////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_nx_mode_support_disable_test.sv
// Project :  srio vip
// Purpose :  nx mode support 
// Author  :  Mobiveil
//
// Test to nx mode support disabled.  
//  
// 1.force the nx mode support  
// 2.After state changes ,wait for link initialization and use nread transcation .
// 3.NREAD transcation
// Supported by all mode (Gen1,Gen2,Gen3)
////////////////////////////////////////////////////////////////////////////////


class srio_pl_nx_mode_support_disable_test extends srio_base_test;

  `uvm_component_utils(srio_pl_nx_mode_support_disable_test)

  srio_ll_nread_req_seq nread_req_seq;
  //srio_pl_nx_mode_support_disable_seq pl_nx_mode_support_disable_seq;
    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
      env_config1.pl_config.nx_mode_support = 0;
    // pl_nx_mode_support_disable_seq = srio_pl_nx_mode_support_disable_seq::type_id::create("pl_nx_mode_support_disable_seq");
     nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");
       
     phase.raise_objection( this );
       
     //pl_nx_mode_support_disable_seq.start(env1.e_virtual_sequencer);

     nread_req_seq.start( env1.e_virtual_sequencer);  ///NREAD 

     #100ns;
     phase.drop_objection(this);

  endtask

  
endclass


