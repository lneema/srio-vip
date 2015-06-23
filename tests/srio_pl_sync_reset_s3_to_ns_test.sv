////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_sync_reset_s3_to_ns_test .sv
// Project :  srio vip
// Purpose :  SYNC State Machine - Reset test for sync3 state
// Author  :  Mobiveil
//
// Apply reset after SYNC3 State
// Supported by only  Gen2 mode
//
////////////////////////////////////////////////////////////////////////////////

class srio_pl_sync_reset_s3_to_ns_test extends srio_base_test;
  `uvm_component_utils(srio_pl_sync_reset_s3_to_ns_test)
   srio_ll_nread_req_seq nread_req_seq;
 srio_pl_sync_reset_sm_callback sync_reset_sm_ins ;

  function new(string name, uvm_component parent=null);
    super.new(name, parent);
    sync_reset_sm_ins = new();
  endfunction
 
  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
       sync_reset_sm_ins.pl_agent_cb = env1.pl_agent;
       uvm_callbacks #(srio_pl_lane_driver, srio_pl_sync_reset_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[0], sync_reset_sm_ins);
       uvm_callbacks #(srio_pl_lane_driver, srio_pl_sync_reset_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[1], sync_reset_sm_ins);
       uvm_callbacks #(srio_pl_lane_driver, srio_pl_sync_reset_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[2], sync_reset_sm_ins);
       uvm_callbacks #(srio_pl_lane_driver, srio_pl_sync_reset_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[3], sync_reset_sm_ins);
       uvm_callbacks #(srio_pl_lane_driver, srio_pl_sync_reset_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[4], sync_reset_sm_ins);
       uvm_callbacks #(srio_pl_lane_driver, srio_pl_sync_reset_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[5], sync_reset_sm_ins);
       uvm_callbacks #(srio_pl_lane_driver, srio_pl_sync_reset_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[6], sync_reset_sm_ins);
       uvm_callbacks #(srio_pl_lane_driver, srio_pl_sync_reset_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[7], sync_reset_sm_ins);
       uvm_callbacks #(srio_pl_lane_driver, srio_pl_sync_reset_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[8], sync_reset_sm_ins);
       uvm_callbacks #(srio_pl_lane_driver, srio_pl_sync_reset_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[9], sync_reset_sm_ins);
       uvm_callbacks #(srio_pl_lane_driver, srio_pl_sync_reset_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[10], sync_reset_sm_ins);
       uvm_callbacks #(srio_pl_lane_driver, srio_pl_sync_reset_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[11], sync_reset_sm_ins);
       uvm_callbacks #(srio_pl_lane_driver, srio_pl_sync_reset_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[12], sync_reset_sm_ins);
       uvm_callbacks #(srio_pl_lane_driver, srio_pl_sync_reset_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[13], sync_reset_sm_ins);
       uvm_callbacks #(srio_pl_lane_driver, srio_pl_sync_reset_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[14], sync_reset_sm_ins);
       uvm_callbacks #(srio_pl_lane_driver, srio_pl_sync_reset_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[15], sync_reset_sm_ins);
  endfunction
 
  task run_phase( uvm_phase phase );
    super.run_phase(phase);
    nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");
    phase.raise_objection( this );

      wait(env1.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].current_sync_state == SYNC_3);
     
      env1.pl_agent.pl_driver.srio_if.srio_rst_n = 1'b0;
       
      wait(env1.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].current_sync_state == NO_SYNC);
     
      env1.pl_agent.pl_driver.srio_if.srio_rst_n = 1'b1;
      nread_req_seq.start( env1.e_virtual_sequencer);
 #20000ns;
 phase.drop_objection(this);
    
  endtask
  
endclass



