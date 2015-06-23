////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_gsm_dkill_home_test.sv
// Project :  srio vip
// Purpose :  GSM test 
// Author  :  Mobiveil
//
// Test for DKILL HOME Global Shared Memory Packet .
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_gsm_dkill_home_test extends srio_base_test;

  `uvm_component_utils(srio_ll_gsm_dkill_home_test)

  srio_ll_gsm_dkill_home_seq gsm_dkill_home_seq;

    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    gsm_dkill_home_seq = srio_ll_gsm_dkill_home_seq::type_id::create("gsm_dkill_home_seq");

      phase.raise_objection( this );
     gsm_dkill_home_seq.start( env1.e_virtual_sequencer);
     
  #20000ns;

    phase.drop_objection(this);
    
  endtask


endclass


