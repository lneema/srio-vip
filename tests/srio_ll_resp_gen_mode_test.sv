////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_resp_gen_mode_test .sv
// Project :  srio vip
// Purpose :  Response gen_mode ratio
// Author  :  Mobiveil
//
// Test for NREAD request class for response gen_mode ratio with choosing DISABLED or RANDOM; 
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_resp_gen_mode_test extends srio_base_test;

  `uvm_component_utils(srio_ll_resp_gen_mode_test)
  rand bit mode;
  srio_ll_nread_req_seq nread_req_seq;
  //srio_ll_port_resp_timeout_reg_seq port_resp_timeout_reg_seq;
    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
     mode = $urandom;
     
     env1.ll_agent.ll_config.resp_gen_mode =  mode ? DISABLED : RANDOM ;
          
    nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");
   //port_resp_timeout_reg_seq = srio_ll_port_resp_timeout_reg_seq::type_id::create("port_resp_timeout_reg_seq");

     phase.raise_objection( this );


      //port_resp_timeout_reg_seq.start( env1.e_virtual_sequencer);

     nread_req_seq.start( env2.e_virtual_sequencer);
    
    #5000ns;
    phase.drop_objection(this);
    
  endtask

  
endclass


