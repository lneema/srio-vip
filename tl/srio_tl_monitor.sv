////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_tl_monitor.sv
// Project :  srio vip
// Purpose :  Monitors TL Packets
// Author  :  Mobiveil
//
// Contains srio_tl_monitor class for monitoring TL Transactions 
// 
//////////////////////////////////////////////////////////////////////////////// 

// =============================================================================
// class: srio_tl_monitor 
// =============================================================================
class srio_tl_monitor extends uvm_monitor;

  /// @cond
  `uvm_component_utils(srio_tl_monitor)

  // Instance of Tx & Rx monitor
  srio_tl_txrx_monitor tx_monitor;
  srio_tl_txrx_monitor rx_monitor;

  // Analysis ports
  uvm_analysis_port #(srio_trans) tx_mon_ap; 
  uvm_analysis_port #(srio_trans) rx_mon_ap;
 
  // Env Config 
  srio_env_config tl_mon_env_config;

  bit tx_en_err_report;
  bit rx_en_err_report;
  /// @endcond

  extern function new(string name="srio_tl_monitor", 
                      uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass: srio_tl_monitor

// =============================================================================

////////////////////////////////////////////////////////////////////////////////
/// Name: new \n 
/// Description: TL Monitor's new function\n
/// new
////////////////////////////////////////////////////////////////////////////////
 
function srio_tl_monitor::new(string name="srio_tl_monitor", 
                              uvm_component parent=null);
  super.new(name,parent);
endfunction

////////////////////////////////////////////////////////////////////////////////
/// Name: build_phase \n 
/// Description: TL Monitor's build_phase function \n
/// build_phase
////////////////////////////////////////////////////////////////////////////////

function void srio_tl_monitor::build_phase(uvm_phase phase);

  tx_monitor = srio_tl_txrx_monitor::type_id::create("tx_monitor", this);
  rx_monitor = srio_tl_txrx_monitor::type_id::create("rx_monitor", this);

  if (!uvm_config_db #(srio_env_config)::get(this, "", "srio_env_config", tl_mon_env_config))
    `uvm_fatal("CONFIG_LOAD", "Cannot get() Env Config Handle")

  if (tl_mon_env_config.srio_tx_mon_if == BFM)
    tx_en_err_report = 0;
  else
    tx_en_err_report = 1;

  if (tl_mon_env_config.srio_rx_mon_if == BFM)
    rx_en_err_report = 0;
  else
    rx_en_err_report = 1;

  uvm_config_db #(bit)::set(this, "tx_monitor", "mon_type", 1);
  uvm_config_db #(bit)::set(this, "rx_monitor", "mon_type", 0);

  uvm_config_db #(bit)::set(this, "tx_monitor", "en_err_report", tx_en_err_report);
  uvm_config_db #(bit)::set(this, "rx_monitor", "en_err_report", rx_en_err_report);

endfunction

////////////////////////////////////////////////////////////////////////////////
/// Name: connect_phase \n 
/// Description: TL Monitor's connect_phase function \n
/// connect_phase
////////////////////////////////////////////////////////////////////////////////

function void srio_tl_monitor::connect_phase(uvm_phase phase);
  tx_mon_ap = tx_monitor.mon_ap;
  rx_mon_ap = rx_monitor.mon_ap;
endfunction

// =============================================================================
