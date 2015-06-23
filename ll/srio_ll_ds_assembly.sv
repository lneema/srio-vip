////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_ds_assembly.sv
// Project :  srio vip
// Purpose :  DS Assembly
// Author  :  Mobiveil
//
// Contains srio_ll_ds_assembly class used for DS assembly and testing in LL
// monitor
// 
//////////////////////////////////////////////////////////////////////////////// 

class srio_ll_ds_assembly extends uvm_object;
  /// @cond
  `uvm_object_utils(srio_ll_ds_assembly)
  bit        odd; 
  bit        pad;
  bit [16:0] length_received; 
  bit [ 2:0] flowID; 
  bit [15:0] seg_received;
  bit [31:0] SourceID;
  /// @endcond
 
////////////////////////////////////////////////////////////////////////////////
/// Name: new \n 
/// Description: LL DS assembly class's new function \n
/// new
////////////////////////////////////////////////////////////////////////////////

  function new(string name="srio_ll_ds_assembly");
    super.new(name);
  endfunction: new

endclass: srio_ll_ds_assembly

// =============================================================================
