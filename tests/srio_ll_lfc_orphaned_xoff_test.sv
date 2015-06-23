////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_lfc_orphaned_xoff_test.sv
// Project :  srio vip
// Purpose :  LFC Test 
// Author  :  Mobiveil
//
// Test for LFC.
// 1.Sending Normal packet .
// 2.Send LFC XOFF .
// 3.NO LFC XON.
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_lfc_orphaned_xoff_test extends srio_base_test;

  `uvm_component_utils(srio_ll_lfc_orphaned_xoff_test)

  srio_ll_lfc_user_gen_xoff_seq  ll_lfc_user_gen_xoff_seq;
  srio_ll_user_gen_seq  ll_user_gen_seq;


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
    env1.tl_agent.tl_config.lfc_orphan_timer = 800;
    ll_lfc_user_gen_xoff_seq = srio_ll_lfc_user_gen_xoff_seq::type_id::create("ll_lfc_user_gen_xoff_seq");
    ll_user_gen_seq = srio_ll_user_gen_seq::type_id::create("ll_user_gen_seq");

    phase.raise_objection( this );
    fork 
    begin
    #100ns;
    ll_user_gen_seq.prior = 2'b10;
    ll_user_gen_seq.crf_1 = 1'b1;  
    ll_user_gen_seq.start( env2.e_virtual_sequencer);
    end 
       begin
        env2.ll_agent.ll_config.block_ll_traffic = TRUE;

        ll_lfc_user_gen_xoff_seq.flowid = 7'd5;

        ll_lfc_user_gen_xoff_seq.start( env1.e_virtual_sequencer);
        #500ns;
         
        env2.ll_agent.ll_config.block_ll_traffic = FALSE;
       
     end

    join
    #50000ns;
       phase.drop_objection(this);
    
  endtask

  
endclass


