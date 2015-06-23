////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_ds_concurrent_test.sv
// Project :  srio vip
// Purpose :  Data streaming test
// Author  :  Mobiveil
//
// Dta streaming with Random test.
//
////////////////////////////////////////////////////////////////////////////////
class srio_ll_ds_concurrent_test extends srio_base_test;

  `uvm_component_utils(srio_ll_ds_concurrent_test)

  srio_ll_ds_concurrent_seq ds_concurrent_seq;
    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
      ds_concurrent_seq = srio_ll_ds_concurrent_seq::type_id::create("ds_concurrent_seq");
      phase.raise_objection( this );
      ds_concurrent_seq.start( env1.e_virtual_sequencer);
      #8000ns;
      phase.drop_objection(this);
    endtask

endclass


