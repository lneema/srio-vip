////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_resp_error_ratio_test.sv
// Project :  srio vip
// Purpose :  Response error ratio
// Author  :  Mobiveil
//
// Test for All request class for response error ratio 
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_resp_error_ratio_test extends srio_base_test;

  `uvm_component_utils(srio_ll_resp_error_ratio_test)

  srio_ll_default_seq nread_req_seq;

    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);

     env1.ll_agent.ll_config.resp_done_ratio = 0;
     env1.ll_agent.ll_config.resp_err_ratio = 100;
     
    nread_req_seq = srio_ll_default_seq::type_id::create("nread_req_seq");

     phase.raise_objection( this );
     nread_req_seq.start( env2.e_virtual_sequencer);
    
    #5000ns; 
    phase.drop_objection(this);
    
  endtask

  
endclass


