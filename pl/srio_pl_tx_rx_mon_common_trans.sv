////////////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File       :  srio_pl_tx_rx_mon_common_transaction.sv
// Project    :  srio vip
// Purpose    :  Transaction which is used by both the tx and rx monitor to exchange information.
// Author     :  Mobiveil
//
// Physical layer tx and rx monitor specific transaction class.
//
//
//////////////////////////////////////////////////////////////////////////////////////////////////

class srio_pl_tx_rx_mon_common_trans extends uvm_object;

  /// @cond
  `uvm_object_utils(srio_pl_tx_rx_mon_common_trans)
  /// @endcond

  // Properties

  int rx_mon_status_cs_cnt;				///< Status control symbol count updated by rx monitor used for link initialization.
  int tx_mon_status_cs_cnt;				///< Status contorl symbol count updated by tx monitor used for link initialization.

  bit idle_selection_done[bit];				///< Indicates idle selection done.
  bit selected_idle[bit];				///< Indicates the detected idle sequence.

  bit port_initialized[bit];				///< Port initialized flag.
  bit link_initialized[bit];				///< Link initialized flag.
  bit clear_status_cs_cnt[bit];				///< Flag to clear status cs count updated by the other monitor.

  time current_time[bit];				///< Current time information.

  bit pl_outstanding_ackid[bit][int];			///< Outstanding ackid information. "bit" index is for mon_type and "int" index is for the ackid.

  int pkt_ack_timer_stype0[bit][$];			///< Stype0 acknowledgement timer queue.
  srio_trans outstanding_pkt_ack_stype0[bit][$];	///< Outstanding stype0 acknowledgement queue.
  int pkt_ack_timer_stype1[bit][$];			///< Stype1 acknowledgement timer queue.
  srio_trans outstanding_pkt_ack_stype1[bit][$];	///< Outstanding stype1 acknowledgement queue.

  init_sm_states current_init_state[bit];		///< Indicates the current state of init SM

  bit outstanding_link_req[bit];			///< Flag to indicate link request is outstanding or not.
  bit outstanding_rfr[bit];				///< Flag to indicate restart-from-retry is outstanding or not.
  bit outstanding_retry[bit];				///< Flag to indicate retry is outstanding or not.

  int num_outstanding_pkts[bit];			///< Number of outstanding packets.
  int ackid_status[bit];				///< Ackid status.

  bit oes_state_detected[bit];				///< Flag to indicate that OES state is detected.
  bit ies_state_detected[bit];				///< Flag to indicate that OES state is detected.

  bit update_exp_pkt_ackid[bit];			///< Flag to validate updated_exp_pkt_ackid_val.
  int updated_exp_pkt_ackid_val[bit];			///< Used for updating the expected packet ackid after a recovery process.

  bit idle2_aet_cmd_outstanding[bit][int];		///< Indicates IDLE2 AET command is outstading. "bit" index is for mon_type and "int" index is for lane number.
  bit idle2_aet_ack_nack_rcvd[bit][int];		///< Indicates acknowledgement is received for an AET command.
  bit idle2_ack_timeout_occured[bit][int];		///< Indicates acknowledgement timeout occured for an AET command.
  bit idle2_cmd_timeout_occured[bit][int];		///< Indicates command is not deasserted after ack/nack is received till the cmd timer expires.
  bit command_deasserted[bit][int];			///< Flag to indicate command is deasserted.

  bit [0:5] pkt_vcid_q[bit][int][$];			///< Queue to store ackid of non-zero vc packets. "bit" index is for mon_type, "int" index is for vc_id.

  bit write_pkt_to_ap[bit];				///< Flag to allow packet write into analysis port.
  bit pkt_accepted[bit];				///< Indicates packet is accepted.
  bit pkt_retried[bit];					///< Indicates packet is retried.
  bit pkt_not_accepted[bit];				///< Indicates packet is not accepted.
  bit pkt_acc_timeout_occured[bit];			///< Indicates packet accepted timeout occured.
  bit [11:0] ackid_in_cs[bit];				///< Holds ackid in the received packet acknowledgement control symbol.

  bit packet_rx_in_progress[bit];                    	///< Indicates that a packet is being received.
  bit [0:11] pkt_in_progress_ack_id[bit];              ///< Indicates the ack_id of the packet being received.

  // GEN 3.0 specific variables

  bit gen3_training_cmd_outstanding[bit][int];		///< Indicates gen3 training command is outstanding.
  bit gen3_training_status_received[bit][int];		///< Indicates status is received for a gen3 training command.
  bit gen3_cmd_deassertion_timer_started[bit][int];	///< Indicates command deassertion timer is started.

  bit [2:0] gen3_c0_training_cmd[bit][int];		///< gen3 c0 coefficient training command.
  bit [1:0] gen3_cp1_training_cmd[bit][int];		///< gen3 cp1 coefficient training command.
  bit [1:0] gen3_cn1_training_cmd[bit][int];		///< gen3 cn1 coefficient training command.

  bit [1:0] gen3_expected_c0_training_status[bit][int];		///< Holds the expected status for the received c0 training command.
  bit [1:0] gen3_expected_cp1_training_status[bit][int];	///< Holds the expected status for the received cp1 training command.
  bit [1:0] gen3_expected_cn1_training_status[bit][int];	///< Holds the expected status for the received cn1 training command.

  bit dme_wait_timer_en[bit][int];			///< DME wait timer enable.
  bit dme_wait_timer_done[bit][int];			///< DME wait timer completed.

  bit retraining[bit];			///< Retraining flag.
  bit retrain_ready[bit];		///< Retrain ready flag.
  bit retrain_grnt[bit];		///< Retrain grant flag.

  bit xmting_idle[bit];			///< Indicates idle is being transmitted.

  bit timestamp_seq_started[bit];	///< Indicates timestamp sequence is started.
  bit timestamp_seq_completed[bit];	///< Indicates timestamp sequence is completed.
  bit outstanding_loop_req[bit];	///< Indicates loop timing request is outstanding.

  bit [2:0] xmt_width_req_cmd[bit];	///< Transmit width request command.
  bit xmt_width_req_pending[bit];	///< Transmit width request pending.

  bit [2:0] rcv_width_cmd[bit];		///< Receive width link command.
  bit rcv_width_ack[bit];		///< Receive width link command ack.
  bit rcv_width_nack[bit];		///< Receive width link command nack.

  int sc_os_cnt[bit];			///< Status-Control ordered sequence count when Port/Lane entering silence is set.
  // Methods
  extern function new (string name = "srio_pl_tx_rx_mon_common_trans");

endclass


///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : New
/// Description : Constructor method for srio_pl_tx_rx_mon_common_trans class.
///////////////////////////////////////////////////////////////////////////////////////////////
function srio_pl_tx_rx_mon_common_trans::new(string name = "srio_pl_tx_rx_mon_common_trans");

  super.new(name);

endfunction : new
