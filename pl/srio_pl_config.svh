/////////////////////////////////////////////////////////////////////////////////////////////////
///(c) Copyright 2013 Mobiveil, Inc. All rights reserved
///
/// File       :  srio_pl_config.sv
/// Project    :  srio vip
/// Purpose    :  PL agent configuration fields.
/// Author     :  Mobiveil
///
/// Physical layer agent configuration class.
///
///
///////////////////////////////////////////////////////////////////////////////////////////////////

/// Config class for PL Agent.

class srio_pl_config extends uvm_object;

  `uvm_object_utils(srio_pl_config)


  virtual srio_interface srio_if;			///< Virtual interface.

  // Properties

  uvm_active_passive_enum is_active = UVM_ACTIVE;	///< Active or passive agent.

  bit has_checks = 1;  					///< checks enable
  bit has_coverage = 0;					///< coverage enable

  baud_rate_class baud_rate_class_support = BRC2;	///< Baud rate class supported
//  spec_version spec_support = V21;			///< Specification version supported

  int max_lanes_support = 4;				///< Maximum lanes supported

  int comma_cnt_threshold = 127;			///< Comma characters threshold used by SYNC SM
  int clk_compensation_seq_rate = 5000;			///< Clock compensation sequence rate interms of code groups

  int sync_break_threshold = 3;				///< Invalid symbols threshold to break SYNC in a lane
  int vmin_sync_threshold = 1024;			///< Vmin threshold used by SYNC SM
  int valid_sync_threshold = 255;			///< Valid symbols threshold that is to be checked once an 
							///< invalid character is received.

  int k_cnt_for_idle_detection = 4;			///< No. of K characters to match to detect receiving IDLE sequence.
  int m_cnt_for_idle_detection = 5;			///< No. of M characters to match to detect receiving IDLE sequence.

  int align_threshold = 4;				///< Align threshold to declare lane alignment.
  int lane_misalignment_threshold = 4;			///< Misalignment threshold to break alignment.

  int ism_status_cs_sent = 15;				///< No. of status control symbols to be sent
							///< as part of link initialization.
  int ism_status_cs_rx = 7;				///< No. of status control symbols to be received 
							///< as part of link initialization.

  int code_group_sent_2_cs = 1024;			///< Status control symbols rate in terms of code groups.

  bit tx_scr_en = 1;					///< scrambling enable

  bit idle_sel = 1;                                     ///< when 1 idle2 else idle1

  integer bfm_discovery_timer = 19200;			///< Discover timer count
  integer bfm_silence_timer = 2040;			///< Silence timer count
  integer bfm_recovery_timer = 19200;			///< Recovery timer count

  integer lp_discovery_timer = 19200;			///< Link partner Discover timer count
  integer lp_silence_timer = 2040;			///< Link partner Silence timer count
  integer lp_recovery_timer = 19200;			///< Link partner recovery timer count

  bit pkt_retry_support = 1;				///< Packet retry control symbol support
  bit idle_seq_check_en = 1;				///< Idle sequence check enable
  bit force_reinit_en = 1;				///< force re-initialization enable

  int ackid_threshold  = 4095;				///< Outstanding AckID supported.
  int buffer_space = 16;				///< Buffer space used for priority re-ordering.

  bit force_1x_mode_en = 1;				///< force 1x mode enable.
  bit force_laner_en = 1;				///< force laneR enable.
  bit aet_en = 0;					///< AET enable.
  int aet_command_period = 8000;			///< AET period for command timeout. 

  aet_cmd_drive_kind aet_cmd_kind = CMD_ENABLED;	///< AET Command Drive Enable/Disable.
  int aet_cmd_cnt  = 4;                                 ///< No of AET command to drive
  aet_cmd_type aet_cmd_type = TAPPLUS;                  ///< AET command type
  aet_tplus_kind aet_tplus_kind = TP_INCR;              ///< AET TAPPLUS command kind
  aet_tminus_kind aet_tminus_kind = TM_INCR;            ///< AET TAPMINUS command kind
							///< Valid only when AET_enable is 1.
  int cs_field_ack_timer = 8000;			///< Ack timeout for an AET command.
							///< Valid only when AET_enable is 1.

  flow_control flow_control_mode = RECEIVE;		///< Flow contorl mode supported.

  brc12_stype0_type default_cs_stype0 = STATUS;		///< Default stype0 transmitted.
  brc12_stype1_type default_cs_stype1 = NOP;		///< Default stype1 transmitted.

  int buffer_rel_min_val=10;                            ///< Buffer release min value
  int buffer_rel_max_val=25;                            ///< Buffer release max value

  int link_timeout = 50000;				///< Link timeout count

  int vc_ct_mode = 0;					///< VCs operating in CT mode. Encoding same as "CT Mode"
							///< field of "Port n VC CSR"
  int vc_refresh_int = 1024;				///< VC Refresh interval.
  int vc_status_cs_rate = 1024;				///< VC_status control symbol rate in terms of code groups.

  bit brc3_training_mode = 0;				///< 1 - Long run support, 0 - Short run support.
							///< Valid only if BRC3 is supported.

  int tap_minus_min_value = 0;				///< Minimum value for Tap minus emphasis
  int tap_minus_max_value = 0;				///< Maximum value for Tap minus emphasis
  int tap_minus_rst_value = 10;				///< Reset value for Tap minus emphasis
  int tap_minus_prst_value = 7;				///< Preset value for Tap minus emphasis
  int tap_plus_min_value = 0;				///< Minimum value for Tap plus emphasis
  int tap_plus_max_value = 0;				///< Maximum value for Tap plus emphasis
  int tap_plus_rst_value = 10;				///< Reset value for Tap plus emphasis
  int tap_plus_prst_value = 7;				///< Preset value for Tap plus emphasis
  int def_Tap = 0;					///< Default tap selected for BRC3.
  int tap_rst_value = 0;				///< Reset value for any Tap
  int tap_preset_value = 0;				///< Preset value for any Tap
  int aet_training_period = 10000;			///< Period after which receiver_trained will be set if no
							///< emphasis commands are available.
  // dme training fields
  dme_trn_cmd_drive_kind dme_cmd_kind = DME_CMD_ENABLED;	///< AET Command Drive Enable/Disable.
  int dme_cmd_cnt  = 4;                                 	///< No of AET command to drive
  dme_cmd_type dme_cmd_type = DME_INCR;                  	///< AET command type
  dme_cmd_tap_type dme_tap_type = DME_CMD_COEF0;
  dme_coef0_kind dme_coef0_kind = COEF0_INCR;              	///< C0 DME command kind
  dme_coefplus1_kind dme_coefplus1_kind = COEFPLUS1_INCR;       ///< CP1 DME command kind
  dme_coefminus1_kind dme_coefminus1_kind = COEFMINUS1_INCR;    ///< CN1 DME command kind

  int coef0_min_value  = 0;				///< Minimum value for DMe C0 coefficient.
  int coef0_max_value  = 0;				///< Maximum value for DMe C0 coefficient.

  int coefplus1_min_value  = 0;				///< Minimum value for DMe CP1 coefficient.
  int coefplus1_max_value  = 0;				///< Maximum value for DMe CP1 coefficient.

  int coefminus1_min_value  = 0;			///< Minimum value for DMe CN1 coefficient.
  int coefminus1_max_value  = 0;			///< Maximum value for DMe CN1 coefficient.

  int dme_wait_timer_frame_cnt=10;			///< No. of DME frames to be sent before moving to TRAINED state.

  cw_trn_cmd_drive_kind cw_cmd_kind = CW_CMD_ENABLED;	///< AET Command Drive Enable/Disable.
  int cw_cmd_cnt  = 4;                                 	///< No of AET command to drive
  cw_cmd_type cw_cmd_type = CW_INCR;                  	///< AET command type
  cw_cmd_tap_type cw_tap_type = CW_CMD_TAP0;		///< Default Tap for codeword command
  cw_tp0_kind cw_tp0_kind = TP0_INCR;              	///< Default Tap0 command kind.
  cw_tplus1_kind cw_tplus1_kind = TPLUS1_INCR;          ///< Default Tap(+)1 command kind.
  cw_tplus2_kind cw_tplus2_kind = TPLUS2_INCR;          ///< Default Tap(+)2 command kind.
  cw_tplus3_kind cw_tplus3_kind = TPLUS3_INCR;          ///< Default Tap(+)3 command kind.
  cw_tplus4_kind cw_tplus4_kind = TPLUS4_INCR;          ///< Default Tap(+)4 command kind.
  cw_tplus5_kind cw_tplus5_kind = TPLUS5_INCR;          ///< Default Tap(+)5 command kind.
  cw_tplus6_kind cw_tplus6_kind = TPLUS6_INCR;          ///< Default Tap(+)6 command kind.
  cw_tplus7_kind cw_tplus7_kind = TPLUS7_INCR;          ///< Default Tap(+)7 command kind.
  cw_tminus8_kind cw_tminus8_kind = TMINUS8_INCR;       ///< Default Tap(-)8 command kind.
  cw_tminus7_kind cw_tminus7_kind = TMINUS7_INCR;       ///< Default Tap(-)7 command kind.
  cw_tminus6_kind cw_tminus6_kind = TMINUS6_INCR;       ///< Default Tap(-)6 command kind.
  cw_tminus5_kind cw_tminus5_kind = TMINUS5_INCR;       ///< Default Tap(-)5 command kind.
  cw_tminus4_kind cw_tminus4_kind = TMINUS4_INCR;       ///< Default Tap(-)4 command kind.
  cw_tminus3_kind cw_tminus3_kind = TMINUS3_INCR;       ///< Default Tap(-)3 command kind.
  cw_tminus2_kind cw_tminus2_kind = TMINUS2_INCR;       ///< Default Tap(-)2 command kind.
  cw_tminus1_kind cw_tminus1_kind = TMINUS1_INCR;       ///< Default Tap(-)1 command kind.


  //tap0 
  int tap0_min_value  = 0;		///< Minimum value for Tap0
  int tap0_max_value  = 0;		///< Maximum value for Tap0
  int tap0_init_value  = 10;		///< Initialize value for Tap0
  int tap0_prst_value  = 7;		///< Preset value for Tap0
  bit tap0_impl_en    = 1; 		///< Tap0 implementation status
 
  //tap+1 
  int tplus1_min_value  = 0;		///< Minimum value for Tapplus1
  int tplus1_max_value  = 0;    	///< Maximum value for Tapplus1
  int tplus1_init_value  = 10;  	///< Initialize value for Tapplus1
  int tplus1_prst_value  = 7;   	///< Preset value for Tapplus1
  bit tplus1_impl_en    = 1;    	///< Tapplus1 implementation status

  //tap+2 
  int tplus2_min_value  = 0;		///< Minimum value for Tapplus2
  int tplus2_max_value  = 0;    	///< Maximum value for Tapplus2
  int tplus2_init_value  = 10;  	///< Initialize value for Tapplus2
  int tplus2_prst_value  = 7;   	///< Preset value for Tapplus2
  bit tplus2_impl_en    = 1;    	///< Tapplus2 implementation status

  //tap+3 
  int tplus3_min_value  = 0;		///< Minimum value for Tapplus3
  int tplus3_max_value  = 0;    	///< Maximum value for Tapplus3
  int tplus3_init_value  = 10;  	///< Initialize value for Tapplus3
  int tplus3_prst_value  = 7;   	///< Preset value for Tapplus3
  bit tplus3_impl_en    = 1;    	///< Tapplus3 implementation status

  //tap+4 
  int tplus4_min_value  = 0;		///< Minimum value for Tapplus4
  int tplus4_max_value  = 0;    	///< Maximum value for Tapplus4
  int tplus4_init_value  = 10;  	///< Initialize value for Tapplus4
  int tplus4_prst_value  = 7;   	///< Preset value for Tapplus4
  bit tplus4_impl_en    = 1;    	///< Tapplus4 implementation status

  //tap+5 
  int tplus5_min_value  = 0;		///< Minimum value for Tapplus5
  int tplus5_max_value  = 0;    	///< Maximum value for Tapplus5
  int tplus5_init_value  = 10;  	///< Initialize value for Tapplus5
  int tplus5_prst_value  = 7;   	///< Preset value for Tapplus5
  bit tplus5_impl_en    = 1;    	///< Tapplus5 implementation status

  //tap+6 
  int tplus6_min_value  = 0;		///< Minimum value for Tapplus6
  int tplus6_max_value  = 0;    	///< Maximum value for Tapplus6
  int tplus6_init_value  = 10;  	///< Initialize value for Tapplus6
  int tplus6_prst_value  = 7;   	///< Preset value for Tapplus6
  bit tplus6_impl_en    = 1;    	///< Tapplus6 implementation status

  //tap+7 
  int tplus7_min_value  = 0;		///< Minimum value for Tapplus7
  int tplus7_max_value  = 0;    	///< Maximum value for Tapplus7
  int tplus7_init_value  = 10;  	///< Initialize value for Tapplus7
  int tplus7_prst_value  = 7;   	///< Preset value for Tapplus7
  bit tplus7_impl_en    = 1;    	///< Tapplus7 implementation status

  //tap-8 
  int tminus8_min_value  = 0;		///< Minimum value for Tapminus8
  int tminus8_max_value  = 0;   	///< Maximum value for Tapminus8
  int tminus8_init_value  = 10; 	///< Initialize value for Tapminus8
  int tminus8_prst_value  = 7;  	///< Preset value for Tapminus8
  bit tminus8_impl_en    = 1;   	///< Tapminus8 implementation status

  //tap-7 
  int tminus7_min_value  = 0;		///< Minimum value for Tapminus7
  int tminus7_max_value  = 0;   	///< Maximum value for Tapminus7
  int tminus7_init_value  = 10; 	///< Initialize value for Tapminus7
  int tminus7_prst_value  = 7;  	///< Preset value for Tapminus7
  bit tminus7_impl_en    = 1;   	///< Tapminus7 implementation status

  //tap-6 
  int tminus6_min_value  = 0;		///< Minimum value for Tapminus6
  int tminus6_max_value  = 0;   	///< Maximum value for Tapminus6
  int tminus6_init_value  = 10; 	///< Initialize value for Tapminus6
  int tminus6_prst_value  = 7;  	///< Preset value for Tapminus6
  bit tminus6_impl_en    = 1;   	///< Tapminus6 implementation status

  //tap-5 
  int tminus5_min_value  = 0;		///< Minimum value for Tapminus5
  int tminus5_max_value  = 0;		///< Maximum value for Tapminus5
  int tminus5_init_value  = 1;		///< Initialize value for Tapminus5 0
  int tminus5_prst_value  = 7;		///< Preset value for Tapminus5
  bit tminus5_impl_en    = 1;		///< Tapminus5 implementation status 

  //tap-4 
  int tminus4_min_value  = 0;		///< Minimum value for Tapminus4
  int tminus4_max_value  = 0;		///< Maximum value for Tapminus4
  int tminus4_init_value  = 1;		///< Initialize value for Tapminus4 0
  int tminus4_prst_value  = 7;		///< Preset value for Tapminus4
  bit tminus4_impl_en    = 1;		///< Tapminus4 implementation status 

  //tap-3 
  int tminus3_min_value  = 0;		///< Minimum value for Tapminus3
  int tminus3_max_value  = 0;   	///< Maximum value for Tapminus3
  int tminus3_init_value  = 10; 	///< Initialize value for Tapminus3
  int tminus3_prst_value  = 7;  	///< Preset value for Tapminus3
  bit tminus3_impl_en    = 1;   	///< Tapminus3 implementation status

  //tap-2 
  int tminus2_min_value  = 0;		///< Minimum value for Tapminus2
  int tminus2_max_value  = 0;   	///< Maximum value for Tapminus2
  int tminus2_init_value  = 10; 	///< Initialize value for Tapminus2
  int tminus2_prst_value  = 7;  	///< Preset value for Tapminus2
  bit tminus2_impl_en    = 1;   	///< Tapminus2 implementation status

  //tap-1 
  int tminus1_min_value  = 0;		///< Minimum value for Tapminus1
  int tminus1_max_value  = 0;   	///< Maximum value for Tapminus1
  int tminus1_init_value  = 10; 	///< Initialize value for Tapminus1
  int tminus1_prst_value  = 7;  	///< Preset value for Tapminus1
  bit tminus1_impl_en    = 1;   	///< Tapminus1 implementation status

  int cw_training_ack_timeout_period = 8000;		///< ACK/NAK timeperiod for CW training.

  int cw_training_cmd_deassertion_period = 8000;	///< Timeperiod within which cmd has to return to "hold" incase of CW training.

  int gen3_training_timer = 30000;			///< Timeperiod within which CW training/re-training  or DME training has to complete

  int gen3_keep_alive_assert_timer = 8000;		///< Timeperiod after which keep_alive has to be asserted in TRAINED state.

  int gen3_keep_alive_deassert_timer = 8000;		///< Timeperiod after which keep_alive has to be deasserted once asserted.

  int bfm_dme_training_c0_preset_value = 20;		///< Preset value for c0 tap.
  int bfm_dme_training_cp1_preset_value = 0;		///< Preset value for cp1 tap.
  int bfm_dme_training_cn1_preset_value = 0;		///< Preset value for cn1 tap.

  int bfm_dme_training_c0_init_value = 0;		///< Initialize value for c0 tap.
  int bfm_dme_training_cp1_init_value = 0;		///< Initialize value for cp1 tap.
  int bfm_dme_training_cn1_init_value = 0;		///< Initialize value for cn1 tap.

  int bfm_dme_training_c0_min_value = 0;		///< Minimum value for c0 tap.
  int bfm_dme_training_cp1_min_value = 0;		///< Minimum value for cp1 tap.
  int bfm_dme_training_cn1_min_value = 0;		///< Minimum value for cn1 tap.

  int bfm_dme_training_c0_max_value = 20;		///< Maximum value for c0 tap.
  int bfm_dme_training_cp1_max_value = 15;		///< Maximum value for cp1 tap.
  int bfm_dme_training_cn1_max_value = 10;		///< Maximum value for cn1 tap.

  int lp_dme_training_c0_preset_value = 20;		///< Preset value for c0 tap.
  int lp_dme_training_cp1_preset_value = 0;		///< Preset value for cp1 tap.
  int lp_dme_training_cn1_preset_value = 0;		///< Preset value for cn1 tap.

  int lp_dme_training_c0_init_value = 0;		///< Initialize value for c0 tap.
  int lp_dme_training_cp1_init_value = 0;		///< Initialize value for cp1 tap.
  int lp_dme_training_cn1_init_value = 0;		///< Initialize value for cn1 tap.

  int lp_dme_training_c0_min_value = 0;			///< Minimum value for c0 tap.
  int lp_dme_training_cp1_min_value = 0;		///< Minimum value for cp1 tap.
  int lp_dme_training_cn1_min_value = 0;		///< Minimum value for cn1 tap.

  int lp_dme_training_c0_max_value = 20;		///< Maximum value for c0 tap.
  int lp_dme_training_cp1_max_value = 15;		///< Maximum value for cp1 tap.
  int lp_dme_training_cn1_max_value = 10;		///< Maximum value for cn1 tap.


  bit retrain_en = 1;					///< Retraining is enabled
  
  int idle2_data_field_len = 512;			///< Length of IDLE2 pseudo-random data characters.
  int max_pkt_size = 276;				///< Maximum packet size.
  int gen3_max_pkt_size = 288;				///< GEN3 Maximum packet size.

  ack_gen_kind pkt_acc_gen_kind = PL_IMMEDIATE;		///< Packet acknowledgement generation delay control.
  pkt_resp_kind pl_response_gen_mode= PL_PKT_IMMEDIATE;
  bit response_en = 1;					///< Response generation enable
  int pl_response_delay_min=5;				///< Minimum delay after which a PKT_ACC is generated.
  int pl_response_delay_max=20;				///< Maximum delay before which a PKT_ACC is generated.
  bit ackid_status_pnack_support = 0;			///< Parameter0 field of PKT_NACC when BRC3 
  bit multiple_ack_support = 0;				///< Multiple acknowledgement support.

  bit timestamp_sync_support = 0;			///< Timestamp synchronization support.
  bit timestamp_master_slave_support = 0;		///< Timestamp master slave support. 1: Master, 0: Slave.
  bit timestamp_auto_update_en = 0;			///< Timestamp auto update enable.

  int timestamp_auto_update_timer = 5024;		///< Indicates the time in which the timestamp sequence has to be sent by the master
							///< automatically. Valid only if both timestamp_sync_support and 
							///< timestamp_master_slave_support are 1.

  int seed_ord_seq_rate = 49;				///< Seed ordered sequence rate.
  int status_cntl_ord_seq_rate_min = 16;		///< Minimum codewords allowed inbetween 2 Status and control ordered sequence.
  int status_cntl_ord_seq_rate_max = 49;		///< Maximum codewords allowed inbetween 2 Status and control ordered sequence.

  bit cs_merge_en = 1;					///< Controls control symbol/packet merging functionality.
  bit cs_embed_en = 1;					///< Controls control symbol embedding functionality.

  int pkt_accept_prob = 100;                            ///< Probability for sending out pacc control symbol
  int pkt_na_prob = 0;					///< Probability for sending out Pnacc control symbol.
  int pkt_retry_prob = 0;				///< Probability for sending out pkt retry control symbol.

  int pkt_ack_delay_min = 5;                            ///< pkt ack delay min value 
  int pkt_ack_delay_max = 15;                           ///< pkt ack delay max value

  int brc3_v_cnt_threshold = 64;			///< BRC3 V_counter threshold. Used in Codeword lock state machine.
  int brc3_iv_slip = 4;					///< BRC3 IVslip
  int brc3_ds_cnt_threshold = 4;			///< BRC3 DS_counter threshold. Used in Sync state machine.
  int lock_break_threshold = 3;				///< Invalid symbols threshold to break Codeword lock in a lane
  int sync1_state_ui_cnt_threshold = 65536;		///< Unit intervals to wait before moving to SYNC_2 state

  bit [0:15] skew_en;                                  	///< skew enable lane 0

  int skew_min[0:15];                                 	///< skew min value for lane0
  
  int skew_max[0:15];                                 	///< skew min value for lane0

  bit nx_mode_support = 1;				///< Nx mode supported.
  bit x2_mode_support = 1;				///< 2x mode supported.

  bit asymmetric_support = 0;				///< Asymmetric mode support.

  bit asym_1x_mode_en = 0;				///< Asymmetric 1x mode enable.
  bit asym_2x_mode_en = 0;				///< Asymmetric 2x mode enable.
  bit asym_nx_mode_en = 0;				///< Asymmetric Nx mode enable.

  int xmt_width_timer = 10000;			///< Timeperiod within Transmit width command has to complete.
  int rcv_width_timer = 10000;			///< Timeperiod within Receive width command has to complete.

  int xmt_my_cmd_timer = 10000;			///< Timeperiod within my Transmit width command has to be acknowledged.
  int xmt_lp_cmd_timer = 10000;			///< Timeperiod within  Link Partner Transmit width command has to be acknowledged.
  int idle2_seq_len_min = 548;                  ///< Minimum Idle2 sequence Length  
  int idle2_seq_len_max = 554;                  ///< Maximum Idle2 sequence Length 
  
  bit parallel_dme_slip_adj_en= 0;               ///< Enable slip adjustments for DME in parallel mode
  bit parallel_cw_slip_adj_en= 0;               ///< Enable slip adjustments for CW in parallel mode
 /// Methods

  extern function new (string name = "srio_pl_config");

endclass


///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : New
/// Description : Constructor method for srio_pl_config class.
///////////////////////////////////////////////////////////////////////////////////////////////
function srio_pl_config::new(string name = "srio_pl_config");
  super.new(name);
endfunction : new
