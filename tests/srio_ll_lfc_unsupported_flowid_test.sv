////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_lfc_unsupported_flowid_test.sv
// Project :  srio vip
// Purpose :  LFC Test 
// Author  :  Mobiveil
//
// Test for LFC with xoff in unsuported flowid and xon for a normal request packet
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_lfc_unsupported_flowid_test extends srio_base_test;

  `uvm_component_utils(srio_ll_lfc_unsupported_flowid_test)

  srio_ll_lfc_unsupport_flowid_seq  ll_lfc_unsupport_flowid_seq;
  srio_ll_lfc_user_gen_xon_seq   ll_lfc_user_gen_xon_seq;
  srio_ll_user_gen_seq  ll_user_gen_seq;
  rand bit flag;

  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);


    env1.tl_agent.tl_config.usr_sourceid_en = TRUE;
    env1.tl_agent.tl_config.usr_destinationid_en = TRUE;
    env1.tl_agent.tl_config.usr_sourceid = 32'h2;
    env1.tl_agent.tl_config.usr_destinationid = 32'h1;
    env2.tl_agent.tl_config.usr_sourceid_en = TRUE;
    env2.tl_agent.tl_config.usr_destinationid_en = TRUE;
    env2.tl_agent.tl_config.usr_sourceid = 32'h1;
    env2.tl_agent.tl_config.usr_destinationid = 32'h2;


    ll_lfc_unsupport_flowid_seq = srio_ll_lfc_unsupport_flowid_seq::type_id::create("ll_lfc_unsupport_flowid_seq");
    ll_lfc_user_gen_xon_seq = srio_ll_lfc_user_gen_xon_seq::type_id::create("ll_lfc_user_gen_xon_seq");
    ll_user_gen_seq = srio_ll_user_gen_seq::type_id::create("ll_user_gen_seq");

    phase.raise_objection( this );

     flag =$urandom;

    fork 
    begin 
      ll_user_gen_seq.prior = $urandom_range(32'h0,32'h2);
      ll_user_gen_seq.crf_1 = $urandom_range(32'h0,32'h1);
      ll_user_gen_seq.start( env2.e_virtual_sequencer);
    end 
    begin 
        wait (env2.ll_agent.ll_config.bfm_tx_pkt_cnt >1 ) ;
        env2.ll_agent.ll_config.block_ll_traffic = TRUE;
        ll_lfc_unsupport_flowid_seq.flowid = flag ? $urandom_range(32'd6,32'd64) :$urandom_range(32'd73,32'd127); 
        ll_lfc_unsupport_flowid_seq.start( env1.e_virtual_sequencer);
        #100ns;
        env2.ll_agent.ll_config.block_ll_traffic = FALSE;
        ll_lfc_user_gen_xon_seq.flowid = 7'd0;
        ll_lfc_user_gen_xon_seq.start( env1.e_virtual_sequencer);
    end
      join 
    #5000ns;	
    
       phase.drop_objection(this);
    
  endtask

  
endclass


