////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_tl_callback.sv
// Project :  srio vip
// Purpose :  Logical Layer Call Back
// Author  :  Mobiveil
//
// Logical Layer BFM component.
//
//////////////////////////////////////////////////////////////////////////////// 


class srio_tl_tx_cb extends srio_tl_callback; 

function new (string name = "srio_tl_tx_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_tl_tx_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_tl_trans_generated(ref srio_trans tx_srio_trans);
   
   //tx_srio_trans.prio = 2'b11; 
   //tx_srio_trans.crf  = 1'b1;
   tx_srio_trans.SourceID = 32'hFF0F;
   tx_srio_trans.DestinationID = 32'hF0FF;

   tx_srio_trans.print(); 
endtask 

endclass : srio_tl_tx_cb 

class srio_tl_rx_cb extends srio_tl_callback; 

function new (string name = "srio_tl_rx_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_tl_rx_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_tl_trans_received(ref srio_trans rx_srio_trans);
   
   //rx_srio_trans.hop_count = 8'hFF;
   rx_srio_trans.SourceID = 32'hF0FF;
   rx_srio_trans.DestinationID = 32'hFF0F;
   rx_srio_trans.print(); 
endtask 

endclass : srio_tl_rx_cb  
class srio_tl_tx_destid_corrupt_cb extends srio_tl_callback; 

function new (string name = "srio_tl_tx_destid_corrupt_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_tl_tx_destid_corrupt_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_tl_trans_generated(ref srio_trans tx_srio_trans);
   
   //tx_srio_trans.prio = 2'b11; 
   //tx_srio_trans.crf  = 1'b1;
   tx_srio_trans.SourceID = 32'hFF0F;
   tx_srio_trans.DestinationID = 32'hF0DB;

   tx_srio_trans.print(); 
endtask 

endclass : srio_tl_tx_destid_corrupt_cb 

class srio_tl_rx_destid_corrupt_cb extends srio_tl_callback; 

function new (string name = "srio_tl_rx_destid_corrupt_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_tl_rx_destid_corrupt_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_tl_trans_received(ref srio_trans rx_srio_trans);
      //rx_srio_trans.hop_count = 8'hFF;
   rx_srio_trans.SourceID = 32'hF0FF;
   rx_srio_trans.DestinationID = 32'hFFED;
   rx_srio_trans.print(); 
endtask 

endclass : srio_tl_rx_destid_corrupt_cb 
 
//============================= Callback class for DS SourceID corruption ========
class srio_tl_ds_tx_scrid_err_cb extends srio_tl_callback; 

function new (string name = "srio_tl_ds_tx_scrid_err_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_tl_ds_tx_scrid_err_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_tl_trans_generated(ref srio_trans tx_srio_trans);
   tx_srio_trans.SourceID = 32'hFF00;
   tx_srio_trans.DestinationID = 32'hF0DB;

   tx_srio_trans.print(); 
endtask 

endclass : srio_tl_ds_tx_scrid_err_cb 

class srio_tl_ds_rx_scrid_err_cb extends srio_tl_callback; 

function new (string name = "srio_tl_ds_rx_scrid_err_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_tl_ds_rx_scrid_err_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_tl_trans_received(ref srio_trans rx_srio_trans);
   rx_srio_trans.SourceID = 32'hF0EF;
   rx_srio_trans.DestinationID = 32'hFFED;
   rx_srio_trans.print(); 
endtask 

endclass : srio_tl_ds_rx_scrid_err_cb  


class srio_tl_tx_invalid_tt_cb extends srio_tl_callback; 

function new (string name = "srio_tl_tx_invalid_tt_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_tl_tx_invalid_tt_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_tl_trans_generated(ref srio_trans tx_srio_trans);
   
   tx_srio_trans.tt = 'h3;

   tx_srio_trans.print(); 
endtask 

endclass : srio_tl_tx_invalid_tt_cb 


class srio_tl_rx_invalid_tt_cb extends srio_tl_callback; 

function new (string name = "srio_tl_rx_invalid_tt_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_tl_rx_invalid_tt_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_tl_trans_received(ref srio_trans rx_srio_trans);
   
   rx_srio_trans.tt = 'h3;

   rx_srio_trans.print(); 
endtask 

endclass : srio_tl_rx_invalid_tt_cb 
