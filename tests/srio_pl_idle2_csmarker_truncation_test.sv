////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_idle2_csmarker_truncation_test.sv
// Project :  srio vip
// Purpose :  IDLE2 Truncation
// Author  :  Mobiveil
//
// 
//Test file for IDLE2 csmarker truncation error test
////////////////////////////////////////////////////////////////////////////////


class srio_pl_idle2_csmarker_truncation_test extends srio_base_test;

  `uvm_component_utils(srio_pl_idle2_csmarker_truncation_test)

  srio_pl_idle2_csmarker_truncation_seq pl_idle2_csmarker_truncation_seq;
     
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    pl_idle2_csmarker_truncation_seq = srio_pl_idle2_csmarker_truncation_seq::type_id::create("pl_idle2_csmarker_truncation_seq");
   
     phase.raise_objection( this );
          pl_idle2_csmarker_truncation_seq.start( env1.e_virtual_sequencer);
     
  
    phase.drop_objection(this);
      endtask


endclass


