////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_reg_adapter.sv
// Project :  srio vip
// Purpose :  srio register adapter
// Author  :  Mobiveil
//
// The SRIO Register Adapter converts SRIO transactions (Maintenance, NWRITE_R/NREAD) 
// into register transactions. The conversion of srio_trans sequence item into a 
// register transac-tion is implemented inside bus2reg function of Adapter class
// 
//////////////////////////////////////////////////////////////////////////////// 

class srio_reg_adapter extends uvm_reg_adapter;

  `uvm_object_utils(srio_reg_adapter)

  bit we;
  int index;

  function new(string name = "srio_reg_adapter");
    super.new(name);
  endfunction

  virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
  endfunction: reg2bus

//////////////////////////////////////////////////////////////////////////
/// Name: bus2reg
/// Description: 
/// bus2reg function converts srio_trans seq_item into register transactions
/// The converted register transactions are used by register model to update
/// the register fields in the register model
/// bus2reg
//////////////////////////////////////////////////////////////////////////

  virtual function void bus2reg (uvm_sequence_item bus_item, 
                                 ref uvm_reg_bus_op rw);
  
    srio_trans seq_item;
    
    if (!$cast(seq_item, bus_item)) begin
      `uvm_warning("NOT_SRIO_TRANS_TYPE","Provided txn is not of the correct type")
      return;
    end
    
    /// Identify Write/Read Transaction
    if(seq_item.ftype==4'h2 && seq_item.ttype==4'h4)  ///< NREAD
      we = 1'b0;
    else if(seq_item.ftype==4'h5 && seq_item.ttype==4'h5)  ///< NWRITE_R
      we = 1'b1;
    else if(seq_item.ftype==4'h8 && seq_item.ttype==4'h0) ///< MAINT READ
      we = 1'b0;
    else if(seq_item.ftype==4'h8 && seq_item.ttype==4'h1) ///< MAINT WRITE
      we = 1'b1;
    
    rw.kind = we ? UVM_WRITE : UVM_READ; ///< update WRITE/READ

    if(seq_item.ftype==4'h8)
      rw.addr = seq_item.config_offset; ///< addr is updated from config_offset for MAINT txns
    else
      rw.addr = seq_item.address[23:0]; ///< addr is updated from address for non MAINT txns 

    rw.data[31:0] = {reverse_data(seq_item.payload[0]), reverse_data(seq_item.payload[1]), reverse_data(seq_item.payload[2]), reverse_data(seq_item.payload[3])}; ///< reverse data payload bytes and bits since registers are implemented little endian format
    rw.status = UVM_IS_OK;
    
  endfunction: bus2reg

//////////////////////////////////////////////////////////////////////////
/// Name: reverse_data
/// Description: returns the bit reversed data byte
/// reverse_data
//////////////////////////////////////////////////////////////////////////

  function bit [7:0] reverse_data(bit [7:0] in_data);
    bit [7:0] out_data;
    
    index = 7;
    for(int i=0; i<8; i++)
    begin // {
      out_data[index] = in_data[i];
      index = index-1;
    end //}

    reverse_data = out_data;
   
  endfunction : reverse_data

endclass: srio_reg_adapter
