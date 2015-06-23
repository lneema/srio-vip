////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_atomic_set_test.sv
// Project :  srio vip
// Purpose : Atomic  set test 
// Author  :  Mobiveil
//
// Test for Atomic  set .
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_atomic_set_test extends srio_base_test;

  `uvm_component_utils(srio_ll_atomic_set_test)

  srio_ll_atomic_set_seq atomic_set_seq;

    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    atomic_set_seq = srio_ll_atomic_set_seq::type_id::create("atomic_set_seq");

      phase.raise_objection( this );
     atomic_set_seq.start( env1.e_virtual_sequencer);
     
  #20000ns;

    phase.drop_objection(this);
    
  endtask


endclass


