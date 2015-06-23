////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_msg_max_resp_delay_test.sv
// Project :  srio vip
// Purpose :  Base test
// Author  :  Mobiveil
//
// Data Message with Maximum payload and configured response delay.
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_msg_max_resp_delay_test extends srio_base_test;

  `uvm_component_utils(srio_ll_msg_max_resp_delay_test)
   srio_ll_msg_mseg_max_req_seq ll_msg_mseg_max_req_seq;
  
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction
 
    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    //Configuration of message response delay with maximum values
     env2.ll_agent.ll_config.resp_gen_mode         = RANDOM;  
     env2.ll_agent.ll_config.resp_delay_min        = 3000;                
     env2.ll_agent.ll_config.resp_delay_max         = 5000;  

    ll_msg_mseg_max_req_seq = srio_ll_msg_mseg_max_req_seq::type_id::create("ll_msg_mseg_max_req_seq"); 
    phase.raise_objection( this );
    //MSG Packet
    ll_msg_mseg_max_req_seq.start( env1.e_virtual_sequencer);
    #5000ns;
 
    phase.drop_objection(this);
    
  endtask

endclass
