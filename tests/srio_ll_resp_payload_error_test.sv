
////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_resp_payload_error_test .sv
// Project :  srio vip
// Purpose :  ERROR
// Author  :  Mobiveil
//
// Test for ERROR for resp_payload .
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_resp_payload_error_test extends srio_base_test;

  `uvm_component_utils(srio_ll_resp_payload_error_test)

  srio_ll_resp_payload_error_seq resp_payload_error_seq;

    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    resp_payload_error_seq = srio_ll_resp_payload_error_seq::type_id::create("resp_payload_error_seq");

     phase.raise_objection( this );
     resp_payload_error_seq.start( env1.e_virtual_sequencer);
    #20000ns;
 
    phase.drop_objection(this);
    
  endtask


endclass


