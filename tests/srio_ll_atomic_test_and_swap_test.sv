////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_atomic_test_and_swap_test .sv
// Project :  srio vip
// Purpose :atomic test and swap test 
// Author  :  Mobiveil
//
// Test file for atomic test and swap.
//
////////////////////////////////////////////////////////////////////////////////
class srio_ll_atomic_test_and_swap_test extends srio_base_test;

  `uvm_component_utils(srio_ll_atomic_test_and_swap_test)

  srio_ll_atomic_test_and_swap_seq atomic_test_and_swap_seq;

    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    atomic_test_and_swap_seq = srio_ll_atomic_test_and_swap_seq::type_id::create("atomic_test_and_swap_seq");

      phase.raise_objection( this );
     atomic_test_and_swap_seq.start( env1.e_virtual_sequencer);
     #20000ns;
  
    phase.drop_objection(this);
    
  endtask


endclass


