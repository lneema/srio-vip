////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_rx_trans_decoder.sv
// Project :  srio vip
// Purpose :
// Author  :  Mobiveil
//
// Sub-block instantiated inside SRIO transaction decoder
// This block decodes the responses received by BFM from DUT
//
////////////////////////////////////////////////////////////////////////////////

class srio_rx_trans_decoder extends uvm_subscriber #(srio_trans);

  `uvm_component_utils(srio_rx_trans_decoder)
  
  srio_trans rx_trans;
  event rx_trans_done;
  
  extern function new(string name = "srio_rx_trans_decoder", uvm_component parent = null);
  extern function void write(srio_trans t);
  
endclass: srio_rx_trans_decoder

function srio_rx_trans_decoder::new(string name = "srio_rx_trans_decoder", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void srio_rx_trans_decoder::write(srio_trans t);
  /// filter NWRITE_R, NREAD, MAINT_W and MAINT_R txns only
  if( (t.ftype=='hd && t.ttype==0) ///< NWRITE_R
      || (t.ftype==8 && t.ttype==3) ///< MAINT_W  
      || (t.ftype=='hd && t.ttype==8) ///< NREAD  
      || (t.ftype==8 && t.ttype==2) ///< MAINT_R  
    )
  begin //{
    rx_trans = new t;
    -> rx_trans_done;
  end //}
endfunction: write
