////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_io_generator.sv
// Project :  srio vip
// Purpose :  IO Packet Generation
// Author  :  Mobiveil
//
// This components handles the generation of IO packets.
// Extended from srio_ll_base_generator
//////////////////////////////////////////////////////////////////////////////// 

class srio_io_generator extends srio_ll_base_generator;
  /// @cond
  `uvm_component_utils(srio_io_generator)
  /// @endcond

  srio_trans io_pkt_q[$];       ///< Generated IO packets are store in this queue
  srio_trans io_tid_q[$];       ///< Packets waiting for TID values are stored in thus queue
  srio_trans out_tid_q[int];    ///< Stores the TIDs occupied by IO packets(Outstanding)
 
  extern function new(string name="SRIO_IO_GENERATOR", uvm_component parent = null); ///< new function
  extern task run_phase(uvm_phase phase);        ///< run phase
  extern virtual task generate_io_pkt();         ///< Generates IO packets
  extern virtual task inject_err();              ///< Task injects IO related error
  extern virtual task io_resp_chk();             ///< Checks responses and clears srcTID
  extern virtual task io_resp_timeout();         ///< Response timeout logic
  extern virtual task push_pkt(srio_trans i_srio_trans);  ///< Receives packets from sequence  
  extern virtual task get_next_pkt(bit[2:0] sub_type,bit[31:0] tx_pkt_id,output bool pkt_valid,output srio_trans o_srio_trans);
                                                      ///< Provides the the packet to packet scheduler
  
endclass: srio_io_generator

//////////////////////////////////////////////////////////////////////////
/// Name: new \n
/// Description: IO generator's new function \n
/// new
//////////////////////////////////////////////////////////////////////////

function srio_io_generator::new(string name="SRIO_IO_GENERATOR", uvm_component parent=null);
  super.new(name, parent);
endfunction: new

//////////////////////////////////////////////////////////////////////////
/// Name: run_phase \n
/// Description: IO generator's run_phase function \n
/// run_phase
//////////////////////////////////////////////////////////////////////////

task srio_io_generator::run_phase(uvm_phase phase);
begin
   fork
     generate_io_pkt;    
     io_resp_chk;        
     io_resp_timeout;
   join_none
end
endtask: run_phase

//////////////////////////////////////////////////////////////////////////
/// Name: push_pkt \n
/// Description: Called by logic trans generator when IO packet is \n
/// received from sequence. just stores the packet to tid queue  
/// push_pkt
//////////////////////////////////////////////////////////////////////////

task srio_io_generator::push_pkt(srio_trans i_srio_trans);
begin 
   io_tid_q.push_back(i_srio_trans);
end 
endtask: push_pkt

//////////////////////////////////////////////////////////////////////////
/// Name: generate_io_pkt \n
/// Description: generates IO packets.User generated packets will not be \n
/// modified and directly considered for transmission.Non user packts,Only \n
/// the payload is generated.Valid values for other fields are \n
/// already constrained in srio_trans. Waits for TID to be available.\n
/// generate_io_pkt
//////////////////////////////////////////////////////////////////////////

task srio_io_generator::generate_io_pkt;
bit [3:0]    ftype;        
bit [3:0]    ttype;        
bit [7:0]    byte_en;
bit [7:0]    payload[$];
integer      byte_cnt;
integer      act_byte_cnt;
begin 
  forever
  begin
    wait(io_tid_q.size() > 0);                  // Wait for io_tid_q to have packets from sequence
    srio_trans_item = new io_tid_q.pop_front();
    ftype = srio_trans_item.ftype;
    ttype = srio_trans_item.ttype;
    if(srio_trans_item.usr_gen_pkt == 0)        // If user has already not generated
    begin
      if(ftype == TYPE2 || (ftype == TYPE5 &&  (ttype == NWR_R || ttype > 4'hB)) ||  // IO Packets that require response
            (ftype == TYPE8 && (ttype == MAINT_RD_REQ || ttype == MAINT_WR_REQ)))
      begin
        ll_common_class.get_next_tid(srio_trans_item.SrcTID);                        // Wait and get the TID which is not in use
      end 
      payload.delete();
      if(ftype == TYPE6 || (ftype == TYPE5 && (ttype == NWR || ttype == NWR_R ||    // Generate payload for the IO packets which require
             ttype == ATO_SWAP || ttype == ATO_COMP_SWAP || ttype == ATO_TEST_SWAP)) ||
        (ftype == TYPE8 && (ttype == MAINT_WR_REQ || ttype == MAINT_PORT_WR_REQ)))
      begin
          get_byte_cnt_en(srio_trans_item.wdptr,srio_trans_item.wrsize,byte_cnt,byte_en,act_byte_cnt); // Get the payload cnt value using wdprt,wrsize
          for(int cnt=0;cnt<byte_cnt;cnt++)
             payload.push_back($urandom_range('hFF,'h0));
          srio_trans_item.payload = payload;    
      end 
    end 
    out_tid_q[srio_trans_item.SrcTID] = srio_trans_item;        // To track the TIDs used by IO packets 
    inject_err;                                                 // Inject error if configured before transmitting to TL
    srio_trans_item.ll_rd_cnter = 0;                            // Resp timeout counter initialized to 0;
    ll_common_class.get_next_pkt_id(srio_trans_item.ll_pkt_id); // Assign packet id
    io_pkt_q.push_back(srio_trans_item);
    ll_common_class.pkt_cnt_update(TRUE);                       // Increment the total packt count value 
  end
end 
endtask: generate_io_pkt

//////////////////////////////////////////////////////////////////////////
/// Name: get_next_pkt \n
/// Description: Called by packet scheduler , provides the IO packet if \n
/// available in the queue.If packet is present returns pkt_valid as TRUE \n
/// Uses tx_pkt_id to search for the matching packet from queue in \n
/// non-interleaved mode.In interleaved mode,picks top most packet \n
/// from the queue.\n
/// get_next_pkt
//////////////////////////////////////////////////////////////////////////

task srio_io_generator::get_next_pkt(bit[2:0] sub_type,bit [31:0] tx_pkt_id,output bool pkt_valid,output srio_trans o_srio_trans);
integer tmp_cnt;
bool    id_match;
begin
   pkt_valid = FALSE;
   id_match  = FALSE;
   tmp_cnt = 0;
   
   if(io_pkt_q.size() > 0)             // Check the queue size to know if packet is available to transfer    
   begin
      if(ll_config.interleaved_pkt)   // If interleaved is TRUE, pop the top packet    
      begin
        pkt_valid = TRUE;             // pkt_valid is set to TRUE if packet is available for transmission
        o_srio_trans = io_pkt_q.pop_front();  
      end else
      begin
         while(id_match == FALSE && tmp_cnt < io_pkt_q.size())  // Search for the packet with id matching the value
         begin                                                  // requested by scheduler
            if(io_pkt_q[tmp_cnt].ll_pkt_id == tx_pkt_id)
              id_match = TRUE;
            else
              tmp_cnt++;
         end
         if(id_match)                               // If packet is matches,send out that packet and delete from queue
         begin
            pkt_valid = TRUE;
            o_srio_trans = io_pkt_q[tmp_cnt];
            io_pkt_q.delete(tmp_cnt); 
         end 
      end
      if(pkt_valid)
        ll_common_class.pkt_cnt_update(FALSE);    // decrement the packet counter
   end
end
endtask: get_next_pkt

//////////////////////////////////////////////////////////////////////////
/// Name: inject_err \n
/// Description: Injects IO packet error based on the error kind \n
/// User also can inject error in the packet in sequence and \n
/// set the user_gen_pkt to 1. \n
/// inject_err
//////////////////////////////////////////////////////////////////////////

task srio_io_generator::inject_err;
begin
  case(srio_trans_item.ll_err_kind)
    MAX_SIZE_ERR:begin   // payload more than max payload size
                   for(int cnt = srio_trans_item.payload.size()-1; cnt < 264; cnt++)
                     srio_trans_item.payload.push_back(cnt);  
                 end
    FTYPE_ERR: begin  // Invalid FTYPE
                 srio_trans_item.ftype = 4'hF;
               end
    TTYPE_ERR:begin  // Invalid TTYPE
                if(srio_trans_item.ftype == 4'h5)
                  srio_trans_item.ttype = 4'hF; 
                if(srio_trans_item.ftype == 4'h8)
                  srio_trans_item.ttype = 4'hA; 
              end 
    PAYLOAD_ERR:begin  // Payload more than the actual count
                   for(int cnt = 0; cnt < 8; cnt++)
                     srio_trans_item.payload.push_back(cnt);  
                end
    SIZE_ERR:begin   // Invalid wdptr and wr/rd size
                srio_trans_item.wdptr = ~srio_trans_item.wdptr; 
                srio_trans_item.rdsize = ~srio_trans_item.rdsize;
                srio_trans_item.wrsize = ~srio_trans_item.wrsize;
             end 
    PAYLOAD_EXIST_ERR:begin // Not supposed to have payload, including payload
                     for(int cnt = 0; cnt < 8; cnt++)
                       srio_trans_item.payload.push_back(cnt);  
                   end    
    NO_PAYLOAD_ERR:begin   // Payload supposed to be present, deleting it
                        srio_trans_item.payload.delete(); 
                      end 
    DW_ALIGN_ERR:begin   // DW align error
                     for(int cnt = 0; cnt < 4; cnt++)
                       srio_trans_item.payload.push_back(cnt);  
                 end
    ATAS_PAYLOAD_ERR,
    ACAS_PAYLOAD_ERR, 
    AS_PAYLOAD_ERR:begin  // Payload Error specific to ATOMIC packets
                     srio_trans_item.wdptr = 1'b0;
                     srio_trans_item.wrsize = 4'b1100;
                     srio_trans_item.payload.delete();  
                     for(int cnt = 0; cnt < 32; cnt++)
                       srio_trans_item.payload.push_back(cnt);  
                   end  
  endcase 
end
endtask: inject_err

//////////////////////////////////////////////////////////////////////////
/// Name: io_resp_chk \n
/// Description: Compared the received target TID from received response \n
/// with the TIDs in oustanding queue. If there is a match,frees the TID.\n 
/// io_resp_chk
//////////////////////////////////////////////////////////////////////////

task srio_io_generator::io_resp_chk;
bit [7:0] resp_tgtid;
bit [3:0] resp_ttype;
srio_trans srio_rx_trans;
begin
  forever
  begin 
    @(ll_common_class.ll_rx_pkt_received);                // Wait for packet to be received by RX logic
    srio_rx_trans = new ll_common_class.srio_ll_rx_trans; // Copy the received packet
    if(srio_rx_trans.ftype == TYPE13)                     // If completion packet
    begin
      resp_tgtid   = srio_rx_trans.targetID_Info;
      resp_ttype   = srio_rx_trans.ttype;
      if(out_tid_q.exists(resp_tgtid) && resp_ttype != MSG_RES)                   // Check if TID matches with any of the packet
      begin                                               // from the queue
        out_tid_q.delete(resp_tgtid);                     // Delete from the queue 
        ll_common_class.update_tid(resp_tgtid);           // Free the TID
      end
    end
  end
end 
endtask: io_resp_chk

//////////////////////////////////////////////////////////////////////////
/// Name: io_resp_timeout \n
/// Description: Handled the response timeout mechanism for IO packets. \n
/// Timeout counter of each outstanding packet is incremented for every 1ns.\n 
/// When matches with the timeout value configured in LL config,packet \n
/// is removed from the queue and TID is made available.\n
/// io_resp_chk
//////////////////////////////////////////////////////////////////////////

task srio_io_generator::io_resp_timeout;
int first_index;
int last_index;
begin
  forever
  begin 
    #1ns;
    first_index = 0;
    last_index  = 0; 
    void'(out_tid_q.first(first_index));                  // First index of the array 
    void'(out_tid_q.last(last_index));                    // Last indes of the array
    for(int cnt = first_index; cnt <= last_index; cnt++)  
    begin
      if(out_tid_q.num() > 0 && out_tid_q.exists(cnt))    // Check each index, if packet is present
      begin
       out_tid_q[cnt].ll_rd_cnter++;                      // increment the response timeout counter 
        if(out_tid_q[cnt].ll_rd_cnter >= ll_config.ll_resp_timeout)
        begin
           out_tid_q.delete(cnt);                         // If matches with the timeout value,delete the packet
           ll_common_class.update_tid(cnt);               // Free the TID
        end  
      end
    end
  end
end
endtask: io_resp_timeout
