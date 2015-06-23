////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_db_pkt_ratio_test .sv
// Project :  srio vip
// Purpose : DB Packet Ratio test  
// Author  :  Mobiveil
//
// 1. Set weighted round robin .
// 2. set the ratio value.
// 3. Send Credit base traffic management ,if traffic management get selected ,then to write in register value.
// 4.send default sequence.
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_db_pkt_ratio_test extends srio_base_test;

     `uvm_component_utils(srio_ll_db_pkt_ratio_test)

     rand bit [3:0] tm_mode_2,TMmode_1;
     rand bit [2:0] mode;
     rand bit sel;
     rand bit [7:0] mtusize_2;

     srio_ll_default_seq default_seq;
     srio_ll_ds_traffic_mgmt_credit_control_seq     ds_traffic_mgmt_credit_control_seq;
     srio_ll_maintenance_ds_support_reg_seq ll_maintenance_ds_support_reg_seq;  
     function new(string name, uvm_component parent=null);
       super.new(name, parent);
     endfunction

     task run_phase( uvm_phase phase );
    super.run_phase(phase);
      env1.ll_agent.ll_config.arb_type = SRIO_LL_WRR ; 
      env1.ll_agent.ll_config.interleaved_pkt = TRUE;
         
      env1.ll_agent.ll_config.io_pkt_ratio =0;
      env1.ll_agent.ll_config.db_pkt_ratio = 100;
      env1.ll_agent.ll_config.msg_pkt_ratio = 0;
      env1.ll_agent.ll_config.ds_pkt_ratio = 0;
      env1.ll_agent.ll_config.gsm_pkt_ratio = 0;
      env1.ll_agent.ll_config.lfc_pkt_ratio = 0;
      default_seq = srio_ll_default_seq::type_id::create("default_seq");
      phase.raise_objection( this );
      ds_traffic_mgmt_credit_control_seq = srio_ll_ds_traffic_mgmt_credit_control_seq::type_id::create("ds_traffic_mgmt_credit_control_seq");
      ll_maintenance_ds_support_reg_seq = srio_ll_maintenance_ds_support_reg_seq::type_id::create("ll_maintenance_ds_support_reg_seq");

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

`ifdef SRIO_VIP_B2B
    //Configuring TM mode
      ll_maintenance_ds_support_reg_seq.mtusize_1 = mtusize_2;
      ll_maintenance_ds_support_reg_seq.tm_mode_1 = tm_mode_2;
      ll_maintenance_ds_support_reg_seq.start( env2.e_virtual_sequencer);

      if (tm_mode_2 >=3)
      begin
        // DS TM credit Packet
        ds_traffic_mgmt_credit_control_seq.TMmode_0 = 4'h2;
        ds_traffic_mgmt_credit_control_seq.start( env2.e_virtual_sequencer);
      end
`endif
     
      default_seq.TMmode_0 = TMmode_1;
      default_seq.mtusize_1 = mtusize_2;

      default_seq.start( env1.e_virtual_sequencer);
      #50000ns;
      phase.drop_objection(this);
    
     endtask

endclass


