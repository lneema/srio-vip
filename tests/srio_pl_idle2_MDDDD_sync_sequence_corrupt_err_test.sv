////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. Apl rights reserved
//
// File    :  srio_pl_idle2_MDDDD_sync_sequence_corrupt_err_test.sv
// Project :  srio vip
// Purpose :  To corrupt Sync sequence
// Author  :  Mobiveil
//
////Test for corrupting sync sequence MDDDD.
//Supported by only Gen2 mode.
//with callback to corrupt Idle2 sequence with corrupted Sync sequence MDDDD.
////////////////////////////////////////////////////////////////////////////////

class srio_pl_idle2_MDDDD_sync_sequence_corrupt_err_test extends srio_base_test;

  `uvm_component_utils(srio_pl_idle2_MDDDD_sync_sequence_corrupt_err_test)

    srio_ll_nread_req_seq ll_nread_req_seq;
    
     srio_pl_idle2_MDDDD_sync_sequence_corrupt_callback pl_idle2_MDDDD_sync_sequence_corrupt_callback;

    
  function new(string name, uvm_component parent=null);

    super.new(name, parent);
    pl_idle2_MDDDD_sync_sequence_corrupt_callback = new();
  endfunction

  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase); 
    uvm_callbacks #(srio_pl_idle_gen,srio_pl_idle2_MDDDD_sync_sequence_corrupt_callback )::add(env1.pl_agent.pl_driver.idle_gen,pl_idle2_MDDDD_sync_sequence_corrupt_callback);
   endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);

    ll_nread_req_seq = srio_ll_nread_req_seq::type_id::create("ll_nread_req_seq");

     phase.raise_objection( this );
     ll_nread_req_seq.start( env1.e_virtual_sequencer);
    #5000ns; 
    phase.drop_objection(this);
    
  endtask


endclass

