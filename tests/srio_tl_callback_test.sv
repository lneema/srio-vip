////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_tl_callback_test.sv
// Project :  srio vip
// Purpose :  Base test
// Author  :  Mobiveil
//
// Base test for all tests.
//
////////////////////////////////////////////////////////////////////////////////

class srio_tl_callback_test extends srio_base_test;

  `uvm_component_utils(srio_tl_callback_test)

   srio_ll_nread_req_seq nread_req_seq;
  
  srio_tl_tx_cb tl_tx_cb_ins;
  srio_tl_rx_cb tl_rx_cb_ins;

  function new(string name, uvm_component parent=null);
    super.new(name, parent);
    tl_tx_cb_ins = new();
    tl_rx_cb_ins = new();
  endfunction

 
 // endfunction

  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);

    
    uvm_callbacks #(srio_tl_generator,srio_tl_tx_cb)::add(env1.tl_agent.tl_bfm.tl_generator, tl_tx_cb_ins);
    uvm_callbacks #(srio_tl_receiver,srio_tl_rx_cb)::add(env1.tl_agent.tl_bfm.tl_receiver, tl_rx_cb_ins);

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


