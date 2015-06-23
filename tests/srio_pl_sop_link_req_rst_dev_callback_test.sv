////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_sop_link_req_rst_dev_callback_test.sv
// Project :  srio vip
// Purpose :  SOP-- LINK REQUEST RESET
// Author  :  Mobiveil
// 1.Register callback
// 2. Send IO --  here EOP get corrupt using callback and changed to link request reset device CS.
////////////////////////////////////////////////////////////////////////////////


class srio_pl_sop_link_req_rst_dev_callback_test extends srio_base_test;

  `uvm_component_utils(srio_pl_sop_link_req_rst_dev_callback_test)
  rand bit [0:11] ackid_0 ;

  
  srio_pl_ll_io_random_seq  pl_ll_io_random_seq;  
  srio_pl_sop_link_req_rst_dev_callback  pl_sop_link_req_rst_dev_callback ;
    function new(string name, uvm_component parent=null);
    super.new(name, parent);
   pl_sop_link_req_rst_dev_callback = new();
  endfunction
   function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
     pl_sop_link_req_rst_dev_callback.pl_agent_cb = env1.pl_agent;
    uvm_callbacks #(srio_pl_idle_gen,srio_pl_sop_link_req_rst_dev_callback )::add(env1.pl_agent.pl_driver.idle_gen,pl_sop_link_req_rst_dev_callback);
   endfunction 
      task run_phase( uvm_phase phase );
    super.run_phase(phase);
      pl_ll_io_random_seq = srio_pl_ll_io_random_seq::type_id::create("pl_ll_io_random_seq");
     phase.raise_objection( this );
     pl_ll_io_random_seq.start( env1.e_virtual_sequencer);
     #2000ns;
    phase.drop_objection(this);
      endtask


endclass


