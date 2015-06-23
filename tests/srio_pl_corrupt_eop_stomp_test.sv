////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_pl_corrupt_eop_stomp_test .sv
// Project :  srio vip
// Purpose :  NREAD
// Author  :  Mobiveil
//
// Test for Corrupt EOP with STOMP
// supportd for GEN1 GEN2 and GEN3
// Increase number of ll_nread pkts
//
////////////////////////////////////////////////////////////////////////////////

class srio_pl_corrupt_eop_stomp_test extends srio_base_test;

  `uvm_component_utils(srio_pl_corrupt_eop_stomp_test)

  srio_ll_nread_req_num_pkt_seq nread_req_seq;
  srio_pl_transmit_eop_to_stomp_cs_cb  pl_transmit_eop_to_stomp_cs_cb;
  srio_pl_gen1_transmit_eop_to_stomp_cs_cb  pl_gen1_transmit_eop_to_stomp_cs_cb;
  srio_pl_gen3_transmit_eop_to_stomp_cs_cb  pl_gen3_transmit_eop_to_stomp_cs_cb;
    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
   pl_transmit_eop_to_stomp_cs_cb = new();
   pl_gen1_transmit_eop_to_stomp_cs_cb = new();
   pl_gen3_transmit_eop_to_stomp_cs_cb = new();
  endfunction

  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
    if(env_config1.srio_mode == SRIO_GEN13)
    uvm_callbacks #(srio_pl_idle_gen,srio_pl_gen1_transmit_eop_to_stomp_cs_cb )::add(env1.pl_agent.pl_driver.idle_gen,pl_gen1_transmit_eop_to_stomp_cs_cb);

    if((env_config1.srio_mode == SRIO_GEN21) || (env_config1.srio_mode == SRIO_GEN22))
    uvm_callbacks #(srio_pl_idle_gen,srio_pl_transmit_eop_to_stomp_cs_cb )::add(env1.pl_agent.pl_driver.idle_gen,pl_transmit_eop_to_stomp_cs_cb);
    if(env_config1.srio_mode == SRIO_GEN30)
    uvm_callbacks #(srio_pl_idle_gen,srio_pl_gen3_transmit_eop_to_stomp_cs_cb )::add(env1.pl_agent.pl_driver.idle_gen,pl_gen3_transmit_eop_to_stomp_cs_cb);
   endfunction

  task run_phase( uvm_phase phase );
    super.run_phase(phase);
    nread_req_seq = srio_ll_nread_req_num_pkt_seq::type_id::create("nread_req_seq");
    phase.raise_objection( this );
    nread_req_seq.num_pkt = 200;
    nread_req_seq.start( env1.e_virtual_sequencer);
    #20000ns;
    phase.drop_objection(this);
  endtask

  
endclass


