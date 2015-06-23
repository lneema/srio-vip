////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_pl_gen2_a1_a2_a2_sm_test .sv
// Project :  srio vip
// Purpose :  LANE SYNC STATE MACHINE
// Author  :  Mobiveil
//
// 1.Register callbacks .
// 2.wait for aligned_1 and 2 and 2 for nx and 2x align state changes.
// 3. After state changes wait for aligned .
// 4.After link initialized,send nread packets.
//Supported by only Gen2 mode
//
////////////////////////////////////////////////////////////////////////////////

class srio_pl_gen2_a1_a2_a2_sm_test extends srio_base_test;

  `uvm_component_utils(srio_pl_gen2_a1_a2_a2_sm_test)
  rand bit mode;
  srio_ll_nread_req_seq nread_req_seq;
  srio_pl_gen2_a1_a2_a2_sm_callback pl_gen2_a1_a2_a2_sm_callback_ins;
    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
   pl_gen2_a1_a2_a2_sm_callback_ins = new();
  endfunction
  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
    mode = 1;
      if(mode) 
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_gen2_a1_a2_a2_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[0], pl_gen2_a1_a2_a2_sm_callback_ins);
     endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    env1.pl_agent.pl_config.sync_break_threshold = 15;   //To avoid sync break the Icounter value to be max.
    //env2.pl_agent.pl_config.sync_break_threshold = 15;
     
    nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");

     phase.raise_objection( this );

      if(mode) begin //{
      nread_req_seq.start( env1.e_virtual_sequencer);
      end //}
    #20000ns;
 
    phase.drop_objection(this);
    
  endtask

  
endclass

