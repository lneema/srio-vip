////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_x1m0_x1r_x1rn_x1r_sl_test.sv
// Project :  srio vip
// Purpose :  INIT STATE Machine - x1m0_x1r_x1rn_x1r_sil
// Author  :  Mobiveil
//
// Test for x1m0_x1r_x1rn_x1r_sil
// Callback is used for discovery to 1xln0 transition and then 1x recovery
//Supported by only Gen3 mode
// NREAD transition
////////////////////////////////////////////////////////////////////////////////


class srio_pl_x1m0_x1r_x1rn_x1r_sl_test extends srio_base_test ;
`uvm_component_utils(srio_pl_x1m0_x1r_x1rn_x1r_sl_test)

  srio_ll_nread_req_seq nread_req_seq;
  srio_pl_1xmode_ln0_1x_rec_sm_seq pl_1xmode_ln0_1x_rec_sm_seq;
  srio_pl_1x_rec_sl_sm_seq pl_1x_rec_sl_sm_seq;

 srio_pl_x1m0_x1r_x1rn_x1r_sl_cb sync1_sync2_break_cb_ins;

function new(string name, uvm_component parent = null);
  super.new(name,parent);
  sync1_sync2_break_cb_ins = new();
endfunction

 function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
    
   uvm_callbacks #(srio_pl_lane_driver, srio_pl_x1m0_x1r_x1rn_x1r_sl_cb  )::add(env1.pl_agent.pl_driver.lane_driver_ins[0], sync1_sync2_break_cb_ins);
   uvm_callbacks #(srio_pl_lane_driver, srio_pl_x1m0_x1r_x1rn_x1r_sl_cb  )::add(env1.pl_agent.pl_driver.lane_driver_ins[1], sync1_sync2_break_cb_ins);
   uvm_callbacks #(srio_pl_lane_driver, srio_pl_x1m0_x1r_x1rn_x1r_sl_cb  )::add(env1.pl_agent.pl_driver.lane_driver_ins[2], sync1_sync2_break_cb_ins);
   uvm_callbacks #(srio_pl_lane_driver, srio_pl_x1m0_x1r_x1rn_x1r_sl_cb  )::add(env1.pl_agent.pl_driver.lane_driver_ins[3], sync1_sync2_break_cb_ins);
  endfunction


task run_phase(uvm_phase phase);
   super.run_phase(phase);
   nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");
   pl_1xmode_ln0_1x_rec_sm_seq = srio_pl_1xmode_ln0_1x_rec_sm_seq::type_id ::create("pl_1xmode_ln0_1x_rec_sm_seq");
   pl_1x_rec_sl_sm_seq = srio_pl_1x_rec_sl_sm_seq::type_id ::create("pl_1x_rec_sl_sm_seq");
   phase.raise_objection(this);
  if(env_config1.srio_mode == SRIO_GEN30) begin //{
     
     wait(env_config1.pl_rx_mon_init_sm_state == X1_M0);
     wait(env_config1.pl_tx_mon_init_sm_state == X1_M0);

     env1.pl_agent.pl_agent_bfm_trans.lane_trained[0] = 1'b0 ;
  	 env1.pl_agent.pl_agent_rx_trans.lane_trained[0] = 1'b0;
 	 env1.pl_agent.pl_agent_tx_trans.lane_trained[0] = 1'b0;

     wait(env_config1.pl_tx_mon_init_sm_state == X1_RECOVERY);
     wait(env_config1.pl_rx_mon_init_sm_state == X1_RECOVERY);
 
     env1.pl_agent.pl_agent_bfm_trans.retrain= 1'b1 ;
 	 env1.pl_agent.pl_agent_rx_trans.retrain = 1'b1 ;
 	 env1.pl_agent.pl_agent_tx_trans.retrain = 1'b1 ;

     wait(env_config1.pl_tx_mon_init_sm_state == X1_RETRAIN);
     wait(env_config1.pl_rx_mon_init_sm_state == X1_RETRAIN);
 
     env1.pl_agent.pl_agent_bfm_trans.retrain= 1'b0 ;
	 env1.pl_agent.pl_agent_rx_trans.retrain = 1'b0 ;
 	 env1.pl_agent.pl_agent_tx_trans.retrain = 1'b0 ;
 
     wait(env_config1.pl_tx_mon_init_sm_state == SILENT);
     wait(env_config1.pl_rx_mon_init_sm_state == SILENT);
             
      nread_req_seq.start( env1.e_virtual_sequencer);

end //}
phase.drop_objection(this);
endtask

endclass
