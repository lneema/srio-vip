
////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_pl_nwrite_swrite_req_test .sv
// Project :  srio vip
// Purpose :  NREAD
// Author  :  Mobiveil
//
// Test for NREAD request class
//
////////////////////////////////////////////////////////////////////////////////

class srio_pl_nwrite_swrite_req_test extends srio_base_test;

  `uvm_component_utils(srio_pl_nwrite_swrite_req_test)

  srio_pl_nwrite_swrite_req_seq pl_nwrite_swrite_req_seq;

    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
       pl_nwrite_swrite_req_seq = srio_pl_nwrite_swrite_req_seq::type_id::create("pl_nwrite_swrite_req_seq");

     phase.raise_objection( this );
     pl_nwrite_swrite_req_seq.start( env1.e_virtual_sequencer);
    #20000ns;
 
    phase.drop_objection(this);
    
  endtask

  
endclass


