////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_callback.sv
// Project :  srio vip
// Purpose :  Logical Layer Call Back
// Author  :  Mobiveil
//
// Logical Layer Call back base class and methods
// 
//////////////////////////////////////////////////////////////////////////////// 

class srio_ll_callback extends uvm_callback; 

function new (string name = "srio_ll_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_ll_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_ll_trans_generated(ref srio_trans tx_srio_trans); ///< LL TX call back triggered before sending to TL
endtask 

virtual task srio_ll_trans_received(ref srio_trans rx_srio_trans); ///< LL RX call back triggered when a packet is received from TL
endtask 

endclass : srio_ll_callback 
