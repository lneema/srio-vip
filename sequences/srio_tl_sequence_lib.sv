////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_tl_sequence_lib.sv
// Project :  srio vip
// Purpose :  Transport layer sequences 
// Author  :  Mobiveil
//
// All  Transport layer sequences  component.
//
////////////////////////////////////////////////////////////////////////////////

class srio_tl_base_seq extends uvm_sequence#(srio_trans);

  `uvm_object_utils(srio_tl_base_seq)

  srio_env_config env_config;
  srio_reg_block srio_reg_model;

function new(string name="");
    super.new(name);
  endfunction

task pre_body();

   super.pre_body();
   if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    `uvm_fatal("Config Fatal", "Can't get the env_config")
   srio_reg_model = env_config.srio_reg_model_rx;
   wait (env_config.pl_mon_tx_link_initialized == 1); 
   wait (env_config.pl_mon_rx_link_initialized == 1); 
   #10000ns; 

endtask

endclass : srio_tl_base_seq



//======================================================
//==============TRANSPORT LAYER SEQUENCE================
//======================================================

class srio_tl_pkt_tt_base_seq extends srio_tl_base_seq; //{
 
 `uvm_object_utils(srio_tl_pkt_tt_base_seq)

   srio_trans srio_trans_item;

     
     rand bit [3:0] ftype_0,ttype_0;
     

	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{
        
    
     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
        srio_trans_item.Ftype.constraint_mode(0);
        srio_trans_item.Ttype.constraint_mode(0);
        srio_trans_item.wrsize_0.constraint_mode(0);
	        
       ftype_0 = $urandom_range(32'd6,32'd5);        
      start_item(srio_trans_item);

     assert(srio_trans_item.randomize() with {ftype ==ftype_0 ;ttype == 4'h4;wrsize ==4'hB ;wdptr ==1'b0;}); 
     for(int i=0; i<8; i++) begin //{
     srio_trans_item.payload.push_back(i); 
     end //}
	srio_trans_item.print();

        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE READ REQUEST Transcation"),UVM_LOW); end
finish_item(srio_trans_item);

        
	endtask //}

endclass : srio_tl_pkt_tt_base_seq //}

