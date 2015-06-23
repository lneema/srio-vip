////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_traffic_mgmt_lfc_xoff_xon_test.sv
// Project :  srio vip
// Purpose :  TRAFFIC and LFC test
// Author  :  Mobiveil
//
// 1.Configuring DS TM mode and MTU.
// 2.Send  for DS Traffic management with using data streaming packet and traffic management
// 3.LFC with different priority
////////////////////////////////////////////////////////////////////////////////

class srio_ll_traffic_mgmt_lfc_xoff_xon_test extends srio_base_test;

  `uvm_component_utils(srio_ll_traffic_mgmt_lfc_xoff_xon_test)
  
  rand bit [7:0] mtusize_2;
  rand bit [15:0] pdu_length_2;
  rand bit [3:0] tm_mode_2,TMmode_1;

  srio_ll_ds_traffic_mgmt_specific_cos_xoff_seq  ll_ds_traffic_mgmt_specific_stream_xoff_seq;
  srio_ll_ds_traffic_mgmt_specific_cos_xon_seq   ll_ds_traffic_mgmt_specific_stream_xon_seq;
  srio_ll_lfc_user_gen_xoff_seq  ll_lfc_user_gen_xoff_seq;
  srio_ll_lfc_user_gen_xon_seq   ll_lfc_user_gen_xon_seq;
  srio_ll_user_gen_random_prio_seq  ll_user_gen_seq;
  srio_ll_ds_traffic_seq  ll_ds_traffic_seq;
  srio_ll_maintenance_ds_support_reg_seq ll_maintenance_ds_support_reg_seq;
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);


    env1.tl_agent.tl_config.usr_sourceid_en = TRUE;
    env1.tl_agent.tl_config.usr_destinationid_en = TRUE;
    env1.tl_agent.tl_config.usr_sourceid = 32'h2;
    env1.tl_agent.tl_config.usr_destinationid = 32'h1;
    env2.tl_agent.tl_config.usr_sourceid_en = TRUE;
    env2.tl_agent.tl_config.usr_destinationid_en = TRUE;
    env2.tl_agent.tl_config.usr_sourceid = 32'h1;
    env2.tl_agent.tl_config.usr_destinationid = 32'h2;


    ll_ds_traffic_mgmt_specific_stream_xoff_seq = srio_ll_ds_traffic_mgmt_specific_cos_xoff_seq::type_id::create("ll_ds_traffic_mgmt_specific_stream_xoff_seq");
    ll_ds_traffic_mgmt_specific_stream_xon_seq = srio_ll_ds_traffic_mgmt_specific_cos_xon_seq::type_id::create("ll_ds_traffic_mgmt_specific_stream_xon_seq");
    ll_ds_traffic_seq = srio_ll_ds_traffic_seq::type_id::create("srio_ll_ds_traffic_seq");
    ll_lfc_user_gen_xoff_seq = srio_ll_lfc_user_gen_xoff_seq::type_id::create("ll_lfc_user_gen_xoff_seq");
    ll_lfc_user_gen_xon_seq = srio_ll_lfc_user_gen_xon_seq::type_id::create("ll_lfc_user_gen_xon_seq");
    ll_user_gen_seq = srio_ll_user_gen_random_prio_seq::type_id::create("ll_user_gen_seq");
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

    fork 
    begin 
     fork
       begin

         ll_user_gen_seq.start( env2.e_virtual_sequencer);
       end
       begin
         ll_ds_traffic_seq.start( env2.e_virtual_sequencer);
       end
     join
    end 
    begin 
        wait (env2.ll_agent.ll_config.bfm_tx_pkt_cnt >1 ) ;
        env2.ll_agent.ll_config.block_ll_traffic = TRUE;
        fork
          begin
            ll_lfc_user_gen_xoff_seq.flowid = 7'd4;
            ll_lfc_user_gen_xoff_seq.start( env1.e_virtual_sequencer);
          end
          begin
            ll_ds_traffic_mgmt_specific_stream_xoff_seq.TMOP_rand = TMmode_1;
            ll_ds_traffic_mgmt_specific_stream_xoff_seq.start( env1.e_virtual_sequencer);
          end
        join
        #1000ns;
        env2.ll_agent.ll_config.block_ll_traffic = FALSE;
        #10ns;
        ll_ds_traffic_mgmt_specific_stream_xon_seq.TMOP_rand = TMmode_1;
        ll_ds_traffic_mgmt_specific_stream_xon_seq.start( env1.e_virtual_sequencer);
        #5000ns;
        ll_lfc_user_gen_xon_seq.flowid = 7'd4;
        ll_lfc_user_gen_xon_seq.start( env1.e_virtual_sequencer);
        #5000ns;
        ll_lfc_user_gen_xon_seq.flowid = 7'd2;
        ll_lfc_user_gen_xon_seq.start( env1.e_virtual_sequencer);
        #5000ns;
        ll_lfc_user_gen_xon_seq.flowid = 7'd0;
        ll_lfc_user_gen_xon_seq.start( env1.e_virtual_sequencer);
        #5000ns;
        ll_ds_traffic_mgmt_specific_stream_xon_seq.TMOP_rand = 0;
        ll_ds_traffic_mgmt_specific_stream_xon_seq.start( env1.e_virtual_sequencer);
    end
    join 
    #5000ns;	
    phase.drop_objection(this);
    
  endtask

  
endclass



