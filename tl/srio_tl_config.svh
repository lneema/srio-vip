////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_tl_config.sv
// Project :  srio vip
// Purpose :  Transport Layer Configuration
// Author  :  Mobiveil
//
// Contains the TL configuration class and its variables.
//
//////////////////////////////////////////////////////////////////////////////// 

class srio_tl_config extends uvm_object;

  /// @cond 
  `uvm_object_utils(srio_tl_config)
  /// @endcond 

  bit  en_deviceid_chk;                            ///< Enable/Disable Device ID Check 

  uvm_active_passive_enum is_active = UVM_ACTIVE;  ///< Active or passive agent.

  bit has_checks   = 1;  			   ///< checks enable
  bit has_coverage = 1;			           ///< coverage enable

  bool usr_sourceid_en      = FALSE;               ///< Enable/disable user desired source id 
  bool usr_destinationid_en = FALSE;               ///< Enable/disable user desired destination id
  bit [31:0] usr_sourceid       = 32'hFFFF_FFFF;   ///< Desired Source id value from user
  bit [31:0] usr_destinationid  = 32'hFFFF_FFFF;   ///< Desired Destination id value from user
 
  integer lfc_orphan_timer = 10000;                ///< Orphan timer value for LFC  packets in ns

  extern function new (string name = "srio_tl_config");

endclass: srio_tl_config

////////////////////////////////////////////////////////////////////////////////
/// Name: new  \n
/// Description: TL config's new function \n
/// new
//////////////////////////////////////////////////////////////////////////////// 

function srio_tl_config::new(string name = "srio_tl_config");
  super.new(name);

  en_deviceid_chk = 0;

endfunction: new
