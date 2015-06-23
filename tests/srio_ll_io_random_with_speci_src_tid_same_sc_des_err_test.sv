////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_io_random_with_speci_src_tid_same_sc_des_err_test.sv
// Project :  srio vip
// Purpose :  IO Test 
// Author  :  Mobiveil
//
// Test for IO random packets with same SrcTID and same source and destination ID.
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_io_random_with_speci_src_tid_same_sc_des_err_test extends srio_base_test;

  `uvm_component_utils(srio_ll_io_random_with_speci_src_tid_same_sc_des_err_test)

  
  srio_ll_io_random_speci_src_tid_seq  ll_io_random_seq;
  srio_ll_src_tid_cb ll_src_tid_cb;

  function new(string name, uvm_component parent=null);
    super.new(name, parent);
    ll_src_tid_cb = new();
  endfunction

  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
    uvm_callbacks #(srio_logical_transaction_generator, srio_ll_src_tid_cb)::add(env1.ll_agent.ll_bfm.logical_transaction_generator, ll_src_tid_cb);
  endfunction
    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    //specific source and destination ID
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
    ll_io_random_seq = srio_ll_io_random_speci_src_tid_seq::type_id::create("ll_io_random_seq");
    phase.raise_objection( this );
`ifdef SRIO_VIP_B2B
      //Block the response packets for certain period 
      env2.ll_agent.ll_config.block_ll_traffic = TRUE;   
`endif
      ll_io_random_seq.start( env1.e_virtual_sequencer);
      #500ns;
`ifdef SRIO_VIP_B2B
      env2.ll_agent.ll_config.block_ll_traffic = FALSE; 
`endif
    #10000ns;  
    phase.drop_objection(this);
    
  endtask

endclass

