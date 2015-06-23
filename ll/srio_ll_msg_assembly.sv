////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_msg_assembly.sv
// Project :  srio vip
// Purpose :  MSG Assembly
// Author  :  Mobiveil
//
// Contains srio_ll_msg_assembly class used for MSG assembly and testing in LL
// monitor
// 
//////////////////////////////////////////////////////////////////////////////// 

class srio_ll_msg_assembly extends uvm_object;
  /// @cond
  `uvm_object_utils(srio_ll_msg_assembly)
  bit [3:0]  msg_len;
  bit [3:0]  ssize;
  bit        err_sts;
  bit        seg_list[bit[3:0]]; // Used to save arrived segment details
  bit [31:0] SourceID;
  bit        msg_type;    // 0-> sseg; 1-> mseg
  /// @endcond

////////////////////////////////////////////////////////////////////////////////
/// Name: new  \n
/// Description: LL msg_assembly class's new function \n
/// new
////////////////////////////////////////////////////////////////////////////////

  function new(string name="srio_ll_msg_assembly");
    super.new(name);
  endfunction: new

endclass: srio_ll_msg_assembly

// =============================================================================

