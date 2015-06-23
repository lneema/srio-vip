////////////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File       :  srio_pl_lane_data.sv
// Project    :  srio vip
// Purpose    :  Transaction which is used by the methods inside the lane_handler class.
//		 Lane specific data is passed to the higher level component through this transaction.
// Author     :  Mobiveil
//
// Physical layer lane specific transaction class. 
//
//
//////////////////////////////////////////////////////////////////////////////////////////////////

class srio_pl_lane_data extends uvm_object;

  /// @cond
  `uvm_object_utils(srio_pl_lane_data)
  /// @endcond

  bit [0:7] character;				///< BRC1/2 character
  bit cntl;					///< Control / Data character. 1 : control ; 0 : Data
  bit [0:9] cg;					///< BRC1/2 10-bit code group
  bit idle2_cs;					///< To indicate that currently IDLE2 CS Marker / CS field is being received.
  bit csfield_update;				///< Flag used to update cs field.
  bit [0:7] idle2_cs_field_descrambled_data;	///< Variable to store descrambled data of CS field. Could be used at higher block if the data doesn't belong to CS field.

  bit [0:63] brc3_cw;				///< BRC3 code word
  bit brc3_type;				///< BRC3 type. 0 : control ; 1 : Data
  bit [1:0] brc3_cc_type;			///< BRC3 cc_type
  brc3_cntl_cw_func_type brc3_cntl_cw_type;	///< BRC3 control codeword function type
  bit [0:66] brc3_cg;				///< BRC3 67-bit code group
  bit brc3_stcs_update;				///< Flag used to update status/control ordered sequemce.
  bit brc3_sdos_update;				///< Flag used to update seed ordered sequence.
  bit brc3_lc_update;				///< Flag used to update lane check control codeword.
  bit brc3_trn_update;				///< Flag used to update codeword training command.
  bit brc3_fm_update;				///< Flag used to update dme training command.
  bit brc3_cof_update;				///< Flag used to update training coefficient.
  bit brc3_stat_update;				///< Flag used to update training status.
  bit brc3_skip;				///< Flag used to mark skip 

  bit invalid_cg;				///< Indicates invalid codegroup.

  running_disparity curr_rd;			///< current running disparity


///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : New
/// Description : Constructor method for srio_pl_lane_data class.
///////////////////////////////////////////////////////////////////////////////////////////////
  function new(string name="srio_pl_lane_data");
    super.new(name);
  endfunction

endclass



class srio_1x_lane_data extends uvm_object;

  /// @cond
  `uvm_object_utils(srio_1x_lane_data)
  /// @endcond

  bit [7:0] character;				///< 8-bit character.
  bit cntl;					///< Control or data character. 1 : control ; 0 : Data.

  bit [0:63] brc3_cw;				///< BRC3 code word
  bit brc3_type;				///< BRC3 type. 0 : control ; 1 : Data
  bit [1:0] brc3_cc_type;			///< BRC3 cc_type
  brc3_cntl_cw_func_type brc3_cntl_cw_type;	///< BRC3 control codeword function type


///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : New
/// Description : Constructor method for srio_1x_lane_data class.
///////////////////////////////////////////////////////////////////////////////////////////////
  function new(string name="srio_1x_lane_data");
    super.new(name);
  endfunction

endclass


class srio_2x_align_data extends uvm_object;

  /// @cond
  `uvm_object_utils(srio_2x_align_data)
  /// @endcond

  bit [7:0] character[int];				///< 8-bit character.
  bit cntl[int];                        		///< Control or data character. 1 : control ; 0 : Data.
  bit idle2_cs[int];					///< To indicate that currently IDLE2 CS Marker / CS field is being received.

  bit [0:63] brc3_cw[int];				///< BRC3 code word
  bit brc3_type[int];					///< BRC3 type. 0 : control ; 1 : Data
  bit [1:0] brc3_cc_type[int];				///< BRC3 cc_type
  brc3_cntl_cw_func_type brc3_cntl_cw_type[int];	///< BRC3 control codeword function type


///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : New
/// Description : Constructor method for srio_2x_align_data class.
///////////////////////////////////////////////////////////////////////////////////////////////
  function new(string name="srio_2x_lane_data");
    super.new(name);
  endfunction

endclass


class srio_nx_align_data extends uvm_object;

  /// @cond
  `uvm_object_utils(srio_nx_align_data)
  /// @endcond

  bit [7:0] character[int];				///< 8-bit character.
  bit cntl[int];                                	///< Control or data character. 1 : control ; 0 : Data.
  bit idle2_cs[int];					///< To indicate that currently IDLE2 CS Marker / CS field is being received.
  bit [0:7] idle2_cs_field_descrambled_data[int];	///< Variable to store descrambled data of CS field.

  bit [0:63] brc3_cw[int];				///< BRC3 code word
  bit brc3_type[int];					///< BRC3 type. 0 : control ; 1 : Data
  bit [1:0] brc3_cc_type[int];				///< BRC3 cc_type
  brc3_cntl_cw_func_type brc3_cntl_cw_type[int];	///< BRC3 control codeword function type


///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : New
/// Description : Constructor method for srio_nx_align_data class.
///////////////////////////////////////////////////////////////////////////////////////////////
  function new(string name="srio_nx_lane_data");
    super.new(name);
  endfunction

endclass


class srio_gen3_align_data extends uvm_object;

  /// @cond
  `uvm_object_utils(srio_gen3_align_data)
  /// @endcond

  bit [0:63] brc3_cw[int];				///< BRC3 code word
  bit brc3_type[int];					///< BRC3 type. 0 : control ; 1 : Data
  bit [1:0] brc3_cc_type[int];				///< BRC3 cc_type
  brc3_cntl_cw_func_type brc3_cntl_cw_type[int];	///< BRC3 control codeword function type


///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : New
/// Description : Constructor method for srio_gen3_align_data class.
///////////////////////////////////////////////////////////////////////////////////////////////
  function new(string name="srio_gen3_align_data");
    super.new(name);
  endfunction

endclass


class srio_pl_rcvd_cs_field_data extends uvm_object;

  /// @cond
  `uvm_object_utils(srio_pl_rcvd_cs_field_data)
  /// @endcond


  bit [0:1] cs_fld_char_q[$];			///< cs field character queue.


  bit idle2_cs_fld_cmd;				///< Command decoded from idle2 cs field.
  bit idle2_cs_fld_rcvr_trained;		///< Receiver trained decoded from idle2 cs field.
  bit idle2_cs_fld_data_scr_en;			///< Data scrambler enable decoded from idle2 cs field.
  bit [0:1] idle2_cs_fld_tap_minus1_status;	///< Tap(-)1 status decoded from idle2 cs field.
  bit [0:1] idle2_cs_fld_tap_plus1_status;	///< Tap(+)1 status decoded from idle2 cs field.
  bit [0:1] idle2_cs_fld_tap_minus1_cmd;	///< Tap(-)1 command decoded from idle2 cs field.
  bit [0:1] idle2_cs_fld_tap_plus1_cmd;		///< Tap(+)1 command decoded from idle2 cs field.
  bit idle2_cs_fld_reset_emp;			///< Reset decoded from idle2 cs field.
  bit idle2_cs_fld_preset_emp;			///< Preset decoded from idle2 cs field.
  bit idle2_cs_fld_ack;				///< ACK decoded from idle2 cs field.
  bit idle2_cs_fld_nack;			///< NACK decoded from idle2 cs field.

  bit idle2_cs_fld_decode_success;		///< Flag to indicate that cs field decoding is success.

  bit aet_fld_compare;				///< Flag to indicate cs field compare status.


///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : New
/// Description : Constructor method for srio_pl_rcvd_cs_field_data class.
///////////////////////////////////////////////////////////////////////////////////////////////
  function new(string name="srio_pl_rcvd_cs_field_data");
    super.new(name);
  endfunction



////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : decode_idle2_cs_field_bits
/// Description : This method decodes the received cs field data and updates idle2_cs_fld_decode_success
/// flag to indicate the decoding status.
////////////////////////////////////////////////////////////////////////////////////////////////////////
  task decode_idle2_cs_field_bits();

    bit [0:1] temp_char;

    if (cs_fld_char_q.size()==32)
    begin //{

      temp_char = cs_fld_char_q.pop_front();
      idle2_cs_fld_cmd = temp_char[0];

      temp_char = cs_fld_char_q.pop_front();
      idle2_cs_fld_rcvr_trained = temp_char[0];
      idle2_cs_fld_data_scr_en = temp_char[1];

      temp_char = cs_fld_char_q.pop_front();
      idle2_cs_fld_tap_minus1_status = temp_char;

      temp_char = cs_fld_char_q.pop_front();
      idle2_cs_fld_tap_plus1_status = temp_char;

      repeat(8) void'(cs_fld_char_q.pop_front());
       
      temp_char = cs_fld_char_q.pop_front();
      idle2_cs_fld_tap_minus1_cmd = temp_char;

      temp_char = cs_fld_char_q.pop_front();
      idle2_cs_fld_tap_plus1_cmd = temp_char;

      temp_char = cs_fld_char_q.pop_front();
      idle2_cs_fld_reset_emp = temp_char[0];
      idle2_cs_fld_preset_emp = temp_char[1];

      temp_char = cs_fld_char_q.pop_front();
      idle2_cs_fld_ack = temp_char[0];
      idle2_cs_fld_nack = temp_char[1];

      cs_fld_char_q.delete();

      idle2_cs_fld_decode_success = 1;

    end //}
    else
    begin //{
      `uvm_info("SRIO_PL_RCVD_CS_FIELD_DATA", $sformatf(" Complete IDLE2 CS Field is not collected. cs_fld_char_q size is %0d", cs_fld_char_q.size()), UVM_LOW)

      idle2_cs_fld_decode_success = 0;

    end //}

  endtask : decode_idle2_cs_field_bits



///////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : compare_aet_control_fields
/// Description : This method compares command fields of two cs field data and updates the aet_fld_compare
/// flag. If the aet_fld_compare is '0', it means compare failed, else it is success.
///////////////////////////////////////////////////////////////////////////////////////////////////////////
  task compare_aet_control_fields(srio_pl_rcvd_cs_field_data cmp_ins);

    aet_fld_compare = 1;

    if (this.idle2_cs_fld_cmd != cmp_ins.idle2_cs_fld_cmd)
    begin //{
      aet_fld_compare = 0;
    end //}

    if (this.idle2_cs_fld_tap_minus1_cmd != cmp_ins.idle2_cs_fld_tap_minus1_cmd)
    begin //{
      aet_fld_compare = 0;
    end //}

    if (this.idle2_cs_fld_tap_plus1_cmd != cmp_ins.idle2_cs_fld_tap_plus1_cmd)
    begin //{
      aet_fld_compare = 0;
    end //}

    if (this.idle2_cs_fld_reset_emp != cmp_ins.idle2_cs_fld_reset_emp)
    begin //{
      aet_fld_compare = 0;
    end //}

    if (this.idle2_cs_fld_preset_emp != cmp_ins.idle2_cs_fld_preset_emp)
    begin //{
      aet_fld_compare = 0;
    end //}

  endtask : compare_aet_control_fields



///////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : compare_aet_status_fields
/// Description : This method compares status fields of two cs field data and updates the aet_fld_compare
/// flag. If the aet_fld_compare is '0', it means compare failed, else it is success.
///////////////////////////////////////////////////////////////////////////////////////////////////////////
  task compare_aet_status_fields(srio_pl_rcvd_cs_field_data cmp_ins);

    aet_fld_compare = 1;

    if (this.idle2_cs_fld_tap_minus1_status != cmp_ins.idle2_cs_fld_tap_minus1_status)
    begin //{
      aet_fld_compare = 0;
    end //}

    if (this.idle2_cs_fld_tap_plus1_status != cmp_ins.idle2_cs_fld_tap_plus1_status)
    begin //{
      aet_fld_compare = 0;
    end //}

    if (this.idle2_cs_fld_rcvr_trained != cmp_ins.idle2_cs_fld_rcvr_trained)
    begin //{
      aet_fld_compare = 0;
    end //}

    if (this.idle2_cs_fld_data_scr_en != cmp_ins.idle2_cs_fld_data_scr_en)
    begin //{
      aet_fld_compare = 0;
    end //}

  endtask : compare_aet_status_fields

endclass



class srio_pl_gen3_lane_train_data extends uvm_object;

  /// @cond
  `uvm_object_utils(srio_pl_gen3_lane_train_data)
  /// @endcond

  bit [3:0] xmit_equalizer_tap;		///< Tap field decoded from Status/Control control codeword.
  bit [2:0] xmit_equalizer_cmd;		///< Command field decoded from Status/Control control codeword.
  bit [2:0] xmit_equalizer_status;	///< Status field decoded from Status/Control control codeword.

  bit [1:0] xmit_equalizer_cp1_cmd; 	///< CP1 command field decoded from DME frame.
  bit [1:0] xmit_equalizer_cn1_cmd; 	///< CN1 command field decoded from DME frame.

  bit [1:0] xmit_equalizer_cp1_status; 	///< CP1 status field decoded from DME frame.
  bit [1:0] xmit_equalizer_cn1_status; 	///< CN1 status field decoded from DME frame.



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : New
/// Description : Constructor method for srio_pl_gen3_lane_train_data class.
///////////////////////////////////////////////////////////////////////////////////////////////
  function new(string name="srio_pl_gen3_lane_train_data");
    super.new(name);
  endfunction

endclass
