////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_tx_trans_collector.sv
// Project :  srio vip
// Purpose :  
// Author  :  Mobiveil
//
// Instantiated inside srio_pl_func_coverage class. It receives transactions
// from pl agent tx monitor.
// 
//////////////////////////////////////////////////////////////////////////////// 
class srio_pl_tx_trans_collector extends uvm_subscriber #(srio_trans);

  `uvm_component_utils(srio_pl_tx_trans_collector)
  
  srio_trans tx_trans_temp;
  srio_trans tx_trans[$];
  event tx_trans_received;
  
  extern function new(string name = "srio_pl_tx_trans_collector", uvm_component parent = null);
  extern function void write(srio_trans t);
  extern function void build_phase(uvm_phase phase);
  
endclass: srio_pl_tx_trans_collector

function srio_pl_tx_trans_collector::new(string name = "srio_pl_tx_trans_collector", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void srio_pl_tx_trans_collector::build_phase(uvm_phase phase);
endfunction

function void srio_pl_tx_trans_collector::write(srio_trans t);
  
    tx_trans_temp = new t;
    tx_trans.push_back(tx_trans_temp);
    -> tx_trans_received;

endfunction: write

