////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_ds_all_traffic_credit_xoff_xon_test.sv
// Project :  srio vip
// Purpose :  FOR all traffic
// Author  :  Mobiveil
//
//    <DestID = xx ><cos= xx ><streamid = xx > + <wc = 111> + <m = xx>
// 1.Configuring DS TM mode and MTU.
// 2.Send  for DS Traffic management with using data streaming packet and traffic management
// 3.Credit XOFF and XON packet.
//////////////////////////////////////////////////////////////////////////

class srio_ll_ds_all_traffic_credit_xoff_xon_test extends srio_base_test;

  `uvm_component_utils(srio_ll_ds_all_traffic_credit_xoff_xon_test)

  rand bit [7:0] mtusize_2;
  rand bit [15:0] pdu_length_2;
  rand bit [3:0] tm_mode_2,TMmode_1;
  

  srio_ll_ds_all_traffic_xoff_seq  ll_ds_all_traffic_xoff_seq;
  srio_ll_ds_all_traffic_xon_seq   ll_ds_all_traffic_xon_seq;
  srio_ll_ds_all_traffic_seq  ll_ds_all_traffic_seq;
  srio_ll_maintenance_ds_support_reg_seq ll_maintenance_ds_support_reg_seq;
  srio_ll_ds_all_traffic_mgmt_credit_control_seq ds_all_traffic_mgmt_credit_control_seq;
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);

    ll_ds_all_traffic_xoff_seq = srio_ll_ds_all_traffic_xoff_seq::type_id::create("ll_ds_all_traffic_xoff_seq");
    ll_ds_all_traffic_xon_seq = srio_ll_ds_all_traffic_xon_seq::type_id::create("ll_ds_all_traffic_xon_seq");
    ll_ds_all_traffic_seq = srio_ll_ds_all_traffic_seq::type_id::create("ll_ds_all_traffic_seq");
    ll_maintenance_ds_support_reg_seq = srio_ll_maintenance_ds_support_reg_seq::type_id::create("ll_maintenance_ds_support_reg_seq");
    ds_all_traffic_mgmt_credit_control_seq = srio_ll_ds_all_traffic_mgmt_credit_control_seq::type_id::create("ds_all_traffic_mgmt_credit_control_seq");
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
      ds_all_traffic_mgmt_credit_control_seq.TMmode_0 = TMmode_1;
      ds_all_traffic_mgmt_credit_control_seq.start( env1.e_virtual_sequencer);
     // DS AND TRAFFIC Credit PACKET
    fork 
    begin 
    ll_ds_all_traffic_seq.mtusize_1 = mtusize_2;
    ll_ds_all_traffic_seq.pdu_length_1 = pdu_length_2;
    ll_ds_all_traffic_seq.start( env2.e_virtual_sequencer);
    end 
    begin 
     wait (env2.ll_agent.ll_config.bfm_tx_pkt_cnt > 5);
     env2.ll_agent.ll_config.block_ll_traffic = TRUE;
     ll_ds_all_traffic_xoff_seq.TMOP_rand =TMmode_1; 
     ll_ds_all_traffic_xoff_seq.start( env1.e_virtual_sequencer);
   
     #100ns;
    env2.ll_agent.ll_config.block_ll_traffic = FALSE;
    #1000ns; 
    ll_ds_all_traffic_xon_seq.TMOP_rand =TMmode_1;
    ll_ds_all_traffic_xon_seq.start( env1.e_virtual_sequencer);

    end

    join
#5000ns;
  
       phase.drop_objection(this);
    
  endtask
  

  
endclass

