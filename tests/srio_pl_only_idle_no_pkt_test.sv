////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_pl_only_idle_no_pkt_test.sv
// Project :  srio vip
// Purpose :  NREAD
// Author  :  Mobiveil
//
// Test for Generating IDLE sequence alone
//
////////////////////////////////////////////////////////////////////////////////

class srio_pl_only_idle_no_pkt_test extends srio_base_test;

  `uvm_component_utils(srio_pl_only_idle_no_pkt_test)
  rand bit [31:0] cs_to_sent;
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

  task run_phase( uvm_phase phase );
  super.run_phase(phase);
   phase.raise_objection( this );
   cs_to_sent = $urandom_range(100,1024);
   env1.pl_agent.pl_config.code_group_sent_2_cs = cs_to_sent; 
   #100000ns;
  phase.drop_objection(this);
  endtask
  
endclass


