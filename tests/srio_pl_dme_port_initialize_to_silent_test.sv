////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_dme_port_initialize_to_silent_test.sv
// Project :  srio vip
// Purpose :  DME training for long run
// Author  :  Mobiveil
//
// Test for DME Training for long run with intermediate reset after Link is initialized
//Supported by only Gen3 mode
//
////////////////////////////////////////////////////////////////////////////////
class srio_pl_dme_port_initialize_to_silent_test extends srio_base_test;
  `uvm_component_utils(srio_pl_dme_port_initialize_to_silent_test)

  srio_ll_nread_req_seq nread_req_seq;

  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

 task run_phase( uvm_phase phase );
    super.run_phase(phase);
	env1.pl_agent.pl_config.brc3_training_mode = 1'b1;
	env2.pl_agent.pl_config.brc3_training_mode = 1'b1;
 
    //Command from ENV1
	env1.pl_agent.pl_config.dme_cmd_kind = DME_CMD_ENABLED;
	env1.pl_agent.pl_config.dme_cmd_type = DME_INCR;
    //Command from ENV2
	env2.pl_agent.pl_config.dme_cmd_kind = DME_CMD_ENABLED;
	env2.pl_agent.pl_config.dme_cmd_type = DME_INCR;

   nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");
   phase.raise_objection( this );

//need to be verified
//       env1.pl_agent.pl_driver.srio_if.srio_rst_n = 1'b0;
//       env2.pl_agent.pl_driver.srio_if.srio_rst_n = 1'b0;
//       #1000ns;
//       env1.pl_agent.pl_driver.srio_if.srio_rst_n = 1'b1;
//       env2.pl_agent.pl_driver.srio_if.srio_rst_n = 1'b1;
  
   nread_req_seq.start( env1.e_virtual_sequencer);
   #20000ns;
   phase.drop_objection(this);
  endtask

endclass


