////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. Apl rights reserved
//
// File    :  srio_pl_asymmetry_rcv_x2mr_x2rec_x2rn_x2rec_are_ari_test.sv
// Project :  srio vip
// Purpose :  GEN3.0 Asymmetry test
// Author  :  Mobiveil
//
//// Tests for state transition between srio_pl_asymmetry_rcv_x2mr_x2rec_x2rn_x2rec_are_ari_test 
// Supported by only  Gen3 mode
////////////////////////////////////////////////////////////////////////////////

class srio_pl_asymmetry_rcv_x2mr_x2rec_x2rn_x2rec_are_ari_test extends srio_base_test;

  `uvm_component_utils(srio_pl_asymmetry_rcv_x2mr_x2rec_x2rn_x2rec_are_ari_test)
     srio_ll_nread_req_seq ll_nread_req_seq;
     srio_pl_asymmetry_rcv_x2rnr_x2mrcv_cb pl_asymmetry_rcv_x2rnr_x2mrcv_cb_ins;
  bit [1:0] cmd_ack_status;
    
  function new(string name, uvm_component parent=null);

    super.new(name, parent);
    pl_asymmetry_rcv_x2rnr_x2mrcv_cb_ins = new();
  endfunction

  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
       pl_asymmetry_rcv_x2rnr_x2mrcv_cb_ins.pl_agent_cb = env1.pl_agent;
  uvm_callbacks #(srio_pl_lane_driver, srio_pl_asymmetry_rcv_x2rnr_x2mrcv_cb)::add(env1.pl_agent.pl_driver.lane_driver_ins[0],pl_asymmetry_rcv_x2rnr_x2mrcv_cb_ins);
  uvm_callbacks #(srio_pl_lane_driver, srio_pl_asymmetry_rcv_x2rnr_x2mrcv_cb)::add(env1.pl_agent.pl_driver.lane_driver_ins[1],pl_asymmetry_rcv_x2rnr_x2mrcv_cb_ins);

  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
	env1.pl_agent.pl_config.asymmetric_support = 1'b1;
	env2.pl_agent.pl_config.asymmetric_support = 1'b1;

	env1.pl_agent.pl_config.asym_1x_mode_en = 1'b1;
	env1.pl_agent.pl_config.asym_2x_mode_en = 1'b1;
	env1.pl_agent.pl_config.asym_nx_mode_en = 1'b1;

	env2.pl_agent.pl_config.asym_1x_mode_en = 1'b1;
	env2.pl_agent.pl_config.asym_2x_mode_en = 1'b1;
	env2.pl_agent.pl_config.asym_nx_mode_en = 1'b1;

        void'(srio1_reg_model_tx.Port_0_Power_Management_CSR.predict(32'h0000_03FF));
        void'(srio1_reg_model_rx.Port_0_Power_Management_CSR.predict(32'h0000_03FF));
        void'(srio2_reg_model_tx.Port_0_Power_Management_CSR.predict(32'h0000_03FF));
        void'(srio2_reg_model_rx.Port_0_Power_Management_CSR.predict(32'h0000_03FF));

     phase.raise_objection( this );

        wait(env_config1.pl_tx_mon_init_sm_state == ASYM_MODE);
        wait(env_config1.pl_rx_mon_init_sm_state == ASYM_MODE);
        wait(env_config2.pl_tx_mon_init_sm_state == ASYM_MODE);
        wait(env_config2.pl_rx_mon_init_sm_state == ASYM_MODE);

    	ll_nread_req_seq = srio_ll_nread_req_seq::type_id::create("ll_nread_req_seq");
      	repeat(10) @(posedge env1.pl_agent.pl_driver.srio_if.sim_clk);
	    env1.pl_agent.pl_agent_bfm_trans.change_my_xmt_width = 3'b010;
    	env1.pl_agent.pl_agent_rx_trans.change_my_xmt_width = 3'b010;

       void'(srio2_reg_model_rx.Port_0_Power_Management_CSR.Change_My_Transmit_Width.predict(3'b010));
       

       wait(env1.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_rcv_width_state == SEEK_2X_MODE_RCV);
       wait(env2.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_rcv_width_state == SEEK_2X_MODE_RCV);
       wait(env1.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_rcv_width_state == X2_MODE_RCV);
       wait(env2.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_rcv_width_state == X2_MODE_RCV);

       env1.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.temp_2_lanes_ready = 0;
       env2.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.temp_2_lanes_ready = 0; 
       env2.pl_agent.pl_driver.srio_pl_sm_ins.temp_2_lanes_ready = 0;

       env1.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_sync[0] = 1;
       env2.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.lane_sync[0] = 1;
       env2.pl_agent.pl_driver.srio_pl_sm_ins.pl_sm_trans.lane_sync[0] = 1;

       wait(env1.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_rcv_width_state == X2_RECOVERY_RCV);

       wait(env2.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_rcv_width_state == X2_RECOVERY_RCV);
     
       env1.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.recovery_retrain = 0;
       env2.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.recovery_retrain = 0; 
       env2.pl_agent.pl_driver.srio_pl_sm_ins.pl_sm_trans.recovery_retrain = 0;

       env1.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.retrain = 1;
       env2.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.retrain = 1;
       env2.pl_agent.pl_driver.srio_pl_sm_ins.pl_sm_trans.retrain = 1;
       wait(env1.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_rcv_width_state == X2_RETRAIN_RCV);
       wait(env2.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_rcv_width_state == X2_RETRAIN_RCV);

        wait(env1.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_rcv_width_state == X2_RECOVERY_RCV);
       wait(env2.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_rcv_width_state == X2_RECOVERY_RCV);
  
       env1.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.recovery_timer_done = 1;
       env2.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.recovery_timer_done = 1; 
       env2.pl_agent.pl_driver.srio_pl_sm_ins.recovery_timer_done = 1;
   
       env1.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.recovery_retrain = 1;
       env2.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.recovery_retrain = 1; 
       env2.pl_agent.pl_driver.srio_pl_sm_ins.pl_sm_trans.recovery_retrain = 1;

       env1.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.retrain = 0;
       env2.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.retrain = 0;
       env2.pl_agent.pl_driver.srio_pl_sm_ins.pl_sm_trans.retrain = 0;
      
       env1.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.temp_2_lanes_ready = 0;
       env2.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.temp_2_lanes_ready = 0; 
       env2.pl_agent.pl_driver.srio_pl_sm_ins.temp_2_lanes_ready = 0;
       wait(env1.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_rcv_width_state == ASYM_RCV_EXIT);
       wait(env2.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_rcv_width_state == ASYM_RCV_EXIT);

       wait(env1.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_rcv_width_state == ASYM_RCV_IDLE);

       wait(env2.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_rcv_width_state == ASYM_RCV_IDLE);
       ll_nread_req_seq.start( env1.e_virtual_sequencer);

    	#10000ns;
     
    	phase.drop_objection(this);
    
  endtask

endclass

