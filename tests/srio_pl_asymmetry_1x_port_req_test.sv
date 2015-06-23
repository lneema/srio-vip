////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_pl_asymmetry_1x_port_req_test.sv
// Project :  srio vip
// Purpose :  Base test
// Author  :  Mobiveil
//
// Test for changing xmt width to 1x w.r.t change my link partner request
// Supported by only  Gen3 mode
//
////////////////////////////////////////////////////////////////////////////////
class srio_pl_asymmetry_1x_port_req_test extends srio_base_test;

  `uvm_component_utils(srio_pl_asymmetry_1x_port_req_test)
   
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

  	   env1.pl_agent.pl_agent_bfm_trans.change_lp_xmt_width = 3'b001;
	   env1.pl_agent.pl_agent_rx_trans.change_lp_xmt_width = 3'b001;

       void'(srio2_reg_model_rx.Port_0_Power_Management_CSR.Change_Link_Partner_Transmit_width.predict(3'b100));
       #2000ns;
  	   env1.pl_agent.pl_agent_bfm_trans.change_lp_xmt_width = 3'b000;
	   env1.pl_agent.pl_agent_rx_trans.change_lp_xmt_width = 3'b000;
       env2.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_common_mon_trans.xmt_width_req_pending[0] = 1;
       env1.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_common_mon_trans.xmt_width_req_pending[0] = 1;
       ll_nread_req_seq.start( env1.e_virtual_sequencer);
       #10000ns;
     
    	phase.drop_objection(this);
    
  endtask


endclass

