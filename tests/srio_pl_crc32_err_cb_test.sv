////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_pl_crc32_err_cb_test.sv
// Project :  srio vip
// Purpose :  Base test
// Author  :  Mobiveil
//
// Test to corrupt crc32 value using callback
// Supported by only  Gen3 mode
//
////////////////////////////////////////////////////////////////////////////////

class srio_pl_crc32_err_cb_test extends srio_base_test;

  `uvm_component_utils(srio_pl_crc32_err_cb_test)

   srio_ll_nread_req_seq nread_req_seq;

   //handle for callback
   srio_pl_tx_crc32_err_cb pl_tx_crc32_err_cb;

  function new(string name, uvm_component parent=null);
    super.new(name, parent);
    pl_tx_crc32_err_cb = new();
  endfunction
 
  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
    uvm_callbacks #(srio_pl_bfm, srio_pl_tx_crc32_err_cb)::add(env1.pl_agent.pl_driver, pl_tx_crc32_err_cb);
  endfunction

task run_phase( uvm_phase phase );
    super.run_phase(phase);
    
  nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");
  phase.raise_objection( this );
  nread_req_seq.start( env1.e_virtual_sequencer);
  #20000ns;
  nread_req_seq.start( env1.e_virtual_sequencer);
  #20000ns;
  phase.drop_objection(this);
    
  endtask


endclass


