////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :srio_ll_message_random_test .sv
// Project :  srio vip
// Purpose :  Message test
// Author  :  Mobiveil
//
//// Test for Message packet random.

////////////////////////////////////////////////////////////////////////////////

class srio_ll_message_random_test extends srio_base_test;

  `uvm_component_utils(srio_ll_message_random_test)

  srio_ll_message_random_seq message_random_seq;
   function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    message_random_seq = srio_ll_message_random_seq::type_id::create("message_random_seq");
       phase.raise_objection( this );
  
   message_random_seq.start( env1.e_virtual_sequencer);

     #20000ns;
      phase.drop_objection(this);
    
  endtask

  endclass


