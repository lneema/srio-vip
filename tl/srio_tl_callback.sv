////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_tl_callback.sv
// Project :  srio vip
// Purpose :  Logical Layer Call Back
// Author  :  Mobiveil
//
// Impplments TL Layer's call back methods
//
//////////////////////////////////////////////////////////////////////////////// 

class srio_tl_callback extends uvm_callback; 

function new (string name = "srio_tl_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_tl_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_tl_trans_generated(ref srio_trans tx_srio_trans); ///< Invoked before sending a packet from TL to PL
endtask 

virtual task srio_tl_trans_received(ref srio_trans rx_srio_trans);  ///< Invoked when a packet is received by TL from PL
endtask 

endclass: srio_tl_callback 
