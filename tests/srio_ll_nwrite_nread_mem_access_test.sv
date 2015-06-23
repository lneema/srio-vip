////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_nwrite_nread_mem_access_test.sv
// Project :  srio vip
// Purpose : NWRITE_R AND NREAD_R for sparse memory acess
// Author  :  Mobiveil
//
// NWRITE_R AND NREAD_R for sparse memory acess
//
////////////////////////////////////////////////////////////////////////////////


class srio_ll_nwrite_nread_mem_access_test extends srio_base_test;

  `uvm_component_utils(srio_ll_nwrite_nread_mem_access_test)

  srio_ll_nwrite_nread_mem_access_seq nwrite_r_reg_seq;
    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);

    env1.tl_agent.tl_config.usr_sourceid_en = TRUE;
    env1.tl_agent.tl_config.usr_destinationid_en = TRUE;
    env1.tl_agent.tl_config.usr_sourceid = 32'h2;
    env1.tl_agent.tl_config.usr_destinationid = 32'h1;
`ifdef SRIO_VIP_B2B
    env2.tl_agent.tl_config.usr_sourceid_en = TRUE;
    env2.tl_agent.tl_config.usr_destinationid_en = TRUE;
    env2.tl_agent.tl_config.usr_sourceid = 32'h1;
    env2.tl_agent.tl_config.usr_destinationid = 32'h2;
`endif

    nwrite_r_reg_seq = srio_ll_nwrite_nread_mem_access_seq::type_id::create("nwrite_r_reg_seq");
      phase.raise_objection( this );
     nwrite_r_reg_seq.start( env1.e_virtual_sequencer);

      
  #20000ns;

    phase.drop_objection(this);
    
  endtask
endclass


