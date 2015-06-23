////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_lfc_generator.sv
// Project :  srio vip
// Purpose :  LFC Packet Generation
// Author  :  Mobiveil
//
// This components handles the generation of LFC packets.
// Extended from srio_ll_base_generator
//////////////////////////////////////////////////////////////////////////////// 

class srio_lfc_generator extends srio_ll_base_generator;

  /// @cond
  `uvm_component_utils(srio_lfc_generator)
  /// @endcond

  srio_trans lfc_pkt_q[$];  ///< Generated LFC packets are store in this queue

  extern function new(string name="SRIO_LFC_GENERATOR", uvm_component parent = null); ///< new function
  extern virtual task push_pkt(srio_trans i_srio_trans); ///< Receives packets from sequence 
  extern virtual task get_next_pkt(bit[2:0] sub_type,bit[31:0] tx_pkt_id,output bool pkt_valid,output srio_trans o_srio_trans);
                                                         ///< Provides the the packet to packet scheduler
endclass: srio_lfc_generator

//////////////////////////////////////////////////////////////////////////
/// Name: new \n
/// Description: LFC generator's new function \n
/// new
//////////////////////////////////////////////////////////////////////////

function srio_lfc_generator::new(string name="SRIO_LFC_GENERATOR", uvm_component parent=null);
  super.new(name, parent);
endfunction: new

//////////////////////////////////////////////////////////////////////////
/// Name: push_pkt \n
/// Description: Called by logic trans generator when LFC packet is \n
/// received from sequence. Invokes generate_io_pkt to generate the  \n
/// required fields. \n
/// push_pkt
//////////////////////////////////////////////////////////////////////////

task srio_lfc_generator::push_pkt(srio_trans i_srio_trans);
begin 
   srio_trans_item = new i_srio_trans;
   srio_trans_item.env_config = this.env_config;
   ll_common_class.get_next_pkt_id(srio_trans_item.ll_pkt_id);  // Assign next packet id
   print_ll_tx_rx(TRUE,srio_trans_item);                        // print LFC packet generation information
   if(srio_trans_item.ll_err_kind == LFC_PRI_ERR)               // Inject invalid priority 
     srio_trans_item.prio = 0;
   lfc_pkt_q.push_back(srio_trans_item);
   ll_common_class.pkt_cnt_update(TRUE);                        // Increment the total packet count
end 
endtask: push_pkt

//////////////////////////////////////////////////////////////////////////
/// Name: get_next_pkt \n
/// Description: Called by packet scheduler , provides the LFC packet if \n
/// available in the queue.If packet is present returns pkt_valid as TRUE \n
/// Uses tx_pkt_id to search for the matching packet from queue in \n
/// non-interleaved mode.In interleaved mode,picks top most packet \n
/// from the queue. \n
/// get_next_pkt
//////////////////////////////////////////////////////////////////////////

task srio_lfc_generator::get_next_pkt(bit[2:0] sub_type,bit [31:0] tx_pkt_id,output bool pkt_valid,output srio_trans o_srio_trans);
bool id_match;
int tmp_cnt;
begin
   pkt_valid = FALSE;
   id_match  = FALSE;
   tmp_cnt   = 0;
   if(lfc_pkt_q.size() > 0)           // Check the queue size to know if packet is available to transfer   
   begin
     if(ll_config.interleaved_pkt)    // If interleaved is TRUE, pop the top packet
     begin 
       pkt_valid = TRUE;              // pkt_valid is set to TRUE if packet is available for transmission
       o_srio_trans = lfc_pkt_q.pop_front();  
     end else
     begin
       while(id_match == FALSE && tmp_cnt < lfc_pkt_q.size())  // Search for the packet with id matching the value   
       begin                                                   // requested by scheduler
         if(lfc_pkt_q[tmp_cnt].ll_pkt_id == tx_pkt_id)
           id_match = TRUE;
         else
           tmp_cnt++;
       end
       if(id_match)                                            // If packet is matches,send out that packet and delete from queue
       begin
         pkt_valid = TRUE;
         o_srio_trans = lfc_pkt_q[tmp_cnt];
         lfc_pkt_q.delete(tmp_cnt); 
       end 
     end
     if(pkt_valid)
       ll_common_class.pkt_cnt_update(FALSE);                  // decrement the packet counter
   end
end
endtask: get_next_pkt
