////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_sequencer.sv
// Project :  srio vip
// Purpose :  Logical Layer Sequencer
// Author  :  Mobiveil
//
// Logical Layer Agent Sequencer.
// 
//////////////////////////////////////////////////////////////////////////////// 

class srio_ll_sequencer extends  uvm_sequencer #(srio_trans);
  
  /// @cond
 `uvm_component_utils(srio_ll_sequencer)
  /// @endcond

  extern function new(string name="srio_ll_sequencer", uvm_component parent = null); ///< new function
 
endclass: srio_ll_sequencer

//////////////////////////////////////////////////////////////////////////
/// Name: new \n
/// Description: LL Sequencer's new function \n
/// new
//////////////////////////////////////////////////////////////////////////

function srio_ll_sequencer::new (string name="srio_ll_sequencer", uvm_component parent = null);
  super.new(name, parent);
endfunction: new
