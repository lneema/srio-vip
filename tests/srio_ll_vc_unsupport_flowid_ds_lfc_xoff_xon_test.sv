////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_vc_unsupport_flowid_ds_lfc_xoff_xon_test .sv
// Project :  srio vip
// Purpose :  LFC -- Data streaming test
// Author  :  Mobiveil
//
// 1.Configuring DS MTU and enable Multi VC support.
// 2.Data streaming with Multi segment packet 
// 3.LFC XOFF and XON for VC 's with unsupported flowID
////////////////////////////////////////////////////////////////////////////////
class srio_ll_vc_unsupport_flowid_ds_lfc_xoff_xon_test extends srio_base_test;

  `uvm_component_utils(srio_ll_vc_unsupport_flowid_ds_lfc_xoff_xon_test)

  rand bit [7:0] mtusize_2;
  rand bit [15:0] pdu_length_2;
  rand bit [1:0] pri,mode;
  rand bit crf_2,vc_2,flag,sel;
  rand bit [6:0] flowid_0;
  rand int support;
  srio_ll_vc_ds_mseg_req_seq vc_ds_mseg_req_seq;
  srio_ll_maintenance_ds_support_reg_seq ll_maintenance_ds_support_reg_seq; 
  srio_ll_vc_lfc_xoff_seq ll_vc_lfc_xoff_seq;
  srio_ll_vc_lfc_xon_seq ll_vc_lfc_xon_seq; 
  function new(string name, uvm_component parent=null);
  super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
      mode = $urandom_range(32'd2,32'd0);
      sel = $urandom;
      vc_2 = 1; 
      env_config1.multi_vc_support = vc_2;
      env_config2.multi_vc_support = vc_2;
      
      case(mode) //{
      2'b00 : begin support = 1; pri = 2'b10; crf_2 = 1'b0; end    
      2'b01 : begin support = 2; pri = sel ? 2'b11 : 2'b10; crf_2 = 1'b0; end    
      2'b10 : begin support = 4; pri = $urandom_range(32'd3,32'd0); crf_2 = 1'b0; end    
       
      endcase //}   
      env_config1.vc_num_support = support;
      env_config2.vc_num_support = support;

    env1.tl_agent.tl_config.usr_sourceid_en = TRUE;
    env1.tl_agent.tl_config.usr_destinationid_en = TRUE;
    env1.tl_agent.tl_config.usr_sourceid = 32'h1;
    env1.tl_agent.tl_config.usr_destinationid = 32'h2;
    env2.tl_agent.tl_config.usr_sourceid_en = TRUE;
    env2.tl_agent.tl_config.usr_destinationid_en = TRUE;
    env2.tl_agent.tl_config.usr_sourceid = 32'h2;
    env2.tl_agent.tl_config.usr_destinationid = 32'h1;

    vc_ds_mseg_req_seq = srio_ll_vc_ds_mseg_req_seq::type_id::create("vc_ds_mseg_req_seq");
    ll_vc_lfc_xoff_seq = srio_ll_vc_lfc_xoff_seq::type_id::create("ll_vc_lfc_xoff_seq");
    ll_vc_lfc_xon_seq  = srio_ll_vc_lfc_xon_seq ::type_id::create("ll_vc_lfc_xon_seq");
    ll_maintenance_ds_support_reg_seq = srio_ll_maintenance_ds_support_reg_seq::type_id::create("ll_maintenance_ds_support_reg_seq");

   phase.raise_objection( this );
      mtusize_2 = $urandom_range(32'd64,32'd8);
      pdu_length_2 = $urandom_range(32'h0000_0FFF,mtusize_2*4);
   
   // Configuring MTU
      ll_maintenance_ds_support_reg_seq.mtusize_1 = mtusize_2;
      ll_maintenance_ds_support_reg_seq.start( env1.e_virtual_sequencer);

    //Configuring MTU 
      ll_maintenance_ds_support_reg_seq.mtusize_1 = mtusize_2;
      ll_maintenance_ds_support_reg_seq.start( env2.e_virtual_sequencer);
    fork //{
    begin //{
   //DS Packet 
     vc_ds_mseg_req_seq.prio_1 = pri;
     vc_ds_mseg_req_seq.crf_1 = crf_2;
     vc_ds_mseg_req_seq.mtusize_1 = mtusize_2;
     vc_ds_mseg_req_seq.pdu_length_1 = pdu_length_2;
     vc_ds_mseg_req_seq.vc_1 = vc_2;
     vc_ds_mseg_req_seq.start( env2.e_virtual_sequencer);
     end //}
     begin //{
     wait (env2.ll_agent.ll_config.bfm_tx_pkt_cnt > 2);
     env2.ll_agent.ll_config.block_ll_traffic = TRUE;
     ll_vc_lfc_xoff_seq.vc_1 = vc_2;      // LFC XOFF
     ll_vc_lfc_xoff_seq.flowid = {4'b1000,pri,crf_2};
     ll_vc_lfc_xoff_seq.start( env1.e_virtual_sequencer);
     #500ns;
     env2.ll_agent.ll_config.block_ll_traffic = FALSE;
     #500ns;
     ll_vc_lfc_xon_seq.vc_1 = vc_2;      // LFC XON
     ll_vc_lfc_xon_seq.flowid = {4'b1000,pri,crf_2};
     ll_vc_lfc_xon_seq.start( env1.e_virtual_sequencer);
     end //}
     join //}


     #50000ns;
     phase.drop_objection(this);
 
    
  endtask
endclass


