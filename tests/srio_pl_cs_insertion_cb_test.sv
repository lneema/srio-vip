////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_pl_cs_insertion_cb_test.sv
// Project :  srio vip
// Purpose :  NREAD
// Author  :  Mobiveil
//
// Test for CS insertion
//
////////////////////////////////////////////////////////////////////////////////

class srio_pl_cs_insertion_cb_test extends srio_base_test;

  `uvm_component_utils(srio_pl_cs_insertion_cb_test)

  srio_pl_cs_insertion_callback pl_cs_insertion_callback;
    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
    pl_cs_insertion_callback = new();
  endfunction


  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase); 
    uvm_callbacks #(srio_pl_idle_gen,srio_pl_cs_insertion_callback )::add(env1.pl_agent.pl_driver.idle_gen,pl_cs_insertion_callback);
   endfunction


    task run_phase( uvm_phase phase );
    // Error Demotion
    severity_modifier severity_modifier1 = new;
    severity_modifier1.config_severity("SRIO_PL_RX_DATA_HANDLER : IDLE2_SEQUENCE_MIN_PSR_DATA_LENGTH_CHECK", UVM_WARNING);
    severity_modifier1.config_severity("SRIO_PL_RX_DATA_HANDLER : IDLE2_SEQUENCE_FIRST_PSR_DATA_MIN_SPACING_CHECK", UVM_WARNING);
    severity_modifier1.config_severity("SRIO_PL_RX_DATA_HANDLER : IDLE2_SEQUENCE_AM_CHAR_MAX_SPACING_CHECK", UVM_WARNING);
    severity_modifier1.config_severity("SRIO_PL_LANE_HANDLER : CG_BETWEEN_CLK_COMP_CHECK", UVM_WARNING);
    uvm_report_cb::add(null, severity_modifier1);
    super.run_phase(phase);
       
     phase.raise_objection( this );
    #500us;
 
    phase.drop_objection(this);
    
  endtask

  
endclass


