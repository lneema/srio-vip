////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_seq_order_pri_crf_retry_test.sv
// Project : srio vip
// Purpose : Default test  
// Author  : Mobiveil
// Sequenctial order priority and crf sequence called
// Configuring pl_config packet accepted and packet retry ratio
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_seq_order_pri_crf_retry_test extends srio_base_test;

     `uvm_component_utils(srio_ll_seq_order_pri_crf_retry_test)

     srio_ll_user_gen_seq_prio_seq ll_user_gen_seq_prio_seq;
 
     function new(string name, uvm_component parent=null);
       super.new(name, parent);
     endfunction

     task run_phase( uvm_phase phase );
    super.run_phase(phase);
     
      ll_user_gen_seq_prio_seq = srio_ll_user_gen_seq_prio_seq::type_id::create("ll_user_gen_seq_prio_seq");

    // Configuring pl_config packet accepted and packet retry ratio
     //env1.pl_agent.pl_config.pkt_accept_prob=5;
     env2.pl_agent.pl_config.pkt_retry_prob=100;

      phase.raise_objection( this );
      ll_user_gen_seq_prio_seq.start( env1.e_virtual_sequencer);
      #50000ns;
      phase.drop_objection(this);
    
     endtask
  
endclass

