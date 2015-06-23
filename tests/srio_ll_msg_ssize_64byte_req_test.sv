////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_msg_ssize_64byte_req_test.sv
// Project :  srio vip
// Purpose : Message Test 
// Author  :  Mobiveil
//
//// Test for Message packet with standard size 64btye

////////////////////////////////////////////////////////////////////////////////


class srio_ll_msg_ssize_64byte_req_test extends srio_base_test;

  `uvm_component_utils(srio_ll_msg_ssize_64byte_req_test)

  srio_ll_msg_ssize_64byte_req_seq msg_ssize_64byte_req_seq;
   function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    msg_ssize_64byte_req_seq = srio_ll_msg_ssize_64byte_req_seq::type_id::create("msg_ssize_64byte_req_seq");
       phase.raise_objection( this );
  
   msg_ssize_64byte_req_seq.start( env1.e_virtual_sequencer);

    #20000ns; 
      phase.drop_objection(this);
    
  endtask


endclass


