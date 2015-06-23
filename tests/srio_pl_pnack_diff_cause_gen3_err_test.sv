////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_pl_pnack_diff_cause_gen3_err_test.sv
// Project :  srio vip
// Purpose :  NREAD
// Author  :  Mobiveil
//
// Test for NREAD request class with callback to corrupt ackid and crc
// Support only gen3
////////////////////////////////////////////////////////////////////////////////

class srio_pl_pnack_diff_cause_gen3_err_test extends srio_base_test;

  `uvm_component_utils(srio_pl_pnack_diff_cause_gen3_err_test)

     rand bit [3:0] tm_mode_2,TMmode_1;
     rand bit [2:0] mode;
     rand bit sel;
     rand bit [7:0] mtusize_2;

`ifdef SRIO_VIP_B2B
     srio_ll_default_seq default_seq;
`else
     srio_ll_standalone_default_seq default_seq;
`endif
     srio_ll_ds_traffic_mgmt_credit_control_seq ds_traffic_mgmt_credit_control_seq;
     srio_ll_maintenance_ds_support_reg_seq ll_maintenance_ds_support_reg_seq;
     srio_pl_pnack_diff_cause_gen3_err_cb pl_pnack_diff_cause_gen3_err_cb; 
     srio_pl_gen3_cwl_descr_seed_skip_order_corrup_cb pl_gen3_cwl_descr_seed_skip_order_corrup_cb;

    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
    pl_pnack_diff_cause_gen3_err_cb = new();
    pl_gen3_cwl_descr_seed_skip_order_corrup_cb = new();
    pl_gen3_cwl_descr_seed_skip_order_corrup_cb.no_cwl_cnt_0 = 0;
    pl_gen3_cwl_descr_seed_skip_order_corrup_cb.no_cwl_cnt_1 = 0;
    pl_gen3_cwl_descr_seed_skip_order_corrup_cb.no_cwl_cnt_2 = 0;
    pl_gen3_cwl_descr_seed_skip_order_corrup_cb.no_cwl_cnt_3 = 0;
    pl_gen3_cwl_descr_seed_skip_order_corrup_cb.no_skip_order_cnt_0 = 0;
    pl_gen3_cwl_descr_seed_skip_order_corrup_cb.no_skip_order_cnt_1 = 0;
    pl_gen3_cwl_descr_seed_skip_order_corrup_cb.no_skip_order_cnt_2 = 0;
    pl_gen3_cwl_descr_seed_skip_order_corrup_cb.no_skip_order_cnt_3 = 0;
    pl_gen3_cwl_descr_seed_skip_order_corrup_cb.no_status_control_cw_cnt_0 = 0;
    pl_gen3_cwl_descr_seed_skip_order_corrup_cb.no_status_control_cw_cnt_1 = 0;
    pl_gen3_cwl_descr_seed_skip_order_corrup_cb.no_status_control_cw_cnt_2 = 0;
    pl_gen3_cwl_descr_seed_skip_order_corrup_cb.no_status_control_cw_cnt_3 = 0;

  endfunction

   function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
     pl_pnack_diff_cause_gen3_err_cb.pl_agent_cb = env1.pl_agent;
    uvm_callbacks #(srio_pl_idle_gen,srio_pl_pnack_diff_cause_gen3_err_cb)::add(env1.pl_agent.pl_driver.idle_gen,pl_pnack_diff_cause_gen3_err_cb);
    if(env_config1.num_of_lanes == 4) begin //{ 
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_cwl_descr_seed_skip_order_corrup_cb)::add(env1.pl_agent.pl_driver.lane_driver_ins[0], pl_gen3_cwl_descr_seed_skip_order_corrup_cb);
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_cwl_descr_seed_skip_order_corrup_cb)::add(env1.pl_agent.pl_driver.lane_driver_ins[1], pl_gen3_cwl_descr_seed_skip_order_corrup_cb);
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_cwl_descr_seed_skip_order_corrup_cb)::add(env1.pl_agent.pl_driver.lane_driver_ins[2], pl_gen3_cwl_descr_seed_skip_order_corrup_cb);
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_cwl_descr_seed_skip_order_corrup_cb)::add(env1.pl_agent.pl_driver.lane_driver_ins[3], pl_gen3_cwl_descr_seed_skip_order_corrup_cb);
    end //}
   else if(env_config1.num_of_lanes == 2) begin //{
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_cwl_descr_seed_skip_order_corrup_cb)::add(env1.pl_agent.pl_driver.lane_driver_ins[0], pl_gen3_cwl_descr_seed_skip_order_corrup_cb);
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_cwl_descr_seed_skip_order_corrup_cb)::add(env1.pl_agent.pl_driver.lane_driver_ins[1], pl_gen3_cwl_descr_seed_skip_order_corrup_cb);
    end //}
   else if(env_config1.num_of_lanes == 1) begin //{
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_cwl_descr_seed_skip_order_corrup_cb)::add(env1.pl_agent.pl_driver.lane_driver_ins[0], pl_gen3_cwl_descr_seed_skip_order_corrup_cb);
    end //}

   endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
       
  `ifdef SRIO_VIP_B2B     
      default_seq = srio_ll_default_seq::type_id::create("default_seq");
`else
      default_seq = srio_ll_standalone_default_seq::type_id::create("default_seq");
`endif

      ds_traffic_mgmt_credit_control_seq = srio_ll_ds_traffic_mgmt_credit_control_seq::type_id::create("ds_traffic_mgmt_credit_control_seq");
      ll_maintenance_ds_support_reg_seq = srio_ll_maintenance_ds_support_reg_seq::type_id::create("ll_maintenance_ds_support_reg_seq");

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
     wait(env_config1.pl_mon_tx_link_initialized == 1);
     wait(env_config1.pl_mon_rx_link_initialized == 1);
     wait(env_config1.link_initialized == 1);
`ifdef SRIO_VIP_B2B
     wait(env_config2.pl_mon_tx_link_initialized == 1);
     wait(env_config2.pl_mon_rx_link_initialized == 1);
     wait(env_config2.link_initialized == 1);
`endif
      pl_pnack_diff_cause_gen3_err_cb.flag = 1;
     //Configuring TM mode 
      ll_maintenance_ds_support_reg_seq.mtusize_1 = mtusize_2;
      ll_maintenance_ds_support_reg_seq.tm_mode_1 = tm_mode_2;
      ll_maintenance_ds_support_reg_seq.start( env1.e_virtual_sequencer);

`ifdef SRIO_VIP_B2B
    //Configuring TM mode
      ll_maintenance_ds_support_reg_seq.mtusize_1 = mtusize_2;
      ll_maintenance_ds_support_reg_seq.tm_mode_1 = tm_mode_2;
      ll_maintenance_ds_support_reg_seq.start( env2.e_virtual_sequencer);
`endif 

      if (tm_mode_2 >=3)
      begin
`ifdef SRIO_VIP_B2B
        // DS TM credit Packet
        ds_traffic_mgmt_credit_control_seq.TMmode_0 = 4'h2;
        ds_traffic_mgmt_credit_control_seq.start( env2.e_virtual_sequencer);
`endif 
        // DS TM credit Packet
        ds_traffic_mgmt_credit_control_seq.TMmode_0 = 4'h2;
        ds_traffic_mgmt_credit_control_seq.start( env1.e_virtual_sequencer);
      end
`ifdef SRIO_VIP_B2B
      // Random Packet
      default_seq.TMmode_0 = TMmode_1;
      default_seq.mtusize_1 = mtusize_2;
      default_seq.start( env1.e_virtual_sequencer);
`else
      default_seq.mtusize_1 = mtusize_2;
      default_seq.start( env1.e_virtual_sequencer);
`endif
      #50000ns;
      phase.drop_objection(this);
    
  endtask

  
endclass
