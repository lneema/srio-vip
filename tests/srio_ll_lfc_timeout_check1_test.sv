////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_lfc_timeout_check1_test.sv
// Project :  srio vip
// Purpose :  LFC Test 
// Author  :  Mobiveil
//
// Test for LFC.
// 1.Sending Normal packet .
// 2.Send LFC XOFF With multiple .
// 3.send LFC XON with multiple with XOFF count lesser than XON flowid given.
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_lfc_timeout_check1_test extends srio_base_test;

  `uvm_component_utils(srio_ll_lfc_timeout_check1_test)

  srio_ll_lfc_user_gen_xoff_seq  ll_lfc_user_gen_xoff_seq;
  srio_ll_lfc_user_gen_xon_seq   ll_lfc_user_gen_xon_seq;
  srio_ll_user_gen_seq  ll_user_gen_seq;


  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

function void connect_phase(uvm_phase phase);
   super.connect_phase(phase);
    env1.tl_agent.tl_config.lfc_orphan_timer = 5000;
    env2.tl_agent.tl_config.lfc_orphan_timer = 5000;
    env1.ll_agent.ll_config.orph_xoff_timeout = 32'd800;
    env2.ll_agent.ll_config.orph_xoff_timeout = 32'd800;
endfunction : connect_phase

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
    
        ll_lfc_user_gen_xoff_seq = srio_ll_lfc_user_gen_xoff_seq::type_id::create("ll_lfc_user_gen_xoff_seq");
    ll_lfc_user_gen_xon_seq = srio_ll_lfc_user_gen_xon_seq::type_id::create("ll_lfc_user_gen_xon_seq");
    ll_user_gen_seq = srio_ll_user_gen_seq::type_id::create("ll_user_gen_seq");

    phase.raise_objection( this );
    fork 
    begin 
    
    ll_user_gen_seq.prior =2'b00;       //$urandom_range(32'd0,32'd2);
    ll_user_gen_seq.crf_1 =1'b0;      //$urandom;
    ll_user_gen_seq.start( env2.e_virtual_sequencer);
    end 
       begin
        wait (env2.ll_agent.ll_config.bfm_tx_pkt_cnt > 1);
        env2.ll_agent.ll_config.block_ll_traffic = TRUE;
        //XOFF
        ll_lfc_user_gen_xoff_seq.flowid = 7'd3;
        ll_lfc_user_gen_xoff_seq.start( env1.e_virtual_sequencer);
        #1000ns;
        env2.ll_agent.ll_config.block_ll_traffic = FALSE;

        
       

       //XON 
        ll_lfc_user_gen_xon_seq.flowid = 7'd3;
        ll_lfc_user_gen_xon_seq.start( env1.e_virtual_sequencer);
        #10ns;
        
        ll_lfc_user_gen_xon_seq.flowid = 7'd2;
        ll_lfc_user_gen_xon_seq.start( env1.e_virtual_sequencer);
        #10ns;


        ll_lfc_user_gen_xon_seq.flowid = 7'd1;
        ll_lfc_user_gen_xon_seq.start( env1.e_virtual_sequencer);
        #10ns;
            end

    join
    #50000ns;
       phase.drop_objection(this);
    
  endtask

  
endclass


