////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_virtual_sequencer.sv
// Project :  srio vip
// Purpose :  Virtual Sequencer
// Author  :  Mobiveil
//
// SRIO VIP Virtual Sequencer Class.Has the handles of individual
// layer's virtual sequencer
////////////////////////////////////////////////////////////////////////////////

class srio_virtual_sequencer extends  uvm_sequencer #(srio_trans);

 `uvm_component_utils(srio_virtual_sequencer)

  srio_ll_sequencer v_ll_sequencer;   ///< Handle of LL virtual sequencer
  srio_tl_sequencer v_tl_sequencer;   ///< Handle of TL virtual sequencer
  srio_pl_sequencer v_pl_sequencer;   ///< Handle of PL virtual sequencer


  extern function new(string name="srio_virtual_sequencer", uvm_component parent = null);
 
endclass: srio_virtual_sequencer

//////////////////////////////////////////////////////////////////////////
/// Name: new
/// Description: Virtual Sequencer's new function
/// new
//////////////////////////////////////////////////////////////////////////

function srio_virtual_sequencer::new (string name="srio_virtual_sequencer", uvm_component parent = null);
  super.new(name, parent);
endfunction: new

