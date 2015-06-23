////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_seek_1xmode_ln2_test.sv
// Project :  srio vip
// Purpose :  SEEK to 1xmode lane2. 
// Author  :  Mobiveil
//
// state Transition from SEEK to 1xmode lane2 - test.
//Supported by only Gen1 mode
//
////////////////////////////////////////////////////////////////////////////////

class srio_pl_seek_1xmode_ln2_test extends srio_base_test;
  `uvm_component_utils(srio_pl_seek_1xmode_ln2_test)

  srio_ll_nread_req_seq nread_req_seq;
 srio_pl_sync0_2_3_brk_cb   sync1_2_3_brk_ins; 

  function new(string name, uvm_component parent=null);
    super.new(name, parent);
    sync1_2_3_brk_ins = new();
  endfunction


  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
    
   uvm_callbacks #(srio_pl_lane_driver, srio_pl_sync0_2_3_brk_cb)::add(env1.pl_agent.pl_driver.lane_driver_ins[0], sync1_2_3_brk_ins);
   uvm_callbacks #(srio_pl_lane_driver, srio_pl_sync0_2_3_brk_cb)::add(env1.pl_agent.pl_driver.lane_driver_ins[1], sync1_2_3_brk_ins);
   uvm_callbacks #(srio_pl_lane_driver, srio_pl_sync0_2_3_brk_cb)::add(env1.pl_agent.pl_driver.lane_driver_ins[3], sync1_2_3_brk_ins);
`ifdef SRIO_VIP_B2B
   uvm_callbacks #(srio_pl_lane_driver, srio_pl_sync0_2_3_brk_cb)::add(env2.pl_agent.pl_driver.lane_driver_ins[0], sync1_2_3_brk_ins);
   uvm_callbacks #(srio_pl_lane_driver, srio_pl_sync0_2_3_brk_cb)::add(env2.pl_agent.pl_driver.lane_driver_ins[1], sync1_2_3_brk_ins);
   uvm_callbacks #(srio_pl_lane_driver, srio_pl_sync0_2_3_brk_cb)::add(env2.pl_agent.pl_driver.lane_driver_ins[3], sync1_2_3_brk_ins);
`endif
  endfunction

task run_phase( uvm_phase phase );
    super.run_phase(phase);
  nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");
     env1.pl_agent.pl_agent_rx_trans.force_1x_mode = 1;
     env1.pl_agent.pl_agent_bfm_trans.force_1x_mode = 1;

`ifdef SRIO_VIP_B2B
     env2.pl_agent.pl_agent_rx_trans.force_1x_mode = 1;
     env2.pl_agent.pl_agent_bfm_trans.force_1x_mode = 1;
`endif

     env1.pl_agent.pl_agent_rx_trans.force_laneR = 1;
     env1.pl_agent.pl_agent_bfm_trans.force_laneR = 1; // Force 1x mode support
`ifdef SRIO_VIP_B2B
     env2.pl_agent.pl_agent_rx_trans.force_laneR = 1;
     env2.pl_agent.pl_agent_bfm_trans.force_laneR = 1; // Force 1x mode support
`endif
          void'(srio1_reg_model_rx.Port_0_Control_CSR.Port_Width_Support.predict(2'b00));
          void'(srio1_reg_model_rx.Port_0_Control_CSR.Port_Width_Override.predict(3'b110)); //force single lane R
          void'(srio1_reg_model_rx.Port_0_Control_CSR.Extended_Port_Width_Override.predict(2'b00));
 `ifdef SRIO_VIP_B2B
          void'(srio2_reg_model_rx.Port_0_Control_CSR.Port_Width_Support.predict(2'b00));
          void'(srio2_reg_model_rx.Port_0_Control_CSR.Port_Width_Override.predict(3'b110)); //force single lane R
          void'(srio2_reg_model_rx.Port_0_Control_CSR.Extended_Port_Width_Override.predict(2'b00));
 `endif

  phase.raise_objection( this );
  
       wait(env_config1.pl_tx_mon_init_sm_state == SEEK);
       wait(env_config1.pl_rx_mon_init_sm_state == SEEK);
`ifdef SRIO_VIP_B2B
       wait(env_config2.pl_tx_mon_init_sm_state == SEEK);
       wait(env_config2.pl_rx_mon_init_sm_state == SEEK);
 `endif   
      wait(env_config1.pl_tx_mon_init_sm_state == X1_M2);
      wait(env_config1.pl_rx_mon_init_sm_state == X1_M2);
`ifdef SRIO_VIP_B2B
      wait(env_config2.pl_tx_mon_init_sm_state == X1_M2);
      wait(env_config2.pl_rx_mon_init_sm_state == X1_M2);
`endif
      nread_req_seq.start( env1.e_virtual_sequencer);
  
      #20000ns;
 phase.drop_objection(this);
endtask


endclass


