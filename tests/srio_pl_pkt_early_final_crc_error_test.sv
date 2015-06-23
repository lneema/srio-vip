//////////////////////////////////////////////////////////////////////////////
// File    : srio_pl_pkt_early_final_crc_error_test .sv
// Project :  srio vip
// Purpose :  ERROR
// Author  :  Mobiveil
//
// Test for ERROR for early crc and final crc .
// Supported by only  Gen2 mode
//
////////////////////////////////////////////////////////////////////////////////

class srio_pl_pkt_early_final_crc_error_test extends srio_base_test;

  `uvm_component_utils(srio_pl_pkt_early_final_crc_error_test)

  srio_pl_pkt_final_crc_error_seq pl_pkt_final_crc_error_seq;
  srio_pl_final_crc_corrupt_callback  pl_final_crc_corrupt_callback;
    
  function new(string name, uvm_component parent=null);
   super.new(name, parent);
   pl_final_crc_corrupt_callback = new();
  endfunction
  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
    uvm_callbacks #(srio_pl_idle_gen,srio_pl_final_crc_corrupt_callback )::add(env1.pl_agent.pl_driver.idle_gen,pl_final_crc_corrupt_callback);
   endfunction
    task run_phase( uvm_phase phase );
      super.run_phase(phase);
      pl_pkt_final_crc_error_seq = srio_pl_pkt_final_crc_error_seq::type_id::create("pl_pkt_final_crc_error_seq");
      phase.raise_objection( this );
      pl_pkt_final_crc_error_seq.start(env1.e_virtual_sequencer);
      #2000ns;
      phase.drop_objection(this);
  endtask


endclass


