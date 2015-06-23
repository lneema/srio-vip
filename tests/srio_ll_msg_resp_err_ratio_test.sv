////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_msg_resp_err_ratio_test.sv
// Project :  srio vip
// Purpose :  Response error ratio
// Author  :  Mobiveil
//
// Test for MSG response error ratio 
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_msg_resp_err_ratio_test extends srio_base_test;

  `uvm_component_utils(srio_ll_msg_resp_err_ratio_test)

  srio_ll_message_random_seq message_random_seq;

    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
//Configuration for different response generation
     env1.ll_agent.ll_config.resp_done_ratio        = 40;                  ///< Done response status ratio
     env1.ll_agent.ll_config.resp_err_ratio         = 40;                    ///< Error response status ratio
     env1.ll_agent.ll_config.resp_retry_ratio       = 20;                    ///< Retry response status ratio

    message_random_seq = srio_ll_message_random_seq::type_id::create("message_random_seq");

     phase.raise_objection( this );
//Random MSG packets
     message_random_seq.start( env2.e_virtual_sequencer);
    
    #5000ns; 
    phase.drop_objection(this);
    
  endtask

  
endclass

