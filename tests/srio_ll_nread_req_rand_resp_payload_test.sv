////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_nread_req_rand_resp_payload_test.sv
// Project :  srio vip
// Purpose :  NREAD
// Author  :  Mobiveil
//
// Test for NREAD request class with random response payload value
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_nread_req_rand_resp_payload_test extends srio_base_test;

  `uvm_component_utils(srio_ll_nread_req_rand_resp_payload_test)

  srio_ll_nread_req_seq nread_req_seq;
   srio_ll_resp_with_rand_pld_cb ll_resp_with_rand_pld_cb;
    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
    ll_resp_with_rand_pld_cb = new();
  endfunction

  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
    
    uvm_callbacks #(srio_logical_transaction_generator, srio_ll_resp_with_rand_pld_cb)::add(env2.ll_agent.ll_bfm.logical_transaction_generator, ll_resp_with_rand_pld_cb);

  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
       
    nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");

     phase.raise_objection( this );
       nread_req_seq.start( env1.e_virtual_sequencer);
    #2000ns;
 
    phase.drop_objection(this);
    
  endtask

  
endclass


