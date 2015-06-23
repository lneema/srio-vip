////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_bfm.sv
// Project :  srio vip
// Purpose :  Physical Layer Driver 
// Author  :  Mobiveil
//
// Physical Layer Driver component.
//
////////////////////////////////////////////////////////////////////////////////  
  
// class declaration
 class srio_pl_bfm extends uvm_driver #(srio_trans);

  /// @cond
 `uvm_component_utils(srio_pl_bfm)
  /// @endcond

 `uvm_register_cb(srio_pl_bfm, srio_pl_callback)	///< Registering PL callback

 virtual srio_interface srio_if;                        ///< Virtual interface 

  srio_env_config pl_env_config;                       ///< ENV config instance 

 srio_pl_config  pl_config;                            ///< PL config instance     

 srio_pl_idle_gen idle_gen;                            ///< Idle Gen instance

 srio_pl_lane_driver lane_driver_ins[int];             ///<Lane driver array instance 

 srio_pl_common_component_trans driver_trans;          ///< PL common transaction instance

  srio_pl_lane_handler lane_handle_ins[int];           ///< PL Lane handler array instance

  srio_2x_align_data x2_align_data_ins;                 ///<Align data instance for laign S/M for X2   
  srio_nx_align_data nx_align_data_ins;                 ///<Align data instance for laign S/M for NX

  srio_pl_rx_data_handler srio_pl_rx_data_handle_ins;   ///< PL RX data handler instance

  srio_pl_state_machine srio_pl_sm_ins;                 ///< PL state machine instance

  srio_pl_pktcs_merger srio_pktcs_merge_ins;            ///< PL Packet/Control Symbol merger instance

  srio_pl_pkt_handler  srio_pkt_handler_ins;            ///< PL RX Packet Handler Instance

  bit bfm_or_mon;                                       ///< Indicator for active or passive component

  srio_trans srio_trans_item,item,temp_trans,temp_trans1; ///< Transaction item instances

  bit xmt_my_cmd_rcvd;                                  ///< Change my Transmit width command received
  bit xmt_lp_cmd_rcvd;                                  ///< Change Link Partner Transmit Width Request Received
  uvm_event srio_tx_pkt_event;                          ///< Event to be triggered when packet/control symbol is to be tranmsitted

  uvm_event srio_tx_lane_event[int];                    ///< Event to trigger transmission on lane
  uvm_event srio_rx_lane_event[int];                    ///< Event to be triggered when data is received on a lane 

  uvm_blocking_put_port #(srio_trans) pl_drv_put_port;  ///< Port to put item received to the higher layer
  uvm_get_port #(srio_trans) pl_drv_get_port;           ///< Port to get item to be transmitted 

 logic [5:0] ackid ;

 bit          seq_flag;
 
 bit          packet_open;
  
 bit          set_delimiter;

 byte unsigned bytestream[];
 int bytestream_size;
 bit block_pkt; 
 srio_trans ackid_pkt_trans;

 extern function new(string name = "srio_pl_bfm", uvm_component parent = null);
 extern function void build_phase(uvm_phase phase);
 extern function void connect_phase(uvm_phase phase);
 extern task run_phase(uvm_phase phase);
 extern task pl_pkt_gen(srio_trans srio_trans_item_ip);
 extern task inc_ackid();
 extern task initialize();
 extern task gen_xmt_cmd();  
 extern task xmt_timer_method();
 extern task tb_reset_ackid();
 extern task pl_pkt_delay(srio_trans srio_trans_item_ip); 
 extern task pl_pkt_gen_txrx(srio_trans srio_trans_item_ip);

 virtual task srio_pl_trans_generated(ref srio_trans tx_srio_trans);
 endtask 

 endclass : srio_pl_bfm

///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : New
/// Description : Constructor method for srio_pl_bfm class.
///////////////////////////////////////////////////////////////////////////////////////////////
 function srio_pl_bfm::new(string name = "srio_pl_bfm", uvm_component parent = null);
  super.new(name, parent);
  pl_drv_put_port = new("pl_drv_put_port", this);
  pl_drv_get_port = new("pl_drv_get_port", this);
 endfunction
 
///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : build_phase
/// Description : build_phase method for srio_pl_bfm class.
/// In this all the config varibales are got and connection between different classes are made
///////////////////////////////////////////////////////////////////////////////////////////////
 function void srio_pl_bfm::build_phase(uvm_phase phase);
   super.build_phase(phase);
  if (!uvm_config_db #(srio_pl_config)::get(this, "", "pl_config", pl_config)) // get config object
   `uvm_fatal("Config Fatal", "Can't get the pl_config")

   if (!uvm_config_db #(srio_pl_common_component_trans)::get(this, "", "pl_com_bfm_trans", driver_trans))
    `uvm_fatal("CONFIG_LOAD", "Cannot get() PL COMMON BFM TRANS HANDLE")

  if (!uvm_config_db #(srio_env_config)::get(this, "", "srio_env_config", pl_env_config))
    `uvm_fatal("CONFIG_LOAD", "Cannot get() ENV CONFIG HANDLE")

  idle_gen = srio_pl_idle_gen::type_id::create("idle_gen",this);
  srio_pktcs_merge_ins = srio_pl_pktcs_merger::type_id::create("srio_pktcs_merge_ins",this);
  srio_pkt_handler_ins = srio_pl_pkt_handler::type_id::create("srio_pkt_handler_ins",this);
  srio_tx_pkt_event = new();
  for (int num_ln=0; num_ln<pl_env_config.num_of_lanes; num_ln++)
  begin //{ 
  srio_tx_lane_event[num_ln] = new();
  end //}
  for (int num_ln=0; num_ln<pl_env_config.num_of_lanes; num_ln++)
  begin //{
    lane_driver_ins[num_ln] = srio_pl_lane_driver::type_id::create($sformatf("pl_lane_driver[%0d]", num_ln), this);
//    lane_driver_ins[num_ln].srio_tx_lane_event = new();
  end //}

  if (!uvm_config_db #(bit)::get(this, "", "bfm_or_mon", bfm_or_mon))
    `uvm_fatal("CONFIG_LOAD", "Cannot get() bfm_or_mon Value")

  for (int num_ln=0; num_ln<pl_env_config.num_of_lanes; num_ln++)
  begin //{
    lane_handle_ins[num_ln] = srio_pl_lane_handler::type_id::create($sformatf("pl_lane_handler[%0d]", num_ln), this);
    srio_rx_lane_event[num_ln] = new();

  end //}

  x2_align_data_ins = srio_2x_align_data::type_id::create("pl_2x_align_data", this);
  nx_align_data_ins = srio_nx_align_data::type_id::create("pl_nx_align_data", this);

  srio_pl_rx_data_handle_ins = srio_pl_rx_data_handler::type_id::create("pl_rx_data_handle", this);

  srio_pl_sm_ins = srio_pl_state_machine::type_id::create("pl_sm_handle", this);

  srio_trans_item = srio_trans::type_id::create("srio_trans_item",this);

 endfunction : build_phase

////////////////////////////////////////////////////////////////////////////////
/// Name: connect_phase \n
/// Description: PL BFM's connect_phase function \n
////////////////////////////////////////////////////////////////////////////////
 function void srio_pl_bfm::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    srio_if = pl_config.srio_if; // set local virtual if property
    idle_gen.env_config = pl_env_config;
    idle_gen.idle_config = pl_config;
    idle_gen.srio_if = pl_config.srio_if;
    idle_gen.idle_trans = driver_trans;
    idle_gen.pktcs_merge_ins = srio_pktcs_merge_ins;
    idle_gen.pkt_handler_ins = srio_pkt_handler_ins;

    srio_pktcs_merge_ins.pktm_config = pl_config;
    srio_pktcs_merge_ins.srio_if = pl_config.srio_if;
    srio_pktcs_merge_ins.pktm_trans = driver_trans;
    srio_pktcs_merge_ins.pkt_handler_ins = srio_pkt_handler_ins;
    srio_pktcs_merge_ins.pktm_env_config = pl_env_config;

    srio_pkt_handler_ins.pkth_config = pl_config;
    srio_pkt_handler_ins.srio_if = pl_config.srio_if;
    srio_pkt_handler_ins.common_com_trans = driver_trans;
    srio_pkt_handler_ins.pkt_merge_ins = srio_pktcs_merge_ins;
    srio_pkt_handler_ins.handler_env_config = pl_env_config;

    srio_pkt_handler_ins.pl_handler_gen_put_port.connect(pl_drv_put_port);

    for (int lane_num=0; lane_num<pl_env_config.num_of_lanes; lane_num++)
    begin //{
       idle_gen.srio_tx_lane_event[lane_num]  = srio_tx_lane_event[lane_num];
    end //}
    for (int lane_num=0; lane_num<pl_env_config.num_of_lanes; lane_num++)
    begin //{
    lane_driver_ins[lane_num].srio_if = srio_if;
    lane_driver_ins[lane_num].ld_config = pl_config;
    lane_driver_ins[lane_num].ld_trans = driver_trans;
    lane_driver_ins[lane_num].lane_num = lane_num;
    lane_driver_ins[lane_num].srio_tx_lane_event = srio_tx_lane_event[lane_num];
    lane_driver_ins[lane_num].ld_env_config = pl_env_config;
    end //}

    srio_pktcs_merge_ins.srio_tx_pkt_event = srio_tx_pkt_event;

 // Lane handler instance connections.

  for (int num_ln=0; num_ln<pl_env_config.num_of_lanes; num_ln++)
  begin //{
    lane_handle_ins[num_ln].srio_if = srio_if;
    lane_handle_ins[num_ln].lh_env_config = pl_env_config;
    lane_handle_ins[num_ln].lh_config = pl_config;
    lane_handle_ins[num_ln].lh_trans = driver_trans;
    lane_handle_ins[num_ln].bfm_or_mon = bfm_or_mon;
    lane_handle_ins[num_ln].lane_num = num_ln;

    lane_handle_ins[num_ln].srio_rx_lane_event = srio_rx_lane_event[num_ln];
  end //}


  // Rx Data handler instance connections.

  srio_pl_rx_data_handle_ins.srio_if = srio_if;
  srio_pl_rx_data_handle_ins.rx_dh_env_config = pl_env_config;
  srio_pl_rx_data_handle_ins.rx_dh_config = pl_config;
  srio_pl_rx_data_handle_ins.rx_dh_trans = driver_trans;
  srio_pl_rx_data_handle_ins.bfm_or_mon = bfm_or_mon;
  srio_pl_rx_data_handle_ins.x2_align_data = x2_align_data_ins;
  srio_pl_rx_data_handle_ins.nx_align_data = nx_align_data_ins;

  for (int num_ln=0; num_ln<pl_env_config.num_of_lanes; num_ln++)
    srio_pl_rx_data_handle_ins.srio_rx_lane_event[num_ln] = srio_rx_lane_event[num_ln];

  srio_pl_sm_ins.srio_if = srio_if;
  srio_pl_sm_ins.pl_sm_env_config = pl_env_config;
  srio_pl_sm_ins.pl_sm_config = pl_config;
  srio_pl_sm_ins.pl_sm_trans = driver_trans;
  srio_pl_sm_ins.bfm_or_mon = bfm_or_mon;
  srio_pl_sm_ins.pl_sm_x2_align_data = x2_align_data_ins;
  srio_pl_sm_ins.pl_sm_nx_align_data = nx_align_data_ins;

 endfunction : connect_phase

///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : initialiaze
/// Description : Initializing the variables used 
///////////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_bfm::initialize();
    driver_trans.curr_tx_ackid = 0;
    seq_flag = 0;
 endtask : initialize


///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : run_phase
/// Description : run_phase method of srio_pl_bfm class.
/// It triggers all the methods within the class which needs to be run forever.
/// It receives the packets and control symbols to be transmitte dfrom the sequencer
///////////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_bfm::run_phase(uvm_phase phase);

 if(pl_env_config.srio_vip_model!=SRIO_TXRX)
  begin//{
    initialize(); 
    fork
     tb_reset_ackid();
     gen_xmt_cmd(); 
     xmt_timer_method();
    join_none
    forever
    begin //{
       @(negedge driver_trans.int_clk or negedge srio_if.srio_rst_n)
       begin//{
       if(~srio_if.srio_rst_n)
       begin //{
        driver_trans.curr_tx_ackid=0;
        driver_trans.next_tx_ackid = 0;
       end//}
       else
        if(/*~driver_trans.ies_state && ~driver_trans.oes_state && ~driver_trans.irs_state && ~driver_trans.ors_state && */driver_trans.link_initialized && driver_trans.transmit_enable)
        begin //{   
            for(int i=0;i<srio_pktcs_merge_ins.pl_outstanding_ackid_q.size();i++)
            begin //{
               ackid_pkt_trans = new srio_pktcs_merge_ins.pl_outstanding_ackid_q[i];
               if(ackid_pkt_trans.ackid==driver_trans.next_tx_ackid)
                block_pkt=1;
               else
                block_pkt=0;
               break;
            end//}
            if((((!block_pkt && (pl_env_config.srio_mode == SRIO_GEN30 && (srio_pktcs_merge_ins.pl_outstanding_ackid_q.size()<= pl_config.ackid_threshold))) || (!block_pkt && driver_trans.bfm_idle_selected && (srio_pktcs_merge_ins.pl_outstanding_ackid_q.size()<= pl_config.ackid_threshold[5:0])) || (!block_pkt && ~driver_trans.bfm_idle_selected && (srio_pktcs_merge_ins.pl_outstanding_ackid_q.size()<= pl_config.ackid_threshold[4:0]))) && (pl_config.flow_control_mode == RECEIVE)) || ((pl_config.flow_control_mode == TRANSMIT) && (srio_pkt_handler_ins.rxed_buf_status <= pl_config.buffer_space)))
           begin //{   
              seq_item_port.try_next_item(item);       
              if(item != null)
              begin //{   
                 if(pl_env_config.en_packet_delay)
                  pl_pkt_delay(item); //Task to delay packet transmission
                 pl_pkt_gen(item); 
                 seq_item_port.item_done();       
                 `ifdef UVM_DISABLE_AUTO_ITEM_RECORDING
                   end_tr(item);
                 `endif
              end //}
              else 
              begin //{
                       if(pl_drv_get_port.try_get(item))
                        begin//{
                         if(pl_env_config.en_packet_delay)
                          pl_pkt_delay(item); //Task to delay packet transmission
                         pl_pkt_gen(item);
                        end//}
              end //}  
           end //}
     end //}
    end //}
   end //}
  end //}
  else
   begin//{
    forever
     begin//{
        @(negedge driver_trans.int_clk)
         begin//{
          if( driver_trans.port_initialized)
           begin//{
            seq_item_port.try_next_item(item);       
            if(item != null)
             begin//{
              pl_pkt_gen_txrx(item);
              seq_item_port.item_done();      
              `ifdef UVM_DISABLE_AUTO_ITEM_RECORDING
                end_tr(item);
              `endif
             end//}
           end//}
         end //}
     end//}
   end //}
 endtask : run_phase


///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : pl_pkt_gen
/// Description :This task performs the following function
/// 1. Introduces the relevant error in packet /control symbol to be transmitted
/// 2. Based on the packet/control symbol received from the pl_sequencer manipulates the local variables 
///  to keep track of tha packets/control symbols tranmistted
/// 3. Receives the state machine transaction request and sets the internal flags accordingly 
/// 4. Forms each transcation(packet/contraol symbol) by calculating the crc and packing the bytes
/// 5. Triggers the event to indicate packet/control symbol is avilable for transmissiom
///////////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_bfm::pl_pkt_gen(srio_trans srio_trans_item_ip);
     srio_trans_item = new srio_trans_item_ip;
     `uvm_do_callbacks(srio_pl_bfm, srio_pl_callback, srio_pl_trans_generated(srio_trans_item))
     if(srio_trans_item.pkt_type == SRIO_TL_PACKET && srio_trans_item.transaction_kind == SRIO_PACKET)
     begin //{
       if(srio_trans_item.pl_err_kind == EARLY_CRC_ERR)
       begin //{
          srio_trans_item.early_crc = ~srio_trans_item.early_crc;
       end //}
       else if(srio_trans_item.pl_err_kind == FINAL_CRC_ERR)
       begin //{
          srio_trans_item.final_crc = ~srio_trans_item.final_crc;
       end //}
       srio_trans_item.pkt_type = SRIO_PL_PACKET; 
       srio_trans_item.transaction_kind = SRIO_PACKET;
       driver_trans.curr_tx_ackid = driver_trans.next_tx_ackid;
       if(srio_trans_item.pl_err_kind == ACKID_ERR)
       begin //{
         srio_trans_item.ackid  =  ~driver_trans.curr_tx_ackid;
       end //}
       else
       begin //{
         srio_trans_item.ackid  =  driver_trans.curr_tx_ackid;
       end //}
       inc_ackid();

      srio_trans_item.env_config = pl_env_config;
      void'(srio_trans_item.pack_bytes(bytestream));
      srio_trans_item.bytestream = bytestream;
      `uvm_info("SRIO_PL_BFM : ", $sformatf("SRIO TL PACKET RECEIVED IN PL DRIVER "), UVM_LOW)
     end //}
     else if(srio_trans_item.pkt_type == SRIO_PL_PACKET && srio_trans_item.transaction_kind == SRIO_PACKET)
     begin //{
       if(srio_trans_item.pl_err_kind == EARLY_CRC_ERR)
       begin //{
          srio_trans_item.early_crc = ~srio_trans_item.early_crc;
       end //}
       else if(srio_trans_item.pl_err_kind == FINAL_CRC_ERR)
       begin //{
          srio_trans_item.final_crc = ~srio_trans_item.final_crc;
       end //}
         driver_trans.curr_tx_ackid = driver_trans.next_tx_ackid;
       if(srio_trans_item.pl_err_kind == ACKID_ERR)
       begin //{
         srio_trans_item.ackid  =  ~driver_trans.curr_tx_ackid;
       end //}
       else
       begin //{
         srio_trans_item.ackid  =  driver_trans.curr_tx_ackid;
       end //}
         inc_ackid();
         srio_trans_item.env_config = pl_env_config;
         void'(srio_trans_item.pack_bytes(bytestream));
         srio_trans_item.bytestream = bytestream;
        `uvm_info("SRIO_PL_BFM : ", $sformatf("SRIO PL PACKET RECEIVED FROM PL SEQUENCE"), UVM_LOW)
     end //} 
     else if(srio_trans_item.pkt_type == SRIO_PL_PACKET && srio_trans_item.transaction_kind == SRIO_CS)
     begin //{

        srio_trans_item.env_config = pl_env_config;
        set_delimiter=0;
       if(srio_trans_item.stype0 == 4'b0000)
       begin //{
          if(~srio_pkt_handler_ins.pkth_incr_ackid)
          begin //{
            srio_pkt_handler_ins.seq_pa_flag = 1'b1;
            srio_pkt_handler_ins.seq_pa_ackid = srio_trans_item.param0;
          end  //}
          else
          begin //{
            srio_pkt_handler_ins.seq_pa_flag = 1'b0;
            srio_pkt_handler_ins.seq_pa_ackid = 0;
          end //}
          for(int i=0;i<srio_pkt_handler_ins.rx_outstanding_ackid_q.size();i++)
          begin//{
             temp_trans = new srio_pkt_handler_ins.rx_outstanding_ackid_q[i];
             if(temp_trans.ackid == srio_trans_item.param0)
             begin //{
                 srio_pkt_handler_ins.rx_outstanding_ackid_q.delete(i);
                 break; 
             end //} 
          end //}

         srio_pkt_handler_ins.inc_ackid();
         srio_pkt_handler_ins.pkth_incr_ackid = 1'b0; 

       end //}

      if(srio_trans_item.stype0 == 4'b0001)
      begin //{

          if(~srio_pkt_handler_ins.pkth_incr_ackid)
          begin //{
            srio_pkt_handler_ins.seq_retry_flag = 1'b1;
            for(int i=0;i<srio_pkt_handler_ins.rx_outstanding_ackid_q.size();i++)
            begin//{
               temp_trans = new srio_pkt_handler_ins.rx_outstanding_ackid_q[i];
               if(temp_trans.ackid <= srio_trans_item.param0)
                   srio_pkt_handler_ins.rx_outstanding_ackid_q.delete(i);
            end //}
             srio_pkt_handler_ins.outstanding_ackid = srio_trans_item.param0;
          end //}
          else
          begin//{
             srio_pkt_handler_ins.pkth_incr_ackid = 1'b0;
            if(srio_pkt_handler_ins.rx_outstanding_ackid_q.size()!= 0 )
            begin //{
               for(int i=0;i<srio_pkt_handler_ins.rx_outstanding_ackid_q.size();i++)
               begin//{
                  temp_trans = new srio_pkt_handler_ins.rx_outstanding_ackid_q[i];
                  if(temp_trans.ackid <= srio_trans_item.param0)
                      srio_pkt_handler_ins.rx_outstanding_ackid_q.delete(i);
               end //}
               srio_pkt_handler_ins.outstanding_ackid = srio_pkt_handler_ins.outstanding_ackid - 1;
            end //}
          end //} 
      end

       if(srio_trans_item.stype0 == 4'b0010)
       begin //{
          driver_trans.ies_state = 1'b1;         
         if(~srio_pkt_handler_ins.pkth_incr_ackid)
         begin
           srio_pkt_handler_ins.seq_pna_flag = 1'b1;
         end
         else
          begin//{
             srio_pkt_handler_ins.pkth_incr_ackid = 1'b0;
            if(srio_pkt_handler_ins.rx_outstanding_ackid_q.size()!= 0 )
            begin //{
             void'(srio_pkt_handler_ins.rx_outstanding_ackid_q.pop_back());
             srio_pkt_handler_ins.outstanding_ackid = srio_pkt_handler_ins.outstanding_ackid - 1;
            end //}

          end //} 
          
       end //}

       if(srio_trans_item.stype1 == 4'b0000)
          packet_open=1'b1;
       if((srio_trans_item.stype1 == 4'b0011 || srio_trans_item.stype1 == 4'b0100) && packet_open==1)
        begin//{
         packet_open=0;
         srio_trans_item.delimiter=8'h7C;
         set_delimiter=1;
        end//}
       if(srio_trans_item.stype1 == 4'b0010)
         packet_open=0;

       if(pl_env_config.srio_mode != SRIO_GEN30)
       begin //{
       if(driver_trans.bfm_idle_selected)
            srio_trans_item.cstype = CS48;
          else
            srio_trans_item.cstype = CS24; 
         if(driver_trans.bfm_idle_selected)
        void'(srio_trans_item.calccrc13(srio_trans_item.pack_cs()));
       else
         void'(srio_trans_item.calccrc5(srio_trans_item.pack_cs()));
         if(~set_delimiter)
          void'(srio_trans_item.set_delimiter());
         void'(srio_trans_item.pack_cs_bytes());
        end //}
        else
        begin //{
          srio_trans_item.cstype = CS64; 
     
          void'(srio_trans_item.calccrc24(srio_trans_item.pack_cs()));
       void'(srio_trans_item.pack_cs_bytes());
        end //}
        `uvm_info("SRIO_PL_BFM : ", $sformatf("SRIO CONTROL SYMBOL RECEIVED FROM PL SEQUENCE"), UVM_LOW)
     end //}

     if(srio_trans_item.transaction_kind == SRIO_STATE_MC && driver_trans.ism_change_req == FALSE)
     begin
        driver_trans.ism_change_req = TRUE;
        driver_trans.ism_req_state  = srio_trans_item.next_state;
        `uvm_info("SRIO_PL_BFM : ", $sformatf(" ISM State Change Requested. Requested State: %s ",driver_trans.ism_req_state.name()), UVM_LOW)
     end
     else begin
         srio_tx_pkt_event.trigger(srio_trans_item);
     end
 endtask : pl_pkt_gen 

///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : inc_ackid
/// Description :Task to incremnet the ackid for packets to be transmitted 
///////////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_bfm::inc_ackid();

   if(pl_env_config.srio_mode == SRIO_GEN30)
   begin //{
      if(driver_trans.next_tx_ackid == 4095)
        driver_trans.next_tx_ackid = 0;
      else
        driver_trans.next_tx_ackid = driver_trans.next_tx_ackid + 1; 
   end //}
   else if(driver_trans.bfm_idle_selected)
   begin //{
      if(driver_trans.next_tx_ackid == 63)
        driver_trans.next_tx_ackid = 0;
      else
        driver_trans.next_tx_ackid = driver_trans.next_tx_ackid + 1; 
   end //}
   else
   begin //{
      if(driver_trans.next_tx_ackid == 31)
        driver_trans.next_tx_ackid = 0;
      else
        driver_trans.next_tx_ackid = driver_trans.next_tx_ackid + 1; 
   end //}    

 endtask : inc_ackid 

//////////////////////////////////////////////////////////////////////////
/// Name: pl_pkt_delay \n
/// Description: Inserting delay between each paket to be transmitted 
//////////////////////////////////////////////////////////////////////////
task srio_pl_bfm::pl_pkt_delay(srio_trans srio_trans_item_ip);
  repeat(srio_trans_item_ip.packet_gap)
    @(negedge srio_if.sim_clk);
endtask : pl_pkt_delay
//////////////////////////////////////////////////////////////////////////
/// Name: gen_xmt_cmd \n
/// Description: Task to trigger timer once the "change_my_xmt_width"
/// is asserted 
//////////////////////////////////////////////////////////////////////////
 task srio_pl_bfm::gen_xmt_cmd();
  fork
    begin//{ //Change my Transmit Width
     forever
      begin//{
       @(driver_trans.change_my_xmt_width);
        begin//{
         if(driver_trans.change_my_xmt_width==3'b000)
          begin//{
            driver_trans.status_my_xmt_width_chng = 2'b00;
           `uvm_info("SRIO_PL_DRIVER : ", $sformatf("Change my Transmit Width is set to HOLD "), UVM_LOW)
          end//}
         else if(driver_trans.change_my_xmt_width==3'b110 || driver_trans.change_my_xmt_width==3'b111)
          `uvm_info("SRIO_PL_DRIVER : ", $sformatf("Change my Transmit Width - Reserved Values "), UVM_LOW)
         else
          begin//{
           xmt_my_cmd_rcvd=1'b1;
          end //} 
        end//}
      end  //} 
     end//}
    begin//{ //Change Link Partner Transmit Width
     forever
      begin//{
       @(driver_trans.change_lp_xmt_width);
        begin//{ 
         if(driver_trans.change_lp_xmt_width==3'b000)
          begin//{
            driver_trans.status_lp_xmt_width_chng = 2'b00;
           `uvm_info("SRIO_PL_DRIVER : ", $sformatf("Change Link Partner Transmit Width is set to HOLD "), UVM_LOW)
          end //}
         else if(driver_trans.change_lp_xmt_width==3'b110 || driver_trans.change_lp_xmt_width==3'b111)
          `uvm_info("SRIO_PL_DRIVER : ", $sformatf("Change Link Partner Transmit Width - Reserved Values "), UVM_LOW)
         else
          begin//{
           xmt_lp_cmd_rcvd=1'b1;
          end //} 
        end//}
      end  //} 
     end//}
  join
 endtask:gen_xmt_cmd

//////////////////////////////////////////////////////////////////////////
/// Name: xmt_timer_method \n
/// Description: Task to run timer once the "change_my_xmt_width"
/// is asserted 
//////////////////////////////////////////////////////////////////////////
task srio_pl_bfm::xmt_timer_method();
 fork
  begin//{
   forever
    begin//{
     wait(xmt_my_cmd_rcvd==1);
     repeat(pl_config.xmt_my_cmd_timer)
      begin //{
       if (~driver_trans.from_sc_rcv_width_link_cmd_ack||~driver_trans.from_sc_rcv_width_link_cmd_nack)
        @(posedge srio_if.sim_clk);
       else
        break;
      end //}
     xmt_my_cmd_rcvd=1'b0;
     if(driver_trans.from_sc_rcv_width_link_cmd_ack)
      driver_trans.status_my_xmt_width_chng = 2'b01;
     else
      driver_trans.status_my_xmt_width_chng = 2'b10;
    end//}
  end//}
  begin//{
   forever
    begin//{
     wait(xmt_lp_cmd_rcvd==1'b1);
     repeat(pl_config.xmt_lp_cmd_timer)
      begin //{
       if (~driver_trans.xmt_width_port_req_pending)
        @(posedge srio_if.sim_clk);
       else
        break;
      end //}
     xmt_lp_cmd_rcvd=1'b0;
    if(driver_trans.xmt_width_port_req_pending)
     driver_trans.status_lp_xmt_width_chng = 2'b01; 
    else 
     driver_trans.status_lp_xmt_width_chng = 2'b10; 
    end//}
  end//}
 join
endtask:xmt_timer_method
  


///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : pl_pkt_gen_txrx
/// Description :Task to receive the packets/control symbols to be transmitted, manipulate for error
/// and form the complete transactions for TXRX model 
///////////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_bfm::pl_pkt_gen_txrx(srio_trans srio_trans_item_ip);
  begin//{
   begin//{
   srio_trans_item=new srio_trans_item_ip;
    if(srio_trans_item.pkt_type == SRIO_PL_PACKET && srio_trans_item.transaction_kind == SRIO_PACKET)
    begin //{ 
      if(srio_trans_item.pl_err_kind == EARLY_CRC_ERR)
      begin //{ 
         srio_trans_item.early_crc = ~srio_trans_item.early_crc;
      end //} 
      else if(srio_trans_item.pl_err_kind == FINAL_CRC_ERR)
      begin //{ 
         srio_trans_item.final_crc = ~srio_trans_item.final_crc;
      end //} 
      driver_trans.curr_tx_ackid = driver_trans.next_tx_ackid;
      if(srio_trans_item.pl_err_kind == ACKID_ERR)
      begin //{ 
        srio_trans_item.ackid  =  ~driver_trans.curr_tx_ackid;
      end //} 
      else
      begin //{ 
        srio_trans_item.ackid  =  driver_trans.curr_tx_ackid;
      end //} 
        inc_ackid();
        srio_trans_item.env_config = pl_env_config;

        void'(srio_trans_item.pack_bytes(bytestream));
        srio_trans_item.bytestream = bytestream;
       `uvm_info("SRIO_PL_BFM : ", $sformatf("SRIO PL PACKET RECEIVED FROM PL SEQUENCE"), UVM_LOW)
    end //} 
    else if(srio_trans_item.pkt_type == SRIO_PL_PACKET && srio_trans_item.transaction_kind == SRIO_CS)
    begin //{ 


      if(pl_env_config.srio_mode != SRIO_GEN30)
      begin //{
      if(driver_trans.bfm_idle_selected)
           srio_trans_item.cstype = CS48;
         else
           srio_trans_item.cstype = CS24;
        if(driver_trans.bfm_idle_selected)
       void'(srio_trans_item.calccrc13(srio_trans_item.pack_cs()));
      else
        void'(srio_trans_item.calccrc5(srio_trans_item.pack_cs()));

//        void'(srio_trans_item.set_delimiter());
        void'(srio_trans_item.pack_cs_bytes());
    end//}
     else
     begin //{ 
       srio_trans_item.cstype = CS64; 
       void'(srio_trans_item.calccrc24(srio_trans_item.pack_cs()));
       void'(srio_trans_item.pack_cs_bytes());
     end //} 
   end//}
   srio_tx_pkt_event.trigger(srio_trans_item);
  end//}
 end//}
 endtask:pl_pkt_gen_txrx

///////////////////////////////////////////////////////////////////////////////////////////////
/// Name :tb_reset_ackid 
/// Description :Task to reset BFM outbound packet ackid 
///////////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_bfm::tb_reset_ackid();
 forever
  begin//{
   wait(pl_env_config.reset_ackid==1);
    driver_trans.next_tx_ackid=0;
   wait(pl_env_config.reset_ackid==0);
  end//}
endtask:tb_reset_ackid
