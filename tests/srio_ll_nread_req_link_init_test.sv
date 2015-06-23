////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_nread_req_link_init_test .sv
// Project :  srio vip
// Purpose :  NREAD
// Author  :  Mobiveil
//
// Test for NREAD request class
// Nread case with Link Init wait
////////////////////////////////////////////////////////////////////////////////

class srio_ll_nread_req_link_init_test extends srio_base_test;

  `uvm_component_utils(srio_ll_nread_req_link_init_test)

  srio_ll_nread_req_seq nread_req_seq;

    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
       
    nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");

    phase.raise_objection( this );
    wait(env_config1.pl_mon_tx_link_initialized == 1);
    wait(env_config1.pl_mon_rx_link_initialized == 1);
    wait(env_config2.pl_mon_tx_link_initialized == 1);
    wait(env_config2.pl_mon_rx_link_initialized == 1);
    wait(env_config1.link_initialized == 1);
    wait(env_config2.link_initialized == 1);
    nread_req_seq.start( env1.e_virtual_sequencer);
    #2000ns;
 
    phase.drop_objection(this);
    
  endtask

  
endclass


