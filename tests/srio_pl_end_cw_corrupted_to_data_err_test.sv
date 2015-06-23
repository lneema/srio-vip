////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_end_cw_corrupted_to_data_err_test.sv
// Project :  srio vip
// Purpose :  End code word corrupted to Data
// Author  :  Mobiveil
//
// Tests for corrupted code word,received DATA cw instead of CSE or CSEB
// Supported by only  Gen3 mode
////////////////////////////////////////////////////////////////////////////////

class srio_pl_end_cw_corrupted_to_data_err_test extends srio_base_test;

  `uvm_component_utils(srio_pl_end_cw_corrupted_to_data_err_test)

   srio_ll_nread_req_seq nread_req_seq; 
  //callback handle 
   srio_pl_end_cw_corrupted_to_data_err_cb pl_end_cw_corrupted_to_data_err_cb;
   
  function new(string name, uvm_component parent=null);
    super.new(name, parent);

  pl_end_cw_corrupted_to_data_err_cb = new();
    
  endfunction 
              
  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
    
  uvm_callbacks #(srio_pl_lane_driver, srio_pl_end_cw_corrupted_to_data_err_cb)::add(env1.pl_agent.pl_driver.lane_driver_ins[0], pl_end_cw_corrupted_to_data_err_cb);
    endfunction

     task run_phase( uvm_phase phase );
    super.run_phase(phase);

     nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");

     phase.raise_objection( this );
     nread_req_seq.start( env1.e_virtual_sequencer);
     #2000ns;
     phase.drop_objection(this);
    
  endtask

  

endclass

