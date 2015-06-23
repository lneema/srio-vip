////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_env_pkg.sv
// Project :  srio vip
// Purpose :  SRIO VIP Env package
// Author  :  Mobiveil
//
// Package file for srio vip.Includes all the srio vip files.
// Needs to be imported to use the srio vip.
////////////////////////////////////////////////////////////////////////////////
package srio_env_pkg;

import uvm_pkg::*;

`include "uvm_macros.svh"
`include "srio_pl_variables.sv"
`include "srio_reg_block.sv"
`include "srio_env_config.svh"
`include "srio_base_trans.sv"
`include "srio_trans.sv"
`include "srio_gen_trans_tracker.sv"

`include "srio_reg_adapter.sv"
`include "srio_tx_trans_decoder.sv"
`include "srio_rx_trans_decoder.sv"
`include "srio_trans_decoder.sv"

`include "srio_report_catcher_callback.sv"
`include "srio_ll_callback.sv"
`include "srio_ll_variables.sv"
`include "srio_ll_config.svh"
`include "srio_ll_common_class.sv"
`include "srio_ll_ds_assembly.sv"
`include "srio_ll_msg_assembly.sv"
`include "srio_ll_lfc_assembly.sv"
`include "srio_ll_shared_class.sv"
`include "srio_ll_txrx_monitor.sv"
`include "srio_ll_monitor.sv"
`include "srio_ll_agent.sv"
`include "srio_ll_bfm.sv"
`include "srio_ll_sequencer.sv"
`include "srio_ll_base_generator.sv"
`include "srio_logical_transaction_generator.sv"
`include "srio_io_generator.sv"
`include "srio_msg_db_generator.sv"
`include "srio_ds_generator.sv"
`include "srio_lfc_generator.sv"
`include "srio_gsm_generator.sv"
`include "srio_resp_generator.sv"
`include "srio_packet_handler.sv"

`include "srio_tl_variables.sv"
`include "srio_tl_callback.sv"
`include "srio_tl_config.svh"
`include "srio_tl_txrx_monitor.sv"
`include "srio_tl_monitor.sv"
`include "srio_tl_agent.sv"
`include "srio_tl_bfm.sv"
`include "srio_tl_sequencer.sv"
`include "srio_tl_generator.sv"
`include "srio_tl_receiver.sv"

`include "srio_pl_config.svh"
`include "srio_pl_tx_rx_mon_common_trans.sv"
`include "srio_pl_common_component_trans.sv"
`include "srio_pl_lane_data.sv"
`include "srio_pl_callback.sv"
`include "srio_pl_lane_handler.sv"
`include "srio_pl_rx_data_handler.sv"
`include "srio_pl_state_machine.sv"
`include "srio_pl_protocol_checker.sv"
`include "srio_pl_link_monitor.sv"
`include "srio_pl_monitor.sv"
`include "srio_pl_data_trans.sv"
`include "srio_pl_pkt_handler.sv"
`include "srio_pl_pktcs_merger.sv"
`include "srio_pl_idle_gen.sv"
`include "srio_pl_lane_driver.sv"
`include "srio_pl_bfm.sv"
`include "srio_pl_sequencer.svh"
`include "srio_pl_agent.sv"
`include "srio_virtual_sequencer.sv"
`include "srio_ll_tx_trans_collector.sv"
`include "srio_ll_rx_trans_collector.sv"
`include "srio_ll_func_coverage.sv"
`include "srio_tl_tx_trans_collector.sv"
`include "srio_tl_rx_trans_collector.sv"
`include "srio_tl_func_coverage.sv"
`include "srio_pl_tx_trans_collector.sv"
`include "srio_pl_rx_trans_collector.sv"
`include "srio_pl_func_coverage.sv"
`include "srio_env.sv"

endpackage : srio_env_pkg
