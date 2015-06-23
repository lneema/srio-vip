////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_nxm_dis_2xm_test.sv
// Project :  srio vip
// Purpose :  NXM to Discovery to 2xm. 
// Author  :  Mobiveil
//
// state Transition from NXM to discovery to 2xm - test.
//Supported by only Gen2 mode
//
////////////////////////////////////////////////////////////////////////////////
class srio_pl_nxm_dis_2xm_test extends srio_base_test;
  `uvm_component_utils(srio_pl_nxm_dis_2xm_test)
 
  srio_pl_dis_1xmode_ln0_sm_seq pl_dis_1xmode_ln0_sm_seq;
  srio_ll_nread_req_seq nread_req_seq;
 srio_pl_nxm_dis_x2m_cb nxm_dis_sl_cb_ins ; 

  function new(string name, uvm_component parent=null);
    super.new(name, parent);
    nxm_dis_sl_cb_ins =new() ;
  endfunction

  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
    
   uvm_callbacks #(srio_pl_lane_driver, srio_pl_nxm_dis_x2m_cb )::add(env1.pl_agent.pl_driver.lane_driver_ins[0], nxm_dis_sl_cb_ins);
   uvm_callbacks #(srio_pl_lane_driver, srio_pl_nxm_dis_x2m_cb )::add(env1.pl_agent.pl_driver.lane_driver_ins[2], nxm_dis_sl_cb_ins);
   uvm_callbacks #(srio_pl_lane_driver, srio_pl_nxm_dis_x2m_cb )::add(env1.pl_agent.pl_driver.lane_driver_ins[3], nxm_dis_sl_cb_ins);
  endfunction



    task run_phase( uvm_phase phase );
    super.run_phase(phase);

     pl_dis_1xmode_ln0_sm_seq = srio_pl_dis_1xmode_ln0_sm_seq::type_id::create("pl_dis_1xmode_ln0_sm_seq"); 
     nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");
       
     phase.raise_objection( this );
         
       wait(env_config1.pl_tx_mon_init_sm_state == DISCOVERY);
       wait(env_config1.pl_rx_mon_init_sm_state == DISCOVERY);
    
//      pl_dis_1xmode_ln0_sm_seq.start( env1.e_virtual_sequencer);

//      wait(env_config1.pl_tx_mon_init_sm_state == X1_M1);
  //    wait(env_config1.pl_rx_mon_init_sm_state == X1_M1);

      nread_req_seq.start( env1.e_virtual_sequencer);
  
     #20000ns;
     phase.drop_objection(this);

  endtask


endclass
