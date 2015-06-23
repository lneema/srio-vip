
////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_ds_traffic_mgmt_parameter1_err_test.sv
// Project :  srio vip
// Purpose : Reserved parameter1 value
// Author  :  Mobiveil
//
// Test for valid TMOP and reserved parameter1
//
////////////////////////////////////////////////////////////////////////////////


class srio_ll_ds_traffic_mgmt_parameter1_err_test extends srio_base_test;

  `uvm_component_utils(srio_ll_ds_traffic_mgmt_parameter1_err_test)

  srio_ll_ds_traffic_mgmt_parameter1_err_seq ds_traffic_mgmt_parameter1_err_seq;
  srio_ll_maintenance_ds_support_reg_seq ll_maintenance_ds_support_reg_seq;

  rand bit [7:0] mtusize_2;
  rand bit [15:0] pdu_length_2;
  rand bit [3:0] tm_mode_2,TMmode_1;  
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    ds_traffic_mgmt_parameter1_err_seq = srio_ll_ds_traffic_mgmt_parameter1_err_seq::type_id::create("ds_traffic_mgmt_parameter1_err_seq");
    ll_maintenance_ds_support_reg_seq = srio_ll_maintenance_ds_support_reg_seq::type_id::create("ll_maintenance_ds_support_reg_seq");

      phase.raise_objection( this );
      mtusize_2 = $urandom_range(32'd64,32'd8);
      pdu_length_2 = $urandom_range(32'h 0000_00FF,32'h1);
      tm_mode_2 = 4'b0001; TMmode_1 = 4'h0;

      //CONFIGURING MTUSIZE AND TM MODE 
      ll_maintenance_ds_support_reg_seq.mtusize_1 = mtusize_2;
      ll_maintenance_ds_support_reg_seq.tm_mode_1 = tm_mode_2;
      ll_maintenance_ds_support_reg_seq.start( env1.e_virtual_sequencer);
    //CONFIGURING MTUSIZE AND TM MODE
      ll_maintenance_ds_support_reg_seq.mtusize_1 = mtusize_2;
      ll_maintenance_ds_support_reg_seq.tm_mode_1 = tm_mode_2;
      ll_maintenance_ds_support_reg_seq.start( env2.e_virtual_sequencer);

     ds_traffic_mgmt_parameter1_err_seq.start( env1.e_virtual_sequencer);

      
   #20000ns;
    phase.drop_objection(this);
    
  endtask

endclass
