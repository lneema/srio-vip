////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_ds_s_e_err_test.sv
// Project :  srio vip
// Purpose :  Data streaming test
// Author  :  Mobiveil
//
// Dta streaming with Random test.
//
////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
//              EXPECTED ERROR
//  Start Segment received in a opened context   
//  Continuation seg received in a closed context
//  End seg received in a closed context
//
//
////////////////////////////////////////////////////////////////////////////////
class srio_ll_ds_s_e_err_test extends srio_base_test;

  `uvm_component_utils(srio_ll_ds_s_e_err_test)

  srio_ll_ds_s_e_err_seq ds_s_e_err_seq;
      function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    ds_s_e_err_seq = srio_ll_ds_s_e_err_seq::type_id::create("ds_s_e_err_seq");
      phase.raise_objection( this );
     ds_s_e_err_seq.start( env1.e_virtual_sequencer);

     
   #20000ns;
    phase.drop_objection(this);
    
  endtask
endclass


