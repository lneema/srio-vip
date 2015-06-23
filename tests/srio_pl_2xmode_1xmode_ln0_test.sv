////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_2xmode_1xmode_ln0_test.sv
// Project :  srio vip
// Purpose :  2x recovery to 1xmode lane0
// Author  :  Mobiveil
//
// Test for  2x recovery to 1xmode lane0 state transition
// Supported by all mode (Gen1,Gen2,Gen3)
//
////////////////////////////////////////////////////////////////////////////////


class srio_pl_2xmode_1xmode_ln0_test extends srio_base_test;

  `uvm_component_utils(srio_pl_2xmode_1xmode_ln0_test)
 // srio_pl_2xmode_2x_rec_sm_seq pl_2xmode_2x_rec_sm_seq;
  srio_pl_2xmode_1xmode_ln0_sm_seq pl_2xmode_1xmode_ln0_sm_seq;
  srio_ll_nread_req_seq nread_req_seq;
 
    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    // pl_2xmode_2x_rec_sm_seq = srio_pl_2xmode_2x_rec_sm_seq::type_id::create("pl_2xmode_2x_rec_sm_seq"); 
     pl_2xmode_1xmode_ln0_sm_seq = srio_pl_2xmode_1xmode_ln0_sm_seq::type_id::create("pl_2xmode_1xmode_ln0_sm_seq"); 
     nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");
       
     phase.raise_objection( this );
     

    wait(env_config1.pl_tx_mon_init_sm_state ==X2_MODE );
    wait(env_config1.pl_rx_mon_init_sm_state ==X2_MODE );

        //pl_2xmode_2x_rec_sm_seq.start( env1.e_virtual_sequencer);
   
    
    
       pl_2xmode_1xmode_ln0_sm_seq.start( env1.e_virtual_sequencer);

    wait(env_config1.pl_tx_mon_init_sm_state == X2_RECOVERY);
    wait(env_config1.pl_rx_mon_init_sm_state == X2_RECOVERY);

   wait(env_config1.pl_tx_mon_init_sm_state == X1_M0);
   wait(env_config1.pl_rx_mon_init_sm_state == X1_M0);

   nread_req_seq.start( env1.e_virtual_sequencer);

   #20000ns;
  
    phase.drop_objection(this);

  endtask


endclass


