////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. Apl rights reserved
//
// File    :  srio_pl_cw_retrain_trnd_ret2_ret_fail_test.sv
// Project :  srio vip
// Purpose :   retraining.
// Author  :  Mobiveil
// 1.Wait for Retrain4 and deasseted lane trained for respect lanes.
// 2.Retraining fail states after retraining  2.
// Supported by only  Gen3 mode
////////////////////////////////////////////////////////////////////////////////

class srio_pl_cw_retrain_trnd_ret2_ret_fail_test extends srio_base_test;

  `uvm_component_utils(srio_pl_cw_retrain_trnd_ret2_ret_fail_test)
    rand bit [1:0] mode;
    srio_ll_nread_req_seq ll_nread_req_seq;
   
    function new(string name, uvm_component parent=null);
    super.new(name, parent);   
    endfunction
     task run_phase( uvm_phase phase );	 
    super.run_phase(phase);
     //NREAD PACKET
     ll_nread_req_seq = srio_ll_nread_req_seq::type_id::create("ll_nread_req_seq");

     phase.raise_objection( this );
        ll_nread_req_seq.start( env1.e_virtual_sequencer);
        #2000ns;
        if(env_config1.num_of_lanes == 4 ) begin //{
        //ENV1 five
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.lane_degraded[0] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 1;
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.lane_degraded[1] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[1] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[1] = 1;
         env1.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.lane_degraded[2] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[2] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[2] = 1;
        env1.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.lane_degraded[3] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[3] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[3] = 1;
        wait(env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_0 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_0 );

        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.lane_degraded[0] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.lane_degraded[1] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[1] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[1] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.lane_degraded[2] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[2] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[2] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.lane_degraded[3] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[3] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[3] = 0;

        wait(env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_4 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_4 );
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_cw_train_state == RETRAINING_1);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].current_cw_train_state == RETRAINING_1);
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.lane_trained[0] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.lane_trained[0] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.lane_trained[0] = 0;
        env2.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.lane_trained[0] = 0;
        env2.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.lane_trained[0] = 0;
        env1.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.lane_trained[0] = 0;

        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_cw_train_state == RETRAINING_1);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].current_cw_train_state == RETRAINING_1);
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.lane_trained[1] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.lane_trained[1] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].lh_trans.lane_trained[1] = 0;
        env2.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.lane_trained[1] = 0;
        env2.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.lane_trained[1] = 0;
        env1.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].lh_trans.lane_trained[1] = 0;
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_cw_train_state == RETRAINING_1);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].current_cw_train_state == RETRAINING_1);
        env1.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.lane_trained[2] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].lh_trans.lane_trained[2] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].lh_trans.lane_trained[2] = 0;
        env2.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.lane_trained[2] = 0;
        env2.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].lh_trans.lane_trained[2] = 0;
        env1.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].lh_trans.lane_trained[2] = 0;

        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_cw_train_state == RETRAINING_1);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].current_cw_train_state == RETRAINING_1);
        env1.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.lane_trained[3] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].lh_trans.lane_trained[3] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].lh_trans.lane_trained[3] = 0;
        env2.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.lane_trained[3] = 0;
        env2.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].lh_trans.lane_trained[3] = 0;
        env1.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].lh_trans.lane_trained[3] = 0;

        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_cw_train_state == RETRAINING_2 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].current_cw_train_state == RETRAINING_2 );
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.retrain_timer_done = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.retrain_timer_done = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.retrain_timer_done = 1; 
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.lane_degraded[0] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 1;

        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_cw_train_state == RETRAINING_2 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].current_cw_train_state == RETRAINING_2 );
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.retrain_timer_done = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.retrain_timer_done = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].lh_trans.retrain_timer_done = 1; 
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.lane_degraded[1] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[1] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[1] = 1;
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_cw_train_state == RETRAINING_2 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].current_cw_train_state == RETRAINING_2 );
        env1.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.retrain_timer_done = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].lh_trans.retrain_timer_done = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].lh_trans.retrain_timer_done = 1;
        env1.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.lane_degraded[2] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[2] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[2] = 1;
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_cw_train_state == RETRAINING_2 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].current_cw_train_state == RETRAINING_2 );
        env1.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.retrain_timer_done = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].lh_trans.retrain_timer_done = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].lh_trans.retrain_timer_done = 1; 
      
        env1.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.lane_degraded[3] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[3] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[3] = 1;

          
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_cw_train_state == RETRAIN_FAIL);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].current_cw_train_state == RETRAIN_FAIL);
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_cw_train_state == RETRAIN_FAIL);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].current_cw_train_state == RETRAIN_FAIL);
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_cw_train_state == RETRAIN_FAIL);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].current_cw_train_state == RETRAIN_FAIL);
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_cw_train_state == RETRAIN_FAIL);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].current_cw_train_state == RETRAIN_FAIL);
             
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.retrain_timer_done = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.retrain_timer_done = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].lh_trans.retrain_timer_done = 0;

        env1.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].lh_trans.retrain_timer_done = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].lh_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].lh_trans.retrain_timer_done = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].lh_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.lane_degraded[0] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.lane_degraded[1] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[1] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[1] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.lane_degraded[2] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[2] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[2] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.lane_degraded[3] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[3] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[3] = 0;

          
        end //}

        else if (env_config1.num_of_lanes == 8) begin //{
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.lane_degraded[0] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 1;
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.lane_degraded[1] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[1] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[1] = 1;
        env1.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.lane_degraded[2] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[2] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[2] = 1;
        env1.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.lane_degraded[3] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[3] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[3] = 1;
        env1.pl_agent.pl_driver.lane_driver_ins[4].ld_trans.lane_degraded[4] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[4] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[4] = 1;
        env1.pl_agent.pl_driver.lane_driver_ins[5].ld_trans.lane_degraded[5] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[5] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[5] = 1;
        env1.pl_agent.pl_driver.lane_driver_ins[6].ld_trans.lane_degraded[6] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[6] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[6] = 1;
        env1.pl_agent.pl_driver.lane_driver_ins[7].ld_trans.lane_degraded[7] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[7] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[7] = 1;

        wait(env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_0 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_0 );

        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.lane_degraded[0] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.lane_degraded[1] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[1] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[1] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.lane_degraded[2] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[2] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[2] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.lane_degraded[3] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[3] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[3] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[4].ld_trans.lane_degraded[4] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[4] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[4] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[5].ld_trans.lane_degraded[5] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[5] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[5] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[6].ld_trans.lane_degraded[6] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[6] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[6] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[7].ld_trans.lane_degraded[7] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[7] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[7] = 0;

        wait(env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_4 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_4 );

        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_cw_train_state == RETRAINING_1);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].current_cw_train_state == RETRAINING_1);
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.lane_trained[0] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.lane_trained[0] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.lane_trained[0] = 0;
        env2.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.lane_trained[0] = 0;
        env2.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.lane_trained[0] = 0;
        env1.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.lane_trained[0] = 0;

        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_cw_train_state == RETRAINING_1);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].current_cw_train_state == RETRAINING_1);
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.lane_trained[1] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.lane_trained[1] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].lh_trans.lane_trained[1] = 0;
        env2.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.lane_trained[1] = 0;
        env2.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.lane_trained[1] = 0;
        env1.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].lh_trans.lane_trained[1] = 0;
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_cw_train_state == RETRAINING_1);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].current_cw_train_state == RETRAINING_1);
        env1.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.lane_trained[2] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].lh_trans.lane_trained[2] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].lh_trans.lane_trained[2] = 0;
        env2.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.lane_trained[2] = 0;
        env2.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].lh_trans.lane_trained[2] = 0;
        env1.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].lh_trans.lane_trained[2] = 0;

        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_cw_train_state == RETRAINING_1);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].current_cw_train_state == RETRAINING_1);
        env1.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.lane_trained[3] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].lh_trans.lane_trained[3] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].lh_trans.lane_trained[3] = 0;
        env2.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.lane_trained[3] = 0;
        env2.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].lh_trans.lane_trained[3] = 0;
        env1.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].lh_trans.lane_trained[3] = 0;
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].current_cw_train_state == RETRAINING_1);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[4].current_cw_train_state == RETRAINING_1);
        env1.pl_agent.pl_driver.lane_driver_ins[4].ld_trans.lane_trained[4] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].lh_trans.lane_trained[4] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[4].lh_trans.lane_trained[4] = 0;
        env2.pl_agent.pl_driver.lane_driver_ins[4].ld_trans.lane_trained[4] = 0;
        env2.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].lh_trans.lane_trained[4] = 0;
        env1.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[4].lh_trans.lane_trained[4] = 0;

        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].current_cw_train_state == RETRAINING_1);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[5].current_cw_train_state == RETRAINING_1);
        env1.pl_agent.pl_driver.lane_driver_ins[5].ld_trans.lane_trained[5] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].lh_trans.lane_trained[5] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[5].lh_trans.lane_trained[5] = 0;
        env2.pl_agent.pl_driver.lane_driver_ins[5].ld_trans.lane_trained[5] = 0;
        env2.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].lh_trans.lane_trained[5] = 0;
        env1.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[5].lh_trans.lane_trained[5] = 0;

        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].current_cw_train_state == RETRAINING_1);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[6].current_cw_train_state == RETRAINING_1);
         env1.pl_agent.pl_driver.lane_driver_ins[6].ld_trans.lane_trained[6] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].lh_trans.lane_trained[6] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[6].lh_trans.lane_trained[6] = 0;
        env2.pl_agent.pl_driver.lane_driver_ins[6].ld_trans.lane_trained[6] = 0;
        env2.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].lh_trans.lane_trained[6] = 0;
        env1.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[6].lh_trans.lane_trained[6] = 0;

        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].current_cw_train_state == RETRAINING_1);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[7].current_cw_train_state == RETRAINING_1);
        env1.pl_agent.pl_driver.lane_driver_ins[7].ld_trans.lane_trained[7] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].lh_trans.lane_trained[7] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[7].lh_trans.lane_trained[7] = 0;
        env2.pl_agent.pl_driver.lane_driver_ins[7].ld_trans.lane_trained[7] = 0;
        env2.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].lh_trans.lane_trained[7] = 0;
        env1.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[7].lh_trans.lane_trained[7] = 0;

        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_cw_train_state == RETRAINING_2 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].current_cw_train_state == RETRAINING_2 );
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.retrain_timer_done = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.retrain_timer_done = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.retrain_timer_done = 1; 
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.lane_degraded[0] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 1;

        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_cw_train_state == RETRAINING_2 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].current_cw_train_state == RETRAINING_2 );
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.retrain_timer_done = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.retrain_timer_done = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].lh_trans.retrain_timer_done = 1; 
         env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.lane_degraded[1] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[1] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[1] = 1;
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_cw_train_state == RETRAINING_2 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].current_cw_train_state == RETRAINING_2 );
        env1.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.retrain_timer_done = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].lh_trans.retrain_timer_done = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].lh_trans.retrain_timer_done = 1;
        env1.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.lane_degraded[2] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[2] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[2] = 1;

        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_cw_train_state == RETRAINING_2 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].current_cw_train_state == RETRAINING_2 );
        env1.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.retrain_timer_done = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].lh_trans.retrain_timer_done = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].lh_trans.retrain_timer_done = 1; 
        env1.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.lane_degraded[3] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[3] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[3] = 1;
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].current_cw_train_state == RETRAINING_2 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[4].current_cw_train_state == RETRAINING_2 );
        env1.pl_agent.pl_driver.lane_driver_ins[4].ld_trans.retrain_timer_done = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].lh_trans.retrain_timer_done = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[4].lh_trans.retrain_timer_done = 1; 
         env1.pl_agent.pl_driver.lane_driver_ins[4].ld_trans.lane_degraded[4] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[4] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[4] = 1;

        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].current_cw_train_state == RETRAINING_2 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[5].current_cw_train_state == RETRAINING_2 );
        env1.pl_agent.pl_driver.lane_driver_ins[5].ld_trans.retrain_timer_done = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].lh_trans.retrain_timer_done = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[5].lh_trans.retrain_timer_done = 1; 
        env1.pl_agent.pl_driver.lane_driver_ins[5].ld_trans.lane_degraded[5] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[5] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[5] = 1;

        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].current_cw_train_state == RETRAINING_2 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[6].current_cw_train_state == RETRAINING_2 );
        env1.pl_agent.pl_driver.lane_driver_ins[6].ld_trans.retrain_timer_done = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].lh_trans.retrain_timer_done = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[6].lh_trans.retrain_timer_done = 1;
        env1.pl_agent.pl_driver.lane_driver_ins[6].ld_trans.lane_degraded[6] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[6] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[6] = 1;
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].current_cw_train_state == RETRAINING_2 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[7].current_cw_train_state == RETRAINING_2 );
        env1.pl_agent.pl_driver.lane_driver_ins[7].ld_trans.retrain_timer_done = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].lh_trans.retrain_timer_done = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[7].lh_trans.retrain_timer_done = 1; 
               
        env1.pl_agent.pl_driver.lane_driver_ins[7].ld_trans.lane_degraded[7] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[7] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[7] = 1;

           
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_cw_train_state == RETRAIN_FAIL);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].current_cw_train_state == RETRAIN_FAIL);
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_cw_train_state == RETRAIN_FAIL);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].current_cw_train_state == RETRAIN_FAIL);
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_cw_train_state == RETRAIN_FAIL);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].current_cw_train_state == RETRAIN_FAIL);
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_cw_train_state == RETRAIN_FAIL);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].current_cw_train_state == RETRAIN_FAIL);
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].current_cw_train_state == RETRAIN_FAIL);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[4].current_cw_train_state == RETRAIN_FAIL);
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].current_cw_train_state == RETRAIN_FAIL);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[5].current_cw_train_state == RETRAIN_FAIL);
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].current_cw_train_state == RETRAIN_FAIL);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[6].current_cw_train_state == RETRAIN_FAIL);
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].current_cw_train_state == RETRAIN_FAIL);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[7].current_cw_train_state == RETRAIN_FAIL);
     
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.retrain_timer_done = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.retrain_timer_done = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].lh_trans.retrain_timer_done = 0;

        env1.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].lh_trans.retrain_timer_done = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].lh_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].lh_trans.retrain_timer_done = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].lh_trans.retrain_timer_done = 0;
         env1.pl_agent.pl_driver.lane_driver_ins[4].ld_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].lh_trans.retrain_timer_done = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[4].lh_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[5].ld_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].lh_trans.retrain_timer_done = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[5].lh_trans.retrain_timer_done = 0;

        env1.pl_agent.pl_driver.lane_driver_ins[6].ld_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].lh_trans.retrain_timer_done = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[6].lh_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[7].ld_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].lh_trans.retrain_timer_done = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[7].lh_trans.retrain_timer_done = 0;

        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.lane_degraded[0] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.lane_degraded[1] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[1] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[1] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.lane_degraded[2] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[2] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[2] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.lane_degraded[3] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[3] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[3] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[4].ld_trans.lane_degraded[4] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[4] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[4] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[5].ld_trans.lane_degraded[5] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[5] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[5] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[6].ld_trans.lane_degraded[6] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[6] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[6] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[7].ld_trans.lane_degraded[7] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[7] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[7] = 0;

         
        end //}
        else if (env_config1.num_of_lanes == 16) begin //{
        //ENV1 five
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.lane_degraded[0] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 1;
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.lane_degraded[1] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[1] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[1] = 1;
        env1.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.lane_degraded[2] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[2] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[2] = 1;
        env1.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.lane_degraded[3] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[3] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[3] = 1;
        env1.pl_agent.pl_driver.lane_driver_ins[4].ld_trans.lane_degraded[4] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[4] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[4] = 1;
        env1.pl_agent.pl_driver.lane_driver_ins[5].ld_trans.lane_degraded[5] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[5] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[5] = 1;
        env1.pl_agent.pl_driver.lane_driver_ins[6].ld_trans.lane_degraded[6] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[6] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[6] = 1;
        env1.pl_agent.pl_driver.lane_driver_ins[7].ld_trans.lane_degraded[7] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[7] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[7] = 1;
        env1.pl_agent.pl_driver.lane_driver_ins[8].ld_trans.lane_degraded[8] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[8] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[8] = 1;
        env1.pl_agent.pl_driver.lane_driver_ins[9].ld_trans.lane_degraded[9] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[9] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[9] = 1;
        env1.pl_agent.pl_driver.lane_driver_ins[10].ld_trans.lane_degraded[10] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[10] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[10] = 1;
        env1.pl_agent.pl_driver.lane_driver_ins[11].ld_trans.lane_degraded[11] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[11] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[11] = 1;
         env1.pl_agent.pl_driver.lane_driver_ins[12].ld_trans.lane_degraded[12] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[12] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[12] = 1;
        env1.pl_agent.pl_driver.lane_driver_ins[13].ld_trans.lane_degraded[13] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[13] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[13] = 1;
        env1.pl_agent.pl_driver.lane_driver_ins[14].ld_trans.lane_degraded[14] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[14] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[14] = 1;
        env1.pl_agent.pl_driver.lane_driver_ins[15].ld_trans.lane_degraded[15] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[15] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[15] = 1;

        wait(env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_0 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_0 );

        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.lane_degraded[0] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.lane_degraded[1] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[1] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[1] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.lane_degraded[2] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[2] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[2] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.lane_degraded[3] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[3] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[3] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[4].ld_trans.lane_degraded[4] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[4] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[4] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[5].ld_trans.lane_degraded[5] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[5] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[5] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[6].ld_trans.lane_degraded[6] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[6] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[6] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[7].ld_trans.lane_degraded[7] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[7] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[7] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[8].ld_trans.lane_degraded[8] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[8] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[8] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[9].ld_trans.lane_degraded[9] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[9] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[9] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[10].ld_trans.lane_degraded[10] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[10] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[10] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[11].ld_trans.lane_degraded[11] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[11] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[11] = 0;
         env1.pl_agent.pl_driver.lane_driver_ins[12].ld_trans.lane_degraded[12] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[12] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[12] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[13].ld_trans.lane_degraded[13] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[13] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[13] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[14].ld_trans.lane_degraded[14] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[14] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[14] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[15].ld_trans.lane_degraded[15] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[15] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[15] = 0;

        wait(env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_4 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_4 );
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_cw_train_state == RETRAINING_1);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].current_cw_train_state == RETRAINING_1);
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.lane_trained[0] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.lane_trained[0] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.lane_trained[0] = 0;
        env2.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.lane_trained[0] = 0;
        env2.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.lane_trained[0] = 0;
        env1.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.lane_trained[0] = 0;
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_cw_train_state == RETRAINING_1);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].current_cw_train_state == RETRAINING_1);
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.lane_trained[1] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.lane_trained[1] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].lh_trans.lane_trained[1] = 0;
        env2.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.lane_trained[1] = 0;
        env2.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.lane_trained[1] = 0;
        env1.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].lh_trans.lane_trained[1] = 0;

        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_cw_train_state == RETRAINING_1);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].current_cw_train_state == RETRAINING_1);
        env1.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.lane_trained[2] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].lh_trans.lane_trained[2] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].lh_trans.lane_trained[2] = 0;
        env2.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.lane_trained[2] = 0;
        env2.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].lh_trans.lane_trained[2] = 0;
        env1.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].lh_trans.lane_trained[2] = 0;
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_cw_train_state == RETRAINING_1);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].current_cw_train_state == RETRAINING_1);
        env1.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.lane_trained[3] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].lh_trans.lane_trained[3] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].lh_trans.lane_trained[3] = 0;
        env2.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.lane_trained[3] = 0;
        env2.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].lh_trans.lane_trained[3] = 0;
        env1.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].lh_trans.lane_trained[3] = 0;

        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].current_cw_train_state == RETRAINING_1);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[4].current_cw_train_state == RETRAINING_1);
        env1.pl_agent.pl_driver.lane_driver_ins[4].ld_trans.lane_trained[4] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].lh_trans.lane_trained[4] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[4].lh_trans.lane_trained[4] = 0;
        env2.pl_agent.pl_driver.lane_driver_ins[4].ld_trans.lane_trained[4] = 0;
        env2.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].lh_trans.lane_trained[4] = 0;
        env1.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[4].lh_trans.lane_trained[4] = 0;
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].current_cw_train_state == RETRAINING_1);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[5].current_cw_train_state == RETRAINING_1);
        env1.pl_agent.pl_driver.lane_driver_ins[5].ld_trans.lane_trained[5] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].lh_trans.lane_trained[5] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[5].lh_trans.lane_trained[5] = 0;
        env2.pl_agent.pl_driver.lane_driver_ins[5].ld_trans.lane_trained[5] = 0;
        env2.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].lh_trans.lane_trained[5] = 0;
        env1.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[5].lh_trans.lane_trained[5] = 0;

        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].current_cw_train_state == RETRAINING_1);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[6].current_cw_train_state == RETRAINING_1);
         env1.pl_agent.pl_driver.lane_driver_ins[6].ld_trans.lane_trained[6] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].lh_trans.lane_trained[6] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[6].lh_trans.lane_trained[6] = 0;
        env2.pl_agent.pl_driver.lane_driver_ins[6].ld_trans.lane_trained[6] = 0;
        env2.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].lh_trans.lane_trained[6] = 0;
        env1.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[6].lh_trans.lane_trained[6] = 0;
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].current_cw_train_state == RETRAINING_1);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[7].current_cw_train_state == RETRAINING_1);
         env1.pl_agent.pl_driver.lane_driver_ins[7].ld_trans.lane_trained[7] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].lh_trans.lane_trained[7] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[7].lh_trans.lane_trained[7] = 0;
        env2.pl_agent.pl_driver.lane_driver_ins[7].ld_trans.lane_trained[7] = 0;
        env2.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].lh_trans.lane_trained[7] = 0;
        env1.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[7].lh_trans.lane_trained[7] = 0;
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[8].current_cw_train_state == RETRAINING_1);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[8].current_cw_train_state == RETRAINING_1);
        env1.pl_agent.pl_driver.lane_driver_ins[8].ld_trans.lane_trained[8] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[8].lh_trans.lane_trained[8] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[8].lh_trans.lane_trained[8] = 0;
        env2.pl_agent.pl_driver.lane_driver_ins[8].ld_trans.lane_trained[8] = 0;
        env2.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[8].lh_trans.lane_trained[8] = 0;
        env1.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[8].lh_trans.lane_trained[8] = 0;

        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[9].current_cw_train_state == RETRAINING_1);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[9].current_cw_train_state == RETRAINING_1);
        env1.pl_agent.pl_driver.lane_driver_ins[9].ld_trans.lane_trained[9] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[9].lh_trans.lane_trained[9] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[9].lh_trans.lane_trained[9] = 0;
        env2.pl_agent.pl_driver.lane_driver_ins[9].ld_trans.lane_trained[9] = 0;
        env2.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[9].lh_trans.lane_trained[9] = 0;
        env1.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[9].lh_trans.lane_trained[9] = 0;
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[10].current_cw_train_state == RETRAINING_1 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[10].current_cw_train_state == RETRAINING_1 );
        env1.pl_agent.pl_driver.lane_driver_ins[10].ld_trans.lane_trained[10] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[10].lh_trans.lane_trained[10] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[10].lh_trans.lane_trained[10] = 0;
        env2.pl_agent.pl_driver.lane_driver_ins[10].ld_trans.lane_trained[10] = 0;
        env2.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[10].lh_trans.lane_trained[10] = 0;
        env1.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[10].lh_trans.lane_trained[10] = 0;
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[11].current_cw_train_state == RETRAINING_1 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[11].current_cw_train_state == RETRAINING_1 );
        env1.pl_agent.pl_driver.lane_driver_ins[11].ld_trans.lane_trained[11] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[11].lh_trans.lane_trained[11] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[11].lh_trans.lane_trained[11] = 0;
        env2.pl_agent.pl_driver.lane_driver_ins[11].ld_trans.lane_trained[11] = 0;
        env2.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[11].lh_trans.lane_trained[11] = 0;
        env1.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[11].lh_trans.lane_trained[11] = 0;
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[12].current_cw_train_state == RETRAINING_1 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[12].current_cw_train_state == RETRAINING_1 );
        env1.pl_agent.pl_driver.lane_driver_ins[12].ld_trans.lane_trained[12] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[12].lh_trans.lane_trained[12] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[12].lh_trans.lane_trained[12] = 0;
        env2.pl_agent.pl_driver.lane_driver_ins[12].ld_trans.lane_trained[12] = 0;
        env2.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[12].lh_trans.lane_trained[12] = 0;
        env1.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[12].lh_trans.lane_trained[12] = 0;
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[13].current_cw_train_state == RETRAINING_1 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[13].current_cw_train_state == RETRAINING_1 );
        env1.pl_agent.pl_driver.lane_driver_ins[13].ld_trans.lane_trained[13] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[13].lh_trans.lane_trained[13] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[13].lh_trans.lane_trained[13] = 0;
        env2.pl_agent.pl_driver.lane_driver_ins[13].ld_trans.lane_trained[13] = 0;
        env2.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[13].lh_trans.lane_trained[13] = 0;
        env1.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[13].lh_trans.lane_trained[13] = 0;
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[14].current_cw_train_state == RETRAINING_1 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[14].current_cw_train_state == RETRAINING_1 );
         env1.pl_agent.pl_driver.lane_driver_ins[14].ld_trans.lane_trained[14] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[14].lh_trans.lane_trained[14] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[14].lh_trans.lane_trained[14] = 0;
        env2.pl_agent.pl_driver.lane_driver_ins[14].ld_trans.lane_trained[14] = 0;
        env2.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[14].lh_trans.lane_trained[14] = 0;
        env1.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[14].lh_trans.lane_trained[14] = 0;

        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[15].current_cw_train_state == RETRAINING_1 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[15].current_cw_train_state == RETRAINING_1 );
        env1.pl_agent.pl_driver.lane_driver_ins[15].ld_trans.lane_trained[15] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[15].lh_trans.lane_trained[15] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[15].lh_trans.lane_trained[15] = 0;
        env2.pl_agent.pl_driver.lane_driver_ins[15].ld_trans.lane_trained[15] = 0;
        env2.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[15].lh_trans.lane_trained[15] = 0;
        env1.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[15].lh_trans.lane_trained[15] = 0;
///
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_cw_train_state == RETRAINING_2 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].current_cw_train_state == RETRAINING_2 );
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.retrain_timer_done = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.retrain_timer_done = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.retrain_timer_done = 1; 
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.lane_degraded[0] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 1;

        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_cw_train_state == RETRAINING_2 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].current_cw_train_state == RETRAINING_2 );
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.retrain_timer_done = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.retrain_timer_done = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].lh_trans.retrain_timer_done = 1; 
         env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.lane_degraded[1] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[1] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[1] = 1;
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_cw_train_state == RETRAINING_2 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].current_cw_train_state == RETRAINING_2 );
        env1.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.retrain_timer_done = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].lh_trans.retrain_timer_done = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].lh_trans.retrain_timer_done = 1;
        env1.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.lane_degraded[2] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[2] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[2] = 1;

        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_cw_train_state == RETRAINING_2 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].current_cw_train_state == RETRAINING_2 );
        env1.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.retrain_timer_done = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].lh_trans.retrain_timer_done = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].lh_trans.retrain_timer_done = 1; 
        env1.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.lane_degraded[3] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[3] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[3] = 1;
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].current_cw_train_state == RETRAINING_2 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[4].current_cw_train_state == RETRAINING_2 );
        env1.pl_agent.pl_driver.lane_driver_ins[4].ld_trans.retrain_timer_done = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].lh_trans.retrain_timer_done = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[4].lh_trans.retrain_timer_done = 1; 
         env1.pl_agent.pl_driver.lane_driver_ins[4].ld_trans.lane_degraded[4] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[4] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[4] = 1;

        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].current_cw_train_state == RETRAINING_2 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[5].current_cw_train_state == RETRAINING_2 );
        env1.pl_agent.pl_driver.lane_driver_ins[5].ld_trans.retrain_timer_done = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].lh_trans.retrain_timer_done = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[5].lh_trans.retrain_timer_done = 1; 
        env1.pl_agent.pl_driver.lane_driver_ins[5].ld_trans.lane_degraded[5] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[5] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[5] = 1;

        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].current_cw_train_state == RETRAINING_2 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[6].current_cw_train_state == RETRAINING_2 );
        env1.pl_agent.pl_driver.lane_driver_ins[6].ld_trans.retrain_timer_done = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].lh_trans.retrain_timer_done = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[6].lh_trans.retrain_timer_done = 1;
        env1.pl_agent.pl_driver.lane_driver_ins[6].ld_trans.lane_degraded[6] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[6] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[6] = 1;
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].current_cw_train_state == RETRAINING_2 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[7].current_cw_train_state == RETRAINING_2 );
        env1.pl_agent.pl_driver.lane_driver_ins[7].ld_trans.retrain_timer_done = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].lh_trans.retrain_timer_done = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[7].lh_trans.retrain_timer_done = 1; 
               
        env1.pl_agent.pl_driver.lane_driver_ins[7].ld_trans.lane_degraded[7] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[7] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[7] = 1;

        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[8].current_cw_train_state == RETRAINING_2 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[8].current_cw_train_state == RETRAINING_2 );
        env1.pl_agent.pl_driver.lane_driver_ins[8].ld_trans.retrain_timer_done = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[8].lh_trans.retrain_timer_done = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[8].lh_trans.retrain_timer_done = 1; 
        env1.pl_agent.pl_driver.lane_driver_ins[8].ld_trans.lane_degraded[8] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[8] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[8] = 0;

        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[9].current_cw_train_state == RETRAINING_2 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[9].current_cw_train_state == RETRAINING_2 );
        env1.pl_agent.pl_driver.lane_driver_ins[9].ld_trans.retrain_timer_done = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[9].lh_trans.retrain_timer_done = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[9].lh_trans.retrain_timer_done = 1; 
        env1.pl_agent.pl_driver.lane_driver_ins[9].ld_trans.lane_degraded[9] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[9] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[9] = 0;

        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[10].current_cw_train_state == RETRAINING_2 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[10].current_cw_train_state == RETRAINING_2 );
        env1.pl_agent.pl_driver.lane_driver_ins[10].ld_trans.retrain_timer_done = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[10].lh_trans.retrain_timer_done = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[10].lh_trans.retrain_timer_done = 1;
        env1.pl_agent.pl_driver.lane_driver_ins[10].ld_trans.lane_degraded[10] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[10] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[10] = 0;
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[11].current_cw_train_state == RETRAINING_2 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[11].current_cw_train_state == RETRAINING_2 );
        env1.pl_agent.pl_driver.lane_driver_ins[11].ld_trans.retrain_timer_done = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[11].lh_trans.retrain_timer_done = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[11].lh_trans.retrain_timer_done = 1; 
        env1.pl_agent.pl_driver.lane_driver_ins[11].ld_trans.lane_degraded[11] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[11] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[11] = 0;

        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[12].current_cw_train_state == RETRAINING_2 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[12].current_cw_train_state == RETRAINING_2 );
        env1.pl_agent.pl_driver.lane_driver_ins[12].ld_trans.retrain_timer_done = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[12].lh_trans.retrain_timer_done = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[12].lh_trans.retrain_timer_done = 1; 
        env1.pl_agent.pl_driver.lane_driver_ins[12].ld_trans.lane_degraded[12] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[12] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[12] = 0;

        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[13].current_cw_train_state == RETRAINING_2 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[13].current_cw_train_state == RETRAINING_2 );
        env1.pl_agent.pl_driver.lane_driver_ins[13].ld_trans.retrain_timer_done = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[13].lh_trans.retrain_timer_done = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[13].lh_trans.retrain_timer_done = 1; 
        env1.pl_agent.pl_driver.lane_driver_ins[13].ld_trans.lane_degraded[13] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[13] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[13] = 0;

        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[14].current_cw_train_state == RETRAINING_2 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[14].current_cw_train_state == RETRAINING_2 );
        env1.pl_agent.pl_driver.lane_driver_ins[14].ld_trans.retrain_timer_done = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[14].lh_trans.retrain_timer_done = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[14].lh_trans.retrain_timer_done = 1;
        env1.pl_agent.pl_driver.lane_driver_ins[14].ld_trans.lane_degraded[14] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[14] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[14] = 0;
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[15].current_cw_train_state == RETRAINING_2 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[15].current_cw_train_state == RETRAINING_2 );
        env1.pl_agent.pl_driver.lane_driver_ins[15].ld_trans.retrain_timer_done = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[15].lh_trans.retrain_timer_done = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[15].lh_trans.retrain_timer_done = 1;
                       
        env1.pl_agent.pl_driver.lane_driver_ins[15].ld_trans.lane_degraded[15] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[15] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[15] = 0;

        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_cw_train_state == RETRAIN_FAIL);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].current_cw_train_state == RETRAIN_FAIL);
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_cw_train_state == RETRAIN_FAIL);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].current_cw_train_state == RETRAIN_FAIL);
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_cw_train_state == RETRAIN_FAIL);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].current_cw_train_state == RETRAIN_FAIL);
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_cw_train_state == RETRAIN_FAIL);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].current_cw_train_state == RETRAIN_FAIL);
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].current_cw_train_state == RETRAIN_FAIL);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[4].current_cw_train_state == RETRAIN_FAIL);
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].current_cw_train_state == RETRAIN_FAIL);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[5].current_cw_train_state == RETRAIN_FAIL);
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].current_cw_train_state == RETRAIN_FAIL);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[6].current_cw_train_state == RETRAIN_FAIL);
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].current_cw_train_state == RETRAIN_FAIL);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[7].current_cw_train_state == RETRAIN_FAIL);
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[8].current_cw_train_state == RETRAIN_FAIL);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[8].current_cw_train_state == RETRAIN_FAIL);
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[9].current_cw_train_state == RETRAIN_FAIL);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[9].current_cw_train_state == RETRAIN_FAIL);
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[10].current_cw_train_state == RETRAIN_FAIL);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[10].current_cw_train_state == RETRAIN_FAIL);
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[11].current_cw_train_state == RETRAIN_FAIL);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[11].current_cw_train_state == RETRAIN_FAIL);
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[12].current_cw_train_state == RETRAIN_FAIL);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[12].current_cw_train_state == RETRAIN_FAIL);
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[13].current_cw_train_state == RETRAIN_FAIL);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[13].current_cw_train_state == RETRAIN_FAIL);
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[14].current_cw_train_state == RETRAIN_FAIL);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[14].current_cw_train_state == RETRAIN_FAIL);
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[15].current_cw_train_state == RETRAIN_FAIL);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[15].current_cw_train_state == RETRAIN_FAIL);
 
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.retrain_timer_done = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.retrain_timer_done = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].lh_trans.retrain_timer_done = 0;

        env1.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].lh_trans.retrain_timer_done = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[2].lh_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].lh_trans.retrain_timer_done = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[3].lh_trans.retrain_timer_done = 0;
         env1.pl_agent.pl_driver.lane_driver_ins[4].ld_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].lh_trans.retrain_timer_done = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[4].lh_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[5].ld_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].lh_trans.retrain_timer_done = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[5].lh_trans.retrain_timer_done = 0;

        env1.pl_agent.pl_driver.lane_driver_ins[6].ld_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].lh_trans.retrain_timer_done = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[6].lh_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[7].ld_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].lh_trans.retrain_timer_done = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[7].lh_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[8].ld_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[8].lh_trans.retrain_timer_done = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[8].lh_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[9].ld_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[9].lh_trans.retrain_timer_done = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[9].lh_trans.retrain_timer_done = 0;

        env1.pl_agent.pl_driver.lane_driver_ins[10].ld_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[10].lh_trans.retrain_timer_done = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[10].lh_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[11].ld_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[11].lh_trans.retrain_timer_done = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[11].lh_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[12].ld_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[12].lh_trans.retrain_timer_done = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[12].lh_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[13].ld_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[13].lh_trans.retrain_timer_done = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[13].lh_trans.retrain_timer_done = 0;

        env1.pl_agent.pl_driver.lane_driver_ins[14].ld_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[14].lh_trans.retrain_timer_done = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[14].lh_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[15].ld_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[15].lh_trans.retrain_timer_done = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[15].lh_trans.retrain_timer_done = 0;

         env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.lane_degraded[0] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.lane_degraded[1] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[1] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[1] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[2].ld_trans.lane_degraded[2] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[2] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[2] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[3].ld_trans.lane_degraded[3] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[3] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[3] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[4].ld_trans.lane_degraded[4] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[4] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[4] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[5].ld_trans.lane_degraded[5] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[5] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[5] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[6].ld_trans.lane_degraded[6] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[6] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[6] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[7].ld_trans.lane_degraded[7] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[7] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[7] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[8].ld_trans.lane_degraded[8] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[8] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[8] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[9].ld_trans.lane_degraded[9] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[9] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[9] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[10].ld_trans.lane_degraded[10] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[10] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[10] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[11].ld_trans.lane_degraded[11] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[11] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[11] = 0;
         env1.pl_agent.pl_driver.lane_driver_ins[12].ld_trans.lane_degraded[12] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[12] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[12] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[13].ld_trans.lane_degraded[13] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[13] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[13] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[14].ld_trans.lane_degraded[14] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[14] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[14] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[15].ld_trans.lane_degraded[15] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[15] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[15] = 0;

       end //}
       else if (env_config1.num_of_lanes == 2) begin //{
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.lane_degraded[0] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 1;
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.lane_degraded[1] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[1] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[1] = 1;
       
        wait(env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_0 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_0 );

        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.lane_degraded[0] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.lane_degraded[1] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[1] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[1] = 0;
        
        wait(env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_4 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_4 );
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_cw_train_state == RETRAINING_1);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].current_cw_train_state == RETRAINING_1);
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.lane_trained[0] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.lane_trained[0] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.lane_trained[0] = 0;
        env2.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.lane_trained[0] = 0;
        env2.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.lane_trained[0] = 0;
        env1.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.lane_trained[0] = 0;

        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_cw_train_state == RETRAINING_1);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].current_cw_train_state == RETRAINING_1);
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.lane_trained[1] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.lane_trained[1] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].lh_trans.lane_trained[1] = 0;
        env2.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.lane_trained[1] = 0;
        env2.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.lane_trained[1] = 0;
        env1.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].lh_trans.lane_trained[1] = 0;

        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_cw_train_state == RETRAINING_2 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].current_cw_train_state == RETRAINING_2 );
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.retrain_timer_done = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.retrain_timer_done = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.retrain_timer_done = 1; 
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.lane_degraded[0] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 1;

        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_cw_train_state == RETRAINING_2 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].current_cw_train_state == RETRAINING_2 );
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.retrain_timer_done = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.retrain_timer_done = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].lh_trans.retrain_timer_done = 1; 
         env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.lane_degraded[1] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[1] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[1] = 1;
 
                
           
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_cw_train_state == RETRAIN_FAIL);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].current_cw_train_state == RETRAIN_FAIL);
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_cw_train_state == RETRAIN_FAIL);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].current_cw_train_state == RETRAIN_FAIL);
         
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.retrain_timer_done = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.retrain_timer_done = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[1].lh_trans.retrain_timer_done = 0;

        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.lane_degraded[0] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.lane_degraded[1] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[1] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[1] = 0;

       
       end //}
       else begin //{
       
       env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.lane_degraded[0] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 1;
              
        wait(env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_0 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_0 );

        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.lane_degraded[0] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 0;
                
        wait(env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_4 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_4 );
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_cw_train_state == RETRAINING_1);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].current_cw_train_state == RETRAINING_1);
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.lane_trained[0] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.lane_trained[0] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.lane_trained[0] = 0;
        env2.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.lane_trained[0] = 0;
        env2.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.lane_trained[0] = 0;
        env1.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.lane_trained[0] = 0;      
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_cw_train_state == RETRAINING_2 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].current_cw_train_state == RETRAINING_2 );
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.retrain_timer_done = 1;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.retrain_timer_done = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.retrain_timer_done = 1;        
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.lane_degraded[0] = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 1;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 1;

        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_cw_train_state == RETRAIN_FAIL);
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].current_cw_train_state == RETRAIN_FAIL);
                
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.retrain_timer_done = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.retrain_timer_done = 0;
         env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.lane_degraded[0] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 0;
              
           
       end //}

         ll_nread_req_seq.start( env1.e_virtual_sequencer);
         #2000ns;
          phase.drop_objection(this);
    
  endtask


endclass


