////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_nread_req_test .sv
// Project :  srio vip
// Purpose :  READ & WRITE
// Author  :  Mobiveil
//
// Test for NREAD  and NWRITE request class
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_read_write_test extends srio_base_test;

  `uvm_component_utils(srio_ll_read_write_test)
  srio_ll_nread_req_seq read_seq;
  srio_ll_nwrite_req_seq write_seq; 
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction
  task run_phase( uvm_phase phase );
    super.run_phase(phase);
     read_seq = srio_ll_nread_req_seq::type_id::create("read_seq");
     write_seq = srio_ll_nwrite_req_seq::type_id::create("write_seq");
     phase.raise_objection( this );
    fork
     read_seq.start( env1.e_virtual_sequencer);
     write_seq.start( env1.e_virtual_sequencer);
    join
    #20000ns;
    phase.drop_objection(this);
  endtask

  endclass


