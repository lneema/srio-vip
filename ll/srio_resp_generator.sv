////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_resp_generator.sv
// Project :  srio vip
// Purpose :  Response Generation
// Author  :  Mobiveil
//
// This components generates the response packets for the
// received request.Extended from srio_ll_base_generator.
//
//////////////////////////////////////////////////////////////////////////////// 

class srio_resp_generator extends srio_ll_base_generator;

  /// @cond
  `uvm_component_utils(srio_resp_generator)
  /// @endcond

  srio_trans item_frm_pkt_handler_q[$]; ///< Queue to store packets received from packet handler
  srio_trans item_frm_seq_q[$];         ///< Queue to store packets received from sequence
  srio_trans ll_resp_delay_q[$];        ///< Used in response delay generation logic 
  srio_trans resp_pkt_q[$];             ///< Packets are taken from this queue and transmitted

  uvm_blocking_get_port #(srio_trans) resp_gen_get_port; /// TLM connects packet handler and response generator

  extern function new(string name="SRIO_RESP_GENERATOR", uvm_component parent = null); ///< new function
  extern task run_phase(uvm_phase phase);                        ///< run_phase
  extern virtual task generate_resp_pkt(srio_trans i_srio_trans);///< Generates response packets
  extern virtual task resp_gen_handling();              ///< Gets packets from queues and pass it to respecive processing task
  extern virtual task get_rx_pkt_frm_pkt_handler();     ///< Gets packets from packet handler
  extern virtual task gen_resp_status();                ///< Generate response status based on the received packet type
  extern virtual task gen_io_resp_status();             ///< subtask to generate response for IO packets 
  extern virtual task gen_msg_db_resp_status();         ///< subtask to generate response for MSG,DB packets 
  extern virtual task gen_gsm_resp_status();            ///< subtask to generate response for GSM packets
  extern virtual task gen_resp_delay();                 ///< Handles delaying the responses
  extern virtual task print_resp_pkt_info(srio_trans i_srio_trans);///< Prints response generation details
  extern virtual task push_pkt(srio_trans i_srio_trans);           ///< Gets packet from sequence
  extern virtual task get_next_pkt(bit[2:0] sub_type,bit[31:0] tx_pkt_id,output bool pkt_valid,output srio_trans o_srio_trans);
                                                                   ///< Provides the the packet to packet scheduler
  
endclass: srio_resp_generator

//////////////////////////////////////////////////////////////////////////
/// Name: new \n
/// Description: Response generator's new function \n
/// new
//////////////////////////////////////////////////////////////////////////

function srio_resp_generator::new(string name="SRIO_RESP_GENERATOR", uvm_component parent=null);
  super.new(name, parent);
  resp_gen_get_port = new("resp_gen_get_port",this);  // Create Packet handler->response generator TLM port
endfunction: new

//////////////////////////////////////////////////////////////////////////
/// Name: run_phase \n
/// Description: Response generator's run_phase function \n
/// run_phase
//////////////////////////////////////////////////////////////////////////

task srio_resp_generator::run_phase(uvm_phase phase);
begin 
  fork
    get_rx_pkt_frm_pkt_handler;
    resp_gen_handling;
    gen_resp_delay;
  join_none
end 
endtask: run_phase

//////////////////////////////////////////////////////////////////////////
/// Name: push_pkt \n
/// Description: Called by logic trans generator when Response packet is \n
/// received from sequence. Stores the packet to item_frm_seq_q queue \n
/// push_pkt
//////////////////////////////////////////////////////////////////////////

task srio_resp_generator::push_pkt(srio_trans i_srio_trans);
srio_trans srio_trans_seq;
begin
   srio_trans_seq = new i_srio_trans; 
   item_frm_seq_q.push_back(srio_trans_seq);  // Store the packet received from sequence 
end
endtask: push_pkt

//////////////////////////////////////////////////////////////////////////
/// Name: get_rx_pkt_frm_pkt_handler \n
/// Description: Gets received packet from packet handler using \n
/// resp_gen_get_port TLM port. \n
/// get_rx_pkt_frm_pkt_handler
//////////////////////////////////////////////////////////////////////////

task srio_resp_generator::get_rx_pkt_frm_pkt_handler;
srio_trans srio_trans_rx;
begin
  forever
  begin 
    resp_gen_get_port.get(srio_trans_rx);            // Get packet from packet handler using TLM port
    item_frm_pkt_handler_q.push_back(srio_trans_rx); // Store the packet to queue for further processing
  end
end 
endtask: get_rx_pkt_frm_pkt_handler

//////////////////////////////////////////////////////////////////////////
/// Name: resp_gen_handling \n
/// Description: Gets received packet from packet handler using \n
/// resp_gen_get_port TLM port. \n
/// resp_gen_handling
//////////////////////////////////////////////////////////////////////////

task srio_resp_generator::resp_gen_handling;
  forever
  begin 
    wait(item_frm_seq_q.size() > 0 || item_frm_pkt_handler_q.size() > 0);// wait for packets to be received from sequence or packet handler
    if(item_frm_pkt_handler_q.size() > 0)                                // if packet is received from packet handler,generate response
    begin 
      generate_resp_pkt(item_frm_pkt_handler_q.pop_front());
    end 
    else if (item_frm_seq_q.size() > 0)           // response packet from test sequence is available, assumption is that it is already created
    begin                                         // properly by user. So just send it to the delaying logic
      ll_resp_delay_q.push_back(item_frm_seq_q.pop_front());
    end 
  end 
endtask: resp_gen_handling

//////////////////////////////////////////////////////////////////////////
/// Name: generate_resp_pkt \n
/// Description: Generates the response for the received requests packets sent \n
/// by packet handler.packet handler sends only the packet which require response \n
/// to this module. response packet fields are generated based on the various \n
/// configuration done by user. \n
/// generate_resp_pkt
//////////////////////////////////////////////////////////////////////////

task srio_resp_generator::generate_resp_pkt(srio_trans i_srio_trans);
bit [3:0] ftype;  
bit [3:0] ttype;
bit [2:0] crf_prio;
bool      en_resp_gen;
srio_trans  srio_trans_tmp;
begin 
   
    srio_trans_item = new i_srio_trans;  
    srio_trans_tmp  = new i_srio_trans;
    en_resp_gen     = TRUE;           // Flag to indicate whether response to be generated or not 
    srio_trans_item.ll_rd_cnter = 0;  // response delay counter initialized to 0

    srio_trans_item.env_config = this.env_config;
    ftype     = srio_trans_item.ftype;
    ttype     = srio_trans_item.ttype;
    crf_prio  = {srio_trans_item.crf,srio_trans_item.prio};
    srio_trans_item.vc = 0; // Response packets should use VC0
    // Response delay,status given by user are considered first
    if(srio_trans_item.usr_directed_ll_response_en)  // Whether user directed values need to be considered
    begin
       srio_trans_item.ll_rd = srio_trans_item.usr_directed_ll_response_delay; // user configured delay value
    end
    else begin
      if(ll_config.resp_gen_mode == RANDOM)  // findout if the response delay value is random or none
         srio_trans_item.ll_rd = $urandom_range(ll_config.resp_delay_max,ll_config.resp_delay_min);
      else
         srio_trans_item.ll_rd = 0;
    end

    print_resp_pkt_info(srio_trans_item);  // Print info about for which packet response is getting generated

    crf_prio = (crf_prio != 'h3 || crf_prio != 'h7) ? crf_prio + 1 : crf_prio; // Increase the priority

    srio_trans_item.crf  = crf_prio[2];
    srio_trans_item.prio = crf_prio[1:0];
    srio_trans_item.DestinationID = srio_trans_tmp.SourceID;      // exchange the soure and destination id values
    srio_trans_item.SourceID      = srio_trans_tmp.DestinationID;

    gen_resp_status;       // Generate response status

    if(ftype == TYPE11)    // For message packets,targetTID is from letter,mbox and xmbox comnbination
      srio_trans_item.targetID_Info = {srio_trans_tmp.letter,srio_trans_tmp.mbox,srio_trans_tmp.msgseg_xmbox};
    else
      srio_trans_item.targetID_Info = srio_trans_tmp.SrcTID; // for non msg packets,targetTID is received SrcTID

    if(ftype == TYPE8)     // if RX packet ftype is 8 , response ftype is also 8
    begin
      srio_trans_item.ftype = TYPE8;
      srio_trans_item.hop_count = 8'hFF;  // hop_count for maintenance response is 'FF
    end else
    begin
      srio_trans_item.ftype = TYPE13;     // For other packets , TYPE13 is the response packet
    end

    if(srio_trans_item.ttype != RES_WITH_DP &&  ~(srio_trans_item.ftype == TYPE8 && srio_trans_item.ttype == MAINT_RD_RES))
      srio_trans_item.payload.delete();

    randcase   // Disable generation of responses using the ratio configured
       ll_config.gen_resp_en_ratio:  en_resp_gen = TRUE; 
       ll_config.gen_resp_dis_ratio: en_resp_gen = FALSE;
    endcase

    if((srio_trans_item.usr_directed_ll_response_en && srio_trans_item.usr_directed_ll_response_type == LL_NO_RESP) 
      || (!srio_trans_item.usr_directed_ll_response_en && ll_config.resp_gen_mode == DISABLED))
    begin  // Either user has configured no response or response generation is disabled in ll_config
        en_resp_gen = FALSE;
    end
    if(en_resp_gen)
       ll_resp_delay_q.push_back(srio_trans_item); // for delaying logic
end 
endtask: generate_resp_pkt

//////////////////////////////////////////////////////////////////////////
/// Name: gen_resp_status \n
/// Description: Based on the packet type , invokes the respective response \n
/// genration task.\n
/// gen_resp_status
//////////////////////////////////////////////////////////////////////////

task srio_resp_generator::gen_resp_status;
srio_ll_gen_kind ll_gen_kind;
begin
  ll_gen_kind = get_ll_gen_kind(srio_trans_item);// findout the packet kind
  case(ll_gen_kind)                              // based on the packet type, invoke the corresponding response generation task
    IO:     gen_io_resp_status;
    MSG_DB: gen_msg_db_resp_status;
    GSM:    gen_gsm_resp_status;
  endcase
  if(srio_trans_item.usr_directed_ll_response_en)// response status value requested by user
  begin
    $cast(srio_trans_item.trans_status,srio_trans_item.usr_directed_ll_response_type);
    if(srio_trans_item.ttype != MSG_RES && (srio_trans_item.trans_status != STS_DONE && 
       srio_trans_item.trans_status != STS_INTERVENTION && srio_trans_item.trans_status != STS_DATA_ONLY)) 
       srio_trans_item.ttype = RES_WO_DP;  
  end
end
endtask: gen_resp_status

//////////////////////////////////////////////////////////////////////////
/// Name: gen_io_resp_status \n
/// Description: Generate response status and ttype values for IO packets \n
/// Various status values are generated using the programmed ratio \n
/// gen_io_resp_status
//////////////////////////////////////////////////////////////////////////

task srio_resp_generator::gen_io_resp_status;
bit [3:0] ftype;  
bit [3:0] ttype;
begin
    ftype = srio_trans_item.ftype;
    ttype = srio_trans_item.ttype;
    if((ftype == TYPE2 && (ttype == NRD || ttype >= 4'hC)) || (ftype == TYPE5 && (ttype == NWR_R || ttype >= 4'hC)))     
    begin   // TYPE2 NREAD and ATOMIC packets, TYPE5, NWRITE_R, ATOMIC Packets
      randcase
         ll_config.resp_done_ratio:begin
                                      srio_trans_item.trans_status = STS_DONE; // Done status
                                      if(srio_trans_item.ttype == NWR_R)       // For NWRITE_R, no payload ttype
                                        srio_trans_item.ttype  = RES_WO_DP;
                                      else  
                                        srio_trans_item.ttype  = RES_WITH_DP;
                                    end
         ll_config.resp_err_ratio:begin
                                      srio_trans_item.ttype  = RES_WO_DP;      // Ttype is no payload type
                                      srio_trans_item.trans_status = STS_ERROR;// Error status
                                    end 
      endcase
    end
    if(ftype == TYPE8)  // Maintenance packets
    begin
      if(srio_trans_item.ttype == MAINT_RD_REQ)     // for maintenance reqd request, maintenance read response
         srio_trans_item.ttype = MAINT_RD_RES;
      else if(srio_trans_item.ttype == MAINT_WR_REQ)// for maintenance write request, maintenance write response   
         srio_trans_item.ttype = MAINT_WR_RES;
      randcase
         ll_config.resp_done_ratio: srio_trans_item.trans_status = STS_DONE;   // Done response status
         ll_config.resp_err_ratio:  srio_trans_item.trans_status = STS_ERROR;  // Error response status
      endcase
    end
end
endtask: gen_io_resp_status

//////////////////////////////////////////////////////////////////////////
/// Name: gen_msg_db_resp_status \n
/// Description: Generate response status and ttype values for MSG/DB packets \n
/// Various status values are generated using the programmed ratio \n
/// gen_msg_db_resp_status
//////////////////////////////////////////////////////////////////////////

task srio_resp_generator::gen_msg_db_resp_status;
bit [3:0] ftype;  
bit [3:0] ttype;
begin

    ftype = srio_trans_item.ftype;
    ttype = srio_trans_item.ttype;

    if(ftype == TYPE10 || ftype == TYPE11) // Message or Doorbell packets
    begin
      if(srio_trans_item.ftype == TYPE11)  // Message response
        srio_trans_item.ttype = MSG_RES;
      else
        srio_trans_item.ttype = RES_WO_DP; // Doorbell response
      randcase
          ll_config.resp_done_ratio:  srio_trans_item.trans_status = STS_DONE;   // DONE response status
          ll_config.resp_retry_ratio: srio_trans_item.trans_status = STS_RETRY;  // RETRY response status
          ll_config.resp_err_ratio:   srio_trans_item.trans_status = STS_ERROR;  // Error response status
      endcase
    end
end
endtask: gen_msg_db_resp_status

//////////////////////////////////////////////////////////////////////////
/// Name: gen_gsm_resp_status \n
/// Description: Generate response status and ttype values for GSM packetsn\n
/// Various status values are generated using the programmed ratio \n
/// gen_gsm_resp_status
//////////////////////////////////////////////////////////////////////////

task srio_resp_generator::gen_gsm_resp_status;
bit [3:0] ftype;  
bit [3:0] ttype;
begin

    ftype = srio_trans_item.ftype;
    ttype = srio_trans_item.ttype;

    if(ftype == TYPE5 && ttype < 4'h2)    // Type5 GSM packets
    begin
      srio_trans_item.ttype = RES_WO_DP;  // Response without Data payload
      randcase
        ll_config.resp_done_ratio:      srio_trans_item.trans_status = STS_DONE;   // DONE response status
        ll_config.resp_retry_ratio:     srio_trans_item.trans_status = STS_RETRY;  // RETRY response status
        ll_config.resp_err_ratio:       srio_trans_item.trans_status = STS_ERROR;  // ERROR response status
        ll_config.resp_not_owner_ratio: srio_trans_item.trans_status = STS_NOT_OWNER; // NOT_OWNER response status
      endcase
    end
    if(ftype == TYPE1 && ttype < 4'h3)   // Type1 GSM packets
    begin
      randcase
        ll_config.resp_retry_ratio:     srio_trans_item.trans_status = STS_RETRY;   // RETRY response status
        ll_config.resp_err_ratio:       srio_trans_item.trans_status = STS_ERROR;   // ERROR response status
        ll_config.resp_not_owner_ratio: srio_trans_item.trans_status = STS_NOT_OWNER; // NOT_OWNER response status
        ll_config.resp_interv_ratio:    srio_trans_item.trans_status = STS_INTERVENTION; // INTERVENTION response status
      endcase
      if(srio_trans_item.trans_status == STS_INTERVENTION)   // Intervention status packets will have payload
        srio_trans_item.ttype = RES_WITH_DP; 
      else
        srio_trans_item.ttype = RES_WO_DP; 
    end
    if(ftype == TYPE2 && (ttype < 4'h3 || ttype == IRD_HOME))// Type2 GSM packets RD_HOME,RD_OWN_HOME,IORD_HOME
    begin
      randcase
        ll_config.resp_done_ratio:      srio_trans_item.trans_status = STS_DONE;  // Done status
        ll_config.resp_retry_ratio:     srio_trans_item.trans_status = STS_RETRY; // Retry status 
        ll_config.resp_err_ratio:       srio_trans_item.trans_status = STS_ERROR;  // Error status
        ll_config.resp_not_owner_ratio: srio_trans_item.trans_status = STS_NOT_OWNER;  // Not Owner status
        ll_config.resp_done_interv_ratio: srio_trans_item.trans_status = STS_DONE_INT; // Done Intervention status
        ll_config.resp_data_only_ratio:   srio_trans_item.trans_status = STS_DATA_ONLY; // Data Only status
      endcase
      if(srio_trans_item.trans_status == STS_DONE || srio_trans_item.trans_status == STS_DATA_ONLY)
        srio_trans_item.ttype = RES_WITH_DP;   // Status DONE and DATA_ONLY has payload data 
      else
        srio_trans_item.ttype = RES_WO_DP; 
    end
    else if(ftype == TYPE2)                    // Remaining Type2 GSM packets
    begin
      randcase
        ll_config.resp_done_ratio:      srio_trans_item.trans_status = STS_DONE;   // DONE Status
        ll_config.resp_retry_ratio:     srio_trans_item.trans_status = STS_RETRY;  // RETRY status
        ll_config.resp_err_ratio:       srio_trans_item.trans_status = STS_ERROR;  // ERROR status
        ll_config.resp_not_owner_ratio: srio_trans_item.trans_status = STS_NOT_OWNER; // NOT_OWNER status
      endcase
      srio_trans_item.ttype = RES_WO_DP; 
    end
end
endtask: gen_gsm_resp_status

//////////////////////////////////////////////////////////////////////////
/// Name: gen_resp_delay \n
/// Description: Delays transmission of responses as per the delay value  \n
/// configured.Delay value is in ns.Loop runs for every 1ns and each packet's \n
/// ll_rd_cnter is incremented.When it matches with the delay value configured \n
/// packet will be popped out and sent to transmission queue \n
/// gen_resp_delay
//////////////////////////////////////////////////////////////////////////

task srio_resp_generator::gen_resp_delay;
int q_size;
int tmp_index;
begin
   forever
   begin
      #1ns;
      tmp_index = 0;
      q_size = ll_resp_delay_q.size();                // Run the delay cnter for each packet in the queue 
      while(tmp_index < ll_resp_delay_q.size())
      begin
        if(ll_resp_delay_q[tmp_index].ll_rd_cnter >= ll_resp_delay_q[tmp_index].ll_rd) // If matches with the configured
        begin                                                                          // delay value,take it out
          resp_pkt_q.push_back(ll_resp_delay_q[tmp_index]); 
          ll_resp_delay_q.delete(tmp_index);   
          ll_common_class.pkt_cnt_update(TRUE);      // Increment the packet count
        end
        else begin                                   // Otherwise increase the delay cnter and move to next packet
          ll_resp_delay_q[tmp_index].ll_rd_cnter++;   
          tmp_index++;
        end
      end
   end
end
endtask: gen_resp_delay

//////////////////////////////////////////////////////////////////////////
/// Name: get_next_pkt \n
/// Description: Called by packet scheduler , provides the Response packet if \n
/// available in the queue.If packet is present returns pkt_valid as TRUE \n
/// Out_of_order_gen mode is enabled , randomly picks one packet from the \n
/// queue else follows first in first out.Injects response type errors \n
/// get_next_pkt
//////////////////////////////////////////////////////////////////////////
 
task srio_resp_generator::get_next_pkt(bit[2:0] sub_type,bit [31:0] tx_pkt_id,output bool pkt_valid,output srio_trans o_srio_trans);
int q_index;
begin
   pkt_valid = FALSE;
   if(resp_pkt_q.size() > 0)             // Check is the response packet queue has packet to transmit
   begin
      pkt_valid = TRUE;                  // Yes,packet valid is TRUE
      if(ll_config.en_out_of_order_gen)  // Out of order responses
      begin
        q_index = $urandom_range(resp_pkt_q.size()-1,0); // Randomly take one from the queue
        o_srio_trans = new resp_pkt_q[q_index];
        resp_pkt_q.delete(q_index); 
      end
      else begin
        o_srio_trans = new resp_pkt_q.pop_front();      // Otherwise top most packet sent out
      end  
      ll_common_class.pkt_cnt_update(FALSE);            // Decrement the total packet count
      case(o_srio_trans.ll_err_kind)                    // Check whether error needs to be injected
         RESP_RSVD_STS_ERR:begin                        // RESERVED Status Error
                             o_srio_trans.trans_status = STS_RESERVED10;
                           end
         RESP_PRI_ERR:begin                             // Priority Error
                        o_srio_trans.prio = 0;
                      end
         RESP_PAYLOAD_ERR:begin                         // More payload than supposed to be
                            for(int cnt = 0; cnt < 8; cnt++)
                              o_srio_trans.payload.push_back(cnt);
                          end
         NO_PAYLOAD_ERR:begin                           // No payload expected , but some payload is present
                          for(int cnt = 0; cnt < 8; cnt++)
                            o_srio_trans.payload.push_back(cnt);
                        end
         PAYLOAD_EXIST_ERR:begin                        // Supposed to have payload, but deleting it
                              o_srio_trans.payload.delete();
                           end
       
      endcase
   end
end
endtask: get_next_pkt

//////////////////////////////////////////////////////////////////////////
/// Name: print_resp_pkt_info \n
/// Description: Prints the info about the request packet for which the \n
/// response is generated. \n 
/// run_phase
//////////////////////////////////////////////////////////////////////////

task srio_resp_generator::print_resp_pkt_info(srio_trans i_srio_trans);
srio_trans_ftype    trans_ftype;  
srio_trans_ttype1   trans_ttype1; 
srio_trans_ttype2   trans_ttype2; 
srio_trans_ttype5   trans_ttype5; 
srio_trans_ttype8   trans_ttype8; 
srio_trans_ttype13  trans_ttype13;
begin
  // Casting ftype and ttype values
  trans_ftype        = srio_trans_ftype'(i_srio_trans.ftype);
  trans_ttype1       = srio_trans_ttype1'(i_srio_trans.ttype);
  trans_ttype2       = srio_trans_ttype2'(i_srio_trans.ttype);
  trans_ttype5       = srio_trans_ttype5'(i_srio_trans.ttype);
  trans_ttype8       = srio_trans_ttype8'(i_srio_trans.ttype);
  trans_ttype13      = srio_trans_ttype13'(i_srio_trans.ttype);

  `uvm_info(get_name(),$sformatf("%s Response Generation", (
  (trans_ftype == FTYPE1) ? trans_ttype1.name : (
  (trans_ftype == FTYPE2) ? trans_ttype2.name : (
  (trans_ftype == FTYPE5) ? trans_ttype5.name : (
  (trans_ftype == FTYPE6) ? "SWRITE"    : (
  (trans_ftype == FTYPE7) ? "LFC"       : (
  (trans_ftype == FTYPE8) ? trans_ttype8.name : (
  (trans_ftype == FTYPE9) ? ((i_srio_trans.xh == 1) ? "DS TM" : "DS") : (
  (trans_ftype == FTYPE10)? "DOOR BELL" : (
  (trans_ftype == FTYPE11)? "DATA MSG"  : (
  (trans_ftype == FTYPE13)? trans_ttype13.name: "UNRECOGNIZED PKT"))))))))))), UVM_LOW);

end
endtask: print_resp_pkt_info
