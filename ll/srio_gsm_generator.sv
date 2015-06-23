////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_gsm_generator.sv
// Project :  srio vip
// Purpose :  GSM Packet Generation
// Author  :  Mobiveil
//
// This components handles the generation of GSM packets.
// Extended from srio_ll_base_generator
//////////////////////////////////////////////////////////////////////////////// 

class srio_gsm_generator extends srio_ll_base_generator;

  /// @cond
  `uvm_component_utils(srio_gsm_generator)
  /// @endcond

  srio_trans gsm_pkt_q[$];         ///< Generated GSM packets are store in this queue
  srio_trans gsm_tid_q[$];         ///< Stores the packets waiting for TID to be available
  srio_trans gsm_retry_q[int];     ///< Retry queue for GSM packets

  extern function new(string name="SRIO_GSM_GENERATOR", uvm_component parent = null); ///< new function
  extern task run_phase(uvm_phase phase);                ///< run_phase
  extern virtual task generate_gsm_pkt();                ///< Generates GSM packets
  extern virtual task gsm_retry();                       ///< Handles GSM retry mechanism
  extern virtual task gsm_resp_timeout();                ///< Handles GSM retry mechanism
  extern virtual task inject_err();                      ///< Task injects GSM related error 
  extern virtual task push_pkt(srio_trans i_srio_trans); ///< Receives packets from sequence 
  extern virtual task get_next_pkt(bit[2:0] sub_type,bit[31:0] tx_pkt_id,output bool pkt_valid,output srio_trans o_srio_trans);
                                                      ///< Provides the the packet to packet scheduler

endclass: srio_gsm_generator

//////////////////////////////////////////////////////////////////////////
/// Name: new \n
/// Description: GSM generator's new function \n
/// new
//////////////////////////////////////////////////////////////////////////

function srio_gsm_generator::new(string name="SRIO_GSM_GENERATOR", uvm_component parent=null);
  super.new(name, parent);
endfunction: new

//////////////////////////////////////////////////////////////////////////
/// Name: run_phase \n
/// Description: GSM generator's run_phase function \n
/// run_phase
//////////////////////////////////////////////////////////////////////////

task srio_gsm_generator::run_phase(uvm_phase phase);
begin 
  fork
    generate_gsm_pkt;     // Generates GSM packets
    gsm_retry;            // Call gsm retry mechanism logic thread 
    gsm_resp_timeout;     // GSM response timeout logic
  join_none
end 
endtask: run_phase

//////////////////////////////////////////////////////////////////////////
/// Name: push_pkt \n
/// Description: Called by logic trans generator when GSM packet is \n
/// received from sequence. Stores the packet to gsm_tid_q for further \n  
/// processing.\n
/// push_pkt
//////////////////////////////////////////////////////////////////////////

task srio_gsm_generator::push_pkt(srio_trans i_srio_trans);
begin
   gsm_tid_q.push_back(i_srio_trans);
end
endtask: push_pkt

//////////////////////////////////////////////////////////////////////////
/// Name: generate_gsm_pkt \n
/// Description: generates GSM packets.User generated packets will not be \n
/// modified and directly considered for transmission.Non user packts,Only \n
/// the payload is generated.Valid values for other fields are \n
/// already constrained in srio_trans. Waits for TID to be available. \n
/// generate_gsm_pkt
//////////////////////////////////////////////////////////////////////////

task srio_gsm_generator::generate_gsm_pkt;
bit [7:0] payload[$];
bit [3:0] ftype;  
bit [3:0] ttype;
bit [7:0] byte_en;
integer   byte_cnt;
integer   act_byte_cnt;
begin
  forever
  begin
    wait (gsm_tid_q.size() > 0);                 // Wait for gsm_tid_q to have packets from sequence
    srio_trans_item = new gsm_tid_q.pop_front();
    ftype = srio_trans_item.ftype;
    ttype = srio_trans_item.ttype;
    payload.delete();
    if(srio_trans_item.usr_gen_pkt == 0)                                        // If user has already not generated
    begin
      if(ftype == TYPE1 || ftype == TYPE2 || (ftype == TYPE5 &&  ttype < 4'h2)) // GSM packets which require response
      begin
        ll_common_class.get_next_tid(srio_trans_item.SrcTID);                   // Wait and Get the TID which is not in use 
      end 
      if(ftype == TYPE5 && (ttype == CASTOUT || ttype == FLUSH_WD))             // check if the GSM packet requires payload
      begin
        get_byte_cnt_en(srio_trans_item.wdptr,srio_trans_item.wrsize,byte_cnt,byte_en,act_byte_cnt); // Get byte cnt using wdptr and size
        for(int cnt=0;cnt<byte_cnt;cnt++)
           payload.push_back($urandom_range('hFF,'h0));
        srio_trans_item.payload = payload;    
      end 
    end 
    print_ll_tx_rx(TRUE,srio_trans_item);                       // print GSM packet generation information
    inject_err;                                                 // Injects GSM related erros if enabled
    srio_trans_item.ll_rd_cnter = 0;                            // Initialize reponse timeout counter to zero   
    ll_common_class.get_next_pkt_id(srio_trans_item.ll_pkt_id); // Assign packet id
    gsm_pkt_q.push_back(srio_trans_item);                       // Store the packet to GSM queue for transmission
    gsm_retry_q[srio_trans_item.SrcTID] = srio_trans_item;      // Store a copy in retry queue
    ll_common_class.pkt_cnt_update(TRUE);                       // Increment the packet count
  end
end
endtask: generate_gsm_pkt

//////////////////////////////////////////////////////////////////////////
/// Name: get_next_pkt \n
/// Description: Called by packet scheduler , provides the GSM packet if \n
/// available in the queue.If packet is present returns pkt_valid as TRUE \n
/// Uses tx_pkt_id to search for the matching packet from queue in \n
/// non-interleaved mode.In interleaved mode,picks top most packet \n
/// from the queue. \n
/// get_next_pkt
//////////////////////////////////////////////////////////////////////////

task srio_gsm_generator::get_next_pkt(bit[2:0] sub_type,bit [31:0] tx_pkt_id,output bool pkt_valid,output srio_trans o_srio_trans);
integer tmp_cnt;
bool    id_match;
begin
   pkt_valid = FALSE;
   id_match  = FALSE;
   tmp_cnt   = 0;

   if(gsm_pkt_q.size() > 0)         // Check the queue size to know if packet is available to transfer
   begin
     if(ll_config.interleaved_pkt)  // If interleaved is TRUE, pop the top packet
     begin
        pkt_valid = TRUE;           // pkt_valid is set to TRUE if packet is available for transmission
        o_srio_trans = gsm_pkt_q.pop_front();  
     end else
     begin 
       while(id_match == FALSE && tmp_cnt < gsm_pkt_q.size()) // Search for the packet with id matching the value
       begin                                                  // requested by scheduler
         if(gsm_pkt_q[tmp_cnt].ll_pkt_id == tx_pkt_id)
           id_match = TRUE;
         else
           tmp_cnt++;
       end
       if(id_match)                            // If packet is matches,send out that packet and delete from queue
       begin
          pkt_valid = TRUE;
          o_srio_trans = gsm_pkt_q[tmp_cnt];
          gsm_pkt_q.delete(tmp_cnt);              
       end 
     end
     if(pkt_valid)
       ll_common_class.pkt_cnt_update(FALSE);  // decrement the packet counter
   end
end
endtask: get_next_pkt

//////////////////////////////////////////////////////////////////////////
/// Name: inject_err \n
/// Description: Injects GSM packet error based on the error kind \n
/// User also can inject error in the packet in sequence and \n
/// set the user_gen_pkt to 1. \n
/// inject_err
//////////////////////////////////////////////////////////////////////////

task srio_gsm_generator::inject_err;
begin
  case(srio_trans_item.ll_err_kind)
    MAX_SIZE_ERR:begin  // Payload more than maximum
                   for(int cnt = srio_trans_item.payload.size()-1; cnt < 264; cnt++)
                     srio_trans_item.payload.push_back(cnt);  
                 end
    FTYPE_ERR: begin  // Invalid FTYPE
                 srio_trans_item.ftype = TYPE15;
               end
    TTYPE_ERR:begin  // Invalid TTYPE
                srio_trans_item.ttype = (srio_trans_item.ftype == TYPE5) ? 4'hF : 4'hA; 
              end 
    PAYLOAD_ERR:begin  // Payload more than the actual
                   for(int cnt = 0; cnt < 8; cnt++)
                     srio_trans_item.payload.push_back(cnt);  
                end
    SIZE_ERR:begin // Wrong size and wdptr combination 
                srio_trans_item.wdptr = ~srio_trans_item.wdptr; 
                srio_trans_item.rdsize = ~srio_trans_item.rdsize;
                srio_trans_item.wrsize = ~srio_trans_item.wrsize;
             end 
    PAYLOAD_EXIST_ERR:begin  // Include payload in packets which are not supposed to have payload
                     for(int cnt = 0; cnt < 8; cnt++)
                       srio_trans_item.payload.push_back(cnt);  
                   end    
    NO_PAYLOAD_ERR:begin // packet requires payload, but send without payload
                        srio_trans_item.payload.delete(); 
                      end 
    DW_ALIGN_ERR:begin   // DW Align Error
                     for(int cnt = 0; cnt < 4; cnt++)
                       srio_trans_item.payload.push_back(cnt);  
                 end
  endcase 
end
endtask: inject_err

//////////////////////////////////////////////////////////////////////////
/// Name: gsm_retry \n
/// Description: Implments the retry mechanism logic for gsm.Whenever a \n
/// completion is received check the status if retry, pop that packet from \n
/// retry queue and push it to the transmission queue. Else delete the packet.\n  
/// gsm_retry
//////////////////////////////////////////////////////////////////////////

task srio_gsm_generator::gsm_retry;
bit [7:0] resp_tgtid;
bit [4:0] trans_status;
bit [3:0] resp_ttype;
srio_trans srio_rx_trans;
begin
  forever
  begin 
    @(ll_common_class.ll_rx_pkt_received);                // Wait for packet to be received by RX logic
    srio_rx_trans = new ll_common_class.srio_ll_rx_trans; // get the received packet
    if(srio_rx_trans.ftype == TYPE13)                     // If completion packet
    begin
      resp_tgtid   = srio_rx_trans.targetID_Info;
      trans_status = srio_rx_trans.trans_status;
      resp_ttype   = srio_rx_trans.ttype;
      if(gsm_retry_q.exists(resp_tgtid) && resp_ttype != MSG_RES)                 // Check if TID matches with any of the packet
      begin                                               // from the queue
        srio_rx_trans  = gsm_retry_q[resp_tgtid];
        if(trans_status == STS_RETRY)                     // If status is retry
        begin 
          ll_common_class.get_next_pkt_id(srio_rx_trans.ll_pkt_id);  // assign new packet id
          srio_trans_item.ll_rd_cnter = 0;
          gsm_pkt_q.push_back(srio_rx_trans);                         // Push it to gsm queue for re-transmission
          ll_common_class.pkt_cnt_update(TRUE);                      // Increment the packet count
        end else                                                      // Other than retrym delete and free the TID
        begin
           gsm_retry_q.delete(resp_tgtid);
           ll_common_class.update_tid(resp_tgtid);
        end 
      end
    end
  end
end 
endtask: gsm_retry

//////////////////////////////////////////////////////////////////////////
/// Name: gsm_resp_timeout \n
/// Description: Handled the response timeout mechanism for GSM packets.\n
/// Timeout counter of each outstanding packet is incremented for every 1ns.\n 
/// When matches with the timeout value configured in LL config,packet \n
/// is removed from the queue and TID is made available. \n
/// io_resp_chk
//////////////////////////////////////////////////////////////////////////

task srio_gsm_generator::gsm_resp_timeout;
int first_index;
int last_index;
begin
  forever
  begin 
    #1ns;
    first_index = 0;
    last_index  = 0; 
    void'(gsm_retry_q.first(first_index));                           // First index of the array
    void'(gsm_retry_q.last(last_index));                             // Last index of the array
    for(int cnt = first_index; cnt <= last_index; cnt++)
    begin
      if(gsm_retry_q.num() > 0 && gsm_retry_q.exists(cnt))           // Check each index, if packet is present
      begin
        gsm_retry_q[cnt].ll_rd_cnter++;                              // increment the response timeout counter
        if(gsm_retry_q[cnt].ll_rd_cnter >= ll_config.ll_resp_timeout)
        begin
           gsm_retry_q.delete(cnt);                                  // If matches with the timeout value,delete the packet
           ll_common_class.update_tid(cnt);                          // Free the TID
        end  
      end
    end
  end
end
endtask: gsm_resp_timeout
