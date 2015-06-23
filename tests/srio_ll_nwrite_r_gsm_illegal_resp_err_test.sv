////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_nwrite_r_gsm_illegal_resp_err_test.sv
// Project :  srio vip
// Purpose :  Base test
// Author  :  Mobiveil
//
// Callback test with corrupted ftype and ttype test
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_nwrite_r_gsm_illegal_resp_err_test extends srio_base_test;

  `uvm_component_utils(srio_ll_nwrite_r_gsm_illegal_resp_err_test)

   srio_ll_nwrite_r_req_seq ll_req_seq;
   srio_ll_gsm_pkt_for_illegal_resp_req_seq ll_gsm_seq;
   srio_ll_nwrite_r_resp_corrupt_ttype_cb ll_tx_cb_ins;

  function new(string name, uvm_component parent=null);
    super.new(name, parent);
    ll_tx_cb_ins = new();
  endfunction
  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
    uvm_callbacks #(srio_logical_transaction_generator, srio_ll_nwrite_r_resp_corrupt_ttype_cb)::add(env1.ll_agent.ll_bfm.logical_transaction_generator, ll_tx_cb_ins);
  endfunction
      
    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    ll_req_seq = srio_ll_nwrite_r_req_seq::type_id::create("ll_req_seq");
    ll_gsm_seq = srio_ll_gsm_pkt_for_illegal_resp_req_seq::type_id::create("ll_gsm_seq");
     phase.raise_objection( this );
     ll_req_seq.start( env2.e_virtual_sequencer);
     ll_gsm_seq.start( env2.e_virtual_sequencer);
    #20000ns;
    phase.drop_objection(this);
  endtask

endclass


