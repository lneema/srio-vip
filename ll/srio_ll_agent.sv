////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_agent.sv
// Project :  srio vip
// Purpose :  Logical Layer Agent
// Author  :  Mobiveil
//
// Logical Layer agent components includes active and passive components.
//
//////////////////////////////////////////////////////////////////////////////// 

class srio_ll_agent extends uvm_agent;

  /// @cond
  `uvm_component_utils(srio_ll_agent)
  /// @endcond

  srio_ll_sequencer ll_sequencer;   ///< LL sequencer object
  srio_ll_config    ll_config;      ///< LL config object
  srio_ll_bfm       ll_bfm;         ///< LL Acive component BFM object  
  srio_ll_monitor   ll_monitor;     ///< LL Passive monitor object

  uvm_analysis_port #(srio_trans) tx_mon_ap;           ///< Analysis port for TX monitor 
  uvm_analysis_port #(srio_trans) rx_mon_ap;           ///< Analysis port for RX monitor

  uvm_put_port   #(srio_trans) ll_agent_tx_put_port;   ///< TLM port connects LL->TL TX path
  uvm_put_export #(srio_trans) ll_agent_rx_put_export; ///< TLM port connects LL<-TL RX path 
  uvm_tlm_fifo   #(srio_trans) ll_rx_fifo;             ///< TLM FIFO for the RX path

  extern function new(string name="srio_ll_agent", uvm_component parent = null); ///< new function
  extern function void build_phase(uvm_phase phase);                             ///< build_phase
  extern function void connect_phase(uvm_phase phase);                           ///< connect_phase

endclass: srio_ll_agent

//////////////////////////////////////////////////////////////////////////
/// Name: new \n
/// Description: LL Agent's new function \n
/// new
//////////////////////////////////////////////////////////////////////////

function srio_ll_agent::new(string name="srio_ll_agent", uvm_component parent=null);
  super.new(name,parent);
  ll_agent_tx_put_port = new("ll_agent_tx_put_port", this);
  ll_agent_rx_put_export = new("ll_agent_rx_put_export", this);
  ll_rx_fifo = new("ll_rx_fifo", this);
endfunction: new

//////////////////////////////////////////////////////////////////////////
/// Name: build_phase \n
/// Description: LL Agent's build_phase function \n
/// build_phase
//////////////////////////////////////////////////////////////////////////

function void srio_ll_agent::build_phase(uvm_phase phase);
  ll_config = srio_ll_config::type_id::create("ll_config", this);          // Create LL config object
  uvm_config_db #(srio_ll_config)::set(this,"*", "ll_config", ll_config);  // Store LL config handle in Config data base
  if (ll_config.is_active == UVM_ACTIVE)                                   // ACTIVE Component creation
  begin
    ll_sequencer = srio_ll_sequencer::type_id::create("ll_sequencer",this);// LL Sequencer
    ll_bfm       = srio_ll_bfm::type_id::create("ll_bfm",this);            // LL BFM
  end 
  ll_monitor   = srio_ll_monitor::type_id::create("ll_monitor",this);      // LL Passive Monitor Creation 
  tx_mon_ap    = new("tx_mon_ap", this);                                    
  rx_mon_ap    = new("rx_mon_ap", this);
endfunction: build_phase

//////////////////////////////////////////////////////////////////////////
/// Name: connect_phase \n
/// Description: LL Agent's connect_phase function \n
/// connect_phase
//////////////////////////////////////////////////////////////////////////

function void srio_ll_agent::connect_phase(uvm_phase phase);
  if(ll_config.is_active == UVM_ACTIVE)                         // Connections for LL Acitve components
  begin
    ll_bfm.seq_item_port.connect(ll_sequencer.seq_item_export);// LL sequencer, agent connection
    ll_bfm.ll_drv_put_port.connect(ll_agent_tx_put_port);      // LL->TL TX path conneection 
    ll_agent_rx_put_export.connect(ll_rx_fifo.put_export);     // LL<-TL RX path connections  
    ll_bfm.ll_drv_get_port.connect(ll_rx_fifo.get_export);
  end 
  ll_monitor.tx_mon_ap.connect(tx_mon_ap);
  ll_monitor.rx_mon_ap.connect(rx_mon_ap);
endfunction: connect_phase
