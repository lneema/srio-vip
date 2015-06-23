////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_tx_trans_decoder.sv
// Project :  srio vip
// Purpose :
// Author  :  Mobiveil
//
// Sub-block instantiated inside SRIO transaction decoder
// This block decodes the MAINT_RD, MAINT_WR, NWRITE_R, NREAD
// transaction requests transmitted by BFM
//
////////////////////////////////////////////////////////////////////////////////

typedef enum {DUT_SRIO_ADDR_34,DUT_SRIO_ADDR_50,DUT_SRIO_ADDR_66} dut_address_mode;

class srio_tx_trans_decoder extends uvm_subscriber #(srio_trans);

  `uvm_component_utils(srio_tx_trans_decoder)
  
  srio_trans tx_trans;
  event tx_trans_done;
  srio_env_config env_config;
  dut_address_mode addr_mode_dut;
  bit [31:0] reg_read_data;
  bit [31:0] reg_write_data;
  bit [31:0] LCSBA0_data;
  bit [31:0] LCSBA1_data;
  bit [31:0] LCSBA0_data_rev;
  bit [31:0] LCSBA1_data_rev;
  bit [65:0] base_addr;
  bit [65:0] base_limit;
  bit [65:0] trans_addr;
  srio_reg_block srio_reg_model;
  
  extern function new(string name = "srio_tx_trans_decoder", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern function void write(srio_trans t);
  
endclass: srio_tx_trans_decoder

function srio_tx_trans_decoder::new(string name = "srio_tx_trans_decoder", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void srio_tx_trans_decoder::build_phase(uvm_phase phase);
  if(!uvm_config_db #(srio_env_config)::get(this, "", "srio_env_config", env_config)) begin
    `uvm_error("build_phase", "Failed to find srio_env_config")
  end
endfunction

function void srio_tx_trans_decoder::write(srio_trans t);
  
  /// filter NWRITE_R, NREAD, MAINT_W and MAINT_R txns only
  if(
      (t.ftype==8 && t.ttype==1) ///< MAINT_W  
      || (t.ftype==8 && t.ttype==0) ///< MAINT_R  
    )
  begin //{
    tx_trans = new t;
    -> tx_trans_done; ///< trigger tx_trans_done event
  end //}
  else if (
            (t.ftype==5 && t.ttype==5) ///< NWRITE_R
            || (t.ftype==2 && t.ttype==4) ///< NREAD  
          )
  begin //{

    /// Addr mode of SRIO DUT
    reg_read_data = srio_reg_model.Processing_Element_Logical_Layer_Control_CSR.get();
    if(reg_read_data[31:29] == 3'b100) ///< 34 bit addressing mode
    begin //{
      addr_mode_dut = DUT_SRIO_ADDR_34;
    end //}
    else if(reg_read_data[31:29] == 3'b010) ///< 50 bit addressing mode
    begin //{
      addr_mode_dut = DUT_SRIO_ADDR_50;
    end //}
    else
    begin //{
      addr_mode_dut = DUT_SRIO_ADDR_66; ///< 66 bit addressing mode
    end //}
    
    /// Get the Base Addr of SRIO Registers
    LCSBA0_data = srio_reg_model.Local_Configuration_Space_Base_Address_0_CSR.get();
    LCSBA1_data = srio_reg_model.Local_Configuration_Space_Base_Address_1_CSR.get();

    /// reverse the data read from LCSBA* register
    for(int i=0; i<32; i++)
    begin //{
      LCSBA0_data_rev[31-i] = LCSBA0_data[i];
      LCSBA1_data_rev[31-i] = LCSBA1_data[i];
    end //}


    /// form base_addr, base_limit and transaction request address based on 
    /// the addressing mode selected and register space size configured in
    /// env_config (reg_space_size)
    if(addr_mode_dut == DUT_SRIO_ADDR_34)
    begin //{
      base_addr  = {LCSBA1_data_rev[30:1], 1'b0, 3'b000};
      base_limit = base_addr + env_config.reg_space_size;
      trans_addr = {t.xamsbs, t.address, 3'b000};
    end //}
    else if(addr_mode_dut == DUT_SRIO_ADDR_50)
    begin //{
      base_addr  = {LCSBA0_data_rev[14:0], LCSBA1_data_rev[31:0], 3'b000};
      base_limit = base_addr + env_config.reg_space_size;
      trans_addr = {t.xamsbs, t.ext_address[15:0], t.address, 3'b000};
    end //}
    else ///< DUT_SRIO_ADDR_66
    begin //{
      base_addr  = {LCSBA0_data_rev[30:0], LCSBA1_data_rev[31:0], 3'b000};
      base_limit = base_addr + env_config.reg_space_size;
      trans_addr = {t.xamsbs, t.ext_address, t.address, 3'b000};
    end //}

    /// check if NWRITE_R and NREAD are accessing register address ranges
    if(trans_addr >= base_addr && trans_addr <= base_limit)
    begin //{
      tx_trans = new t;
      -> tx_trans_done;
    end //}
  end //}
endfunction: write

