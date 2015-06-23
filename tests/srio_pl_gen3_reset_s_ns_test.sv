////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_pl_gen3_reset_s_ns_test .sv
// Project :  srio vip
// Purpose :  LANE ALIGN STATE MACHINE
// Author  :  Mobiveil
//
// // 1.wait for  SYNC  .
// 2. apply reset.after that deassarted reset.
// 3. After state changes wait for SYNC.
// 4.After link initialized,send nread packets.
// Supported by only  Gen3 mode
////////////////////////////////////////////////////////////////////////////////

class srio_pl_gen3_reset_s_ns_test extends srio_base_test;

  `uvm_component_utils(srio_pl_gen3_reset_s_ns_test)
   rand int num;
   srio_ll_nread_req_seq nread_req_seq;
   
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
     endfunction
  
     task run_phase( uvm_phase phase );
    super.run_phase(phase);
      
    nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");

     phase.raise_objection( this );
      if(env_config1.num_of_lanes == 1) begin //{ 
       wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_sync_state == SYNC);
      end //} 
      else if(env_config1.num_of_lanes == 2) begin //{
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_sync_state == SYNC);
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_sync_state == SYNC);  
      end //}
      else if(env_config1.num_of_lanes == 4) begin //{
      $display($time,"wait for no_sync_1");
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_sync_state == SYNC);
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_sync_state == SYNC);
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_sync_state == SYNC);  
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_sync_state == SYNC);
        
      end //}
      else if(env_config1.num_of_lanes == 8) begin //{
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_sync_state == SYNC);
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_sync_state == SYNC);
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_sync_state == SYNC);  
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_sync_state == SYNC);  
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].current_sync_state == SYNC);
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].current_sync_state == SYNC);
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].current_sync_state == SYNC);  
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].current_sync_state == SYNC);  
      end //}
      else  begin //{
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_sync_state == SYNC);
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_sync_state == SYNC);
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_sync_state == SYNC);  
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_sync_state == SYNC);  
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].current_sync_state == SYNC);
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].current_sync_state == SYNC);
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].current_sync_state == SYNC);  
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].current_sync_state == SYNC);   
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[8].current_sync_state == SYNC);
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[9].current_sync_state == SYNC);
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[10].current_sync_state == SYNC);  
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[11].current_sync_state == SYNC);  
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[12].current_sync_state == SYNC);
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[13].current_sync_state == SYNC);
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[14].current_sync_state == SYNC);  
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[15].current_sync_state == SYNC);  
      end //}

      env1.pl_agent.pl_driver.srio_if.srio_rst_n = 0;
      #1000ns;
      env1.pl_agent.pl_driver.srio_if.srio_rst_n = 1;
      nread_req_seq.start(env1.e_virtual_sequencer);
      #2000ns;     
      phase.drop_objection(this);
    
  endtask

  
endclass


