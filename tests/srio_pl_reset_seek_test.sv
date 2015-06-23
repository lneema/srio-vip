////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_reset_seek_test .sv
// Project :  srio vip
// Purpose :  INIT state machine - SEEK state reset
// Author  :  Mobiveil
// 
//     Test for reset when state machine in SEEK state
//         1. Wait for SEEK state 
//         2. Make reset active (active low)
//         3. After delay make reset inactive 
//         4. NREAD Transition 
//Supported by all mode (Gen1,Gen2,Gen3)
//////////////////////////////////////////////////////////////////////////////////

class srio_pl_reset_seek_test extends srio_base_test;
  `uvm_component_utils(srio_pl_reset_seek_test)
   srio_ll_nread_req_seq nread_req_seq;
   
   function new(string name, uvm_component parent=null);
     super.new(name, parent);
   endfunction
 
   task run_phase( uvm_phase phase );
    super.run_phase(phase);
     nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");
     phase.raise_objection( this );
       wait(env_config1.pl_tx_mon_init_sm_state == SEEK);
       wait(env_config1.pl_rx_mon_init_sm_state == SEEK);

       env1.pl_agent.pl_driver.srio_if.srio_rst_n = 1'b0;
       #1000ns;
       env1.pl_agent.pl_driver.srio_if.srio_rst_n = 1'b1;
     
       wait(env_config1.pl_tx_mon_init_sm_state == NX_MODE);
       wait(env_config1.pl_rx_mon_init_sm_state == NX_MODE);

      nread_req_seq.start( env1.e_virtual_sequencer);
      #20000ns;
    phase.drop_objection(this);
  endtask

endclass



