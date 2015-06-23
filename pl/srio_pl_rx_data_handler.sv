////////////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File       :  srio_rx_data_handler.sv
// Project    :  srio vip
// Purpose    :  Rx data handler contains the following major functionalities:
// 		 1. IDLE detection
// 		 2. Deskew
// 		 3. Destriping
// Author     :  Mobiveil
//
// Physical layer Receiving data handler class.
//
//
//////////////////////////////////////////////////////////////////////////////////////////////////

class srio_pl_rx_data_handler extends uvm_component;

  /// @cond
  `uvm_component_utils(srio_pl_rx_data_handler)
  /// @endcond

  virtual srio_interface srio_if;				///< Virtual interface

  srio_env_config rx_dh_env_config;				///< ENV config instance

  srio_pl_config rx_dh_config;					///< PL Config instance

  srio_pl_common_component_trans rx_dh_trans;			///< PL monitor common transaction instance

  srio_pl_tx_rx_mon_common_trans rx_dh_common_mon_trans;	///< Common monitor transction instance

  srio_reg_block rx_dh_reg_model;				///< Register model instance

  
  srio_trans srio_trans_cs_ins;					///< srio_trans instances for forming control symbol transaction.
  srio_trans cloned_srio_trans_cs_ins;

  srio_trans link_init_srio_trans_cs_ins;			///< srio_trans instance used to check CS CRC error before link initialization.

  srio_trans srio_trans_pkt_ins;				///< srio_trans instances for forming packet transaction.
  srio_trans cloned_srio_trans_pkt_ins;

  // Properties

  int idle_k_cnt;				///< K character count
  int idle_m_cnt;				///< M character count
  bit cs_st_fg=0; 
  bit bfm_or_mon;                               ///< Indicates BFM or monitor instance. 1: BFM ; 0: Monitor
  bit mon_type;					///< Monitor type. 1 : Tx monitor ; 0 : Rx monitor.
  bit report_error;				///< Report error or warning.
 
  bit dut_idle2_spt;				///< IDLE2 sequence support for DUT
  bit dut_idle2_en;				///< IDLE2 sequence enable for DUT
 
  uvm_object uvm_data_ins[int];			///< uvm_object instance to capture uvm_event data.
  srio_pl_lane_data srio_data_ins[int];		///< srio lane data handle to push into align queue.
  srio_pl_lane_data srio_data_ins_temp[int];	///< srio lane data handle to capture from srio_rx_lane_event.
  srio_pl_lane_data srio_data_ins_q[int][$];	///< srio lane data queue to store the data from lane handler.
  srio_pl_lane_data x2_srio_data;		///< srio lane data handle to pop from 2x align queue.
  srio_pl_lane_data nx_srio_data;		///< srio lane data handle to pop from nx align queue.
   
  srio_2x_align_data x2_align_data;		///< x2 lane align data to be used by 2x align s/m
  
  srio_nx_align_data nx_align_data;		///< nx lane align data to be used by nx align s/m
   
  srio_pl_lane_data x2_lane_align_q[int][$];	///< 2X lane alignment queue.
  srio_pl_lane_data nx_lane_align_q[int][$];	///< 2X lane alignment queue.
    
  srio_1x_lane_data x1_lane_data;		///< 1X lane data. This is used only inside this class.
  
  int x1_lane;					///< active 1x lane
  bit x1_lane_data_valid;			///< 1x lane data valid
      
  int x2_cg_cnt, nx_cg_cnt;			///< codegroup count for de-skew
        
  bit srio_data_ins_valid[int];			///< control bit to indicate srio_data_ins as valid.
  bit clear_x2_lane_queues;			///< control bit to clear x2_lane_align_q.
  bit clear_nx_lane_queues;			///< control bit to clear nx_lane_align_q.
  bit inc_x2_cnt, inc_nx_cnt;			///< control bits for x2 and nx deskewing.
        
  bit prev_temp_2x_alignment_done;		///< Indicates temporary 2x alignment status.
  bit prev_temp_nx_alignment_done;		///< Indicates temporary nx alignment status.
         
  bit cntl_symbol_open, prev_cntl_symbol_open;	///< control bits used for link initialization.
  bit packet_open;				///< Indicates packet destriping status.
  bit sop_received;				///< Indicates SOP is received. Used to check if any end-delimitig CS is received without SOP.
  int cntl_symbol_bytes;			///< No. of control symbol bytes collected during destriping.
  int packet_bytes;				///< No. of packet bytes collected during destriping.
  bit nx_scs_rcvd;				///< Used in IDLE1 checking.
  bit lcs_completed_in_same_column;		///< Used in 8x & 16x modes where LCS completes in single column.
  bit packet_ended;				///< Indicates packet has just ended. Used when b2b packets are received.
  bit x1_delimiter_detected;			///< Indicates control symbol is received in x1 mode format.
  bit x2_delimiter_detected;			///< Indicates control symbol is received in x2 mode format.
  int cs_char_cnt;				///< Local variable used in form_1x_srio_trans to detect the LCS completion.

  bit local_cntl_symbol_open; 			///< used for detecting last column of control symbol.
  bit perform_idle2_truncation_check; 		///< used for detecting last column of control symbol.
  int sc_cnt;					///< Counts the number of 'SC' received to detect the control symbol start and end.

  int active_lane_for_idle;			///< Indicates the lane on which idle sequence is decoded for performing checks.
  bit active_lane_found;			///< Indicates the active lane for idle is identified.

  bit idle_seq_start_detected;			///< Indicates idle sequence start is detected.
  bit idle_seq_start_after_port_init_detected;	///< Indicates idle sequence start is detected after port initialization.
  bit [7:0] idle_seq_char[int][$];		///< Holds the idle sequence characters from each of the active lanes.
  bit idle_seq_cntl[int][$];			///< Holds the control signal for the corresponding idle character.

  // IDLE sequence properties
  bit lane0_idle_valid;				///< Indicates idle sequence characters read from lane 0 is valid.
  bit [7:0] lane0_idle_char;			///< Holds the idle sequence characters from lane 0.
  bit lane0_idle_cntl;				///< Holds the control signal for lane 0 idle character.

  bit lane_idle_valid;				///< Indicates idle sequence characters read from lane other than lane 0 is valid.
  bit [7:0] lane_idle_char;             	///< Holds the idle sequence character from lane other than lane 0.
  bit lane_idle_cntl;                   	///< Holds the control signal for lane_idle_char.

  bit x1_idle_seq_chk_in_progress;		///< Indicates idle sequence check in X1 mode is in progress.
  bit x2_idle_seq_chk_in_progress;		///< Indicates idle sequence check in X2 mode is in progress.
  bit nx_idle_seq_chk_in_progress;		///< Indicates idle sequence check in NX mode is in progress.

  bit idle_check_in_progress;			///< Indicates idle sequence check is in progress.
  bit idle_check_started;			///< Indicates idle sequence check has started.
  bit idle2_started_with_k;			///< Indicates IDLE2 sequence started with 'K' character.

  int idle1_char_cnt;				///< Counts the IDLE1 characters.
  bit idle1_A_received;				///< 'A' character received in IDLE1 sequence.

  int idle2_non_AM_char_cnt;			///< Counts the no. of non A/M characters to check the A/M character spacing in IDLE2 sequence.
  int last_idle2_non_AM_char_cnt;		///< Stores the last value of idle2_non_AM_char_cnt.
  int max_d00_char_cnt;				///< Indicates maximum no. of D0.0 characters that could be present between 2 A/M characters.
  int idle2_psr_char_cnt;			///< Counts the no. of pseudo random characters in an IDLE2 sequence.
  int idle2_M_char_cnt;				///< Counts the 'M' characters to detect CS field marker in received IDLE2 sequence.
  int idle2_cs_marker_char_cnt;			///< Counts the characters in CS field marker.
  int idle2_D_after_M_cnt;			///< Counts the no. of data characters received after an 'M' character in the PSR of IDLE2 sequence.
  int idle2_cs_field_char_cnt;			///< Counts the characters in IDLE2 CS Field.
  int cs_fld_bit_loc;				///< CS field bit locations.
  int cs_fld_bit_loc_2;				///< Temporary variable for CS field bit locations.
  int cs_fld_bit_loc_3;				///< Temporary variable for CS field bit locations.
  int idle2_cs_field_cmp_bits;			///< CS field compare bits.
  int idle2_cs_field_curr_bits;			///< Current CS field bits.
  int idle2_marker_d10_2_rcvd_cnt;		///< No. of times, D10.2 characters received in a CS field marker.
  int temp_idl_chk;				///< Temporary variable which indicates the IDLE sequence collecting lane.
  bit idle2_cs_marker;				///< Indicates IDLE2 CS field marker is being received.
  bit idle2_cs_field;				///< Indicates IDLE2 CS field is being received.
  bit idle2_first_psr_seq;			///< Holds the first PSR character count in the received IDLE2 sequence.
  bit idle2_psr_length_check_done;		///< Indicates IDLE2 PSR length check is done.
  bit [7:0] idle2_cs_marker_char_5;		///< Holds the 5th character of IDLE2 CS field marker.
  bit [7:0] idle2_cs_marker_char_6;		///< Holds the 6th character of IDLE2 CS field marker.
  bit [2:0] idle2_active_link_width;		///< Holds the active link width value received in the CS field marker.
  bit [2:0] exp_idle2_active_link_width;	///< Holds the expected active link width value.
  bit [4:0] idle2_lane_num;			///< Holds the lane number value received in the CS field marker.
  bit [0:63] idle2_cs_field_bits;		///< Holds the decoded IDLE2 CS field bits.

  bit cntl_symbol_err;				///< Indicates control symbol error is detected.
  bit pkt_size_err_reported;			///< Indicates packet size error is already reported once.

  bit link_init_cntl_symbol_err;		///< control symbol error is detected during link initialization process.

  int scs_final_bytes;				///< Short control symbol byte count.

  int temp_sdi_var;				///< Temporary variable to store serial data input lane number.
  int cg_bet_clk_comp_cnt;			///< No. of codegroups between clock compensation sequence.
  bit k_for_clk_comp_check_rcvd;		///< 'K' character which is a part of clock compensation sequence is received.
  bit clk_comp_started;				///< Indicates clock compensation sequence started.
  bit clk_comp_check_started;			///< Indicates clock compnesation sequence check started.
  bit clk_comp_rcvd;				///< Indicates clock compensation sequence is received.
  bit clk_comp_freq_err;			///< Indicates clock compensation sequence occurance frequency is violated.

  bit sync_seq_started;				///< Indicates sync sequence started.
  bit check_for_sync_seq;			///< Indicates check for sync sequence is happening currently which is used to mask few checks.
  int sync_seq_D_cnt;				///< Indicaates D character count in sync sequence.
  int sync_seq_MDDDD_cnt;			///< Indicates no. of MDDDD sequence received as part of sync sequence.

  // Events
  uvm_event srio_rx_lane_event[int];		///< Lane event containing respective lane data received from lane handler component.

  // GEN3.0 related variables
  bit [31:0] link_crc32;			///< Holds the link crc32 value.
  bit [31:0] temp_gen3_pkt_data;		///< Temporary variable to store a part of packet data.

  srio_gen3_align_data gen3_align_data_ins;	///< Align data instance used for calling form_gen3_srio_trans method.

  bit gen3_ordered_seq_start_detected;			///< Indicates start of an ordered sequence.
  brc3_cntl_cw_func_type idle3_seq_cw_type[int][$];	///< Holds the idle3 sequence control codeword type from each of the active lanes.
  bit [0:63] idle3_seq_cw[int][$];			///< Holds the  idle3 codeword for the corresponding gen3 idle character.

  bit perform_idle3_truncation_check;			///< Indicates idle3_truncation_check method can be called.
  bit gen3_cs_completed_in_same_column;			///< Indicates a control symbol was received in the current column.
  bit skip_os_in_progress;				///< Indicates skip ordered sequence is in progress.
  bit descr_seed_os_in_progress;			///< Indicates descrambler seed ordered sequence is in progress.
  bit status_cntl_os_in_progress;			///< Indicates status control ordered sequence is in progress.

  bit descr_seed_os_detected;				///< Indicates Descrabler seed ordered sequence is detected by the monitor.
  bit descr_seed_os_detected_within_pkt;		///< Indicates Descrabler seed ordered sequence is detected when a packet is in progress.

  brc3_cntl_cw_func_type lane0_idle3_seq_cw_type;	///< Holds the codeword type enum value received on lane0.
  bit [0:63] lane0_idle3_seq_cw;			///< Holds the codeword value received on lane0.

  brc3_cntl_cw_func_type lane_idle3_seq_cw_type;	///< Holds the codeword type enum value received on lane other than lane0.
  bit [0:63] lane_idle3_seq_cw;                        	///< Holds the codeword value received on lane other than lane0.
  brc3_cntl_cw_func_type prev_cntl_cw_type;		///< Previous control codeword type.

  int idle3_chk_cntl_cw_cnt;				///< codeword count used in ordered sequence check.
  int idle3_cw_cnt_bet_descr_seed_os;			///< No. of codeword inbetween 2 descrambler seed ordered sequences in an IDLE3.
  int idle3_cw_cnt_bet_stat_cntl_os;			///< No. of codeword inbetween 2 status control ordered sequences in an IDLE3.
  int first_stat_cntl_os_rcvd;				///< Indicates first status control ordered sequence is received in an IDLE3.

  bit timestamp_start_flag;				///< Start flag decoded from the received timestamp_control symbol.
  bit timestamp_end_flag;				///< End flag decoded from the received timestamp_control symbol.
  bit [1:0] timestamp_seq_num;				///< Sequence number of the received timestamp control symbol. Used in GEN3.0.
  int timestamp_cs_cnt;					///< Counts the no. of timestamp control symbols received.

  bit [31:0] capture_0_reg_val;				///< Variable used to update Capture 0 CSR.
  bit [31:0] capture_1_reg_val;				///< Variable used to update Capture 1 CSR.
  bit [31:0] capture_2_reg_val;				///< Variable used to update Capture 2 CSR.
  bit [31:0] capture_3_reg_val;				///< Variable used to update Capture 3 CSR.
  bit [31:0] capture_4_reg_val;				///< Variable used to update Capture 4 CSR.

  uvm_reg_field reqd_field_name[string];	///< Associative array to get respective field name from register_update_method.

  // Methods
  extern function new(string name = "srio_pl_rx_data_handler", uvm_component parent = null);
  extern task run_phase(uvm_phase phase);

  extern task clear_vars_on_reset();
  extern virtual task get_lane_data();
  extern virtual task automatic capture_lane_event(int lane_num);
  extern virtual task srio_data_ins_gen();
  extern virtual task srio_idle_detection();
  extern virtual task x2_lane_deskew();
  extern virtual task nx_lane_deskew();
  extern virtual task x2_destriping();
  extern virtual task nx_destriping();
  extern virtual task form_1x_srio_trans();
  extern virtual task form_2x_srio_trans();
  extern virtual task form_nx_srio_trans(input int nx_lane_num);
  extern virtual task set_link_initialization();
  extern virtual task clear_link_initialization();
  extern virtual task link_init_check_trigger();
  extern virtual task idle_seq_collect();
  extern virtual task idle_seq_checks();
  extern virtual task idle1_check();
  extern virtual task idle2_check();
  extern virtual task idle2_invalid_char_check();
  extern virtual task idle2_contiguous_psr_length_check();
  extern virtual task idle2_total_psr_length_check();
  extern virtual task idle2_cs_marker_check();
  extern virtual task idle2_cs_marker_dxy_check();
  extern virtual task idle2_cs_field_check();
  extern virtual task idle2_truncation_check();
  extern virtual task idle_negotiation_check();
  extern virtual task control_symbol_check(input int lane_num);
  extern virtual task check_pkt_char(input int pkt_lane_num);
  extern virtual task pkt_size_err();
  extern virtual task clk_comp_seq_rate_check();
  extern virtual task sync_sequence_capture();

  extern virtual task objection_handling(uvm_phase phase);

  // GEN3.0 related methods
  extern virtual task form_gen3_srio_trans(input int gen3_lane_num);
  extern virtual task gen_trans_xmting_idle();
  extern virtual task link_crc32_check();
  extern virtual task gen3_pkt_unpadded_delimiter_check();
  extern virtual task gen3_pkt_padded_delimiter_check();
  extern virtual task gen3_status_cntl_cw_decode();
  extern virtual task idle3_seq_checks();
  extern virtual task idle3_truncation_check();
  extern virtual task idle3_check();
  extern virtual task check_port_scope_fields_in_stat_cntl_cw();
  extern virtual task check_from_sc_port_fields();

  extern virtual task update_error_detect_csr(string csr_field_name);

  extern virtual task automatic register_update_method(string reg_name, string field_name, int offset, string reg_ins, output uvm_reg_field out_field_name);

endclass


///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : New
/// Description : Constructor method for srio_pl_rx_data_handler class.
///////////////////////////////////////////////////////////////////////////////////////////////
function srio_pl_rx_data_handler::new(string name="srio_pl_rx_data_handler", uvm_component parent=null);
  super.new(name, parent);
  x1_lane_data = new("pl_1x_lane_data");
  gen3_align_data_ins = new("pl_gen3_align_data");
endfunction : new



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : run_phase
/// Description : run_phase method of srio_pl_rx_data_handler class.
/// It triggers all the methods within the class which needs to be run forever.
/// It also registers the callback for uvm_error demote logic.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::run_phase(uvm_phase phase);

  err_demoter pl_rx_dh_err_demoter = new();
  pl_rx_dh_err_demoter.en_err_demote = !report_error;
  uvm_report_cb::add(this, pl_rx_dh_err_demoter);

  fork

    get_lane_data();
    srio_data_ins_gen();
    x2_lane_deskew();
    nx_lane_deskew();
    x2_destriping();
    nx_destriping();
    clear_link_initialization();
    link_init_check_trigger();
    form_1x_srio_trans();
    idle_seq_collect();
    clear_vars_on_reset();

    if (rx_dh_env_config.srio_mode != SRIO_GEN30)
      srio_idle_detection();

    if (rx_dh_config.idle_seq_check_en && rx_dh_config.has_checks && rx_dh_env_config.srio_mode != SRIO_GEN30)
      idle_seq_checks();

    if (rx_dh_config.idle_seq_check_en && rx_dh_config.has_checks && rx_dh_env_config.srio_mode != SRIO_GEN30)
      idle_negotiation_check();

    if (rx_dh_env_config.srio_mode == SRIO_GEN30)
      gen3_status_cntl_cw_decode();

    if (rx_dh_env_config.srio_mode == SRIO_GEN30)
      idle3_seq_checks();

    if (rx_dh_env_config.srio_mode == SRIO_GEN30 && ~bfm_or_mon)
      gen_trans_xmting_idle();

    objection_handling(phase);

  join_none

endtask : run_phase



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : get_lane_data
/// Description : It triggers the capture_lane_event for all the lanes based on the
/// number of lanes supported.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::get_lane_data();

  fork

    begin //{
      capture_lane_event(0);
    end //}

    begin //{

      if (rx_dh_env_config.num_of_lanes>1)
      begin //{
        capture_lane_event(1);		// Lane 1 will be redundant lane only if 2x mode supported.
      end //}

    end //}

    begin //{

      if (rx_dh_env_config.num_of_lanes>2)
      begin //{
	fork
          capture_lane_event(2);	// Lane 2 will be redundant lane only if 4x mode is supported.
          capture_lane_event(3);
	join
      end //}

    end //}

    begin //{

      if (rx_dh_env_config.num_of_lanes>4)
      begin //{
	fork
          capture_lane_event(4);
          capture_lane_event(5);
          capture_lane_event(6);
          capture_lane_event(7);
	join
      end //}

    end //}

    begin //{

      if (rx_dh_env_config.num_of_lanes>8)
      begin //{
	fork
          capture_lane_event(8);
          capture_lane_event(9);
          capture_lane_event(10);
          capture_lane_event(11);
          capture_lane_event(12);
          capture_lane_event(13);
          capture_lane_event(14);
          capture_lane_event(15);
	join
      end //}

    end //}

  join


endtask : get_lane_data


///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : capture_lane_event
/// Description : Captures the srio_rx_lane_event and accumulates the captured data
/// into the srio_data_ins_q. This is an "automatic" method which runs parallely for
/// all the available lanes.
///////////////////////////////////////////////////////////////////////////////////////////////
task automatic srio_pl_rx_data_handler::capture_lane_event(int lane_num);

  forever begin //{

    #1ps;
    srio_rx_lane_event[lane_num].wait_ptrigger_data(uvm_data_ins[lane_num]);
    $cast(srio_data_ins_temp[lane_num], uvm_data_ins[lane_num]);

    srio_data_ins_q[lane_num].push_back(srio_data_ins_temp[lane_num]);

    //if (~bfm_or_mon && ~mon_type)
    //  `uvm_info("SRIO_PL_RX_DATA_HANDLER : LANE_EVENT_INFO", $sformatf(" Event from lane %0d triggered. character is %0h", lane_num, srio_data_ins_temp[lane_num].character), UVM_LOW)

	//if (srio_data_ins_q[0].size()>0 && ~bfm_or_mon && ~mon_type)
	//begin //{
	//  for (int i2=0; i2<srio_data_ins_q[0].size(); i2++)
	//    $display($time, " During push. srio_data_ins_q[0][%0d].character is %0h", i2, srio_data_ins_q[0][i2].character);
	//end //}

  end //}

endtask : capture_lane_event



///////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : srio_data_ins_gen
/// Description : The srio_rx_lane_event is triggered on the negedge of the lane clock, and it is pushed into the
/// srio_data_ins_q at that time. The data from that queue is popped on the negedge of the core clock
/// and srio_data_ins is created. At the next posegde of core clock, the srio_data_ins is processed by the
/// deskew logic based on the srio_data_ins_valid. Since core clock frequency is higher than the lane clock, 
/// this negegde pop, and posedge process mechanism ensures error free synchronization between the lane data
/// and the corresponding deskew logic.
/// From this method, the sync sequence capture task is called. Also it counts the number codegroups that are
/// received in between 2 status control symbols and in between 2 clock compensation sequences.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::srio_data_ins_gen();

  forever begin //{

    @(negedge srio_if.sim_clk);

	//if (srio_data_ins_q[0].size()>0 && ~bfm_or_mon && ~mon_type)
	//begin //{
	//  for (int ii=0; ii<srio_data_ins_q[0].size(); ii++)
	//    $display($time, " srio_data_ins_q[0][%0d].character is %0h", ii, srio_data_ins_q[0][ii].character);
	//end //}

    for(int sdi_var=0; sdi_var < rx_dh_env_config.num_of_lanes; sdi_var++)
    begin //{

      if (srio_data_ins_q.exists(sdi_var) && srio_data_ins_q[sdi_var].size()>0)
      begin //{
        srio_data_ins[sdi_var] = new srio_data_ins_q[sdi_var].pop_front();
        srio_data_ins_valid[sdi_var] = 1;

	if (~bfm_or_mon)
	begin //{

	  if (rx_dh_trans.num_cg_bet_status_cs_cnt > 0 && srio_data_ins[sdi_var].character == SRIO_SC && srio_data_ins[sdi_var].cntl && rx_dh_common_mon_trans.port_initialized[~mon_type] && ~rx_dh_common_mon_trans.port_initialized[mon_type] && rx_dh_env_config.srio_mode != SRIO_GEN30)
	  begin //{
	    rx_dh_trans.num_cg_bet_status_cs_cnt = 0;
	  end //}
	  else if (rx_dh_trans.num_cg_bet_status_cs_cnt > 0 && srio_data_ins[sdi_var].brc3_cntl_cw_type == CSB && ~srio_data_ins[sdi_var].brc3_type && rx_dh_common_mon_trans.port_initialized[~mon_type] && ~rx_dh_common_mon_trans.port_initialized[mon_type] && rx_dh_env_config.srio_mode == SRIO_GEN30)
	  begin //{
	    rx_dh_trans.num_cg_bet_status_cs_cnt = 0;
	  end //}
	  else if (rx_dh_trans.status_cs_cnt_check_started && sdi_var == active_lane_for_idle && rx_dh_common_mon_trans.port_initialized[~mon_type])
	  begin //{
	    rx_dh_trans.num_cg_bet_status_cs_cnt++;
	  end //}
	  else if (rx_dh_trans.status_cs_cnt_check_started && ~rx_dh_common_mon_trans.port_initialized[~mon_type])
	  begin //{
	    rx_dh_trans.status_cs_cnt_check_started = 0;
	    rx_dh_trans.num_cg_bet_status_cs_cnt = 0;
	  end //}

	  if (rx_dh_env_config.multi_vc_support)
	  begin //{

	    for (int vc_num_var=1; vc_num_var<=8; vc_num_var++)
	    begin //{

	      if (!rx_dh_trans.vc_status_cs_cnt_check_started.exists(vc_num_var))
	        continue;

	      if (rx_dh_trans.num_cg_bet_vc_status_cs_cnt[vc_num_var] > 0 && srio_data_ins[sdi_var].character == SRIO_SC && srio_data_ins[sdi_var].cntl && rx_dh_common_mon_trans.port_initialized[~mon_type] && ~rx_dh_common_mon_trans.port_initialized[mon_type] && rx_dh_env_config.srio_mode != SRIO_GEN30)
	      begin //{
	        rx_dh_trans.num_cg_bet_vc_status_cs_cnt[vc_num_var] = 0;
	      end //}
	      else if (rx_dh_trans.num_cg_bet_vc_status_cs_cnt[vc_num_var] > 0 && srio_data_ins[sdi_var].brc3_cntl_cw_type == CSB && ~srio_data_ins[sdi_var].brc3_type && rx_dh_common_mon_trans.port_initialized[~mon_type] && ~rx_dh_common_mon_trans.port_initialized[mon_type] && rx_dh_env_config.srio_mode == SRIO_GEN30)
	      begin //{
	        rx_dh_trans.num_cg_bet_vc_status_cs_cnt[vc_num_var] = 0;
	      end //}
	      else if (rx_dh_trans.vc_status_cs_cnt_check_started[vc_num_var] && sdi_var == active_lane_for_idle && rx_dh_common_mon_trans.port_initialized[~mon_type])
	      begin //{
	        rx_dh_trans.num_cg_bet_vc_status_cs_cnt[vc_num_var]++;
	      end //}
	      else if (rx_dh_trans.vc_status_cs_cnt_check_started[vc_num_var] && ~rx_dh_common_mon_trans.port_initialized[~mon_type])
	      begin //{
	        rx_dh_trans.vc_status_cs_cnt_check_started[vc_num_var] = 0;
	        rx_dh_trans.num_cg_bet_vc_status_cs_cnt[vc_num_var] = 0;
	      end //}

	    end //}

	  end //}
	end //}
	  temp_sdi_var = sdi_var;


	if (rx_dh_env_config.srio_mode != SRIO_GEN30)
	  clk_comp_seq_rate_check();

	if (rx_dh_env_config.srio_mode != SRIO_GEN30)
	  sync_sequence_capture();

	//if (~bfm_or_mon && ~mon_type)
	//$display($time, " Popped from queue. srio_data_ins[%0d].character is %0h", sdi_var, srio_data_ins[sdi_var].character);
      end //}
      else
      begin //{
        srio_data_ins_valid[sdi_var] = 0;
	//if (~bfm_or_mon && ~mon_type)
	//$display($time, " Not Popped from queue");
      end //}

    end //}

  end //}

endtask : srio_data_ins_gen



/////////////////////////////////////////////////////////////////////////////////////////
/// Name : srio_idle_detection
/// Description : Idle detection happens during SEEK state where atleast one primary lane
/// sync has to be achieved. The idle_detection logic selects either lane 0, 1 or 2
/// based on which one achieves the sync first and then uses it as active_lane_for_idle.
/// Then, the logic counts the number of K and M characters on the active_lane_for_idle.
/// When the number of K characters count reaches 4, then based on the K count value and
/// M count value IDLE sequence is selected. If K count is higher, then IDLE1 is selected
/// else, IDLE2 is selected. The selected idle sequence is updated in both rx_dh_trans and
/// rx_dh_common_mon_trans.
///////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::srio_idle_detection();

  forever begin //{

    while (~rx_dh_trans.idle_detected)
    begin //{

      idle_k_cnt = 0;
      idle_m_cnt = 0;

      wait (rx_dh_trans.current_init_state == SEEK);

      while (~active_lane_found)
      begin //{

        @(posedge srio_if.sim_clk);

	if (rx_dh_trans.lane_sync.exists(0) && srio_data_ins_valid[0] == 1)
	begin //{

	  if (srio_data_ins[0].character == SRIO_K && srio_data_ins[0].cntl == 1)
	    idle_k_cnt++;
	  else if (srio_data_ins[0].character == SRIO_M && srio_data_ins[0].cntl == 1)
	    idle_m_cnt++;

	  if (idle_m_cnt>0 || idle_k_cnt>0)
	  begin //{
	    active_lane_found = 1;
	    active_lane_for_idle = 0;
	    break;
	  end //}

	end //}

	if (rx_dh_trans.lane_sync.exists(1) && srio_data_ins_valid[1] == 1)
	begin //{

	  if (srio_data_ins[1].character == SRIO_K && srio_data_ins[1].cntl == 1)
	    idle_k_cnt++;
	  else if (srio_data_ins[1].character == SRIO_M && srio_data_ins[1].cntl == 1)
	    idle_m_cnt++;

	  if (idle_m_cnt>0 || idle_k_cnt>0)
	  begin //{
	    active_lane_found = 1;
	    active_lane_for_idle = 1;
	    break;
	  end //}

	end //}

	if (rx_dh_trans.lane_sync.exists(2) && srio_data_ins_valid[2] == 1)
	begin //{

	  if (srio_data_ins[2].character == SRIO_K && srio_data_ins[2].cntl == 1)
	    idle_k_cnt++;
	  else if (srio_data_ins[2].character == SRIO_M && srio_data_ins[2].cntl == 1)
	    idle_m_cnt++;

	  if (idle_m_cnt>0 || idle_k_cnt>0)
	  begin //{
	    active_lane_found = 1;
	    active_lane_for_idle = 2;
	    break;
	  end //}

	end //}

      end //}

      active_lane_found = 0;

	//$display($time, " 1. active_lane_for_idle is %0d", active_lane_for_idle);

      
      //`uvm_info("SRIO_PL_RX_DATA_HANDLER : K_M_CNT TEST", $sformatf("1. K count is %0d, M count is %0d", idle_k_cnt, idle_m_cnt), UVM_LOW)

      while (~rx_dh_trans.idle_detected)
      begin //{

      	@(posedge srio_if.sim_clk);

	if (srio_data_ins_valid[active_lane_for_idle] == 0)
	  continue;

	if (srio_data_ins[active_lane_for_idle].character == SRIO_K && srio_data_ins[active_lane_for_idle].cntl == 1)
	  idle_k_cnt++;
	else if (srio_data_ins[active_lane_for_idle].character == SRIO_M && srio_data_ins[active_lane_for_idle].cntl == 1)
	  idle_m_cnt++;

      //`uvm_info("SRIO_PL_RX_DATA_HANDLER : K_M_CNT TEST", $sformatf("2. K count is %0d, M count is %0d. srio_data_ins[%0d].character is %0h", idle_k_cnt, idle_m_cnt, active_lane_for_idle, srio_data_ins[active_lane_for_idle].character), UVM_LOW)
	if (idle_k_cnt == rx_dh_config.k_cnt_for_idle_detection || idle_m_cnt == rx_dh_config.m_cnt_for_idle_detection)
	begin //{

	  // When the idle_k_cnt reaches 4 or if idle_m_cnt is 255, if the idle_k_cnt is
	  // greater than idle_m_cnt, then IDLE1 is detected, else IDLE2 is detected.

	  rx_dh_trans.idle_detected = 1;

	  if (bfm_or_mon)
	    rx_dh_env_config.idle_detected = 1;

	  if (~bfm_or_mon)
	    rx_dh_common_mon_trans.idle_selection_done[mon_type] = 1;	// IDLE1 selected.

	  if (idle_k_cnt > idle_m_cnt)
	  begin //{
	    rx_dh_trans.idle_selected = 0;	// IDLE1 selected.

	    if (bfm_or_mon)
	      rx_dh_env_config.idle_selected = 0;

	    if (~bfm_or_mon)
	      rx_dh_common_mon_trans.selected_idle[mon_type] = 0;
	  end //}
	  else
	  begin //{
	    rx_dh_trans.idle_selected = 1;	// IDLE2 selected.

	    if (bfm_or_mon)
	      rx_dh_env_config.idle_selected = 1;

	    if (~bfm_or_mon && rx_dh_env_config.srio_baud_rate != SRIO_625)
	    begin //{

  	      if ((mon_type && rx_dh_env_config.srio_tx_mon_if == BFM) || (~mon_type && rx_dh_env_config.srio_rx_mon_if == BFM))
	      begin //{

	    	if (rx_dh_config.idle_sel == 0)
	    	begin //{

	    	  `uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE2_SEQUENCE_SUPPORT_CHECK", $sformatf(" Spec reference 6.6.8. IDLE2 sequence is not suppported but IDLE2 sequence is transmitted."))

	    	end //}

	      end //}
  	      else if ((mon_type && rx_dh_env_config.srio_tx_mon_if == DUT) || (~mon_type && rx_dh_env_config.srio_rx_mon_if == DUT))
	      begin //{

		if (mon_type && rx_dh_env_config.srio_tx_mon_if == DUT)
		begin //{
    		  register_update_method("Error_and_Status_CSR", "Idle_Sequence2_Support", 64, "rx_dh_reg_model_tx", reqd_field_name["Idle_Sequence2_Support"]);
    		  dut_idle2_spt = reqd_field_name["Idle_Sequence2_Support"].get();
      		  //dut_idle2_spt = rx_dh_env_config.srio_reg_model_tx.Port_0_Error_and_Status_CSR.Idle_Sequence2_Support.get();
    		  register_update_method("Error_and_Status_CSR", "Idle_Sequence2_Enable", 64, "rx_dh_reg_model_tx", reqd_field_name["Idle_Sequence2_Enable"]);
    		  dut_idle2_en = reqd_field_name["Idle_Sequence2_Enable"].get();
      		  //dut_idle2_en = rx_dh_env_config.srio_reg_model_tx.Port_0_Error_and_Status_CSR.Idle_Sequence2_Enable.get();
		end //}
		else if (~mon_type && rx_dh_env_config.srio_rx_mon_if == DUT)
		begin //{
    		  register_update_method("Error_and_Status_CSR", "Idle_Sequence2_Support", 64, "rx_dh_reg_model_rx", reqd_field_name["Idle_Sequence2_Support"]);
    		  dut_idle2_spt = reqd_field_name["Idle_Sequence2_Support"].get();
      		  //dut_idle2_spt = rx_dh_env_config.srio_reg_model_rx.Port_0_Error_and_Status_CSR.Idle_Sequence2_Support.get();
    		  register_update_method("Error_and_Status_CSR", "Idle_Sequence2_Enable", 64, "rx_dh_reg_model_rx", reqd_field_name["Idle_Sequence2_Enable"]);
    		  dut_idle2_en = reqd_field_name["Idle_Sequence2_Enable"].get();
      		  //dut_idle2_en = rx_dh_env_config.srio_reg_model_rx.Port_0_Error_and_Status_CSR.Idle_Sequence2_Enable.get();
		end //}

	    	if (~dut_idle2_spt || ~dut_idle2_en)
	    	begin //{

	    	  `uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE2_SEQUENCE_SUPPORT_CHECK", $sformatf(" Spec reference 6.6.8. IDLE2 sequence is not suppported but IDLE2 sequence is transmitted."))

	    	end //}


	      end //}

	    end //}

	    if (~bfm_or_mon)
	      rx_dh_common_mon_trans.selected_idle[mon_type] = 1;

	  end //}

	end //}

      end //}

      if (rx_dh_trans.idle_selected)
        `uvm_info("SRIO_PL_RX_DATA_HANDLER : IDLE_DETECTION", $sformatf("IDLE sequence detected is IDLE2"), UVM_LOW)
      else
        `uvm_info("SRIO_PL_RX_DATA_HANDLER : IDLE_DETECTION", $sformatf("IDLE sequence detected is IDLE1"), UVM_LOW)

      wait (rx_dh_trans.idle_detected == 0); // cleared in init sm silent state

    end //}

  end //}

endtask : srio_idle_detection



/////////////////////////////////////////////////////////////////////////////////////////
/// Name : x2_lane_deskew
/// Description : 2X Deskew logic :
///	1. A character is pushed into the particular lane position of the x2_lane_align_q.
///	2. Once a single entry is pushed into any position of the x2_lane_align_q, then
///	   the logic waits till 7 characters, before which it expects the other position
///	   of the x2_lane_align_q to also be filled with an entry.
///	3. If the point '2' is satisfied, then at all the posedge of core clock,
///	   the data is continuously pushed into the x2_lane_align_q's appropriate
///	   position based on the srio_data_ins_valid bit. This completes the x2 deskew
///	   logic, and temp_2x_alignment_done is set.
///	4. If the point '2' is not satisfied, then the x2_lane_align_q is cleared completely,
///	   and the logic restarts from step '1'.
/////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::x2_lane_deskew();

  forever begin //{

    @(posedge srio_if.sim_clk);
    
    if (prev_temp_2x_alignment_done && ~rx_dh_trans.temp_2x_alignment_done)
    begin //{
      for (int x2_lane_q_clr=0; x2_lane_q_clr<2; x2_lane_q_clr++)
        x2_lane_align_q[x2_lane_q_clr].delete();
    end //}

    // TODO: Check for 2x mode support before executing this block.
    if (~rx_dh_trans.temp_2x_alignment_done && rx_dh_trans.lane_sync.num()>1)
    begin //{

      for(int x2_sync_var=0; x2_sync_var<2; x2_sync_var++)
      begin //{

	if (rx_dh_trans.lane_sync.exists(x2_sync_var) && rx_dh_trans.lane_sync[x2_sync_var] == 1)
	begin //{

    	  if (srio_data_ins_valid[x2_sync_var] == 0)
    	    continue;

	  // Skip character has to be inserted or removed as a column only. Hence, it is not
	  // required to discard the skip character before destriping.
	  //if (srio_data_ins[x2_sync_var].character == SRIO_R && srio_data_ins[x2_sync_var].cntl)
	  //  continue;

	  if (rx_dh_env_config.srio_mode != SRIO_GEN30)
	  begin //{

	    if (srio_data_ins[x2_sync_var].character == SRIO_A && srio_data_ins[x2_sync_var].cntl)
	    begin //{
	      x2_lane_align_q[x2_sync_var].push_back(srio_data_ins[x2_sync_var]);
	      inc_x2_cnt = 1;
	    end //}
	    else if (x2_cg_cnt>0 && x2_lane_align_q[x2_sync_var].size()>0)
	    begin //{
	      x2_lane_align_q[x2_sync_var].push_back(srio_data_ins[x2_sync_var]);
	      inc_x2_cnt = 1;
	    end //}

	  end //}
	  else
	  begin //{

	    if (srio_data_ins[x2_sync_var].brc3_cntl_cw_type == STATUS_CNTL && ~srio_data_ins[x2_sync_var].brc3_type)
	    begin //{
	      x2_lane_align_q[x2_sync_var].push_back(srio_data_ins[x2_sync_var]);
	      inc_x2_cnt = 1;
	    end //}
	    else if (x2_cg_cnt>0 && x2_lane_align_q[x2_sync_var].size()>0)
	    begin //{
	      x2_lane_align_q[x2_sync_var].push_back(srio_data_ins[x2_sync_var]);
	      inc_x2_cnt = 1;
	    end //}

	  end //}

	end //}

      end //}

      if (inc_x2_cnt)
      begin //{
        x2_cg_cnt++;
        inc_x2_cnt = 0;
      end //}

      if (x2_cg_cnt<=8)
      begin //{

	for (int x2_lane_q_chk=0; x2_lane_q_chk<2; x2_lane_q_chk++)
	begin //{

	  if (!x2_lane_align_q.exists(x2_lane_q_chk))
	  begin //{
	    clear_x2_lane_queues = 1;
	    break;
	  end //}
	  else if (x2_lane_align_q[x2_lane_q_chk].size()==0)
	  begin //{
	    clear_x2_lane_queues = 1;
	    break;
	  end //}

	end //}

	if (clear_x2_lane_queues && x2_cg_cnt==8)
	begin //{
	  clear_x2_lane_queues = 0;
	  x2_cg_cnt = 0;
	  for (int x2_lane_q_chk=0; x2_lane_q_chk<2; x2_lane_q_chk++)
	    x2_lane_align_q[x2_lane_q_chk].delete();
	end //}
	else if (clear_x2_lane_queues && x2_cg_cnt<8)
	  clear_x2_lane_queues = 0;
	else // clear_x2_lane_queues is 0 which means all the required queues contain data.
	begin //{
	  rx_dh_trans.temp_2x_alignment_done = 1;
	  x2_cg_cnt = 0;
	end //}

      end //}

    end //}
    else if (rx_dh_trans.temp_2x_alignment_done) // rx_dh_trans.temp_2x_alignment_done is cleared in 2x align sm
    begin //{

      for(int x2_sync_var=0; x2_sync_var<2; x2_sync_var++)
      begin //{

    	if (srio_data_ins_valid[x2_sync_var] == 0)
    	  continue;

      	//if (srio_data_ins[x2_sync_var].character == SRIO_R && srio_data_ins[x2_sync_var].cntl)
      	//  continue;

	x2_lane_align_q[x2_sync_var].push_back(srio_data_ins[x2_sync_var]);

      end //}

    end //}

    prev_temp_2x_alignment_done = rx_dh_trans.temp_2x_alignment_done;

  end //}

endtask : x2_lane_deskew




/////////////////////////////////////////////////////////////////////////////////////////
/// Name : nx_lane_deskew
/// Description : NX Deskew logic :
///	1. A character is pushed into the particular lane position of the nx_lane_align_q.
///	2. Once a single entry is pushed into any position of the nx_lane_align_q, then
///	   the logic waits till 7 characters, before which it expects the other position
///	   of the nx_lane_align_q to also be filled with an entry.
///	3. If the point '2' is satisfied, then at all the posedge of core clock,
///	   the data is continuously pushed into the nx_lane_align_q's appropriate
///	   position based on the srio_data_ins_valid bit. This completes the nx deskew
///	   logic, and temp_nx_alignment_done is set.
///	4. If the point '2' is not satisfied, then the nx_lane_align_q is cleared completely,
///	   and the logic restarts from step '1'.
/////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::nx_lane_deskew();

  forever begin //{

    @(posedge srio_if.sim_clk);

    if (rx_dh_env_config.num_of_lanes < 4)
      return;

    if (prev_temp_nx_alignment_done && ~rx_dh_trans.temp_nx_alignment_done)
    begin //{
      for (int nx_lane_q_clr=0; nx_lane_q_clr<rx_dh_env_config.num_of_lanes; nx_lane_q_clr++)
        nx_lane_align_q[nx_lane_q_clr].delete();
    end //}

    // TODO: Check for nx mode support before executing this block.
    if (~rx_dh_trans.temp_nx_alignment_done && rx_dh_trans.lane_sync.num()>1)
    begin //{

      for(int nx_sync_var=0; nx_sync_var<rx_dh_env_config.num_of_lanes; nx_sync_var++)
      begin //{

	if (rx_dh_trans.lane_sync.exists(nx_sync_var) && rx_dh_trans.lane_sync[nx_sync_var] == 1)
	begin //{

    	  if (srio_data_ins_valid[nx_sync_var] == 0)
    	    continue;

	  //if (srio_data_ins[nx_sync_var].character == SRIO_R && srio_data_ins[nx_sync_var].cntl)
	  //  continue;

	  if (rx_dh_env_config.srio_mode != SRIO_GEN30)
	  begin //{

	    if (srio_data_ins[nx_sync_var].character == SRIO_A && srio_data_ins[nx_sync_var].cntl)
	    begin //{
	      nx_lane_align_q[nx_sync_var].push_back(srio_data_ins[nx_sync_var]);
	      inc_nx_cnt = 1;
	    end //}
	    else if (nx_cg_cnt>0 && nx_lane_align_q[nx_sync_var].size()>0)
	    begin //{
	      nx_lane_align_q[nx_sync_var].push_back(srio_data_ins[nx_sync_var]);
	      inc_nx_cnt = 1;
	    end //}

	  end //}
	  else
	  begin //{	

	    if (srio_data_ins[nx_sync_var].brc3_cntl_cw_type == STATUS_CNTL && ~srio_data_ins[nx_sync_var].brc3_type)
	    begin //{
	      nx_lane_align_q[nx_sync_var].push_back(srio_data_ins[nx_sync_var]);
	      inc_nx_cnt = 1;
	    end //}
	    else if (nx_cg_cnt>0 && nx_lane_align_q[nx_sync_var].size()>0)
	    begin //{
	      nx_lane_align_q[nx_sync_var].push_back(srio_data_ins[nx_sync_var]);
	      inc_nx_cnt = 1;
	    end //}

	  end //}

	end //}

      end //}

      if (inc_nx_cnt)
      begin //{
        nx_cg_cnt++;
        inc_nx_cnt = 0;
      end //}

      if (nx_cg_cnt<=8)
      begin //{

	for (int nx_lane_q_chk=0; nx_lane_q_chk<rx_dh_env_config.num_of_lanes; nx_lane_q_chk++)
	begin //{

	  if (!nx_lane_align_q.exists(nx_lane_q_chk))
	  begin //{
	    clear_nx_lane_queues = 1;
	    break;
	  end //}
	  else if (nx_lane_align_q[nx_lane_q_chk].size()==0)
	  begin //{
	    clear_nx_lane_queues = 1;
	    break;
	  end //}

	end //}

	if (clear_nx_lane_queues && nx_cg_cnt==8)
	begin //{
	  clear_nx_lane_queues = 0;
	  nx_cg_cnt = 0;
	  for (int nx_lane_q_chk=0; nx_lane_q_chk<rx_dh_env_config.num_of_lanes; nx_lane_q_chk++)
	    nx_lane_align_q[nx_lane_q_chk].delete();
	end //}
	else if (clear_nx_lane_queues && nx_cg_cnt<8)
	  clear_nx_lane_queues = 0;
	else // clear_nx_lane_queues is 0 which means all the required queues contain data.
	begin //{

	  nx_cg_cnt = 0;
	  rx_dh_trans.temp_nx_alignment_done = 1;

	end //}

      end //}

    end //}
    else if (rx_dh_trans.temp_nx_alignment_done) // rx_dh_trans.temp_nx_alignment_done is cleared in nx align sm
    begin //{

      for (int nx_lane_q_chk=0; nx_lane_q_chk<rx_dh_env_config.num_of_lanes; nx_lane_q_chk++)
      begin //{

    	if (srio_data_ins_valid[nx_lane_q_chk] == 0)
    	  continue;

      	//if (srio_data_ins[nx_lane_q_chk].character == SRIO_R && srio_data_ins[nx_lane_q_chk].cntl)
      	//  continue;

	nx_lane_align_q[nx_lane_q_chk].push_back(srio_data_ins[nx_lane_q_chk]);

      end //}

    end //}

    prev_temp_nx_alignment_done = rx_dh_trans.temp_nx_alignment_done;

  end //}

endtask : nx_lane_deskew



/////////////////////////////////////////////////////////////////////////////////////////
/// Name : x2_destriping
/// Description : 2X Destriping logic:
///	1. When the queues available in both the locations of the x2_lane_align_q
///	   contains data, then it means deskew logic is completed.
///	2. Condition to satisfy point '1' is checked, and if it is true, then the
///	   x2_lane_align_q is popped and x2_align_data is created.
///	3. The destriping logic happens on the posedge of core clock, and the x2_align_data
///	   is processed by the 2x align state machine at the next negedge of core clock. This
///	   way, synchronization is achieved between the destriping logic and state machine.
///	4. Once the x2_align_data is formed, the logic waits for port_initialization to complete
///	   and after that, if the port was initialized in 2x mode, the srio_trans is formed, based
///	   on which the link initialization is set.
/////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::x2_destriping();

  bit x2_queue_empty;

  forever begin //{

    @(posedge srio_if.sim_clk);

    for (int x2_data_loc=0; x2_data_loc<2; x2_data_loc++)
    begin //{
      if (!x2_lane_align_q.exists(x2_data_loc))
      begin //{
	x2_queue_empty = 1;
	break;
      end //}
      else if (x2_lane_align_q[x2_data_loc].size()==0)
      begin //{
	x2_queue_empty = 1;
	break;
      end //}
    end //}

    if (x2_queue_empty)
    begin //{
      x2_queue_empty = 0;
      rx_dh_trans.x2_align_data_valid = 0;
    end //}
    else
    begin //{

      for (int x2_data_loc=0; x2_data_loc<2; x2_data_loc++)
      begin //{

        x2_srio_data = x2_lane_align_q[x2_data_loc].pop_front();

	if (rx_dh_env_config.srio_mode != SRIO_GEN30)
	begin //{

          x2_align_data.character[x2_data_loc] = x2_srio_data.character;
          x2_align_data.cntl[x2_data_loc] = x2_srio_data.cntl;
          x2_align_data.idle2_cs[x2_data_loc] = x2_srio_data.idle2_cs;

	  // If Idle2 cs marker/cs field is truncated, and the scrambled data
	  // matches with any of the expected cs marker/cs field data, then it
	  // wouldn't be descrambled which might lead to data corruption. Thus
	  // replacing the character with descrambled cs field data below to
	  // avoid error in such scenarios.
	  if (x2_data_loc == 1)
	  begin //{
	    if (x2_align_data.idle2_cs[x2_data_loc-1] != x2_align_data.idle2_cs[x2_data_loc])
	    begin //{
              x2_align_data.character[x2_data_loc] = x2_srio_data.idle2_cs_field_descrambled_data;
	    end //}
	  end //}

	end //}
	else
	begin //{

          x2_align_data.brc3_cntl_cw_type[x2_data_loc] = x2_srio_data.brc3_cntl_cw_type;
          x2_align_data.brc3_type[x2_data_loc] = x2_srio_data.brc3_type;
          x2_align_data.brc3_cw[x2_data_loc] = x2_srio_data.brc3_cw;
          x2_align_data.brc3_cc_type[x2_data_loc] = x2_srio_data.brc3_cc_type;

	  // gen3_align_data_ins will be same as x2_align_data. This is created to have a single
	  // class for forming the srio_trans irrespective of the mode it initialized. Hence,
	  // the trade-off of having a redundant instance can be tolerated. Since, the form_gen3_srio_trans
	  // method is done on a single lane data, the same method can be used for any init modes.
          gen3_align_data_ins.brc3_cntl_cw_type[x2_data_loc] = x2_srio_data.brc3_cntl_cw_type;
          gen3_align_data_ins.brc3_type[x2_data_loc] = x2_srio_data.brc3_type;
          gen3_align_data_ins.brc3_cw[x2_data_loc] = x2_srio_data.brc3_cw;
          gen3_align_data_ins.brc3_cc_type[x2_data_loc] = x2_srio_data.brc3_cc_type;

	end //}

	rx_dh_trans.x2_align_data_valid = 1;

        //`uvm_info("SRIO_PL_RX_DATA_HANDLER : 2X_ALIGN_DATA", $sformatf(" x2_align_data.character[%0d] is %0h x2_align_data.cntl[%0d] is %0h", x2_data_loc, x2_align_data.character[x2_data_loc], x2_data_loc, x2_align_data.cntl[x2_data_loc]), UVM_LOW)

      end //}

      if (rx_dh_trans.port_initialized && (rx_dh_trans.current_init_state == X2_MODE || (rx_dh_trans.current_init_state == ASYM_MODE && rx_dh_trans.rcv_width == "2x")))
      begin //{

        if ((((x2_align_data.character[0] == SRIO_SC || x2_align_data.character[0] == SRIO_PD) && x2_align_data.cntl[0]) || cntl_symbol_open || packet_open) && rx_dh_env_config.srio_mode != SRIO_GEN30)
        begin //{
          if(x1_delimiter_detected)
           begin//{
             local_cntl_symbol_open=cntl_symbol_open;
             cntl_symbol_bytes++;
             if (~rx_dh_trans.idle_selected)
              begin//{
               if(cntl_symbol_bytes==4)
                begin//{
                 cntl_symbol_bytes=0;
          	 cntl_symbol_open = ~cntl_symbol_open;
                end//}
              end//}
             else
              begin//{
               if(cntl_symbol_bytes==8)
                begin//{
                 cntl_symbol_bytes=0;
          	 cntl_symbol_open = ~cntl_symbol_open;
               end//}
              end//}
           end//}

	  if (((x2_align_data.character[0] == SRIO_SC && x2_align_data.character[1] == SRIO_SC) || (x2_align_data.character[0] == SRIO_PD && x2_align_data.character[1] == SRIO_PD)) && x2_align_data.cntl[0] && x2_align_data.cntl[1] /*&& ~rx_dh_trans.link_initialized*/)
	  begin //{
	    x1_delimiter_detected = 1;
            if(rx_dh_trans.idle_selected && !cs_st_fg)
             begin//{
	    cntl_symbol_open = ~cntl_symbol_open;
             cntl_symbol_bytes=1;
             end//}
            else if(~rx_dh_trans.idle_selected)
             begin//{
	      cntl_symbol_open = ~cntl_symbol_open;
              cntl_symbol_bytes=1;
             end//}
             if(rx_dh_trans.idle_selected)
              cs_st_fg=~cs_st_fg;
	  end //}
	  else if (((x2_align_data.character[0] == SRIO_SC && x2_align_data.character[1] != SRIO_SC) || (x2_align_data.character[0] == SRIO_PD && x2_align_data.character[1] != SRIO_PD)) && x2_align_data.cntl[0] && ~x2_align_data.cntl[1])
	  begin //{
	    x1_delimiter_detected = 0;
	  end //}
	  
	  if (~x1_delimiter_detected)
            form_2x_srio_trans();
	  else
	  begin //{
	    rx_dh_trans.num_cg_bet_status_cs_cnt = 0;
	    continue;
	  end //}

          if (rx_dh_trans.port_initialized && (prev_cntl_symbol_open && ~cntl_symbol_open))
	  begin //{
	    if (bfm_or_mon && ~rx_dh_trans.link_initialized)
              set_link_initialization();
	    else if (~bfm_or_mon && (~rx_dh_common_mon_trans.link_initialized[mon_type] || ~rx_dh_common_mon_trans.link_initialized[~mon_type]))
              set_link_initialization();
	  end //}

          prev_cntl_symbol_open = cntl_symbol_open;

        end //}
	else if (~cntl_symbol_open && ~packet_open && ~bfm_or_mon && rx_dh_env_config.srio_mode != SRIO_GEN30)
	begin //{

	  if (rx_dh_common_mon_trans.timestamp_seq_started[mon_type] && ~rx_dh_common_mon_trans.timestamp_seq_completed[mon_type])
	  begin //{

	    -> rx_dh_trans.rcvd_interrupted_timestamp_cs;

      	    `uvm_error("SRIO_PL_PROTOCOL_CHECKER : INCOMPLETE_TIMESTAMP_SEQ_CHECK", $sformatf(" Spec reference 6.5.3.5. Timestamp sequence shall not be truncated by IDLE sequence. No. of timestamp control symbols received when it is truncated is %0d.", timestamp_cs_cnt))
            rx_dh_common_mon_trans.timestamp_seq_started[mon_type] = 0;
            rx_dh_common_mon_trans.timestamp_seq_completed[mon_type] = 1;
            timestamp_cs_cnt = 0;

	  end //}

	end //}

        if (rx_dh_env_config.srio_mode == SRIO_GEN30)
        begin //{

	  for (int gen3_ln_num = 0; gen3_ln_num < 2; gen3_ln_num++)
	  begin //{

            if (((gen3_align_data_ins.brc3_cntl_cw_type[gen3_ln_num] == CSB || gen3_align_data_ins.brc3_cntl_cw_type[gen3_ln_num] == CSE || gen3_align_data_ins.brc3_cntl_cw_type[gen3_ln_num] == CSEB) && ~gen3_align_data_ins.brc3_type[gen3_ln_num]) || cntl_symbol_open || packet_open)
              form_gen3_srio_trans(gen3_ln_num);
	    else
	    begin //{

	      if (~bfm_or_mon)
	      begin //{

	        rx_dh_common_mon_trans.xmting_idle[~mon_type] = 1;

	  	if (rx_dh_common_mon_trans.timestamp_seq_started[mon_type] && ~rx_dh_common_mon_trans.timestamp_seq_completed[mon_type])
	  	begin //{

	    	  -> rx_dh_trans.rcvd_interrupted_timestamp_cs;

      	  	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : INCOMPLETE_TIMESTAMP_SEQ_CHECK", $sformatf(" Spec reference 6.5.3.5. Timestamp sequence shall not be truncated by IDLE sequence. No. of timestamp control symbols received when it is truncated is %0d.", timestamp_cs_cnt))
          	  rx_dh_common_mon_trans.timestamp_seq_started[mon_type] = 0;
          	  rx_dh_common_mon_trans.timestamp_seq_completed[mon_type] = 1;
          	  timestamp_cs_cnt = 0;

	  	end //}

	      end //}

	    end //}

            if (rx_dh_trans.port_initialized && (prev_cntl_symbol_open && ~cntl_symbol_open))
	    begin //{
	      if (bfm_or_mon && ~rx_dh_trans.link_initialized)
                set_link_initialization();
	      else if (~bfm_or_mon && (~rx_dh_common_mon_trans.link_initialized[mon_type] || ~rx_dh_common_mon_trans.link_initialized[~mon_type]))
                set_link_initialization();
	    end //}

            prev_cntl_symbol_open = cntl_symbol_open;

	  end //}

        end //}

      end //}
      else if (~rx_dh_trans.port_initialized)
      begin //{
	if (~bfm_or_mon)
	  rx_dh_common_mon_trans.xmting_idle[mon_type] = 1;
      end //}

    end //}

  end //}

endtask : x2_destriping



/////////////////////////////////////////////////////////////////////////////////////////
/// Name : nx_destriping
/// Description : NX Destriping logic:
///	1. When the queues available in both the locations of the nx_lane_align_q
///	   contains data, then it means deskew logic is completed.
///	2. Condition to satisfy point '1' is checked, and if it is true, then the
///	   nx_lane_align_q is popped and nx_align_data is created.
///	3. The destriping logic happens on the posedge of core clock, and the nx_align_data
///	   is processed by the nx align state machine at the next negedge of core clock. This
///	   way, synchronization is achieved between the destriping logic and state machine.
///	4. Once the nx_align_data is formed, the logic waits for port_initialization to complete
///	   and after that, if the port was initialized in nx mode, the srio_trans is formed, based
///	   on which the link initialization is set.
/////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::nx_destriping();

  bit nx_queue_empty;

  forever begin //{

    @(posedge srio_if.sim_clk);

    if (rx_dh_env_config.num_of_lanes < 4)
      return;

    for (int nx_data_loc=0; nx_data_loc<rx_dh_env_config.num_of_lanes; nx_data_loc++)
    begin //{
      if (!nx_lane_align_q.exists(nx_data_loc))
      begin //{
	nx_queue_empty = 1;
	break;
      end //}
      else if (nx_lane_align_q[nx_data_loc].size()==0)
      begin //{
	nx_queue_empty = 1;
	break;
      end //}
    end //}

    if (nx_queue_empty)
    begin //{
      nx_queue_empty = 0;
      rx_dh_trans.nx_align_data_valid = 0;
    end //}
    else
    begin //{

      for (int nx_data_loc=0; nx_data_loc<rx_dh_env_config.num_of_lanes; nx_data_loc++)
      begin //{

        nx_srio_data = nx_lane_align_q[nx_data_loc].pop_front();

	if (rx_dh_env_config.srio_mode != SRIO_GEN30)
	begin //{

          nx_align_data.character[nx_data_loc] = nx_srio_data.character;
          nx_align_data.cntl[nx_data_loc] = nx_srio_data.cntl;

          nx_align_data.idle2_cs[nx_data_loc] = nx_srio_data.idle2_cs;
          nx_align_data.idle2_cs_field_descrambled_data[nx_data_loc] = nx_srio_data.idle2_cs_field_descrambled_data;

	end //}
	else
	begin //{

          nx_align_data.brc3_cntl_cw_type[nx_data_loc] = nx_srio_data.brc3_cntl_cw_type;
          nx_align_data.brc3_type[nx_data_loc] = nx_srio_data.brc3_type;
          nx_align_data.brc3_cw[nx_data_loc] = nx_srio_data.brc3_cw;
          nx_align_data.brc3_cc_type[nx_data_loc] = nx_srio_data.brc3_cc_type;

          gen3_align_data_ins.brc3_cntl_cw_type[nx_data_loc] = nx_srio_data.brc3_cntl_cw_type;
          gen3_align_data_ins.brc3_type[nx_data_loc] = nx_srio_data.brc3_type;
          gen3_align_data_ins.brc3_cw[nx_data_loc] = nx_srio_data.brc3_cw;
          gen3_align_data_ins.brc3_cc_type[nx_data_loc] = nx_srio_data.brc3_cc_type;

	end //}

	rx_dh_trans.nx_align_data_valid = 1;

        //`uvm_info("SRIO_PL_RX_DATA_HANDLER : NX_ALIGN_DATA", $sformatf(" nx_align_data.character[%0d] is %0h nx_align_data.cntl[%0d] is %0h", nx_data_loc, nx_align_data.character[nx_data_loc], nx_data_loc, nx_align_data.cntl[nx_data_loc]), UVM_LOW)

      end //}

      // If Idle2 cs marker/cs field is truncated, and the scrambled data
      // matches with any of the expected cs marker/cs field data, then it
      // wouldn't be descrambled which might lead to data corruption. Thus
      // replacing the character with descrambled cs field data below to
      // avoid error in such scenarios. Fix done inside x2_destriping can't
      // be directly used for nx_destriping, since SC/PD could have been
      // started in any lane whose mod 4 is 0. i.e., SC could have been
      // started in lane 4, and idle2_cs could have been set for lane0-3 data.
      // To handle such case, if idle2_cs is different across the lanes,
      // then for all the lanes whose idle2_cs is '1', its 'character' value
      // is replaced with corresponding idle2_cs_field_descrambled_data.
      for (int nx_data_loc_1 = 1; nx_data_loc_1<rx_dh_env_config.num_of_lanes; nx_data_loc_1++)
      begin //{
        if (nx_align_data.idle2_cs[nx_data_loc_1] != nx_align_data.idle2_cs[0])
        begin //{
          for (int temp_nx_data_loc = 0; temp_nx_data_loc<rx_dh_env_config.num_of_lanes; temp_nx_data_loc++)
          begin //{
            if (nx_align_data.idle2_cs[temp_nx_data_loc])
	      nx_align_data.character[temp_nx_data_loc] = nx_align_data.idle2_cs_field_descrambled_data[temp_nx_data_loc];
          end //}
          break;
        end //}
      end //}


      if (rx_dh_trans.port_initialized && (rx_dh_trans.current_init_state == NX_MODE || (rx_dh_trans.current_init_state == ASYM_MODE && (rx_dh_trans.rcv_width == "4x" || rx_dh_trans.rcv_width == "8x" || rx_dh_trans.rcv_width == "16x"))))
      begin //{

	if (rx_dh_env_config.srio_mode != SRIO_GEN30)
	begin //{

          if (((nx_align_data.character[0] == SRIO_SC || nx_align_data.character[0] == SRIO_PD) && nx_align_data.cntl[0]) || cntl_symbol_open || packet_open)
          begin //{

            form_nx_srio_trans(0);

	  	//$display($time, " bfm_or_mon is %0d, mon_type is %0d. Recived CS.", bfm_or_mon, mon_type);

            if (rx_dh_trans.port_initialized && (prev_cntl_symbol_open && ~cntl_symbol_open))
	    begin //{
	  	//$display($time, " bfm_or_mon is %0d, mon_type is %0d. Inside if1.", bfm_or_mon, mon_type);
	      if (bfm_or_mon && ~rx_dh_trans.link_initialized)
                set_link_initialization();
	      else if (~bfm_or_mon && (~rx_dh_common_mon_trans.link_initialized[mon_type] || ~rx_dh_common_mon_trans.link_initialized[~mon_type]))
                set_link_initialization();
	    end //}

            prev_cntl_symbol_open = cntl_symbol_open;

          end //}
	  else if (~cntl_symbol_open && ~packet_open && ~bfm_or_mon)
	  begin //{

	    if (rx_dh_common_mon_trans.timestamp_seq_started[mon_type] && ~rx_dh_common_mon_trans.timestamp_seq_completed[mon_type])
	    begin //{

	      -> rx_dh_trans.rcvd_interrupted_timestamp_cs;

      	      `uvm_error("SRIO_PL_PROTOCOL_CHECKER : INCOMPLETE_TIMESTAMP_SEQ_CHECK", $sformatf(" Spec reference 6.5.3.5. Timestamp sequence shall not be truncated by IDLE sequence. No. of timestamp control symbols received when it is truncated is %0d.", timestamp_cs_cnt))
              rx_dh_common_mon_trans.timestamp_seq_started[mon_type] = 0;
              rx_dh_common_mon_trans.timestamp_seq_completed[mon_type] = 1;
              timestamp_cs_cnt = 0;

	    end //}

	  end //}

	  if (rx_dh_env_config.num_of_lanes > 4)
	  begin //{

            if (((nx_align_data.character[4] == SRIO_SC || nx_align_data.character[4] == SRIO_PD) && nx_align_data.cntl[4]) || cntl_symbol_open || packet_open)
            begin //{

              form_nx_srio_trans(4);

              if (rx_dh_trans.port_initialized && (prev_cntl_symbol_open && ~cntl_symbol_open))
	      begin //{
	        if (bfm_or_mon && ~rx_dh_trans.link_initialized)
                  set_link_initialization();
	        else if (~bfm_or_mon && (~rx_dh_common_mon_trans.link_initialized[mon_type] || ~rx_dh_common_mon_trans.link_initialized[~mon_type]))
                  set_link_initialization();
	      end //}

              prev_cntl_symbol_open = cntl_symbol_open;

            end //}
	    else if (~cntl_symbol_open && ~packet_open && ~bfm_or_mon)
	    begin //{

	      if (rx_dh_common_mon_trans.timestamp_seq_started[mon_type] && ~rx_dh_common_mon_trans.timestamp_seq_completed[mon_type])
	      begin //{

	    	-> rx_dh_trans.rcvd_interrupted_timestamp_cs;

      	        `uvm_error("SRIO_PL_PROTOCOL_CHECKER : INCOMPLETE_TIMESTAMP_SEQ_CHECK", $sformatf(" Spec reference 6.5.3.5. Timestamp sequence shall not be truncated by IDLE sequence. No. of timestamp control symbols received when it is truncated is %0d.", timestamp_cs_cnt))
                rx_dh_common_mon_trans.timestamp_seq_started[mon_type] = 0;
                rx_dh_common_mon_trans.timestamp_seq_completed[mon_type] = 1;
                timestamp_cs_cnt = 0;

	      end //}

	    end //}

          end //}

	  if (rx_dh_env_config.num_of_lanes > 8)
	  begin //{

            if (((nx_align_data.character[8] == SRIO_SC || nx_align_data.character[8] == SRIO_PD) && nx_align_data.cntl[8]) || cntl_symbol_open || packet_open)
            begin //{

              form_nx_srio_trans(8);

              if (rx_dh_trans.port_initialized && (prev_cntl_symbol_open && ~cntl_symbol_open))
	      begin //{
	        if (bfm_or_mon && ~rx_dh_trans.link_initialized)
                  set_link_initialization();
	        else if (~bfm_or_mon && (~rx_dh_common_mon_trans.link_initialized[mon_type] || ~rx_dh_common_mon_trans.link_initialized[~mon_type]))
                  set_link_initialization();
	      end //}

              prev_cntl_symbol_open = cntl_symbol_open;

            end //}
	    else if (~cntl_symbol_open && ~packet_open && ~bfm_or_mon)
	    begin //{

	      if (rx_dh_common_mon_trans.timestamp_seq_started[mon_type] && ~rx_dh_common_mon_trans.timestamp_seq_completed[mon_type])
	      begin //{

	    	 -> rx_dh_trans.rcvd_interrupted_timestamp_cs;

      	        `uvm_error("SRIO_PL_PROTOCOL_CHECKER : INCOMPLETE_TIMESTAMP_SEQ_CHECK", $sformatf(" Spec reference 6.5.3.5. Timestamp sequence shall not be truncated by IDLE sequence. No. of timestamp control symbols received when it is truncated is %0d.", timestamp_cs_cnt))
                rx_dh_common_mon_trans.timestamp_seq_started[mon_type] = 0;
                rx_dh_common_mon_trans.timestamp_seq_completed[mon_type] = 1;
                timestamp_cs_cnt = 0;

	      end //}

	    end //}

            if (((nx_align_data.character[12] == SRIO_SC || nx_align_data.character[12] == SRIO_PD) && nx_align_data.cntl[12]) || cntl_symbol_open || packet_open)
              begin //{

                form_nx_srio_trans(12);

                if (rx_dh_trans.port_initialized && (prev_cntl_symbol_open && ~cntl_symbol_open))
	        begin //{
	          if (bfm_or_mon && ~rx_dh_trans.link_initialized)
                    set_link_initialization();
	          else if (~bfm_or_mon && (~rx_dh_common_mon_trans.link_initialized[mon_type] || ~rx_dh_common_mon_trans.link_initialized[~mon_type]))
                    set_link_initialization();
	        end //}

                prev_cntl_symbol_open = cntl_symbol_open;

              end //}
	      else if (~cntl_symbol_open && ~packet_open && ~bfm_or_mon)
	      begin //{

	        if (rx_dh_common_mon_trans.timestamp_seq_started[mon_type] && ~rx_dh_common_mon_trans.timestamp_seq_completed[mon_type])
	        begin //{

	    	  -> rx_dh_trans.rcvd_interrupted_timestamp_cs;

      	          `uvm_error("SRIO_PL_PROTOCOL_CHECKER : INCOMPLETE_TIMESTAMP_SEQ_CHECK", $sformatf(" Spec reference 6.5.3.5. Timestamp sequence shall not be truncated by IDLE sequence. No. of timestamp control symbols received when it is truncated is %0d.", timestamp_cs_cnt))
                  rx_dh_common_mon_trans.timestamp_seq_started[mon_type] = 0;
                  rx_dh_common_mon_trans.timestamp_seq_completed[mon_type] = 1;
                  timestamp_cs_cnt = 0;

	        end //}

	      end //}

            end //}

	end //}
	else
	begin //{

	  for (int gen3_ln_num = 0; gen3_ln_num < rx_dh_env_config.num_of_lanes; gen3_ln_num++)
	  begin //{

            if (((gen3_align_data_ins.brc3_cntl_cw_type[gen3_ln_num] == CSB || gen3_align_data_ins.brc3_cntl_cw_type[gen3_ln_num] == CSE || gen3_align_data_ins.brc3_cntl_cw_type[gen3_ln_num] == CSEB) && ~gen3_align_data_ins.brc3_type[gen3_ln_num]) || cntl_symbol_open || packet_open)
              form_gen3_srio_trans(gen3_ln_num);
	    else
	    begin //{

	      if (~bfm_or_mon)
	      begin //{

	        rx_dh_common_mon_trans.xmting_idle[~mon_type] = 1;

	        if (rx_dh_common_mon_trans.timestamp_seq_started[mon_type] && ~rx_dh_common_mon_trans.timestamp_seq_completed[mon_type])
	        begin //{

	    	  -> rx_dh_trans.rcvd_interrupted_timestamp_cs;

      	          `uvm_error("SRIO_PL_PROTOCOL_CHECKER : INCOMPLETE_TIMESTAMP_SEQ_CHECK", $sformatf(" Spec reference 6.5.3.5. Timestamp sequence shall not be truncated by IDLE sequence. No. of timestamp control symbols received when it is truncated is %0d.", timestamp_cs_cnt))
                  rx_dh_common_mon_trans.timestamp_seq_started[mon_type] = 0;
                  rx_dh_common_mon_trans.timestamp_seq_completed[mon_type] = 1;
                  timestamp_cs_cnt = 0;

	        end //}

	      end //}

	    end //}

            if (rx_dh_trans.port_initialized && (prev_cntl_symbol_open && ~cntl_symbol_open))
	    begin //{
	      if (bfm_or_mon && ~rx_dh_trans.link_initialized)
                set_link_initialization();
	      else if (~bfm_or_mon && (~rx_dh_common_mon_trans.link_initialized[mon_type] || ~rx_dh_common_mon_trans.link_initialized[~mon_type]))
                set_link_initialization();
	    end //}

            prev_cntl_symbol_open = cntl_symbol_open;

	  end //}

	end //}

      end //}
      else if (~rx_dh_trans.port_initialized)
      begin //{
	if (~bfm_or_mon)
	  rx_dh_common_mon_trans.xmting_idle[mon_type] = 1;
      end //}

    end //}

  end //}

endtask : nx_destriping




//////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : form_2x_srio_trans
/// Description : This task forms the srio_trans from x2_align_data. If SC character is observed on lane0
/// the control symbol context is opened, and the complete CS kind srio_trans is formed from
/// consecutive x2_align_data. If PD character is found on lane0, then packet context is opened
/// along with control symbol context, since the packet delimiter is itself a control symbol.
/// The CS kind srio_trans is formed with the packet delimiter control symbol and after that
/// PACKET kind srio_trans is formed by accumulating the bytestream of srio_trans.
/// The bytestream is initially created for 276 locations which is the maximum packet size, and
/// when the end delimiter is found, the bytestream is restricted to the actual packet size based
/// on the packet_bytes.
/// If an embedded control symbol is found inbetween a packet, then a new CS kind srio_trans is
/// formed before proceeding with the packet again.
//////////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::form_2x_srio_trans();

  if ((x2_align_data.character[0] == SRIO_SC || x2_align_data.character[0] == SRIO_PD) && x2_align_data.cntl[0] && ~cntl_symbol_open)
  begin //{

    cntl_symbol_open = 1;
    cntl_symbol_bytes = cntl_symbol_bytes+2;

    //$display($time, " 1. form_2x_srio_trans cntl_symbol_bytes is %0d", cntl_symbol_bytes);

    srio_trans_cs_ins = new();
    srio_trans_cs_ins.transaction_kind = SRIO_CS;

    if (~rx_dh_trans.idle_selected)
      srio_trans_cs_ins.cstype = CS24;
    else
      srio_trans_cs_ins.cstype = CS48;

    if (x2_align_data.character[0] == SRIO_SC)
      srio_trans_cs_ins.cs_kind = SRIO_DELIM_SC;
    else if (x2_align_data.character[0] == SRIO_PD)
    begin //{

      srio_trans_cs_ins.cs_kind = SRIO_DELIM_PD;

      if (packet_open)
      begin //{

	srio_trans_pkt_ins.bytestream = new[packet_bytes] (rx_dh_trans.bytestream);

	packet_open = 0;
	packet_bytes = 0;

	packet_ended = 1;

	//$cast(cloned_srio_trans_pkt_ins, srio_trans_pkt_ins.clone());
      	//cloned_srio_trans_pkt_ins = new srio_trans_pkt_ins;
	//rx_dh_trans.pl_rx_srio_trans_q.push_back(cloned_srio_trans_pkt_ins);

      end //}
      //else
      //  packet_open = 1;

    end //}

    if (~rx_dh_trans.idle_selected)
    begin //{
      srio_trans_cs_ins.stype0 = x2_align_data.character[1][7:5];
      srio_trans_cs_ins.param0 = x2_align_data.character[1][4:0];
    end //}
    else
    begin //{
      srio_trans_cs_ins.stype0 = x2_align_data.character[1][7:5];
      srio_trans_cs_ins.param0[6:10] = x2_align_data.character[1][4:0];
    end //}

  end //}
  else if (cntl_symbol_open)
  begin //{

    cntl_symbol_bytes = cntl_symbol_bytes+2;

    //$display($time, " 2. form_2x_srio_trans cntl_symbol_bytes is %0d", cntl_symbol_bytes);

    if (~rx_dh_trans.idle_selected)
    begin //{
      srio_trans_cs_ins.param1 = x2_align_data.character[0][7:3];
      srio_trans_cs_ins.stype1 = x2_align_data.character[0][2:0];

      srio_trans_cs_ins.cmd = x2_align_data.character[1][7:5];
      srio_trans_cs_ins.cs_crc5 = x2_align_data.character[1][4:0];
      cntl_symbol_open = 0;
      cntl_symbol_bytes = 0;

      if (srio_trans_cs_ins.stype0 == 4'b0011 && ~bfm_or_mon)
      begin //{

	timestamp_start_flag = srio_trans_cs_ins.param0[7];
	timestamp_end_flag = srio_trans_cs_ins.param0[8];

	if (rx_dh_trans.timestamp_support && ~rx_dh_trans.timestamp_master)
	  timestamp_cs_cnt++;

	if (timestamp_cs_cnt == 1 && ~timestamp_start_flag)
	begin //{
      	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : TIMESTAMP_SEQ_NO_START_FLAG_CHECK", $sformatf(" Spec reference 6.5.3.5. Start flag is not set in the first control symbol of timestamp sequence."))
	end //}
	else if (timestamp_cs_cnt > 1 && timestamp_cs_cnt < 8 && timestamp_start_flag)
	begin //{
      	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : TIMESTAMP_SEQ_START_FLAG_CHECK", $sformatf(" Spec reference 6.5.3.5. Start flag is set in control symbol no. %0d of timestamp sequence.", timestamp_cs_cnt))
	end //}
	else if (timestamp_cs_cnt > 1 && timestamp_cs_cnt < 8 && timestamp_end_flag)
	begin //{
      	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : TIMESTAMP_SEQ_END_FLAG_CHECK", $sformatf(" Spec reference 6.5.3.5. End flag is set in control symbol no. %0d of timestamp sequence.", timestamp_cs_cnt))
	end //}
	else if (timestamp_cs_cnt == 8 && ~timestamp_end_flag)
	begin //{
      	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : TIMESTAMP_SEQ_NO_END_FLAG_CHECK", $sformatf(" Spec reference 6.5.3.5. End flag is not set in the last control symbol of timestamp sequence."))
	end //}

        if (~bfm_or_mon && timestamp_cs_cnt == 1 && timestamp_start_flag)
        begin //{
          rx_dh_common_mon_trans.timestamp_seq_started[mon_type] = 1;
        end //}
        else if (~bfm_or_mon && timestamp_cs_cnt == 8 && timestamp_end_flag)
        begin //{
	  -> rx_dh_trans.rcvd_uninterrupted_timestamp_cs;
          rx_dh_common_mon_trans.timestamp_seq_completed[mon_type] = 1;
          timestamp_cs_cnt = 0;
        end //}

      end //}
      else if (srio_trans_cs_ins.stype0 != 4'b0011 && ~bfm_or_mon)
      begin //{

	if (rx_dh_common_mon_trans.timestamp_seq_started[mon_type] && ~rx_dh_common_mon_trans.timestamp_seq_completed[mon_type])
	begin //{

	  -> rx_dh_trans.rcvd_interrupted_timestamp_cs;

      	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : INCOMPLETE_TIMESTAMP_SEQ_CHECK", $sformatf(" Spec reference 6.5.3.5. Timestamp sequence shall not be truncated by any other control symbols. No. of timestamp control symbols received when it is truncated is %0d.", timestamp_cs_cnt))
          rx_dh_common_mon_trans.timestamp_seq_started[mon_type] = 0;
          rx_dh_common_mon_trans.timestamp_seq_completed[mon_type] = 1;
          timestamp_cs_cnt = 0;

	end //}

      end //}

      //$display($time, " 3. form_2x_srio_trans cntl_symbol_bytes is %0d", cntl_symbol_bytes);

      if (brc12_stype1_type'(srio_trans_cs_ins.stype1) == SOP && srio_trans_cs_ins.cs_kind == SRIO_DELIM_PD)
      begin //{
	packet_open = 1;
	sop_received = 1;
	if (packet_ended)
	begin //{

      	  cloned_srio_trans_pkt_ins = new srio_trans_pkt_ins;
	  rx_dh_trans.pl_rx_srio_trans_q.push_back(cloned_srio_trans_pkt_ins);

	  if (~bfm_or_mon)
	  begin //{
	    rx_dh_common_mon_trans.packet_rx_in_progress[mon_type] = 0;
	  end //}

	end //}
      end //}

      if (packet_ended)
	packet_ended = 0;

      if ((brc12_stype1_type'(srio_trans_cs_ins.stype1) != STOMP && brc12_stype1_type'(srio_trans_cs_ins.stype1) != LINK_REQ && brc12_stype1_type'(srio_trans_cs_ins.stype1) != RFR) && srio_trans_cs_ins.cs_kind == SRIO_DELIM_PD && ~packet_open)
      begin //{

	if (sop_received && brc12_stype1_type'(srio_trans_cs_ins.stype1) == EOP)
	begin //{

	  sop_received = 0;
      	  cloned_srio_trans_pkt_ins = new srio_trans_pkt_ins;
	  rx_dh_trans.pl_rx_srio_trans_q.push_back(cloned_srio_trans_pkt_ins);

	  if (~bfm_or_mon)
	  begin //{
	    rx_dh_common_mon_trans.packet_rx_in_progress[mon_type] = 0;
	  end //}

	end //}
	else if (~sop_received && brc12_stype1_type'(srio_trans_cs_ins.stype1) == EOP && ~bfm_or_mon)
	begin //{
      	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : EOP_WITHOUT_SOP", $sformatf(" Spec reference 3.5.3. EOP control symbol received when no packet is in progress."))
	end //}

      end //}
      else if (brc12_stype1_type'(srio_trans_cs_ins.stype1) == STOMP && srio_trans_cs_ins.cs_kind == SRIO_DELIM_PD && ~packet_open)
      begin //{
	if (sop_received)
	begin //{
	  sop_received = 0;
	  if (~bfm_or_mon)
	  begin //{
	    rx_dh_common_mon_trans.packet_rx_in_progress[mon_type] = 0;
            if(~rx_dh_common_mon_trans.outstanding_rfr[mon_type]  && ~rx_dh_common_mon_trans.oes_state_detected[~mon_type] && ~rx_dh_trans.ies_state)
             begin//{
             rx_dh_common_mon_trans.outstanding_retry[mon_type]=1;
             rx_dh_common_mon_trans.outstanding_rfr[mon_type]=1;
             end//}
	  end //}
	end //}
	else if (~bfm_or_mon)
         begin//{
          `uvm_error("SRIO_PL_PROTOCOL_CHECKER : STOMP_WITHOUT_PACKET", $sformatf(" Spec reference 3.5.2. STOMP control symbol received when no packet is in progress."))
      	    if (~rx_dh_trans.ies_state && rx_dh_trans.link_initialized)
      	    begin //{
      	      rx_dh_trans.ies_state = 1;
      	      rx_dh_trans.ies_cause_value = 5;
      	      //$display($time, " 3_1. Vaidhy : ies_state set here");
      	    end //}
         end//}
      end //}
      else if (brc12_stype1_type'(srio_trans_cs_ins.stype1) == LINK_REQ && srio_trans_cs_ins.cs_kind == SRIO_DELIM_PD && ~packet_open)
      begin //{
	if (sop_received)
	begin //{
	  sop_received = 0;
	  if (~bfm_or_mon)
	  begin //{
	    rx_dh_common_mon_trans.packet_rx_in_progress[mon_type] = 0;
	  end //}
	end //}
	else if (~bfm_or_mon)
          `uvm_error("SRIO_PL_PROTOCOL_CHECKER : LINK_REQ_IN_PD_DELIMITER_WITHOUT_PACKET", $sformatf(" Spec reference 3.5.5. LINK-REQUEST control symbol received with PD delimiter when no packet is in progress."))
      end //}
      else if (brc12_stype1_type'(srio_trans_cs_ins.stype1) == RFR && srio_trans_cs_ins.cs_kind == SRIO_DELIM_PD && ~packet_open)
      begin //{
	if (sop_received)
	begin //{
	  sop_received = 0;
	  if (~bfm_or_mon)
	  begin //{
	    rx_dh_common_mon_trans.packet_rx_in_progress[mon_type] = 0;
	  end //}
	end //}
	else if (~bfm_or_mon)
          `uvm_error("SRIO_PL_PROTOCOL_CHECKER : RFR_IN_PD_DELIMITER_WITHOUT_PACKET", $sformatf(" Spec reference 3.5.5. Restart-from-Retry control symbol received with PD delimiter when no packet is in progress."))
      end //}

      //$cast(cloned_srio_trans_cs_ins, srio_trans_cs_ins.clone());
      cloned_srio_trans_cs_ins = new srio_trans_cs_ins;
      rx_dh_trans.pl_rx_srio_trans_q.push_back(cloned_srio_trans_cs_ins);

    end //}
    else if (cntl_symbol_bytes == 4)
    begin //{

      srio_trans_cs_ins.param0[11] = x2_align_data.character[0][7];
      srio_trans_cs_ins.param1 = x2_align_data.character[0][6:1];

      srio_trans_cs_ins.stype1[0] = x2_align_data.character[0][0];
      srio_trans_cs_ins.stype1[1:2] = x2_align_data.character[1][7:6];
      srio_trans_cs_ins.cmd = x2_align_data.character[1][5:3];

      if (srio_trans_cs_ins.stype0 == 4'b0011 && ~bfm_or_mon)
      begin //{

	timestamp_start_flag = srio_trans_cs_ins.param0[7];
	timestamp_end_flag = srio_trans_cs_ins.param0[8];

	if (rx_dh_trans.timestamp_support && ~rx_dh_trans.timestamp_master)
	  timestamp_cs_cnt++;

	if (timestamp_cs_cnt == 1 && ~timestamp_start_flag)
	begin //{
      	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : TIMESTAMP_SEQ_NO_START_FLAG_CHECK", $sformatf(" Spec reference 6.5.3.5. Start flag is not set in the first control symbol of timestamp sequence."))
	end //}
	else if (timestamp_cs_cnt > 1 && timestamp_cs_cnt < 8 && timestamp_start_flag)
	begin //{
      	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : TIMESTAMP_SEQ_START_FLAG_CHECK", $sformatf(" Spec reference 6.5.3.5. Start flag is set in control symbol no. %0d of timestamp sequence.", timestamp_cs_cnt))
	end //}
	else if (timestamp_cs_cnt > 1 && timestamp_cs_cnt < 8 && timestamp_end_flag)
	begin //{
      	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : TIMESTAMP_SEQ_END_FLAG_CHECK", $sformatf(" Spec reference 6.5.3.5. End flag is set in control symbol no. %0d of timestamp sequence.", timestamp_cs_cnt))
	end //}
	else if (timestamp_cs_cnt == 8 && ~timestamp_end_flag)
	begin //{
      	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : TIMESTAMP_SEQ_NO_END_FLAG_CHECK", $sformatf(" Spec reference 6.5.3.5. End flag is not set in the last control symbol of timestamp sequence."))
	end //}

        if (~bfm_or_mon && timestamp_cs_cnt == 1 && timestamp_start_flag)
        begin //{
          rx_dh_common_mon_trans.timestamp_seq_started[mon_type] = 1;
        end //}
        else if (~bfm_or_mon && timestamp_cs_cnt == 8 && timestamp_end_flag)
        begin //{
	  -> rx_dh_trans.rcvd_uninterrupted_timestamp_cs;
          rx_dh_common_mon_trans.timestamp_seq_completed[mon_type] = 1;
          timestamp_cs_cnt = 0;
        end //}

      end //}
      else if (srio_trans_cs_ins.stype0 != 4'b0011 && ~bfm_or_mon)
      begin //{

	if (rx_dh_common_mon_trans.timestamp_seq_started[mon_type] && ~rx_dh_common_mon_trans.timestamp_seq_completed[mon_type])
	begin //{

	  -> rx_dh_trans.rcvd_interrupted_timestamp_cs;

      	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : INCOMPLETE_TIMESTAMP_SEQ_CHECK", $sformatf(" Spec reference 6.5.3.5. Timestamp sequence shall not be truncated by any other control symbols. No. of timestamp control symbols received when it is truncated is %0d.", timestamp_cs_cnt))
          rx_dh_common_mon_trans.timestamp_seq_started[mon_type] = 0;
          rx_dh_common_mon_trans.timestamp_seq_completed[mon_type] = 1;
          timestamp_cs_cnt = 0;

	end //}

      end //}

      if (brc12_stype1_type'(srio_trans_cs_ins.stype1) == SOP && srio_trans_cs_ins.cs_kind == SRIO_DELIM_PD)
      begin //{

	packet_open = 1;
	sop_received = 1;

	if (packet_ended)
	begin //{

      	  cloned_srio_trans_pkt_ins = new srio_trans_pkt_ins;
	  rx_dh_trans.pl_rx_srio_trans_q.push_back(cloned_srio_trans_pkt_ins);

	  if (~bfm_or_mon)
	  begin //{
	    rx_dh_common_mon_trans.packet_rx_in_progress[mon_type] = 0;
	  end //}

	end //}

      end //}

      if (packet_ended)
	packet_ended = 0;

      if ((brc12_stype1_type'(srio_trans_cs_ins.stype1) != STOMP && brc12_stype1_type'(srio_trans_cs_ins.stype1) != LINK_REQ && brc12_stype1_type'(srio_trans_cs_ins.stype1) != RFR) && srio_trans_cs_ins.cs_kind == SRIO_DELIM_PD && ~packet_open)
      begin //{

	if (sop_received && brc12_stype1_type'(srio_trans_cs_ins.stype1) == EOP)
	begin //{

	  sop_received = 0;
      	  cloned_srio_trans_pkt_ins = new srio_trans_pkt_ins;
	  rx_dh_trans.pl_rx_srio_trans_q.push_back(cloned_srio_trans_pkt_ins);

	  if (~bfm_or_mon)
	  begin //{
	    rx_dh_common_mon_trans.packet_rx_in_progress[mon_type] = 0;
	  end //}

	end //}
	else if (~sop_received && brc12_stype1_type'(srio_trans_cs_ins.stype1) == EOP && ~bfm_or_mon)
	begin //{
      	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : EOP_WITHOUT_SOP", $sformatf(" Spec reference 3.5.3. EOP control symbol received when no packet is in progress."))
	end //}

      end //}
      else if (brc12_stype1_type'(srio_trans_cs_ins.stype1) == STOMP && srio_trans_cs_ins.cs_kind == SRIO_DELIM_PD && ~packet_open)
      begin //{
	if (sop_received)
	begin //{
	  sop_received = 0;
	  if (~bfm_or_mon)
	  begin //{
	    rx_dh_common_mon_trans.packet_rx_in_progress[mon_type] = 0;
            if(~rx_dh_common_mon_trans.outstanding_rfr[mon_type]  && ~rx_dh_common_mon_trans.oes_state_detected[~mon_type]  && ~rx_dh_trans.ies_state)
             begin//{
             rx_dh_common_mon_trans.outstanding_retry[mon_type]=1;
             rx_dh_common_mon_trans.outstanding_rfr[mon_type]=1;
             end//}
	  end //}
	end //}
	else if (~bfm_or_mon)
         begin//{
          `uvm_error("SRIO_PL_PROTOCOL_CHECKER : STOMP_WITHOUT_PACKET", $sformatf(" Spec reference 3.5.2. STOMP control symbol received when no packet is in progress."))
      	    if (~rx_dh_trans.ies_state && rx_dh_trans.link_initialized)
      	    begin //{
      	      rx_dh_trans.ies_state = 1;
      	      rx_dh_trans.ies_cause_value = 5;
      	      //$display($time, " 4_1. Vaidhy : ies_state set here");
      	    end //}
         end//}
      end //}
      else if (brc12_stype1_type'(srio_trans_cs_ins.stype1) == LINK_REQ && srio_trans_cs_ins.cs_kind == SRIO_DELIM_PD && ~packet_open)
      begin //{
	if (sop_received)
	begin //{
	  sop_received = 0;
	  if (~bfm_or_mon)
	  begin //{
	    rx_dh_common_mon_trans.packet_rx_in_progress[mon_type] = 0;
	  end //}
	end //}
	else if (~bfm_or_mon)
          `uvm_error("SRIO_PL_PROTOCOL_CHECKER : LINK_REQ_IN_PD_DELIMITER_WITHOUT_PACKET", $sformatf(" Spec reference 3.5.5. LINK-REQUEST control symbol received with PD delimiter when no packet is in progress."))
      end //}
      else if (brc12_stype1_type'(srio_trans_cs_ins.stype1) == RFR && srio_trans_cs_ins.cs_kind == SRIO_DELIM_PD && ~packet_open)
      begin //{
	if (sop_received)
	begin //{
	  sop_received = 0;
	  if (~bfm_or_mon)
	  begin //{
	    rx_dh_common_mon_trans.packet_rx_in_progress[mon_type] = 0;
	  end //}
	end //}
	else if (~bfm_or_mon)
          `uvm_error("SRIO_PL_PROTOCOL_CHECKER : RFR_IN_PD_DELIMITER_WITHOUT_PACKET", $sformatf(" Spec reference 3.5.5. Restart-from-Retry control symbol received with PD delimiter when no packet is in progress."))
      end //}


    end //}
    else if (cntl_symbol_bytes == 6)
    begin //{

      srio_trans_cs_ins.cs_crc13[0:4] = x2_align_data.character[1][4:0];

    end //}
    else if (cntl_symbol_bytes == 8)
    begin //{

      srio_trans_cs_ins.cs_crc13[5:12] = x2_align_data.character[0];

      cntl_symbol_open = 0;
      cntl_symbol_bytes = 0;

      //$cast(cloned_srio_trans_cs_ins, srio_trans_cs_ins.clone());
      cloned_srio_trans_cs_ins = new srio_trans_cs_ins;
      rx_dh_trans.pl_rx_srio_trans_q.push_back(cloned_srio_trans_cs_ins);

    end //}

  end //}
  else if (packet_open)
  begin //{

    packet_bytes = packet_bytes+2;

    if (packet_bytes == 2)
    begin //{

      srio_trans_pkt_ins = new();
      srio_trans_pkt_ins.transaction_kind = SRIO_PACKET;
      rx_dh_trans.bytestream = new[rx_dh_config.max_pkt_size]; // max packet size is 276

    end //}

    if (packet_bytes<=rx_dh_config.max_pkt_size)
    begin //{

      rx_dh_trans.bytestream[packet_bytes-2] = x2_align_data.character[0];
      rx_dh_trans.bytestream[packet_bytes-1] = x2_align_data.character[1];

      if (packet_bytes == 2)
      begin //{
	if (rx_dh_trans.idle_selected && bfm_or_mon)
	  rx_dh_env_config.current_ack_id = x2_align_data.character[0][7:2];
	else if (~rx_dh_trans.idle_selected && bfm_or_mon)
	  rx_dh_env_config.current_ack_id = x2_align_data.character[0][7:3];

	if (bfm_or_mon)
	  ->rx_dh_env_config.packet_rx_started;

	if (~bfm_or_mon)
	begin //{
	  rx_dh_common_mon_trans.packet_rx_in_progress[mon_type] = 1;
	  if (rx_dh_trans.idle_selected)
	    rx_dh_common_mon_trans.pkt_in_progress_ack_id[mon_type] = x2_align_data.character[0][7:2];
	  else if (~rx_dh_trans.idle_selected)
	    rx_dh_common_mon_trans.pkt_in_progress_ack_id[mon_type] = x2_align_data.character[0][7:3];
	end //}

      end //}

    end //}
    else
    begin //{
      pkt_size_err();
    end //}

    check_pkt_char(0);

  end //}

  if (cntl_symbol_open || prev_cntl_symbol_open)
  begin //{
    //$display($time, " control_symbol_check called here");
    control_symbol_check(0);
  end //}

  if (prev_cntl_symbol_open && ~cntl_symbol_open)
  begin //{
    link_init_srio_trans_cs_ins = new srio_trans_cs_ins;
    if (rx_dh_trans.idle_detected && ~rx_dh_trans.idle_selected)
    begin //{
      if (srio_trans_cs_ins.cs_crc5 != link_init_srio_trans_cs_ins.calccrc5(link_init_srio_trans_cs_ins.pack_cs()))
	link_init_cntl_symbol_err = 1;
    end //}
    else if (rx_dh_trans.idle_detected && rx_dh_trans.idle_selected)
    begin //{
      if (srio_trans_cs_ins.cs_crc13 != link_init_srio_trans_cs_ins.calccrc13(link_init_srio_trans_cs_ins.pack_cs()))
	link_init_cntl_symbol_err = 1;
    end //}
  end //}

  if (pkt_size_err_reported && ~cntl_symbol_open && ~packet_open)
    pkt_size_err_reported = 0;

endtask : form_2x_srio_trans



//////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : form_nx_srio_trans
/// Description : This task forms the srio_trans from nx_align_data. If SC character is observed on a lane%4=0
/// the control symbol context is opened, and the complete CS kind srio_trans is formed from
/// consecutive nx_align_data. If PD character is found on lane%4=0, then packet context is opened
/// along with control symbol context, since the packet delimiter is itself a control symbol.
/// The CS kind srio_trans is formed with the packet delimiter control symbol and after that
/// PACKET kind srio_trans is formed by accumulating the bytestream of srio_trans.
/// The bytestream is initially created for 276 locations which is the maximum packet size, and
/// when the end delimiter is found, the bytestream is restricted to the actual packet size based
/// on the packet_bytes.
/// If an embedded control symbol is found inbetween a packet, then a new CS kind srio_trans is
/// formed before proceeding with the packet again.
///
/// The method processes 4 lanes at a time, hence it is called multiple times based on the
/// max_lanes_support. Depending on the argument passed to this method, it'll select a particular
/// 4 lanes and processes the corresponding nx_align_data entry.
//////////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::form_nx_srio_trans(input int nx_lane_num);

  if (((nx_align_data.character[nx_lane_num] == SRIO_SC || nx_align_data.character[nx_lane_num] == SRIO_PD) && nx_align_data.cntl[nx_lane_num]) && ~cntl_symbol_open)
  begin //{

    cntl_symbol_open = 1;
    cntl_symbol_bytes = cntl_symbol_bytes+4;

    srio_trans_cs_ins = new();
    srio_trans_cs_ins.transaction_kind = SRIO_CS;

    if (~rx_dh_trans.idle_selected)
      srio_trans_cs_ins.cstype = CS24;
    else
      srio_trans_cs_ins.cstype = CS48;

    if (nx_align_data.character[nx_lane_num] == SRIO_SC)
      srio_trans_cs_ins.cs_kind = SRIO_DELIM_SC;
    else if (nx_align_data.character[nx_lane_num] == SRIO_PD)
    begin //{

      srio_trans_cs_ins.cs_kind = SRIO_DELIM_PD;

      if (packet_open)
      begin //{

	srio_trans_pkt_ins.bytestream = new[packet_bytes] (rx_dh_trans.bytestream);

	packet_open = 0;
	packet_bytes = 0;

	packet_ended = 1;

	//$cast(cloned_srio_trans_pkt_ins, srio_trans_pkt_ins.clone());
      	//cloned_srio_trans_pkt_ins = new srio_trans_pkt_ins;
	//rx_dh_trans.pl_rx_srio_trans_q.push_back(cloned_srio_trans_pkt_ins);

      end //}
      //else
      //  packet_open = 1;

    end //}

    if (~rx_dh_trans.idle_selected)
    begin //{

	//$display($time, " SCS received : char0 is %0h, char1 is %0h, char2 is %0h, char3 is %0h", nx_align_data.character[nx_lane_num], nx_align_data.character[nx_lane_num+1], nx_align_data.character[nx_lane_num+2], nx_align_data.character[nx_lane_num+3]);

      srio_trans_cs_ins.stype0 = nx_align_data.character[nx_lane_num+1][7:5];
      srio_trans_cs_ins.param0 = nx_align_data.character[nx_lane_num+1][4:0];

      srio_trans_cs_ins.param1 = nx_align_data.character[nx_lane_num+2][7:3];
      srio_trans_cs_ins.stype1 = nx_align_data.character[nx_lane_num+2][2:0];

      srio_trans_cs_ins.cmd = nx_align_data.character[nx_lane_num+3][7:5];
      srio_trans_cs_ins.cs_crc5 = nx_align_data.character[nx_lane_num+3][4:0];
      prev_cntl_symbol_open = 1; // Short CS will be finishing in the same column.
      nx_scs_rcvd = 1; // Used for IDLE1 check
      cntl_symbol_open = 0;
      cntl_symbol_bytes = 0;

      if (srio_trans_cs_ins.stype0 == 4'b0011 && ~bfm_or_mon)
      begin //{

	timestamp_start_flag = srio_trans_cs_ins.param0[7];
	timestamp_end_flag = srio_trans_cs_ins.param0[8];

	if (rx_dh_trans.timestamp_support && ~rx_dh_trans.timestamp_master)
	  timestamp_cs_cnt++;

	if (timestamp_cs_cnt == 1 && ~timestamp_start_flag)
	begin //{
      	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : TIMESTAMP_SEQ_NO_START_FLAG_CHECK", $sformatf(" Spec reference 6.5.3.5. Start flag is not set in the first control symbol of timestamp sequence."))
	end //}
	else if (timestamp_cs_cnt > 1 && timestamp_cs_cnt < 8 && timestamp_start_flag)
	begin //{
      	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : TIMESTAMP_SEQ_START_FLAG_CHECK", $sformatf(" Spec reference 6.5.3.5. Start flag is set in control symbol no. %0d of timestamp sequence.", timestamp_cs_cnt))
	end //}
	else if (timestamp_cs_cnt > 1 && timestamp_cs_cnt < 8 && timestamp_end_flag)
	begin //{
      	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : TIMESTAMP_SEQ_END_FLAG_CHECK", $sformatf(" Spec reference 6.5.3.5. End flag is set in control symbol no. %0d of timestamp sequence.", timestamp_cs_cnt))
	end //}
	else if (timestamp_cs_cnt == 8 && ~timestamp_end_flag)
	begin //{
      	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : TIMESTAMP_SEQ_NO_END_FLAG_CHECK", $sformatf(" Spec reference 6.5.3.5. End flag is not set in the last control symbol of timestamp sequence."))
	end //}

        if (~bfm_or_mon && timestamp_cs_cnt == 1 && timestamp_start_flag)
        begin //{
          rx_dh_common_mon_trans.timestamp_seq_started[mon_type] = 1;
        end //}
        else if (~bfm_or_mon && timestamp_cs_cnt == 8 && timestamp_end_flag)
        begin //{
	  -> rx_dh_trans.rcvd_uninterrupted_timestamp_cs;
          rx_dh_common_mon_trans.timestamp_seq_completed[mon_type] = 1;
          timestamp_cs_cnt = 0;
        end //}

      end //}
      else if (srio_trans_cs_ins.stype0 != 4'b0011 && ~bfm_or_mon)
      begin //{

	if (rx_dh_common_mon_trans.timestamp_seq_started[mon_type] && ~rx_dh_common_mon_trans.timestamp_seq_completed[mon_type])
	begin //{

	  -> rx_dh_trans.rcvd_interrupted_timestamp_cs;

      	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : INCOMPLETE_TIMESTAMP_SEQ_CHECK", $sformatf(" Spec reference 6.5.3.5. Timestamp sequence shall not be truncated by any other control symbols. No. of timestamp control symbols received when it is truncated is %0d.", timestamp_cs_cnt))
          rx_dh_common_mon_trans.timestamp_seq_started[mon_type] = 0;
          rx_dh_common_mon_trans.timestamp_seq_completed[mon_type] = 1;
          timestamp_cs_cnt = 0;

	end //}

      end //}

      if (brc12_stype1_type'(srio_trans_cs_ins.stype1) == SOP && srio_trans_cs_ins.cs_kind == SRIO_DELIM_PD)
      begin //{

	packet_open = 1;
	sop_received = 1;

	if (packet_ended)
	begin //{

      	  cloned_srio_trans_pkt_ins = new srio_trans_pkt_ins;
	  rx_dh_trans.pl_rx_srio_trans_q.push_back(cloned_srio_trans_pkt_ins);

	  if (~bfm_or_mon)
	  begin //{
	    rx_dh_common_mon_trans.packet_rx_in_progress[mon_type] = 0;
	  end //}

	end //}

      end //}

      if (packet_ended)
	packet_ended = 0;

      if ((brc12_stype1_type'(srio_trans_cs_ins.stype1) != STOMP && brc12_stype1_type'(srio_trans_cs_ins.stype1) != LINK_REQ && brc12_stype1_type'(srio_trans_cs_ins.stype1) != RFR) && srio_trans_cs_ins.cs_kind == SRIO_DELIM_PD && ~packet_open)
      begin //{

	if (sop_received && brc12_stype1_type'(srio_trans_cs_ins.stype1) == EOP)
	begin //{
	  sop_received = 0;
      	  cloned_srio_trans_pkt_ins = new srio_trans_pkt_ins;
	  rx_dh_trans.pl_rx_srio_trans_q.push_back(cloned_srio_trans_pkt_ins);
	  if (~bfm_or_mon)
	  begin //{
	    rx_dh_common_mon_trans.packet_rx_in_progress[mon_type] = 0;
	  end //}
	end //}
	else if (~sop_received && brc12_stype1_type'(srio_trans_cs_ins.stype1) == EOP && ~bfm_or_mon)
	begin //{
      	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : EOP_WITHOUT_SOP", $sformatf(" Spec reference 3.5.3. EOP control symbol received when no packet is in progress."))
	end //}

      end //}
      else if (brc12_stype1_type'(srio_trans_cs_ins.stype1) == STOMP && srio_trans_cs_ins.cs_kind == SRIO_DELIM_PD && ~packet_open)
      begin //{
	if (sop_received)
	begin //{
	  sop_received = 0;
	  if (~bfm_or_mon)
	  begin //{
	    rx_dh_common_mon_trans.packet_rx_in_progress[mon_type] = 0;
            if(~rx_dh_common_mon_trans.outstanding_rfr[mon_type]  && ~rx_dh_common_mon_trans.oes_state_detected[~mon_type] && ~rx_dh_trans.ies_state)
             begin//{
             rx_dh_common_mon_trans.outstanding_retry[mon_type]=1;
             rx_dh_common_mon_trans.outstanding_rfr[mon_type]=1;
             end//}
	  end //}
	end //}
	else if (~bfm_or_mon)
         begin//{
          `uvm_error("SRIO_PL_PROTOCOL_CHECKER : STOMP_WITHOUT_PACKET", $sformatf(" Spec reference 3.5.2. STOMP control symbol received when no packet is in progress."))
      	    if (~rx_dh_trans.ies_state && rx_dh_trans.link_initialized)
      	    begin //{
      	      rx_dh_trans.ies_state = 1;
      	      rx_dh_trans.ies_cause_value = 5;
      	      //$display($time, " 1. Vaidhy : ies_state set here");
      	    end //}
        end//}
      end //}
      else if (brc12_stype1_type'(srio_trans_cs_ins.stype1) == LINK_REQ && srio_trans_cs_ins.cs_kind == SRIO_DELIM_PD && ~packet_open)
      begin //{
	if (sop_received)
	begin //{
	  sop_received = 0;
	  if (~bfm_or_mon)
	  begin //{
	    rx_dh_common_mon_trans.packet_rx_in_progress[mon_type] = 0;
	  end //}
	end //}
	else if (~bfm_or_mon)
          `uvm_error("SRIO_PL_PROTOCOL_CHECKER : LINK_REQ_IN_PD_DELIMITER_WITHOUT_PACKET", $sformatf(" Spec reference 3.5.5. LINK-REQUEST control symbol received with PD delimiter when no packet is in progress."))
      end //}
      else if (brc12_stype1_type'(srio_trans_cs_ins.stype1) == RFR && srio_trans_cs_ins.cs_kind == SRIO_DELIM_PD && ~packet_open)
      begin //{
	if (sop_received)
	begin //{
	  sop_received = 0;
	  if (~bfm_or_mon)
	  begin //{
	    rx_dh_common_mon_trans.packet_rx_in_progress[mon_type] = 0;
	  end //}
	end //}
	else if (~bfm_or_mon)
          `uvm_error("SRIO_PL_PROTOCOL_CHECKER : RFR_IN_PD_DELIMITER_WITHOUT_PACKET", $sformatf(" Spec reference 3.5.5. Restart-from-Retry control symbol received with PD delimiter when no packet is in progress."))
      end //}

      //$cast(cloned_srio_trans_cs_ins, srio_trans_cs_ins.clone());
      cloned_srio_trans_cs_ins = new srio_trans_cs_ins;
      rx_dh_trans.pl_rx_srio_trans_q.push_back(cloned_srio_trans_cs_ins);

    end //}
    else
    begin //{
      srio_trans_cs_ins.stype0 = nx_align_data.character[nx_lane_num+1][7:5];
      srio_trans_cs_ins.param0[6:10] = nx_align_data.character[nx_lane_num+1][4:0];

      srio_trans_cs_ins.param0[11] = nx_align_data.character[nx_lane_num+2][7];
      srio_trans_cs_ins.param1 = nx_align_data.character[nx_lane_num+2][6:1];

      srio_trans_cs_ins.stype1[0] = nx_align_data.character[nx_lane_num+2][0];
      srio_trans_cs_ins.stype1[1:2] = nx_align_data.character[nx_lane_num+3][7:6];
      srio_trans_cs_ins.cmd = nx_align_data.character[nx_lane_num+3][5:3];

      if (srio_trans_cs_ins.stype0 == 4'b0011 && ~bfm_or_mon)
      begin //{

	timestamp_start_flag = srio_trans_cs_ins.param0[7];
	timestamp_end_flag = srio_trans_cs_ins.param0[8];

	if (rx_dh_trans.timestamp_support && ~rx_dh_trans.timestamp_master)
	  timestamp_cs_cnt++;

	if (timestamp_cs_cnt == 1 && ~timestamp_start_flag)
	begin //{
      	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : TIMESTAMP_SEQ_NO_START_FLAG_CHECK", $sformatf(" Spec reference 6.5.3.5. Start flag is not set in the first control symbol of timestamp sequence."))
	end //}
	else if (timestamp_cs_cnt > 1 && timestamp_cs_cnt < 8 && timestamp_start_flag)
	begin //{
      	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : TIMESTAMP_SEQ_START_FLAG_CHECK", $sformatf(" Spec reference 6.5.3.5. Start flag is set in control symbol no. %0d of timestamp sequence.", timestamp_cs_cnt))
	end //}
	else if (timestamp_cs_cnt > 1 && timestamp_cs_cnt < 8 && timestamp_end_flag)
	begin //{
      	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : TIMESTAMP_SEQ_END_FLAG_CHECK", $sformatf(" Spec reference 6.5.3.5. End flag is set in control symbol no. %0d of timestamp sequence.", timestamp_cs_cnt))
	end //}
	else if (timestamp_cs_cnt == 8 && ~timestamp_end_flag)
	begin //{
      	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : TIMESTAMP_SEQ_NO_END_FLAG_CHECK", $sformatf(" Spec reference 6.5.3.5. End flag is not set in the last control symbol of timestamp sequence."))
	end //}

        if (~bfm_or_mon && timestamp_cs_cnt == 1 && timestamp_start_flag)
        begin //{
          rx_dh_common_mon_trans.timestamp_seq_started[mon_type] = 1;
        end //}
        else if (~bfm_or_mon && timestamp_cs_cnt == 8 && timestamp_end_flag)
        begin //{
	  -> rx_dh_trans.rcvd_uninterrupted_timestamp_cs;
          rx_dh_common_mon_trans.timestamp_seq_completed[mon_type] = 1;
          timestamp_cs_cnt = 0;
        end //}

      end //}
      else if (srio_trans_cs_ins.stype0 != 4'b0011 && ~bfm_or_mon)
      begin //{

	if (rx_dh_common_mon_trans.timestamp_seq_started[mon_type] && ~rx_dh_common_mon_trans.timestamp_seq_completed[mon_type])
	begin //{

	  -> rx_dh_trans.rcvd_interrupted_timestamp_cs;

      	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : INCOMPLETE_TIMESTAMP_SEQ_CHECK", $sformatf(" Spec reference 6.5.3.5. Timestamp sequence shall not be truncated by any other control symbols. No. of timestamp control symbols received when it is truncated is %0d.", timestamp_cs_cnt))
          rx_dh_common_mon_trans.timestamp_seq_started[mon_type] = 0;
          rx_dh_common_mon_trans.timestamp_seq_completed[mon_type] = 1;
          timestamp_cs_cnt = 0;

	end //}

      end //}

      if (brc12_stype1_type'(srio_trans_cs_ins.stype1) == SOP && srio_trans_cs_ins.cs_kind == SRIO_DELIM_PD)
      begin //{
	packet_open = 1;
	sop_received = 1;
	if (packet_ended)
	begin //{
      	  cloned_srio_trans_pkt_ins = new srio_trans_pkt_ins;
	  rx_dh_trans.pl_rx_srio_trans_q.push_back(cloned_srio_trans_pkt_ins);
	  if (~bfm_or_mon)
	  begin //{
	    rx_dh_common_mon_trans.packet_rx_in_progress[mon_type] = 0;
	  end //}
	end //}
      end //}

      if (packet_ended)
	packet_ended = 0;

      if ((brc12_stype1_type'(srio_trans_cs_ins.stype1) != STOMP && brc12_stype1_type'(srio_trans_cs_ins.stype1) != LINK_REQ && brc12_stype1_type'(srio_trans_cs_ins.stype1) != RFR) && srio_trans_cs_ins.cs_kind == SRIO_DELIM_PD && ~packet_open)
      begin //{

	if (sop_received && brc12_stype1_type'(srio_trans_cs_ins.stype1) == EOP)
	begin //{
	  sop_received = 0;
      	  cloned_srio_trans_pkt_ins = new srio_trans_pkt_ins;
	  rx_dh_trans.pl_rx_srio_trans_q.push_back(cloned_srio_trans_pkt_ins);
	  if (~bfm_or_mon)
	  begin //{
	    rx_dh_common_mon_trans.packet_rx_in_progress[mon_type] = 0;
	  end //}
	end //}
	else if (~sop_received && brc12_stype1_type'(srio_trans_cs_ins.stype1) == EOP && ~bfm_or_mon)
	begin //{
      	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : EOP_WITHOUT_SOP", $sformatf(" Spec reference 3.5.3. EOP control symbol received when no packet is in progress."))
	end //}

      end //}
      else if (brc12_stype1_type'(srio_trans_cs_ins.stype1) == STOMP && srio_trans_cs_ins.cs_kind == SRIO_DELIM_PD && ~packet_open)
      begin //{
	if (sop_received)
	begin //{
	  sop_received = 0;
	  if (~bfm_or_mon)
	  begin //{
	    rx_dh_common_mon_trans.packet_rx_in_progress[mon_type] = 0;
            if(~rx_dh_common_mon_trans.outstanding_rfr[mon_type]  && ~rx_dh_common_mon_trans.oes_state_detected[~mon_type] && ~rx_dh_trans.ies_state)
             begin//{
             rx_dh_common_mon_trans.outstanding_retry[mon_type]=1;
             rx_dh_common_mon_trans.outstanding_rfr[mon_type]=1;
             end//}
	  end //}
	end //}
	else if (~bfm_or_mon)
           begin//{
          `uvm_error("SRIO_PL_PROTOCOL_CHECKER : STOMP_WITHOUT_PACKET", $sformatf(" Spec reference 3.5.2. STOMP control symbol received when no packet is in progress."))
      	    if (~rx_dh_trans.ies_state && rx_dh_trans.link_initialized)
      	    begin //{
      	      rx_dh_trans.ies_state = 1;
      	      rx_dh_trans.ies_cause_value = 5;
      	      //$display($time, " STOMP HERE 6_1. Vaidhy : ies_state set here");
      	    end //}
           end//}
      end //}
      else if (brc12_stype1_type'(srio_trans_cs_ins.stype1) == LINK_REQ && srio_trans_cs_ins.cs_kind == SRIO_DELIM_PD && ~packet_open)
      begin //{
	if (sop_received)
	begin //{
	  sop_received = 0;
	  if (~bfm_or_mon)
	  begin //{
	    rx_dh_common_mon_trans.packet_rx_in_progress[mon_type] = 0;
	  end //}
	end //}
	else if (~bfm_or_mon)
          `uvm_error("SRIO_PL_PROTOCOL_CHECKER : LINK_REQ_IN_PD_DELIMITER_WITHOUT_PACKET", $sformatf(" Spec reference 3.5.5. LINK-REQUEST control symbol received with PD delimiter when no packet is in progress."))
      end //}
      else if (brc12_stype1_type'(srio_trans_cs_ins.stype1) == RFR && srio_trans_cs_ins.cs_kind == SRIO_DELIM_PD && ~packet_open)
      begin //{
	if (sop_received)
	begin //{
	  sop_received = 0;
	  if (~bfm_or_mon)
	  begin //{
	    rx_dh_common_mon_trans.packet_rx_in_progress[mon_type] = 0;
	  end //}
	end //}
	else if (~bfm_or_mon)
          `uvm_error("SRIO_PL_PROTOCOL_CHECKER : RFR_IN_PD_DELIMITER_WITHOUT_PACKET", $sformatf(" Spec reference 3.5.5. Restart-from-Retry control symbol received with PD delimiter when no packet is in progress."))
      end //}

    end //}

  end //}
  else if (cntl_symbol_open)
  begin //{

    cntl_symbol_bytes = cntl_symbol_bytes+4;

    if (cntl_symbol_bytes == 8)
    begin //{

      srio_trans_cs_ins.cs_crc13[0:4] = nx_align_data.character[nx_lane_num+1][4:0];

      srio_trans_cs_ins.cs_crc13[5:12] = nx_align_data.character[nx_lane_num+2];

      cntl_symbol_open = 0;
      cntl_symbol_bytes = 0;

      if (nx_lane_num > 3)
      begin //{
	lcs_completed_in_same_column = 1;
      end //}

      //$cast(cloned_srio_trans_cs_ins, srio_trans_cs_ins.clone());
      cloned_srio_trans_cs_ins = new srio_trans_cs_ins;
      rx_dh_trans.pl_rx_srio_trans_q.push_back(cloned_srio_trans_cs_ins);

    end //}

  end //}
  else if (packet_open)
  begin //{

    packet_bytes = packet_bytes+4;

    if (packet_bytes == 4)
    begin //{

      srio_trans_pkt_ins = new();
      srio_trans_pkt_ins.transaction_kind = SRIO_PACKET;
      rx_dh_trans.bytestream = new[rx_dh_config.max_pkt_size]; // max packet size is 276

    end //}

    if(packet_bytes<=rx_dh_config.max_pkt_size)
    begin //{
      rx_dh_trans.bytestream[packet_bytes-4] = nx_align_data.character[nx_lane_num];
      rx_dh_trans.bytestream[packet_bytes-3] = nx_align_data.character[nx_lane_num+1];
      rx_dh_trans.bytestream[packet_bytes-2] = nx_align_data.character[nx_lane_num+2];
      rx_dh_trans.bytestream[packet_bytes-1] = nx_align_data.character[nx_lane_num+3];

      if (packet_bytes == 4)
      begin //{
	if (rx_dh_trans.idle_selected && bfm_or_mon)
	  rx_dh_env_config.current_ack_id = nx_align_data.character[nx_lane_num][7:2];
	else if (~rx_dh_trans.idle_selected && bfm_or_mon)
	  rx_dh_env_config.current_ack_id = nx_align_data.character[nx_lane_num][7:3];

	if (bfm_or_mon)
	  ->rx_dh_env_config.packet_rx_started;

	if (~bfm_or_mon)
	begin //{
	  rx_dh_common_mon_trans.packet_rx_in_progress[mon_type] = 1;
	  if (rx_dh_trans.idle_selected)
	    rx_dh_common_mon_trans.pkt_in_progress_ack_id[mon_type] = nx_align_data.character[nx_lane_num][7:2];
	  else if (~rx_dh_trans.idle_selected)
	    rx_dh_common_mon_trans.pkt_in_progress_ack_id[mon_type] = nx_align_data.character[nx_lane_num][7:3];
	end //}

      end //}

    end //}
    else
    begin //{
      pkt_size_err();
    end //}

    check_pkt_char(nx_lane_num);

  end //}

  if (cntl_symbol_open || prev_cntl_symbol_open)
    control_symbol_check(nx_lane_num);

  if (prev_cntl_symbol_open && ~cntl_symbol_open)
  begin //{
    link_init_srio_trans_cs_ins = new srio_trans_cs_ins;
    if (rx_dh_trans.idle_detected && ~rx_dh_trans.idle_selected)
    begin //{
      if (srio_trans_cs_ins.cs_crc5 != link_init_srio_trans_cs_ins.calccrc5(link_init_srio_trans_cs_ins.pack_cs()))
	link_init_cntl_symbol_err = 1;
    end //}
    else if (rx_dh_trans.idle_detected && rx_dh_trans.idle_selected)
    begin //{
      if (srio_trans_cs_ins.cs_crc13 != link_init_srio_trans_cs_ins.calccrc13(link_init_srio_trans_cs_ins.pack_cs()))
	link_init_cntl_symbol_err = 1;
    end //}
  end //}

  if (pkt_size_err_reported && ~cntl_symbol_open && ~packet_open)
    pkt_size_err_reported = 0;

endtask : form_nx_srio_trans


//////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : form_1x_srio_trans
/// Description : Based on the initialized state, the x1_lane is selected, and after that srio_trans
/// is formed similar to the form_2x_srio_trans and form_nx_srio_trans methods. In this
/// method x1_lane_data is used for creating the srio_trans.
/// If the 1x mode lane in which the port got initialized is different from active_lane_for_idle, then
/// active_lane_for_idle is updated with lane number in which the port got initialized.
//////////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::form_1x_srio_trans();

  active_lane_for_idle = 0;

  forever begin //{

 //   wait (rx_dh_trans.port_initialized == 1);
    if (rx_dh_env_config.srio_mode != SRIO_GEN30)
      wait (rx_dh_trans.idle_detected == 1);

    @(posedge srio_if.sim_clk);

    if ((packet_open || cntl_symbol_open) && ~rx_dh_trans.port_initialized)
    begin //{
      packet_open = 0;
      //cntl_symbol_open = 0;
      packet_bytes = 0;
      //cntl_symbol_bytes = 0;
      lcs_completed_in_same_column = 0;
      //local_cntl_symbol_open = 0;
      //x1_delimiter_detected = 0;
      x2_delimiter_detected = 0;
      if(~x1_delimiter_detected)
       begin//{
          cntl_symbol_open = 0;
          cntl_symbol_bytes = 0;
          x1_delimiter_detected = 0;
       end//}
//`uvm_info("RXD",$sformatf("6_cntl_symbol_open:%0d x1_delimiter_detected:%0d potr_init:%0d",cntl_symbol_open,x1_delimiter_detected,rx_dh_trans.port_initialized),UVM_LOW)
    end //}

    if (rx_dh_trans.lane_sync.exists(active_lane_for_idle) && rx_dh_trans.lane_sync[active_lane_for_idle] == 0)
    begin //{

      active_lane_found = 0;

      if (rx_dh_trans.lane_sync.exists(0) && rx_dh_trans.lane_sync[0] == 1)
      begin //{
        active_lane_for_idle = 0;
        active_lane_found = 1;
      end //}
      else if (rx_dh_trans.lane_sync.exists(1) && rx_dh_trans.lane_sync[1] == 1)
      begin //{
        active_lane_for_idle = 1;
        active_lane_found = 1;
      end //}
      else if (rx_dh_trans.lane_sync.exists(2) && rx_dh_trans.lane_sync[2] == 1)
      begin //{
        active_lane_for_idle = 2;
        active_lane_found = 1;
      end //}
	
	//$display($time, " 3. active_lane_for_idle is %0d", active_lane_for_idle);

      if (~active_lane_found)
	continue;

    end //}

    if (~rx_dh_trans.port_initialized && srio_data_ins_valid.exists(active_lane_for_idle) && srio_data_ins_valid[active_lane_for_idle] == 1)
    begin //{

      if (~bfm_or_mon)
        rx_dh_common_mon_trans.xmting_idle[mon_type] = 1;

      if (rx_dh_env_config.srio_mode != SRIO_GEN30)
      begin //{

        x1_lane_data.character = srio_data_ins[active_lane_for_idle].character;
        x1_lane_data.cntl = srio_data_ins[active_lane_for_idle].cntl;

      end //}
      else
      begin //{

        x1_lane_data.brc3_cntl_cw_type = srio_data_ins[active_lane_for_idle].brc3_cntl_cw_type;
        x1_lane_data.brc3_type = srio_data_ins[active_lane_for_idle].brc3_type;
        x1_lane_data.brc3_cw = srio_data_ins[active_lane_for_idle].brc3_cw;
        x1_lane_data.brc3_cc_type = srio_data_ins[active_lane_for_idle].brc3_cc_type;

      end //}

      x1_lane_data_valid = 1;
      continue;

    end //}
    else if (~rx_dh_trans.port_initialized && srio_data_ins_valid.exists(active_lane_for_idle) && srio_data_ins_valid[active_lane_for_idle] == 0)
    begin //{

      if (~bfm_or_mon)
        rx_dh_common_mon_trans.xmting_idle[mon_type] = 1;

      x1_lane_data_valid = 0;
      continue;

    end //}

    if (rx_dh_trans.current_init_state == X1_M0 || (rx_dh_trans.current_init_state == ASYM_MODE && rx_dh_trans.rcv_width == "1x"))
      x1_lane = 0;
    else if (rx_dh_trans.current_init_state == X1_M1)
      x1_lane = 1;
    else if (rx_dh_trans.current_init_state == X1_M2)
      x1_lane = 2;
    else
      continue;

    if (srio_data_ins_valid[x1_lane] == 0)
    begin //{
      x1_lane_data_valid = 0;
      continue;
    end //}

    active_lane_for_idle = x1_lane;

    if (rx_dh_env_config.srio_mode != SRIO_GEN30)
    begin //{
      if(x1_delimiter_detected && cntl_symbol_open  && rx_dh_trans.idle_selected)
       begin//{
        if(srio_data_ins[x1_lane].character==SRIO_SC &&  srio_data_ins[x1_lane].cntl)
         begin//{
          cntl_symbol_open=0; 
          local_cntl_symbol_open=0; 
          cntl_symbol_bytes=0; 
          x1_delimiter_detected=0;         
          continue;
         end//}
       end//}

      x1_lane_data.character = srio_data_ins[x1_lane].character;
      x1_lane_data.cntl = srio_data_ins[x1_lane].cntl;

    end //}
    else
    begin //{

      x1_lane_data.brc3_cntl_cw_type = srio_data_ins[x1_lane].brc3_cntl_cw_type;
      x1_lane_data.brc3_type = srio_data_ins[x1_lane].brc3_type;
      x1_lane_data.brc3_cw = srio_data_ins[x1_lane].brc3_cw;
      x1_lane_data.brc3_cc_type = srio_data_ins[x1_lane].brc3_cc_type;

      gen3_align_data_ins.brc3_cntl_cw_type[x1_lane] = srio_data_ins[x1_lane].brc3_cntl_cw_type;
      gen3_align_data_ins.brc3_type[x1_lane] = srio_data_ins[x1_lane].brc3_type;
      gen3_align_data_ins.brc3_cw[x1_lane] = srio_data_ins[x1_lane].brc3_cw;
      gen3_align_data_ins.brc3_cc_type[x1_lane] = srio_data_ins[x1_lane].brc3_cc_type;

    end //}

    x1_lane_data_valid = 1;

    if (rx_dh_env_config.srio_mode != SRIO_GEN30)
    begin //{

      if (rx_dh_trans.x2_mode_delimiter)
      begin //{
	x2_delimiter_detected = 1;
	cntl_symbol_open = 1;
	prev_cntl_symbol_open = 0;
	cntl_symbol_bytes = 0;
      end //}

      if (x2_delimiter_detected)
      begin //{
        rx_dh_trans.x2_mode_delimiter=0;
        rx_dh_trans.num_cg_bet_status_cs_cnt = 0;

	if (~rx_dh_trans.idle_selected)
	begin //{
	  x2_delimiter_detected = 0;	// CS will complete in 2 columns including the delimiter for SCS.
	end //}
	else if (rx_dh_trans.idle_selected)
	begin //{
	  cs_char_cnt++;
	  if (cs_char_cnt == 3)
	    x2_delimiter_detected = 0;	// CS will complete in 4 columns including the delimiter for LCS.
	end //}

	if (~x2_delimiter_detected)
	  cntl_symbol_open = 0;

        continue;

      end //}

      if (((x1_lane_data.character == SRIO_SC || x1_lane_data.character == SRIO_PD) && x1_lane_data.cntl) || cntl_symbol_open || packet_open)
      begin //{

        if (((x1_lane_data.character == SRIO_SC || x1_lane_data.character == SRIO_PD) && x1_lane_data.cntl) && ~cntl_symbol_open)
        begin //{

          cntl_symbol_open = 1;
          cntl_symbol_bytes = cntl_symbol_bytes+1;

          //if (~bfm_or_mon && ~mon_type)
          //  $display($time, " 1. cntl_sym_disp : received byte is %0h, cntl is %0d", x1_lane_data.character, x1_lane_data.cntl);

          srio_trans_cs_ins = new();
          srio_trans_cs_ins.transaction_kind = SRIO_CS;

      	if (~rx_dh_trans.idle_selected)
      	  srio_trans_cs_ins.cstype = CS24;
      	else
      	  srio_trans_cs_ins.cstype = CS48;

          if (x1_lane_data.character == SRIO_SC)
            srio_trans_cs_ins.cs_kind = SRIO_DELIM_SC;
          else if (x1_lane_data.character == SRIO_PD)
          begin //{

            srio_trans_cs_ins.cs_kind = SRIO_DELIM_PD;

            if (packet_open)
            begin //{

              srio_trans_pkt_ins.bytestream = new[packet_bytes] (rx_dh_trans.bytestream);

              packet_open = 0;
              packet_bytes = 0;

	      packet_ended = 1;

              //$cast(cloned_srio_trans_pkt_ins, srio_trans_pkt_ins.clone());
       // 	    cloned_srio_trans_pkt_ins = new srio_trans_pkt_ins;
       //       rx_dh_trans.pl_rx_srio_trans_q.push_back(cloned_srio_trans_pkt_ins);

            end //}
            //else
            //  packet_open = 1;

          end //}

        end //}
        else if (cntl_symbol_open)
        begin //{

          cntl_symbol_bytes = cntl_symbol_bytes+1;

          //if (~bfm_or_mon && ~mon_type)
          //  $display($time, " 2. cntl_sym_disp : received byte is %0h, cntl is %0d", x1_lane_data.character, x1_lane_data.cntl);

          if (cntl_symbol_bytes == 2)
          begin //{

            if (~rx_dh_trans.idle_selected)
            begin //{
              srio_trans_cs_ins.stype0 = x1_lane_data.character[7:5];
              srio_trans_cs_ins.param0 = x1_lane_data.character[4:0];
            end //}
            else
            begin //{
              srio_trans_cs_ins.stype0 = x1_lane_data.character[7:5];
              srio_trans_cs_ins.param0[6:10] = x1_lane_data.character[4:0];
            end //}

          end //}
          else if (cntl_symbol_bytes == 3)
          begin //{

            if (~rx_dh_trans.idle_selected)
            begin //{
              srio_trans_cs_ins.param1 = x1_lane_data.character[7:3];
              srio_trans_cs_ins.stype1 = x1_lane_data.character[2:0];
            end //}
            else
            begin //{
              srio_trans_cs_ins.param0[11] = x1_lane_data.character[7];
              srio_trans_cs_ins.param1 = x1_lane_data.character[6:1];

              srio_trans_cs_ins.stype1[0] = x1_lane_data.character[0];
            end //}

      	    if (srio_trans_cs_ins.stype0 == 4'b0011 && ~bfm_or_mon)
      	    begin //{

      	      timestamp_start_flag = srio_trans_cs_ins.param0[7];
      	      timestamp_end_flag = srio_trans_cs_ins.param0[8];

	      if (rx_dh_trans.timestamp_support && ~rx_dh_trans.timestamp_master)
      	        timestamp_cs_cnt++;

      	      if (timestamp_cs_cnt == 1 && ~timestamp_start_flag)
      	      begin //{
      	    	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : TIMESTAMP_SEQ_NO_START_FLAG_CHECK", $sformatf(" Spec reference 6.5.3.5. Start flag is not set in the first control symbol of timestamp sequence."))
      	      end //}
      	      else if (timestamp_cs_cnt > 1 && timestamp_cs_cnt < 8 && timestamp_start_flag)
      	      begin //{
      	    	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : TIMESTAMP_SEQ_START_FLAG_CHECK", $sformatf(" Spec reference 6.5.3.5. Start flag is set in control symbol no. %0d of timestamp sequence.", timestamp_cs_cnt))
      	      end //}
      	      else if (timestamp_cs_cnt > 1 && timestamp_cs_cnt < 8 && timestamp_end_flag)
      	      begin //{
      	    	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : TIMESTAMP_SEQ_END_FLAG_CHECK", $sformatf(" Spec reference 6.5.3.5. End flag is set in control symbol no. %0d of timestamp sequence.", timestamp_cs_cnt))
      	      end //}
      	      else if (timestamp_cs_cnt == 8 && ~timestamp_end_flag)
      	      begin //{
      	    	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : TIMESTAMP_SEQ_NO_END_FLAG_CHECK", $sformatf(" Spec reference 6.5.3.5. End flag is not set in the last control symbol of timestamp sequence."))
      	      end //}

              if (~bfm_or_mon && timestamp_cs_cnt == 1 && timestamp_start_flag)
              begin //{
                rx_dh_common_mon_trans.timestamp_seq_started[mon_type] = 1;
              end //}
              else if (~bfm_or_mon && timestamp_cs_cnt == 8 && timestamp_end_flag)
              begin //{
	  	-> rx_dh_trans.rcvd_uninterrupted_timestamp_cs;
                rx_dh_common_mon_trans.timestamp_seq_completed[mon_type] = 1;
                timestamp_cs_cnt = 0;
              end //}

      	    end //}
      	    else if (srio_trans_cs_ins.stype0 != 4'b0011 && ~bfm_or_mon)
      	    begin //{

      	      if (rx_dh_common_mon_trans.timestamp_seq_started[mon_type] && ~rx_dh_common_mon_trans.timestamp_seq_completed[mon_type])
      	      begin //{

	    	-> rx_dh_trans.rcvd_interrupted_timestamp_cs;

      	    	`uvm_error("SRIO_PL_PROTOCOL_CHECKER : INCOMPLETE_TIMESTAMP_SEQ_CHECK", $sformatf(" Spec reference 6.5.3.5. Timestamp sequence shall not be truncated by any other control symbols. No. of timestamp control symbols received when it is truncated is %0d.", timestamp_cs_cnt))
      	        rx_dh_common_mon_trans.timestamp_seq_started[mon_type] = 0;
      	        rx_dh_common_mon_trans.timestamp_seq_completed[mon_type] = 1;
      	        timestamp_cs_cnt = 0;

      	      end //}

      	    end //}

          end //}
          else if (cntl_symbol_bytes == 4)
          begin //{

            if (~rx_dh_trans.idle_selected)
            begin //{

              srio_trans_cs_ins.cmd = x1_lane_data.character[7:5];
              srio_trans_cs_ins.cs_crc5 = x1_lane_data.character[4:0];
              cntl_symbol_open = 0;
              cntl_symbol_bytes = 0;

              if (brc12_stype1_type'(srio_trans_cs_ins.stype1) == SOP && srio_trans_cs_ins.cs_kind == SRIO_DELIM_PD)
              begin //{
                packet_open = 1;
		sop_received = 1;
		if (packet_ended)
		begin //{
      		  cloned_srio_trans_pkt_ins = new srio_trans_pkt_ins;
		  rx_dh_trans.pl_rx_srio_trans_q.push_back(cloned_srio_trans_pkt_ins);
	  	  if (~bfm_or_mon)
	  	  begin //{
	  	    rx_dh_common_mon_trans.packet_rx_in_progress[mon_type] = 0;
	  	  end //}
		end //}
              end //}

      	      if (packet_ended)
		packet_ended = 0;

      	      if ((brc12_stype1_type'(srio_trans_cs_ins.stype1) != STOMP && brc12_stype1_type'(srio_trans_cs_ins.stype1) != LINK_REQ && brc12_stype1_type'(srio_trans_cs_ins.stype1) != RFR) && srio_trans_cs_ins.cs_kind == SRIO_DELIM_PD && ~packet_open)
      	      begin //{

      	        if (sop_received && brc12_stype1_type'(srio_trans_cs_ins.stype1) == EOP)
      	        begin //{
      	          sop_received = 0;
      	      	  cloned_srio_trans_pkt_ins = new srio_trans_pkt_ins;
      	          rx_dh_trans.pl_rx_srio_trans_q.push_back(cloned_srio_trans_pkt_ins);
	  	  if (~bfm_or_mon)
	  	  begin //{
	  	    rx_dh_common_mon_trans.packet_rx_in_progress[mon_type] = 0;
	  	  end //}
      	        end //}
      	        else if (~sop_received && brc12_stype1_type'(srio_trans_cs_ins.stype1) == EOP && ~bfm_or_mon)
      	        begin //{
      	      	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : EOP_WITHOUT_SOP", $sformatf(" Spec reference 3.5.3. EOP control symbol received when no packet is in progress."))
      	        end //}

      	      end //}
      	      else if (brc12_stype1_type'(srio_trans_cs_ins.stype1) == STOMP && srio_trans_cs_ins.cs_kind == SRIO_DELIM_PD && ~packet_open)
      	      begin //{
		if (sop_received)
		begin //{
		  sop_received = 0;
	  	  if (~bfm_or_mon)
	  	  begin //{
	  	    rx_dh_common_mon_trans.packet_rx_in_progress[mon_type] = 0;
                    if(~rx_dh_common_mon_trans.outstanding_rfr[mon_type]  && ~rx_dh_common_mon_trans.oes_state_detected[~mon_type] && ~rx_dh_trans.ies_state)
                     begin//{
                      rx_dh_common_mon_trans.outstanding_retry[mon_type]=1;
                      rx_dh_common_mon_trans.outstanding_rfr[mon_type]=1;
                     end//}
	  	  end //}
	  	end //}
		else if (~bfm_or_mon)
      	         begin //{
      	          `uvm_error("SRIO_PL_PROTOCOL_CHECKER : STOMP_WITHOUT_PACKET", $sformatf(" Spec reference 3.5.2. STOMP control symbol received when no packet is in progress."))
      	           if (~rx_dh_trans.ies_state && rx_dh_trans.link_initialized)
      	           begin //{
      	             rx_dh_trans.ies_state = 1;
      	             rx_dh_trans.ies_cause_value = 5;
      	             //$display($time, " 7_1. Vaidhy : ies_state set here");
      	           end //}
      	         end //}
      	      end //}
      	      else if (brc12_stype1_type'(srio_trans_cs_ins.stype1) == LINK_REQ && srio_trans_cs_ins.cs_kind == SRIO_DELIM_PD && ~packet_open)
      	      begin //{
		if (sop_received)
		begin //{
		  sop_received = 0;
	  	  if (~bfm_or_mon)
	  	  begin //{
	  	    rx_dh_common_mon_trans.packet_rx_in_progress[mon_type] = 0;
	  	  end //}
	  	end //}
		else if (~bfm_or_mon)
      	          `uvm_error("SRIO_PL_PROTOCOL_CHECKER : LINK_REQ_IN_PD_DELIMITER_WITHOUT_PACKET", $sformatf(" Spec reference 3.5.5. LINK-REQUEST control symbol received with PD delimiter when no packet is in progress."))
      	      end //}
      	      else if (brc12_stype1_type'(srio_trans_cs_ins.stype1) == RFR && srio_trans_cs_ins.cs_kind == SRIO_DELIM_PD && ~packet_open)
      	      begin //{
		if (sop_received)
		begin //{
		  sop_received = 0;
	  	  if (~bfm_or_mon)
	  	  begin //{
	  	    rx_dh_common_mon_trans.packet_rx_in_progress[mon_type] = 0;
	  	  end //}
	  	end //}
		else if (~bfm_or_mon)
      	          `uvm_error("SRIO_PL_PROTOCOL_CHECKER : RFR_IN_PD_DELIMITER_WITHOUT_PACKET", $sformatf(" Spec reference 3.5.5. Restart-from-Retry control symbol received with PD delimiter when no packet is in progress."))
      	      end //}

              //$cast(cloned_srio_trans_cs_ins, srio_trans_cs_ins.clone());
              cloned_srio_trans_cs_ins = new srio_trans_cs_ins;
              rx_dh_trans.pl_rx_srio_trans_q.push_back(cloned_srio_trans_cs_ins);

            end //}
            else
            begin //{

              srio_trans_cs_ins.stype1[1:2] = x1_lane_data.character[7:6];
              srio_trans_cs_ins.cmd = x1_lane_data.character[5:3];

              if (brc12_stype1_type'(srio_trans_cs_ins.stype1) == SOP && srio_trans_cs_ins.cs_kind == SRIO_DELIM_PD)
              begin //{
                packet_open = 1;
		sop_received = 1;
		if (packet_ended)
		begin //{
      		  cloned_srio_trans_pkt_ins = new srio_trans_pkt_ins;
		  rx_dh_trans.pl_rx_srio_trans_q.push_back(cloned_srio_trans_pkt_ins);
	  	  if (~bfm_or_mon)
	  	  begin //{
	  	    rx_dh_common_mon_trans.packet_rx_in_progress[mon_type] = 0;
	  	  end //}
		end //}
              end //}

      	      if (packet_ended)
		packet_ended = 0;

      	      if ((brc12_stype1_type'(srio_trans_cs_ins.stype1) != STOMP && brc12_stype1_type'(srio_trans_cs_ins.stype1) != LINK_REQ && brc12_stype1_type'(srio_trans_cs_ins.stype1) != RFR) && srio_trans_cs_ins.cs_kind == SRIO_DELIM_PD && ~packet_open)
      	      begin //{

      	        if (sop_received && brc12_stype1_type'(srio_trans_cs_ins.stype1) == EOP)
      	        begin //{
      	          sop_received = 0;
      	      	  cloned_srio_trans_pkt_ins = new srio_trans_pkt_ins;
      	          rx_dh_trans.pl_rx_srio_trans_q.push_back(cloned_srio_trans_pkt_ins);
	  	  if (~bfm_or_mon)
	  	  begin //{
	  	    rx_dh_common_mon_trans.packet_rx_in_progress[mon_type] = 0;
	  	  end //}
      	        end //}
      	        else if (~sop_received && brc12_stype1_type'(srio_trans_cs_ins.stype1) == EOP && ~bfm_or_mon)
      	        begin //{
      	      	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : EOP_WITHOUT_SOP", $sformatf(" Spec reference 3.5.3. EOP control symbol received when no packet is in progress."))
      	        end //}

      	      end //}
      	      else if (brc12_stype1_type'(srio_trans_cs_ins.stype1) == STOMP && srio_trans_cs_ins.cs_kind == SRIO_DELIM_PD && ~packet_open)
      	      begin //{
		if (sop_received)
		begin //{
		  sop_received = 0;
	  	  if (~bfm_or_mon)
	  	  begin //{
	  	    rx_dh_common_mon_trans.packet_rx_in_progress[mon_type] = 0;
                    if(~rx_dh_common_mon_trans.outstanding_rfr[mon_type]  && ~rx_dh_common_mon_trans.oes_state_detected[~mon_type]&& ~rx_dh_trans.ies_state)
                     begin//{
                      rx_dh_common_mon_trans.outstanding_retry[mon_type]=1;
                      rx_dh_common_mon_trans.outstanding_rfr[mon_type]=1;
                     end//}
	  	  end //}
	  	end //}
		else if (~bfm_or_mon)
                 begin//{
      	          `uvm_error("SRIO_PL_PROTOCOL_CHECKER : STOMP_WITHOUT_PACKET", $sformatf(" Spec reference 3.5.2. STOMP control symbol received when no packet is in progress."))
      	           if (~rx_dh_trans.ies_state && rx_dh_trans.link_initialized)
      	           begin //{
      	             rx_dh_trans.ies_state = 1;
      	             rx_dh_trans.ies_cause_value = 5;
      	             //$display($time, " 8_1. Vaidhy : ies_state set here");
      	           end //}
      	         end //}
      	      end //}
      	      else if (brc12_stype1_type'(srio_trans_cs_ins.stype1) == LINK_REQ && srio_trans_cs_ins.cs_kind == SRIO_DELIM_PD && ~packet_open)
      	      begin //{
		if (sop_received)
		begin //{
		  sop_received = 0;
	  	  if (~bfm_or_mon)
	  	  begin //{
	  	    rx_dh_common_mon_trans.packet_rx_in_progress[mon_type] = 0;
	  	  end //}
	  	end //}
		else if (~bfm_or_mon)
      	          `uvm_error("SRIO_PL_PROTOCOL_CHECKER : LINK_REQ_IN_PD_DELIMITER_WITHOUT_PACKET", $sformatf(" Spec reference 3.5.5. LINK-REQUEST control symbol received with PD delimiter when no packet is in progress."))
      	      end //}
      	      else if (brc12_stype1_type'(srio_trans_cs_ins.stype1) == RFR && srio_trans_cs_ins.cs_kind == SRIO_DELIM_PD && ~packet_open)
      	      begin //{
		if (sop_received)
		begin //{
		  sop_received = 0;
	  	  if (~bfm_or_mon)
	  	  begin //{
	  	    rx_dh_common_mon_trans.packet_rx_in_progress[mon_type] = 0;
	  	  end //}
	  	end //}
		else if (~bfm_or_mon)
      	          `uvm_error("SRIO_PL_PROTOCOL_CHECKER : RFR_IN_PD_DELIMITER_WITHOUT_PACKET", $sformatf(" Spec reference 3.5.5. Restart-from-Retry control symbol received with PD delimiter when no packet is in progress."))
      	      end //}

            end //}

          end //}
          else if (cntl_symbol_bytes == 6)
          begin //{

            srio_trans_cs_ins.cs_crc13[0:4] = x1_lane_data.character[4:0];

          end //}
          else if (cntl_symbol_bytes == 7)
          begin //{

            srio_trans_cs_ins.cs_crc13[5:12] = x1_lane_data.character;

          end //}
          else if (cntl_symbol_bytes == 8)
          begin //{

            cntl_symbol_open = 0;
            cntl_symbol_bytes = 0;

        	 // $cast(cloned_srio_trans_cs_ins, srio_trans_cs_ins.clone());
        	  cloned_srio_trans_cs_ins = new srio_trans_cs_ins;
        	  rx_dh_trans.pl_rx_srio_trans_q.push_back(cloned_srio_trans_cs_ins);

          //if (~bfm_or_mon && ~mon_type)
          //  $display($time, " cs trans pushed into queue");

          end //}

        end //}
        else if (packet_open)
        begin //{

          packet_bytes = packet_bytes+1;

          if (packet_bytes == 1)
          begin //{

            srio_trans_pkt_ins = new();
            srio_trans_pkt_ins.transaction_kind = SRIO_PACKET;
            rx_dh_trans.bytestream = new[rx_dh_config.max_pkt_size]; // max packet size is 276

          end //}

      	if (packet_bytes<=rx_dh_config.max_pkt_size)
      	begin //{

            rx_dh_trans.bytestream[packet_bytes-1] = x1_lane_data.character;

            if (packet_bytes == 1)
            begin //{
              if (rx_dh_trans.idle_selected && bfm_or_mon)
                rx_dh_env_config.current_ack_id = x1_lane_data.character[7:2];
              else if (~rx_dh_trans.idle_selected && bfm_or_mon)
                rx_dh_env_config.current_ack_id = x1_lane_data.character[7:3];

              if (bfm_or_mon)
                ->rx_dh_env_config.packet_rx_started;

	      if (~bfm_or_mon)
	      begin //{
	        rx_dh_common_mon_trans.packet_rx_in_progress[mon_type] = 1;
	  	if (rx_dh_trans.idle_selected)
	  	  rx_dh_common_mon_trans.pkt_in_progress_ack_id[mon_type] = x1_lane_data.character[7:2];
	  	else if (~rx_dh_trans.idle_selected)
	  	  rx_dh_common_mon_trans.pkt_in_progress_ack_id[mon_type] = x1_lane_data.character[7:3];
	      end //}

            end //}

      	end //}
      	else
      	begin //{
      	  pkt_size_err();
      	end //}

      	check_pkt_char(0);

        end //}

        if (cntl_symbol_open || prev_cntl_symbol_open)
          control_symbol_check(0);

  	if (prev_cntl_symbol_open && ~cntl_symbol_open)
  	begin //{
  	  link_init_srio_trans_cs_ins = new srio_trans_cs_ins;
  	  if (rx_dh_trans.idle_detected && ~rx_dh_trans.idle_selected)
  	  begin //{
  	    if (srio_trans_cs_ins.cs_crc5 != link_init_srio_trans_cs_ins.calccrc5(link_init_srio_trans_cs_ins.pack_cs()))
  	      link_init_cntl_symbol_err = 1;
  	  end //}
  	  else if (rx_dh_trans.idle_detected && rx_dh_trans.idle_selected)
  	  begin //{
  	    if (srio_trans_cs_ins.cs_crc13 != link_init_srio_trans_cs_ins.calccrc13(link_init_srio_trans_cs_ins.pack_cs()))
  	      link_init_cntl_symbol_err = 1;
  	  end //}
  	end //}

        if (pkt_size_err_reported && ~cntl_symbol_open && ~packet_open)
          pkt_size_err_reported = 0;

        if (rx_dh_trans.port_initialized && (prev_cntl_symbol_open && ~cntl_symbol_open))
        begin //{

          //if (~bfm_or_mon)
          //  $display($time, " vaidhy : mon_type is %0d, rx_dh_common_mon_trans.link_initialized[%0d] is %0d, rx_dh_common_mon_trans.link_initialized[%0d] is %0d", mon_type, ~mon_type, rx_dh_common_mon_trans.link_initialized[~mon_type], mon_type, rx_dh_common_mon_trans.link_initialized[mon_type]);

          if (bfm_or_mon && ~rx_dh_trans.link_initialized)
            set_link_initialization();
          else if (~bfm_or_mon && (~rx_dh_common_mon_trans.link_initialized[mon_type] || ~rx_dh_common_mon_trans.link_initialized[~mon_type]))
            set_link_initialization();
        end //}

        prev_cntl_symbol_open = cntl_symbol_open;

      end //}
      else if (~cntl_symbol_open && ~packet_open && ~bfm_or_mon)
      begin //{
      
        if (rx_dh_common_mon_trans.timestamp_seq_started[mon_type] && ~rx_dh_common_mon_trans.timestamp_seq_completed[mon_type])
        begin //{
      
	  -> rx_dh_trans.rcvd_interrupted_timestamp_cs;

          `uvm_error("SRIO_PL_PROTOCOL_CHECKER : INCOMPLETE_TIMESTAMP_SEQ_CHECK", $sformatf(" Spec reference 6.5.3.5. Timestamp sequence shall not be truncated by IDLE sequence. No. of timestamp control symbols received when it is truncated is %0d.", timestamp_cs_cnt))
          rx_dh_common_mon_trans.timestamp_seq_started[mon_type] = 0;
          rx_dh_common_mon_trans.timestamp_seq_completed[mon_type] = 1;
          timestamp_cs_cnt = 0;
      
        end //}
      
      end //}

    end //}
    else
    begin //{

      if (((gen3_align_data_ins.brc3_cntl_cw_type[x1_lane] == CSB || gen3_align_data_ins.brc3_cntl_cw_type[x1_lane] == CSE || gen3_align_data_ins.brc3_cntl_cw_type[x1_lane] == CSEB) && ~gen3_align_data_ins.brc3_type[x1_lane]) || cntl_symbol_open || packet_open)
        form_gen3_srio_trans(x1_lane);
      else
      begin //{

	if (~bfm_or_mon)
	begin //{

	  rx_dh_common_mon_trans.xmting_idle[~mon_type] = 1;

          if (rx_dh_common_mon_trans.timestamp_seq_started[mon_type] && ~rx_dh_common_mon_trans.timestamp_seq_completed[mon_type])
          begin //{
      
	    -> rx_dh_trans.rcvd_interrupted_timestamp_cs;

            `uvm_error("SRIO_PL_PROTOCOL_CHECKER : INCOMPLETE_TIMESTAMP_SEQ_CHECK", $sformatf(" Spec reference 6.5.3.5. Timestamp sequence shall not be truncated by IDLE sequence. No. of timestamp control symbols received when it is truncated is %0d.", timestamp_cs_cnt))
            rx_dh_common_mon_trans.timestamp_seq_started[mon_type] = 0;
            rx_dh_common_mon_trans.timestamp_seq_completed[mon_type] = 1;
            timestamp_cs_cnt = 0;
      
          end //}

        end //}

      end //}

        if (rx_dh_trans.port_initialized && (prev_cntl_symbol_open && ~cntl_symbol_open))
	begin //{
	  if (bfm_or_mon && ~rx_dh_trans.link_initialized)
            set_link_initialization();
	  else if (~bfm_or_mon && (~rx_dh_common_mon_trans.link_initialized[mon_type] || ~rx_dh_common_mon_trans.link_initialized[~mon_type]))
            set_link_initialization();
	end //}

        prev_cntl_symbol_open = cntl_symbol_open;

    end //}

  end //}

endtask : form_1x_srio_trans



//////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : clear_link_initialization
/// Description : Whenever the port_initialization is de-asserted, the link initialization should also 
/// be de-asserted. This method takes care of it. While clearing the link initialization, this method also 
/// clears the tx and rx status control symbol count.
//////////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::clear_link_initialization();

  rx_dh_trans.link_initialized = 0;

  rx_dh_trans.tx_status_cs_cnt = 0;
  rx_dh_trans.rx_status_cs_cnt = 0;

  if (bfm_or_mon)
    rx_dh_env_config.link_initialized = 0;

  if (~bfm_or_mon)
  begin //{

    if (mon_type)
    begin //{
      rx_dh_common_mon_trans.tx_mon_status_cs_cnt = 0;
      rx_dh_env_config.pl_mon_tx_link_initialized = 0;
    end //}
    else
    begin //{
      rx_dh_common_mon_trans.rx_mon_status_cs_cnt = 0;
      rx_dh_env_config.pl_mon_rx_link_initialized = 0;
    end //}

    rx_dh_common_mon_trans.link_initialized[mon_type] = 1;
    rx_dh_common_mon_trans.clear_status_cs_cnt[mon_type] = 1;

    rx_dh_common_mon_trans.link_initialized[mon_type] = 0;
    rx_dh_common_mon_trans.clear_status_cs_cnt[mon_type] = 0;

  end //}

  forever begin //{

    @(rx_dh_trans.port_initialized);

    if (~rx_dh_trans.port_initialized)
    begin //{

      rx_dh_trans.link_initialized = 0;

      rx_dh_trans.tx_status_cs_cnt = 0;
      rx_dh_trans.rx_status_cs_cnt = 0;

      link_init_cntl_symbol_err = 0;

      if (bfm_or_mon)
        rx_dh_env_config.link_initialized = 0;

      if (~bfm_or_mon)
      begin //{

        if (mon_type)
	begin //{
          rx_dh_common_mon_trans.tx_mon_status_cs_cnt = 0;
          rx_dh_env_config.pl_mon_tx_link_initialized = 0;
	end //}
        else
	begin //{
          rx_dh_common_mon_trans.rx_mon_status_cs_cnt = 0;
          rx_dh_env_config.pl_mon_rx_link_initialized = 0;
	end //}

        rx_dh_common_mon_trans.link_initialized[mon_type] = 0;
        rx_dh_common_mon_trans.clear_status_cs_cnt[mon_type] = 0;

      end //}

    end //}

  end //}

endtask : clear_link_initialization



//////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : set_link_initialization
/// Description : This method counts the number of status control symbols transmitted and received,
/// and as per protocol, it sets the link_initialized bit based on the count.
/// The monitor instance of this class, will check the status control symbol count from the other monitor,
/// through the rx_dh_common_mon_trans, which will be used for setting the link_initialized variable.
//////////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::set_link_initialization();

	//$display($time, " : bfm_or_mon is %0d, mon_type is %0d. Inside set_link_initialization. stype0 is %0d", bfm_or_mon, mon_type, srio_trans_cs_ins.stype0);
  if (link_init_cntl_symbol_err)
  begin //{
    link_init_cntl_symbol_err = 0;
    return;
  end //}

  if (brc12_stype0_type'(srio_trans_cs_ins.stype0) == STATUS)
  begin //{

    if (bfm_or_mon)
    begin //{

      rx_dh_trans.rx_status_cs_cnt++;

      if (rx_dh_trans.rx_status_cs_cnt >= 7 && rx_dh_trans.tx_status_cs_cnt >= 15)
      begin //{
        rx_dh_trans.link_initialized = 1;
        rx_dh_env_config.link_initialized = 1;
        `uvm_info(" SRIO_PL_RX_DATA_HANDLER : LINK_INIT", $sformatf(" Link is initialized"), UVM_LOW)
      end //}

      //`uvm_info(" SRIO_PL_RX_DATA_HANDLER : BFM_LINK_INIT", $sformatf(" rx_status_cs_cnt is %0d, tx_status_cs_cnt is %0d", rx_dh_trans.rx_status_cs_cnt, rx_dh_trans.tx_status_cs_cnt), UVM_LOW)

    end //}
    else if (mon_type)
    begin //{

      // error free status control symbol has to be received and
      // then only link_init procedure has to be started. clear_status_cs_cnt
      // logic will taske care of it.

	//$display($time, " rx_dh_common_mon_trans.port_initialized[%0d] is %0d", ~mon_type, rx_dh_common_mon_trans.port_initialized[~mon_type]);
      if (rx_dh_common_mon_trans.port_initialized[~mon_type])
      begin //{

	if (rx_dh_trans.tx_status_cs_cnt==0 && rx_dh_common_mon_trans.rx_mon_status_cs_cnt>0 && $time>rx_dh_common_mon_trans.current_time[mon_type])
	begin //{
	  rx_dh_common_mon_trans.clear_status_cs_cnt[~mon_type] = 1;
	end //}

	if (rx_dh_common_mon_trans.clear_status_cs_cnt[mon_type])
	begin //{
	  rx_dh_common_mon_trans.clear_status_cs_cnt[mon_type] = 0;
	  rx_dh_common_mon_trans.tx_mon_status_cs_cnt = 0;
	end //}

        rx_dh_trans.tx_status_cs_cnt++;
        rx_dh_common_mon_trans.tx_mon_status_cs_cnt++;

	// current_time is used to check if status control symbol is received
	// on the same time in both the monitor instances.
	rx_dh_common_mon_trans.current_time[~mon_type] = $time;

      end //}

      if ((rx_dh_common_mon_trans.rx_mon_status_cs_cnt >= 15 && rx_dh_common_mon_trans.clear_status_cs_cnt[~mon_type] == 0) && rx_dh_trans.tx_status_cs_cnt >= 7 && ~rx_dh_trans.link_initialized)
      begin //{
        rx_dh_trans.link_initialized = 1;
        rx_dh_common_mon_trans.link_initialized[mon_type] = 1;
        rx_dh_env_config.pl_mon_tx_link_initialized = 1;
        `uvm_info(" SRIO_PL_RX_DATA_HANDLER : LINK_INIT", $sformatf(" Link is initialized"), UVM_LOW)
      end //}

      //`uvm_info(" SRIO_PL_RX_DATA_HANDLER : TX_MON_LINK_INIT", $sformatf(" rx_status_cs_cnt is %0d, tx_status_cs_cnt is %0d", rx_dh_common_mon_trans.rx_mon_status_cs_cnt, rx_dh_trans.tx_status_cs_cnt), UVM_LOW)

    end //}
    else if (~mon_type)
    begin //{

      // error free status control symbol has to be received and
      // then only link_init procedure has to be started. clear_status_cs_cnt
      // logic will taske care of it.

	//$display($time, " rx_dh_common_mon_trans.port_initialized[%0d] is %0d", ~mon_type, rx_dh_common_mon_trans.port_initialized[~mon_type]);
      if (rx_dh_common_mon_trans.port_initialized[~mon_type])
      begin //{

	if (rx_dh_trans.rx_status_cs_cnt==0 && rx_dh_common_mon_trans.tx_mon_status_cs_cnt>0 && $time>rx_dh_common_mon_trans.current_time[mon_type])
	begin //{
	  rx_dh_common_mon_trans.clear_status_cs_cnt[~mon_type] = 1;
	end //}

	if (rx_dh_common_mon_trans.clear_status_cs_cnt[mon_type])
	begin //{
	  rx_dh_common_mon_trans.clear_status_cs_cnt[mon_type] = 0;
	  rx_dh_common_mon_trans.rx_mon_status_cs_cnt = 0;
	end //}

        rx_dh_trans.rx_status_cs_cnt++;
        rx_dh_common_mon_trans.rx_mon_status_cs_cnt++;

	rx_dh_common_mon_trans.current_time[~mon_type] = $time;

      end //}

      if ((rx_dh_common_mon_trans.tx_mon_status_cs_cnt >= 15 && rx_dh_common_mon_trans.clear_status_cs_cnt[~mon_type] == 0) && rx_dh_trans.rx_status_cs_cnt >= 7 && ~rx_dh_trans.link_initialized)
      begin //{
        rx_dh_trans.link_initialized = 1;
        rx_dh_common_mon_trans.link_initialized[mon_type] = 1;
        rx_dh_env_config.pl_mon_rx_link_initialized = 1;
        `uvm_info(" SRIO_PL_RX_DATA_HANDLER : LINK_INIT", $sformatf(" Link is initialized"), UVM_LOW)
      end //}

      //`uvm_info(" SRIO_PL_RX_DATA_HANDLER : RX_MON_LINK_INIT", $sformatf(" rx_status_cs_cnt is %0d, tx_status_cs_cnt is %0d", rx_dh_trans.rx_status_cs_cnt, rx_dh_common_mon_trans.tx_mon_status_cs_cnt), UVM_LOW)

    end //}

  end //}

endtask : set_link_initialization




/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : link_init_check_trigger
/// Description : set_link_initialization method is called only when a status control symbol is received in that
/// particular instance (bfm_or_mon/mon_type). So, it'll miss if its dependent variable is updated by the other instance.
/// To take care of such scenario, link_init_check_trigger method is defined. This method will wait for the instance
/// specific dependent variable to get updated, and then checks for the link init condition.
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::link_init_check_trigger();

  if (~bfm_or_mon)
  begin //{
    rx_dh_common_mon_trans.current_time[mon_type] = 1;
    rx_dh_common_mon_trans.current_time[mon_type] = 0;
  end //}

  forever begin //{

    if (bfm_or_mon)
    begin //{

      @(rx_dh_trans.tx_status_cs_cnt);

      if (rx_dh_trans.rx_status_cs_cnt >= 7 && rx_dh_trans.tx_status_cs_cnt >= 15)
      begin //{
        rx_dh_trans.link_initialized = 1;
        rx_dh_env_config.link_initialized = 1;
        `uvm_info(" SRIO_PL_RX_DATA_HANDLER : LINK_INIT", $sformatf(" Link is initialized"), UVM_LOW)
      end //}

      //`uvm_info(" SRIO_PL_RX_DATA_HANDLER : BFM_LINK_INIT", $sformatf(" rx_status_cs_cnt is %0d, tx_status_cs_cnt is %0d", rx_dh_trans.rx_status_cs_cnt, rx_dh_trans.tx_status_cs_cnt), UVM_LOW)

    end //}
    else if (mon_type)
    begin //{

      @(rx_dh_common_mon_trans.rx_mon_status_cs_cnt);

      if ((rx_dh_common_mon_trans.rx_mon_status_cs_cnt >= 15 && rx_dh_common_mon_trans.clear_status_cs_cnt[~mon_type] == 0) && rx_dh_trans.tx_status_cs_cnt >= 7 && ~rx_dh_trans.link_initialized)
      begin //{
        rx_dh_trans.link_initialized = 1;
        rx_dh_common_mon_trans.link_initialized[mon_type] = 1;
        rx_dh_env_config.pl_mon_tx_link_initialized = 1;
        `uvm_info(" SRIO_PL_RX_DATA_HANDLER : LINK_INIT", $sformatf(" Link is initialized"), UVM_LOW)
      end //}

      //`uvm_info(" SRIO_PL_RX_DATA_HANDLER : TX_MON_LINK_INIT", $sformatf(" rx_status_cs_cnt is %0d, tx_status_cs_cnt is %0d", rx_dh_common_mon_trans.rx_mon_status_cs_cnt, rx_dh_trans.tx_status_cs_cnt), UVM_LOW)

    end //}
    else
    begin //{

      @(rx_dh_common_mon_trans.tx_mon_status_cs_cnt);

      if ((rx_dh_common_mon_trans.tx_mon_status_cs_cnt >= 15 && rx_dh_common_mon_trans.clear_status_cs_cnt[~mon_type] == 0) && rx_dh_trans.rx_status_cs_cnt >= 7 && ~rx_dh_trans.link_initialized)
      begin //{
        rx_dh_trans.link_initialized = 1;
        rx_dh_common_mon_trans.link_initialized[mon_type] = 1;
        rx_dh_env_config.pl_mon_rx_link_initialized = 1;
        `uvm_info(" SRIO_PL_RX_DATA_HANDLER : LINK_INIT", $sformatf(" Link is initialized"), UVM_LOW)
      end //}

      //`uvm_info(" SRIO_PL_RX_DATA_HANDLER : RX_MON_LINK_INIT", $sformatf(" rx_status_cs_cnt is %0d, tx_status_cs_cnt is %0d", rx_dh_trans.rx_status_cs_cnt, rx_dh_common_mon_trans.tx_mon_status_cs_cnt), UVM_LOW)

    end //}

  end //}

endtask : link_init_check_trigger





////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : idle_seq_collect
/// Description : This method collects the idle1/2/3 sequence before and after port initialization.
/// Before port initialization, the method waits till idle detection to get completed(for non 3.0), after 
/// which idle sequence collect logic becomes active. Based on either nx_align_data_valid or x2_align_data_valid
/// or x1_lane_data_valid, the method collects the idle sequence from the active lanes and pushes it into
/// idle_seq_char queue on appropriate lane locations. Incase of GEN3.0, idle3_seq_cw_type and idle3_seq_cw
/// queues are used.
/// If the link partner gets initialized before the local port, then it would be transmitting status control
/// symbols. In such cases, the monitor which monitors the link partner's port will check the other monitor's
/// port initialized status to confirm if control symbols are not transmitted before port gets initialized.
/// If it finds that they are valid control symbols, it checks the initialized mode of the other monitor and
/// waits till the control symbol completes, and then proceeds with the idle sequence collection logic.
/// After port initialization, the port checks if cntl_symbol_open or packet_open variables are set. If set,
/// it waits till they are cleared, and then continues with the idle sequence collection logic.
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::idle_seq_collect();

  forever begin //{

    @(negedge srio_if.sim_clk);
	//if (~bfm_or_mon && ~mon_type)
	//$display($time, " After negedge sim_Clk");

    if (rx_dh_env_config.srio_mode != SRIO_GEN30)
      wait(rx_dh_trans.idle_detected == 1);

    if (~rx_dh_trans.port_initialized)
    begin //{

      if (packet_open || cntl_symbol_open)
      begin //{
	packet_open = 0;
	packet_bytes = 0;
	lcs_completed_in_same_column = 0;
        if(~x1_delimiter_detected)
         begin//{
	  cntl_symbol_open = 0;
	  cntl_symbol_bytes = 0;
	  local_cntl_symbol_open = 0;
         end//}
	end //}

      if (idle_seq_start_after_port_init_detected)
      begin //{
        idle_seq_start_after_port_init_detected = 0;
	nx_idle_seq_chk_in_progress = 0;
	x2_idle_seq_chk_in_progress = 0;
	x1_idle_seq_chk_in_progress = 0;
      end //}

      if (rx_dh_trans.nx_align_data_valid == 1)
      begin //{

	if (~nx_idle_seq_chk_in_progress)
	begin //{
	  if (idle_seq_start_detected)
	  begin //{
	    idle_seq_start_detected = 0;
	    idle_check_in_progress = 0;
	  end //}
	end //}

	nx_idle_seq_chk_in_progress = 1;

	if (rx_dh_env_config.srio_mode == SRIO_GEN30 && ~idle_seq_start_detected)
	begin //{

	  if(nx_align_data.brc3_cntl_cw_type[0] == SKIP_MARKER || nx_align_data.brc3_cntl_cw_type[0] == DESCR_SEED || nx_align_data.brc3_cntl_cw_type[0] == STATUS_CNTL)
	    gen3_ordered_seq_start_detected = 1;

	end //}

	if (rx_dh_env_config.srio_mode != SRIO_GEN30 && nx_align_data.character[0] == SRIO_K && nx_align_data.cntl[0] == 1 && ~idle_seq_start_detected)
        begin //{

	  for (int idle_seq_var = 0; idle_seq_var < rx_dh_env_config.num_of_lanes; idle_seq_var++)
	  begin //{

	    idle_seq_char[idle_seq_var].push_back(nx_align_data.character[idle_seq_var]);
	    idle_seq_cntl[idle_seq_var].push_back(nx_align_data.cntl[idle_seq_var]);

	    //if (~bfm_or_mon && mon_type)
	    //begin //{
	    //$display($time, " 10. _idle_check: nx_align_data.character[%0d] is %0h", idle_seq_var, nx_align_data.character[idle_seq_var]);
	    //$display($time, " 10. _idle_check: idle_seq_char[%0d][0] is %0h", idle_seq_var, idle_seq_char[idle_seq_var][0]);
	    //end //}
	  end //}

	  idle_seq_start_detected = 1;
	  perform_idle2_truncation_check = 1;

	end //}
	else if (rx_dh_env_config.srio_mode == SRIO_GEN30 && gen3_ordered_seq_start_detected && ~idle_seq_start_detected)
        begin //{

	  gen3_ordered_seq_start_detected = 0;

	  for (int idle_seq_var = 0; idle_seq_var < rx_dh_env_config.num_of_lanes; idle_seq_var++)
	  begin //{

	    idle3_seq_cw_type[idle_seq_var].push_back(nx_align_data.brc3_cntl_cw_type[idle_seq_var]);
	    idle3_seq_cw[idle_seq_var].push_back(nx_align_data.brc3_cw[idle_seq_var]);

	    //if (~bfm_or_mon && mon_type)
	    //begin //{
	    //$display($time, " 10. _idle_check: nx_align_data.character[%0d] is %0h", idle_seq_var, nx_align_data.character[idle_seq_var]);
	    //$display($time, " 10. _idle_check: idle_seq_char[%0d][0] is %0h", idle_seq_var, idle_seq_char[idle_seq_var][0]);
	    //end //}
	  end //}

	  idle_seq_start_detected = 1;
	  perform_idle3_truncation_check = 1;

	end //}
	else if (idle_seq_start_detected && rx_dh_env_config.srio_mode != SRIO_GEN30)
        begin //{

	  for (int idle_seq_var = 0; idle_seq_var < rx_dh_env_config.num_of_lanes; idle_seq_var++)
	  begin //{

	    if (~rx_dh_trans.idle_selected)
	    begin //{
	      if (local_cntl_symbol_open && idle_seq_var%4==0)
	        local_cntl_symbol_open = 0;
	    end //}
	    else if (sc_cnt%2 == 0) // In case of LCS, if sc_cnt is even, it means, end delimiter is received.
	    begin //{
	      local_cntl_symbol_open = 0;
	      sc_cnt = 0;
	    end //}

	    if (idle_seq_var%4==0)
	    begin //{

	      // if rx monitor is receiving control symbols before its port is initialized,
	      // then it could mean that the link partner is initialized. Hence, port_initialized[~mon_type]
	      // is checked.
	      if (~bfm_or_mon)
	      begin //{

		  //$display($time, " 12 : nx_align_data.character[%0d] is %0h, nx_align_data.cntl[%0d] is %0h, rx_dh_common_mon_trans.port_initialized[%0d] is %0d", idle_seq_var, nx_align_data.character[idle_seq_var], idle_seq_var, nx_align_data.cntl[idle_seq_var], ~mon_type, rx_dh_common_mon_trans.port_initialized[~mon_type]);
	        if (nx_align_data.character[idle_seq_var] == SRIO_SC && nx_align_data.cntl[idle_seq_var] == 1 && rx_dh_common_mon_trans.port_initialized[~mon_type] == 1)
	        begin //{
		  if (nx_align_data.character[idle_seq_var+1][7:5] == 3'b100)
		    rx_dh_trans.num_cg_bet_status_cs_cnt = 0;
	          local_cntl_symbol_open = 1;
	          if (rx_dh_trans.idle_selected)
	            sc_cnt++;
                end //}

	      end //}

	    end //}

	  end //}

	  if (local_cntl_symbol_open && rx_dh_trans.idle_selected && perform_idle2_truncation_check)
	  begin //{

	//	if (~bfm_or_mon && ~mon_type)
	//	  $display($time, " 1. idle2_truncation_check called from here");
	    perform_idle2_truncation_check = 0;
	    idle2_truncation_check();
	    continue;

	  end //}
	  else if (local_cntl_symbol_open && ~rx_dh_trans.idle_selected)
	  begin //{
	    idle_check_in_progress = 0;
	    continue;
	  end //}
	  
	  perform_idle2_truncation_check = 1;

	  for (int idle_seq_var = 0; idle_seq_var < rx_dh_env_config.num_of_lanes; idle_seq_var++)
	  begin //{

	    idle_seq_char[idle_seq_var].push_back(nx_align_data.character[idle_seq_var]);
	    idle_seq_cntl[idle_seq_var].push_back(nx_align_data.cntl[idle_seq_var]);

	    //if (~bfm_or_mon && ~mon_type)
	    //begin //{
	    //$display($time, " 11. _idle_check: nx_align_data.character[%0d] is %0h", idle_seq_var, nx_align_data.character[idle_seq_var]);
	    //$display($time, " 11. _idle_check: idle_seq_char[%0d][0] is %0h", idle_seq_var, idle_seq_char[idle_seq_var][0]);
	    //end //}
	  end //}

	end //}
	else if (idle_seq_start_detected && rx_dh_env_config.srio_mode == SRIO_GEN30)
        begin //{

	  for (int idle_seq_var = 0; idle_seq_var < rx_dh_env_config.num_of_lanes; idle_seq_var++)
	  begin //{

	    if (local_cntl_symbol_open && nx_align_data.brc3_cntl_cw_type[idle_seq_var] == CSE)
	      local_cntl_symbol_open = 0;

	    // if rx monitor is receiving control symbols before its port is initialized,
	    // then it could mean that the link partner is initialized. Hence, port_initialized[~mon_type]
	    // is checked.
	    if (~bfm_or_mon)
	    begin //{

	        //$display($time, " 12 : nx_align_data.character[%0d] is %0h, nx_align_data.cntl[%0d] is %0h, rx_dh_common_mon_trans.port_initialized[%0d] is %0d", idle_seq_var, nx_align_data.character[idle_seq_var], idle_seq_var, nx_align_data.cntl[idle_seq_var], ~mon_type, rx_dh_common_mon_trans.port_initialized[~mon_type]);
	      if (nx_align_data.brc3_cntl_cw_type[idle_seq_var] == CSB && rx_dh_common_mon_trans.port_initialized[~mon_type] == 1)
	      begin //{
	        local_cntl_symbol_open = 1;
              end //}

	    end //}

	  end //}

	  if (local_cntl_symbol_open && perform_idle3_truncation_check)
	  begin //{

	//	if (~bfm_or_mon && ~mon_type)
	//	  $display($time, " 1. idle2_truncation_check called from here");
	    perform_idle3_truncation_check = 0;
	    idle3_truncation_check();
	    continue;

	  end //}
	  else if (local_cntl_symbol_open)
	  begin //{
	    idle_check_in_progress = 0;
	    continue;
	  end //}
	  
	  perform_idle3_truncation_check = 1;

	  for (int idle_seq_var = 0; idle_seq_var < rx_dh_env_config.num_of_lanes; idle_seq_var++)
	  begin //{
             if(nx_align_data.brc3_cntl_cw_type[idle_seq_var] == CSB || nx_align_data.brc3_cntl_cw_type[idle_seq_var] == CSE) 
              begin
               break;
              end

	    idle3_seq_cw_type[idle_seq_var].push_back(nx_align_data.brc3_cntl_cw_type[idle_seq_var]);
	    idle3_seq_cw[idle_seq_var].push_back(nx_align_data.brc3_cw[idle_seq_var]);

	    //if (~bfm_or_mon && ~mon_type)
	    //begin //{
	    //$display($time, " 11. _idle_check: nx_align_data.character[%0d] is %0h", idle_seq_var, nx_align_data.character[idle_seq_var]);
	    //$display($time, " 11. _idle_check: idle_seq_char[%0d][0] is %0h", idle_seq_var, idle_seq_char[idle_seq_var][0]);
	    //end //}
	  end //}

	end //}
	else
        begin //{

	  for (int idle_seq_var = 0; idle_seq_var < rx_dh_env_config.num_of_lanes; idle_seq_var++)
	  begin //{

	    if (rx_dh_env_config.srio_mode != SRIO_GEN30)
	    begin //{

	      if (idle_seq_char.exists(idle_seq_var) && idle_seq_char[idle_seq_var].size()>0)
	        idle_seq_char[idle_seq_var].delete();

	      if (idle_seq_cntl.exists(idle_seq_var) && idle_seq_cntl[idle_seq_var].size()>0)
	        idle_seq_cntl[idle_seq_var].delete();

	    end //}
	    else if (rx_dh_env_config.srio_mode == SRIO_GEN30)
	    begin //{

	      if (idle3_seq_cw_type.exists(idle_seq_var) && idle3_seq_cw_type[idle_seq_var].size()>0)
	        idle3_seq_cw_type[idle_seq_var].delete();

	      if (idle3_seq_cw.exists(idle_seq_var) && idle3_seq_cw[idle_seq_var].size()>0)
	        idle3_seq_cw[idle_seq_var].delete();

	    end //}

	  end //}

	end //}

      end //}
      else if (rx_dh_trans.x2_align_data_valid == 1)
      begin //{

	if (nx_idle_seq_chk_in_progress)
	  continue;

	if (~x2_idle_seq_chk_in_progress)
	begin //{
	  if (idle_seq_start_detected)
	  begin //{
	    idle_seq_start_detected = 0;
	    idle_check_in_progress = 0;
	  end //}
	end //}

	x2_idle_seq_chk_in_progress = 1;

	if (rx_dh_env_config.srio_mode == SRIO_GEN30 && ~idle_seq_start_detected)
	begin //{

	  if(x2_align_data.brc3_cntl_cw_type[0] == SKIP_MARKER || x2_align_data.brc3_cntl_cw_type[0] == DESCR_SEED || x2_align_data.brc3_cntl_cw_type[0] == STATUS_CNTL)
	    gen3_ordered_seq_start_detected = 1;

	end //}

	if (rx_dh_env_config.srio_mode != SRIO_GEN30 && x2_align_data.character[0] == SRIO_K && x2_align_data.cntl[0] == 1 && ~idle_seq_start_detected)
        begin //{

	  for (int idle_seq_var = 0; idle_seq_var < 2; idle_seq_var++)
	  begin //{

	    idle_seq_char[idle_seq_var].push_back(x2_align_data.character[idle_seq_var]);
	    idle_seq_cntl[idle_seq_var].push_back(x2_align_data.cntl[idle_seq_var]);

	    //if (~bfm_or_mon && mon_type)
	    //begin //{
	    //$display($time, " 1. _idle_check: x2_align_data.character[%0d] is %0h", idle_seq_var, x2_align_data.character[idle_seq_var]);
	    //$display($time, " 1. _idle_check: idle_seq_char[%0d][0] is %0h", idle_seq_var, idle_seq_char[idle_seq_var][0]);
	    //end //}

	  end //}

	  idle_seq_start_detected = 1;
	  perform_idle2_truncation_check = 1;

	end //}
	else if (rx_dh_env_config.srio_mode == SRIO_GEN30 && gen3_ordered_seq_start_detected && ~idle_seq_start_detected)
        begin //{

	  gen3_ordered_seq_start_detected = 0;

	  for (int idle_seq_var = 0; idle_seq_var < 2; idle_seq_var++)
	  begin //{

	    idle3_seq_cw_type[idle_seq_var].push_back(x2_align_data.brc3_cntl_cw_type[idle_seq_var]);
	    idle3_seq_cw[idle_seq_var].push_back(x2_align_data.brc3_cw[idle_seq_var]);

	    //if (~bfm_or_mon && mon_type)
	    //begin //{
	    //$display($time, " 10. _idle_check: nx_align_data.character[%0d] is %0h", idle_seq_var, nx_align_data.character[idle_seq_var]);
	    //$display($time, " 10. _idle_check: idle_seq_char[%0d][0] is %0h", idle_seq_var, idle_seq_char[idle_seq_var][0]);
	    //end //}
	  end //}

	  idle_seq_start_detected = 1;
	  perform_idle3_truncation_check = 1;

	end //}
	else if (idle_seq_start_detected && rx_dh_env_config.srio_mode != SRIO_GEN30)
        begin //{

	  for (int idle_seq_var = 0; idle_seq_var < 2; idle_seq_var++)
	  begin //{

	    if (~rx_dh_trans.idle_selected)
	    begin //{

	      if (local_cntl_symbol_open && scs_final_bytes==0 && idle_seq_var==0)
		scs_final_bytes++;
	      else if (local_cntl_symbol_open && scs_final_bytes == 1 && idle_seq_var==0)
	      begin //{
		scs_final_bytes = 0;
		sc_cnt = 0;
	        local_cntl_symbol_open = 0;
	      end //}
		
	    end //}
	    else if (sc_cnt%2 == 0) // In case of LCS, if sc_cnt is even, it means, end delimiter is received.
	    begin //{
	      local_cntl_symbol_open = 0;
	      sc_cnt = 0;
	    end //}

	    if (idle_seq_var%4==0)
	    begin //{

	      if (~bfm_or_mon)
	      begin //{

		//if (mon_type)
		//begin //{
		//  $display($time, " 2 : x2_align_data.character[%0d] is %0h, x2_align_data.cntl[%0d] is %0h, rx_dh_common_mon_trans.port_initialized[%0d] is %0d", idle_seq_var, x2_align_data.character[idle_seq_var], idle_seq_var, x2_align_data.cntl[idle_seq_var], ~mon_type, rx_dh_common_mon_trans.port_initialized[~mon_type]);
		//end //}

	        if (x2_align_data.character[idle_seq_var] == SRIO_SC && x2_align_data.cntl[idle_seq_var] == 1 && rx_dh_common_mon_trans.port_initialized[~mon_type] == 1)
	        begin //{
	          local_cntl_symbol_open = 1;
	          //if (rx_dh_trans.idle_selected)
	            sc_cnt++;
                end //}
		else if (sc_cnt == 1 && rx_dh_common_mon_trans.current_init_state[~mon_type] != X2_MODE)
		begin //{
		  // this else if is required because the link partner might get initialized in a
		  // higher link width and the rx monitor is yet to receive alignment on N lanes,
		  // then checking will be suspended till K character is received again, because
		  // detecting exact completion of control symbol is not possible in such cases.
	          sc_cnt = 0;
		  idle_seq_start_detected = 0;
		end //}

              end //}

	    end //}

	  end //}

	  if (~idle_seq_start_detected)
	    continue;

	  if (local_cntl_symbol_open && rx_dh_trans.idle_selected && perform_idle2_truncation_check)
	  begin //{

		//if (~bfm_or_mon && ~mon_type)
		//  $display($time, " 2. idle2_truncation_check called from here");
	    perform_idle2_truncation_check = 0;
	    idle2_truncation_check();
	    continue;

	  end //}
	  else if (local_cntl_symbol_open && ~rx_dh_trans.idle_selected)
	  begin //{
	    idle_check_in_progress = 0;
	    continue;
	  end //}
	  
	  perform_idle2_truncation_check = 1;

	  for (int idle_seq_var = 0; idle_seq_var < 2; idle_seq_var++)
	  begin //{

	    idle_seq_char[idle_seq_var].push_back(x2_align_data.character[idle_seq_var]);
	    idle_seq_cntl[idle_seq_var].push_back(x2_align_data.cntl[idle_seq_var]);

	    //if (~bfm_or_mon && ~mon_type)
	    //begin //{
	    //$display($time, " 2. _idle_check: x2_align_data.character[%0d] is %0h", idle_seq_var, x2_align_data.character[idle_seq_var]);
	    //$display($time, " 2. _idle_check: idle_seq_char[%0d][0] is %0h", idle_seq_var, idle_seq_char[idle_seq_var][0]);
	    //end //}
	  end //}

	end //}
	else if (idle_seq_start_detected && rx_dh_env_config.srio_mode == SRIO_GEN30)
        begin //{

	  for (int idle_seq_var = 0; idle_seq_var < 2; idle_seq_var++)
	  begin //{

	    if (local_cntl_symbol_open && x2_align_data.brc3_cntl_cw_type[idle_seq_var] == CSE)
	      local_cntl_symbol_open = 0;

	    // if rx monitor is receiving control symbols before its port is initialized,
	    // then it could mean that the link partner is initialized. Hence, port_initialized[~mon_type]
	    // is checked.
	    if (~bfm_or_mon)
	    begin //{

	        //$display($time, " 12 : nx_align_data.character[%0d] is %0h, nx_align_data.cntl[%0d] is %0h, rx_dh_common_mon_trans.port_initialized[%0d] is %0d", idle_seq_var, nx_align_data.character[idle_seq_var], idle_seq_var, nx_align_data.cntl[idle_seq_var], ~mon_type, rx_dh_common_mon_trans.port_initialized[~mon_type]);
	      if (x2_align_data.brc3_cntl_cw_type[idle_seq_var] == CSB && rx_dh_common_mon_trans.port_initialized[~mon_type] == 1)
	      begin //{
	        local_cntl_symbol_open = 1;
              end //}

	    end //}

	  end //}

	  if (local_cntl_symbol_open && perform_idle3_truncation_check)
	  begin //{

	//	if (~bfm_or_mon && ~mon_type)
	//	  $display($time, " 1. idle2_truncation_check called from here");
	    perform_idle3_truncation_check = 0;
	    idle3_truncation_check();
	    continue;

	  end //}
	  else if (local_cntl_symbol_open)
	  begin //{
	    idle_check_in_progress = 0;
	    continue;
	  end //}
	  
	  perform_idle3_truncation_check = 1;

	  for (int idle_seq_var = 0; idle_seq_var < 2; idle_seq_var++)
	  begin //{

             if(x2_align_data.brc3_cntl_cw_type[idle_seq_var] == CSB || x2_align_data.brc3_cntl_cw_type[idle_seq_var] == CSE) 
              begin
               break;
              end

	    idle3_seq_cw_type[idle_seq_var].push_back(x2_align_data.brc3_cntl_cw_type[idle_seq_var]);
	    idle3_seq_cw[idle_seq_var].push_back(x2_align_data.brc3_cw[idle_seq_var]);

	    //if (~bfm_or_mon && ~mon_type)
	    //begin //{
	    //$display($time, " 11. _idle_check: nx_align_data.character[%0d] is %0h", idle_seq_var, nx_align_data.character[idle_seq_var]);
	    //$display($time, " 11. _idle_check: idle_seq_char[%0d][0] is %0h", idle_seq_var, idle_seq_char[idle_seq_var][0]);
	    //end //}
	  end //}

	end //}
	else
        begin //{

	  for (int idle_seq_var = 0; idle_seq_var < 2; idle_seq_var++)
	  begin //{

	    if (rx_dh_env_config.srio_mode != SRIO_GEN30)
	    begin //{

	    if (idle_seq_char.exists(idle_seq_var) && idle_seq_char[idle_seq_var].size()>0)
	      idle_seq_char[idle_seq_var].delete();

	    if (idle_seq_cntl.exists(idle_seq_var) && idle_seq_cntl[idle_seq_var].size()>0)
	      idle_seq_cntl[idle_seq_var].delete();

	    end //}
	    else if (rx_dh_env_config.srio_mode == SRIO_GEN30)
	    begin //{

	      if (idle3_seq_cw_type.exists(idle_seq_var) && idle3_seq_cw_type[idle_seq_var].size()>0)
	        idle3_seq_cw_type[idle_seq_var].delete();

	      if (idle3_seq_cw.exists(idle_seq_var) && idle3_seq_cw[idle_seq_var].size()>0)
	        idle3_seq_cw[idle_seq_var].delete();

	    end //}

	  end //}

	end //}

      end //}
      else if (x1_lane_data_valid == 1)
      begin //{

	// Since the skew might cause one lane to get data, this else condition
	// might push a data into the idle_seq_char queue before the x2/nx deskew
	// and destriping logic completes its function. Hence to avoid it, we are
	// not proceeding with this else condition.
	if (x2_idle_seq_chk_in_progress || nx_idle_seq_chk_in_progress)
	  continue;

	if (~x1_idle_seq_chk_in_progress)
	begin //{
	  if (idle_seq_start_detected)
	  begin //{
	    idle_seq_start_detected = 0;
	    idle_check_in_progress = 0;
	  end //}
	end //}

	x1_idle_seq_chk_in_progress = 1;

	if (rx_dh_trans.lane_sync.exists(0) && rx_dh_trans.lane_sync[0] == 1)
	  active_lane_for_idle = 0;
	else if (rx_dh_trans.lane_sync.exists(1) && rx_dh_trans.lane_sync[1] == 1)
	  active_lane_for_idle = 1;
	else if (rx_dh_trans.lane_sync.exists(2) && rx_dh_trans.lane_sync[2] == 1)
	  active_lane_for_idle = 2;
	
	//$display($time, " 2. active_lane_for_idle is %0d", active_lane_for_idle);

	if (rx_dh_env_config.srio_mode == SRIO_GEN30 && ~idle_seq_start_detected)
	begin //{

	  if(x1_lane_data.brc3_cntl_cw_type == SKIP_MARKER || x1_lane_data.brc3_cntl_cw_type == DESCR_SEED || x1_lane_data.brc3_cntl_cw_type == STATUS_CNTL)
	    gen3_ordered_seq_start_detected = 1;

	end //}

	if (rx_dh_env_config.srio_mode != SRIO_GEN30 && x1_lane_data.character == SRIO_K && x1_lane_data.cntl == 1 && ~idle_seq_start_detected)
        begin //{

	  idle_seq_char[active_lane_for_idle].push_back(x1_lane_data.character);
	  idle_seq_cntl[active_lane_for_idle].push_back(x1_lane_data.cntl);

	  idle_seq_start_detected = 1;
	  perform_idle2_truncation_check = 1;

	end //}
	else if (rx_dh_env_config.srio_mode == SRIO_GEN30 && gen3_ordered_seq_start_detected && ~idle_seq_start_detected)
        begin //{

	  gen3_ordered_seq_start_detected = 0;

	  idle3_seq_cw_type[active_lane_for_idle].push_back(x1_lane_data.brc3_cntl_cw_type);
	  idle3_seq_cw[active_lane_for_idle].push_back(x1_lane_data.brc3_cw);

	  idle_seq_start_detected = 1;
	  perform_idle3_truncation_check = 1;

	end //}
	else if (idle_seq_start_detected && rx_dh_env_config.srio_mode != SRIO_GEN30)
        begin //{

	  if (~rx_dh_trans.idle_selected)
	  begin //{

	    if (local_cntl_symbol_open && scs_final_bytes<3)
	      scs_final_bytes++;
	    else if (local_cntl_symbol_open && scs_final_bytes == 3)
	    begin //{
	      scs_final_bytes = 0;
	      sc_cnt = 0;
	      local_cntl_symbol_open = 0;
	    end //}
	      
	  end //}
	  else if (sc_cnt%2 == 0) // In case of LCS, if sc_cnt is even, it means, end delimiter is received.
	  begin //{
	    local_cntl_symbol_open = 0;
	    sc_cnt = 0;
	  end //}

	  if (~bfm_or_mon)
	  begin //{

	    if (x1_lane_data.character == SRIO_SC && x1_lane_data.cntl == 1 && rx_dh_common_mon_trans.port_initialized[~mon_type] == 1)
	    begin //{
	      local_cntl_symbol_open = 1;
	      //if (rx_dh_trans.idle_selected)
	        sc_cnt++;
            end //}
	    else if (sc_cnt==1 && (rx_dh_common_mon_trans.current_init_state[~mon_type] != X1_M0 && rx_dh_common_mon_trans.current_init_state[~mon_type] != X1_M1 && rx_dh_common_mon_trans.current_init_state[~mon_type] != X1_M2))
	    begin //{
	      sc_cnt = 0;
	      local_cntl_symbol_open = 0;
	      idle_seq_start_detected = 0;
	    end //}

          end //}

	  if (~idle_seq_start_detected)
	    continue;

	  if (local_cntl_symbol_open && rx_dh_trans.idle_selected && perform_idle2_truncation_check)
	  begin //{

		//if (~bfm_or_mon && ~mon_type)
		//  $display($time, " 3. idle2_truncation_check called from here");
	    perform_idle2_truncation_check = 0;
	    idle2_truncation_check();
	    continue;

	  end //}
	  else if (local_cntl_symbol_open && ~rx_dh_trans.idle_selected)
	  begin //{
	    idle_check_in_progress = 0;
	    continue;
	  end //}
	  
	  perform_idle2_truncation_check = 1;

	  idle_seq_char[active_lane_for_idle].push_back(x1_lane_data.character);
	  idle_seq_cntl[active_lane_for_idle].push_back(x1_lane_data.cntl);

	    //if (~bfm_or_mon && ~mon_type)
	    //begin //{
	    //$display($time, " 4. _idle_check: x1_lane_data.character is %0h", x1_lane_data.character);
	    //$display($time, " 4. _idle_check: idle_seq_char[%0d][0] is %0h", active_lane_for_idle, idle_seq_char[active_lane_for_idle][0]);
	    //end //}

	end //}
	else if (idle_seq_start_detected && rx_dh_env_config.srio_mode == SRIO_GEN30)
        begin //{

	  if (local_cntl_symbol_open && x1_lane_data.brc3_cntl_cw_type == CSE)
	    local_cntl_symbol_open = 0;

	  if (~bfm_or_mon)
	  begin //{

	    if (x1_lane_data.brc3_cntl_cw_type == CSB && rx_dh_common_mon_trans.port_initialized[~mon_type] == 1)
	    begin //{
	      local_cntl_symbol_open = 1;
            end //}
	    else if (local_cntl_symbol_open && (rx_dh_common_mon_trans.current_init_state[~mon_type] != X1_M0 && rx_dh_common_mon_trans.current_init_state[~mon_type] != X1_M1 && rx_dh_common_mon_trans.current_init_state[~mon_type] != X1_M2))
	    begin //{
	      local_cntl_symbol_open = 0;
	      idle_seq_start_detected = 0;
	    end //}

          end //}

	  if (~idle_seq_start_detected)
	    continue;

	  if (local_cntl_symbol_open && perform_idle3_truncation_check)
	  begin //{

		//if (~bfm_or_mon && ~mon_type)
		//  $display($time, " 3. idle2_truncation_check called from here");
	    perform_idle3_truncation_check = 0;
	    idle3_truncation_check();
	    continue;

	  end //}
	  else if (local_cntl_symbol_open)
	  begin //{
	    idle_check_in_progress = 0;
	    continue;
	  end //}
	  
	  perform_idle3_truncation_check = 1;


             if(x1_lane_data.brc3_cntl_cw_type == CSB || x1_lane_data.brc3_cntl_cw_type == CSE) 
              begin
               continue;
              end

	  idle3_seq_cw_type[active_lane_for_idle].push_back(x1_lane_data.brc3_cntl_cw_type);
	  idle3_seq_cw[active_lane_for_idle].push_back(x1_lane_data.brc3_cw);

	    //if (~bfm_or_mon && ~mon_type)
	    //begin //{
	    //$display($time, " 4. _idle_check: x1_lane_data.character is %0h", x1_lane_data.character);
	    //$display($time, " 4. _idle_check: idle_seq_char[%0d][0] is %0h", active_lane_for_idle, idle_seq_char[active_lane_for_idle][0]);
	    //end //}

	end //}
	else
        begin //{

	  if (rx_dh_env_config.srio_mode != SRIO_GEN30)
	  begin //{

	  if (idle_seq_char.exists(active_lane_for_idle) && idle_seq_char[active_lane_for_idle].size()>0)
	    idle_seq_char[active_lane_for_idle].delete();

	  if (idle_seq_cntl.exists(active_lane_for_idle) && idle_seq_cntl[active_lane_for_idle].size()>0)
	    idle_seq_cntl[active_lane_for_idle].delete();

	  end //}
	  else if (rx_dh_env_config.srio_mode == SRIO_GEN30)
	  begin //{

	    if (idle3_seq_cw_type.exists(active_lane_for_idle) && idle3_seq_cw_type[active_lane_for_idle].size()>0)
	      idle3_seq_cw_type[active_lane_for_idle].delete();

	    if (idle3_seq_cw.exists(active_lane_for_idle) && idle3_seq_cw[active_lane_for_idle].size()>0)
	      idle3_seq_cw[active_lane_for_idle].delete();

	  end //}

	end //}

      end //}

    end //}
    else
    begin //{

      idle_seq_start_detected = 0;

      if (rx_dh_trans.current_init_state == NX_MODE || (rx_dh_trans.current_init_state == ASYM_MODE && (rx_dh_trans.rcv_width == "4x" || rx_dh_trans.rcv_width == "8x" || rx_dh_trans.rcv_width == "16x")))
      begin //{

      	x2_idle_seq_chk_in_progress = 0;
      	x1_idle_seq_chk_in_progress = 0;

	if (~nx_idle_seq_chk_in_progress)
	begin //{

	  idle_check_in_progress = 0;
      	  nx_idle_seq_chk_in_progress = 1;
      	  x2_idle_seq_chk_in_progress = 0;
      	  x1_idle_seq_chk_in_progress = 0;

	  if (lcs_completed_in_same_column)
	    lcs_completed_in_same_column = 0;

	  if (idle_seq_start_after_port_init_detected)
	    idle_seq_start_after_port_init_detected = 0;

	  continue;

	end //}
	else if (~idle_seq_start_after_port_init_detected && nx_idle_seq_chk_in_progress)
	begin //{

	  idle_check_in_progress = 0;

	  if (rx_dh_env_config.srio_mode != SRIO_GEN30 && nx_align_data.character[0] == SRIO_K && nx_align_data.cntl[0] == 1 && rx_dh_trans.nx_align_data_valid)
	    idle_seq_start_after_port_init_detected = 1;
	  else if (rx_dh_env_config.srio_mode == SRIO_GEN30 && (nx_align_data.brc3_cntl_cw_type[0] == SKIP_MARKER || nx_align_data.brc3_cntl_cw_type[0] == DESCR_SEED || nx_align_data.brc3_cntl_cw_type[0] == STATUS_CNTL) && rx_dh_trans.nx_align_data_valid)
	    idle_seq_start_after_port_init_detected = 1;
	  else
	  begin //{

	    if (lcs_completed_in_same_column)
	      lcs_completed_in_same_column = 0;

	    continue;

	  end //}

	end //}

	if (rx_dh_trans.nx_align_data_valid == 0 || cntl_symbol_open || packet_open || lcs_completed_in_same_column && (rx_dh_env_config.srio_mode != SRIO_GEN30))
	begin //{

	  if (rx_dh_trans.nx_align_data_valid == 0)
	    continue;

	  local_cntl_symbol_open = cntl_symbol_open;

		//if (~bfm_or_mon && mon_type)
		//  $display($time, " 4. idle2_truncation_check called from here");
	  if (~rx_dh_trans.sync_seq_detected)
	    idle2_truncation_check();
	  else
	  begin //{
	    if (cntl_symbol_open || lcs_completed_in_same_column)
	    begin //{
	      rx_dh_trans.cs_after_sync_seq_rcvd = 1;
	      idle_check_in_progress = 0;
	    end //}
	  end //}

	  lcs_completed_in_same_column = 0;
	  //idle_check_in_progress = 0;
	  continue;
	end //}
	else if (rx_dh_trans.nx_align_data_valid == 0 || cntl_symbol_open || packet_open || gen3_cs_completed_in_same_column && (rx_dh_env_config.srio_mode == SRIO_GEN30))
	begin //{

	  if (rx_dh_trans.nx_align_data_valid == 0)
	    continue;

	  local_cntl_symbol_open = cntl_symbol_open;

		//if (~bfm_or_mon && mon_type)
		//  $display($time, " 4. idle2_truncation_check called from here");
	  idle3_truncation_check();

	  if (gen3_cs_completed_in_same_column && descr_seed_os_detected)
	    descr_seed_os_detected = 0;

	  gen3_cs_completed_in_same_column = 0;
	  //idle_check_in_progress = 0;
	  continue;

	end //}
	else if (~rx_dh_trans.idle_selected && nx_scs_rcvd && rx_dh_env_config.srio_mode != SRIO_GEN30)
	begin //{
	  // this else if condition will not push the Short control symbol into
	  // the idle_seq_char queue in NX mode.
	  idle_check_in_progress = 0;
	  nx_scs_rcvd = 0;
	  continue;
	end //}
	else if (local_cntl_symbol_open)
	begin //{

	  local_cntl_symbol_open = cntl_symbol_open;

	  if (descr_seed_os_detected)
	    descr_seed_os_detected = 0;

	  continue;

	end //}

	for (int idle_seq_var = 0; idle_seq_var < rx_dh_env_config.num_of_lanes; idle_seq_var++)
	begin //{

	  if (rx_dh_env_config.srio_mode != SRIO_GEN30)
	  begin //{

	    idle_seq_char[idle_seq_var].push_back(nx_align_data.character[idle_seq_var]);
	    idle_seq_cntl[idle_seq_var].push_back(nx_align_data.cntl[idle_seq_var]);

	  end //}
	  else
	  begin //{

	    idle3_seq_cw_type[idle_seq_var].push_back(nx_align_data.brc3_cntl_cw_type[idle_seq_var]);
	    idle3_seq_cw[idle_seq_var].push_back(nx_align_data.brc3_cw[idle_seq_var]);

	  end //}

	  //if (~bfm_or_mon && mon_type)
	  //begin //{
	  //$display($time, " 20. _idle_check: nx_align_data.character[%0d] is %0h", idle_seq_var, nx_align_data.character[idle_seq_var]);
	  //$display($time, " 20. _idle_check: idle_seq_char[%0d][0] is %0h", idle_seq_var, idle_seq_char[idle_seq_var][0]);
	  //end //}

	end //}

      end //}
	else if (rx_dh_trans.current_init_state == X2_MODE || (rx_dh_trans.current_init_state == ASYM_MODE && rx_dh_trans.rcv_width == "2x"))
      begin //{

      	nx_idle_seq_chk_in_progress = 0;
      	x1_idle_seq_chk_in_progress = 0;

	if (~x2_idle_seq_chk_in_progress)
	begin //{

	  idle_check_in_progress = 0;
      	  x2_idle_seq_chk_in_progress = 1;

	  if (idle_seq_start_after_port_init_detected)
	    idle_seq_start_after_port_init_detected = 0;

	  continue;

	end //}
	else if (~idle_seq_start_after_port_init_detected && x2_idle_seq_chk_in_progress)
	begin //{
	  idle_check_in_progress = 0;
	  if (rx_dh_env_config.srio_mode != SRIO_GEN30 && x2_align_data.character[0] == SRIO_K && x2_align_data.cntl[0] == 1 && rx_dh_trans.x2_align_data_valid)
	    idle_seq_start_after_port_init_detected = 1;
	  else if (rx_dh_env_config.srio_mode == SRIO_GEN30 && (x2_align_data.brc3_cntl_cw_type[0] == SKIP_MARKER || x2_align_data.brc3_cntl_cw_type[0] == DESCR_SEED || x2_align_data.brc3_cntl_cw_type[0] == STATUS_CNTL) && rx_dh_trans.x2_align_data_valid)
	    idle_seq_start_after_port_init_detected = 1;
	  else
	    continue;
	end //}

	if (rx_dh_trans.x2_align_data_valid == 0 || cntl_symbol_open || packet_open && (rx_dh_env_config.srio_mode != SRIO_GEN30))
	begin //{

	  if (rx_dh_trans.x2_align_data_valid == 0)
	    continue;

	  local_cntl_symbol_open = cntl_symbol_open;

		//if (~bfm_or_mon && ~mon_type)
		//  $display($time, " 5. idle2_truncation_check called from here");
	  if (~rx_dh_trans.sync_seq_detected)
	    idle2_truncation_check();
	  else
	  begin //{
	    if (cntl_symbol_open)
	    begin //{
	      rx_dh_trans.cs_after_sync_seq_rcvd = 1;
	      idle_check_in_progress = 0;
	    end //}
	  end //}


	  //idle_check_in_progress = 0;
	  continue;

	end //}
	else if (rx_dh_trans.x2_align_data_valid == 0 || cntl_symbol_open || packet_open || gen3_cs_completed_in_same_column && (rx_dh_env_config.srio_mode == SRIO_GEN30))
	begin //{

	  if (rx_dh_trans.x2_align_data_valid == 0)
	    continue;

	  local_cntl_symbol_open = cntl_symbol_open;

		//if (~bfm_or_mon && mon_type)
		//  $display($time, " 4. idle2_truncation_check called from here");
	  idle3_truncation_check();

	  if (gen3_cs_completed_in_same_column && descr_seed_os_detected)
	    descr_seed_os_detected = 0;

	  gen3_cs_completed_in_same_column = 0;
	  //idle_check_in_progress = 0;
	  continue;

	end //}
	else if (local_cntl_symbol_open)
	begin //{

	  local_cntl_symbol_open = cntl_symbol_open;

	  if (descr_seed_os_detected)
	    descr_seed_os_detected = 0;

	  continue;

	end //}

	for (int idle_seq_var = 0; idle_seq_var < 2; idle_seq_var++)
	begin //{

	  if (rx_dh_env_config.srio_mode != SRIO_GEN30)
	  begin //{

	    idle_seq_char[idle_seq_var].push_back(x2_align_data.character[idle_seq_var]);
	    idle_seq_cntl[idle_seq_var].push_back(x2_align_data.cntl[idle_seq_var]);

	  end //}
	  else
	  begin //{

	    idle3_seq_cw_type[idle_seq_var].push_back(x2_align_data.brc3_cntl_cw_type[idle_seq_var]);
	    idle3_seq_cw[idle_seq_var].push_back(x2_align_data.brc3_cw[idle_seq_var]);

	  end //}

	    //if (~bfm_or_mon && mon_type)
	    //begin //{
	    //$display($time, " 3. _idle_check: x2_align_data.character[%0d] is %0h", idle_seq_var, x2_align_data.character[idle_seq_var]);
	    //$display($time, " 3. _idle_check: idle_seq_char[%0d][0] is %0h", idle_seq_var, idle_seq_char[idle_seq_var][0]);
	    //end //}
	end //}

      end //}
      else if (rx_dh_trans.current_init_state == X1_M0 || rx_dh_trans.current_init_state == X1_M1 || rx_dh_trans.current_init_state == X1_M2 || (rx_dh_trans.current_init_state == ASYM_MODE && rx_dh_trans.rcv_width == "1x"))
      begin //{

      	nx_idle_seq_chk_in_progress = 0;
      	x2_idle_seq_chk_in_progress = 0;

	if (~x1_idle_seq_chk_in_progress)
	begin //{

	  idle_check_in_progress = 0;
      	  x1_idle_seq_chk_in_progress = 1;

	  if (idle_seq_start_after_port_init_detected)
	    idle_seq_start_after_port_init_detected = 0;

	  continue;

	end //}
	else if (~idle_seq_start_after_port_init_detected && x1_idle_seq_chk_in_progress)
	begin //{
	  idle_check_in_progress = 0;
	  if (rx_dh_env_config.srio_mode != SRIO_GEN30 && x1_lane_data.character == SRIO_K && x1_lane_data.cntl == 1 && x1_lane_data_valid)
	    idle_seq_start_after_port_init_detected = 1;
	  else if (rx_dh_env_config.srio_mode == SRIO_GEN30 && (x1_lane_data.brc3_cntl_cw_type == SKIP_MARKER || x1_lane_data.brc3_cntl_cw_type == DESCR_SEED || x1_lane_data.brc3_cntl_cw_type == STATUS_CNTL) && x1_lane_data_valid)
	    idle_seq_start_after_port_init_detected = 1;
	  else
	    continue;
	end //}

	if (x1_lane_data_valid == 0 || cntl_symbol_open || packet_open && (rx_dh_env_config.srio_mode != SRIO_GEN30))
	begin //{

	  if (x1_lane_data_valid == 0)
	    continue;

	  local_cntl_symbol_open = cntl_symbol_open;

		//if (~bfm_or_mon && ~mon_type)
		//  $display($time, " 6. idle2_truncation_check called from here");
	  if (~rx_dh_trans.sync_seq_detected)
	    idle2_truncation_check();
	  else
	  begin //{
	    if (cntl_symbol_open)
	    begin //{
	      rx_dh_trans.cs_after_sync_seq_rcvd = 1;
	      idle_check_in_progress = 0;
	    end //}
	  end //}


	  //idle_check_in_progress = 0;
	  continue;
	end //}
	else if (x1_lane_data_valid == 0 || cntl_symbol_open || packet_open && (rx_dh_env_config.srio_mode == SRIO_GEN30))
	begin //{

	  if (x1_lane_data_valid == 0)
	    continue;

	  local_cntl_symbol_open = cntl_symbol_open;

		//if (~bfm_or_mon && mon_type)
		//  $display($time, " 4. idle2_truncation_check called from here");
	  idle3_truncation_check();

	  //idle_check_in_progress = 0;
	  continue;

	end //}
	else if (local_cntl_symbol_open)
	begin //{

	  local_cntl_symbol_open = cntl_symbol_open;
	  gen3_cs_completed_in_same_column = 0;

	  if (descr_seed_os_detected)
	    descr_seed_os_detected = 0;

	  continue;

	end //}

	if (rx_dh_env_config.srio_mode != SRIO_GEN30)
	begin //{

	  idle_seq_char[active_lane_for_idle].push_back(x1_lane_data.character);
	  idle_seq_cntl[active_lane_for_idle].push_back(x1_lane_data.cntl);

	end //}
	else
	begin //{

	  idle3_seq_cw_type[active_lane_for_idle].push_back(x1_lane_data.brc3_cntl_cw_type);
	  idle3_seq_cw[active_lane_for_idle].push_back(x1_lane_data.brc3_cw);

	end //}

	    //if (~bfm_or_mon && mon_type)
	    //begin //{
	    //$display($time, " 33. _idle_check: x1_lane_data.character is %0h", x1_lane_data.character);
	    //$display($time, " 33. _idle_check: idle_seq_char[%0d][0] is %0h", active_lane_for_idle, idle_seq_char[active_lane_for_idle][0]);
	    //end //}

      end //}

    end //}

    //if (mon_type)
    //if (~bfm_or_mon && ~mon_type)
    //begin //{

    //  for (int idl_disp=0; idl_disp<rx_dh_env_config.num_of_lanes; idl_disp++)
    //  begin //{
    //    if (idle_seq_char[idl_disp].size()>0)
    //      `uvm_info("SRIO_PL_RX_DATA_HANDLER : IDLE DISPLAY", $sformatf(" Lane %0d : idle_seq_char[%0d] is %0h, idle_seq_cntl[%0d] is %0d", idl_disp, idl_disp, idle_seq_char[idl_disp].pop_front(), idl_disp, idle_seq_cntl[idl_disp].pop_front()), UVM_LOW)
    //  end //}

    //end //}

  end //}

endtask : idle_seq_collect




//////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : idle_seq_checks
/// Description : This method performs the IDLE column check and sync sequence check. Also, based on the
/// idle sequence selected, this method triggers either idle1_check and idle2_check.
//////////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::idle_seq_checks();

  forever begin //{

    @(posedge srio_if.sim_clk);

    if (~rx_dh_trans.idle_detected)
      idle_check_started = 0;

    wait(rx_dh_trans.idle_detected == 1);

    for (int idl_chk=0; idl_chk<rx_dh_env_config.num_of_lanes; idl_chk++)
    begin //{

      temp_idl_chk = idl_chk;

      if (idle_seq_char.exists(idl_chk) && idle_seq_char[idl_chk].size()>0)
      begin //{

	if (idl_chk == 0)
	begin //{

	  lane0_idle_valid = 1;
	  lane0_idle_char = idle_seq_char[idl_chk].pop_front();
	  lane0_idle_cntl = idle_seq_cntl[idl_chk].pop_front();

	  //if (~bfm_or_mon && mon_type)
	  //$display($time, " lane0_idle_char is %0h, lane0_idle_cntl is %0d", lane0_idle_char, lane0_idle_cntl);

	end //}
	else
	begin //{

	  lane_idle_valid = 1;
	  lane_idle_char = idle_seq_char[idl_chk].pop_front();
	  lane_idle_cntl = idle_seq_cntl[idl_chk].pop_front();

	  //if (~bfm_or_mon && mon_type)
	  //$display($time, " lane_idle_char is %0h, lane_idle_cntl is %0d", lane_idle_char, lane_idle_cntl);

	end //}

	if (lane0_idle_valid && idl_chk>0)
	begin //{

	  if (((lane_idle_char !== lane0_idle_char) || (lane_idle_cntl !== lane0_idle_cntl)) && ~idle2_cs_marker && ~idle2_cs_field && idle_check_started)
	  begin //{
      	    if (~rx_dh_trans.ies_state && rx_dh_trans.link_initialized)
      	    begin //{
      	      rx_dh_trans.ies_state = 1;
      	      rx_dh_trans.ies_cause_value = 31;
      	       //$display($time, " 1. Vaidhy : ies_state set here");
      	    end //}

	    if (~bfm_or_mon)
	    begin //{

	      -> rx_dh_trans.idle_seq_not_aligned;

	      if (rx_dh_common_mon_trans.port_initialized[0] && rx_dh_common_mon_trans.port_initialized[1])
	      begin //{

	        `uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE_SEQUENCE_COLUMN_CHECK", $sformatf(" Spec reference 5.13.2.2. IDLE sequence is not identical on all lanes. Lane 0 character is %0h, Lane 0 cntl is %0d, Lane %0d is %0h, Lane %0d cntl is %0d", lane0_idle_char, lane0_idle_cntl, idl_chk, lane_idle_char, idl_chk, lane_idle_cntl))

	      end //}

	    end //}

	  end //}

	end //}

	if (rx_dh_trans.idle_selected && ~bfm_or_mon)
	  idle2_cs_marker_dxy_check();

      end //}

    end //}

    if (lane0_idle_valid || lane_idle_valid)
    begin //{
      if (~lane_idle_valid)
      begin //{
	lane_idle_char = lane0_idle_char;
	lane_idle_cntl = lane0_idle_cntl;
      end //}
      lane0_idle_valid = 0;
      lane_idle_valid = 0;
    end //}
    else
    begin //{
	//if (~bfm_or_mon && mon_type)
	//  $display($time, " lane_idle_valid and lane0_idle_valid are zero.");
      continue;
    end //}

    if (rx_dh_trans.sync_seq_detected && (rx_dh_trans.cs_after_sync_seq_processed || (lane_idle_char == SRIO_D00 && idle2_D_after_M_cnt == 4) || (lane_idle_char != SRIO_M && lane_idle_cntl)))
    begin //{


      idle_check_in_progress = 0;

      rx_dh_trans.sync_seq_detected = 0;
      rx_dh_trans.cs_after_sync_seq_processed = 0;

      if (~bfm_or_mon)
      begin //{

        `uvm_error("SRIO_PL_RX_DATA_HANDLER : LINK_REQ_AFTER_SYNC_SEQUENCE_CHECK", $sformatf(" Spec reference 4.8.2. Link request doesn't follow immediately after descrambler sync sequence.")) 

      end //}

    end //}
    else if (~rx_dh_trans.sync_seq_detected && rx_dh_trans.cs_after_sync_seq_processed)
    begin //{

      rx_dh_trans.cs_after_sync_seq_processed = 0;

    end //}

    if (~idle_check_started)
    begin //{

      if (lane_idle_char == SRIO_K && lane_idle_cntl)
        idle_check_started = 1;
      else
        continue;

    end //}

    if (~rx_dh_trans.idle_selected)
    begin //{

      idle1_check();

    end //}
    else
    begin //{

      idle2_check();

    end //}

  end //}

endtask : idle_seq_checks




//////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : idle1_check
/// Description : This method performs IDLE1 related sequence checks which are listed in micro-architecture
/// document under section "PL Monitor Checks" and sub-section "IDLE SEQUENCE CHECKS"
//////////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::idle1_check();

 if (idle1_A_received)
   idle1_char_cnt++;

 if (~idle_check_in_progress)
 begin //{

   idle1_A_received = 0;
   idle1_char_cnt = 0;

   if (lane_idle_char != SRIO_K && lane_idle_cntl != 1)
   begin //{

     if (~bfm_or_mon && (~rx_dh_trans.x1_mode_detected && rx_dh_trans.current_init_state!=X1_M0)) 
     begin //{

       -> rx_dh_trans.idle1_corrupt_seq;

       `uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE1_SEQUENCE_BEGIN_CHAR_CHECK", $sformatf(" Spec reference 4.7.2. IDLE sequence1 shall begin with K character. Char is %0h Cntl is %0d", lane_idle_char, lane_idle_cntl))

     end //}

   end //}
   else
     idle_check_in_progress = 1;

 end //}
 else
 begin //{

   if ((lane_idle_char != SRIO_K && lane_idle_char != SRIO_R && lane_idle_char != SRIO_A) || lane_idle_cntl != 1)
   begin //{

     if (~rx_dh_trans.ies_state && rx_dh_trans.link_initialized)
     begin //{
       rx_dh_trans.ies_state = 1;
       rx_dh_trans.ies_cause_value = 5;
	//$display($time, " 1. Vaidhy : ies_state set here");
     end //}

     if (~bfm_or_mon)
     begin //{

       -> rx_dh_trans.idle1_corrupt_seq;

       update_error_detect_csr("IDLE1_ERR");

       `uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE1_SEQUENCE_INVALID_CHAR_CHECK", $sformatf(" Spec reference 5.13.2.2. Invalid / Illegal character encountered inbetween IDLE sequence1. Char is %0h Cntl is %0d", lane_idle_char, lane_idle_cntl))

     end //}

   end //}

   if (lane_idle_char == SRIO_A && lane_idle_cntl == 1)
   begin //{

     idle1_A_received = 1;

     if (idle1_char_cnt>0 && idle1_char_cnt<16)
     begin //{

       if (~bfm_or_mon)
       begin //{

         `uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE1_SEQUENCE__A_CHAR_SPACING_CHECK", $sformatf(" Spec reference 4.7.2. Successive A characters in IDLE1 sequence has to be seperated by atleast 16 non-A characters. They are separated by %0d non-A characters", idle1_char_cnt))

       end //}

     end //}

     idle1_char_cnt = 0;

   end //}

 end //}

endtask : idle1_check




//////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : idle2_check
/// Description : This method performs IDLE2 sequence related checks which are listed in micro-architecture
/// document under section "PL Monitor Checks" and sub-section "IDLE SEQUENCE CHECKS"
//////////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::idle2_check();

  if (idle2_psr_char_cnt>0)
  begin //{
    if (lane_idle_char == SRIO_D00 && lane_idle_cntl == 0)
      idle2_non_AM_char_cnt++;
    idle2_psr_char_cnt++;
  end //}

  if (~idle_check_in_progress)
  begin //{

    idle2_non_AM_char_cnt = 0;
	//if (~bfm_or_mon && mon_type)
	//$display($time, " 5. idle2_non_AM_char_cnt made 0 here. lane_idle_char is %0h", lane_idle_char);
    idle2_psr_char_cnt = 0;
    idle2_first_psr_seq = 1;
    idle2_psr_length_check_done = 0;
    idle2_M_char_cnt = 0;
    idle2_D_after_M_cnt = 0;
    idle2_cs_marker_char_cnt = 0;
    idle2_cs_field_char_cnt = 0;
    idle2_cs_marker = 0;
    idle2_cs_field = 0;

    if (lane_idle_char == SRIO_D00 && lane_idle_cntl == 0)
    begin //{
      idle2_non_AM_char_cnt++;
      idle2_psr_char_cnt++;
    end //}

    if ((lane_idle_char != SRIO_K && lane_idle_cntl != 1) && (lane_idle_char != SRIO_D00 && lane_idle_cntl != 0))
    begin //{

      if (check_for_sync_seq || rx_dh_trans.sync_seq_detected || sync_seq_started)
	return;

      if (~bfm_or_mon)
      begin //{

        -> rx_dh_trans.idle2_corrupt_seq;

        `uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE2_SEQUENCE_BEGIN_CHAR_CHECK", $sformatf(" Spec reference 4.7.4. IDLE sequence2 shall begin with KRRR or D0.0 character. Char is %0h Cntl is %0d", lane_idle_char, lane_idle_cntl))

      end //}

    end //}
    else
    begin //{
      idle_check_in_progress = 1;
      if (lane_idle_char == SRIO_K && lane_idle_cntl == 1)
	idle2_started_with_k = 1;
    end //}

  end //}
  else
  begin //{

    if (idle2_psr_char_cnt == 0 && lane_idle_char == SRIO_D00 && lane_idle_cntl == 0)
    begin //{
      idle2_non_AM_char_cnt++;
      idle2_psr_char_cnt++;
    end //}

	/*if (mon_type)
	  $display($time, " lane_idle_char is %0h, idle2_non_AM_char_cnt is %0d", lane_idle_char, idle2_non_AM_char_cnt);
	else*/ //if (~bfm_or_mon && mon_type)
	       // $display($time, " lane_idle_char is %0h, idle2_psr_char_cnt is %0d", lane_idle_char, idle2_psr_char_cnt);

    idle2_invalid_char_check();

    if (idle2_first_psr_seq)
      max_d00_char_cnt = 35;
    else
      max_d00_char_cnt = 31;

    idle2_contiguous_psr_length_check();

    if (lane_idle_char == SRIO_M && lane_idle_cntl == 1 && ~idle2_cs_marker)
    begin //{

      idle2_M_char_cnt++;

      if (idle2_M_char_cnt>1)
      begin //{

        idle2_cs_marker = 1;
        idle2_cs_marker_char_cnt = idle2_M_char_cnt;

      end //}

    end //}
    else if (lane_idle_char == SRIO_M && lane_idle_cntl == 1 && idle2_cs_marker)
    begin //{
      if (idle2_M_char_cnt<4)
       begin //{
        idle2_M_char_cnt++;
        idle2_cs_marker_char_cnt = idle2_M_char_cnt;
       end //}
      else 
       begin //{
        idle2_cs_marker_char_cnt = 0;
        idle2_M_char_cnt = 0;
        idle2_cs_marker=0;
        idle_check_in_progress=0;
       end //}
    end //}
    else if((lane_idle_char== SRIO_SC || lane_idle_char==SRIO_PD) && lane_idle_cntl==1 && idle2_cs_marker)
    begin //{
        idle2_cs_marker_char_cnt = 0;
        idle2_M_char_cnt = 0;
        idle2_cs_marker=0;
        idle_check_in_progress=0;
    end //}
    else if (idle2_M_char_cnt>0 && ~idle2_cs_marker)
    begin //{
      idle2_M_char_cnt = 0;
      idle2_D_after_M_cnt++;
    end //}
    else if (idle2_M_char_cnt == 4 && idle2_cs_marker)
    begin //{
      idle2_cs_marker_char_cnt++;
    end //}
    else if (idle2_cs_field == 1)
    begin //{
      idle2_cs_field_char_cnt++;
    end //}
    else if (idle2_D_after_M_cnt > 0)
    begin //{
      idle2_D_after_M_cnt++;
    end //}

    if (idle2_D_after_M_cnt == 4)
      idle2_D_after_M_cnt = 0;

    if (~idle2_psr_length_check_done)
      idle2_total_psr_length_check();

    idle2_cs_marker_check();

    if (idle2_cs_marker_char_cnt == 8)
    begin //{
      idle2_cs_marker_char_cnt = 0;
      idle2_cs_marker = 0;
      idle2_M_char_cnt = 0;
      idle2_cs_field = 1;
    end //}

    idle2_cs_field_check();

  end //}

endtask : idle2_check



//////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : idle2_invalid_char_check
/// Description : This method is called by idle2_check.
/// Checks if any invalid characters are received in between IDLE2 sequence.
//////////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::idle2_invalid_char_check();

    if (((lane_idle_char != SRIO_K || lane_idle_char != SRIO_R || lane_idle_char != SRIO_A || lane_idle_char != SRIO_M) && lane_idle_cntl != 1) && (lane_idle_char != SRIO_D00 && lane_idle_cntl != 0) && ~idle2_cs_marker && ~idle2_cs_field)
    begin //{

      if (~rx_dh_trans.ies_state && rx_dh_trans.link_initialized)
      begin //{
        rx_dh_trans.ies_state = 1;
        rx_dh_trans.ies_cause_value = 5;
	//$display($time, " 2. Vaidhy : ies_state set here");
      end //}

      if (~bfm_or_mon)
      begin //{

        -> rx_dh_trans.idle2_corrupt_seq;

        `uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE2_SEQUENCE_INVALID_CHAR_CHECK", $sformatf(" Spec reference 5.13.2.2. Invalid / Illegal character encountered inbetween IDLE sequence2. Char is %0h Cntl is %0d", lane_idle_char, lane_idle_cntl))

      end //}

    end //}
    else if (lane_idle_char == SRIO_K && lane_idle_cntl == 1)
    begin //{

      idle2_non_AM_char_cnt = 0;
	//if (~bfm_or_mon && mon_type)
	//$display($time, " 1. idle2_non_AM_char_cnt made 0 here");
      idle2_psr_char_cnt = 0;
      idle2_first_psr_seq = 1;
      idle2_psr_length_check_done = 0;
      idle2_M_char_cnt = 0;
      idle2_D_after_M_cnt = 0;
      idle2_cs_marker_char_cnt = 0;
      idle2_cs_field_char_cnt = 0;
      idle2_cs_marker = 0;
      idle2_cs_field = 0;

    end //}

endtask : idle2_invalid_char_check




//////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : idle2_contiguous_psr_length_check
/// Description : This method is called by idle2_check.
/// Checks the contiguous length of pseudo random sequence in IDLE2.
//////////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::idle2_contiguous_psr_length_check();

  if (lane_idle_char == SRIO_K && lane_idle_cntl && ~bfm_or_mon &&  rx_dh_common_mon_trans.port_initialized[~mon_type] && rx_dh_common_mon_trans.port_initialized[mon_type])
       `uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE2_SEQUENCE_TERMINATED_WITH_KRRR", $sformatf(" Spec reference 4.7.4. Idle2 random data field is terminated with KRRR."))

  if (lane_idle_char == SRIO_M && lane_idle_cntl && idle2_started_with_k && idle2_non_AM_char_cnt==0)
  begin //{
    idle2_started_with_k = 0;
    return;
  end //}

  if (idle2_started_with_k && idle2_non_AM_char_cnt>0)
  begin //{

    idle2_started_with_k = 0;

     if (~bfm_or_mon)
     begin //{

        -> rx_dh_trans.idle2_corrupt_seq;

       `uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE2_SEQUENCE_M_AFTER_KRRR_CHECK", $sformatf(" Spec reference 4.7.4.1.1. M character missing after a clock compensation sequence."))

       idle2_first_psr_seq = 0;

     end //}

  end //}


 if ((lane_idle_char == SRIO_A || lane_idle_char == SRIO_M) && lane_idle_cntl == 1)
 begin //{

   if (idle2_non_AM_char_cnt>0 && idle2_non_AM_char_cnt<16 && idle2_psr_char_cnt<509 && ~check_for_sync_seq)
   begin //{

     if (~bfm_or_mon)
     begin //{

      if (idle2_first_psr_seq)
       if((rx_dh_trans.current_init_state != NX_MODE | rx_dh_trans.current_init_state != X2_MODE | rx_dh_trans.current_init_state != X1_M0 | rx_dh_trans.current_init_state != X1_M1 | rx_dh_trans.current_init_state != X1_M2 ) && (rx_dh_env_config.idle_chk_err_dis == 1))
         `uvm_warning("SRIO_PL_RX_DATA_HANDLER : IDLE2_SEQUENCE_FIRST_PSR_DATA_MIN_SPACING_CHECK", $sformatf(" Spec reference 4.7.4.1.1. First contiguous Pseudo-random data shall be atleast 16 D0.0 characters. They are separated by %0d D0.0 characters", idle2_non_AM_char_cnt))
        else
         `uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE2_SEQUENCE_FIRST_PSR_DATA_MIN_SPACING_CHECK", $sformatf(" Spec reference 4.7.4.1.1. First contiguous Pseudo-random data shall be atleast 16 D0.0 characters. They are separated by %0d D0.0 characters", idle2_non_AM_char_cnt))
      else
       if((rx_dh_trans.current_init_state != NX_MODE | rx_dh_trans.current_init_state != X2_MODE | rx_dh_trans.current_init_state != X1_M0 | rx_dh_trans.current_init_state != X1_M1 | rx_dh_trans.current_init_state != X1_M2 ) && (rx_dh_env_config.idle_chk_err_dis == 1))
         `uvm_warning("SRIO_PL_RX_DATA_HANDLER : IDLE2_SEQUENCE_AM_CHAR_MIN_SPACING_CHECK", $sformatf(" Spec reference 4.7.4.1.1. Successive A/M characters in IDLE2 sequence has to be seperated by atleast 16 D0.0 characters. They are separated by %0d D0.0 characters", idle2_non_AM_char_cnt))
       else
         `uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE2_SEQUENCE_AM_CHAR_MIN_SPACING_CHECK", $sformatf(" Spec reference 4.7.4.1.1. Successive A/M characters in IDLE2 sequence has to be seperated by atleast 16 D0.0 characters. They are separated by %0d D0.0 characters", idle2_non_AM_char_cnt))

       idle2_first_psr_seq = 0;

     end //}

   end //}

   if (lane_idle_char == SRIO_M && lane_idle_cntl && idle2_M_char_cnt==0)
     last_idle2_non_AM_char_cnt = idle2_non_AM_char_cnt;

   idle2_non_AM_char_cnt = 0;
   idle2_first_psr_seq = 0;
	//if (~bfm_or_mon && mon_type)
	//$display($time, " 2. idle2_non_AM_char_cnt made 0 here");

 end //}


 if (idle2_non_AM_char_cnt>max_d00_char_cnt && idle2_psr_char_cnt< 504 && ~idle2_cs_marker && ~idle2_cs_field)
 begin //{

   if (~bfm_or_mon)
   begin //{

     if (idle2_first_psr_seq)
       if((rx_dh_trans.current_init_state != NX_MODE | rx_dh_trans.current_init_state != X2_MODE | rx_dh_trans.current_init_state != X1_M0 | rx_dh_trans.current_init_state != X1_M1 | rx_dh_trans.current_init_state != X1_M2 ) && (rx_dh_env_config.idle_chk_err_dis == 1))
       `uvm_warning("SRIO_PL_RX_DATA_HANDLER : IDLE2_SEQUENCE_FIRST_PSR_DATA_MAX_SPACING_CHECK", $sformatf(" Spec reference 4.7.4.1.1. First contiguous Pseudo-random data shall not be more than 35 D0.0 characters. They are separated by %0d D0.0 characters", idle2_non_AM_char_cnt))
       else
       `uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE2_SEQUENCE_FIRST_PSR_DATA_MAX_SPACING_CHECK", $sformatf(" Spec reference 4.7.4.1.1. First contiguous Pseudo-random data shall not be more than 35 D0.0 characters. They are separated by %0d D0.0 characters", idle2_non_AM_char_cnt))
     else
       if((rx_dh_trans.current_init_state != NX_MODE | rx_dh_trans.current_init_state != X2_MODE | rx_dh_trans.current_init_state != X1_M0 | rx_dh_trans.current_init_state != X1_M1 | rx_dh_trans.current_init_state != X1_M2 ) && (rx_dh_env_config.idle_chk_err_dis == 1))
       `uvm_warning("SRIO_PL_RX_DATA_HANDLER : IDLE2_SEQUENCE_AM_CHAR_MAX_SPACING_CHECK", $sformatf(" Spec reference 4.7.4.1.1. Successive A/M characters in IDLE2 sequence has to be seperated by not more than 31 D0.0 characters. They are separated by %0d D0.0 characters. If it is the last contiguous sequence, then the issue could be in PSR length or in the last contiguous sequence length.", idle2_non_AM_char_cnt))
       else 
       `uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE2_SEQUENCE_AM_CHAR_MAX_SPACING_CHECK", $sformatf(" Spec reference 4.7.4.1.1. Successive A/M characters in IDLE2 sequence has to be seperated by not more than 31 D0.0 characters. They are separated by %0d D0.0 characters. If it is the last contiguous sequence, then the issue could be in PSR length or in the last contiguous sequence length.", idle2_non_AM_char_cnt))

     idle2_first_psr_seq = 0;

   end //}

   idle2_non_AM_char_cnt = 0;
	//if (~bfm_or_mon && mon_type)
	//$display($time, " 3. idle2_non_AM_char_cnt made 0 here");

 end //}


endtask : idle2_contiguous_psr_length_check




//////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : idle2_total_psr_length_check
/// Description : This method is called by idle2_check.
/// Checks the total length of pseudo random sequence in IDLE2.
//////////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::idle2_total_psr_length_check();

 if (idle2_cs_marker && idle2_psr_char_cnt < 509)
 begin //{

 idle2_psr_length_check_done = 1;
 idle2_non_AM_char_cnt = 0;
	//if (~bfm_or_mon && mon_type)
	//$display($time, " 4. idle2_non_AM_char_cnt made 0 here");

   if (~bfm_or_mon)
   begin //{

     `uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE2_SEQUENCE_MIN_PSR_DATA_LENGTH_CHECK", $sformatf(" Spec reference 4.7.4.1.1. Length of Pseudo-random data characters in IDLE2 sequence is less than 509 characters. No. of IDLE2 PSR data characters generated before cs field marker is %0d", idle2_psr_char_cnt))

   end //}

   idle2_psr_char_cnt = 0;

 end //}
 else if (~idle2_cs_marker && idle2_M_char_cnt == 0 && idle2_psr_char_cnt > 515 && ~check_for_sync_seq)
 begin //{

 idle2_psr_length_check_done = 1;
 idle2_non_AM_char_cnt = 0;
	//if (~bfm_or_mon && mon_type)
	//$display($time, " 6. idle2_non_AM_char_cnt made 0 here");

   if (~bfm_or_mon)
   begin //{
   if((rx_dh_trans.current_init_state != NX_MODE | rx_dh_trans.current_init_state != X2_MODE | rx_dh_trans.current_init_state != X1_M0 | rx_dh_trans.current_init_state != X1_M1 | rx_dh_trans.current_init_state != X1_M2 ) && (rx_dh_env_config.idle_chk_err_dis == 1))
     `uvm_warning("SRIO_PL_RX_DATA_HANDLER : IDLE2_SEQUENCE_MAX_PSR_DATA_LENGTH_CHECK", $sformatf(" Spec reference 4.7.4.1.1. Length of Pseudo-random data characters in IDLE2 sequence is more than 515 characters. No. of IDLE2 PSR data characters generated before cs field marker is %0d", idle2_psr_char_cnt))
        else
     `uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE2_SEQUENCE_MAX_PSR_DATA_LENGTH_CHECK", $sformatf(" Spec reference 4.7.4.1.1. Length of Pseudo-random data characters in IDLE2 sequence is more than 515 characters. No. of IDLE2 PSR data characters generated before cs field marker is %0d", idle2_psr_char_cnt))

   end //}

   idle2_psr_char_cnt = 0;

 end //}
 else if (idle2_cs_marker)
 begin //{

   if (~bfm_or_mon)
   begin //{
     if (last_idle2_non_AM_char_cnt < 4)
     begin //{
       if((rx_dh_trans.current_init_state != NX_MODE | rx_dh_trans.current_init_state != X2_MODE | rx_dh_trans.current_init_state != X1_M0 | rx_dh_trans.current_init_state != X1_M1 | rx_dh_trans.current_init_state != X1_M2 ) && (rx_dh_env_config.idle_chk_err_dis == 1))
       `uvm_warning("SRIO_PL_RX_DATA_HANDLER : IDLE2_PSR_LAST_CONT_SEQ_MIN_LENGTH_CHECK", $sformatf(" Spec reference 4.7.4.1.1. Last contiguous sequence in IDLE2 PSR shall not be less than 4 characters. They are separated by %0d characters", last_idle2_non_AM_char_cnt))
        else
       `uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE2_PSR_LAST_CONT_SEQ_MIN_LENGTH_CHECK", $sformatf(" Spec reference 4.7.4.1.1. Last contiguous sequence in IDLE2 PSR shall not be less than 4 characters. They are separated by %0d characters", last_idle2_non_AM_char_cnt))
     end //}
     else if (last_idle2_non_AM_char_cnt > 35)
     begin //{
       if((rx_dh_trans.current_init_state != NX_MODE | rx_dh_trans.current_init_state != X2_MODE | rx_dh_trans.current_init_state != X1_M0 | rx_dh_trans.current_init_state != X1_M1 | rx_dh_trans.current_init_state != X1_M2 ) && (rx_dh_env_config.idle_chk_err_dis == 1))
       `uvm_warning("SRIO_PL_RX_DATA_HANDLER : IDLE2_PSR_LAST_CONT_SEQ_MAX_LENGTH_CHECK", $sformatf(" Spec reference 4.7.4.1.1. Last contiguous sequence in IDLE2 PSR shall not be more than 35 characters. They are separated by %0d characters", last_idle2_non_AM_char_cnt))
        else
       `uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE2_PSR_LAST_CONT_SEQ_MAX_LENGTH_CHECK", $sformatf(" Spec reference 4.7.4.1.1. Last contiguous sequence in IDLE2 PSR shall not be more than 35 characters. They are separated by %0d characters", last_idle2_non_AM_char_cnt))
     end //}
   end //}

 idle2_psr_length_check_done = 1;
 idle2_non_AM_char_cnt = 0;
 last_idle2_non_AM_char_cnt = 0;
	//if (~bfm_or_mon && mon_type)
	//$display($time, " 7. idle2_non_AM_char_cnt made 0 here");

   idle2_psr_char_cnt = 0;
 end //}

endtask : idle2_total_psr_length_check




//////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : idle2_cs_marker_check
/// Description : This method is called by idle2_check.
/// Checks the CS field marker in IDLE2 sequence.
//////////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::idle2_cs_marker_check();

 if (idle2_cs_marker_char_cnt == 5 || idle2_cs_marker_char_cnt == 7)
 begin //{

   if (idle2_cs_marker_char_cnt == 5)
     idle2_cs_marker_char_5 = lane_idle_char;
   else if (idle2_cs_marker_char_cnt == 7)
   begin //{

     if (idle2_cs_marker_char_5 != lane_idle_char)
     begin //{

       if (~bfm_or_mon)
       begin //{

        -> rx_dh_trans.idle2_cs_field_marker_corrupt;

        `uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE2_SEQUENCE_CS_MARKER_CHAR_5_CHAR_7_CHECK", $sformatf(" Spec reference 4.7.4.1.2. IDLE2 CS marker 5th character and 7th character has to be same. 5th Char is %0h. 7th Char is %0h", idle2_cs_marker_char_5, lane_idle_char))

       end //}

     end //}

   end //}

   if (lane_idle_char != SRIO_D21_5)
   begin //{

     if (lane_idle_char != SRIO_D10_2)
     begin //{

       if (~bfm_or_mon)
       begin //{

        -> rx_dh_trans.idle2_cs_field_marker_corrupt;

        `uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE2_SEQUENCE_CS_MARKER_CHAR_5_CHECK", $sformatf(" Spec reference 4.7.4.1.2. IDLE2 CS marker 5th character is neither D21.5 nor D10.2. Char is %0h Cntl is %0d", lane_idle_char, lane_idle_cntl))

       end //}

     end //}
     else	// if D10.2 received
     begin //{

       idle2_marker_d10_2_rcvd_cnt++;

       if (idle2_marker_d10_2_rcvd_cnt == 4) // TODO: Temp count to confirm lane polarity inversion.
       begin //{
 	rx_dh_trans.lane_polarity_inverted = 1;
       end //}

     end //}

   end //}
   else		// if D21.5 received
   begin //{

     if (idle2_marker_d10_2_rcvd_cnt>0)
       idle2_marker_d10_2_rcvd_cnt = 0;

   end //}

 end //}

 if (idle2_cs_marker_char_cnt == 6 || idle2_cs_marker_char_cnt == 8)
 begin //{

   if (idle2_cs_marker_char_cnt == 6)
     idle2_cs_marker_char_6 = lane_idle_char;
   else if (idle2_cs_marker_char_cnt == 8)
   begin //{

     if (idle2_cs_marker_char_6 != ~lane_idle_char)
     begin //{

       if (~bfm_or_mon)
       begin //{

        -> rx_dh_trans.idle2_cs_field_marker_corrupt;

        `uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE2_SEQUENCE_CHAR_6_CHAR_8_CHECK", $sformatf(" Spec reference 4.7.4.1.2. IDLE2 CS marker 6th character and 8th character has to be complement of each other. 6th Char is %0h. 8th Char is %0h", idle2_cs_marker_char_6, lane_idle_char))

       end //}

     end //}

   end //}

 end //}

endtask : idle2_cs_marker_check




//////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : idle2_cs_marker_dxy_check
/// Description : This method is called by idle_seq_checks since it has to be performed on a per lane
/// basis. It Checks the values of active link width and lane number field indicated by the CS marker.
//////////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::idle2_cs_marker_dxy_check();

  if (idle2_cs_marker && idle2_cs_marker_char_cnt == 5)
  begin //{
    if ((temp_idl_chk == 0 && lane0_idle_cntl) || (temp_idl_chk != 0 && lane_idle_cntl))
      return;
  
    idle2_lane_num = (temp_idl_chk == 0) ? lane0_idle_char[4:0] : lane_idle_char[4:0];
    idle2_active_link_width = (temp_idl_chk == 0) ? lane0_idle_char[7:5] : lane_idle_char[7:5];
  
    if (idle2_lane_num > 15)
    begin //{
  
      if (~bfm_or_mon)
      begin //{
  
        -> rx_dh_trans.idle2_cs_field_marker_corrupt;

  	`uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE2_SEQUENCE_RSVD_LANE_NUM_IN_CS_MARKER_CHECK", $sformatf(" Spec reference 4.7.4.1.2 / Table 4-6. Reserved lane number indicated in IDLE2 CS marker. Lane number field is %0d", idle2_lane_num))
  
      end //}
  
    end //}
  
    if (idle2_lane_num !== temp_idl_chk)
    begin //{
  
      if (~bfm_or_mon)
      begin //{
  
        -> rx_dh_trans.idle2_cs_field_marker_corrupt;

  	`uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE2_SEQUENCE_WRONG_LANE_NUM_IN_CS_MARKER_CHECK", $sformatf(" Spec reference 4.7.4.1.2 / Table 4-6. Wrong lane number indicated in IDLE2 CS marker. Actual lane number is %0d, Lane number field received is %0d", temp_idl_chk, idle2_lane_num))
  
      end //}
  
    end //}
  
    if (rx_dh_common_mon_trans.port_initialized[~mon_type])
    begin //{
  
      exp_idle2_active_link_width = (rx_dh_common_mon_trans.current_init_state[~mon_type] == NX_MODE)
  					? (rx_dh_env_config.num_of_lanes == 4) ? 3'b010 :
  					(rx_dh_env_config.num_of_lanes == 8) ? 3'b011 : 3'b100
  					: (rx_dh_common_mon_trans.current_init_state[~mon_type] == X2_MODE) ? 3'b001 : 3'b000;
  					
  
      if (idle2_active_link_width !== exp_idle2_active_link_width)
      begin //{
  
        if ((exp_idle2_active_link_width !== 3'b000) || ((exp_idle2_active_link_width == 3'b000) && !(idle2_active_link_width == 3'b101 || idle2_active_link_width == 3'b110 || idle2_active_link_width == 3'b111)))
        begin //{
  
      	if (~bfm_or_mon)
      	begin //{
  
          -> rx_dh_trans.idle2_cs_field_marker_corrupt;

      	  `uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE2_SEQUENCE_WRONG_LINK_WIDTH_IN_CS_MARKER_CHECK", $sformatf(" Spec reference 4.7.4.1.2 / Table 4-5. Wrong active link width indicated in IDLE2 CS marker. Expected active link width is %0d, Received active link width is %0d ", exp_idle2_active_link_width, idle2_active_link_width))
  
      	end //}
  
        end //}
  
      end //}
  
    end //}
  
  end //}

endtask : idle2_cs_marker_dxy_check




//////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : idle2_cs_field_check
/// Description : This method is called by idle2_check.
/// Checks whether invalid characters are received in CS field. Training related checks are performed in
/// the lane handler component itself.
//////////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::idle2_cs_field_check();

 if (idle2_cs_field && idle2_cs_field_char_cnt>0)
 begin //{

   if (lane_idle_char !== 8'h67 && lane_idle_char !== 8'h78 && lane_idle_char !== 8'h7E && lane_idle_char !== 8'hF8 && ~check_for_sync_seq)
   begin //{

        if (~rx_dh_trans.ies_state && rx_dh_trans.link_initialized)
        begin //{
          idle2_cs_field=0;
          idle2_cs_field_char_cnt=0;
          idle_check_in_progress=0;
          rx_dh_trans.ies_state = 1;
          rx_dh_trans.ies_cause_value = 5;
	//$display($time, " 3. Vaidhy : ies_state set here");
        end //}

    	if (~bfm_or_mon)
    	begin //{

          -> rx_dh_trans.idle2_cs_field_corrupt;

    	  `uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE2_SEQUENCE_INVALID_CS_FIELD_CHAR_CHECK", $sformatf(" Spec reference 4.7.4.1.3. Invalid / Illegal character received during IDLE2 CS Field. Char is %0h", lane_idle_char))

    	end //}

   end //}
   else
   begin //{

     if (idle2_cs_field_char_cnt == 1)
       cs_fld_bit_loc = 0;
     else
       cs_fld_bit_loc = cs_fld_bit_loc+2;

     if (lane_idle_char == 8'h67)
	idle2_cs_field_bits[cs_fld_bit_loc+:2] = 2'b00;
     else if (lane_idle_char == 8'h78)
	idle2_cs_field_bits[cs_fld_bit_loc+:2] = 2'b01;
     else if (lane_idle_char == 8'h7E)
	idle2_cs_field_bits[cs_fld_bit_loc+:2] = 2'b10;
     else if (lane_idle_char == 8'hF8)
	idle2_cs_field_bits[cs_fld_bit_loc+:2] = 2'b11;

   end //}

   if (idle2_cs_field_char_cnt>16)
   begin //{

     if (idle2_cs_field_char_cnt == 17)
     begin //{
       cs_fld_bit_loc_2 = 17;
       cs_fld_bit_loc_3 = 15;
     end //}
     else
     begin //{
       cs_fld_bit_loc_2 = cs_fld_bit_loc_2-1;
       cs_fld_bit_loc_3 = cs_fld_bit_loc_3+1;
     end //}

     idle2_cs_field_cmp_bits = idle2_cs_field_char_cnt-cs_fld_bit_loc_2;
     idle2_cs_field_curr_bits = idle2_cs_field_char_cnt+cs_fld_bit_loc_3;

     if (idle2_cs_field_bits[idle2_cs_field_cmp_bits+:2] !== ~(idle2_cs_field_bits[idle2_cs_field_curr_bits+:2]))
     begin //{

    	  if (~bfm_or_mon)
    	  begin //{

            -> rx_dh_trans.idle2_cs_field_corrupt;

    	    `uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE2_SEQUENCE_CS_FIELD_CHECK", $sformatf(" Spec reference 4.7.4.1.3. IDLE2 CS Field bits [0:31] are not complement of [32:63]. Info Bits [%0d:%0d] is %0b. Check Bits at [%0d:%0d] is %0b", idle2_cs_field_cmp_bits, idle2_cs_field_cmp_bits+1, idle2_cs_field_bits[idle2_cs_field_cmp_bits+:2], idle2_cs_field_curr_bits, idle2_cs_field_curr_bits+1, idle2_cs_field_bits[idle2_cs_field_curr_bits+:2]))

    	  end //}

     end //}

   end //}

   if (idle2_cs_field_char_cnt == 32)
     idle_check_in_progress = 0;

 end //}

endtask : idle2_cs_field_check




//////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : idle2_truncation_check
/// Description : This method is called when a control symbol or packet is detected while IDLE2 sequence
/// is in progress. It checks whether IDLE2 truncation rules are properly followed or not.
//////////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::idle2_truncation_check();

  if (~rx_dh_config.idle_seq_check_en || ~rx_dh_config.has_checks)
    return;

  if (cntl_symbol_open || local_cntl_symbol_open || lcs_completed_in_same_column)
  begin //{

	//if (~bfm_or_mon && mon_type)
	//  $display($time, " Inside idle2_truncation_check task");

    idle_check_in_progress = 0;
    idle2_cs_marker = 0;
    idle2_cs_field = 0;

    if (idle2_D_after_M_cnt>0 && idle2_D_after_M_cnt<4)
    begin //{

      if (~bfm_or_mon)
      begin //{

        `uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE2_SEQUENCE_PSR_DATA_TRUNCATION_CHECK", $sformatf(" Spec reference 4.7.4. IDLE2 sequence shall not be truncated in an MDDDD sequence. idle2_D_after_M_cnt is %0d", idle2_D_after_M_cnt))

      end //}

    end //}

    if (idle2_cs_marker && idle2_M_char_cnt>0 && idle2_M_char_cnt<4)
    begin //{

      if (~bfm_or_mon)
      begin //{

        `uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE2_SEQUENCE_CS_MARKER_TRUNCATION_CHECK", $sformatf(" Spec reference 4.7.4. IDLE2 sequence shall not be truncated in MMMM sequence of CS Marker. idle2_M_char_cnt is %0d", idle2_M_char_cnt))

      end //}

    end //}

  end //}

endtask : idle2_truncation_check




//////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : idle_negotiation_check
/// Description : This method checks if proper idle sequence is negotiated or not.
//////////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::idle_negotiation_check();

  if (~bfm_or_mon)
  begin //{

    forever begin //{

      wait(rx_dh_common_mon_trans.idle_selection_done.exists(0) && rx_dh_common_mon_trans.idle_selection_done.exists(1));

      wait (rx_dh_common_mon_trans.idle_selection_done[0] == 1 && rx_dh_common_mon_trans.idle_selection_done[1] == 1);

      if (rx_dh_common_mon_trans.selected_idle[0] !== rx_dh_common_mon_trans.selected_idle[1])
      begin //{

        `uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE_SEQUENCE_NEGOTIATION_CHECK", $sformatf(" Spec reference 4.7.4. IDLE2 sequence did not negotiate down to IDLE1 to match the link partner."))

      end //}

      wait (rx_dh_common_mon_trans.idle_selection_done[0] == 0 || rx_dh_common_mon_trans.idle_selection_done[1] == 0);

    end //}

  end //}

endtask : idle_negotiation_check




//////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : control_symbol_check
/// Description : This method performs control symbol format related checks based on whether short control
/// symbol or long control symbol is being received.
//////////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::control_symbol_check(input int lane_num);

  bit [7:0] temp_cs_delim;

  if(~rx_dh_config.has_checks)
    return;

  if (rx_dh_trans.current_init_state == NX_MODE)
  begin //{

	//$display($time, " Inside control_symbol_check task. bfm_or_mon is %0d, mon_type is %0d Char received are:", bfm_or_mon, mon_type);
//	for(int ttv=lane_num; ttv<lane_num+4; ttv++)
//	  $display($time, " Char %0d is %0h", ttv, nx_align_data.character[ttv]);

    if (cntl_symbol_bytes == 4 || (rx_dh_trans.idle_detected && ~rx_dh_trans.idle_selected))
    begin //{

      if (nx_align_data.cntl[lane_num+1] || nx_align_data.cntl[lane_num+2] || nx_align_data.cntl[lane_num+3])
      begin //{
        cntl_symbol_err = 1;
        link_init_cntl_symbol_err = 1;
        -> rx_dh_trans.idle_seq_in_scs;
      end //}

    end //}
    else if(rx_dh_trans.idle_selected && (cntl_symbol_open || prev_cntl_symbol_open))
    begin //{

      if (nx_align_data.cntl[lane_num] || nx_align_data.cntl[lane_num+1] || nx_align_data.cntl[lane_num+2])
      begin //{
        cntl_symbol_err = 1;
        link_init_cntl_symbol_err = 1;
        -> rx_dh_trans.idle_seq_in_lcs;
      end //}

    end //}

    if (cntl_symbol_err)
    begin //{

      cntl_symbol_err = 0;

      if (~rx_dh_trans.ies_state && rx_dh_trans.link_initialized)
      begin //{
        rx_dh_trans.ies_state = 1;
        rx_dh_trans.ies_cause_value = 5;
	//$display($time, " 4. Vaidhy : ies_state set here");
      end //}

      if (~bfm_or_mon)
      begin //{

        `uvm_error("SRIO_PL_RX_DATA_HANDLER : INVALID_CHAR_IN_CONTROL_SYMBOL_CHECK", $sformatf(" Spec reference 5.13.2.3.2. Invalid / Illegal character seen in between control symbol. character is %0h %0h %0h %0h, cntl is %0d %0d %0d %0d", nx_align_data.character[lane_num], nx_align_data.character[lane_num+1], nx_align_data.character[lane_num+2], nx_align_data.character[lane_num+3], nx_align_data.cntl[lane_num], nx_align_data.cntl[lane_num+1], nx_align_data.cntl[lane_num+2], nx_align_data.cntl[lane_num+3]))

      end //}

    end //}

    if (~cntl_symbol_open && prev_cntl_symbol_open && rx_dh_trans.idle_selected)
    begin //{

      if (srio_trans_cs_ins.cs_kind == SRIO_DELIM_SC)
        temp_cs_delim = SRIO_SC;
      else if (srio_trans_cs_ins.cs_kind == SRIO_DELIM_PD)
        temp_cs_delim = SRIO_PD;

      if (nx_align_data.character[lane_num+3] != temp_cs_delim)
      begin //{
	cntl_symbol_err = 1;
        link_init_cntl_symbol_err = 1;
      end //}

      if (cntl_symbol_err)
      begin //{

        cntl_symbol_err = 0;

        if (~bfm_or_mon)
        begin //{

          `uvm_error("SRIO_PL_RX_DATA_HANDLER : CONTROL_SYMBOL_SAME_START_END_DELIMTER_CHECK", $sformatf(" Spec reference 5.13.2.3.2. Start delimiter and end delimiter are not same. start delimiter is %0h, end delimiter is %0h", temp_cs_delim, nx_align_data.character[lane_num+3]))

        end //}

      end //}


      if (nx_align_data.cntl[lane_num+3] != 1)
      begin //{
	cntl_symbol_err = 1;
        link_init_cntl_symbol_err = 1;
      end //}

      if (cntl_symbol_err)
      begin //{

        cntl_symbol_err = 0;

        if (~bfm_or_mon)
        begin //{

       	  -> rx_dh_trans.lcs_without_end_delimiter;

          `uvm_error("SRIO_PL_RX_DATA_HANDLER : CONTROL_SYMBOL_END_DELIMITER_POSITION_CHECK", $sformatf(" Spec reference 5.13.2.3.2. End delimiter is missing from the 7th character position from the start delimiter."))

        end //}

      end //}

    end //}

  end //}
  else if (rx_dh_trans.current_init_state == X2_MODE)
  begin //{

    //$display($time, " control_symbol_check is called");

    if (cntl_symbol_bytes == 2 || (rx_dh_trans.idle_detected && ~rx_dh_trans.idle_selected))
    begin //{

      if (x2_align_data.cntl[lane_num+1] && cntl_symbol_bytes == 2)
      begin //{
        cntl_symbol_err = 1;
        link_init_cntl_symbol_err = 1;
        -> rx_dh_trans.idle_seq_in_scs;
	//$display($time, " 1. cntl_symbol_err set here");
      end //}
      else if (x2_align_data.cntl[lane_num] && rx_dh_trans.idle_detected && ~rx_dh_trans.idle_selected && cntl_symbol_bytes != 2) // for SCS
      begin //{
        cntl_symbol_err = 1;
        link_init_cntl_symbol_err = 1;
        -> rx_dh_trans.idle_seq_in_scs;
	//$display($time, " 2. cntl_symbol_err set here");
      end //}

    end //}
    else if(rx_dh_trans.idle_selected && (cntl_symbol_open || prev_cntl_symbol_open))
    begin //{

      if ((x2_align_data.cntl[lane_num] || x2_align_data.cntl[lane_num+1]) && cntl_symbol_bytes>2 && cntl_symbol_bytes<8)
      begin //{
        cntl_symbol_err = 1;
        link_init_cntl_symbol_err = 1;
        -> rx_dh_trans.idle_seq_in_lcs;
      end //}
      else if (x2_align_data.cntl[lane_num] && cntl_symbol_bytes != 2)
      begin //{
        cntl_symbol_err = 1;
        link_init_cntl_symbol_err = 1;
        -> rx_dh_trans.idle_seq_in_lcs;
      end //}

    end //}

    if (cntl_symbol_err)
    begin //{

      cntl_symbol_err = 0;

      if (~rx_dh_trans.ies_state && rx_dh_trans.link_initialized)
      begin //{
        rx_dh_trans.ies_state = 1;
        rx_dh_trans.ies_cause_value = 5;
	//$display($time, " 5. Vaidhy : ies_state set here");
      end //}

      if (~bfm_or_mon)
      begin //{

        `uvm_error("SRIO_PL_RX_DATA_HANDLER : INVALID_CHAR_IN_CONTROL_SYMBOL_CHECK", $sformatf(" Spec reference 5.13.2.3.2. Invalid / Illegal character seen in between control symbol. character is %0h %0h, cntl is %0d %0d", x2_align_data.character[lane_num], x2_align_data.character[lane_num+1], x2_align_data.cntl[lane_num], x2_align_data.cntl[lane_num+1]))

      end //}

    end //}

    if (~cntl_symbol_open && prev_cntl_symbol_open && rx_dh_trans.idle_selected)
    begin //{

      if (srio_trans_cs_ins.cs_kind == SRIO_DELIM_SC)
        temp_cs_delim = SRIO_SC;
      else if (srio_trans_cs_ins.cs_kind == SRIO_DELIM_PD)
        temp_cs_delim = SRIO_PD;

      if (x2_align_data.character[lane_num+1] != temp_cs_delim)
      begin //{
	cntl_symbol_err = 1;
        link_init_cntl_symbol_err = 1;
      end //}

      if (cntl_symbol_err)
      begin //{

        cntl_symbol_err = 0;

        if (~bfm_or_mon)
        begin //{

          `uvm_error("SRIO_PL_RX_DATA_HANDLER : CONTROL_SYMBOL_SAME_START_END_DELIMTER_CHECK", $sformatf(" Spec reference 5.13.2.3.2. Start delimiter and end delimiter are not same. start delimiter is %0h, end delimiter is %0h", temp_cs_delim, x2_align_data.character[lane_num+1]))

        end //}

      end //}


      if (x2_align_data.cntl[lane_num+1] != 1)
      begin //{
	cntl_symbol_err = 1;
        link_init_cntl_symbol_err = 1;
      end //}

      if (cntl_symbol_err)
      begin //{

        cntl_symbol_err = 0;

        if (~bfm_or_mon)
        begin //{

       	  -> rx_dh_trans.lcs_without_end_delimiter;

          `uvm_error("SRIO_PL_RX_DATA_HANDLER : CONTROL_SYMBOL_END_DELIMITER_POSITION_CHECK", $sformatf(" Spec reference 5.13.2.3.2. End delimiter is missing from the 7th character position from the start delimiter."))

        end //}

      end //}

    end //}

  end //}
  else if (rx_dh_trans.current_init_state == X1_M0 || rx_dh_trans.current_init_state == X1_M1 || rx_dh_trans.current_init_state == X1_M2)
  begin //{

    if (rx_dh_trans.idle_detected && ~rx_dh_trans.idle_selected)
    begin //{

      if (x1_lane_data.cntl && (cntl_symbol_bytes > 1 || prev_cntl_symbol_open))
      begin //{
        cntl_symbol_err = 1;
        link_init_cntl_symbol_err = 1;
        -> rx_dh_trans.idle_seq_in_scs;
      end //}

    end //}
    else if(rx_dh_trans.idle_selected && cntl_symbol_open)
    begin //{

      if (x1_lane_data.cntl && cntl_symbol_bytes>1)
      begin //{
        cntl_symbol_err = 1;
        link_init_cntl_symbol_err = 1;
        -> rx_dh_trans.idle_seq_in_lcs;
      end //}

    end //}

    if (cntl_symbol_err)
    begin //{

      cntl_symbol_err = 0;

      if (~rx_dh_trans.ies_state && rx_dh_trans.link_initialized)
      begin //{
        rx_dh_trans.ies_state = 1;
        rx_dh_trans.ies_cause_value = 5;
	//$display($time, " 6. Vaidhy : ies_state set here");
      end //}

      if (~bfm_or_mon)
      begin //{

        `uvm_error("SRIO_PL_RX_DATA_HANDLER : INVALID_CHAR_IN_CONTROL_SYMBOL_CHECK", $sformatf(" Spec reference 5.13.2.3.2. Invalid / Illegal character seen in between control symbol. character is %0h, cntl is %0d", x1_lane_data.character, x1_lane_data.cntl))

      end //}

    end //}

    if (~cntl_symbol_open && prev_cntl_symbol_open && rx_dh_trans.idle_selected)
    begin //{

      if (srio_trans_cs_ins.cs_kind == SRIO_DELIM_SC)
        temp_cs_delim = SRIO_SC;
      else if (srio_trans_cs_ins.cs_kind == SRIO_DELIM_PD)
        temp_cs_delim = SRIO_PD;

      if (x1_lane_data.character != temp_cs_delim)
      begin //{
	cntl_symbol_err = 1;
        link_init_cntl_symbol_err = 1;
      end //}

      if (cntl_symbol_err)
      begin //{

        cntl_symbol_err = 0;

        if (~bfm_or_mon)
        begin //{

          `uvm_error("SRIO_PL_RX_DATA_HANDLER : CONTROL_SYMBOL_SAME_START_END_DELIMTER_CHECK", $sformatf(" Spec reference 5.13.2.3.2. Start delimiter and end delimiter are not same. start delimiter is %0h, end delimiter is %0h", temp_cs_delim, x1_lane_data.character))

        end //}

      end //}


      if (x1_lane_data.cntl != 1)
      begin //{
	cntl_symbol_err = 1;
        link_init_cntl_symbol_err = 1;
      end //}

      if (cntl_symbol_err)
      begin //{

        cntl_symbol_err = 0;

        if (~bfm_or_mon)
        begin //{

       	  -> rx_dh_trans.lcs_without_end_delimiter;

          `uvm_error("SRIO_PL_RX_DATA_HANDLER : CONTROL_SYMBOL_END_DELIMITER_POSITION_CHECK", $sformatf(" Spec reference 5.13.2.3.2. End delimiter is missing from the 7th character position from the start delimiter."))

        end //}

      end //}

    end //}

  end //}

endtask : control_symbol_check




//////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : check_pkt_char
/// Description : This method checks if any invalid characters are received in between a packet.
//////////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::check_pkt_char(input int pkt_lane_num);

  if(~rx_dh_config.has_checks)
    return;

  if (rx_dh_trans.current_init_state == NX_MODE)
  begin //{

    if((nx_align_data.cntl[pkt_lane_num] || nx_align_data.cntl[pkt_lane_num+1] || nx_align_data.cntl[pkt_lane_num+2] || nx_align_data.cntl[pkt_lane_num+3]) && ~check_for_sync_seq)
    begin //{

      if (~rx_dh_trans.ies_state && rx_dh_trans.link_initialized)
      begin //{
        rx_dh_trans.ies_state = 1;
        rx_dh_trans.ies_cause_value = 5;
	//$display($time, " 7. Vaidhy : ies_state set here");
      end //}

      if (~bfm_or_mon)
      begin //{

        -> rx_dh_trans.idle_seq_in_pkt_err;

        `uvm_error("SRIO_PL_RX_DATA_HANDLER : INVALID_CHAR_IN_PACKET_CHECK", $sformatf(" Spec reference 5.13.2.4. Invalid / Illegal character observed inbetween a packet. character is %0h %0h %0h %0h, cntl is %0d %0d %0d %0d", nx_align_data.character[pkt_lane_num], nx_align_data.character[pkt_lane_num+1], nx_align_data.character[pkt_lane_num+2], nx_align_data.character[pkt_lane_num+3], nx_align_data.cntl[pkt_lane_num], nx_align_data.cntl[pkt_lane_num+1], nx_align_data.cntl[pkt_lane_num+2], nx_align_data.cntl[pkt_lane_num+3]))

      end //}

    end //}

  end //}
  else if (rx_dh_trans.current_init_state == X2_MODE)
  begin //{

    if((x2_align_data.cntl[pkt_lane_num] || x2_align_data.cntl[pkt_lane_num+1]) && ~check_for_sync_seq)
    begin //{

      if (~rx_dh_trans.ies_state && rx_dh_trans.link_initialized)
      begin //{
        rx_dh_trans.ies_state = 1;
        rx_dh_trans.ies_cause_value = 5;
	//$display($time, " 8. Vaidhy : ies_state set here");
      end //}

      if (~bfm_or_mon)
      begin //{

        -> rx_dh_trans.idle_seq_in_pkt_err;

        `uvm_error("SRIO_PL_RX_DATA_HANDLER : INVALID_CHAR_IN_PACKET_CHECK", $sformatf(" Spec reference 5.13.2.4. Invalid / Illegal character observed inbetween a packet. character is %0h %0h, cntl is %0d %0d", x2_align_data.character[pkt_lane_num], x2_align_data.character[pkt_lane_num+1], x2_align_data.cntl[pkt_lane_num], x2_align_data.cntl[pkt_lane_num+1]))

      end //}

    end //}

  end //}
  else if (rx_dh_trans.current_init_state == X1_M0 || rx_dh_trans.current_init_state == X1_M1 || rx_dh_trans.current_init_state == X1_M2)
  begin //{

    if(x1_lane_data.cntl && ~check_for_sync_seq)
    begin //{

      if (~rx_dh_trans.ies_state && rx_dh_trans.link_initialized)
      begin //{
        rx_dh_trans.ies_state = 1;
        rx_dh_trans.ies_cause_value = 5;
	//$display($time, " 9. Vaidhy : ies_state set here");
      end //}

      if (~bfm_or_mon)
      begin //{

        -> rx_dh_trans.idle_seq_in_pkt_err;

        `uvm_error("SRIO_PL_RX_DATA_HANDLER : INVALID_CHAR_IN_PACKET_CHECK", $sformatf(" Spec reference 5.13.2.4. Invalid / Illegal character observed inbetween a packet. character is %0h, cntl is %0d", x1_lane_data.character, x1_lane_data.cntl))

      end //}

    end //}

  end //}

endtask : check_pkt_char



//////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : pkt_size_err
/// Description : This method checks the size of packet. pkt_size_err_reported variable is used in this
/// method to restrict the pkt size error display to one time.
//////////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::pkt_size_err();

      if (check_for_sync_seq || rx_dh_trans.sync_seq_detected || sync_seq_started)
	return;

  if (~rx_dh_trans.ies_state && rx_dh_trans.link_initialized)
  begin //{
    rx_dh_trans.ies_state = 1;
    rx_dh_trans.ies_cause_value = 31;
    if(rx_dh_env_config.max_pkt_err_cause)
     rx_dh_trans.ies_cause_value = 5;
     //$display($time, " 11. Vaidhy : ies_state set here");
  end //}

  if (bfm_or_mon || ~rx_dh_config.has_checks || pkt_size_err_reported)
    return;

  capture_0_reg_val = {rx_dh_trans.bytestream[3],  rx_dh_trans.bytestream[2],  rx_dh_trans.bytestream[1],  rx_dh_trans.bytestream[0]};
  capture_1_reg_val = {rx_dh_trans.bytestream[7],  rx_dh_trans.bytestream[6],  rx_dh_trans.bytestream[5],  rx_dh_trans.bytestream[4]};
  capture_2_reg_val = {rx_dh_trans.bytestream[11], rx_dh_trans.bytestream[10], rx_dh_trans.bytestream[9],  rx_dh_trans.bytestream[8]};
  capture_3_reg_val = {rx_dh_trans.bytestream[15], rx_dh_trans.bytestream[14], rx_dh_trans.bytestream[13], rx_dh_trans.bytestream[12]};
  capture_4_reg_val = {rx_dh_trans.bytestream[19], rx_dh_trans.bytestream[18], rx_dh_trans.bytestream[17], rx_dh_trans.bytestream[16]};

  pkt_size_err_reported = 1;

  update_error_detect_csr("PKT_SIZE_ERR");

  `uvm_error("SRIO_PL_RX_DATA_HANDLER : PKT_SIZE_CHECK", $sformatf(" Spec reference 5.13.2.4. Max packet size exceeded. Max packet size is %0d", rx_dh_config.max_pkt_size))

endtask : pkt_size_err




//////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : clk_comp_seq_rate_check
/// Description : This method checks the clock compensation sequence frequency.
//////////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::clk_comp_seq_rate_check();

  if (rx_dh_trans.idle_detected && temp_sdi_var == active_lane_for_idle)
  begin //{

    if ((srio_data_ins[temp_sdi_var].character == SRIO_K && srio_data_ins[temp_sdi_var].cntl) && ~k_for_clk_comp_check_rcvd && ~clk_comp_started)
    begin //{
      k_for_clk_comp_check_rcvd = 1;
      clk_comp_rcvd = 0;
    end //}
    else if ((srio_data_ins[temp_sdi_var].character != SRIO_R && srio_data_ins[temp_sdi_var].cntl) && k_for_clk_comp_check_rcvd && rx_dh_trans.idle_selected)
    begin //{
  
      k_for_clk_comp_check_rcvd = 0;
      if (~bfm_or_mon)
      begin //{
  
  	`uvm_error("SRIO_PL_RX_DATA_HANDLER : KR_CHECK", $sformatf(" R didn't follow K in IDLE2 sequence."))
  
      end //}
  
    end //}
    else if((srio_data_ins[temp_sdi_var].character == SRIO_R && srio_data_ins[temp_sdi_var].cntl) && k_for_clk_comp_check_rcvd)
    begin //{

      k_for_clk_comp_check_rcvd = 0;
      clk_comp_started = 1;
  
      cg_bet_clk_comp_cnt = 0;

    end //}
    else if ((clk_comp_started || k_for_clk_comp_check_rcvd) && (srio_data_ins[temp_sdi_var].character != SRIO_R && srio_data_ins[temp_sdi_var].cntl))
    begin //{
      if (~clk_comp_started && k_for_clk_comp_check_rcvd)
        k_for_clk_comp_check_rcvd = 0;
      else if (clk_comp_started && ~k_for_clk_comp_check_rcvd)
      begin //{
        clk_comp_started = 0;
        clk_comp_rcvd = 1;
      end //}
    end //}
    else if (clk_comp_rcvd)
      cg_bet_clk_comp_cnt++;
  
      //if (~bfm_or_mon && mon_type)
      //  $display($time, " TX_CLK_COMP_CNT : num_cg_cnt is %0d", cg_bet_clk_comp_cnt);
      //else if(~bfm_or_mon && ~mon_type)
      //  $display($time, " RX_CLK_COMP_CNT : num_cg_cnt is %0d", cg_bet_clk_comp_cnt);

    if (~bfm_or_mon && ~report_error)
    begin //{
      if (cg_bet_clk_comp_cnt > rx_dh_config.clk_compensation_seq_rate)
        clk_comp_freq_err = 1;
    end //}
    else if (~bfm_or_mon && report_error)
    begin //{
      if (cg_bet_clk_comp_cnt > 5000)
        clk_comp_freq_err = 1;
    end //}
  
    if (clk_comp_freq_err)
    begin //{

      if (report_error)
        `uvm_error("SRIO_PL_RX_DATA_HANDLER : CG_BETWEEN_CLK_COMP_CHECK", $sformatf(" Spec reference 4.7.1. Number of code groups between successive clock compensation sequences exceeded. Expected count is 5000. Actual count is %0d", cg_bet_clk_comp_cnt))
      else
        `uvm_error("SRIO_PL_RX_DATA_HANDLER : CG_BETWEEN_CLK_COMP_CHECK", $sformatf(" Spec reference 4.7.1. Number of code groups between successive clock compensation sequences exceeded. Expected count is %0d. Actual count is %0d", rx_dh_config.clk_compensation_seq_rate, cg_bet_clk_comp_cnt))
  
      clk_comp_freq_err = 0;
      cg_bet_clk_comp_cnt = 0;
  
    end //}
  
  
  end //}
  if(~rx_dh_trans.idle_detected)
   cg_bet_clk_comp_cnt=0;

endtask : clk_comp_seq_rate_check




//////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : sync_sequence_capture
/// Description : This method detects the sync sequence that is being received and also checks if complete
/// sync sequence is received properly or not. Based on the variable set in this method, other method will
/// check if link-request is following sync sequence or not.
//////////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::sync_sequence_capture();

  if (~rx_dh_trans.idle_detected || ~rx_dh_trans.idle_selected || temp_sdi_var != active_lane_for_idle)
    return;


  if (srio_data_ins[active_lane_for_idle].character == SRIO_M && srio_data_ins[active_lane_for_idle].cntl)
  begin //{

    sync_seq_MDDDD_cnt++;

    if (sync_seq_D_cnt == 0 && ~check_for_sync_seq)
      check_for_sync_seq = 1;
    else if (sync_seq_D_cnt == 0 && check_for_sync_seq)
    begin //{
      check_for_sync_seq = 0;
      sync_seq_MDDDD_cnt = 0;
    end //}
    else if (sync_seq_D_cnt == 4)
      sync_seq_D_cnt = 0;
    else if (sync_seq_D_cnt < 4 && sync_seq_started)
    begin //{

      sync_seq_MDDDD_cnt = 0;
      check_for_sync_seq = 0;
      sync_seq_D_cnt = 0;

      sync_seq_started = 0;

      if (~bfm_or_mon)
      begin //{

        `uvm_error("SRIO_PL_RX_DATA_HANDLER : INCOMPLETE_SYNC_SEQUENCE_CHECK", $sformatf(" Spec reference 4.8.2. Invalid / incomplete descrambler sync sequence detected."))

      end //}

    end //}

    //$display($time, " 1. sync_seq_chk : sync_seq_MDDDD_cnt is %0d, sync_seq_D_cnt is %0d, check_for_sync_seq is %0d, sync_seq_started is %0d", sync_seq_MDDDD_cnt, sync_seq_D_cnt, check_for_sync_seq, sync_seq_started);

  end //}
  else if(check_for_sync_seq && srio_data_ins[active_lane_for_idle].character == SRIO_D00 && srio_data_ins[active_lane_for_idle].cntl == 0)
  begin //{

    sync_seq_D_cnt++;

    if (sync_seq_MDDDD_cnt == 2)
    begin //{

      sync_seq_started = 1;

//      if (packet_open)
//	rx_dh_trans.packet_cancelled = 1;

    end //}
    else if (sync_seq_D_cnt > 4)
    begin //{
      sync_seq_MDDDD_cnt = 0;
      check_for_sync_seq = 0;
      sync_seq_D_cnt = 0;
      return;
    end //}

    if (sync_seq_MDDDD_cnt == 4 && sync_seq_D_cnt == 4)
    begin //{
      idle2_cs_field=0;
      idle2_cs_marker=0;
      idle_check_in_progress=0;
      sync_seq_MDDDD_cnt = 0;
      sync_seq_started = 0;
      check_for_sync_seq = 0;
      sync_seq_D_cnt = 0;
      rx_dh_trans.sync_seq_detected = 1;
    end //}

    //$display($time, " 2. sync_seq_chk : sync_seq_MDDDD_cnt is %0d, sync_seq_D_cnt is %0d, check_for_sync_seq is %0d, sync_seq_started is %0d sync_seq_detected is %0d", sync_seq_MDDDD_cnt, sync_seq_D_cnt, check_for_sync_seq, sync_seq_started, rx_dh_trans.sync_seq_detected);

  end //}
  else if (sync_seq_started && ~rx_dh_trans.sync_seq_detected)
  begin //{

    sync_seq_MDDDD_cnt = 0;
    sync_seq_started = 0;
    check_for_sync_seq = 0;
    sync_seq_D_cnt = 0;

    if (~bfm_or_mon)
    begin //{

      `uvm_error("SRIO_PL_RX_DATA_HANDLER : INCOMPLETE_SYNC_SEQUENCE_CHECK", $sformatf(" Spec reference 4.8.2. Invalid / incomplete descrambler sync sequence detected."))

    end //}

  end //}
  else if (check_for_sync_seq && ~sync_seq_started && ~rx_dh_trans.sync_seq_detected)
  begin //{
    sync_seq_MDDDD_cnt = 0;
    check_for_sync_seq = 0;
    sync_seq_D_cnt = 0;
  end //}

endtask : sync_sequence_capture




//////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : form_gen3_srio_trans
/// Description : This method forms the conrtol symbol and packet transactions for GEN3.0 mode.
/// It is equivalent to form_2x_srio_trans / form_nx_srio_trans used for GEN1.3 & GEN2.x modes.
/// Since control symbol can start on any lane in 3.0 mode, this method is called on a per-lane basis.
/// Thus, it is commonly used for 2x mode and nx mode.
//////////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::form_gen3_srio_trans(input int gen3_lane_num);

  if (~bfm_or_mon)
    rx_dh_common_mon_trans.xmting_idle[~mon_type] = 0;

  if (gen3_align_data_ins.brc3_cntl_cw_type[gen3_lane_num] == CSB && ~gen3_align_data_ins.brc3_type[gen3_lane_num] && ~cntl_symbol_open)
  begin //{

    cntl_symbol_open = 1;

    //$display($time, " 1. form_2x_srio_trans cntl_symbol_bytes is %0d", cntl_symbol_bytes);

    srio_trans_cs_ins = new();
    srio_trans_cs_ins.transaction_kind = SRIO_CS;

    srio_trans_cs_ins.cstype = CS64;

    srio_trans_cs_ins.stype0 = gen3_align_data_ins.brc3_cw[gen3_lane_num][0:3];
    srio_trans_cs_ins.param0 = gen3_align_data_ins.brc3_cw[gen3_lane_num][4:15];
    srio_trans_cs_ins.param1 = gen3_align_data_ins.brc3_cw[gen3_lane_num][16:27];
    srio_trans_cs_ins.brc3_stype1_msb = gen3_align_data_ins.brc3_cw[gen3_lane_num][28:29];

    if (srio_trans_cs_ins.stype0 == 4'b0011 && ~bfm_or_mon)
    begin //{

      timestamp_seq_num = srio_trans_cs_ins.param0[3:4];
      timestamp_cs_cnt++;

      if (timestamp_cs_cnt == 1 && timestamp_seq_num != 2'b00)
      begin //{
    	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : TIMESTAMP_SEQ_NUM_0_CHECK", $sformatf(" Spec reference 6.5.3.5. Incorrect sequence number in the first control symbol of timestamp sequence."))
      end //}
      else if (timestamp_cs_cnt == 2 && timestamp_seq_num != 2'b01)
      begin //{
    	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : TIMESTAMP_SEQ_NUM_1_CHECK", $sformatf(" Spec reference 6.5.3.5. Incorrect sequence number in the second control symbol of timestamp sequence."))
      end //}
      else if (timestamp_cs_cnt == 3 && timestamp_seq_num != 2'b10)
      begin //{
    	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : TIMESTAMP_SEQ_NUM_2_CHECK", $sformatf(" Spec reference 6.5.3.5. Incorrect sequence number in the third control symbol of timestamp sequence."))
      end //}
      else if (timestamp_cs_cnt == 4 && timestamp_seq_num != 2'b11)
      begin //{
    	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : TIMESTAMP_SEQ_NUM_3_CHECK", $sformatf(" Spec reference 6.5.3.5. Incorrect sequence number in the fourth control symbol of timestamp sequence."))
      end //}

      if (~bfm_or_mon && timestamp_cs_cnt == 1 && timestamp_seq_num == 2'b00)
      begin //{
        rx_dh_common_mon_trans.timestamp_seq_started[mon_type] = 1;
      end //}
      else if (~bfm_or_mon && timestamp_cs_cnt == 4 && timestamp_seq_num == 2'b11)
      begin //{
	-> rx_dh_trans.rcvd_uninterrupted_timestamp_cs;
        rx_dh_common_mon_trans.timestamp_seq_completed[mon_type] = 1;
        timestamp_cs_cnt = 0;
      end //}

    end //}
    else if (srio_trans_cs_ins.stype0 != 4'b0011 && ~bfm_or_mon)
    begin //{

      if (rx_dh_common_mon_trans.timestamp_seq_started[mon_type] && ~rx_dh_common_mon_trans.timestamp_seq_completed[mon_type])
      begin //{

	  -> rx_dh_trans.rcvd_interrupted_timestamp_cs;

    	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : INCOMPLETE_TIMESTAMP_SEQ_CHECK", $sformatf(" Spec reference 6.5.3.5. Timestamp sequence shall not be truncated by any other control symbols. No. of timestamp control symbols received when it is truncated is %0d.", timestamp_cs_cnt))
        rx_dh_common_mon_trans.timestamp_seq_started[mon_type] = 0;
        rx_dh_common_mon_trans.timestamp_seq_completed[mon_type] = 1;
        timestamp_cs_cnt = 0;

      end //}

    end //}

    if ((srio_trans_cs_ins.brc3_stype1_msb == 2'b10 || srio_trans_cs_ins.brc3_stype1_msb == 2'b11) && packet_open)
    begin //{

      if (srio_trans_cs_ins.brc3_stype1_msb == 2'b10)
      begin //{
 	// SOP unpadded. Hence, the data field of CSB is the link level CRC32.
        link_crc32 = gen3_align_data_ins.brc3_cw[gen3_lane_num][32:63];
	gen3_pkt_unpadded_delimiter_check();
      end //}
      else
      begin //{
 	// SOP padded. Hence, the last 4 bytes of bytestream would be the CRC32. Data bytes in CSB would be the pad bytes.
	link_crc32 = {rx_dh_trans.bytestream[packet_bytes-4], rx_dh_trans.bytestream[packet_bytes-3], rx_dh_trans.bytestream[packet_bytes-2], rx_dh_trans.bytestream[packet_bytes-1]};
	packet_bytes = packet_bytes - 4;
	gen3_pkt_padded_delimiter_check();
      end //}

      srio_trans_pkt_ins.bytestream = new[packet_bytes] (rx_dh_trans.bytestream);

      link_crc32_check();

      packet_open = 0;
      packet_bytes = 0;

      //$cast(cloned_srio_trans_pkt_ins, srio_trans_pkt_ins.clone());
      cloned_srio_trans_pkt_ins = new srio_trans_pkt_ins;
      rx_dh_trans.pl_rx_srio_trans_q.push_back(cloned_srio_trans_pkt_ins);

      if (~bfm_or_mon)
      begin //{
        rx_dh_common_mon_trans.packet_rx_in_progress[mon_type] = 0;
      end //}

    end //}
    else if ((srio_trans_cs_ins.brc3_stype1_msb == 2'b10 || srio_trans_cs_ins.brc3_stype1_msb == 2'b11) && ~packet_open)
    begin //{

      packet_open = 1;

      if (srio_trans_cs_ins.brc3_stype1_msb == 2'b11)
      begin //{
        `uvm_error("SRIO_PL_RX_DATA_HANDLER : GEN3_NEW_PKT_WITH_SOP_PADDED_CHECK", $sformatf(" Spec reference 3.5.1 No packet is in progress, but SOP-PADDED control symbol received."))
      end //}

    end //}
    else if (srio_trans_cs_ins.brc3_stype1_msb == 2'b00 && packet_open)
    begin //{

      // Temporarily assigning link_crc32 here, because if EOP-unpadded is detected in the next codeword,
      // then proper link_crc32 is the one assigned below. Else, correct link_crc32 will override the
      // below assigned value when SOP/EOP is received.
      link_crc32 = gen3_align_data_ins.brc3_cw[gen3_lane_num][32:63];

      // It could be a NOP control symbol. In that case, the temp_gen3_pkt_data assigned below would be
      // the packet bytes. Based on the next control codeword, the temp_gen3_pkt_data might be assigned
      // to the rx_dh_trans.bytestream array.
     temp_gen3_pkt_data = gen3_align_data_ins.brc3_cw[gen3_lane_num][32:63];

    end //}

    prev_cntl_cw_type = gen3_align_data_ins.brc3_cntl_cw_type[gen3_lane_num];

  end //}
  else if (cntl_symbol_open)
  begin //{

    if ((gen3_align_data_ins.brc3_cntl_cw_type[gen3_lane_num] == CSE || gen3_align_data_ins.brc3_cntl_cw_type[gen3_lane_num] == CSEB) && ~gen3_align_data_ins.brc3_type[gen3_lane_num])
    begin //{

      cntl_symbol_open = 0;
      gen3_cs_completed_in_same_column = 1;

      if (srio_trans_cs_ins.brc3_stype1_msb == 2'b10 || srio_trans_cs_ins.brc3_stype1_msb == 2'b11)
      begin //{

        packet_open = 1;

    	srio_trans_pkt_ins = new();
    	srio_trans_pkt_ins.transaction_kind = SRIO_PACKET;
    	rx_dh_trans.bytestream = new[rx_dh_config.gen3_max_pkt_size]; // max packet size is 288 including link level CRC32 and padding

    	srio_trans_pkt_ins.gen3_ackid_msb = gen3_align_data_ins.brc3_cw[gen3_lane_num][0:5];

      end //}

      srio_trans_cs_ins.stype1 = gen3_align_data_ins.brc3_cw[gen3_lane_num][0:2];
      srio_trans_cs_ins.cmd = gen3_align_data_ins.brc3_cw[gen3_lane_num][3:5];

      srio_trans_cs_ins.cs_crc24 = gen3_align_data_ins.brc3_cw[gen3_lane_num][6:29];

      if (srio_trans_cs_ins.brc3_stype1_msb == 2'b00 && brc12_stype1_type'(srio_trans_cs_ins.stype1) == EOP && packet_open)
      begin //{

	// Packet cancellation is taken care here. Packet is pushed into the pl_rx_srio_trans_q only if SOP or EOP is received.
        if(prev_cntl_cw_type==CSEB)
         packet_bytes=packet_bytes-4;
        if (srio_trans_cs_ins.cmd == 3'b000)
        begin //{
          // EOP unpadded. Hence, the data field of CSB is the link level CRC32.
          link_crc32 = link_crc32;
	  gen3_pkt_unpadded_delimiter_check();
        end //}
        else if (srio_trans_cs_ins.cmd == 3'b001)
        begin //{
          // EOP padded. Hence, the last 4 bytes of bytestream would be the CRC32. Data bytes in CSB would be the pad bytes.
          link_crc32 = {rx_dh_trans.bytestream[packet_bytes-4], rx_dh_trans.bytestream[packet_bytes-3], rx_dh_trans.bytestream[packet_bytes-2], rx_dh_trans.bytestream[packet_bytes-1]};
          packet_bytes = packet_bytes - 4;
	  gen3_pkt_padded_delimiter_check();
        end //}

        srio_trans_pkt_ins.bytestream = new[packet_bytes] (rx_dh_trans.bytestream);

        link_crc32_check();

        packet_open = 0;
        packet_bytes = 0;

        //$cast(cloned_srio_trans_pkt_ins, srio_trans_pkt_ins.clone());
        cloned_srio_trans_pkt_ins = new srio_trans_pkt_ins;
        rx_dh_trans.pl_rx_srio_trans_q.push_back(cloned_srio_trans_pkt_ins);

        if (~bfm_or_mon)
        begin //{
          rx_dh_common_mon_trans.packet_rx_in_progress[mon_type] = 0;
        end //}

      end //}
      else if (srio_trans_cs_ins.brc3_stype1_msb == 2'b00 && (brc12_stype1_type'(srio_trans_cs_ins.stype1) == STOMP || brc12_stype1_type'(srio_trans_cs_ins.stype1) == LINK_REQ || brc12_stype1_type'(srio_trans_cs_ins.stype1) == RFR) && packet_open)
      begin //{

	// Clear the packet related variables when packet is cancelled.

        packet_open = 0;
        packet_bytes = 0;

        if (~bfm_or_mon)
        begin //{
          rx_dh_common_mon_trans.packet_rx_in_progress[mon_type] = 0;
          if((brc12_stype1_type'(srio_trans_cs_ins.stype1) == STOMP) &&~rx_dh_common_mon_trans.outstanding_rfr[mon_type]  && ~rx_dh_common_mon_trans.oes_state_detected[~mon_type] && ~rx_dh_trans.ies_state)
          begin//{
           rx_dh_common_mon_trans.outstanding_retry[mon_type]=1;
           rx_dh_common_mon_trans.outstanding_rfr[mon_type]=1;
          end//}
        end //}

	if (brc12_stype1_type'(srio_trans_cs_ins.stype1) == LINK_REQ && ~descr_seed_os_detected && ~descr_seed_os_detected_within_pkt && ~bfm_or_mon)
	begin //{

    	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : GEN3_LINK_REQ_AFTER_DESCR_SEED_OS_CHECK", $sformatf(" Spec reference 5.8.1. Link request is not preceded by descrambler sync sequence."))

	end //}
	else if (brc12_stype1_type'(srio_trans_cs_ins.stype1) == LINK_REQ && (descr_seed_os_detected || descr_seed_os_detected_within_pkt) && ~bfm_or_mon)
	begin //{
	  if (descr_seed_os_detected_within_pkt)
	    descr_seed_os_detected_within_pkt = 0;
	  -> rx_dh_trans.rcvd_seedos_linkreq;
	end //}

      end //}
      else if (srio_trans_cs_ins.brc3_stype1_msb == 2'b00 && brc12_stype1_type'(srio_trans_cs_ins.stype1) == NOP && packet_open && prev_cntl_cw_type != CSEB)
      begin //{

	// Embedded control symbol condition.

    	packet_bytes = packet_bytes+4;

      	rx_dh_trans.bytestream[packet_bytes-4] = temp_gen3_pkt_data[31:24];
      	rx_dh_trans.bytestream[packet_bytes-3] = temp_gen3_pkt_data[23:16];
      	rx_dh_trans.bytestream[packet_bytes-2] = temp_gen3_pkt_data[15:8];
      	rx_dh_trans.bytestream[packet_bytes-1] = temp_gen3_pkt_data[7:0];

      end //}
      else if (srio_trans_cs_ins.brc3_stype1_msb == 2'b00 && brc12_stype1_type'(srio_trans_cs_ins.stype1) == EOP && ~packet_open && ~bfm_or_mon)
      begin //{
	if (srio_trans_cs_ins.cmd == 3'b000)
    	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : GEN3_EOP_UNPADDED_WITHOUT_SOP", $sformatf(" Spec reference 3.5.3. EOP-UNPADDED control symbol received when no packet is in progress."))
	else if (srio_trans_cs_ins.cmd == 3'b001)
    	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : GEN3_EOP_PADDED_WITHOUT_SOP", $sformatf(" Spec reference 3.5.3. EOP-PADDED control symbol received when no packet is in progress."))
      end //}
      else if (srio_trans_cs_ins.brc3_stype1_msb == 2'b00 && (brc12_stype1_type'(srio_trans_cs_ins.stype1) == STOMP || brc12_stype1_type'(srio_trans_cs_ins.stype1) == LINK_REQ) && ~packet_open && ~bfm_or_mon)
      begin //{

	// Clear the packet related variables when packet is cancelled.

	if (brc12_stype1_type'(srio_trans_cs_ins.stype1) == LINK_REQ && ~descr_seed_os_detected && ~descr_seed_os_detected_within_pkt)
	begin //{

    	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : GEN3_LINK_REQ_AFTER_DESCR_SEED_OS_CHECK", $sformatf(" Spec reference 5.8.1. Link request is not preceded by descrambler sync sequence."))

	end //}
	else if (brc12_stype1_type'(srio_trans_cs_ins.stype1) == LINK_REQ && (descr_seed_os_detected || descr_seed_os_detected_within_pkt))
	begin //{
	  if (descr_seed_os_detected_within_pkt)
	    descr_seed_os_detected_within_pkt = 0;
	  -> rx_dh_trans.rcvd_seedos_linkreq;
	end //}
	else if (brc12_stype1_type'(srio_trans_cs_ins.stype1) == STOMP)
	begin //{

    	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : GEN3_STOMP_WITHOUT_PACKET", $sformatf(" Spec reference 3.5.2. STOMP control symbol received when no packet is in progress."))
      	    if (~rx_dh_trans.ies_state && rx_dh_trans.link_initialized)
      	    begin //{
      	      rx_dh_trans.ies_state = 1;
      	      rx_dh_trans.ies_cause_value = 5;
      	      //$display($time, " 21_1. Vaidhy : ies_state set here");
      	    end //}

	end //}

      end //}

      cloned_srio_trans_cs_ins = new srio_trans_cs_ins;
      rx_dh_trans.pl_rx_srio_trans_q.push_back(cloned_srio_trans_cs_ins);

      if (gen3_align_data_ins.brc3_cntl_cw_type[gen3_lane_num] == CSE && (/*srio_trans_cs_ins.brc3_stype1_msb == 2'b10 || srio_trans_cs_ins.brc3_stype1_msb == 2'b11*/ packet_open))
      begin //{
	
    	packet_bytes = packet_bytes+4;

      	rx_dh_trans.bytestream[packet_bytes-4] = gen3_align_data_ins.brc3_cw[gen3_lane_num][32:39];
      	rx_dh_trans.bytestream[packet_bytes-3] = gen3_align_data_ins.brc3_cw[gen3_lane_num][40:47];
      	rx_dh_trans.bytestream[packet_bytes-2] = gen3_align_data_ins.brc3_cw[gen3_lane_num][48:55];
      	rx_dh_trans.bytestream[packet_bytes-1] = gen3_align_data_ins.brc3_cw[gen3_lane_num][56:63];

      	if (bfm_or_mon)
	begin //{
      	  rx_dh_env_config.current_ack_id = {srio_trans_pkt_ins.gen3_ackid_msb, gen3_align_data_ins.brc3_cw[gen3_lane_num][32:37]};
      	  ->rx_dh_env_config.packet_rx_started;
	end //}
	else if (~bfm_or_mon)
	begin //{
	  rx_dh_common_mon_trans.packet_rx_in_progress[mon_type] = 1;
	  rx_dh_common_mon_trans.pkt_in_progress_ack_id[mon_type] = {srio_trans_pkt_ins.gen3_ackid_msb, gen3_align_data_ins.brc3_cw[gen3_lane_num][32:37]};
	end //}


      end //}
      else if (gen3_align_data_ins.brc3_cntl_cw_type[gen3_lane_num] == CSEB)
      begin //{

        cntl_symbol_open = 1;

        //$display($time, " 1. form_2x_srio_trans cntl_symbol_bytes is %0d", cntl_symbol_bytes);

        srio_trans_cs_ins = new();
        srio_trans_cs_ins.transaction_kind = SRIO_CS;

        srio_trans_cs_ins.cstype = CS64;

        srio_trans_cs_ins.stype0 = gen3_align_data_ins.brc3_cw[gen3_lane_num][32:35];
        srio_trans_cs_ins.param0 = gen3_align_data_ins.brc3_cw[gen3_lane_num][36:47];
        srio_trans_cs_ins.param1 = gen3_align_data_ins.brc3_cw[gen3_lane_num][48:59];
        srio_trans_cs_ins.brc3_stype1_msb = gen3_align_data_ins.brc3_cw[gen3_lane_num][60:61];

    	if (srio_trans_cs_ins.stype0 == 4'b0011 && ~bfm_or_mon)
    	begin //{

    	  timestamp_seq_num = srio_trans_cs_ins.param0[3:4];
    	  timestamp_cs_cnt++;

    	  if (timestamp_cs_cnt == 1 && timestamp_seq_num != 2'b00)
    	  begin //{
    		  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : TIMESTAMP_SEQ_NUM_0_CHECK", $sformatf(" Spec reference 6.5.3.5. Incorrect sequence number in the first control symbol of timestamp sequence."))
    	  end //}
    	  else if (timestamp_cs_cnt == 2 && timestamp_seq_num != 2'b01)
    	  begin //{
    		  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : TIMESTAMP_SEQ_NUM_1_CHECK", $sformatf(" Spec reference 6.5.3.5. Incorrect sequence number in the second control symbol of timestamp sequence."))
    	  end //}
    	  else if (timestamp_cs_cnt == 3 && timestamp_seq_num != 2'b10)
    	  begin //{
    		  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : TIMESTAMP_SEQ_NUM_2_CHECK", $sformatf(" Spec reference 6.5.3.5. Incorrect sequence number in the third control symbol of timestamp sequence."))
    	  end //}
    	  else if (timestamp_cs_cnt == 4 && timestamp_seq_num != 2'b11)
    	  begin //{
    		  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : TIMESTAMP_SEQ_NUM_3_CHECK", $sformatf(" Spec reference 6.5.3.5. Incorrect sequence number in the fourth control symbol of timestamp sequence."))
    	  end //}

    	  if (~bfm_or_mon && timestamp_cs_cnt == 1 && timestamp_seq_num == 2'b00)
    	  begin //{
    	    rx_dh_common_mon_trans.timestamp_seq_started[mon_type] = 1;
    	  end //}
    	  else if (~bfm_or_mon && timestamp_cs_cnt == 4 && timestamp_seq_num == 2'b11)
    	  begin //{
	    -> rx_dh_trans.rcvd_uninterrupted_timestamp_cs;
    	    rx_dh_common_mon_trans.timestamp_seq_completed[mon_type] = 1;
    	    timestamp_cs_cnt = 0;
    	  end //}

    	end //}
    	else if (srio_trans_cs_ins.stype0 != 4'b0011 && ~bfm_or_mon)
    	begin //{

    	  if (rx_dh_common_mon_trans.timestamp_seq_started[mon_type] && ~rx_dh_common_mon_trans.timestamp_seq_completed[mon_type])
    	  begin //{

	    -> rx_dh_trans.rcvd_interrupted_timestamp_cs;

    	    `uvm_error("SRIO_PL_PROTOCOL_CHECKER : INCOMPLETE_TIMESTAMP_SEQ_CHECK", $sformatf(" Spec reference 6.5.3.5. Timestamp sequence shall not be truncated by any other control symbols. No. of timestamp control symbols received when it is truncated is %0d.", timestamp_cs_cnt))
    	    rx_dh_common_mon_trans.timestamp_seq_started[mon_type] = 0;
    	    rx_dh_common_mon_trans.timestamp_seq_completed[mon_type] = 1;
    	    timestamp_cs_cnt = 0;

    	  end //}

    	end //}

        if ((srio_trans_cs_ins.brc3_stype1_msb == 2'b10 || srio_trans_cs_ins.brc3_stype1_msb == 2'b11) && packet_open)
        begin //{

          if (srio_trans_cs_ins.brc3_stype1_msb == 2'b10)
          begin //{
            // SOP unpadded. 
	    // Since this is CSEB, the data field of CSB is the link level CRC32.
            link_crc32 = link_crc32; //gen3_align_data_ins.brc3_cw[gen3_lane_num][32:63];
            packet_bytes = packet_bytes - 4;
	    gen3_pkt_unpadded_delimiter_check();
          end //}
          else
          begin //{
            // SOP padded. Hence, the last 4 bytes of bytestream would be the CRC32. Data bytes in CSB would be the pad bytes.
            packet_bytes = packet_bytes - 4;
            link_crc32 = {rx_dh_trans.bytestream[packet_bytes-4], rx_dh_trans.bytestream[packet_bytes-3], rx_dh_trans.bytestream[packet_bytes-2], rx_dh_trans.bytestream[packet_bytes-1]};
            packet_bytes = packet_bytes - 4;
	    gen3_pkt_padded_delimiter_check();
          end //}

          srio_trans_pkt_ins.bytestream = new[packet_bytes] (rx_dh_trans.bytestream);

          link_crc32_check();

          packet_open = 0;
          packet_bytes = 0;

          //$cast(cloned_srio_trans_pkt_ins, srio_trans_pkt_ins.clone());
          cloned_srio_trans_pkt_ins = new srio_trans_pkt_ins;
          rx_dh_trans.pl_rx_srio_trans_q.push_back(cloned_srio_trans_pkt_ins);

          if (~bfm_or_mon)
          begin //{
            rx_dh_common_mon_trans.packet_rx_in_progress[mon_type] = 0;
          end //}

        end //}
        else if ((srio_trans_cs_ins.brc3_stype1_msb == 2'b10 || srio_trans_cs_ins.brc3_stype1_msb == 2'b11) && ~packet_open)
        begin //{

          packet_open = 1;

          if (srio_trans_cs_ins.brc3_stype1_msb == 2'b11)
          begin //{
            `uvm_error("SRIO_PL_RX_DATA_HANDLER : GEN3_NEW_PKT_WITH_SOP_PADDED_CHECK", $sformatf(" Spec reference 3.5.1 No packet is in progress, but SOP-PADDED control symbol received."))
          end //}

        end //}
        //else if (srio_trans_cs_ins.brc3_stype1_msb == 2'b00 && packet_open) // This should not exist for CSEB since it will not contain any data fields.
        //begin //{

        //  // Temporarily assigning link_crc32 here, because if EOP-unpadded is detected in the next codeword,
        //  // then proper link_crc32 is the one assigned below. Else, correct link_crc32 will override the
        //  // below assigned value when SOP/EOP is received.
        //  link_crc32 = gen3_align_data_ins.brc3_cw[gen3_lane_num][32:63];

      	//  // It could be a NOP control symbol. In that case, the temp_gen3_pkt_data assigned below would be
      	//  // the packet bytes. Based on the next control codeword, the temp_gen3_pkt_data might be assigned
      	//  // to the rx_dh_trans.bytestream array.
     	//  temp_gen3_pkt_data = gen3_align_data_ins.brc3_cw[gen3_lane_num][32:63];

        //end //}


      end //}
	
      prev_cntl_cw_type = gen3_align_data_ins.brc3_cntl_cw_type[gen3_lane_num];

    end //}
    else if (cntl_symbol_open && (!(gen3_align_data_ins.brc3_cntl_cw_type[gen3_lane_num] == CSE || gen3_align_data_ins.brc3_cntl_cw_type[gen3_lane_num] == CSEB) || (gen3_align_data_ins.brc3_type[gen3_lane_num])))
    begin //{

      cntl_symbol_open = 0;

      if (~bfm_or_mon)
      begin //{

	if (gen3_align_data_ins.brc3_type[gen3_lane_num])
	  -> rx_dh_trans.rcvd_data_insteadof_endcw;
	else if (gen3_align_data_ins.brc3_cntl_cw_type[gen3_lane_num] == CSB)
	  -> rx_dh_trans.rcvd_startcw_in_opencontext;

        `uvm_error("SRIO_PL_RX_DATA_HANDLER : CSB_NOT_FOLLOWED_BY_CSE_OR_CSEB_CHECK", $sformatf(" Spec reference 5.7 CSB codeword should be followed by either CSE or CSEB, but received codeword is %0s.", gen3_align_data_ins.brc3_cntl_cw_type[gen3_lane_num]))

      end //}

    end //}

  end //}
  else if (packet_open && gen3_align_data_ins.brc3_type[gen3_lane_num])
  begin //{

    if (descr_seed_os_detected_within_pkt && ~bfm_or_mon)
    begin //{
      descr_seed_os_detected_within_pkt = 0;
      `uvm_error("SRIO_PL_RX_DATA_HANDLER : GEN3_ILLEGAL_DS_OS_WITHIN_PKT", $sformatf(" Spec reference 5.6/5.7 DESCR_SEED OS is received within a packet. Packet was expected to be cancelled, but Link-request doesn't follow DESCR_SEED OS. DESCR_SEED is illegal within a packet when it is not cancelled."))
    end //}

    packet_bytes = packet_bytes + 8;

    if (packet_bytes<=rx_dh_config.gen3_max_pkt_size)
    begin //{

      rx_dh_trans.bytestream[packet_bytes-8] = gen3_align_data_ins.brc3_cw[gen3_lane_num][0:7];
      rx_dh_trans.bytestream[packet_bytes-7] = gen3_align_data_ins.brc3_cw[gen3_lane_num][8:15];
      rx_dh_trans.bytestream[packet_bytes-6] = gen3_align_data_ins.brc3_cw[gen3_lane_num][16:23];
      rx_dh_trans.bytestream[packet_bytes-5] = gen3_align_data_ins.brc3_cw[gen3_lane_num][24:31];
      rx_dh_trans.bytestream[packet_bytes-4] = gen3_align_data_ins.brc3_cw[gen3_lane_num][32:39];
      rx_dh_trans.bytestream[packet_bytes-3] = gen3_align_data_ins.brc3_cw[gen3_lane_num][40:47];
      rx_dh_trans.bytestream[packet_bytes-2] = gen3_align_data_ins.brc3_cw[gen3_lane_num][48:55];
      rx_dh_trans.bytestream[packet_bytes-1] = gen3_align_data_ins.brc3_cw[gen3_lane_num][56:63];

    end //}
    else
    begin //{
      pkt_size_err();
    end //}

  end //}
  else if (~gen3_align_data_ins.brc3_type[gen3_lane_num])
  begin //{

    if (~rx_dh_trans.ies_state && rx_dh_trans.link_initialized && gen3_align_data_ins.brc3_cntl_cw_type[gen3_lane_num] != DESCR_SEED )
    begin //{
      rx_dh_trans.ies_state = 1;
      rx_dh_trans.ies_cause_value = 5;
      //$display($time, " 7. Vaidhy : gen3 ies_state set here");
    end //}

    if (~bfm_or_mon)
    begin //{

      if (gen3_align_data_ins.brc3_cntl_cw_type[gen3_lane_num] == CSE || gen3_align_data_ins.brc3_cntl_cw_type[gen3_lane_num] == CSEB)
	-> rx_dh_trans.rcvd_endcw_in_closedcontext;

      if (gen3_align_data_ins.brc3_cntl_cw_type[gen3_lane_num] == DESCR_SEED)
	descr_seed_os_detected_within_pkt = 1;
      else
      	`uvm_error("SRIO_PL_RX_DATA_HANDLER : GEN3_INVALID_CONTROL_CODEWORD_CHECK", $sformatf(" Spec reference 5.6/5.7 Invalid/Illegal control codeword is received. packet_open is %0d, cntl_symbol_open is %0d.  control codeword received is %0s", packet_open, cntl_symbol_open, gen3_align_data_ins.brc3_cntl_cw_type[gen3_lane_num].name()))

    end //}

  end //}

  if (prev_cntl_symbol_open && ~cntl_symbol_open)
  begin //{
    link_init_srio_trans_cs_ins = new srio_trans_cs_ins;
    if (srio_trans_cs_ins.cs_crc24 != link_init_srio_trans_cs_ins.calccrc24(link_init_srio_trans_cs_ins.pack_cs()))
      link_init_cntl_symbol_err = 1;
  end //}

  if (pkt_size_err_reported && ~cntl_symbol_open && ~packet_open)
    pkt_size_err_reported = 0;

endtask : form_gen3_srio_trans






//////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_trans_xmting_idle
/// Description : This method is active only for monitor instances.
/// Monitor1 will update the rx_dh_common_mon_trans.xmting_idle of monitor2, and based on that,
/// monitor2 will update its own rx_dh_trans.xmting_idle and vice-versa.
//////////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::gen_trans_xmting_idle();

  forever begin //{

    @(rx_dh_common_mon_trans.xmting_idle[mon_type]);

    rx_dh_trans.xmting_idle = rx_dh_common_mon_trans.xmting_idle[mon_type];

  end //}

endtask : gen_trans_xmting_idle




//////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen3_pkt_unpadded_delimiter_check
/// Description : This method is called when a SOP/EOP unpadded control symbol is received.
/// It checks the packet bytes and throws an error if padded delimiter is expected.
//////////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::gen3_pkt_unpadded_delimiter_check();

  if (~rx_dh_config.has_checks || bfm_or_mon)
    return;

  -> rx_dh_trans.pkt_terminating_8bit_boundary;

  if (((packet_bytes+4)%8) != 0)
  begin //{
    `uvm_error("SRIO_PL_RX_DATA_HANDLER : GEN3_PKT_UNPADDED_DELIM_CHECK", $sformatf(" Spec reference 5.6. Total packet size including link crc32 is %0d which is not an integer multiple of 8 bytes. Expecting a SOP/EOP PADDED control symbol delimiter. Received an UNPADDED control symbol delimiter.", packet_bytes+4))
  end //}

endtask : gen3_pkt_unpadded_delimiter_check





//////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen3_pkt_padded_delimiter_check
/// Description : This method is called when a SOP/EOP padded control symbol is received.
/// It checks the packet bytes and throws an error if unpadded delimiter is expected.
//////////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::gen3_pkt_padded_delimiter_check();

  if (~rx_dh_config.has_checks || bfm_or_mon)
    return;

  -> rx_dh_trans.pkt_terminating_non_8bit_boundary;

  if (((packet_bytes+4)%8) == 0)
  begin //{
    `uvm_error("SRIO_PL_RX_DATA_HANDLER : GEN3_PKT_PADDED_DELIM_CHECK", $sformatf(" Spec reference 5.6. Total packet size including link crc32 is %0d which is an integer multiple of 8 bytes. Expecting a SOP/EOP UNPADDED control symbol delimiter. Received a PADDED control symbol delimiter.", packet_bytes+4))
  end //}

endtask : gen3_pkt_padded_delimiter_check





//////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : link_crc32_check
/// Description : This method checks the link level CRC32 correctness.
//////////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::link_crc32_check();

  srio_trans_pkt_ins.calcCRC32();

  if (link_crc32 != srio_trans_pkt_ins.crc32)
  begin //{

    if (~rx_dh_trans.ies_state && rx_dh_trans.link_initialized)
    begin //{
      rx_dh_trans.ies_state = 1;
      rx_dh_trans.ies_cause_value = 4;
      //$display($time, " 8. Vaidhy : gen3 ies_state set here");
    end //}

    srio_trans_pkt_ins.crc32_err = 1;

    if (~bfm_or_mon)
    begin //{

      `uvm_error("SRIO_PL_RX_DATA_HANDLER : GEN3_LINK_CRC32_CHECK", $sformatf(" Spec reference 5.6. Incorrect LINK CRC32 detected in packet. Received crc is %0h, Expected crc is %0h", link_crc32, srio_trans_pkt_ins.crc32))

    end //}

  end //}

endtask : link_crc32_check





//////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : idle3_seq_checks
/// Description : This method performs the IDLE column check. After the column check, it triggers the 
/// idle3_check method where other idle3 related checks are performed.
//////////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::idle3_seq_checks();

  forever begin //{

    @(posedge srio_if.sim_clk);

    for (int idl_chk=0; idl_chk<rx_dh_env_config.num_of_lanes; idl_chk++)
    begin //{

      temp_idl_chk = idl_chk;

      if (idle3_seq_cw_type.exists(idl_chk) && idle3_seq_cw_type[idl_chk].size()>0)
      begin //{

	if (idl_chk == 0)
	begin //{

	  lane0_idle_valid = 1;
	  lane0_idle3_seq_cw_type = idle3_seq_cw_type[idl_chk].pop_front();
	  lane0_idle3_seq_cw = idle3_seq_cw[idl_chk].pop_front();

	  //if (~bfm_or_mon && mon_type)
	  //$display($time, " lane0_idle_char is %0h, lane0_idle_cntl is %0d", lane0_idle_char, lane0_idle_cntl);

	end //}
	else
	begin //{

	  lane_idle_valid = 1;
	  lane_idle3_seq_cw_type = idle3_seq_cw_type[idl_chk].pop_front();
	  lane_idle3_seq_cw = idle3_seq_cw[idl_chk].pop_front();

	  //if (~bfm_or_mon && mon_type)
	  //$display($time, " lane_idle_char is %0h, lane_idle_cntl is %0d", lane_idle_char, lane_idle_cntl);

	end //}

	if (lane0_idle_valid && idl_chk>0)
	begin //{

	  if (lane_idle3_seq_cw_type !== lane0_idle3_seq_cw_type)
	  begin //{
      	    if (~rx_dh_trans.ies_state && rx_dh_trans.link_initialized)
      	    begin //{
      	      rx_dh_trans.ies_state = 1;
      	      rx_dh_trans.ies_cause_value = 31;
      	       //$display($time, " 1. Vaidhy : ies_state set here");
      	    end //}

	    if (~bfm_or_mon)
	    begin //{

	      if (rx_dh_common_mon_trans.port_initialized[0] && rx_dh_common_mon_trans.port_initialized[1])
	      begin //{

	        `uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE3_SEQUENCE_COLUMN_CHECK", $sformatf(" Spec reference 5.9.1 IDLE3 sequence is not identical on all lanes. Lane 0 control codeword is %0s, Lane %0d control codeword is %0s", lane0_idle3_seq_cw_type.name(), idl_chk, lane_idle3_seq_cw_type.name()))

		-> rx_dh_trans.rcvd_idle3_with_diffcw_err;

	      end //}

	    end //}

	  end //}
	  else if (lane_idle3_seq_cw_type == STATUS_CNTL && ~bfm_or_mon)
	  begin //{

	    check_port_scope_fields_in_stat_cntl_cw();

	  end //}

	end //}

	//if (rx_dh_trans.idle_selected && ~bfm_or_mon)
	//  idle2_cs_marker_dxy_check();

      end //}

    end //}

    if (lane0_idle_valid || lane_idle_valid)
    begin //{
      if (~lane_idle_valid)
      begin //{
	lane_idle3_seq_cw_type = lane0_idle3_seq_cw_type;
	lane_idle3_seq_cw = lane0_idle3_seq_cw;
      end //}
      lane0_idle_valid = 0;
      lane_idle_valid = 0;
    end //}
    else
    begin //{
	//if (~bfm_or_mon && mon_type)
	//  $display($time, " lane_idle_valid and lane0_idle_valid are zero.");
      continue;
    end //}

    // idle3_check triggered only after port initialization because, before port
    // initialization, there may not be proper alignment and hence, same
    // column's idle codewords could be processed at different times by the
    // below method which might trigger false errors. Since, ordered sequence
    // spacing and IDLE3 truncation are checked in this component, it is fine
    // to check it after port initialization. However, ordered sequence
    // structure are checked in lane handler component from the beginning
    // itself. Thus, errors in ordereed sequence will not be missed.
    if (rx_dh_trans.port_initialized)
      idle3_check();

  end //}

endtask : idle3_seq_checks




//////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : idle3_check
/// Description : This method performs IDLE3 related sequence checks which are listed in micro-architecture
/// document under section "PL Monitor Checks" and sub-section "GNE3.0 SPECIFIC CHECKS"
//////////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::idle3_check();

  if (~idle_check_in_progress)
  begin //{

    idle3_cw_cnt_bet_descr_seed_os = 0;
    idle3_cw_cnt_bet_stat_cntl_os = 0;
    idle3_chk_cntl_cw_cnt = 0;
    first_stat_cntl_os_rcvd = 0;

    skip_os_in_progress = 0;
    descr_seed_os_in_progress = 0;
    descr_seed_os_detected = 0;
    status_cntl_os_in_progress = 0;

    if (lane_idle3_seq_cw_type == SKIP_MARKER || lane_idle3_seq_cw_type == DESCR_SEED || lane_idle3_seq_cw_type == STATUS_CNTL)
    begin //{

      idle_check_in_progress = 1; // Beginning of an ordered sequence
      idle3_chk_cntl_cw_cnt = 1;

      if (lane_idle3_seq_cw_type == SKIP_MARKER)
        skip_os_in_progress = 1;
      else if (lane_idle3_seq_cw_type == DESCR_SEED)
      begin //{
        descr_seed_os_in_progress = 1;
        descr_seed_os_detected = 1;
      end //}
      else if (lane_idle3_seq_cw_type == STATUS_CNTL)
        status_cntl_os_in_progress = 1;

    end //}

  end //}
  else
  begin //{

    if (lane_idle3_seq_cw_type != SKIP_MARKER && lane_idle3_seq_cw_type != SKIP && lane_idle3_seq_cw_type != DESCR_SEED && lane_idle3_seq_cw_type != LANE_CHECK && lane_idle3_seq_cw_type != STATUS_CNTL && (lane_idle3_seq_cw_type != DATA || (lane_idle3_seq_cw_type == DATA && lane_idle3_seq_cw != SRIO_IDLE3_D00)))
    begin //{

      if (~rx_dh_trans.ies_state && rx_dh_trans.link_initialized)
      begin //{
        rx_dh_trans.ies_state = 1;
        rx_dh_trans.ies_cause_value = 5;
         //$display($time, " 1. Vaidhy : ies_state set here");
      end //}

      if (~bfm_or_mon)
      begin //{

        -> rx_dh_trans.rcvd_idle3_with_invalid_cw;

        `uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE3_SEQUENCE_INVALID_CW_CHECK", $sformatf(" Spec reference 5.9. Invalid / Illegal codeword encountered inbetween IDLE sequence3. brc3_cw_type is %0s brc3_cw is %0h", lane_idle3_seq_cw_type.name(), lane_idle3_seq_cw))

      end //}

    end //}

    if (lane_idle3_seq_cw_type == SKIP_MARKER && ~skip_os_in_progress)
      skip_os_in_progress = 1;
    else if (lane_idle3_seq_cw_type == DESCR_SEED && ~descr_seed_os_in_progress)
    begin //{
      descr_seed_os_in_progress = 1;
      descr_seed_os_detected = 1;
    end //}
    else if (lane_idle3_seq_cw_type == STATUS_CNTL && ~status_cntl_os_in_progress)
      status_cntl_os_in_progress = 1;

    // Ordered sequence structure are checked inlane handler component itself.
    // Hence, just keeping track of the no. of characters here to set and
    // clear the respective os_in_progress variables.
    if (skip_os_in_progress && descr_seed_os_in_progress && idle3_chk_cntl_cw_cnt == 1)
    begin //{
      skip_os_in_progress = 0;
    end //}
    else if (skip_os_in_progress && idle3_chk_cntl_cw_cnt < 6)
    begin //{
      idle3_chk_cntl_cw_cnt++;
      if (descr_seed_os_in_progress)
      begin //{
        idle3_chk_cntl_cw_cnt = 0;
      end //}
    end //}

    if (descr_seed_os_in_progress && idle3_chk_cntl_cw_cnt > 0)
    begin //{
      descr_seed_os_in_progress = 0;
      idle3_chk_cntl_cw_cnt=0;
    end //}
    else if (descr_seed_os_in_progress && idle3_chk_cntl_cw_cnt == 0)
    begin //{
      idle3_chk_cntl_cw_cnt++;
      idle3_cw_cnt_bet_descr_seed_os = 0;
    end //}
    else if (~descr_seed_os_in_progress)
    begin //{

      idle3_cw_cnt_bet_descr_seed_os++;
      descr_seed_os_detected = 0;

      if (idle3_cw_cnt_bet_descr_seed_os > rx_dh_config.seed_ord_seq_rate && ~bfm_or_mon)
      begin //{

    	`uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE3_SEQUENCE_DS_OS_SPACING_CHECK", $sformatf(" Spec reference 5.9.1. A seed ordered sequence has to be transmitted atleast once every 49 codewords transmitted per lane. Number codewords received without a seed ordered sequence in the receiving IDLE3 sequence is %0d", idle3_cw_cnt_bet_descr_seed_os))

        idle3_cw_cnt_bet_descr_seed_os=0;

      end //}

    end //}

    if (status_cntl_os_in_progress && idle3_chk_cntl_cw_cnt > 0)
    begin //{
      status_cntl_os_in_progress = 0;
      idle3_chk_cntl_cw_cnt=0;
      if (~first_stat_cntl_os_rcvd)
	first_stat_cntl_os_rcvd = 1;
    end //}
    else if (status_cntl_os_in_progress && idle3_chk_cntl_cw_cnt == 0)
    begin //{

      if (idle3_cw_cnt_bet_stat_cntl_os < rx_dh_config.status_cntl_ord_seq_rate_min && first_stat_cntl_os_rcvd && ~bfm_or_mon)
      begin //{

    	`uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE3_SEQUENCE_SC_OS_MIN_SPACING_CHECK", $sformatf(" Spec reference 5.9.1. Minimum 18 codewords has to be transmitted inbetween 2 status control codewords transmitted per lane. Number codewords received inbetween 2 status control ordered sequence in the receiving IDLE3 sequence is %0d", idle3_cw_cnt_bet_stat_cntl_os))

        idle3_cw_cnt_bet_stat_cntl_os = 0;

      end //}

      idle3_chk_cntl_cw_cnt++;
      idle3_cw_cnt_bet_stat_cntl_os = 0;

    end //}
    else if (~status_cntl_os_in_progress)
    begin //{

      idle3_cw_cnt_bet_stat_cntl_os++;

      if (idle3_cw_cnt_bet_stat_cntl_os > rx_dh_config.status_cntl_ord_seq_rate_max && ~bfm_or_mon)
      begin //{

    	`uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE3_SEQUENCE_SC_OS_MAX_SPACING_CHECK", $sformatf(" Spec reference 5.9.1. A Status control ordered sequence has to be transmitted atleast once every 49 codewords transmitted per lane. Number codewords received without a status control ordered sequence in the receiving IDLE3 sequence is %0d", idle3_cw_cnt_bet_stat_cntl_os))

        idle3_cw_cnt_bet_stat_cntl_os = 0;

      end //}

    end //}

  end //}

endtask : idle3_check




///////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : idle3_truncation_check
/// Description : This method checks if none of the ordered sequence is truncated by control symbols / packet.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::idle3_truncation_check();

  if (~rx_dh_config.idle_seq_check_en || ~rx_dh_config.has_checks)
    return;

  idle_check_in_progress = 0;

  if ((skip_os_in_progress || descr_seed_os_in_progress || status_cntl_os_in_progress) && (~bfm_or_mon))
  begin //{

    `uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE3_SEQUENCE_OS_TRUNCATION_CHECK", $sformatf(" Spec reference 5.9.1. An ordered sequence shall not be truncated. skip_os_in_progress is %0d, descr_seed_os_in_progress is %0d, status_cntl_os_in_progress is %0d", skip_os_in_progress, descr_seed_os_in_progress, status_cntl_os_in_progress))

  end //}

  skip_os_in_progress = 0;
  descr_seed_os_in_progress = 0;
  status_cntl_os_in_progress = 0;

endtask : idle3_truncation_check





///////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : check_port_scope_fields_in_stat_cntl_cw
/// Description : This method checks if all the port scope fields of the received status-control codeword is
/// same on all the active lanes.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::check_port_scope_fields_in_stat_cntl_cw();

  if (lane0_idle3_seq_cw[0:7] != lane_idle3_seq_cw[0:7])
  begin //{
    `uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE3_SEQUENCE_SC_CW_COLUMN_CHECK_1", $sformatf(" Spec reference 5.5.3.5 / Table 5-3. Port number field is not same on all lanes in the received STATUS / CONTROL control codeword. Port number field on lane 0 is %0h, Port number field on lane %0d is %0h", lane0_idle3_seq_cw[0:7], temp_idl_chk, lane_idle3_seq_cw[0:7]))
  end //}

  if (lane0_idle3_seq_cw[12] != lane_idle3_seq_cw[12])
  begin //{
    `uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE3_SEQUENCE_SC_CW_COLUMN_CHECK_2", $sformatf(" Spec reference 5.5.3.5 / Table 5-3. Remote training support field is not same on all lanes in the received STATUS / CONTROL control codeword. Remote training support field on lane 0 is %0h, Remote training support field on lane %0d is %0h", lane0_idle3_seq_cw[12], temp_idl_chk, lane_idle3_seq_cw[12]))
  end //}

  if (lane0_idle3_seq_cw[13] != lane_idle3_seq_cw[13])
  begin //{
    `uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE3_SEQUENCE_SC_CW_COLUMN_CHECK_3", $sformatf(" Spec reference 5.5.3.5 / Table 5-3. Retraining enabled field is not same on all lanes in the received STATUS / CONTROL control codeword. Retraining enabled field on lane 0 is %0h, Retraining enabled field on lane %0d is %0h", lane0_idle3_seq_cw[13], temp_idl_chk, lane_idle3_seq_cw[13]))
  end //}

  if (lane0_idle3_seq_cw[14] != lane_idle3_seq_cw[14])
  begin //{
    `uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE3_SEQUENCE_SC_CW_COLUMN_CHECK_4", $sformatf(" Spec reference 5.5.3.5 / Table 5-3. Asymmetric mode enabled field is not same on all lanes in the received STATUS / CONTROL control codeword. Asymmetric mode enabled field on lane 0 is %0h, Asymmetric mode enabled field on lane %0d is %0h", lane0_idle3_seq_cw[14], temp_idl_chk, lane_idle3_seq_cw[14]))
  end //}

  if (lane0_idle3_seq_cw[15] != lane_idle3_seq_cw[15])
  begin //{
    `uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE3_SEQUENCE_SC_CW_COLUMN_CHECK_5", $sformatf(" Spec reference 5.5.3.5 / Table 5-3. Port initialized field is not same on all lanes in the received STATUS / CONTROL control codeword. Port initialized field on lane 0 is %0h, Port initialized field on lane %0d is %0h", lane0_idle3_seq_cw[15], temp_idl_chk, lane_idle3_seq_cw[15]))
  end //}

  if (lane0_idle3_seq_cw[16] != lane_idle3_seq_cw[16])
  begin //{
    `uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE3_SEQUENCE_SC_CW_COLUMN_CHECK_6", $sformatf(" Spec reference 5.5.3.5 / Table 5-3. Transmit 1x mode field is not same on all lanes in the received STATUS / CONTROL control codeword. Transmit 1x mode field on lane 0 is %0h, Transmit 1x mode field on lane %0d is %0h", lane0_idle3_seq_cw[16], temp_idl_chk, lane_idle3_seq_cw[16]))
  end //}

  if (lane0_idle3_seq_cw[17:19] != lane_idle3_seq_cw[17:19])
  begin //{
    `uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE3_SEQUENCE_SC_CW_COLUMN_CHECK_7", $sformatf(" Spec reference 5.5.3.5 / Table 5-3. Receive width field is not same on all lanes in the received STATUS / CONTROL control codeword. Receive width field on lane 0 is %0h, Receive width field on lane %0d is %0h", lane0_idle3_seq_cw[17:19], temp_idl_chk, lane_idle3_seq_cw[17:19]))
  end //}

  if (lane0_idle3_seq_cw[51] != lane_idle3_seq_cw[51])
  begin //{
    `uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE3_SEQUENCE_SC_CW_COLUMN_CHECK_8", $sformatf(" Spec reference 5.5.3.5 / Table 5-3. Retrain grant field is not same on all lanes in the received STATUS / CONTROL control codeword. Retrain grant field on lane 0 is %0h, Retrain grant field on lane %0d is %0h", lane0_idle3_seq_cw[51], temp_idl_chk, lane_idle3_seq_cw[51]))
  end //}

  if (lane0_idle3_seq_cw[52] != lane_idle3_seq_cw[52])
  begin //{
    `uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE3_SEQUENCE_SC_CW_COLUMN_CHECK_9", $sformatf(" Spec reference 5.5.3.5 / Table 5-3. Retrain ready field is not same on all lanes in the received STATUS / CONTROL control codeword. Retrain ready field on lane 0 is %0h, Retrain ready field on lane %0d is %0h", lane0_idle3_seq_cw[52], temp_idl_chk, lane_idle3_seq_cw[52]))
  end //}

  if (lane0_idle3_seq_cw[53] != lane_idle3_seq_cw[53])
  begin //{
    `uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE3_SEQUENCE_SC_CW_COLUMN_CHECK_10", $sformatf(" Spec reference 5.5.3.5 / Table 5-3. Retraining field is not same on all lanes in the received STATUS / CONTROL control codeword. Retraining field on lane 0 is %0h, Retraining field on lane %0d is %0h", lane0_idle3_seq_cw[53], temp_idl_chk, lane_idle3_seq_cw[53]))
  end //}

  if (lane0_idle3_seq_cw[54] != lane_idle3_seq_cw[54])
  begin //{
    `uvm_error("SRIO_PL_RX_DATA_HANDLER : IDLE3_SEQUENCE_SC_CW_COLUMN_CHECK_11", $sformatf(" Spec reference 5.5.3.5 / Table 5-3. Port entering silence field is not same on all lanes in the received STATUS / CONTROL control codeword. Port entering silence field on lane 0 is %0h, Port entering silence field on lane %0d is %0h", lane0_idle3_seq_cw[54], temp_idl_chk, lane_idle3_seq_cw[54]))
  end //}

endtask : check_port_scope_fields_in_stat_cntl_cw





//////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen3_status_cntl_cw_decode
/// Description : This method decodes the STATUS_CNTL codeword based on nx_align_data_valid / 
/// x2_align_data_valid / x1_lane_data_valid and assigns the from_sc_* variables in the common
/// component transaction.
//////////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::gen3_status_cntl_cw_decode();

  int temp_sts_cntl_cw_dec_lane;

  forever begin //{

    @(negedge srio_if.sim_clk);

    if (rx_dh_trans.nx_align_data_valid || rx_dh_trans.x2_align_data_valid || (x1_lane_data_valid && active_lane_for_idle == 0))
    begin //{
      temp_sts_cntl_cw_dec_lane = 0;
    end //}
    else if (x1_lane_data_valid)
    begin //{
      temp_sts_cntl_cw_dec_lane = active_lane_for_idle;
    end //}
    else if (~rx_dh_trans.nx_align_data_valid && ~rx_dh_trans.x2_align_data_valid && ~x1_lane_data_valid)
    begin //{
      continue;
    end //}

    if (!gen3_align_data_ins.brc3_cntl_cw_type.exists(temp_sts_cntl_cw_dec_lane))
      continue;

    if (gen3_align_data_ins.brc3_cntl_cw_type[temp_sts_cntl_cw_dec_lane] == STATUS_CNTL)
    begin //{

      rx_dh_trans.from_sc_retrain_en	= gen3_align_data_ins.brc3_cw[temp_sts_cntl_cw_dec_lane][13];
      rx_dh_trans.from_sc_asym_mode_en	= gen3_align_data_ins.brc3_cw[temp_sts_cntl_cw_dec_lane][14];
      rx_dh_trans.from_sc_initialized	= gen3_align_data_ins.brc3_cw[temp_sts_cntl_cw_dec_lane][15];
      rx_dh_trans.from_sc_xmt_1x_mode	= gen3_align_data_ins.brc3_cw[temp_sts_cntl_cw_dec_lane][16];
      rx_dh_trans.from_sc_retrain_grnt	= gen3_align_data_ins.brc3_cw[temp_sts_cntl_cw_dec_lane][51];
      rx_dh_trans.from_sc_retrain_ready	= gen3_align_data_ins.brc3_cw[temp_sts_cntl_cw_dec_lane][52];
      rx_dh_trans.from_sc_retraining	= gen3_align_data_ins.brc3_cw[temp_sts_cntl_cw_dec_lane][53];
      rx_dh_trans.from_sc_port_silence	= gen3_align_data_ins.brc3_cw[temp_sts_cntl_cw_dec_lane][54];

      rx_dh_trans.from_sc_receive_lanes_ready = gen3_align_data_ins.brc3_cw[temp_sts_cntl_cw_dec_lane][20:22];
      rx_dh_trans.xmt_width_port_req_cmd = gen3_align_data_ins.brc3_cw[temp_sts_cntl_cw_dec_lane][36:38];
      rx_dh_trans.xmt_width_port_req_pending = gen3_align_data_ins.brc3_cw[temp_sts_cntl_cw_dec_lane][39];

      if (gen3_align_data_ins.brc3_cw[temp_sts_cntl_cw_dec_lane][17:19] == 3'b001)
      begin//{
        rx_dh_trans.from_sc_rcv_width	= "1x";
        rx_dh_trans.from_sc_rcv_width_int = 1;
      end //}
      else if (gen3_align_data_ins.brc3_cw[temp_sts_cntl_cw_dec_lane][17:19] == 3'b010)
      begin//{
        rx_dh_trans.from_sc_rcv_width	= "2x";
        rx_dh_trans.from_sc_rcv_width_int = 2;
      end //}
      else if (gen3_align_data_ins.brc3_cw[temp_sts_cntl_cw_dec_lane][17:19] == 3'b011)
      begin//{
        rx_dh_trans.from_sc_rcv_width	= "4x";
        rx_dh_trans.from_sc_rcv_width_int = 4;
      end //}
      else if (gen3_align_data_ins.brc3_cw[temp_sts_cntl_cw_dec_lane][17:19] == 3'b100)
      begin//{
        rx_dh_trans.from_sc_rcv_width	= "8x";
        rx_dh_trans.from_sc_rcv_width_int = 8;
      end //}
      else if (gen3_align_data_ins.brc3_cw[temp_sts_cntl_cw_dec_lane][17:19] == 3'b101)
      begin//{
        rx_dh_trans.from_sc_rcv_width	= "16x";
        rx_dh_trans.from_sc_rcv_width_int = 16;
      end //}
      else if (gen3_align_data_ins.brc3_cw[temp_sts_cntl_cw_dec_lane][17:19] != 3'b000)
      begin//{
        rx_dh_trans.from_sc_rcv_width	= "1x";
        rx_dh_trans.from_sc_rcv_width_int = 1;
      end //}

      rx_dh_trans.from_sc_rcv_width_link_cmd = gen3_align_data_ins.brc3_cw[temp_sts_cntl_cw_dec_lane][25:27];
      rx_dh_trans.from_sc_rcv_width_link_cmd_ack = gen3_align_data_ins.brc3_cw[temp_sts_cntl_cw_dec_lane][28];
      rx_dh_trans.from_sc_rcv_width_link_cmd_nack = gen3_align_data_ins.brc3_cw[temp_sts_cntl_cw_dec_lane][29];

      if (~bfm_or_mon)
      begin //{
        rx_dh_common_mon_trans.xmt_width_req_cmd[mon_type] = rx_dh_trans.xmt_width_port_req_cmd;
        rx_dh_common_mon_trans.xmt_width_req_pending[mon_type] = rx_dh_trans.xmt_width_port_req_pending;
        rx_dh_common_mon_trans.rcv_width_cmd[mon_type] = rx_dh_trans.from_sc_rcv_width_link_cmd;
        rx_dh_common_mon_trans.rcv_width_ack[mon_type] = rx_dh_trans.from_sc_rcv_width_link_cmd_ack;
        rx_dh_common_mon_trans.rcv_width_nack[mon_type] = rx_dh_trans.from_sc_rcv_width_link_cmd_nack;
      end //}

      if (~bfm_or_mon)
        check_from_sc_port_fields();

    end //}

  end //}

endtask : gen3_status_cntl_cw_decode





//////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : check_from_sc_port_fields
/// Description : This method checks if the from_sc_* fields are properly updated or not. The respective
/// fields are checked against the same fields from ~mon_type.
//////////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::check_from_sc_port_fields();

  if (rx_dh_trans.from_sc_initialized != rx_dh_common_mon_trans.port_initialized[~mon_type])
  begin //{

    `uvm_warning("SRIO_PL_RX_DATA_HANDLER : FROM_SC_PORT_INIT_FIELD_CHECK", $sformatf("Spec reference 5.5.3.5. from_sc_initialized field is not properly updated in the receiving STATUS/CONTROL control codeword. Expected Value is %0d, Received value is %0d", rx_dh_common_mon_trans.port_initialized[~mon_type], rx_dh_trans.from_sc_initialized))

  end //}

  if (rx_dh_trans.from_sc_xmt_1x_mode && (rx_dh_common_mon_trans.current_init_state[~mon_type] != X1_M0 && rx_dh_common_mon_trans.current_init_state[~mon_type] != X1_M1 && rx_dh_common_mon_trans.current_init_state[~mon_type] != X1_M2))
  begin //{

    `uvm_warning("SRIO_PL_RX_DATA_HANDLER : FROM_SC_XMT_1X_MODE_FIELD_CHECK", $sformatf("Spec reference 5.5.3.5. from_sc_xmt_1x_mode is not properly updated in the receiving STATUS/CONTROL control codeword. Port not initialized in any of the 1x mode, but from_sc_xmt_1x_mode is set to 1. Current init state is %0s", rx_dh_common_mon_trans.current_init_state[~mon_type].name()))

  end //}
  else if (~rx_dh_trans.from_sc_xmt_1x_mode && (rx_dh_common_mon_trans.current_init_state[~mon_type] == X1_M0 || rx_dh_common_mon_trans.current_init_state[~mon_type] == X1_M1 || rx_dh_common_mon_trans.current_init_state[~mon_type] == X1_M2))
  begin //{

    `uvm_warning("SRIO_PL_RX_DATA_HANDLER : FROM_SC_XMT_1X_MODE_FIELD_CHECK", $sformatf("Spec reference 5.5.3.5. from_sc_xmt_1x_mode is not properly updated in the receiving STATUS/CONTROL control codeword. Port initialized in one of the 1x modes, but from_sc_xmt_1x_mode is set to 0. Current init state is %0s", rx_dh_common_mon_trans.current_init_state[~mon_type].name()))

  end //}

  if (rx_dh_trans.from_sc_retrain_grnt != rx_dh_common_mon_trans.retrain_grnt[~mon_type])
  begin //{

    `uvm_warning("SRIO_PL_RX_DATA_HANDLER : FROM_SC_RETRAIN_GRANT_FIELD_CHECK", $sformatf("Spec reference 5.5.3.5. from_sc_retrain_grnt field is not properly updated in the receiving STATUS/CONTROL control codeword. Expected Value is %0d, Received value is %0d", rx_dh_common_mon_trans.retrain_grnt[~mon_type], rx_dh_trans.from_sc_retrain_grnt))

  end //}

  if (rx_dh_trans.from_sc_retrain_ready != rx_dh_common_mon_trans.retrain_ready[~mon_type])
  begin //{

    `uvm_warning("SRIO_PL_RX_DATA_HANDLER : FROM_SC_RETRAIN_READY_FIELD_CHECK", $sformatf("Spec reference 5.5.3.5. from_sc_retrain_ready field is not properly updated in the receiving STATUS/CONTROL control codeword. Expected Value is %0d, Received value is %0d", rx_dh_common_mon_trans.retrain_ready[~mon_type], rx_dh_trans.from_sc_retrain_ready))

  end //}

  if (rx_dh_trans.from_sc_retraining != rx_dh_common_mon_trans.retraining[~mon_type])
  begin //{

    `uvm_warning("SRIO_PL_RX_DATA_HANDLER : FROM_SC_RETRAINING_FIELD_CHECK", $sformatf("Spec reference 5.5.3.5. from_sc_retraining field is not properly updated in the receiving STATUS/CONTROL control codeword. Expected Value is %0d, Received value is %0d", rx_dh_common_mon_trans.retraining[~mon_type], rx_dh_trans.from_sc_retraining))

  end //}

endtask : check_from_sc_port_fields




//////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : update_error_detect_csr
/// Description : This method updates the Port n Error detect CSR when packet size error or IDLE1 sequence
/// error is detected. It also checks if corresponding bit is set in error rate CSR, and updates the error 
/// rate counter in Error Rate CSR. It also updates the Port n Capture 0-4 CSR if capture_valid_info bit
/// is not set.
//////////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::update_error_detect_csr(string csr_field_name);

  bit error_enable;
  bit [7:0] error_rate_counter;
  bit capture_valid_info;

  if (csr_field_name == "PKT_SIZE_ERR")
  begin //{
    register_update_method("Error_Detect_CSR", "Received_packet_exceeds_maximum_allowed_size", 64, "rx_dh_reg_model", reqd_field_name["Received_packet_exceeds_maximum_allowed_size"]);
    void'(reqd_field_name["Received_packet_exceeds_maximum_allowed_size"].predict(1));
    //void'(rx_dh_reg_model.Port_0_Error_Detect_CSR.Received_packet_exceeds_maximum_allowed_size.predict(1));
    register_update_method("Error_Rate_Enable_CSR", "Received_packet_exceeds_maximum_allowed_size_enable", 64, "rx_dh_reg_model", reqd_field_name["Received_packet_exceeds_maximum_allowed_size_enable"]);
    error_enable = reqd_field_name["Received_packet_exceeds_maximum_allowed_size_enable"].get();
    //error_enable = rx_dh_reg_model.Port_0_Error_Rate_Enable_CSR.Received_packet_exceeds_maximum_allowed_size_enable.get();
  end //}
  else if (csr_field_name == "IDLE1_ERR")
  begin //{
    register_update_method("Error_Detect_CSR", "Received_data_character_in_IDLE1_sequence", 64, "rx_dh_reg_model", reqd_field_name["Received_data_character_in_IDLE1_sequence"]);
    void'(reqd_field_name["Received_data_character_in_IDLE1_sequence"].predict(1));
    //void'(rx_dh_reg_model.Port_0_Error_Detect_CSR.Received_data_character_in_IDLE1_sequence.predict(1));
    register_update_method("Error_Rate_Enable_CSR", "Received_data_character_in_an_IDLE1_sequence_enable", 64, "rx_dh_reg_model", reqd_field_name["Received_data_character_in_an_IDLE1_sequence_enable"]);
    error_enable = reqd_field_name["Received_data_character_in_an_IDLE1_sequence_enable"].get();
    //error_enable = rx_dh_reg_model.Port_0_Error_Rate_Enable_CSR.Received_data_character_in_an_IDLE1_sequence_enable.get();
  end //}

  if (error_enable)
  begin //{
    register_update_method("Error_Rate_CSR", "Error_Rate_Counter", 64, "rx_dh_reg_model", reqd_field_name["Error_Rate_Counter"]);
    error_rate_counter = reqd_field_name["Error_Rate_Counter"].get();
    //error_rate_counter = rx_dh_reg_model.Port_0_Error_Rate_CSR.Error_Rate_Counter.get();
    error_rate_counter = {error_rate_counter[0], error_rate_counter[1], error_rate_counter[2], error_rate_counter[3], error_rate_counter[4], error_rate_counter[5], error_rate_counter[6], error_rate_counter[7]};
    if (error_rate_counter < 8'hFF)
    begin //{
      error_rate_counter++;
      error_rate_counter = {error_rate_counter[0], error_rate_counter[1], error_rate_counter[2], error_rate_counter[3], error_rate_counter[4], error_rate_counter[5], error_rate_counter[6], error_rate_counter[7]};
      register_update_method("Error_Rate_CSR", "Error_Rate_Counter", 64, "rx_dh_reg_model", reqd_field_name["Error_Rate_Counter"]);
      void'(reqd_field_name["Error_Rate_Counter"].predict(error_rate_counter));
      //void'(rx_dh_reg_model.Port_0_Error_Rate_CSR.Error_Rate_Counter.predict(error_rate_counter));
    end //}
  end //}

  register_update_method("Attributes_Capture_CSR", "Capture_valid_info", 64, "rx_dh_reg_model", reqd_field_name["Capture_valid_info"]);
  capture_valid_info = reqd_field_name["Capture_valid_info"].get();
  //capture_valid_info = rx_dh_reg_model.Port_0_Attributes_Capture_CSR.Capture_valid_info.get();

  if (~capture_valid_info && csr_field_name == "PKT_SIZE_ERR")
  begin //{

    register_update_method("Attributes_Capture_CSR", "Info_type", 64, "rx_dh_reg_model", reqd_field_name["Info_type"]);
    void'(reqd_field_name["Info_type"].predict(3'b000));
    //void'(rx_dh_reg_model.Port_0_Attributes_Capture_CSR.Info_type.predict(3'b000));
    register_update_method("Packet_Control_Symbol_Capture_0_CSR", "predict1", 64, "rx_dh_reg_model", reqd_field_name["predict1"]);
    //void'(rx_dh_reg_model.Port_0_Packet_Control_Symbol_Capture_0_CSR.predict(capture_0_reg_val));
    register_update_method("Packet_Capture_1_CSR", "predict2", 64, "rx_dh_reg_model", reqd_field_name["predict2"]);
    //void'(rx_dh_reg_model.Port_0_Packet_Capture_1_CSR.predict(capture_1_reg_val));
    register_update_method("Packet_Capture_2_CSR", "predict3", 64, "rx_dh_reg_model", reqd_field_name["predict3"]);
    //void'(rx_dh_reg_model.Port_0_Packet_Capture_2_CSR.predict(capture_2_reg_val));
    register_update_method("Packet_Capture_3_CSR", "predict4", 64, "rx_dh_reg_model", reqd_field_name["predict4"]);
    //void'(rx_dh_reg_model.Port_0_Packet_Capture_3_CSR.predict(capture_3_reg_val));
    register_update_method("Packet_Capture_4_CSR", "predict5", 64, "rx_dh_reg_model", reqd_field_name["predict5"]);
    //void'(rx_dh_reg_model.Port_0_Packet_Capture_4_CSR.predict(capture_4_reg_val));

    register_update_method("Attributes_Capture_CSR", "Capture_valid_info", 64, "rx_dh_reg_model", reqd_field_name["Capture_valid_info"]);
    void'(reqd_field_name["Capture_valid_info"].predict(1));
    //void'(rx_dh_reg_model.Port_0_Attributes_Capture_CSR.Capture_valid_info.predict(1));

  end //}


endtask : update_error_detect_csr




////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name :register_update_method 
/// Description : This method updates the appropriate register based on the port number configured.
/// It initially does a string concatenation based on the port number to form the register name, and then
/// gets the register name using the get_reg_by_name function. It then calculates the offset of the 
/// required register and then gets its name through get_reg_by_offset function. With the required register
/// name, the required field name is obtained from the get_field_by_name function and returned.
////////////////////////////////////////////////////////////////////////////////////////////////////////////
task automatic srio_pl_rx_data_handler::register_update_method(string reg_name, string field_name, int offset, string reg_ins, output uvm_reg_field out_field_name);

  string temp_reg_name;
  string reg_name_prefix;
  uvm_reg_addr_t reg_addr;
  uvm_reg reqd_reg_name;
  uvm_reg reg_name1;

  if (rx_dh_env_config.port_number == 0)
    reg_name_prefix = "Port_0_";
  else if (rx_dh_env_config.port_number == 1)
    reg_name_prefix = "Port_1_";
  else if (rx_dh_env_config.port_number == 2)
    reg_name_prefix = "Port_2_";
  else if (rx_dh_env_config.port_number == 3)
    reg_name_prefix = "Port_3_";
  else if (rx_dh_env_config.port_number == 4)
    reg_name_prefix = "Port_4_";
  else if (rx_dh_env_config.port_number == 5)
    reg_name_prefix = "Port_5_";
  else if (rx_dh_env_config.port_number == 6)
    reg_name_prefix = "Port_6_";
  else if (rx_dh_env_config.port_number == 7)
    reg_name_prefix = "Port_7_";
  else if (rx_dh_env_config.port_number == 8)
    reg_name_prefix = "Port_8_";
  else if (rx_dh_env_config.port_number == 9)
    reg_name_prefix = "Port_9_";
  else if (rx_dh_env_config.port_number == 10)
    reg_name_prefix = "Port_10_";
  else if (rx_dh_env_config.port_number == 11)
    reg_name_prefix = "Port_11_";
  else if (rx_dh_env_config.port_number == 12)
    reg_name_prefix = "Port_12_";
  else if (rx_dh_env_config.port_number == 13)
    reg_name_prefix = "Port_13_";
  else if (rx_dh_env_config.port_number == 14)
    reg_name_prefix = "Port_14_";
  else if (rx_dh_env_config.port_number == 15)
    reg_name_prefix = "Port_15_";
  else
    reg_name_prefix = "Port_0_";

  temp_reg_name = {reg_name_prefix, reg_name};

  if (reg_ins == "rx_dh_reg_model")
    reg_name1 = rx_dh_reg_model.get_reg_by_name(temp_reg_name);
  else if (reg_ins == "rx_dh_reg_model_tx")
    reg_name1 = rx_dh_env_config.srio_reg_model_tx.get_reg_by_name(temp_reg_name);
  else if (reg_ins == "rx_dh_reg_model_rx")
    reg_name1 = rx_dh_env_config.srio_reg_model_rx.get_reg_by_name(temp_reg_name);

  if (reg_name1 == null)
    `uvm_warning("NULL_REGISTER_ACCESS", $sformatf(" No register found with name %0s", temp_reg_name))
  reg_addr = reg_name1.get_offset();

  if (rx_dh_env_config.srio_mode != SRIO_GEN30 && rx_dh_env_config.spec_support != V30)
  begin //{
    if (reg_name == "Link_Maintenance_Response_CSR" || reg_name == "Control_2_CSR" || reg_name == "Error_and_Status_CSR" || reg_name == "Control_CSR")
      offset = 32;
  end //}

  if (reg_ins == "rx_dh_reg_model")
    reqd_reg_name = rx_dh_reg_model.srio_reg_block_map.get_reg_by_offset(reg_addr+(rx_dh_env_config.port_number*offset));
  else if (reg_ins == "rx_dh_reg_model_tx")
    reqd_reg_name = rx_dh_env_config.srio_reg_model_tx.srio_reg_block_map.get_reg_by_offset(reg_addr+(rx_dh_env_config.port_number*offset));
  else if (reg_ins == "rx_dh_reg_model_rx")
    reqd_reg_name = rx_dh_env_config.srio_reg_model_rx.srio_reg_block_map.get_reg_by_offset(reg_addr+(rx_dh_env_config.port_number*offset));

  if (reqd_reg_name == null)
    `uvm_warning("NULL_REGISTER_ACCESS", $sformatf(" Register %0s. Base address : %0h, Accessed address : %0h", temp_reg_name, reg_addr, reg_addr+(rx_dh_env_config.port_number*offset)))
  else
  begin //{
    if (reg_name == "Packet_Control_Symbol_Capture_0_CSR")
      void'(reqd_reg_name.predict(capture_0_reg_val));
    else if (reg_name == "Packet_Capture_1_CSR")
      void'(reqd_reg_name.predict(capture_1_reg_val));
    else if (reg_name == "Packet_Capture_2_CSR")
      void'(reqd_reg_name.predict(capture_2_reg_val));
    else if (reg_name == "Packet_Capture_3_CSR")
      void'(reqd_reg_name.predict(capture_3_reg_val));
    else if (reg_name == "Packet_Capture_4_CSR")
      void'(reqd_reg_name.predict(capture_4_reg_val));
    else
      out_field_name = reqd_reg_name.get_field_by_name(field_name);
  end //}

endtask : register_update_method




//////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : objection_handling
/// Description : This method raises the objection when control symbol or packet is being received
/// and drops the raised objection when the receiving control symbol / packet is completely received.
//////////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::objection_handling(uvm_phase phase);

  fork

    forever begin //{

      wait(packet_open == 1);

      phase.raise_objection(this);

      wait(packet_open == 0);

      phase.drop_objection(this);

    end //}

    forever begin //{

      wait(cntl_symbol_open == 1);

      phase.raise_objection(this);

      wait(cntl_symbol_open == 0);

      phase.drop_objection(this);

    end //}

  join

endtask : objection_handling

/////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : clear_vars_on_reset
/// Description : This method clears all the required flags, arrays and queues when reset is applied.
/////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_rx_data_handler::clear_vars_on_reset();

  forever begin //{

    @(negedge srio_if.srio_rst_n);

      cg_bet_clk_comp_cnt = 0;
      cs_st_fg=0;
  end //}

endtask : clear_vars_on_reset
