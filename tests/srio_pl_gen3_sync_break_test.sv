////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_pl_gen3_sync_break_test.sv
// Project :  srio vip
// Purpose :  NREAD
// Author  :  Mobiveil
//
// Test for NREAD request class
//
////////////////////////////////////////////////////////////////////////////////

class srio_pl_gen3_sync_break_test extends srio_base_test;

  `uvm_component_utils(srio_pl_gen3_sync_break_test)
  rand bit mode;
  rand bit [3:0] mode1;

  srio_ll_nread_req_seq nread_req_seq;
  srio_pl_gen3_sync_break_callback pl_gen3_sync_break_callback;
    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
    pl_gen3_sync_break_callback = new();
  endfunction

  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
       mode = 1;
       if(mode) begin //{
       if(env_config1.num_of_lanes == 1) begin //{ 
       mode1 = $urandom_range(32'h2,32'h0);
       case(mode1) //{
    
       4'h0  :  uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_sync_break_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[0], pl_gen3_sync_break_callback);
       4'h1  :  uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_sync_break_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[1], pl_gen3_sync_break_callback);
       4'h2  :  uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_sync_break_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[2], pl_gen3_sync_break_callback); 
       endcase //}
       end //}
       else if (env_config1.num_of_lanes == 2) begin //{ 
       mode1 = $urandom_range(32'h1,32'h0);
       case(mode1) //{
       4'h0  :  uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_sync_break_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[0], pl_gen3_sync_break_callback);
       4'h1  :  uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_sync_break_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[1], pl_gen3_sync_break_callback);
       endcase //}
       end //}
       else if (env_config1.num_of_lanes == 4) begin //{ 
       mode1 =  $urandom_range(32'h3,32'h0);
       case(mode1) //{
       4'h0  :  uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_sync_break_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[0], pl_gen3_sync_break_callback);
       4'h1  :  uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_sync_break_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[1], pl_gen3_sync_break_callback);
       4'h2  :  uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_sync_break_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[2], pl_gen3_sync_break_callback);
       4'h3  :  uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen3_sync_break_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[3], pl_gen3_sync_break_callback);
       endcase //}
       end //}
    end //}
   endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
       
    nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");

     phase.raise_objection( this );
     wait(env_config1.pl_mon_tx_link_initialized == 1);	 
     wait(env_config1.pl_mon_rx_link_initialized == 1);	 
     wait(env_config1.link_initialized == 1);	
     nread_req_seq.start( env1.e_virtual_sequencer);
     #1000ns;
     if(env_config1.num_of_lanes == 1) begin //{ 
     pl_gen3_sync_break_callback.flag_0 = 1;
     pl_gen3_sync_break_callback.flag_1 = 1;
     pl_gen3_sync_break_callback.flag_2 = 1;
     end //}
     if(env_config1.num_of_lanes == 2) begin //{ 
     pl_gen3_sync_break_callback.flag_0 = 1;
     pl_gen3_sync_break_callback.flag_1 = 1;
     end //}
     if(env_config1.num_of_lanes == 4) begin //{ 
     pl_gen3_sync_break_callback.flag_0 = 1;
     pl_gen3_sync_break_callback.flag_1 = 1;
     pl_gen3_sync_break_callback.flag_2 = 1;
     pl_gen3_sync_break_callback.flag_3 = 1;
     end //}

     wait(env_config1.pl_mon_tx_link_initialized == 1);	 
     wait(env_config1.pl_mon_rx_link_initialized == 1);	 
     wait(env_config1.link_initialized == 1);	
     nread_req_seq.start( env1.e_virtual_sequencer);
     #20000ns;
 
    phase.drop_objection(this);
    
  endtask

  
endclass


