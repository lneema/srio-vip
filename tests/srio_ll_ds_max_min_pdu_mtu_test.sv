////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_ds_max_min_pdu_mtu_test.sv
// Project :  srio vip
// Purpose :  Data streaming test
// Author  :  Mobiveil
//
// 1. COnfiguring DS MTU .
// 2.Data streaming with Random test.
//
////////////////////////////////////////////////////////////////////////////////
class srio_ll_ds_max_min_pdu_mtu_test extends srio_base_test;

  `uvm_component_utils(srio_ll_ds_max_min_pdu_mtu_test)

  rand bit [7:0] mtusize_2;
  rand bit [15:0] pdu_length_2;
  rand bit [2:0] flag;

  srio_ll_ds_max_min_pdu_mtu_seq ds_max_min_pdu_mtu_seq;
  srio_ll_maintenance_ds_support_reg_seq ll_maintenance_ds_support_reg_seq;
  
  function new(string name, uvm_component parent=null);
  super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    ds_max_min_pdu_mtu_seq = srio_ll_ds_max_min_pdu_mtu_seq::type_id::create("ds_max_min_pdu_mtu_seq");
    ll_maintenance_ds_support_reg_seq = srio_ll_maintenance_ds_support_reg_seq::type_id::create("ll_maintenance_ds_support_reg_seq");


   phase.raise_objection( this );

   flag = $urandom_range(32'd0,32'd4);
        
        if (flag == 0)
        begin	
          mtusize_2   = 8'd64;                                
          pdu_length_2 = 16'h0;                                               
        end
        else if (flag == 1)
        begin	
          mtusize_2   = 8'd8;                                
          pdu_length_2 = 16'h0;                                               
        end 
        else if (flag == 2)
        begin	
          mtusize_2   = 8'd64;                                
          pdu_length_2 = 16'h1;                                               
        end
        else if (flag == 3)
        begin	
          mtusize_2   = 8'd8;                                
          pdu_length_2 = 16'h1;                                               
        end
        else 
        begin	
          mtusize_2   = $urandom_range(32'd64,32'd8);
          pdu_length_2 = $urandom_range(32'h0000_FFFF,32'h0000_0000);
        end

     // Configuring MTU
      ll_maintenance_ds_support_reg_seq.mtusize_1 = mtusize_2;
      ll_maintenance_ds_support_reg_seq.start( env1.e_virtual_sequencer);
`ifdef SRIO_VIP_B2B
    //Configuring MTU 
      ll_maintenance_ds_support_reg_seq.mtusize_1 = mtusize_2;
      ll_maintenance_ds_support_reg_seq.start( env2.e_virtual_sequencer);
`endif
   // DS Packet
      ds_max_min_pdu_mtu_seq.mtusize_1 = mtusize_2;
      ds_max_min_pdu_mtu_seq.pdu_length_1 = pdu_length_2;
      ds_max_min_pdu_mtu_seq.start( env1.e_virtual_sequencer);

      #50000ns;
    phase.drop_objection(this);
    
  endtask

 
endclass


