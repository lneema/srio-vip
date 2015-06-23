////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_random_interleaved_test.sv
// Project :  srio vip
// Purpose :  Interleaved Test 
// Author  :  Mobiveil
//
// Test for Interleaved Random sequences
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_random_interleaved_test extends srio_base_test;

  `uvm_component_utils(srio_ll_random_interleaved_test)

  
  srio_ll_io_random_seq  ll_io_random_seq;
  srio_ll_msg_mseg_req_seq msg_mseg_req_seq;
  srio_ll_doorbell_req_seq doorbell_req_seq;
  srio_ll_ds_mseg_single_mtu_seq ds_mseg_single_mtu_seq;

  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);

     env1.ll_agent.ll_config.interleaved_pkt = TRUE;
     //env1.ll_agent.ll_config.arb_type = SRIO_LL_WRR ;
     ll_io_random_seq = srio_ll_io_random_seq::type_id::create("ll_io_random_seq");
     msg_mseg_req_seq = srio_ll_msg_mseg_req_seq::type_id::create("msg_mseg_req_seq");
     doorbell_req_seq = srio_ll_doorbell_req_seq::type_id::create("doorbell_req_seq");
     ds_mseg_single_mtu_seq = srio_ll_ds_mseg_single_mtu_seq::type_id::create("ds_mseg_single_mtu_seq");

    phase.raise_objection( this );
    fork //{
    begin 
        ds_mseg_single_mtu_seq.start( env1.e_virtual_sequencer);
    end 
    begin  
        ll_io_random_seq.start( env1.e_virtual_sequencer);
    end
    begin 
        msg_mseg_req_seq.start( env1.e_virtual_sequencer);
    end 
    begin
        doorbell_req_seq.start( env1.e_virtual_sequencer);
    end   
    begin
        wait (env1.ll_agent.ll_config.bfm_tx_pkt_cnt > 1);
        env1.ll_agent.ll_config.block_ll_traffic = TRUE;
        #10000ns;
        env1.ll_agent.ll_config.block_ll_traffic = FALSE;
       
     end
    join //}
        #5000ns;   
     phase.drop_objection(this);
    
  endtask

endclass


