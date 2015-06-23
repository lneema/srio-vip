////////////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File       :  srio_pl_monitor.sv
// Project    :  srio vip
// Purpose    :  Instantiates the PL Tx monitor and Rx monitor
// Author     :  Mobiveil
//
// Physical layer monitor class. 
//
//
//////////////////////////////////////////////////////////////////////////////////////////////////

class srio_pl_monitor extends uvm_monitor;

  /// @cond
  `uvm_component_utils (srio_pl_monitor)
  /// @endcond

  virtual srio_interface srio_if;				///< Virtual interface
                                                                                                            
  srio_env_config pl_mon_env_config;                            ///< ENV config instance
                                                                                                            
  srio_pl_config pl_mon_config;                                 ///< PL Config instance
                                                                                                            
  srio_pl_tx_rx_mon_common_trans pl_mon_common_trans;           ///< Common monitor transction instance
                                                                                                            
  srio_pl_common_component_trans pl_mon_tx_trans;         	///< PL monitor common transaction instance for tx monitor.
  srio_pl_common_component_trans pl_mon_rx_trans;         	///< PL monitor common transaction instance for rx monitor.

  srio_pl_link_monitor tx_monitor;				///< PL link monitor instance to create tx monitor.
  srio_pl_link_monitor rx_monitor;				///< PL link monitor instance to create rx monitor.

  // Properties
  bit mon_type;					///< Monitor type.
  bit report_error;				///< Report error or warning.

  // ports
  uvm_analysis_port #(srio_trans) tx_mon_ap;	///< Analysis port for tx monitor.
  uvm_analysis_port #(srio_trans) rx_mon_ap;	///< Analysis port for rx monitor.

  extern function new(string name="srio_pl_monitor", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : New
/// Description : Constructor method for srio_pl_monitor class.
///////////////////////////////////////////////////////////////////////////////////////////////
function srio_pl_monitor::new(string name="srio_pl_monitor", uvm_component parent=null);
  super.new(name, parent);
endfunction : new



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : build_phase
/// Description : build_phase method for srio_pl_monitor class.
/// It gets various config_db variables and also creates tx and rx monitor.
///////////////////////////////////////////////////////////////////////////////////////////////
function void srio_pl_monitor::build_phase(uvm_phase phase);

  if (!uvm_config_db #(srio_pl_config)::get(this, "", "pl_config", pl_mon_config))
    `uvm_fatal("CONFIG_LOAD", "Cannot get() PL CONFIG HANDLE")

  if (!uvm_config_db #(srio_pl_common_component_trans)::get(this, "", "pl_com_tx_trans", pl_mon_tx_trans))
    `uvm_fatal("CONFIG_LOAD", "Cannot get() PL COMMON TX TRANS HANDLE")

  if (!uvm_config_db #(srio_pl_common_component_trans)::get(this, "", "pl_com_rx_trans", pl_mon_rx_trans))
    `uvm_fatal("CONFIG_LOAD", "Cannot get() PL COMMON RX TRANS HANDLE")

  if (!uvm_config_db #(srio_env_config)::get(this, "", "srio_env_config", pl_mon_env_config))
    `uvm_fatal("CONFIG_LOAD", "Cannot get() ENV CONFIG HANDLE")

  srio_if = pl_mon_config.srio_if;

  pl_mon_common_trans = srio_pl_tx_rx_mon_common_trans::type_id::create("pl_mon_common_trans", this);

  uvm_config_db #(srio_pl_tx_rx_mon_common_trans)::set(this,"*", "pl_tx_rx_mon_common_trans", pl_mon_common_trans);

  uvm_config_db #(bit)::set(this,"tx_monitor", "mon_type", 1);
  uvm_config_db #(bit)::set(this,"rx_monitor", "mon_type", 0);

  if (pl_mon_env_config.srio_tx_mon_if == BFM)
    uvm_config_db #(bit)::set(this,"tx_monitor", "report_error", 0);
  else if (pl_mon_env_config.srio_tx_mon_if == DUT)
    uvm_config_db #(bit)::set(this,"tx_monitor", "report_error", 1);

  if (pl_mon_env_config.srio_rx_mon_if == BFM)
    uvm_config_db #(bit)::set(this,"rx_monitor", "report_error", 0);
  else if (pl_mon_env_config.srio_rx_mon_if == DUT)
    uvm_config_db #(bit)::set(this,"rx_monitor", "report_error", 1);

  tx_monitor = srio_pl_link_monitor::type_id::create("tx_monitor", this);
  rx_monitor = srio_pl_link_monitor::type_id::create("rx_monitor", this);

endfunction : build_phase




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name :connect_phase 
/// Description : connect_phase method for srio_pl_monitor class.
/// It connects the config_db variables to corresponding tx and rx monitor variables, and also
/// creates a connection from the analysis ports of tx and rx monitor instances.
///////////////////////////////////////////////////////////////////////////////////////////////
function void srio_pl_monitor::connect_phase(uvm_phase phase);

  tx_monitor.srio_pl_rx_data_handle_ins.rx_dh_common_mon_trans = pl_mon_common_trans;
  tx_monitor.srio_pl_sm_ins.pl_sm_common_mon_trans = pl_mon_common_trans;
  tx_monitor.srio_pl_pc_ins.pl_pc_common_mon_trans = pl_mon_common_trans;

  rx_monitor.srio_pl_rx_data_handle_ins.rx_dh_common_mon_trans = pl_mon_common_trans;
  rx_monitor.srio_pl_sm_ins.pl_sm_common_mon_trans = pl_mon_common_trans;
  rx_monitor.srio_pl_pc_ins.pl_pc_common_mon_trans = pl_mon_common_trans;

  tx_mon_ap = tx_monitor.link_mon_ap;
  rx_mon_ap = rx_monitor.link_mon_ap;
endfunction
