////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_pl_sop_padded_length_not8multiple_test.sv
// Project :  srio vip
// Purpose :  Base test
// Author  :  Mobiveil
//
// Test for start of packet with padded length by modifying value of stype1_msb cs.
// Supported by only  Gen3 mode
//
////////////////////////////////////////////////////////////////////////////////

class srio_pl_sop_padded_length_not8multiple_test extends srio_base_test;

  `uvm_component_utils(srio_pl_sop_padded_length_not8multiple_test)

   srio_ll_nread_req_seq nread_req_seq;

   //handle for callback
   srio_pl_brc3_stype1_msb_cb pl_brc3_stype1_msb_cb;

  function new(string name, uvm_component parent=null);
    super.new(name, parent);
    pl_brc3_stype1_msb_cb = new();
  endfunction
 
  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
    uvm_callbacks #(srio_pl_bfm, srio_pl_brc3_stype1_msb_cb)::add(env1.pl_agent.pl_driver, pl_brc3_stype1_msb_cb);
  endfunction

task run_phase( uvm_phase phase );
    super.run_phase(phase);
    
  nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");
  phase.raise_objection( this );
  nread_req_seq.start( env1.e_virtual_sequencer);
  #20000ns;
  phase.drop_objection(this);
    
  endtask


endclass


