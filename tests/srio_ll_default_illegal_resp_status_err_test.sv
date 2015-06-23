////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_default_illegal_resp_status_err_test.sv
// Project :  srio vip
// Purpose :  Illegal ttype and status for IO packets
// Author  :  Mobiveil
//
//1) maintenance packet to configure MTU size
//2) credit allocation packet
//3) default sequence for all packets
//4) maintenance read and write packet
////////////////////////////////////////////////////////////////////////////////

class srio_ll_default_illegal_resp_status_err_test extends srio_base_test;

  `uvm_component_utils(srio_ll_default_illegal_resp_status_err_test)

   rand bit [3:0] tm_mode_2,TMmode_1;
   rand bit [2:0] mode;
   rand bit sel;
   rand bit [7:0] mtusize_2;

   srio_ll_default_seq default_seq;
   srio_ll_ds_traffic_mgmt_credit_control_seq ds_traffic_mgmt_credit_control_seq;
   srio_ll_maintenance_ds_support_reg_seq ll_maintenance_ds_support_reg_seq;
   srio_ll_tx_default_resp_with_invalid_status_err_cb ll_tx_cb_ins;
   srio_ll_maintenance_rd_resp_req_seq ll_maintenance_rd_resp_req_seq;
   srio_ll_maintenance_wr_resp_req_seq ll_maintenance_wr_resp_req_seq;
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
    ll_tx_cb_ins = new();
  endfunction

 
  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
    uvm_callbacks #(srio_logical_transaction_generator, srio_ll_tx_default_resp_with_invalid_status_err_cb)::add(env2.ll_agent.ll_bfm.logical_transaction_generator, ll_tx_cb_ins);  //Registration of callback class
  endfunction

      
   task run_phase( uvm_phase phase );
    super.run_phase(phase);
     
      default_seq = srio_ll_default_seq::type_id::create("default_seq");

      ds_traffic_mgmt_credit_control_seq = srio_ll_ds_traffic_mgmt_credit_control_seq::type_id::create("ds_traffic_mgmt_credit_control_seq");
      ll_maintenance_ds_support_reg_seq = srio_ll_maintenance_ds_support_reg_seq::type_id::create("ll_maintenance_ds_support_reg_seq");
      ll_maintenance_rd_resp_req_seq = srio_ll_maintenance_rd_resp_req_seq::type_id::create("ll_maintenance_rd_resp_req_seq");
      ll_maintenance_wr_resp_req_seq = srio_ll_maintenance_wr_resp_req_seq::type_id::create("ll_maintenance_wr_resp_req_seq");

      phase.raise_objection( this );
      mode = $urandom_range(32'd3,32'd0);
      sel = $urandom;
      mtusize_2 = $urandom_range(32'd64,32'd8); 
      case(mode) //{
        3'd0:begin tm_mode_2 = 4'b0001; TMmode_1 = 4'h0;end
        3'd1:begin tm_mode_2 = 4'b0010; TMmode_1 = 4'h1;end
        3'd2:begin tm_mode_2 = 4'b0011; TMmode_1 = 4'h2;end
        3'd3:begin tm_mode_2 = 4'b0100; TMmode_1 = (sel == 1'b1) ? 4'h2 :4'h1; end 
      endcase //}

     //Configuring TM mode 
      ll_maintenance_ds_support_reg_seq.mtusize_1 = mtusize_2;
      ll_maintenance_ds_support_reg_seq.tm_mode_1 = tm_mode_2;
      ll_maintenance_ds_support_reg_seq.start( env1.e_virtual_sequencer);

    //Configuring TM mode
      ll_maintenance_ds_support_reg_seq.mtusize_1 = mtusize_2;
      ll_maintenance_ds_support_reg_seq.tm_mode_1 = tm_mode_2;
      ll_maintenance_ds_support_reg_seq.start( env2.e_virtual_sequencer);

      if (tm_mode_2 >=3)
      begin
        // DS TM credit Packet
        ds_traffic_mgmt_credit_control_seq.TMmode_0 = 4'h2;
        ds_traffic_mgmt_credit_control_seq.start( env2.e_virtual_sequencer);
        // DS TM credit Packet
        ds_traffic_mgmt_credit_control_seq.TMmode_0 = 4'h2;
        ds_traffic_mgmt_credit_control_seq.start( env1.e_virtual_sequencer);
      end

      // Random Packet
      default_seq.TMmode_0 = TMmode_1;
      default_seq.mtusize_1 = mtusize_2;
      default_seq.start( env1.e_virtual_sequencer);
      //Maintainance Write and Read Response packet
      ll_maintenance_wr_resp_req_seq.start(env2.e_virtual_sequencer);
      ll_maintenance_rd_resp_req_seq.start(env2.e_virtual_sequencer);

      #10000ns;
      phase.drop_objection(this);
    
   endtask

endclass


