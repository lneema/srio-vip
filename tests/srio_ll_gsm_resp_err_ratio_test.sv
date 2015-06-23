////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_gsm_resp_err_ratio_test.sv
// Project :  srio vip
// Purpose :  Response error ratio
// Author  :  Mobiveil
//
// Test for GSM response error ratio 
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_gsm_resp_err_ratio_test extends srio_base_test;

  `uvm_component_utils(srio_ll_gsm_resp_err_ratio_test)

  srio_ll_gsm_random_seq gsm_random_seq;

    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
//Configuration for different response generation
     env1.ll_agent.ll_config.resp_done_ratio        = 20;                  ///< Done response status ratio
     env1.ll_agent.ll_config.resp_err_ratio         = 30;                    ///< Error response status ratio
     env1.ll_agent.ll_config.resp_retry_ratio       = 10;                    ///< Retry response status ratio
     env1.ll_agent.ll_config.resp_interv_ratio      = 10;                   ///< Intervention status ratio         
     env1.ll_agent.ll_config.resp_done_interv_ratio = 10;                   ///< Done intervention status ratio 
     env1.ll_agent.ll_config.resp_data_only_ratio   = 10;                   ///< Data only response status ratio
     env1.ll_agent.ll_config.resp_not_owner_ratio   = 10;   
    gsm_random_seq = srio_ll_gsm_random_seq::type_id::create("gsm_random_seq");

     phase.raise_objection( this );
//Random GSM packets
     gsm_random_seq.start( env2.e_virtual_sequencer);
    
    #5000ns; 
    phase.drop_objection(this);
    
  endtask

  
endclass


