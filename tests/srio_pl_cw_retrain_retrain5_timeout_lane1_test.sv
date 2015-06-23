

////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. Apl rights reserved
//
// File    :  srio_pl_cw_retrain_retrain5_timeout_lane1_test.sv
// Project :  srio vip
// Purpose :  CW training.
// Author  :  Mobiveil
//
// 1.Register callback for 1x mode.
// 2.Set retrain timer done for retrain5 states.
// Supported by only  Gen3 mode
////////////////////////////////////////////////////////////////////////////////

class srio_pl_cw_retrain_retrain5_timeout_lane1_test extends srio_base_test;

  `uvm_component_utils(srio_pl_cw_retrain_retrain5_timeout_lane1_test)
   
    srio_ll_nread_req_seq ll_nread_req_seq;
    srio_pl_sync1_sync2_break_callback pl_sync1_sync2_break_callback; 
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
   pl_sync1_sync2_break_callback = new();
  endfunction
  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
    
    uvm_callbacks #(srio_pl_lane_driver,srio_pl_sync1_sync2_break_callback )::add(env1.pl_agent.pl_driver.lane_driver_ins[1], pl_sync1_sync2_break_callback);
    uvm_callbacks #(srio_pl_lane_driver,srio_pl_sync1_sync2_break_callback )::add(env1.pl_agent.pl_driver.lane_driver_ins[2], pl_sync1_sync2_break_callback);
    uvm_callbacks #(srio_pl_lane_driver,srio_pl_sync1_sync2_break_callback )::add(env1.pl_agent.pl_driver.lane_driver_ins[3], pl_sync1_sync2_break_callback);
    uvm_callbacks #(srio_pl_lane_driver,srio_pl_sync1_sync2_break_callback )::add(env2.pl_agent.pl_driver.lane_driver_ins[1], pl_sync1_sync2_break_callback);
    uvm_callbacks #(srio_pl_lane_driver,srio_pl_sync1_sync2_break_callback )::add(env2.pl_agent.pl_driver.lane_driver_ins[2], pl_sync1_sync2_break_callback);
    uvm_callbacks #(srio_pl_lane_driver,srio_pl_sync1_sync2_break_callback )::add(env2.pl_agent.pl_driver.lane_driver_ins[3], pl_sync1_sync2_break_callback);
    
  endfunction
    task run_phase( uvm_phase phase );	 
    super.run_phase(phase);
     //NREAD PACKET
     ll_nread_req_seq = srio_ll_nread_req_seq::type_id::create("ll_nread_req_seq");

     phase.raise_objection( this );
        ll_nread_req_seq.start( env1.e_virtual_sequencer);
        #2000ns;
         wait((env_config1.pl_rx_mon_init_sm_state == X1_M0)|| (env_config1.pl_tx_mon_init_sm_state == X1_M0)|| (env_config2.pl_rx_mon_init_sm_state == X1_M0)|| (env_config2.pl_tx_mon_init_sm_state == X1_M0));
          
       
       //ENV1 six
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
        
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_cw_train_state == RETRAINING_1 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].current_cw_train_state == RETRAINING_1 );
    
        //ENV1
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.lane_trained[0] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.lane_trained[0] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.lane_trained[0] = 0;
        //ENV2
        env2.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.lane_trained[0] = 0;
        env2.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.lane_trained[0] = 0;
        env1.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.lane_trained[0] = 0;
         
        wait(env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_5 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_5 );
   
        //GO to timeout
        env1.pl_agent.pl_driver.srio_pl_sm_ins.pl_sm_trans.retrain_timer_done = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.retrain_timer_done = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.retrain_timer_done = 1;

        
        wait(env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_TIMEOUT );
        wait(env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_TIMEOUT );
         //GO to timeout
        env1.pl_agent.pl_driver.srio_pl_sm_ins.pl_sm_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.retrain_timer_done = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.retrain_timer_done = 0;

        wait(env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_cw_retrain_state == IDLE );
        wait(env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_cw_retrain_state == IDLE );
        //ENV1 seven
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
      
        
        wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_cw_train_state == RETRAINING_1 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].current_cw_train_state == RETRAINING_1 );
 
        //ENV1
        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.lane_trained[0] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.lane_trained[0] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.lane_trained[0] = 0;
        //ENV2
        env2.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.lane_trained[0] = 0;
        env2.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.lane_trained[0] = 0;
        env1.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[0].lh_trans.lane_trained[0] = 0;
        
        wait(env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_5 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_5 );

         ll_nread_req_seq.start( env1.e_virtual_sequencer);
        

     #5000ns;
     phase.drop_objection(this);
    
  endtask


endclass

