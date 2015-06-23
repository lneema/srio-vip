////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_trans.sv
// Project :  srio vip
// Purpose :  Sequence Item
// Author  :  Mobiveil
//
// SRIO VIP's Sequence Item extended from srio_base_trans. 
////////////////////////////////////////////////////////////////////////////////
 
class srio_trans extends srio_base_trans;

  /// @cond
  `uvm_object_utils_begin(srio_trans)
  /// @endcond
    uvm_default_packer.use_metadata = 1;
    `uvm_field_int(ftype               , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(SourceID            , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(DestinationID       , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(tt                  , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(crf                 , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(prio                , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(wdptr               , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(wrsize              , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(rdsize              , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(SrcTID              , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(ttype               , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(ext_address         , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(address             , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(xamsbs              , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(config_offset       , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(hop_count           , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(msg_len             , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(ssize               , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(letter              , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(mbox                , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(msgseg_xmbox        , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(info_lsb            , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(info_msb            , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(cos                 , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(S                   , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(E                   , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(O                   , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(P                   , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(xh                  , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(xtype               , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(wild_card           , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(parameter1          , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(parameter2          , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(TMOP                , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(mask                , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(streamID            , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(pdulength           , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(mtusize             , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(SecTID              , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(SecID               , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(sec_domain          , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(tgtdestID           , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(xon_xoff            , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(SOC                 , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(flowID              , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(targetID_Info       , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(trans_status        , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(ackid               , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(vc                  , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(crc32               , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(early_crc           , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(final_crc           , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
  `uvm_object_utils_end

  srio_trans_ftype    trans_ftype;  
  srio_trans_ttype1   trans_ttype1; 
  srio_trans_ttype2   trans_ttype2; 
  srio_trans_ttype5   trans_ttype5; 
  srio_trans_ttype8   trans_ttype8; 
  srio_trans_ttype13  trans_ttype13;

  bit[31:0] misc_flag1;
  bit[31:0] misc_flag2;
  bit[31:0] misc_flag3;
  bit[31:0] misc_flag4;
  bit[31:0] misc_flag5;


  extern function new(string name="srio_trans");
  extern function void do_pack(uvm_packer packer);
  extern function void do_unpack(uvm_packer packer);
  extern function int findearlycrc();
  extern function int findfinalcrc();
  extern function void calcCRC();
  extern function void calcCRC32();
  extern function [31:0]  compute_crc32(int start,int finish,logic [31:0] _init_crc);
  extern function void gen_bytestream(int length);
  extern function void setCRC(int  _CRC);
  extern function logic[15:0] computecrc16(int start, int finish, logic[15:0] _runningCRC);
  extern function logic[31:0] getCRC();
  extern function logic [0:4] calccrc5(logic [0:37] scs_val);
  extern function logic [0:12] calccrc13(logic [0:37] lcs_val);
  extern function logic [0:23] calccrc24(logic [0:37] scs_val);
  extern function logic [0:37] pack_cs();
  extern function void set_delimiter();
  extern function void pack_cs_bytes();
  extern function void unpack_cs_bytes();
  extern function void do_print(uvm_printer printer);
  extern function void do_copy(uvm_object rhs);
  extern function bit  do_compare(uvm_object rhs, uvm_comparer comparer);
endclass: srio_trans

////////////////////////////////////////////////////////////////////////////////
/// Name: new \n 
/// Description: srio_trans's new function \n
/// new
//////////////////////////////////////////////////////////////////////////////// 

function srio_trans::new(string name="srio_trans");
  super.new(name);
endfunction : new

////////////////////////////////////////////////////////////////////////////////
/// Name: set_delimiter \n 
/// Description: Function to set the delimiter of control symbols \n
/// set_delimiter
//////////////////////////////////////////////////////////////////////////////// 

function void srio_trans::set_delimiter();

  if(stype1 == 3'b000 || stype1 == 3'b010 || stype1 == 3'b001 /*|| stype1 == 3'b100 || stype1 == 3'b011*/)
     delimiter = 8'h7C;
  else
     delimiter = 8'h1C;

endfunction: set_delimiter

////////////////////////////////////////////////////////////////////////////////
/// Name: pack_cs_bytes \n 
/// Description: Function to pack the Control symbols into the bytestream \n
/// pack_cs_bytes
//////////////////////////////////////////////////////////////////////////////// 

function void srio_trans::pack_cs_bytes();

  if(cstype == CS24)
     bytestream_cs = new[4];
  else if(cstype == CS48)
     bytestream_cs = new[8];
  else if(cstype == CS64)
     bytestream_cs = new[8];

  if(cstype != CS64) 
   bytestream_cs[0] = delimiter;
  else
   bytestream_cs[0] = {stype0,param0[0:3]};

  if(cstype == CS24)
    bytestream_cs[1] = {stype0[1:3],param0[7:11]};
  else if(cstype == CS48)
    bytestream_cs[1] = {stype0[1:3],param0[6:10]};
  else if(cstype == CS64)
    bytestream_cs[1] = param0[4:11];

  if(cstype == CS24)
    bytestream_cs[2] = {param1[7:11],stype1};
  else if(cstype == CS48)
    bytestream_cs[2] = {param0[11],param1[6:11],stype1[0]};
  else if(cstype == CS64)
    bytestream_cs[2] = param1[0:7];

  if(cstype == CS24)
    bytestream_cs[3] = {cmd,cs_crc5};
  else if(cstype == CS48)
    bytestream_cs[3] = {stype1[1:2],cmd,3'b0};
  else if(cstype == CS64)
    bytestream_cs[3] = {param1[8:11],brc3_stype1_msb,2'b00};
 
  if(cstype == CS48)
  begin //{
    bytestream_cs[4] = {8'b0}; 
    bytestream_cs[5] = {3'b0,cs_crc13[0:4]};
    bytestream_cs[6] = {cs_crc13[5:12]};
    bytestream_cs[7] = delimiter;
  end //}
  else if(cstype == CS64)
  begin //{
    bytestream_cs[4] = {stype1,cmd,cs_crc24[0:1]};
    bytestream_cs[5] = cs_crc24[2:9];
    bytestream_cs[6] = cs_crc24[10:17]; 
    bytestream_cs[7] = {cs_crc24[18:23],2'b00};
  end //}

endfunction:pack_cs_bytes

////////////////////////////////////////////////////////////////////////////////
/// Name: unpack_cs_bytes \n 
/// Description: Function to unpack the Control symbols from the bytestream \n
/// unpack_cs_bytes
//////////////////////////////////////////////////////////////////////////////// 

function void srio_trans::unpack_cs_bytes();

  int total_bytes;
  logic [0:7] _byte [int];

  total_bytes = this.bytestream_cs.size();

  for (int i=0;i< this.bytestream_cs.size(); i++) begin //{
      _byte[i] = this.bytestream_cs[i];
  end //}

  delimiter = _byte[0];
  stype0 = _byte[1][0:2];

  if(cstype == CS24)
    param0[7:11] = _byte[1][3:7];
  else if(cstype == CS48)
    param0[6:11] = {_byte[1][3:7],_byte[2][0]}; 

  if(cstype == CS24)
    param1[7:11] = _byte[2][0:4];
  else if(cstype == CS48)
    param1[6:11] = _byte[2][1:6]; 
   
  if(cstype == CS24)
    stype1 = _byte[2][5:7];
  else if(cstype == CS48)
    stype1 = {_byte[2][7],_byte[3][0:1]}; 

  if(cstype == CS24)
    cmd = _byte[3][0:2];
  else if(cstype == CS48)
    cmd = _byte[3][2:4];

  if(cstype == CS24)
    cs_crc5 = _byte[3][3:7];
  else if(cstype == CS48)
    reserved[0:7] = {_byte[3][5:7],_byte[4][0:4]};
  
  if(cstype == CS48)
    reserved[8:13] = {_byte[4][5:7],_byte[5][0:2]};
  
  if(cstype == CS48)
    cs_crc13[0:7] = {_byte[5][3:7],_byte[6][0:2]};

  if(cstype == CS48)
    cs_crc13[8:12] = _byte[6][3:7];


endfunction : unpack_cs_bytes

function logic [0:37] srio_trans::pack_cs();
  
  if(cstype == CS64)
    pack_cs = {stype0,param0,param1,brc3_stype1_msb,2'b00,stype1,cmd};
  else if(cstype == CS48)
    pack_cs = {stype0,param0[6:11],param1[6:11],stype1,cmd};
  else 
    pack_cs = {stype0,param0[6:11],param1[6:11],stype1,cmd};

endfunction: pack_cs

function logic [0:4] srio_trans::calccrc5(logic [0:37] scs_val);

  logic [0:20] temp_val;

  temp_val = scs_val[17:37];

  calccrc5[0] = ( temp_val[ 0] ^ temp_val[ 1] ^
                           temp_val[ 4] ^ temp_val[ 5] ^
                           temp_val[ 6] ^ temp_val[12] ^
                           temp_val[14] ^ temp_val[17] ^
                           temp_val[18] ^ temp_val[20] );

  calccrc5[1] = ( temp_val[ 0] ^ temp_val[ 2] ^
                           temp_val[ 4] ^ temp_val[ 7] ^
                           temp_val[12] ^ temp_val[13] ^
                           temp_val[14] ^ temp_val[15] ^
                           temp_val[17] ^ temp_val[19] ^
                           ~temp_val[20]  );

  calccrc5[2] = ( temp_val[ 1] ^ temp_val[ 4] ^
                           temp_val[ 5] ^ temp_val[ 8] ^
                           temp_val[13] ^ temp_val[14] ^
                           temp_val[15] ^ temp_val[16] ^
                           temp_val[18] ^ ~temp_val[20]);

  calccrc5[3] = ( temp_val[ 1] ^ temp_val[ 2] ^
                           temp_val[ 4] ^ temp_val[10] ^
                           temp_val[12] ^ temp_val[15] ^
                           temp_val[16] ^ temp_val[18] ^
                           temp_val[19] ^ ~temp_val[20]);

  calccrc5[4] = ( temp_val[ 0] ^ temp_val[ 2] ^
                             temp_val[ 4] ^ temp_val[ 5] ^
                             temp_val[11] ^ temp_val[13] ^
                             temp_val[16] ^ temp_val[17] ^
                             temp_val[19] ^ temp_val[20] );

  cs_crc5 = calccrc5;

endfunction : calccrc5

function logic [0:12] srio_trans::calccrc13(logic [0:37] lcs_val);

  logic [0:20] temp_val;

  bit poly_load = 0;

  temp_val = lcs_val[17:37];

  calccrc13[ 0 ]  = ( temp_val[ 4] ^ temp_val[ 6] ^
                             temp_val[ 9] ^ temp_val[14] ^
                            temp_val[19] ) ^ poly_load;
  calccrc13[ 1 ]  = ( temp_val[ 0] ^ temp_val[ 5] ^
                             temp_val[ 7] ^ temp_val[10] ^
                             temp_val[15] ^ temp_val[20] );
  calccrc13[ 2 ]  = ( temp_val[ 1] ^ temp_val[ 6] ^
                             temp_val[ 8] ^ temp_val[11] ^
                             temp_val[16] );
  calccrc13[ 3 ]  = ( temp_val[ 2] ^ temp_val[ 4] ^
                             temp_val[ 6] ^ temp_val[ 7] ^
                             temp_val[12] ^ temp_val[14] ^
                            temp_val[17] ^ temp_val[19] ) ^ poly_load;
  calccrc13[ 4 ]  = ( temp_val[ 3] ^ temp_val[ 5] ^
                             temp_val[ 7] ^ temp_val[ 8] ^
                             temp_val[13] ^ temp_val[15] ^
                             temp_val[18] ^ temp_val[20] );
  calccrc13[ 5 ]  = ( temp_val[ 0] ^ temp_val[ 8] ^
                             temp_val[16] );
  calccrc13[ 6 ]  = ( temp_val[ 1] ^ temp_val[ 9] ^
                             temp_val[17] );
  calccrc13[ 7 ]  = ( temp_val[ 2] ^ temp_val[10] ^
                             temp_val[18] );
  calccrc13[ 8 ]  = ( temp_val[ 3] ^ temp_val[ 4] ^
                             temp_val[ 6] ^ temp_val[ 9] ^
                             temp_val[11] ^ temp_val[14] ) ^ poly_load;
  calccrc13[ 9 ]  = ( temp_val[ 0] ^ temp_val[ 4] ^
                             temp_val[ 5] ^ temp_val[ 7] ^
                             temp_val[10] ^ temp_val[12] ^
                             temp_val[15] );
  calccrc13[ 10 ] = ( temp_val[ 1] ^ temp_val[ 5] ^
                             temp_val[ 6] ^ temp_val[ 8] ^
                             temp_val[11] ^ temp_val[13] ^
                             temp_val[16] ) ^ poly_load;
  calccrc13[ 11 ] = ( temp_val[ 2] ^ temp_val[ 4] ^
                             temp_val[ 7] ^ temp_val[12] ^
                             temp_val[17] ^ temp_val[19] );
  calccrc13[ 12 ] = ( temp_val[ 3] ^ temp_val[ 5] ^
                                       temp_val[ 8] ^ temp_val[13] ^
                                       temp_val[18] ^ temp_val[20] ) ^ poly_load;
 

  cs_crc13 = calccrc13;
endfunction : calccrc13

function logic [0:23] srio_trans::calccrc24(logic [0:37] scs_val);
  logic [0:37] temp_val;

  temp_val = scs_val;

      calccrc24[0] = temp_val[36] ^ temp_val[33] ^ temp_val[29] ^ temp_val[28] ^ temp_val[27] ^ temp_val[25] ^ temp_val[24] ^ temp_val[17] ^ temp_val[15] ^ temp_val[14] ^ temp_val[12] ^ temp_val[11] ^ temp_val[10] ^ temp_val[9]  ^ temp_val[4] ^ temp_val[2] ^ temp_val[0];

      calccrc24[1] = temp_val[37] ^ temp_val[34] ^ temp_val[30] ^ temp_val[29] ^ temp_val[28] ^ temp_val[26] ^ temp_val[25] ^ temp_val[18] ^ temp_val[16] ^ temp_val[15] ^ temp_val[13] ^ temp_val[12] ^ temp_val[11] ^ temp_val[10] ^ temp_val[5] ^ temp_val[3] ^ temp_val[1];

      calccrc24[2] = temp_val[36] ^ temp_val[35] ^ temp_val[33] ^ temp_val[31] ^ temp_val[30] ^ temp_val[28] ^ temp_val[26] ^ temp_val[25] ^ temp_val[24] ^ temp_val[19] ^ temp_val[16] ^ temp_val[15] ^ temp_val[13] ^ temp_val[10] ^ temp_val[9] ^ temp_val[6] ^ temp_val[0];

      calccrc24[3] = !temp_val[37] ^ temp_val[36] ^ temp_val[34] ^ temp_val[32] ^ temp_val[31] ^ temp_val[29] ^ temp_val[27] ^ temp_val[26] ^ temp_val[25] ^ temp_val[20] ^ temp_val[17] ^ temp_val[16] ^ temp_val[14] ^ temp_val[11] ^ temp_val[10] ^ temp_val[7] ^ temp_val[1] ^ temp_val[0];

      calccrc24[4] = !temp_val[37] ^ temp_val[36] ^ temp_val[35] ^ temp_val[32] ^ temp_val[30] ^ temp_val[29] ^ temp_val[26] ^ temp_val[25] ^ temp_val[24] ^ temp_val[21] ^ temp_val[18] ^ temp_val[14] ^ temp_val[10] ^ temp_val[9] ^ temp_val[8] ^ temp_val[4] ^ temp_val[1] ^ temp_val[0];

      calccrc24[5] = !temp_val[37] ^ temp_val[31] ^ temp_val[30] ^ temp_val[29] ^ temp_val[28] ^ temp_val[26] ^ temp_val[24] ^ temp_val[22] ^ temp_val[19] ^ temp_val[17] ^ temp_val[14] ^ temp_val[12] ^ temp_val[5] ^ temp_val[4] ^ temp_val[1] ^ temp_val[0];

      calccrc24[6] = !temp_val[36] ^ temp_val[33] ^ temp_val[32] ^ temp_val[31] ^ temp_val[30] ^ temp_val[28] ^ temp_val[24] ^ temp_val[23] ^ temp_val[20] ^ temp_val[18] ^ temp_val[17] ^ temp_val[14] ^ temp_val[13] ^ temp_val[12] ^ temp_val[11] ^ temp_val[10] ^ temp_val[9] ^ temp_val[6] ^ temp_val[5] ^ temp_val[4] ^ temp_val[1] ^ temp_val[0];

      calccrc24[7] = temp_val[37] ^ temp_val[34] ^ temp_val[33] ^ temp_val[32] ^ temp_val[31] ^ temp_val[29] ^ temp_val[25] ^ temp_val[24] ^ temp_val[21] ^ temp_val[19] ^ temp_val[18] ^ temp_val[15] ^ temp_val[14] ^ temp_val[13] ^ temp_val[12] ^ temp_val[11] ^ temp_val[10] ^ temp_val[7] ^ temp_val[6] ^ temp_val[5] ^ temp_val[2] ^ temp_val[1];

      calccrc24[8] = !temp_val[36] ^ temp_val[35] ^ temp_val[34] ^ temp_val[32] ^ temp_val[30] ^ temp_val[29] ^ temp_val[28] ^ temp_val[27] ^ temp_val[26] ^ temp_val[24] ^ temp_val[22] ^ temp_val[20] ^ temp_val[19] ^ temp_val[17] ^ temp_val[16] ^ temp_val[13] ^ temp_val[10] ^ temp_val[9] ^ temp_val[8] ^ temp_val[7] ^ temp_val[6] ^ temp_val[4] ^ temp_val[3];

      calccrc24[9] = !temp_val[37] ^ temp_val[36] ^ temp_val[35] ^ temp_val[33] ^ temp_val[31] ^ temp_val[30] ^ temp_val[29] ^ temp_val[28] ^ temp_val[27] ^ temp_val[25] ^ temp_val[23] ^ temp_val[21] ^ temp_val[20] ^ temp_val[18] ^ temp_val[17] ^ temp_val[14] ^ temp_val[11] ^ temp_val[10] ^ temp_val[9] ^ temp_val[8] ^ temp_val[7] ^ temp_val[5] ^ temp_val[4];

      calccrc24[10] = temp_val[37] ^ temp_val[34] ^ temp_val[33] ^ temp_val[32] ^ temp_val[31] ^ temp_val[30] ^ temp_val[27] ^ temp_val[26] ^ temp_val[25] ^ temp_val[22] ^ temp_val[21] ^ temp_val[19] ^ temp_val[18] ^ temp_val[17] ^ temp_val[14] ^ temp_val[8] ^ temp_val[6] ^ temp_val[5] ^ temp_val[4] ^ temp_val[2] ^ temp_val[0];

      calccrc24[11] = temp_val[36] ^ temp_val[35] ^ temp_val[34] ^ temp_val[32] ^ temp_val[31] ^ temp_val[29] ^ temp_val[26] ^ temp_val[25] ^ temp_val[24] ^ temp_val[23] ^ temp_val[22] ^ temp_val[20] ^ temp_val[19] ^ temp_val[18] ^ temp_val[17] ^ temp_val[14] ^ temp_val[12] ^ temp_val[11] ^ temp_val[10] ^ temp_val[7] ^ temp_val[6] ^ temp_val[5] ^ temp_val[4] ^ temp_val[3] ^ temp_val[2] ^ temp_val[1] ^ temp_val[0];

      calccrc24[12] = temp_val[37] ^ temp_val[36] ^ temp_val[35] ^ temp_val[33] ^ temp_val[32] ^ temp_val[30] ^ temp_val[27] ^ temp_val[26] ^ temp_val[25] ^ temp_val[24] ^ temp_val[23] ^ temp_val[21] ^ temp_val[20] ^ temp_val[19] ^ temp_val[18] ^ temp_val[15] ^ temp_val[13] ^ temp_val[12] ^ temp_val[11] ^ temp_val[8] ^ temp_val[7] ^ temp_val[6] ^ temp_val[5] ^ temp_val[4] ^ temp_val[3] ^ temp_val[2] ^ temp_val[1] ^ temp_val[0];

      calccrc24[13] = !temp_val[37] ^ temp_val[34] ^ temp_val[31] ^ temp_val[29] ^ temp_val[26] ^ temp_val[22] ^ temp_val[21] ^ temp_val[20] ^ temp_val[19] ^ temp_val[17] ^ temp_val[16] ^ temp_val[15] ^ temp_val[13] ^ temp_val[11] ^ temp_val[10] ^ temp_val[8] ^ temp_val[7] ^ temp_val[6] ^ temp_val[5] ^ temp_val[3] ^ temp_val[1] ^ temp_val[0];

      calccrc24[14] = temp_val[36] ^ temp_val[35] ^ temp_val[33] ^ temp_val[32] ^ temp_val[30] ^ temp_val[29] ^ temp_val[28] ^ temp_val[25] ^ temp_val[24] ^ temp_val[23] ^ temp_val[22] ^ temp_val[21] ^ temp_val[20] ^ temp_val[18] ^ temp_val[16] ^ temp_val[15] ^ temp_val[10] ^ temp_val[8] ^ temp_val[7] ^ temp_val[6] ^ temp_val[1];

      calccrc24[15] = !temp_val[37] ^ temp_val[36] ^ temp_val[34] ^ temp_val[33] ^ temp_val[31] ^ temp_val[30] ^ temp_val[29] ^ temp_val[26] ^ temp_val[25] ^ temp_val[24] ^ temp_val[23] ^ temp_val[22] ^ temp_val[21] ^ temp_val[19] ^ temp_val[17] ^ temp_val[16] ^ temp_val[11] ^ temp_val[9] ^ temp_val[8] ^ temp_val[7] ^ temp_val[2];

      calccrc24[16] = temp_val[37] ^ temp_val[36] ^ temp_val[35] ^ temp_val[34] ^ temp_val[33] ^ temp_val[32] ^ temp_val[31] ^ temp_val[30] ^ temp_val[29] ^ temp_val[28] ^ temp_val[26] ^ temp_val[23] ^ temp_val[22] ^ temp_val[20] ^ temp_val[18] ^ temp_val[15] ^ temp_val[14] ^ temp_val[11] ^ temp_val[8] ^ temp_val[4] ^ temp_val[3] ^ temp_val[2] ^ temp_val[0];

      calccrc24[17] = !temp_val[37] ^ temp_val[35] ^ temp_val[34] ^ temp_val[32] ^ temp_val[31] ^ temp_val[30] ^ temp_val[28] ^ temp_val[25] ^ temp_val[23] ^ temp_val[21] ^ temp_val[19] ^ temp_val[17] ^ temp_val[16] ^ temp_val[14] ^ temp_val[11] ^ temp_val[10] ^ temp_val[5] ^ temp_val[3] ^ temp_val[2] ^ temp_val[1] ^ temp_val[0];

      calccrc24[18] = !temp_val[35] ^ temp_val[32] ^ temp_val[31] ^ temp_val[28] ^ temp_val[27] ^ temp_val[26] ^ temp_val[25] ^ temp_val[22] ^ temp_val[20] ^ temp_val[18] ^ temp_val[14] ^ temp_val[10] ^ temp_val[9] ^ temp_val[6] ^ temp_val[3] ^ temp_val[1];

      calccrc24[19] = !temp_val[36] ^ temp_val[33] ^ temp_val[32] ^ temp_val[29] ^ temp_val[28]  ^ temp_val[27] ^ temp_val[26] ^ temp_val[23] ^ temp_val[21]  ^ temp_val[19] ^ temp_val[15] ^ temp_val[11] ^ temp_val[10] ^ temp_val[7]  ^ temp_val[4] ^ temp_val[2];

      calccrc24[20] = !temp_val[37] ^ temp_val[34] ^ temp_val[33] ^ temp_val[30] ^ temp_val[29] ^ temp_val[28]  ^ temp_val[27] ^ temp_val[24] ^ temp_val[22] ^ temp_val[20] ^ temp_val[16] ^ temp_val[12] ^ temp_val[11] ^ temp_val[8] ^ temp_val[5]  ^ temp_val[3] ^ temp_val[0];

      calccrc24[21] = !temp_val[36] ^ temp_val[35] ^ temp_val[34] ^ temp_val[33] ^ temp_val[31] ^ temp_val[30] ^ temp_val[27] ^ temp_val[24] ^ temp_val[23] ^ temp_val[21]   ^ temp_val[15] ^ temp_val[14] ^ temp_val[13] ^ temp_val[11] ^ temp_val[10] ^ temp_val[6] ^ temp_val[2] ^ temp_val[1] ^ temp_val[0]; 

      calccrc24[22] = !temp_val[37] ^ temp_val[36] ^ temp_val[35] ^ temp_val[34]  ^ temp_val[32]  ^ temp_val[31]  ^ temp_val[28]  ^ temp_val[25] ^ temp_val[24] ^ temp_val[22]  ^ temp_val[16]  ^ temp_val[15] ^ temp_val[14]  ^ temp_val[12] ^ temp_val[11]  ^ temp_val[7]  ^ temp_val[3]  ^ temp_val[2] ^ temp_val[1] ^ temp_val[0];  

      calccrc24[23] = temp_val[37] ^ temp_val[35]  ^ temp_val[32] ^ temp_val[28]  ^ temp_val[27] ^ temp_val[26]  ^ temp_val[24] ^ temp_val[23] ^ temp_val[16] ^ temp_val[14] ^ temp_val[13] ^ temp_val[11] ^ temp_val[10] ^ ^ temp_val[9] ^ temp_val[8] ^ temp_val[3] ^ temp_val[1];

   cs_crc24 = calccrc24;

endfunction : calccrc24

function [31:0]  srio_trans::compute_crc32(int start,int finish,logic [31:0] _init_crc);
  logic [31:0] data_in;
  logic [31:0] lfsr_q,lfsr_c;

  lfsr_q = _init_crc;

  for(int i = start;i<finish;i++)
  begin //{
    if(gen3_data_q.size() != 0)
      data_in = gen3_data_q.pop_front();
   
    if(!i)
      data_in = data_in & 32'h03FF_FFFF;
 
      lfsr_c[0] = lfsr_q[0] ^ lfsr_q[6] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[16] ^ lfsr_q[24] ^ lfsr_q[25] ^ lfsr_q[26] ^ lfsr_q[28] ^ lfsr_q[29] ^ lfsr_q[30] ^ lfsr_q[31] ^ data_in[0] ^ data_in[6] ^ data_in[9] ^ data_in[10] ^ data_in[12] ^ data_in[16] ^ data_in[24] ^ data_in[25] ^ data_in[26] ^ data_in[28] ^ data_in[29] ^ data_in[30] ^ data_in[31];

      lfsr_c[1] = lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[9] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[24] ^ lfsr_q[27] ^ lfsr_q[28] ^ data_in[0] ^ data_in[1] ^ data_in[6] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[12] ^ data_in[13] ^ data_in[16] ^ data_in[17] ^ data_in[24] ^ data_in[27] ^ data_in[28];

      lfsr_c[2] = lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[24] ^ lfsr_q[26] ^ lfsr_q[30] ^ lfsr_q[31] ^ data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[13] ^ data_in[14] ^ data_in[16] ^ data_in[17] ^ data_in[18] ^ data_in[24] ^ data_in[26] ^ data_in[30] ^ data_in[31];

      lfsr_c[3] = lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[25] ^ lfsr_q[27] ^ lfsr_q[31] ^ data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[14] ^ data_in[15] ^ data_in[17] ^ data_in[18] ^ data_in[19] ^ data_in[25] ^ data_in[27] ^ data_in[31];

      lfsr_c[4] = lfsr_q[0] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[6] ^ lfsr_q[8] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[15] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[24] ^ lfsr_q[25] ^ lfsr_q[29] ^ lfsr_q[30] ^ lfsr_q[31] ^ data_in[0] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[11] ^ data_in[12] ^ data_in[15] ^ data_in[18] ^ data_in[19] ^ data_in[20] ^ data_in[24] ^ data_in[25] ^ data_in[29] ^ data_in[30] ^ data_in[31];

      lfsr_c[5] = lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[10] ^ lfsr_q[13] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[24] ^ lfsr_q[28] ^ lfsr_q[29] ^ data_in[0] ^ data_in[1] ^ data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^ data_in[10] ^ data_in[13] ^ data_in[19] ^ data_in[20] ^ data_in[21] ^ data_in[24] ^ data_in[28] ^ data_in[29];

      lfsr_c[6] = lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[11] ^ lfsr_q[14] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22] ^ lfsr_q[25] ^ lfsr_q[29] ^ lfsr_q[30] ^ data_in[1] ^ data_in[2] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[11] ^ data_in[14] ^ data_in[20] ^ data_in[21] ^ data_in[22] ^ data_in[25] ^ data_in[29] ^ data_in[30];

      lfsr_c[7] = lfsr_q[0] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[5] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[10] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[21] ^ lfsr_q[22] ^ lfsr_q[23] ^ lfsr_q[24] ^ lfsr_q[25] ^ lfsr_q[28] ^ lfsr_q[29] ^ data_in[0] ^ data_in[2] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[8] ^ data_in[10] ^ data_in[15] ^ data_in[16] ^ data_in[21] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[28] ^ data_in[29];

      lfsr_c[8] = lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[8] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[17] ^ lfsr_q[22] ^ lfsr_q[23] ^ lfsr_q[28] ^ lfsr_q[31] ^ data_in[0] ^ data_in[1] ^ data_in[3] ^ data_in[4] ^ data_in[8] ^ data_in[10] ^ data_in[11] ^ data_in[12] ^ data_in[17] ^ data_in[22] ^ data_in[23] ^ data_in[28] ^ data_in[31];

      lfsr_c[9] = lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[9] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[18] ^ lfsr_q[23] ^ lfsr_q[24] ^ lfsr_q[29] ^ data_in[1] ^ data_in[2] ^ data_in[4] ^ data_in[5] ^ data_in[9] ^ data_in[11] ^ data_in[12] ^ data_in[13] ^ data_in[18] ^ data_in[23] ^ data_in[24] ^ data_in[29];

      lfsr_c[10] = lfsr_q[0] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[5] ^ lfsr_q[9] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[19] ^ lfsr_q[26] ^ lfsr_q[28] ^ lfsr_q[29] ^ lfsr_q[31] ^ data_in[0] ^ data_in[2] ^ data_in[3] ^ data_in[5] ^ data_in[9] ^ data_in[13] ^ data_in[14] ^ data_in[16] ^ data_in[19] ^ data_in[26] ^ data_in[28] ^ data_in[29] ^ data_in[31];

      lfsr_c[11] = lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[9] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[20] ^ lfsr_q[24] ^ lfsr_q[25] ^ lfsr_q[26] ^ lfsr_q[27] ^ lfsr_q[28] ^ lfsr_q[31] ^ data_in[0] ^ data_in[1] ^ data_in[3] ^ data_in[4] ^ data_in[9] ^ data_in[12] ^ data_in[14] ^ data_in[15] ^ data_in[16] ^ data_in[17] ^ data_in[20] ^ data_in[24] ^ data_in[25] ^ data_in[26] ^ data_in[27] ^ data_in[28] ^ data_in[31];

      lfsr_c[12] = lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[9] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[21] ^ lfsr_q[24] ^ lfsr_q[27] ^ lfsr_q[30] ^ lfsr_q[31] ^ data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[9] ^ data_in[12] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[18] ^ data_in[21] ^ data_in[24] ^ data_in[27] ^ data_in[30] ^ data_in[31];

      lfsr_c[13] = lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[10] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[22] ^ lfsr_q[25] ^ lfsr_q[28] ^ lfsr_q[31] ^ data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^ data_in[10] ^ data_in[13] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[19] ^ data_in[22] ^ data_in[25] ^ data_in[28] ^ data_in[31];

      lfsr_c[14] = lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[11] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[23] ^ lfsr_q[26] ^ lfsr_q[29] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[11] ^ data_in[14] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[20] ^ data_in[23] ^ data_in[26] ^ data_in[29];

      lfsr_c[15] = lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[12] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[24] ^ lfsr_q[27] ^ lfsr_q[30] ^ data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[12] ^ data_in[15] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[21] ^ data_in[24] ^ data_in[27] ^ data_in[30];

      lfsr_c[16] = lfsr_q[0] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[8] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[21] ^ lfsr_q[22] ^ lfsr_q[24] ^ lfsr_q[26] ^ lfsr_q[29] ^ lfsr_q[30] ^ data_in[0] ^ data_in[4] ^ data_in[5] ^ data_in[8] ^ data_in[12] ^ data_in[13] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[29] ^ data_in[30];

      lfsr_c[17] = lfsr_q[1] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[9] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[22] ^ lfsr_q[23] ^ lfsr_q[25] ^ lfsr_q[27] ^ lfsr_q[30] ^ lfsr_q[31] ^ data_in[1] ^ data_in[5] ^ data_in[6] ^ data_in[9] ^ data_in[13] ^ data_in[14] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[30] ^ data_in[31];

      lfsr_c[18] = lfsr_q[2] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[10] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[19] ^ lfsr_q[21] ^ lfsr_q[23] ^ lfsr_q[24] ^ lfsr_q[26] ^ lfsr_q[28] ^ lfsr_q[31] ^ data_in[2] ^ data_in[6] ^ data_in[7] ^ data_in[10] ^ data_in[14] ^ data_in[15] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[31];

      lfsr_c[19] = lfsr_q[3] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[11] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[20] ^ lfsr_q[22] ^ lfsr_q[24] ^ lfsr_q[25] ^ lfsr_q[27] ^ lfsr_q[29] ^ data_in[3] ^ data_in[7] ^ data_in[8] ^ data_in[11] ^ data_in[15] ^ data_in[16] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[25] ^ data_in[27] ^ data_in[29];

      lfsr_c[20] = lfsr_q[4] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[12] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[21] ^ lfsr_q[23] ^ lfsr_q[25] ^ lfsr_q[26] ^ lfsr_q[28] ^ lfsr_q[30] ^ data_in[4] ^ data_in[8] ^ data_in[9] ^ data_in[12] ^ data_in[16] ^ data_in[17] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[26] ^ data_in[28] ^ data_in[30];

      lfsr_c[21] = lfsr_q[5] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[13] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[22] ^ lfsr_q[24] ^ lfsr_q[26] ^ lfsr_q[27] ^ lfsr_q[29] ^ lfsr_q[31] ^ data_in[5] ^ data_in[9] ^ data_in[10] ^ data_in[13] ^ data_in[17] ^ data_in[18] ^ data_in[22] ^ data_in[24] ^ data_in[26] ^ data_in[27] ^ data_in[29] ^ data_in[31];

      lfsr_c[22] = lfsr_q[0] ^ lfsr_q[9] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[23] ^ lfsr_q[24] ^ lfsr_q[26] ^ lfsr_q[27] ^ lfsr_q[29] ^ lfsr_q[31] ^ data_in[0] ^ data_in[9] ^ data_in[11] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[19] ^ data_in[23] ^ data_in[24] ^ data_in[26] ^ data_in[27] ^ data_in[29] ^ data_in[31];

      lfsr_c[23] = lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[6] ^ lfsr_q[9] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[26] ^ lfsr_q[27] ^ lfsr_q[29] ^ lfsr_q[31] ^ data_in[0] ^ data_in[1] ^ data_in[6] ^ data_in[9] ^ data_in[13] ^ data_in[15] ^ data_in[16] ^ data_in[17] ^ data_in[19] ^ data_in[20] ^ data_in[26] ^ data_in[27] ^ data_in[29] ^ data_in[31];

      lfsr_c[24] = lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[7] ^ lfsr_q[10] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[27] ^ lfsr_q[28] ^ lfsr_q[30] ^ data_in[1] ^ data_in[2] ^ data_in[7] ^ data_in[10] ^ data_in[14] ^ data_in[16] ^ data_in[17] ^ data_in[18] ^ data_in[20] ^ data_in[21] ^ data_in[27] ^ data_in[28] ^ data_in[30];

      lfsr_c[25] = lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[8] ^ lfsr_q[11] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[21] ^ lfsr_q[22] ^ lfsr_q[28] ^ lfsr_q[29] ^ lfsr_q[31] ^ data_in[2] ^ data_in[3] ^ data_in[8] ^ data_in[11] ^ data_in[15] ^ data_in[17] ^ data_in[18] ^ data_in[19] ^ data_in[21] ^ data_in[22] ^ data_in[28] ^ data_in[29] ^ data_in[31];

      lfsr_c[26] = lfsr_q[0] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[6] ^ lfsr_q[10] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[22] ^ lfsr_q[23] ^ lfsr_q[24] ^ lfsr_q[25] ^ lfsr_q[26] ^ lfsr_q[28] ^ lfsr_q[31] ^ data_in[0] ^ data_in[3] ^ data_in[4] ^ data_in[6] ^ data_in[10] ^ data_in[18] ^ data_in[19] ^ data_in[20] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[26] ^ data_in[28] ^ data_in[31];

      lfsr_c[27] = lfsr_q[1] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[7] ^ lfsr_q[11] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[23] ^ lfsr_q[24] ^ lfsr_q[25] ^ lfsr_q[26] ^ lfsr_q[27] ^ lfsr_q[29] ^ data_in[1] ^ data_in[4] ^ data_in[5] ^ data_in[7] ^ data_in[11] ^ data_in[19] ^ data_in[20] ^ data_in[21] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[26] ^ data_in[27] ^ data_in[29];

      lfsr_c[28] = lfsr_q[2] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[8] ^ lfsr_q[12] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22] ^ lfsr_q[24] ^ lfsr_q[25] ^ lfsr_q[26] ^ lfsr_q[27] ^ lfsr_q[28] ^ lfsr_q[30] ^ data_in[2] ^ data_in[5] ^ data_in[6] ^ data_in[8] ^ data_in[12] ^ data_in[20] ^ data_in[21] ^ data_in[22] ^ data_in[24] ^ data_in[25] ^ data_in[26] ^ data_in[27] ^ data_in[28] ^ data_in[30];

      lfsr_c[29] = lfsr_q[3] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[9] ^ lfsr_q[13] ^ lfsr_q[21] ^ lfsr_q[22] ^ lfsr_q[23] ^ lfsr_q[25] ^ lfsr_q[26] ^ lfsr_q[27] ^ lfsr_q[28] ^ lfsr_q[29] ^ lfsr_q[31] ^ data_in[3] ^ data_in[6] ^ data_in[7] ^ data_in[9] ^ data_in[13] ^ data_in[21] ^ data_in[22] ^ data_in[23] ^ data_in[25] ^ data_in[26] ^ data_in[27] ^ data_in[28] ^ data_in[29] ^ data_in[31];

      lfsr_c[30] = lfsr_q[4] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[10] ^ lfsr_q[14] ^ lfsr_q[22] ^ lfsr_q[23] ^ lfsr_q[24] ^ lfsr_q[26] ^ lfsr_q[27] ^ lfsr_q[28] ^ lfsr_q[29] ^ lfsr_q[30] ^ data_in[4] ^ data_in[7] ^ data_in[8] ^ data_in[10] ^ data_in[14] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[26] ^ data_in[27] ^ data_in[28] ^ data_in[29] ^ data_in[30];

      lfsr_c[31] = lfsr_q[5] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[11] ^ lfsr_q[15] ^ lfsr_q[23] ^ lfsr_q[24] ^ lfsr_q[25] ^ lfsr_q[27] ^ lfsr_q[28] ^ lfsr_q[29] ^ lfsr_q[30] ^ lfsr_q[31] ^ data_in[5] ^ data_in[8] ^ data_in[9] ^ data_in[11] ^ data_in[15] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[27] ^ data_in[28] ^ data_in[29] ^ data_in[30] ^ data_in[31];

      lfsr_q = lfsr_c;
  end //}

  compute_crc32 = lfsr_q;

endfunction : compute_crc32


function void srio_trans::calcCRC32();

  logic [31:0] temp_data;
  int size,q_size;
 
  size = bytestream.size();

  for(int i = 0;i<size;i=i+4)
  begin //{
       temp_data = 32'h0;
       temp_data ={bytestream[i],bytestream[i+1],bytestream[i+2],bytestream[i+3]};
       gen3_data_q.push_back(temp_data);
  end //}

  q_size = gen3_data_q.size();

  crc32 = compute_crc32(0,q_size,32'hFFFF_FFFF);
  if(pl_err_kind ==  LINK_CRC_ERR)
  begin //{
    crc32 = ~crc32;
  end //}

endfunction : calcCRC32

function void srio_trans::calcCRC();

  // calculate the first CRC and store it.  also set secondCRC to zero (if necessary)
  this.setCRC(this.computecrc16(0, this.findearlycrc(), 16'hFFFF) << 16);
  // if necessary, calculate the second crc, starting from the firstCRC
  if (this.findfinalcrc())
  begin
   this.setCRC(this.getCRC() |
               this.computecrc16(this.findearlycrc(), this.findfinalcrc(), this.getCRC() >> 16));
  end
endfunction : calcCRC

function void srio_trans::setCRC(int  _CRC);
  int firstIdx;
  int secondIdx;
  firstIdx = this.findearlycrc();
  secondIdx = this.findfinalcrc();
   
  early_crc = _CRC[31:16];
  final_crc = _CRC[15:0];
  if(pl_err_kind ==  EARLY_CRC_ERR && secondIdx > 0)
  begin //{
    early_crc = ~early_crc;
    _CRC[31:16] = $random;
  end //}
  else if(pl_err_kind ==  FINAL_CRC_ERR && secondIdx == 0)
  begin //{
    early_crc = ~early_crc;
   _CRC[31:16] = ~_CRC[31:16];
  end //}
  else if(pl_err_kind ==  FINAL_CRC_ERR && secondIdx > 0)
  begin //{
    final_crc = ~final_crc;
   _CRC[15:0] = ~_CRC[15:0];
  end //}
  if (secondIdx)
  begin
    for(int i=(total_pkt_bytes-pad-4);i<firstIdx;i--)
    begin
      this.bytestream[i+1] = this.bytestream[i]; 
      this.bytestream[i+2] = this.bytestream[i+1]; 
    end
    this.bytestream[firstIdx] = (_CRC >> 24) & 8'hFF;
    this.bytestream[firstIdx+1] = (_CRC >> 16) & 8'hFF;
    this.bytestream[secondIdx] = (_CRC >> 8) & 8'hFF;
    this.bytestream[secondIdx+1]= _CRC & 8'hFF;
  end
  else
  begin
   this.bytestream[firstIdx] = (_CRC >> 24) & 8'hFF;
   this.bytestream[firstIdx+1] = (_CRC >> 16) & 8'hFF;
  end

endfunction : setCRC

function logic[15:0] srio_trans::computecrc16(int start, int finish, logic[15:0] _runningCRC);
  // the loop that does a single, 16-bit CRC computation.  Used
  // twice, once for firstCRC, then for secondCRC
  int i;
  int j;
  logic[15:0] runningCRC=_runningCRC;
  logic[7:0] currByte;

  // calculate the CRC
  for (i=start; i < finish; i++)
  begin
    currByte = this.bytestream[i];
    // mask out the first 6 bits of byte 0
    if (!i)
      currByte = currByte & 8'h03;
    runningCRC ^= currByte << 8;
    for (j=0; j < 8; j++)
    begin
      if (runningCRC[15])
        runningCRC = (runningCRC << 1) ^ 16'h1021;
      else
        runningCRC <<= 1;
      runningCRC &= 16'hFFFF;
    end
  end
  computecrc16 = runningCRC;
  
endfunction : computecrc16

function logic[31:0] srio_trans::getCRC();
  int firstIdx;
  int secondIdx;
  firstIdx = this.findearlycrc();
  secondIdx = this.findfinalcrc();
  if (secondIdx)
    getCRC = (this.bytestream[firstIdx] << 24) | (this.bytestream[firstIdx+1] << 16) |
      (this.bytestream[secondIdx] << 8) | this.bytestream[secondIdx+1];
  else
    getCRC = (this.bytestream[firstIdx] << 24) | (this.bytestream[firstIdx+1] << 16);
endfunction : getCRC

function int srio_trans::findearlycrc();
  if(this.total_pkt_bytes > (80 + pad + 2))
    findearlycrc = 80;
  else
    findearlycrc = this.total_pkt_bytes-pad-2;
endfunction : findearlycrc

function int srio_trans::findfinalcrc();
  if(this.total_pkt_bytes > 0 && this.total_pkt_bytes <= (80+ pad+2))
    findfinalcrc = 0;
  else 
    findfinalcrc = this.total_pkt_bytes-pad-2;
endfunction : findfinalcrc

////////////////////////////////////////////////////////////////////////////////
/// Name: gen_bytestream \n 
/// Description: Function to generate bytestream from packed bits \n
/// gen_bytestream
//////////////////////////////////////////////////////////////////////////////// 

function void srio_trans::gen_bytestream(int length);
  bit [0:7] byte_temp = 0;
  int count;
  bytestream = new[length];
  count = 0;

  for (int i=0; i<length; i=i+1)
  begin // {
    count = 0;
    for (int j=i*8; j< i*8+8; j=j+1)
    begin // {
      byte_temp[count] = packed_bitstream[j]; 
      count = count + 1;
    end // }
    bytestream[i] = byte_temp;
  end // }
endfunction : gen_bytestream

////////////////////////////////////////////////////////////////////////////////
/// Name: do_pack \n 
/// Description: do_pack function called by the pack methods to pack the \n
///              header and data payload into a packet \n
/// do_pack
//////////////////////////////////////////////////////////////////////////////// 

function void srio_trans::do_pack(uvm_packer packer);

  bit   [3:0] act_ftype;
  bit   [3:0] act_ttype;
  bit   [1:0] tt;
  int         byte_count;
  bit   [7:0] ttype_rdsize_wrsize_sts;
  bit   [7:0] source_tgtdest_id3;
  bit   [7:0] source_tgtdest_id2;
  bit   [7:0] source_tgtdest_id1;
  bit   [7:0] source_tgtdest_id0;
  bit   [7:0] tid;
  bit   [7:0] config_offset2;
  bit   [7:0] config_offset1;
  bit   [7:0] config_offset0;
  int         count;
  logic[15:0] crc;
  int         stream_len;
  bit         rand_var;

  trans_ftype        = srio_trans_ftype'(this.ftype);
  trans_ttype1       = srio_trans_ttype1'(this.ttype);
  trans_ttype2       = srio_trans_ttype2'(this.ttype);
  trans_ttype5       = srio_trans_ttype5'(this.ttype);
  trans_ttype8       = srio_trans_ttype8'(this.ttype);
  trans_ttype13      = srio_trans_ttype13'(this.ttype);
  
  if ((tl_err_kind != UNSUPPORTED_TT_ERR) && (tl_err_kind != RESERVED_TT_ERR))
  begin // {
    if      (env_config.srio_dev_id_size == SRIO_DEVID_32)  tt = 2'b10;	 
    else if (env_config.srio_dev_id_size == SRIO_DEVID_16)  tt = 2'b01;	 
    else                                                    tt = 2'b00;	 
    this.tt = tt;
  end // }
  else if (tl_err_kind == RESERVED_TT_ERR)
  begin // {
    `uvm_info(get_full_name(), ("RESERVED_TT_ERR is set"),UVM_LOW);
    tt = 2'b11;
    this.tt = tt;
  end // }
  else if (tl_err_kind == UNSUPPORTED_TT_ERR)
  begin // {
    rand_var = $urandom;
    if      (env_config.srio_dev_id_size == SRIO_DEVID_32)  tt = {1'b0,     rand_var};	 
    else if (env_config.srio_dev_id_size == SRIO_DEVID_16)  tt = {rand_var, 1'b0};	 
    else                                                    tt = {rand_var, !rand_var};	 
    this.tt = tt;
    `uvm_info(get_full_name(), ("UNSUPPORTED_TT_ERR is set"),UVM_LOW);
  end // }

  `uvm_info(""," ********* Packing of Packet Header Fields *******",UVM_LOW);
  super.do_pack(packer);

  // Log Messages
  // ---------------------------------------------------------------------------
  act_ftype = this.ftype;
  act_ttype = this.ttype;
  if ((this.ftype == 0) || (this.ftype == 3) || (this.ftype == 4) || 
      (this.ftype == 12)|| (this.ftype == 14)|| (this.ftype == 15)) 
  begin // {
   `uvm_warning("SRIO_TRANS: pack_byte:",$sformatf("Unsupported FTYPE: %h; Packing is done for NWRITE",this.ftype));
   this.ftype = 5;
   this.ttype = 4;
  end // }
  else
  begin // {
    if(((this.ftype == 1)  &&  (this.ttype > 2))                                                 || 
       ((this.ftype == 5)  && ((this.ttype != 0)  && (this.ttype != 1)   && (this.ttype != 4) &&   
                               (this.ttype != 5)  && (this.ttype != 12)) && 
                               (this.ttype != 13) && (this.ttype != 14))                         ||
       ((this.ftype == 8)  &&  (this.ttype > 4))                                                 || 
       ((this.ftype == 13) &&  (this.ttype != 0)  && (this.ttype != 1)   && (this.ttype != 8))) 
    begin // {
     `uvm_warning("SRIO_TRANS: pack_byte:",$sformatf("%s Unsupported TTYPE: %h; Packing is done for TTYPE_0",
     trans_ftype.name, this.ttype));
     this.ttype = 0;
    end // }
    else  
    begin // {
      `uvm_info("SRIO_TRANS: pack_byte:",$sformatf("%s Packet Generation", (
    (this.ftype == 1) ? trans_ttype1.name : (
    (this.ftype == 2) ? trans_ttype2.name : (
    (this.ftype == 5) ? trans_ttype5.name : (
    (this.ftype == 6) ? "SWRITE"    : (
    (this.ftype == 7) ? "LFC"       : (
    (this.ftype == 8) ? trans_ttype8.name : (
    (this.ftype == 9) ? ((this.xh == 1) ? "DS TM" : "DS") : (
    (this.ftype == 10)? "DOOR BELL" : (
    (this.ftype == 11)? "DATA MSG"  : (
    (this.ftype == 13)? trans_ttype13.name: "UNRECOGNIZED PKT"))))))))))), UVM_LOW);
    end // }
  end

  if(env_config.crf_en==NOT_SUPPTD)
   this.crf=0;
  // ACK_ID, VC, CRF
  // ---------------------------------------------------------------------------
  if(env_config.srio_mode == SRIO_GEN13 || (env_config.idle_detected && ~env_config.idle_selected))
  begin //{
    packer.pack_field_int(this.ackid[7:11], 5);
    packer.pack_field_int(2'b00           , 2);
    packer.pack_field_int(this.crf        , 1);
  end //}
  else if(env_config.srio_mode == SRIO_GEN21 || env_config.srio_mode == SRIO_GEN22 || env_config.srio_mode == SRIO_GEN30)  
  begin // 
    packer.pack_field_int(this.ackid[6:11], 6);
    packer.pack_field_int(this.vc         , 1);
    packer.pack_field_int(this.crf        , 1);
  end //}
  
  // PRIORITY, TT, FTYPE
  // ---------------------------------------------------------------------------
  packer.pack_field_int(this.prio         , 2);
  packer.pack_field_int(this.tt           , 2);
  packer.pack_field_int(act_ftype         , 4);

  // DESTINATION_ID, SOURCE_ID/TARGET_DESTINATIN_ID
  // ---------------------------------------------------------------------------
  if(this.ftype !='h7) 
  begin //{
    source_tgtdest_id3 = this.SourceID[31:24]; // Source ID
    source_tgtdest_id2 = this.SourceID[23:16];
    source_tgtdest_id1 = this.SourceID[15:8];
    source_tgtdest_id0 = this.SourceID[7:0];
  end // }
  else
  begin //{
    source_tgtdest_id3 = this.tgtdestID[31:24]; 
    source_tgtdest_id2 = this.tgtdestID[23:16]; 
    source_tgtdest_id1 = this.tgtdestID[15:8];
    source_tgtdest_id0 = this.tgtdestID[7:0];
  end // }

  if(env_config.srio_dev_id_size== SRIO_DEVID_32) 
  begin //{
    packer.pack_field_int(this.DestinationID[31:24],8);
    packer.pack_field_int(this.DestinationID[23:16],8);
    packer.pack_field_int(this.DestinationID[15:8] ,8);
    packer.pack_field_int(this.DestinationID[7:0]  ,8);
    packer.pack_field_int(source_tgtdest_id3       ,8);
    packer.pack_field_int(source_tgtdest_id2       ,8);
    packer.pack_field_int(source_tgtdest_id1       ,8);
    packer.pack_field_int(source_tgtdest_id0       ,8);
  end //}
  else if(env_config.srio_dev_id_size== SRIO_DEVID_16) 
  begin //{
    packer.pack_field_int(this.DestinationID[15:8] ,8);
    packer.pack_field_int(this.DestinationID[7:0]  ,8);
    packer.pack_field_int(source_tgtdest_id1       ,8);
    packer.pack_field_int(source_tgtdest_id0       ,8);
  end //}
  else  
  begin //{
    if (env_config.srio_dev_id_size != SRIO_DEVID_8) 
    begin // {
      `uvm_error(get_full_name(), "Unsupported Dev_ID is configured; Packing is done for SRIO_DEVID_8");
    end // }
    packer.pack_field_int(this.DestinationID[7:0]  ,8);
    packer.pack_field_int(source_tgtdest_id0       ,8);
  end //}

  // TTYPE, RD_SIZE/WR_SIZE/STATUS/MSG_LEN_SSIZE 
  // ---------------------------------------------------------------------------
  if ((this.ftype == 1) ||  
      (this.ftype == 2) ||  
     ((this.ftype == 8) && (this.ttype == 0))) // {
    ttype_rdsize_wrsize_sts = {act_ttype,this.rdsize};

  else if ((this.ftype == 5) ||  
     ((this.ftype == 8) && (this.ttype == 1)) ||  
     ((this.ftype == 8) && (this.ttype == 4))) // {
    ttype_rdsize_wrsize_sts = {act_ttype,this.wrsize};

  else if (((this.ftype == 8) && (this.ttype == 2))  ||  
      ((this.ftype == 8) && (this.ttype == 3)) || 
       (this.ftype == 13)) 
    ttype_rdsize_wrsize_sts = {act_ttype,this.trans_status};

  else if (this.ftype == 10) // DB  
    ttype_rdsize_wrsize_sts = {8'b0};

  else if (this.ftype == 11) // Data Msg  
    ttype_rdsize_wrsize_sts = {this.msg_len,this.ssize};

  if ((this.ftype == 1)  ||   // rd_size 
      (this.ftype == 2)  ||  
      (this.ftype == 8)  ||
      (this.ftype == 5)  || 
      (this.ftype == 10) ||
      (this.ftype == 11) ||
      (this.ftype == 13))  
  begin //{
    packer.pack_field_int(ttype_rdsize_wrsize_sts, 8);
  end //}

  // SrcTID / Target ID Info  
  // ---------------------------------------------------------------------------
  if (((this.ftype == 8) && ((this.ttype == 2) || (this.ttype == 3))) || 
       (this.ftype == 13)) // Response packet 
    tid = {this.targetID_Info};
  else if ((this.ftype == 8) && (this.ttype == 4))
    tid = {8'b0}; // SrcTID is reserved for port write
  else 
    tid = {this.SrcTID};   

  if ((this.ftype == 1)   || 
      (this.ftype == 2)   ||
      (this.ftype == 5)   ||
      (this.ftype == 8)   ||
      (this.ftype == 10)  ||
      (this.ftype == 13)) // Response packet 
  begin //{
    packer.pack_field_int(tid, 8);
  end //}

  if (this.ftype == 1) // Type1 - GSM  
  begin //{  
    packer.pack_field_int(this.sec_domain ,4);
    packer.pack_field_int(this.SecID      ,4);
    packer.pack_field_int(this.SecTID     ,8);
  end //}

  // EXTENDED ADDRESS, ADDRESS
  // ---------------------------------------------------------------------------
  if((this.ftype == 1) ||    
     (this.ftype == 2) ||  
     (this.ftype == 5) ||  
     (this.ftype == 6))   
  begin //{ 
    if (this.ftype == 6)
      this.wdptr = 0;
    if(env_config.en_ext_addr_support == 1) 
    begin // {
      if(env_config.srio_addr_mode == SRIO_ADDR_66) 
      begin //{
        packer.pack_field_int(this.ext_address[31:24], 8);
        packer.pack_field_int(this.ext_address[23:16], 8);
        packer.pack_field_int(this.ext_address[15:8] , 8);
        packer.pack_field_int(this.ext_address[7:0]  , 8);
      end //}
      else if (env_config.srio_addr_mode == SRIO_ADDR_50) 
      begin //{
        packer.pack_field_int(this.ext_address[15:8], 8);
        packer.pack_field_int(this.ext_address[7:0] , 8);
      end //}
    end //}
    else
    begin // { 
      if ((env_config.srio_addr_mode == SRIO_ADDR_66) ||  
          (env_config.srio_addr_mode == SRIO_ADDR_50))
      begin // {  
        `uvm_error(get_full_name()," ERROR: ***** Extended Address Feature is not Enabled ****** ");
      end // }
    end // }
    packer.pack_field_int(this.address[28:21] , 8);
    packer.pack_field_int(this.address[20:13] , 8);
    packer.pack_field_int(this.address[12:5]  , 8);
    packer.pack_field_int(this.address[4:0]   , 5);
    packer.pack_field_int(this.wdptr          , 1);
    packer.pack_field_int(this.xamsbs         , 2);
  end //}

  // Other Fields
  // ---------------------------------------------------------------------------
  case(this.ftype) // {
    4'h7: 
    begin //{
      packer.pack_field_int(this.xon_xoff , 1);
      packer.pack_field_int(this.FAM      , 3);
      packer.pack_field_int(4'h0          , 4);
      packer.pack_field_int(this.flowID   , 7);
      packer.pack_field_int(this.SOC      , 1);
    end //}

    4'h8: 
    begin //{
      if ((this.ttype == 2) || (this.ttype == 3) || (this.ttype == 4))
      begin // {
        config_offset2 = 0;
        config_offset1 = 0;
        config_offset0 = 0;
        if (this.ttype == 4)
        begin // {
          config_offset0 = {5'b0,this.wdptr,2'b0};
        end // }
      end // }
      else
      begin // {
        config_offset2 = {this.config_offset[20:13]};
        config_offset1 = {this.config_offset[12:5]}; 
        config_offset0 = {this.config_offset[4:0],this.wdptr,2'b0};
      end // }

      packer.pack_field_int(hop_count      , 8);
      packer.pack_field_int(config_offset2 , 8);
      packer.pack_field_int(config_offset1 , 8);
      packer.pack_field_int(config_offset0 , 8);
    end //}

    4'h9: 
    begin //{

      if (this.xh == 0) // If not DS TM packet
      begin // {
        this.xtype = 3'h0;
      end //}
      else 
      begin // {
        this.S = 1'h0; this.E = 1'h0;  this.O = 1'h0; this.P = 1'h0;
      end //}
 
      packer.pack_field_int(this.cos  , 8);
      packer.pack_field_int(this.S    , 1);
      packer.pack_field_int(this.E    , 1);
      packer.pack_field_int(this.xtype, 3);
      packer.pack_field_int(this.xh   , 1);
      packer.pack_field_int(this.O    , 1);
      packer.pack_field_int(this.P    , 1);

      if ((this.S) || (this.xh))
      begin
        packer.pack_field_int(streamID[15:8], 8);
        packer.pack_field_int(streamID[7:0] , 8);
      end
      else if(this.S == 0 && this.E == 1)
      begin
        packer.pack_field_int(pdulength[15:8], 8);
        packer.pack_field_int(pdulength[7:0] , 8);
      end

      if (this.xh) // DS TM packet
      begin // {
        packer.pack_field_int(this.TMOP       , 4);
        packer.pack_field_int(1'b0            , 1);
        packer.pack_field_int(this.wild_card  , 3);
        packer.pack_field_int(this.mask       , 8);
        packer.pack_field_int(this.parameter1 , 8);
        packer.pack_field_int(this.parameter2 , 8);
      end //}
    end //}

    4'hA: 
    begin //{
      packer.pack_field_int(this.info_msb   ,8);
      packer.pack_field_int(this.info_lsb   ,8);
    end //}

    4'hB: 
    begin //{
      packer.pack_field_int(this.letter       , 2);
      packer.pack_field_int(this.mbox         , 2);
      packer.pack_field_int(this.msgseg_xmbox , 4);
    end //}
  endcase //}

  this.total_hdr_byte = packer.count/8;
  this.total_pld_byte = payload.size();
  this.total_pkt_bytes = this.total_hdr_byte + this.total_pld_byte;

  if(this.total_pkt_bytes < 80)
  begin //{
    for(int i=0;i<this.total_pld_byte;i++)
    begin //{
      packer.pack_field_int(payload[i], 8);
    end //}

    packed_bitstream = packer.get_packed_bits();  
    stream_len = packer.count/8;
    gen_bytestream(stream_len);
 
    // Final CRC
    crc = this.computecrc16(0, this.total_pkt_bytes, 16'hFFFF);
    this.final_crc = crc; 
    if(pl_err_kind ==  FINAL_CRC_ERR)
    begin //{
      final_crc = ~final_crc;
      crc       = ~crc;
    end //}

    packer.pack_field_int(crc ,16);
    crc_bytes = 2;
  end //}
  else
  begin // {
    for(int i=0;i<(80-this.total_hdr_byte);i++)
    begin //{
      packer.pack_field_int(payload[i], 8);
    end //}

    packed_bitstream = packer.get_packed_bits();         
    stream_len = packer.count/8;
    gen_bytestream(stream_len);
    // Early CRC
    crc = this.computecrc16(0, 80, 16'hFFFF);
    this.early_crc = crc; 
    if(pl_err_kind ==  EARLY_CRC_ERR)
    begin //{
      this.early_crc = ~this.early_crc;
      crc       = ~crc;
    end //}
    packer.pack_field_int(crc, 16);

    for(int i=(80-this.total_hdr_byte); i<this.total_pld_byte;i++)
    begin //{
      packer.pack_field_int(payload[i], 8);
    end //}

    packed_bitstream = packer.get_packed_bits();         
    stream_len = packer.count/8;
    gen_bytestream(stream_len);
    // Final CRC
    crc = this.computecrc16(0, (this.total_pkt_bytes+2), 16'hFFFF);
    this.final_crc = crc; 
    if(pl_err_kind ==  FINAL_CRC_ERR)
    begin //{
      this.final_crc = ~this.final_crc;
      crc       = ~crc;
    end //}
    packer.pack_field_int(crc, 16);
    crc_bytes = 4;
  end //}

  this.total_pkt_bytes = this.total_hdr_byte + this.total_pld_byte + crc_bytes;

  if ((this.total_pkt_bytes%4) > 0)
  begin // {
    packer.pack_field_int(16'h0, 16);
    pad = 2;
  end //}
  else 
    pad = 0; 

  this.total_pkt_bytes = this.total_hdr_byte + this.total_pld_byte + crc_bytes + pad;

  if(env_config.srio_mode == SRIO_GEN30)
  begin //{
    packed_bitstream = packer.get_packed_bits();         
    stream_len = packer.count/8;
    gen_bytestream(stream_len);
    total_pkt_bytes += 4;

    calcCRC32();
    gen3_crc_bytes = 4; 
    packer.pack_field_int(crc32, 32);

    if((total_pkt_bytes%8) > 0)
      pad_gen3 = (8 - (total_pkt_bytes % 8));
    else
      pad_gen3 = 0;

    if(pad_gen3)
    begin //{   
      total_pkt_bytes += 4;
      packer.pack_field_int(32'h0, 32);
      gen3_pad_bytes = 4;
    end //}
  end //}

endfunction: do_pack

////////////////////////////////////////////////////////////////////////////////
/// Name: do_unpack \n 
/// Description: do_unpack function called by the unpack method to unpack the\n
///              header and data payload into a packet \n
/// do_unpack
//////////////////////////////////////////////////////////////////////////////// 

function void srio_trans::do_unpack(uvm_packer packer);
  logic [7:0] _byte [$];
  int         byte_count;
  int         rbit;    
  bit   [7:0] source_tgtdest_id3;
  bit   [7:0] source_tgtdest_id2;
  bit   [7:0] source_tgtdest_id1;
  bit   [7:0] source_tgtdest_id0;
  bit   [7:0] ttype_rdsize_wrsize_sts;
  bit   [7:0] tid;
  bit  [15:0] pad_bytes;
  int         ecrc_byte_count;
  int         x;
  int         y;

  byte_count  = 0;

  super.do_unpack(packer);  

  this.total_pkt_bytes = (packer.get_packed_size()/8);            
  
  // ACK_ID, VC, CRF
  // ---------------------------------------------------------------------------
  if(env_config.srio_mode == SRIO_GEN13 || (env_config.idle_detected && ~env_config.idle_selected))
  begin //{
    this.ackid[7:11] = packer.unpack_field_int(5); 
    rbit[0]          = packer.unpack_field_int(1); 
    this.vc          = packer.unpack_field_int(1); 
    this.crf         = packer.unpack_field_int(1); 
  end //}
  else if(env_config.srio_mode == SRIO_GEN21 || env_config.srio_mode == SRIO_GEN22 || env_config.srio_mode == SRIO_GEN30)  
  begin // 
    this.ackid[6:11] = packer.unpack_field_int(6); 
    this.vc          = packer.unpack_field_int(1); 
    this.crf         = packer.unpack_field_int(1); 
  end //}

  // GEN3 change for ackid
  if(env_config.srio_mode == SRIO_GEN30)  
  begin //                                                   
    this.ackid = {gen3_ackid_msb, 6'b00_0000} | {6'b00_0000, this.ackid[6:11]};
  end //}

  // PRIORITY, TT, FTYPE
  // ---------------------------------------------------------------------------
  this.prio   = packer.unpack_field_int(2);
  this.tt     = packer.unpack_field_int(2);
  this.ftype  = packer.unpack_field_int(4);

  // DESTINATION_ID, SOURCE_ID/TARGET_DESTINATIN_ID
  // ---------------------------------------------------------------------------
   
  if(env_config.srio_dev_id_size== SRIO_DEVID_32) 
  begin //{
    this.DestinationID[31:24]  = packer.unpack_field_int(8);
    this.DestinationID[23:16]  = packer.unpack_field_int(8);
    this.DestinationID[15:8]   = packer.unpack_field_int(8);
    this.DestinationID[7:0]    = packer.unpack_field_int(8);

    source_tgtdest_id3         = packer.unpack_field_int(8);
    source_tgtdest_id2         = packer.unpack_field_int(8);
    source_tgtdest_id1         = packer.unpack_field_int(8);
    source_tgtdest_id0         = packer.unpack_field_int(8);
  end //}
  else if(env_config.srio_dev_id_size== SRIO_DEVID_16) 
  begin //{
    this.DestinationID[15:8]   = packer.unpack_field_int(8);
    this.DestinationID[7:0]    = packer.unpack_field_int(8);
    source_tgtdest_id1         = packer.unpack_field_int(8);
    source_tgtdest_id0         = packer.unpack_field_int(8);
  end //}
  else  
  begin // {
    if (env_config.srio_dev_id_size != SRIO_DEVID_8) 
    begin // {
      `uvm_error(get_full_name(), "Unsupported Dev_ID is configured; Un-packing is done for SRIO_DEVID_8");
    end // }
    this.DestinationID[7:0]    = packer.unpack_field_int(8);
    source_tgtdest_id0         = packer.unpack_field_int(8);
  end //}

  if(this.ftype !='h7) 
  begin //{
    this.SourceID[31:24]       = source_tgtdest_id3; 
    this.SourceID[23:16]       = source_tgtdest_id2;
    this.SourceID[15:8]        = source_tgtdest_id1;
    this.SourceID[7:0]         = source_tgtdest_id0;
  end // }
  else
  begin //{
    this.tgtdestID[31:24]      = source_tgtdest_id3; 
    this.tgtdestID[23:16]      = source_tgtdest_id2;
    this.tgtdestID[15:8]       = source_tgtdest_id1;
    this.tgtdestID[7:0]        = source_tgtdest_id0;
  end // }

  // TTYPE, RD_SIZE/WR_SIZE/STATUS/MSG_LEN_SSIZE 
  // ---------------------------------------------------------------------------
  if ((this.ftype == 1)  ||       
      (this.ftype == 2)  ||  
      (this.ftype == 8)  ||
      (this.ftype == 5)  || 
      (this.ftype == 10) ||
      (this.ftype == 11) ||
      (this.ftype == 13))  
  begin //{
    ttype_rdsize_wrsize_sts = packer.unpack_field_int(8);
    {this.ttype, rbit[3:0]} = ttype_rdsize_wrsize_sts;
  end //}

  if ((this.ftype == 1) ||  
      (this.ftype == 2) ||  
     ((this.ftype == 8) && (this.ttype == 0))) // {
    {this.ttype,this.rdsize} = ttype_rdsize_wrsize_sts;

  else if ((this.ftype == 5) ||  
     ((this.ftype == 8) && (this.ttype == 1)) ||  
     ((this.ftype == 8) && (this.ttype == 4))) // {
    {this.ttype,this.wrsize} = ttype_rdsize_wrsize_sts;

  else if (((this.ftype == 8) && (this.ttype == 2))  ||  
      ((this.ftype == 8) && (this.ttype == 3)) || 
       (this.ftype == 13)) 
    {this.ttype,this.trans_status} = ttype_rdsize_wrsize_sts;

  else if (this.ftype == 11) // Data Msg  
    {this.msg_len,this.ssize} = ttype_rdsize_wrsize_sts;

  // SrcTID / Target ID Info  
  // ---------------------------------------------------------------------------
  if ((this.ftype == 1)   || 
      (this.ftype == 2)   ||
      (this.ftype == 5)   ||
      (this.ftype == 8)   ||
      (this.ftype == 10)  ||
      (this.ftype == 13)) // Response packet 
  begin //{
    tid = packer.unpack_field_int(8);
  end //}

  if (((this.ftype == 8) && ((this.ttype == 2) || (this.ttype == 3))) || 
       (this.ftype == 13)) // Response packet 
    this.targetID_Info = tid;
  else 
    this.SrcTID = tid;   

  if (this.ftype == 1) // Type1 - GSM  
  begin //{  
    this.sec_domain = packer.unpack_field_int(4);
    this.SecID      = packer.unpack_field_int(4);
    this.SecTID     = packer.unpack_field_int(8);
  end //}

  // EXTENDED ADDRESS, ADDRESS
  // ---------------------------------------------------------------------------
  if((this.ftype == 1) ||    
     (this.ftype == 2) ||  
     (this.ftype == 5) ||  
     (this.ftype == 6))   
  begin //{  
    if(env_config.en_ext_addr_support == 1) 
    begin // {
      if(env_config.srio_addr_mode == SRIO_ADDR_66) 
      begin //{
        this.ext_address[31:24] = packer.unpack_field_int(8);
        this.ext_address[23:16] = packer.unpack_field_int(8);
        this.ext_address[15:8]  = packer.unpack_field_int(8);
        this.ext_address[7:0]   = packer.unpack_field_int(8);
      end //}
      else if (env_config.srio_addr_mode == SRIO_ADDR_50) 
      begin //{
        this.ext_address[15:8]  = packer.unpack_field_int(8);
        this.ext_address[7:0]   = packer.unpack_field_int(8);
      end //}
    end //}
    else
    begin // { 
      if ((env_config.srio_addr_mode == SRIO_ADDR_66) ||  
          (env_config.srio_addr_mode == SRIO_ADDR_50))
      begin // {  
        `uvm_error(get_full_name()," ERROR: ***** Extended Address Feature is not Enabled ****** ");
      end // }
    end // }

    this.address[28:21] = packer.unpack_field_int(8);
    this.address[20:13] = packer.unpack_field_int(8);
    this.address[12:5]  = packer.unpack_field_int(8);
    this.address[4:0]   = packer.unpack_field_int(5);
    this.wdptr          = packer.unpack_field_int(1);
    this.xamsbs         = packer.unpack_field_int(2);
  end //}

  // Other Fields
  // ---------------------------------------------------------------------------
  case(this.ftype) // {
    4'h7: 
    begin //{
      this.xon_xoff  = packer.unpack_field_int(1);
      this.FAM       = packer.unpack_field_int(3);
      rbit[3:0]      = packer.unpack_field_int(4);
      this.flowID    = packer.unpack_field_int(7);
      this.SOC       = packer.unpack_field_int(1);
    end //}

    4'h8:  
    begin //{
      this.hop_count            = packer.unpack_field_int(8);
      this.config_offset[20:13] = packer.unpack_field_int(8);
      this.config_offset[12:5]  = packer.unpack_field_int(8);
      this.config_offset[4:0]   = packer.unpack_field_int(5);
      this.wdptr                = packer.unpack_field_int(1);
      rbit[1:0]                 = packer.unpack_field_int(2);
    end //}

    4'h9: 
    begin //{
      this.cos   = packer.unpack_field_int(8);
      this.S     = packer.unpack_field_int(1);
      this.E     = packer.unpack_field_int(1);
      this.xtype = packer.unpack_field_int(3);
      this.xh    = packer.unpack_field_int(1);
      this.O     = packer.unpack_field_int(1);
      this.P     = packer.unpack_field_int(1);

      if(this.S || this.xh)
      begin
        this.streamID[15:8] = packer.unpack_field_int(8); 
        this.streamID[7:0]  = packer.unpack_field_int(8);
      end
      else if((this.S == 0) && (this.E == 1))
      begin
        this.pdulength[15:8] = packer.unpack_field_int(8);  
        this.pdulength[7:0]  = packer.unpack_field_int(8);
      end

      if (this.xh) // DS TM packet
      begin // {
        this.TMOP       = packer.unpack_field_int(4);  
        rbit[0]         = packer.unpack_field_int(1);  
        this.wild_card  = packer.unpack_field_int(3);  

        this.mask       = packer.unpack_field_int(8);
        this.parameter1 = packer.unpack_field_int(8);
        this.parameter2 = packer.unpack_field_int(8);
      end //}
    end //}

    4'hA: 
    begin //{
      this.info_msb = packer.unpack_field_int(8);
      this.info_lsb = packer.unpack_field_int(8);
    end //}

    4'hB: 
    begin //{
      this.letter        = packer.unpack_field_int(2);
      this.mbox          = packer.unpack_field_int(2);
      this.msgseg_xmbox  = packer.unpack_field_int(4);
    end //}
  endcase //}

  this.total_hdr_byte = packer.count/8;

  ecrc_byte_count = ((this.total_pkt_bytes - 2) > 82) ? 2 : 0;
  if ((this.ftype != 9) || ((this.ftype == 9) && (this.E == 0)))
  begin // {
    if (((this.total_hdr_byte + ecrc_byte_count) % 4) != 0)
      pad = 0;
    else
      pad = 2;
  end // }
  else // DS End packet  
  begin // {
    x = this.total_pkt_bytes - (this.total_hdr_byte + ecrc_byte_count);
    y = (x / 2) % 2;   
    if (((y == 0) && (this.O == 0))  ||
        ((y != 0) && (this.O == 1)))
      pad = 2;
    else
      pad = 0;
  end // }

  if(ecrc_byte_count == 0)
  begin //{
    crc_bytes = 2;
    for(int i=this.total_hdr_byte;i<(this.total_pkt_bytes-2-pad);i++)
    begin //{
      payload.push_back(packer.unpack_field_int(8));
    end //}
  end //}
  else
  begin // {
    crc_bytes = 4;
    for(int i=this.total_hdr_byte;i<80;i++)
    begin //{
      payload.push_back(packer.unpack_field_int(8));
    end //}

    this.early_crc[0:7]  = packer.unpack_field_int(8); 
    this.early_crc[8:15] = packer.unpack_field_int(8); 

    for(int i=82; i<(this.total_pkt_bytes-2-pad);i++)
    begin //{
      payload.push_back(packer.unpack_field_int(8));
    end //}
  end //}

  this.total_pld_byte = payload.size();
 
  this.final_crc[0:7]    = packer.unpack_field_int(8);
  this.final_crc[8:15]   = packer.unpack_field_int(8);

  if (pad == 2)
  begin // {
    pad_bytes = packer.unpack_field_int(16);
  end // }

  trans_ftype        = srio_trans_ftype'(this.ftype);
  trans_ttype1       = srio_trans_ttype1'(this.ttype);
  trans_ttype2       = srio_trans_ttype2'(this.ttype);
  trans_ttype5       = srio_trans_ttype5'(this.ttype);
  trans_ttype8       = srio_trans_ttype8'(this.ttype);
  trans_ttype13      = srio_trans_ttype13'(this.ttype);

  // Log Messages
  // ---------------------------------------------------------------------------
  if ((this.ftype == 0) || (this.ftype == 3) || (this.ftype == 4) || 
      (this.ftype == 12)|| (this.ftype == 14)|| (this.ftype == 15)) 
  begin // {
   `uvm_error("SRIO_TRANS: unpack_byte:",$sformatf("Unsupported FTYPE: %h",this.ftype));
  end // }
  else
  begin // {
    if(((this.ftype == 1)  &&  (this.ttype > 2))                                                 || 
       ((this.ftype == 5)  && ((this.ttype != 0)  && (this.ttype != 1)   && (this.ttype != 4) &&   
                               (this.ttype != 5)  && (this.ttype != 12)) && 
                               (this.ttype != 13) && (this.ttype != 14))                         ||
       ((this.ftype == 8)  &&  (this.ttype > 4))                                                 || 
       ((this.ftype == 13) &&  (this.ttype != 0)  && (this.ttype != 1)   && (this.ttype != 8))) 
    begin // {
     `uvm_error("SRIO_TRANS: unpack_byte:",$sformatf("%s Unsupported TTYPE: %h",trans_ftype.name, this.ttype));
    end // }
    else  
    begin // {
      `uvm_info("SRIO_TRANS: unpack_byte:",$sformatf("%s Packet Generation", (
    (this.ftype == 1) ? trans_ttype1.name : (
    (this.ftype == 2) ? trans_ttype2.name : (
    (this.ftype == 5) ? trans_ttype5.name : (
    (this.ftype == 6) ? "SWRITE"    : (
    (this.ftype == 7) ? "LFC"       : (
    (this.ftype == 8) ? trans_ttype8.name : (
    (this.ftype == 9) ? ((this.xh == 1) ? "DS TM" : "DS") : (
    (this.ftype == 10)? "DOOR BELL" : (
    (this.ftype == 11)? "DATA MSG"  : (
    (this.ftype == 13)? trans_ttype13.name: "UNRECOGNIZED PKT"))))))))))), UVM_LOW);
    end // }
  end
endfunction: do_unpack

////////////////////////////////////////////////////////////////////////////////
/// Name: do_print \n 
/// Description: do_print function called by the print method to display the \n
///              packet contents i.e. header fields and data payload \n
/// do_print
//////////////////////////////////////////////////////////////////////////////// 

function void srio_trans::do_print(uvm_printer printer);
  int i = 0;
  int dpl_size;

  srio_trans_ttype1   trans_ttype1; 
  srio_trans_ttype2   trans_ttype2; 
  srio_trans_ttype5   trans_ttype5; 
  srio_trans_ttype8   trans_ttype8; 
  srio_trans_ttype13  trans_ttype13;

  trans_ttype1       = srio_trans_ttype1'(this.ttype);
  trans_ttype2       = srio_trans_ttype2'(this.ttype);
  trans_ttype5       = srio_trans_ttype5'(this.ttype);
  trans_ttype8       = srio_trans_ttype8'(this.ttype);
  trans_ttype13      = srio_trans_ttype13'(this.ttype);

            if (ftype == 1)
            begin // {
  `uvm_info("SRIO_TRANS", $sformatf("\n  **************************************************************** \n \
          %s  SRIO_TRANS_PACKET_DETAIL \n \
 ****************************************************************  \n \
  \t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t ftype      = %0h\t ttype      = %0h\t SrcID      = %0h\n\
  \t rdsize     = %0h\t SrcTID     = %0h\t sec_domain = %0h\n\
  \t SecID      = %0h\t SecTID     = %0h\t ext_addr   = %0h\n\
  \t xamsbs     = %0h\t wdptr      = %0h\t addr       = %0h\n\
  \t early_crc  = %0h\n\
  \t final_crc  = %0h\n", 
  trans_ttype1.name,   crf, vc, ackid,   prio, tt, DestinationID,
  ftype, ttype, SourceID, rdsize, SrcTID, sec_domain,   SecID, SecTID, ext_address,
  xamsbs, wdptr, address, early_crc, final_crc),UVM_LOW);
;
            end // }
  
            else if (ftype == 2)
            begin // {
  `uvm_info("SRIO_TRANS", $sformatf("\n  **************************************************************** \n \
          %s  SRIO_TRANS_PACKET_DETAIL \n \
 ****************************************************************  \n \
  \t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t ftype      = %0h\t ttype      = %0h\t SrcID      = %0h\n\
  \t rdsize     = %0h\t SrcTID     = %0h\n\
  \t ext_addr   = %0h\n\
  \t xamsbs     = %0h\t wdptr      = %0h\t addr       = %0h\n\
  \t early_crc  = %0h\n\
  \t final_crc  = %0h\n", 
  trans_ttype2.name,   crf, vc, ackid,    prio, tt, DestinationID,
  ftype, ttype, SourceID,   rdsize, SrcTID, ext_address,   xamsbs, wdptr, address, early_crc, final_crc),UVM_LOW);
            end // }
  
            else if (ftype == 5)
            begin // {
  `uvm_info("SRIO_TRANS", $sformatf("\n  **************************************************************** \n \
          %s  SRIO_TRANS_PACKET_DETAIL \n \
 ****************************************************************  \n \
  \t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t ftype      = %0h\t ttype      = %0h\t SrcID      = %0h\n\
  \t wrsize     = %0h\t SrcTID     = %0h\n\
  \t ext_addr   = %0h\n\
  \t xamsbs     = %0h\t wdptr      = %0h\t addr       = %0h\n\
  \t early_crc  = %0h\n\
  \t final_crc  = %0h\n", 
  trans_ttype5.name,  crf, vc, ackid,   prio, tt, DestinationID,  ftype, ttype, SourceID,
  wrsize, SrcTID, ext_address,  xamsbs, wdptr, address, early_crc, final_crc),UVM_LOW);
            end // }
  
            else if (ftype == 6)
            begin // {
  `uvm_info("SRIO_TRANS", $sformatf("\n  **************************************************************** \n \
          SWRITE SRIO_TRANS_PACKET_DETAIL \n \
 ****************************************************************  \n \
  \t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t ftype      = %0h\t ttype      = %0h\t ext_addr   = %0h\n\
  \t xamsbs     = %0h\t SrcID      = %0h\t addr       = %0h\n\
  \t early_crc  = %0h\n\
  \t final_crc  = %0h",
  crf, vc,   ackid,   prio, tt, DestinationID,  ftype, ttype,   ext_address,xamsbs, 
  SourceID, address, early_crc, final_crc),UVM_LOW);
            end // }
  
            else if (ftype == 7)
            begin // {
  `uvm_info("SRIO_TRANS", $sformatf("\n  **************************************************************** \n \
          LFC SRIO_TRANS_PACKET_DETAIL \n \
 ****************************************************************  \n \
  \t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t ftype      = %0h\t xon_xoff   = %0h\t tgtdestID  = %0h\n\
  \t FAM        = %0h\t flowID     = %0h\t SOC        = %0h\n\
  \t early_crc  = %0h\n\
  \t final_crc  = %0h\n", 
  crf, vc, ackid,   prio, tt, DestinationID,  ftype, xon_xoff,   tgtdestID, FAM, flowID,
  SOC, early_crc, final_crc),UVM_LOW);
            end // }
  
  
            else if ((ftype == 8) && (ttype == 0))
            begin // {
  `uvm_info("SRIO_TRANS", $sformatf("\n  **************************************************************** \n \
          %s SRIO_TRANS_PACKET_DETAIL \n \
 ****************************************************************  \n \
  \t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t ftype      = %0h\t ttype      = %0h\t SrcID      = %0h\n\
  \t rdsize     = %0h\t SrcTID     = %0h\t hop_count  = %0h\n\
  \t cfg_off    = %0h\t wdptr      = %0h\n\
  \t early_crc  = %0h\n\
  \t final_crc  = %0h\n", 
  trans_ttype8.name,   crf, vc, ackid,    prio, tt, DestinationID,   ftype, ttype, SourceID,
  rdsize, SrcTID,   hop_count, config_offset,   wdptr, early_crc, final_crc),UVM_LOW);
            end // }
  
            else if ((ftype == 8) && 
                    ((ttype == 1) || (ttype == 4)))
            begin // {
  `uvm_info("SRIO_TRANS", $sformatf("\n  **************************************************************** \n \
          %s SRIO_TRANS_PACKET_DETAIL \n \
 ****************************************************************  \n \
  \t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t ftype      = %0h\t ttype      = %0h\t SrcID      = %0h\n\
  \t wrsize     = %0h\t SrcTID     = %0h\t hop_count  = %0h\n\
  \t cfg_off    = %0h\t wdptr      = %0h\n\
  \t early_crc  = %0h\n\
  \t final_crc  = %0h\n", 
  trans_ttype8.name,  crf, vc, ackid,   prio, tt, DestinationID,  ftype, ttype, SourceID,
  wrsize, SrcTID,  hop_count, config_offset,  wdptr, early_crc, final_crc),UVM_LOW);
            end // }
  
  
            else if ((ftype == 8) && 
                    ((ttype == 2) || (ttype == 3)))
            begin // {
  `uvm_info("SRIO_TRANS", $sformatf("\n  **************************************************************** \n \
          %s SRIO_TRANS_PACKET_DETAIL \n \
 ****************************************************************  \n \
  \t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t ftype      = %0h\t ttype      = %0h\t SrcID      = %0h\n\
  \t status     = %0h\t TarTID     = %0h\t hop_count  = %0h\n\
  \t cfg_off    = %0h\t wdptr      = %0h\n\
  \t early_crc  = %0h\n\
  \t final_crc  = %0h\n", 
  trans_ttype8.name,  crf, vc, ackid,   prio, tt, DestinationID,  ftype, ttype, SourceID,
  trans_status, targetID_Info,  hop_count, config_offset,  wdptr, early_crc, final_crc),UVM_LOW);
            end // }
  
  
            else if (ftype == 8)
            begin // {
  `uvm_info("SRIO_TRANS", $sformatf("\n  **************************************************************** \n \
 MAINTENANCE PACKET WITH RESERVED TTYPE  SRIO_TRANS_PACKET_DETAIL \n \
 ****************************************************************  \n \
  \t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t ftype      = %0h\t ttype      = %0h\t SrcID      = %0h\n\
  \t rdsize     = %0h\t SrcTID     = %0h\t hop_count  = %0h\n\
  \t wrsize     = %0h\t TarTID     = %0h\n\
  \t status     = %0h\t wdptr      = %0h\n\
  \t cfg_off    = %0h\n\
  \t early_crc  = %0h\n\
  \t final_crc  = %0h\n", 
  crf, vc, ackid,   prio, tt, DestinationID,  ftype, ttype, SourceID,  rdsize, SrcTID, hop_count,
  wrsize, targetID_Info,  trans_status, wdptr,   config_offset, early_crc, final_crc),UVM_LOW);
            end // }
  
            else if ((ftype == 9) && (xh))
            begin // {
  `uvm_info("SRIO_TRANS", $sformatf("\n  **************************************************************** \n \
                  DS TM SRIO_TRANS_PACKET_DETAIL \n \
 ****************************************************************  \n \
  \t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t ftype      = %0h\t ttype      = %0h\t cos        = %0h\n\
  \t Start      = %0h\t End        = %0h\t xh         = %0h\n\
  \t Odd        = %0h\t Pad        = %0h\t streamID   = %0h\n\
  \t TMOP       = %0h\t wild_card  = %0h\t mask       = %0h\n\
  \t xtype      = %0h\t parameter1 = %0h\t parameter2 = %0h\n\
  \t early_crc  = %0h\n\
  \t final_crc  = %0h\n\
  \t SrcID      = %0h", 
  crf, vc, ackid,   prio, tt, DestinationID,  ftype, ttype, cos,  S, E, xh,
  O, P, streamID, TMOP, wild_card, mask, xtype, parameter1, parameter2, early_crc, final_crc,SourceID),UVM_LOW);
            end // }
  
            else if (ftype == 9)
            begin // {
  `uvm_info("SRIO_TRANS", $sformatf("\n  **************************************************************** \n \
                  DS SRIO_TRANS_PACKET_DETAIL \n \
 ****************************************************************  \n \
  \t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t ftype      = %0h\t ttype      = %0h\t cos        = %0h\n\
  \t Start      = %0h\t End        = %0h\t xh         = %0h\n\
  \t Odd        = %0h\t Pad        = %0h\t streamID   = %0h\n\
  \t pdu_len    = %0h\n\
  \t early_crc  = %0h\n\
  \t final_crc  = %0h\n\
  \t SrcID      = %0h", 
  crf, vc, ackid,   prio, tt, DestinationID,  ftype, ttype, cos,  S, E, xh,
  O, P, streamID,  pdulength, early_crc, final_crc,SourceID),UVM_LOW);
            end // }
  
            else if (ftype == 10)
            begin // {
  `uvm_info("SRIO_TRANS", $sformatf("\n  **************************************************************** \n \
                DB  SRIO_TRANS_PACKET_DETAIL \n \
 ****************************************************************  \n \
  \t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t ftype      = %0h\t ttype      = %0h\t SrcID      = %0h\n\
  \t info_msb   = %0h\t info_lsb   = %0h\n\
  \t                    SrcTID     = %0h\n\
  \t early_crc  = %0h\n\
  \t final_crc  = %0h\n", 
  crf, vc, ackid,   prio, tt, DestinationID,  ftype, ttype, SourceID,
  info_msb, info_lsb, SrcTID, early_crc, final_crc),UVM_LOW);
            end // }
  
  
            else if (ftype == 11)
            begin // {
  `uvm_info("SRIO_TRANS", $sformatf("\n  **************************************************************** \n \
             DATA MSG SRIO_TRANS_PACKET_DETAIL \n \
 ****************************************************************  \n \
  \t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t ftype      = %0h\t ttype      = %0h\t SrcID      = %0h\n\
  \t msg_len    = %0h\t ssize      = %0h\t letter     = %0h\n\
  \t mbox       = %0h\t MsgsegXmbox= %0h\n\
  \t early_crc  = %0h\n\
  \t final_crc  = %0h\n", 
  crf, vc, ackid,   prio, tt, DestinationID,  ftype, ttype, SourceID,
  msg_len, ssize, letter,  mbox, msgseg_xmbox, early_crc, final_crc),UVM_LOW); 
            end // }
  
  
            else if (ftype == 13) 
            begin // {
  `uvm_info("SRIO_TRANS", $sformatf("\n  **************************************************************** \n \
          %s  SRIO_TRANS_PACKET_DETAIL \n \
 ****************************************************************  \n \
  \t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t ftype      = %0h\t ttype      = %0h\t SrcID      = %0h\n\
  \t status     = %0h\t TarTID     = %0h\n\
  \t early_crc  = %0h\n\
  \t final_crc  = %0h\n", 
  trans_ttype13.name,  crf, vc, ackid,   prio, tt, DestinationID,  ftype, ttype, SourceID,
  trans_status, targetID_Info, early_crc, final_crc),UVM_LOW);
            end // }

          else  
          begin // {
  `uvm_info("SRIO_TRANS", $sformatf("\n  **************************************************************** \n \
               UNRECOGNIZED SRIO_TRANS_PACKET_DETAIL \n \
 ****************************************************************  \n \
  ackid ............................... : %0h \n \
  vc                                    : %0h \n \
  ftype (Format Type) ................. : %0h \n \
  SourceID                              : %0h \n \
  DestinationID ....................... : %0h \n \
  tt (Transport Type)                   : %0h \n \
  crf ................................. : %0h \n \
  prio  (Priority)                      : %0h \n \
                                              \n \
  I/O Packet Fields                           \n \
  -----------------                           \n \
  wdptr ............................... : %0h \n \
  wrsize                                : %0h \n \
  rdsize .............................. : %0h \n \
  SrcTID                                : %0h \n \
  ttype (Transaction).................. : %0h \n \
  ext_address                           : %0h \n \
  address ............................. : %0h \n \
  xamsbs                                : %0h \n \
  config_offset ....................... : %0h \n \
  hop_count                             : %0h \n \
                                              \n \
  Message/DB Packet Fields                    \n \
  ------------------------                    \n \
  msg_len (Message Length)............. : %0h \n \
  ssize (Segment Size)                  : %0h \n \
  letter .............................. : %0h \n \
  mbox  (Mail Box)                      : %0h \n \
  msgseg_xmbox......................... : %0h \n \
  info_lsb                              : %0h \n \
  info_msb ............................ : %0h \n \
  message_length                        : %0h \n \
                                              \n \
  Data Stream Packet Fields                   \n \
  -------------------------                   \n \
  cos.................................. : %0h \n \
  S (Start Bit)                         : %0h \n \
  E (End Bit).......................... : %0h \n \
  O (Odd Bit)                           : %0h \n \
  P (Pad Bit).......................... : %0h \n \
  xh (Extended Header)                  : %0h \n \
  xtype................................ : %0h \n \
  wild_card                             : %0h \n \
  parameter1........................... : %0h \n \
  parameter2                            : %0h \n \
  TMOP................................. : %0h \n \
  mask                                  : %0h \n \
  streamID............................. : %0h \n \
  pdulength                             : %0h \n \
                                              \n \
  GSM Packet Fields                           \n \
  -----------------                           \n \
  SecTID................................: %0h \n \
  SecID                                 : %0h \n \
  sec_domain........................... : %0h \n \
                                              \n \
  LFC Packet Fields                           \n \
  -----------------                           \n \
  tgtdestID(Target Destination ID)      : %0h \n \
  xon_xoff ............................ : %0h \n \
  FAM                                   : %0h \n \
  SOC.................................. : %0h \n \
  flowID                                : %0h \n \
                                              \n \
  Response Packet Fields                      \n \
  ----------------------                      \n \
  targetID_Info........................ : %0h \n \
  trans_status                          : %0h \n \
  early_crc ........................... : %0h \n \
  final_crc                             : %0h \n \
 ****************************************************************  \n ",
  ackid,vc,ftype, SourceID, DestinationID, tt, crf, prio, wdptr, wrsize, rdsize,
  SrcTID, ttype, ext_address, address, xamsbs, config_offset, hop_count, msg_len,
  ssize, letter, mbox, msgseg_xmbox, info_lsb, info_msb, message_length,
  cos, S, E, O, P, xh, xtype, wild_card, parameter1, parameter2, TMOP,
  mask, streamID, pdulength, SecTID, SecID, sec_domain, 
  tgtdestID, xon_xoff, FAM, SOC, flowID, targetID_Info, trans_status, early_crc,final_crc), UVM_LOW)
  end // }   
 
  dpl_size = payload.size();
  i = 0; 
  if (dpl_size > 0) 
  begin // {
    $display ("\tData Payload"); 
    while ((dpl_size - i) >= 4) 
    begin // {
      $display ("\t D[%0d]:%h \t D[%0d]:%h \t D[%0d]:%h \t D[%0d]:%h", 
      i, payload[i], i+1, payload[i+1], 
      i+2, payload[i+2], i+3, payload[i+3]);
      i = i + 4;  
    end // }
    if ((dpl_size - i) == 3) 
      $display ("\t D[%0d]:%h \t D[%0d]:%h \t D[%0d]:%h\n", i, payload[i], 
      i+1, payload[i+1], i+2, payload[i+2]);
    else if ((dpl_size - i) == 2) 
      $display ("\t D[%0d]:%h \t D[%0d]:%h \n", i, payload[i], 
      i+1, payload[i+1]);
    else if ((dpl_size - i) == 1) 
      $display ("\t D[%0d]:%h\n", i, payload[i]);
  end // }   

  $display ("\n");
  $display ("\tTotal Header Bytes                 = %0d", total_hdr_byte);
  $display ("\tTotal Payload Bytes                = %0d", total_pld_byte);
  $display ("\tEarly + Final CRC                  = %0d", crc_bytes);
  $display ("\tGEN3  CRC                          = %0d", gen3_crc_bytes);
  $display ("\tPad Bytes (For Half DW alignment)  = %0d", pad);
  $display ("\tGEN3 Pad Bytes (For DW alignment)  = %0d", gen3_pad_bytes);
  $display ("\t                                   --------",);
  $display ("\tTotal Packet Bytes                 = %0d", total_pkt_bytes);
  $display ("\t                                   --------",);
  $display ("\n");

endfunction: do_print

////////////////////////////////////////////////////////////////////////////////
/// Name: copy \n 
/// Description: srio_trans's copy task \n
/// copy
//////////////////////////////////////////////////////////////////////////////// 

function void srio_trans::do_copy(uvm_object rhs);
  begin // {
    srio_trans i_srio_trans;
    super.do_copy(rhs);
    $cast(i_srio_trans, rhs);
    `uvm_info("SRIO_TRANS:",$sformatf("copy function - copying srio_trans (Ftype: %0h)",this.ftype),UVM_LOW);

    ackid                 = i_srio_trans.ackid; 
    vc                    = i_srio_trans.vc; 
    crf                   = i_srio_trans.crf; 
    prio                  = i_srio_trans.prio; 
    ftype                 = i_srio_trans.ftype; 
    tt                    = i_srio_trans.tt; 
    DestinationID         = i_srio_trans.DestinationID;  

    if(this.ftype == 4'h7) 
      tgtdestID           = i_srio_trans.tgtdestID;
    else 
      SourceID            = i_srio_trans.SourceID;  

    if(ftype == 4'h1)
    begin // {
      SrcTID              = i_srio_trans.SrcTID; 
      rdsize              = i_srio_trans.rdsize;
      ttype               = i_srio_trans.ttype;  
      SecTID              = i_srio_trans.SecTID; 
      SecID               = i_srio_trans.SecID; 
      sec_domain          = i_srio_trans.sec_domain; 
      ext_address         = i_srio_trans.ext_address;  
      address             = i_srio_trans.address;
      wdptr               = i_srio_trans.wdptr; 
      xamsbs              = i_srio_trans.xamsbs; 
    end // }
    if(ftype == 4'h2) 
    begin  // {
      SrcTID              = i_srio_trans.SrcTID; 
      wdptr               = i_srio_trans.wdptr;   
      rdsize              = i_srio_trans.rdsize;
      ttype               = i_srio_trans.ttype;  
      ext_address         = i_srio_trans.ext_address;  
      address             = i_srio_trans.address;
      xamsbs              = i_srio_trans.xamsbs;
    end  // }
    if(ftype == 4'h5) 
    begin  // {
      SrcTID              = i_srio_trans.SrcTID;
      wdptr               = i_srio_trans.wdptr;    
      ttype               = i_srio_trans.ttype; 
      wrsize              = i_srio_trans.wrsize;
      ext_address         = i_srio_trans.ext_address;  
      address             = i_srio_trans.address;
      xamsbs              = i_srio_trans.xamsbs;
    end  // }
    if(ftype == 4'h6) 
    begin  // {
      ext_address         = i_srio_trans.ext_address; 
      address             = i_srio_trans.address;
      xamsbs              = i_srio_trans.xamsbs;
    end // }
    if(this.ftype == 4'h7) 
    begin  // {
      xon_xoff            = i_srio_trans.xon_xoff; 
      FAM                 = i_srio_trans.FAM; 
      flowID              = i_srio_trans.flowID;  
      SOC                 = i_srio_trans.SOC;  
    end // }
    if(ftype == 4'h8) 
    begin  // {
      ttype               = i_srio_trans.ttype;  
      hop_count           = i_srio_trans.hop_count; 
      if(ttype == 4'h0) 
      begin // {
        rdsize            = i_srio_trans.rdsize;
      end // }
      if(ttype == 4'h1 || ttype == 4'h4) 
      begin // {
        wrsize            = i_srio_trans.wrsize;
      end // }
      if(ttype < 4'h2 || ttype == 4'h4) 
      begin // {
        SrcTID            = i_srio_trans.SrcTID;
        wdptr             = i_srio_trans.wdptr;
        config_offset     = i_srio_trans.config_offset;
      end // }
      if(ttype == 4'h2 || ttype == 4'h3) 
      begin // {
        trans_status      = i_srio_trans.trans_status; 
        targetID_Info     = i_srio_trans.targetID_Info;
      end   // }
    end	   // }
    if(ftype == 4'h9) 
    begin // {
      cos                 = i_srio_trans.cos;
      xh                  = i_srio_trans.xh;
      if(xh == 0)
      begin // {
        S                 = i_srio_trans.S;
        E                 = i_srio_trans.E;
        O                 = i_srio_trans.O;
        P                 = i_srio_trans.P;
        if(S == 0 && E == 1)
        begin // {
          pdulength       = i_srio_trans.pdulength; 
        end // }
      end // }
      else 
      begin // {
        xtype             = i_srio_trans.xtype;
        wild_card         = i_srio_trans.wild_card;
        parameter1        = i_srio_trans.parameter1;
        parameter2        = i_srio_trans.parameter2;
        TMOP              = i_srio_trans.TMOP;
        mask              = i_srio_trans.mask;
      end // }
      if (S || xh)
      begin // {
        streamID          = i_srio_trans.streamID; 
      end  // }
    end  // }
    if(ftype == 4'hA) 
    begin // {
      SrcTID              = i_srio_trans.SrcTID; 
      info_msb            = i_srio_trans.info_msb; 
      info_lsb            = i_srio_trans.info_lsb; 
    end // }
    if(ftype == 4'hB) 
    begin // {
      msg_len             = i_srio_trans.msg_len; 
      ssize               = i_srio_trans.ssize;
      letter              = i_srio_trans.letter; 
      mbox                = i_srio_trans.mbox;
      msgseg_xmbox        = i_srio_trans.msgseg_xmbox;
    end // }
    if(ftype == 4'hD) 
    begin // {
      ttype               = i_srio_trans.ttype;  
      trans_status        = i_srio_trans.trans_status; 
      targetID_Info       = i_srio_trans.targetID_Info; 
    end // }
    payload.delete();
    for(int cnt = 0; cnt < i_srio_trans.payload.size(); cnt++)
    begin // {
      payload.push_back(i_srio_trans.payload[cnt]);
    end // }
  end // }
endfunction: do_copy

////////////////////////////////////////////////////////////////////////////////
/// Name: compare \n 
/// Description: srio_trans's compare task \n
/// compare
//////////////////////////////////////////////////////////////////////////////// 

function bit srio_trans::do_compare(uvm_object rhs, uvm_comparer comparer);
begin // {

  bit compare_success = 1;
  srio_trans i_srio_trans;
  do_compare = super.do_compare(rhs, comparer);
  $cast(i_srio_trans, rhs);

  trans_ftype   = srio_trans_ftype'(this.ftype);
  trans_ttype1  = srio_trans_ttype1'(this.ttype);
  trans_ttype2  = srio_trans_ttype2'(this.ttype);
  trans_ttype5  = srio_trans_ttype5'(this.ttype);
  trans_ttype8  = srio_trans_ttype8'(this.ttype);
  trans_ttype13 = srio_trans_ttype13'(this.ttype);

  if ((this.ftype == FTYPE0) || (this.ftype == FTYPE3) || (this.ftype == FTYPE4) || 
      (this.ftype == FTYPE12)|| (this.ftype == FTYPE14)|| (this.ftype == FTYPE15)) 
  begin // {
    `uvm_info("SRIO_TRANS:",
    $sformatf("compare function-comparing srio_trans Unsupported FTYPE_%0h",this.ftype), UVM_LOW);
  end // }
  else
  begin // {
    if(((this.ftype == FTYPE1)  &&  (this.ttype > FTYPE2))                                            || 
       ((this.ftype == FTYPE5)  && ((this.ttype != 0)  && (this.ttype != 1)   && (this.ttype != 4) &&   
                               (this.ttype != 5)  && (this.ttype != 12)) && 
                               (this.ttype != 13) && (this.ttype != 14))                              ||
       ((this.ftype == FTYPE8)  &&  (this.ttype > 4))                                                 || 
       ((this.ftype == FTYPE13) &&  (this.ttype != 0)  && (this.ttype != 1)   && (this.ttype != 8))) 
    begin // {
     `uvm_warning("SRIO_TRANS:",
     $sformatf("compare function-comparing srio_trans %s Unsupported TTYPE_%0h", 
     trans_ftype.name, this.ttype));
    end // }
    else  
    begin // {
      `uvm_info("SRIO_TRANS:",$sformatf("compare function-comparing srio_trans %s", (
    (this.ftype == FTYPE1) ? trans_ttype1.name : (
    (this.ftype == FTYPE2) ? trans_ttype2.name : (
    (this.ftype == FTYPE5) ? trans_ttype5.name : (
    (this.ftype == FTYPE6) ? "SWRITE"    : (
    (this.ftype == FTYPE7) ? "LFC"       : (
    (this.ftype == FTYPE8) ? trans_ttype8.name : (
    (this.ftype == FTYPE9) ? ((this.xh == 1) ? "DS TM" : "DS") : (
    (this.ftype == FTYPE10)? "DOOR BELL" : (
    (this.ftype == FTYPE11)? "DATA MSG"  : (
    (this.ftype == FTYPE13)? trans_ttype13.name: "UNRECOGNIZED PKT"))))))))))), UVM_LOW);
    end // }
  end // }

  do_compare = (ackid == i_srio_trans.ackid);
  if (!do_compare)
  begin //{
    `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in ackid value. EXP: %h RCVD: %h",
    this.ackid, i_srio_trans.ackid));
    compare_success = 0;
  end //}

  do_compare = (vc == i_srio_trans.vc);
  if (!do_compare)
  begin //{
    `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in vc value. EXP: %h RCVD: %h",
    this.vc, i_srio_trans.vc));
    compare_success = 0;
  end //}

  do_compare = (ftype == i_srio_trans.ftype);
  if (!do_compare)
  begin //{
    `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in FTYPE value. EXP: %h RCVD: %h",
    this.ftype, i_srio_trans.ftype));
    compare_success = 0;
  end //}

  case(this.ftype) // {
    FTYPE1, FTYPE2, FTYPE5, FTYPE8, FTYPE13:
    begin //{
      do_compare = (this.ttype == i_srio_trans.ttype);
      if(!do_compare)
      begin //{
        `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in TTYPE value. EXP: %h RCVD: %h",
        this.ttype,i_srio_trans.ttype));
        compare_success = 0;
      end //}
    end //} 
  endcase //}

  do_compare = (this.crf == i_srio_trans.crf);
  if (!do_compare)
  begin //{
    `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in CRF value. EXP: %h RCVD: %h",
    this.crf,i_srio_trans.crf));
    compare_success = 0;
  end //}

  do_compare = (this.prio == i_srio_trans.prio);
  if (!do_compare)
  begin //{
    `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in PRIO value. EXP: %h RCVD: %h",
    this.prio,i_srio_trans.prio));
    compare_success = 0;
  end //}

  do_compare = (this.tt == i_srio_trans.tt);
  if (!do_compare)
  begin //{
    `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in TT value. EXP: %h RCVD: %h",
    this.tt,i_srio_trans.tt));
    compare_success = 0;
  end //}

  if(this.ftype != FTYPE7)
  begin //{
    do_compare = (this.SourceID == i_srio_trans.SourceID);
    if (!do_compare)
    begin //{ 
      `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in SourceID value. EXP: %h RCVD: %h",
      this.SourceID,i_srio_trans.SourceID));
      compare_success = 0;
    end //}
  end //}

  do_compare = (this.DestinationID == i_srio_trans.DestinationID);
  if (!do_compare)
  begin //{ 
    `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in Destination ID value. EXP: %h RCVD: %h",
    this.DestinationID,i_srio_trans.DestinationID));
    compare_success = 0;
  end //}

  // NWRITE request packets do not require a response. Therefore, 
  // the transaction ID (SrcTID) field for a NWRITE request is undefined 
  // and may have an arbitrary value.
  if(this.ftype == FTYPE1 || this.ftype == FTYPE2 || (this.ftype == FTYPE5 && this.ttype != 4) ||
     this.ftype == FTYPE10 || (this.ftype == FTYPE8 && ((this.ttype == MAINT_READ_REQ) || 
    (this.ttype == MAINT_WRITE_REQ) || (this.ttype == MAINT_PORT_WRITE_REQ)))) 
  begin //{
    do_compare = (this.SrcTID == i_srio_trans.SrcTID);
    if (!do_compare)
    begin //{ 
      `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in SRC TID value. EXP: %h RCVD: %h",
      this.SrcTID,i_srio_trans.SrcTID));
      compare_success = 0;
    end //}
  end //}

  if(this.ftype == FTYPE1 || this.ftype == FTYPE2 || this.ftype == FTYPE5 || 
    (this.ftype == FTYPE8 && (this.ttype < 2 || this.ttype == FTYPE4)))
  begin //{
    do_compare = (this.wdptr == i_srio_trans.wdptr);
    if (!do_compare)
    begin //{ 
      `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in WDPTR value. EXP: %h RCVD: %h",
      this.wdptr,i_srio_trans.wdptr));
      compare_success = 0;
    end //}
  end //}

  if(this.ftype == FTYPE1 || this.ftype == FTYPE2 || this.ftype == FTYPE5 || this.ftype == FTYPE6)
  begin //{
    do_compare = (this.address == i_srio_trans.address);
    if(!do_compare)
    begin //{ 
      `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in Address value. EXP: %h RCVD: %h",
      this.address,i_srio_trans.address));
      compare_success = 0;
    end //}

    do_compare = (this.ext_address == i_srio_trans.ext_address);
    if(!do_compare)
    begin //{ 
      `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in Extended Address value. EXP: %h RCVD: %h",
      this.ext_address,i_srio_trans.ext_address));
      compare_success = 0;
    end //}

    do_compare = (this.xamsbs == i_srio_trans.xamsbs);
    if(!do_compare)
    begin //{ 
      `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in XAMSBS value. EXP: %h RCVD: %h",
      this.xamsbs,i_srio_trans.xamsbs));
      compare_success = 0;
    end //}
  end //}     
        
  if(this.ftype == FTYPE1 || this.ftype == FTYPE2 || (this.ftype == FTYPE8 && this.ttype == 4'h0))
  begin //{
    do_compare = (this.rdsize == i_srio_trans.rdsize);
    if(!do_compare)
    begin //{ 
      `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in Read Size value. EXP: %h RCVD: %h",
      this.rdsize,i_srio_trans.rdsize));
      compare_success = 0;
    end //}
  end //}

  if(this.ftype == FTYPE5|| (this.ftype == FTYPE8 && (this.ttype == 1 || this.ttype == 4'h4)))
  begin //{
    do_compare = (this.wrsize == i_srio_trans.wrsize);
    if(!do_compare)
    begin //{ 
      `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in Write Size value. EXP: %h RCVD: %h",
      this.wrsize,i_srio_trans.wrsize));
      compare_success = 0;
    end //}
  end //}

  if(this.ftype == FTYPE8)
  begin //{
    do_compare = (this.hop_count == i_srio_trans.hop_count);
    if(!do_compare)
    begin //{ 
      `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in Hop Count value. EXP: %h RCVD: %h",
      this.hop_count,i_srio_trans.hop_count));
      compare_success = 0;
    end //}

    if(ttype < 4'h2 || ttype == 4'h4) 
    begin //{ 
      do_compare = (this.config_offset == i_srio_trans.config_offset);
      if(!do_compare)
      begin //{ 
        `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in config_offset value. EXP: %h RCVD: %h",
        this.config_offset,i_srio_trans.config_offset));
        compare_success = 0;
      end //}
    end //}
  end //}

  if(this.ftype == FTYPE1)
  begin //{
    do_compare = (this.SecTID == i_srio_trans.SecTID);
    if(!do_compare)
    begin //{ 
      `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in Sec TID value. EXP: %h RCVD: %h",
      this.SecTID,i_srio_trans.SecTID));
      compare_success = 0;
    end //}

    do_compare = (this.SecID == i_srio_trans.SecID);
    if(!do_compare)
    begin //{ 
      `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in Sec ID value. EXP: %h RCVD: %h",
      this.SecID,i_srio_trans.SecID));
      compare_success = 0;
    end //}

    do_compare = (this.sec_domain == i_srio_trans.sec_domain);
    if(!do_compare)
    begin //{ 
      `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in Sec Domain value. EXP: %h RCVD: %h",
      this.sec_domain,i_srio_trans.sec_domain));
      compare_success = 0;
    end //}
  end //}

  if(this.ftype == FTYPE7)
  begin //{
    do_compare = (this.tgtdestID == i_srio_trans.tgtdestID);
    if(!do_compare)
    begin //{ 
      `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in Target Destination ID value. EXP: %h RCVD: %h",
      this.tgtdestID,i_srio_trans.tgtdestID));
      compare_success = 0;
    end //}

    do_compare = (this.xon_xoff == i_srio_trans.xon_xoff);
    if(!do_compare)
    begin //{ 
      `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in XON_XOFF value. EXP: %h RCVD: %h",
      this.xon_xoff,i_srio_trans.xon_xoff));
      compare_success = 0;
    end //}

    do_compare = (this.FAM == i_srio_trans.FAM);
    if(!do_compare)
    begin //{ 
      `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in FAM value. EXP: %h RCVD: %h",
      this.FAM,i_srio_trans.FAM));
      compare_success = 0;
    end //}

    do_compare = (this.SOC == i_srio_trans.SOC);
    if(!do_compare)
    begin //{ 
      `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in SOC value. EXP: %h RCVD: %h",
      this.SOC,i_srio_trans.SOC));
      compare_success = 0;
    end //}

    do_compare = (this.flowID == i_srio_trans.flowID);
    if(!do_compare)
    begin //{ 
      `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in Flow ID value. EXP: %h RCVD: %h",
      this.flowID,i_srio_trans.flowID));
      compare_success = 0;
    end //}
  end //}

  if(this.ftype == FTYPE9)
  begin //{
    if (this.S || this.xh)
    begin
      do_compare = (this.streamID == i_srio_trans.streamID);
      if(!do_compare)
      begin //{ 
        `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in Stream ID value. EXP: %h RCVD: %h",
        this.streamID,i_srio_trans.streamID));
        compare_success = 0;
      end //}
    end //}

    do_compare = (this.cos == i_srio_trans.cos);
    if(!do_compare)
    begin //{ 
      `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in COS value. EXP: %h RCVD: %h",
      this.cos,i_srio_trans.cos));
      compare_success = 0;
    end //}

    do_compare = (this.xh == i_srio_trans.xh);
    if(!do_compare)
    begin //{ 
      `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in XH value. EXP: %h RCVD: %h",
      this.xh,i_srio_trans.xh));
      compare_success = 0;
    end //}

    if(this.xh == 0)
    begin //{
      do_compare = (this.S == i_srio_trans.S);
      if(!do_compare)
      begin //{ 
        `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in DS Start Seg bit (S). EXP: %h RCVD: %h",
        this.S,i_srio_trans.S));
        compare_success = 0;
      end //}

      do_compare = (this.E == i_srio_trans.E);
      if(!do_compare)
      begin //{ 
        `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in DS End Seg bit (E). EXP: %h RCVD: %h",
        this.E,i_srio_trans.E));
        compare_success = 0;
      end //}

      if(this.E)
      begin //{
        do_compare = (this.O == i_srio_trans.O);
        if(!do_compare)
        begin //{ 
          `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in ODD value. EXP: %h RCVD: %h",
          this.O,i_srio_trans.O));
          compare_success = 0;
        end //}

        do_compare = (this.P == i_srio_trans.P);
        if(!do_compare)
        begin //{ 
          `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in PAD value. EXP: %h RCVD: %h",
          this.P,i_srio_trans.P));
          compare_success = 0;
        end //}

        if(this.S == 0)
        begin //{
          do_compare = (this.pdulength == i_srio_trans.pdulength);
          if(!do_compare)
          begin //{ 
            `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in PDU Length value. EXP: %h RCVD: %h",
            this.pdulength,i_srio_trans.pdulength));
            compare_success = 0;
          end //}
        end //}

      end //}
    end //}
    else 
    begin //{
      do_compare = (this.xtype == i_srio_trans.xtype);
      if(!do_compare)
      begin //{ 
        `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in Xtype value. EXP: %h RCVD: %h",
        this.xtype,i_srio_trans.xtype));
        compare_success = 0;
      end //}

      do_compare = (this.wild_card == i_srio_trans.wild_card);
      if(!do_compare)
      begin //{ 
        `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in Wild Card value. EXP: %h RCVD: %h",
        this.wild_card,i_srio_trans.wild_card));
        compare_success = 0;
      end //}

      do_compare = (this.TMOP == i_srio_trans.TMOP);
      if(!do_compare)
      begin //{ 
        `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in TMOP value. EXP: %h RCVD: %h",
        this.TMOP,i_srio_trans.TMOP));
        compare_success = 0;
      end //}

      do_compare = (this.mask == i_srio_trans.mask);
      if(!do_compare)
      begin //{ 
        `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in Mask value. EXP: %h RCVD: %h",
        this.mask,i_srio_trans.mask));
        compare_success = 0;
      end //}

      do_compare = (this.parameter1 == i_srio_trans.parameter1);
      if(!do_compare)
      begin //{ 
        `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in Parameter1 value. EXP: %h RCVD: %h",
        this.parameter1,i_srio_trans.parameter1));
        compare_success = 0;
      end //}

      do_compare = (this.parameter2 == i_srio_trans.parameter2);
      if(!do_compare)
      begin //{ 
        `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in Parameter2 value. EXP: %h RCVD: %h",
        this.parameter2,i_srio_trans.parameter2));
        compare_success = 0;
      end //}

    end //}
  end //}

  if(this.ftype == FTYPE10)
  begin //{
    do_compare = (this.info_lsb == i_srio_trans.info_lsb);
    if(!do_compare)
    begin //{ 
      `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in Info LSB value. EXP: %h RCVD: %h",
      this.info_lsb,i_srio_trans.info_lsb));
      compare_success = 0;
    end //}

    do_compare = (this.info_msb == i_srio_trans.info_msb);
    if(!do_compare)
    begin //{ 
      `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in Info MSB value. EXP: %h RCVD: %h",
      this.info_msb,i_srio_trans.info_msb));
      compare_success = 0;
    end //}
  end //}

  if(this.ftype == FTYPE11)
  begin //{
    do_compare = (this.msg_len == i_srio_trans.msg_len);
    if(!do_compare)
    begin //{ 
      `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in Message Length value. EXP: %h RCVD: %h",
      this.msg_len,i_srio_trans.msg_len));
      compare_success = 0;
    end //}

    do_compare = (this.ssize == i_srio_trans.ssize);
    if(!do_compare)
    begin //{ 
      `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in SSIZE value. EXP: %h RCVD: %h",
      this.ssize,i_srio_trans.ssize));
      compare_success = 0;
    end //}

    do_compare = (this.letter == i_srio_trans.letter);
    if(!do_compare)
    begin //{ 
      `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in Letter value. EXP: %h RCVD: %h",
      this.letter,i_srio_trans.letter));
      compare_success = 0;
    end //}

    do_compare = (this.mbox == i_srio_trans.mbox);
    if(!do_compare)
    begin //{ 
      `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in MBOX value. EXP: %h RCVD: %h",
      this.mbox,i_srio_trans.mbox));
      compare_success = 0;
    end //}

    do_compare = (this.msgseg_xmbox == i_srio_trans.msgseg_xmbox);
    if(!do_compare)
    begin //{ 
      `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in MSGSEG/XMBOX value. EXP: %h RCVD: %h",
      this.msgseg_xmbox,i_srio_trans.msgseg_xmbox));
      compare_success = 0;
    end //}
  end //}

  if(this.ftype == FTYPE13 || (this.ftype == FTYPE8 && (ttype == 4'h2 || ttype == 4'h3)))
  begin //{
    do_compare = (this.trans_status == i_srio_trans.trans_status);
    if(!do_compare)
    begin //{ 
      `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in Transaction Status value. EXP: %h RCVD: %h",
      this.trans_status,i_srio_trans.trans_status));
      compare_success = 0;
    end //}

    do_compare = (this.targetID_Info == i_srio_trans.targetID_Info);
    if(!do_compare)
    begin //{ 
      `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in Target ID Info value. EXP: %h RCVD: %h",
      this.targetID_Info,i_srio_trans.targetID_Info));
      compare_success = 0;
    end //}
  end //}

  do_compare = (this.payload.size() == i_srio_trans.payload.size());
  if(!do_compare)
  begin //{
    `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in Payload Size. EXP: %d RCVD: %d",
    this.payload.size(),i_srio_trans.payload.size()));
    compare_success = 0;
  end //}
  else 
  begin //{
    for(int cnt = 0; cnt < this.payload.size(); cnt++)
    begin //{
      do_compare = (this.payload[cnt] == i_srio_trans.payload[cnt]);
      if(!do_compare)
      begin //{
        `uvm_error("SRIO_TRANS:",$sformatf("Mismatch in Payload content[%0d]; Data EXP: %d RCVD: %d",
        cnt, this.payload[cnt],i_srio_trans.payload[cnt]));
        compare_success = 0;
      end //}
    end //}  
  end //}

  return compare_success;
end //}
endfunction: do_compare

// =============================================================================

