
////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_pl_ns1_ns2_ns3_ns2_ns_sm_all_lanes_test .sv
// Project :  srio vip
// Purpose :   SYNC STATE MACHINE
// Author  :  Mobiveil
//
// 1.Register callbacks .
// 2.wait for no_sync_1 and 2 ,3 and no _sync2 to no_sync 
// 3. After state changes wait for sync.
// 4.After link initialized,send nread packets.
// Supported by only  Gen2 mode
//
////////////////////////////////////////////////////////////////////////////////

class srio_pl_ns1_ns2_ns3_ns2_ns_sm_all_lanes_test extends srio_base_test;

  `uvm_component_utils(srio_pl_ns1_ns2_ns3_ns2_ns_sm_all_lanes_test)
  rand bit mode;
  rand bit [3:0] mode1;
  srio_ll_nread_req_seq nread_req_seq;
  srio_pl_ns1_ns2_ns3_ns2_ns_sm_callback pl_ns1_ns2_ns3_ns2_ns_sm_callback_ins ;
    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
   pl_ns1_ns2_ns3_ns2_ns_sm_callback_ins = new();
  endfunction
    function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
       pl_ns1_ns2_ns3_ns2_ns_sm_callback_ins.pl_agent_cb = env1.pl_agent;
       if(env_config1.num_of_lanes == 1) begin //{ 
       
       uvm_callbacks #(srio_pl_lane_driver, srio_pl_ns1_ns2_ns3_ns2_ns_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[0], pl_ns1_ns2_ns3_ns2_ns_sm_callback_ins);
       
       end //}
       else if (env_config1.num_of_lanes == 2) begin //{ 
      
        uvm_callbacks #(srio_pl_lane_driver, srio_pl_ns1_ns2_ns3_ns2_ns_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[0], pl_ns1_ns2_ns3_ns2_ns_sm_callback_ins);
        uvm_callbacks #(srio_pl_lane_driver, srio_pl_ns1_ns2_ns3_ns2_ns_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[1], pl_ns1_ns2_ns3_ns2_ns_sm_callback_ins);
      
       end //}
       else if (env_config1.num_of_lanes == 4) begin //{ 
       
        uvm_callbacks #(srio_pl_lane_driver, srio_pl_ns1_ns2_ns3_ns2_ns_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[0], pl_ns1_ns2_ns3_ns2_ns_sm_callback_ins);
        uvm_callbacks #(srio_pl_lane_driver, srio_pl_ns1_ns2_ns3_ns2_ns_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[1], pl_ns1_ns2_ns3_ns2_ns_sm_callback_ins);
        uvm_callbacks #(srio_pl_lane_driver, srio_pl_ns1_ns2_ns3_ns2_ns_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[2], pl_ns1_ns2_ns3_ns2_ns_sm_callback_ins);
        uvm_callbacks #(srio_pl_lane_driver, srio_pl_ns1_ns2_ns3_ns2_ns_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[3], pl_ns1_ns2_ns3_ns2_ns_sm_callback_ins);
       
       end //}
       else if (env_config1.num_of_lanes == 8) begin //{
       
        uvm_callbacks #(srio_pl_lane_driver, srio_pl_ns1_ns2_ns3_ns2_ns_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[0], pl_ns1_ns2_ns3_ns2_ns_sm_callback_ins);
        uvm_callbacks #(srio_pl_lane_driver, srio_pl_ns1_ns2_ns3_ns2_ns_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[1], pl_ns1_ns2_ns3_ns2_ns_sm_callback_ins);
        uvm_callbacks #(srio_pl_lane_driver, srio_pl_ns1_ns2_ns3_ns2_ns_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[2], pl_ns1_ns2_ns3_ns2_ns_sm_callback_ins);
        uvm_callbacks #(srio_pl_lane_driver, srio_pl_ns1_ns2_ns3_ns2_ns_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[3], pl_ns1_ns2_ns3_ns2_ns_sm_callback_ins);
        uvm_callbacks #(srio_pl_lane_driver, srio_pl_ns1_ns2_ns3_ns2_ns_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[4], pl_ns1_ns2_ns3_ns2_ns_sm_callback_ins);
        uvm_callbacks #(srio_pl_lane_driver, srio_pl_ns1_ns2_ns3_ns2_ns_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[5], pl_ns1_ns2_ns3_ns2_ns_sm_callback_ins);
        uvm_callbacks #(srio_pl_lane_driver, srio_pl_ns1_ns2_ns3_ns2_ns_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[6], pl_ns1_ns2_ns3_ns2_ns_sm_callback_ins);
        uvm_callbacks #(srio_pl_lane_driver, srio_pl_ns1_ns2_ns3_ns2_ns_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[7], pl_ns1_ns2_ns3_ns2_ns_sm_callback_ins);
       
       end //}
       else  begin //{
       
        uvm_callbacks #(srio_pl_lane_driver, srio_pl_ns1_ns2_ns3_ns2_ns_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[0], pl_ns1_ns2_ns3_ns2_ns_sm_callback_ins);
        uvm_callbacks #(srio_pl_lane_driver, srio_pl_ns1_ns2_ns3_ns2_ns_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[1], pl_ns1_ns2_ns3_ns2_ns_sm_callback_ins);
        uvm_callbacks #(srio_pl_lane_driver, srio_pl_ns1_ns2_ns3_ns2_ns_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[2], pl_ns1_ns2_ns3_ns2_ns_sm_callback_ins);
        uvm_callbacks #(srio_pl_lane_driver, srio_pl_ns1_ns2_ns3_ns2_ns_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[3], pl_ns1_ns2_ns3_ns2_ns_sm_callback_ins);
        uvm_callbacks #(srio_pl_lane_driver, srio_pl_ns1_ns2_ns3_ns2_ns_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[4], pl_ns1_ns2_ns3_ns2_ns_sm_callback_ins);
        uvm_callbacks #(srio_pl_lane_driver, srio_pl_ns1_ns2_ns3_ns2_ns_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[5], pl_ns1_ns2_ns3_ns2_ns_sm_callback_ins);
        uvm_callbacks #(srio_pl_lane_driver, srio_pl_ns1_ns2_ns3_ns2_ns_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[6], pl_ns1_ns2_ns3_ns2_ns_sm_callback_ins);
        uvm_callbacks #(srio_pl_lane_driver, srio_pl_ns1_ns2_ns3_ns2_ns_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[7], pl_ns1_ns2_ns3_ns2_ns_sm_callback_ins);
        uvm_callbacks #(srio_pl_lane_driver, srio_pl_ns1_ns2_ns3_ns2_ns_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[8], pl_ns1_ns2_ns3_ns2_ns_sm_callback_ins);
        uvm_callbacks #(srio_pl_lane_driver, srio_pl_ns1_ns2_ns3_ns2_ns_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[9], pl_ns1_ns2_ns3_ns2_ns_sm_callback_ins);
        uvm_callbacks #(srio_pl_lane_driver, srio_pl_ns1_ns2_ns3_ns2_ns_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[10], pl_ns1_ns2_ns3_ns2_ns_sm_callback_ins);
        uvm_callbacks #(srio_pl_lane_driver, srio_pl_ns1_ns2_ns3_ns2_ns_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[11], pl_ns1_ns2_ns3_ns2_ns_sm_callback_ins);
        uvm_callbacks #(srio_pl_lane_driver, srio_pl_ns1_ns2_ns3_ns2_ns_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[12], pl_ns1_ns2_ns3_ns2_ns_sm_callback_ins);
        uvm_callbacks #(srio_pl_lane_driver, srio_pl_ns1_ns2_ns3_ns2_ns_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[13], pl_ns1_ns2_ns3_ns2_ns_sm_callback_ins);
        uvm_callbacks #(srio_pl_lane_driver, srio_pl_ns1_ns2_ns3_ns2_ns_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[14], pl_ns1_ns2_ns3_ns2_ns_sm_callback_ins);
        uvm_callbacks #(srio_pl_lane_driver, srio_pl_ns1_ns2_ns3_ns2_ns_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[15], pl_ns1_ns2_ns3_ns2_ns_sm_callback_ins);
       
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


