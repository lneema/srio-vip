////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_2x_rec_sl_test.sv
// Project :  srio vip
// Purpose :  INIT STATE Machine - 2x recovery to silent
// Author  :  Mobiveil
//
// Test for  2x recovery to silent state transition
// Callback is used for discovery to 2xmode transition
//Supported by all mode(Gen1,Gen2,Gen3)
// NREAD
////////////////////////////////////////////////////////////////////////////////

class srio_pl_2x_rec_sl_test extends srio_base_test;

  `uvm_component_utils(srio_pl_2x_rec_sl_test)

  srio_pl_2xmode_2x_rec_sm_seq pl_2xmode_2x_rec_sm_seq;
  srio_pl_2x_rec_1xmode_ln0_sm_seq pl_2x_rec_1xmode_ln0_sm_seq;
  srio_pl_1xmode_ln0_sl_sm_seq pl_1xmode_ln0_sl_sm_seq;
 

  srio_ll_nread_req_seq nread_req_seq;
 srio_pl_sync0_sync1_brk_cb sync0_sync1_cb_ins ; 
    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
sync0_sync1_cb_ins = new() ;
  endfunction

  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
       uvm_callbacks #(srio_pl_lane_driver,srio_pl_sync0_sync1_brk_cb)::add(env1.pl_agent.pl_driver.lane_driver_ins[0], sync0_sync1_cb_ins);

       uvm_callbacks #(srio_pl_lane_driver,srio_pl_sync0_sync1_brk_cb)::add(env1.pl_agent.pl_driver.lane_driver_ins[1], sync0_sync1_cb_ins);

       uvm_callbacks #(srio_pl_lane_driver,srio_pl_sync0_sync1_brk_cb)::add(env1.pl_agent.pl_driver.lane_driver_ins[2], sync0_sync1_cb_ins);

       uvm_callbacks #(srio_pl_lane_driver,srio_pl_sync0_sync1_brk_cb)::add(env1.pl_agent.pl_driver.lane_driver_ins[3], sync0_sync1_cb_ins);
  endfunction


  task run_phase( uvm_phase phase );
    super.run_phase(phase);
     pl_2xmode_2x_rec_sm_seq = srio_pl_2xmode_2x_rec_sm_seq::type_id::create("pl_2xmode_2x_rec_sm_seq"); 
     pl_2x_rec_1xmode_ln0_sm_seq = srio_pl_2x_rec_1xmode_ln0_sm_seq::type_id::create("pl_2x_rec_1xmode_ln0_sm_seq"); 
     pl_1xmode_ln0_sl_sm_seq = srio_pl_1xmode_ln0_sl_sm_seq::type_id::create("pl_1xmode_ln0_sl_sm_seq"); 
     nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");
       
     phase.raise_objection( this );
      if(!(env_config1.srio_mode == SRIO_GEN30)) begin //{
        wait(env_config1.pl_tx_mon_init_sm_state ==X2_MODE );
        wait(env_config1.pl_rx_mon_init_sm_state ==X2_MODE );
 
   env1.pl_agent.pl_monitor.rx_monitor.pl_link_mon_trans.rcvr_trained[1] = 0;
   env1.pl_agent.pl_monitor.tx_monitor.pl_link_mon_trans.rcvr_trained[1] = 0;
   env1.pl_agent.pl_driver.driver_trans.rcvr_trained[1] = 0;

        wait(env_config1.pl_tx_mon_init_sm_state == X2_RECOVERY);
        wait(env_config1.pl_rx_mon_init_sm_state == X2_RECOVERY);

        wait(env_config1.pl_tx_mon_init_sm_state == DISCOVERY);
        wait(env_config1.pl_rx_mon_init_sm_state == DISCOVERY);

// wait(env_config1.pl_tx_mon_init_sm_state == X2_MODE);
// wait(env_config1.pl_rx_mon_init_sm_state == X2_MODE);

   env1.pl_agent.pl_monitor.rx_monitor.pl_link_mon_trans.rcvr_trained[1] = 1;
   env1.pl_agent.pl_monitor.tx_monitor.pl_link_mon_trans.rcvr_trained[1] = 1;
   env1.pl_agent.pl_driver.driver_trans.rcvr_trained[1] = 1;

  wait(env_config1.pl_tx_mon_init_sm_state == X2_MODE);
  wait(env_config1.pl_rx_mon_init_sm_state == X2_MODE);
       nread_req_seq.start( env1.e_virtual_sequencer);
      end //}
else begin //{
 
 wait(env_config1.pl_tx_mon_init_sm_state == X2_MODE);
 wait(env_config1.pl_rx_mon_init_sm_state == X2_MODE);

    env1.pl_agent.pl_agent_bfm_trans.lane_trained[1] = 1'b0 ;
	env1.pl_agent.pl_agent_rx_trans.lane_trained[1] = 1'b0;
	env1.pl_agent.pl_agent_tx_trans.lane_trained[1] = 1'b0;

      wait(env_config1.pl_tx_mon_init_sm_state == X2_RECOVERY);
      wait(env_config1.pl_rx_mon_init_sm_state == X2_RECOVERY);

    nread_req_seq.start( env1.e_virtual_sequencer);
end //}
    #20000ns; 
    phase.drop_objection(this);

  endtask


endclass


