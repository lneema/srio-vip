//
// File    : srio_pl_pkt_early_crc_error_test .sv
// Project :  srio vip
// Purpose :  ERROR
// Author  :  Mobiveil
//
// Test for ERROR for early crc .
// Supported by all mode (Gen1,Gen2,Gen3)
//
////////////////////////////////////////////////////////////////////////////////

class srio_pl_pkt_early_crc_error_test extends srio_base_test;

  `uvm_component_utils(srio_pl_pkt_early_crc_error_test)

  srio_pl_pkt_early_crc_error_seq pl_pkt_early_crc_error_seq;

    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    pl_pkt_early_crc_error_seq = srio_pl_pkt_early_crc_error_seq::type_id::create("pl_pkt_early_crc_error_seq");

     phase.raise_objection( this );
      pl_pkt_early_crc_error_seq.start( env1.e_virtual_sequencer);
      #2000ns;
 
    phase.drop_objection(this);
    
  endtask


endclass


