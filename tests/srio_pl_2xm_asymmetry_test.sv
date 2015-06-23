////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_2xm_asymmetry_test.sv
// Project :  srio vip
// Purpose :  2x mode  to asymmetry   
// Author  :  Mobiveil
//
// state Transition from 2x mode to asymmetry test.
//Supported by only Gen3 mode
//
////////////////////////////////////////////////////////////////////////////////


class srio_pl_2xm_asymmetry_test extends srio_base_test;

  `uvm_component_utils(srio_pl_2xm_asymmetry_test)
   srio_pl_2x_mode_asymm_sm_seq twox_mode_asymm_sm_seq ; 
   srio_ll_nread_req_seq nread_req_seq;
   srio_pl_asymm_sl_sm_base_seq asymm_sl_sm_base_seq;
  
  srio_pl_sync3_brk_cb sync3_brk_cb_ins1 ;

  function new(string name, uvm_component parent=null);
     super.new(name, parent);
    sync3_brk_cb_ins1 = new();
   endfunction

  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_sync3_brk_cb)::add(env1.pl_agent.pl_driver.lane_driver_ins[2], sync3_brk_cb_ins1 );
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_sync3_brk_cb)::add(env1.pl_agent.pl_driver.lane_driver_ins[3], sync3_brk_cb_ins1 );
`ifdef SRIO_VIP_B2B
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_sync3_brk_cb )::add(env2.pl_agent.pl_driver.lane_driver_ins[2], sync3_brk_cb_ins1 );
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_sync3_brk_cb )::add(env2.pl_agent.pl_driver.lane_driver_ins[3], sync3_brk_cb_ins1 );
`endif
  endfunction
 
  task run_phase( uvm_phase phase );
    super.run_phase(phase);
    nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");
   twox_mode_asymm_sm_seq = srio_pl_2x_mode_asymm_sm_seq::type_id::create("twox_mode_asymm_sm_seq");
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
        
        nread_req_seq.start( env1.e_virtual_sequencer);
      end
     #20000ns;
    phase.drop_objection(this);

  endtask


endclass

    

