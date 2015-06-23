////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_base_generator.sv
// Project :  srio vip
// Purpose :  LL base Generator
// Author  :  Mobiveil
//
// LL Generator base includes common code. Individual packet generators are 
// inherited from this.
//////////////////////////////////////////////////////////////////////////////// 

class srio_ll_base_generator extends uvm_component;

  /// @cond
  `uvm_component_utils(srio_ll_base_generator)
  /// @endcond
  
  srio_trans srio_trans_item;             ///< srio trans 
  srio_env_config env_config;             ///< env config 
  srio_ll_config  ll_config;              ///< ll config 
  srio_reg_block  srio_reg_model;         ///< BFM register model  
  srio_ll_common_class ll_common_class;   ///< LL common module

  extern function new(string name="SRIO_LL_BASE_GENERATOR", uvm_component parent = null); ///< new function
  extern function void build_phase(uvm_phase phase);                                 ///< build_phase
  extern virtual function bool is_ftype_ttype_valid(srio_trans i_srio_trans);        ///< Checks if ftype/ttype is valid
  extern virtual function srio_ll_gen_kind get_ll_gen_kind(srio_trans i_srio_trans); ///< Finds the packet kind
  extern virtual task print_ll_tx_rx(bool dir,srio_trans i_srio_trans);              ///< Prints LL packet generation information
  extern virtual task get_byte_cnt_en(logic wdptr,logic [3:0] wr_rd_size,     
                                      output integer byte_cnt,output logic[7:0] byte_en,output integer act_byte_cnt);
                                       ///< Byte cnt and byten en value calculation 
endclass: srio_ll_base_generator

//////////////////////////////////////////////////////////////////////////
/// Name: new \n
/// Description: LL Base generator's new function \n
/// new
//////////////////////////////////////////////////////////////////////////

function srio_ll_base_generator::new(string name="SRIO_LL_BASE_GENERATOR", uvm_component parent=null);
  super.new(name, parent);
endfunction: new

//////////////////////////////////////////////////////////////////////////
/// Name: build_phase \n
/// Description: LL Base generator's build_phase function \n
/// build_phase
//////////////////////////////////////////////////////////////////////////

function void srio_ll_base_generator::build_phase(uvm_phase phase);

  if(!uvm_config_db #(srio_env_config)::get(this, "", "srio_env_config", env_config))  // Get env config handle from config database
   `uvm_fatal("CONFIG FATAL", "Can't get the env_config") 
  if(!uvm_config_db #(srio_ll_config)::get(this, "", "ll_config", ll_config))          // Get ll config handle from config database
    `uvm_fatal("Config Fatal", "Can't get the ll_config")
  if(!uvm_config_db #(srio_ll_common_class)::get(this, "", "ll_common_class", ll_common_class))  // Get ll common class handle from config database
    `uvm_fatal("Config Fatal", "Can't get the ll_common_class")
  srio_reg_model = env_config.srio_reg_model_tx;                                       // BFM register model handle
endfunction: build_phase

//////////////////////////////////////////////////////////////////////////
/// Name: is_ftype_ttype_valid \n
/// Description: Checks if ftype and ttype is valid \n
/// is_ftype_ttype_valid
//////////////////////////////////////////////////////////////////////////

function bool srio_ll_base_generator::is_ftype_ttype_valid(srio_trans i_srio_trans);
bit [3:0]        trans_ftype; 
bit [3:0]        trans_ttype; 
bool             ft_valid; 
begin
  ft_valid     = TRUE;
  trans_ftype  = i_srio_trans.ftype;
  trans_ttype  = i_srio_trans.ttype;

  if ((trans_ftype == TYPE0) || (trans_ftype == TYPE3) || (trans_ftype == TYPE4) ||  // Invalid Ftypes 
      (trans_ftype == TYPE12)|| (trans_ftype == TYPE14)|| (trans_ftype == TYPE15)) 
  begin 
   `uvm_warning(get_name(),$sformatf("Unsupported TYPE: %s; ",trans_ftype)); 
    ft_valid = FALSE;
  end else
  begin     // Check if ttype is valid for the given ftype
    if(((trans_ftype == TYPE1)  &&  (trans_ttype > 2))                                                 || 
       ((trans_ftype == TYPE5)  && ((trans_ttype != 0)  && (trans_ttype != 1)   && (trans_ttype != 4) &&   
                               (trans_ttype != 5)  && (trans_ttype != 12)) && 
                               (trans_ttype != 13) && (trans_ttype != 14))                         ||
       ((trans_ftype == TYPE8)  &&  (trans_ttype > 4))                                                 || 
       ((trans_ftype == TYPE13) &&  (trans_ttype != 0)  && (trans_ttype != 1)   && (trans_ttype != 8))) 
    begin 
     `uvm_warning(get_name(),$sformatf("Unsupported TTYPE: %h for TYPE: %s",trans_ttype,trans_ftype)); 
      ft_valid = FALSE;
    end 
  end
  return ft_valid;
end
endfunction: is_ftype_ttype_valid

//////////////////////////////////////////////////////////////////////////
/// Name: get_ll_gen_kind \n
/// Description: Checks ftype and indicates if packet blongs to IO,GSM,MSG_DB,\n
/// DS,LFC and RESP Group.\n
/// get_ll_gen_kind
//////////////////////////////////////////////////////////////////////////

function srio_ll_gen_kind srio_ll_base_generator::get_ll_gen_kind(srio_trans i_srio_trans);
bit [3:0] trans_ftype; 
bit [3:0] trans_ttype; 
srio_ll_gen_kind ll_gen_kind;
begin

  trans_ftype  = i_srio_trans.ftype;
  trans_ttype  = i_srio_trans.ttype;
  
  ll_gen_kind = INVALID;

  if((trans_ftype == TYPE1 && trans_ttype <  4'h3) ||
     (trans_ftype == TYPE2 && trans_ttype != 4'h4 && trans_ttype < 4'hC) ||
     (trans_ftype == TYPE5 && trans_ttype < 4'h2))
  begin
    ll_gen_kind = GSM;
  end
  if((trans_ftype == TYPE2 && (trans_ttype == 4'h4 || trans_ttype > 4'hB)) ||
     (trans_ftype == TYPE6) ||
     (trans_ftype == TYPE8 && (trans_ttype < 4'h2 || trans_ttype == 4'h4)) ||
     (trans_ftype == TYPE5 && (trans_ttype == 4'h4 || trans_ttype == 4'h5 || trans_ttype > 4'hB)))
  begin
    ll_gen_kind = IO;
  end
  if(trans_ftype == TYPE7)
  begin
    ll_gen_kind = LFC;
  end
  if(trans_ftype == TYPE9)
  begin
    ll_gen_kind = DS;
  end
  if(trans_ftype == TYPE10 || trans_ftype == TYPE11)
  begin
    ll_gen_kind = MSG_DB;
  end 
  if(trans_ftype == TYPE13 || (trans_ftype == TYPE8 && (trans_ttype == 4'h2 || trans_ttype == 4'h3)))
  begin
    ll_gen_kind = RESP;
  end
  return ll_gen_kind;
end
endfunction: get_ll_gen_kind

//////////////////////////////////////////////////////////////////////////
/// Name: print_ll_tx_rx \n
/// Description: Prints information about the packet generated/received \n
/// print_ll_tx_rx
//////////////////////////////////////////////////////////////////////////

task srio_ll_base_generator::print_ll_tx_rx(bool dir,srio_trans i_srio_trans);
srio_trans_ftype    trans_ftype;  
srio_trans_ttype1   trans_ttype1; 
srio_trans_ttype2   trans_ttype2; 
srio_trans_ttype5   trans_ttype5; 
srio_trans_ttype8   trans_ttype8; 
srio_trans_ttype13  trans_ttype13;
string              tx_rx;    // Transmitted or Received
begin

  if(dir)
    tx_rx = "Generate";
  else  
    tx_rx = "Received";
  /// Casting ftype and ttype for easy printing
  trans_ftype        = srio_trans_ftype'(i_srio_trans.ftype);
  trans_ttype1       = srio_trans_ttype1'(i_srio_trans.ttype);
  trans_ttype2       = srio_trans_ttype2'(i_srio_trans.ttype);
  trans_ttype5       = srio_trans_ttype5'(i_srio_trans.ttype);
  trans_ttype8       = srio_trans_ttype8'(i_srio_trans.ttype);
  trans_ttype13      = srio_trans_ttype13'(i_srio_trans.ttype);

  `uvm_info(get_name(),$sformatf("%s %s Packet", tx_rx,(
  (trans_ftype == FTYPE1) ? trans_ttype1.name : (
  (trans_ftype == FTYPE2) ? trans_ttype2.name : (
  (trans_ftype == FTYPE5) ? trans_ttype5.name : (
  (trans_ftype == FTYPE6) ? "SWRITE"    : (
  (trans_ftype == FTYPE7) ? "LFC"       : (
  (trans_ftype == FTYPE8) ? trans_ttype8.name : (
  (trans_ftype == FTYPE9) ? ((i_srio_trans.xh == 1) ? "DS TM" : "DS") : (
  (trans_ftype == FTYPE10)? "DOOR BELL" : (
  (trans_ftype == FTYPE11)? "DATA MSG"  : (
  (trans_ftype == FTYPE13)? trans_ttype13.name: "UNRECOGNIZED PKT"))))))))))), UVM_LOW);

end
endtask: print_ll_tx_rx

//////////////////////////////////////////////////////////////////////////
/// Name: get_byte_cnt_en \n
/// Description: Returns byte cnt and byte en values for given wdprt and size \n
/// get_byte_cnt_en
//////////////////////////////////////////////////////////////////////////

task srio_ll_base_generator::get_byte_cnt_en(logic wdptr,logic [3:0] wr_rd_size,output integer byte_cnt,
                                      output logic[7:0] byte_en,output integer act_byte_cnt);
logic [4:0] pld_size;    
begin 
    pld_size = {wdptr,wr_rd_size};

    case(pld_size)

      5'b0_0000: begin
                   byte_cnt = 8; 
                   act_byte_cnt = 1;
                   byte_en  = 8'b1000_0000;
                 end 
      5'b0_0001: begin
                   byte_cnt = 8; 
                   act_byte_cnt = 1;
                   byte_en  = 8'b0100_0000;
                 end 
      5'b0_0010: begin
                   byte_cnt = 8; 
                   act_byte_cnt = 1;
                   byte_en  = 8'b0010_0000;
                 end 
      5'b0_0011: begin
                   byte_cnt = 8; 
                   act_byte_cnt = 1;
                   byte_en  = 8'b0001_0000;
                 end 
      5'b1_0000: begin
                   byte_cnt = 8; 
                   act_byte_cnt = 1;
                   byte_en  = 8'b0000_1000;
                 end 
      5'b1_0001: begin
                   byte_cnt = 8; 
                   act_byte_cnt = 1;
                   byte_en  = 8'b0000_0100;
                 end 
      5'b1_0010: begin
                   byte_cnt = 8; 
                   act_byte_cnt = 1;
                   byte_en  = 8'b0000_0010;
                 end 
      5'b1_0011: begin
                   byte_cnt = 8; 
                   act_byte_cnt = 1;
                   byte_en  = 8'b0000_0001;
                 end 
      5'b0_0100: begin
                   byte_cnt = 8; 
                   act_byte_cnt = 2;
                   byte_en  = 8'b1100_0000;
                 end 
      5'b0_0101: begin
                   byte_cnt = 8; 
                   act_byte_cnt = 3;
                   byte_en  = 8'b1110_0000;
                 end 
      5'b0_0110: begin
                   byte_cnt = 8; 
                   act_byte_cnt = 2;
                   byte_en  = 8'b0011_0000;
                 end 
      5'b0_0111: begin
                   byte_cnt = 8; 
                   act_byte_cnt = 5;
                   byte_en  = 8'b1111_1000;
                 end 
      5'b1_0100: begin
                   byte_cnt = 8; 
                   act_byte_cnt = 2;
                   byte_en  = 8'b0000_1100;
                 end 
      5'b1_0101: begin
                   byte_cnt = 8; 
                   act_byte_cnt = 3;
                   byte_en  = 8'b0000_0111;
                 end 
      5'b1_0110: begin
                   byte_cnt = 8; 
                   act_byte_cnt = 2;
                   byte_en  = 8'b0000_0011;
                 end 
      5'b1_0111: begin
                   byte_cnt = 8; 
                   act_byte_cnt = 5;
                   byte_en  = 8'b0001_1111;
                 end 
      5'b0_1000: begin
                   byte_cnt = 8; 
                   act_byte_cnt = 4;
                   byte_en  = 8'b1111_0000;
                 end 
      5'b1_1000: begin
                   byte_cnt = 8; 
                   act_byte_cnt = 4;
                   byte_en  = 8'b0000_1111;
                 end 
      5'b0_1001: begin
                   byte_cnt = 8; 
                   act_byte_cnt = 6;
                   byte_en  = 8'b1111_1100;
                 end 
      5'b1_1001: begin
                   byte_cnt = 8; 
                   act_byte_cnt = 6;
                   byte_en  = 8'b0011_1111;
                 end 
      5'b0_1010: begin
                   byte_cnt = 8; 
                   act_byte_cnt = 7;
                   byte_en  = 8'b1111_1110;
                 end 
      5'b1_1010: begin
                   byte_cnt = 8; 
                   act_byte_cnt = 7;
                   byte_en  = 8'b0111_1111;
                 end 
      5'b0_1011: begin
                   byte_cnt = 8;
                   act_byte_cnt = 8;
                   byte_en  = 8'b1111_1111;
                 end 
      5'b1_1011: begin
                   byte_cnt = 16;
                   act_byte_cnt = 16;
                   byte_en  = 8'b1111_1111;
                 end 
      5'b0_1100: begin
                   byte_cnt = 32;
                   act_byte_cnt = 32;
                   byte_en  = 8'b1111_1111;
                 end 
      5'b1_1100: begin
                   byte_cnt = 64;
                   act_byte_cnt = 64;
                   byte_en  = 8'b1111_1111;
                 end 
      5'b0_1101: begin
                   byte_cnt = 96;
                   act_byte_cnt = 96;
                   byte_en  = 8'b1111_1111;
                 end 
      5'b1_1101: begin
                   byte_cnt = 128;
                   act_byte_cnt = 128;
                   byte_en  = 8'b1111_1111;
                 end 
      5'b0_1110: begin
                   byte_cnt = 160;
                   act_byte_cnt = 160;
                   byte_en  = 8'b1111_1111;
                 end 
      5'b1_1110: begin
                   byte_cnt = 192;
                   act_byte_cnt = 192;
                   byte_en  = 8'b1111_1111;
                 end 
      5'b0_1111: begin
                   byte_cnt = 224;
                   act_byte_cnt = 224;
                   byte_en  = 8'b1111_1111;
                 end 
      5'b1_1111: begin
                   byte_cnt = 256;
                   act_byte_cnt = 256;
                   byte_en  = 8'b1111_1111;
                 end 
      default:   begin
                   byte_cnt = 8;
                   act_byte_cnt = 8;
                   byte_en  = 8'b1111_1111;
                 end 

    endcase 

end 
endtask: get_byte_cnt_en
