////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_msg_consecutive_resp_err_test.sv
// Project :  srio vip
// Purpose :  Response error ratio
// Author  :  Mobiveil
//
// Test for MSG consecutive response error ratio 
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_msg_consecutive_resp_err_test extends srio_base_test;

  `uvm_component_utils(srio_ll_msg_consecutive_resp_err_test)

  srio_ll_msg_mseg_max_req_seq msg_mseg_max_req_seq;

    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
     //Configuration for different response generation
     env1.ll_agent.ll_config.resp_done_ratio        = 0;                  ///< Done response status ratio
     env1.ll_agent.ll_config.resp_err_ratio         = 100;                    ///< Error response status ratio
     env1.ll_agent.ll_config.resp_retry_ratio       = 0;                    ///< Retry response status ratio

     msg_mseg_max_req_seq = srio_ll_msg_mseg_max_req_seq::type_id::create("msg_mseg_max_req_seq");

     phase.raise_objection( this );
     //MSG packets
     msg_mseg_max_req_seq.start( env2.e_virtual_sequencer);
    
    #5000ns; 
    phase.drop_objection(this);
    
  endtask

  
endclass

