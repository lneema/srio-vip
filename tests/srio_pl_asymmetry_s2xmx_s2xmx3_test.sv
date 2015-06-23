////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. Apl rights reserved
//
// File    :  srio_pl_asymmetry_s2xmx_s2xmx3_test.sv
// Project :  srio vip
// Purpose :  GEN3.0 Asymmetry test
// Author  :  Mobiveil
//
//// Tests for state transition for seek_2x_mode_xmt to seek_2x_mode_xmt3 
//Supported by only Gen3 mode
////////////////////////////////////////////////////////////////////////////////

class srio_pl_asymmetry_s2xmx_s2xmx3_test extends srio_base_test;

  `uvm_component_utils(srio_pl_asymmetry_s2xmx_s2xmx3_test)
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

	env1.pl_agent.pl_agent_bfm_trans.change_my_xmt_width = 3'b010;
	env1.pl_agent.pl_agent_rx_trans.change_my_xmt_width = 3'b010;

        void'(srio2_reg_model_rx.Port_0_Power_Management_CSR.Change_My_Transmit_Width.predict(3'b010));
       wait(env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_xmit_width_state == SEEK_2X_MODE_XMT);
       wait(env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_xmit_width_state == SEEK_2X_MODE_XMT);
       env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.xmt_width_tmr_done = 1;
       env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.xmt_width_tmr_done = 1;
       env1.pl_agent.pl_driver.srio_pl_sm_ins.xmt_width_tmr_done = 1 ;

       env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.from_sc_receive_lanes_ready = 0;
       env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.from_sc_receive_lanes_ready = 0;   
       env1.pl_agent.pl_driver.srio_pl_sm_ins.pl_sm_trans.from_sc_receive_lanes_ready = 0 ;

       wait(env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_xmit_width_state == SEEK_2X_MODE_XMT_3);
       wait(env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_xmit_width_state == SEEK_2X_MODE_XMT_3);
       env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.xmt_width_tmr_done = 1;
       env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.xmt_width_tmr_done = 1;
       env1.pl_agent.pl_driver.srio_pl_sm_ins.xmt_width_tmr_done = 1 ;
     
  	    port_cmd_ack_method();

    	#10000ns;
     
    	phase.drop_objection(this);
    
  endtask

  task port_cmd_ack_method();

    wait(env1.pl_agent.pl_agent_bfm_trans.xmt_width_port_cmd_ack==1 || env1.pl_agent.pl_agent_bfm_trans.xmt_width_port_cmd_nack==1);
    wait(env1.pl_agent.pl_agent_rx_trans.xmt_width_port_cmd_ack==1 || env1.pl_agent.pl_agent_rx_trans.xmt_width_port_cmd_nack==1);
  
    cmd_ack_status = srio2_reg_model_rx.Port_0_Power_Management_CSR.Status_of_My_Transmit_Width_Change.get();
    while (cmd_ack_status != 2'b01 && cmd_ack_status != 2'b10)
    begin //{
      @(posedge env1.pl_agent.pl_driver.srio_if.sim_clk);
      cmd_ack_status = srio2_reg_model_rx.Port_0_Power_Management_CSR.Status_of_My_Transmit_Width_Change.get();
    end //}
  
    env1.pl_agent.pl_agent_bfm_trans.change_my_xmt_width = 3'b000;
    env1.pl_agent.pl_agent_rx_trans.change_my_xmt_width = 3'b000;
  
    void'(srio2_reg_model_rx.Port_0_Power_Management_CSR.Change_My_Transmit_Width.predict(3'b000));
  
    wait(env1.pl_agent.pl_agent_bfm_trans.xmt_width_port_cmd_ack==0 && env1.pl_agent.pl_agent_bfm_trans.xmt_width_port_cmd_nack==0);
    wait(env1.pl_agent.pl_agent_rx_trans.xmt_width_port_cmd_ack==0 && env1.pl_agent.pl_agent_rx_trans.xmt_width_port_cmd_nack==0);
  
    cmd_ack_status = srio2_reg_model_rx.Port_0_Power_Management_CSR.Status_of_My_Transmit_Width_Change.get();
    while (cmd_ack_status != 2'b00)
    begin //{
      @(posedge env1.pl_agent.pl_driver.srio_if.sim_clk);
      cmd_ack_status = srio2_reg_model_rx.Port_0_Power_Management_CSR.Status_of_My_Transmit_Width_Change.get();
    end //}
  
    wait(env2.pl_agent.pl_agent_bfm_trans.rcv_width_link_cmd_ack==0 && env2.pl_agent.pl_agent_bfm_trans.rcv_width_link_cmd_nack==0);
    wait(env2.pl_agent.pl_agent_rx_trans.rcv_width_link_cmd_ack==0 && env2.pl_agent.pl_agent_rx_trans.rcv_width_link_cmd_nack==0);
  
     ll_nread_req_seq.start( env1.e_virtual_sequencer);
  
  endtask

endclass

