
////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_pl_pkt_prob_test .sv
// Project :  srio vip
// Purpose :  PL PACKET RATIO
// Author  :  Mobiveil
// 1. Set the pl packet response ratio.
// 2.Test for NREAD request class
//Supported by all mode (Gen1,Gen2,Gen3)
//
////////////////////////////////////////////////////////////////////////////////

class srio_pl_pkt_prob_test extends srio_base_test;

  `uvm_component_utils(srio_pl_pkt_prob_test)

  srio_ll_nread_req_seq nread_req_seq;

    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    env1.pl_agent.pl_config.pkt_accept_prob = 30;   
    env1.pl_agent.pl_config.pkt_na_prob = 40;   
    env1.pl_agent.pl_config.pkt_retry_prob = 30;   
    nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");

     phase.raise_objection( this );
     nread_req_seq.start( env2.e_virtual_sequencer);
    #2000ns;
 
    phase.drop_objection(this);
    
  endtask

  
endclass


