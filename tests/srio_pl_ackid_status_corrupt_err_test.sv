////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_pl_ackid_status_corrupt_err_test.sv
// Project :  srio vip
// Purpose :  NREAD
// Author  :  Mobiveil
//
// Test for CS ackid status corrupt after link init for GEN2
//
////////////////////////////////////////////////////////////////////////////////

class srio_pl_ackid_status_corrupt_err_test extends srio_base_test;

  `uvm_component_utils(srio_pl_ackid_status_corrupt_err_test)

  srio_pl_ackid_status_corrupt_cb pl_ackid_status_corrupt_cb; 
    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
    pl_ackid_status_corrupt_cb = new();
  endfunction

   function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
    pl_ackid_status_corrupt_cb.pl_agent_cb = env1.pl_agent;
    uvm_callbacks #(srio_pl_idle_gen,srio_pl_ackid_status_corrupt_cb)::add(env1.pl_agent.pl_driver.idle_gen,pl_ackid_status_corrupt_cb);
   endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);

     phase.raise_objection( this );
     #1000ns;
     wait(env_config1.pl_mon_tx_link_initialized == 1);	 
     wait(env_config1.pl_mon_rx_link_initialized == 1);	 
     wait(env_config1.link_initialized == 1);	 
     pl_ackid_status_corrupt_cb.flag = 1;

    #2000ns;
 
    phase.drop_objection(this);
    
  endtask

  
endclass


