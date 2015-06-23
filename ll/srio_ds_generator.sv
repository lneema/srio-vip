////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ds_generator.sv
// Project :  srio vip
// Purpose :  Data Stream Packet Generation
// Author  :  Mobiveil
//
// This components handles the generation of Data Stream packets.
// Inherited from srio_ll_base_generator
//////////////////////////////////////////////////////////////////////////////// 

class srio_ds_generator extends srio_ll_base_generator;
  /// @cond
  `uvm_component_utils(srio_ds_generator) 
  /// @endcond

  srio_trans ds_pkt_q[int][$];    ///< Associative array of queue,stores the DS packets interleaved mode
  srio_trans ds_seq_pkt_q[$];     ///< Queue to store DS packets in non-interleaved mode 

  extern function new(string name="SRIO_DS_GENERATOR", uvm_component parent = null); ///< New function 
  extern virtual task generate_ds_pkt();                 ///< Generates DS packets
  extern virtual task generate_ds_tm_pkt();              ///< Generates DS TM packets  
  extern virtual task push_pkt(srio_trans i_srio_trans); ///< receives packets from sequence
  extern virtual task get_next_pkt(bit[2:0] sub_type,bit[31:0] tx_pkt_id,output bool pkt_valid,output srio_trans o_srio_trans);
                                                         ///< Provides the the packet to packet scheduler

endclass: srio_ds_generator

//////////////////////////////////////////////////////////////////////////
/// Name: new \n
/// Description: DS generator's new function \n
/// new
//////////////////////////////////////////////////////////////////////////

function srio_ds_generator::new(string name="SRIO_DS_GENERATOR", uvm_component parent=null);
  super.new(name, parent);
endfunction: new

//////////////////////////////////////////////////////////////////////////
/// Name: push_pkt \n
/// Description: Called by logic trans generator when DS packet is \n
/// received from sequence. Based on XH bit value,invokes DS or DS TM \n
/// generator task \n
/// push_pkt
//////////////////////////////////////////////////////////////////////////

task srio_ds_generator::push_pkt(srio_trans i_srio_trans);
begin 
   srio_trans_item = new i_srio_trans;
   srio_trans_item.env_config = this.env_config;
   if(srio_trans_item.xh == 1)                  // Check the xh bit to check DS or DS TM packet
     generate_ds_tm_pkt;                        // Call the correxponding generation task
   else
     generate_ds_pkt;
end
endtask: push_pkt

//////////////////////////////////////////////////////////////////////////
/// Name: generate_ds_tm_pkt \n
/// Description: generates DS TM packets \n
/// generate_ds_tm_pkt
//////////////////////////////////////////////////////////////////////////

task srio_ds_generator::generate_ds_tm_pkt;
begin 
   ll_common_class.get_next_pkt_id(srio_trans_item.ll_pkt_id); // Get the packet id from common class and assign it
   print_ll_tx_rx(TRUE,srio_trans_item);                       // Prints packet generator information
   if(ll_config.interleaved_pkt == TRUE)                       // Interleaved is TRUE, using the cos value 
      ds_pkt_q[srio_trans_item.cos].push_back(srio_trans_item);// push it to the array
   else
      ds_seq_pkt_q.push_back(srio_trans_item);                 // In order, store it in the queue
   ll_common_class.pkt_cnt_update(TRUE);                       // Increment the packet count
end
endtask: generate_ds_tm_pkt

//////////////////////////////////////////////////////////////////////////
/// Name: generate_ds_pkt \n
/// Description: generates DS packets.User generated packets will not be \n
/// modified.i.e User has taken care of creating proper DS segments. \n
/// Otherwise this task handles generation of generating the required \n
/// segments using PDU length and mtu size \n
/// generate_ds_pkt
//////////////////////////////////////////////////////////////////////////

task srio_ds_generator::generate_ds_pkt;
logic S;
logic E;
logic O;
logic P;
logic [7:0]  COS;
logic [15:0] streamID;
logic [15:0] pdulength;
logic [7:0]  mtusize;
logic [8:0]  mtu_size;
logic [16:0] pdusize;
logic [16:0] seg_tot_byte;
bit   [7:0]  payload[$];
int  no_of_segments;
int  ds_index;
int  act_byte;
int  rand_err_seg;
srio_trans srio_trans_tmp;
begin
 
    COS = srio_trans_item.cos;            // DS packets are stored in associative array using the cos value.
    ds_index  = COS;                      // So that mixed transmision of DS segments from different COS can happen
    print_ll_tx_rx(TRUE,srio_trans_item); // Info about DS packet generation 
    if(srio_trans_item.usr_gen_pkt == 0)  // If not user generated packet,then create the required segments 
    begin
     streamID  = srio_trans_item.streamID;
     pdulength = srio_trans_item.pdulength;
     mtusize   = srio_trans_item.mtusize;
     mtu_size  = mtusize * 4;                              // Multiply by 4 to form actcual mtu size
     pdusize =  (pdulength == 'h0000) ? 65536 : pdulength; // Form the actual pdusize from received pdu length
     pdusize = (srio_trans_item.ll_err_kind == DS_PDU_ERR) ? pdusize + 2 : pdusize; // Insert PDU Error 
    
     `uvm_info(get_name(),$sformatf(" PDU LENGTH is %h",pdulength),UVM_LOW);
     `uvm_info(get_name(),$sformatf(" MTU SIZE is %h",mtu_size),UVM_LOW);
  
     // Find out the number of segments required to create this DS packet
     // using pdu size and mtu size 
     no_of_segments = (pdusize%mtu_size == 0) ?  pdusize/mtu_size : (pdusize/mtu_size)+1;

     rand_err_seg = $urandom_range(no_of_segments-1,0); // Select one of the segments randomly to insert DS related error
     `uvm_info(get_name(),$sformatf(" Total Number of Segments is %d",no_of_segments),UVM_LOW);
  
     for(int segment=0;segment<no_of_segments; segment = segment+1)
     begin 
       if((segment == 0) && (segment == no_of_segments-1))   // Calculate START and END fields value using segment number
       begin 
         S=1;
         E=1;
       end 
       else if ((segment == 0) && (segment != no_of_segments-1))
       begin 
         S=1;
         E=0;
       end 
       else if ((segment != 0) && (segment != no_of_segments-1))
       begin 
         S=0;
         E=0;
       end 
       else if ((segment != 0) && (segment == no_of_segments-1))
       begin 
         S=0;
         E=1;
       end 
   
       // Calculate PAD and ODD field value
       if(S==1 && E==1)                      // End segment 
       begin
         if(pdusize <= mtu_size)             // Single Segment
         begin 
           seg_tot_byte = pdusize; 
           if(seg_tot_byte%2 != 0 )
           begin 
             P=1;
             seg_tot_byte++;
           end else
           begin
             P=0;
           end 
           if((seg_tot_byte/2) % 2 == 0)
             O=0;
           else 
             O=1;
         end 
         act_byte = pdusize;               // In single segment,actual payloadcnt is pdu size
       end
       // Multi segments
       if((S==0 || S==1) && E==0)    // Start and middle segments 
       begin
         P=0;
         O=0;
         act_byte = mtu_size;        // in multi segment,for start and middle packets,actual payload cnt is mtusize
       end
       if(S==0 && E==1)              // Last segment
       begin
        // Actual payload count in last segment can be equal or less
        act_byte = (pdusize%mtu_size == 0) ? mtu_size : pdusize%mtu_size;
        seg_tot_byte = act_byte; 
        if(seg_tot_byte%2 != 0 )     // recalculate PAD ans ODD values
        begin 
          P=1;
          seg_tot_byte++;
        end else 
        begin
          P=0;
        end 
        if((seg_tot_byte/2) %2 == 0)
          O=0;
        else 
          O=1;
       end
       if(segment == rand_err_seg)  // if current segment matches random segment number insert err if enabled
       begin                        // User can also inject errors in user generated packets
         act_byte = (srio_trans_item.ll_err_kind == DS_MTU_ERR) ? act_byte + 4 : act_byte; // MTU error 
         S        = (srio_trans_item.ll_err_kind == DS_SOP_ERR) ? ~S : S;                  // SOP error
         E        = (srio_trans_item.ll_err_kind == DS_EOP_ERR) ? ~E : E;                  // EOP error
         O        = (srio_trans_item.ll_err_kind == DS_ODD_ERR) ? ~O : O;                  // ODD error
         P        = (srio_trans_item.ll_err_kind == DS_PAD_ERR) ? ~P : P;                  // PAD error 
       end
       // Assign DS packet fields values
       srio_trans_item.cos = COS;
       srio_trans_item.S   = S;
       srio_trans_item.E   = E;
       srio_trans_item.O   = O;
       srio_trans_item.P   = P;
       srio_trans_item.xh  = 1'b0;
       srio_trans_item.pdulength = pdulength;
       srio_trans_item.streamID = streamID;  
       payload.delete(); 
       for(int cnt=0;cnt<act_byte;cnt++)               // Payload Creation
          payload.push_back($urandom_range('hFF,'h0)); 
       if(P)  
          payload.push_back(0); 
       srio_trans_item.payload = payload; 
     
       srio_trans_tmp = new srio_trans_item; 
       ll_common_class.get_next_pkt_id(srio_trans_tmp.ll_pkt_id); // Get the next packet id and assign it
       if(ll_config.interleaved_pkt == TRUE)                      // Interleaved TRUE, store it in associative array
       begin
         ds_pkt_q[ds_index].push_back(srio_trans_tmp);
       end 
       else begin   
          ds_seq_pkt_q.push_back(srio_trans_tmp);                 // StoreDS packet in queue
       end
       ll_common_class.pkt_cnt_update(TRUE);                      // Increment the packet count 
  
       $display("**************************************************************");
       $display("Segment Number = %d",segment);
       $display("COS = %h",COS);
       $display("Start = %b",S);
       $display("End = %b",E);
       $display("Odd = %b",O);
       $display("Pad = %b",P);
       $display("StreamID = %h",streamID);
       
       for(int pld=0;pld<srio_trans_item.payload.size();pld++)
       begin 
         $display(" Payload Bytes of %d is %h ",pld,srio_trans_item.payload[pld]);
       end 
        $display("***************************************************************");
     end 
     end else
     begin           // It is user generated packet do not modify the DS packet fields
       ll_common_class.get_next_pkt_id(srio_trans_item.ll_pkt_id);   // Assign the nest packet id
       if(ll_config.interleaved_pkt == TRUE)
       begin
         ds_pkt_q[ds_index].push_back(srio_trans_item);
       end
       else begin   
          ds_seq_pkt_q.push_back(srio_trans_item);
       end
       ll_common_class.pkt_cnt_update(TRUE);                         // Increment packet count
     end    
end 
endtask: generate_ds_pkt

//////////////////////////////////////////////////////////////////////////
/// Name: get_next_pkt \n
/// Description: Called by packet scheduler , provides the DS packet if available \n
/// in the queue.If packet is present returns pkt_valid as TRUE \n
/// Uses tx_pkt_id to search for the matching packet from sequencial queue in \n
/// non-interleaved mode.In interleaved mode,randomly picks one of the DS \n
/// segment from available streams. \n
/// get_next_pkt
//////////////////////////////////////////////////////////////////////////

task srio_ds_generator::get_next_pkt(bit[2:0] sub_type,bit [31:0] tx_pkt_id,output bool pkt_valid,output srio_trans o_srio_trans);
  int first_index = 0;
  int last_index  = 0;
  int next_index  = 0;
  bit invalid_index = 0;
  int  q_index = 0; 
  bool id_match = FALSE;
  int  tmp_cnt = 0;
begin
   pkt_valid = FALSE;
   id_match  = FALSE;
   tmp_cnt   = 0;
   if(ll_config.interleaved_pkt == FALSE)
   begin
     if(ds_seq_pkt_q.size() > 0)
     begin                                  
       while(id_match == FALSE && tmp_cnt < ds_seq_pkt_q.size())
       begin                                                // Search for the packet with id matching the value
         if(ds_seq_pkt_q[tmp_cnt].ll_pkt_id == tx_pkt_id)   // requested by scheduler
           id_match = TRUE;
          else
            tmp_cnt++;
       end
       if(id_match)                                         // If packet is matches,send out that packet and delete from queue
       begin
          pkt_valid = TRUE;
          o_srio_trans = ds_seq_pkt_q[tmp_cnt];
          ds_seq_pkt_q.delete(tmp_cnt); 
       end 
     end 
   end else
   begin
     if(ds_pkt_q.num() > 0)   // Interleaved mode, DS packets are stored in the associative array using cos field as index
     begin 
        void'(ds_pkt_q.first(first_index));  
        void'(ds_pkt_q.last(last_index));
        invalid_index = 1;
        q_index = 0; 
        next_index = $urandom_range(last_index,first_index);     // Randomly pick one segment from one of the streams
        while(invalid_index) 
        begin 
          if ((ds_pkt_q.exists(next_index) == 1) && (ds_pkt_q[next_index].size() > 0))
          begin 
            o_srio_trans = new ds_pkt_q[next_index].pop_front(); // if found pop and send it out
            invalid_index = 0;
            pkt_valid = TRUE;                                    // also set pkt_valid as TRUE
          end else 
          begin 
            next_index = $urandom_range(last_index,first_index);
          end 
        end 
        if(pkt_valid && ds_pkt_q[next_index].size() == 0)
         ds_pkt_q.delete(next_index);      // if all the segments for a stream are transmitted, delete that index
     end 
   end 
   if(pkt_valid)                           // decrement the packt count since packet is transmitted
     ll_common_class.pkt_cnt_update(FALSE);
end
endtask: get_next_pkt
