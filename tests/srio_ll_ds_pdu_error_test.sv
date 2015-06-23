
////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_ds_pdu_error_test .sv
// Project :  srio vip
// Purpose :  ERROR
// Author  :  Mobiveil
//
// Test for ERROR for pdu .
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_ds_pdu_error_test extends srio_base_test;

  `uvm_component_utils(srio_ll_ds_pdu_error_test)
  rand bit [7:0] mtusize_2;
  rand bit [15:0] pdu_length_2;
  srio_ll_ds_pdu_error_seq ds_pdu_error_seq;
  srio_ll_maintenance_ds_support_reg_seq ll_maintenance_ds_support_reg_seq;
    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    ds_pdu_error_seq = srio_ll_ds_pdu_error_seq::type_id::create("ds_pdu_error_seq");
    ll_maintenance_ds_support_reg_seq = srio_ll_maintenance_ds_support_reg_seq::type_id::create("ll_maintenance_ds_support_reg_seq");
     phase.raise_objection( this );
     mtusize_2 =  $urandom_range(32'd64,32'd8);
     pdu_length_2 = $urandom_range(32'h0000_0FFF,32'h0);
     // Configuring MTU
      ll_maintenance_ds_support_reg_seq.mtusize_1 = mtusize_2;
      ll_maintenance_ds_support_reg_seq.start( env1.e_virtual_sequencer);
`ifdef SRIO_VIP_B2B
    //Configuring MTU 
      ll_maintenance_ds_support_reg_seq.mtusize_1 = mtusize_2;
      ll_maintenance_ds_support_reg_seq.start( env2.e_virtual_sequencer);
`endif
   // DS Packet
     ds_pdu_error_seq.mtusize_1 = mtusize_2;
     ds_pdu_error_seq.pdu_length_1 = pdu_length_2;

     ds_pdu_error_seq.start( env1.e_virtual_sequencer);
    #20000ns;
 
    phase.drop_objection(this);
    
  endtask

endclass


