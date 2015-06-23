

////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. Apl rights reserved
//
// File    :  srio_pl_cw_train1_untrned_test.sv
// Project :  srio vip
// Purpose :  CW training.
// Author  :  Mobiveil
//
// 1.Set short run.
// 2. set the low value to timer for getting untrained state.
// 3.Set increment and decrement command with Tap value random.
//Supported by only Gen3 mode
////////////////////////////////////////////////////////////////////////////////

class srio_pl_cw_train1_untrned_test extends srio_base_test;

  `uvm_component_utils(srio_pl_cw_train1_untrned_test)
   
    srio_ll_nread_req_seq ll_nread_req_seq;
    
  function new(string name, uvm_component parent=null);

    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);

	env1.pl_agent.pl_config.brc3_training_mode = 1'b0;
	env2.pl_agent.pl_config.brc3_training_mode = 1'b0;
 
    //Command from ENV1
	env1.pl_agent.pl_config.cw_cmd_kind = CW_CMD_ENABLED;
	env1.pl_agent.pl_config.cw_cmd_type = CW_INCR;
        env1.pl_agent.pl_config.cw_tap_type = CW_CMD_TRANDOM;
    if(env_config1.num_of_lanes == 1)
   begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_cw_train_state == CW_TRAINING_1)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].current_cw_train_state == CW_TRAINING_1)
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.drvr_oe[0] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.drvr_oe[0] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.drvr_oe[0] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_cw_train_state == UNTRAINED)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].current_cw_train_state == UNTRAINED)
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.drvr_oe[0] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.drvr_oe[0] = 1; 
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.drvr_oe[0] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_cw_train_state == CW_TRAINING_0)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].current_cw_train_state == CW_TRAINING_0)
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.train_timer_done[0] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.train_timer_done[0] = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.train_timer_done[0] = 1;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_cw_train_state == CW_TRAINING_FAIL)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].current_cw_train_state == CW_TRAINING_FAIL)
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.train_timer_done[0] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.train_timer_done[0] = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.train_timer_done[0] = 0;      
    end

        else if(env_config1.num_of_lanes == 2)
 begin
  fork 
begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_cw_train_state == CW_TRAINING_1)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].current_cw_train_state == CW_TRAINING_1)
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.drvr_oe[0] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.drvr_oe[0] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.drvr_oe[0] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_cw_train_state == UNTRAINED)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].current_cw_train_state == UNTRAINED)
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.drvr_oe[0] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.drvr_oe[0] = 1; 
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.drvr_oe[0] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_cw_train_state == CW_TRAINING_0)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].current_cw_train_state == CW_TRAINING_0)
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.train_timer_done[0] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.train_timer_done[0] = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.train_timer_done[0] = 1;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_cw_train_state == CW_TRAINING_FAIL)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].current_cw_train_state == CW_TRAINING_FAIL)
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.train_timer_done[0] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.train_timer_done[0] = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.train_timer_done[0] = 0;      
    end
begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_cw_train_state == CW_TRAINING_1)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].current_cw_train_state == CW_TRAINING_1)
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.drvr_oe[1] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.drvr_oe[1] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].lh_trans.drvr_oe[1] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_cw_train_state == UNTRAINED)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].current_cw_train_state == UNTRAINED)
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.drvr_oe[1] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.drvr_oe[1] = 1; 
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].lh_trans.drvr_oe[1] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_cw_train_state == CW_TRAINING_0)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].current_cw_train_state == CW_TRAINING_0)
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.train_timer_done[1] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.train_timer_done[1] = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].lh_trans.train_timer_done[1] = 1;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_cw_train_state == CW_TRAINING_FAIL)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].current_cw_train_state == CW_TRAINING_FAIL)
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.train_timer_done[1] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.train_timer_done[1] = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].lh_trans.train_timer_done[1] = 0;      
    end

    join_none
 end
else if(env_config1.num_of_lanes == 4)
 begin
  fork 
    begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_cw_train_state == CW_TRAINING_1)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].current_cw_train_state == CW_TRAINING_1)
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.drvr_oe[0] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.drvr_oe[0] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.drvr_oe[0] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_cw_train_state == UNTRAINED)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].current_cw_train_state == UNTRAINED)
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.drvr_oe[0] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.drvr_oe[0] = 1; 
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.drvr_oe[0] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_cw_train_state == CW_TRAINING_0)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].current_cw_train_state == CW_TRAINING_0)
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.train_timer_done[0] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.train_timer_done[0] = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.train_timer_done[0] = 1;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_cw_train_state == CW_TRAINING_FAIL)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].current_cw_train_state == CW_TRAINING_FAIL)
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.train_timer_done[0] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.train_timer_done[0] = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.train_timer_done[0] = 0;      
    end
begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_cw_train_state == CW_TRAINING_1)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].current_cw_train_state == CW_TRAINING_1)
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.drvr_oe[1] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.drvr_oe[1] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].lh_trans.drvr_oe[1] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_cw_train_state == UNTRAINED)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].current_cw_train_state == UNTRAINED)
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.drvr_oe[1] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.drvr_oe[1] = 1; 
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].lh_trans.drvr_oe[1] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_cw_train_state == CW_TRAINING_0)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].current_cw_train_state == CW_TRAINING_0)
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.train_timer_done[1] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.train_timer_done[1] = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].lh_trans.train_timer_done[1] = 1;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_cw_train_state == CW_TRAINING_FAIL)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].current_cw_train_state == CW_TRAINING_FAIL)
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.train_timer_done[1] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.train_timer_done[1] = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].lh_trans.train_timer_done[1] = 0;      
    end
begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_cw_train_state == CW_TRAINING_1)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].current_cw_train_state == CW_TRAINING_1)
        env1.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.drvr_oe[2] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].lh_trans.drvr_oe[2] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].lh_trans.drvr_oe[2] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_cw_train_state == UNTRAINED)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].current_cw_train_state == UNTRAINED)
        env1.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.drvr_oe[2] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].lh_trans.drvr_oe[2] = 1; 
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].lh_trans.drvr_oe[2] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_cw_train_state == CW_TRAINING_0)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].current_cw_train_state == CW_TRAINING_0)
        env1.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.train_timer_done[2] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].lh_trans.train_timer_done[2] = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].lh_trans.train_timer_done[2] = 1;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_cw_train_state == CW_TRAINING_FAIL)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].current_cw_train_state == CW_TRAINING_FAIL)
        env1.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.train_timer_done[2] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].lh_trans.train_timer_done[2] = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].lh_trans.train_timer_done[2] = 0;      
    end
begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_cw_train_state == CW_TRAINING_1)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].current_cw_train_state == CW_TRAINING_1)
        env1.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.drvr_oe[3] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].lh_trans.drvr_oe[3] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].lh_trans.drvr_oe[3] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_cw_train_state == UNTRAINED)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].current_cw_train_state == UNTRAINED)
        env1.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.drvr_oe[3] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].lh_trans.drvr_oe[3] = 1; 
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].lh_trans.drvr_oe[3] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_cw_train_state == CW_TRAINING_0)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].current_cw_train_state == CW_TRAINING_0)
        env1.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.train_timer_done[3] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].lh_trans.train_timer_done[3] = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].lh_trans.train_timer_done[3] = 1;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_cw_train_state == CW_TRAINING_FAIL)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].current_cw_train_state == CW_TRAINING_FAIL)
        env1.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.train_timer_done[3] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].lh_trans.train_timer_done[3] = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].lh_trans.train_timer_done[3] = 0;      
    end

    join_none
end
else if(env_config1.num_of_lanes == 8)
 begin
  fork 
  begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_cw_train_state == CW_TRAINING_1)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].current_cw_train_state == CW_TRAINING_1)
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.drvr_oe[0] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.drvr_oe[0] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.drvr_oe[0] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_cw_train_state == UNTRAINED)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].current_cw_train_state == UNTRAINED)
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.drvr_oe[0] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.drvr_oe[0] = 1; 
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.drvr_oe[0] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_cw_train_state == CW_TRAINING_0)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].current_cw_train_state == CW_TRAINING_0)
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.train_timer_done[0] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.train_timer_done[0] = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.train_timer_done[0] = 1;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_cw_train_state == CW_TRAINING_FAIL)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].current_cw_train_state == CW_TRAINING_FAIL)
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.train_timer_done[0] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.train_timer_done[0] = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.train_timer_done[0] = 0;      
    end
begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_cw_train_state == CW_TRAINING_1)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].current_cw_train_state == CW_TRAINING_1)
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.drvr_oe[1] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.drvr_oe[1] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].lh_trans.drvr_oe[1] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_cw_train_state == UNTRAINED)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].current_cw_train_state == UNTRAINED)
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.drvr_oe[1] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.drvr_oe[1] = 1; 
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].lh_trans.drvr_oe[1] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_cw_train_state == CW_TRAINING_0)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].current_cw_train_state == CW_TRAINING_0)
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.train_timer_done[1] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.train_timer_done[1] = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].lh_trans.train_timer_done[1] = 1;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_cw_train_state == CW_TRAINING_FAIL)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].current_cw_train_state == CW_TRAINING_FAIL)
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.train_timer_done[1] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.train_timer_done[1] = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].lh_trans.train_timer_done[1] = 0;      
    end
begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_cw_train_state == CW_TRAINING_1)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].current_cw_train_state == CW_TRAINING_1)
        env1.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.drvr_oe[2] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].lh_trans.drvr_oe[2] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].lh_trans.drvr_oe[2] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_cw_train_state == UNTRAINED)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].current_cw_train_state == UNTRAINED)
        env1.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.drvr_oe[2] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].lh_trans.drvr_oe[2] = 1; 
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].lh_trans.drvr_oe[2] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_cw_train_state == CW_TRAINING_0)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].current_cw_train_state == CW_TRAINING_0)
        env1.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.train_timer_done[2] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].lh_trans.train_timer_done[2] = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].lh_trans.train_timer_done[2] = 1;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_cw_train_state == CW_TRAINING_FAIL)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].current_cw_train_state == CW_TRAINING_FAIL)
        env1.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.train_timer_done[2] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].lh_trans.train_timer_done[2] = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].lh_trans.train_timer_done[2] = 0;      
    end
begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_cw_train_state == CW_TRAINING_1)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].current_cw_train_state == CW_TRAINING_1)
        env1.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.drvr_oe[3] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].lh_trans.drvr_oe[3] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].lh_trans.drvr_oe[3] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_cw_train_state == UNTRAINED)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].current_cw_train_state == UNTRAINED)
        env1.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.drvr_oe[3] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].lh_trans.drvr_oe[3] = 1; 
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].lh_trans.drvr_oe[3] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_cw_train_state == CW_TRAINING_0)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].current_cw_train_state == CW_TRAINING_0)
        env1.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.train_timer_done[3] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].lh_trans.train_timer_done[3] = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].lh_trans.train_timer_done[3] = 1;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_cw_train_state == CW_TRAINING_FAIL)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].current_cw_train_state == CW_TRAINING_FAIL)
        env1.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.train_timer_done[3] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].lh_trans.train_timer_done[3] = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].lh_trans.train_timer_done[3] = 0;      
    end
begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].current_cw_train_state == CW_TRAINING_1)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[4].current_cw_train_state == CW_TRAINING_1)
        env1.pl_agent.pl_driver.lane_driver_ins[4].ld_trans.drvr_oe[4] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].lh_trans.drvr_oe[4] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[4].lh_trans.drvr_oe[4] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].current_cw_train_state == UNTRAINED)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[4].current_cw_train_state == UNTRAINED)
        env1.pl_agent.pl_driver.lane_driver_ins[4].ld_trans.drvr_oe[4] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].lh_trans.drvr_oe[4] = 1; 
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[4].lh_trans.drvr_oe[4] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].current_cw_train_state == CW_TRAINING_0)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[4].current_cw_train_state == CW_TRAINING_0)
        env1.pl_agent.pl_driver.lane_driver_ins[4].ld_trans.train_timer_done[4] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].lh_trans.train_timer_done[4] = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[4].lh_trans.train_timer_done[4] = 1;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].current_cw_train_state == CW_TRAINING_FAIL)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[4].current_cw_train_state == CW_TRAINING_FAIL)
        env1.pl_agent.pl_driver.lane_driver_ins[4].ld_trans.train_timer_done[4] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].lh_trans.train_timer_done[4] = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[4].lh_trans.train_timer_done[4] = 0;      
    end
begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].current_cw_train_state == CW_TRAINING_1)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[5].current_cw_train_state == CW_TRAINING_1)
        env1.pl_agent.pl_driver.lane_driver_ins[5].ld_trans.drvr_oe[5] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].lh_trans.drvr_oe[5] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[5].lh_trans.drvr_oe[5] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].current_cw_train_state == UNTRAINED)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[5].current_cw_train_state == UNTRAINED)
        env1.pl_agent.pl_driver.lane_driver_ins[5].ld_trans.drvr_oe[5] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].lh_trans.drvr_oe[5] = 1; 
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[5].lh_trans.drvr_oe[5] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].current_cw_train_state == CW_TRAINING_0)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[5].current_cw_train_state == CW_TRAINING_0)
        env1.pl_agent.pl_driver.lane_driver_ins[5].ld_trans.train_timer_done[5] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].lh_trans.train_timer_done[5] = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[5].lh_trans.train_timer_done[5] = 1;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].current_cw_train_state == CW_TRAINING_FAIL)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[5].current_cw_train_state == CW_TRAINING_FAIL)
        env1.pl_agent.pl_driver.lane_driver_ins[5].ld_trans.train_timer_done[5] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].lh_trans.train_timer_done[5] = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[5].lh_trans.train_timer_done[5] = 0;      
    end
begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].current_cw_train_state == CW_TRAINING_1)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[6].current_cw_train_state == CW_TRAINING_1)
        env1.pl_agent.pl_driver.lane_driver_ins[6].ld_trans.drvr_oe[6] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].lh_trans.drvr_oe[6] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[6].lh_trans.drvr_oe[6] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].current_cw_train_state == UNTRAINED)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[6].current_cw_train_state == UNTRAINED)
        env1.pl_agent.pl_driver.lane_driver_ins[6].ld_trans.drvr_oe[6] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].lh_trans.drvr_oe[6] = 1; 
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[6].lh_trans.drvr_oe[6] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].current_cw_train_state == CW_TRAINING_0)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[6].current_cw_train_state == CW_TRAINING_0)
        env1.pl_agent.pl_driver.lane_driver_ins[6].ld_trans.train_timer_done[6] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].lh_trans.train_timer_done[6] = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[6].lh_trans.train_timer_done[6] = 1;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].current_cw_train_state == CW_TRAINING_FAIL)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[6].current_cw_train_state == CW_TRAINING_FAIL)
        env1.pl_agent.pl_driver.lane_driver_ins[6].ld_trans.train_timer_done[6] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].lh_trans.train_timer_done[6] = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[6].lh_trans.train_timer_done[6] = 0;      
    end
    begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].current_cw_train_state == CW_TRAINING_1)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[7].current_cw_train_state == CW_TRAINING_1)
        env1.pl_agent.pl_driver.lane_driver_ins[7].ld_trans.drvr_oe[7] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].lh_trans.drvr_oe[7] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[7].lh_trans.drvr_oe[7] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].current_cw_train_state == UNTRAINED)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[7].current_cw_train_state == UNTRAINED)
        env1.pl_agent.pl_driver.lane_driver_ins[7].ld_trans.drvr_oe[7] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].lh_trans.drvr_oe[7] = 1; 
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[7].lh_trans.drvr_oe[7] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].current_cw_train_state == CW_TRAINING_0)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[7].current_cw_train_state == CW_TRAINING_0)
        env1.pl_agent.pl_driver.lane_driver_ins[7].ld_trans.train_timer_done[7] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].lh_trans.train_timer_done[7] = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[7].lh_trans.train_timer_done[7] = 1;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].current_cw_train_state == CW_TRAINING_FAIL)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[7].current_cw_train_state == CW_TRAINING_FAIL)
        env1.pl_agent.pl_driver.lane_driver_ins[7].ld_trans.train_timer_done[7] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].lh_trans.train_timer_done[7] = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[7].lh_trans.train_timer_done[7] = 0;      
    end
   
  join_none 
 end

else if(env_config1.num_of_lanes == 16)
 begin
  fork 
begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_cw_train_state == CW_TRAINING_1)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].current_cw_train_state == CW_TRAINING_1)
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.drvr_oe[0] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.drvr_oe[0] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.drvr_oe[0] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_cw_train_state == UNTRAINED)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].current_cw_train_state == UNTRAINED)
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.drvr_oe[0] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.drvr_oe[0] = 1; 
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.drvr_oe[0] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_cw_train_state == CW_TRAINING_0)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].current_cw_train_state == CW_TRAINING_0)
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.train_timer_done[0] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.train_timer_done[0] = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.train_timer_done[0] = 1;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_cw_train_state == CW_TRAINING_FAIL)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].current_cw_train_state == CW_TRAINING_FAIL)
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.train_timer_done[0] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.train_timer_done[0] = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.train_timer_done[0] = 0;      
    end
begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_cw_train_state == CW_TRAINING_1)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].current_cw_train_state == CW_TRAINING_1)
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.drvr_oe[1] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.drvr_oe[1] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].lh_trans.drvr_oe[1] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_cw_train_state == UNTRAINED)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].current_cw_train_state == UNTRAINED)
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.drvr_oe[1] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.drvr_oe[1] = 1; 
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].lh_trans.drvr_oe[1] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_cw_train_state == CW_TRAINING_0)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].current_cw_train_state == CW_TRAINING_0)
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.train_timer_done[1] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.train_timer_done[1] = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].lh_trans.train_timer_done[1] = 1;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_cw_train_state == CW_TRAINING_FAIL)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].current_cw_train_state == CW_TRAINING_FAIL)
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.train_timer_done[1] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.train_timer_done[1] = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].lh_trans.train_timer_done[1] = 0;      
    end
begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_cw_train_state == CW_TRAINING_1)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].current_cw_train_state == CW_TRAINING_1)
        env1.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.drvr_oe[2] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].lh_trans.drvr_oe[2] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].lh_trans.drvr_oe[2] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_cw_train_state == UNTRAINED)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].current_cw_train_state == UNTRAINED)
        env1.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.drvr_oe[2] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].lh_trans.drvr_oe[2] = 1; 
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].lh_trans.drvr_oe[2] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_cw_train_state == CW_TRAINING_0)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].current_cw_train_state == CW_TRAINING_0)
        env1.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.train_timer_done[2] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].lh_trans.train_timer_done[2] = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].lh_trans.train_timer_done[2] = 1;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_cw_train_state == CW_TRAINING_FAIL)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].current_cw_train_state == CW_TRAINING_FAIL)
        env1.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.train_timer_done[2] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].lh_trans.train_timer_done[2] = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].lh_trans.train_timer_done[2] = 0;      
    end
begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_cw_train_state == CW_TRAINING_1)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].current_cw_train_state == CW_TRAINING_1)
        env1.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.drvr_oe[3] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].lh_trans.drvr_oe[3] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].lh_trans.drvr_oe[3] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_cw_train_state == UNTRAINED)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].current_cw_train_state == UNTRAINED)
        env1.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.drvr_oe[3] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].lh_trans.drvr_oe[3] = 1; 
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].lh_trans.drvr_oe[3] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_cw_train_state == CW_TRAINING_0)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].current_cw_train_state == CW_TRAINING_0)
        env1.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.train_timer_done[3] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].lh_trans.train_timer_done[3] = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].lh_trans.train_timer_done[3] = 1;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_cw_train_state == CW_TRAINING_FAIL)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].current_cw_train_state == CW_TRAINING_FAIL)
        env1.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.train_timer_done[3] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].lh_trans.train_timer_done[3] = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].lh_trans.train_timer_done[3] = 0;      
    end
begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].current_cw_train_state == CW_TRAINING_1)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[4].current_cw_train_state == CW_TRAINING_1)
        env1.pl_agent.pl_driver.lane_driver_ins[4].ld_trans.drvr_oe[4] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].lh_trans.drvr_oe[4] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[4].lh_trans.drvr_oe[4] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].current_cw_train_state == UNTRAINED)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[4].current_cw_train_state == UNTRAINED)
        env1.pl_agent.pl_driver.lane_driver_ins[4].ld_trans.drvr_oe[4] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].lh_trans.drvr_oe[4] = 1; 
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[4].lh_trans.drvr_oe[4] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].current_cw_train_state == CW_TRAINING_0)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[4].current_cw_train_state == CW_TRAINING_0)
        env1.pl_agent.pl_driver.lane_driver_ins[4].ld_trans.train_timer_done[4] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].lh_trans.train_timer_done[4] = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[4].lh_trans.train_timer_done[4] = 1;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].current_cw_train_state == CW_TRAINING_FAIL)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[4].current_cw_train_state == CW_TRAINING_FAIL)
        env1.pl_agent.pl_driver.lane_driver_ins[4].ld_trans.train_timer_done[4] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].lh_trans.train_timer_done[4] = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[4].lh_trans.train_timer_done[4] = 0;      
    end
begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].current_cw_train_state == CW_TRAINING_1)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[5].current_cw_train_state == CW_TRAINING_1)
        env1.pl_agent.pl_driver.lane_driver_ins[5].ld_trans.drvr_oe[5] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].lh_trans.drvr_oe[5] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[5].lh_trans.drvr_oe[5] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].current_cw_train_state == UNTRAINED)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[5].current_cw_train_state == UNTRAINED)
        env1.pl_agent.pl_driver.lane_driver_ins[5].ld_trans.drvr_oe[5] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].lh_trans.drvr_oe[5] = 1; 
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[5].lh_trans.drvr_oe[5] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].current_cw_train_state == CW_TRAINING_0)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[5].current_cw_train_state == CW_TRAINING_0)
        env1.pl_agent.pl_driver.lane_driver_ins[5].ld_trans.train_timer_done[5] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].lh_trans.train_timer_done[5] = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[5].lh_trans.train_timer_done[5] = 1;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].current_cw_train_state == CW_TRAINING_FAIL)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[5].current_cw_train_state == CW_TRAINING_FAIL)
        env1.pl_agent.pl_driver.lane_driver_ins[5].ld_trans.train_timer_done[5] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].lh_trans.train_timer_done[5] = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[5].lh_trans.train_timer_done[5] = 0;      
    end
begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].current_cw_train_state == CW_TRAINING_1)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[6].current_cw_train_state == CW_TRAINING_1)
        env1.pl_agent.pl_driver.lane_driver_ins[6].ld_trans.drvr_oe[6] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].lh_trans.drvr_oe[6] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[6].lh_trans.drvr_oe[6] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].current_cw_train_state == UNTRAINED)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[6].current_cw_train_state == UNTRAINED)
        env1.pl_agent.pl_driver.lane_driver_ins[6].ld_trans.drvr_oe[6] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].lh_trans.drvr_oe[6] = 1; 
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[6].lh_trans.drvr_oe[6] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].current_cw_train_state == CW_TRAINING_0)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[6].current_cw_train_state == CW_TRAINING_0)
        env1.pl_agent.pl_driver.lane_driver_ins[6].ld_trans.train_timer_done[6] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].lh_trans.train_timer_done[6] = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[6].lh_trans.train_timer_done[6] = 1;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].current_cw_train_state == CW_TRAINING_FAIL)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[6].current_cw_train_state == CW_TRAINING_FAIL)
        env1.pl_agent.pl_driver.lane_driver_ins[6].ld_trans.train_timer_done[6] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].lh_trans.train_timer_done[6] = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[6].lh_trans.train_timer_done[6] = 0;      
    end
    begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].current_cw_train_state == CW_TRAINING_1)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[7].current_cw_train_state == CW_TRAINING_1)
        env1.pl_agent.pl_driver.lane_driver_ins[7].ld_trans.drvr_oe[7] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].lh_trans.drvr_oe[7] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[7].lh_trans.drvr_oe[7] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].current_cw_train_state == UNTRAINED)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[7].current_cw_train_state == UNTRAINED)
        env1.pl_agent.pl_driver.lane_driver_ins[7].ld_trans.drvr_oe[7] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].lh_trans.drvr_oe[7] = 1; 
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[7].lh_trans.drvr_oe[7] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].current_cw_train_state == CW_TRAINING_0)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[7].current_cw_train_state == CW_TRAINING_0)
        env1.pl_agent.pl_driver.lane_driver_ins[7].ld_trans.train_timer_done[7] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].lh_trans.train_timer_done[7] = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[7].lh_trans.train_timer_done[7] = 1;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].current_cw_train_state == CW_TRAINING_FAIL)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[7].current_cw_train_state == CW_TRAINING_FAIL)
        env1.pl_agent.pl_driver.lane_driver_ins[7].ld_trans.train_timer_done[7] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].lh_trans.train_timer_done[7] = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[7].lh_trans.train_timer_done[7] = 0;      
    end
begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[8].current_cw_train_state == CW_TRAINING_1)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[8].current_cw_train_state == CW_TRAINING_1)
        env1.pl_agent.pl_driver.lane_driver_ins[8].ld_trans.drvr_oe[8] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[8].lh_trans.drvr_oe[8] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[8].lh_trans.drvr_oe[8] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[8].current_cw_train_state == UNTRAINED)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[8].current_cw_train_state == UNTRAINED)
        env1.pl_agent.pl_driver.lane_driver_ins[8].ld_trans.drvr_oe[8] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[8].lh_trans.drvr_oe[8] = 1; 
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[8].lh_trans.drvr_oe[8] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[8].current_cw_train_state == CW_TRAINING_0)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[8].current_cw_train_state == CW_TRAINING_0)
        env1.pl_agent.pl_driver.lane_driver_ins[8].ld_trans.train_timer_done[8] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[8].lh_trans.train_timer_done[8] = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[8].lh_trans.train_timer_done[8] = 1;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[8].current_cw_train_state == CW_TRAINING_FAIL)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[8].current_cw_train_state == CW_TRAINING_FAIL)
        env1.pl_agent.pl_driver.lane_driver_ins[8].ld_trans.train_timer_done[8] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[8].lh_trans.train_timer_done[8] = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[8].lh_trans.train_timer_done[8] = 0;      
    end
begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[9].current_cw_train_state == CW_TRAINING_1)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[9].current_cw_train_state == CW_TRAINING_1)
        env1.pl_agent.pl_driver.lane_driver_ins[9].ld_trans.drvr_oe[9] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[9].lh_trans.drvr_oe[9] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[9].lh_trans.drvr_oe[9] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[9].current_cw_train_state == UNTRAINED)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[9].current_cw_train_state == UNTRAINED)
        env1.pl_agent.pl_driver.lane_driver_ins[9].ld_trans.drvr_oe[9] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[9].lh_trans.drvr_oe[9] = 1; 
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[9].lh_trans.drvr_oe[9] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[9].current_cw_train_state == CW_TRAINING_0)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[9].current_cw_train_state == CW_TRAINING_0)
        env1.pl_agent.pl_driver.lane_driver_ins[9].ld_trans.train_timer_done[9] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[9].lh_trans.train_timer_done[9] = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[9].lh_trans.train_timer_done[9] = 1;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[9].current_cw_train_state == CW_TRAINING_FAIL)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[9].current_cw_train_state == CW_TRAINING_FAIL)
        env1.pl_agent.pl_driver.lane_driver_ins[9].ld_trans.train_timer_done[9] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[9].lh_trans.train_timer_done[9] = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[9].lh_trans.train_timer_done[9] = 0;      
    end
begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[10].current_cw_train_state == CW_TRAINING_1)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[10].current_cw_train_state == CW_TRAINING_1)
        env1.pl_agent.pl_driver.lane_driver_ins[10].ld_trans.drvr_oe[10] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[10].lh_trans.drvr_oe[10] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[10].lh_trans.drvr_oe[10] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[10].current_cw_train_state == UNTRAINED)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[10].current_cw_train_state == UNTRAINED)
        env1.pl_agent.pl_driver.lane_driver_ins[10].ld_trans.drvr_oe[10] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[10].lh_trans.drvr_oe[10] = 1; 
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[10].lh_trans.drvr_oe[10] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[10].current_cw_train_state == CW_TRAINING_0)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[10].current_cw_train_state == CW_TRAINING_0)
        env1.pl_agent.pl_driver.lane_driver_ins[10].ld_trans.train_timer_done[10] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[10].lh_trans.train_timer_done[10] = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[10].lh_trans.train_timer_done[10] = 1;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[10].current_cw_train_state == CW_TRAINING_FAIL)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[10].current_cw_train_state == CW_TRAINING_FAIL)
        env1.pl_agent.pl_driver.lane_driver_ins[10].ld_trans.train_timer_done[10] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[10].lh_trans.train_timer_done[10] = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[10].lh_trans.train_timer_done[10] = 0;      
    end
begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[11].current_cw_train_state == CW_TRAINING_1)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[11].current_cw_train_state == CW_TRAINING_1)
        env1.pl_agent.pl_driver.lane_driver_ins[11].ld_trans.drvr_oe[11] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[11].lh_trans.drvr_oe[11] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[11].lh_trans.drvr_oe[11] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[11].current_cw_train_state == UNTRAINED)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[11].current_cw_train_state == UNTRAINED)
        env1.pl_agent.pl_driver.lane_driver_ins[11].ld_trans.drvr_oe[11] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[11].lh_trans.drvr_oe[11] = 1; 
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[11].lh_trans.drvr_oe[11] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[11].current_cw_train_state == CW_TRAINING_0)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[11].current_cw_train_state == CW_TRAINING_0)
        env1.pl_agent.pl_driver.lane_driver_ins[11].ld_trans.train_timer_done[11] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[11].lh_trans.train_timer_done[11] = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[11].lh_trans.train_timer_done[11] = 1;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[11].current_cw_train_state == CW_TRAINING_FAIL)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[11].current_cw_train_state == CW_TRAINING_FAIL)
        env1.pl_agent.pl_driver.lane_driver_ins[11].ld_trans.train_timer_done[11] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[11].lh_trans.train_timer_done[11] = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[11].lh_trans.train_timer_done[11] = 0;      
    end

begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[12].current_cw_train_state == CW_TRAINING_1)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[12].current_cw_train_state == CW_TRAINING_1)
        env1.pl_agent.pl_driver.lane_driver_ins[12].ld_trans.drvr_oe[12] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[12].lh_trans.drvr_oe[12] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[12].lh_trans.drvr_oe[12] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[12].current_cw_train_state == UNTRAINED)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[12].current_cw_train_state == UNTRAINED)
        env1.pl_agent.pl_driver.lane_driver_ins[12].ld_trans.drvr_oe[12] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[12].lh_trans.drvr_oe[12] = 1; 
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[12].lh_trans.drvr_oe[12] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[12].current_cw_train_state == CW_TRAINING_0)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[12].current_cw_train_state == CW_TRAINING_0)
        env1.pl_agent.pl_driver.lane_driver_ins[12].ld_trans.train_timer_done[12] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[12].lh_trans.train_timer_done[12] = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[12].lh_trans.train_timer_done[12] = 1;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[12].current_cw_train_state == CW_TRAINING_FAIL)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[12].current_cw_train_state == CW_TRAINING_FAIL)
        env1.pl_agent.pl_driver.lane_driver_ins[12].ld_trans.train_timer_done[12] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[12].lh_trans.train_timer_done[12] = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[12].lh_trans.train_timer_done[12] = 0;      
    end
begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[13].current_cw_train_state == CW_TRAINING_1)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[13].current_cw_train_state == CW_TRAINING_1)
        env1.pl_agent.pl_driver.lane_driver_ins[13].ld_trans.drvr_oe[13] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[13].lh_trans.drvr_oe[13] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[13].lh_trans.drvr_oe[13] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[13].current_cw_train_state == UNTRAINED)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[13].current_cw_train_state == UNTRAINED)
        env1.pl_agent.pl_driver.lane_driver_ins[13].ld_trans.drvr_oe[13] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[13].lh_trans.drvr_oe[13] = 1; 
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[13].lh_trans.drvr_oe[13] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[13].current_cw_train_state == CW_TRAINING_0)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[13].current_cw_train_state == CW_TRAINING_0)
        env1.pl_agent.pl_driver.lane_driver_ins[13].ld_trans.train_timer_done[13] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[13].lh_trans.train_timer_done[13] = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[13].lh_trans.train_timer_done[13] = 1;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[13].current_cw_train_state == CW_TRAINING_FAIL)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[13].current_cw_train_state == CW_TRAINING_FAIL)
        env1.pl_agent.pl_driver.lane_driver_ins[13].ld_trans.train_timer_done[13] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[13].lh_trans.train_timer_done[13] = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[13].lh_trans.train_timer_done[13] = 0;      
    end
begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[14].current_cw_train_state == CW_TRAINING_1)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[14].current_cw_train_state == CW_TRAINING_1)
        env1.pl_agent.pl_driver.lane_driver_ins[14].ld_trans.drvr_oe[14] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[14].lh_trans.drvr_oe[14] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[14].lh_trans.drvr_oe[14] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[14].current_cw_train_state == UNTRAINED)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[14].current_cw_train_state == UNTRAINED)
        env1.pl_agent.pl_driver.lane_driver_ins[14].ld_trans.drvr_oe[14] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[14].lh_trans.drvr_oe[14] = 1; 
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[14].lh_trans.drvr_oe[14] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[14].current_cw_train_state == CW_TRAINING_0)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[14].current_cw_train_state == CW_TRAINING_0)
        env1.pl_agent.pl_driver.lane_driver_ins[14].ld_trans.train_timer_done[14] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[14].lh_trans.train_timer_done[14] = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[14].lh_trans.train_timer_done[14] = 1;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[14].current_cw_train_state == CW_TRAINING_FAIL)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[14].current_cw_train_state == CW_TRAINING_FAIL)
        env1.pl_agent.pl_driver.lane_driver_ins[14].ld_trans.train_timer_done[14] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[14].lh_trans.train_timer_done[14] = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[14].lh_trans.train_timer_done[14] = 0;      
    end
    begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[15].current_cw_train_state == CW_TRAINING_1)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[15].current_cw_train_state == CW_TRAINING_1)
        env1.pl_agent.pl_driver.lane_driver_ins[15].ld_trans.drvr_oe[15] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[15].lh_trans.drvr_oe[15] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[15].lh_trans.drvr_oe[15] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[15].current_cw_train_state == UNTRAINED)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[15].current_cw_train_state == UNTRAINED)
        env1.pl_agent.pl_driver.lane_driver_ins[15].ld_trans.drvr_oe[15] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[15].lh_trans.drvr_oe[15] = 1; 
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[15].lh_trans.drvr_oe[15] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[15].current_cw_train_state == CW_TRAINING_0)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[15].current_cw_train_state == CW_TRAINING_0)
        env1.pl_agent.pl_driver.lane_driver_ins[15].ld_trans.train_timer_done[15] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[15].lh_trans.train_timer_done[15] = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[15].lh_trans.train_timer_done[15] = 1;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[15].current_cw_train_state == CW_TRAINING_FAIL)
      wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[15].current_cw_train_state == CW_TRAINING_FAIL)
        env1.pl_agent.pl_driver.lane_driver_ins[15].ld_trans.train_timer_done[15] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[15].lh_trans.train_timer_done[15] = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[15].lh_trans.train_timer_done[15] = 0;      
    end


    join_none
end

     //NREAD PACKET
     ll_nread_req_seq = srio_ll_nread_req_seq::type_id::create("ll_nread_req_seq");

     phase.raise_objection( this );
     ll_nread_req_seq.start( env1.e_virtual_sequencer);
     #5000ns;
     phase.drop_objection(this);
    
  endtask


endclass
