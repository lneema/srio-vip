////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_rx_trans_collector.sv
// Project :  srio vip
// Purpose :  
// Author  :  Mobiveil
//
// Instantiated inside srio_ll_func_coverage class. It receives transactions
// from ll agent rx monitor.
// 
//////////////////////////////////////////////////////////////////////////////// 
class srio_ll_rx_trans_collector extends uvm_subscriber #(srio_trans);

  `uvm_component_utils(srio_ll_rx_trans_collector)
  
  srio_trans rx_trans;
  event rx_trans_received; ///< event triggered upon reception of transaction from rx monitor
  
  extern function new(string name = "srio_ll_rx_trans_collector", uvm_component parent = null);
  extern function void write(srio_trans t);
  extern function void build_phase(uvm_phase phase);
  
endclass: srio_ll_rx_trans_collector

function srio_ll_rx_trans_collector::new(string name = "srio_ll_rx_trans_collector", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void srio_ll_rx_trans_collector::build_phase(uvm_phase phase);
endfunction

function void srio_ll_rx_trans_collector::write(srio_trans t);
  
    rx_trans = new t;   ///< transaction received from rx monitor
    -> rx_trans_received;

endfunction: write

