
////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_msg_mseg_req_with_lastseg_err_test.sv
// Project :  srio vip
// Purpose :  Message single segment sequences 
// Author  :  Mobiveil
//
//// Multi Segment Message Packet with last segment is non-multiple of 8B
////////////////////////////////////////////////////////////////////////////////

class srio_ll_msg_mseg_req_with_lastseg_err_test extends srio_base_test;

  `uvm_component_utils(srio_ll_msg_mseg_req_with_lastseg_err_test)
   srio_ll_msg_mseg_req_with_err_seq ll_msg_mseg_req_with_err_seq;
   srio_ll_tx_msg_lstseg_err_cb ll_tx_msg_lstseg_err_cb;
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
    ll_tx_msg_lstseg_err_cb = new();
  endfunction

 function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
    
    uvm_callbacks #(srio_logical_transaction_generator, srio_ll_tx_msg_lstseg_err_cb)::add(env1.ll_agent.ll_bfm.logical_transaction_generator, ll_tx_msg_lstseg_err_cb);

  endfunction


    task run_phase( uvm_phase phase );
    super.run_phase(phase);


     ll_msg_mseg_req_with_err_seq = srio_ll_msg_mseg_req_with_err_seq::type_id::create("ll_msg_mseg_req_with_err_seq"); 
     phase.raise_objection( this );
     ll_msg_mseg_req_with_err_seq.start( env1.e_virtual_sequencer);
      
   #10000ns;
    phase.drop_objection(this);
    
  endtask



endclass


