//////////////////////////////////////////////////////////////////////////////n
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_pkt_handler.sv
// Project :  srio vip
// Purpose :  Physical Layer Packet Handler
// Author  :  Mobiveil
//
// Physical Layer Packet Handler component.
//
////////////////////////////////////////////////////////////////////////////////  


class srio_pl_pkt_handler extends uvm_component;
 
  /// @cond
   `uvm_component_utils(srio_pl_pkt_handler)
  /// @endcond

  `uvm_register_cb(srio_pl_pkt_handler, srio_pl_callback)	///< Registering PL callback

  virtual srio_interface srio_if;                               ///< Virtual interface

  srio_pl_config pkth_config;                                  ///< PL config instance

  srio_pl_common_component_trans common_com_trans;             ///< PL common transaction instance

  srio_env_config handler_env_config;                          ///< ENV config instance

  srio_pl_pktcs_merger pkt_merge_ins;                          ///< PL Packet/Conrtrol symbol Merger instance

  srio_trans pkth_trans_ins,trans_push_ins,ackid_pkt_trans,status_cs,pkth_trans_ins_2,temp_srio_trans,temp_trans,del_trans,seq_trans ; ///< Transaction Item instance


  uvm_blocking_put_port #(srio_trans) pl_handler_gen_put_port; ///< Port where received packets are put

  int random_delay;

  logic [0:11] buf_status;                                     ///< Buffer status in control symbol in RECEIVE flow control mode
  bit   [0:11] seq_pa_ackid;                                   ///< Ackid in the Packet Accepted given through sequence
  bit         seq_pa_flag;                                     ///< Packet Accepted is given through sequence 
  bit         seq_retry_flag;                                  ///< Packet Retry is given through sequence
  bit         seq_pna_flag;                                    ///< Packet Not Accepted is given through sequence
  logic [0:11] seq_retried_ackid; 
  logic [0:11] ackid;                                          ///< storing next expected ackid
  logic [0:11] ackid_clear;                                    ///< Ackid to be cleared from the packet queue upon receipt of PAC 
  logic [0:11] ackid_status;                                   ///< Ackid status received in Link Response
  logic [0:11] retried_ackid;                                  ///< Ackid received in retry CS
  logic [0:11] notaccepted_ackid;                              ///< Ackid received in not accepted CS
  logic [0:11] buff_status;                                    ///< Buffer status received
  logic [0:11] temp_ackid,temp1_ackid,temp_ackid2,temp_ackid3; ///< Store received ackid
  logic [0:7] gen3_stype1;                                     ///< Concatanated stype1 
  logic [0:37] cs_val;                                         ///< Formatted CS bytes on which CRC is calculated 
  bit          incorrect_crc;                                  ///< Detected incorrect CRC in packet  
  bit          ackid_err;                                      ///< Detected wrong ackid in packet
  bit          buffer_full;                                    ///< Buffer full error for PNAC
  bit          pkt_size_err;                                   ///< Error in packet size 
  bit          inv_ilgl_err;                                    ///< Invalid/Illegal Character 
  logic [0:12] temp_cs_crc13;                                  ///< CRC13 in received CS
  logic [0:4]  temp_cs_crc5;                                   ///< CRC5 in received CS
  logic [0:23] temp_cs_crc24;                                  ///< CRC24 in received CS 
  logic [0:15] packed_ecrc;
  logic [0:15] packed_fcrc;
  logic [0:15] temp_earlycrc;                                  ///< Received Packet Early CRC  
  logic [0:15]  temp_finalcrc;                                 ///< Received Packet Final CRC
  logic [0:12] calc_crc13;                                     ///< Calculated CRC13 
  logic [0:23] calc_crc24;                                     ///< Calculted CRC24
  logic [0:4]  calc_crc5;                                      ///< Calculated CRC5
  bit          cs_crc_err;                                     ///< Incorrect CRC in control symbol
  bit          rst_dev_cmd_rxd;                                ///< Received reset link request command
  bit   [2:0]  rst_dec_cmd_cnt;                                ///< Received reset link request command count
  int          pa_cnt;
  //int          status_cnt;                                     ///< Counter to keep track of status control symbol to be transmitted 
  int          vc_status_cnt;                                  ///< Counter tpo keep track of VC status control symbol to be transmitted 
  int          rxed_buf_status;                                ///< Received Buffer status for TRansmit mode
  bit [0:11]    outstanding_ackid;                             ///< Next expected ackid in packet
  srio_trans    rx_outstanding_ackid_q[$];                     ///< Store received packet
  bit   [0:11]  vcid_status;                                   ///< VCID status received for multi vc
  bit   [0:11]  vcid1_buf_status;                              ///< VC1 Buffer status received
  bit   [0:11]  vcid2_buf_status;                              ///< VC2 Buffer status received
  bit   [0:11]  vcid3_buf_status;                              ///< VC3 Buffer status received
  bit   [0:11]  vcid4_buf_status;                              ///< VC4 Buffer status received
  bit   [0:11]  vcid5_buf_status;                              ///< VC5 Buffer status received
  bit   [0:11]  vcid6_buf_status;                              ///< VC6 Buffer status received
  bit   [0:11]  vcid7_buf_status;                              ///< VC7 Buffer status received
  bit   [0:11]  vcid8_buf_status;                              ///< VC8 Buffer status received
  bit   [0:11]  vc0_buf_status;                                ///< VC0 Buffer status received   
  int          free_buf_cnt_vc1;                               ///< Buffer allocated for VC1
  int          free_buf_cnt_vc2;                               ///< Buffer allocated for VC2
  int          free_buf_cnt_vc3;                               ///< Buffer allocated for VC3
  int          free_buf_cnt_vc4;                               ///< Buffer allocated for VC4
  int          free_buf_cnt_vc5;                               ///< Buffer allocated for VC5
  int          free_buf_cnt_vc6;                               ///< Buffer allocated for VC6
  int          free_buf_cnt_vc7;                               ///< Buffer allocated for VC7
  int          free_buf_cnt_vc8;                               ///< Buffer allocated for VC8
  int          free_buf_cnt_vc0;                               ///< Buffer allocated for VC0
  bit          temp_vc;                                        ///< Received VC in packet 
  bit [0:2]    temp_vcid;                                      ///< Received VCID in packet
  bit          sync_retry_flag;
  bit          sync_pna_flag;
  bit          sync_out_ackid;
  srio_trans   cs_dly_q[$];                                   ///< Below are various transaction item
  srio_trans   pkt_dly_q[$];                                  ///< queues to schedule control symbol/packet
  srio_trans   receive_pkt_q[$];                              ///< transmission with delay with/without
  srio_trans   receive_pkt_vc0_q[$];                          ///< multi VC support
  srio_trans   receive_pkt_vc1_q[$];
  srio_trans   receive_pkt_vc2_q[$];
  srio_trans   receive_pkt_vc3_q[$];
  srio_trans   receive_pkt_vc4_q[$];
  srio_trans   receive_pkt_vc5_q[$];
  srio_trans   receive_pkt_vc6_q[$];
  srio_trans   receive_pkt_vc7_q[$];
  srio_trans   receive_pkt_vc8_q[$];
  bit gen_link_req_after_link_init;                           ///< Flag to indicate Link Request needs to be trasnmitted after link
                                                              ///< is initialized
  byte unsigned bytestream[];                                 ///< Received packet bytestream
  int bytestream_size;                                        ///< Receive dpacket bytestream size

  int pkt_early_crc_index;                                    ///< Early CRC index in packet bytestream
  int pkt_final_crc_index;                                    ///< Final CRC index in packet bytestream
  bit pkth_incr_ackid;                                        ///< Increase packet ACKid

  bit [15:0] pkt_early_crc_rcvd;                              ///< Early CRC received 
  bit [15:0] pkt_early_crc_exp;                               ///< Early CRC expected
  bit [15:0] pkt_final_crc_rcvd;                              ///< Final CRC received
  bit [15:0] pkt_final_crc_exp;                               ///< FInal CRC expected

  bit [15:0] pkt_early_crc_exp_2;
  bit [15:0] pkt_final_crc_exp_2;

  bit [0:63] local_TSG;                                       ///< Timestamp received 
  bit update_TSG;                                             ///< Flag to update TSG based on teh received timestamp
  int TS_auto_cntr;                                           ///< Counetr for automatic transmission of Timestamp
  bit send_TS;                                                ///< Flag to trigger timestamp CS
  bit send_loop_req;                                          ///< Flag to trigger Loop Request CS
  bit send_zero_TS;                                           ///< Flag to trigger zero Timestamp CS
  bit send_lreq;                                              ///< FLag to indicate Fast error recovery
  bit err_choice;                                             ///< Internal variable to randomly choose error type for PNAC
  bit packet_open;


  // Methods
  extern function new(string name = "srio_pl_pkt_handler", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task initialize();
  extern task resp_random_delay();
  extern task pkt_resp_random_delay();
  extern task pop_pkt();
  extern task pop_trans_user();
  extern task inc_ackid();
  extern task inc_ackid_mul(input int ackid);
  extern task inc_outs_ackid();
  extern task gen_pna_cs();
  extern task gen_pa_cs();
  extern task gen_rfr_cs();
  extern task gen_pr_cs();
  extern task gen_linkreq_cs();
  extern task gen_lresp_cs();
  extern task gen_status_cs();  
  extern task gen_vc_status_cs(input bit [0:2] vcid);
  extern task gen_loop_req_cs();  
  extern task gen_loop_res_cs();  
  extern task gen_timestamp_cs();  
  extern task get_timestamp_req();  
  extern task pkt_push_transmit_mode();
  extern task pkt_push_transmit_mode_vc0();
  extern task pkt_push_transmit_mode_vc1();
  extern task pkt_push_transmit_mode_vc2();
  extern task pkt_push_transmit_mode_vc3();
  extern task pkt_push_transmit_mode_vc4();
  extern task pkt_push_transmit_mode_vc5();
  extern task pkt_push_transmit_mode_vc6();
  extern task pkt_push_transmit_mode_vc7();
  extern task pkt_push_transmit_mode_vc8();
  extern task run_TSG();
  extern task loop_req_timer();
  extern task run_TS_autoupdate_timer();
  extern task reform_cs(input srio_trans temp_srio_trans);
  extern task tb_reset_ackid();

  virtual task srio_pl_trans_received(ref srio_trans rx_srio_trans);
  endtask 

 endclass : srio_pl_pkt_handler

///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : New
/// Description : Constructor method for srio_pl_pkt_handler class.
///////////////////////////////////////////////////////////////////////////////////////////////
 function srio_pl_pkt_handler::new(string name = "srio_pl_pkt_handler", uvm_component parent = null);
  super.new(name, parent);
//  pkth_trans_ins = new();
 // trans_push_ins = new();
//  ackid_pkt_trans = new();
  pl_handler_gen_put_port = new("pl_handler_gen_put_port",this);
 endfunction 


///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : build_phase
/// Description : build_phase method for srio_pl_pkt_handler class.
///////////////////////////////////////////////////////////////////////////////////////////////
 function void srio_pl_pkt_handler::build_phase(uvm_phase phase);
   super.build_phase(phase);
 endfunction :build_phase 

////////////////////////////////////////////////////////////////////////////////////////////
/// Name: inc_ackid\n
/// Description: Task to increment Ackid. When a packet accepted CS is generated, the ackid
/// is incremented
////////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_pkt_handler::inc_ackid();

   if(handler_env_config.srio_mode == SRIO_GEN30)
   begin //{
      if(common_com_trans.curr_rx_ackid == 4095)
        common_com_trans.curr_rx_ackid = 0;
      else
        common_com_trans.curr_rx_ackid = common_com_trans.curr_rx_ackid + 1; 
   end //}
   else if(common_com_trans.bfm_idle_selected)
   begin //{
      if(common_com_trans.curr_rx_ackid == 63)
        common_com_trans.curr_rx_ackid = 0;
      else
        common_com_trans.curr_rx_ackid = common_com_trans.curr_rx_ackid + 1; 
   end //}
   else
   begin //{
      if(common_com_trans.curr_rx_ackid == 31)
        common_com_trans.curr_rx_ackid = 0;
      else
        common_com_trans.curr_rx_ackid = common_com_trans.curr_rx_ackid + 1; 
   end //}    

 endtask : inc_ackid 
////////////////////////////////////////////////////////////////////////////////////////////
/// Name: inc_ackid_mul\n
/// Description: Task to increment Ackid when multiple ack is supported.
/// When a packet accepted CS is generated, the ackid is incremented
////////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_pkt_handler::inc_ackid_mul(input int ackid);
   if(handler_env_config.srio_mode == SRIO_GEN30)
   begin //{
      if(ackid == 4095)
        common_com_trans.gr_curr_tx_ackid = 0;
      else
        common_com_trans.gr_curr_tx_ackid = ackid+ 1; 
   end //}
   else if(common_com_trans.bfm_idle_selected)
   begin //{
      if(ackid == 63)
        common_com_trans.gr_curr_tx_ackid = 0;
      else
        common_com_trans.gr_curr_tx_ackid = ackid + 1; 
   end //}
   else
   begin //{
      if(ackid == 31)
        common_com_trans.gr_curr_tx_ackid = 0;
      else
        common_com_trans.gr_curr_tx_ackid = ackid + 1; 
   end //}    
 endtask : inc_ackid_mul 

////////////////////////////////////////////////////////////////////////////////////////////
/// Name: inc_outs_ackid\n
/// Description: Task to increment Outstanding Ackid. This is the ackid expected in the next
/// packet
////////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_pkt_handler::inc_outs_ackid();

   if(handler_env_config.srio_mode == SRIO_GEN30)
   begin //{
      if(outstanding_ackid == 4095)
        outstanding_ackid = 0;
      else
        outstanding_ackid = outstanding_ackid + 1; 
   end //}
   else if(common_com_trans.bfm_idle_selected)
   begin //{
      if(outstanding_ackid == 63)
        outstanding_ackid = 0;
      else
        outstanding_ackid = outstanding_ackid + 1; 
   end //}
   else
   begin //{
      if(outstanding_ackid == 31)
        outstanding_ackid = 0;
      else
        outstanding_ackid = outstanding_ackid + 1; 
   end //}    
  `uvm_info("SRIO_PL_PKT_HANDLER : ",$sformatf("outstanding_ackid=%d",outstanding_ackid),UVM_LOW);

 endtask : inc_outs_ackid 

////////////////////////////////////////////////////////////////////////////////////////////
/// Name: gen_vc_status_cs\n
/// Description: Task to generate VC Status Control Symbol. 
////////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_pkt_handler::gen_vc_status_cs(input bit [0:2] vcid);

     status_cs = new(); 
     status_cs.pkt_type = SRIO_PL_PACKET;
     status_cs.transaction_kind = SRIO_CS;
     status_cs.stype0 = 4'b0101;
     if(handler_env_config.srio_mode == SRIO_GEN30)
       status_cs.cstype = CS64;
     else if(common_com_trans.bfm_idle_selected)
       status_cs.cstype = CS48;
     else
       status_cs.cstype = CS24;

     status_cs.param0 = {6'b000000,3'b000,vcid};

     if(pkth_config.flow_control_mode == RECEIVE)
       status_cs.param1 = 12'hFFF;
     else
     begin//{
      if(vcid == 3'b000)
       status_cs.param1 = free_buf_cnt_vc1 - receive_pkt_vc1_q.size();
      else if(vcid == 3'b001)
       status_cs.param1 = free_buf_cnt_vc2 - receive_pkt_vc2_q.size();
      else if(vcid == 3'b010)
       status_cs.param1 = free_buf_cnt_vc3 - receive_pkt_vc3_q.size();
      else if(vcid == 3'b011)
       status_cs.param1 = free_buf_cnt_vc4 - receive_pkt_vc4_q.size();
      else if(vcid == 3'b100)
       status_cs.param1 = free_buf_cnt_vc5 - receive_pkt_vc5_q.size();
      else if(vcid == 3'b101)
       status_cs.param1 = free_buf_cnt_vc6 - receive_pkt_vc6_q.size();
      else if(vcid == 3'b110)
       status_cs.param1 = free_buf_cnt_vc7 - receive_pkt_vc7_q.size();
      else if(vcid == 3'b111)
       status_cs.param1 = free_buf_cnt_vc8 - receive_pkt_vc8_q.size();
     end //}

     status_cs.stype1  = 3'b111;
     status_cs.cmd     = 3'b101;
     status_cs.brc3_stype1_msb = 2'b00;
 
     if(handler_env_config.srio_mode == SRIO_GEN30)
       void'(status_cs.calccrc24(status_cs.pack_cs()));
     else if(common_com_trans.bfm_idle_selected)
       void'(status_cs.calccrc13(status_cs.pack_cs()));
     else
       void'(status_cs.calccrc5(status_cs.pack_cs()));
 
       
     if(handler_env_config.srio_mode != SRIO_GEN30)
        status_cs.delimiter = 8'h1C;
     void'(status_cs.pack_cs_bytes());
     pkt_merge_ins.pl_gencs_q.push_back(status_cs); 

 endtask : gen_vc_status_cs

////////////////////////////////////////////////////////////////////////////////////////////
/// Name: gen_status_cs\n
/// Description: Task to generate Status Control Symbol. 
////////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_pkt_handler::gen_status_cs();
     status_cs = new(); 
     status_cs.pkt_type = SRIO_PL_PACKET;
     status_cs.transaction_kind = SRIO_CS;
     status_cs.stype0 = 4'b0100;
     if(handler_env_config.srio_mode == SRIO_GEN30)
       status_cs.cstype = CS64;
     else if(common_com_trans.bfm_idle_selected)
       status_cs.cstype = CS48;
     else
       status_cs.cstype = CS24;

     //status_cs.param0 = common_com_trans.curr_rx_ackid;
     status_cs.param0 = common_com_trans.ackid_for_scs; 
     if(pkth_config.multiple_ack_support)
      status_cs.param0 = common_com_trans.gr_curr_tx_ackid;

     if(pkth_config.flow_control_mode == RECEIVE)
     begin //{
          status_cs.param1 = 12'hfff;
     end //}
     else
     begin //{
       if(handler_env_config.multi_vc_support == 1'b0)
         status_cs.param1 = pkth_config.buffer_space - receive_pkt_q.size();
       else
         status_cs.param1 = pkth_config.buffer_space - receive_pkt_vc0_q.size();
     end //}
   
     status_cs.stype1  = 3'b111;
     status_cs.cmd     = 3'b000;
     status_cs.brc3_stype1_msb = 2'b00;
 
     if(handler_env_config.srio_mode == SRIO_GEN30)
       void'(status_cs.calccrc24(status_cs.pack_cs()));
     else if(common_com_trans.bfm_idle_selected)
       void'(status_cs.calccrc13(status_cs.pack_cs()));
     else
       void'(status_cs.calccrc5(status_cs.pack_cs()));
 
       
     if(handler_env_config.srio_mode != SRIO_GEN30)
        status_cs.delimiter = 8'h1C;

     void'(status_cs.pack_cs_bytes());
     pkt_merge_ins.pl_gencs_q.push_back(status_cs); 


 endtask : gen_status_cs

///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : run_phase
/// Description : run_phase method of srio_pl_pkt_handler class.
/// It triggers all the methods within the class which needs to be run forever.
///////////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_pkt_handler::run_phase(uvm_phase phase);
     if(handler_env_config.srio_vip_model!=SRIO_TXRX)
      begin//{
       fork
        tb_reset_ackid();
        initialize();
        pop_pkt();
        resp_random_delay();
        pkt_resp_random_delay();
        gen_pna_cs();
        run_TSG();
        if(handler_env_config.spec_support==V30)
         gen_loop_req_cs();  
        if(handler_env_config.spec_support==V30)
         loop_req_timer();                   
        if(handler_env_config.spec_support==V30)
         gen_timestamp_cs();  
        if(handler_env_config.spec_support==V30)
         run_TS_autoupdate_timer();
        if(handler_env_config.spec_support==V30)
         get_timestamp_req();
        if(pkth_config.flow_control_mode == TRANSMIT && handler_env_config.multi_vc_support == 1'b0)
          pkt_push_transmit_mode();
        if(handler_env_config.multi_vc_support == 1'b1)
        begin //{
          pkt_push_transmit_mode_vc0();
          pkt_push_transmit_mode_vc1();
          pkt_push_transmit_mode_vc2();
          pkt_push_transmit_mode_vc3();
          pkt_push_transmit_mode_vc4();
          pkt_push_transmit_mode_vc5();
          pkt_push_transmit_mode_vc6();
          pkt_push_transmit_mode_vc7();
          pkt_push_transmit_mode_vc8();
        end //}
       join_none
      end //}
     else
      pop_trans_user();  
 endtask:run_phase


////////////////////////////////////////////////////////////////////////////////////////////
/// Name: pop_pkt\n
/// Description: Task to handle received packet and control symbols. 
////////////////////////////////////////////////////////////////////////////////////////////
  task srio_pl_pkt_handler::pop_pkt();
   int i=0;
   int q_siz=0;
   forever
      begin //{
        @(negedge common_com_trans.int_clk or negedge srio_if.srio_rst_n)
        begin //{
        if(~srio_if.srio_rst_n)
        begin //{
          temp_ackid=0;
          temp_ackid2=0;
          temp_ackid3=0;
          ackid=0;
          ackid_clear=0;
          common_com_trans.curr_rx_ackid = 0;
          common_com_trans.ackid_for_scs = 0;
          outstanding_ackid=0;
          common_com_trans.status_cnt =0; 
          seq_retry_flag = 0;
          seq_pna_flag      = 1'b0;
          pkth_incr_ackid  = 1'b0; 
          seq_pa_flag      = 1'b0;
          seq_pa_ackid     = 12'b0;
          incorrect_crc    = 1'b0;
          ackid_err        = 1'b0;
          pkt_size_err     = 1'b0;
          send_lreq        = 1'b0;
          retried_ackid    = 0;
          err_choice       = 0;
          packet_open      = 0;
          common_com_trans.oes_state = 1'b0;
          common_com_trans.ors_state = 1'b0;
          common_com_trans.ies_state = 1'b0;
          common_com_trans.irs_state = 1'b0;
        end //}
        else
        begin //{ 
         if(common_com_trans.pl_rx_srio_trans_q.size() != 0)
         begin //{ 
            pkth_trans_ins = new common_com_trans.pl_rx_srio_trans_q.pop_front();
            bytestream_size = pkth_trans_ins.bytestream.size();

            if (bytestream.size()>0)
              bytestream.delete();

            bytestream = new[bytestream_size] (pkth_trans_ins.bytestream);
            if(pkth_trans_ins.transaction_kind == SRIO_PACKET && ~common_com_trans.ies_state &&  /*~common_com_trans.oes_state  &&*/ ~common_com_trans.irs_state /*&& ~common_com_trans.ors_state*/ && common_com_trans.link_initialized)
            begin //{
//Process the incoming packet
               if(pkth_config.vc_ct_mode == 1'b1 && pkth_config.flow_control_mode == RECEIVE)
               begin //{               
                  pkth_trans_ins.env_config = handler_env_config;
                  void'(pkth_trans_ins.unpack_bytes(bytestream));
                  gen_pa_cs(); 
                  if(pkth_config.response_en &&  pkth_config.pl_response_gen_mode == PL_PKT_IMMEDIATE)
                  begin //{
                    `uvm_do_callbacks(srio_pl_pkt_handler, srio_pl_callback, srio_pl_trans_received(pkth_trans_ins))
                    pl_handler_gen_put_port.put(pkth_trans_ins);
                  end //}
                  else if(pkth_config.response_en &&  pkth_config.pl_response_gen_mode == PL_PKT_RANDOM)
                  begin //{
                     pkth_trans_ins.pl_pkt_rd_cnter = 0;
                     pkth_trans_ins.pl_pkt_rd = $urandom_range(pkth_config.pl_response_delay_min,pkth_config.pl_response_delay_max); 
                     pkt_dly_q.push_back(pkth_trans_ins);
                  end //}
                  else
                  begin //{
                     `uvm_info("SRIO_PL_PKT_HANDLER : ", $sformatf("PACKET RESPONSE IS DISABLED"), UVM_LOW);
                  end //}
               end //}
               else if(pkth_config.vc_ct_mode == 1'b0 && pkth_config.flow_control_mode == RECEIVE)
               begin //{
                   pkth_trans_ins.total_pkt_bytes = bytestream.size();


                  if (bytestream[pkth_trans_ins.total_pkt_bytes-2] == 8'h00 && bytestream[pkth_trans_ins.total_pkt_bytes-1] == 8'h00)
                    pkth_trans_ins.pad = 2;
                  else
                    pkth_trans_ins.pad = 0;

                  pkth_trans_ins_2 = new pkth_trans_ins;

                  pkt_early_crc_index = pkth_trans_ins.findearlycrc();
                  pkt_final_crc_index = pkth_trans_ins.findfinalcrc();


                  pkt_early_crc_rcvd = {bytestream[pkt_early_crc_index], bytestream[pkt_early_crc_index+1]};

                  pkt_early_crc_exp = pkth_trans_ins_2.computecrc16(0, pkt_early_crc_index, 16'hFFFF);
  		  pkt_early_crc_exp_2 = pkth_trans_ins_2.computecrc16(0, pkt_early_crc_index+2, 16'hFFFF);


                  //if (pkt_final_crc_index != 0)
                  //begin //{  
                  //  pkt_final_crc_rcvd = {bytestream[pkt_final_crc_index], bytestream[pkt_final_crc_index+1]};
                  //  pkt_final_crc_exp = pkth_trans_ins_2.computecrc16(pkt_early_crc_index, pkt_final_crc_index, pkt_early_crc_rcvd);
                  //end //}
                  //else
                  //begin //{  
                  //  pkt_final_crc_rcvd = pkt_early_crc_rcvd;
                  //  pkt_final_crc_exp  =  pkt_early_crc_exp;
                  //  pkt_early_crc_rcvd = 0;
                  //  pkt_early_crc_exp  = 0;
                  //end //}

		  if (handler_env_config.srio_mode != SRIO_GEN30)
		  begin //{

                    if(bytestream.size() > pkth_config.max_pkt_size)
                       pkt_size_err = 1;
                    else
                        pkt_size_err = 0; 

		  end //}
		  else
		  begin //{

                    if(bytestream.size() > pkth_config.gen3_max_pkt_size)
                       pkt_size_err = 1;
                    else
                        pkt_size_err = 0; 

		  end //}
                   
                   pkth_trans_ins.env_config = handler_env_config;
                   void'(pkth_trans_ins.unpack_bytes(bytestream));
                   temp_ackid = pkth_trans_ins.ackid;
                  if(temp_ackid != outstanding_ackid)
                    ackid_err = 1'b1;
                  else
                    ackid_err = 1'b0;

                  temp_earlycrc = pkth_trans_ins.early_crc;
                  temp_finalcrc = pkth_trans_ins.final_crc;


  		  if (pkt_early_crc_exp_2 != 16'h0000)
		  begin //{
                   incorrect_crc = 1'b1;
		  end //}

                  if (pkt_final_crc_index != 0)
                  begin //{  

  		    pkt_final_crc_rcvd = {bytestream[pkt_final_crc_index], bytestream[pkt_final_crc_index+1]};

  		    pkt_final_crc_exp = pkth_trans_ins_2.computecrc16(pkt_early_crc_index, pkt_final_crc_index, pkt_early_crc_rcvd);
  		    pkt_final_crc_exp_2 = pkth_trans_ins_2.computecrc16(pkt_early_crc_index, pkth_trans_ins.total_pkt_bytes, pkt_early_crc_rcvd);

  		    if (pkt_final_crc_exp_2 != 16'h0000)
		    begin //{
                     incorrect_crc = 1'b1;
		    end //}

                  end //}

                  //if((temp_earlycrc != pkt_early_crc_exp ) || (temp_finalcrc != pkt_final_crc_exp))
                  //begin 
                  // incorrect_crc = 1'b1;
                  //end 
                  //else
                  //  incorrect_crc = 1'b0;
 

                   if(~ackid_err && ~pkt_size_err && ~incorrect_crc)              
                   begin //{
                       if(rx_outstanding_ackid_q.size() <= pkth_config.ackid_threshold)
                       begin //{
                        if(seq_retry_flag || seq_pna_flag)
                        begin //{
                          seq_retry_flag    = 1'b0;
                          seq_pna_flag      = 1'b0;
                        end //}
                        else
                        begin //{
                          rx_outstanding_ackid_q.push_back(pkth_trans_ins);
                          inc_outs_ackid();
                          pkth_incr_ackid = 1'b1;
                        end //}  
                       end //}
                       else
                       begin //{
                          `uvm_info("SRIO_PL_PKT_HANDLER : ", $sformatf("RX OUTSTANDING PACKET QUEUE EXCEEDED ACKID THRESHOLD"), UVM_LOW);
                       end //}
                       if(seq_pa_flag)
                       begin //{
                           seq_pa_flag = 1'b0;
                           pkth_incr_ackid = 1'b0;
                           for(int i=0;i<rx_outstanding_ackid_q.size();i++)
                           begin//{
                              seq_trans = new rx_outstanding_ackid_q[i];
                              if(seq_trans.ackid == seq_pa_ackid)
                              begin //{
                                  rx_outstanding_ackid_q.delete(i);
                                  break; 
                              end //} 
                           end //}
                       end //}
                      if(pkth_trans_ins.usr_directed_pl_ack_en)
                      begin //{
                          if(pkth_trans_ins.usr_directed_pl_ack_type == PL_ACCEPT)
                          begin //{
                                gen_pa_cs(); 
                                if(pkth_trans_ins.usr_directed_pl_response_en)
                                begin //{
                                      pkth_trans_ins.pl_pkt_rd_cnter = 0;
                                      pkth_trans_ins.pl_pkt_rd = pkth_trans_ins.usr_directed_pl_response_delay;
                                      pkt_dly_q.push_back(pkth_trans_ins);
                                end //} 
                                else
                                begin //{
                                   if(pkth_config.response_en &&  pkth_config.pl_response_gen_mode == PL_PKT_IMMEDIATE)
                                   begin //{
                                    `uvm_do_callbacks(srio_pl_pkt_handler, srio_pl_callback, srio_pl_trans_received(pkth_trans_ins))
                                     pl_handler_gen_put_port.put(pkth_trans_ins);
                                   end //}
                                   else if(pkth_config.response_en &&  pkth_config.pl_response_gen_mode == PL_PKT_RANDOM)
                                   begin //{
                                      pkth_trans_ins.pl_pkt_rd_cnter = 0;
                                      pkth_trans_ins.pl_pkt_rd = $urandom_range(pkth_config.pl_response_delay_min,pkth_config.pl_response_delay_max); 
                                      pkt_dly_q.push_back(pkth_trans_ins);
                                   end //}
                                end //} 
                          end //}
                          else if(pkth_trans_ins.usr_directed_pl_ack_type == PL_NOT_ACCEPT)
                          begin //{
                                if(rx_outstanding_ackid_q.size()!= 0 )
                                begin //{
                                 void'(rx_outstanding_ackid_q.pop_back());       
                                  if(outstanding_ackid==0)
                                   begin //{
                                    if(handler_env_config.srio_mode == SRIO_GEN30)
                                     outstanding_ackid=4095;
                                    else if(common_com_trans.bfm_idle_selected)
                                     outstanding_ackid=63 ;
                                    else 
                                     outstanding_ackid=31 ;
                                   end//}
                                  else
                                  outstanding_ackid = outstanding_ackid - 1;  
                                end //}
                                if(~common_com_trans.ies_state)
                                begin //{
                                   common_com_trans.ies_state = 1'b1;
                                end //}
                                else
                                begin //{
                                   incorrect_crc = 1'b0;
                                   ackid_err    = 1'b0;
                                   pkt_size_err = 1'b0;
                                end  //}
                          end //}
                          else if(pkth_trans_ins.usr_directed_pl_ack_type == PL_RETRY)
                          begin //{
                                  if(rx_outstanding_ackid_q.size()!= 0 )
                                  begin //{
                                   void'(rx_outstanding_ackid_q.pop_back());
                                  if(outstanding_ackid==0)
                                   begin //{
                                    if(handler_env_config.srio_mode == SRIO_GEN30)
                                     outstanding_ackid=4095;
                                    else if(common_com_trans.bfm_idle_selected)
                                     outstanding_ackid=63 ;
                                    else 
                                     outstanding_ackid=31 ;
                                   end//}
                                  else
                                    outstanding_ackid = outstanding_ackid - 1;  
                                  end //}
                                  common_com_trans.irs_state = 1'b1;
                                  gen_pr_cs();
                          end //}
                      end //} 
                      else
                      begin //{
                           randcase
                              pkth_config.pkt_accept_prob : begin //{
                                                              gen_pa_cs(); 
                                                           //   inc_ackid(); 
                                                              if(pkth_config.response_en &&  pkth_config.pl_response_gen_mode == PL_PKT_IMMEDIATE)
                                                              begin //{
                                                               `uvm_do_callbacks(srio_pl_pkt_handler, srio_pl_callback, srio_pl_trans_received(pkth_trans_ins))
                                                                pl_handler_gen_put_port.put(pkth_trans_ins);
                                                              end //}
                                                              else if(pkth_config.response_en &&  pkth_config.pl_response_gen_mode == PL_PKT_RANDOM)
                                                              begin //{
                                                                 pkth_trans_ins.pl_pkt_rd_cnter = 0;
                                                                 pkth_trans_ins.pl_pkt_rd = $urandom_range(pkth_config.pl_response_delay_min,pkth_config.pl_response_delay_max); 
                                                                 pkt_dly_q.push_back(pkth_trans_ins);
                                                              end //}
                                                              else
                                                              begin //{
                                                                 `uvm_info("SRIO_PL_PKT_HANDLER : ", $sformatf("PACKET RESPONSE IS DISABLED"), UVM_LOW);
                                                              end //}
                                                            end //} 

                              pkth_config.pkt_na_prob     : begin //{
                                                              if(rx_outstanding_ackid_q.size()!= 0 )
                                                              begin //{
                                                               void'(rx_outstanding_ackid_q.pop_back());                           
                                                               if(outstanding_ackid==0)
                                                                begin //{
                                                                 if(handler_env_config.srio_mode == SRIO_GEN30)
                                                                  outstanding_ackid=4095;
                                                                 else if(common_com_trans.bfm_idle_selected)
                                                                  outstanding_ackid=63 ;
                                                                 else 
                                                                  outstanding_ackid=31 ;
                                                                end//}
                                                               else 
                                                               outstanding_ackid = outstanding_ackid - 1;  
                                                              end//}
                                                               if(~common_com_trans.ies_state)
                                                               begin //{
                                                                  common_com_trans.ies_state = 1'b1;
                                                                  err_choice=$random;
                                                                  if(err_choice)
                                                                   ackid_err    = 1'b1;
                                                                  else
                                                                   incorrect_crc = 1'b1;
                                                               end //}
                                                               else
                                                               begin //{
                                                                  incorrect_crc = 1'b0;
                                                                  ackid_err    = 1'b0;
                                                                  pkt_size_err = 1'b0;
                                                               end  //}
                                                            end //} 

                              pkth_config.pkt_retry_prob  : begin //{
                                                              if(pkth_config.pkt_retry_support == 1'b1)
                                                              begin //{
                                                               if(rx_outstanding_ackid_q.size()!= 0 )
                                                               begin //{
                                                                void'(rx_outstanding_ackid_q.pop_back());
                                                                if(outstanding_ackid==0)
                                                                 begin //{
                                                                  if(handler_env_config.srio_mode == SRIO_GEN30)
                                                                   outstanding_ackid=4095;
                                                                  else if(common_com_trans.bfm_idle_selected)
                                                                   outstanding_ackid=63 ;
                                                                  else 
                                                                   outstanding_ackid=31 ;
                                                                 end//}
                                                                else
                                                                 outstanding_ackid = outstanding_ackid - 1;  
                                                               end //}
                                                                common_com_trans.irs_state = 1'b1;
                                                                gen_pr_cs();
                                                              end //}
                                                              else
                                                              begin //{
                                                                   `uvm_info("SRIO_PL_PKT_HANDLER : ", $sformatf("PACKET RETRY SUPPORT IS DISABLED"), UVM_LOW);
                                                              end //}
                                                            end //} 

                           endcase
                     end //}
                   end //}
                   else
                   begin  //{
                     if(~common_com_trans.ies_state)
                     begin
                        common_com_trans.ies_state = 1'b1;
                     end 
                     else
                     begin
                        incorrect_crc = 1'b0;
                        ackid_err    = 1'b0;
                        pkt_size_err = 1'b0;
                     end  
                   //  gen_pna_cs();
                   end //}  
               end //}
               else if(pkth_config.vc_ct_mode == 1'b1 && pkth_config.flow_control_mode == TRANSMIT)
               begin //{               
                  pkth_trans_ins.env_config = handler_env_config;
                  void'(pkth_trans_ins.unpack_bytes(bytestream));
                  temp_vc  = pkth_trans_ins.vc;
                  gen_pa_cs(); 
                  if(temp_vc == 0)
                  begin //{
                       if(receive_pkt_q.size() >=  pkth_config.buffer_space && handler_env_config.multi_vc_support == 1'b0)
                       begin //{
                            `uvm_info("SRIO_PL_PKT_HANDLER : ", $sformatf("PACKET IS DISCARDED BECAUSE OF LACK OF BUFFER SPACE IN FLOW CONTROL TRANSMIT CT MODE"), UVM_LOW);
                       end //}
                       else if(receive_pkt_vc0_q.size() >=  free_buf_cnt_vc0 && handler_env_config.multi_vc_support == 1'b1)
                       begin //{
                            `uvm_info("SRIO_PL_PKT_HANDLER : ", $sformatf("PACKET IS DISCARDED FOR VC0 BECAUSE OF LACK OF BUFFER SPACE IN FLOW CONTROL TRANSMIT CT MODE"), UVM_LOW);
                       end //}
                       else 
                       begin //{
                           pkth_trans_ins.pl_pkt_rd_cnter = 0;
                           pkth_trans_ins.pl_pkt_rd = $urandom_range(pkth_config.buffer_rel_min_val,pkth_config.buffer_rel_max_val); 
                           if(handler_env_config.multi_vc_support == 1'b0)
                               receive_pkt_q.push_back(pkth_trans_ins);
                           else
                               receive_pkt_vc0_q.push_back(pkth_trans_ins);
                               
                       end //}
                  end //}
                  else if(temp_vc == 1 && handler_env_config.multi_vc_support == 1'b1)
                  begin //{
                       temp_vcid = {pkth_trans_ins.prio,pkth_trans_ins.crf}; 
                       if(temp_vcid == 3'b000)
                       begin //{
                         if(receive_pkt_vc1_q.size() >= free_buf_cnt_vc1)
                         begin //{
                            `uvm_info("SRIO_PL_PKT_HANDLER : ", $sformatf("VCID1 PACKET IS DISCARDED BECAUSE OF LACK OF BUFFER SPACE IN FLOW CONTROL TRANSMIT CT MODE"), UVM_LOW);
                         end //}  
                         else
                         begin //{
                           pkth_trans_ins.pl_pkt_rd_cnter = 0;
                           pkth_trans_ins.pl_pkt_rd = $urandom_range(pkth_config.buffer_rel_min_val,pkth_config.buffer_rel_max_val); 
                           receive_pkt_vc1_q.push_back(pkth_trans_ins);
                         end //}  
                       end //}  

                       if(temp_vcid == 3'b001)
                       begin //{
                         if(receive_pkt_vc2_q.size() >= free_buf_cnt_vc2)
                         begin //{
                            `uvm_info("SRIO_PL_PKT_HANDLER : ", $sformatf("VCID2 PACKET IS DISCARDED BECAUSE OF LACK OF BUFFER SPACE IN FLOW CONTROL TRANSMIT CT MODE"), UVM_LOW);
                         end //}  
                         else
                         begin //{
                           pkth_trans_ins.pl_pkt_rd_cnter = 0;
                           pkth_trans_ins.pl_pkt_rd = $urandom_range(pkth_config.buffer_rel_min_val,pkth_config.buffer_rel_max_val); 
                           receive_pkt_vc2_q.push_back(pkth_trans_ins);
                         end //}  
                       end //}  

                       if(temp_vcid == 3'b010)
                       begin //{
                         if(receive_pkt_vc3_q.size() >= free_buf_cnt_vc3)
                         begin //{
                            `uvm_info("SRIO_PL_PKT_HANDLER : ", $sformatf("VCID3 PACKET IS DISCARDED BECAUSE OF LACK OF BUFFER SPACE IN FLOW CONTROL TRANSMIT CT MODE"), UVM_LOW);
                         end //}  
                         else
                         begin //{
                           pkth_trans_ins.pl_pkt_rd_cnter = 0;
                           pkth_trans_ins.pl_pkt_rd = $urandom_range(pkth_config.buffer_rel_min_val,pkth_config.buffer_rel_max_val); 
                           receive_pkt_vc3_q.push_back(pkth_trans_ins);
                         end //}  
                       end //}  

                       if(temp_vcid == 3'b011)
                       begin //{
                         if(receive_pkt_vc4_q.size() >= free_buf_cnt_vc4)
                         begin //{
                            `uvm_info("SRIO_PL_PKT_HANDLER : ", $sformatf("VCID4 PACKET IS DISCARDED BECAUSE OF LACK OF BUFFER SPACE IN FLOW CONTROL TRANSMIT CT MODE"), UVM_LOW);
                         end //}  
                         else
                         begin //{
                           pkth_trans_ins.pl_pkt_rd_cnter = 0;
                           pkth_trans_ins.pl_pkt_rd = $urandom_range(pkth_config.buffer_rel_min_val,pkth_config.buffer_rel_max_val); 
                           receive_pkt_vc4_q.push_back(pkth_trans_ins);
                         end //}  
                       end //}  

                       if(temp_vcid == 3'b100)
                       begin //{
                         if(receive_pkt_vc5_q.size() >= free_buf_cnt_vc5)
                         begin //{
                            `uvm_info("SRIO_PL_PKT_HANDLER : ", $sformatf("VCID5 PACKET IS DISCARDED BECAUSE OF LACK OF BUFFER SPACE IN FLOW CONTROL TRANSMIT CT MODE"), UVM_LOW);
                         end //}  
                         else
                         begin //{
                           pkth_trans_ins.pl_pkt_rd_cnter = 0;
                           pkth_trans_ins.pl_pkt_rd = $urandom_range(pkth_config.buffer_rel_min_val,pkth_config.buffer_rel_max_val); 
                           receive_pkt_vc5_q.push_back(pkth_trans_ins);
                         end //}  
                       end //}  

                       if(temp_vcid == 3'b101)
                       begin //{
                         if(receive_pkt_vc6_q.size() >= free_buf_cnt_vc6)
                         begin //{
                            `uvm_info("SRIO_PL_PKT_HANDLER : ", $sformatf("VCID6 PACKET IS DISCARDED BECAUSE OF LACK OF BUFFER SPACE IN FLOW CONTROL TRANSMIT CT MODE"), UVM_LOW);
                         end //}  
                         else
                         begin //{
                           pkth_trans_ins.pl_pkt_rd_cnter = 0;
                           pkth_trans_ins.pl_pkt_rd = $urandom_range(pkth_config.buffer_rel_min_val,pkth_config.buffer_rel_max_val); 
                           receive_pkt_vc6_q.push_back(pkth_trans_ins);
                         end //}  
                       end //}  

                       if(temp_vcid == 3'b110)
                       begin //{
                         if(receive_pkt_vc7_q.size() >= free_buf_cnt_vc7)
                         begin //{
                            `uvm_info("SRIO_PL_PKT_HANDLER : ", $sformatf("VCID7 PACKET IS DISCARDED BECAUSE OF LACK OF BUFFER SPACE IN FLOW CONTROL TRANSMIT CT MODE"), UVM_LOW);
                         end //}  
                         else
                         begin //{
                           pkth_trans_ins.pl_pkt_rd_cnter = 0;
                           pkth_trans_ins.pl_pkt_rd = $urandom_range(pkth_config.buffer_rel_min_val,pkth_config.buffer_rel_max_val); 
                           receive_pkt_vc7_q.push_back(pkth_trans_ins);
                         end //}  
                       end //}  

                       if(temp_vcid == 3'b111)
                       begin //{
                         if(receive_pkt_vc8_q.size() >= free_buf_cnt_vc8)
                         begin //{
                            `uvm_info("SRIO_PL_PKT_HANDLER : ", $sformatf("VCID8 PACKET IS DISCARDED BECAUSE OF LACK OF BUFFER SPACE IN FLOW CONTROL TRANSMIT CT MODE"), UVM_LOW);
                         end //}  
                         else
                         begin //{
                           pkth_trans_ins.pl_pkt_rd_cnter = 0;
                           pkth_trans_ins.pl_pkt_rd = $urandom_range(pkth_config.buffer_rel_min_val,pkth_config.buffer_rel_max_val); 
                           receive_pkt_vc8_q.push_back(pkth_trans_ins);
                         end //}  
                       end //}  
                  end //}  
               end //}
               else if(pkth_config.vc_ct_mode == 1'b0 && pkth_config.flow_control_mode == TRANSMIT)
               begin //{
                     pkth_trans_ins.total_pkt_bytes = bytestream.size();

                     if (bytestream[pkth_trans_ins.total_pkt_bytes-2] == 8'h00 && bytestream[pkth_trans_ins.total_pkt_bytes-1] == 8'h00)
                       pkth_trans_ins.pad = 2;
                     else
                       pkth_trans_ins.pad = 0;

                     pkth_trans_ins_2 = new pkth_trans_ins;


                     pkt_early_crc_index = pkth_trans_ins.findearlycrc();
                     pkt_final_crc_index = pkth_trans_ins.findfinalcrc();

                     pkt_early_crc_rcvd = {bytestream[pkt_early_crc_index], bytestream[pkt_early_crc_index+1]};

                     pkt_early_crc_exp = pkth_trans_ins_2.computecrc16(0, pkt_early_crc_index, 16'hFFFF);
  		     pkt_early_crc_exp_2 = pkth_trans_ins_2.computecrc16(0, pkt_early_crc_index+2, 16'hFFFF);

		     if (handler_env_config.srio_mode != SRIO_GEN30)
		     begin //{

                       if(bytestream.size() > pkth_config.max_pkt_size)
                          pkt_size_err = 1;
                       else
                           pkt_size_err = 0; 

		     end //}
		     else
		     begin //{

                       if(bytestream.size() > pkth_config.gen3_max_pkt_size)
                          pkt_size_err = 1;
                       else
                           pkt_size_err = 0; 

		     end //}
                   
                     pkth_trans_ins.env_config = handler_env_config;
                     void'(pkth_trans_ins.unpack_bytes(bytestream));
                     temp_ackid = pkth_trans_ins.ackid;

                   //  if(temp_ackid != common_com_trans.curr_rx_ackid)
                     if(temp_ackid != outstanding_ackid)
                       ackid_err = 1'b1;
                     else
                       ackid_err = 1'b0;

                     temp_earlycrc = pkth_trans_ins.early_crc;
                     temp_finalcrc = pkth_trans_ins.final_crc;

                     //if((temp_earlycrc != pkt_early_crc_exp ) && (temp_finalcrc != pkt_final_crc_exp))
                     //begin 
                     // incorrect_crc = 1'b1;
                     //end 
                     //else
                     //  incorrect_crc = 1'b0;

  		     if (pkt_early_crc_exp_2 != 16'h0000)
		     begin //{
                      incorrect_crc = 1'b1;
		     end //}

                     if (pkt_final_crc_index != 0)
                     begin //{  

                       pkt_final_crc_rcvd = {bytestream[pkt_final_crc_index], bytestream[pkt_final_crc_index+1]};
                       pkt_final_crc_exp = pkth_trans_ins_2.computecrc16(pkt_early_crc_index, pkt_final_crc_index, pkt_early_crc_rcvd);
  		       pkt_final_crc_exp_2 = pkth_trans_ins_2.computecrc16(pkt_early_crc_index, pkth_trans_ins.total_pkt_bytes, pkt_early_crc_rcvd);

  		       if (pkt_final_crc_exp_2 != 16'h0000)
		       begin //{
                        incorrect_crc = 1'b1;
		       end //}

                     end //}
                     else
                     begin //{  
                       pkt_final_crc_rcvd = 16'h0000;
                       pkt_final_crc_exp  = 16'h0000;
                     end //}
                      

                     if(~ackid_err && ~pkt_size_err && ~incorrect_crc)              
                     begin //{
                        if(rx_outstanding_ackid_q.size() <= pkth_config.ackid_threshold)
                        begin //{
                         rx_outstanding_ackid_q.push_back(pkth_trans_ins);
                         inc_outs_ackid();
                        end //}
                        else
                        begin //{
                           `uvm_info("SRIO_PL_PKT_HANDLER : ", $sformatf("RX OUTSTANDING PACKET QUEUE EXCEEDED ACKID THRESHOLD"), UVM_LOW);
                        end //}
                         temp_vc  = pkth_trans_ins.vc;
                         if(temp_vc == 0)
                         begin //{
                              if(receive_pkt_q.size() >=  pkth_config.buffer_space && handler_env_config.multi_vc_support == 1'b0)
                              begin //{
                                 if(rx_outstanding_ackid_q.size()!= 0 )
                                 begin //{
                                  void'(rx_outstanding_ackid_q.pop_back());
                                  if(outstanding_ackid==0)
                                   begin //{
                                    if(handler_env_config.srio_mode == SRIO_GEN30)
                                     outstanding_ackid=4095;
                                    else if(common_com_trans.bfm_idle_selected)
                                     outstanding_ackid=63 ;
                                    else
                                     outstanding_ackid=31 ;
                                   end//}
                                  else 				  
                                   outstanding_ackid = outstanding_ackid - 1;  
                                 end //}
                                 common_com_trans.irs_state = 1'b1;
                                 gen_pr_cs();
                                   `uvm_info("SRIO_PL_PKT_HANDLER : ", $sformatf("PACKET IS RETRIED BECAUSE OF LACK OF BUFFER SPACE IN FLOW CONTROL TRANSMIT RT MODE"), UVM_LOW);
                              end //}
                              else if(receive_pkt_vc0_q.size() >=  free_buf_cnt_vc0 && handler_env_config.multi_vc_support == 1'b1)
                              begin //{
                                 if(rx_outstanding_ackid_q.size()!= 0 )
                                 begin //{
                                  void'(rx_outstanding_ackid_q.pop_back());
                                  if(outstanding_ackid==0)
                                   begin //{
                                    if(handler_env_config.srio_mode == SRIO_GEN30)
                                     outstanding_ackid=4095;
                                    else if(common_com_trans.bfm_idle_selected)
                                     outstanding_ackid=63 ;
                                    else 
                                     outstanding_ackid=31 ;
                                   end//}
                                  else
                                   outstanding_ackid = outstanding_ackid - 1;  
                                 end //}
                                 common_com_trans.irs_state = 1'b1;
                                 gen_pr_cs();
                                   `uvm_info("SRIO_PL_PKT_HANDLER : ", $sformatf("PACKET IS RETRIED FOR VC0 BECAUSE OF LACK OF BUFFER SPACE IN FLOW CONTROL TRANSMIT RT MODE"), UVM_LOW);
                              end //}
                              else 
                              begin //{
                                  pkth_trans_ins.pl_pkt_rd_cnter = 0;
                                  pkth_trans_ins.pl_pkt_rd = $urandom_range(pkth_config.buffer_rel_min_val,pkth_config.buffer_rel_max_val); 
                                  if(handler_env_config.multi_vc_support == 1'b0)
                                      receive_pkt_q.push_back(pkth_trans_ins);
                                  else
                                      receive_pkt_vc0_q.push_back(pkth_trans_ins);
                                  gen_pa_cs(); 
                              end //}
                         end //}
                         else if(temp_vc == 1 && handler_env_config.multi_vc_support == 1'b1)
                         begin //{
                              temp_vcid = {pkth_trans_ins.prio,pkth_trans_ins.crf}; 
                              if(temp_vcid == 3'b000)
                              begin //{
                                if(receive_pkt_vc1_q.size() >= free_buf_cnt_vc1)
                                begin //{
                                 if(rx_outstanding_ackid_q.size()!= 0 )
                                 begin //{
                                  void'(rx_outstanding_ackid_q.pop_back()); 
                                  if(outstanding_ackid==0)
                                   begin //{
                                    if(handler_env_config.srio_mode == SRIO_GEN30)
                                     outstanding_ackid=4095;
                                    else if(common_com_trans.bfm_idle_selected)
                                     outstanding_ackid=63 ;
                                    else 
                                     outstanding_ackid=31 ;
                                   end//}
                                  else
                                   outstanding_ackid = outstanding_ackid - 1;  
                                 end //}
                                 common_com_trans.irs_state = 1'b1;
                                 gen_pr_cs();
                                   `uvm_info("SRIO_PL_PKT_HANDLER : ", $sformatf("VCID1 PACKET IS RETRIED BECAUSE OF LACK OF BUFFER SPACE IN FLOW CONTROL TRANSMIT RT MODE"), UVM_LOW);
                                end //}  
                                else
                                begin //{
                                  pkth_trans_ins.pl_pkt_rd_cnter = 0;
                                  pkth_trans_ins.pl_pkt_rd = $urandom_range(pkth_config.buffer_rel_min_val,pkth_config.buffer_rel_max_val); 
                                  receive_pkt_vc1_q.push_back(pkth_trans_ins);
                                  gen_pa_cs(); 
                                end //}  
                              end //}  

                              if(temp_vcid == 3'b001)
                              begin //{
                                if(receive_pkt_vc2_q.size() >= free_buf_cnt_vc2)
                                begin //{
                                 if(rx_outstanding_ackid_q.size()!= 0 )
                                 begin //{
                                  void'(rx_outstanding_ackid_q.pop_back());
                                  if(outstanding_ackid==0)
                                   begin //{
                                    if(handler_env_config.srio_mode == SRIO_GEN30)
                                     outstanding_ackid=4095;
                                    else if(common_com_trans.bfm_idle_selected)
                                     outstanding_ackid=63 ;
                                    else 
                                     outstanding_ackid=31 ;
                                   end//}
                                  else
                                   outstanding_ackid = outstanding_ackid - 1;  
                                 end //}
                                 common_com_trans.irs_state = 1'b1;
                                 gen_pr_cs();
                                   `uvm_info("SRIO_PL_PKT_HANDLER : ", $sformatf("VCID2 PACKET IS RETRIED BECAUSE OF LACK OF BUFFER SPACE IN FLOW CONTROL TRANSMIT RT MODE"), UVM_LOW);
                                end //}  
                                else
                                begin //{
                                  pkth_trans_ins.pl_pkt_rd_cnter = 0;
                                  pkth_trans_ins.pl_pkt_rd = $urandom_range(pkth_config.buffer_rel_min_val,pkth_config.buffer_rel_max_val); 
                                  receive_pkt_vc2_q.push_back(pkth_trans_ins);
                                  gen_pa_cs(); 
                                end //}  
                              end //}  

                              if(temp_vcid == 3'b010)
                              begin //{
                                if(receive_pkt_vc3_q.size() >= free_buf_cnt_vc3)
                                begin //{
                                 if(rx_outstanding_ackid_q.size()!= 0 )
                                 begin //{
                                  void'(rx_outstanding_ackid_q.pop_back());
                                  if(outstanding_ackid==0)
                                   begin //{
                                    if(handler_env_config.srio_mode == SRIO_GEN30)
                                     outstanding_ackid=4095;
                                    else if(common_com_trans.bfm_idle_selected)
                                     outstanding_ackid=63 ;
                                    else 
                                     outstanding_ackid=31 ;
                                   end//}
                                  else
                                   outstanding_ackid = outstanding_ackid - 1;  
                                 end //}
                                 common_com_trans.irs_state = 1'b1;
                                 gen_pr_cs();
                                   `uvm_info("SRIO_PL_PKT_HANDLER : ", $sformatf("VCID3 PACKET IS RETRIED BECAUSE OF LACK OF BUFFER SPACE IN FLOW CONTROL TRANSMIT RT MODE"), UVM_LOW);
                                end //}  
                                else
                                begin //{
                                  pkth_trans_ins.pl_pkt_rd_cnter = 0;
                                  pkth_trans_ins.pl_pkt_rd = $urandom_range(pkth_config.buffer_rel_min_val,pkth_config.buffer_rel_max_val); 
                                  receive_pkt_vc3_q.push_back(pkth_trans_ins);
                                  gen_pa_cs(); 
                                end //}  
                              end //}  

                              if(temp_vcid == 3'b011)
                              begin //{
                                if(receive_pkt_vc4_q.size() >= free_buf_cnt_vc4)
                                begin //{
                                 if(rx_outstanding_ackid_q.size()!= 0 )
                                 begin //{
                                  void'(rx_outstanding_ackid_q.pop_back());
                                  if(outstanding_ackid==0)
                                   begin //{
                                    if(handler_env_config.srio_mode == SRIO_GEN30)
                                     outstanding_ackid=4095;
                                    else if(common_com_trans.bfm_idle_selected)
                                     outstanding_ackid=63 ;
                                    else 
                                     outstanding_ackid=31 ;
                                   end//}
                                  else
                                   outstanding_ackid = outstanding_ackid - 1;  
                                 end //}
                                 common_com_trans.irs_state = 1'b1;
                                 gen_pr_cs();
                                   `uvm_info("SRIO_PL_PKT_HANDLER : ", $sformatf("VCID4 PACKET IS RETRIED BECAUSE OF LACK OF BUFFER SPACE IN FLOW CONTROL TRANSMIT RT MODE"), UVM_LOW);
                                end //}  
                                else
                                begin //{
                                  pkth_trans_ins.pl_pkt_rd_cnter = 0;
                                  pkth_trans_ins.pl_pkt_rd = $urandom_range(pkth_config.buffer_rel_min_val,pkth_config.buffer_rel_max_val); 
                                  receive_pkt_vc4_q.push_back(pkth_trans_ins);
                                  gen_pa_cs(); 
                                end //}  
                              end //}  

                              if(temp_vcid == 3'b100)
                              begin //{
                                if(receive_pkt_vc5_q.size() >= free_buf_cnt_vc5)
                                begin //{
                                 if(rx_outstanding_ackid_q.size()!= 0 )
                                 begin //{
                                  void'(rx_outstanding_ackid_q.pop_back());
                                  if(outstanding_ackid==0)
                                   begin //{
                                    if(handler_env_config.srio_mode == SRIO_GEN30)
                                     outstanding_ackid=4095;
                                    else if(common_com_trans.bfm_idle_selected)
                                     outstanding_ackid=63 ;
                                    else 
                                     outstanding_ackid=31 ;
                                   end//}
                                  else
                                   outstanding_ackid = outstanding_ackid - 1;  
                                 end //}
                                 common_com_trans.irs_state = 1'b1;
                                 gen_pr_cs();
                                   `uvm_info("SRIO_PL_PKT_HANDLER : ", $sformatf("VCID5 PACKET IS RETRIED BECAUSE OF LACK OF BUFFER SPACE IN FLOW CONTROL TRANSMIT RT MODE"), UVM_LOW);
                                end //}  
                                else
                                begin //{
                                  pkth_trans_ins.pl_pkt_rd_cnter = 0;
                                  pkth_trans_ins.pl_pkt_rd = $urandom_range(pkth_config.buffer_rel_min_val,pkth_config.buffer_rel_max_val); 
                                  receive_pkt_vc5_q.push_back(pkth_trans_ins);
                                  gen_pa_cs(); 
                                end //}  
                              end //}  

                              if(temp_vcid == 3'b101)
                              begin //{
                                if(receive_pkt_vc6_q.size() >= free_buf_cnt_vc6)
                                begin //{
                                 if(rx_outstanding_ackid_q.size()!= 0 )
                                 begin //{
                                  void'(rx_outstanding_ackid_q.pop_back());
                                  if(outstanding_ackid==0)
                                   begin //{
                                    if(handler_env_config.srio_mode == SRIO_GEN30)
                                     outstanding_ackid=4095;
                                    else if(common_com_trans.bfm_idle_selected)
                                     outstanding_ackid=63 ;
                                    else 
                                     outstanding_ackid=31 ;
                                   end//}
                                  else
                                   outstanding_ackid = outstanding_ackid - 1;  
                                 end//}
                                 common_com_trans.irs_state = 1'b1;
                                 gen_pr_cs();
                                   `uvm_info("SRIO_PL_PKT_HANDLER : ", $sformatf("VCID6 PACKET IS RETRIED BECAUSE OF LACK OF BUFFER SPACE IN FLOW CONTROL TRANSMIT RT MODE"), UVM_LOW);
                                end //}  
                                else
                                begin //{
                                  pkth_trans_ins.pl_pkt_rd_cnter = 0;
                                  pkth_trans_ins.pl_pkt_rd = $urandom_range(pkth_config.buffer_rel_min_val,pkth_config.buffer_rel_max_val); 
                                  receive_pkt_vc6_q.push_back(pkth_trans_ins);
                                  gen_pa_cs(); 
                                end //}  
                              end //}  

                              if(temp_vcid == 3'b110)
                              begin //{
                                if(receive_pkt_vc7_q.size() >= free_buf_cnt_vc7)
                                begin //{
                                 if(rx_outstanding_ackid_q.size()!= 0 )
                                 begin //{
                                  void'(rx_outstanding_ackid_q.pop_back());
                                  if(outstanding_ackid==0)
                                   begin //{
                                    if(handler_env_config.srio_mode == SRIO_GEN30)
                                     outstanding_ackid=4095;
                                    else if(common_com_trans.bfm_idle_selected)
                                     outstanding_ackid=63 ;
                                    else 
                                     outstanding_ackid=31 ;
                                   end//}
                                  else
                                   outstanding_ackid = outstanding_ackid - 1;  
                                 end //}
                                 common_com_trans.irs_state = 1'b1;
                                 gen_pr_cs();
                                   `uvm_info("SRIO_PL_PKT_HANDLER : ", $sformatf("VCID7 PACKET IS RETRIED BECAUSE OF LACK OF BUFFER SPACE IN FLOW CONTROL TRANSMIT RT MODE"), UVM_LOW);
                                end //}  
                                else
                                begin //{
                                  pkth_trans_ins.pl_pkt_rd_cnter = 0;
                                  pkth_trans_ins.pl_pkt_rd = $urandom_range(pkth_config.buffer_rel_min_val,pkth_config.buffer_rel_max_val); 
                                  receive_pkt_vc7_q.push_back(pkth_trans_ins);
                                  gen_pa_cs(); 
                                end //}  
                              end //}  

                              if(temp_vcid == 3'b111)
                              begin //{
                                if(receive_pkt_vc8_q.size() >= free_buf_cnt_vc8)
                                begin //{
                                 if(rx_outstanding_ackid_q.size()!= 0 )
                                 begin //{
                                  void'(rx_outstanding_ackid_q.pop_back());
                                  if(outstanding_ackid==0)
                                   begin //{
                                    if(handler_env_config.srio_mode == SRIO_GEN30)
                                     outstanding_ackid=4095;
                                    else if(common_com_trans.bfm_idle_selected)
                                     outstanding_ackid=63 ;
                                    else 
                                     outstanding_ackid=31 ;
                                   end//}
                                  else
                                   outstanding_ackid = outstanding_ackid - 1;  
                                 end //}
                                 common_com_trans.irs_state = 1'b1;
                                 gen_pr_cs();
                                   `uvm_info("SRIO_PL_PKT_HANDLER : ", $sformatf("VCID8 PACKET IS RETRIED BECAUSE OF LACK OF BUFFER SPACE IN FLOW CONTROL TRANSMIT RT MODE"), UVM_LOW);
                                end //}  
                                else
                                begin //{
                                  pkth_trans_ins.pl_pkt_rd_cnter = 0;
                                  pkth_trans_ins.pl_pkt_rd = $urandom_range(pkth_config.buffer_rel_min_val,pkth_config.buffer_rel_max_val); 
                                  receive_pkt_vc8_q.push_back(pkth_trans_ins);
                                  gen_pa_cs(); 
                                end //}  
                              end //}  
                         end //}  
               end //}
               else
               begin  //{
                 if(~common_com_trans.ies_state)
                 begin
                    common_com_trans.ies_state = 1'b1;
                 end 
                 else
                 begin
                    incorrect_crc = 1'b0;
                    ackid_err    = 1'b0;
                    pkt_size_err = 1'b0;
                 end  
               end //}  
              end //}
            end //}
            else if(pkth_trans_ins.transaction_kind == SRIO_CS && (common_com_trans.oes_state || common_com_trans.ies_state ||common_com_trans.ors_state ||common_com_trans.irs_state) && common_com_trans.link_initialized)
            begin //{
//Process incoming Control symbol while in error state
                `uvm_do_callbacks(srio_pl_pkt_handler, srio_pl_callback, srio_pl_trans_received(pkth_trans_ins))


                 //  if(gen3_stype1 == 8'h22)
                 //  begin //{
                 //  end //}

                 //  if(gen3_stype1 == 8'h23)
                 //  begin //{
                 //  end //}
                if(handler_env_config.srio_mode == SRIO_GEN30)
                begin //{
                  temp_cs_crc24 = pkth_trans_ins.cs_crc24;        
                  pkth_trans_ins.cstype = CS64; 
                end //}
                else if(common_com_trans.bfm_idle_selected)
                begin //{
                  temp_cs_crc13 = pkth_trans_ins.cs_crc13;        
                end //}
                else
                begin //{
                  temp_cs_crc5 = pkth_trans_ins.cs_crc5;        
                end //}
                if(handler_env_config.srio_mode != SRIO_GEN30)
                  pkth_trans_ins.delimiter =  (pkth_trans_ins.cs_kind == SRIO_DELIM_PD) ? 8'h7C : 8'h1C;
                cs_val =  pkth_trans_ins.pack_cs();
                if(handler_env_config.srio_mode == SRIO_GEN30)
                  calc_crc24 =  pkth_trans_ins.calccrc24(pkth_trans_ins.pack_cs());  
                else if(common_com_trans.bfm_idle_selected)
                  calc_crc13 =  pkth_trans_ins.calccrc13(cs_val);  
                else
                  calc_crc5  = pkth_trans_ins.calccrc5(cs_val);  
                if((handler_env_config.srio_mode == SRIO_GEN30) && (calc_crc24 != temp_cs_crc24))
                   cs_crc_err = 1'b1;
                else if(common_com_trans.bfm_idle_selected && (calc_crc13 != temp_cs_crc13))
                   cs_crc_err = 1'b1;
                else if(~common_com_trans.bfm_idle_selected && (calc_crc5 != temp_cs_crc5)) 
                   cs_crc_err = 1'b1;
                else
                   cs_crc_err = 1'b0;

                if(cs_crc_err)
                begin //{
                   if(~common_com_trans.ies_state)
                   begin //{
                    common_com_trans.ies_state = 1'b1;
                   end //}
                   else
                       cs_crc_err = 1'b0;
                    end //} 
                   else
                    begin//{
                    if(handler_env_config.srio_mode == SRIO_GEN30)
                    begin //{
                    gen3_stype1 = {pkth_trans_ins.brc3_stype1_msb,pkth_trans_ins.stype1,pkth_trans_ins.cmd};
                    if(gen3_stype1 == 8'h24)
                    begin //{
                       if((pkth_config.multiple_ack_support && pkth_config.ackid_status_pnack_support)) 
                        common_com_trans.ies_state = 1'b0;
                       common_com_trans.irs_state = 1'b0;
                       gen_lresp_cs();
                       seq_pna_flag = 1'b0;
                       pkth_incr_ackid = 1'b0;
                    end //}

                    if(gen3_stype1 == 8'h18)
                    begin //{
                       common_com_trans.irs_state = 1'b0;
                       seq_retry_flag = 1'b0;
                       pkth_incr_ackid = 1'b0;
                    end //}
                    
                 end //}
                 else 
                 begin //{
                    // stype1 lreq rxed gen lresp
                    if(pkth_trans_ins.stype1 == 3'b100 && pkth_trans_ins.cmd == 3'b100 && pkth_trans_ins.brc3_stype1_msb == 2'b00)
                    begin //{ 
                      if((pkth_config.multiple_ack_support && pkth_config.ackid_status_pnack_support)) 
                       common_com_trans.ies_state = 1'b0;
                       common_com_trans.irs_state = 1'b0;
                      gen_lresp_cs();
                      if(handler_env_config.multi_vc_support == 1'b1)
                      begin //{
                        gen_status_cs();
                        if(handler_env_config.vc_num_support == 1)
                        begin //{
                           gen_vc_status_cs(3'b001);
                        end //}
                        else if(handler_env_config.vc_num_support == 2)
                        begin //{
                           gen_vc_status_cs(3'b001);
                           gen_vc_status_cs(3'b101);
                        end //}
                        else if(handler_env_config.vc_num_support == 4)
                        begin //{
                           gen_vc_status_cs(3'b001);
                           gen_vc_status_cs(3'b011);
                           gen_vc_status_cs(3'b101);
                           gen_vc_status_cs(3'b111);
                        end //}
                        else if(handler_env_config.vc_num_support == 8)
                        begin //{
                           gen_vc_status_cs(3'b000);
                           gen_vc_status_cs(3'b001);
                           gen_vc_status_cs(3'b010);
                           gen_vc_status_cs(3'b011);
                           gen_vc_status_cs(3'b100);
                           gen_vc_status_cs(3'b101);
                           gen_vc_status_cs(3'b110);
                           gen_vc_status_cs(3'b111);
                        end //}
                      end //}
              //        common_com_trans.ies_state = 1'b0;
                      seq_pna_flag = 1'b0;
                      pkth_incr_ackid = 1'b0;
                    end //}
                    // rfr rxed clear irs
                    if(pkth_trans_ins.stype1 == 3'b011 && pkth_trans_ins.cmd == 3'b000 && pkth_trans_ins.brc3_stype1_msb == 2'b00)
                    begin //{
                      common_com_trans.irs_state = 1'b0;
                      seq_retry_flag = 1'b0;
                      pkth_incr_ackid = 1'b0;
                    end //} 
                 end //}  

                 // status cs rxed for multi vc
                 if(pkth_trans_ins.stype0 == 4'b0101)
                 begin //{
                    vcid_status =  pkth_trans_ins.param0;
                    if(vcid_status == 12'h000)
                      vcid1_buf_status = pkth_trans_ins.param1;
                    else if(vcid_status == 12'h001)
                      vcid2_buf_status = pkth_trans_ins.param1; 
                    else if(vcid_status == 12'h002)
                      vcid3_buf_status = pkth_trans_ins.param1; 
                    else if(vcid_status == 12'h003)
                      vcid4_buf_status = pkth_trans_ins.param1; 
                    else if(vcid_status == 12'h004)
                      vcid5_buf_status = pkth_trans_ins.param1; 
                    else if(vcid_status == 12'h005)
                      vcid6_buf_status = pkth_trans_ins.param1; 
                    else if(vcid_status == 12'h006)
                      vcid7_buf_status = pkth_trans_ins.param1; 
                    else if(vcid_status == 12'h007)
                      vcid8_buf_status = pkth_trans_ins.param1; 
                 end //}


                 if((pkth_config.multiple_ack_support && pkth_config.ackid_status_pnack_support) && send_lreq)
                  begin//{ 
                   common_com_trans.oes_state = 1'b0;
                   send_lreq=1'b0;   
                  end//}
                 // pna rxed enter oes state
                 if(pkth_trans_ins.stype0 == 4'b0010 && common_com_trans.ism_change_req == FALSE)
                 begin //{
                    if(~common_com_trans.oes_state )   
                    gen_linkreq_cs();
                    common_com_trans.oes_state = 1'b1;   
                    if((pkth_config.multiple_ack_support && pkth_config.ackid_status_pnack_support))
                     send_lreq=1'b1;
                    notaccepted_ackid = pkth_trans_ins.param0;
                           if(pkth_config.multiple_ack_support)
                            begin//{
                             ackid=notaccepted_ackid;
                             if(common_com_trans.mul_ack_min<common_com_trans.mul_ack_max)
                              begin//{
                               q_siz=pkt_merge_ins.pl_outstanding_ackid_q.size();
                               for(int j=0;j<q_siz;j++)
                                begin //{
                                 ackid_pkt_trans = new pkt_merge_ins.pl_outstanding_ackid_q[0];
                                 if(ackid_pkt_trans.ackid <notaccepted_ackid) 
                                  begin //{
                                   pkt_merge_ins.pl_outstanding_ackid_q.delete(0);
                                  end //}
                                   if(ackid_pkt_trans.ackid == notaccepted_ackid)
                                   break;
                                end //}
                              end//}
                              else if(common_com_trans.mul_ack_min>common_com_trans.mul_ack_max)
                               begin//{
                                q_siz=pkt_merge_ins.pl_outstanding_ackid_q.size();
                                for(int i=0;i<q_siz;i++)
                                 begin //{
                                  q_siz=pkt_merge_ins.pl_outstanding_ackid_q.size();
                                   for(int i=0;i<q_siz;i++)
                                    begin //{
                                     ackid_pkt_trans = new pkt_merge_ins.pl_outstanding_ackid_q[i];
                                     if(ackid_pkt_trans.ackid==notaccepted_ackid)
                                      begin//{
                                       for(int k=0;k<i;k++)
begin
                                 ackid_pkt_trans = new pkt_merge_ins.pl_outstanding_ackid_q[0];
                                         pkt_merge_ins.pl_outstanding_ackid_q.delete(0);
end
                                        break;
                                      end//}
                                    end //}
                                   end //}
                                 end //}
                               end//}
                             for(int i=0;i<pkt_merge_ins.pl_outstanding_ackid_q.size();i++)
                             begin //{
                                ackid_pkt_trans = new pkt_merge_ins.pl_outstanding_ackid_q[i];
                             end //}
                              common_com_trans.mul_ack_min=notaccepted_ackid;
                 end //}

                 // lresp rxed clear oes
                 if(pkth_trans_ins.stype0 == 4'b0110)
                 begin //{
                   common_com_trans.oes_state = 1'b0;
                   ackid_status = pkth_trans_ins.param0;
                   buff_status  = pkth_trans_ins.param1;
                   for(int i=0;i<rx_outstanding_ackid_q.size();i++)
                   begin //{
                      del_trans = new rx_outstanding_ackid_q[i]; 
                      if(del_trans.ackid <= ackid_status)
                      begin //{
                         rx_outstanding_ackid_q.delete(i);
                      end //}
                   end //}
                 //  outstanding_ackid =  ackid_status;
                      seq_pna_flag = 1'b0;
                      pkth_incr_ackid = 1'b0;
                 end //} 

                 // packet retry cs rxed and exit ors
                 if(pkth_trans_ins.stype0 == 4'b0001)
                 begin //{
                   retried_ackid = pkth_trans_ins.param0;
                   buff_status   = pkth_trans_ins.param1; 
                   common_com_trans.ors_state = 1'b1;
                   if(common_com_trans.oes_state)
                     gen_linkreq_cs();
                   else
                   gen_rfr_cs();    
                   if(pkth_config.multiple_ack_support)
                     begin//{
                      ackid=retried_ackid;
                      if(common_com_trans.mul_ack_min<common_com_trans.mul_ack_max)
                       begin//{
                        q_siz=pkt_merge_ins.pl_outstanding_ackid_q.size();
                        for(int j=0;j<q_siz;j++)
                         begin //{
                          ackid_pkt_trans = new pkt_merge_ins.pl_outstanding_ackid_q[0];
                          if(ackid_pkt_trans.ackid < retried_ackid) 
                            pkt_merge_ins.pl_outstanding_ackid_q.delete(0);
                          if(ackid_pkt_trans.ackid == (retried_ackid))
                            break;
                 end //} 
                       end//}
                       else if(common_com_trans.mul_ack_min>common_com_trans.mul_ack_max)
                        begin//{
                         q_siz=pkt_merge_ins.pl_outstanding_ackid_q.size();
                         for(int i=0;i<q_siz;i++)
                          begin //{
                           ackid_pkt_trans = new pkt_merge_ins.pl_outstanding_ackid_q[0];
                           if(ackid_pkt_trans.ackid == retried_ackid) 
                            begin //{
                             for(int k=0;k<i;k++)
                             pkt_merge_ins.pl_outstanding_ackid_q.delete(0);
                             break;
                            end //}
                          end //}
                        end//}
                     end//}
                    common_com_trans.mul_ack_min=retried_ackid;
                  end //} 

                 if(pkth_trans_ins.stype0 == 4'b0000)
                 begin //{ 
                       ackid_clear =  pkth_trans_ins.param0;
                       if(handler_env_config.srio_mode == SRIO_GEN30)
                       begin //{ 
                         ackid = ackid_clear + 1;
                       end //}
                       else if(common_com_trans.bfm_idle_selected)
                       begin //{ 
                         if(ackid_clear == 63)
                           ackid = 0;
                         else 
                           ackid = ackid_clear + 1;
                       end //}
                       else
                       begin //{ 
                         if(ackid_clear == 31)
                           ackid = 0;
                         else 
                           ackid = ackid_clear + 1;
                       end //}
                           if(pkth_config.multiple_ack_support)
                            begin//{
                             if(common_com_trans.mul_ack_min<common_com_trans.mul_ack_max)
                              begin//{
                               q_siz=pkt_merge_ins.pl_outstanding_ackid_q.size();
                               for(int j=0;j<q_siz;j++)
                                begin //{
                                 ackid_pkt_trans = new pkt_merge_ins.pl_outstanding_ackid_q[0];
                                 if(ackid_pkt_trans.ackid <= ackid_clear) 
                                  begin //{
                                   pkt_merge_ins.pl_outstanding_ackid_q.delete(0);
                                   if(ackid_pkt_trans.ackid == ackid_clear)
                                   break;
                                  end //}
                                end //}
                              end//}
                              else if(common_com_trans.mul_ack_min>common_com_trans.mul_ack_max)
                               begin//{
                                q_siz=pkt_merge_ins.pl_outstanding_ackid_q.size();
                                for(int i=0;i<q_siz;i++)
                                 begin //{
                                  ackid_pkt_trans = new pkt_merge_ins.pl_outstanding_ackid_q[0];
                                  if((ackid_pkt_trans.ackid >= common_com_trans.mul_ack_min) || (ackid_pkt_trans.ackid <= common_com_trans.mul_ack_max)) 
                                   begin //{
                                    pkt_merge_ins.pl_outstanding_ackid_q.delete(0);
                                    if(ackid_pkt_trans.ackid == ackid_clear)
                                    break;
                                   end //}
                                 end //}
                               end//}
                              else if(common_com_trans.mul_ack_min==common_com_trans.mul_ack_max)
                               begin//{
                                q_siz=pkt_merge_ins.pl_outstanding_ackid_q.size();
                                for(int i=0;i<q_siz;i++)
                                 begin //{
                                  ackid_pkt_trans = new pkt_merge_ins.pl_outstanding_ackid_q[i];
                                  if(ackid_pkt_trans.ackid == ackid_clear) 
                                   begin //{
                                    pkt_merge_ins.pl_outstanding_ackid_q.delete(i);
                                    //if(ackid_pkt_trans.ackid == ackid_clear)
                                    break;
                                   end //}
                                 end //}
                              end//}
                            end//}
                           else
                            begin//{
                     // clear pktcs outstanding queue
                    for(int i=0;i<pkt_merge_ins.pl_outstanding_ackid_q.size();i++)
                    begin //{
                       ackid_pkt_trans = new pkt_merge_ins.pl_outstanding_ackid_q[i];
                       if(ackid_pkt_trans.ackid == ackid_clear) 
                       begin //{
                        pkt_merge_ins.pl_outstanding_ackid_q.delete(i);
                        break;
                       end //}
                    end //}
                  end//}
                           common_com_trans.mul_ack_min=ackid;
                             for(int i=0;i<pkt_merge_ins.pl_outstanding_ackid_q.size();i++)
                             begin //{
                                ackid_pkt_trans = new pkt_merge_ins.pl_outstanding_ackid_q[i];
                    end //}
                 end //}

                  // status cs rxed ackid check
                  if(pkth_trans_ins.stype0 == 4'b0100)
                  begin //{
                      temp_ackid2 =  pkth_trans_ins.param0;
                      if(common_com_trans.bfm_idle_selected)
                      begin //{
                        if(pkth_trans_ins.param1 != 6'h3F)
                           vc0_buf_status = pkth_trans_ins.param1;
                      end //}
                      else
                      begin //{
                        if(pkth_trans_ins.param1[1:5] != 5'h1F)
                          vc0_buf_status = pkth_trans_ins.param1[1:5];
                      end //}
 
                     if(ackid != temp_ackid2)
                     begin //{
                       `uvm_info("SRIO_PL_PKT_HANDLER : ", $sformatf("Ackid and Status Ackid Not Matched temp_ackid2=%d,ackid=%d",temp_ackid2,ackid), UVM_LOW);
                     end //}
                      
                  end //}

                 // rx buffer status in transmit flow control
                 if(handler_env_config.multi_vc_support == 1 && pkth_config.flow_control_mode == TRANSMIT)
                 begin //{
                    rxed_buf_status =  vcid1_buf_status + vcid2_buf_status + vcid3_buf_status + vcid4_buf_status + vcid5_buf_status + vcid6_buf_status + vcid7_buf_status + vcid8_buf_status + vc0_buf_status;
                 end //}
                 else if(handler_env_config.multi_vc_support == 0 && pkth_config.flow_control_mode == TRANSMIT)
                 begin //{
                     rxed_buf_status = vc0_buf_status;
                 end //}
            end //}
            end //}
            else if(pkth_trans_ins.transaction_kind == SRIO_CS && ~common_com_trans.ies_state &&  ~common_com_trans.oes_state  && ~common_com_trans.irs_state && ~common_com_trans.ors_state)
            begin //{
                if((pkth_trans_ins.stype1==0) && ~packet_open)
                 packet_open=1;
                if(pkth_trans_ins.stype1==1 || pkth_trans_ins.stype1==2 || pkth_trans_ins.stype1==4)
                 packet_open=0;
//Process incoming Control symbol 
                if(handler_env_config.srio_mode != SRIO_GEN30)
                begin //{
                 if(((pkth_trans_ins.stype1==0) || (pkth_trans_ins.stype1==1) || (pkth_trans_ins.stype1==2)) && pkth_trans_ins.cs_kind == SRIO_DELIM_SC)
                   begin//{
                    inv_ilgl_err=1'b1;
                    common_com_trans.ies_state = 1'b1;
                   end//}
                 if(((pkth_trans_ins.stype1==5) || (pkth_trans_ins.stype1==6) || (pkth_trans_ins.stype1==7)) && pkth_trans_ins.cs_kind == SRIO_DELIM_PD)
                   begin//{
                    inv_ilgl_err=1'b1;
                    common_com_trans.ies_state = 1'b1;
                   end//}
                end //}
                if(handler_env_config.srio_mode == SRIO_GEN30)
                begin //{
                  temp_cs_crc24 = pkth_trans_ins.cs_crc24;        
                  pkth_trans_ins.cstype = CS64; 
                end //}
                else if(common_com_trans.bfm_idle_selected)
                begin //{
                  temp_cs_crc13 = pkth_trans_ins.cs_crc13;        
                end //}
                else
                begin //{
                  temp_cs_crc5 = pkth_trans_ins.cs_crc5;        
                end //}
   
                if(handler_env_config.srio_mode != SRIO_GEN30)
                  pkth_trans_ins.delimiter =  (pkth_trans_ins.cs_kind == SRIO_DELIM_PD) ? 8'h7C : 8'h1C;
    
                cs_val =  pkth_trans_ins.pack_cs();
             
                if(handler_env_config.srio_mode == SRIO_GEN30)
                  calc_crc24 =  pkth_trans_ins.calccrc24(pkth_trans_ins.pack_cs());  
                else if(common_com_trans.bfm_idle_selected)
                  calc_crc13 =  pkth_trans_ins.calccrc13(cs_val);  
                else
                  calc_crc5  = pkth_trans_ins.calccrc5(cs_val);  
               
                if((handler_env_config.srio_mode == SRIO_GEN30) && (calc_crc24 != temp_cs_crc24))
                   cs_crc_err = 1'b1;
                else if(common_com_trans.bfm_idle_selected && (calc_crc13 != temp_cs_crc13))
                   cs_crc_err = 1'b1;
                else if(~common_com_trans.bfm_idle_selected && (calc_crc5 != temp_cs_crc5)) 
                   cs_crc_err = 1'b1;
                else
                   cs_crc_err = 1'b0;

                if(cs_crc_err)
                begin //{
                   if(~common_com_trans.ies_state)
                   begin //{
                    common_com_trans.ies_state = 1'b1;
                   end //}
                   else
                       cs_crc_err = 1'b0;
                end //} 
                else
                begin //{
                    `uvm_do_callbacks(srio_pl_pkt_handler, srio_pl_callback, srio_pl_trans_received(pkth_trans_ins))
                    // packet accepted clear ackid outstanding queue
                    if(pkth_trans_ins.stype0 == 4'b0000 && common_com_trans.port_initialized & ~common_com_trans.link_initialized)
                    begin //{ 
                        common_com_trans.oes_state = 1'b1;   
			gen_link_req_after_link_init = 1;
                    end//}

                    if(pkth_trans_ins.stype0 == 4'b0000 && common_com_trans.link_initialized && pkth_config.vc_ct_mode == 0)
                    begin //{ 
                          ackid_clear =  pkth_trans_ins.param0;
                          if(handler_env_config.srio_mode == SRIO_GEN30)
                          begin //{ 
                            ackid = ackid_clear + 1;
                          end //}
                          else if(common_com_trans.bfm_idle_selected)
                          begin //{ 
                            if(ackid_clear == 63)
                              ackid = 0;
                            else 
                              ackid = ackid_clear + 1;
                          end //}
                          else
                          begin //{ 
                            if(ackid_clear == 31)
                              ackid = 0;
                            else 
                              ackid = ackid_clear + 1;
                          end //}
                             for(int i=0;i<pkt_merge_ins.pl_outstanding_ackid_q.size();i++)
                             begin //{
                                ackid_pkt_trans = new pkt_merge_ins.pl_outstanding_ackid_q[i];
                             end //}
                        // clear pktcs outstanding queue
                           if(pkth_config.multiple_ack_support)
                            begin//{
                             if(common_com_trans.mul_ack_min<common_com_trans.mul_ack_max)
                              begin//{
                               q_siz=pkt_merge_ins.pl_outstanding_ackid_q.size();
                               for(int j=0;j<q_siz;j++)
                                begin //{
                                 ackid_pkt_trans = new pkt_merge_ins.pl_outstanding_ackid_q[0];
                                 if(ackid_pkt_trans.ackid <= ackid_clear) 
                                  begin //{
                                   pkt_merge_ins.pl_outstanding_ackid_q.delete(0);
                                   if(ackid_pkt_trans.ackid == ackid_clear)
                                   break;
                                  end //}
                                end //}
                              end//}
                              else if(common_com_trans.mul_ack_min>common_com_trans.mul_ack_max)
                               begin//{
                                q_siz=pkt_merge_ins.pl_outstanding_ackid_q.size();
                                for(int i=0;i<q_siz;i++)
                                 begin //{
                                  ackid_pkt_trans = new pkt_merge_ins.pl_outstanding_ackid_q[0];
                                  if((ackid_pkt_trans.ackid >= common_com_trans.mul_ack_min) || (ackid_pkt_trans.ackid <= common_com_trans.mul_ack_max)) 
                                   begin //{
                                    pkt_merge_ins.pl_outstanding_ackid_q.delete(0);
                                    if(ackid_pkt_trans.ackid == ackid_clear)
                                    break;
                                   end //}
                                 end //}
                               end//}
                              else if(common_com_trans.mul_ack_min==common_com_trans.mul_ack_max)
                               begin//{
                                q_siz=pkt_merge_ins.pl_outstanding_ackid_q.size();
                                for(int i=0;i<q_siz;i++)
                                 begin //{
                                  ackid_pkt_trans = new pkt_merge_ins.pl_outstanding_ackid_q[i];
                                  if(ackid_pkt_trans.ackid == ackid_clear) 
                                   begin //{
                                    pkt_merge_ins.pl_outstanding_ackid_q.delete(i);
                                    //if(ackid_pkt_trans.ackid == ackid_clear)
                                    break;
                                   end //}
                                 end //}
                              end//}
                            end//}
                           else
                            begin//{
                       for(int i=0;i<pkt_merge_ins.pl_outstanding_ackid_q.size();i++)
                       begin //{
                          ackid_pkt_trans = new pkt_merge_ins.pl_outstanding_ackid_q[i];
                          if(ackid_pkt_trans.ackid == ackid_clear) 
                          begin //{
                           pkt_merge_ins.pl_outstanding_ackid_q.delete(i);
                           break;
                          end //}
                       end //}
                    end //}
                             for(int i=0;i<pkt_merge_ins.pl_outstanding_ackid_q.size();i++)
                             begin //{
                                ackid_pkt_trans = new pkt_merge_ins.pl_outstanding_ackid_q[i];
                             end //}
                           common_com_trans.mul_ack_min=ackid;
                     end //}
                    // retry rx'ed enter into ors state and generate restart from retry cs
                    if(pkth_trans_ins.stype0 == 4'b0001 && common_com_trans.link_initialized)
                    begin //{
                       retried_ackid = pkth_trans_ins.param0;
                       buff_status   = pkth_trans_ins.param1; 
                       if(common_com_trans.oes_state)
                        gen_linkreq_cs();
                       else
                       gen_rfr_cs();    
                       common_com_trans.ors_state = 1'b1;
                       if(pkth_config.multiple_ack_support)
                        begin//{
                         ackid=retried_ackid;
                         if(common_com_trans.mul_ack_min<common_com_trans.mul_ack_max)
                          begin//{
                           q_siz=pkt_merge_ins.pl_outstanding_ackid_q.size();
                           for(int j=0;j<q_siz;j++)
                            begin //{
                             ackid_pkt_trans = new pkt_merge_ins.pl_outstanding_ackid_q[0];
                             if(ackid_pkt_trans.ackid < retried_ackid) 
                              begin //{
                               pkt_merge_ins.pl_outstanding_ackid_q.delete(0);
                              end //}
                              if(ackid_pkt_trans.ackid == (retried_ackid))
                               break;
                            end //}
                          end//}
                          else if(common_com_trans.mul_ack_min>common_com_trans.mul_ack_max)
                           begin//{
                            q_siz=pkt_merge_ins.pl_outstanding_ackid_q.size();
                            for(int i=0;i<q_siz;i++)
                             begin //{
                              ackid_pkt_trans = new pkt_merge_ins.pl_outstanding_ackid_q[i];
                              if(ackid_pkt_trans.ackid==retried_ackid)
                               begin//{
                                for(int k=0;k<i;k++)
                                  pkt_merge_ins.pl_outstanding_ackid_q.delete(0);
                                 break;
                               end//}
                             end //}
                           end//}
                        end//}
                       common_com_trans.mul_ack_min=retried_ackid;
                    end //}
                    if((pkth_config.multiple_ack_support && pkth_config.ackid_status_pnack_support) && send_lreq)
                     begin//{ 
                      common_com_trans.oes_state = 1'b0;
                      send_lreq=1'b0;   
                     end//}
                    // pkt not accepted rxed enter oes state gen Link Req/ip status cs 
                    if(pkth_trans_ins.stype0 == 4'b0010 && common_com_trans.ism_change_req == FALSE && common_com_trans.link_initialized)
                    begin //{
                       if(~common_com_trans.oes_state)
                       gen_linkreq_cs();
                       common_com_trans.oes_state = 1'b1;   
                      if((pkth_config.multiple_ack_support && pkth_config.ackid_status_pnack_support))
                       send_lreq=1;
                      notaccepted_ackid = pkth_trans_ins.param0;
                       if(pkth_config.multiple_ack_support)
                        begin//{
                         ackid=notaccepted_ackid;
                         if(common_com_trans.mul_ack_min<common_com_trans.mul_ack_max)
                          begin//{
                           q_siz=pkt_merge_ins.pl_outstanding_ackid_q.size();
                           for(int j=0;j<q_siz;j++)
                            begin //{
                             ackid_pkt_trans = new pkt_merge_ins.pl_outstanding_ackid_q[0];
                             if(ackid_pkt_trans.ackid < notaccepted_ackid) 
                              begin //{
                               pkt_merge_ins.pl_outstanding_ackid_q.delete(0);
                              end //}
                              if(ackid_pkt_trans.ackid == notaccepted_ackid)
                               break;
                            end //}
                          end//}
                          else if(common_com_trans.mul_ack_min>common_com_trans.mul_ack_max)
                           begin//{
                            q_siz=pkt_merge_ins.pl_outstanding_ackid_q.size();
                            for(int i=0;i<q_siz;i++)
                             begin //{
                              ackid_pkt_trans = new pkt_merge_ins.pl_outstanding_ackid_q[i];
                              if(ackid_pkt_trans.ackid==notaccepted_ackid)
                               begin//{
                                for(int k=0;k<i;k++)
begin
                                 ackid_pkt_trans = new pkt_merge_ins.pl_outstanding_ackid_q[0];
                                  pkt_merge_ins.pl_outstanding_ackid_q.delete(0);
end
                                 break;
                               end//}
                             end //}
                           end//}
                        end//}
                       common_com_trans.mul_ack_min=notaccepted_ackid;
                             for(int i=0;i<pkt_merge_ins.pl_outstanding_ackid_q.size();i++)
                             begin //{
                                ackid_pkt_trans = new pkt_merge_ins.pl_outstanding_ackid_q[i];
                             end //}
                    end //}

                    // pkt not accepted rxed when change req is true gen link req/ip status cs
                    if(pkth_trans_ins.stype0 == 4'b0010 && common_com_trans.ism_change_req == TRUE && common_com_trans.link_initialized) 
                    begin //{
                        common_com_trans.oes_state = 1'b1;   
			gen_link_req_after_link_init = 1;
                    end //}

                    // status cs rxed ackid check
                    if(pkth_trans_ins.stype0 == 4'b0100)
                    begin //{
                          temp_ackid3 =  pkth_trans_ins.param0;
                          if(pkth_trans_ins.param1 != 12'hFFF && handler_env_config.srio_mode == SRIO_GEN30)
                             vc0_buf_status = pkth_trans_ins.param1;
                          else if(pkth_trans_ins.param1 != 6'h3F && common_com_trans.bfm_idle_selected)
                             vc0_buf_status = pkth_trans_ins.param1[6:11];
                          else if(pkth_trans_ins.param1 != 5'h1F && ~common_com_trans.bfm_idle_selected)
                             vc0_buf_status = pkth_trans_ins.param1[7:11];
 
                       if(ackid != temp_ackid3)
                       begin //{
                         `uvm_info("SRIO_PL_PKT_HANDLER : ", $sformatf("Ackid and Status Ackid Not Matched temp_ackid3=%d,ackid=%d",temp_ackid3,ackid), UVM_LOW);
                       end //}
                    end //}

                    // status cs rxed for multi vc
                    if(pkth_trans_ins.stype0 == 4'b0101)
                    begin //{
                       vcid_status =  pkth_trans_ins.param0[3:5];
                       if(vcid_status == 3'b000)
                         vcid1_buf_status = pkth_trans_ins.param1;
                       else if(vcid_status == 3'b001)
                         vcid2_buf_status = pkth_trans_ins.param1; 
                       else if(vcid_status == 3'b010)
                         vcid3_buf_status = pkth_trans_ins.param1; 
                       else if(vcid_status == 3'b011)
                         vcid4_buf_status = pkth_trans_ins.param1; 
                       else if(vcid_status == 3'b100)
                         vcid5_buf_status = pkth_trans_ins.param1; 
                       else if(vcid_status == 3'b101)
                         vcid6_buf_status = pkth_trans_ins.param1; 
                       else if(vcid_status == 3'b110)
                         vcid7_buf_status = pkth_trans_ins.param1; 
                       else if(vcid_status == 3'b111)
                         vcid8_buf_status = pkth_trans_ins.param1; 
                      
                    end //}

                   
                    // Link response rxed exit oes state
                    if(pkth_trans_ins.stype0 == 4'b0110)
                    begin //{
                          temp_ackid =  pkth_trans_ins.param0;
                        for(int i=0;i<rx_outstanding_ackid_q.size();i++)
                        begin //{
                           del_trans = new rx_outstanding_ackid_q[i]; 
                           if(del_trans.ackid <= temp_ackid)
                           begin //{
                              rx_outstanding_ackid_q.delete(i);
                           end //}
                        end //}
                      //  outstanding_ackid =  temp1_ackid;
                       if(seq_pna_flag)
                           seq_pna_flag = 1'b0;
                       if(ackid != temp_ackid)
                       begin 
                         `uvm_info("SRIO_PL_PKT_HANDLER : ", $sformatf("Ackid and Link Request Status Ackid Not Matched "), UVM_LOW)
                       end
                       else
                       begin
                         common_com_trans.oes_state = 1'b0;
                       end
                    end //}
                           
                    // stype1 sampling
                    if(handler_env_config.srio_mode == SRIO_GEN30)
                    begin //{
                       gen3_stype1 = {pkth_trans_ins.brc3_stype1_msb,pkth_trans_ins.stype1,pkth_trans_ins.cmd};
                     // if(gen3_stype1 == 8'h22)
                     // begin //{
                     // end //}

                     // if(gen3_stype1 == 8'h23)
                     // begin //{
                     // end //}

                       if(gen3_stype1 == 8'h24)
                       begin //{
                          if((pkth_config.multiple_ack_support && pkth_config.ackid_status_pnack_support)) 
                           common_com_trans.ies_state = 1'b0;
                          common_com_trans.irs_state = 1'b0;
                          gen_lresp_cs();
                          seq_pna_flag = 1'b0;
                          pkth_incr_ackid = 1'b0;
                       end //}
                       // Restart from retry received exit irs state and resume normal operation
                       if(gen3_stype1 == 8'h18)
                       begin //{
                          common_com_trans.irs_state = 1'b0;
                          seq_retry_flag = 1'b0;
                          pkth_incr_ackid = 1'b0;
                       end //}
                       if(gen3_stype1 == 8'h08)
                       begin //{
                          common_com_trans.irs_state = 1'b1;
                          gen_pr_cs();
                       end //}
                    end //}
                    else 
                    begin //{
                        // Restart from retry rxed exit irs state and resume normal operation
                        if(pkth_trans_ins.stype1 == 3'b011 && pkth_trans_ins.cmd == 3'b000 && pkth_trans_ins.brc3_stype1_msb == 2'b00  && common_com_trans.link_initialized  )
                        begin //{
                             common_com_trans.irs_state = 1'b0;
                             seq_retry_flag = 1'b0;
                             pkth_incr_ackid = 1'b0;
                             common_com_trans.ies_state = 1'b1;
                             inv_ilgl_err=1;
                        end //}
                        // Link req/ip status cs rxed gen link response and exit ies
                        if(pkth_trans_ins.stype1 == 3'b100 && pkth_trans_ins.cmd == 3'b100 && pkth_trans_ins.brc3_stype1_msb == 2'b00)
                        begin //{
                             if((pkth_config.multiple_ack_support && pkth_config.ackid_status_pnack_support)) 
                              common_com_trans.ies_state = 1'b0;
                              common_com_trans.irs_state = 1'b0;
                             gen_lresp_cs(); 
                             if(handler_env_config.multi_vc_support == 1'b1)
                             begin //{
                               gen_status_cs();
                               if(handler_env_config.vc_num_support == 1)
                               begin //{
                                  gen_vc_status_cs(3'b001);
                               end //}
                               else if(handler_env_config.vc_num_support == 2)
                               begin //{
                                  gen_vc_status_cs(3'b001);
                                  gen_vc_status_cs(3'b101);
                               end //}
                               else if(handler_env_config.vc_num_support == 4)
                               begin //{
                                  gen_vc_status_cs(3'b001);
                                  gen_vc_status_cs(3'b011);
                                  gen_vc_status_cs(3'b101);
                                  gen_vc_status_cs(3'b111);
                               end //}
                               else if(handler_env_config.vc_num_support == 8)
                               begin //{
                                  gen_vc_status_cs(3'b000);
                                  gen_vc_status_cs(3'b001);
                                  gen_vc_status_cs(3'b010);
                                  gen_vc_status_cs(3'b011);
                                  gen_vc_status_cs(3'b100);
                                  gen_vc_status_cs(3'b101);
                                  gen_vc_status_cs(3'b110);
                                  gen_vc_status_cs(3'b111);
                               end //}
                             end //}
                            if(seq_pna_flag)
                                seq_pna_flag = 1'b0;
                          pkth_incr_ackid = 1'b0;

                        end //}

                        // Link req/reset dev cmd rxed rx consecutive 4 cs and do a system reset
                        if(pkth_trans_ins.stype1 == 3'b100 && pkth_trans_ins.cmd == 3'b011 && pkth_trans_ins.brc3_stype1_msb == 2'b00 && ~rst_dev_cmd_rxd)
                        begin //{
                             rst_dev_cmd_rxd = 1'b1;
                             rst_dec_cmd_cnt = rst_dec_cmd_cnt + 1;
                        end //}
                        if(pkth_trans_ins.stype1 == 3'b100 && pkth_trans_ins.cmd == 3'b011 && rst_dev_cmd_rxd && pkth_trans_ins.brc3_stype1_msb == 2'b00)
                        begin //{
                             rst_dev_cmd_rxd = 1'b1;
                             if(rst_dec_cmd_cnt == 4)
                             begin //{
                                rst_dec_cmd_cnt = 0;
                             end //}
                             else 
                               rst_dec_cmd_cnt = rst_dec_cmd_cnt + 1;
                        end //}
                        if(pkth_trans_ins.stype1 == 3'b001 && pkth_trans_ins.cmd == 3'b000 && pkth_trans_ins.brc3_stype1_msb == 2'b00 && !common_com_trans.ies_state && packet_open)
                        begin //{
                          common_com_trans.irs_state = 1'b1;
                          gen_pr_cs();
                        end //}
                    end //}
                end //}

                 // rx buffer status in transmit flow control
                 if(handler_env_config.multi_vc_support == 1 && pkth_config.flow_control_mode == TRANSMIT)
                 begin //{
                    rxed_buf_status =  vcid1_buf_status + vcid2_buf_status + vcid3_buf_status + vcid4_buf_status + vcid5_buf_status + vcid6_buf_status + vcid7_buf_status + vcid8_buf_status + vc0_buf_status;
                 end //}
                 else if(handler_env_config.multi_vc_support == 0 && pkth_config.flow_control_mode == TRANSMIT)
                 begin //{
                     rxed_buf_status = vc0_buf_status;
                 end //}

                 if(handler_env_config.srio_mode == SRIO_GEN30)
                  begin //{
                    gen3_stype1 = {pkth_trans_ins.brc3_stype1_msb,pkth_trans_ins.stype1,pkth_trans_ins.cmd};
                    if(gen3_stype1 == 8'h2B)
                     gen_loop_res_cs();
                    if(pkth_trans_ins.stype0==4'b1011)
                     begin //{
                      common_com_trans.loop_resp_recvd=1;
                      common_com_trans.delay=pkth_trans_ins.param0;
                     end//}
                  end//}
                else
                 if(pkth_trans_ins.stype1 == 3'b101 && pkth_trans_ins.cmd == 3'b011 && ~common_com_trans.timestamp_master) 
                  begin//{
                   gen_loop_res_cs();
                  end//}
                  if(pkth_trans_ins.stype0==4'b0011)
                    begin//{
                      if(common_com_trans.timestamp_master)
                       begin//{
                        common_com_trans.loop_resp_recvd=1;
                        common_com_trans.delay={pkth_trans_ins.param0,pkth_trans_ins.param1};
                        common_com_trans.Timestamp1 = common_com_trans.TSG;  
                        common_com_trans.timestamp_offset= common_com_trans.Timestamp1 - common_com_trans.Timestamp0 - common_com_trans.delay;
                       end//}
                     else
                       begin//{

                        if(handler_env_config.srio_mode != SRIO_GEN30)
                         begin//{
                          case (i)
                           0:
                            begin//{
                             local_TSG[0:2]=pkth_trans_ins.param0[9:11];
                             local_TSG[3:7]=pkth_trans_ins.param1[7:11];
                             i++;
                            end//}
                           1:
                            begin//{
                             local_TSG[8:10]=pkth_trans_ins.param0[9:11];
                             local_TSG[11:15]=pkth_trans_ins.param1[7:11];
                             i++;
                            end//}
                           2:
                            begin//{
                             local_TSG[16:18]=pkth_trans_ins.param0[9:11];
                             local_TSG[19:23]=pkth_trans_ins.param1[7:11];
                             i++;
                            end//}
                           3:
                            begin//{
                             local_TSG[24:26]=pkth_trans_ins.param0[9:11];
                             local_TSG[27:31]=pkth_trans_ins.param1[7:11];
                             i++;
                            end//}
                           4:
                            begin//{
                             local_TSG[32:34]=pkth_trans_ins.param0[9:11];
                             local_TSG[35:39]=pkth_trans_ins.param1[7:11];
                             i++;
                            end//}
                           5:
                            begin//{
                             local_TSG[40:42]=pkth_trans_ins.param0[9:11];
                             local_TSG[43:47]=pkth_trans_ins.param1[7:11];
                             i++;
                            end//}
                           6:
                            begin//{
                             local_TSG[48:50]=pkth_trans_ins.param0[9:11];
                             local_TSG[51:55]=pkth_trans_ins.param1[7:11];
                             i++;
                            end//}
                           7:
                            begin//{
                             local_TSG[56:58]=pkth_trans_ins.param0[9:11];
                             local_TSG[59:63]=pkth_trans_ins.param1[7:11];
                             i=0;
                             update_TSG=1;
                            end//}
                           endcase
                          end//}
                           else
                            begin//{
                              case (i)
                               0:
                                begin//{
                                 local_TSG[0:3]=pkth_trans_ins.param0[8:11];
                                 local_TSG[4:15]=pkth_trans_ins.param1;
                                 i++;
                                end//}
                               1:
                                begin//{
                                 local_TSG[16:19]=pkth_trans_ins.param0[8:11];
                                 local_TSG[20:31]=pkth_trans_ins.param1;
                                 i++;
                                end//}
                               2:
                                begin//{
                                 local_TSG[32:35]=pkth_trans_ins.param0[8:11];
                                 local_TSG[36:47]=pkth_trans_ins.param1;
                                 i++;
                                end//}
                               3:
                                begin//{
                                 local_TSG[48:51]=pkth_trans_ins.param0[8:11];
                                 local_TSG[52:63]=pkth_trans_ins.param1;
                                 i=0;
                                 update_TSG=1;
                                end//}
                              endcase
                            end//}
                       end  //}
                     end//}
               end  //}
            else if(pkth_trans_ins.transaction_kind == SRIO_CS  && common_com_trans.port_initialized)
               begin  //{
                        if(pkth_trans_ins.stype1 == 3'b100 && pkth_trans_ins.cmd == 3'b100 && pkth_trans_ins.brc3_stype1_msb == 2'b00)
                        begin //{
                             if((pkth_config.multiple_ack_support && pkth_config.ackid_status_pnack_support)) 
                              common_com_trans.ies_state = 1'b0;
                              common_com_trans.irs_state = 1'b0;
                             gen_lresp_cs(); 
                             if(handler_env_config.multi_vc_support == 1'b1)
                             begin //{
                               gen_status_cs();
                               if(handler_env_config.vc_num_support == 1)
                               begin //{
                                  gen_vc_status_cs(3'b001);
                               end //}
                               else if(handler_env_config.vc_num_support == 2)
                               begin //{
                                  gen_vc_status_cs(3'b001);
                                  gen_vc_status_cs(3'b101);
                               end //}
                               else if(handler_env_config.vc_num_support == 4)
                               begin //{
                                  gen_vc_status_cs(3'b001);
                                  gen_vc_status_cs(3'b011);
                                  gen_vc_status_cs(3'b101);
                                  gen_vc_status_cs(3'b111);
                               end //}
                               else if(handler_env_config.vc_num_support == 8)
                               begin //{
                                  gen_vc_status_cs(3'b000);
                                  gen_vc_status_cs(3'b001);
                                  gen_vc_status_cs(3'b010);
                                  gen_vc_status_cs(3'b011);
                                  gen_vc_status_cs(3'b100);
                                  gen_vc_status_cs(3'b101);
                                  gen_vc_status_cs(3'b110);
                                  gen_vc_status_cs(3'b111);
                               end //}
                             end //}
                            if(seq_pna_flag)
                                seq_pna_flag = 1'b0;
                          pkth_incr_ackid = 1'b0;
                         end//}
                    if(pkth_trans_ins.stype0 == 4'b0110)
                    begin //{
                          temp_ackid =  pkth_trans_ins.param0;
                        for(int i=0;i<rx_outstanding_ackid_q.size();i++)
                        begin //{
                           del_trans = new rx_outstanding_ackid_q[i]; 
                           if(del_trans.ackid <= temp_ackid)
                           begin //{
                              rx_outstanding_ackid_q.delete(i);
                           end //}
                        end //}
                      //  outstanding_ackid =  temp1_ackid;
                       if(seq_pna_flag)
                           seq_pna_flag = 1'b0;
                       if(ackid != temp_ackid)
                       begin 
                         `uvm_info("SRIO_PL_PKT_HANDLER : ", $sformatf("Ackid and Link Request Status Ackid Not Matched "), UVM_LOW)
                       end
                       else
                       begin
                         common_com_trans.oes_state = 1'b0;
                       end
                    end //}
               end  //}
/*      else if (common_com_trans.ism_change_req == FALSE && gen_link_req_after_link_init && common_com_trans.link_initialized)
      begin //{
	gen_link_req_after_link_init = 0;
        common_com_trans.oes_state = 1'b1;   
	gen_linkreq_cs();
      end //}*/
   end //}

   if(common_com_trans.port_initialized && common_com_trans.ism_change_req == FALSE && common_com_trans.status_cnt == 0)
   begin //{
     if(handler_env_config.srio_mode == SRIO_GEN13 && common_com_trans.current_init_state==NX_MODE )
      common_com_trans.status_cnt = (pkth_config.code_group_sent_2_cs/handler_env_config.num_of_lanes)-25;
     else
      common_com_trans.status_cnt = pkth_config.code_group_sent_2_cs-25;
   end //}
   else if(common_com_trans.port_initialized && (common_com_trans.ism_change_req == FALSE))
   begin //{
      common_com_trans.status_cnt = common_com_trans.status_cnt - 1;
   end //}
   else if(common_com_trans.ism_change_req == TRUE)
   begin //{
     if(handler_env_config.srio_mode == SRIO_GEN13 && common_com_trans.current_init_state==NX_MODE )
      common_com_trans.status_cnt = (pkth_config.code_group_sent_2_cs/handler_env_config.num_of_lanes)-25;
     else
      common_com_trans.status_cnt = pkth_config.code_group_sent_2_cs-25;
   end //}
   //   common_com_trans.status_cnt = pkth_config.code_group_sent_2_cs-40;
   
   if(common_com_trans.status_cnt == 0 && common_com_trans.port_initialized && common_com_trans.ism_change_req == FALSE)
   begin //{  
      gen_status_cs();
      if(common_com_trans.link_initialized)
      begin //{
          common_com_trans.tx_status_cs_cnt = 0;
      end //}
      else if(common_com_trans.port_initialized)
      begin //{
          if (common_com_trans.rx_status_cs_cnt>0)
            common_com_trans.tx_status_cs_cnt += 1;
      end //}
   end //}

   // vc status cs generation
   if(handler_env_config.multi_vc_support == 1'b1)
   begin //{
       if(common_com_trans.port_initialized && common_com_trans.ism_change_req == FALSE && vc_status_cnt == 0)
          vc_status_cnt = pkth_config.vc_refresh_int-40;
       else if(common_com_trans.port_initialized && (common_com_trans.ism_change_req == FALSE))
          vc_status_cnt = vc_status_cnt - 1;
       else if(common_com_trans.ism_change_req == TRUE)
          vc_status_cnt = pkth_config.vc_refresh_int;
       
       if(vc_status_cnt == 0 && common_com_trans.port_initialized && common_com_trans.ism_change_req == FALSE)
       begin //{  
         if(handler_env_config.vc_num_support == 1)
         begin //{
            gen_vc_status_cs(3'b001);
         end //}
         else if(handler_env_config.vc_num_support == 2)
         begin //{
            gen_vc_status_cs(3'b001);
            gen_vc_status_cs(3'b101);
         end //}
         else if(handler_env_config.vc_num_support == 4)
         begin //{
            gen_vc_status_cs(3'b001);
            gen_vc_status_cs(3'b011);
            gen_vc_status_cs(3'b101);
            gen_vc_status_cs(3'b111);
         end //}
         else if(handler_env_config.vc_num_support == 8)
         begin //{
            gen_vc_status_cs(3'b000);
            gen_vc_status_cs(3'b001);
            gen_vc_status_cs(3'b010);
            gen_vc_status_cs(3'b011);
            gen_vc_status_cs(3'b100);
            gen_vc_status_cs(3'b101);
            gen_vc_status_cs(3'b110);
            gen_vc_status_cs(3'b111);
         end //}
       end //}
   end //}

   if (common_com_trans.ism_change_req == FALSE && gen_link_req_after_link_init && common_com_trans.link_initialized)
    begin //{
      gen_link_req_after_link_init = 0;
      common_com_trans.oes_state = 1'b1;   
      gen_linkreq_cs();
    end //}
   end //}
  end //}
 end //}
  endtask : pop_pkt 


////////////////////////////////////////////////////////////////////////////////////////////
/// Name: gen_pr_cs\n
/// Description: Task to generate Retry Control Symbol. 
////////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_pkt_handler::gen_pr_cs();
     trans_push_ins = new();
     trans_push_ins.pkt_type = SRIO_PL_PACKET;
     trans_push_ins.transaction_kind = SRIO_CS;
     trans_push_ins.stype0 = 4'b0001;
     if(handler_env_config.srio_mode == SRIO_GEN30)
       trans_push_ins.cstype = CS64;
     else if(common_com_trans.bfm_idle_selected)
       trans_push_ins.cstype = CS48;
     else
       trans_push_ins.cstype = CS24;

     if(common_com_trans.bfm_idle_selected)
     begin //{
       trans_push_ins.param0 = common_com_trans.curr_rx_ackid;
     end //}
     else
     begin //{
       trans_push_ins.param0 = common_com_trans.curr_rx_ackid;
     end //} 
     if(pkth_config.flow_control_mode == RECEIVE)
       trans_push_ins.param1 = 12'hFFF;
     else
     begin //{
       if(handler_env_config.multi_vc_support == 1'b0)
         trans_push_ins.param1 = pkth_config.buffer_space - receive_pkt_q.size();
       else
         trans_push_ins.param1 = pkth_config.buffer_space - receive_pkt_vc0_q.size();
     end //}

     trans_push_ins.stype1  = 3'b111;
     trans_push_ins.cmd     = 3'b000;
     trans_push_ins.brc3_stype1_msb = 2'b00;
 
     cs_val = trans_push_ins.pack_cs();
     if(handler_env_config.srio_mode == SRIO_GEN30)
       void'(trans_push_ins.calccrc24(cs_val));
     else if(common_com_trans.bfm_idle_selected)
       void'(trans_push_ins.calccrc13(cs_val));
     else
       void'(trans_push_ins.calccrc5(cs_val));
       
     if(handler_env_config.srio_mode != SRIO_GEN30)
       trans_push_ins.delimiter = 8'h1C;

     void'(trans_push_ins.pack_cs_bytes());
       if(pkth_config.pkt_acc_gen_kind == PL_RANDOM)
       begin //{ 
         trans_push_ins.pl_rd_cnter = 0;
         trans_push_ins.pl_rd = $urandom_range(pkth_config.pkt_ack_delay_min,pkth_config.pkt_ack_delay_max); 
         cs_dly_q.push_back(trans_push_ins);
       //  inc_ackid();
       end //}
       else if(pkth_config.pkt_acc_gen_kind == PL_IMMEDIATE)
       begin //{
     pkt_merge_ins.pl_gencs_q.push_back(trans_push_ins); 
         /*for(int i=0;i<rx_outstanding_ackid_q.size();i++)
         begin//{
            temp_trans = new rx_outstanding_ackid_q[i];
            if(temp_trans.ackid == common_com_trans.curr_rx_ackid)
                rx_outstanding_ackid_q.delete(i);          
         end //}
         inc_ackid();*/ 
       end //}
       else
         `uvm_info("SRIO_PL_PKT_HANDLER : ", $sformatf("PACKET ACC GEN PACKET ACCEPTED KIND IS DISABLED"), UVM_LOW);
   
 endtask : gen_pr_cs

////////////////////////////////////////////////////////////////////////////////////////////
/// Name: gen_rfr_c\n
/// Description: Task to generate Restart from Retry Control Symbol. 
////////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_pkt_handler::gen_rfr_cs();

     trans_push_ins = new();
     trans_push_ins.pkt_type = SRIO_PL_PACKET;
     trans_push_ins.transaction_kind = SRIO_CS;
     trans_push_ins.stype0 = 4'b0100;

     if(handler_env_config.srio_mode == SRIO_GEN30)
       trans_push_ins.cstype = CS64;
     else if(common_com_trans.bfm_idle_selected)
       trans_push_ins.cstype = CS48;
     else
       trans_push_ins.cstype = CS24;

     //trans_push_ins.param0 = common_com_trans.curr_rx_ackid;
     trans_push_ins.param0 = common_com_trans.ackid_for_scs; 
     if(pkth_config.multiple_ack_support)
      trans_push_ins.param0 = common_com_trans.gr_curr_tx_ackid;

     if(pkth_config.flow_control_mode == RECEIVE)
       trans_push_ins.param1 = 12'hFFF;
     else
     begin //{
       if(handler_env_config.multi_vc_support == 1'b0)
         trans_push_ins.param1 = pkth_config.buffer_space - receive_pkt_q.size();
       else
         trans_push_ins.param1 = pkth_config.buffer_space - receive_pkt_vc0_q.size();
     end //}

     trans_push_ins.stype1  = 3'b011;
     trans_push_ins.cmd     = 3'b000;
     trans_push_ins.brc3_stype1_msb = 2'b00;
 
     cs_val = trans_push_ins.pack_cs();
     if(handler_env_config.srio_mode == SRIO_GEN30)
       void'(trans_push_ins.calccrc24(cs_val));
     else if(common_com_trans.bfm_idle_selected)
       void'(trans_push_ins.calccrc13(cs_val));
     else
       void'(trans_push_ins.calccrc5(cs_val));
       
     if(handler_env_config.srio_mode != SRIO_GEN30)
       trans_push_ins.delimiter = 8'h1C;

     void'(trans_push_ins.pack_cs_bytes());
     pkt_merge_ins.pl_gencs_q.push_back(trans_push_ins); 
   
 endtask : gen_rfr_cs

////////////////////////////////////////////////////////////////////////////////////////////
/// Name: gen_linkreq_cs \n
/// Description: Task to generate Link Request Control Symbol. 
////////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_pkt_handler::gen_linkreq_cs();
     trans_push_ins = new();
     trans_push_ins.pkt_type = SRIO_PL_PACKET;
     trans_push_ins.transaction_kind = SRIO_CS;
     trans_push_ins.stype0 = 4'b0100;
     if(handler_env_config.srio_mode == SRIO_GEN30)
       trans_push_ins.cstype = CS64;
     else if(common_com_trans.bfm_idle_selected)
       trans_push_ins.cstype = CS48;
     else
       trans_push_ins.cstype = CS24;

     trans_push_ins.param0 = common_com_trans.curr_rx_ackid;
     trans_push_ins.param0 = common_com_trans.ackid_for_scs; 
     if(pkth_config.multiple_ack_support)
      trans_push_ins.param0 = common_com_trans.gr_curr_tx_ackid;

     if(pkth_config.flow_control_mode == RECEIVE)
       trans_push_ins.param1 = 12'hFFF;
     else
     begin //{
       if(handler_env_config.multi_vc_support == 1'b0)
         trans_push_ins.param1 = pkth_config.buffer_space - receive_pkt_q.size();
       else
         trans_push_ins.param1 = pkth_config.buffer_space - receive_pkt_vc0_q.size();
     end //}

     trans_push_ins.stype1  = 3'b100;
     trans_push_ins.cmd     = 3'b100;
     trans_push_ins.brc3_stype1_msb = 2'b00;
 
     if(handler_env_config.srio_mode == SRIO_GEN30)
       void'(trans_push_ins.calccrc24(trans_push_ins.pack_cs()));
     else if(common_com_trans.bfm_idle_selected)
       void'(trans_push_ins.calccrc13(trans_push_ins.pack_cs()));
     else
       void'(trans_push_ins.calccrc5(trans_push_ins.pack_cs()));
       
     if(handler_env_config.srio_mode != SRIO_GEN30)
        trans_push_ins.delimiter = 8'h1C;
     void'(trans_push_ins.pack_cs_bytes());
     pkt_merge_ins.pl_gencs_q.push_back(trans_push_ins); 
   
 endtask : gen_linkreq_cs

////////////////////////////////////////////////////////////////////////////////////////////
/// Name: gen_lresp_cs \n
/// Description: Task to generate Link Response Control Symbol. 
////////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_pkt_handler::gen_lresp_cs();

     trans_push_ins = new();
     trans_push_ins.pkt_type = SRIO_PL_PACKET;
     trans_push_ins.transaction_kind = SRIO_CS;
     trans_push_ins.stype0 = 4'b0110;
     if(handler_env_config.srio_mode == SRIO_GEN30)
       trans_push_ins.cstype = CS64;
     else if(common_com_trans.bfm_idle_selected)
       trans_push_ins.cstype = CS48;
     else
       trans_push_ins.cstype = CS24;
     trans_push_ins.param0 = common_com_trans.curr_rx_ackid;
     trans_push_ins.param0 = common_com_trans.ackid_for_scs; 
     if(pkth_config.multiple_ack_support)
      trans_push_ins.param0 = common_com_trans.gr_curr_tx_ackid;

     if(handler_env_config.srio_mode == SRIO_GEN30)
       trans_push_ins.param1 = {7'b0,5'b00101};
     else if(common_com_trans.bfm_idle_selected)
       trans_push_ins.param1 = {7'b0,5'b10000};
       //trans_push_ins.param1 = {7'b0,5'b00101};
     else
       trans_push_ins.param1 = {7'b0,5'b00101};
     if(common_com_trans.ies_state)
       trans_push_ins.param1 = {7'b0,5'b00101};
     else if(common_com_trans.irs_state)
       trans_push_ins.param1 = {7'b0,5'b00100};
     else
       trans_push_ins.param1 = {7'b0,5'b10000};
     if(handler_env_config.srio_mode == SRIO_GEN30)
      begin//{
       trans_push_ins.param1[0] = 1'b0;
       if(common_com_trans.ies_state)
        trans_push_ins.param1[1:2] = 2'b10;
       else if(common_com_trans.irs_state)
        trans_push_ins.param1[1:2] = 2'b01;
       else
        trans_push_ins.param1[1:2] = 2'b00;
       trans_push_ins.param1[3] = 1'b1;
       trans_push_ins.param1[4] = 1'b0;
       if(common_com_trans.oes_state)
        trans_push_ins.param1[5:6] = 2'b10;
       else if(common_com_trans.ors_state)
        trans_push_ins.param1[5:6] = 2'b01;
       else
        trans_push_ins.param1[5:6] = 2'b00;
       trans_push_ins.param1[7] = 1'b1;
       trans_push_ins.param1[8] = 1'b0;
       trans_push_ins.param1[9:11] = 'h0;
      end//}
     trans_push_ins.stype1  = 3'b111;
     trans_push_ins.cmd     = 3'b000;
     trans_push_ins.brc3_stype1_msb = 2'b00;
 
     cs_val = trans_push_ins.pack_cs();
     if(handler_env_config.srio_mode == SRIO_GEN30)
       void'(trans_push_ins.calccrc24(cs_val));
     else if(common_com_trans.bfm_idle_selected)
       void'(trans_push_ins.calccrc13(cs_val));
     else
       void'(trans_push_ins.calccrc5(cs_val));
       
     if(handler_env_config.srio_mode != SRIO_GEN30)
        void'(trans_push_ins.set_delimiter());
     void'(trans_push_ins.pack_cs_bytes());
     pkt_merge_ins.pl_gencs_q.push_back(trans_push_ins); 
   
 endtask : gen_lresp_cs


////////////////////////////////////////////////////////////////////////////////////////////
/// Name: gen_pa_cs \n
/// Description: Task to generate Packet Accepted Control Symbol. PACC can be generated by the user also
/// and either with random delay or immediate.
////////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_pkt_handler::gen_pa_cs();

     trans_push_ins = new();
     trans_push_ins.pkt_type = SRIO_PL_PACKET;
     trans_push_ins.transaction_kind = SRIO_CS;
     trans_push_ins.stype0 = 4'b0000;
     if(handler_env_config.srio_mode == SRIO_GEN30)
       trans_push_ins.cstype = CS64;
     else if(common_com_trans.bfm_idle_selected)
       trans_push_ins.cstype = CS48;
     else
       trans_push_ins.cstype = CS24;

     trans_push_ins.param0 = common_com_trans.curr_rx_ackid;

     if(pkth_config.flow_control_mode == RECEIVE)
       trans_push_ins.param1 = 12'hfff;
     else
     begin //{
       if(handler_env_config.multi_vc_support == 1'b0)
         trans_push_ins.param1 = pkth_config.buffer_space - receive_pkt_q.size();
       else
         trans_push_ins.param1 = pkth_config.buffer_space - receive_pkt_vc0_q.size();
     end //}

     trans_push_ins.stype1  = 3'b111;
     trans_push_ins.cmd     = 3'b000;
     trans_push_ins.brc3_stype1_msb = 2'b00;
 
     cs_val = trans_push_ins.pack_cs();
     if(handler_env_config.srio_mode == SRIO_GEN30)
       void'(trans_push_ins.calccrc24(cs_val));
     else if(common_com_trans.bfm_idle_selected)
       void'(trans_push_ins.calccrc13(cs_val));
     else
       void'(trans_push_ins.calccrc5(cs_val));
       
     if(handler_env_config.srio_mode != SRIO_GEN30)
        void'(trans_push_ins.set_delimiter());
     void'(trans_push_ins.pack_cs_bytes());

     if(pkth_trans_ins.usr_directed_pl_ack_en)
     begin //{
       trans_push_ins.pl_rd_cnter = 0;
       trans_push_ins.pl_rd = pkth_trans_ins.usr_directed_pl_ack_delay;
       cs_dly_q.push_back(trans_push_ins);
     end //}
     else
     begin //{
       if(pkth_config.pkt_acc_gen_kind == PL_RANDOM)
       begin //{ 
         trans_push_ins.pl_rd_cnter = 0;
         trans_push_ins.pl_rd = $urandom_range(pkth_config.pkt_ack_delay_min,pkth_config.pkt_ack_delay_max); 
         cs_dly_q.push_back(trans_push_ins);
         inc_ackid();
       end //}
       else if(pkth_config.pkt_acc_gen_kind == PL_IMMEDIATE)
       begin //{
         pkt_merge_ins.pl_gencs_q.push_back(trans_push_ins); 
         for(int i=0;i<rx_outstanding_ackid_q.size();i++)
         begin//{
            temp_trans = new rx_outstanding_ackid_q[i];
            if(temp_trans.ackid == common_com_trans.curr_rx_ackid)
                rx_outstanding_ackid_q.delete(i);          
         end //}
         inc_ackid(); 
         common_com_trans.ackid_for_scs=common_com_trans.curr_rx_ackid;
       end //}
       else
         `uvm_info("SRIO_PL_PKT_HANDLER : ", $sformatf("PACKET ACC GEN PACKET ACCEPTED KIND IS DISABLED"), UVM_LOW);
    end //} 
   
 endtask : gen_pa_cs

////////////////////////////////////////////////////////////////////////////////////////////
/// Name: gen_pna_cs \n
/// Description: Task to generate Packet Not Accepted Control Symbol. PNAC can be generated
/// by the user also with user controlled error infomration and either with random delay
/// or immediate.
////////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_pkt_handler::gen_pna_cs();

   forever
   begin //{
     wait(common_com_trans.ies_state && common_com_trans.link_initialized && common_com_trans.ism_change_req == FALSE  && handler_env_config.pl_mon_tx_link_initialized);
     trans_push_ins = new();
     trans_push_ins.pkt_type = SRIO_PL_PACKET;
     trans_push_ins.transaction_kind = SRIO_CS;
     trans_push_ins.stype0 = 4'b0010;
     if(handler_env_config.srio_mode == SRIO_GEN30)
       trans_push_ins.cstype = CS64;
     else if(common_com_trans.bfm_idle_selected)
       trans_push_ins.cstype = CS48;
     else
       trans_push_ins.cstype = CS24;

     trans_push_ins.param0 = 12'h000;
     if(pkth_config.multiple_ack_support && pkth_config.ackid_status_pnack_support) 
      trans_push_ins.param0 = temp_ackid;

     if(pkth_trans_ins.usr_directed_pl_ack_en)
     begin //{
          if(pkth_trans_ins.usr_directed_pl_nac_cause == UNEXP_ACKID)
            trans_push_ins.param1 = {7'b0,5'b00001};
          else if(pkth_trans_ins.usr_directed_pl_nac_cause == BAD_CRC)
            trans_push_ins.param1 = {7'b0,5'b00010};
          else if(pkth_trans_ins.usr_directed_pl_nac_cause == PKT_RECP_STOP)
            trans_push_ins.param1 = {7'b0,5'b00011};
          else if(pkth_trans_ins.usr_directed_pl_nac_cause == PKT_BAD_CRC)
            trans_push_ins.param1 = {7'b0,5'b00100}; 
          else if(pkth_trans_ins.usr_directed_pl_nac_cause == INV_CHAR)
            trans_push_ins.param1 = {7'b0,5'b00101}; 
          else if(pkth_trans_ins.usr_directed_pl_nac_cause == PNA_LBF_RES)
            trans_push_ins.param1 = {7'b0,5'b00110}; 
          else if(pkth_trans_ins.usr_directed_pl_nac_cause == LOSS_DSCR)
            trans_push_ins.param1 = {7'b0,5'b00111}; 
          else if(pkth_trans_ins.usr_directed_pl_nac_cause == GNRL_ERR)
            trans_push_ins.param1 = {7'b0,5'b11111}; 
     end //}
     else
     begin //{
          if(ackid_err)
            begin//{
            trans_push_ins.param1 = {7'b0,5'b00001};
             ackid_err        = 1'b0;
            end//}
          else if(incorrect_crc)
            begin//{
            trans_push_ins.param1 = {7'b0,5'b00100};
             incorrect_crc=1'b0;
            end//}
          else if(inv_ilgl_err)
            begin//{
             trans_push_ins.param1 = {7'b0,5'b00101};
             inv_ilgl_err=1'b0;
            end//}
          else if(cs_crc_err)
            trans_push_ins.param1 = {7'b0,5'b00010};
          else if(buffer_full)
            trans_push_ins.param1 = {7'b0,5'b00110}; 
          else
             trans_push_ins.param1 = common_com_trans.ies_cause_value;
     end //}

     trans_push_ins.stype1  = 3'b111;
     trans_push_ins.cmd     = 3'b000;
     trans_push_ins.brc3_stype1_msb = 2'b00;
 
     cs_val = trans_push_ins.pack_cs();
     if(handler_env_config.srio_mode == SRIO_GEN30)
       void'(trans_push_ins.calccrc24(cs_val));
     else if(common_com_trans.bfm_idle_selected)
       void'(trans_push_ins.calccrc13(cs_val));
     else
       void'(trans_push_ins.calccrc5(cs_val));
       
     if(handler_env_config.srio_mode != SRIO_GEN30)
        void'(trans_push_ins.set_delimiter());
     void'(trans_push_ins.pack_cs_bytes());

     if(pkth_trans_ins.usr_directed_pl_ack_en)
     begin //{
       trans_push_ins.pl_rd_cnter = 0;
       trans_push_ins.pl_rd = pkth_trans_ins.usr_directed_pl_ack_delay;
       cs_dly_q.push_back(trans_push_ins);
     end //}
     else
     begin //{
       if(pkth_config.pkt_acc_gen_kind == PL_RANDOM)
       begin //{ 
         trans_push_ins.pl_rd_cnter = 0;
         trans_push_ins.pl_rd = $urandom_range(pkth_config.pkt_ack_delay_min,pkth_config.pkt_ack_delay_max); 
         cs_dly_q.push_back(trans_push_ins);
       end //}
       else if(pkth_config.pkt_acc_gen_kind == PL_IMMEDIATE)
         pkt_merge_ins.pl_gencs_q.push_back(trans_push_ins); 
       else
         `uvm_info("SRIO_PL_PKT_HANDLER : ", $sformatf("PACKET ACC GEN PACKET NOT ACCEPTED KIND IS DISABLED"), UVM_LOW);
    end //}

     wait(common_com_trans.ies_state==1'b0);
  end //}
   
 endtask : gen_pna_cs

////////////////////////////////////////////////////////////////////////////////////////////
/// Name: pkt_push_transmit_mode \n
/// Description: Task to  delay the transmission of packets to upper layers when multi VC 
/// mode is not supported
////////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_pkt_handler:: pkt_push_transmit_mode();
 int q_size;
     forever
     begin //{
        @(posedge common_com_trans.int_clk)
        begin //{
         if(receive_pkt_q.size() != 0)
         begin //{
            q_size = receive_pkt_q.size();
            for(int tmp_index = 0; tmp_index < q_size; tmp_index++)
            begin //{
              if(receive_pkt_q[tmp_index].pl_rd_cnter >= receive_pkt_q[tmp_index].pl_rd)
              begin //{
                `uvm_do_callbacks(srio_pl_pkt_handler, srio_pl_callback, srio_pl_trans_received(pkth_trans_ins))
                pl_handler_gen_put_port.put(receive_pkt_q[tmp_index]);
                receive_pkt_q.delete(tmp_index);
              end //}
              else
              begin //{
                receive_pkt_q[tmp_index].pl_rd_cnter++;
              end //}
            end //}
         end //}
        end //}
     end //}
 endtask : pkt_push_transmit_mode

////////////////////////////////////////////////////////////////////////////////////////////
/// Name: pkt_push_transmit_mode_vc0 \n
/// Description: Task to  delay the transmission of VC0 packets to upper layers 
////////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_pkt_handler:: pkt_push_transmit_mode_vc0();
 int q_size;
     forever
     begin //{
        @(posedge common_com_trans.int_clk)
        begin //{
          q_size = receive_pkt_vc0_q.size();
          for(int tmp_index = 0; tmp_index < q_size; tmp_index++)
          begin //{
            if(receive_pkt_vc0_q[tmp_index].pl_rd_cnter >= receive_pkt_vc0_q[tmp_index].pl_rd)
            begin //{
              `uvm_do_callbacks(srio_pl_pkt_handler, srio_pl_callback, srio_pl_trans_received(pkth_trans_ins))
              pl_handler_gen_put_port.put(receive_pkt_vc0_q[tmp_index]);
              receive_pkt_vc0_q.delete(tmp_index);
            end //}
            else
            begin //{
              receive_pkt_vc0_q[tmp_index].pl_rd_cnter++;
            end //}
          end //}
        end //}
     end //}
 endtask : pkt_push_transmit_mode_vc0

////////////////////////////////////////////////////////////////////////////////////////////
/// Name: pkt_push_transmit_mode_vc1 \n
/// Description: Task to  delay the transmission of VC1 packets to upper layers 
////////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_pkt_handler:: pkt_push_transmit_mode_vc1();
 int q_size;
     forever
     begin //{
        @(posedge common_com_trans.int_clk)
        begin //{
          q_size = receive_pkt_vc1_q.size();
          for(int tmp_index = 0; tmp_index < q_size; tmp_index++)
          begin //{
            if(receive_pkt_vc1_q[tmp_index].pl_rd_cnter >= receive_pkt_vc1_q[tmp_index].pl_rd)
            begin //{
              `uvm_do_callbacks(srio_pl_pkt_handler, srio_pl_callback, srio_pl_trans_received(pkth_trans_ins))
              pl_handler_gen_put_port.put(receive_pkt_vc1_q[tmp_index]);
              receive_pkt_vc1_q.delete(tmp_index);
            end //}
            else
            begin //{
              receive_pkt_vc1_q[tmp_index].pl_rd_cnter++;
            end //}
          end //}
        end //}
     end //}
 endtask : pkt_push_transmit_mode_vc1 

////////////////////////////////////////////////////////////////////////////////////////////
/// Name: pkt_push_transmit_mode_vc2 \n
/// Description: Task to  delay the transmission of VC2 packets to upper layers 
////////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_pkt_handler:: pkt_push_transmit_mode_vc2();
 int q_size;
     forever
     begin //{
        @(posedge common_com_trans.int_clk)
        begin //{
          q_size = receive_pkt_vc2_q.size();
          for(int tmp_index = 0; tmp_index < q_size; tmp_index++)
          begin //{
            if(receive_pkt_vc2_q[tmp_index].pl_rd_cnter >= receive_pkt_vc2_q[tmp_index].pl_rd)
            begin //{
              `uvm_do_callbacks(srio_pl_pkt_handler, srio_pl_callback, srio_pl_trans_received(pkth_trans_ins))
              pl_handler_gen_put_port.put(receive_pkt_vc2_q[tmp_index]);
              receive_pkt_vc2_q.delete(tmp_index);
            end //}
            else
            begin //{
              receive_pkt_vc2_q[tmp_index].pl_rd_cnter++;
            end //}
          end //}
        end //}
     end //}
 endtask : pkt_push_transmit_mode_vc2 

////////////////////////////////////////////////////////////////////////////////////////////
/// Name: pkt_push_transmit_mode_vc3 \n
/// Description: Task to  delay the transmission of VC3 packets to upper layers 
////////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_pkt_handler:: pkt_push_transmit_mode_vc3();
 int q_size;
     forever
     begin //{
        @(posedge common_com_trans.int_clk)
        begin //{
          q_size = receive_pkt_vc3_q.size();
          for(int tmp_index = 0; tmp_index < q_size; tmp_index++)
          begin //{
            if(receive_pkt_vc3_q[tmp_index].pl_rd_cnter >= receive_pkt_vc3_q[tmp_index].pl_rd)
            begin //{
              `uvm_do_callbacks(srio_pl_pkt_handler, srio_pl_callback, srio_pl_trans_received(pkth_trans_ins))
              pl_handler_gen_put_port.put(receive_pkt_vc3_q[tmp_index]);
              receive_pkt_vc3_q.delete(tmp_index);
            end //}
            else
            begin //{
              receive_pkt_vc3_q[tmp_index].pl_rd_cnter++;
            end //}
          end //}
        end //}
     end //}
 endtask : pkt_push_transmit_mode_vc3 

////////////////////////////////////////////////////////////////////////////////////////////
/// Name: pkt_push_transmit_mode_vc4 \n
/// Description: Task to  delay the transmission of VC4 packets to upper layers 
////////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_pkt_handler:: pkt_push_transmit_mode_vc4();
 int q_size;
     forever
     begin //{
        @(posedge common_com_trans.int_clk)
        begin //{
          q_size = receive_pkt_vc4_q.size();
          for(int tmp_index = 0; tmp_index < q_size; tmp_index++)
          begin //{
            if(receive_pkt_vc4_q[tmp_index].pl_rd_cnter >= receive_pkt_vc4_q[tmp_index].pl_rd)
            begin //{
              `uvm_do_callbacks(srio_pl_pkt_handler, srio_pl_callback, srio_pl_trans_received(pkth_trans_ins))
              pl_handler_gen_put_port.put(receive_pkt_vc4_q[tmp_index]);
              receive_pkt_vc4_q.delete(tmp_index);
            end //}
            else
            begin //{
              receive_pkt_vc4_q[tmp_index].pl_rd_cnter++;
            end //}
          end //}
        end //}
     end //}
 endtask : pkt_push_transmit_mode_vc4 

////////////////////////////////////////////////////////////////////////////////////////////
/// Name: pkt_push_transmit_mode_vc5 \n
/// Description: Task to  delay the transmission of VC5 packets to upper layers 
////////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_pkt_handler:: pkt_push_transmit_mode_vc5();
 int q_size;
     forever
     begin //{
        @(posedge common_com_trans.int_clk)
        begin //{
          q_size = receive_pkt_vc5_q.size();
          for(int tmp_index = 0; tmp_index < q_size; tmp_index++)
          begin //{
            if(receive_pkt_vc5_q[tmp_index].pl_rd_cnter >= receive_pkt_vc5_q[tmp_index].pl_rd)
            begin //{
              `uvm_do_callbacks(srio_pl_pkt_handler, srio_pl_callback, srio_pl_trans_received(pkth_trans_ins))
              pl_handler_gen_put_port.put(receive_pkt_vc5_q[tmp_index]);
              receive_pkt_vc5_q.delete(tmp_index);
            end //}
            else
            begin //{
              receive_pkt_vc5_q[tmp_index].pl_rd_cnter++;
            end //}
          end //}
        end //}
     end //}
 endtask : pkt_push_transmit_mode_vc5 

////////////////////////////////////////////////////////////////////////////////////////////
/// Name: pkt_push_transmit_mode_vc6 \n
/// Description: Task to  delay the transmission of VC6 packets to upper layers 
////////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_pkt_handler:: pkt_push_transmit_mode_vc6();
 int q_size;
     forever
     begin //{
        @(posedge common_com_trans.int_clk)
        begin //{
          q_size = receive_pkt_vc6_q.size();
          for(int tmp_index = 0; tmp_index < q_size; tmp_index++)
          begin //{
            if(receive_pkt_vc6_q[tmp_index].pl_rd_cnter >= receive_pkt_vc6_q[tmp_index].pl_rd)
            begin //{
              `uvm_do_callbacks(srio_pl_pkt_handler, srio_pl_callback, srio_pl_trans_received(pkth_trans_ins))
              pl_handler_gen_put_port.put(receive_pkt_vc6_q[tmp_index]);
              receive_pkt_vc6_q.delete(tmp_index);
            end //}
            else
            begin //{
              receive_pkt_vc6_q[tmp_index].pl_rd_cnter++;
            end //}
          end //}
        end //}
     end //}
 endtask : pkt_push_transmit_mode_vc6 

////////////////////////////////////////////////////////////////////////////////////////////
/// Name: pkt_push_transmit_mode_vc7 \n
/// Description: Task to  delay the transmission of VC7 packets to upper layers 
////////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_pkt_handler:: pkt_push_transmit_mode_vc7();
 int q_size;
     forever
     begin //{
        @(posedge common_com_trans.int_clk)
        begin //{
          q_size = receive_pkt_vc7_q.size();
          for(int tmp_index = 0; tmp_index < q_size; tmp_index++)
          begin //{
            if(receive_pkt_vc7_q[tmp_index].pl_rd_cnter >= receive_pkt_vc7_q[tmp_index].pl_rd)
            begin //{
              `uvm_do_callbacks(srio_pl_pkt_handler, srio_pl_callback, srio_pl_trans_received(pkth_trans_ins))
              pl_handler_gen_put_port.put(receive_pkt_vc7_q[tmp_index]);
              receive_pkt_vc7_q.delete(tmp_index);
            end //}
            else
            begin //{
              receive_pkt_vc7_q[tmp_index].pl_rd_cnter++;
            end //}
          end //}
        end //}
     end //}
 endtask : pkt_push_transmit_mode_vc7 

////////////////////////////////////////////////////////////////////////////////////////////
/// Name: pkt_push_transmit_mode_vc8 \n
/// Description: Task to  delay the transmission of VC8 packets to upper layers 
////////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_pkt_handler:: pkt_push_transmit_mode_vc8();
 int q_size;
     forever
     begin //{
        @(posedge common_com_trans.int_clk)
        begin //{
          q_size = receive_pkt_vc8_q.size();
          for(int tmp_index = 0; tmp_index < q_size; tmp_index++)
          begin //{
            if(receive_pkt_vc8_q[tmp_index].pl_rd_cnter >= receive_pkt_vc8_q[tmp_index].pl_rd)
            begin //{
              `uvm_do_callbacks(srio_pl_pkt_handler, srio_pl_callback, srio_pl_trans_received(pkth_trans_ins))
              pl_handler_gen_put_port.put(receive_pkt_vc8_q[tmp_index]);
              receive_pkt_vc8_q.delete(tmp_index);
            end //}
            else
            begin //{
              receive_pkt_vc8_q[tmp_index].pl_rd_cnter++;
            end //}
          end //}
        end //}
     end //}
 endtask : pkt_push_transmit_mode_vc8 

////////////////////////////////////////////////////////////////////////////////////////////
/// Name: resp_random_delay \n
/// Description: Task to  delay the transmission of Packet Accepted/Not Accepted Control
/// symbols. Also when multiple ackid is supported, queues all the PACC,PNAC and retry control
/// symbols and chooses to transmit either the last PACC or the first PNAC/Retry CS 
////////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_pkt_handler:: resp_random_delay();
 int q_size;
 int mark;
 bit retry_nac_flg;
 int no_of_cs;
     forever
     begin //{
        @(posedge common_com_trans.int_clk)
        begin //{
          q_size = cs_dly_q.size();
          retry_nac_flg=0;
          for(int tmp_index = 0; tmp_index < q_size; tmp_index++)
          begin //{
            if(cs_dly_q[tmp_index].pl_rd_cnter >= cs_dly_q[tmp_index].pl_rd)
            begin //{
              temp_srio_trans = new cs_dly_q[tmp_index];
              if(temp_srio_trans.stype0 == 4'b0000)
              begin// {
                for(int i=0;i<rx_outstanding_ackid_q.size();i++)
                begin//{
                   temp_trans = new rx_outstanding_ackid_q[i];
                   if(temp_trans.ackid == common_com_trans.curr_rx_ackid)
                       rx_outstanding_ackid_q.delete(i);
                end //}
              //  outstanding_ackid = outstanding_ackid - 1;
              //  inc_ackid();
              end //} 
              `uvm_do_callbacks(srio_pl_pkt_handler, srio_pl_callback, srio_pl_trans_received(pkth_trans_ins))
              if(pkth_config.multiple_ack_support)
               begin//{
               for(int k=0;k<cs_dly_q.size();k++)
                begin//{
                 temp_srio_trans = new cs_dly_q[k];
                   if((temp_srio_trans.stype0 == 4'b0001) || (temp_srio_trans.stype0 == 4'b0010)) 
                    begin//{
                      common_com_trans.gr_curr_tx_ackid=temp_srio_trans.param0;
                      pkt_merge_ins.pl_gencs_q.push_back(cs_dly_q[k]);
                      retry_nac_flg=1;
                      break;
                    end//}
                end//}
                if(retry_nac_flg)
                  retry_nac_flg=0;
                else
                 begin//{
                  temp_srio_trans = new cs_dly_q[$];
                  inc_ackid_mul(temp_srio_trans.param0);
                  for(mark=0;mark<rx_outstanding_ackid_q.size();mark++)
                   begin//{
                    del_trans = new rx_outstanding_ackid_q[mark];
                    if(del_trans.ackid==temp_srio_trans.param0)
                     break;
                   end//}  
                   for(int j=0;j<=mark;j++)
                    rx_outstanding_ackid_q.delete(0);
                   pkt_merge_ins.pl_gencs_q.push_back(cs_dly_q.pop_back());
                end//}
                cs_dly_q.delete();
               end//}
              else
               begin//{
                no_of_cs=$urandom_range(1,cs_dly_q.size());
                for(int j=0;j<no_of_cs;j++)
                 begin//{
                  temp_srio_trans = new cs_dly_q[0];
                  if(temp_srio_trans.stype0==1 || temp_srio_trans.stype0==2)
                    reform_cs(temp_srio_trans);
                  else
                   pkt_merge_ins.pl_gencs_q.push_back(cs_dly_q[0]);
                  cs_dly_q.delete(0);
                  if(temp_srio_trans.stype0==0)
                   begin//{
                    common_com_trans.ackid_for_scs= temp_srio_trans.param0+1;
                for(int i=0;i<rx_outstanding_ackid_q.size();i++)
                begin//{
                   temp_trans = new rx_outstanding_ackid_q[i];
                   if(temp_trans.ackid == temp_srio_trans.param0)
                       rx_outstanding_ackid_q.delete(i);
                end //}
 
                   end//}
                 end//}
               end//}
              break;
            end //}
            else
            begin //{
              cs_dly_q[tmp_index].pl_rd_cnter++;
            end //}
          end //}
        end //}
     end //}
 endtask : resp_random_delay 

////////////////////////////////////////////////////////////////////////////////////////////
/// Name: pkt_resp_random_delay \n
/// Description: Task to  delay passing the packets to upper layers
////////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_pkt_handler:: pkt_resp_random_delay();
 int pkt_q_size;
     forever
     begin //{ 
        @(posedge common_com_trans.int_clk)
        begin //{
          pkt_q_size = pkt_dly_q.size();
          for(int tmp_index = 0; tmp_index < pkt_q_size; tmp_index++)
          begin //{
            if(pkt_dly_q[tmp_index].pl_pkt_rd_cnter >= pkt_dly_q[tmp_index].pl_pkt_rd)
            begin //{
              `uvm_do_callbacks(srio_pl_pkt_handler, srio_pl_callback, srio_pl_trans_received(pkth_trans_ins))
              pl_handler_gen_put_port.put(pkt_dly_q[tmp_index]);
              pkt_dly_q.delete(tmp_index);
              break;
            end //}
            else
            begin //{
              pkt_dly_q[tmp_index].pl_pkt_rd_cnter++;
            end //}
          end //}
        end //}
     end //}
 endtask : pkt_resp_random_delay

 
////////////////////////////////////////////////////////////////////////////////////////////
/// Name: initialize \n
/// Description: Task to initialize the ackid and buffer values 
////////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_pkt_handler::initialize();
   common_com_trans.curr_rx_ackid        = 0; 
   common_com_trans.tx_status_cs_cnt = 0;
   if(pkth_config.flow_control_mode == RECEIVE)
     buf_status = 12'hFFF;

   if(pkth_config.flow_control_mode == TRANSMIT)
   begin //{
     if(handler_env_config.multi_vc_support == 1'b1)
     begin //{
         if(handler_env_config.vc_num_support == 1)
         begin //{
            free_buf_cnt_vc0 = pkth_config.buffer_space/2;
            free_buf_cnt_vc1 = pkth_config.buffer_space - free_buf_cnt_vc0;
         end //} 
         else if(handler_env_config.vc_num_support == 2)
         begin //{
            free_buf_cnt_vc0 = pkth_config.buffer_space/2;
            free_buf_cnt_vc1 = (pkth_config.buffer_space - free_buf_cnt_vc0)/2;
            free_buf_cnt_vc5 = (pkth_config.buffer_space - free_buf_cnt_vc0)/2;
         end //} 
         else if(handler_env_config.vc_num_support == 4)
         begin //{
            free_buf_cnt_vc0 = pkth_config.buffer_space/2;
            free_buf_cnt_vc1 = (pkth_config.buffer_space - free_buf_cnt_vc0)/4;
            free_buf_cnt_vc3 = (pkth_config.buffer_space - free_buf_cnt_vc0)/4;
            free_buf_cnt_vc5 = (pkth_config.buffer_space - free_buf_cnt_vc0)/4;
            free_buf_cnt_vc7 = (pkth_config.buffer_space - free_buf_cnt_vc0)/4;
         end //} 
         else if(handler_env_config.vc_num_support == 8)
         begin //{
            free_buf_cnt_vc0 = pkth_config.buffer_space/2;
            free_buf_cnt_vc1 = (pkth_config.buffer_space - free_buf_cnt_vc0)/8;
            free_buf_cnt_vc2 = (pkth_config.buffer_space - free_buf_cnt_vc0)/8;
            free_buf_cnt_vc3 = (pkth_config.buffer_space - free_buf_cnt_vc0)/8;
            free_buf_cnt_vc4 = (pkth_config.buffer_space - free_buf_cnt_vc0)/8;
            free_buf_cnt_vc5 = (pkth_config.buffer_space - free_buf_cnt_vc0)/8;
            free_buf_cnt_vc6 = (pkth_config.buffer_space - free_buf_cnt_vc0)/8;
            free_buf_cnt_vc7 = (pkth_config.buffer_space - free_buf_cnt_vc0)/8;
            free_buf_cnt_vc8 = (pkth_config.buffer_space - free_buf_cnt_vc0)/8;
         end //} 
     end //}
     else
     begin //{
         free_buf_cnt_vc0 = pkth_config.buffer_space;
     end //}
   end //}  
  
  
 endtask : initialize 


////////////////////////////////////////////////////////////////////////////////////////////
/// Name: run_TSG \n
/// Description: Task to run TSG timer on the TSG_clk. The timer will be updated with the   
/// value received on Timestamp control symbol. The Timestamp0 and Timestamp1 which are
/// taken on transmission of Loop request and reception of Loop Response respectively are
/// based on this timer.
///////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_pkt_handler::run_TSG();
   forever
      begin //{
        @(posedge srio_if.TSG_clk or negedge srio_if.srio_rst_n)
        begin //{
         if(~srio_if.srio_rst_n)
          begin //{
           common_com_trans.TSG=0;
          end//}
        else
          begin //{
           if(update_TSG)
            begin
              common_com_trans.TSG=local_TSG;
              update_TSG=0;
             end
           else
            common_com_trans.TSG++;
          end//}
        end//}
     end//}
 endtask : run_TSG 

////////////////////////////////////////////////////////////////////////////////////////////
/// Name: gen_loop_req_cs \n
/// Description: Task to generate Loop Request when BFM is configured to be master and 
/// send_loop_request changes to '1'
///////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_pkt_handler::gen_loop_req_cs();  
  forever
  begin
     @(posedge common_com_trans.send_loop_request && common_com_trans.timestamp_master);
     common_com_trans.Timestamp0 = common_com_trans.TSG;  
     common_com_trans.loop_req_sent = 1;  
     trans_push_ins = new();
     trans_push_ins.pkt_type = SRIO_PL_PACKET;
     trans_push_ins.transaction_kind = SRIO_CS;
     trans_push_ins.stype0 = 4'b100;
     if(handler_env_config.srio_mode == SRIO_GEN30)
       trans_push_ins.cstype = CS64;
     else if(common_com_trans.bfm_idle_selected)
       trans_push_ins.cstype = CS48;
     else
       trans_push_ins.cstype = CS24;
     trans_push_ins.param0 = common_com_trans.curr_rx_ackid;
     if(pkth_config.multiple_ack_support)
      trans_push_ins.param0 = common_com_trans.gr_curr_tx_ackid;
     if(pkth_config.flow_control_mode == RECEIVE)
       trans_push_ins.param1 = 12'hfff;
     else
     begin //{
       if(handler_env_config.multi_vc_support == 1'b0)
         trans_push_ins.param1 = pkth_config.buffer_space - receive_pkt_q.size();
       else
         trans_push_ins.param1 = pkth_config.buffer_space - receive_pkt_vc0_q.size();
     end //}
     trans_push_ins.stype1  = 3'b101;
     trans_push_ins.cmd     = 3'b011;
     trans_push_ins.brc3_stype1_msb = 2'b00;
     cs_val = trans_push_ins.pack_cs();
     if(handler_env_config.srio_mode == SRIO_GEN30)
       void'(trans_push_ins.calccrc24(cs_val));
     else if(common_com_trans.bfm_idle_selected)
       void'(trans_push_ins.calccrc13(cs_val));
     else
       void'(trans_push_ins.calccrc5(cs_val));
     if(handler_env_config.srio_mode != SRIO_GEN30)
        void'(trans_push_ins.set_delimiter());
     void'(trans_push_ins.pack_cs_bytes());
      pkt_merge_ins.pl_gencs_q.push_back(trans_push_ins);
  end
 endtask:gen_loop_req_cs

////////////////////////////////////////////////////////////////////////////////////////////
/// Name: loop_req_timer \n
/// Description: Task to run the timeout timer when a Loop Request is received
///////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_pkt_handler::loop_req_timer();  
 forever
  begin
   wait( common_com_trans.loop_req_sent);
   repeat(pkth_config.link_timeout)
    begin//{
    if(~common_com_trans.loop_resp_recvd)
     @(posedge common_com_trans.int_clk);
    else
     break;
    end//}
     common_com_trans.loop_req_sent=0;
     common_com_trans.loop_resp_recvd=0;
  end
 endtask:loop_req_timer

////////////////////////////////////////////////////////////////////////////////////////////
/// Name: gen_loop_res_cs \n
/// Description: Task to generate Loop Reponse Control symbol when a Loop Request is 
/// received
///////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_pkt_handler::gen_loop_res_cs();  
     trans_push_ins = new();
     trans_push_ins.pkt_type = SRIO_PL_PACKET;
     trans_push_ins.transaction_kind = SRIO_CS;
     trans_push_ins.stype0 = 4'b1011;
     trans_push_ins.param0 = $urandom;
     trans_push_ins.param1 = $urandom;
     if(handler_env_config.srio_mode == SRIO_GEN30)
      begin//{
       trans_push_ins.cstype = CS64;
       trans_push_ins.stype0 = 4'b1011;
       trans_push_ins.param1 = 12'b0;
      end //}
     else if(common_com_trans.bfm_idle_selected)
       trans_push_ins.cstype = CS48;
     else
       trans_push_ins.cstype = CS24;

     trans_push_ins.stype1  = 3'b111;
     trans_push_ins.cmd     = 3'b000;
     trans_push_ins.brc3_stype1_msb = 2'b00;
     cs_val = trans_push_ins.pack_cs();
     if(handler_env_config.srio_mode == SRIO_GEN30)
       void'(trans_push_ins.calccrc24(cs_val));
     else if(common_com_trans.bfm_idle_selected)
       void'(trans_push_ins.calccrc13(cs_val));
     else
       void'(trans_push_ins.calccrc5(cs_val));
     if(handler_env_config.srio_mode != SRIO_GEN30)
        void'(trans_push_ins.set_delimiter());
     void'(trans_push_ins.pack_cs_bytes());
      pkt_merge_ins.pl_gencs_q.push_back(trans_push_ins);
 endtask:gen_loop_res_cs

////////////////////////////////////////////////////////////////////////////////////////////
/// Name: gen_timestamp_cs \n
/// Description: Task to generate the timestamp control symbol when send_timestamp or 
/// send_zero_timestamp becomes '1' or auto _enable is high and the timer is expired.
///////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_pkt_handler::gen_timestamp_cs();  
  int no_of_cs;
  bit[0:63] TSG;
  forever
   begin
     wait(send_TS);
     begin
       send_TS=0;
       TSG=send_zero_TS?0:(common_com_trans.TSG+common_com_trans.timestamp_offset);
       send_zero_TS=0;
       no_of_cs=(handler_env_config.srio_mode == SRIO_GEN30)?4:8;
       for (int i=0;i<no_of_cs;i++)
       begin
         trans_push_ins = new();
         trans_push_ins.pkt_type = SRIO_PL_PACKET;
         trans_push_ins.transaction_kind = SRIO_CS;
         trans_push_ins.stype0 = 4'b0011;
         trans_push_ins.param0 = 0;
         trans_push_ins.param1 = 0;
         if(handler_env_config.srio_mode != SRIO_GEN30)
          begin
           case (i)
            0:
              begin
               trans_push_ins.param0[7]=1'b1;
               trans_push_ins.param0[9:11]=TSG[0:2];
               trans_push_ins.param1[7:11]=TSG[3:7];
              end
            1:
              begin
               trans_push_ins.param0[9:11]=TSG[8:10];
               trans_push_ins.param1[7:11]=TSG[11:15];
              end
            2:
              begin
               trans_push_ins.param0[9:11]=TSG[16:18];
               trans_push_ins.param1[7:11]=TSG[19:23];
              end
            3:
              begin
               trans_push_ins.param0[9:11]=TSG[24:26];
               trans_push_ins.param1[7:11]=TSG[27:31];
              end
            4:
              begin
               trans_push_ins.param0[9:11]=TSG[32:34];
               trans_push_ins.param1[7:11]=TSG[35:39];
              end
            5:
              begin
               trans_push_ins.param0[9:11]=TSG[40:42];
               trans_push_ins.param1[7:11]=TSG[43:47];
              end
            6:
              begin
               trans_push_ins.param0[9:11]=TSG[48:50];
               trans_push_ins.param1[7:11]=TSG[51:55];
              end
            7:
              begin
               trans_push_ins.param0[9:11]=TSG[56:58];
               trans_push_ins.param1[7:11]=TSG[59:63];
               trans_push_ins.param0[8]=1'b1;
              end
           endcase
          end
        else
         begin
           case (i)
            0:
              begin
               trans_push_ins.param0[3:4]=0;
               trans_push_ins.param0[8:11]=TSG[0:3];
               trans_push_ins.param1      =TSG[4:15];
              end
            1:
              begin
               trans_push_ins.param0[3:4]=2'b01;
               trans_push_ins.param0[8:11]=TSG[16:19];
               trans_push_ins.param1      =TSG[20:31];
              end
            2:
              begin
               trans_push_ins.param0[3:4]=2'b10;
               trans_push_ins.param0[8:11]=TSG[32:35];
               trans_push_ins.param1      =TSG[36:47];
              end
            3:
              begin
               trans_push_ins.param0[3:4]=2'b11;
               trans_push_ins.param0[8:11]=TSG[48:51];
               trans_push_ins.param1      =TSG[52:63];
              end
          endcase
         end

         if(handler_env_config.srio_mode == SRIO_GEN30)
          begin//{
           trans_push_ins.cstype = CS64;
          end //}
         else if(common_com_trans.bfm_idle_selected)
           trans_push_ins.cstype = CS48;
         else
           trans_push_ins.cstype = CS24;
         trans_push_ins.stype1  = 3'b111;
         trans_push_ins.cmd     = 3'b000;
         trans_push_ins.brc3_stype1_msb = 2'b00;
         cs_val = trans_push_ins.pack_cs();
         if(handler_env_config.srio_mode == SRIO_GEN30)
           void'(trans_push_ins.calccrc24(cs_val));
         else if(common_com_trans.bfm_idle_selected)
           void'(trans_push_ins.calccrc13(cs_val));
         else
           void'(trans_push_ins.calccrc5(cs_val));
         if(handler_env_config.srio_mode != SRIO_GEN30)
            void'(trans_push_ins.set_delimiter());
         void'(trans_push_ins.pack_cs_bytes());
          pkt_merge_ins.pl_gencs_q.push_back(trans_push_ins);
        end
       end
    end
 endtask:gen_timestamp_cs



//////////////////////////////////////////////////////////////////////////
/// Name: run_TS_autoupdate_timer \n
/// Description: Task to run the timer for Timestamp auto updation.
/// The timer will run when the BFM is configures to be a master and auto 
/// enable for timestamp generation is high
//////////////////////////////////////////////////////////////////////////
 task srio_pl_pkt_handler::run_TS_autoupdate_timer();  
   forever
      begin //{
        @(posedge common_com_trans.int_clk or negedge srio_if.srio_rst_n)
        begin //{
        if(~srio_if.srio_rst_n)
         begin
          TS_auto_cntr=0;
          send_TS=0;
         end
        else if(pkth_config.timestamp_auto_update_en && common_com_trans.timestamp_master)
         begin //{
          if(TS_auto_cntr==0)
           begin
            TS_auto_cntr=(pkth_config.timestamp_auto_update_timer-1000);
            send_TS=1;
           end
          else
           begin
            TS_auto_cntr--;        
            send_TS=0;
           end
         end//}
        end//}
      end//}
 endtask:run_TS_autoupdate_timer


//////////////////////////////////////////////////////////////////////////
/// Name: get_timestamp_req \n
/// Description: Task to get the Timestamp trigger input from the test
//////////////////////////////////////////////////////////////////////////
 task srio_pl_pkt_handler::get_timestamp_req();  
   forever
      begin //{
        @((common_com_trans.send_timestamp || common_com_trans.send_zero_timestamp)&& common_com_trans.timestamp_master); 
          begin
           if(common_com_trans.send_timestamp || common_com_trans.send_zero_timestamp)
            send_TS=1;
           if(common_com_trans.send_zero_timestamp)
            send_zero_TS=1;
          end
      end//}
  endtask:get_timestamp_req


////////////////////////////////////////////////////////////////////////////////////////////
/// Name: pop_trans_user\n
/// Description: Task to provide the received transaction to the user through ports. 
////////////////////////////////////////////////////////////////////////////////////////////
  task srio_pl_pkt_handler::pop_trans_user();
   forever
      begin //{
        @(negedge common_com_trans.int_clk or negedge srio_if.srio_rst_n)
         begin //{
          if(common_com_trans.pl_rx_srio_trans_q.size() != 0)
           begin //{ 
             pkth_trans_ins = new common_com_trans.pl_rx_srio_trans_q.pop_front();
             pl_handler_gen_put_port.put(pkth_trans_ins);
           end//}
         end//}
      end//}
  endtask:pop_trans_user
////////////////////////////////////////////////////////////////////////////////////////////
/// Name: reform_cs\n
/// Description: Task to re-generate Control Symbol. 
////////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_pkt_handler::reform_cs(input srio_trans temp_srio_trans);
  temp_srio_trans.param0= common_com_trans.ackid_for_scs; 
     cs_val = temp_srio_trans.pack_cs();
     if(handler_env_config.srio_mode == SRIO_GEN30)
       void'(temp_srio_trans.calccrc24(cs_val));
     else if(common_com_trans.bfm_idle_selected)
       void'(temp_srio_trans.calccrc13(cs_val));
     else 
       void'(temp_srio_trans.calccrc5(cs_val));
     if(handler_env_config.srio_mode != SRIO_GEN30)
       temp_srio_trans.delimiter = 8'h1C;
     void'(temp_srio_trans.pack_cs_bytes());
     pkt_merge_ins.pl_gencs_q.push_back(temp_srio_trans); 
 endtask:reform_cs

///////////////////////////////////////////////////////////////////////////////////////////////
/// Name :tb_reset_ackid 
/// Description :Task to reset BFM ackid 
///////////////////////////////////////////////////////////////////////////////////////////////

 task srio_pl_pkt_handler::tb_reset_ackid();
 forever
  begin//{
   wait(handler_env_config.reset_ackid==1);
    common_com_trans.ackid_for_scs=0;
    ackid=0;
     outstanding_ackid = 0;
   wait(handler_env_config.reset_ackid==0);
  end//}
endtask:tb_reset_ackid
