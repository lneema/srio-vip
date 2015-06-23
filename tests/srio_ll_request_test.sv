////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_request_test .sv
// Project :  srio vip
// Purpose :  Request class test
// Author  :  Mobiveil
//
// Test for RANDOM request class
//
////////////////////////////////////////////////////////////////////////////////


class srio_ll_request_test extends srio_base_test;

  `uvm_component_utils(srio_ll_request_test)

  srio_ll_request_seq request_seq;
    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    request_seq = srio_ll_request_seq::type_id::create("request_seq");
      phase.raise_objection( this );
     request_seq.start( env1.e_virtual_sequencer);

      
  #20000ns;

    phase.drop_objection(this);
    
  endtask

  endclass


