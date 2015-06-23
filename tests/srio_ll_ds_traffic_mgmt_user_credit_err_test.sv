

////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_ds_traffic_mgmt_user_credit_err_test.sv
// Project :  srio vip
// Purpose :  DS TRAFFIC Test 
// Author  :  Mobiveil
//
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_ds_traffic_mgmt_user_credit_err_test extends srio_base_test;

  `uvm_component_utils(srio_ll_ds_traffic_mgmt_user_credit_err_test)
  rand bit [7:0] mtusize_2;
  rand bit [15:0] pdu_length_2;
  rand bit [3:0] tm_mode_2,TMmode_1;
  srio_ll_ds_traffic_mgmt_user_credit_err_seq  ll_ds_traffic_mgmt_user_credit_err_seq;
  srio_ll_ds_traffic_seq  ll_ds_traffic_seq;
  srio_ll_maintenance_ds_support_reg_seq ll_maintenance_ds_support_reg_seq;
  srio_ll_ds_traffic_mgmt_credit_control_seq ds_traffic_mgmt_credit_control_seq;

  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);


    env1.tl_agent.tl_config.usr_sourceid_en = TRUE;
    env1.tl_agent.tl_config.usr_destinationid_en = TRUE;
    env1.tl_agent.tl_config.usr_sourceid = 32'h4F;
    env1.tl_agent.tl_config.usr_destinationid = 32'h5F;
    env2.tl_agent.tl_config.usr_sourceid_en = TRUE;
    env2.tl_agent.tl_config.usr_destinationid_en = TRUE;
    env2.tl_agent.tl_config.usr_sourceid = 32'h5F;
    env2.tl_agent.tl_config.usr_destinationid = 32'h4F;


    ll_ds_traffic_mgmt_user_credit_err_seq = srio_ll_ds_traffic_mgmt_user_credit_err_seq::type_id::create("ll_ds_traffic_mgmt_user_credit_err_seq");
    ll_ds_traffic_seq = srio_ll_ds_traffic_seq::type_id::create("ll_ds_traffic_seq");
    ll_maintenance_ds_support_reg_seq = srio_ll_maintenance_ds_support_reg_seq::type_id::create("ll_maintenance_ds_support_reg_seq");
    ds_traffic_mgmt_credit_control_seq = srio_ll_ds_traffic_mgmt_credit_control_seq::type_id::create("ds_traffic_mgmt_credit_control_seq");
    phase.raise_objection( this );
      mtusize_2 = $urandom_range(32'd64,32'd8);
      pdu_length_2 = $urandom_range(32'h 0000_00FF,32'h1);
      tm_mode_2 = 4'b0011; TMmode_1 = 4'h2;

      //CONFIGURING MTUSIZE AND TM MODE 
      ll_maintenance_ds_support_reg_seq.mtusize_1 = mtusize_2;
      ll_maintenance_ds_support_reg_seq.tm_mode_1 = tm_mode_2;
      ll_maintenance_ds_support_reg_seq.start( env1.e_virtual_sequencer);
    //CONFIGURING MTUSIZE AND TM MODE
      ll_maintenance_ds_support_reg_seq.mtusize_1 = mtusize_2;
      ll_maintenance_ds_support_reg_seq.tm_mode_1 = tm_mode_2;
      ll_maintenance_ds_support_reg_seq.start( env2.e_virtual_sequencer);

    //DS TM Packet
    //  ds_traffic_mgmt_credit_control_seq.TMmode_0 = TMmode_1;
    //  ds_traffic_mgmt_credit_control_seq.start( env1.e_virtual_sequencer);
    
   fork
    begin
    ll_ds_traffic_seq.mtusize_1 = mtusize_2;
    ll_ds_traffic_seq.pdu_length_1 = pdu_length_2;
    ll_ds_traffic_seq.start( env2.e_virtual_sequencer);
    end
    ll_ds_traffic_mgmt_user_credit_err_seq.start( env1.e_virtual_sequencer);
   join


#5000ns;
       phase.drop_objection(this);
    
  endtask

  
endclass


