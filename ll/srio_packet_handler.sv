////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_packet_handler.sv
// Project :  srio vip
// Purpose :  Packet Handlere
// Author  :  Mobiveil
//
// Decodes the received packets.
// 
//////////////////////////////////////////////////////////////////////////////// 

class srio_packet_handler extends srio_ll_base_generator;

  /// @cond
  `uvm_component_utils(srio_packet_handler)
  /// @endcond

  srio_reg_block srio_reg_model;                               ///< Reg model instance

  uvm_blocking_get_port #(srio_trans) ll_pkt_handler_get_port; ///< TLM connects TL->LL packet handler
  uvm_blocking_put_port #(srio_trans) pkt_handler_put_port;    ///< TLM connects Packet handler-> Response generator
  
  /// @cond
  `uvm_register_cb(srio_packet_handler,srio_ll_callback)       ///< Register LL RX Call back method 
  /// @endcond

  bit [63:0] srio_mem[bit[62:0]];                              ///< Memory array

  extern function new(string name="SRIO_PACKET_HANDLER", uvm_component parent = null); ///< new function
  extern function void build_phase(uvm_phase phase);          ///< build_phase
  extern task run_phase(uvm_phase phase);                     ///< run_phase 
  extern virtual task decode_rx_pkt(srio_trans i_srio_trans); ///< Decodes the received packet
  extern virtual task check_for_reg_access(output bool reg_access);    ///< Check if the received packet intended for register access
  extern virtual task reg_model_access(bool rd ,bit [20:0] reg_offset);///< Task to access the register model
  extern virtual task mem_access(bool rd);                             ///< Implements memory write/read functionality

  virtual task srio_ll_trans_received(ref srio_trans rx_srio_trans);   ///< LL RX call back method
  endtask

endclass: srio_packet_handler

//////////////////////////////////////////////////////////////////////////
/// Name: new \n
/// Description: packet handler's new function \n
/// new
//////////////////////////////////////////////////////////////////////////

function srio_packet_handler::new (string name = "SRIO_PACKET_HANDLER", uvm_component parent = null);
  super.new(name, parent);
  ll_pkt_handler_get_port = new("ll_pkt_handler_get_port",this);
  pkt_handler_put_port = new("pkt_handler_put_port",this);
endfunction: new

//////////////////////////////////////////////////////////////////////////
/// Name: build_phase \n
/// Description: packet handler's build_phase function \n
/// build_phase
//////////////////////////////////////////////////////////////////////////

function void srio_packet_handler::build_phase(uvm_phase phase);
   super.build_phase(phase);
   srio_reg_model = env_config.srio_reg_model_tx;  // Get the handle of BFM's register model
endfunction: build_phase

//////////////////////////////////////////////////////////////////////////
/// Name: run_phase \n
/// Description: packet handler's run_phase function \n
/// run_phase
//////////////////////////////////////////////////////////////////////////

task srio_packet_handler::run_phase(uvm_phase phase);
srio_trans item;
begin
  forever
  begin 
    ll_pkt_handler_get_port.get(item);  // Get packet from TL
    `uvm_do_callbacks(srio_packet_handler,srio_ll_callback,srio_ll_trans_received(item)) // Trigger TL RX call back
    ->ll_config.ll_pkt_received;      // Trigger event to indicate packet received by packet handler
    ll_config.bfm_rx_pkt_cnt++;       // Increment the RX packet count
    decode_rx_pkt(item);              // Call decode_rx for further processing the rx packet
  end
end 
endtask: run_phase

//////////////////////////////////////////////////////////////////////////
/// Name: decode_rx_pkt \n
/// Description: Decode the received packet and checks for register and memory \n
/// access. Sends the packet which require response to response genereator \n
/// decode_rx_pkt
//////////////////////////////////////////////////////////////////////////

task srio_packet_handler::decode_rx_pkt(srio_trans i_srio_trans);
bit [3:0]  ftype;
bit [3:0]  ttype;
bit [20:0] config_offset;
bool reg_access= FALSE; 
begin 
    srio_trans_item = new i_srio_trans;

    ll_common_class.srio_ll_rx_trans = i_srio_trans;
    -> ll_common_class.ll_rx_pkt_received;   // Trigger even which indicate that a RX packet is received
    print_ll_tx_rx(FALSE,srio_trans_item);   // Print the received packet informatin
    ftype = srio_trans_item.ftype;
    ttype = srio_trans_item.ttype;

    if(ftype == TYPE1 && ttype < 4'h3)  // Type 1 GSM packets 
    begin
       mem_access(TRUE);                // memory access 
       pkt_handler_put_port.put(srio_trans_item);  // require response
    end
    if(ftype == TYPE2)   // Type2 
    begin
       if(ttype == NRD)   // Nread can also access registers, check if the address matches LCSBA
          check_for_reg_access(reg_access); 
       if(reg_access == FALSE)   // If not accessing registers, then memory access
         mem_access(TRUE); 
       pkt_handler_put_port.put(srio_trans_item);
    end
    if(ftype == TYPE5)  // Type5 
    begin
       if(ttype == NWR_R) // Nwrite_R can access registers also
          check_for_reg_access(reg_access); 
       if(reg_access == FALSE) 
         mem_access(FALSE);
       if(ttype < 2 || ttype == 4'h5 || ttype > 4'hB)  // Type5 GSM, Nwrite_r and Atomic packets require response
         pkt_handler_put_port.put(srio_trans_item);
    end
    if(ftype == TYPE6)  // Type6 
       mem_access(FALSE);
    if(ftype == TYPE8) // Type8
    begin
      config_offset = srio_trans_item.config_offset;  // Get the register config offset
      if(ttype == MAINT_RD_REQ)     // Maintenance read, read from register
        reg_model_access(TRUE,config_offset); 
      if(ttype == MAINT_WR_REQ)    // Maintenance write, Write data to register
        reg_model_access(FALSE,config_offset); 
      if(ttype < 4'h2)
        pkt_handler_put_port.put(srio_trans_item);
    end
    if(ftype == TYPE10|| ftype == TYPE11)   // MSG or DB 
    begin
        srio_trans_item.print();
        pkt_handler_put_port.put(srio_trans_item);
    end
  end 
endtask: decode_rx_pkt

//////////////////////////////////////////////////////////////////////////
/// Name: check_for_reg_access \n
/// Description: Nread and Nwrite_r packets can also access registers if the \n
/// address in those packets matches the valus programmed in LCSBA registers.\n
/// This task checks and confirms if NREAD/NWRITE_R access registers or meomory \n
/// check_for_reg_access
//////////////////////////////////////////////////////////////////////////

task srio_packet_handler::check_for_reg_access(output bool reg_access);
dut_address_mode addr_mode_dut;
bit [31:0] reg_read_data;
bit [31:0] reg_write_data;
bit [31:0] LCSBA0_data;
bit [31:0] LCSBA1_data;
bit [31:0] LCSBA0_data_rev;
bit [31:0] LCSBA1_data_rev;
bit [65:0] base_addr;
bit [65:0] base_limit;
bit [65:0] trans_addr;
bit [20:0] reg_offset;
bool       rd;
begin
  reg_access = FALSE;
  rd = FALSE;
  // Check packet is NREAD or NWRITE_R
  if((srio_trans_item.ftype == TYPE2 && srio_trans_item.ttype == NRD) || (srio_trans_item.ftype == TYPE5 && srio_trans_item.ttype == NWR_R))
  begin   
    if(srio_trans_item.ftype == TYPE2)
      rd = TRUE;     // NREAD , read access
    else    
      rd = FALSE;    // NWRITE_T , write access
    // Get the address mode 34 bit, 50 bit or 66 bit addressing
    reg_read_data = srio_reg_model.Processing_Element_Logical_Layer_Control_CSR.get();
    if(reg_read_data[31:29] == 3'b100)
    begin //{
      addr_mode_dut = DUT_SRIO_ADDR_34;
    end //}
    else if(reg_read_data[31:29] == 3'b010)
    begin //{
      addr_mode_dut = DUT_SRIO_ADDR_50;
    end //}
    else
    begin //{
      addr_mode_dut = DUT_SRIO_ADDR_66;
    end //}
    
    //  Get the values from LCSBA Registers
    LCSBA0_data = srio_reg_model.Local_Configuration_Space_Base_Address_0_CSR.get();
    LCSBA1_data = srio_reg_model.Local_Configuration_Space_Base_Address_1_CSR.get();

    for(int i=0; i<32; i++)
    begin //{
      LCSBA0_data_rev[31-i] = LCSBA0_data[i];
      LCSBA1_data_rev[31-i] = LCSBA1_data[i];
    end //}

    // Form the address calculation based on the address mode
    if(addr_mode_dut == DUT_SRIO_ADDR_34)
    begin //{
      base_addr  = {LCSBA1_data_rev[30:1], 1'b0, 3'b000};
      base_limit = base_addr + env_config.reg_space_size;
      trans_addr = {srio_trans_item.xamsbs, srio_trans_item.address, 3'b000};
    end //}
    else if(addr_mode_dut == DUT_SRIO_ADDR_50)
    begin //{
      base_addr  = {LCSBA0_data_rev[14:0], LCSBA1_data_rev[31:0], 3'b000};
      base_limit = base_addr + env_config.reg_space_size;
      trans_addr = { srio_trans_item.xamsbs, srio_trans_item.ext_address[15:0], srio_trans_item.address, 3'b000};
    end //}
    else //DUT_SRIO_ADDR_66
    begin //{
      base_addr  = {LCSBA0_data_rev[30:0], LCSBA1_data_rev[31:0], 3'b000};
      base_limit = base_addr + env_config.reg_space_size;
      trans_addr = { srio_trans_item.xamsbs, srio_trans_item.ext_address, srio_trans_item.address, 3'b000};
    end //}

    // check if NWRITE_R and NREAD are accessing register address ranges
    if(trans_addr >= base_addr && trans_addr <= base_limit)
    begin //{
      reg_access = TRUE;
      reg_offset = trans_addr[20:0];
      reg_model_access(rd,reg_offset); 
    end     
  end     
end
endtask: check_for_reg_access

//////////////////////////////////////////////////////////////////////////
/// Name: reg_model_access \n
/// Description: Handles reading from and writing into register model using the \n  
/// config offset value. Register model is implemented in Little Endian \n
/// format.Where as RIO is Big Endian.So need to swap the data. \n
/// reg_model_access
//////////////////////////////////////////////////////////////////////////

task srio_packet_handler::reg_model_access(bool rd ,bit [20:0] reg_offset);
bit [31:0] reg_write_data;
bit [7:0]  payload[$];
bit [0:7]  tmp_swap; 
bit        reg_status;
int        byte_cnt;
int        act_byte_cnt;
bit [7:0]  byte_en; 

uvm_reg           rg;
uvm_reg_data_t    rd_wr_data;
uvm_reg_byte_en_t rd_wr_byte_en;
begin
  
   payload.delete();
   if(rd)  // Register Read
   begin   // findout the byte en, byte cnt and actual cnt passing wdptr ans rdsize fields 
     get_byte_cnt_en(srio_trans_item.wdptr,srio_trans_item.rdsize,byte_cnt,byte_en,act_byte_cnt);
     if(byte_cnt != 0 && byte_en != 0) 
     begin
       for(int i = 0; i < byte_cnt/4; i++)
       begin
          rg = srio_reg_model.srio_reg_block_map.get_reg_by_offset(reg_offset+(i*4)); // Instance of the register matching config offset value
          if(rg != null)
          begin
            //rd_wr_byte_en = (i%2)? {4'h0,{byte_en[0],byte_en[1],byte_en[2],byte_en[3]}} : {4'h0,{byte_en[4],byte_en[5],byte_en[6],byte_en[7]}};  
            //reg_status = rg.predict(rd_wr_data,rd_wr_byte_en,UVM_PREDICT_READ,,,,);
            rd_wr_data = rg.get();  // Get register data in little endian format
          end 
          else 
            rd_wr_data = 0;
          for(int cnt=0; cnt<=3; cnt++)   // convert to big endian format
          begin
             for(int bit_cnt = 0; bit_cnt < 8; bit_cnt++)
              tmp_swap[7-bit_cnt] = rd_wr_data[31-bit_cnt];
             payload[(i*4)+cnt] = tmp_swap;   
             rd_wr_data = rd_wr_data << 8;
          end                       
       end
         srio_trans_item.payload = payload;   // store the read data to the transation
     end 
   end
   else begin   // Register Write
      payload = srio_trans_item.payload;
      // findout the byte en, byte cnt and actual cnt passing wdptr ans wrsize fields 
      get_byte_cnt_en(srio_trans_item.wdptr,srio_trans_item.wrsize,byte_cnt,byte_en,act_byte_cnt);
      if(byte_cnt != 0 && byte_en != 0 && payload.size() <= byte_cnt && payload.size() % 8 == 0) 
      begin
        for(int i = 0; i < payload.size()/4; i++) 
        begin
          rg = srio_reg_model.srio_reg_block_map.get_reg_by_offset(reg_offset+(i*4)); 
          rd_wr_byte_en = (i%2)? {4'h0,{byte_en[3],byte_en[2],byte_en[1],byte_en[0]}} : {4'h0,{byte_en[7],byte_en[6],byte_en[5],byte_en[4]}};  
          rd_wr_data = 0;
          for(int cnt = 0; cnt <=3; cnt ++)
          begin                      // Convert to little endian format
            rd_wr_data = rd_wr_data << 8;  
            tmp_swap = payload[(i*4)+cnt];
            for(int bit_cnt = 0; bit_cnt < 8; bit_cnt++)
             rd_wr_data[bit_cnt] = tmp_swap[bit_cnt];
          end
          if(rg != null)
          begin  
            reg_status = rg.predict(rd_wr_data,rd_wr_byte_en,UVM_PREDICT_WRITE,,,,); // Update the value in to register
          end 
        end   
      end     
   end 
end
endtask: reg_model_access

//////////////////////////////////////////////////////////////////////////
/// Name: mem_access \n
/// Description: Handles reading from and writing into memory model using the \n  
/// address value. Memory model is a sparse array.\n
/// mem_access
//////////////////////////////////////////////////////////////////////////

task srio_packet_handler::mem_access(bool rd);
bit [65:0] addr;
bit [7:0] payload[$];
bit [2:0] be_cnt;
bit [3:0] ftype;
bit [3:0] ttype;
bit [0:7] byte_en_r;
bit [2:0] f_byte;
bit [63:0] tmp_data;
int        byte_cnt;
int        act_byte_cnt;
bit [7:0]  byte_en; 
begin
   ftype = srio_trans_item.ftype;
   ttype = srio_trans_item.ttype;
   addr = {srio_trans_item.xamsbs,srio_trans_item.ext_address,srio_trans_item.address,3'b000};
   addr = addr/8;
   payload.delete();
   if(rd)  // Read from memory
   begin
      // findout the byte en, byte cnt and actual cnt passing wdptr ans rdsize fields 
     get_byte_cnt_en(srio_trans_item.wdptr,srio_trans_item.rdsize,byte_cnt,byte_en,act_byte_cnt);
     byte_en_r = byte_en;
     for(int cnt = 0; cnt < 8; cnt++) 
     begin
         if(byte_en_r[cnt])
         begin
           f_byte = cnt;
           break;
         end
     end 
     for(int cnt = 0; cnt < byte_cnt/8; cnt++)   // Read data from memory
     begin
        if(srio_mem.num() > 0 && srio_mem.exists(addr+cnt))
        begin
          tmp_data = srio_mem[addr+cnt];
        end
        else begin
          tmp_data = $random;
        end
        for(int cnt1 = 0; cnt1 < 8; cnt1++)
        begin
           payload[(cnt*8)+cnt1] = tmp_data[7:0];
           tmp_data = tmp_data >> 8; 
        end
     end
     srio_trans_item.payload = payload;
     payload.delete();
     if(ftype == TYPE2 && (ttype == ATO_INC || ttype == ATO_DEC || ttype == ATO_SET || ttype == ATO_CLR))
     begin   // Type2 Atomic transactions modify the memory
        if(srio_mem.num() > 0 && srio_mem.exists(addr))
        begin
          tmp_data = srio_mem[addr];
        end
        else begin
          tmp_data = $random;
        end
        payload[0] = tmp_data[7:0]; payload[1] = tmp_data[15:8]; payload[2] = tmp_data[23:16]; 
        payload[3] = tmp_data[31:24]; payload[4] = tmp_data[39:32]; payload[5] = tmp_data[47:40]; 
        payload[6] = tmp_data[55:48]; payload[7] = tmp_data[63:56]; 
        tmp_data = tmp_data >> f_byte*8; 
        case(ttype)
           ATO_INC:begin
                  tmp_data++; 
                end
           ATO_DEC:begin
                  tmp_data--; 
                end
           ATO_SET:begin
                  tmp_data = {64{1'b1}}; 
                end
           ATO_CLR:begin
                  tmp_data = {64{1'b0}}; 
                end
        endcase
        for(int cnt = 0; cnt < 8; cnt++)
        begin
           if(cnt >= f_byte && cnt < (act_byte_cnt + f_byte))
           begin
             payload[cnt] = tmp_data[7:0];
             tmp_data = tmp_data >> 8;           
           end
        end  
        srio_mem[addr] =  {payload[7],payload[6],payload[5],payload[4],payload[3],payload[2],payload[1],payload[0]};
     end   
   end
   else begin
      // findout the byte en, byte cnt and actual cnt passing wdptr ans wrsize fields 
     get_byte_cnt_en(srio_trans_item.wdptr,srio_trans_item.wrsize,byte_cnt,byte_en,act_byte_cnt);
     byte_en_r = byte_en;
     payload = srio_trans_item.payload;
     if(srio_mem.num() > 0 && srio_mem.exists(addr))
     begin
       tmp_data = srio_mem[addr];
     end
     else begin
       tmp_data = $random;
     end
     if(ftype == TYPE5 && (ttype == ATO_SWAP || ttype == ATO_COMP_SWAP || ttype == ATO_TEST_SWAP))
     begin   // Type5 Atomic transactios write in to memory and read from memory
       case(ttype)
           ATO_SWAP:begin
                  srio_mem[addr] =  {payload[7],payload[6],payload[5],payload[4],payload[3],payload[2],payload[1],payload[0]};
                end
           ATO_COMP_SWAP:begin
                  if(tmp_data ==  {payload[7],payload[6],payload[5],payload[4],payload[3],payload[2],payload[1],payload[0]})
                    srio_mem[addr] =  {payload[15],payload[14],payload[13],payload[12],payload[11],payload[10],payload[9],payload[8]};
                end
           ATO_TEST_SWAP:begin
                  if(tmp_data ==  64'h0)
                    srio_mem[addr] =  {payload[7],payload[6],payload[5],payload[4],payload[3],payload[2],payload[1],payload[0]};
                end
       endcase
       payload.delete(); 
       for(int cnt = 0; cnt < 8; cnt++)
       begin 
         payload[cnt] = tmp_data[7:0];
         tmp_data = tmp_data >> 8; 
       end
       if(ttype == ATO_COMP_SWAP)
       begin
         tmp_data = srio_mem[addr];
         for(int cnt = 0; cnt < 8; cnt++)
         begin 
           payload[8+cnt] = tmp_data[7:0];
           tmp_data = tmp_data >> 8; 
         end
       end
       srio_trans_item.payload = payload;  
     end
     else begin
       for(int sen =0; sen < payload.size(); sen++)
       srio_trans_item.payload.delete();
       if(ftype == TYPE6)
       begin
         byte_cnt = payload.size();byte_en_r = 8'hFF;
       end 
       for(int cnt = 0; cnt < byte_cnt/8; cnt++)
       begin
         for(int cnt1 = 0; cnt1 < 8; cnt1++)
         begin 
           tmp_data = tmp_data >> 8;
           if(byte_en_r[cnt1])
             tmp_data[63:56] = payload[(cnt*8)+cnt1]; 
            else
             tmp_data[63:56] = 0; 
         end
         srio_mem[addr+cnt] = tmp_data;
       end
     end
   end
end
endtask: mem_access
