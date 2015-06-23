////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_asymmetry_silent_test.sv
// Project :  srio vip
// Purpose :  Asymmetry to Silent   
// Author  :  Mobiveil
//
// state Transition from Asymmetry to silent state test.
//Supported by only Gen3 mode
////////////////////////////////////////////////////////////////////////////////


class srio_pl_asymmetry_silent_test extends srio_base_test;
  `uvm_component_utils(srio_pl_asymmetry_silent_test)
   srio_pl_nx_mode_asymm_sm_seq nx_mode_asymm_sm_seq ; 
   srio_ll_nread_req_seq nread_req_seq;
   srio_pl_asymm_sl_sm_base_seq asymm_sl_sm_base_seq;

  bit [1:0] cmd_ack_status;

   function new(string name, uvm_component parent=null);
     super.new(name, parent);
   endfunction
  task run_phase( uvm_phase phase );
    super.run_phase(phase);
    nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");
    nx_mode_asymm_sm_seq = srio_pl_nx_mode_asymm_sm_seq::type_id::create("nx_mode_asymm_sm_seq");
    asymm_sl_sm_base_seq = srio_pl_asymm_sl_sm_base_seq:: type_id:: create("symm_sl_sm_base_seq");

    void'(srio1_reg_model_tx.Port_0_Power_Management_CSR.predict(32'h0000_07FF));
    void'(srio1_reg_model_rx.Port_0_Power_Management_CSR.predict(32'h0000_07FF));
`ifdef SRIO_VIP_B2B
    void'(srio2_reg_model_tx.Port_0_Power_Management_CSR.predict(32'h0000_07FF));
    void'(srio2_reg_model_rx.Port_0_Power_Management_CSR.predict(32'h0000_07FF));
`endif
    phase.raise_objection( this );
      if(env_config1.srio_mode == SRIO_GEN30) begin //{
        wait(env_config1.pl_tx_mon_init_sm_state == DISCOVERY); 
        wait(env_config1.pl_rx_mon_init_sm_state == DISCOVERY);

	env1.pl_agent.pl_config.asymmetric_support = 1'b1;   //asymmetric support
	
        env1.pl_agent.pl_config.asym_1x_mode_en = 1'b1;   //env1
        env1.pl_agent.pl_config.asym_2x_mode_en = 1'b1;   //env1
        env1.pl_agent.pl_config.asym_nx_mode_en = 1'b1;   //env1

`ifdef SRIO_VIP_B2B
	env2.pl_agent.pl_config.asymmetric_support = 1'b1;
        env2.pl_agent.pl_config.asym_1x_mode_en = 1'b1;   //env2
        env2.pl_agent.pl_config.asym_2x_mode_en = 1'b1;   //env2
        env2.pl_agent.pl_config.asym_nx_mode_en = 1'b1;   //env2
`endif

        
        wait(env_config1.pl_tx_mon_init_sm_state == ASYM_MODE);
        wait(env_config1.pl_rx_mon_init_sm_state == ASYM_MODE);
`ifdef SRIO_VIP_B2B
        wait(env_config2.pl_tx_mon_init_sm_state == ASYM_MODE);
        wait(env_config2.pl_rx_mon_init_sm_state == ASYM_MODE);
`endif
      
	//env1.pl_agent.pl_agent_bfm_trans.change_my_xmt_width = 3'b010;
///	env1.pl_agent.pl_agent_rx_trans.change_my_xmt_width = 3'b010;
       #0 ; 
	env1.pl_agent.pl_agent_rx_trans.end_asym_mode = 1'b1;
	env1.pl_agent.pl_agent_tx_trans.end_asym_mode = 1'b1;
	env1.pl_agent.pl_agent_bfm_trans.end_asym_mode = 1'b1;
`ifdef SRIO_VIP_B2B
	env2.pl_agent.pl_agent_tx_trans.end_asym_mode = 1'b1;
	env2.pl_agent.pl_agent_rx_trans.end_asym_mode = 1'b1;
	env2.pl_agent.pl_agent_bfm_trans.end_asym_mode = 1'b1;
`endif

   //       void'(srio2_reg_model_rx.Port_0_Power_Management_CSR.Change_My_Transmit_Width.predict(3'b110));

      nread_req_seq.start( env1.e_virtual_sequencer);
      end
     #20000ns;
    phase.drop_objection(this);

  endtask


endclass






