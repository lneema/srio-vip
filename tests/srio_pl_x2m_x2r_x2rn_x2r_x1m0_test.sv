////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_x2m_x2r_x2rn_x2r_x1m0_test.sv
// Project :  srio vip
// Purpose :  INIT State Machine  x2m to x2rn to x2r to x1m0
// Author  :  Mobiveil
//
// state Transition from x2m to x2rn to x2r to x1m0 test.
//Supported by only Gen3 mode
//
////////////////////////////////////////////////////////////////////////////////


class srio_pl_x2m_x2r_x2rn_x2r_x1m0_test extends srio_base_test;

  `uvm_component_utils(srio_pl_x2m_x2r_x2rn_x2r_x1m0_test)

  srio_ll_nread_req_seq nread_req_seq;
    
  srio_pl_x2m_x2r_x2rn_x2r_x1m0_cb pl_sync3_brk_cb ;

  function new(string name, uvm_component parent=null);
    super.new(name, parent);
    pl_sync3_brk_cb = new();
  endfunction

  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);;
   uvm_callbacks #(srio_pl_lane_driver,srio_pl_x2m_x2r_x2rn_x2r_x1m0_cb )::add(env1.pl_agent.pl_driver.lane_driver_ins[1],pl_sync3_brk_cb );
   uvm_callbacks #(srio_pl_lane_driver,srio_pl_x2m_x2r_x2rn_x2r_x1m0_cb )::add(env1.pl_agent.pl_driver.lane_driver_ins[2],pl_sync3_brk_cb );
   uvm_callbacks #(srio_pl_lane_driver,srio_pl_x2m_x2r_x2rn_x2r_x1m0_cb )::add(env1.pl_agent.pl_driver.lane_driver_ins[3],pl_sync3_brk_cb );
  endfunction
 
    task run_phase( uvm_phase phase );
    super.run_phase(phase);

     nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");
     phase.raise_objection( this );
     if(env_config1.srio_mode == SRIO_GEN30) begin //{
       wait(env_config1.pl_tx_mon_init_sm_state == X2_MODE);
       wait(env_config1.pl_rx_mon_init_sm_state == X2_MODE);
       
       env1.pl_agent.pl_agent_bfm_trans.lane_trained[0] = 1'b0 ;
  	   env1.pl_agent.pl_agent_rx_trans.lane_trained[0] = 1'b0;
 	   env1.pl_agent.pl_agent_tx_trans.lane_trained[0] = 1'b0;

       wait(env_config1.pl_tx_mon_init_sm_state == X2_RECOVERY);
       wait(env_config1.pl_rx_mon_init_sm_state == X2_RECOVERY);
 
       env1.pl_agent.pl_agent_bfm_trans.retrain= 1'b1 ;
 	   env1.pl_agent.pl_agent_rx_trans.retrain = 1'b1 ;
 	   env1.pl_agent.pl_agent_tx_trans.retrain = 1'b1 ;

       wait(env_config1.pl_tx_mon_init_sm_state == X2_RETRAIN);
       wait(env_config1.pl_rx_mon_init_sm_state == X2_RETRAIN);

       wait(env_config1.pl_tx_mon_init_sm_state == X2_RECOVERY);
       wait(env_config1.pl_rx_mon_init_sm_state == X2_RECOVERY);

       env1.pl_agent.pl_agent_bfm_trans.retrain= 1'b0 ;
  	   env1.pl_agent.pl_agent_rx_trans.retrain = 1'b0 ;
 	   env1.pl_agent.pl_agent_tx_trans.retrain = 1'b0 ;
      
      nread_req_seq.start( env1.e_virtual_sequencer);
 end  //}
      #20000ns;
    phase.drop_objection(this);
  endtask


endclass


