
////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_pl_diff_idle_sel_test .sv
// Project :  srio vip
// Purpose :  IDLE 1
// Author  :  Mobiveil
// 1.Set IDLE selection bit to 1.
// 2.Send NREAD request class
//Supported by only Gen2 mode
//
////////////////////////////////////////////////////////////////////////////////

class srio_pl_diff_idle_sel_test extends srio_base_test;

  `uvm_component_utils(srio_pl_diff_idle_sel_test)

  srio_ll_nread_req_seq nread_req_seq;

    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    env1.pl_agent.pl_config.idle_sel = 0;
    
    nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");

     phase.raise_objection( this );
     nread_req_seq.start( env1.e_virtual_sequencer);
    #2000ns;
 
    phase.drop_objection(this);
    
  endtask

  
endclass


