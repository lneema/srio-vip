////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_tl_bfm.sv
// Project :  srio vip
// Purpose :  Transport Layer BFM
// Author  :  Mobiveil
//
// Transport Layer BFM active component.
// TL Generator and Receivers are instantiated.
//////////////////////////////////////////////////////////////////////////////// 

class srio_tl_bfm extends uvm_driver #(srio_trans);

  /// @cond 
  `uvm_component_utils (srio_tl_bfm)
  /// @endcond 

  srio_trans tl_seq_item;         ///< Sequence item from TL sequencer/sequence
  srio_trans tl_tx_seq_item;      ///< Sequence item from LL agent on the TX side
  srio_trans tl_rx_seq_item;      ///< Sequence item to LL agent on the RX side
  
  srio_tl_generator tl_generator;  ///< TL generator
  srio_tl_receiver  tl_receiver;   ///< TL receiver
  
  uvm_blocking_put_port #(srio_trans) tl_drv_put_port;   ///< TLM port connects TL and PL TX paths
  uvm_blocking_put_port #(srio_trans) tl_recv_put_port;  ///< TLM port connects TL and LL RX paths 
  uvm_blocking_get_port #(srio_trans) tl_drv_get_port;   ///< TLM port connects TL and LL TX paths 
  uvm_blocking_get_port #(srio_trans) tl_recv_get_port;  ///< TLM port connects TL and PL RX paths 
  
  extern function new(string name="srio_tl_bfm", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass: srio_tl_bfm

////////////////////////////////////////////////////////////////////////////////
/// Name: new \n 
/// Description: TL BFM's new function \n
/// new 
////////////////////////////////////////////////////////////////////////////////

function srio_tl_bfm::new(string name="srio_tl_bfm", uvm_component parent=null);
  super.new(name, parent);
  tl_drv_put_port = new("tl_drv_put_port", this);    // Create required TLM ports
  tl_drv_get_port = new("tl_drv_get_port", this);
  tl_recv_put_port = new("tl_recv_put_port", this);
  tl_recv_get_port = new("tl_recv_get_port", this);
endfunction: new

////////////////////////////////////////////////////////////////////////////////
/// Name: build_phase \n
/// Description: TL BFM's build_phase function \n
/// build_phase
////////////////////////////////////////////////////////////////////////////////

function void srio_tl_bfm::build_phase(uvm_phase phase);
  tl_generator = srio_tl_generator::type_id::create("tl_generator",this);  // TL Generator instance creation
  tl_receiver  = srio_tl_receiver::type_id::create("tl_receiver",this);    // TL Receiver  instance creation
endfunction: build_phase

////////////////////////////////////////////////////////////////////////////////
/// Name: connect_phase \n
/// Description: TL BFM's connect_phase function \n
/// connect_phase
////////////////////////////////////////////////////////////////////////////////

function void srio_tl_bfm::connect_phase(uvm_phase phase);
  tl_generator.tl_tr_gen_put_port.connect(tl_drv_put_port);   // TLM port connects TL and PL TX paths 
  tl_receiver.tl_tr_recv_put_port.connect(tl_recv_put_port);  // TLM port connects TL and LL RX paths
endfunction: connect_phase

////////////////////////////////////////////////////////////////////////////////
/// Name: run_phase \n
/// Description: TL BFM's run_phase function \n
/// run_phase
//////////////////////////////////////////////////////////////////////////////// 

task srio_tl_bfm::run_phase(uvm_phase phase);
begin
  fork 
  begin
    forever
    begin 
       tl_drv_get_port.get(tl_tx_seq_item);      // Get packets from LL on the TX side
       tl_generator.tl_pkt_gen(tl_tx_seq_item);  // Pass packets to the TL generator task
    end 
  end
  begin
    forever
    begin 
       tl_recv_get_port.get(tl_rx_seq_item);          // Receive packets from PL 
       tl_receiver.tl_pkt_recv(tl_rx_seq_item);       // Pass packets to TL receiver task
       tl_generator.process_rx_pkt(tl_rx_seq_item);   // Decode the received packets for flow control logic
    end 
  end 
  begin 
     forever
     begin 
       seq_item_port.get_next_item(tl_seq_item);   // Get sequence item from TL sequencer
       seq_item_port.item_done();
       `ifdef UVM_DISABLE_AUTO_ITEM_RECORDING
         end_tr(tl_seq_item);
       `endif
       tl_generator.tl_pkt_gen(tl_seq_item);       // Pass packets to the TL generator task
     end 
  end 
  join_none
end
endtask: run_phase
