////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_tl_func_coverage.sv
// Project :  srio vip
// Purpose :  Transport Layer Functional Coverage
// Author  :  Mobiveil
//
// Contains TL layer related coverpoints.
// 
//////////////////////////////////////////////////////////////////////////////// 
class srio_tl_func_coverage extends uvm_component;

  `uvm_component_utils(srio_tl_func_coverage)
  
  srio_env_config env_config;
  srio_trans tx_trans; ///< transactions in tx path
  srio_trans rx_trans; ///< transactions in rx path
  srio_tl_tx_trans_collector tx_trans_collector;
  srio_tl_rx_trans_collector rx_trans_collector;
  event      tx_trans_event, rx_trans_event;
  
  logic [4:0] address;
  bit wnr;
  
  covergroup CG_TL_TX_PATH @(tx_trans_event);
    option.per_instance = 1;
    CP_TL_TX_TT_VALID : coverpoint tx_trans.tt
                        {
                          bins device_id_8bit = {0};
                          bins device_id_16bit = {1};
                          bins device_id_32bit = {2};
                        }
    CP_TL_TX_TT_INVALID : coverpoint tx_trans.tt
                        {
                          bins invalid_bins[] = {3};
                        }
    CP_TL_TX_SOURCEID : coverpoint tx_trans.SourceID
                        {
                          bins srcID = {[0:32'hFFFF_FFFF]};
                        }
    CP_TL_TX_DESTINATION_ID : coverpoint tx_trans.DestinationID
                        {
                          bins destID = {[0:32'hFFFF_FFFF]};
                        }
  endgroup: CG_TL_TX_PATH
  
  covergroup CG_TL_RX_PATH @(rx_trans_event);
    option.per_instance = 1;
    CP_TL_RX_TT_VALID : coverpoint rx_trans.tt
                        {
                          bins device_id_8bit = {0};
                          bins device_id_16bit = {1};
                          bins device_id_32bit = {2};
                        }
    CP_TL_RX_SOURCEID : coverpoint rx_trans.SourceID
                        {
                          bins srcID = {[0:32'hFFFF_FFFF]};
                        }
    CP_TL_RX_DESTINATION_ID : coverpoint rx_trans.DestinationID
                        {
                          bins destID = {[0:32'hFFFF_FFFF]};
                        }
  endgroup: CG_TL_RX_PATH

  extern function new(string name = "srio_tl_func_coverage", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass: srio_tl_func_coverage

function srio_tl_func_coverage::new(string name = "srio_tl_func_coverage", uvm_component parent = null);
  super.new(name, parent);
  CG_TL_TX_PATH = new();
  CG_TL_RX_PATH = new();
endfunction

function void srio_tl_func_coverage::build_phase(uvm_phase phase);
    tx_trans_collector = srio_tl_tx_trans_collector::type_id::create("tx_trans_collector", this);
    rx_trans_collector = srio_tl_rx_trans_collector::type_id::create("rx_trans_collector", this);
    if(!uvm_config_db #(srio_env_config)::get(this, "", "srio_env_config", env_config))
     `uvm_fatal("CONFIG FATAL", "Can't get the env_config")
endfunction : build_phase

task srio_tl_func_coverage::run_phase(uvm_phase phase);

  fork
    begin : tx_collector
      while(1)
      begin //{
        /// wait for the event trigger from srio_tl_tx_trans_collector
        @(tx_trans_collector.tx_trans_received);
        this.tx_trans = tx_trans_collector.tx_trans;
        -> tx_trans_event;
      end //}
    end // tx_collector
    begin : rx_collector
      while(1)
      begin //{
        /// wait for the event trigger from srio_tl_rx_trans_collector
        @(rx_trans_collector.rx_trans_received);
        this.rx_trans = rx_trans_collector.rx_trans;
        -> rx_trans_event;
      end //} //while(1)
    end // rx_collector
  join_none

endtask : run_phase

