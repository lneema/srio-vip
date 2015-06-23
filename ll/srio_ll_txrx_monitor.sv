////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_txrx_monitor.sv
// Project :  srio vip
// Purpose :  LL protocol Checker
// Author  :  Mobiveil
//
// Contains srio_ll_txrx_monitor class to perform protocol checks of LL
////////////////////////////////////////////////////////////////////////////////

// =============================================================================
// Class: srio_ll_txrx_monitor
// =============================================================================

class srio_ll_txrx_monitor extends uvm_component;

  /// @cond
  `uvm_component_utils(srio_ll_txrx_monitor)

  event                ll_mon_received_pkt                    ;
  // Destination Support
  bit                  dest_ds_support                        ;
  bit                  dest_rd_support                        ;
  bit                  dest_write_support                     ;
  bit                  dest_swrite_support                    ;
  bit                  dest_nwriter_support                   ;
  bit                  dest_msg_support                       ;
  bit                  dest_db_support                        ;
  bit                  dest_ato_comp_swap_support             ;
  bit                  dest_ato_test_swap_support             ;
  bit                  dest_ato_inc_support                   ;
  bit                  dest_ato_dec_support                   ;
  bit                  dest_ato_set_support                   ;
  bit                  dest_ato_clr_support                   ;
  bit                  dest_ato_swap_support                  ;
  bit                  dest_port_wr_support                   ;
  bit                  dest_ds_tm_support                     ;
  bit                  dest_read_support                      ;    
  bit                  dest_inst_read_support                 ;    
  bit                  dest_read_ownership_support            ;    
  bit                  dest_data_cache_inval_support          ;    
  bit                  dest_castout_support                   ;    
  bit                  dest_data_cache_flush_support          ;    
  bit                  dest_io_read_support                   ;    
  bit                  dest_inst_cache_inval_support          ;    
  bit                  dest_tlb_inval_entry_support           ;    
  bit                  dest_tlb_inval_entry_sync_support      ;   
  // Source Support
  bit                  src_ds_support                         ;
  bit                  src_rd_support                         ;
  bit                  src_write_support                      ;
  bit                  src_swrite_support                     ;
  bit                  src_nwriter_support                    ;
  bit                  src_msg_support                        ;
  bit                  src_db_support                         ;
  bit                  src_ato_comp_swap_support              ;
  bit                  src_ato_test_swap_support              ;
  bit                  src_ato_inc_support                    ;
  bit                  src_ato_dec_support                    ;
  bit                  src_ato_set_support                    ;
  bit                  src_ato_clr_support                    ;
  bit                  src_ato_swap_support                   ;
  bit                  src_port_wr_support                    ;
  bit                  src_ds_tm_support                      ;
  bit                  src_read_support                       ;   
  bit                  src_inst_read_support                  ;   
  bit                  src_read_ownership_support             ;   
  bit                  src_data_cache_inval_support           ;   
  bit                  src_castout_support                    ;   
  bit                  src_data_cache_flush_support           ;   
  bit                  src_io_read_support                    ;   
  bit                  src_inst_cache_inval_support           ;   
  bit                  src_tlb_inval_entry_support            ;   
  bit                  src_tlb_inval_entry_sync_support       ;   

  bit                  crf_support                            ;
  bit                  fc_support                             ;
  bit                  flow_arb_support_self                  ;
  bit                  flow_arb_support_lp                    ;
  bit                  ll_pass_sts                            ;
  bit                  tl_pass_sts                            ;
  bit                  ato_pkt                                ;
  bit                  maint_pkt                              ;
  bit                  pkt_validity                           ;
  bit                  io_pkt                                 ;
  bit                  fc_pkt                                 ;
  bit                  db_pkt                                 ;
  bit                  ds_pkt                                 ;
  bit                  msg_pkt                                ;
  bit                  gsm_pkt                                ;
  bit                  req_pkt                                ;
  bit                  res_pkt                                ;
  bit                  reqd_res_with_dp                       ;
  bit                  reqd_res                               ;
  bit                  valid_pkt                              ;
  bit                  valid_ftype                            ;
  bit                  single_req_pipelined                = 0;
  bit                  multi_req_pipelined                 = 0;
  bit                  orph_xoff                              ;
  bit                  drop_packet                            ; 
  bit                  protocol_check_completed            = 1;
  bit                  sseg                                   ;
  bit                  mseg                                   ;
  bit [ 2: 0]          tm_xoff_wc                             ;
  bit [ 3: 0]          tm_types_support                       ;
  bit [23: 0]          resp_timeout                           ;
  bit [ 7: 0]          mtu                                    ;
  bit [15: 0]          seg_support                            ;
  bit [15: 0]          max_pdu                                ;
  bit [ 2: 0]          ll_pkt_type                            ;
  bit [72: 0]          index                                  ;
  bit [72: 0]          outstanding_gsm_req_tid             = 0;
  bit [ 6: 0]          tx_valid_tran_flow                     ;
  bit [ 6: 0]          rx_valid_tran_flow                     ;
  bit [ 6: 0]          flow_id                                ;
  bit [ 6: 0]          valid_tran_flow                        ;
  bit [55: 0]          ds_xoff_index1                         ;
  bit [55: 0]          ds_credit_index1                       ;
  bit [ 7: 0]          mask                                   ;
  bit [ 2: 0]          wild_card                              ;
  bit [31: 0]          regcontent                             ;
  bit [31: 0]          rev_regcontent                         ;
  bit [70: 0]          orph_xoff_curr                         ;
  bit [65: 0]          address_66bit                          ;
  int                  xoff_timer                             ;
  int                  seg_support_bytes                      ;
  int                  max_pdu_bytes                          ;
  int                  dpl_size                               ;
  int                  pkt_count                              ;
  int                  ind_pkt_count                          ;
  int                  imp_defined_ftype                      ;
  int                  reserved_ftype                         ;
  int                  orph_xoff_timeout                      ;
  int                  req_xonxoff_timeout                    ;
  int                  xon_pdu_timeout                        ;
  int                  LTLED_CSR                              ;
  int                  ftype_count        [bit[ 7: 0]]        ;
  bit                  ds_tm_xoff_array   [bit[55: 0]]        ;
  bit                  tout_err_reported  [bit[72: 0]]        ;
  string               outstanding_gsm_req                    ;
  srio_ll_ds_assembly  ds_array           [bit[71: 0]]        ;
  srio_trans           pkts_to_process    [$]                 ;

  // Monitor Properties
  bit                  mon_type         ;  // 0-> rx       1-> tx
  bit                  en_err_report    ;  // 0-> Disable  1-> Enable err report 

  // Instance of srio_trans              
  srio_trans           ll_out_pkt       ;                
  srio_trans           pkt              ;
  srio_trans           mon_trans        ;
  srio_trans           in_packet        ;
  srio_trans           ato_packet       ;

  srio_ll_shared_class shared_class     ;  // Instance of Shared Class 
  srio_ll_config       ll_config        ;  // Instance of LL configuration
  srio_reg_block       ll_reg_model     ;  // Instance of Reg model-Self
  srio_reg_block       ll_reg_model_lp  ;  // Instance of Reg model-Link Partner
  srio_env_config      ll_mon_env_config;  // Instance of Env Config

  srio_ll_msg_assembly msg_assembly     ;  // Instance of MSG Assembly 
  srio_ll_lfc_assembly lfc_assembly     ;  // Instance of LFC Assembly
  srio_ll_ds_assembly  ds_assembly      ;  // Instance of DS  Assembly

  // Enum variables
  ll_err_kind          err_type         ;
  srio_ftype           ftype            ;
  type1_ttype          ttype1           ;
  type2_ttype          ttype2           ;
  type5_ttype          ttype5           ;
  type8_ttype          ttype8           ;
  type13_ttype         ttype13          ;
  pkt_sts              sts              ;

  // Analysis port
  uvm_analysis_port #(srio_trans) mon_ap;

  // Monitor imports
  uvm_analysis_imp #(srio_trans,srio_ll_txrx_monitor) ll_tx_mon_imp; 
  uvm_analysis_imp #(srio_trans,srio_ll_txrx_monitor) ll_rx_mon_imp; 

  /// @endcond

  extern function new(string name="srio_ll_txrx_monitor", 
                             uvm_component parent = null);
  extern function void build_phase(uvm_phase phase)  ;
  extern function void connect_phase(uvm_phase phase);
  extern task          run_phase(uvm_phase phase)    ;
  extern function void write(srio_trans t1)          ;
  extern function void process_pkt(srio_trans t)     ;
  extern function void report_phase(uvm_phase phase) ;

  extern function void srio_ll_pkt_protocol_chk()    ;
  extern function void wdptr_rdsize_chk()            ;
  extern function void lfc_checks()                  ;
  extern function void valid_flow_chk()              ;
  extern task          timer_track()                 ;
  extern function void ds_assembly_chk()             ;
  extern function void zero_dpl_chk()                ;
  extern function void reser_fld_chk()               ;
  extern function void resp_pkt_gen()                ;
  extern function void resp_pkt_chk()                ;
  extern function void outstanding_req_chk()         ;
  extern function void outstanding_ato_req_chk()     ;
  extern function void msg_assembly_chk()            ;
  extern function void exp_dpl_chk()                 ;
  extern function void ds_tm_chk()                   ;
  extern function void ll_update_ltled_csr()         ;
  extern function void ds_tm_xoff_array_update()     ;
  extern function void reg_content_reverse()         ;
  extern function void display_pkt_details()         ;
  extern function void oustanding_pkt_details()      ;
       
endclass: srio_ll_txrx_monitor

////////////////////////////////////////////////////////////////////////////////
/// Name: new \n 
/// Description: LL TXRX Monitor's new function \n
/// new
////////////////////////////////////////////////////////////////////////////////

function srio_ll_txrx_monitor::new(string name="srio_ll_txrx_monitor", 
                                   uvm_component parent=null);
  super.new(name, parent);
  drop_packet = 0; 
endfunction: new

////////////////////////////////////////////////////////////////////////////////
/// Name: build_phase \n 
/// Description: LL TXRX Monitor's build_phase function \n
/// build_phase
////////////////////////////////////////////////////////////////////////////////

function void srio_ll_txrx_monitor::build_phase(uvm_phase phase);

  if (!uvm_config_db #(srio_ll_config)::get(this,"", "ll_config", ll_config))
    `uvm_fatal("CONFIG_LOAD", "Cannot get() ll_config ")

  if (!uvm_config_db #(bit)::get(this, "", "mon_type", mon_type))
    `uvm_fatal("CONFIG_LOAD", "Cannot get() LL MON_TYPE Value")

  if (!uvm_config_db #(bit)::get(this, "", "en_err_report", en_err_report))
    `uvm_fatal("CONFIG_LOAD", "Cannot get() LL en_err_report Value")

  if (!uvm_config_db #(srio_ll_shared_class)::get(this, "", "ll_shared_trans",
      shared_class))
    `uvm_fatal("CONFIG_LOAD", "Cannot get() LL shared_class handle")

  if (!uvm_config_db #(srio_env_config)::get(this, "", "srio_env_config", 
      ll_mon_env_config))
    `uvm_fatal("CONFIG_LOAD", "Cannot get() Env Config Handle")

  `uvm_info("LL_MON", $sformatf("LL MON_TYPE %0h h en_err_report %0h h", 
  mon_type, en_err_report), UVM_LOW)

  mon_ap = new("txrx_monitor_ap", this);

  // Monitor imports
  ll_tx_mon_imp = new("ll_tx_mon_imp", this);
  ll_rx_mon_imp = new("ll_rx_mon_imp", this);

endfunction : build_phase

////////////////////////////////////////////////////////////////////////////////
/// Name: connect_phase \n 
/// Description: LL TXRX Monitor's connect_phase function \n
/// connect_phase
////////////////////////////////////////////////////////////////////////////////

function void srio_ll_txrx_monitor::connect_phase(uvm_phase phase);

  // Register Model 
  if (mon_type)
  begin // {
    ll_reg_model    = ll_mon_env_config.srio_reg_model_rx;
    ll_reg_model_lp = ll_mon_env_config.srio_reg_model_tx;
  end // }
  else
  begin // {
    ll_reg_model    = ll_mon_env_config.srio_reg_model_tx;
    ll_reg_model_lp = ll_mon_env_config.srio_reg_model_rx;
  end // }

  outstanding_gsm_req = "NULL"; 
endfunction: connect_phase

////////////////////////////////////////////////////////////////////////////////
/// Name: run_phase \n 
/// Description: LL TXRX Monitor's run_phase task \n
/// run_phase
//////////////////////////////////////////////////////////////////////////////// 

task srio_ll_txrx_monitor::run_phase(uvm_phase phase);

  // Error demotion - BFM instance is made to report errors as warnings
  err_demoter ll_err_demoter   = new;
  ll_err_demoter.en_err_demote = !en_err_report;
  uvm_report_cb::add(this,ll_err_demoter);

  // Timeout limits are obtained from LL Configuration
  orph_xoff_timeout                = ll_config.orph_xoff_timeout                                                      ; 
  req_xonxoff_timeout              = ll_config.req_xonxoff_timeout                                                    ;  
  xon_pdu_timeout                  = ll_config.xon_pdu_timeout                                                        ;   
  // Destination Support is obtained from Register model configuration
  dest_ds_support                  = ll_reg_model.Destination_Operations_CAR.Data_streaming.get()                     ;
  dest_rd_support                  = ll_reg_model.Destination_Operations_CAR.Nread.get()                              ;
  dest_write_support               = ll_reg_model.Destination_Operations_CAR.nwrite.get()                             ;
  dest_swrite_support              = ll_reg_model.Destination_Operations_CAR.Streaming_write.get()                    ;
  dest_nwriter_support             = ll_reg_model.Destination_Operations_CAR.Write_with_response.get()                ;
  dest_msg_support                 = ll_reg_model.Destination_Operations_CAR.Data_Message.get()                       ;
  dest_db_support                  = ll_reg_model.Destination_Operations_CAR.Doorbell.get()                           ;
  dest_ato_comp_swap_support       = ll_reg_model.Destination_Operations_CAR.Atomic_compare_and_swap.get()            ;
  dest_ato_test_swap_support       = ll_reg_model.Destination_Operations_CAR.Atomic_test_and_swap.get()               ;
  dest_ato_inc_support             = ll_reg_model.Destination_Operations_CAR.Atomic_increment.get()                   ;
  dest_ato_dec_support             = ll_reg_model.Destination_Operations_CAR.Atomic_decrement.get()                   ;
  dest_ato_set_support             = ll_reg_model.Destination_Operations_CAR.Atomic_set.get()                         ;
  dest_ato_clr_support             = ll_reg_model.Destination_Operations_CAR.Atomic_clear.get()                       ;
  dest_ato_swap_support            = ll_reg_model.Destination_Operations_CAR.Atomic_swap.get()                        ;
  dest_port_wr_support             = ll_reg_model.Destination_Operations_CAR.Port_write.get()                         ;
  dest_ds_tm_support               = ll_reg_model.Destination_Operations_CAR.Data_streaming_traffic_management.get()  ;

  dest_read_support                = ll_reg_model.Destination_Operations_CAR.Read.get()                               ;
  dest_inst_read_support           = ll_reg_model.Destination_Operations_CAR.Instruction_read.get()                   ;
  dest_read_ownership_support      = ll_reg_model.Destination_Operations_CAR.Read_for_ownership.get()                 ;
  dest_data_cache_inval_support    = ll_reg_model.Destination_Operations_CAR.Data_cache_invalidate.get()              ;
  dest_castout_support             = ll_reg_model.Destination_Operations_CAR.Castout.get()                            ;
  dest_data_cache_flush_support    = ll_reg_model.Destination_Operations_CAR.Data_cache_flush.get()                   ;
  dest_io_read_support             = ll_reg_model.Destination_Operations_CAR.IO_read.get()                            ;
  dest_inst_cache_inval_support    = ll_reg_model.Destination_Operations_CAR.Instruction_cache_invalidate.get()       ;
  dest_tlb_inval_entry_support     = ll_reg_model.Destination_Operations_CAR.TLB_invalidate_entry.get()               ;
  dest_tlb_inval_entry_sync_support= ll_reg_model.Destination_Operations_CAR.TLB_invalidate_entry_sync.get()          ;

  // Source Support is obtained from Register model configuration
  src_ds_support                   = ll_reg_model_lp.Source_Operations_CAR.Data_streaming.get()                       ;
  src_rd_support                   = ll_reg_model_lp.Source_Operations_CAR.Nread.get()                                ;
  src_write_support                = ll_reg_model_lp.Source_Operations_CAR.nwrite.get()                               ;
  src_swrite_support               = ll_reg_model_lp.Source_Operations_CAR.Streaming_write.get()                      ;
  src_nwriter_support              = ll_reg_model_lp.Source_Operations_CAR.Write_with_response.get()                  ;
  src_msg_support                  = ll_reg_model_lp.Source_Operations_CAR.Data_Message.get()                         ;
  src_db_support                   = ll_reg_model_lp.Source_Operations_CAR.Doorbell.get()                             ;
  src_ato_comp_swap_support        = ll_reg_model_lp.Source_Operations_CAR.Atomic_compare_and_swap.get()              ;
  src_ato_test_swap_support        = ll_reg_model_lp.Source_Operations_CAR.Atomic_test_and_swap.get()                 ;
  src_ato_inc_support              = ll_reg_model_lp.Source_Operations_CAR.Atomic_increment.get()                     ;
  src_ato_dec_support              = ll_reg_model_lp.Source_Operations_CAR.Atomic_decrement.get()                     ;
  src_ato_set_support              = ll_reg_model_lp.Source_Operations_CAR.Atomic_set.get()                           ;
  src_ato_clr_support              = ll_reg_model_lp.Source_Operations_CAR.Atomic_clear.get()                         ;
  src_ato_swap_support             = ll_reg_model_lp.Source_Operations_CAR.Atomic_swap.get()                          ;
  src_port_wr_support              = ll_reg_model_lp.Source_Operations_CAR.Port_write.get()                           ;
  src_ds_tm_support                = ll_reg_model_lp.Source_Operations_CAR.Data_streaming_traffic_management.get()    ;

  src_read_support                 = ll_reg_model_lp.Source_Operations_CAR.Read.get()                                 ;
  src_inst_read_support            = ll_reg_model_lp.Source_Operations_CAR.Instruction_read.get()                     ;
  src_read_ownership_support       = ll_reg_model_lp.Source_Operations_CAR.Read_for_ownership.get()                   ;
  src_data_cache_inval_support     = ll_reg_model_lp.Source_Operations_CAR.Data_cache_invalidate.get()                ;
  src_castout_support              = ll_reg_model_lp.Source_Operations_CAR.Castout.get()                              ;
  src_data_cache_flush_support     = ll_reg_model_lp.Source_Operations_CAR.Data_cache_flush.get()                     ;
  src_io_read_support              = ll_reg_model_lp.Source_Operations_CAR.IO_read.get()                              ;
  src_inst_cache_inval_support     = ll_reg_model_lp.Source_Operations_CAR.Instruction_cache_invalidate.get()         ;
  src_tlb_inval_entry_support      = ll_reg_model_lp.Source_Operations_CAR.TLB_invalidate_entry.get()                 ;
  src_tlb_inval_entry_sync_support = ll_reg_model_lp.Source_Operations_CAR.TLB_invalidate_entry_sync.get()            ;

  crf_support                      = ll_reg_model.Processing_Element_Features_CAR.CRF_Support.get()                   ;
  fc_support                       = ll_reg_model.Processing_Element_Features_CAR.Flow_Control_Support.get()          ;
  flow_arb_support_self            = ll_reg_model.Processing_Element_Features_CAR.Flow_Arbitration_Support.get()      ;
  flow_arb_support_lp              = ll_reg_model_lp.Processing_Element_Features_CAR.Flow_Arbitration_Support.get()   ;
  seg_support                      = ll_reg_model.Data_Streaming_Information_CAR.SegSupport.get()                     ;
  max_pdu                          = ll_reg_model.Data_Streaming_Information_CAR.MaxPDU.get()                         ;

  // TM Type Support - Read-only bit
  tm_types_support                 = ll_reg_model.Data_Streaming_Logical_Layer_Control_CSR.TM_Types_Supported.get()   ;

  // Big Endian to Little Endian conversion for ease of access
  regcontent = {16'h0,max_pdu};
  reg_content_reverse();
  max_pdu = rev_regcontent[31:16];
  max_pdu_bytes = max_pdu;
  if (max_pdu == 0)  
  begin // {
    max_pdu_bytes = 'h1_0000; // 64KBytes  
  end // }

  regcontent = {16'h0,seg_support};
  reg_content_reverse();
  seg_support = rev_regcontent[31:16];
  seg_support_bytes = seg_support;
  if (seg_support == 0)  
  begin // {
    seg_support_bytes = 'h1_0000; // 64K segmentation contexts 
  end // }

  // Error status register initialization
  LTLED_CSR  = 32'h0;
  orph_xoff  = 0;
  xoff_timer = 0;

  // Timers are started only after receiving the first packet
  @ll_mon_received_pkt;  
  fork // {
    begin // { Timer updates
      forever 
      begin  // {
        // All the tracking timers are updated/incremented once in every 1ns
        timer_track(); 
        #1ns; 
      end // }
    end // }
 
    begin // { // Protocol checks
      forever 
      begin  // {
        wait(pkts_to_process.size() > 0); 
        begin // {          
          in_packet = new pkts_to_process.pop_front(); 
          process_pkt(in_packet); 
        end // } 
      end // }
    end // } 
  join // }

endtask: run_phase

////////////////////////////////////////////////////////////////////////////////
/// Name: write \n
/// Description: LL TXRX Monitor's write function \n
///              Stores all the packets received through the analysis port of \n  
///              other layers into a queue \n    
/// write
//////////////////////////////////////////////////////////////////////////////// 

function void srio_ll_txrx_monitor::write(srio_trans t1);
  pkts_to_process.push_back(t1); 
  // Triggers event whenever a packet is received
  ->ll_mon_received_pkt;  
  `uvm_info("LL_MON", $sformatf("LL_MON_RECEIVED_A_NEW_PKT @%0t", $time),UVM_LOW)
endfunction: write

////////////////////////////////////////////////////////////////////////////////
/// Name: process_pkt \n
/// Description: LL TXRX Monitor's process_pkt function \n
///              Does first level processing of the received packet \n  
///              Updates the TType wise packet counter   \n
///              Call the protocol checker to perform further checks and \n  
///              sends out the packet through the analysis port \n    
/// process_pkt
//////////////////////////////////////////////////////////////////////////////// 

function void srio_ll_txrx_monitor::process_pkt(srio_trans t); 

  ll_out_pkt = new t;
  pkt        = new t;
  ato_packet = new t;
  LTLED_CSR  = 32'h0;

  if (ll_mon_env_config.en_ext_addr_support == 1) 
    address_66bit = {pkt.xamsbs, pkt.ext_address, pkt.address, 3'b0};
  else
    address_66bit = {32'b0, pkt.xamsbs, pkt.address, 3'b0};

  if ((pkt.ftype == 6) || (pkt.ftype == 7) || (pkt.ftype == 9) || 
      (pkt.ftype == 10) || (pkt.ftype == 11))
    ftype_count[{pkt.ftype,4'b0}]      = ftype_count[{pkt.ftype,4'b0}]      + 1;
  else
    ftype_count[{pkt.ftype,pkt.ttype}] = ftype_count[{pkt.ftype,pkt.ttype}] + 1;

  pkt_count = pkt_count + 1;

  // Config variable is updated with Total packet count received by the monitor
  if (mon_type)
  begin // {
    ll_config.tx_mon_tot_pkt_rcvd = pkt_count;
  end // }
  else
  begin // {
    ll_config.rx_mon_tot_pkt_rcvd = pkt_count;
  end // }

  // LL Protocol checks are done only when ENV and LL 'has_checks' are set
  if (ll_config.has_checks && ll_mon_env_config.has_checks)
  begin // {
    if (pkt.pl_err_encountered)
    begin // {
      `uvm_info("LL_MON", 
      $sformatf("Packet Ftype: %0h h is not entering into LL checks because of\
      PL error", pkt.ftype), UVM_LOW)
    end // }  
    else 
    begin // {
      protocol_check_completed = 0;
      srio_ll_pkt_protocol_chk();
      protocol_check_completed = 1;
      ll_update_ltled_csr();
    end // }
  end //}

  // Packet is sent through the analysis port
  mon_ap.write(ll_out_pkt);
 
endfunction: process_pkt

////////////////////////////////////////////////////////////////////////////////
/// Name: report_phase \n 
/// Description: LL TXRX Monitor's report_phase function \n
/// report_phase
////////////////////////////////////////////////////////////////////////////////

function void srio_ll_txrx_monitor::report_phase(uvm_phase phase);
 
  display_pkt_details();
  oustanding_pkt_details();

endfunction: report_phase      
                                                                                 
////////////////////////////////////////////////////////////////////////////////
/// Name: srio_ll_pkt_protocol_chk \n 
/// Description: LL Protocol Checker function \n
/// srio_ll_pkt_protocol_chk
////////////////////////////////////////////////////////////////////////////////

function void srio_ll_txrx_monitor::srio_ll_pkt_protocol_chk();     
  // Initial values 
  err_type     = NONE;
  ato_pkt      = 0;
  maint_pkt    = 0;
  io_pkt       = 0;
  fc_pkt       = 0;
  db_pkt       = 0;
  ds_pkt       = 0;
  msg_pkt      = 0;
  gsm_pkt      = 0;
  req_pkt      = 1; 
  res_pkt      = 0; 
  tl_pass_sts  = pkt.tl_err_encountered;
  ll_pass_sts  = 1;
  pkt_validity = 1;
  valid_pkt    = 1;   
  valid_ftype  = 1;

  ftype        = srio_ftype'(pkt.ftype);
  ttype1       = type1_ttype'(pkt.ttype);
  ttype2       = type2_ttype'(pkt.ttype);
  ttype5       = type5_ttype'(pkt.ttype);
  ttype8       = type8_ttype'(pkt.ttype);
  ttype13      = type13_ttype'(pkt.ttype);
  sts          = pkt_sts'(pkt.trans_status);

  // GSM Packets
  // TYPE1 GSM Packets
  if(((ftype  == TYPE1) &&    
     ((ttype1 == RD_OWNER)    || (ttype1 == RD_OWN_OWNER) || 
      (ttype1 == IO_RD_OWNER)))                                              ||
     // TYPE2 GSM Packets
     ((ftype  == TYPE2) &&   
     ((ttype2 == RD_HOME)     || (ttype2 == RD_OWN_HOME)  || 
      (ttype2 == IORD_HOME)   ||
      (ttype2 == DKILL_HOME)  || (ttype2 == IKILL_HOME)   || 
      (ttype2 == TLBIE)       || (ttype2 == TLBSYNC)      || 
      (ttype2 == IRD_HOME)    || (ttype2 == FLUSH_WO_DATA)||
      (ttype2 == IKILL_SHARER)|| (ttype2 == DKILL_SHARER)))                  ||
     // TYPE5 GSM Packets
     ((ftype  == TYPE5) &&   
     ((ttype5 == CAST_OUT)    || (ttype5 == FLUSH_WD))))             
  begin // {
    gsm_pkt = 1;
  end // }

  // IO Request Packets
     // TYPE2 IO Packets
  if(((ftype  == TYPE2) && 
     ((ttype2 == NRD)         || (ttype2 == ATO_INC)      ||
      (ttype2 == ATO_DEC)     || (ttype2 == ATO_SET)      ||
      (ttype2 == ATO_CLR)))                                                  ||
     // TYPE5 IO Packets
     ((ftype  == TYPE5) && 
     ((ttype5 == NWR)         || (ttype5 == NWR_R)        ||
      (ttype5 == ATO_SWAP)    || (ttype5 == ATO_COMP_SWAP)|| 
      (ttype5 == ATO_TEST_SWAP)))                                            || 
     // TYPE6 IO Packets
      (ftype  == TYPE6)                                                      ||
     // TYPE8 IO Packets
     ((ftype  == TYPE8) && 
     ((ttype8 == MAINT_RD_REQ)     || (ttype8 == MAINT_WR_REQ)      || 
      (ttype8 == MAINT_RD_RES)     || (ttype8 == MAINT_WR_RES)      || 
      (ttype8 == MAINT_PORT_WR_REQ))))
  begin // {
    io_pkt = 1;
  end // }  

  if(((ftype  == TYPE2) && 
     ((ttype2 == ATO_INC)     || (ttype2 == ATO_DEC)  || 
      (ttype2 == ATO_SET)     || (ttype2 == ATO_CLR)))       ||    
     ((ftype  == TYPE5) && 
     ((ttype5 == ATO_SWAP)    || (ttype5 == ATO_COMP_SWAP)|| 
      (ttype5 == ATO_TEST_SWAP)))) 
  begin // {
    ato_pkt = 1;
  end // }  

  // FC Packet
  if (ftype == TYPE7)
    fc_pkt = 1;

  // DS Packet
  if (ftype == TYPE9)
    ds_pkt = 1;

  // DB Packet
  if (ftype == TYPE10)
    db_pkt = 1;

  // Message Packets
  if (((ftype == TYPE13) && (ttype13 == MSG_RES)) || (ftype == TYPE11))
    msg_pkt = 1; 

  // Response packets
  if (((ftype   == TYPE8)   && 
      ((ttype8  == MAINT_RD_RES) || (ttype8 == MAINT_WR_RES) || 
       (ttype8 == MAINT_WR_RES))) ||
      ((ftype   == TYPE13)  &&  
      ((ttype13 == RES_WO_DP)   || (ttype13 == MSG_RES) || 
       (ttype13 == RES_WITH_DP)))) 
  begin
    req_pkt = 0; 
    res_pkt = 1;
  end

  // Index extraction
  if (req_pkt)
  begin // {
    if (msg_pkt)
      index = {pkt.SourceID, pkt.DestinationID, 1'b1, pkt.letter, pkt.mbox, pkt.msgseg_xmbox};
    else 
      index = {pkt.SourceID, pkt.DestinationID, 1'b0, pkt.SrcTID};
  end // }
  else
  begin // {
    if (msg_pkt)
      index = {pkt.DestinationID, pkt.SourceID, 1'b1, pkt.targetID_Info};
    else 
      index = {pkt.DestinationID, pkt.SourceID, 1'b0, pkt.targetID_Info};
  end // }

  ds_tm_xoff_array.delete;

  // Update the variables/arrays from the shared class content
  if (mon_type) 
  begin // {
    ds_tm_xoff_array = `RX_DS_TM_XOFF_ARRAY;
    tm_xoff_wc       = `RX_DS_TM_WC;
  end // }
  else 
  begin // {
    ds_tm_xoff_array = `TX_DS_TM_XOFF_ARRAY;
    tm_xoff_wc       = `TX_DS_TM_WC;
  end // }

  ll_pkt_type = (io_pkt ? 1 : (msg_pkt ? 2 : (gsm_pkt ? 3 : 0)));

  if (pkt.tl_pkt_valid)
  begin // {
    if (gsm_pkt || io_pkt || fc_pkt || ds_pkt || db_pkt || msg_pkt || res_pkt)
    begin // {
      valid_pkt = 1;   
    end // }
    else 
    begin // {
      valid_pkt = 0;   
    end // }
  end // }
  else
  begin // {
    valid_pkt = 0;   
    `uvm_info("SRIO_LL_PROTOCOL_CHECKER", 
    $sformatf("TID_%0h; Not entering into LL checks because of TL error", 
    index[7:0]), UVM_LOW) 
  end // }

  // Maintenace Packet
  if (valid_pkt & (ftype == TYPE8)) 
    maint_pkt = 1;   
 
  if ((ftype == TYPE1)                                                  || 
     ((ftype == TYPE2) && 
     ((ttype2 == NRD) || (ttype2 == RD_HOME) || (ttype2 == RD_OWN_HOME) || 
      (ttype2 == IORD_HOME) || (ttype2 == IRD_HOME)))                   || 
      (ato_pkt)                                                         ||
      (maint_pkt && (ttype8 == MAINT_RD_REQ))) 
  begin // {   
    reqd_res_with_dp = 1;
  end // }
  if((reqd_res_with_dp)                     || 
     (gsm_pkt)                              ||
    ((ftype == TYPE5) && (ttype5 != NWR))   || 
      (maint_pkt && (ttype8 == MAINT_WR_REQ))    ||
      (db_pkt || (msg_pkt && req_pkt))) 
  begin // {   
    reqd_res = 1;
  end // }

  // Maintenance and flow control transaction request flows must never cause the 
  // generation of a flow control transaction
  if ((!maint_pkt) && (!fc_pkt) && valid_pkt)
  begin // {
    if (mon_type)
    begin // {
      if (shared_class.tx_max_prio_sent < pkt.prio)   
      begin // {
        shared_class.tx_max_prio_sent = pkt.prio;
      end // }
    end // }
    else
    begin // {
      if (shared_class.rx_max_prio_sent < pkt.prio)   
      begin // {
        shared_class.rx_max_prio_sent = pkt.prio;
      end // }
    end // }
  end // }

  if ((ftype == 3) || (ftype == 4) || (ftype == 12) || (ftype == 14) || 
      (ftype == 0) || (ftype == 15))  
  begin // {
    valid_ftype = 0;
  end // } 

  if (valid_pkt)
  begin // {
    pkt.print();
 
    `uvm_info("SRIO_LL_PROTOCOL_CHECKER", $sformatf("\n \
    LL_%s_MON_CHK ........................: %s - %s; %s @ %0t TID_%0h;\
DS->(COS_%0h S_%0h E_%0h) MSG (Msg_len %0h h)->(LETTER_%0h_MBX_%0h msgseg_%0h)\n \
    Source ID ........................... : %0h; \n \
    tgtdestID(Valid only for LFC Pkt) ... : %0h; \n \
    Destination ID .......................: %0h;", 
     ((mon_type == 1) ? "TX" : "RX"),  
       ftype.name, (
      (ftype == 1) ? ttype1.name : (
      (ftype == 2) ? ttype2.name : (
      (ftype == 5) ? ttype5.name : (
      (ftype == 6) ? "SWRITE"    : (
      (ftype == 7) ? "LFC"       : (
      (ftype == 8) ? ttype8.name : (
      (ftype == 9) ? ((pkt.xh == 1) ? "DS TM" : "DS") : (
      (ftype == 10)? "DOOR BELL" : (
      (ftype == 11)? ((pkt.msg_len > 0) ? "DATA MSG - MSEG" : "DATA MSG - SSEG") : (
      (ftype == 13)? ttype13.name: {ftype.name," UNRECOGNIZED PKT"})))))))))),
     ((res_pkt == 1) ? sts.name : "REQ_PKT"), $time, index[7:0], pkt.cos, pkt.S, pkt.E, 
       pkt.msg_len, pkt.letter, pkt.mbox, pkt.msgseg_xmbox, pkt.SourceID, 
       pkt.tgtdestID, pkt.DestinationID), UVM_LOW);

    if ((pkt.ftype == 6) || (pkt.ftype == 7) || (pkt.ftype == 9) || 
        (pkt.ftype == 10) || (pkt.ftype == 11))
      ind_pkt_count = ftype_count[{pkt.ftype,4'b0}];
    else
      ind_pkt_count = ftype_count[{pkt.ftype,pkt.ttype}];

    `uvm_info("PACKET_DETAIL", $sformatf("\n\
              PACKET_COUNT_UPDATE \n\
         Current_Packet_Count    : %0d    \n\
         Total_Packet_Count      : %0d    \n\
    ---------------------------------------", 
    ind_pkt_count, pkt_count), UVM_LOW)

    // SWrite, NWrite and Maintence Port Write requests do not have response.
    // And hence SrcTID check need not be done
    if ((io_pkt && !((ftype == TYPE6)                                || 
                    ((ftype == 5) && (ttype5 == NWR))                || 
                    ((ftype == 8) && (ttype8 == MAINT_PORT_WR_REQ))))     || 
         db_pkt || msg_pkt || res_pkt || gsm_pkt)
    begin // {
      outstanding_req_chk();
    end // }
    
    // Check for Atomic operations for not getting interrupted by another
    // operation of the same address
    if ((ftype == TYPE1)|| (ftype == TYPE2)  || 
        (ftype == TYPE5) || (ftype == TYPE6)) 
    begin // {
      outstanding_ato_req_chk();
    end // }

    if (pkt_validity)
    begin // {
      valid_flow_chk();   
 
      case (ftype)
        
        TYPE1: // - GSM packets
        begin // {
          case (ttype1)
            RD_OWNER:
            begin // {
              if (dest_read_support)
              begin // {
                if (src_read_support == 0)
                begin // {
                  `uvm_error("SRIO_LL_PROTOCOL_CHECKER:SRC_OP_UNSUPPORTED_ERR", 
                  $sformatf("SpecRef:Part5-Section5.4.1: TID_%0h; FTYPE: %s; TTYPE: %s\
                  No Src support to issue this packet", index[7:0], ftype.name, ttype1.name))
                  err_type = SRC_OP_UNSUPPORTED_ERR; 
                end // }
                zero_dpl_chk(); 
                wdptr_rdsize_chk(); 
                resp_pkt_gen();  
              end // }
              else
              begin // {
                LTLED_CSR[9] = 1;
                `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DEST_OP_UNSUPPORTED_ERR", 
                $sformatf("SpecRef:Part5-Section5.4.2: TID_%0h; FTYPE: %s; TTYPE: %s\
                No Destination support to process this Packet; ",
                index[7:0], ftype.name, ttype1.name))
                ll_pass_sts = 0; 
                err_type = DEST_OP_UNSUPPORTED_ERR; 
              end // } 
            end // }
            RD_OWN_OWNER:
            begin // {
              if (dest_read_ownership_support)
              begin // {
                if (src_read_ownership_support == 0)
                begin // {
                  `uvm_error("SRIO_LL_PROTOCOL_CHECKER:SRC_OP_UNSUPPORTED_ERR", 
                  $sformatf("SpecRef:Part5-Section5.4.1: TID_%0h; FTYPE: %s; TTYPE: %s\
                  No Src support to issue this packet", 
                  index[7:0], ftype.name, ttype1.name))
                  err_type = SRC_OP_UNSUPPORTED_ERR; 
                end // }
                zero_dpl_chk(); 
                wdptr_rdsize_chk(); 
                resp_pkt_gen();  
              end // }
              else
              begin // {
                LTLED_CSR[9] = 1;
                `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DEST_OP_UNSUPPORTED_ERR", 
                $sformatf("SpecRef:Part5-Section5.4.2: TID_%0h; FTYPE: %s; TTYPE: %s\
                No Destination support to process this Packet; ", 
                index[7:0], ftype.name, ttype1.name))
                ll_pass_sts = 0; 
                err_type = DEST_OP_UNSUPPORTED_ERR; 
              end // } 
            end // }
            IO_RD_OWNER:
            begin // {
              if (dest_io_read_support)
              begin // {
                if (src_io_read_support == 0)
                begin // {
                  `uvm_error("SRIO_LL_PROTOCOL_CHECKER:SRC_OP_UNSUPPORTED_ERR", 
                  $sformatf("SpecRef:Part5-Section5.4.1: TID_%0h; FTYPE: %s; TTYPE: %s\
                  No Src support to issue this packet", 
                  index[7:0], ftype.name, ttype1.name))
                  err_type = SRC_OP_UNSUPPORTED_ERR; 
                end // }
                zero_dpl_chk(); 
                wdptr_rdsize_chk(); 
                resp_pkt_gen();  
              end // }
              else
              begin // {
                LTLED_CSR[9] = 1;
                `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DEST_OP_UNSUPPORTED_ERR", 
                $sformatf("SpecRef:Part5-Section5.4.2: TID_%0h; FTYPE: %s; TTYPE: %s\
                No Destination support to process this Packet;", 
                index[7:0], ftype.name, ttype1.name))
                ll_pass_sts = 0; 
                err_type = DEST_OP_UNSUPPORTED_ERR; 
              end // } 
            end // }
          endcase
        end // } 

    // =============================================================================
    
        TYPE2:
        begin // {
          case (ttype2)
            RD_HOME: 
            begin // {
              if (dest_read_support)
              begin // {
                if (src_read_support == 0)
                begin // {
                  `uvm_error("SRIO_LL_PROTOCOL_CHECKER:SRC_OP_UNSUPPORTED_ERR", 
                  $sformatf("SpecRef:Part5-Section5.4.1: TID_%0h; FTYPE: %s; TTYPE: %s\
                  No Src support to issue this packet", 
                  index[7:0], ftype.name, ttype2.name))
                  err_type = SRC_OP_UNSUPPORTED_ERR; 
                end // }
                zero_dpl_chk(); // check for no data payload 
                wdptr_rdsize_chk();  
                resp_pkt_gen();  
              end // }
              else
              begin // {
                LTLED_CSR[9] = 1;
                `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DEST_OP_UNSUPPORTED_ERR", 
                $sformatf("SpecRef:Part5-Section5.4.2: TID_%0h; FTYPE: %s; TTYPE: %s\
                No Destination support to process this Packet;", 
                index[7:0], ftype.name, ttype2.name))
                ll_pass_sts = 0; 
                err_type = DEST_OP_UNSUPPORTED_ERR; 
              end // } 
            end // } 


            RD_OWN_HOME: 
            begin // {
              if (dest_read_ownership_support)
              begin // {
                if (src_read_ownership_support == 0)
                begin // {
                  `uvm_error("SRIO_LL_PROTOCOL_CHECKER:SRC_OP_UNSUPPORTED_ERR", 
                  $sformatf("SpecRef:Part5-Section5.4.1: TID_%0h; FTYPE: %s; TTYPE: %s\
                  No Src support to issue this packet", 
                  index[7:0], ftype.name, ttype2.name))
                  err_type = SRC_OP_UNSUPPORTED_ERR; 
                end // }
                zero_dpl_chk(); // check for no data payload 
                wdptr_rdsize_chk();  
                resp_pkt_gen();  
              end // }
              else
              begin // {
                LTLED_CSR[9] = 1;
                `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DEST_OP_UNSUPPORTED_ERR", 
                $sformatf("SpecRef:Part5-Section5.4.2: TID_%0h; FTYPE: %s; TTYPE: %s\
                No Destination support to process this Packet;",
                index[7:0], ftype.name, ttype2.name))
                ll_pass_sts = 0; 
                err_type = DEST_OP_UNSUPPORTED_ERR; 
              end // } 
            end // } 


            IORD_HOME: 
            begin // {
              if (dest_io_read_support)
              begin // {
                if (src_io_read_support == 0)
                begin // {
                  `uvm_error("SRIO_LL_PROTOCOL_CHECKER:SRC_OP_UNSUPPORTED_ERR", 
                  $sformatf("SpecRef:Part5-Section5.4.1: TID_%0h; FTYPE: %s; TTYPE: %s \
                  No Src support to issue this packet",
                  index[7:0], ftype.name, ttype2.name))
                  err_type = SRC_OP_UNSUPPORTED_ERR; 
                end // }
                zero_dpl_chk();                                           
                wdptr_rdsize_chk();  
                resp_pkt_gen();  
              end // }
              else
              begin // {
                LTLED_CSR[9] = 1;
                `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DEST_OP_UNSUPPORTED_ERR", 
                $sformatf("SpecRef:Part5-Section5.4.2: TID_%0h; FTYPE: %s; TTYPE: %s \
                No Destination support to process this Packet;", 
                index[7:0], ftype.name, ttype2.name))
                ll_pass_sts = 0; 
                err_type = DEST_OP_UNSUPPORTED_ERR; 
              end // } 
            end // } 

            DKILL_HOME: 
            begin // {
              if (dest_data_cache_inval_support)
              begin // {
                if (src_data_cache_inval_support == 0)
                begin // {
                  `uvm_error("SRIO_LL_PROTOCOL_CHECKER:SRC_OP_UNSUPPORTED_ERR", 
                  $sformatf("SpecRef:Part5-Section5.4.1: TID_%0h; FTYPE: %s; TTYPE: %s \
                  No Src support to issue this packet", 
                  index[7:0], ftype.name, ttype2.name))
                  err_type = SRC_OP_UNSUPPORTED_ERR; 
                end // }
                zero_dpl_chk(); // check for no data payload 
                wdptr_rdsize_chk();  
                reser_fld_chk();  
                resp_pkt_gen();  
              end // }
              else
              begin // {
                LTLED_CSR[9] = 1;
                `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DEST_OP_UNSUPPORTED_ERR", 
                $sformatf("SpecRef:Part5-Section5.4.2: TID_%0h; FTYPE: %s; TTYPE: %s \
                No Destination support to process this Packet;",
                index[7:0], ftype.name, ttype2.name))
                ll_pass_sts = 0; 
                err_type = DEST_OP_UNSUPPORTED_ERR; 
              end // } 
            end // } 


            IKILL_HOME: 
            begin // {
              if (dest_inst_cache_inval_support)
              begin // {
                if (src_inst_cache_inval_support == 0)
                begin // {
                  `uvm_error("SRIO_LL_PROTOCOL_CHECKER:SRC_OP_UNSUPPORTED_ERR", 
                  $sformatf("SpecRef:Part5-Section5.4.1: TID_%0h; FTYPE: %s; TTYPE: %s \
                  No Src support to issue this packet",
                  index[7:0], ftype.name, ttype2.name))
                  err_type = SRC_OP_UNSUPPORTED_ERR; 
                end // }
                zero_dpl_chk(); // check for no data payload 
                wdptr_rdsize_chk();  
                reser_fld_chk();  
                resp_pkt_gen();  
              end // }
              else
              begin // {
                LTLED_CSR[9] = 1;
                `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DEST_OP_UNSUPPORTED_ERR", 
                $sformatf("SpecRef:Part5-Section5.4.2: TID_%0h; FTYPE: %s; TTYPE: %s \
                No Destination support to process this Packet;", 
                index[7:0], ftype.name, ttype2.name))
                ll_pass_sts = 0; 
                err_type = DEST_OP_UNSUPPORTED_ERR; 
              end // } 
            end // } 


            TLBIE: 
            begin // {
              if (dest_tlb_inval_entry_support)
              begin // {
                if (src_tlb_inval_entry_support == 0)
                begin // {
                  `uvm_error("SRIO_LL_PROTOCOL_CHECKER:SRC_OP_UNSUPPORTED_ERR", 
                  $sformatf("SpecRef:Part5-Section5.4.1: TID_%0h; FTYPE: %s; TTYPE: %s \
                  No Src support to issue this packet",
                  index[7:0], ftype.name, ttype2.name))
                  err_type = SRC_OP_UNSUPPORTED_ERR; 
                end // }
                zero_dpl_chk(); // check for no data payload 
                wdptr_rdsize_chk();  
                reser_fld_chk();  
                resp_pkt_gen();  
              end // }
              else
              begin // {
                LTLED_CSR[9] = 1;
                `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DEST_OP_UNSUPPORTED_ERR", 
                $sformatf("SpecRef:Part5-Section5.4.2: TID_%0h; FTYPE: %s; TTYPE: %s \
                No Destination support to process this Packet;",
                index[7:0], ftype.name, ttype2.name))
                ll_pass_sts = 0;         
                err_type = DEST_OP_UNSUPPORTED_ERR; 
              end // } 
            end // } 


            TLBSYNC: 
            begin // {
              if (dest_tlb_inval_entry_sync_support)
              begin // {
                if (src_tlb_inval_entry_sync_support == 0)
                begin // {
                  `uvm_error("SRIO_LL_PROTOCOL_CHECKER:SRC_OP_UNSUPPORTED_ERR", 
                  $sformatf("SpecRef:Part5-Section5.4.1: TID_%0h; FTYPE: %s; TTYPE: %s \
                No Src support to issue this packet", 
                  index[7:0], ftype.name, ttype2.name))
                  err_type = SRC_OP_UNSUPPORTED_ERR; 
                end // }
                zero_dpl_chk(); // check for no data payload 
                wdptr_rdsize_chk();  
                reser_fld_chk();  
                resp_pkt_gen();  
              end // }
              else
              begin // {
                LTLED_CSR[9] = 1;
                `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DEST_OP_UNSUPPORTED_ERR", 
                $sformatf("SpecRef:Part5-Section5.4.2: TID_%0h; FTYPE: %s; TTYPE: %s \
                No Destination support to process this Packet;",
                index[7:0], ftype.name, ttype2.name))
                ll_pass_sts = 0;         
                err_type = DEST_OP_UNSUPPORTED_ERR; 
              end // } 
            end // } 


            IRD_HOME: 
            begin // {
              if (dest_inst_read_support)
              begin // {
                if (src_inst_read_support == 0)
                begin // {
                  `uvm_error("SRIO_LL_PROTOCOL_CHECKER:SRC_OP_UNSUPPORTED_ERR", 
                  $sformatf("SpecRef:Part5-Section5.4.1: TID_%0h; FTYPE: %s; TTYPE: %s \
                  No Src support to issue this packet",
                  index[7:0], ftype.name, ttype2.name))
                  err_type = SRC_OP_UNSUPPORTED_ERR; 
                end // }
                zero_dpl_chk(); // check for no data payload 
                wdptr_rdsize_chk();  
                resp_pkt_gen();  
              end // }
              else
              begin // {
                LTLED_CSR[9] = 1;
                `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DEST_OP_UNSUPPORTED_ERR", 
                $sformatf("SpecRef:Part5-Section5.4.2: TID_%0h; FTYPE: %s; TTYPE: %s \
                No Destination support to process this Packet;",
                index[7:0], ftype.name, ttype2.name))
                ll_pass_sts = 0;         
                err_type = DEST_OP_UNSUPPORTED_ERR; 
              end // } 
            end // } 

            FLUSH_WO_DATA: 
            begin // {
              if (dest_data_cache_flush_support)
              begin // {
                if (src_data_cache_flush_support == 0)
                begin // {
                  `uvm_error("SRIO_LL_PROTOCOL_CHECKER:SRC_OP_UNSUPPORTED_ERR", 
                  $sformatf("SpecRef:Part5-Section5.4.1: TID_%0h; FTYPE: %s; TTYPE: %s \
                  No Src support to issue this packet", 
                  index[7:0], ftype.name, ttype2.name))
                  err_type = SRC_OP_UNSUPPORTED_ERR; 
                end // }
                zero_dpl_chk(); // check for no data payload 
                wdptr_rdsize_chk();  
                reser_fld_chk();  
                resp_pkt_gen();  
              end // }
              else
              begin // {
                LTLED_CSR[9] = 1;
                `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DEST_OP_UNSUPPORTED_ERR", 
                $sformatf("SpecRef:Part5-Section5.4.2: TID_%0h; FTYPE: %s; TTYPE: %s \
                No Destination support to process this Packet;",
                index[7:0], ftype.name, ttype2.name))
                ll_pass_sts = 0;         
                err_type = DEST_OP_UNSUPPORTED_ERR; 
              end // } 
            end // } 

            IKILL_SHARER: 
            begin // {
              if (dest_inst_cache_inval_support)
              begin // {
                if (src_inst_cache_inval_support == 0)
                begin // {
                  `uvm_error("SRIO_LL_PROTOCOL_CHECKER:SRC_OP_UNSUPPORTED_ERR", 
                  $sformatf("SpecRef:Part5-Section5.4.1: TID_%0h; FTYPE: %s; TTYPE: %s \
                  No Src support to issue this packet",
                  index[7:0], ftype.name, ttype2.name))
                  err_type = SRC_OP_UNSUPPORTED_ERR; 
                end // }
                zero_dpl_chk(); // check for no data payload 
                wdptr_rdsize_chk();  
                reser_fld_chk();  
                resp_pkt_gen();  
              end // }
              else
              begin // {
                LTLED_CSR[9] = 1;
                `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DEST_OP_UNSUPPORTED_ERR", 
                $sformatf("SpecRef:Part5-Section5.4.2: TID_%0h; FTYPE: %s; TTYPE: %s \
                No Destination support to process this Packet;",
                index[7:0], ftype.name, ttype2.name))
                ll_pass_sts = 0;         
                err_type = DEST_OP_UNSUPPORTED_ERR; 
              end // } 
            end // } 


            DKILL_SHARER: 
            begin // {
              if (dest_read_ownership_support)
              begin // {
                if (src_read_ownership_support == 0)
                begin // {
                  `uvm_error("SRIO_LL_PROTOCOL_CHECKER:SRC_OP_UNSUPPORTED_ERR", 
                  $sformatf("SpecRef:Part5-Section5.4.1: TID_%0h; FTYPE: %s; TTYPE: %s \
                  No Src support to issue this packet",
                  index[7:0], ftype.name, ttype2.name))
                  err_type = SRC_OP_UNSUPPORTED_ERR; 
                end // }
                zero_dpl_chk(); // check for no data payload 
                wdptr_rdsize_chk();  
                reser_fld_chk();  
                resp_pkt_gen();  
              end // }
              else
              begin // {
                LTLED_CSR[9] = 1;
                `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DEST_OP_UNSUPPORTED_ERR", 
                $sformatf("SpecRef:Part5-Section5.4.2: TID_%0h; FTYPE: %s; TTYPE: %s \
                No Destination support to process this Packet;",
                index[7:0], ftype.name, ttype2.name))
                ll_pass_sts = 0;         
                err_type = DEST_OP_UNSUPPORTED_ERR; 
              end // } 
            end // }
 
            NRD:
            begin // {
              if (dest_rd_support)
              begin // {
                if (src_rd_support == 0)
                begin // {
                  `uvm_error("SRIO_LL_PROTOCOL_CHECKER:SRC_OP_UNSUPPORTED_ERR", 
                  $sformatf("SpecRef:Part5-Section5.4.7: TID_%0h; FTYPE: %s; TTYPE: %s \
                  No Src support to issue this packet",
                  index[7:0], ftype.name, ttype2.name))
                  err_type = SRC_OP_UNSUPPORTED_ERR; 
                end // }
                zero_dpl_chk(); // check for no data payload 
                wdptr_rdsize_chk();  
                resp_pkt_gen();  
              end // }
              else
              begin // {
                LTLED_CSR[9] = 1;
                `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DEST_OP_UNSUPPORTED_ERR", 
                $sformatf("SpecRef:Part5-Section5.4.8: TID_%0h; FTYPE: %s; TTYPE: %s \
                No Destination support to process this Packet;",
                index[7:0], ftype.name, ttype2.name))
                ll_pass_sts = 0;         
                err_type = DEST_OP_UNSUPPORTED_ERR; 
              end // } 
            end // } 
     
            // ATO_INC, ATO_DEC, ATO_SET, ATO_CLR
            ATO_INC:
            begin // {
              if (dest_ato_inc_support)
              begin // {
                if (src_ato_inc_support == 0)
                begin // {
                  `uvm_error("SRIO_LL_PROTOCOL_CHECKER:SRC_OP_UNSUPPORTED_ERR", 
                  $sformatf("SpecRef:Part5-Section5.4.7: TID_%0h; FTYPE: %s; TTYPE: %s \
                  No Src support to issue this packet",
                  index[7:0], ftype.name, ttype2.name))
                  err_type = SRC_OP_UNSUPPORTED_ERR; 
                end // }
                zero_dpl_chk(); // check for no data payload 
                wdptr_rdsize_chk();  
                resp_pkt_gen();  
              end // }
              else
              begin // {
                LTLED_CSR[9] = 1;
                `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DEST_OP_UNSUPPORTED_ERR", 
                $sformatf("SpecRef:Part5-Section5.4.8: TID_%0h; FTYPE: %s; TTYPE: %s \
                No Destination support to process this Packet;",
                index[7:0], ftype.name, ttype2.name))
                ll_pass_sts = 0;         
                err_type = DEST_OP_UNSUPPORTED_ERR; 
              end // } 
            end // } 
     
            ATO_DEC:
            begin // {
              if (dest_ato_dec_support)
              begin // {
                if (src_ato_dec_support == 0)
                begin // {
                  `uvm_error("SRIO_LL_PROTOCOL_CHECKER:SRC_OP_UNSUPPORTED_ERR", 
                  $sformatf("SpecRef:Part5-Section5.4.7: TID_%0h; FTYPE: %s; TTYPE: %s \
                  No Src support to issue this packet",
                  index[7:0], ftype.name, ttype2.name))
                  err_type = SRC_OP_UNSUPPORTED_ERR; 
                end // }
                zero_dpl_chk(); // check for no data payload 
                wdptr_rdsize_chk();  
                resp_pkt_gen();  
              end // }
              else
              begin // {
                LTLED_CSR[9] = 1;
                `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DEST_OP_UNSUPPORTED_ERR", 
                $sformatf("SpecRef:Part5-Section5.4.8: TID_%0h; FTYPE: %s; TTYPE: %s \
                No Destination support to process this Packet;",
                index[7:0], ftype.name, ttype2.name))
                ll_pass_sts = 0;         
                err_type = DEST_OP_UNSUPPORTED_ERR; 
              end // } 
            end // } 
     
            ATO_SET:
            begin // {
              if (dest_ato_set_support)
              begin // {
                if (src_ato_set_support == 0)
                begin // {
                  `uvm_error("SRIO_LL_PROTOCOL_CHECKER:SRC_OP_UNSUPPORTED_ERR", 
                  $sformatf("SpecRef:Part5-Section5.4.7: TID_%0h; FTYPE: %s; TTYPE: %s \
                  No Src support to issue this packet",
                  index[7:0], ftype.name, ttype2.name))
                  err_type = SRC_OP_UNSUPPORTED_ERR; 
                end // }
                zero_dpl_chk(); // check for no data payload 
                wdptr_rdsize_chk();  
                resp_pkt_gen();  
              end // }
              else
              begin // {
                LTLED_CSR[9] = 1;
                `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DEST_OP_UNSUPPORTED_ERR", 
                $sformatf("SpecRef:Part5-Section5.4.8: TID_%0h; FTYPE: %s; TTYPE: %s \
                No Destination support to process this Packet;",
                index[7:0], ftype.name, ttype2.name))
                ll_pass_sts = 0;         
                err_type = DEST_OP_UNSUPPORTED_ERR; 
              end // } 
            end // } 
     
            ATO_CLR:
            begin // {
              if (dest_ato_clr_support)
              begin // {
                if (src_ato_clr_support == 0)
                begin // {
                  `uvm_error("SRIO_LL_PROTOCOL_CHECKER:SRC_OP_UNSUPPORTED_ERR", 
                  $sformatf("SpecRef:Part5-Section5.4.7: TID_%0h; FTYPE: %s; TTYPE: %s \
                  No Src support to issue this packet",
                  index[7:0], ftype.name, ttype2.name))
                  err_type = SRC_OP_UNSUPPORTED_ERR; 
                end // }
                zero_dpl_chk(); // check for no data payload 
                wdptr_rdsize_chk();  
                resp_pkt_gen();  
              end // }
              else
              begin // {
                LTLED_CSR[9] = 1;
                `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DEST_OP_UNSUPPORTED_ERR", 
                $sformatf("SpecRef:Part5-Section5.4.8: TID_%0h; FTYPE: %s; TTYPE: %s \
                No Destination support to process this Packet;",
                index[7:0], ftype.name, ttype2.name))
                ll_pass_sts = 0;         
                err_type = DEST_OP_UNSUPPORTED_ERR; 
              end // } 
            end // }
          endcase
        end // } 
    
    // =============================================================================
    // NWR, NWR_R, ATO_SWAP, ATO_COMP_SWAP, ATO_TEST_SWAP
    // =============================================================================
        TYPE5:
        begin // {
          case (ttype5)
            FLUSH_WD: 
            begin // {
              if (dest_data_cache_flush_support)
              begin // {
                if (src_data_cache_flush_support == 0)
                begin // {
                  `uvm_error("SRIO_LL_PROTOCOL_CHECKER:SRC_OP_UNSUPPORTED_ERR", 
                  $sformatf("SpecRef:Part5-Section5.4.1: TID_%0h; FTYPE: %s; TTYPE: %s \
                  No Src support to issue this packet", 
                  index[7:0], ftype.name, ttype5.name))
                  err_type = SRC_OP_UNSUPPORTED_ERR; 
                end // }
                exp_dpl_chk();  
                resp_pkt_gen();  
              end // }  
              else
              begin // {
                LTLED_CSR[9] = 1;
                `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DEST_OP_UNSUPPORTED_ERR", 
                $sformatf("SpecRef:Part5-Section5.4.2: TID_%0h; FTYPE: %s; TTYPE: %s \
                No Destination support to process this Packet;", 
                index[7:0], ftype.name, ttype5.name))
                ll_pass_sts = 0;         
                err_type = DEST_OP_UNSUPPORTED_ERR; 
              end // } 
            end // }  

            CAST_OUT: 
            begin // {
              if (dest_castout_support)
              begin // {
                if (src_castout_support == 0)
                begin // {
                  `uvm_error("SRIO_LL_PROTOCOL_CHECKER:SRC_OP_UNSUPPORTED_ERR", 
                  $sformatf("SpecRef:Part5-Section5.4.1: TID_%0h; FTYPE: %s; TTYPE: %s \
                  No Src support to issue this packet", 
                  index[7:0], ftype.name, ttype5.name))
                  err_type = SRC_OP_UNSUPPORTED_ERR; 
                end // }
                exp_dpl_chk();  
                resp_pkt_gen();  
              end // }  
              else
              begin // {
                LTLED_CSR[9] = 1;
                `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DEST_OP_UNSUPPORTED_ERR", 
                $sformatf("SpecRef:Part5-Section5.4.2: TID_%0h; FTYPE: %s; TTYPE: %s \
                No Destination support to process this Packet;",
                index[7:0], ftype.name, ttype5.name))
                ll_pass_sts = 0;         
                err_type = DEST_OP_UNSUPPORTED_ERR; 
              end // } 
            end // }  

        
            NWR: // NWRITE
            begin // {
              if (dest_write_support)
              begin // {
                if (src_write_support == 0)
                begin // {
                  `uvm_error("SRIO_LL_PROTOCOL_CHECKER:SRC_OP_UNSUPPORTED_ERR", 
                  $sformatf("SpecRef:Part1-Section5.4.7: TID_%0h; FTYPE: %s; TTYPE: %s \
                  No Src support to issue this packet", 
                  index[7:0], ftype.name, ttype5.name))
                  err_type = SRC_OP_UNSUPPORTED_ERR; 
                end // }
                exp_dpl_chk();  
              end // }  
              else
              begin // {
                LTLED_CSR[9] = 1;
                `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DEST_OP_UNSUPPORTED_ERR", 
                $sformatf("SpecRef:Part1-Section5.4.8: TID_%0h; FTYPE: %s; TTYPE: %s \
                No Destination support to process this Packet;",
                index[7:0], ftype.name, ttype5.name))
                ll_pass_sts = 0;         
                err_type = DEST_OP_UNSUPPORTED_ERR; 
              end // } 
            end // }  
    
            NWR_R: // N write_R
            begin // {
              if (dest_nwriter_support)
              begin // {
                if (src_nwriter_support == 0)
                begin // {
                  `uvm_error("SRIO_LL_PROTOCOL_CHECKER:SRC_OP_UNSUPPORTED_ERR", 
                  $sformatf("SpecRef:Part1-Section5.4.7: TID_%0h; FTYPE: %s; TTYPE: %s \
                  No Src support to issue this packet",
                  index[7:0], ftype.name, ttype5.name))
                  err_type = SRC_OP_UNSUPPORTED_ERR; 
                end // }
                exp_dpl_chk();  
                resp_pkt_gen();  
              end // }
              else
              begin // {
                LTLED_CSR[9] = 1;
                `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DEST_OP_UNSUPPORTED_ERR", 
                $sformatf("SpecRef:Part1-Section5.4.8: TID_%0h; FTYPE: %s; TTYPE: %s \
                No Destination support to process this Packet;",
                index[7:0], ftype.name, ttype5.name))
                ll_pass_sts = 0;         
                err_type = DEST_OP_UNSUPPORTED_ERR; 
              end // } 
            end // }  
    
            ATO_SWAP: // ATOMIC SWAP
            begin // {
              if (dest_ato_swap_support)
              begin // {
                if (src_ato_swap_support == 0)
                begin // {
                  `uvm_error("SRIO_LL_PROTOCOL_CHECKER:SRC_OP_UNSUPPORTED_ERR", 
                  $sformatf("SpecRef:Part1-Section5.4.7: TID_%0h; FTYPE: %s; TTYPE: %s \
                  No Src support to issue this packet",
                  index[7:0], ftype.name, ttype5.name))
                  err_type = SRC_OP_UNSUPPORTED_ERR; 
                end // }
                // Ftype5 Atomic packets will return the same size of data in the response
                // i.e. DPL = 8  Bytes for the response of Swap and test and swap
                //      DPL = 16 Bytes for the response of Compare and Swap                    
                exp_dpl_chk();  
                resp_pkt_gen();  
              end // }
              else
              begin // {
                LTLED_CSR[9] = 1;
                `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DEST_OP_UNSUPPORTED_ERR", 
                $sformatf("SpecRef:Part1-Section5.4.8: TID_%0h; FTYPE: %s; TTYPE: %s \
                No Destination support to process this Packet;", 
                index[7:0], ftype.name, ttype5.name))
                ll_pass_sts = 0;         
                err_type = DEST_OP_UNSUPPORTED_ERR; 
              end // } 
            end // }  
    
            ATO_COMP_SWAP: // ATOMIC COMPARE AND SWAP
            begin // {
              if (dest_ato_comp_swap_support)
              begin // {
                if (src_ato_comp_swap_support == 0)
                begin // {
                  `uvm_error("SRIO_LL_PROTOCOL_CHECKER:SRC_OP_UNSUPPORTED_ERR", 
                  $sformatf("SpecRef:Part1-Section5.4.7: TID_%0h; FTYPE: %s; TTYPE: %s \
                  No Src support to issue this packet", 
                  index[7:0], ftype.name, ttype5.name))
                  err_type = SRC_OP_UNSUPPORTED_ERR; 
                end // }
                exp_dpl_chk();  
                resp_pkt_gen();  
              end // }
              else
              begin // {
                LTLED_CSR[9] = 1;
                `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DEST_OP_UNSUPPORTED_ERR", 
                $sformatf("SpecRef:Part1-Section5.4.8: TID_%0h; FTYPE: %s; TTYPE: %s \
                No Destination support to process this Packet;",
                index[7:0], ftype.name, ttype5.name))
                ll_pass_sts = 0;         
                err_type = DEST_OP_UNSUPPORTED_ERR; 
              end // } 
            end // }  
    
            ATO_TEST_SWAP: // ATOMIC TEST AND SWAP
            begin // {
              if (dest_ato_test_swap_support)
              begin // {
                if (src_ato_test_swap_support == 0)
                begin // {
                  `uvm_error("SRIO_LL_PROTOCOL_CHECKER:SRC_OP_UNSUPPORTED_ERR", 
                  $sformatf("SpecRef:Part1-Section5.4.7: TID_%0h; FTYPE: %s; TTYPE: %s \
                  No Src support to issue this packet",
                  index[7:0], ftype.name, ttype5.name))
                  err_type = SRC_OP_UNSUPPORTED_ERR; 
                end // }
                exp_dpl_chk();  
                resp_pkt_gen();  
              end // }
              else
              begin // {
                LTLED_CSR[9] = 1;
                `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DEST_OP_UNSUPPORTED_ERR", 
                $sformatf("SpecRef:Part1-Section5.4.8: TID_%0h; FTYPE: %s; TTYPE: %s \
                No Destination support to process this Packet;",
                index[7:0], ftype.name, ttype5.name))
                ll_pass_sts = 0;         
                err_type = DEST_OP_UNSUPPORTED_ERR; 
              end // } 
            end // }  
          endcase   
        end // } 
    // =============================================================================
        // SWRITE
        TYPE6:
        begin // {
          if (dest_swrite_support)
          begin // {
            if (src_swrite_support == 0)
            begin // {
              `uvm_error("SRIO_LL_PROTOCOL_CHECKER:SRC_OP_UNSUPPORTED_ERR", 
              $sformatf("SpecRef:Part1-Section5.4.7: TID_%0h; FTYPE: %s; \
              No Src support to issue this packet", 
              index[7:0], ftype.name))
              err_type = SRC_OP_UNSUPPORTED_ERR; 
            end // }
            exp_dpl_chk();  
          end // } 
          else
          begin // {
            `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DEST_OP_UNSUPPORTED_ERR", 
            $sformatf("SpecRef:Part1-Section5.4.8: TID_%0h; FTYPE: %s; \
            No Destination support to process this Packet;", 
            index[7:0], ftype.name))
            ll_pass_sts = 0;         
            LTLED_CSR[9] = 1; // Unsupported Transaction
            err_type = DEST_OP_UNSUPPORTED_ERR; 
          end // } 
        end // } 
    // =============================================================================
        // LFC
        TYPE7:
        begin // {
          if (fc_support)
          begin // {
            zero_dpl_chk(); // check for no data payload                     
            lfc_checks();
          end // }
          else
          begin // {
            `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DEST_OP_UNSUPPORTED_ERR", 
            $sformatf("SpecRef:Part9-Section4.2.1: TID_%0h; FTYPE: %s; \
            No Destination support to process this Packet;", 
            index[7:0], ftype.name))
            ll_pass_sts = 0;         
            LTLED_CSR[9] = 1; // Unsupported Transaction
            err_type = DEST_OP_UNSUPPORTED_ERR; 
          end // } 
        end // } 
    
    // MAINT_RD_REQ, MAINT_WR_REQ, MAINT_RD_RES, MAINT_WR_RES, MAINT_PORT_WR_REQ
    // =============================================================================
        TYPE8:
        begin // {
          case (ttype8)
            MAINT_RD_REQ:
            begin // {
              zero_dpl_chk(); // check for no data payload 
              wdptr_rdsize_chk();
              resp_pkt_gen();  
            end // }
            MAINT_WR_REQ:
            begin // {
              exp_dpl_chk();  
              resp_pkt_gen();  
            end // }
            MAINT_RD_RES:
            begin // {
              resp_pkt_chk();
            end // }
            MAINT_WR_RES:
            begin // {
              resp_pkt_chk();
            end // }
            MAINT_PORT_WR_REQ:
            begin // {
              reser_fld_chk();  
              exp_dpl_chk();  
            end // }
          endcase   
        end // } 
    
    // DATA STREAMING
    // =============================================================================
        TYPE9:
        begin // {
          if (dest_ds_support)
          begin // { 
            if (src_ds_support == 0)
            begin // {
              `uvm_error("SRIO_LL_PROTOCOL_CHECKER:SRC_OP_UNSUPPORTED_ERR", 
              $sformatf("SpecRef:Part10-Section5.5.1: TID_%0h; FTYPE: %s; \
              No Src support to issue this packet", 
              index[7:0], ftype.name))
              err_type = SRC_OP_UNSUPPORTED_ERR; 
            end // }
            if (pkt.xh)
            begin // {
              if (dest_ds_tm_support)
              begin // { 
                if (src_ds_tm_support == 0)
                begin // {
                  `uvm_error("SRIO_LL_PROTOCOL_CHECKER:SRC_OP_UNSUPPORTED_ERR", 
                  $sformatf("SpecRef:Part10-Section5.5.1: TID_%0h; FTYPE: %s; \
                  No Src support to issue this packet",
                  index[7:0], ftype.name))
                  err_type = SRC_OP_UNSUPPORTED_ERR; 
                end // }
                ds_tm_chk();
              end // }
              else
              begin // {
                `uvm_warning("SRIO_LL_PROTOCOL_CHECKER:DEST_OP_UNSUPPORTED_ERR", 
                $sformatf("SpecRef:Part10-Section5.5.2: TID_%0h; FTYPE: %s; \
                No Destination support to process this Packet;", 
                index[7:0], ftype.name))
                ll_pass_sts = 0;         
                LTLED_CSR[9] = 1; // Unsupported Transaction
                err_type = DEST_OP_UNSUPPORTED_ERR; 
              end // } 
            end // }
            else
            begin // {
              ds_xoff_index1 = {pkt.DestinationID, pkt.cos, pkt.streamID};
              if ((ds_tm_xoff_array.exists(ds_xoff_index1) == 0) && tm_xoff_wc != 3'b111)
              begin // {
                ds_assembly_chk();
              end // }
              else
              begin // {
                `uvm_error("SRIO_LL_PROTOCOL_CHECKER:TM_BLOCKED_DS_ERR", 
                $sformatf("SpecRef:Part1-Section5.4.7: TID_%0h %s Blocked DS; \
                DestinationID:%0h h, cos: %0h, streamID: %0h", 
                index[7:0], ftype.name, pkt.DestinationID, pkt.cos, pkt.streamID))
              end // }
            end // }
          end // }
          else
          begin // {
            `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DEST_OP_UNSUPPORTED_ERR", 
            $sformatf("SpecRef:Part10-Section5.5.2: TID_%0h; FTYPE: %s; \
            No Destination support to process this Packet;", 
            index[7:0], ftype.name))
            ll_pass_sts = 0;         
            LTLED_CSR[9] = 1; // Unsupported Transaction
            err_type = DEST_OP_UNSUPPORTED_ERR; 
          end // } 
        end // } 
    
    // DOOR BELL
    // =============================================================================
        TYPE10: 
        begin // {
          if (dest_db_support)
          begin // { 
            if (src_db_support == 0)
            begin // {
              `uvm_error("SRIO_LL_PROTOCOL_CHECKER:SRC_OP_UNSUPPORTED_ERR", 
              $sformatf("SpecRef:Part2-Section5.4.1: TID_%0h; FTYPE: %s; \
              No Src support to issue this packet",
              index[7:0], ftype.name))
              err_type = SRC_OP_UNSUPPORTED_ERR; 
            end // }
            zero_dpl_chk(); 
            resp_pkt_gen();  
          end // }
          else
          begin // {
            `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DEST_OP_UNSUPPORTED_ERR", 
            $sformatf("SpecRef:Part2-Section5.4.2: TID_%0h; FTYPE: %s; \
            No Destination support to process this Packet;",
            index[7:0], ftype.name))
            ll_pass_sts = 0;         
            LTLED_CSR[9] = 1; // Unsupported Transaction
            err_type = DEST_OP_UNSUPPORTED_ERR; 
          end // } 
        end // } 
    
    // MESSAGE
    // =============================================================================
        TYPE11: 
        begin // {
          if (dest_msg_support)
          begin // { 
            if (src_msg_support == 0)
            begin // {
              `uvm_error("SRIO_LL_PROTOCOL_CHECKER:SRC_OP_UNSUPPORTED_ERR", 
              $sformatf("SpecRef:Part2-Section5.4.1: TID_%0h; FTYPE: %s; \
              No Src support to issue this packet",
              index[7:0], ftype.name))
              err_type = SRC_OP_UNSUPPORTED_ERR; 
            end // }
            exp_dpl_chk();  
            msg_assembly_chk();
            resp_pkt_gen();  
          end // }
          else
          begin // {
            `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DEST_OP_UNSUPPORTED_ERR", 
            $sformatf("SpecRef:Part2-Section5.4.2: TID_%0h; FTYPE: %s; \
            No Destination support to process this Packet;",
            index[7:0], ftype.name))
            ll_pass_sts = 0;         
            LTLED_CSR[9] = 1; // Unsupported Transaction
            err_type = DEST_OP_UNSUPPORTED_ERR; 
          end // } 
        end // } 
    
    // RESPONSE: RES_WO_DP, MSG_RES, RES_WITH_DP
    // =============================================================================
        TYPE13: 
        begin // {
          //  RES_WO_DP, MSG_RES, RES_WITH_DP:
          if (pkt_validity)
          begin // {
            resp_pkt_chk();
          end // }
        end // } 
      endcase
    end // }
  end // }
  else
  begin // {
    if (pkt.tl_pkt_valid)
    begin // {
      pkt.print();
   
      `uvm_info("SRIO_LL_PROTOCOL_CHECKER", $sformatf("\n \
      LL_%s_MON_CHK ........................: Unrecognized_Packet \n \
      Source ID ........................... : %0h; \n \
      tgtdestID(Valid only for LFC Pkt) ... : %0h; \n \
      Destination ID .......................: %0h;", 
      ((mon_type == 1) ? "TX" : "RX"), pkt.SourceID, pkt.tgtdestID, pkt.DestinationID), UVM_LOW);

      if ((pkt.ftype == 6) || (pkt.ftype == 7) || (pkt.ftype == 9) || 
          (pkt.ftype == 10) || (pkt.ftype == 11))
        ind_pkt_count = ftype_count[{pkt.ftype,4'b0}];
      else
        ind_pkt_count = ftype_count[{pkt.ftype,pkt.ttype}];

      `uvm_info("PACKET_DETAIL", $sformatf("\n\
              PACKET_COUNT_UPDATE \n\
         Current_Packet_Count    : %0d    \n\
         Total_Packet_Count      : %0d    \n\
      ---------------------------------------", 
      ind_pkt_count, pkt_count), UVM_LOW)

      if (valid_ftype)
      begin // { 
        `uvm_error("SRIO_LL_PROTOCOL_CHECKER:TTYPE_ERR", 
        $sformatf("SpecRef:Part1-Section4.1: Part2-Section4.3.1,Part5-Section4.2: \
        TID_%0h Received a packet with Valid ftype: %0h h & Invalid ttype: %0h h", 
        index[7:0], pkt.ftype, pkt.ttype))

        LTLED_CSR[9] = 1;
        err_type = TTYPE_ERR; 
      end // }
      else
      begin // { 
        LTLED_CSR[9] = 1; // Unsupported Transaction
        err_type = FTYPE_ERR; 

        if ((ftype == 3)  || (ftype == 4)  ||  (ftype == 12) || (ftype == 14))
        begin // {
          `uvm_error("SRIO_LL_PROTOCOL_CHECKER:FTYPE_ERR", 
          $sformatf("SpecRef:Part1-Section4.1: TID_%0h Reserved ftype; FTYPE: %s; ttype: %0hh ", 
          index[7:0], ftype.name, pkt.ttype))
        end // } 
        else 
        begin // {
          `uvm_error("SRIO_LL_PROTOCOL_CHECKER:FTYPE_ERR", 
          $sformatf("SpecRef:Part1-Section4.1: TID_%0h; Implementation defined ftype; \
          Functionality not implemented; FTYPE: %s; ttype: %0hh ", 
          index[7:0], ftype.name, pkt.ttype))
        end // } 
      end // }
    end // }
  end // }
 
  ll_out_pkt.ll_err_encountered = ll_pass_sts;
  ll_out_pkt.ll_err_detected    = err_type; 
   
endfunction: srio_ll_pkt_protocol_chk

////////////////////////////////////////////////////////////////////////////////
/// Name: wdptr_rdsize_chk \n 
/// Description: Funtion to check wdptr and rdsize protocol \n
/// wdptr_rdsize_chk
////////////////////////////////////////////////////////////////////////////////

function void srio_ll_txrx_monitor::wdptr_rdsize_chk();
  bit [4:0] wdptr_rdsize;
  wdptr_rdsize = {pkt.wdptr, pkt.rdsize};

  if (shared_class.wdptr_rdsize_array.exists(wdptr_rdsize))
  begin // {
    dpl_size = shared_class.wdptr_rdsize_array[wdptr_rdsize];
    if (ato_pkt)
    begin // {
      if ((dpl_size !== 1) &&
          (dpl_size !== 2) &&
          (dpl_size !== 4)) 
      begin // {
        `uvm_error("SRIO_LL_PROTOCOL_CHECKER:SIZE_ERR", 
        $sformatf("SpecRef:Part1-Section4.1.2: TID_%0h; \
        Atomic Pkt with Reserved wdptr_rd_size. Act wd_ptr: %0h h, rd_size: %0h h", 
        index[7:0], pkt.wdptr, pkt.rdsize)); 
        LTLED_CSR[4] = 1;
        ll_pass_sts = 0;         
        err_type = SIZE_ERR;
      end // }
    end // }
    if (maint_pkt)
    begin // {
      if ((dpl_size < 8  && dpl_size !== 4) ||
          (dpl_size > 8  && dpl_size % 8 !== 0)) 
      begin // {
        ll_pass_sts = 0;         
        LTLED_CSR[4] = 1;
        err_type = SIZE_ERR;
        if (dpl_size > 64) 
        begin // { 
          `uvm_error("SRIO_LL_PROTOCOL_CHECKER:SIZE_ERR", 
          $sformatf("SpecRef:Part1-Section4.1.10: TID_%0h; \
          Maintenance read for size greater than 64 bytes; dpl_size:%0h h", 
          index[7:0], dpl_size)); 
        end // }
        else 
        begin // { 
          `uvm_error("SRIO_LL_PROTOCOL_CHECKER:SIZE_ERR", 
          $sformatf("SpecRef:Part1-Section4.1.10: TID_%0h; \
          Maintenance read for the size other than word/DW/multiple DW; dpl_size:%0h h", 
          index[7:0], dpl_size)); 
        end // }
      end // }
    end // }

    if (gsm_pkt)
    begin // {
      if (dpl_size > 64) 
      begin // { 
        `uvm_error("SRIO_LL_PROTOCOL_CHECKER:SIZE_ERR", 
        $sformatf("SpecRef:Part5-Section4.2.3: TID_%0h; \
        GSM Type%0h h with invalid DPL wdptr: %0h h; rdsize: %0h h", 
        index[7:0], pkt.ftype, pkt.wdptr, pkt.rdsize)) 
        ll_pass_sts = 0;         
        LTLED_CSR[4] = 1;
        err_type = SIZE_ERR;
      end // }
    end //}
  end // }
  else        
  begin // {
    `uvm_error("SRIO_LL_PROTOCOL_CHECKER:SIZE_ERR", 
    $sformatf("SpecRef:Part1-Section4.1.2(For IO), Part5-Section4.2.3(For GSM):\
    TID_%0h; Type%0h h Reserved combination of wdptr: %0h h; rdsize: %0h h", 
    index[7:0], pkt.ftype, pkt.wdptr, pkt.rdsize)) 
    LTLED_CSR[4] = 1;
    dpl_size = 0;
    ll_pass_sts = 0;         
    err_type = SIZE_ERR;
  end // }
endfunction : wdptr_rdsize_chk

////////////////////////////////////////////////////////////////////////////////
/// Name: exp_dpl_chk \n 
/// Description: Function to check the Data payload \n
/// exp_dpl_chk
////////////////////////////////////////////////////////////////////////////////

function void srio_ll_txrx_monitor::exp_dpl_chk();
  srio_ftype  ftype;
  type5_ttype ttype5;
  int         act_dpl_size;
  int         pkt_dpl_size; 
  bit [4:0]   wdptr_wrsize;
  bit [9:0]   min_size; 
  bit [9:0]   max_size;

  act_dpl_size = pkt.payload.size();
  ftype        = srio_ftype'(pkt.ftype);
  ttype5       = type5_ttype'(pkt.ttype);

  // Minimum value that could be read/written is 8 bytes
  wdptr_wrsize = {pkt.wdptr, pkt.wrsize};
  pkt_dpl_size = shared_class.wdptr_wrsize_array[wdptr_wrsize];
  dpl_size = shared_class.wdptr_wrsize_array[wdptr_wrsize];
  if (dpl_size < 8)
  begin // {
    dpl_size = 8;
  end // }

  case (ftype)
    TYPE5:
    begin // {
      if (shared_class.wdptr_wrsize_array.exists(wdptr_wrsize))
      begin // {

        max_size = 256; 
        if (act_dpl_size > max_size) 
        begin // {  
          `uvm_error("SRIO_LL_PROTOCOL_CHECKER:MAX_SIZE_ERR", 
          $sformatf("SpecRef:Part1-Section4.1.2: TID_%0h; \
          TYPE5 Packet with DPL > max size(256 bytes) dpl_size: %0h h", 
          index[7:0], act_dpl_size))
          ll_pass_sts = 0;         
          LTLED_CSR[4] = 1;
          err_type = MAX_SIZE_ERR;
        end // } 

        if (act_dpl_size > 0) 
        begin // {
          case (ttype5)
            ATO_SWAP: // Atomic swap 
            begin // {
              if ((pkt_dpl_size != 1) && (pkt_dpl_size != 2) && (pkt_dpl_size != 4))
              begin // {
                `uvm_error("SRIO_LL_PROTOCOL_CHECKER:AS_PAYLOAD_ERR", 
                $sformatf("SpecRef:Part1-Section4.1.7: TID_%0h; \
                ATOMIC SWAP with Number of bytes selected != 1/2/4 Bytes; wdptr_wrsize %0h h",
                index[7:0], wdptr_wrsize));
                ll_pass_sts = 0;                  
                LTLED_CSR[4] = 1;
                err_type = AS_PAYLOAD_ERR;
              end // }

              if (act_dpl_size != 8)  
              begin // {
                `uvm_error("SRIO_LL_PROTOCOL_CHECKER:AS_PAYLOAD_ERR", 
                $sformatf("SpecRef:Part1-Section4.1.7: TID_%0h; \
                ATOMIC SWAP with data payload != 1DW; dpl_size:%0h h",
                index[7:0], act_dpl_size));
                ll_pass_sts = 0;         
                LTLED_CSR[4] = 1;
                err_type = AS_PAYLOAD_ERR;
              end // }
            end // }
            ATO_COMP_SWAP: // Atomic compare and swap 
            begin // {
              if (act_dpl_size != 16) 
              begin // {
                `uvm_error("SRIO_LL_PROTOCOL_CHECKER:ACAS_PAYLOAD_ERR", 
                $sformatf("SpecRef:Part1-Section4.1.7: TID_%0h; \
                ATOMIC COMPARE AND SWAP with DPL != 16B; dpl_size: %0h h",
                index[7:0], act_dpl_size))
                ll_pass_sts = 0;         
                LTLED_CSR[4] = 1;
                err_type = ACAS_PAYLOAD_ERR;
              end // }
            end // }
            ATO_TEST_SWAP: // Atomic test and swap 
            begin // {
              if ((pkt_dpl_size != 1) && (pkt_dpl_size != 2) && (pkt_dpl_size != 4))
              begin // {
                `uvm_error("SRIO_LL_PROTOCOL_CHECKER:ATAS_PAYLOAD_ERR", 
                $sformatf("SpecRef:Part1-Section4.1.7: TID_%0h; \
                ATO_TEST_SWAP with Number of bytes selected != 1/2/4 Bytes; wdptr_wrsize %0h h",
                index[7:0], wdptr_wrsize));
                ll_pass_sts = 0;                  
                LTLED_CSR[4] = 1;
                err_type = ATAS_PAYLOAD_ERR;
              end // }

              if (act_dpl_size != 8) 
              begin // {
                `uvm_error("SRIO_LL_PROTOCOL_CHECKER:ATAS_PAYLOAD_ERR", 
                $sformatf("SpecRef:Part1-Section4.1.7: TID_%0h; \
                ATOMIC TEST-AND-SWAP with DPL != 1DW; dpl_size: %0h h",
                index[7:0], act_dpl_size))
                ll_pass_sts = 0;         
                LTLED_CSR[4] = 1;
                err_type = ATAS_PAYLOAD_ERR;
              end // }
            end // }
            default:
            begin // {
              if (act_dpl_size < 8) 
              begin // {  
                ll_pass_sts = 0;         
                LTLED_CSR[4] = 1;
                `uvm_error("SRIO_LL_PROTOCOL_CHECKER:PAYLOAD_ERR", 
                $sformatf("SpecRef:Part1-Section4.2: TID_%0h; DPL < 1DW; \
                Min. size of DPL is 1DW; DPL Act:%0h h",index[7:0], act_dpl_size))
                err_type = PAYLOAD_ERR;
              end // }
              else if (act_dpl_size > dpl_size)
              begin // {  
                ll_pass_sts = 0;         
                LTLED_CSR[4] = 1;
                `uvm_error("SRIO_LL_PROTOCOL_CHECKER:PAYLOAD_ERR", 
                $sformatf("SpecRef:Part1-Section4.2: TID_%0h; DPL > wrsize. \
                DPL Exp: %0h h; Act: %0h h", index[7:0], dpl_size, act_dpl_size))
                err_type = PAYLOAD_ERR;
              end // }
            end // }
          endcase 
        end // }
        else
        begin // {
          ll_pass_sts = 0;         
          LTLED_CSR[4] = 1;
          `uvm_error("SRIO_LL_PROTOCOL_CHECKER:NO_PAYLOAD_ERR", 
          $sformatf("SpecRef:Part1-Section4.1.7: TID_%0h; TYPE5 Packet with null DPL", 
          index[7:0]))
          err_type = NO_PAYLOAD_ERR;
        end // }
      end // } 
      else
      begin // {
        `uvm_error("SRIO_LL_PROTOCOL_CHECKER:SIZE_ERR", 
        $sformatf("SpecRef:Part1-Section4.1.2: TID_%0h; \
        %s Reserved combination of wdptr-wrsize; wd_ptr: %0h h, wrsize: %0h h",
        index[7:0], ftype.name, pkt.wdptr, pkt.wrsize))
        LTLED_CSR[4] = 1;
        ll_pass_sts = 0;         
        err_type = SIZE_ERR;
      end // }
    end // }

    TYPE6:
    begin // {
      min_size = 8; // Minimum size is 1DW / 8 bytes
      max_size = 256; 
      if (act_dpl_size > max_size) 
      begin // {  
        `uvm_error("SRIO_LL_PROTOCOL_CHECKER:MAX_SIZE_ERR", 
        $sformatf("SpecRef:Part1-Section4.1.2: TID_%0h; \
        TYPE6 Packet with DPL > max size(256 bytes). dpl_size: %0h h", 
        index[7:0], act_dpl_size))
        ll_pass_sts = 0;         
        LTLED_CSR[4] = 1;
        err_type = MAX_SIZE_ERR;
      end // } 
      else if ((act_dpl_size > min_size) && ((act_dpl_size % 8) != 0)) 
      begin // {
        `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DW_ALIGN_ERR", 
        $sformatf("SpecRef:Part1-Section4.1.8: TID_%0h; \
        TYPE6 DPL size is not multiple of DW; dpl_size: %0h h", 
        index[7:0], act_dpl_size))
        err_type = DW_ALIGN_ERR;
      end // }
      else if ((act_dpl_size > 0) && (act_dpl_size < min_size)) 
      begin // {
        `uvm_error("SRIO_LL_PROTOCOL_CHECKER:PAYLOAD_ERR", 
        $sformatf("SpecRef:Part1-Section4.1.8: TID_%0h; \
        TYPE6 Packet with DPL < min size; dpl_size: %0h h", 
        index[7:0], act_dpl_size))
        ll_pass_sts = 0;         
        LTLED_CSR[4] = 1;
        err_type = PAYLOAD_ERR;
      end // }
      else if (act_dpl_size == 0) 
      begin // {
        `uvm_error("SRIO_LL_PROTOCOL_CHECKER:NO_PAYLOAD_ERR", 
        $sformatf("SpecRef:Part1-Section4.1.8: TID_%0h; TYPE6 Packet with null DPL", 
        index[7:0]))
        ll_pass_sts = 0;         
        LTLED_CSR[4] = 1;
        err_type = NO_PAYLOAD_ERR;
      end // }
    end // }
  
    TYPE8:
    begin // { 
      if (shared_class.wdptr_wrsize_array.exists(wdptr_wrsize))
      begin // {
        if (act_dpl_size > 0) 
        begin // {
          if ((act_dpl_size > 8) && (act_dpl_size > dpl_size))
          begin // {  
            ll_pass_sts = 0;         
            LTLED_CSR[4] = 1;
            `uvm_error("SRIO_LL_PROTOCOL_CHECKER:PAYLOAD_ERR", 
            $sformatf("SpecRef:Part1-Section4.1.10: TID_%0h; \
            TYPE8 DPL > wrsize. DPL Exp: %0h h; Act: %0h h",
            index[7:0], dpl_size, act_dpl_size))
            err_type = PAYLOAD_ERR;
          end // }

          if ((act_dpl_size < 8 && act_dpl_size !== 4) ||
              (act_dpl_size > 8 && act_dpl_size % 8 !== 0)) 
          begin // {
            `uvm_error("SRIO_LL_PROTOCOL_CHECKER:PAYLOAD_ERR", 
            $sformatf("SpecRef:Part1-Section4.1.10: TID_%0h; \
            Maintenance wr for the size != (word/DW/multiple DW; dpl_size: %0h h", 
            index[7:0], act_dpl_size)) 
            LTLED_CSR[4] = 1;
            ll_pass_sts = 0;         
            err_type = PAYLOAD_ERR;
          end // }

          if (act_dpl_size > 64) 
          begin // { 
            `uvm_error("SRIO_LL_PROTOCOL_CHECKER:PAYLOAD_ERR", 
            $sformatf("SpecRef:Part1-Section4.1.10: TID_%0h; \
            Maintenance wr for size > 64B; dpl_size: %0h h", 
            index[7:0], act_dpl_size)) 
            ll_pass_sts = 0;         
            LTLED_CSR[4] = 1;
            err_type = PAYLOAD_ERR;
          end // }
        end // }
        else 
        begin // {
          ll_pass_sts = 0;         
          LTLED_CSR[4] = 1;
          `uvm_error("SRIO_LL_PROTOCOL_CHECKER:NO_PAYLOAD_ERR", 
          $sformatf("SpecRef:Part1-Section4.1.10: TID_%0h; \
          MAINT_WR_RES Packet with null DPL", index[7:0]))
          err_type = NO_PAYLOAD_ERR;
        end // }

      end // }
      else
      begin // {
        `uvm_error("SRIO_LL_PROTOCOL_CHECKER:SIZE_ERR", 
        $sformatf("SpecRef:Part1-Section4.1.2: TID_%0h; \
        Maintenance wr with Reserved combination of wdptr-wrsize; \
        wd_ptr: %0h h, wr_size: %0h h",
        index[7:0], pkt.wdptr, pkt.wrsize))
        LTLED_CSR[4] = 1;
        ll_pass_sts = 0;         
        err_type = SIZE_ERR;
      end // }
    end // } 
   
    TYPE11: // Message
    begin // {
      if (shared_class.msg_ssize_array.exists(pkt.ssize))
      begin // {
        dpl_size = shared_class.msg_ssize_array[pkt.ssize];
      end // }
      else
      begin // {
        `uvm_error("SRIO_LL_PROTOCOL_CHECKER:MSG_SSIZE_ERR", 
        $sformatf("SpecRef:Part2-Section4.2.5: TID_%0h; \
        TYPE11: Reserved ssize value; ssize: %0h h", index[7:0], pkt.ssize))
        ll_pass_sts = 0;         
        LTLED_CSR[4] = 1;
        err_type = MSG_SSIZE_ERR;
      end // } 
      if (pkt.payload.size() == 0) 
      begin // {
        ll_pass_sts = 0;         
        `uvm_error("SRIO_LL_PROTOCOL_CHECKER:NO_PAYLOAD_ERR", 
        $sformatf("SpecRef:Part2-Section4.2.5: TID_%0h; \
        Message Packet with null DPL", index[7:0]))
        LTLED_CSR[4] = 1;
        err_type = NO_PAYLOAD_ERR;
      end // }
    end // } 
  endcase      

endfunction : exp_dpl_chk

////////////////////////////////////////////////////////////////////////////////
/// Name: msg_assembly_chk \n 
/// Description: Function to check Message Packet Protocol \n
/// msg_assembly_chk
////////////////////////////////////////////////////////////////////////////////

function void srio_ll_txrx_monitor::msg_assembly_chk();

  bit [ 8:0] last_req[bit[72:0]]; 
  bit [72:0] index_mac;  
  bit [72:0] sseg_index;
  bit [72:0] mseg_index;
  bit [ 5:0] sseg_mbox;
  bit        mseg_valid;
  bit        sseg_valid;
  int        completed_seg;
   bit [72:0] copy_index;

  srio_ll_msg_assembly  msg_array_mac[bit[72:0]];
  srio_trans exp_resp_array_mac[bit[72:0]];
  exp_resp_array_mac.delete;
  msg_array_mac.delete;

  if (pkt.msg_len > 0) 
  begin // {
    sseg = 0; mseg = 1;
    index_mac  = {pkt.SourceID, pkt.DestinationID, 1'b1, pkt.letter, pkt.mbox, 4'h0};
    sseg_index = {pkt.SourceID, pkt.DestinationID, 1'b1, pkt.letter, pkt.mbox, pkt.msgseg_xmbox}; 
    mseg_index = {pkt.SourceID, pkt.DestinationID, 1'b1, pkt.letter, pkt.mbox, 4'h0};
  end //}
  else
  begin // {
    sseg = 1; mseg = 0;
    index_mac  = {pkt.SourceID, pkt.DestinationID, 1'b1, pkt.letter, pkt.mbox, pkt.msgseg_xmbox}; 
    sseg_index = {pkt.SourceID, pkt.DestinationID, 1'b1, pkt.letter, pkt.mbox, pkt.msgseg_xmbox}; 
    mseg_index = {pkt.SourceID, pkt.DestinationID, 1'b1, pkt.letter, pkt.mbox, 4'h0};
  end //}

  msg_assembly = new;

  if (mon_type) 
  begin 
   `ifdef VCS_ASS_ARR_FIX
     foreach(`TX_EXP_RESP_ARRAY[copy_index]) exp_resp_array_mac[copy_index] = `TX_EXP_RESP_ARRAY[copy_index];
     foreach(`TX_LAST_REQ[copy_index]) last_req[copy_index]           = `TX_LAST_REQ[copy_index]; 
     foreach(`TX_MSG_ARRAY[copy_index]) msg_array_mac[copy_index]      = `TX_MSG_ARRAY[copy_index]; 
   `else
     exp_resp_array_mac = `TX_EXP_RESP_ARRAY; 
     last_req           = `TX_LAST_REQ; 
     msg_array_mac      = `TX_MSG_ARRAY; 
   `endif
  end 
  else 
  begin 
   `ifdef VCS_ASS_ARR_FIX
     foreach(`RX_EXP_RESP_ARRAY[copy_index]) exp_resp_array_mac[copy_index] = `RX_EXP_RESP_ARRAY[copy_index];
     foreach(`RX_LAST_REQ[copy_index]) last_req[copy_index]           = `RX_LAST_REQ[copy_index]; 
     foreach(`RX_MSG_ARRAY[copy_index]) msg_array_mac[copy_index]      = `RX_MSG_ARRAY[copy_index]; 
   `else
     exp_resp_array_mac = `RX_EXP_RESP_ARRAY; 
     last_req           = `RX_LAST_REQ; 
     msg_array_mac      = `RX_MSG_ARRAY; 
   `endif
  end 

  if(sseg) 
  begin // {
    mseg_valid = 0;   
    sseg_valid = 1;
    if ((msg_array_mac.exists(mseg_index)) && (msg_array_mac[mseg_index].msg_type == 1))            
      sseg_valid = 0;
    else
      sseg_valid = 1;
  end // }
  else
  begin // {
    sseg_valid = 0;
    mseg_valid = 1;   
    for (bit[4:0] m_box=0; m_box<16; m_box=m_box+1)
    begin // {
      sseg_index = {pkt.SourceID, pkt.DestinationID, 1'b1, pkt.letter, pkt.mbox, m_box[3:0]}; 
      if ((msg_array_mac.exists(sseg_index)) && (msg_array_mac[sseg_index].msg_type == 0))            
      begin // {
        mseg_valid = 0;   
        break;
      end //}
    end //}
  end // }
     
  if (sseg_valid || mseg_valid) 
  begin // {
    if (((msg_array_mac.exists(index_mac))    &&
         (msg_array_mac[index_mac].err_sts == 0)) ||
        ((msg_array_mac.exists(index_mac)) == 0))
    begin // {
      if (pkt.payload.size() >= 8) // Minimum payload size is 8
      begin // {
        if ((pkt.payload.size() % 8) != 0)
        begin // {  
          `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DW_ALIGN_ERR", 
          $sformatf("Part2-Section4.2.5: TID_%0h;Msg without DW boundary alignment; \
          Payload size: %0h h", index[7:0], pkt.payload.size()))
          ll_pass_sts = 0;         
          LTLED_CSR[3] = 1;         
          err_type = DW_ALIGN_ERR;
        end // } 
        if (mseg &&
          ((pkt.msgseg_xmbox  < pkt.msg_len) && 
           (pkt.payload.size() < dpl_size))) 
        begin // {
          `uvm_error("SRIO_LL_PROTOCOL_CHECKER:PAYLOAD_ERR", 
          $sformatf("Part2-Section4.2.5: TID_%0h; Msgseg:%0h h (Msg_len: %0h h) \
          DPL lesser than ssize in a non-end segment; dpl_size: Act %0h h; Exp:%0h h", 
          index[7:0], pkt.msgseg_xmbox, pkt.msg_len, pkt.payload.size(), dpl_size))
          ll_pass_sts = 0;         
          LTLED_CSR[3] = 1;         
          err_type = PAYLOAD_ERR;
        end // } 
        if(pkt.payload.size() > dpl_size)
        begin // {
          `uvm_error("SRIO_LL_PROTOCOL_CHECKER:PAYLOAD_ERR", 
          $sformatf("Part2-Section4.2.5: TID_%0h; Msgseg:%0h h (Msg_len: %0h h) \
          DPL greater than ssize; dpl_size: Act %0h h; Exp:%0h h", 
          index[7:0], pkt.msgseg_xmbox, pkt.msg_len, pkt.payload.size(), dpl_size))
          ll_pass_sts = 0;         
          LTLED_CSR[3] = 1;         
          err_type = PAYLOAD_ERR;
        end // } 
      end // } 
      else 
      begin // { 
        `uvm_error("SRIO_LL_PROTOCOL_CHECKER:PAYLOAD_ERR", 
        $sformatf("Part2-Section4.2.5: TID_%0h; Packet received with DPL < 8B; \
        dpl_size: Act %0h h; Exp:%0h h",  index[7:0], pkt.payload.size(), dpl_size))
        ll_pass_sts = 0;         
        LTLED_CSR[3] = 1;         
        err_type = PAYLOAD_ERR;
      end // } 
 
      // Check for msg_seg validity
      if (mseg && (pkt.msgseg_xmbox > pkt.msg_len))
      begin // {
        `uvm_error("SRIO_LL_PROTOCOL_CHECKER:MSGSEG_ERR", 
        $sformatf("Part2-Section4.2.5: TID_%0h; msgseg > msg_len; \
        msgseg: %0h h; msg_len: %0h h;", index[7:0], pkt.msgseg_xmbox, pkt.msg_len))
        ll_pass_sts = 0;         
        LTLED_CSR[3] = 1;         
        err_type = MSGSEG_ERR;
      end // }

      if (msg_array_mac.exists(index_mac))
      begin // {
        // Check for msg segment duplication
        if ((mseg && (msg_array_mac[index_mac].seg_list.exists(pkt.msgseg_xmbox))) ||
             sseg) 
        begin // {
          if (exp_resp_array_mac.exists(index))
          begin // { 
            if (exp_resp_array_mac[index].retry_reqd == 0)
            begin // { 
              `uvm_error("SRIO_LL_PROTOCOL_CHECKER:MSGSEG_ERR", 
              $sformatf("Part2-Section4.2.5: TID_%0h; Duplicated msg_seg : %0h h", 
              index[7:0], pkt.msgseg_xmbox))
              ll_pass_sts = 0;         
              sseg_valid = 0;
              mseg_valid = 0;   
              err_type = MSGSEG_ERR;
            end // }  
          end // }  
        end // }  
 
        if ((mseg_valid && (pkt.msgseg_xmbox <= pkt.msg_len)) || sseg_valid) 
        begin // {
          msg_array_mac[index_mac].seg_list[pkt.msgseg_xmbox] = 1;
          last_req[index_mac] = index; // {1'b1, pkt.letter, pkt.mbox, pkt.msgseg_xmbox};

          if (msg_array_mac[index_mac].SourceID != pkt.SourceID)                                
          begin // {
            `uvm_error("SRIO_LL_PROTOCOL_CHECKER:MSGSEG_ERR", 
            $sformatf("SpecRef:Part2-Section2.3.1: TID_%0h; \
            SourceID mismatches with the previous value; Exp: %0h, Act: %0h", 
            index[7:0], msg_array_mac[index_mac].SourceID, pkt.SourceID))
            LTLED_CSR[3] = 1;         
            ll_pass_sts = 0;            
            err_type = MSGSEG_ERR;
          end // } 
        end // } 
        // Check for unchanged msg_len
        if (pkt.msg_len != msg_array_mac[index_mac].msg_len)
        begin // {
          `uvm_error("SRIO_LL_PROTOCOL_CHECKER:MSGSEG_ERR", 
          $sformatf("Part2-Section4.2.5: TID_%0h; \
          msg_len mismatches with the previous value; Exp msg_len: %0h h Act: %0h h",
          index[7:0], msg_array_mac[index_mac].msg_len, pkt.msg_len))
          ll_pass_sts = 0;         
          LTLED_CSR[3] = 1;         
          err_type = MSGSEG_ERR;
        end // }  

        // Check for unchanged ssize
        if (pkt.ssize != msg_array_mac[index_mac].ssize)
        begin // {
          `uvm_error("SRIO_LL_PROTOCOL_CHECKER:MSGSEG_ERR", 
          $sformatf("Part2-Section4.2.5: TID_%0h; \
          ssize mismatches with the previous value; ssize Exp: %0h h; Act: %0h h", 
          index[7:0], msg_array_mac[index_mac].ssize, pkt.ssize))
          ll_pass_sts = 0;         
          LTLED_CSR[3] = 1;         
          err_type = MSGSEG_ERR;
        end // } 
      end // } 
    end // } 
 
    // Create a new message context
    if ((msg_array_mac.exists(index_mac)) == 0)
    begin // {
      if (((pkt.msg_len > 0) && (pkt.msgseg_xmbox <= pkt.msg_len)) || 
           (pkt.msg_len == 0))
      begin // {
        msg_assembly.ssize   = pkt.ssize;
        msg_assembly.msg_len = pkt.msg_len;
        msg_assembly.SourceID = pkt.SourceID;
        msg_assembly.seg_list[pkt.msgseg_xmbox] = 1;
        msg_assembly.msg_type = (mseg == 1) ? 1 : 0;
        msg_array_mac[index_mac] = msg_assembly;    
        last_req[index_mac] = index; // {1'b1, pkt.letter, pkt.mbox, pkt.msgseg_xmbox};
      end // }
    end // }

    // Update message status only when the index exists
    if ((ll_pass_sts == 0) && (msg_array_mac.exists(index_mac))) 
    begin // {
      msg_array_mac[index_mac].err_sts = 1;
    end // } 
  end // }
  else 
  begin // {
    if (mseg)
    begin // {
      `uvm_error("SRIO_LL_PROTOCOL_CHECKER:MSGSEG_ERR", 
      $sformatf("Part2-Section4.2.5: TID_%0h; Multi-seg msg is targetted a memory where \
      a Single-Seg Msg is already occupied;{Letter %0h h,MBox %0h h,xmbox %0h h}", 
      index[7:0], pkt.letter, pkt.mbox, pkt.msgseg_xmbox)) 
      err_type = MSGSEG_ERR;
    end // }
    else
    begin // {
      `uvm_error("SRIO_LL_PROTOCOL_CHECKER:MSGSEG_ERR", 
      $sformatf("Part2-Section4.2.5: TID_%0h; Single-seg msg is targetted a memory \
      where a Multi-Seg Msg is already occupied; {Letter %0h h,xmbox %0h h,MBox %0h h}", 
      index[7:0], pkt.letter,pkt.msgseg_xmbox,pkt.mbox)) 
      err_type = MSGSEG_ERR;
    end // }
  end // }

  // Check the message completeness
  if (msg_array_mac.exists(index_mac))
  begin // {
    if (msg_array_mac[index_mac].seg_list.size() == (msg_array_mac[index_mac].msg_len + 1))
    begin // {
      completed_seg = 0;
      for (int i= 0; i < 16; i++)
      begin // {
        if (msg_array_mac[index_mac].seg_list.exists(i[3:0]))
          completed_seg = completed_seg + msg_array_mac[index_mac].seg_list[i[3:0]];
      end // }
      if (completed_seg == (msg_array_mac[index_mac].msg_len + 1))
      begin // { 
        if (mseg)
        begin // {
          `uvm_info("SRIO_LL_PROTOCOL_CHECKER:msg_assembly_chk", 
          $sformatf("TID_%0h; MSeg Msg Reception Completed for Letter %0h h Mbox %0h h", 
          index[7:0], pkt.letter, pkt.mbox),UVM_LOW);
        end // }
        else
        begin // {
          sseg_mbox = {pkt.msgseg_xmbox, pkt.mbox}; 
          `uvm_info("SRIO_LL_PROTOCOL_CHECKER:msg_assembly_chk", 
          $sformatf("TID_%0h; SSeg Msg Reception Completed for Letter %0h h Mbox %0h h", 
          index[7:0], pkt.letter, sseg_mbox),UVM_LOW);
        end // }
      end // }
    end // }
  end // }

  if (mon_type) 
  begin // {
   `ifdef VCS_ASS_ARR_FIX
     foreach(last_req[copy_index]) `TX_LAST_REQ[copy_index] = last_req[copy_index];
     foreach(`TX_LAST_REQ[copy_index])
       if (last_req.exists(copy_index) == 0) `TX_LAST_REQ.delete(copy_index);
     
     foreach(msg_array_mac[copy_index]) `TX_MSG_ARRAY[copy_index] = msg_array_mac[copy_index];
     foreach(`TX_MSG_ARRAY[copy_index])
       if (msg_array_mac.exists(copy_index) == 0) `TX_MSG_ARRAY.delete(copy_index);     
   `else
    `TX_LAST_REQ = last_req; 
    `TX_MSG_ARRAY = msg_array_mac; 
   `endif
  end // }
  else 
  begin // { 
   `ifdef VCS_ASS_ARR_FIX
     foreach(last_req[copy_index]) `RX_LAST_REQ[copy_index] = last_req[copy_index];
     foreach(`RX_LAST_REQ[copy_index])
       if (last_req.exists(copy_index) == 0) `RX_LAST_REQ.delete(copy_index);

     foreach(msg_array_mac[copy_index]) `RX_MSG_ARRAY[copy_index] = msg_array_mac[copy_index];
     foreach(`RX_MSG_ARRAY[copy_index])
       if (msg_array_mac.exists(copy_index) == 0) `RX_MSG_ARRAY.delete(copy_index);
   `else
    `RX_LAST_REQ = last_req; 
    `RX_MSG_ARRAY = msg_array_mac; 
   `endif
  end // }

endfunction : msg_assembly_chk

////////////////////////////////////////////////////////////////////////////////
/// Name: outstanding_req_chk \n 
/// Description: Function to check Outstanding Request \n
/// outstanding_req_chk
////////////////////////////////////////////////////////////////////////////////

function void srio_ll_txrx_monitor::outstanding_req_chk();

  srio_trans tx_exp_resp_array_orc   [bit[72:0]];
  srio_trans rx_exp_resp_array_orc   [bit[72:0]];
  int        tx_resp_track_array_orc [bit[72:0]];
  bit [72:0] copy_index;

  srio_ftype ftype; 
  pkt_validity = 1;

  tx_exp_resp_array_orc.delete;   
  rx_exp_resp_array_orc.delete;   
  tx_resp_track_array_orc.delete; 

  if (mon_type) 
  begin // {
   `ifdef VCS_ASS_ARR_FIX
    foreach(`TX_EXP_RESP_ARRAY[copy_index]) tx_exp_resp_array_orc[copy_index]   = `TX_EXP_RESP_ARRAY[copy_index]; 
    foreach(`RX_EXP_RESP_ARRAY[copy_index]) rx_exp_resp_array_orc[copy_index]   = `RX_EXP_RESP_ARRAY[copy_index];
    foreach(`TX_RESP_TRACK_ARRAY[copy_index]) tx_resp_track_array_orc[copy_index] = `TX_RESP_TRACK_ARRAY[copy_index]; 
   `else
     tx_exp_resp_array_orc   = `TX_EXP_RESP_ARRAY; 
     rx_exp_resp_array_orc   = `RX_EXP_RESP_ARRAY;
     tx_resp_track_array_orc = `TX_RESP_TRACK_ARRAY; 
   `endif
  end // }
  else 
  begin // {
   `ifdef VCS_ASS_ARR_FIX
     foreach(`RX_EXP_RESP_ARRAY[copy_index]) tx_exp_resp_array_orc[copy_index]   = `RX_EXP_RESP_ARRAY[copy_index]; 
     foreach(`TX_EXP_RESP_ARRAY[copy_index]) rx_exp_resp_array_orc[copy_index]   = `TX_EXP_RESP_ARRAY[copy_index];
     foreach(`RX_RESP_TRACK_ARRAY[copy_index]) tx_resp_track_array_orc[copy_index] = `RX_RESP_TRACK_ARRAY[copy_index]; 
   `else
     tx_exp_resp_array_orc   = `RX_EXP_RESP_ARRAY; 
     rx_exp_resp_array_orc   = `TX_EXP_RESP_ARRAY;
     tx_resp_track_array_orc = `RX_RESP_TRACK_ARRAY; 
   `endif
  end // }

  ftype = srio_ftype'(pkt.ftype);
  if (req_pkt)   
  begin // {
    if (tx_exp_resp_array_orc.exists(index))  
    begin // {
      if (tx_resp_track_array_orc.exists(index))
      begin // {
        if (tx_exp_resp_array_orc[index].retry_reqd == 0)
        begin // {
         `ifdef VCS_ASS_ARR_FIX
          `uvm_error("SRIO_LL_PROTOCOL_CHECKER:OUTSTANDING_REQ_ERR", 
          $sformatf("SpecRef: Part1-Section3.1: Request with outstanding TID_%0h h  (tx_resp_track_array['h%h]);", 
          index[7:0], index))
         `else
          `uvm_error("SRIO_LL_PROTOCOL_CHECKER:OUTSTANDING_REQ_ERR", 
          $sformatf("SpecRef: Part1-Section3.1: Request with outstanding TID_%0h h;", 
          index[7:0]))
         `endif
          pkt_validity = 0;
          err_type = OUTSTANDING_REQ_ERR;
        end // }
        else if (tx_exp_resp_array_orc[index].ftype != ftype)  
        begin // {
          `uvm_error("SRIO_LL_PROTOCOL_CHECKER:OUTSTANDING_REQ_ERR", 
          $sformatf("TID_%0h; Retried packet with different ftype. \
          Original ftype %0h h; Retried ftype:%0h h",
          index[7:0], tx_exp_resp_array_orc[index].ftype, ftype))
          pkt_validity = 0;
          err_type = OUTSTANDING_REQ_ERR;
        end // }
      end // }   
      else
      begin // {
        tx_exp_resp_array_orc.delete(index);  
      end //}
    end // }
  end // }
 
  if (req_pkt == 0)
  begin // {
    if (rx_exp_resp_array_orc.exists(index) ==0)
    begin // {
      `uvm_error("SRIO_LL_PROTOCOL_CHECKER:UNEXP_RESP_ERR", 
      $sformatf("SpecRef: Part8-Section2.5.3: TID_%0h \
      Response for non-oustanding request; SourceID: %0h; DestinationID: %0h", 
      index[7:0], pkt.SourceID, pkt.DestinationID))
      pkt_validity = 0;
      LTLED_CSR[8] = 1;
      drop_packet  = 1; 
      err_type = UNEXP_RESP_ERR;
    end // }
    else
    begin // {  // TL check
      if (pkt.SourceID != rx_exp_resp_array_orc[index].DestinationID)
      begin // {
        `uvm_error("SRIO_LL_PROTOCOL_CHECKER:UNEXP_RESP_ERR", 
        $sformatf("SpecRef: Part3-Section2.3: TID_%0h \
        Response SrcID (%0h) != Request DestID (%0h);", 
        index[7:0], pkt.SourceID, rx_exp_resp_array_orc[index].DestinationID))
        pkt_validity = 0;
        drop_packet  = 1; 
        LTLED_CSR[8] = 1;
        err_type = UNEXP_RESP_ERR;
      end // }
      if (pkt.DestinationID != rx_exp_resp_array_orc[index].SourceID)
      begin // {
        `uvm_error("SRIO_LL_PROTOCOL_CHECKER:UNEXP_RESP_ERR", 
        $sformatf("SpecRef: Part3-Section2.3: TID_%0h \
        Response DestID (%0h) != Request SrcID (%0h);", 
        index[7:0], pkt.DestinationID, rx_exp_resp_array_orc[index].SourceID))
        pkt_validity = 0;
        drop_packet  = 1; 
        LTLED_CSR[8] = 1;
        err_type = UNEXP_RESP_ERR;
      end // }
    end // }

  end // }

  if (mon_type) 
  begin // {
    `ifdef VCS_ASS_ARR_FIX
     foreach(tx_exp_resp_array_orc[copy_index]) `TX_EXP_RESP_ARRAY[copy_index] = tx_exp_resp_array_orc[copy_index]; 
     foreach(`TX_EXP_RESP_ARRAY[copy_index])
     if (tx_exp_resp_array_orc.exists(copy_index) == 0) `TX_EXP_RESP_ARRAY.delete(copy_index);
    `else
     `TX_EXP_RESP_ARRAY = tx_exp_resp_array_orc; 
    `endif
  end // }
  else 
  begin // { 
    `ifdef VCS_ASS_ARR_FIX
     foreach(tx_exp_resp_array_orc[copy_index]) `RX_EXP_RESP_ARRAY[copy_index] = tx_exp_resp_array_orc[copy_index]; 
     foreach(`RX_EXP_RESP_ARRAY[copy_index])
     if (tx_exp_resp_array_orc.exists(copy_index) == 0) `RX_EXP_RESP_ARRAY.delete(copy_index);
    `else
     `RX_EXP_RESP_ARRAY = tx_exp_resp_array_orc; 
    `endif
  end // }

endfunction : outstanding_req_chk

////////////////////////////////////////////////////////////////////////////////
/// Name: outstanding_ato_req_chk \n 
/// Description: Function to check Atomic request for not getting interrupted \n
///              by another operation to the same address \n
/// outstanding_ato_req_chk
////////////////////////////////////////////////////////////////////////////////

function void srio_ll_txrx_monitor::outstanding_ato_req_chk();

  srio_trans ato_req_array_orc[bit[65:0]];
   bit [65:0] copy_index;
 
  type2_ttype ttype2_orc;
  type5_ttype ttype5_orc;

  ato_req_array_orc.delete; 

  if (mon_type) 
    `ifdef VCS_ASS_ARR_FIX
      foreach (`TX_ATO_REQ_ARRAY[copy_index]) ato_req_array_orc[copy_index] = `TX_ATO_REQ_ARRAY[copy_index]; 
    `else
      ato_req_array_orc = `TX_ATO_REQ_ARRAY; 
    `endif
  else 
    `ifdef VCS_ASS_ARR_FIX
      foreach (`RX_ATO_REQ_ARRAY[copy_index]) ato_req_array_orc[copy_index] = `RX_ATO_REQ_ARRAY[copy_index]; 
    `else
      ato_req_array_orc = `RX_ATO_REQ_ARRAY; 
    `endif

  if (req_pkt)   
  begin // {
    // Atomic operations should not be interrupted by another operation to 
    // the same address
    if(ato_req_array_orc.exists(address_66bit))
    begin // {
      ttype2_orc  = type2_ttype'(ato_req_array_orc[address_66bit].ttype); 
      ttype5_orc  = type5_ttype'(ato_req_array_orc[address_66bit].ttype);
      `uvm_error("SRIO_LL_PROTOCOL_CHECKER:OUTSTANDING_REQ_ERR", 
      $sformatf("TID_%0h; Atomic Operation interrupted by another operation\
      to the same address; Address: %0h; Outstanding Atomic request: %s ",
      index[7:0], pkt.address, 
      (ato_req_array_orc[address_66bit].ftype == 2) ? ttype2_orc.name : ttype5_orc.name))
      pkt_validity = 0;
      err_type = OUTSTANDING_REQ_ERR;
    end // }
    else if (ato_pkt)
    begin // {
      ato_req_array_orc[address_66bit] = ato_packet;
    end // }
  end // }
 
  if (mon_type) begin
    `ifdef VCS_ASS_ARR_FIX
     foreach(ato_req_array_orc[copy_index]) `TX_ATO_REQ_ARRAY[copy_index] = ato_req_array_orc[copy_index]; 
     foreach(`TX_ATO_REQ_ARRAY[copy_index])
     if (ato_req_array_orc.exists(copy_index) == 0) `TX_ATO_REQ_ARRAY.delete(copy_index);
    `else
     `TX_ATO_REQ_ARRAY = ato_req_array_orc; 
    `endif
    end
  else begin
    `ifdef VCS_ASS_ARR_FIX
     foreach(ato_req_array_orc[copy_index]) `RX_ATO_REQ_ARRAY[copy_index] = ato_req_array_orc[copy_index]; 
     foreach(`RX_ATO_REQ_ARRAY[copy_index])
       if (ato_req_array_orc.exists(copy_index) == 0) `RX_ATO_REQ_ARRAY.delete(copy_index);
    `else
     `RX_ATO_REQ_ARRAY = ato_req_array_orc; 
    `endif
    end
endfunction : outstanding_ato_req_chk

////////////////////////////////////////////////////////////////////////////////
/// Name: resp_pkt_chk \n 
/// Description: Function to check Response Packet Protocol \n
/// resp_pkt_chk
////////////////////////////////////////////////////////////////////////////////

function void srio_ll_txrx_monitor::resp_pkt_chk();
  srio_trans exp_resp_array_rpc [bit[72:0]];
  srio_trans ato_req_array_rpc  [bit[65:0]];
  int        req_track_array_rpc[bit[72:0]]; 
  srio_ll_msg_assembly  msg_array_rpc[bit[72:0]];

  pkt_sts      sts;
  pkt_sts      exp_sts;
  type13_ttype ttype13;
  type8_ttype  ttype8;
  type8_ttype  exp_ttype8;
  srio_ftype   ftype;
  srio_ftype   ftype_req;
  int          exp_dpl_size;
  bit [7:0]    tid;
  bit          del_msg = 0;
   bit [72:0]  copy_index;
   bit [65:0]  ato_copy_index;

  msg_array_rpc.delete;
  exp_resp_array_rpc.delete;
  req_track_array_rpc.delete;
  ato_req_array_rpc.delete;

  if (mon_type) 
  begin 
   `ifdef VCS_ASS_ARR_FIX
     foreach(`RX_EXP_RESP_ARRAY[copy_index]) exp_resp_array_rpc[copy_index]  = `RX_EXP_RESP_ARRAY[copy_index];  
     foreach(`RX_REQ_TRACK_ARRAY[copy_index]) req_track_array_rpc[copy_index] = `RX_REQ_TRACK_ARRAY[copy_index]; 
     foreach(`RX_MSG_ARRAY[copy_index]) msg_array_rpc[copy_index]       = `RX_MSG_ARRAY[copy_index]; 
     foreach(`RX_ATO_REQ_ARRAY[ato_copy_index]) ato_req_array_rpc[ato_copy_index]   = `RX_ATO_REQ_ARRAY[ato_copy_index]; 
   `else
     exp_resp_array_rpc  = `RX_EXP_RESP_ARRAY;  
     req_track_array_rpc = `RX_REQ_TRACK_ARRAY; 
     msg_array_rpc       = `RX_MSG_ARRAY; 
     ato_req_array_rpc   = `RX_ATO_REQ_ARRAY; 
   `endif
  end 
  else 
  begin 
   `ifdef VCS_ASS_ARR_FIX
     foreach(`TX_EXP_RESP_ARRAY[copy_index]) exp_resp_array_rpc[copy_index]  = `TX_EXP_RESP_ARRAY[copy_index];  
     foreach(`TX_REQ_TRACK_ARRAY[copy_index]) req_track_array_rpc[copy_index] = `TX_REQ_TRACK_ARRAY[copy_index]; 
     foreach(`TX_MSG_ARRAY[copy_index]) msg_array_rpc[copy_index]       = `TX_MSG_ARRAY[copy_index]; 
     foreach(`TX_ATO_REQ_ARRAY[ato_copy_index]) ato_req_array_rpc[ato_copy_index]   = `TX_ATO_REQ_ARRAY[ato_copy_index]; 
   `else
     exp_resp_array_rpc  = `TX_EXP_RESP_ARRAY;   
     req_track_array_rpc = `TX_REQ_TRACK_ARRAY; 
     msg_array_rpc       = `TX_MSG_ARRAY; 
     ato_req_array_rpc   = `TX_ATO_REQ_ARRAY; 
   `endif
  end 

  ttype13   = type13_ttype'(pkt.ttype);
  ttype8    = type8_ttype'(pkt.ttype);
  ftype     = srio_ftype'(pkt.ftype);
  ftype_req = srio_ftype'(exp_resp_array_rpc[index].ftype);
  sts       = pkt_sts'(pkt.trans_status);
  exp_sts   = pkt_sts'(exp_resp_array_rpc[index].trans_status);

  exp_ttype8 = type8_ttype'(exp_resp_array_rpc[index].ttype);
  tid        = index[7:0];

  exp_dpl_size = exp_resp_array_rpc[index].dpl_size;
  if (exp_dpl_size < 8)
  begin // {
    exp_dpl_size = 8;
  end // }

  if (pkt.vc != 0)
  begin // {
    `uvm_warning("SRIO_LL_PROTOCOL_CHECKER:vc_chk", 
    $sformatf("Part6-Section6.12: TID_%0h h Response Packet with vc != 0",
    index[7:0]))
  end // }                                     
               
  if(((ftype == TYPE13) && 
     ((sts != STS_DONE) && (sts != STS_DATA_ONLY) &&
      (sts != STS_NOT_OWNER) && (sts != STS_RETRY) &&
      (sts != STS_INTERVENTION) && (sts != STS_DONE_INT) &&
      (sts != STS_ERROR)))                                            || 
     ((ftype == TYPE8) && ((sts != STS_DONE) && (sts != STS_ERROR)))  ||       
     ((ftype == TYPE13) && (exp_resp_array_rpc[index].ll_pkt_type != 3) && // 3-> gsm_pkt
     ((sts == STS_DATA_ONLY)    || (sts == STS_NOT_OWNER)    ||
      (sts == STS_INTERVENTION) || (sts == STS_DONE_INT)))) 
  begin // {
    `uvm_error("SRIO_LL_PROTOCOL_CHECKER:RESP_RSVD_STS_ERR", 
    $sformatf("Part2-Section4.3.1: TID_%0h Reserved status", tid))
    LTLED_CSR[4] = 1;
    err_type = RESP_RSVD_STS_ERR;
  end // }

  // Status check 
  if ((((sts == STS_ERROR) || (sts == STS_DONE))   &&
        (exp_resp_array_rpc[index].trans_status != sts))        || 
    // Retry could be issued only after protocol checks  
      (((sts == STS_RETRY) && 
       ((exp_resp_array_rpc[index].ftype == TYPE11) || 
        (exp_resp_array_rpc[index].ftype == TYPE10))) &&
        (exp_resp_array_rpc[index].trans_status != STS_DONE)))   
  begin // {
    `uvm_error("SRIO_LL_PROTOCOL_CHECKER:UNEXP_RESP_STS_ERR", 
    $sformatf("Part1-Section4.2: TID_%0h Response status mismatch; Exp:%s, Act: %s", 
    tid, exp_sts.name, sts.name))
    err_type = UNEXP_RESP_STS_ERR;
  end // } 

  if (sts == STS_RETRY)
  begin // { 
    if ((exp_resp_array_rpc[index].ftype == TYPE11) || 
        (exp_resp_array_rpc[index].ftype == TYPE10) ||
        (exp_resp_array_rpc[index].ll_pkt_type == 3))  // 3->gsm_pkt  
    begin // {
      `uvm_info("SRIO_LL_PROTOCOL_CHECKER:resp_pkt_chk", 
      $sformatf("TID_%0h Packet retry is requested for Type%0h h", 
      tid, exp_resp_array_rpc[index].ftype), UVM_LOW)
      exp_resp_array_rpc[index].retry_reqd = 1;
    end // }
    else
    begin // {
      `uvm_error("SRIO_LL_PROTOCOL_CHECKER:RESP_RSVD_STS_ERR", 
      $sformatf("Part2-Section4.3.1: TID_%0h \
      Reserved status bit; %s for req other than TYPE10/11 ",tid, sts.name))
      LTLED_CSR[4] = 1;
      err_type = RESP_RSVD_STS_ERR;
    end // }
  end // }
  else
  begin // {
    exp_resp_array_rpc[index].retry_reqd = 0;
  end // }

  case (ftype) //{
    TYPE13:
    begin // {
      // ttype check
      if((((ttype13 == MSG_RES)  || (ttype13 == RES_WITH_DP)) &&
           (exp_resp_array_rpc[index].ttype != ttype13))                ||
          ((ttype13 != RES_WO_DP) && (exp_resp_array_rpc[index].ttype == RES_WO_DP))) 
      begin // {
        `uvm_error("SRIO_LL_PROTOCOL_CHECKER:UNEXP_RESP_ERR", 
        $sformatf("Part1-Section4.2: TID_%0h Unexpected ttype in response; \
        Exp: %0h h; Act: %0h h", tid, exp_resp_array_rpc[index].ttype, ttype13))
        err_type = UNEXP_RESP_ERR;
      end // }

      // Data payload check
      if (((ttype13 == RES_WO_DP) || (sts == STS_ERROR) || (ttype13 == MSG_RES))  &&
           (pkt.payload.size() != 0)) 
      begin // {
        `uvm_error("SRIO_LL_PROTOCOL_CHECKER:RESP_PAYLOAD_ERR", 
        $sformatf("Part1-Section4.2.3: TID_%0h Unexpected DPL; dpl_size: %0h h",
        tid,  pkt.payload.size()))
        err_type = RESP_PAYLOAD_ERR;
      end // }

      if (((ttype13 == RES_WITH_DP) && (sts != STS_ERROR)) &&
           (pkt.payload.size() == 0)) 
      begin // {
        `uvm_error("SRIO_LL_PROTOCOL_CHECKER:RESP_PAYLOAD_ERR", 
        $sformatf("Part1-Section4.2: TID_%0h DPL is missing for RES_WITH_DP type",
        tid))
        err_type = RESP_PAYLOAD_ERR;
      end // }

      if ((ttype13 == RES_WITH_DP) && 
          (sts == STS_DONE) || (sts == STS_DATA_ONLY))          
      begin // {
        if (pkt.payload.size() > exp_dpl_size)
        begin // { 
          `uvm_error("SRIO_LL_PROTOCOL_CHECKER:RESP_PAYLOAD_ERR", 
          $sformatf("SpecRef:Part1-Section4.2: TID_%0h \
          Excess DPL; Exp: %0h h, Act: %0h h",tid, exp_dpl_size, pkt.payload.size))
          drop_packet  = 1; 
          LTLED_CSR[4] = 1;
          err_type = RESP_PAYLOAD_ERR;
        end // }
        else if (pkt.payload.size() < exp_dpl_size)
        begin // { 
          `uvm_error("SRIO_LL_PROTOCOL_CHECKER:RESP_PAYLOAD_ERR", 
          $sformatf("SpecRef:Part1-Section4.2: TID_%0h \
          Insufficient DPL; Exp: %0h h, Act: %0h h",
          tid, exp_dpl_size, pkt.payload.size()))
          drop_packet  = 1; 
          LTLED_CSR[4] = 1;
          err_type = RESP_PAYLOAD_ERR;
        end // }
      end // }

      if (exp_resp_array_rpc[index].ll_pkt_type == 3) //  gsm_pkt check
      begin // { 
        if(sts != STS_RETRY) 
        begin // {
          case (exp_resp_array_rpc[index].ftype) // {
            TYPE1:
            begin // {
              if ((sts != STS_INTERVENTION) && (sts != STS_ERROR))
              begin // {
                `uvm_error("SRIO_LL_PROTOCOL_CHECKER:RESP_RSVD_STS_ERR", 
                $sformatf("SpecRef:Part5-Section3.3: TID_%0h \
                Invalid Response status (%s) for %s;", tid, sts.name, ftype_req.name))
                err_type = RESP_RSVD_STS_ERR;
              end // }
              else
              begin // {
                if (sts != exp_sts)
                begin // {
                  `uvm_error("SRIO_LL_PROTOCOL_CHECKER:RESP_RSVD_STS_ERR", 
                  $sformatf("SpecRef:Part5-Section3.3: TID_%0h \
                  Unexpected Response status; Exp: %s, Act: %s", tid, exp_sts.name, sts.name))
                  err_type = RESP_RSVD_STS_ERR;
                end // }
              end // }
            end // }
 
            TYPE2:
            begin // {
              case (ttype2) // { 
                DKILL_HOME, IKILL_HOME, TLBIE, TLBSYNC, FLUSH_WO_DATA, IKILL_SHARER, DKILL_SHARER:
                begin // {
                  if ((sts != STS_DONE) && (sts != STS_ERROR))
                  begin // {
                    `uvm_error("SRIO_LL_PROTOCOL_CHECKER:RESP_RSVD_STS_ERR", 
                    $sformatf("SpecRef:Part5-Section3.3: TID_%0h \
                    Invalid Response status (%s) for %s;", tid, sts.name, ftype_req.name))
                    err_type = RESP_RSVD_STS_ERR;
                  end // }
                  else
                  begin // {
                    if (sts != exp_sts)
                    begin // {
                      `uvm_error("SRIO_LL_PROTOCOL_CHECKER:RESP_RSVD_STS_ERR", 
                      $sformatf("SpecRef:Part5-Section3.3: TID_%0h \
                      Unexpected Response status; Exp: %s, Act: %s", 
                      tid, exp_sts.name, sts.name))
                      err_type = RESP_RSVD_STS_ERR;
                    end // }
                  end // }
                end // }

                RD_HOME, RD_OWN_HOME, IORD_HOME, IRD_HOME:
                begin // {
                  if ((sts != STS_DONE) && (sts != STS_DONE_INT) && 
                      (sts != STS_DATA_ONLY) && (sts != STS_ERROR))
                  begin // {
                    `uvm_error("SRIO_LL_PROTOCOL_CHECKER:RESP_RSVD_STS_ERR", 
                    $sformatf("SpecRef:Part5-Section3.3: TID_%0h \
                    Invalid Response status (%s) for %s;", 
                    tid, sts.name, ftype_req.name))
                    err_type = RESP_RSVD_STS_ERR;
                  end // } 
                end // } 
              endcase  // }             
            end // }
 
            TYPE5:
            begin // {
              if ((sts != STS_DONE) && (sts != STS_ERROR))
              begin // {
                `uvm_error("SRIO_LL_PROTOCOL_CHECKER:RESP_RSVD_STS_ERR", 
                $sformatf("SpecRef:Part5-Section3.3: TID_%0h \
                Invalid Response status (%s) for %s;", 
                tid, sts.name, ftype_req.name))
                err_type = RESP_RSVD_STS_ERR;
              end // }
              else
              begin // {
                if (sts != exp_sts)
                begin // {
                  `uvm_error("SRIO_LL_PROTOCOL_CHECKER:RESP_RSVD_STS_ERR", 
                  $sformatf("SpecRef:Part5-Section3.3: TID_%0h \
                  Unexpected Response status; Exp: %s, Act: %s", 
                  tid, exp_sts.name, sts.name))
                  err_type = RESP_RSVD_STS_ERR;
                end // }
              end // }
            end // } 
          endcase // }     
        end // } 
      end // }
    end // }
  
    TYPE8:
    begin // { 
      if(ttype8 != exp_resp_array_rpc[index].ttype) 
      begin // {
        `uvm_error("SRIO_LL_PROTOCOL_CHECKER:UNEXP_RESP_ERR", 
        $sformatf("SpecRef:Part1-Section4.1.10: TID_%0h \
        Response ttype mismatch; Exp: %s, Act: %s", 
        tid, exp_ttype8.name, ttype8.name))
        drop_packet  = 1; 
        LTLED_CSR[4] = 1;
        err_type = UNEXP_RESP_ERR;
      end // }
      else if (ttype8 == MAINT_RD_RES) 
      begin // {
        if (((pkt.payload.size() != exp_dpl_size) && (sts == STS_DONE)) ||
            ((pkt.payload.size() != exp_dpl_size) && (sts == STS_ERROR) && 
             (pkt.payload.size() != 0)))
        begin // { 
          if (sts == STS_ERROR)
          begin // { 
            `uvm_error("SRIO_LL_PROTOCOL_CHECKER:RESP_PAYLOAD_ERR", 
            $sformatf("Part1-Section4.1.10: TID_%0h \
            Maintenance read Error_Response with neither Null DPL not expected DPL; \
            Exp: %0h h, Act: %0h h",
            tid,exp_dpl_size, pkt.payload.size()))
            drop_packet  = 1; 
            LTLED_CSR[4] = 1;
            err_type = RESP_PAYLOAD_ERR;
          end // }
          else 
          begin // {
            `uvm_error("SRIO_LL_PROTOCOL_CHECKER:RESP_PAYLOAD_ERR", 
            $sformatf("SpecRef:Part1-Section4.1.10: TID_%0h \
            MAINT_RD_RES DPL mismatch; Exp: %0h h, Act: %0h h", 
            tid,exp_dpl_size, pkt.payload.size()))
            drop_packet  = 1; 
            LTLED_CSR[4] = 1;
            err_type = RESP_PAYLOAD_ERR;
          end // }
        end // }
      end // }

      if (pkt.hop_count != exp_resp_array_rpc[index].hop_count)
      begin // {
        `uvm_error("SRIO_LL_PROTOCOL_CHECKER:HOP_COUNT_ERR", 
        $sformatf("SpecRef:Part1-Section4.1.10: TID_%0h \
        Maintenance Resp with Hop_count != 8'FF; Act Hop_count: %0h h",
        tid, pkt.hop_count));
        err_type = HOP_COUNT_ERR;
      end // }
    end // }
  
  endcase //}

  if (sts == STS_ERROR) 
  begin // {
    //ll_pkt_type = (io_pkt ? 1 : (msg_pkt ? 2 : (gsm_pkt ? 3 : 0)));
    case (exp_resp_array_rpc[index].ll_pkt_type) // {
      1: // 
      begin // {
        `uvm_info("SRIO_LL_PROTOCOL_CHECKER:resp_pkt_chk", 
        $sformatf("TID_%0h IO Error Response", tid), UVM_LOW)
        LTLED_CSR[0] = 1;
      end // }  
      2: // 
      begin // {
        `uvm_info("SRIO_LL_PROTOCOL_CHECKER:resp_pkt_chk", 
        $sformatf("TID_%0h IO MSG Error Response", tid), UVM_LOW)
        LTLED_CSR[1] = 1;
      end // }  
      3: // 
      begin // {
        `uvm_info("SRIO_LL_PROTOCOL_CHECKER:resp_pkt_chk", 
        $sformatf("TID_%0h IO GSM Error Response", tid), UVM_LOW)
        LTLED_CSR[2] = 1;
      end // }  
    endcase  // }
  end // }

  if (exp_resp_array_rpc.exists(index))
  begin // {
    if (exp_resp_array_rpc[index].ll_pkt_type == 2) // 2-> Msg Pkt
    begin // {
      if (exp_resp_array_rpc[index].msg_type == 1)  // 0-> SSeg; 1-> MSeg
      begin // {
        if (msg_array_rpc.exists({index[72:4],4'b0}))
        begin // {

          if (exp_resp_array_rpc[index].retry_reqd == 1)
          begin // {
            msg_array_rpc[{index[72:4],4'b0}].seg_list[index[3:0]] = 0;
          end // }

          if (msg_array_rpc[{index[72:4],4'b0}].seg_list.size() == 
             (msg_array_rpc[{index[72:4],4'b0}].msg_len + 1))
          begin // {
            del_msg = 1;
            for (bit[4:0] seg_id = 0; seg_id < (msg_array_rpc[{index[72:4],4'b0}].msg_len + 1); seg_id++)
            begin // {
              if ((({index[72:4],seg_id[3:0]} != index) &&  
                  (exp_resp_array_rpc.exists({index[72:4],seg_id[3:0]})))                  || 
                (({index[72:4],seg_id[3:0]} == index) &&  
                  (exp_resp_array_rpc[{index[72:4],seg_id[3:0]}].retry_reqd == 1)))
              begin // {
                del_msg = 0;
                break;
              end // } 
            end // } 
            if (del_msg)
            begin // {
              msg_array_rpc[{index[72:4],4'b0}].seg_list.delete();
              msg_array_rpc.delete({index[72:4],4'b0});
            end // } 
          end // } 
        end // }
      end // }
      else 
      begin // { 
        if (msg_array_rpc.exists(index))
        begin // {
          if (exp_resp_array_rpc[index].retry_reqd == 0)
          begin // {
            msg_array_rpc.delete(index);
          end // } 
          else 
          begin // {
            msg_array_rpc[index].seg_list[index[3:0]] = 0;  
          end // }
        end // }
      end // }
    end // }
 
    if (exp_resp_array_rpc[index].retry_reqd == 0)
    begin // {
      exp_resp_array_rpc.delete(index); 
      req_track_array_rpc[index] = 0;  

      // Removing the outstanding address detail of the atomic request 
      if(ato_req_array_rpc.exists(address_66bit))
      begin // {
        ato_req_array_rpc.delete(address_66bit);
      end // }
    end // }
  end // }

  if (mon_type) 
  begin
   `ifdef VCS_ASS_ARR_FIX
     foreach(exp_resp_array_rpc[copy_index]) `RX_EXP_RESP_ARRAY[copy_index]  = exp_resp_array_rpc[copy_index]; 
     foreach(`RX_EXP_RESP_ARRAY[copy_index])
       if (exp_resp_array_rpc.exists(copy_index) == 0) `RX_EXP_RESP_ARRAY.delete(copy_index);
     
     foreach(req_track_array_rpc[copy_index]) `RX_REQ_TRACK_ARRAY[copy_index] = req_track_array_rpc[copy_index]; 
     foreach(`RX_REQ_TRACK_ARRAY[copy_index])
       if (req_track_array_rpc.exists(copy_index) == 0) `RX_REQ_TRACK_ARRAY.delete(copy_index);

     foreach(msg_array_rpc[copy_index]) `RX_MSG_ARRAY[copy_index]       = msg_array_rpc[copy_index]; 
     foreach(`RX_MSG_ARRAY[copy_index])
       if (msg_array_rpc.exists(copy_index) == 0) `RX_MSG_ARRAY.delete(copy_index);

     foreach(ato_req_array_rpc[ato_copy_index]) `RX_ATO_REQ_ARRAY[ato_copy_index]   = ato_req_array_rpc[ato_copy_index]; 
     foreach(`RX_ATO_REQ_ARRAY[ato_copy_index])
       if (ato_req_array_rpc.exists(ato_copy_index) == 0) `RX_ATO_REQ_ARRAY.delete(ato_copy_index);
   `else
    `RX_EXP_RESP_ARRAY  = exp_resp_array_rpc; 
    `RX_REQ_TRACK_ARRAY = req_track_array_rpc; 
    `RX_MSG_ARRAY       = msg_array_rpc; 
    `RX_ATO_REQ_ARRAY   = ato_req_array_rpc; 
   `endif
  end
  else 
  begin 
   `ifdef VCS_ASS_ARR_FIX
     foreach(exp_resp_array_rpc[copy_index]) `TX_EXP_RESP_ARRAY[copy_index]  = exp_resp_array_rpc[copy_index]; 
     foreach(`TX_EXP_RESP_ARRAY[copy_index])
       if (exp_resp_array_rpc.exists(copy_index) == 0) `TX_EXP_RESP_ARRAY.delete(copy_index);
     
     foreach(req_track_array_rpc[copy_index]) `TX_REQ_TRACK_ARRAY[copy_index] = req_track_array_rpc[copy_index]; 
     foreach(`TX_REQ_TRACK_ARRAY[copy_index])
       if (req_track_array_rpc.exists(copy_index) == 0) `TX_REQ_TRACK_ARRAY.delete(copy_index);

     foreach(msg_array_rpc[copy_index]) `TX_MSG_ARRAY[copy_index]       = msg_array_rpc[copy_index]; 
     foreach(`TX_MSG_ARRAY[copy_index])
       if (msg_array_rpc.exists(copy_index) == 0) `TX_MSG_ARRAY.delete(copy_index);

     foreach(ato_req_array_rpc[ato_copy_index]) `TX_ATO_REQ_ARRAY[ato_copy_index]   = ato_req_array_rpc[ato_copy_index]; 
     foreach(`TX_ATO_REQ_ARRAY[ato_copy_index])
       if (ato_req_array_rpc.exists(ato_copy_index) == 0) `TX_ATO_REQ_ARRAY.delete(ato_copy_index);
   `else
    `TX_EXP_RESP_ARRAY  = exp_resp_array_rpc; 
    `TX_REQ_TRACK_ARRAY = req_track_array_rpc; 
    `TX_MSG_ARRAY       = msg_array_rpc; 
    `TX_ATO_REQ_ARRAY   = ato_req_array_rpc; 
   `endif
  end

endfunction: resp_pkt_chk 

////////////////////////////////////////////////////////////////////////////////
/// Name: resp_pkt_gen \n 
/// Description: Function to generate the Expected Response Packet \n
/// resp_pkt_gen
////////////////////////////////////////////////////////////////////////////////

function void srio_ll_txrx_monitor::resp_pkt_gen();

  int           resp_track_array_rpg[bit[72:0]];
  srio_trans    exp_resp_array_rpg  [bit[72:0]];
  bit           chk_passed;
  srio_ftype    ftype;
  type8_ttype   ttype8;
  string        incoming_gsm_req;
  string        out_in_gsm_req;
   bit [72:0]   copy_index;
  chk_passed  = 0;
  exp_resp_array_rpg.delete; 
  resp_track_array_rpg.delete; 

  mon_trans  = new pkt; 
  ftype      = srio_ftype'(mon_trans.ftype);
  ttype8     = type8_ttype'(mon_trans.ttype);
  chk_passed = (ll_pass_sts && tl_pass_sts);

  if (mon_type) 
  begin // {
   `ifdef VCS_ASS_ARR_FIX
    foreach(`TX_EXP_RESP_ARRAY[copy_index]) exp_resp_array_rpg[copy_index]   = `TX_EXP_RESP_ARRAY[copy_index]; 
    foreach(`TX_RESP_TRACK_ARRAY[copy_index]) resp_track_array_rpg[copy_index] = `TX_RESP_TRACK_ARRAY[copy_index]; 
   `else
    exp_resp_array_rpg   = `TX_EXP_RESP_ARRAY; 
    resp_track_array_rpg = `TX_RESP_TRACK_ARRAY; 
   `endif
  end // }
  else 
  begin // {
   `ifdef VCS_ASS_ARR_FIX
    foreach (`RX_EXP_RESP_ARRAY[copy_index]) exp_resp_array_rpg[copy_index]   = `RX_EXP_RESP_ARRAY[copy_index]; 
    foreach (`RX_RESP_TRACK_ARRAY[copy_index]) resp_track_array_rpg[copy_index] = `RX_RESP_TRACK_ARRAY[copy_index]; 
   `else
    exp_resp_array_rpg   = `RX_EXP_RESP_ARRAY; 
    resp_track_array_rpg = `RX_RESP_TRACK_ARRAY; 
   `endif
  end // }

  mon_trans.trans_status = ((chk_passed == 1) ? ((ftype == TYPE1) ? 
                            STS_INTERVENTION : STS_DONE) :STS_ERROR);
  mon_trans.dpl_size     = dpl_size;

  if (pkt.vc != 0)
  begin // {
    `uvm_warning("SRIO_LL_PROTOCOL_CHECKER:vc_chk", 
    $sformatf("Part6-Section6.12: TID_%0h h Request transaction requiring \
    response with vc != 0",index[7:0]))
  end // } 
            
  // Address collision 
  if (gsm_pkt)         
  begin // {           
    if (chk_passed)    
    begin // {  
      if ((outstanding_gsm_req != "NULL") && 
          (exp_resp_array_rpg.exists(outstanding_gsm_req_tid)))
      begin // {  
        incoming_gsm_req = {((ftype == 1) ? ttype1.name :
                            ((ftype == 2) ? ttype2.name : ttype5.name))};  
        `uvm_info("SRIO_LL_PROTOCOL_CHECKER:gsm_chk",  
        $sformatf("GSM incoming_gsm_req %s", incoming_gsm_req),UVM_LOW)
        out_in_gsm_req = {outstanding_gsm_req, "__", incoming_gsm_req};  

        if ((incoming_gsm_req != "TLBIE") && (incoming_gsm_req != "TLBSYNC"))
        begin // { 
          case (out_in_gsm_req) // {
            // DONE response
            "CAST_OUT__IKILL_SHARER",               "DKILL_HOME__RD_OWN_OWNER",
            "CAST_OUT__TLBIE",                      "RD_OWN_HOME__RD_OWNER",
            "CAST_OUT__TLBSYNC",                    "RD_OWN_HOME__RD_OWN_OWNER",
            "DKILL_HOME__IKILL_SHARER",             "IORD_HOME__DKILL_SHARER",
            "DKILL_HOME__IO_RD_OWNER",              "IORD_HOME__IKILL_SHARER",
            "DKILL_HOME__TLBIE",                    "IORD_HOME__TLBIE",
            "DKILL_HOME__TLBSYNC",                  "IORD_HOME__TLBSYNC",
            "DKILL_SHARER__IKILL_HOME",             "IO_RD_OWNER__IKILL_HOME",
            "DKILL_SHARER__TLBIE",                  "IO_RD_OWNER__TLBIE",
            "DKILL_SHARER__TLBSYNC",                "IO_RD_OWNER__TLBSYNC",
            "FLUSH_WD__IKILL_SHARER",               "IRD_HOME__DKILL_SHARER",
            "FLUSH_WD__TLBIE",                      "IRD_HOME__IKILL_SHARER",
            "FLUSH_WD__TLBSYNC",                    "IRD_HOME__IO_RD_OWNER",
            "FLUSH_WO_DATA__IKILL_SHARER",          "IRD_HOME__RD_OWNER",
            "FLUSH_WO_DATA__TLBIE",                 "IRD_HOME__RD_OWN_OWNER",
            "FLUSH_WO_DATA__TLBSYNC",               "IRD_HOME__TLBIE",
            "IKILL_HOME__CAST_OUT",                 "IRD_HOME__TLBSYNC",
            "IKILL_HOME__DKILL_SHARER",             "RD_HOME__DKILL_SHARER",
            "IKILL_HOME__IKILL_SHARER",             "RD_HOME__IKILL_SHARER",
            "IKILL_HOME__IO_RD_OWNER",              "RD_HOME__TLBIE",
            "IKILL_HOME__RD_OWNER",                 "RD_HOME__TLBSYNC",
            "IKILL_HOME__RD_OWN_OWNER",             "RD_OWNER__CAST_OUT",
            "IKILL_HOME__TLBIE",                    "RD_OWNER__IKILL_HOME",
            "IKILL_HOME__TLBSYNC",                  "RD_OWNER__TLBIE",
            "IKILL_SHARER__CAST_OUT",               "RD_OWNER__TLBSYNC",
            "IKILL_SHARER__DKILL_HOME",             "RD_OWN_HOME__FLUSH_WD",
            "IKILL_SHARER__FLUSH_WD",               "RD_OWN_HOME__FLUSH_WO_DATA",
            "IKILL_SHARER__FLUSH_WO_DATA",          "RD_OWN_HOME__IKILL_SHARER",
            "IKILL_SHARER__IKILL_HOME",             "RD_OWN_HOME__IO_RD_OWNER",
            "IKILL_SHARER__IRD_HOME",               "RD_OWN_HOME__TLBIE",
            "IKILL_SHARER__RD_HOME",                "RD_OWN_HOME__TLBSYNC",
            "IKILL_SHARER__RD_OWN_HOME",            "RD_OWN_OWNER__CAST_OUT",
            "IKILL_SHARER__TLBIE",                  "RD_OWN_OWNER__IKILL_HOME",
            "IKILL_SHARER__TLBSYNC",                "RD_OWN_OWNER__TLBIE",
            "DKILL_HOME__RD_OWNER",             "RD_OWN_OWNER__TLBSYNC":
            begin // {
              mon_trans.trans_status = STS_DONE;
              `uvm_info("SRIO_LL_PROTOCOL_CHECKER:gsm_chk",  
              $sformatf("GSM out_in_gsm_req %s", out_in_gsm_req),UVM_LOW)
            end  // }
            // ERROR response
            "CAST_OUT__CAST_OUT",                   "IKILL_SHARER__IKILL_SHARER",
            "CAST_OUT__DKILL_HOME",                 "IKILL_SHARER__IO_RD_OWNER",
            "CAST_OUT__DKILL_SHARER",               "IKILL_SHARER__RD_OWNER",
            "CAST_OUT__FLUSH_WD",                   "IKILL_SHARER__RD_OWN_OWNER",
            "CAST_OUT__FLUSH_WO_DATA",              "IORD_HOME__CAST_OUT",
            "CAST_OUT__IKILL_HOME",                 "IORD_HOME__DKILL_HOME",
            "CAST_OUT__IORD_HOME",                  "IORD_HOME__FLUSH_WD",
            "CAST_OUT__IRD_HOME",                   "IORD_HOME__FLUSH_WO_DATA",
            "CAST_OUT__RD_HOME",                    "IORD_HOME__IKILL_HOME",
            "CAST_OUT__RD_OWN_HOME",                "IORD_HOME__IORD_HOME",
            "DKILL_HOME__CAST_OUT",                 "IORD_HOME__IRD_HOME",
            "DKILL_HOME__DKILL_HOME",               "IORD_HOME__RD_HOME",
            "DKILL_HOME__DKILL_SHARER",             "IORD_HOME__RD_OWN_HOME",
            "DKILL_HOME__FLUSH_WD",                 "IO_RD_OWNER__CAST_OUT",
            "DKILL_HOME__FLUSH_WO_DATA",            "IO_RD_OWNER__DKILL_SHARER",
            "DKILL_HOME__IKILL_HOME",               "IO_RD_OWNER__IKILL_SHARER",
            "DKILL_HOME__IORD_HOME",                "IO_RD_OWNER__IO_RD_OWNER",
            "DKILL_HOME__IRD_HOME",                 "IO_RD_OWNER__RD_OWNER",
            "DKILL_HOME__RD_HOME",                  "IO_RD_OWNER__RD_OWN_OWNER",
            "DKILL_HOME__RD_OWN_HOME",              "IRD_HOME__CAST_OUT",
            "DKILL_SHARER__CAST_OUT",               "IRD_HOME__DKILL_HOME",
            "DKILL_SHARER__DKILL_SHARER",           "IRD_HOME__FLUSH_WD",
            "DKILL_SHARER__IKILL_SHARER",           "IRD_HOME__FLUSH_WO_DATA",
            "DKILL_SHARER__IO_RD_OWNER",            "IRD_HOME__IKILL_HOME",
            "DKILL_SHARER__RD_OWNER",               "IRD_HOME__IORD_HOME",
            "DKILL_SHARER__RD_OWN_OWNER",           "IRD_HOME__IRD_HOME",
            "FLUSH_WD__CAST_OUT",                   "IRD_HOME__RD_HOME",
            "FLUSH_WD__DKILL_HOME",                 "IRD_HOME__RD_OWN_HOME",
            "FLUSH_WD__DKILL_SHARER",               "RD_HOME__CAST_OUT",
            "FLUSH_WD__FLUSH_WD",                   "RD_HOME__DKILL_HOME",
            "FLUSH_WD__FLUSH_WO_DATA",              "RD_HOME__FLUSH_WD",
            "FLUSH_WD__IKILL_HOME",                 "RD_HOME__FLUSH_WO_DATA",
            "FLUSH_WD__IORD_HOME",                  "RD_HOME__IKILL_HOME",
            "FLUSH_WD__IRD_HOME",                   "RD_HOME__IORD_HOME",
            "FLUSH_WD__RD_HOME",                    "RD_HOME__IRD_HOME",
            "FLUSH_WD__RD_OWN_HOME",                "RD_HOME__RD_HOME",
            "FLUSH_WO_DATA__CAST_OUT",              "RD_HOME__RD_OWN_HOME",
            "FLUSH_WO_DATA__DKILL_HOME",            "RD_OWNER__DKILL_SHARER",
            "FLUSH_WO_DATA__DKILL_SHARER",          "RD_OWNER__IKILL_SHARER",
            "FLUSH_WO_DATA__FLUSH_WD",              "RD_OWNER__IO_RD_OWNER",
            "FLUSH_WO_DATA__FLUSH_WO_DATA",         "RD_OWNER__RD_OWNER",
            "FLUSH_WO_DATA__IKILL_HOME",            "RD_OWNER__RD_OWN_OWNER",
            "FLUSH_WO_DATA__IORD_HOME",             "RD_OWN_HOME__CAST_OUT",
            "FLUSH_WO_DATA__IRD_HOME",              "RD_OWN_HOME__DKILL_HOME",
            "FLUSH_WO_DATA__RD_HOME",               "RD_OWN_HOME__DKILL_SHARER",
            "FLUSH_WO_DATA__RD_OWN_HOME",           "RD_OWN_HOME__IKILL_HOME",
            "IKILL_HOME__DKILL_HOME",               "RD_OWN_HOME__IORD_HOME",
            "IKILL_HOME__FLUSH_WD",                 "RD_OWN_HOME__IRD_HOME",
            "IKILL_HOME__FLUSH_WO_DATA",            "RD_OWN_HOME__RD_HOME",
            "IKILL_HOME__IKILL_HOME",               "RD_OWN_HOME__RD_OWN_HOME",
            "IKILL_HOME__IORD_HOME",                "RD_OWN_OWNER__DKILL_SHARER",
            "IKILL_HOME__IRD_HOME",                 "RD_OWN_OWNER__IKILL_SHARER",
            "IKILL_HOME__RD_HOME",                  "RD_OWN_OWNER__IO_RD_OWNER",
            "IKILL_HOME__RD_OWN_HOME",              "RD_OWN_OWNER__RD_OWNER",
            "IKILL_SHARER__DKILL_SHARER",           "RD_OWN_OWNER__RD_OWN_OWNER":
            begin // {
              mon_trans.trans_status = STS_ERROR;
              `uvm_info("SRIO_LL_PROTOCOL_CHECKER:gsm_chk",  
              $sformatf("GSM out_in_gsm_req %s", out_in_gsm_req),UVM_LOW)
            end  // }
            "FLUSH_WD__IO_RD_OWNER",                "IORD_HOME__IO_RD_OWNER",
            "FLUSH_WD__RD_OWNER",                   "IORD_HOME__RD_OWNER",
            "FLUSH_WD__RD_OWN_OWNER",               "IORD_HOME__RD_OWN_OWNER",
            "FLUSH_WO_DATA__IO_RD_OWNER",           "RD_HOME__IO_RD_OWNER",
            "FLUSH_WO_DATA__RD_OWNER",              "RD_HOME__RD_OWNER",
            "FLUSH_WO_DATA__RD_OWN_OWNER",          "RD_HOME__RD_OWN_OWNER":
            begin // {
              mon_trans.trans_status = STS_NOT_OWNER;
              `uvm_info("SRIO_LL_PROTOCOL_CHECKER:gsm_chk",  
              $sformatf("GSM out_in_gsm_req %s", out_in_gsm_req),UVM_LOW)
            end  // }
            "CAST_OUT__IO_RD_OWNER",                "IO_RD_OWNER__RD_HOME",
            "CAST_OUT__RD_OWNER",                   "IO_RD_OWNER__RD_OWN_HOME",
            "CAST_OUT__RD_OWN_OWNER",               "RD_OWNER__DKILL_HOME",
            "DKILL_SHARER__DKILL_HOME",             "RD_OWNER__FLUSH_WD",
            "DKILL_SHARER__FLUSH_WD",               "RD_OWNER__FLUSH_WO_DATA",
            "DKILL_SHARER__FLUSH_WO_DATA",          "RD_OWNER__IORD_HOME",
            "DKILL_SHARER__IORD_HOME",              "RD_OWNER__IRD_HOME",
            "DKILL_SHARER__IRD_HOME",               "RD_OWNER__RD_HOME",
            "DKILL_SHARER__RD_HOME",                "RD_OWNER__RD_OWN_HOME",
            "DKILL_SHARER__RD_OWN_HOME",            "RD_OWN_OWNER__DKILL_HOME",
            "IKILL_SHARER__IORD_HOME",              "RD_OWN_OWNER__FLUSH_WD",
            "IO_RD_OWNER__DKILL_HOME",              "RD_OWN_OWNER__FLUSH_WO_DATA",
            "IO_RD_OWNER__FLUSH_WD",                "RD_OWN_OWNER__IORD_HOME",
            "IO_RD_OWNER__FLUSH_WO_DATA",           "RD_OWN_OWNER__IRD_HOME",
            "IO_RD_OWNER__IORD_HOME",               "RD_OWN_OWNER__RD_HOME",
            "IO_RD_OWNER__IRD_HOME",                "RD_OWN_OWNER__RD_OWN_HOME":
            begin // {
              mon_trans.trans_status = STS_RETRY;
              `uvm_info("SRIO_LL_PROTOCOL_CHECKER:gsm_chk",  
              $sformatf("GSM out_in_gsm_req %s", out_in_gsm_req),UVM_LOW)
            end  // }
             
            default: 
            begin // { 
              `uvm_info("GSM_CHECK",("out_in_gsm_req does not exist"),UVM_LOW);
            end  // }
             
          endcase  // }
        end // }
      end // }
      else if (outstanding_gsm_req == "NULL")
      begin // { 
        if ((incoming_gsm_req != "TLBIE") && (incoming_gsm_req != "TLBSYNC"))
        begin // { 
          outstanding_gsm_req = {((ftype == 1) ? ttype1.name : 
                                 ((ftype == 2) ? ttype2.name : ttype5.name))};  
          `uvm_info("SRIO_LL_PROTOCOL_CHECKER:gsm_chk",  
          $sformatf("GSM outstanding_gsm_req %s", outstanding_gsm_req),UVM_LOW)
          outstanding_gsm_req_tid = index; 
        end // }
        else
        begin // {
          outstanding_gsm_req = "NULL"; 
        end // } 
      end // }
    end // }
  end // }

  //  packets
  if (ato_pkt)  
  begin // {  
  end // }

  // Response ttype prediction
  if (ftype == TYPE11)
  begin // {
    mon_trans.ttype = MSG_RES;
    mon_trans.msg_type = mseg;
  end // }
  else if (reqd_res_with_dp)
  begin // {
    mon_trans.ttype = RES_WITH_DP;
  end // }
  else 
  begin // {
    mon_trans.ttype = RES_WO_DP;
  end // }

  if (ftype == TYPE8) // Maintenance packet
  begin // {
    mon_trans.hop_count = 8'hFF;
    // MAINT_RD_REQ, MAINT_WR_REQ, MAINT_RD_RES, MAINT_WR_RES, MAINT_PORT_WR_REQ
    if (ttype8 == MAINT_RD_REQ)
    begin // {
      mon_trans.ttype = 2; // MAINT_RD_RES;
    end // }
    if (ttype8 == MAINT_WR_REQ)
    begin // {
      mon_trans.ttype = 3; //MAINT_WR_RES;
    end // }
  end // }
  mon_trans.ll_pkt_type = ll_pkt_type;

  resp_track_array_rpg[index] = 0;
  exp_resp_array_rpg[index] = mon_trans; // push to expected response array
  
  if (drop_packet == 0) 
  begin // {
    if (mon_type) 
    begin // {
   `ifdef VCS_ASS_ARR_FIX
        foreach(exp_resp_array_rpg[copy_index]) `TX_EXP_RESP_ARRAY[copy_index]   = exp_resp_array_rpg[copy_index]; 
        foreach(`TX_EXP_RESP_ARRAY[copy_index])
          if (exp_resp_array_rpg.exists(copy_index) == 0) `TX_EXP_RESP_ARRAY.delete(copy_index);
        
        foreach(resp_track_array_rpg[copy_index]) `TX_RESP_TRACK_ARRAY[copy_index] = resp_track_array_rpg[copy_index]; 
        foreach(`TX_RESP_TRACK_ARRAY[copy_index])
          if (resp_track_array_rpg.exists(copy_index) == 0) `TX_RESP_TRACK_ARRAY.delete(copy_index);
   `else
      `TX_EXP_RESP_ARRAY   = exp_resp_array_rpg; 
      `TX_RESP_TRACK_ARRAY = resp_track_array_rpg; 
    `endif
    end // }
    else 
    begin // { 
    `ifdef VCS_ASS_ARR_FIX
        foreach(exp_resp_array_rpg[copy_index]) `RX_EXP_RESP_ARRAY[copy_index]   = exp_resp_array_rpg[copy_index]; 
        foreach(`RX_EXP_RESP_ARRAY[copy_index])
          if (exp_resp_array_rpg.exists(copy_index) == 0) `RX_EXP_RESP_ARRAY.delete(copy_index);
        
        foreach(resp_track_array_rpg[copy_index]) `RX_RESP_TRACK_ARRAY[copy_index] = resp_track_array_rpg[copy_index]; 
        foreach(`RX_RESP_TRACK_ARRAY[copy_index])
          if (resp_track_array_rpg.exists(copy_index) == 0) `RX_RESP_TRACK_ARRAY.delete(copy_index);
    `else
      `RX_EXP_RESP_ARRAY   = exp_resp_array_rpg; 
      `RX_RESP_TRACK_ARRAY = resp_track_array_rpg; 
    `endif
    end // }
  end // }

endfunction: resp_pkt_gen 

////////////////////////////////////////////////////////////////////////////////
/// Name: zero_dpl_chk \n 
/// Description: Function to check Null Data Payload \n
/// zero_dpl_chk
////////////////////////////////////////////////////////////////////////////////

function void srio_ll_txrx_monitor::zero_dpl_chk();
  if (pkt.payload.size() > 0)
  begin // {  
    `uvm_error("SRIO_LL_PROTOCOL_CHECKER:PAYLOAD_EXIST_ERR", 
    $sformatf("Part1-Section4.1.5: TID_%0h Type_%0h h Unexpected DPL in the packet",
    index[7:0], pkt.ftype))
    ll_pass_sts = 0;         
    LTLED_CSR[4] = 1;
    err_type = PAYLOAD_EXIST_ERR;
  end // } 
endfunction : zero_dpl_chk

////////////////////////////////////////////////////////////////////////////////
/// Name: reser_fld_chk \n 
/// Description: Function to check Zero value in Reserved fields \n
/// reser_fld_chk
////////////////////////////////////////////////////////////////////////////////

function void srio_ll_txrx_monitor::reser_fld_chk();
  bit [4:0] wdptr_readsize;
  if ((pkt.ftype == TYPE8) && (ttype8 == MAINT_PORT_WR_REQ))
  begin // {
    if (pkt.SrcTID != 0)
    begin // {
      `uvm_error("SRIO_LL_PROTOCOL_CHECKER:NONZERO_RESERVED_FLD_ERR", 
      $sformatf("Part1-Section4.1.10: TID_%0h h %s with non_zero SrcTID. Act: %0h",
      pkt.SrcTID, ttype8.name, pkt.SrcTID))
      err_type = NONZERO_RESERVED_FLD_ERR;
    end // }

    if (pkt.config_offset != 0)
    begin // {
      `uvm_error("SRIO_LL_PROTOCOL_CHECKER:NONZERO_RESERVED_FLD_ERR", 
      $sformatf("Part1-Section4.1.10: TID_%0h h %s with non_zero config_offset. Act: %0h", 
      pkt.SrcTID, ttype8.name, pkt.config_offset))
      err_type = NONZERO_RESERVED_FLD_ERR;
    end // }
  end // }

  if (gsm_pkt)
  begin // {
    if ((ttype2 == DKILL_HOME)  || (ttype2 == IKILL_HOME)     || 
        (ttype2 == TLBIE)       || (ttype2 == FLUSH_WO_DATA)  ||
        (ttype2 == IKILL_SHARER)|| (ttype2 == DKILL_SHARER)   || 
        (ttype2 == TLBSYNC))  
    begin // {
      wdptr_readsize = {pkt.wdptr, pkt.rdsize};
      if (wdptr_readsize != 0) 
      begin // { 
        `uvm_warning("SRIO_LL_PROTOCOL_CHECKER:reser_fld_chk", 
        $sformatf("SpecRef:Part5-Section4.2.6: TID_%0h \
        %s with non-zero wdptr: %0h h & rdsize: %0h h", 
        index[7:0],ttype2.name, pkt.wdptr, pkt.rdsize)) 
      end // }  

      if (ttype2 == TLBSYNC)  
      begin // {
        if (pkt.xamsbs != 0)
        begin // {
          `uvm_warning("SRIO_LL_PROTOCOL_CHECKER:reser_fld_chk", 
          $sformatf("SpecRef:Part5-Section4.2.6: TID_%0h \
          %s with non-zero xamsbs: %0h hd",index[7:0], ttype2.name, pkt.xamsbs)) 
        end // } 
        if (pkt.address != 0)
        begin // {
          `uvm_warning("SRIO_LL_PROTOCOL_CHECKER:reser_fld_chk", 
          $sformatf("SpecRef:Part5-Section4.2.6: TID_%0h \
          %s with non-zero address: %0h hd",index[7:0], ttype2.name, pkt.address)) 
        end // }  
      end // }  
    end // }  
  end // }

endfunction : reser_fld_chk

////////////////////////////////////////////////////////////////////////////////
/// Name: ds_assembly_chk \n 
/// Description: Function to check DS Packet Protocol \n
/// ds_assembly_chk
////////////////////////////////////////////////////////////////////////////////

function void srio_ll_txrx_monitor::ds_assembly_chk();

  bit odd;
  bit pad;
  bit [71:0] index_dac;
  bit [2:0]  ds_flowid;
  bit [2:0]  granted_flowid;
  bit        ds_allowed;
  bit [63:0] lfc_sindex;
  bit [63:0] lfc_dindex;
  bit [31:0] destid;
  bit [7:0]  cos1;
  bit [15:0] streamid;
  bit [3:0]  tmmode_r;
  bit        credit_mode;
  int        mtu_bytes;
  int        pdulength_bytes;
    bit [63:0]          copy_index;
    bit [55:0]          credit_copy_index;

  srio_ll_lfc_assembly tx_lfc_array_dac       [bit [63:0]];
  srio_ll_lfc_assembly rx_lfc_array_dac       [bit [63:0]];
  int                  ds_tm_credit_array_dac [bit [55:0]];
  destid   = pkt.DestinationID; 
  streamid = pkt.streamID; 
  cos1     = pkt.cos; 

  tx_lfc_array_dac.delete;
  rx_lfc_array_dac.delete;
  ds_tm_credit_array_dac.delete;

  ds_assembly = new;
  index_dac = {pkt.SourceID, pkt.DestinationID, pkt.cos};

  ds_flowid  = {pkt.prio,pkt.crf}; 
  lfc_sindex = {pkt.SourceID,pkt.DestinationID};
  lfc_dindex = {pkt.DestinationID,pkt.SourceID};
  ds_allowed = 1;

  mtu  = ll_reg_model.Data_Streaming_Logical_Layer_Control_CSR.MTU.get();
  regcontent = {24'h0,mtu};
  reg_content_reverse();
  mtu = rev_regcontent[31:24];

  `uvm_info("SRIO_LL_PROTOCOL_CHECKER:reg_chk", 
  $sformatf("TID_%0h MTU programmed: %0h h;",index[7:0], mtu), UVM_LOW)

  if ((mtu < 8) || (mtu > 64)) 
  begin // {
    `uvm_error("SRIO_LL_PROTOCOL_CHECKER:REG_CONFIG_ERR", 
    $sformatf("SpecRef:Part10-Section5.6.1: TID_%0h \
    Reserved MTU is programmed in the register: %0h h;",index[7:0], mtu))

    if (mtu < 8) mtu = 8; 
    else         mtu = 64; 

    `uvm_info("SRIO_LL_PROTOCOL_CHECKER:reg_chk", 
    $sformatf("SpecRef:Part10-Section5.6.1: TID_%0h \
    Default MTU considered for testing: %0h h;",index[7:0], mtu), UVM_LOW)
  end //}

  if (mon_type) 
  begin // {
    `ifdef VCS_ASS_ARR_FIX
      foreach (`TX_LFC_ARRAY[copy_index]) tx_lfc_array_dac[copy_index]        = `TX_LFC_ARRAY[copy_index]; 
      foreach(`RX_LFC_ARRAY[copy_index]) rx_lfc_array_dac[copy_index]        = `RX_LFC_ARRAY[copy_index]; 
      foreach(`TX_DS_TM_CREDIT_ARRAY[credit_copy_index]) ds_tm_credit_array_dac[credit_copy_index]  = `TX_DS_TM_CREDIT_ARRAY[credit_copy_index];
    `else
    tx_lfc_array_dac        = `TX_LFC_ARRAY; 
    rx_lfc_array_dac        = `RX_LFC_ARRAY; 
    ds_tm_credit_array_dac  = `TX_DS_TM_CREDIT_ARRAY;
    `endif
  end // }
  else 
  begin // {
    `ifdef VCS_ASS_ARR_FIX
      foreach(`RX_LFC_ARRAY[copy_index]) tx_lfc_array_dac[copy_index]        = `RX_LFC_ARRAY[copy_index]; 
      foreach(`TX_LFC_ARRAY[copy_index]) rx_lfc_array_dac[copy_index]        = `TX_LFC_ARRAY[copy_index]; 
      foreach(`RX_DS_TM_CREDIT_ARRAY[credit_copy_index]) ds_tm_credit_array_dac[credit_copy_index]  = `TX_DS_TM_CREDIT_ARRAY[credit_copy_index];
    `else
    tx_lfc_array_dac        = `RX_LFC_ARRAY; 
    rx_lfc_array_dac        = `TX_LFC_ARRAY; 
    ds_tm_credit_array_dac  = `RX_DS_TM_CREDIT_ARRAY;
   `endif
  end // }

  mtu_bytes = mtu * 4; // mtu * 4 -> mtu in bytes

  if (flow_arb_support_self && flow_arb_support_lp)
  begin // {
    if (tx_lfc_array_dac.exists(lfc_dindex))
    begin // {
      if (rx_lfc_array_dac.exists(lfc_sindex))
      begin // {
        if(((rx_lfc_array_dac[lfc_sindex].xon_pdu_timer0 > 0) && 
            (ds_flowid <= tx_lfc_array_dac[lfc_dindex].req0_flowid[2:0])) ||  
           ((rx_lfc_array_dac[lfc_sindex].xon_pdu_timer1 > 0) && 
             (ds_flowid <= tx_lfc_array_dac[lfc_dindex].req1_flowid[2:0])))
        begin // {                      
          `uvm_info("SRIO_LL_PROTOCOL_CHECKER:ds_assembly_chk", 
          $sformatf("TID_%0h DS: valid pdu", index[7:0]),UVM_LOW)
        end //}
        else
        begin // {                      
          ds_allowed = 0;
          if ((rx_lfc_array_dac[lfc_sindex].xon_pdu_timer0 > 0) || 
              (rx_lfc_array_dac[lfc_sindex].xon_pdu_timer1 > 0))  
          begin // {                      
            if (rx_lfc_array_dac[lfc_sindex].xon_pdu_timer0 > 0)
            begin // {                      
              granted_flowid = tx_lfc_array_dac[lfc_dindex].req0_flowid[2:0];
            end //} 
            else
            begin // {                      
              granted_flowid = tx_lfc_array_dac[lfc_dindex].req1_flowid[2:0];
            end //}
            `uvm_error("SRIO_LL_PROTOCOL_CHECKER:TM_BLOCKED_DS_ERR", 
            $sformatf("SpecRef:Part9-Section2.2: TID_%0h DS packet ignored; \
            DS with unpermitted/blocked Flow. Allowed Prio_crf: %0h h, Act: %0h h",
            index[7:0],granted_flowid, ds_flowid))
            err_type = TM_BLOCKED_DS_ERR;
          end //}
          else
          begin // {                      
            `uvm_error("SRIO_LL_PROTOCOL_CHECKER:TM_BLOCKED_DS_ERR", 
            $sformatf("SpecRef:Part9-Section2.2: TID_%0h DS packet ignored;  \
            DS without XON;", pkt.SrcTID))
            err_type = TM_BLOCKED_DS_ERR;
          end //} 
        end //}
      end //}
      else
      begin // {                      
        ds_allowed = 0;
        `uvm_error("SRIO_LL_PROTOCOL_CHECKER:TM_BLOCKED_DS_ERR", 
        $sformatf("SpecRef:Part9-Section2.2: TID_%0h DS packet ignored; \
        DS without XON", index[7:0]))
        err_type = TM_BLOCKED_DS_ERR;
      end //}
    end //}
    else
    begin // {                      
      ds_allowed = 0;
      `uvm_error("SRIO_LL_PROTOCOL_CHECKER:TM_BLOCKED_DS_ERR", 
      $sformatf("SpecRef:Part9-Section2.2: TID_%0h \
      DS without REQUEST-XON Handshake; Packet is ignored", index[7:0]))
      err_type = TM_BLOCKED_DS_ERR;
    end //}
  end //}
 
  if(ds_allowed)
  begin // {
    // Check for credit mode enable
    tmmode_r = ll_reg_model.Data_Streaming_Logical_Layer_Control_CSR.TM_Mode.get();
    regcontent = {28'h0,tmmode_r};
    reg_content_reverse();
    tmmode_r = rev_regcontent[31:28];

    credit_mode = ((tmmode_r == 4'b0011) || (tmmode_r == 4'b0100)) ? 1 : 0;

    if((tmmode_r != 4'b0000) && 
       (tmmode_r != 4'b0001) && 
       (tmmode_r != 4'b0010) && 
       (tmmode_r != 4'b0011) &&
       (tmmode_r != 4'b0100))
    begin // {
      `uvm_error("SRIO_LL_PROTOCOL_CHECKER:REG_CONFIG_ERR", 
      $sformatf("SpecRef:Part10-Section5.6.1: TID_%0h \
      Undefined/Reserved TM mode configured. Valid Combinations: \
      0b0000, 0b0001, 0b0010, 0b0011, 0b0100; Act: %0h h", index[7:0],tmmode_r))
    end // }

    // <TODO> Credit check will be added later
    //if(credit_mode)
    //begin // {
    //  if (ds_tm_credit_array_dac.exists({destid,cos1,streamid}) && 
    //     (ds_tm_credit_array_dac[{destid,cos1,streamid}] > 0))
    //  begin // {
    //    ds_tm_credit_array_dac[{destid,cos1,streamid}] = 
    //    ds_tm_credit_array_dac[{destid,cos1,streamid}] - 1;
    //  end // }
    //  else 
    //  begin // {
    //    ds_allowed = 0;
    //    `uvm_error("SRIO_LL_PROTOCOL_CHECKER:REG_CONFIG_ERR", 
    //    "Received DS packet where there is no credit available")
    //  end // }
    //end // }
  end // }

  if(ds_allowed)
  begin // {                      
    if (((ds_array.exists(index_dac))      && pkt.S == 1)  ||
        ((ds_array.exists(index_dac) == 0) && pkt.S == 0))
    begin // {
      if (pkt.S)
      begin // {
        ll_pass_sts = 0;         
        `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DS_SOP_ERR", 
        $sformatf("SpecRef:Part10-Section3.2.5: TID_%0h \
        Start Segment received in a opened context", index[7:0]))
        LTLED_CSR[11] = 1; 
        err_type = DS_SOP_ERR;
      end // }
      else 
      begin // {
        if (pkt.E == 0)
        begin // {
          `uvm_error("SRIO_LL_PROTOCOL_CHECKER:MISSING_DS_CONTEXT_ERR", 
          $sformatf("SpecRef:Part10-Section3.2.5: TID_%0h \
          Continuation seg received in a closed context", index[7:0]))
          ll_pass_sts = 0;            
          LTLED_CSR[10] = 1; 
          err_type = MISSING_DS_CONTEXT_ERR;
        end // } 
        else
        begin // {
          `uvm_error("SRIO_LL_PROTOCOL_CHECKER:MISSING_DS_CONTEXT_ERR", 
          $sformatf("SpecRef:Part10-Section3.2.5: TID_%0h \
          End seg received in a closed context", index[7:0]))
          ll_pass_sts = 0;            
          LTLED_CSR[10] = 1; 
          err_type = MISSING_DS_CONTEXT_ERR;
        end // } 
      end // } 
    end // } 
    else if (((ds_array.exists(index_dac))      && pkt.S == 0)  ||
             ((ds_array.exists(index_dac) == 0) && pkt.S == 1))
    begin // {
      if (pkt.payload.size() > mtu_bytes)
      begin // {
        `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DS_MTU_ERR", 
        $sformatf("SpecRef:Part10-Section3.2.5: TID_%0h \
        Long data streaming segment", index[7:0]))
        ll_pass_sts = 0;            
        LTLED_CSR[12] = 1; 
        err_type = DS_MTU_ERR;
      end // }

      if ((pkt.payload.size() % 2) == 1)
      begin // { 
        `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DS_PDU_ERR", 
        $sformatf("SpecRef:Part10-Section4.2. TID_%0h \
        DPL Length not a multiple of Half DW", index[7:0]))
        err_type = DS_PDU_ERR;
      end // }

      if (pkt.S)       
      begin // { 

        if (flow_arb_support_self && flow_arb_support_lp)
        begin // {
          if((rx_lfc_array_dac[lfc_sindex].xoff_rel_timer0 > 0) || 
             (rx_lfc_array_dac[lfc_sindex].xoff_rel_timer1 > 0)) 
          begin // {
            `uvm_warning("SRIO_LL_PROTOCOL_CHECKER:ds_assembly_chk", 
            $sformatf("SpecRef:Part9-Section2.2: TID_%0h \
            New PDU even after XOFF has been received.", pkt.SrcTID))
          end  // }
        end  // }

        // Max active pdu context is given by seg_support
        if (ds_array.size() > seg_support_bytes) 
        begin // {
          `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DSSEG_ERR", 
          $sformatf("TID_%0h Number of active segmentation contexts exceeded \
          the SegSupport; DS packet is discareded; Seg_support: %0h h",
          index[7:0],seg_support_bytes))
          ll_pass_sts = 0;            
          err_type = DSSEG_ERR;
        end // }
        else
        begin // {
          ds_assembly.flowID           = pkt.flowID;
          ds_assembly.SourceID         = pkt.SourceID;
          ds_assembly.length_received  = pkt.payload.size();
          ds_assembly.seg_received     = 1;
          ds_array[index_dac] = ds_assembly;
          if (flow_arb_support_self && flow_arb_support_lp)
          begin // {
            tx_lfc_array_dac[lfc_dindex].pdu_flowid = flow_id; 
            tx_lfc_array_dac[lfc_dindex].pdu_started = 1; 
            tx_lfc_array_dac[lfc_dindex].pdu_completed = 0; 
          end // }
          `uvm_info("SRIO_LL_PROTOCOL_CHECKER:ds_assembly_chk", 
          $sformatf("TID_%0h Number of Active Segmentation context: %0h h,\
          Seg_Support: %0h h", index[7:0],ds_array.size, seg_support_bytes), UVM_LOW)
        end // }
      end // }
      else 
      begin // {
        ds_array[index_dac].length_received  = ds_array[index_dac].length_received + pkt.payload.size();
        ds_array[index_dac].seg_received     = ds_array[index_dac].seg_received    + 1;

        if (ds_array[index_dac].SourceID != pkt.SourceID) 
        begin // {
          `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DSSEG_ERR", 
          $sformatf("SpecRef:Part10-Section2.4: TID_%0h Start Segment's SourceID \
          mismatches with this segment's SourceID; Exp: %0h, Act: %0h", 
          index[7:0],ds_array[index_dac].SourceID, pkt.SourceID))
          ll_pass_sts = 0;            
          err_type = DSSEG_ERR;
        end // } 
      end // }
 
      if (pkt.E) 
      begin // {
        
        if (flow_arb_support_self && flow_arb_support_lp)
        begin // {
          tx_lfc_array_dac[lfc_dindex].pdu_completed = 1;
          if ((tx_lfc_array_dac[lfc_dindex].req_type0 == 0)  && 
              (tx_lfc_array_dac[lfc_dindex].req_type1 == 0))  
          begin // {
            if (tx_lfc_array_dac[lfc_dindex].req_xonxoff_timer1 > 0) 
              tx_lfc_array_dac[lfc_dindex].req_xonxoff_timer1 = 0;   
            else
              tx_lfc_array_dac[lfc_dindex].req_xonxoff_timer0 = 0; 
          end  // }
        end //}

        if ((pkt.pdulength == 0) && (pkt.payload.size() == 0)) 
        begin // {
          `uvm_info("SRIO_LL_PROTOCOL_CHECKER:ds_assembly_chk", 
          $sformatf("SpecRef:Part10-Section3.2.5: TID_%0h \
          End segment to abort the PDU;", pkt.SrcTID), UVM_LOW)
        end // }
        else 
        begin // {

          if (pkt.pdulength > max_pdu_bytes)
          begin // {
            `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DS_PDU_ERR", 
            $sformatf("SpecRef:Part10-Section3.2.5: TID_%0h \
            PDU Length (%0h h) > Max PDU (%0h h)",
            index[7:0],pkt.pdulength, max_pdu_bytes))
            ll_pass_sts = 0;            
            err_type = DS_PDU_ERR;
          end // }

          if (pkt.S == 0)
          begin // {
            odd = ((((pkt.payload.size() - pkt.P) % 4) == 1 ) || 
                   (((pkt.payload.size() - pkt.P) % 4) == 2 )) ? 1 : 0;
            pad =  (pkt.pdulength % 2) ? 1 : 0;

            pdulength_bytes = pkt.pdulength;
            if (pkt.pdulength == 0)
            begin // {
              pdulength_bytes = 16'hFFFF + 1;  // 64KB data
            end // }  
            if ((ds_array[index_dac].length_received - pkt.P) != pdulength_bytes)
            begin // {
              `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DS_PDU_ERR", 
              $sformatf("SpecRef:Part10-Section3.2.5: TID_%0h \
              Data streaming PDU length error; Exp: %0h h, Act pdu_length field: %0h h", 
              index[7:0],ds_array[index_dac].length_received, pdulength_bytes))
              ll_pass_sts = 0;            
              LTLED_CSR[14] = 1; 
              err_type = DS_PDU_ERR;
            end // }
          end // }
          else 
          begin // {
            odd = ((((pkt.payload.size() - pkt.P) % 4) == 1 ) || 
                   (((pkt.payload.size() - pkt.P) % 4) == 2 )) ? 1 : 0;
            pad =   ((pkt.payload.size() - pkt.P) % 2) ? 1 : 0;
          end // }

          if (pkt.O != odd)
          begin // {
            `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DS_ODD_ERR", 
            $sformatf("SpecRef:Part10-Section3.2.5: TID_%0h Error in Odd field; \
            Exp: %0h h, Act: %0h h", index[7:0],odd, pkt.O))
            ll_pass_sts = 0;            
            err_type = DS_ODD_ERR;
          end // }
          if (pkt.P != pad)
          begin // {
            `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DS_PAD_ERR", 
            $sformatf("SpecRef:Part10-Section3.2.5: TID_%0h Error in pad field; \
            Exp: %0h h; Act: %0h h", index[7:0],pad, pkt.P))
            ll_pass_sts = 0;            
            err_type = DS_PAD_ERR;
          end // }
        end // }
      end // }
      else
      begin // {
        if (pkt.payload.size() < mtu_bytes)       
        begin // {
          `uvm_error("SRIO_LL_PROTOCOL_CHECKER:DS_MTU_ERR",
          $sformatf("SpecRef:Part10-Section3.2.5: TID_%0h \
          DPL < MTU in a non-end segment; DPL Exp: %0h h; Act: %0h h", 
          index[7:0],mtu_bytes, pkt.payload.size()))
          ll_pass_sts = 0;             
          LTLED_CSR[13] = 1; 
          err_type = DS_MTU_ERR;
        end // }
      end // }
    end // }
  end // }

  // Check the message completeness
  if ((ll_pass_sts == 0) || pkt.E)
  begin // {
    if (ds_array.exists(index_dac))
      ds_array.delete(index_dac);
  end // }

  if (flow_arb_support_self && flow_arb_support_lp)
  begin // {
    if (mon_type) 
    begin // {
      `TX_LFC_ARRAY          = tx_lfc_array_dac; 
      `TX_DS_TM_CREDIT_ARRAY = ds_tm_credit_array_dac;
    end // }
    else 
    begin // { 
      `RX_LFC_ARRAY          = tx_lfc_array_dac; 
      `RX_DS_TM_CREDIT_ARRAY = ds_tm_credit_array_dac;
    end // }
  end // }

endfunction : ds_assembly_chk

////////////////////////////////////////////////////////////////////////////////
/// Name: timer_track \n
/// Description: Function used to update all the LL timers once in every 1ns \n
/// timer_track
//////////////////////////////////////////////////////////////////////////////// 

task srio_ll_txrx_monitor::timer_track();

  /// @cond
  srio_trans           exp_resp_array_tt  [bit[72:0]];
  int                  resp_track_array_tt[bit[72:0]];
  srio_ll_lfc_assembly tx_lfc_array_tt    [bit[63:0]];
  srio_ll_lfc_assembly rx_lfc_array_tt    [bit[63:0]];
  int                  xoff_cnt_array_tt  [bit[70:0]];
  bit [ 8:0]           rx_last_req        [bit[72:0]]; 
  int                  req_track_array_tt [bit[72:0]]; 
  bit [63:0]           index_tt;   // {DestinationID, Source ID}
  bit [63:0]           rxindex;    // {Source ID    , Destination ID} 
  bit [72:0]           reqindex;
  bit [ 2:0]           array_limit;
  bit [ 2:0]           flow3;
  bit [ 6:0]           flowid;
  int                  orph_xoff_size;
  bit [63:0]           dindex;
  bit [70:0]           tx_orphxoff_timer_array_tt[$];
  bit [72:0]           resindex;
  bit                  seq_no;
  bit                  xon_xoff_received0;
  bit                  xon_xoff_received1;
  bit                  pdu_received0;
  bit                  pdu_received1;
  /// @endcond
  exp_resp_array_tt.delete;
  resp_track_array_tt.delete;
  tx_lfc_array_tt.delete;
  rx_lfc_array_tt.delete;
  req_track_array_tt.delete;
  tx_orphxoff_timer_array_tt.delete;
  rx_last_req.delete;
  xoff_cnt_array_tt.delete;

  wait (protocol_check_completed == 1);
  if (mon_type) 
  begin // {
    `ifdef VCS_ASS_ARR_FIX
      foreach(`TX_EXP_RESP_ARRAY[copy_index73]) exp_resp_array_tt[copy_index73]          = `TX_EXP_RESP_ARRAY[copy_index73]; 
      foreach(`TX_RESP_TRACK_ARRAY[copy_index73]) resp_track_array_tt[copy_index73]        = `TX_RESP_TRACK_ARRAY[copy_index73]; 
      foreach(`TX_LFC_ARRAY[copy_index64]) tx_lfc_array_tt[copy_index64]            = `TX_LFC_ARRAY[copy_index64]; 
      foreach(`RX_LFC_ARRAY[copy_index64]) rx_lfc_array_tt[copy_index64]            = `RX_LFC_ARRAY[copy_index64]; 
      foreach(`RX_REQ_TRACK_ARRAY[copy_index73]) req_track_array_tt[copy_index73]         = `RX_REQ_TRACK_ARRAY[copy_index73]; 
      foreach(`RX_LAST_REQ[copy_index73]) rx_last_req[copy_index73]                = `RX_LAST_REQ[copy_index73];
      tx_orphxoff_timer_array_tt = `TX_ORPHXOFF_TIMER_ARRAY;
      foreach(`TX_XOFF_CNT[copy_index71]) xoff_cnt_array_tt[copy_index71]          = `TX_XOFF_CNT[copy_index71];
    `else
    exp_resp_array_tt          = `TX_EXP_RESP_ARRAY; 
    resp_track_array_tt        = `TX_RESP_TRACK_ARRAY; 
    tx_lfc_array_tt            = `TX_LFC_ARRAY; 
    rx_lfc_array_tt            = `RX_LFC_ARRAY; 
    req_track_array_tt         = `RX_REQ_TRACK_ARRAY; 
    rx_last_req                = `RX_LAST_REQ; 
    tx_orphxoff_timer_array_tt = `TX_ORPHXOFF_TIMER_ARRAY;
    xoff_cnt_array_tt          = `TX_XOFF_CNT;
    `endif
  end // }
  else 
  begin // {
    `ifdef VCS_ASS_ARR_FIX
    foreach(`RX_EXP_RESP_ARRAY[copy_index73]) exp_resp_array_tt[copy_index73]          = `RX_EXP_RESP_ARRAY[copy_index73]; 
    foreach(`RX_RESP_TRACK_ARRAY[copy_index73]) resp_track_array_tt[copy_index73]        = `RX_RESP_TRACK_ARRAY[copy_index73]; 
    foreach(`RX_LFC_ARRAY[copy_index64]) tx_lfc_array_tt[copy_index64]            = `RX_LFC_ARRAY[copy_index64]; 
    foreach(`TX_LFC_ARRAY[copy_index64]) rx_lfc_array_tt[copy_index64]            = `TX_LFC_ARRAY[copy_index64]; 
    foreach(`TX_REQ_TRACK_ARRAY[copy_index73]) req_track_array_tt[copy_index73]         = `TX_REQ_TRACK_ARRAY[copy_index73]; 
    foreach(`TX_LAST_REQ[copy_index73]) rx_last_req[copy_index73]                = `TX_LAST_REQ[copy_index73]; 
    tx_orphxoff_timer_array_tt = `RX_ORPHXOFF_TIMER_ARRAY;
    foreach(`RX_XOFF_CNT[copy_index71]) xoff_cnt_array_tt[copy_index71]          = `RX_XOFF_CNT[copy_index71];
    `else
    exp_resp_array_tt          = `RX_EXP_RESP_ARRAY; 
    resp_track_array_tt        = `RX_RESP_TRACK_ARRAY; 
    tx_lfc_array_tt            = `RX_LFC_ARRAY; 
    rx_lfc_array_tt            = `TX_LFC_ARRAY; 
    req_track_array_tt         = `TX_REQ_TRACK_ARRAY; 
    rx_last_req                = `TX_LAST_REQ; 
    tx_orphxoff_timer_array_tt = `RX_ORPHXOFF_TIMER_ARRAY;
    xoff_cnt_array_tt          = `RX_XOFF_CNT;
    `endif
  end // }

  resp_timeout = ll_reg_model.Port_Response_Timeout_Control_CSR.timeout_value.get();
  regcontent = {8'h0,resp_timeout};
  reg_content_reverse();
  resp_timeout = rev_regcontent[31:8];

  if (tx_orphxoff_timer_array_tt.size() > 0)
  begin // {
    if (orph_xoff ==0)          
    begin // {
      orph_xoff_curr = tx_orphxoff_timer_array_tt[0];
      xoff_timer = 0;
      orph_xoff  = 1;          
    end // }
         
    if (orph_xoff_curr != tx_orphxoff_timer_array_tt[0])
    begin // {
      orph_xoff_curr = tx_orphxoff_timer_array_tt[0];
      xoff_timer = 0;
    end // }
    else
    begin // {
      if (xoff_timer < orph_xoff_timeout)
      begin // {
        xoff_timer = xoff_timer + 1;
      end // }
      else 
      begin // {
        if (xoff_cnt_array_tt.exists(orph_xoff_curr))
        begin // {
          array_limit = 6;
          flow3  = orph_xoff_curr[2:0]; // 3 Bit flowid
          dindex = orph_xoff_curr[70:7];  
          flowid  = orph_xoff_curr[6:0]; // 7 Bit flowid
          for (int d=flow3; d<=array_limit; d++) // Flow F = 101; 
          begin // {
            if (xoff_cnt_array_tt.exists({dindex,flowid}) && 
               (xoff_cnt_array_tt[{dindex,flowid}] > 0)) 
            begin // {
              xoff_cnt_array_tt[{dindex,flowid}] = xoff_cnt_array_tt[{dindex,flowid}] - 1;
              if (xoff_cnt_array_tt[{dindex,flowid}] == 0) 
              begin // {
                orph_xoff_size = tx_orphxoff_timer_array_tt.size();
                for (int a = 0; a < orph_xoff_size; a++) 
                begin // {
                  if (tx_orphxoff_timer_array_tt[a] == {dindex,flowid})
                  begin // {
                    tx_orphxoff_timer_array_tt.delete(a); 
                  end // }
                end // }
              end // }
            end // }
            flowid = flowid + 1;
          end // }
        end // }
      end // }
    end // }
  end // }

  if (req_track_array_tt.size() > 0) 
  begin // {
    if (req_track_array_tt.first(reqindex)) 
    begin // {
      do  // {
        begin // {
          if (req_track_array_tt.exists(reqindex))
          begin // {
            if (rx_last_req.exists({reqindex[72:4],4'h0}))
            begin // {
              if (reqindex == rx_last_req[{reqindex[72:4],4'h0}])
              begin // {
                req_track_array_tt[reqindex] = req_track_array_tt[reqindex] + 1;
                if (req_track_array_tt[reqindex] > resp_timeout) 
                begin // {
                  if (tout_err_reported.exists(reqindex) && 
                     (tout_err_reported[reqindex] == 0))
                  begin // {
                    `uvm_error("SRIO_LL_PROTOCOL_CHECKER:REQ_TIMEOUT_ERR", 
                    $sformatf("SpecRef:Part8-Section2.5.3: TID_%0h Msg Request timeout; \
                    Message is discarded;",reqindex[7:0]))
                    tout_err_reported[reqindex] = 1;
                    LTLED_CSR[7] = 1;
                    err_type = REQ_TIMEOUT_ERR;
                  end // }
                end // }
              end // }
              else
              begin // {
                req_track_array_tt.delete(reqindex);
                if (tout_err_reported.exists(reqindex)) 
                begin // {
                  tout_err_reported.delete(reqindex);
                end // }
              end // } 
            end // }
            else
            begin // {
              req_track_array_tt.delete(reqindex);
              if (tout_err_reported.exists(reqindex)) 
              begin // {
                tout_err_reported.delete(reqindex);
              end // }
            end // } 
          end // }
        end // } 
      while (req_track_array_tt.next(reqindex)); // }
    end // }
  end // }

  if (resp_track_array_tt.size() > 0) 
  begin // {
    if (resp_track_array_tt.first(resindex)) 
    begin // {
      do  // {
        begin // {
          if (resp_track_array_tt.exists(resindex))
          begin // {
            if (exp_resp_array_tt.exists(resindex))
            begin // {
              if (resp_track_array_tt[resindex] < resp_timeout)
              begin // {
                resp_track_array_tt[resindex] = resp_track_array_tt[resindex] + 1;
              end // } 
              else
              begin // {
                `uvm_error("SRIO_LL_PROTOCOL_CHECKER:RESP_TIMEOUT_ERR", 
                $sformatf("SpecRef:Part8-Section2.5.3: TID_%0h Response timeout;",
                resindex[7:0]))
                resp_track_array_tt.delete(resindex);
                LTLED_CSR[7] = 1;
                err_type = RESP_TIMEOUT_ERR;
              end // }
            end // }
            else
            begin // {
              resp_track_array_tt.delete(resindex);
            end // } 
          end // }
        end // } 
      while (resp_track_array_tt.next(resindex)); // }
    end // }
  end // }

  if (tx_lfc_array_tt.first(index_tt))
  begin // {
    rxindex = {index_tt[31:0], index_tt[63:32]}; // {Source ID, Destination ID}
    do // {
      begin // {     
        xon_xoff_received0 = 0;
        pdu_received0 = 0;
        // Seq_no 0
        // req_xonxoff_timer chk
        if (tx_lfc_array_tt.exists(index_tt))
        begin // {
          if (tx_lfc_array_tt[index_tt].req_xonxoff_timer0 > 0)
          begin // {
            if (rx_lfc_array_tt.exists(rxindex))
            begin // { 
              if ((rx_lfc_array_tt[rxindex].xon_pdu_timer0  > 0) ||
                  (rx_lfc_array_tt[rxindex].xoff_rel_timer0 > 0))
              begin // {
                xon_xoff_received0 = 1;
              end // }
                          
              if ((rx_lfc_array_tt[rxindex].xoff_rel_timer0 >  0) &&
                  (tx_lfc_array_tt[index_tt].pdu_started       == 0)) 
              begin // {
                tx_lfc_array_tt[index_tt].req_xonxoff_timer0 = 0;
              end // }

            end // }
            if (xon_xoff_received0 == 0)
            begin // {
              if (tx_lfc_array_tt[index_tt].req_xonxoff_timer0 < req_xonxoff_timeout)
              begin // {
                tx_lfc_array_tt[index_tt].req_xonxoff_timer0 = 
                tx_lfc_array_tt[index_tt].req_xonxoff_timer0 + 1;
              end // }
              else 
              begin // {
                `uvm_warning("SRIO_LL_PROTOCOL_CHECKER", 
                $sformatf("TID_%0h REQUEST0 did not receive XON/XOFF. \n \
                Src_ID: %0h h, Dest_ID: %0h h; Device can resend it;", 
                index[7:0],index_tt[63:32], index_tt[31:0]))
                tx_lfc_array_tt[index_tt].req_xonxoff_timer0 = 0;
              end // }
            end // }
          end // }

          if (tx_lfc_array_tt[index_tt].req_xonxoff_timer1 > 0)
          begin // {
            if (rx_lfc_array_tt.exists(rxindex))
            begin // { 
              if ((rx_lfc_array_tt[rxindex].xon_pdu_timer1  > 0) ||
                  (rx_lfc_array_tt[rxindex].xoff_rel_timer1 > 0))
              begin // {
                xon_xoff_received1 = 1;
              end // }

              if ((rx_lfc_array_tt[rxindex].xoff_rel_timer1 >  0) &&
                  (tx_lfc_array_tt[index_tt].pdu_started       == 0)) 
              begin // {
                tx_lfc_array_tt[index_tt].req_xonxoff_timer1 = 0;
              end // }
            end // }
            if (xon_xoff_received1 == 0)
            begin // {
              if (tx_lfc_array_tt[index_tt].req_xonxoff_timer1 < req_xonxoff_timeout)
              begin // {
                tx_lfc_array_tt[index_tt].req_xonxoff_timer1 = 
                tx_lfc_array_tt[index_tt].req_xonxoff_timer1 + 1;
              end // }
              else 
              begin // {
                `uvm_warning("SRIO_LL_PROTOCOL_CHECKER", 
                $sformatf("TID_%0h REQUEST1 did not receive XON/XOFF. \n \
                Src_ID: %0h h, Dest_ID: %0h h; Device can resend it;", 
                index[7:0],index_tt[63:32], index_tt[31:0]))
                tx_lfc_array_tt[index_tt].req_xonxoff_timer1 = 0;
              end // }
            end // }
          end // }

          // xon_pdu_timer chk
          if (tx_lfc_array_tt[index_tt].xon_pdu_timer0 > 0)
          begin // {
            if (rx_lfc_array_tt.exists(rxindex))
            begin // { 
              if (rx_lfc_array_tt[rxindex].pdu_started)
              begin // {
                pdu_received0 = 1;
              end // }
            end // }
            if (pdu_received0 == 0) 
            begin // {
              if (tx_lfc_array_tt[index_tt].xon_pdu_timer0 < xon_pdu_timeout)
              begin // {
                if ((tx_lfc_array_tt[index_tt].xoff_rel_timer0 > 0) &&
                    (rx_lfc_array_tt.exists(rxindex) && 
                    (rx_lfc_array_tt[rxindex].pdu_started == 0)))
                begin // {
                  tx_lfc_array_tt[index_tt].xon_pdu_timer0 = 0;
                  tx_lfc_array_tt[index_tt].xoff_rel_timer0 = 0;
                end // }
                else
                begin // {
                  tx_lfc_array_tt[index_tt].xon_pdu_timer0 = 
                  tx_lfc_array_tt[index_tt].xon_pdu_timer0 + 1;
                end // }
              end // }
              else 
              begin // {
                `uvm_warning("SRIO_LL_PROTOCOL_CHECKER", 
                $sformatf("TID_%0h xon_pdu_timeout. Resource are deallocated. \
                Src_ID: %0h h, Dest_ID: %0h h; req0_flowid: %0h h", 
                index[7:0],index_tt[63:32], index_tt[31:0], tx_lfc_array_tt[index_tt].req0_flowid))
                tx_lfc_array_tt[index_tt].xon_pdu_timer0 = 0;
              end // }
            end // }
          end // }

          if (tx_lfc_array_tt[index_tt].xon_pdu_timer1 > 0)
          begin // {
            if (rx_lfc_array_tt.exists(rxindex))
            begin // { 
              if (rx_lfc_array_tt[rxindex].pdu_started)
              begin // {
                pdu_received1 = 1;
              end // }
            end // }
            if (pdu_received1 == 0) 
            begin // {
              if (tx_lfc_array_tt[index_tt].xon_pdu_timer1 < xon_pdu_timeout)
              begin // {
                if ((tx_lfc_array_tt[index_tt].xoff_rel_timer1 > 0) &&
                    (rx_lfc_array_tt.exists(rxindex) && 
                    (rx_lfc_array_tt[rxindex].pdu_started == 0)))
                begin // {
                  tx_lfc_array_tt[index_tt].xon_pdu_timer1 = 0;
                  tx_lfc_array_tt[index_tt].xoff_rel_timer1 = 0;
                end // }
                else
                begin // {
                  tx_lfc_array_tt[index_tt].xon_pdu_timer1 = 
                  tx_lfc_array_tt[index_tt].xon_pdu_timer1 + 1;
                end // }
              end // }
              else 
              begin // {
                `uvm_warning("SRIO_LL_PROTOCOL_CHECKER", 
                $sformatf("TID_%0h xon_pdu_timeout. Resource are deallocated. \
                Src_ID: %0h h, Dest_ID: %0h h, req1_flowid: %0h h", 
                index[7:0],index_tt[63:32], index_tt[31:0], tx_lfc_array_tt[index_tt].req1_flowid)) 
                tx_lfc_array_tt[index_tt].xon_pdu_timer1 = 0;
              end // }
            end // }
          end // }

          // xoff_rel_timer chk
          if (tx_lfc_array_tt[index_tt].xoff_rel_timer0 > 0)
          begin // {
            if (rx_lfc_array_tt.exists(rxindex))
            begin // { 
              if (rx_lfc_array_tt[rxindex].rel_deall_timer0 > 0)
              begin // {
                tx_lfc_array_tt[index_tt].xoff_rel_timer0 = 0;
                tx_lfc_array_tt[index_tt].xon_pdu_timer0  = 0;
              end // }
              if (rx_lfc_array_tt[rxindex].req_xonxoff_timer0 == 0)
              begin // {
                tx_lfc_array_tt[index_tt].xoff_rel_timer0 = 0;
              end // }
            end // }
            else 
            begin // { 
              tx_lfc_array_tt[index_tt].xoff_rel_timer0 = 0;
            end // }
          end // }

          if (tx_lfc_array_tt[index_tt].xoff_rel_timer1 > 0)
          begin // {
            if (rx_lfc_array_tt.exists(rxindex))
            begin // { 
              if (rx_lfc_array_tt[rxindex].rel_deall_timer1 > 0)
              begin // {
                tx_lfc_array_tt[index_tt].xoff_rel_timer1 = 0;
                tx_lfc_array_tt[index_tt].xon_pdu_timer1  = 0;
              end // }
              if (rx_lfc_array_tt[rxindex].req_xonxoff_timer1 == 0)
              begin // {
                tx_lfc_array_tt[index_tt].xoff_rel_timer1 = 0;
              end // }
            end // }
            else 
            begin // { 
              tx_lfc_array_tt[index_tt].xoff_rel_timer1 = 0;
            end // }
          end // }

          // rel_deall_timer chk
          if (tx_lfc_array_tt[index_tt].rel_deall_timer0 > 0)
          begin // {
            `uvm_info("SRIO_LL_PROTOCOL_CHECKER", 
            $sformatf("TID_%0h Request0 is released. Src_ID: %0h h, Dest_ID: %0h h;", 
            index[7:0],index_tt[63:32], index_tt[31:0]), UVM_LOW)
            tx_lfc_array_tt[index_tt].req_xonxoff_timer0 = 0;
            tx_lfc_array_tt[index_tt].rel_deall_timer0   = 0;
          end // }

          if (tx_lfc_array_tt[index_tt].rel_deall_timer1 > 0)
          begin // {
            `uvm_info("SRIO_LL_PROTOCOL_CHECKER", 
            $sformatf("TID_%0h Request1 is released. Src_ID: %0h h, Dest_ID: %0h h;", 
            index[7:0],index_tt[63:32], index_tt[31:0]), UVM_LOW)
            tx_lfc_array_tt[index_tt].req_xonxoff_timer1 = 0;
            tx_lfc_array_tt[index_tt].rel_deall_timer1   = 0;
          end // }  
          
          if ((tx_lfc_array_tt[index_tt].req_xonxoff_timer0 == 0) &&    
              (tx_lfc_array_tt[index_tt].rel_deall_timer0   == 0) &&  
              (tx_lfc_array_tt[index_tt].xoff_rel_timer0    == 0) &&  
              (tx_lfc_array_tt[index_tt].xon_pdu_timer0     == 0) &&  
              (tx_lfc_array_tt[index_tt].req_xonxoff_timer1 == 0) &&  
              (tx_lfc_array_tt[index_tt].rel_deall_timer1   == 0) &&  
              (tx_lfc_array_tt[index_tt].xoff_rel_timer1    == 0) &&  
              (tx_lfc_array_tt[index_tt].xon_pdu_timer1     == 0))
          begin // { 
            tx_lfc_array_tt.delete(index_tt);
            single_req_pipelined = 0;
            multi_req_pipelined  = 0;
          end // }
        end // }
      end // }
    while (tx_lfc_array_tt.next(index_tt)); //}
  end // }

  if (mon_type) 
  begin // {
    `ifdef VCS_ASS_ARR_FIX
     foreach (tx_lfc_array_tt[copy_index64]) `TX_LFC_ARRAY[copy_index64]            = tx_lfc_array_tt[copy_index64];
     foreach (`TX_LFC_ARRAY[copy_index64])
       if (tx_lfc_array_tt.exists(copy_index64) == 0) `TX_LFC_ARRAY.delete(copy_index64);
     
     foreach (resp_track_array_tt[copy_index73]) `TX_RESP_TRACK_ARRAY[copy_index73]     = resp_track_array_tt[copy_index73];
     foreach (`TX_RESP_TRACK_ARRAY[copy_index73])
       if (resp_track_array_tt.exists(copy_index73) == 0) `TX_RESP_TRACK_ARRAY.delete(copy_index73);
     
     foreach (req_track_array_tt[copy_index73]) `RX_REQ_TRACK_ARRAY[copy_index73]      = req_track_array_tt[copy_index73];
     foreach (`RX_REQ_TRACK_ARRAY[copy_index73])
       if (req_track_array_tt.exists(copy_index73) == 0) `RX_REQ_TRACK_ARRAY.delete(copy_index73);
     
     `TX_ORPHXOFF_TIMER_ARRAY = tx_orphxoff_timer_array_tt;
     
     foreach (xoff_cnt_array_tt[copy_index71]) `TX_XOFF_CNT[copy_index71]             =  xoff_cnt_array_tt[copy_index71];
     foreach (`TX_XOFF_CNT[copy_index71])
       if (xoff_cnt_array_tt.exists(copy_index71) == 0) `TX_XOFF_CNT.delete(copy_index71);
    `else
    `TX_LFC_ARRAY            = tx_lfc_array_tt;
    `TX_RESP_TRACK_ARRAY     = resp_track_array_tt;
    `RX_REQ_TRACK_ARRAY      = req_track_array_tt; 
    `TX_ORPHXOFF_TIMER_ARRAY = tx_orphxoff_timer_array_tt;
    `TX_XOFF_CNT             = xoff_cnt_array_tt;
    `endif
  end // }
  else 
  begin // { 
    `ifdef VCS_ASS_ARR_FIX
     foreach (tx_lfc_array_tt[copy_index64]) `RX_LFC_ARRAY[copy_index64]            = tx_lfc_array_tt[copy_index64];
     foreach (`RX_LFC_ARRAY[copy_index64])
       if (tx_lfc_array_tt.exists(copy_index64) == 0) `RX_LFC_ARRAY.delete(copy_index64);
     
     foreach (resp_track_array_tt[copy_index73]) `RX_RESP_TRACK_ARRAY[copy_index73]     = resp_track_array_tt[copy_index73];
     foreach (`RX_RESP_TRACK_ARRAY[copy_index73])
       if (resp_track_array_tt.exists(copy_index73) == 0) `RX_RESP_TRACK_ARRAY.delete(copy_index73);
     
     foreach (req_track_array_tt[copy_index73]) `TX_REQ_TRACK_ARRAY[copy_index73]      = req_track_array_tt[copy_index73];
     foreach (`TX_REQ_TRACK_ARRAY[copy_index73])
       if (req_track_array_tt.exists(copy_index73) == 0) `TX_REQ_TRACK_ARRAY.delete(copy_index73);
     
     `RX_ORPHXOFF_TIMER_ARRAY = tx_orphxoff_timer_array_tt;
     
     foreach (xoff_cnt_array_tt[copy_index71]) `RX_XOFF_CNT[copy_index71]             =  xoff_cnt_array_tt[copy_index71];
     foreach (`RX_XOFF_CNT[copy_index71])
       if (xoff_cnt_array_tt.exists(copy_index71) == 0) `RX_XOFF_CNT.delete(copy_index71);
    `else
    `RX_LFC_ARRAY            = tx_lfc_array_tt;
    `RX_RESP_TRACK_ARRAY     = resp_track_array_tt;
    `TX_REQ_TRACK_ARRAY      = req_track_array_tt; 
    `RX_ORPHXOFF_TIMER_ARRAY = tx_orphxoff_timer_array_tt;
    `RX_XOFF_CNT             = xoff_cnt_array_tt;
    `endif
  end // }

endtask: timer_track

////////////////////////////////////////////////////////////////////////////////
/// Name: valid_flow_chk \n
/// Description: Function to check the validity of packet based on its flowid \n 
/// valid_flow_chk
//////////////////////////////////////////////////////////////////////////////// 

function void srio_ll_txrx_monitor::valid_flow_chk();

  int xoff_cnt_array_vfc[bit[70:0]]; // Xoff count
  bit [70:0] sindex_vfc;
   bit [72:0] copy_index;
   bit [70:0] cnt_copy_index;
                                
  int xoff_count;
  srio_ftype ftype;
  srio_trans exp_resp_array_vfc[bit[72:0]];
  ftype = srio_ftype'(pkt.ftype);
  exp_resp_array_vfc.delete;
  xoff_cnt_array_vfc.delete;

  if (mon_type) 
  begin // {
    `ifdef VCS_ASS_ARR_FIX
     foreach (`RX_EXP_RESP_ARRAY[copy_index]) exp_resp_array_vfc[copy_index] = `RX_EXP_RESP_ARRAY[copy_index];
     foreach (`RX_XOFF_CNT[cnt_copy_index]) xoff_cnt_array_vfc[cnt_copy_index] = `RX_XOFF_CNT[cnt_copy_index]; 
    `else
    exp_resp_array_vfc = `RX_EXP_RESP_ARRAY;
    xoff_cnt_array_vfc = `RX_XOFF_CNT; 
    `endif
  
  end // }
  else 
  begin // {
    `ifdef VCS_ASS_ARR_FIX
     foreach (`TX_EXP_RESP_ARRAY[copy_index]) exp_resp_array_vfc[copy_index] = `TX_EXP_RESP_ARRAY[copy_index];
     foreach (`TX_XOFF_CNT[cnt_copy_index]) xoff_cnt_array_vfc[cnt_copy_index] = `TX_XOFF_CNT[cnt_copy_index]; 
    `else
    exp_resp_array_vfc = `TX_EXP_RESP_ARRAY;
    xoff_cnt_array_vfc = `TX_XOFF_CNT; 
    `endif
  end // }

  if((ll_mon_env_config.multi_vc_support) && 
     (ll_mon_env_config.srio_mode == SRIO_GEN13))
  begin // { 
    `uvm_error("SRIO_LL_PROTOCOL_CHECKER:VC_ERR", 
    $sformatf("TID_%0h Multiple VC support is set to 1,\
    which is not suppoted in Gen1.3", index[7:0]))    
    err_type = VC_ERR;
  end // }

  if((pkt.vc) && ((ll_mon_env_config.multi_vc_support == 0) || 
     (ll_mon_env_config.srio_mode == SRIO_GEN13)))
  begin // {
    if(ll_mon_env_config.multi_vc_support == 0)
    begin // {
      `uvm_error("SRIO_LL_PROTOCOL_CHECKER:VC_ERR", 
      $sformatf("TID_%0h %s Packet with vc = 1, \
      where Multiple VC support is not there", index[7:0], ftype.name))    
      err_type = VC_ERR;
    end // }
    if(ll_mon_env_config.srio_mode == SRIO_GEN13)
    begin // {
      `uvm_error("SRIO_LL_PROTOCOL_CHECKER:VC_ERR", 
      $sformatf("TID_%0h %s Packet with vc = 1,\
      which is not supported in Gen1.3", index[7:0], ftype.name))    
      err_type = VC_ERR;
    end // }
  end // }

  if((ll_mon_env_config.multi_vc_support) && 
     (ll_mon_env_config.srio_mode != SRIO_GEN13) && (pkt.vc))
  begin // {
    if(ll_mon_env_config.vc_num_support == 8)
    begin   // {
      flow_id = {4'b1000,pkt.prio,pkt.crf};
      flow_id++; 
    end // }
    else if(ll_mon_env_config.vc_num_support == 4)
    begin   // {
      flow_id = {4'b1000,pkt.prio,1'b1}; 
    end // }
    else if(ll_mon_env_config.vc_num_support == 2)
    begin   // {
      flow_id = {4'b1000,pkt.prio[1],1'b0,1'b1}; 
    end // }
    else if(ll_mon_env_config.vc_num_support == 1)
    begin   // {
      flow_id = {7'b1000001}; 
    end // }
  end
  else
  begin // {   
    flow_id = {4'b0000, pkt.prio, pkt.crf};
  end // }

  sindex_vfc = {pkt.SourceID,pkt.DestinationID,flow_id};
  if (xoff_cnt_array_vfc.exists(sindex_vfc))
    xoff_count = xoff_cnt_array_vfc[sindex_vfc];
  else
    xoff_count = 0;

  if (xoff_count > 0) 
  begin // {
    `uvm_error("SRIO_LL_PROTOCOL_CHECKER:LFC_BLOCKED_PKT_ERR", 
    $sformatf("SpecRef:Part9-Section2.2: TID_%0h Packet with XOFF-ed flow", 
    index[7:0]))
    err_type = LFC_BLOCKED_PKT_ERR;
  end // }

  if (req_pkt)  
  begin // {
    if (ftype == TYPE7) 
    begin // {
      if (pkt.prio != 3)
      begin // {
        `uvm_error("SRIO_LL_PROTOCOL_CHECKER:LFC_PRI_ERR", 
        $sformatf("SpecRef:Part9-Section2.2: TID_%0h LFC PKT WITH PRIORITY != 3; \
        ACT PRIO: %0h h", index[7:0], pkt.prio))  
        LTLED_CSR[4] = 1;
        err_type = LFC_PRI_ERR;
      end // }
      if ((pkt.crf != 1) && (crf_support))
      begin // {
        `uvm_error("SRIO_LL_PROTOCOL_CHECKER:LFC_PRI_ERR", 
        $sformatf("SpecRef:Part9-Section2.2: TID_%0h LFC PKT WITH CRF != 1",
        index[7:0]))  
        LTLED_CSR[4] = 1;
        err_type = LFC_PRI_ERR;
      end // }
    end // }
    else if(pkt.prio == 3)
    begin // {
      if (!((ll_mon_env_config.multi_vc_support) && 
            (ll_mon_env_config.srio_mode != SRIO_GEN13) && (pkt.vc)))
      begin // {
        `uvm_error("SRIO_LL_PROTOCOL_CHECKER:INVALID_PRI_ERR", 
        $sformatf("SpecRef:Part6-Section6.6.3: TID_%0h REQUEST WITH PRIORITY = 3; \
        Packet is dropped",index[7:0]))
        LTLED_CSR[4] = 1;
        drop_packet  = 1; 
        err_type = INVALID_PRI_ERR;
      end // }      
    end // }      
  end // }
  else  
  begin // {
    if (pkt.crf != exp_resp_array_vfc[index].crf) 
    begin // {   
      `uvm_error("SRIO_LL_PROTOCOL_CHECKER:RESP_PRI_ERR", 
      $sformatf("SpecRef:Part6-Section6.6.3: TID_%0h REQ CRF != RESP CRF; \
      EXP: %0h h, ACT: %0h h", index[7:0], exp_resp_array_vfc[index].crf, pkt.crf))    
      err_type = RESP_PRI_ERR;
    end // }
 
    if (pkt.prio == 0)
    begin // {
      `uvm_error("SRIO_LL_PROTOCOL_CHECKER:INVALID_PRI_ERR", 
      $sformatf("SpecRef:Part6-Section6.6.3: TID_%0h RESP WITH PRIORITY = 0;", 
      index[7:0]))    
      err_type = INVALID_PRI_ERR;
    end // }
    else if (pkt.prio <= exp_resp_array_vfc[index].prio) 
    begin // {
      `uvm_error("SRIO_LL_PROTOCOL_CHECKER:RESP_PRI_ERR", 
      $sformatf("SpecRef:Part6-Section6.6.3: TID_%0h \
      RESP PRIO (%0h h)<= REQ PRIO (%0h h);", 
      index[7:0], pkt.prio, exp_resp_array_vfc[index].prio))    
      LTLED_CSR[4] = 1;
      drop_packet  = 1; 
      err_type = RESP_PRI_ERR;
    end // }
  end // }    

endfunction: valid_flow_chk

////////////////////////////////////////////////////////////////////////////////
/// Name: lfc_checks \n 
/// Description: Function to check LFC packet protocol \n
/// lfc_checks
////////////////////////////////////////////////////////////////////////////////

function void srio_ll_txrx_monitor::lfc_checks();

  srio_ll_lfc_assembly tx_lfc_array_lfc       [bit [63:0]];
  srio_ll_lfc_assembly rx_lfc_array_lfc       [bit [63:0]];
  bit [6:0]  flow7;
  bit [6:0]  flowid;
  bit [6:0]  req_flowid;
  bit        crf;
  bit [1:0]  prio;
  bit [2:0]  flow3;
  bit [2:0]  array_limit;
  bit [63:0] sindex;
  bit [63:0] dindex;
  bit        seq_no;
  bit        valid_req;
  bit        xon_valid;
  bit        xoff_valid;
  flow_arb_cmd arb_cmd;
  int        orph_xoff_size;
  bit        xoff_id_exist;
  bit        flowid_chk_passed;
  bit        request_issued;
  bit [70:0] tx_orphxoff_timer_array_lfc[$]; 
  int        xoff_cnt_array_lfc     [bit[70:0]];
   bit [63:0] lfc_copy_index;
   bit [71:0] cnt_copy_index;
  lfc_assembly = new;

  arb_cmd = flow_arb_cmd'({pkt.xon_xoff,pkt.FAM});
  seq_no  = pkt.FAM[0];
  sindex = {pkt.tgtdestID,pkt.DestinationID};
  dindex = {pkt.DestinationID,pkt.tgtdestID};

  flow7  = pkt.flowID; // 7 Bit flowid
  flowid = pkt.flowID;
  crf    = flowid[0]; 
  prio   = flowid[2:1];
  array_limit = 6;
  flow3  = flowid[2:0]; // 3 Bit flowid
  flowid_chk_passed = 0;
  tx_lfc_array_lfc.delete;
  rx_lfc_array_lfc.delete;
  xoff_cnt_array_lfc.delete;
  tx_orphxoff_timer_array_lfc.delete;

  if (mon_type) 
  begin // {
    `ifdef VCS_ASS_ARR_FIX
     foreach(`TX_LFC_ARRAY[lfc_copy_index]) tx_lfc_array_lfc[lfc_copy_index]            = `TX_LFC_ARRAY[lfc_copy_index];
     foreach(`RX_LFC_ARRAY[lfc_copy_index]) rx_lfc_array_lfc[lfc_copy_index]            = `RX_LFC_ARRAY[lfc_copy_index];
     foreach(`TX_XOFF_CNT[cnt_copy_index]) xoff_cnt_array_lfc[cnt_copy_index]          = `TX_XOFF_CNT[cnt_copy_index];
     tx_orphxoff_timer_array_lfc = `TX_ORPHXOFF_TIMER_ARRAY;
    `else
    tx_lfc_array_lfc            = `TX_LFC_ARRAY;
    rx_lfc_array_lfc            = `RX_LFC_ARRAY;
    xoff_cnt_array_lfc          = `TX_XOFF_CNT;
    tx_orphxoff_timer_array_lfc = `TX_ORPHXOFF_TIMER_ARRAY;
    `endif
  end // }
  else 
  begin // { 
    `ifdef VCS_ASS_ARR_FIX
     foreach(`RX_LFC_ARRAY[lfc_copy_index]) tx_lfc_array_lfc[lfc_copy_index]            = `RX_LFC_ARRAY[lfc_copy_index];
     foreach(`TX_LFC_ARRAY[lfc_copy_index]) rx_lfc_array_lfc[lfc_copy_index]            = `TX_LFC_ARRAY[lfc_copy_index];
     foreach(`RX_XOFF_CNT[cnt_copy_index]) xoff_cnt_array_lfc[cnt_copy_index]          = `RX_XOFF_CNT[cnt_copy_index];
     tx_orphxoff_timer_array_lfc = `RX_ORPHXOFF_TIMER_ARRAY;
    `else
    tx_lfc_array_lfc            = `RX_LFC_ARRAY;
    rx_lfc_array_lfc            = `TX_LFC_ARRAY;
    xoff_cnt_array_lfc          = `RX_XOFF_CNT;
    tx_orphxoff_timer_array_lfc = `RX_ORPHXOFF_TIMER_ARRAY;
    `endif
  end // }
 
  if (shared_class.valid_lfc_flowid.exists(flowid))
  begin // {
    if (ll_pass_sts)
    begin // {
      // Flow arbitration command check
      if ((flow_arb_support_self == 0) || (flow_arb_support_lp == 0))
      begin // {
        arb_cmd[2:0] = 3'b000;
      end // }

      if (shared_class.valid_flow_arb_cmd.exists(arb_cmd))
      begin // {
        `uvm_info("SRIO_LL_PROTOCOL_CHECKER:lfc_checks", 
        $sformatf("TID_%0h LFC Packet: %s with flowid: %0h h", 
        index[7:0], arb_cmd.name, flowid), UVM_LOW)
        // Flowid check 
        if (flowid[6])
        begin // {
          if(((ll_mon_env_config.multi_vc_support) && 
              (ll_mon_env_config.srio_mode != SRIO_GEN13)))
          begin //{
            if(((ll_mon_env_config.vc_num_support == 4) && 
               ((flowid[2:0] != 1) && (flowid[2:0] != 3) && 
                (flowid[2:0] != 5) && (flowid[2:0] != 7)))  ||
               ((ll_mon_env_config.vc_num_support == 2) && 
               ((flowid[2:0] != 1) && (flowid[2:0] != 5)))  ||
               ((ll_mon_env_config.vc_num_support == 1) && (flowid[2:0] != 1)))
            begin   // {
              `uvm_error("SRIO_LL_PROTOCOL_CHECKER:INVALID_FLOWID_ERR", 
              $sformatf("TID_%0h %s Packet with unsupported FlowID 7'b%0h h", 
              index[7:0], ftype.name, flowid))    
              err_type = INVALID_FLOWID_ERR;
            end // }
            else
            begin // {
              flowid_chk_passed = 1;
            end // }
          end // }
          else 
          begin // {
            if(ll_mon_env_config.multi_vc_support == 0)
            begin // {
              `uvm_error("SRIO_LL_PROTOCOL_CHECKER:VC_ERR", 
              $sformatf("TID_%0h %s Packet with FlowID[6]= 1,\
              where Multiple VC support is not there", index[7:0], ftype.name))    
              err_type = VC_ERR;
            end // }
            if(ll_mon_env_config.srio_mode == SRIO_GEN13)
            begin // {
              `uvm_error("SRIO_LL_PROTOCOL_CHECKER:INVALID_FLOWID_ERR", 
              $sformatf("TID_%0h %s Packet with FlowID[6]= 1, \
              which is not supported in Gen1.3", index[7:0], ftype.name))    
              err_type = INVALID_FLOWID_ERR;
            end // }
          end // }
        end // }
        else
        begin // {
          flowid_chk_passed = 1;
        end // }

        if (flowid_chk_passed)
        begin // {
          case (arb_cmd) // {
            XOFF:
            begin // {
              orph_xoff_size = tx_orphxoff_timer_array_lfc.size();
              xoff_id_exist = 0;
              for (int b = 0; b < orph_xoff_size; b++) 
              begin // {
                if (tx_orphxoff_timer_array_lfc[b] == {dindex,flowid})  
                begin // {
                  xoff_id_exist = 1;
                  break;
                end // }
              end // }
              if (xoff_id_exist == 0)
              begin // {
                tx_orphxoff_timer_array_lfc.push_back({dindex,flowid});    
              end // }
 
              if (flowid[6])
              begin // {
                xoff_cnt_array_lfc[{dindex,flowid}] = xoff_cnt_array_lfc[{dindex,flowid}] + 1;
                `uvm_info("SRIO_LL_PROTOCOL_CHECKER:lfc_checks", 
                $sformatf("TID_%0h XOFF Multi-vc xoff_cnt_array_lfc[{%0h h,%0h h}]: %0h h", 
                index[7:0], dindex,flowid[2:0], 
                xoff_cnt_array_lfc[{dindex,flowid}]), UVM_LOW)
              end // }
              else
              begin // {  
                for (int i=0; i<= flow3; i++) 
                begin // {
                  xoff_cnt_array_lfc[{dindex,flowid}] = xoff_cnt_array_lfc[{dindex,flowid}] + 1;
                  `uvm_info("SRIO_LL_PROTOCOL_CHECKER:lfc_checks", 
                  $sformatf("TID_%0h XOFF xoff_cnt_array_lfc[{%0h h,%0h h}]: %0h h", 
                  index[7:0], dindex,flowid[2:0], 
                  xoff_cnt_array_lfc[{dindex,flowid}]), UVM_LOW)
                  flowid = flowid - 1;
                end // }
              end // }
            end // }

            XON: 
            begin // {
              if (xoff_cnt_array_lfc.exists({dindex,flowid}))
              begin // {
                for (int i=flow3; i<=array_limit; i++) // Flow F = 101; 
                begin // {
                  if (xoff_cnt_array_lfc.exists({dindex,flowid}))
                  begin // {
                    if (xoff_cnt_array_lfc[{dindex,flowid}] > 0) 
                    begin // {
                      xoff_cnt_array_lfc[{dindex,flowid}] = xoff_cnt_array_lfc[{dindex,flowid}] - 1;
                      flowid = flowid + 1;

                      `uvm_info("SRIO_LL_PROTOCOL_CHECKER:lfc_checks", 
                      $sformatf("XOFF xoff_cnt_array_lfc[{%0h h,%0h h}]: %0h h", 
                      dindex,flowid[2:0], xoff_cnt_array_lfc[{dindex,flowid}]), UVM_LOW);

                      if (xoff_cnt_array_lfc[{dindex,flowid}] == 0) 
                      begin // {
                        orph_xoff_size = tx_orphxoff_timer_array_lfc.size();
                        for (int a = 0; a < orph_xoff_size; a++) 
                        begin // {
                          if (tx_orphxoff_timer_array_lfc[a] == {dindex,flowid})
                          begin // {
                            tx_orphxoff_timer_array_lfc.delete(a); 
                          end // }
                        end // }
                      end // }
                    end // }
                  end // }
                  else
                  begin // {
                    flowid = flowid + 1;
                  end // }
                  if (flowid[6]) // If multi-vc is enabled only that particular flow will be affected
                  begin // {
                    break;
                  end // }
                end // }
              end // }
              else
              begin // {
                `uvm_info("SRIO_LL_PROTOCOL_CHECKER:lfc_checks", 
                $sformatf("SpecRef:Part9-Section2.2: TID_%0h \
                XON without XOFF preceeded by it; flowid: %0h h",
                index[7:0], flowid), UVM_LOW)
              end // } 
            end // }

            REQ_SINGLE0, REQ_MULTI0:
            begin // {
              valid_req = 1;
              if (tx_lfc_array_lfc.exists(dindex))
              begin // {
                if (tx_lfc_array_lfc[dindex].req_xonxoff_timer0 > 0)
                begin // {
                  `uvm_error("SRIO_LL_PROTOCOL_CHECKER:OUTSTANDING_SEQNO_ERR", 
                  $sformatf("SpecRef:Part9-Section2.2: TID_%0h \
                  %s with Outstanding seq_no %0h h", 
                  index[7:0], arb_cmd.name, seq_no))
                  valid_req = 0;
                  ll_pass_sts = 0;            
                  err_type = OUTSTANDING_SEQNO_ERR;
                end // }
                else if (tx_lfc_array_lfc[dindex].req_xonxoff_timer1 > 0)  
                begin  // {
                  if (rx_lfc_array_lfc.exists(sindex))
                  begin  // {                
                    if ((rx_lfc_array_lfc[sindex].xon_pdu_timer1  == 0) &&
                        (rx_lfc_array_lfc[sindex].xoff_rel_timer1 == 0))
                    begin // {
                      `uvm_error("SRIO_LL_PROTOCOL_CHECKER:REQ_PIPELINING_ERR", 
                      $sformatf("SpecRef:Part9-Section2.2: TID_%0h \
                      %s Pipelining request before the first request is responded", 
                      index[7:0], arb_cmd.name))
                      valid_req = 0;
                      ll_pass_sts = 0;            
                      err_type = REQ_PIPELINING_ERR;
                    end // }
                    else if (rx_lfc_array_lfc[sindex].xon_pdu_timer1  > 0) 
                    begin // {
                      `uvm_info("SRIO_LL_PROTOCOL_CHECKER:lfc_checks", 
                      $sformatf("SpecRef:Part9-Section2.2: TID_%0h %s \
                      Pipelining request", index[7:0], arb_cmd.name), UVM_LOW)
                      if (arb_cmd == REQ_SINGLE0)
                        single_req_pipelined = 1;
                      else
                        multi_req_pipelined  = 1;
                    end // }
                  end // }
                  else
                  begin // {
                    `uvm_error("SRIO_LL_PROTOCOL_CHECKER:REQ_PIPELINING_ERR", 
                    $sformatf("SpecRef:Part9-Section2.2: TID_%0h \
                    %s Pipelining request before the first request is responded",
                    index[7:0], arb_cmd.name))
                    valid_req = 0;
                    ll_pass_sts = 0;            
                    err_type = REQ_PIPELINING_ERR;
                  end // } 
                end // } 
              end // }

              if (valid_req)
              begin // {
                if (!tx_lfc_array_lfc.exists(dindex))
                begin // {
                  lfc_assembly.req_xonxoff_timer0 = 1;
                  tx_lfc_array_lfc[dindex] = lfc_assembly;
                end // }
                tx_lfc_array_lfc[dindex].req_xonxoff_timer0 = 1;
                tx_lfc_array_lfc[dindex].req0_flowid = pkt.flowID;

                if (arb_cmd == REQ_MULTI0) 
                begin // { 
                  tx_lfc_array_lfc[dindex].req_type0 = 1;  // req_type1 for seq1
                end // }
                else
                begin // { 
                  tx_lfc_array_lfc[dindex].req_type0 = 0;
                end // }
              end // }
            end // }

            REQ_SINGLE1, REQ_MULTI1:
            begin // {
              valid_req = 1;
              if (tx_lfc_array_lfc.exists(dindex))
              begin // {
                if (tx_lfc_array_lfc[dindex].req_xonxoff_timer1 > 0)
                begin // {
                  `uvm_error("SRIO_LL_PROTOCOL_CHECKER:OUTSTANDING_SEQNO_ERR", 
                  $sformatf("SpecRef:Part9-Section2.2: TID_%0h \
                  %s with Outstanding seq_no %0h h", 
                  index[7:0], arb_cmd.name, seq_no))
                  valid_req = 0;
                  ll_pass_sts = 0;            
                  err_type = OUTSTANDING_SEQNO_ERR;
                end // }
                else if (tx_lfc_array_lfc[dindex].req_xonxoff_timer0 > 0) 
                begin  // {
                  if (rx_lfc_array_lfc.exists(sindex))
                  begin  // {                
                    if ((rx_lfc_array_lfc[sindex].xon_pdu_timer0  == 0) &&
                        (rx_lfc_array_lfc[sindex].xoff_rel_timer0 == 0))
                    begin // {
                      `uvm_error("SRIO_LL_PROTOCOL_CHECKER:REQ_PIPELINING_ERR", 
                      $sformatf("SpecRef:Part9-Section2.2: TID_%0h %s \
                      Pipelining request before the first request is responded", 
                      index[7:0], arb_cmd.name))
                      valid_req = 0;
                      ll_pass_sts = 0;            
                      err_type = REQ_PIPELINING_ERR;
                    end // }
                    else if (rx_lfc_array_lfc[sindex].xon_pdu_timer0  > 0) 
                    begin // {
                      `uvm_info("SRIO_LL_PROTOCOL_CHECKER:lfc_checks", 
                      $sformatf("SpecRef:Part9-Section2.2: TID_%0h \
                      %s Pipelining request", index[7:0], arb_cmd.name), UVM_LOW)
                      if (arb_cmd == REQ_SINGLE1)
                        single_req_pipelined = 1;
                      else
                        multi_req_pipelined  = 1;
                    end // }
                  end // }
                  else
                  begin // {
                    `uvm_error("SRIO_LL_PROTOCOL_CHECKER:REQ_PIPELINING_ERR", 
                    $sformatf("SpecRef:Part9-Section2.2: TID_%0h \
                    %s Pipelining request before the first request is responded",
                    index[7:0], arb_cmd.name))
                    valid_req = 0;
                    ll_pass_sts = 0;            
                    err_type = REQ_PIPELINING_ERR;
                  end // } 
                end // } 
              end // }

              if (valid_req)
              begin // {
                if (!tx_lfc_array_lfc.exists(dindex))
                begin // {
                  lfc_assembly.req_xonxoff_timer1 = 1;
                  tx_lfc_array_lfc[dindex] = lfc_assembly;
                end // }
                tx_lfc_array_lfc[dindex].req_xonxoff_timer1 = 1;
                tx_lfc_array_lfc[dindex].req1_flowid = pkt.flowID;

                if (arb_cmd ==REQ_MULTI1)
                begin // { 
                  tx_lfc_array_lfc[dindex].req_type1 = 1;  
                end // }
                else
                begin // { 
                  tx_lfc_array_lfc[dindex].req_type1 = 0;
                end // }
              end // }
            end // }

            XON_ARB0: 
            begin // {
              xon_valid = 0;
              request_issued = 0;
              if (rx_lfc_array_lfc.exists(sindex))
              begin // {
                if (rx_lfc_array_lfc[sindex].req_xonxoff_timer0 > 0)
                begin // {
                  if (tx_lfc_array_lfc.exists(dindex))
                  begin // {
                    if ((tx_lfc_array_lfc[dindex].xon_pdu_timer0 > 0) ||
                       (tx_lfc_array_lfc[dindex].xon_pdu_timer1 > 0))
                    begin // {                       
                      `uvm_warning("SRIO_LL_PROTOCOL_CHECKER:lfc_checks", 
                      $sformatf("SpecRef:Part9-Section2.2: TID_%0h \
                      Ignoring %s, as already XON has been sent", 
                      index[7:0], arb_cmd.name))
                      request_issued = 1;
                    end // }
                  end // }
                  else
                  begin // {
                    xon_valid = 1;
                  end //} 
                end // }
              end // }

              if (xon_valid) 
              begin // {                        
                if (((arb_cmd == XON_ARB0) && (rx_lfc_array_lfc[sindex].req0_flowid == pkt.flowID)) ||
                    ((arb_cmd == XON_ARB1) && (rx_lfc_array_lfc[sindex].req1_flowid == pkt.flowID)))
                begin // {
                  if (!tx_lfc_array_lfc.exists(dindex))
                  begin // {
                    lfc_assembly.xon_pdu_timer0 = 1;
                    tx_lfc_array_lfc[dindex] = lfc_assembly;
                  end // }
                  tx_lfc_array_lfc[dindex].xon_pdu_timer0 = 1;
                end // }
                else
                begin // {
                  req_flowid = rx_lfc_array_lfc[sindex].req0_flowid;
                  `uvm_warning("SRIO_LL_PROTOCOL_CHECKER:lfc_checks",
                  $sformatf("SpecRef:Part9-Section2.2: TID_%0h Ignoring %s, \
                  as Req_Flowid != %s_Flowid; \n \
                  Req_Seq_No: %0h h FlowId Exp: %0h h, Act: %0h h", index[7:0], 
                  arb_cmd.name, arb_cmd.name, seq_no, req_flowid, pkt.flowID)) 
                end // }
              end // }
              else
              begin // {
                if(request_issued == 0)
                begin // {
                  `uvm_warning("SRIO_LL_PROTOCOL_CHECKER:lfc_checks", 
                  $sformatf("SpecRef:Part9-Section2.2: TID_%0h \
                  %s without corresponding Request", index[7:0], arb_cmd.name)) 
                end // }
              end // }
            end // }

            XON_ARB1: 
            begin // {
              xon_valid = 0;
              request_issued = 0;
              if (rx_lfc_array_lfc.exists(sindex))
              begin // {
                if (rx_lfc_array_lfc[sindex].req_xonxoff_timer1 > 0)
                begin // {
                  if (tx_lfc_array_lfc.exists(dindex))
                  begin // {
                    if ((tx_lfc_array_lfc[dindex].xon_pdu_timer1 > 0) ||
                       (tx_lfc_array_lfc[dindex].xon_pdu_timer0 > 0))
                    begin // {                       
                      `uvm_warning("SRIO_LL_PROTOCOL_CHECKER:lfc_checks", 
                      $sformatf("SpecRef:Part9-Section2.2: TID_%0h \
                      Ignoring %s, as already XON has been sent", 
                      index[7:0], arb_cmd.name))
                      request_issued = 1;
                    end // }
                  end // }
                  else
                  begin // {
                    xon_valid = 1;
                  end //} 
                end // }
              end // }

              if (xon_valid) 
              begin // {                        
                if (((arb_cmd == XON_ARB1) && (rx_lfc_array_lfc[sindex].req1_flowid == pkt.flowID)) ||
                    ((arb_cmd == XON_ARB0) && (rx_lfc_array_lfc[sindex].req0_flowid == pkt.flowID)))
                begin // {
                  if (!tx_lfc_array_lfc.exists(dindex))
                  begin // {
                    lfc_assembly.xon_pdu_timer1 = 1;
                    tx_lfc_array_lfc[dindex] = lfc_assembly;
                  end // }
                  tx_lfc_array_lfc[dindex].xon_pdu_timer1 = 1;
                end // }
                else
                begin // {
                  req_flowid = rx_lfc_array_lfc[sindex].req1_flowid;
                  `uvm_warning("SRIO_LL_PROTOCOL_CHECKER:lfc_checks",
                  $sformatf("SpecRef:Part9-Section2.2: TID_%0h \
                  Ignoring %s, as Req_Flowid != %s_Flowid; \n \
                  Req_Seq_No: %0h h FlowId Exp: %0h h, Act: %0h h", index[7:0], 
                  arb_cmd.name, arb_cmd.name, seq_no, req_flowid, pkt.flowID)) 
                end // }
              end // }
              else
              begin // {
                if(request_issued == 0)
                begin // {
                  `uvm_warning("SRIO_LL_PROTOCOL_CHECKER:lfc_checks", 
                  $sformatf("SpecRef:Part9-Section2.2: TID_%0h \
                  %s without corresponding Request", index[7:0], arb_cmd.name)) 
                end // }
              end // }
            end // }

            XOFF_ARB0: 
            begin // {
              xoff_valid = 0;  
              if (rx_lfc_array_lfc.exists(sindex))
              begin // {
                if (rx_lfc_array_lfc[sindex].req_xonxoff_timer0 > 0)
                begin // {
                  if (tx_lfc_array_lfc.exists(dindex))
                  begin // {                        
                    if (tx_lfc_array_lfc[dindex].xoff_rel_timer0 > 0)
                    begin // {                        
                      `uvm_warning("SRIO_LL_PROTOCOL_CHECKER:lfc_checks", 
                      $sformatf("SpecRef:Part9-Section2.2: TID_%0h \
                      Ignoring %s, as it has already been sent", index[7:0], 
                      arb_cmd.name))    
                    end // }
                    else
                    begin // {                        
                      xoff_valid = 1;  
                    end // }                    
                  end // }
                  else
                  begin // {
                    xoff_valid = 1; 
                  end // }
                end // }
              end // }

              if (xoff_valid) 
              begin // {
                if (!tx_lfc_array_lfc.exists(dindex))
                begin // {
                  tx_lfc_array_lfc[dindex] = lfc_assembly;
                end // }

                if (((arb_cmd == XOFF_ARB0) && (rx_lfc_array_lfc[sindex].req0_flowid == pkt.flowID)) ||
                    ((arb_cmd == XOFF_ARB1) && (rx_lfc_array_lfc[sindex].req1_flowid == pkt.flowID)))
                begin // {
                  tx_lfc_array_lfc[dindex].xoff_rel_timer0 = 1;
                end // }
                else
                begin // {
                  req_flowid = rx_lfc_array_lfc[sindex].req0_flowid;
                  `uvm_warning("SRIO_LL_PROTOCOL_CHECKER:lfc_checks",
                  $sformatf("SpecRef:Part9-Section2.2: TID_%0h Ignoring %s, \
                  as Req_Flowid != %s_Flowid; Req_Seq_No: %0h h FlowId Exp: %0h h, Act: %0h h",
                  index[7:0], arb_cmd.name, arb_cmd.name, 
                  seq_no, req_flowid, pkt.flowID)) 
                end // }
              end // }
              else
              begin // {
                `uvm_warning("SRIO_LL_PROTOCOL_CHECKER:lfc_checks", 
                $sformatf("SpecRef:Part9-Section2.2: TID_%0h \
                %s without corresponding Request", index[7:0], arb_cmd.name)) 
              end // }
            end // }

            XOFF_ARB1: 
            begin // {
              xoff_valid = 0;  
              if (rx_lfc_array_lfc.exists(sindex))
              begin // {
                if (rx_lfc_array_lfc[sindex].req_xonxoff_timer1 > 0)
                begin // {
                  if (tx_lfc_array_lfc.exists(dindex))
                  begin // {                        
                    if (tx_lfc_array_lfc[dindex].xoff_rel_timer1 > 0)
                    begin // {                        
                      `uvm_warning("SRIO_LL_PROTOCOL_CHECKER:lfc_checks", 
                      $sformatf("SpecRef:Part9-Section2.2: TID_%0h \
                      Ignoring %s, as it has already been sent", 
                      index[7:0], arb_cmd.name))    
                    end // }
                    else
                    begin // {                        
                      xoff_valid = 1;  
                    end // }                    
                  end // }
                  else
                  begin // {
                    xoff_valid = 1; 
                  end // }
                end // }
              end // }

              if (xoff_valid) 
              begin // {
                if (!tx_lfc_array_lfc.exists(dindex))
                begin // {
                  tx_lfc_array_lfc[dindex] = lfc_assembly;
                end // }

                if (((arb_cmd == XOFF_ARB1) && (rx_lfc_array_lfc[sindex].req1_flowid == pkt.flowID)) ||
                    ((arb_cmd == XOFF_ARB0) && (rx_lfc_array_lfc[sindex].req0_flowid == pkt.flowID)))
                begin // {
                  tx_lfc_array_lfc[dindex].xoff_rel_timer1 = 1;
                end // }
                else
                begin // {
                  req_flowid = rx_lfc_array_lfc[sindex].req1_flowid;
                  `uvm_warning("SRIO_LL_PROTOCOL_CHECKER:lfc_checks",
                  $sformatf("SpecRef:Part9-Section2.2: TID_%0h \
                  Ignoring %s, as Req_Flowid != %s_Flowid; \n \
                  Req_Seq_No: %0h h FlowId Exp: %0h h, Act: %0h h",index[7:0], 
                  arb_cmd.name, arb_cmd.name, seq_no, req_flowid, pkt.flowID)) 
                end // }
              end // }
              else
              begin // {
                `uvm_warning("SRIO_LL_PROTOCOL_CHECKER:lfc_checks", 
                $sformatf("SpecRef:Part9-Section2.2: TID_%0h \
                %s without corresponding Request", index[7:0], arb_cmd.name)) 
              end // }
            end // }

            RELEASE0:
            begin // {
              if (tx_lfc_array_lfc.exists(dindex))
              begin // {
                if (tx_lfc_array_lfc[dindex].req_xonxoff_timer0 > 0)
                begin // {
                  if (tx_lfc_array_lfc[dindex].req_type0) // Release only for multi_req
                  begin // {
                    if (rx_lfc_array_lfc.exists(sindex))
                    begin // {
                      if ((rx_lfc_array_lfc[sindex].xon_pdu_timer0 > 0) ||
                          (rx_lfc_array_lfc[sindex].xoff_rel_timer0 > 0))
                      begin // {
                        if (tx_lfc_array_lfc[dindex].pdu_flowid == pkt.flowID)
                        begin // {
                          if (tx_lfc_array_lfc[dindex].pdu_completed) 
                          begin // {
                            tx_lfc_array_lfc[dindex].req_xonxoff_timer0 = 0; 
                            tx_lfc_array_lfc[dindex].rel_deall_timer0   = 1; 
                          end // }
                          else
                          begin // {
                            `uvm_error("SRIO_LL_PROTOCOL_CHECKER:IMPROPER_RELEASE_ERR", 
                            $sformatf("SpecRef:Part9-Section2.2: TID_%0h \
                            %s before the PDU is completed", index[7:0], arb_cmd.name))
                            ll_pass_sts = 0;            
                            err_type = IMPROPER_RELEASE_ERR;
                          end // }                 
                        end // }                 
                        else
                        begin // {
                          `uvm_warning("SRIO_LL_PROTOCOL_CHECKER:lfc_checks", 
                          $sformatf("SpecRef:Part9-Section2.2: TID_%0h \
                          %s flowid != PDU flowid; FlowID exp: %0h h; Act:%0h h",index[7:0], 
                          arb_cmd.name,tx_lfc_array_lfc[dindex].pdu_flowid,pkt.flowID))
                        end // }                 
                      end // }
                      else
                      begin // {   
                        `uvm_warning("SRIO_LL_PROTOCOL_CHECKER:lfc_checks", 
                        $sformatf("SpecRef:Part9-Section2.2: TID_%0h \
                        %s for the unallocated memory", index[7:0], arb_cmd.name))
                      end // }                 
                    end // }
                    else
                    begin // {
                      `uvm_warning("SRIO_LL_PROTOCOL_CHECKER:lfc_checks", 
                      $sformatf("SpecRef:Part9-Section2.2: TID_%0h \
                      %s without XON/XOFF", index[7:0], arb_cmd.name))   
                    end // }                 
                  end // }                 
                  else
                  begin // {
                    `uvm_error("SRIO_LL_PROTOCOL_CHECKER:IMPROPER_RELEASE_ERR", 
                    $sformatf("SpecRef:Part9-Section2.2: TID_%0h \
                    %s for a Single Request",index[7:0], arb_cmd.name))   
                    ll_pass_sts = 0;            
                    err_type = IMPROPER_RELEASE_ERR;
                  end // }                 
                end // }
                else
                begin // {
                  `uvm_error("SRIO_LL_PROTOCOL_CHECKER:IMPROPER_RELEASE_ERR", 
                  $sformatf("SpecRef:Part9-Section2.2: TID_%0h \
                  %s without corresponding Request",index[7:0], arb_cmd.name))    
                  ll_pass_sts = 0;            
                  err_type = IMPROPER_RELEASE_ERR;
                end // }
              end // }
              else
              begin // {
                `uvm_warning("SRIO_LL_PROTOCOL_CHECKER:lfc_checks", 
                $sformatf("SpecRef:Part9-Section2.2: TID_%0h \
                %s: Trying to release the memory which was not requested", 
                index[7:0], arb_cmd.name)) 
                ll_pass_sts = 0;            
              end // }
            end // }

            RELEASE1:
            begin // {
              if (tx_lfc_array_lfc.exists(dindex))
              begin // {
                if (tx_lfc_array_lfc[dindex].req_xonxoff_timer1 > 0)
                begin // {
                  if (tx_lfc_array_lfc[dindex].req_type1) // Release only for multi_req
                  begin // {
                    if (rx_lfc_array_lfc.exists(sindex))
                    begin // {
                      if ((rx_lfc_array_lfc[sindex].xon_pdu_timer1 > 0) ||
                          (rx_lfc_array_lfc[sindex].xoff_rel_timer1 > 0))
                      begin // {
                        if (tx_lfc_array_lfc[dindex].pdu_flowid == pkt.flowID)
                        begin // {
                          if (tx_lfc_array_lfc[dindex].pdu_completed) 
                          begin // {
                            tx_lfc_array_lfc[dindex].req_xonxoff_timer1 = 0; 
                            tx_lfc_array_lfc[dindex].rel_deall_timer1   = 1; 
                          end // }
                          else
                          begin // {
                            `uvm_error("SRIO_LL_PROTOCOL_CHECKER:IMPROPER_RELEASE_ERR", 
                            $sformatf("SpecRef:Part9-Section2.2: TID_%0h \
                            %s before the PDU is completed", index[7:0], arb_cmd.name))
                            ll_pass_sts = 0;            
                            err_type = IMPROPER_RELEASE_ERR;
                          end // }                 
                        end // }                 
                        else
                        begin // {
                          `uvm_warning("SRIO_LL_PROTOCOL_CHECKER:lfc_checks", 
                          $sformatf("SpecRef:Part9-Section2.2: TID_%0h \
                          %s flowid != PDU flowid; FlowID exp: %0h h; Act:%0h h", index[7:0],
                          arb_cmd.name,tx_lfc_array_lfc[dindex].pdu_flowid,pkt.flowID))
                        end // }                 
                      end // }
                      else
                      begin // {
                        `uvm_warning("SRIO_LL_PROTOCOL_CHECKER:lfc_checks", 
                        $sformatf("SpecRef:Part9-Section2.2: TID_%0h \
                        %s for the unallocated memory", index[7:0], arb_cmd.name))
                      end // }                 
                    end // }
                    else
                    begin // {
                      `uvm_warning("SRIO_LL_PROTOCOL_CHECKER:lfc_checks", 
                      $sformatf("SpecRef:Part9-Section2.2: TID_%0h %s without XON/XOFF", 
                      index[7:0], arb_cmd.name))   
                    end // }                 
                  end // }                 
                  else
                  begin // {
                    `uvm_error("SRIO_LL_PROTOCOL_CHECKER:IMPROPER_RELEASE_ERR", 
                    $sformatf("SpecRef:Part9-Section2.2: TID_%0h \
                    %s for a Single Request",index[7:0], arb_cmd.name))   
                    ll_pass_sts = 0;            
                    err_type = IMPROPER_RELEASE_ERR;
                  end // }                 
                end // }
                else
                begin // {
                  `uvm_error("SRIO_LL_PROTOCOL_CHECKER:IMPROPER_RELEASE_ERR", 
                  $sformatf("SpecRef:Part9-Section2.2: TID_%0h \
                  %s without corresponding Request",index[7:0], arb_cmd.name))    
                  ll_pass_sts = 0;            
                  err_type = IMPROPER_RELEASE_ERR;
                end // }
              end // }
              else
              begin // {
                `uvm_warning("SRIO_LL_PROTOCOL_CHECKER:lfc_checks", 
                $sformatf("SpecRef:Part9-Section2.2: TID_%0h \
                %s: Trying to release the memory which was not requested",
                index[7:0], arb_cmd.name)) 
                ll_pass_sts = 0;            
              end // }
            end // }
          endcase  // }
        end // }
      end // }
      else
      begin // {
        `uvm_error("SRIO_LL_PROTOCOL_CHECKER:INVALID_FLOWARB_CMD_ERR", 
        $sformatf("SpecRef:Part9-Section2.2: TID_%0h Invalid Flow_arb command \
        xon_xoff: %0h h, FAM: %0h h",index[7:0], pkt.xon_xoff,pkt.FAM))
        ll_pass_sts = 0;            
        err_type = INVALID_FLOWARB_CMD_ERR;
      end // }
    end // }
  end // }
  else
  begin // {
    `uvm_error("SRIO_LL_PROTOCOL_CHECKER:INVALID_FLOWID_ERR", 
    $sformatf("TID_%0h Invalid FlowID. Packet Flowid %0h h", index[7:0], pkt.flowID))
    ll_pass_sts = 0;            
    err_type = INVALID_FLOWID_ERR;
  end // }

  if (mon_type) 
  begin // {
    `ifdef VCS_ASS_ARR_FIX
     foreach (tx_lfc_array_lfc[lfc_copy_index]) `TX_LFC_ARRAY[lfc_copy_index] = tx_lfc_array_lfc[lfc_copy_index];
     foreach (`TX_LFC_ARRAY[lfc_copy_index])
       if (tx_lfc_array_lfc.exists(lfc_copy_index) == 0) `TX_LFC_ARRAY.delete(lfc_copy_index);
     
     foreach (xoff_cnt_array_lfc[cnt_copy_index]) `TX_XOFF_CNT[cnt_copy_index]  = xoff_cnt_array_lfc[cnt_copy_index]; 
     foreach (`TX_XOFF_CNT[cnt_copy_index])
       if (xoff_cnt_array_lfc.exists(cnt_copy_index) == 0) `TX_XOFF_CNT.delete(cnt_copy_index);
    `else
    `TX_LFC_ARRAY = tx_lfc_array_lfc;
    `TX_XOFF_CNT  = xoff_cnt_array_lfc; 
    `endif
    `TX_ORPHXOFF_TIMER_ARRAY = tx_orphxoff_timer_array_lfc;
  end // }
  else 
  begin // { 
    `ifdef VCS_ASS_ARR_FIX
     foreach (tx_lfc_array_lfc[lfc_copy_index]) `RX_LFC_ARRAY[lfc_copy_index] = tx_lfc_array_lfc[lfc_copy_index];
     foreach (`RX_LFC_ARRAY[lfc_copy_index])
       if (tx_lfc_array_lfc.exists(lfc_copy_index) == 0) `RX_LFC_ARRAY.delete(lfc_copy_index);
     
     foreach (xoff_cnt_array_lfc[cnt_copy_index]) `RX_XOFF_CNT[cnt_copy_index]  = xoff_cnt_array_lfc[cnt_copy_index]; 
     foreach (`RX_XOFF_CNT[cnt_copy_index])
       if (xoff_cnt_array_lfc.exists(cnt_copy_index) == 0) `RX_XOFF_CNT.delete(cnt_copy_index);
    `else
    `RX_LFC_ARRAY = tx_lfc_array_lfc;
    `RX_XOFF_CNT  = xoff_cnt_array_lfc; 
    `endif
    `RX_ORPHXOFF_TIMER_ARRAY = tx_orphxoff_timer_array_lfc;
  end // }
 
endfunction :lfc_checks

////////////////////////////////////////////////////////////////////////////////
/// Name: ds_tm_chk \n 
/// Description: Function to check DS TM packet protocol \n
/// ds_tm_chk
////////////////////////////////////////////////////////////////////////////////

function void srio_ll_txrx_monitor::ds_tm_chk();
  bit [7:0] q_status;
  bit       basic_type_support;
  bit       rate_type_support;
  bit       credit_type_support;
  bit [3:0] tm_types_support_r;

  bit [3:0] tm_mode; 
  bit [3:0] tm_mode_r; 
  bit       tm_disabled;         
  bit       basic_mode_selected;  
  bit       rate_mode_selected;  
  bit       credit_mode_selected;

  mask = pkt.mask;
  tm_types_support    = ll_reg_model.Data_Streaming_Logical_Layer_Control_CSR.TM_Types_Supported.get(); // Read-only
  basic_type_support  = tm_types_support[0];
  rate_type_support   = tm_types_support[1];
  credit_type_support = tm_types_support[2];

  regcontent = {28'h0,tm_types_support};
  reg_content_reverse();
  tm_types_support_r = rev_regcontent[31:28];

  tm_types_support    = tm_types_support_r;

  tm_mode_r = ll_reg_model.Data_Streaming_Logical_Layer_Control_CSR.TM_Mode.get();
  regcontent = {28'h0,tm_mode_r};
  reg_content_reverse();
  tm_mode = rev_regcontent[31:28];

  // Traffic Management Mode of operation
  // 0b0000 = TM Disabled
  // 0b0001 = Basic
  // 0b0010 = Rate
  // 0b0011 = Credit
  // 0b0100 = Credit + Rate
  // 0b0101 - 0b0111 = Reserved
  // 0b1000 - 0b1111 = allowed for user defined modes
 
  tm_disabled          =  (tm_mode == 4'b0000) ? 1 : 0;
  basic_mode_selected  =  (tm_mode == 4'b0001) ? 1 : 0;
  rate_mode_selected   = ((tm_mode == 4'b0010) || (tm_mode == 4'b0100)) ? 1 : 0;
  credit_mode_selected = ((tm_mode == 4'b0011) || (tm_mode == 4'b0100)) ? 1 : 0;

  if((tm_types_support != 4'b1000) && 
     (tm_types_support != 4'b1100) && 
     (tm_types_support != 4'b1010) &&
     (tm_types_support != 4'b1110))
  begin // {  
    `uvm_error("SRIO_LL_PROTOCOL_CHECKER:REG_CONFIG_ERR", 
    $sformatf("SpecRef:Part10-Section5.6.1: TID_%0h Invalid TM Types supported. \
    Valid Combinations:  0b1000, 0b1100, 0b1010, 0b1110; Act: %0h h", 
    index[7:0], tm_types_support))
    err_type = REG_CONFIG_ERR;
  end // }

  if((!tm_disabled) && (!basic_mode_selected) && 
     (!rate_mode_selected) && (!credit_mode_selected))
  begin // {
    `uvm_error("SRIO_LL_PROTOCOL_CHECKER:REG_CONFIG_ERR", 
    $sformatf("SpecRef:Part10-Section5.6.1: TID_%0h Reserved TM mode. \
    Valid Combinations: 0/1/2/3/4; Act: %0h h", index[7:0], tm_mode))
    err_type = REG_CONFIG_ERR;
  end // }

  if (!tm_disabled)
  begin // {
    // Mask Field check
    if (shared_class.valid_tm_mask.exists(mask) == 0)
    begin // {
      `uvm_error("SRIO_LL_PROTOCOL_CHECKER:RESERVED_MASK_ERR", 
      $sformatf("TID_%0h %s Packet with reserved mask field 8'b%0h h", 
      index[7:0], ftype.name, mask))    
      err_type = RESERVED_MASK_ERR;
    end // }

    if (pkt.xtype != 0)
    begin // {
      `uvm_error("SRIO_LL_PROTOCOL_CHECKER:NONZERO_RESERVED_FLD_ERR", 
      $sformatf("SpecRef:Part10-Section4.3: TID_%0h \
      Non-zero(reserved) xtype field %0h h", index[7:0], pkt.xtype))
      LTLED_CSR[4] = 1;
      err_type = NONZERO_RESERVED_FLD_ERR;
    end  // }

    case (pkt.TMOP)  // {
      4'h0: // Basic Stream Management Message
      begin // {
        if (basic_type_support)
        begin // {
          if (basic_mode_selected)
          begin // {
            case (pkt.parameter1) //{  
              8'h0:
              begin // {
                case (pkt.parameter2) // {
                  8'h0: 
                  begin // {
                    ds_tm_xoff_array_update();
                    `uvm_info("SRIO_LL_PROTOCOL_CHECKER:ds_tm_chk", 
                    $sformatf("TID_%0h Basic TM: XOFF",index[7:0]), UVM_LOW)
                  end // } 
                  8'hFF: 
                  begin // {
                    `uvm_info("SRIO_LL_PROTOCOL_CHECKER:ds_tm_chk", 
                    $sformatf("TID_%0h Basic TM: XON", index[7:0]), UVM_LOW)
                    ds_tm_xoff_array_update();
                  end // }
                  default: 
                  begin // {
                    `uvm_info("SRIO_LL_PROTOCOL_CHECKER:ds_tm_chk", 
                    $sformatf("TID_%0h Basic TM: User defined TM Msg; \
                    TMOP: %0h h, Parameter1: %0h h, Parameter2: %0h h", 
                    index[7:0], pkt.TMOP, pkt.parameter1, pkt.parameter2), UVM_LOW)
                  end // }
                endcase // }
              end // } 

              8'h3:
              begin // {
                `uvm_info("SRIO_LL_PROTOCOL_CHECKER:ds_tm_chk", 
                $sformatf("TID_%0h Basic TM: Q_Status: Source Q is %0h h/255 full", 
                index[7:0], pkt.parameter2), UVM_LOW)
              end // }

              default:
              begin // {
                `uvm_error("SRIO_LL_PROTOCOL_CHECKER:RESERVED_PARAMETER_ERR", 
                $sformatf("TID_%0h Basic TM: Reserved Parameter1 %0h h", 
                index[7:0], pkt.parameter1))
                LTLED_CSR[4] = 1;
                err_type = RESERVED_PARAMETER_ERR;
              end // }                 
            endcase // }
          end // } 
          else
          begin // {
            `uvm_error("SRIO_LL_PROTOCOL_CHECKER:REG_CONFIG_ERR", 
            $sformatf("SpecRef:Part10-Section5.6.1: TID_%0h \
            Basic TM mode of operation is not programmed in the register", index[7:0]))
            err_type = REG_CONFIG_ERR;
          end // } 
        end // } 
        else
        begin // {
          `uvm_error("SRIO_LL_PROTOCOL_CHECKER:REG_CONFIG_ERR", 
          $sformatf("SpecRef:Part10-Section5.6.1: TID_%0h \
          TM Basic type is not supported", index[7:0]))
          LTLED_CSR[9] = 1; // Unsupported Transaction          
          err_type = REG_CONFIG_ERR;
        end // } 
      end // } 

      4'h1: // Rate Based Traffic Management 
      begin // {
        if (rate_type_support)
        begin // {
          if (rate_mode_selected)
          begin // {
            case (pkt.parameter1) // { 
              8'h0:
              begin // {
                case (pkt.parameter2) // {
                  8'h0: 
                  begin // {
                    ds_tm_xoff_array_update();
                    `uvm_info("SRIO_LL_PROTOCOL_CHECKER:ds_tm_chk", 
                    $sformatf("TID_%0h Rate Based TM: XOFF", index[7:0]), UVM_LOW)
                  end // } 
                  8'hFF: 
                  begin // {
                    ds_tm_xoff_array_update();
                    `uvm_info("SRIO_LL_PROTOCOL_CHECKER:ds_tm_chk", 
                    $sformatf("TID_%0h Rate Based TM: XON", index[7:0]), UVM_LOW)
                  end // }
                  default: 
                  begin // {
                    `uvm_error("SRIO_LL_PROTOCOL_CHECKER:REG_CONFIG_ERR", 
                    $sformatf("TID_%0h Rate Based TM: User defined TM Msg; \
                    TMOP: %0h h, Parameter1: %0h h, Parameter2: %0h h", 
                    index[7:0], pkt.TMOP, pkt.parameter1, pkt.parameter2))
                    err_type = REG_CONFIG_ERR;
                  end // }
                endcase // }
              end // } 

              8'h1, 8'h5:
              begin // {
                 case (pkt.parameter2) // {
                   8'h0: 
                   begin // {
                     `uvm_info("SRIO_LL_PROTOCOL_CHECKER:ds_tm_chk", 
                     $sformatf("TID_%0h Rate Based TM: Maintain Rate", 
                     index[7:0]), UVM_LOW)
                   end // } 
                   default: 
                   begin // {
                     `uvm_info("SRIO_LL_PROTOCOL_CHECKER:ds_tm_chk", 
                     $sformatf("TID_%0h Rate Based TM: \
                     REDUCE the current rate to = Current Rate x (1 - %0h h/256)", 
                     index[7:0], pkt.parameter2), UVM_LOW)
                   end // } 
                 endcase // }
              end // } 

              8'h2, 8'h6:
              begin // {
                case (pkt.parameter2) // {
                  8'hFF: 
                  begin // {
                    `uvm_info("SRIO_LL_PROTOCOL_CHECKER:ds_tm_chk", 
                    $sformatf("TID_%0h Rate Based TM: \
                    DOUBLE the current Rate",index[7:0]), UVM_LOW)
                  end // } 
                  default: 
                  begin // {
                    `uvm_info("SRIO_LL_PROTOCOL_CHECKER:ds_tm_chk", 
                    $sformatf("TID_%0h Rate Based TM: \
                    INCREASE the current rate to = Current Rate x (1 + %0h h/256)", 
                    index[7:0], pkt.parameter2), UVM_LOW)
                  end // } 
                endcase // }
              end // } 

              8'h3:
              begin // {
                `uvm_info("SRIO_LL_PROTOCOL_CHECKER:ds_tm_chk", 
                $sformatf("TID_%0h Rate Based TM: Q_Status: \
                Source queue is %0h h/255 full", index[7:0], pkt.parameter2), UVM_LOW)
              end // } 

              default:
              begin // {
                `uvm_error("SRIO_LL_PROTOCOL_CHECKER:RESERVED_PARAMETER_ERR", 
                $sformatf("TID_%0h Rate Based TM: Reserved Parameter1 %0h h",
                index[7:0], pkt.parameter1))
                LTLED_CSR[4] = 1;
                err_type = RESERVED_PARAMETER_ERR;
              end // }
            endcase  // }
          end // }
          else
          begin // {
            `uvm_error("SRIO_LL_PROTOCOL_CHECKER:REG_CONFIG_ERR", 
            $sformatf("SpecRef:Part10-Section5.6.1: TID_%0h \
            Rate Based TM mode of operation is not programmed in the register", index[7:0]))
            err_type = REG_CONFIG_ERR;
          end // } 
        end // } 
        else
        begin // {
          `uvm_error("SRIO_LL_PROTOCOL_CHECKER:REG_CONFIG_ERR", 
          $sformatf("SpecRef:Part10-Section5.6.1: TID_%0h \
          TM Rate Based type is not supported", index[7:0]))
          LTLED_CSR[9] = 1; // Unsupported Transaction          
          err_type = REG_CONFIG_ERR;
        end // } 
      end // } 

      4'h2: // Credit Based Traffic Management 
      begin // {
        if (credit_type_support)
        begin // {
          if (credit_mode_selected)
          begin // {
            casez (pkt.parameter1) // { 
              8'h0:
              begin // {
                 casez (pkt.parameter2) // {
                   8'h0: 
                   begin // {
                     ds_tm_xoff_array_update();
                     `uvm_info("SRIO_LL_PROTOCOL_CHECKER:ds_tm_chk", 
                     $sformatf("TID_%0h Credit Based TM: XOFF", index[7:0]), UVM_LOW)
                   end // } 
                   8'hFF: 
                   begin // {
                     ds_tm_xoff_array_update();
                     `uvm_info("SRIO_LL_PROTOCOL_CHECKER:ds_tm_chk", 
                     $sformatf("TID_%0h Credit Based TM: XON", index[7:0]), UVM_LOW)
                   end // }
                   default: 
                   begin // {
                     `uvm_error("SRIO_LL_PROTOCOL_CHECKER:RESERVED_PARAMETER_ERR", 
                     $sformatf("TID_%0h Credit Based TM: User Defined Format; \
                     TMOP: %0h h, Parameter1: %0h h, Parameter2: %0h h", 
                     index[7:0], pkt.TMOP, pkt.parameter1, pkt.parameter2))
                     err_type = RESERVED_PARAMETER_ERR;
                   end // }
                 endcase // }
              end // } 

              8'b0001_????:
              begin // {
                `uvm_info("SRIO_LL_PROTOCOL_CHECKER:ds_tm_chk", 
                $sformatf("TID_%0h Credit Based TM: Allocate %0h h Unit", 
                index[7:0], pkt.parameter2), UVM_LOW)
                ds_tm_xoff_array_update();
              end // } 

              8'b0010_????:
              begin // {
                `uvm_info("SRIO_LL_PROTOCOL_CHECKER:ds_tm_chk", 
                $sformatf("TID_%0h Credit Based TM: Credit Status %0h h Unit", 
                index[7:0], pkt.parameter2), UVM_LOW)
              end // } 

              8'b0011_0000:
              begin // {
                `uvm_info("SRIO_LL_PROTOCOL_CHECKER:ds_tm_chk", 
                $sformatf("TID_%0h Credit Based TM: Q_Status: \
                Source Queue is %0h h/255 full", index[7:0], pkt.parameter2), UVM_LOW)
              end // } 

              default:
              begin // {
                `uvm_error("SRIO_LL_PROTOCOL_CHECKER:RESERVED_PARAMETER_ERR", 
                $sformatf("TID_%0h Credit Based TM: Reserved Parameter1 %0h h", 
                index[7:0], pkt.parameter1))
                LTLED_CSR[4] = 1;
                err_type = RESERVED_PARAMETER_ERR;
              end // }
            endcase // }
          end // }
          else
          begin // {
            `uvm_error("SRIO_LL_PROTOCOL_CHECKER:REG_CONFIG_ERR", 
            $sformatf("SpecRef:Part10-Section5.6.1: TID_%0h \
            Credit Based TM mode of operation is not programmed in the register", index[7:0]))
            err_type = REG_CONFIG_ERR;
          end // } 
        end // } 
        else
        begin // {
          `uvm_error("SRIO_LL_PROTOCOL_CHECKER:REG_CONFIG_ERR", 
          $sformatf("SpecRef:Part10-Section5.6.1: TID_%0h \
          TM Credit Based type is not supported",index[7:0]))
          LTLED_CSR[9] = 1; // Unsupported Transaction          
          err_type = REG_CONFIG_ERR;
        end // } 
      end // }

      4'h3: // Application Defined Stream Management Message 
      begin // {
        `uvm_error("SRIO_LL_PROTOCOL_CHECKER:RESERVED_TMOP_ERR", 
        $sformatf("SpecRef:Part10-Section4.3: TID_%0h \
        Appln Defined TMOP field %0h h", index[7:0], pkt.TMOP))
        LTLED_CSR[4] = 1;
        err_type = RESERVED_TMOP_ERR;
      end  // }

      default: 
      begin // {
        `uvm_error("SRIO_LL_PROTOCOL_CHECKER:RESERVED_TMOP_ERR", 
        $sformatf("SpecRef:Part10-Section4.3: TID_%0h \
        Reserved TMOP field %0h h", index[7:0], pkt.TMOP))
        LTLED_CSR[4] = 1;
        err_type = RESERVED_TMOP_ERR;
      end  // }
    endcase // }
  end  // }
  else 
  begin // {
    `uvm_error("SRIO_LL_PROTOCOL_CHECKER:REG_CONFIG_ERR", 
    $sformatf("SpecRef:Part10-Section5.6.1: TID_%0h \
    Received TM Pkt where TM is Disabled",index[7:0]))
    err_type = REG_CONFIG_ERR;
  end  // }

endfunction : ds_tm_chk

////////////////////////////////////////////////////////////////////////////////
/// Name: ds_tm_xoff_array_update \n 
/// Description: Function to update DS block/unblock/credit status \n
/// ds_tm_xoff_array_update
////////////////////////////////////////////////////////////////////////////////

function void srio_ll_txrx_monitor::ds_tm_xoff_array_update();
  bit        ds_tm_xoff_array_up   [bit[55: 0]];
  int        ds_tm_credit_array_tm [bit[55: 0]];
  bit [55:0] ds_xoff_index;
  bit [55:0] ds_credit_index;
  bit [7:0]  parameter1;
  bit [7:0]  parameter2;
  bit [7:0]  class_mask;
  bit [3:0]  TMOP;
  bit [2:0]  ds_tm_xoff_wc;
  bit [31:0] dest_id;
  bit [31:0] src_id;
  bit [7:0]  cos;
  bit [15:0] stream_id;
  bit [31:0] s_d       = 0;
  bit [31:0] e_d       = 0;
  bit [7:0]  s_c       = 0;
  bit [7:0]  e_c       = 0;
  bit [15:0] s_s       = 0;
  bit [15:0] e_s       = 0;
   bit [55:0] copy_index;

  dest_id   = pkt.SourceID; 
  src_id   = pkt.DestinationID;
  stream_id = pkt.streamID; 
  cos       = pkt.cos; 
  wild_card = pkt.wild_card;
  parameter1 = pkt.parameter1;
  parameter2 = pkt.parameter2;
  TMOP       = pkt.TMOP;
  mask       = pkt.mask;

  ds_tm_credit_array_tm.delete;
  ds_tm_xoff_array_up.delete;

  if (mon_type) 
  begin // {
    ds_tm_xoff_wc          = `TX_DS_TM_WC;
    `ifdef VCS_ASS_ARR_FIX
     foreach (`RX_DS_TM_CREDIT_ARRAY[copy_index]) ds_tm_credit_array_tm[copy_index]  = `RX_DS_TM_CREDIT_ARRAY[copy_index];
     foreach (`TX_DS_TM_XOFF_ARRAY[copy_index]) ds_tm_xoff_array_up[copy_index]    = `TX_DS_TM_XOFF_ARRAY[copy_index];
    `else
    ds_tm_credit_array_tm  = `RX_DS_TM_CREDIT_ARRAY;
    ds_tm_xoff_array_up    = `TX_DS_TM_XOFF_ARRAY;
    `endif
  end // }
  else 
  begin // {
    ds_tm_xoff_wc          = `RX_DS_TM_WC;
    `ifdef VCS_ASS_ARR_FIX
     foreach (`TX_DS_TM_CREDIT_ARRAY[copy_index]) ds_tm_credit_array_tm[copy_index]  = `TX_DS_TM_CREDIT_ARRAY[copy_index];
     foreach (`RX_DS_TM_XOFF_ARRAY[copy_index]) ds_tm_xoff_array_up[copy_index]    = `RX_DS_TM_XOFF_ARRAY[copy_index];
    `else
    ds_tm_credit_array_tm  = `TX_DS_TM_CREDIT_ARRAY;
    ds_tm_xoff_array_up    = `RX_DS_TM_XOFF_ARRAY;
     `endif
  end // }

  if(TMOP < 3 && parameter1 == 0 && parameter2 == 0)     // XOFF DS TM received
    ds_tm_xoff_wc = wild_card; 
  else if(TMOP < 3 && parameter1 == 0 && parameter2 == 8'hFF) // XON DS TM received
    ds_tm_xoff_wc = 0; 

  if(wild_card == 3'b111)            // All (DestID, cos, stream id)
  begin // {
    if((TMOP == 4'b0010) && (parameter1[7:4] == 4'b0001)) // Allocate Unit
    begin // {
      s_d = dest_id;   e_d = dest_id;  s_c = 8'h0;        e_c = 8'hFF; s_s = 16'h0;     e_s = 16'hFFFF;
    end // }
    else
    begin // {
      s_d = 32'h0;     e_d = 32'h0;    s_c = 8'h0;        e_c = 8'h0;  s_s = 16'h0;     e_s = 16'h0;  
    end // }
  end // }
  else if(wild_card == 3'b011)       // All (cos,stream id) 1 DestID
  begin // {
    s_d = dest_id;   e_d = dest_id;  s_c = 8'h0;        e_c = 8'hFF; s_s = 16'h0;     e_s = 16'hFFFF;  
  end // }
  else if(wild_card == 3'b001)     
  begin  // {
    if(mask == 0)                    // All (stream id) One (cos, DestID)
    begin // {
      s_d = dest_id; e_d = dest_id;  s_c = cos;         e_c = cos;   s_s = 16'h0;     e_s = 16'hFFFF;  
    end // }
    else
    begin  // {                      // All (stream id) Group of cos
      s_d = dest_id; e_d = dest_id;  s_c = cos & ~mask; e_c = 8'hFF; s_s = 16'h0;     e_s = 16'hFFFF; 
    end  // }                                         
  end // }
  else 
  begin  // {                       //  One (DestID, cos, stream id)
    s_d = dest_id;   e_d = dest_id;  s_c = cos;         e_c = cos;   s_s = stream_id; e_s = stream_id;  
  end // }

  if(TMOP < 3 && parameter1 == 0 && parameter2 == 0) // XOFF  
  begin // {
    for(bit[56:0]cnt = {1'b0,s_d,s_c,s_s}; cnt <= {1'b0,e_d,e_c,e_s}; cnt++)
    begin // {
     ds_tm_xoff_array_up[cnt[55:0]] = 1;
    end     // }      
  end // }
  else if(TMOP < 3 && parameter1 == 0 && parameter2 == 8'hFF) // XON
  begin // {
    for(bit[56:0]cnt = {1'b0,s_d,s_c,s_s}; cnt <= {1'b0,e_d,e_c,e_s}; cnt++)
    begin // {
      if(ds_tm_xoff_array_up.num() > 0 && ds_tm_xoff_array_up.exists(cnt[55:0]))
      begin // {
        if (ds_tm_xoff_array_up.exists(cnt[55:0]))
          ds_tm_xoff_array_up.delete(cnt[55:0]);
      end    // }       
    end    // }       
  end // }
  else if((TMOP == 4'b0010) && (parameter1[7:4] == 4'b0001)) // Allocate Unit
  begin // {
    for(bit[56:0]cnt = {1'b0,s_d,s_c,s_s}; cnt <= {1'b0,e_d,e_c,e_s}; cnt++)
    begin // {
      if (ds_tm_credit_array_tm.exists(cnt[55:0]))
        ds_tm_credit_array_tm[cnt[55:0]] = ds_tm_credit_array_tm[cnt[55:0]] + parameter2;
      else 
        ds_tm_credit_array_tm[cnt[55:0]] = parameter2;
    end  // }       
  end // }

  if (mon_type) 
  begin // {
    `ifdef VCS_ASS_ARR_FIX
     foreach (ds_tm_xoff_array_up[copy_index]) `TX_DS_TM_XOFF_ARRAY[copy_index]   = ds_tm_xoff_array_up[copy_index];
     foreach (`TX_DS_TM_XOFF_ARRAY[copy_index])
       if (ds_tm_xoff_array_up.exists(copy_index) == 0) `TX_DS_TM_XOFF_ARRAY.delete(copy_index);
     
     foreach (ds_tm_credit_array_tm[copy_index]) `RX_DS_TM_CREDIT_ARRAY[copy_index] = ds_tm_credit_array_tm[copy_index];
     foreach (`RX_DS_TM_CREDIT_ARRAY[copy_index])
       if (ds_tm_credit_array_tm.exists(copy_index) == 0) `RX_DS_TM_CREDIT_ARRAY.delete(copy_index);
    `else
    `TX_DS_TM_XOFF_ARRAY   = ds_tm_xoff_array_up;
    `RX_DS_TM_CREDIT_ARRAY = ds_tm_credit_array_tm;
   `endif
    `TX_DS_TM_WC           = ds_tm_xoff_wc;
  end // }
  else 
  begin // { 
    `ifdef VCS_ASS_ARR_FIX
     foreach (ds_tm_xoff_array_up[copy_index]) `RX_DS_TM_XOFF_ARRAY[copy_index]   = ds_tm_xoff_array_up[copy_index];
     foreach (`RX_DS_TM_XOFF_ARRAY[copy_index])
       if (ds_tm_xoff_array_up.exists(copy_index) == 0) `RX_DS_TM_XOFF_ARRAY.delete(copy_index);
     
     foreach (ds_tm_credit_array_tm[copy_index]) `TX_DS_TM_CREDIT_ARRAY[copy_index] = ds_tm_credit_array_tm[copy_index];
     foreach (`TX_DS_TM_CREDIT_ARRAY[copy_index])
       if (ds_tm_credit_array_tm.exists(copy_index) == 0) `TX_DS_TM_CREDIT_ARRAY.delete(copy_index);
    `else
    `RX_DS_TM_XOFF_ARRAY   = ds_tm_xoff_array_up;
    `TX_DS_TM_CREDIT_ARRAY = ds_tm_credit_array_tm;
   `endif
    `RX_DS_TM_WC           = ds_tm_xoff_wc;
  end // }
  
endfunction : ds_tm_xoff_array_update

////////////////////////////////////////////////////////////////////////////////
/// Name: ll_update_ltled_csr \n 
/// Description: Function to update LL Error status register \n
/// ll_update_ltled_csr
////////////////////////////////////////////////////////////////////////////////

function void srio_ll_txrx_monitor::ll_update_ltled_csr();
  
  int LTLEE_RD1, LTLED_RD1, LTLED_WR, LTLED_RD2, LTLHAC_WR, LTLAC_WR, LTLDIDC_WR,
      LTLCC_WR, LTLD32DIDC_WR, LTLD32SIDC_WR; 
  bit dev32support, port_wr_pending_sts;
 
  if (LTLED_CSR !=0)
  begin // { 
    LTLEE_RD1 =  ll_reg_model.Logical_Transport_Layer_Error_Enable_CSR.get();
    LTLED_RD1 =  ll_reg_model.Logical_Transport_Layer_Error_Detect_CSR.get();

    LTLED_WR = LTLED_CSR & LTLEE_RD1;

    if (LTLED_WR) // Err sts update is enabled and the error has been detected 
    begin // {
      LTLED_WR = LTLED_WR  | LTLED_RD1;
      void'(ll_reg_model.Logical_Transport_Layer_Error_Detect_CSR.predict(LTLED_WR));
      LTLED_RD2 = ll_reg_model.Logical_Transport_Layer_Error_Detect_CSR.get();
  
      if (LTLED_RD2 != LTLED_WR)
      begin // {
       `uvm_warning("SRIO_LL_PROTOCOL_CHECKER:reg_chk", 
        $sformatf("LTLED Register not updated properly; \
        Write value: %0h h; Read Value: %0h h", LTLED_WR, LTLED_RD2))
      end // }

      // Updating Error Capture registers
      case (ll_mon_env_config.port_number)
        0 : port_wr_pending_sts = ll_reg_model.Port_0_Error_and_Status_CSR.Port_write_Pending.get(); 
        1 : port_wr_pending_sts = ll_reg_model.Port_1_Error_and_Status_CSR.Port_write_Pending.get();
        2 : port_wr_pending_sts = ll_reg_model.Port_2_Error_and_Status_CSR.Port_write_Pending.get();
        3 : port_wr_pending_sts = ll_reg_model.Port_3_Error_and_Status_CSR.Port_write_Pending.get();
        4 : port_wr_pending_sts = ll_reg_model.Port_4_Error_and_Status_CSR.Port_write_Pending.get();
        5 : port_wr_pending_sts = ll_reg_model.Port_5_Error_and_Status_CSR.Port_write_Pending.get();
        6 : port_wr_pending_sts = ll_reg_model.Port_6_Error_and_Status_CSR.Port_write_Pending.get();
        7 : port_wr_pending_sts = ll_reg_model.Port_7_Error_and_Status_CSR.Port_write_Pending.get();
        8 : port_wr_pending_sts = ll_reg_model.Port_8_Error_and_Status_CSR.Port_write_Pending.get();
        9 : port_wr_pending_sts = ll_reg_model.Port_9_Error_and_Status_CSR.Port_write_Pending.get();
        10: port_wr_pending_sts = ll_reg_model.Port_10_Error_and_Status_CSR.Port_write_Pending.get();
        11: port_wr_pending_sts = ll_reg_model.Port_11_Error_and_Status_CSR.Port_write_Pending.get();
        12: port_wr_pending_sts = ll_reg_model.Port_12_Error_and_Status_CSR.Port_write_Pending.get();
        13: port_wr_pending_sts = ll_reg_model.Port_13_Error_and_Status_CSR.Port_write_Pending.get();
        14: port_wr_pending_sts = ll_reg_model.Port_14_Error_and_Status_CSR.Port_write_Pending.get();
        15: port_wr_pending_sts = ll_reg_model.Port_15_Error_and_Status_CSR.Port_write_Pending.get();
      endcase

      if (port_wr_pending_sts == 0)
      begin // {
        // Set Port-write Pending bit to 1  
        case (ll_mon_env_config.port_number)
          0 : void'(ll_reg_model.Port_0_Error_and_Status_CSR.Port_write_Pending.predict(1'b1));
          1 : void'(ll_reg_model.Port_1_Error_and_Status_CSR.Port_write_Pending.predict(1'b1));
          2 : void'(ll_reg_model.Port_2_Error_and_Status_CSR.Port_write_Pending.predict(1'b1));
          3 : void'(ll_reg_model.Port_3_Error_and_Status_CSR.Port_write_Pending.predict(1'b1));
          4 : void'(ll_reg_model.Port_4_Error_and_Status_CSR.Port_write_Pending.predict(1'b1));
          5 : void'(ll_reg_model.Port_5_Error_and_Status_CSR.Port_write_Pending.predict(1'b1));
          6 : void'(ll_reg_model.Port_6_Error_and_Status_CSR.Port_write_Pending.predict(1'b1));
          7 : void'(ll_reg_model.Port_7_Error_and_Status_CSR.Port_write_Pending.predict(1'b1));
          8 : void'(ll_reg_model.Port_8_Error_and_Status_CSR.Port_write_Pending.predict(1'b1));
          9 : void'(ll_reg_model.Port_9_Error_and_Status_CSR.Port_write_Pending.predict(1'b1));
          10: void'(ll_reg_model.Port_10_Error_and_Status_CSR.Port_write_Pending.predict(1'b1));
          11: void'(ll_reg_model.Port_11_Error_and_Status_CSR.Port_write_Pending.predict(1'b1));
          12: void'(ll_reg_model.Port_12_Error_and_Status_CSR.Port_write_Pending.predict(1'b1));
          13: void'(ll_reg_model.Port_13_Error_and_Status_CSR.Port_write_Pending.predict(1'b1));
          14: void'(ll_reg_model.Port_14_Error_and_Status_CSR.Port_write_Pending.predict(1'b1));
          15: void'(ll_reg_model.Port_15_Error_and_Status_CSR.Port_write_Pending.predict(1'b1));
        endcase

        LTLHAC_WR     =  pkt.ext_address;
        LTLAC_WR      = {pkt.address, 1'b0, pkt.xamsbs};
        LTLDIDC_WR    = {pkt.DestinationID[15:0], pkt.SourceID[15:0]}; 
        LTLCC_WR      = {pkt.ftype, pkt.ttype, pkt.letter, pkt.mbox, pkt.msgseg_xmbox, 16'h0};
        LTLD32DIDC_WR =  pkt.DestinationID;
        LTLD32SIDC_WR =  pkt.SourceID;
 
        void'(ll_reg_model.Logical_Transport_Layer_Address_Capture_CSR.predict(LTLAC_WR));
        void'(ll_reg_model.Logical_Transport_Layer_Control_Capture_CSR.predict(LTLCC_WR));

        if (ll_mon_env_config.en_ext_addr_support)
        begin // {
          void'(ll_reg_model.Logical_Transport_Layer_High_Address_Capture_CSR.predict(LTLHAC_WR));
        end // }

        dev32support = ll_reg_model.Processing_Element_Features_CAR.Dev32_Support.get();
        if (dev32support)
        begin // {
          void'(ll_reg_model.Logical_Transport_Layer_Dev32_Destination_ID_Capture_CSR.predict(LTLD32DIDC_WR));
          void'(ll_reg_model.Logical_Transport_Layer_Dev32_Source_ID_Capture_CSR.predict(LTLD32SIDC_WR));
        end // }
        else
        begin // {
          void'(ll_reg_model.Logical_Transport_Layer_Device_ID_Capture_CSR.predict(LTLDIDC_WR));
        end // }
      end // }
    end // }
  end // }

endfunction : ll_update_ltled_csr

////////////////////////////////////////////////////////////////////////////////
/// Name: reg_content_reverse \n 
/// Description: Function to change Reg content - Big endian to little endian \n
/// reg_content_reverse
////////////////////////////////////////////////////////////////////////////////

function void srio_ll_txrx_monitor::reg_content_reverse();
 
  rev_regcontent = 32'h0;;
  
  for (int rev_count = 0; rev_count <= 31; rev_count++)
  begin // {
    rev_regcontent[31-rev_count] = regcontent[rev_count];
  end // }
  
endfunction : reg_content_reverse

////////////////////////////////////////////////////////////////////////////////
/// Name: display_pkt_details \n 
/// Description: Function to print the packet count at the end of simulation \n  
/// display_pkt_details
////////////////////////////////////////////////////////////////////////////////

function void srio_ll_txrx_monitor::display_pkt_details();

  int rd_owner     = 0;
  int rd_own_owner = 0;
  int iord_owner   = 0;
  int rd_home      = 0;
  int rd_own_home  = 0;
  int iord_home    = 0;
  int dkill_home   = 0;
  int ikill_home   = 0;
  int tlbie        = 0;
  int tlbsync      = 0;
  int ird_home     = 0;
  int flush_wo_data= 0;
  int ikill_sharer = 0;
  int dkill_sharer = 0;
  int cast_out     = 0;
  int flush_wdata  = 0;
  int nrd          = 0;
  int ato_inc      = 0;
  int ato_dec      = 0;
  int ato_set      = 0;
  int ato_clr      = 0;
  int nwr          = 0;
  int nwr_r        = 0;
  int ato_swap     = 0;
  int ato_cswap    = 0;
  int ato_tswap    = 0;
  int swr          = 0;
  int mrd_req      = 0;
  int mwr_req      = 0;
  int mrd_res      = 0;
  int mwr_res      = 0;
  int mport_wr     = 0;
  int resp_wo_dpl  = 0;
  int resp_msg     = 0;
  int resp_with_dpl= 0;
  int fc           = 0;
  int ds           = 0;
  int db           = 0;
  int msg          = 0;
  int tot_gsm      = 0;
  int tot_io       = 0;
  int tot_msg      = 0;
  int tot_resp     = 0;
  int invalid_pkt  = 0;

  // GSM
  rd_owner     = ftype_count[{4'h1,4'h0}];
  rd_own_owner = ftype_count[{4'h1,4'h1}];
  iord_owner   = ftype_count[{4'h1,4'h2}];
  rd_home      = ftype_count[{4'h2,4'h0}];
  rd_own_home  = ftype_count[{4'h2,4'h1}];
  iord_home    = ftype_count[{4'h2,4'h2}];
  dkill_home   = ftype_count[{4'h2,4'h3}];
  ikill_home   = ftype_count[{4'h2,4'h5}];
  tlbie        = ftype_count[{4'h2,4'h6}];
  tlbsync      = ftype_count[{4'h2,4'h7}];
  ird_home     = ftype_count[{4'h2,4'h8}];
  flush_wo_data= ftype_count[{4'h2,4'h9}];
  ikill_sharer = ftype_count[{4'h2,4'hA}];
  dkill_sharer = ftype_count[{4'h2,4'hB}];
  cast_out     = ftype_count[{4'h5,4'h0}];
  flush_wdata  = ftype_count[{4'h5,4'h1}];
    
  // IO
  nrd          = ftype_count[{4'h2,4'h4}];
  ato_inc      = ftype_count[{4'h2,4'hC}];
  ato_dec      = ftype_count[{4'h2,4'hD}];
  ato_set      = ftype_count[{4'h2,4'hE}];
  ato_clr      = ftype_count[{4'h2,4'hF}];
  nwr          = ftype_count[{4'h5,4'h4}];
  nwr_r        = ftype_count[{4'h5,4'h5}];
  ato_swap     = ftype_count[{4'h5,4'hC}];
  ato_cswap    = ftype_count[{4'h5,4'hD}];
  ato_tswap    = ftype_count[{4'h5,4'hE}];
  swr          = ftype_count[{4'h6,4'h0}];
  mrd_req      = ftype_count[{4'h8,4'h0}];
  mwr_req      = ftype_count[{4'h8,4'h1}];
  mrd_res      = ftype_count[{4'h8,4'h2}];
  mwr_res      = ftype_count[{4'h8,4'h3}];
  mport_wr     = ftype_count[{4'h8,4'h4}];
  resp_wo_dpl  = ftype_count[{4'hD,4'h0}];
  resp_msg     = ftype_count[{4'hD,4'h1}];
  resp_with_dpl= ftype_count[{4'hD,4'h8}];
  
  // FC
  fc           = ftype_count[{4'h7,4'h0}];
  
  // DS
  ds           = ftype_count[{4'h9,4'h0}];
  
  // MSG
  db           = ftype_count[{4'hA,4'h0}];
  msg          = ftype_count[{4'hB,4'h0}];

  tot_gsm = rd_owner    + rd_own_owner  + iord_owner   + rd_home      + 
            rd_own_home + iord_home     + dkill_home   + ikill_home   + 
            tlbie       + tlbsync       + ird_home     + flush_wo_data+ 
            ikill_sharer+ dkill_sharer  + cast_out     + flush_wdata;  

  tot_io  = nrd         + ato_inc       + ato_dec      + ato_set      +
            ato_clr     + nwr           + nwr_r        + ato_swap     +
            ato_cswap   + ato_tswap     + swr          + mrd_req      +
            mwr_req     + mrd_res       + mwr_res      + mport_wr;

  tot_resp= resp_wo_dpl + resp_msg      + resp_with_dpl;

  tot_msg = db          + msg;  

  invalid_pkt = pkt_count - (tot_gsm + tot_io + tot_msg + tot_resp + fc + ds);


    `uvm_info("LL_MON", $sformatf("\n\
=========================================================================\n\
                       %s_MON_PKT_COUNT_DETAIL \n\
=========================================================================\n\n\
TOTAL IO PACKET COUNT---------------------------------------------:  %0d \n\
\n\
[nread        : %0d  ato_inc      : %0d  ato_dec      : %0d              \n\
 ato_set      : %0d  ato_clr      : %0d  n_wr         : %0d              \n\
 nwr_r        : %0d  ato_swap     : %0d  ato_comp_swap: %0d              \n\
 ato_test_swap: %0d  s_wr         : %0d  maint_rd_req : %0d              \n\
 maint_wr_req : %0d  maint_rd_res : %0d  maint_wr_res : %0d              \n\
 maint_port_wr: %0d  ]                                                   \n\
 \n\
TOTAL GSM PACKET COUNT--------------------------------------------:  %0d \n\
 \n\
[rd_owner     : %0d  rd_own_owner : %0d  io_rd_owner  : %0d              \n\
 rd_home      : %0d  rd_own_home  : %0d  io_rd_home   : %0d              \n\
 dkill_home   : %0d  ikill_home   : %0d  tlbie        : %0d              \n\
 tlbsync      : %0d  ird_home     : %0d  flush_wo_data: %0d              \n\
 ikill_sharer : %0d  dkill_sharer : %0d  cast_out     : %0d              \n\
 flush_wdata  : %0d ]                                                    \n\
 \n\
TOTAL MSG PACKET COUNT--------------------------------------------:  %0d \n\
[data_msg     : %0d   door_bell   : %0d]                                 \n\
 \n\
TOTAL FC PACKET COUNT---------------------------------------------:  %0d \n\
TOTAL DS PACKET COUNT---------------------------------------------:  %0d \n\
 \n\
TOTAL RESPONSE PACKET COUNT---------------------------------------:  %0d \n\
[resp_wo_dpl  : %0d  resp_with_dpl: %0d  msg_resp     : %0d]             \n\
 \n\
UNRECOGNIZED PACKET COUNT-----------------------------------------:  %0d \n\
 \n\
=========================================================================\n\
TOTAL                                                             :  %0d \n\
=========================================================================\n",

  ((mon_type == 1) ? "TX" : "RX"),tot_io, nrd, ato_inc, ato_dec, ato_set, 
  ato_clr, nwr, nwr_r, ato_swap,
  ato_cswap, ato_tswap, swr, mrd_req, mwr_req, mrd_res, mwr_res, mport_wr,
  tot_gsm, rd_owner, rd_own_owner, iord_owner, rd_home, rd_own_home,
  iord_home, dkill_home, ikill_home, tlbie, tlbsync, ird_home, flush_wo_data, 
  ikill_sharer, dkill_sharer, cast_out, flush_wdata,  
  tot_msg, msg, db, fc, ds,
  tot_resp, resp_wo_dpl, resp_with_dpl, resp_msg,
  invalid_pkt, pkt_count),UVM_LOW)

endfunction : display_pkt_details

////////////////////////////////////////////////////////////////////////////////
/// Name: oustanding_pkt_details \n 
/// Description: Function to report the outstanding packet details at the end \n
///              of simulation
/// oustanding_pkt_details
////////////////////////////////////////////////////////////////////////////////

function void srio_ll_txrx_monitor::oustanding_pkt_details();
  bit [72:0] mindex;
  bit [71:0] d_index;
  bit [72:0] req_index;
  bit [ 5:0] mail_box;
  int        done_seg;
  srio_trans outstanding_resp_array [bit[72:0]];
  srio_ll_msg_assembly msg_array[bit[72:0]];
   bit [72:0] copy_index;
  msg_array.delete;

  if (mon_type) 
  begin // {
    `ifdef VCS_ASS_ARR_FIX
     foreach (`TX_EXP_RESP_ARRAY[copy_index]) outstanding_resp_array[copy_index] = `TX_EXP_RESP_ARRAY[copy_index]; 
     foreach (`TX_MSG_ARRAY[copy_index]) msg_array[copy_index] = `TX_MSG_ARRAY[copy_index]; 
    `else
    outstanding_resp_array = `TX_EXP_RESP_ARRAY; 
    msg_array = `TX_MSG_ARRAY; 
    `endif
  end // }
  else 
  begin // {
    `ifdef VCS_ASS_ARR_FIX
     foreach (`RX_EXP_RESP_ARRAY[copy_index]) outstanding_resp_array[copy_index] = `RX_EXP_RESP_ARRAY[copy_index]; 
     foreach (`RX_MSG_ARRAY[copy_index]) msg_array[copy_index] = `RX_MSG_ARRAY[copy_index]; 
    `else
    outstanding_resp_array = `RX_EXP_RESP_ARRAY; 
    msg_array = `RX_MSG_ARRAY; 
    `endif
  end // }

  if (msg_array.first(mindex)) 
  begin // {
    do // {
      begin // {
        if (msg_array[mindex].msg_type) 
          mail_box = mindex[5:4]; 
        else
          mail_box = {mindex[3:0], mindex[5:4]}; 

        done_seg = 0;
        for (int i= 0; i < 16; i++)
        begin // {
          if (msg_array[mindex].seg_list.exists(i[3:0]))
            done_seg = done_seg + msg_array[mindex].seg_list[i[3:0]];
        end // }

        if (done_seg != msg_array[mindex].msg_len+1)
        begin // {
          `uvm_warning("SRIO_LL_PROTOCOL_CHECKER - Incomplete Message", 
          $sformatf("Letter: %0h h; Mail Box: %0h h; \
          Segment Count--- Expected: %0h h; Received: %0h h",
          mindex[7:6], mail_box, msg_array[mindex].msg_len+1, done_seg))
        end // }
      end // }
    while (msg_array.next(mindex));  // }
  end // }

  if (ds_array.first(d_index)) 
  begin // {
    do // {
      begin // {
        `uvm_warning("SRIO_LL_PROTOCOL_CHECKER - Incomplete DS", 
        $sformatf("\n \
        Cos: %0h h; DPL Received: %0h h",  
        d_index, ds_array[d_index].length_received))
      end // }
    while (ds_array.next(d_index));  // }
  end // }

  if (outstanding_resp_array.first(req_index)) 
  begin // {
    do // {
      begin // {
        if(req_index[8])
        begin // {
          if (outstanding_resp_array[req_index].msg_type) 
          begin // {
            mail_box = req_index[5:4]; 
            `uvm_warning("SRIO_LL_PROTOCOL_CHECKER - Outstanding MSeg Msg Req", 
            $sformatf("\n \
            Letter: %0h h; Mail Box: %0h h; Msg_Segment: %0h h;", 
            req_index[7:6], mail_box, req_index[3:0]));
          end // } 
          else
          begin // {
            mail_box = {req_index[3:0], req_index[5:4]}; 
            `uvm_warning("SRIO_LL_PROTOCOL_CHECKER - Outstanding Sseg Msg Req", 
            $sformatf("\n \
            Letter: %0h h; Mail Box: %0h h", 
            req_index[7:6], mail_box));
          end // } 
        end // }
        else
        begin // {
          `uvm_warning("SRIO_LL_PROTOCOL_CHECKER - Outstanding Req(other than Msg)", 
          $sformatf("TID: %0h h; Ftype: %0h h;", 
          req_index[7:0], outstanding_resp_array[req_index].ftype));
        end // }
      end // }
    while (outstanding_resp_array.next(req_index));  // }
  end // }
 
endfunction : oustanding_pkt_details

// =============================================================================

