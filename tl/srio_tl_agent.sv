////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_tl_agent.sv
// Project :  srio vip
// Purpose :  Transport Layer Agent
// Author  :  Mobiveil
//
// Agent component for transport layer.Instantiates the active and passive
// components.
//////////////////////////////////////////////////////////////////////////////// 

class srio_tl_agent extends uvm_agent;

  /// @cond 
  `uvm_component_utils(srio_tl_agent)
  /// @endcond 

  srio_tl_sequencer tl_sequencer;     ///< TL Sequencer
  srio_tl_config    tl_config;        ///< TL Config 
  srio_tl_bfm       tl_bfm;           ///< TL BFM
  srio_tl_monitor   tl_monitor;       ///< TL Monitor

  uvm_put_port #(srio_trans) tl_agent_tx_put_port,tl_agent_rx_put_port;        ///< TLM ports from TL to LL 
  uvm_put_export #(srio_trans) tl_agent_tx_put_export,tl_agent_rx_put_export;  ///< TLM ports from PL to TL
  uvm_tlm_fifo #(srio_trans) tl_tx_fifo,tl_rx_fifo;                            ///< TLM ports fifo  
  
  uvm_analysis_port #(srio_trans) tx_mon_ap;        ///< Analysis port TL TX monitor to LL TX monitor
  uvm_analysis_port #(srio_trans) rx_mon_ap;        ///< Analysis port TL RX monitor to LL RX monitor

  extern function new(string name="srio_tl_agent", uvm_component parent = null); 
  extern function void build_phase(uvm_phase phase);                             
  extern function void connect_phase(uvm_phase phase);

endclass: srio_tl_agent

////////////////////////////////////////////////////////////////////////////////
/// Name: new \n 
/// Description: TL agent's new function \n
/// new
//////////////////////////////////////////////////////////////////////////////// 

function srio_tl_agent::new(string name="srio_tl_agent", uvm_component parent=null);
  super.new(name,parent);
  tl_agent_tx_put_port = new("tl_agent_tx_put_port", this);
  tl_agent_rx_put_port = new("tl_agent_rx_put_port", this);
  tl_agent_tx_put_export = new("tl_agent_tx_put_export", this);
  tl_agent_rx_put_export = new("tl_agent_rx_put_export", this);
  tl_tx_fifo = new("tl_tx_fifo", this);
  tl_rx_fifo = new("tl_rx_fifo", this);
endfunction: new

////////////////////////////////////////////////////////////////////////////////
/// Name: build_phase \n
/// Description: TL agent's build_phase function \n
/// build_phase
////////////////////////////////////////////////////////////////////////////////

function void srio_tl_agent::build_phase(uvm_phase phase);
  tl_config = srio_tl_config::type_id::create("tl_config", this);         // Create TL config object 
  uvm_config_db #(srio_tl_config)::set(this,"*", "tl_config", tl_config); // Store TL config handle to config database
  if (tl_config.is_active == UVM_ACTIVE)                                  // Agent is active component
  begin
    tl_sequencer = srio_tl_sequencer::type_id::create("tl_sequencer",this); // Create TL sequencer active component
    tl_bfm       = srio_tl_bfm::type_id::create("tl_bfm",this);             // Create TL BFM active component
  end
  tl_monitor   = srio_tl_monitor::type_id::create("tl_monitor",this);    // Create TL passive monitor instance
endfunction: build_phase

////////////////////////////////////////////////////////////////////////////////
/// Name: connect_phase \n
/// Description: TL agent's connect_phase function \n
/// connect_phase
////////////////////////////////////////////////////////////////////////////////

function void srio_tl_agent::connect_phase(uvm_phase phase);

 if (tl_config.is_active == UVM_ACTIVE)  // If Active, connect active components
 begin
   tl_bfm.seq_item_port.connect(tl_sequencer.seq_item_export);  // TL sequencer Port
   tl_bfm.tl_drv_put_port.connect(tl_agent_tx_put_port);
   tl_agent_tx_put_export.connect(tl_tx_fifo.put_export);
   tl_bfm.tl_drv_get_port.connect(tl_tx_fifo.get_export); // TX TLM from LL Agent

   tl_agent_rx_put_export.connect(tl_rx_fifo.put_export);  
   tl_bfm.tl_recv_get_port.connect(tl_rx_fifo.get_export);
   tl_bfm.tl_recv_put_port.connect(tl_agent_rx_put_port);   // RX TLM to LL Agent
  end 

  tx_mon_ap = tl_monitor.tx_mon_ap;  // Analysis port connecting TL TX and LL TX monitors 
  rx_mon_ap = tl_monitor.rx_mon_ap;  // Analysis port connecting TL RX and LL RX monitors 

endfunction: connect_phase
