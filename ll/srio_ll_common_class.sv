////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_common_class.sv
// Project :  srio vip
// Purpose :  Logical Layer Common Class
// Author  :  Mobiveil
//
// Variables used commonly used by various active components are included in this
// class.
//////////////////////////////////////////////////////////////////////////////// 

class srio_ll_common_class extends uvm_component;

  /// @cond
  `uvm_component_utils(srio_ll_common_class)
  /// @endcond

  srio_trans srio_ll_rx_trans;  ///< Used to store the current received packet by packet handler
  integer pkt_cnt = 0;          ///< Number of packets available in various LL genrerators for tranmission
  bit [31:0] pkt_id = 0;        ///< Packet ID  
  bit [7:0]  curr_tid = 0;      ///< Stores the current TID value
  bit tid_q[bit[7:0]];          ///< Array which maintains the TID availability
  semaphore pkt_cnt_sema;       ///< Semaphore for pkt_cnt_update task
  semaphore pkt_id_sema;        ///< Semaphore for get_next_pkt_id task
  semaphore get_tid_sema;       ///< Semaphore for get_next_tid task
  semaphore update_tid_sema;    ///< Semaphore for update_tid task

  event ll_rx_pkt_received;     ///< Event triggered when a packet is received by packet handler from TL

  extern function new(string name="SRIO_LL_COMMON_CLASS",uvm_component parent = null); ///< new function
  extern task run_phase(uvm_phase phase);                                       ///< Run phase
  extern virtual task automatic pkt_cnt_update(bool incr);                      ///< Task used to update packet count
  extern virtual task automatic get_next_pkt_id(output bit [31:0] next_pkt_id); ///< Task which provides the next packet id
  extern virtual task automatic get_next_tid(output bit [7:0] next_tid);        ///< Task which provides the next packet id
  extern virtual task automatic update_tid(bit [7:0] tid);                      ///< Task which provides the next packet id

endclass: srio_ll_common_class

//////////////////////////////////////////////////////////////////////////
/// Name: new \n
/// Description: LL common class new function \n
/// new
//////////////////////////////////////////////////////////////////////////

function srio_ll_common_class::new (string name = "SRIO_LL_COMMON_CLASS",uvm_component parent = null);
  super.new(name,parent);
  pkt_cnt_sema     = new(1);
  pkt_id_sema      = new(1);
  get_tid_sema     = new(1); 
  update_tid_sema = new(1);
endfunction: new

//////////////////////////////////////////////////////////////////////////
/// Name: run_phase \n
/// Description: LL common class run_phase function \n
/// run_phase
//////////////////////////////////////////////////////////////////////////

task srio_ll_common_class::run_phase(uvm_phase phase);
begin
    for(int cnt = 0; cnt < 256; cnt++)
      tid_q[cnt] = 1;
end
endtask: run_phase

//////////////////////////////////////////////////////////////////////////
/// Name: pkt_cnt_update \n
/// Description: Updates packet count. TRUE - increment FLASE - decrement \n
/// To keep track of number of packets present in various LL generators \n
/// for sending to TL.Can be called by differnt active components hence \n
/// semaphore is used give access one at a time. \n
/// pkt_cnt_update
//////////////////////////////////////////////////////////////////////////

task automatic srio_ll_common_class::pkt_cnt_update(bool incr);
begin
   pkt_cnt_sema.get(1);
   if(incr)
     pkt_cnt++;
   else
     pkt_cnt--;
   pkt_cnt_sema.put(1);
end
endtask: pkt_cnt_update

//////////////////////////////////////////////////////////////////////////
/// Name: get_next_pkt_id \n
/// Description: Provides the next packet id to be used. \n
/// Can be called by differnt active components hence \n
/// semaphore is used give access one at a time. \n
/// get_next_pkt_id
//////////////////////////////////////////////////////////////////////////

task automatic srio_ll_common_class::get_next_pkt_id(output bit [31:0] next_pkt_id);
begin
   pkt_id_sema.get(1);
   next_pkt_id = pkt_id;
   pkt_id++;
   pkt_id_sema.put(1);
end
endtask: get_next_pkt_id

//////////////////////////////////////////////////////////////////////////
/// Name: get_next_pkt_tid \n
/// Description: Provides the next tid available for non-posted transactions. \n
/// Can be called by differnt active components hence \n
/// semaphore is used give access one at a time. \n
/// get_next_tid
//////////////////////////////////////////////////////////////////////////

task automatic srio_ll_common_class::get_next_tid(output bit [7:0] next_tid);
bit[7:0] cnt;
begin
  get_tid_sema.get(1);
  cnt = curr_tid;
  next_tid = 0;
  if(tid_q.num() == 0)       // When a generator requests for unsed TID value and if not available
  begin                      // Waits for TID to be available 
    wait (tid_q.num() > 0);
  end
  for(int cnt1 = 0; cnt1 < 256; cnt1++)     // If TID is available, provide it
  begin
     if(tid_q.exists(cnt))
     begin
        next_tid = cnt;
        curr_tid = cnt+1; 
        break;
     end 
     cnt++;  
  end
  tid_q.delete(cnt);
  get_tid_sema.put(1);
end
endtask: get_next_tid

//////////////////////////////////////////////////////////////////////////
/// Name: update_tid \n
/// Description: Once a TID is available for use bacause of receiving \n
/// response or the response timeout,tid queue is updated to indicate that.\n
/// Can be called by differnt active components hence \n
/// semaphore is used give access one at a time. \n
/// update_tid
//////////////////////////////////////////////////////////////////////////

task automatic srio_ll_common_class::update_tid(bit [7:0] tid);
begin
  update_tid_sema.get(1);
  tid_q[tid] = 1; 
  update_tid_sema.put(1);
end
endtask: update_tid
