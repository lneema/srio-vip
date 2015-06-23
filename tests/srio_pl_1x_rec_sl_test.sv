////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_1x_rec_1xmode_ln0_test.sv
// Project :  srio vip
// Purpose :  INIT STATE Machine - 1x recovery to silent
// Author  :  Mobiveil
//
// Test for 1x recovery to 1x mode lan0 state transition
// Callback is used for discovery to 1xln0 transition and then 1x recovery
//Supported by all mode(Gen1,Gen2,Gen3)
// NREAD transition
////////////////////////////////////////////////////////////////////////////////


class srio_pl_1x_rec_sl_test extends srio_base_test ;
`uvm_component_utils(srio_pl_1x_rec_sl_test)

  srio_ll_nread_req_seq nread_req_seq;
  srio_pl_1xmode_ln0_1x_rec_sm_seq pl_1xmode_ln0_1x_rec_sm_seq;
  srio_pl_1x_rec_sl_sm_seq pl_1x_rec_sl_sm_seq;

  srio_pl_sync1_sync2_break_cb1 sync1_sync2_break_cb_ins;

function new(string name, uvm_component parent = null);
  super.new(name,parent);
  sync1_sync2_break_cb_ins = new();
endfunction

 function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
    
   uvm_callbacks #(srio_pl_lane_driver, srio_pl_sync1_sync2_break_cb1)::add(env1.pl_agent.pl_driver.lane_driver_ins[0], sync1_sync2_break_cb_ins);
   uvm_callbacks #(srio_pl_lane_driver, srio_pl_sync1_sync2_break_cb1)::add(env1.pl_agent.pl_driver.lane_driver_ins[1], sync1_sync2_break_cb_ins);
   uvm_callbacks #(srio_pl_lane_driver, srio_pl_sync1_sync2_break_cb1)::add(env1.pl_agent.pl_driver.lane_driver_ins[2], sync1_sync2_break_cb_ins);
   uvm_callbacks #(srio_pl_lane_driver, srio_pl_sync1_sync2_break_cb1)::add(env1.pl_agent.pl_driver.lane_driver_ins[3], sync1_sync2_break_cb_ins);
  endfunction


task run_phase(uvm_phase phase);
    super.run_phase(phase);
  nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");
pl_1xmode_ln0_1x_rec_sm_seq = srio_pl_1xmode_ln0_1x_rec_sm_seq::type_id ::create("pl_1xmode_ln0_1x_rec_sm_seq");
pl_1x_rec_sl_sm_seq = srio_pl_1x_rec_sl_sm_seq::type_id ::create("pl_1x_rec_sl_sm_seq");
  phase.raise_objection(this);
  if(!(env_config1.srio_mode == SRIO_GEN30)) begin //{
     wait(env_config1.pl_tx_mon_init_sm_state == X1_M0);
     wait(env_config1.pl_rx_mon_init_sm_state == X1_M0);
      

   env1.pl_agent.pl_monitor.rx_monitor.pl_link_mon_trans.rcvr_trained[0] = 0;
   env1.pl_agent.pl_monitor.tx_monitor.pl_link_mon_trans.rcvr_trained[0] = 0;
   env1.pl_agent.pl_driver.driver_trans.rcvr_trained[0] = 0;

     wait(env_config1.pl_tx_mon_init_sm_state ==DISCOVERY);
     wait(env_config1.pl_rx_mon_init_sm_state == DISCOVERY);

   env1.pl_agent.pl_monitor.rx_monitor.pl_link_mon_trans.rcvr_trained[0] = 1;
   env1.pl_agent.pl_monitor.tx_monitor.pl_link_mon_trans.rcvr_trained[0] = 1;
   env1.pl_agent.pl_driver.driver_trans.rcvr_trained[0] = 1;

     wait(env_config1.pl_tx_mon_init_sm_state ==X1_M0);
     wait(env_config1.pl_rx_mon_init_sm_state == X1_M0);

      nread_req_seq.start( env1.e_virtual_sequencer);
 end   //}
  
 else begin //{
     
     wait(env_config1.pl_tx_mon_init_sm_state == X1_M0);
     wait(env_config1.pl_rx_mon_init_sm_state == X1_M0);
    
    env1.pl_agent.pl_agent_bfm_trans.lane_trained[0] = 1'b0 ;
	env1.pl_agent.pl_agent_rx_trans.lane_trained[0] = 1'b0;
	env1.pl_agent.pl_agent_tx_trans.lane_trained[0] = 1'b0;

     wait(env_config1.pl_tx_mon_init_sm_state == X1_RECOVERY);
     wait(env_config1.pl_rx_mon_init_sm_state == X1_RECOVERY);

     wait(env_config1.pl_tx_mon_init_sm_state == SILENT);
     wait(env_config1.pl_rx_mon_init_sm_state == SILENT);
             
      nread_req_seq.start( env1.e_virtual_sequencer);

end //}
#20000ns;
phase.drop_objection(this);
endtask

endclass
