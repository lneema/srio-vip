
////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_lfc_xoff_request_flow_grnt_1_test .sv
// Project :  srio vip
// Purpose :  LFC Test 
// Author  :  Mobiveil
//
// Test for Lfc Xoff request flow Granted
//
////////////////////////////////////////////////////////////////////////////////


class srio_ll_lfc_xoff_request_flow_grnt_1_test extends srio_base_test;

  `uvm_component_utils(srio_ll_lfc_xoff_request_flow_grnt_1_test)

  srio_ll_lfc_xoff_request_flow_grnt_1_seq lfc_xoff_request_flow_grnt_1_seq;
    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    lfc_xoff_request_flow_grnt_1_seq = srio_ll_lfc_xoff_request_flow_grnt_1_seq::type_id::create("lfc_xoff_request_flow_grnt_1_seq");

    phase.raise_objection( this );
    lfc_xoff_request_flow_grnt_1_seq.start( env1.e_virtual_sequencer);

    #20000ns; 
       phase.drop_objection(this);
    
  endtask

 
endclass


