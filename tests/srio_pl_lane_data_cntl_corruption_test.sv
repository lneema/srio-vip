////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_lane_data_cntl_corruption_test.sv
// Project :  srio vip
// Purpose :  Lanes data and control word corruption.
// Author  :  Mobiveil
//
// 
//Test file for IDLE2 csfield corruption error test with nread.
// Supported by only  Gen2 mode lane 2
////////////////////////////////////////////////////////////////////////////////


class srio_pl_lane_data_cntl_corruption_test extends srio_base_test;

  `uvm_component_utils(srio_pl_lane_data_cntl_corruption_test)
  srio_ll_nread_req_seq nread_req_seq;
  srio_pl_data_cntl_corrupt_callback pl_data_cntl_corrupt_callback;

    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  pl_data_cntl_corrupt_callback = new();
  endfunction
  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase); 
    uvm_callbacks #(srio_pl_idle_gen,srio_pl_data_cntl_corrupt_callback)::add(env1.pl_agent.pl_driver.idle_gen,pl_data_cntl_corrupt_callback);
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

 
     
 


