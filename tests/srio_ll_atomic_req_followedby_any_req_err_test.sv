////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_atomic_req_followedby_any_req_err_test.sv
// Project : srio vip
// Purpose : Atomic request followed by any other request 
// Author  : Mobiveil
//
// Atomic request followed by any other request to the same address
//
////////////////////////////////////////////////////////////////////////////////


class srio_ll_atomic_req_followedby_any_req_err_test extends srio_base_test;

  `uvm_component_utils(srio_ll_atomic_req_followedby_any_req_err_test)

  srio_ll_atomic_req_with_addr_seq atomic_req_seq;
  srio_ll_req_with_addr_seq ll_req_seq;
 
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
    atomic_req_seq = srio_ll_atomic_req_with_addr_seq::type_id::create("atomic_req_seq");
    ll_req_seq = srio_ll_req_with_addr_seq::type_id::create("ll_req_seq");
    phase.raise_objection( this );
`ifdef SRIO_VIP_B2B
    env2.ll_agent.ll_config.block_ll_traffic = TRUE;
`endif
    //Unacknowledged Atomic request followed by any request 
    fork 
      atomic_req_seq.start(env1.e_virtual_sequencer);
      begin
      #2ns;
      ll_req_seq.start(env1.e_virtual_sequencer);
      end
    join  
    #500ns;
`ifdef SRIO_VIP_B2B
        env2.ll_agent.ll_config.block_ll_traffic = FALSE;
`endif
    #20000ns;
    phase.drop_objection(this);
    
  endtask

  
endclass

