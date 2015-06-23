////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_pktcs_merger.sv
// Project :  srio vip
// Purpose :  Physical Layer Packet CS Merger 
// Author  :  Mobiveil
//
// Physical Layer Packet CS Merger component.
//
////////////////////////////////////////////////////////////////////////////////  
typedef class srio_pl_idle_gen;
class srio_pl_pktcs_merger extends uvm_component;
 
  /// @cond
   `uvm_component_utils(srio_pl_pktcs_merger)
  /// @endcond

  virtual srio_interface srio_if;                              ///< Virtual interface

  srio_pl_config pktm_config;                                  ///< PL config instance

  srio_pl_common_component_trans pktm_trans;                   ///< PL common transaction instance

  srio_pl_pkt_handler  pkt_handler_ins;                        ///< PL Packet Handler Instance

  srio_pl_data_trans pktcs_proc_q[$];                          ///< PL data transaction Queue 

  srio_pl_data_trans merge_pkt,merge_cs,del_item;              ///< PL data transaction instance

  srio_pl_idle_gen idle_ins;                                   ///< PL Idle gen Instance 

  srio_env_config pktm_env_config;                             ///< ENV config instance

  srio_trans pl_pkt_q[$];                                      ///< Queue for Packets to be transmitted 
  srio_trans ip_pl_pkt_q[$];                                      ///< Queue for Packets to be transmitted 
  srio_trans pl_seqcs_q[$];                                    ///< Queue for Control symbols to be transmitted - Available from the sequencer
  srio_trans pl_gencs_q[$];                                    ///< Queue for Control symbols to be transmitted - Available from the BFM
  srio_trans pl_outstanding_ackid_q[$];                        ///< Queue for outstanding packets
  logic [0:7] temp_pkt_q[$];                                   ///< Scratch variable for Gen3 transmission queue formation 
  logic [0:7] pkt_queue[$];
  int merge_loc;                                               ///< Location for embeddeding CS
  int merge_rand1;                                               ///< Location for embeddeding CS
  int merge_rand2;                                               ///< Location for embeddeding CS
  int merge_rand3;                                               ///< Location for embeddeding CS
  int merge_rand4;                                               ///< Location for embeddeding CS
  bit embed_inc,pkt_can_req,cs_txt,pkt_avail_req,pkt_avail_req_g3; ///<Flags to control various operations as embedding, packet cancellation etc
  logic [0:11] bkp_ackid;                                      ///< ackid variables 
  logic [0:11] retry_ackid;
  logic [0:11] tmp;                                           ///< stype1 concatanation 
  bit   [0:31] temp_data;                                     ///< Below are scratch variables for queue formation
  bit   [0:31] temp1_data;                                     ///< Below are scratch variables for queue formation
  bit   [0:11] temp_ackid;
  bit   [0:7]  stype1_temp;
  bit   [0:3]  stype0_temp;
  bit   [0:7]  temp0,temp1,temp2,temp3,temp4,temp5,temp6,temp7;
  int         out_size,temp_size,pkt_push_tr,ackid_qsize;
  bit local_clr   =0;
  bit eop_rcvd    =0;
  int q_siz;
  bit begin_sop   =0;
  merge_states state;                                          ///< State variable 
  bit detect_ors_in_ies;

 int time_l=0;
  bit  [2:0] cs_comb;
  bit  cs_packed;
  srio_trans tranm_pkt_ins,tranm_gen_ins,tranm_gen_cs,tranm_csins,tranm_seq_cs,trans_push_ins,can_trans_ins,tp_trans,tp_trans1;
  srio_trans tranm_cs_ins1,tranm_cs_ins,tranm_seq_ins,merge_trans_ins,bkp_ackid_trans,rty_ackid_trans,del_stcs_ins;
  srio_trans pack_ts_ins[$];                                 ///< Transaction Item variables for queue formation  

  uvm_event srio_tx_pkt_event;                                  ///< Event - Triggered when a transaction is available in teh driver

  uvm_object uvm_pkt_ins;                                       ///< Transaction from teh driver is available as uvm_object  

  srio_trans pkt_ins;

  // Methods
  extern function new(string name = "srio_pl_pktcs_merger", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern function void reset_status_cnt();
  extern task run_phase(uvm_phase phase);
  extern task get_pkt();
  extern task capture_pkt_event();
  extern task pktcs_merge();
  extern task pktcs_merge_txrx();
  extern task gen_stomp_cs();
  extern task initialize();
  extern task hold_packets();
  extern task tfr_packets();
  extern task sorter();

 endclass :srio_pl_pktcs_merger 

///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : New
/// Description : Constructor method for srio_pl_pktcs_merger class.
///////////////////////////////////////////////////////////////////////////////////////////////
 function srio_pl_pktcs_merger::new(string name = "srio_pl_pktcs_merger", uvm_component parent = null);
  super.new(name, parent);
  pkt_ins = new();
//  merge_pkt = new();
//  merge_cs  = new();
 endfunction 

///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : build_phase
/// Description : build_phase method for srio_pl_pktcs_merger class.
///////////////////////////////////////////////////////////////////////////////////////////////
 function void srio_pl_pktcs_merger::build_phase(uvm_phase phase);
   super.build_phase(phase);
 endfunction :build_phase 

///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : hold_packets
/// Description : hold_packets method of srio_pl_pktcs_merger class.
/// It accumulates packets for a short duration to enable sop-pkt-sop-..-eop packet packaging
///////////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_pktcs_merger::hold_packets();
 forever
 begin
  if (time_l==0)
  begin
  time_l=$urandom_range(0,5);
  tfr_packets();
  end
  repeat (time_l)
   begin
    @(posedge pktm_trans.int_clk);
    time_l--;
   end
 end
 endtask:hold_packets

///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : tfr_packets
/// Description : tfr_packets method of srio_pl_pktcs_merger class.
/// It transfers all packet to main processing queue pl_pkt_q
///////////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_pktcs_merger::tfr_packets();
  int lq_siz=ip_pl_pkt_q.size();
  for(int k=0;k<lq_siz;k++)
   begin
     tranm_pkt_ins= new ip_pl_pkt_q[k];
     pl_pkt_q.push_back(ip_pl_pkt_q[k]);
   end  
   ip_pl_pkt_q.delete();
 endtask:tfr_packets
///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : run_phase
/// Description : run_phase method of srio_pl_pktcs_merger class.
/// It triggers all the methods within the class which needs to be run forever.
///////////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_pktcs_merger::run_phase(uvm_phase phase);
  fork
   get_pkt();
   hold_packets();
   if(pktm_env_config.srio_vip_model!=SRIO_TXRX)
    pktcs_merge();
   else
     pktcs_merge_txrx();
  join_none
 
 endtask:run_phase


///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : get_pkt
/// Description :Task to get packets/control symbols from the driver  
///////////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_pktcs_merger::get_pkt();

 fork
     capture_pkt_event();
 join
 endtask : get_pkt

///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : capture_pkt_event
/// Description :Task to put packets/control symbols received from the driver in the queue
///////////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_pktcs_merger::capture_pkt_event();

 forever begin //{

   #1;
   srio_tx_pkt_event.wait_ptrigger_data(uvm_pkt_ins);
   $cast(pkt_ins, uvm_pkt_ins);

   if(pkt_ins.pkt_type == SRIO_PL_PACKET && pkt_ins.transaction_kind == SRIO_PACKET)
   begin //{
     //pl_pkt_q.push_back(pkt_ins);
     ip_pl_pkt_q.push_back(pkt_ins);
   end //}
   else if(pkt_ins.pkt_type == SRIO_PL_PACKET && pkt_ins.transaction_kind == SRIO_CS)
     pl_seqcs_q.push_back(pkt_ins);  
 end //}
 endtask : capture_pkt_event

///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : initialize
/// Description :Task to initialize local variables 
///////////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_pktcs_merger::initialize();
     if(pktm_env_config.srio_mode == SRIO_GEN30)
     begin
        pkt_avail_req_g3 = 1'b1;
        pkt_avail_req = 1'b0;
     end
     else
     begin
        pkt_avail_req = 1'b1;
        pkt_avail_req_g3 = 1'b0;
     end

     if(pktm_env_config.srio_mode == SRIO_GEN30)
     begin
       ackid_qsize = 4096;
     end 

 endtask : initialize 

///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : pktcs_merge
/// Description :Task to form the queue of delimited packets and control symbols which are
/// to be transmitted on the lane.
/// Control symbols which can be merged together will be done here.
///////////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_pktcs_merger::pktcs_merge();
  initialize();
  forever
    begin //{
     if(pktm_trans.idle_selected && pktm_env_config.srio_mode != SRIO_GEN30 && pktm_trans.idle_detected )
       ackid_qsize = 64;
     else if (~pktm_trans.idle_selected && pktm_env_config.srio_mode != SRIO_GEN30 && pktm_trans.idle_detected)
       ackid_qsize = 32;
      @(posedge pktm_trans.int_clk or negedge srio_if.srio_rst_n)
      begin //{  
      if(~srio_if.srio_rst_n)
      begin //{
        ip_pl_pkt_q.delete();
        pl_pkt_q.delete();
        pktcs_proc_q.delete();
        temp_data=0;
        temp1_data=32'h0;
        begin_sop=0;
        pktm_trans.mul_ack_min=0;
        pktm_trans.mul_ack_max=0;
        retry_ackid=0;
        rty_ackid_trans=null;
        pl_outstanding_ackid_q.delete();
        detect_ors_in_ies=0;
        if(pktm_env_config.srio_mode == SRIO_GEN30)
        begin //{       
          state = MERGE_NORMAL_G3;
          pkt_can_req = 1'b0;
          pkt_avail_req_g3 = 1;  
          pkt_avail_req = 1;  
        end //}
        else
        begin //{       
          state = MERGE_NORMAL;
          pkt_can_req = 1'b0;
          pkt_avail_req_g3 = 1;  
          pkt_avail_req = 1;  
        end //}
      end //}        
      else         
      begin //{
       case(state) 
//For Gen 3 state with _G3 will be used.
       MERGE_NORMAL_G3 : begin //{
                        if(pl_pkt_q.size> 1 && pktm_trans.link_initialized && ~pktm_trans.oes_state && ~pktm_trans.ors_state && pkt_avail_req_g3 && pl_outstanding_ackid_q.size() < ackid_qsize) 
                         begin //{
                             merge_pkt = new();
                             q_siz=pl_pkt_q.size();
                             for(int k=0;k<q_siz;k++)
                              begin//{
                                tranm_pkt_ins  = new pl_pkt_q.pop_front();
                                temp_ackid     = tranm_pkt_ins.ackid;

                                if(pl_gencs_q.size() != 0)
                                 begin //{
                                     for(int i=0;i<pl_gencs_q.size();i++)
                                     begin //{
                                        tranm_cs_ins = new pl_gencs_q[i];
                                        stype1_temp = {tranm_cs_ins.brc3_stype1_msb,tranm_cs_ins.stype1, tranm_cs_ins.cmd};
                                        stype0_temp =  tranm_cs_ins.stype0;
                                        if(stype1_temp == 8'h18 || stype1_temp == 8'h22 || stype1_temp == 8'h23 || stype1_temp == 8'h24 || stype1_temp == 8'h2B)                   
                                        begin //{
                                            pl_gencs_q.delete(i);
                                            merge_cs = new();
                                            merge_cs.brc3_merged_cs[0] = {2'b10,tranm_cs_ins.stype0,tranm_cs_ins.param0,tranm_cs_ins.param1,tranm_cs_ins.brc3_stype1_msb,2'b01,32'h0000_0000};
                                            merge_cs.brc3_merged_cs[1] = {2'b10,tranm_cs_ins.stype1,tranm_cs_ins.cmd,tranm_cs_ins.cs_crc24,2'b10,32'h0000_0000};                       
                                            if(stype1_temp == 8'h24)
                                            begin //{
                                               merge_cs.link_req_en = 1'b1;
                                            end //} 
                                            else if(stype1_temp == 8'h18)
                                            begin //{ 
                                               merge_cs.rst_frm_rty_en = 1'b1;
                                            end //} 
                                            if(tranm_cs_ins.stype0 == 4'b0110)
                                            begin //{
                                                merge_cs.link_resp_en = 1'b1;
                                            end //}  
                                            merge_cs.m_type = MERGED_CS;
                                            pktcs_proc_q.push_back(merge_cs);
                                        end //}   
                                        /*else if(stype0_temp == 4'b0110)
                                        begin //{ 
                                            pl_gencs_q.delete(i);
                                            merge_cs = new();
                                            merge_cs.brc3_merged_cs[0] = {2'b10,tranm_cs_ins.stype0,tranm_cs_ins.param0,tranm_cs_ins.param1,tranm_cs_ins.brc3_stype1_msb,2'b01,32'h0000_0000};
                                            merge_cs.brc3_merged_cs[1] = {2'b10,tranm_cs_ins.stype1,tranm_cs_ins.cmd,tranm_cs_ins.cs_crc24,2'b10,32'h0000_0000};
                                            if(stype1_temp == 8'h24)
                                            begin //{
                                               merge_cs.link_req_en = 1'b1;
                                            end //}
                                            else if(stype1_temp == 8'h18)
                                            begin //{
                                               merge_cs.rst_frm_rty_en = 1'b1;
                                            end //}
                                            if(tranm_cs_ins.stype0 == 4'b0110)
                                            begin //{
                                                merge_cs.link_resp_en = 1'b1;
                                            end //}
                                            merge_cs.m_type = MERGED_CS;
                                            pktcs_proc_q.push_back(merge_cs);
                                        end //}*/
                                        else if(stype0_temp == 4'b0110 || stype0_temp == 4'h0 || stype0_temp == 4'h1 || stype0_temp == 4'h2 || stype0_temp == 4'h4)
                                        begin //{
                                            pl_gencs_q.delete(i);
                                            tranm_cs_ins.cstype = CS64;
                                            tranm_cs_ins.stype1 = temp_ackid[0:2];
                                            tranm_cs_ins.cmd    = temp_ackid[3:5];
                                 //           tranm_cs_ins.brc3_stype1_msb = 2'b10;
	                                    if(temp1_data==32'h0 && begin_sop)
                                             tranm_cs_ins.brc3_stype1_msb = 2'b11;
                                            else 
                                             tranm_cs_ins.brc3_stype1_msb = 2'b10;
                                            begin_sop=1;
                                            tranm_cs_ins.cs_crc24 =  tranm_cs_ins.calccrc24(tranm_cs_ins.pack_cs());
                                            if(tranm_cs_ins.stype0 == 4'b0110)
                                            begin //{
                                                merge_cs.link_resp_en = 1'b1;
                                            end //}
                                            void'(tranm_cs_ins.pack_cs_bytes());
                                            break;
                                        end //}
                                     end //}
                                 end //}
                             else if(pl_seqcs_q.size() != 0)
                              begin //{
                                   for(int i=0;i<pl_seqcs_q.size();i++)
                                   begin //{
                                      tranm_cs_ins = new pl_seqcs_q[i];
                                      stype1_temp = {tranm_cs_ins.brc3_stype1_msb,tranm_cs_ins.stype1, tranm_cs_ins.cmd};
                                      stype0_temp =  tranm_cs_ins.stype0;
                                      if(stype1_temp == 8'h18 || stype1_temp == 8'h22 || stype1_temp == 8'h23 || stype1_temp == 8'h24 || stype1_temp == 8'h2B)
                                      begin //{
                                          pl_seqcs_q.delete(i);
                                          merge_cs = new();
                                          merge_cs.brc3_merged_cs[0] = {2'b10,tranm_cs_ins.stype0,tranm_cs_ins.param0,tranm_cs_ins.param1,tranm_cs_ins.brc3_stype1_msb,2'b01,32'h0000_0000};
                                          merge_cs.brc3_merged_cs[1] = {2'b10,tranm_cs_ins.stype1,tranm_cs_ins.cmd,tranm_cs_ins.cs_crc24,2'b10,32'h0000_0000};
                                          if(stype1_temp == 8'h24)
                                          begin //{
                                             merge_cs.link_req_en = 1'b1;
                                          end //}
                                          else if(stype1_temp == 8'h18)
                                          begin //{
                                             merge_cs.rst_frm_rty_en = 1'b1;
                                          end //}
                                          if(tranm_cs_ins.stype0 == 4'b0110)
                                          begin //{
                                              merge_cs.link_resp_en = 1'b1;
                                          end //}
                                          merge_cs.m_type = MERGED_CS;
                                          pktcs_proc_q.push_back(merge_cs);
                                      end //}
                                      /*else if(stype0_temp == 4'b0110)
                                      begin //{
                                          pl_seqcs_q.delete(i);
                                          merge_cs = new();
                                          merge_cs.brc3_merged_cs[0] = {2'b10,tranm_cs_ins.stype0,tranm_cs_ins.param0,tranm_cs_ins.param1,tranm_cs_ins.brc3_stype1_msb,2'b01,32'h0000_0000};
                                          merge_cs.brc3_merged_cs[1] = {2'b10,tranm_cs_ins.stype1,tranm_cs_ins.cmd,tranm_cs_ins.cs_crc24,2'b10,32'h0000_0000};
                                          if(stype1_temp == 8'h24)
                                          begin //{
                                             merge_cs.link_req_en = 1'b1;
                                          end //}
                                          else if(stype1_temp == 8'h18)
                                        begin //{
                                             merge_cs.rst_frm_rty_en = 1'b1;
                                          end //}
                                          if(tranm_cs_ins.stype0 == 4'b0110)
                                          begin //{
                                              merge_cs.link_resp_en = 1'b1;
                                          end //}
                                          merge_cs.m_type = MERGED_CS;
                                          pktcs_proc_q.push_back(merge_cs);
                                      end //}*/
                                      else if(stype0_temp == 4'h0 || stype0_temp == 4'h1 || stype0_temp == 4'h2 || stype0_temp == 4'h4 || stype0_temp == 4'b0110)
                                      begin //{
                                          pl_seqcs_q.delete(i);
                                          tranm_cs_ins.cstype = CS64;
                                          tranm_cs_ins.stype1 = temp_ackid[0:2];
                                          tranm_cs_ins.cmd    = temp_ackid[3:5];
	                                  if(temp1_data==32'h0 && begin_sop)
                                           tranm_cs_ins.brc3_stype1_msb = 2'b11;
                                          else 
                                           tranm_cs_ins.brc3_stype1_msb = 2'b10;
                                          begin_sop=1;
                                 //         tranm_cs_ins.brc3_stype1_msb = 2'b10;
                                          tranm_cs_ins.cs_crc24 =  tranm_cs_ins.calccrc24(tranm_cs_ins.pack_cs());
                                          if(tranm_cs_ins.stype0 == 4'b0110)
                                          begin //{
                                              merge_cs.link_resp_en = 1'b1;
                                          end //}
                                          void'(tranm_cs_ins.pack_cs_bytes());
                                          break;
                                      end //}
                                   end //}
                              end //}
                              else
                              begin //{
                                 tranm_cs_ins = new();

                                 tranm_cs_ins.cstype = CS64;
                                 tranm_cs_ins.stype1 = temp_ackid[0:2];
                                 tranm_cs_ins.cmd    = temp_ackid[3:5];
	                         if(temp1_data==32'h0 && begin_sop)
                                  tranm_cs_ins.brc3_stype1_msb = 2'b11;
                                 else 
                                  tranm_cs_ins.brc3_stype1_msb = 2'b10;
                                 begin_sop=1;
                                 tranm_cs_ins.stype0 = 4'b0100;
                                 //tranm_cs_ins.param0 =   pktm_trans.curr_rx_ackid; //pkt_handler_ins.ackid;
                                 tranm_cs_ins.param0 =   pktm_trans.ackid_for_scs; //pkt_handler_ins.ackid;
                                 if(pktm_config.multiple_ack_support)
                                  tranm_cs_ins.param0 = pktm_trans.gr_curr_tx_ackid;
                                 if(pktm_config.flow_control_mode == RECEIVE)
                                   tranm_cs_ins.param1 = 12'hFFF;
                                 else
                                 begin //{
                                   if(pktm_env_config.multi_vc_support == 1'b0)
                                     tranm_cs_ins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_q.size();
                                   else
                                     tranm_cs_ins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_vc0_q.size();
                                 end //}
                                 tranm_cs_ins.cs_crc24 =  tranm_cs_ins.calccrc24(tranm_cs_ins.pack_cs());
                                void'(tranm_cs_ins.pack_cs_bytes());
                              end //}
                              pl_outstanding_ackid_q.push_back(tranm_pkt_ins);
                              for(int i = 0;i<tranm_pkt_ins.bytestream.size();i++)
                              begin //{
                                  temp_pkt_q.push_back(tranm_pkt_ins.bytestream[i]);
                              end //}
                              for(int i =0;i<4;i++)
                              begin //{
                                  if(temp_pkt_q.size() != 0)
                                    temp_data[24:31] = temp_pkt_q.pop_front();
                                  if(i!=3)
                                    temp_data = temp_data << 8;
                              end //}
                              merge_rand3=$urandom_range(0,1);
                              if(merge_rand3)
                               begin//{ 
                                if(pl_gencs_q.size() != 0)
                                begin //{
                                     for(int i=0;i<pl_gencs_q.size();i++)
                                     begin //{
                                        tranm_csins = new pl_gencs_q[0];
                                        stype1_temp = {tranm_csins.brc3_stype1_msb,tranm_csins.stype1, tranm_csins.cmd};
                                        stype0_temp =  tranm_csins.stype0;
                                        if(stype1_temp == 8'h18 || stype1_temp == 8'h22 || stype1_temp == 8'h23 || stype1_temp == 8'h24 || stype1_temp == 8'h2B)
                                        begin //{
                                            pl_gencs_q.delete(0);
                                            merge_cs = new();
                                            merge_cs.brc3_merged_cs[0] = {2'b10,tranm_csins.stype0,tranm_csins.param0,tranm_csins.param1,tranm_csins.brc3_stype1_msb,2'b01,32'h0000_0000};
                                            merge_cs.brc3_merged_cs[1] = {2'b10,tranm_csins.stype1,tranm_csins.cmd,tranm_csins.cs_crc24,2'b10,32'h0000_0000};
                                            if(stype1_temp == 8'h24)
                                            begin //{
                                               merge_cs.link_req_en = 1'b1;
                                            end //}
                                            else if(stype1_temp == 8'h18)
                                            begin //{
                                               merge_cs.rst_frm_rty_en = 1'b1;
                                            end //}
                                            if(tranm_csins.stype0 == 4'b0110)
                                            begin //{
                                                merge_cs.link_resp_en = 1'b1;
                                            end //}
                                            merge_cs.m_type = MERGED_CS; 
                                            pktcs_proc_q.push_back(merge_cs);
                                        end //}   
                                        else if(stype0_temp == 4'h0 || stype0_temp == 4'h1 || stype0_temp == 4'h2 || stype0_temp == 4'h4 || stype0_temp == 4'b0110)
                                        begin //{
                                            embed_inc=1;
                                            pl_gencs_q.delete(0);
                                            tranm_csins.cstype = CS64;
                                            tranm_csins.cs_crc24 =  tranm_csins.calccrc24(tranm_csins.pack_cs());
                                            if(tranm_csins.stype0 == 4'b0110)
                                            begin //{
                                                merge_cs.link_resp_en = 1'b1;
                                            end //}
                                            void'(tranm_csins.pack_cs_bytes());  
                                            break;
                                        end //} 
                                     end //} 
                                end //} 
                                else if(pl_seqcs_q.size() != 0)
                                begin //{
                                     for(int i=0;i<pl_seqcs_q.size();i++)
                                     begin //{
                                        tranm_csins = new pl_seqcs_q[0];
                                        stype1_temp = {tranm_csins.brc3_stype1_msb,tranm_csins.stype1, tranm_csins.cmd};
                                        stype0_temp =  tranm_csins.stype0;
                                        if(stype1_temp == 8'h18 || stype1_temp == 8'h22 || stype1_temp == 8'h23 || stype1_temp == 8'h24 || stype1_temp == 8'h2B)
                                        begin //{
                                            pl_seqcs_q.delete(0);
                                            merge_cs = new();
                                            merge_cs.brc3_merged_cs[0] = {2'b10,tranm_csins.stype0,tranm_csins.param0,tranm_csins.param1,tranm_csins.brc3_stype1_msb,2'b01,32'h0000_0000};
                                            merge_cs.brc3_merged_cs[1] = {2'b10,tranm_csins.stype1,tranm_csins.cmd,tranm_csins.cs_crc24,2'b10,32'h0000_0000};
                                            if(stype1_temp == 8'h24)
                                            begin //{
                                               merge_cs.link_req_en = 1'b1;
                                            end //}
                                            else if(stype1_temp == 8'h18)
                                            begin //{
                                               merge_cs.rst_frm_rty_en = 1'b1;
                                            end //}
                                            if(tranm_csins.stype0 == 4'b0110)
                                            begin //{
                                                merge_cs.link_resp_en = 1'b1;
                                            end //}
                                            merge_cs.m_type = MERGED_CS; 
                                            pktcs_proc_q.push_back(merge_cs);
                                        end //}   
                                        else if(stype0_temp == 4'h0 || stype0_temp == 4'h1 || stype0_temp == 4'h2 || stype0_temp == 4'h4 || stype0_temp == 4'b0110)
                                        begin //{
                                            pl_seqcs_q.delete(0);
                                            embed_inc=1;
                                            tranm_csins.cstype = CS64;
                                            tranm_csins.cs_crc24 =  tranm_csins.calccrc24(tranm_csins.pack_cs());
                                            if(tranm_csins.stype0 == 4'b0110)
                                            begin //{
                                                merge_cs.link_resp_en = 1'b1;
                                            end //}
                                            void'(tranm_csins.pack_cs_bytes());  
                                            break;
                                        end //} 
                                     end //} 
                                end //} 
                              end//}
                              merge_rand1=$urandom_range(0,1);
                              if(merge_rand1==0 || merge_rand3==0 || embed_inc==0)
                               begin//{
                              merge_pkt.brc3_merged_pkt.push_back({2'b10,tranm_cs_ins.stype0,tranm_cs_ins.param0,tranm_cs_ins.param1,tranm_cs_ins.brc3_stype1_msb,2'b01,temp1_data});
                              merge_pkt.brc3_merged_pkt.push_back({2'b10,tranm_cs_ins.stype1,tranm_cs_ins.cmd,tranm_cs_ins.cs_crc24,2'b10,temp_data});
                               end//}
                              else if(embed_inc && merge_rand3)
                               begin//{
                                embed_inc=0;
                                merge_pkt.brc3_merged_pkt.push_back({2'b10,tranm_cs_ins.stype0,tranm_cs_ins.param0,tranm_cs_ins.param1,tranm_cs_ins.brc3_stype1_msb,2'b01,temp1_data});
                                merge_pkt.brc3_merged_pkt.push_back({2'b10,tranm_cs_ins.stype1,tranm_cs_ins.cmd,tranm_cs_ins.cs_crc24,2'b11,tranm_csins.stype0,tranm_csins.param0,tranm_csins.param1,tranm_csins.brc3_stype1_msb,2'b00});
                                merge_pkt.brc3_merged_pkt.push_back({2'b10,tranm_csins.stype1,tranm_csins.cmd,tranm_csins.cs_crc24,2'b10,temp_data});
                             end//} 
                              //merge_pkt.brc3_merged_pkt.push_back({2'b10,tranm_cs_ins.stype0,tranm_cs_ins.param0,tranm_cs_ins.param1,tranm_cs_ins.brc3_stype1_msb,2'b01,temp1_data});
                              //merge_pkt.brc3_merged_pkt.push_back({2'b10,tranm_cs_ins.stype1,tranm_cs_ins.cmd,tranm_cs_ins.cs_crc24,2'b10,temp_data});
                              temp1_data=32'h0;
                              temp_size = temp_pkt_q.size();
                              merge_rand2=$urandom_range(0,(temp_size/8-1));
                              for(int i = 0;i<temp_size/8;i++)
                              begin //{
                                   temp0 = temp_pkt_q.pop_front();
                                   temp1 = temp_pkt_q.pop_front();
                                   temp2 = temp_pkt_q.pop_front();
				   temp3 = temp_pkt_q.pop_front();
                                   temp4 = temp_pkt_q.pop_front();
                                   temp5 = temp_pkt_q.pop_front();
                                   temp6 = temp_pkt_q.pop_front();
                                   temp7 = temp_pkt_q.pop_front();
                             //      merge_pkt.brc3_merged_pkt.push_back({2'b01,temp0,temp1,temp2,temp3,temp4,temp5,temp6,temp7});
                                   if(merge_rand1==0 && embed_inc  && merge_rand2 ==i && merge_rand3)
                                    begin//{
                                     embed_inc=0;
                                     merge_pkt.brc3_merged_pkt.push_back({2'b10,tranm_csins.stype0,tranm_csins.param0,tranm_csins.param1,tranm_csins.brc3_stype1_msb,2'b01,temp0,temp1,temp2,temp3});                                     merge_pkt.brc3_merged_pkt.push_back({2'b10,tranm_csins.stype1,tranm_csins.cmd,tranm_csins.cs_crc24,2'b10,temp4,temp5,temp6,temp7});
                                    end//}
                                   else  
                                   merge_pkt.brc3_merged_pkt.push_back({2'b01,temp0,temp1,temp2,temp3,temp4,temp5,temp6,temp7});

                              end //}
                             if(temp_pkt_q.size() != 0)
                              begin//{
                               for(int i =0;i<4;i++)
                                begin //{
                                  if(temp_pkt_q.size() != 0)
                                    temp1_data[24:31] = temp_pkt_q.pop_front();
                                  if(i!=3)
                                    temp1_data = temp1_data << 8;
                                end //}
                               end //}
                              else
                               temp1_data=0;

                                 if(pl_pkt_q.size()!=0 && (merge_pkt.brc3_merged_pkt.size()<3000))
                                  continue;
                                 else
                                  begin//{
                                   if(pl_gencs_q.size() != 0)
                                    begin //{
                                         for(int i=0;i<pl_gencs_q.size();i++)
                                         begin //{
                                            tranm_csins = new pl_gencs_q[i];
                                            stype1_temp = {tranm_csins.brc3_stype1_msb,tranm_csins.stype1, tranm_csins.cmd};
                                            stype0_temp =  tranm_csins.stype0;
                                            if(stype1_temp == 8'h18 || stype1_temp == 8'h22 || stype1_temp == 8'h23 || stype1_temp == 8'h24 || stype1_temp == 8'h2B)
                                            begin //{
                                                pl_gencs_q.delete(i);
                                                merge_cs = new();
                                                merge_cs.brc3_merged_cs[0] = {2'b10,tranm_csins.stype0,tranm_csins.param0,tranm_csins.param1,tranm_csins.brc3_stype1_msb,2'b01,32'h0000_0000};
                                                merge_cs.brc3_merged_cs[1] = {2'b10,tranm_csins.stype1,tranm_csins.cmd,tranm_csins.cs_crc24,2'b10,32'h0000_0000};
                                                if(stype1_temp == 8'h24)
                                                begin //{
                                                   merge_cs.link_req_en = 1'b1;
                                                end //}
                                                else if(stype1_temp == 8'h18)
                                                begin //{
                                                   merge_cs.rst_frm_rty_en = 1'b1;
                                                end //}
                                                if(tranm_csins.stype0 == 4'b0110)
                                                begin //{
                                                    merge_cs.link_resp_en = 1'b1;
                                                end //}
                                                merge_cs.m_type = MERGED_CS;
                                                pktcs_proc_q.push_back(merge_cs);
                                            end //}
                                            /*else if(stype0_temp == 4'b0110)
                                            begin //{
                                                pl_gencs_q.delete(i);
                                                merge_cs = new();
                                                merge_cs.brc3_merged_cs[0] = {2'b10,tranm_csins.stype0,tranm_csins.param0,tranm_csins.param1,tranm_csins.brc3_stype1_msb,2'b01,32'h0000_0000};
                                                merge_cs.brc3_merged_cs[1] = {2'b10,tranm_csins.stype1,tranm_csins.cmd,tranm_csins.cs_crc24,2'b10,32'h0000_0000};
                                                if(stype1_temp == 8'h24)
                                                begin //{
                                                  merge_cs.link_req_en = 1'b1;
                                                end //}
                                                else if(stype1_temp == 8'h18)
                                                begin //{
                                                   merge_cs.rst_frm_rty_en = 1'b1;
                                                end //}
                                                if(tranm_csins.stype0 == 4'b0110)
                                                begin //{
                                                    merge_cs.link_resp_en = 1'b1;
                                                end //}
                                                merge_cs.m_type = MERGED_CS;
                                                pktcs_proc_q.push_back(merge_cs);
                                            end //}*/
                                            else if(stype0_temp == 4'h0 || stype0_temp == 4'h1 || stype0_temp == 4'h2 || stype0_temp == 4'h4 || stype0_temp == 4'b0110)
                                            begin //{
                                                pl_gencs_q.delete(i);
                                                tranm_csins.cstype = CS64;
                                                if(temp1_data == 32'h00000000)
                                                begin //{
                                                   tranm_csins.stype1 = 3'b010;
                                                   tranm_csins.cmd    = 3'b001;
                                                   tranm_csins.brc3_stype1_msb = 2'b00;
                                                end //}
                                                else
                                                begin //{
                                                   tranm_csins.stype1 = 3'b010;
                                                   tranm_csins.cmd    = 3'b000;
                                                   tranm_csins.brc3_stype1_msb = 2'b00;
                                                end //}
                                                if(tranm_csins.stype0 == 4'b0110)
                                                begin //{
                                                    merge_cs.link_resp_en = 1'b1;
                                                end //}
                                                tranm_csins.cs_crc24 =  tranm_csins.calccrc24(tranm_csins.pack_cs());
                                                void'(tranm_csins.pack_cs_bytes());
                                                break;
                                            end //}
                                         end //}
                                    end //}
                                    else if(pl_seqcs_q.size() != 0)
                                    begin //{
                                         for(int i=0;i<pl_seqcs_q.size();i++)
                                         begin //{
                                            tranm_csins = new pl_seqcs_q[i];
                                            stype1_temp = {tranm_csins.brc3_stype1_msb,tranm_csins.stype1, tranm_csins.cmd};
                                            stype0_temp =  tranm_csins.stype0;
                                            if(stype1_temp == 8'h18 || stype1_temp == 8'h22 || stype1_temp == 8'h23 || stype1_temp == 8'h24 || stype1_temp == 8'h2B)
                                            begin //{
                                                pl_seqcs_q.delete(i);
                                                merge_cs = new();
                                                merge_cs.brc3_merged_cs[0] = {2'b10,tranm_csins.stype0,tranm_csins.param0,tranm_csins.param1,tranm_csins.brc3_stype1_msb,2'b01,32'h0000_0000};
                                                merge_cs.brc3_merged_cs[1] = {2'b10,tranm_csins.stype1,tranm_csins.cmd,tranm_csins.cs_crc24,2'b10,32'h0000_0000};
                                                if(stype1_temp == 8'h24)
                                                begin //{
                                                   merge_cs.link_req_en = 1'b1;
                                                end //}
                                                else if(stype1_temp == 8'h18)
                                                begin //{
                                                   merge_cs.rst_frm_rty_en = 1'b1;
                                                end //}
                                                if(tranm_csins.stype0 == 4'b0110)
                                                begin //{
                                                    merge_cs.link_resp_en = 1'b1;
                                                end //}
                                                merge_cs.m_type = MERGED_CS;
                                                pktcs_proc_q.push_back(merge_cs);
                                            end //}
                                            /*else if(stype0_temp == 4'b0110)
                                            begin //{
                                                pl_seqcs_q.delete(i);
                                                merge_cs = new();
                                                merge_cs.brc3_merged_cs[0] = {2'b10,tranm_csins.stype0,tranm_csins.param0,tranm_csins.param1,tranm_csins.brc3_stype1_msb,2'b01,32'h0000_0000};
                                                merge_cs.brc3_merged_cs[1] = {2'b10,tranm_csins.stype1,tranm_csins.cmd,tranm_csins.cs_crc24,2'b10,32'h0000_0000};
                                                if(stype1_temp == 8'h24)
                                                begin //{
                                                   merge_cs.link_req_en = 1'b1;
                                                end //}
                                                else if(stype1_temp == 8'h18)
                                                begin //{
                                                  merge_cs.rst_frm_rty_en = 1'b1;
                                                end //}
                                                if(tranm_csins.stype0 == 4'b0110)
                                                begin //{
                                                    merge_cs.link_resp_en = 1'b1;
                                                end //}
                                                merge_cs.m_type = MERGED_CS;
                                                pktcs_proc_q.push_back(merge_cs);
                                            end //}*/
                                            else if(stype0_temp == 4'h0 || stype0_temp == 4'h1 || stype0_temp == 4'h2 || stype0_temp == 4'h4 || stype0_temp==4'h6)
                                            begin //{
                                                pl_seqcs_q.delete(i);
                                                tranm_csins.cstype = CS64;
                                                if(temp1_data == 32'h00000000)
                                                begin //{
                                                   tranm_csins.stype1 = 3'b010;
                                                   tranm_csins.cmd    = 3'b001;
                                                   tranm_csins.brc3_stype1_msb = 2'b00;
                                                end //}
                                                else
                                                begin //{
                                                   tranm_csins.stype1 = 3'b010;
                                                   tranm_csins.cmd    = 3'b000;
                                                   tranm_csins.brc3_stype1_msb = 2'b00;
                                                end //}
                                                if(tranm_csins.stype0 == 4'b0110)
                                                begin //{
                                                    merge_cs.link_resp_en = 1'b1;
                                                end //}
                                                tranm_csins.cs_crc24 =  tranm_csins.calccrc24(tranm_csins.pack_cs());
                                                void'(tranm_csins.pack_cs_bytes());
                                                break;
                                            end //}
                                         end //}
                                    end //}
                                    else
                                    begin //{
                                      tranm_csins = new();
                                      tranm_csins.cstype = CS64;
                                      if(temp1_data == 32'h00000000)
                                      begin //{
                                         tranm_csins.stype1 = 3'b010;
                                         tranm_csins.cmd    = 3'b001;
                                         tranm_csins.brc3_stype1_msb = 2'b00;
                                      end //}
                                     else
                                      begin //{
                                         tranm_csins.stype1 = 3'b010;
                                         tranm_csins.cmd    = 3'b000;
                                         tranm_csins.brc3_stype1_msb = 2'b00;
                                      end //}
                                      tranm_csins.stype0 = 4'b0100;
                                      //tranm_csins.param0 =   pktm_trans.curr_rx_ackid;
                                      tranm_csins.param0 =   pktm_trans.ackid_for_scs; //pkt_handler_ins.ackid;
                                      if(pktm_config.multiple_ack_support)
                                       tranm_csins.param0 = pktm_trans.gr_curr_tx_ackid;

                                      if(pktm_config.flow_control_mode == RECEIVE)
                                        tranm_csins.param1 = 12'hFFF;
                                      else
                                      begin //{
                                        if(pktm_env_config.multi_vc_support == 1'b0)
                                          tranm_csins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_q.size();
                                        else
                                          tranm_csins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_vc0_q.size();
                                      end //}
                                      tranm_csins.cs_crc24 =  tranm_csins.calccrc24(tranm_csins.pack_cs());
                                      void'(tranm_csins.pack_cs_bytes());
                                    end //}
                              merge_rand3=$urandom_range(0,1);
                              if(merge_rand3)
                               begin//{ 
                                if(pl_gencs_q.size() != 0)
                                begin //{
                                     for(int i=0;i<pl_gencs_q.size();i++)
                                     begin //{
                                        tranm_cs_ins = new pl_gencs_q[0];
                                        stype1_temp = {tranm_cs_ins.brc3_stype1_msb,tranm_cs_ins.stype1, tranm_cs_ins.cmd};
                                        stype0_temp =  tranm_cs_ins.stype0;
                                        if(stype1_temp == 8'h18 || stype1_temp == 8'h22 || stype1_temp == 8'h23 || stype1_temp == 8'h24 || stype1_temp == 8'h2B)
                                        begin //{
                                            pl_gencs_q.delete(0);
                                            merge_cs = new();
                                            merge_cs.brc3_merged_cs[0] = {2'b10,tranm_cs_ins.stype0,tranm_cs_ins.param0,tranm_cs_ins.param1,tranm_cs_ins.brc3_stype1_msb,2'b01,32'h0000_0000};
                                            merge_cs.brc3_merged_cs[1] = {2'b10,tranm_cs_ins.stype1,tranm_cs_ins.cmd,tranm_cs_ins.cs_crc24,2'b10,32'h0000_0000};
                                            if(stype1_temp == 8'h24)
                                            begin //{
                                               merge_cs.link_req_en = 1'b1;
                                            end //}
                                            else if(stype1_temp == 8'h18)
                                            begin //{
                                               merge_cs.rst_frm_rty_en = 1'b1;
                                            end //}
                                            if(tranm_cs_ins.stype0 == 4'b0110)
                                            begin //{
                                                merge_cs.link_resp_en = 1'b1;
                                            end //}
                                            merge_cs.m_type = MERGED_CS; 
                                            pktcs_proc_q.push_back(merge_cs);
                                        end //}   
                                        else if(stype0_temp == 4'h0 || stype0_temp == 4'h1 || stype0_temp == 4'h2 || stype0_temp == 4'h4 || stype0_temp == 4'b0110)
                                        begin //{
                                            embed_inc=1;
                                            pl_gencs_q.delete(0);
                                            tranm_cs_ins.cstype = CS64;
                                            tranm_cs_ins.cs_crc24 =  tranm_cs_ins.calccrc24(tranm_cs_ins.pack_cs());
                                            if(tranm_cs_ins.stype0 == 4'b0110)
                                            begin //{
                                                merge_cs.link_resp_en = 1'b1;
                                            end //}
                                            void'(tranm_cs_ins.pack_cs_bytes());  
                                            break;
                                        end //} 
                                     end //} 
                                end //} 
                                else if(pl_seqcs_q.size() != 0)
                                begin //{
                                     for(int i=0;i<pl_seqcs_q.size();i++)
                                     begin //{
                                        tranm_cs_ins = new pl_seqcs_q[0];
                                        stype1_temp = {tranm_cs_ins.brc3_stype1_msb,tranm_cs_ins.stype1, tranm_cs_ins.cmd};
                                        stype0_temp =  tranm_cs_ins.stype0;
                                        if(stype1_temp == 8'h18 || stype1_temp == 8'h22 || stype1_temp == 8'h23 || stype1_temp == 8'h24 || stype1_temp == 8'h2B)
                                        begin //{
                                            pl_seqcs_q.delete(0);
                                            merge_cs = new();
                                            merge_cs.brc3_merged_cs[0] = {2'b10,tranm_cs_ins.stype0,tranm_cs_ins.param0,tranm_cs_ins.param1,tranm_cs_ins.brc3_stype1_msb,2'b01,32'h0000_0000};
                                            merge_cs.brc3_merged_cs[1] = {2'b10,tranm_cs_ins.stype1,tranm_cs_ins.cmd,tranm_cs_ins.cs_crc24,2'b10,32'h0000_0000};
                                            if(stype1_temp == 8'h24)
                                            begin //{
                                               merge_cs.link_req_en = 1'b1;
                                            end //}
                                            else if(stype1_temp == 8'h18)
                                            begin //{
                                               merge_cs.rst_frm_rty_en = 1'b1;
                                            end //}
                                            if(tranm_cs_ins.stype0 == 4'b0110)
                                            begin //{
                                                merge_cs.link_resp_en = 1'b1;
                                            end //}
                                            merge_cs.m_type = MERGED_CS; 
                                            pktcs_proc_q.push_back(merge_cs);
                                        end //}   
                                        else if(stype0_temp == 4'h0 || stype0_temp == 4'h1 || stype0_temp == 4'h2 || stype0_temp == 4'h4 || stype0_temp == 4'b0110)
                                        begin //{
                                            pl_seqcs_q.delete(0);
                                            embed_inc=1;
                                            tranm_cs_ins.cstype = CS64;
                                            tranm_cs_ins.cs_crc24 =  tranm_cs_ins.calccrc24(tranm_cs_ins.pack_cs());
                                            if(tranm_cs_ins.stype0 == 4'b0110)
                                            begin //{
                                                merge_cs.link_resp_en = 1'b1;
                                            end //}
                                            void'(tranm_cs_ins.pack_cs_bytes());  
                                            break;
                                        end //} 
                                     end //} 
                                end //} 
                              end//}
                              if(embed_inc)
                               begin//{
                                embed_inc=0;
                                merge_pkt.brc3_merged_pkt.push_back({2'b10,tranm_csins.stype0,tranm_csins.param0,tranm_csins.param1,tranm_csins.brc3_stype1_msb,2'b01,temp1_data});
                                merge_pkt.brc3_merged_pkt.push_back({2'b10,tranm_csins.stype1,tranm_csins.cmd,tranm_csins.cs_crc24,2'b11,tranm_cs_ins.stype0,tranm_cs_ins.param0,tranm_cs_ins.param1,tranm_cs_ins.brc3_stype1_msb,2'b00});
                                merge_pkt.brc3_merged_pkt.push_back({2'b10,tranm_cs_ins.stype1,tranm_cs_ins.cmd,tranm_cs_ins.cs_crc24,2'b10,32'h0000_0000});
                               end//}
                              else
                               begin//{
                                merge_pkt.brc3_merged_pkt.push_back({2'b10,tranm_csins.stype0,tranm_csins.param0,tranm_csins.param1,tranm_csins.brc3_stype1_msb,2'b01,temp1_data});
                              merge_pkt.brc3_merged_pkt.push_back({2'b10,tranm_csins.stype1,tranm_csins.cmd,tranm_csins.cs_crc24,2'b10,32'h0000_0000});
                               end//}
                              //merge_pkt.brc3_merged_pkt.push_back({2'b10,tranm_csins.stype0,tranm_csins.param0,tranm_csins.param1,tranm_csins.brc3_stype1_msb,2'b01,temp1_data});
                              //merge_pkt.brc3_merged_pkt.push_back({2'b10,tranm_csins.stype1,tranm_csins.cmd,tranm_csins.cs_crc24,2'b10,32'h0000_0000});
                              temp1_data=32'h0;
                              merge_pkt.m_type = MERGED_PKT;
                              pktcs_proc_q.push_back(merge_pkt);
                              begin_sop=0;
                              if(!(merge_pkt.brc3_merged_pkt.size()<3000)) 
                               break;
                                  end //}
                              end//}
                         end //}
                        else if(pl_pkt_q.size() != 0 && pktm_trans.link_initialized && ~pktm_trans.oes_state && ~pktm_trans.ors_state && pkt_avail_req_g3 && pl_outstanding_ackid_q.size() < ackid_qsize) 
                         begin //{
//When link is initialized and packet is available for transmission check if any of the available control symbols can be merged together , if possible 
//merge those control symbols and place in the queue as MERGED_CS and delimited packets as MERGED_PKT
// Both the control symbols which are input from the sequencer and those generated by the BFM will be considered
// Packets and control symbols to be transmitted during normal and error state will be placed into the queue in the different states
// Control symbols such as link request etc which cannot be merged will be placed into the queue seperately nad not merged with any other transaction
                              tranm_pkt_ins  = new pl_pkt_q.pop_front();
                              temp_ackid     = tranm_pkt_ins.ackid;
                              if(pl_gencs_q.size() != 0)
                              begin //{
                                   for(int i=0;i<pl_gencs_q.size();i++)
                                   begin //{
                                      tranm_cs_ins = new pl_gencs_q[i];
                                      stype1_temp = {tranm_cs_ins.brc3_stype1_msb,tranm_cs_ins.stype1, tranm_cs_ins.cmd};
                                      stype0_temp =  tranm_cs_ins.stype0;
                                      if(stype1_temp == 8'h18 || stype1_temp == 8'h22 || stype1_temp == 8'h23 || stype1_temp == 8'h24 || stype1_temp == 8'h2B)
                                      begin //{
                                          pl_gencs_q.delete(i);
                                          merge_cs = new();
                                          merge_cs.brc3_merged_cs[0] = {2'b10,tranm_cs_ins.stype0,tranm_cs_ins.param0,tranm_cs_ins.param1,tranm_cs_ins.brc3_stype1_msb,2'b01,32'h0000_0000};
                                          merge_cs.brc3_merged_cs[1] = {2'b10,tranm_cs_ins.stype1,tranm_cs_ins.cmd,tranm_cs_ins.cs_crc24,2'b10,32'h0000_0000};
                                          if(stype1_temp == 8'h24)
                                          begin //{
                                             merge_cs.link_req_en = 1'b1;
                                          end //}
                                          else if(stype1_temp == 8'h18)
                                          begin //{
                                             merge_cs.rst_frm_rty_en = 1'b1;
                                          end //}
                                          if(tranm_cs_ins.stype0 == 4'b0110)
                                          begin //{
                                              merge_cs.link_resp_en = 1'b1;
                                          end //}
                                          merge_cs.m_type = MERGED_CS; 
                                          pktcs_proc_q.push_back(merge_cs);
                                      end //}   
                                      /*else if(stype0_temp == 4'b0110)
                                      begin //{
                                          pl_gencs_q.delete(i);
                                          merge_cs = new();
                                          merge_cs.brc3_merged_cs[0] = {2'b10,tranm_cs_ins.stype0,tranm_cs_ins.param0,tranm_cs_ins.param1,tranm_cs_ins.brc3_stype1_msb,2'b01,32'h0000_0000};
                                          merge_cs.brc3_merged_cs[1] = {2'b10,tranm_cs_ins.stype1,tranm_cs_ins.cmd,tranm_cs_ins.cs_crc24,2'b10,32'h0000_0000};
                                          if(stype1_temp == 8'h24)
                                          begin //{
                                             merge_cs.link_req_en = 1'b1;
                                          end //}
                                          else if(stype1_temp == 8'h18)
                                          begin //{
                                             merge_cs.rst_frm_rty_en = 1'b1;
                                          end //}
                                          if(tranm_cs_ins.stype0 == 4'b0110)
                                          begin //{
                                              merge_cs.link_resp_en = 1'b1;
                                          end //}
                                          merge_cs.m_type = MERGED_CS; 
                                          pktcs_proc_q.push_back(merge_cs);
                                      end //} */
                                      else if(stype0_temp == 4'h0 || stype0_temp == 4'h1 || stype0_temp == 4'h2 || stype0_temp == 4'h4 || stype0_temp == 4'b0110)
                                      begin //{
                                          pl_gencs_q.delete(i);
                                          tranm_cs_ins.cstype = CS64;
                                          tranm_cs_ins.stype1 = temp_ackid[0:2];
                                          tranm_cs_ins.cmd    = temp_ackid[3:5];
                                          tranm_cs_ins.brc3_stype1_msb = 2'b10;
                                          tranm_cs_ins.cs_crc24 =  tranm_cs_ins.calccrc24(tranm_cs_ins.pack_cs());
                                          if(tranm_cs_ins.stype0 == 4'b0110)
                                          begin //{
                                              merge_cs.link_resp_en = 1'b1;
                                          end //}
                                          void'(tranm_cs_ins.pack_cs_bytes());  
                                          break;
                                      end //} 
                                   end //} 
                              end //} 
                              else if(pl_seqcs_q.size() != 0)
                              begin //{
                                   for(int i=0;i<pl_seqcs_q.size();i++)
                                   begin //{
                                      tranm_cs_ins = new pl_seqcs_q[i];
                                      stype1_temp = {tranm_cs_ins.brc3_stype1_msb,tranm_cs_ins.stype1, tranm_cs_ins.cmd};
                                      stype0_temp =  tranm_cs_ins.stype0;
                                      if(stype1_temp == 8'h18 || stype1_temp == 8'h22 || stype1_temp == 8'h23 || stype1_temp == 8'h24 || stype1_temp == 8'h2B)
                                      begin //{
                                          pl_seqcs_q.delete(i);
                                          merge_cs = new();
                                          merge_cs.brc3_merged_cs[0] = {2'b10,tranm_cs_ins.stype0,tranm_cs_ins.param0,tranm_cs_ins.param1,tranm_cs_ins.brc3_stype1_msb,2'b01,32'h0000_0000};
                                          merge_cs.brc3_merged_cs[1] = {2'b10,tranm_cs_ins.stype1,tranm_cs_ins.cmd,tranm_cs_ins.cs_crc24,2'b10,32'h0000_0000};
                                          if(stype1_temp == 8'h24)
                                          begin //{
                                             merge_cs.link_req_en = 1'b1;
                                          end //}
                                          else if(stype1_temp == 8'h18)
                                          begin //{
                                             merge_cs.rst_frm_rty_en = 1'b1;
                                          end //}
                                          if(tranm_cs_ins.stype0 == 4'b0110)
                                          begin //{
                                              merge_cs.link_resp_en = 1'b1;
                                          end //}
                                          merge_cs.m_type = MERGED_CS; 
                                          pktcs_proc_q.push_back(merge_cs);
                                      end //}   
                                      /*else if(stype0_temp == 4'b0110)
                                      begin //{
                                          pl_seqcs_q.delete(i);
                                          merge_cs = new();
                                          merge_cs.brc3_merged_cs[0] = {2'b10,tranm_cs_ins.stype0,tranm_cs_ins.param0,tranm_cs_ins.param1,tranm_cs_ins.brc3_stype1_msb,2'b01,32'h0000_0000};
                                          merge_cs.brc3_merged_cs[1] = {2'b10,tranm_cs_ins.stype1,tranm_cs_ins.cmd,tranm_cs_ins.cs_crc24,2'b10,32'h0000_0000};
                                          if(stype1_temp == 8'h24)
                                          begin //{
                                             merge_cs.link_req_en = 1'b1;
                                          end //}
                                          else if(stype1_temp == 8'h18)
                                          begin //{
                                             merge_cs.rst_frm_rty_en = 1'b1;
                                          end //}
                                          if(tranm_cs_ins.stype0 == 4'b0110)
                                          begin //{
                                              merge_cs.link_resp_en = 1'b1;
                                          end //}
                                          merge_cs.m_type = MERGED_CS; 
                                          pktcs_proc_q.push_back(merge_cs);
                                      end //}*/ 
                                      else if(stype0_temp == 4'h0 || stype0_temp == 4'h1 || stype0_temp == 4'h2 || stype0_temp == 4'h4 || stype0_temp == 4'b0110)
                                      begin //{
                                          pl_seqcs_q.delete(i);
                                          tranm_cs_ins.cstype = CS64;
                                          tranm_cs_ins.stype1 = temp_ackid[0:2];
                                          tranm_cs_ins.cmd    = temp_ackid[3:5];
                                          tranm_cs_ins.brc3_stype1_msb = 2'b10;
                                          tranm_cs_ins.cs_crc24 =  tranm_cs_ins.calccrc24(tranm_cs_ins.pack_cs());
                                          if(tranm_cs_ins.stype0 == 4'b0110)
                                          begin //{
                                              merge_cs.link_resp_en = 1'b1;
                                          end //}
                                          void'(tranm_cs_ins.pack_cs_bytes());  
                                          break;
                                      end //} 
                                   end //} 
                              end //} 
                              else
                              begin //{
                                 tranm_cs_ins = new();

                                 tranm_cs_ins.cstype = CS64;
                                 tranm_cs_ins.stype1 = temp_ackid[0:2];
                                 tranm_cs_ins.cmd    = temp_ackid[3:5];
                                 tranm_cs_ins.brc3_stype1_msb = 2'b10;
                                 tranm_cs_ins.stype0 = 4'b0100;
                                 //tranm_cs_ins.param0 =   pktm_trans.curr_rx_ackid; //pkt_handler_ins.ackid;
                                 tranm_cs_ins.param0 =   pktm_trans.ackid_for_scs; //pkt_handler_ins.ackid;
                                 if(pktm_config.multiple_ack_support)
                                  tranm_cs_ins.param0 = pktm_trans.gr_curr_tx_ackid;
                                 if(pktm_config.flow_control_mode == RECEIVE)
                                   tranm_cs_ins.param1 = 12'hFFF;
                                 else
                                 begin //{
                                   if(pktm_env_config.multi_vc_support == 1'b0)
                                     tranm_cs_ins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_q.size();
                                   else
                                     tranm_cs_ins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_vc0_q.size();
                                 end //}
                                 tranm_cs_ins.cs_crc24 =  tranm_cs_ins.calccrc24(tranm_cs_ins.pack_cs());
                                 void'(tranm_cs_ins.pack_cs_bytes());  
                              end //} 
                              merge_pkt = new();
                              pl_outstanding_ackid_q.push_back(tranm_pkt_ins);
                              for(int i = 0;i<tranm_pkt_ins.bytestream.size();i++)
                              begin //{
                                  temp_pkt_q.push_back(tranm_pkt_ins.bytestream[i]);
                              end //}
                              for(int i =0;i<4;i++)
                              begin //{
                                  if(temp_pkt_q.size() != 0)
                                    temp_data[24:31] = temp_pkt_q.pop_front(); 
                                  if(i!=3)
                                    temp_data = temp_data << 8;
                              end //}
                              merge_rand3=$urandom_range(0,1);
                              if(merge_rand3)
                               begin//{ 
                                if(pl_gencs_q.size() != 0)
                                begin //{
                                     for(int i=0;i<pl_gencs_q.size();i++)
                                     begin //{
                                        tranm_csins = new pl_gencs_q[0];
                                        stype1_temp = {tranm_csins.brc3_stype1_msb,tranm_csins.stype1, tranm_csins.cmd};
                                        stype0_temp =  tranm_csins.stype0;
                                        if(stype1_temp == 8'h18 || stype1_temp == 8'h22 || stype1_temp == 8'h23 || stype1_temp == 8'h24 || stype1_temp == 8'h2B)
                                        begin //{
                                            pl_gencs_q.delete(0);
                                            merge_cs = new();
                                            merge_cs.brc3_merged_cs[0] = {2'b10,tranm_csins.stype0,tranm_csins.param0,tranm_csins.param1,tranm_csins.brc3_stype1_msb,2'b01,32'h0000_0000};
                                            merge_cs.brc3_merged_cs[1] = {2'b10,tranm_csins.stype1,tranm_csins.cmd,tranm_csins.cs_crc24,2'b10,32'h0000_0000};
                                            if(stype1_temp == 8'h24)
                                            begin //{
                                               merge_cs.link_req_en = 1'b1;
                                            end //}
                                            else if(stype1_temp == 8'h18)
                                            begin //{
                                               merge_cs.rst_frm_rty_en = 1'b1;
                                            end //}
                                            if(tranm_csins.stype0 == 4'b0110)
                                            begin //{
                                                merge_cs.link_resp_en = 1'b1;
                                            end //}
                                            merge_cs.m_type = MERGED_CS; 
                                            pktcs_proc_q.push_back(merge_cs);
                                        end //}   
                                        else if(stype0_temp == 4'h0 || stype0_temp == 4'h1 || stype0_temp == 4'h2 || stype0_temp == 4'h4 || stype0_temp == 4'b0110)
                                        begin //{
                                            embed_inc=1;
                                            pl_gencs_q.delete(0);
                                            tranm_csins.cstype = CS64;
                                            tranm_csins.cs_crc24 =  tranm_csins.calccrc24(tranm_csins.pack_cs());
                                            if(tranm_csins.stype0 == 4'b0110)
                                            begin //{
                                                merge_cs.link_resp_en = 1'b1;
                                            end //}
                                            void'(tranm_csins.pack_cs_bytes());  
                                            break;
                                        end //} 
                                     end //} 
                                end //} 
                                else if(pl_seqcs_q.size() != 0)
                                begin //{
                                     for(int i=0;i<pl_seqcs_q.size();i++)
                                     begin //{
                                        tranm_csins = new pl_seqcs_q[0];
                                        stype1_temp = {tranm_csins.brc3_stype1_msb,tranm_csins.stype1, tranm_csins.cmd};
                                        stype0_temp =  tranm_csins.stype0;
                                        if(stype1_temp == 8'h18 || stype1_temp == 8'h22 || stype1_temp == 8'h23 || stype1_temp == 8'h24 || stype1_temp == 8'h2B)
                                        begin //{
                                            pl_seqcs_q.delete(0);
                                            merge_cs = new();
                                            merge_cs.brc3_merged_cs[0] = {2'b10,tranm_csins.stype0,tranm_csins.param0,tranm_csins.param1,tranm_csins.brc3_stype1_msb,2'b01,32'h0000_0000};
                                            merge_cs.brc3_merged_cs[1] = {2'b10,tranm_csins.stype1,tranm_csins.cmd,tranm_csins.cs_crc24,2'b10,32'h0000_0000};
                                            if(stype1_temp == 8'h24)
                                            begin //{
                                               merge_cs.link_req_en = 1'b1;
                                            end //}
                                            else if(stype1_temp == 8'h18)
                                            begin //{
                                               merge_cs.rst_frm_rty_en = 1'b1;
                                            end //}
                                            if(tranm_csins.stype0 == 4'b0110)
                                            begin //{
                                                merge_cs.link_resp_en = 1'b1;
                                            end //}
                                            merge_cs.m_type = MERGED_CS; 
                                            pktcs_proc_q.push_back(merge_cs);
                                        end //}   
                                        else if(stype0_temp == 4'h0 || stype0_temp == 4'h1 || stype0_temp == 4'h2 || stype0_temp == 4'h4 || stype0_temp == 4'b0110)
                                        begin //{
                                            pl_seqcs_q.delete(0);
                                            embed_inc=1;
                                            tranm_csins.cstype = CS64;
                                            tranm_csins.cs_crc24 =  tranm_csins.calccrc24(tranm_csins.pack_cs());
                                            if(tranm_csins.stype0 == 4'b0110)
                                            begin //{
                                                merge_cs.link_resp_en = 1'b1;
                                            end //}
                                            void'(tranm_csins.pack_cs_bytes());  
                                            break;
                                        end //} 
                                     end //} 
                                end //} 
                              end//}
                              merge_rand1=$urandom_range(0,1);
                              if(merge_rand1==0 || merge_rand3==0 || embed_inc==0)
                               begin//{
                              merge_pkt.brc3_merged_pkt[0] = {2'b10,tranm_cs_ins.stype0,tranm_cs_ins.param0,tranm_cs_ins.param1,tranm_cs_ins.brc3_stype1_msb,2'b01,32'h0000_0000};
                              merge_pkt.brc3_merged_pkt[1] = {2'b10,tranm_cs_ins.stype1,tranm_cs_ins.cmd,tranm_cs_ins.cs_crc24,2'b10,temp_data};
                               end//}
                              else if(embed_inc && merge_rand3)
                               begin//{
                                embed_inc=0;
                                merge_pkt.brc3_merged_pkt[0] = {2'b10,tranm_cs_ins.stype0,tranm_cs_ins.param0,tranm_cs_ins.param1,tranm_cs_ins.brc3_stype1_msb,2'b01,32'h0000_0000};
                                merge_pkt.brc3_merged_pkt[1] = {2'b10,tranm_cs_ins.stype1,tranm_cs_ins.cmd,tranm_cs_ins.cs_crc24,2'b11,tranm_csins.stype0,tranm_csins.param0,tranm_csins.param1,tranm_csins.brc3_stype1_msb,2'b00};
                                merge_pkt.brc3_merged_pkt[2] = {2'b10,tranm_csins.stype1,tranm_csins.cmd,tranm_csins.cs_crc24,2'b10,temp_data};
                               end//}
                              temp_size = temp_pkt_q.size();
                              merge_rand2=$urandom_range(0,(temp_size/8-1));
                              for(int i = 0;i<temp_size/8;i++)
                              begin //{
                                   temp0 = temp_pkt_q.pop_front();
                                   temp1 = temp_pkt_q.pop_front();
                                   temp2 = temp_pkt_q.pop_front();
                                   temp3 = temp_pkt_q.pop_front();
                                   temp4 = temp_pkt_q.pop_front();
                                   temp5 = temp_pkt_q.pop_front();
                                   temp6 = temp_pkt_q.pop_front();
                                   temp7 = temp_pkt_q.pop_front();
                                   if(merge_rand1==0 && embed_inc  && merge_rand2 ==i && merge_rand3)
                                    begin//{
                                     embed_inc=0;
                                     merge_pkt.brc3_merged_pkt.push_back({2'b10,tranm_csins.stype0,tranm_csins.param0,tranm_csins.param1,tranm_csins.brc3_stype1_msb,2'b01,temp0,temp1,temp2,temp3});
                                     merge_pkt.brc3_merged_pkt.push_back({2'b10,tranm_csins.stype1,tranm_csins.cmd,tranm_csins.cs_crc24,2'b10,temp4,temp5,temp6,temp7});
                                    end//}
                                   else 
                                   merge_pkt.brc3_merged_pkt.push_back({2'b01,temp0,temp1,temp2,temp3,temp4,temp5,temp6,temp7});
                              end //}
                              for(int i =0;i<4;i++)
                              begin //{
                                  if(temp_pkt_q.size() != 0)
                                    temp_data[24:31] = temp_pkt_q.pop_front(); 
                                  if(i!=3)
                                    temp_data = temp_data << 8;
                              end //}
                              if(pl_gencs_q.size() != 0)
                              begin //{
                                   for(int i=0;i<pl_gencs_q.size();i++)
                                   begin //{
                                      tranm_csins = new pl_gencs_q[i];
                                      stype1_temp = {tranm_csins.brc3_stype1_msb,tranm_csins.stype1, tranm_csins.cmd};
                                      stype0_temp =  tranm_csins.stype0;
                                      if(stype1_temp == 8'h18 || stype1_temp == 8'h22 || stype1_temp == 8'h23 || stype1_temp == 8'h24 || stype1_temp == 8'h2B)
                                      begin //{
                                          pl_gencs_q.delete(i);
                                          merge_cs = new();
                                          merge_cs.brc3_merged_cs[0] = {2'b10,tranm_csins.stype0,tranm_csins.param0,tranm_csins.param1,tranm_csins.brc3_stype1_msb,2'b01,32'h0000_0000};
                                          merge_cs.brc3_merged_cs[1] = {2'b10,tranm_csins.stype1,tranm_csins.cmd,tranm_csins.cs_crc24,2'b10,32'h0000_0000};
                                          if(stype1_temp == 8'h24)
                                          begin //{
                                             merge_cs.link_req_en = 1'b1;
                                          end //}
                                          else if(stype1_temp == 8'h18)
                                          begin //{
                                             merge_cs.rst_frm_rty_en = 1'b1;
                                          end //}
                                          if(tranm_csins.stype0 == 4'b0110)
                                          begin //{
                                              merge_cs.link_resp_en = 1'b1;
                                          end //}
                                          merge_cs.m_type = MERGED_CS; 
                                          pktcs_proc_q.push_back(merge_cs);
                                      end //}   
                                      /*else if(stype0_temp == 4'b0110)
                                      begin //{
                                          pl_gencs_q.delete(i);
                                          merge_cs = new();
                                          merge_cs.brc3_merged_cs[0] = {2'b10,tranm_csins.stype0,tranm_csins.param0,tranm_csins.param1,tranm_csins.brc3_stype1_msb,2'b01,32'h0000_0000};
                                          merge_cs.brc3_merged_cs[1] = {2'b10,tranm_csins.stype1,tranm_csins.cmd,tranm_csins.cs_crc24,2'b10,32'h0000_0000};
                                          if(stype1_temp == 8'h24)
                                          begin //{
                                             merge_cs.link_req_en = 1'b1;
                                          end //}
                                          else if(stype1_temp == 8'h18)
                                          begin //{
                                             merge_cs.rst_frm_rty_en = 1'b1;
                                          end //}
                                          if(tranm_csins.stype0 == 4'b0110)
                                          begin //{
                                              merge_cs.link_resp_en = 1'b1;
                                          end //}
                                          merge_cs.m_type = MERGED_CS; 
                                          pktcs_proc_q.push_back(merge_cs);
                                      end //}*/ 
                                      else if(stype0_temp == 4'h0 || stype0_temp == 4'h1 || stype0_temp == 4'h2 || stype0_temp == 4'h4 || stype0_temp == 4'b0110)
                                      begin //{
                                          pl_gencs_q.delete(i);
                                          tranm_csins.cstype = CS64;
                                          if(temp_data == 32'h00000000)
                                          begin //{
                                             tranm_csins.stype1 = 3'b010;
                                             tranm_csins.cmd    = 3'b001;
                                             tranm_csins.brc3_stype1_msb = 2'b00;
                                          end //}    
                                          else
                                          begin //{
                                             tranm_csins.stype1 = 3'b010;
                                             tranm_csins.cmd    = 3'b000;
                                             tranm_csins.brc3_stype1_msb = 2'b00;
                                          end //}    
                                          if(tranm_csins.stype0 == 4'b0110)
                                          begin //{
                                              merge_cs.link_resp_en = 1'b1;
                                          end //}
                                          tranm_csins.cs_crc24 =  tranm_csins.calccrc24(tranm_csins.pack_cs());
                                          void'(tranm_csins.pack_cs_bytes());  
                                          break;
                                      end //} 
                                   end //} 
                              end //} 
                              else if(pl_seqcs_q.size() != 0)
                              begin //{
                                   for(int i=0;i<pl_seqcs_q.size();i++)
                                   begin //{
                                      tranm_csins = new pl_seqcs_q[i];
                                      stype1_temp = {tranm_csins.brc3_stype1_msb,tranm_csins.stype1, tranm_csins.cmd};
                                      stype0_temp =  tranm_csins.stype0;
                                      if(stype1_temp == 8'h18 || stype1_temp == 8'h22 || stype1_temp == 8'h23 || stype1_temp == 8'h24 || stype1_temp == 8'h2B)
                                      begin //{
                                          pl_seqcs_q.delete(i);
                                          merge_cs = new();
                                          merge_cs.brc3_merged_cs[0] = {2'b10,tranm_csins.stype0,tranm_csins.param0,tranm_csins.param1,tranm_csins.brc3_stype1_msb,2'b01,32'h0000_0000};
                                          merge_cs.brc3_merged_cs[1] = {2'b10,tranm_csins.stype1,tranm_csins.cmd,tranm_csins.cs_crc24,2'b10,32'h0000_0000};
                                          if(stype1_temp == 8'h24)
                                          begin //{
                                             merge_cs.link_req_en = 1'b1;
                                          end //}
                                          else if(stype1_temp == 8'h18)
                                          begin //{
                                             merge_cs.rst_frm_rty_en = 1'b1;
                                          end //}
                                          if(tranm_csins.stype0 == 4'b0110)
                                          begin //{
                                              merge_cs.link_resp_en = 1'b1;
                                          end //}
                                          merge_cs.m_type = MERGED_CS; 
                                          pktcs_proc_q.push_back(merge_cs);
                                      end //}   
                                      /*else if(stype0_temp == 4'b0110)
                                      begin //{
                                          pl_seqcs_q.delete(i);
                                          merge_cs = new();
                                          merge_cs.brc3_merged_cs[0] = {2'b10,tranm_csins.stype0,tranm_csins.param0,tranm_csins.param1,tranm_csins.brc3_stype1_msb,2'b01,32'h0000_0000};
                                          merge_cs.brc3_merged_cs[1] = {2'b10,tranm_csins.stype1,tranm_csins.cmd,tranm_csins.cs_crc24,2'b10,32'h0000_0000};
                                          if(stype1_temp == 8'h24)
                                          begin //{
                                             merge_cs.link_req_en = 1'b1;
                                          end //}
                                          else if(stype1_temp == 8'h18)
                                          begin //{
                                             merge_cs.rst_frm_rty_en = 1'b1;
                                          end //}
                                          if(tranm_csins.stype0 == 4'b0110)
                                          begin //{
                                              merge_cs.link_resp_en = 1'b1;
                                          end //}
                                          merge_cs.m_type = MERGED_CS; 
                                          pktcs_proc_q.push_back(merge_cs);
                                      end //}*/ 
                                      else if(stype0_temp == 4'h0 || stype0_temp == 4'h1 || stype0_temp == 4'h2 || stype0_temp == 4'h4 || stype0_temp == 4'b0110 )
                                      begin //{
                                          pl_seqcs_q.delete(i);
                                          tranm_csins.cstype = CS64;
                                          if(temp_data == 32'h00000000)
                                          begin //{
                                             tranm_csins.stype1 = 3'b010;
                                             tranm_csins.cmd    = 3'b001;
                                             tranm_csins.brc3_stype1_msb = 2'b00;
                                          end //}    
                                          else
                                          begin //{
                                             tranm_csins.stype1 = 3'b010;
                                             tranm_csins.cmd    = 3'b000;
                                             tranm_csins.brc3_stype1_msb = 2'b00;
                                          end //}    
                                          if(tranm_csins.stype0 == 4'b0110)
                                          begin //{
                                              merge_cs.link_resp_en = 1'b1;
                                          end //}
                                          tranm_csins.cs_crc24 =  tranm_csins.calccrc24(tranm_csins.pack_cs());
                                          void'(tranm_csins.pack_cs_bytes());  
                                          break;
                                      end //} 
                                   end //} 
                              end //} 
                              else
                              begin //{
                                tranm_csins = new();
                                tranm_csins.cstype = CS64;
                                if(temp_data == 32'h00000000)
                                begin //{
                                   tranm_csins.stype1 = 3'b010;
                                   tranm_csins.cmd    = 3'b001;
                                   tranm_csins.brc3_stype1_msb = 2'b00;
                                end //}    
                                else
                                begin //{
                                   tranm_csins.stype1 = 3'b010;
                                   tranm_csins.cmd    = 3'b000;
                                   tranm_csins.brc3_stype1_msb = 2'b00;
                                end //}    
                                tranm_csins.stype0 = 4'b0100;
                                //tranm_csins.param0 =   pktm_trans.curr_rx_ackid;
                                 tranm_csins.param0 =   pktm_trans.ackid_for_scs; //pkt_handler_ins.ackid;
                                if(pktm_config.multiple_ack_support)
                                 tranm_csins.param0 = pktm_trans.gr_curr_tx_ackid;
                                
                                if(pktm_config.flow_control_mode == RECEIVE)
                                  tranm_csins.param1 = 12'hFFF;
                                else
                                begin //{
                                  if(pktm_env_config.multi_vc_support == 1'b0)
                                    tranm_csins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_q.size();
                                  else
                                    tranm_csins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_vc0_q.size();
                                end //}
                                tranm_csins.cs_crc24 =  tranm_csins.calccrc24(tranm_csins.pack_cs());
                                void'(tranm_csins.pack_cs_bytes());  
                              end //}  
                              merge_rand3=$urandom_range(0,1);
                              if(merge_rand3)
                               begin//{ 
                                if(pl_gencs_q.size() != 0)
                                begin //{
                                     for(int i=0;i<pl_gencs_q.size();i++)
                                     begin //{
                                        tranm_cs_ins = new pl_gencs_q[0];
                                        stype1_temp = {tranm_cs_ins.brc3_stype1_msb,tranm_cs_ins.stype1, tranm_cs_ins.cmd};
                                        stype0_temp =  tranm_cs_ins.stype0;
                                        if(stype1_temp == 8'h18 || stype1_temp == 8'h22 || stype1_temp == 8'h23 || stype1_temp == 8'h24 || stype1_temp == 8'h2B)
                                        begin //{
                                            pl_gencs_q.delete(0);
                                            merge_cs = new();
                                            merge_cs.brc3_merged_cs[0] = {2'b10,tranm_cs_ins.stype0,tranm_cs_ins.param0,tranm_cs_ins.param1,tranm_cs_ins.brc3_stype1_msb,2'b01,32'h0000_0000};
                                            merge_cs.brc3_merged_cs[1] = {2'b10,tranm_cs_ins.stype1,tranm_cs_ins.cmd,tranm_cs_ins.cs_crc24,2'b10,32'h0000_0000};
                                            if(stype1_temp == 8'h24)
                                            begin //{
                                               merge_cs.link_req_en = 1'b1;
                                            end //}
                                            else if(stype1_temp == 8'h18)
                                            begin //{
                                               merge_cs.rst_frm_rty_en = 1'b1;
                                            end //}
                                            if(tranm_cs_ins.stype0 == 4'b0110)
                                            begin //{
                                                merge_cs.link_resp_en = 1'b1;
                                            end //}
                                            merge_cs.m_type = MERGED_CS; 
                                            pktcs_proc_q.push_back(merge_cs);
                                        end //}   
                                        else if(stype0_temp == 4'h0 || stype0_temp == 4'h1 || stype0_temp == 4'h2 || stype0_temp == 4'h4 || stype0_temp == 4'b0110)
                                        begin //{
                                            embed_inc=1;
                                            pl_gencs_q.delete(0);
                                            tranm_cs_ins.cstype = CS64;
                                            tranm_cs_ins.cs_crc24 =  tranm_cs_ins.calccrc24(tranm_cs_ins.pack_cs());
                                            if(tranm_cs_ins.stype0 == 4'b0110)
                                            begin //{
                                                merge_cs.link_resp_en = 1'b1;
                                            end //}
                                            void'(tranm_cs_ins.pack_cs_bytes());  
                                            break;
                                        end //} 
                                     end //} 
                                end //} 
                                else if(pl_seqcs_q.size() != 0)
                                begin //{
                                     for(int i=0;i<pl_seqcs_q.size();i++)
                                     begin //{
                                        tranm_cs_ins = new pl_seqcs_q[0];
                                        stype1_temp = {tranm_cs_ins.brc3_stype1_msb,tranm_cs_ins.stype1, tranm_cs_ins.cmd};
                                        stype0_temp =  tranm_cs_ins.stype0;
                                        if(stype1_temp == 8'h18 || stype1_temp == 8'h22 || stype1_temp == 8'h23 || stype1_temp == 8'h24 || stype1_temp == 8'h2B)
                                        begin //{
                                            pl_seqcs_q.delete(0);
                                            merge_cs = new();
                                            merge_cs.brc3_merged_cs[0] = {2'b10,tranm_cs_ins.stype0,tranm_cs_ins.param0,tranm_cs_ins.param1,tranm_cs_ins.brc3_stype1_msb,2'b01,32'h0000_0000};
                                            merge_cs.brc3_merged_cs[1] = {2'b10,tranm_cs_ins.stype1,tranm_cs_ins.cmd,tranm_cs_ins.cs_crc24,2'b10,32'h0000_0000};
                                            if(stype1_temp == 8'h24)
                                            begin //{
                                               merge_cs.link_req_en = 1'b1;
                                            end //}
                                            else if(stype1_temp == 8'h18)
                                            begin //{
                                               merge_cs.rst_frm_rty_en = 1'b1;
                                            end //}
                                            if(tranm_cs_ins.stype0 == 4'b0110)
                                            begin //{
                                                merge_cs.link_resp_en = 1'b1;
                                            end //}
                                            merge_cs.m_type = MERGED_CS; 
                                            pktcs_proc_q.push_back(merge_cs);
                                        end //}   
                                        else if(stype0_temp == 4'h0 || stype0_temp == 4'h1 || stype0_temp == 4'h2 || stype0_temp == 4'h4 || stype0_temp == 4'b0110)
                                        begin //{
                                            pl_seqcs_q.delete(0);
                                            embed_inc=1;
                                            tranm_cs_ins.cstype = CS64;
                                            tranm_cs_ins.cs_crc24 =  tranm_cs_ins.calccrc24(tranm_cs_ins.pack_cs());
                                            if(tranm_cs_ins.stype0 == 4'b0110)
                                            begin //{
                                                merge_cs.link_resp_en = 1'b1;
                                            end //}
                                            void'(tranm_cs_ins.pack_cs_bytes());  
                                            break;
                                        end //} 
                                     end //} 
                                end //} 
                              end//}
                              if(embed_inc)
                               begin//{
                                embed_inc=0;
                                merge_pkt.brc3_merged_pkt.push_back({2'b10,tranm_csins.stype0,tranm_csins.param0,tranm_csins.param1,tranm_csins.brc3_stype1_msb,2'b01,temp_data});
                                merge_pkt.brc3_merged_pkt.push_back({2'b10,tranm_csins.stype1,tranm_csins.cmd,tranm_csins.cs_crc24,2'b11,tranm_cs_ins.stype0,tranm_cs_ins.param0,tranm_cs_ins.param1,tranm_cs_ins.brc3_stype1_msb,2'b00});
                                merge_pkt.brc3_merged_pkt.push_back({2'b10,tranm_cs_ins.stype1,tranm_cs_ins.cmd,tranm_cs_ins.cs_crc24,2'b10,32'h0000_0000});
                               end//}
                              else
                               begin//{
                                merge_pkt.brc3_merged_pkt.push_back({2'b10,tranm_csins.stype0,tranm_csins.param0,tranm_csins.param1,tranm_csins.brc3_stype1_msb,2'b01,temp_data});
                              merge_pkt.brc3_merged_pkt.push_back({2'b10,tranm_csins.stype1,tranm_csins.cmd,tranm_csins.cs_crc24,2'b10,32'h0000_0000});
                               end//}
                              merge_pkt.m_type = MERGED_PKT; 
                              pktcs_proc_q.push_back(merge_pkt);
                         end //}
                         else
                         begin //{
                          if(pl_gencs_q.size() != 0 &&  pktm_trans.link_initialized)
                          begin //{
                           int q_siz=pl_gencs_q.size();
                           for(int j=0;j<pl_gencs_q.size();j++)
                           begin //{
                               merge_cs = new();
                               tranm_gen_ins = new pl_gencs_q[j];
                               if(tranm_gen_ins.stype0==4'b0011)
                                begin //{
                                 for(int j=0;j<q_siz;j++)
                                    pack_ts_ins[j] = new pl_gencs_q[j];
                                 merge_cs.brc3_merged_cs[0] = {2'b10,pack_ts_ins[0].stype0,pack_ts_ins[0].param0,pack_ts_ins[0].param1,pack_ts_ins[0].brc3_stype1_msb,2'b01,32'h0000_0000};
                                 merge_cs.brc3_merged_cs[1] = {2'b10,pack_ts_ins[0].stype1,pack_ts_ins[0].cmd,pack_ts_ins[0].cs_crc24,2'b11,pack_ts_ins[1].stype0,pack_ts_ins[1].param0,pack_ts_ins[1].param1,pack_ts_ins[1].brc3_stype1_msb,2'b00};
                                 merge_cs.brc3_merged_cs[2] = {2'b10,pack_ts_ins[1].stype1,pack_ts_ins[1].cmd,pack_ts_ins[1].cs_crc24,2'b11,pack_ts_ins[2].stype0,pack_ts_ins[2].param0,pack_ts_ins[2].param1,pack_ts_ins[2].brc3_stype1_msb,2'b00};
                                 merge_cs.brc3_merged_cs[3] = {2'b10,pack_ts_ins[2].stype1,pack_ts_ins[2].cmd,pack_ts_ins[2].cs_crc24,2'b11,pack_ts_ins[3].stype0,pack_ts_ins[3].param0,pack_ts_ins[3].param1,pack_ts_ins[3].brc3_stype1_msb,2'b00};
                                 merge_cs.brc3_merged_cs[4] = {2'b10,pack_ts_ins[3].stype1,pack_ts_ins[3].cmd,pack_ts_ins[3].cs_crc24,2'b10,32'h0000_0000};
                                 merge_cs.m_type = MERGED_CS; 
                                 pktcs_proc_q.push_back(merge_cs);
                                 pl_gencs_q.delete();
                                end//}
                              end//}
                          end//}


                          if(pl_gencs_q.size() != 0 &&  pktm_trans.link_initialized)
                          begin //{
                            cs_comb=$urandom_range(0,pl_gencs_q.size()/2);
                            for(int i=0;i<=cs_comb;i++)
                            begin//{
                            tranm_gen_ins = new pl_gencs_q[0];
                            pl_gencs_q.delete(0);
                            stype1_temp = {tranm_gen_ins.brc3_stype1_msb,tranm_gen_ins.stype1, tranm_gen_ins.cmd};
                            if(stype1_temp == 8'h22 || stype1_temp == 8'h23 || stype1_temp == 8'h24 || stype1_temp == 8'h18 || tranm_gen_ins.stype0 == 4'b0110)
                             begin //{
                            if(pack_ts_ins.size()!=0)
                             begin//{
                            merge_cs = new();
                              for(int j=0;j<pack_ts_ins.size();j++)
                               begin//{
                                if(pack_ts_ins.size()==1)
                                 begin//{
                                  merge_cs.brc3_merged_cs[0] = {2'b10,pack_ts_ins[0].stype0,pack_ts_ins[0].param0,pack_ts_ins[0].param1,pack_ts_ins[0].brc3_stype1_msb,2'b01,32'h0000_0000};
                                  merge_cs.brc3_merged_cs[1] = {2'b10,pack_ts_ins[0].stype1,pack_ts_ins[0].cmd,pack_ts_ins[0].cs_crc24,2'b10,32'h0000_0000};
                                  break;
                                 end//}
                                if(j==0)
                                  merge_cs.brc3_merged_cs.push_back({2'b10,pack_ts_ins[j].stype0,pack_ts_ins[j].param0,pack_ts_ins[j].param1,pack_ts_ins[j].brc3_stype1_msb,2'b01,32'h0000_0000});
                                else
                                 merge_cs.brc3_merged_cs.push_back({2'b10,pack_ts_ins[j-1].stype1,pack_ts_ins[j-1].cmd,pack_ts_ins[j-1].cs_crc24,2'b11,pack_ts_ins[j].stype0,pack_ts_ins[j].param0,pack_ts_ins[j].param1,pack_ts_ins[j].brc3_stype1_msb,2'b00});
                                if(j==(pack_ts_ins.size()-1))  
                                 merge_cs.brc3_merged_cs.push_back({2'b10,pack_ts_ins[j].stype1,pack_ts_ins[j].cmd,pack_ts_ins[j].cs_crc24,2'b10,32'h0000_0000});
                               end//}
                               pack_ts_ins.delete();
                               merge_cs.m_type = MERGED_CS; 
                               pktcs_proc_q.push_back(merge_cs);
                             end//}
                               merge_cs = new();
                            merge_cs.brc3_merged_cs[0] = {2'b10,tranm_gen_ins.stype0,tranm_gen_ins.param0,tranm_gen_ins.param1,tranm_gen_ins.brc3_stype1_msb,2'b01,32'h0000_0000};
                            merge_cs.brc3_merged_cs[1] = {2'b10,tranm_gen_ins.stype1,tranm_gen_ins.cmd,tranm_gen_ins.cs_crc24,2'b10,32'h0000_0000};
                               if(stype1_temp == 8'h22 || stype1_temp == 8'h23 || stype1_temp == 8'h24)
                               merge_cs.link_req_en = 1'b1;
                            else if(stype1_temp == 8'h18)
                               merge_cs.rst_frm_rty_en = 1'b1;
                               if(tranm_gen_ins.stype0 == 4'b0110)
                                   merge_cs.link_resp_en = 1'b1;
                               merge_cs.m_type = MERGED_CS; 
                               pktcs_proc_q.push_back(merge_cs);
                            end //}
                            else
                             begin//{
                              pack_ts_ins.push_back(tranm_gen_ins);

                             end//}
                            end //}
                            if(pack_ts_ins.size()!=0)
                            begin //{
                               merge_cs = new();
                              for(int j=0;j<=pack_ts_ins.size();j++)
                               begin//{
                                if(pack_ts_ins.size()==1)
                                 begin//{
                                  merge_cs.brc3_merged_cs[0] = {2'b10,pack_ts_ins[0].stype0,pack_ts_ins[0].param0,pack_ts_ins[0].param1,pack_ts_ins[0].brc3_stype1_msb,2'b01,32'h0000_0000};
                                  merge_cs.brc3_merged_cs[1] = {2'b10,pack_ts_ins[0].stype1,pack_ts_ins[0].cmd,pack_ts_ins[0].cs_crc24,2'b10,32'h0000_0000};
                                  break;
                            end //}
                                if(j==0)
                                  merge_cs.brc3_merged_cs.push_back({2'b10,pack_ts_ins[j].stype0,pack_ts_ins[j].param0,pack_ts_ins[j].param1,pack_ts_ins[j].brc3_stype1_msb,2'b01,32'h0000_0000});
                                else if(j==pack_ts_ins.size())  
                                 merge_cs.brc3_merged_cs.push_back({2'b10,pack_ts_ins[j-1].stype1,pack_ts_ins[j-1].cmd,pack_ts_ins[j-1].cs_crc24,2'b10,32'h0000_0000});
                                else
                                 merge_cs.brc3_merged_cs.push_back({2'b10,pack_ts_ins[j-1].stype1,pack_ts_ins[j-1].cmd,pack_ts_ins[j-1].cs_crc24,2'b11,pack_ts_ins[j].stype0,pack_ts_ins[j].param0,pack_ts_ins[j].param1,pack_ts_ins[j].brc3_stype1_msb,2'b00});
                               end//}
                               pack_ts_ins.delete();
                            merge_cs.m_type = MERGED_CS; 
                            pktcs_proc_q.push_back(merge_cs);
                             end//}
                          end //}
                          if(pl_seqcs_q.size() != 0 &&  pktm_trans.link_initialized)
                          begin //{
                            tranm_gen_ins = new pl_seqcs_q[0];
                            pl_seqcs_q.delete(0);
                            stype1_temp = {tranm_gen_ins.brc3_stype1_msb,tranm_gen_ins.stype1, tranm_gen_ins.cmd};
                            merge_cs = new();
                            merge_cs.brc3_merged_cs[0] = {2'b10,tranm_gen_ins.stype0,tranm_gen_ins.param0,tranm_gen_ins.param1,tranm_gen_ins.brc3_stype1_msb,2'b01,32'h0000_0000};
                            merge_cs.brc3_merged_cs[1] = {2'b10,tranm_gen_ins.stype1,tranm_gen_ins.cmd,tranm_gen_ins.cs_crc24,2'b10,32'h0000_0000};
                            if(stype1_temp == 8'h24)
                            begin //{
                               merge_cs.link_req_en = 1'b1;
                            end //}
                            else if(stype1_temp == 8'h18)
                            begin //{
                               merge_cs.rst_frm_rty_en = 1'b1;
                            end //}
                            if(tranm_gen_ins.stype0 == 4'b0110)
                            begin //{
                                merge_cs.link_resp_en = 1'b1;
                            end //}
                            merge_cs.m_type = MERGED_CS; 
                            pktcs_proc_q.push_back(merge_cs);
                          end //}
                         end //} 
                                 
                          if(pl_gencs_q.size() != 0 &&  ~pktm_trans.link_initialized && pktm_trans.port_initialized)
                          begin //{
                            tranm_gen_ins = new pl_gencs_q[0];
                            pl_gencs_q.delete(0);
                            stype1_temp = {tranm_gen_ins.brc3_stype1_msb,tranm_gen_ins.stype1, tranm_gen_ins.cmd};
                            merge_cs = new();
                            merge_cs.brc3_merged_cs[0] = {2'b10,tranm_gen_ins.stype0,tranm_gen_ins.param0,tranm_gen_ins.param1,tranm_gen_ins.brc3_stype1_msb,2'b01,32'h0000_0000};
                            merge_cs.brc3_merged_cs[1] = {2'b10,tranm_gen_ins.stype1,tranm_gen_ins.cmd,tranm_gen_ins.cs_crc24,2'b10,32'h0000_0000};
                            if(stype1_temp == 8'h24)
                            begin //{
                               merge_cs.link_req_en = 1'b1;
                            end //}
                            else if(stype1_temp == 8'h18)
                            begin //{
                               merge_cs.rst_frm_rty_en = 1'b1;
                            end //}
                            if(tranm_gen_ins.stype0 == 4'b0110)
                            begin //{
                                merge_cs.link_resp_en = 1'b1;
                            end //}
                            merge_cs.m_type = MERGED_CS; 
                            pktcs_proc_q.push_back(merge_cs);
                          end //}

                          if(pktm_trans.oes_state == 1'b1 && pktm_trans.link_initialized)
                                state = MERGE_OES_G3;
                          else if(pktm_trans.ies_state == 1'b1 && pktm_trans.link_initialized)
                               state = MERGE_IES_G3;
                          else if(pktm_trans.ors_state == 1'b1 && pktm_trans.link_initialized)
                               state = MERGE_ORS_G3;
                          else if(pktm_trans.irs_state == 1'b1 && pktm_trans.link_initialized)
                               state = MERGE_IRS_G3;
                         else if(pktm_trans.link_initialized)
                                state = MERGE_NORMAL_G3;
                         else if(pktm_trans.port_initialized)
                                state = MERGE_NORMAL_G3;
                          end //}  

     MERGE_OES_G3    : begin //{
                       if(pktm_trans.oes_state)
                       begin //{ 
                          if(pl_gencs_q.size() != 0 &&  pktm_trans.link_initialized)
                          begin //{
                              tranm_gen_ins = new pl_gencs_q[0];
                              pl_gencs_q.delete(0);
                              stype1_temp = {tranm_gen_ins.brc3_stype1_msb,tranm_gen_ins.stype1,tranm_gen_ins.cmd};
                              merge_cs = new();
                              merge_cs.brc3_merged_cs[0] = {2'b10,tranm_gen_ins.stype0,tranm_gen_ins.param0,tranm_gen_ins.param1,tranm_gen_ins.brc3_stype1_msb,2'b01,32'h0000_0000};
                              merge_cs.brc3_merged_cs[1] = {2'b10,tranm_gen_ins.stype1,tranm_gen_ins.cmd,tranm_gen_ins.cs_crc24,2'b10,32'h0000_0000};
                              if(stype1_temp == 8'h22 || stype1_temp == 8'h23 || stype1_temp == 8'h24)
                              begin //{
                                 merge_cs.link_req_en = 1'b1;
                              end //}
                              else if(stype1_temp == 8'h18)
                              begin //{
                                 merge_cs.rst_frm_rty_en = 1'b1;
                              end //}
                              if(tranm_gen_ins.stype0 == 4'b0110)
                              begin //{
                                  merge_cs.link_resp_en = 1'b1;
                              end //}
                              merge_cs.m_type = MERGED_CS; 
                              pktcs_proc_q.push_back(merge_cs);
                          end //}
                          if(pl_seqcs_q.size() != 0 &&  pktm_trans.link_initialized)
                          begin //{
                              tranm_seq_ins = new pl_seqcs_q[0];
                              pl_seqcs_q.delete(0);
                              stype1_temp = {tranm_seq_ins.brc3_stype1_msb,tranm_seq_ins.stype1,tranm_seq_ins.cmd};
                              merge_cs = new();
                              merge_cs.brc3_merged_cs[0] = {2'b10,tranm_seq_ins.stype0,tranm_seq_ins.param0,tranm_seq_ins.param1,tranm_seq_ins.brc3_stype1_msb,2'b01,32'h0000_0000};
                              merge_cs.brc3_merged_cs[1] = {2'b10,tranm_seq_ins.stype1,tranm_seq_ins.cmd,tranm_seq_ins.cs_crc24,2'b10,32'h0000_0000};
                              if(stype1_temp == 8'h22 || stype1_temp == 8'h23 || stype1_temp == 8'h24)
                              begin //{
                                 merge_cs.link_req_en = 1'b1;
                              end //}
                              else if(stype1_temp == 8'h18)
                              begin //{
                                 merge_cs.rst_frm_rty_en = 1'b1;
                              end //}
                              if(tranm_seq_ins.stype0 == 4'b0110)
                              begin //{
                                  merge_cs.link_resp_en = 1'b1;
                              end //}
                              merge_cs.m_type = MERGED_CS; 
                              pktcs_proc_q.push_back(merge_cs);
                          end //}
                          if(pl_gencs_q.size() != 0 &&  ~pktm_trans.link_initialized && pktm_trans.port_initialized)
                          begin //{
                              tranm_gen_ins = new pl_gencs_q[0];
                              pl_gencs_q.delete(0);
                              merge_cs = new();
                              merge_cs.brc3_merged_cs[0] = {2'b10,tranm_gen_ins.stype0,tranm_gen_ins.param0,tranm_gen_ins.param1,tranm_gen_ins.brc3_stype1_msb,2'b01,32'h0000_0000};
                              merge_cs.brc3_merged_cs[1] = {2'b10,tranm_gen_ins.stype1,tranm_gen_ins.cmd,tranm_gen_ins.cs_crc24,2'b10,32'h0000_0000};
                              stype1_temp = {tranm_gen_ins.brc3_stype1_msb,tranm_gen_ins.stype1,tranm_gen_ins.cmd};
                              if(stype1_temp == 8'h22 || stype1_temp == 8'h23 || stype1_temp == 8'h24)
                              begin //{
                                 merge_cs.link_req_en = 1'b1;
                              end //}
                              else if(stype1_temp == 8'h18)
                              begin //{
                                 merge_cs.rst_frm_rty_en = 1'b1;
                              end //}
                              if(tranm_gen_ins.stype0 == 4'b0110)
                              begin //{
                                  merge_cs.link_resp_en = 1'b1;
                              end //}
                              merge_cs.m_type = MERGED_CS; 
                              pktcs_proc_q.push_back(merge_cs);
                          end //}
                       end //}
                       else
                       begin //{
                          if(pl_outstanding_ackid_q.size() != 0)
                          begin //{
                             bkp_ackid =  pkt_handler_ins.ackid_status;
                             if((pktm_config.multiple_ack_support && pktm_config.ackid_status_pnack_support))
                              bkp_ackid =  pkt_handler_ins.notaccepted_ackid;
                             for(int i=0;i<pl_outstanding_ackid_q.size();i++)
                             begin //{
                                bkp_ackid_trans = new(); 
                                bkp_ackid_trans = pl_outstanding_ackid_q[i];
                                if(bkp_ackid_trans.ackid == bkp_ackid)
                                begin //{
                                   pl_outstanding_ackid_q.delete(i);
                                    break;
                                end //}
                               else if(bkp_ackid_trans.ackid < bkp_ackid)
                               begin //{
                                  pl_outstanding_ackid_q.delete(i);
                               end //}
                             end //} 
                             out_size = pl_outstanding_ackid_q.size();
                             for(int i=0;i< out_size;i++)
                             begin //{
                                if(pl_outstanding_ackid_q.size()!=0)
                                   pl_pkt_q.push_front(pl_outstanding_ackid_q.pop_back());
                             end //} 
                             // error cases
                             if(bkp_ackid_trans.pl_err_kind == ACKID_ERR)
                             begin //{
                                bkp_ackid_trans.pl_err_kind = NO_ERR;               
                             end //} 
                             else if(bkp_ackid_trans.pl_err_kind == EARLY_CRC_ERR)
                             begin //{
                                bkp_ackid_trans.pl_err_kind = NO_ERR;
                             end //}
                             else if(bkp_ackid_trans.pl_err_kind == FINAL_CRC_ERR)
                             begin //{
                                bkp_ackid_trans.pl_err_kind = NO_ERR;
                             end //}
                          // else if(bkp_ackid_trans.ll_err_kind == MAX_SIZE_ERR)
                          // begin //{
                          //    bkp_ackid_trans.ll_err_kind = NONE;
                          //     
                          // end //}
                            bkp_ackid_trans.ackid = bkp_ackid;
                            void'(bkp_ackid_trans.pack_bytes(bkp_ackid_trans.bytestream));
                            pl_outstanding_ackid_q.push_back(bkp_ackid_trans);
 
                            merge_trans_ins = new();
                            merge_trans_ins.stype0 = 4'b0100;
                            //merge_trans_ins.param0 =  pktm_trans.curr_rx_ackid;
                            merge_trans_ins.param0 =   pktm_trans.ackid_for_scs; //pkt_handler_ins.ackid;
                            if(pktm_config.multiple_ack_support)
                             merge_trans_ins.param0 = pktm_trans.gr_curr_tx_ackid;
                            merge_trans_ins.param1 =  12'hFFF;
                            merge_trans_ins.stype1 = bkp_ackid[0:2];
                            merge_trans_ins.cmd    = bkp_ackid[3:5];
                            merge_trans_ins.brc3_stype1_msb = 2'b10;
                            merge_trans_ins.cstype = CS64;
                            void'(merge_trans_ins.calccrc24(merge_trans_ins.pack_cs()));
                            void'(merge_trans_ins.pack_cs_bytes());
                            merge_pkt = new();
                            for(int i = 0;i<bkp_ackid_trans.bytestream.size();i++)
                            begin //{
                                temp_pkt_q.push_back(bkp_ackid_trans.bytestream[i]);
                            end //}
                            for(int i =0;i<4;i++)
                            begin //{
                                if(temp_pkt_q.size() != 0)
                                  temp_data[24:31] = temp_pkt_q.pop_front(); 
                                if(i!=3)
                                  temp_data = temp_data << 8;
                            end //}
                            merge_pkt.brc3_merged_pkt[0] = {2'b10,merge_trans_ins.stype0,merge_trans_ins.param0,merge_trans_ins.param1,merge_trans_ins.brc3_stype1_msb,2'b01,32'h0000_0000};
                            merge_pkt.brc3_merged_pkt[1] = {2'b10,merge_trans_ins.stype1,merge_trans_ins.cmd,merge_trans_ins.cs_crc24,2'b10,temp_data};
                            temp_size = temp_pkt_q.size();
                            for(int i = 0;i<temp_size/8;i++)
                            begin //{
                                 temp0 = temp_pkt_q.pop_front();
                                 temp1 = temp_pkt_q.pop_front();
                                 temp2 = temp_pkt_q.pop_front();
                                 temp3 = temp_pkt_q.pop_front();
                                 temp4 = temp_pkt_q.pop_front();
                                 temp5 = temp_pkt_q.pop_front();
                                 temp6 = temp_pkt_q.pop_front();
                                 temp7 = temp_pkt_q.pop_front();
                                 merge_pkt.brc3_merged_pkt.push_back({2'b01,temp0,temp1,temp2,temp3,temp4,temp5,temp6,temp7});
                            end //}
                              for(int i =0;i<4;i++)
                              begin //{
                                  if(temp_pkt_q.size() != 0)
                                    temp_data[24:31] = temp_pkt_q.pop_front(); 
                                  if(i!=3)
                                    temp_data = temp_data << 8;
                              end //}
                            tranm_csins = new();
                            tranm_csins.cstype = CS64;
                            if(temp_data == 32'h00000000)
                            begin //{
                               tranm_csins.stype1 = 3'b010;
                               tranm_csins.cmd    = 3'b001;
                               tranm_csins.brc3_stype1_msb = 2'b00;
                            end //}    
                            else
                            begin //{
                               tranm_csins.stype1 = 3'b010;
                               tranm_csins.cmd    = 3'b000;
                               tranm_csins.brc3_stype1_msb = 2'b00;
                            end //}    
                            tranm_csins.stype0 = 4'b0100;
                            //tranm_csins.param0 =   pktm_trans.curr_rx_ackid;
                            tranm_csins.param0 =   pktm_trans.ackid_for_scs; //pkt_handler_ins.ackid;
                            if(pktm_config.multiple_ack_support)
                             tranm_csins.param0 = pktm_trans.gr_curr_tx_ackid;
                            
                            if(pktm_config.flow_control_mode == RECEIVE)
                              tranm_csins.param1 = 12'hFFF;
                            else
                            begin //{
                              if(pktm_env_config.multi_vc_support == 1'b0)
                                tranm_csins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_q.size();
                              else
                                tranm_csins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_vc0_q.size();
                            end //}
                            tranm_csins.cs_crc24 =  tranm_csins.calccrc24(tranm_csins.pack_cs());
                            void'(tranm_csins.pack_cs_bytes());  
                            /*for(int i =0;i<4;i++)
                            begin //{
                                if(temp_pkt_q.size() != 0)
                                  temp_data[24:31] = temp_pkt_q.pop_front(); 
                                if(i!=3)
                                  temp_data = temp_data << 8;
                            end //}*/
                            merge_pkt.brc3_merged_pkt.push_back({2'b10,tranm_csins.stype0,tranm_csins.param0,tranm_csins.param1,tranm_csins.brc3_stype1_msb,2'b01,temp_data});
                            merge_pkt.brc3_merged_pkt.push_back({2'b10,tranm_csins.stype1,tranm_csins.cmd,tranm_csins.cs_crc24,2'b10,32'h0000_0000});
                            merge_pkt.m_type = MERGED_PKT; 
                            pktcs_proc_q.push_back(merge_pkt);
                          end //} 
                       end //} 
                       if(pktm_trans.oes_state == 1'b0 && pktm_trans.link_initialized)
                             state = MERGE_NORMAL_G3;
                      else if(pktm_trans.ies_state == 1'b1 && pktm_trans.link_initialized)
                           state = MERGE_IES_G3;
                      else if(pktm_trans.ors_state == 1'b1 && pktm_trans.link_initialized)
                           state = MERGE_ORS_G3;
                      else if(pktm_trans.irs_state == 1'b1 && pktm_trans.link_initialized)
                           state = MERGE_IRS_G3;
                        else if(pktm_trans.link_initialized && pktm_trans.oes_state == 1'b1)
                             state = MERGE_OES_G3;
                        end //}

        MERGE_IES_G3 :begin //{
                      if(pktm_trans.ies_state)
                      begin //{ 
                          if(pl_gencs_q.size() != 0 &&  pktm_trans.link_initialized)
                          begin //{
                              tranm_gen_ins = new pl_gencs_q[0];
                              pl_gencs_q.delete(0);
                              stype1_temp = {tranm_gen_ins.brc3_stype1_msb,tranm_gen_ins.stype1,tranm_gen_ins.cmd};
                              merge_cs = new();
                              merge_cs.brc3_merged_cs[0] = {2'b10,tranm_gen_ins.stype0,tranm_gen_ins.param0,tranm_gen_ins.param1,tranm_gen_ins.brc3_stype1_msb,2'b01,32'h0000_0000};
                              merge_cs.brc3_merged_cs[1] = {2'b10,tranm_gen_ins.stype1,tranm_gen_ins.cmd,tranm_gen_ins.cs_crc24,2'b10,32'h0000_0000};
                              if(stype1_temp == 8'h22 || stype1_temp == 8'h23 || stype1_temp == 8'h24)
                              begin //{
                                 merge_cs.link_req_en = 1'b1;
                              end //}
                              else if(stype1_temp == 8'h18)
                              begin //{
                                 merge_cs.rst_frm_rty_en = 1'b1;
                              end //}
                              if(tranm_gen_ins.stype0 == 4'b0110)
                              begin //{
                                  merge_cs.link_resp_en = 1'b1;
                              end //}
                              merge_cs.m_type = MERGED_CS; 
                              pktcs_proc_q.push_back(merge_cs);
                          end //}
                          if(pl_seqcs_q.size() != 0 &&  pktm_trans.link_initialized)
                          begin //{
                              tranm_seq_ins = new pl_seqcs_q[0];
                              pl_seqcs_q.delete(0);
                              stype1_temp = {tranm_seq_ins.brc3_stype1_msb,tranm_seq_ins.stype1,tranm_seq_ins.cmd};
                              merge_cs = new();
                              merge_cs.brc3_merged_cs[0] = {2'b10,tranm_seq_ins.stype0,tranm_seq_ins.param0,tranm_seq_ins.param1,tranm_seq_ins.brc3_stype1_msb,2'b01,32'h0000_0000};
                              merge_cs.brc3_merged_cs[1] = {2'b10,tranm_seq_ins.stype1,tranm_seq_ins.cmd,tranm_seq_ins.cs_crc24,2'b10,32'h0000_0000};
                              if(stype1_temp == 8'h22 || stype1_temp == 8'h23 || stype1_temp == 8'h24)
                              begin //{
                                 merge_cs.link_req_en = 1'b1;
                              end //}
                              else if(stype1_temp == 8'h18)
                              begin //{
                                 merge_cs.rst_frm_rty_en = 1'b1;
                              end //}
                              if(tranm_seq_ins.stype0 == 4'b0110)
                              begin //{
                                  merge_cs.link_resp_en = 1'b1;
                              end //}
                              merge_cs.m_type = MERGED_CS; 
                              pktcs_proc_q.push_back(merge_cs);
                          end //}
                          if(pl_gencs_q.size() != 0 &&  ~pktm_trans.link_initialized && pktm_trans.port_initialized)
                          begin //{
                              tranm_gen_ins = new pl_gencs_q[0];
                              pl_gencs_q.delete(0);
                              stype1_temp = {tranm_gen_ins.brc3_stype1_msb,tranm_gen_ins.stype1,tranm_gen_ins.cmd};
                              merge_cs = new();
                              merge_cs.brc3_merged_cs[0] = {2'b10,tranm_gen_ins.stype0,tranm_gen_ins.param0,tranm_gen_ins.param1,tranm_gen_ins.brc3_stype1_msb,2'b01,32'h0000_0000};
                              merge_cs.brc3_merged_cs[1] = {2'b10,tranm_gen_ins.stype1,tranm_gen_ins.cmd,tranm_gen_ins.cs_crc24,2'b10,32'h0000_0000};
                              if(stype1_temp == 8'h22 || stype1_temp == 8'h23 || stype1_temp == 8'h24)
                              begin //{
                                 merge_cs.link_req_en = 1'b1;
                              end //}
                              else if(stype1_temp == 8'h18)
                              begin //{
                                 merge_cs.rst_frm_rty_en = 1'b1;
                              end //}
                              if(tranm_gen_ins.stype0 == 4'b0110)
                              begin //{
                                  merge_cs.link_resp_en = 1'b1;
                              end //}
                              merge_cs.m_type = MERGED_CS; 
                              pktcs_proc_q.push_back(merge_cs);
                          end //}
                       end //}
                       if(pktm_trans.ies_state == 1'b0 && pktm_trans.link_initialized)
                             state = MERGE_NORMAL_G3;
                       else if(pktm_trans.oes_state == 1'b1 && pktm_trans.link_initialized)
                            state = MERGE_OES_G3;
                       else if(pktm_trans.ors_state == 1'b1 && pktm_trans.link_initialized)
                            state = MERGE_ORS_G3;
                       else if(pktm_trans.irs_state == 1'b1 && pktm_trans.link_initialized)
                            state = MERGE_IRS_G3;
                       else if(pktm_trans.link_initialized && pktm_trans.ies_state == 1'b1)
                            state = MERGE_IES_G3;

                       end //}  

        MERGE_IRS_G3  : begin //{
                      if(pktm_trans.irs_state)
                      begin //{ 
                          if(pl_gencs_q.size() != 0 &&  pktm_trans.link_initialized)
                          begin //{
                              tranm_gen_ins = new pl_gencs_q[0];
                              pl_gencs_q.delete(0);
                              stype1_temp = {tranm_gen_ins.brc3_stype1_msb,tranm_gen_ins.stype1,tranm_gen_ins.cmd};
                              merge_cs = new();
                              merge_cs.brc3_merged_cs[0] = {2'b10,tranm_gen_ins.stype0,tranm_gen_ins.param0,tranm_gen_ins.param1,tranm_gen_ins.brc3_stype1_msb,2'b01,32'h0000_0000};
                              merge_cs.brc3_merged_cs[1] = {2'b10,tranm_gen_ins.stype1,tranm_gen_ins.cmd,tranm_gen_ins.cs_crc24,2'b10,32'h0000_0000};
                              if(stype1_temp == 8'h22 || stype1_temp == 8'h23 || stype1_temp == 8'h24)
                              begin //{
                                 merge_cs.link_req_en = 1'b1;
                              end //}
                              else if(stype1_temp == 8'h18)
                              begin //{
                                 merge_cs.rst_frm_rty_en = 1'b1;
                              end //}
                              if(tranm_gen_ins.stype0 == 4'b0110)
                              begin //{
                                  merge_cs.link_resp_en = 1'b1;
                              end //}
                              merge_cs.m_type = MERGED_CS; 
                              pktcs_proc_q.push_back(merge_cs);
                          end //}
                          if(pl_seqcs_q.size() != 0 &&  pktm_trans.link_initialized)
                          begin //{
                              tranm_seq_ins = new pl_seqcs_q[0];
                              pl_seqcs_q.delete(0);
                              stype1_temp = {tranm_seq_ins.brc3_stype1_msb,tranm_seq_ins.stype1,tranm_seq_ins.cmd};
                              merge_cs = new();
                              merge_cs.brc3_merged_cs[0] = {2'b10,tranm_seq_ins.stype0,tranm_seq_ins.param0,tranm_seq_ins.param1,tranm_seq_ins.brc3_stype1_msb,2'b01,32'h0000_0000};
                              merge_cs.brc3_merged_cs[1] = {2'b10,tranm_seq_ins.stype1,tranm_seq_ins.cmd,tranm_seq_ins.cs_crc24,2'b10,32'h0000_0000};
                              if(stype1_temp == 8'h22 || stype1_temp == 8'h23 || stype1_temp == 8'h24)
                              begin //{
                                 merge_cs.link_req_en = 1'b1;
                              end //}
                              else if(stype1_temp == 8'h18)
                              begin //{
                                 merge_cs.rst_frm_rty_en = 1'b1;
                              end //}
                              if(tranm_seq_ins.stype0 == 4'b0110)
                              begin //{
                                  merge_cs.link_resp_en = 1'b1;
                              end //}
                              merge_cs.m_type = MERGED_CS; 
                              pktcs_proc_q.push_back(merge_cs);
                          end //}
                          if(pl_gencs_q.size() != 0 &&  ~pktm_trans.link_initialized && pktm_trans.port_initialized)
                          begin //{
                              tranm_gen_ins = new pl_gencs_q[0];
                              pl_gencs_q.delete(0);
                              stype1_temp = {tranm_gen_ins.brc3_stype1_msb,tranm_gen_ins.stype1,tranm_gen_ins.cmd};
                              merge_cs = new();
                              merge_cs.brc3_merged_cs[0] = {2'b10,tranm_gen_ins.stype0,tranm_gen_ins.param0,tranm_gen_ins.param1,tranm_gen_ins.brc3_stype1_msb,2'b01,32'h0000_0000};
                              merge_cs.brc3_merged_cs[1] = {2'b10,tranm_gen_ins.stype1,tranm_gen_ins.cmd,tranm_gen_ins.cs_crc24,2'b10,32'h0000_0000};
                              if(stype1_temp == 8'h22 || stype1_temp == 8'h23 || stype1_temp == 8'h24)
                              begin //{
                                 merge_cs.link_req_en = 1'b1;
                              end //}
                              else if(stype1_temp == 8'h18)
                              begin //{
                                 merge_cs.rst_frm_rty_en = 1'b1;
                              end //}
                              if(tranm_gen_ins.stype0 == 4'b0110)
                              begin //{
                                  merge_cs.link_resp_en = 1'b1;
                              end //}
                              merge_cs.m_type = MERGED_CS; 
                              pktcs_proc_q.push_back(merge_cs);
                          end //}
                       end //}
                      if(pktm_trans.oes_state == 1'b1 && pktm_trans.link_initialized)
                           state = MERGE_OES_G3;
                      else if(pktm_trans.ors_state == 1'b1 && pktm_trans.link_initialized)
                           state = MERGE_ORS_G3;
                      else if(pktm_trans.irs_state == 1'b1 && pktm_trans.link_initialized)
                           state = MERGE_IRS_G3;
                       else if(pktm_trans.link_initialized && pktm_trans.ies_state == 1'b1)
                            state = MERGE_IES_G3;
                      else if(pktm_trans.irs_state == 1'b0 && pktm_trans.link_initialized)
                            state = MERGE_NORMAL_G3;

                     end //}  

        MERGE_ORS_G3  : begin //{
                      if(pktm_trans.ors_state)
                      begin //{ 
                          if(pl_gencs_q.size() != 0 &&  pktm_trans.link_initialized)
                          begin //{
                              tranm_gen_ins = new pl_gencs_q[0];
                              pl_gencs_q.delete(0);
                              stype1_temp = {tranm_gen_ins.brc3_stype1_msb,tranm_gen_ins.stype1,tranm_gen_ins.cmd};
                              merge_cs = new();
                              merge_cs.brc3_merged_cs[0] = {2'b10,tranm_gen_ins.stype0,tranm_gen_ins.param0,tranm_gen_ins.param1,tranm_gen_ins.brc3_stype1_msb,2'b01,32'h0000_0000};
                              merge_cs.brc3_merged_cs[1] = {2'b10,tranm_gen_ins.stype1,tranm_gen_ins.cmd,tranm_gen_ins.cs_crc24,2'b10,32'h0000_0000};
                              if(stype1_temp == 8'h22 || stype1_temp == 8'h23 || stype1_temp == 8'h24)
                              begin //{
                                 merge_cs.link_req_en = 1'b1;
                              end //}
                              else if(stype1_temp == 8'h18)
                              begin //{
                                 merge_cs.rst_frm_rty_en = 1'b1;
                              end //}
                              if(tranm_gen_ins.stype0 == 4'b0110)
                              begin //{
                                  merge_cs.link_resp_en = 1'b1;
                              end //}
                              merge_cs.m_type = MERGED_CS; 
                              pktcs_proc_q.push_back(merge_cs);
                          end //}
                          if(pl_seqcs_q.size() != 0 &&  pktm_trans.link_initialized)
                          begin //{
                              tranm_seq_ins = new pl_seqcs_q[0];
                              pl_seqcs_q.delete(0);
                              merge_cs = new();
                              merge_cs.brc3_merged_cs[0] = {2'b10,tranm_seq_ins.stype0,tranm_seq_ins.param0,tranm_seq_ins.param1,tranm_seq_ins.brc3_stype1_msb,2'b01,32'h0000_0000};
                              merge_cs.brc3_merged_cs[1] = {2'b10,tranm_seq_ins.stype1,tranm_seq_ins.cmd,tranm_seq_ins.cs_crc24,2'b10,32'h0000_0000};
                              stype1_temp = {tranm_seq_ins.brc3_stype1_msb,tranm_seq_ins.stype1,tranm_seq_ins.cmd};
                              if(stype1_temp == 8'h22 || stype1_temp == 8'h23 || stype1_temp == 8'h24)
                              begin //{
                                 merge_cs.link_req_en = 1'b1;
                              end //}
                              else if(stype1_temp == 8'h18)
                              begin //{
                                 merge_cs.rst_frm_rty_en = 1'b1;
                              end //}
                              if(tranm_seq_ins.stype0 == 4'b0110)
                              begin //{
                                  merge_cs.link_resp_en = 1'b1;
                              end //}
                              merge_cs.m_type = MERGED_CS; 
                              pktcs_proc_q.push_back(merge_cs);
                          end //}
                          if(pl_gencs_q.size() != 0 &&  ~pktm_trans.link_initialized && pktm_trans.port_initialized)
                          begin //{
                              tranm_gen_ins = new pl_gencs_q[0];
                              pl_gencs_q.delete(0);
                              stype1_temp = {tranm_gen_ins.brc3_stype1_msb,tranm_gen_ins.stype1,tranm_gen_ins.cmd};
                              merge_cs = new();
                              merge_cs.brc3_merged_cs[0] = {2'b10,tranm_gen_ins.stype0,tranm_gen_ins.param0,tranm_gen_ins.param1,tranm_gen_ins.brc3_stype1_msb,2'b01,32'h0000_0000};
                              merge_cs.brc3_merged_cs[1] = {2'b10,tranm_gen_ins.stype1,tranm_gen_ins.cmd,tranm_gen_ins.cs_crc24,2'b10,32'h0000_0000};
                              if(stype1_temp == 8'h22 || stype1_temp == 8'h23 || stype1_temp == 8'h24)
                              begin //{
                                 merge_cs.link_req_en = 1'b1;
                              end //}
                              else if(stype1_temp == 8'h18)
                              begin //{
                                 merge_cs.rst_frm_rty_en = 1'b1;
                              end //}
                              if(tranm_gen_ins.stype0 == 4'b0110)
                              begin //{
                                  merge_cs.link_resp_en = 1'b1;
                              end //}
                              merge_cs.m_type = MERGED_CS; 
                              pktcs_proc_q.push_back(merge_cs);
                          end //}
                       end //}
                       else 
                       begin //{
                          if(pl_outstanding_ackid_q.size() != 0)
                          begin //{
                            retry_ackid = pkt_handler_ins.retried_ackid; 
                            for(int i=0;i<pl_outstanding_ackid_q.size();i++)
                            begin //{
                               rty_ackid_trans = new pl_outstanding_ackid_q[i];
                               if(rty_ackid_trans.ackid == retry_ackid)
                               begin //{
                                  //pl_outstanding_ackid_q.delete(i);
                                   break;
                               end //}
                               else if(rty_ackid_trans.ackid < retry_ackid)
                               begin //{
                                  pl_outstanding_ackid_q.delete(i);
                               end //}
                            end //} 
                            temp_size = pl_outstanding_ackid_q.size();
                            for(int i=0;i<temp_size;i++)
                            begin //{
                                if(pl_outstanding_ackid_q.size()!=0)
                                  pl_pkt_q.push_front(pl_outstanding_ackid_q.pop_back());
                            end //} 
                            sorter();
                              if(pl_gencs_q.size() != 0)
                               begin //{
                                 for(int i=0;i<pl_gencs_q.size();i++)
                                  begin //{
                                    merge_trans_ins = new pl_gencs_q[i];
                                    stype1_temp = {merge_trans_ins.brc3_stype1_msb,merge_trans_ins.stype1, merge_trans_ins.cmd};
                                    stype0_temp =  merge_trans_ins.stype0;
 if(stype0_temp == 4'h0 || stype0_temp == 4'h1 || stype0_temp == 4'h2 || stype0_temp == 4'h4)
                                    begin //{
                                        pl_gencs_q.delete(i);
                                        merge_trans_ins.cstype = CS64;
                                        merge_trans_ins.stype1 = retry_ackid[0:2];
                                        merge_trans_ins.cmd    = retry_ackid[3:5];
                                        merge_trans_ins.brc3_stype1_msb = 2'b10;
                                        merge_trans_ins.cs_crc24 =  merge_trans_ins.calccrc24(merge_trans_ins.pack_cs());
                                        void'(merge_trans_ins.pack_cs_bytes());
                                        break;
                                    end //}
                                  end //}
                               end //}
                              else
                               begin //{
                                merge_trans_ins = new();
                                merge_trans_ins.stype0 = 4'b0100;
                                //merge_trans_ins.param0 =  pktm_trans.curr_rx_ackid;
                                merge_trans_ins.param0 =   pktm_trans.ackid_for_scs; //pkt_handler_ins.ackid;
                                if(pktm_config.multiple_ack_support)
                                 merge_trans_ins.param0 = pktm_trans.gr_curr_tx_ackid;
                                merge_trans_ins.param1 =  12'hFFF;
                                merge_trans_ins.stype1 = retry_ackid[0:2];
                                merge_trans_ins.cmd    = retry_ackid[3:5];
                                merge_trans_ins.brc3_stype1_msb = 2'b10;
                                merge_trans_ins.cstype = CS64;
                                void'(merge_trans_ins.calccrc24(merge_trans_ins.pack_cs()));
                                void'(merge_trans_ins.pack_cs_bytes());
                               end //}
                               rty_ackid_trans = pl_pkt_q.pop_front();
                            merge_pkt = new();
                            pl_outstanding_ackid_q.push_back(rty_ackid_trans);
                            for(int i = 0;i<rty_ackid_trans.bytestream.size();i++)
                            begin //{
                                temp_pkt_q.push_back(rty_ackid_trans.bytestream[i]);
                            end //}
                            for(int i =0;i<4;i++)
                            begin //{
                                if(temp_pkt_q.size() != 0)
                                  temp_data[24:31] = temp_pkt_q.pop_front(); 
                                if(i!=3)
                                  temp_data = temp_data << 8;
                            end //}
                            merge_pkt.brc3_merged_pkt[0] = {2'b10,merge_trans_ins.stype0,merge_trans_ins.param0,merge_trans_ins.param1,merge_trans_ins.brc3_stype1_msb,2'b01,32'h0000_0000};
                            merge_pkt.brc3_merged_pkt[1] = {2'b10,merge_trans_ins.stype1,merge_trans_ins.cmd,merge_trans_ins.cs_crc24,2'b10,temp_data};
                            temp_size = temp_pkt_q.size();
                            for(int i = 0;i<temp_size/8;i++)
                            begin //{
                                 temp0 = temp_pkt_q.pop_front();
                                 temp1 = temp_pkt_q.pop_front();
                                 temp2 = temp_pkt_q.pop_front();
                                 temp3 = temp_pkt_q.pop_front();
                                 temp4 = temp_pkt_q.pop_front();
                                 temp5 = temp_pkt_q.pop_front();
                                 temp6 = temp_pkt_q.pop_front();
                                 temp7 = temp_pkt_q.pop_front();
                                 merge_pkt.brc3_merged_pkt.push_back({2'b01,temp0,temp1,temp2,temp3,temp4,temp5,temp6,temp7});
                            end //}
                            for(int i =0;i<4;i++)
                            begin //{
                                if(temp_pkt_q.size() != 0)
                                  temp_data[24:31] = temp_pkt_q.pop_front(); 
                                if(i!=3)
                                  temp_data = temp_data << 8;
                            end //}
                            tranm_csins = new();
                            tranm_csins.cstype = CS64;
                            if(temp_data == 32'h00000000)
                            begin //{
                               tranm_csins.stype1 = 3'b010;
                               tranm_csins.cmd    = 3'b001;
                               tranm_csins.brc3_stype1_msb = 2'b00;
                            end //}    
                            else
                            begin //{
                               tranm_csins.stype1 = 3'b010;
                               tranm_csins.cmd    = 3'b000;
                               tranm_csins.brc3_stype1_msb = 2'b00;
                            end //}    
                            tranm_csins.stype0 = 4'b0100;
                            //tranm_csins.param0 =   pktm_trans.curr_rx_ackid;
                            tranm_csins.param0 =   pktm_trans.ackid_for_scs; //pkt_handler_ins.ackid;
                            if(pktm_config.multiple_ack_support)
                             tranm_csins.param0 = pktm_trans.gr_curr_tx_ackid;
                            
                            if(pktm_config.flow_control_mode == RECEIVE)
                              tranm_csins.param1 = 12'hFFF;
                            else
                            begin //{
                              if(pktm_env_config.multi_vc_support == 1'b0)
                                tranm_csins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_q.size();
                              else
                                tranm_csins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_vc0_q.size();
                            end //}
                            tranm_csins.cs_crc24 =  tranm_csins.calccrc24(tranm_csins.pack_cs());
                            void'(tranm_csins.pack_cs_bytes());  
                            merge_pkt.brc3_merged_pkt.push_back({2'b10,tranm_csins.stype0,tranm_csins.param0,tranm_csins.param1,tranm_csins.brc3_stype1_msb,2'b01,temp_data});
                            merge_pkt.brc3_merged_pkt.push_back({2'b10,tranm_csins.stype1,tranm_csins.cmd,tranm_csins.cs_crc24,2'b10,32'h0000_0000});
                            merge_pkt.m_type = MERGED_PKT; 
                            pktcs_proc_q.push_back(merge_pkt);
                          end //} 
                       end //}
                      if(pktm_trans.oes_state == 1'b1 && pktm_trans.link_initialized)
                           state = MERGE_OES_G3;
                      else if(pktm_trans.ies_state == 1'b1 && pktm_trans.link_initialized)
                           state = MERGE_IES_G3;
                       else if(pktm_trans.link_initialized && pktm_trans.ors_state == 1'b1)
                            state = MERGE_ORS_G3;
                      else if(pktm_trans.irs_state == 1'b1 && pktm_trans.link_initialized)
                           state = MERGE_IRS_G3;
                      else if(pktm_trans.ors_state == 1'b0 && pktm_trans.link_initialized)
                            state = MERGE_NORMAL_G3;
                     end //}  

       MERGE_NORMAL    : begin //{ 
                       
                         if(pl_pkt_q.size>1 && pktm_config.cs_merge_en && pktm_trans.link_initialized && ~pktm_trans.oes_state && ~pktm_trans.ors_state && pkt_avail_req && pl_outstanding_ackid_q.size() < ackid_qsize) 
                          begin //{
                             if(pktm_trans.bfm_idle_selected)
                              merge_loc=8;
                             else
                              merge_loc=4;
                             merge_pkt = new();
                             q_siz=pl_pkt_q.size();
                             for(int k=0;k<q_siz;k++)
                              begin//{
                               if(pl_gencs_q.size() != 0)
                               begin //{
                                    for(int i=0;i<pl_gencs_q.size();i++)
                                    begin //{
                                       tranm_cs_ins = new pl_gencs_q[i];
                                       if(tranm_cs_ins.stype1 == 3'b100 || tranm_cs_ins.stype1 == 3'b011 || tranm_cs_ins.stype1 == 3'b000 || tranm_cs_ins.stype1 == 3'b001 || tranm_cs_ins.stype1 == 3'b010)
                                       begin //{
                                           pl_gencs_q.delete(i);
                                           merge_cs = new();
                                           for(int i = 0;i<tranm_cs_ins.bytestream_cs.size();i++)
                                           begin //{
                                            if(i == 0)
                                             merge_cs.bs_merged_cs[i] = {1'b1,tranm_cs_ins.bytestream_cs[i]};
                                            else if((i == tranm_cs_ins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                             merge_cs.bs_merged_cs[i] = {1'b1,tranm_cs_ins.bytestream_cs[i]};
                                            else
                                             merge_cs.bs_merged_cs[i] = {1'b0,tranm_cs_ins.bytestream_cs[i]};
                                           end //}
                                           if(tranm_cs_ins.stype1 == 3'b100)
                                           begin //{
                                              merge_cs.link_req_en = 1'b1;
                                           end //}
                                           else if(tranm_cs_ins.stype1 == 3'b011)
                                           begin //{
                                              merge_cs.rst_frm_rty_en = 1'b1;
                                           end //}
                                           merge_cs.m_type = MERGED_CS;
                                           pktcs_proc_q.push_back(merge_cs);
                                       end //}
                                       else if(tranm_cs_ins.stype0 == 4'b0110 || tranm_cs_ins.stype0 == 4'b0000 || tranm_cs_ins.stype0 == 4'b0001 || tranm_cs_ins.stype0 == 4'b0010 || tranm_cs_ins.stype0 == 4'b0100 || tranm_cs_ins.stype0 == 4'b0101 )
                                       begin //{
                                          pl_gencs_q.delete(i);
                                          if(pktm_trans.bfm_idle_selected)
                                             tranm_cs_ins.cstype = CS48;
                                          else
                                             tranm_cs_ins.cstype = CS24;
                                          tranm_cs_ins.stype1 = 3'b000;
                                          tranm_cs_ins.cmd    = 3'b000;
                                          tranm_cs_ins.brc3_stype1_msb = 2'b00;
                                          if(pktm_trans.bfm_idle_selected)
                                          begin //{
                                           tranm_cs_ins.cs_crc13 =  tranm_cs_ins.calccrc13(tranm_cs_ins.pack_cs());
                                          end //}
                                          else
                                          begin //{
                                           tranm_cs_ins.cs_crc5 =  tranm_cs_ins.calccrc5(tranm_cs_ins.pack_cs());
                                          end //}
                                           if(tranm_cs_ins.stype0 == 4'b0110)
                                           begin //{
                                               merge_cs.link_resp_en = 1'b1;
                                           end //}
                                          void'(tranm_cs_ins.set_delimiter());
                                          void'(tranm_cs_ins.pack_cs_bytes());
                                          break;
                                       end   //}
                                   end   //}
                               end //}
                               else if(pl_seqcs_q.size() != 0)
                               begin //{
                                    for(int i=0;i<pl_seqcs_q.size();i++)
                                    begin //{
                                       tranm_cs_ins = new pl_seqcs_q[i];
                                       if(tranm_cs_ins.stype1 == 3'b011 || tranm_cs_ins.stype1 == 3'b100 || tranm_cs_ins.stype1 == 3'b001)
                                       begin //{
                                          pkt_can_req = 1'b1;
                                          if(~pktm_trans.bfm_idle_selected)
                                             tranm_cs_ins.cstype = CS24;
                                          else
                                             tranm_cs_ins.cstype = CS48;

                                          tranm_cs_ins.stype1 = 3'b000;
                                          tranm_cs_ins.cmd    = 3'b000;
                                          tranm_cs_ins.brc3_stype1_msb = 2'b00;
                                          tranm_cs_ins.stype0 = 4'b0100;
                                          if(pktm_trans.bfm_idle_selected)
                                           tranm_cs_ins.param0 =   pktm_trans.curr_rx_ackid; //pkt_handler_ins.ackid;
                                          else
                                           tranm_cs_ins.param0 =   pktm_trans.curr_rx_ackid; //pkt_handler_ins.ackid;
                                          if(pktm_config.multiple_ack_support)
                                           tranm_cs_ins.param0 = pktm_trans.gr_curr_tx_ackid;

                                          if(pktm_config.flow_control_mode == RECEIVE)
                                            tranm_cs_ins.param1 = 12'hFFF;
                                          else
                                          begin //{
                                            if(pktm_env_config.multi_vc_support == 1'b0)
                                              tranm_cs_ins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_q.size();
                                            else
                                              tranm_cs_ins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_vc0_q.size();
                                          end //}

                                          if(pktm_trans.bfm_idle_selected)
                                          begin //{
                                           tranm_cs_ins.cs_crc13 =  tranm_cs_ins.calccrc13(tranm_cs_ins.pack_cs());
                                          end //}
                                          else
                                          begin //{
                                           tranm_cs_ins.cs_crc5 =  tranm_cs_ins.calccrc5(tranm_cs_ins.pack_cs());
                                          end //}
                                          tranm_cs_ins.delimiter = 8'h1C;
                                        tranm_cs_ins.pack_cs_bytes();
                                          break;
                                       end //}
                                       else if(tranm_cs_ins.stype0 == 4'b0000 || tranm_cs_ins.stype0 == 4'b0001 || tranm_cs_ins.stype0 == 4'b0010 || tranm_cs_ins.stype0 == 4'b0110 || tranm_cs_ins.stype0 == 4'b0100)
                                       begin //{
                                         pl_seqcs_q.delete(i);
                                         if(~pktm_trans.bfm_idle_selected)
                                            tranm_cs_ins.cstype = CS24;
                                         else
                                            tranm_cs_ins.cstype = CS48;
                                         tranm_cs_ins.stype1 = 3'b000;
                                         tranm_cs_ins.cmd    = 3'b000;
                                         tranm_cs_ins.brc3_stype1_msb = 2'b00;
                                         if(pktm_trans.bfm_idle_selected)
                                         begin //{
                                          tranm_cs_ins.cs_crc13 =  tranm_cs_ins.calccrc13(tranm_cs_ins.pack_cs());
                                         end //}
                                         else
                                         begin //{
                                          tranm_cs_ins.cs_crc5 =  tranm_cs_ins.calccrc5(tranm_cs_ins.pack_cs());
                                         end //}
                                        void'(tranm_cs_ins.set_delimiter());
                                        void'(tranm_cs_ins.pack_cs_bytes());
                                         break;
                                       end //}
                                    end //}
                               end //}
                               else
                               begin //{
                                    reset_status_cnt();
                                    tranm_cs_ins = new();
                                    if(~pktm_trans.bfm_idle_selected)
                                       tranm_cs_ins.cstype = CS24;
                                    else
                                       tranm_cs_ins.cstype = CS48;
                                    tranm_cs_ins.stype1 = 3'b000;
                                    tranm_cs_ins.cmd    = 3'b000;
                                    tranm_cs_ins.brc3_stype1_msb = 2'b00;
                                    tranm_cs_ins.stype0 = 4'b0100;
                                    if(pktm_trans.bfm_idle_selected)
                                     tranm_cs_ins.param0 =   pktm_trans.curr_rx_ackid; //pkt_handler_ins.ackid;
                                    else 
                                     tranm_cs_ins.param0 =   pktm_trans.curr_rx_ackid; //pkt_handler_ins.ackid;
                                    if(pktm_config.multiple_ack_support)
                                     tranm_cs_ins.param0 = pktm_trans.gr_curr_tx_ackid;

                                    if(pktm_config.flow_control_mode == RECEIVE)
                                      tranm_cs_ins.param1 = 12'hfff;
                                    else
                                    begin //{
                                      if(pktm_env_config.multi_vc_support == 1'b0)
                                        tranm_cs_ins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_q.size();
                                      else
                                        tranm_cs_ins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_vc0_q.size();
                                    end //}

                                    if(pktm_trans.bfm_idle_selected)
                                    begin //{
                                     tranm_cs_ins.cs_crc13 =  tranm_cs_ins.calccrc13(tranm_cs_ins.pack_cs());
                                    end //}
                                    else
                                    begin //{
                                     tranm_cs_ins.cs_crc5 =  tranm_cs_ins.calccrc5(tranm_cs_ins.pack_cs());
                                    end //}
                                    void'(tranm_cs_ins.set_delimiter());
                                    void'(tranm_cs_ins.pack_cs_bytes());
                                 end //}
//                               begin //{
                                  //merge_pkt = new();
                                  for(int i = 0;i<tranm_cs_ins.bytestream_cs.size();i++)
                                  begin //{  
                                    if(i == 0)
                                     merge_pkt.bs_merged_pkt.push_back({1'b1,tranm_cs_ins.bytestream_cs[i]});
                                    else if((i == tranm_cs_ins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)                  
                                     merge_pkt.bs_merged_pkt.push_back({1'b1,tranm_cs_ins.bytestream_cs[i]});
                                    else  
                                     merge_pkt.bs_merged_pkt.push_back({1'b0,tranm_cs_ins.bytestream_cs[i]});
                                  end //}
//                                 begin //{
                                     tranm_pkt_ins  = new pl_pkt_q.pop_front();
                                     pktm_trans.mul_ack_max=tranm_pkt_ins.ackid;
                                     pl_outstanding_ackid_q.push_back(tranm_pkt_ins);
                                     for(int i = 0;i<tranm_pkt_ins.bytestream.size();i++)
                                     begin //{
                                       merge_pkt.bs_merged_pkt.push_back({1'b0,tranm_pkt_ins.bytestream[i]});
                                     end //}
                                    if(pktm_config.cs_embed_en)
                                    begin //{
                                      if(pktm_trans.bfm_idle_selected)
                                        merge_loc = $urandom_range(merge_loc,merge_pkt.bs_merged_pkt.size()-8);
                                      else
                                        merge_loc = $urandom_range(merge_loc,merge_pkt.bs_merged_pkt.size()-4);

                                      merge_loc = (merge_loc%4)?((merge_loc/4+1)*4) :merge_loc;
                                      embed_inc = 0;
                                      if(pl_gencs_q.size != 0)
                                      begin //{
                                           for(int i=0;i<pl_gencs_q.size();i++)
                                           begin //{
                                              tranm_gen_cs = new pl_gencs_q[0];
                                              if(tranm_gen_cs.stype1 == 3'b100 || tranm_gen_cs.stype1 == 3'b011 || tranm_gen_cs.stype1 == 3'b000 || tranm_gen_cs.stype1 == 3'b001 || tranm_gen_cs.stype1 == 3'b010)
                                              begin //{
                                                 pl_gencs_q.delete(0);
                                                  merge_cs = new();
                                                  for(int i = 0;i<tranm_gen_cs.bytestream_cs.size();i++)
                                                  begin //{
                                                   if(i == 0)
                                                    merge_cs.bs_merged_cs[i] = {1'b1,tranm_gen_cs.bytestream_cs[i]};
                                                   else if((i == tranm_gen_cs.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                                    merge_cs.bs_merged_cs[i] = {1'b1,tranm_gen_cs.bytestream_cs[i]};
                                                   else
                                                    merge_cs.bs_merged_cs[i] = {1'b0,tranm_gen_cs.bytestream_cs[i]};
                                                  end //}
                                                  if(tranm_gen_cs.stype1 == 3'b100)
                                                  begin //{
                                                     merge_cs.link_req_en = 1'b1;
                                                  end //}
                                                  else if(tranm_gen_cs.stype1 == 3'b011)
                                                  begin //{
                                                     merge_cs.rst_frm_rty_en = 1'b1;
                                                  end //}
                                                  merge_cs.m_type = MERGED_CS;
                                                  pktcs_proc_q.push_back(merge_cs);
                                              end //}
                                              else if(tranm_gen_cs.stype0 == 4'b0110)
                                              begin //{
                                                  pl_gencs_q.delete(0);
                                                  merge_cs = new();
                                                  for(int i = 0;i<tranm_gen_cs.bytestream_cs.size();i++)
                                                  begin //{
                                                   if(i == 0)
                                                    merge_cs.bs_merged_cs[i] = {1'b1,tranm_gen_cs.bytestream_cs[i]};
                                                   else if((i == tranm_gen_cs.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                                    merge_cs.bs_merged_cs[i] = {1'b1,tranm_gen_cs.bytestream_cs[i]};
                                                   else
                                                    merge_cs.bs_merged_cs[i] = {1'b0,tranm_gen_cs.bytestream_cs[i]};
                                                  end //}
                                                  if(tranm_gen_cs.stype0 == 4'b0110)
                                                  begin //{
                                                      merge_cs.link_resp_en = 1'b1;
                                                  end //}
                                                  merge_cs.m_type = MERGED_CS;
                                                  pktcs_proc_q.push_back(merge_cs);
                                              end //}
                                              else
                                              begin //{
                                                if(embed_inc)
                                                  merge_loc = pktm_trans.bfm_idle_selected?merge_loc+8:merge_loc+4;
                                                if(((tranm_gen_cs.stype0 == 4'b0000) || (tranm_gen_cs.stype0 == 4'b0001) || (tranm_gen_cs.stype0 == 4'b0010) || (tranm_gen_cs.stype0 == 4'b0100) || (tranm_gen_cs.stype0 == 4'b0101)))
                                                begin //{
                                                   pl_gencs_q.delete(0);
                                                   for(int j=0;j<tranm_gen_cs.bytestream_cs.size();j++)
                                                   begin //{
                                                      if(j == 0)
                                                       merge_pkt.bs_merged_pkt.insert(merge_loc+j,{1'b1,tranm_gen_cs.bytestream_cs[j]});
                                                      else if((j == tranm_gen_cs.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                                       merge_pkt.bs_merged_pkt.insert(merge_loc+j,{1'b1,tranm_gen_cs.bytestream_cs[j]});
                                                      else
                                                       merge_pkt.bs_merged_pkt.insert(merge_loc+j,{1'b0,tranm_gen_cs.bytestream_cs[j]});
                                                   end //}
                                                  embed_inc = 1'b1;
                                                end //}
                                                else
                                                begin //{
                                                    embed_inc = 1'b0;
                                                end //}
                                              end //}
                                           end //}
                                           if(pktm_trans.bfm_idle_selected)
                                            merge_loc=merge_pkt.bs_merged_pkt.size()+7;
                                           else
                                            merge_loc=merge_pkt.bs_merged_pkt.size()+3;
                                         end //}
                                        if(pl_seqcs_q.size != 0)
                                        begin //{
                                             for(int i=0;i<pl_seqcs_q.size;i++)
                                             begin //{
                                                tranm_seq_cs = new pl_seqcs_q[0];
                                                void'(tranm_seq_cs.set_delimiter());
                                                if(embed_inc)
                                                  merge_loc = pktm_trans.bfm_idle_selected?merge_loc+8:merge_loc+4;
                                                if(tranm_seq_cs.delimiter == 8'h1C)
                                                begin //{
                                                   pl_seqcs_q.delete(0);
                                                   tranm_seq_cs.pack_cs_bytes();
                                                   for(int j=0;j<tranm_seq_cs.bytestream_cs.size();j++)
                                                   begin //{
                                                      if(j == 0)
                                                       merge_pkt.bs_merged_pkt.insert(merge_loc+j,{1'b1,tranm_seq_cs.bytestream_cs[j]});
                                                      else if((j == tranm_seq_cs.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                                       merge_pkt.bs_merged_pkt.insert(merge_loc+j,{1'b1,tranm_seq_cs.bytestream_cs[j]});
                                                      else
                                                       merge_pkt.bs_merged_pkt.insert(merge_loc+j,{1'b0,tranm_seq_cs.bytestream_cs[j]});
                                                   end //}
                                                embed_inc = 1'b1;
                                                end //}
                                                else
                                                begin //{
                                                    embed_inc = 1'b0;
                                                end //}
                                             end //}
                                                  merge_loc = pktm_trans.bfm_idle_selected?(merge_pkt.bs_merged_pkt.size()+7):(merge_pkt.bs_merged_pkt.size()+3);
                                        end //}
                                       end //}
//                                      end //}
//                              end//}

                                 if(pl_pkt_q.size()!=0 && (merge_pkt.bs_merged_pkt.size()<3000))
                                  continue;
                                 else
                                  begin//{
                                     if(pl_gencs_q.size() != 0)
                                       begin //{
                                            for(int i=0;i<pl_gencs_q.size();i++)
                                            begin //{
                                               tranm_csins = new pl_gencs_q[i];
                                               if(tranm_csins.stype1 == 3'b100 || tranm_csins.stype1 == 3'b011 || tranm_csins.stype1 == 3'b000 || tranm_csins.stype1 == 3'b001 || tranm_csins.stype1 == 3'b010)
                                               begin //{
                                                   pl_gencs_q.delete(i);
                                                   merge_cs = new();
                                                   for(int i = 0;i<tranm_csins.bytestream_cs.size();i++)
                                                   begin //{
                                                    if(i == 0)
                                                     merge_cs.bs_merged_cs[i] = {1'b1,tranm_csins.bytestream_cs[i]};
                                                    else if((i == tranm_csins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                                     merge_cs.bs_merged_cs[i] = {1'b1,tranm_csins.bytestream_cs[i]};
                                                    else
                                                     merge_cs.bs_merged_cs[i] = {1'b0,tranm_csins.bytestream_cs[i]};
                                                   end //}
                                                   if(tranm_csins.stype1 == 3'b100)
                                                   begin //{
                                                      merge_cs.link_req_en = 1'b1;
                                                   end //}
                                                   else if(tranm_csins.stype1 == 3'b011)
                                                   begin //{
                                                      merge_cs.rst_frm_rty_en = 1'b1;
                                                   end //}
                                                   merge_cs.m_type = MERGED_CS;
                                                   pktcs_proc_q.push_back(merge_cs);
                                               end //}
                                               else if(tranm_csins.stype0 == 4'b0000 || tranm_csins.stype0 == 4'b0001 || tranm_csins.stype0 == 4'b0010 || tranm_csins.stype0 == 4'b0100 || tranm_csins.stype0 == 4'b0101 || tranm_csins.stype0 == 4'b0110)
                                               begin //{
                                                  pl_gencs_q.delete(i);
                                                  if(~pktm_trans.bfm_idle_selected)
                                                     tranm_csins.cstype = CS24;
                                                  else
                                                     tranm_csins.cstype = CS48;
                                                  tranm_csins.stype1 = 3'b010;
                                                  tranm_csins.cmd    = 3'b000;
                                                  tranm_csins.brc3_stype1_msb = 2'b00;
                                                  if(pktm_trans.bfm_idle_selected)
                                                  begin //{
                                                   tranm_csins.cs_crc13 =  tranm_csins.calccrc13(tranm_csins.pack_cs());
                                                  end //}
                                                  else
                                                  begin //{
                                                   tranm_csins.cs_crc5 =  tranm_csins.calccrc5(tranm_csins.pack_cs());
                                                  end //}
                                                   if(tranm_csins.stype0 == 4'b0110)
                                                   begin //{
                                                       merge_cs.link_resp_en = 1'b1;
                                                   end //}
                                                  void'(tranm_csins.set_delimiter());
                                                  void'(tranm_csins.pack_cs_bytes());
                                               break;
                                               end //}
                                            end  //}
                                       end //}
                                       else if(pl_seqcs_q.size() != 0)
                                       begin //{
                                            for(int i=0;i<pl_seqcs_q.size();i++)
                                            begin //{
                                               tranm_csins = new pl_seqcs_q[i];
                                                if(tranm_csins.stype0 == 4'b0000 || tranm_csins.stype0 == 4'b0001 || tranm_csins.stype0 == 4'b0010 || tranm_csins.stype0 == 4'b0110 || tranm_csins.stype0 == 4'b0100)
                                                pl_seqcs_q.delete(i);
                                                if(~pktm_trans.bfm_idle_selected)
                                                   tranm_csins.cstype = CS24;
                                                else
                                                   tranm_csins.cstype = CS48;
                                                tranm_csins.stype1 = 3'b010;
                                                tranm_csins.cmd    = 3'b000;
                                                tranm_csins.brc3_stype1_msb = 2'b00;
                                                if(pktm_trans.bfm_idle_selected)
                                                begin //{
                                                 tranm_csins.cs_crc13 =  tranm_csins.calccrc13(tranm_csins.pack_cs());
                                                end //}
                                                else
                                                begin //{
                                                 tranm_csins.cs_crc5 =  tranm_csins.calccrc5(tranm_csins.pack_cs());
                                                end //}
                                                void'(tranm_csins.set_delimiter());
                                                void'(tranm_csins.pack_cs_bytes());
                                                break;
                                            end //}
                                       end //}
                                     else
                                     begin //{
                                        reset_status_cnt();
                                        tranm_csins = new();
                                        if(~pktm_trans.bfm_idle_selected)
                                          tranm_csins.cstype = CS24;
                                        else
                                           tranm_csins.cstype = CS48;
                                        tranm_csins.stype1 = 3'b010;
                                        tranm_csins.cmd    = 3'b000;
                                        tranm_csins.brc3_stype1_msb = 2'b00;
                                        tranm_csins.stype0 = 4'b0100;
                                        if(pktm_trans.bfm_idle_selected)
                                         tranm_csins.param0 =   pktm_trans.curr_rx_ackid; //pkt_handler_ins.ackid;
                                        else
                                         tranm_csins.param0 =   pktm_trans.curr_rx_ackid; //pkt_handler_ins.ackid;
                                        if(pktm_config.multiple_ack_support)
                                         tranm_csins.param0 = pktm_trans.gr_curr_tx_ackid;

                                        if(pktm_config.flow_control_mode == RECEIVE)
                                          tranm_csins.param1 = 12'hfff;
                                        else
                                        begin //{
                                          if(pktm_env_config.multi_vc_support == 1'b0)
                                            tranm_csins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_q.size();
                                          else
                                            tranm_csins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_vc0_q.size();
                                        end //}

                                        if(pktm_trans.bfm_idle_selected)
                                        begin //{
                                         tranm_csins.cs_crc13 =  tranm_csins.calccrc13(tranm_csins.pack_cs());
                                        end //}
                                        else
                                        begin //{
                                         tranm_csins.cs_crc5 =  tranm_csins.calccrc5(tranm_csins.pack_cs());
                                        end //}
                                        void'(tranm_csins.set_delimiter());
                                        void'(tranm_csins.pack_cs_bytes());
                                      end //}
                                      for(int i=0;i<tranm_csins.bytestream_cs.size();i++)
                                      begin //{
                                       if(i == 0)
                                        merge_pkt.bs_merged_pkt.push_back({1'b1,tranm_csins.bytestream_cs[i]});
                                       else if(i == tranm_csins.bytestream_cs.size()-1 && pktm_trans.bfm_idle_selected)
                                        merge_pkt.bs_merged_pkt.push_back({1'b1,tranm_csins.bytestream_cs[i]});
                                       else
                                        merge_pkt.bs_merged_pkt.push_back({1'b0,tranm_csins.bytestream_cs[i]});
                                      end //}
                                     merge_pkt.m_type = MERGED_PKT;
                                     pktcs_proc_q.push_back(merge_pkt);
                                     if(!(merge_pkt.bs_merged_pkt.size()<3000)) 
                                      break;
                                  end //}
                              end//}
                            end//}
                         else if(pl_pkt_q.size() != 0 && pktm_config.cs_merge_en && pktm_trans.link_initialized && ~pktm_trans.oes_state && ~pktm_trans.ors_state && pkt_avail_req && pl_outstanding_ackid_q.size() < ackid_qsize) 
                           begin//{
                               if(pl_gencs_q.size() != 0)
                               begin //{
                                    for(int i=0;i<pl_gencs_q.size();i++)
                                    begin //{
                                       tranm_cs_ins = new pl_gencs_q[i];
                                       if(tranm_cs_ins.stype1 == 3'b100 || tranm_cs_ins.stype1 == 3'b011 || tranm_cs_ins.stype1 == 3'b000 || tranm_cs_ins.stype1 == 3'b001 || tranm_cs_ins.stype1 == 3'b010)
                                       begin //{
                                           pl_gencs_q.delete(i);
                                           merge_cs = new();
                                           for(int i = 0;i<tranm_cs_ins.bytestream_cs.size();i++)
                                           begin //{ 
                                            if(i == 0)
                                             merge_cs.bs_merged_cs[i] = {1'b1,tranm_cs_ins.bytestream_cs[i]};
                                            else if((i == tranm_cs_ins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                             merge_cs.bs_merged_cs[i] = {1'b1,tranm_cs_ins.bytestream_cs[i]};
                                            else
                                             merge_cs.bs_merged_cs[i] = {1'b0,tranm_cs_ins.bytestream_cs[i]};
                                           end //}
                                           if(tranm_cs_ins.stype1 == 3'b100)
                                           begin //{
                                              merge_cs.link_req_en = 1'b1;
                                           end //}
                                           else if(tranm_cs_ins.stype1 == 3'b011)
                                           begin //{
                                              merge_cs.rst_frm_rty_en = 1'b1;
                                           end //}
                                           merge_cs.m_type = MERGED_CS; 
                                           pktcs_proc_q.push_back(merge_cs);
                                       end //}
                                       else if(tranm_cs_ins.stype0 == 4'b0110 || tranm_cs_ins.stype0 == 4'b0000 || tranm_cs_ins.stype0 == 4'b0001 || tranm_cs_ins.stype0 == 4'b0010 || tranm_cs_ins.stype0 == 4'b0100 || tranm_cs_ins.stype0 == 4'b0101 )
                                       begin //{
                                          pl_gencs_q.delete(i);
                                          if(pktm_trans.bfm_idle_selected)
                                             tranm_cs_ins.cstype = CS48;
                                          else 
                                             tranm_cs_ins.cstype = CS24;
                                          tranm_cs_ins.stype1 = 3'b000;
                                          tranm_cs_ins.cmd    = 3'b000;
                                          tranm_cs_ins.brc3_stype1_msb = 2'b00; 
                                          if(pktm_trans.bfm_idle_selected)
                                          begin //{ 
                                           tranm_cs_ins.cs_crc13 =  tranm_cs_ins.calccrc13(tranm_cs_ins.pack_cs());
                                          end //}
                                          else
                                          begin //{
                                           tranm_cs_ins.cs_crc5 =  tranm_cs_ins.calccrc5(tranm_cs_ins.pack_cs());
                                          end //}  
                                          if(tranm_cs_ins.stype0 == 4'b0110)
                                          begin //{
                                              merge_cs.link_resp_en = 1'b1;
                                          end //}
                                          void'(tranm_cs_ins.set_delimiter());
                                          void'(tranm_cs_ins.pack_cs_bytes());  
                                          break;
                                       end   //}
                                   end   //}
                               end //}
                               else if(pl_seqcs_q.size() != 0)
                               begin //{
                                    for(int i=0;i<pl_seqcs_q.size();i++)
                                    begin //{
                                       reset_status_cnt();
                                       tranm_cs_ins = new pl_seqcs_q[i];
                                       if(tranm_cs_ins.stype1 == 3'b011 || tranm_cs_ins.stype1 == 3'b100 || tranm_cs_ins.stype1 == 3'b001)
                                       begin //{
                                          pkt_can_req = 1'b1;
                                          if(~pktm_trans.bfm_idle_selected)
                                             tranm_cs_ins.cstype = CS24;
                                          else 
                                             tranm_cs_ins.cstype = CS48;

                                          tranm_cs_ins.stype1 = 3'b000;
                                          tranm_cs_ins.cmd    = 3'b000;
                                          tranm_cs_ins.brc3_stype1_msb = 2'b00; 
                                          tranm_cs_ins.stype0 = 4'b0100;
                                          if(pktm_trans.bfm_idle_selected)
                                           tranm_cs_ins.param0 =   pktm_trans.curr_rx_ackid; //pkt_handler_ins.ackid;
                                          else
                                           tranm_cs_ins.param0 =   pktm_trans.curr_rx_ackid; //pkt_handler_ins.ackid;
                                          if(pktm_config.multiple_ack_support)
                                           tranm_cs_ins.param0 = pktm_trans.gr_curr_tx_ackid;

                                          if(pktm_config.flow_control_mode == RECEIVE)
                                            tranm_cs_ins.param1 = 12'hFFF;
                                          else
                                          begin //{
                                            if(pktm_env_config.multi_vc_support == 1'b0)
                                              tranm_cs_ins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_q.size();
                                            else
                                              tranm_cs_ins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_vc0_q.size();
                                          end //}

                                          if(pktm_trans.bfm_idle_selected)
                                          begin //{ 
                                           tranm_cs_ins.cs_crc13 =  tranm_cs_ins.calccrc13(tranm_cs_ins.pack_cs());
                                          end //}
                                          else
                                          begin //{
                                           tranm_cs_ins.cs_crc5 =  tranm_cs_ins.calccrc5(tranm_cs_ins.pack_cs());
                                          end //}  
                                          tranm_cs_ins.delimiter = 8'h1C;
                                          tranm_cs_ins.pack_cs_bytes();  
                                          break;
                                       end //}
                                       else if(tranm_cs_ins.stype0 == 4'b0000 || tranm_cs_ins.stype0 == 4'b0001 || tranm_cs_ins.stype0 == 4'b0010 || tranm_cs_ins.stype0 == 4'b0110 || tranm_cs_ins.stype0 == 4'b0100)
                                       begin //{
                                         pl_seqcs_q.delete(i);
                                         if(~pktm_trans.bfm_idle_selected)
                                            tranm_cs_ins.cstype = CS24;
                                         else 
                                            tranm_cs_ins.cstype = CS48;
                                         tranm_cs_ins.stype1 = 3'b000;
                                         tranm_cs_ins.cmd    = 3'b000;
                                         tranm_cs_ins.brc3_stype1_msb = 2'b00; 
                                         if(pktm_trans.bfm_idle_selected)
                                         begin //{ 
                                          tranm_cs_ins.cs_crc13 =  tranm_cs_ins.calccrc13(tranm_cs_ins.pack_cs());
                                         end //}
                                         else
                                         begin //{
                                          tranm_cs_ins.cs_crc5 =  tranm_cs_ins.calccrc5(tranm_cs_ins.pack_cs());
                                         end //}  
                                        void'(tranm_cs_ins.set_delimiter());
                                        void'(tranm_cs_ins.pack_cs_bytes());  
                                         break;    
                                       end //}
                                    end //}
                               end //}
                               else 
                               begin //{
                                    reset_status_cnt();
                                    tranm_cs_ins = new();
                                    if(~pktm_trans.bfm_idle_selected)
                                       tranm_cs_ins.cstype = CS24;
                                    else 
                                       tranm_cs_ins.cstype = CS48;
                                    tranm_cs_ins.stype1 = 3'b000;
                                    tranm_cs_ins.cmd    = 3'b000;
                                    tranm_cs_ins.brc3_stype1_msb = 2'b00; 
                                    tranm_cs_ins.stype0 = 4'b0100;
                                    if(pktm_trans.bfm_idle_selected)
                                     tranm_cs_ins.param0 =   pktm_trans.curr_rx_ackid; //pkt_handler_ins.ackid;
                                    else
                                     tranm_cs_ins.param0 =   pktm_trans.curr_rx_ackid; //pkt_handler_ins.ackid;
                                    if(pktm_config.multiple_ack_support)
                                     tranm_cs_ins.param0 = pktm_trans.gr_curr_tx_ackid;
                                    
                                    if(pktm_config.flow_control_mode == RECEIVE)
                                      tranm_cs_ins.param1 = 12'hfff;
                                    else
                                    begin //{
                                      if(pktm_env_config.multi_vc_support == 1'b0)
                                        tranm_cs_ins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_q.size();
                                      else
                                        tranm_cs_ins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_vc0_q.size();
                                    end //}

                                    if(pktm_trans.bfm_idle_selected)
                                    begin //{ 
                                     tranm_cs_ins.cs_crc13 =  tranm_cs_ins.calccrc13(tranm_cs_ins.pack_cs());
                                    end //}
                                    else
                                    begin //{
                                     tranm_cs_ins.cs_crc5 =  tranm_cs_ins.calccrc5(tranm_cs_ins.pack_cs());
                                    end //}  
                                    void'(tranm_cs_ins.set_delimiter());
                                    void'(tranm_cs_ins.pack_cs_bytes());  
                               end //}
/*                               if(pkt_can_req)
                               begin //{
                                  pkt_can_req = 1'b0; 
                                  merge_pkt = new();
                                  for(int i = 0;i<tranm_cs_ins.bytestream_cs.size();i++)
                                  begin //{ 
                                    if(i == 0)
                                     merge_pkt.bs_merged_pkt.push_back({1'b1,tranm_cs_ins.bytestream_cs[i]});
                                    else if((i == tranm_cs_ins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                     merge_pkt.bs_merged_pkt.push_back({1'b1,tranm_cs_ins.bytestream_cs[i]});
                                    else
                                     merge_pkt.bs_merged_pkt.push_back({1'b0,tranm_cs_ins.bytestream_cs[i]});
                                  end //}
                                  tranm_pkt_ins  = new pl_pkt_q.pop_front();
                                  pl_outstanding_ackid_q.push_back(tranm_pkt_ins);
                                  for(int i = 0;i<8;i++)
                                  begin //{
                                    merge_pkt.bs_merged_pkt.push_back({1'b0,tranm_pkt_ins.bytestream[i]});
                                  end //}
                                  if(pl_seqcs_q.size() != 0)
                                  begin //{
                                     can_trans_ins = new pl_seqcs_q[0];
                                     pl_seqcs_q.delete(0);
                                     if(pktm_trans.bfm_idle_selected)
                                     begin //{ 
                                      can_trans_ins.cs_crc13 =  can_trans_ins.calccrc13(can_trans_ins.pack_cs());
                                     end //}
                                     else
                                     begin //{
                                      can_trans_ins.cs_crc5 =  can_trans_ins.calccrc5(can_trans_ins.pack_cs());
                                     end //}  
                                     can_trans_ins.delimiter = 8'h7C;
                                     void'(can_trans_ins.pack_cs_bytes());  
                                     for(int i = 0;i<can_trans_ins.bytestream_cs.size();i++)
                                     begin //{ 
                                       if(i == 0)
                                        merge_pkt.bs_merged_pkt[i] = {1'b1,can_trans_ins.bytestream_cs[i]};
                                       else if((i == can_trans_ins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                        merge_pkt.bs_merged_pkt[i] = {1'b1,can_trans_ins.bytestream_cs[i]};
                                       else
                                        merge_pkt.bs_merged_pkt[i] = {1'b0,can_trans_ins.bytestream_cs[i]};
                                     end //}
                                     merge_pkt.m_type = MERGED_PKT; 
                                     pktcs_proc_q.push_back(merge_pkt);
                                  end //} 
                               end //}
                               else*/ 
                               begin //{  
                                 merge_pkt = new();
                                 for(int i = 0;i<tranm_cs_ins.bytestream_cs.size();i++)
                                 begin //{ 
                                   if(i == 0)
                                    merge_pkt.bs_merged_pkt[i] = {1'b1,tranm_cs_ins.bytestream_cs[i]};
                                   else if((i == tranm_cs_ins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                    merge_pkt.bs_merged_pkt[i] = {1'b1,tranm_cs_ins.bytestream_cs[i]};
                                   else
                                    merge_pkt.bs_merged_pkt[i] = {1'b0,tranm_cs_ins.bytestream_cs[i]};
                                 end //}
/*                                 if(pktm_trans.ies_state || pktm_trans.irs_state)
                                 begin //{
                                   gen_stomp_cs();
                                   tranm_pkt_ins  = new pl_pkt_q.pop_front();
                                   pl_outstanding_ackid_q.push_back(tranm_pkt_ins);
                                   for(int i = 0;i<8;i++)
                                   begin //{
                                     merge_pkt.bs_merged_pkt.push_back({1'b0,tranm_pkt_ins.bytestream[i]});
                                   end //}
                                   for(int i=0;i<trans_push_ins.bytestream_cs.size();i++)
                                   begin //{ 
                                    if(i == 0)
                                     merge_pkt.bs_merged_pkt.push_back({1'b1,trans_push_ins.bytestream_cs[i]});
                                    else if(i == trans_push_ins.bytestream_cs.size()-1 && pktm_trans.bfm_idle_selected)
                                     merge_pkt.bs_merged_pkt.push_back({1'b1,trans_push_ins.bytestream_cs[i]});
                                    else
                                     merge_pkt.bs_merged_pkt.push_back({1'b0,trans_push_ins.bytestream_cs[i]});
                                   end //}
                                 merge_pkt.m_type = MERGED_PKT; 
                                 pktcs_proc_q.push_back(merge_pkt);
                                 end //}
                                 else */
                                 begin //{
                                     tranm_pkt_ins  = new pl_pkt_q.pop_front();
                                     pktm_trans.mul_ack_max=tranm_pkt_ins.ackid;
                                     pl_outstanding_ackid_q.push_back(tranm_pkt_ins);
                                     for(int i = 0;i<tranm_pkt_ins.bytestream.size();i++)
                                     begin //{
                                       merge_pkt.bs_merged_pkt.push_back({1'b0,tranm_pkt_ins.bytestream[i]});
                                     end //}
                                    if(pktm_config.cs_embed_en)
                                    begin //{
                                      if(pktm_trans.bfm_idle_selected)
                                        merge_loc = $urandom_range(8,merge_pkt.bs_merged_pkt.size()-8);
                                      else 
                                        merge_loc = $urandom_range(4,merge_pkt.bs_merged_pkt.size()-4);

                                      merge_loc = (merge_loc%4)?((merge_loc/4+1)*4) :merge_loc;
                                      embed_inc = 0;
                                      if(pl_gencs_q.size != 0)
                                      begin //{
                                           for(int i=0;i<pl_gencs_q.size();i++)
                                           begin //{
                                              tranm_gen_cs = new pl_gencs_q[i];
                                              if(tranm_gen_cs.stype1 == 3'b100 || tranm_gen_cs.stype1 == 3'b011 || tranm_gen_cs.stype1 == 3'b000 || tranm_gen_cs.stype1 == 3'b001 || tranm_gen_cs.stype1 == 3'b010)
                                              begin //{
                                                  pl_gencs_q.delete(i);
                                                  merge_cs = new();
                                                  for(int i = 0;i<tranm_gen_cs.bytestream_cs.size();i++)
                                                  begin //{ 
                                                   if(i == 0)
                                                    merge_cs.bs_merged_cs[i] = {1'b1,tranm_gen_cs.bytestream_cs[i]};
                                                   else if((i == tranm_gen_cs.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                                    merge_cs.bs_merged_cs[i] = {1'b1,tranm_gen_cs.bytestream_cs[i]};
                                                   else
                                                    merge_cs.bs_merged_cs[i] = {1'b0,tranm_gen_cs.bytestream_cs[i]};
                                                  end //}
                                                  if(tranm_gen_cs.stype1 == 3'b100)
                                                  begin //{
                                                     merge_cs.link_req_en = 1'b1;
                                                  end //}
                                                  else if(tranm_gen_cs.stype1 == 3'b011)
                                                  begin //{
                                                     merge_cs.rst_frm_rty_en = 1'b1;
                                                  end //}
                                                  merge_cs.m_type = MERGED_CS; 
                                                  pktcs_proc_q.push_back(merge_cs);
                                              end //}
                                              else if(tranm_gen_cs.stype0 == 4'b0110)
                                              begin //{
                                                  pl_gencs_q.delete(i);
                                                  merge_cs = new();
                                                  for(int i = 0;i<tranm_gen_cs.bytestream_cs.size();i++)
                                                  begin //{ 
                                                   if(i == 0)
                                                    merge_cs.bs_merged_cs[i] = {1'b1,tranm_gen_cs.bytestream_cs[i]};
                                                   else if((i == tranm_gen_cs.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                                    merge_cs.bs_merged_cs[i] = {1'b1,tranm_gen_cs.bytestream_cs[i]};
                                                   else
                                                    merge_cs.bs_merged_cs[i] = {1'b0,tranm_gen_cs.bytestream_cs[i]};
                                                  end //}
                                                  if(tranm_gen_cs.stype0 == 4'b0110)
                                                  begin //{
                                                      merge_cs.link_resp_en = 1'b1;
                                                  end //}
                                                  merge_cs.m_type = MERGED_CS; 
                                                  pktcs_proc_q.push_back(merge_cs);
                                              end //}
                                              else
                                              begin //{
                                                if(embed_inc)
                                                  merge_loc = pktm_trans.bfm_idle_selected?merge_loc+8:merge_loc+4;
                                                if(((tranm_gen_cs.stype0 == 4'b0000) || (tranm_gen_cs.stype0 == 4'b0001) || (tranm_gen_cs.stype0 == 4'b0010) || (tranm_gen_cs.stype0 == 4'b0100) || (tranm_gen_cs.stype0 == 4'b0101)))
                                                begin //{
                                                   pl_gencs_q.delete(i);
                                                   for(int j=0;j<tranm_gen_cs.bytestream_cs.size();j++)
                                                   begin //{
                                                      if(j == 0)
                                                       merge_pkt.bs_merged_pkt.insert(merge_loc+j,{1'b1,tranm_gen_cs.bytestream_cs[j]});
                                                      else if((j == tranm_gen_cs.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                                       merge_pkt.bs_merged_pkt.insert(merge_loc+j,{1'b1,tranm_gen_cs.bytestream_cs[j]});
                                                      else
                                                       merge_pkt.bs_merged_pkt.insert(merge_loc+j,{1'b0,tranm_gen_cs.bytestream_cs[j]});
                                                   end //} 
                                                  embed_inc = 1'b1;
                                                end //}
                                                else 
                                                begin //{
                                                    embed_inc = 1'b0;
                                                end //} 
                                              end //}
                                           end //}       
                                        end //}
                                        if(pl_seqcs_q.size != 0)
                                        begin //{
                                             for(int i=0;i<pl_seqcs_q.size;i++)
                                             begin //{
                                                tranm_seq_cs = new pl_seqcs_q[i];
                                                void'(tranm_seq_cs.set_delimiter());
                                                if(embed_inc)
                                                  merge_loc = pktm_trans.bfm_idle_selected?merge_loc+8:merge_loc+4;
                                                if(tranm_seq_cs.delimiter == 8'h1C)
                                                begin //{
                                                   pl_seqcs_q.delete(i);
                                                   tranm_seq_cs.pack_cs_bytes();
                                                   for(int j=0;j<tranm_seq_cs.bytestream_cs.size();j++)
                                                   begin //{
                                                      if(j == 0)
                                                       merge_pkt.bs_merged_pkt.insert(merge_loc+j,{1'b1,tranm_seq_cs.bytestream_cs[j]});
                                                      else if((j == tranm_seq_cs.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                                       merge_pkt.bs_merged_pkt.insert(merge_loc+j,{1'b1,tranm_seq_cs.bytestream_cs[j]});
                                                      else
                                                       merge_pkt.bs_merged_pkt.insert(merge_loc+j,{1'b0,tranm_seq_cs.bytestream_cs[j]});
                                                   end //} 
                                                embed_inc = 1'b1;
                                                end //}
                                                else 
                                                begin //{
                                                    embed_inc = 1'b0;
                                                end //} 
                                             end //}       
                                        end //}
                                       end //}
//if(pl_pkt_q.size()!=0)
//continue;
                                       if(pl_gencs_q.size() != 0)
                                       begin //{
                                            for(int i=0;i<pl_gencs_q.size();i++)
                                            begin //{
                                               tranm_csins = new pl_gencs_q[i];
                                               if(tranm_csins.stype1 == 3'b100 || tranm_csins.stype1 == 3'b011 || tranm_csins.stype1 == 3'b000 || tranm_csins.stype1 == 3'b001 || tranm_csins.stype1 == 3'b010)
                                               begin //{
                                                   pl_gencs_q.delete(i);
                                                   merge_cs = new();
                                                   for(int i = 0;i<tranm_csins.bytestream_cs.size();i++)
                                                   begin //{ 
                                                    if(i == 0)
                                                     merge_cs.bs_merged_cs[i] = {1'b1,tranm_csins.bytestream_cs[i]};
                                                    else if((i == tranm_csins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                                     merge_cs.bs_merged_cs[i] = {1'b1,tranm_csins.bytestream_cs[i]};
                                                    else
                                                     merge_cs.bs_merged_cs[i] = {1'b0,tranm_csins.bytestream_cs[i]};
                                                   end //}
                                                   if(tranm_csins.stype1 == 3'b100)
                                                   begin //{
                                                      merge_cs.link_req_en = 1'b1;
                                                   end //}
                                                   else if(tranm_csins.stype1 == 3'b011)
                                                   begin //{
                                                      merge_cs.rst_frm_rty_en = 1'b1;
                                                   end //}
                                                   merge_cs.m_type = MERGED_CS; 
                                                   pktcs_proc_q.push_back(merge_cs);
                                               end //}
                                               else if(tranm_csins.stype0 == 4'b0000 || tranm_csins.stype0 == 4'b0001 || tranm_csins.stype0 == 4'b0010 || tranm_csins.stype0 == 4'b0100 || tranm_csins.stype0 == 4'b0101 ||tranm_csins.stype0 == 4'b0110)
                                               begin //{
                                                  pl_gencs_q.delete(i);
                                                  if(~pktm_trans.bfm_idle_selected)
                                                     tranm_csins.cstype = CS24;
                                                  else 
                                                     tranm_csins.cstype = CS48;
                                                  tranm_csins.stype1 = 3'b010;
                                                  tranm_csins.cmd    = 3'b000;
                                                  tranm_cs_ins.brc3_stype1_msb = 2'b00; 
                                                  if(pktm_trans.bfm_idle_selected)
                                                  begin //{ 
                                                   tranm_csins.cs_crc13 =  tranm_csins.calccrc13(tranm_csins.pack_cs());
                                                  end //}
                                                  else
                                                  begin //{
                                                   tranm_csins.cs_crc5 =  tranm_csins.calccrc5(tranm_csins.pack_cs());
                                                  end //}  
                                                  if(tranm_csins.stype0 == 4'b0110)
                                                  begin //{
                                                      merge_cs.link_resp_en = 1'b1;
                                                  end //}
                                                  void'(tranm_csins.set_delimiter());
                                                  void'(tranm_csins.pack_cs_bytes());  
                                                  break;
                                               end //}    
                                            end  //}
                                       end //}
                                       else if(pl_seqcs_q.size() != 0)
                                       begin //{
                                            for(int i=0;i<pl_seqcs_q.size();i++)
                                            begin //{
                                               tranm_csins = new pl_seqcs_q[i];
                                                if(tranm_csins.stype0 == 4'b0000 || tranm_csins.stype0 == 4'b0001 || tranm_csins.stype0 == 4'b0010 || tranm_csins.stype0 == 4'b0110 || tranm_csins.stype0 == 4'b0100)
                                                pl_seqcs_q.delete(i);
                                                if(~pktm_trans.bfm_idle_selected)
                                                   tranm_csins.cstype = CS24;
                                                else 
                                                   tranm_csins.cstype = CS48;
                                                tranm_csins.stype1 = 3'b010;
                                                tranm_csins.cmd    = 3'b000;
                                                tranm_csins.brc3_stype1_msb = 2'b00; 
                                                if(pktm_trans.bfm_idle_selected)
                                                begin //{ 
                                                 tranm_csins.cs_crc13 =  tranm_csins.calccrc13(tranm_csins.pack_cs());
                                                end //}
                                                else
                                                begin //{
                                                 tranm_csins.cs_crc5 =  tranm_csins.calccrc5(tranm_csins.pack_cs());
                                                end //}  
                                                void'(tranm_csins.set_delimiter());
                                                void'(tranm_csins.pack_cs_bytes());  
                                                break;    
                                            end //}
                                       end //}
                                     else 
                                     begin //{ 
                                        reset_status_cnt();
                                        tranm_csins = new();
                                        if(~pktm_trans.bfm_idle_selected)
                                          tranm_csins.cstype = CS24;
                                        else 
                                           tranm_csins.cstype = CS48;
                                        tranm_csins.stype1 = 3'b010;
                                        tranm_csins.cmd    = 3'b000;
                                        tranm_csins.brc3_stype1_msb = 2'b00; 
                                        tranm_csins.stype0 = 4'b0100;
                                        if(pktm_trans.bfm_idle_selected)
                                         tranm_csins.param0 =   pktm_trans.curr_rx_ackid; //pkt_handler_ins.ackid;
                                        else
                                         tranm_csins.param0 =   pktm_trans.curr_rx_ackid; //pkt_handler_ins.ackid;
                                        if(pktm_config.multiple_ack_support)
                                         tranm_csins.param0 = pktm_trans.gr_curr_tx_ackid;
                                        
                                        if(pktm_config.flow_control_mode == RECEIVE)
                                          tranm_csins.param1 = 12'hfff;
                                        else
                                        begin //{
                                          if(pktm_env_config.multi_vc_support == 1'b0)
                                            tranm_csins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_q.size();
                                          else
                                            tranm_csins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_vc0_q.size();
                                        end //}
                                              
                                        if(pktm_trans.bfm_idle_selected)
                                        begin //{ 
                                         tranm_csins.cs_crc13 =  tranm_csins.calccrc13(tranm_csins.pack_cs());
                                        end //}
                                        else
                                        begin //{
                                         tranm_csins.cs_crc5 =  tranm_csins.calccrc5(tranm_csins.pack_cs());
                                        end //} 
                                        void'(tranm_csins.set_delimiter());
                                        void'(tranm_csins.pack_cs_bytes());  
                                      end //}  
                                      for(int i=0;i<tranm_csins.bytestream_cs.size();i++)
                                      begin //{ 
                                       if(i == 0)
                                        merge_pkt.bs_merged_pkt.push_back({1'b1,tranm_csins.bytestream_cs[i]});
                                       else if(i == tranm_csins.bytestream_cs.size()-1 && pktm_trans.bfm_idle_selected)
                                        merge_pkt.bs_merged_pkt.push_back({1'b1,tranm_csins.bytestream_cs[i]});
                                       else
                                        merge_pkt.bs_merged_pkt.push_back({1'b0,tranm_csins.bytestream_cs[i]});
                                      end //}
                                     merge_pkt.m_type = MERGED_PKT; 
                                     pktcs_proc_q.push_back(merge_pkt);
                                end //}
                             end //}
                          end //}  
                          else
                          begin //{
                              if(pl_gencs_q.size() != 0 &&  pktm_trans.link_initialized)
                              begin //{
                                    int q_siz=pl_gencs_q.size();
                                    for(int j=0;j<pl_gencs_q.size();j++)
                                    begin //{
                                        int lcl_index=0;
                                        merge_cs = new();
                                        tranm_gen_ins = new pl_gencs_q[j];
                                        if(tranm_gen_ins.stype0==4'b0011)
                                         begin //{
                                          for(int j=0;j<q_siz;j++)
                                           begin//{
                                             tranm_gen_ins = new pl_gencs_q[j];
                                             for(int i = 0;i<tranm_gen_ins.bytestream_cs.size();i++)
                                             begin //{ 
                                              if(i == 0)
                                               merge_cs.bs_merged_cs[lcl_index+i] = {1'b1,tranm_gen_ins.bytestream_cs[i]};
                                              else if((i == tranm_gen_ins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                               merge_cs.bs_merged_cs[lcl_index+i] = {1'b1,tranm_gen_ins.bytestream_cs[i]};
                                              else
                                               merge_cs.bs_merged_cs[lcl_index+i] = {1'b0,tranm_gen_ins.bytestream_cs[i]};
                                             end //}
                                             lcl_index= (pktm_trans.bfm_idle_selected)?(lcl_index+8):(lcl_index+4);
                                           end//}
                                           merge_cs.m_type = MERGED_CS; 
                                           pktcs_proc_q.push_back(merge_cs);
                                         local_clr=1;
                                         end//}
                                         if(local_clr)
                                         begin//{
                                         pl_gencs_q.delete();
                                         local_clr=0;
                                         end//}
				    end //}
                                    merge_cs = new();
                                    for(int i=0;i<pl_gencs_q.size();i++)
                                    begin //{
                                        tranm_gen_ins = new pl_gencs_q[0];
                                        pl_gencs_q.delete(0);
                                        if(tranm_gen_ins.stype0 == 4'b0100 && tranm_gen_ins.stype1 == 3'b111)
                                        begin //{
                                            cs_txt = 1'b1;
                                            for(int j=0;j<pl_gencs_q.size();j++)
                                            begin//{
                                               del_stcs_ins =  new pl_gencs_q[j];
                                               if(del_stcs_ins.stype0 == 4'b0100 && del_stcs_ins.stype1 == 3'b111)
                                                  pl_gencs_q.delete(j); 
                                            end //} 
                                        end //} 
                                        else
                                           cs_txt = 1'b0;
                                    if(tranm_gen_ins.stype1 == 3'b100 || tranm_gen_ins.stype1 == 3'b011 || tranm_gen_ins.stype0 == 4'b0110)
                                     begin //{ 
                                      if(cs_packed)
                                        begin //{ 
                                         cs_packed=0;
                                         merge_cs.m_type = MERGED_CS; 
                                         pktcs_proc_q.push_back(merge_cs);
                                        end //}
                                        merge_cs = new();
                                        for(int i = 0;i<tranm_gen_ins.bytestream_cs.size();i++)
                                        begin //{ 
                                         if(i == 0)
                                          merge_cs.bs_merged_cs.push_back({1'b1,tranm_gen_ins.bytestream_cs[i]});
                                         else if((i == tranm_gen_ins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                          merge_cs.bs_merged_cs.push_back({1'b1,tranm_gen_ins.bytestream_cs[i]});
                                         else
                                          merge_cs.bs_merged_cs.push_back({1'b0,tranm_gen_ins.bytestream_cs[i]});
                                        end //}
                                        if(tranm_gen_ins.stype1 == 3'b100)
                                        begin //{
                                           merge_cs.link_req_en = 1'b1;
                                        end //}
                                        else if(tranm_gen_ins.stype1 == 3'b011)
                                        begin //{
                                           merge_cs.rst_frm_rty_en = 1'b1;
                                        end //}
                                        if(tranm_gen_ins.stype0 == 4'b0110)
                                        begin //{
                                            merge_cs.link_resp_en = 1'b1;
                                        end //}
                                        merge_cs.m_type = MERGED_CS; 
                                        pktcs_proc_q.push_back(merge_cs);
                                        break;
                                     end //}
                                    else
                                     begin //{ 
                                        for(int i = 0;i<tranm_gen_ins.bytestream_cs.size();i++)
                                        begin //{ 
                                         cs_packed=1;
                                         if(i == 0)
                                          merge_cs.bs_merged_cs.push_back({1'b1,tranm_gen_ins.bytestream_cs[i]});
                                         else if((i == tranm_gen_ins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                          merge_cs.bs_merged_cs.push_back({1'b1,tranm_gen_ins.bytestream_cs[i]});
                                         else
                                          merge_cs.bs_merged_cs.push_back({1'b0,tranm_gen_ins.bytestream_cs[i]});
                                        end //}
                                        if(tranm_gen_ins.stype1 == 3'b100)
                                        begin //{
                                           merge_cs.link_req_en = 1'b1;
                                        end //}
                                        else if(tranm_gen_ins.stype1 == 3'b011)
                                        begin //{
                                           merge_cs.rst_frm_rty_en = 1'b1;
                                        end //}
                                        if(tranm_gen_ins.stype0 == 4'b0110)
                                        begin //{
                                            merge_cs.link_resp_en = 1'b1;
                                        end //}
                                        if(cs_txt)
                                           merge_cs.cs_txt = 1'b1;
                                     end //}
                                 end //}
                                if(cs_packed)
                                 begin //{ 
                                        cs_packed=0;
                                        merge_cs.m_type = MERGED_CS; 
                                        pktcs_proc_q.push_back(merge_cs);
                                    end //}
                              end //}  
                              if(pl_seqcs_q.size() != 0 &&  pktm_trans.link_initialized)
                              begin //{
                               for(int i=0;i<pl_seqcs_q.size();i++)
                                begin //{
                                tranm_seq_ins = new(); 
                                tranm_seq_ins = pl_seqcs_q[0];
                                pl_seqcs_q.delete(0);
                                 merge_cs = new();
                                 if(tranm_seq_ins.stype1 == 3'b100 || tranm_seq_ins.stype1 == 3'b011 || tranm_seq_ins.stype0 == 4'b0110)
                                  begin //{ 
                                   if(cs_packed)
                                    begin //{ 
                                     cs_packed=0;
                                     merge_cs.m_type = MERGED_CS; 
                                     pktcs_proc_q.push_back(merge_cs);
                                    end //}
                                merge_cs = new();
                                for(int i = 0;i<tranm_seq_ins.bytestream_cs.size();i++)
                                begin //{ 
                                 if(i == 0)
                                    merge_cs.bs_merged_cs.push_back({1'b1,tranm_seq_ins.bytestream_cs[i]});
                                 else if((i == tranm_seq_ins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                    merge_cs.bs_merged_cs.push_back({1'b1,tranm_seq_ins.bytestream_cs[i]});
                                 else
                                    merge_cs.bs_merged_cs.push_back({1'b0,tranm_seq_ins.bytestream_cs[i]});
                                end //}
                                if(tranm_seq_ins.stype1 == 3'b100)
                                begin //{
                                   merge_cs.link_req_en = 1'b1;
                                end //}
                                else if(tranm_seq_ins.stype1 == 3'b011)
                                begin //{
                                   merge_cs.rst_frm_rty_en = 1'b1;
                                end //}
                                if(tranm_seq_ins.stype0 == 4'b0110)
                                begin //{
                                    merge_cs.link_resp_en = 1'b1;
                                end //}
                                  merge_cs.m_type = MERGED_CS; 
                                  pktcs_proc_q.push_back(merge_cs);
                                  break;
                                 end //}
                                else
                                 begin//{
                                  for(int i = 0;i<tranm_seq_ins.bytestream_cs.size();i++)
                                   begin //{ 
                                    cs_packed=1;
                                    if(i == 0)
                                     merge_cs.bs_merged_cs.push_back({1'b1,tranm_seq_ins.bytestream_cs[i]});
                                    else if((i == tranm_seq_ins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                     merge_cs.bs_merged_cs.push_back({1'b1,tranm_seq_ins.bytestream_cs[i]});
                                    else
                                     merge_cs.bs_merged_cs.push_back({1'b0,tranm_seq_ins.bytestream_cs[i]});
                                   end //}
                                   if(tranm_seq_ins.stype1 == 3'b100)
                                   begin //{
                                      merge_cs.link_req_en = 1'b1;
                                   end //}
                                   else if(tranm_seq_ins.stype1 == 3'b011)
                                   begin //{
                                      merge_cs.rst_frm_rty_en = 1'b1;
                                   end //}
                                   if(tranm_seq_ins.stype0 == 4'b0110)
                                   begin //{
                                       merge_cs.link_resp_en = 1'b1;
                                   end //}
                                  end//}
                                end //} 
                                if(cs_packed)
                                 begin //{ 
                                  cs_packed=0;
                                merge_cs.m_type = MERGED_CS; 
                                pktcs_proc_q.push_back(merge_cs);
                                end //}
                          end //} 
                          if(pl_gencs_q.size() != 0 &&  ~pktm_trans.link_initialized && pktm_trans.port_initialized)
                          begin //{
                            //tranm_gen_ins = new(); 
                            tranm_gen_ins = new pl_gencs_q[0];
                            pl_gencs_q.delete(0);
                            merge_cs = new();
                            for(int i = 0;i<tranm_gen_ins.bytestream_cs.size();i++)
                            begin //{ 
                             if(i == 0)
                              merge_cs.bs_merged_cs[i] = {1'b1,tranm_gen_ins.bytestream_cs[i]};
                             else if((i == tranm_gen_ins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                              merge_cs.bs_merged_cs[i] = {1'b1,tranm_gen_ins.bytestream_cs[i]};
                             else
                              merge_cs.bs_merged_cs[i] = {1'b0,tranm_gen_ins.bytestream_cs[i]};
                            end //}
                            if(tranm_gen_ins.stype1 == 3'b100)
                            begin //{
                               merge_cs.link_req_en = 1'b1;
                            end //}
                            else if(tranm_gen_ins.stype1 == 3'b011)
                            begin //{
                               merge_cs.rst_frm_rty_en = 1'b1;
                            end //}
                            if(tranm_gen_ins.stype0 == 4'b0110)
                            begin //{
                                merge_cs.link_resp_en = 1'b1;
                            end //}
                            merge_cs.m_type = MERGED_CS; 
                            pktcs_proc_q.push_back(merge_cs);
                          end //}
                          end //}
                       if(pktm_trans.oes_state == 1'b1 && pktm_trans.link_initialized)
                             state = MERGE_OES;
                       else if(pktm_trans.ies_state == 1'b1 && pktm_trans.link_initialized)
                            state = MERGE_IES;
                       else if(pktm_trans.ors_state == 1'b1 && pktm_trans.link_initialized)
                            state = MERGE_ORS;
                       else if(pktm_trans.irs_state == 1'b1 && pktm_trans.link_initialized)
                            state = MERGE_IRS;
                        else if(pktm_trans.link_initialized)
                             state = MERGE_NORMAL;
                        else if(pktm_trans.port_initialized)
                             state = MERGE_NORMAL;
                        end //}

     MERGE_OES    :    begin //{
                       if(pktm_trans.oes_state)
                       begin //{ 
                          if(pl_gencs_q.size() != 0 &&  pktm_trans.port_initialized)
                          begin //{
                          if(pl_gencs_q.size() != 0 &&  pktm_trans.port_initialized)
                            tranm_gen_ins = new(); 
                            tranm_gen_ins = pl_gencs_q[0];
                            pl_gencs_q.delete(0);
                            merge_cs = new();
                            for(int i = 0;i<tranm_gen_ins.bytestream_cs.size();i++)
                            begin //{ 
                             if(i == 0)
                              merge_cs.bs_merged_cs[i] = {1'b1,tranm_gen_ins.bytestream_cs[i]};
                             else if((i == tranm_gen_ins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                              merge_cs.bs_merged_cs[i] = {1'b1,tranm_gen_ins.bytestream_cs[i]};
                             else
                              merge_cs.bs_merged_cs[i] = {1'b0,tranm_gen_ins.bytestream_cs[i]};
                            end //}
                            if(tranm_gen_ins.stype1 == 3'b100)
                            begin //{
                               merge_cs.link_req_en = 1'b1;
                            end //}
                            else if(tranm_gen_ins.stype1 == 3'b011)
                            begin //{
                               merge_cs.rst_frm_rty_en = 1'b1;
                            end //}
                            if(tranm_gen_ins.stype0 == 4'b0110)
                            begin //{
                                merge_cs.link_resp_en = 1'b1;
                            end //}
                            merge_cs.m_type = MERGED_CS; 
                            pktcs_proc_q.push_back(merge_cs);
                          end //}
                         if(pl_seqcs_q.size() != 0 &&  pktm_trans.port_initialized)
                         begin //{
                           tranm_seq_ins = new(); 
                           tranm_seq_ins = pl_seqcs_q[0];
                           pl_seqcs_q.delete(0);
                           merge_cs = new();
                           for(int i = 0;i<tranm_seq_ins.bytestream_cs.size();i++)
                           begin //{ 
                            if(i == 0)
                             merge_cs.bs_merged_cs[i] = {1'b1,tranm_seq_ins.bytestream_cs[i]};
                            else if((i == tranm_seq_ins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                             merge_cs.bs_merged_cs[i] = {1'b1,tranm_seq_ins.bytestream_cs[i]};
                            else
                             merge_cs.bs_merged_cs[i] = {1'b0,tranm_seq_ins.bytestream_cs[i]};
                           end //}
                           if(tranm_seq_ins.stype1 == 3'b100)
                           begin //{
                              merge_cs.link_req_en = 1'b1;
                           end //}
                           else if(tranm_seq_ins.stype1 == 3'b011)
                           begin //{
                              merge_cs.rst_frm_rty_en = 1'b1;
                           end //}
                           if(tranm_seq_ins.stype0 == 4'b0110)
                           begin //{
                               merge_cs.link_resp_en = 1'b1;
                           end //}
                           merge_cs.m_type = MERGED_CS; 
                           pktcs_proc_q.push_back(merge_cs);
                         end //}
                       end //}
                       else
                       begin //{
                          if(pl_outstanding_ackid_q.size() != 0)
                          begin //{
                             bkp_ackid =  pkt_handler_ins.ackid_status;
                             if((pktm_config.multiple_ack_support && pktm_config.ackid_status_pnack_support))
                              bkp_ackid =  pkt_handler_ins.notaccepted_ackid;
                             for(int i=0;i<pl_outstanding_ackid_q.size();i++)
                             begin //{
                                bkp_ackid_trans = new(); 
                                bkp_ackid_trans = pl_outstanding_ackid_q[i];
                                if(bkp_ackid_trans.ackid == bkp_ackid)
                                begin //{
                                   pl_outstanding_ackid_q.delete(i);
                                    break;
                                end //}
                               else if(bkp_ackid_trans.ackid < bkp_ackid)
                               begin //{
                                  pl_outstanding_ackid_q.delete(i);
                               end //}
                             end //} 
                             out_size = pl_outstanding_ackid_q.size();
                             for(int i=0;i< out_size;i++)
                             begin //{
                                if(pl_outstanding_ackid_q.size()!=0)
                                   pl_pkt_q.push_front(pl_outstanding_ackid_q.pop_back());
                             end //} 
                             // error cases
                             if(bkp_ackid_trans.pl_err_kind == ACKID_ERR)
                             begin //{
                                bkp_ackid_trans.pl_err_kind = NO_ERR;               
                             end //} 
                             else if(bkp_ackid_trans.pl_err_kind == EARLY_CRC_ERR)
                             begin //{
                                bkp_ackid_trans.pl_err_kind = NO_ERR;
                             end //}
                             else if(bkp_ackid_trans.pl_err_kind == FINAL_CRC_ERR)
                             begin //{
                                bkp_ackid_trans.pl_err_kind = NO_ERR;
                             end //}
                          // else if(bkp_ackid_trans.ll_err_kind == MAX_SIZE_ERR)
                          // begin //{
                          //    bkp_ackid_trans.ll_err_kind = NONE;
                          //     
                          // end //}
 
                             if(pl_gencs_q.size() != 0)
                             begin //{
                                  for(int i=0;i<pl_gencs_q.size();i++)
                                  begin //{
                                     merge_trans_ins = new pl_gencs_q[i];
                                     if(merge_trans_ins.stype1 == 3'b100 || merge_trans_ins.stype1 == 3'b011 || merge_trans_ins.stype1 == 3'b000 || merge_trans_ins.stype1 == 3'b001 || merge_trans_ins.stype1 == 3'b010)
                                     begin //{
                                         pl_gencs_q.delete(i);
                                         merge_cs = new();
                                         for(int i = 0;i<merge_trans_ins.bytestream_cs.size();i++)
                                         begin //{
                                          if(i == 0)
                                           merge_cs.bs_merged_cs[i] = {1'b1,merge_trans_ins.bytestream_cs[i]};
                                          else if((i == merge_trans_ins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                           merge_cs.bs_merged_cs[i] = {1'b1,merge_trans_ins.bytestream_cs[i]};
                                          else 
                                           merge_cs.bs_merged_cs[i] = {1'b0,merge_trans_ins.bytestream_cs[i]};
                                         end //}
                                         if(merge_trans_ins.stype1 == 3'b100)
                                         begin //{
                                            merge_cs.link_req_en = 1'b1;
                                         end //}
                                         else if(merge_trans_ins.stype1 == 3'b011)
                                         begin //{
                                            merge_cs.rst_frm_rty_en = 1'b1;
                                         end //}
                                         merge_cs.m_type = MERGED_CS;
                                         pktcs_proc_q.push_back(merge_cs);
                                     end //}
                                     /*else if(merge_trans_ins.stype0 == 4'b0110)
                                     begin //{
                                         pl_gencs_q.delete(i);
                                         merge_cs = new();
                                         for(int i = 0;i<merge_trans_ins.bytestream_cs.size();i++)
                                         begin //{
                                          if(i == 0)
                                           merge_cs.bs_merged_cs[i] = {1'b1,merge_trans_ins.bytestream_cs[i]};
                                          else if((i == merge_trans_ins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                           merge_cs.bs_merged_cs[i] = {1'b1,merge_trans_ins.bytestream_cs[i]};
                                          else
                                           merge_cs.bs_merged_cs[i] = {1'b0,merge_trans_ins.bytestream_cs[i]};
                                         end //}
                                         if(merge_trans_ins.stype0 == 4'b0110)
                                         begin //{
                                             merge_cs.link_resp_en = 1'b1;
                                         end //}
                                         merge_cs.m_type = MERGED_CS;
                                         pktcs_proc_q.push_back(merge_cs);
                                     end //}*/
                                     else if(merge_trans_ins.stype0 == 4'b0000 || merge_trans_ins.stype0 == 4'b0001 || merge_trans_ins.stype0 == 4'b0010 || merge_trans_ins.stype0 == 4'b0100 || merge_trans_ins.stype0 == 4'b0101 || merge_trans_ins.stype0 == 4'b0110 )
                                     begin //{
                                        pl_gencs_q.delete(i);
                                        if(pktm_trans.bfm_idle_selected)
                                           merge_trans_ins.cstype = CS48;
                                        else
                                           merge_trans_ins.cstype = CS24;
                                        merge_trans_ins.stype1 = 3'b000;
                                        merge_trans_ins.cmd    = 3'b000;
                                        merge_trans_ins.brc3_stype1_msb = 2'b00;
                                        if(pktm_trans.bfm_idle_selected)
                                        begin //{
                                         merge_trans_ins.cs_crc13 =  merge_trans_ins.calccrc13(merge_trans_ins.pack_cs());
                                        end //}
                                        else
                                        begin //{
                                         merge_trans_ins.cs_crc5 =  merge_trans_ins.calccrc5(merge_trans_ins.pack_cs());
                                        end //}
                                        if(merge_trans_ins.stype0 == 4'b0110)
                                        begin //{
                                            merge_cs.link_resp_en = 1'b1;
                                        end //}
                                        void'(merge_trans_ins.set_delimiter());
                                        void'(merge_trans_ins.pack_cs_bytes());
                                        break;
                                     end   //}
                                 end   //}
                             end //}
                            else
                             begin//{
                             reset_status_cnt();
                             merge_trans_ins = new();
                             merge_trans_ins.stype0 = 4'b0100;
                             merge_trans_ins.param0 =  pktm_trans.curr_rx_ackid;
                             if(pktm_config.multiple_ack_support)
                              merge_trans_ins.param0 = pktm_trans.gr_curr_tx_ackid;
                             if(pktm_config.flow_control_mode == RECEIVE)
                               merge_trans_ins.param1 = 6'b111111;
                             else
                             begin //{
                               if(pktm_env_config.multi_vc_support == 1'b0)
                                 merge_trans_ins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_q.size();
                               else
                                 merge_trans_ins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_vc0_q.size();
                             end //}
                             merge_trans_ins.stype1 = 3'b000;
                             merge_trans_ins.cmd    = 3'b000;
                             merge_trans_ins.brc3_stype1_msb = 2'b00; 
                             if(pktm_trans.bfm_idle_selected)
                                merge_trans_ins.cstype = CS48;
                             else
                                merge_trans_ins.cstype = CS24; 
                             if(pktm_trans.bfm_idle_selected)
                               void'(merge_trans_ins.calccrc13(merge_trans_ins.pack_cs()));
                             else
                               void'(merge_trans_ins.calccrc5(merge_trans_ins.pack_cs())); 
                             merge_trans_ins.delimiter = 8'h7C;
                             void'(merge_trans_ins.pack_cs_bytes());
                             end//}
                             merge_pkt = new();
                             for(int i = 0;i<merge_trans_ins.bytestream_cs.size();i++)
                             begin //{ 
                               if(i == 0)
                                merge_pkt.bs_merged_pkt[i] = {1'b1,merge_trans_ins.bytestream_cs[i]};
                               else if((i == merge_trans_ins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                merge_pkt.bs_merged_pkt[i] = {1'b1,merge_trans_ins.bytestream_cs[i]};
                               else
                                merge_pkt.bs_merged_pkt[i] = {1'b0,merge_trans_ins.bytestream_cs[i]};
                             end //}
                             bkp_ackid_trans.ackid = bkp_ackid;
                             void'(bkp_ackid_trans.pack_bytes(bkp_ackid_trans.bytestream));
                             pl_outstanding_ackid_q.push_back(bkp_ackid_trans);
                             pktm_trans.mul_ack_max=bkp_ackid_trans.ackid;
                             for(int i = 0;i<bkp_ackid_trans.bytestream.size();i++)
                             begin //{
                                 merge_pkt.bs_merged_pkt.push_back({1'b0,bkp_ackid_trans.bytestream[i]});
                             end //}
                             reset_status_cnt();
                             tranm_csins = new();
                             if(~pktm_trans.bfm_idle_selected)
                               tranm_csins.cstype = CS24;
                             else 
                                tranm_csins.cstype = CS48;
                             tranm_csins.stype1 = 3'b010;
                             tranm_csins.cmd    = 3'b000;
                             tranm_csins.brc3_stype1_msb = 2'b00; 
                             tranm_csins.stype0 = 4'b0100;
                             if(pktm_trans.bfm_idle_selected)
                              tranm_csins.param0 =   pktm_trans.curr_rx_ackid;
                             else
                              tranm_csins.param0 =   pktm_trans.curr_rx_ackid;
                             if(pktm_config.multiple_ack_support)
                              tranm_csins.param0 = pktm_trans.gr_curr_tx_ackid;
                             
                              tranm_csins.param1  = 12'hFFF;
                                   
                             if(pktm_trans.bfm_idle_selected)
                             begin //{ 
                              tranm_csins.cs_crc13 =  tranm_csins.calccrc13(tranm_csins.pack_cs());
                             end //}
                             else
                             begin //{
                              tranm_csins.cs_crc5 =  tranm_csins.calccrc5(tranm_csins.pack_cs());
                             end //} 
                             void'(tranm_csins.set_delimiter());
                             void'(tranm_csins.pack_cs_bytes());  
                             for(int i=0;i<tranm_csins.bytestream_cs.size();i++)
                             begin //{ 
                              if(i == 0)
                               merge_pkt.bs_merged_pkt.push_back({1'b1,tranm_csins.bytestream_cs[i]});
                              else if(i == tranm_csins.bytestream_cs.size()-1 && pktm_trans.bfm_idle_selected)
                               merge_pkt.bs_merged_pkt.push_back({1'b1,tranm_csins.bytestream_cs[i]});
                              else
                               merge_pkt.bs_merged_pkt.push_back({1'b0,tranm_csins.bytestream_cs[i]});
                             end //}
                             merge_pkt.m_type = MERGED_PKT; 
                             pktcs_proc_q.push_back(merge_pkt);
                          end //} 
                       end //} 
                       if(pktm_trans.oes_state == 1'b0 && pktm_trans.link_initialized)
                             state = MERGE_NORMAL;
                      else if(pktm_trans.link_initialized && pktm_trans.oes_state == 1'b1)
                           state = MERGE_OES;
                      else if(~pktm_trans.link_initialized && pktm_trans.port_initialized && pktm_trans.oes_state == 1'b1)
                           state = MERGE_OES;
                      else if(pktm_trans.ies_state == 1'b1 && pktm_trans.link_initialized)
                           state = MERGE_IES;
                      else if(pktm_trans.ors_state == 1'b1 && pktm_trans.link_initialized)
                           state = MERGE_ORS;
                      else if(pktm_trans.irs_state == 1'b1 && pktm_trans.link_initialized)
                           state = MERGE_IRS;

                      end //}
       
        MERGE_IES  : begin //{
                         if(pl_gencs_q.size() != 0 &&  pktm_trans.port_initialized)
                          begin //{
                           tranm_gen_ins = new(); 
                           tranm_gen_ins = pl_gencs_q[0];
                           pl_gencs_q.delete(0);
                           merge_cs = new();
                           for(int i = 0;i<tranm_gen_ins.bytestream_cs.size();i++)
                           begin //{ 
                            if(i == 0)
                             merge_cs.bs_merged_cs[i] = {1'b1,tranm_gen_ins.bytestream_cs[i]};
                            else if((i == tranm_gen_ins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                             merge_cs.bs_merged_cs[i] = {1'b1,tranm_gen_ins.bytestream_cs[i]};
                            else
                             merge_cs.bs_merged_cs[i] = {1'b0,tranm_gen_ins.bytestream_cs[i]};
                           end //}
                           if(tranm_gen_ins.stype1 == 3'b100)
                           begin //{
                              merge_cs.link_req_en = 1'b1;
                           end //}
                            else if(tranm_gen_ins.stype1 == 3'b011)
                            begin //{
                               merge_cs.rst_frm_rty_en = 1'b1;
                            end //}
                           if(tranm_gen_ins.stype0 == 4'b0110)
                           begin //{
                               merge_cs.link_resp_en = 1'b1;
                           end //}
                           merge_cs.m_type = MERGED_CS; 
                           pktcs_proc_q.push_back(merge_cs);
                         end //}
                      if(detect_ors_in_ies && !pktm_trans.ors_state)
                       begin//{
                          detect_ors_in_ies=0;
                          if(pl_outstanding_ackid_q.size() != 0)
                          begin //{
                            retry_ackid = pkt_handler_ins.retried_ackid; 
                            q_siz=pl_outstanding_ackid_q.size();
                            for(int i=0;i<q_siz;i++)
                            begin //{
                               rty_ackid_trans = new pl_outstanding_ackid_q[0];
                               if(rty_ackid_trans.ackid == retry_ackid)
                               begin //{
                                  pkt_handler_ins.retried_ackid=12'hx;
                                  //pl_outstanding_ackid_q.delete(0);
                                   break;
                               end //}
                               else if(rty_ackid_trans.ackid < retry_ackid)
                               begin //{
                                  pl_outstanding_ackid_q.delete(0);
                               end //}
                            end //} 
                            temp_size = pl_outstanding_ackid_q.size();
                            for(int i=0;i<temp_size;i++)
                            begin //{
                                if(pl_outstanding_ackid_q.size()!=0)
                                  pl_pkt_q.push_front(pl_outstanding_ackid_q.pop_back());
                            end //} 
                            sorter();
                             if(pl_gencs_q.size() != 0)
                             begin //{
                                  for(int i=0;i<pl_gencs_q.size();i++)
                                  begin //{
                                     merge_trans_ins = new pl_gencs_q[i];
                                     if(merge_trans_ins.stype1 == 3'b100 || merge_trans_ins.stype1 == 3'b011 || merge_trans_ins.stype1 == 3'b000 || merge_trans_ins.stype1 == 3'b001 || merge_trans_ins.stype1 == 3'b010)
                                     begin //{
                                         pl_gencs_q.delete(i);
                                         merge_cs = new();
                                         for(int i = 0;i<merge_trans_ins.bytestream_cs.size();i++)
                                         begin //{
                                          if(i == 0)
                                           merge_cs.bs_merged_cs[i] = {1'b1,merge_trans_ins.bytestream_cs[i]};
                                          else if((i == merge_trans_ins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                           merge_cs.bs_merged_cs[i] = {1'b1,merge_trans_ins.bytestream_cs[i]};
                                          else 
                                           merge_cs.bs_merged_cs[i] = {1'b0,merge_trans_ins.bytestream_cs[i]};
                                         end //}
                                         if(merge_trans_ins.stype1 == 3'b100)
                                         begin //{
                                            merge_cs.link_req_en = 1'b1;
                                         end //}
                                         else if(merge_trans_ins.stype1 == 3'b011)
                                         begin //{
                                            merge_cs.rst_frm_rty_en = 1'b1;
                                         end //}
                                         merge_cs.m_type = MERGED_CS;
                                         pktcs_proc_q.push_back(merge_cs);
                                     end //}
                                     /*else if(merge_trans_ins.stype0 == 4'b0110)
                                     begin //{
                                         pl_gencs_q.delete(i);
                                         merge_cs = new();
                                         for(int i = 0;i<merge_trans_ins.bytestream_cs.size();i++)
                                         begin //{
                                          if(i == 0)
                                           merge_cs.bs_merged_cs[i] = {1'b1,merge_trans_ins.bytestream_cs[i]};
                                          else if((i == merge_trans_ins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                           merge_cs.bs_merged_cs[i] = {1'b1,merge_trans_ins.bytestream_cs[i]};
                                          else
                                           merge_cs.bs_merged_cs[i] = {1'b0,merge_trans_ins.bytestream_cs[i]};
                                         end //}
                                         if(merge_trans_ins.stype0 == 4'b0110)
                                         begin //{
                                             merge_cs.link_resp_en = 1'b1;
                                         end //}
                                         merge_cs.m_type = MERGED_CS;
                                         pktcs_proc_q.push_back(merge_cs);
                                     end //}*/
                                     else if(merge_trans_ins.stype0 == 4'b0000 || merge_trans_ins.stype0 == 4'b0001 || merge_trans_ins.stype0 == 4'b0010 || merge_trans_ins.stype0 == 4'b0100 || merge_trans_ins.stype0 == 4'b0101 || merge_trans_ins.stype0 == 4'b0110)
                                     begin //{
                                        pl_gencs_q.delete(i);
                                        if(pktm_trans.bfm_idle_selected)
                                           merge_trans_ins.cstype = CS48;
                                        else
                                           merge_trans_ins.cstype = CS24;
                                        merge_trans_ins.stype1 = 3'b000;
                                        merge_trans_ins.cmd    = 3'b000;
                                        merge_trans_ins.brc3_stype1_msb = 2'b00;
                                        if(pktm_trans.bfm_idle_selected)
                                        begin //{
                                         merge_trans_ins.cs_crc13 =  merge_trans_ins.calccrc13(merge_trans_ins.pack_cs());
                                        end //}
                                        else
                                        begin //{
                                         merge_trans_ins.cs_crc5 =  merge_trans_ins.calccrc5(merge_trans_ins.pack_cs());
                                        end //}
                                        if(merge_trans_ins.stype0 == 4'b0110)
                                        begin //{
                                            merge_cs.link_resp_en = 1'b1;
                                        end //}
                                        void'(merge_trans_ins.set_delimiter());
                                        void'(merge_trans_ins.pack_cs_bytes());
                                        break;
                                     end   //}
                                 end   //}
                             end //}
                            else
                             begin//{
                            reset_status_cnt();
                            merge_trans_ins = new();
                            merge_trans_ins.stype0 = 4'b0100;
                            merge_trans_ins.param0 =  pktm_trans.curr_rx_ackid;
                              if(pktm_config.multiple_ack_support)
                               merge_trans_ins.param0 = pktm_trans.gr_curr_tx_ackid;
                            merge_trans_ins.param1 =  12'hFFF;
                            merge_trans_ins.stype1 = 3'b000;
                            merge_trans_ins.cmd    = 3'b000;
                            merge_trans_ins.brc3_stype1_msb= 2'b00;
                            if(pktm_trans.bfm_idle_selected)
                               merge_trans_ins.cstype = CS48;
                            else
                               merge_trans_ins.cstype = CS24; 
                            if(pktm_trans.bfm_idle_selected)
                              void'(merge_trans_ins.calccrc13(merge_trans_ins.pack_cs()));
                            else
                              void'(merge_trans_ins.calccrc5(merge_trans_ins.pack_cs())); 
                            merge_trans_ins.delimiter = 8'h7C;
                            void'(merge_trans_ins.pack_cs_bytes());
                             end//}
                            merge_pkt = new();
                            for(int i = 0;i<merge_trans_ins.bytestream_cs.size();i++)
                            begin //{ 
                              if(i == 0)
                               merge_pkt.bs_merged_pkt[i] = {1'b1,merge_trans_ins.bytestream_cs[i]};
                              else if((i == merge_trans_ins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                               merge_pkt.bs_merged_pkt[i] = {1'b1,merge_trans_ins.bytestream_cs[i]};
                              else
                               merge_pkt.bs_merged_pkt[i] = {1'b0,merge_trans_ins.bytestream_cs[i]};
                            end //}
                               rty_ackid_trans = pl_pkt_q.pop_front();
                            pl_outstanding_ackid_q.push_back(rty_ackid_trans);
                            pktm_trans.mul_ack_max=rty_ackid_trans.ackid;
                            for(int i = 0;i<rty_ackid_trans.bytestream.size();i++)
                            begin //{
                                merge_pkt.bs_merged_pkt.push_back({1'b0,rty_ackid_trans.bytestream[i]});
                            end //}
                            tranm_csins = new();
                            if(~pktm_trans.bfm_idle_selected)
                              tranm_csins.cstype = CS24;
                            else 
                               tranm_csins.cstype = CS48;
                            tranm_csins.stype1 = 3'b010;
                            tranm_csins.cmd    = 3'b000;
                            tranm_csins.brc3_stype1_msb = 2'b00;
                            tranm_csins.stype0 = 4'b0100;
                            reset_status_cnt();
                            if(pktm_trans.bfm_idle_selected)
                             tranm_csins.param0 =   pktm_trans.curr_rx_ackid;
                            else
                             tranm_csins.param0 =   pktm_trans.curr_rx_ackid;
                            if(pktm_config.multiple_ack_support)
                             tranm_csins.param0 = pktm_trans.gr_curr_tx_ackid;
                            if(pktm_config.flow_control_mode == RECEIVE)
                              tranm_csins.param1 = 12'hFFF;
                            else
                            begin //{
                              if(pktm_env_config.multi_vc_support == 1'b0)
                                tranm_csins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_q.size();
                              else
                                tranm_csins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_vc0_q.size();
                            end //}
                            if(pktm_trans.bfm_idle_selected)
                            begin //{ 
                             tranm_csins.cs_crc13 =  tranm_csins.calccrc13(tranm_csins.pack_cs());
                            end //}
                            else
                            begin //{
                             tranm_csins.cs_crc5 =  tranm_csins.calccrc5(tranm_csins.pack_cs());
                            end //} 
                            void'(tranm_csins.set_delimiter());
                            void'(tranm_csins.pack_cs_bytes());  
                            for(int i=0;i<tranm_csins.bytestream_cs.size();i++)
                            begin //{ 
                             if(i == 0)
                              merge_pkt.bs_merged_pkt.push_back({1'b1,tranm_csins.bytestream_cs[i]});
                             else if(i == tranm_csins.bytestream_cs.size()-1 && pktm_trans.bfm_idle_selected)
                              merge_pkt.bs_merged_pkt.push_back({1'b1,tranm_csins.bytestream_cs[i]});
                             else
                              merge_pkt.bs_merged_pkt.push_back({1'b0,tranm_csins.bytestream_cs[i]});
                            end //}
                            merge_pkt.m_type = MERGED_PKT; 
                            pktcs_proc_q.push_back(merge_pkt);
                          end //} 
                       end//}
                      else if(pktm_trans.ies_state)
                      begin //{ 
                         if(pl_pkt_q.size() != 0 && pktm_config.cs_merge_en && pktm_trans.link_initialized && ~pktm_trans.oes_state && ~pktm_trans.ors_state && pkt_avail_req && pl_outstanding_ackid_q.size() < ackid_qsize) 
                           begin//{
                               if(pl_gencs_q.size() != 0)
                               begin //{
                                    for(int i=0;i<pl_gencs_q.size();i++)
                                    begin //{
                                       tranm_cs_ins = new pl_gencs_q[i];
                                       if(tranm_cs_ins.stype1 == 3'b100 || tranm_cs_ins.stype1 == 3'b011 || tranm_cs_ins.stype1 == 3'b000 || tranm_cs_ins.stype1 == 3'b001 || tranm_cs_ins.stype1 == 3'b010)
                                       begin //{
                                           pl_gencs_q.delete(i);
                                           merge_cs = new();
                                           for(int i = 0;i<tranm_cs_ins.bytestream_cs.size();i++)
                                           begin //{ 
                                            if(i == 0)
                                             merge_cs.bs_merged_cs[i] = {1'b1,tranm_cs_ins.bytestream_cs[i]};
                                            else if((i == tranm_cs_ins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                             merge_cs.bs_merged_cs[i] = {1'b1,tranm_cs_ins.bytestream_cs[i]};
                                            else
                                             merge_cs.bs_merged_cs[i] = {1'b0,tranm_cs_ins.bytestream_cs[i]};
                                           end //}
                                           if(tranm_cs_ins.stype1 == 3'b100)
                                           begin //{
                                              merge_cs.link_req_en = 1'b1;
                                           end //}
                                           else if(tranm_cs_ins.stype1 == 3'b011)
                                           begin //{
                                              merge_cs.rst_frm_rty_en = 1'b1;
                                           end //}
                                           merge_cs.m_type = MERGED_CS; 
                                           pktcs_proc_q.push_back(merge_cs);
                                       end //}
                                       else if(tranm_cs_ins.stype0 == 4'b0110 || tranm_cs_ins.stype0 == 4'b0000 || tranm_cs_ins.stype0 == 4'b0001 || tranm_cs_ins.stype0 == 4'b0010 || tranm_cs_ins.stype0 == 4'b0100 || tranm_cs_ins.stype0 == 4'b0101 )
                                       begin //{
                                          pl_gencs_q.delete(i);
                                          if(pktm_trans.bfm_idle_selected)
                                             tranm_cs_ins.cstype = CS48;
                                          else 
                                             tranm_cs_ins.cstype = CS24;
                                          tranm_cs_ins.stype1 = 3'b000;
                                          tranm_cs_ins.cmd    = 3'b000;
                                          tranm_cs_ins.brc3_stype1_msb = 2'b00; 
                                          if(pktm_trans.bfm_idle_selected)
                                          begin //{ 
                                           tranm_cs_ins.cs_crc13 =  tranm_cs_ins.calccrc13(tranm_cs_ins.pack_cs());
                                          end //}
                                          else
                                          begin //{
                                           tranm_cs_ins.cs_crc5 =  tranm_cs_ins.calccrc5(tranm_cs_ins.pack_cs());
                                          end //}  
                                          if(tranm_cs_ins.stype0 == 4'b0110)
                                          begin //{
                                              merge_cs.link_resp_en = 1'b1;
                                          end //}
                                          void'(tranm_cs_ins.set_delimiter());
                                          void'(tranm_cs_ins.pack_cs_bytes());  
                                          break;
                                       end   //}
                                   end   //}
                               end //}
                               else if(pl_seqcs_q.size() != 0)
                               begin //{
                                    for(int i=0;i<pl_seqcs_q.size();i++)
                                    begin //{
                                       reset_status_cnt();
                                       tranm_cs_ins = new pl_seqcs_q[i];
                                       if(tranm_cs_ins.stype1 == 3'b011 || tranm_cs_ins.stype1 == 3'b100 || tranm_cs_ins.stype1 == 3'b001)
                                       begin //{
                                          pkt_can_req = 1'b1;
                                          if(~pktm_trans.bfm_idle_selected)
                                             tranm_cs_ins.cstype = CS24;
                                          else 
                                             tranm_cs_ins.cstype = CS48;
                                          tranm_cs_ins.stype1 = 3'b000;
                                          tranm_cs_ins.cmd    = 3'b000;
                                          tranm_cs_ins.brc3_stype1_msb = 2'b00; 
                                          tranm_cs_ins.stype0 = 4'b0100;
                                          if(pktm_trans.bfm_idle_selected)
                                           tranm_cs_ins.param0 =   pktm_trans.curr_rx_ackid; //pkt_handler_ins.ackid;
                                          else
                                           tranm_cs_ins.param0 =   pktm_trans.curr_rx_ackid; //pkt_handler_ins.ackid;
                                          if(pktm_config.multiple_ack_support)
                                           tranm_cs_ins.param0 = pktm_trans.gr_curr_tx_ackid;
                                          if(pktm_config.flow_control_mode == RECEIVE)
                                            tranm_cs_ins.param1 = 12'hFFF;
                                          else
                                          begin //{
                                            if(pktm_env_config.multi_vc_support == 1'b0)
                                              tranm_cs_ins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_q.size();
                                            else
                                              tranm_cs_ins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_vc0_q.size();
                                          end //}
                                          if(pktm_trans.bfm_idle_selected)
                                          begin //{ 
                                           tranm_cs_ins.cs_crc13 =  tranm_cs_ins.calccrc13(tranm_cs_ins.pack_cs());
                                          end //}
                                          else
                                          begin //{
                                           tranm_cs_ins.cs_crc5 =  tranm_cs_ins.calccrc5(tranm_cs_ins.pack_cs());
                                          end //}  
                                          tranm_cs_ins.delimiter = 8'h1C;
                                          tranm_cs_ins.pack_cs_bytes();  
                                          break;
                                       end //}
                                       else if(tranm_cs_ins.stype0 == 4'b0000 || tranm_cs_ins.stype0 == 4'b0001 || tranm_cs_ins.stype0 == 4'b0010 || tranm_cs_ins.stype0 == 4'b0110 || tranm_cs_ins.stype0 == 4'b0100)
                                       begin //{
                                         pl_seqcs_q.delete(i);
                                         if(~pktm_trans.bfm_idle_selected)
                                            tranm_cs_ins.cstype = CS24;
                                         else 
                                            tranm_cs_ins.cstype = CS48;
                                         tranm_cs_ins.stype1 = 3'b000;
                                         tranm_cs_ins.cmd    = 3'b000;
                                         tranm_cs_ins.brc3_stype1_msb = 2'b00; 
                                         if(pktm_trans.bfm_idle_selected)
                                         begin //{ 
                                          tranm_cs_ins.cs_crc13 =  tranm_cs_ins.calccrc13(tranm_cs_ins.pack_cs());
                                         end //}
                                         else
                                         begin //{
                                          tranm_cs_ins.cs_crc5 =  tranm_cs_ins.calccrc5(tranm_cs_ins.pack_cs());
                                         end //}  
                                        void'(tranm_cs_ins.set_delimiter());
                                        void'(tranm_cs_ins.pack_cs_bytes());  
                                         break;    
                                       end //}
                                    end //}
                               end //}
                               else 
                               begin //{
                                    reset_status_cnt();
                                    tranm_cs_ins = new();
                                    if(~pktm_trans.bfm_idle_selected)
                                       tranm_cs_ins.cstype = CS24;
                                    else 
                                       tranm_cs_ins.cstype = CS48;
                                    tranm_cs_ins.stype1 = 3'b000;
                                    tranm_cs_ins.cmd    = 3'b000;
                                    tranm_cs_ins.brc3_stype1_msb = 2'b00; 
                                    tranm_cs_ins.stype0 = 4'b0100;
                                    if(pktm_trans.bfm_idle_selected)
                                     tranm_cs_ins.param0 =   pktm_trans.curr_rx_ackid; //pkt_handler_ins.ackid;
                                    else
                                     tranm_cs_ins.param0 =   pktm_trans.curr_rx_ackid; //pkt_handler_ins.ackid;
                                    if(pktm_config.multiple_ack_support)
                                     tranm_cs_ins.param0 = pktm_trans.gr_curr_tx_ackid;
                                    if(pktm_config.flow_control_mode == RECEIVE)
                                      tranm_cs_ins.param1 = 12'hfff;
                                    else
                                    begin //{
                                      if(pktm_env_config.multi_vc_support == 1'b0)
                                        tranm_cs_ins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_q.size();
                                      else
                                        tranm_cs_ins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_vc0_q.size();
                                    end //}
                                    if(pktm_trans.bfm_idle_selected)
                                    begin //{ 
                                     tranm_cs_ins.cs_crc13 =  tranm_cs_ins.calccrc13(tranm_cs_ins.pack_cs());
                                    end //}
                                    else
                                    begin //{
                                     tranm_cs_ins.cs_crc5 =  tranm_cs_ins.calccrc5(tranm_cs_ins.pack_cs());
                                    end //}  
                                    void'(tranm_cs_ins.set_delimiter());
                                    void'(tranm_cs_ins.pack_cs_bytes());  
                               end //}
                               begin //{  
                                 merge_pkt = new();
                                 for(int i = 0;i<tranm_cs_ins.bytestream_cs.size();i++)
                                 begin //{ 
                                   if(i == 0)
                                    merge_pkt.bs_merged_pkt[i] = {1'b1,tranm_cs_ins.bytestream_cs[i]};
                                   else if((i == tranm_cs_ins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                    merge_pkt.bs_merged_pkt[i] = {1'b1,tranm_cs_ins.bytestream_cs[i]};
                                   else
                                    merge_pkt.bs_merged_pkt[i] = {1'b0,tranm_cs_ins.bytestream_cs[i]};
                                 end //}
                                 begin //{
                                     tranm_pkt_ins  = new pl_pkt_q.pop_front();
                                     pktm_trans.mul_ack_max=tranm_pkt_ins.ackid;
                                     pl_outstanding_ackid_q.push_back(tranm_pkt_ins);
                                     for(int i = 0;i<tranm_pkt_ins.bytestream.size();i++)
                                     begin //{
                                       merge_pkt.bs_merged_pkt.push_back({1'b0,tranm_pkt_ins.bytestream[i]});
                                     end //}
                                    /*if(pktm_config.cs_embed_en)
                                    begin //{
                                      if(pktm_trans.bfm_idle_selected)
                                        merge_loc = $urandom_range(8,merge_pkt.bs_merged_pkt.size()-8);
                                      else 
                                        merge_loc = $urandom_range(4,merge_pkt.bs_merged_pkt.size()-4);
                                      merge_loc = (merge_loc%4)?((merge_loc/4+1)*4) :merge_loc;
                                      embed_inc = 0;
                                      if(pl_gencs_q.size != 0)
                                      begin //{
                                           for(int i=0;i<pl_gencs_q.size();i++)
                                           begin //{
                                              tranm_gen_cs = new pl_gencs_q[i];
                                              if(tranm_gen_cs.stype1 == 3'b100 || tranm_gen_cs.stype1 == 3'b011 || tranm_gen_cs.stype1 == 3'b000 || tranm_gen_cs.stype1 == 3'b001 || tranm_gen_cs.stype1 == 3'b010)
                                              begin //{
                                                  pl_gencs_q.delete(i);
                                                  merge_cs = new();
                                                  for(int i = 0;i<tranm_gen_cs.bytestream_cs.size();i++)
                                                  begin //{ 
                                                   if(i == 0)
                                                    merge_cs.bs_merged_cs[i] = {1'b1,tranm_gen_cs.bytestream_cs[i]};
                                                   else if((i == tranm_gen_cs.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                                    merge_cs.bs_merged_cs[i] = {1'b1,tranm_gen_cs.bytestream_cs[i]};
                                                   else
                                                    merge_cs.bs_merged_cs[i] = {1'b0,tranm_gen_cs.bytestream_cs[i]};
                                                  end //}
                                                  if(tranm_gen_cs.stype1 == 3'b100)
                                                  begin //{
                                                     merge_cs.link_req_en = 1'b1;
                                                  end //}
                                                  else if(tranm_gen_cs.stype1 == 3'b011)
                                                  begin //{
                                                     merge_cs.rst_frm_rty_en = 1'b1;
                                                  end //}
                                                  merge_cs.m_type = MERGED_CS; 
                                                  pktcs_proc_q.push_back(merge_cs);
                                              end //}
                                              else if(tranm_gen_cs.stype0 == 4'b0110)
                                              begin //{
                                                  pl_gencs_q.delete(i);
                                                  merge_cs = new();
                                                  for(int i = 0;i<tranm_gen_cs.bytestream_cs.size();i++)
                                                  begin //{ 
                                                   if(i == 0)
                                                    merge_cs.bs_merged_cs[i] = {1'b1,tranm_gen_cs.bytestream_cs[i]};
                                                   else if((i == tranm_gen_cs.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                                    merge_cs.bs_merged_cs[i] = {1'b1,tranm_gen_cs.bytestream_cs[i]};
                                                   else
                                                    merge_cs.bs_merged_cs[i] = {1'b0,tranm_gen_cs.bytestream_cs[i]};
                                                  end //}
                                                  if(tranm_gen_cs.stype0 == 4'b0110)
                                                  begin //{
                                                      merge_cs.link_resp_en = 1'b1;
                                                  end //}
                                                  merge_cs.m_type = MERGED_CS; 
                                                  pktcs_proc_q.push_back(merge_cs);
                                              end //}
                                              else
                                              begin //{
                                                if(embed_inc)
                                                  merge_loc = pktm_trans.bfm_idle_selected?merge_loc+8:merge_loc+4;
                                                if(((tranm_gen_cs.stype0 == 4'b0000) || (tranm_gen_cs.stype0 == 4'b0001) || (tranm_gen_cs.stype0 == 4'b0010) || (tranm_gen_cs.stype0 == 4'b0100) || (tranm_gen_cs.stype0 == 4'b0101)))
                                                begin //{
                                                   pl_gencs_q.delete(i);
                                                   for(int j=0;j<tranm_gen_cs.bytestream_cs.size();j++)
                                                   begin //{
                                                      if(j == 0)
                                                       merge_pkt.bs_merged_pkt.insert(merge_loc+j,{1'b1,tranm_gen_cs.bytestream_cs[j]});
                                                      else if((j == tranm_gen_cs.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                                       merge_pkt.bs_merged_pkt.insert(merge_loc+j,{1'b1,tranm_gen_cs.bytestream_cs[j]});
                                                      else
                                                       merge_pkt.bs_merged_pkt.insert(merge_loc+j,{1'b0,tranm_gen_cs.bytestream_cs[j]});
                                                   end //} 
                                                  embed_inc = 1'b1;
                                                end //}
                                                else 
                                                begin //{
                                                    embed_inc = 1'b0;
                                                end //} 
                                              end //}
                                           end //}       
                                        end //}
                                        if(pl_seqcs_q.size != 0)
                                        begin //{
                                             for(int i=0;i<pl_seqcs_q.size;i++)
                                             begin //{
                                                tranm_seq_cs = new pl_seqcs_q[i];
                                                void'(tranm_seq_cs.set_delimiter());
                                                if(embed_inc)
                                                  merge_loc = pktm_trans.bfm_idle_selected?merge_loc+8:merge_loc+4;
                                                if(tranm_seq_cs.delimiter == 8'h1C)
                                                begin //{
                                                   pl_seqcs_q.delete(i);
                                                   tranm_seq_cs.pack_cs_bytes();
                                                   for(int j=0;j<tranm_seq_cs.bytestream_cs.size();j++)
                                                   begin //{
                                                      if(j == 0)
                                                       merge_pkt.bs_merged_pkt.insert(merge_loc+j,{1'b1,tranm_seq_cs.bytestream_cs[j]});
                                                      else if((j == tranm_seq_cs.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                                       merge_pkt.bs_merged_pkt.insert(merge_loc+j,{1'b1,tranm_seq_cs.bytestream_cs[j]});
                                                      else
                                                       merge_pkt.bs_merged_pkt.insert(merge_loc+j,{1'b0,tranm_seq_cs.bytestream_cs[j]});
                                                   end //} 
                                                embed_inc = 1'b1;
                                                end //}
                                                else 
                                                begin //{
                                                    embed_inc = 1'b0;
                                                end //} 
                                             end //}       
                                        end //}
                                       end //}*/
//if(pl_pkt_q.size()!=0)
//continue;
                                       if(pl_gencs_q.size() != 0)
                                       begin //{
                                            for(int i=0;i<pl_gencs_q.size();i++)
                                            begin //{
                                               tranm_csins = new pl_gencs_q[i];
                                               if(tranm_csins.stype1 == 3'b100 || tranm_csins.stype1 == 3'b011 || tranm_csins.stype1 == 3'b000 || tranm_csins.stype1 == 3'b001 || tranm_csins.stype1 == 3'b010)
                                               begin //{
                                                   pl_gencs_q.delete(i);
                                                   merge_cs = new();
                                                   for(int i = 0;i<tranm_csins.bytestream_cs.size();i++)
                                                   begin //{ 
                                                    if(i == 0)
                                                     merge_cs.bs_merged_cs[i] = {1'b1,tranm_csins.bytestream_cs[i]};
                                                    else if((i == tranm_csins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                                     merge_cs.bs_merged_cs[i] = {1'b1,tranm_csins.bytestream_cs[i]};
                                                    else
                                                     merge_cs.bs_merged_cs[i] = {1'b0,tranm_csins.bytestream_cs[i]};
                                                   end //}
                                                   if(tranm_csins.stype1 == 3'b100)
                                                   begin //{
                                                      merge_cs.link_req_en = 1'b1;
                                                   end //}
                                                   else if(tranm_csins.stype1 == 3'b011)
                                                   begin //{
                                                      merge_cs.rst_frm_rty_en = 1'b1;
                                                   end //}
                                                   merge_cs.m_type = MERGED_CS; 
                                                   pktcs_proc_q.push_back(merge_cs);
                                               end //}
                                               else if(tranm_csins.stype0 == 4'b0000 || tranm_csins.stype0 == 4'b0001 || tranm_csins.stype0 == 4'b0010 || tranm_csins.stype0 == 4'b0100 || tranm_csins.stype0 == 4'b0101 ||tranm_csins.stype0 == 4'b0110)
                                               begin //{
                                                  pl_gencs_q.delete(i);
                                                  if(~pktm_trans.bfm_idle_selected)
                                                     tranm_csins.cstype = CS24;
                                                  else 
                                                     tranm_csins.cstype = CS48;
                                                  tranm_csins.stype1 = 3'b010;
                                                  tranm_csins.cmd    = 3'b000;
                                                  tranm_cs_ins.brc3_stype1_msb = 2'b00; 
                                                  if(pktm_trans.bfm_idle_selected)
                                                  begin //{ 
                                                   tranm_csins.cs_crc13 =  tranm_csins.calccrc13(tranm_csins.pack_cs());
                                                  end //}
                                                  else
                                                  begin //{
                                                   tranm_csins.cs_crc5 =  tranm_csins.calccrc5(tranm_csins.pack_cs());
                                                  end //}  
                                                  if(tranm_csins.stype0 == 4'b0110)
                                                  begin //{
                                                      merge_cs.link_resp_en = 1'b1;
                                                  end //}
                                                  void'(tranm_csins.set_delimiter());
                                                  void'(tranm_csins.pack_cs_bytes());  
                                                  break;
                                               end //}    
                                            end  //}
                                       end //}
                                       else if(pl_seqcs_q.size() != 0)
                                       begin //{
                                            for(int i=0;i<pl_seqcs_q.size();i++)
                                            begin //{
                                               tranm_csins = new pl_seqcs_q[i];
                                                if(tranm_csins.stype0 == 4'b0000 || tranm_csins.stype0 == 4'b0001 || tranm_csins.stype0 == 4'b0010 || tranm_csins.stype0 == 4'b0110 || tranm_csins.stype0 == 4'b0100)
                                                pl_seqcs_q.delete(i);
                                                if(~pktm_trans.bfm_idle_selected)
                                                   tranm_csins.cstype = CS24;
                                                else 
                                                   tranm_csins.cstype = CS48;
                                                tranm_csins.stype1 = 3'b010;
                                                tranm_csins.cmd    = 3'b000;
                                                tranm_csins.brc3_stype1_msb = 2'b00; 
                                                if(pktm_trans.bfm_idle_selected)
                                                begin //{ 
                                                 tranm_csins.cs_crc13 =  tranm_csins.calccrc13(tranm_csins.pack_cs());
                                                end //}
                                                else
                                                begin //{
                                                 tranm_csins.cs_crc5 =  tranm_csins.calccrc5(tranm_csins.pack_cs());
                                                end //}  
                                                void'(tranm_csins.set_delimiter());
                                                void'(tranm_csins.pack_cs_bytes());  
                                                break;    
                                            end //}
                                       end //}
                                     else 
                                     begin //{ 
                                        reset_status_cnt();
                                        tranm_csins = new();
                                        if(~pktm_trans.bfm_idle_selected)
                                          tranm_csins.cstype = CS24;
                                        else 
                                           tranm_csins.cstype = CS48;
                                        tranm_csins.stype1 = 3'b010;
                                        tranm_csins.cmd    = 3'b000;
                                        tranm_csins.brc3_stype1_msb = 2'b00; 
                                        tranm_csins.stype0 = 4'b0100;
                                        if(pktm_trans.bfm_idle_selected)
                                         tranm_csins.param0 =   pktm_trans.curr_rx_ackid; //pkt_handler_ins.ackid;
                                        else
                                         tranm_csins.param0 =   pktm_trans.curr_rx_ackid; //pkt_handler_ins.ackid;
                                        if(pktm_config.multiple_ack_support)
                                         tranm_csins.param0 = pktm_trans.gr_curr_tx_ackid;
                                        if(pktm_config.flow_control_mode == RECEIVE)
                                          tranm_csins.param1 = 12'hfff;
                                        else
                                        begin //{
                                          if(pktm_env_config.multi_vc_support == 1'b0)
                                            tranm_csins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_q.size();
                                          else
                                            tranm_csins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_vc0_q.size();
                                        end //}
                                        if(pktm_trans.bfm_idle_selected)
                                        begin //{ 
                                         tranm_csins.cs_crc13 =  tranm_csins.calccrc13(tranm_csins.pack_cs());
                                        end //}
                                        else
                                        begin //{
                                         tranm_csins.cs_crc5 =  tranm_csins.calccrc5(tranm_csins.pack_cs());
                                        end //} 
                                        void'(tranm_csins.set_delimiter());
                                        void'(tranm_csins.pack_cs_bytes());  
                                      end //}  
                                      for(int i=0;i<tranm_csins.bytestream_cs.size();i++)
                                      begin //{ 
                                       if(i == 0)
                                        merge_pkt.bs_merged_pkt.push_back({1'b1,tranm_csins.bytestream_cs[i]});
                                       else if(i == tranm_csins.bytestream_cs.size()-1 && pktm_trans.bfm_idle_selected)
                                        merge_pkt.bs_merged_pkt.push_back({1'b1,tranm_csins.bytestream_cs[i]});
                                       else
                                        merge_pkt.bs_merged_pkt.push_back({1'b0,tranm_csins.bytestream_cs[i]});
                                      end //}
                                     merge_pkt.m_type = MERGED_PKT; 
                                     pktcs_proc_q.push_back(merge_pkt);
                                end //}
                             end //}
                          end //}  
                         if(pl_gencs_q.size() != 0 &&  pktm_trans.link_initialized)
                         begin //{
                           tranm_gen_ins = new(); 
                           tranm_gen_ins = pl_gencs_q[0];
                           pl_gencs_q.delete(0);
                           merge_cs = new();
                           for(int i = 0;i<tranm_gen_ins.bytestream_cs.size();i++)
                           begin //{ 
                            if(i == 0)
                             merge_cs.bs_merged_cs[i] = {1'b1,tranm_gen_ins.bytestream_cs[i]};
                            else if((i == tranm_gen_ins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                             merge_cs.bs_merged_cs[i] = {1'b1,tranm_gen_ins.bytestream_cs[i]};
                            else
                             merge_cs.bs_merged_cs[i] = {1'b0,tranm_gen_ins.bytestream_cs[i]};
                           end //}
                           if(tranm_gen_ins.stype1 == 3'b100)
                           begin //{
                              merge_cs.link_req_en = 1'b1;
                           end //}
                            else if(tranm_gen_ins.stype1 == 3'b011)
                            begin //{
                               merge_cs.rst_frm_rty_en = 1'b1;
                            end //}
                           if(tranm_gen_ins.stype0 == 4'b0110)
                           begin //{
                               merge_cs.link_resp_en = 1'b1;
                           end //}
                           merge_cs.m_type = MERGED_CS; 
                           pktcs_proc_q.push_back(merge_cs);
                         end //}
                         if(pl_seqcs_q.size() != 0 &&  pktm_trans.link_initialized)
                         begin //{
                           tranm_seq_ins = new(); 
                           tranm_seq_ins = pl_seqcs_q[0];
                           pl_seqcs_q.delete(0);
                           merge_cs = new();
                           for(int i = 0;i<tranm_seq_ins.bytestream_cs.size();i++)
                           begin //{ 
                            if(i == 0)
                             merge_cs.bs_merged_cs[i] = {1'b1,tranm_seq_ins.bytestream_cs[i]};
                            else if((i == tranm_seq_ins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                             merge_cs.bs_merged_cs[i] = {1'b1,tranm_seq_ins.bytestream_cs[i]};
                            else
                             merge_cs.bs_merged_cs[i] = {1'b0,tranm_seq_ins.bytestream_cs[i]};
                           end //}
                           if(tranm_seq_ins.stype1 == 3'b100)
                           begin //{
                              merge_cs.link_req_en = 1'b1;
                           end //}
                           else if(tranm_seq_ins.stype1 == 3'b011)
                           begin //{
                              merge_cs.rst_frm_rty_en = 1'b1;
                           end //}
                           if(tranm_seq_ins.stype0 == 4'b0110)
                           begin //{
                               merge_cs.link_resp_en = 1'b1;
                           end //}
                           merge_cs.m_type = MERGED_CS; 
                           pktcs_proc_q.push_back(merge_cs);
                         end //}
                         if(pl_gencs_q.size() != 0 &&  ~pktm_trans.link_initialized && pktm_trans.port_initialized)
                         begin //{
                           tranm_gen_ins = new(); 
                           tranm_gen_ins = pl_gencs_q[0];
                           pl_gencs_q.delete(0);
                           merge_cs = new();
                           for(int i = 0;i<tranm_gen_ins.bytestream_cs.size();i++)
                           begin //{ 
                            if(i == 0)
                             merge_cs.bs_merged_cs[i] = {1'b1,tranm_gen_ins.bytestream_cs[i]};
                            else if((i == tranm_gen_ins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                             merge_cs.bs_merged_cs[i] = {1'b1,tranm_gen_ins.bytestream_cs[i]};
                            else
                             merge_cs.bs_merged_cs[i] = {1'b0,tranm_gen_ins.bytestream_cs[i]};
                           end //}
                           if(tranm_gen_ins.stype1 == 3'b100)
                           begin //{
                              merge_cs.link_req_en = 1'b1;
                           end //}
                            else if(tranm_gen_ins.stype1 == 3'b011)
                            begin //{
                               merge_cs.rst_frm_rty_en = 1'b1;
                            end //}
                           if(tranm_gen_ins.stype0 == 4'b0110)
                           begin //{
                               merge_cs.link_resp_en = 1'b1;
                           end //}
                           merge_cs.m_type = MERGED_CS; 
                           pktcs_proc_q.push_back(merge_cs);
                         end //}
                       end //}
                       if(pktm_trans.ors_state) 
                        detect_ors_in_ies=1;
                      if(pktm_trans.ies_state == 1'b0 && pktm_trans.link_initialized)
                       begin
                            state = MERGE_NORMAL;
                            detect_ors_in_ies=0;
                       end
                      else if(pktm_trans.link_initialized && pktm_trans.ies_state == 1'b1)
                       begin
                            state = MERGE_IES;
                       end
                      else if(~pktm_trans.link_initialized && pktm_trans.port_initialized && pktm_trans.ies_state == 1'b1)
                       begin
                            state = MERGE_IES;
                       end
                      else if(pktm_trans.ors_state == 1'b1 && pktm_trans.link_initialized)
                       begin
                           state = MERGE_ORS;
                            detect_ors_in_ies=0;
                       end
                      else if(pktm_trans.oes_state == 1'b1 && pktm_trans.link_initialized)
                       begin
                           state = MERGE_OES;
                            detect_ors_in_ies=0;
                       end
                      else if(pktm_trans.irs_state == 1'b1 && pktm_trans.link_initialized)
                       begin
                           state = MERGE_IRS;
                           detect_ors_in_ies=0;
                       end

                     end //}  

        MERGE_IRS  : begin //{
                      if(pktm_trans.irs_state)
                      begin //{ 
                         if(pl_pkt_q.size() != 0 && pktm_config.cs_merge_en && pktm_trans.link_initialized && ~pktm_trans.oes_state && ~pktm_trans.ors_state && pkt_avail_req && pl_outstanding_ackid_q.size() < ackid_qsize) 
                           begin//{
                               if(pl_gencs_q.size() != 0)
                               begin //{
                                    for(int i=0;i<pl_gencs_q.size();i++)
                                    begin //{
                                       tranm_cs_ins = new pl_gencs_q[i];
                                       if(tranm_cs_ins.stype1 == 3'b100 || tranm_cs_ins.stype1 == 3'b011 || tranm_cs_ins.stype1 == 3'b000 || tranm_cs_ins.stype1 == 3'b001 || tranm_cs_ins.stype1 == 3'b010)
                                       begin //{
                                           pl_gencs_q.delete(i);
                                           merge_cs = new();
                                           for(int i = 0;i<tranm_cs_ins.bytestream_cs.size();i++)
                                           begin //{ 
                                            if(i == 0)
                                             merge_cs.bs_merged_cs[i] = {1'b1,tranm_cs_ins.bytestream_cs[i]};
                                            else if((i == tranm_cs_ins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                             merge_cs.bs_merged_cs[i] = {1'b1,tranm_cs_ins.bytestream_cs[i]};
                                            else
                                             merge_cs.bs_merged_cs[i] = {1'b0,tranm_cs_ins.bytestream_cs[i]};
                                           end //}
                                           if(tranm_cs_ins.stype1 == 3'b100)
                                           begin //{
                                              merge_cs.link_req_en = 1'b1;
                                           end //}
                                           else if(tranm_cs_ins.stype1 == 3'b011)
                                           begin //{
                                              merge_cs.rst_frm_rty_en = 1'b1;
                                           end //}
                                           merge_cs.m_type = MERGED_CS; 
                                           pktcs_proc_q.push_back(merge_cs);
                                       end //}
                                       else if(tranm_cs_ins.stype0 == 4'b0110 || tranm_cs_ins.stype0 == 4'b0000 || tranm_cs_ins.stype0 == 4'b0001 || tranm_cs_ins.stype0 == 4'b0010 || tranm_cs_ins.stype0 == 4'b0100 || tranm_cs_ins.stype0 == 4'b0101 )
                                       begin //{
                                          pl_gencs_q.delete(i);
                                          if(pktm_trans.bfm_idle_selected)
                                             tranm_cs_ins.cstype = CS48;
                                          else 
                                             tranm_cs_ins.cstype = CS24;
                                          tranm_cs_ins.stype1 = 3'b000;
                                          tranm_cs_ins.cmd    = 3'b000;
                                          tranm_cs_ins.brc3_stype1_msb = 2'b00; 
                                          if(pktm_trans.bfm_idle_selected)
                                          begin //{ 
                                           tranm_cs_ins.cs_crc13 =  tranm_cs_ins.calccrc13(tranm_cs_ins.pack_cs());
                                          end //}
                                          else
                                          begin //{
                                           tranm_cs_ins.cs_crc5 =  tranm_cs_ins.calccrc5(tranm_cs_ins.pack_cs());
                                          end //}  
                                          if(tranm_cs_ins.stype0 == 4'b0110)
                                          begin //{
                                              merge_cs.link_resp_en = 1'b1;
                                          end //}
                                          void'(tranm_cs_ins.set_delimiter());
                                          void'(tranm_cs_ins.pack_cs_bytes());  
                                          break;
                                       end   //}
                                   end   //}
                               end //}
                               else if(pl_seqcs_q.size() != 0)
                               begin //{
                                    for(int i=0;i<pl_seqcs_q.size();i++)
                                    begin //{
                                       reset_status_cnt();
                                       tranm_cs_ins = new pl_seqcs_q[i];
                                       if(tranm_cs_ins.stype1 == 3'b011 || tranm_cs_ins.stype1 == 3'b100 || tranm_cs_ins.stype1 == 3'b001)
                                       begin //{
                                          pkt_can_req = 1'b1;
                                          if(~pktm_trans.bfm_idle_selected)
                                             tranm_cs_ins.cstype = CS24;
                                          else 
                                             tranm_cs_ins.cstype = CS48;
                                          tranm_cs_ins.stype1 = 3'b000;
                                          tranm_cs_ins.cmd    = 3'b000;
                                          tranm_cs_ins.brc3_stype1_msb = 2'b00; 
                                          tranm_cs_ins.stype0 = 4'b0100;
                                          if(pktm_trans.bfm_idle_selected)
                                           tranm_cs_ins.param0 =   pktm_trans.curr_rx_ackid; //pkt_handler_ins.ackid;
                                          else
                                           tranm_cs_ins.param0 =   pktm_trans.curr_rx_ackid; //pkt_handler_ins.ackid;
                                          if(pktm_config.multiple_ack_support)
                                           tranm_cs_ins.param0 = pktm_trans.gr_curr_tx_ackid;
                                          if(pktm_config.flow_control_mode == RECEIVE)
                                            tranm_cs_ins.param1 = 12'hFFF;
                                          else
                                          begin //{
                                            if(pktm_env_config.multi_vc_support == 1'b0)
                                              tranm_cs_ins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_q.size();
                                            else
                                              tranm_cs_ins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_vc0_q.size();
                                          end //}
                                          if(pktm_trans.bfm_idle_selected)
                                          begin //{ 
                                           tranm_cs_ins.cs_crc13 =  tranm_cs_ins.calccrc13(tranm_cs_ins.pack_cs());
                                          end //}
                                          else
                                          begin //{
                                           tranm_cs_ins.cs_crc5 =  tranm_cs_ins.calccrc5(tranm_cs_ins.pack_cs());
                                          end //}  
                                          tranm_cs_ins.delimiter = 8'h1C;
                                          tranm_cs_ins.pack_cs_bytes();  
                                          break;
                                       end //}
                                       else if(tranm_cs_ins.stype0 == 4'b0000 || tranm_cs_ins.stype0 == 4'b0001 || tranm_cs_ins.stype0 == 4'b0010 || tranm_cs_ins.stype0 == 4'b0110 || tranm_cs_ins.stype0 == 4'b0100)
                                       begin //{
                                         pl_seqcs_q.delete(i);
                                         if(~pktm_trans.bfm_idle_selected)
                                            tranm_cs_ins.cstype = CS24;
                                         else 
                                            tranm_cs_ins.cstype = CS48;
                                         tranm_cs_ins.stype1 = 3'b000;
                                         tranm_cs_ins.cmd    = 3'b000;
                                         tranm_cs_ins.brc3_stype1_msb = 2'b00; 
                                         if(pktm_trans.bfm_idle_selected)
                                         begin //{ 
                                          tranm_cs_ins.cs_crc13 =  tranm_cs_ins.calccrc13(tranm_cs_ins.pack_cs());
                                         end //}
                                         else
                                         begin //{
                                          tranm_cs_ins.cs_crc5 =  tranm_cs_ins.calccrc5(tranm_cs_ins.pack_cs());
                                         end //}  
                                        void'(tranm_cs_ins.set_delimiter());
                                        void'(tranm_cs_ins.pack_cs_bytes());  
                                         break;    
                                       end //}
                                    end //}
                               end //}
                               else 
                               begin //{
                                    reset_status_cnt();
                                    tranm_cs_ins = new();
                                    if(~pktm_trans.bfm_idle_selected)
                                       tranm_cs_ins.cstype = CS24;
                                    else 
                                       tranm_cs_ins.cstype = CS48;
                                    tranm_cs_ins.stype1 = 3'b000;
                                    tranm_cs_ins.cmd    = 3'b000;
                                    tranm_cs_ins.brc3_stype1_msb = 2'b00; 
                                    tranm_cs_ins.stype0 = 4'b0100;
                                    if(pktm_trans.bfm_idle_selected)
                                     tranm_cs_ins.param0 =   pktm_trans.curr_rx_ackid; //pkt_handler_ins.ackid;
                                    else
                                     tranm_cs_ins.param0 =   pktm_trans.curr_rx_ackid; //pkt_handler_ins.ackid;
                                    if(pktm_config.multiple_ack_support)
                                     tranm_cs_ins.param0 = pktm_trans.gr_curr_tx_ackid;
                                    if(pktm_config.flow_control_mode == RECEIVE)
                                      tranm_cs_ins.param1 = 12'hfff;
                                    else
                                    begin //{
                                      if(pktm_env_config.multi_vc_support == 1'b0)
                                        tranm_cs_ins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_q.size();
                                      else
                                        tranm_cs_ins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_vc0_q.size();
                                    end //}
                                    if(pktm_trans.bfm_idle_selected)
                                    begin //{ 
                                     tranm_cs_ins.cs_crc13 =  tranm_cs_ins.calccrc13(tranm_cs_ins.pack_cs());
                                    end //}
                                    else
                                    begin //{
                                     tranm_cs_ins.cs_crc5 =  tranm_cs_ins.calccrc5(tranm_cs_ins.pack_cs());
                                    end //}  
                                    void'(tranm_cs_ins.set_delimiter());
                                    void'(tranm_cs_ins.pack_cs_bytes());  
                               end //}
/*                               if(pkt_can_req)
                               begin //{
                                  pkt_can_req = 1'b0; 
                                  merge_pkt = new();
                                  for(int i = 0;i<tranm_cs_ins.bytestream_cs.size();i++)
                                  begin //{ 
                                    if(i == 0)
                                     merge_pkt.bs_merged_pkt.push_back({1'b1,tranm_cs_ins.bytestream_cs[i]});
                                    else if((i == tranm_cs_ins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                     merge_pkt.bs_merged_pkt.push_back({1'b1,tranm_cs_ins.bytestream_cs[i]});
                                    else
                                     merge_pkt.bs_merged_pkt.push_back({1'b0,tranm_cs_ins.bytestream_cs[i]});
                                  end //}
                                  tranm_pkt_ins  = new pl_pkt_q.pop_front();
                                  pl_outstanding_ackid_q.push_back(tranm_pkt_ins);
                                  for(int i = 0;i<8;i++)
                                  begin //{
                                    merge_pkt.bs_merged_pkt.push_back({1'b0,tranm_pkt_ins.bytestream[i]});
                                  end //}
                                  if(pl_seqcs_q.size() != 0)
                                  begin //{
                                     can_trans_ins = new pl_seqcs_q[0];
                                     pl_seqcs_q.delete(0);
                                     if(pktm_trans.bfm_idle_selected)
                                     begin //{ 
                                      can_trans_ins.cs_crc13 =  can_trans_ins.calccrc13(can_trans_ins.pack_cs());
                                     end //}
                                     else
                                     begin //{
                                      can_trans_ins.cs_crc5 =  can_trans_ins.calccrc5(can_trans_ins.pack_cs());
                                     end //}  
                                     can_trans_ins.delimiter = 8'h7C;
                                     void'(can_trans_ins.pack_cs_bytes());  
                                     for(int i = 0;i<can_trans_ins.bytestream_cs.size();i++)
                                     begin //{ 
                                       if(i == 0)
                                        merge_pkt.bs_merged_pkt[i] = {1'b1,can_trans_ins.bytestream_cs[i]};
                                       else if((i == can_trans_ins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                        merge_pkt.bs_merged_pkt[i] = {1'b1,can_trans_ins.bytestream_cs[i]};
                                       else
                                        merge_pkt.bs_merged_pkt[i] = {1'b0,can_trans_ins.bytestream_cs[i]};
                                     end //}
                                     merge_pkt.m_type = MERGED_PKT; 
                                     pktcs_proc_q.push_back(merge_pkt);
                                  end //} 
                               end //}
                               else*/ 
                               begin //{  
                                 merge_pkt = new();
                                 for(int i = 0;i<tranm_cs_ins.bytestream_cs.size();i++)
                                 begin //{ 
                                   if(i == 0)
                                    merge_pkt.bs_merged_pkt[i] = {1'b1,tranm_cs_ins.bytestream_cs[i]};
                                   else if((i == tranm_cs_ins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                    merge_pkt.bs_merged_pkt[i] = {1'b1,tranm_cs_ins.bytestream_cs[i]};
                                   else
                                    merge_pkt.bs_merged_pkt[i] = {1'b0,tranm_cs_ins.bytestream_cs[i]};
                                 end //}
/*                                 if(pktm_trans.ies_state || pktm_trans.irs_state)
                                 begin //{
                                   gen_stomp_cs();
                                   tranm_pkt_ins  = new pl_pkt_q.pop_front();
                                   pl_outstanding_ackid_q.push_back(tranm_pkt_ins);
                                   for(int i = 0;i<8;i++)
                                   begin //{
                                     merge_pkt.bs_merged_pkt.push_back({1'b0,tranm_pkt_ins.bytestream[i]});
                                   end //}
                                   for(int i=0;i<trans_push_ins.bytestream_cs.size();i++)
                                   begin //{ 
                                    if(i == 0)
                                     merge_pkt.bs_merged_pkt.push_back({1'b1,trans_push_ins.bytestream_cs[i]});
                                    else if(i == trans_push_ins.bytestream_cs.size()-1 && pktm_trans.bfm_idle_selected)
                                     merge_pkt.bs_merged_pkt.push_back({1'b1,trans_push_ins.bytestream_cs[i]});
                                    else
                                     merge_pkt.bs_merged_pkt.push_back({1'b0,trans_push_ins.bytestream_cs[i]});
                                   end //}
                                 merge_pkt.m_type = MERGED_PKT; 
                                 pktcs_proc_q.push_back(merge_pkt);
                                 end //}
                                 else */
                                 begin //{
                                     tranm_pkt_ins  = new pl_pkt_q.pop_front();
                                     pktm_trans.mul_ack_max=tranm_pkt_ins.ackid;
                                     pl_outstanding_ackid_q.push_back(tranm_pkt_ins);
                                     for(int i = 0;i<tranm_pkt_ins.bytestream.size();i++)
                                     begin //{
                                       merge_pkt.bs_merged_pkt.push_back({1'b0,tranm_pkt_ins.bytestream[i]});
                                     end //}
                                    /*if(pktm_config.cs_embed_en)
                                    begin //{
                                      if(pktm_trans.bfm_idle_selected)
                                        merge_loc = $urandom_range(8,merge_pkt.bs_merged_pkt.size()-8);
                                      else 
                                        merge_loc = $urandom_range(4,merge_pkt.bs_merged_pkt.size()-4);
                                      merge_loc = (merge_loc%4)?((merge_loc/4+1)*4) :merge_loc;
                                      embed_inc = 0;
                                      if(pl_gencs_q.size != 0)
                                      begin //{
                                           for(int i=0;i<pl_gencs_q.size();i++)
                                           begin //{
                                              tranm_gen_cs = new pl_gencs_q[i];
                                              if(tranm_gen_cs.stype1 == 3'b100 || tranm_gen_cs.stype1 == 3'b011 || tranm_gen_cs.stype1 == 3'b000 || tranm_gen_cs.stype1 == 3'b001 || tranm_gen_cs.stype1 == 3'b010)
                                              begin //{
                                                  pl_gencs_q.delete(i);
                                                  merge_cs = new();
                                                  for(int i = 0;i<tranm_gen_cs.bytestream_cs.size();i++)
                                                  begin //{ 
                                                   if(i == 0)
                                                    merge_cs.bs_merged_cs[i] = {1'b1,tranm_gen_cs.bytestream_cs[i]};
                                                   else if((i == tranm_gen_cs.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                                    merge_cs.bs_merged_cs[i] = {1'b1,tranm_gen_cs.bytestream_cs[i]};
                                                   else
                                                    merge_cs.bs_merged_cs[i] = {1'b0,tranm_gen_cs.bytestream_cs[i]};
                                                  end //}
                                                  if(tranm_gen_cs.stype1 == 3'b100)
                                                  begin //{
                                                     merge_cs.link_req_en = 1'b1;
                                                  end //}
                                                  else if(tranm_gen_cs.stype1 == 3'b011)
                                                  begin //{
                                                     merge_cs.rst_frm_rty_en = 1'b1;
                                                  end //}
                                                  merge_cs.m_type = MERGED_CS; 
                                                  pktcs_proc_q.push_back(merge_cs);
                                              end //}
                                              else if(tranm_gen_cs.stype0 == 4'b0110)
                                              begin //{
                                                  pl_gencs_q.delete(i);
                                                  merge_cs = new();
                                                  for(int i = 0;i<tranm_gen_cs.bytestream_cs.size();i++)
                                                  begin //{ 
                                                   if(i == 0)
                                                    merge_cs.bs_merged_cs[i] = {1'b1,tranm_gen_cs.bytestream_cs[i]};
                                                   else if((i == tranm_gen_cs.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                                    merge_cs.bs_merged_cs[i] = {1'b1,tranm_gen_cs.bytestream_cs[i]};
                                                   else
                                                    merge_cs.bs_merged_cs[i] = {1'b0,tranm_gen_cs.bytestream_cs[i]};
                                                  end //}
                                                  if(tranm_gen_cs.stype0 == 4'b0110)
                                                  begin //{
                                                      merge_cs.link_resp_en = 1'b1;
                                                  end //}
                                                  merge_cs.m_type = MERGED_CS; 
                                                  pktcs_proc_q.push_back(merge_cs);
                                              end //}
                                              else
                                              begin //{
                                                if(embed_inc)
                                                  merge_loc = pktm_trans.bfm_idle_selected?merge_loc+8:merge_loc+4;
                                                if(((tranm_gen_cs.stype0 == 4'b0000) || (tranm_gen_cs.stype0 == 4'b0001) || (tranm_gen_cs.stype0 == 4'b0010) || (tranm_gen_cs.stype0 == 4'b0100) || (tranm_gen_cs.stype0 == 4'b0101)))
                                                begin //{
                                                   pl_gencs_q.delete(i);
                                                   for(int j=0;j<tranm_gen_cs.bytestream_cs.size();j++)
                                                   begin //{
                                                      if(j == 0)
                                                       merge_pkt.bs_merged_pkt.insert(merge_loc+j,{1'b1,tranm_gen_cs.bytestream_cs[j]});
                                                      else if((j == tranm_gen_cs.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                                       merge_pkt.bs_merged_pkt.insert(merge_loc+j,{1'b1,tranm_gen_cs.bytestream_cs[j]});
                                                      else
                                                       merge_pkt.bs_merged_pkt.insert(merge_loc+j,{1'b0,tranm_gen_cs.bytestream_cs[j]});
                                                   end //} 
                                                  embed_inc = 1'b1;
                                                end //}
                                                else 
                                                begin //{
                                                    embed_inc = 1'b0;
                                                end //} 
                                              end //}
                                           end //}       
                                        end //}
                                        if(pl_seqcs_q.size != 0)
                                        begin //{
                                             for(int i=0;i<pl_seqcs_q.size;i++)
                                             begin //{
                                                tranm_seq_cs = new pl_seqcs_q[i];
                                                void'(tranm_seq_cs.set_delimiter());
                                                if(embed_inc)
                                                  merge_loc = pktm_trans.bfm_idle_selected?merge_loc+8:merge_loc+4;
                                                if(tranm_seq_cs.delimiter == 8'h1C)
                                                begin //{
                                                   pl_seqcs_q.delete(i);
                                                   tranm_seq_cs.pack_cs_bytes();
                                                   for(int j=0;j<tranm_seq_cs.bytestream_cs.size();j++)
                                                   begin //{
                                                      if(j == 0)
                                                       merge_pkt.bs_merged_pkt.insert(merge_loc+j,{1'b1,tranm_seq_cs.bytestream_cs[j]});
                                                      else if((j == tranm_seq_cs.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                                       merge_pkt.bs_merged_pkt.insert(merge_loc+j,{1'b1,tranm_seq_cs.bytestream_cs[j]});
                                                      else
                                                       merge_pkt.bs_merged_pkt.insert(merge_loc+j,{1'b0,tranm_seq_cs.bytestream_cs[j]});
                                                   end //} 
                                                embed_inc = 1'b1;
                                                end //}
                                                else 
                                                begin //{
                                                    embed_inc = 1'b0;
                                                end //} 
                                             end //}       
                                        end //}
                                       end //}*/
//if(pl_pkt_q.size()!=0)
//continue;
                                       if(pl_gencs_q.size() != 0)
                                       begin //{
                                            for(int i=0;i<pl_gencs_q.size();i++)
                                            begin //{
                                               tranm_csins = new pl_gencs_q[i];
                                               if(tranm_csins.stype1 == 3'b100 || tranm_csins.stype1 == 3'b011 || tranm_csins.stype1 == 3'b000 || tranm_csins.stype1 == 3'b001 || tranm_csins.stype1 == 3'b010)
                                               begin //{
                                                   pl_gencs_q.delete(i);
                                                   merge_cs = new();
                                                   for(int i = 0;i<tranm_csins.bytestream_cs.size();i++)
                                                   begin //{ 
                                                    if(i == 0)
                                                     merge_cs.bs_merged_cs[i] = {1'b1,tranm_csins.bytestream_cs[i]};
                                                    else if((i == tranm_csins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                                     merge_cs.bs_merged_cs[i] = {1'b1,tranm_csins.bytestream_cs[i]};
                                                    else
                                                     merge_cs.bs_merged_cs[i] = {1'b0,tranm_csins.bytestream_cs[i]};
                                                   end //}
                                                   if(tranm_csins.stype1 == 3'b100)
                                                   begin //{
                                                      merge_cs.link_req_en = 1'b1;
                                                   end //}
                                                   else if(tranm_csins.stype1 == 3'b011)
                                                   begin //{
                                                      merge_cs.rst_frm_rty_en = 1'b1;
                                                   end //}
                                                   merge_cs.m_type = MERGED_CS; 
                                                   pktcs_proc_q.push_back(merge_cs);
                                               end //}
                                               else if(tranm_csins.stype0 == 4'b0000 || tranm_csins.stype0 == 4'b0001 || tranm_csins.stype0 == 4'b0010 || tranm_csins.stype0 == 4'b0100 || tranm_csins.stype0 == 4'b0101 ||tranm_csins.stype0 == 4'b0110)
                                               begin //{
                                                  pl_gencs_q.delete(i);
                                                  if(~pktm_trans.bfm_idle_selected)
                                                     tranm_csins.cstype = CS24;
                                                  else 
                                                     tranm_csins.cstype = CS48;
                                                  tranm_csins.stype1 = 3'b010;
                                                  tranm_csins.cmd    = 3'b000;
                                                  tranm_cs_ins.brc3_stype1_msb = 2'b00; 
                                                  if(pktm_trans.bfm_idle_selected)
                                                  begin //{ 
                                                   tranm_csins.cs_crc13 =  tranm_csins.calccrc13(tranm_csins.pack_cs());
                                                  end //}
                                                  else
                                                  begin //{
                                                   tranm_csins.cs_crc5 =  tranm_csins.calccrc5(tranm_csins.pack_cs());
                                                  end //}  
                                                  if(tranm_csins.stype0 == 4'b0110)
                                                  begin //{
                                                      merge_cs.link_resp_en = 1'b1;
                                                  end //}
                                                  void'(tranm_csins.set_delimiter());
                                                  void'(tranm_csins.pack_cs_bytes());  
                                                  break;
                                               end //}    
                                            end  //}
                                       end //}
                                       else if(pl_seqcs_q.size() != 0)
                                       begin //{
                                            for(int i=0;i<pl_seqcs_q.size();i++)
                                            begin //{
                                               tranm_csins = new pl_seqcs_q[i];
                                                if(tranm_csins.stype0 == 4'b0000 || tranm_csins.stype0 == 4'b0001 || tranm_csins.stype0 == 4'b0010 || tranm_csins.stype0 == 4'b0110 || tranm_csins.stype0 == 4'b0100)
                                                pl_seqcs_q.delete(i);
                                                if(~pktm_trans.bfm_idle_selected)
                                                   tranm_csins.cstype = CS24;
                                                else 
                                                   tranm_csins.cstype = CS48;
                                                tranm_csins.stype1 = 3'b010;
                                                tranm_csins.cmd    = 3'b000;
                                                tranm_csins.brc3_stype1_msb = 2'b00; 
                                                if(pktm_trans.bfm_idle_selected)
                                                begin //{ 
                                                 tranm_csins.cs_crc13 =  tranm_csins.calccrc13(tranm_csins.pack_cs());
                                                end //}
                                                else
                                                begin //{
                                                 tranm_csins.cs_crc5 =  tranm_csins.calccrc5(tranm_csins.pack_cs());
                                                end //}  
                                                void'(tranm_csins.set_delimiter());
                                                void'(tranm_csins.pack_cs_bytes());  
                                                break;    
                                            end //}
                                       end //}
                                     else 
                                     begin //{ 
                                        reset_status_cnt();
                                        tranm_csins = new();
                                        if(~pktm_trans.bfm_idle_selected)
                                          tranm_csins.cstype = CS24;
                                        else 
                                           tranm_csins.cstype = CS48;
                                        tranm_csins.stype1 = 3'b010;
                                        tranm_csins.cmd    = 3'b000;
                                        tranm_csins.brc3_stype1_msb = 2'b00; 
                                        tranm_csins.stype0 = 4'b0100;
                                        if(pktm_trans.bfm_idle_selected)
                                         tranm_csins.param0 =   pktm_trans.curr_rx_ackid; //pkt_handler_ins.ackid;
                                        else
                                         tranm_csins.param0 =   pktm_trans.curr_rx_ackid; //pkt_handler_ins.ackid;
                                        if(pktm_config.multiple_ack_support)
                                         tranm_csins.param0 = pktm_trans.gr_curr_tx_ackid;
                                        if(pktm_config.flow_control_mode == RECEIVE)
                                          tranm_csins.param1 = 12'hfff;
                                        else
                                        begin //{
                                          if(pktm_env_config.multi_vc_support == 1'b0)
                                            tranm_csins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_q.size();
                                          else
                                            tranm_csins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_vc0_q.size();
                                        end //}
                                        if(pktm_trans.bfm_idle_selected)
                                        begin //{ 
                                         tranm_csins.cs_crc13 =  tranm_csins.calccrc13(tranm_csins.pack_cs());
                                        end //}
                                        else
                                        begin //{
                                         tranm_csins.cs_crc5 =  tranm_csins.calccrc5(tranm_csins.pack_cs());
                                        end //} 
                                        void'(tranm_csins.set_delimiter());
                                        void'(tranm_csins.pack_cs_bytes());  
                                      end //}  
                                      for(int i=0;i<tranm_csins.bytestream_cs.size();i++)
                                      begin //{ 
                                       if(i == 0)
                                        merge_pkt.bs_merged_pkt.push_back({1'b1,tranm_csins.bytestream_cs[i]});
                                       else if(i == tranm_csins.bytestream_cs.size()-1 && pktm_trans.bfm_idle_selected)
                                        merge_pkt.bs_merged_pkt.push_back({1'b1,tranm_csins.bytestream_cs[i]});
                                       else
                                        merge_pkt.bs_merged_pkt.push_back({1'b0,tranm_csins.bytestream_cs[i]});
                                      end //}
                                     merge_pkt.m_type = MERGED_PKT; 
                                     pktcs_proc_q.push_back(merge_pkt);
                                end //}
                             end //}
                          end //}  
                         if(pl_gencs_q.size() != 0 &&  pktm_trans.link_initialized)
                         begin //{
                           tranm_gen_ins = new(); 
                           tranm_gen_ins = pl_gencs_q[0];
                           pl_gencs_q.delete(0);
                           merge_cs = new();
                           for(int i = 0;i<tranm_gen_ins.bytestream_cs.size();i++)
                           begin //{ 
                            if(i == 0)
                             merge_cs.bs_merged_cs[i] = {1'b1,tranm_gen_ins.bytestream_cs[i]};
                            else if((i == tranm_gen_ins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                             merge_cs.bs_merged_cs[i] = {1'b1,tranm_gen_ins.bytestream_cs[i]};
                            else
                             merge_cs.bs_merged_cs[i] = {1'b0,tranm_gen_ins.bytestream_cs[i]};
                           end //}
                           if(tranm_gen_ins.stype1 == 3'b100)
                           begin //{
                              merge_cs.link_req_en = 1'b1;
                           end //}
                           else if(tranm_gen_ins.stype1 == 3'b011)
                           begin //{
                              merge_cs.rst_frm_rty_en = 1'b1;
                           end //}
                           if(tranm_gen_ins.stype0 == 4'b0110)
                           begin //{
                               merge_cs.link_resp_en = 1'b1;
                           end //}
                           merge_cs.m_type = MERGED_CS; 
                           pktcs_proc_q.push_back(merge_cs);
                         end //}
                         if(pl_seqcs_q.size() != 0 &&  pktm_trans.link_initialized)
                         begin //{
                           tranm_seq_ins = new(); 
                           tranm_seq_ins = pl_seqcs_q[0];
                           pl_seqcs_q.delete(0);
                           merge_cs = new();
                           for(int i = 0;i<tranm_seq_ins.bytestream_cs.size();i++)
                           begin //{ 
                            if(i == 0)
                             merge_cs.bs_merged_cs[i] = {1'b1,tranm_seq_ins.bytestream_cs[i]};
                            else if((i == tranm_seq_ins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                             merge_cs.bs_merged_cs[i] = {1'b1,tranm_seq_ins.bytestream_cs[i]};
                            else
                             merge_cs.bs_merged_cs[i] = {1'b0,tranm_seq_ins.bytestream_cs[i]};
                           end //}
                           if(tranm_seq_ins.stype1 == 3'b100)
                           begin //{
                              merge_cs.link_req_en = 1'b1;
                           end //}
                           else if(tranm_seq_ins.stype1 == 3'b011)
                           begin //{
                              merge_cs.rst_frm_rty_en = 1'b1;
                           end //}
                           if(tranm_seq_ins.stype0 == 4'b0110)
                           begin //{
                               merge_cs.link_resp_en = 1'b1;
                           end //}
                           merge_cs.m_type = MERGED_CS; 
                           pktcs_proc_q.push_back(merge_cs);
                         end //}
                         if(pl_gencs_q.size() != 0 &&  ~pktm_trans.link_initialized && ~pktm_trans.port_initialized)
                         begin //{
                           tranm_gen_ins = new(); 
                           tranm_gen_ins = pl_gencs_q[0];
                           pl_gencs_q.delete(0);
                           merge_cs = new();
                           for(int i = 0;i<tranm_gen_ins.bytestream_cs.size();i++)
                           begin //{ 
                            if(i == 0)
                             merge_cs.bs_merged_cs[i] = {1'b1,tranm_gen_ins.bytestream_cs[i]};
                            else if((i == tranm_gen_ins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                             merge_cs.bs_merged_cs[i] = {1'b1,tranm_gen_ins.bytestream_cs[i]};
                            else
                             merge_cs.bs_merged_cs[i] = {1'b0,tranm_gen_ins.bytestream_cs[i]};
                           end //}
                           if(tranm_gen_ins.stype1 == 3'b100)
                           begin //{
                              merge_cs.link_req_en = 1'b1;
                           end //}
                           else if(tranm_gen_ins.stype1 == 3'b011)
                           begin //{
                              merge_cs.rst_frm_rty_en = 1'b1;
                           end //}
                           if(tranm_gen_ins.stype0 == 4'b0110)
                           begin //{
                               merge_cs.link_resp_en = 1'b1;
                           end //}
                           merge_cs.m_type = MERGED_CS; 
                           pktcs_proc_q.push_back(merge_cs);
                         end //}
                       end //}
                      if(pktm_trans.oes_state == 1'b1 && pktm_trans.link_initialized)
                           state = MERGE_OES;
                      else if(pktm_trans.ors_state == 1'b1 && pktm_trans.link_initialized)
                           state = MERGE_ORS;
                      else if(pktm_trans.irs_state == 1'b1 && pktm_trans.link_initialized)
                           state = MERGE_IRS;
                       else if(pktm_trans.link_initialized && pktm_trans.ies_state == 1'b1)
                            state = MERGE_IES;
                      else if(pktm_trans.irs_state == 1'b0 && pktm_trans.link_initialized)
                            state = MERGE_NORMAL;
                      else if(pktm_trans.irs_state == 1'b1 && ~pktm_trans.link_initialized && pktm_trans.port_initialized)
                           state = MERGE_IRS;

                     end //}  

        MERGE_ORS  : begin //{
                      if(pktm_trans.ors_state)
                      begin //{ 
                         if(pl_gencs_q.size() != 0 &&  pktm_trans.link_initialized)
                         begin //{
                           tranm_gen_ins = new(); 
                           tranm_gen_ins = pl_gencs_q[0];
                           pl_gencs_q.delete(0);
                           merge_cs = new();
                           for(int i = 0;i<tranm_gen_ins.bytestream_cs.size();i++)
                           begin //{ 
                            if(i == 0)
                             merge_cs.bs_merged_cs[i] = {1'b1,tranm_gen_ins.bytestream_cs[i]};
                            else if((i == tranm_gen_ins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                             merge_cs.bs_merged_cs[i] = {1'b1,tranm_gen_ins.bytestream_cs[i]};
                            else
                             merge_cs.bs_merged_cs[i] = {1'b0,tranm_gen_ins.bytestream_cs[i]};
                           end //}
                           if(tranm_gen_ins.stype1 == 3'b100)
                           begin //{
                              merge_cs.link_req_en = 1'b1;
                           end //}
                           else if(tranm_gen_ins.stype1 == 3'b011)
                           begin //{
                              merge_cs.rst_frm_rty_en = 1'b1;
                           end //}
                           if(tranm_gen_ins.stype0 == 4'b0110)
                           begin //{
                               merge_cs.link_resp_en = 1'b1;
                           end //}
                           merge_cs.m_type = MERGED_CS; 
                           pktcs_proc_q.push_back(merge_cs);
                         end //}
                         if(pl_seqcs_q.size() != 0 &&  pktm_trans.link_initialized)
                         begin //{
                           tranm_seq_ins = new(); 
                           tranm_seq_ins = pl_seqcs_q[0];
                           pl_seqcs_q.delete(0);
                           merge_cs = new();
                           for(int i = 0;i<tranm_seq_ins.bytestream_cs.size();i++)
                           begin //{ 
                            if(i == 0)
                             merge_cs.bs_merged_cs[i] = {1'b1,tranm_seq_ins.bytestream_cs[i]};
                            else if((i == tranm_seq_ins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                             merge_cs.bs_merged_cs[i] = {1'b1,tranm_seq_ins.bytestream_cs[i]};
                            else
                             merge_cs.bs_merged_cs[i] = {1'b0,tranm_seq_ins.bytestream_cs[i]};
                           end //}
                           if(tranm_seq_ins.stype1 == 3'b100)
                           begin //{
                              merge_cs.link_req_en = 1'b1;
                           end //}
                           else if(tranm_seq_ins.stype1 == 3'b011)
                           begin //{
                              merge_cs.rst_frm_rty_en = 1'b1;
                           end //}
                           if(tranm_seq_ins.stype0 == 4'b0110)
                           begin //{
                               merge_cs.link_resp_en = 1'b1;
                           end //}
                           merge_cs.m_type = MERGED_CS; 
                           pktcs_proc_q.push_back(merge_cs);
                         end //}
                         if(pl_gencs_q.size() != 0 &&  ~pktm_trans.link_initialized && pktm_trans.port_initialized)
                         begin //{
                           tranm_gen_ins = new(); 
                           tranm_gen_ins = pl_gencs_q[0];
                           pl_gencs_q.delete(0);
                           merge_cs = new();
                           for(int i = 0;i<tranm_gen_ins.bytestream_cs.size();i++)
                           begin //{ 
                            if(i == 0)
                             merge_cs.bs_merged_cs[i] = {1'b1,tranm_gen_ins.bytestream_cs[i]};
                            else if((i == tranm_gen_ins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                             merge_cs.bs_merged_cs[i] = {1'b1,tranm_gen_ins.bytestream_cs[i]};
                            else
                             merge_cs.bs_merged_cs[i] = {1'b0,tranm_gen_ins.bytestream_cs[i]};
                           end //}
                           if(tranm_gen_ins.stype1 == 3'b100)
                           begin //{
                              merge_cs.link_req_en = 1'b1;
                           end //}
                           else if(tranm_gen_ins.stype1 == 3'b011)
                           begin //{
                              merge_cs.rst_frm_rty_en = 1'b1;
                           end //}
                           if(tranm_gen_ins.stype0 == 4'b0110)
                           begin //{
                               merge_cs.link_resp_en = 1'b1;
                           end //}
                           merge_cs.m_type = MERGED_CS; 
                           pktcs_proc_q.push_back(merge_cs);
                         end //}
                       end //}
                       else 
                       begin //{
                          if(pl_outstanding_ackid_q.size() != 0)
                          begin //{
                            retry_ackid = pkt_handler_ins.retried_ackid; 
                            q_siz=pl_outstanding_ackid_q.size();
                            for(int i=0;i<q_siz;i++)
                            begin //{
                               rty_ackid_trans = new pl_outstanding_ackid_q[0];
                               if(rty_ackid_trans.ackid == retry_ackid)
                               begin //{
                                  //pl_outstanding_ackid_q.delete(0);
                                   break;
                               end //}
                               else if(rty_ackid_trans.ackid < retry_ackid)
                               begin //{
                                  pl_outstanding_ackid_q.delete(0);
                               end //}
                            end //} 
                            temp_size = pl_outstanding_ackid_q.size();
                            for(int i=0;i<temp_size;i++)
                            begin //{
                                if(pl_outstanding_ackid_q.size()!=0)
                                  pl_pkt_q.push_front(pl_outstanding_ackid_q.pop_back());
                            end //} 
                            sorter();
                             if(pl_gencs_q.size() != 0)
                             begin //{
                                  for(int i=0;i<pl_gencs_q.size();i++)
                                  begin //{
                                     merge_trans_ins = new pl_gencs_q[i];
                                     if(merge_trans_ins.stype1 == 3'b100 || merge_trans_ins.stype1 == 3'b011 || merge_trans_ins.stype1 == 3'b000 || merge_trans_ins.stype1 == 3'b001 || merge_trans_ins.stype1 == 3'b010)
                                     begin //{
                                         pl_gencs_q.delete(i);
                                         merge_cs = new();
                                         for(int i = 0;i<merge_trans_ins.bytestream_cs.size();i++)
                                         begin //{
                                          if(i == 0)
                                           merge_cs.bs_merged_cs[i] = {1'b1,merge_trans_ins.bytestream_cs[i]};
                                          else if((i == merge_trans_ins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                           merge_cs.bs_merged_cs[i] = {1'b1,merge_trans_ins.bytestream_cs[i]};
                                          else 
                                           merge_cs.bs_merged_cs[i] = {1'b0,merge_trans_ins.bytestream_cs[i]};
                                         end //}
                                         if(merge_trans_ins.stype1 == 3'b100)
                                         begin //{
                                            merge_cs.link_req_en = 1'b1;
                                         end //}
                                         else if(merge_trans_ins.stype1 == 3'b011)
                                         begin //{
                                            merge_cs.rst_frm_rty_en = 1'b1;
                                         end //}
                                         merge_cs.m_type = MERGED_CS;
                                         pktcs_proc_q.push_back(merge_cs);
                                     end //}
                                     /*else if(merge_trans_ins.stype0 == 4'b0110)
                                     begin //{
                                         pl_gencs_q.delete(i);
                                         merge_cs = new();
                                         for(int i = 0;i<merge_trans_ins.bytestream_cs.size();i++)
                                         begin //{
                                          if(i == 0)
                                           merge_cs.bs_merged_cs[i] = {1'b1,merge_trans_ins.bytestream_cs[i]};
                                          else if((i == merge_trans_ins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                                           merge_cs.bs_merged_cs[i] = {1'b1,merge_trans_ins.bytestream_cs[i]};
                                          else
                                           merge_cs.bs_merged_cs[i] = {1'b0,merge_trans_ins.bytestream_cs[i]};
                                         end //}
                                         if(merge_trans_ins.stype0 == 4'b0110)
                                         begin //{
                                             merge_cs.link_resp_en = 1'b1;
                                         end //}
                                         merge_cs.m_type = MERGED_CS;
                                         pktcs_proc_q.push_back(merge_cs);
                                     end //}*/
                                     else if(merge_trans_ins.stype0 == 4'b0000 || merge_trans_ins.stype0 == 4'b0001 || merge_trans_ins.stype0 == 4'b0010 || merge_trans_ins.stype0 == 4'b0100 || merge_trans_ins.stype0 == 4'b0101 || merge_trans_ins.stype0 == 4'b0110)
                                     begin //{
                                        pl_gencs_q.delete(i);
                                        if(pktm_trans.bfm_idle_selected)
                                           merge_trans_ins.cstype = CS48;
                                        else
                                           merge_trans_ins.cstype = CS24;
                                        merge_trans_ins.stype1 = 3'b000;
                                        merge_trans_ins.cmd    = 3'b000;
                                        merge_trans_ins.brc3_stype1_msb = 2'b00;
                                        if(pktm_trans.bfm_idle_selected)
                                        begin //{
                                         merge_trans_ins.cs_crc13 =  merge_trans_ins.calccrc13(merge_trans_ins.pack_cs());
                                        end //}
                                        else
                                        begin //{
                                         merge_trans_ins.cs_crc5 =  merge_trans_ins.calccrc5(merge_trans_ins.pack_cs());
                                        end //}
                                        if(merge_trans_ins.stype0 == 4'b0110)
                                        begin //{
                                            merge_cs.link_resp_en = 1'b1;
                                        end //}
                                        void'(merge_trans_ins.set_delimiter());
                                        void'(merge_trans_ins.pack_cs_bytes());
                                        break;
                                     end   //}
                                 end   //}
                             end //}
                            else
                             begin//{
                            reset_status_cnt();
                            merge_trans_ins = new();
                            merge_trans_ins.stype0 = 4'b0100;
                            merge_trans_ins.param0 =  pktm_trans.curr_rx_ackid;
                              if(pktm_config.multiple_ack_support)
                               merge_trans_ins.param0 = pktm_trans.gr_curr_tx_ackid;
                            merge_trans_ins.param1 =  12'hFFF;
                            merge_trans_ins.stype1 = 3'b000;
                            merge_trans_ins.cmd    = 3'b000;
                            merge_trans_ins.brc3_stype1_msb= 2'b00;
                            if(pktm_trans.bfm_idle_selected)
                               merge_trans_ins.cstype = CS48;
                            else
                               merge_trans_ins.cstype = CS24; 
                            if(pktm_trans.bfm_idle_selected)
                              void'(merge_trans_ins.calccrc13(merge_trans_ins.pack_cs()));
                            else
                              void'(merge_trans_ins.calccrc5(merge_trans_ins.pack_cs())); 
                            merge_trans_ins.delimiter = 8'h7C;
                            void'(merge_trans_ins.pack_cs_bytes());
                             end//}
                            merge_pkt = new();
                            for(int i = 0;i<merge_trans_ins.bytestream_cs.size();i++)
                            begin //{ 
                              if(i == 0)
                               merge_pkt.bs_merged_pkt[i] = {1'b1,merge_trans_ins.bytestream_cs[i]};
                              else if((i == merge_trans_ins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                               merge_pkt.bs_merged_pkt[i] = {1'b1,merge_trans_ins.bytestream_cs[i]};
                              else
                               merge_pkt.bs_merged_pkt[i] = {1'b0,merge_trans_ins.bytestream_cs[i]};
                            end //}
                               rty_ackid_trans = pl_pkt_q.pop_front();
                            pl_outstanding_ackid_q.push_back(rty_ackid_trans);
                            pktm_trans.mul_ack_max=rty_ackid_trans.ackid;
                            for(int i = 0;i<rty_ackid_trans.bytestream.size();i++)
                            begin //{
                                merge_pkt.bs_merged_pkt.push_back({1'b0,rty_ackid_trans.bytestream[i]});
                            end //}
                            tranm_csins = new();
                            if(~pktm_trans.bfm_idle_selected)
                              tranm_csins.cstype = CS24;
                            else 
                               tranm_csins.cstype = CS48;
                            tranm_csins.stype1 = 3'b010;
                            tranm_csins.cmd    = 3'b000;
                            tranm_csins.brc3_stype1_msb = 2'b00;
                            tranm_csins.stype0 = 4'b0100;
                            reset_status_cnt();


                            if(pktm_trans.bfm_idle_selected)
                             tranm_csins.param0 =   pktm_trans.curr_rx_ackid;
                            else
                             tranm_csins.param0 =   pktm_trans.curr_rx_ackid;
                            if(pktm_config.multiple_ack_support)
                             tranm_csins.param0 = pktm_trans.gr_curr_tx_ackid;
                            
                            if(pktm_config.flow_control_mode == RECEIVE)
                              tranm_csins.param1 = 12'hFFF;
                            else
                            begin //{
                              if(pktm_env_config.multi_vc_support == 1'b0)
                                tranm_csins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_q.size();
                              else
                                tranm_csins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_vc0_q.size();
                            end //}
                                  
                            if(pktm_trans.bfm_idle_selected)
                            begin //{ 
                             tranm_csins.cs_crc13 =  tranm_csins.calccrc13(tranm_csins.pack_cs());
                            end //}
                            else
                            begin //{
                             tranm_csins.cs_crc5 =  tranm_csins.calccrc5(tranm_csins.pack_cs());
                            end //} 
                            void'(tranm_csins.set_delimiter());
                            void'(tranm_csins.pack_cs_bytes());  
                            for(int i=0;i<tranm_csins.bytestream_cs.size();i++)
                            begin //{ 
                             if(i == 0)
                              merge_pkt.bs_merged_pkt.push_back({1'b1,tranm_csins.bytestream_cs[i]});
                             else if(i == tranm_csins.bytestream_cs.size()-1 && pktm_trans.bfm_idle_selected)
                              merge_pkt.bs_merged_pkt.push_back({1'b1,tranm_csins.bytestream_cs[i]});
                             else
                              merge_pkt.bs_merged_pkt.push_back({1'b0,tranm_csins.bytestream_cs[i]});
                            end //}
                            merge_pkt.m_type = MERGED_PKT; 
                            pktcs_proc_q.push_back(merge_pkt);
                          end //} 
                       end //}
                      if(pktm_trans.oes_state == 1'b1 && pktm_trans.link_initialized)
                           state = MERGE_OES;
                      else if(pktm_trans.link_initialized && pktm_trans.ors_state == 1'b1) //chngd order, -b4 IES
                            state = MERGE_ORS;
                      else if(pktm_trans.ies_state == 1'b1 && pktm_trans.link_initialized)
                           state = MERGE_IES;
                      else if(pktm_trans.irs_state == 1'b1 && pktm_trans.link_initialized)
                           state = MERGE_IRS;
                      else if(pktm_trans.ors_state == 1'b0 && pktm_trans.link_initialized)
                            state = MERGE_NORMAL;
                      else if(pktm_trans.port_initialized && pktm_trans.ors_state == 1'b1)
                            state = MERGE_ORS;
                     end //}  
         endcase 
         end //}      
    end //}
  end //}

 endtask : pktcs_merge

///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_stomp_cs
/// Description :Task to form stomp control symbol 
///////////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_pktcs_merger::gen_stomp_cs();

     trans_push_ins = new();
     trans_push_ins.pkt_type = SRIO_PL_PACKET;
     trans_push_ins.transaction_kind = SRIO_CS;
     trans_push_ins.stype0 = 4'b0100;
     if(pktm_trans.bfm_idle_selected)
       trans_push_ins.cstype = CS48;
     else
       trans_push_ins.cstype = CS24;
     if(pktm_trans.bfm_idle_selected)
       trans_push_ins.param0 = pktm_trans.curr_rx_ackid;
     else
       trans_push_ins.param0 = pktm_trans.curr_rx_ackid;
     if(pktm_config.multiple_ack_support)
      trans_push_ins.param0 = pktm_trans.gr_curr_tx_ackid;
     if(pktm_config.flow_control_mode == RECEIVE)
       trans_push_ins.param1 = 12'hFFF;
     else
     begin //{
       if(pktm_env_config.multi_vc_support == 1'b0)
         trans_push_ins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_q.size();
       else
         trans_push_ins.param1 = pktm_config.buffer_space - pkt_handler_ins.receive_pkt_vc0_q.size();
     end //}

     trans_push_ins.stype1  = 3'b001;
     trans_push_ins.cmd     = 3'b000;
     trans_push_ins.brc3_stype1_msb = 2'b00;
 
     if(pktm_trans.bfm_idle_selected)
       void'(trans_push_ins.calccrc13(trans_push_ins.pack_cs()));
     else
       void'(trans_push_ins.calccrc5(trans_push_ins.pack_cs()));
       
     trans_push_ins.delimiter = 8'h7C;
     void'(trans_push_ins.pack_cs_bytes());
   
 endtask : gen_stomp_cs
 

///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : pktcs_merge_txrx
/// Description :Task to form the queue of delimited packets and control symbols which are
/// to be transmitted on the lane for the TXRX model.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_pktcs_merger::pktcs_merge_txrx();
  forever
    begin //{
     @(posedge pktm_trans.int_clk or negedge srio_if.srio_rst_n)
      begin //{  
       if(~srio_if.srio_rst_n)
         begin //{
          eop_rcvd=0;
         end//}
       else
         begin //{
//Packets and control symbols which are to be transmitted are placed in the queue .
          if(pl_seqcs_q.size() != 0 && pktm_trans.port_initialized)
           begin //{
             tranm_gen_ins = new(); 
             tranm_gen_ins = pl_seqcs_q[0];
             pl_seqcs_q.delete(0);
             if(tranm_gen_ins.stype0==4'b100)
              begin//{
               if (pktm_trans.rx_status_cs_cnt>0)
                 pktm_trans.tx_status_cs_cnt += 1;
               if(pktm_trans.link_initialized)
                 pktm_trans.tx_status_cs_cnt = 0;
              end//}
                merge_cs = new();
                if(pktm_env_config.srio_mode != SRIO_GEN30)
                 begin //{
                  if(tranm_gen_ins.stype1==3'b000)
                    tp_trans=new tranm_gen_ins;
                  if(tranm_gen_ins.stype1==3'b010)
                    begin//{
                     tp_trans1=new tranm_gen_ins;
                     eop_rcvd=1;
                    end//}
                  if((tranm_gen_ins.stype1!=3'b000 && tranm_gen_ins.stype1!=3'b010) )
                    begin//{   
                     for(int i = 0;i<tranm_gen_ins.bytestream_cs.size();i++)
                     begin //{ 
                      if(i == 0)
                       merge_cs.bs_merged_cs[i] = {1'b1,tranm_gen_ins.bytestream_cs[i]};
                      else if((i == tranm_gen_ins.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                       merge_cs.bs_merged_cs[i] = {1'b1,tranm_gen_ins.bytestream_cs[i]};
                      else
                       merge_cs.bs_merged_cs[i] = {1'b0,tranm_gen_ins.bytestream_cs[i]};
                       end //}
                      merge_cs.m_type = MERGED_CS; 
                      pktcs_proc_q.push_back(merge_cs);
                     end //}
                 end//}
                else
                 begin //{
                  if(tranm_gen_ins.brc3_stype1_msb==2'b10||tranm_gen_ins.brc3_stype1_msb==2'b11)
                    tp_trans=new tranm_gen_ins;
                  tmp={tranm_gen_ins.brc3_stype1_msb,tranm_gen_ins.stype1,tranm_gen_ins.cmd};
                  if(tmp==12'h10 || tmp==12'h11)
                    begin//{
                     tp_trans1=new tranm_gen_ins;
                     eop_rcvd=1;
                    end//}
                  if(tranm_gen_ins.brc3_stype1_msb!=2'b10 && tranm_gen_ins.brc3_stype1_msb!=2'b11 && {tranm_gen_ins.stype1,tranm_gen_ins.cmd}!=12'h10 && {tranm_gen_ins.stype1,tranm_gen_ins.cmd}!=12'h11)
                   begin//{
                    merge_cs.brc3_merged_cs[0] = {2'b10,tranm_gen_ins.stype0,tranm_gen_ins.param0,tranm_gen_ins.param1,tranm_gen_ins.brc3_stype1_msb,2'b01,32'h0000_0000};
                    merge_cs.brc3_merged_cs[1] = {2'b10,tranm_gen_ins.stype1,tranm_gen_ins.cmd,tranm_gen_ins.cs_crc24,2'b10,32'h0000_0000};
                   end//}
                   merge_cs.m_type = MERGED_CS; 
                   pktcs_proc_q.push_back(merge_cs);
                 end//}
           end//}
          else if(pl_pkt_q.size() != 0 && pktm_trans.port_initialized && eop_rcvd==1)
           begin //{
            eop_rcvd=0;
            tranm_pkt_ins  = new pl_pkt_q.pop_front();
            pktm_trans.mul_ack_max=tranm_pkt_ins.ackid;
            merge_pkt = new();

            if(pktm_env_config.srio_mode != SRIO_GEN30)
             begin //{
              for(int i = 0;i<tp_trans.bytestream_cs.size();i++)
              begin //{ 
                if(i == 0)
                 merge_pkt.bs_merged_pkt[i] = {1'b1,tp_trans.bytestream_cs[i]};
                else if((i == tp_trans.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                 merge_pkt.bs_merged_pkt[i] = {1'b1,tp_trans.bytestream_cs[i]};
                else
                 merge_pkt.bs_merged_pkt[i] = {1'b0,tp_trans.bytestream_cs[i]};
              end //}
              for(int i = 0;i<tranm_pkt_ins.bytestream.size();i++)
                merge_pkt.bs_merged_pkt.push_back({1'b0,tranm_pkt_ins.bytestream[i]});
              for(int i = 0;i<tp_trans1.bytestream_cs.size();i++)
              begin //{ 
                if(i == 0)
                 merge_pkt.bs_merged_pkt.push_back({1'b1,tp_trans1.bytestream_cs[i]});
                else if((i == tp_trans1.bytestream_cs.size()-1) && pktm_trans.bfm_idle_selected)
                 merge_pkt.bs_merged_pkt.push_back({1'b1,tp_trans1.bytestream_cs[i]});
                else
                 merge_pkt.bs_merged_pkt.push_back({1'b0,tp_trans1.bytestream_cs[i]});
              end //}
             end//}
            else
             begin//{
              temp_ackid     = tranm_pkt_ins.ackid;
              tp_trans.stype1 = temp_ackid[0:2];
              tp_trans.cmd    = temp_ackid[3:5];
              for(int i = 0;i<tranm_pkt_ins.bytestream.size();i++)
              begin //{
                  temp_pkt_q.push_back(tranm_pkt_ins.bytestream[i]);
              end //}
              for(int i =0;i<4;i++)
              begin //{
                  if(temp_pkt_q.size() != 0)
                    temp_data[24:31] = temp_pkt_q.pop_front(); 
                  if(i!=3)
                    temp_data = temp_data << 8;
              end //}
              merge_pkt.brc3_merged_pkt[0] = {2'b10,tp_trans.stype0,tp_trans.param0,tp_trans.param1,tp_trans.brc3_stype1_msb,2'b01,32'h0000_0000};
              merge_pkt.brc3_merged_pkt[1] = {2'b10,tp_trans.stype1,tp_trans.cmd,tp_trans.cs_crc24,2'b10,temp_data};
              temp_size = temp_pkt_q.size();
              for(int i = 0;i<temp_size/8;i++)
              begin //{
                   temp0 = temp_pkt_q.pop_front();
                   temp1 = temp_pkt_q.pop_front();
                   temp2 = temp_pkt_q.pop_front();
                   temp3 = temp_pkt_q.pop_front();
                   temp4 = temp_pkt_q.pop_front();
                   temp5 = temp_pkt_q.pop_front();
                   temp6 = temp_pkt_q.pop_front();
                   temp7 = temp_pkt_q.pop_front();
                   merge_pkt.brc3_merged_pkt.push_back({2'b01,temp0,temp1,temp2,temp3,temp4,temp5,temp6,temp7});
              end //}

              for(int i =0;i<4;i++)
              begin //{
                if(temp_pkt_q.size() != 0)
                  temp_data[24:31] = temp_pkt_q.pop_front(); 
                if(i!=3)
                  temp_data = temp_data << 8;
              end //}
              merge_pkt.brc3_merged_pkt.push_back({2'b10,tp_trans1.stype0,tp_trans1.param0,tp_trans1.param1,tp_trans1.brc3_stype1_msb,2'b01,temp_data});
              merge_pkt.brc3_merged_pkt.push_back({2'b10,tp_trans1.stype1,tp_trans1.cmd,tp_trans1.cs_crc24,2'b10,32'h0000_0000});
             end//} 
              merge_pkt.m_type = MERGED_PKT; 
             pktcs_proc_q.push_back(merge_pkt);
           end//}
         end//}
     end//}
    end//}
endtask:pktcs_merge_txrx

///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : reset_status_cnt
/// Description : Resetting the Status Count 
///////////////////////////////////////////////////////////////////////////////////////////////
 function void srio_pl_pktcs_merger::reset_status_cnt();
     if(pktm_env_config.srio_mode == SRIO_GEN13 && pktm_trans.current_init_state==NX_MODE )
      pktm_trans.status_cnt = (pktm_config.code_group_sent_2_cs/pktm_env_config.num_of_lanes)-25;
     else
      pktm_trans.status_cnt = pktm_config.code_group_sent_2_cs-25;
 endfunction :reset_status_cnt 

///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : sorter
/// Description : Rearrange packets as per priority
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_pktcs_merger::sorter();
 srio_trans sw_ele,rebuild_ele;
 int out_q_size=0;
 int cal_ackid=0;

 out_q_size=pl_pkt_q.size();
    for(int i = 0; i < out_q_size; i++)
     begin//{
      for(int j = 1; j < (out_q_size-i); j++)
       begin//{
        if({pl_pkt_q[j-1].crf,pl_pkt_q[j-1].prio} < {pl_pkt_q[j].crf,pl_pkt_q[j].prio})
         begin//{
          sw_ele = pl_pkt_q[j-1];
          pl_pkt_q[j-1]=pl_pkt_q[j];
          pl_pkt_q[j]=sw_ele;
        end//}
      end//}
  end//}
  for(int k=0;k<out_q_size;k++)
   begin//{
    if(k==0)
     cal_ackid=retry_ackid; 
    pl_pkt_q[k].ackid=cal_ackid;
   if(pktm_env_config.srio_mode == SRIO_GEN30)
   begin //{
      if(cal_ackid== 4095)
        cal_ackid= 0;
      else
        cal_ackid= cal_ackid+ 1; 
   end //}
   else if(pktm_trans.bfm_idle_selected)
   begin //{
      if(cal_ackid== 63)
        cal_ackid= 0;
      else
        cal_ackid= cal_ackid+ 1; 
   end //}
   else
   begin //{
      if(cal_ackid== 31)
        cal_ackid= 0;
      else
        cal_ackid= cal_ackid+ 1; 
   end //}    
    rebuild_ele=new pl_pkt_q[k];
    void'(rebuild_ele.pack_bytes(rebuild_ele.bytestream));
    pl_pkt_q[k]=rebuild_ele;
   end//}


endtask:sorter
