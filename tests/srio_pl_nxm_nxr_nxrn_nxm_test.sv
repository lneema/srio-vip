
////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_nxm_nxr_nxrn_nxm_test.sv
// Project :  srio vip
// Purpose :  INIT State Machine -nxmode to nxrecovery to nxretrain to nxm
// Author  :  Mobiveil
//
// state Transition from nxmode to nxrecovery to nx retrain test.
//Supported by only Gen3 mode
////////////////////////////////////////////////////////////////////////////////


class srio_pl_nxm_nxr_nxrn_nxm_test extends srio_base_test;

  `uvm_component_utils(srio_pl_nxm_nxr_nxrn_nxm_test)

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
       
       env1.pl_agent.pl_agent_bfm_trans.lane_trained[0] = 1'b0 ;
	   env1.pl_agent.pl_agent_rx_trans.lane_trained[0] = 1'b0;
 	   env1.pl_agent.pl_agent_tx_trans.lane_trained[0] = 1'b0;

       wait(env_config1.pl_tx_mon_init_sm_state == NX_RECOVERY);
       wait(env_config1.pl_rx_mon_init_sm_state == NX_RECOVERY);
 
       env1.pl_agent.pl_agent_bfm_trans.retrain= 1'b1 ;
	   env1.pl_agent.pl_agent_rx_trans.retrain = 1'b1 ;
 	   env1.pl_agent.pl_agent_tx_trans.retrain = 1'b1 ;

       wait(env_config1.pl_tx_mon_init_sm_state == NX_RETRAIN);
       wait(env_config1.pl_rx_mon_init_sm_state == NX_RETRAIN);

       wait(env_config1.pl_tx_mon_init_sm_state == NX_RECOVERY);
       wait(env_config1.pl_rx_mon_init_sm_state == NX_RECOVERY);

       env1.pl_agent.pl_agent_bfm_trans.retrain= 1'b0 ;
	   env1.pl_agent.pl_agent_rx_trans.retrain = 1'b0 ;
 	   env1.pl_agent.pl_agent_tx_trans.retrain = 1'b0 ;
 
         
       wait(env_config1.pl_tx_mon_init_sm_state == NX_MODE);
       wait(env_config1.pl_rx_mon_init_sm_state == NX_MODE);
       
      nread_req_seq.start( env1.e_virtual_sequencer);
 end  //}
      #20000ns;
    phase.drop_objection(this);
  endtask


endclass


