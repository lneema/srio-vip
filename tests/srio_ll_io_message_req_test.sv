////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_io_message_req_test.sv
// Project :  srio vip
// Purpose :  IO and MESSAGE Concurrent Test 
// Author  :  Mobiveil
//
// Test for IO passing Random sequences
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_io_message_req_test extends srio_base_test;

  `uvm_component_utils(srio_ll_io_message_req_test)

    srio_ll_io_random_seq ll_io_random_seq;
    srio_ll_message_random_seq ll_message_random_seq; 

  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
     ll_io_random_seq = srio_ll_io_random_seq::type_id::create("ll_io_random_seq");
     ll_message_random_seq = srio_ll_message_random_seq::type_id::create("ll_message_random_seq");

    phase.raise_objection( this );
    fork
    ll_io_random_seq.start( env1.e_virtual_sequencer);
    ll_message_random_seq.start( env1.e_virtual_sequencer);
    join        
    #2000ns;
     phase.drop_objection(this);
   endtask

endclass


