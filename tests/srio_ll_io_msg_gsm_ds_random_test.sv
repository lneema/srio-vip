
////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_io_msg_gsm_ds_random_test .sv
// Project :  srio vip
// Purpose :  io,msg,gsm,ds random sequences 
// Author  :  Mobiveil
//
//// Test for concurrent IO,DS,MSG,GSM packets
////////////////////////////////////////////////////////////////////////////////

class srio_ll_io_msg_gsm_ds_random_test extends srio_base_test;

  rand bit [7:0] mtusize_2;
  rand bit [15:0] pdu_length_2;
  rand bit [3:0] tm_mode_2,TMmode_1;

  `uvm_component_utils(srio_ll_io_msg_gsm_ds_random_test)
          
   srio_ll_io_random_seq ll_io_random_seq;
   srio_ll_message_random_seq ll_message_random_seq;
   srio_ll_gsm_random_seq ll_gsm_random_seq;
   srio_ll_ds_traffic_seq  ll_ds_traffic_seq;
   srio_ll_maintenance_ds_support_reg_seq ll_maintenance_ds_support_reg_seq;
    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
        ll_io_random_seq = srio_ll_io_random_seq::type_id::create("ll_io_random_seq");
        ll_message_random_seq = srio_ll_message_random_seq::type_id::create("ll_message_random_seq");
        ll_gsm_random_seq = srio_ll_gsm_random_seq::type_id::create("ll_gsm_random_seq");
        ll_ds_traffic_seq = srio_ll_ds_traffic_seq::type_id::create("ll_ds_traffic_seq");
        ll_maintenance_ds_support_reg_seq = srio_ll_maintenance_ds_support_reg_seq::type_id::create("ll_maintenance_ds_support_reg_seq");

        phase.raise_objection( this );
        mtusize_2 = $urandom_range(32'd64,32'd8);
        pdu_length_2 = $urandom_range(32'h 0000_0FFF,32'h0);
        tm_mode_2 = 4'b0001; TMmode_1 = 4'h0;
        //CONFIGURING MTUSIZE AND TM MODE 
        ll_maintenance_ds_support_reg_seq.mtusize_1 = mtusize_2;
        ll_maintenance_ds_support_reg_seq.tm_mode_1 = tm_mode_2;
        ll_maintenance_ds_support_reg_seq.start( env1.e_virtual_sequencer);

        //CONFIGURING MTUSIZE AND TM MODE
        ll_maintenance_ds_support_reg_seq.mtusize_1 = mtusize_2;
        ll_maintenance_ds_support_reg_seq.tm_mode_1 = tm_mode_2;
        ll_maintenance_ds_support_reg_seq.start( env2.e_virtual_sequencer);

        fork
          ll_io_random_seq.start( env1.e_virtual_sequencer);
          ll_message_random_seq.start( env1.e_virtual_sequencer);
          ll_gsm_random_seq.start( env1.e_virtual_sequencer);
          begin 
          ll_ds_traffic_seq.mtusize_1 = mtusize_2;
          ll_ds_traffic_seq.pdu_length_1 = pdu_length_2;
          ll_ds_traffic_seq.start(env2.e_virtual_sequencer);
          end 
        join
    #20000ns;
    phase.drop_objection(this);


  endtask
endclass


