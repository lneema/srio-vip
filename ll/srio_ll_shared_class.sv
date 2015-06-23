////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_shared_class.sv
// Project :  srio vip
// Purpose :  To share the transaction details between Tx and Rx monitors
// Author  :  Mobiveil
//
// Contains srio_ll_shared_class which is used in both Tx and Rx monitors
// 
//////////////////////////////////////////////////////////////////////////////// 

class srio_ll_shared_class extends uvm_component;
  /// @cond
  `uvm_component_utils(srio_ll_shared_class)

  bit [9:0] wdptr_rdsize_array[bit [4:0]];
  bit [9:0] wdptr_wrsize_array[bit [4:0]];
  bit [9:0] msg_ssize_array   [bit [3:0]];
  bit [70:0]tx_orphxoff_timer_array[$]; // {srcid, flowid}
  bit [70:0]rx_orphxoff_timer_array[$]; // {srcid, flowid}
  bit [1:0] tx_max_prio_sent;
  bit [1:0] rx_max_prio_sent;
  bit       valid_lfc_flowid[bit [6:0]];
  int       tx_xoff_cnt_array[bit[70:0]]; // Xoff count
  int       rx_xoff_cnt_array[bit[70:0]]; // Xoff count

  srio_ll_lfc_assembly  tx_lfc_array[bit [63:0]];
  srio_ll_lfc_assembly  rx_lfc_array[bit [63:0]];
  bit       valid_flow_arb_cmd[bit [3:0]];
  bit       valid_tm_mask[bit [7:0]];

  srio_trans tx_exp_resp_array      [bit[72:0]];
  srio_trans rx_exp_resp_array      [bit[72:0]];

  srio_trans tx_ato_req_array       [bit[65:0]];
  srio_trans rx_ato_req_array       [bit[65:0]];
  srio_ll_msg_assembly tx_msg_array [bit[72:0]];
  srio_ll_msg_assembly rx_msg_array [bit[72:0]];

  int        tx_resp_track_array    [bit[72:0]];
  int        rx_resp_track_array    [bit[72:0]];

  bit        tx_ds_tm_xoff_array   [bit [55:0]];
  bit        rx_ds_tm_xoff_array   [bit [55:0]];

  int        tx_ds_tm_credit_array   [bit [55:0]];
  int        rx_ds_tm_credit_array   [bit [55:0]];

  bit [34:0] tx_ds_xoff_all;
  bit [34:0] rx_ds_xoff_all;

  bit [ 8:0] tx_last_req            [bit[72:0]];  
  bit [ 8:0] rx_last_req            [bit[72:0]]; 
  int        tx_req_track_array     [bit[72:0]]; 
  int        rx_req_track_array     [bit[72:0]]; 

  bit [2:0]  tx_ds_tm_wc;
  bit [2:0]  rx_ds_tm_wc;
  /// @endcond

  extern function new (string name = "srio_ll_shared_class", 
                                     uvm_component parent = null);

endclass: srio_ll_shared_class

////////////////////////////////////////////////////////////////////////////////
/// Name: new \n 
/// Description: LL shared class's new function \n
/// new
////////////////////////////////////////////////////////////////////////////////

function srio_ll_shared_class::new(string name="srio_ll_shared_class", 
                                 uvm_component parent=null);
  super.new(name, parent);

// wd_ptr, rd_size array
// ---------------------
  wdptr_rdsize_array[5'b00000] = 1;	 
  wdptr_rdsize_array[5'b00001] = 1;
  wdptr_rdsize_array[5'b00010] = 1; 
  wdptr_rdsize_array[5'b00011] = 1; 
  wdptr_rdsize_array[5'b10000] = 1; 
  wdptr_rdsize_array[5'b10001] = 1; 
  wdptr_rdsize_array[5'b10010] = 1; 
  wdptr_rdsize_array[5'b10011] = 1; 
  wdptr_rdsize_array[5'b00100] = 2; 
  wdptr_rdsize_array[5'b00101] = 3; 
  wdptr_rdsize_array[5'b00110] = 2; 
  wdptr_rdsize_array[5'b00111] = 5; 
  wdptr_rdsize_array[5'b10100] = 2; 
  wdptr_rdsize_array[5'b10101] = 3; 
  wdptr_rdsize_array[5'b10110] = 2; 
  wdptr_rdsize_array[5'b10111] = 5; 
  wdptr_rdsize_array[5'b01000] = 4; 
  wdptr_rdsize_array[5'b11000] = 4; 
  wdptr_rdsize_array[5'b01001] = 6; 
  wdptr_rdsize_array[5'b11001] = 6; 
  wdptr_rdsize_array[5'b01010] = 7; 
  wdptr_rdsize_array[5'b11010] = 7; 
  wdptr_rdsize_array[5'b01011] = 8; 
  wdptr_rdsize_array[5'b11011] = 16;      
  wdptr_rdsize_array[5'b01100] = 32;
  wdptr_rdsize_array[5'b11100] = 64;
  wdptr_rdsize_array[5'b01101] = 96;
  wdptr_rdsize_array[5'b11101] = 128; 
  wdptr_rdsize_array[5'b01110] = 160;
  wdptr_rdsize_array[5'b11110] = 192;
  wdptr_rdsize_array[5'b01111] = 224;
  wdptr_rdsize_array[5'b11111] = 256;

  // wd_ptr, rd_size array
  // ---------------------
  wdptr_wrsize_array[5'b00000] = 1; 
  wdptr_wrsize_array[5'b00001] = 1; 
  wdptr_wrsize_array[5'b00010] = 1; 
  wdptr_wrsize_array[5'b00011] = 1; 
  wdptr_wrsize_array[5'b10000] = 1; 
  wdptr_wrsize_array[5'b10001] = 1; 
  wdptr_wrsize_array[5'b10010] = 1; 
  wdptr_wrsize_array[5'b10011] = 1; 
  wdptr_wrsize_array[5'b00100] = 2; 
  wdptr_wrsize_array[5'b00101] = 3; 
  wdptr_wrsize_array[5'b00110] = 2; 
  wdptr_wrsize_array[5'b00111] = 5; 
  wdptr_wrsize_array[5'b10100] = 2; 
  wdptr_wrsize_array[5'b10101] = 3; 
  wdptr_wrsize_array[5'b10110] = 2; 
  wdptr_wrsize_array[5'b10111] = 5; 
  wdptr_wrsize_array[5'b01000] = 4; 
  wdptr_wrsize_array[5'b11000] = 4; 
  wdptr_wrsize_array[5'b01001] = 6; 
  wdptr_wrsize_array[5'b11001] = 6; 
  wdptr_wrsize_array[5'b01010] = 7; 
  wdptr_wrsize_array[5'b11010] = 7; 
  wdptr_wrsize_array[5'b01011] = 8; 
  wdptr_wrsize_array[5'b11011] = 16; 
  wdptr_wrsize_array[5'b01100] = 32; 
  wdptr_wrsize_array[5'b11100] = 64; 
  wdptr_wrsize_array[5'b11101] = 128; 
  wdptr_wrsize_array[5'b11111] = 256; 

// Message ssize values in bytes  
  msg_ssize_array[4'b1001] = 8;	
  msg_ssize_array[4'b1010] = 16;	
  msg_ssize_array[4'b1011] = 32;	
  msg_ssize_array[4'b1100] = 64;	
  msg_ssize_array[4'b1101] = 128;	
  msg_ssize_array[4'b1110] = 256;

// LFC Valid FlowIDs
  valid_lfc_flowid[7'b0000000] = 1; // (Flow 0A)
  valid_lfc_flowid[7'b0000001] = 1; // (Flow 0B)
  valid_lfc_flowid[7'b0000010] = 1; // (Flow 0C)
  valid_lfc_flowid[7'b0000011] = 1; // (Flow 0D)
  valid_lfc_flowid[7'b0000100] = 1; // (Flow 0E)
  valid_lfc_flowid[7'b0000101] = 1; // (Flow 0F)
  valid_lfc_flowid[7'b1000001] = 1; // (Flow 1A)
  valid_lfc_flowid[7'b1000010] = 1; // (Flow 2A)
  valid_lfc_flowid[7'b1000011] = 1; // (Flow 3A)
  valid_lfc_flowid[7'b1000100] = 1; // (Flow 4A)
  valid_lfc_flowid[7'b1000101] = 1; // (Flow 5A)
  valid_lfc_flowid[7'b1000110] = 1; // (Flow 6A)
  valid_lfc_flowid[7'b1000111] = 1; // (Flow 7A)
  valid_lfc_flowid[7'b1001000] = 1; // (Flow 8A)

  valid_flow_arb_cmd[4'b0000]  = 1;
  valid_flow_arb_cmd[4'b0010]  = 1;
  valid_flow_arb_cmd[4'b0011]  = 1;
  valid_flow_arb_cmd[4'b0100]  = 1;
  valid_flow_arb_cmd[4'b0101]  = 1;
  valid_flow_arb_cmd[4'b1000]  = 1; 
  valid_flow_arb_cmd[4'b1010]  = 1; 
  valid_flow_arb_cmd[4'b1011]  = 1; 
  valid_flow_arb_cmd[4'b1100]  = 1; 
  valid_flow_arb_cmd[4'b1101]  = 1; 
  valid_flow_arb_cmd[4'b1110]  = 1; 
  valid_flow_arb_cmd[4'b1111]  = 1;        

  valid_tm_mask[8'b0000_0000]  = 1;
  valid_tm_mask[8'b0000_0001]  = 1;
  valid_tm_mask[8'b0000_0011]  = 1;
  valid_tm_mask[8'b0000_0111]  = 1;
  valid_tm_mask[8'b0000_1111]  = 1;
  valid_tm_mask[8'b0001_1111]  = 1;
  valid_tm_mask[8'b0011_1111]  = 1;
  valid_tm_mask[8'b0111_1111]  = 1;
  valid_tm_mask[8'b1111_1111]  = 1;

endfunction: new

// =============================================================================
