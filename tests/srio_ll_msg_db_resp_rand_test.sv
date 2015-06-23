////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_msg_db_resp_rand_test.sv
// Project : srio vip
// Purpose : Random response for msg/db
// Author  : Mobiveil
//
// Test case for generating random response for msg/db packets 
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_msg_db_resp_rand_test extends srio_base_test;

  `uvm_component_utils(srio_ll_msg_db_resp_rand_test)

   srio_ll_msg_mseg_req_seq ll_message_req_seq;
   srio_ll_doorbell_req_seq ll_doorbell_seq;
    
   function new(string name, uvm_component parent=null);
     super.new(name, parent);
   endfunction

   task run_phase( uvm_phase phase );
    super.run_phase(phase);
     env_config2.ll_config.ll_resp_timeout        = 5000;  
     env_config1.ll_config.en_out_of_order_gen    = TRUE;    
     env_config1.ll_config.gen_resp_en_ratio      = 95;      
     env_config1.ll_config.gen_resp_dis_ratio     = 5;       
     env_config1.ll_config.resp_gen_mode          = RANDOM;  
     env_config1.ll_config.resp_done_ratio        = 90;             
     env_config1.ll_config.resp_retry_ratio       = 5;             
     env_config1.ll_config.resp_err_ratio         = 5;             

    ll_message_req_seq = srio_ll_msg_mseg_req_seq::type_id::create("ll_message_req_seq");
    ll_doorbell_seq = srio_ll_doorbell_req_seq::type_id::create("ll_doorbell_seq");

    phase.raise_objection( this );
    ll_message_req_seq.start( env2.e_virtual_sequencer);
    ll_doorbell_seq.start( env2.e_virtual_sequencer);
    
    #5000ns; 
    phase.drop_objection(this);
    
   endtask

endclass


