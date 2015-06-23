////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_pl_gen3_cwl_descr_seed_skip_order_rand_corrupt_test.sv
// Project :  srio vip
// Purpose :  CORRUPTION CODEWORD LOCK - DESCRAMBLER SEED - SKIP ORDER MARKER
// Author  :  Mobiveil
//
// Test for NREAD request class with corrupting Skip Marker fixed value.
// Supported by only  Gen3 mode
//
////////////////////////////////////////////////////////////////////////////////

class srio_pl_gen3_cwl_descr_seed_skip_order_rand_corrupt_test extends srio_base_test;

  `uvm_component_utils(srio_pl_gen3_cwl_descr_seed_skip_order_rand_corrupt_test)

  srio_ll_standalone_nread_req_seq nread_req_seq;
  srio_pl_gen3_cwl_descr_seed_skip_order_rand_corrup_cb pl_gen3_cwl_descr_seed_skip_order_corrup_cb;

    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  pl_gen3_cwl_descr_seed_skip_order_corrup_cb = new();
  endfunction
  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
    if(env_config1.num_of_lanes == 4) begin //{ 
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_cwl_descr_seed_skip_order_rand_corrup_cb)::add(env1.pl_agent.pl_driver.lane_driver_ins[0], pl_gen3_cwl_descr_seed_skip_order_corrup_cb);
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_cwl_descr_seed_skip_order_rand_corrup_cb)::add(env1.pl_agent.pl_driver.lane_driver_ins[1], pl_gen3_cwl_descr_seed_skip_order_corrup_cb);
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_cwl_descr_seed_skip_order_rand_corrup_cb)::add(env1.pl_agent.pl_driver.lane_driver_ins[2], pl_gen3_cwl_descr_seed_skip_order_corrup_cb);
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_cwl_descr_seed_skip_order_rand_corrup_cb)::add(env1.pl_agent.pl_driver.lane_driver_ins[3], pl_gen3_cwl_descr_seed_skip_order_corrup_cb);
    end //}
   else if(env_config1.num_of_lanes == 2) begin //{
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_cwl_descr_seed_skip_order_rand_corrup_cb)::add(env1.pl_agent.pl_driver.lane_driver_ins[0], pl_gen3_cwl_descr_seed_skip_order_corrup_cb);
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_cwl_descr_seed_skip_order_rand_corrup_cb)::add(env1.pl_agent.pl_driver.lane_driver_ins[1], pl_gen3_cwl_descr_seed_skip_order_corrup_cb);
    end //}
   else if(env_config1.num_of_lanes == 1) begin //{
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_cwl_descr_seed_skip_order_rand_corrup_cb)::add(env1.pl_agent.pl_driver.lane_driver_ins[0], pl_gen3_cwl_descr_seed_skip_order_corrup_cb);
    end //}

       endfunction
    task run_phase( uvm_phase phase );
    super.run_phase(phase);
       
    nread_req_seq = srio_ll_standalone_nread_req_seq::type_id::create("nread_req_seq");

     phase.raise_objection( this );
     wait(env_config1.pl_mon_tx_link_initialized == 1);
     wait(env_config1.pl_mon_rx_link_initialized == 1);
     wait(env_config1.link_initialized == 1);
    // wait(env_config2.pl_mon_tx_link_initialized == 1);
    // wait(env_config2.pl_mon_rx_link_initialized == 1);
    // wait(env_config2.link_initialized == 1);
     nread_req_seq.num_of_pkt_0 = 100;
     nread_req_seq.start( env1.e_virtual_sequencer);
    #200000ns;
 
    phase.drop_objection(this);
    
  endtask

  
endclass

