////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_gsm_address_collision_test.sv
// Project :  srio vip
// Purpose :  GSM test 
// Author  :  Mobiveil
//
// Test for GSM packet with address collision
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_gsm_address_collision_test extends srio_base_test;

  `uvm_component_utils(srio_ll_gsm_address_collision_test)

  srio_ll_gsm_random_seq gsm_random_seq;

    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
      gsm_random_seq = srio_ll_gsm_random_seq::type_id::create("gsm_random_seq");
      phase.raise_objection( this );
    fork
     begin
      gsm_random_seq.start( env1.e_virtual_sequencer);
     end
     begin
      wait (env2.ll_agent.ll_config.bfm_tx_pkt_cnt > 5);
      env2.ll_agent.ll_config.block_ll_traffic = TRUE;
      #50000ns;
      env2.ll_agent.ll_config.block_ll_traffic = FALSE;
     end
    join
    #20000ns;
    phase.drop_objection(this);
    
  endtask


endclass


