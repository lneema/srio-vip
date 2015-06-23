
////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_traffic_mgmt_tm_type_mode_err_test .sv
// Project :  srio vip
// Purpose : Test for Trafffic management TM type and mode error 
// Author  :  Mobiveil
//
// Test for Trafffic management TM type and mode error
//
////////////////////////////////////////////////////////////////////////////////


class srio_ll_traffic_mgmt_tm_type_mode_err_test extends srio_base_test;

  `uvm_component_utils(srio_ll_traffic_mgmt_tm_type_mode_err_test)

  srio_ll_traffic_mgmt_tm_type_mode_err_seq ll_traffic_mgmt_tm_type_mode_err_seq;
    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    ll_traffic_mgmt_tm_type_mode_err_seq = srio_ll_traffic_mgmt_tm_type_mode_err_seq ::type_id::create("ll_traffic_mgmt_tm_type_mode_err_seq");
      phase.raise_objection( this );
     ll_traffic_mgmt_tm_type_mode_err_seq.start( env1.e_virtual_sequencer);

      
   #20000ns;
    phase.drop_objection(this);
    
  
endtask

endclass


