
////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_nwrite_max_byte_err_test .sv
// Project :  srio vip
// Purpose :  Nwrite_r
// Author  :  Mobiveil
//
// Test for NWRITE request class with maximum payload size more than 256 bytes
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_nwrite_max_byte_err_test extends srio_base_test;

  `uvm_component_utils(srio_ll_nwrite_max_byte_err_test)

  srio_ll_nwrite_max_pkt_size_class_vseq nwrite_req_seq;
  srio_ll_nwrite_max_pld_err_cb ll_nwrite_max_pld_err_cb;
    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
    ll_nwrite_max_pld_err_cb = new();
  endfunction

  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
    
    uvm_callbacks #(srio_logical_transaction_generator, srio_ll_nwrite_max_pld_err_cb)::add(env1.ll_agent.ll_bfm.logical_transaction_generator, ll_nwrite_max_pld_err_cb);

  endfunction
    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    nwrite_req_seq = srio_ll_nwrite_max_pkt_size_class_vseq::type_id::create("nwrite_req_seq");
    phase.raise_objection( this );
    nwrite_req_seq.start( env1.e_virtual_sequencer);
    #20000ns;
    nwrite_req_seq.start( env1.e_virtual_sequencer);
    #20000ns;

    phase.drop_objection(this);
    
  endtask


endclass

