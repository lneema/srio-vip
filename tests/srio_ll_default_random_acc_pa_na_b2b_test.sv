////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_default_random_acc_pa_na_b2b_test.sv
// Project : srio vip
// Purpose : Default test  
// Author  : Mobiveil
//
// 1.Configuring DS TM mode and MTU
// 2.Send credit packet from other side ,if credit mode is generated in random 
//  sequences.
// 3.Configuring pl_config packet accepted and packet not accepted ratio for both env's
// 4.Configuring pkt_acc_gen_kind and  pl_response_gen_mode to random
// 5.Generate Random sequence 
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_default_random_acc_pa_na_b2b_test extends srio_base_test;

     `uvm_component_utils(srio_ll_default_random_acc_pa_na_b2b_test)

     rand bit [3:0] tm_mode_2,TMmode_1;
     rand bit [2:0] mode;
     rand bit sel;
     rand bit [7:0] mtusize_2;

     srio_ll_default_seq default_seq;
     srio_ll_ds_traffic_mgmt_credit_control_seq ds_traffic_mgmt_credit_control_seq;
     srio_ll_maintenance_ds_support_reg_seq ll_maintenance_ds_support_reg_seq;
 
     function new(string name, uvm_component parent=null);
       super.new(name, parent);
     endfunction

     task run_phase( uvm_phase phase );
    super.run_phase(phase);
     
      default_seq = srio_ll_default_seq::type_id::create("default_seq");

      ds_traffic_mgmt_credit_control_seq = srio_ll_ds_traffic_mgmt_credit_control_seq::type_id::create("ds_traffic_mgmt_credit_control_seq");
      ll_maintenance_ds_support_reg_seq = srio_ll_maintenance_ds_support_reg_seq::type_id::create("ll_maintenance_ds_support_reg_seq");
     // Configuring PL ack and response kind to random
       env_config1.pl_config.pkt_acc_gen_kind = PL_RANDOM; 
       env_config2.pl_config.pkt_acc_gen_kind = PL_RANDOM;  
       env_config1.pl_config.pl_response_gen_mode = PL_PKT_RANDOM; 
       env_config2.pl_config.pl_response_gen_mode = PL_PKT_RANDOM; 
       env_config1.pl_config.pkt_ack_delay_min = 100; 
       env_config2.pl_config.pkt_ack_delay_min = 100; 
       env_config1.pl_config.pkt_ack_delay_max = 200; 
       env_config2.pl_config.pkt_ack_delay_max = 200;  
       env_config1.pl_config.pl_response_delay_min = 110; 
       env_config2.pl_config.pl_response_delay_min = 110; 
       env_config1.pl_config.pl_response_delay_max = 210; 
       env_config2.pl_config.pl_response_delay_max = 210;  
    // Configuring pl_config packet accepted and packet not accepted ratio
      env1.pl_agent.pl_config.pkt_accept_prob=50;
      env1.pl_agent.pl_config.pkt_na_prob=50;     
      env2.pl_agent.pl_config.pkt_accept_prob=50;
      env2.pl_agent.pl_config.pkt_na_prob=50;

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
      #50000ns;
      phase.drop_objection(this);
    
     endtask
  
endclass
