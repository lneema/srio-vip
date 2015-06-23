////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_bfm.sv
// Project :  srio vip
// Purpose :  Logical Layer BFM
// Author  :  Mobiveil
//
// Logical Layer BFM component. Top module of Active logic
//
//////////////////////////////////////////////////////////////////////////////// 

class srio_ll_bfm extends uvm_driver #(srio_trans);

  /// @cond
  `uvm_component_utils (srio_ll_bfm)
  /// @endcond

  srio_logical_transaction_generator logical_transaction_generator;///< logical trans generator object
  srio_packet_handler  packet_handler;                             ///< Packet handler object
  srio_ll_common_class ll_common_class;                            ///< LL common class object 
  
  uvm_blocking_put_port #(srio_trans) ll_drv_put_port;   ///< TLM port used to put the packets to TL from LL
  uvm_blocking_get_port #(srio_trans) ll_drv_get_port;   ///< TLM port connects packet handler -> response generator
  
  extern function new(string name="srio_ll_bfm", uvm_component parent = null);///< new function
  extern function void build_phase(uvm_phase phase);                          ///< build_phase
  extern function void connect_phase(uvm_phase phase);                        ///< connect_phase 
  extern task run_phase(uvm_phase phase);                                     ///< run_phase  

endclass: srio_ll_bfm

//////////////////////////////////////////////////////////////////////////
/// Name: new \n
/// Description: LL BFM's new function \n
/// new
//////////////////////////////////////////////////////////////////////////

function srio_ll_bfm::new(string name="srio_ll_bfm", uvm_component parent=null);
  super.new(name, parent);
  ll_drv_put_port = new("ll_drv_put_port", this);
  ll_drv_get_port = new("ll_drv_get_port", this);
endfunction: new

//////////////////////////////////////////////////////////////////////////
/// Name: build_phase \n
/// Description: LL BFM's build_phase function \n
/// build_phase
//////////////////////////////////////////////////////////////////////////

function void srio_ll_bfm::build_phase(uvm_phase phase);
  ll_common_class = srio_ll_common_class::type_id::create("ll_common_class",this);         // LL common class creation
  uvm_config_db #(srio_ll_common_class)::set(this,"*", "ll_common_class", ll_common_class);// Store ll common class handle to database
  logical_transaction_generator = srio_logical_transaction_generator::type_id::create("logical_transaction_generator",this);
  packet_handler  = srio_packet_handler::type_id::create("packet_handler",this);
endfunction: build_phase

//////////////////////////////////////////////////////////////////////////
/// Name: connect_phase \n
/// Description: LL BFM's connect_phase function \n
/// connect_phase
//////////////////////////////////////////////////////////////////////////

function void srio_ll_bfm::connect_phase(uvm_phase phase);
  logical_transaction_generator.ll_tr_gen_put_port.connect(ll_drv_put_port);
  packet_handler.ll_pkt_handler_get_port.connect(ll_drv_get_port);
  packet_handler.pkt_handler_put_port.connect(logical_transaction_generator.tr_gen_put_export);
  logical_transaction_generator.ll_common_class = ll_common_class; 
endfunction: connect_phase

//////////////////////////////////////////////////////////////////////////
/// Name: run_phase \n
/// Description: LL BFM's run_phase function \n
/// run_phase
//////////////////////////////////////////////////////////////////////////

task srio_ll_bfm::run_phase(uvm_phase phase);
  forever
  begin 
    srio_trans ll_seq_item;
    seq_item_port.get_next_item(ll_seq_item);                  // Get packet from LL sequencer
    if(ll_seq_item != null)
      logical_transaction_generator.push_seq_item(ll_seq_item);// pass it to logical trans generator for further processing
    seq_item_port.item_done();                                 // Assert sequence item done
   `ifdef UVM_DISABLE_AUTO_ITEM_RECORDING
     end_tr(ll_seq_item);
   `endif
  end
endtask: run_phase
