

////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_msg_mseg_resp_retry_ratio_test .sv
// Project :  srio vip
// Purpose :  Message single segment sequences 
// Author  :  Mobiveil
//
// 1. Set the retry ratio value and done ratio value.
//// 2.Message Packet with multi segment sequence
////////////////////////////////////////////////////////////////////////////////

class srio_ll_msg_mseg_resp_retry_ratio_test extends srio_base_test;

  `uvm_component_utils(srio_ll_msg_mseg_resp_retry_ratio_test)

  srio_ll_msg_mseg_req_seq msg_mseg_req_seq;
    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
     env_config1.ll_config.gen_resp_en_ratio      = 100;      
     env_config1.ll_config.gen_resp_dis_ratio     = 0;       
     env_config1.ll_config.resp_gen_mode          = RANDOM;  
     env_config1.ll_config.resp_done_ratio        = 50;             
     env_config1.ll_config.resp_retry_ratio       = 50; 
     env_config1.ll_config.resp_err_ratio         = 0; 
    msg_mseg_req_seq = srio_ll_msg_mseg_req_seq::type_id::create("msg_mseg_req_seq");
      phase.raise_objection( this );
     msg_mseg_req_seq.start( env2.e_virtual_sequencer);

      
   #20000ns;
    phase.drop_objection(this);
    
  endtask

  
endclass


