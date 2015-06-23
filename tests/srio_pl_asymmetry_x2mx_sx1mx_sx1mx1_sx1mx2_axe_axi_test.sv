////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. Apl rights reserved
//
// File    :  srio_pl_asymmetry_x2mx_sx1mx_sx1mx1_sx1mx2_axe_axi_test.sv
// Project :  srio vip
// Purpose :  GEN3.0 Asymmetry test
// Author  :  Mobiveil
//
//// Tests for state transition for x2mx_sx1mx_sx1mx1_sx1mx2_axe_axi
// Supported by only  Gen3 mode
////////////////////////////////////////////////////////////////////////////////

class srio_pl_asymmetry_x2mx_sx1mx_sx1mx1_sx1mx2_axe_axi_test extends srio_base_test;

  `uvm_component_utils(srio_pl_asymmetry_x2mx_sx1mx_sx1mx1_sx1mx2_axe_axi_test)
     srio_ll_nread_req_seq ll_nread_req_seq;

  bit [1:0] cmd_ack_status;
    
  function new(string name, uvm_component parent=null);

    super.new(name, parent);
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
	    env1.pl_agent.pl_agent_bfm_trans.change_my_xmt_width = 3'b001;
    	env1.pl_agent.pl_agent_rx_trans.change_my_xmt_width = 3'b001;

       void'(srio2_reg_model_rx.Port_0_Power_Management_CSR.Change_My_Transmit_Width.predict(3'b100));
       wait(env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_xmit_width_state == SEEK_1X_MODE_XMT);
       wait(env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_xmit_width_state == SEEK_1X_MODE_XMT);

       wait(env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_xmit_width_state == SEEK_1X_MODE_XMT_1);
       wait(env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_xmit_width_state == SEEK_1X_MODE_XMT_1);

       wait(env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_xmit_width_state == SEEK_1X_MODE_XMT_2);
       wait(env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_xmit_width_state == SEEK_1X_MODE_XMT_2);

    	repeat(2) @(posedge env1.pl_agent.pl_driver.srio_if.sim_clk);

       env1.pl_agent.pl_driver.srio_pl_sm_ins.xmt_width_tmr_done = 1;
       env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.xmt_width_tmr_done = 1;
       env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.xmt_width_tmr_done = 1;

       wait(env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_xmit_width_state == ASYM_XMT_EXIT);
       wait(env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_xmit_width_state == ASYM_XMT_EXIT);

    	repeat(2) @(posedge env1.pl_agent.pl_driver.srio_if.sim_clk);

       env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.xmt_width_tmr_done = 0;
       env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.xmt_width_tmr_done = 0;
       env1.pl_agent.pl_driver.srio_pl_sm_ins.xmt_width_tmr_done = 0 ;

       ll_nread_req_seq.start( env1.e_virtual_sequencer);

    	#10000ns;
     
    	phase.drop_objection(this);
    
  endtask

endclass

