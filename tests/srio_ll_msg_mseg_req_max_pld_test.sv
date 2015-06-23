////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_msg_mseg_req_max_pld_test.sv
// Project :  srio vip
// Purpose :  Base test
// Author  :  Mobiveil
//
// Data Message with Maximum payload and segment size.
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_msg_mseg_req_max_pld_test extends srio_base_test;

  `uvm_component_utils(srio_ll_msg_mseg_req_max_pld_test)
   srio_ll_msg_mseg_max_req_seq ll_msg_mseg_max_req_seq;
  
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction
 
    task run_phase( uvm_phase phase );
    super.run_phase(phase);

   ll_msg_mseg_max_req_seq = srio_ll_msg_mseg_max_req_seq::type_id::create("ll_msg_mseg_max_req_seq"); 

     phase.raise_objection( this );
     ll_msg_mseg_max_req_seq.start( env1.e_virtual_sequencer);
    #5000ns;
 
    phase.drop_objection(this);
    
  endtask

endclass
