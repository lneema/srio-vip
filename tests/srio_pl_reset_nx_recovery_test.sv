////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_reset_nx_recovery_test.sv
// Project :  srio vip
// Purpose :  INIT State Machine  - NX_RECOVERY State reset
// Author  :  Mobiveil
//
//      Test for reset when state machine in NX_RECOVERY state
//         1. Wait for NX_RECOVERY state 
//         2. Make reset active (active low)
//         3. After delay make reset inactive 
//         4. NREAD Transition 
//Supported by only Gen3 mode
//
////////////////////////////////////////////////////////////////////////////////

class srio_pl_reset_nx_recovery_test extends srio_base_test;
  `uvm_component_utils(srio_pl_reset_nx_recovery_test )
   srio_ll_nread_req_seq nread_req_seq;
  
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

  task run_phase( uvm_phase phase );
    super.run_phase(phase);
    nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");
    phase.raise_objection( this );
     if(env_config1.srio_mode == SRIO_GEN30) begin //{
        wait(env_config1.pl_tx_mon_init_sm_state == NX_MODE);
        wait(env_config1.pl_rx_mon_init_sm_state == NX_MODE);
       
    env1.pl_agent.pl_agent_bfm_trans.lane_trained[0] = 1'b0;    // for Nx_recovery state 
	env1.pl_agent.pl_agent_rx_trans.lane_trained[0]  = 1'b0;
 	env1.pl_agent.pl_agent_tx_trans.lane_trained[0]  = 1'b0;
    
    wait(env_config1.pl_tx_mon_init_sm_state == NX_RECOVERY);
    wait(env_config1.pl_rx_mon_init_sm_state == NX_RECOVERY);
        
    env1.pl_agent.pl_driver.srio_if.srio_rst_n = 1'b0;
    #1000ns;
    env1.pl_agent.pl_driver.srio_if.srio_rst_n = 1'b1;
  
    nread_req_seq.start( env1.e_virtual_sequencer);
     end  //}
   phase.drop_objection(this);
  endtask
endclass
