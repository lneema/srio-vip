////////////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File       :  srio_pl_common_component_transaction.sv
// Project    :  srio vip
// Purpose    :  Transaction which is used by all the components inside the PL BFM / PL monitor,
// 		 to know the status of the agent.
// Author     :  Mobiveil
//
// Physical layer common transaction class. 
// Separate instance of this class will be available for PL BFM, PL TX monitor and PL RX monitor.
//
//
//////////////////////////////////////////////////////////////////////////////////////////////////

class srio_pl_common_component_trans extends uvm_object;

  /// @cond
  `uvm_object_utils(srio_pl_common_component_trans)
  /// @endcond


  // Properties

  srio_pl_config common_trans_cfg;	///< PL config instance.

  int num_lanes;			///< Number of lanes supported.

  byte unsigned bytestream[];		///< Bytestream array for storing packet bytes.

  bit x1_mode_delimiter;		///< Lanes 0 and 1 contains ||SC|| or ||PD||.
  bit x1_mode_detected;			///< 1x/2x mode detect SM indicates 1x mode is detected.
					///< 1 : 1x mode detected ; 0 : 2x mode detected.

  bit x2_mode_delimiter;		///< Beginning /SC/ or /PD/ present in lane 0.

  bit A_col_received;			///< Column of A received.
  bit align_error;			///< Align error detected. It is set when one or more lanes contain /A/ but no ||A||

  bit force_1x_mode;			///< Set when Nx modes are disabled.
  bit force_laneR;			///< When force_1x_mode is set, this bit indicates whether 1x mode 
					///< has to be operated on lane0 or laneR
  bit force_reinit;			///< Forces the initialization SM to re-initialize.

  bit idle_detected;			///< Indicates IDLE sequence is detected.
  bit idle_selected;			///< 1 : IDLE2 ; 0 : IDLE1

  bit lane_sync [int];			///< set when sync is achieved in that particular lane. 
					///< Bit position indicates lane number.

  bit rcvr_trained [int];		///< set when sync is achieved in that particular lane. 
					///< Bit position indicates lane number.

  bit lane_ready [int];			///< set when sync is achieved in that particular lane. 
					///< Bit position indicates lane number.

  bit lanes01_drvr_oe;			///< output driver enable for lanes 0 and 1.
  bit lanes02_drvr_oe;			///< output driver enable for lanes 0 and 2.
  bit lanes13_drvr_oe;			///< output driver enable for lanes 1 and 3.

  bit N_lanes_aligned;			///< N lanes alignment acheived.
  bit N_lanes_drvr_oe;			///< output drivers enabled for all N lanes.
  bit N_lanes_ready;			///< N lanes ready. Set if all bits of lane_ready is set.
  bit N_lane_sync;			///< N lanes sync acheived.

  bit two_lanes_aligned;		///< 2 lanes (lane0 & lane1) alignment acheived.
  bit two_lanes_ready;			///< 2 lanes (lane0 & lane1) ready.

  bit Nx_mode;				///< Model initialized in Nx mode.
  bit x2_mode;				///< Model initialized in 2x mode.
  bit port_initialized;			///< Port is initialized.

  int tx_status_cs_cnt;			///< Transmitted status control symbol count
  int rx_status_cs_cnt;			///< Received status control symbol count
  bit link_initialized;			///< Link is initialized.

  bit receive_lane1;			///< Indicates the receive lane when 2x port is initialized in 1x mode.
					///< 1 : lane1 ; 0 : lane0
  bit receive_lane2;			///< Indicates the receive lane when Nx port is initialized in 1x mode.
					///< 1 : lane2 ; 0 : lane0

  bit signal_detect[int];		///< set when lane receiver is enabled and detects symbols.

  bit temp_2x_alignment_done;		///< Indicates temperory completion of 2x alignment
  bit temp_nx_alignment_done;		///< Indicates temperory completion of nx alignment

  init_sm_states current_init_state;	///< Indicates the current state of init SM

  bool ism_change_req  = FALSE;         ///< True - When state change requested
  init_sm_states ism_req_state;         ///< Requested state

  bit nx_align_data_valid;		///< signal to indicate that new valid entry is available 
					///< in srio_nx_align_data object.

  bit x2_align_data_valid;		///< signal to indicate that new valid entry is available 
					///< in srio_2x_align_data object.

  srio_trans pl_rx_srio_trans_q[$];	///< Queue to pass the srio_trans from rx data handler to protocol checker

  bit lane_polarity_inverted;		///< Indicates lane polarity is inverted.

  bit ies_state;                        ///< Input error state
  bit oes_state;                        ///< Output error state 
  bit irs_state;                        ///< Input retry state
  bit ors_state;                        ///< output retry state

  int bfm_no_lanes;                     ///< no of lanes in bfm logic
  logic [0:11]  curr_tx_ackid = 0;	///< Current ackid to be transmitted.
  logic [0:11]  curr_rx_ackid = 0;	///< Current ackid received.
  logic [0:11]  next_tx_ackid = 0;	///< Next ackid to be transmitted.
  logic [0:11]  cpy_rx_ackid  = 0;	///< Copy of received ackid.
  logic [0:11]  gr_curr_tx_ackid = 0;	///< Current ackid to be transmitted for grouping multipl ackids.

  int ies_cause_value;				///< Cause field when IES is detected.
  int link_req_rst_cmd_cnt;			///< Number of link request with reset-device cmd control symbols received.
  int link_req_rst_port_cmd_cnt;		///< Number of link request with reset-port cmd control symbols received.

  int num_cg_bet_status_cs_cnt;			///< Number of code groups between status control symbol.
  bit status_cs_cnt_check_started;		///< Indicates status cs is getting received.

  int num_cg_bet_vc_status_cs_cnt[int];		///< Number of code groups between VC status control symbol.
  bit vc_status_cs_cnt_check_started[int];	///< Indicates VC status cs is getting received.

  bit sync_seq_detected;			///< Indicates sync sequence detection.
  bit cs_after_sync_seq_rcvd;			///< Indicates a control symbol is received after sync sequence.
  bit cs_after_sync_seq_processed;		///< Indicates the control symbol which was received after sync sequence is processed.
  bit packet_cancelled;				///< Indicates packet is cancelled.
  bit bfm_idle_selected;                	///< Indicates idle selected for bfm logic
  
  bit int_clk;					///< Internal clock used by the tx path of PL active component.

  ///< IDLE2 AET variables.

  bit idle2_bfm_aet_command_set[int];		///< Set by the PL lane driver when aet command is transmitted.

  bit idle2_aet_command_set[int];		///< Set by the monitor instance when aet command is observed on the link.
  bit idle2_aet_cs_fld_rcvr_trained[int];	///< Receiver trained field decoded from the received IDLE2 CS field.
  bit idle2_aet_cs_fld_data_scr_en[int];	///< Data scrambling enable field decoded from the received IDLE2 CS field.
  bit idle2_aet_cs_fld_tap_plus1_cmd[int];	///< Tap(+)1 command field decoded from the received IDLE2 CS field.
  bit idle2_aet_cs_fld_tap_minus1_cmd[int];	///< Tap(-)1 command field decoded from the received IDLE2 CS field.
  bit idle2_aet_cs_fld_reset_cmd[int];		///< Reset field decoded from the received IDLE2 CS field.
  bit idle2_aet_cs_fld_preset_cmd[int];		///< Preset field decoded from the received IDLE2 CS field.
  bit idle2_aet_cs_fld_ack[int];		///< ACK field decoded from the received IDLE2 CS field.
  bit idle2_aet_cs_fld_nack[int];		///< NACK field decoded from the received IDLE2 CS field.

  bit [1:0] idle2_aet_cs_fld_tap_plus1_cmd_val[int];	///< Set by the lane handler to indicate tx path that received a valid tap(+)1 command.
  bit [1:0] idle2_aet_cs_fld_tap_minus1_cmd_val[int];	///< Set by the lane handler to indicate tx path that received a valid tap(-)1 command.

  // Associative arrays for 10b-8b decoding.
  static int data_pos_rd_array [int];			///< Positive running disparity data array for 10Bto8B decoding.
  static int data_neg_rd_array [int];			///< Negative running disparity data array for 10Bto8B decoding.

  static int cntl_pos_rd_array [int];			///< Positive running disparity control array for 10Bto8B decoding.
  static int cntl_neg_rd_array [int];			///< Negative running disparity control array for 10Bto8B decoding.

  // Associative arrays for 8b-10b encoding
  static int enc_data_pos_rd_array[int];		///< Positive running disparity data array for 8Bto10B encoding.
  static int enc_data_neg_rd_array[int];		///< Negative running disparity data array for 8Bto10B encoding.
                                                                                                                               
  static int enc_cntl_pos_rd_array [int];		///< Positive running disparity control array for 8Bto10B encoding.
  static int enc_cntl_neg_rd_array [int];		///< Negative running disparity control array for 8Bto10B encoding.

  static int scrambler_init_array[int];			///< Initialize values for GEN2.x scrambler.


  // GEN3.0 specific Variables

  bit frame_lock [int];					///< set when frame lock is achieved in that particular lane. 
							///< Bit position indicates lane number.

  bit cw_lock [int];					///< set when codeword lock is achieved in that particular lane. 
							///< Bit position indicates lane number.

  bit force_no_lock [int];				///< Forces the Codeword lock SM to NO_LOCK state

  bit lane0_drvr_oe;					///< output driver enable for lane 0. Used only in Gen3.0

  bit asym_mode;					///< Indicates Initialize s/m is in asymmetric state or not.
  bit end_asym_mode;					///< Indicates exit of asymmetric mode.

  bit receive_enable_pi;				///< Local receive enable signal used in init s/m.
  bit transmit_enable_pi;				///< Local transmit enable signal used in init s/m.

  bit recovery_retrain;					///< Init s/m variable to control the recovery timer.

  string max_width;					///< Indicates the max symmetric width in which the port is initialized.

  bit lane_trained [int];				///< Indicates lane trained information.
  bit lane_retraining [int];				///< Indicates lane retraining information.

  bit xmting_idle;					///< Device transmitting idle sequence.
  bit retrain;						///< Port retraining its lanes.

  bit gen3_bfm_training_command_set[int];		///< Indicates bfm has transmitted a training command.

  bit gen3_training_cmd_set [int];			///< Indicates whether DME/CW training command is received or not.
  bit [3:0] gen3_training_equalizer_tap [int];		///< Transmit equalizer tap value received in status_control control codeword.
  bit [2:0] gen3_training_equalizer_cmd [int];		///< Transmit equalizer cmd value received in status_control control codeword.
  bit [2:0] gen3_training_equalizer_status [int];	///< Transmit equalizer status value received in status_control control codeword.

  bit gen3_training_cp1_cmd_set [int];			///< Indicates whether CP1 inc/dec DME training command is received or not.
  bit gen3_training_cn1_cmd_set [int];			///< Indicates whether CN1 inc/dec DME training command is received or not.

  bit [1:0] gen3_training_equalizer_cp1_cmd [int];	///< Indicates the cmd type received for CP1 DME training. 
							///< Valid if gen3_training_cp1_cmd_set is 1 for corresponding lane number.

  bit [1:0] gen3_training_equalizer_cn1_cmd [int];	///< Indicates the cmd type received for CN1 DME training. 
							///< Valid if gen3_training_cn1_cmd_set is 1 for corresponding lane number.

  bit [1:0] gen3_training_equalizer_cp1_status [int];	///< Indicates the coeff status of received for CP1 DME training. 

  bit [1:0] gen3_training_equalizer_cn1_status [int];	///< Indicates the coeff status of received for CN1 DME training. 

  bit dme_mode [int];				///< Indicates whether dme_mode is supported or not.
  bit train_lane [int];				///< Indicates the start of lane training.
  bit retrain_lane [int];			///< Indicates the start of lane retraining.
  int train_timer_en [int];			///< Enables the training timer.
  bit train_timer_done [int];			///< Indicates that training timer is completed.

  bit retrain_timer_en;				///< Enables the retraining timer.
  bit retrain_timer_done;			///< Indicates that retraining timer is completed.

  bit force_drvr_oe [int];			///< Forces the output enable of particular lane indicated by the index.
  bit drvr_oe [int];				///< Indicates that output enable of the lane is enabled.

  bit keep_alive [int];				///< If '1' indicates lane has to be kept alive inorder to retrain quickly when required.

  bit lane_degraded [int];			///< Indicates lane quality is degraded.
  bit retrain_fail [int];			///< Indicates retrain status. If '1', it means retraining is unsuccessful.
  bit training_fail [int];			///< Indicates training status. If '1', it means training is unsuccessful.

  string xmt_equalizer;				///< Transmit equalizer type. "SR_initialize" if CW training, "LR_initialize" if DME training.

  bit receive_enable;				///< Receive enable. If '0', then control symbols and packets are ignored.
  bit receive_enable_rw;			///< Local receive enable used in receive width s/m.

  bit retraining;				///< Indicates port is retraining.
  bit retrain_pending;				///< Indicates port is retrain is pending.

  bit retrain_grnt;				///< Indicates retrain is granted.
  bit retrain_ready;				///< Indicates retrain ready.
  bit xmt_width_grnt;				///< Indicates Transmit width grant.
  bit transmit_enable_rtwc;			///< Indicates transmit enable used in reatrain/transmit width s/m.

  bit xmt_width_cmd_pending;			///< Indicates transmit width command is pending.

  bit mr_restart_training;			///< If set, the coefficirent update S/Ms should come back to NOT_UPDATED state.

  bit [1:0] gen3_c0_coeff_status [int];		///< Status to be sent for c0 coefficient in outbound DME frame.

  bit [1:0] gen3_cp1_coeff_status [int];	///< Status to be sent for cp1 coefficient in outbound DME frame.

  bit [1:0] gen3_cn1_coeff_status [int];	///< Status to be sent for cn1 coefficient in outbound DME frame.

  bit dme_wait_timer_en [int];			///< Enables the DME wait timer. When set, the tx path should count the no. of DME frames it sent out.

  bit dme_wait_timer_done [int];		///< Set by the tx path when it completes the transmission of expected no. of DME frames before 
						///< moving to TRAINED state.

  link_train_sm_states current_dme_train_state[int];	///< current long-run training states. Index indicates lane number.

  xmt_width_sm_states common_trans_xmit_width_state;	///< Transmit width state used by the tx path.

  bit [2:0] xmt_width_port_req_cmd;		///< Transmit width port request command. Decoded from the receiving status/control control CW.
  bit [2:0] change_my_xmt_width;		///< PnPMCSR register field equivalent of "Change My Transmit Width"
  bit [2:0] change_lp_xmt_width;		///< PnPMCSR register field equivalent of "Change Link Partner Transmit Width"

  bit xmt_width_port_cmd_ack;			///< Transmit width port command ack.
  bit xmt_width_port_cmd_nack;			///< Transmit width port command nack.
  bit xmt_width_port_req_pending;		///< Transmit width port request command pending.

  bit x1_mode_xmt_cmd;				///< 1x mode transmit command set.
  bit x2_mode_xmt_cmd;				///< 2x mode transmit command set.
  bit nx_mode_xmt_cmd;				///< Nx mode transmit command set.

  bit transmit_enable;				///< Transmit enable. If '0', then control symbols and packets are blocked.
  bit transmit_enable_tw;			///< Local transmit enable used in transmit width s/m.

  bit [2:0] rcv_width_link_cmd;			///< Receive width link command.
  bit xmt_sc_seq;				///< Transmit sc ordered sequence every 256 codewords.

  int transmit_sc_sequences_cnt;		///< No. of sc ordered sequences to be sent in minimum interval.
  string xmt_width;				///< Transmit width set in the "Transmit width" state mcahine.

  bit rcv_width_link_cmd_ack;			///< receive width command status which needs to be transmitted on the status/control os.
  bit rcv_width_link_cmd_nack;			///< receive width command status which needs to be transmitted on the status/control os.

  string rcv_width;				///< Receive width set in the "Receive width" state mcahine.

  bit x1_mode_rcv_cmd;				///< 1x mode receive command set.
  bit x2_mode_rcv_cmd;				///< 2x mode receive command set.
  bit nx_mode_rcv_cmd;				///< Nx mode receive command set.

  bit timestamp_support;			///< If set, then it indicates timestamp is supported or not.
  bit timestamp_master;				///< If set, then it indicates master mode is enabled else slave mode is enabled.
  bit send_zero_timestamp;			///< If set, timestamp master will send a timestamp sequence control symbols
						///< with all timestamp bits set to zero.

  bit send_timestamp;				///< If set, timestamp master will send a timestamp sequence control symbols
						///< with current TSG value + Timestamp offset.

  bit send_loop_request;			///< If set, timestamp master will send a loop-timing request control symbol.

  bit[0:15] timestamp_offset;			///< Timestamp offset value.
  bit [0:63] TSG;                               ///< Timestamp Generator counter
  bit [0:63] Timestamp0;                        ///< Timestamp stored when loop request is transmitted
  bit [0:63] Timestamp1;                        ///< Timestamp stored when loop response is received
  bit [0:11] delay;                             ///< Delay calculated
  bit loop_req_sent                    =0;      ///< Loop request has been transmitted
  bit loop_resp_recvd                  =0;      ///< Loop response has been received    

  bit from_sc_port_silence;			///< Link partner port entering into silence which is communicated 
						///< through its status / control control codeword.

  bit from_sc_xmt_1x_mode;			///< Link partner port transmitting in 1x mode which is communicated
						///< through its status / control control codeword.

  bit from_sc_asym_mode_en;			///< Link partner supports asymmetric mode
						///< which is communicated through its status / control control codeword.

  bit from_sc_initialized;			///< Link partner port initialized
						///< which is communicated through its status / control control codeword.

  string from_sc_rcv_width;			///< Link partner receive width
						///< which is communicated through its status / control control codeword.

  int from_sc_rcv_width_int;			///< Int version of from_sc_rcv_width. Used to generate state machine variables
						///< as string can't be used in the sensitivity list.

  bit from_sc_retrain_en;			///< Retraining is enabled in link partner.

  bit from_sc_retrain_grnt;			///< Indicates link partner has granted retrain permission for its port.

  bit from_sc_retrain_ready;			///< Indicates link partner is ready retrain its port.

  bit from_sc_retraining;			///< Indicates link partner is retraining.

  bit [2:0] from_sc_receive_lanes_ready;		///< Indicates receive lane ready value of link partner.

  bit [2:0] from_sc_rcv_width_link_cmd;		///< Indicates receive width link command issued by the link partner.
  bit from_sc_rcv_width_link_cmd_ack;		///< Indicates receive width command status of link partner.
  bit from_sc_rcv_width_link_cmd_nack;		///< Indicates receive width command status of link partner.

  bit from_sc_lane_silence[int];		///< Link partner lane (indicated by the index) entering into silence 
						///< which is communicated through its status / control control codeword.

  bit from_sc_lane_trained [int];		///< Link partner's lane indicated by the index is trained.
  bit from_sc_lane_ready [int];			///< Link partner's lane indicated by the index is ready.

  bit from_dme_rcvr_ready [int];		///< Link partner's receiver ready indicated in the received DME frame.

  bit [1:0] status_my_xmt_width_chng;          ///<status of the last requested change to the local transmitter width  
  bit [1:0] status_lp_xmt_width_chng;          ///<status of the last requested change to the link partners transmitter width
  int mul_ack_min;                             ///<Min range of ackid expected
  int mul_ack_max;                             ///<Max range of ackid expected
  int ackid_for_scs;
  int          status_cnt;
  // events/variables used for functional coverage

  event idle_seq_in_pkt_err;                    ///< idle sequence embedded in packet
  event idle_seq_in_scs;                        ///< idle sequece embedded in SCS
  event idle_seq_in_lcs;                        ///< idle sequece embedded in LCS
  event idle2_corrupt_seq;                      ///< corrupted idle2 sequence
  event idle2_cs_field_marker_corrupt;          ///< corrupted idle2 cs field marker
  event idle2_cs_field_corrupt;                 ///< corrupted idle2 cs field
  event status_cs_blocked;                      ///< status cs not present event after 1024 code-groups
  event idle1_corrupt_seq;                      ///< corrupted idle1 sequence
  event idle_seq_not_aligned;                   ///< bfm not transmitting idle2 sequence on all lanes
  event invalid_packet_acc_cs;                  ///< unexpected packet accepted control symbol
  event invalid_packet_na_cs;                   ///< unexpected packet not accepted control symbol
  event packet_ackID_corrupt;                   ///< packet acknowledgement with corrupted packet_ackID
  event lcs_without_end_delimiter;              ///< LCS without end delimier
  event invalid_ackID;                          ///< packets with unexpected ackID

  event rcvd_startcw_in_opencontext;            ///< CSB CW instead of CSEB/CSE CW
  event rcvd_endcw_in_closedcontext;            ///< CSE/CSEB instead of CSB
  event rcvd_data_insteadof_endcw;              ///< DATA CW instead of CSE/CSEB
  event rcvd_seedos_linkreq;                    ///< Received Seed OS followed by Link Req
  event lanechk_cw_correct_bip;                 ///< Lane Check CW with correct BIP
  event lanechk_cw_corrupt_bip;                 ///< Lane Check CW with corrupted BIP
  event rcvd_idle3_with_invalid_cw;             ///< Received invalid CW in Idle3  

  event rcvd_interrupted_timestamp_cs;          ///< Received interrupted Timestamp CS  
  event rcvd_uninterrupted_timestamp_cs;        ///< Received un-interrupted Timestamp CS  
  event pkt_terminating_8bit_boundary;          ///< Received packet that terminates at 8 bit boundary
  event pkt_terminating_non_8bit_boundary;      ///< Received packet that terminates at a non 8 bit boundary

  event rcvd_idle3_with_diffcw_err;             ///< Received IDLE3 with Diff CW in Diff Lanes
  event invert_bit_high;                        ///< Set when invert bit is set 
  event force_reinit_set;                       ///< Force reinit event for FC

 // Methods

  extern function new (string name = "srio_pl_common_component_trans");


endclass


///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : New
/// Description : Constructor method for srio_pl_common_component_trans class. It initializes
/// the encoder array, decoder array and scrambler array.
///////////////////////////////////////////////////////////////////////////////////////////////
function srio_pl_common_component_trans::new(string name="srio_pl_common_component_trans");
  super.new(name);

  /////// 10b-8b decoder array creation ////////
  data_pos_rd_array['h55] = 'h57;
  data_pos_rd_array['h56] = 'hD7;
  data_pos_rd_array['h59] = 'h37;
  data_pos_rd_array['h5A] = 'hB7;
  data_pos_rd_array['h5B] = 'h17;
  data_pos_rd_array['h5C] = 'h77;
  data_pos_rd_array['h5D] = 'h97;
  data_pos_rd_array['h5E] = 'hF7;
  data_pos_rd_array['h65] = 'h48;
  data_pos_rd_array['h66] = 'hC8;
  data_pos_rd_array['h69] = 'h28;
  data_pos_rd_array['h6A] = 'hA8;
  data_pos_rd_array['h6B] = 'h08;
  data_pos_rd_array['h6C] = 'h68;
  data_pos_rd_array['h6D] = 'h88;
  data_pos_rd_array['h6E] = 'hE8;
  data_pos_rd_array['h71] = 'hE7;
  data_pos_rd_array['h72] = 'h87;
  data_pos_rd_array['h73] = 'h67;
  data_pos_rd_array['h74] = 'h07;
  data_pos_rd_array['h75] = 'h47;
  data_pos_rd_array['h76] = 'hC7;
  data_pos_rd_array['h79] = 'h27;
  data_pos_rd_array['h7A] = 'hA7;
  data_pos_rd_array['h95] = 'h5B;
  data_pos_rd_array['h96] = 'hDB;
  data_pos_rd_array['h99] = 'h3B;
  data_pos_rd_array['h9A] = 'hBB;
  data_pos_rd_array['h9B] = 'h1B;
  data_pos_rd_array['h9C] = 'h7B;
  data_pos_rd_array['h9D] = 'h9B;
  data_pos_rd_array['h9E] = 'hFB;
  data_pos_rd_array['hA5] = 'h44;
  data_pos_rd_array['hA6] = 'hC4;
  data_pos_rd_array['hA9] = 'h24;
  data_pos_rd_array['hAA] = 'hA4;
  data_pos_rd_array['hAB] = 'h04;
  data_pos_rd_array['hAC] = 'h64;
  data_pos_rd_array['hAD] = 'h84;
  data_pos_rd_array['hAE] = 'hE4;
  data_pos_rd_array['hB1] = 'hF4;
  data_pos_rd_array['hB2] = 'h94;
  data_pos_rd_array['hB3] = 'h74;
  data_pos_rd_array['hB4] = 'h14;
  data_pos_rd_array['hB5] = 'h54;
  data_pos_rd_array['hB6] = 'hD4;
  data_pos_rd_array['hB9] = 'h34;
  data_pos_rd_array['hBA] = 'hB4;
  data_pos_rd_array['hC5] = 'h58;
  data_pos_rd_array['hC6] = 'hD8;
  data_pos_rd_array['hC9] = 'h38;
  data_pos_rd_array['hCA] = 'hB8;
  data_pos_rd_array['hCB] = 'h18;
  data_pos_rd_array['hCC] = 'h78;
  data_pos_rd_array['hCD] = 'h98;
  data_pos_rd_array['hCE] = 'hF8;
  data_pos_rd_array['hD1] = 'hEC;
  data_pos_rd_array['hD2] = 'h8C;
  data_pos_rd_array['hD3] = 'h6C;
  data_pos_rd_array['hD4] = 'h0C;
  data_pos_rd_array['hD5] = 'h4C;
  data_pos_rd_array['hD6] = 'hCC;
  data_pos_rd_array['hD9] = 'h2C;
  data_pos_rd_array['hDA] = 'hAC;
  data_pos_rd_array['hE1] = 'hFC;
  data_pos_rd_array['hE2] = 'h9C;
  data_pos_rd_array['hE3] = 'h7C;
  data_pos_rd_array['hE4] = 'h1C;
  data_pos_rd_array['hE5] = 'h5C;
  data_pos_rd_array['hE6] = 'hDC;
  data_pos_rd_array['hE9] = 'h3C;
  data_pos_rd_array['hEA] = 'hBC;
  data_pos_rd_array['h115] = 'h5D;
  data_pos_rd_array['h116] = 'hDD;
  data_pos_rd_array['h119] = 'h3D;
  data_pos_rd_array['h11A] = 'hBD;
  data_pos_rd_array['h11B] = 'h1D;
  data_pos_rd_array['h11C] = 'h7D;
  data_pos_rd_array['h11D] = 'h9D;
  data_pos_rd_array['h11E] = 'hFD;
  data_pos_rd_array['h125] = 'h42;
  data_pos_rd_array['h126] = 'hC2;
  data_pos_rd_array['h129] = 'h22;
  data_pos_rd_array['h12A] = 'hA2;
  data_pos_rd_array['h12B] = 'h02;
  data_pos_rd_array['h12C] = 'h62;
  data_pos_rd_array['h12D] = 'h82;
  data_pos_rd_array['h12E] = 'hE2;
  data_pos_rd_array['h131] = 'hF2;
  data_pos_rd_array['h132] = 'h92;
  data_pos_rd_array['h133] = 'h72;
  data_pos_rd_array['h134] = 'h12;
  data_pos_rd_array['h135] = 'h52;
  data_pos_rd_array['h136] = 'hD2;
  data_pos_rd_array['h139] = 'h32;
  data_pos_rd_array['h13A] = 'hB2;
  data_pos_rd_array['h145] = 'h5F;
  data_pos_rd_array['h146] = 'hDF;
  data_pos_rd_array['h149] = 'h3F;
  data_pos_rd_array['h14A] = 'hBF;
  data_pos_rd_array['h14B] = 'h1F;
  data_pos_rd_array['h14C] = 'h7F;
  data_pos_rd_array['h14D] = 'h9F;
  data_pos_rd_array['h14E] = 'hFF;
  data_pos_rd_array['h151] = 'hEA;
  data_pos_rd_array['h152] = 'h8A;
  data_pos_rd_array['h153] = 'h6A;
  data_pos_rd_array['h154] = 'h0A;
  data_pos_rd_array['h155] = 'h4A;
  data_pos_rd_array['h156] = 'hCA;
  data_pos_rd_array['h159] = 'h2A;
  data_pos_rd_array['h15A] = 'hAA;
  data_pos_rd_array['h161] = 'hFA;
  data_pos_rd_array['h162] = 'h9A;
  data_pos_rd_array['h163] = 'h7A;
  data_pos_rd_array['h164] = 'h1A;
  data_pos_rd_array['h165] = 'h5A;
  data_pos_rd_array['h166] = 'hDA;
  data_pos_rd_array['h169] = 'h3A;
  data_pos_rd_array['h16A] = 'hBA;
  data_pos_rd_array['h185] = 'h40;
  data_pos_rd_array['h186] = 'hC0;
  data_pos_rd_array['h189] = 'h20;
  data_pos_rd_array['h18A] = 'hA0;
  data_pos_rd_array['h18B] = 'h00;
  data_pos_rd_array['h18C] = 'h60;
  data_pos_rd_array['h18D] = 'h80;
  data_pos_rd_array['h18E] = 'hE0;
  data_pos_rd_array['h191] = 'hE6;
  data_pos_rd_array['h192] = 'h86;
  data_pos_rd_array['h193] = 'h66;
  data_pos_rd_array['h194] = 'h06;
  data_pos_rd_array['h195] = 'h46;
  data_pos_rd_array['h196] = 'hC6;
  data_pos_rd_array['h199] = 'h26;
  data_pos_rd_array['h19A] = 'hA6;
  data_pos_rd_array['h1A1] = 'hF6;
  data_pos_rd_array['h1A2] = 'h96;
  data_pos_rd_array['h1A3] = 'h76;
  data_pos_rd_array['h1A4] = 'h16;
  data_pos_rd_array['h1A5] = 'h56;
  data_pos_rd_array['h1A6] = 'hD6;
  data_pos_rd_array['h1A9] = 'h36;
  data_pos_rd_array['h1AA] = 'hB6;
  data_pos_rd_array['h1C2] = 'h8E;
  data_pos_rd_array['h1C3] = 'h6E;
  data_pos_rd_array['h1C4] = 'h0E;
  data_pos_rd_array['h1C5] = 'h4E;
  data_pos_rd_array['h1C6] = 'hCE;
  data_pos_rd_array['h1C8] = 'hEE;
  data_pos_rd_array['h1C9] = 'h2E;
  data_pos_rd_array['h1CA] = 'hAE;
  data_pos_rd_array['h215] = 'h5E;
  data_pos_rd_array['h216] = 'hDE;
  data_pos_rd_array['h219] = 'h3E;
  data_pos_rd_array['h21A] = 'hBE;
  data_pos_rd_array['h21B] = 'h1E;
  data_pos_rd_array['h21C] = 'h7E;
  data_pos_rd_array['h21D] = 'h9E;
  data_pos_rd_array['h21E] = 'hFE;
  data_pos_rd_array['h225] = 'h41;
  data_pos_rd_array['h226] = 'hC1;
  data_pos_rd_array['h229] = 'h21;
  data_pos_rd_array['h22A] = 'hA1;
  data_pos_rd_array['h22B] = 'h01;
  data_pos_rd_array['h22C] = 'h61;
  data_pos_rd_array['h22D] = 'h81;
  data_pos_rd_array['h22E] = 'hE1;
  data_pos_rd_array['h231] = 'hF1;
  data_pos_rd_array['h232] = 'h91;
  data_pos_rd_array['h233] = 'h71;
  data_pos_rd_array['h234] = 'h11;
  data_pos_rd_array['h235] = 'h51;
  data_pos_rd_array['h236] = 'hD1;
  data_pos_rd_array['h239] = 'h31;
  data_pos_rd_array['h23A] = 'hB1;
  data_pos_rd_array['h245] = 'h50;
  data_pos_rd_array['h246] = 'hD0;
  data_pos_rd_array['h249] = 'h30;
  data_pos_rd_array['h24A] = 'hB0;
  data_pos_rd_array['h24B] = 'h10;
  data_pos_rd_array['h24C] = 'h70;
  data_pos_rd_array['h24D] = 'h90;
  data_pos_rd_array['h24E] = 'hF0;
  data_pos_rd_array['h251] = 'hE9;
  data_pos_rd_array['h252] = 'h89;
  data_pos_rd_array['h253] = 'h69;
  data_pos_rd_array['h254] = 'h09;
  data_pos_rd_array['h255] = 'h49;
  data_pos_rd_array['h256] = 'hC9;
  data_pos_rd_array['h259] = 'h29;
  data_pos_rd_array['h25A] = 'hA9;
  data_pos_rd_array['h261] = 'hF9;
  data_pos_rd_array['h262] = 'h99;
  data_pos_rd_array['h263] = 'h79;
  data_pos_rd_array['h264] = 'h19;
  data_pos_rd_array['h265] = 'h59;
  data_pos_rd_array['h266] = 'hD9;
  data_pos_rd_array['h269] = 'h39;
  data_pos_rd_array['h26A] = 'hB9;
  data_pos_rd_array['h285] = 'h4F;
  data_pos_rd_array['h286] = 'hCF;
  data_pos_rd_array['h289] = 'h2F;
  data_pos_rd_array['h28A] = 'hAF;
  data_pos_rd_array['h28B] = 'h0F;
  data_pos_rd_array['h28C] = 'h6F;
  data_pos_rd_array['h28D] = 'h8F;
  data_pos_rd_array['h28E] = 'hEF;
  data_pos_rd_array['h291] = 'hE5;
  data_pos_rd_array['h292] = 'h85;
  data_pos_rd_array['h293] = 'h65;
  data_pos_rd_array['h294] = 'h05;
  data_pos_rd_array['h295] = 'h45;
  data_pos_rd_array['h296] = 'hC5;
  data_pos_rd_array['h299] = 'h25;
  data_pos_rd_array['h29A] = 'hA5;
  data_pos_rd_array['h2A1] = 'hF5;
  data_pos_rd_array['h2A2] = 'h95;
  data_pos_rd_array['h2A3] = 'h75;
  data_pos_rd_array['h2A4] = 'h15;
  data_pos_rd_array['h2A5] = 'h55;
  data_pos_rd_array['h2A6] = 'hD5;
  data_pos_rd_array['h2A9] = 'h35;
  data_pos_rd_array['h2AA] = 'hB5;
  data_pos_rd_array['h2C2] = 'h8D;
  data_pos_rd_array['h2C3] = 'h6D;
  data_pos_rd_array['h2C4] = 'h0D;
  data_pos_rd_array['h2C5] = 'h4D;
  data_pos_rd_array['h2C6] = 'hCD;
  data_pos_rd_array['h2C8] = 'hED;
  data_pos_rd_array['h2C9] = 'h2D;
  data_pos_rd_array['h2CA] = 'hAD;
  data_pos_rd_array['h311] = 'hE3;
  data_pos_rd_array['h312] = 'h83;
  data_pos_rd_array['h313] = 'h63;
  data_pos_rd_array['h314] = 'h03;
  data_pos_rd_array['h315] = 'h43;
  data_pos_rd_array['h316] = 'hC3;
  data_pos_rd_array['h319] = 'h23;
  data_pos_rd_array['h31A] = 'hA3;
  data_pos_rd_array['h321] = 'hF3;
  data_pos_rd_array['h322] = 'h93;
  data_pos_rd_array['h323] = 'h73;
  data_pos_rd_array['h324] = 'h13;
  data_pos_rd_array['h325] = 'h53;
  data_pos_rd_array['h326] = 'hD3;
  data_pos_rd_array['h329] = 'h33;
  data_pos_rd_array['h32A] = 'hB3;
  data_pos_rd_array['h342] = 'h8B;
  data_pos_rd_array['h343] = 'h6B;
  data_pos_rd_array['h344] = 'h0B;
  data_pos_rd_array['h345] = 'h4B;
  data_pos_rd_array['h346] = 'hCB;
  data_pos_rd_array['h348] = 'hEB;
  data_pos_rd_array['h349] = 'h2B;
  data_pos_rd_array['h34A] = 'hAB;

  data_neg_rd_array['hB5] = 'h54;
  data_neg_rd_array['hB6] = 'hD4;
  data_neg_rd_array['hB7] = 'hF4;
  data_neg_rd_array['hB9] = 'h34;
  data_neg_rd_array['hBA] = 'hB4;
  data_neg_rd_array['hBB] = 'h14;
  data_neg_rd_array['hBC] = 'h74;
  data_neg_rd_array['hBD] = 'h94;
  data_neg_rd_array['hD5] = 'h4C;
  data_neg_rd_array['hD6] = 'hCC;
  data_neg_rd_array['hD9] = 'h2C;
  data_neg_rd_array['hDA] = 'hAC;
  data_neg_rd_array['hDB] = 'h0C;
  data_neg_rd_array['hDC] = 'h6C;
  data_neg_rd_array['hDD] = 'h8C;
  data_neg_rd_array['hDE] = 'hEC;
  data_neg_rd_array['hE5] = 'h5C;
  data_neg_rd_array['hE6] = 'hDC;
  data_neg_rd_array['hE9] = 'h3C;
  data_neg_rd_array['hEA] = 'hBC;
  data_neg_rd_array['hEB] = 'h1C;
  data_neg_rd_array['hEC] = 'h7C;
  data_neg_rd_array['hED] = 'h9C;
  data_neg_rd_array['hEE] = 'hFC;
  data_neg_rd_array['h135] = 'h52;
  data_neg_rd_array['h136] = 'hD2;
  data_neg_rd_array['h137] = 'hF2;
  data_neg_rd_array['h139] = 'h32;
  data_neg_rd_array['h13A] = 'hB2;
  data_neg_rd_array['h13B] = 'h12;
  data_neg_rd_array['h13C] = 'h72;
  data_neg_rd_array['h13D] = 'h92;
  data_neg_rd_array['h155] = 'h4A;
  data_neg_rd_array['h156] = 'hCA;
  data_neg_rd_array['h159] = 'h2A;
  data_neg_rd_array['h15A] = 'hAA;
  data_neg_rd_array['h15B] = 'h0A;
  data_neg_rd_array['h15C] = 'h6A;
  data_neg_rd_array['h15D] = 'h8A;
  data_neg_rd_array['h15E] = 'hEA;
  data_neg_rd_array['h165] = 'h5A;
  data_neg_rd_array['h166] = 'hDA;
  data_neg_rd_array['h169] = 'h3A;
  data_neg_rd_array['h16A] = 'hBA;
  data_neg_rd_array['h16B] = 'h1A;
  data_neg_rd_array['h16C] = 'h7A;
  data_neg_rd_array['h16D] = 'h9A;
  data_neg_rd_array['h16E] = 'hFA;
  data_neg_rd_array['h171] = 'hEF;
  data_neg_rd_array['h172] = 'h8F;
  data_neg_rd_array['h173] = 'h6F;
  data_neg_rd_array['h174] = 'h0F;
  data_neg_rd_array['h175] = 'h4F;
  data_neg_rd_array['h176] = 'hCF;
  data_neg_rd_array['h179] = 'h2F;
  data_neg_rd_array['h17A] = 'hAF;
  data_neg_rd_array['h195] = 'h46;
  data_neg_rd_array['h196] = 'hC6;
  data_neg_rd_array['h199] = 'h26;
  data_neg_rd_array['h19A] = 'hA6;
  data_neg_rd_array['h19B] = 'h06;
  data_neg_rd_array['h19C] = 'h66;
  data_neg_rd_array['h19D] = 'h86;
  data_neg_rd_array['h19E] = 'hE6;
  data_neg_rd_array['h1A5] = 'h56;
  data_neg_rd_array['h1A6] = 'hD6;
  data_neg_rd_array['h1A9] = 'h36;
  data_neg_rd_array['h1AA] = 'hB6;
  data_neg_rd_array['h1AB] = 'h16;
  data_neg_rd_array['h1AC] = 'h76;
  data_neg_rd_array['h1AD] = 'h96;
  data_neg_rd_array['h1AE] = 'hF6;
  data_neg_rd_array['h1B1] = 'hF0;
  data_neg_rd_array['h1B2] = 'h90;
  data_neg_rd_array['h1B3] = 'h70;
  data_neg_rd_array['h1B4] = 'h10;
  data_neg_rd_array['h1B5] = 'h50;
  data_neg_rd_array['h1B6] = 'hD0;
  data_neg_rd_array['h1B9] = 'h30;
  data_neg_rd_array['h1BA] = 'hB0;
  data_neg_rd_array['h1C5] = 'h4E;
  data_neg_rd_array['h1C6] = 'hCE;
  data_neg_rd_array['h1C9] = 'h2E;
  data_neg_rd_array['h1CA] = 'hAE;
  data_neg_rd_array['h1CB] = 'h0E;
  data_neg_rd_array['h1CC] = 'h6E;
  data_neg_rd_array['h1CD] = 'h8E;
  data_neg_rd_array['h1CE] = 'hEE;
  data_neg_rd_array['h1D1] = 'hE1;
  data_neg_rd_array['h1D2] = 'h81;
  data_neg_rd_array['h1D3] = 'h61;
  data_neg_rd_array['h1D4] = 'h01;
  data_neg_rd_array['h1D5] = 'h41;
  data_neg_rd_array['h1D6] = 'hC1;
  data_neg_rd_array['h1D9] = 'h21;
  data_neg_rd_array['h1DA] = 'hA1;
  data_neg_rd_array['h1E1] = 'hFE;
  data_neg_rd_array['h1E2] = 'h9E;
  data_neg_rd_array['h1E3] = 'h7E;
  data_neg_rd_array['h1E4] = 'h1E;
  data_neg_rd_array['h1E5] = 'h5E;
  data_neg_rd_array['h1E6] = 'hDE;
  data_neg_rd_array['h1E9] = 'h3E;
  data_neg_rd_array['h1EA] = 'hBE;
  data_neg_rd_array['h235] = 'h51;
  data_neg_rd_array['h236] = 'hD1;
  data_neg_rd_array['h237] = 'hF1;
  data_neg_rd_array['h239] = 'h31;
  data_neg_rd_array['h23A] = 'hB1;
  data_neg_rd_array['h23B] = 'h11;
  data_neg_rd_array['h23C] = 'h71;
  data_neg_rd_array['h23D] = 'h91;
  data_neg_rd_array['h255] = 'h49;
  data_neg_rd_array['h256] = 'hC9;
  data_neg_rd_array['h259] = 'h29;
  data_neg_rd_array['h25A] = 'hA9;
  data_neg_rd_array['h25B] = 'h09;
  data_neg_rd_array['h25C] = 'h69;
  data_neg_rd_array['h25D] = 'h89;
  data_neg_rd_array['h25E] = 'hE9;
  data_neg_rd_array['h265] = 'h59;
  data_neg_rd_array['h266] = 'hD9;
  data_neg_rd_array['h269] = 'h39;
  data_neg_rd_array['h26A] = 'hB9;
  data_neg_rd_array['h26B] = 'h19;
  data_neg_rd_array['h26C] = 'h79;
  data_neg_rd_array['h26D] = 'h99;
  data_neg_rd_array['h26E] = 'hF9;
  data_neg_rd_array['h271] = 'hE0;
  data_neg_rd_array['h272] = 'h80;
  data_neg_rd_array['h273] = 'h60;
  data_neg_rd_array['h274] = 'h00;
  data_neg_rd_array['h275] = 'h40;
  data_neg_rd_array['h276] = 'hC0;
  data_neg_rd_array['h279] = 'h20;
  data_neg_rd_array['h27A] = 'hA0;
  data_neg_rd_array['h295] = 'h45;
  data_neg_rd_array['h296] = 'hC5;
  data_neg_rd_array['h299] = 'h25;
  data_neg_rd_array['h29A] = 'hA5;
  data_neg_rd_array['h29B] = 'h05;
  data_neg_rd_array['h29C] = 'h65;
  data_neg_rd_array['h29D] = 'h85;
  data_neg_rd_array['h29E] = 'hE5;
  data_neg_rd_array['h2A5] = 'h55;
  data_neg_rd_array['h2A6] = 'hD5;
  data_neg_rd_array['h2A9] = 'h35;
  data_neg_rd_array['h2AA] = 'hB5;
  data_neg_rd_array['h2AB] = 'h15;
  data_neg_rd_array['h2AC] = 'h75;
  data_neg_rd_array['h2AD] = 'h95;
  data_neg_rd_array['h2AE] = 'hF5;
  data_neg_rd_array['h2B1] = 'hFF;
  data_neg_rd_array['h2B2] = 'h9F;
  data_neg_rd_array['h2B3] = 'h7F;
  data_neg_rd_array['h2B4] = 'h1F;
  data_neg_rd_array['h2B5] = 'h5F;
  data_neg_rd_array['h2B6] = 'hDF;
  data_neg_rd_array['h2B9] = 'h3F;
  data_neg_rd_array['h2BA] = 'hBF;
  data_neg_rd_array['h2C5] = 'h4D;
  data_neg_rd_array['h2C6] = 'hCD;
  data_neg_rd_array['h2C9] = 'h2D;
  data_neg_rd_array['h2CA] = 'hAD;
  data_neg_rd_array['h2CB] = 'h0D;
  data_neg_rd_array['h2CC] = 'h6D;
  data_neg_rd_array['h2CD] = 'h8D;
  data_neg_rd_array['h2CE] = 'hED;
  data_neg_rd_array['h2D1] = 'hE2;
  data_neg_rd_array['h2D2] = 'h82;
  data_neg_rd_array['h2D3] = 'h62;
  data_neg_rd_array['h2D4] = 'h02;
  data_neg_rd_array['h2D5] = 'h42;
  data_neg_rd_array['h2D6] = 'hC2;
  data_neg_rd_array['h2D9] = 'h22;
  data_neg_rd_array['h2DA] = 'hA2;
  data_neg_rd_array['h2E1] = 'hFD;
  data_neg_rd_array['h2E2] = 'h9D;
  data_neg_rd_array['h2E3] = 'h7D;
  data_neg_rd_array['h2E4] = 'h1D;
  data_neg_rd_array['h2E5] = 'h5D;
  data_neg_rd_array['h2E6] = 'hDD;
  data_neg_rd_array['h2E9] = 'h3D;
  data_neg_rd_array['h2EA] = 'hBD;
  data_neg_rd_array['h315] = 'h43;
  data_neg_rd_array['h316] = 'hC3;
  data_neg_rd_array['h319] = 'h23;
  data_neg_rd_array['h31A] = 'hA3;
  data_neg_rd_array['h31B] = 'h03;
  data_neg_rd_array['h31C] = 'h63;
  data_neg_rd_array['h31D] = 'h83;
  data_neg_rd_array['h31E] = 'hE3;
  data_neg_rd_array['h325] = 'h53;
  data_neg_rd_array['h326] = 'hD3;
  data_neg_rd_array['h329] = 'h33;
  data_neg_rd_array['h32A] = 'hB3;
  data_neg_rd_array['h32B] = 'h13;
  data_neg_rd_array['h32C] = 'h73;
  data_neg_rd_array['h32D] = 'h93;
  data_neg_rd_array['h32E] = 'hF3;
  data_neg_rd_array['h331] = 'hF8;
  data_neg_rd_array['h332] = 'h98;
  data_neg_rd_array['h333] = 'h78;
  data_neg_rd_array['h334] = 'h18;
  data_neg_rd_array['h335] = 'h58;
  data_neg_rd_array['h336] = 'hD8;
  data_neg_rd_array['h339] = 'h38;
  data_neg_rd_array['h33A] = 'hB8;
  data_neg_rd_array['h345] = 'h4B;
  data_neg_rd_array['h346] = 'hCB;
  data_neg_rd_array['h349] = 'h2B;
  data_neg_rd_array['h34A] = 'hAB;
  data_neg_rd_array['h34B] = 'h0B;
  data_neg_rd_array['h34C] = 'h6B;
  data_neg_rd_array['h34D] = 'h8B;
  data_neg_rd_array['h34E] = 'hEB;
  data_neg_rd_array['h351] = 'hE4;
  data_neg_rd_array['h352] = 'h84;
  data_neg_rd_array['h353] = 'h64;
  data_neg_rd_array['h354] = 'h04;
  data_neg_rd_array['h355] = 'h44;
  data_neg_rd_array['h356] = 'hC4;
  data_neg_rd_array['h359] = 'h24;
  data_neg_rd_array['h35A] = 'hA4;
  data_neg_rd_array['h361] = 'hFB;
  data_neg_rd_array['h362] = 'h9B;
  data_neg_rd_array['h363] = 'h7B;
  data_neg_rd_array['h364] = 'h1B;
  data_neg_rd_array['h365] = 'h5B;
  data_neg_rd_array['h366] = 'hDB;
  data_neg_rd_array['h369] = 'h3B;
  data_neg_rd_array['h36A] = 'hBB;
  data_neg_rd_array['h385] = 'h47;
  data_neg_rd_array['h386] = 'hC7;
  data_neg_rd_array['h389] = 'h27;
  data_neg_rd_array['h38A] = 'hA7;
  data_neg_rd_array['h38B] = 'h07;
  data_neg_rd_array['h38C] = 'h67;
  data_neg_rd_array['h38D] = 'h87;
  data_neg_rd_array['h38E] = 'hE7;
  data_neg_rd_array['h391] = 'hE8;
  data_neg_rd_array['h392] = 'h88;
  data_neg_rd_array['h393] = 'h68;
  data_neg_rd_array['h394] = 'h08;
  data_neg_rd_array['h395] = 'h48;
  data_neg_rd_array['h396] = 'hC8;
  data_neg_rd_array['h399] = 'h28;
  data_neg_rd_array['h39A] = 'hA8;
  data_neg_rd_array['h3A1] = 'hF7;
  data_neg_rd_array['h3A2] = 'h97;
  data_neg_rd_array['h3A3] = 'h77;
  data_neg_rd_array['h3A4] = 'h17;
  data_neg_rd_array['h3A5] = 'h57;
  data_neg_rd_array['h3A6] = 'hD7;
  data_neg_rd_array['h3A9] = 'h37;
  data_neg_rd_array['h3AA] = 'hB7;

  cntl_pos_rd_array['h57] = 'hF7;
  cntl_pos_rd_array['h97] = 'hFB;
  cntl_pos_rd_array['h117] = 'hFD;
  cntl_pos_rd_array['h217] = 'hFE;
  cntl_pos_rd_array['h305] = 'hBC;
  cntl_pos_rd_array['h306] = 'h3C;
  cntl_pos_rd_array['h307] = 'hFC;
  cntl_pos_rd_array['h309] = 'hDC;
  cntl_pos_rd_array['h30A] = 'h5C;
  cntl_pos_rd_array['h30B] = 'h1C;
  cntl_pos_rd_array['h30C] = 'h7C;
  cntl_pos_rd_array['h30D] = 'h9C;

  cntl_neg_rd_array['h1E8] = 'hFE;
  cntl_neg_rd_array['h2E8] = 'hFD;
  cntl_neg_rd_array['h368] = 'hFB;
  cntl_neg_rd_array['h3A8] = 'hF7;
  cntl_neg_rd_array['hF2] = 'h9C;
  cntl_neg_rd_array['hF3] = 'h7C;
  cntl_neg_rd_array['hF4] = 'h1C;
  cntl_neg_rd_array['hF5] = 'h5C;
  cntl_neg_rd_array['hF6] = 'hDC;
  cntl_neg_rd_array['hF8] = 'hFC;
  cntl_neg_rd_array['hF9] = 'h3C;
  cntl_neg_rd_array['hFA] = 'hBC;

  // enc table
  /////// 8b-10b encoder array creation ////////
  enc_data_pos_rd_array['h57] = 'h55;   
  enc_data_pos_rd_array['hD7] = 'h56;
  enc_data_pos_rd_array['h37] = 'h59;
  enc_data_pos_rd_array['hB7] = 'h5A;
  enc_data_pos_rd_array['h17] = 'h5B;
  enc_data_pos_rd_array['h77] = 'h5C;
  enc_data_pos_rd_array['h97] = 'h5D;
  enc_data_pos_rd_array['hF7] = 'h5E;
  enc_data_pos_rd_array['h48] = 'h65;
  enc_data_pos_rd_array['hC8] = 'h66;
  enc_data_pos_rd_array['h28] = 'h69;
  enc_data_pos_rd_array['hA8] = 'h6A;
  enc_data_pos_rd_array['h08] = 'h6B;
  enc_data_pos_rd_array['h68] = 'h6C;
  enc_data_pos_rd_array['h88] = 'h6D;
  enc_data_pos_rd_array['hE8] = 'h6E;
  enc_data_pos_rd_array['hE7] = 'h71;
  enc_data_pos_rd_array['h87] = 'h72;
  enc_data_pos_rd_array['h67] = 'h73;
  enc_data_pos_rd_array['h07] = 'h74;
  enc_data_pos_rd_array['h47] = 'h75;
  enc_data_pos_rd_array['hC7] = 'h76;
  enc_data_pos_rd_array['h27] = 'h79;
  enc_data_pos_rd_array['hA7] = 'h7A;
  enc_data_pos_rd_array['h5B] = 'h95;
  enc_data_pos_rd_array['hDB] = 'h96;
  enc_data_pos_rd_array['h3B] = 'h99;
  enc_data_pos_rd_array['hBB] = 'h9A;
  enc_data_pos_rd_array['h1B] = 'h9B;
  enc_data_pos_rd_array['h7B] = 'h9C;
  enc_data_pos_rd_array['h9B] = 'h9D;
  enc_data_pos_rd_array['hFB] = 'h9E;
  enc_data_pos_rd_array['h44] = 'hA5;
  enc_data_pos_rd_array['hC4] = 'hA6;
  enc_data_pos_rd_array['h24] = 'hA9;
  enc_data_pos_rd_array['hA4] = 'hAA;
  enc_data_pos_rd_array['h04] = 'hAB;
  enc_data_pos_rd_array['h64] = 'hAC;
  enc_data_pos_rd_array['h84] = 'hAD;
  enc_data_pos_rd_array['hE4] = 'hAE;
  enc_data_pos_rd_array['hF4] = 'hB1;
  enc_data_pos_rd_array['h94] = 'hB2;
  enc_data_pos_rd_array['h74] = 'hB3;
  enc_data_pos_rd_array['h14] = 'hB4;
  enc_data_pos_rd_array['h54] = 'hB5;
  enc_data_pos_rd_array['hD4] = 'hB6;
  enc_data_pos_rd_array['h34] = 'hB9;
  enc_data_pos_rd_array['hB4] = 'hBA;
  enc_data_pos_rd_array['h58] = 'hC5;
  enc_data_pos_rd_array['hD8] = 'hC6;
  enc_data_pos_rd_array['h38] = 'hC9;
  enc_data_pos_rd_array['hB8] = 'hCA;
  enc_data_pos_rd_array['h18] = 'hCB;
  enc_data_pos_rd_array['h78] = 'hCC;
  enc_data_pos_rd_array['h98] = 'hCD;
  enc_data_pos_rd_array['hF8] = 'hCE;
  enc_data_pos_rd_array['hEC] = 'hD1;
  enc_data_pos_rd_array['h8C] = 'hD2;
  enc_data_pos_rd_array['h6C] = 'hD3;
  enc_data_pos_rd_array['h0C] = 'hD4;
  enc_data_pos_rd_array['h4C] = 'hD5;
  enc_data_pos_rd_array['hCC] = 'hD6;
  enc_data_pos_rd_array['h2C] = 'hD9;
  enc_data_pos_rd_array['hAC] = 'hDA;
  enc_data_pos_rd_array['hFC] = 'hE1;
  enc_data_pos_rd_array['h9C] = 'hE2;
  enc_data_pos_rd_array['h7C] = 'hE3;
  enc_data_pos_rd_array['h1C] = 'hE4;
  enc_data_pos_rd_array['h5C] = 'hE5;
  enc_data_pos_rd_array['hDC] = 'hE6;
  enc_data_pos_rd_array['h3C] = 'hE9;
  enc_data_pos_rd_array['hBC] = 'hEA;
  enc_data_pos_rd_array['h5D] = 'h115;    
  enc_data_pos_rd_array['hDD] = 'h116;
  enc_data_pos_rd_array['h3D] = 'h119;
  enc_data_pos_rd_array['hBD] = 'h11A;
  enc_data_pos_rd_array['h1D] = 'h11B;
  enc_data_pos_rd_array['h7D] = 'h11C;
  enc_data_pos_rd_array['h9D] = 'h11D;
  enc_data_pos_rd_array['hFD] = 'h11E;
  enc_data_pos_rd_array['h42] = 'h125;
  enc_data_pos_rd_array['hC2] = 'h126;
  enc_data_pos_rd_array['h22] = 'h129;
  enc_data_pos_rd_array['hA2] = 'h12A;
  enc_data_pos_rd_array['h02] = 'h12B;
  enc_data_pos_rd_array['h62] = 'h12C;
  enc_data_pos_rd_array['h82] = 'h12D;
  enc_data_pos_rd_array['hE2] = 'h12E;
  enc_data_pos_rd_array['hF2] = 'h131;
  enc_data_pos_rd_array['h92] = 'h132;
  enc_data_pos_rd_array['h72] = 'h133;
  enc_data_pos_rd_array['h12] = 'h134;
  enc_data_pos_rd_array['h52] = 'h135;
  enc_data_pos_rd_array['hD2] = 'h136;
  enc_data_pos_rd_array['h32] = 'h139;
  enc_data_pos_rd_array['hB2] = 'h13A;
  enc_data_pos_rd_array['h5F] = 'h145;
  enc_data_pos_rd_array['hDF] = 'h146;
  enc_data_pos_rd_array['h3F] = 'h149;
  enc_data_pos_rd_array['hBF] = 'h14A;
  enc_data_pos_rd_array['h1F] = 'h14B;
  enc_data_pos_rd_array['h7F] = 'h14C;
  enc_data_pos_rd_array['h9F] = 'h14D;
  enc_data_pos_rd_array['hFF] = 'h14E;
  enc_data_pos_rd_array['hEA] = 'h151;
  enc_data_pos_rd_array['h8A] = 'h152;
  enc_data_pos_rd_array['h6A] = 'h153;
  enc_data_pos_rd_array['h0A] = 'h154;
  enc_data_pos_rd_array['h4A] = 'h155;
  enc_data_pos_rd_array['hCA] = 'h156;
  enc_data_pos_rd_array['h2A] = 'h159;
  enc_data_pos_rd_array['hAA] = 'h15A;
  enc_data_pos_rd_array['hFA] = 'h161;
  enc_data_pos_rd_array['h9A] = 'h162;
  enc_data_pos_rd_array['h7A] = 'h163;
  enc_data_pos_rd_array['h1A] = 'h164;
  enc_data_pos_rd_array['h5A] = 'h165;
  enc_data_pos_rd_array['hDA] = 'h166;
  enc_data_pos_rd_array['h3A] = 'h169;
  enc_data_pos_rd_array['hBA] = 'h16A;
  enc_data_pos_rd_array['h40] = 'h185;
  enc_data_pos_rd_array['hC0] = 'h186;
  enc_data_pos_rd_array['h20] = 'h189;
  enc_data_pos_rd_array['hA0] = 'h18A;
  enc_data_pos_rd_array['h00] = 'h18B;
  enc_data_pos_rd_array['h60] = 'h18C;
  enc_data_pos_rd_array['h80] = 'h18D;
  enc_data_pos_rd_array['hE0] = 'h18E;
  enc_data_pos_rd_array['hE6] = 'h191;
  enc_data_pos_rd_array['h86] = 'h192;
  enc_data_pos_rd_array['h66] = 'h193;
  enc_data_pos_rd_array['h06] = 'h194;
  enc_data_pos_rd_array['h46] = 'h195;
  enc_data_pos_rd_array['hC6] = 'h196;
  enc_data_pos_rd_array['h26] = 'h199;
  enc_data_pos_rd_array['hA6] = 'h19A;
  enc_data_pos_rd_array['hF6] = 'h1A1;
  enc_data_pos_rd_array['h96] = 'h1A2;
  enc_data_pos_rd_array['h76] = 'h1A3;
  enc_data_pos_rd_array['h16] = 'h1A4;
  enc_data_pos_rd_array['h56] = 'h1A5;
  enc_data_pos_rd_array['hD6] = 'h1A6;
  enc_data_pos_rd_array['h36] = 'h1A9;
  enc_data_pos_rd_array['hB6] = 'h1AA;
  enc_data_pos_rd_array['h8E] = 'h1C2;
  enc_data_pos_rd_array['h6E] = 'h1C3;
  enc_data_pos_rd_array['h0E] = 'h1C4;
  enc_data_pos_rd_array['h4E] = 'h1C5;
  enc_data_pos_rd_array['hCE] = 'h1C6;
  enc_data_pos_rd_array['hEE] = 'h1C8;
  enc_data_pos_rd_array['h2E] = 'h1C9;
  enc_data_pos_rd_array['hAE] = 'h1CA;
  enc_data_pos_rd_array['h5E] = 'h215;
  enc_data_pos_rd_array['hDE] = 'h216;
  enc_data_pos_rd_array['h3E] = 'h219;
  enc_data_pos_rd_array['hBE] = 'h21A;
  enc_data_pos_rd_array['h1E] = 'h21B;
  enc_data_pos_rd_array['h7E] = 'h21C;
  enc_data_pos_rd_array['h9E] = 'h21D;
  enc_data_pos_rd_array['hFE] = 'h21E;
  enc_data_pos_rd_array['h41] = 'h225;
  enc_data_pos_rd_array['hC1] = 'h226;
  enc_data_pos_rd_array['h21] = 'h229;
  enc_data_pos_rd_array['hA1] = 'h22A;
  enc_data_pos_rd_array['h01] = 'h22B;
  enc_data_pos_rd_array['h61] = 'h22C;
  enc_data_pos_rd_array['h81] = 'h22D;
  enc_data_pos_rd_array['hE1] = 'h22E;
  enc_data_pos_rd_array['hF1] = 'h231;
  enc_data_pos_rd_array['h91] = 'h232;
  enc_data_pos_rd_array['h71] = 'h233;
  enc_data_pos_rd_array['h11] = 'h234;
  enc_data_pos_rd_array['h51] = 'h235;
  enc_data_pos_rd_array['hD1] = 'h236;
  enc_data_pos_rd_array['h31] = 'h239;
  enc_data_pos_rd_array['hB1] = 'h23A;
  enc_data_pos_rd_array['h50] = 'h245;
  enc_data_pos_rd_array['hD0] = 'h246;
  enc_data_pos_rd_array['h30] = 'h249;
  enc_data_pos_rd_array['hB0] = 'h24A;
  enc_data_pos_rd_array['h10] = 'h24B;
  enc_data_pos_rd_array['h70] = 'h24C;
  enc_data_pos_rd_array['h90] = 'h24D;
  enc_data_pos_rd_array['hF0] = 'h24E;
  enc_data_pos_rd_array['hE9] = 'h251;
  enc_data_pos_rd_array['h89] = 'h252;
  enc_data_pos_rd_array['h69] = 'h253;
  enc_data_pos_rd_array['h09] = 'h254;
  enc_data_pos_rd_array['h49] = 'h255;
  enc_data_pos_rd_array['hC9] = 'h256;
  enc_data_pos_rd_array['h29] = 'h259;
  enc_data_pos_rd_array['hA9] = 'h25A;
  enc_data_pos_rd_array['hF9] = 'h261;
  enc_data_pos_rd_array['h99] = 'h262;
  enc_data_pos_rd_array['h79] = 'h263;
  enc_data_pos_rd_array['h19] = 'h264;
  enc_data_pos_rd_array['h59] = 'h265;
  enc_data_pos_rd_array['hD9] = 'h266;
  enc_data_pos_rd_array['h39] = 'h269;
  enc_data_pos_rd_array['hB9] = 'h26A;
  enc_data_pos_rd_array['h4F] = 'h285;
  enc_data_pos_rd_array['hCF] = 'h286;
  enc_data_pos_rd_array['h2F] = 'h289;
  enc_data_pos_rd_array['hAF] = 'h28A;
  enc_data_pos_rd_array['h0F] = 'h28B;
  enc_data_pos_rd_array['h6F] = 'h28C;
  enc_data_pos_rd_array['h8F] = 'h28D;
  enc_data_pos_rd_array['hEF] = 'h28E;
  enc_data_pos_rd_array['hE5] = 'h291;
  enc_data_pos_rd_array['h85] = 'h292;
  enc_data_pos_rd_array['h65] = 'h293;
  enc_data_pos_rd_array['h05] = 'h294;
  enc_data_pos_rd_array['h45] = 'h295;
  enc_data_pos_rd_array['hC5] = 'h296;
  enc_data_pos_rd_array['h25] = 'h299;
  enc_data_pos_rd_array['hA5] = 'h29A;
  enc_data_pos_rd_array['hF5] = 'h2A1;
  enc_data_pos_rd_array['h95] = 'h2A2;
  enc_data_pos_rd_array['h75] = 'h2A3;
  enc_data_pos_rd_array['h15] = 'h2A4;
  enc_data_pos_rd_array['h55] = 'h2A5;
  enc_data_pos_rd_array['hD5] = 'h2A6;
  enc_data_pos_rd_array['h35] = 'h2A9;
  enc_data_pos_rd_array['hB5] = 'h2AA;
  enc_data_pos_rd_array['h8D] = 'h2C2;
  enc_data_pos_rd_array['h6D] = 'h2C3;
  enc_data_pos_rd_array['h0D] = 'h2C4;
  enc_data_pos_rd_array['h4D] = 'h2C5;
  enc_data_pos_rd_array['hCD] = 'h2C6;
  enc_data_pos_rd_array['hED] = 'h2C8;
  enc_data_pos_rd_array['h2D] = 'h2C9;
  enc_data_pos_rd_array['hAD] = 'h2CA;
  enc_data_pos_rd_array['hE3] = 'h311;
  enc_data_pos_rd_array['h83] = 'h312;
  enc_data_pos_rd_array['h63] = 'h313;
  enc_data_pos_rd_array['h03] = 'h314;
  enc_data_pos_rd_array['h43] = 'h315;
  enc_data_pos_rd_array['hC3] = 'h316;
  enc_data_pos_rd_array['h23] = 'h319;
  enc_data_pos_rd_array['hA3] = 'h31A;
  enc_data_pos_rd_array['hF3] = 'h321;
  enc_data_pos_rd_array['h93] = 'h322;
  enc_data_pos_rd_array['h73] = 'h323;
  enc_data_pos_rd_array['h13] = 'h324;
  enc_data_pos_rd_array['h53] = 'h325;
  enc_data_pos_rd_array['hD3] = 'h326;
  enc_data_pos_rd_array['h33] = 'h329;
  enc_data_pos_rd_array['hB3] = 'h32A;
  enc_data_pos_rd_array['h8B] = 'h342;
  enc_data_pos_rd_array['h6B] = 'h343;
  enc_data_pos_rd_array['h0B] = 'h344;
  enc_data_pos_rd_array['h4B] = 'h345;
  enc_data_pos_rd_array['hCB] = 'h346;
  enc_data_pos_rd_array['hEB] = 'h348;
  enc_data_pos_rd_array['h2B] = 'h349;
  enc_data_pos_rd_array['hAB] = 'h34A;
	
  enc_data_neg_rd_array['h54] = 'hB5; 
  enc_data_neg_rd_array['hD4] = 'hB6;
  enc_data_neg_rd_array['hF4] = 'hB7;
  enc_data_neg_rd_array['h34] = 'hB9;
  enc_data_neg_rd_array['hB4] = 'hBA;
  enc_data_neg_rd_array['h14] = 'hBB;
  enc_data_neg_rd_array['h74] = 'hBC;
  enc_data_neg_rd_array['h94] = 'hBD;
  enc_data_neg_rd_array['h4C] = 'hD5;
  enc_data_neg_rd_array['hCC] = 'hD6;
  enc_data_neg_rd_array['h2C] = 'hD9;
  enc_data_neg_rd_array['hAC] = 'hDA;
  enc_data_neg_rd_array['h0C] = 'hDB;
  enc_data_neg_rd_array['h6C] = 'hDC;
  enc_data_neg_rd_array['h8C] = 'hDD;
  enc_data_neg_rd_array['hEC] = 'hDE;
  enc_data_neg_rd_array['h5C] = 'hE5;
  enc_data_neg_rd_array['hDC] = 'hE6;
  enc_data_neg_rd_array['h3C] = 'hE9;
  enc_data_neg_rd_array['hBC] = 'hEA;
  enc_data_neg_rd_array['h1C] = 'hEB;
  enc_data_neg_rd_array['h7C] = 'hEC;
  enc_data_neg_rd_array['h9C] = 'hED;
  enc_data_neg_rd_array['hFC] = 'hEE;
  enc_data_neg_rd_array['h52] = 'h135; 
  enc_data_neg_rd_array['hD2] = 'h136;
  enc_data_neg_rd_array['hF2] = 'h137;
  enc_data_neg_rd_array['h32] = 'h139;
  enc_data_neg_rd_array['hB2] = 'h13A;
  enc_data_neg_rd_array['h12] = 'h13B;
  enc_data_neg_rd_array['h72] = 'h13C;
  enc_data_neg_rd_array['h92] = 'h13D;
  enc_data_neg_rd_array['h4A] = 'h155;
  enc_data_neg_rd_array['hCA] = 'h156;
  enc_data_neg_rd_array['h2A] = 'h159;
  enc_data_neg_rd_array['hAA] = 'h15A;
  enc_data_neg_rd_array['h0A] = 'h15B;
  enc_data_neg_rd_array['h6A] = 'h15C;
  enc_data_neg_rd_array['h8A] = 'h15D;
  enc_data_neg_rd_array['hEA] = 'h15E;
  enc_data_neg_rd_array['h5A] = 'h165;
  enc_data_neg_rd_array['hDA] = 'h166;
  enc_data_neg_rd_array['h3A] = 'h169;
  enc_data_neg_rd_array['hBA] = 'h16A;
  enc_data_neg_rd_array['h1A] = 'h16B;
  enc_data_neg_rd_array['h7A] = 'h16C;
  enc_data_neg_rd_array['h9A] = 'h16D;
  enc_data_neg_rd_array['hFA] = 'h16E;
  enc_data_neg_rd_array['hEF] = 'h171;
  enc_data_neg_rd_array['h8F] = 'h172;
  enc_data_neg_rd_array['h6F] = 'h173;
  enc_data_neg_rd_array['h0F] = 'h174;
  enc_data_neg_rd_array['h4F] = 'h175;
  enc_data_neg_rd_array['hCF] = 'h176;
  enc_data_neg_rd_array['h2F] = 'h179;
  enc_data_neg_rd_array['hAF] = 'h17A;
  enc_data_neg_rd_array['h46] = 'h195;
  enc_data_neg_rd_array['hC6] = 'h196;
  enc_data_neg_rd_array['h26] = 'h199;
  enc_data_neg_rd_array['hA6] = 'h19A;
  enc_data_neg_rd_array['h06] = 'h19B;
  enc_data_neg_rd_array['h66] = 'h19C;
  enc_data_neg_rd_array['h86] = 'h19D;
  enc_data_neg_rd_array['hE6] = 'h19E;
  enc_data_neg_rd_array['h56] = 'h1A5;
  enc_data_neg_rd_array['hD6] = 'h1A6;
  enc_data_neg_rd_array['h36] = 'h1A9;
  enc_data_neg_rd_array['hB6] = 'h1AA;
  enc_data_neg_rd_array['h16] = 'h1AB;
  enc_data_neg_rd_array['h76] = 'h1AC;
  enc_data_neg_rd_array['h96] = 'h1AD;
  enc_data_neg_rd_array['hF6] = 'h1AE;
  enc_data_neg_rd_array['hF0] = 'h1B1;
  enc_data_neg_rd_array['h90] = 'h1B2;
  enc_data_neg_rd_array['h70] = 'h1B3;
  enc_data_neg_rd_array['h10] = 'h1B4;
  enc_data_neg_rd_array['h50] = 'h1B5;
  enc_data_neg_rd_array['hD0] = 'h1B6;
  enc_data_neg_rd_array['h30] = 'h1B9;
  enc_data_neg_rd_array['hB0] = 'h1BA;
  enc_data_neg_rd_array['h4E] = 'h1C5;
  enc_data_neg_rd_array['hCE] = 'h1C6;
  enc_data_neg_rd_array['h2E] = 'h1C9;
  enc_data_neg_rd_array['hAE] = 'h1CA;
  enc_data_neg_rd_array['h0E] = 'h1CB;
  enc_data_neg_rd_array['h6E] = 'h1CC;
  enc_data_neg_rd_array['h8E] = 'h1CD;
  enc_data_neg_rd_array['hEE] = 'h1CE;
  enc_data_neg_rd_array['hE1] = 'h1D1;
  enc_data_neg_rd_array['h81] = 'h1D2;
  enc_data_neg_rd_array['h61] = 'h1D3;
  enc_data_neg_rd_array['h01] = 'h1D4;
  enc_data_neg_rd_array['h41] = 'h1D5;
  enc_data_neg_rd_array['hC1] = 'h1D6;
  enc_data_neg_rd_array['h21] = 'h1D9;
  enc_data_neg_rd_array['hA1] = 'h1DA;
  enc_data_neg_rd_array['hFE] = 'h1E1;
  enc_data_neg_rd_array['h9E] = 'h1E2;
  enc_data_neg_rd_array['h7E] = 'h1E3;
  enc_data_neg_rd_array['h1E] = 'h1E4;
  enc_data_neg_rd_array['h5E] = 'h1E5;
  enc_data_neg_rd_array['hDE] = 'h1E6;
  enc_data_neg_rd_array['h3E] = 'h1E9;
  enc_data_neg_rd_array['hBE] = 'h1EA;
  enc_data_neg_rd_array['h51] = 'h235;
  enc_data_neg_rd_array['hD1] = 'h236;
  enc_data_neg_rd_array['hF1] = 'h237;
  enc_data_neg_rd_array['h31] = 'h239;
  enc_data_neg_rd_array['hB1] = 'h23A;
  enc_data_neg_rd_array['h11] = 'h23B;
  enc_data_neg_rd_array['h71] = 'h23C;
  enc_data_neg_rd_array['h91] = 'h23D;
  enc_data_neg_rd_array['h49] = 'h255;
  enc_data_neg_rd_array['hC9] = 'h256;
  enc_data_neg_rd_array['h29] = 'h259;
  enc_data_neg_rd_array['hA9] = 'h25A;
  enc_data_neg_rd_array['h09] = 'h25B;
  enc_data_neg_rd_array['h69] = 'h25C;
  enc_data_neg_rd_array['h89] = 'h25D;
  enc_data_neg_rd_array['hE9] = 'h25E;
  enc_data_neg_rd_array['h59] = 'h265;
  enc_data_neg_rd_array['hD9] = 'h266;
  enc_data_neg_rd_array['h39] = 'h269;
  enc_data_neg_rd_array['hB9] = 'h26A;
  enc_data_neg_rd_array['h19] = 'h26B;
  enc_data_neg_rd_array['h79] = 'h26C;
  enc_data_neg_rd_array['h99] = 'h26D;
  enc_data_neg_rd_array['hF9] = 'h26E;
  enc_data_neg_rd_array['hE0] = 'h271;
  enc_data_neg_rd_array['h80] = 'h272;
  enc_data_neg_rd_array['h60] = 'h273;
  enc_data_neg_rd_array['h00] = 'h274;
  enc_data_neg_rd_array['h40] = 'h275;
  enc_data_neg_rd_array['hC0] = 'h276;
  enc_data_neg_rd_array['h20] = 'h279;
  enc_data_neg_rd_array['hA0] = 'h27A;
  enc_data_neg_rd_array['h45] = 'h295;
  enc_data_neg_rd_array['hC5] = 'h296;
  enc_data_neg_rd_array['h25] = 'h299;
  enc_data_neg_rd_array['hA5] = 'h29A;
  enc_data_neg_rd_array['h05] = 'h29B;
  enc_data_neg_rd_array['h65] = 'h29C;
  enc_data_neg_rd_array['h85] = 'h29D;
  enc_data_neg_rd_array['hE5] = 'h29E;
  enc_data_neg_rd_array['h55] = 'h2A5;
  enc_data_neg_rd_array['hD5] = 'h2A6;
  enc_data_neg_rd_array['h35] = 'h2A9;
  enc_data_neg_rd_array['hB5] = 'h2AA;
  enc_data_neg_rd_array['h15] = 'h2AB;
  enc_data_neg_rd_array['h75] = 'h2AC;
  enc_data_neg_rd_array['h95] = 'h2AD;
  enc_data_neg_rd_array['hF5] = 'h2AE;
  enc_data_neg_rd_array['hFF] = 'h2B1;
  enc_data_neg_rd_array['h9F] = 'h2B2;
  enc_data_neg_rd_array['h7F] = 'h2B3;
  enc_data_neg_rd_array['h1F] = 'h2B4;
  enc_data_neg_rd_array['h5F] = 'h2B5;
  enc_data_neg_rd_array['hDF] = 'h2B6;
  enc_data_neg_rd_array['h3F] = 'h2B9;
  enc_data_neg_rd_array['hBF] = 'h2BA;
  enc_data_neg_rd_array['h4D] = 'h2C5;
  enc_data_neg_rd_array['hCD] = 'h2C6;
  enc_data_neg_rd_array['h2D] = 'h2C9;
  enc_data_neg_rd_array['hAD] = 'h2CA;
  enc_data_neg_rd_array['h0D] = 'h2CB;
  enc_data_neg_rd_array['h6D] = 'h2CC;
  enc_data_neg_rd_array['h8D] = 'h2CD;
  enc_data_neg_rd_array['hED] = 'h2CE;
  enc_data_neg_rd_array['hE2] = 'h2D1;
  enc_data_neg_rd_array['h82] = 'h2D2;
  enc_data_neg_rd_array['h62] = 'h2D3;
  enc_data_neg_rd_array['h02] = 'h2D4;
  enc_data_neg_rd_array['h42] = 'h2D5;
  enc_data_neg_rd_array['hC2] = 'h2D6;
  enc_data_neg_rd_array['h22] = 'h2D9;
  enc_data_neg_rd_array['hA2] = 'h2DA;
  enc_data_neg_rd_array['hFD] = 'h2E1;
  enc_data_neg_rd_array['h9D] = 'h2E2;
  enc_data_neg_rd_array['h7D] = 'h2E3;
  enc_data_neg_rd_array['h1D] = 'h2E4;
  enc_data_neg_rd_array['h5D] = 'h2E5;
  enc_data_neg_rd_array['hDD] = 'h2E6;
  enc_data_neg_rd_array['h3D] = 'h2E9;
  enc_data_neg_rd_array['hBD] = 'h2EA;
  enc_data_neg_rd_array['h43] = 'h315;
  enc_data_neg_rd_array['hC3] = 'h316;
  enc_data_neg_rd_array['h23] = 'h319;
  enc_data_neg_rd_array['hA3] = 'h31A;
  enc_data_neg_rd_array['h03] = 'h31B;
  enc_data_neg_rd_array['h63] = 'h31C;
  enc_data_neg_rd_array['h83] = 'h31D;
  enc_data_neg_rd_array['hE3] = 'h31E;
  enc_data_neg_rd_array['h53] = 'h325;
  enc_data_neg_rd_array['hD3] = 'h326;
  enc_data_neg_rd_array['h33] = 'h329;
  enc_data_neg_rd_array['hB3] = 'h32A;
  enc_data_neg_rd_array['h13] = 'h32B;
  enc_data_neg_rd_array['h73] = 'h32C;
  enc_data_neg_rd_array['h93] = 'h32D;
  enc_data_neg_rd_array['hF3] = 'h32E;
  enc_data_neg_rd_array['hF8] = 'h331;
  enc_data_neg_rd_array['h98] = 'h332;
  enc_data_neg_rd_array['h78] = 'h333;
  enc_data_neg_rd_array['h18] = 'h334;
  enc_data_neg_rd_array['h58] = 'h335;
  enc_data_neg_rd_array['hD8] = 'h336;
  enc_data_neg_rd_array['h38] = 'h339;
  enc_data_neg_rd_array['hB8] = 'h33A;
  enc_data_neg_rd_array['h4B] = 'h345;
  enc_data_neg_rd_array['hCB] = 'h346;
  enc_data_neg_rd_array['h2B] = 'h349;
  enc_data_neg_rd_array['hAB] = 'h34A;
  enc_data_neg_rd_array['h0B] = 'h34B;
  enc_data_neg_rd_array['h6B] = 'h34C;
  enc_data_neg_rd_array['h8B] = 'h34D;
  enc_data_neg_rd_array['hEB] = 'h34E;
  enc_data_neg_rd_array['hE4] = 'h351;
  enc_data_neg_rd_array['h84] = 'h352;
  enc_data_neg_rd_array['h64] = 'h353;
  enc_data_neg_rd_array['h04] = 'h354;
  enc_data_neg_rd_array['h44] = 'h355;
  enc_data_neg_rd_array['hC4] = 'h356;
  enc_data_neg_rd_array['h24] = 'h359;
  enc_data_neg_rd_array['hA4] = 'h35A;
  enc_data_neg_rd_array['hFB] = 'h361;
  enc_data_neg_rd_array['h9B] = 'h362;
  enc_data_neg_rd_array['h7B] = 'h363;
  enc_data_neg_rd_array['h1B] = 'h364;
  enc_data_neg_rd_array['h5B] = 'h365;
  enc_data_neg_rd_array['hDB] = 'h366;
  enc_data_neg_rd_array['h3B] = 'h369;
  enc_data_neg_rd_array['hBB] = 'h36A;
  enc_data_neg_rd_array['h47] = 'h385;
  enc_data_neg_rd_array['hC7] = 'h386;
  enc_data_neg_rd_array['h27] = 'h389;
  enc_data_neg_rd_array['hA7] = 'h38A;
  enc_data_neg_rd_array['h07] = 'h38B;
  enc_data_neg_rd_array['h67] = 'h38C;
  enc_data_neg_rd_array['h87] = 'h38D;
  enc_data_neg_rd_array['hE7] = 'h38E;
  enc_data_neg_rd_array['hE8] = 'h391;
  enc_data_neg_rd_array['h88] = 'h392;
  enc_data_neg_rd_array['h68] = 'h393;
  enc_data_neg_rd_array['h08] = 'h394;
  enc_data_neg_rd_array['h48] = 'h395;
  enc_data_neg_rd_array['hC8] = 'h396;
  enc_data_neg_rd_array['h28] = 'h399;
  enc_data_neg_rd_array['hA8] = 'h39A;
  enc_data_neg_rd_array['hF7] = 'h3A1;
  enc_data_neg_rd_array['h97] = 'h3A2;
  enc_data_neg_rd_array['h77] = 'h3A3;
  enc_data_neg_rd_array['h17] = 'h3A4;
  enc_data_neg_rd_array['h57] = 'h3A5;
  enc_data_neg_rd_array['hD7] = 'h3A6;
  enc_data_neg_rd_array['h37] = 'h3A9;
  enc_data_neg_rd_array['hB7] = 'h3AA;
	
  enc_cntl_pos_rd_array['hF7] = 'h57;
  enc_cntl_pos_rd_array['hFB] = 'h97;
  enc_cntl_pos_rd_array['hFD] = 'h117;
  enc_cntl_pos_rd_array['hFE] = 'h217;
  enc_cntl_pos_rd_array['hBC] = 'h305;
  enc_cntl_pos_rd_array['h3C] = 'h306;
  enc_cntl_pos_rd_array['hFC] = 'h307;
  enc_cntl_pos_rd_array['hDC] = 'h309;
  enc_cntl_pos_rd_array['h5C] = 'h30A;
  enc_cntl_pos_rd_array['h1C] = 'h30B;
  enc_cntl_pos_rd_array['h7C] = 'h30C;
  enc_cntl_pos_rd_array['h9C] = 'h30D;

  enc_cntl_neg_rd_array['hFE] = 'h1E8;
  enc_cntl_neg_rd_array['hFD] = 'h2E8;
  enc_cntl_neg_rd_array['hFB] = 'h368;
  enc_cntl_neg_rd_array['hF7] = 'h3A8;
  enc_cntl_neg_rd_array['h9C] = 'hF2;
  enc_cntl_neg_rd_array['h7C] = 'hF3;
  enc_cntl_neg_rd_array['h1C] = 'hF4;
  enc_cntl_neg_rd_array['h5C] = 'hF5;
  enc_cntl_neg_rd_array['hDC] = 'hF6;
  enc_cntl_neg_rd_array['hFC] = 'hF8;
  enc_cntl_neg_rd_array['h3C] = 'hF9;
  enc_cntl_neg_rd_array['hBC] = 'hFA;

  // tx scrambler initialisation array
  scrambler_init_array[0]  = 17'b1111_1111_1111_1111_1;
  scrambler_init_array[1]  = 17'b1111_1111_0000_0110_1;
  scrambler_init_array[2]  = 17'b0000_0000_1000_0110_1;
  scrambler_init_array[3]  = 17'b0000_0110_0111_1010_0;
  scrambler_init_array[4]  = 17'b1000_0000_1011_1001_0;
  scrambler_init_array[5]  = 17'b1111_1010_1000_0111_0;
  scrambler_init_array[6]  = 17'b0100_0011_1001_1011_1;
  scrambler_init_array[7]  = 17'b1100_0100_1010_0101_0;
  scrambler_init_array[8]  = 17'b0101_1111_0100_1001_0;
  scrambler_init_array[9]  = 17'b1111_1010_0111_1001_1;
  scrambler_init_array[10] = 17'b1011_0011_0111_0010_1;
  scrambler_init_array[11] = 17'b1100_1010_1011_0011_0;
  scrambler_init_array[12] = 17'b1011_1000_0101_0011_1;
  scrambler_init_array[13] = 17'b0000_1011_0110_1111_0;
  scrambler_init_array[14] = 17'b0101_1000_1001_1010_1;
  scrambler_init_array[15] = 17'b0011_0111_1010_1000_1;


 endfunction : new
