////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_force_reinit_asymmetry_test.sv
// Project :  srio vip
// Purpose :  INIT State machine - reset in asymmetry test
// Author  :  Mobiveil
//
//      Test for reset when state machine in asymmetry State
//         1. Wait for asymmetry state 
//         2. Make force reinit high
//         4. NREAD Transition 
//Supported by only Gen3 mode
//Callback is used for nxtoasym transition 
////////////////////////////////////////////////////////////////////////////////


class srio_pl_force_reinit_asymmetry_test extends srio_base_test;

  `uvm_component_utils(srio_pl_force_reinit_asymmetry_test)
   srio_pl_nx_mode_asymm_sm_seq nx_mode_asymm_sm_seq ; 
   srio_ll_nread_req_seq nread_req_seq;
   srio_pl_asymm_sl_sm_base_seq asymm_sl_sm_base_seq;
  
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
 
    env1.pl_agent.pl_agent_rx_trans.force_reinit  = 1'b1;
    env1.pl_agent.pl_agent_bfm_trans.force_reinit = 1'b1;
    env1.pl_agent.pl_agent_tx_trans.force_reinit  = 1'b1;
`ifdef SRIO_VIP_B2B
    env2.pl_agent.pl_agent_rx_trans.force_reinit  = 1'b1;
    env2.pl_agent.pl_agent_bfm_trans.force_reinit = 1'b1;
    env2.pl_agent.pl_agent_tx_trans.force_reinit  = 1'b1;
`endif
        nread_req_seq.start( env1.e_virtual_sequencer);
        #20000ns;
      end
    phase.drop_objection(this);

  endtask
endclass

    



