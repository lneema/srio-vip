////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_msg_with_same_mbox_letter_test.sv
// Project :  srio vip
// Purpose :  IO Test 
// Author  :  Mobiveil
//
// Test for MSG packets with same mbox and letter value.
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_msg_with_same_mbox_letter_test extends srio_base_test;

  `uvm_component_utils(srio_ll_msg_with_same_mbox_letter_test)

  
  srio_ll_msg_same_mbox_letter_req_seq  ll_msg_pkt_seq;
  srio_ll_msg_same_mbox_letter_req_seq  ll_msg_pkt_seq1;
  srio_ll_msg_same_mbox_letter_req_seq  ll_msg_pkt_seq2;
  srio_ll_msg_same_mbox_letter_req_seq  ll_msg_pkt_seq3;

  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
     ll_msg_pkt_seq = srio_ll_msg_same_mbox_letter_req_seq::type_id::create("ll_msg_pkt_seq");
     ll_msg_pkt_seq1 = srio_ll_msg_same_mbox_letter_req_seq::type_id::create("ll_msg_pkt_seq1");
     ll_msg_pkt_seq2 = srio_ll_msg_same_mbox_letter_req_seq::type_id::create("ll_msg_pkt_seq2");
     ll_msg_pkt_seq3 = srio_ll_msg_same_mbox_letter_req_seq::type_id::create("ll_msg_pkt_seq3");

    phase.raise_objection( this );
`ifdef SRIO_VIP_B2B
      //Block the response packets for certain period 
      env2.ll_agent.ll_config.block_ll_traffic = TRUE;   
`endif
      fork
      ll_msg_pkt_seq.start( env1.e_virtual_sequencer);
      ll_msg_pkt_seq1.start( env1.e_virtual_sequencer);
      ll_msg_pkt_seq2.start( env1.e_virtual_sequencer);
      ll_msg_pkt_seq3.start( env1.e_virtual_sequencer);
      join
      #50000ns;
`ifdef SRIO_VIP_B2B
      env2.ll_agent.ll_config.block_ll_traffic = FALSE; 
`endif
    #50000ns;  
    phase.drop_objection(this);
    
  endtask

endclass

