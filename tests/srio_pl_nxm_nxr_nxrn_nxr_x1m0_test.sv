
////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. Apl rights reserved
//
// File    :  srio_pl_nxm_nxr_nxrn_nxr_x1m0_test.sv
// Project :  srio vip
// Purpose :  INIT State Machine - nxm_nxr_nxrn_nxr_x1m0
// Author  :  Mobiveil
//
// 1.NREAD
// 2. Set retrain timer done and wait for retrain 4 and go to timeout .
////////////////////////////////////////////////////////////////////////////////

class srio_pl_nxm_nxr_nxrn_nxr_x1m0_test extends srio_base_test;

  `uvm_component_utils(srio_pl_nxm_nxr_nxrn_nxr_x1m0_test)
   srio_ll_nread_req_seq ll_nread_req_seq;
  srio_pl_nxm_nxr_nxrn_nxr_x1m0_cb sync3_brk_cb_ins1 ;

   function new(string name, uvm_component parent=null);
    super.new(name, parent); 
     sync3_brk_cb_ins1 = new();
   endfunction

 function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
    uvm_callbacks #(srio_pl_lane_driver,srio_pl_nxm_nxr_nxrn_nxr_x1m0_cb )::add(env1.pl_agent.pl_driver.lane_driver_ins[1], sync3_brk_cb_ins1 );
    uvm_callbacks #(srio_pl_lane_driver,srio_pl_nxm_nxr_nxrn_nxr_x1m0_cb )::add(env2.pl_agent.pl_driver.lane_driver_ins[1], sync3_brk_cb_ins1 );
    uvm_callbacks #(srio_pl_lane_driver,srio_pl_nxm_nxr_nxrn_nxr_x1m0_cb )::add(env1.pl_agent.pl_driver.lane_driver_ins[2], sync3_brk_cb_ins1 );
    uvm_callbacks #(srio_pl_lane_driver,srio_pl_nxm_nxr_nxrn_nxr_x1m0_cb )::add(env2.pl_agent.pl_driver.lane_driver_ins[2], sync3_brk_cb_ins1 );
    uvm_callbacks #(srio_pl_lane_driver,srio_pl_nxm_nxr_nxrn_nxr_x1m0_cb )::add(env1.pl_agent.pl_driver.lane_driver_ins[3], sync3_brk_cb_ins1 );
    uvm_callbacks #(srio_pl_lane_driver,srio_pl_nxm_nxr_nxrn_nxr_x1m0_cb )::add(env2.pl_agent.pl_driver.lane_driver_ins[3], sync3_brk_cb_ins1 );
  endfunction
 


      task run_phase( uvm_phase phase );	 
    super.run_phase(phase);
     //NREAD PACKET
     ll_nread_req_seq = srio_ll_nread_req_seq::type_id::create("ll_nread_req_seq");

     phase.raise_objection( this );
        ll_nread_req_seq.start( env1.e_virtual_sequencer);
        #2000ns;
          
        
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
       
        env1.pl_agent.pl_driver.srio_pl_sm_ins.pl_sm_trans.retrain_timer_done = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.retrain_timer_done = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.retrain_timer_done = 1;
        wait(env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_TIMEOUT );
        wait(env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_TIMEOUT );
        env1.pl_agent.pl_driver.srio_pl_sm_ins.pl_sm_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.retrain_timer_done = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.retrain_timer_done = 0;
       // dfdfdf///
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
      
         ll_nread_req_seq.start( env1.e_virtual_sequencer);
        

     #5000ns;
     phase.drop_objection(this);
    
  endtask


endclass

