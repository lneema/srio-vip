////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_pl_gen3_incorrect_lc_flwd_by_sc_cw_test.sv
// Project :  srio vip
// Purpose :  CORRUPTION ORDERED SEQUENCES
// Author  :  Mobiveil
//
// Test for NREAD request class with corrupting Skip Marker fixed value.
// Supported by only  Gen3 mode
//
////////////////////////////////////////////////////////////////////////////////

class srio_pl_gen3_incorrect_lc_flwd_by_sc_cw_test extends srio_base_test;

  `uvm_component_utils(srio_pl_gen3_incorrect_lc_flwd_by_sc_cw_test)

  srio_ll_nread_req_seq nread_req_seq;
  srio_pl_gen3_incorrect_skip_order_lc_flwby_sc_seq_callback pl_gen3_incorrect_skip_order_1_seq_callback;

    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  pl_gen3_incorrect_skip_order_1_seq_callback = new();
  endfunction
  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
    if(env_config1.num_of_lanes == 4) begin //{ 
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_incorrect_skip_order_lc_flwby_sc_seq_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[0], pl_gen3_incorrect_skip_order_1_seq_callback);
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_incorrect_skip_order_lc_flwby_sc_seq_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[1], pl_gen3_incorrect_skip_order_1_seq_callback);
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_incorrect_skip_order_lc_flwby_sc_seq_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[2], pl_gen3_incorrect_skip_order_1_seq_callback);
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_incorrect_skip_order_lc_flwby_sc_seq_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[3], pl_gen3_incorrect_skip_order_1_seq_callback);
    end //}
   else if(env_config1.num_of_lanes == 2) begin //{
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_incorrect_skip_order_lc_flwby_sc_seq_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[0], pl_gen3_incorrect_skip_order_1_seq_callback);
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_incorrect_skip_order_lc_flwby_sc_seq_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[1], pl_gen3_incorrect_skip_order_1_seq_callback);
    end //}
   else if(env_config1.num_of_lanes == 8) begin //{
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_incorrect_skip_order_lc_flwby_sc_seq_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[0], pl_gen3_incorrect_skip_order_1_seq_callback);
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_incorrect_skip_order_lc_flwby_sc_seq_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[1], pl_gen3_incorrect_skip_order_1_seq_callback);
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_incorrect_skip_order_lc_flwby_sc_seq_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[2], pl_gen3_incorrect_skip_order_1_seq_callback);
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_incorrect_skip_order_lc_flwby_sc_seq_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[3], pl_gen3_incorrect_skip_order_1_seq_callback);
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_incorrect_skip_order_lc_flwby_sc_seq_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[4], pl_gen3_incorrect_skip_order_1_seq_callback);
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_incorrect_skip_order_lc_flwby_sc_seq_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[5], pl_gen3_incorrect_skip_order_1_seq_callback);
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_incorrect_skip_order_lc_flwby_sc_seq_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[6], pl_gen3_incorrect_skip_order_1_seq_callback);
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_incorrect_skip_order_lc_flwby_sc_seq_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[7], pl_gen3_incorrect_skip_order_1_seq_callback);
    end //}
   else if(env_config1.num_of_lanes == 16) begin //{
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_incorrect_skip_order_lc_flwby_sc_seq_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[0], pl_gen3_incorrect_skip_order_1_seq_callback);
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_incorrect_skip_order_lc_flwby_sc_seq_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[1], pl_gen3_incorrect_skip_order_1_seq_callback);
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_incorrect_skip_order_lc_flwby_sc_seq_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[2], pl_gen3_incorrect_skip_order_1_seq_callback);
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_incorrect_skip_order_lc_flwby_sc_seq_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[3], pl_gen3_incorrect_skip_order_1_seq_callback);
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_incorrect_skip_order_lc_flwby_sc_seq_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[4], pl_gen3_incorrect_skip_order_1_seq_callback);
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_incorrect_skip_order_lc_flwby_sc_seq_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[5], pl_gen3_incorrect_skip_order_1_seq_callback);
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_incorrect_skip_order_lc_flwby_sc_seq_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[6], pl_gen3_incorrect_skip_order_1_seq_callback);
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_incorrect_skip_order_lc_flwby_sc_seq_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[7], pl_gen3_incorrect_skip_order_1_seq_callback);
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_incorrect_skip_order_lc_flwby_sc_seq_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[8], pl_gen3_incorrect_skip_order_1_seq_callback);
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_incorrect_skip_order_lc_flwby_sc_seq_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[9], pl_gen3_incorrect_skip_order_1_seq_callback);
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_incorrect_skip_order_lc_flwby_sc_seq_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[10], pl_gen3_incorrect_skip_order_1_seq_callback);
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_incorrect_skip_order_lc_flwby_sc_seq_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[11], pl_gen3_incorrect_skip_order_1_seq_callback);
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_incorrect_skip_order_lc_flwby_sc_seq_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[12], pl_gen3_incorrect_skip_order_1_seq_callback);
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_incorrect_skip_order_lc_flwby_sc_seq_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[13], pl_gen3_incorrect_skip_order_1_seq_callback);
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_incorrect_skip_order_lc_flwby_sc_seq_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[14], pl_gen3_incorrect_skip_order_1_seq_callback);
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_incorrect_skip_order_lc_flwby_sc_seq_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[15], pl_gen3_incorrect_skip_order_1_seq_callback);
    end //}
    else  begin //{
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_incorrect_skip_order_lc_flwby_sc_seq_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[0], pl_gen3_incorrect_skip_order_1_seq_callback);
    end //}
       endfunction
    task run_phase( uvm_phase phase );
    super.run_phase(phase);
       
    nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");

     phase.raise_objection( this );

     nread_req_seq.start( env1.e_virtual_sequencer);
    #20000ns;
 
    phase.drop_objection(this);
    
  endtask

  
endclass

