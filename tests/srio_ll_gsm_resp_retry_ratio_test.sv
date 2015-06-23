////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_gsm_resp_retry_ratio_test .sv
// Project :  srio vip
// Purpose :  Response retry ratio
// Author  :  Mobiveil
//
// Test for GSM request class for response retry ratio 
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_gsm_resp_retry_ratio_test extends srio_base_test;

  `uvm_component_utils(srio_ll_gsm_resp_retry_ratio_test)

  srio_ll_gsm_random_seq nread_req_seq;

    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
     env1.ll_agent.ll_config.resp_done_ratio = 0;
     env1.ll_agent.ll_config.resp_interv_ratio      = 0;                   ///< Intervention status ratio         
     env1.ll_agent.ll_config.resp_done_interv_ratio = 0;                   ///< Done intervention status ratio 
     env1.ll_agent.ll_config.resp_data_only_ratio   = 0;                   ///< Data only response status ratio
     env1.ll_agent.ll_config.resp_not_owner_ratio   = 0;
     env1.ll_agent.ll_config.resp_retry_ratio = 100;

    nread_req_seq = srio_ll_gsm_random_seq::type_id::create("nread_req_seq");

     phase.raise_objection( this );
     nread_req_seq.start( env2.e_virtual_sequencer);
    
   #1000ns; 
    phase.drop_objection(this);
    
  endtask
 

endclass


