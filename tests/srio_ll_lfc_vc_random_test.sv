////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_lfc_vc_random_test.sv
// Project :  srio vip
// Purpose :  LFC Test 
// Author  :  Mobiveil
//
// Test for LFC.
// 1.Sending Normal packet with random priority and crf,vc as 1 .
// 2.Send LFC XOFF with the same random priority and crf,vc as 1.
// 3.send LFC XON with the same random priority and crf,vc as 1.
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_lfc_vc_random_test extends srio_base_test;

  `uvm_component_utils(srio_ll_lfc_vc_random_test)
  rand bit [1:0] pri;
  rand bit crf_2;
  bit vc_2;
  srio_ll_vc_lfc_user_gen_xoff_seq  ll_lfc_user_gen_xoff_seq;
  srio_ll_vc_lfc_user_gen_xon_seq   ll_lfc_user_gen_xon_seq;
  srio_ll_vc_user_gen_seq  ll_user_gen_seq;


  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction
    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    //configuration for multi vc support
    env_config1.multi_vc_support = 1;
    env_config2.multi_vc_support = 1;
    env_config1.vc_num_support = 1;
    env_config2.vc_num_support = 1;
    repeat(50) begin //{
    env1.tl_agent.tl_config.usr_sourceid_en = TRUE;
    env1.tl_agent.tl_config.usr_destinationid_en = TRUE;
    env1.tl_agent.tl_config.usr_sourceid = 32'h2;
    env1.tl_agent.tl_config.usr_destinationid = 32'h1;
    env2.tl_agent.tl_config.usr_sourceid_en = TRUE;
    env2.tl_agent.tl_config.usr_destinationid_en = TRUE;
    env2.tl_agent.tl_config.usr_sourceid = 32'h1;
    env2.tl_agent.tl_config.usr_destinationid = 32'h2;
    ll_lfc_user_gen_xoff_seq = srio_ll_vc_lfc_user_gen_xoff_seq::type_id::create("ll_lfc_user_gen_xoff_seq");
    ll_lfc_user_gen_xon_seq = srio_ll_vc_lfc_user_gen_xon_seq::type_id::create("ll_lfc_user_gen_xon_seq");
    ll_user_gen_seq = srio_ll_vc_user_gen_seq::type_id::create("ll_user_gen_seq");

    phase.raise_objection( this );
    pri = $urandom_range(32'd2,32'd0);
    crf_2 = $urandom;
    vc_2 = 1;
    fork 
    begin 
    
    ll_user_gen_seq.prior =pri ; 
    ll_user_gen_seq.crf_1 =crf_2;
    ll_user_gen_seq.vc_1 = vc_2;

    ll_user_gen_seq.start( env2.e_virtual_sequencer);
    end 
       begin
        wait (env2.ll_agent.ll_config.bfm_tx_pkt_cnt > 1);
        env2.ll_agent.ll_config.block_ll_traffic = TRUE;
        //XOFF
        ll_lfc_user_gen_xoff_seq.flowid = {pri,crf_2};
        ll_lfc_user_gen_xoff_seq.vc_1 = vc_2; 
        ll_lfc_user_gen_xoff_seq.start( env1.e_virtual_sequencer);
        #500ns;
        env2.ll_agent.ll_config.block_ll_traffic = FALSE;

       
         #500ns;

       //XON 
        ll_lfc_user_gen_xon_seq.flowid = {pri,crf_2};
        ll_lfc_user_gen_xon_seq.vc_1 = vc_2; 

        ll_lfc_user_gen_xon_seq.start( env1.e_virtual_sequencer);
        end

    join
    #5000ns;
       phase.drop_objection(this);
    end //}
  endtask

  
endclass
