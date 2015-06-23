////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_tl_ds_scrid_err_cb_test.sv
// Project :  srio vip
// Purpose :  Source ID corruption
// Author  :  Mobiveil
//
// Source ID corruption using callback
//
////////////////////////////////////////////////////////////////////////////////

class srio_tl_ds_scrid_err_cb_test extends srio_base_test;

  `uvm_component_utils(srio_tl_ds_scrid_err_cb_test)

   srio_ll_maintenance_ds_seq maintenance_ds_seq;
  
  srio_tl_ds_tx_scrid_err_cb tl_tx_ds_scrid_err_cb_ins;

  function new(string name, uvm_component parent=null);
    super.new(name, parent);
    tl_tx_ds_scrid_err_cb_ins = new();
  endfunction

  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);

    
    uvm_callbacks #(srio_tl_generator,srio_tl_ds_tx_scrid_err_cb)::add(env1.tl_agent.tl_bfm.tl_generator, tl_tx_ds_scrid_err_cb_ins);

  endfunction

      
    task run_phase( uvm_phase phase );
    super.run_phase(phase);

    
    maintenance_ds_seq = srio_ll_maintenance_ds_seq::type_id::create("maintenance_ds_seq");

     phase.raise_objection( this );
     maintenance_ds_seq.start( env1.e_virtual_sequencer);
    #20000ns;
 
    phase.drop_objection(this);
    
  endtask

  endclass

