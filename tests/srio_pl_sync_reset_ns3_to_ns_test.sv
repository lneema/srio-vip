////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_sync_reset_ns3_to_ns_test .sv
// Project :  srio vip
// Purpose :  SYNC State Machine - reset test for No Sync 3 state
// Author  :  Mobiveil
// 
// Apply reset after Sync 3 state
// Supports only Gen2 mode
////////////////////////////////////////////////////////////////////////////////

class srio_pl_sync_reset_ns3_to_ns_test extends srio_base_test;
  `uvm_component_utils(srio_pl_sync_reset_ns3_to_ns_test)
   srio_ll_nread_req_seq nread_req_seq;
 
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

  task run_phase( uvm_phase phase );
    super.run_phase(phase);
    nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");
    phase.raise_objection( this );
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_sync_state == NO_SYNC_3);

      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_sync_state == NO_SYNC_3);

      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_sync_state == NO_SYNC_3);

      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_sync_state == NO_SYNC_3);

      env1.pl_agent.pl_driver.srio_if.srio_rst_n = 0;
  
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_sync_state == NO_SYNC);

      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_sync_state == NO_SYNC);

      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_sync_state == NO_SYNC);

      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_sync_state == NO_SYNC);

 
      env1.pl_agent.pl_driver.srio_if.srio_rst_n = 1;
  
      nread_req_seq.start( env1.e_virtual_sequencer);
 
 phase.drop_objection(this);
    
  endtask
  
endclass



