////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_pl_sync_signal_detect_s_ns_test .sv
// Project :  srio vip
// Purpose :  LANE ALIGN STATE MACHINE
// Author  :  Mobiveil
//
// // 1.wait for  SYNC  .
// 2. apply signal detect.
// 3. After state changes wait for SYNC.
// 4.After link initialized,send nread packets.
// Supported by only  Gen2 mode
////////////////////////////////////////////////////////////////////////////////

class srio_pl_sync_signal_detect_s_ns_test extends srio_base_test;

  `uvm_component_utils(srio_pl_sync_signal_detect_s_ns_test)
   rand int num;
   srio_ll_nread_req_seq nread_req_seq;
   
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
     endfunction
  
     task run_phase( uvm_phase phase );
    super.run_phase(phase);
      
    nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");

     phase.raise_objection( this );
      if(env_config1.num_of_lanes == 1 ) begin //{ 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_sync_state == SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.signal_detect[0] = 0;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[0] = 0;
    
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_sync_state == NO_SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.signal_detect[0] = 1;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[0] = 1;
       end //}
     else if(env_config1.num_of_lanes == 2 ) begin //{
      fork //{
      begin //{
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_sync_state == SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.signal_detect[0] = 0;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[0] = 0;
    
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_sync_state == NO_SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.signal_detect[0] = 1;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[0] = 1;
      end //}
      begin //{ 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_sync_state == SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.signal_detect[1] = 0;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[1] = 0;
    
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_sync_state == NO_SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.signal_detect[1] = 1;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[1] = 1;
      end //}
      join //}
     end //}
     else if(env_config1.num_of_lanes == 4 ) begin //{
     fork //{
      begin //{
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_sync_state == SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.signal_detect[0] = 0;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[0] = 0;
      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_sync_state == NO_SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.signal_detect[0] = 1;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[0] = 1;
      end //}
      begin //{ 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_sync_state == SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.signal_detect[1] = 0;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[1] = 0;
    
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_sync_state == NO_SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.signal_detect[1] = 1;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[1] = 1;
      end //}
      begin //{
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_sync_state == SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.signal_detect[2] = 0;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[2] = 0;
    
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_sync_state == NO_SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.signal_detect[2] = 1;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[2] = 1;
      end //}
      begin //{
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_sync_state == SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.signal_detect[3] = 0;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[3] = 0;
    
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_sync_state == NO_SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.signal_detect[3] = 1;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[3] = 1;
      end //}
     join //}
     end //}
    else if(env_config1.num_of_lanes == 8 ) begin //{
      fork //{
      begin //{
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_sync_state == SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.signal_detect[0] = 0;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[0] = 0;
    
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_sync_state == NO_SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.signal_detect[0] = 1;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[0] = 1;
      end //}
      begin //{ 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_sync_state == SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.signal_detect[1] = 0;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[1] = 0;
    
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_sync_state == NO_SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.signal_detect[1] = 1;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[1] = 1;
      end //}
      begin //{
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_sync_state == SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.signal_detect[2] = 0;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[2] = 0;
    
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_sync_state == NO_SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.signal_detect[2] = 1;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[2] = 1;
      end //}
      begin //{
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_sync_state == SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.signal_detect[3] = 0;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[3] = 0;
    
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_sync_state == NO_SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.signal_detect[3] = 1;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[3] = 1;
      end //}
      begin //{
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].current_sync_state == SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[4].ld_trans.signal_detect[4] = 0;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[4] = 0;
    
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].current_sync_state == NO_SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[4].ld_trans.signal_detect[4] = 1;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[4] = 1;
        end //}
      begin //{
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].current_sync_state == SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[5].ld_trans.signal_detect[5] = 0;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[5] = 0;
    
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].current_sync_state == NO_SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[5].ld_trans.signal_detect[5] = 1;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[5] = 1;
      end //}
      begin //{
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].current_sync_state == SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[6].ld_trans.signal_detect[6] = 0;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[6] = 0;
    
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].current_sync_state == NO_SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[6].ld_trans.signal_detect[6] = 1;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[6] = 1;
      end //}
      begin //{
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].current_sync_state == SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[7].ld_trans.signal_detect[7] = 0;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[7] = 0;
    
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].current_sync_state == NO_SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[7].ld_trans.signal_detect[7] = 1;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[7] = 1;
      end //}
      join //}
    end //}
    else begin //{
     fork //{
      begin //{
     wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_sync_state == SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.signal_detect[0] = 0;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[0] = 0;
    
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_sync_state == NO_SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.signal_detect[0] = 1;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[0] = 1;
       end //}
      begin //{ 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_sync_state == SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.signal_detect[1] = 0;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[1] = 0;
    
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_sync_state == NO_SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.signal_detect[1] = 1;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[1] = 1;
      end //}
      begin //{
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_sync_state == SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.signal_detect[2] = 0;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[2] = 0;
    
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_sync_state == NO_SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.signal_detect[2] = 1;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[2] = 1;
      end //}
      begin //{
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_sync_state == SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.signal_detect[3] = 0;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[3] = 0;
    
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_sync_state == NO_SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.signal_detect[3] = 1;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[3] = 1;
       end //}
      begin //{
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].current_sync_state == SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[4].ld_trans.signal_detect[4] = 0;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[4] = 0;
    
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].current_sync_state == NO_SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[4].ld_trans.signal_detect[4] = 1;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[4] = 1;
        end //}
      begin //{
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].current_sync_state == SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[5].ld_trans.signal_detect[5] = 0;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[5] = 0;
    
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].current_sync_state == NO_SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[5].ld_trans.signal_detect[5] = 1;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[5] = 1;
      end //}
      begin //{
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].current_sync_state == SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[6].ld_trans.signal_detect[6] = 0;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[6] = 0;
    
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].current_sync_state == NO_SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[6].ld_trans.signal_detect[6] = 1;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[6] = 1;
      end //}
      begin //{
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].current_sync_state == SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[7].ld_trans.signal_detect[7] = 0;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[7] = 0;
    
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].current_sync_state == NO_SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[7].ld_trans.signal_detect[7] = 1;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[7] = 1;
      end //}
      begin //{
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[8].current_sync_state == SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[8].ld_trans.signal_detect[8] = 0;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[8] = 0;
    
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[8].current_sync_state == NO_SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[8].ld_trans.signal_detect[8] = 1;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[8] = 1;
       end //}
      begin //{ 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[9].current_sync_state == SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[9].ld_trans.signal_detect[9] = 0;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[9] = 0;
    
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[9].current_sync_state == NO_SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[9].ld_trans.signal_detect[9] = 1;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[9] = 1;
      end //}
      begin //{
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[10].current_sync_state == SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[10].ld_trans.signal_detect[10] = 0;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[10] = 0;
    
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[10].current_sync_state == NO_SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[10].ld_trans.signal_detect[10] = 1;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[10] = 1;
      end //}
      begin //{
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[11].current_sync_state == SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[11].ld_trans.signal_detect[11] = 0;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[11] = 0;
    
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[11].current_sync_state == NO_SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[11].ld_trans.signal_detect[11] = 1;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[11] = 1;
      end //}
      begin //{
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[12].current_sync_state == SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[12].ld_trans.signal_detect[12] = 0;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[12] = 0;
    
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[12].current_sync_state == NO_SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[12].ld_trans.signal_detect[12] = 1;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[12] = 1;
        end //}
      begin //{
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[13].current_sync_state == SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[13].ld_trans.signal_detect[13] = 0;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[13] = 0;
    
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[13].current_sync_state == NO_SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[13].ld_trans.signal_detect[13] = 1;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[13] = 1;
      end //}
      begin //{
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[14].current_sync_state == SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[14].ld_trans.signal_detect[14] = 0;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[14] = 0;
    
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[14].current_sync_state == NO_SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[14].ld_trans.signal_detect[14] = 1;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[14] = 1;
      end //}
      begin //{
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[15].current_sync_state == SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[15].ld_trans.signal_detect[15] = 0;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[15] = 0;
    
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[15].current_sync_state == NO_SYNC);
      env1.pl_agent.pl_driver.lane_driver_ins[15].ld_trans.signal_detect[15] = 1;
      env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.signal_detect[15] = 1;
      end //}
      join //}
    end //}
      nread_req_seq.start(env1.e_virtual_sequencer);
      #2000ns;     
      phase.drop_objection(this);
    
  endtask

  
endclass



