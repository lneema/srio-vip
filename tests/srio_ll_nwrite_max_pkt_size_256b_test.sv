////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_nwrite_max_pkt_size_256b_test .sv
// Project :  srio vip
// Purpose :  Nwrite_r
// Author  :  Mobiveil
//
// Test for NWRITE request class with maximum payload size of 256 bytes
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_nwrite_max_pkt_size_256b_test extends srio_base_test;

  `uvm_component_utils(srio_ll_nwrite_max_pkt_size_256b_test)

  srio_ll_nwrite_max_pkt_size_class_vseq nwrite_req_seq;
    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    nwrite_req_seq = srio_ll_nwrite_max_pkt_size_class_vseq::type_id::create("nwrite_req_seq");
      phase.raise_objection( this );
     wait(env_config1.pl_mon_tx_link_initialized == 1);
     wait(env_config1.pl_mon_rx_link_initialized == 1);
     wait(env_config2.pl_mon_tx_link_initialized == 1);
     wait(env_config2.pl_mon_rx_link_initialized == 1);
     wait(env_config1.link_initialized == 1);
     wait(env_config2.link_initialized == 1);
     nwrite_req_seq.start( env1.e_virtual_sequencer);

      
  #20000ns;

    phase.drop_objection(this);
    
  endtask


endclass


