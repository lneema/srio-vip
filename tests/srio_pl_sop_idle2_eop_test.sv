////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_sop_idle2_eop_test.sv
// Project :  srio vip
// Purpose :  SOP + IDLE2 + EOP
// Author  :  Mobiveil
// 1.Register callback to corrupt packet with idle.
// 2.Maximum sized nwrite packet is initiated.
////////////////////////////////////////////////////////////////////////////////


class srio_pl_sop_idle2_eop_test extends srio_base_test;

  `uvm_component_utils(srio_pl_sop_idle2_eop_test)
  rand bit [0:11] ackid_0 ;
  rand bit [0:11] param_value_1;
  rand bit set_delim,mode;

  
  srio_ll_nwrite_wrsize_wdptr_req_seq nwrite_req_seq;  
  srio_pl_sop_idle_eop_merg_pkt_cb  pl_sop_idle_eop_merg_pkt_cb ;

    function new(string name, uvm_component parent=null);
    super.new(name, parent);
   pl_sop_idle_eop_merg_pkt_cb = new();
  endfunction
   function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
     pl_sop_idle_eop_merg_pkt_cb.pl_agent_cb = env1.pl_agent;
    uvm_callbacks #(srio_pl_idle_gen,srio_pl_sop_idle_eop_merg_pkt_cb)::add(env1.pl_agent.pl_driver.idle_gen,pl_sop_idle_eop_merg_pkt_cb);
   endfunction 
      task run_phase( uvm_phase phase );
    super.run_phase(phase);
    nwrite_req_seq = srio_ll_nwrite_wrsize_wdptr_req_seq::type_id::create("nwrite_req_seq");
     phase.raise_objection( this );
     #500ns;
       nwrite_req_seq.start( env1.e_virtual_sequencer);
     #20000ns;
    phase.drop_objection(this);
      endtask

endclass

