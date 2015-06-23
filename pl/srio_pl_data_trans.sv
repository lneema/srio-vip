////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_data_trans.sv
// Project :  srio vip
// Purpose :  Physical Layer Data Transaction  
// Author  :  Mobiveil
//
// Physical Layer Data Transcaction component.
//
////////////////////////////////////////////////////////////////////////////////  

  class srio_pl_data_trans extends uvm_object;

 `uvm_object_utils(srio_pl_data_trans)

  merge_type m_type;

   bit link_req_en=0;
  
   bit link_resp_en=0;

   bit rst_frm_rty_en=0;

   bit cs_txt =0;

   bit brc3_en=0;

  logic  [0:8]  bs_merged_pkt[$];
  logic  [0:8]  bs_merged_cs[$];

  logic  [0:65] brc3_merged_pkt[$];
  logic  [0:65] brc3_merged_cs[$];
 
  extern function new(string name="srio_pl_data_trans");
  

  endclass : srio_pl_data_trans

  function srio_pl_data_trans::new(string name = "srio_pl_data_trans");
  super.new(name);
  endfunction : new
 
