
////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_pl_clck_comp_code_group_cs_test .sv
// Project :  srio vip
// Purpose :  Compensation rate and code groups.
// Author  :  Mobiveil
//
// 1.Compensation rate changed and code groups changed.
// Test for NREAD request class
//Supported by only Gen2 mode
//
////////////////////////////////////////////////////////////////////////////////

class srio_pl_clck_comp_code_group_cs_test extends srio_base_test;

  `uvm_component_utils(srio_pl_clck_comp_code_group_cs_test)

  srio_ll_nread_req_seq nread_req_seq;

    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction
 

    task run_phase( uvm_phase phase );
    super.run_phase(phase);

   env1.pl_agent.pl_config.clk_compensation_seq_rate = 2000;
   env1.pl_agent.pl_config.code_group_sent_2_cs = 200;
`ifdef SRIO_VIP_B2B
   env2.pl_agent.pl_config.clk_compensation_seq_rate = 2500;
   env2.pl_agent.pl_config.code_group_sent_2_cs = 220;
`endif

   nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");

     phase.raise_objection( this );
     nread_req_seq.start( env1.e_virtual_sequencer);
    #2000ns;
 
    phase.drop_objection(this);
    
  endtask

  
endclass


