////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_func_coverage.sv
// Project :  srio vip
// Purpose :  Logical Layer Functional Coverage
// Author  :  Mobiveil
//
// Contains LL layer related coverpoints.
// 
//////////////////////////////////////////////////////////////////////////////// 
typedef enum {A, B, C, D, E, F} trans_priority; ///< transaction priority

class srio_ll_func_coverage extends uvm_component;

  `uvm_component_utils(srio_ll_func_coverage)
  
  virtual srio_interface srio_if;
  srio_env_config env_config;
  srio_ll_agent ll_agent;
  srio_trans tx_trans; ///< transactions in tx path
  srio_trans rx_trans; ///< transactions in rx path

  srio_ll_tx_trans_collector tx_trans_collector;
  srio_ll_rx_trans_collector rx_trans_collector;

  event      tx_trans_event, rx_trans_event;

  srio_trans tx_trans_list[int]; ///< index is SrcTID
  srio_trans rx_trans_list[int]; ///< index is targetID_Info
  trans_priority tx_req_priority;
  trans_priority rx_req_priority;
  trans_priority tx_resp_priority;
  trans_priority rx_resp_priority;
  int tx_wr_trans_size;
  int tx_rd_trans_size;
  int rx_wr_trans_size;
  int rx_rd_trans_size;
  bit tx_invalid_payload_len;
  bit tx_msg_out_of_order;
  bit tx_msg_interleave;
  bit rx_msg_out_of_order;
  bit rx_msg_interleave;
  int tx_msg_open[*];
  int tx_msg_total_len[*];
  int tx_msg_rcvd_size[*];
  int rx_msg_open[*];
  int rx_msg_total_len[*];
  int rx_msg_rcvd_size[*];
  int tx_payload_size;
  int rx_payload_size;
  bit tx_io_error_resp;
  bit sim_clk;
  bit tx_msg_invalid_size;
  bit tx_msg_invalid_seg;
  bit msg_req_timeout;
  bit resp_timeout;
  bit unexp_response;
  bit tx_ds_pkt_interleave;
  bit rx_ds_pkt_interleave;
  int tx_ds_pkt_open[*];
  int rx_ds_pkt_open[*];
  bit tx_single_pdu_pipeline;
  bit tx_multi_pdu_pipeline;
  bit rx_single_pdu_pipeline;
  bit rx_multi_pdu_pipeline;

  bit [3:0] rx_nread_resp_type;
  bit [3:0] rx_nread_resp_status;
  bit [3:0] rx_atomic_inc_resp_type;
  bit [3:0] rx_atomic_inc_resp_status;
  bit [3:0] rx_atomic_dec_resp_type;
  bit [3:0] rx_atomic_dec_resp_status;
  bit [3:0] rx_atomic_set_resp_type;
  bit [3:0] rx_atomic_set_resp_status;
  bit [3:0] rx_atomic_clr_resp_type;
  bit [3:0] rx_atomic_clr_resp_status;
  bit [3:0] rx_atomic_swap_resp_type;
  bit [3:0] rx_atomic_swap_resp_status;
  bit [3:0] rx_atomic_comp_resp_type;
  bit [3:0] rx_atomic_comp_resp_status;
  bit [3:0] rx_atomic_test_resp_type;
  bit [3:0] rx_atomic_test_resp_status;
  bit [3:0] rx_nwrite_r_resp_type;
  bit [3:0] rx_nwrite_r_resp_status;
  bit [3:0] rx_doorbell_resp_type;
  bit [3:0] rx_doorbell_resp_status;
  bit [3:0] rx_msg_resp_type;
  bit [3:0] rx_msg_resp_status;
  bit [7:0] rx_msg_resp_tgt_tid;
  bit [3:0] rx_gsm_resp_type;
  bit [3:0] rx_gsm_resp_status;
  bit [3:0] tx_gsm_resp_type;
  bit [3:0] tx_gsm_resp_status;
  bit [3:0] rx_gsm_rd_o_resp_type;
  bit [3:0] rx_gsm_rd_o_resp_status;
  bit [3:0] rx_gsm_rd_o_o_resp_type;
  bit [3:0] rx_gsm_rd_o_o_resp_status;
  bit [3:0] rx_gsm_io_rd_o_resp_type;
  bit [3:0] rx_gsm_io_rd_o_resp_status;
  bit [3:0] rx_gsm_rd_h_resp_type;
  bit [3:0] rx_gsm_rd_h_resp_status;
  bit [3:0] rx_gsm_rd_o_h_resp_type;
  bit [3:0] rx_gsm_rd_o_h_resp_status;
  bit [3:0] rx_gsm_io_rd_h_resp_type;
  bit [3:0] rx_gsm_io_rd_h_resp_status;
  bit [3:0] rx_gsm_d_h_resp_type;
  bit [3:0] rx_gsm_d_h_resp_status;
  bit [3:0] rx_gsm_i_h_resp_type;
  bit [3:0] rx_gsm_i_h_resp_status;
  bit [3:0] rx_gsm_tlbie_resp_type;
  bit [3:0] rx_gsm_tlbie_resp_status;
  bit [3:0] rx_gsm_tlbsync_resp_type;
  bit [3:0] rx_gsm_tlbsync_resp_status;
  bit [3:0] rx_gsm_ird_h_resp_type;
  bit [3:0] rx_gsm_ird_h_resp_status;
  bit [3:0] rx_gsm_flush_wo_d_resp_type;
  bit [3:0] rx_gsm_flush_wo_d_resp_status;
  bit [3:0] rx_gsm_ik_sh_resp_type;
  bit [3:0] rx_gsm_ik_sh_resp_status;
  bit [3:0] rx_gsm_dk_sh_resp_type;
  bit [3:0] rx_gsm_dk_sh_resp_status;
  bit [3:0] rx_gsm_castout_resp_type;
  bit [3:0] rx_gsm_castout_resp_status;
  bit [3:0] rx_gsm_flush_wd_resp_type;
  bit [3:0] rx_gsm_flush_wd_resp_status;
  bit [3:0] tx_nread_resp_type;
  bit [3:0] tx_nread_resp_status;
  bit [3:0] tx_atomic_inc_resp_type;
  bit [3:0] tx_atomic_inc_resp_status;
  bit [3:0] tx_atomic_dec_resp_type;
  bit [3:0] tx_atomic_dec_resp_status;
  bit [3:0] tx_atomic_set_resp_type;
  bit [3:0] tx_atomic_set_resp_status;
  bit [3:0] tx_atomic_clr_resp_type;
  bit [3:0] tx_atomic_clr_resp_status;
  bit [3:0] tx_atomic_swap_resp_type;
  bit [3:0] tx_atomic_swap_resp_status;
  bit [3:0] tx_atomic_comp_resp_type;
  bit [3:0] tx_atomic_comp_resp_status;
  bit [3:0] tx_atomic_test_resp_type;
  bit [3:0] tx_atomic_test_resp_status;
  bit [3:0] tx_nwrite_r_resp_type;
  bit [3:0] tx_nwrite_r_resp_status;
  bit [3:0] tx_doorbell_resp_type;
  bit [3:0] tx_doorbell_resp_status;
  bit [3:0] tx_msg_resp_type;
  bit [3:0] tx_msg_resp_status;
  bit [7:0] tx_msg_resp_tgt_tid;
  bit [3:0] tx_gsm_rd_o_resp_type;
  bit [3:0] tx_gsm_rd_o_resp_status;
  bit [3:0] tx_gsm_rd_o_o_resp_type;
  bit [3:0] tx_gsm_rd_o_o_resp_status;
  bit [3:0] tx_gsm_io_rd_o_resp_type;
  bit [3:0] tx_gsm_io_rd_o_resp_status;
  bit [3:0] tx_gsm_rd_h_resp_type;
  bit [3:0] tx_gsm_rd_h_resp_status;
  bit [3:0] tx_gsm_rd_o_h_resp_type;
  bit [3:0] tx_gsm_rd_o_h_resp_status;
  bit [3:0] tx_gsm_io_rd_h_resp_type;
  bit [3:0] tx_gsm_io_rd_h_resp_status;
  bit [3:0] tx_gsm_d_h_resp_type;
  bit [3:0] tx_gsm_d_h_resp_status;
  bit [3:0] tx_gsm_i_h_resp_type;
  bit [3:0] tx_gsm_i_h_resp_status;
  bit [3:0] tx_gsm_tlbie_resp_type;
  bit [3:0] tx_gsm_tlbie_resp_status;
  bit [3:0] tx_gsm_tlbsync_resp_type;
  bit [3:0] tx_gsm_tlbsync_resp_status;
  bit [3:0] tx_gsm_ird_h_resp_type;
  bit [3:0] tx_gsm_ird_h_resp_status;
  bit [3:0] tx_gsm_flush_wo_d_resp_type;
  bit [3:0] tx_gsm_flush_wo_d_resp_status;
  bit [3:0] tx_gsm_ik_sh_resp_type;
  bit [3:0] tx_gsm_ik_sh_resp_status;
  bit [3:0] tx_gsm_dk_sh_resp_type;
  bit [3:0] tx_gsm_dk_sh_resp_status;
  bit [3:0] tx_gsm_castout_resp_type;
  bit [3:0] tx_gsm_castout_resp_status;
  bit [3:0] tx_gsm_flush_wd_resp_type;
  bit [3:0] tx_gsm_flush_wd_resp_status;
  
  bit [7:0] mtu_size;
  
  logic [4:0] address;
  bit wnr;
  bit Nread;
  bit nwrite;
  bit Write_with_response;
  bit Streaming_write;
  bit Atomic_swap;
  bit Atomic_clear;
  bit Atomic_set;
  bit Atomic_decrement;
  bit Atomic_increment;
  bit Atomic_test_and_swap;
  bit Atomic_compare_and_swap;
  bit Port_write;
  bit Data_Message;
  bit Doorbell;
  bit Read;
  bit Instruction_read;
  bit Read_for_ownership;
  bit Data_cache_invalidate;
  bit Castout;
  bit TLB_invalidate_entry;
  bit TLB_invalidate_entry_sync;
  bit Instruction_cache_invalidate;
  bit Data_cache_flush;
  bit IO_read;
  
  covergroup CG_LL_TX_PATH @(tx_trans_event);
    option.per_instance = 1;
    CP_LL_TX_TXN_ID: coverpoint tx_trans.SrcTID
                     {
                       bins low_range = {[0:50]};
                       bins mid_range = {[51:150]};
                       bins high_range = {[151:255]};
                     }
    CP_LL_TX_ATOMIC_TYPES :  
                     coverpoint tx_trans.ttype
                     { 
                       bins type2_atomic[] =  {12, 13, 14, 15} iff (tx_trans.ftype == 2);
                       bins type5_atomic[] =  {12, 13, 14}     iff (tx_trans.ftype == 5);
                     }
    CP_LL_TX_FTYPE:  coverpoint tx_trans.ftype
                     {
                       bins ftype[] = {1, 2, 5, 6, 7, 8, 9, 10, 11, 13};
                     }
    CP_LL_TX_TTYPE:  coverpoint tx_trans.ttype
                     {
                       bins ttype[] = {[0:15]};
                     }
    CP_LL_TX_TYPE2_TTYPE : 
                     coverpoint tx_trans.ttype
                     {
                       bins type2_ttype[] = {4, 12, 13, 14, 15} iff (tx_trans.ftype == 2);
                     }
    CP_LL_TX_TYPE5_TTYPE : 
                     coverpoint tx_trans.ttype
                     {
                       bins type5_ttype[] = {4, 5,12, 13, 14} iff (tx_trans.ftype == 5);
                     }
    CP_LL_TX_NREAD_RESP_TYPE : coverpoint tx_nread_resp_type
                               {
                                 bins resp_type[] = {0, 8};
                               }
    CP_LL_TX_NWRITE_R_RESP_TYPE : coverpoint tx_nwrite_r_resp_type
                                  {
                                    bins resp_type[] = {0, 8};
                                  }
    CP_LL_TX_NREAD_RESP_STATUS : coverpoint tx_nread_resp_status
                                 {
                                   bins resp_status[] = {0, 7};
                                 }
    CP_LL_TX_NWRITE_R_RESP_STATUS : coverpoint tx_nwrite_r_resp_status
                                    {
                                      bins resp_status[] = {0, 7};
                                    }
    CP_LL_TX_TYPE8_TTYPE : coverpoint tx_trans.ttype
                     {
                       bins type8_ttype[] = {[0:4]} iff (tx_trans.ftype == 8);
                     }
    CP_LL_TX_TYPE10_TTYPE : coverpoint tx_trans.ttype
                     {
                       bins type10_ttype = {0} iff (tx_trans.ftype == 10);
                     }
    CP_LL_TX_TYPE11_TTYPE : coverpoint tx_trans.ttype
                     {
                       bins type11_ttype = {0} iff (tx_trans.ftype == 11);
                     }
    CP_LL_TX_TYPE13_TTYPE : coverpoint tx_trans.ttype
                     {
                       bins type13_ttype[] = {0, 1, 8} iff (tx_trans.ftype == 13);
                     }
    CP_LL_TX_MAINT_PRIORITY : coverpoint tx_trans.prio
                              {
                                bins maint_prio_crf0[] = {[0:2]} iff (tx_trans.crf==0 && tx_trans.ftype==8 && (tx_trans.ttype==0 || tx_trans.ttype==1));
                                bins maint_prio_crf1[] = {[0:2]} iff (tx_trans.crf==1 && tx_trans.ftype==8 && (tx_trans.ttype==0 || tx_trans.ttype==1));
                              }
    CP_LL_TX_MAINT_PRIORITY_ORDER : coverpoint tx_req_priority
                              {
                                bins high_high1 = (F=>F) iff (tx_trans.ftype==8 && (tx_trans.ttype==0 || tx_trans.ttype==1));
                                bins high_high2 = (F=>E) iff (tx_trans.ftype==8 && (tx_trans.ttype==0 || tx_trans.ttype==1));
                                bins high_high3 = (E=>E) iff (tx_trans.ftype==8 && (tx_trans.ttype==0 || tx_trans.ttype==1));
                                bins high_low1  = (F=>A) iff (tx_trans.ftype==8 && (tx_trans.ttype==0 || tx_trans.ttype==1));
                                bins high_low2  = (F=>B) iff (tx_trans.ftype==8 && (tx_trans.ttype==0 || tx_trans.ttype==1));
                                bins high_low3  = (F=>C) iff (tx_trans.ftype==8 && (tx_trans.ttype==0 || tx_trans.ttype==1));
                                bins high_low4  = (E=>A) iff (tx_trans.ftype==8 && (tx_trans.ttype==0 || tx_trans.ttype==1));
                                bins high_low5  = (E=>C) iff (tx_trans.ftype==8 && (tx_trans.ttype==0 || tx_trans.ttype==1));
                                bins low_high1  = (A=>F) iff (tx_trans.ftype==8 && (tx_trans.ttype==0 || tx_trans.ttype==1));
                                bins low_high2  = (B=>F) iff (tx_trans.ftype==8 && (tx_trans.ttype==0 || tx_trans.ttype==1));
                                bins low_high3  = (C=>F) iff (tx_trans.ftype==8 && (tx_trans.ttype==0 || tx_trans.ttype==1));
                                bins low_high4  = (D=>F) iff (tx_trans.ftype==8 && (tx_trans.ttype==0 || tx_trans.ttype==1));
                                bins low_high5  = (D=>E) iff (tx_trans.ftype==8 && (tx_trans.ttype==0 || tx_trans.ttype==1));
                                bins low_high6  = (B=>E) iff (tx_trans.ftype==8 && (tx_trans.ttype==0 || tx_trans.ttype==1));
                                bins low_high7  = (C=>E) iff (tx_trans.ftype==8 && (tx_trans.ttype==0 || tx_trans.ttype==1));
                                bins low_low1   = (A=>A) iff (tx_trans.ftype==8 && (tx_trans.ttype==0 || tx_trans.ttype==1));
                                bins low_low2   = (A=>B) iff (tx_trans.ftype==8 && (tx_trans.ttype==0 || tx_trans.ttype==1));
                                bins low_low3   = (B=>B) iff (tx_trans.ftype==8 && (tx_trans.ttype==0 || tx_trans.ttype==1));
                                bins low_low4   = (B=>A) iff (tx_trans.ftype==8 && (tx_trans.ttype==0 || tx_trans.ttype==1));
                              }
    CP_LL_TX_WRITE_TXN_PRIORITY_ORDER : coverpoint tx_req_priority
                              {
                                bins high_high1 = (F=>F) iff (tx_trans.ftype==5 || tx_trans.ftype==9);
                                bins high_high2 = (F=>E) iff (tx_trans.ftype==5 || tx_trans.ftype==9);
                                bins high_high3 = (E=>E) iff (tx_trans.ftype==5 || tx_trans.ftype==9);
                                bins high_low1  = (F=>A) iff (tx_trans.ftype==5 || tx_trans.ftype==9);
                                bins high_low2  = (F=>B) iff (tx_trans.ftype==5 || tx_trans.ftype==9);
                                bins high_low3  = (F=>C) iff (tx_trans.ftype==5 || tx_trans.ftype==9);
                                bins high_low4  = (E=>A) iff (tx_trans.ftype==5 || tx_trans.ftype==9);
                                bins high_low5  = (E=>C) iff (tx_trans.ftype==5 || tx_trans.ftype==9);
                                bins low_high1  = (A=>F) iff (tx_trans.ftype==5 || tx_trans.ftype==9);
                                bins low_high2  = (B=>F) iff (tx_trans.ftype==5 || tx_trans.ftype==9);
                                bins low_high3  = (C=>F) iff (tx_trans.ftype==5 || tx_trans.ftype==9);
                                bins low_high4  = (D=>F) iff (tx_trans.ftype==5 || tx_trans.ftype==9);
                                bins low_high5  = (D=>E) iff (tx_trans.ftype==5 || tx_trans.ftype==9);
                                bins low_high6  = (B=>E) iff (tx_trans.ftype==5 || tx_trans.ftype==9);
                                bins low_high7  = (C=>E) iff (tx_trans.ftype==5 || tx_trans.ftype==9);
                                bins low_low1   = (A=>A) iff (tx_trans.ftype==5 || tx_trans.ftype==9);
                                bins low_low2   = (A=>B) iff (tx_trans.ftype==5 || tx_trans.ftype==9);
                                bins low_low3   = (B=>B) iff (tx_trans.ftype==5 || tx_trans.ftype==9);
                                bins low_low4   = (B=>A) iff (tx_trans.ftype==5 || tx_trans.ftype==9);
                              }
    CP_LL_TX_WDPTR : coverpoint tx_trans.wdptr;
    CP_LL_TX_WRSIZE : coverpoint tx_trans.wrsize;
    CP_LL_TX_RDSIZE : coverpoint tx_trans.rdsize;
    CP_LL_TX_ADDR : coverpoint tx_trans.address
                    {
                      bins address_lower_range = {[29'h00000000:29'h01FFFFFF]};
                      bins address_middle_range = {[29'h02000000:29'h0EFFFFFF]};
                      bins address_high_range = {[29'h0F000000:29'h1FFFFFFF]};
                    }
    CP_LL_TX_EXT_ADDR : coverpoint tx_trans.ext_address
                    {
                      bins address_lower_range = {[32'h00000000:32'h1FFFFFFF]};
                      bins address_middle_range = {[32'h20000000:32'h9FFFFFFF]};
                      bins address_high_range = {[32'hA0000000:32'hFFFFFFFF]};
                    }
    CP_LL_TX_XAMSBS : coverpoint tx_trans.xamsbs;
    CR_LL_TX_TYPE2_WDPTR_RDSIZE : cross CP_LL_TX_TYPE2_TTYPE, CP_LL_TX_WDPTR, CP_LL_TX_RDSIZE;
    CR_LL_TX_TYPE5_WDPTR_WRSIZE : cross CP_LL_TX_TYPE5_TTYPE, CP_LL_TX_WDPTR, CP_LL_TX_WRSIZE
                                  {
                                        ignore_bins bin1 = binsof (CP_LL_TX_TYPE5_TTYPE) intersect {4,5} && binsof (CP_LL_TX_WDPTR) intersect {0} && binsof (CP_LL_TX_WRSIZE) intersect {13};
                                  }
    CR_LL_TX_TYPE5_ATOMIC_VALID_SIZE : cross CP_LL_TX_TYPE5_TTYPE,CP_LL_TX_WDPTR, CP_LL_TX_WRSIZE
                                       {
                                        ignore_bins bin1 = binsof (CP_LL_TX_TYPE5_TTYPE) intersect {4,5};
                                        ignore_bins bin2 = binsof (CP_LL_TX_WDPTR) intersect {1} && binsof (CP_LL_TX_TYPE5_TTYPE) intersect {13};
                                        ignore_bins bin3 = binsof (CP_LL_TX_WRSIZE) intersect {5, 7, [9:15]} && binsof (CP_LL_TX_TYPE5_TTYPE) 
                                                           intersect {12,14};
                                        ignore_bins bin4 = binsof (CP_LL_TX_WRSIZE) intersect {[0:10], [12:15]} && binsof (CP_LL_TX_TYPE5_TTYPE) 
                                                           intersect {13} && binsof (CP_LL_TX_WDPTR) intersect {0};
                                       }
    CR_LL_TX_TYPE2_ATOMIC_VALID_SIZE : cross CP_LL_TX_TYPE2_TTYPE, CP_LL_TX_WDPTR,CP_LL_TX_RDSIZE
                                       {
                                        ignore_bins bin1 = binsof (CP_LL_TX_TYPE2_TTYPE) intersect {4};
                                        ignore_bins bin2 = binsof (CP_LL_TX_RDSIZE) intersect {5, 7, [9:15]} && binsof (CP_LL_TX_TYPE2_TTYPE) 
                                                           intersect {12,13,14,15};
                                       }
    CR_LL_TX_TYPE5_ATOMIC_INVALID_SIZE : cross CP_LL_TX_TYPE5_TTYPE,CP_LL_TX_WDPTR, CP_LL_TX_WRSIZE
                                         {
                                          ignore_bins bin1 = binsof (CP_LL_TX_TYPE5_TTYPE) intersect {4,5};
                                          ignore_bins bin2 = binsof (CP_LL_TX_WRSIZE) intersect {11} && binsof (CP_LL_TX_WDPTR) intersect {0} && 
                                                             binsof (CP_LL_TX_TYPE5_TTYPE) intersect {13};
                                          ignore_bins bin3 = binsof (CP_LL_TX_WRSIZE) intersect {[0:4],6,8} && binsof (CP_LL_TX_TYPE5_TTYPE) 
                                                             intersect {12,14};
                                         }
    CR_LL_TX_TYPE2_ATOMIC_INVALID_SIZE : cross CP_LL_TX_TYPE2_TTYPE, CP_LL_TX_WDPTR,CP_LL_TX_RDSIZE
                                         {
                                          ignore_bins bin1 = binsof (CP_LL_TX_TYPE2_TTYPE) intersect {4};
                                          ignore_bins bin2 = binsof (CP_LL_TX_RDSIZE) intersect {[0:4], 6, 8} && binsof (CP_LL_TX_TYPE2_TTYPE) 
                                                           intersect {12,13,14,15};
                                         }
    CP_LL_TX_ATOMIC_INC_RESP_TYPE : coverpoint tx_atomic_inc_resp_type
                                    {
                                      bins resp_type[] = {0, 8};
                                    }
    CP_LL_TX_ATOMIC_INC_RESP_STATUS : coverpoint tx_atomic_inc_resp_status
                                    {
                                      bins resp_status[] = {0, 7};
                                    }
    CP_LL_TX_ATOMIC_DEC_RESP_TYPE : coverpoint tx_atomic_dec_resp_type
                                    {
                                      bins resp_type[] = {0, 8};
                                    }
    CP_LL_TX_ATOMIC_DEC_RESP_STATUS : coverpoint tx_atomic_dec_resp_status
                                    {
                                      bins resp_status[] = {0, 7};
                                    }
    CP_LL_TX_ATOMIC_SET_RESP_TYPE : coverpoint tx_atomic_set_resp_type
                                    {
                                      bins resp_type[] = {0, 8};
                                    }
    CP_LL_TX_ATOMIC_SET_RESP_STATUS : coverpoint tx_atomic_set_resp_status
                                    {
                                      bins resp_status[] = {0, 7};
                                    }
    CP_LL_TX_ATOMIC_CLR_RESP_TYPE : coverpoint tx_atomic_clr_resp_type
                                    {
                                      bins resp_type[] = {0, 8};
                                    }
    CP_LL_TX_ATOMIC_CLR_RESP_STATUS : coverpoint tx_atomic_clr_resp_status
                                    {
                                      bins resp_status[] = {0, 7};
                                    }
    CP_LL_TX_ATOMIC_SWAP_RESP_TYPE : coverpoint tx_atomic_swap_resp_type
                                    {
                                      bins resp_type[] = {0, 8};
                                    }
    CP_LL_TX_ATOMIC_SWAP_RESP_STATUS : coverpoint tx_atomic_swap_resp_status
                                    {
                                      bins resp_status[] = {0, 7};
                                    }
    CP_LL_TX_ATOMIC_COMP_RESP_TYPE : coverpoint tx_atomic_comp_resp_type
                                    {
                                      bins resp_type[] = {0, 8};
                                    }
    CP_LL_TX_ATOMIC_COMP_RESP_STATUS : coverpoint tx_atomic_comp_resp_status
                                    {
                                      bins resp_status[] = {0, 7};
                                    }
    CP_LL_TX_ATOMIC_TEST_RESP_TYPE : coverpoint tx_atomic_test_resp_type
                                    {
                                      bins resp_type[] = {0, 8};
                                    }
    CP_LL_TX_ATOMIC_TEST_RESP_STATUS : coverpoint tx_atomic_test_resp_status
                                    {
                                      bins resp_status[] = {0, 7};
                                    }

    CR_LL_TX_FTYPE_XAMSBS_SRCTID : cross CP_LL_TX_FTYPE, CP_LL_TX_XAMSBS, CP_LL_TX_TXN_ID
                                   {
                                     ignore_bins bin1 = binsof(CP_LL_TX_FTYPE) intersect {7, 8, 9, 10, 11, 13} && binsof(CP_LL_TX_XAMSBS);
                                     ignore_bins bin2 = binsof(CP_LL_TX_FTYPE) intersect {6} && binsof (CP_LL_TX_TXN_ID);
                                   }
    CP_LL_TX_NWRITE_INVALID_PAYLOAD_LEN : coverpoint tx_invalid_payload_len
                                          {
                                            bins invalid_payload_len[] = {0, 1} iff (tx_trans.ftype==5);
                                          }
    CP_LL_TX_MAINT_WRITE_INVALID_PAYLOAD_LEN : coverpoint tx_invalid_payload_len
                                          {
                                            bins invalid_payload_len[] = {0, 1} iff (tx_trans.ftype==8 && tx_trans.ttype==1);
                                          }
    CR_LL_TX_MAINT_RD_WDPTR_RDSIZE : cross CP_LL_TX_TYPE8_TTYPE, CP_LL_TX_WDPTR, CP_LL_TX_RDSIZE
                               {
                                 ignore_bins bin1 = !binsof(CP_LL_TX_RDSIZE) intersect {8, 11, 12};
                                 ignore_bins bin2 = !binsof (CP_LL_TX_TYPE8_TTYPE) intersect {0};
                               }
    CR_LL_TX_MAINT_WR_WDPTR_WRSIZE : cross CP_LL_TX_TYPE8_TTYPE, CP_LL_TX_WDPTR, CP_LL_TX_WRSIZE
                               {
                                 ignore_bins bin1 = !binsof(CP_LL_TX_WRSIZE) intersect {8, 11, 12};
                                 ignore_bins bin2 = !binsof (CP_LL_TX_TYPE8_TTYPE) intersect {1};
                               }
    CP_LL_TX_MAINT_CONFIG_OFFSET : coverpoint tx_trans.config_offset 
                                   {
                                     bins offset1 = {[20'h00000 : 20'h000FF]} iff (tx_trans.ftype==8 && (tx_trans.ttype==0 || tx_trans.ttype==1));
                                     bins offset2 = {[20'h00100 : 20'h001FF]} iff (tx_trans.ftype==8 && (tx_trans.ttype==0 || tx_trans.ttype==1));
                                     bins offset3 = {[20'h00200 : 20'h003FF]} iff (tx_trans.ftype==8 && (tx_trans.ttype==0 || tx_trans.ttype==1));
                                     bins offset4 = {[20'h00600 : 20'h006FF]} iff (tx_trans.ftype==8 && (tx_trans.ttype==0 || tx_trans.ttype==1));
                                     bins offset5 = {[20'h00800 : 20'h008FF]} iff (tx_trans.ftype==8 && (tx_trans.ttype==0 || tx_trans.ttype==1));
                                   }
    CP_LL_TX_MAINT_SRCTID : coverpoint tx_trans.SrcTID 
                            {
                              bins srctid_range0_ttype0 = {[0:50]}   iff (tx_trans.ftype==8 && tx_trans.ttype==0);
                              bins srctid_range1_ttype0 = {[51:150]} iff (tx_trans.ftype==8 && tx_trans.ttype==0);
                              bins srctid_range2_ttype0 = {[151:255]} iff (tx_trans.ftype==8 && tx_trans.ttype==0);
                              bins srctid_range0_ttype1 = {[0:50]}    iff (tx_trans.ftype==8 && tx_trans.ttype==1);
                              bins srctid_range1_ttype1 = {[51:150]}  iff (tx_trans.ftype==8 && tx_trans.ttype==1);
                              bins srctid_range2_ttype1 = {[151:255]} iff (tx_trans.ftype==8 && tx_trans.ttype==1);
                            }
    CP_LL_TX_MAINT_TARGET_TID : coverpoint tx_trans.targetID_Info
                                {
                                  bins tgtid_range0_ttype2 = {[0:50]} iff (tx_trans.ftype==8 && tx_trans.ttype==2);
                                  bins tgtid_range1_ttype2 = {[51:150]} iff (tx_trans.ftype==8 && tx_trans.ttype==2);
                                  bins tgtid_range2_ttype2 = {[151:255]} iff (tx_trans.ftype==8 && tx_trans.ttype==2);
                                  bins tgtid_range0_ttype3 = {[0:50]} iff (tx_trans.ftype==8 && tx_trans.ttype==3);
                                  bins tgtid_range1_ttype3 = {[51:150]} iff (tx_trans.ftype==8 && tx_trans.ttype==3);
                                  bins tgtid_range2_ttype3 = {[151:255]} iff (tx_trans.ftype==8 && tx_trans.ttype==3);
                                }
    CP_LL_TX_MAINT_STATUS : coverpoint tx_trans.trans_status
                            {
                              bins trans_status_ttype2[] = {0, 7} iff (tx_trans.ftype==8 && tx_trans.ttype==2);
                              bins trans_status_ttype3[] = {0, 7} iff (tx_trans.ftype==8 && tx_trans.ttype==3);
                            }
    CP_LL_TX_RESP_TXN : coverpoint tx_trans.ttype
                        {
                         bins type13_with_no_data_payload = {0} iff (tx_trans.ftype == 13);
                         bins type13_with_data_payload = {8} iff (tx_trans.ftype == 13);
                        }
    CP_LL_TX_RESP_TARGET_TID : coverpoint tx_trans.targetID_Info
                                {
                                  bins tgtid_range0_ttype0 = {[0:50]} iff (tx_trans.ftype==13 && tx_trans.ttype==0);
                                  bins tgtid_range1_ttype0 = {[51:150]} iff (tx_trans.ftype==13 && tx_trans.ttype==0);
                                  bins tgtid_range2_ttype0 = {[151:255]} iff (tx_trans.ftype==13 && tx_trans.ttype==0);
                                  bins tgtid_range0_ttype8 = {[0:50]} iff (tx_trans.ftype==13 && tx_trans.ttype==8);
                                  bins tgtid_range1_ttype8 = {[51:150]} iff (tx_trans.ftype==13 && tx_trans.ttype==8);
                                  bins tgtid_range2_ttype8 = {[151:255]} iff (tx_trans.ftype==13 && tx_trans.ttype==8);
                                }
    CP_LL_TX_IO_RESP_STATUS : coverpoint tx_trans.trans_status
                                {
                                  bins trans_sts_ttype0[] = {0, 7} iff (tx_trans.ftype==13  && tx_trans.ttype==0);
                                  bins trans_sts_ttype8[] = {0, 7} iff (tx_trans.ftype==13  && tx_trans.ttype==8);
                                }
    CP_LL_TX_MSG_MSGLEN : coverpoint tx_trans.msg_len
                          {
                            bins msg_len[] = {[0:15]} iff (tx_trans.ftype==11);
                          }
    CP_LL_TX_MSG_MSGSEG : coverpoint tx_trans.msgseg_xmbox
                          {
                               bins msg_seg[] = {[0:15]} iff (tx_trans.ftype==11 && tx_trans.msg_len !=0);
                          }
    CP_LL_TX_MSG_XMBOX : coverpoint tx_trans.msgseg_xmbox
                             {
                               bins msg_xmbox_range1 = {[0:3]} iff (tx_trans.ftype==11 && tx_trans.msg_len==0);
                               bins msg_xmbox_range2 = {[4:7]} iff (tx_trans.ftype==11 && tx_trans.msg_len==0);
                               bins msg_xmbox_range3 = {[8:11]} iff (tx_trans.ftype==11 && tx_trans.msg_len==0);
                               bins msg_xmbox_range4 = {[12:15]} iff (tx_trans.ftype==11 && tx_trans.msg_len==0);
                             }
    CP_LL_TX_MSG_MBOX : coverpoint tx_trans.mbox
                             {
                               bins msg_mbox[] = {[0:3]} iff (tx_trans.ftype==11);
                             }
    CP_LL_TX_MSG_SSIZE : coverpoint tx_trans.ssize
                             {
                               bins msg_ssize[] = {[9:14]} iff (tx_trans.ftype==11);
                             }
    CP_LL_TX_MSG_LETTER : coverpoint tx_trans.letter
                             {
                               bins msg_letter[] = {[0:3]} iff (tx_trans.ftype==11);
                             }
    CR_LL_TX_MSG_SINGLE_XMBOX_MBOX_LETTER : cross CP_LL_TX_MSG_XMBOX, CP_LL_TX_MSG_MBOX, CP_LL_TX_MSG_LETTER;
    CR_LL_TX_MSG_MULTI_SEG_SSIZE_MBOX_LETTER : cross CP_LL_TX_MSG_MSGLEN, CP_LL_TX_MSG_SSIZE, CP_LL_TX_MSG_MBOX, CP_LL_TX_MSG_LETTER
                                               {
                                                 ignore_bins single_seg = binsof(CP_LL_TX_MSG_MSGLEN) intersect {0};
                                               }
    CP_LL_TX_MSG_OUT_ORDER : coverpoint tx_msg_out_of_order;
    CP_LL_TX_MSG_INTERLEAVE : coverpoint tx_msg_interleave;
    CP_LL_TX_DOORBELL_RESP_TYPE : coverpoint tx_doorbell_resp_type
                                  {
                                    bins resp_type = {0};
                                  }
    CP_LL_TX_DOORBELL_RESP_STATUS : coverpoint tx_doorbell_resp_status
                                  {
                                    bins resp_status[] = {0, 3, 7};
                                  }
    CP_LL_TX_MSG_RESP_TYPE : coverpoint tx_trans.ttype
                                  {
                                    bins resp_type = {1} iff (tx_trans.ftype=='hd);
                                  }
    CP_LL_TX_MSG_RESP_STATUS : coverpoint tx_trans.trans_status
                                  {
                                    bins resp_status[] = {0, 3, 7} iff (tx_trans.ftype=='hd && tx_trans.ttype=='h1);
                                  }
    CP_LL_TX_MSG_RESP_TARGET_TID : coverpoint tx_trans.targetID_Info
                               {
                                 bins target_range1_info = {[8'd0:8'd50]} iff (tx_trans.ftype=='hd && tx_trans.ttype=='h1);
                                 bins target_range2_info = {[8'd51:8'd150]} iff (tx_trans.ftype=='hd && tx_trans.ttype=='h1);
                                 bins target_range3_info = {[8'd151:8'd255]} iff (tx_trans.ftype=='hd && tx_trans.ttype=='h1);
                               }
    CR_LL_TX_MSG_RESP_STATUS_TARGET_TID : cross CP_LL_TX_MSG_RESP_STATUS, CP_LL_TX_MSG_RESP_TARGET_TID;
    CP_LL_TX_MSG_PRIORITY : coverpoint tx_trans.prio
                              {
                                bins msg_prio_crf0[] = {[0:2]} iff (tx_trans.crf==0 && tx_trans.ftype==11);
                                bins msg_prio_crf1[] = {[0:2]} iff (tx_trans.crf==1 && tx_trans.ftype==11);
                              }
    CP_TL_TX_TT_VALID : coverpoint tx_trans.tt
                        {
                          bins valid_tt[] = {[0:2]};
                        }
    CR_TX_TT_FTYPE : cross CP_LL_TX_FTYPE, CP_TL_TX_TT_VALID;
    CR_TX_TT_TTYPE : cross CP_LL_TX_TTYPE, CP_TL_TX_TT_VALID;
    CR_TX_TT_TYPE2_TTYPE : cross CP_TL_TX_TT_VALID, CP_LL_TX_TYPE2_TTYPE;
    CR_TX_TT_TYPE5_TTYPE : cross CP_TL_TX_TT_VALID, CP_LL_TX_TYPE5_TTYPE;
    CR_TX_TT_TYPE8_TTYPE : cross CP_TL_TX_TT_VALID, CP_LL_TX_TYPE8_TTYPE;
    CR_TX_TT_TYPE10_TTYPE : cross CP_TL_TX_TT_VALID, CP_LL_TX_TYPE10_TTYPE;
    CR_TX_TT_TYPE11_TTYPE : cross CP_TL_TX_TT_VALID, CP_LL_TX_TYPE11_TTYPE;
    CR_TX_TT_TYPE13_TTYPE : cross CP_TL_TX_TT_VALID, CP_LL_TX_TYPE13_TTYPE;
    CP_LL_TX_GSM_REQ_TTYPE : coverpoint tx_trans.ttype
                             {
                               bins type1_gsm_type[] = {[0:2]} iff (tx_trans.ftype==1);
                               bins type2_gsm_type[] = {[0:3], [5:11]} iff (tx_trans.ftype==2);
                               bins type5_gsm_type[] = {0, 1} iff (tx_trans.ftype==5);
                             }

    CP_LL_TX_GSM_SRCTID : coverpoint tx_trans.SrcTID 
                            {
                              bins srctid_range0_ftype1 = {[0:50]}   iff (tx_trans.ftype==1);
                              bins srctid_range1_ftype1 = {[51:150]} iff (tx_trans.ftype==1) ;
                              bins srctid_range2_ftype1 = {[151:255]} iff (tx_trans.ftype==1);
                              bins srctid_range0_ftype2 = {[0:50]}    iff (tx_trans.ftype==2);
                              bins srctid_range1_ftype2 = {[51:150]}  iff (tx_trans.ftype==2);
                              bins srctid_range2_ftype2 = {[151:255]} iff (tx_trans.ftype==2);
                              bins srctid_range0_ftype5 = {[0:50]}    iff (tx_trans.ftype==5);
                              bins srctid_range1_ftype5 = {[51:150]}  iff (tx_trans.ftype==5);
                              bins srctid_range2_ftype5 = {[151:255]} iff (tx_trans.ftype==5);
                            }
    CR_LL_TX_GSM_REQ_SRCTID : cross CP_LL_TX_GSM_REQ_TTYPE, CP_LL_TX_GSM_SRCTID
                              {
                                ignore_bins type1_en = binsof(CP_LL_TX_GSM_REQ_TTYPE.type1_gsm_type) && (binsof(CP_LL_TX_GSM_SRCTID.srctid_range0_ftype2) ||  binsof(CP_LL_TX_GSM_SRCTID.srctid_range1_ftype2) || binsof(CP_LL_TX_GSM_SRCTID.srctid_range2_ftype2) || binsof(CP_LL_TX_GSM_SRCTID.srctid_range0_ftype5) ||  binsof(CP_LL_TX_GSM_SRCTID.srctid_range1_ftype5) || binsof(CP_LL_TX_GSM_SRCTID.srctid_range2_ftype5) );
                                ignore_bins type2_en = binsof(CP_LL_TX_GSM_REQ_TTYPE.type2_gsm_type) && (binsof(CP_LL_TX_GSM_SRCTID.srctid_range0_ftype1) ||  binsof(CP_LL_TX_GSM_SRCTID.srctid_range1_ftype1) || binsof(CP_LL_TX_GSM_SRCTID.srctid_range2_ftype1) || binsof(CP_LL_TX_GSM_SRCTID.srctid_range0_ftype5) ||  binsof(CP_LL_TX_GSM_SRCTID.srctid_range1_ftype5) || binsof(CP_LL_TX_GSM_SRCTID.srctid_range2_ftype5) );
                                ignore_bins type5_en = binsof(CP_LL_TX_GSM_REQ_TTYPE.type5_gsm_type) && (binsof(CP_LL_TX_GSM_SRCTID.srctid_range0_ftype1) ||  binsof(CP_LL_TX_GSM_SRCTID.srctid_range1_ftype1) || binsof(CP_LL_TX_GSM_SRCTID.srctid_range2_ftype1) || binsof(CP_LL_TX_GSM_SRCTID.srctid_range0_ftype2) ||  binsof(CP_LL_TX_GSM_SRCTID.srctid_range1_ftype2) || binsof(CP_LL_TX_GSM_SRCTID.srctid_range2_ftype2) );
                              }

    CR_LL_TX_GSM_REQ_WDPTR_WRSIZE : cross CP_LL_TX_GSM_REQ_TTYPE, CP_LL_TX_WDPTR, CP_LL_TX_WRSIZE
                                    {
                                      ignore_bins wrsize_reserved = binsof(CP_LL_TX_WRSIZE) intersect {[13:15]};
                                      ignore_bins type1_2_pkts = !binsof(CP_LL_TX_GSM_REQ_TTYPE.type5_gsm_type);
                                    }
    CR_LL_TX_GSM_REQ_WDPTR_RDSIZE : cross CP_LL_TX_GSM_REQ_TTYPE, CP_LL_TX_WDPTR, CP_LL_TX_RDSIZE
                                    {
                                      ignore_bins rdsize_reserved = binsof(CP_LL_TX_RDSIZE) intersect {[13:15]};
                                      ignore_bins type5_pkts = binsof(CP_LL_TX_GSM_REQ_TTYPE.type5_gsm_type);
                                      ignore_bins addr_only_txns = !binsof(CP_LL_TX_GSM_REQ_TTYPE) intersect {3, 5, 6, 7, 9, 10, 11} && binsof(CP_LL_TX_RDSIZE) intersect {0} && binsof(CP_LL_TX_WDPTR) intersect {0};
                                    }
    CP_LL_TX_GSM_RD_O_RESP_TYPE : coverpoint tx_gsm_rd_o_resp_type
                                  {
                                    bins resp_type[] = {0, 8};
                                  }
    CP_LL_TX_GSM_RD_O_RESP_STATUS : coverpoint tx_gsm_rd_o_resp_status
                                  {
                                    bins resp_status[] = {3, 4, 7};
                                  }
    CP_LL_TX_GSM_RD_O_O_RESP_TYPE : coverpoint tx_gsm_rd_o_o_resp_type
                                  {
                                    bins resp_type[] = {0, 8};
                                  }
    CP_LL_TX_GSM_RD_O_O_RESP_STATUS : coverpoint tx_gsm_rd_o_o_resp_status
                                  {
                                    bins resp_status[] = {3, 4, 7};
                                  }
    CP_LL_TX_GSM_IO_RD_O_RESP_TYPE : coverpoint tx_gsm_io_rd_o_resp_type
                                  {
                                    bins resp_type[] = {0, 8};
                                  }
    CP_LL_TX_GSM_IO_RD_O_RESP_STATUS : coverpoint tx_gsm_io_rd_o_resp_status
                                  {
                                    bins resp_status[] = {3, 4, 7};
                                  }
    CP_LL_TX_GSM_RD_H_RESP_TYPE : coverpoint tx_gsm_rd_h_resp_type
                                  {
                                    bins resp_type[] = {0, 8};
                                  }
    CP_LL_TX_GSM_RD_H_RESP_STATUS : coverpoint tx_gsm_rd_h_resp_status
                                  {
                                    bins resp_status[] = {0, 1, 3, 5, 7};
                                  }
    CP_LL_TX_GSM_RD_O_H_RESP_TYPE : coverpoint tx_gsm_rd_o_h_resp_type
                                  {
                                    bins resp_type[] = {0, 8};
                                  }
    CP_LL_TX_GSM_RD_O_H_RESP_STATUS : coverpoint tx_gsm_rd_o_h_resp_status
                                  {
                                    bins resp_status[] = {0, 1, 3, 5, 7};
                                  }
    CP_LL_TX_GSM_IO_RD_H_RESP_TYPE : coverpoint tx_gsm_io_rd_h_resp_type
                                  {
                                    bins resp_type[] = {0, 8};
                                  }
    CP_LL_TX_GSM_IO_RD_H_RESP_STATUS : coverpoint tx_gsm_io_rd_h_resp_status
                                  {
                                    bins resp_status[] = {0, 1, 3, 5, 7};
                                  }
    CP_LL_TX_GSM_D_H_RESP_TYPE : coverpoint tx_gsm_d_h_resp_type
                                  {
                                    bins resp_type[] = {0, 8};
                                  }
    CP_LL_TX_GSM_D_H_RESP_STATUS : coverpoint tx_gsm_d_h_resp_status
                                  {
                                    bins resp_status[] = {0, 3, 7};
                                  }
    CP_LL_TX_GSM_I_H_RESP_TYPE : coverpoint tx_gsm_i_h_resp_type
                                  {
                                    bins resp_type[] = {0, 8};
                                  }
    CP_LL_TX_GSM_I_H_RESP_STATUS : coverpoint tx_gsm_i_h_resp_status
                                  {
                                    bins resp_status[] = {0, 3, 7};
                                  }
    CP_LL_TX_GSM_TLBIE_RESP_TYPE : coverpoint tx_gsm_tlbie_resp_type
                                  {
                                    bins resp_type[] = {0, 8};
                                  }
    CP_LL_TX_GSM_TLBIE_RESP_STATUS : coverpoint tx_gsm_tlbie_resp_status
                                  {
                                    bins resp_status[] = {0, 3, 7};
                                  }
    CP_LL_TX_GSM_TLBSYNC_RESP_TYPE : coverpoint tx_gsm_tlbsync_resp_type
                                  {
                                    bins resp_type[] = {0, 8};
                                  }
    CP_LL_TX_GSM_TLBSYNC_RESP_STATUS : coverpoint tx_gsm_tlbsync_resp_status
                                  {
                                    bins resp_status[] = {0, 3, 7};
                                  }
    CP_LL_TX_GSM_IRD_H_RESP_TYPE : coverpoint tx_gsm_ird_h_resp_type
                                  {
                                    bins resp_type[] = {0, 8};
                                  }
    CP_LL_TX_GSM_IRD_H_RESP_STATUS : coverpoint tx_gsm_ird_h_resp_status
                                  {
                                    bins resp_status[] = {0, 1, 3, 5, 7};
                                  }
    CP_LL_TX_GSM_FLUSH_WO_D_RESP_TYPE : coverpoint tx_gsm_flush_wo_d_resp_type
                                  {
                                    bins resp_type[] = {0, 8};
                                  }
    CP_LL_TX_GSM_FLUSH_WO_D_RESP_STATUS : coverpoint tx_gsm_flush_wo_d_resp_status
                                  {
                                    bins resp_status[] = {0, 3, 7};
                                  }
    CP_LL_TX_GSM_IK_SH_RESP_TYPE : coverpoint tx_gsm_ik_sh_resp_type
                                  {
                                    bins resp_type[] = {0, 8};
                                  }
    CP_LL_TX_GSM_IK_SH_RESP_STATUS : coverpoint tx_gsm_ik_sh_resp_status
                                  {
                                    bins resp_status[] = {0, 3, 7};
                                  }
    CP_LL_TX_GSM_DK_SH_RESP_TYPE : coverpoint tx_gsm_dk_sh_resp_type
                                  {
                                    bins resp_type[] = {0, 8};
                                  }
    CP_LL_TX_GSM_DK_SH_RESP_STATUS : coverpoint tx_gsm_dk_sh_resp_status
                                  {
                                    bins resp_status[] = {0, 3, 7};
                                  }
    CP_LL_TX_GSM_CASTOUT_RESP_TYPE : coverpoint tx_gsm_castout_resp_type
                                  {
                                    bins resp_type[] = {0, 8};
                                  }
    CP_LL_TX_GSM_CASTOUT_RESP_STATUS : coverpoint tx_gsm_castout_resp_status
                                  {
                                    bins resp_status[] = {0, 3, 7};
                                  }
    CP_LL_TX_GSM_FLUSH_WD_RESP_TYPE : coverpoint tx_gsm_flush_wd_resp_type
                                  {
                                    bins resp_type[] = {0, 8};
                                  }
    CP_LL_TX_GSM_FLUSH_WD_RESP_STATUS : coverpoint tx_gsm_flush_wd_resp_status
                                  {
                                    bins resp_status[] = {0, 3, 7};
                                  }
//    CP_LL_TX_GSM_REQ_DATA_PAYLOAD : coverpoint tx_payload_size
//                                    {
//                                      bins aligned_8byte = {[0:256]} with (item % 8 == 0);
//                                      //bins aligned_8byte = {[0:256]} with (item % 8 == 0);
//                                      bins aligned_4byte = {[0:256]} with (((item % 4) == 0) && ((item % 8) != 0));
//                                      bins aligned_2byte = {[0:256]} with (((item % 2) == 0) && ((item % 4) != 0) && ((item % 8) != 0));
//                                      bins aligned_1byte = {[0:256]} with (((item % 1) == 0) && ((item % 2) != 0) && ((item % 4) != 0) && ((item % 8) != 0));
//                                    }
    CP_LL_TX_IO_ERROR_RESP : coverpoint tx_trans.trans_status
                             {
                               bins resp_status = {7} iff (tx_trans.ftype==13 && tx_trans.ttype==0);
                             }
    CP_LL_TX_MSG_ERROR_RESP : coverpoint tx_trans.trans_status
                              {
                                bins resp_status = {7} iff (tx_trans.ftype==13 && tx_trans.ttype==1);
                              }
    CP_LL_TX_GSM_ERROR_RESP : coverpoint tx_gsm_resp_status
                              {
                                bins resp_status = {7};
                              }
    CP_LL_TX_MSG_FORMAT_ERR_INVALID_SIZE : coverpoint tx_msg_invalid_size
                                           {    
                                             bins invalid = {1};
                                           }
    CP_LL_TX_MSG_FORMAT_ERR_INVALID_SEG : coverpoint tx_msg_invalid_seg
                                           {    
                                             bins invalid = {1};
                                           }
    CR_LL_TX_MSG_FORMAT_ERR_INVALID_SIZE_SEGMENT : cross CP_LL_TX_MSG_FORMAT_ERR_INVALID_SIZE, CP_LL_TX_MSG_FORMAT_ERR_INVALID_SEG;
    CP_LL_TX_IO_ILLEGAL_TRANS_DEC : coverpoint tx_trans.ttype 
                                    {
                                      bins type5_ttype_illegal[] = {[2:3],[6:11]} iff (tx_trans.ftype == 5);
                                      bins type5_wrsize_illegal_1[] = {[0:1],[4:5],[12:15]} iff (tx_trans.ftype == 5 && 
                                                                       tx_trans.wrsize == 14 && tx_trans.wdptr ==1);
                                      bins type5_wrsize_illegal_2[] = {[0:1],[4:5],[12:15]} iff (tx_trans.ftype == 5 && 
                                                                       tx_trans.wrsize == 14 && tx_trans.wdptr ==0);
                                      bins type5_wrsize_illegal_3[] = {[0:1],[4:5],[12:15]} iff (tx_trans.ftype == 5 && 
                                                                       tx_trans.wrsize == 15 && tx_trans.wdptr ==0);
                                      bins type8_ttype_illegal[] = {[5:15]} iff (tx_trans.ftype ==8);
                                    }
    CP_LL_TX_IO_RESP_ILLEGAL_TRANS_DEC : coverpoint tx_trans.ttype
                                         {
                                           bins type13_ttype_illegal[] = {[2:7],[9:15]} iff (tx_trans.ftype == 13);
                                           bins type8_status_illegal_1[] = {[2:3]} iff  (tx_trans.ftype==8 && tx_trans.trans_status == 1);
                                           bins type8_status_illegal_2[] = {[2:3]} iff  (tx_trans.ftype==8 && tx_trans.trans_status == 2);
                                           bins type8_status_illegal_3[] = {[2:3]} iff  (tx_trans.ftype==8 && tx_trans.trans_status == 3);
                                           bins type8_status_illegal_4[] = {[2:3]} iff  (tx_trans.ftype==8 && tx_trans.trans_status == 4);
                                           bins type8_status_illegal_5[] = {[2:3]} iff  (tx_trans.ftype==8 && tx_trans.trans_status == 5);
                                           bins type8_status_illegal_6[] = {[2:3]} iff  (tx_trans.ftype==8 && tx_trans.trans_status == 6);
                                           bins type8_status_illegal_7[] = {[2:3]} iff  (tx_trans.ftype==8 && tx_trans.trans_status == 8);
                                           bins type8_status_illegal_8[] = {[2:3]} iff  (tx_trans.ftype==8 && tx_trans.trans_status == 9);
                                           bins type8_status_illegal_9[] = {[2:3]} iff  (tx_trans.ftype==8 && tx_trans.trans_status == 10);
                                           bins type8_status_illegal_10[] = {[2:3]} iff (tx_trans.ftype==8 && tx_trans.trans_status == 11);
                                         }
    CP_LL_TX_MSG_ILLEGAL_TRANS_DEC : coverpoint tx_trans.ssize
                                     {
                                        bins type11_sseg_illegal[] = {[0:8]} iff (tx_trans.ftype == 11 && tx_trans.msg_len ==0);
                                        bins type11_mseg_illegal[] = {[0:8]} iff (tx_trans.ftype == 11 && tx_trans.msg_len !=0);
                                     }
    CP_LL_TX_MSG_RESP_ILLEGAL_TRANS_DEC : coverpoint tx_trans.trans_status
                                          {
                                            bins msg_resp_illegal[] = {[1:2],[4:6],[8:11]} iff (tx_trans.ftype == 13 && tx_trans.ttype == 1);
                                          }
    CP_LL_TX_GSM_ILLEGAL_TRANS_DEC : coverpoint tx_trans.ttype
                                     {
                                       bins type1_ttype_illegal[] = {[3:$]} iff (tx_trans.ftype==1);
                                       bins type5_ttype_illegal[] = {2, 3, [6:$]} iff (tx_trans.ftype==5);
                                       bins type1_txnsize_illegal[]  = {[0:2]} iff (tx_trans.ftype==1 && tx_trans.rdsize>12); 
                                       bins type2_txnsize_illegal[]  = {[0:3], [5:11]} iff (tx_trans.ftype==2 && (tx_trans.rdsize>12 || tx_trans.wrsize>12)); 
                                       bins type5_txnsize_illegal[]  = {0, 1} iff (tx_trans.ftype==5 && (tx_trans.rdsize>12 || tx_trans.wrsize>12)); 
                                     }
    CP_LL_TX_GSM_RESP_ILLEGAL_TRANS_DEC : coverpoint tx_gsm_resp_type
                                     {
                                        bins gsm_type_illegal[] = {[1:7], [9:$]};
                                        bins gsm_status_illegal[] = {0, 8} iff (tx_gsm_resp_status==6 || tx_gsm_resp_status>7);
                                     }
    CP_TL_TX_ILLEGAL_TARGET : coverpoint tx_trans.tl_err_detected
                              {
                                bins err_type = {DEST_ID_MISMATCH_ERR};
                              }
    CP_TL_TX_IO_ILLEGAL_TRANS_TARGET : coverpoint tx_trans.tl_err_detected
                              {
                                bins err_type2 = {DEST_ID_MISMATCH_ERR} iff (tx_trans.ftype==2);
                                bins err_type5 = {DEST_ID_MISMATCH_ERR} iff (tx_trans.ftype==5);
                                bins err_type8 = {DEST_ID_MISMATCH_ERR} iff (tx_trans.ftype==8);
                              }
    CP_TL_TX_GSM_ILLEGAL_TRANS_TARGET : coverpoint tx_trans.ttype
                              {
                               bins type1_gsm_type[] = {[0:2]} iff (tx_trans.ftype==1 && tx_trans.tl_err_detected==DEST_ID_MISMATCH_ERR);
                               bins type2_gsm_type[] = {[0:3], [5:11]} iff (tx_trans.ftype==2 && tx_trans.tl_err_detected==DEST_ID_MISMATCH_ERR);
                               bins type5_gsm_type[] = {0, 1} iff (tx_trans.ftype==5 && tx_trans.tl_err_detected==DEST_ID_MISMATCH_ERR);
                              }
    CP_LL_TX_MSG_REQ_TIMEOUT : coverpoint msg_req_timeout;
    CP_LL_TX_RESP_TIMEOUT : coverpoint resp_timeout;
    CP_LL_TX_UNEXPECTED_IO_RESP : coverpoint unexp_response
                                  {
                                    bins err_type13 = {1} iff (tx_trans.ftype==13 && (tx_trans.ttype==0 || tx_trans.ttype==8));
                                  }
    CP_LL_TX_UNEXPECTED_MAINT_RESP : coverpoint unexp_response
                                  {
                                    bins err_type8 = {1} iff (tx_trans.ftype==8 && (tx_trans.ttype==2 || tx_trans.ttype==3));
                                  }
    CP_LL_TX_UNEXPECTED_MSG_RESP : coverpoint unexp_response
                                  {
                                    bins err_type11 = {1} iff (tx_trans.ftype==13 && (tx_trans.ttype==1));
                                  }
                               
    CP_LL_TX_UNSUPP_IO_TXN : coverpoint tx_trans.ftype
                             {
                               bins nread_not_supported = {2} iff (Nread == 0 && tx_trans.ttype == 4);
                               bins atomic_inc_not_supported = {2} iff (Atomic_increment ==0 && tx_trans.ttype == 12);
                               bins atomic_dec_not_supported = {2} iff (Atomic_decrement ==0 && tx_trans.ttype == 13);
                               bins atomic_set_not_supported = {2} iff (Atomic_set ==0 && tx_trans.ttype == 14);
                               bins atomic_clr_not_supported = {2} iff (Atomic_clear ==0 && tx_trans.ttype == 15);
                               bins nwrite_not_supported = {5} iff (nwrite ==0 && tx_trans.ttype == 4);
                               bins nwrite_r_not_supported = {5} iff (Write_with_response ==0 && tx_trans.ttype == 5);
                               bins atomic_swap_not_supported = {5} iff (Atomic_swap ==0 && tx_trans.ttype == 12);
                               bins atomic_compare_and_swap_not_supported = {5} iff (Atomic_compare_and_swap ==0 && tx_trans.ttype == 13);
                               bins atomic_test_and_swap_not_supported = {5} iff (Atomic_test_and_swap ==0 && tx_trans.ttype == 14);
                               bins swrite_not_supported = {6} iff (Streaming_write ==0);
                               bins port_write_not_supported = {8} iff (Port_write ==0 && tx_trans.ttype == 4);
                             }
    CP_LL_TX_UNSUPP_MSG_TXN : coverpoint tx_trans.ftype
                              {
                               bins sseg_msg_not_supported = {11} iff (Data_Message ==0 && tx_trans.msg_len ==0);
                               bins mseg_msg_not_supported = {11} iff (Data_Message ==0 && tx_trans.msg_len !=0);
                               bins doorbell_msg_not_supported = {10} iff (Doorbell ==0);
                              }
    CP_LL_TX_UNSUPP_GSM_TXN : coverpoint tx_trans.ftype
                              {
                                bins read_owner_not_supported_1 = {1} iff (Read ==0 && tx_trans.ttype == 0);
                                bins read_owner_not_supported_2 = {1} iff (Instruction_read ==0 && tx_trans.ttype == 0);
                                bins read_to_own_owner_not_supported_1 = {1} iff (Read_for_ownership ==0 && tx_trans.ttype == 1);
                                bins read_to_own_owner_not_supported_2 = {1} iff (Data_cache_flush ==0 && tx_trans.ttype == 1);
                                bins io_read_owner_not_supported = {1} iff (IO_read==0 && tx_trans.ttype == 2);
                                bins read_home_not_supported = {2} iff (Read ==0 && tx_trans.ttype ==0);
                                bins read_to_own_home_not_supported = {2} iff (Read_for_ownership == 0 && tx_trans.ttype ==1);
                                bins io_read_home_not_supported = {2} iff (IO_read && tx_trans.ttype == 2);
                                bins dkill_home_not_supported = {2} iff (Data_cache_invalidate==0 && tx_trans.ttype == 3);
                                bins ikill_home_not_supported = {2} iff (Instruction_cache_invalidate ==0 && tx_trans.ttype ==5);
                                bins tlbie_not_supported = {2} iff (TLB_invalidate_entry ==0 && tx_trans.ttype == 6);
                                bins tlbsync_not_supported = {2} iff (TLB_invalidate_entry_sync ==0 && tx_trans.ttype == 7);
                                bins iread_home_not_supported = {2} iff (Instruction_read ==0 && tx_trans.ttype == 8);
                                bins flush_without_data_not_supported = {2} iff (Data_cache_flush == 0 && tx_trans.ttype == 9);
                                bins ikill_sharer_not_supported = {2} iff (Instruction_cache_invalidate==0 && tx_trans.ttype == 10);
                                bins dkill_sharer_not_supported_1 = {2} iff (Read_for_ownership ==0 && tx_trans.ttype == 11);
                                bins dkill_sharer_not_supported_2 = {2} iff (Data_cache_flush ==0 && tx_trans.ttype == 11);
                                bins dkill_sharer_not_supported_3 = {2} iff (Data_cache_invalidate ==0 && tx_trans.ttype == 11);
                                bins castout_not_supported = {5} iff (Castout ==0 && tx_trans.ttype == 0);
                                bins flsuh_with_data_not_supported = {5} iff (Data_cache_flush ==0 && tx_trans.ttype == 1);
                              }
    CP_LL_TX_IO_GOOD_ERROR_RESP : coverpoint tx_trans.trans_status
                                  {
                                    bins io_done_error_done_error_resp_no_data_payload[] = (0=>7=>0=>7) iff (tx_trans.ftype == 13 && tx_trans.ttype == 0);
                                    bins io_done_error_done_error_with_data_payload[] = (0=>7=>0=>7) iff (tx_trans.ftype == 13 && tx_trans.ttype == 8);
                                  }
    CP_LL_TX_MSG_GOOD_ERROR_RESP : coverpoint tx_trans.trans_status
                                   {
                                     bins msg_done_error_done_error_resp[] = (0=>7=>0=>7) iff (tx_trans.ftype == 13 && tx_trans.ttype == 1);
                                   } 
    CP_LL_TX_BACK2BACK_MSG_INVALID_SIZE : coverpoint tx_msg_invalid_size
                                          {
                                             bins pattern1 = (1 => 1);
                                          }
    CP_LL_TX_BACK2BACK_MSG_INVALID_SEGMENT : coverpoint tx_msg_invalid_seg
                                          {
                                             bins pattern1 = (1 => 1);
                                          }
    CR_LL_TX_BACK2BACK_MSG_INVALID_SIZE_SEGMENT : cross CP_LL_TX_BACK2BACK_MSG_INVALID_SIZE, CP_LL_TX_BACK2BACK_MSG_INVALID_SEGMENT;
    CP_LL_TX_CONSECUTIVE_MSG_VALID_INVALID_SIZE : coverpoint tx_msg_invalid_size
                                                   {
                                                      bins pattern0 = (0 => 0 => 0);
                                                      bins pattern1 = (0 => 0 => 1);
                                                      bins pattern2 = (0 => 1 => 0);
                                                      bins pattern3 = (0 => 1 => 1);
                                                      bins pattern4 = (1 => 0 => 0);
                                                      bins pattern5 = (1 => 0 => 1);
                                                      bins pattern6 = (1 => 1 => 0);
                                                      bins pattern7 = (1 => 1 => 1);
                                                   }
    CP_LL_TX_CONSECUTIVE_MSG_VALID_INVALID_SEGMENT  : coverpoint tx_msg_invalid_seg
                                                   {
                                                      bins pattern0 = (0 => 0 => 0);
                                                      bins pattern1 = (0 => 0 => 1);
                                                      bins pattern2 = (0 => 1 => 0);
                                                      bins pattern3 = (0 => 1 => 1);
                                                      bins pattern4 = (1 => 0 => 0);
                                                      bins pattern5 = (1 => 0 => 1);
                                                      bins pattern6 = (1 => 1 => 0);
                                                      bins pattern7 = (1 => 1 => 1);
                                                   }
    CP_LL_TX_PDU_LENGTH : coverpoint tx_trans.pdulength
                          {
                            bins pdu_len_min = {16'h0000} iff (tx_trans.ftype==9);
                            bins pdu_len_small = {[16'h0001:16'h01FF]} iff (tx_trans.ftype==9);
                            bins pdu_len_medium = {[16'h0200:16'h0FFF]} iff (tx_trans.ftype==9);
                            bins pdu_len_large = {[16'h1000:16'hFFFF]} iff (tx_trans.ftype==9);
                          }
    CP_LL_TX_PDU_COS : coverpoint tx_trans.cos
                          {
                            bins cos_low_range = {[0:50]} iff (tx_trans.ftype==9);
                            bins cos_mid_range = {[51:150]} iff (tx_trans.ftype==9);
                            bins cos_high_range = {[151:255]} iff (tx_trans.ftype==9);
                          }
    CP_LL_TX_PDU_MTU : coverpoint tx_trans.mtusize
                          {
                            bins mtu_range1 = {[8:24]} iff (tx_trans.ftype==9);
                            bins mtu_range2 = {[25:41]} iff (tx_trans.ftype==9);
                            bins mtu_range3 = {[42:57]} iff (tx_trans.ftype==9);
                            bins mtu_range4 = {[58:64]} iff (tx_trans.ftype==9);
                          }
    CR_LL_TX_PDU_LENGTH_MTU : cross CP_LL_TX_PDU_LENGTH, CP_LL_TX_PDU_MTU;
    CP_LL_TX_PDU_S : coverpoint tx_trans.S
                     {
                       bins pdu_S[] = {0,1} iff (tx_trans.ftype==9);
                     }
    CP_LL_TX_PDU_E : coverpoint tx_trans.E
                     {
                       bins pdu_E[] = {0,1} iff (tx_trans.ftype==9);
                     }
    CP_LL_TX_PDU_O : coverpoint tx_trans.O
                     {
                       bins pdu_O[] = {0,1} iff (tx_trans.ftype==9);
                     }
    CP_LL_TX_PDU_P : coverpoint tx_trans.P
                     {
                       bins pdu_P[] = {0,1} iff (tx_trans.ftype==9);
                     }
    CP_LL_TX_PDU_XH : coverpoint tx_trans.xh
                     {
                       bins pdu_xh[] = {0,1} iff (tx_trans.ftype==9);
                     }
    CP_LL_TX_PDU_STREAM_ID : coverpoint tx_trans.streamID
                     {
                            bins streamID_min = {16'h0000} iff (tx_trans.ftype==9);
                            bins streamID_small = {[16'h0001:16'h01FF]} iff (tx_trans.ftype==9);
                            bins streamID_medium = {[16'h0200:16'h0FFF]} iff (tx_trans.ftype==9);
                            bins streamID_large = {[16'h1000:16'hFFFF]} iff (tx_trans.ftype==9);
                            bins streamID_max = {16'hFFFF} iff (tx_trans.ftype==9);
                     }
    CR_LL_TX_PDU_SINGLE_SEGMENT : cross CP_LL_TX_PDU_O, CP_LL_TX_PDU_P, CP_LL_TX_PDU_S, CP_LL_TX_PDU_E
                                  {
                                    ignore_bins pdu_s = !binsof(CP_LL_TX_PDU_S) intersect {1};
                                    ignore_bins pdu_e = !binsof(CP_LL_TX_PDU_E) intersect {1};
                                  }
    CR_LL_TX_PDU_START_SEGMENT : cross CP_LL_TX_PDU_S, CP_LL_TX_PDU_E, CP_LL_TX_PDU_MTU
                                  {
                                    ignore_bins pdu_s = !binsof(CP_LL_TX_PDU_S) intersect {1};
                                    ignore_bins pdu_e = !binsof(CP_LL_TX_PDU_E) intersect {0};
                                  }
    CR_LL_TX_PDU_MIDDLE_SEGMENT : cross CP_LL_TX_PDU_S, CP_LL_TX_PDU_E, CP_LL_TX_PDU_MTU
                                  {
                                    ignore_bins pdu_s = !binsof(CP_LL_TX_PDU_S) intersect {0};
                                    ignore_bins pdu_e = !binsof(CP_LL_TX_PDU_E) intersect {0};
                                  }
    CR_LL_TX_PDU_LAST_SEGMENT : cross CP_LL_TX_PDU_O, CP_LL_TX_PDU_P, CP_LL_TX_PDU_S, CP_LL_TX_PDU_E, CP_LL_TX_PDU_MTU, CP_LL_TX_PDU_LENGTH
                                  {
                                    ignore_bins pdu_s = !binsof(CP_LL_TX_PDU_S) intersect {0};
                                    ignore_bins pdu_e = !binsof(CP_LL_TX_PDU_E) intersect {1};
                                    ignore_bins pdu_length = binsof(CP_LL_TX_PDU_LENGTH) intersect {0} && (binsof(CP_LL_TX_PDU_O) intersect {1} || binsof(CP_LL_TX_PDU_P) intersect {1});
                                  }
    CP_LL_TX_DATA_STREAM_INTERLEAVE : coverpoint tx_ds_pkt_interleave;
    CP_LL_TX_DATA_STREAM_FLOW_ID : coverpoint tx_trans.prio
                                   {
                                     bins maint_prio_crf0[] = {[0:2]} iff (tx_trans.crf==0 && tx_trans.ftype==9);
                                     bins maint_prio_crf1[] = {[0:2]} iff (tx_trans.crf==1 && tx_trans.ftype==9);
                                   }
    CR_LL_TX_PDU_LENGTH_MTU_FLOW_ID : cross CP_LL_TX_PDU_MTU, CP_LL_TX_PDU_LENGTH, CP_LL_TX_DATA_STREAM_FLOW_ID;
    CR_LL_TX_PDU_S_E_FLOW_ID : cross CP_LL_TX_PDU_S, CP_LL_TX_PDU_E, CP_LL_TX_DATA_STREAM_FLOW_ID;
    CP_LL_TX_TM_TMOP : coverpoint tx_trans.TMOP
                       {
                         bins tmop[] = {[0:2]} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1);
                       }
    CP_LL_TX_TM_WC : coverpoint tx_trans.wild_card
                       {
                         bins wc[] = {0, 1, 3, 7} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1);
                       }
    CP_LL_TX_TM_MASK : coverpoint tx_trans.mask
                       {
                         bins mask[] = {0, 1, 3,7,15,31,63,127,255} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1);
                       }
    CP_LL_TX_TM_PARAMETER1 : coverpoint tx_trans.parameter1
                       {
                         bins parameter1_range1[] = {0, 2, 3, 5, 6} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1);
                         bins parameter1_range2 = {[8'h10:8'h1F]} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1);
                         bins parameter1_range3 = {[8'h20:8'h2F]} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1);
                         bins parameter1_range4 = {8'h30} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1);
                       }
    CP_LL_TX_TM_PARAMETER2 : coverpoint tx_trans.parameter2
                       {
                         bins parameter2_range1 = {[00:50]} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1);
                         bins parameter2_range2 = {[51:150]} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1);
                         bins parameter2_range3 = {[151:255]} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1);
                       }
    CP_LL_TX_TM_BASIC_TRAFFIC : coverpoint tx_trans.parameter2
                                {
                                  bins bt_1[] = {0,8'hFF} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1 && tx_trans.TMOP==0 && tx_trans.parameter1==0);
                                  bins bt_Q_Status_empty = {0} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1 && tx_trans.TMOP==0 && tx_trans.parameter1==3);
                                  bins bt_Q_Status_low_range = {[1:100]} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1 && tx_trans.TMOP==0 && tx_trans.parameter1==3);
                                  bins bt_Q_Status_mid_range = {[101:200]} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1 && tx_trans.TMOP==0 && tx_trans.parameter1==3);
                                  bins bt_Q_Status_high_range = {[201:254]} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1 && tx_trans.TMOP==0 && tx_trans.parameter1==3);
                                  bins bt_Q_Status_full = {255} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1 && tx_trans.TMOP==0 && tx_trans.parameter1==3);
                                }
    CP_LL_TX_TM_RATE_BASED_TRAFFIC : coverpoint tx_trans.parameter2
                                {
                                  bins rt_param1_0[] = {0,8'hFF} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1 && tx_trans.TMOP==1 && tx_trans.parameter1==0);
                                  bins rt_param1_1_bin1[] = {[0:2]} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1 && tx_trans.TMOP==1 && tx_trans.parameter1==1);
                                  bins rt_param1_1_bin2 = {[3:255]} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1 && tx_trans.TMOP==1 && tx_trans.parameter1==1);
                                  bins rt_param1_5_bin1[] = {[0:2]} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1 && tx_trans.TMOP==1 && tx_trans.parameter1==5);
                                  bins rt_param1_5_bin2 = {[3:255]} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1 && tx_trans.TMOP==1 && tx_trans.parameter1==5);
                                  bins rt_param1_2_bin1 = {[1:254]} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1 && tx_trans.TMOP==1 && tx_trans.parameter1==2);
                                  bins rt_param1_2_bin2 = {255} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1 && tx_trans.TMOP==1 && tx_trans.parameter1==2);
                                  bins rt_param1_6_bin1 = {[1:254]} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1 && tx_trans.TMOP==1 && tx_trans.parameter1==6);
                                  bins rt_param1_6_bin2 = {255} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1 && tx_trans.TMOP==1 && tx_trans.parameter1==6);
                                  bins rt_param1_3_Q_Status_empty = {0} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1 && tx_trans.TMOP==1 && tx_trans.parameter1==3);
                                  bins rt_param1_3_Q_Status_low_range = {[1:100]} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1 && tx_trans.TMOP==1 && tx_trans.parameter1==3);
                                  bins rt_param1_3_Q_Status_mid_range = {[101:200]} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1 && tx_trans.TMOP==1 && tx_trans.parameter1==3);
                                  bins rt_param1_3_Q_Status_high_range = {[201:254]} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1 && tx_trans.TMOP==1 && tx_trans.parameter1==3);
                                  bins rt_param1_3_Q_Status_full = {255} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1 && tx_trans.TMOP==1 && tx_trans.parameter1==3);
                                }
    CP_LL_TX_TM_CREDIT_BASED_TRAFFIC : coverpoint tx_trans.parameter2
                                {
                                  bins ct_param1_0[] = {0,8'hFF} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1 && tx_trans.TMOP==2 && tx_trans.parameter1==0);
                                  bins ct_param1_1_low_range = {[0:100]} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1 && tx_trans.TMOP==2 && tx_trans.parameter1[7:4]==1);
                                  bins ct_param1_1_mid_range = {[101:200]} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1 && tx_trans.TMOP==2 && tx_trans.parameter1[7:4]==1);
                                  bins ct_param1_1_high_range = {[201:255]} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1 && tx_trans.TMOP==2 && tx_trans.parameter1[7:4]==1);
                                  bins ct_param1_2_low_range = {[0:100]} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1 && tx_trans.TMOP==2 && tx_trans.parameter1[7:4]==2);
                                  bins ct_param1_2_mid_range = {[101:200]} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1 && tx_trans.TMOP==2 && tx_trans.parameter1[7:4]==2);
                                  bins ct_param1_2_high_range = {[201:255]} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1 && tx_trans.TMOP==2 && tx_trans.parameter1[7:4]==2);
                                  bins ct_param1_30_empty = {0} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1 && tx_trans.TMOP==2 && tx_trans.parameter1==8'h30);
                                  bins ct_param1_30_low_range = {[1:100]} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1 && tx_trans.TMOP==2 && tx_trans.parameter1==8'h30);
                                  bins ct_param1_30_mid_range = {[101:200]} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1 && tx_trans.TMOP==2 && tx_trans.parameter1==8'h30);
                                  bins ct_param1_30_high_range = {[201:254]} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1 && tx_trans.TMOP==2 && tx_trans.parameter1==8'h30);
                                  bins ct_param1_30_full = {255} iff (tx_trans.ftype==9 && tx_trans.xtype==0 && tx_trans.xh==1 && tx_trans.TMOP==2 && tx_trans.parameter1==8'h30);
                                }
    CP_LL_TX_XON_XOFF : coverpoint tx_trans.xon_xoff
                        {
                          bins xon_xoff[] = {0, 1} iff (tx_trans.ftype==7);
                        }
    CP_LL_TX_FLOW_CTRL_FLOW_ID : coverpoint tx_trans.flowID
                        {
                          bins flowID[] = {[0:5], [8'h41:8'h48]} iff (tx_trans.ftype==7);
                        }
    CP_LL_TX_FLOW_DEST_ID : coverpoint tx_trans.DestinationID
                            {
                              bins valid_bins = {[0:32'hFFFF_FFFF]} iff (tx_trans.ftype==7);
                            }
    CP_LL_TX_FLOW_TGT_DEST_ID : coverpoint tx_trans.tgtdestID
                            {
                              bins valid_bins = {[0:32'hFFFF_FFFF]} iff (tx_trans.ftype==7);
                            }
    CP_LL_TX_FLOW_CTRL_FAM : coverpoint tx_trans.FAM
                        {
                          bins fam[] = {0, [2:7]} iff (tx_trans.ftype==7);
                        }
    CP_LL_TX_FLOW_CTRL_SOC : coverpoint tx_trans.SOC
                        {
                          bins soc[] = {0, 1} iff (tx_trans.ftype==7);
                        }
    CR_LL_TX_FLOW_CTRL_XON_XOFF_FLOW_ID_FAM : cross CP_LL_TX_XON_XOFF, CP_LL_TX_FLOW_CTRL_FAM, CP_LL_TX_FLOW_CTRL_FLOW_ID
                                              {
                                                ignore_bins fam_xoff = binsof(CP_LL_TX_XON_XOFF) intersect {0} && binsof(CP_LL_TX_FLOW_CTRL_FAM) intersect {6, 7};
                                              }                             
    CP_LL_TX_FLOW_CTRL_PIPELINE_REQ_SINGLE_PDU : coverpoint tx_single_pdu_pipeline;
    CP_LL_TX_FLOW_CTRL_PIPELINE_REQ_MULTI_PDU : coverpoint tx_multi_pdu_pipeline;
  endgroup: CG_LL_TX_PATH
  
  covergroup CG_LL_RX_PATH @(rx_trans_event);
    option.per_instance = 1;
    CP_LL_RX_TXN_ID: coverpoint rx_trans.SrcTID
                     {
                       bins low_range = {[0:50]};
                       bins mid_range = {[51:150]};
                       bins high_range = {[151:255]};
                     }
    CP_LL_RX_ATOMIC_TYPES : coverpoint rx_trans.ttype
                            { 
                              bins type2_atomic[] =  {12, 13, 14, 15} iff (rx_trans.ftype == 2);
                              bins type5_atomic[] =  {12, 13, 14} iff (rx_trans.ftype == 5);
                            }

    CP_LL_RX_FTYPE: coverpoint rx_trans.ftype
                    {
                      bins ftype[] = {2, 5, 6, 7, 8, 9, 10, 11, 13};
                    }
    CP_LL_RX_TTYPE: coverpoint rx_trans.ttype
                    {
                      bins ttype[] = {[0:15]};
                    }
    CP_LL_RX_TYPE2_TTYPE : coverpoint rx_trans.ttype
                     {
                       bins type2_ttype[] = {4, 12, 13, 14, 15} iff (rx_trans.ftype == 2);
                     }
    CP_LL_RX_TYPE5_TTYPE : coverpoint rx_trans.ttype
                     {
                       bins type5_ttype[] = {4, 5, 12, 13, 14} iff (rx_trans.ftype == 5);
                     }
    CP_LL_RX_NREAD_RESP_TYPE : coverpoint rx_nread_resp_type
                               {
                                 bins resp_type[] = {0, 8};
                               }
    CP_LL_RX_NWRITE_R_RESP_TYPE : coverpoint rx_nwrite_r_resp_type
                                  {
                                    bins resp_type[] = {0};
                                  }
    CP_LL_RX_NREAD_RESP_STATUS : coverpoint rx_nread_resp_status
                                 {
                                   bins resp_status[] = {0, 7};
                                 }
    CP_LL_RX_NWRITE_R_RESP_STATUS : coverpoint rx_nwrite_r_resp_status
                                    {
                                      bins resp_status[] = {0, 7};
                                    }
    CP_LL_RX_TYPE8_TTYPE : coverpoint rx_trans.ttype
                     {
                       bins type8_ttype[] = {[0:4]} iff (rx_trans.ftype == 8);
                     }
    CP_LL_RX_TYPE10_TTYPE : coverpoint rx_trans.ttype
                     {
                       bins type10_ttype = {0} iff (rx_trans.ftype == 10);
                     }
    CP_LL_RX_TYPE11_TTYPE : coverpoint rx_trans.ttype
                     {
                       bins type11_ttype = {0} iff (rx_trans.ftype == 11);
                     }
    CP_LL_RX_TYPE13_TTYPE : coverpoint rx_trans.ttype
                     {
                       bins type13_ttype[] = {0, 1, 8} iff (rx_trans.ftype == 13);
                     }
    CP_LL_RX_WDPTR  : coverpoint rx_trans.wdptr;
    CP_LL_RX_WRSIZE : coverpoint rx_trans.wrsize;
    CP_LL_RX_RDSIZE : coverpoint rx_trans.rdsize;
    CP_LL_RX_ADDR : coverpoint rx_trans.address
                    {
                      bins address_lower_range = {[29'h00000000:29'h01FFFFFF]};
                      bins address_middle_range = {[29'h02000000:29'h0EFFFFFF]};
                      bins address_high_range = {[29'h0F000000:29'h1FFFFFFF]};
                    }
    CP_LL_RX_EXT_ADDR : coverpoint rx_trans.ext_address
                    {
                      bins address_lower_range = {[32'h00000000:32'h1FFFFFFF]};
                      bins address_middle_range = {[32'h20000000:32'h9FFFFFFF]};
                      bins address_high_range = {[32'hA0000000:32'hFFFFFFFF]};
                    }
    CP_LL_RX_XAMSBS : coverpoint rx_trans.xamsbs;
    CR_LL_RX_TYPE2_WDPTR_RDSIZE : cross CP_LL_RX_TYPE2_TTYPE, CP_LL_RX_WDPTR, CP_LL_RX_RDSIZE;
    CR_LL_RX_TYPE5_WDPTR_WRSIZE : cross CP_LL_RX_TYPE5_TTYPE, CP_LL_RX_WDPTR, CP_LL_RX_WRSIZE
                                  {
                                        ignore_bins bin1 = binsof (CP_LL_RX_TYPE5_TTYPE) intersect {4,5} && binsof (CP_LL_RX_WDPTR) intersect {0} && binsof (CP_LL_RX_WRSIZE) intersect {13};
                                  }
    CR_LL_RX_TYPE5_ATOMIC_VALID_SIZE : cross CP_LL_RX_TYPE5_TTYPE,CP_LL_RX_WDPTR, CP_LL_RX_WRSIZE
                                       {
                                        ignore_bins bin1 = binsof (CP_LL_RX_TYPE5_TTYPE) intersect {4,5};
                                        ignore_bins bin2 = binsof (CP_LL_RX_WDPTR) intersect {1} && binsof (CP_LL_RX_TYPE5_TTYPE) intersect {13};
                                        ignore_bins bin3 = binsof (CP_LL_RX_WRSIZE) intersect {5, 7, [9:15]} && binsof (CP_LL_RX_TYPE5_TTYPE) 
                                                           intersect {12,14};
                                        ignore_bins bin4 = binsof (CP_LL_RX_WRSIZE) intersect {[0:10], [12:15]} && binsof (CP_LL_RX_TYPE5_TTYPE) 
                                                           intersect {13} && binsof (CP_LL_RX_WDPTR) intersect {0};
                                       }
    CR_LL_RX_TYPE2_ATOMIC_VALID_SIZE : cross CP_LL_RX_TYPE2_TTYPE, CP_LL_RX_WDPTR,CP_LL_RX_RDSIZE
                                       {
                                        ignore_bins bin1 = binsof (CP_LL_RX_TYPE2_TTYPE) intersect {4};
                                        ignore_bins bin2 = binsof (CP_LL_RX_RDSIZE) intersect {5, 7, [9:15]} && binsof (CP_LL_RX_TYPE2_TTYPE) 
                                                           intersect {12,13,14,15};
                                       }
    CR_LL_RX_TYPE5_ATOMIC_INVALID_SIZE : cross CP_LL_RX_TYPE5_TTYPE,CP_LL_RX_WDPTR, CP_LL_RX_WRSIZE
                                         {
                                          ignore_bins bin1 = binsof (CP_LL_RX_TYPE5_TTYPE) intersect {4,5};
                                          ignore_bins bin2 = binsof (CP_LL_RX_WRSIZE) intersect {11} && binsof (CP_LL_RX_WDPTR) intersect {0} && 
                                                             binsof (CP_LL_RX_TYPE5_TTYPE) intersect {13};
                                          ignore_bins bin3 = binsof (CP_LL_RX_WRSIZE) intersect {[0:4],6,8} && binsof (CP_LL_RX_TYPE5_TTYPE) 
                                                             intersect {12,14};
                                         }
    CR_LL_RX_TYPE2_ATOMIC_INVALID_SIZE : cross CP_LL_RX_TYPE2_TTYPE, CP_LL_RX_WDPTR,CP_LL_RX_RDSIZE
                                         {
                                          ignore_bins bin1 = binsof (CP_LL_RX_TYPE2_TTYPE) intersect {4};
                                          ignore_bins bin2 = binsof (CP_LL_RX_RDSIZE) intersect {[0:4], 6, 8} && binsof (CP_LL_RX_TYPE2_TTYPE) 
                                                           intersect {12,13,14,15};
                                         }
    CP_LL_RX_ATOMIC_INC_RESP_TYPE : coverpoint rx_atomic_inc_resp_type
                                    {
                                      bins resp_type[] = {0, 8};
                                    }
    CP_LL_RX_ATOMIC_INC_RESP_STATUS : coverpoint rx_atomic_inc_resp_status
                                    {
                                      bins resp_status[] = {0, 7};
                                    }
    CP_LL_RX_ATOMIC_DEC_RESP_TYPE : coverpoint rx_atomic_dec_resp_type
                                    {
                                      bins resp_type[] = {0, 8};
                                    }
    CP_LL_RX_ATOMIC_DEC_RESP_STATUS : coverpoint rx_atomic_dec_resp_status
                                    {
                                      bins resp_status[] = {0, 7};
                                    }
    CP_LL_RX_ATOMIC_SET_RESP_TYPE : coverpoint rx_atomic_set_resp_type
                                    {
                                      bins resp_type[] = {0, 8};
                                    }
    CP_LL_RX_ATOMIC_SET_RESP_STATUS : coverpoint rx_atomic_set_resp_status
                                    {
                                      bins resp_status[] = {0, 7};
                                    }
    CP_LL_RX_ATOMIC_CLR_RESP_TYPE : coverpoint rx_atomic_clr_resp_type
                                    {
                                      bins resp_type[] = {0, 8};
                                    }
    CP_LL_RX_ATOMIC_CLR_RESP_STATUS : coverpoint rx_atomic_clr_resp_status
                                    {
                                      bins resp_status[] = {0, 7};
                                    }
    CP_LL_RX_ATOMIC_SWAP_RESP_TYPE : coverpoint rx_atomic_swap_resp_type
                                    {
                                      bins resp_type[] = {0, 8};
                                    }
    CP_LL_RX_ATOMIC_SWAP_RESP_STATUS : coverpoint rx_atomic_swap_resp_status
                                    {
                                      bins resp_status[] = {0, 7};
                                    }
    CP_LL_RX_ATOMIC_COMP_RESP_TYPE : coverpoint rx_atomic_comp_resp_type
                                    {
                                      bins resp_type[] = {0, 8};
                                    }
    CP_LL_RX_ATOMIC_COMP_RESP_STATUS : coverpoint rx_atomic_comp_resp_status
                                    {
                                      bins resp_status[] = {0, 7};
                                    }
    CP_LL_RX_ATOMIC_TEST_RESP_TYPE : coverpoint rx_atomic_test_resp_type
                                    {
                                      bins resp_type[] = {0, 8};
                                    }
    CP_LL_RX_ATOMIC_TEST_RESP_STATUS : coverpoint rx_atomic_test_resp_status
                                    {
                                      bins resp_status[] = {0, 7};
                                    }
    CR_LL_RX_FTYPE_XAMSBS_SRCTID : cross CP_LL_RX_FTYPE, CP_LL_RX_XAMSBS, CP_LL_RX_TXN_ID
                                   {
                                     ignore_bins bin1 = binsof(CP_LL_RX_FTYPE) intersect {7, 8, 9, 10, 11, 13} && binsof(CP_LL_RX_XAMSBS);
                                   }
    CR_LL_RX_MAINT_RD_WDPTR_RDSIZE : cross CP_LL_RX_TYPE8_TTYPE, CP_LL_RX_WDPTR, CP_LL_RX_RDSIZE
                               {
                                 ignore_bins bin1 = !binsof(CP_LL_RX_RDSIZE) intersect {8, 11, 12};
                                 ignore_bins bin2 = !binsof (CP_LL_RX_TYPE8_TTYPE) intersect {0};
                               }
    CR_LL_RX_MAINT_WR_WDPTR_WRSIZE : cross CP_LL_RX_TYPE8_TTYPE, CP_LL_RX_WDPTR, CP_LL_RX_WRSIZE
                               {
                                 ignore_bins bin1 = !binsof(CP_LL_RX_WRSIZE) intersect {8, 11, 12};
                                 ignore_bins bin2 = !binsof (CP_LL_RX_TYPE8_TTYPE) intersect {1};
                               }
    CP_LL_RX_MAINT_CONFIG_OFFSET : coverpoint rx_trans.config_offset 
                                   {
                                     bins offset1 = {[20'h00000 : 20'h000FF]} iff (rx_trans.ftype==8 && (rx_trans.ttype==0 || rx_trans.ttype==1));
                                     bins offset2 = {[20'h00100 : 20'h001FF]} iff (rx_trans.ftype==8 && (rx_trans.ttype==0 || rx_trans.ttype==1));
                                     bins offset3 = {[20'h00200 : 20'h003FF]} iff (rx_trans.ftype==8 && (rx_trans.ttype==0 || rx_trans.ttype==1));
                                     bins offset4 = {[20'h00600 : 20'h006FF]} iff (rx_trans.ftype==8 && (rx_trans.ttype==0 || rx_trans.ttype==1));
                                     bins offset5 = {[20'h00800 : 20'h008FF]} iff (rx_trans.ftype==8 && (rx_trans.ttype==0 || rx_trans.ttype==1));
                                   }
    CP_LL_RX_MAINT_SRCTID : coverpoint rx_trans.SrcTID 
                            {
                              bins srctid_range0_ttype0 = {[0:50]}   iff (rx_trans.ftype==8 && rx_trans.ttype==0);
                              bins srctid_range1_ttype0 = {[51:150]} iff (rx_trans.ftype==8 && rx_trans.ttype==0);
                              bins srctid_range2_ttype0 = {[151:255]} iff (rx_trans.ftype==8 && rx_trans.ttype==0);
                              bins srctid_range0_ttype1 = {[0:50]}    iff (rx_trans.ftype==8 && rx_trans.ttype==1);
                              bins srctid_range1_ttype1 = {[51:150]}  iff (rx_trans.ftype==8 && rx_trans.ttype==1);
                              bins srctid_range2_ttype1 = {[151:255]} iff (rx_trans.ftype==8 && rx_trans.ttype==1);
                            }
    CP_LL_RX_MAINT_TARGET_TID : coverpoint rx_trans.targetID_Info
                                {
                                  bins tgtid_range0_ttype2 = {[0:50]} iff (rx_trans.ftype==8 && rx_trans.ttype==2);
                                  bins tgtid_range1_ttype2 = {[51:150]} iff (rx_trans.ftype==8 && rx_trans.ttype==2);
                                  bins tgtid_range2_ttype2 = {[151:255]} iff (rx_trans.ftype==8 && rx_trans.ttype==2);
                                  bins tgtid_range0_ttype3 = {[0:50]} iff (rx_trans.ftype==8 && rx_trans.ttype==3);
                                  bins tgtid_range1_ttype3 = {[51:150]} iff (rx_trans.ftype==8 && rx_trans.ttype==3);
                                  bins tgtid_range2_ttype3 = {[151:255]} iff (rx_trans.ftype==8 && rx_trans.ttype==3);
                                }
    CP_LL_RX_MAINT_STATUS : coverpoint rx_trans.trans_status
                            {
                              bins trans_status_ttype2[] = {0, 7} iff (rx_trans.ftype==8 && rx_trans.ttype==2);
                              bins trans_status_ttype3[] = {0, 7} iff (rx_trans.ftype==8 && rx_trans.ttype==3);
                            }
    CP_LL_RX_RESP_TXN : coverpoint rx_trans.ttype
                        {
                         bins type13_with_no_data_payload = {0} iff (rx_trans.ftype == 13);
                         bins type13_with_data_payload = {8} iff (rx_trans.ftype == 13);
                        }

    CP_LL_RX_RESP_TARGET_TID : coverpoint rx_trans.targetID_Info
                                {
                                  bins tgtid_range0_ttype0 = {[0:50]} iff (rx_trans.ftype==13 && rx_trans.ttype==0);
                                  bins tgtid_range1_ttype0 = {[51:150]} iff (rx_trans.ftype==13 && rx_trans.ttype==0);
                                  bins tgtid_range2_ttype0 = {[151:255]} iff (rx_trans.ftype==13 && rx_trans.ttype==0);
                                  bins tgtid_range0_ttype8 = {[0:50]} iff (rx_trans.ftype==13 && rx_trans.ttype==8);
                                  bins tgtid_range1_ttype8 = {[51:150]} iff (rx_trans.ftype==13 && rx_trans.ttype==8);
                                  bins tgtid_range2_ttype8 = {[151:255]} iff (rx_trans.ftype==13 && rx_trans.ttype==8);
                                }
    CP_LL_RX_IO_RESP_STATUS : coverpoint rx_trans.trans_status
                                {
                                  bins trans_sts_ttype0[] = {0, 7} iff (rx_trans.ftype==13  && rx_trans.ttype==0);
                                  bins trans_sts_ttype8[] = {0, 7} iff (rx_trans.ftype==13  && rx_trans.ttype==8);
                                }
    CP_LL_RX_MSG_MSGLEN : coverpoint rx_trans.msg_len
                          {
                            bins msg_len[] = {[0:15]} iff (rx_trans.ftype==11);
                          }
    CP_LL_RX_MSG_MSGSEG : coverpoint rx_trans.msgseg_xmbox
                          {
                               bins msg_seg[] = {[0:15]} iff (rx_trans.ftype==11 && rx_trans.msg_len !=0);
                          }
    CP_LL_RX_MSG_XMBOX : coverpoint rx_trans.msgseg_xmbox
                             {
                               bins msg_xmbox_range1 = {[0:3]} iff (rx_trans.ftype==11 && rx_trans.msg_len==0);
                               bins msg_xmbox_range2 = {[4:7]} iff (rx_trans.ftype==11 && rx_trans.msg_len==0);
                               bins msg_xmbox_range3 = {[8:11]} iff (rx_trans.ftype==11 && rx_trans.msg_len==0);
                               bins msg_xmbox_range4 = {[12:15]} iff (rx_trans.ftype==11 && rx_trans.msg_len==0);
                             }
    CP_LL_RX_MSG_MBOX : coverpoint rx_trans.mbox
                             {
                               bins msg_mbox[] = {[0:3]} iff (rx_trans.ftype==11);
                             }
    CP_LL_RX_MSG_SSIZE : coverpoint rx_trans.ssize
                             {
                               bins msg_ssize[] = {[9:14]} iff (rx_trans.ftype==11);
                             }
    CP_LL_RX_MSG_LETTER : coverpoint rx_trans.letter
                             {
                               bins msg_letter[] = {[0:3]} iff (rx_trans.ftype==11);
                             }
    CR_LL_RX_MSG_SINGLE_XMBOX_MBOX_LETTER : cross CP_LL_RX_MSG_XMBOX, CP_LL_RX_MSG_MBOX, CP_LL_RX_MSG_LETTER;
    CR_LL_RX_MSG_MULTI_SEG_SSIZE_MBOX_LETTER : cross CP_LL_RX_MSG_MSGLEN, CP_LL_RX_MSG_SSIZE, CP_LL_RX_MSG_MBOX, CP_LL_RX_MSG_LETTER
                                               {
                                                // ignore_bins single_seg = binsof(CP_LL_RX_MSG_MSGLEN) intersect {0};
                                               }
    CP_LL_RX_MSG_OUT_ORDER : coverpoint rx_msg_out_of_order;
    CP_LL_RX_MSG_INTERLEAVE : coverpoint rx_msg_interleave;
    CP_LL_RX_DOORBELL_RESP_TYPE : coverpoint rx_doorbell_resp_type
                                  {
                                    bins resp_type = {0};
                                  }
    CP_LL_RX_DOORBELL_RESP_STATUS : coverpoint rx_doorbell_resp_status
                                  {
                                    bins resp_status[] = {0, 3, 7};
                                  }
    CP_LL_RX_MSG_RESP_TYPE : coverpoint rx_trans.ttype
                                  {
                                    bins resp_type = {1} iff (rx_trans.ftype=='hd);
                                  }
    CP_LL_RX_MSG_RESP_STATUS : coverpoint rx_trans.trans_status
                                  {
                                    bins resp_status[] = {0, 3, 7} iff (rx_trans.ftype=='hd && rx_trans.ttype=='h1);
                                  }
    CP_LL_RX_MSG_RESP_TARGET_TID : coverpoint rx_trans.targetID_Info
                               {
                                 bins target_range1_info = {[8'd0:8'd50]} iff (rx_trans.ftype=='hd && rx_trans.ttype=='h1);
                                 bins target_range2_info = {[8'd51:8'd150]} iff (rx_trans.ftype=='hd && rx_trans.ttype=='h1);
                                 bins target_range3_info = {[8'd151:8'd255]} iff (rx_trans.ftype=='hd && rx_trans.ttype=='h1);
                               }
    CR_LL_RX_MSG_RESP_STATUS_TARGET_TID : cross CP_LL_RX_MSG_RESP_STATUS, CP_LL_RX_MSG_RESP_TARGET_TID;
    CP_LL_RX_MSG_PRIORITY : coverpoint rx_trans.prio
                              {
                                bins msg_prio_crf0[] = {[0:2]} iff (rx_trans.crf==0 && rx_trans.ftype==11);
                                bins msg_prio_crf1[] = {[0:2]} iff (rx_trans.crf==1 && rx_trans.ftype==11);
                              }
    CP_TL_RX_TT_VALID : coverpoint rx_trans.tt
                        {
                          bins valid_tt[] = {[0:2]};
                        }
    CR_RX_TT_FTYPE : cross CP_LL_RX_FTYPE, CP_TL_RX_TT_VALID;
    CR_RX_TT_TTYPE : cross CP_LL_RX_TTYPE, CP_TL_RX_TT_VALID;
    CR_RX_TT_TYPE2_TTYPE : cross CP_TL_RX_TT_VALID, CP_LL_RX_TYPE2_TTYPE;
    CR_RX_TT_TYPE5_TTYPE : cross CP_TL_RX_TT_VALID, CP_LL_RX_TYPE5_TTYPE;
    CR_RX_TT_TYPE8_TTYPE : cross CP_TL_RX_TT_VALID, CP_LL_RX_TYPE8_TTYPE;
    CR_RX_TT_TYPE10_TTYPE : cross CP_TL_RX_TT_VALID, CP_LL_RX_TYPE10_TTYPE;
    CR_RX_TT_TYPE11_TTYPE : cross CP_TL_RX_TT_VALID, CP_LL_RX_TYPE11_TTYPE;
    CR_RX_TT_TYPE13_TTYPE : cross CP_TL_RX_TT_VALID, CP_LL_RX_TYPE13_TTYPE;
    CP_LL_RX_GSM_REQ_TTYPE : coverpoint rx_trans.ttype
                             {
                               bins type1_gsm_type[] = {[0:2]} iff (rx_trans.ftype==1);
                               bins type2_gsm_type[] = {[0:3], [5:11]} iff (rx_trans.ftype==2);
                               bins type5_gsm_type[] = {0, 1} iff (rx_trans.ftype==5);
                             }
    CP_LL_RX_GSM_SRCTID : coverpoint rx_trans.SrcTID 
                            {
                              bins srctid_range0_ftype1 = {[0:50]}   iff (rx_trans.ftype==1);
                              bins srctid_range1_ftype1 = {[51:150]} iff (rx_trans.ftype==1) ;
                              bins srctid_range2_ftype1 = {[151:255]} iff (rx_trans.ftype==1);
                              bins srctid_range0_ftype2 = {[0:50]}    iff (rx_trans.ftype==2);
                              bins srctid_range1_ftype2 = {[51:150]}  iff (rx_trans.ftype==2);
                              bins srctid_range2_ftype2 = {[151:255]} iff (rx_trans.ftype==2);
                              bins srctid_range0_ftype5 = {[0:50]}    iff (rx_trans.ftype==5);
                              bins srctid_range1_ftype5 = {[51:150]}  iff (rx_trans.ftype==5);
                              bins srctid_range2_ftype5 = {[151:255]} iff (rx_trans.ftype==5);
                            }
    CR_LL_RX_GSM_REQ_SRCTID : cross CP_LL_RX_GSM_REQ_TTYPE, CP_LL_RX_GSM_SRCTID
                              {
                                ignore_bins type1_en = binsof(CP_LL_RX_GSM_REQ_TTYPE.type1_gsm_type) && (binsof(CP_LL_RX_GSM_SRCTID.srctid_range0_ftype2) ||  binsof(CP_LL_RX_GSM_SRCTID.srctid_range1_ftype2) || binsof(CP_LL_RX_GSM_SRCTID.srctid_range2_ftype2) || binsof(CP_LL_RX_GSM_SRCTID.srctid_range0_ftype5) ||  binsof(CP_LL_RX_GSM_SRCTID.srctid_range1_ftype5) || binsof(CP_LL_RX_GSM_SRCTID.srctid_range2_ftype5) );
                                ignore_bins type2_en = binsof(CP_LL_RX_GSM_REQ_TTYPE.type2_gsm_type) && (binsof(CP_LL_RX_GSM_SRCTID.srctid_range0_ftype1) ||  binsof(CP_LL_RX_GSM_SRCTID.srctid_range1_ftype1) || binsof(CP_LL_RX_GSM_SRCTID.srctid_range2_ftype1) || binsof(CP_LL_RX_GSM_SRCTID.srctid_range0_ftype5) ||  binsof(CP_LL_RX_GSM_SRCTID.srctid_range1_ftype5) || binsof(CP_LL_RX_GSM_SRCTID.srctid_range2_ftype5) );
                                ignore_bins type5_en = binsof(CP_LL_RX_GSM_REQ_TTYPE.type5_gsm_type) && (binsof(CP_LL_RX_GSM_SRCTID.srctid_range0_ftype1) ||  binsof(CP_LL_RX_GSM_SRCTID.srctid_range1_ftype1) || binsof(CP_LL_RX_GSM_SRCTID.srctid_range2_ftype1) || binsof(CP_LL_RX_GSM_SRCTID.srctid_range0_ftype2) ||  binsof(CP_LL_RX_GSM_SRCTID.srctid_range1_ftype2) || binsof(CP_LL_RX_GSM_SRCTID.srctid_range2_ftype2) );
                              }
    CR_LL_RX_GSM_REQ_WDPTR_WRSIZE : cross CP_LL_RX_GSM_REQ_TTYPE, CP_LL_RX_WDPTR, CP_LL_RX_WRSIZE
                                    {
                                      ignore_bins wrsize_reserved = binsof(CP_LL_RX_WRSIZE) intersect {[13:15]};
                                      ignore_bins type1_2_pkts = !binsof(CP_LL_RX_GSM_REQ_TTYPE.type5_gsm_type);
                                    }
    CR_LL_RX_GSM_REQ_WDPTR_RDSIZE : cross CP_LL_RX_GSM_REQ_TTYPE, CP_LL_RX_WDPTR, CP_LL_RX_RDSIZE
                                    {
                                      ignore_bins rdsize_reserved = binsof(CP_LL_RX_RDSIZE) intersect {[13:15]};
                                      ignore_bins type5_pkts = binsof(CP_LL_RX_GSM_REQ_TTYPE.type5_gsm_type);
                                      ignore_bins addr_only_txns = !binsof(CP_LL_RX_GSM_REQ_TTYPE) intersect {3, 5, 6, 7, 9, 10, 11} && binsof(CP_LL_RX_RDSIZE) intersect {0} && binsof(CP_LL_RX_WDPTR) intersect {0};
                                    }
    CP_LL_RX_GSM_RD_O_RESP_TYPE : coverpoint rx_gsm_rd_o_resp_type
                                  {
                                    bins resp_type[] = {0, 8};
                                  }
    CP_LL_RX_GSM_RD_O_RESP_STATUS : coverpoint rx_gsm_rd_o_resp_status
                                  {
                                    bins resp_status[] = {3, 4, 7};
                                  }
    CP_LL_RX_GSM_RD_O_O_RESP_TYPE : coverpoint rx_gsm_rd_o_o_resp_type
                                  {
                                    bins resp_type[] = {0, 8};
                                  }
    CP_LL_RX_GSM_RD_O_O_RESP_STATUS : coverpoint rx_gsm_rd_o_o_resp_status
                                  {
                                    bins resp_status[] = {3, 4, 7};
                                  }
    CP_LL_RX_GSM_IO_RD_O_RESP_TYPE : coverpoint rx_gsm_io_rd_o_resp_type
                                  {
                                    bins resp_type[] = {0, 8};
                                  }
    CP_LL_RX_GSM_IO_RD_O_RESP_STATUS : coverpoint rx_gsm_io_rd_o_resp_status
                                  {
                                    bins resp_status[] = {3, 4, 7};
                                  }
    CP_LL_RX_GSM_RD_H_RESP_TYPE : coverpoint rx_gsm_rd_h_resp_type
                                  {
                                    bins resp_type[] = {0, 8};
                                  }
    CP_LL_RX_GSM_RD_H_RESP_STATUS : coverpoint rx_gsm_rd_h_resp_status
                                  {
                                    bins resp_status[] = {0, 1, 3, 5, 7};
                                  }
    CP_LL_RX_GSM_RD_O_H_RESP_TYPE : coverpoint rx_gsm_rd_o_h_resp_type
                                  {
                                    bins resp_type[] = {0, 8};
                                  }
    CP_LL_RX_GSM_RD_O_H_RESP_STATUS : coverpoint rx_gsm_rd_o_h_resp_status
                                  {
                                    bins resp_status[] = {0, 1, 3, 5, 7};
                                  }
    CP_LL_RX_GSM_IO_RD_H_RESP_TYPE : coverpoint rx_gsm_io_rd_h_resp_type
                                  {
                                    bins resp_type[] = {0, 8};
                                  }
    CP_LL_RX_GSM_IO_RD_H_RESP_STATUS : coverpoint rx_gsm_io_rd_h_resp_status
                                  {
                                    bins resp_status[] = {0, 1, 3, 5, 7};
                                  }
    CP_LL_RX_GSM_D_H_RESP_TYPE : coverpoint rx_gsm_d_h_resp_type
                                  {
                                    bins resp_type[] = {0};
                                  }
    CP_LL_RX_GSM_D_H_RESP_STATUS : coverpoint rx_gsm_d_h_resp_status
                                  {
                                    bins resp_status[] = {0, 3, 7};
                                  }
    CP_LL_RX_GSM_I_H_RESP_TYPE : coverpoint rx_gsm_i_h_resp_type
                                  {
                                    bins resp_type[] = {0};
                                  }
    CP_LL_RX_GSM_I_H_RESP_STATUS : coverpoint rx_gsm_i_h_resp_status
                                  {
                                    bins resp_status[] = {0, 3, 7};
                                  }
    CP_LL_RX_GSM_TLBIE_RESP_TYPE : coverpoint rx_gsm_tlbie_resp_type
                                  {
                                    bins resp_type[] = {0};
                                  }
    CP_LL_RX_GSM_TLBIE_RESP_STATUS : coverpoint rx_gsm_tlbie_resp_status
                                  {
                                    bins resp_status[] = {0, 3, 7};
                                  }
    CP_LL_RX_GSM_TLBSYNC_RESP_TYPE : coverpoint rx_gsm_tlbsync_resp_type
                                  {
                                    bins resp_type[] = {0};
                                  }
    CP_LL_RX_GSM_TLBSYNC_RESP_STATUS : coverpoint rx_gsm_tlbsync_resp_status
                                  {
                                    bins resp_status[] = {0, 3, 7};
                                  }
    CP_LL_RX_GSM_IRD_H_RESP_TYPE : coverpoint rx_gsm_ird_h_resp_type
                                  {
                                    bins resp_type[] = {0, 8};
                                  }
    CP_LL_RX_GSM_IRD_H_RESP_STATUS : coverpoint rx_gsm_ird_h_resp_status
                                  {
                                    bins resp_status[] = {0, 1, 3, 5, 7};
                                  }
    CP_LL_RX_GSM_FLUSH_WO_D_RESP_TYPE : coverpoint rx_gsm_flush_wo_d_resp_type
                                  {
                                    bins resp_type[] = {0};
                                  }
    CP_LL_RX_GSM_FLUSH_WO_D_RESP_STATUS : coverpoint rx_gsm_flush_wo_d_resp_status
                                  {
                                    bins resp_status[] = {0, 3, 7};
                                  }
    CP_LL_RX_GSM_IK_SH_RESP_TYPE : coverpoint rx_gsm_ik_sh_resp_type
                                  {
                                    bins resp_type[] = {0};
                                  }
    CP_LL_RX_GSM_IK_SH_RESP_STATUS : coverpoint rx_gsm_ik_sh_resp_status
                                  {
                                    bins resp_status[] = {0, 3, 7};
                                  }
    CP_LL_RX_GSM_DK_SH_RESP_TYPE : coverpoint rx_gsm_dk_sh_resp_type
                                  {
                                    bins resp_type[] = {0};
                                  }
    CP_LL_RX_GSM_DK_SH_RESP_STATUS : coverpoint rx_gsm_dk_sh_resp_status
                                  {
                                    bins resp_status[] = {0, 3, 7};
                                  }
    CP_LL_RX_GSM_CASTOUT_RESP_TYPE : coverpoint rx_gsm_castout_resp_type
                                  {
                                    bins resp_type[] = {0};
                                  }
    CP_LL_RX_GSM_CASTOUT_RESP_STATUS : coverpoint rx_gsm_castout_resp_status
                                  {
                                    bins resp_status[] = {0, 3, 7};
                                  }
    CP_LL_RX_GSM_FLUSH_WD_RESP_TYPE : coverpoint rx_gsm_flush_wd_resp_type
                                  {
                                    bins resp_type[] = {0};
                                  }
    CP_LL_RX_GSM_FLUSH_WD_RESP_STATUS : coverpoint rx_gsm_flush_wd_resp_status
                                  {
                                    bins resp_status[] = {0, 3, 7};
                                  }
    CP_LL_RX_IO_ERROR_RESP : coverpoint rx_trans.trans_status
                             {
                               bins resp_status = {7} iff (rx_trans.ftype==13 && rx_trans.ttype==0);
                             }
    CP_LL_RX_MSG_ERROR_RESP : coverpoint rx_trans.trans_status
                              {
                                bins resp_status = {7} iff (rx_trans.ftype==13 && rx_trans.ttype==1);
                              }
    CP_LL_RX_GSM_ERROR_RESP : coverpoint rx_gsm_resp_status
                              {
                                bins resp_status = {7};
                              }
    CP_LL_RX_PDU_LENGTH : coverpoint rx_trans.pdulength
                          {
                            bins pdu_len_min = {16'h0000} iff (rx_trans.ftype==9);
                            bins pdu_len_small = {[16'h0001:16'h01FF]} iff (rx_trans.ftype==9);
                            bins pdu_len_medium = {[16'h0200:16'h0FFF]} iff (rx_trans.ftype==9);
                            bins pdu_len_large = {[16'h1000:16'hFFFF]} iff (rx_trans.ftype==9);
                          }
    CP_LL_RX_PDU_COS : coverpoint rx_trans.cos
                          {
                            bins cos_low_range = {[0:50]} iff (rx_trans.ftype==9);
                            bins cos_mid_range = {[51:150]} iff (rx_trans.ftype==9);
                            bins cos_high_range = {[151:255]} iff (rx_trans.ftype==9);
                          }
    CP_LL_RX_PDU_MTU : coverpoint rx_trans.mtusize
                          {
                            bins mtu_range1 = {[8:24]} iff (rx_trans.ftype==9);
                            bins mtu_range2 = {[25:41]} iff (rx_trans.ftype==9);
                            bins mtu_range3 = {[42:57]} iff (rx_trans.ftype==9);
                            bins mtu_range4 = {[58:64]} iff (rx_trans.ftype==9);
                          }
    CR_LL_RX_PDU_LENGTH_MTU : cross CP_LL_RX_PDU_LENGTH, CP_LL_RX_PDU_MTU;
    CP_LL_RX_PDU_S : coverpoint rx_trans.S
                     {
                       bins pdu_S[] = {0,1} iff (rx_trans.ftype==9);
                     }
    CP_LL_RX_PDU_E : coverpoint rx_trans.E
                     {
                       bins pdu_E[] = {0,1} iff (rx_trans.ftype==9);
                     }
    CP_LL_RX_PDU_O : coverpoint rx_trans.O
                     {
                       bins pdu_O[] = {0,1} iff (rx_trans.ftype==9);
                     }
    CP_LL_RX_PDU_P : coverpoint rx_trans.P
                     {
                       bins pdu_P[] = {0,1} iff (rx_trans.ftype==9);
                     }
    CP_LL_RX_PDU_XH : coverpoint rx_trans.xh
                     {
                       bins pdu_xh[] = {0,1} iff (rx_trans.ftype==9);
                     }
    CP_LL_RX_PDU_STREAM_ID : coverpoint rx_trans.streamID
                     {
                            bins streamID_min = {16'h0000} iff (rx_trans.ftype==9);
                            bins streamID_small = {[16'h0001:16'h01FF]} iff (rx_trans.ftype==9);
                            bins streamID_medium = {[16'h0200:16'h0FFF]} iff (rx_trans.ftype==9);
                            bins streamID_large = {[16'h1000:16'hFFFF]} iff (rx_trans.ftype==9);
                            bins streamID_max = {16'hFFFF} iff (rx_trans.ftype==9);
                     }
    CR_LL_RX_PDU_SINGLE_SEGMENT : cross CP_LL_RX_PDU_O, CP_LL_RX_PDU_P, CP_LL_RX_PDU_S, CP_LL_RX_PDU_E
                                  {
                                    ignore_bins pdu_s = !binsof(CP_LL_RX_PDU_S) intersect {1};
                                    ignore_bins pdu_e = !binsof(CP_LL_RX_PDU_E) intersect {1};
                                  }
    CR_LL_RX_PDU_START_SEGMENT : cross CP_LL_RX_PDU_S, CP_LL_RX_PDU_E, CP_LL_RX_PDU_MTU
                                  {
                                    ignore_bins pdu_s = !binsof(CP_LL_RX_PDU_S) intersect {1};
                                    ignore_bins pdu_e = !binsof(CP_LL_RX_PDU_E) intersect {0};
                                  }
    CR_LL_RX_PDU_MIDDLE_SEGMENT : cross CP_LL_RX_PDU_S, CP_LL_RX_PDU_E, CP_LL_RX_PDU_MTU
                                  {
                                    ignore_bins pdu_s = !binsof(CP_LL_RX_PDU_S) intersect {0};
                                    ignore_bins pdu_e = !binsof(CP_LL_RX_PDU_E) intersect {0};
                                  }
    CR_LL_RX_PDU_LAST_SEGMENT : cross CP_LL_RX_PDU_O, CP_LL_RX_PDU_P, CP_LL_RX_PDU_S, CP_LL_RX_PDU_E, CP_LL_RX_PDU_MTU, CP_LL_RX_PDU_LENGTH
                                  {
                                    ignore_bins pdu_s = !binsof(CP_LL_RX_PDU_S) intersect {0};
                                    ignore_bins pdu_e = !binsof(CP_LL_RX_PDU_E) intersect {1};
                                    ignore_bins pdu_length = binsof(CP_LL_RX_PDU_LENGTH) intersect {0} && (binsof(CP_LL_RX_PDU_O) intersect {1} || binsof(CP_LL_RX_PDU_P) intersect {1});
                                  }
    CP_LL_RX_DATA_STREAM_INTERLEAVE : coverpoint rx_ds_pkt_interleave;
    CP_LL_RX_DATA_STREAM_FLOW_ID : coverpoint rx_trans.prio
                                   {
                                     bins maint_prio_crf0[] = {[0:2]} iff (rx_trans.crf==0 && rx_trans.ftype==9);
                                     bins maint_prio_crf1[] = {[0:2]} iff (rx_trans.crf==1 && rx_trans.ftype==9);
                                   }
    CR_LL_RX_PDU_LENGTH_MTU_FLOW_ID : cross CP_LL_RX_PDU_MTU, CP_LL_RX_PDU_LENGTH, CP_LL_RX_DATA_STREAM_FLOW_ID;
    CR_LL_RX_PDU_S_E_FLOW_ID : cross CP_LL_RX_PDU_S, CP_LL_RX_PDU_E, CP_LL_RX_DATA_STREAM_FLOW_ID;
    CP_LL_RX_TM_TMOP : coverpoint rx_trans.TMOP
                       {
                         bins tmop[] = {[0:2]} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1);
                       }
    CP_LL_RX_TM_WC : coverpoint rx_trans.wild_card
                       {
                         bins wc[] = {0, 1, 3, 7} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1);
                       }
    CP_LL_RX_TM_MASK : coverpoint rx_trans.mask
                       {
                         bins mask[] = {0, 1, 3,7,15,31,63,127,255} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1);
                       }
    CP_LL_RX_TM_PARAMETER1 : coverpoint rx_trans.parameter1
                       {
                         bins parameter1_range1[] = {0, 2, 3, 5, 6} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1);
                         bins parameter1_range2 = {[8'h10:8'h1F]} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1);
                         bins parameter1_range3 = {[8'h20:8'h2F]} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1);
                         bins parameter1_range4 = {8'h30} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1);
                       }
    CP_LL_RX_TM_PARAMETER2 : coverpoint rx_trans.parameter2
                       {
                         bins parameter2_range1 = {[00:50]} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1);
                         bins parameter2_range2 = {[51:150]} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1);
                         bins parameter2_range3 = {[151:255]} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1);
                       }
    CP_LL_RX_TM_BASIC_TRAFFIC : coverpoint rx_trans.parameter2
                                {
                                  bins bt_1[] = {0,8'hFF} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1 && rx_trans.TMOP==0 && rx_trans.parameter1==0);
                                  bins bt_Q_Status_empty = {0} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1 && rx_trans.TMOP==0 && rx_trans.parameter1==3);
                                  bins bt_Q_Status_low_range = {[1:100]} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1 && rx_trans.TMOP==0 && rx_trans.parameter1==3);
                                  bins bt_Q_Status_mid_range = {[101:200]} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1 && rx_trans.TMOP==0 && rx_trans.parameter1==3);
                                  bins bt_Q_Status_high_range = {[201:254]} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1 && rx_trans.TMOP==0 && rx_trans.parameter1==3);
                                  bins bt_Q_Status_full = {255} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1 && rx_trans.TMOP==0 && rx_trans.parameter1==3);
                                }
    CP_LL_RX_TM_RATE_BASED_TRAFFIC : coverpoint rx_trans.parameter2
                                {
                                  bins rt_param1_0[] = {0,8'hFF} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1 && rx_trans.TMOP==1 && rx_trans.parameter1==0);
                                  bins rt_param1_1_bin1[] = {[0:2]} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1 && rx_trans.TMOP==1 && rx_trans.parameter1==1);
                                  bins rt_param1_1_bin2 = {[3:255]} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1 && rx_trans.TMOP==1 && rx_trans.parameter1==1);
                                  bins rt_param1_5_bin1[] = {[0:2]} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1 && rx_trans.TMOP==1 && rx_trans.parameter1==5);
                                  bins rt_param1_5_bin2 = {[3:255]} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1 && rx_trans.TMOP==1 && rx_trans.parameter1==5);
                                  bins rt_param1_2_bin1 = {[1:254]} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1 && rx_trans.TMOP==1 && rx_trans.parameter1==2);
                                  bins rt_param1_2_bin2 = {255} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1 && rx_trans.TMOP==1 && rx_trans.parameter1==2);
                                  bins rt_param1_6_bin1 = {[1:254]} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1 && rx_trans.TMOP==1 && rx_trans.parameter1==6);
                                  bins rt_param1_6_bin2 = {255} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1 && rx_trans.TMOP==1 && rx_trans.parameter1==6);
                                  bins rt_param1_3_Q_Status_empty = {0} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1 && rx_trans.TMOP==1 && rx_trans.parameter1==3);
                                  bins rt_param1_3_Q_Status_low_range = {[1:100]} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1 && rx_trans.TMOP==1 && rx_trans.parameter1==3);
                                  bins rt_param1_3_Q_Status_mid_range = {[101:200]} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1 && rx_trans.TMOP==1 && rx_trans.parameter1==3);
                                  bins rt_param1_3_Q_Status_high_range = {[201:254]} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1 && rx_trans.TMOP==1 && rx_trans.parameter1==3);
                                  bins rt_param1_3_Q_Status_full = {255} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1 && rx_trans.TMOP==1 && rx_trans.parameter1==3);
                                }
    CP_LL_RX_TM_CREDIT_BASED_TRAFFIC : coverpoint rx_trans.parameter2
                                {
                                  bins ct_param1_0[] = {0,8'hFF} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1 && rx_trans.TMOP==2 && rx_trans.parameter1==0);
                                  bins ct_param1_1_low_range = {[0:100]} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1 && rx_trans.TMOP==2 && rx_trans.parameter1[7:4]==1);
                                  bins ct_param1_1_mid_range = {[101:200]} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1 && rx_trans.TMOP==2 && rx_trans.parameter1[7:4]==1);
                                  bins ct_param1_1_high_range = {[201:255]} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1 && rx_trans.TMOP==2 && rx_trans.parameter1[7:4]==1);
                                  bins ct_param1_2_low_range = {[0:100]} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1 && rx_trans.TMOP==2 && rx_trans.parameter1[7:4]==2);
                                  bins ct_param1_2_mid_range = {[101:200]} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1 && rx_trans.TMOP==2 && rx_trans.parameter1[7:4]==2);
                                  bins ct_param1_2_high_range = {[201:255]} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1 && rx_trans.TMOP==2 && rx_trans.parameter1[7:4]==2);
                                  bins ct_param1_30_empty = {0} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1 && rx_trans.TMOP==2 && rx_trans.parameter1==8'h30);
                                  bins ct_param1_30_low_range = {[1:100]} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1 && rx_trans.TMOP==2 && rx_trans.parameter1==8'h30);
                                  bins ct_param1_30_mid_range = {[101:200]} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1 && rx_trans.TMOP==2 && rx_trans.parameter1==8'h30);
                                  bins ct_param1_30_high_range = {[201:254]} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1 && rx_trans.TMOP==2 && rx_trans.parameter1==8'h30);
                                  bins ct_param1_30_full = {255} iff (rx_trans.ftype==9 && rx_trans.xtype==0 && rx_trans.xh==1 && rx_trans.TMOP==2 && rx_trans.parameter1==8'h30);
                                }
    CP_LL_RX_XON_XOFF : coverpoint rx_trans.xon_xoff
                        {
                          bins xon_xoff[] = {0, 1} iff (rx_trans.ftype==7);
                        }
    CP_LL_RX_FLOW_CTRL_FLOW_ID : coverpoint rx_trans.flowID
                        {
                          bins flowID[] = {[0:5], [8'h41:8'h48]} iff (rx_trans.ftype==7);
                        }
    CP_LL_RX_FLOW_DEST_ID : coverpoint rx_trans.DestinationID
                            {
                              bins valid_bins = {[0:32'hFFFF_FFFF]} iff (rx_trans.ftype==7);
                            }
    CP_LL_RX_FLOW_TGT_DEST_ID : coverpoint rx_trans.tgtdestID
                            {
                              bins valid_bins = {[0:32'hFFFF_FFFF]} iff (rx_trans.ftype==7);
                            }
    CP_LL_RX_FLOW_CTRL_FAM : coverpoint rx_trans.FAM
                        {
                          bins fam[] = {0, [2:7]} iff (rx_trans.ftype==7);
                        }
    CP_LL_RX_FLOW_CTRL_SOC : coverpoint rx_trans.SOC
                        {
                          bins soc[] = {0, 1} iff (rx_trans.ftype==7);
                        }
    CR_LL_RX_FLOW_CTRL_XON_XOFF_FLOW_ID_FAM : cross CP_LL_RX_XON_XOFF, CP_LL_RX_FLOW_CTRL_FAM, CP_LL_RX_FLOW_CTRL_FLOW_ID
                                              {
                                                ignore_bins fam_xoff = binsof(CP_LL_RX_XON_XOFF) intersect {0} && binsof(CP_LL_RX_FLOW_CTRL_FAM) intersect {6, 7};
                                              }                             
    CP_LL_RX_FLOW_CTRL_PIPELINE_REQ_SINGLE_PDU : coverpoint rx_single_pdu_pipeline;
    CP_LL_RX_FLOW_CTRL_PIPELINE_REQ_MULTI_PDU : coverpoint rx_multi_pdu_pipeline;
  endgroup: CG_LL_RX_PATH

  extern function new(string name = "srio_ll_func_coverage", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task update_rx_resp_type(srio_trans tx_trans_item, srio_trans rx_trans_item);
  extern task update_tx_resp_type(srio_trans tx_trans_item, srio_trans rx_trans_item);
  extern function int size_of_txn(bit wdptr, bit [3:0] txn_size);

endclass: srio_ll_func_coverage

function srio_ll_func_coverage::new(string name = "srio_ll_func_coverage", uvm_component parent = null);
  super.new(name, parent);
  CG_LL_TX_PATH = new();
  CG_LL_RX_PATH = new();
endfunction

function void srio_ll_func_coverage::build_phase(uvm_phase phase);
    tx_trans_collector = srio_ll_tx_trans_collector::type_id::create("tx_trans_collector", this);
    rx_trans_collector = srio_ll_rx_trans_collector::type_id::create("rx_trans_collector", this);
    if(!uvm_config_db #(srio_env_config)::get(this, "", "srio_env_config", env_config))
     `uvm_fatal("CONFIG FATAL", "Can't get the env_config")
    if(!uvm_config_db #(virtual srio_interface)::get(this, "", "SRIO_VIF", srio_if))
     `uvm_fatal("CONFIG FATAL", "Can't get the SRIO_VIF")
endfunction : build_phase

task srio_ll_func_coverage::run_phase(uvm_phase phase);

  fork
  begin //{
    forever
    begin //{
      @(srio_if.sim_clk);
      this.sim_clk = srio_if.sim_clk; ///< sample global sim clk
    end //}
  end //}
  join_none

  fork
    begin : register_decode //{
      while(1)
      begin //{
        @(posedge sim_clk);
        tx_io_error_resp = env_config.srio_reg_model_rx.Logical_Transport_Layer_Error_Detect_CSR.IO_error_response.get();
      end //}
    end  // register_decode }
    begin : tx_collector
      while(1)
      begin //{
        /// wait for the event trigger from srio_ll_tx_trans_collector
        @(tx_trans_collector.tx_trans_received);
        this.tx_trans = new tx_trans_collector.tx_trans;
        tx_trans.mtusize = env_config.srio_reg_model_rx.Data_Streaming_Logical_Layer_Control_CSR.MTU.get();
        Nread = env_config.srio_reg_model_rx.Destination_Operations_CAR.Nread.get();
        nwrite = env_config.srio_reg_model_rx.Destination_Operations_CAR.nwrite.get();
        Write_with_response = env_config.srio_reg_model_rx.Destination_Operations_CAR.Write_with_response.get();
        Streaming_write = env_config.srio_reg_model_rx.Destination_Operations_CAR.Streaming_write.get();
        Atomic_swap = env_config.srio_reg_model_rx.Destination_Operations_CAR.Atomic_swap.get();
        Atomic_clear = env_config.srio_reg_model_rx.Destination_Operations_CAR.Atomic_clear.get();
        Atomic_set = env_config.srio_reg_model_rx.Destination_Operations_CAR.Atomic_set.get();
        Atomic_decrement = env_config.srio_reg_model_rx.Destination_Operations_CAR.Atomic_decrement.get();
        Atomic_increment = env_config.srio_reg_model_rx.Destination_Operations_CAR.Atomic_increment.get();
        Atomic_test_and_swap = env_config.srio_reg_model_rx.Destination_Operations_CAR.Atomic_test_and_swap.get();
        Atomic_compare_and_swap = env_config.srio_reg_model_rx.Destination_Operations_CAR.Atomic_compare_and_swap.get();
        Port_write = env_config.srio_reg_model_rx.Destination_Operations_CAR.Port_write.get();
        Data_Message = env_config.srio_reg_model_rx.Destination_Operations_CAR.Data_Message.get();
        Doorbell = env_config.srio_reg_model_rx.Destination_Operations_CAR.Doorbell.get();
        Read = env_config.srio_reg_model_rx.Destination_Operations_CAR.Read.get();
        Instruction_read = env_config.srio_reg_model_rx.Destination_Operations_CAR.Instruction_read.get(); 
        Read_for_ownership = env_config.srio_reg_model_rx.Destination_Operations_CAR.Read_for_ownership.get();
        Data_cache_invalidate = env_config.srio_reg_model_rx.Destination_Operations_CAR.Data_cache_invalidate.get();
        Castout = env_config.srio_reg_model_rx.Destination_Operations_CAR.Castout.get();
        TLB_invalidate_entry = env_config.srio_reg_model_rx.Destination_Operations_CAR.TLB_invalidate_entry.get();
        TLB_invalidate_entry_sync = env_config.srio_reg_model_rx.Destination_Operations_CAR.TLB_invalidate_entry_sync.get();
        Instruction_cache_invalidate = env_config.srio_reg_model_rx.Destination_Operations_CAR.Instruction_cache_invalidate.get();
        Data_cache_flush = env_config.srio_reg_model_rx.Destination_Operations_CAR.Data_cache_flush.get();
        IO_read = env_config.srio_reg_model_rx.Destination_Operations_CAR.IO_read.get();
        msg_req_timeout = env_config.srio_reg_model_rx.Logical_Transport_Layer_Error_Detect_CSR.Message_Request_Timeout.get();
        resp_timeout = env_config.srio_reg_model_rx.Logical_Transport_Layer_Error_Detect_CSR.Packet_Response_Timeout.get();
        unexp_response = env_config.srio_reg_model_rx.Logical_Transport_Layer_Error_Detect_CSR.Unsolicited_Response.get();
        if(tx_trans.ftype != 4'h8 && tx_trans.ftype != 4'hd)
          tx_trans_list[tx_trans.SrcTID] = new tx_trans; ///< req transactions sent in TX Path
        if(tx_trans.ftype == 4'hd)
        begin //{
          if(rx_trans_list.exists(tx_trans.targetID_Info)) ///< check if the request corresponding to the response exists
          begin //{
            update_tx_resp_type(tx_trans, rx_trans_list[tx_trans.targetID_Info]);
            rx_trans_list.delete(tx_trans.targetID_Info); ///< remove the request txn from queue after getting response
          end //}
        end //}
        /// tx request transaction priority
        if( !(tx_trans.ftype == 13) && !(tx_trans.ftype==8 && (tx_trans.ttype==2 || tx_trans.ttype==3)) )
        begin //{
          if(tx_trans.prio==0 && tx_trans.crf==0)
            tx_req_priority = A;
          else if(tx_trans.prio==0 && tx_trans.crf==1)
            tx_req_priority = B;
          else if(tx_trans.prio==1 && tx_trans.crf==0)
            tx_req_priority = C;
          else if(tx_trans.prio==1 && tx_trans.crf==1)
            tx_req_priority = D;
          else if(tx_trans.prio==2 && tx_trans.crf==0)
            tx_req_priority = E;
          else if(tx_trans.prio==2 && tx_trans.crf==1)
            tx_req_priority = F;
        end //}
        if((tx_trans.ftype==5) || (tx_trans.ftype==6) || (tx_trans.ftype==8 && (tx_trans.ttype==1 || tx_trans.ttype==4)) ) ///< check the payload length of write transactions
        begin //{
          tx_wr_trans_size = size_of_txn(tx_trans.wdptr, tx_trans.wrsize);
          if(tx_wr_trans_size >= 8)
          begin //{
            if(tx_trans.payload.size() > tx_wr_trans_size)
              tx_invalid_payload_len = 1; ///< invalid payload length
            else
              tx_invalid_payload_len = 0; ///< valid payload length 
          end //}
          else
          begin //{
            tx_invalid_payload_len = 0; ///< valid payload length
          end //}
        end //}
        else if((tx_trans.ftype==2) || (tx_trans.ftype==8 && tx_trans.ttype==0) )
        begin //{
          tx_rd_trans_size = size_of_txn(tx_trans.wdptr, tx_trans.rdsize); ///< get the read req transaction size
        end //}
        /////////////////////////////////////////////////////////////////////////////
        /// message txns decoder logic
        ////////////////////////////////////////////////////////////////////////////
        if(tx_trans.ftype==11)
        begin //{
          if(tx_msg_open.exists({tx_trans.mbox, tx_trans.letter})) ///< old message
          begin //{
            if(tx_trans.msgseg_xmbox == (tx_msg_open[{tx_trans.mbox, tx_trans.letter}]+1) )
            begin //{
              tx_msg_out_of_order = 0; ///< msg segment is not out of order
            end //}
            else
            begin //{
              tx_msg_out_of_order = 1; ///< msg segment is out of order
            end //}
            tx_msg_open[{tx_trans.mbox, tx_trans.letter}] = tx_trans.msgseg_xmbox;
            tx_msg_rcvd_size[{tx_trans.mbox, tx_trans.letter}] = tx_msg_rcvd_size[{tx_trans.mbox, tx_trans.letter}] + 1;
            if(tx_msg_rcvd_size[{tx_trans.mbox, tx_trans.letter}] == (tx_msg_total_len[{tx_trans.mbox, tx_trans.letter}]+1) ) ///< check if last segment is received
            begin //{
              /// remove the index if last segment has been received
              tx_msg_open.delete({tx_trans.mbox, tx_trans.letter});
              tx_msg_rcvd_size.delete({tx_trans.mbox, tx_trans.letter});
              tx_msg_total_len.delete({tx_trans.mbox, tx_trans.letter});
            end //}
            /// message is interleaved if more than one msg is open (i.e) size_of(tx_msg_open) > 1
            if(tx_msg_open.num() > 1)
            begin //{
              tx_msg_interleave = 1; ///< msg is interleaved
            end //}
            else
            begin //{
              tx_msg_interleave = 0; ///< msg is not interleaved
            end //}
          end //}
          else
          begin //{
            /// new msg received. open a new index in tx_msg_open, tx_msg_total_len, tx_msg_rcvd_size arrays
            if(tx_trans.msg_len > 0)
            begin //{
              tx_msg_open[{tx_trans.mbox, tx_trans.letter}] = tx_trans.msgseg_xmbox;
              tx_msg_total_len[{tx_trans.mbox, tx_trans.letter}] = tx_trans.msg_len;
              tx_msg_rcvd_size[{tx_trans.mbox, tx_trans.letter}] = 1; ///< first segment received
              /// message is out_of_order if the first segment number is != 0
              if(tx_msg_open[tx_trans.msgseg_xmbox] != 0)
              begin //{
                tx_msg_out_of_order = 1; ///< msg segment is out of order
              end //}
              else
              begin //{
                tx_msg_out_of_order = 0; ///< msg segment is not out of order
              end //}
              /// message is interleaved if more than one msg is open (i.e) size_of(tx_msg_open) > 1
              if(tx_msg_open.num() > 1)
              begin //{
                tx_msg_interleave = 1; ///< msg is interleaved
              end //}
              else
              begin //{
                tx_msg_interleave = 0; ///< msg is not interleaved
              end //}
            end //}
          end //}
        end //}
        else
        begin //{
          tx_msg_out_of_order = 0; ///< msg is not out of order
          tx_msg_interleave = 0; ///< msg is not interleaved
        end //}
        tx_payload_size = tx_trans.payload.size();
        if(tx_trans.ftype == 11)
        begin //{
          if(tx_payload_size > tx_trans.ssize)
            tx_msg_invalid_size = 1; ///< invalid msg size
          if(tx_trans.msgseg_xmbox > tx_trans.msg_len)
            tx_msg_invalid_seg = 1; ///< invalid msg segment
        end //}
        else
        begin //{
          tx_msg_invalid_size = 0; ///< valid msg size
          tx_msg_invalid_seg = 0; ///< valid msg segment
        end //}
        /////////////////////////////////////////////////////////////////
        /// DS Packet decoding logic
        /////////////////////////////////////////////////////////////////
        if(tx_trans.ftype==9)
        begin //{
          if(tx_ds_pkt_open.exists(tx_trans.cos)) ///< old ds packet
          begin //{
            tx_ds_pkt_open[tx_trans.cos] = tx_ds_pkt_open[tx_trans.cos] + 1;
            if(tx_trans.S==0 && tx_trans.E==1) ///< check if it is last segment
            begin //{
              tx_ds_pkt_open.delete(tx_trans.cos); ///< remove ds packet from queue (if last segment)
            end //}
          end //}
          else 
          begin //{
            tx_ds_pkt_open[tx_trans.cos] = 1;
            if(tx_ds_pkt_open.size() > 1)
            begin //{
              tx_ds_pkt_interleave = 1; ///< ds packet is interleaved
            end //}
            else
            begin //{
              tx_ds_pkt_interleave = 0; ///< ds packet is not interleaved
            end //}
          end //}
        end //}
        else
        begin //{
          tx_ds_pkt_interleave = 0; ///< ds packet is not interleaved
        end //}
 
        -> tx_trans_event;
      end //}
    end // tx_collector
    begin : rx_collector
      while(1)
      begin //{
        /// wait for the event trigger from srio_ll_rx_trans_collector
        @(rx_trans_collector.rx_trans_received);
        this.rx_trans = new rx_trans_collector.rx_trans;
        rx_trans.mtusize = env_config.srio_reg_model_tx.Data_Streaming_Logical_Layer_Control_CSR.MTU.get();
        if(rx_trans.ftype != 4'h8 && rx_trans.ftype != 4'hd)
          rx_trans_list[rx_trans.SrcTID] = new rx_trans; ///< req transactions sent in rx path
        if(rx_trans.ftype == 4'hd)
        begin //{
          if(tx_trans_list.exists(rx_trans.targetID_Info)) ///< check if the request corresponding to the response exists
          begin //{
            update_rx_resp_type(tx_trans_list[rx_trans.targetID_Info], rx_trans);
            tx_trans_list.delete(rx_trans.targetID_Info); ///< remove the request txn from queue after getting response
          end //}
        end //}
        rx_wr_trans_size = size_of_txn(rx_trans.wdptr, rx_trans.wrsize); ///< get the size of write transaction
        rx_rd_trans_size = size_of_txn(rx_trans.wdptr, rx_trans.rdsize); ///< get the size of read transaction
        /////////////////////////////////////////////////////////////////////////////
        /// message txns decoder logic
        ////////////////////////////////////////////////////////////////////////////
        if(rx_trans.ftype==11)
        begin //{
          if(rx_msg_open.exists({rx_trans.mbox, rx_trans.letter})) ///< old message
          begin //{
            if(rx_trans.msgseg_xmbox == (rx_msg_open[{rx_trans.mbox, rx_trans.letter}]+1) )
            begin //{
              rx_msg_out_of_order = 0; ///< msg segment is not out of order
            end //}
            else
            begin //{
              rx_msg_out_of_order = 1; ///< msg segment is out of order
            end //}
            rx_msg_open[{rx_trans.mbox, rx_trans.letter}] = rx_trans.msgseg_xmbox;
            rx_msg_rcvd_size[{rx_trans.mbox, rx_trans.letter}] = rx_msg_rcvd_size[{rx_trans.mbox, rx_trans.letter}] + 1;
            if(rx_msg_rcvd_size[{rx_trans.mbox, rx_trans.letter}] == (rx_msg_total_len[{rx_trans.mbox, rx_trans.letter}]+1) ) ///<      check if last segment is received
            begin //{
              /// remove the index if last segment has been received
              rx_msg_open.delete({rx_trans.mbox, rx_trans.letter});
              rx_msg_rcvd_size.delete({rx_trans.mbox, rx_trans.letter});
              rx_msg_total_len.delete({rx_trans.mbox, rx_trans.letter});
            end //}
            /// message is interleaved if more than one msg is open (i.e) size_of(rx_msg_open) > 1
            if(rx_msg_open.num() > 1)
            begin //{
              rx_msg_interleave = 1; ///< msg is interleaved
            end //}
            else
            begin //{
              rx_msg_interleave = 0; ///< msg is not interleaved
            end //}
          end //}
          else
          begin //{
            /// new msg received. open a new index in rx_msg_open, rx_msg_total_len, rx_msg_rcvd_size arrays
            if(rx_trans.msg_len > 0)
            begin //{
              rx_msg_open[{rx_trans.mbox, rx_trans.letter}] = rx_trans.msgseg_xmbox;
              rx_msg_total_len[{rx_trans.mbox, rx_trans.letter}] = rx_trans.msg_len;
              rx_msg_rcvd_size[{rx_trans.mbox, rx_trans.letter}] = 1; ///< first segment received
              /// message is out_of_order if the first segment number is != 0
              if(rx_msg_open[rx_trans.msgseg_xmbox] != 0)
              begin //{
                rx_msg_out_of_order = 1; ///< msg segment is out of order
              end //}
              else
              begin //{
                rx_msg_out_of_order = 0; ///< msg segment is out of order
              end //}
              /// message is interleaved if more than one msg is open (i.e) size_of(rx_msg_open) > 1
              if(rx_msg_open.num() > 1)
              begin //{
                rx_msg_interleave = 1; ///< msg is interleaved
              end //}
              else
              begin //{
                rx_msg_interleave = 0; ///< msg is not interleaved
              end //}
            end //}
          end //}
        end //}
        else
        begin //{
          rx_msg_out_of_order = 0; ///< msg is not out of order
          rx_msg_interleave = 0; ///< msg is not interleaved
        end //}
        rx_payload_size = rx_trans.payload.size();
        /////////////////////////////////////////////////////////////////
        /// DS Packet decoding logic
        /////////////////////////////////////////////////////////////////
        if(rx_trans.ftype==9)
        begin //{
          if(rx_ds_pkt_open.exists(rx_trans.cos)) ///< old ds packet
          begin //{
            rx_ds_pkt_open[rx_trans.cos] = rx_ds_pkt_open[rx_trans.cos] + 1;
            if(rx_trans.S==0 && rx_trans.E==1) ///< check if it is last segment
            begin //{
              rx_ds_pkt_open.delete(rx_trans.cos); ///< remove ds packet from queue (if last segment)
            end //}
          end //}
          else 
          begin //{
            rx_ds_pkt_open[rx_trans.cos] = 1;
            if(rx_ds_pkt_open.size() > 1)
            begin //{
              rx_ds_pkt_interleave = 1; ///< ds packet is interleaved
            end //}
            else
            begin //{
              rx_ds_pkt_interleave = 0; ///< ds packet is not interleaved
            end //}
          end //}
        end //}
        else
        begin //{
          rx_ds_pkt_interleave = 0; ///< ds packet is not interleaved
        end //}
        -> rx_trans_event;
      end //} //while(1)
    end // rx_collector
    begin : ll_mon_variables //{
      while(1)
      begin //{
        @(posedge sim_clk);
        tx_single_pdu_pipeline = ll_agent.ll_monitor.tx_monitor.single_req_pipelined;
        tx_multi_pdu_pipeline = ll_agent.ll_monitor.tx_monitor.multi_req_pipelined;
        rx_single_pdu_pipeline = ll_agent.ll_monitor.rx_monitor.single_req_pipelined;
        rx_multi_pdu_pipeline = ll_agent.ll_monitor.rx_monitor.multi_req_pipelined;
      end //}
    end //} ll_mon_variables
  join_none

endtask : run_phase

//////////////////////////////////////////////////////////////////////////
/// Name: update_rx_resp_type
/// Description: updates the response type and response status for all
/// transactions in rx path
/// update_rx_resp_type
//////////////////////////////////////////////////////////////////////////

task srio_ll_func_coverage::update_rx_resp_type(srio_trans tx_trans_item, srio_trans rx_trans_item);
  if(tx_trans_item.ftype==2 && tx_trans_item.ttype==4) ///< NREAD
  begin //{
    rx_nread_resp_type = rx_trans_item.ttype;
    rx_nread_resp_status = rx_trans_item.trans_status;
  end //}
  else if(tx_trans_item.ftype==2 && tx_trans_item.ttype==4'hc) ///< ATOMIC_INC
  begin //{
    rx_atomic_inc_resp_type = rx_trans_item.ttype;
    rx_atomic_inc_resp_status = rx_trans_item.trans_status;
  end //}
  else if(tx_trans_item.ftype==2 && tx_trans_item.ttype==4'hd) ///< ATOMIC_DEC
  begin //{
    rx_atomic_dec_resp_type = rx_trans_item.ttype;
    rx_atomic_dec_resp_status = rx_trans_item.trans_status;
  end //}
  else if(tx_trans_item.ftype==2 && tx_trans_item.ttype==4'he) ///< ATOMIC_SET
  begin //{
    rx_atomic_set_resp_type = rx_trans_item.ttype;
    rx_atomic_set_resp_status = rx_trans_item.trans_status;
  end //}
  else if(tx_trans_item.ftype==2 && tx_trans_item.ttype==4'hf) ///< ATOMIC_CLR
  begin //{
    rx_atomic_clr_resp_type = rx_trans_item.ttype;
    rx_atomic_clr_resp_status = rx_trans_item.trans_status;
  end //}
  else if(tx_trans_item.ftype==5 && tx_trans_item.ttype==4'hc) ///< ATOMIC_SWAP
  begin //{
    rx_atomic_swap_resp_type = rx_trans_item.ttype;
    rx_atomic_swap_resp_status = rx_trans_item.trans_status;
  end //}
  else if(tx_trans_item.ftype==5 && tx_trans_item.ttype==4'hd) ///< ATOMIC_COMP
  begin //{
    rx_atomic_comp_resp_type = rx_trans_item.ttype;
    rx_atomic_comp_resp_status = rx_trans_item.trans_status;
  end //}
  else if(tx_trans_item.ftype==5 && tx_trans_item.ttype==4'he) ///< ATOMIC_TEST
  begin //{
    rx_atomic_test_resp_type = rx_trans_item.ttype;
    rx_atomic_test_resp_status = rx_trans_item.trans_status;
  end //}
  else if(tx_trans_item.ftype==5 && tx_trans_item.ttype==5) ///< NWRITE_R
  begin //{
    rx_nwrite_r_resp_type = rx_trans_item.ttype;
    rx_nwrite_r_resp_status = rx_trans_item.trans_status;
  end //}
  else if(tx_trans_item.ftype==4'ha) ///< DOORBELL
  begin //{
    rx_doorbell_resp_type = rx_trans_item.ttype;
    rx_doorbell_resp_status = rx_trans_item.trans_status;
  end //}
  else if(tx_trans_item.ftype==4'hb) ///< MESSAGE
  begin //{
    rx_msg_resp_type = rx_trans_item.ttype;
    rx_msg_resp_status = rx_trans_item.trans_status;
    rx_msg_resp_tgt_tid = rx_trans_item.targetID_Info;
  end //}
  else if(tx_trans_item.ftype==1 && tx_trans_item.ttype==0) ///< GSM_RD_O
  begin //{
    rx_gsm_rd_o_resp_type = rx_trans_item.ttype;
    rx_gsm_rd_o_resp_status = rx_trans_item.trans_status;
    rx_gsm_resp_type = rx_trans_item.ttype;
    rx_gsm_resp_status = rx_trans_item.trans_status;
  end //}
  else if(tx_trans_item.ftype==1 && tx_trans_item.ttype==1) ///< GSM_RD_O_O
  begin //{
    rx_gsm_rd_o_o_resp_type = rx_trans_item.ttype;
    rx_gsm_rd_o_o_resp_status = rx_trans_item.trans_status;
    rx_gsm_resp_type = rx_trans_item.ttype;
    rx_gsm_resp_status = rx_trans_item.trans_status;
  end //}
  else if(tx_trans_item.ftype==1 && tx_trans_item.ttype==2) ///< GSM_IO_RD_O
  begin //{
    rx_gsm_io_rd_o_resp_type = rx_trans_item.ttype;
    rx_gsm_io_rd_o_resp_status = rx_trans_item.trans_status;
    rx_gsm_resp_type = rx_trans_item.ttype;
    rx_gsm_resp_status = rx_trans_item.trans_status;
  end //}
  else if(tx_trans_item.ftype==2 && tx_trans_item.ttype==0) ///< GSM_RD_H
  begin //{
    rx_gsm_rd_h_resp_type = rx_trans_item.ttype;
    rx_gsm_rd_h_resp_status = rx_trans_item.trans_status;
    rx_gsm_resp_type = rx_trans_item.ttype;
    rx_gsm_resp_status = rx_trans_item.trans_status;
  end //}
  else if(tx_trans_item.ftype==2 && tx_trans_item.ttype==1) ///< GSM_RD_O_H
  begin //{
    rx_gsm_rd_o_h_resp_type = rx_trans_item.ttype;
    rx_gsm_rd_o_h_resp_status = rx_trans_item.trans_status;
    rx_gsm_resp_type = rx_trans_item.ttype;
    rx_gsm_resp_status = rx_trans_item.trans_status;
  end //}
  else if(tx_trans_item.ftype==2 && tx_trans_item.ttype==2) ///< GSM_IO_RD_H
  begin //{
    rx_gsm_io_rd_h_resp_type = rx_trans_item.ttype;
    rx_gsm_io_rd_h_resp_status = rx_trans_item.trans_status;
    rx_gsm_resp_type = rx_trans_item.ttype;
    rx_gsm_resp_status = rx_trans_item.trans_status;
  end //}
  else if(tx_trans_item.ftype==2 && tx_trans_item.ttype==3) ///< GSM_D_H
  begin //{
    rx_gsm_d_h_resp_type = rx_trans_item.ttype;
    rx_gsm_d_h_resp_status = rx_trans_item.trans_status;
    rx_gsm_resp_type = rx_trans_item.ttype;
    rx_gsm_resp_status = rx_trans_item.trans_status;
  end //}
  else if(tx_trans_item.ftype==2 && tx_trans_item.ttype==5) ///< GSM_I_H
  begin //{
    rx_gsm_i_h_resp_type = rx_trans_item.ttype;
    rx_gsm_i_h_resp_status = rx_trans_item.trans_status;
    rx_gsm_resp_type = rx_trans_item.ttype;
    rx_gsm_resp_status = rx_trans_item.trans_status;
  end //}
  else if(tx_trans_item.ftype==2 && tx_trans_item.ttype==6) ///< GSM_TLBIE
  begin //{
    rx_gsm_tlbie_resp_type = rx_trans_item.ttype;
    rx_gsm_tlbie_resp_status = rx_trans_item.trans_status;
    rx_gsm_resp_type = rx_trans_item.ttype;
    rx_gsm_resp_status = rx_trans_item.trans_status;
  end //}
  else if(tx_trans_item.ftype==2 && tx_trans_item.ttype==7) ///< GSM_TLBSYNC
  begin //{
    rx_gsm_tlbsync_resp_type = rx_trans_item.ttype;
    rx_gsm_tlbsync_resp_status = rx_trans_item.trans_status;
    rx_gsm_resp_type = rx_trans_item.ttype;
    rx_gsm_resp_status = rx_trans_item.trans_status;
  end //}
  else if(tx_trans_item.ftype==2 && tx_trans_item.ttype==8) ///< GSM_IRD_H
  begin //{
    rx_gsm_ird_h_resp_type = rx_trans_item.ttype;
    rx_gsm_ird_h_resp_status = rx_trans_item.trans_status;
    rx_gsm_resp_type = rx_trans_item.ttype;
    rx_gsm_resp_status = rx_trans_item.trans_status;
  end //}
  else if(tx_trans_item.ftype==2 && tx_trans_item.ttype==9) ///< GSM_FLUSH_WO_D
  begin //{
    rx_gsm_flush_wo_d_resp_type = rx_trans_item.ttype;
    rx_gsm_flush_wo_d_resp_status = rx_trans_item.trans_status;
    rx_gsm_resp_type = rx_trans_item.ttype;
    rx_gsm_resp_status = rx_trans_item.trans_status;
  end //}
  else if(tx_trans_item.ftype==2 && tx_trans_item.ttype==4'ha) ///< GSM_IK_SH
  begin //{
    rx_gsm_ik_sh_resp_type = rx_trans_item.ttype;
    rx_gsm_ik_sh_resp_status = rx_trans_item.trans_status;
    rx_gsm_resp_type = rx_trans_item.ttype;
    rx_gsm_resp_status = rx_trans_item.trans_status;
  end //}
  else if(tx_trans_item.ftype==2 && tx_trans_item.ttype==4'hb) ///< GSM_DK_SH
  begin //{
    rx_gsm_dk_sh_resp_type = rx_trans_item.ttype;
    rx_gsm_dk_sh_resp_status = rx_trans_item.trans_status;
    rx_gsm_resp_type = rx_trans_item.ttype;
    rx_gsm_resp_status = rx_trans_item.trans_status;
  end //}
  else if(tx_trans_item.ftype==5 && tx_trans_item.ttype==0) ///< GSM_CAST_OUT
  begin //{
    rx_gsm_castout_resp_type = rx_trans_item.ttype;
    rx_gsm_castout_resp_status = rx_trans_item.trans_status;
    rx_gsm_resp_type = rx_trans_item.ttype;
    rx_gsm_resp_status = rx_trans_item.trans_status;
  end //}
  else if(tx_trans_item.ftype==5 && tx_trans_item.ttype==1) ///< GSM_FLUSH_WD
  begin //{
    rx_gsm_flush_wd_resp_type = rx_trans_item.ttype;
    rx_gsm_flush_wd_resp_status = rx_trans_item.trans_status;
    rx_gsm_resp_type = rx_trans_item.ttype;
    rx_gsm_resp_status = rx_trans_item.trans_status;
  end //}
endtask

//////////////////////////////////////////////////////////////////////////
/// Name: update_tx_resp_type
/// Description: updates the response type and response status for all
/// transactions in tx path
/// update_tx_resp_type
//////////////////////////////////////////////////////////////////////////

task srio_ll_func_coverage::update_tx_resp_type(srio_trans tx_trans_item, srio_trans rx_trans_item);
  if(rx_trans_item.ftype==2 && rx_trans_item.ttype==4) ///< NREAD
  begin //{
    tx_nread_resp_type = tx_trans_item.ttype;
    tx_nread_resp_status = tx_trans_item.trans_status;
  end //}
  else if(rx_trans_item.ftype==2 && rx_trans_item.ttype==4'hc) ///< ATOMIC_INC
  begin //{
    tx_atomic_inc_resp_type = tx_trans_item.ttype;
    tx_atomic_inc_resp_status = tx_trans_item.trans_status;
  end //}
  else if(rx_trans_item.ftype==2 && rx_trans_item.ttype==4'hd) ///< ATOMIC_DEC
  begin //{
    tx_atomic_dec_resp_type = tx_trans_item.ttype;
    tx_atomic_dec_resp_status = tx_trans_item.trans_status;
  end //}
  else if(rx_trans_item.ftype==2 && rx_trans_item.ttype==4'he) ///< ATOMIC_SET
  begin //{
    tx_atomic_set_resp_type = tx_trans_item.ttype;
    tx_atomic_set_resp_status = tx_trans_item.trans_status;
  end //}
  else if(rx_trans_item.ftype==2 && rx_trans_item.ttype==4'hf) ///< ATOMIC_CLR
  begin //{
    tx_atomic_clr_resp_type = tx_trans_item.ttype;
    tx_atomic_clr_resp_status = tx_trans_item.trans_status;
  end //}
  else if(rx_trans_item.ftype==5 && rx_trans_item.ttype==4'hc) ///< ATOMIC_SWAP
  begin //{
    tx_atomic_swap_resp_type = tx_trans_item.ttype;
    tx_atomic_swap_resp_status = tx_trans_item.trans_status;
  end //}
  else if(rx_trans_item.ftype==5 && rx_trans_item.ttype==4'hd) ///< ATOMIC_COMP
  begin //{
    tx_atomic_comp_resp_type = tx_trans_item.ttype;
    tx_atomic_comp_resp_status = tx_trans_item.trans_status;
  end //}
  else if(rx_trans_item.ftype==5 && rx_trans_item.ttype==4'he) ///< ATOMIC_TEST
  begin //{
    tx_atomic_test_resp_type = tx_trans_item.ttype;
    tx_atomic_test_resp_status = tx_trans_item.trans_status;
  end //}
  else if(rx_trans_item.ftype==5 && rx_trans_item.ttype==5) ///< NWRITE_R
  begin //{
    tx_nwrite_r_resp_type = tx_trans_item.ttype;
    tx_nwrite_r_resp_status = tx_trans_item.trans_status;
  end //}
  else if(rx_trans_item.ftype==4'ha) ///< DOORBELL
  begin //{
    tx_doorbell_resp_type = tx_trans_item.ttype;
    tx_doorbell_resp_status = tx_trans_item.trans_status;
  end //}
  else if(rx_trans_item.ftype==4'hb) ///< MESSAGE
  begin //{
    tx_msg_resp_type = tx_trans_item.ttype;
    tx_msg_resp_status = tx_trans_item.trans_status;
    tx_msg_resp_tgt_tid = tx_trans_item.targetID_Info;
  end //}
  else if(rx_trans_item.ftype==1 && rx_trans_item.ttype==0) ///< GSM_RD_O
  begin //{
    tx_gsm_rd_o_resp_type = tx_trans_item.ttype;
    tx_gsm_rd_o_resp_status = tx_trans_item.trans_status;
    tx_gsm_resp_type   = tx_trans_item.ttype;
    tx_gsm_resp_status = tx_trans_item.trans_status;
  end //}
  else if(rx_trans_item.ftype==1 && rx_trans_item.ttype==1) ///< GSM_RD_O_O
  begin //{
    tx_gsm_rd_o_o_resp_type = tx_trans_item.ttype;
    tx_gsm_rd_o_o_resp_status = tx_trans_item.trans_status;
    tx_gsm_resp_type   = tx_trans_item.ttype;
    tx_gsm_resp_status = tx_trans_item.trans_status;
  end //}
  else if(rx_trans_item.ftype==1 && rx_trans_item.ttype==2) ///< GSM_IO_RD_O
  begin //{
    tx_gsm_io_rd_o_resp_type = tx_trans_item.ttype;
    tx_gsm_io_rd_o_resp_status = tx_trans_item.trans_status;
    tx_gsm_resp_type   = tx_trans_item.ttype;
    tx_gsm_resp_status = tx_trans_item.trans_status;
  end //}
  else if(rx_trans_item.ftype==2 && rx_trans_item.ttype==0) ///< GSM_RD_H
  begin //{
    tx_gsm_rd_h_resp_type = tx_trans_item.ttype;
    tx_gsm_rd_h_resp_status = tx_trans_item.trans_status;
    tx_gsm_resp_type   = tx_trans_item.ttype;
    tx_gsm_resp_status = tx_trans_item.trans_status;
  end //}
  else if(rx_trans_item.ftype==2 && rx_trans_item.ttype==1) ///< GSM_RD_O_H
  begin //{
    tx_gsm_rd_o_h_resp_type = tx_trans_item.ttype;
    tx_gsm_rd_o_h_resp_status = tx_trans_item.trans_status;
    tx_gsm_resp_type   = tx_trans_item.ttype;
    tx_gsm_resp_status = tx_trans_item.trans_status;
  end //}
  else if(rx_trans_item.ftype==2 && rx_trans_item.ttype==2) ///< GSM_IO_RD_H
  begin //{
    tx_gsm_io_rd_h_resp_type = tx_trans_item.ttype;
    tx_gsm_io_rd_h_resp_status = tx_trans_item.trans_status;
    tx_gsm_resp_type   = tx_trans_item.ttype;
    tx_gsm_resp_status = tx_trans_item.trans_status;
  end //}
  else if(rx_trans_item.ftype==2 && rx_trans_item.ttype==3) ///< GSM_D_H
  begin //{
    tx_gsm_d_h_resp_type = tx_trans_item.ttype;
    tx_gsm_d_h_resp_status = tx_trans_item.trans_status;
    tx_gsm_resp_type   = tx_trans_item.ttype;
    tx_gsm_resp_status = tx_trans_item.trans_status;
  end //}
  else if(rx_trans_item.ftype==2 && rx_trans_item.ttype==5) ///< GSM_I_H
  begin //{
    tx_gsm_i_h_resp_type = tx_trans_item.ttype;
    tx_gsm_i_h_resp_status = tx_trans_item.trans_status;
    tx_gsm_resp_type   = tx_trans_item.ttype;
    tx_gsm_resp_status = tx_trans_item.trans_status;
  end //}
  else if(rx_trans_item.ftype==2 && rx_trans_item.ttype==6) ///< GSM_TLBIE
  begin //{
    tx_gsm_tlbie_resp_type = tx_trans_item.ttype;
    tx_gsm_tlbie_resp_status = tx_trans_item.trans_status;
    tx_gsm_resp_type   = tx_trans_item.ttype;
    tx_gsm_resp_status = tx_trans_item.trans_status;
  end //}
  else if(rx_trans_item.ftype==2 && rx_trans_item.ttype==7) ///< GSM_TLBSYNC
  begin //{
    tx_gsm_tlbsync_resp_type = tx_trans_item.ttype;
    tx_gsm_tlbsync_resp_status = tx_trans_item.trans_status;
    tx_gsm_resp_type   = tx_trans_item.ttype;
    tx_gsm_resp_status = tx_trans_item.trans_status;
  end //}
  else if(rx_trans_item.ftype==2 && rx_trans_item.ttype==8) ///< GSM_IRD_H
  begin //{
    tx_gsm_ird_h_resp_type = tx_trans_item.ttype;
    tx_gsm_ird_h_resp_status = tx_trans_item.trans_status;
    tx_gsm_resp_type   = tx_trans_item.ttype;
    tx_gsm_resp_status = tx_trans_item.trans_status;
  end //}
  else if(rx_trans_item.ftype==2 && rx_trans_item.ttype==9) ///< GSM_FLUSH_WO_D
  begin //{
    tx_gsm_flush_wo_d_resp_type = tx_trans_item.ttype;
    tx_gsm_flush_wo_d_resp_status = tx_trans_item.trans_status;
    tx_gsm_resp_type   = tx_trans_item.ttype;
    tx_gsm_resp_status = tx_trans_item.trans_status;
  end //}
  else if(rx_trans_item.ftype==2 && rx_trans_item.ttype==4'ha) ///< GSM_IK_SH
  begin //{
    tx_gsm_ik_sh_resp_type = tx_trans_item.ttype;
    tx_gsm_ik_sh_resp_status = tx_trans_item.trans_status;
    tx_gsm_resp_type   = tx_trans_item.ttype;
    tx_gsm_resp_status = tx_trans_item.trans_status;
  end //}
  else if(rx_trans_item.ftype==2 && rx_trans_item.ttype==4'hb) ///< GSM_DK_SH
  begin //{
    tx_gsm_dk_sh_resp_type = tx_trans_item.ttype;
    tx_gsm_dk_sh_resp_status = tx_trans_item.trans_status;
    tx_gsm_resp_type   = tx_trans_item.ttype;
    tx_gsm_resp_status = tx_trans_item.trans_status;
  end //}
  else if(rx_trans_item.ftype==5 && rx_trans_item.ttype==0) ///< GSM_CAST_OUT
  begin //{
    tx_gsm_castout_resp_type = tx_trans_item.ttype;
    tx_gsm_castout_resp_status = tx_trans_item.trans_status;
    tx_gsm_resp_type   = tx_trans_item.ttype;
    tx_gsm_resp_status = tx_trans_item.trans_status;
  end //}
  else if(rx_trans_item.ftype==5 && rx_trans_item.ttype==1) ///< GSM_FLUSH_WD
  begin //{
    tx_gsm_flush_wd_resp_type = tx_trans_item.ttype;
    tx_gsm_flush_wd_resp_status = tx_trans_item.trans_status;
    tx_gsm_resp_type   = tx_trans_item.ttype;
    tx_gsm_resp_status = tx_trans_item.trans_status;
  end //}
endtask

//////////////////////////////////////////////////////////////////////////
/// Name: size_of_txn
/// Description: returns the size of each txn in bytes
/// size_of_txn
//////////////////////////////////////////////////////////////////////////

function int srio_ll_func_coverage::size_of_txn(bit wdptr, bit [3:0] txn_size);
  if(txn_size<4)
  begin //{
    size_of_txn = 1;
  end //}
  else if(txn_size==4 || txn_size==6)
  begin //{
    size_of_txn = 2;
  end //}
  else if(txn_size==5)
  begin //{
    size_of_txn = 3;
  end //}
  else if(txn_size==7)
  begin //{
    size_of_txn = 5;
  end //}
  else if(txn_size==8)
  begin //{
    size_of_txn = 4;
  end //}
  else if(txn_size==9)
  begin //{
    size_of_txn = 6;
  end //}
  else if(txn_size==10)
  begin //{
    size_of_txn = 7;
  end //}
  else if(txn_size==11 && wdptr==0)
  begin //{
    size_of_txn = 8;
  end //}
  else if(txn_size==11 && wdptr==1)
  begin //{
    size_of_txn = 16;
  end //}
  else if(txn_size==12 && wdptr==0)
  begin //{
    size_of_txn = 32;
  end //}
  else if(txn_size==12 && wdptr==1)
  begin //{
    size_of_txn = 64;
  end //}
  else if(txn_size==13 && wdptr==0)
  begin //{
    size_of_txn = 96;
  end //}
  else if(txn_size==13 && wdptr==1)
  begin //{
    size_of_txn = 128;
  end //}
  else if(txn_size==14 && wdptr==0)
  begin //{
    size_of_txn = 160;
  end //}
  else if(txn_size==14 && wdptr==1)
  begin //{
    size_of_txn = 192;
  end //}
  else if(txn_size==15 && wdptr==0)
  begin //{
    size_of_txn = 224;
  end //}
  else if(txn_size==15 && wdptr==1)
  begin //{
    size_of_txn = 256;
  end //}
endfunction : size_of_txn
