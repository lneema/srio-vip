////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_nread_req_env1_env2_test .sv
// Project :  srio vip
// Purpose :  NREAD
// Author  :  Mobiveil
//
// Test for NREAD request class
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_nread_req_env1_env2_test extends srio_base_test;

  `uvm_component_utils(srio_ll_nread_req_env1_env2_test)

  srio_ll_nread_req_seq nread_req_seq;
  srio_ll_nread_req_seq nread_req_seq1;
    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");
    nread_req_seq1 = srio_ll_nread_req_seq::type_id::create("nread_req_seq1");
     phase.raise_objection( this );
    fork 
     nread_req_seq.start( env1.e_virtual_sequencer);
     nread_req_seq1.start( env2.e_virtual_sequencer);
    join 
   
    phase.drop_objection(this);
    
  endtask

  
endclass


