////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_parallel_mode_test.sv
// Project :  srio vip
// Purpose :  IO Test 
// Author  :  Mobiveil
//
// 1. Set mode of transmission in Parallel.
// 2. Send IO passing Random sequences
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_parallel_mode_test extends srio_base_test;

  `uvm_component_utils(srio_ll_parallel_mode_test)
  
  srio_ll_io_random_seq  ll_io_random_seq;

  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
  
    env_config1.srio_interface_mode = SRIO_PARALLEL;
`ifdef SRIO_VIP_B2B 
    env_config2.srio_interface_mode = SRIO_PARALLEL;
`endif

    ll_io_random_seq = srio_ll_io_random_seq::type_id::create("ll_io_random_seq");

    phase.raise_objection( this );
    
    ll_io_random_seq.start( env1.e_virtual_sequencer);
      
    #1000ns;  
    phase.drop_objection(this);
    
  endtask

endclass


