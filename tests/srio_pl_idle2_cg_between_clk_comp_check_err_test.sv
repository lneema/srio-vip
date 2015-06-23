////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_pl_idle2_cg_between_clk_comp_check_err_test.sv
// Project :  srio vip
// Purpose :  NREAD
// Author  :  Mobiveil
//
// Test for IDLE2 code group between clock compensation error check
//
////////////////////////////////////////////////////////////////////////////////

class srio_pl_idle2_cg_between_clk_comp_check_err_test extends srio_base_test;

  `uvm_component_utils(srio_pl_idle2_cg_between_clk_comp_check_err_test)

  srio_ll_nread_req_seq nread_req_seq;

    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
       
     nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");
     //configuring clock compensation sequence rate with higher value
     env1.pl_agent.pl_config.clk_compensation_seq_rate = 10000;

     phase.raise_objection( this );
       nread_req_seq.start( env1.e_virtual_sequencer);
    #2000ns;
 
    phase.drop_objection(this);
    
  endtask

  
endclass


