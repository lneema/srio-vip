///////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_vc_support_swrite_nwrite_lfc_xoff_xon_test.sv
// Project :  srio vip
// Purpose :  Multi VC support for swrite and nwrite
// Author  :  Mobiveil
//
// 1.Test for multi VC support for nwrite and swrite packets
// 2. Send XOFF and XON for VC's.
////////////////////////////////////////////////////////////////////////////////

class srio_ll_vc_support_swrite_nwrite_lfc_xoff_xon_test extends srio_base_test;

  `uvm_component_utils(srio_ll_vc_support_swrite_nwrite_lfc_xoff_xon_test)
  rand bit [1:0] prio_2,mode;
  rand bit crf_2;
  rand bit vc_2,sel;
  rand int support;
  srio_ll_multi_vc_nwrite_swrite_seq ll_multi_vc_nwrite_swrite_seq;
  srio_ll_vc_lfc_xoff_seq ll_vc_lfc_xoff_seq;
  srio_ll_vc_lfc_xon_seq ll_vc_lfc_xon_seq;  
  function new(string name, uvm_component parent=null);
    super.new(name,parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
      mode = $urandom_range(32'd3,32'd0);
      sel = $urandom;
      vc_2 = 1; 
      env_config1.multi_vc_support = vc_2;
      env_config2.multi_vc_support = vc_2;
      
      case(mode) //{
      2'b00 : begin support = 1; prio_2 = 2'b00; crf_2 = 1'b1; end    
      2'b01 : begin support = 2; prio_2 = sel ? 2'b00 : 2'b10; crf_2 = 1'b1; end    
      2'b10 : begin support = 4; prio_2 = $urandom_range(32'd3,32'd0); crf_2 = 1'b1; end    
      2'b11 : begin support = 8; prio_2 = $urandom_range(32'd3,32'd0); crf_2 = $urandom_range(32'd1,32'd0); end 
      endcase //}   
      env_config1.vc_num_support = support;
      env_config2.vc_num_support = support;

    env1.tl_agent.tl_config.usr_sourceid_en = TRUE;
    env1.tl_agent.tl_config.usr_destinationid_en = TRUE;
    env1.tl_agent.tl_config.usr_sourceid = 32'h1;
    env1.tl_agent.tl_config.usr_destinationid = 32'h2;
    env2.tl_agent.tl_config.usr_sourceid_en = TRUE;
    env2.tl_agent.tl_config.usr_destinationid_en = TRUE;
    env2.tl_agent.tl_config.usr_sourceid = 32'h2;
    env2.tl_agent.tl_config.usr_destinationid = 32'h1;

     
    ll_multi_vc_nwrite_swrite_seq = srio_ll_multi_vc_nwrite_swrite_seq::type_id::create("ll_multi_vc_nwrite_swrite_seq");
   ll_vc_lfc_xoff_seq = srio_ll_vc_lfc_xoff_seq::type_id::create("ll_vc_lfc_xoff_seq");
   ll_vc_lfc_xon_seq  = srio_ll_vc_lfc_xon_seq ::type_id::create("ll_vc_lfc_xon_seq");
      
      phase.raise_objection( this );
     
      fork //{
      begin //{
      ll_multi_vc_nwrite_swrite_seq.prio_1 = prio_2;
      ll_multi_vc_nwrite_swrite_seq.crf_1 = crf_2;
      ll_multi_vc_nwrite_swrite_seq.vc_1 = vc_2;
      ll_multi_vc_nwrite_swrite_seq.start( env2.e_virtual_sequencer);
      end //}
      begin //{
      wait (env2.ll_agent.ll_config.bfm_tx_pkt_cnt > 1);
      env2.ll_agent.ll_config.block_ll_traffic = TRUE;
      ll_vc_lfc_xoff_seq.vc_1 = vc_2;      // LFC XOFF
      ll_vc_lfc_xoff_seq.flowid = {4'b1000,prio_2,crf_2};
      ll_vc_lfc_xoff_seq.start( env1.e_virtual_sequencer);
      #500ns;
      env2.ll_agent.ll_config.block_ll_traffic = FALSE;
      #500ns;
      ll_vc_lfc_xon_seq.vc_1 = vc_2;      // LFC XON
      ll_vc_lfc_xon_seq.flowid = {4'b1000,prio_2,crf_2};
      ll_vc_lfc_xon_seq.start( env1.e_virtual_sequencer);
      end //}
      join //}


      #20000ns;
      phase.drop_objection(this);
   endtask

endclass


