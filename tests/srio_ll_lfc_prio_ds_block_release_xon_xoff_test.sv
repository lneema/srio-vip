////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_lfc_prio_ds_block_release_xon_xoff_test.sv
// Project :  srio vip
// Purpose :  LFC Test 
// Author  :  Mobiveil
//
// Test for LFC with xoff higer priority and xon priority lesser than DS packet
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_lfc_prio_ds_block_release_xon_xoff_test extends srio_base_test;

  `uvm_component_utils(srio_ll_lfc_prio_ds_block_release_xon_xoff_test)

  srio_ll_lfc_user_gen_xoff_seq  ll_lfc_user_gen_xoff_seq;
  srio_ll_lfc_user_gen_xon_seq   ll_lfc_user_gen_xon_seq;
  srio_ll_lfc_ds_seq  ll_lfc_ds_seq;


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


    ll_lfc_user_gen_xoff_seq = srio_ll_lfc_user_gen_xoff_seq::type_id::create("ll_lfc_user_gen_xoff_seq");
    ll_lfc_user_gen_xon_seq = srio_ll_lfc_user_gen_xon_seq::type_id::create("ll_lfc_user_gen_xon_seq");
    ll_lfc_ds_seq = srio_ll_lfc_ds_seq::type_id::create("ll_lfc_ds_seq");

    phase.raise_objection( this );

    fork 
    begin 
      ll_lfc_ds_seq.prior = 2'b01;
      ll_lfc_ds_seq.crf_1 = 1'b0;  
      ll_lfc_ds_seq.start( env2.e_virtual_sequencer);
    end 
    begin 
        wait (env2.ll_agent.ll_config.bfm_tx_pkt_cnt >1 ) ;
        env2.ll_agent.ll_config.block_ll_traffic = TRUE;
        ll_lfc_user_gen_xoff_seq.flowid = 7'd4;
        ll_lfc_user_gen_xoff_seq.start( env1.e_virtual_sequencer);
        #1000ns;
        env2.ll_agent.ll_config.block_ll_traffic = FALSE;
         #500ns;
        ll_lfc_user_gen_xon_seq.flowid = 7'd0;
        ll_lfc_user_gen_xon_seq.start( env1.e_virtual_sequencer);
    end
      join 
    #5000ns;	
    
       phase.drop_objection(this);
    
  endtask

  
endclass


