////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_atomic_invalid_size .sv
// Project :  srio vip
// Purpose :
// Author  :  Mobiveil
//
// Test for NWRITE_R request class
 //
////////////////////////////////////////////////////////////////////////////////


class srio_ll_atomic_invalid_size extends srio_base_test;

  `uvm_component_utils(srio_ll_atomic_invalid_size)

  srio_ll_atomic_invalid_size_seq illegal_atomic_seq;
    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    illegal_atomic_seq = srio_ll_atomic_invalid_size_seq::type_id::create("illegal_atomic_seq");
      phase.raise_objection( this );
     illegal_atomic_seq.start( env1.e_virtual_sequencer);

      
  #20000ns;

    phase.drop_objection(this);
    
  endtask


endclass


