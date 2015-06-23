////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_ds_env1_env2_test.sv
// Project :  srio vip
// Purpose :  Concurrent DS packet in both the environment
// Author  :  Mobiveil
//
//
////////////////////////////////////////////////////////////////////////////////
class srio_ll_ds_env1_env2_test extends srio_base_test;

  `uvm_component_utils(srio_ll_ds_env1_env2_test)

  rand bit [7:0] mtusize_2;
  rand bit [15:0] pdu_length_2;

  srio_ll_ds_interleaved_seq ds_interleaved_seq;
  srio_ll_ds_interleaved_seq ds_interleaved_seq1;
  srio_ll_maintenance_ds_support_reg_seq ll_maintenance_ds_support_reg_seq;
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
      ds_interleaved_seq = srio_ll_ds_interleaved_seq::type_id::create("ds_interleaved_seq");
      ds_interleaved_seq1 = srio_ll_ds_interleaved_seq::type_id::create("ds_interleaved_seq1");
     ll_maintenance_ds_support_reg_seq = srio_ll_maintenance_ds_support_reg_seq::type_id::create("ll_maintenance_ds_support_reg_seq");
      phase.raise_objection( this );

       mtusize_2 = $urandom_range(32'd64,32'd8);
       pdu_length_2 = $urandom_range(32'h 0000_FFFF,32'h0);

    // Configuring MTU
      ll_maintenance_ds_support_reg_seq.mtusize_1 = mtusize_2;
      ll_maintenance_ds_support_reg_seq.start( env1.e_virtual_sequencer);

    //Configuring MTU 
      ll_maintenance_ds_support_reg_seq.mtusize_1 = mtusize_2;
      ll_maintenance_ds_support_reg_seq.start( env2.e_virtual_sequencer);
     fork //{
begin
fork //{
    begin 
     ds_interleaved_seq.mtusize_1 = mtusize_2;
     ds_interleaved_seq.pdu_length_1 = pdu_length_2;

     ds_interleaved_seq.start( env1.e_virtual_sequencer);
    end
    begin
        wait (env1.ll_agent.ll_config.bfm_tx_pkt_cnt > 1);
        env1.ll_agent.ll_config.block_ll_traffic = TRUE;
        #100ns;
        env1.ll_agent.ll_config.block_ll_traffic = FALSE;
     end
join //}
end
begin
fork //{
    begin 
    ds_interleaved_seq.mtusize_1 = mtusize_2;
     ds_interleaved_seq.pdu_length_1 = pdu_length_2;

     ds_interleaved_seq1.start( env2.e_virtual_sequencer);
    end
    begin
        wait (env2.ll_agent.ll_config.bfm_tx_pkt_cnt > 1);
        env2.ll_agent.ll_config.block_ll_traffic = TRUE;
        #100ns;
        env2.ll_agent.ll_config.block_ll_traffic = FALSE;
     end
join //}
end
    join //}

      #50000ns;
      phase.drop_objection(this);
    endtask

endclass


