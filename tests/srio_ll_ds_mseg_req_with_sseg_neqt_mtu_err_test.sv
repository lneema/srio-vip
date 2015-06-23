////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_ds_mseg_req_test .sv
// Project :  srio vip
// Purpose :  Data streaming test
// Author  :  Mobiveil
//
// Data streaming with Multi segment packet with Start segment not equal to MTU
//
////////////////////////////////////////////////////////////////////////////////
class srio_ll_ds_mseg_req_with_sseg_neqt_mtu_err_test extends srio_base_test;

  `uvm_component_utils(srio_ll_ds_mseg_req_with_sseg_neqt_mtu_err_test)

  rand bit [7:0] mtusize_2;
  rand bit [15:0] pdu_length_2;

  srio_ll_ds_mseg_req_err_seq ds_mseg_req_err_seq;
  srio_ll_maintenance_ds_support_reg_seq ll_maintenance_ds_support_reg_seq; 
  srio_ll_tx_ds_sseg_err_cb ll_tx_ds_sseg_err_cb;

  function new(string name, uvm_component parent=null);
  super.new(name, parent);
   ll_tx_ds_sseg_err_cb = new();
  endfunction

 function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
    
    uvm_callbacks #(srio_logical_transaction_generator, srio_ll_tx_ds_sseg_err_cb)::add(env1.ll_agent.ll_bfm.logical_transaction_generator, ll_tx_ds_sseg_err_cb);

  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);

    ds_mseg_req_err_seq = srio_ll_ds_mseg_req_err_seq::type_id::create("ds_mseg_req_err_seq");
    ll_maintenance_ds_support_reg_seq = srio_ll_maintenance_ds_support_reg_seq::type_id::create("ll_maintenance_ds_support_reg_seq");

   phase.raise_objection( this );

   mtusize_2 = $urandom_range(32'd64,32'd8);
   pdu_length_2 = $urandom_range(32'h0000_0FFF,mtusize_2*4);
   
   // Configuring MTU
      ll_maintenance_ds_support_reg_seq.mtusize_1 = mtusize_2;
      ll_maintenance_ds_support_reg_seq.start( env1.e_virtual_sequencer);
`ifdef SRIO_VIP_B2B
    //Configuring MTU 
      ll_maintenance_ds_support_reg_seq.mtusize_1 = mtusize_2;
      ll_maintenance_ds_support_reg_seq.start( env2.e_virtual_sequencer);
`endif
   //DS Packet 
     ds_mseg_req_err_seq.mtusize_1 = mtusize_2;
     ds_mseg_req_err_seq.pdu_length_1 = pdu_length_2;
     ds_mseg_req_err_seq.start( env1.e_virtual_sequencer);

     #10000ns; 
     phase.drop_objection(this);
  endtask
endclass


