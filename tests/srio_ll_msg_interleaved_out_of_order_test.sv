///////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_msg_interleaved_out_of_order_test.sv
// Project :  srio vip
// Purpose :  Message  test
// Author  :  Mobiveil
//
// Message Packet  with Interleaved packet and out of order  test.
//
////////////////////////////////////////////////////////////////////////////////
class srio_ll_msg_interleaved_out_of_order_test  extends srio_base_test;

  `uvm_component_utils(srio_ll_msg_interleaved_out_of_order_test)

  srio_ll_msg_interleaved_req_seq msg_interleaved_req_seq;
    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    env1.ll_agent.ll_config.en_out_of_order_gen = TRUE;
    msg_interleaved_req_seq = srio_ll_msg_interleaved_req_seq::type_id::create("msg_interleaved_req_seq");
      phase.raise_objection( this );
    fork //{
    begin 
     msg_interleaved_req_seq.start( env1.e_virtual_sequencer);
    end
    begin
        wait (env1.ll_agent.ll_config.bfm_tx_pkt_cnt > 2);
        env1.ll_agent.ll_config.block_ll_traffic = TRUE;
        #500ns;
        env1.ll_agent.ll_config.block_ll_traffic = FALSE;
       
     end
    join //}

    #20000ns;
    phase.drop_objection(this);
    
  endtask

  
endclass


