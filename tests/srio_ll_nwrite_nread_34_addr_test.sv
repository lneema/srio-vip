////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_nwrite_nread_34_addr_test .sv
// Project :  srio vip
// Purpose : NWRITE_R AND NREAD_R with 34 bit addressing mode
// Author  :  Mobiveil
//
// NWRITE_R AND NREAD_R with 34 bit addressing mode
//
////////////////////////////////////////////////////////////////////////////////


class srio_ll_nwrite_nread_34_addr_test extends srio_base_test;

  `uvm_component_utils(srio_ll_nwrite_nread_34_addr_test)

  srio_ll_nwrite_nread_34_addr_seq nwrite_r_reg_seq;
    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    nwrite_r_reg_seq = srio_ll_nwrite_nread_34_addr_seq::type_id::create("nwrite_r_reg_seq");
      phase.raise_objection( this );
     nwrite_r_reg_seq.start( env1.e_virtual_sequencer);

      
  #20000ns;

    phase.drop_objection(this);
    
  endtask
endclass


