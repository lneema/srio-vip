
////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_2x_mode_support_disable_test.sv
// Project :  srio vip
// Purpose :  2x mode support 
// Author  :  Mobiveil
//
// Test to 2x mode support disabled.  
//  
// 1.force the 2x mode support  
// 2.After state changes ,wait for link initialization and use nread transcation .
// 3.NREAD transcation
// Supported by all mode (Gen1,Gen2,Gen3)
////////////////////////////////////////////////////////////////////////////////


class srio_pl_2x_mode_support_disable_test extends srio_base_test;

  `uvm_component_utils(srio_pl_2x_mode_support_disable_test)

  srio_ll_nread_req_seq nread_req_seq;
  //srio_pl_2x_mode_support_disable_seq pl_2x_mode_support_disable_seq;
    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);

     env1.pl_agent.pl_config.x2_mode_support = 0;
     //env_config1.pl_config.x2_mode_support = 0;
      
     nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");
    // pl_2x_mode_support_disable_seq = srio_pl_2x_mode_support_disable_seq::type_id::create("pl_2x_mode_support_disable_seq");   
     phase.raise_objection( this );
       
     //wait((env_config1.pl_tx_mon_init_sm_state ==  X1_M1) || (env_config1.pl_tx_mon_init_sm_state ==  X1_M2)); //waiting for lane0 or lane1 initaliaztion
     //wait((env_config1.pl_rx_mon_init_sm_state ==  X1_M1) || (env_config1.pl_rx_mon_init_sm_state ==   X1_M2)); 

     // pl_2x_mode_support_disable_seq.start(env1.e_virtual_sequencer);

     nread_req_seq.start( env1.e_virtual_sequencer);  ///NREAD 

     #100ns;
     phase.drop_objection(this);

  endtask

  

endclass


