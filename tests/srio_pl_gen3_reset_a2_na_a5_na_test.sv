
////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_pl_gen3_reset_a2_na_a5_na_test .sv
// Project :  srio vip
// Purpose :  LANE ALIGN STATE MACHINE
// Author  :  Mobiveil
//
// // 1.wait for aligned 2.
// 2. apply reset.after that deassarted reset.
// 3. After state changes wait for aligned .
// 4. wait for aligned 5 and apply reset .
// 4.After link initialized,send nread packets.

////////////////////////////////////////////////////////////////////////////////

class srio_pl_gen3_reset_a2_na_a5_na_test extends srio_base_test;

  `uvm_component_utils(srio_pl_gen3_reset_a2_na_a5_na_test)

   srio_ll_nread_req_seq nread_req_seq;
   srio_pl_gen3_a_a2_a3_a4_sm_callback pl_gen3_a_a2_a3_a4_sm_callback_ins; 
    function new(string name, uvm_component parent=null);
    super.new(name, parent);
    pl_gen3_a_a2_a3_a4_sm_callback_ins = new();

    endfunction
    function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);          
      pl_gen3_a_a2_a3_a4_sm_callback_ins.pl_agent_cb = env1.pl_agent;
      uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_a_a2_a3_a4_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[0], pl_gen3_a_a2_a3_a4_sm_callback_ins);
    endfunction

     task run_phase( uvm_phase phase );
    super.run_phase(phase);
      
    nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");

     phase.raise_objection( this );
        
      wait(env1.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_nx_align_state == ALIGNED);
      wait(env2.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_nx_align_state == ALIGNED); 
        
      wait(env1.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_nx_align_state == ALIGNED_2);
      wait(env2.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_nx_align_state == ALIGNED_2); 
      env1.pl_agent.pl_driver.srio_if.srio_rst_n = 0;
      env2.pl_agent.pl_driver.srio_if.srio_rst_n = 0;
      #1000ns;
      env1.pl_agent.pl_driver.srio_if.srio_rst_n = 1;
      env2.pl_agent.pl_driver.srio_if.srio_rst_n = 1;
       
      wait(env1.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_nx_align_state == ALIGNED);
      wait(env2.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_nx_align_state == ALIGNED);
      nread_req_seq.start(env1.e_virtual_sequencer);
      #2000ns;     
      
     
    phase.drop_objection(this);
    
  endtask

  
endclass


