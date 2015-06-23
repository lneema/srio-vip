////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_lfc_req_xon_ds_single_pdu_0_test.sv
// Project :  srio vip
// Purpose :  LFC Test 
// Author  :  Mobiveil
//
// 1.flow arbiration support
// 2.Request single PDU for sequence number 0
// 3.LFC XON for sequence number 0.
// 4.DS single PDU.
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_lfc_req_xon_ds_single_pdu_0_test extends srio_base_test;

  `uvm_component_utils(srio_ll_lfc_req_xon_ds_single_pdu_0_test)

  srio_ll_lfc_request_flow_spdu_0_seq  ll_lfc_request_flow_spdu_0_seq;
  //srio_ll_lfc_release_0_seq   ll_lfc_release_0_seq;
  srio_ll_lfc_ds_single_pdu_arb_seq  ll_lfc_ds_single_pdu_arb_seq;
  srio_ll_lfc_xon_arb_0_seq  ll_lfc_xon_arb_0_seq;
  srio_ll_flow_arb_support_reg_seq ll_flow_arb_support_reg_seq;


  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);


    env1.tl_agent.tl_config.usr_sourceid_en = TRUE;
    env1.tl_agent.tl_config.usr_destinationid_en = TRUE;
    env1.tl_agent.tl_config.usr_sourceid = 32'h2;
    env1.tl_agent.tl_config.usr_destinationid = 32'h1;
    env2.tl_agent.tl_config.usr_sourceid_en = TRUE;
    env2.tl_agent.tl_config.usr_destinationid_en = TRUE;
    env2.tl_agent.tl_config.usr_sourceid = 32'h1;
    env2.tl_agent.tl_config.usr_destinationid = 32'h2;


    ll_lfc_request_flow_spdu_0_seq = srio_ll_lfc_request_flow_spdu_0_seq::type_id::create("ll_lfc_request_flow_spdu_0_seq");
    //ll_lfc_release_0_seq = srio_ll_lfc_release_0_seq::type_id::create("ll_lfc_release_0_seq");
    ll_lfc_ds_single_pdu_arb_seq = srio_ll_lfc_ds_single_pdu_arb_seq::type_id::create("ll_lfc_ds_single_pdu_arb_seq");
     ll_lfc_xon_arb_0_seq= srio_ll_lfc_xon_arb_0_seq::type_id::create("ll_lfc_xon_arb_0_seq");
   ll_flow_arb_support_reg_seq = srio_ll_flow_arb_support_reg_seq::type_id::create("ll_flow_arb_support_reg_seq");


    phase.raise_objection( this );
     
// flow arbiration support
     ll_flow_arb_support_reg_seq.start(env1.e_virtual_sequencer);

// Request single PDU for sequence number 0
     
     ll_lfc_request_flow_spdu_0_seq.flowid= 7'd0;
     ll_lfc_request_flow_spdu_0_seq.start( env1.e_virtual_sequencer);

// LFC XON for sequence number 0.
  
     ll_lfc_xon_arb_0_seq.flowid = 7'd0;
     ll_lfc_xon_arb_0_seq.start(env2.e_virtual_sequencer);

// DS single PDU   

     ll_lfc_ds_single_pdu_arb_seq.prior = 2'b00;
     ll_lfc_ds_single_pdu_arb_seq.crf_1 = 1'b0;
     ll_lfc_ds_single_pdu_arb_seq.start( env1.e_virtual_sequencer);
    #5000ns;	
    
       phase.drop_objection(this);
    
  endtask

  
endclass


