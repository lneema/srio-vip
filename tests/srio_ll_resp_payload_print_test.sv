////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_resp_payload_print_test.sv
// Project :  srio vip
// Purpose : NWRITE_R AND NREAD_R with response payload print callback
// Author  :  Mobiveil
//
// NWRITE_R AND NREAD_R  with response payload print callback
//
////////////////////////////////////////////////////////////////////////////////


class srio_ll_resp_payload_print_test extends srio_base_test;

  `uvm_component_utils(srio_ll_resp_payload_print_test)

  srio_ll_nwrite_nread_pld_print_cb_vseq nwrite_r_reg_seq;
  srio_ll_resp_payload_print_cb ll_resp_payload_print_cb;
   
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
    ll_resp_payload_print_cb = new();
  endfunction

  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
    uvm_callbacks #(srio_logical_transaction_generator, srio_ll_resp_payload_print_cb)::add(env2.ll_agent.ll_bfm.logical_transaction_generator, ll_resp_payload_print_cb);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    nwrite_r_reg_seq = srio_ll_nwrite_nread_pld_print_cb_vseq::type_id::create("nwrite_r_reg_seq");
      phase.raise_objection( this );
     nwrite_r_reg_seq.start( env1.e_virtual_sequencer);

      
  #20000ns;

    phase.drop_objection(this);
    
  endtask
endclass


