////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_resp_pri_error_test .sv
// Project :  srio vip
// Purpose :  ERROR
// Author  :  Mobiveil
//
// Test for ERROR for response priority .
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_resp_pri_error_test extends srio_base_test;

  `uvm_component_utils(srio_ll_resp_pri_error_test)

  srio_ll_resp_pri_error_seq resp_pri_error_seq;
  srio_ll_rx_resp_pri_cb  ll_rx_resp_pri_cb;
    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  ll_rx_resp_pri_cb = new ();
  endfunction

 function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
    
    uvm_callbacks #(srio_packet_handler, srio_ll_rx_resp_pri_cb)::add(env1.ll_agent.ll_bfm.packet_handler,ll_rx_resp_pri_cb );

  endfunction
    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    resp_pri_error_seq = srio_ll_resp_pri_error_seq::type_id::create("resp_pri_error_seq");

     phase.raise_objection( this );
     resp_pri_error_seq.start( env2.e_virtual_sequencer);
    #20000ns;
 
    phase.drop_objection(this);
    
  endtask


endclass


