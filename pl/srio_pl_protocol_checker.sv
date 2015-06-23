////////////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File       :  srio_pl_protocol_checker.sv
// Project    :  srio vip
// Purpose    :  Performs the link protocol checks and checks on packet and control symbols
// Author     :  Mobiveil
//
// Physical layer protocol checks class.
//
//
//////////////////////////////////////////////////////////////////////////////////////////////////

class srio_pl_protocol_checker extends uvm_component;

  /// @cond
  `uvm_component_utils(srio_pl_protocol_checker)
  /// @endcond


  virtual srio_interface srio_if;				///< Virtual interface
                                                                                                            
  srio_env_config pl_pc_env_config;                             ///< ENV config instance
                                                                                                            
  srio_pl_config pl_pc_config;                                  ///< PL Config instance
                                                                                                            
  srio_pl_common_component_trans pl_pc_trans;                   ///< PL monitor common transaction instance
                                                                                                            
  srio_pl_tx_rx_mon_common_trans pl_pc_common_mon_trans;        ///< Common monitor transaction instance
                                                                                                            
  srio_reg_block pl_pc_reg_model;                               ///< Register model instance

  srio_trans temp_pc_trans_ins, temp_pc_trans_ins_2;		///< srio_trans instance used for checks.
  srio_trans temp_exp_trans, exp_trans;				///< srio_trans instance used for checks.
  srio_trans exp_comp_trans, temp_pkt_ack_trans;		///< srio_trans instance used for checks.
  srio_trans pc_trans_ins;					///< srio_trans instance used for checks.
  srio_trans cloned_pc_trans_ins;				///< srio_trans instance used for checks.
  srio_trans cloned_pc_trans_ins_2, cloned_pc_trans_ins_3;	///< srio_trans instance used for checks.
  srio_trans timeout_trans;					///< srio_trans instance used for checks.
  srio_trans received_packet_q[$];				///< Queue to hold the packets till its acknowledgement is received.
  srio_trans pkt_ack_stype0[$]; 

  srio_gen_trans_tracker gen_trans_tracker_ins;			///< Transaction tracker instance.

  // Properties
  bit mon_type;					///< Monitor type.
  bit report_error;				///< Report error or warning.

  bit cs_crc_err_detected;			///< Flag to indicate crc error is detected in the received control symbol.
  bit [0:23] rcvd_cs_crc;			///< Holds the crc value from the received control symbol.

  int pkt_early_crc_index;			///< Index of the early crc in the received packet.
  int pkt_final_crc_index;			///< Index of the final crc in the received packet.

  bit [15:0] pkt_early_crc_rcvd;		///< Holds the early crc value from the received packet.
  bit [15:0] pkt_early_crc_exp;			///< Holds the expected early crc value of the received packet.
  bit [15:0] pkt_final_crc_rcvd;		///< Holds the final crc value from the received packet.
  bit [15:0] pkt_final_crc_exp;			///< Holds the expected final crc value of the received packet.

  bit [15:0] pkt_early_crc_exp_2;		///< Another variable to store the expected early crc value used for CRC checks.
  bit [15:0] pkt_final_crc_exp_2;		///< Another variable to store the expected final crc value used for CRC checks.

  int exp_pkt_ackid;				///< Expected packet ackid value.
  int exp_cs_ackid;				///< Expected ackid value in the next packet acknowledgement control symbol.
  bit pkt_crc_err;				///< Flag to indicate packet crc error.
  bit pkt_ackid_err;				///< Flag to indicate packet ackid error.
  bit pl_pkt_err;				///< Set if any PL error is detected in the received packet.
  bit ct_mode_vc_pkt;				///< Flag to indicate that the received packet belongs to a CT mode VC.

  int buf_status_value;				///< Buf status value in the received control symbol.

  int arr_index;				///< Current index of an associative array.
  int last_arr_index;				///< Last index of an associative array.
  int link_req_arr_idx;				///< Array index used to clear already scheduled packet accepted control symbols, when OES state is entered.

  bit status_cs_freq_err;			///< Indicates detection of status control symbol frequency error.
  bit vc_status_cs_freq_err;			///< Indicated detection of VC status control symbol frequency error.

  int temp_outst_ack_q_size;			///< Holds the size of outstanding acknowledgement control symbols queue.
  bit scheduled_link_req_found;			///< Flag to indicate that scheduled link request control symbol is found in the outstanding cs queue.
  bit scheduled_rfr_found;			///< Flag to indicate that scheduled restart-from retry control symbol is found in the outstanding cs queue.
  bit scheduled_link_resp_found;		///< Flag to indicate that scheduled link response control symbol is found in the outstanding cs queue.
  bit scheduled_loop_req_found;			///< Flag to indicate that scheduled loop request control symbol is found in the outstanding cs queue.
  bit scheduled_loop_resp_found;		///< Flag to indicate that scheduled loop response control symbol is found in the outstanding cs queue.

  bit vc1_q_hit;				///< Indicates packet acknowledgement cs is received for a VCID 1 packet.
  bit vc2_q_hit;				///< Indicates packet acknowledgement cs is received for a VCID 2 packet.
  bit vc3_q_hit;				///< Indicates packet acknowledgement cs is received for a VCID 3 packet.
  bit vc4_q_hit;				///< Indicates packet acknowledgement cs is received for a VCID 4 packet.
  bit vc5_q_hit;				///< Indicates packet acknowledgement cs is received for a VCID 5 packet.
  bit vc6_q_hit;				///< Indicates packet acknowledgement cs is received for a VCID 6 packet.
  bit vc7_q_hit;				///< Indicates packet acknowledgement cs is received for a VCID 7 packet.
  bit vc8_q_hit;				///< Indicates packet acknowledgement cs is received for a VCID 8 packet.

  bit [0:7] lp_vc_refresh_int_temp;		///< Bit type vector to store link partner's vc refresh interval read from the register model.
  int lp_vc_refresh_int;			///< Integer type variable to calculate the link partner's vc refresh interval.

  byte unsigned bytestream[];			///< Bytestream to hold packet bytes which is used for unpack function call.
  int bytestream_size;				///< Size of bytestream array.

  int temp_loc;					///< Temp variable used for queue processing.
  bit write_trans_to_ap;			///< Flag which allows to write into analysis port.
  int ackid_min_in_q;
  int ackid_max_in_q;
  int ackid_rcvd_s0_6;

  bit check_timestamp_supp_for_dut_if;		///< Flag used to read the timestamp support value thro' pl_config or thro' register model.
  bit timestamp_car_master_support;		///< Master support value read from timestamp CAR.
  bit timestamp_car_slave_support;		///< Slave support value read from timestamp CAR.
  bit pl_pc_timestamp_auto_update_en;		///< local variable for timestamp auto update enable.
  bit pl_pc_send_zero_timestamp;		///< Local variable for send zero timestamp.
  bit pl_pc_send_timestamp;			///< Local variable for send timestamp.
  bit [1:0] timestamp_port_operating_mode;	///< Timestamp port operating mode read from register model.
  bit pl_pc_send_loop_request;			///< Local variable for send loop request.

  bit [2:0] temp_send_loop_request;		///< Send loop request value read from register model.

  bit check_mult_ack_supp_for_dut_if;		///< Flag used to read the multiple ack support value thro' pl_config or thro' register model.
  bit temp_mult_ack_support;			///< Multiple ack support value read from register model.
  bit temp_mult_ack_enable;			///< Multiple ack enable value read from register model.
  bit temp_pna_ackid_support;			///< Ackid_status in PNACC control symbol support value read from register model.
  bit temp_pna_ackid_enable;			///< Ackid_status in PNACC control symbol enable value read from register model.
  bit pl_pc_multiple_ack_support;		///< Local variable for multiple ack support.
  bit pl_pc_pna_ackid_support;			///< Local variable for ackid_status in pnacc control symbol support.
  bit check_for_pna;				///< Flag used for certain checks when pnacc cs is received while multiple ack and pna_ackid is enabled.

  bit [31:0] capture_0_reg_val;			///< Variable used to update Capture 0 CSR.
  bit [31:0] capture_1_reg_val;			///< Variable used to update Capture 1 CSR.
  bit [31:0] capture_2_reg_val;			///< Variable used to update Capture 2 CSR.
  bit [31:0] capture_3_reg_val;			///< Variable used to update Capture 3 CSR.
  bit [31:0] capture_4_reg_val;			///< Variable used to update Capture 4 CSR.
  bit ies_err_reg;

  uvm_reg_field reqd_field_name[string];	///< Associative array to get respective field name from register_update_method.

  uvm_analysis_port #(srio_trans) pl_pc_ap;	///< Analysis port.
  
  // Methods
  extern function new(string name = "srio_pl_protocol_checker", uvm_component parent = null);
  extern task run_phase(uvm_phase phase);

  extern task get_srio_trans();
  extern task write_accepted_packet_to_ap();
  extern task cntl_symbol_checks();
  extern task cntl_symbol_crc_check();
  extern task cntl_symbol_buf_status_check();
  extern task cntl_symbol_ackid_status_check();
  extern task cntl_symbol_delimiter_check();
  extern task cntl_symbol_status_cs_cnt_check();
  extern task cntl_symbol_vc_status_cs_cnt_check();
  extern task link_req_after_sync_seq_check();
  extern task cntl_symbol_outstanding_stype0_ack_check();
  extern task cntl_symbol_outstanding_stype1_ack_check();
  extern task packet_checks();
  extern task pkt_crc_check();
  extern task pkt_ackid_check();
  extern task pkt_vc_check();
  extern task pop_vc_q_on_pkt_acc(srio_trans local_temp_pc_trans_ins);
  extern task clear_vc_q_on_pkt_retry_or_pna();
  extern task clear_oes_state();
  extern task ies_recovery();
  extern task oes_recovery();
  extern task irs_recovery();
  extern task ors_recovery();
  extern task gen_link_resp();
  extern task status_cs_timer_method();
  extern task stype0_link_timeout_check();
  extern task stype1_link_timeout_check();
  extern task clear_vars_on_reset();
  extern task get_timestamp_vars();
  extern task timestamp_auto_update_timer_method();
  extern task schedule_loop_timing_request();
  extern task gen_loop_resp();
  extern task gen_retry_cs();
  extern task check_multiple_ack_support();
  extern task clear_pending_acknowledgements();
  extern task pop_received_pkt_q_on_ack_timeout();

  extern task update_link_maint_resp_reg_resp_valid();
  extern task update_link_maint_resp_reg();
  extern task update_inbound_ackid_outstanding_ackid_reg();
  extern task update_outbound_ackid_reg();
  extern task update_gen3_inbound_ackid_outstanding_ackid_reg();
  extern task update_gen3_outbound_ackid_reg();
  extern task update_pnescsr_idle_seq_active();
  extern task update_pnescsr_ies_fields();
  extern task update_pnescsr_oes_fields();
  extern task update_pnescsr_irs_fields();
  extern task update_pnescsr_ors_fields();
  extern task update_pnescsr_port_error_field();
  extern task update_pnescsr_pu_pnccsr_ipw_fields();
  extern task update_pnescsr_port_ok_field();
  extern task update_error_detect_csr(string csr_field_name);
  extern task set_ies_state();
  extern task tb_reset_ackid();
  extern virtual task automatic register_update_method(string reg_name, string field_name, int offset, string reg_ins, output uvm_reg_field out_field_name);

endclass



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : New
/// Description : Constructor method for srio_pl_protocol_checker class.
///////////////////////////////////////////////////////////////////////////////////////////////
function srio_pl_protocol_checker::new(string name = "srio_pl_protocol_checker", uvm_component parent = null);

  super.new(name, parent);
  pl_pc_ap = new("pl_pc_ap", this);
  gen_trans_tracker_ins = new();
  write_trans_to_ap = 1;

endfunction : new




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : run_phase
/// Description : run_phase method of srio_pl_protocol_checker class.
/// It triggers all the methods within the class which needs to be run forever.
/// It also registers the callback for uvm_error demote logic.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::run_phase(uvm_phase phase);

  err_demoter pl_pc_err_demoter = new();
  pl_pc_err_demoter.en_err_demote = !report_error;
  uvm_report_cb::add(this, pl_pc_err_demoter);

  pl_pc_common_mon_trans.outstanding_rfr[mon_type] = 1;
  pl_pc_common_mon_trans.outstanding_link_req[mon_type] = 1;

  pl_pc_common_mon_trans.outstanding_rfr[mon_type] = 0;
  pl_pc_common_mon_trans.outstanding_link_req[mon_type] = 0;

  fork
    tb_reset_ackid();
    get_srio_trans();
    write_accepted_packet_to_ap();
    clear_oes_state();
    ies_recovery();
    oes_recovery();
    irs_recovery();
    ors_recovery();
    gen_link_resp();
    gen_retry_cs();
    status_cs_timer_method();
    stype0_link_timeout_check();
    stype1_link_timeout_check();
    clear_vars_on_reset();

    if (pl_pc_env_config.srio_mode == SRIO_GEN30 || pl_pc_env_config.spec_support == V30)
      get_timestamp_vars();

    if (pl_pc_env_config.srio_mode == SRIO_GEN30 || pl_pc_env_config.spec_support == V30)
      timestamp_auto_update_timer_method();

    if (pl_pc_env_config.srio_mode == SRIO_GEN30 || pl_pc_env_config.spec_support == V30)
      schedule_loop_timing_request();

    if (pl_pc_env_config.srio_mode == SRIO_GEN30 || pl_pc_env_config.spec_support == V30)
      gen_loop_resp();

    if (pl_pc_env_config.srio_mode == SRIO_GEN30 || pl_pc_env_config.spec_support == V30)
      pop_received_pkt_q_on_ack_timeout();

    update_pnescsr_idle_seq_active();
    update_pnescsr_ies_fields();
    update_pnescsr_oes_fields();
    update_pnescsr_irs_fields();
    update_pnescsr_ors_fields();
    update_pnescsr_pu_pnccsr_ipw_fields();
    update_pnescsr_port_ok_field();
    set_ies_state();
  join_none

endtask : run_phase




/////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : get_srio_trans
/// Description : This method pops the srio_trans from the pl_rx_srio_trans_q, and triggers
/// either packet checks or control symbol checks based on the transaction kind. It also writes
/// the transaction to the analysis port immediately if it is a control symbol trans. If it is
/// a packet trans, then it is pushed into the received_packet_q. Once the acknowledgement for
/// that packet is received, then only it is decided whether to write the packet into the 
/// analysis port or to discard it. This method also calls the transaction tracker's methods
/// to write the transaction into tracker file.
/////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::get_srio_trans();

  forever begin //{

    wait(pl_pc_trans.pl_rx_srio_trans_q.size()>0);

    temp_pc_trans_ins = new pl_pc_trans.pl_rx_srio_trans_q.pop_front();

    bytestream_size = temp_pc_trans_ins.bytestream.size();

    if (bytestream.size()>0)
      bytestream.delete();

    bytestream = new[bytestream_size] (temp_pc_trans_ins.bytestream);

    pc_trans_ins = new temp_pc_trans_ins;

    ///< If receive_enable is not set, the control symbols and packets should
    ///< be ignored and discarded.
    if (pl_pc_env_config.srio_mode == SRIO_GEN30)
    begin //{

      if (~pl_pc_trans.receive_enable)
	continue;

    end //}

    //$cast(cloned_pc_trans_ins, pc_trans_ins.clone());
    cloned_pc_trans_ins = new pc_trans_ins;

    cloned_pc_trans_ins.env_config = pl_pc_env_config;

    if (cloned_pc_trans_ins.transaction_kind == SRIO_PACKET && pl_pc_common_mon_trans.oes_state_detected[~mon_type])
    begin //{

      `uvm_error("SRIO_PL_PROTOCOL_CHECKER : PKT_DURING_OES_CHECK", $sformatf(" Spec reference 5.13.2.7. Packet is transmitted in Output-Error-Stopped state"))

    end //}

    if (pl_pc_config.has_checks)
    begin //{

      if (temp_pc_trans_ins.transaction_kind == SRIO_CS)
      begin //{
        cntl_symbol_checks();
      end //}
      else if (temp_pc_trans_ins.transaction_kind == SRIO_PACKET && ~pl_pc_trans.ies_state && ~pl_pc_common_mon_trans.oes_state_detected[~mon_type] && ~pl_pc_trans.packet_cancelled && pl_pc_trans.link_initialized)
      begin //{
    	if (pl_pc_common_mon_trans.outstanding_rfr[mon_type])
    	begin //{
          `uvm_info("SRIO_PL_PROTOCOL_CHECKER : PACKET_IN_IRS", $sformatf(" Packet received during irs state. Ignoring"), UVM_MEDIUM)
	  continue;
	end //}
	else
	begin //{
          packet_checks();
	end //}
      end //}
      else if (temp_pc_trans_ins.transaction_kind == SRIO_PACKET && ~pl_pc_trans.link_initialized)
      begin //{
        `uvm_info("SRIO_PL_PROTOCOL_CHECKER : PACKET_BEFORE_LINK_INIT", $sformatf(" Packet received before link is initialized. Ignoring"), UVM_MEDIUM)
	continue;
      end //}

    end //}

    if (temp_pc_trans_ins.transaction_kind == SRIO_CS)
    begin //{

      wait(write_trans_to_ap == 1);
      write_trans_to_ap = 0;
      pl_pc_ap.write(cloned_pc_trans_ins);
      write_trans_to_ap = 1;

      gen_trans_tracker_ins.trans_tracker_env_config = pl_pc_env_config;
      gen_trans_tracker_ins.file_h = pl_pc_env_config.file_h;

      if ((mon_type && pl_pc_env_config.srio_tx_mon_if == BFM) || (~mon_type && pl_pc_env_config.srio_rx_mon_if == BFM))
        gen_trans_tracker_ins.bfm_tx_control_symbol_tracker(temp_pc_trans_ins);
      else
        gen_trans_tracker_ins.bfm_rx_control_symbol_tracker(temp_pc_trans_ins);

      if (cloned_pc_trans_ins.stype0 == 3'b000)
      begin //{
	wait (pl_pc_common_mon_trans.write_pkt_to_ap[~mon_type] == 0);
	pl_pc_common_mon_trans.ackid_in_cs[~mon_type] = cloned_pc_trans_ins.param0;
	pl_pc_common_mon_trans.pkt_accepted[~mon_type] = 1;
	pl_pc_common_mon_trans.pkt_retried[~mon_type] = 0;
	pl_pc_common_mon_trans.pkt_not_accepted[~mon_type] = 0;
	pl_pc_common_mon_trans.write_pkt_to_ap[~mon_type] = 1;
      end //}
      else if (cloned_pc_trans_ins.stype0 == 3'b001)
      begin //{
	wait (pl_pc_common_mon_trans.write_pkt_to_ap[~mon_type] == 0);
	pl_pc_common_mon_trans.ackid_in_cs[~mon_type] = cloned_pc_trans_ins.param0;
	pl_pc_common_mon_trans.pkt_accepted[~mon_type] = 0;
	pl_pc_common_mon_trans.pkt_retried[~mon_type] = 1;
	pl_pc_common_mon_trans.pkt_not_accepted[~mon_type] = 0;
	pl_pc_common_mon_trans.write_pkt_to_ap[~mon_type] = 1;
      end //}
      else if (cloned_pc_trans_ins.stype0 == 3'b010)
      begin //{
	wait (pl_pc_common_mon_trans.write_pkt_to_ap[~mon_type] == 0);
	pl_pc_common_mon_trans.ackid_in_cs[~mon_type] = cloned_pc_trans_ins.param0;
	pl_pc_common_mon_trans.pkt_accepted[~mon_type] = 0;
	pl_pc_common_mon_trans.pkt_retried[~mon_type] = 0;
	pl_pc_common_mon_trans.pkt_not_accepted[~mon_type] = 1;
	pl_pc_common_mon_trans.write_pkt_to_ap[~mon_type] = 1;
      end //}

    end //}
    else if (cloned_pc_trans_ins.transaction_kind == SRIO_PACKET && ~pl_pc_trans.packet_cancelled && pl_pc_trans.link_initialized)
    begin //{

      // The higher layers have to check for ackID_err, early_crc_err & final_crc_err
      // in the received SRIO_PACKET type trans and then only process the packet.
      // From the next packet, it'll not be written into the analysis port at all
      // until the ies_state is cleared.

      if (~pl_pc_trans.ies_state && ~pl_pc_common_mon_trans.oes_state_detected[~mon_type])
      begin //{

        void'(cloned_pc_trans_ins.unpack_bytes(bytestream));
        cloned_pc_trans_ins_2 = new cloned_pc_trans_ins;
	//`uvm_info("TEST", $sformatf(" pushing packet with ackid %0d into received_packet_q.", cloned_pc_trans_ins_2.ackid), UVM_LOW)
        received_packet_q.push_back(cloned_pc_trans_ins_2);

      end //}
      else if (pl_pc_trans.ies_state && (cloned_pc_trans_ins.ackID_err || cloned_pc_trans_ins.early_crc_err || cloned_pc_trans_ins.final_crc_err || cloned_pc_trans_ins.crc32_err))
      begin //{
        void'(cloned_pc_trans_ins.unpack_bytes(bytestream));
	cloned_pc_trans_ins.pl_err_encountered = 1;
        wait(write_trans_to_ap == 1);
        write_trans_to_ap = 0;
        //pl_pc_ap.write(cloned_pc_trans_ins);
        write_trans_to_ap = 1;
      end //}

      gen_trans_tracker_ins.trans_tracker_env_config = pl_pc_env_config;
      gen_trans_tracker_ins.file_h = pl_pc_env_config.file_h;

      if ((mon_type && pl_pc_env_config.srio_tx_mon_if == BFM) || (~mon_type && pl_pc_env_config.srio_rx_mon_if == BFM))
        gen_trans_tracker_ins.bfm_tx_pkt_tracker(temp_pc_trans_ins);
      else
        gen_trans_tracker_ins.bfm_rx_pkt_tracker(temp_pc_trans_ins);

    end //}

  end //}

endtask : get_srio_trans





///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : write_accepted_packet_to_ap
/// Description : This method pops the received_packet_q if corresponding packet
/// acknowledgement is received, and either writes into the analysis port if packet is accepted
/// or clears it if retried. Multiple acknowledgement is also taken care in this method.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::write_accepted_packet_to_ap();

  pl_pc_common_mon_trans.write_pkt_to_ap[mon_type] = 1;
  pl_pc_common_mon_trans.write_pkt_to_ap[mon_type] = 0;

  forever begin //{

    wait (pl_pc_common_mon_trans.write_pkt_to_ap[mon_type] == 1);

    if (received_packet_q.size() == 0)
    begin //{
      pl_pc_common_mon_trans.write_pkt_to_ap[mon_type] = 0;
      continue;
    end //}

    if (pl_pc_common_mon_trans.pkt_retried[mon_type] || pl_pc_common_mon_trans.pkt_not_accepted[mon_type])
    begin //{

      check_multiple_ack_support();

      if (pl_pc_multiple_ack_support || (pl_pc_pna_ackid_support && pl_pc_common_mon_trans.pkt_not_accepted[mon_type]))
      begin //{

        wait(write_trans_to_ap == 1);
        write_trans_to_ap = 0;

        cloned_pc_trans_ins_3 = new received_packet_q[0];

	// When the packet ackid matches with the param0 value in received
	// cs, then the loop should be quit. Th '!=' condition will make sure
	// of that logic.
        while (cloned_pc_trans_ins_3.ackid != pl_pc_common_mon_trans.ackid_in_cs[mon_type])
        begin //{

 	  void'(received_packet_q.pop_front());
          `uvm_info("PKT_WRITE_TO_AP", $sformatf(" Packet ackid : %0d", cloned_pc_trans_ins_3.ackid), UVM_LOW)
          pl_pc_ap.write(cloned_pc_trans_ins_3);

	  if (received_packet_q.size() == 0)
	    break;

          cloned_pc_trans_ins_3 = new received_packet_q[0];

        end //}

	if (received_packet_q.size() >= 0)
          received_packet_q.delete();

        write_trans_to_ap = 1;

      end //}
      else
      begin //{
        received_packet_q.delete();
      end //}

    end //}
    else if (pl_pc_common_mon_trans.pkt_accepted[mon_type])
    begin //{

      check_multiple_ack_support();

      if (pl_pc_multiple_ack_support)
      begin //{

        wait(write_trans_to_ap == 1);
        write_trans_to_ap = 0;

        cloned_pc_trans_ins_3 = new received_packet_q[0];

        while (cloned_pc_trans_ins_3.ackid <= pl_pc_common_mon_trans.ackid_in_cs[mon_type] || cloned_pc_trans_ins_3.ackid >= pl_pc_common_mon_trans.ackid_in_cs[mon_type])
        begin //{

 	  void'(received_packet_q.pop_front());
          `uvm_info("PKT_WRITE_TO_AP", $sformatf(" Packet ackid : %0d", cloned_pc_trans_ins_3.ackid), UVM_LOW)
          pl_pc_ap.write(cloned_pc_trans_ins_3);

	  // Packet with ackid matching the param0 in packet-accepted cs
	  // should be written to the analysis port. Once it is done, then the
	  // loop can be broken.
	  if (received_packet_q.size() == 0 || cloned_pc_trans_ins_3.ackid == pl_pc_common_mon_trans.ackid_in_cs[mon_type])
	    break;

          cloned_pc_trans_ins_3 = new received_packet_q[0];

        end //}

        write_trans_to_ap = 1;

      end //}
      else
      begin //{
        wait(write_trans_to_ap == 1);
        write_trans_to_ap = 0;
        cloned_pc_trans_ins_3 = new received_packet_q.pop_front();
        `uvm_info("PKT_WRITE_TO_AP", $sformatf(" Packet ackid : %0d", cloned_pc_trans_ins_3.ackid), UVM_LOW)
        pl_pc_ap.write(cloned_pc_trans_ins_3);
        write_trans_to_ap = 1;
      end //}

    end //}

    pl_pc_common_mon_trans.pkt_accepted[mon_type] = 0;
    pl_pc_common_mon_trans.pkt_retried[mon_type] = 0;
    pl_pc_common_mon_trans.pkt_not_accepted[mon_type] = 0;

    pl_pc_common_mon_trans.write_pkt_to_ap[mon_type] = 0;

  end //}

endtask : write_accepted_packet_to_ap




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : cntl_symbol_checks
/// Description : This method triggers all the control symbol related checks sequentially.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::cntl_symbol_checks();

  int temp_rev_val;


  // Generating the capture_0_reg_val and capture_1_reg_val so that, if required,
  // variables will be used to log into the repective capture registers.
  if (temp_pc_trans_ins.cstype == CS24)
  begin //{
    if (temp_pc_trans_ins.cs_kind == SRIO_DELIM_SC)
      capture_0_reg_val = {8'h1C, temp_pc_trans_ins.stype0[1:3], temp_pc_trans_ins.param0[7:11], temp_pc_trans_ins.param1[7:11], temp_pc_trans_ins.stype1, temp_pc_trans_ins.cmd, temp_pc_trans_ins.cs_crc5};
    else if (temp_pc_trans_ins.cs_kind == SRIO_DELIM_PD)
      capture_0_reg_val = {8'h7C, temp_pc_trans_ins.stype0[1:3], temp_pc_trans_ins.param0[7:11], temp_pc_trans_ins.param1[7:11], temp_pc_trans_ins.stype1, temp_pc_trans_ins.cmd, temp_pc_trans_ins.cs_crc5};
  end //}
  else if (temp_pc_trans_ins.cstype == CS48)
  begin //{
    if (temp_pc_trans_ins.cs_kind == SRIO_DELIM_SC)
    begin //{
      capture_0_reg_val = {8'h1C, temp_pc_trans_ins.stype0[1:3], temp_pc_trans_ins.param0[6:11], temp_pc_trans_ins.param1[6:11], temp_pc_trans_ins.stype1, temp_pc_trans_ins.cmd, 3'b000};
      capture_1_reg_val = {11'b00000_000000, temp_pc_trans_ins.cs_crc13, 8'h1C};
    end //}
    else if (temp_pc_trans_ins.cs_kind == SRIO_DELIM_PD)
    begin //{
      capture_0_reg_val = {8'h7C, temp_pc_trans_ins.stype0[1:3], temp_pc_trans_ins.param0[6:11], temp_pc_trans_ins.param1[6:11], temp_pc_trans_ins.stype1, temp_pc_trans_ins.cmd, 3'b000};
      capture_1_reg_val = {11'b00000_000000, temp_pc_trans_ins.cs_crc13, 8'h7C};
    end //}
  end //}
  else if (temp_pc_trans_ins.cstype == CS64)
  begin //{
    capture_0_reg_val = {temp_pc_trans_ins.stype0, temp_pc_trans_ins.param0, temp_pc_trans_ins.param1, temp_pc_trans_ins.brc3_stype1_msb, 2'b00};
    capture_1_reg_val = {temp_pc_trans_ins.stype1, temp_pc_trans_ins.cmd, temp_pc_trans_ins.cs_crc24};
  end //}

  temp_rev_val = 31;
  for (int rev_val=0; rev_val<32; rev_val++)
  begin //{
    capture_0_reg_val[rev_val] = capture_0_reg_val[temp_rev_val];
    capture_1_reg_val[rev_val] = capture_1_reg_val[temp_rev_val];
    temp_rev_val--;
  end //}


  cntl_symbol_crc_check();

  cntl_symbol_buf_status_check();


  if (pl_pc_env_config.srio_mode != SRIO_GEN30)
    cntl_symbol_delimiter_check();

  cntl_symbol_status_cs_cnt_check();

  cntl_symbol_vc_status_cs_cnt_check();

  if (pl_pc_trans.sync_seq_detected && pl_pc_trans.cs_after_sync_seq_rcvd)
  begin //{
    pl_pc_trans.cs_after_sync_seq_rcvd = 0;
    pl_pc_trans.cs_after_sync_seq_processed = 1;
  end //}

  if (temp_pc_trans_ins.stype1 == 3'b100 && pl_pc_trans.idle_detected && pl_pc_trans.idle_selected)
    link_req_after_sync_seq_check();

  if (temp_pc_trans_ins.stype0 == 3'b000 || temp_pc_trans_ins.stype0 == 3'b001 || temp_pc_trans_ins.stype0 == 3'b010 || temp_pc_trans_ins.stype0 == 3'b110 || temp_pc_trans_ins.stype0 == 4'b0011 || (temp_pc_trans_ins.stype0 == 4'b1011 && pl_pc_env_config.srio_mode == SRIO_GEN30))
    cntl_symbol_outstanding_stype0_ack_check();
  if (temp_pc_trans_ins.stype0 == 4'b1101 &&  pl_pc_env_config.srio_mode== SRIO_GEN30)
    `uvm_info("SRIO_PL_PROTOCOL_CHECKER : VOQ_CS", $sformatf(" VOQ-backpressure control symbol received."), UVM_LOW)
 #0;
  if (temp_pc_trans_ins.brc3_stype1_msb == 2'b00 && (temp_pc_trans_ins.stype1 == 3'b100 || temp_pc_trans_ins.stype1 == 3'b011 || temp_pc_trans_ins.stype1 == 3'b101))
    cntl_symbol_outstanding_stype1_ack_check();
  if (temp_pc_trans_ins.brc3_stype1_msb == 2'b00 && temp_pc_trans_ins.stype1 == 3'b101 && temp_pc_trans_ins.cmd == 3'b000)
    `uvm_info("SRIO_PL_PROTOCOL_CHECKER : MULTICAST_CS", $sformatf(" Multicast-event control symbol received."), UVM_LOW)
  cntl_symbol_ackid_status_check();

endtask : cntl_symbol_checks




////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : cntl_symbol_crc_check
/// Description : This method performs the control symbol CRC check. If error is detected, it
/// schedules pna with appropriate cause field for the other monitor's outstanding stype0 queue.
////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::cntl_symbol_crc_check();

  temp_pc_trans_ins_2 = new temp_pc_trans_ins;


  if (temp_pc_trans_ins.cstype == CS24 && (temp_pc_trans_ins.cs_crc5 != temp_pc_trans_ins_2.calccrc5(temp_pc_trans_ins_2.pack_cs())))
  begin //{
    cs_crc_err_detected = 1;
    cloned_pc_trans_ins.cs_crc5_err = 1;
  end //}
  else if (temp_pc_trans_ins.cstype == CS48 && (temp_pc_trans_ins.cs_crc13 != temp_pc_trans_ins_2.calccrc13(temp_pc_trans_ins_2.pack_cs())))
  begin //{
    cs_crc_err_detected = 1;
    cloned_pc_trans_ins.cs_crc13_err = 1;
  end //}
  else if (temp_pc_trans_ins.cstype == CS64 && (temp_pc_trans_ins.cs_crc24 != temp_pc_trans_ins_2.calccrc24(temp_pc_trans_ins_2.pack_cs())))
  begin //{
    cs_crc_err_detected = 1;
    cloned_pc_trans_ins.cs_crc24_err = 1;
  end //}

  if (temp_pc_trans_ins.cstype == CS24)
    rcvd_cs_crc[19:23] = temp_pc_trans_ins.cs_crc5;
  else if (temp_pc_trans_ins.cstype == CS48)
    rcvd_cs_crc[11:23] = temp_pc_trans_ins.cs_crc13;
  else if (temp_pc_trans_ins.cstype == CS64)
    rcvd_cs_crc = temp_pc_trans_ins.cs_crc24;

 // if (~cs_crc_err_detected)
 //   $display($time, " cs crc is proper. rcvd is %0h, expected is %0h", rcvd_cs_crc, temp_pc_trans_ins.calccrc13(temp_pc_trans_ins.pack_cs()));

  if (cs_crc_err_detected)
  begin //{

    update_error_detect_csr("CORRUPT_CS");

    cs_crc_err_detected = 0;

    if (~pl_pc_trans.ies_state && pl_pc_trans.link_initialized)
    begin //{
      pl_pc_trans.ies_state = 1;
      pl_pc_trans.ies_cause_value = 2;
	//$display($time, " 11. Vaidhy : ies_state set here");
    end //}

    if (temp_pc_trans_ins.cstype == CS24)
      `uvm_error("SRIO_PL_PROTOCOL_CHECKER : CONTROL_SYMBOL_CRC5_CHECK", $sformatf(" Spec reference 5.13.2.3.2. Incorrect CRC detected in control symbol. Received crc is %0h, Expected crc is %0h", rcvd_cs_crc, temp_pc_trans_ins_2.calccrc5(temp_pc_trans_ins_2.pack_cs())))
    else if (temp_pc_trans_ins.cstype == CS48)
      `uvm_error("SRIO_PL_PROTOCOL_CHECKER : CONTROL_SYMBOL_CRC13_CHECK", $sformatf(" Spec reference 5.13.2.3.2. Incorrect CRC detected in control symbol. Received crc is %0h, Expected crc is %0h", rcvd_cs_crc, temp_pc_trans_ins_2.calccrc13(temp_pc_trans_ins_2.pack_cs())))
    else if (temp_pc_trans_ins.cstype == CS64)
      `uvm_error("SRIO_PL_PROTOCOL_CHECKER : CONTROL_SYMBOL_CRC24_CHECK", $sformatf(" Spec reference 5.13.2.3.2. Incorrect CRC detected in control symbol. Received crc is %0h, Expected crc is %0h", rcvd_cs_crc, temp_pc_trans_ins_2.calccrc24(temp_pc_trans_ins_2.pack_cs())))

  end //}

endtask : cntl_symbol_crc_check




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : packet_checks
/// Description : This method triggers all the packet related checks and also updates the
/// "expected" flags from the received packet to perform checks on the next packet. If no
/// error is detected in the packet it schedules packet accepted control symbol for the
/// other monitor's outstanding stype0 queue. On the other hand, if error is detected, it
/// will set ies_state and the corresponding ies_cause_value, so that ies_recovery method
/// will take the required action.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::packet_checks();

  `uvm_info("SRIO_PL_PROTOCOL_CHECKER : PACKET_RECEIVED", $sformatf("Total packet bytes is %0d", bytestream.size()), UVM_LOW)

  if(pl_pc_trans.link_req_rst_cmd_cnt>0)
    pl_pc_trans.link_req_rst_cmd_cnt=0;

  if(pl_pc_trans.link_req_rst_port_cmd_cnt>0)
    pl_pc_trans.link_req_rst_port_cmd_cnt=0;
/*
  capture_0_reg_val = {bytestream[3], bytestream[2], bytestream[1], bytestream[0]};
  capture_1_reg_val = {bytestream[7], bytestream[6], bytestream[5], bytestream[4]};
  capture_2_reg_val = {bytestream[11], bytestream[10], bytestream[9], bytestream[8]};
  capture_3_reg_val = {bytestream[15], bytestream[14], bytestream[13], bytestream[12]};
  capture_4_reg_val = {bytestream[19], bytestream[18], bytestream[17], bytestream[16]};
*/
  for(int index=0; index<bytestream.size(); index+=4) begin//{
    if(index==0)   capture_0_reg_val = {bytestream[index+3], bytestream[index+2], bytestream[index+1], bytestream[index]};
    if(index==4)   capture_1_reg_val = {bytestream[index+3], bytestream[index+2], bytestream[index+1], bytestream[index]};
    if(index==8)   capture_2_reg_val = {bytestream[index+3], bytestream[index+2], bytestream[index+1], bytestream[index]};
    if(index==12)  capture_3_reg_val = {bytestream[index+3], bytestream[index+2], bytestream[index+1], bytestream[index]};
    if(index==16)  capture_4_reg_val = {bytestream[index+3], bytestream[index+2], bytestream[index+1], bytestream[index]};
  end//}
  pkt_crc_check();

  temp_pc_trans_ins.env_config = pl_pc_env_config;

  void'(temp_pc_trans_ins.unpack_bytes(bytestream));

  pkt_ackid_check();

  pkt_vc_check();

  if (~ct_mode_vc_pkt)
    pl_pkt_err = pkt_crc_err | pkt_ackid_err;

  if (~pl_pkt_err)
  begin //{

    pl_pc_common_mon_trans.pl_outstanding_ackid[mon_type][exp_pkt_ackid] = 1;

    pl_pc_common_mon_trans.num_outstanding_pkts[mon_type]++;

    temp_exp_trans = new();
    temp_exp_trans.env_config = pl_pc_env_config;
    temp_exp_trans.transaction_kind = SRIO_CS;
    temp_exp_trans.stype0 = 3'b000;
    temp_exp_trans.param0 = exp_pkt_ackid;

    exp_trans = new temp_exp_trans;
    exp_trans.env_config = pl_pc_env_config;

    pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[~mon_type].push_back(exp_trans);
    pl_pc_common_mon_trans.pkt_ack_timer_stype0[~mon_type].push_back(pl_pc_config.link_timeout);

    exp_pkt_ackid++;

    if (pl_pc_env_config.srio_mode != SRIO_GEN30 && pl_pc_env_config.spec_support != V30)
      update_outbound_ackid_reg();
    else
      update_gen3_outbound_ackid_reg();

    if (exp_pkt_ackid == 64 && pl_pc_trans.idle_selected && pl_pc_env_config.srio_mode != SRIO_GEN30)
      exp_pkt_ackid = 0;
    else if (exp_pkt_ackid == 32 && ~pl_pc_trans.idle_selected && pl_pc_env_config.srio_mode != SRIO_GEN30)
      exp_pkt_ackid = 0;
    else if (exp_pkt_ackid == 4096 && pl_pc_env_config.srio_mode == SRIO_GEN30)
      exp_pkt_ackid = 0;

  end //}
  else
  begin //{

    if (~pl_pc_trans.ies_state)
    begin //{

      pl_pc_trans.ies_state = 1;
	//$display($time, " 12. Vaidhy : ies_state set here");

      if (pkt_ackid_err)
        pl_pc_trans.ies_cause_value = 1;
      else if (pkt_crc_err)
        pl_pc_trans.ies_cause_value = 4;

    end //}

    pkt_ackid_err = 0;
    pkt_crc_err = 0;

  end //}

endtask : packet_checks




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : pkt_crc_check
/// Description : This method performs early and final CRC checks on the received packet.
/// For early crc check, the crc calculation is performed till 82nd byte which includes the
/// early crc. Since output will be zeros if same values are XORed, the output is checked
/// against 16'h0000, and error is triggered if the condition is not met. Similarly, for final
/// crc check, crc calculation is performed for the entire packet bytes including the final
/// crc bytes.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::pkt_crc_check();

  temp_pc_trans_ins.total_pkt_bytes = bytestream.size();

  if (bytestream[temp_pc_trans_ins.total_pkt_bytes-2] == SRIO_D00 && bytestream[temp_pc_trans_ins.total_pkt_bytes-1] == SRIO_D00)
    temp_pc_trans_ins.pad = 2;
  else
    temp_pc_trans_ins.pad = 0;

  temp_pc_trans_ins_2 = new temp_pc_trans_ins;


  pkt_early_crc_index = temp_pc_trans_ins.findearlycrc();
  pkt_final_crc_index = temp_pc_trans_ins.findfinalcrc();

  pkt_early_crc_rcvd = {bytestream[pkt_early_crc_index], bytestream[pkt_early_crc_index+1]};

  pkt_early_crc_exp = temp_pc_trans_ins_2.computecrc16(0, pkt_early_crc_index, 16'hFFFF);
  pkt_early_crc_exp_2 = temp_pc_trans_ins_2.computecrc16(0, pkt_early_crc_index+2, 16'hFFFF);

  //if (pkt_early_crc_rcvd !== pkt_early_crc_exp)
  if (pkt_early_crc_exp_2 != 16'h0000)
  begin //{

    pkt_crc_err = 1;

    cloned_pc_trans_ins.early_crc_err = 1;

    update_error_detect_csr("BAD_CRC_PKT");

    `uvm_error("SRIO_PL_PROTOCOL_CHECKER : PKT_EARLY_CRC_CHECK", $sformatf(" Spec reference 5.13.2.4. Incorrect early CRC detected in packet. Received crc is %0h, Expected crc is %0h", pkt_early_crc_rcvd, pkt_early_crc_exp))

  end //}

  if (pkt_final_crc_index == 0)
    return;

  pkt_final_crc_rcvd = {bytestream[pkt_final_crc_index], bytestream[pkt_final_crc_index+1]};

  pkt_final_crc_exp = temp_pc_trans_ins_2.computecrc16(pkt_early_crc_index, pkt_final_crc_index, pkt_early_crc_rcvd);
  pkt_final_crc_exp_2 = temp_pc_trans_ins_2.computecrc16(pkt_early_crc_index, temp_pc_trans_ins.total_pkt_bytes, pkt_early_crc_rcvd);

  //if (pkt_final_crc_rcvd !== pkt_final_crc_exp)
  if (pkt_final_crc_exp_2 != 16'h0000)
  begin //{

    pkt_crc_err = 1;

    cloned_pc_trans_ins.final_crc_err = 1;

    update_error_detect_csr("BAD_CRC_PKT");

    `uvm_error("SRIO_PL_PROTOCOL_CHECKER : PKT_FINAL_CRC_CHECK", $sformatf(" Spec reference 5.13.2.4. Incorrect final CRC detected in packet. Received crc is %0h, Expected crc is %0h", pkt_final_crc_rcvd, pkt_final_crc_exp))

  end //}

endtask : pkt_crc_check




///////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : pkt_ackid_check
/// Description : This method checks if the expected packet ackid and the ackid in the received
/// packets are same or not. It also checks if outstanding ackid is retransmitted again, and
/// also whether no. of allowed outstanding ackid is exceeding or not.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::pkt_ackid_check();

  if (temp_pc_trans_ins.ackid != exp_pkt_ackid)
  begin //{

    pkt_ackid_err = 1;

    cloned_pc_trans_ins.ackID_err = 1;

    -> pl_pc_trans.invalid_ackID;

    update_error_detect_csr("UNEXP_ACKID_PKT");

    `uvm_error("SRIO_PL_PROTOCOL_CHECKER : INCORRECT_PKT_ACKID_CHECK", $sformatf(" Spec reference 5.13.2.4. Incorrect ackid detected in packet. Received ackid is %0h, Expected ackid is %0h", temp_pc_trans_ins.ackid, exp_pkt_ackid))

  end //}

  if (pl_pc_common_mon_trans.pl_outstanding_ackid[mon_type].exists(temp_pc_trans_ins.ackid) && pl_pc_common_mon_trans.pl_outstanding_ackid[mon_type][temp_pc_trans_ins.ackid] == 1)
  begin //{

    pkt_ackid_err = 1;

    cloned_pc_trans_ins.ackID_err = 1;

    update_error_detect_csr("UNEXP_ACKID_PKT");

    `uvm_error("SRIO_PL_PROTOCOL_CHECKER : OUTSTANDING_PKT_ACKID_CHECK", $sformatf(" Spec reference 5.13.2.4. Outstanding ackid detected in packet. Received ackid is %0h, Expected ackid is %0h", temp_pc_trans_ins.ackid, exp_pkt_ackid))

  end //}

  if (pl_pc_common_mon_trans.num_outstanding_pkts[mon_type] > pl_pc_config.ackid_threshold)
  begin //{

    `uvm_error("SRIO_PL_PROTOCOL_CHECKER : PKT_ACKID_THRESHOLD_CHECK", $sformatf(" ACKID Threshold exceeded. ackid threshold is %0h, Number of packets outstanding is %0h", pl_pc_config.ackid_threshold, pl_pc_common_mon_trans.num_outstanding_pkts[mon_type]))

  end //}

endtask : pkt_ackid_check




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : pkt_vc_check
/// Description : This method stores the ackid of the received packet in appropriate vc_id
/// queue, if the packet belongs to a non-zero vc. It also triggers error if non-zero vc packet
/// is detected when multiple vc is not supported.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::pkt_vc_check();

  if (~pl_pc_env_config.multi_vc_support)
  begin //{

    ct_mode_vc_pkt = 0;

    if (temp_pc_trans_ins.vc)
    begin //{

      `uvm_error("SRIO_PL_PROTOCOL_CHECKER : PACKET_VC_CHECK", $sformatf(" Spec reference 5.4 / 5.8 / 5.9. VC bit set when multiple vc is not supported"))

    end //}

  end //}
  else
  begin //{

    if (temp_pc_trans_ins.vc && ((~pkt_ackid_err && ~pkt_crc_err) || (pl_pc_config.vc_ct_mode > 0)))
    begin //{

      if(pl_pc_env_config.vc_num_support == 1)
      begin //{

	if ((~pkt_ackid_err && ~pkt_crc_err) || (pl_pc_config.vc_ct_mode == 1))
	begin //{
	  pl_pc_common_mon_trans.pkt_vcid_q[~mon_type][1].push_back(temp_pc_trans_ins.ackid);
    	  ct_mode_vc_pkt = 1;
	end //}
    	else
    	begin //{
    	  ct_mode_vc_pkt = 0;
    	end //}

      end //}
      else if(pl_pc_env_config.vc_num_support == 2)
      begin //{

	if (~temp_pc_trans_ins.prio[1] && ((~pkt_ackid_err && ~pkt_crc_err) || (pl_pc_config.vc_ct_mode == 3)))
	begin //{
	  pl_pc_common_mon_trans.pkt_vcid_q[~mon_type][1].push_back(temp_pc_trans_ins.ackid);
    	  ct_mode_vc_pkt = 1;
	end //}
	else if (temp_pc_trans_ins.prio[1] && ((~pkt_ackid_err && ~pkt_crc_err) || (pl_pc_config.vc_ct_mode == 1 || pl_pc_config.vc_ct_mode == 3)))
	begin //{
	  pl_pc_common_mon_trans.pkt_vcid_q[~mon_type][5].push_back(temp_pc_trans_ins.ackid);
    	  ct_mode_vc_pkt = 1;
	end //}
    	else
    	begin //{
    	  ct_mode_vc_pkt = 0;
    	end //}

      end //}
      else if(pl_pc_env_config.vc_num_support == 4)
      begin //{

	if (temp_pc_trans_ins.prio == 2'b00 && ((~pkt_ackid_err && ~pkt_crc_err) || (pl_pc_config.vc_ct_mode == 7)))
	begin //{
	  pl_pc_common_mon_trans.pkt_vcid_q[~mon_type][1].push_back(temp_pc_trans_ins.ackid);
    	  ct_mode_vc_pkt = 1;
	end //}
	else if (temp_pc_trans_ins.prio == 2'b01 && ((~pkt_ackid_err && ~pkt_crc_err) || (pl_pc_config.vc_ct_mode == 7)))
	begin //{
	  pl_pc_common_mon_trans.pkt_vcid_q[~mon_type][3].push_back(temp_pc_trans_ins.ackid);
    	  ct_mode_vc_pkt = 1;
	end //}
	else if (temp_pc_trans_ins.prio == 2'b10 && ((~pkt_ackid_err && ~pkt_crc_err) || (pl_pc_config.vc_ct_mode == 3 || pl_pc_config.vc_ct_mode == 7)))
	begin //{
	  pl_pc_common_mon_trans.pkt_vcid_q[~mon_type][5].push_back(temp_pc_trans_ins.ackid);
    	  ct_mode_vc_pkt = 1;
	end //}
	else if (temp_pc_trans_ins.prio == 2'b11 && ((~pkt_ackid_err && ~pkt_crc_err) || (pl_pc_config.vc_ct_mode == 1 || pl_pc_config.vc_ct_mode == 3 || pl_pc_config.vc_ct_mode == 7)))
	begin //{
	  pl_pc_common_mon_trans.pkt_vcid_q[~mon_type][7].push_back(temp_pc_trans_ins.ackid);
    	  ct_mode_vc_pkt = 1;
	end //}
    	else
    	begin //{
    	  ct_mode_vc_pkt = 0;
    	end //}

      end //}
      else if(pl_pc_env_config.vc_num_support == 8)
      begin //{

	if (temp_pc_trans_ins.prio == 2'b00 && temp_pc_trans_ins.crf == 1'b0 && ((~pkt_ackid_err && ~pkt_crc_err) || (pl_pc_config.vc_ct_mode == 15)))
	begin //{
	  pl_pc_common_mon_trans.pkt_vcid_q[~mon_type][1].push_back(temp_pc_trans_ins.ackid);
    	  ct_mode_vc_pkt = 1;
	end //}
	else if (temp_pc_trans_ins.prio == 2'b00 && temp_pc_trans_ins.crf == 1'b1 && ((~pkt_ackid_err && ~pkt_crc_err) || (pl_pc_config.vc_ct_mode == 15)))
	begin //{
	  pl_pc_common_mon_trans.pkt_vcid_q[~mon_type][2].push_back(temp_pc_trans_ins.ackid);
    	  ct_mode_vc_pkt = 1;
	end //}
	else if (temp_pc_trans_ins.prio == 2'b01 && temp_pc_trans_ins.crf == 1'b0 && ((~pkt_ackid_err && ~pkt_crc_err) || (pl_pc_config.vc_ct_mode == 15)))
	begin //{
	  pl_pc_common_mon_trans.pkt_vcid_q[~mon_type][3].push_back(temp_pc_trans_ins.ackid);
    	  ct_mode_vc_pkt = 1;
	end //}
	else if (temp_pc_trans_ins.prio == 2'b01 && temp_pc_trans_ins.crf == 1'b1 && ((~pkt_ackid_err && ~pkt_crc_err) || (pl_pc_config.vc_ct_mode == 15)))
	begin //{
	  pl_pc_common_mon_trans.pkt_vcid_q[~mon_type][4].push_back(temp_pc_trans_ins.ackid);
    	  ct_mode_vc_pkt = 1;
	end //}
	else if (temp_pc_trans_ins.prio == 2'b10 && temp_pc_trans_ins.crf == 1'b0 && ((~pkt_ackid_err && ~pkt_crc_err) || (pl_pc_config.vc_ct_mode == 15 || pl_pc_config.vc_ct_mode == 7)))
	begin //{
	  pl_pc_common_mon_trans.pkt_vcid_q[~mon_type][5].push_back(temp_pc_trans_ins.ackid);
    	  ct_mode_vc_pkt = 1;
	end //}
	else if (temp_pc_trans_ins.prio == 2'b10 && temp_pc_trans_ins.crf == 1'b1 && ((~pkt_ackid_err && ~pkt_crc_err) || (pl_pc_config.vc_ct_mode == 15 || pl_pc_config.vc_ct_mode == 7)))
	begin //{
	  pl_pc_common_mon_trans.pkt_vcid_q[~mon_type][6].push_back(temp_pc_trans_ins.ackid);
    	  ct_mode_vc_pkt = 1;
	end //}
	else if (temp_pc_trans_ins.prio == 2'b11 && temp_pc_trans_ins.crf == 1'b0 && ((~pkt_ackid_err && ~pkt_crc_err) || (pl_pc_config.vc_ct_mode == 15 || pl_pc_config.vc_ct_mode == 7 || pl_pc_config.vc_ct_mode == 3)))
	begin //{
	  pl_pc_common_mon_trans.pkt_vcid_q[~mon_type][7].push_back(temp_pc_trans_ins.ackid);
    	  ct_mode_vc_pkt = 1;
	end //}
	else if (temp_pc_trans_ins.prio == 2'b11 && temp_pc_trans_ins.crf == 1'b1 && ((~pkt_ackid_err && ~pkt_crc_err) || (pl_pc_config.vc_ct_mode == 15 || pl_pc_config.vc_ct_mode == 7 || pl_pc_config.vc_ct_mode == 3 || pl_pc_config.vc_ct_mode == 1)))
	begin //{
	  pl_pc_common_mon_trans.pkt_vcid_q[~mon_type][8].push_back(temp_pc_trans_ins.ackid);
    	  ct_mode_vc_pkt = 1;
	end //}
    	else
    	begin //{
    	  ct_mode_vc_pkt = 0;
    	end //}

      end //}

    end //}
    else
    begin //{
      ct_mode_vc_pkt = 0;
    end //}

  end //}

endtask : pkt_vc_check




/////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : cntl_symbol_outstanding_stype0_ack_check
/// Description : This method checks if the next expected stype0 control symbol and the
/// received stype0 control symbols along with its param0, param1 values are same or not. There
/// could be a possibility for few control symbols like link response which could arrive 
/// anytime before its timer expires to arrive at a later time than its position in the outstanding
/// stype0 queue. In such cases, the queue will be reordered before performing the checks. Error
/// will be triggered if the received control symbol is not at all present in the outstanding queue.
/// Once the match is found, it clears that particular outstanding stype0 queue location
/// and its corresponding timer. For timestamp sequence, the check is performed at a different 
/// method/block. Hence the method is returned by just displaying an info message on timestamp 
/// sequence reception.
/////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::cntl_symbol_outstanding_stype0_ack_check();

 int delete_index1[$];
 int delete_index2[$];
 int ack_track;
 int step_thru;
  `uvm_info("SRIO_PL_PROTOCOL_CHECKER : CS_RECEIVED", $sformatf("stype0 is %0d, stype1 is %0d", temp_pc_trans_ins.stype0, temp_pc_trans_ins.stype1), UVM_LOW)

  if(pl_pc_trans.link_req_rst_cmd_cnt>0)
    pl_pc_trans.link_req_rst_cmd_cnt=0;

  if(pl_pc_trans.link_req_rst_port_cmd_cnt>0)
    pl_pc_trans.link_req_rst_port_cmd_cnt=0;

  if (pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type].size() == 0)
  begin //{

    // Added PNACC condition also below, because, before complete packet is received, there is a possibility
    // to generate PNACC or Retry acknowledgement, so that the transmitter can cancel the packet. In those
    // cases, error or warning will anyways be triggered, but error recovery will be monitored.
    if (temp_pc_trans_ins.stype0 == 3'b000 || temp_pc_trans_ins.stype0 == 3'b010)
    begin //{

      if (temp_pc_trans_ins.stype0 == 3'b010)
        update_error_detect_csr("RCVD_PNA_CS");

      if (~pl_pc_trans.oes_state && pl_pc_trans.port_initialized)
      begin //{
        pl_pc_trans.oes_state = 1;
        pl_pc_common_mon_trans.oes_state_detected[mon_type] = 1;
        pl_pc_common_mon_trans.ies_state_detected[~mon_type] = 1;
      end //}
    end //}

    if (temp_pc_trans_ins.stype0 == 3'b000)
      -> pl_pc_trans.invalid_packet_acc_cs;

    if (temp_pc_trans_ins.stype0 == 4'b0001 && pl_pc_common_mon_trans.packet_rx_in_progress[~mon_type])
    begin //{

      pl_pc_common_mon_trans.pl_outstanding_ackid[~mon_type][temp_pc_trans_ins.param0] = 0;

      if (pl_pc_common_mon_trans.pkt_in_progress_ack_id[~mon_type] != temp_pc_trans_ins.param0)
      begin //{

        -> pl_pc_trans.packet_ackID_corrupt;

        update_error_detect_csr("RCVD_ACK_CS_WITH_UNEXP_ACKID");

        `uvm_error("SRIO_PL_PROTOCOL_CHECKER : UNEXP_ACKID_IN_PKT_RETRY_WHILE_PKT_RX_IN_PROGRESS_CHECK", $sformatf(" Spec reference 5.7. Unexpected ackid value detected in packet retry control symbol which is received while a packet reception is in progress. Ackid value detected in the receiving packet is %0h, Received ackid value in retry control symbol is %0h", pl_pc_common_mon_trans.pkt_in_progress_ack_id[~mon_type], temp_pc_trans_ins.param0))

      end //}
      else
      begin //{
	`uvm_info("SRIO_PL_PROTOCOL_CHECKER : PKT_RERTY_WHEN_PKT_RX_IN_PROGRESS", $sformatf(" Recived a packet_retry control symbol when a packet is in progress. Ackid in control symbol is %0h, Ackid of the receiving packet is %0h", temp_pc_trans_ins.param0, pl_pc_common_mon_trans.pkt_in_progress_ack_id[~mon_type]), UVM_LOW)
      end //}

      pl_pc_trans.num_cg_bet_status_cs_cnt = 0;
      if(!pl_pc_trans.ors_state && !pl_pc_trans.oes_state)
       begin//{
        pl_pc_common_mon_trans.ackid_status[mon_type] = temp_pc_trans_ins.param0;
        pl_pc_trans.ors_state = 1;
        pl_pc_common_mon_trans.outstanding_rfr[~mon_type] = 1;
       end//}

    end //}
    else if (temp_pc_trans_ins.stype0 == 4'b0001 && ~pl_pc_common_mon_trans.packet_rx_in_progress[~mon_type])
    begin //{

      `uvm_warning("SRIO_PL_PROTOCOL_CHECKER : UNSOLICITED_PKT_RETRY_CHECK", $sformatf(" Spec reference 5.7. Unsolicited packet-retry control symbol with ackid %0d received. It could be for a cancelled packet.", temp_pc_trans_ins.param0))

      if(!pl_pc_trans.ors_state && !pl_pc_trans.oes_state)
       begin//{
        pl_pc_common_mon_trans.pl_outstanding_ackid[~mon_type][temp_pc_trans_ins.param0] = 0;
        pl_pc_common_mon_trans.ackid_status[mon_type] = temp_pc_trans_ins.param0;
        pl_pc_trans.ors_state = 1;
        pl_pc_common_mon_trans.outstanding_rfr[~mon_type] = 1;
       end//}

    end //}
    else if (temp_pc_trans_ins.stype0 == 4'b0010 && pl_pc_common_mon_trans.packet_rx_in_progress[~mon_type])
    begin //{

      `uvm_warning("SRIO_PL_PROTOCOL_CHECKER : UNSOLICITED_PNA_WHILE_PKT_RX_IN_PROGRESS_CHECK", $sformatf(" Spec reference 5.7. Unsolicited packet-not-accepted control symbol with cause field %0d received while a packet reception is in progress. Ackid value detected in the receiving packet is %0h", temp_pc_trans_ins.param1, pl_pc_common_mon_trans.pkt_in_progress_ack_id[~mon_type]))

    end //}
    else if (temp_pc_trans_ins.stype0 == 4'b0010 && ~pl_pc_common_mon_trans.packet_rx_in_progress[~mon_type])
    begin //{

      `uvm_warning("SRIO_PL_PROTOCOL_CHECKER : UNSOLICITED_PNA_PROGRESS_CHECK", $sformatf(" Spec reference 5.7. Unsolicited packet-not-accepted control symbol with cause field %0d received.", temp_pc_trans_ins.param1))

    end //}
    else if (temp_pc_trans_ins.stype0 != 4'b0011 || (pl_pc_env_config.srio_mode != SRIO_GEN30 && temp_pc_trans_ins.stype0 == 4'b0011 && pl_pc_trans.timestamp_master))
    begin //{
      update_error_detect_csr("UNSOL_ACK_CS");
      `uvm_error("SRIO_PL_PROTOCOL_CHECKER : UNSOLICITED_PKT_ACK_CHECK", $sformatf(" Spec reference 5.13.2.3.1. Unsolicited packet acknowledgement with stype0 %0h  and stype1 %0h received.", temp_pc_trans_ins.stype0, temp_pc_trans_ins.stype1))
    end //}
    else
    begin //{

      if (pl_pc_env_config.srio_mode != SRIO_GEN30)
        `uvm_info("SRIO_PL_PROTOCOL_CHECKER : TIMESTAMP_SEQ_RECEIVED", $sformatf("start flag is %0d, end flag is %0d", temp_pc_trans_ins.param0[7], temp_pc_trans_ins.param0[8]), UVM_LOW)
      else
        `uvm_info("SRIO_PL_PROTOCOL_CHECKER : TIMESTAMP_SEQ_RECEIVED", $sformatf("sequence number is %0d", temp_pc_trans_ins.param0[3:4]), UVM_LOW)

    end //}

    return;

  end //}

    if (temp_pc_trans_ins.stype0 == 4'b0011 && ~pl_pc_trans.timestamp_master)
    begin //{

      if (pl_pc_env_config.srio_mode != SRIO_GEN30)
        `uvm_info("SRIO_PL_PROTOCOL_CHECKER : TIMESTAMP_SEQ_RECEIVED", $sformatf("start flag is %0d, end flag is %0d", temp_pc_trans_ins.param0[7], temp_pc_trans_ins.param0[8]), UVM_LOW)
      else
        `uvm_info("SRIO_PL_PROTOCOL_CHECKER : TIMESTAMP_SEQ_RECEIVED", $sformatf("sequence number is %0d", temp_pc_trans_ins.param0[3:4]), UVM_LOW)

      return;

    end //}

  if (temp_pc_trans_ins.stype0 == 3'b110)
  begin //{
    pl_pc_common_mon_trans.ackid_status[mon_type] = temp_pc_trans_ins.param0;
    ackid_min_in_q=temp_pc_trans_ins.param0;
    ackid_max_in_q=temp_pc_trans_ins.param0;
    ackid_rcvd_s0_6=temp_pc_trans_ins.param0;
    ack_track=0;
    step_thru=0;
    for(int i=0;i<pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type].size();i++)
     begin//{
	if (pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type][i].stype0 == 3'b000)
         begin//{
	  temp_pkt_ack_trans = new pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type][i];
          pl_pc_common_mon_trans.ackid_status[mon_type] = temp_pkt_ack_trans.param0;
          pkt_ack_stype0.push_back(temp_pkt_ack_trans);
          if(temp_pkt_ack_trans.param0==ackid_rcvd_s0_6)
           break;
         end//}
	if (pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type][i].stype0 != 3'b000)
         break;
     end //}  
    for(int i=0;i<pkt_ack_stype0.size();i++)
     begin//{
            temp_pkt_ack_trans = new pkt_ack_stype0[i];
            ack_track=0; 
	    temp_pkt_ack_trans = new pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type][ack_track];
	    pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type].delete(ack_track);
	    pl_pc_common_mon_trans.pkt_ack_timer_stype0[mon_type].delete(ack_track);
            pl_pc_common_mon_trans.pl_outstanding_ackid[~mon_type][temp_pkt_ack_trans.param0] = 0;
            pl_pc_common_mon_trans.num_outstanding_pkts[~mon_type]--;
     end//}
/*    while(1)
     begin//{
      //`uvm_info("PRTCLCHKR",$sformatf("ackid_min_in_q:%0d ackid_max_in_q:%0d",ackid_min_in_q,ackid_max_in_q),UVM_LOW)
      step_thru++;
      if(step_thru>pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type].size())
       break;
      if(pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type].size()!=0)
       begin//{
	if (pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type][ack_track].stype0 == 3'b000)
	begin //{
	  temp_pkt_ack_trans = new pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type][ack_track];
          if(temp_pkt_ack_trans.param0<ackid_min_in_q)
           ackid_min_in_q=temp_pkt_ack_trans.param0;
          if(temp_pkt_ack_trans.param0>ackid_max_in_q)
           ackid_max_in_q=temp_pkt_ack_trans.param0;
          if(temp_pkt_ack_trans.param0<ackid_rcvd_s0_6)
           begin//{
	    pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type].delete(ack_track);
	    pl_pc_common_mon_trans.pkt_ack_timer_stype0[mon_type].delete(ack_track);
            pl_pc_common_mon_trans.pl_outstanding_ackid[~mon_type][temp_pkt_ack_trans.param0] = 0;
            pl_pc_common_mon_trans.num_outstanding_pkts[~mon_type]--;
           end//}
          if(temp_pkt_ack_trans.param0>ackid_rcvd_s0_6 || pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type].size()==0 || pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type][ack_track].stype0 == 3'b110)
           begin//{
            break;
           end//}
          end//}
         else if (pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type][ack_track].stype0 == 3'b010)
	  begin //{
	    temp_pkt_ack_trans = new pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type][ack_track];
            ackid_max_in_q=temp_pkt_ack_trans.param0;
            break;
          end//}
         else
          ack_track=ack_track+1;
       end//}
      else
       break;

      end//}
*/
    if (pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type][0].stype0 != 3'b110)
    begin //{

      temp_outst_ack_q_size = pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type].size();

      for (int chk_lresp=0; chk_lresp<temp_outst_ack_q_size; chk_lresp++)
      begin //{
	if (pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type][chk_lresp].stype0 == 3'b110)
	begin //{
	  temp_pkt_ack_trans = new pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type][chk_lresp];
	  pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type].delete(chk_lresp);
	  pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type].push_front(temp_pkt_ack_trans);
	  pl_pc_common_mon_trans.pkt_ack_timer_stype0[mon_type].push_front(pl_pc_common_mon_trans.pkt_ack_timer_stype0[mon_type][chk_lresp]);
	  pl_pc_common_mon_trans.pkt_ack_timer_stype0[mon_type].delete(chk_lresp+1);
	  scheduled_link_resp_found = 1;
	  break;
	end //}
      end //}

      if (scheduled_link_resp_found)
	scheduled_link_resp_found = 0;
      else
      begin //{

        update_error_detect_csr("PROTOCOL_ERROR");

        `uvm_error("SRIO_PL_PROTOCOL_CHECKER : LINK_RESP_WITHOUT_LINK_REQ_CHECK", $sformatf(" Spec reference 5.7. Unexpected link response detected when no link request is outstanding"))

      end //}

    end //}

  end //}

  if (temp_pc_trans_ins.stype0 == 4'b0011 && pl_pc_env_config.srio_mode != SRIO_GEN30)
  begin //{

    if (pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type][0].stype0 != 4'b0011)
    begin //{

      temp_outst_ack_q_size = pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type].size();

      for (int chk_lresp=0; chk_lresp<temp_outst_ack_q_size; chk_lresp++)
      begin //{
	if (pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type][chk_lresp].stype0 == 4'b0011)
	begin //{
	  temp_pkt_ack_trans = new pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type][chk_lresp];
	  pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type].delete(chk_lresp);
	  pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type].push_front(temp_pkt_ack_trans);
	  pl_pc_common_mon_trans.pkt_ack_timer_stype0[mon_type].push_front(pl_pc_common_mon_trans.pkt_ack_timer_stype0[mon_type][chk_lresp]);
	  pl_pc_common_mon_trans.pkt_ack_timer_stype0[mon_type].delete(chk_lresp+1);
	  scheduled_loop_resp_found = 1;
	  break;
	end //}
      end //}

      if (scheduled_loop_resp_found)
	scheduled_loop_resp_found = 0;
      else
      begin //{

        if (~pl_pc_trans.oes_state && pl_pc_trans.port_initialized)
        begin //{
          pl_pc_trans.oes_state = 1;
          pl_pc_common_mon_trans.oes_state_detected[mon_type] = 1;
        end //}
        update_error_detect_csr("PROTOCOL_ERROR");

        `uvm_error("SRIO_PL_PROTOCOL_CHECKER : LOOP_RESP_WITHOUT_LOOP_REQ_CHECK", $sformatf(" Spec reference 6.5.3.5. Unexpected loop response detected when no loop request is outstanding"))

      end //}

    end //}

  end //}
  else if (temp_pc_trans_ins.stype0 == 4'b1011 && pl_pc_env_config.srio_mode == SRIO_GEN30)
  begin //{

    if (pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type][0].stype0 != 4'b1011)
    begin //{

      temp_outst_ack_q_size = pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type].size();

      for (int chk_lresp=0; chk_lresp<temp_outst_ack_q_size; chk_lresp++)
      begin //{
	if (pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type][chk_lresp].stype0 == 4'b1011)
	begin //{
	  temp_pkt_ack_trans = new pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type][chk_lresp];
	  pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type].delete(chk_lresp);
	  pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type].push_front(temp_pkt_ack_trans);
	  pl_pc_common_mon_trans.pkt_ack_timer_stype0[mon_type].push_front(pl_pc_common_mon_trans.pkt_ack_timer_stype0[mon_type][chk_lresp]);
	  pl_pc_common_mon_trans.pkt_ack_timer_stype0[mon_type].delete(chk_lresp+1);
	  scheduled_loop_resp_found = 1;
	  break;
	end //}
      end //}

      if (scheduled_loop_resp_found)
	scheduled_loop_resp_found = 0;
      else
      begin //{

        if (~pl_pc_trans.oes_state && pl_pc_trans.port_initialized)
        begin //{
          pl_pc_trans.oes_state = 1;
          pl_pc_common_mon_trans.oes_state_detected[mon_type] = 1;
        end //}
        update_error_detect_csr("PROTOCOL_ERROR");

        `uvm_error("SRIO_PL_PROTOCOL_CHECKER : LOOP_RESP_WITHOUT_LOOP_REQ_CHECK", $sformatf(" Spec reference 6.5.3.5. Unexpected loop response detected when no loop request is outstanding"))

      end //}

    end //}

  end //}

  if (temp_pc_trans_ins.stype0 == 3'b000)
  begin //{

    if (pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type][0].stype0 == 3'b110 || (pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type][0].stype0 == 4'b0011 && pl_pc_env_config.srio_mode != SRIO_GEN30) || (pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type][0].stype0 == 4'b1011 && pl_pc_env_config.srio_mode == SRIO_GEN30))
    begin //{

      temp_outst_ack_q_size = pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type].size();

      for (int chk_pa=0; chk_pa<temp_outst_ack_q_size; chk_pa++)
      begin //{
	if (pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type][chk_pa].stype0 == 3'b000)
	begin //{
	  temp_pkt_ack_trans = new pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type][chk_pa];
	  pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type].delete(chk_pa);
	  pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type].push_front(temp_pkt_ack_trans);
	  pl_pc_common_mon_trans.pkt_ack_timer_stype0[mon_type].push_front(pl_pc_common_mon_trans.pkt_ack_timer_stype0[mon_type][chk_pa]);
	  pl_pc_common_mon_trans.pkt_ack_timer_stype0[mon_type].delete(chk_pa+1);
	  break;
	end //}
      end //}

    end //}

  end //}

  if (temp_pc_trans_ins.stype0 == 4'b0010)
  begin //{
    if (pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type][0].stype0 != 4'b0010)
    begin //{
      temp_outst_ack_q_size = pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type].size();
      for (int chk_pna=0; chk_pna<temp_outst_ack_q_size; chk_pna++)
      begin //{
	if (pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type][chk_pna].stype0 == 4'b0010 /*&& pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type][chk_pna].param1 != 12'h001 && pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type][chk_pna].param1 != 12'h100*/)
	begin //{
	  temp_pkt_ack_trans = new pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type][chk_pna];
	  pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type].delete(chk_pna);
	  pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type].push_front(temp_pkt_ack_trans);
	  pl_pc_common_mon_trans.pkt_ack_timer_stype0[mon_type].push_front(pl_pc_common_mon_trans.pkt_ack_timer_stype0[mon_type][chk_pna]);
	  pl_pc_common_mon_trans.pkt_ack_timer_stype0[mon_type].delete(chk_pna+1);
	  break;
	end //}
      end //}
    end //}
  end //}
  exp_comp_trans = new pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type].pop_front();

  void'(pl_pc_common_mon_trans.pkt_ack_timer_stype0[mon_type].pop_front());

  //$display($time, " Expeted CS values are: stype0 is %0d, stype1 is %0d", exp_comp_trans.stype0, exp_comp_trans.stype1);

  if (exp_comp_trans.stype0 == 3'b000 && (temp_pc_trans_ins.stype0 != 3'b000 && temp_pc_trans_ins.stype0 != 3'b001))
  begin //{

    if (temp_pc_trans_ins.stype0 == 3'b010)
    begin //{

      update_error_detect_csr("RCVD_PNA_CS");

      check_multiple_ack_support();

      if (pl_pc_pna_ackid_support)
      begin //{

        check_for_pna = 1;

        clear_pending_acknowledgements();

	// check_for_pna should have been cleared if pna is found in the
	// outstanding_pkt_ack_stype0 queue.

	if (check_for_pna)
	begin //{

	  check_for_pna = 0;

    	  pl_pc_common_mon_trans.ackid_status[mon_type] = exp_cs_ackid;

	  // Though an unexpected PNACC received, report error / warning
	  // and then enter into OES state to check the recovery.

          if (~pl_pc_trans.oes_state && pl_pc_trans.port_initialized)
          begin //{

            if (~pl_pc_common_mon_trans.update_exp_pkt_ackid[~mon_type])
            begin //{
              pl_pc_common_mon_trans.update_exp_pkt_ackid[~mon_type] = 1;
              pl_pc_common_mon_trans.updated_exp_pkt_ackid_val[~mon_type] = exp_cs_ackid;
            end //}

            pl_pc_trans.oes_state = 1;
            pl_pc_common_mon_trans.oes_state_detected[mon_type] = 1;

          end //}

          if (~pl_pc_env_config.multi_vc_support || (pl_pc_env_config.multi_vc_support && temp_pc_trans_ins.param1 !== 'b00110))
          begin //{

            if (temp_pc_trans_ins.stype0 == 3'b010)
              -> pl_pc_trans.invalid_packet_na_cs;

            update_error_detect_csr("PROTOCOL_ERROR");

            `uvm_error("SRIO_PL_PROTOCOL_CHECKER : UNEXP_STYPE0_CS_FOR_PACC_CHECK", $sformatf(" Spec reference 5.13.2.3.1. Unexpected packet acknowledgement with stype0 %0h received. Expecting Packet accepted control symbol.", temp_pc_trans_ins.stype0))

          end //}

        end //}
	else
	begin //{

    	  `uvm_info("SRIO_PL_PROTOCOL_CHECKER : PACKET_ACK_RECEIVED", $sformatf(" Packet not accepted control symbol with cause field %0h received", temp_pc_trans_ins.param1), UVM_MEDIUM)

    	  if (~pl_pc_trans.oes_state && pl_pc_trans.port_initialized)
    	  begin //{
            if (~pl_pc_common_mon_trans.update_exp_pkt_ackid[~mon_type])
            begin //{
              pl_pc_common_mon_trans.update_exp_pkt_ackid[~mon_type] = 1;
              pl_pc_common_mon_trans.updated_exp_pkt_ackid_val[~mon_type] = exp_cs_ackid;
            end //}
    	    pl_pc_trans.oes_state = 1;
    	    pl_pc_common_mon_trans.oes_state_detected[mon_type] = 1;
    	  end //}

    	  pl_pc_common_mon_trans.ackid_status[mon_type] = exp_comp_trans.param0;

    	  if (exp_comp_trans.param0 != temp_pc_trans_ins.param0)
    	  begin //{

      	    `uvm_error("SRIO_PL_PROTOCOL_CHECKER : UNEXP_ACKID_STATUS_IN_PNA_CHECK", $sformatf(" Spec reference 5.13.2.3.1. Unexpected ackid_status detected in the received Packet-not-accepted control symbol. Expected ackid_status value is %0h, Received ackid_status value is %0h", exp_comp_trans.param0, temp_pc_trans_ins.param0))

    	  end //}

    	  if (exp_comp_trans.param1 != temp_pc_trans_ins.param1)
    	  begin //{

    	    `uvm_error("SRIO_PL_PROTOCOL_CHECKER : UNEXP_CAUSE_IN_PNA_CHECK", $sformatf(" Spec reference 5.7. Unexpected cause field detected in packet not accepted control symbol. Expected cause field is %0d, Received cause field is %0d", exp_comp_trans.param1, temp_pc_trans_ins.param1))

    	  end //}

    	  if (pl_pc_env_config.multi_vc_support)
    	  begin //{
    	    clear_vc_q_on_pkt_retry_or_pna();
    	  end //}

	end //}

	return;

      end //}

	// Though an unexpected PNACC received, report error / warning
	// and then enter into OES state to check the recovery.

      if (~pl_pc_trans.oes_state && pl_pc_trans.port_initialized)
      begin //{

	if (~pl_pc_common_mon_trans.update_exp_pkt_ackid[~mon_type])
	begin //{
	  pl_pc_common_mon_trans.update_exp_pkt_ackid[~mon_type] = 1;
	  pl_pc_common_mon_trans.updated_exp_pkt_ackid_val[~mon_type] = exp_comp_trans.param0;
	end //}

        pl_pc_trans.oes_state = 1;
        pl_pc_common_mon_trans.oes_state_detected[mon_type] = 1;

      end //}

    end //}

    if (~pl_pc_env_config.multi_vc_support || (pl_pc_env_config.multi_vc_support && temp_pc_trans_ins.param1 !== 'b00110))
    begin //{

      if (temp_pc_trans_ins.stype0 == 3'b010)
        -> pl_pc_trans.invalid_packet_na_cs;

      update_error_detect_csr("PROTOCOL_ERROR");

      `uvm_error("SRIO_PL_PROTOCOL_CHECKER : UNEXP_STYPE0_CS_FOR_PACC_CHECK", $sformatf(" Spec reference 5.13.2.3.1. Unexpected packet acknowledgement with stype0 %0h received. Expecting Packet accepted control symbol.", temp_pc_trans_ins.stype0))

    end //}

  end //}
  else if (exp_comp_trans.stype0 == 3'b000 && temp_pc_trans_ins.stype0 == 3'b000)
  begin //{

    check_multiple_ack_support();

    if (pl_pc_multiple_ack_support)
    begin //{
      clear_pending_acknowledgements();
    end //}

    if (exp_comp_trans.param0 != temp_pc_trans_ins.param0)
    begin //{

      if (~pl_pc_trans.oes_state && pl_pc_trans.port_initialized)
      begin //{
        pl_pc_trans.oes_state = 1;
        pl_pc_common_mon_trans.oes_state_detected[mon_type] = 1;
      end //}

      -> pl_pc_trans.packet_ackID_corrupt;

      update_error_detect_csr("RCVD_ACK_CS_WITH_UNEXP_ACKID");

      `uvm_error("SRIO_PL_PROTOCOL_CHECKER : UNEXP_ACKID_IN_PKT_ACC_CHECK", $sformatf(" Spec reference 5.7. Unexpected ackid value detected in packet accepted control symbol. Expected ackid value is %0h, Received ackid value is %0h", exp_comp_trans.param0, temp_pc_trans_ins.param0))

    end //}
    else
    begin //{

      `uvm_info("SRIO_PL_PROTOCOL_CHECKER : PACKET_ACK_RECEIVED", $sformatf(" Packet accepted control symbol with ackid %0h received", temp_pc_trans_ins.param0), UVM_MEDIUM)

      pl_pc_trans.num_cg_bet_status_cs_cnt = 0;

      if (temp_pc_trans_ins.param0 == 63 && pl_pc_trans.idle_selected && pl_pc_env_config.srio_mode != SRIO_GEN30)
        exp_cs_ackid = 0;
      else if (temp_pc_trans_ins.param0 == 31 && ~pl_pc_trans.idle_selected && pl_pc_env_config.srio_mode != SRIO_GEN30)
        exp_cs_ackid = 0;
      else if (exp_comp_trans.param0 == 4095 && pl_pc_env_config.srio_mode == SRIO_GEN30)
        exp_cs_ackid = 0;
      else
        exp_cs_ackid = temp_pc_trans_ins.param0+1;

      pl_pc_common_mon_trans.pl_outstanding_ackid[~mon_type][temp_pc_trans_ins.param0] = 0;

      pl_pc_common_mon_trans.num_outstanding_pkts[~mon_type]--;

      if (exp_comp_trans.param0 == 63 && pl_pc_trans.idle_selected && pl_pc_env_config.srio_mode != SRIO_GEN30)
        pl_pc_common_mon_trans.ackid_status[mon_type] = 0;
      else if (exp_comp_trans.param0 == 31 && ~pl_pc_trans.idle_selected && pl_pc_env_config.srio_mode != SRIO_GEN30)
        pl_pc_common_mon_trans.ackid_status[mon_type] = 0;
      else if (exp_comp_trans.param0 == 4095 && pl_pc_env_config.srio_mode == SRIO_GEN30)
        pl_pc_common_mon_trans.ackid_status[mon_type] = 0;
      else
        pl_pc_common_mon_trans.ackid_status[mon_type] = exp_comp_trans.param0+1;

      if (pl_pc_env_config.multi_vc_support)
      begin //{
	pop_vc_q_on_pkt_acc(temp_pc_trans_ins);
      end //}

      if (pl_pc_env_config.srio_mode != SRIO_GEN30 && pl_pc_env_config.spec_support != V30)
        update_inbound_ackid_outstanding_ackid_reg();
      else
        update_gen3_inbound_ackid_outstanding_ackid_reg();

    end //}


  end //}
  else if (exp_comp_trans.stype0 == 3'b000 && temp_pc_trans_ins.stype0 == 3'b001)
  begin //{

    pl_pc_common_mon_trans.num_outstanding_pkts[~mon_type]--;
    check_multiple_ack_support();

    if (pl_pc_multiple_ack_support)
    begin //{
      clear_pending_acknowledgements();
    end //}

    pl_pc_common_mon_trans.pl_outstanding_ackid[~mon_type][temp_pc_trans_ins.param0] = 0;

    if (exp_cs_ackid != temp_pc_trans_ins.param0)
    begin //{
      if (~pl_pc_trans.oes_state && pl_pc_trans.port_initialized)
      begin //{
        pl_pc_trans.oes_state = 1;
        pl_pc_common_mon_trans.oes_state_detected[mon_type] = 1;
      end //}

      -> pl_pc_trans.packet_ackID_corrupt;

      update_error_detect_csr("RCVD_ACK_CS_WITH_UNEXP_ACKID");

      `uvm_error("SRIO_PL_PROTOCOL_CHECKER : UNEXP_ACKID_IN_PKT_RETRY_CHECK", $sformatf(" Spec reference 5.7. Unexpected ackid value detected in packet retry control symbol. Expected ackid value is %0h, Received ackid value is %0h", exp_cs_ackid, temp_pc_trans_ins.param0))

    end //}
    else
    begin //{

      if (~pl_pc_env_config.multi_vc_support)
        `uvm_info("SRIO_PL_PROTOCOL_CHECKER : PACKET_ACK_RECEIVED", $sformatf(" Packet retry control symbol with ackid %0h received", temp_pc_trans_ins.param0), UVM_MEDIUM)

      pl_pc_trans.num_cg_bet_status_cs_cnt = 0;

    end //}

    if (pl_pc_env_config.multi_vc_support)
    begin //{

      clear_vc_q_on_pkt_retry_or_pna();

      if (~pl_pc_trans.ies_state && pl_pc_trans.link_initialized)
      begin //{
        pl_pc_trans.ies_state = 1;
        pl_pc_trans.ies_cause_value = 31;
          //$display($time, " 11. Vaidhy : ies_state set here");
      end //}

      `uvm_error("SRIO_PL_PROTOCOL_CHECKER : PKT_RETRY_IN_MULTI_VC_CHECK", $sformatf(" Spec reference 5.9.1.1. Packet retry control symbol received when operating in multi vc mode."))

    end //}

    //exp_pkt_ackid = temp_pc_trans_ins.param0;
    pl_pc_common_mon_trans.ackid_status[mon_type] = temp_pc_trans_ins.param0;

    if (pl_pc_env_config.srio_mode != SRIO_GEN30 && pl_pc_env_config.spec_support != V30)
      update_inbound_ackid_outstanding_ackid_reg();
    else
      update_gen3_inbound_ackid_outstanding_ackid_reg();

    arr_index = temp_pc_trans_ins.param0;

    void'(pl_pc_common_mon_trans.pl_outstanding_ackid[~mon_type].last(last_arr_index));

    // if a packet retry is received, all the outstanding ackid are cleared as they
    // have to be retransmitted again. Below logic does that. When the last entry of
    // the array is reached, then it is wrapped around and performs the same logic.
    // TODO: This logic has to be validated.
    if (arr_index == last_arr_index)
    begin //{

      // If the last_arr_index is retried, the while loop below will miss to check
      // the pl_outstanding_ackid from '0'. Hence it is checked first before moving
      // to the while loop below.
      $display($time, " 1. Checking pl_outstanding_ackid[%0d][%0d] after retry control symbol received.", ~mon_type, arr_index);

      void'(pl_pc_common_mon_trans.pl_outstanding_ackid[~mon_type].first(arr_index));

      if (pl_pc_common_mon_trans.pl_outstanding_ackid[~mon_type][arr_index] == 1)
        pl_pc_common_mon_trans.pl_outstanding_ackid[~mon_type][arr_index] = 0;

    end //}

    while (pl_pc_common_mon_trans.pl_outstanding_ackid[~mon_type].next(arr_index))
    begin //{

      $display($time, " 2. Checking pl_outstanding_ackid[%0d][%0d] after retry control symbol received.", ~mon_type, arr_index);

      if (pl_pc_common_mon_trans.pl_outstanding_ackid[~mon_type][arr_index] == 1)
    	pl_pc_common_mon_trans.pl_outstanding_ackid[~mon_type][arr_index] = 0;
      else
    	break;

      if (arr_index == last_arr_index)
      begin //{

	void'(pl_pc_common_mon_trans.pl_outstanding_ackid[~mon_type].first(arr_index));

        if (pl_pc_common_mon_trans.pl_outstanding_ackid[~mon_type][arr_index] == 1)
          pl_pc_common_mon_trans.pl_outstanding_ackid[~mon_type][arr_index] = 0;
        else
    	  break;

      end //}

    end //}

    // When retry is received, all scheduled acknowledgements other than link-response
    // has to be cleared. Mostly, only packet-accepepted would be in the queue.
    temp_loc = 0;

    while (pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type].size() > 0)
    begin //{

      if (pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type][temp_loc].stype0 != 3'b110)
      begin //{

        pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type].delete(temp_loc);
        pl_pc_common_mon_trans.pkt_ack_timer_stype0[mon_type].delete(temp_loc);
        pl_pc_common_mon_trans.num_outstanding_pkts[~mon_type]--;

      end //}
      else
        temp_loc++; // Increment only if link response is encountered.

    end //}

    if(!pl_pc_trans.ors_state && !pl_pc_trans.oes_state)
     begin//{
      pl_pc_trans.ors_state = 1;
      pl_pc_common_mon_trans.outstanding_rfr[~mon_type] = 1;
     end //}

  end //}
  else if (exp_comp_trans.stype0 == 3'b010 && temp_pc_trans_ins.stype0 == 3'b010)
  begin //{

    update_error_detect_csr("RCVD_PNA_CS");

    `uvm_info("SRIO_PL_PROTOCOL_CHECKER : PACKET_ACK_RECEIVED", $sformatf(" Packet not accepted control symbol with cause field %0h received", temp_pc_trans_ins.param1), UVM_MEDIUM)

    if (~pl_pc_trans.oes_state && pl_pc_trans.port_initialized)
    begin //{
      pl_pc_trans.oes_state = 1;
      pl_pc_common_mon_trans.oes_state_detected[mon_type] = 1;
    end //}

    check_multiple_ack_support();

    if (pl_pc_pna_ackid_support)
    begin //{

      if (exp_comp_trans.param0 != temp_pc_trans_ins.param0)
      begin //{

        update_error_detect_csr("RCVD_ACK_CS_WITH_UNEXP_ACKID");

        `uvm_error("SRIO_PL_PROTOCOL_CHECKER : UNEXP_ACKID_STATUS_IN_PNA_CHECK", $sformatf(" Spec reference 5.13.2.3.1. Unexpected ackid_status detected in the received Packet-not-accepted control symbol. Expected ackid_status value is %0h, Received ackid_status value is %0h", exp_comp_trans.param0, temp_pc_trans_ins.param0))

      end //}

    end //}

    if (exp_comp_trans.param1 != temp_pc_trans_ins.param1)
    begin //{

      `uvm_error("SRIO_PL_PROTOCOL_CHECKER : UNEXP_CAUSE_IN_PNA_CHECK", $sformatf(" Spec reference 5.7. Unexpected cause field detected in packet not accepted control symbol. Expected cause field is %0d, Received cause field is %0d", exp_comp_trans.param1, temp_pc_trans_ins.param1))

    end //}

    if (pl_pc_env_config.multi_vc_support)
    begin //{
      clear_vc_q_on_pkt_retry_or_pna();
    end //}

  end //}
  else if (exp_comp_trans.stype0 == 3'b110 && temp_pc_trans_ins.stype0 == 3'b110)
  begin //{

    `uvm_info("SRIO_PL_PROTOCOL_CHECKER : PACKET_ACK_RECEIVED", $sformatf(" Link response control symbol received"), UVM_MEDIUM)

    if (pl_pc_trans.oes_state)
    begin //{
      pl_pc_trans.oes_state = 0;
      pl_pc_common_mon_trans.oes_state_detected[mon_type] = 0;
    end //}

    if (exp_comp_trans.param1 != temp_pc_trans_ins.param1)
    begin //{

      `uvm_error("SRIO_PL_PROTOCOL_CHECKER : UNEXP_PORT_STATUS_IN_LINK_RESP_CHECK", $sformatf(" Spec reference 5.7. Unexpected port status field detected in link response control symbol. Expected port status field is %0b, Received port status field is %0b", exp_comp_trans.param1, temp_pc_trans_ins.param1))

    end //}

    if (pl_pc_common_mon_trans.outstanding_link_req[~mon_type])
    begin //{

      pl_pc_common_mon_trans.outstanding_link_req[~mon_type] = 0;

      update_link_maint_resp_reg();

    end //}
    else
    begin //{

      if (~pl_pc_trans.oes_state && pl_pc_trans.port_initialized)
      begin //{
        pl_pc_trans.oes_state = 1;
        pl_pc_common_mon_trans.oes_state_detected[mon_type] = 1;
      end //}

      update_error_detect_csr("PROTOCOL_ERROR");

      `uvm_error("SRIO_PL_PROTOCOL_CHECKER : PKT_ACK_CHECK", $sformatf(" Spec reference 5.7. Unexpected link response detected when no link request is outstanding"))

    end //}


  end //}
  else if (exp_comp_trans.stype0 == 3'b010 && (exp_comp_trans.stype0 != temp_pc_trans_ins.stype0))
  begin //{

    if (temp_pc_trans_ins.stype0 == 3'b000)
      -> pl_pc_trans.invalid_packet_acc_cs;

    update_error_detect_csr("PROTOCOL_ERROR");

    `uvm_error("SRIO_PL_PROTOCOL_CHECKER : UNEXP_STYPE0_CS_FOR_PNA_CHECK", $sformatf(" Spec reference 5.13.2.3.1. Unexpected packet acknowledgement with stype0 %0h received. Expecting a packet not accepted control symbol with cause field %0d", temp_pc_trans_ins.stype0, exp_comp_trans.param1))

  end //}
  else if (exp_comp_trans.stype0 == 3'b110 && (exp_comp_trans.stype0 != temp_pc_trans_ins.stype0))
  begin //{

    if (temp_pc_trans_ins.stype0 == 3'b000)
      -> pl_pc_trans.invalid_packet_acc_cs;
    else if (temp_pc_trans_ins.stype0 == 3'b010)
      -> pl_pc_trans.invalid_packet_na_cs;

    update_error_detect_csr("PROTOCOL_ERROR");

    `uvm_error("SRIO_PL_PROTOCOL_CHECKER : UNEXP_STYPE0_CS_FOR_LINK_RESP_CHECK", $sformatf(" Spec reference 5.13.2.3.1. Unexpected packet acknowledgement with stype0 %0h received. Expecting a link response control symbol", temp_pc_trans_ins.stype0))

  end //}
  else if ((pl_pc_env_config.srio_mode != SRIO_GEN30 && exp_comp_trans.stype0 == 4'b0011 && temp_pc_trans_ins.stype0 == 4'b0011) || (pl_pc_env_config.srio_mode == SRIO_GEN30 && exp_comp_trans.stype0 == 4'b1011 && temp_pc_trans_ins.stype0 == 4'b1011))
  begin //{

    `uvm_info("SRIO_PL_PROTOCOL_CHECKER : PACKET_ACK_RECEIVED", $sformatf(" Loop response control symbol received"), UVM_MEDIUM)

    if (pl_pc_common_mon_trans.outstanding_loop_req[~mon_type])
    begin //{

      pl_pc_common_mon_trans.outstanding_loop_req[~mon_type] = 0;

    end //}
    else
    begin //{

      if (~pl_pc_trans.oes_state && pl_pc_trans.port_initialized)
      begin //{
        pl_pc_trans.oes_state = 1;
        pl_pc_common_mon_trans.oes_state_detected[mon_type] = 1;
      end //}
      update_error_detect_csr("PROTOCOL_ERROR");

      `uvm_error("SRIO_PL_PROTOCOL_CHECKER : LOOP_RESP_WITHOUT_LOOP_REQ_CHECK", $sformatf(" Spec reference 5.7. Unexpected loop response detected when no loop request is outstanding"))

    end //}

  end //}
  else if (((pl_pc_env_config.srio_mode != SRIO_GEN30 && exp_comp_trans.stype0 == 4'b0011) || (pl_pc_env_config.srio_mode == SRIO_GEN30 && exp_comp_trans.stype0 == 4'b1011)) && (exp_comp_trans.stype0 != temp_pc_trans_ins.stype0))
  begin //{

    if (temp_pc_trans_ins.stype0 == 3'b000)
      -> pl_pc_trans.invalid_packet_acc_cs;
    else if (temp_pc_trans_ins.stype0 == 3'b010)
      -> pl_pc_trans.invalid_packet_na_cs;

    update_error_detect_csr("PROTOCOL_ERROR");

    `uvm_error("SRIO_PL_PROTOCOL_CHECKER : UNEXP_STYPE0_CS_FOR_LOOP_RESP_CHECK", $sformatf(" Spec reference 5.13.2.3.1. Unexpected packet acknowledgement with stype0 %0h received. Expecting a loop response control symbol", temp_pc_trans_ins.stype0))

  end //}

endtask : cntl_symbol_outstanding_stype0_ack_check




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : cntl_symbol_outstanding_stype1_ack_check
/// Description : This method checks if the next expected stype1 control symbol and the
/// received stype1 control symbols along with its cmd value are same or not. There
/// could be a possibility that scheduled control symbols arrive in a different order than its
/// position in the outstanding stype1 queue. In such cases, the queue will be reordered before
/// performing the checks. Error will be triggered if the received control symbol is not at all
/// present in the outstanding queue.
/// If the match is found, it clears that particular outstanding stype1 queue location
/// and its corresponding timer.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::cntl_symbol_outstanding_stype1_ack_check();

  `uvm_info("SRIO_PL_PROTOCOL_CHECKER : CS_RECEIVED", $sformatf("stype0 is %0d, stype1 is %0d", temp_pc_trans_ins.stype0, temp_pc_trans_ins.stype1), UVM_LOW)

  if (pl_pc_common_mon_trans.outstanding_pkt_ack_stype1[mon_type].size() == 0)
  begin //{

    if (temp_pc_trans_ins.stype1 != 3'b100 || (temp_pc_trans_ins.stype1 == 3'b100 && temp_pc_trans_ins.cmd != 3'b011))
    begin //{
      if(pl_pc_trans.link_req_rst_cmd_cnt>0)
        pl_pc_trans.link_req_rst_cmd_cnt=0;
    end //}

    if (temp_pc_trans_ins.stype1 != 3'b100 || (temp_pc_trans_ins.stype1 == 3'b100 && temp_pc_trans_ins.cmd != 3'b010))
    begin //{
      if(pl_pc_trans.link_req_rst_port_cmd_cnt>0)
        pl_pc_trans.link_req_rst_port_cmd_cnt=0;
    end //}

    if (temp_pc_trans_ins.stype1 == 3'b100 && temp_pc_trans_ins.cmd == 3'b100)
    begin //{
      pl_pc_common_mon_trans.outstanding_link_req[mon_type] = 1;
      if (pl_pc_trans.ies_state)
        begin//{
        pl_pc_trans.ies_state = 0;
         ies_err_reg=1;
        end//}
      return;
    end //}
    else if (temp_pc_trans_ins.stype1 == 3'b100 && temp_pc_trans_ins.cmd == 3'b011)
    begin //{

      pl_pc_trans.link_req_rst_cmd_cnt++;

      update_link_maint_resp_reg_resp_valid();

      return;

    end //}
    else if (temp_pc_trans_ins.stype1 == 3'b100 && temp_pc_trans_ins.cmd == 3'b010)
    begin //{

      pl_pc_trans.link_req_rst_port_cmd_cnt++;

      update_link_maint_resp_reg_resp_valid();

      return;

    end //}

    // In case of state transitions, there is a possibility that corrupted
    // control symbols might be received. In such case, stype1 may be seen
    // as 3'b100, but cmd field may be neither 3'b100 nor 3'b011. In those
    // cases, the logic will proceed after this block which may eventually
    // lead to null pointer dereference at some place below. Thus, adding
    // return here for safety purpose.

    if (temp_pc_trans_ins.stype1 == 3'b011)
    begin //{
      pl_pc_common_mon_trans.outstanding_pkt_ack_stype1[mon_type].push_back(temp_pc_trans_ins);
      pl_pc_common_mon_trans.pkt_ack_timer_stype1[mon_type].push_back(pl_pc_config.link_timeout);
    end //}
    else
      return;

  end //}

  if (temp_pc_trans_ins.stype1 == 3'b100)
  begin //{

    if (pl_pc_common_mon_trans.outstanding_pkt_ack_stype1[mon_type][0].stype1 != 3'b100)
    begin //{

      temp_outst_ack_q_size = pl_pc_common_mon_trans.outstanding_pkt_ack_stype1[mon_type].size();

      for (int chk_lreq=0; chk_lreq<temp_outst_ack_q_size; chk_lreq++)
      begin //{

	if (pl_pc_common_mon_trans.outstanding_pkt_ack_stype1[mon_type][chk_lreq].stype1 == 3'b100)
	begin //{

	  temp_pkt_ack_trans = new pl_pc_common_mon_trans.outstanding_pkt_ack_stype1[mon_type][chk_lreq];

	  pl_pc_common_mon_trans.outstanding_pkt_ack_stype1[mon_type].delete(chk_lreq);
	  pl_pc_common_mon_trans.outstanding_pkt_ack_stype1[mon_type].push_front(temp_pkt_ack_trans);
	  pl_pc_common_mon_trans.pkt_ack_timer_stype1[mon_type].push_front(pl_pc_common_mon_trans.pkt_ack_timer_stype1[mon_type][chk_lreq]);
	  pl_pc_common_mon_trans.pkt_ack_timer_stype1[mon_type].delete(chk_lreq+1);
	  scheduled_link_req_found = 1;
	  break;

	end //}

      end //}

      if (~scheduled_link_req_found)
      begin //{
	pl_pc_common_mon_trans.outstanding_pkt_ack_stype1[mon_type].push_front(temp_pc_trans_ins);
	pl_pc_common_mon_trans.pkt_ack_timer_stype1[mon_type].push_front(pl_pc_config.link_timeout);
      end //}
      else
	scheduled_link_req_found = 0;

      // The Input-retry stopped state shall also be cleared if link-request with input-status control symbol
      // is received. Hence, if RFR is scheduled already, and a linkreq with input-status CS is received, then
      // the RFR is removed from the scheduled queue.
      temp_outst_ack_q_size = pl_pc_common_mon_trans.outstanding_pkt_ack_stype1[mon_type].size();
      for (int chk_rfr=0; chk_rfr<temp_outst_ack_q_size; chk_rfr++)
      begin //{
	if (pl_pc_common_mon_trans.outstanding_pkt_ack_stype1[mon_type][chk_rfr].stype1 == 3'b011)
	begin //{
	  pl_pc_common_mon_trans.outstanding_pkt_ack_stype1[mon_type].delete(chk_rfr);
	  pl_pc_common_mon_trans.pkt_ack_timer_stype1[mon_type].delete(chk_rfr);
	  break;
	end //}
      end //}
    end //}

  end //}
  else if (temp_pc_trans_ins.stype1 == 3'b011)
  begin //{

    if (pl_pc_common_mon_trans.outstanding_pkt_ack_stype1[mon_type][0].stype1 != 3'b011)
    begin //{

      temp_outst_ack_q_size = pl_pc_common_mon_trans.outstanding_pkt_ack_stype1[mon_type].size();

      for (int chk_rfr=0; chk_rfr<temp_outst_ack_q_size; chk_rfr++)
      begin //{

	if (pl_pc_common_mon_trans.outstanding_pkt_ack_stype1[mon_type][chk_rfr].stype1 == 3'b011)
	begin //{

	  temp_pkt_ack_trans = new pl_pc_common_mon_trans.outstanding_pkt_ack_stype1[mon_type][chk_rfr];

	  pl_pc_common_mon_trans.outstanding_pkt_ack_stype1[mon_type].delete(chk_rfr);
	  pl_pc_common_mon_trans.outstanding_pkt_ack_stype1[mon_type].push_front(temp_pkt_ack_trans);
	  pl_pc_common_mon_trans.pkt_ack_timer_stype1[mon_type].push_front(pl_pc_common_mon_trans.pkt_ack_timer_stype1[mon_type][chk_rfr]);
	  pl_pc_common_mon_trans.pkt_ack_timer_stype1[mon_type].delete(chk_rfr+1);
	  scheduled_rfr_found = 1;
	  break;

	end //}

      end //}

      if (~scheduled_rfr_found)
      begin //{
	pl_pc_common_mon_trans.outstanding_pkt_ack_stype1[mon_type].push_front(temp_pc_trans_ins);
	pl_pc_common_mon_trans.pkt_ack_timer_stype1[mon_type].push_front(pl_pc_config.link_timeout);
      end //}
      else
	scheduled_rfr_found = 0;

    end //}

  end //}
  else if (temp_pc_trans_ins.stype1 == 3'b101 && temp_pc_trans_ins.cmd == 3'b011)
  begin //{

    if (pl_pc_common_mon_trans.outstanding_pkt_ack_stype1[mon_type][0].stype1 != 3'b101)
    begin //{

      temp_outst_ack_q_size = pl_pc_common_mon_trans.outstanding_pkt_ack_stype1[mon_type].size();

      for (int chk_lreq=0; chk_lreq<temp_outst_ack_q_size; chk_lreq++)
      begin //{

	if (pl_pc_common_mon_trans.outstanding_pkt_ack_stype1[mon_type][chk_lreq].stype1 == 3'b101)
	begin //{

	  temp_pkt_ack_trans = new pl_pc_common_mon_trans.outstanding_pkt_ack_stype1[mon_type][chk_lreq];

	  pl_pc_common_mon_trans.outstanding_pkt_ack_stype1[mon_type].delete(chk_lreq);
	  pl_pc_common_mon_trans.outstanding_pkt_ack_stype1[mon_type].push_front(temp_pkt_ack_trans);
	  pl_pc_common_mon_trans.pkt_ack_timer_stype1[mon_type].push_front(pl_pc_common_mon_trans.pkt_ack_timer_stype1[mon_type][chk_lreq]);
	  pl_pc_common_mon_trans.pkt_ack_timer_stype1[mon_type].delete(chk_lreq+1);
	  scheduled_loop_req_found = 1;
	  break;

	end //}

      end //}

      if (scheduled_loop_req_found)
      begin //{
	scheduled_loop_req_found = 0;
	pl_pc_common_mon_trans.outstanding_pkt_ack_stype1[mon_type].push_front(temp_pc_trans_ins);
	pl_pc_common_mon_trans.pkt_ack_timer_stype1[mon_type].push_front(pl_pc_config.link_timeout);
      end //}
      else
      begin //{

        update_error_detect_csr("PROTOCOL_ERROR");

        `uvm_error("SRIO_PL_PROTOCOL_CHECKER : UNEXP_LOOP_REQ_CHECK", $sformatf(" Spec reference 6.5.3.5. Unexpected loop request detected when it is not initiated"))

      end //}

    end //}

  end //}

  exp_comp_trans = new pl_pc_common_mon_trans.outstanding_pkt_ack_stype1[mon_type].pop_front();

  void'(pl_pc_common_mon_trans.pkt_ack_timer_stype1[mon_type].pop_front());

  if (exp_comp_trans.stype1 == 3'b100 && temp_pc_trans_ins.stype1 == 3'b100)
  begin //{

    if (temp_pc_trans_ins.cmd == 4 && pl_pc_trans.ies_state)
    begin //{
      pl_pc_trans.ies_state = 0;
      // The Input-retry stopped state shall also be cleared if link-request with input-status control symbol
      // is received. Hence, outstanding_rfr is cleared here if set previously.
      if (pl_pc_common_mon_trans.outstanding_rfr[mon_type])
      begin //{
        pl_pc_common_mon_trans.outstanding_rfr[mon_type] = 0;
        pl_pc_common_mon_trans.outstanding_retry[mon_type] = 0;
        exp_pkt_ackid = pl_pc_common_mon_trans.ackid_status[~mon_type];
        if (pl_pc_env_config.srio_mode != SRIO_GEN30 && pl_pc_env_config.spec_support != V30)
          update_outbound_ackid_reg();
        else
          update_gen3_outbound_ackid_reg();
      end //}
    end //}
    else if (temp_pc_trans_ins.cmd == 3)
    begin //{

      pl_pc_trans.link_req_rst_cmd_cnt++;

      update_link_maint_resp_reg_resp_valid();

    end //}
    else if (temp_pc_trans_ins.cmd == 2)
    begin //{

      pl_pc_trans.link_req_rst_port_cmd_cnt++;

      update_link_maint_resp_reg_resp_valid();

    end //}

    if (~pl_pc_common_mon_trans.outstanding_link_req[mon_type] && temp_pc_trans_ins.cmd == 4)
    begin //{

      // Fast error recovery mechanism is taken care here.
      check_multiple_ack_support();
      if (pl_pc_pna_ackid_support && pl_pc_common_mon_trans.oes_state_detected[~mon_type])
      begin //{
        pl_pc_common_mon_trans.oes_state_detected[~mon_type] = 0;
      end //}
      pl_pc_common_mon_trans.outstanding_link_req[mon_type] = 1;

      if (pl_pc_common_mon_trans.update_exp_pkt_ackid[mon_type])
      begin //{
	exp_pkt_ackid = pl_pc_common_mon_trans.updated_exp_pkt_ackid_val[mon_type];
	pl_pc_common_mon_trans.update_exp_pkt_ackid[mon_type] = 0;
      end //}

    end //}
    else if (pl_pc_common_mon_trans.outstanding_link_req[mon_type] && temp_pc_trans_ins.cmd == 4)
    begin //{

      update_error_detect_csr("PROTOCOL_ERROR");

      `uvm_error("SRIO_PL_PROTOCOL_CHECKER : MULTIPLE_LINK_REQ_CHECK", $sformatf(" Spec reference 5.7. New link request is transmitted when previous link request is outstanding"))

    end //}

  end //}
  else if (exp_comp_trans.stype1 == 3'b011 && temp_pc_trans_ins.stype1 == 3'b011)
  begin //{

    `uvm_info("SRIO_PL_PROTOCOL_CHECKER : PACKET_ACK_RECEIVED", $sformatf(" Restart-from-Retry control symbol received."), UVM_MEDIUM)

    if (pl_pc_common_mon_trans.outstanding_rfr[mon_type])
    begin //{

      pl_pc_common_mon_trans.outstanding_rfr[mon_type] = 0;
      pl_pc_common_mon_trans.outstanding_retry[mon_type] = 0;
      exp_pkt_ackid = pl_pc_common_mon_trans.ackid_status[~mon_type];

      if (pl_pc_env_config.srio_mode != SRIO_GEN30 && pl_pc_env_config.spec_support != V30)
        update_outbound_ackid_reg();
      else
        update_gen3_outbound_ackid_reg();

    end //}
    else if (~pl_pc_common_mon_trans.outstanding_rfr[mon_type])
    begin //{

      update_error_detect_csr("PROTOCOL_ERROR");

      `uvm_error("SRIO_PL_PROTOCOL_CHECKER : RFR_WITHOUT_PKT_RETRY_CHECK", $sformatf(" Spec reference 3.5.4. Unexpected Restart-from-Retry control symbol detected without a packet-retry."))
      if (~pl_pc_trans.ies_state && pl_pc_trans.link_initialized)
      begin //{
        pl_pc_trans.ies_state = 1;
        pl_pc_trans.ies_cause_value = 5;
          //$display($time, " 11. Vaidhy : ies_state set here");
      end //}

    end //}

  end //}
  else if (exp_comp_trans.stype1 == 3'b101 && temp_pc_trans_ins.stype1 == 3'b101 && exp_comp_trans.cmd == 3'b011 && temp_pc_trans_ins.cmd == 3'b011)
  begin //{

    `uvm_info("SRIO_PL_PROTOCOL_CHECKER : PACKET_ACK_RECEIVED", $sformatf(" Loop request control symbol received."), UVM_MEDIUM)

    if (~pl_pc_common_mon_trans.outstanding_loop_req[mon_type])
    begin //{

      pl_pc_common_mon_trans.outstanding_loop_req[mon_type] = 1;

    end //}
    else if (pl_pc_common_mon_trans.outstanding_loop_req[mon_type])
    begin //{

      update_error_detect_csr("PROTOCOL_ERROR");

      `uvm_error("SRIO_PL_PROTOCOL_CHECKER : MULTIPLE_LOOP_REQ_CHECK", $sformatf(" Spec reference 5.7. New loop request is transmitted when previous loop request is outstanding"))

    end //}

  end //}
  else if (exp_comp_trans.stype1 == 3'b100 && temp_pc_trans_ins.stype1 != 3'b111 && (exp_comp_trans.stype1 != temp_pc_trans_ins.stype1))
  begin //{

    update_error_detect_csr("PROTOCOL_ERROR");

    `uvm_error("SRIO_PL_PROTOCOL_CHECKER : UNEXP_STYPE1_CS_FOR_LINK_REQ_CHECK", $sformatf(" Spec reference 5.13.2.3.1. Unexpected  control symbol with stype1 %0h received. Expecting a link request control symbol with input status", temp_pc_trans_ins.stype1))

  end //}
  else if (exp_comp_trans.stype1 == 3'b011 && temp_pc_trans_ins.stype1 != 3'b111 && (exp_comp_trans.stype1 != temp_pc_trans_ins.stype1))
  begin //{

    update_error_detect_csr("PROTOCOL_ERROR");

    `uvm_error("SRIO_PL_PROTOCOL_CHECKER : UNEXP_STYPE1_CS_FOR_RFR_CHECK", $sformatf(" Spec reference 5.13.2.3.1. Unexpected  control symbol with stype1 %0h received. Expecting a Restart-from-Retry control symbol", temp_pc_trans_ins.stype1))

  end //}
  else if (exp_comp_trans.stype1 == 3'b101 && temp_pc_trans_ins.stype1 != 3'b111 && (exp_comp_trans.stype1 != temp_pc_trans_ins.stype1))
  begin //{

    update_error_detect_csr("PROTOCOL_ERROR");

    `uvm_error("SRIO_PL_PROTOCOL_CHECKER : UNEXP_STYPE1_CS_FOR_LOOP_REQ_CHECK", $sformatf(" Spec reference 5.13.2.3.1. Unexpected  control symbol with stype1 %0h received. Expecting a Loop request control symbol", temp_pc_trans_ins.stype1))

  end //}

endtask : cntl_symbol_outstanding_stype1_ack_check





///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : pop_vc_q_on_pkt_acc
/// Description : This method pops the ackid from corresponding vc_id queue when its
/// acknowledgement is received.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::pop_vc_q_on_pkt_acc(srio_trans local_temp_pc_trans_ins);

  if (pl_pc_env_config.vc_num_support == 1)
  begin //{
  
    if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][1].size()>0)
    begin //{
      if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][1][0] == local_temp_pc_trans_ins.param0)
      begin //{
        void'(pl_pc_common_mon_trans.pkt_vcid_q[mon_type][1].pop_front());
	vc1_q_hit = 1;
      end //}
    end //}
  
  end //}
  else if (pl_pc_env_config.vc_num_support == 2)
  begin //{
  
    if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][1].size()>0)
    begin //{
      if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][1][0] == local_temp_pc_trans_ins.param0)
      begin //{
        void'(pl_pc_common_mon_trans.pkt_vcid_q[mon_type][1].pop_front());
	vc1_q_hit = 1;
      end //}
    end //}
  
    if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][5].size()>0)
    begin //{
      if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][5][0] == local_temp_pc_trans_ins.param0)
      begin //{
        void'(pl_pc_common_mon_trans.pkt_vcid_q[mon_type][5].pop_front());
	vc5_q_hit = 1;
      end //}
    end //}
  
  end //}
  else if (pl_pc_env_config.vc_num_support == 4)
  begin //{
  
    if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][1].size()>0)
    begin //{
      if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][1][0] == local_temp_pc_trans_ins.param0)
      begin //{
        void'(pl_pc_common_mon_trans.pkt_vcid_q[mon_type][1].pop_front());
	vc1_q_hit = 1;
      end //}
    end //}
  
    if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][3].size()>0)
    begin //{
      if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][3][0] == local_temp_pc_trans_ins.param0)
      begin //{
        void'(pl_pc_common_mon_trans.pkt_vcid_q[mon_type][3].pop_front());
	vc3_q_hit = 1;
      end //}
    end //}
  
    if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][5].size()>0)
    begin //{
      if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][5][0] == local_temp_pc_trans_ins.param0)
      begin //{
        void'(pl_pc_common_mon_trans.pkt_vcid_q[mon_type][5].pop_front());
	vc5_q_hit = 1;
      end //}
    end //}
  
    if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][7].size()>0)
    begin //{
      if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][7][0] == local_temp_pc_trans_ins.param0)
      begin //{
        void'(pl_pc_common_mon_trans.pkt_vcid_q[mon_type][7].pop_front());
	vc7_q_hit = 1;
      end //}
    end //}
  
  end //}
  else if (pl_pc_env_config.vc_num_support == 8)
  begin //{
  
    if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][1].size()>0)
    begin //{
      if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][1][0] == local_temp_pc_trans_ins.param0)
      begin //{
        void'(pl_pc_common_mon_trans.pkt_vcid_q[mon_type][1].pop_front());
	vc1_q_hit = 1;
      end //}
    end //}
  
    if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][2].size()>0)
    begin //{
      if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][2][0] == local_temp_pc_trans_ins.param0)
      begin //{
        void'(pl_pc_common_mon_trans.pkt_vcid_q[mon_type][2].pop_front());
	vc2_q_hit = 1;
      end //}
    end //}
  
    if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][3].size()>0)
    begin //{
      if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][3][0] == local_temp_pc_trans_ins.param0)
      begin //{
        void'(pl_pc_common_mon_trans.pkt_vcid_q[mon_type][3].pop_front());
	vc3_q_hit = 1;
      end //}
    end //}
  
    if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][4].size()>0)
    begin //{
      if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][4][0] == local_temp_pc_trans_ins.param0)
      begin //{
        void'(pl_pc_common_mon_trans.pkt_vcid_q[mon_type][4].pop_front());
	vc4_q_hit = 1;
      end //}
    end //}
  
    if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][5].size()>0)
    begin //{
      if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][5][0] == local_temp_pc_trans_ins.param0)
      begin //{
        void'(pl_pc_common_mon_trans.pkt_vcid_q[mon_type][5].pop_front());
	vc5_q_hit = 1;
      end //}
    end //}
  
    if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][6].size()>0)
    begin //{
      if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][6][0] == local_temp_pc_trans_ins.param0)
      begin //{
        void'(pl_pc_common_mon_trans.pkt_vcid_q[mon_type][6].pop_front());
	vc6_q_hit = 1;
      end //}
    end //}
  
    if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][7].size()>0)
    begin //{
      if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][7][0] == local_temp_pc_trans_ins.param0)
      begin //{
        void'(pl_pc_common_mon_trans.pkt_vcid_q[mon_type][7].pop_front());
	vc7_q_hit = 1;
      end //}
    end //}
  
    if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][8].size()>0)
    begin //{
      if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][8][0] == local_temp_pc_trans_ins.param0)
      begin //{
        void'(pl_pc_common_mon_trans.pkt_vcid_q[mon_type][8].pop_front());
	vc8_q_hit = 1;
      end //}
    end //}
  
  end //}

  if (vc1_q_hit)
  begin //{
    pl_pc_trans.num_cg_bet_vc_status_cs_cnt[1] = 0;
  end //}

  if (vc2_q_hit)
  begin //{
    pl_pc_trans.num_cg_bet_vc_status_cs_cnt[2] = 0;
  end //}

  if (vc3_q_hit)
  begin //{
    pl_pc_trans.num_cg_bet_vc_status_cs_cnt[3] = 0;
  end //}

  if (vc4_q_hit)
  begin //{
    pl_pc_trans.num_cg_bet_vc_status_cs_cnt[4] = 0;
  end //}

  if (vc5_q_hit)
  begin //{
    pl_pc_trans.num_cg_bet_vc_status_cs_cnt[5] = 0;
  end //}

  if (vc6_q_hit)
  begin //{
    pl_pc_trans.num_cg_bet_vc_status_cs_cnt[6] = 0;
  end //}

  if (vc7_q_hit)
  begin //{
    pl_pc_trans.num_cg_bet_vc_status_cs_cnt[7] = 0;
  end //}

  if (vc8_q_hit)
  begin //{
    pl_pc_trans.num_cg_bet_vc_status_cs_cnt[8] = 0;
  end //}

  vc1_q_hit = 0;
  vc2_q_hit = 0;
  vc3_q_hit = 0;
  vc4_q_hit = 0;
  vc5_q_hit = 0;
  vc6_q_hit = 0;
  vc7_q_hit = 0;
  vc8_q_hit = 0;

endtask : pop_vc_q_on_pkt_acc




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : clear_vc_q_on_pkt_retry_or_pna
/// Description : This method clears the vc_id queue when a retry / pna is received, since all
/// the previous packets will be transmitted again.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::clear_vc_q_on_pkt_retry_or_pna();

  if (pl_pc_env_config.vc_num_support == 1)
  begin //{
  
    if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][1].size()>0)
    begin //{

      // If PNACC is received for a CT mode packet, it would be caught by the "Unexpected packet acknowledgement when expecting a packet-accepted
      // control symbol" error. Hence, a separate check is not required for it here.
      if (pl_pc_config.vc_ct_mode == 1 && temp_pc_trans_ins.stype0 == 3'b001)
      begin //{
        if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][1][0] == temp_pc_trans_ins.param0)
        begin //{
    	  update_error_detect_csr("PROTOCOL_ERROR");
          `uvm_error("SRIO_PL_PROTOCOL_CHECKER : PKT_RETRY_FOR_VC_1_CT_MODE_CHECK", $sformatf(" Spec reference 5.4 / 5.8 / 5.9. Packet-retry is received for a VCID 1 packet which is operating in CT mode."))
        end //}
      end //}

      pl_pc_common_mon_trans.pkt_vcid_q[mon_type][1].delete();
      vc1_q_hit = 1;

    end //}
  
  end //}
  else if (pl_pc_env_config.vc_num_support == 2)
  begin //{
  
    if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][1].size()>0)
    begin //{

      if (pl_pc_config.vc_ct_mode == 3 && temp_pc_trans_ins.stype0 == 3'b001)
      begin //{
        if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][1][0] == temp_pc_trans_ins.param0)
        begin //{
    	  update_error_detect_csr("PROTOCOL_ERROR");
          `uvm_error("SRIO_PL_PROTOCOL_CHECKER : PKT_RETRY_FOR_VC_1_CT_MODE_CHECK", $sformatf(" Spec reference 5.4 / 5.8 / 5.9. Packet-retry is received for a VCID 1 packet which is operating in CT mode."))
        end //}
      end //}

      pl_pc_common_mon_trans.pkt_vcid_q[mon_type][1].delete();
      vc1_q_hit = 1;

    end //}
  
    if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][5].size()>0)
    begin //{

      if ((pl_pc_config.vc_ct_mode == 1 || pl_pc_config.vc_ct_mode == 3) && temp_pc_trans_ins.stype0 == 3'b001)
      begin //{
        if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][5][0] == temp_pc_trans_ins.param0)
        begin //{
    	  update_error_detect_csr("PROTOCOL_ERROR");
          `uvm_error("SRIO_PL_PROTOCOL_CHECKER : PKT_RETRY_FOR_VC_5_CT_MODE_CHECK", $sformatf(" Spec reference 5.4 / 5.8 / 5.9. Packet-retry is received for a VCID 5 packet which is operating in CT mode."))
        end //}
      end //}

      pl_pc_common_mon_trans.pkt_vcid_q[mon_type][5].delete();
      vc5_q_hit = 1;

    end //}
  
  end //}
  else if (pl_pc_env_config.vc_num_support == 4)
  begin //{
  
    if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][1].size()>0)
    begin //{

      if (pl_pc_config.vc_ct_mode == 7 && temp_pc_trans_ins.stype0 == 3'b001)
      begin //{
        if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][1][0] == temp_pc_trans_ins.param0)
        begin //{
    	  update_error_detect_csr("PROTOCOL_ERROR");
          `uvm_error("SRIO_PL_PROTOCOL_CHECKER : PKT_RETRY_FOR_VC_1_CT_MODE_CHECK", $sformatf(" Spec reference 5.4 / 5.8 / 5.9. Packet-retry is received for a VCID 1 packet which is operating in CT mode."))
        end //}
      end //}

      pl_pc_common_mon_trans.pkt_vcid_q[mon_type][1].delete();
      vc1_q_hit = 1;

    end //}
  
    if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][3].size()>0)
    begin //{

      if (pl_pc_config.vc_ct_mode == 7 && temp_pc_trans_ins.stype0 == 3'b001)
      begin //{
        if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][3][0] == temp_pc_trans_ins.param0)
        begin //{
    	  update_error_detect_csr("PROTOCOL_ERROR");
          `uvm_error("SRIO_PL_PROTOCOL_CHECKER : PKT_RETRY_FOR_VC_3_CT_MODE_CHECK", $sformatf(" Spec reference 5.4 / 5.8 / 5.9. Packet-retry is received for a VCID 3 packet which is operating in CT mode."))
        end //}
      end //}

      pl_pc_common_mon_trans.pkt_vcid_q[mon_type][3].delete();
      vc3_q_hit = 1;

    end //}
  
    if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][5].size()>0)
    begin //{

      if ((pl_pc_config.vc_ct_mode == 7 || pl_pc_config.vc_ct_mode == 3) && temp_pc_trans_ins.stype0 == 3'b001)
      begin //{
        if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][5][0] == temp_pc_trans_ins.param0)
        begin //{
    	  update_error_detect_csr("PROTOCOL_ERROR");
          `uvm_error("SRIO_PL_PROTOCOL_CHECKER : PKT_RETRY_FOR_VC_5_CT_MODE_CHECK", $sformatf(" Spec reference 5.4 / 5.8 / 5.9. Packet-retry is received for a VCID 5 packet which is operating in CT mode."))
        end //}
      end //}

      pl_pc_common_mon_trans.pkt_vcid_q[mon_type][5].delete();
      vc5_q_hit = 1;

    end //}
  
    if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][7].size()>0)
    begin //{

      if ((pl_pc_config.vc_ct_mode == 7 || pl_pc_config.vc_ct_mode == 3 || pl_pc_config.vc_ct_mode == 1) && temp_pc_trans_ins.stype0 == 3'b001)
      begin //{
        if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][7][0] == temp_pc_trans_ins.param0)
        begin //{
    	  update_error_detect_csr("PROTOCOL_ERROR");
          `uvm_error("SRIO_PL_PROTOCOL_CHECKER : PKT_RETRY_FOR_VC_7_CT_MODE_CHECK", $sformatf(" Spec reference 5.4 / 5.8 / 5.9. Packet-retry is received for a VCID 7 packet which is operating in CT mode."))
        end //}
      end //}

      pl_pc_common_mon_trans.pkt_vcid_q[mon_type][7].delete();
      vc7_q_hit = 1;

    end //}
  
  end //}
  else if (pl_pc_env_config.vc_num_support == 8)
  begin //{
  
    if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][1].size()>0)
    begin //{

      if (pl_pc_config.vc_ct_mode == 15 && temp_pc_trans_ins.stype0 == 3'b001)
      begin //{
        if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][1][0] == temp_pc_trans_ins.param0)
        begin //{
    	  update_error_detect_csr("PROTOCOL_ERROR");
          `uvm_error("SRIO_PL_PROTOCOL_CHECKER : PKT_RETRY_FOR_VC_1_CT_MODE_CHECK", $sformatf(" Spec reference 5.4 / 5.8 / 5.9. Packet-retry is received for a VCID 1 packet which is operating in CT mode."))
        end //}
      end //}

      pl_pc_common_mon_trans.pkt_vcid_q[mon_type][1].delete();
      vc1_q_hit = 1;

    end //}
  
    if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][2].size()>0)
    begin //{

      if (pl_pc_config.vc_ct_mode == 15 && temp_pc_trans_ins.stype0 == 3'b001)
      begin //{
        if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][2][0] == temp_pc_trans_ins.param0)
        begin //{
    	  update_error_detect_csr("PROTOCOL_ERROR");
          `uvm_error("SRIO_PL_PROTOCOL_CHECKER : PKT_RETRY_FOR_VC_2_CT_MODE_CHECK", $sformatf(" Spec reference 5.4 / 5.8 / 5.9. Packet-retry is received for a VCID 2 packet which is operating in CT mode."))
        end //}
      end //}

      pl_pc_common_mon_trans.pkt_vcid_q[mon_type][2].delete();
      vc2_q_hit = 1;

    end //}
  
    if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][3].size()>0)
    begin //{

      if (pl_pc_config.vc_ct_mode == 15 && temp_pc_trans_ins.stype0 == 3'b001)
      begin //{
        if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][3][0] == temp_pc_trans_ins.param0)
        begin //{
    	  update_error_detect_csr("PROTOCOL_ERROR");
          `uvm_error("SRIO_PL_PROTOCOL_CHECKER : PKT_RETRY_FOR_VC_3_CT_MODE_CHECK", $sformatf(" Spec reference 5.4 / 5.8 / 5.9. Packet-retry is received for a VCID 3 packet which is operating in CT mode."))
        end //}
      end //}

      pl_pc_common_mon_trans.pkt_vcid_q[mon_type][3].delete();
      vc3_q_hit = 1;

    end //}
  
    if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][4].size()>0)
    begin //{

      if (pl_pc_config.vc_ct_mode == 15 && temp_pc_trans_ins.stype0 == 3'b001)
      begin //{
        if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][4][0] == temp_pc_trans_ins.param0)
        begin //{
    	  update_error_detect_csr("PROTOCOL_ERROR");
          `uvm_error("SRIO_PL_PROTOCOL_CHECKER : PKT_RETRY_FOR_VC_4_CT_MODE_CHECK", $sformatf(" Spec reference 5.4 / 5.8 / 5.9. Packet-retry is received for a VCID 4 packet which is operating in CT mode."))
        end //}
      end //}

      pl_pc_common_mon_trans.pkt_vcid_q[mon_type][4].delete();
      vc4_q_hit = 1;

    end //}
  
    if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][5].size()>0)
    begin //{

      if ((pl_pc_config.vc_ct_mode == 15 || pl_pc_config.vc_ct_mode == 7) && temp_pc_trans_ins.stype0 == 3'b001)
      begin //{
        if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][5][0] == temp_pc_trans_ins.param0)
        begin //{
    	  update_error_detect_csr("PROTOCOL_ERROR");
          `uvm_error("SRIO_PL_PROTOCOL_CHECKER : PKT_RETRY_FOR_VC_5_CT_MODE_CHECK", $sformatf(" Spec reference 5.4 / 5.8 / 5.9. Packet-retry is received for a VCID 5 packet which is operating in CT mode."))
        end //}
      end //}

      pl_pc_common_mon_trans.pkt_vcid_q[mon_type][5].delete();
      vc5_q_hit = 1;

    end //}
  
    if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][6].size()>0)
    begin //{

      if ((pl_pc_config.vc_ct_mode == 15 || pl_pc_config.vc_ct_mode == 7) && temp_pc_trans_ins.stype0 == 3'b001)
      begin //{
        if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][6][0] == temp_pc_trans_ins.param0)
        begin //{
    	  update_error_detect_csr("PROTOCOL_ERROR");
          `uvm_error("SRIO_PL_PROTOCOL_CHECKER : PKT_RETRY_FOR_VC_6_CT_MODE_CHECK", $sformatf(" Spec reference 5.4 / 5.8 / 5.9. Packet-retry is received for a VCID 6 packet which is operating in CT mode."))
        end //}
      end //}

      pl_pc_common_mon_trans.pkt_vcid_q[mon_type][6].delete();
      vc6_q_hit = 1;

    end //}
  
    if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][7].size()>0)
    begin //{

      if ((pl_pc_config.vc_ct_mode == 15 || pl_pc_config.vc_ct_mode == 7 || pl_pc_config.vc_ct_mode == 3) && temp_pc_trans_ins.stype0 == 3'b001)
      begin //{
        if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][7][0] == temp_pc_trans_ins.param0)
        begin //{
    	  update_error_detect_csr("PROTOCOL_ERROR");
          `uvm_error("SRIO_PL_PROTOCOL_CHECKER : PKT_RETRY_FOR_VC_7_CT_MODE_CHECK", $sformatf(" Spec reference 5.4 / 5.8 / 5.9. Packet-retry is received for a VCID 7 packet which is operating in CT mode."))
        end //}
      end //}

      pl_pc_common_mon_trans.pkt_vcid_q[mon_type][7].delete();
      vc7_q_hit = 1;

    end //}
  
    if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][8].size()>0)
    begin //{

      if ((pl_pc_config.vc_ct_mode == 15 || pl_pc_config.vc_ct_mode == 7 || pl_pc_config.vc_ct_mode == 3 || pl_pc_config.vc_ct_mode == 1) && temp_pc_trans_ins.stype0 == 3'b001)
      begin //{
        if (pl_pc_common_mon_trans.pkt_vcid_q[mon_type][8][0] == temp_pc_trans_ins.param0)
        begin //{
    	  update_error_detect_csr("PROTOCOL_ERROR");
          `uvm_error("SRIO_PL_PROTOCOL_CHECKER : PKT_RETRY_FOR_VC_8_CT_MODE_CHECK", $sformatf(" Spec reference 5.4 / 5.8 / 5.9. Packet-retry is received for a VCID 8 packet which is operating in CT mode."))
        end //}
      end //}

      pl_pc_common_mon_trans.pkt_vcid_q[mon_type][8].delete();
      vc8_q_hit = 1;

    end //}
  
  end //}

  if (temp_pc_trans_ins.stype0 == 3'b001)
  begin //{

    if (vc1_q_hit)
    begin //{
      pl_pc_trans.num_cg_bet_vc_status_cs_cnt[1] = 0;
    end //}

    if (vc2_q_hit)
    begin //{
      pl_pc_trans.num_cg_bet_vc_status_cs_cnt[2] = 0;
    end //}

    if (vc3_q_hit)
    begin //{
      pl_pc_trans.num_cg_bet_vc_status_cs_cnt[3] = 0;
    end //}

    if (vc4_q_hit)
    begin //{
      pl_pc_trans.num_cg_bet_vc_status_cs_cnt[4] = 0;
    end //}

    if (vc5_q_hit)
    begin //{
      pl_pc_trans.num_cg_bet_vc_status_cs_cnt[5] = 0;
    end //}

    if (vc6_q_hit)
    begin //{
      pl_pc_trans.num_cg_bet_vc_status_cs_cnt[6] = 0;
    end //}

    if (vc7_q_hit)
    begin //{
      pl_pc_trans.num_cg_bet_vc_status_cs_cnt[7] = 0;
    end //}

    if (vc8_q_hit)
    begin //{
      pl_pc_trans.num_cg_bet_vc_status_cs_cnt[8] = 0;
    end //}

    vc1_q_hit = 0;
    vc2_q_hit = 0;
    vc3_q_hit = 0;
    vc4_q_hit = 0;
    vc5_q_hit = 0;
    vc6_q_hit = 0;
    vc7_q_hit = 0;
    vc8_q_hit = 0;

  end //}

endtask : clear_vc_q_on_pkt_retry_or_pna





///////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : clear_oes_state
/// Description : This method runs forever and checks if oes_state_detected variable of self mon_type
/// is cleared when oes_state is set. oes_state is also cleared when such condition is encountered.
///////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::clear_oes_state();
  forever begin //{
    @(pl_pc_common_mon_trans.oes_state_detected[mon_type]);
    if (pl_pc_common_mon_trans.oes_state_detected[mon_type] == 0 && pl_pc_trans.oes_state == 1)
    begin //{
      pl_pc_trans.oes_state = 0;
    end //}
  end //}

endtask : clear_oes_state
/////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : ies_recovery
/// Description : This method runs forever and tracks the Input-error-stopped state and its recovery.
/// The method waits for ies_state to be set, and once set, it schedules pna with appropriate cause
/// field for the other monitor's outstanding stype0 queue and waits for the ies_state to be cleared.
/////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::ies_recovery();

  forever begin //{

    wait(pl_pc_trans.ies_state == 1 && !pl_pc_common_mon_trans.ies_state_detected[mon_type]);

    `uvm_info("SRIO_PL_PROTOCOL_CHECKER : IES STATE", $sformatf(" Entered into Input-Error-Stoped state"), UVM_MEDIUM)

    temp_exp_trans = new();
    temp_exp_trans.env_config = pl_pc_env_config;
    temp_exp_trans.transaction_kind = SRIO_CS;
    temp_exp_trans.stype0 = 3'b010;

    temp_exp_trans.param0 = exp_pkt_ackid;
    temp_exp_trans.param1 = pl_pc_trans.ies_cause_value;

    exp_trans = new temp_exp_trans;
    exp_trans.env_config = pl_pc_env_config;

    pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[~mon_type].push_back(exp_trans);
    pl_pc_common_mon_trans.pkt_ack_timer_stype0[~mon_type].push_back(pl_pc_config.link_timeout);

    //$display($time, " ies_state : scheduled pnacc with cause field %0d for mon_type %0d", pl_pc_trans.ies_cause_value, ~mon_type);

    wait(pl_pc_trans.ies_state == 0);
    pl_pc_common_mon_trans.ies_state_detected[mon_type]=0;

    `uvm_info("SRIO_PL_PROTOCOL_CHECKER : IES STATE", $sformatf(" Exit from Input-Error-Stoped state"), UVM_MEDIUM)

  end //}

endtask : ies_recovery




////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : oes_recovery
/// Description : This method runs forever and tracks the Output-error-stopped state and its recovery.
/// The method waits for oes_state to be set, and once set, it schedules link-request with input-status
/// command for the other monitor's outstanding stype1 queue and clears all the outstanding packet
/// accepted control symbols, and related variables before waiting for the oes_state to be cleared.
////////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::oes_recovery();

  forever begin //{

    wait(pl_pc_trans.oes_state == 1);

    `uvm_info("SRIO_PL_PROTOCOL_CHECKER : OES STATE", $sformatf(" Entered into Output-Error-Stoped state"), UVM_MEDIUM)

    temp_exp_trans = new();
    temp_exp_trans.env_config = pl_pc_env_config;
    temp_exp_trans.transaction_kind = SRIO_CS;
    temp_exp_trans.stype1 = 3'b100;

    temp_exp_trans.cmd = 3'b100;

    exp_trans = new temp_exp_trans;
    exp_trans.env_config = pl_pc_env_config;

    pl_pc_common_mon_trans.num_outstanding_pkts[~mon_type] = 0;

    temp_outst_ack_q_size = pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type].size();

    // In OES, clear only outstanding packet accepted control symbols.
    // Outstanding packet-not-accepted control symbols should not be cleared.
    for (int clr_pa=0; clr_pa<temp_outst_ack_q_size; clr_pa++)
    begin //{

      temp_pkt_ack_trans = new pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type][0];

      if (temp_pkt_ack_trans.stype0 == 3'b000)
      begin //{

	void'(pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type].pop_front());
        void'(pl_pc_common_mon_trans.pkt_ack_timer_stype0[mon_type].pop_front());
	//if (~pl_pc_common_mon_trans.update_exp_pkt_ackid[mon_type])
	//begin //{
	//  pl_pc_common_mon_trans.update_exp_pkt_ackid[mon_type] = 1;
	//  pl_pc_common_mon_trans.updated_exp_pkt_ackid_val[mon_type] = temp_pkt_ack_trans.param0;
	//end //}

      end //}
      else if (temp_pkt_ack_trans.stype0 == 3'b010)
      begin //{
    	pl_pc_common_mon_trans.pkt_ack_timer_stype0[mon_type][0] = pl_pc_config.link_timeout;
	break;
      end //}

    end //}

    if (pl_pc_common_mon_trans.pl_outstanding_ackid[~mon_type].first(link_req_arr_idx))
    begin //{

      do begin //{

	$display($time, " Clearing pl_outstanding_ackid in oes_state. link_req_arr_idx is %0d", link_req_arr_idx);

	pl_pc_common_mon_trans.pl_outstanding_ackid[~mon_type][link_req_arr_idx] = 0;

      end while(pl_pc_common_mon_trans.pl_outstanding_ackid[~mon_type].next(link_req_arr_idx)); //}

    end //}

    pl_pc_common_mon_trans.outstanding_pkt_ack_stype1[~mon_type].push_back(exp_trans);
    pl_pc_common_mon_trans.pkt_ack_timer_stype1[~mon_type].push_back(pl_pc_config.link_timeout);

    //$display($time, " oes_state : scheduled link_req with cmd field %0d for mon_type %0d", temp_exp_trans.cmd, ~mon_type);

    wait(pl_pc_trans.oes_state == 0);

    `uvm_info("SRIO_PL_PROTOCOL_CHECKER : OES STATE", $sformatf(" Exit from Output-Error-Stoped state"), UVM_MEDIUM)

  end //}

endtask : oes_recovery




/////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : irs_recovery
/// Description : This method runs forever and tracks the Input-retry-stopped state. This method
/// will be triggered if a retry control symbol is received by a monitor. When it receives a
/// retry control symbol, it will outstanding_rfr flag and waits for it to be cleared.
/////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::irs_recovery();

  forever begin //{

    wait(pl_pc_common_mon_trans.outstanding_rfr[mon_type] == 1);

    `uvm_info("SRIO_PL_PROTOCOL_CHECKER : IRS STATE", $sformatf(" Entered into Input-Retry-Stoped state"), UVM_MEDIUM)

    pl_pc_trans.irs_state = 1;

    wait(pl_pc_common_mon_trans.outstanding_rfr[mon_type] == 0);

    pl_pc_trans.irs_state = 0;

    `uvm_info("SRIO_PL_PROTOCOL_CHECKER : IRS STATE", $sformatf(" Exit from Input-Retry-Stoped state"), UVM_MEDIUM)

  end //}

endtask : irs_recovery




//////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : ors_recovery
/// Description : This method runs forever and tracks the Output-retry-stopped state. This method
/// will be triggered if outstanding_rfr flag is set by the other monitor. Once set, it will
/// schedule restart-from-retry control symbol for the other monitor's stype1 outstanding
/// queue and waits for the outstanding_rfr flag to be cleared.
//////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::ors_recovery();

  forever begin //{

    wait(pl_pc_common_mon_trans.outstanding_rfr[~mon_type] == 1);

    `uvm_info("SRIO_PL_PROTOCOL_CHECKER : ORS STATE", $sformatf(" Entered into Output-Retry-Stoped state"), UVM_MEDIUM)

    temp_exp_trans = new();
    temp_exp_trans.env_config = pl_pc_env_config;
    temp_exp_trans.transaction_kind = SRIO_CS;
    temp_exp_trans.stype1 = 3'b011;

    temp_exp_trans.cmd = 3'b000;

    exp_trans = new temp_exp_trans;
    exp_trans.env_config = pl_pc_env_config;

    pl_pc_common_mon_trans.outstanding_pkt_ack_stype1[~mon_type].push_back(exp_trans);
    pl_pc_common_mon_trans.pkt_ack_timer_stype1[~mon_type].push_back(pl_pc_config.link_timeout);

    wait(pl_pc_common_mon_trans.outstanding_rfr[~mon_type] == 0);
    pl_pc_trans.ors_state = 0;

    `uvm_info("SRIO_PL_PROTOCOL_CHECKER : ORS STATE", $sformatf(" Exit from Output-Retry-Stoped state"), UVM_MEDIUM)

  end //}

endtask : ors_recovery




//////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_link_resp
/// Description : This method will be triggered if outstanding_link_req flag is set by the other
/// monitor. Once set, it will schedule link_response control symbol for the other monitor's
/// stype0 outstanding queue and waits for the outstanding_link_req flag to be cleared.
//////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::gen_link_resp();

  forever begin //{

    wait(pl_pc_common_mon_trans.outstanding_link_req[mon_type] == 1);

    temp_exp_trans = new();
    temp_exp_trans.env_config = pl_pc_env_config;
    temp_exp_trans.transaction_kind = SRIO_CS;
    temp_exp_trans.stype0 = 3'b110;

    temp_exp_trans.param0 = pl_pc_common_mon_trans.ackid_status[~mon_type];

    if (pl_pc_env_config.srio_mode != SRIO_GEN30)
     begin//{
      if (pl_pc_common_mon_trans.oes_state_detected[~mon_type] || ies_err_reg)
        temp_exp_trans.param1 = 5'b00101;
      else if (pl_pc_common_mon_trans.outstanding_rfr[~mon_type])
        temp_exp_trans.param1 = 5'b00100;
      else
        temp_exp_trans.param1 = 5'b10000;
     end//}
    else
     begin//{
      if (pl_pc_common_mon_trans.oes_state_detected[~mon_type])
        temp_exp_trans.param1 = 12'b0101_0001_0000;
      else if (pl_pc_common_mon_trans.outstanding_rfr[~mon_type])
        temp_exp_trans.param1 = 12'b0011_0001_0000;
      else
        temp_exp_trans.param1 = 12'b0001_0001_0000;
     end//}
    exp_trans = new temp_exp_trans;
    exp_trans.env_config = pl_pc_env_config;

    pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[~mon_type].push_back(exp_trans);
    pl_pc_common_mon_trans.pkt_ack_timer_stype0[~mon_type].push_back(pl_pc_config.link_timeout);

    wait(pl_pc_common_mon_trans.outstanding_link_req[mon_type] == 0);
    ies_err_reg=0;

  end //}

endtask : gen_link_resp




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : cntl_symbol_buf_status_check
/// Description : This method checks the buf_status field in receive flow control mode.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::cntl_symbol_buf_status_check();

  if (temp_pc_trans_ins.stype0 == 3'b000 || temp_pc_trans_ins.stype0 == 3'b001 || temp_pc_trans_ins.stype0 == 3'b100 || temp_pc_trans_ins.stype0 == 3'b101)
  begin //{

    if (pl_pc_trans.idle_detected && pl_pc_trans.idle_selected && pl_pc_env_config.srio_mode != SRIO_GEN30)
      buf_status_value = 63;
    else if (pl_pc_trans.idle_detected && ~pl_pc_trans.idle_selected && pl_pc_env_config.srio_mode != SRIO_GEN30)
      buf_status_value = 31;
    else if (pl_pc_env_config.srio_mode == SRIO_GEN30)
      buf_status_value = 4095;

    if (pl_pc_config.flow_control_mode == RECEIVE && temp_pc_trans_ins.param1 != buf_status_value)
    begin //{

      `uvm_error("SRIO_PL_PROTOCOL_CHECKER : CS_BUF_STATUS_CHECK", $sformatf(" Spec reference 5.9.1. Device operating in receiver flow control mode, and the buf status field in the received control symbol is not equal to %0d. stype0 is %0d, received buf_status value is %0h", buf_status_value, temp_pc_trans_ins.stype0, temp_pc_trans_ins.param1))

    end //}

  end //}

endtask : cntl_symbol_buf_status_check




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : cntl_symbol_ackid_status_check
/// Description : This method checks ackid_status value for appropriate control symbols.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::cntl_symbol_ackid_status_check();
srio_trans chk_trans;
int track=0;
bit flag_parm_err=0;
int i;
  if (temp_pc_trans_ins.stype0 == 3'b100 || temp_pc_trans_ins.stype0 == 3'b110)
  begin //{

    if (!pl_pc_common_mon_trans.ackid_status.exists(mon_type))
      pl_pc_common_mon_trans.ackid_status[mon_type] = 0;

         if(temp_pc_trans_ins.stype0==3'b110)
          begin//{
           track=0;
           flag_parm_err=0;
           for(i=0;i<pkt_ack_stype0.size();i++)
            begin//{
             chk_trans=new pkt_ack_stype0[i];
             if(chk_trans.param0==temp_pc_trans_ins.param0)
               break; 
            end//} 
            if(i==pkt_ack_stype0.size())
             begin//{
              if(chk_trans!=null)
              pl_pc_common_mon_trans.ackid_status[mon_type] = (chk_trans.param0+1);
              flag_parm_err=1;
              if(temp_pc_trans_ins.param0==pl_pc_common_mon_trans.ackid_status[mon_type])
               flag_parm_err=0;
             end//}
             if(!flag_parm_err)
              pl_pc_common_mon_trans.ackid_status[mon_type]=temp_pc_trans_ins.param0;
            pkt_ack_stype0.delete();
          end//}
    if((temp_pc_trans_ins.param0 != pl_pc_common_mon_trans.ackid_status[mon_type] && (temp_pc_trans_ins.stype0 == 3'b100)) || ((temp_pc_trans_ins.stype0 == 3'b110) && flag_parm_err/*((temp_pc_trans_ins.param0<ackid_min_in_q) || (temp_pc_trans_ins.param0>ackid_max_in_q))*/))
    begin //{

      update_error_detect_csr("NON_OUTST_ACKID");

      `uvm_error("SRIO_PL_PROTOCOL_CHECKER : UNEXP_ACKID_STATUS_CHECK", $sformatf(" Spec reference 5.13.2.3.1. Unexpected ackid_status detected in the received control symbol. stype0 is %0d, Expected ackid_status value is %0h, Received ackid_status value is %0h", temp_pc_trans_ins.stype0, pl_pc_common_mon_trans.ackid_status[mon_type], temp_pc_trans_ins.param0))

    end //}

  end //}

endtask : cntl_symbol_ackid_status_check




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : cntl_symbol_delimiter_check
/// Description : This method checks if control symbol is delimited by valid delimiters or not.
/// This method is triggered oly for non GNE3.0 device.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::cntl_symbol_delimiter_check();

  if (temp_pc_trans_ins.cs_kind == SRIO_DELIM_SC && (temp_pc_trans_ins.stype1 == 3'b000 || temp_pc_trans_ins.stype1 == 3'b001 || temp_pc_trans_ins.stype1 == 3'b010))
  begin //{

    `uvm_error("SRIO_PL_PROTOCOL_CHECKER : CS_SC_DELIMITER_CHECK", $sformatf(" Spec reference 3.5 / Table 3-7. Control symbol delimiter is SC, but stype1 is %0d", temp_pc_trans_ins.stype1))
    if (~pl_pc_trans.ies_state && pl_pc_trans.link_initialized)
    begin //{
      pl_pc_trans.ies_state = 1;
      pl_pc_trans.ies_cause_value = 5;
	//$display($time, " 11. Vaidhy : ies_state set here");
    end //}

  end //}

  if (temp_pc_trans_ins.cs_kind == SRIO_DELIM_PD && (temp_pc_trans_ins.stype1 == 3'b101 || temp_pc_trans_ins.stype1 == 3'b110 || temp_pc_trans_ins.stype1 == 3'b111))
  begin //{

    `uvm_error("SRIO_PL_PROTOCOL_CHECKER : CS_PD_DELIMITER_CHECK", $sformatf(" Spec reference 3.5 / Table 3-7. Control symbol delimiter is PD, but stype1 is %0d", temp_pc_trans_ins.stype1))

    if (~pl_pc_trans.ies_state && pl_pc_trans.link_initialized)
    begin //{
      pl_pc_trans.ies_state = 1;
      pl_pc_trans.ies_cause_value = 5;
	//$display($time, " 11. Vaidhy : ies_state set here");
    end //}
  end //}

endtask : cntl_symbol_delimiter_check




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : cntl_symbol_status_cs_cnt_check
/// Description : This method checks whether the status control symbol is received in the
/// expected codegroup/codeword interval or not.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::cntl_symbol_status_cs_cnt_check();

  int temp_cg_bet_status_cs_cnt;

  if (temp_pc_trans_ins.stype0 == 3'b100)
  begin //{

    if (pl_pc_trans.status_cs_cnt_check_started)
    begin //{

	//if (mon_type)
	//  $display($time, " TX_STAT_CS_CNT : num_cg_cnt is %0d", pl_pc_trans.num_cg_bet_status_cs_cnt);
	//else
	//  $display($time, " RX_STAT_CS_CNT : num_cg_cnt is %0d", pl_pc_trans.num_cg_bet_status_cs_cnt);

      if (pl_pc_common_mon_trans.port_initialized[~mon_type] && pl_pc_trans.current_init_state == NX_MODE)
       begin //{
        if (pl_pc_trans.idle_detected && pl_pc_trans.idle_selected && pl_pc_env_config.srio_mode != SRIO_GEN30)
	 pl_pc_trans.num_cg_bet_status_cs_cnt = pl_pc_trans.num_cg_bet_status_cs_cnt-2;
        else if (pl_pc_trans.idle_detected && ~pl_pc_trans.idle_selected && pl_pc_env_config.srio_mode != SRIO_GEN30)
 	 pl_pc_trans.num_cg_bet_status_cs_cnt = pl_pc_trans.num_cg_bet_status_cs_cnt-2;
        else if (pl_pc_env_config.srio_mode == SRIO_GEN30)
	 pl_pc_trans.num_cg_bet_status_cs_cnt = pl_pc_trans.num_cg_bet_status_cs_cnt-2;
       end //}
      else if (pl_pc_common_mon_trans.port_initialized[~mon_type] && pl_pc_trans.current_init_state == X2_MODE)
       begin //{
        if (pl_pc_trans.idle_detected && pl_pc_trans.idle_selected && pl_pc_env_config.srio_mode != SRIO_GEN30)
	 pl_pc_trans.num_cg_bet_status_cs_cnt = pl_pc_trans.num_cg_bet_status_cs_cnt-4;
        else if (pl_pc_trans.idle_detected && ~pl_pc_trans.idle_selected && pl_pc_env_config.srio_mode != SRIO_GEN30)
 	 pl_pc_trans.num_cg_bet_status_cs_cnt = pl_pc_trans.num_cg_bet_status_cs_cnt-2;
        else if (pl_pc_env_config.srio_mode == SRIO_GEN30)
	 pl_pc_trans.num_cg_bet_status_cs_cnt = pl_pc_trans.num_cg_bet_status_cs_cnt-2;
       end //}
      else if (pl_pc_common_mon_trans.port_initialized[~mon_type] && (pl_pc_trans.current_init_state == X1_M0 || pl_pc_trans.current_init_state == X1_M1 || pl_pc_trans.current_init_state == X1_M2))
       begin //{
        if (pl_pc_trans.idle_detected && pl_pc_trans.idle_selected && pl_pc_env_config.srio_mode != SRIO_GEN30)
	 pl_pc_trans.num_cg_bet_status_cs_cnt = pl_pc_trans.num_cg_bet_status_cs_cnt-8;
        else if (pl_pc_trans.idle_detected && ~pl_pc_trans.idle_selected && pl_pc_env_config.srio_mode != SRIO_GEN30)
 	 pl_pc_trans.num_cg_bet_status_cs_cnt = pl_pc_trans.num_cg_bet_status_cs_cnt-4;
        else if (pl_pc_env_config.srio_mode == SRIO_GEN30)
	 pl_pc_trans.num_cg_bet_status_cs_cnt = pl_pc_trans.num_cg_bet_status_cs_cnt-2;
       end //}

	if (~report_error) // if report_error is not set means, then it is BFM interface
	begin //{
            if((pl_pc_env_config.srio_mode == SRIO_GEN13) && (pl_pc_trans.current_init_state == NX_MODE) && (pl_pc_trans.num_cg_bet_status_cs_cnt > ( pl_pc_config.code_group_sent_2_cs/pl_pc_env_config.num_of_lanes)))
	  begin //{
	    status_cs_freq_err = 1;
	    temp_cg_bet_status_cs_cnt = pl_pc_config.code_group_sent_2_cs/pl_pc_env_config.num_of_lanes;
	  end //}
	  else if (pl_pc_trans.num_cg_bet_status_cs_cnt > pl_pc_config.code_group_sent_2_cs)
	  begin //{
	    status_cs_freq_err = 1;
	    temp_cg_bet_status_cs_cnt = pl_pc_config.code_group_sent_2_cs;
	  end //}
	end //}
	else
	begin //{
            if((pl_pc_env_config.srio_mode == SRIO_GEN13) && (pl_pc_trans.current_init_state == NX_MODE) && (pl_pc_trans.num_cg_bet_status_cs_cnt > (1024/pl_pc_env_config.num_of_lanes)))
	  begin //{
	     status_cs_freq_err = 1;
	     temp_cg_bet_status_cs_cnt = 1024/pl_pc_env_config.num_of_lanes;
	   end //}
	  else if (pl_pc_trans.num_cg_bet_status_cs_cnt > 1024)
	  begin //{
	    status_cs_freq_err = 1;
	    temp_cg_bet_status_cs_cnt = 1024;
	  end //}
	end //}
  
      if (status_cs_freq_err)
      begin //{

	-> pl_pc_trans.status_cs_blocked;

	status_cs_freq_err = 0;
        if((pl_pc_env_config.srio_mode == SRIO_GEN13) && (pl_pc_trans.current_init_state == NX_MODE) && (pl_pc_trans.num_cg_bet_status_cs_cnt <= 1024))
    	`uvm_warning("SRIO_PL_PROTOCOL_CHECKER : CG_BETWEEN_STAT_CS_CHECK", $sformatf(" Spec reference 5.3.2. Number of code groups between two status control symbols exceeded. Expected count is %0d. Actual count is %0d.This is permitted if the link partner is Gen2 Version", temp_cg_bet_status_cs_cnt, pl_pc_trans.num_cg_bet_status_cs_cnt))
        else if (pl_pc_env_config.srio_mode == SRIO_GEN13)
    	`uvm_error("SRIO_PL_PROTOCOL_CHECKER : CG_BETWEEN_STAT_CS_CHECK", $sformatf(" Spec reference 5.3.2. Number of code groups between two status control symbols exceeded. Expected count is %0d. Actual count is %0d", temp_cg_bet_status_cs_cnt, pl_pc_trans.num_cg_bet_status_cs_cnt))
        else
    	`uvm_error("SRIO_PL_PROTOCOL_CHECKER : CG_BETWEEN_STAT_CS_CHECK", $sformatf(" Spec reference 5.5.3.1. Number of code groups between two status control symbols exceeded. Expected count is %0d. Actual count is %0d", temp_cg_bet_status_cs_cnt, pl_pc_trans.num_cg_bet_status_cs_cnt))

      end //}

    end //}

    pl_pc_trans.num_cg_bet_status_cs_cnt = 0;
    pl_pc_trans.status_cs_cnt_check_started = 1;

  end //}

endtask : cntl_symbol_status_cs_cnt_check




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : cntl_symbol_vc_status_cs_cnt_check
/// Description : This method checks if the VC_Status control symbol is received in expected
/// codegroup / codeword interval or not.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::cntl_symbol_vc_status_cs_cnt_check();

  if (~pl_pc_env_config.multi_vc_support)
    return;

  if (temp_pc_trans_ins.stype0 == 3'b101)
  begin //{

    if (pl_pc_trans.vc_status_cs_cnt_check_started[temp_pc_trans_ins.param0])
    begin //{

	//if (mon_type)
	//  $display($time, " TX_STAT_CS_CNT : num_cg_cnt is %0d", pl_pc_trans.num_cg_bet_status_cs_cnt);
	//else
	//  $display($time, " RX_STAT_CS_CNT : num_cg_cnt is %0d", pl_pc_trans.num_cg_bet_status_cs_cnt);

      if (pl_pc_common_mon_trans.port_initialized[~mon_type] && pl_pc_trans.current_init_state == NX_MODE)
	pl_pc_trans.num_cg_bet_vc_status_cs_cnt[temp_pc_trans_ins.param0] = pl_pc_trans.num_cg_bet_vc_status_cs_cnt[temp_pc_trans_ins.param0]-2;
      else if (pl_pc_common_mon_trans.port_initialized[~mon_type] && pl_pc_trans.current_init_state == X2_MODE)
	pl_pc_trans.num_cg_bet_vc_status_cs_cnt[temp_pc_trans_ins.param0] = pl_pc_trans.num_cg_bet_vc_status_cs_cnt[temp_pc_trans_ins.param0]-4;
      else if (pl_pc_common_mon_trans.port_initialized[~mon_type] && (pl_pc_trans.current_init_state == X1_M0 || pl_pc_trans.current_init_state == X1_M1 || pl_pc_trans.current_init_state == X1_M2))
	pl_pc_trans.num_cg_bet_vc_status_cs_cnt[temp_pc_trans_ins.param0] = pl_pc_trans.num_cg_bet_vc_status_cs_cnt[temp_pc_trans_ins.param0]-8;

	if (~report_error) // if report_error is not set means, then it is BFM interface
	begin //{
	  if (pl_pc_trans.num_cg_bet_vc_status_cs_cnt[temp_pc_trans_ins.param0] > pl_pc_config.vc_status_cs_rate)
	    vc_status_cs_freq_err = 1;
	end //}
	else
	begin //{

	  register_update_method("VC_Control_and_Status_Register", "VC_Refresh_Interval", 32, "pl_pc_reg_model", reqd_field_name["VC_Refresh_Interval"]);
	  lp_vc_refresh_int_temp = reqd_field_name["VC_Refresh_Interval"].get();
	  //lp_vc_refresh_int_temp = pl_pc_reg_model.Port_0_VC_Control_and_Status_Register.VC_Refresh_Interval.get();
	  lp_vc_refresh_int_temp = {lp_vc_refresh_int_temp[7], lp_vc_refresh_int_temp[6], lp_vc_refresh_int_temp[5], lp_vc_refresh_int_temp[4], lp_vc_refresh_int_temp[3], lp_vc_refresh_int_temp[2], lp_vc_refresh_int_temp[1], lp_vc_refresh_int_temp[0]};

	  lp_vc_refresh_int = (lp_vc_refresh_int_temp+1)*1024;

	  if (pl_pc_trans.num_cg_bet_vc_status_cs_cnt[temp_pc_trans_ins.param0] > lp_vc_refresh_int)
	    vc_status_cs_freq_err = 1;

	end //}
  
      if (vc_status_cs_freq_err)
      begin //{

	vc_status_cs_freq_err = 0;

    	`uvm_error("SRIO_PL_PROTOCOL_CHECKER : CG_BETWEEN_STAT_CS_CHECK", $sformatf(" Spec reference 5.5.3.1. Number of code groups between two status control symbols exceeded. Expected count is %0d. Actual count is %0d", lp_vc_refresh_int, pl_pc_trans.num_cg_bet_vc_status_cs_cnt[temp_pc_trans_ins.param0]))

      end //}

    end //}


    if (temp_pc_trans_ins.param0 == 1)
    begin //{
      pl_pc_trans.vc_status_cs_cnt_check_started[temp_pc_trans_ins.param0] = 1;
      pl_pc_trans.num_cg_bet_vc_status_cs_cnt[temp_pc_trans_ins.param0] = 1;
      pl_pc_trans.num_cg_bet_vc_status_cs_cnt[temp_pc_trans_ins.param0] = 0;
    end //}
    else if (pl_pc_env_config.vc_num_support >= 2 && temp_pc_trans_ins.param0 == 5)
    begin //{
      pl_pc_trans.vc_status_cs_cnt_check_started[temp_pc_trans_ins.param0] = 1;
      pl_pc_trans.num_cg_bet_vc_status_cs_cnt[temp_pc_trans_ins.param0] = 1;
      pl_pc_trans.num_cg_bet_vc_status_cs_cnt[temp_pc_trans_ins.param0] = 0;
    end //}
    else if (pl_pc_env_config.vc_num_support >= 4 && (temp_pc_trans_ins.param0 == 3 || temp_pc_trans_ins.param0 == 7))
    begin //{
      pl_pc_trans.vc_status_cs_cnt_check_started[temp_pc_trans_ins.param0] = 1;
      pl_pc_trans.num_cg_bet_vc_status_cs_cnt[temp_pc_trans_ins.param0] = 1;
      pl_pc_trans.num_cg_bet_vc_status_cs_cnt[temp_pc_trans_ins.param0] = 0;
    end //}
    else if (pl_pc_env_config.vc_num_support == 8)
    begin //{
      pl_pc_trans.vc_status_cs_cnt_check_started[temp_pc_trans_ins.param0] = 1;
      pl_pc_trans.num_cg_bet_vc_status_cs_cnt[temp_pc_trans_ins.param0] = 1;
      pl_pc_trans.num_cg_bet_vc_status_cs_cnt[temp_pc_trans_ins.param0] = 0;
    end //}

  end //}

endtask : cntl_symbol_vc_status_cs_cnt_check





///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : link_req_after_sync_seq_check
/// Description : This method checks if link request control symbol is preceded by descrambler
/// sync sequence or not. sync_seq_detected flag is set by rx_data_handler block and it is
/// checked in this method.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::link_req_after_sync_seq_check();

  if (pl_pc_trans.sync_seq_detected)
  begin //{

    pl_pc_trans.sync_seq_detected = 0;

    `uvm_info("SRIO_PL_PROTOCOL_CHECKER : PACKET_ACK_RECEIVED", $sformatf(" Link request control symbol received. cmd field is %0d", temp_pc_trans_ins.cmd), UVM_MEDIUM)

  end //}
  else
  begin //{

    `uvm_error("SRIO_PL_PROTOCOL_CHECKER : LINK_REQ_AFTER_SYNC_SEQ_CHECK", $sformatf(" Spec reference 4.8.2. Link request is not preceded by descrambler sync sequence."))

  end //}

endtask : link_req_after_sync_seq_check





///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : status_cs_timer_method
/// Description : This method runs forever and triggers an error if no. of codegroups/codewords
/// without a status control symbol exceeds the expected interval.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::status_cs_timer_method();

  int status_cs_timer_method_cg_cnt;
  int temp_num_cg_bet_status_cs_cnt;
  int local_status_cs_freq_err;

  forever begin //{

    @(negedge srio_if.sim_clk);

    if (~pl_pc_common_mon_trans.port_initialized[~mon_type] && pl_pc_trans.status_cs_cnt_check_started)
    begin //{
      pl_pc_trans.status_cs_cnt_check_started = 0;
      pl_pc_trans.num_cg_bet_status_cs_cnt = 0;
    end //}

    wait (pl_pc_common_mon_trans.port_initialized[~mon_type] == 1);

    pl_pc_trans.status_cs_cnt_check_started = 1;

    if (pl_pc_trans.current_init_state == NX_MODE && pl_pc_trans.num_cg_bet_status_cs_cnt >= 2)
      temp_num_cg_bet_status_cs_cnt = pl_pc_trans.num_cg_bet_status_cs_cnt-2;
    else if (pl_pc_trans.current_init_state == X2_MODE && pl_pc_trans.num_cg_bet_status_cs_cnt >= 4)
      temp_num_cg_bet_status_cs_cnt = pl_pc_trans.num_cg_bet_status_cs_cnt-4;
    else if ((pl_pc_trans.current_init_state == X1_M0 || pl_pc_trans.current_init_state == X1_M1 || pl_pc_trans.current_init_state == X1_M2) && pl_pc_trans.num_cg_bet_status_cs_cnt >= 8)
      temp_num_cg_bet_status_cs_cnt = pl_pc_trans.num_cg_bet_status_cs_cnt-8;

    if (pl_pc_trans.num_cg_bet_status_cs_cnt == 0)
      temp_num_cg_bet_status_cs_cnt = 0;

    if (~report_error && temp_num_cg_bet_status_cs_cnt > pl_pc_config.code_group_sent_2_cs)
    begin //{
      local_status_cs_freq_err = 1;
      status_cs_timer_method_cg_cnt = pl_pc_config.code_group_sent_2_cs;
    end //}
    else if (report_error && temp_num_cg_bet_status_cs_cnt > 1024)
    begin //{
      local_status_cs_freq_err = 1;
      status_cs_timer_method_cg_cnt = 1024;
    end //}
  
    if (local_status_cs_freq_err)
    begin //{

      -> pl_pc_trans.status_cs_blocked;
      
      local_status_cs_freq_err = 0;
      
      `uvm_error("SRIO_PL_PROTOCOL_CHECKER : CG_BETWEEN_STAT_CS_CHECK", $sformatf(" Spec reference 5.5.3.1. Number of code groups received without a status control symbols exceeded the expected count of %0d", status_cs_timer_method_cg_cnt))

      pl_pc_trans.num_cg_bet_status_cs_cnt = 0;
      temp_num_cg_bet_status_cs_cnt = 0;

    end //}

  end //}

endtask : status_cs_timer_method





/////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : stype0_link_timeout_check
/// Description : This method checks if the scheduled stype0 control symbols are received within
/// link_timeout period. All the methods which schedules the stype0 control symbol will also
/// load the timeout value in its corresponding timer array. This method will decrement all the
/// loaded timers for every sim_clk period till it expires and triggers an error for the same.
/////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::stype0_link_timeout_check();

  forever begin //{

    @(negedge srio_if.sim_clk);

    wait(pl_pc_common_mon_trans.link_initialized[mon_type] == 1 && pl_pc_common_mon_trans.link_initialized[~mon_type] == 1);

    wait(pl_pc_common_mon_trans.pkt_ack_timer_stype0.exists(mon_type));

    if (pl_pc_common_mon_trans.pkt_ack_timer_stype0[mon_type].size() == 0)
      continue;

    for (int stype0_ack_timer_chk=0; stype0_ack_timer_chk<pl_pc_common_mon_trans.pkt_ack_timer_stype0[mon_type].size(); stype0_ack_timer_chk++)
    begin //{

      pl_pc_common_mon_trans.pkt_ack_timer_stype0[mon_type][stype0_ack_timer_chk]--;

      if (pl_pc_common_mon_trans.pkt_ack_timer_stype0[mon_type][stype0_ack_timer_chk] == 0)
      begin //{

	pl_pc_common_mon_trans.pkt_ack_timer_stype0[mon_type].delete(stype0_ack_timer_chk);

	timeout_trans = new pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type][stype0_ack_timer_chk];
	pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type].delete(stype0_ack_timer_chk);
        if (~pl_pc_trans.oes_state && pl_pc_trans.port_initialized)
        begin //{
          pl_pc_trans.oes_state = 1;
          pl_pc_common_mon_trans.oes_state_detected[mon_type] = 1;
        end //}

	if (timeout_trans.stype0 == 3'b000)
	begin //{

	  pl_pc_common_mon_trans.pl_outstanding_ackid[~mon_type][timeout_trans.param0] = 0;
      	  pl_pc_common_mon_trans.pkt_acc_timeout_occured[~mon_type] = 1;

	  -> pl_pc_env_config.pkt_acc_timeout_evt;
    	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : PACC_LINK_TIMEOUT_CHECK", $sformatf(" Spec reference 6.6.2. Link timeout occured when expecting for Packet accepted control symbol with ackid %0d", timeout_trans.param0))

	end //}
	else if (timeout_trans.stype0 == 3'b010)
	begin //{

	  -> pl_pc_env_config.pkt_nacc_timeout_evt;
    	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : PNA_LINK_TIMEOUT_CHECK", $sformatf(" Spec reference 5.13.2.7. Link timeout occured when expecting for Packet not accepted control symbol with cause %0d. Input error recovery not initiated.", timeout_trans.param1))

	end //}
	else if (timeout_trans.stype0 == 3'b110)
	begin //{

	  -> pl_pc_env_config.link_resp_timeout_evt;
    	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : LINK_RESP_LINK_TIMEOUT_CHECK", $sformatf(" Spec reference 6.6.2. Link timeout occured when expecting for link response control symbol with ackid_status %0d.", timeout_trans.param0))
          pl_pc_common_mon_trans.outstanding_link_req[~mon_type]=0;
         ies_err_reg=0;
	end //}
	else if ((timeout_trans.stype0 == 4'b0011 && pl_pc_env_config.srio_mode != SRIO_GEN30) || (timeout_trans.stype0 == 4'b1011 && pl_pc_env_config.srio_mode == SRIO_GEN30))
	begin //{
	  -> pl_pc_env_config.loop_resp_timeout_evt;

    	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : LOOP_RESP_LINK_TIMEOUT_CHECK", $sformatf(" Spec reference 6.6.2. Link timeout occured when expecting for loop response control symbol."))

	end //}

	update_pnescsr_port_error_field();
	update_error_detect_csr("LINK_TIMEOUT");

	break;

      end //}

    end //}

  end //}

endtask : stype0_link_timeout_check




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : stype1_link_timeout_check
/// Description : This method checks if the scheduled stype1 control symbols are received within
/// link_timeout period. All the methods which schedules the stype1 control symbol will also
/// load the timeout value in its corresponding timer array. This method will decrement all the
/// loaded timers for every sim_clk period till it expires and triggers an error for the same.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::stype1_link_timeout_check();

  forever begin //{

    @(negedge srio_if.sim_clk);

    wait(pl_pc_common_mon_trans.link_initialized[mon_type] == 1 && pl_pc_common_mon_trans.link_initialized[~mon_type] == 1);

    wait(pl_pc_common_mon_trans.pkt_ack_timer_stype1.exists(mon_type));

    if (pl_pc_common_mon_trans.pkt_ack_timer_stype1[mon_type].size() == 0)
      continue;

    for (int stype1_ack_timer_chk=0; stype1_ack_timer_chk<pl_pc_common_mon_trans.pkt_ack_timer_stype1[mon_type].size(); stype1_ack_timer_chk++)
    begin //{

      pl_pc_common_mon_trans.pkt_ack_timer_stype1[mon_type][stype1_ack_timer_chk]--;

      if (pl_pc_common_mon_trans.pkt_ack_timer_stype1[mon_type][stype1_ack_timer_chk] == 0)
      begin //{

	pl_pc_common_mon_trans.pkt_ack_timer_stype1[mon_type].delete(stype1_ack_timer_chk);

	timeout_trans = new pl_pc_common_mon_trans.outstanding_pkt_ack_stype1[mon_type][stype1_ack_timer_chk];
	pl_pc_common_mon_trans.outstanding_pkt_ack_stype1[mon_type].delete(stype1_ack_timer_chk);

	if (timeout_trans.stype1 == 3'b100)
	begin //{

	  -> pl_pc_env_config.link_req_timeout_evt;
    	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : LINK_REQ_LINK_TIMEOUT_CHECK", $sformatf(" Spec reference 5.7. Link timeout occured when expecting for link request control symbol with cmd %0d.", timeout_trans.cmd))

	end //}
	else if (timeout_trans.stype1 == 3'b011)
	begin //{

	  -> pl_pc_env_config.rfr_timeout_evt;
    	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : RFR_LINK_TIMEOUT_CHECK", $sformatf(" Link timeout occured when expecting for restart-from-retry control symbol."))

	end //}
	else if (timeout_trans.stype1 == 3'b101 && timeout_trans.cmd == 3'b011)
	begin //{
	  -> pl_pc_env_config.loop_req_timeout_evt;

    	  `uvm_error("SRIO_PL_PROTOCOL_CHECKER : LOOP_REQ_LINK_TIMEOUT_CHECK", $sformatf(" Link timeout occured when expecting for Loop request control symbol."))

	end //}

	update_pnescsr_port_error_field();

	break;

      end //}

    end //}

  end //}

endtask : stype1_link_timeout_check





///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : pop_received_pkt_q_on_ack_timeout
/// Description : This method pops the received_packet_q when its corresponding acknowledgement
/// is timed out.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::pop_received_pkt_q_on_ack_timeout();

  forever begin //{

    wait(pl_pc_common_mon_trans.pkt_acc_timeout_occured[mon_type] == 1);

    // TODO : check if packet has to be passed to upper layer on timeout or
    // should be cleared. Currently it is clearing.
    if (received_packet_q.size() > 0)
      void'(received_packet_q.pop_front());

    pl_pc_common_mon_trans.pkt_acc_timeout_occured[mon_type] = 0;

  end //}

endtask : pop_received_pkt_q_on_ack_timeout





///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : get_timestamp_vars
/// Description : This method gets the various timestamp related configurations and variables
/// either from the config variables or from the register model. The capabilities are read
/// when reset is cleared, and the controls are polled for every sim_clk period.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::get_timestamp_vars();

  @(posedge srio_if.srio_rst_n);

  if ((mon_type && pl_pc_env_config.srio_tx_mon_if == DUT) || (~mon_type && pl_pc_env_config.srio_rx_mon_if == DUT))
  begin //{
    check_timestamp_supp_for_dut_if = 1;
  end //}
  else if ((mon_type && pl_pc_env_config.srio_tx_mon_if == BFM) || (~mon_type && pl_pc_env_config.srio_rx_mon_if == BFM))
  begin //{
    check_timestamp_supp_for_dut_if = 0;
  end //}

  if (check_timestamp_supp_for_dut_if)
  begin //{
    pl_pc_trans.timestamp_support = pl_pc_config.timestamp_sync_support;
  end //}
  else if (~check_timestamp_supp_for_dut_if)
  begin //{

    @(posedge srio_if.sim_clk);
    timestamp_car_master_support = pl_pc_reg_model.Timestamp_CAR.Timestamp_Master_Supported.get();
    timestamp_car_slave_support = pl_pc_reg_model.Timestamp_CAR.Timestamp_Slave_Supported.get();

    pl_pc_trans.timestamp_support = timestamp_car_master_support | timestamp_car_slave_support;

  end //}

  if (~pl_pc_trans.timestamp_support)
    return;

  forever begin //{

    wait(pl_pc_trans.link_initialized == 1);

    @(posedge srio_if.sim_clk);

    if (check_timestamp_supp_for_dut_if)
    begin //{

      pl_pc_trans.timestamp_master = pl_pc_config.timestamp_master_slave_support;
      pl_pc_timestamp_auto_update_en = pl_pc_config.timestamp_master_slave_support & pl_pc_config.timestamp_auto_update_en;
      pl_pc_send_zero_timestamp = pl_pc_config.timestamp_master_slave_support & pl_pc_trans.send_zero_timestamp;
      pl_pc_send_timestamp = pl_pc_config.timestamp_master_slave_support & pl_pc_trans.send_timestamp;
      pl_pc_send_loop_request = pl_pc_config.timestamp_master_slave_support & pl_pc_trans.send_loop_request;

    end //}
    else
    begin //{

      register_update_method("Timestamp_Generator_Synchronization_CSR", "Port_Opening_Mode", 64, "pl_pc_reg_model", reqd_field_name["Port_Opening_Mode"]);
      timestamp_port_operating_mode = reqd_field_name["Port_Opening_Mode"].get();
      //timestamp_port_operating_mode = pl_pc_reg_model.Port_0_Timestamp_Generator_Synchronization_CSR.Port_Opening_Mode.get();
      timestamp_port_operating_mode = {timestamp_port_operating_mode[0], timestamp_port_operating_mode[1]};

      if (timestamp_port_operating_mode == 2'b10)
      begin //{

        pl_pc_trans.timestamp_master = 1;
        register_update_method("Timestamp_Generator_Synchronization_CSR", "Auto_Update_Link_Partner_Timestamp_Generators", 64, "pl_pc_reg_model", reqd_field_name["Auto_Update_Link_Partner_Timestamp_Generators"]);
        pl_pc_timestamp_auto_update_en = reqd_field_name["Auto_Update_Link_Partner_Timestamp_Generators"].get();
        //pl_pc_timestamp_auto_update_en = pl_pc_reg_model.Port_0_Timestamp_Generator_Synchronization_CSR.Auto_Update_Link_Partner_Timestamp_Generators.get();
        register_update_method("Timestamp_Synchronization_Command_CSR", "Send_Zero_Timestamp", 64, "pl_pc_reg_model", reqd_field_name["Send_Zero_Timestamp"]);
        pl_pc_send_zero_timestamp = reqd_field_name["Send_Zero_Timestamp"].get();
        //pl_pc_send_zero_timestamp = pl_pc_reg_model.Port_0_Timestamp_Synchronization_Command_CSR.Send_Zero_Timestamp.get();
        register_update_method("Timestamp_Synchronization_Command_CSR", "Send_Timestamp", 64, "pl_pc_reg_model", reqd_field_name["Send_Timestamp"]);
        pl_pc_send_timestamp = reqd_field_name["Send_Timestamp"].get();
        //pl_pc_send_timestamp = pl_pc_reg_model.Port_0_Timestamp_Synchronization_Command_CSR.Send_Timestamp.get();
        register_update_method("Timestamp_Synchronization_Command_CSR", "Command", 64, "pl_pc_reg_model", reqd_field_name["Command"]);
        temp_send_loop_request= reqd_field_name["Command"].get();
        //temp_send_loop_request= pl_pc_reg_model.Port_0_Timestamp_Synchronization_Command_CSR.Command.get();
        temp_send_loop_request = {temp_send_loop_request[0], temp_send_loop_request[1], temp_send_loop_request[2]};
        if (temp_send_loop_request == 3'b011)
          pl_pc_send_loop_request = 1;
        else
          pl_pc_send_loop_request = 0;

      end //}

    end //}

  end //}

endtask : get_timestamp_vars





///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : timestamp_auto_update_timer_method
/// Description : This method runs a timer for timestamp sequence and triggers an error if the
/// timer expires. It also triggers an error if timestamp sequence is received unexpectedly.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::timestamp_auto_update_timer_method();

  forever begin //{

    wait(pl_pc_timestamp_auto_update_en == 1 || pl_pc_send_timestamp == 1 || pl_pc_send_zero_timestamp == 1 || pl_pc_common_mon_trans.timestamp_seq_started[~mon_type] == 1);

    if (pl_pc_common_mon_trans.timestamp_seq_started[~mon_type] && ~pl_pc_timestamp_auto_update_en && ~pl_pc_send_timestamp && ~pl_pc_send_zero_timestamp)
    begin //{
      `uvm_error("SRIO_PL_PROTOCOL_CHECKER : UNEXP_TIMESTAMP_SEQ_CHECK", $sformatf(" Spec reference 6.5.3.5. Timestamp sequence received when it is not expected. Neither auto update is enabled nor send_timestamp is set nor send_zero_timestamp is set."))
      wait (pl_pc_common_mon_trans.timestamp_seq_completed[~mon_type] == 1);
      pl_pc_common_mon_trans.timestamp_seq_started[~mon_type] = 0;
      pl_pc_common_mon_trans.timestamp_seq_completed[~mon_type] = 0;
      continue;
    end //}

    repeat(pl_pc_config.timestamp_auto_update_timer)
    begin //{

      if (~pl_pc_common_mon_trans.timestamp_seq_started[~mon_type])
      begin //{
	@(posedge srio_if.sim_clk);
      end //}
      else
      begin //{
	break;
      end //}

    end //}

    if (~pl_pc_common_mon_trans.timestamp_seq_started[~mon_type])
    begin //{
      `uvm_error("SRIO_PL_PROTOCOL_CHECKER : TIMESTAMP_SEQ_TMR_CHECK", $sformatf(" Spec reference 6.5.3.5. Expecting timestamp sequence, but it is not received till the timer expires."))
    end //}
    else
    begin //{
      wait (pl_pc_common_mon_trans.timestamp_seq_completed[~mon_type] == 1);
      pl_pc_common_mon_trans.timestamp_seq_started[~mon_type] = 0;
      pl_pc_common_mon_trans.timestamp_seq_completed[~mon_type] = 0;
    end //}

    if (pl_pc_send_timestamp)
    begin //{

      // Since no events from register model is supported currently, the variables and
      // register bit are cleared by the monitor itself.

      pl_pc_send_timestamp = 0;
      pl_pc_trans.send_timestamp = 0;
      register_update_method("Timestamp_Synchronization_Command_CSR", "Send_Timestamp", 64, "pl_pc_reg_model", reqd_field_name["Send_Timestamp"]);
      void'(reqd_field_name["Send_Timestamp"].predict(0));
      //void'(pl_pc_reg_model.Port_0_Timestamp_Synchronization_Command_CSR.Send_Timestamp.predict(0));

    end //}

    if (pl_pc_send_zero_timestamp)
    begin //{

      // Since no events from register model is supported currently, the variables and
      // register bit are cleared by the monitor itself.

      pl_pc_send_zero_timestamp = 0;
      pl_pc_trans.send_zero_timestamp = 0;
      register_update_method("Timestamp_Synchronization_Command_CSR", "Send_Zero_Timestamp", 64, "pl_pc_reg_model", reqd_field_name["Send_Zero_Timestamp"]);
      void'(reqd_field_name["Send_Zero_Timestamp"].predict(0));
      //void'(pl_pc_reg_model.Port_0_Timestamp_Synchronization_Command_CSR.Send_Zero_Timestamp.predict(0));

    end //}

  end //}

endtask : timestamp_auto_update_timer_method





///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : schedule_loop_timing_request
/// Description : This method runs forever and waits for send loop_request to be set. If set,
/// it will schedule loop_request control for the other monitor's stype1 outstanding queue.
/// After this, it will clear send loop_request inorder to make sure that only one loop_request
/// is scheduled.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::schedule_loop_timing_request();

  forever begin //{

    wait(pl_pc_send_loop_request == 1);

    `uvm_info("SRIO_PL_PROTOCOL_CHECKER : LOOP_TIMING_REQUEST", $sformatf(" loop timing request control symbol requested"), UVM_MEDIUM)

    temp_exp_trans = new();
    temp_exp_trans.env_config = pl_pc_env_config;
    temp_exp_trans.transaction_kind = SRIO_CS;
    temp_exp_trans.stype1 = 3'b101;

    temp_exp_trans.cmd = 3'b011;

    exp_trans = new temp_exp_trans;
    exp_trans.env_config = pl_pc_env_config;

    pl_pc_common_mon_trans.outstanding_pkt_ack_stype1[~mon_type].push_back(exp_trans);
    pl_pc_common_mon_trans.pkt_ack_timer_stype1[~mon_type].push_back(pl_pc_config.link_timeout);

    pl_pc_send_loop_request = 0;
    pl_pc_trans.send_loop_request = 0;
    register_update_method("Timestamp_Synchronization_Command_CSR", "Command", 64, "pl_pc_reg_model", reqd_field_name["Command"]);
    void'(reqd_field_name["Command"].predict(3'b000));
    //void'(pl_pc_reg_model.Port_0_Timestamp_Synchronization_Command_CSR.Command.predict(3'b000));

  end //}

endtask : schedule_loop_timing_request




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_loop_resp
/// Description : This method runs forever and waits for outstanding_loop_req flag to be set.
/// Once set, it will schedule loop_response control symbol for the other monitor's outstanding
/// stype0 queue and waits for the outstanding_loop_req flag to be cleared.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::gen_loop_resp();

  forever begin //{

    wait(pl_pc_common_mon_trans.outstanding_loop_req[mon_type] == 1);

    temp_exp_trans = new();
    temp_exp_trans.env_config = pl_pc_env_config;
    temp_exp_trans.transaction_kind = SRIO_CS;
    if (pl_pc_env_config.srio_mode != SRIO_GEN30)
      temp_exp_trans.stype0 = 4'b0011;
    else
      temp_exp_trans.stype0 = 4'b1011;

    exp_trans = new temp_exp_trans;
    exp_trans.env_config = pl_pc_env_config;

    pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[~mon_type].push_back(exp_trans);
    pl_pc_common_mon_trans.pkt_ack_timer_stype0[~mon_type].push_back(pl_pc_config.link_timeout);

    wait(pl_pc_common_mon_trans.outstanding_loop_req[mon_type] == 0);

  end //}

endtask : gen_loop_resp



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_retry_cs
/// Description : This method runs forever and waits for outstanding_rfr flag to be set.
/// Once set, it will schedule retry control symbol for the other monitor's outstanding
/// stype1 queue and waits for the outstanding_rfr flag to be cleared.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::gen_retry_cs();

  forever begin //{

    wait(pl_pc_common_mon_trans.outstanding_retry[mon_type] == 1);
    temp_exp_trans = new();
    temp_exp_trans.env_config = pl_pc_env_config;
    temp_exp_trans.transaction_kind = SRIO_CS;
    if (pl_pc_env_config.srio_mode != SRIO_GEN30)
      temp_exp_trans.stype0 = 4'b0001;
    else
      temp_exp_trans.stype0 = 4'b0001;

    exp_trans = new temp_exp_trans;
    exp_trans.env_config = pl_pc_env_config;

    pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[~mon_type].push_back(exp_trans);
    pl_pc_common_mon_trans.pkt_ack_timer_stype0[~mon_type].push_back(pl_pc_config.link_timeout);

    wait(pl_pc_common_mon_trans.outstanding_retry[mon_type] == 0);

  end //}

endtask : gen_retry_cs




//////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : check_multiple_ack_support
/// Description : This method reads the multiple ack support, enable and ackid in pna cs support
/// and its enable, and updates the corresponding local variables to be used by other methods.
//////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::check_multiple_ack_support();

  if (pl_pc_env_config.srio_mode != SRIO_GEN30 && pl_pc_env_config.spec_support != V30)
    return;

  if ((mon_type && pl_pc_env_config.srio_tx_mon_if == DUT) || (~mon_type && pl_pc_env_config.srio_rx_mon_if == DUT))
  begin //{
    check_mult_ack_supp_for_dut_if = 1;
  end //}
  else if ((mon_type && pl_pc_env_config.srio_tx_mon_if == BFM) || (~mon_type && pl_pc_env_config.srio_rx_mon_if == BFM))
  begin //{
    check_mult_ack_supp_for_dut_if = 0;
  end //}

  if (check_mult_ack_supp_for_dut_if)
  begin //{

    pl_pc_multiple_ack_support = pl_pc_config.multiple_ack_support;
    pl_pc_pna_ackid_support = pl_pc_config.ackid_status_pnack_support;

  end //}
  else
  begin //{

    register_update_method("Latency_Optimization_CSR", "Multiple_Acknowledges_Supported", 64, "pl_pc_reg_model", reqd_field_name["Multiple_Acknowledges_Supported"]);
    temp_mult_ack_support = reqd_field_name["Multiple_Acknowledges_Supported"].get();
    //temp_mult_ack_support = pl_pc_reg_model.Port_0_Latency_Optimization_CSR.Multiple_Acknowledges_Supported.get();
    register_update_method("Latency_Optimization_CSR", "Multiple_Acknowledges_Enabled", 64, "pl_pc_reg_model", reqd_field_name["Multiple_Acknowledges_Enabled"]);
    temp_mult_ack_enable = reqd_field_name["Multiple_Acknowledges_Enabled"].get();
    //temp_mult_ack_enable = pl_pc_reg_model.Port_0_Latency_Optimization_CSR.Multiple_Acknowledges_Enabled.get();
    register_update_method("Latency_Optimization_CSR", "Error_Recovery_with_AckID_in_PNA_Supported", 64, "pl_pc_reg_model", reqd_field_name["Error_Recovery_with_AckID_in_PNA_Supported"]);
    temp_pna_ackid_support = reqd_field_name["Error_Recovery_with_AckID_in_PNA_Supported"].get();
    //temp_pna_ackid_support = pl_pc_reg_model.Port_0_Latency_Optimization_CSR.Error_Recovery_with_AckID_in_PNA_Supported.get();
    register_update_method("Latency_Optimization_CSR", "Error_Recovery_with_AckID_in_PNA_Enabled", 64, "pl_pc_reg_model", reqd_field_name["Error_Recovery_with_AckID_in_PNA_Enabled"]);
    temp_pna_ackid_enable = reqd_field_name["Error_Recovery_with_AckID_in_PNA_Enabled"].get();
    //temp_pna_ackid_enable = pl_pc_reg_model.Port_0_Latency_Optimization_CSR.Error_Recovery_with_AckID_in_PNA_Enabled.get();

    pl_pc_multiple_ack_support = temp_mult_ack_support & temp_mult_ack_enable;
    pl_pc_pna_ackid_support = temp_pna_ackid_support & temp_pna_ackid_enable;

  end //}

endtask : check_multiple_ack_support





///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : clear_pending_acknowledgements
/// Description : This method clears all the pending acknowledgements till the ackid value in
/// the received control symbol. If pna is encountered inbetween the scheduled acknowledgements
/// then the loop inside this method is broken and returned. This method is called in case of
/// multiple ack enable.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::clear_pending_acknowledgements();

  bit loop_broken;
  bit exit_loop;
  bit [0:11] next_ackid_to_match;

  loop_broken = 0;
  exit_loop = 0;

  next_ackid_to_match = temp_pc_trans_ins.param0;

  temp_pkt_ack_trans = new exp_comp_trans;

  if (temp_pkt_ack_trans.param0 < next_ackid_to_match || ((temp_pkt_ack_trans.param0 > next_ackid_to_match) && (pl_pc_common_mon_trans.pl_outstanding_ackid[~mon_type][next_ackid_to_match] == 1)))
  begin //{

     `uvm_info("SRIO_PL_PROTOCOL_CHECKER : MULTIPLE_PACKET_ACK_RECEIVED", $sformatf(" Clearing Packet accepted control symbol with ackid %0h", temp_pkt_ack_trans.param0), UVM_MEDIUM)

    if (temp_pkt_ack_trans.param0 == 63 && pl_pc_trans.idle_selected && pl_pc_env_config.srio_mode != SRIO_GEN30)
      next_ackid_to_match = 0;
    else if (temp_pkt_ack_trans.param0 == 31 && ~pl_pc_trans.idle_selected && pl_pc_env_config.srio_mode != SRIO_GEN30)
      next_ackid_to_match = 0;
    else if (temp_pkt_ack_trans.param0 == 4095 && pl_pc_env_config.srio_mode == SRIO_GEN30)
      next_ackid_to_match = 0;
    else
      next_ackid_to_match = temp_pkt_ack_trans.param0+1;

    exp_cs_ackid = next_ackid_to_match;

    pl_pc_common_mon_trans.pl_outstanding_ackid[~mon_type][temp_pkt_ack_trans.param0] = 0;

    pl_pc_common_mon_trans.num_outstanding_pkts[~mon_type]--;

    if (pl_pc_env_config.multi_vc_support)
    begin //{
      pop_vc_q_on_pkt_acc(temp_pkt_ack_trans);
    end //}

  end //}
  else if (temp_pkt_ack_trans.param0 >= next_ackid_to_match)
  begin //{
    exit_loop = 1;
  end //}

  while (~exit_loop)
  begin //{

    temp_outst_ack_q_size = pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type].size();

    for (int chk_pa=0; chk_pa<temp_outst_ack_q_size; chk_pa++)
    begin //{

      exp_comp_trans = new pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type][chk_pa];

      if (pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type][chk_pa].stype0 == 3'b000)
      begin //{

        temp_pkt_ack_trans = new pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type][chk_pa];

        if (temp_pkt_ack_trans.param0 < temp_pc_trans_ins.param0 || ((temp_pkt_ack_trans.param0 > temp_pc_trans_ins.param0) && (pl_pc_common_mon_trans.pl_outstanding_ackid[~mon_type][temp_pc_trans_ins.param0] == 1)))
        begin //{

     	  `uvm_info("SRIO_PL_PROTOCOL_CHECKER : MULTIPLE_PACKET_ACK_RECEIVED", $sformatf(" Clearing Packet accepted control symbol with ackid %0h", temp_pkt_ack_trans.param0), UVM_MEDIUM)

          pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type].delete(chk_pa);
          pl_pc_common_mon_trans.pkt_ack_timer_stype0[mon_type].delete(chk_pa);

          if (temp_pkt_ack_trans.param0 == 63 && pl_pc_trans.idle_selected && pl_pc_env_config.srio_mode != SRIO_GEN30)
            next_ackid_to_match = 0;
          else if (temp_pkt_ack_trans.param0 == 31 && ~pl_pc_trans.idle_selected && pl_pc_env_config.srio_mode != SRIO_GEN30)
            next_ackid_to_match = 0;
          else if (temp_pkt_ack_trans.param0 == 4095 && pl_pc_env_config.srio_mode == SRIO_GEN30)
            next_ackid_to_match = 0;
          else
            next_ackid_to_match = temp_pkt_ack_trans.param0+1;

    	  exp_cs_ackid = next_ackid_to_match;

          pl_pc_common_mon_trans.pl_outstanding_ackid[~mon_type][temp_pkt_ack_trans.param0] = 0;

          pl_pc_common_mon_trans.num_outstanding_pkts[~mon_type]--;

          if (pl_pc_env_config.multi_vc_support)
          begin //{
            pop_vc_q_on_pkt_acc(temp_pkt_ack_trans);
          end //}

	  loop_broken = 1;
          break;

        end //}
        else if (temp_pkt_ack_trans.param0 >= temp_pc_trans_ins.param0)
        begin //{
	  if (temp_pkt_ack_trans.param0 == temp_pc_trans_ins.param0)
	  begin //{
            pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type].delete(chk_pa);
            pl_pc_common_mon_trans.pkt_ack_timer_stype0[mon_type].delete(chk_pa);
	  end //}
	  loop_broken = 1;
          exit_loop = 1;
          break;
        end //}

      end //}
      else if (check_for_pna && pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type][chk_pa].stype0 == 3'b010)
      begin //{
	check_for_pna = 0;
	loop_broken = 1;
        exit_loop = 1;
        break;
      end //}

    end //}

    if (~loop_broken)
    begin //{
      exit_loop = 1;
    end //}

    loop_broken = 0;

  end //}

endtask : clear_pending_acknowledgements





/////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : clear_vars_on_reset
/// Description : This method clears all the required flags, arrays and queues when reset is applied.
/////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::clear_vars_on_reset();

  forever begin //{

    @(negedge srio_if.srio_rst_n);

    pl_pc_common_mon_trans.outstanding_rfr[mon_type] = 0;
    pl_pc_common_mon_trans.outstanding_retry[mon_type] = 0;
    pl_pc_common_mon_trans.outstanding_link_req[mon_type] = 0;
    pl_pc_common_mon_trans.oes_state_detected[mon_type] = 0;

    pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type] = {}; // delete all outstanding ack
    pl_pc_common_mon_trans.pkt_ack_timer_stype0[mon_type] = {};	// delete all timers for outstanding ack
    pl_pc_common_mon_trans.num_outstanding_pkts[mon_type] = 0;
    pl_pc_common_mon_trans.ackid_status[mon_type] = 0;
    pl_pc_common_mon_trans.update_exp_pkt_ackid[mon_type] = 0;

    received_packet_q.delete();

    if (pl_pc_common_mon_trans.pl_outstanding_ackid[~mon_type].first(link_req_arr_idx))
    begin //{

      do begin //{

	$display($time, " Clearing pl_outstanding_ackid in reset. link_req_arr_idx is %0d", link_req_arr_idx);

	pl_pc_common_mon_trans.pl_outstanding_ackid[~mon_type][link_req_arr_idx] = 0;

      end while(pl_pc_common_mon_trans.pl_outstanding_ackid[~mon_type].next(link_req_arr_idx)); //}

    end //}

    exp_pkt_ackid = 0;
    exp_cs_ackid = 0;

    pl_pc_trans.ies_state = 0;
    pl_pc_trans.oes_state = 0;
    pl_pc_trans.irs_state = 0;
    pl_pc_trans.ors_state = 0;

  end //}

endtask : clear_vars_on_reset




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : update_link_maint_resp_reg_resp_valid
/// Description : This method updates response_valid field of Link maintenance response CSR.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::update_link_maint_resp_reg_resp_valid();

      if (mon_type)
      begin //{
    	register_update_method("Link_Maintenance_Response_CSR", "response_valid", 64, "pl_pc_reg_model_tx", reqd_field_name["response_valid"]);
    	void'(reqd_field_name["response_valid"].predict(1));
	//void'(pl_pc_env_config.srio_reg_model_tx.Port_0_Link_Maintenance_Response_CSR.response_valid.predict(1));
      end //}
      else
      begin //{
    	register_update_method("Link_Maintenance_Response_CSR", "response_valid", 64, "pl_pc_reg_model_rx", reqd_field_name["response_valid"]);
    	void'(reqd_field_name["response_valid"].predict(1));
	//void'(pl_pc_env_config.srio_reg_model_rx.Port_0_Link_Maintenance_Response_CSR.response_valid.predict(1));
      end //}

endtask : update_link_maint_resp_reg_resp_valid




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : update_link_maint_resp_reg
/// Description : This method updates Link maintenance response CSR fields.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::update_link_maint_resp_reg();

  bit [0:11] reg_param0;
  bit [0:11] reg_param1;

    register_update_method("Link_Maintenance_Response_CSR", "response_valid", 64, "pl_pc_reg_model", reqd_field_name["response_valid"]);
    void'(reqd_field_name["response_valid"].predict(1));
    //void'(pl_pc_reg_model.Port_0_Link_Maintenance_Response_CSR.response_valid.predict(1));

    if (pl_pc_trans.idle_detected && ~pl_pc_trans.idle_selected && pl_pc_env_config.srio_mode != SRIO_GEN30)
    begin //{
      reg_param0 = {temp_pc_trans_ins.param0[11], temp_pc_trans_ins.param0[10], temp_pc_trans_ins.param0[9], temp_pc_trans_ins.param0[8], temp_pc_trans_ins.param0[7], 7'b000_0000};
      reg_param1 = {temp_pc_trans_ins.param1[11], temp_pc_trans_ins.param1[10], temp_pc_trans_ins.param1[9], temp_pc_trans_ins.param1[8], temp_pc_trans_ins.param1[7]};
    end //}
    else if (pl_pc_trans.idle_detected && pl_pc_trans.idle_selected && pl_pc_env_config.srio_mode != SRIO_GEN30)
    begin //{
      reg_param0 = {temp_pc_trans_ins.param0[11], temp_pc_trans_ins.param0[10], temp_pc_trans_ins.param0[9], temp_pc_trans_ins.param0[8], temp_pc_trans_ins.param0[7], temp_pc_trans_ins.param0[6], 6'b00_0000};
      reg_param1 = {temp_pc_trans_ins.param1[11], temp_pc_trans_ins.param1[10], temp_pc_trans_ins.param1[9], temp_pc_trans_ins.param1[8], temp_pc_trans_ins.param1[7]};
    end //}
    else if (pl_pc_env_config.srio_mode == SRIO_GEN30)
    begin //{
      reg_param0 = {temp_pc_trans_ins.param0[11], temp_pc_trans_ins.param0[10], temp_pc_trans_ins.param0[9], temp_pc_trans_ins.param0[8], temp_pc_trans_ins.param0[7], temp_pc_trans_ins.param0[6], temp_pc_trans_ins.param0[5], temp_pc_trans_ins.param0[4], temp_pc_trans_ins.param0[3], temp_pc_trans_ins.param0[2], temp_pc_trans_ins.param0[1], temp_pc_trans_ins.param0[0]};
      reg_param1 = {temp_pc_trans_ins.param1[11], temp_pc_trans_ins.param1[10], temp_pc_trans_ins.param1[9], temp_pc_trans_ins.param1[8], temp_pc_trans_ins.param1[7], temp_pc_trans_ins.param1[6], temp_pc_trans_ins.param1[5], temp_pc_trans_ins.param1[4], temp_pc_trans_ins.param1[3], temp_pc_trans_ins.param1[2], temp_pc_trans_ins.param1[1], temp_pc_trans_ins.param1[0]};
    end //}

    register_update_method("Link_Maintenance_Response_CSR", "ackID_status", 64, "pl_pc_reg_model", reqd_field_name["ackID_status"]);
    void'(reqd_field_name["ackID_status"].predict(reg_param0));
    //void'(pl_pc_reg_model.Port_0_Link_Maintenance_Response_CSR.ackID_status.predict(reg_param0));

    if (pl_pc_env_config.srio_mode != SRIO_GEN30)
    begin //{
      register_update_method("Link_Maintenance_Response_CSR", "port_status", 64, "pl_pc_reg_model", reqd_field_name["port_status"]);
      void'(reqd_field_name["port_status"].predict(reg_param1));
      //void'(pl_pc_reg_model.Port_0_Link_Maintenance_Response_CSR.port_status.predict(reg_param1));
    end //}
    else
    begin //{
      register_update_method("Link_Maintenance_Response_CSR", "Port_status_cs64", 64, "pl_pc_reg_model", reqd_field_name["Port_status_cs64"]);
      void'(reqd_field_name["Port_status_cs64"].predict(reg_param1));
      //void'(pl_pc_reg_model.Port_0_Link_Maintenance_Response_CSR.Port_status_cs64.predict(reg_param1));
    end //}

endtask : update_link_maint_resp_reg




/////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : update_inbound_ackid_outstanding_ackid_reg
/// Description : This method updates inbound ackid and outstanding ackid fields of Local ackid CSR.
/////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::update_inbound_ackid_outstanding_ackid_reg();

  bit [0:5] reg_ackid_status;
  bit [0:5] temp_rd_val;

  reg_ackid_status = {pl_pc_common_mon_trans.ackid_status[mon_type][0], pl_pc_common_mon_trans.ackid_status[mon_type][1], pl_pc_common_mon_trans.ackid_status[mon_type][2], pl_pc_common_mon_trans.ackid_status[mon_type][3], pl_pc_common_mon_trans.ackid_status[mon_type][4], pl_pc_common_mon_trans.ackid_status[mon_type][5]};

  register_update_method("Local_ackID_CSR", "Outstanding_ackID", 32, "pl_pc_reg_model", reqd_field_name["Outstanding_ackID"]);
  void'(reqd_field_name["Outstanding_ackID"].predict(reg_ackid_status));
  ////void'(pl_pc_reg_model.Port_0_Local_ackID_CSR.Outstanding_ackID.predict(reg_ackid_status));

  if (mon_type)
  begin //{
    register_update_method("Local_ackID_CSR", "Inbound_ackID", 32, "pl_pc_reg_model_tx", reqd_field_name["Inbound_ackID"]);
    void'(reqd_field_name["Inbound_ackID"].predict(reg_ackid_status));
    //void'(pl_pc_env_config.srio_reg_model_tx.Port_0_Local_ackID_CSR.Inbound_ackID.predict(reg_ackid_status));
  end //}
  else
  begin //{
    register_update_method("Local_ackID_CSR", "Inbound_ackID", 32, "pl_pc_reg_model_rx", reqd_field_name["Inbound_ackID"]);
    void'(reqd_field_name["Inbound_ackID"].predict(reg_ackid_status));
    //void'(pl_pc_env_config.srio_reg_model_rx.Port_0_Local_ackID_CSR.Inbound_ackID.predict(reg_ackid_status));
  end //}

endtask : update_inbound_ackid_outstanding_ackid_reg




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : update_outbound_ackid_reg
/// Description  This method updates outbound ackid field of Local ackid CSR.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::update_outbound_ackid_reg();

  bit [0:5] reg_ackid;

  reg_ackid = {exp_pkt_ackid[0], exp_pkt_ackid[1], exp_pkt_ackid[2], exp_pkt_ackid[3], exp_pkt_ackid[4], exp_pkt_ackid[5]};

  if (mon_type)
  begin //{
    register_update_method("Local_ackID_CSR", "Outbound_ackID", 32, "pl_pc_reg_model_tx", reqd_field_name["Outbound_ackID"]);
    void'(reqd_field_name["Outbound_ackID"].predict(reg_ackid));
    //void'(pl_pc_env_config.srio_reg_model_tx.Port_0_Local_ackID_CSR.Outbound_ackID.predict(reg_ackid));
  end //}
  else
  begin //{
    register_update_method("Local_ackID_CSR", "Outbound_ackID", 32, "pl_pc_reg_model_rx", reqd_field_name["Outbound_ackID"]);
    void'(reqd_field_name["Outbound_ackID"].predict(reg_ackid));
    //void'(pl_pc_env_config.srio_reg_model_rx.Port_0_Local_ackID_CSR.Outbound_ackID.predict(reg_ackid));
  end //}

endtask : update_outbound_ackid_reg




/////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : update_gen3_inbound_ackid_outstanding_ackid_reg
/// Description : This method updates inbound ackid and outstanding ackid fields of Local ackid CSR.
/////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::update_gen3_inbound_ackid_outstanding_ackid_reg();

  bit [0:11] reg_ackid_status;

  if (pl_pc_env_config.srio_mode != SRIO_GEN30 && pl_pc_trans.idle_detected && ~pl_pc_trans.idle_selected)
    reg_ackid_status = {pl_pc_common_mon_trans.ackid_status[mon_type][0], pl_pc_common_mon_trans.ackid_status[mon_type][1], pl_pc_common_mon_trans.ackid_status[mon_type][2], pl_pc_common_mon_trans.ackid_status[mon_type][3], pl_pc_common_mon_trans.ackid_status[mon_type][4], 7'b000_0000};
  else if (pl_pc_env_config.srio_mode != SRIO_GEN30 && pl_pc_trans.idle_detected && pl_pc_trans.idle_selected)
    reg_ackid_status = {pl_pc_common_mon_trans.ackid_status[mon_type][0], pl_pc_common_mon_trans.ackid_status[mon_type][1], pl_pc_common_mon_trans.ackid_status[mon_type][2], pl_pc_common_mon_trans.ackid_status[mon_type][3], pl_pc_common_mon_trans.ackid_status[mon_type][4], pl_pc_common_mon_trans.ackid_status[mon_type][5], 6'b00_0000};
  else if (pl_pc_env_config.srio_mode == SRIO_GEN30)
    reg_ackid_status = {pl_pc_common_mon_trans.ackid_status[mon_type][0], pl_pc_common_mon_trans.ackid_status[mon_type][1], pl_pc_common_mon_trans.ackid_status[mon_type][2], pl_pc_common_mon_trans.ackid_status[mon_type][3], pl_pc_common_mon_trans.ackid_status[mon_type][4], pl_pc_common_mon_trans.ackid_status[mon_type][5], pl_pc_common_mon_trans.ackid_status[mon_type][6], pl_pc_common_mon_trans.ackid_status[mon_type][7], pl_pc_common_mon_trans.ackid_status[mon_type][8], pl_pc_common_mon_trans.ackid_status[mon_type][9], pl_pc_common_mon_trans.ackid_status[mon_type][10], pl_pc_common_mon_trans.ackid_status[mon_type][11]};

  register_update_method("Outbound_ackID_CSR", "Outstanding_ackID", 64, "pl_pc_reg_model", reqd_field_name["Outstanding_ackID"]);
  void'(reqd_field_name["Outstanding_ackID"].predict(reg_ackid_status));
  //void'(pl_pc_reg_model.Port_0_Outbound_ackID_CSR.Outstanding_ackID.predict(reg_ackid_status));

  if (mon_type)
  begin //{
    register_update_method("Inbound_ackID_CSR", "Inbound_ackID", 64, "pl_pc_reg_model_tx", reqd_field_name["Inbound_ackID"]);
    void'(reqd_field_name["Inbound_ackID"].predict(reg_ackid_status));
    //void'(pl_pc_env_config.srio_reg_model_tx.Port_0_Inbound_ackID_CSR.Inbound_ackID.predict(reg_ackid_status));
  end //}
  else
  begin //{
    register_update_method("Inbound_ackID_CSR", "Inbound_ackID", 64, "pl_pc_reg_model_rx", reqd_field_name["Inbound_ackID"]);
    void'(reqd_field_name["Inbound_ackID"].predict(reg_ackid_status));
    //void'(pl_pc_env_config.srio_reg_model_rx.Port_0_Inbound_ackID_CSR.Inbound_ackID.predict(reg_ackid_status));
  end //}

endtask : update_gen3_inbound_ackid_outstanding_ackid_reg




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : update_gen3_outbound_ackid_reg
/// Description  This method updates outbound ackid field of Local ackid CSR.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::update_gen3_outbound_ackid_reg();

  bit [0:11] reg_ackid;

  if (pl_pc_env_config.srio_mode != SRIO_GEN30 && pl_pc_trans.idle_detected && ~pl_pc_trans.idle_selected)
    reg_ackid = {exp_pkt_ackid[0], exp_pkt_ackid[1], exp_pkt_ackid[2], exp_pkt_ackid[3], exp_pkt_ackid[4], 7'b000_0000};
  else if (pl_pc_env_config.srio_mode != SRIO_GEN30 && pl_pc_trans.idle_detected && pl_pc_trans.idle_selected)
    reg_ackid = {exp_pkt_ackid[0], exp_pkt_ackid[1], exp_pkt_ackid[2], exp_pkt_ackid[3], exp_pkt_ackid[4], exp_pkt_ackid[5], 6'b00_0000};
  else if (pl_pc_env_config.srio_mode == SRIO_GEN30)
    reg_ackid = {exp_pkt_ackid[0], exp_pkt_ackid[1], exp_pkt_ackid[2], exp_pkt_ackid[3], exp_pkt_ackid[4], exp_pkt_ackid[5], exp_pkt_ackid[6], exp_pkt_ackid[7], exp_pkt_ackid[8], exp_pkt_ackid[9], exp_pkt_ackid[10], exp_pkt_ackid[11]};

  if (mon_type)
  begin //{
    register_update_method("Outbound_ackID_CSR", "Outbound_ackID", 64, "pl_pc_reg_model_tx", reqd_field_name["Outbound_ackID"]);
    void'(reqd_field_name["Outbound_ackID"].predict(reg_ackid));
    //void'(pl_pc_env_config.srio_reg_model_tx.Port_0_Outbound_ackID_CSR.Outbound_ackID.predict(reg_ackid));
  end //}
  else
  begin //{
    register_update_method("Outbound_ackID_CSR", "Outbound_ackID", 64, "pl_pc_reg_model_rx", reqd_field_name["Outbound_ackID"]);
    void'(reqd_field_name["Outbound_ackID"].predict(reg_ackid));
    //void'(pl_pc_env_config.srio_reg_model_rx.Port_0_Outbound_ackID_CSR.Outbound_ackID.predict(reg_ackid));
  end //}

endtask : update_gen3_outbound_ackid_reg




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : update_pnescsr_idle_seq_active
/// Description : This method updates the detected idle sequence in Error and status CSR.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::update_pnescsr_idle_seq_active();

  forever begin //{

    @(pl_pc_trans.idle_detected or pl_pc_trans.idle_selected);

    if (pl_pc_trans.idle_detected)
    begin //{
      register_update_method("Error_and_Status_CSR", "Idle_Sequence", 64, "pl_pc_reg_model", reqd_field_name["Idle_Sequence"]);
      void'(reqd_field_name["Idle_Sequence"].predict(pl_pc_trans.idle_selected));
      //void'(pl_pc_reg_model.Port_0_Error_and_Status_CSR.Idle_Sequence.predict(pl_pc_trans.idle_selected));
    end //}

  end //}

endtask : update_pnescsr_idle_seq_active




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : update_pnescsr_oes_fields
/// Description : This method updates the OES state related fields in error and status CSR.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::update_pnescsr_oes_fields();

  forever begin //{

    @(pl_pc_trans.oes_state);

    register_update_method("Error_and_Status_CSR", "Output_Error_encountered", 64, "pl_pc_reg_model", reqd_field_name["Output_Error_encountered"]);
    void'(reqd_field_name["Output_Error_encountered"].predict(pl_pc_trans.oes_state));
    //void'(pl_pc_reg_model.Port_0_Error_and_Status_CSR.Output_Error_encountered.predict(pl_pc_trans.oes_state));
    register_update_method("Error_and_Status_CSR", "Output_Error_stopped", 64, "pl_pc_reg_model", reqd_field_name["Output_Error_stopped"]);
    void'(reqd_field_name["Output_Error_stopped"].predict(pl_pc_trans.oes_state));
    //void'(pl_pc_reg_model.Port_0_Error_and_Status_CSR.Output_Error_stopped.predict(pl_pc_trans.oes_state));

  end //}

endtask : update_pnescsr_oes_fields




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : update_pnescsr_ies_fields
/// Description : This method updates IES state related fields in error and status CSR.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::update_pnescsr_ies_fields();

  forever begin //{

    @(pl_pc_trans.ies_state);

    register_update_method("Error_and_Status_CSR", "Input_Error_encountered", 64, "pl_pc_reg_model", reqd_field_name["Input_Error_encountered"]);
    void'(reqd_field_name["Input_Error_encountered"].predict(pl_pc_trans.ies_state));
    //void'(pl_pc_reg_model.Port_0_Error_and_Status_CSR.Input_Error_encountered.predict(pl_pc_trans.ies_state));
    register_update_method("Error_and_Status_CSR", "Input_Error_stopped", 64, "pl_pc_reg_model", reqd_field_name["Input_Error_stopped"]);
    void'(reqd_field_name["Input_Error_stopped"].predict(pl_pc_trans.ies_state));
    //void'(pl_pc_reg_model.Port_0_Error_and_Status_CSR.Input_Error_stopped.predict(pl_pc_trans.ies_state));

  end //}

endtask : update_pnescsr_ies_fields




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : update_pnescsr_irs_fields
/// Description : This method updates IRS state related fields in error and status CSR.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::update_pnescsr_irs_fields();

  forever begin //{

    @(pl_pc_trans.irs_state);

    register_update_method("Error_and_Status_CSR", "Input_Retry_stopped", 64, "pl_pc_reg_model", reqd_field_name["Input_Retry_stopped"]);
    void'(reqd_field_name["Input_Retry_stopped"].predict(pl_pc_trans.irs_state));
    //void'(pl_pc_reg_model.Port_0_Error_and_Status_CSR.Input_Retry_stopped.predict(pl_pc_trans.irs_state));

  end //}

endtask : update_pnescsr_irs_fields




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : update_pnescsr_ors_fields
/// Description : This method updates ORS state related fields in error and status CSR.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::update_pnescsr_ors_fields();

  forever begin //{

    @(pl_pc_trans.ors_state);

    register_update_method("Error_and_Status_CSR", "Output_Retry_stopped", 64, "pl_pc_reg_model", reqd_field_name["Output_Retry_stopped"]);
    void'(reqd_field_name["Output_Retry_stopped"].predict(pl_pc_trans.ors_state));
    //void'(pl_pc_reg_model.Port_0_Error_and_Status_CSR.Output_Retry_stopped.predict(pl_pc_trans.ors_state));
    register_update_method("Error_and_Status_CSR", "Output_Retry_encountered", 64, "pl_pc_reg_model", reqd_field_name["Output_Retry_encountered"]);
    void'(reqd_field_name["Output_Retry_encountered"].predict(pl_pc_trans.ors_state));
    //void'(pl_pc_reg_model.Port_0_Error_and_Status_CSR.Output_Retry_encountered.predict(pl_pc_trans.ors_state));
    register_update_method("Error_and_Status_CSR", "Output_Retried", 64, "pl_pc_reg_model", reqd_field_name["Output_Retried"]);
    void'(reqd_field_name["Output_Retried"].predict(pl_pc_trans.ors_state));
    //void'(pl_pc_reg_model.Port_0_Error_and_Status_CSR.Output_Retried.predict(pl_pc_trans.ors_state));

  end //}

endtask : update_pnescsr_ors_fields




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : update_pnescsr_port_error_field
/// Description : This method updates port error field of error and status CSR.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::update_pnescsr_port_error_field();

  register_update_method("Error_and_Status_CSR", "Port_Error", 64, "pl_pc_reg_model", reqd_field_name["Port_Error"]);
  void'(reqd_field_name["Port_Error"].predict(1));
  //void'(pl_pc_reg_model.Port_0_Error_and_Status_CSR.Port_Error.predict(1));

endtask : update_pnescsr_port_error_field




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : update_pnescsr_pu_pnccsr_ipw_fields
/// Description : This method updates initialized port width field in error and status CSR.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::update_pnescsr_pu_pnccsr_ipw_fields();

  forever begin //{

    @(pl_pc_trans.port_initialized);

    register_update_method("Error_and_Status_CSR", "Port_Uninitialized", 64, "pl_pc_reg_model", reqd_field_name["Port_Uninitialized"]);
    void'(reqd_field_name["Port_Uninitialized"].predict(~pl_pc_trans.port_initialized));
    //void'(pl_pc_reg_model.Port_0_Error_and_Status_CSR.Port_Uninitialized.predict(~pl_pc_trans.port_initialized));

    if (pl_pc_trans.port_initialized)
    begin //{

      if (pl_pc_trans.current_init_state == NX_MODE && pl_pc_env_config.num_of_lanes == 16)
      begin //{
        register_update_method("Control_CSR", "Initialized_Port_Width", 64, "pl_pc_reg_model", reqd_field_name["Initialized_Port_Width"]);
        void'(reqd_field_name["Initialized_Port_Width"].predict(3'b101));
    	//void'(pl_pc_reg_model.Port_0_Control_CSR.Initialized_Port_Width.predict(3'b101));
      end //}
      else if (pl_pc_trans.current_init_state == NX_MODE && pl_pc_env_config.num_of_lanes == 8)
      begin //{
        register_update_method("Control_CSR", "Initialized_Port_Width", 64, "pl_pc_reg_model", reqd_field_name["Initialized_Port_Width"]);
        void'(reqd_field_name["Initialized_Port_Width"].predict(3'b100));
    	//void'(pl_pc_reg_model.Port_0_Control_CSR.Initialized_Port_Width.predict(3'b100));
      end //}
      else if (pl_pc_trans.current_init_state == NX_MODE && pl_pc_env_config.num_of_lanes == 4)
      begin //{
        register_update_method("Control_CSR", "Initialized_Port_Width", 64, "pl_pc_reg_model", reqd_field_name["Initialized_Port_Width"]);
        void'(reqd_field_name["Initialized_Port_Width"].predict(3'b010));
    	//void'(pl_pc_reg_model.Port_0_Control_CSR.Initialized_Port_Width.predict(3'b010));
      end //}
      else if (pl_pc_trans.current_init_state == X2_MODE)
      begin //{
        register_update_method("Control_CSR", "Initialized_Port_Width", 64, "pl_pc_reg_model", reqd_field_name["Initialized_Port_Width"]);
        void'(reqd_field_name["Initialized_Port_Width"].predict(3'b011));
    	//void'(pl_pc_reg_model.Port_0_Control_CSR.Initialized_Port_Width.predict(3'b011));
      end //}
      else if (pl_pc_trans.current_init_state == X1_M0)
      begin //{
        register_update_method("Control_CSR", "Initialized_Port_Width", 64, "pl_pc_reg_model", reqd_field_name["Initialized_Port_Width"]);
        void'(reqd_field_name["Initialized_Port_Width"].predict(3'b000));
    	//void'(pl_pc_reg_model.Port_0_Control_CSR.Initialized_Port_Width.predict(3'b000));
      end //}
      else
      begin //{
        register_update_method("Control_CSR", "Initialized_Port_Width", 64, "pl_pc_reg_model", reqd_field_name["Initialized_Port_Width"]);
        void'(reqd_field_name["Initialized_Port_Width"].predict(3'b001));
    	//void'(pl_pc_reg_model.Port_0_Control_CSR.Initialized_Port_Width.predict(3'b001)); // Lane R
      end //}

    end //}

  end //}

endtask : update_pnescsr_pu_pnccsr_ipw_fields




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : update_pnescsr_port_ok_field
/// Description : This method updates port ok field in error and status CSR.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::update_pnescsr_port_ok_field();

  forever begin //{

    @(pl_pc_trans.link_initialized);

    register_update_method("Error_and_Status_CSR", "Port_OK", 64, "pl_pc_reg_model", reqd_field_name["Port_OK"]);
    void'(reqd_field_name["Port_OK"].predict(pl_pc_trans.link_initialized));
    //void'(pl_pc_reg_model.Port_0_Error_and_Status_CSR.Port_OK.predict(pl_pc_trans.link_initialized));

  end //}

endtask : update_pnescsr_port_ok_field




//////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : update_error_detect_csr
/// Description : This method updates the Port n Error detect CSR when any specified error is detected.
/// It also checks if corresponding bit is set in error rate CSR, and updates the error rate counter in
/// Error Rate CSR. It also updates the Port n Capture 0-4 CSR if required.
//////////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::update_error_detect_csr(string csr_field_name);

  bit error_enable;
  bit [7:0] error_rate_counter;
  bit capture_valid_info;

  if (csr_field_name == "CORRUPT_CS")
  begin //{
    register_update_method("Error_Detect_CSR", "Received_corrupt_control_symbol", 64, "pl_pc_reg_model", reqd_field_name["Received_corrupt_control_symbol"]);
    void'(reqd_field_name["Received_corrupt_control_symbol"].predict(1));
    //void'(pl_pc_reg_model.Port_0_Error_Detect_CSR.Received_corrupt_control_symbol.predict(1));
    register_update_method("Error_Rate_Enable_CSR", "Received_corrupt_control_symbol_enable", 64, "pl_pc_reg_model", reqd_field_name["Received_corrupt_control_symbol_enable"]);
    error_enable = reqd_field_name["Received_corrupt_control_symbol_enable"].get();
    //error_enable = pl_pc_reg_model.Port_0_Error_Rate_Enable_CSR.Received_corrupt_control_symbol_enable.get();
  end //}
  else if (csr_field_name == "RCVD_ACK_CS_WITH_UNEXP_ACKID")
  begin //{
    register_update_method("Error_Detect_CSR", "Received_acknowledge_control_symbol_with_unexpected_ackID", 64, "pl_pc_reg_model", reqd_field_name["Received_acknowledge_control_symbol_with_unexpected_ackID"]);
    void'(reqd_field_name["Received_acknowledge_control_symbol_with_unexpected_ackID"].predict(1));
    //void'(pl_pc_reg_model.Port_0_Error_Detect_CSR.Received_acknowledge_control_symbol_with_unexpected_ackID.predict(1));
    register_update_method("Error_Rate_Enable_CSR", "Received_acknowledge_control_symbol_with_unexpected_ackID_enable", 64, "pl_pc_reg_model", reqd_field_name["Received_acknowledge_control_symbol_with_unexpected_ackID_enable"]);
    error_enable = reqd_field_name["Received_acknowledge_control_symbol_with_unexpected_ackID_enable"].get();
    //error_enable = pl_pc_reg_model.Port_0_Error_Rate_Enable_CSR.Received_acknowledge_control_symbol_with_unexpected_ackID_enable.get();
  end //}
  else if (csr_field_name == "RCVD_PNA_CS")
  begin //{
    register_update_method("Error_Detect_CSR", "Received_packet_not_accepted_control_symbol", 64, "pl_pc_reg_model", reqd_field_name["Received_packet_not_accepted_control_symbol"]);
    void'(reqd_field_name["Received_packet_not_accepted_control_symbol"].predict(1));
    //void'(pl_pc_reg_model.Port_0_Error_Detect_CSR.Received_packet_not_accepted_control_symbol.predict(1));
    register_update_method("Error_Rate_Enable_CSR", "Received_packet_not_accepted_control_symbol_enable", 64, "pl_pc_reg_model", reqd_field_name["Received_packet_not_accepted_control_symbol_enable"]);
    error_enable = reqd_field_name["Received_packet_not_accepted_control_symbol_enable"].get();
    //error_enable = pl_pc_reg_model.Port_0_Error_Rate_Enable_CSR.Received_packet_not_accepted_control_symbol_enable.get();
  end //}
  else if (csr_field_name == "UNSOL_ACK_CS")
  begin //{
    register_update_method("Error_Detect_CSR", "Unsolicited_acknowledgement_control_symbol", 64, "pl_pc_reg_model", reqd_field_name["Unsolicited_acknowledgement_control_symbol"]);
    void'(reqd_field_name["Unsolicited_acknowledgement_control_symbol"].predict(1));
    //void'(pl_pc_reg_model.Port_0_Error_Detect_CSR.Unsolicited_acknowledgement_control_symbol.predict(1));
    register_update_method("Error_Rate_Enable_CSR", "Unsolicited_acknowledgement_control_symbol_enable", 64, "pl_pc_reg_model", reqd_field_name["Unsolicited_acknowledgement_control_symbol_enable"]);
    error_enable = reqd_field_name["Unsolicited_acknowledgement_control_symbol_enable"].get();
    //error_enable = pl_pc_reg_model.Port_0_Error_Rate_Enable_CSR.Unsolicited_acknowledgement_control_symbol_enable.get();
  end //}
  else if (csr_field_name == "PROTOCOL_ERROR")
  begin //{
    register_update_method("Error_Detect_CSR", "Protocol_error", 64, "pl_pc_reg_model", reqd_field_name["Protocol_error"]);
    void'(reqd_field_name["Protocol_error"].predict(1));
    //void'(pl_pc_reg_model.Port_0_Error_Detect_CSR.Protocol_error.predict(1));
    register_update_method("Error_Rate_Enable_CSR", "Protocol_error_enable", 64, "pl_pc_reg_model", reqd_field_name["Protocol_error_enable"]);
    error_enable = reqd_field_name["Protocol_error_enable"].get();
    //error_enable = pl_pc_reg_model.Port_0_Error_Rate_Enable_CSR.Protocol_error_enable.get();
  end //}
  else if (csr_field_name == "NON_OUTST_ACKID")
  begin //{
    register_update_method("Error_Detect_CSR", "Non_outstanding_ackID", 64, "pl_pc_reg_model", reqd_field_name["Non_outstanding_ackID"]);
    void'(reqd_field_name["Non_outstanding_ackID"].predict(1));
    //void'(pl_pc_reg_model.Port_0_Error_Detect_CSR.Non_outstanding_ackID.predict(1));
    register_update_method("Error_Rate_Enable_CSR", "Non_outstanding_ackID_enable", 64, "pl_pc_reg_model", reqd_field_name["Non_outstanding_ackID_enable"]);
    error_enable = reqd_field_name["Non_outstanding_ackID_enable"].get();
    //error_enable = pl_pc_reg_model.Port_0_Error_Rate_Enable_CSR.Non_outstanding_ackID_enable.get();
  end //}
  else if (csr_field_name == "LINK_TIMEOUT")
  begin //{
    register_update_method("Error_Detect_CSR", "Link_timeout", 64, "pl_pc_reg_model", reqd_field_name["Link_timeout"]);
    void'(reqd_field_name["Link_timeout"].predict(1));
    //void'(pl_pc_reg_model.Port_0_Error_Detect_CSR.Link_timeout.predict(1));
    register_update_method("Error_Rate_Enable_CSR", "Link_timeout_enable", 64, "pl_pc_reg_model", reqd_field_name["Link_timeout_enable"]);
    error_enable = reqd_field_name["Link_timeout_enable"].get();
    //error_enable = pl_pc_reg_model.Port_0_Error_Rate_Enable_CSR.Link_timeout_enable.get();
  end //}
  else if (csr_field_name == "BAD_CRC_PKT")
  begin //{
    register_update_method("Error_Detect_CSR", "Received_packet_with_bad_CRC", 64, "pl_pc_reg_model", reqd_field_name["Received_packet_with_bad_CRC"]);
    void'(reqd_field_name["Received_packet_with_bad_CRC"].predict(1));
    //void'(pl_pc_reg_model.Port_0_Error_Detect_CSR.Received_packet_with_bad_CRC.predict(1));
    register_update_method("Error_Rate_Enable_CSR", "Received_packet_with_bad_CRC_enable", 64, "pl_pc_reg_model", reqd_field_name["Received_packet_with_bad_CRC_enable"]);
    error_enable = reqd_field_name["Received_packet_with_bad_CRC_enable"].get();
    //error_enable = pl_pc_reg_model.Port_0_Error_Rate_Enable_CSR.Received_packet_with_bad_CRC_enable.get();
  end //}
  else if (csr_field_name == "UNEXP_ACKID_PKT")
  begin //{
    register_update_method("Error_Detect_CSR", "Received_packet_with_unexpected_ackID", 64, "pl_pc_reg_model", reqd_field_name["Received_packet_with_unexpected_ackID"]);
    void'(reqd_field_name["Received_packet_with_unexpected_ackID"].predict(1));
    //void'(pl_pc_reg_model.Port_0_Error_Detect_CSR.Received_packet_with_unexpected_ackID.predict(1));
    register_update_method("Error_Rate_Enable_CSR", "Received_packet_with_unexpected_ackID_enable", 64, "pl_pc_reg_model", reqd_field_name["Received_packet_with_unexpected_ackID_enable"]);
    error_enable = reqd_field_name["Received_packet_with_unexpected_ackID_enable"].get();
    //error_enable = pl_pc_reg_model.Port_0_Error_Rate_Enable_CSR.Received_packet_with_unexpected_ackID_enable.get();
  end //}

  if (error_enable)
  begin //{
    register_update_method("Error_Rate_CSR", "Error_Rate_Counter", 64, "pl_pc_reg_model", reqd_field_name["Error_Rate_Counter"]);
    error_rate_counter = reqd_field_name["Error_Rate_Counter"].get();
    //error_rate_counter = pl_pc_reg_model.Port_0_Error_Rate_CSR.Error_Rate_Counter.get();
    error_rate_counter = {error_rate_counter[0], error_rate_counter[1], error_rate_counter[2], error_rate_counter[3], error_rate_counter[4], error_rate_counter[5], error_rate_counter[6], error_rate_counter[7]};
    if (error_rate_counter < 8'hFF)
    begin //{
      error_rate_counter++;
      error_rate_counter = {error_rate_counter[0], error_rate_counter[1], error_rate_counter[2], error_rate_counter[3], error_rate_counter[4], error_rate_counter[5], error_rate_counter[6], error_rate_counter[7]};
      register_update_method("Error_Rate_CSR", "Error_Rate_Counter", 64, "pl_pc_reg_model", reqd_field_name["Error_Rate_Counter"]);
      void'(reqd_field_name["Error_Rate_Counter"].predict(error_rate_counter));
      //void'(pl_pc_reg_model.Port_0_Error_Rate_CSR.Error_Rate_Counter.predict(error_rate_counter));
    end //}
  end //}

  register_update_method("Attributes_Capture_CSR", "Capture_valid_info", 64, "pl_pc_reg_model", reqd_field_name["Capture_valid_info"]);
  capture_valid_info = reqd_field_name["Capture_valid_info"].get();
  //capture_valid_info = pl_pc_reg_model.Port_0_Attributes_Capture_CSR.Capture_valid_info.get();

  if (~capture_valid_info && csr_field_name != "LINK_TIMEOUT")
  begin //{

    if (temp_pc_trans_ins.transaction_kind == SRIO_CS)
    begin //{

      if (pl_pc_trans.idle_detected && ~pl_pc_trans.idle_selected && pl_pc_env_config.srio_mode != SRIO_GEN30)
      begin //{
  	register_update_method("Attributes_Capture_CSR", "Info_type", 64, "pl_pc_reg_model", reqd_field_name["Info_type"]);
  	void'(reqd_field_name["Info_type"].predict(3'b010));
        //void'(pl_pc_reg_model.Port_0_Attributes_Capture_CSR.Info_type.predict(3'b010));
  	register_update_method("Packet_Control_Symbol_Capture_0_CSR", "predict0", 64, "pl_pc_reg_model", reqd_field_name["predict0"]);
        //void'(pl_pc_reg_model.Port_0_Packet_Control_Symbol_Capture_0_CSR.predict(capture_0_reg_val));
      end //}
      else if (pl_pc_trans.idle_detected && pl_pc_trans.idle_selected && pl_pc_env_config.srio_mode != SRIO_GEN30)
      begin //{
  	register_update_method("Attributes_Capture_CSR", "Info_type", 64, "pl_pc_reg_model", reqd_field_name["Info_type"]);
  	void'(reqd_field_name["Info_type"].predict(3'b110));
        //void'(pl_pc_reg_model.Port_0_Attributes_Capture_CSR.Info_type.predict(3'b110));
  	register_update_method("Packet_Control_Symbol_Capture_0_CSR", "predict0", 64, "pl_pc_reg_model", reqd_field_name["predict0"]);
        //void'(pl_pc_reg_model.Port_0_Packet_Control_Symbol_Capture_0_CSR.predict(capture_0_reg_val));
  	register_update_method("Packet_Capture_1_CSR", "predict1", 64, "pl_pc_reg_model", reqd_field_name["predict1"]);
        //void'(pl_pc_reg_model.Port_0_Packet_Capture_1_CSR.predict(capture_1_reg_val));
      end //}
      else if (pl_pc_env_config.srio_mode == SRIO_GEN30)
      begin //{
  	register_update_method("Attributes_Capture_CSR", "Info_type", 64, "pl_pc_reg_model", reqd_field_name["Info_type"]);
  	void'(reqd_field_name["Info_type"].predict(3'b101));
        //void'(pl_pc_reg_model.Port_0_Attributes_Capture_CSR.Info_type.predict(3'b101));
  	register_update_method("Packet_Control_Symbol_Capture_0_CSR", "predict0", 64, "pl_pc_reg_model", reqd_field_name["predict0"]);
        //void'(pl_pc_reg_model.Port_0_Packet_Control_Symbol_Capture_0_CSR.predict(capture_0_reg_val));
  	register_update_method("Packet_Capture_1_CSR", "predict1", 64, "pl_pc_reg_model", reqd_field_name["predict1"]);
        //void'(pl_pc_reg_model.Port_0_Packet_Capture_1_CSR.predict(capture_1_reg_val));
      end //}

    end //}
    else if (temp_pc_trans_ins.transaction_kind == SRIO_PACKET)
    begin //{
      register_update_method("Attributes_Capture_CSR", "Info_type", 64, "pl_pc_reg_model", reqd_field_name["Info_type"]);
      void'(reqd_field_name["Info_type"].predict(3'b000));
      //void'(pl_pc_reg_model.Port_0_Attributes_Capture_CSR.Info_type.predict(3'b000));
      register_update_method("Packet_Control_Symbol_Capture_0_CSR", "predict0", 64, "pl_pc_reg_model", reqd_field_name["predict0"]);
      //void'(pl_pc_reg_model.Port_0_Packet_Control_Symbol_Capture_0_CSR.predict(capture_0_reg_val));
      register_update_method("Packet_Capture_1_CSR", "predict1", 64, "pl_pc_reg_model", reqd_field_name["predict1"]);
      //void'(pl_pc_reg_model.Port_0_Packet_Capture_1_CSR.predict(capture_1_reg_val));
      register_update_method("Packet_Capture_2_CSR", "predict2", 64, "pl_pc_reg_model", reqd_field_name["predict2"]);
      //void'(pl_pc_reg_model.Port_0_Packet_Capture_2_CSR.predict(capture_2_reg_val));
      register_update_method("Packet_Capture_3_CSR", "predict3", 64, "pl_pc_reg_model", reqd_field_name["predict3"]);
      //void'(pl_pc_reg_model.Port_0_Packet_Capture_3_CSR.predict(capture_3_reg_val));
      register_update_method("Packet_Capture_4_CSR", "predict4", 64, "pl_pc_reg_model", reqd_field_name["predict4"]);
      //void'(pl_pc_reg_model.Port_0_Packet_Capture_4_CSR.predict(capture_4_reg_val));
    end //}

    register_update_method("Attributes_Capture_CSR", "Capture_valid_info", 64, "pl_pc_reg_model", reqd_field_name["Capture_valid_info"]);
    void'(reqd_field_name["Capture_valid_info"].predict(1));
    //void'(pl_pc_reg_model.Port_0_Attributes_Capture_CSR.Capture_valid_info.predict(1));

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
task automatic srio_pl_protocol_checker::register_update_method(string reg_name, string field_name, int offset, string reg_ins, output uvm_reg_field out_field_name);

  string temp_reg_name;
  string reg_name_prefix;
  uvm_reg_addr_t reg_addr;
  uvm_reg reqd_reg_name;
  uvm_reg reg_name1;

  if (pl_pc_env_config.port_number == 0)
    reg_name_prefix = "Port_0_";
  else if (pl_pc_env_config.port_number == 1)
    reg_name_prefix = "Port_1_";
  else if (pl_pc_env_config.port_number == 2)
    reg_name_prefix = "Port_2_";
  else if (pl_pc_env_config.port_number == 3)
    reg_name_prefix = "Port_3_";
  else if (pl_pc_env_config.port_number == 4)
    reg_name_prefix = "Port_4_";
  else if (pl_pc_env_config.port_number == 5)
    reg_name_prefix = "Port_5_";
  else if (pl_pc_env_config.port_number == 6)
    reg_name_prefix = "Port_6_";
  else if (pl_pc_env_config.port_number == 7)
    reg_name_prefix = "Port_7_";
  else if (pl_pc_env_config.port_number == 8)
    reg_name_prefix = "Port_8_";
  else if (pl_pc_env_config.port_number == 9)
    reg_name_prefix = "Port_9_";
  else if (pl_pc_env_config.port_number == 10)
    reg_name_prefix = "Port_10_";
  else if (pl_pc_env_config.port_number == 11)
    reg_name_prefix = "Port_11_";
  else if (pl_pc_env_config.port_number == 12)
    reg_name_prefix = "Port_12_";
  else if (pl_pc_env_config.port_number == 13)
    reg_name_prefix = "Port_13_";
  else if (pl_pc_env_config.port_number == 14)
    reg_name_prefix = "Port_14_";
  else if (pl_pc_env_config.port_number == 15)
    reg_name_prefix = "Port_15_";
  else
    reg_name_prefix = "Port_0_";

  temp_reg_name = {reg_name_prefix, reg_name};

  if (reg_ins == "pl_pc_reg_model")
    reg_name1 = pl_pc_reg_model.get_reg_by_name(temp_reg_name);
  else if (reg_ins == "pl_pc_reg_model_tx")
    reg_name1 = pl_pc_env_config.srio_reg_model_tx.get_reg_by_name(temp_reg_name);
  else if (reg_ins == "pl_pc_reg_model_rx")
    reg_name1 = pl_pc_env_config.srio_reg_model_rx.get_reg_by_name(temp_reg_name);

  if (reg_name1 == null)
    `uvm_warning("NULL_REGISTER_ACCESS", $sformatf(" No register found with name %0s", temp_reg_name))
  reg_addr = reg_name1.get_offset();

  if (pl_pc_env_config.srio_mode != SRIO_GEN30 && pl_pc_env_config.spec_support != V30)
  begin //{
    if (reg_name == "Link_Maintenance_Response_CSR" || reg_name == "Control_2_CSR" || reg_name == "Error_and_Status_CSR" || reg_name == "Control_CSR")
      offset = 32;
  end //}

  if (reg_ins == "pl_pc_reg_model")
    reqd_reg_name = pl_pc_reg_model.srio_reg_block_map.get_reg_by_offset(reg_addr+(pl_pc_env_config.port_number*offset));
  else if (reg_ins == "pl_pc_reg_model_tx")
    reqd_reg_name = pl_pc_env_config.srio_reg_model_tx.srio_reg_block_map.get_reg_by_offset(reg_addr+(pl_pc_env_config.port_number*offset));
  else if (reg_ins == "pl_pc_reg_model_rx")
    reqd_reg_name = pl_pc_env_config.srio_reg_model_rx.srio_reg_block_map.get_reg_by_offset(reg_addr+(pl_pc_env_config.port_number*offset));

  if (reqd_reg_name == null)
    `uvm_warning("NULL_REGISTER_ACCESS", $sformatf(" Register %0s. Base address : %0h, Accessed address : %0h", temp_reg_name, reg_addr, reg_addr+(pl_pc_env_config.port_number*offset)))
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

task srio_pl_protocol_checker::set_ies_state();
forever
 begin//{
        wait (pl_pc_common_mon_trans.ies_state_detected[mon_type]==1);
        pl_pc_trans.ies_state=1;
        wait (pl_pc_common_mon_trans.ies_state_detected[mon_type]==0);
 end//}
endtask

///////////////////////////////////////////////////////////////////////////////////////////////
/// Name :tb_reset_ackid 
/// Description :Task to reset BFM packet ackid 
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_protocol_checker::tb_reset_ackid;
 forever
  begin
   wait(pl_pc_env_config.reset_ackid==1);
    exp_pkt_ackid=0;
    pl_pc_common_mon_trans.outstanding_pkt_ack_stype0[mon_type] = {}; // delete all outstanding ack
    pl_pc_common_mon_trans.pkt_ack_timer_stype0[mon_type] = {};	// delete all timers for outstanding ack
    pl_pc_common_mon_trans.num_outstanding_pkts[mon_type] = 0;
    pl_pc_common_mon_trans.ackid_status[mon_type] = 0;
    pl_pc_common_mon_trans.update_exp_pkt_ackid[mon_type] = 0;
   `uvm_info("SRIO_PL_PROTOCOL_CHECKER",$sformatf("Clear ACKID"),UVM_LOW)
   wait(pl_pc_env_config.reset_ackid==0);
  end
endtask
