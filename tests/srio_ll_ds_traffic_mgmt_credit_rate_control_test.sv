
////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_ds_traffic_mgmt_credit_rate_control_test.sv
// Project :  srio vip
// Purpose :  Traffic mangement  
// Author  :  Mobiveil
//
// 1.Configuring DS TM mode.
// 2.Trafffic management application stream control
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_ds_traffic_mgmt_credit_rate_control_test extends srio_base_test;

  `uvm_component_utils(srio_ll_ds_traffic_mgmt_credit_rate_control_test)

  rand bit [3:0] tm_mode_2,TMmode_1;
  rand bit flag;

  srio_ll_ds_traffic_mgmt_credit_rate_control_seq ds_traffic_mgmt_credit_rate_control_seq;
  srio_ll_maintenance_ds_support_reg_seq ll_maintenance_ds_support_reg_seq;
 
  function new(string name, uvm_component parent=null);
  super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    ds_traffic_mgmt_credit_rate_control_seq = srio_ll_ds_traffic_mgmt_credit_rate_control_seq::type_id::create("ds_traffic_mgmt_credit_rate_control_seq");
    ll_maintenance_ds_support_reg_seq = srio_ll_maintenance_ds_support_reg_seq::type_id::create("ll_maintenance_ds_support_reg_seq");

    phase.raise_objection( this );
      flag = $urandom ;
      tm_mode_2 = 4'b0100;TMmode_1 = (flag == 1'b1) ? 4'h2 :4'h1;

     //Configuring TM mode
      
      ll_maintenance_ds_support_reg_seq.tm_mode_1 = tm_mode_2;
      ll_maintenance_ds_support_reg_seq.start( env1.e_virtual_sequencer);
`ifdef SRIO_VIP_B2B
    //Configuring TM mode

      ll_maintenance_ds_support_reg_seq.tm_mode_1 = tm_mode_2;
      ll_maintenance_ds_support_reg_seq.start( env2.e_virtual_sequencer);
`endif
      //DS TM Packet
     ds_traffic_mgmt_credit_rate_control_seq.TMmode_0 = TMmode_1;
     ds_traffic_mgmt_credit_rate_control_seq.start( env1.e_virtual_sequencer);
     #5000ns;
     phase.drop_objection(this);
    
  endtask

endclass


