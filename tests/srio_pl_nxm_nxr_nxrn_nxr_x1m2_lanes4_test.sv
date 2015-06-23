
////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. Apl rights reserved
//
// File    :  srio_pl_nxm_nxr_nxrn_nxr_x1m2_lanes4_test.sv
// Project :  srio vip
// Purpose :  Retraining.
// Author  :  Mobiveil
//
// 1.Set retrain timer done for all retrain statesin lanes 4.
////////////////////////////////////////////////////////////////////////////////

class srio_pl_nxm_nxr_nxrn_nxr_x1m2_lanes4_test extends srio_base_test;

  `uvm_component_utils(srio_pl_nxm_nxr_nxrn_nxr_x1m2_lanes4_test)
   srio_ll_nread_req_seq ll_nread_req_seq;
 srio_pl_nxm_nxr_nxrn_nxr_x1m2_cb sync3_brk_cb_ins1 ;
    function new(string name, uvm_component parent=null);
    super.new(name, parent); 
sync3_brk_cb_ins1 = new(); 
  endfunction

 function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
    uvm_callbacks #(srio_pl_lane_driver,srio_pl_nxm_nxr_nxrn_nxr_x1m2_cb)::add(env1.pl_agent.pl_driver.lane_driver_ins[0], sync3_brk_cb_ins1 );
    uvm_callbacks #(srio_pl_lane_driver,srio_pl_nxm_nxr_nxrn_nxr_x1m2_cb)::add(env2.pl_agent.pl_driver.lane_driver_ins[0], sync3_brk_cb_ins1 );
    uvm_callbacks #(srio_pl_lane_driver,srio_pl_nxm_nxr_nxrn_nxr_x1m2_cb)::add(env1.pl_agent.pl_driver.lane_driver_ins[1], sync3_brk_cb_ins1 );
    uvm_callbacks #(srio_pl_lane_driver,srio_pl_nxm_nxr_nxrn_nxr_x1m2_cb)::add(env2.pl_agent.pl_driver.lane_driver_ins[1], sync3_brk_cb_ins1 );
    uvm_callbacks #(srio_pl_lane_driver,srio_pl_nxm_nxr_nxrn_nxr_x1m2_cb)::add(env1.pl_agent.pl_driver.lane_driver_ins[3], sync3_brk_cb_ins1 );
    uvm_callbacks #(srio_pl_lane_driver,srio_pl_nxm_nxr_nxrn_nxr_x1m2_cb)::add(env2.pl_agent.pl_driver.lane_driver_ins[3], sync3_brk_cb_ins1 );
  endfunction
 


      task run_phase( uvm_phase phase );	 
    super.run_phase(phase);
     //NREAD PACKET
     ll_nread_req_seq = srio_ll_nread_req_seq::type_id::create("ll_nread_req_seq");

     phase.raise_objection( this );
        ll_nread_req_seq.start( env1.e_virtual_sequencer);
        #2000ns;
          
        //ENV1
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

       //ENV1  first 
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
        
        

        wait(env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_1 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_1 );
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
         //ENV1 third 
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
        
        
        wait(env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_2 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_2 );
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

       //ENV1 fourth 
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
       
         

        wait(env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_3 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_3 );
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

        env1.pl_agent.pl_driver.srio_pl_sm_ins.pl_sm_trans.retrain_timer_done = 1;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.retrain_timer_done = 1;      
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.retrain_timer_done = 1;
        wait(env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_TIMEOUT );
        wait(env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_TIMEOUT );
        env1.pl_agent.pl_driver.srio_pl_sm_ins.pl_sm_trans.retrain_timer_done = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.retrain_timer_done = 0;      
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.retrain_timer_done = 0; 

         ll_nread_req_seq.start( env1.e_virtual_sequencer);
        

     #5000ns;
     phase.drop_objection(this);
    
  endtask


endclass



