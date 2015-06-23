////////////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File       :  srio_pl_link_monitor.sv
// Project    :  srio vip
// Purpose    :  Instantiates the sub components of PL Tx monitor and Rx monitor
// Author     :  Mobiveil
//
// Physical layer Tx monitor and Rx monitor class. 
//
//
//////////////////////////////////////////////////////////////////////////////////////////////////

typedef class srio_pl_lane_data;
class srio_pl_link_monitor extends uvm_component;

  /// @cond
  `uvm_component_utils (srio_pl_link_monitor)
  /// @endcond

  virtual srio_interface srio_if;				///< Virtual interface
                                                                                                                    
  srio_env_config pl_link_mon_env_config;                       ///< ENV config instance
                                                                                                                    
  srio_pl_config pl_link_mon_config;                            ///< PL Config instance
                                                                                                                    
  srio_pl_tx_rx_mon_common_trans pl_link_mon_common_trans;      ///< Common monitor transction instance
                                                                                                                    
  srio_pl_common_component_trans pl_link_mon_trans;             ///< PL monitor common transaction instance
                                                                                                                    
  srio_reg_block pl_link_mon_reg_model;                         ///< Register model instance

  srio_pl_lane_handler lane_handle_ins[int];			///< Array of lane handler class instances

  srio_2x_align_data x2_align_data_ins;				///< Align data instance for 2x align s/m
  srio_nx_align_data nx_align_data_ins;				///< Align data instance for nx align s/m

  srio_1x_lane_data x1_lane_data_ins;				///< Align data instance for 1x align s/m

  srio_pl_rx_data_handler srio_pl_rx_data_handle_ins;		///< Rx data handler instance

  srio_pl_state_machine srio_pl_sm_ins;				///< PL State Machine instance

  srio_pl_protocol_checker srio_pl_pc_ins;			///< PL Protocol checker instance

  // Properties
  bit bfm_or_mon;						///< Flag to identify the instance as bfm or monitor. 1: bfm, 0: monitor.
  bit mon_type;							///< Flag to identify monitor type. 1 : tx_monitor ; 0 : rx_monitor
  bit report_error;						///< Flag to indicate whether to report error or warning. 1 : error ; 0 : warning 

  // Events
  uvm_event srio_rx_lane_event[int];				///< uvm event type to pass the lane data to higher blocks. Index indicates the lane no.

  // ports
  uvm_analysis_port #(srio_trans) link_mon_ap;			///< Monitor's analysis port.

  // Methods

  extern function new(string name="srio_pl_link_monitor", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  
endclass



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : New
/// Description : Constructor method for srio_pl_link_monitor class.
///////////////////////////////////////////////////////////////////////////////////////////////
function srio_pl_link_monitor::new(string name="srio_pl_link_monitor", uvm_component parent=null);
  super.new(name, parent);
endfunction



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : build_phase
/// Description : build_phase method for srio_pl_link_monitor class.
/// It gets various config_db variables and also creates all the comonents under this instance.
///////////////////////////////////////////////////////////////////////////////////////////////
function void srio_pl_link_monitor::build_phase(uvm_phase phase);

  if (!uvm_config_db #(srio_pl_config)::get(this, "", "pl_config", pl_link_mon_config))
    `uvm_fatal("CONFIG_LOAD", "Cannot get() PL CONFIG HANDLE")
  
 if (!uvm_config_db #(srio_pl_tx_rx_mon_common_trans)::get(this, "", "pl_tx_rx_mon_common_trans", pl_link_mon_common_trans))
    `uvm_fatal("CONFIG_LOAD", "Cannot get() pl_tx_rx_mon_common_trans handle")


  if (!uvm_config_db #(bit)::get(this, "", "mon_type", mon_type))
    `uvm_fatal("CONFIG_LOAD", "Cannot get() MON_TYPE Value")
  if (!uvm_config_db #(bit)::get(this, "", "report_error", report_error))
    `uvm_fatal("CONFIG_LOAD", "Cannot get() REPORT_ERROR Value")

  if (!uvm_config_db #(srio_env_config)::get(this, "", "srio_env_config", pl_link_mon_env_config))
    `uvm_fatal("CONFIG_LOAD", "Cannot get() ENV CONFIG HANDLE")

  `uvm_info("SRIO_PL_LINK_MONITOR :", $sformatf(" MON_TYPE is %0d", mon_type), UVM_LOW)
  `uvm_info("SRIO_PL_LINK_MONITOR :", $sformatf(" REPORT_ERR is %0d", report_error), UVM_LOW)

  if (mon_type)
  begin //{
    if (!uvm_config_db #(srio_pl_common_component_trans)::get(this, "", "pl_com_tx_trans", pl_link_mon_trans))
      `uvm_fatal("CONFIG_LOAD", "Cannot get() PL COMMON TX TRANS HANDLE")
  end //}
  else
  begin //{
    if (!uvm_config_db #(srio_pl_common_component_trans)::get(this, "", "pl_com_rx_trans", pl_link_mon_trans))
      `uvm_fatal("CONFIG_LOAD", "Cannot get() PL COMMON RX TRANS HANDLE")
  end //}

  if (!uvm_config_db #(bit)::get(this, "", "bfm_or_mon", bfm_or_mon))
    `uvm_fatal("CONFIG_LOAD", "Cannot get() bfm_or_mon Value")

  srio_if = pl_link_mon_config.srio_if;

  `uvm_info("SRIO_PL_LINK_MONITOR :", $sformatf(" MAX LANES SUPPORT is %0d", pl_link_mon_env_config.num_of_lanes), UVM_LOW)

  for (int num_ln=0; num_ln<pl_link_mon_env_config.num_of_lanes; num_ln++)
  begin //{
    lane_handle_ins[num_ln] = srio_pl_lane_handler::type_id::create($sformatf("pl_lane_handler[%0d]", num_ln), this);
    srio_rx_lane_event[num_ln] = new();

  end //}

  x2_align_data_ins = srio_2x_align_data::type_id::create("pl_2x_align_data", this);
  nx_align_data_ins = srio_nx_align_data::type_id::create("pl_nx_align_data", this);

  srio_pl_rx_data_handle_ins = srio_pl_rx_data_handler::type_id::create("srio_pl_rx_data_handle_ins", this);

  srio_pl_sm_ins = srio_pl_state_machine::type_id::create("pl_sm_handle", this);

  srio_pl_pc_ins = srio_pl_protocol_checker::type_id::create("srio_pl_pc_ins", this);

endfunction : build_phase



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name :connect_phase 
/// Description : connect_phase method for srio_pl_link_monitor class.
/// It connects the config_db variables to corresponding sub-compoenent variables, and also
/// creates a connection for the analysis port from protocol checker instance.
///////////////////////////////////////////////////////////////////////////////////////////////
function void srio_pl_link_monitor::connect_phase(uvm_phase phase);

  // analysis port connection
  link_mon_ap = srio_pl_pc_ins.pl_pc_ap;

  // register model connection
  if (mon_type)
    pl_link_mon_reg_model = pl_link_mon_env_config.srio_reg_model_rx;
  else
    pl_link_mon_reg_model = pl_link_mon_env_config.srio_reg_model_tx;

 // Lane handler instance connections.

  for (int num_ln=0; num_ln<pl_link_mon_env_config.num_of_lanes; num_ln++)
  begin //{
    lane_handle_ins[num_ln].srio_if = srio_if;
    lane_handle_ins[num_ln].lh_env_config = pl_link_mon_env_config;
    lane_handle_ins[num_ln].lh_config = pl_link_mon_config;
    lane_handle_ins[num_ln].lh_trans = pl_link_mon_trans;
    lane_handle_ins[num_ln].mon_type = mon_type;
    lane_handle_ins[num_ln].bfm_or_mon = bfm_or_mon;
    lane_handle_ins[num_ln].report_error = report_error;
    lane_handle_ins[num_ln].lane_num = num_ln;
    lane_handle_ins[num_ln].lh_reg_model = pl_link_mon_reg_model;
    lane_handle_ins[num_ln].lh_common_mon_trans= pl_link_mon_common_trans;

    lane_handle_ins[num_ln].srio_rx_lane_event = srio_rx_lane_event[num_ln];
  end //}


  // Rx Data handler instance connections.

  srio_pl_rx_data_handle_ins.srio_if = srio_if;
  srio_pl_rx_data_handle_ins.rx_dh_env_config = pl_link_mon_env_config;
  srio_pl_rx_data_handle_ins.rx_dh_config = pl_link_mon_config;
  srio_pl_rx_data_handle_ins.rx_dh_trans = pl_link_mon_trans;
  srio_pl_rx_data_handle_ins.mon_type = mon_type;
  srio_pl_rx_data_handle_ins.bfm_or_mon = bfm_or_mon;
  srio_pl_rx_data_handle_ins.report_error = report_error;
  srio_pl_rx_data_handle_ins.x2_align_data = x2_align_data_ins;
  srio_pl_rx_data_handle_ins.nx_align_data = nx_align_data_ins;
  //srio_pl_rx_data_handle_ins.x1_lane_data = x1_lane_data_ins;
  srio_pl_rx_data_handle_ins.rx_dh_common_mon_trans = pl_link_mon_common_trans;
  srio_pl_rx_data_handle_ins.rx_dh_reg_model = pl_link_mon_reg_model;

  for (int num_ln=0; num_ln<pl_link_mon_env_config.num_of_lanes; num_ln++)
    srio_pl_rx_data_handle_ins.srio_rx_lane_event[num_ln] = srio_rx_lane_event[num_ln];

  srio_pl_sm_ins.srio_if = srio_if;
  srio_pl_sm_ins.pl_sm_env_config = pl_link_mon_env_config;
  srio_pl_sm_ins.pl_sm_config = pl_link_mon_config;
  srio_pl_sm_ins.pl_sm_trans = pl_link_mon_trans;
  srio_pl_sm_ins.mon_type = mon_type;
  srio_pl_sm_ins.bfm_or_mon = bfm_or_mon;
  srio_pl_sm_ins.report_error = report_error;
  srio_pl_sm_ins.pl_sm_x2_align_data = x2_align_data_ins;
  srio_pl_sm_ins.pl_sm_nx_align_data = nx_align_data_ins;
  srio_pl_sm_ins.pl_sm_common_mon_trans = pl_link_mon_common_trans;
  srio_pl_sm_ins.pl_sm_reg_model = pl_link_mon_reg_model;

  srio_pl_pc_ins.srio_if = srio_if;
  srio_pl_pc_ins.pl_pc_env_config = pl_link_mon_env_config;
  srio_pl_pc_ins.pl_pc_config = pl_link_mon_config;
  srio_pl_pc_ins.pl_pc_trans = pl_link_mon_trans;
  srio_pl_pc_ins.pl_pc_common_mon_trans = pl_link_mon_common_trans;
  srio_pl_pc_ins.mon_type = mon_type;
  srio_pl_pc_ins.report_error = report_error;
  srio_pl_pc_ins.pl_pc_reg_model = pl_link_mon_reg_model;

endfunction : connect_phase
