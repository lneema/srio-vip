
////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_tl_pkt_tt_test .sv
// Project :  srio vip
// Purpose :  TRANSPORT TYPE
// Author  :  Mobiveil
//
// Test for TRANSPORT TYPE request class
//
////////////////////////////////////////////////////////////////////////////////

class srio_tl_pkt_tt_test extends srio_base_test;

  `uvm_component_utils(srio_tl_pkt_tt_test)

  srio_tl_pkt_tt_seq tl_pkt_tt_seq;

    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    tl_pkt_tt_seq = srio_tl_pkt_tt_seq::type_id::create("tl_pkt_tt_seq");

     phase.raise_objection( this );
     tl_pkt_tt_seq.start( env1.e_virtual_sequencer);
    #2000ns;
 
    phase.drop_objection(this);
    
  endtask

  
endclass


