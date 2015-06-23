////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_callback_test.sv
// Project :  srio vip
// Purpose :  Base test
// Author  :  Mobiveil
//
// Base test for all tests.
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_callback_test extends srio_base_test;

  `uvm_component_utils(srio_ll_callback_test)

   srio_ll_nread_req_seq nread_req_seq;

    
  
   srio_ll_tx_cb ll_tx_cb_ins;
  srio_ll_rx_cb ll_rx_cb_ins;

  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  ll_tx_cb_ins = new();
    ll_rx_cb_ins = new();

  endfunction

    
    
 
  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
    
    uvm_callbacks #(srio_logical_transaction_generator, srio_ll_tx_cb)::add(env1.ll_agent.ll_bfm.logical_transaction_generator, ll_tx_cb_ins);
    uvm_callbacks #(srio_packet_handler, srio_ll_rx_cb)::add(env1.ll_agent.ll_bfm.packet_handler, ll_rx_cb_ins);

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


