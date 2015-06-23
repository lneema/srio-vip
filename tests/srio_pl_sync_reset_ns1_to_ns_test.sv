////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_sync_reset_ns1_to_ns_test .sv
// Project :  srio vip
// Purpose :  SYNC State Machine - Reset test for NS1 state
// Author  :  Mobiveil
//
// Apply reset after NO_SYNC_1 State
// Supports only Gen2 mode
////////////////////////////////////////////////////////////////////////////////

class srio_pl_sync_reset_ns1_to_ns_test extends srio_base_test;
  `uvm_component_utils(srio_pl_sync_reset_ns1_to_ns_test)
   srio_ll_nread_req_seq nread_req_seq;
 
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  task run_phase( uvm_phase phase );
    super.run_phase(phase);
    nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");
    phase.raise_objection( this );
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_sync_state == NO_SYNC_1);
         
      env1.pl_agent.pl_driver.srio_if.srio_rst_n = 1'b0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_sync_state == NO_SYNC);
       
       #500ns;
      env1.pl_agent.pl_driver.srio_if.srio_rst_n = 1'b1;
      nread_req_seq.start( env1.e_virtual_sequencer);
 
 phase.drop_objection(this);
    
  endtask
  
endclass


