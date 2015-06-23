////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_tl_genreator.sv
// Project :  srio vip
// Purpose :  Transport Layer Generator
// Author  :  Mobiveil
//
// Handles generation of TL fields
// Handles Flow control mechanism
//////////////////////////////////////////////////////////////////////////////// 

class srio_tl_generator extends uvm_component;

  /// @cond 
  `uvm_component_utils(srio_tl_generator)
  /// @endcond 

   srio_trans srio_trans_item;   ///< SRIO trans received from LL
   srio_tl_config tl_config;     ///< TL config object
   srio_env_config env_config;   ///< Env config object 

   uvm_blocking_put_port #(srio_trans) tl_tr_gen_put_port;  ///< TLM port connects TL and PL tx interface

  /// @cond 
   `uvm_register_cb(srio_tl_generator,srio_tl_callback)     ///< TL TX call back 
  /// @endcond 

   srio_trans tl_tx_q[$];       ///< Queue stores the packets received from LL 
   srio_trans lfc_timer_q[$];   ///< Queue stores the received LFC packets on the RX side 

   int  lfc_cnter_q[bit[38:0]];  ///< Stores the count of LFC flowid
   bool fam_status_q[bit[38:0]]; ///< FAM status of LFC flowid for DS
   bit  tm_fc[bit[55:0]];        ///< DS traffic management information  
   bit  [2:0] rx_wc      = 0;    ///< Wildcard information received in the DS TM packet
   semaphore   tl_gen_sema;      ///< Semaphore for tl_gen task

  // Methods
  extern function new(string name="srio_tl_generator", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern virtual task fc_transmit_pkt();
  extern virtual task process_rx_pkt(srio_trans i_srio_trans);
  extern virtual task decode_lfc_info(srio_trans i_srio_trans);
  extern virtual task decode_lfc_fam(srio_trans i_srio_trans);
  extern virtual task decode_ds_tm(srio_trans i_srio_trans);
  extern virtual task lfc_timer_logic();
  extern virtual task automatic tl_pkt_gen(srio_trans i_srio_trans);

  virtual task srio_tl_trans_generated(ref srio_trans tx_srio_trans);
  endtask

endclass: srio_tl_generator

////////////////////////////////////////////////////////////////////////////////
/// Name: new \n 
/// Description: TL generator's new function \n
/// new
//////////////////////////////////////////////////////////////////////////////// 

function srio_tl_generator::new (string name = "srio_tl_generator", uvm_component parent = null);
  super.new(name, parent);
  tl_tr_gen_put_port = new("tl_tr_gen_put_port", this);
  tl_gen_sema = new(1);                                  // Create semaphore with one key
endfunction: new

////////////////////////////////////////////////////////////////////////////////
/// Name: build_phase \n
/// Description: TL generator's build_phase function \n
/// build_phase
////////////////////////////////////////////////////////////////////////////////

function void srio_tl_generator::build_phase(uvm_phase phase);
  if(!uvm_config_db #(srio_env_config)::get(this, "", "srio_env_config", env_config)) // get env config handle from config database
    `uvm_fatal("CONFIG FATAL", "Can't get the env_config")
  if(!uvm_config_db #(srio_tl_config)::get(this, "", "tl_config", tl_config))         // get tl config handle from config database 
    `uvm_fatal("CONFIG FATAL", "Can't get the tl_config")
endfunction: build_phase

////////////////////////////////////////////////////////////////////////////////
/// Name: run_phase \n
/// Description: TL Generator's run_phase function \n
/// run_phase
//////////////////////////////////////////////////////////////////////////////// 

task srio_tl_generator::run_phase(uvm_phase phase);
   fork
     lfc_timer_logic;    // LFC timer thread 
     fc_transmit_pkt;    // LFC blocking thread
    join_none
endtask: run_phase

////////////////////////////////////////////////////////////////////////////////
/// Name: tl_pkt_gen \n
/// Description: Insert TL fields for packets received from LL and TL sequencer \n
/// tl_pkt_gen
//////////////////////////////////////////////////////////////////////////////// 

task automatic srio_tl_generator::tl_pkt_gen(srio_trans i_srio_trans);
bit [3:0] ftype;
bit [3:0] ttype;
begin

    tl_gen_sema.get(1);  // This task is called whenever packets are received from LL and TL sequencer
                         // Semaphore to give access one at a time
    srio_trans_item = new i_srio_trans;
    srio_trans_item.pkt_type = SRIO_TL_PACKET;
    ftype = srio_trans_item.ftype;  
    ttype = srio_trans_item.ttype;
    // Do not alter the source and destionation id for response packets
    if(ftype != TYPE13 && (!(ftype == TYPE8 && (ttype == MAINT_RD_RES || ttype == MAINT_WR_RES))))
    begin
      if(tl_config.usr_sourceid_en == TRUE)                 // User configured  source and dest id values
        srio_trans_item.SourceID = tl_config.usr_sourceid;
      if(tl_config.usr_destinationid_en == TRUE)
        srio_trans_item.DestinationID = tl_config.usr_destinationid;
    end
    tl_tx_q.push_back(srio_trans_item);   // Push it to queue for Flow control check
    tl_gen_sema.put(1);                   // Put back the key  
end 
endtask: tl_pkt_gen

////////////////////////////////////////////////////////////////////////////////
/// Name: fc_transmit_pkt \n
/// Description: flow control logic \n
/// fc_transmit_pkt
//////////////////////////////////////////////////////////////////////////////// 

task srio_tl_generator::fc_transmit_pkt;
srio_trans srio_tl_tx_trans;
int  q_size    = 0;
int  q_index   = 0;
bool pkt_block = FALSE;
bool pkt_found = FALSE;
bit [38:0] fam_id   = 0; 
bit [38:0] lfc_port = 0; 
begin
   forever
   begin
     wait(tl_tx_q.size() > 0);   // Wait for the TL TX queue to get packet
     pkt_block = FALSE;
     pkt_found = FALSE;
     q_size = tl_tx_q.size();
     q_index = 0;
     while(pkt_found == FALSE && q_index < q_size)  // Check each packet in the queue whether it is blocked by Flowcontrol
     begin
       srio_tl_tx_trans = new tl_tx_q[q_index];
       if(srio_tl_tx_trans.ftype == TYPE7 || (srio_tl_tx_trans.ftype == TYPE9 && srio_tl_tx_trans.xh == 1))
       begin                    // No need to block LFC and traffic management packets
         pkt_found = TRUE;
         tl_tx_q.delete(q_index); 
       end
       else begin   
         if(srio_tl_tx_trans.ftype == TYPE9 && srio_tl_tx_trans.xh == 0)  // DS packets can be blocked by LFC,TM and FAM
         begin                                                           // check for DS TM rules
           if(rx_wc != 3'b111)        // Wild card not 111, check if that stream id needs to be blocked
           begin
              if(tm_fc.num() > 0 && tm_fc.exists({srio_tl_tx_trans.DestinationID,srio_tl_tx_trans.cos,srio_tl_tx_trans.streamID}))
               pkt_block = TRUE;  // tm_fc array has the information of block/unblock of a particular stream id   
           end
           else begin
               pkt_block = TRUE;        // wildcard 111, block all DS stream traffic
           end   
           if(pkt_block == FALSE)      // DS packet is not blocked by TM information, check for FAM
           begin
             if(env_config.multi_vc_support && env_config.srio_mode != SRIO_GEN13 && srio_tl_tx_trans.vc) // Multi VC supported 
             begin
               if(env_config.vc_num_support == 8)    // get the flow id value of the DS packet based on the number of VCs supported
               begin                                 // Supported VCs are 8  
                 fam_id = {srio_tl_tx_trans.DestinationID,1'b1,3'b0,srio_tl_tx_trans.prio,srio_tl_tx_trans.crf};
                 fam_id++; 
               end
               else if(env_config.vc_num_support == 4)    // Supported VCs are 4
                 fam_id = {srio_tl_tx_trans.DestinationID,1'b1,3'b0,srio_tl_tx_trans.prio,1'b1}; 
               else if(env_config.vc_num_support == 2)    // Supported VCs are 2
                 fam_id = {srio_tl_tx_trans.DestinationID,1'b1,3'b0,srio_tl_tx_trans.prio[1],1'b0,1'b1}; 
               else if(env_config.vc_num_support == 1)    // Supported VCs are 1
                 fam_id = {srio_tl_tx_trans.DestinationID,7'b1000001}; 
             end
             else begin                // Single VC support, get the flow id along with Destionation id value
               fam_id = {srio_tl_tx_trans.DestinationID,4'h0,srio_tl_tx_trans.prio,srio_tl_tx_trans.crf}; 
             end   
             if(fam_status_q.exists(fam_id) && fam_status_q[fam_id] == FALSE)
               pkt_block = TRUE;    
           end                
         end
         if(pkt_block == FALSE)        // Check for normal LFC flowcontrol, if not blocked by the TM and FAM
         begin                         // Get the destionation,pri,crf and VC values, check if it is blocked
           if(env_config.multi_vc_support && env_config.srio_mode != SRIO_GEN13 && srio_tl_tx_trans.vc) // Multi VC support
           begin
             if(env_config.vc_num_support == 8)
             begin   
               lfc_port = {srio_tl_tx_trans.DestinationID,1'b1,3'b0,srio_tl_tx_trans.prio,srio_tl_tx_trans.crf};
               lfc_port++; 
             end
             else if(env_config.vc_num_support == 4)
               lfc_port = {srio_tl_tx_trans.DestinationID,1'b1,3'b0,srio_tl_tx_trans.prio,1'b1}; 
             else if(env_config.vc_num_support == 2)
               lfc_port = {srio_tl_tx_trans.DestinationID,1'b1,3'b0,srio_tl_tx_trans.prio[1],1'b0,1'b1}; 
             else if(env_config.vc_num_support == 1)
               lfc_port = {srio_tl_tx_trans.DestinationID,7'b1000001}; 
           end
           else begin
             lfc_port = {srio_tl_tx_trans.DestinationID,4'h0,srio_tl_tx_trans.prio,srio_tl_tx_trans.crf}; // Single VC support
           end   
           if(lfc_cnter_q.exists(lfc_port) && lfc_cnter_q[lfc_port] > 0) // If LFC packet received for destinaton,crf,pri combination
           begin                                                         // block the transmission of the packet
             pkt_block = TRUE;
           end
         end
         if(pkt_block == FALSE)        // if a packet is not blocked by any of the FC mechanism, then packet can be sent to PL
         begin
           pkt_found = TRUE;
           tl_tx_q.delete(q_index); 
         end
         q_index++;
       end
       if(pkt_found) begin 
        `uvm_do_callbacks(srio_tl_generator,srio_tl_callback,srio_tl_trans_generated(srio_tl_tx_trans))  // Invoke TL TX call back method
        tl_tr_gen_put_port.put(srio_tl_tx_trans);                                                        // Push the packet to PL
       end
     end 
     if(pkt_found == FALSE)
      #1ns; 
   end
end
endtask: fc_transmit_pkt

////////////////////////////////////////////////////////////////////////////////
/// Name: process_rx_pkt \n
/// Description: Checks if the received packet from other device is \n
/// flowcontrol packets and calles the respecive decoding task. \n
/// process_rx_pkt
//////////////////////////////////////////////////////////////////////////////// 

task srio_tl_generator::process_rx_pkt(srio_trans i_srio_trans);
srio_trans srio_tl_rx_trans;
begin 
    srio_tl_rx_trans = new i_srio_trans;
    if(srio_tl_rx_trans.ftype == TYPE7)     // if LFC packet (type7) is received
    begin
      decode_lfc_info(srio_tl_rx_trans);
      decode_lfc_fam(srio_tl_rx_trans);
    end  
    if(srio_tl_rx_trans.ftype == TYPE9 && srio_tl_rx_trans.xtype == 3'h0 && srio_tl_rx_trans.xh == 1)
    begin                                        // DS traffic mangement packet decoding
      decode_ds_tm(srio_tl_rx_trans);
    end
end
endtask: process_rx_pkt

////////////////////////////////////////////////////////////////////////////////
/// Name: decode_lfc_info \n
/// Description: Decodes the received information in LFC packet and stores it \n
/// for flowcontrol logic. \n
/// decode_lfc_info
//////////////////////////////////////////////////////////////////////////////// 

task srio_tl_generator::decode_lfc_info(srio_trans i_srio_trans);
int size     = 0;
int q_index  = 0;
bit vc       = 0;
bit xon_xoff = 0;
bit [31:0] tgtdestID = 0;
bit [2:0] FAM        = 0;
bit [6:0] flowID     = 0;
bit [36:0] lfc_port  = 0;
bool index_hit       = FALSE;
srio_trans srio_tl_rx_trans;
begin 
    srio_tl_rx_trans = new i_srio_trans;
    vc        = srio_tl_rx_trans.vc;                // get the VC value
    tgtdestID = srio_tl_rx_trans.tgtdestID;  // Get the target destination id to be blocked/unblocked
    xon_xoff  = srio_tl_rx_trans.xon_xoff;    // XON or XOFF
    FAM       = srio_tl_rx_trans.FAM;              // Get the FAM value
    flowID    = srio_tl_rx_trans.flowID;        // Flowid received in the LFC packet
    if(xon_xoff == 0 && FAM == 3'h0)         // XOFF, No FAM logic involved
    begin
      if(env_config.multi_vc_support && env_config.srio_mode != SRIO_GEN13 && flowID[6]) // Multi VC support
      begin
        lfc_port = {tgtdestID,flowID};       // Form the Dest id and flow id to be blocked
        if(lfc_cnter_q.exists(lfc_port))     // If packet is already received for that combination, increment
        begin
           lfc_cnter_q[lfc_port]++;          // LFC cnter stores the number of XOFF packets received for each 
        end                                  // <destid + flowid> combination
        else begin
            lfc_cnter_q[lfc_port] = 1;       // first XOFF packet with multi vc support
        end
      end
      else if(flowID[6] == 0)  // single VC support
      begin  
        for(bit[2:0] tmp_cnt = 0; tmp_cnt <= flowID[2:0]; tmp_cnt++) // example if XOFF for PRI2 is received, need to block 
        begin                                                        // all the below priorites also 
          lfc_port = {tgtdestID,flowID[6:3],tmp_cnt};                // increment the LFC counter for each prio
          if(lfc_cnter_q.exists(lfc_port))
          begin
             lfc_cnter_q[lfc_port]++;
          end
          else begin
              lfc_cnter_q[lfc_port] = 1;
          end
        end
      end
      srio_tl_rx_trans.lfc_orphan_cnter = 0;      // Load initial value as 0 for orphan timer   
      lfc_timer_q.push_back(srio_tl_rx_trans);    // Push the received LFC packet to LFC timer queue for Orphan timer mechanism
    end 
    if(xon_xoff == 1 && FAM == 3'h0)     // XON, No FAM logic is involved
    begin 
      if(env_config.multi_vc_support && env_config.srio_mode != SRIO_GEN13 && flowID[6])  // Multi VC support
      begin
        lfc_port = {tgtdestID,flowID};                 // get tgtdestionation and flowid 
        if(lfc_cnter_q.exists(lfc_port))
        begin
          lfc_cnter_q[lfc_port]--;                    // decrement the LFC packet counter since XON received 
        end
        if(lfc_cnter_q[lfc_port] == 0)
        begin
          lfc_cnter_q.delete(lfc_port);
        end
      end
      else if(flowID[6] == 0)  // single VC support
      begin  
        for(bit[2:0] tmp_cnt = flowID[2:0]; tmp_cnt < 6; tmp_cnt++)  // example if XON for pri1 received, counters for higher priorities 
        begin                                                        // also needs to be decremented  
          lfc_port = {tgtdestID,flowID[6:3],tmp_cnt};
           if(lfc_cnter_q.exists(lfc_port))
           begin
             lfc_cnter_q[lfc_port]--;
           end
           if(lfc_cnter_q[lfc_port] == 0)
           begin
             lfc_cnter_q.delete(lfc_port);
           end
        end
      end  
      index_hit = FALSE;
      q_index   = 0;
      size = lfc_timer_q.size();
      while(index_hit == FALSE && q_index < size)  // once XON packet is received for a flow id, remove it from orphan timer queue
      begin                                        // orphan timer logic is stopped for that flow id  
         if(lfc_timer_q[q_index].flowID == flowID && lfc_timer_q[q_index].tgtdestID == tgtdestID)
         begin                                     // search if XOFF for that flow id is preasent in the orphan timer queue
            index_hit = TRUE;
         end
         else begin
           q_index++;
         end
      end
      if(index_hit == TRUE)                     // IF XON is received and XOFF is already present ,remove it from orphan timer logic  
         lfc_timer_q.delete(q_index);
    end
end
endtask: decode_lfc_info

////////////////////////////////////////////////////////////////////////////////
/// Name: decode_lfc_fam \n
/// Description: Decodes FAM field reeived inthe LFC packet \n
/// decode_lfc_fam
//////////////////////////////////////////////////////////////////////////////// 

task srio_tl_generator::decode_lfc_fam(srio_trans i_srio_trans);
bit xon_xoff = 0;
bit [31:0] tgtdestID = 0;
bit [2:0] FAM        = 0;
bit [6:0] flowID     = 0;
bit [36:0] lfc_port  = 0;
begin 
    tgtdestID = i_srio_trans.tgtdestID;  // Get the target destination id to be blocked/unblocked
    xon_xoff  = i_srio_trans.xon_xoff;    // XON or XOFF
    FAM       = i_srio_trans.FAM;              // Get the FAM value
    flowID    = i_srio_trans.flowID;        // Flowid received in the LFC packet
    lfc_port  = {tgtdestID,flowID};
    if(xon_xoff == 1 && FAM > 3'h3)           // Flow arbitration mechanism
    begin
      fam_status_q[lfc_port] = FALSE;         // XON Requested,yet to get the grant, till that time, Grant for transmission is FALSE
    end
    if(xon_xoff == 1 && (FAM == 3'h2 || FAM == 3'h3))  // XON Request is granted, Grant for transmission is TRUE
    begin
      fam_status_q[lfc_port] = TRUE;
    end
    if(xon_xoff == 0 && (FAM == 3'h2 || FAM == 3'h3))  // XOFF, request is rejected, Grant for transmission is FALSE
    begin
      fam_status_q[lfc_port] = FALSE;
    end
    if(xon_xoff == 0 && (FAM == 3'h4 || FAM == 3'h5))  // XOFF, released and the request is no more valid
    begin
      if(fam_status_q.exists(lfc_port))
        fam_status_q.delete(lfc_port);
    end
end
endtask: decode_lfc_fam

////////////////////////////////////////////////////////////////////////////////
/// Name: decode_ds_tm \n
/// Description: Decodes DS traffic management packet and stores the informations \n
/// for DS flowcontrol logic. \n
/// decode_ds_tm
//////////////////////////////////////////////////////////////////////////////// 

task srio_tl_generator::decode_ds_tm(srio_trans i_srio_trans);
bit [7:0] cos        = 0;
bit [2:0] xtype      = 0;
bit [2:0] wild_card  = 0;
bit [7:0] parameter1 = 0;
bit [7:0] parameter2 = 0;
bit [3:0] TMOP       = 0;
bit [7:0] mask       = 0;
bit [15:0] streamID  = 0;
bit [31:0] destid    = 0;
bit [31:0] s_d       = 0;
bit [31:0] e_d       = 0;
bit [7:0]  s_c       = 0;
bit [7:0]  e_c       = 0;
bit [15:0] s_s       = 0;
bit [15:0] e_s       = 0;
begin 
      destid     = i_srio_trans.SourceID;
      streamID   = i_srio_trans.streamID;
      cos        = i_srio_trans.cos;
      wild_card  = i_srio_trans.wild_card; 
      mask       = i_srio_trans.mask; 
      TMOP       = i_srio_trans.TMOP; 
      parameter1 = i_srio_trans.parameter1; 
      parameter2 = i_srio_trans.parameter2; 
      if(TMOP < 3 && parameter1 == 0 && parameter2 == 0)     // XOFF DS TM received
       rx_wc      = wild_card; 
      if(TMOP < 3 && parameter1 == 0 && parameter2 == 8'hFF) // XON DS TM received
       rx_wc      = 0; 
      if(wild_card == 3'b111)              // wildcard 111 , block all dest,cos stream id
      begin
        s_d = 32'h0; e_d = 32'h0; s_c = 8'h0; e_c = 8'h0; s_s = 16'h0; e_s = 16'h0;        
      end
      else if(wild_card == 3'b011)         // All cos,stream id in a dest id need to be blocked
      begin
        s_d = destid; e_d = destid; s_c = 8'h0; e_c = 8'hFF; s_s = 16'h0;  e_s = 16'hFFFF;        
      end
      else if(wild_card == 3'b001)     
      begin
        if(mask == 0)      // all stream id in a particular cos and destination
        begin
          s_d = destid; e_d = destid; s_c = cos; e_c = cos; s_s = 16'h0; e_s = 16'hFFFF;        
        end else
        begin                // Group of cos ,all streams blocked based on mask value
          s_d = destid; e_d = destid; s_c = cos & ~mask; e_c = 8'hFF; s_s = 16'h0; e_s = 16'hFFFF;        
        end          
      end
      else begin           // blocking based on dest,cos,streamid
          s_d = destid; e_d = destid; s_c = cos; e_c = cos; s_s = streamID; e_s = streamID;        
      end
      if(TMOP < 3 && parameter1 == 0 && parameter2 == 0) // XOFF DS TM received
      begin
        for(bit[56:0] cnt = {1'b0,s_d,s_c,s_s}; cnt <= {1'b0,e_d,e_c,e_s}; cnt++)
        begin
           tm_fc[cnt[55:0]] = 1;
        end
      end
      else if(TMOP < 3 && parameter1 == 0 && parameter2 == 8'hFF) // XON DS TM received
      begin
       for(bit[56:0] cnt = {1'b0,s_d,s_c,s_s}; cnt <= {1'b0,e_d,e_c,e_s}; cnt++)
       begin
         if(tm_fc.num() > 0 && tm_fc.exists(cnt[55:0]))
           tm_fc.delete(cnt[55:0]);
       end          
      end
end
endtask: decode_ds_tm

////////////////////////////////////////////////////////////////////////////////
/// Name: lfc_timer_logic \n
/// Description: Handles orphan timer logic for LFC packets \n
/// Timer runs for each LFC XOFF received one bye one. 1ns timer \n
/// lfc_timer_logic
////////////////////////////////////////////////////////////////////////////////

task srio_tl_generator::lfc_timer_logic;
bit [31:0] tgtdestID;
bit [6:0]  flowID;
bit [38:0] lfc_port;
begin
   forever 
   begin
     #1ns;
     if(lfc_timer_q.size() > 0)  // if LFC XOFF present
     begin
       lfc_timer_q[0].lfc_orphan_cnter++;  // orphan cnter is incremented for the first packet in the queue
       if(lfc_timer_q[0].lfc_orphan_cnter >= tl_config.lfc_orphan_timer)
       begin                                    // if orphan cnter is equal to the orphan timer configured
         tgtdestID = lfc_timer_q[0].tgtdestID;  // and no XON received, decrement the cnt 
         flowID    = lfc_timer_q[0].flowID; 
         if(flowID[6])                         // Multiple VC support, only that flow id is decremented
         begin 
           lfc_port = {tgtdestID,flowID};
           if(lfc_cnter_q.exists(lfc_port))
           begin
             lfc_cnter_q[lfc_port]--;
           end
           if(lfc_cnter_q[lfc_port] == 0)
           begin
             lfc_cnter_q.delete(lfc_port);
           end
         end
         else begin               // single VC support, all the hight priorities also neesds to be decremented
           for(bit[2:0] tmp_cnt = flowID[2:0]; tmp_cnt < 6; tmp_cnt++)
           begin
             lfc_port = {tgtdestID,flowID[6:3],tmp_cnt};
             if(lfc_cnter_q.exists(lfc_port))
             begin
               lfc_cnter_q[lfc_port]--;
             end
             if(lfc_cnter_q[lfc_port] == 0)
             begin
               lfc_cnter_q.delete(lfc_port);
             end
           end
         end
         lfc_timer_q.delete(0);
       end
     end 
   end
end
endtask: lfc_timer_logic
