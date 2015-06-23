////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_callback.sv
// Project :  srio vip
// Purpose :  Logical Layer Call Back
// Author  :  Mobiveil
//
// Logical Layer BFM component.
//
//////////////////////////////////////////////////////////////////////////////// 

//`include "uvm_macros.svh"

//import uvm_pkg::*;
//import srio_env_pkg::*;

class srio_ll_tx_cb extends srio_ll_callback; 

function new (string name = "srio_ll_tx_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_ll_tx_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_ll_trans_generated(ref srio_trans tx_srio_trans);
   tx_srio_trans.prio = 2'b10; 
   tx_srio_trans.crf  = 1'b1;
   tx_srio_trans.ftype = 4'h2;
   tx_srio_trans.ttype = 4'h4;

   tx_srio_trans.print(); 
endtask 

endclass : srio_ll_tx_cb 

class srio_ll_rx_cb extends srio_ll_callback; 

function new (string name = "srio_ll_rx_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_ll_rx_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_ll_trans_received(ref srio_trans rx_srio_trans);
     rx_srio_trans.hop_count = 8'hFF; 
   rx_srio_trans.prio = 2'b00; 
   rx_srio_trans.print(); 
endtask 

endclass : srio_ll_rx_cb
/////RESPONSE PRIORITY ERROR 
class srio_ll_rx_resp_pri_cb extends srio_ll_callback; 

function new (string name = "srio_ll_rx_resp_pri_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_ll_rx_resp_pri_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_ll_trans_received(ref srio_trans rx_srio_trans);
     rx_srio_trans.ll_err_kind = RESP_PRI_ERR; 
    
   rx_srio_trans.print(); 
endtask 

endclass : srio_ll_rx_resp_pri_cb


// DATA MESSAGE CALLBACKS

// Corrupting msgseg field in a MESSAGE PACKET

class srio_ll_tx_msgseg_err_cb extends srio_ll_callback; 

function new (string name = "srio_ll_tx_msgseg_err_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_ll_tx_msgseg_err_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_ll_trans_generated(ref srio_trans tx_srio_trans);

   if(tx_srio_trans.ftype == 'hB) begin //{
     if (tx_srio_trans.msg_len == tx_srio_trans.msgseg_xmbox) begin //{
       tx_srio_trans.msgseg_xmbox = $urandom_range(10,1);
     end //}
   end //}
   else begin //{
     `uvm_error("SRIO_LL_TEST_CB:", "Invalid FTYPE for Message")
   end //}
   tx_srio_trans.print(); 
endtask 

endclass : srio_ll_tx_msgseg_err_cb

// Corrupting msglen field in a MESSAGE PACKET

class srio_ll_tx_msglen_err_cb extends srio_ll_callback; 

function new (string name = "srio_ll_tx_msglen_err_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_ll_tx_msglen_err_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_ll_trans_generated(ref srio_trans tx_srio_trans);

   if(tx_srio_trans.ftype == 'hB) begin //{
     if(tx_srio_trans.msg_len > 5) begin //{
       tx_srio_trans.msg_len = $urandom_range(5,1);
     end //}
     else begin //{
       tx_srio_trans.msg_len = $urandom_range(10,5);
     end //}
   end //}
   else begin //{
     `uvm_error("SRIO_LL_TEST_CB:", "Invalid FTYPE for Message")
   end //}
   tx_srio_trans.print(); 
endtask 

endclass : srio_ll_tx_msglen_err_cb



// Corrupting Start segment in a MESSAGE PACKET

class srio_ll_tx_msg_sseg_neqt_ssize_err_cb extends srio_ll_callback; 


function new (string name = "srio_ll_tx_msg_sseg_neqt_ssize_err_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_ll_tx_msg_sseg_neqt_ssize_err_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_ll_trans_generated(ref srio_trans tx_srio_trans);

   if(tx_srio_trans.ftype == 'hB) begin //{
     if(tx_srio_trans.msgseg_xmbox == 0) begin //{
       randcase
         1: begin //{
              for(int i=0;i<8;i++) begin //{
                tx_srio_trans.payload.push_back($urandom_range('hFF,'h0));
              end //}
            end //}
         1: begin //{
              for(int i=0;i<8;i++) begin //{
                void'(tx_srio_trans.payload.pop_front());
              end //}
            end //}         
       endcase
     end //}
   end //}
   else begin //{
     `uvm_error("SRIO_LL_TEST_CB:", "Invalid FTYPE for Message")
   end //}
   tx_srio_trans.print(); 
endtask 

endclass : srio_ll_tx_msg_sseg_neqt_ssize_err_cb


// Corrupting Continuous segment in a MESSAGE PACKET

class srio_ll_tx_msg_cseg_neqt_ssize_err_cb extends srio_ll_callback; 


function new (string name = "srio_ll_tx_msg_cseg_neqt_ssize_err_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_ll_tx_msg_cseg_neqt_ssize_err_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_ll_trans_generated(ref srio_trans tx_srio_trans);

   if(tx_srio_trans.ftype == 'hB) begin //{
     if((tx_srio_trans.msgseg_xmbox != 0)) begin //{ && (tx_srio_trans.msgseg_xmbox != tx_srio_trans.msg_len)) begin //{
       randcase
         1: begin //{
              for(int i=0;i<8;i++) begin //{
                tx_srio_trans.payload.push_back($urandom_range('hFF,'h0));
              end //}
            end //}
         1: begin //{
              for(int i=0;i<8;i++) begin //{
                void'(tx_srio_trans.payload.pop_front());
              end //}
            end //}
       endcase
     end //}
   end //}
   else begin //{
     `uvm_error("SRIO_LL_TEST_CB:", "Invalid FTYPE for Message")
   end //}
   tx_srio_trans.print(); 
endtask 

endclass : srio_ll_tx_msg_cseg_neqt_ssize_err_cb

// Corrupting End segment in a MESSAGE PACKET

class srio_ll_tx_msg_eseg_gt_ssize_err_cb extends srio_ll_callback; 


function new (string name = "srio_ll_tx_msg_eseg_gt_ssize_err_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_ll_tx_msg_eseg_gt_ssize_err_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_ll_trans_generated(ref srio_trans tx_srio_trans);

   if(tx_srio_trans.ftype == 'hB) begin //{
     if(tx_srio_trans.msgseg_xmbox == tx_srio_trans.msg_len) begin //{
        for(int i=0;i<8;i++) begin //{
          tx_srio_trans.payload.push_back($urandom_range('hFF,'h0));
        end //}
     end //}
   end //}
   else begin //{
     `uvm_error("SRIO_LL_TEST_CB:", "Invalid FTYPE for Message")
   end //}
   tx_srio_trans.print(); 
endtask 

endclass : srio_ll_tx_msg_eseg_gt_ssize_err_cb


// MESSAGE PACKET with no data payload

class srio_ll_tx_msg_without_pld_err_cb extends srio_ll_callback; 


function new (string name = "srio_ll_tx_msg_without_pld_err_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_ll_tx_msg_without_pld_err_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_ll_trans_generated(ref srio_trans tx_srio_trans);

   if(tx_srio_trans.ftype == 'hB) begin //{
     tx_srio_trans.payload.delete();
   end //}
   else begin //{
     `uvm_error("SRIO_LL_TEST_CB:", "Invalid FTYPE for Message")
   end //}
   tx_srio_trans.print(); 
endtask 

endclass : srio_ll_tx_msg_without_pld_err_cb


// MESSAGE RESPONSE PACKET with data payload

class srio_ll_tx_msg_resp_with_pld_err_cb extends srio_ll_callback; 


function new (string name = "srio_ll_tx_msg_resp_with_pld_err_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_ll_tx_msg_resp_with_pld_err_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_ll_trans_generated(ref srio_trans tx_srio_trans);

   if(tx_srio_trans.ftype == 'hD) begin //{
     if(tx_srio_trans.msgseg_xmbox == 0) begin //{
        for(int i=0;i<8;i++) begin //{
          tx_srio_trans.payload.push_back($urandom_range('hFF,'h0));
        end //}
     end //}
   end //}
   else begin //{
     `uvm_error("SRIO_LL_TEST_CB:", "Invalid FTYPE for Message")
   end //}
   tx_srio_trans.print(); 
endtask 

endclass : srio_ll_tx_msg_resp_with_pld_err_cb

// MESSAGE RESPONSE PACKET with Invalid Status

class srio_ll_tx_msg_resp_with_invalid_status_err_cb extends srio_ll_callback; 


function new (string name = "srio_ll_tx_msg_resp_with_invalid_status_err_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_ll_tx_msg_resp_with_invalid_status_err_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_ll_trans_generated(ref srio_trans tx_srio_trans);

   if(tx_srio_trans.ftype == 'hD) begin //{
     tx_srio_trans.trans_status = $urandom_range('hF,'h0);
   end //}
   else begin //{
     `uvm_error("SRIO_LL_TEST_CB:", "Invalid FTYPE for Message")
   end //}
   tx_srio_trans.print(); 
endtask 

endclass : srio_ll_tx_msg_resp_with_invalid_status_err_cb


// MESSAGE RESPONSE PACKET with corruption of Target_info

class srio_ll_tx_msg_resp_with_invalid_tgtinfo_err_cb extends srio_ll_callback; 


function new (string name = "srio_ll_tx_msg_resp_with_invalid_tgtinfo_err_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_ll_tx_msg_resp_with_invalid_tgtinfo_err_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_ll_trans_generated(ref srio_trans tx_srio_trans);

   if(tx_srio_trans.ftype == 'hD) begin //{
     tx_srio_trans.targetID_Info = $urandom_range('hFF,'h0);
   end //}
   else begin //{
     `uvm_error("SRIO_LL_TEST_CB:", "Invalid FTYPE for Message")
   end //}
   tx_srio_trans.print(); 
endtask 

endclass : srio_ll_tx_msg_resp_with_invalid_tgtinfo_err_cb


// corrupting last segment field in a MESSAGE PACKET

class srio_ll_tx_msg_lstseg_err_cb extends srio_ll_callback; 

function new (string name = "srio_ll_tx_msg_lstseg_err_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_ll_tx_msg_lstseg_err_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_ll_trans_generated(ref srio_trans tx_srio_trans);

   if(tx_srio_trans.ftype == 'hB) begin //{
     if (tx_srio_trans.msg_len == tx_srio_trans.msgseg_xmbox) begin //{
       for(int i=0;i<4;i++) begin //{
          void'(tx_srio_trans.payload.pop_front());
       end //}
     end //}
   end //}
   else begin //{
     `uvm_error("SRIO_LL_TEST_CB:", "Invalid FTYPE for Message")
   end //}
   tx_srio_trans.print(); 
endtask 

endclass : srio_ll_tx_msg_lstseg_err_cb


// Data Streaming Callbacks

// DS PACKET with SSEG > MTU

class srio_ll_tx_ds_sseg_err_cb extends srio_ll_callback; 

function new (string name = "srio_ll_tx_ds_sseg_err_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_ll_tx_ds_sseg_err_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_ll_trans_generated(ref srio_trans tx_srio_trans);

   if(tx_srio_trans.ftype == 'h9) begin //{
     if (tx_srio_trans.S == 1 && tx_srio_trans.E == 0) begin //{
       randcase
         1: begin //{
              for(int i=0;i<4;i++) begin //{
                 void'(tx_srio_trans.payload.pop_front());
              end //}  
            end //}
         1: begin //{
              for(int i=0;i<4;i++) begin //{
                tx_srio_trans.payload.push_back($urandom_range('hFF,'h0));
              end //}  
            end //}
       endcase
     end //}
   end //}
   tx_srio_trans.print(); 
endtask 

endclass : srio_ll_tx_ds_sseg_err_cb

// DS PACKET with CSEG > MTU

class srio_ll_tx_ds_cseg_err_cb extends srio_ll_callback; 

function new (string name = "srio_ll_tx_ds_cseg_err_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_ll_tx_ds_cseg_err_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_ll_trans_generated(ref srio_trans tx_srio_trans);

   if(tx_srio_trans.ftype == 'h9) begin //{
     if (tx_srio_trans.S == 0 && tx_srio_trans.E == 0) begin //{
       randcase
         1: begin //{
              for(int i=0;i<4;i++) begin //{
                 void'(tx_srio_trans.payload.pop_front());
              end //}  
            end //}
         1: begin //{
              for(int i=0;i<4;i++) begin //{
                tx_srio_trans.payload.push_back($urandom_range('hFF,'h0));
              end //}  
            end //}
       endcase
     end //}
   end //}
   tx_srio_trans.print(); 
endtask 

endclass : srio_ll_tx_ds_cseg_err_cb

// DS PACKET with no data payload

class srio_ll_tx_ds_without_pld_err_cb extends srio_ll_callback; 


function new (string name = "srio_ll_tx_ds_without_pld_err_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_ll_tx_ds_without_pld_err_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_ll_trans_generated(ref srio_trans tx_srio_trans);

   if(tx_srio_trans.ftype == 'h9) begin //{
     if (tx_srio_trans.S == 1 && tx_srio_trans.E == 0) begin //{
       tx_srio_trans.payload.delete();
     end //}
   end //}
   tx_srio_trans.print(); 
endtask 

endclass : srio_ll_tx_ds_without_pld_err_cb

// DS PACKET with Corruption of pdulength field

class srio_ll_tx_ds_pdulen_err_cb extends srio_ll_callback; 


function new (string name = "srio_ll_tx_ds_pdulen_err_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_ll_tx_ds_pdulen_err_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_ll_trans_generated(ref srio_trans tx_srio_trans);

   if(tx_srio_trans.ftype == 'h9) begin //{
     if (tx_srio_trans.S == 0 && tx_srio_trans.E == 1) begin //{
        tx_srio_trans.pdulength = $urandom_range('hFFFF,'h0001);
     end //}
   end //}
   tx_srio_trans.print(); 
endtask 

endclass : srio_ll_tx_ds_pdulen_err_cb

// Invalid Response Status for all packets

class srio_ll_tx_default_resp_with_invalid_status_err_cb extends srio_ll_callback; 

rand bit a;  //random selection bit

function new (string name = "srio_ll_tx_default_resp_with_invalid_status_err_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_ll_tx_default_resp_with_invalid_status_err_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_ll_trans_generated(ref srio_trans tx_srio_trans);
   a = $urandom;
   if(tx_srio_trans.ftype == 'hD) begin //{
     tx_srio_trans.ttype = a ? $urandom_range(7,2) : $urandom_range(15,9);
   end //}
   else if ((tx_srio_trans.ftype == 'h8) && ((tx_srio_trans.ttype == 'h2)||(tx_srio_trans.ttype == 'h3))) begin //{
     tx_srio_trans.trans_status = a ? $urandom_range(6,1) : $urandom_range(11,8);
   end //}

   tx_srio_trans.print(); 
endtask 

endclass : srio_ll_tx_default_resp_with_invalid_status_err_cb

//Legal and illegal Ftype and Ttype corruption

class srio_ll_illegal_ftype_type_corrupt_cb extends srio_ll_callback; 
rand bit [3:0] ftype_rand;
rand bit [3:0] ttype_rand;
function new (string name = "srio_ll_illegal_ftype_type_corrupt_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_ll_illegal_ftype_type_corrupt_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_ll_trans_generated(ref srio_trans tx_srio_trans);
   ftype_rand = $urandom_range(32'd16,32'd0);
   ttype_rand = $urandom_range(32'd16,32'd0); 
   tx_srio_trans.ftype = ftype_rand;
   tx_srio_trans.ttype = ttype_rand;

   tx_srio_trans.print(); 
endtask 

endclass : srio_ll_illegal_ftype_type_corrupt_cb
//Illegal NWRITE_R Response
class srio_ll_nwrite_r_resp_corrupt_ttype_cb extends srio_ll_callback; 
rand bit [3:0] temp;
function new (string name = "srio_ll_nwrite_r_resp_corrupt_ttype_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_ll_nwrite_r_resp_corrupt_ttype_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_ll_trans_generated(ref srio_trans tx_srio_trans);
   if(tx_srio_trans.ftype == 4'hd)
   if(tx_srio_trans.trans_status == 6 || tx_srio_trans.trans_status > 7)
   begin
     temp = $urandom_range(1,0);
     tx_srio_trans.ttype = temp ;
   end
   else
    begin
      temp = $urandom;
      tx_srio_trans.ttype = temp;
    end
   tx_srio_trans.print(); 
endtask 

endclass : srio_ll_nwrite_r_resp_corrupt_ttype_cb

//callback to reduce the payload w.r.t wrsize

class srio_ll_tx_lesser_payload_cb extends srio_ll_callback; 

rand bit [7:0] reduce_payload;

function new (string name = "srio_ll_tx_lesser_payload_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_ll_tx_lesser_payload_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_ll_trans_generated(ref srio_trans tx_srio_trans);

   reduce_payload = 0;
   if((tx_srio_trans.wrsize == 11) && (tx_srio_trans.wdptr == 1))
     reduce_payload = 8;
   else if((tx_srio_trans.wrsize == 12) && (tx_srio_trans.wdptr == 0))
    begin
     reduce_payload = $urandom_range(3,1);
     reduce_payload = reduce_payload*8;
    end
   else if((tx_srio_trans.wrsize == 12) && (tx_srio_trans.wdptr == 1))
    begin
     reduce_payload = $urandom_range(7,1);
     reduce_payload = reduce_payload*8;
    end
   else if((tx_srio_trans.wrsize == 13) && (tx_srio_trans.wdptr == 1))
    begin
     reduce_payload = $urandom_range(15,1);
     reduce_payload = reduce_payload*8;
    end
   else if((tx_srio_trans.wrsize == 15) && (tx_srio_trans.wdptr == 1))
    begin
     reduce_payload = $urandom_range(31,1);
     reduce_payload = reduce_payload*8;
    end
   if((tx_srio_trans.ftype == 5 && !((tx_srio_trans.ttype == 12)||(tx_srio_trans.ttype == 13)||(tx_srio_trans.ttype == 14)))||(tx_srio_trans.ftype == 8 && tx_srio_trans.ttype == 1)||(tx_srio_trans.ftype == 8 && tx_srio_trans.ttype == 4))
     begin
       for(int i = 0 ;i < reduce_payload;i++)
         void'(tx_srio_trans.payload.pop_back());
      end
   tx_srio_trans.print(); 
endtask 

endclass : srio_ll_tx_lesser_payload_cb 

//========== Source TID corruption test ==============
class srio_ll_src_tid_cb extends srio_ll_callback; 

function new (string name = "srio_ll_src_tid_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_ll_src_tid_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_ll_trans_generated(ref srio_trans tx_srio_trans);
   tx_srio_trans.SrcTID = 8'h3f; 
   tx_srio_trans.print(); 
endtask 

endclass : srio_ll_src_tid_cb 

// ============ callback to corrupt response with random value ========
class srio_ll_resp_with_rand_pld_cb extends srio_ll_callback; 
logic [15:0] payload_size;

function new (string name = "srio_ll_resp_with_rand_pld_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_ll_resp_with_rand_pld_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_ll_trans_generated(ref srio_trans tx_srio_trans);

   if(tx_srio_trans.ftype == 'hD) begin //{
     payload_size = tx_srio_trans.payload.size();
     tx_srio_trans.payload.delete();
        for(int i=0;i< payload_size;i++) begin //{
          tx_srio_trans.payload.push_back(8'hFF);
        end //}
   end //}
   else begin //{
     `uvm_error("SRIO_LL_TEST_CB:", "Not of Response")
   end //}
   tx_srio_trans.print(); 
endtask 

endclass : srio_ll_resp_with_rand_pld_cb


//**************** LL RESPONSE - disable w.r.t SrcTID of request pkt *******
 
class srio_ll_rx_resp_pkt_dis_cb extends srio_ll_callback; 

function new (string name = "srio_ll_rx_resp_pkt_dis_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_ll_rx_resp_pkt_dis_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_ll_trans_received(ref srio_trans rx_srio_trans);
    if(rx_srio_trans.ftype == 2 && rx_srio_trans.ttype == 4 && rx_srio_trans.SrcTID == 3)
    begin
    rx_srio_trans.usr_directed_ll_response_en = 1;
    rx_srio_trans.usr_directed_ll_response_type = LL_NO_RESP;
    rx_srio_trans.print(); 
    end
endtask 

endclass : srio_ll_rx_resp_pkt_dis_cb


//callback to display generated response payload

class srio_ll_resp_payload_print_cb extends srio_ll_callback; 

int pld_size;

function new (string name = "srio_ll_resp_payload_print_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_ll_resp_payload_print_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_ll_trans_generated(ref srio_trans tx_srio_trans);

   if(tx_srio_trans.ftype == 'hD) begin //{
     pld_size = tx_srio_trans.payload.size();
     for(int i=0;i< pld_size;i++)
       $display($time,"GENERATED RESPONSE PAYLOAD Value is PAYLOAD[%0d] : %0h",i,tx_srio_trans.payload[i]);
   end //}
   tx_srio_trans.print(); 
endtask 

endclass : srio_ll_resp_payload_print_cb

// ============ callback to corrupt response with random value ========
class srio_ll_nwrite_max_pld_err_cb extends srio_ll_callback; 
logic [15:0] payload_size;
int cnt;

function new (string name = "srio_ll_nwrite_max_pld_err_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_ll_nwrite_max_pld_err_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_ll_trans_generated(ref srio_trans tx_srio_trans);

   if(tx_srio_trans.ftype == 'h5 && tx_srio_trans.ttype == 'h4 && cnt < 3 ) begin //{
     payload_size = tx_srio_trans.payload.size();
        for(int i=0;i< 8;i++) begin //{
          tx_srio_trans.payload.push_back(8'hFF);
          cnt = cnt+1;
        end //}
   end //}
   //else begin //{
   //  `uvm_error("SRIO_LL_TEST_CB:", "Not of Response")
   //end //}
   tx_srio_trans.print(); 
endtask 

endclass : srio_ll_nwrite_max_pld_err_cb
