////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_msg_db_resp_retry_ratio_test.sv
// Project :  srio vip
// Purpose :  Response retry ratio
// Author  :  Mobiveil
//
// Test for Message and Doorbell request class for response retry ratio 
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_msg_db_resp_retry_ratio_test extends srio_base_test;

  `uvm_component_utils(srio_ll_msg_db_resp_retry_ratio_test)

srio_ll_msg_mseg_req_seq ll_message_req_seq;
srio_ll_doorbell_req_seq ll_doorbell_seq;
    
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

    ll_message_req_seq = srio_ll_msg_mseg_req_seq::type_id::create("ll_message_req_seq");
    ll_doorbell_seq = srio_ll_doorbell_req_seq::type_id::create("ll_doorbell_seq");

     phase.raise_objection( this );
     ll_message_req_seq.start( env2.e_virtual_sequencer);
     ll_doorbell_seq.start( env2.e_virtual_sequencer);
    
   #1000ns; 
    phase.drop_objection(this);
    
  endtask
 

endclass


