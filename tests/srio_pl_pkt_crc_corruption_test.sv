//////////////////////////////////////////////////////////////////////////////
// File    : srio_pl_pkt_crc_corruption_test.sv
// Project :  srio vip
// Purpose :  ERROR
// Author  :  Mobiveil
//
// Test for ERROR for early crc and final crc .
//
////////////////////////////////////////////////////////////////////////////////

class srio_pl_pkt_crc_corruption_test extends srio_base_test;

  `uvm_component_utils(srio_pl_pkt_crc_corruption_test)

  srio_pl_pkt_crc_corrupt_callback  pl_pkt_crc_corrupt_callback;
  srio_ll_nwrite_wrsize_wdptr_req_seq nwrite_req_seq;  
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
   pl_pkt_crc_corrupt_callback = new();
  endfunction
  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
    uvm_callbacks #(srio_pl_idle_gen,srio_pl_pkt_crc_corrupt_callback )::add(env1.pl_agent.pl_driver.idle_gen,pl_pkt_crc_corrupt_callback);
   endfunction
    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    nwrite_req_seq = srio_ll_nwrite_wrsize_wdptr_req_seq::type_id::create("nwrite_req_seq");
     phase.raise_objection( this );
       nwrite_req_seq.start( env1.e_virtual_sequencer);
      #2000ns;
 
    phase.drop_objection(this);
    
  endtask


endclass


