////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_pl_callback_test.sv
// Project :  srio vip
// Purpose :  Base test
// Author  :  Mobiveil
//
// Base test for all tests.
//
////////////////////////////////////////////////////////////////////////////////

class srio_pl_callback_test extends srio_base_test;

  `uvm_component_utils(srio_pl_callback_test)

   srio_ll_nread_req_seq nread_req_seq;

    
  
   srio_pl_tx_cb pl_tx_cb_ins;
  //srio_pl_rx_cb pl_rx_cb_ins;

  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  pl_tx_cb_ins = new();
    //pl_rx_cb_ins = new();

  endfunction

    
    
 
  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
    
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_tx_cb)::add(env1.pl_agent.pl_driver.lane_driver_ins[2], pl_tx_cb_ins);
    //uvm_callbacks #(srio_pl_lane_handler, srio_pl_rx_cb)::add(env1.pl_agent.pl_driver.lane_handle_ins[2], pl_rx_cb_ins);

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


