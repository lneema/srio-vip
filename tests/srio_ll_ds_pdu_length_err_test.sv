////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_ds_pdu_length_err_test.sv
// Project :  srio vip
// Purpose :  PDU length error
// Author  :  Mobiveil
//
// Dta streaming with configure MaxPDU for error
//
////////////////////////////////////////////////////////////////////////////////
class srio_ll_ds_pdu_length_err_test extends srio_base_test;

  `uvm_component_utils(srio_ll_ds_pdu_length_err_test)
  rand bit [7:0] mtusize_2;
  rand bit [15:0] pdu_length_2;
   srio_ll_maintenance_ds_support_reg_seq ll_maintenance_ds_support_reg_seq;
   srio_ll_ds_mseg_req_seq ds_mseg_req_seq;
  
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
      ll_maintenance_ds_support_reg_seq = srio_ll_maintenance_ds_support_reg_seq::type_id::create("ll_maintenance_ds_support_reg_seq");
      ds_mseg_req_seq = srio_ll_ds_mseg_req_seq::type_id::create("ds_mseg_req_seq");
      phase.raise_objection( this );

      mtusize_2 =  $urandom_range(32'd64,32'd8);
      pdu_length_2 = $urandom_range(32'h0000_0FFF,32'h0f);
      ll_maintenance_ds_support_reg_seq.tm_mode_1 = 0;
     // Configuring MTU
      ll_maintenance_ds_support_reg_seq.mtusize_1 = mtusize_2;
      ll_maintenance_ds_support_reg_seq.start( env1.e_virtual_sequencer);
`ifdef SRIO_VIP_B2B
    //Configuring MTU 
      ll_maintenance_ds_support_reg_seq.mtusize_1 = mtusize_2;
      ll_maintenance_ds_support_reg_seq.start( env2.e_virtual_sequencer);
`endif
      ds_mseg_req_seq.mtusize_1 = mtusize_2;
      ds_mseg_req_seq.pdu_length_1 = pdu_length_2;
      ds_mseg_req_seq.start( env1.e_virtual_sequencer);

      #50000ns;
      phase.drop_objection(this);
    endtask
function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
     void'(srio1_reg_model_tx.Data_Streaming_Information_CAR.MaxPDU.predict(16'ha000));
     void'(srio1_reg_model_rx.Data_Streaming_Information_CAR.MaxPDU.predict(16'ha000));
`ifdef SRIO_VIP_B2B
     void'(srio2_reg_model_tx.Data_Streaming_Information_CAR.MaxPDU.predict(16'ha000));
     void'(srio2_reg_model_rx.Data_Streaming_Information_CAR.MaxPDU.predict(16'ha000)); 
`endif
endfunction

endclass


