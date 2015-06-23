////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_io_resp_rand_test.sv
// Project :  srio vip
// Purpose :  Random response for IO packets
// Author  :  Mobiveil
//
// Test to generate random response for IO packets
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_io_resp_rand_test extends srio_base_test;

  `uvm_component_utils(srio_ll_io_resp_rand_test)

  
  srio_ll_io_random_seq  ll_io_random_seq;


  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);

     env_config2.ll_config.ll_resp_timeout        = 5000;  
     env_config1.ll_config.en_out_of_order_gen    = TRUE;    
     env_config1.ll_config.gen_resp_en_ratio      = 95;      
     env_config1.ll_config.gen_resp_dis_ratio     = 5;       
     env_config1.ll_config.resp_gen_mode          = RANDOM;  
     env_config1.ll_config.resp_done_ratio        = 90;             
     env_config1.ll_config.resp_err_ratio         = 10;             
        
     ll_io_random_seq = srio_ll_io_random_seq::type_id::create("ll_io_random_seq");

     phase.raise_objection( this );
    
     ll_io_random_seq.start( env2.e_virtual_sequencer);
     #50000ns;  
     phase.drop_objection(this);
    
  endtask

endclass


