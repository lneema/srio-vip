////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_force_reinit_2xretrain_test .sv
// Project :  srio vip
// Purpose :  INIT state machine - 2x retrain state force reinit active
// Author  :  Mobiveil
// 
//      Test for reset when state machine in 2X RETRAIN state
//         1. Wait for 2X_RETRAIN state 
//         2. Make force_reinit active 
//         3. After delay make force_reinit inactive 
//         4. NREAD Transition 
//Supported by only Gen3 mode
//////////////////////////////////////////////////////////////////////////////////

class srio_pl_force_reinit_2xretrain_test extends srio_base_test;
  `uvm_component_utils(srio_pl_force_reinit_2xretrain_test )
   srio_ll_nread_req_seq nread_req_seq;
      
    srio_pl_sync3_brk_cb  pl_sync3_brk_cb ;

  function new(string name, uvm_component parent=null);
    super.new(name, parent);
    pl_sync3_brk_cb = new(); 
  endfunction
  
function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
   uvm_callbacks #(srio_pl_lane_driver,srio_pl_sync3_brk_cb )::add(env1.pl_agent.pl_driver.lane_driver_ins[2],pl_sync3_brk_cb );
   uvm_callbacks #(srio_pl_lane_driver,srio_pl_sync3_brk_cb )::add(env1.pl_agent.pl_driver.lane_driver_ins[3],pl_sync3_brk_cb );
  endfunction
 
    task run_phase( uvm_phase phase );
    super.run_phase(phase);

     nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");
     phase.raise_objection( this );
     if(env_config1.srio_mode == SRIO_GEN30) begin //{
       wait(env_config1.pl_tx_mon_init_sm_state == X2_MODE);
       wait(env_config1.pl_rx_mon_init_sm_state == X2_MODE);
       
       env1.pl_agent.pl_agent_bfm_trans.lane_trained[0] = 1'b0 ;
	   env1.pl_agent.pl_agent_rx_trans.lane_trained[0] = 1'b0;
 	   env1.pl_agent.pl_agent_tx_trans.lane_trained[0] = 1'b0;

       wait(env_config1.pl_tx_mon_init_sm_state == X2_RECOVERY);
       wait(env_config1.pl_rx_mon_init_sm_state == X2_RECOVERY);
 
       env1.pl_agent.pl_agent_bfm_trans.retrain= 1'b1 ;
	   env1.pl_agent.pl_agent_rx_trans.retrain = 1'b1 ;
 	   env1.pl_agent.pl_agent_tx_trans.retrain = 1'b1 ;

       wait(env_config1.pl_tx_mon_init_sm_state == X2_RETRAIN);
       wait(env_config1.pl_rx_mon_init_sm_state == X2_RETRAIN);
      
       env1.pl_agent.pl_agent_rx_trans.force_reinit  = 1'b1;
       env1.pl_agent.pl_agent_bfm_trans.force_reinit = 1'b1;
       env1.pl_agent.pl_agent_tx_trans.force_reinit  = 1'b1;
       #200; 
       wait(env_config1.pl_tx_mon_init_sm_state == X2_MODE);
       wait(env_config1.pl_rx_mon_init_sm_state == X2_MODE);
       nread_req_seq.start( env1.e_virtual_sequencer);
 end  //}
      #20000ns;
    phase.drop_objection(this);
  endtask

endclass


