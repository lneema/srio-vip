////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_ds_max_seg_support_test.sv
// Project :  srio vip
// Purpose :  Data streaming test
// Author  :  Mobiveil
//
// Dta streaming with Random test.
//
////////////////////////////////////////////////////////////////////////////////
class srio_ll_ds_max_seg_support_test extends srio_base_test;
logic [31:0] x;
  `uvm_component_utils(srio_ll_ds_max_seg_support_test)

  srio_ll_ds_max_seg_support_seq ds_max_seg_support_seq;
  
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
      ds_max_seg_support_seq = srio_ll_ds_max_seg_support_seq::type_id::create("ds_max_seg_support_seq");
      phase.raise_objection( this );
    fork //{
    begin 
      ds_max_seg_support_seq.start( env1.e_virtual_sequencer);
     end
    begin
        wait (env1.ll_agent.ll_config.bfm_tx_pkt_cnt > 1);
        env1.ll_agent.ll_config.block_ll_traffic = TRUE;
        #10000ns;
        env1.ll_agent.ll_config.block_ll_traffic = FALSE;
       
     end
    join //}

      #10000ns;
      phase.drop_objection(this);
    endtask
function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
     void'(srio1_reg_model_tx.Data_Streaming_Information_CAR.SegSupport.predict(16'hA000));
     void'(srio1_reg_model_rx.Data_Streaming_Information_CAR.SegSupport.predict(16'hA000));
`ifdef SRIO_VIP_B2B 
     void'(srio2_reg_model_tx.Data_Streaming_Information_CAR.SegSupport.predict(16'hA000));
     void'(srio2_reg_model_rx.Data_Streaming_Information_CAR.SegSupport.predict(16'hA000)); 
`endif
endfunction


endclass


