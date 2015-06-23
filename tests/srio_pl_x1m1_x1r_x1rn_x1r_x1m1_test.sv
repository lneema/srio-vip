////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_x1m1_x1r_x1rn_x1r_x1m1_test.sv
// Project :  srio vi
// Purpose :  INIT State Machine - x1m1_x1r_x1rn_x1r_x1m1
// Author  :  Mobiveil
//
// x1m1_x1r_x1rn_x1r_x1m1
// Callback used for disto1xln0 state transition
//Supported by only Gen3 mode
// NREAD
////////////////////////////////////////////////////////////////////////////////
class srio_pl_x1m1_x1r_x1rn_x1r_x1m1_test extends srio_base_test;
  `uvm_component_utils(srio_pl_x1m1_x1r_x1rn_x1r_x1m1_test)

  srio_pl_sync0_sync2_break_cb sync0_sync2_break_cb_ins;
  srio_pl_1xmode_ln0_1x_rec_sm_seq pl_1xmode_ln0_1x_rec_sm_seq;
  srio_ll_nread_req_seq nread_req_seq;

  function new(string name, uvm_component parent=null);
    super.new(name, parent);
    sync0_sync2_break_cb_ins = new();
  endfunction
  
  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
    
   uvm_callbacks #(srio_pl_lane_driver, srio_pl_sync0_sync2_break_cb)::add(env1.pl_agent.pl_driver.lane_driver_ins[0], sync0_sync2_break_cb_ins);
   uvm_callbacks #(srio_pl_lane_driver, srio_pl_sync0_sync2_break_cb)::add(env1.pl_agent.pl_driver.lane_driver_ins[2], sync0_sync2_break_cb_ins);
   uvm_callbacks #(srio_pl_lane_driver, srio_pl_sync0_sync2_break_cb)::add(env1.pl_agent.pl_driver.lane_driver_ins[3], sync0_sync2_break_cb_ins);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);

     nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");
     phase.raise_objection( this );
     if(env_config1.srio_mode == SRIO_GEN30) begin //{
       wait(env_config1.pl_tx_mon_init_sm_state == X1_M1);
       wait(env_config1.pl_rx_mon_init_sm_state == X1_M1);
       
       env1.pl_agent.pl_agent_bfm_trans.lane_trained[1] = 1'b0 ;
	   env1.pl_agent.pl_agent_rx_trans.lane_trained[1] = 1'b0;
 	   env1.pl_agent.pl_agent_tx_trans.lane_trained[1] = 1'b0;

       wait(env_config1.pl_tx_mon_init_sm_state == X1_RECOVERY);
       wait(env_config1.pl_rx_mon_init_sm_state == X1_RECOVERY);
 
       env1.pl_agent.pl_agent_bfm_trans.retrain= 1'b1 ;
	   env1.pl_agent.pl_agent_rx_trans.retrain = 1'b1 ;
 	   env1.pl_agent.pl_agent_tx_trans.retrain = 1'b1 ;

       wait(env_config1.pl_tx_mon_init_sm_state == X1_RETRAIN);
       wait(env_config1.pl_rx_mon_init_sm_state == X1_RETRAIN);

       wait(env_config1.pl_tx_mon_init_sm_state == X1_RECOVERY);
       wait(env_config1.pl_rx_mon_init_sm_state == X1_RECOVERY);

       env1.pl_agent.pl_agent_bfm_trans.retrain= 1'b0 ;
 	   env1.pl_agent.pl_agent_rx_trans.retrain = 1'b0 ;
 	   env1.pl_agent.pl_agent_tx_trans.retrain = 1'b0 ;
      
      nread_req_seq.start( env1.e_virtual_sequencer);
 end  //}
      #20000ns;
    phase.drop_objection(this);
  endtask


endclass


