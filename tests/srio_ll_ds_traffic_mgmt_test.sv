
////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_ds_traffic_mgmt_test .sv
// Project :  srio vip
// Purpose : Traffic mangement  
// Author  :  Mobiveil
//
// 1.Configuring DS TM mode.
// 2.Trafffic management req sequences and data streaming 
//
////////////////////////////////////////////////////////////////////////////////


class srio_ll_ds_traffic_mgmt_test extends srio_base_test;

  `uvm_component_utils(srio_ll_ds_traffic_mgmt_test)

  rand bit [7:0] mtusize_2;
  rand bit [15:0] pdu_length_2;
  rand bit [3:0] tm_mode_2,TMmode_1;
  rand bit [2:0] mode;
  rand bit sel;

  srio_ll_ds_traffic_mgmt_seq ds_traffic_mgmt_req_seq;
  srio_ll_ds_traffic_mgmt_credit_control_seq ds_traffic_mgmt_credit_control_seq;
  srio_ll_maintenance_ds_support_reg_seq ll_maintenance_ds_support_reg_seq; 
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    ds_traffic_mgmt_req_seq = srio_ll_ds_traffic_mgmt_seq ::type_id::create("ds_traffic_mgmt_req_seq");
    ds_traffic_mgmt_credit_control_seq = srio_ll_ds_traffic_mgmt_credit_control_seq::type_id::create("ds_traffic_mgmt_credit_control_seq");
    ll_maintenance_ds_support_reg_seq = srio_ll_maintenance_ds_support_reg_seq::type_id::create("ll_maintenance_ds_support_reg_seq");


      phase.raise_objection( this );
      mtusize_2 = $urandom_range(32'd64,32'd8);
      pdu_length_2 = $urandom_range(32'h 0000_00FF,32'h1);
      mode = $urandom_range(32'd3,32'd0);
      sel = $urandom;
      
      case(mode) //{
        3'd0:begin tm_mode_2 = 4'b0001; TMmode_1 = 4'h0;end
        3'd1:begin tm_mode_2 = 4'b0010; TMmode_1 = 4'h1;end
        3'd2:begin tm_mode_2 = 4'b0011; TMmode_1 = 4'h2;end
        3'd3:begin tm_mode_2 = 4'b0100; TMmode_1 = (sel == 1'b1) ? 4'h2 :4'h1; end 

      endcase //}

       //CONFIGURING MTUSIZE AND TM MODE 
      ll_maintenance_ds_support_reg_seq.mtusize_1 = mtusize_2;
      ll_maintenance_ds_support_reg_seq.tm_mode_1 = tm_mode_2;
      ll_maintenance_ds_support_reg_seq.start( env1.e_virtual_sequencer);

    //CONFIGURING MTUSIZE AND TM MODE
      ll_maintenance_ds_support_reg_seq.mtusize_1 = mtusize_2;
      ll_maintenance_ds_support_reg_seq.tm_mode_1 = tm_mode_2;
      ll_maintenance_ds_support_reg_seq.start( env2.e_virtual_sequencer);

     // DS Credit Packet 
      if((tm_mode_2 == 4'b0011)||((tm_mode_2 == 4'b0100)&&(sel == 1'b1)))
       begin
       ds_traffic_mgmt_credit_control_seq.TMmode_0 = 4'h2;
       ds_traffic_mgmt_credit_control_seq.start( env2.e_virtual_sequencer);
       end
     // Random DS Packet.
       ds_traffic_mgmt_req_seq.mtusize_1 = mtusize_2;
       ds_traffic_mgmt_req_seq.pdu_length_1 = pdu_length_2;
       ds_traffic_mgmt_req_seq.TMmode_0 = TMmode_1;
       ds_traffic_mgmt_req_seq.start( env1.e_virtual_sequencer);

       #2000ns ;
       phase.drop_objection(this);
    
  endtask

endclass


