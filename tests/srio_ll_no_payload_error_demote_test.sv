////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_no_payload_error_demote_test .sv
// Project :  srio vip
// Purpose :  Payload ERROR demotion
// Author  :  Mobiveil
//
// Example for Error demotion
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_no_payload_error_demote_test extends srio_base_test;
  `uvm_component_utils(srio_ll_no_payload_error_demote_test)
  srio_ll_no_payload_error_seq no_payload_error_seq;
    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

  task run_phase( uvm_phase phase );
    // Error Demotion
    severity_modifier severity_modifier1 = new;
    severity_modifier1.config_severity("SRIO_LL_PROTOCOL_CHECKER:NO_PAYLOAD_ERR", UVM_WARNING);
    uvm_report_cb::add(null, severity_modifier1);
    super.run_phase(phase);

    no_payload_error_seq = srio_ll_no_payload_error_seq::type_id::create("no_payload_error_seq");
    phase.raise_objection( this );
    no_payload_error_seq.start( env1.e_virtual_sequencer);
    #20000ns;
    phase.drop_objection(this);
  endtask
endclass

// =============================================================================
