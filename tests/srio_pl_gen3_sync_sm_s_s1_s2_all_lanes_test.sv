////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_pl_gen3_sync_sm_s_s1_s2_all_lanes_test .sv
// Project :  srio vip
// Purpose :   SYNC STATE MACHINE
// Author  :  Mobiveil
//
// 1.Register callbacks .
// 2.wait for sync and move to sync 1 and  sync2 
// 3. After state changes wait for sync.
// 4.After link initialized,send nread packets.
//Supported by only Gen3 mode
//
////////////////////////////////////////////////////////////////////////////////

class srio_pl_gen3_sync_sm_s_s1_s2_all_lanes_test extends srio_base_test;

  `uvm_component_utils(srio_pl_gen3_sync_sm_s_s1_s2_all_lanes_test)
   srio_ll_nread_req_seq nread_req_seq;
   rand int num; 
    
  function new(string name, uvm_component parent=null);
  super.new(name, parent);
  endfunction
  
          
      task run_phase( uvm_phase phase );
    super.run_phase(phase);
       
    // SYNC UI CLK THRESHOLD
      env1.pl_agent.pl_config.sync1_state_ui_cnt_threshold = 250;  
      //env2.pl_agent.pl_config.sync1_state_ui_cnt_threshold = 250;  
      nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");
 
      phase.raise_objection( this );
      num = $urandom_range(32'd2,32'd0);
     if(env_config1.num_of_lanes == 1) begin //{ 
      case(num)  //{
      32'd0 : wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[num].current_sync_state == SYNC);
      32'd1 : wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[num].current_sync_state == SYNC);
      32'd2 : wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[num].current_sync_state == SYNC);
      endcase //}
      end //} 
      else if(env_config1.num_of_lanes == 2) begin //{
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_sync_state == SYNC);
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_sync_state == SYNC);  
      end //}
      else if(env_config1.num_of_lanes == 4) begin //{
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

           // Set from sc lane silence 
      //env2.pl_agent.pl_agent_tx_trans.from_sc_port_silence = 1;
      env1.pl_agent.pl_agent_rx_trans.from_sc_port_silence = 1;
      env1.pl_agent.pl_agent_bfm_trans.from_sc_port_silence = 1;

        
    if(env_config1.num_of_lanes == 1) begin //{ 
      case(num)  //{
      32'd0 : wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[num].current_sync_state == SYNC_1);
      32'd1 : wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[num].current_sync_state == SYNC_1);
      32'd2 : wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[num].current_sync_state == SYNC_1);
      endcase //}
      end //} 
      else if(env_config1.num_of_lanes == 2) begin //{
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_sync_state == SYNC_1);
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_sync_state == SYNC_1);  
      end //}
      else if(env_config1.num_of_lanes == 4) begin //{
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_sync_state == SYNC_1);
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_sync_state == SYNC_1);
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_sync_state == SYNC_1);  
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_sync_state == SYNC_1);  
      end //}
      else if(env_config1.num_of_lanes == 8) begin //{
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_sync_state == SYNC_1);
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_sync_state == SYNC_1);
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_sync_state == SYNC_1);  
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_sync_state == SYNC_1);  
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].current_sync_state == SYNC_1);
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].current_sync_state == SYNC_1);
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].current_sync_state == SYNC_1);  
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].current_sync_state == SYNC_1);  
      end //}
      else  begin //{
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_sync_state == SYNC_1);
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_sync_state == SYNC_1);
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_sync_state == SYNC_1);  
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_sync_state == SYNC_1);  
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].current_sync_state == SYNC_1);
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].current_sync_state == SYNC_1);
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].current_sync_state == SYNC_1);  
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].current_sync_state == SYNC_1);   
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[8].current_sync_state == SYNC_1);
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[9].current_sync_state == SYNC_1);
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[10].current_sync_state == SYNC_1);  
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[11].current_sync_state == SYNC_1);  
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[12].current_sync_state == SYNC_1);
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[13].current_sync_state == SYNC_1);
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[14].current_sync_state == SYNC_1);  
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[15].current_sync_state == SYNC_1);  
      end //}

    // Reset from sc lane silence
     // env2.pl_agent.pl_agent_tx_trans.from_sc_port_silence = 0;
      env1.pl_agent.pl_agent_rx_trans.from_sc_port_silence = 0;
      env1.pl_agent.pl_agent_bfm_trans.from_sc_port_silence = 0;
    
   // Nread
      nread_req_seq.start( env1.e_virtual_sequencer);
    
      #20000ns;
 
    phase.drop_objection(this);
    
  endtask

  
endclass


