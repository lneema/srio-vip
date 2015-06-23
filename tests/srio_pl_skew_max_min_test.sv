
////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_pl_skew_max_min_test .sv
// Project :  srio vip
// Purpose :  NREAD
// Author  :  Mobiveil
//
// 1.Configure Skew max and min value for all lanes.
// 2 .Send  NREAD request class
//Supported by only Gen2 mode
//
////////////////////////////////////////////////////////////////////////////////

class srio_pl_skew_max_min_test extends srio_base_test;

  `uvm_component_utils(srio_pl_skew_max_min_test)

   rand int skew_min_value,i;
   
   srio_ll_nread_req_seq nread_req_seq;

    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);

    env1.pl_agent.pl_config.skew_en = 16'hFFFF;

    for(i=0;i<16;i++) begin //{
    skew_min_value = $urandom_range(32'd70,32'd0);
    env1.pl_agent.pl_config.skew_min[i] = skew_min_value;
    env1.pl_agent.pl_config.skew_max[i] = $urandom_range(70,skew_min_value);
    end //}

    nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");

     phase.raise_objection( this );
     nread_req_seq.start( env1.e_virtual_sequencer);
    #2000ns;
 
    phase.drop_objection(this);
    
  endtask

  
endclass


