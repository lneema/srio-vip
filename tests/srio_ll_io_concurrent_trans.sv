////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_io_concurrent_trans.sv
// Project :  srio vip
// Purpose :  IO Test 
// Author  :  Mobiveil
//
// Test for IO passing Random sequences
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_io_concurrent_trans extends srio_base_test;
  `uvm_component_utils(srio_ll_io_concurrent_trans)

   srio_ll_io_random_seq  ll_io_random_seq1;
   srio_ll_io_random_seq  ll_io_random_seq2;
   srio_ll_io_random_seq  ll_io_random_seq3;
   srio_ll_io_random_seq  ll_io_random_seq4;

  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
     ll_io_random_seq1 = srio_ll_io_random_seq::type_id::create("ll_io_random_seq1");
     ll_io_random_seq2 = srio_ll_io_random_seq::type_id::create("ll_io_random_seq2");
     ll_io_random_seq3 = srio_ll_io_random_seq::type_id::create("ll_io_random_seq3");
     ll_io_random_seq4 = srio_ll_io_random_seq::type_id::create("ll_io_random_seq4");
     phase.raise_objection( this );
    fork
     ll_io_random_seq1.start( env1.e_virtual_sequencer);
     ll_io_random_seq2.start( env1.e_virtual_sequencer);
     ll_io_random_seq3.start( env1.e_virtual_sequencer);
     ll_io_random_seq4.start( env1.e_virtual_sequencer);
    join
    #5000ns;
     phase.drop_objection(this);
  endtask
endclass
