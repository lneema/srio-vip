////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_logical_transaction_generator.sv
// Project :  srio vip
// Purpose :  Logical Layer Transaction Generator
// Author  :  Mobiveil
//
// Logical Layer transaction generator component instantiates various packet
// generators. Extended from srio_ll_base_generator.
//////////////////////////////////////////////////////////////////////////////// 

class srio_logical_transaction_generator extends srio_ll_base_generator;

  /// @cond
  `uvm_component_utils(srio_logical_transaction_generator)
  /// @endcond

   srio_io_generator      io_generator;         ///< IO Generator 
   srio_msg_db_generator  msg_db_generator;     ///< MSG and DB Generator 
   srio_gsm_generator     gsm_generator;        ///< GSM Generator
   srio_lfc_generator     lfc_generator;        ///< LFC Generator
   srio_ds_generator      ds_generator;         ///< DS Generator
   srio_resp_generator    resp_generator;       ///< Response Generator
   srio_ll_common_class   ll_common_class;      ///< LL Common class used by active components

   uvm_blocking_put_port #(srio_trans) ll_tr_gen_put_port;  ///< TLM connects LL and TL on the TX side
   uvm_blocking_put_export #(srio_trans) tr_gen_put_export; ///< TLM connects packet handler and resp genetator
   uvm_tlm_fifo #(srio_trans) intl_fifo;                    ///< TLM FIFO

  /// @cond
  `uvm_register_cb(srio_logical_transaction_generator,srio_ll_callback) ///< Register LL TX Call back method
  /// @endcond

   bit [3:0]  next_pkt_type = 0; ///< 0-IO,1-MSG,2-DB,3-DS,4-GSM,5-LFC. Response is not part of arbitration
   bit [31:0] tx_pkt_id     = 0; ///< Packet ID used when interleaved is FALSE

   extern function new(string name="SRIO_LOGICAL_TRANSACTION_GENERATOR", uvm_component parent = null); ///< new function
   extern function void build_phase(uvm_phase phase);                 ///< build_phase function
   extern function void connect_phase(uvm_phase phase);               ///< connect_phase function 
   extern task run_phase(uvm_phase phase);                            ///< run_phase
   extern virtual task push_seq_item(srio_trans srio_trans_seq_item); ///< Task to get sequence item
   extern virtual task packet_scheduler(uvm_phase phase);                            ///< Implements packet scheduling logic 

   virtual task srio_ll_trans_generated(ref srio_trans tx_srio_trans); ///< LL TX Call back method
   endtask

endclass: srio_logical_transaction_generator

//////////////////////////////////////////////////////////////////////////
/// Name: new \n
/// Description: Logical ttransaction generator's new function \n
/// new
//////////////////////////////////////////////////////////////////////////

function srio_logical_transaction_generator::new (string name = "SRIO_LOGICAL_TRANSACTION_GENERATOR", uvm_component parent = null);
  super.new(name, parent);
  ll_tr_gen_put_port = new("ll_tr_gen_put_port", this);
  tr_gen_put_export  = new("tr_gen_put_export",this);
  intl_fifo          = new("intl_fifo",this);
endfunction: new

//////////////////////////////////////////////////////////////////////////
/// Name: build_phase \n
/// Description: Logical ttransaction generator's build_phase function \n
//  Creates invidual packet generators \n
/// build_phase
//////////////////////////////////////////////////////////////////////////

function void srio_logical_transaction_generator::build_phase(uvm_phase phase);
 
  super.build_phase(phase);
  io_generator      = srio_io_generator::type_id::create("SRIO_LL_IO_GENERATOR",this);
  msg_db_generator  = srio_msg_db_generator::type_id::create("SRIO_LL_MSG_DB_GENERATOR",this);
  gsm_generator     = srio_gsm_generator::type_id::create("SRIO_LL_GSM_GENERATOR",this);
  lfc_generator     = srio_lfc_generator::type_id::create("SRIO_LL_LFC_GENERATOR",this);
  ds_generator      = srio_ds_generator::type_id::create("SRIO_LL_DS_GENERATOR",this);
  resp_generator    = srio_resp_generator::type_id::create("SRIO_LL_RESP_GENERATOR",this);

endfunction: build_phase

//////////////////////////////////////////////////////////////////////////
/// Name: connect_phase \n
/// Description: Logical ttransaction generator's connect_phase function \n
/// Required connections for TLM ports \n
/// connect_phase
//////////////////////////////////////////////////////////////////////////

function void srio_logical_transaction_generator::connect_phase(uvm_phase phase);
  super.connect_phase(phase); 
  tr_gen_put_export.connect(intl_fifo.put_export);
  resp_generator.resp_gen_get_port.connect(intl_fifo.get_export);
endfunction: connect_phase

//////////////////////////////////////////////////////////////////////////
/// Name: run_phase \n
/// Description: Logical ttransaction generator's run_phase function \n
/// Invokes packet schedule thread \n
/// connect_phase
//////////////////////////////////////////////////////////////////////////

task srio_logical_transaction_generator::run_phase(uvm_phase phase);
    fork
      packet_scheduler(phase);
    join_none
endtask: run_phase

//////////////////////////////////////////////////////////////////////////
/// Name: packet_scheduler \n
/// Description: Scheduling packet \n
/// If interleaved is FALSE, packets are transmitted in the order they \n
/// received from sequence.Each packet is with embeded with a packet id \n
/// to transmits them in the order.If interleaved is TRUE, packets from \n
/// various generators are transmitted in RR or random manner based on the ratio \n
/// programmed. \n
/// pack_scheduler
//////////////////////////////////////////////////////////////////////////

task srio_logical_transaction_generator::packet_scheduler(uvm_phase phase);
srio_trans next_item;
bool pkt_valid;
begin 
    forever
    begin
       // Wait till any of the generator has packets and block traffic
       // valriable is FALSE.
       wait(ll_common_class.pkt_cnt > 0 && ll_config.block_ll_traffic == FALSE);
       phase.raise_objection(this);
       
       pkt_valid = FALSE;   /// Packet valid is FALSE initially
       // Response packet transmission is not part of any arbitration.
       // They are given first priotiry in transmission
       resp_generator.get_next_pkt(0,0,pkt_valid,next_item); // Get next packet from response generator
                                                             // if packet is available pkt_valid will be made TRUE
       if(pkt_valid == FALSE)   // If response packet is available for transmission, no need to check with other generators
       begin
         // Rund Robin method. Incase interleaved is false, packet is
         // fetched based on the packet id
         if(ll_config.arb_type == SRIO_LL_RR || ll_config.interleaved_pkt == FALSE) 
         begin
           case(next_pkt_type)
              4'h0: io_generator.get_next_pkt(0,tx_pkt_id,pkt_valid,next_item);
              4'h1: msg_db_generator.get_next_pkt(0,tx_pkt_id,pkt_valid,next_item);
              4'h2: msg_db_generator.get_next_pkt(1,tx_pkt_id,pkt_valid,next_item);
              4'h3: ds_generator.get_next_pkt(0,tx_pkt_id,pkt_valid,next_item);
              4'h4: gsm_generator.get_next_pkt(0,tx_pkt_id,pkt_valid,next_item);
              4'h5: lfc_generator.get_next_pkt(0,tx_pkt_id,pkt_valid,next_item);
           endcase
             if(pkt_valid)
               tx_pkt_id++;           // if pkt is available to transmit, increment packet id to for next packet
             if(next_pkt_type >= 5)   // For Round Robin
               next_pkt_type = 0;
             else
               next_pkt_type++;
         end else
         begin                        // Interleaved is TRUE and packet transmission is based on the ratio
            next_pkt_type = 0;        
            randcase 
              ll_config.io_pkt_ratio:  io_generator.get_next_pkt(0,0,pkt_valid,next_item);
              ll_config.db_pkt_ratio:  msg_db_generator.get_next_pkt(0,0,pkt_valid,next_item);
              ll_config.msg_pkt_ratio: msg_db_generator.get_next_pkt(1,0,pkt_valid,next_item);
              ll_config.ds_pkt_ratio:  ds_generator.get_next_pkt(1,0,pkt_valid,next_item);
              ll_config.gsm_pkt_ratio: gsm_generator.get_next_pkt(0,0,pkt_valid,next_item);
              ll_config.lfc_pkt_ratio: lfc_generator.get_next_pkt(0,0,pkt_valid,next_item);
           endcase
         end
       end
       if(pkt_valid == TRUE)  // if packet is found from any of the generator
       begin                  // invoke the call back
         `uvm_do_callbacks(srio_logical_transaction_generator,srio_ll_callback,srio_ll_trans_generated(next_item))
         ll_tr_gen_put_port.put(next_item); // Push the packet to TL
         ll_config.bfm_tx_pkt_cnt++;        // increment LL TX packet count
         ->ll_config.ll_pkt_transmitted;    // Tigger event to indicate that a packet is transmitted from LL
       end
       phase.drop_objection(this);
    end
end
endtask: packet_scheduler 

//////////////////////////////////////////////////////////////////////////
/// Name: push_seq_item \n
/// Description: Called by LL BFM whenever a packet is recveived from sequence \n
/// Checks if the packet has valid ftype/ttype.Checks what kind of packet, \n
/// based on that push the packet to respecive generator \n
/// push_seq_item
//////////////////////////////////////////////////////////////////////////

task srio_logical_transaction_generator::push_seq_item(srio_trans srio_trans_seq_item);
bool ft_valid;
srio_ll_gen_kind ll_gen_kind;
begin
    srio_trans_item = new srio_trans_seq_item; 
    ft_valid = is_ftype_ttype_valid(srio_trans_item);   // Check ftype/ttype valid
    if(ft_valid)                                        // if valid consider else drop
    begin
      ll_gen_kind = get_ll_gen_kind(srio_trans_item);   // Get the category of the packet
      srio_trans_item.ll_gen_kind = ll_gen_kind;
      case(ll_gen_kind)                                 // Push packet to the corresponding generator
        IO:     io_generator.push_pkt(srio_trans_item);
        MSG_DB: msg_db_generator.push_pkt(srio_trans_item);
        DS:     ds_generator.push_pkt(srio_trans_item);
        GSM:    gsm_generator.push_pkt(srio_trans_item);
        LFC:    lfc_generator.push_pkt(srio_trans_item);
        RESP:   resp_generator.push_pkt(srio_trans_item);
      endcase
    end
end
endtask: push_seq_item
