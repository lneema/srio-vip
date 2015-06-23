////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_lfc_xoff_test.sv
// Project :  srio vip
// Purpose :  LFC Test 
// Author  :  Mobiveil
//
// Test for LFC with  XOFF Only
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_lfc_xoff_test extends srio_base_test;

  `uvm_component_utils(srio_ll_lfc_xoff_test)

  srio_ll_lfc_xoff_seq lfc_xoff_seq;
    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    lfc_xoff_seq = srio_ll_lfc_xoff_seq::type_id::create("lfc_xoff_seq");

    phase.raise_objection( this );
    lfc_xoff_seq.start( env1.e_virtual_sequencer);

    #2000ns;
       phase.drop_objection(this);
    
  endtask


endclass


