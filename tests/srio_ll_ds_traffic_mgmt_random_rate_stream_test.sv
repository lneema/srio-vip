


////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_ds_traffic_mgmt_random_rate_stream_test .sv
// Project :  srio vip
// Purpose : Traffic mangement  
// Author  :  Mobiveil
//
// 1. Configuring DS TM mode.
// 2. Trafffic management  random rate stream control
//
////////////////////////////////////////////////////////////////////////////////


class srio_ll_ds_traffic_mgmt_random_rate_stream_test extends srio_base_test;

  `uvm_component_utils(srio_ll_ds_traffic_mgmt_random_rate_stream_test)

    rand bit [3:0] tm_mode_2,TMmode_1;

  srio_ll_ds_traffic_mgmt_random_rate_stream_seq ds_traffic_mgmt_random_rate_stream_seq;
  srio_ll_maintenance_ds_support_reg_seq ll_maintenance_ds_support_reg_seq;
  
  function new(string name, uvm_component parent=null);
  super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    ds_traffic_mgmt_random_rate_stream_seq = srio_ll_ds_traffic_mgmt_random_rate_stream_seq::type_id::create("ds_traffic_mgmt_random_rate_stream_seq");
    ll_maintenance_ds_support_reg_seq = srio_ll_maintenance_ds_support_reg_seq::type_id::create("ll_maintenance_ds_support_reg_seq");


      phase.raise_objection( this );

      tm_mode_2 = 4'b0010; TMmode_1 = 4'h1;

     //Configuring TM mode
      
      ll_maintenance_ds_support_reg_seq.tm_mode_1 = tm_mode_2;
      ll_maintenance_ds_support_reg_seq.start( env1.e_virtual_sequencer);
`ifdef SRIO_VIP_B2B
    //Configuring TM mode

      ll_maintenance_ds_support_reg_seq.tm_mode_1 = tm_mode_2;
      ll_maintenance_ds_support_reg_seq.start( env2.e_virtual_sequencer);
`endif
      //DS TM Packet
      ds_traffic_mgmt_random_rate_stream_seq.TMmode_0 = TMmode_1;
      ds_traffic_mgmt_random_rate_stream_seq.start( env1.e_virtual_sequencer);
  
    phase.drop_objection(this);
    
  endtask

 
endclass


