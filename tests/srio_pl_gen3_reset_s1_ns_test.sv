////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_pl_gen3_reset_s1_ns_test .sv
// Project :  srio vip
// Purpose :   SYNC STATE MACHINE
// Author  :  Mobiveil
//
// 1.Register callbacks .
// 2.wait for sync and move to sync 1 and appply reset 
// 3. After state changes wait for sync.
// 4.After link initialized,send nread packets.
// Supported by only  Gen3 mode
//
////////////////////////////////////////////////////////////////////////////////

class srio_pl_gen3_reset_s1_ns_test extends srio_base_test;

  `uvm_component_utils(srio_pl_gen3_reset_s1_ns_test)
   rand int num;
 
  srio_ll_nread_req_seq nread_req_seq;
    
  function new(string name, uvm_component parent=null);
  super.new(name, parent);
  endfunction
          
      task run_phase( uvm_phase phase );
    super.run_phase(phase);
        num = $urandom_range(32'd2,32'd0); 
    // SYNC UI CLK THRESHOLD
      env1.pl_agent.pl_config.sync1_state_ui_cnt_threshold = 2500;
      nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");
 
      phase.raise_objection( this ); 
       
        // Link init 
   // Nread
      nread_req_seq.start( env1.e_virtual_sequencer);
    
      #2000ns;       
    // Set from sc lane silence 
      env1.pl_agent.pl_agent_rx_trans.from_sc_port_silence = 1;
      env1.pl_agent.pl_agent_bfm_trans.from_sc_port_silence = 1;
     #2000ns;
     
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_sync_state == SYNC_1);
           
     env1.pl_agent.pl_driver.srio_if.srio_rst_n = 0;
     
     #1000ns;
     env1.pl_agent.pl_driver.srio_if.srio_rst_n = 1;

   // Nread
      nread_req_seq.start( env1.e_virtual_sequencer);
    
      #2000ns;
    phase.drop_objection(this);
    
  endtask

endclass


