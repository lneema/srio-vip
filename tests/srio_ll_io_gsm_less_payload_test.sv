////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_io_gsm_less_payload_test.sv
// Project :  srio vip
// Purpose :  IO and GSM test
// Author  :  Mobiveil
//
// Callback test for IO and GSM packet with lesser payload w.r.t wrsize
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_io_gsm_less_payload_test extends srio_base_test;

  `uvm_component_utils(srio_ll_io_gsm_less_payload_test)

   srio_ll_tx_lesser_payload_cb ll_tx_cb_ins;
   srio_ll_io_random_seq ll_io_random_seq;
   srio_ll_gsm_random_seq gsm_random_seq;

  function new(string name, uvm_component parent=null);
    super.new(name, parent);
    ll_tx_cb_ins = new();
  endfunction

  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
       uvm_callbacks #(srio_logical_transaction_generator, srio_ll_tx_lesser_payload_cb)::add(env1.ll_agent.ll_bfm.logical_transaction_generator, ll_tx_cb_ins);

  endfunction

      
    task run_phase( uvm_phase phase );
    super.run_phase(phase);

     ll_io_random_seq = srio_ll_io_random_seq::type_id::create("ll_io_random_seq");
     gsm_random_seq = srio_ll_gsm_random_seq::type_id::create("gsm_random_seq");

     phase.raise_objection( this );
     ll_io_random_seq.start( env1.e_virtual_sequencer);
     gsm_random_seq.start( env1.e_virtual_sequencer);
    #20000ns;
     phase.drop_objection(this);
    
  endtask


endclass

