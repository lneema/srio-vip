////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_vc4_nwrite_swrite_test.sv
// Project :  srio vip
// Purpose :  Multi VC support for swrite and nwrite
// Author  :  Mobiveil
//
// Test for 4 VCs support for nwrite and swrite packets
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_vc4_nwrite_swrite_test extends srio_base_test;

  `uvm_component_utils(srio_ll_vc4_nwrite_swrite_test)
  rand bit [1:0] prio_2,mode;
  rand bit crf_2;
  rand bit vc_2,sel;
  rand int support;
  srio_ll_multi_vc_nwrite_swrite_seq ll_multi_vc_nwrite_swrite_seq;
    
  function new(string name, uvm_component parent=null);
    super.new(name,parent);
  endfunction
   function void connect_phase(uvm_phase phase);
      void'(srio1_reg_model_tx.Port_0_VC_Control_and_Status_Register.VCs_Support.predict(4));
      void'(srio1_reg_model_rx.Port_0_VC_Control_and_Status_Register.VCs_Support.predict(4));
      void'(srio2_reg_model_tx.Port_0_VC_Control_and_Status_Register.VCs_Support.predict(4));
      void'(srio2_reg_model_rx.Port_0_VC_Control_and_Status_Register.VCs_Support.predict(4));

      void'(srio1_reg_model_tx.Port_0_VC_Control_and_Status_Register.CT_Mode.predict(1));
      void'(srio1_reg_model_rx.Port_0_VC_Control_and_Status_Register.CT_Mode.predict(1));
      void'(srio2_reg_model_tx.Port_0_VC_Control_and_Status_Register.CT_Mode.predict(1));
      void'(srio2_reg_model_rx.Port_0_VC_Control_and_Status_Register.CT_Mode.predict(1));
   endfunction
    task run_phase( uvm_phase phase );
    super.run_phase(phase);
      mode = $urandom_range(32'd3,32'd0);
      sel = $urandom;
      vc_2 = 1; 
      env_config1.multi_vc_support = vc_2;
      env_config2.multi_vc_support = vc_2;
      
      case(mode) //{
      2'b00 : begin support = 1; prio_2 = 2'b00; crf_2 = 1'b1; end    
      2'b01 : begin support = 2; prio_2 = sel ? 2'b00 : 2'b10; crf_2 = 1'b1; end    
      2'b10 : begin support = 4; prio_2 = $urandom_range(32'd3,32'd0); crf_2 = 1'b1; end    
      2'b11 : begin support = 8; prio_2 = $urandom_range(32'd3,32'd0); crf_2 = $urandom_range(32'd1,32'd0); end 
      endcase //}   
      env_config1.vc_num_support = support;
      env_config2.vc_num_support = support;

       ll_multi_vc_nwrite_swrite_seq = srio_ll_multi_vc_nwrite_swrite_seq::type_id::create("ll_multi_vc_nwrite_swrite_seq");
      phase.raise_objection( this );
       
      ll_multi_vc_nwrite_swrite_seq.prio_1 = prio_2;
      ll_multi_vc_nwrite_swrite_seq.crf_1 = crf_2;
      ll_multi_vc_nwrite_swrite_seq.vc_1 = vc_2;
      ll_multi_vc_nwrite_swrite_seq.start( env1.e_virtual_sequencer);
      #20000ns;
      phase.drop_objection(this);
   endtask

endclass


