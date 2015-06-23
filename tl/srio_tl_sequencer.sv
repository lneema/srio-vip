////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_tl_sequencer.sv
// Project :  srio vip
// Purpose :  Transport Layer Sequencer
// Author  :  Mobiveil
//
// TL Agent's Sequencer
//
//////////////////////////////////////////////////////////////////////////////// 

class srio_tl_sequencer extends  uvm_sequencer #(srio_trans);
  /// @cond 
 `uvm_component_utils(srio_tl_sequencer)
  /// @endcond 

  extern function new(string name="srio_tl_sequencer", uvm_component parent = null);
 
endclass

////////////////////////////////////////////////////////////////////////////////
/// Name: new \n 
/// Description: TL Sequencer's new function \n
/// new
//////////////////////////////////////////////////////////////////////////////// 

function srio_tl_sequencer::new (string name="srio_tl_sequencer", uvm_component parent = null);
  super.new(name, parent);
endfunction
