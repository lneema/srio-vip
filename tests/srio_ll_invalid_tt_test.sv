////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_invalid_tt_test.sv
// Project :  srio vip
// Purpose :  Base test
// Author  :  Mobiveil
//
// Invalid tt for NREAD REQUEST.
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_invalid_tt_test extends srio_base_test;

  `uvm_component_utils(srio_ll_invalid_tt_test)

   srio_ll_pkt_invalid_tt_seq ll_pkt_invalid_tt_seq;
  

  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

      
  task run_phase( uvm_phase phase );
    super.run_phase(phase);
    
     ll_pkt_invalid_tt_seq = srio_ll_pkt_invalid_tt_seq::type_id::create("ll_pkt_invalid_tt_seq");
     phase.raise_objection( this );
     ll_pkt_invalid_tt_seq.start( env1.e_virtual_sequencer);
    #20000ns;
    phase.drop_objection(this);
    
  endtask

endclass
