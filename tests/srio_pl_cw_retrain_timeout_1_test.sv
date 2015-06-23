
////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. Apl rights reserved
//
// File    :  srio_pl_cw_retrain_timeout_1_test.sv
// Project :  srio vip
// Purpose :  Retrain.
// Author  :  Mobiveil
// 1. NREAD
// 2.Set retrain timer done for retrain 0,1,2 and 3.
// 3.Retrain Timeout will occur.
// 4. Nread.
// Supported by only  Gen3 mode
////////////////////////////////////////////////////////////////////////////////

class srio_pl_cw_retrain_timeout_1_test extends srio_base_test;

  `uvm_component_utils(srio_pl_cw_retrain_timeout_1_test)
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
          
        //ENV1
       if(env_config1.num_of_lanes == 8) begin //{
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
          
         end //}  
    else if (env_config1.num_of_lanes == 16) begin //{
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

    end //}  
       else if (env_config1.num_of_lanes == 4) begin //{
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


       end //}
    else if (env_config1.num_of_lanes == 2) begin  //{
//ENV1
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
        wait(env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_0 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_0 );

        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.lane_degraded[0] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.lane_degraded[1] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[1] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[1] = 0;

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
        wait(env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_0 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_0 );

        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.lane_degraded[0] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.lane_degraded[1] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[1] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[1] = 0;

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
        wait(env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_0 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_0 );

        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.lane_degraded[0] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 0;
        env1.pl_agent.pl_driver.lane_driver_ins[1].ld_trans.lane_degraded[1] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[1] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[1] = 0;

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
       
        wait(env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_0 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_0 );

        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.lane_degraded[0] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 0;
        

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
        wait(env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_0 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_0 );

        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.lane_degraded[0] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 0;
      

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
       
        wait(env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_0 );
        wait(env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_cw_retrain_state == RETRAIN_0 );

        env1.pl_agent.pl_driver.lane_driver_ins[0].ld_trans.lane_degraded[0] = 0;
        env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 0;
        env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_degraded[0] = 0;
       
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


    end //}

         ll_nread_req_seq.start( env1.e_virtual_sequencer);
        

     #5000ns;
     phase.drop_objection(this);
    
  endtask


endclass


