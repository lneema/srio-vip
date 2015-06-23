////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_nwrite_80bytes_less_greater_test.sv
// Project :  srio vip
// Purpose :  NWRITE
// Author  :  Mobiveil
//
// Test for NWRITE WITH 80bytes lesser and greater request packets
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_nwrite_80bytes_less_greater_test extends srio_base_test;

  `uvm_component_utils(srio_ll_nwrite_80bytes_less_greater_test)

  srio_ll_req_usr_wrsize_wdptr_class_vseq usr_wrsize_wdptr_class_seq;

    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

 task run_phase( uvm_phase phase );
  super.run_phase(phase);      
     usr_wrsize_wdptr_class_seq = srio_ll_req_usr_wrsize_wdptr_class_vseq::type_id::create("usr_wrsize_wdptr_class_seq");
     phase.raise_objection( this );
     usr_wrsize_wdptr_class_seq.start( env1.e_virtual_sequencer);
    #2000ns;
    phase.drop_objection(this);    
  endtask

  
endclass


