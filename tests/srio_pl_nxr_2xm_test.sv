////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_nxr_2xm_test.sv
// Project :  srio vip
// Purpose :  nxrecovery to 2x mode 
// Author  :  Mobiveil
//
// state Transition from nxrecovery to 2x mode test.
//Supported by only Gen3 mode
//
////////////////////////////////////////////////////////////////////////////////
class srio_pl_nxr_2xm_test extends srio_base_test;
  `uvm_component_utils(srio_pl_nxr_2xm_test)
    srio_ll_nread_req_seq nread_req_seq;
    srio_pl_sync2_brk_cb1 sync2_brk_cb_ins; 
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
    sync2_brk_cb_ins = new();
  endfunction

 function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
   uvm_callbacks #(srio_pl_lane_driver, srio_pl_sync2_brk_cb1)::add(env1.pl_agent.pl_driver.lane_driver_ins[2], sync2_brk_cb_ins);
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
       nread_req_seq.start( env1.e_virtual_sequencer);
 end  //}

      #20000ns;
    phase.drop_objection(this);

  endtask


endclass


