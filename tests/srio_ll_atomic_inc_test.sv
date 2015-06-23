////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_atomic_inc_test.sv
// Project :  srio vip
// Purpose : Atomic  increment test 
// Author  :  Mobiveil
//
// Test for Atomic  increment.
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_atomic_inc_test extends srio_base_test;

  `uvm_component_utils(srio_ll_atomic_inc_test)

  srio_ll_atomic_inc_seq atomic_inc_seq;

    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    atomic_inc_seq = srio_ll_atomic_inc_seq::type_id::create("atomic_inc_seq");

      phase.raise_objection( this );
     atomic_inc_seq.start( env1.e_virtual_sequencer);
     
  #20000ns; 

    phase.drop_objection(this);
    
  endtask

 

endclass


