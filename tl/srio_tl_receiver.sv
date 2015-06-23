////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_tl_receiver.sv
// Project :  srio vip
// Purpose :  Transport Layer Receiver
// Author  :  Mobiveil
//
// Receives the packets from PL and pass it to LL.
//
//////////////////////////////////////////////////////////////////////////////// 

class srio_tl_receiver extends uvm_component;

  /// @cond 
    `uvm_component_utils(srio_tl_receiver)
  /// @endcond 

   srio_trans srio_trans_item;   ///< Packet received from PL
   srio_env_config env_config;   ///< Env config object
 
   uvm_blocking_put_port #(srio_trans) tl_tr_recv_put_port; ///< TLM connects TL and LL RX paths

  /// @cond 
  `uvm_register_cb(srio_tl_receiver,srio_tl_callback)   ///< Register TL RX Call back method
  /// @endcond 

  extern function new(string name = "srio_tl_receiver", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern virtual task tl_pkt_recv(srio_trans i_srio_trans); 

  virtual task srio_tl_trans_received(ref srio_trans rx_srio_trans); ///< TL RX call back method
  endtask

endclass: srio_tl_receiver

////////////////////////////////////////////////////////////////////////////////
/// Name: new \n 
/// Description: TL receiver's new function \n
/// new
//////////////////////////////////////////////////////////////////////////////// 

function srio_tl_receiver::new(string name = "srio_tl_receiver", uvm_component parent = null);
  super.new(name, parent);
  tl_tr_recv_put_port = new("tl_tr_recv_put_port", this);
endfunction: new

////////////////////////////////////////////////////////////////////////////////
/// Name: build_phase \n
/// Description: TL receiver's build_phase function \n
/// build_phase
////////////////////////////////////////////////////////////////////////////////

function void srio_tl_receiver::build_phase(uvm_phase phase);
  if(!uvm_config_db #(srio_env_config)::get(this, "", "srio_env_config", env_config)) // Get Env config handle from config database
    `uvm_fatal("CONFIG FATAL", "Can't get the env_config")
endfunction: build_phase

////////////////////////////////////////////////////////////////////////////////
/// Name: tl_pkt_recv \n
/// Description: Invoked whenever packet is received from PL \n
/// tl_pkt_recv
////////////////////////////////////////////////////////////////////////////////

task srio_tl_receiver::tl_pkt_recv(srio_trans i_srio_trans);
begin 
    srio_trans_item = new i_srio_trans;

   `uvm_do_callbacks(srio_tl_receiver,srio_tl_callback,srio_tl_trans_received(i_srio_trans)) // Trigger TL RX call back method

    tl_tr_recv_put_port.put(srio_trans_item);   // Put the packet to TL->LL TLM port
end 
endtask: tl_pkt_recv
