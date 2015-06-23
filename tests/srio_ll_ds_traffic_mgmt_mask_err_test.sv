////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_ds_traffic_mgmt_mask_err_test.sv
// Project :  srio vip
// Purpose :  Inavalid mask test
// Author  :  Mobiveil
//
// Test for DS Traffic management with Invalid mask value in xoff packet
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_ds_traffic_mgmt_mask_err_test extends srio_base_test;

  `uvm_component_utils(srio_ll_ds_traffic_mgmt_mask_err_test)

  srio_ll_ds_traffic_mgmt_mask_err_seq  ll_ds_traffic_mgmt_mask_err_seq;


  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);


    env1.tl_agent.tl_config.usr_sourceid_en = TRUE;
    env1.tl_agent.tl_config.usr_destinationid_en = TRUE;
    env1.tl_agent.tl_config.usr_sourceid = 32'h4F;
    env1.tl_agent.tl_config.usr_destinationid = 32'h5F;
`ifdef SRIO_VIP_B2B
    env2.tl_agent.tl_config.usr_sourceid_en = TRUE;
    env2.tl_agent.tl_config.usr_destinationid_en = TRUE;
    env2.tl_agent.tl_config.usr_sourceid = 32'h5F;
    env2.tl_agent.tl_config.usr_destinationid = 32'h4F;
`endif


    ll_ds_traffic_mgmt_mask_err_seq = srio_ll_ds_traffic_mgmt_mask_err_seq::type_id::create("ll_ds_traffic_mgmt_mask_err_seq");

    phase.raise_objection( this );
       begin 
          ll_ds_traffic_mgmt_mask_err_seq.start( env1.e_virtual_sequencer);
       end
    #1000ns;
   phase.drop_objection(this);
    
  endtask

  
endclass


