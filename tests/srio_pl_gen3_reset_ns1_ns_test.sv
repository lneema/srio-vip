////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_pl_gen3_reset_ns1_ns_test .sv
// Project :  srio vip
// Purpose :  LANE ALIGN STATE MACHINE
// Author  :  Mobiveil
//
// // 1.wait for NO_SYNC_1 .
// 2. apply reset.after that deassarted reset.
// 3. After state changes wait for NO_SYNC_1.
// 4.After link initialized,send nread packets.
// Supported by only  Gen3 mode
////////////////////////////////////////////////////////////////////////////////

class srio_pl_gen3_reset_ns1_ns_test extends srio_base_test;

  `uvm_component_utils(srio_pl_gen3_reset_ns1_ns_test)
   rand int num; 
   srio_ll_nread_req_seq nread_req_seq;
   
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
     endfunction
  
     task run_phase( uvm_phase phase );
    super.run_phase(phase);
      
    nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");

     phase.raise_objection( this );
      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_sync_state == NO_SYNC_1);
      env1.pl_agent.pl_driver.srio_if.srio_rst_n = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_sync_state == NO_SYNC);
      env1.pl_agent.pl_driver.srio_if.srio_rst_n = 1;

      nread_req_seq.start(env1.e_virtual_sequencer);
      #2000ns;     
      phase.drop_objection(this);

  endtask

  
endclass


