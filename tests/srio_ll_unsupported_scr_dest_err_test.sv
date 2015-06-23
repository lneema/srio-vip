////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_unsupported_scr_dest_err_test.sv
// Project :  srio vip
// Purpose : Unsupported FTYPE and TTYPE error test 
// Author  :  Mobiveil
//
// Unsupported FTYPE and TTYPE error test
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_unsupported_scr_dest_err_test extends srio_base_test;

     `uvm_component_utils(srio_ll_unsupported_scr_dest_err_test)
     srio_ll_ftype_default_seq default_seq;
       
     function new(string name, uvm_component parent=null);
       super.new(name, parent);
     endfunction

     task run_phase( uvm_phase phase );
    super.run_phase(phase);
 
      default_seq = srio_ll_ftype_default_seq::type_id::create("default_seq");

      phase.raise_objection( this );
      default_seq.start( env1.e_virtual_sequencer);
#5000ns;
      phase.drop_objection(this);
    
     endtask

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    void'(srio1_reg_model_tx.Destination_Operations_CAR.predict(32'h0000_0000));
    void'(srio1_reg_model_tx.Source_Operations_CAR.predict(32'h0000_0000));
    void'(srio1_reg_model_rx.Destination_Operations_CAR.predict(32'h0000_0000));
    void'(srio1_reg_model_rx.Source_Operations_CAR.predict(32'h0000_0000));
`ifdef SRIO_VIP_B2B 
    void'(srio2_reg_model_tx.Destination_Operations_CAR.predict(32'h0000_0000));
    void'(srio2_reg_model_tx.Source_Operations_CAR.predict(32'h0000_0000));
    void'(srio2_reg_model_rx.Destination_Operations_CAR.predict(32'h0000_0000));
    void'(srio2_reg_model_rx.Source_Operations_CAR.predict(32'h0000_0000)); 
`endif
endfunction


endclass
