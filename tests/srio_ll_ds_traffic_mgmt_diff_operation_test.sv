
////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_ds_traffic_mgmt_diff_operation_test .sv
// Project :  srio vip
// Purpose : TM with different operations w.r.t parameter1 and parameter2
// Author  :  Mobiveil
//
// Test for Trafffic management TRAFFIC MANAGEMENT FOR queue status,reduce,increase,double,credit,allocate
//
////////////////////////////////////////////////////////////////////////////////


class srio_ll_ds_traffic_mgmt_diff_operation_test extends srio_base_test;

  `uvm_component_utils(srio_ll_ds_traffic_mgmt_diff_operation_test)

  srio_ll_ds_traffic_mgmt_diff_operation_seq ll_ds_traffic_mgmt_diff_operation_seq;
    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    ll_ds_traffic_mgmt_diff_operation_seq = srio_ll_ds_traffic_mgmt_diff_operation_seq::type_id::create("ll_ds_traffic_mgmt_diff_operation_seq");
      phase.raise_objection( this );
     ll_ds_traffic_mgmt_diff_operation_seq.start( env1.e_virtual_sequencer);

      
   #20000ns;
    phase.drop_objection(this);
    
  endtask

endclass


