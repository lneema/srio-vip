////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_dis_1xmode_ln2_test.sv
// Project :  srio vip
// Purpose :  INIT STATE Machine - Discovery to 1xmode lane2. 
// Author  :  Mobiveil
//
// Test for state Transition from discovery to 1xmode lane 2 
// Callback is used for disto1xln2 transition
//Supported by all mode(Gen1,Gen2,Gen3)
// NREAD transition
////////////////////////////////////////////////////////////////////////////////
class srio_pl_dis_1xmode_ln2_test extends srio_base_test;
  `uvm_component_utils(srio_pl_dis_1xmode_ln2_test)
   srio_pl_dis_1xmode_ln2_sm_seq pl_dis_1xmode_ln2_sm_seq;
   srio_ll_nread_req_seq nread_req_seq;
   srio_pl_sync0_sync1_break_callback sync0_sync1_break_callback_ins;
   function new(string name, uvm_component parent=null);
     super.new(name, parent);
     sync0_sync1_break_callback_ins = new();
   endfunction

   function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_sync0_sync1_break_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[0], sync0_sync1_break_callback_ins);
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_sync0_sync1_break_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[1], sync0_sync1_break_callback_ins);
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_sync0_sync1_break_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[3], sync0_sync1_break_callback_ins);
   endfunction

 task run_phase( uvm_phase phase );
    super.run_phase(phase);
   pl_dis_1xmode_ln2_sm_seq = srio_pl_dis_1xmode_ln2_sm_seq::type_id::create("pl_dis_1xmode_ln2_sm_seq"); 
   nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");
    
   phase.raise_objection( this );
      if(!(env_config1.srio_mode == SRIO_GEN30)) begin //{
        wait(env_config1.pl_tx_mon_init_sm_state == DISCOVERY);
        wait(env_config1.pl_rx_mon_init_sm_state == DISCOVERY);

        wait(env_config1.pl_tx_mon_init_sm_state == X1_M2);
        wait(env_config1.pl_rx_mon_init_sm_state == X1_M2);

        nread_req_seq.start( env1.e_virtual_sequencer);
     end //}
    else begin //{
       wait(env_config1.pl_tx_mon_init_sm_state == X1_M2);
       wait(env_config1.pl_rx_mon_init_sm_state == X1_M2);

       nread_req_seq.start( env1.e_virtual_sequencer);
    end   //}
    #20000ns;
  phase.drop_objection(this);

  endtask
endclass


