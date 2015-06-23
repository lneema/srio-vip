////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_sequencer.sv
// Project :  srio vip
// Purpose :  Physical Layer Sequencer 
// Author  :  Mobiveil
//
// Physical Layer Sequencer component.
//
////////////////////////////////////////////////////////////////////////////////  

   class srio_pl_sequencer extends uvm_sequencer #(srio_trans);

   /// @cond
   `uvm_component_utils(srio_pl_sequencer)
   /// @endcond

   extern function new(string name = "srio_pl_sequencer", uvm_component parent = null);

   endclass


///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : New
/// Description : Constructor method for srio_pl_sequencer class.
///////////////////////////////////////////////////////////////////////////////////////////////
   function srio_pl_sequencer::new(string name = "srio_pl_sequencer", uvm_component parent = null);
     super.new(name, parent);
   endfunction
