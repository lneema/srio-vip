/////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_nxr_nxrn_nxr_sil.sv
// Project :  srio vip
// Purpose :  Init State Machine - nxr_nxrn_nxr_sil
// Author  :  Mobiveil
//
// state Transition from nxr_nxrn_nxr_sil
//Supported by only Gen3 mode
//
////////////////////////////////////////////////////////////////////////////////


class srio_pl_nxr_nxrn_nxr_sil_test extends srio_base_test;
  `uvm_component_utils(srio_pl_nxr_nxrn_nxr_sil_test)
  srio_ll_nread_req_seq nread_req_seq;
  srio_pl_nxr_nxrn_nxr_sil_cb sync0_brk_cb_ins; 
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
    sync0_brk_cb_ins = new();
  endfunction

 function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
   uvm_callbacks #(srio_pl_lane_driver, srio_pl_nxr_nxrn_nxr_sil_cb )::add(env1.pl_agent.pl_driver.lane_driver_ins[0], sync0_brk_cb_ins);
   uvm_callbacks #(srio_pl_lane_driver, srio_pl_nxr_nxrn_nxr_sil_cb )::add(env1.pl_agent.pl_driver.lane_driver_ins[1], sync0_brk_cb_ins);
   uvm_callbacks #(srio_pl_lane_driver, srio_pl_nxr_nxrn_nxr_sil_cb )::add(env1.pl_agent.pl_driver.lane_driver_ins[2], sync0_brk_cb_ins);
   uvm_callbacks #(srio_pl_lane_driver, srio_pl_nxr_nxrn_nxr_sil_cb )::add(env1.pl_agent.pl_driver.lane_driver_ins[3], sync0_brk_cb_ins);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);

     nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");
     phase.raise_objection( this );
     if(env_config1.srio_mode == SRIO_GEN30) begin //{
       wait(env_config1.pl_tx_mon_init_sm_state == NX_MODE);
       wait(env_config1.pl_rx_mon_init_sm_state == NX_MODE);

       wait(env_config1.pl_tx_mon_init_sm_state == NX_RECOVERY);
       wait(env_config1.pl_rx_mon_init_sm_state == NX_RECOVERY);
 
       env1.pl_agent.pl_agent_bfm_trans.retrain= 1'b1 ;
	   env1.pl_agent.pl_agent_rx_trans.retrain = 1'b1 ;
 	   env1.pl_agent.pl_agent_tx_trans.retrain = 1'b1 ;

       wait(env_config1.pl_tx_mon_init_sm_state == NX_RETRAIN);
       wait(env_config1.pl_rx_mon_init_sm_state == NX_RETRAIN);
 
       env1.pl_agent.pl_agent_bfm_trans.retrain= 1'b0 ;
	   env1.pl_agent.pl_agent_rx_trans.retrain = 1'b0 ;
 	   env1.pl_agent.pl_agent_tx_trans.retrain = 1'b0 ;
 
       wait(env_config1.pl_tx_mon_init_sm_state == SILENT);
       wait(env_config1.pl_rx_mon_init_sm_state == SILENT);

       nread_req_seq.start( env1.e_virtual_sequencer);
 end  //}

      #20000ns;
    phase.drop_objection(this);

  endtask


endclass


