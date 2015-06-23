////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_reset_2xmode_test.sv
// Project :  srio vip
// Purpose :  INIT State Machine - Active reset in 2x_MODE . 
// Author  :  Mobiveil
//
//      Test for reset when state machine in 2x State 
//         1. Wait for 2X MODE state 
//         2. Make reset active (active low)
//         3. After delay make reset inactive 
//         4. NREAD Transition 
//Supported by all mode (Gen1,Gen2,Gen3)
//
//      Callback is used to break lane 2 and 3 -disto2xm transition 
////////////////////////////////////////////////////////////////////////////////
class srio_pl_reset_2xmode_test extends srio_base_test;
  `uvm_component_utils(srio_pl_reset_2xmode_test)
  srio_ll_nread_req_seq nread_req_seq;
  srio_pl_sync3_brk_cb sync3_brk_cb_ins1 ;
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
    sync3_brk_cb_ins1 = new();
  endfunction
  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_sync3_brk_cb)::add(env1.pl_agent.pl_driver.lane_driver_ins[2], sync3_brk_cb_ins1 );
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_sync3_brk_cb)::add(env1.pl_agent.pl_driver.lane_driver_ins[3], sync3_brk_cb_ins1 );
  endfunction
 
 task run_phase( uvm_phase phase );
    super.run_phase(phase);
   nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");
   phase.raise_objection( this );
     if(!(env_config1.srio_mode == SRIO_GEN30)) begin //{
       wait(env_config1.pl_tx_mon_init_sm_state == DISCOVERY);
       wait(env_config1.pl_rx_mon_init_sm_state == DISCOVERY);
       
       wait(env_config1.pl_tx_mon_init_sm_state == X2_MODE);
       wait(env_config1.pl_rx_mon_init_sm_state == X2_MODE);
        
      env1.pl_agent.pl_driver.srio_if.srio_rst_n = 1'b0;
      #1000ns;
      env1.pl_agent.pl_driver.srio_if.srio_rst_n = 1'b1;
       nread_req_seq.start( env1.e_virtual_sequencer);
     end // } 
    else  begin //{             //GEN033
         
       wait(env_config1.pl_tx_mon_init_sm_state == X2_MODE);
       wait(env_config1.pl_rx_mon_init_sm_state == X2_MODE);
      env1.pl_agent.pl_driver.srio_if.srio_rst_n = 1'b0;
      #1000ns;
      env1.pl_agent.pl_driver.srio_if.srio_rst_n = 1'b1;
      nread_req_seq.start( env1.e_virtual_sequencer);
    end  //}
  
    #5000ns;
    phase.drop_objection(this);

  endtask


endclass



