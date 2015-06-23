////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_msg_db_generator.sv
// Project :  srio vip
// Purpose :  Message/Doorbell packet generation
// Author  :  Mobiveil
//
// Handles generation of message and doorbell packets.
// 
//////////////////////////////////////////////////////////////////////////////// 

class srio_msg_db_generator extends srio_ll_base_generator;

  /// @cond
  `uvm_component_utils(srio_msg_db_generator)
  /// @endcond

  srio_trans msg_pkt_q[int][$],msg_seq_pkt_q[$],db_pkt_q[$]; ///< Queues to store Message and DB packets
  srio_trans msg_retry_q[int][$],db_retry_q[int];            ///< Retry Queues for msg and db packets
  srio_trans db_tid_q[$],msg_tid_q[$];                       ///< Queue to store db/msg to check for TID availability 

  bit multi_seg_lm[bit[3:0]];                    ///< Array to indicate the {Letter,Mbox} availabilty for multi segments
  bit single_seg_lm[bit[3:0]];                   ///< Array to indicate the {Letter,Mbox} availabilty for multi segments  
  bit tid_used[bit[7:0]];                        ///<  Array to indicate the TID availabilty for single segments
 
  extern function new(string name="SRIO_MSG_DB_GENERATOR", uvm_component parent = null); ///< new function
  extern task run_phase(uvm_phase phase);                        ///< run_phase
  extern virtual task generate_db_pkt();                         ///< Task generates DB packets
  extern virtual task generate_msg_pkt(srio_trans i_srio_trans); ///< Task generates MSG packets  
  extern virtual task msg_db_retry();                            ///< Handles MSG/DB retry mechanism
  extern virtual task msg_tid_check();                           ///< Checks which message can be generated next
  extern virtual task msg_db_resp_timeout();                     ///< Handles MSG/DB response timeout
  extern virtual task get_next_db_pkt(bit [31:0] tx_pkt_id,output bool pkt_valid,output srio_trans o_srio_trans); ///< Provides next db pkt  
  extern virtual task get_next_msg_pkt(bit [31:0] tx_pkt_id,output bool pkt_valid,output srio_trans o_srio_trans);///< Provides next msg pkt   
  extern virtual task push_pkt(srio_trans i_srio_trans);         ///< Receives packets from sequence
  extern virtual task get_next_pkt(bit[2:0] sub_type,bit[31:0] tx_pkt_id,output bool pkt_valid,output srio_trans o_srio_trans);
                                                                 ///< Provides the the packet to packet scheduler

endclass: srio_msg_db_generator

//////////////////////////////////////////////////////////////////////////
/// Name: new \n
/// Description: Messsage DB generator's new function \n
/// new
//////////////////////////////////////////////////////////////////////////

function srio_msg_db_generator::new(string name="SRIO_MSG_DB_GENERATOR", uvm_component parent=null);
  super.new(name, parent);
endfunction: new

//////////////////////////////////////////////////////////////////////////
/// Name: run_phase \n
/// Description: Messsage DB generator's run_phase function \n
/// run_phase
//////////////////////////////////////////////////////////////////////////

task srio_msg_db_generator::run_phase(uvm_phase phase);
begin  
  for(int cnt=0; cnt < 16; cnt++)   // Initialize the array values
  begin
    single_seg_lm[cnt] = 0;
    multi_seg_lm[cnt]  = 0;
  end
  for(int cnt=0; cnt < 256; cnt++)
    tid_used[cnt] = 0;
  fork
    msg_db_retry;                // msg/db retry mechanism logic thread
    generate_db_pkt;             // DB packet generation thread
    msg_tid_check;               // Checks which is next message to be genereated  
    msg_db_resp_timeout;         // MSG/DB response timeout thread 
  join_none
end 
endtask: run_phase

//////////////////////////////////////////////////////////////////////////
/// Name: push_pkt \n
/// Description: Called by logic trans generator when MSG or DB IO packet is \n
/// received from sequence. Calls generate_msg_pkt for message packets.\n  
/// CAlls generate_db_pkt for doorbell packets. \n
/// push_pkt
//////////////////////////////////////////////////////////////////////////

task srio_msg_db_generator::push_pkt(srio_trans i_srio_trans);
srio_trans srio_tmp_trans;
begin 
   srio_tmp_trans = new i_srio_trans;
   srio_tmp_trans.env_config = this.env_config;
   if(srio_tmp_trans.ftype == TYPE10)       // DB packet, push it db_tid_q for available TID checking
      db_tid_q.push_back(srio_tmp_trans);
   else if(srio_tmp_trans.ftype == TYPE11)  // MSG packet,push it to msg_tid_q for available Letter/Mbox checking
      msg_tid_q.push_back(srio_tmp_trans);
end
endtask: push_pkt 

//////////////////////////////////////////////////////////////////////////
/// Name: get_next_pkt \n
/// Description: Called by packet scheduler , provides the MSG or DB packet \n
/// based on sub_type value. \n
/// get_next_pkt
//////////////////////////////////////////////////////////////////////////

task srio_msg_db_generator::get_next_pkt(bit[2:0] sub_type,bit [31:0] tx_pkt_id,output bool pkt_valid,output srio_trans o_srio_trans);
begin

if(sub_type == 0)                                 
  get_next_db_pkt(tx_pkt_id,pkt_valid,o_srio_trans);  // subtype 0, get door bell packet from queue
else 
  get_next_msg_pkt(tx_pkt_id,pkt_valid,o_srio_trans); // subtype 1, get message packet from queue
   
end
endtask: get_next_pkt

//////////////////////////////////////////////////////////////////////////
/// Name: generate_db_pkt \n
/// Description: generates DB packets.Valid values for the fields are \n
/// already constrained in srio_trans. \n
/// generate_db_pkt
//////////////////////////////////////////////////////////////////////////

task srio_msg_db_generator::generate_db_pkt;
srio_trans srio_tmp_trans;
begin
   forever
   begin
     wait (db_tid_q.size() > 0);                               // Wait for db_tid_q to have packets from LL sequence
     srio_tmp_trans = new db_tid_q.pop_front();
     if(srio_tmp_trans.usr_gen_pkt == 0)                       // Not user generated packet   
       ll_common_class.get_next_tid(srio_tmp_trans.SrcTID);    // Wait and get the available TID 
     print_ll_tx_rx(TRUE,srio_tmp_trans);                      // Prints DB packet generation information
     ll_common_class.get_next_pkt_id(srio_tmp_trans.ll_pkt_id);// Assign next packet id
     srio_tmp_trans.ll_rd_cnter = 0;                           // Response timeout counter initialized to 0
     db_pkt_q.push_back(srio_tmp_trans);                       // Push it to db main queue for transmission to TL
     db_retry_q[srio_tmp_trans.SrcTID] = srio_tmp_trans;       // Store a copy in retry queue
     ll_common_class.pkt_cnt_update(TRUE);                     // Increment the packet count
   end
end
endtask: generate_db_pkt

//////////////////////////////////////////////////////////////////////////
/// Name: get_next_db_pkt \n
/// Description: Called by packet scheduler , provides the DB packet if \n
/// available in the queue.If packet is present returns pkt_valid as TRUE \n
/// Uses tx_pkt_id to search for the matching packet from queue in \n
/// non-interleaved mode.In interleaved mode,picks top most packet \n
/// from the queue. \n
/// get_next_db_pkt
//////////////////////////////////////////////////////////////////////////

task srio_msg_db_generator::get_next_db_pkt(bit [31:0] tx_pkt_id,output bool pkt_valid,output srio_trans o_srio_trans);
bool id_match;
int tmp_cnt;
begin 
   pkt_valid = FALSE; 
   id_match  = FALSE;
   tmp_cnt   = 0;
   if(db_pkt_q.size() > 0)                 // DB packet is available for transmission
   begin
      if(ll_config.interleaved_pkt)        // Interleaved mode
      begin 
         pkt_valid = TRUE;
         o_srio_trans = db_pkt_q.pop_front();  
      end else
      begin                                // Non interleaved mode, fetched using packet id
         while(id_match == FALSE && tmp_cnt < db_pkt_q.size())
         begin
            if(db_pkt_q[tmp_cnt].ll_pkt_id == tx_pkt_id)
              id_match = TRUE;
           else
             tmp_cnt++;
         end
         if(id_match)
         begin
            pkt_valid = TRUE;
            o_srio_trans = db_pkt_q[tmp_cnt];
            db_pkt_q.delete(tmp_cnt); 
         end 
      end
      if(pkt_valid)
        ll_common_class.pkt_cnt_update(FALSE);  // Decrement the packet count
   end
end
endtask: get_next_db_pkt

//////////////////////////////////////////////////////////////////////////
/// Name: generate_msg_pkt \n
/// Description: Generates MSG segments using received ssize and message length \n
/// values.This task takes care of generating the required segments in a \n
/// message packet.User can also generate the segments keeping usr_gen_pkt as 1.\n
/// Those packet will not be modified by this generator. \n
/// generate_msg_pkt
//////////////////////////////////////////////////////////////////////////

task srio_msg_db_generator::generate_msg_pkt(srio_trans i_srio_trans);
bit [3:0] ftype;
bit [3:0] msg_len;
bit [3:0] ssize;
bit [1:0] letter;
bit [1:0] mbox;
bit [31:0] SourceID;
bit [31:0] DestinationID;
bit [7:0] payload[$];
bit [3:0] msg_index;
int seg_size;
int message_length;
int no_of_segments;
int last_seg_size;
int rand_err_seg;
int act_pld_cnt;
srio_trans msg_item;
begin
    srio_trans_item = new i_srio_trans; 
    // Get the required fields from sequence item
    ftype   = srio_trans_item.ftype;
    msg_len = srio_trans_item.msg_len;
    ssize   = srio_trans_item.ssize;
    letter  = srio_trans_item.letter;
    mbox    = srio_trans_item.mbox;
    SourceID = srio_trans_item.SourceID;
    DestinationID = srio_trans_item.DestinationID;
    message_length = srio_trans_item.message_length;
    msg_index   = {letter,mbox};

    print_ll_tx_rx(TRUE,srio_trans_item);  // Prints the info about msg packet generation
    if(srio_trans_item.usr_gen_pkt == 0)   // Not user generated packet
    begin
 
      seg_size     = (ssize >= 9 && ssize <= 14) ? ssize : 9; // Calculate legal ssize value
      seg_size     = 2**(seg_size-9) * 8;                     // Convert to number of bytes

      message_length = message_length * 8;                    // received  message length
      message_length = (message_length > (seg_size*16)) ? seg_size*16 : message_length; // Calculate legal message length value
      no_of_segments = (message_length%seg_size == 0) ? message_length/seg_size:(message_length/seg_size)+1; // Calculate no of segments
      last_seg_size = (message_length%seg_size == 0) ? seg_size : message_length%seg_size;// find out the size of last segment
      msg_len = no_of_segments -1;                                                        // Message lenth field in the packet  
      rand_err_seg = $urandom_range(no_of_segments-1,0);                      // Pick one segment randomly for injecting error
   
      if(no_of_segments > 1)           // Multi segment packet,indicate this letter/mbox is occupied
         multi_seg_lm[msg_index] = 1;
      else                             // Single segment packet,indicate this letter/mbox is occupied
        single_seg_lm[msg_index] = 1; 
 
       for (int segment = 0;segment< no_of_segments;segment = segment+1)  // Create required segments
       begin 
         msg_item = srio_trans::type_id::create("msg_item", this);
         msg_item.ftype   = ftype;
         msg_item.msg_len = msg_len;
         msg_item.ssize   = ssize;
         msg_item.letter  = letter;
         msg_item.mbox    = mbox ;
         msg_item.tt      = srio_trans_item.tt;
         msg_item.prio    = srio_trans_item.prio;
         msg_item.crf     = srio_trans_item.crf;
         msg_item.vc      = srio_trans_item.vc;
         msg_item.SourceID      = SourceID;
         msg_item.DestinationID = DestinationID;
         payload.delete();
         act_pld_cnt = (segment == no_of_segments-1) ? last_seg_size : seg_size;     // Actual payload cnt required fo each segment
         if(segment == rand_err_seg && srio_trans_item.ll_err_kind == MSG_SSIZE_ERR) // Inject Error , Payload more than ssize 
           act_pld_cnt = act_pld_cnt + 8;  
         for(int cnt=0; cnt < act_pld_cnt; cnt++)           // Create payload bytes randomly
            payload.push_back($urandom_range('hFF,'h0));
         msg_item.payload = payload;
         // findout msgseg_xmbox value  
         msg_item.msgseg_xmbox = no_of_segments > 1 ? segment : srio_trans_item.msgseg_xmbox;
 
         if(segment == rand_err_seg && srio_trans_item.ll_err_kind == MSGSEG_ERR)   // Wrong msgseg field
            msg_item.msgseg_xmbox = msg_len+1;

         ll_common_class.get_next_pkt_id(msg_item.ll_pkt_id);  // Assign packt id
         msg_item.ll_rd_cnter = 0;                             // Initialize response timout counter to 0
         if(ll_config.interleaved_pkt == TRUE)                 // Push it respective queues based on the value of Interleaved flag
           msg_pkt_q[msg_index].push_back(msg_item);
         else    
           msg_seq_pkt_q.push_back(msg_item);
         msg_retry_q[msg_index].push_back(msg_item);          // Store a copy to retry queue, for retry logic 
         tid_used[{msg_item.letter,msg_item.mbox,msg_item.msgseg_xmbox}] = 1; // Indicate TID is occupied
         ll_common_class.pkt_cnt_update(TRUE);                 // Increment packet count

         $display("**************************************************************");
         $display(" Segment Number = %d",segment);
         $display(" Last Seg Size = %d",last_seg_size);
         $display(" No of Segments = %d",no_of_segments);
         $display(" Segment Size = %d",seg_size);
         $display(" SSize = %d",ssize);
         $display(" Message Length = %d",message_length);
         $display(" Msg_len is %d",msg_len);
         $display("**************************************************************");
       end 
     end else 
     begin                                                        // User generated segments
       ll_common_class.get_next_pkt_id(srio_trans_item.ll_pkt_id);// Assign packet id 
       srio_trans_item.ll_rd_cnter = 0;                           // Initialize response timout counter to 0
       if(ll_config.interleaved_pkt == TRUE)                      // Push it respective queues based on the value of Interleaved flag
       begin
         msg_pkt_q[msg_index].push_back(srio_trans_item);
       end  
       else begin   
         msg_seq_pkt_q.push_back(srio_trans_item);
       end
       msg_retry_q[msg_index].push_back(srio_trans_item);         // Store a copy to retry queue, for retry logic
       ll_common_class.pkt_cnt_update(TRUE);                      // Increment packet count
     end    
end 
endtask: generate_msg_pkt

//////////////////////////////////////////////////////////////////////////
/// Name: msg_tid_chk \n
/// Description: Packets received from sequence are stored in msg_tid_q. \n
/// When packets are available in this queue, each packt is read and checked \n 
/// letter/mailbox is available for transmission.If the letter/mailbox is already \n
/// in use check the next packet in the queue. If available generate it.This \n
/// is repeated till the packets is emptied. \n
/// msg_tid_chk
//////////////////////////////////////////////////////////////////////////

task srio_msg_db_generator::msg_tid_check;
srio_trans srio_tmp_trans;
bool pkt_valid;
bit [7:0] msg_tid;
bit [3:0] msg_index;
int cnt;
int ssize;
int tot_seg;
begin
  forever
  begin
    pkt_valid = FALSE;
    cnt = 0;
    wait(msg_tid_q.size() > 0);         // Wait for the msg_tid_q to have packets from sequence
    while(cnt < msg_tid_q.size)         // Check each packet
    begin
      // Find out TID, letter/mbox and multi/single segment packet
      srio_tmp_trans = msg_tid_q[cnt];
      msg_index = {srio_tmp_trans.letter,srio_tmp_trans.mbox};
      msg_tid   = {srio_tmp_trans.letter,srio_tmp_trans.mbox,srio_tmp_trans.msgseg_xmbox};
      ssize     = (srio_tmp_trans.ssize >= 9 && srio_tmp_trans.ssize <= 14) ? srio_tmp_trans.ssize : 9;
      ssize     = 2**(ssize-9) * 8;
      tot_seg   = (srio_tmp_trans.message_length*8 % ssize == 0) ? srio_tmp_trans.message_length*8/ssize : (srio_tmp_trans.message_length*8/ssize)+1;
      // For multi segment packet that letter/mbox is already not used by
      // previous multi segment or single segment, then generate it
      // For single segment packet that letter/mbox is already not used by 
      // previous multi segment and TID not used by previous single segment,
      // then generate it. User generated packet need not have this check.
      // User has to take care of  using the proper letter/mbox
      if( (tot_seg > 1 && multi_seg_lm[msg_index] == 0 && single_seg_lm[msg_index] == 0) || 
            (tot_seg ==1 && multi_seg_lm[msg_index] == 0 && tid_used[msg_tid] == 0) || srio_tmp_trans.usr_gen_pkt == 1)
      begin
        generate_msg_pkt(srio_tmp_trans);  // Call generate_msg_pkt task for further processing
        msg_tid_q.delete(cnt);             // Remove the packet from msg_tid_q as it can be used
        pkt_valid = TRUE;  
      end else
        cnt++;
    end
    if(pkt_valid == FALSE)
     #1ns;
  end  
end
endtask: msg_tid_check

//////////////////////////////////////////////////////////////////////////
/// Name: get_next_msg_pkt \n
/// Description: Provides the message packet if available in the queue. \n
/// If packet is present returns pkt_valid as TRUE. In interleaved mode \n
/// randomly picks a segmet from differnt available message queue. \n
/// Out_of_order_gen mode is enabled,randomly select a message stream and in \n
/// that reads the msg segment in shuffled order. \n
/// get_next_msg_pkt
//////////////////////////////////////////////////////////////////////////
 
task srio_msg_db_generator::get_next_msg_pkt(bit [31:0] tx_pkt_id,output bool pkt_valid,output srio_trans o_srio_trans);
int first_index = 0;
int last_index  = 0;
int next_index  = 0;
int q_index     = 0; 
int hit_index   = 0; 
int tmp_cnt     = 0;   
bit invalid_index = 0;
bit [3:0] msg_len = 0; 
bit [3:0] seg_no  = 0;
bool      id_match = FALSE;
bool last_pkt_hit  = FALSE;
begin
   pkt_valid = FALSE;
   if(ll_config.interleaved_pkt)   // Inteleaved TRUE
   begin
      if(msg_pkt_q.num() > 0)      // check if message packet available to transmit
      begin 
         void'(msg_pkt_q.first(first_index));  // Get the fist index, index is letter,mbox,seg no combination
         void'(msg_pkt_q.last(last_index));    // Get the last index
         invalid_index = 1;
         q_index = 0; 
         next_index = $urandom_range(last_index,first_index);// randomly select one index and check it has packets
         while(invalid_index)
         begin 
           if((msg_pkt_q.exists(next_index) == 1) && (msg_pkt_q[next_index].size() > 0)) 
           begin 
             if(ll_config.en_out_of_order_gen == TRUE)       // Out of order enabled,randomly pick one segment from that queue
             begin
               hit_index = $urandom_range(msg_pkt_q[next_index].size()-1,0);   
               o_srio_trans = new msg_pkt_q[next_index][hit_index];
               msg_pkt_q[next_index].delete(hit_index);
               pkt_valid = TRUE;
             end else
             begin 
               o_srio_trans = new msg_pkt_q[next_index].pop_front();
               pkt_valid = TRUE;
             end
             invalid_index = 0;
           end 
           else begin 
             next_index = $urandom_range(last_index,first_index);
           end 
         end 
         if(pkt_valid && msg_pkt_q[next_index].size() == 0)
          msg_pkt_q.delete(next_index);
      end 
    end else if(msg_seq_pkt_q.size() > 0 && ll_config.interleaved_pkt == FALSE)
    begin   
      while(id_match == FALSE && tmp_cnt < msg_seq_pkt_q.size()) 
      begin                                    // Packets need to be transmitted in the same order they received from sequence
        if(msg_seq_pkt_q[tmp_cnt].ll_pkt_id == tx_pkt_id)
          id_match = TRUE;
        else
          tmp_cnt++;
      end
      if(id_match)
      begin
        pkt_valid = TRUE;
        o_srio_trans = msg_seq_pkt_q[tmp_cnt];
        msg_seq_pkt_q.delete(tmp_cnt);
      end 
    end
    if(pkt_valid)
     ll_common_class.pkt_cnt_update(FALSE);
end
endtask: get_next_msg_pkt

//////////////////////////////////////////////////////////////////////////
/// Name: msg_db_retry \n
/// Description: Implements the retry mechanism logic for msg/db.Whenever a \n
/// completion is received check the status if retry, take that packet from \n
/// retry queue and push it to the transmission queue. Else delete the packet.\n
/// If all responses for a letter/mbox is received ,indicate it is available \n    
/// msg_db_retry
//////////////////////////////////////////////////////////////////////////

task srio_msg_db_generator::msg_db_retry;
bit [7:0] resp_tgtid;
bool      pkt_match;
int       q_size;
int       q_index;
bit [3:0] resp_ttype;
bit [4:0] trans_status;
srio_trans srio_rx_trans;
begin
  forever
  begin 
    @(ll_common_class.ll_rx_pkt_received);                // Wait for packet to be received by RX logic
    srio_rx_trans = new ll_common_class.srio_ll_rx_trans; // get the received packet
    if(srio_rx_trans.ftype == TYPE13)                     // If completion packet
    begin
      resp_tgtid   = srio_rx_trans.targetID_Info;
      resp_ttype   = srio_rx_trans.ttype;
      trans_status = srio_rx_trans.trans_status;
      if(resp_ttype != MSG_RES)                         // Check whether it is without payload
      begin
        if(db_retry_q.exists(resp_tgtid))                 // Check if TID matches with any of the packet
        begin                                             // from the queue
          srio_rx_trans  = new db_retry_q[resp_tgtid];
          if(trans_status == STS_RETRY)                   // If status is retry,resend it
          begin 
            srio_rx_trans.ll_rd_cnter = 0;
            ll_common_class.get_next_pkt_id(srio_rx_trans.ll_pkt_id);// assign new packet id
            db_pkt_q.push_back(srio_rx_trans);                       // Push it to db queue for re-transmission
            ll_common_class.pkt_cnt_update(TRUE);                    // Increment the packet count
          end else                                                   // If not retry,remove from queue and 
          begin                                                      // indicate TID is available for use  
           db_retry_q.delete(resp_tgtid);
           ll_common_class.update_tid(resp_tgtid);
          end
        end
      end
      pkt_match = FALSE; 
      if(resp_ttype == MSG_RES)                          // if message response
      begin
        if(msg_retry_q.exists(resp_tgtid[7:4]) && msg_retry_q[resp_tgtid[7:4]].size() > 0) // Check if targetid matches with 
        begin
          for(int cnt = 0; cnt < msg_retry_q[resp_tgtid[7:4]].size(); cnt++)
          begin
             srio_rx_trans = new msg_retry_q[resp_tgtid[7:4]][cnt];
             if({srio_rx_trans.letter,srio_rx_trans.mbox,srio_rx_trans.msgseg_xmbox} == resp_tgtid)
             begin
                if(trans_status == STS_RETRY)            // Status is retry pop and push to msg packet queue for re-transmission
                begin 
                  ll_common_class.get_next_pkt_id(srio_rx_trans.ll_pkt_id); // Assign next packet id
                  srio_rx_trans.ll_rd_cnter = 0;                            // Initialize resp timeout counter to 0
                  if(ll_config.interleaved_pkt == TRUE)                     // Interleaved mode 
                  begin 
                   msg_pkt_q[resp_tgtid[7:4]].push_front(srio_rx_trans);
                  end else                                                  // Non-interleaved mode
                  begin   
                    msg_seq_pkt_q.push_back(srio_rx_trans);
                  end
                  ll_common_class.pkt_cnt_update(TRUE);                     // Increment the packet count
                end  else
                begin
                  msg_retry_q[resp_tgtid[7:4]].delete(cnt);                // Status other than retry, remove and free TID
                  tid_used[resp_tgtid] = 0;
                end 
                break; 
             end 
          end 
          if(msg_retry_q[resp_tgtid[7:4]].size() == 0)  // If all responses for a letter/mbox received
          begin                                         // Indicate it is available for use
             single_seg_lm[resp_tgtid[7:4]] = 0;
             multi_seg_lm[resp_tgtid[7:4]]  = 0;
          end
        end 
      end 
    end 
  end 
end 
endtask: msg_db_retry

//////////////////////////////////////////////////////////////////////////
/// Name: msg_db_resp_timeout \n
/// Description: Handled the response timeout mechanism for MSG/DB packets.\n
/// Timeout counter of each outstanding packet is incremented for every 1ns.\n 
/// When matches with the timeout value configured in LL config,packet \n
/// is removed from the queue and TID is made available. \n
/// msg_db_resp_chk
//////////////////////////////////////////////////////////////////////////

task srio_msg_db_generator::msg_db_resp_timeout;
int first_index;
int last_index;
begin
  forever
  begin 
    #1ns;
    first_index = 0;
    last_index  = 0; 
    void'(db_retry_q.first(first_index));               // find out first occupied index in db retry queue
    void'(db_retry_q.last(last_index));                 // find out last occupied index in db retry queue
    for(int cnt = first_index; cnt <= last_index; cnt++)// Check each index between first and last index
    begin
      if(db_retry_q.num() > 0 && db_retry_q.exists(cnt))// if packet exists  
      begin
        db_retry_q[cnt].ll_rd_cnter++;                  // increment the response timeout counter 
        if(db_retry_q[cnt].ll_rd_cnter >= ll_config.ll_resp_timeout) // if counter value matches with ll_resp_timeout
        begin
           db_retry_q.delete(cnt);                     // Delete from retry queue and free the tid  
           ll_common_class.update_tid(cnt);
        end  
      end
    end 
    void'(msg_retry_q.first(first_index));                // find out first occupied index in msg retry queue
    void'(msg_retry_q.last(last_index));                  // find out last occupied index in msg retry queue
    for(int cnt = first_index; cnt <= last_index; cnt++)  // Check each index between first and last index
    begin
      if(msg_retry_q.num() > 0 && msg_retry_q.exists(cnt))  // if letter/mbox exists ,check each segment in that queue 
      begin
        for(int cnt1=0; cnt1 < msg_retry_q[cnt].size(); cnt1++)
        begin
           msg_retry_q[cnt][cnt1].ll_rd_cnter++;           // Increment the response timeout counter
          if(msg_retry_q[cnt][cnt1].ll_rd_cnter >= ll_config.ll_resp_timeout) // if counter value matches with ll_resp_timeout
          begin
             msg_retry_q[cnt].delete(cnt1);               // Delete from retry queue and free the tid
             tid_used[{cnt[3:0],cnt1[3:0]}] = 0;
             if(msg_retry_q[cnt].size() == 0)             // If all responses for a letter/mbox received
             begin                                        // Inidicate it is available for use
               single_seg_lm[cnt] = 0;
               multi_seg_lm[cnt]  = 0;
             end
          end  
        end
      end
    end
  end
end
endtask: msg_db_resp_timeout
