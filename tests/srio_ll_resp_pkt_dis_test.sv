////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_resp_pkt_dis_test.sv
// Project :  srio vip
// Purpose :  NREAD
// Author  :  Mobiveil
//
// Test for NREAD request class
// used trans_received callback to disable ll packet response w.r.t SrcTID
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_resp_pkt_dis_test extends srio_base_test;

  `uvm_component_utils(srio_ll_resp_pkt_dis_test)

  srio_ll_nread_req_seq nread_req_seq;
  srio_ll_rx_resp_pkt_dis_cb  ll_rx_resp_pkt_dis_cb;
    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
    ll_rx_resp_pkt_dis_cb = new ();
  endfunction


 function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
    
    uvm_callbacks #(srio_packet_handler, srio_ll_rx_resp_pkt_dis_cb)::add(env2.ll_agent.ll_bfm.packet_handler,ll_rx_resp_pkt_dis_cb );

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


