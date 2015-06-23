////////////////////////////////////////////////////////////////////////////////
//
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_func_coverage.sv
// Project :  srio vip
// Purpose :  Physical Layer Functional Coverage
// Author  :  Mobiveil
//
// Contains PL layer related coverpoints.
// 
//////////////////////////////////////////////////////////////////////////////// 

 `include "srio_pl_fc_macro.sv" 

typedef enum {PD_SOP, PD_EOP, PD_STOMP, RESTART_RETRY, LINK_REQ_RESET_PORT, 
  LINK_REQ_RESET_DEV, LINK_REQ_INP_STAT, LINK_RESPONSE, STAT_CS, NON_STAT_CS, SRIO_PKT} pl_symbol;
typedef enum {RT_MODE, CT_MODE} traffic_mode;

class srio_pl_func_coverage extends uvm_component;

  `uvm_component_utils(srio_pl_func_coverage)
  
  virtual srio_interface srio_if;
  srio_env_config env_config;
  srio_pl_agent pl_agent;
  srio_trans tx_trans;
  srio_trans rx_trans;
  event      tx_trans_event, rx_trans_event;
  event      sm_variable;
  srio_pl_tx_trans_collector tx_trans_collector;
  srio_pl_rx_trans_collector rx_trans_collector;
  bit [8:0] tx_payload_length;
  bit [8:0] rx_payload_length;
  pl_symbol rx_pl_symbol;
  pl_symbol tx_pl_symbol;
  bit tx_idle1_detected;
  bit tx_idle2_detected;
  bit rx_idle1_detected;
  bit rx_idle2_detected;
  traffic_mode serial_traffic_mode;
  bit [7:0] vc_num_support;
  bit [7:0] ct_mode;
  bit embedded_cs;
  bit packet_open;

  bit divide_clk;
  bit dme_frame_divide_clk;
  bit sim_clk;
  integer number_of_lanes;
  baud_rate srio_baud_rate;
  /// SYNC SM variables
  sync_sm_states sync_sm_lane0;
  sync_sm_states sync_sm_lane1;
  sync_sm_states sync_sm_lane2;
  sync_sm_states sync_sm_lane3;
  sync_sm_states sync_sm_lane4;
  sync_sm_states sync_sm_lane5;
  sync_sm_states sync_sm_lane6;
  sync_sm_states sync_sm_lane7;
  sync_sm_states sync_sm_lane8;
  sync_sm_states sync_sm_lane9;
  sync_sm_states sync_sm_lane10;
  sync_sm_states sync_sm_lane11;
  sync_sm_states sync_sm_lane12;
  sync_sm_states sync_sm_lane13;
  sync_sm_states sync_sm_lane14;
  sync_sm_states sync_sm_lane15;
  align_sm_states lane_2x_align_state;
  align_sm_states lane_nx_align_state;
  mode_detect_sm_states mode_detect_state;
  frame_lock_sm_states gen3_frame_lock_sm_lane0;
  frame_lock_sm_states gen3_frame_lock_sm_lane1;
  frame_lock_sm_states gen3_frame_lock_sm_lane2;
  frame_lock_sm_states gen3_frame_lock_sm_lane3;
  frame_lock_sm_states gen3_frame_lock_sm_lane4;
  frame_lock_sm_states gen3_frame_lock_sm_lane5;
  frame_lock_sm_states gen3_frame_lock_sm_lane6;
  frame_lock_sm_states gen3_frame_lock_sm_lane7;
  frame_lock_sm_states gen3_frame_lock_sm_lane8;
  frame_lock_sm_states gen3_frame_lock_sm_lane9;
  frame_lock_sm_states gen3_frame_lock_sm_lane10;
  frame_lock_sm_states gen3_frame_lock_sm_lane11;
  frame_lock_sm_states gen3_frame_lock_sm_lane12;
  frame_lock_sm_states gen3_frame_lock_sm_lane13;
  frame_lock_sm_states gen3_frame_lock_sm_lane14;
  frame_lock_sm_states gen3_frame_lock_sm_lane15;
  dme_training_coeff_update_states gen3_c0_coeff_update_sm_lane0;
  dme_training_coeff_update_states gen3_c0_coeff_update_sm_lane1;
  dme_training_coeff_update_states gen3_c0_coeff_update_sm_lane2;
  dme_training_coeff_update_states gen3_c0_coeff_update_sm_lane3;
  dme_training_coeff_update_states gen3_c0_coeff_update_sm_lane4;
  dme_training_coeff_update_states gen3_c0_coeff_update_sm_lane5;
  dme_training_coeff_update_states gen3_c0_coeff_update_sm_lane6;
  dme_training_coeff_update_states gen3_c0_coeff_update_sm_lane7;
  dme_training_coeff_update_states gen3_c0_coeff_update_sm_lane8;
  dme_training_coeff_update_states gen3_c0_coeff_update_sm_lane9;
  dme_training_coeff_update_states gen3_c0_coeff_update_sm_lane10;
  dme_training_coeff_update_states gen3_c0_coeff_update_sm_lane11;
  dme_training_coeff_update_states gen3_c0_coeff_update_sm_lane12;
  dme_training_coeff_update_states gen3_c0_coeff_update_sm_lane13;
  dme_training_coeff_update_states gen3_c0_coeff_update_sm_lane14;
  dme_training_coeff_update_states gen3_c0_coeff_update_sm_lane15;
  dme_training_coeff_update_states gen3_cp1_coeff_update_sm_lane0;
  dme_training_coeff_update_states gen3_cp1_coeff_update_sm_lane1;
  dme_training_coeff_update_states gen3_cp1_coeff_update_sm_lane2;
  dme_training_coeff_update_states gen3_cp1_coeff_update_sm_lane3;
  dme_training_coeff_update_states gen3_cp1_coeff_update_sm_lane4;
  dme_training_coeff_update_states gen3_cp1_coeff_update_sm_lane5;
  dme_training_coeff_update_states gen3_cp1_coeff_update_sm_lane6;
  dme_training_coeff_update_states gen3_cp1_coeff_update_sm_lane7;
  dme_training_coeff_update_states gen3_cp1_coeff_update_sm_lane8;
  dme_training_coeff_update_states gen3_cp1_coeff_update_sm_lane9;
  dme_training_coeff_update_states gen3_cp1_coeff_update_sm_lane10;
  dme_training_coeff_update_states gen3_cp1_coeff_update_sm_lane11;
  dme_training_coeff_update_states gen3_cp1_coeff_update_sm_lane12;
  dme_training_coeff_update_states gen3_cp1_coeff_update_sm_lane13;
  dme_training_coeff_update_states gen3_cp1_coeff_update_sm_lane14;
  dme_training_coeff_update_states gen3_cp1_coeff_update_sm_lane15;
  dme_training_coeff_update_states gen3_cn1_coeff_update_sm_lane0;
  dme_training_coeff_update_states gen3_cn1_coeff_update_sm_lane1;
  dme_training_coeff_update_states gen3_cn1_coeff_update_sm_lane2;
  dme_training_coeff_update_states gen3_cn1_coeff_update_sm_lane3;
  dme_training_coeff_update_states gen3_cn1_coeff_update_sm_lane4;
  dme_training_coeff_update_states gen3_cn1_coeff_update_sm_lane5;
  dme_training_coeff_update_states gen3_cn1_coeff_update_sm_lane6;
  dme_training_coeff_update_states gen3_cn1_coeff_update_sm_lane7;
  dme_training_coeff_update_states gen3_cn1_coeff_update_sm_lane8;
  dme_training_coeff_update_states gen3_cn1_coeff_update_sm_lane9;
  dme_training_coeff_update_states gen3_cn1_coeff_update_sm_lane10;
  dme_training_coeff_update_states gen3_cn1_coeff_update_sm_lane11;
  dme_training_coeff_update_states gen3_cn1_coeff_update_sm_lane12;
  dme_training_coeff_update_states gen3_cn1_coeff_update_sm_lane13;
  dme_training_coeff_update_states gen3_cn1_coeff_update_sm_lane14;
  dme_training_coeff_update_states gen3_cn1_coeff_update_sm_lane15;

  init_sm_states prev_init_state,init_sm_1x_2x_nx_state;
  bit in_port_retry_state;
  bit out_port_retry_state;
  bit in_port_error_state;
  bit out_port_error_state;
  bit two_lanes_aligned;
  bit x1_mode_delimiter;
  bit x2_mode_delimiter;
  bit x1_mode_detected;
  bit x2_a_col_detected;			///< Column of A detected in 2X align sm.
  bit nx_a_col_detected;			///< Column of A detected in NX align sm.
  int x2_a_counter;
  int nx_a_counter;
  int x2_MA_counter;
  int nx_MA_counter;
  int i_counter0;
  int i_counter1;
  int i_counter2;
  int i_counter3;
  int i_counter4;
  int i_counter5;
  int i_counter6;
  int i_counter7;
  int i_counter8;
  int i_counter9;
  int i_counter10;
  int i_counter11;
  int i_counter12;
  int i_counter13;
  int i_counter14;
  int i_counter15;
  int k_counter0;
  int k_counter1;
  int k_counter2;
  int k_counter3;
  int k_counter4;
  int k_counter5;
  int k_counter6;
  int k_counter7;
  int k_counter8;
  int k_counter9;
  int k_counter10;
  int k_counter11;
  int k_counter12;
  int k_counter13;
  int k_counter14;
  int k_counter15;
  int v_counter0;
  int v_counter1;
  int v_counter2;
  int v_counter3;
  int v_counter4;
  int v_counter5;
  int v_counter6;
  int v_counter7;
  int v_counter8;
  int v_counter9;
  int v_counter10;
  int v_counter11;
  int v_counter12;
  int v_counter13;
  int v_counter14;
  int v_counter15;
  bit x2_align_err;
  bit nx_align_err;
  int D_counter;
  bit disc_timer_start;
  bit disc_timer_done;
  bit disc_timer_en;
  bit force_1x_mode;
  bit force_laneR;
  bit force_reinit;
  bit idle_selection_done;
  bit lane_ready0;
  bit lane_ready1;
  bit lane_ready2;
  bit lane_ready3;
  bit lane_ready4;
  bit lane_ready5;
  bit lane_ready6;
  bit lane_ready7;
  bit lane_ready8;
  bit lane_ready9;
  bit lane_ready10;
  bit lane_ready11;
  bit lane_ready12;
  bit lane_ready13;
  bit lane_ready14;
  bit lane_ready15;
  bit lane_sync0;
  bit lane_sync1;
  bit lane_sync2;
  bit lane_sync3;
  bit lane_sync4;
  bit lane_sync5;
  bit lane_sync6;
  bit lane_sync7;
  bit lane_sync8;
  bit lane_sync9;
  bit lane_sync10;
  bit lane_sync11;
  bit lane_sync12;
  bit lane_sync13;
  bit lane_sync14;
  bit lane_sync15;
  bit lanes01_drvr_oe;
  bit lanes02_drvr_oe;
  bit lanes13_drvr_oe;
  bit N_lanes_aligned;
  bit N_lanes_drvr_oe;
  bit N_lanes_ready;
  bit port_initialized;
  bit link_initialized;
  bit receive_lane1;
  bit receive_lane2;
  bit rcvr_trained0;
  bit rcvr_trained1;
  bit rcvr_trained2;
  bit rcvr_trained3;
  bit rcvr_trained4;
  bit rcvr_trained5;
  bit rcvr_trained6;
  bit rcvr_trained7;
  bit rcvr_trained8;
  bit rcvr_trained9;
  bit rcvr_trained10;
  bit rcvr_trained11;
  bit rcvr_trained12;
  bit rcvr_trained13;
  bit rcvr_trained14;
  bit rcvr_trained15;
  bit signal_detect0;
  bit signal_detect1;
  bit signal_detect2;
  bit signal_detect3;
  bit signal_detect4;
  bit signal_detect5;
  bit signal_detect6;
  bit signal_detect7;
  bit signal_detect8;
  bit signal_detect9;
  bit signal_detect10;
  bit signal_detect11;
  bit signal_detect12;
  bit signal_detect13;
  bit signal_detect14;
  bit signal_detect15;
  bit silence_timer_done;
  bit silence_timer_en;
  bit        tx_idle_seq_in_pkt;
  bit        tx_idle_seq_in_scs;
  bit        tx_idle_seq_in_lcs;
  bit        tx_clk_comp_seq;
  bit        rx_clk_comp_seq;
  bit        tx_no_clk_comp_seq;
  bit        tx_clk_comp_seq_unaligned;
  int        tx_idle1_A_char_interval;
  bit        tx_idle2_seq_corrupted;
  int        tx_idle2_random_data_length;
  int        rx_idle2_random_data_length;
  bit [2:0]  tx_idle2_active_link_width;
  bit [2:0]  rx_idle2_active_link_width;
  bit [4:0]  tx_idle2_lane_num;
  bit [4:0]  rx_idle2_lane_num;
  bit        tx_idle2_cs_field_marker_corrupt;
  bit        tx_idle2_cs_field_corrupt;
  bit [0:63] tx_idle2_cs_field;
  bit [0:63] rx_idle2_cs_field;
  bit        tx_sync_seq;
  bit        rx_sync_seq;
  bit        idle2_idle1_detected;
  bit        tx_status_cs_blocked;
  bit        tx_idle1_seq_corrupted;
  bit        tx_idle2_seq_unaligned;
  bit        tx_invalid_pkt_acc_cs;
  bit        tx_invalid_pkt_na_cs;
  bit        tx_pkt_ackID_corrupt;
  bit        tx_lcs_without_end_delimiter;
  bit        tx_invalid_ackID;

  /// GEN3 variables
  bit tx_idle3_detected;
  bit rx_idle3_detected;
  bit timestamp_support;
  bit timestamp_master_support;
  bit timestamp_slave_support;
  bit cw_lock_lane0;
  bit cw_lock_lane1;
  bit cw_lock_lane2;
  bit cw_lock_lane3;
  bit cw_lock_lane4;
  bit cw_lock_lane5;
  bit cw_lock_lane6;
  bit cw_lock_lane7;
  bit cw_lock_lane8;
  bit cw_lock_lane9;
  bit cw_lock_lane10;
  bit cw_lock_lane11;
  bit cw_lock_lane12;
  bit cw_lock_lane13;
  bit cw_lock_lane14;
  bit cw_lock_lane15;
  bit asym_mode;
  bit asymmode;
  bit pism_silent;

  bit [0:66]tx_brc3_cg[16];
  bit [0:66]rx_brc3_cg[16];

  bit [2:0] xmt_width_port_req_cmd;
  bit       retrain_en;

  bit       tx_lane_trained[16];
  bit       rx_lane_trained[16];

  bit       tx_lane_degraded[16];
  bit       rx_lane_degraded[16];

  bit       tx_lane_sync[16];
  bit       rx_lane_sync[16];
  bit       lane_sync[16];

  bit       rx_lane_ready[16];
  bit       tx_lane_ready[16];

  bit [2:0] tx_equi_cmd;
  bit [2:0] tx_equi_sts;
  bit [2:0] rx_equi_cmd;
  bit [2:0] rx_equi_sts;

  bit       tx_lane_degraded_trained_sync[16];
  bit       rx_lane_degraded_trained_sync[16];

  bit       length_8bit_boundary              = 0;
  bit       length_non8bit_boundary           = 0;
  bit       pkt_terminating_8bit_boundary     = 0; 
  bit       pkt_terminating_non_8bit_boundary = 0;
  bit       tx_diffos_difflane;

  brc3_cntl_cw_func_type rx_ctrl_cw_func_type[16];
  brc3_cntl_cw_func_type tx_ctrl_cw_func_type[16];
  brc3_cntl_cw_func_type tx_ctrl_cw_fn_type;
  brc3_cntl_cw_func_type tx_ctrl_cw_func_type_lane[16];

  pl_symbol tx_eop_seedos_linkreq;
  pl_symbol rx_eop_seedos_linkreq;

  bit rx_inverted_cg[16];
  bit tx_inverted_cg[16];

  bit rcvd_startcw_in_opencontext     = 0;        // CSB CW instead of CSEB/CSE CW
  bit rcvd_endcw_in_closedcontext     = 0;        // CSE/CSEB instead of CSB
  bit rcvd_data_insteadof_endcw       = 0;        // DATA CW instead of CSE/CSEB
  bit rcvd_interrupted_timestamp_cs   = 0;        // Received interrupted Timestamp CS
  bit rcvd_uninterrupted_timestamp_cs = 0;        // Received un-interrupted Timestamp CS

  bit rcvd_seedos_linkreq             = 0;        // Seed os followed by link req
  bit lanechk_cw_correct_bip          = 0;
  bit lanechk_cw_corrupt_bip          = 0;

  bit rcvd_idle3_with_invalid_cw      = 0;
  bit rcvd_idle3_with_diffcw_err      = 0;

  sync_sm_states gen3_sync_sm_lane0;
  sync_sm_states gen3_sync_sm_lane1;
  sync_sm_states gen3_sync_sm_lane2;
  sync_sm_states gen3_sync_sm_lane3;
  sync_sm_states gen3_sync_sm_lane4;
  sync_sm_states gen3_sync_sm_lane5;
  sync_sm_states gen3_sync_sm_lane6;
  sync_sm_states gen3_sync_sm_lane7;
  sync_sm_states gen3_sync_sm_lane8;
  sync_sm_states gen3_sync_sm_lane9;
  sync_sm_states gen3_sync_sm_lane10;
  sync_sm_states gen3_sync_sm_lane11;
  sync_sm_states gen3_sync_sm_lane12;
  sync_sm_states gen3_sync_sm_lane13;
  sync_sm_states gen3_sync_sm_lane14;
  sync_sm_states gen3_sync_sm_lane15;
  cw_lock_sm_states cw_lock_sm0;
  cw_lock_sm_states cw_lock_sm1;
  cw_lock_sm_states cw_lock_sm2;
  cw_lock_sm_states cw_lock_sm3;
  cw_lock_sm_states cw_lock_sm4;
  cw_lock_sm_states cw_lock_sm5;
  cw_lock_sm_states cw_lock_sm6;
  cw_lock_sm_states cw_lock_sm7;
  cw_lock_sm_states cw_lock_sm8;
  cw_lock_sm_states cw_lock_sm9;
  cw_lock_sm_states cw_lock_sm10;
  cw_lock_sm_states cw_lock_sm11;
  cw_lock_sm_states cw_lock_sm12;
  cw_lock_sm_states cw_lock_sm13;
  cw_lock_sm_states cw_lock_sm14;
  cw_lock_sm_states cw_lock_sm15;
  link_train_sm_states long_run_link_train_sm0;
  link_train_sm_states long_run_link_train_sm1;
  link_train_sm_states long_run_link_train_sm2;
  link_train_sm_states long_run_link_train_sm3;
  link_train_sm_states long_run_link_train_sm4;
  link_train_sm_states long_run_link_train_sm5;
  link_train_sm_states long_run_link_train_sm6;
  link_train_sm_states long_run_link_train_sm7;
  link_train_sm_states long_run_link_train_sm8;
  link_train_sm_states long_run_link_train_sm9;
  link_train_sm_states long_run_link_train_sm10;
  link_train_sm_states long_run_link_train_sm11;
  link_train_sm_states long_run_link_train_sm12;
  link_train_sm_states long_run_link_train_sm13;
  link_train_sm_states long_run_link_train_sm14;
  link_train_sm_states long_run_link_train_sm15;
  link_train_sm_states short_run_link_train_sm0;
  link_train_sm_states short_run_link_train_sm1;
  link_train_sm_states short_run_link_train_sm2;
  link_train_sm_states short_run_link_train_sm3;
  link_train_sm_states short_run_link_train_sm4;
  link_train_sm_states short_run_link_train_sm5;
  link_train_sm_states short_run_link_train_sm6;
  link_train_sm_states short_run_link_train_sm7;
  link_train_sm_states short_run_link_train_sm8;
  link_train_sm_states short_run_link_train_sm9;
  link_train_sm_states short_run_link_train_sm10;
  link_train_sm_states short_run_link_train_sm11;
  link_train_sm_states short_run_link_train_sm12;
  link_train_sm_states short_run_link_train_sm13;
  link_train_sm_states short_run_link_train_sm14;
  link_train_sm_states short_run_link_train_sm15;
  align_sm_states gen3_lane_2x_align_state;
  align_sm_states gen3_lane_nx_align_state;
  init_sm_states gen3_init_sm_1x_2x_nx_state;
  retrain_xmt_width_ctrl_sm_states retrain_xmt_width_ctrl_state;
  xmt_width_cmd_sm_states xmt_width_cmd_state;
  xmt_width_sm_states xmt_width_state;
  rcv_width_cmd_sm_states rcv_width_cmd_state;
  rcv_width_sm_states rcv_width_state;

// =============================================================================

  // Covergroups for TX Code Word for lanes 0 to 15 

  `CG_GEN3_PL_TX_CODE_WORD(0)
  `CG_GEN3_PL_TX_CODE_WORD(1)
  `CG_GEN3_PL_TX_CODE_WORD(2)
  `CG_GEN3_PL_TX_CODE_WORD(3)
  `CG_GEN3_PL_TX_CODE_WORD(4)
  `CG_GEN3_PL_TX_CODE_WORD(5)
  `CG_GEN3_PL_TX_CODE_WORD(6)
  `CG_GEN3_PL_TX_CODE_WORD(7)
  `CG_GEN3_PL_TX_CODE_WORD(8)
  `CG_GEN3_PL_TX_CODE_WORD(9)
  `CG_GEN3_PL_TX_CODE_WORD(10)
  `CG_GEN3_PL_TX_CODE_WORD(11)
  `CG_GEN3_PL_TX_CODE_WORD(12)
  `CG_GEN3_PL_TX_CODE_WORD(13)
  `CG_GEN3_PL_TX_CODE_WORD(14)
  `CG_GEN3_PL_TX_CODE_WORD(15)

// =============================================================================

  // Covergroups for RX Code Word for lanes 0 to 15 

  `CG_GEN3_PL_RX_CODE_WORD(0)
  `CG_GEN3_PL_RX_CODE_WORD(1)
  `CG_GEN3_PL_RX_CODE_WORD(2)
  `CG_GEN3_PL_RX_CODE_WORD(3)
  `CG_GEN3_PL_RX_CODE_WORD(4)
  `CG_GEN3_PL_RX_CODE_WORD(5)
  `CG_GEN3_PL_RX_CODE_WORD(6)
  `CG_GEN3_PL_RX_CODE_WORD(7)
  `CG_GEN3_PL_RX_CODE_WORD(8)
  `CG_GEN3_PL_RX_CODE_WORD(9)
  `CG_GEN3_PL_RX_CODE_WORD(10)
  `CG_GEN3_PL_RX_CODE_WORD(11)
  `CG_GEN3_PL_RX_CODE_WORD(12)
  `CG_GEN3_PL_RX_CODE_WORD(13)
  `CG_GEN3_PL_RX_CODE_WORD(14)
  `CG_GEN3_PL_RX_CODE_WORD(15)

// =============================================================================

  // Covergroups for TX OS for lanes 0 to 15 

  `CG_GEN3_PL_TX_OS(0)                        
  `CG_GEN3_PL_TX_OS(1)                        
  `CG_GEN3_PL_TX_OS(2)                        
  `CG_GEN3_PL_TX_OS(3)                        
  `CG_GEN3_PL_TX_OS(4)                        
  `CG_GEN3_PL_TX_OS(5)                        
  `CG_GEN3_PL_TX_OS(6)                        
  `CG_GEN3_PL_TX_OS(7)                        
  `CG_GEN3_PL_TX_OS(8)                        
  `CG_GEN3_PL_TX_OS(9)                        
  `CG_GEN3_PL_TX_OS(10)                       
  `CG_GEN3_PL_TX_OS(11)                       
  `CG_GEN3_PL_TX_OS(12)                       
  `CG_GEN3_PL_TX_OS(13)                       
  `CG_GEN3_PL_TX_OS(14)                       
  `CG_GEN3_PL_TX_OS(15)                       

// =============================================================================

  // Covergroups for RX OS for lanes 0 to 15 

  `CG_GEN3_PL_RX_OS(0) 
  `CG_GEN3_PL_RX_OS(1) 
  `CG_GEN3_PL_RX_OS(2) 
  `CG_GEN3_PL_RX_OS(3) 
  `CG_GEN3_PL_RX_OS(4) 
  `CG_GEN3_PL_RX_OS(5) 
  `CG_GEN3_PL_RX_OS(6) 
  `CG_GEN3_PL_RX_OS(7) 
  `CG_GEN3_PL_RX_OS(8) 
  `CG_GEN3_PL_RX_OS(9) 
  `CG_GEN3_PL_RX_OS(10)
  `CG_GEN3_PL_RX_OS(11)
  `CG_GEN3_PL_RX_OS(12)
  `CG_GEN3_PL_RX_OS(13)
  `CG_GEN3_PL_RX_OS(14)
  `CG_GEN3_PL_RX_OS(15)

// =============================================================================

  covergroup CG_GEN3_PL_TX_SEEDOS_LINKREQ_SEQ;     
    option.per_instance = 1;                         
                                                     
    CP_PL_LANE_WIDTH: 
      coverpoint number_of_lanes {
        bins lane_width[] = { 1, 2, 4, 8, 16 };}

    CP_PL_TX_SEED_OS_LINK_REQUEST_CS:                
      coverpoint rcvd_seedos_linkreq {               
        bins seedos_linkreq = {1};}  

    CR_PL_SEEDOS_LINKREQ_LANEWIDTH:
      cross CP_PL_LANE_WIDTH, CP_PL_TX_SEED_OS_LINK_REQUEST_CS;

  endgroup: CG_GEN3_PL_TX_SEEDOS_LINKREQ_SEQ     

// =============================================================================

  covergroup  CG_GEN3_PL_CRC @(tx_trans_event); 
    option.per_instance = 1;
    CP_PL_TX_CORRUPT_CRC32:        
      coverpoint tx_trans.crc32_err {
        bins crc32_err_transmitted = {1};}
  endgroup:CG_GEN3_PL_CRC
// =============================================================================

  covergroup CG_GEN3_PL_LENGTH @(tx_trans_event);                          
    option.per_instance = 1;
    CP_PL_TX_PACKET_LENGTH:         
      coverpoint ({tx_trans.brc3_stype1_msb, tx_trans.stype1, tx_trans.cmd}) {
        bins eop_unpadded_length_8multiple           = {8'b0001_0000};    
        bins eop_padded_length_not8multiple          = {8'b0001_0001};     
        wildcard bins sop_unpadded_length_8multiple  = {8'b10??_????};     
        wildcard bins sop_padded_length_not8multiple = {8'b11??_????};}     
  endgroup: CG_GEN3_PL_LENGTH

// =============================================================================

  covergroup CG_GEN3_PL_TERMINATING_PKT_LENGTH1; 
    option.per_instance = 1;
    CP_PL_TX_PACKET_BOUNDARY:        
      coverpoint pkt_terminating_8bit_boundary { 
        bins terminating_pkt_len_8multiple = {1};} 
  endgroup: CG_GEN3_PL_TERMINATING_PKT_LENGTH1

// =============================================================================

  covergroup CG_GEN3_PL_TERMINATING_PKT_LENGTH2; 
    option.per_instance = 1;
    CP_PL_TX_PACKET_BOUNDARY:        
      coverpoint pkt_terminating_non_8bit_boundary {
        bins terminating_pkt_len_not8multiple = {1};} 
  endgroup: CG_GEN3_PL_TERMINATING_PKT_LENGTH2

// =============================================================================

  // Covergroups for RX AET for lanes 0 to 15 

  `CG_GEN3_PL_RX_AET(0)
  `CG_GEN3_PL_RX_AET(1)
  `CG_GEN3_PL_RX_AET(2)
  `CG_GEN3_PL_RX_AET(3)
  `CG_GEN3_PL_RX_AET(4)
  `CG_GEN3_PL_RX_AET(5)
  `CG_GEN3_PL_RX_AET(6)
  `CG_GEN3_PL_RX_AET(7)
  `CG_GEN3_PL_RX_AET(8)
  `CG_GEN3_PL_RX_AET(9)
  `CG_GEN3_PL_RX_AET(10)
  `CG_GEN3_PL_RX_AET(11)
  `CG_GEN3_PL_RX_AET(12)
  `CG_GEN3_PL_RX_AET(13)
  `CG_GEN3_PL_RX_AET(14)
  `CG_GEN3_PL_RX_AET(15)

// =============================================================================

  // Covergroups for TX AET for lanes 0 to 15 

  `CG_GEN3_PL_TX_AET(0)
  `CG_GEN3_PL_TX_AET(1)
  `CG_GEN3_PL_TX_AET(2)
  `CG_GEN3_PL_TX_AET(3)
  `CG_GEN3_PL_TX_AET(4)
  `CG_GEN3_PL_TX_AET(5)
  `CG_GEN3_PL_TX_AET(6)
  `CG_GEN3_PL_TX_AET(7)
  `CG_GEN3_PL_TX_AET(8)
  `CG_GEN3_PL_TX_AET(9)
  `CG_GEN3_PL_TX_AET(10)
  `CG_GEN3_PL_TX_AET(11)
  `CG_GEN3_PL_TX_AET(12)
  `CG_GEN3_PL_TX_AET(13)
  `CG_GEN3_PL_TX_AET(14)
  `CG_GEN3_PL_TX_AET(15)

// =============================================================================

  // Covergroups for TX AET Command and Status for lanes 0 to 15 

  `CG_GEN3_PL_TX_AET_TAP_CMDSTS(0)
  `CG_GEN3_PL_TX_AET_TAP_CMDSTS(1)
  `CG_GEN3_PL_TX_AET_TAP_CMDSTS(2)
  `CG_GEN3_PL_TX_AET_TAP_CMDSTS(3)
  `CG_GEN3_PL_TX_AET_TAP_CMDSTS(4)
  `CG_GEN3_PL_TX_AET_TAP_CMDSTS(5)
  `CG_GEN3_PL_TX_AET_TAP_CMDSTS(6)
  `CG_GEN3_PL_TX_AET_TAP_CMDSTS(7)
  `CG_GEN3_PL_TX_AET_TAP_CMDSTS(8)
  `CG_GEN3_PL_TX_AET_TAP_CMDSTS(9)
  `CG_GEN3_PL_TX_AET_TAP_CMDSTS(10)
  `CG_GEN3_PL_TX_AET_TAP_CMDSTS(11)
  `CG_GEN3_PL_TX_AET_TAP_CMDSTS(12)
  `CG_GEN3_PL_TX_AET_TAP_CMDSTS(13)
  `CG_GEN3_PL_TX_AET_TAP_CMDSTS(14)
  `CG_GEN3_PL_TX_AET_TAP_CMDSTS(15)

// =============================================================================

  // Covergroups for RX AET Command and Status for lanes 0 to 15 

  `CG_GEN3_PL_RX_AET_TAP_CMDSTS(0)
  `CG_GEN3_PL_RX_AET_TAP_CMDSTS(1)
  `CG_GEN3_PL_RX_AET_TAP_CMDSTS(2)
  `CG_GEN3_PL_RX_AET_TAP_CMDSTS(3)
  `CG_GEN3_PL_RX_AET_TAP_CMDSTS(4)
  `CG_GEN3_PL_RX_AET_TAP_CMDSTS(5)
  `CG_GEN3_PL_RX_AET_TAP_CMDSTS(6)
  `CG_GEN3_PL_RX_AET_TAP_CMDSTS(7)
  `CG_GEN3_PL_RX_AET_TAP_CMDSTS(8)
  `CG_GEN3_PL_RX_AET_TAP_CMDSTS(9)
  `CG_GEN3_PL_RX_AET_TAP_CMDSTS(10)
  `CG_GEN3_PL_RX_AET_TAP_CMDSTS(11)
  `CG_GEN3_PL_RX_AET_TAP_CMDSTS(12)
  `CG_GEN3_PL_RX_AET_TAP_CMDSTS(13)
  `CG_GEN3_PL_RX_AET_TAP_CMDSTS(14)
  `CG_GEN3_PL_RX_AET_TAP_CMDSTS(15)

// =============================================================================

  covergroup  CG_GEN3_PL_ASYMMETRY;                          
    option.per_instance = 1;

    CP_PL_TX_WIDTH_PORT_REQ:       
      coverpoint xmt_width_port_req_cmd{
        bins no_req           = {3'h0};
        bins req_transmit_1x  = {3'h1};
        bins req_transmit_2x  = {3'h2};
        }

   CP_PL_ASYMMETRY_MODE:        
      coverpoint asymmode;   
 
   CR_PL_TX_WIDTH_PORT_CMD_ASYM:         
     cross CP_PL_TX_WIDTH_PORT_REQ, CP_PL_ASYMMETRY_MODE { 
        ignore_bins asym_mode = binsof(CP_PL_ASYMMETRY_MODE) intersect {0};}

  endgroup: CG_GEN3_PL_ASYMMETRY

/// =============================================================================

  covergroup CG_GEN3_PL_TSG; 
    option.per_instance = 1;
    CP_PL_TSG_UNINTERRUPTED:        
      coverpoint rcvd_uninterrupted_timestamp_cs {   
        bins uninterrupted_timestamp_cs = {1};}   
  endgroup: CG_GEN3_PL_TSG

// =============================================================================

  covergroup CG_PL;
    option.per_instance = 1;
    CP_PL_LANE_WIDTH: 
      coverpoint number_of_lanes {
        bins lane_width[] = { 1, 2, 4, 8, 16 };}
    CP_PL_DATA_RATE : coverpoint srio_baud_rate;
    CR_PL_LANE_WIDTH_DATA_RATE : cross CP_PL_LANE_WIDTH, CP_PL_DATA_RATE;
  endgroup

// =============================================================================

  covergroup CG_PL_TX @(tx_trans_event);
    option.per_instance = 1;
    CP_PL_TX_ACK_ID : coverpoint tx_trans.ackid
                      {
                        bins ackid_range1 = {[0:1023]};
                        bins ackid_range2 = {[1024:2047]};
                        bins ackid_range3 = {[2048:3071]};
                        bins ackid_range4 = {[3072:4095]};
                      }
    CP_PL_TX_CS_TYPE : coverpoint tx_trans.cstype
                       {
                         bins cs_type_gen2[] = {CS24, CS48};
                         bins cs_type_gen3 = {CS64};
                       }
    CP_PL_TX_VC : coverpoint tx_trans.vc;
    CP_PL_TX_PRIO : coverpoint tx_trans.prio;
    CP_PL_TX_CRF : coverpoint tx_trans.crf;
    CR_PL_TX_VC_PRIO_CRF : cross CP_PL_TX_VC, CP_PL_TX_PRIO, CP_PL_TX_CRF;
    CP_PL_TX_FTYPE_TTYPE : coverpoint tx_trans.ttype
                           {
                             bins type1[]  = {[0:2]}                  iff (tx_trans.ftype==1);
                             bins type2[]  = {[0:15]}                 iff (tx_trans.ftype==2);
                             bins type5[]  = {0, 1, 4, 5, 12, 13, 14} iff (tx_trans.ftype==5);
                             bins type6    = {0}                      iff (tx_trans.ftype==6);
                             bins type7    = {0}                      iff (tx_trans.ftype==7);
                             bins type8[]  = {[0:4]}                  iff (tx_trans.ftype==8);
                             bins type9    = {0}                      iff (tx_trans.ftype==9);
                             bins type10   = {0}                      iff (tx_trans.ftype==10);
                             bins type11   = {0}                      iff (tx_trans.ftype==11);
                             bins type13[] = {0, 1, 8}                iff (tx_trans.ftype==13);
                           }  
                         
    CR_PL_TX_VC_PRIO_CRF_FTYPE_TTYPE: 
      cross CP_PL_TX_VC, CP_PL_TX_PRIO, CP_PL_TX_CRF, CP_PL_TX_FTYPE_TTYPE {
        ignore_bins req_prio = binsof(CP_PL_TX_PRIO) intersect {3} && (binsof(CP_PL_TX_FTYPE_TTYPE.type1) || binsof(CP_PL_TX_FTYPE_TTYPE.type2) || binsof(CP_PL_TX_FTYPE_TTYPE.type5) || binsof(CP_PL_TX_FTYPE_TTYPE.type6) || binsof(CP_PL_TX_FTYPE_TTYPE.type8) || binsof(CP_PL_TX_FTYPE_TTYPE.type9) || binsof(CP_PL_TX_FTYPE_TTYPE.type10) || binsof(CP_PL_TX_FTYPE_TTYPE.type11));
        ignore_bins type7_1 = binsof(CP_PL_TX_PRIO) && binsof(CP_PL_TX_CRF) intersect {0} && binsof(CP_PL_TX_FTYPE_TTYPE.type7);
        ignore_bins type7_2 = binsof(CP_PL_TX_PRIO) intersect {[0:2]} && binsof(CP_PL_TX_CRF) intersect {1} && binsof(CP_PL_TX_FTYPE_TTYPE.type7);
        ignore_bins vc0_type13 = binsof(CP_PL_TX_VC) intersect {0} && binsof(CP_PL_TX_PRIO) intersect {0} && binsof(CP_PL_TX_FTYPE_TTYPE.type13);
        ignore_bins vc0_type = binsof(CP_PL_TX_VC) intersect {1} && 
          (binsof(CP_PL_TX_FTYPE_TTYPE.type1) || binsof(CP_PL_TX_FTYPE_TTYPE.type2) ||  
           binsof(CP_PL_TX_FTYPE_TTYPE.type5) intersect {0, 1, 5, 12, 13, 14} || 
           binsof(CP_PL_TX_FTYPE_TTYPE.type8) intersect{[0:3]} || binsof(CP_PL_TX_FTYPE_TTYPE.type13) || 
           binsof(CP_PL_TX_FTYPE_TTYPE.type10) || binsof(CP_PL_TX_FTYPE_TTYPE.type11));
                                       }
    CP_PL_TX_PACKET_PAD_ZEROS    : coverpoint tx_trans.pad
                                   {
                                     bins valid_pad[] = {0, 2};
                                   }
    CP_PL_TX_PACKET_EARLY_CRC    : coverpoint tx_trans.early_crc
                                   {
                                     bins no_crc = {0};
                                     bins valid_crc = {[1:16'hFFFF]};
                                   }
    CP_PL_TX_PACKET_FINAL_CRC    : coverpoint tx_trans.final_crc
                                   {
                                     bins no_crc = {0};
                                     bins valid_crc = {[1:16'hFFFF]};
                                   }
    CR_PL_TX_PACKET_PAD_ZEROS_EARLY_CRC_FINAL_CRC : cross CP_PL_TX_PACKET_PAD_ZEROS, CP_PL_TX_PACKET_EARLY_CRC, CP_PL_TX_PACKET_FINAL_CRC;
    CP_PL_TX_PACKET_EARLY_CRC_CORRUPT    : coverpoint tx_trans.early_crc_err;
    CP_PL_TX_PACKET_FINAL_CRC_CORRUPT    : coverpoint tx_trans.final_crc_err;
    CP_PL_TX_PACKET_DOUBLE_EARLY_CRC_CORRUPT : coverpoint tx_trans.early_crc_err
                                               {
                                                 bins early_crc_corrupt[] = {0,1} iff (tx_trans.payload.size() > 80);
                                               }
    CP_PL_TX_PACKET_DOUBLE_FINAL_CRC_CORRUPT : coverpoint tx_trans.final_crc_err
                                               {
                                                 bins final_crc_corrupt[] = {0,1} iff (tx_trans.payload.size() > 80);
                                               }
    CR_PL_TX_PACKET_DOUBLE_EARLY_CRC_LAST_CORRUPT : cross CP_PL_TX_PACKET_DOUBLE_EARLY_CRC_CORRUPT, CP_PL_TX_PACKET_DOUBLE_FINAL_CRC_CORRUPT;
    CP_PL_TX_PACKET_LENGTH : coverpoint tx_payload_length
                             {
                               bins size_zero        = {0};
                               bins size_small       = {[8:64]};
                               bins size_mandatory[] = {72, 80, 88, 96};
                               bins size_medium      = {[104:136]};
                               bins size_large       = {[144:248]};
                               bins size_256         = {256};
                               bins size_greater_256 = {[257:$]};    
                             }
    CP_PL_TX_STYPE0 : coverpoint tx_trans.stype0
                      {
                        ignore_bins invalid_values = {[7:10], 12, 13, 14, 15};
                      }
    CR_PL_TX_CSTYPE_STYPE0 : cross CP_PL_TX_CS_TYPE, CP_PL_TX_STYPE0
                             {
                               ignore_bins gen3_bins = binsof(CP_PL_TX_CS_TYPE) intersect {CS24, CS48} && binsof(CP_PL_TX_STYPE0) intersect {11, 13};
                             }
    CP_PL_TX_PARAMETER0 : coverpoint tx_trans.param0
                          {
                            bins param0[] = {[0:63]};
                          }
    CP_PL_TX_PARAMETER1 : coverpoint tx_trans.param1
                          {
                            bins param1[] = {2, 3, 4, 5, 6, 7, 16, 63};
                          }
 
    CP_PL_TX_PACKET_NA_PARAM1 : coverpoint tx_trans.param1
                                {
                                  bins cause[] = {[1:7], 8'h1F} iff (tx_trans.stype0==2);
                                }
    CP_PL_TX_STYPE1 : coverpoint tx_trans.stype1
                      {
                        ignore_bins invalid_values = {6};
                      }
    CP_PL_TX_CMD : coverpoint tx_trans.cmd
                      {
                        bins cmd[] = {0, 2, 3, 4};
                      }
    CR_PL_TX_STYPE1_CMD : cross CP_PL_TX_STYPE1, CP_PL_TX_CMD
                          {
                            ignore_bins bin0 = binsof(CP_PL_TX_STYPE1) intersect {0} && (binsof(CP_PL_TX_CMD) intersect {3} || binsof(CP_PL_TX_CMD) intersect {4} || binsof(CP_PL_TX_CMD) intersect {2});
                            ignore_bins bin1 = binsof(CP_PL_TX_STYPE1) intersect {1} && (binsof(CP_PL_TX_CMD) intersect {3} || binsof(CP_PL_TX_CMD) intersect {4} || binsof(CP_PL_TX_CMD) intersect {2});
                            ignore_bins bin2 = binsof(CP_PL_TX_STYPE1) intersect {2} && (binsof(CP_PL_TX_CMD) intersect {3} || binsof(CP_PL_TX_CMD) intersect {4} || binsof(CP_PL_TX_CMD) intersect {2});
                            ignore_bins bin3 = binsof(CP_PL_TX_STYPE1) intersect {3} && (binsof(CP_PL_TX_CMD) intersect {3} || binsof(CP_PL_TX_CMD) intersect {4} || binsof(CP_PL_TX_CMD) intersect {2});
                            ignore_bins bin4 = binsof(CP_PL_TX_STYPE1) intersect {4} && binsof(CP_PL_TX_CMD) intersect {0};
                            ignore_bins bin5 = binsof(CP_PL_TX_STYPE1) intersect {5} && (binsof(CP_PL_TX_CMD) intersect {4} || binsof(CP_PL_TX_CMD) intersect {2});
                            ignore_bins bin6 = binsof(CP_PL_TX_STYPE1) intersect {7} && (binsof(CP_PL_TX_CMD) intersect {3} || binsof(CP_PL_TX_CMD) intersect {4} || binsof(CP_PL_TX_CMD) intersect {2});
                          }
    CR_PL_TX_CS_TYPE_STYPE1_CMD : cross CP_PL_TX_CS_TYPE, CP_PL_TX_STYPE1, CP_PL_TX_CMD
                                  {
                            ignore_bins bin0 = binsof(CP_PL_TX_STYPE1) intersect {0} && (binsof(CP_PL_TX_CMD) intersect {3} || binsof(CP_PL_TX_CMD) intersect {4} || binsof(CP_PL_TX_CMD) intersect {2});
                            ignore_bins bin1 = binsof(CP_PL_TX_STYPE1) intersect {1} && (binsof(CP_PL_TX_CMD) intersect {3} || binsof(CP_PL_TX_CMD) intersect {4} || binsof(CP_PL_TX_CMD) intersect {2});
                            ignore_bins bin2 = binsof(CP_PL_TX_STYPE1) intersect {2} && (binsof(CP_PL_TX_CMD) intersect {3} || binsof(CP_PL_TX_CMD) intersect {4} || binsof(CP_PL_TX_CMD) intersect {2});
                            ignore_bins bin3 = binsof(CP_PL_TX_STYPE1) intersect {3} && (binsof(CP_PL_TX_CMD) intersect {3} || binsof(CP_PL_TX_CMD) intersect {4} || binsof(CP_PL_TX_CMD) intersect {2});
                            ignore_bins bin4 = binsof(CP_PL_TX_STYPE1) intersect {4} && binsof(CP_PL_TX_CMD) intersect {0};
                            ignore_bins bin5 = binsof(CP_PL_TX_STYPE1) intersect {5} && (binsof(CP_PL_TX_CMD) intersect {4} || binsof(CP_PL_TX_CMD) intersect {2});
                            ignore_bins bin6 = binsof(CP_PL_TX_STYPE1) intersect {7} && (binsof(CP_PL_TX_CMD) intersect {3} || binsof(CP_PL_TX_CMD) intersect {4} || binsof(CP_PL_TX_CMD) intersect {2});
                                  }
    CP_PL_TX_SCS_CORRUPT_CRC : coverpoint tx_trans.cs_crc5_err;
    CP_PL_TX_LCS_CORRUPT_CRC : coverpoint tx_trans.cs_crc13_err;
    CP_PL_TX_RESET_DEV_CMD_B2B : coverpoint tx_pl_symbol
                                 {
                                    bins b2b_4_cmds = (LINK_REQ_RESET_DEV => LINK_REQ_RESET_DEV => LINK_REQ_RESET_DEV => LINK_REQ_RESET_DEV);
                                    bins b2b_3_cmds_scs_1_cmd = (LINK_REQ_RESET_DEV => LINK_REQ_RESET_DEV => LINK_REQ_RESET_DEV => STAT_CS => LINK_REQ_RESET_DEV);
                                    bins b2b_2_cmds_scs_2_cmds = (LINK_REQ_RESET_DEV => LINK_REQ_RESET_DEV => STAT_CS => LINK_REQ_RESET_DEV => LINK_REQ_RESET_DEV);
                                    bins b2b_1_cmd_scs_3_cmds = (LINK_REQ_RESET_DEV => STAT_CS => LINK_REQ_RESET_DEV => LINK_REQ_RESET_DEV => LINK_REQ_RESET_DEV);
                                    bins b2b_3_cmds_nscs_1_cmd = (LINK_REQ_RESET_DEV => LINK_REQ_RESET_DEV => LINK_REQ_RESET_DEV => NON_STAT_CS => LINK_REQ_RESET_DEV);
                                    bins b2b_2_cmds_nscs_2_cmds = (LINK_REQ_RESET_DEV => LINK_REQ_RESET_DEV => NON_STAT_CS => LINK_REQ_RESET_DEV => LINK_REQ_RESET_DEV);
                                    bins b2b_1_cmd_nscs_3_cmds = (LINK_REQ_RESET_DEV => NON_STAT_CS => LINK_REQ_RESET_DEV => LINK_REQ_RESET_DEV => LINK_REQ_RESET_DEV);
                                    bins b2b_4_cmd_3_scs = (LINK_REQ_RESET_DEV => STAT_CS => LINK_REQ_RESET_DEV => STAT_CS => LINK_REQ_RESET_DEV => STAT_CS => LINK_REQ_RESET_DEV);
                                   }

    CP_PL_TX_IDLE1 : coverpoint tx_idle1_detected;
    CP_PL_TX_IDLE2 : coverpoint tx_idle2_detected;
    CP_PL_TX_CS_DELIMITER : coverpoint tx_trans.cs_kind;
    CP_PL_PORT_INITIALIZED : coverpoint port_initialized;
    CR_PL_TX_IDLE1_PORT_INITIALIZED : cross CP_PL_TX_IDLE1, CP_PL_PORT_INITIALIZED;
    CR_PL_TX_IDLE2_PORT_INITIALIZED : cross CP_PL_TX_IDLE2, CP_PL_PORT_INITIALIZED;
    CP_PL_LINK_INITIALIZED : coverpoint link_initialized;
    CR_PL_PORT_INITIALIZED_LINK_INITIALIZED_CS_DELIMITER : cross CP_PL_PORT_INITIALIZED, CP_PL_LINK_INITIALIZED, CP_PL_TX_CS_DELIMITER
                   {
                     ignore_bins bin1 = (binsof (CP_PL_PORT_INITIALIZED) intersect {0} || binsof (CP_PL_LINK_INITIALIZED) intersect {0}) && binsof (CP_PL_TX_CS_DELIMITER) intersect {SRIO_DELIM_PD};
                     ignore_bins bin2 = binsof (CP_PL_PORT_INITIALIZED) intersect {0} && binsof (CP_PL_LINK_INITIALIZED) intersect {1} && binsof (CP_PL_TX_CS_DELIMITER) intersect {SRIO_DELIM_SC};
                   }

    CP_PL_INPUT_ERROR_STOPPED_STATE_LINK_INIT : coverpoint link_initialized
                                                {
                                                  bins bin0 = {0} iff (in_port_error_state == 1);
                                                  bins bin1 = {1} iff (in_port_error_state == 1);
                                                }
    CP_PL_OUTPUT_ERROR_STOPPED_STATE_LINK_INIT : coverpoint link_initialized
                                                {
                                                  bins bin0 = {0} iff (out_port_error_state == 1);
                                                  bins bin1 = {1} iff (out_port_error_state == 1);
                                                }
    CP_PL_TX_EMBEDDED_CS_STYPE0 : coverpoint tx_trans.stype0
                               {
                                 bins valid_values[] = {[0:2], [4:6]} iff (embedded_cs == 1);
                               }
    CP_PL_TX_EMBEDDED_CS_STYPE1 : coverpoint tx_trans.stype1
                               {
                                 bins valid_values[] = {3, 5, 7} iff (embedded_cs == 1);
                               }
    CP_PL_PACKET_DELIMIT_SEQ : coverpoint tx_pl_symbol
                               {
                                 bins seq1 = (PD_SOP=>SRIO_PKT=>PD_EOP);
                                 bins seq2 = (PD_SOP=>SRIO_PKT=>PD_SOP);
                                 bins seq3 = (PD_SOP=>PD_STOMP);
                               }
    CP_PL_ACK_ID_SEQ : coverpoint tx_trans.ackid
                       {
                         bins seq1 = (0=>1);
                         bins seq3 = (1=>0);
                       }

    /// GEN3 coverpoints
    CP_PL_TX_IDLE3 : coverpoint tx_idle3_detected;
    CP_PL_TIMESTAMP_SUPPORT : coverpoint timestamp_support;
    CR_PL_TIMESTAMP_SUPPORT_CS_TYPE : cross CP_PL_TIMESTAMP_SUPPORT, CP_PL_TX_CS_TYPE;
    CP_PL_TIMESTAMP_MASTER_SUPPORT : coverpoint timestamp_master_support;
    CP_PL_TIMESTAMP_SLAVE_SUPPORT : coverpoint timestamp_slave_support;
 
    CP_BFM_TX_LINK_RESPONSE_INPUT_PORT_STATUS : coverpoint tx_trans.param1[1:2]
                                                {
                                                  bins valid_values = {[0:3]} iff (tx_trans.stype0==6);
                                                }
    CP_BFM_TX_LINK_RESPONSE_OUTPUT_PORT_STATUS : coverpoint tx_trans.param1[5:6]
                                                {
                                                  bins valid_values = {[0:3]} iff (tx_trans.stype0==6);
                                                }
    CP_BFM_TX_SOP_UNPADDED : coverpoint tx_trans.brc3_stype1_msb
                             {
                               bins sop_unpadded = {2};
                             }
    CP_BFM_TX_SOP_PADDED : coverpoint tx_trans.brc3_stype1_msb
                             {
                               bins sop_padded = {3};
                             }
    CP_PL_TX_RESET_PORT_CMD_B2B : coverpoint tx_pl_symbol
                                 {
                                    bins b2b_4_cmds = (LINK_REQ_RESET_PORT => LINK_REQ_RESET_PORT => LINK_REQ_RESET_PORT => LINK_REQ_RESET_PORT);
                                    bins b2b_3_cmds_scs_1_cmd = (LINK_REQ_RESET_PORT => LINK_REQ_RESET_PORT => LINK_REQ_RESET_PORT => STAT_CS => LINK_REQ_RESET_PORT);
                                    bins b2b_2_cmds_scs_2_cmds = (LINK_REQ_RESET_PORT => LINK_REQ_RESET_PORT => STAT_CS => LINK_REQ_RESET_PORT => LINK_REQ_RESET_PORT);
                                    bins b2b_1_cmd_scs_3_cmds = (LINK_REQ_RESET_PORT => STAT_CS => LINK_REQ_RESET_PORT => LINK_REQ_RESET_PORT => LINK_REQ_RESET_PORT);
                                    bins b2b_3_cmds_nscs_1_cmd = (LINK_REQ_RESET_PORT => LINK_REQ_RESET_PORT => LINK_REQ_RESET_PORT => NON_STAT_CS => LINK_REQ_RESET_PORT);
                                    bins b2b_2_cmds_nscs_2_cmds = (LINK_REQ_RESET_PORT => LINK_REQ_RESET_PORT => NON_STAT_CS => LINK_REQ_RESET_PORT => LINK_REQ_RESET_PORT);
                                    bins b2b_1_cmd_nscs_3_cmds = (LINK_REQ_RESET_PORT => NON_STAT_CS => LINK_REQ_RESET_PORT => LINK_REQ_RESET_PORT => LINK_REQ_RESET_PORT);
                                    bins b2b_4_cmd_3_scs = (LINK_REQ_RESET_PORT => STAT_CS => LINK_REQ_RESET_PORT => STAT_CS => LINK_REQ_RESET_PORT => STAT_CS => LINK_REQ_RESET_PORT);
                                   }
    CP_PL_SERIAL_TRAFFIC_MODE : coverpoint serial_traffic_mode;
    CP_PL_SERIAL_TRAFFIC_VC : coverpoint ct_mode
                              {
                                bins one_vc = {1} iff (vc_num_support == 1);
                                bins two_vc = {1,3} iff (vc_num_support == 2);
                                bins four_vc = {1, 3, 7} iff (vc_num_support == 4);
                                bins eight_vc = {1, 3, 7, 15} iff (vc_num_support == 8);
                              }

    CP_PL_BFM_RCVR_FLW_CTRL : coverpoint tx_trans.param1
                              {
                                bins rcvr_flw_ctrl[] = {31,63} iff ( (tx_trans.stype0==3'b000) || 
                                                               (tx_trans.stype0==3'b001) ||
                                                               (tx_trans.stype0==3'b100) ||
                                                               (tx_trans.stype0==3'b101)   );
                              }
  endgroup

// =============================================================================

  covergroup CG_PL_RX @(rx_trans_event);
    option.per_instance = 1;
    CP_PL_RX_ACK_ID : coverpoint rx_trans.ackid
                      {
                        bins ackid_range1 = {[0:1023]};
                        bins ackid_range2 = {[1024:2047]};
                        bins ackid_range3 = {[2048:3071]};
                        bins ackid_range4 = {[3072:4095]};
                      }
    CP_PL_RX_CS_TYPE : coverpoint rx_trans.cstype;
    CP_PL_RX_VC : coverpoint rx_trans.vc;
    CP_PL_RX_PRIO : coverpoint rx_trans.prio;
    CP_PL_RX_CRF : coverpoint rx_trans.crf;
    CR_PL_RX_VC_PRIO_CRF : cross CP_PL_RX_VC, CP_PL_RX_PRIO, CP_PL_RX_CRF;
    CP_PL_RX_FTYPE_TTYPE : coverpoint rx_trans.ttype
                           {
                             bins type1[]  = {[0:2]} iff (rx_trans.ftype==1);
                             bins type2[]  = {[0:15]} iff (rx_trans.ftype==2);
                             bins type5[]  = {0, 1, 4, 5, 12, 13, 14} iff (rx_trans.ftype==5);
                             bins type6    = {[0:15]} iff (rx_trans.ftype==6);
                             bins type7    = {[0:15]} iff (rx_trans.ftype==7);
                             bins type8[]  = {[0:4]} iff (rx_trans.ftype==8);
                             bins type9    = {[0:15]} iff (rx_trans.ftype==9);
                             bins type10   = {0} iff (rx_trans.ftype==10);
                             bins type11   = {0} iff (rx_trans.ftype==11);
                             bins type13[] = {0, 1, 8} iff (rx_trans.ftype==13);
                           }                           
    CR_PL_RX_VC_PRIO_CRF_FTYPE_TTYPE : cross CP_PL_RX_VC, CP_PL_RX_PRIO, CP_PL_RX_CRF, CP_PL_RX_FTYPE_TTYPE {
        ignore_bins req_prio = binsof(CP_PL_RX_PRIO) intersect {3} && (binsof(CP_PL_RX_FTYPE_TTYPE.type1) || binsof(CP_PL_RX_FTYPE_TTYPE.type2) || binsof(CP_PL_RX_FTYPE_TTYPE.type5) || binsof(CP_PL_RX_FTYPE_TTYPE.type6) || binsof(CP_PL_RX_FTYPE_TTYPE.type8) || binsof(CP_PL_RX_FTYPE_TTYPE.type9) || binsof(CP_PL_RX_FTYPE_TTYPE.type10) || binsof(CP_PL_RX_FTYPE_TTYPE.type11));
        ignore_bins type7_1 = binsof(CP_PL_RX_PRIO) && binsof(CP_PL_RX_CRF) intersect {0} && binsof(CP_PL_RX_FTYPE_TTYPE.type7);
        ignore_bins type7_2 = binsof(CP_PL_RX_PRIO) intersect {[0:2]} && binsof(CP_PL_RX_CRF) intersect {1} && binsof(CP_PL_RX_FTYPE_TTYPE.type7);
        ignore_bins vc0_type13 = binsof(CP_PL_RX_VC) intersect {0} && binsof(CP_PL_RX_PRIO) intersect {0} && binsof(CP_PL_RX_FTYPE_TTYPE.type13);
        ignore_bins vc0_type = binsof(CP_PL_RX_VC) intersect {1} && 
          (binsof(CP_PL_RX_FTYPE_TTYPE.type1) || binsof(CP_PL_RX_FTYPE_TTYPE.type2) ||  
           binsof(CP_PL_RX_FTYPE_TTYPE.type5) intersect {0, 1, 5, 12, 13, 14} || 
           binsof(CP_PL_RX_FTYPE_TTYPE.type8) intersect{[0:3]} || binsof(CP_PL_RX_FTYPE_TTYPE.type13) || 
           binsof(CP_PL_RX_FTYPE_TTYPE.type10) || binsof(CP_PL_RX_FTYPE_TTYPE.type11));
                                       } 
    CP_PL_RX_PACKET_PAD_ZEROS    : coverpoint rx_trans.pad
                      {
                        bins valid_pad[] = {0, 2};
                      }
    CP_PL_RX_PACKET_EARLY_CRC    : coverpoint rx_trans.early_crc
                                   {
                                     bins no_crc = {0};
                                     bins valid_crc = {[1:16'hFFFF]};
                                   }
    CP_PL_RX_PACKET_FINAL_CRC    : coverpoint rx_trans.final_crc
                                   {
                                     bins no_crc = {0};
                                     bins valid_crc = {[1:16'hFFFF]};
                                   }
    CR_PL_RX_PACKET_PAD_ZEROS_EARLY_CRC_FINAL_CRC : cross CP_PL_RX_PACKET_PAD_ZEROS, CP_PL_RX_PACKET_EARLY_CRC, CP_PL_RX_PACKET_FINAL_CRC;
    CP_PL_RX_PACKET_LENGTH : coverpoint rx_payload_length
                             {
                               bins size_zero        = {0};
                               bins size_small       = {[8:64]};
                               bins size_mandatory[] = {72, 80, 88, 96};
                               bins size_medium      = {[104:136]};
                               bins size_large       = {[144:248]};
                               bins size_256         = {256};
                             }
    CP_PL_RX_STYPE0 : coverpoint rx_trans.stype0
                      {
                        ignore_bins invalid_values = {[7:10], 12, 13, 14, 15};
                      }
    CR_PL_RX_CSTYPE_STYPE0 : cross CP_PL_RX_CS_TYPE, CP_PL_RX_STYPE0
                             {
                               ignore_bins gen3_bins = binsof(CP_PL_RX_CS_TYPE) intersect {CS24, CS48} && binsof(CP_PL_RX_STYPE0) intersect {11, 13};
                             }
    CP_PL_RX_PARAMETER0 : coverpoint rx_trans.param0
                          {
                            bins param0[] = {[0:63]};
                          }
    CP_PL_RX_PARAMETER1 : coverpoint rx_trans.param1
                          {
                            bins param1[] = {2, 3, 4, 5, 6, 7, 16, 63};
                          }
    CP_PL_RX_PACKET_NA_PARAM1 : coverpoint rx_trans.param1
                                {
                                  bins cause[] = {3, 6, 7} iff (rx_trans.stype0==2);
                                }
    CP_PL_RX_STYPE1 : coverpoint rx_trans.stype1
                      {
                        ignore_bins invalid_values = {6};
                      }
    CP_PL_RX_CMD : coverpoint rx_trans.cmd
                      {
                        bins cmd[] = {0, 2, 3, 4};
                      }
    CR_PL_RX_STYPE1_CMD : cross CP_PL_RX_STYPE1, CP_PL_RX_CMD
                          {
                            ignore_bins bin0 = binsof(CP_PL_RX_STYPE1) intersect {0} && (binsof(CP_PL_RX_CMD) intersect {3} || binsof(CP_PL_RX_CMD) intersect {4} || binsof(CP_PL_RX_CMD) intersect {2});
                            ignore_bins bin1 = binsof(CP_PL_RX_STYPE1) intersect {1} && (binsof(CP_PL_RX_CMD) intersect {3} || binsof(CP_PL_RX_CMD) intersect {4} || binsof(CP_PL_RX_CMD) intersect {2});
                            ignore_bins bin2 = binsof(CP_PL_RX_STYPE1) intersect {2} && (binsof(CP_PL_RX_CMD) intersect {3} || binsof(CP_PL_RX_CMD) intersect {4} || binsof(CP_PL_RX_CMD) intersect {2});
                            ignore_bins bin3 = binsof(CP_PL_RX_STYPE1) intersect {3} && (binsof(CP_PL_RX_CMD) intersect {3} || binsof(CP_PL_RX_CMD) intersect {4} || binsof(CP_PL_RX_CMD) intersect {2});
                            ignore_bins bin4 = binsof(CP_PL_RX_STYPE1) intersect {4} && binsof(CP_PL_RX_CMD) intersect {0};
                            ignore_bins bin5 = binsof(CP_PL_RX_STYPE1) intersect {5} && (binsof(CP_PL_RX_CMD) intersect {4} || binsof(CP_PL_RX_CMD) intersect {2});
                            ignore_bins bin6 = binsof(CP_PL_RX_STYPE1) intersect {7} && (binsof(CP_PL_RX_CMD) intersect {3} || binsof(CP_PL_RX_CMD) intersect {4} || binsof(CP_PL_RX_CMD) intersect {2});
                          }
    CR_PL_RX_CS_TYPE_STYPE1_CMD : cross CP_PL_RX_CS_TYPE, CP_PL_RX_STYPE1, CP_PL_RX_CMD
                                  {
                            ignore_bins bin0 = binsof(CP_PL_RX_STYPE1) intersect {0} && (binsof(CP_PL_RX_CMD) intersect {3} || binsof(CP_PL_RX_CMD) intersect {4} || binsof(CP_PL_RX_CMD) intersect {2});
                            ignore_bins bin1 = binsof(CP_PL_RX_STYPE1) intersect {1} && (binsof(CP_PL_RX_CMD) intersect {3} || binsof(CP_PL_RX_CMD) intersect {4} || binsof(CP_PL_RX_CMD) intersect {2});
                            ignore_bins bin2 = binsof(CP_PL_RX_STYPE1) intersect {2} && (binsof(CP_PL_RX_CMD) intersect {3} || binsof(CP_PL_RX_CMD) intersect {4} || binsof(CP_PL_RX_CMD) intersect {2});
                            ignore_bins bin3 = binsof(CP_PL_RX_STYPE1) intersect {3} && (binsof(CP_PL_RX_CMD) intersect {3} || binsof(CP_PL_RX_CMD) intersect {4} || binsof(CP_PL_RX_CMD) intersect {2});
                            ignore_bins bin4 = binsof(CP_PL_RX_STYPE1) intersect {4} && binsof(CP_PL_RX_CMD) intersect {0};
                            ignore_bins bin5 = binsof(CP_PL_RX_STYPE1) intersect {5} && (binsof(CP_PL_RX_CMD) intersect {4} || binsof(CP_PL_RX_CMD) intersect {2});
                            ignore_bins bin6 = binsof(CP_PL_RX_STYPE1) intersect {7} && (binsof(CP_PL_RX_CMD) intersect {3} || binsof(CP_PL_RX_CMD) intersect {4} || binsof(CP_PL_RX_CMD) intersect {2});
                                  }
    CP_PL_RX_IDLE1 : coverpoint rx_idle1_detected;
    CP_PL_RX_IDLE2 : coverpoint rx_idle2_detected;
    CP_PL_RX_CS_DELIMITER : coverpoint rx_trans.cs_kind;

    /// GEN3 coverpoints
    CP_PL_RX_IDLE3 : coverpoint rx_idle3_detected;

    CP_PL_TIMESTAMP_MASTER_SUPPORT : coverpoint timestamp_master_support;
    CP_PL_TIMESTAMP_SLAVE_SUPPORT : coverpoint timestamp_slave_support;
    CP_BFM_RX_LINK_RESPONSE_INPUT_PORT_STATUS : coverpoint rx_trans.param1[1:2]
                                                {
                                                  bins valid_values = {[0:3]} iff (rx_trans.stype0==6);
                                                }
    CP_BFM_RX_LINK_RESPONSE_OUTPUT_PORT_STATUS : coverpoint rx_trans.param1[5:6]
                                                {
                                                  bins valid_values = {[0:3]} iff (rx_trans.stype0==6);
                                                }
    CP_BFM_RX_SOP_UNPADDED : coverpoint rx_trans.brc3_stype1_msb
                             {
                               bins sop_unpadded = {2};
                             }
    CP_BFM_RX_SOP_PADDED : coverpoint rx_trans.brc3_stype1_msb
                             {
                               bins sop_padded = {3};
                             }


    CP_PL_DUT_RCVR_FLW_CTRL : coverpoint rx_trans.param1
                              {
                                bins rcvr_flw_ctrl[] = {31,63} iff ( (rx_trans.stype0==3'b000) || 
                                                               (rx_trans.stype0==3'b001) ||
                                                               (rx_trans.stype0==3'b100) ||
                                                               (rx_trans.stype0==3'b101)   );
                              }
  endgroup

// =============================================================================

  covergroup CG_PL_SM_VARIABLE;
    option.per_instance = 1;
    CP_PL_SM_1X_MODE_DELIMITER : coverpoint x1_mode_delimiter;
    CP_PL_SM_2X_MODE_DELIMITER : coverpoint x2_mode_delimiter;
    CP_PL_SM_1X_MODE_DETECTED : coverpoint x1_mode_detected;
    CP_PL_SM_2X_A_COL : coverpoint x2_a_col_detected;
    CP_PL_SM_NX_A_COL : coverpoint nx_a_col_detected;
    CP_PL_SM_2X_A_COUNTER : coverpoint x2_a_counter
                            {
                              bins a_count[] = {[0:4]};
                            }
    CP_PL_SM_NX_A_COUNTER : coverpoint nx_a_counter
                            {
                              bins a_count[] = {[0:4]};
                            }
    CP_PL_SM_2X_M_COUNTER : coverpoint x2_MA_counter
                            {
                              bins ma_count[] = {[0:3]};
                            }
    CP_PL_SM_NX_M_COUNTER : coverpoint nx_MA_counter
                            {
                              bins ma_count[] = {[0:3]};
                            }
    CP_PL_SM_2X_ALIGN_ERROR : coverpoint x2_align_err;
    CP_PL_SM_NX_ALIGN_ERROR : coverpoint nx_align_err;
    CP_PL_SM_D_COUNTER : coverpoint D_counter
                            {
                              bins d_count[] = {[0:3]};
                            }
    CP_PL_SM_DISC_TMR_DONE : coverpoint disc_timer_done;
    CP_PL_SM_DISC_TMR_START : coverpoint disc_timer_start;
    CP_PL_SM_DISC_TMR_EN : coverpoint disc_timer_en;
    CP_PL_SM_FORCE_1X_MODE : coverpoint force_1x_mode;
    CP_PL_SM_FORCE_LANER : coverpoint force_laneR;
    CP_PL_SM_FORCE_REINIT : coverpoint force_reinit;

    `CP_PL_SM_I_COUNTER(0)
    `CP_PL_SM_I_COUNTER(1)
    `CP_PL_SM_I_COUNTER(2)
    `CP_PL_SM_I_COUNTER(3)
    `CP_PL_SM_I_COUNTER(4)
    `CP_PL_SM_I_COUNTER(5)
    `CP_PL_SM_I_COUNTER(6)
    `CP_PL_SM_I_COUNTER(7)
    `CP_PL_SM_I_COUNTER(8)
    `CP_PL_SM_I_COUNTER(9)
    `CP_PL_SM_I_COUNTER(10)
    `CP_PL_SM_I_COUNTER(11)
    `CP_PL_SM_I_COUNTER(12)
    `CP_PL_SM_I_COUNTER(13)
    `CP_PL_SM_I_COUNTER(14)
    `CP_PL_SM_I_COUNTER(15)

    `CP_PL_SM_K_COUNTER(0)
    `CP_PL_SM_K_COUNTER(1)
    `CP_PL_SM_K_COUNTER(2)
    `CP_PL_SM_K_COUNTER(3)
    `CP_PL_SM_K_COUNTER(4)
    `CP_PL_SM_K_COUNTER(5)
    `CP_PL_SM_K_COUNTER(6)
    `CP_PL_SM_K_COUNTER(7)
    `CP_PL_SM_K_COUNTER(8)
    `CP_PL_SM_K_COUNTER(9)
    `CP_PL_SM_K_COUNTER(10)
    `CP_PL_SM_K_COUNTER(11)
    `CP_PL_SM_K_COUNTER(12)
    `CP_PL_SM_K_COUNTER(13)
    `CP_PL_SM_K_COUNTER(14)
    `CP_PL_SM_K_COUNTER(15)

    `CP_PL_SM_V_COUNTER(0)
    `CP_PL_SM_V_COUNTER(1)
    `CP_PL_SM_V_COUNTER(2)
    `CP_PL_SM_V_COUNTER(3)
    `CP_PL_SM_V_COUNTER(4)
    `CP_PL_SM_V_COUNTER(5)
    `CP_PL_SM_V_COUNTER(6)
    `CP_PL_SM_V_COUNTER(7)
    `CP_PL_SM_V_COUNTER(8)
    `CP_PL_SM_V_COUNTER(9)
    `CP_PL_SM_V_COUNTER(10)
    `CP_PL_SM_V_COUNTER(11)
    `CP_PL_SM_V_COUNTER(12)
    `CP_PL_SM_V_COUNTER(13)
    `CP_PL_SM_V_COUNTER(14)
    `CP_PL_SM_V_COUNTER(15)
 
    CP_PL_SM_IDLE_SELECTED : coverpoint idle_selection_done;
    CP_PL_SM_LANE_READY0  : coverpoint lane_ready0;
    CP_PL_SM_LANE_READY1  : coverpoint lane_ready1;
    CP_PL_SM_LANE_READY2  : coverpoint lane_ready2;
    CP_PL_SM_LANE_READY3  : coverpoint lane_ready3;
    CP_PL_SM_LANE_READY4  : coverpoint lane_ready4;
    CP_PL_SM_LANE_READY5  : coverpoint lane_ready5;
    CP_PL_SM_LANE_READY6  : coverpoint lane_ready6;
    CP_PL_SM_LANE_READY7  : coverpoint lane_ready7;
    CP_PL_SM_LANE_READY8  : coverpoint lane_ready8;
    CP_PL_SM_LANE_READY9  : coverpoint lane_ready9;
    CP_PL_SM_LANE_READY10 : coverpoint lane_ready10;
    CP_PL_SM_LANE_READY11 : coverpoint lane_ready11;
    CP_PL_SM_LANE_READY12 : coverpoint lane_ready12;
    CP_PL_SM_LANE_READY13 : coverpoint lane_ready13;
    CP_PL_SM_LANE_READY14 : coverpoint lane_ready14;
    CP_PL_SM_LANE_READY15 : coverpoint lane_ready15;
    CP_PL_SM_LANE_SYNC0  : coverpoint lane_sync0;
    CP_PL_SM_LANE_SYNC1  : coverpoint lane_sync1;
    CP_PL_SM_LANE_SYNC2  : coverpoint lane_sync2;
    CP_PL_SM_LANE_SYNC3  : coverpoint lane_sync3;
    CP_PL_SM_LANE_SYNC4  : coverpoint lane_sync4;
    CP_PL_SM_LANE_SYNC5  : coverpoint lane_sync5;
    CP_PL_SM_LANE_SYNC6  : coverpoint lane_sync6;
    CP_PL_SM_LANE_SYNC7  : coverpoint lane_sync7;
    CP_PL_SM_LANE_SYNC8  : coverpoint lane_sync8;
    CP_PL_SM_LANE_SYNC9  : coverpoint lane_sync9;
    CP_PL_SM_LANE_SYNC10 : coverpoint lane_sync10;
    CP_PL_SM_LANE_SYNC11 : coverpoint lane_sync11;
    CP_PL_SM_LANE_SYNC12 : coverpoint lane_sync12;
    CP_PL_SM_LANE_SYNC13 : coverpoint lane_sync13;
    CP_PL_SM_LANE_SYNC14 : coverpoint lane_sync14;
    CP_PL_SM_LANE_SYNC15 : coverpoint lane_sync15;
    CP_PL_SM_LANES01_DRVR_OE : coverpoint lanes01_drvr_oe;
    CP_PL_SM_LANES02_DRVR_OE : coverpoint lanes02_drvr_oe;
    CP_PL_SM_LANES13_DRVR_OE : coverpoint lanes13_drvr_oe;
    CP_PL_SM_N_LANES_ALIGNED : coverpoint N_lanes_aligned;
    CP_PL_SM_N_LANES_DRVR_OE : coverpoint N_lanes_drvr_oe;
    CP_PL_SM_N_LANES_READY : coverpoint N_lanes_ready;
    CP_PL_SM_PORT_INITIALIZED : coverpoint port_initialized;
    CP_PL_SM_RECEIVE_LANE1 : coverpoint receive_lane1;
    CP_PL_SM_RECEIVE_LANE2 : coverpoint receive_lane2;
    CP_PL_SM_RCVR_TRAINED0  : coverpoint rcvr_trained0;
    CP_PL_SM_RCVR_TRAINED1  : coverpoint rcvr_trained1;
    CP_PL_SM_RCVR_TRAINED2  : coverpoint rcvr_trained2;
    CP_PL_SM_RCVR_TRAINED3  : coverpoint rcvr_trained3;
    CP_PL_SM_RCVR_TRAINED4  : coverpoint rcvr_trained4;
    CP_PL_SM_RCVR_TRAINED5  : coverpoint rcvr_trained5;
    CP_PL_SM_RCVR_TRAINED6  : coverpoint rcvr_trained6;
    CP_PL_SM_RCVR_TRAINED7  : coverpoint rcvr_trained7;
    CP_PL_SM_RCVR_TRAINED8  : coverpoint rcvr_trained8;
    CP_PL_SM_RCVR_TRAINED9  : coverpoint rcvr_trained9;
    CP_PL_SM_RCVR_TRAINED10 : coverpoint rcvr_trained10;
    CP_PL_SM_RCVR_TRAINED11 : coverpoint rcvr_trained11;
    CP_PL_SM_RCVR_TRAINED12 : coverpoint rcvr_trained12;
    CP_PL_SM_RCVR_TRAINED13 : coverpoint rcvr_trained13;
    CP_PL_SM_RCVR_TRAINED14 : coverpoint rcvr_trained14;
    CP_PL_SM_RCVR_TRAINED15 : coverpoint rcvr_trained15;
    CP_PL_SM_SIGNAL_DETECT0  : coverpoint signal_detect0;
    CP_PL_SM_SIGNAL_DETECT1  : coverpoint signal_detect1;
    CP_PL_SM_SIGNAL_DETECT2  : coverpoint signal_detect2;
    CP_PL_SM_SIGNAL_DETECT3  : coverpoint signal_detect3;
    CP_PL_SM_SIGNAL_DETECT4  : coverpoint signal_detect4;
    CP_PL_SM_SIGNAL_DETECT5  : coverpoint signal_detect5;
    CP_PL_SM_SIGNAL_DETECT6  : coverpoint signal_detect6;
    CP_PL_SM_SIGNAL_DETECT7  : coverpoint signal_detect7;
    CP_PL_SM_SIGNAL_DETECT8  : coverpoint signal_detect8;
    CP_PL_SM_SIGNAL_DETECT9  : coverpoint signal_detect9;
    CP_PL_SM_SIGNAL_DETECT10 : coverpoint signal_detect10;
    CP_PL_SM_SIGNAL_DETECT11 : coverpoint signal_detect11;
    CP_PL_SM_SIGNAL_DETECT12 : coverpoint signal_detect12;
    CP_PL_SM_SIGNAL_DETECT13 : coverpoint signal_detect13;
    CP_PL_SM_SIGNAL_DETECT14 : coverpoint signal_detect14;
    CP_PL_SM_SIGNAL_DETECT15 : coverpoint signal_detect15;
    CP_PL_SM_SILENCE_TIMER_DONE : coverpoint silence_timer_done;
    CP_PL_SM_SILENCE_TIMER_EN : coverpoint silence_timer_en;
  endgroup

// =============================================================================

  `CG_PL_SYNC_SM_LANE(0)
  `CG_PL_SYNC_SM_LANE(1)
  `CG_PL_SYNC_SM_LANE(2)
  `CG_PL_SYNC_SM_LANE(3)
  `CG_PL_SYNC_SM_LANE(4)
  `CG_PL_SYNC_SM_LANE(5)
  `CG_PL_SYNC_SM_LANE(6)
  `CG_PL_SYNC_SM_LANE(7)
  `CG_PL_SYNC_SM_LANE(8)
  `CG_PL_SYNC_SM_LANE(9)
  `CG_PL_SYNC_SM_LANE(10)
  `CG_PL_SYNC_SM_LANE(11)
  `CG_PL_SYNC_SM_LANE(12)
  `CG_PL_SYNC_SM_LANE(13)
  `CG_PL_SYNC_SM_LANE(14)
  `CG_PL_SYNC_SM_LANE(15)


  `CG_GEN3_PL_LANE_SYNC_SM(0)
  `CG_GEN3_PL_LANE_SYNC_SM(1)
  `CG_GEN3_PL_LANE_SYNC_SM(2)
  `CG_GEN3_PL_LANE_SYNC_SM(3)
  `CG_GEN3_PL_LANE_SYNC_SM(4)
  `CG_GEN3_PL_LANE_SYNC_SM(5)
  `CG_GEN3_PL_LANE_SYNC_SM(6)
  `CG_GEN3_PL_LANE_SYNC_SM(7)
  `CG_GEN3_PL_LANE_SYNC_SM(8)
  `CG_GEN3_PL_LANE_SYNC_SM(9)
  `CG_GEN3_PL_LANE_SYNC_SM(10)
  `CG_GEN3_PL_LANE_SYNC_SM(11)
  `CG_GEN3_PL_LANE_SYNC_SM(12)
  `CG_GEN3_PL_LANE_SYNC_SM(13)
  `CG_GEN3_PL_LANE_SYNC_SM(14)
  `CG_GEN3_PL_LANE_SYNC_SM(15)

  covergroup CG_PL_LANE_ALIGN_2X;
    option.per_instance = 1;
    CP_PL_LANE_ALIGN_2X_NEXT_STATE : coverpoint lane_2x_align_state
                                     {
                                       bins lane_2x_align_state[] = {NOT_ALIGNED, NOT_ALIGNED_1, NOT_ALIGNED_2, ALIGNED, ALIGNED_1, ALIGNED_2, ALIGNED_3};
                                     }
    CP_PL_RESET         : coverpoint srio_if.srio_rst_n;
    CR_PL_LANE_ALIGN_2X_NEXT_STATE_RESET : cross CP_PL_LANE_ALIGN_2X_NEXT_STATE, CP_PL_RESET
                                           { 
                                             ignore_bins bin1 = binsof(CP_PL_LANE_ALIGN_2X_NEXT_STATE) intersect{NOT_ALIGNED_2, ALIGNED_2} && binsof(CP_PL_RESET) intersect{0};
                                           }
    CP_PL_LANE_ALIGN_2X_TO_NA : coverpoint lane_2x_align_state
                                {
                                  bins na1_to_na = (NOT_ALIGNED_1 => NOT_ALIGNED);
                                  bins na2_to_na = (NOT_ALIGNED_2 => NOT_ALIGNED);
                                }
    CP_PL_LANE_ALIGN_2X_TO_NA1 : coverpoint lane_2x_align_state
                                {
                                  bins na_to_na1 = (NOT_ALIGNED => NOT_ALIGNED_1);
                                  bins na2_to_na1 = (NOT_ALIGNED_2 => NOT_ALIGNED_1);
                                }
    CP_PL_LANE_ALIGN_2X_TO_NA2 : coverpoint lane_2x_align_state
                                {
                                  bins na1_to_na2 = (NOT_ALIGNED_1 => NOT_ALIGNED_2);
                                }
    CP_PL_LANE_ALIGN_2X_TO_A : coverpoint lane_2x_align_state
                                {
                                  bins na1_to_a = (NOT_ALIGNED_1 => ALIGNED);
                                  bins a3_to_a = (ALIGNED_3 => ALIGNED);
                                }
    CP_PL_LANE_ALIGN_2X_TO_A1 : coverpoint lane_2x_align_state
                                {
                                  bins a_to_a1 = (ALIGNED => ALIGNED_1);
                                  bins a2_to_a1 = (ALIGNED_2 => ALIGNED_1);
                                }
    CP_PL_LANE_ALIGN_2X_TO_A2 : coverpoint lane_2x_align_state
                                {
                                  bins a1_to_a2 = (ALIGNED_1 => ALIGNED_2);
                                  bins a3_to_a2 = (ALIGNED_3 => ALIGNED_2);
                                }
    CP_PL_LANE_ALIGN_2X_TO_A3 : coverpoint lane_2x_align_state
                                {
                                  bins a2_to_a3 = (ALIGNED_2 => ALIGNED_3);
                                }
    CP_PL_LANE_ALIGN_2X_TO_PATH_TRANSITIONS : coverpoint lane_2x_align_state
                                {
                                  // GEN 1.3
                                  bins na_na1_na2_na1 = (NOT_ALIGNED => NOT_ALIGNED_1 => NOT_ALIGNED_2 => NOT_ALIGNED_1);
                                  bins na1_na2_na1_na2 = (NOT_ALIGNED_1 => NOT_ALIGNED_2 => NOT_ALIGNED_1 => NOT_ALIGNED_2);
                                  bins na1_na2_na1_a = (NOT_ALIGNED_1 => NOT_ALIGNED_2 => NOT_ALIGNED_1 => ALIGNED);
                                  bins a_a1_a2_a1 = (ALIGNED => ALIGNED_1 => ALIGNED_2 => ALIGNED_1);
                                  bins a2_a3_a2 = (ALIGNED_2 => ALIGNED_3 => ALIGNED_2);
                                  bins a2_a3_a = (ALIGNED_2 => ALIGNED_3 => ALIGNED);
                                  bins a2_a1_na = (ALIGNED_2 => ALIGNED_1 => NOT_ALIGNED);

                                  // GEN2.X
                                  bins na_na1_na2 = (NOT_ALIGNED => NOT_ALIGNED_1 => NOT_ALIGNED_2);
                                  bins gen2_na1_na2_na1_na2 = (NOT_ALIGNED_1 => NOT_ALIGNED_2 => NOT_ALIGNED_1 => NOT_ALIGNED_2);
                                  bins gen2_na1_na2_na1_a =(NOT_ALIGNED_1 => NOT_ALIGNED_2 => NOT_ALIGNED_1 => ALIGNED);
                                  bins a2_a1_a2 = ( ALIGNED_2 =>  ALIGNED_1 => ALIGNED_2);
                                  bins gen2_a2_a3_a = (ALIGNED_2 => ALIGNED_3 => ALIGNED);

                                }
  endgroup
// =============================================================================

  covergroup CG_PL_LANE_ALIGN_NX;
    option.per_instance = 1;
    CP_PL_LANE_ALIGN_NX_NEXT_STATE : coverpoint lane_nx_align_state
                                     {
                                       bins lane_nx_align_state[] = {NOT_ALIGNED, NOT_ALIGNED_1, NOT_ALIGNED_2, ALIGNED, ALIGNED_1, ALIGNED_2, ALIGNED_3};
                                     }
    CP_PL_RESET         : coverpoint srio_if.srio_rst_n;
    CR_PL_LANE_ALIGN_NX_NEXT_STATE_RESET : cross CP_PL_LANE_ALIGN_NX_NEXT_STATE, CP_PL_RESET
                                           { 
                                             ignore_bins bin1 = binsof(CP_PL_LANE_ALIGN_NX_NEXT_STATE) intersect {NOT_ALIGNED_2, ALIGNED_2} && binsof(CP_PL_RESET) intersect {0};
                                           }
    CP_PL_LANE_ALIGN_NX_TO_NA : coverpoint lane_nx_align_state
                                {
                                  bins na1_to_na = (NOT_ALIGNED_1 => NOT_ALIGNED);
                                  bins na2_to_na = (NOT_ALIGNED_2 => NOT_ALIGNED);
                                }
    CP_PL_LANE_ALIGN_NX_TO_NA1 : coverpoint lane_nx_align_state
                                {
                                  bins na_to_na1 = (NOT_ALIGNED => NOT_ALIGNED_1);
                                  bins na2_to_na1 = (NOT_ALIGNED_2 => NOT_ALIGNED_1);
                                }
    CP_PL_LANE_ALIGN_NX_TO_NA2 : coverpoint lane_nx_align_state
                                {
                                  bins na1_to_na2 = (NOT_ALIGNED_1 => NOT_ALIGNED_2);
                                }
    CP_PL_LANE_ALIGN_NX_TO_A : coverpoint lane_nx_align_state
                                {
                                  bins na1_to_a = (NOT_ALIGNED_1 => ALIGNED);
                                  bins a3_to_a = (ALIGNED_3 => ALIGNED);
                                }
    CP_PL_LANE_ALIGN_NX_TO_A1 : coverpoint lane_nx_align_state
                                {
                                  bins a_to_a1 = (ALIGNED => ALIGNED_1);
                                  bins a2_to_a1 = (ALIGNED_2 => ALIGNED_1);
                                }
    CP_PL_LANE_ALIGN_NX_TO_A2 : coverpoint lane_nx_align_state
                                {
                                  bins a1_to_a2 = (ALIGNED_1 => ALIGNED_2);
                                  bins a3_to_a2 = (ALIGNED_3 => ALIGNED_2);
                                }
    CP_PL_LANE_ALIGN_NX_TO_A3 : coverpoint lane_nx_align_state
                                {
                                  bins a2_to_a3 = (ALIGNED_2 => ALIGNED_3);
                                }
    CP_PL_NUM_OF_LANES : coverpoint number_of_lanes
                                {
                                  bins num_lanes[] = {4, 8, 16};
                                }
    CP_PL_LANE_ALIGN_NX_TO_PATH_TRANSITIONS : coverpoint lane_nx_align_state
                                {
                                  // GEN 1.3
                                  bins na_na1_na2_na1 = (NOT_ALIGNED => NOT_ALIGNED_1 => NOT_ALIGNED_2 => NOT_ALIGNED_1);
                                  bins na1_na2_na1_na2 = (NOT_ALIGNED_1 => NOT_ALIGNED_2 => NOT_ALIGNED_1 => NOT_ALIGNED_2);
                                  bins na1_na2_na1_a = (NOT_ALIGNED_1 => NOT_ALIGNED_2 => NOT_ALIGNED_1 => ALIGNED);
                                  bins a_a1_a2_a1 = (ALIGNED => ALIGNED_1 => ALIGNED_2 => ALIGNED_1);
                                  bins a2_a3_a2 = (ALIGNED_2 => ALIGNED_3 => ALIGNED_2);
                                  bins a2_a3_a = (ALIGNED_2 => ALIGNED_3 => ALIGNED);
                                  bins a2_a1_na = (ALIGNED_2 => ALIGNED_1 => NOT_ALIGNED);

                                  // GEN2.X
                                  bins na_na1_na2 = (NOT_ALIGNED => NOT_ALIGNED_1 => NOT_ALIGNED_2);
                                  bins gen2_na1_na2_na1_na2 = (NOT_ALIGNED_1 => NOT_ALIGNED_2 => NOT_ALIGNED_1 => NOT_ALIGNED_2);
                                  bins gen2_na1_na2_na1_a =(NOT_ALIGNED_1 => NOT_ALIGNED_2 => NOT_ALIGNED_1 => ALIGNED);
                                  bins a2_a1_a2 = ( ALIGNED_2 =>  ALIGNED_1 => ALIGNED_2);
                                  bins gen2_a2_a3_a = (ALIGNED_2 => ALIGNED_3 => ALIGNED);
                                }
  endgroup
// =============================================================================

  covergroup CG_PL_MODE_DETECT_SM;
    option.per_instance = 1;
    CP_PL_MODE_DETECT_NEXT_STATE : coverpoint mode_detect_state;
    CP_PL_RESET         : coverpoint srio_if.srio_rst_n;
    CP_PL_2_LANES_ALIGNED   : coverpoint two_lanes_aligned;
    CP_PL_MODE_DETECT_TO_GET_COLUMN : coverpoint mode_detect_state
                                      {
                                        bins ini_to_gc = (INITIALIZE => GET_COLUMN);
                                        bins set1x_to_gc = (SET_1X_MODE => GET_COLUMN);
                                        bins set2x_to_gc = (SET_2X_MODE => GET_COLUMN);
                                        bins x1d_to_gc = (X1_DELIMITER => GET_COLUMN);
                                        bins x2d_to_gc = (X2_DELIMITER => GET_COLUMN);
                                      }
    CP_PL_MODE_DETECT_TO_X1_DELIMITER : coverpoint mode_detect_state
                                      {
                                        bins gc_to_x1d = (GET_COLUMN => X1_DELIMITER);
                                      }
    CP_PL_MODE_DETECT_TO_X2_DELIMITER : coverpoint mode_detect_state
                                      {
                                        bins gc_to_x2d = (GET_COLUMN => X2_DELIMITER);
                                      }
    CP_PL_MODE_DETECT_TO_SET_1X_MODE : coverpoint mode_detect_state
                                      {
                                        bins x1d_to_set1x = (X1_DELIMITER => SET_1X_MODE);
                                      }
    CP_PL_MODE_DETECT_TO_SET_2X_MODE : coverpoint mode_detect_state
                                      {
                                        bins x2d_to_set2x = (X2_DELIMITER => SET_2X_MODE);
                                      }
    CP_PL_MODE_DETECT_PATH_TRANSITIONS : coverpoint mode_detect_state
                                      {
                                        bins gc_1xd_1xm = (GET_COLUMN => X1_DELIMITER => SET_1X_MODE);
                                        bins gc_2xd_2xm = (GET_COLUMN => X2_DELIMITER => SET_2X_MODE);
                                        bins gc_1xd_gc = (GET_COLUMN => X1_DELIMITER => GET_COLUMN);
                                        bins gc_2xd_gc = (GET_COLUMN => X2_DELIMITER => GET_COLUMN);
                                      }
  endgroup
// =============================================================================

  covergroup CG_PL_1X_2X_NX_INIT_SM;
    option.per_instance = 1;
    CP_PL_1X_2X_NX_INIT_NEXT_STATE : coverpoint init_sm_1x_2x_nx_state
                                     {
                                      bins init_sm_next_state[] = {SILENT, SEEK, DISCOVERY, X2_RECOVERY, X1_RECOVERY, NX_MODE, X2_MODE, X1_M0, X1_M1, X1_M2};
                                     }
    CP_PL_RESET         : coverpoint srio_if.srio_rst_n;
    CP_PL_SM_FORCE_REINIT : coverpoint force_reinit;
    CR_PL_1X_2X_NX_INIT_NEXT_STATE_RESET : cross CP_PL_1X_2X_NX_INIT_NEXT_STATE, CP_PL_RESET;
    CR_PL_1X_2X_NX_INIT_NEXT_STATE_FORCE_REINIT : cross CP_PL_1X_2X_NX_INIT_NEXT_STATE, CP_PL_SM_FORCE_REINIT
                                                  {
                                                    ignore_bins bin1 = binsof(CP_PL_1X_2X_NX_INIT_NEXT_STATE) intersect {SILENT} && binsof(CP_PL_SM_FORCE_REINIT) intersect {1};
                                                  }
    CP_PL_1X_2X_NX_INIT_TO_SILENT : coverpoint init_sm_1x_2x_nx_state
                                      {
                                        bins dis_to_sil = (DISCOVERY => SILENT);
                                        bins x2r_to_sil = (X2_RECOVERY => SILENT);
                                        bins nxm_to_sil = (NX_MODE => SILENT);
                                        bins x2m_to_sil = (X2_MODE => SILENT);
                                        bins x1ml0_to_sil = (X1_M0 => SILENT);
                                        bins x1ml1_to_sil = (X1_M1 => SILENT);
                                        bins x1ml2_to_sil = (X1_M2 => SILENT);
                                      }
    CP_PL_1X_2X_NX_INIT_TO_SEEK : coverpoint init_sm_1x_2x_nx_state
                                      {
                                        bins sil_to_seek = (SILENT => SEEK);
                                      }
    CP_PL_1X_2X_NX_INIT_TO_DISCOVERY : coverpoint init_sm_1x_2x_nx_state
                                      {
                                        bins seek_to_dis = (SEEK => DISCOVERY);
                                        bins nxm_to_dis = (NX_MODE => DISCOVERY);
                                      }
    CP_PL_1X_2X_NX_INIT_TO_1X_RECOVERY : coverpoint init_sm_1x_2x_nx_state
                                      {
                                        bins x1m0_to_x1r = (X1_M0 => X1_RECOVERY);
                                        bins x1m1_to_x1r = (X1_M1 => X1_RECOVERY);
                                        bins x1m2_to_x1r = (X1_M2 => X1_RECOVERY);
                                      }
    CP_PL_1X_2X_NX_INIT_TO_2X_RECOVERY : coverpoint init_sm_1x_2x_nx_state
                                      {
                                        bins x2m_to_x2r = (X2_MODE => X2_RECOVERY);
                                      }
    CP_PL_1X_2X_NX_INIT_TO_NX_MODE : coverpoint init_sm_1x_2x_nx_state
                                      {
                                        bins dis_to_nxm = (DISCOVERY => NX_MODE);
                                      }
    CP_PL_1X_2X_NX_INIT_TO_2X_MODE : coverpoint init_sm_1x_2x_nx_state
                                      {
                                        bins dis_to_x2m = (DISCOVERY => X2_MODE);
                                        bins x2r_to_x2m = (X2_RECOVERY => X2_MODE);
                                      }
    CP_PL_1X_2X_NX_INIT_TO_1X_MODE_LANE0 : coverpoint init_sm_1x_2x_nx_state
                                           {
                                             bins dis_to_x1m0 = (DISCOVERY => X1_M0);
                                             bins x2r_to_x1m0 = (X2_RECOVERY => X1_M0);
                                             bins x1r_to_x1m0 = (X1_RECOVERY => X1_M0);
                                           }
    CP_PL_1X_2X_NX_INIT_TO_1X_MODE_LANE1 : coverpoint init_sm_1x_2x_nx_state
                                           {
                                             bins dis_to_x1m1 = (DISCOVERY => X1_M1);
                                             bins x2r_to_x1m1 = (X2_RECOVERY => X1_M1);
                                             bins x1r_to_x1m1 = (X1_RECOVERY => X1_M1);
                                           }
    CP_PL_1X_2X_NX_INIT_TO_1X_MODE_LANE2 : coverpoint init_sm_1x_2x_nx_state
                                           {
                                             bins dis_to_x1m2 = (DISCOVERY => X1_M2);
                                             bins x1r_to_x1m2 = (X1_RECOVERY => X1_M2);
                                           }
    CP_PL_1X_2X_NX_INIT_PATH_TRANSITIONS : coverpoint init_sm_1x_2x_nx_state
                                           {
                                             bins sl_se_dis_nxm = (SILENT => SEEK => DISCOVERY => NX_MODE);
                                             bins sl_se_dis_x2m = (SILENT => SEEK => DISCOVERY => X2_MODE);
                                             bins sl_se_dis_x1m0 = (SILENT => SEEK => DISCOVERY => X1_M0);
                                             bins sl_se_dis_x1m1 = (SILENT => SEEK => DISCOVERY => X1_M1);
                                             bins sl_se_dis_x1m2 = (SILENT => SEEK => DISCOVERY => X1_M2);
                                             bins sl_se_dis_sl = (SILENT => SEEK => DISCOVERY => SILENT);
                                             bins nxm_dis_nxm = (NX_MODE => DISCOVERY => NX_MODE);
                                             bins nxm_sl = (NX_MODE => SILENT);
                                             bins nxm_dis_sl = (NX_MODE => DISCOVERY => SILENT);
                                             bins nxm_dis_x2m = (NX_MODE => DISCOVERY => X2_MODE);
                                             bins nxm_dis_x1m0 = (NX_MODE => DISCOVERY => X1_M0);
                                             bins nxm_dis_x1m1 = (NX_MODE => DISCOVERY => X1_M1);
                                             bins nxm_dis_x1m2 = (NX_MODE => DISCOVERY => X1_M2);
                                             bins x2m_x2r_x2m = (X2_MODE => X2_RECOVERY => X2_MODE);
                                             bins x2m_x2r_sl = (X2_MODE => X2_RECOVERY => SILENT);
                                             bins x2m_x2r_x1m0 = (X2_MODE => X2_RECOVERY => X1_M0);
                                             bins x2m_x2r_x1m1 = (X2_MODE => X2_RECOVERY => X1_M1);
                                             bins x2m_sl = (X2_MODE => SILENT);
                                             bins x1m0_sl = (X1_M0 => SILENT);
                                             bins x1m1_sl = (X1_M1 => SILENT);
                                             bins x1m2_sl = (X1_M2 => SILENT);
                                             bins x1m0_x1r_x1m0 = (X1_M0 => X1_RECOVERY => X1_M0);
                                             bins x1m1_x1r_x1m1 = (X1_M1 => X1_RECOVERY => X1_M1);
                                             bins x1m2_x1r_x1m2 = (X1_M2 => X1_RECOVERY => X1_M2);
                                             bins x1m0_x1r_sl = (X1_M0 => X1_RECOVERY => SILENT);
                                             bins x1m1_x1r_sl = (X1_M1 => X1_RECOVERY => SILENT);
                                             bins x1m2_x1r_sl = (X1_M2 => X1_RECOVERY => SILENT);
                                             bins sl_se_x1m0 = (SILENT => SEEK => X1_M0);
                                             bins sl_se_x1m2 = (SILENT => SEEK => X1_M2);
                                           }
    CP_PL_NUM_OF_LANES : coverpoint number_of_lanes
                                {
                                  bins num_lanes[] = {4, 8, 16};
                                }
 
  endgroup
// =============================================================================


  covergroup CG_PL_INPUT_PORT_RETRY_STATE @(in_port_retry_state);
    option.per_instance = 1;
    CP_PL_INPUT_PORT_RETRY_STATE : coverpoint in_port_retry_state;
    CP_PL_INPUT_PORT_RETRY_TRANSITION : coverpoint in_port_retry_state
                                              {
                                                bins trans1 = (0 => 1);
                                                bins trans2 = (1 => 0);
                                              }
  endgroup
// =============================================================================

  covergroup CG_PL_OUTPUT_PORT_RETRY_STATE @(out_port_retry_state);
    option.per_instance = 1;
    CP_PL_OUTPUT_PORT_RETRY_STATE : coverpoint out_port_retry_state;
    CP_PL_OUTPUT_PORT_RETRY_TRANSITION : coverpoint out_port_retry_state
                                              {
                                                bins trans1 = (0 => 1);
                                                bins trans2 = (1 => 0);
                                              }
  endgroup
// =============================================================================

  covergroup CG_PL_INPUT_PORT_ERROR_STATE @(in_port_error_state);
    option.per_instance = 1;
    CP_PL_INPUT_PORT_ERROR_STATE : coverpoint in_port_error_state;
    CP_PL_INPUT_PORT_ERROR_TRANSITION : coverpoint in_port_error_state
                                              {
                                                bins trans1 = (0 => 1);
                                                bins trans2 = (1 => 0);
                                              }
  endgroup
// =============================================================================

  covergroup CG_PL_OUTPUT_PORT_ERROR_STATE @(out_port_error_state);
    option.per_instance = 1;
    CP_PL_OUTPUT_PORT_ERROR_STATE : coverpoint out_port_error_state;
    CP_PL_OUTPUT_PORT_ERROR_TRANSITION : coverpoint out_port_error_state
                                              {
                                                bins trans1 = (0 => 1);
                                                bins trans2 = (1 => 0);
                                              }
  endgroup
// =============================================================================

  covergroup CG_PL_TX_SEQ @(sim_clk);  
    option.per_instance = 1;
    CP_PL_TX_PACKET_IDLE_SYMBOL_ERROR : coverpoint tx_idle_seq_in_pkt;
    CP_PL_TX_CLOCK_COMP_SEQ : coverpoint tx_clk_comp_seq;
    CP_PL_TX_MULTI_LANE_CLK_COMP_ERR : coverpoint tx_clk_comp_seq_unaligned;
    CP_PL_TX_A_CHARACTER_INTERVAL : coverpoint tx_idle1_A_char_interval
                                    {
                                      bins bin1 = {[0:15]};
                                      bins bin2 = {16};
                                      bins bin3 = {[16:31]};
                                      bins bin4 = {31};
                                      bins bin5 = {[31:$]};
                                    }
    CP_PL_TX_IDLE2_CS_FIELD_MARKER_CORRUPT : coverpoint tx_idle2_cs_field_marker_corrupt;
    CP_PL_TX_IDLE2_CS_FIELD_CORRUPT : coverpoint tx_idle2_cs_field_corrupt;
    CP_PL_TX_IDLE2_CS_FIELD_CMD : coverpoint tx_idle2_cs_field[0];
    CP_PL_TX_IDLE2_CS_FIELD_RCVR_TRAINED : coverpoint tx_idle2_cs_field[2];
    CP_PL_TX_IDLE2_CS_FIELD_TAP_MINUS_1_STATUS : coverpoint tx_idle2_cs_field[4:5];
    CP_PL_TX_IDLE2_CS_FIELD_TAP_PLUS_1_STATUS  : coverpoint tx_idle2_cs_field[6:7];
    CP_PL_TX_IDLE2_CS_FIELD_TAP_MINUS_1_CMD : coverpoint tx_idle2_cs_field[24:25];
    CP_PL_TX_IDLE2_CS_FIELD_TAP_PLUS_1_CMD : coverpoint tx_idle2_cs_field[26:27];
    CP_PL_TX_IDLE2_CS_FIELD_RST_EMP  : coverpoint tx_idle2_cs_field[28];
    CP_PL_TX_IDLE2_CS_FIELD_PRESET_EMP  : coverpoint tx_idle2_cs_field[29];
    CP_PL_TX_IDLE2_CS_FIELD_ACK  : coverpoint tx_idle2_cs_field[30];
    CP_PL_TX_IDLE2_CS_FIELD_NACK  : coverpoint tx_idle2_cs_field[31];
    CP_PL_TX_SYNC_SEQ : coverpoint tx_sync_seq;
    CP_PL_TX_IDLE2_IDLE1 : coverpoint idle2_idle1_detected;
    CP_PL_TX_CS_STATUS_BLOCKED : coverpoint tx_status_cs_blocked;
    CP_PL_IDLE2_SEQ_ERROR : coverpoint tx_idle2_seq_unaligned;
    CP_PL_UNEXPECTED_PACKET_ACCEPTED : coverpoint tx_invalid_pkt_acc_cs;
    CP_PL_UNEXPECTED_PACKET_NA : coverpoint tx_invalid_pkt_na_cs;
    CP_PL_ACK_CORRUPT_PACKET_ACKID : coverpoint tx_pkt_ackID_corrupt;
    CP_PL_BFM_TX_PACKET_ERR_INVALID_ACKID : coverpoint tx_invalid_ackID;
  endgroup
// =============================================================================

  covergroup CG_GEN3_PL_2X_LANE_ALIGN_SM;
    option.per_instance = 1;
    CP_PL_LANE_ALIGN_2X_NEXT_STATE : coverpoint gen3_lane_2x_align_state;
    CP_PL_RESET         : coverpoint srio_if.srio_rst_n;
    CR_PL_LANE_ALIGN_2X_NEXT_STATE_RESET : cross CP_PL_LANE_ALIGN_2X_NEXT_STATE, CP_PL_RESET
                                           {
                                             ignore_bins bin1 = binsof(CP_PL_LANE_ALIGN_2X_NEXT_STATE) intersect {NOT_ALIGNED_1, ALIGNED, ALIGNED_4} && binsof(CP_PL_RESET) intersect {0};
                                           }
    CP_PL_LANE_ALIGN_2X_TO_NA : coverpoint gen3_lane_2x_align_state
                                {
                                  bins na2_to_na = (NOT_ALIGNED_2 => NOT_ALIGNED);
                                  bins na3_to_na = (NOT_ALIGNED_3 => NOT_ALIGNED);
                                }
    CP_PL_LANE_ALIGN_2X_TO_NA1 : coverpoint gen3_lane_2x_align_state
                                {
                                  bins na_to_na1 = (NOT_ALIGNED => NOT_ALIGNED_1);
                                  bins na3_to_na1 = (NOT_ALIGNED_3 => NOT_ALIGNED_1);
                                }
    CP_PL_LANE_ALIGN_2X_TO_NA2 : coverpoint gen3_lane_2x_align_state
                                {
                                  bins na1_to_na2 = (NOT_ALIGNED_1 => NOT_ALIGNED_2);
                                }
    CP_PL_LANE_ALIGN_2X_TO_NA3 : coverpoint gen3_lane_2x_align_state
                                {
                                  bins na2_to_na3 = (NOT_ALIGNED_2 => NOT_ALIGNED_3);
                                }
    CP_PL_LANE_ALIGN_2X_TO_A : coverpoint gen3_lane_2x_align_state
                                {
                                  bins na3_to_a = (NOT_ALIGNED_3 => ALIGNED);
                                  bins a1_to_a = (ALIGNED_1 => ALIGNED);
                                  bins a7_to_a = (ALIGNED_7 => ALIGNED);
                                }
    CP_PL_LANE_ALIGN_2X_TO_A1 : coverpoint gen3_lane_2x_align_state
                                {
                                  bins a_to_a1 = (ALIGNED => ALIGNED_1);
                                }
    CP_PL_LANE_ALIGN_2X_TO_A2 : coverpoint gen3_lane_2x_align_state
                                {
                                  bins a_to_a2 = (ALIGNED => ALIGNED_2);
                                }
    CP_PL_LANE_ALIGN_2X_TO_A3 : coverpoint gen3_lane_2x_align_state
                                {
                                  bins a1_to_a3 = (ALIGNED_1 => ALIGNED_3);
                                  bins a2_to_a3 = (ALIGNED_2 => ALIGNED_3);
                                  bins a5_to_a3 = (ALIGNED_5 => ALIGNED_3);
                                  bins a6_to_a3 = (ALIGNED_6 => ALIGNED_3);
                                }
    CP_PL_LANE_ALIGN_2X_TO_A4 : coverpoint gen3_lane_2x_align_state
                                {
                                  bins a3_to_a3 = (ALIGNED_3 => ALIGNED_4);
                                  bins a7_to_a3 = (ALIGNED_7 => ALIGNED_4);
                                }
    CP_PL_LANE_ALIGN_2X_TO_A5 : coverpoint gen3_lane_2x_align_state
                                {
                                  bins a4_to_a5 = (ALIGNED_4 => ALIGNED_5);
                                }
    CP_PL_LANE_ALIGN_2X_TO_A6 : coverpoint gen3_lane_2x_align_state
                                {
                                  bins a4_to_a6 = (ALIGNED_4 => ALIGNED_6);
                                }
    CP_PL_LANE_ALIGN_2X_TO_A7 : coverpoint gen3_lane_2x_align_state
                                {
                                  bins a5_to_a7 = (ALIGNED_5 => ALIGNED_7);
                                }
    CP_PL_LANE_ALIGN_2X_PATH_TRANSITIONS : coverpoint gen3_lane_2x_align_state
                                {
                                  bins na_na1_na2 = (NOT_ALIGNED => NOT_ALIGNED_1 => NOT_ALIGNED_2);
                                  bins na1_na2_na = (NOT_ALIGNED_1 => NOT_ALIGNED_2 => NOT_ALIGNED);
                                  bins na1_na2_na3_na1 = (NOT_ALIGNED_1 => NOT_ALIGNED_2 => NOT_ALIGNED_3 => NOT_ALIGNED_1);
                                  bins na1_na2_na3_a = (NOT_ALIGNED_1 => NOT_ALIGNED_2 => NOT_ALIGNED_3 => ALIGNED);
                                  bins a_a1_a = (ALIGNED => ALIGNED_1 => ALIGNED);
                                  bins a_a1_a3_a4 = (ALIGNED => ALIGNED_1 => ALIGNED_3 => ALIGNED_4);
                                  bins a_a2_a3_a4 = (ALIGNED => ALIGNED_2 => ALIGNED_3 => ALIGNED_4);
                                  bins a4_a5_a7_a4 = (ALIGNED_4 => ALIGNED_5 => ALIGNED_7 => ALIGNED_4);
                                  bins a4_a5_a3_a4 = (ALIGNED_4 => ALIGNED_5 => ALIGNED_3 => ALIGNED_4);
                                  bins a4_a5_a3_na = (ALIGNED_4 => ALIGNED_5 => ALIGNED_3 => NOT_ALIGNED);
                                  bins a4_a6_a3_a4 = (ALIGNED_4 => ALIGNED_6 => ALIGNED_3 => ALIGNED_4);
                                  bins a4_a6_a3_na = (ALIGNED_4 => ALIGNED_6 => ALIGNED_3 => NOT_ALIGNED);
                                  bins a4_a5_a7_a = (ALIGNED_4 => ALIGNED_5 => ALIGNED_7 => ALIGNED);
                                }

  endgroup
// =============================================================================

  covergroup CG_GEN3_PL_NX_LANE_ALIGN_SM;
    option.per_instance = 1;
    CP_PL_LANE_ALIGN_NX_NEXT_STATE : coverpoint gen3_lane_nx_align_state;
    CP_PL_RESET         : coverpoint srio_if.srio_rst_n;
    CR_PL_LANE_ALIGN_NX_NEXT_STATE_RESET : cross CP_PL_LANE_ALIGN_NX_NEXT_STATE, CP_PL_RESET
                                           {
                                             ignore_bins bin1 = binsof(CP_PL_LANE_ALIGN_NX_NEXT_STATE) intersect {NOT_ALIGNED_1, ALIGNED, ALIGNED_4} && binsof(CP_PL_RESET) intersect {0};
                                           }
    CP_PL_LANE_ALIGN_NX_TO_NA : coverpoint gen3_lane_nx_align_state
                                {
                                  bins na2_to_na = (NOT_ALIGNED_2 => NOT_ALIGNED);
                                  bins na3_to_na = (NOT_ALIGNED_3 => NOT_ALIGNED);
                                }
    CP_PL_LANE_ALIGN_NX_TO_NA1 : coverpoint gen3_lane_nx_align_state
                                {
                                  bins na_to_na1 = (NOT_ALIGNED => NOT_ALIGNED_1);
                                  bins na3_to_na1 = (NOT_ALIGNED_3 => NOT_ALIGNED_1);
                                }
    CP_PL_LANE_ALIGN_NX_TO_NA2 : coverpoint gen3_lane_nx_align_state
                                {
                                  bins na1_to_na2 = (NOT_ALIGNED_1 => NOT_ALIGNED_2);
                                }
    CP_PL_LANE_ALIGN_NX_TO_NA3 : coverpoint gen3_lane_nx_align_state
                                {
                                  bins na2_to_na3 = (NOT_ALIGNED_2 => NOT_ALIGNED_3);
                                }
    CP_PL_LANE_ALIGN_NX_TO_A : coverpoint gen3_lane_nx_align_state
                                {
                                  bins na3_to_a = (NOT_ALIGNED_3 => ALIGNED);
                                  bins na1_to_a = (ALIGNED_1 => ALIGNED);
                                  bins a7_to_a = (ALIGNED_7 => ALIGNED);
                                }
    CP_PL_LANE_ALIGN_NX_TO_A1 : coverpoint gen3_lane_nx_align_state
                                {
                                  bins a_to_a1 = (ALIGNED => ALIGNED_1);
                                }
    CP_PL_LANE_ALIGN_NX_TO_A2 : coverpoint gen3_lane_nx_align_state
                                {
                                  bins a_to_a2 = (ALIGNED => ALIGNED_2);
                                }
    CP_PL_LANE_ALIGN_NX_TO_A3 : coverpoint gen3_lane_nx_align_state
                                {
                                  bins a1_to_a3 = (ALIGNED_1 => ALIGNED_3);
                                  bins a2_to_a3 = (ALIGNED_2 => ALIGNED_3);
                                  bins a5_to_a3 = (ALIGNED_5 => ALIGNED_3);
                                  bins a6_to_a3 = (ALIGNED_6 => ALIGNED_3);
                                }
    CP_PL_LANE_ALIGN_NX_TO_A4 : coverpoint gen3_lane_nx_align_state
                                {
                                  bins a3_to_a4 = (ALIGNED_3 => ALIGNED_4);
                                  bins a7_to_a4 = (ALIGNED_7 => ALIGNED_4);
                                }
    CP_PL_LANE_ALIGN_NX_TO_A5 : coverpoint gen3_lane_nx_align_state
                                {
                                  bins a4_to_a5 = (ALIGNED_4 => ALIGNED_5);
                                }
    CP_PL_LANE_ALIGN_NX_TO_A6 : coverpoint gen3_lane_nx_align_state
                                {
                                  bins a4_to_a6 = (ALIGNED_4 => ALIGNED_6);
                                }
    CP_PL_LANE_ALIGN_NX_TO_A7 : coverpoint gen3_lane_nx_align_state
                                {
                                  bins a5_to_a7 = (ALIGNED_5 => ALIGNED_7);
                                }

    CP_PL_NUM_OF_LANES : coverpoint number_of_lanes
                                {
                                  bins num_lanes[] = {4, 8, 16};
                                }

    CP_PL_LANE_ALIGN_NX_PATH_TRANSITIONS : coverpoint gen3_lane_nx_align_state
                                {
                                  bins na_na1_na2 = (NOT_ALIGNED => NOT_ALIGNED_1 => NOT_ALIGNED_2);
                                  bins na1_na2_na = (NOT_ALIGNED_1 => NOT_ALIGNED_2 => NOT_ALIGNED);
                                  bins na1_na2_na3_na1 = (NOT_ALIGNED_1 => NOT_ALIGNED_2 => NOT_ALIGNED_3 => NOT_ALIGNED_1);
                                  bins na1_na2_na3_a = (NOT_ALIGNED_1 => NOT_ALIGNED_2 => NOT_ALIGNED_3 => ALIGNED);
                                  bins a_a1_a = (ALIGNED => ALIGNED_1 => ALIGNED);
                                  bins a_a1_a3_a4 = (ALIGNED => ALIGNED_1 => ALIGNED_3 => ALIGNED_4);
                                  bins a_a2_a3_a4 = (ALIGNED => ALIGNED_2 => ALIGNED_3 => ALIGNED_4);
                                  bins a4_a5_a7_a4 = (ALIGNED_4 => ALIGNED_5 => ALIGNED_7 => ALIGNED_4);
                                  bins a4_a5_a3_a4 = (ALIGNED_4 => ALIGNED_5 => ALIGNED_3 => ALIGNED_4);
                                  bins a4_a5_a3_na = (ALIGNED_4 => ALIGNED_5 => ALIGNED_3 => NOT_ALIGNED);
                                  bins a4_a6_a3_a4 = (ALIGNED_4 => ALIGNED_6 => ALIGNED_3 => ALIGNED_4);
                                  bins a4_a6_a3_na = (ALIGNED_4 => ALIGNED_6 => ALIGNED_3 => NOT_ALIGNED);
                                  bins a4_a5_a7_a = (ALIGNED_4 => ALIGNED_5 => ALIGNED_7 => ALIGNED);
                                }

  endgroup
// =============================================================================

  covergroup CG_GEN3_PL_1X_2X_NX_PORT_INIT_SM;
    option.per_instance = 1;
    CP_PL_1X_2X_NX_INIT_NEXT_STATE : coverpoint gen3_init_sm_1x_2x_nx_state;
    CP_PL_RESET         : coverpoint srio_if.srio_rst_n;
    CP_PL_SM_FORCE_REINIT : coverpoint force_reinit;
    CR_PL_1X_2X_NX_INIT_NEXT_STATE_RESET : cross CP_PL_1X_2X_NX_INIT_NEXT_STATE, CP_PL_RESET;

    CR_PL_1X_2X_NX_INIT_NEXT_STATE_FORCE_REINIT : cross CP_PL_1X_2X_NX_INIT_NEXT_STATE, CP_PL_SM_FORCE_REINIT;

    CP_PL_1X_2X_NX_INIT_TO_ASYM_MODE : coverpoint gen3_init_sm_1x_2x_nx_state
                                      {
                                        bins bin1 = (NX_MODE => ASYM_MODE);
                                        bins bin2 = (X2_MODE => ASYM_MODE);
                                      }
    CP_PL_1X_2X_NX_INIT_TO_SILENT : coverpoint gen3_init_sm_1x_2x_nx_state
                                      {
                                        bins asm_to_sil = (ASYM_MODE => SILENT);
                                        bins x1ml0_x2m_to_sil = (X1_M0 => SILENT);
                                        bins x1ml1_x2m_to_sil = (X1_M1 => SILENT);
                                        bins x1ml2_x2m_to_sil = (X1_M2 => SILENT);
                                        bins x1r_to_sil = (X1_RECOVERY => SILENT);
                                        bins nxr_to_sil = (NX_RECOVERY => SILENT);
                                        bins nxm_to_sil = (NX_MODE => SILENT);
                                        bins dis_to_sil = (DISCOVERY => SILENT);
                                      }
    CP_PL_1X_2X_NX_INIT_TO_SEEK : coverpoint gen3_init_sm_1x_2x_nx_state
                                      {
                                        bins sil_to_seek = (SILENT => SEEK);
                                      }
    CP_PL_1X_2X_NX_INIT_TO_DISCOVERY : coverpoint gen3_init_sm_1x_2x_nx_state
                                      {
                                        bins seek_to_dis = (SEEK => DISCOVERY);
                                      }
    CP_PL_1X_2X_NX_INIT_TO_1X_RETRAIN : coverpoint gen3_init_sm_1x_2x_nx_state
                                      {
                                        bins x1r_to_x1rn = (X1_RECOVERY => X1_RETRAIN);
                                      }
    CP_PL_1X_2X_NX_INIT_TO_1X_RECOVERY : coverpoint gen3_init_sm_1x_2x_nx_state
                                      {
                                        bins x1rn_to_x1r = (X1_RETRAIN => X1_RECOVERY);
                                        bins x1m0_to_x1r = (X1_M0 => X1_RECOVERY);
                                        bins x1m1_to_x1r = (X1_M1 => X1_RECOVERY);
                                        bins x1m2_to_x1r = (X1_M2 => X1_RECOVERY);
                                      }
    CP_PL_1X_2X_NX_INIT_TO_1X_MODE_LANE0 : coverpoint gen3_init_sm_1x_2x_nx_state
                                           {
                                             bins dis_to_x1m0 = (DISCOVERY => X1_M0);
                                             bins x1r_to_x1m0 = (X1_RECOVERY => X1_M0);
                                             bins nxr_to_x1m0 = (NX_RECOVERY => X1_M0);
                                             bins x2r_to_x1m0 = (X2_RECOVERY => X1_M0);
                                           }
    CP_PL_1X_2X_NX_INIT_TO_1X_MODE_LANE1 : coverpoint gen3_init_sm_1x_2x_nx_state
                                           {
                                             bins dis_to_x1m1 = (DISCOVERY => X1_M1);
                                             bins x1r_to_x1m1 = (X1_RECOVERY => X1_M1);
                                             bins nxr_to_x1m1 = (NX_RECOVERY => X1_M1);
                                             bins x2r_to_x1m1 = (X2_RECOVERY => X1_M1);
                                           }
    CP_PL_1X_2X_NX_INIT_TO_1X_MODE_LANE2 : coverpoint gen3_init_sm_1x_2x_nx_state
                                           {
                                             bins dis_to_x1m2 = (DISCOVERY => X1_M2);
                                             bins x1r_to_x1m2 = (X1_RECOVERY => X1_M2);
                                             bins nxr_to_x1m2 = (NX_RECOVERY => X1_M2);
                                           }
    CP_PL_1X_2X_NX_INIT_TO_NX_RETRAIN : coverpoint gen3_init_sm_1x_2x_nx_state
                                           {
                                             bins nxr_to_nxrn = (NX_RECOVERY => NX_RETRAIN);
                                           }
    CP_PL_1X_2X_NX_INIT_TO_2X_RETRAIN : coverpoint gen3_init_sm_1x_2x_nx_state
                                           {
                                             bins x2r_to_nxrn = (X2_RECOVERY => X2_RETRAIN);
                                           }
    CP_PL_1X_2X_NX_INIT_TO_NX_RECOVERY : coverpoint gen3_init_sm_1x_2x_nx_state
                                      {
                                        bins nxrn_to_nxr = (NX_RETRAIN => NX_RECOVERY);
                                      }
    CP_PL_1X_2X_NX_INIT_TO_2X_RECOVERY : coverpoint gen3_init_sm_1x_2x_nx_state
                                      {
                                        bins x2rn_to_x2r = (X2_RETRAIN => X2_RECOVERY);
                                      }
    CP_PL_1X_2X_NX_INIT_TO_NX_MODE : coverpoint gen3_init_sm_1x_2x_nx_state
                                      {
                                        bins dis_to_nxm = (DISCOVERY => NX_MODE);
                                        bins nxr_to_nxm = (NX_RECOVERY => NX_MODE);
                                      }
    CP_PL_1X_2X_NX_INIT_TO_2X_MODE : coverpoint gen3_init_sm_1x_2x_nx_state
                                      {
                                        bins dis_to_x2m = (DISCOVERY => X2_MODE);
                                        bins nxr_to_x2m = (NX_RECOVERY => X2_MODE);
                                        bins x2r_to_x2m = (X2_RECOVERY => X2_MODE);
                                      }
    CP_PL_NUM_OF_LANES : coverpoint number_of_lanes
                                {
                                  bins num_lanes[] = {4, 8, 16};
                                }

    CP_PL_1X_2X_NX_INIT_PATH_TRANSITIONS : coverpoint gen3_init_sm_1x_2x_nx_state
                                           {
                                             bins sl_se_dis_nxm = (SILENT => SEEK => DISCOVERY => NX_MODE);
                                             bins sl_se_dis_x2m = (SILENT => SEEK => DISCOVERY => X2_MODE);
                                             bins sl_se_dis_x1m0 = (SILENT => SEEK => DISCOVERY => X1_M0);
                                             bins sl_se_dis_x1m1 = (SILENT => SEEK => DISCOVERY => X1_M1);
                                             bins sl_se_dis_x1m2 = (SILENT => SEEK => DISCOVERY => X1_M2);
                                             bins sl_se_dis_sl = (SILENT => SEEK => DISCOVERY => SILENT);
                                             bins x2m_x2r_x2m = (X2_MODE => X2_RECOVERY => X2_MODE);
                                             bins x2m_x2r_sl = (X2_MODE => X2_RECOVERY => SILENT);
                                             bins x2m_x2r_x1m0 = (X2_MODE => X2_RECOVERY => X1_M0);
                                             bins x2m_x2r_x1m1 = (X2_MODE => X2_RECOVERY => X1_M1);
                                             bins x2m_sl = (X2_MODE => SILENT);
                                             bins x1m0_sl = (X1_M0 => SILENT);
                                             bins x1m1_sl = (X1_M1 => SILENT);
                                             bins x1m2_sl = (X1_M2 => SILENT);
                                             bins x1m0_x1r_x1m0 = (X1_M0 => X1_RECOVERY => X1_M0);
                                             bins x1m1_x1r_x1m1 = (X1_M1 => X1_RECOVERY => X1_M1);
                                             bins x1m2_x1r_x1m2 = (X1_M2 => X1_RECOVERY => X1_M2);
                                             bins x1m0_x1r_sl = (X1_M0 => X1_RECOVERY => SILENT);
                                             bins x1m1_x1r_sl = (X1_M1 => X1_RECOVERY => SILENT);
                                             bins x1m2_x1r_sl = (X1_M2 => X1_RECOVERY => SILENT);
                                             bins nxm_nxr_nxm = (NX_MODE => NX_RECOVERY => NX_MODE);
                                             bins nxm_nxr_x2m = (NX_MODE => NX_RECOVERY => X2_MODE);
                                             bins nxm_nxr_x1m0 = (NX_MODE => NX_RECOVERY => X1_M0);
                                             bins nxm_nxr_x1m1 = (NX_MODE => NX_RECOVERY => X1_M1);
                                             bins nxm_nxr_x1m2 = (NX_MODE => NX_RECOVERY => X1_M2);
                                             bins nxm_nxr_sl = (NX_MODE => NX_RECOVERY => SILENT);
                                             bins nxm_nxr_nxrn_nxr_nxm = (NX_MODE => NX_RECOVERY => NX_RETRAIN => NX_RECOVERY => NX_MODE);
                                             bins nxm_nxr_nxrn_nxr_2x = (NX_MODE => NX_RECOVERY => NX_RETRAIN => NX_RECOVERY => X2_MODE);
                                             bins nxm_nxr_nxrn_nxr_x1m0 = (NX_MODE => NX_RECOVERY => NX_RETRAIN => NX_RECOVERY => X1_M0);
                                             bins nxm_nxr_nxrn_nxr_x1m1 = (NX_MODE => NX_RECOVERY => NX_RETRAIN => NX_RECOVERY => X1_M1);
                                             bins nxm_nxr_nxrn_nxr_x1m2 = (NX_MODE => NX_RECOVERY => NX_RETRAIN => NX_RECOVERY => X1_M2);
                                             bins nxm_nxr_nxrn_nxr_sil = (NX_MODE => NX_RECOVERY => NX_RETRAIN => NX_RECOVERY => SILENT);
                                             bins x2m_x2r_x2rn_x2r_x2m = (X2_MODE => X2_RECOVERY => X2_RETRAIN => X2_RECOVERY => X2_MODE);
                                             bins x2m_x2r_x2rn_x2r_x1m0 = (X2_MODE => X2_RECOVERY => X2_RETRAIN => X2_RECOVERY => X1_M0);
                                             bins x2m_x2r_x2rn_x2r_x1m1 = (X2_MODE => X2_RECOVERY => X2_RETRAIN => X2_RECOVERY => X1_M1);
                                             bins x2m_x2r_x2rn_x2r_sil = (X2_MODE => X2_RECOVERY => X2_RETRAIN => X2_RECOVERY => SILENT);
                                             bins x1m0_x1r_x1rn_x1r_x1m0 = (X1_M0 => X1_RECOVERY => X1_RETRAIN => X1_RECOVERY => X1_M0);
                                             bins x1m1_x1r_x1rn_x1r_x1m1 = (X1_M1 => X1_RECOVERY => X1_RETRAIN => X1_RECOVERY => X1_M1);
                                             bins x1m2_x1r_x1rn_x1r_x1m2 = (X1_M2 => X1_RECOVERY => X1_RETRAIN => X1_RECOVERY => X1_M2);
                                             bins x1m0_x1r_x1rn_x1r_sil = (X1_M0 =>  X1_RECOVERY => X1_RETRAIN => X1_RECOVERY => SILENT);
                                             bins x1m1_x1r_x1rn_x1r_sil = (X1_M1 => X1_RECOVERY => X1_RETRAIN => X1_RECOVERY => SILENT);
                                             bins x1m2_x1r_x1rn_x1r_sil = (X1_M2 => X1_RECOVERY => X1_RETRAIN => X1_RECOVERY => SILENT);
                                             bins x2m_asm_sil = (X2_MODE => ASYM_MODE => SILENT);
                                             bins nxm_asm_sil = (NX_MODE => ASYM_MODE => SILENT);
                                           }

  endgroup
// =============================================================================

  `CG_GEN3_PL_CW_LOCK_SM(0)
  `CG_GEN3_PL_CW_LOCK_SM(1)
  `CG_GEN3_PL_CW_LOCK_SM(2)
  `CG_GEN3_PL_CW_LOCK_SM(3)
  `CG_GEN3_PL_CW_LOCK_SM(4)
  `CG_GEN3_PL_CW_LOCK_SM(5)
  `CG_GEN3_PL_CW_LOCK_SM(6)
  `CG_GEN3_PL_CW_LOCK_SM(7)
  `CG_GEN3_PL_CW_LOCK_SM(8)
  `CG_GEN3_PL_CW_LOCK_SM(9)
  `CG_GEN3_PL_CW_LOCK_SM(10)
  `CG_GEN3_PL_CW_LOCK_SM(11)
  `CG_GEN3_PL_CW_LOCK_SM(12)
  `CG_GEN3_PL_CW_LOCK_SM(13)
  `CG_GEN3_PL_CW_LOCK_SM(14)
  `CG_GEN3_PL_CW_LOCK_SM(15)

  `CG_GEN3_PL_LONG_RUN_LINK_TRAIN_SM(0)
  `CG_GEN3_PL_LONG_RUN_LINK_TRAIN_SM(1)
  `CG_GEN3_PL_LONG_RUN_LINK_TRAIN_SM(2)
  `CG_GEN3_PL_LONG_RUN_LINK_TRAIN_SM(3)
  `CG_GEN3_PL_LONG_RUN_LINK_TRAIN_SM(4)
  `CG_GEN3_PL_LONG_RUN_LINK_TRAIN_SM(5)
  `CG_GEN3_PL_LONG_RUN_LINK_TRAIN_SM(6)
  `CG_GEN3_PL_LONG_RUN_LINK_TRAIN_SM(7)
  `CG_GEN3_PL_LONG_RUN_LINK_TRAIN_SM(8)
  `CG_GEN3_PL_LONG_RUN_LINK_TRAIN_SM(9)
  `CG_GEN3_PL_LONG_RUN_LINK_TRAIN_SM(10)
  `CG_GEN3_PL_LONG_RUN_LINK_TRAIN_SM(11)
  `CG_GEN3_PL_LONG_RUN_LINK_TRAIN_SM(12)
  `CG_GEN3_PL_LONG_RUN_LINK_TRAIN_SM(13)
  `CG_GEN3_PL_LONG_RUN_LINK_TRAIN_SM(14)
  `CG_GEN3_PL_LONG_RUN_LINK_TRAIN_SM(15)

  `CG_GEN3_PL_SHORT_RUN_LINK_TRAIN_SM(0)
  `CG_GEN3_PL_SHORT_RUN_LINK_TRAIN_SM(1)
  `CG_GEN3_PL_SHORT_RUN_LINK_TRAIN_SM(2)
  `CG_GEN3_PL_SHORT_RUN_LINK_TRAIN_SM(3)
  `CG_GEN3_PL_SHORT_RUN_LINK_TRAIN_SM(4)
  `CG_GEN3_PL_SHORT_RUN_LINK_TRAIN_SM(5)
  `CG_GEN3_PL_SHORT_RUN_LINK_TRAIN_SM(6)
  `CG_GEN3_PL_SHORT_RUN_LINK_TRAIN_SM(7)
  `CG_GEN3_PL_SHORT_RUN_LINK_TRAIN_SM(8)
  `CG_GEN3_PL_SHORT_RUN_LINK_TRAIN_SM(9)
  `CG_GEN3_PL_SHORT_RUN_LINK_TRAIN_SM(10)
  `CG_GEN3_PL_SHORT_RUN_LINK_TRAIN_SM(11)
  `CG_GEN3_PL_SHORT_RUN_LINK_TRAIN_SM(12)
  `CG_GEN3_PL_SHORT_RUN_LINK_TRAIN_SM(13)
  `CG_GEN3_PL_SHORT_RUN_LINK_TRAIN_SM(14)
  `CG_GEN3_PL_SHORT_RUN_LINK_TRAIN_SM(15)

  covergroup CG_GEN3_PL_RETRAIN_TRANSMIT_WIDTH_CTRL_SM;
    option.per_instance = 1;
    CP_PL_RETRAIN_TX_WIDTH_CTRL_NEXT_STATE : coverpoint retrain_xmt_width_ctrl_state;
    CP_PL_RETRAIN_TX_WIDTH_CTRL_TO_IDLE : coverpoint retrain_xmt_width_ctrl_state
                                          {
                                            bins rt5_to_idle = ( RETRAIN_5 => IDLE );
                                            bins rtt_to_idle = ( RETRAIN_TIMEOUT => IDLE );
                                            bins xmt_w_to_idle = ( XMT_WIDTH => IDLE );
                                          }
    CP_PL_RETRAIN_TX_WIDTH_CTRL_TO_XMT_WIDTH : coverpoint retrain_xmt_width_ctrl_state
                                          {
                                            bins idle_to_xmt_w = ( IDLE => XMT_WIDTH );
                                          }
    CP_PL_RETRAIN_TX_WIDTH_CTRL_TO_RETRAIN0 : coverpoint retrain_xmt_width_ctrl_state
                                          {
                                            bins idle_to_rt0 = ( IDLE => RETRAIN_0 );
                                          }
    CP_PL_RETRAIN_TX_WIDTH_CTRL_TO_RETRAIN1 : coverpoint retrain_xmt_width_ctrl_state
                                          {
                                            bins rt0_to_rt1 = ( RETRAIN_0 => RETRAIN_1 );
                                          }
    CP_PL_RETRAIN_TX_WIDTH_CTRL_TO_RETRAIN2 : coverpoint retrain_xmt_width_ctrl_state
                                          {
                                            bins rt1_to_rt2 = ( RETRAIN_1 => RETRAIN_2 );
                                          }
    CP_PL_RETRAIN_TX_WIDTH_CTRL_TO_RETRAIN3 : coverpoint retrain_xmt_width_ctrl_state
                                          {
                                            bins rt2_to_rt3 = ( RETRAIN_2 => RETRAIN_3 );
                                          }
    CP_PL_RETRAIN_TX_WIDTH_CTRL_TO_RETRAIN4 : coverpoint retrain_xmt_width_ctrl_state
                                          {
                                            bins rt3_to_rt4 = ( RETRAIN_3 => RETRAIN_4 );
                                          }
    CP_PL_RETRAIN_TX_WIDTH_CTRL_TO_RETRAIN5 : coverpoint retrain_xmt_width_ctrl_state
                                          {
                                            bins rt4_to_rt5 = ( RETRAIN_4 => RETRAIN_5 );
                                          }
    CP_PL_RETRAIN_TX_WIDTH_CTRL_TO_RETRAIN_TIMEOUT : coverpoint retrain_xmt_width_ctrl_state
                                          {
                                            bins rt0_to_rtt = ( RETRAIN_0 => RETRAIN_TIMEOUT );
                                            bins rt1_to_rtt = ( RETRAIN_1 => RETRAIN_TIMEOUT );
                                            bins rt2_to_rtt = ( RETRAIN_2 => RETRAIN_TIMEOUT );
                                            bins rt3_to_rtt = ( RETRAIN_3 => RETRAIN_TIMEOUT );
                                            bins rt4_to_rtt = ( RETRAIN_4 => RETRAIN_TIMEOUT );
                                            bins rt5_to_rtt = ( RETRAIN_5 => RETRAIN_TIMEOUT );
                                          }
    CP_PL_RETRAIN_TX_WIDTH_CTRL_PATH_TRANSITIONS : coverpoint retrain_xmt_width_ctrl_state
                                          {
                                            bins idle_xmtw_idle = (IDLE => XMT_WIDTH => IDLE);
                                            bins idle_rt0_rtt_idle = (IDLE => RETRAIN_0 => RETRAIN_TIMEOUT => IDLE);
                                            bins idle_rt0_rt1_rtt_idle = (IDLE => RETRAIN_0 => RETRAIN_1 => RETRAIN_TIMEOUT => IDLE);
                                            bins idle_rt0_rt1_rt2_rtt_idle = (IDLE => RETRAIN_0 => RETRAIN_1 => RETRAIN_2 => RETRAIN_TIMEOUT => IDLE);
                                            bins idle_rt0_rt1_rt2_rt3_rtt_idle = (IDLE => RETRAIN_0 => RETRAIN_1 => RETRAIN_2 => RETRAIN_3 => RETRAIN_TIMEOUT => IDLE);
                                            bins idle_rt0_rt1_rt2_rt3_rt4_rtt_idle = (IDLE => RETRAIN_0 => RETRAIN_1 => RETRAIN_2 => RETRAIN_3 => RETRAIN_4 => RETRAIN_TIMEOUT => IDLE);
                                            bins idle_rt0_rt1_rt2_rt3_rt4_rt5_rtt_idle = (IDLE => RETRAIN_0 => RETRAIN_1 => RETRAIN_2 => RETRAIN_3 => RETRAIN_4 => RETRAIN_5 => RETRAIN_TIMEOUT => IDLE);
                                            bins idle_rt0_rt1_rt2_rt3_rt4_rt5_idle = (IDLE => RETRAIN_0 => RETRAIN_1 => RETRAIN_2 => RETRAIN_3 => RETRAIN_4 => RETRAIN_5 => IDLE);
                                          }
  endgroup
// =============================================================================

  covergroup CG_GEN3_PL_TRANSMIT_WIDTH_CMD_SM;
    option.per_instance = 1;
    CP_PL_TX_WIDTH_CMD_NEXT_STATE : coverpoint xmt_width_cmd_state;
    CP_PL_TX_WIDTH_CMD_TO_CMD2 : coverpoint xmt_width_cmd_state
                                 {
                                   bins xwc1_to_xwc2 = ( XMT_WIDTH_CMD_1 => XMT_WIDTH_CMD_2 );
                                   bins xwci_to_xwc2 = ( XMT_WIDTH_CMD_IDLE => XMT_WIDTH_CMD_2 );
                                 }
    CP_PL_TX_WIDTH_CMD_TO_CMD3 : coverpoint xmt_width_cmd_state
                                 {
                                   bins xwc2_to_xwc3 = ( XMT_WIDTH_CMD_2 => XMT_WIDTH_CMD_3 );
                                 }
    CP_PL_TX_WIDTH_CMD_TO_CMD_IDLE : coverpoint xmt_width_cmd_state
                                 {
                                   bins xwc3_to_xwci = ( XMT_WIDTH_CMD_3 => XMT_WIDTH_CMD_IDLE );
                                 }
    CP_PL_TX_WIDTH_CMD_TO_CMD1 : coverpoint xmt_width_cmd_state
                                 {
                                   bins xwci_to_xwc1 = ( XMT_WIDTH_CMD_IDLE => XMT_WIDTH_CMD_1 );
                                 }
    CP_PL_TX_WIDTH_CMD_PATH_TRANSITIONS : coverpoint xmt_width_cmd_state
                                 {
                                   bins xwc3_xwci_xwc2_xwc3 = ( XMT_WIDTH_CMD_3 => XMT_WIDTH_CMD_IDLE => XMT_WIDTH_CMD_2 => XMT_WIDTH_CMD_3);
                                   bins xwc3_xwci_xwc1_xwc2_xwc3 = ( XMT_WIDTH_CMD_3 => XMT_WIDTH_CMD_IDLE => XMT_WIDTH_CMD_1 => XMT_WIDTH_CMD_2 => XMT_WIDTH_CMD_3);
                                 }
  endgroup
// =============================================================================

  covergroup CG_GEN3_PL_TRANSMIT_WIDTH_SM;
    option.per_instance = 1;
    CP_PL_TX_WIDTH_NEXT_STATE : coverpoint xmt_width_state;

    CP_PL_ASYM_MODE : coverpoint asym_mode;

    CP_PL_PISM_SILENT : coverpoint pism_silent;

    CP_PL_TX_WIDTH_TO_ASYM_XMT_EXIT : coverpoint xmt_width_state
                                      {
                                        bins s1xmx2_to_axe = ( SEEK_1X_MODE_XMT_2 => ASYM_XMT_EXIT );
                                        bins s2xmx2_to_axe = ( SEEK_2X_MODE_XMT_2 => ASYM_XMT_EXIT );
                                        // bins snxmx2_to_axe = ( SEEK_NX_MODE_XMT_2 => ASYM_XMT_EXIT );
                                      }
    CP_PL_TX_WIDTH_TO_ASYM_XMT_IDLE : coverpoint xmt_width_state
                                      {
                                        bins axe_to_axi = ( ASYM_XMT_EXIT => ASYM_XMT_IDLE );
                                      }
    CP_PL_TX_WIDTH_TO_XMT_WIDTH_NACK : coverpoint xmt_width_state
                                      {
                                        bins s1xmx3_to_xwn = ( SEEK_1X_MODE_XMT_3 => XMT_WIDTH_NACK );
                                        bins s2xmx3_to_xwn = ( SEEK_2X_MODE_XMT_3 => XMT_WIDTH_NACK );
                                      }
    CP_PL_TX_WIDTH_TO_SEEK_1X_MODE_XMT : coverpoint xmt_width_state
                                      {
                                        bins x2mx_to_s1xmx = ( X2_MODE_XMT => SEEK_1X_MODE_XMT );
                                        bins nxmx_to_s1xmx = ( NX_MODE_XMT => SEEK_1X_MODE_XMT );
                                      }
    CP_PL_TX_WIDTH_TO_SEEK_1X_MODE_XMT1 : coverpoint xmt_width_state
                                      {
                                        bins s1xmx_to_s1xmx1 = ( SEEK_1X_MODE_XMT => SEEK_1X_MODE_XMT_1 );
                                      }
    CP_PL_TX_WIDTH_TO_SEEK_1X_MODE_XMT2 : coverpoint xmt_width_state
                                      {
                                        bins s1xmx1_to_s1xmx2 = ( SEEK_1X_MODE_XMT_1 => SEEK_1X_MODE_XMT_2 );
                                      }
    CP_PL_TX_WIDTH_TO_SEEK_1X_MODE_XMT3 : coverpoint xmt_width_state
                                      {
                                        bins s1xmx_to_s1xmx3 = ( SEEK_1X_MODE_XMT => SEEK_1X_MODE_XMT_3 );
                                      //  bins s1xmx1_to_s1xmx3 = ( SEEK_1X_MODE_XMT_1 => SEEK_1X_MODE_XMT_3 );
                                        bins s1xmx2_to_s1xmx3 = ( SEEK_1X_MODE_XMT_2 => SEEK_1X_MODE_XMT_3 );
                                      }
    CP_PL_TX_WIDTH_TO_X1_MODE_XMT_ACK : coverpoint xmt_width_state
                                      {
                                        bins s1xmx2_to_s1xmxa = ( SEEK_1X_MODE_XMT_2 => X1_MODE_XMT_ACK );
                                        bins x1xmx_to_s1xmxa = ( X1_MODE_XMT => X1_MODE_XMT_ACK );
                                      }
    CP_PL_TX_WIDTH_TO_1X_MODE_XMT : coverpoint xmt_width_state
                                      {
                                        bins x1xa_to_1xmx = ( X1_MODE_XMT_ACK => X1_MODE_XMT );
                                       // bins xwn_to_1xmx = ( XMT_WIDTH_NACK => X1_MODE_XMT );
                                      }
    CP_PL_TX_WIDTH_TO_SEEK_2X_MODE_XMT : coverpoint xmt_width_state
                                      {
                                       // bins x1mx_to_s2xmx = ( X1_MODE_XMT => SEEK_2X_MODE_XMT );
                                        bins nxmx_to_s2xmx = ( NX_MODE_XMT => SEEK_2X_MODE_XMT );
                                      }
    CP_PL_TX_WIDTH_TO_SEEK_2X_MODE_XMT1 : coverpoint xmt_width_state
                                      {
                                        bins s2xmx_to_s2xmx1 = ( SEEK_2X_MODE_XMT => SEEK_2X_MODE_XMT_1 );
                                      }
    CP_PL_TX_WIDTH_TO_SEEK_2X_MODE_XMT2 : coverpoint xmt_width_state
                                      {
                                        bins s2xmx1_to_s2xmx2 = ( SEEK_2X_MODE_XMT_1 => SEEK_2X_MODE_XMT_2 );
                                      }
    CP_PL_TX_WIDTH_TO_SEEK_2X_MODE_XMT3 : coverpoint xmt_width_state
                                      {
                                        bins s2xmx_to_s2xmx3 = ( SEEK_2X_MODE_XMT => SEEK_2X_MODE_XMT_3 );
                                       // bins s2xmx1_to_s2xmx3 = ( SEEK_2X_MODE_XMT_1 => SEEK_2X_MODE_XMT_3 );
                                        bins s2xmx2_to_s2xmx3 = ( SEEK_2X_MODE_XMT_2 => SEEK_2X_MODE_XMT_3 );
                                      }
    CP_PL_TX_WIDTH_TO_X2_MODE_XMT_ACK : coverpoint xmt_width_state
                                      {
                                        bins s2xmx2_to_s2xmxa = ( SEEK_2X_MODE_XMT_2 => X2_MODE_XMT_ACK );
                                        bins x2mx_to_s2xmx3 = ( X2_MODE_XMT => X2_MODE_XMT_ACK );
                                      }
    CP_PL_TX_WIDTH_TO_2X_MODE_XMT : coverpoint xmt_width_state
                                      {
                                        bins x2mxa_to_x2mx = ( X2_MODE_XMT_ACK => X2_MODE_XMT );
                                        bins xwn_to_x2mx = ( XMT_WIDTH_NACK => X2_MODE_XMT );
                                      }
 //   CP_PL_TX_WIDTH_TO_SEEK_NX_MODE_XMT : coverpoint xmt_width_state
 //                                     {
 //                                       bins x1mx_to_snxmx = ( X1_MODE_XMT => SEEK_NX_MODE_XMT );
 //                                       bins x2mx_to_snxmx = ( X2_MODE_XMT => SEEK_NX_MODE_XMT );
 //                                     }
 //   CP_PL_TX_WIDTH_TO_SEEK_NX_MODE_XMT1 : coverpoint xmt_width_state
 //                                     {
 //                                       bins snxmx_to_snxmx1 = ( SEEK_NX_MODE_XMT => SEEK_NX_MODE_XMT_1 );
 //                                     }
 //   CP_PL_TX_WIDTH_TO_SEEK_NX_MODE_XMT2 : coverpoint xmt_width_state
 //                                     {
 //                                       bins snxmx1_to_snxmx2 = ( SEEK_NX_MODE_XMT_1 => SEEK_NX_MODE_XMT_2 );
 //                                     }
 //   CP_PL_TX_WIDTH_TO_SEEK_NX_MODE_XMT3 : coverpoint xmt_width_state
 //                                     {
 //                                       bins snxmx_to_snxmx3 = ( SEEK_NX_MODE_XMT => SEEK_NX_MODE_XMT_3 );
 //                                      // bins snxmx1_to_snxmx3 = ( SEEK_NX_MODE_XMT_1 => SEEK_NX_MODE_XMT_3 );
 //                                       bins snxmx2_to_snxmx3 = ( SEEK_NX_MODE_XMT_2 => SEEK_NX_MODE_XMT_3 );
 //                                     }
 //   CP_PL_TX_WIDTH_TO_NX_MODE_XMT_ACK : coverpoint xmt_width_state
 //                                     {
 //                                       bins snxmx2_to_snxmx3 = ( SEEK_NX_MODE_XMT_2 => NX_MODE_XMT_ACK );
 //                                       bins nxmx_to_snxmx3 = ( NX_MODE_XMT => NX_MODE_XMT_ACK );
 //                                     }
    CP_PL_TX_WIDTH_TO_NX_MODE_XMT : coverpoint xmt_width_state
                                      {
                                        bins nxmxa_to_nxmx = ( NX_MODE_XMT_ACK => NX_MODE_XMT );
                                        bins xwnto_nxmx = ( XMT_WIDTH_NACK => NX_MODE_XMT );
                                      }

    CP_PL_TX_WIDTH_PATH_TRANSITIONS : coverpoint xmt_width_state
                                      {
                                        bins axi_nxmx = (ASYM_XMT_IDLE => NX_MODE_XMT);
                                        bins axi_x2mx = (ASYM_XMT_IDLE => X2_MODE_XMT);
                                       // bins axi_x1mx = (ASYM_XMT_IDLE => X1_MODE_XMT);
                                        bins nxmx_nxmxa = (NX_MODE_XMT => NX_MODE_XMT_ACK);
                                        bins nxmx_sx2mx_sx2mx1_sx2mx2_x2mxa_x2mx = (NX_MODE_XMT => SEEK_2X_MODE_XMT => SEEK_2X_MODE_XMT_1 => SEEK_2X_MODE_XMT_2 => X2_MODE_XMT_ACK => X2_MODE_XMT);
                                        //bins nxmx_sx2mx_sx2mx3_xwn_nxmx = (NX_MODE_XMT => SEEK_2X_MODE_XMT => SEEK_2X_MODE_XMT_3 => XMT_WIDTH_NACK => NX_MODE_XMT);
                                        //bins nxmx_sx2mx_sx2mx1_sx2mx3_xwn_nxmx = (NX_MODE_XMT => SEEK_2X_MODE_XMT => SEEK_2X_MODE_XMT_1 => SEEK_2X_MODE_XMT_3 => XMT_WIDTH_NACK => NX_MODE_XMT);
                                        bins nxmx_sx2mx_sx2mx3_xwn_nxmx = (NX_MODE_XMT => SEEK_2X_MODE_XMT => SEEK_2X_MODE_XMT_3 => XMT_WIDTH_NACK => NX_MODE_XMT);
                                        bins nxmx_sx2mx_sx2mx1_sx2mx2_axe_axi = (NX_MODE_XMT => SEEK_2X_MODE_XMT => SEEK_2X_MODE_XMT_1 => SEEK_2X_MODE_XMT_2 => ASYM_XMT_EXIT => ASYM_XMT_IDLE);
                                        bins nxmx_sx1mx_sx1mx1_sx1mx2_x1mxa_x1mx = (NX_MODE_XMT => SEEK_1X_MODE_XMT => SEEK_1X_MODE_XMT_1 => SEEK_1X_MODE_XMT_2 => X1_MODE_XMT_ACK => X1_MODE_XMT);
                                        //bins nxmx_sx1mx_sx1mx3_xwn_nxmx = (NX_MODE_XMT => SEEK_1X_MODE_XMT => SEEK_1X_MODE_XMT_3 => XMT_WIDTH_NACK => NX_MODE_XMT);
                                        //bins nxmx_sx1mx_sx1mx1_sx1mx3_xwn_nxmx = (NX_MODE_XMT => SEEK_1X_MODE_XMT => SEEK_1X_MODE_XMT_1 => SEEK_1X_MODE_XMT_3 => XMT_WIDTH_NACK => NX_MODE_XMT);
                                        bins nxmx_sx1mx_sx1mx3_xwn_nxmx = (NX_MODE_XMT => SEEK_1X_MODE_XMT => SEEK_1X_MODE_XMT_3 => XMT_WIDTH_NACK => NX_MODE_XMT);
                                        bins nxmx_sx1mx_sx1mx1_sx1mx2_axe_axi = (NX_MODE_XMT => SEEK_1X_MODE_XMT => SEEK_1X_MODE_XMT_1 => SEEK_1X_MODE_XMT_2 => ASYM_XMT_EXIT => ASYM_XMT_IDLE);
                                        bins x2mx_x2mxa = (X2_MODE_XMT => X2_MODE_XMT_ACK);
                                        bins x1mx_x1mxa = (X1_MODE_XMT => X1_MODE_XMT_ACK);
                                       // bins x2mx_snxmx_snxmx1_snxmx2_nxmxa_nxmx = (X2_MODE_XMT => SEEK_NX_MODE_XMT => SEEK_NX_MODE_XMT_1 => SEEK_NX_MODE_XMT_2 => NX_MODE_XMT_ACK => NX_MODE_XMT);
                                       // bins x2mx_snxmx_snxmx3_xwn_x2mx = (X2_MODE_XMT => SEEK_NX_MODE_XMT => SEEK_NX_MODE_XMT_3 => XMT_WIDTH_NACK => X2_MODE_XMT);
                                       // bins x2mx_snxmx_snxmx1_snxmx3_xwn_x2mx = (X2_MODE_XMT => SEEK_NX_MODE_XMT => SEEK_NX_MODE_XMT_1 => SEEK_NX_MODE_XMT_3 => XMT_WIDTH_NACK => X2_MODE_XMT);
                                       // bins x2mx_snxmx_snxmx2_snxmx3_xwn_x2mx = (X2_MODE_XMT => SEEK_NX_MODE_XMT => SEEK_NX_MODE_XMT_2 => SEEK_NX_MODE_XMT_3 => XMT_WIDTH_NACK => X2_MODE_XMT);
                                       // bins x2mx_snxmx_snxmx1_snxmx2_axe_axi = (X2_MODE_XMT => SEEK_NX_MODE_XMT => SEEK_NX_MODE_XMT_1 => SEEK_NX_MODE_XMT_2 => ASYM_XMT_EXIT => ASYM_XMT_IDLE);
                                        bins x2mx_sx1mx_sx1mx1_sx1mx2_x1mxa_x1mx = (X2_MODE_XMT => SEEK_1X_MODE_XMT => SEEK_1X_MODE_XMT_1 => SEEK_1X_MODE_XMT_2 => X1_MODE_XMT_ACK => X1_MODE_XMT);
                                        // bins x2mx_sx1mx_sx1mx3_xwn_x1mx = (X2_MODE_XMT => SEEK_1X_MODE_XMT => SEEK_1X_MODE_XMT_3 => XMT_WIDTH_NACK => X1_MODE_XMT);
                                       // bins x2mx_sx1mx_sx1mx1_sx1mx3_xwn_x1mx = (X2_MODE_XMT => SEEK_1X_MODE_XMT => SEEK_1X_MODE_XMT_1 => SEEK_1X_MODE_XMT_3 => XMT_WIDTH_NACK => X1_MODE_XMT);
                                        bins x2mx_sx1mx_s1mx1_sx1mx2_sx1mx3_xwn_x2mx = (X2_MODE_XMT => SEEK_1X_MODE_XMT => SEEK_1X_MODE_XMT_1 => SEEK_1X_MODE_XMT_2 => SEEK_1X_MODE_XMT_3 => XMT_WIDTH_NACK => X2_MODE_XMT);
                                        bins x2mx_sx1mx_sx1mx1_sx1mx2_axe_axi = (X2_MODE_XMT => SEEK_1X_MODE_XMT => SEEK_1X_MODE_XMT_1 => SEEK_1X_MODE_XMT_2 => ASYM_XMT_EXIT => ASYM_XMT_IDLE);
                                       // bins x1mx_snxmx_snxmx3_xwn_x1mx = (X1_MODE_XMT => SEEK_NX_MODE_XMT => SEEK_NX_MODE_XMT_3 => XMT_WIDTH_NACK => X1_MODE_XMT);
                                       // bins x1mx_snxmx_snxmx1_snxmx3_xwn_x1mx = (X1_MODE_XMT => SEEK_NX_MODE_XMT => SEEK_NX_MODE_XMT_1 => SEEK_NX_MODE_XMT_3 => XMT_WIDTH_NACK => X1_MODE_XMT);
                                       // bins x1mx_snxmx_snxmx2_snxmx3_xwn_x1mx = (X1_MODE_XMT => SEEK_NX_MODE_XMT => SEEK_NX_MODE_XMT_2 => SEEK_NX_MODE_XMT_3 => XMT_WIDTH_NACK => X1_MODE_XMT);
                                      //  bins x1mx_snxmx_snxmx1_snxmx2_axe_axi = (X1_MODE_XMT => SEEK_NX_MODE_XMT => SEEK_NX_MODE_XMT_1=> SEEK_NX_MODE_XMT_2 => ASYM_XMT_EXIT => ASYM_XMT_IDLE);
                                      //  bins x1mx_sx2mx_sx2mx3_xwn_x1mx = (X1_MODE_XMT => SEEK_2X_MODE_XMT => SEEK_2X_MODE_XMT_3 => XMT_WIDTH_NACK => X1_MODE_XMT);
                                      //  bins x1mx_sx2mx_sx2mx1_sx2mx3_xwn_x1mx = (X1_MODE_XMT => SEEK_2X_MODE_XMT => SEEK_2X_MODE_XMT_1 => SEEK_2X_MODE_XMT_3 => XMT_WIDTH_NACK => X1_MODE_XMT);
                                      //  bins x1mx_sx2mx_sx2mx2_sx2mx3_xwn_x1mx = (X1_MODE_XMT => SEEK_2X_MODE_XMT => SEEK_2X_MODE_XMT_2 => SEEK_2X_MODE_XMT_3 => XMT_WIDTH_NACK => X1_MODE_XMT);
                                      //  bins x1mx_sx2mx_sx2mx1_sx2mx2_axe_axi = (X1_MODE_XMT => SEEK_2X_MODE_XMT => SEEK_2X_MODE_XMT_1=> SEEK_2X_MODE_XMT_2 => ASYM_XMT_EXIT => ASYM_XMT_IDLE);
                                      }

  endgroup
// =============================================================================

  covergroup CG_GEN3_PL_RECEIVE_WIDTH_CMD_SM;
    option.per_instance = 1;
    CP_PL_RX_WIDTH_CMD_NEXT_STATE : coverpoint rcv_width_cmd_state;
    CP_PL_RX_WIDTH_CMD_TO_RCV_WIDTH_CMD2 : coverpoint rcv_width_cmd_state
                                           {
                                             bins bin1 = ( RCV_WIDTH_CMD_1 => RCV_WIDTH_CMD_2 );
                                             bins bin2 = ( RCV_WIDTH_CMD_IDLE => RCV_WIDTH_CMD_2 );
                                           }
    CP_PL_RX_WIDTH_CMD_TO_RCV_WIDTH_CMD3 : coverpoint rcv_width_cmd_state
                                           {
                                             bins bin1 = ( RCV_WIDTH_CMD_2 => RCV_WIDTH_CMD_3 );
                                           }
    CP_PL_RX_WIDTH_CMD_TO_RCV_WIDTH_CMD_IDLE : coverpoint rcv_width_cmd_state
                                           {
                                             bins bin1 = ( RCV_WIDTH_CMD_3 => RCV_WIDTH_CMD_IDLE );
                                           }
    CP_PL_RX_WIDTH_CMD_TO_RCV_WIDTH_CMD1 : coverpoint rcv_width_cmd_state
                                           {
                                             bins bin1 = ( RCV_WIDTH_CMD_IDLE => RCV_WIDTH_CMD_1 );
                                           }
    CP_PL_RX_WIDTH_CMD_PATH_TRANSITIONS : coverpoint rcv_width_cmd_state
                                 {
                                   bins rwc3_rwci_rwc2_rwc3 = ( RCV_WIDTH_CMD_3 => RCV_WIDTH_CMD_IDLE => RCV_WIDTH_CMD_2 => RCV_WIDTH_CMD_3);
                                   bins rwc3_rwci_rwc1_rwc2_rwc3 = ( RCV_WIDTH_CMD_3 => RCV_WIDTH_CMD_IDLE => RCV_WIDTH_CMD_1 => RCV_WIDTH_CMD_2 => RCV_WIDTH_CMD_3);
                                 }
  endgroup
// =============================================================================

  covergroup CG_GEN3_PL_RECEIVE_WIDTH_SM;
    option.per_instance = 1;

    CP_PL_RX_WIDTH_NEXT_STATE : coverpoint rcv_width_state;

    CP_PL_ASYM_MODE: coverpoint asym_mode;
   
    CP_PL_PISM_SILENT : coverpoint pism_silent;

    CP_PL_RX_WIDTH_TO_ASYM_RCV_EXIT : coverpoint rcv_width_state
                                      {
                                        bins bin1 = ( SEEK_1X_MODE_RCV => ASYM_RCV_EXIT );
                                        bins bin2 = ( X1_RECOVERY_RCV => ASYM_RCV_EXIT );
                                        bins bin3 = ( X1_MODE_RCV => ASYM_RCV_EXIT );
                                        bins bin4 = ( SEEK_2X_MODE_RCV => ASYM_RCV_EXIT );
                                        bins bin5 = ( X2_RECOVERY_RCV => ASYM_RCV_EXIT );
                                        bins bin6 = ( X2_MODE_RCV => ASYM_RCV_EXIT );
                                       // bins bin7 = ( SEEK_NX_MODE_RCV => ASYM_RCV_EXIT );
                                       // bins bin8 = ( NX_RECOVERY_RCV => ASYM_RCV_EXIT );
                                       // bins bin9 = ( NX_MODE_RCV => ASYM_RCV_EXIT );
                                      }
    CP_PL_RX_WIDTH_TO_ASYM_RCV_IDLE : coverpoint rcv_width_state
                                      {
                                        bins bin1 = ( ASYM_RCV_EXIT => ASYM_RCV_IDLE );
                                      }
    CP_PL_RX_WIDTH_TO_RCV_WIDTH_NACK : coverpoint rcv_width_state
                                      {
                                        bins bin1 = ( SEEK_1X_MODE_RCV => RCV_WIDTH_NACK );
                                        bins bin2 = ( SEEK_2X_MODE_RCV => RCV_WIDTH_NACK );
                                       // bins bin3 = ( SEEK_NX_MODE_RCV => RCV_WIDTH_NACK );
                                      }
    CP_PL_RX_WIDTH_TO_SEEK_1X_MODE_RCV : coverpoint rcv_width_state
                                      {
                                        bins bin1 = ( X2_MODE_RCV => SEEK_1X_MODE_RCV );
                                        bins bin2 = ( NX_MODE_RCV => SEEK_1X_MODE_RCV );
                                      }
    CP_PL_RX_WIDTH_TO_SEEK_1X_MODE_RCV_ACK : coverpoint rcv_width_state
                                      {
                                        bins bin1 = ( X2_MODE_RCV => SEEK_1X_MODE_RCV );
                                        bins bin2 = ( NX_MODE_RCV => SEEK_1X_MODE_RCV );
                                      }
    CP_PL_RX_WIDTH_TO_1X_RETRAIN : coverpoint rcv_width_state
                                      {
                                        bins bin1 = ( X1_RECOVERY_RCV => X1_RETRAIN_RCV );
                                      }
    CP_PL_RX_WIDTH_TO_1X_RECOVERY : coverpoint rcv_width_state
                                      {
                                        bins bin1 = ( X1_RETRAIN_RCV => X1_RECOVERY_RCV );
                                      //  bins bin2 = ( RCV_WIDTH_NACK => X1_RECOVERY_RCV );
                                        bins bin3 = ( X1_MODE_RCV => X1_RECOVERY_RCV );
                                      }
    CP_PL_RX_WIDTH_TO_1X_MODE_RCV : coverpoint rcv_width_state
                                      {
                                      //  bins bin1 = ( SEEK_1X_MODE_RCV => X1_MODE_RCV );
                                        bins bin2 = ( X1_RECOVERY_RCV => X1_MODE_RCV );
                                      }
    CP_PL_RX_WIDTH_TO_SEEK_2X_MODE_RCV : coverpoint rcv_width_state
                                      {
                                       // bins x1mx_to_s2xmx = ( X1_MODE_RCV => SEEK_2X_MODE_RCV );
                                        bins nxmx_to_s2xmx = ( NX_MODE_RCV => SEEK_2X_MODE_RCV );
                                      }
    CP_PL_RX_WIDTH_TO_X2_MODE_RCV_ACK : coverpoint rcv_width_state
                                      {
                                        bins bin1 = ( SEEK_2X_MODE_RCV => X2_MODE_RCV_ACK );
                                        bins bin2 = ( X2_MODE_RCV => X2_MODE_RCV_ACK );
                                      }
    CP_PL_RX_WIDTH_TO_2X_RETRAIN : coverpoint rcv_width_state
                                      {
                                        bins bin1 = ( X2_RECOVERY_RCV => X2_RETRAIN_RCV );
                                      }
    CP_PL_RX_WIDTH_TO_2X_RECOVERY : coverpoint rcv_width_state
                                      {
                                        bins bin1 = ( X2_RETRAIN_RCV => X2_RECOVERY_RCV );
                                        bins bin2 = ( RCV_WIDTH_NACK => X2_RECOVERY_RCV );
                                        bins bin3 = ( X2_MODE_RCV => X2_RECOVERY_RCV );
                                      }
    CP_PL_RX_WIDTH_TO_2X_MODE_RCV : coverpoint rcv_width_state
                                      {
                                       // bins bin1 = ( SEEK_2X_MODE_RCV => X2_MODE_RCV );
                                        bins bin2 = ( X2_RECOVERY_RCV => X2_MODE_RCV );
                                        bins bin3 = ( ASYM_RCV_IDLE => X2_MODE_RCV );
                                      }
 //   CP_PL_RX_WIDTH_TO_SEEK_NX_MODE_RCV : coverpoint rcv_width_state
 //                                     {
 //                                       bins x1mx_to_snxmx = ( X1_MODE_RCV => SEEK_NX_MODE_RCV );
 //                                       bins x2mx_to_snxmx = ( X2_MODE_RCV => SEEK_NX_MODE_RCV );
 //                                     }
 //   CP_PL_RX_WIDTH_TO_NX_MODE_RCV_ACK : coverpoint rcv_width_state
 //                                     {
 //                                       bins snxmx2_to_snxmx3 = ( SEEK_NX_MODE_RCV => NX_MODE_RCV_ACK );
 //                                       bins nxmx_to_snxmx3 = ( NX_MODE_RCV => NX_MODE_RCV_ACK );
 //                                     }
 //   CP_PL_RX_WIDTH_TO_NX_RETRAIN : coverpoint rcv_width_state
 //                                     {
 //                                       bins bin1 = ( NX_RECOVERY_RCV => NX_RETRAIN_RCV );
 //                                     }
 //   CP_PL_RX_WIDTH_TO_NX_RECOVERY : coverpoint rcv_width_state
 //                                     {
 //                                       bins bin1 = ( NX_RETRAIN_RCV => NX_RECOVERY_RCV );
 //                                       bins bin2 = ( RCV_WIDTH_NACK => NX_RECOVERY_RCV );
 //                                       bins bin3 = ( NX_MODE_RCV => NX_RECOVERY_RCV );
 //                                     }
    CP_PL_RX_WIDTH_TO_NX_MODE_RCV : coverpoint rcv_width_state
                                      {
                                       // bins bin1 = ( NX_MODE_RCV_ACK => NX_MODE_RCV );
                                        bins bin2 = ( NX_RECOVERY_RCV => NX_MODE_RCV );
                                        bins bin3 = ( ASYM_RCV_IDLE => NX_MODE_RCV );
                                      }
   CP_PL_RX_WIDTH_PATH_TRANSITIONS : coverpoint rcv_width_state
                                      {
                                        bins ari_nxmr = (ASYM_RCV_IDLE => NX_MODE_RCV);
                                        bins ari_x2mr = (ASYM_RCV_IDLE => X2_MODE_RCV);
                                       // bins nxmr_nxrec_nxmr = (NX_MODE_RCV => NX_RECOVERY_RCV => NX_MODE_RCV);
                                       // bins nxmr_nxrec_nxrn_nxrec_nxmr = (NX_MODE_RCV => NX_RECOVERY_RCV => NX_RETRAIN_RCV => NX_RECOVERY_RCV => NX_MODE_RCV);
                                       // bins nxmr_nxrec_nxrn_nxrec_are_ari = (NX_MODE_RCV => NX_RECOVERY_RCV => NX_RETRAIN_RCV => NX_RECOVERY_RCV => ASYM_RCV_EXIT => ASYM_RCV_IDLE);
                                        bins x2mr_x2rec_x2mr= (X2_MODE_RCV => X2_RECOVERY_RCV => X2_MODE_RCV);
                                        bins x2mr_x2rec_x2rn_x2rec_x2mr= (X2_MODE_RCV => X2_RECOVERY_RCV => X2_RETRAIN_RCV => X2_RECOVERY_RCV => X2_MODE_RCV);
                                        bins x2mr_x2rec_x2rn_x2rec_are_ari= (X2_MODE_RCV => X2_RECOVERY_RCV => X2_RETRAIN_RCV => X2_RECOVERY_RCV => ASYM_RCV_EXIT => ASYM_RCV_IDLE);
                                        bins x1mr_x1rec_x1mr= (X1_MODE_RCV => X1_RECOVERY_RCV => X1_MODE_RCV);
                                        bins x1mr_x1rec_x1rn_x1rec_x1mr= (X1_MODE_RCV => X1_RECOVERY_RCV => X1_RETRAIN_RCV => X1_RECOVERY_RCV => X1_MODE_RCV);
                                        bins x1mr_x1rec_x1rn_x1rec_are_ari= (X1_MODE_RCV => X1_RECOVERY_RCV => X1_RETRAIN_RCV => X1_RECOVERY_RCV => ASYM_RCV_EXIT => ASYM_RCV_IDLE);
                                        bins nxmr_sx2mr_rwn_nxrec_nxmr = (NX_MODE_RCV => SEEK_2X_MODE_RCV => RCV_WIDTH_NACK => NX_RECOVERY_RCV => NX_MODE_RCV);
                                        bins nxmr_sx2mr_are_ari = (NX_MODE_RCV => SEEK_2X_MODE_RCV => ASYM_RCV_EXIT => ASYM_RCV_IDLE);
                                        bins nxmr_sx2mr_x2mra_x2mr = (NX_MODE_RCV => SEEK_2X_MODE_RCV => X2_MODE_RCV_ACK => X2_MODE_RCV);
                                        bins nxmr_sx1mr_rwn_nxrec_nxmr = (NX_MODE_RCV => SEEK_1X_MODE_RCV => RCV_WIDTH_NACK => NX_RECOVERY_RCV => NX_MODE_RCV);
                                        bins nxmr_sx1mr_are_ari = (NX_MODE_RCV => SEEK_1X_MODE_RCV => ASYM_RCV_EXIT => ASYM_RCV_IDLE);
                                        bins nxmr_s1xmr_x1mra_x1mr = (NX_MODE_RCV => SEEK_1X_MODE_RCV => X1_MODE_RCV_ACK => X1_MODE_RCV);
                                       // bins x2mr_snxmr_rwn_x2rec_x2mr = (X2_MODE_RCV => SEEK_NX_MODE_RCV => RCV_WIDTH_NACK => X2_RECOVERY_RCV => X2_MODE_RCV);
                                       // bins x2mr_snxmr_are_ari = (X2_MODE_RCV => SEEK_NX_MODE_RCV => ASYM_RCV_EXIT => ASYM_RCV_IDLE);
                                       // bins x2mr_snxmr_nxmra_nxmr = (X2_MODE_RCV => SEEK_NX_MODE_RCV => NX_MODE_RCV_ACK => NX_MODE_RCV);
                                        bins x2mr_s1xmr_rwn_x2rec_x2mr = (X2_MODE_RCV => SEEK_1X_MODE_RCV => RCV_WIDTH_NACK => X2_RECOVERY_RCV => X2_MODE_RCV);
                                        bins x2mr_s1xmr_are_ari = (X2_MODE_RCV => SEEK_1X_MODE_RCV => ASYM_RCV_EXIT => ASYM_RCV_IDLE);
                                        bins x2mr_s1xmr_x1mra_x1mr = (X2_MODE_RCV => SEEK_1X_MODE_RCV => X1_MODE_RCV_ACK => X1_MODE_RCV);
                                       // bins x1mr_snxmr_rwn_x1rec_x1mr = (X1_MODE_RCV => SEEK_NX_MODE_RCV => RCV_WIDTH_NACK => X1_RECOVERY_RCV => X1_MODE_RCV);
                                       // bins x1mr_snxmr_are_ari = (X1_MODE_RCV => SEEK_NX_MODE_RCV => ASYM_RCV_EXIT => ASYM_RCV_IDLE);
                                       // bins x1mr_snxmr_nxmra_nxmr = (X1_MODE_RCV => SEEK_NX_MODE_RCV => NX_MODE_RCV_ACK => NX_MODE_RCV);
                                       // bins x1mr_sx2mr_rwn_x1rec_x1mr = (X1_MODE_RCV => SEEK_2X_MODE_RCV => RCV_WIDTH_NACK => X1_RECOVERY_RCV => X1_MODE_RCV);
                                       // bins x1mr_sx2mr_are_ari = (X1_MODE_RCV => SEEK_2X_MODE_RCV => ASYM_RCV_EXIT => ASYM_RCV_IDLE);
                                       // bins x1mr_sx2mr_x2mrec_x2mr = (X1_MODE_RCV => SEEK_2X_MODE_RCV => X2_MODE_RCV_ACK => X2_MODE_RCV);
                                      }

  endgroup
// =============================================================================

  `CG_GEN3_PL_FRAME_LOCK_SM(0)
  `CG_GEN3_PL_FRAME_LOCK_SM(1)
  `CG_GEN3_PL_FRAME_LOCK_SM(2)
  `CG_GEN3_PL_FRAME_LOCK_SM(3)
  `CG_GEN3_PL_FRAME_LOCK_SM(4)
  `CG_GEN3_PL_FRAME_LOCK_SM(5)
  `CG_GEN3_PL_FRAME_LOCK_SM(6)
  `CG_GEN3_PL_FRAME_LOCK_SM(7)
  `CG_GEN3_PL_FRAME_LOCK_SM(8)
  `CG_GEN3_PL_FRAME_LOCK_SM(9)
  `CG_GEN3_PL_FRAME_LOCK_SM(10)
  `CG_GEN3_PL_FRAME_LOCK_SM(11)
  `CG_GEN3_PL_FRAME_LOCK_SM(12)
  `CG_GEN3_PL_FRAME_LOCK_SM(13)
  `CG_GEN3_PL_FRAME_LOCK_SM(14)
  `CG_GEN3_PL_FRAME_LOCK_SM(15)

  `CG_GEN3_PL_C0_COEFF_UPDATE_SM(0)
  `CG_GEN3_PL_C0_COEFF_UPDATE_SM(1)
  `CG_GEN3_PL_C0_COEFF_UPDATE_SM(2)
  `CG_GEN3_PL_C0_COEFF_UPDATE_SM(3)
  `CG_GEN3_PL_C0_COEFF_UPDATE_SM(4)
  `CG_GEN3_PL_C0_COEFF_UPDATE_SM(5)
  `CG_GEN3_PL_C0_COEFF_UPDATE_SM(6)
  `CG_GEN3_PL_C0_COEFF_UPDATE_SM(7)
  `CG_GEN3_PL_C0_COEFF_UPDATE_SM(8)
  `CG_GEN3_PL_C0_COEFF_UPDATE_SM(9)
  `CG_GEN3_PL_C0_COEFF_UPDATE_SM(10)
  `CG_GEN3_PL_C0_COEFF_UPDATE_SM(11)
  `CG_GEN3_PL_C0_COEFF_UPDATE_SM(12)
  `CG_GEN3_PL_C0_COEFF_UPDATE_SM(13)
  `CG_GEN3_PL_C0_COEFF_UPDATE_SM(14)
  `CG_GEN3_PL_C0_COEFF_UPDATE_SM(15)
  `CG_GEN3_PL_CP1_COEFF_UPDATE_SM(0)
  `CG_GEN3_PL_CP1_COEFF_UPDATE_SM(1)
  `CG_GEN3_PL_CP1_COEFF_UPDATE_SM(2)
  `CG_GEN3_PL_CP1_COEFF_UPDATE_SM(3)
  `CG_GEN3_PL_CP1_COEFF_UPDATE_SM(4)
  `CG_GEN3_PL_CP1_COEFF_UPDATE_SM(5)
  `CG_GEN3_PL_CP1_COEFF_UPDATE_SM(6)
  `CG_GEN3_PL_CP1_COEFF_UPDATE_SM(7)
  `CG_GEN3_PL_CP1_COEFF_UPDATE_SM(8)
  `CG_GEN3_PL_CP1_COEFF_UPDATE_SM(9)
  `CG_GEN3_PL_CP1_COEFF_UPDATE_SM(10)
  `CG_GEN3_PL_CP1_COEFF_UPDATE_SM(11)
  `CG_GEN3_PL_CP1_COEFF_UPDATE_SM(12)
  `CG_GEN3_PL_CP1_COEFF_UPDATE_SM(13)
  `CG_GEN3_PL_CP1_COEFF_UPDATE_SM(14)
  `CG_GEN3_PL_CP1_COEFF_UPDATE_SM(15)
  `CG_GEN3_PL_CN1_COEFF_UPDATE_SM(0)
  `CG_GEN3_PL_CN1_COEFF_UPDATE_SM(1)
  `CG_GEN3_PL_CN1_COEFF_UPDATE_SM(2)
  `CG_GEN3_PL_CN1_COEFF_UPDATE_SM(3)
  `CG_GEN3_PL_CN1_COEFF_UPDATE_SM(4)
  `CG_GEN3_PL_CN1_COEFF_UPDATE_SM(5)
  `CG_GEN3_PL_CN1_COEFF_UPDATE_SM(6)
  `CG_GEN3_PL_CN1_COEFF_UPDATE_SM(7)
  `CG_GEN3_PL_CN1_COEFF_UPDATE_SM(8)
  `CG_GEN3_PL_CN1_COEFF_UPDATE_SM(9)
  `CG_GEN3_PL_CN1_COEFF_UPDATE_SM(10)
  `CG_GEN3_PL_CN1_COEFF_UPDATE_SM(11)
  `CG_GEN3_PL_CN1_COEFF_UPDATE_SM(12)
  `CG_GEN3_PL_CN1_COEFF_UPDATE_SM(13)
  `CG_GEN3_PL_CN1_COEFF_UPDATE_SM(14)
  `CG_GEN3_PL_CN1_COEFF_UPDATE_SM(15)

  extern function new(string name = "srio_pl_func_coverage", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task update_state_machine();

endclass: srio_pl_func_coverage

function srio_pl_func_coverage::new(string name = "srio_pl_func_coverage", uvm_component parent = null);
  super.new(name, parent);

  CG_GEN3_PL_TX_SEEDOS_LINKREQ_SEQ  = new();     

  CG_GEN3_PL_TX_OS_LANE0  = new();     
  CG_GEN3_PL_TX_OS_LANE1  = new();     
  CG_GEN3_PL_TX_OS_LANE2  = new();     
  CG_GEN3_PL_TX_OS_LANE3  = new();     
  CG_GEN3_PL_TX_OS_LANE4  = new();     
  CG_GEN3_PL_TX_OS_LANE5  = new();     
  CG_GEN3_PL_TX_OS_LANE6  = new();     
  CG_GEN3_PL_TX_OS_LANE7  = new();     
  CG_GEN3_PL_TX_OS_LANE8  = new();     
  CG_GEN3_PL_TX_OS_LANE9  = new();     
  CG_GEN3_PL_TX_OS_LANE10 = new();     
  CG_GEN3_PL_TX_OS_LANE11 = new();     
  CG_GEN3_PL_TX_OS_LANE12 = new();     
  CG_GEN3_PL_TX_OS_LANE13 = new();     
  CG_GEN3_PL_TX_OS_LANE14 = new();     
  CG_GEN3_PL_TX_OS_LANE15 = new();     


  CG_GEN3_PL_TX_AET_LANE0 = new();                          
  CG_GEN3_PL_TX_AET_LANE1 = new();                          
  CG_GEN3_PL_TX_AET_LANE2 = new();                          
  CG_GEN3_PL_TX_AET_LANE3 = new();                          
  CG_GEN3_PL_TX_AET_LANE4 = new();                          
  CG_GEN3_PL_TX_AET_LANE5 = new();                          
  CG_GEN3_PL_TX_AET_LANE6 = new();                          
  CG_GEN3_PL_TX_AET_LANE7 = new();                          
  CG_GEN3_PL_TX_AET_LANE8 = new();                          
  CG_GEN3_PL_TX_AET_LANE9 = new();                          
  CG_GEN3_PL_TX_AET_LANE10 = new();                          
  CG_GEN3_PL_TX_AET_LANE11 = new();                          
  CG_GEN3_PL_TX_AET_LANE12 = new();                          
  CG_GEN3_PL_TX_AET_LANE13 = new();                          
  CG_GEN3_PL_TX_AET_LANE14 = new();                          
  CG_GEN3_PL_TX_AET_LANE15 = new();                          

  CG_GEN3_PL_TX_AET_TAP_CMDSTS_LANE0 = new();                          
  CG_GEN3_PL_TX_AET_TAP_CMDSTS_LANE1 = new();                          
  CG_GEN3_PL_TX_AET_TAP_CMDSTS_LANE2 = new();                          
  CG_GEN3_PL_TX_AET_TAP_CMDSTS_LANE3 = new();                          
  CG_GEN3_PL_TX_AET_TAP_CMDSTS_LANE4 = new();                          
  CG_GEN3_PL_TX_AET_TAP_CMDSTS_LANE5 = new();                          
  CG_GEN3_PL_TX_AET_TAP_CMDSTS_LANE6 = new();                          
  CG_GEN3_PL_TX_AET_TAP_CMDSTS_LANE7 = new();                          
  CG_GEN3_PL_TX_AET_TAP_CMDSTS_LANE8 = new();                          
  CG_GEN3_PL_TX_AET_TAP_CMDSTS_LANE9 = new();                          
  CG_GEN3_PL_TX_AET_TAP_CMDSTS_LANE10 = new();                          
  CG_GEN3_PL_TX_AET_TAP_CMDSTS_LANE11 = new();                          
  CG_GEN3_PL_TX_AET_TAP_CMDSTS_LANE12 = new();                          
  CG_GEN3_PL_TX_AET_TAP_CMDSTS_LANE13 = new();                          
  CG_GEN3_PL_TX_AET_TAP_CMDSTS_LANE14 = new();                          
  CG_GEN3_PL_TX_AET_TAP_CMDSTS_LANE15 = new();                          

  CG_GEN3_PL_TX_CODE_WORD_LANE0 = new();      
  CG_GEN3_PL_TX_CODE_WORD_LANE1 = new();                          
  CG_GEN3_PL_TX_CODE_WORD_LANE2 = new();                          
  CG_GEN3_PL_TX_CODE_WORD_LANE3 = new();                          
  CG_GEN3_PL_TX_CODE_WORD_LANE4 = new();                          
  CG_GEN3_PL_TX_CODE_WORD_LANE5 = new();                          
  CG_GEN3_PL_TX_CODE_WORD_LANE6 = new();                          
  CG_GEN3_PL_TX_CODE_WORD_LANE7 = new();                          
  CG_GEN3_PL_TX_CODE_WORD_LANE8 = new();                          
  CG_GEN3_PL_TX_CODE_WORD_LANE9 = new();                          
  CG_GEN3_PL_TX_CODE_WORD_LANE10 = new();                          
  CG_GEN3_PL_TX_CODE_WORD_LANE11 = new();                          
  CG_GEN3_PL_TX_CODE_WORD_LANE12 = new();                          
  CG_GEN3_PL_TX_CODE_WORD_LANE13 = new();                          
  CG_GEN3_PL_TX_CODE_WORD_LANE14 = new();                          
  CG_GEN3_PL_TX_CODE_WORD_LANE15 = new();                          

  CG_GEN3_PL_RX_CODE_WORD_LANE0 = new();      
  CG_GEN3_PL_RX_CODE_WORD_LANE1 = new();                          
  CG_GEN3_PL_RX_CODE_WORD_LANE2 = new();                          
  CG_GEN3_PL_RX_CODE_WORD_LANE3 = new();                          
  CG_GEN3_PL_RX_CODE_WORD_LANE4 = new();                          
  CG_GEN3_PL_RX_CODE_WORD_LANE5 = new();                          
  CG_GEN3_PL_RX_CODE_WORD_LANE6 = new();                          
  CG_GEN3_PL_RX_CODE_WORD_LANE7 = new();                          
  CG_GEN3_PL_RX_CODE_WORD_LANE8 = new();                          
  CG_GEN3_PL_RX_CODE_WORD_LANE9 = new();                          
  CG_GEN3_PL_RX_CODE_WORD_LANE10 = new();                          
  CG_GEN3_PL_RX_CODE_WORD_LANE11 = new();                          
  CG_GEN3_PL_RX_CODE_WORD_LANE12 = new();                          
  CG_GEN3_PL_RX_CODE_WORD_LANE13 = new();                          
  CG_GEN3_PL_RX_CODE_WORD_LANE14 = new();                          
  CG_GEN3_PL_RX_CODE_WORD_LANE15 = new();                          

  CG_GEN3_PL_RX_OS_LANE0  = new();     
  CG_GEN3_PL_RX_OS_LANE1  = new();     
  CG_GEN3_PL_RX_OS_LANE2  = new();     
  CG_GEN3_PL_RX_OS_LANE3  = new();     
  CG_GEN3_PL_RX_OS_LANE4  = new();     
  CG_GEN3_PL_RX_OS_LANE5  = new();     
  CG_GEN3_PL_RX_OS_LANE6  = new();     
  CG_GEN3_PL_RX_OS_LANE7  = new();     
  CG_GEN3_PL_RX_OS_LANE8  = new();     
  CG_GEN3_PL_RX_OS_LANE9  = new();     
  CG_GEN3_PL_RX_OS_LANE10 = new();     
  CG_GEN3_PL_RX_OS_LANE11 = new();     
  CG_GEN3_PL_RX_OS_LANE12 = new();     
  CG_GEN3_PL_RX_OS_LANE13 = new();     
  CG_GEN3_PL_RX_OS_LANE14 = new();     
  CG_GEN3_PL_RX_OS_LANE15 = new();     
                      
  CG_GEN3_PL_RX_AET_LANE0 = new();                          
  CG_GEN3_PL_RX_AET_LANE1 = new();                          
  CG_GEN3_PL_RX_AET_LANE2 = new();                          
  CG_GEN3_PL_RX_AET_LANE3 = new();                          
  CG_GEN3_PL_RX_AET_LANE4 = new();                          
  CG_GEN3_PL_RX_AET_LANE5 = new();                          
  CG_GEN3_PL_RX_AET_LANE6 = new();                          
  CG_GEN3_PL_RX_AET_LANE7 = new();                          
  CG_GEN3_PL_RX_AET_LANE8 = new();                          
  CG_GEN3_PL_RX_AET_LANE9 = new();                          
  CG_GEN3_PL_RX_AET_LANE10 = new();                          
  CG_GEN3_PL_RX_AET_LANE11 = new();                          
  CG_GEN3_PL_RX_AET_LANE12 = new();                          
  CG_GEN3_PL_RX_AET_LANE13 = new();                          
  CG_GEN3_PL_RX_AET_LANE14 = new();                          
  CG_GEN3_PL_RX_AET_LANE15 = new();                          

  CG_GEN3_PL_RX_AET_TAP_CMDSTS_LANE0 = new();                          
  CG_GEN3_PL_RX_AET_TAP_CMDSTS_LANE1 = new();                          
  CG_GEN3_PL_RX_AET_TAP_CMDSTS_LANE2 = new();                          
  CG_GEN3_PL_RX_AET_TAP_CMDSTS_LANE3 = new();                          
  CG_GEN3_PL_RX_AET_TAP_CMDSTS_LANE4 = new();                          
  CG_GEN3_PL_RX_AET_TAP_CMDSTS_LANE5 = new();                          
  CG_GEN3_PL_RX_AET_TAP_CMDSTS_LANE6 = new();                          
  CG_GEN3_PL_RX_AET_TAP_CMDSTS_LANE7 = new();                          
  CG_GEN3_PL_RX_AET_TAP_CMDSTS_LANE8 = new();                          
  CG_GEN3_PL_RX_AET_TAP_CMDSTS_LANE9 = new();                          
  CG_GEN3_PL_RX_AET_TAP_CMDSTS_LANE10 = new();                          
  CG_GEN3_PL_RX_AET_TAP_CMDSTS_LANE11 = new();                          
  CG_GEN3_PL_RX_AET_TAP_CMDSTS_LANE12 = new();                          
  CG_GEN3_PL_RX_AET_TAP_CMDSTS_LANE13 = new();                          
  CG_GEN3_PL_RX_AET_TAP_CMDSTS_LANE14 = new();                          
  CG_GEN3_PL_RX_AET_TAP_CMDSTS_LANE15 = new();                          

  CG_GEN3_PL_CRC = new();      
  CG_GEN3_PL_LENGTH = new();      
  CG_GEN3_PL_ASYMMETRY = new();      
  CG_GEN3_PL_TSG = new();      
  CG_GEN3_PL_TERMINATING_PKT_LENGTH1 = new();      
  CG_GEN3_PL_TERMINATING_PKT_LENGTH2 = new();      

  CG_PL = new();
  CG_PL_TX = new();
  CG_PL_RX = new();
  CG_PL_SM_VARIABLE = new();
  CG_PL_SYNC_SM_LANE0  = new();
  CG_PL_SYNC_SM_LANE1  = new();
  CG_PL_SYNC_SM_LANE2  = new();
  CG_PL_SYNC_SM_LANE3  = new();
  CG_PL_SYNC_SM_LANE4  = new();
  CG_PL_SYNC_SM_LANE5  = new();
  CG_PL_SYNC_SM_LANE6  = new();
  CG_PL_SYNC_SM_LANE7  = new();
  CG_PL_SYNC_SM_LANE8  = new();
  CG_PL_SYNC_SM_LANE9  = new();
  CG_PL_SYNC_SM_LANE10 = new();
  CG_PL_SYNC_SM_LANE11 = new();
  CG_PL_SYNC_SM_LANE12 = new();
  CG_PL_SYNC_SM_LANE13 = new();
  CG_PL_SYNC_SM_LANE14 = new();
  CG_PL_SYNC_SM_LANE15 = new();
  CG_PL_LANE_ALIGN_2X = new();
  CG_PL_LANE_ALIGN_NX = new();
  CG_PL_MODE_DETECT_SM = new();
  CG_PL_1X_2X_NX_INIT_SM = new();
  CG_PL_INPUT_PORT_RETRY_STATE = new();
  CG_PL_OUTPUT_PORT_RETRY_STATE = new();
  CG_PL_INPUT_PORT_ERROR_STATE = new();
  CG_PL_OUTPUT_PORT_ERROR_STATE = new();
  CG_PL_TX_SEQ = new();
  CG_GEN3_PL_LANE_SYNC_SM0  = new();
  CG_GEN3_PL_LANE_SYNC_SM1  = new();
  CG_GEN3_PL_LANE_SYNC_SM2  = new();
  CG_GEN3_PL_LANE_SYNC_SM3  = new();
  CG_GEN3_PL_LANE_SYNC_SM4  = new();
  CG_GEN3_PL_LANE_SYNC_SM5  = new();
  CG_GEN3_PL_LANE_SYNC_SM6  = new();
  CG_GEN3_PL_LANE_SYNC_SM7  = new();
  CG_GEN3_PL_LANE_SYNC_SM8  = new();
  CG_GEN3_PL_LANE_SYNC_SM9  = new();
  CG_GEN3_PL_LANE_SYNC_SM10 = new();
  CG_GEN3_PL_LANE_SYNC_SM11 = new();
  CG_GEN3_PL_LANE_SYNC_SM12 = new();
  CG_GEN3_PL_LANE_SYNC_SM13 = new();
  CG_GEN3_PL_LANE_SYNC_SM14 = new();
  CG_GEN3_PL_LANE_SYNC_SM15 = new();
  CG_GEN3_PL_2X_LANE_ALIGN_SM = new();
  CG_GEN3_PL_NX_LANE_ALIGN_SM = new();
  CG_GEN3_PL_1X_2X_NX_PORT_INIT_SM = new();
  CG_GEN3_PL_CW_LOCK_SM0  = new();
  CG_GEN3_PL_CW_LOCK_SM1  = new();
  CG_GEN3_PL_CW_LOCK_SM2  = new();
  CG_GEN3_PL_CW_LOCK_SM3  = new();
  CG_GEN3_PL_CW_LOCK_SM4  = new();
  CG_GEN3_PL_CW_LOCK_SM5  = new();
  CG_GEN3_PL_CW_LOCK_SM6  = new();
  CG_GEN3_PL_CW_LOCK_SM7  = new();
  CG_GEN3_PL_CW_LOCK_SM8  = new();
  CG_GEN3_PL_CW_LOCK_SM9  = new();
  CG_GEN3_PL_CW_LOCK_SM10 = new();
  CG_GEN3_PL_CW_LOCK_SM11 = new();
  CG_GEN3_PL_CW_LOCK_SM12 = new();
  CG_GEN3_PL_CW_LOCK_SM13 = new();
  CG_GEN3_PL_CW_LOCK_SM14 = new();
  CG_GEN3_PL_CW_LOCK_SM15 = new();
  CG_GEN3_PL_LONG_RUN_LINK_TRAIN_SM0  = new();
  CG_GEN3_PL_LONG_RUN_LINK_TRAIN_SM1  = new();
  CG_GEN3_PL_LONG_RUN_LINK_TRAIN_SM2  = new();
  CG_GEN3_PL_LONG_RUN_LINK_TRAIN_SM3  = new();
  CG_GEN3_PL_LONG_RUN_LINK_TRAIN_SM4  = new();
  CG_GEN3_PL_LONG_RUN_LINK_TRAIN_SM5  = new();
  CG_GEN3_PL_LONG_RUN_LINK_TRAIN_SM6  = new();
  CG_GEN3_PL_LONG_RUN_LINK_TRAIN_SM7  = new();
  CG_GEN3_PL_LONG_RUN_LINK_TRAIN_SM8  = new();
  CG_GEN3_PL_LONG_RUN_LINK_TRAIN_SM9  = new();
  CG_GEN3_PL_LONG_RUN_LINK_TRAIN_SM10 = new();
  CG_GEN3_PL_LONG_RUN_LINK_TRAIN_SM11 = new();
  CG_GEN3_PL_LONG_RUN_LINK_TRAIN_SM12 = new();
  CG_GEN3_PL_LONG_RUN_LINK_TRAIN_SM13 = new();
  CG_GEN3_PL_LONG_RUN_LINK_TRAIN_SM14 = new();
  CG_GEN3_PL_LONG_RUN_LINK_TRAIN_SM15 = new();
  CG_GEN3_PL_SHORT_RUN_LINK_TRAIN_SM0  = new();
  CG_GEN3_PL_SHORT_RUN_LINK_TRAIN_SM1  = new();
  CG_GEN3_PL_SHORT_RUN_LINK_TRAIN_SM2  = new();
  CG_GEN3_PL_SHORT_RUN_LINK_TRAIN_SM3  = new();
  CG_GEN3_PL_SHORT_RUN_LINK_TRAIN_SM4  = new();
  CG_GEN3_PL_SHORT_RUN_LINK_TRAIN_SM5  = new();
  CG_GEN3_PL_SHORT_RUN_LINK_TRAIN_SM6  = new();
  CG_GEN3_PL_SHORT_RUN_LINK_TRAIN_SM7  = new();
  CG_GEN3_PL_SHORT_RUN_LINK_TRAIN_SM8  = new();
  CG_GEN3_PL_SHORT_RUN_LINK_TRAIN_SM9  = new();
  CG_GEN3_PL_SHORT_RUN_LINK_TRAIN_SM10 = new();
  CG_GEN3_PL_SHORT_RUN_LINK_TRAIN_SM11 = new();
  CG_GEN3_PL_SHORT_RUN_LINK_TRAIN_SM12 = new();
  CG_GEN3_PL_SHORT_RUN_LINK_TRAIN_SM13 = new();
  CG_GEN3_PL_SHORT_RUN_LINK_TRAIN_SM14 = new();
  CG_GEN3_PL_SHORT_RUN_LINK_TRAIN_SM15 = new();
  CG_GEN3_PL_RETRAIN_TRANSMIT_WIDTH_CTRL_SM = new();
  CG_GEN3_PL_TRANSMIT_WIDTH_CMD_SM = new();
  CG_GEN3_PL_TRANSMIT_WIDTH_SM = new();
  CG_GEN3_PL_RECEIVE_WIDTH_CMD_SM = new();
  CG_GEN3_PL_RECEIVE_WIDTH_SM = new();
  CG_GEN3_PL_FRAME_LOCK_SM0 = new();
  CG_GEN3_PL_FRAME_LOCK_SM1 = new();
  CG_GEN3_PL_FRAME_LOCK_SM2 = new();
  CG_GEN3_PL_FRAME_LOCK_SM3 = new();
  CG_GEN3_PL_FRAME_LOCK_SM4 = new();
  CG_GEN3_PL_FRAME_LOCK_SM5 = new();
  CG_GEN3_PL_FRAME_LOCK_SM6 = new();
  CG_GEN3_PL_FRAME_LOCK_SM7 = new();
  CG_GEN3_PL_FRAME_LOCK_SM8 = new();
  CG_GEN3_PL_FRAME_LOCK_SM9 = new();
  CG_GEN3_PL_FRAME_LOCK_SM10 = new();
  CG_GEN3_PL_FRAME_LOCK_SM11 = new();
  CG_GEN3_PL_FRAME_LOCK_SM12 = new();
  CG_GEN3_PL_FRAME_LOCK_SM13= new();
  CG_GEN3_PL_FRAME_LOCK_SM14 = new();
  CG_GEN3_PL_FRAME_LOCK_SM15 = new();
  CG_GEN3_PL_C0_COEFF_UPDATE_SM0 = new();
  CG_GEN3_PL_C0_COEFF_UPDATE_SM1 = new();
  CG_GEN3_PL_C0_COEFF_UPDATE_SM2 = new();
  CG_GEN3_PL_C0_COEFF_UPDATE_SM3 = new();
  CG_GEN3_PL_C0_COEFF_UPDATE_SM4 = new();
  CG_GEN3_PL_C0_COEFF_UPDATE_SM5 = new();
  CG_GEN3_PL_C0_COEFF_UPDATE_SM6 = new();
  CG_GEN3_PL_C0_COEFF_UPDATE_SM7 = new();
  CG_GEN3_PL_C0_COEFF_UPDATE_SM8 = new();
  CG_GEN3_PL_C0_COEFF_UPDATE_SM9 = new();
  CG_GEN3_PL_C0_COEFF_UPDATE_SM10 = new();
  CG_GEN3_PL_C0_COEFF_UPDATE_SM11 = new();
  CG_GEN3_PL_C0_COEFF_UPDATE_SM12 = new();
  CG_GEN3_PL_C0_COEFF_UPDATE_SM13 = new();
  CG_GEN3_PL_C0_COEFF_UPDATE_SM14 = new();
  CG_GEN3_PL_C0_COEFF_UPDATE_SM15 = new();
  CG_GEN3_PL_CP1_COEFF_UPDATE_SM0 = new();
  CG_GEN3_PL_CP1_COEFF_UPDATE_SM1 = new();
  CG_GEN3_PL_CP1_COEFF_UPDATE_SM2 = new();
  CG_GEN3_PL_CP1_COEFF_UPDATE_SM3 = new();
  CG_GEN3_PL_CP1_COEFF_UPDATE_SM4 = new();
  CG_GEN3_PL_CP1_COEFF_UPDATE_SM5 = new();
  CG_GEN3_PL_CP1_COEFF_UPDATE_SM6 = new();
  CG_GEN3_PL_CP1_COEFF_UPDATE_SM7 = new();
  CG_GEN3_PL_CP1_COEFF_UPDATE_SM8 = new();
  CG_GEN3_PL_CP1_COEFF_UPDATE_SM9 = new();
  CG_GEN3_PL_CP1_COEFF_UPDATE_SM10 = new();
  CG_GEN3_PL_CP1_COEFF_UPDATE_SM11 = new();
  CG_GEN3_PL_CP1_COEFF_UPDATE_SM12 = new();
  CG_GEN3_PL_CP1_COEFF_UPDATE_SM13 = new();
  CG_GEN3_PL_CP1_COEFF_UPDATE_SM14 = new();
  CG_GEN3_PL_CP1_COEFF_UPDATE_SM15 = new();
  CG_GEN3_PL_CN1_COEFF_UPDATE_SM0 = new();
  CG_GEN3_PL_CN1_COEFF_UPDATE_SM1 = new();
  CG_GEN3_PL_CN1_COEFF_UPDATE_SM2 = new();
  CG_GEN3_PL_CN1_COEFF_UPDATE_SM3 = new();
  CG_GEN3_PL_CN1_COEFF_UPDATE_SM4 = new();
  CG_GEN3_PL_CN1_COEFF_UPDATE_SM5 = new();
  CG_GEN3_PL_CN1_COEFF_UPDATE_SM6 = new();
  CG_GEN3_PL_CN1_COEFF_UPDATE_SM7 = new();
  CG_GEN3_PL_CN1_COEFF_UPDATE_SM8 = new();
  CG_GEN3_PL_CN1_COEFF_UPDATE_SM9 = new();
  CG_GEN3_PL_CN1_COEFF_UPDATE_SM10 = new();
  CG_GEN3_PL_CN1_COEFF_UPDATE_SM11 = new();
  CG_GEN3_PL_CN1_COEFF_UPDATE_SM12 = new();
  CG_GEN3_PL_CN1_COEFF_UPDATE_SM13 = new();
  CG_GEN3_PL_CN1_COEFF_UPDATE_SM14 = new();
  CG_GEN3_PL_CN1_COEFF_UPDATE_SM15 = new();
endfunction

function void srio_pl_func_coverage::build_phase(uvm_phase phase);
    tx_trans_collector = srio_pl_tx_trans_collector::type_id::create("tx_trans_collector", this);
    rx_trans_collector = srio_pl_rx_trans_collector::type_id::create("rx_trans_collector", this);
    if(!uvm_config_db #(srio_env_config)::get(this, "", "srio_env_config", env_config))
      `uvm_fatal("CONFIG FATAL", "Can't get the env_config")
    if(!uvm_config_db #(virtual srio_interface)::get(this, "", "SRIO_VIF", srio_if))
      `uvm_fatal("CONFIG FATAL", "Can't get the SRIO_VIF")

endfunction : build_phase

task srio_pl_func_coverage::run_phase(uvm_phase phase);

  fork
  begin //{
    forever
    begin //{
      @(srio_if.sim_clk);
      this.sim_clk = srio_if.sim_clk; ///< sample sim_clk
    end //}
  end //}
  begin //{
    forever
    begin //{
      @(pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].divide_clk);
      this.divide_clk = pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].divide_clk; ///< sample divide clk
    end //}
  end //}
  begin //{
    forever
    begin //{
      @(pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].dme_frame_divide_clk);
      this.dme_frame_divide_clk = pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].dme_frame_divide_clk; ///< sample dme_frame_divide_clk
    end //}
  end //}
  join_none

  fork // {
    begin : tx_collector // {
      while(1)
      begin //{
        /// wait for the event trigger from srio_pl_tx_trans_collector
        //@(tx_trans_collector.tx_trans_received);
        wait(tx_trans_collector.tx_trans.size() > 0);
        this.tx_trans = new tx_trans_collector.tx_trans.pop_front();
        tx_payload_length = tx_trans.payload.size();
        /// control symbol decoding logic
        if(tx_trans.cs_kind == SRIO_DELIM_PD && tx_trans.transaction_kind==SRIO_CS)
        begin //{
          if(tx_trans.stype1==3'b000 && tx_trans.cmd==3'b000)
            tx_pl_symbol = PD_SOP;
          if(tx_trans.stype1==3'b001 && tx_trans.cmd==3'b000)
            tx_pl_symbol = PD_STOMP;
          else if(tx_trans.stype1==3'b010 && tx_trans.cmd==3'b000)
            tx_pl_symbol = PD_EOP;
          else if(tx_trans.stype1==3'b011 && tx_trans.cmd==3'b000)
            tx_pl_symbol = RESTART_RETRY;
          else if(tx_trans.stype1==3'b100 && tx_trans.cmd==3'b010)
            tx_pl_symbol = LINK_REQ_RESET_PORT;
          else if(tx_trans.stype1==3'b100 && tx_trans.cmd==3'b011)
            tx_pl_symbol = LINK_REQ_RESET_DEV;
          else if(tx_trans.stype1==3'b100 && tx_trans.cmd==3'b100)
            tx_pl_symbol = LINK_REQ_INP_STAT;
        end //}
        if(tx_trans.cs_kind == SRIO_DELIM_SC && tx_trans.transaction_kind==SRIO_CS)
        begin //{
          if(tx_trans.stype0==3'b100)
            tx_pl_symbol = STAT_CS;
          else
            tx_pl_symbol = NON_STAT_CS;
          if(tx_trans.stype1==3'b011 && tx_trans.cmd==3'b000)
            tx_pl_symbol = RESTART_RETRY;
          else if(tx_trans.stype1==3'b100 && tx_trans.cmd==3'b010)
            tx_pl_symbol = LINK_REQ_RESET_PORT;
          else if(tx_trans.stype1==3'b100 && tx_trans.cmd==3'b011)
            tx_pl_symbol = LINK_REQ_RESET_DEV;
          else if(tx_trans.stype1==3'b100 && tx_trans.cmd==3'b100)
            tx_pl_symbol = LINK_REQ_INP_STAT; 
        end //}
        if(tx_trans.transaction_kind == SRIO_PACKET)
        begin //{
            tx_pl_symbol = SRIO_PKT;
        end //}
        if(env_config.srio_mode != SRIO_GEN30)
        begin //{
          if(env_config.idle_detected==1 && env_config.idle_selected==0)
          begin //{
            tx_idle1_detected = 1;
            if(pl_agent.pl_config.idle_sel)
            begin //{
              tx_idle2_detected = 1;
              idle2_idle1_detected = 1;
            end //}
            else
            begin //{
              tx_idle2_detected = 0;
              idle2_idle1_detected = 0;
            end //}
          end //}
          else if(env_config.idle_detected==1 && env_config.idle_selected==1)
          begin //{
            tx_idle1_detected = 0;
            tx_idle2_detected = 1;
          end //}
          else
          begin //{
            tx_idle1_detected = 0;
            tx_idle2_detected = 0;
          end //}
        end //}
        else //SRIO_GEN30
        begin //{
          tx_idle3_detected = 1;
          rx_idle3_detected = 1;
        end //}
        vc_num_support = env_config.srio_reg_model_rx.Port_0_VC_Control_and_Status_Register.VCs_Support.get();
        ct_mode = env_config.srio_reg_model_rx.Port_0_VC_Control_and_Status_Register.CT_Mode.get();
        if(vc_num_support==0 || ct_mode==0)
        begin //{
          serial_traffic_mode = RT_MODE;
        end //}
        else
        begin //{
          serial_traffic_mode = CT_MODE;
        end //}
        if(packet_open) ///< contains embedded control symbols
        begin //{
          if(tx_trans.cs_kind == SRIO_DELIM_SC)
          begin //{
            embedded_cs = 1;
          end //}
        end //}
        else
        begin //{
          embedded_cs = 0;
        end //}
        if(pl_agent.pl_config.timestamp_sync_support)
        begin //{
          timestamp_support = 1;
          if(pl_agent.pl_config.timestamp_master_slave_support)
            timestamp_master_support = 1;
          else
            timestamp_slave_support = 1;
        end //}
        else
        begin //{
          timestamp_support = 0;
          timestamp_master_support = 0;
          timestamp_slave_support = 0;
        end //}

        -> tx_trans_event;
      end //}
    end // } tx_collector 

    begin : rx_collector // {
      while(1)
      begin //{
        /// wait for the event trigger from srio_pl_rx_trans_collector
        wait(rx_trans_collector.rx_trans.size() > 0);
        this.rx_trans = new rx_trans_collector.rx_trans.pop_front();
        rx_payload_length = rx_trans.payload.size();
        if(env_config.idle_detected==1 && env_config.idle_selected==0)
        begin //{
          rx_idle1_detected = 1;
          rx_idle2_detected = 0;
        end //}
        else if(env_config.idle_detected==1 && env_config.idle_selected==1)
        begin //{
          rx_idle1_detected = 0;
          rx_idle2_detected = 1;
        end //}
        else
        begin //{
          rx_idle1_detected = 0;
          rx_idle2_detected = 0;
        end //}
        -> rx_trans_event;
      end //} //while(1)
    end // } rx_collector

    begin //{
      while(1)
      begin //{
        @(posedge sim_clk);
        asymmode =  pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.asym_mode;
        xmt_width_port_req_cmd = pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_common_mon_trans.xmt_width_req_cmd[1];
        //xmt_width_port_req_cmd = pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.xmt_width_req_cmd;
        CG_GEN3_PL_ASYMMETRY.sample();      
      end //}
    end // } 

    `SAMPLE_TX_LANE_DETAILS(0) 
    `SAMPLE_TX_LANE_DETAILS(1) 
    `SAMPLE_TX_LANE_DETAILS(2) 
    `SAMPLE_TX_LANE_DETAILS(3) 
    `SAMPLE_TX_LANE_DETAILS(4) 
    `SAMPLE_TX_LANE_DETAILS(5) 
    `SAMPLE_TX_LANE_DETAILS(6) 
    `SAMPLE_TX_LANE_DETAILS(7) 
    `SAMPLE_TX_LANE_DETAILS(8) 
    `SAMPLE_TX_LANE_DETAILS(9) 
    `SAMPLE_TX_LANE_DETAILS(10)
    `SAMPLE_TX_LANE_DETAILS(11)
    `SAMPLE_TX_LANE_DETAILS(12)
    `SAMPLE_TX_LANE_DETAILS(13)
    `SAMPLE_TX_LANE_DETAILS(14)
    `SAMPLE_TX_LANE_DETAILS(15)

    `SAMPLE_RX_LANE_DETAILS(0)
    `SAMPLE_RX_LANE_DETAILS(1)
    `SAMPLE_RX_LANE_DETAILS(2)
    `SAMPLE_RX_LANE_DETAILS(3)
    `SAMPLE_RX_LANE_DETAILS(4)
    `SAMPLE_RX_LANE_DETAILS(5)
    `SAMPLE_RX_LANE_DETAILS(6)
    `SAMPLE_RX_LANE_DETAILS(7)
    `SAMPLE_RX_LANE_DETAILS(8)
    `SAMPLE_RX_LANE_DETAILS(9)
    `SAMPLE_RX_LANE_DETAILS(10)
    `SAMPLE_RX_LANE_DETAILS(11)
    `SAMPLE_RX_LANE_DETAILS(12)
    `SAMPLE_RX_LANE_DETAILS(13)
    `SAMPLE_RX_LANE_DETAILS(14)
    `SAMPLE_RX_LANE_DETAILS(15)

  join_none // }

  this.number_of_lanes = env_config.num_of_lanes;
  this.srio_baud_rate  = env_config.srio_baud_rate;
  CG_PL.sample();

  update_state_machine();
 
endtask : run_phase

task srio_pl_func_coverage::update_state_machine(); // {
  fork // {

    begin //{
      while(1)
      begin //{
        @(pl_agent.pl_monitor.tx_monitor.pl_link_mon_trans.idle_seq_in_pkt_err);
        tx_idle_seq_in_pkt=1; ///< idle sequence present in packet (Error)
        @(posedge sim_clk);
        tx_idle_seq_in_pkt=0;
      end //}
    end //}
    begin //{
      while(1)
      begin //{
        @(pl_agent.pl_monitor.tx_monitor.pl_link_mon_trans.idle_seq_in_scs);
        tx_idle_seq_in_scs=1; ///< idle sequence present in short control symbol (Error)
        @(posedge sim_clk);
        tx_idle_seq_in_scs=0;
      end //}
    end //}
    begin //{
      while(1)
      begin //{
        @(pl_agent.pl_monitor.tx_monitor.pl_link_mon_trans.idle_seq_in_lcs);
        tx_idle_seq_in_lcs=1; ///< idle sequence present in long control symbol (Error)
        @(posedge sim_clk);
        tx_idle_seq_in_lcs=0;
      end //}
    end //}
    begin //{
      while(1)
      begin //{
        @(pl_agent.pl_monitor.tx_monitor.pl_link_mon_trans.idle2_corrupt_seq);
        tx_idle2_seq_corrupted=1; ///< idle2 sequence corrupted(Error)
        @(posedge sim_clk);
        tx_idle2_seq_corrupted=0;
      end //}
    end //}
    begin //{
      while(1)
      begin //{
        @(pl_agent.pl_monitor.tx_monitor.pl_link_mon_trans.idle2_cs_field_marker_corrupt);
        tx_idle2_cs_field_marker_corrupt=1; ///< idle2 cs field marker is corrupted (Error)
        @(posedge sim_clk);
        tx_idle2_cs_field_marker_corrupt=0;
      end //}
    end //}
    begin //{
      while(1)
      begin //{
        @(pl_agent.pl_monitor.tx_monitor.pl_link_mon_trans.idle2_cs_field_corrupt);
        tx_idle2_cs_field_corrupt=1; ///< idle2 cs field marker corrupted (Error)
        @(posedge sim_clk);
        tx_idle2_cs_field_corrupt=0;
      end //}
    end //}
    begin //{
      while(1)
      begin //{
        @(pl_agent.pl_monitor.tx_monitor.pl_link_mon_trans.status_cs_blocked);
        tx_status_cs_blocked=1; ///< status control symbol blocked (Error)
        @(posedge sim_clk);
        tx_status_cs_blocked=0;
      end //}
    end //}
    begin //{
      while(1)
      begin //{
        @(pl_agent.pl_monitor.tx_monitor.pl_link_mon_trans.idle1_corrupt_seq);
        tx_idle1_seq_corrupted=1; ///< idle1 sequence corrupted (Error)
        @(posedge sim_clk);
        tx_idle1_seq_corrupted=0;
      end //}
    end //}
    begin //{
      while(1)
      begin //{
        @(pl_agent.pl_monitor.tx_monitor.pl_link_mon_trans.invalid_packet_acc_cs);
        tx_invalid_pkt_acc_cs=1; ///< invalid packet accepted control symbol (Error)
        @(posedge sim_clk);
        tx_invalid_pkt_acc_cs=0;
      end //}
    end //}
    begin //{
      while(1)
      begin //{
        @(pl_agent.pl_monitor.tx_monitor.pl_link_mon_trans.invalid_packet_na_cs);
        tx_invalid_pkt_na_cs=1; ///< invalid packet not accepted control symbol (Error)
        @(posedge sim_clk);
        tx_invalid_pkt_na_cs=0;
      end //}
    end //}
    begin //{
      while(1)
      begin //{
        @(pl_agent.pl_monitor.tx_monitor.pl_link_mon_trans.packet_ackID_corrupt);
        tx_pkt_ackID_corrupt=1; ///< packet ack ID corrupted (Error)
        @(posedge sim_clk);
        tx_pkt_ackID_corrupt=0;
      end //}
    end //}
    begin //{
      while(1)
      begin //{
        @(pl_agent.pl_monitor.tx_monitor.pl_link_mon_trans.lcs_without_end_delimiter);
        tx_lcs_without_end_delimiter=1; ///< long control symbold without end delimiter (Error)
        @(posedge sim_clk);
        tx_lcs_without_end_delimiter=0;
      end //}
    end //}
    begin //{
      while(1)
      begin //{
        @(pl_agent.pl_monitor.tx_monitor.pl_link_mon_trans.invalid_ackID);
        tx_invalid_ackID = 1; ///< invalid ackID (Error)
        @(posedge sim_clk);
        tx_invalid_ackID = 0;
      end //}
    end //}
    begin //{
      while(1)
      begin //{
        @(pl_agent.pl_monitor.tx_monitor.pl_link_mon_trans.idle_seq_not_aligned);
        if(pl_agent.pl_monitor.tx_monitor.srio_pl_rx_data_handle_ins.lane0_idle_char == 8'hBC) ///< SRIO_K
          tx_clk_comp_seq_unaligned = 1;
        else
          tx_idle2_seq_unaligned = 1;
        @(posedge sim_clk);
        tx_clk_comp_seq_unaligned = 0;
        tx_idle2_seq_unaligned = 0;
      end //}
    end //}
    /// GEN3 SM
    begin //{
      while(1)
      begin //{
        @(posedge divide_clk);
        /// State Machine Variables
        `lane_sync(0);
        `lane_sync(1);
        `lane_sync(2);
        `lane_sync(3);
        `lane_sync(4);
        `lane_sync(5);
        `lane_sync(6);
        `lane_sync(7);
        `lane_sync(8);
        `lane_sync(9);
        `lane_sync(10);
        `lane_sync(11);
        `lane_sync(12);
        `lane_sync(13);
        `lane_sync(14);
        `lane_sync(15);

        // FRAME_LOCK State Machine

        `frame_lock_sm(0);
        `frame_lock_sm(1);
        `frame_lock_sm(2);
        `frame_lock_sm(3);
        `frame_lock_sm(4);
        `frame_lock_sm(5);
        `frame_lock_sm(6);
        `frame_lock_sm(7);
        `frame_lock_sm(8);
        `frame_lock_sm(9);
        `frame_lock_sm(10);
        `frame_lock_sm(11);
        `frame_lock_sm(12);
        `frame_lock_sm(12);
        `frame_lock_sm(13);
        `frame_lock_sm(14);
        `frame_lock_sm(15);


        `i_counter(0);
        `i_counter(1);
        `i_counter(2);
        `i_counter(3);
        `i_counter(4);
        `i_counter(5);
        `i_counter(6);
        `i_counter(7);
        `i_counter(8);
        `i_counter(9);
        `i_counter(10);
        `i_counter(11);
        `i_counter(12);
        `i_counter(13);
        `i_counter(14);
        `i_counter(15);

        `k_counter(0);
        `k_counter(1);
        `k_counter(2);
        `k_counter(3);
        `k_counter(4);
        `k_counter(5);
        `k_counter(6);
        `k_counter(7);
        `k_counter(8);
        `k_counter(9);
        `k_counter(10);
        `k_counter(11);
        `k_counter(12);
        `k_counter(13);
        `k_counter(14);
        `k_counter(15);

        `v_counter(0);
        `v_counter(1);
        `v_counter(2);
        `v_counter(3);
        `v_counter(4);
        `v_counter(5);
        `v_counter(6);
        `v_counter(7);
        `v_counter(8);
        `v_counter(9);
        `v_counter(10);
        `v_counter(11);
        `v_counter(12);
        `v_counter(13);
        `v_counter(14);
        `v_counter(15);
       
        CG_PL_SM_VARIABLE.sample();
      if(env_config.srio_mode != SRIO_GEN30) begin //{
        /// GEN1/GEN2 state machine monitor
        `sync_sm_state_mon(0);
        `sync_sm_state_mon(1);
        `sync_sm_state_mon(2);
        `sync_sm_state_mon(3);
        `sync_sm_state_mon(4);
        `sync_sm_state_mon(5);
        `sync_sm_state_mon(6);
        `sync_sm_state_mon(7);
        `sync_sm_state_mon(8);
        `sync_sm_state_mon(9);
        `sync_sm_state_mon(10);
        `sync_sm_state_mon(11);
        `sync_sm_state_mon(12);
        `sync_sm_state_mon(13);
        `sync_sm_state_mon(14);
        `sync_sm_state_mon(15);
       end //}
    /// GEN3 state machine monitor
        `gen3_sync_sm_state_mon(0);
        `gen3_sync_sm_state_mon(1);
        `gen3_sync_sm_state_mon(2);
        `gen3_sync_sm_state_mon(3);
        `gen3_sync_sm_state_mon(4);
        `gen3_sync_sm_state_mon(5);
        `gen3_sync_sm_state_mon(6);
        `gen3_sync_sm_state_mon(7);
        `gen3_sync_sm_state_mon(8);
        `gen3_sync_sm_state_mon(9);
        `gen3_sync_sm_state_mon(10);
        `gen3_sync_sm_state_mon(11);
        `gen3_sync_sm_state_mon(12);
        `gen3_sync_sm_state_mon(13);
        `gen3_sync_sm_state_mon(14);
        `gen3_sync_sm_state_mon(15);

        `cw_lock_lane(0);
        `cw_lock_lane(1);
        `cw_lock_lane(2);
        `cw_lock_lane(3);
        `cw_lock_lane(4);
        `cw_lock_lane(5);
        `cw_lock_lane(6);
        `cw_lock_lane(7);
        `cw_lock_lane(8);
        `cw_lock_lane(9);
        `cw_lock_lane(10);
        `cw_lock_lane(11);
        `cw_lock_lane(12);
        `cw_lock_lane(13);
        `cw_lock_lane(14);
        `cw_lock_lane(15);

        `cw_lock_sm_mon(0);
        `cw_lock_sm_mon(1);
        `cw_lock_sm_mon(2);
        `cw_lock_sm_mon(3);
        `cw_lock_sm_mon(4);
        `cw_lock_sm_mon(5);
        `cw_lock_sm_mon(6);
        `cw_lock_sm_mon(7);
        `cw_lock_sm_mon(8);
        `cw_lock_sm_mon(9);
        `cw_lock_sm_mon(10);
        `cw_lock_sm_mon(11);
        `cw_lock_sm_mon(12);
        `cw_lock_sm_mon(13);
        `cw_lock_sm_mon(14);
        `cw_lock_sm_mon(15);

        `short_run_link_train_sm_mon(0);
        `short_run_link_train_sm_mon(1);
        `short_run_link_train_sm_mon(2);
        `short_run_link_train_sm_mon(3);
        `short_run_link_train_sm_mon(4);
        `short_run_link_train_sm_mon(5);
        `short_run_link_train_sm_mon(6);
        `short_run_link_train_sm_mon(7);
        `short_run_link_train_sm_mon(8);
        `short_run_link_train_sm_mon(9);
        `short_run_link_train_sm_mon(10);
        `short_run_link_train_sm_mon(11);
        `short_run_link_train_sm_mon(12);
        `short_run_link_train_sm_mon(13);
        `short_run_link_train_sm_mon(14);
        `short_run_link_train_sm_mon(15);
      end //}
    end //}
    begin //{
      while(1)
      begin //{
        @(posedge dme_frame_divide_clk);
        `long_run_link_train_sm_mon(0);
        `long_run_link_train_sm_mon(1);
        `long_run_link_train_sm_mon(2);
        `long_run_link_train_sm_mon(3);
        `long_run_link_train_sm_mon(4);
        `long_run_link_train_sm_mon(5);
        `long_run_link_train_sm_mon(6);
        `long_run_link_train_sm_mon(7);
        `long_run_link_train_sm_mon(8);
        `long_run_link_train_sm_mon(9);
        `long_run_link_train_sm_mon(10);
        `long_run_link_train_sm_mon(11);
        `long_run_link_train_sm_mon(12);
        `long_run_link_train_sm_mon(13);
        `long_run_link_train_sm_mon(14);
        `long_run_link_train_sm_mon(15);


        `c0_coeff_update_sm(0);
        `c0_coeff_update_sm(1);
        `c0_coeff_update_sm(2);
        `c0_coeff_update_sm(3);
        `c0_coeff_update_sm(4);
        `c0_coeff_update_sm(5);
        `c0_coeff_update_sm(6);
        `c0_coeff_update_sm(7);
        `c0_coeff_update_sm(8);
        `c0_coeff_update_sm(9);
        `c0_coeff_update_sm(10);
        `c0_coeff_update_sm(11);
        `c0_coeff_update_sm(12);
        `c0_coeff_update_sm(13);
        `c0_coeff_update_sm(14);
        `c0_coeff_update_sm(15);

        `cp1_coeff_update_sm(0);
        `cp1_coeff_update_sm(1);
        `cp1_coeff_update_sm(2);
        `cp1_coeff_update_sm(3);
        `cp1_coeff_update_sm(4);
        `cp1_coeff_update_sm(5);
        `cp1_coeff_update_sm(6);
        `cp1_coeff_update_sm(7);
        `cp1_coeff_update_sm(8);
        `cp1_coeff_update_sm(9);
        `cp1_coeff_update_sm(10);
        `cp1_coeff_update_sm(11);
        `cp1_coeff_update_sm(12);
        `cp1_coeff_update_sm(13);
        `cp1_coeff_update_sm(14);
        `cp1_coeff_update_sm(15);
          
        `cn1_coeff_update_sm(0);
        `cn1_coeff_update_sm(1);
        `cn1_coeff_update_sm(2);
        `cn1_coeff_update_sm(3);
        `cn1_coeff_update_sm(4);
        `cn1_coeff_update_sm(5);
        `cn1_coeff_update_sm(6);
        `cn1_coeff_update_sm(7);
        `cn1_coeff_update_sm(8);
        `cn1_coeff_update_sm(9);
        `cn1_coeff_update_sm(10);
        `cn1_coeff_update_sm(11);
        `cn1_coeff_update_sm(12);
        `cn1_coeff_update_sm(13);
        `cn1_coeff_update_sm(14);
        `cn1_coeff_update_sm(15);
      end //}
    end //}
    begin //{
      while(1)
      begin //{
        @(pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.force_reinit_set)
        force_reinit = 1;
        CG_PL_SM_VARIABLE.sample();
        if(env_config.srio_mode != SRIO_GEN30) begin //{
          CG_PL_1X_2X_NX_INIT_SM.sample();
        end //}
        else begin //{
          CG_GEN3_PL_1X_2X_NX_PORT_INIT_SM.sample();
        end //}
        force_reinit = 0;
      end //}
    end //}
    begin //{
      while(1)
      begin //{
        @(posedge sim_clk);
        /// variables
        two_lanes_aligned = pl_agent.pl_monitor.rx_monitor.pl_link_mon_trans.two_lanes_aligned;
        /// state machine variables
        x1_mode_delimiter =  pl_agent.pl_monitor.rx_monitor.pl_link_mon_trans.x1_mode_delimiter;
        x2_mode_delimiter =  pl_agent.pl_monitor.rx_monitor.pl_link_mon_trans.x2_mode_delimiter;
        x1_mode_detected =  pl_agent.pl_monitor.rx_monitor.pl_link_mon_trans.x1_mode_detected;
        x2_a_col_detected = pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.x2_a_col_detected;
        nx_a_col_detected = pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.nx_a_col_detected;
        x2_a_counter = pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.x2_align_A_counter;
        nx_a_counter = pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.nx_align_A_counter;
        x2_MA_counter = pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.x2_align_MA_counter;
        nx_MA_counter = pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.nx_align_MA_counter;
        x2_align_err = pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.x2_align_err;
        nx_align_err = pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.nx_align_err;
        D_counter = pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.D_counter;
        disc_timer_done = pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.disc_timer_done;
        disc_timer_start = pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.disc_timer_start;
        disc_timer_en = pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.disc_timer_start;
        force_1x_mode =  pl_agent.pl_monitor.rx_monitor.pl_link_mon_trans.force_1x_mode;
        force_laneR =  pl_agent.pl_monitor.rx_monitor.pl_link_mon_trans.force_laneR;
        idle_selection_done = pl_agent.pl_monitor.pl_mon_common_trans.idle_selection_done[1];
        packet_open = pl_agent.pl_monitor.rx_monitor.srio_pl_rx_data_handle_ins.packet_open;

        `lane_ready(0);
        `lane_ready(1);
        `lane_ready(2);
        `lane_ready(3);
        `lane_ready(4);
        `lane_ready(5);
        `lane_ready(6);
        `lane_ready(7);
        `lane_ready(8);
        `lane_ready(9);
        `lane_ready(10);
        `lane_ready(11);
        `lane_ready(12);
        `lane_ready(13);
        `lane_ready(14);
        `lane_ready(15);
       
 
        lanes01_drvr_oe =  pl_agent.pl_monitor.rx_monitor.pl_link_mon_trans.lanes01_drvr_oe;
        lanes02_drvr_oe =  pl_agent.pl_monitor.rx_monitor.pl_link_mon_trans.lanes02_drvr_oe;
        lanes13_drvr_oe =  pl_agent.pl_monitor.rx_monitor.pl_link_mon_trans.lanes13_drvr_oe;
        N_lanes_aligned =  pl_agent.pl_monitor.rx_monitor.pl_link_mon_trans.N_lanes_aligned;
        N_lanes_drvr_oe =  pl_agent.pl_monitor.rx_monitor.pl_link_mon_trans.N_lanes_drvr_oe;
        N_lanes_ready =  pl_agent.pl_monitor.rx_monitor.pl_link_mon_trans.N_lanes_ready;
        port_initialized =  pl_agent.pl_monitor.rx_monitor.pl_link_mon_trans.port_initialized;
        link_initialized = pl_agent.pl_monitor.rx_monitor.pl_link_mon_trans.link_initialized;
        receive_lane1 =  pl_agent.pl_monitor.rx_monitor.pl_link_mon_trans.receive_lane1;
        receive_lane2 =  pl_agent.pl_monitor.rx_monitor.pl_link_mon_trans.receive_lane2;

        `rcvr_trained(0);
        `rcvr_trained(1);
        `rcvr_trained(2);
        `rcvr_trained(3);
        `rcvr_trained(4);
        `rcvr_trained(5);
        `rcvr_trained(6);
        `rcvr_trained(7);
        `rcvr_trained(8);
        `rcvr_trained(9);
        `rcvr_trained(10);
        `rcvr_trained(11);
        `rcvr_trained(12);
        `rcvr_trained(13);
        `rcvr_trained(14);
        `rcvr_trained(15);

        `signal_detect(0);
        `signal_detect(1);
        `signal_detect(2);
        `signal_detect(3);
        `signal_detect(4);
        `signal_detect(5);
        `signal_detect(6);
        `signal_detect(7);
        `signal_detect(8);
        `signal_detect(9);
        `signal_detect(10);
        `signal_detect(11);
        `signal_detect(12);
        `signal_detect(13);
        `signal_detect(14);
        `signal_detect(15);

        silence_timer_done = pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.silence_timer_done;
        silence_timer_en = pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.silence_timer_start;

        tx_sync_seq = pl_agent.pl_monitor.tx_monitor.pl_link_mon_trans.sync_seq_detected;
        rx_sync_seq = pl_agent.pl_monitor.rx_monitor.pl_link_mon_trans.sync_seq_detected;
        CG_PL_SM_VARIABLE.sample();

        /// GEN1/GEN2 SM
       if(env_config.srio_mode != SRIO_GEN30) begin //{
         while(pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_2x_align_state_q.size() != 0)
         begin //{
           lane_2x_align_state = pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_2x_align_state_q.pop_front();
           CG_PL_LANE_ALIGN_2X.sample();
         end //}
         while(pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_nx_align_state_q.size() != 0)
         begin //{
           lane_nx_align_state = pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_nx_align_state_q.pop_front();
           CG_PL_LANE_ALIGN_NX.sample();
         end //}
         while(pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.curr_mode_detect_state_q.size() != 0)
         begin //{
           mode_detect_state = pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.curr_mode_detect_state_q.pop_front();
           CG_PL_MODE_DETECT_SM.sample();
         end //}
       end //}

        while(pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_init_state_q.size() != 0)
        begin //{
          if(pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.current_init_state == SILENT) begin //{
            pism_silent = 1;
          end //}
          else begin //{
            pism_silent = 0;
          end //}
          if(env_config.srio_mode != SRIO_GEN30) begin //{
            init_sm_1x_2x_nx_state = pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_init_state_q.pop_front();
            CG_PL_1X_2X_NX_INIT_SM.sample();
          end //}
          else begin //{
            gen3_init_sm_1x_2x_nx_state = pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_init_state_q.pop_front();
            CG_GEN3_PL_1X_2X_NX_PORT_INIT_SM.sample();
          end //}
        end //}  
        in_port_retry_state = pl_agent.pl_monitor.rx_monitor.pl_link_mon_trans.irs_state;
        out_port_retry_state = pl_agent.pl_monitor.rx_monitor.pl_link_mon_trans.ors_state;
        in_port_error_state = pl_agent.pl_monitor.rx_monitor.pl_link_mon_trans.ies_state;
        out_port_error_state = pl_agent.pl_monitor.rx_monitor.pl_link_mon_trans.oes_state;

        /// GEN3 SM
 
        asym_mode =  pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.pl_sm_trans.asym_mode;

        while(pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_2x_align_state_q.size() != 0)
        begin //{
          gen3_lane_2x_align_state = pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_2x_align_state_q.pop_front();
          CG_GEN3_PL_2X_LANE_ALIGN_SM.sample();
        end //}
        while(pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_nx_align_state_q.size() != 0)
        begin //{
          gen3_lane_nx_align_state = pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_nx_align_state_q.pop_front();
          CG_GEN3_PL_NX_LANE_ALIGN_SM.sample();
        end //}

        while(pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_cw_retrain_state_q.size() != 0)
        begin //{
          retrain_xmt_width_ctrl_state = pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_cw_retrain_state_q.pop_front();
          CG_GEN3_PL_RETRAIN_TRANSMIT_WIDTH_CTRL_SM.sample();
        end //}

        while(pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_xmit_width_cmd_state_q.size() != 0)
        begin //{
          xmt_width_cmd_state = pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_xmit_width_cmd_state_q.pop_front();
          CG_GEN3_PL_TRANSMIT_WIDTH_CMD_SM.sample();
        end //}

        while(pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_xmit_width_state_q.size() != 0)
        begin //{
          xmt_width_state = pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_xmit_width_state_q.pop_front();
          CG_GEN3_PL_TRANSMIT_WIDTH_SM.sample();
        end //}

        while(pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_rcv_width_cmd_state_q.size() != 0) 
        begin //{
          rcv_width_cmd_state = pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_rcv_width_cmd_state_q.pop_front();
          CG_GEN3_PL_RECEIVE_WIDTH_CMD_SM.sample();
        end //}
        while(pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_rcv_width_state_q.size() != 0)
        begin //{
          rcv_width_state = pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_rcv_width_state_q.pop_front();
          CG_GEN3_PL_RECEIVE_WIDTH_SM.sample();
        end //}

      end //}
    end //}
    begin //{
      while(1)
      begin //{
        @(negedge sim_clk);  
        tx_clk_comp_seq = pl_agent.pl_monitor.tx_monitor.srio_pl_rx_data_handle_ins.clk_comp_rcvd;
        rx_clk_comp_seq = pl_agent.pl_monitor.rx_monitor.srio_pl_rx_data_handle_ins.clk_comp_rcvd;
        tx_no_clk_comp_seq = pl_agent.pl_monitor.tx_monitor.srio_pl_rx_data_handle_ins.clk_comp_freq_err;
        tx_idle1_A_char_interval = pl_agent.pl_monitor.tx_monitor.srio_pl_rx_data_handle_ins.idle1_char_cnt;
        tx_idle2_random_data_length = pl_agent.pl_monitor.tx_monitor.srio_pl_rx_data_handle_ins.idle2_psr_char_cnt;
        rx_idle2_random_data_length = pl_agent.pl_monitor.rx_monitor.srio_pl_rx_data_handle_ins.idle2_psr_char_cnt;
        tx_idle2_active_link_width = pl_agent.pl_monitor.tx_monitor.srio_pl_rx_data_handle_ins.idle2_active_link_width;
        rx_idle2_active_link_width = pl_agent.pl_monitor.rx_monitor.srio_pl_rx_data_handle_ins.idle2_active_link_width;
        tx_idle2_lane_num = pl_agent.pl_monitor.tx_monitor.srio_pl_rx_data_handle_ins.idle2_lane_num;   
        rx_idle2_lane_num = pl_agent.pl_monitor.rx_monitor.srio_pl_rx_data_handle_ins.idle2_lane_num;
        tx_idle2_cs_field = pl_agent.pl_monitor.tx_monitor.srio_pl_rx_data_handle_ins.idle2_cs_field_bits;
        rx_idle2_cs_field = pl_agent.pl_monitor.rx_monitor.srio_pl_rx_data_handle_ins.idle2_cs_field_bits;
      end //}
    end //}

    begin //{
      while (1)
      begin // {
        @(pl_agent.pl_monitor.tx_monitor.pl_link_mon_trans.rcvd_seedos_linkreq);
        rcvd_seedos_linkreq = 1;      
        CG_GEN3_PL_TX_SEEDOS_LINKREQ_SEQ.sample(); 
        @(posedge sim_clk);
        rcvd_seedos_linkreq = 0;                            
      end //}
    end //}

    begin //{
      @(pl_agent.pl_monitor.tx_monitor.pl_link_mon_trans.rcvd_uninterrupted_timestamp_cs);
      rcvd_uninterrupted_timestamp_cs = 1;                           
      CG_GEN3_PL_TSG.sample();      
    end //}

    begin //{
      @(pl_agent.pl_monitor.tx_monitor.pl_link_mon_trans.pkt_terminating_8bit_boundary);
      pkt_terminating_8bit_boundary = 1;                           
      CG_GEN3_PL_TERMINATING_PKT_LENGTH1.sample();      
    end //}

    begin //{
      @(pl_agent.pl_monitor.tx_monitor.pl_link_mon_trans.pkt_terminating_non_8bit_boundary);
      pkt_terminating_non_8bit_boundary = 1; 
      CG_GEN3_PL_TERMINATING_PKT_LENGTH2.sample();      
    end //}


    `SAMPLE_TX_INVERTED_BIT(0) 
    `SAMPLE_TX_INVERTED_BIT(1) 
    `SAMPLE_TX_INVERTED_BIT(2) 
    `SAMPLE_TX_INVERTED_BIT(3) 
    `SAMPLE_TX_INVERTED_BIT(4) 
    `SAMPLE_TX_INVERTED_BIT(5) 
    `SAMPLE_TX_INVERTED_BIT(6) 
    `SAMPLE_TX_INVERTED_BIT(7) 
    `SAMPLE_TX_INVERTED_BIT(8) 
    `SAMPLE_TX_INVERTED_BIT(9) 
    `SAMPLE_TX_INVERTED_BIT(10)
    `SAMPLE_TX_INVERTED_BIT(11)
    `SAMPLE_TX_INVERTED_BIT(12)
    `SAMPLE_TX_INVERTED_BIT(13)
    `SAMPLE_TX_INVERTED_BIT(14)
    `SAMPLE_TX_INVERTED_BIT(15)
                           
    `SAMPLE_RX_INVERTED_BIT(0) 
    `SAMPLE_RX_INVERTED_BIT(1) 
    `SAMPLE_RX_INVERTED_BIT(2) 
    `SAMPLE_RX_INVERTED_BIT(3) 
    `SAMPLE_RX_INVERTED_BIT(4) 
    `SAMPLE_RX_INVERTED_BIT(5) 
    `SAMPLE_RX_INVERTED_BIT(6) 
    `SAMPLE_RX_INVERTED_BIT(7) 
    `SAMPLE_RX_INVERTED_BIT(8) 
    `SAMPLE_RX_INVERTED_BIT(9) 
    `SAMPLE_RX_INVERTED_BIT(10)
    `SAMPLE_RX_INVERTED_BIT(11)
    `SAMPLE_RX_INVERTED_BIT(12)
    `SAMPLE_RX_INVERTED_BIT(13)
    `SAMPLE_RX_INVERTED_BIT(14)
    `SAMPLE_RX_INVERTED_BIT(15)

  join_none // }
endtask // }
