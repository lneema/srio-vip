////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_force_reinit_test.sv
// Project :  srio vip
// Purpose :  force reinitilzation
// Author  :  Mobiveil
//
// Test to reinitialize the state changes..
// 1.NREAD transcation 
// 2.force the reinitialization 
// 3.After state changes ,wait for link initialization and use nread transcation .
//Supported by only Gen2 mode
//
////////////////////////////////////////////////////////////////////////////////


class srio_pl_force_reinit_test extends srio_base_test;

  `uvm_component_utils(srio_pl_force_reinit_test)

  srio_ll_nread_req_seq nread_req_seq;
 
    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    
     nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");
       
     phase.raise_objection( this );
       
     nread_req_seq.start( env1.e_virtual_sequencer);  ///NREAD 
      
     env1.pl_agent.pl_agent_rx_trans.force_reinit = 1;
     env1.pl_agent.pl_agent_bfm_trans.force_reinit = 1; // Force re-intialization


     nread_req_seq.start( env1.e_virtual_sequencer);  ///NREAD 

     #20000ns;
     phase.drop_objection(this);

  endtask

  

endclass


