`include "uvm_macros.svh"

import uvm_pkg::*;
import srio_env_pkg::*;

class srio_ll_base_seq extends uvm_sequence#(srio_trans);
  `uvm_object_utils(srio_ll_base_seq)
 logic [31:0] SourceID;
 logic [31:0] DestinationID;
 logic [28:0] address;
 logic [31:0] ext_address;
 logic payload;
 logic [1:0] xamsbs;
 logic wdptr;
 logic [3:0] wrsize;
 logic [7:0] SrcTID;
 logic [2:0] flowID;
 logic [3:0] ttype;

  srio_env_config env_config;
  srio_reg_block srio_reg_model;

function new(string name="");
    super.new(name);
  endfunction

// task pre_body()
//
//   super.pre_body();
//   if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
//    `uvm_fatal("Config Fatal", "Can't get the env_config")
//   srio_reg_model = env_config.srio_reg_model;
//   wait (env_config.link_initialized == 1); 
//
//endtask

  virtual task body();

   srio_trans srio_trans_item;
   if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    `uvm_fatal("Config Fatal", "Can't get the env_config")
   srio_reg_model = env_config.srio_reg_model_rx;
   wait (env_config.link_initialized == 1); 

    for(int i = 0; i<3; i++) begin //{
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");	begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE",$sformatf("NUMBER OF PACKET TRANSFER = %d",i),UVM_LOW); end
        start_item(srio_trans_item);
	//assert(srio_trans_item.randomize());
        assert(srio_trans_item.randomize() with {ftype == 4'h5;ttype == 4'h4;});       
        ///assert(srio_trans_item.randomize() with {ttype == 4'h4;})
      			 begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "Request class with NWRITE Transcation"),UVM_LOW); end
			 begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf("seq item ftype = %h",srio_trans_item.ftype),UVM_LOW); end
			 begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf("seq item ttype = %h",srio_trans_item.ttype),UVM_LOW); end
     			 begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf("seq item Source ID = %h",srio_trans_item.SourceID),UVM_LOW); end
                         begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf("seq item Dest ID = %h",srio_trans_item.DestinationID),UVM_LOW); end
                         begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf("seq item Address  = %h",srio_trans_item.address),UVM_LOW); end
                         begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf("seq item ext_address = %h",srio_trans_item.ext_address),UVM_LOW); end
                         begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf("seq item xamsbs  = %h",srio_trans_item.xamsbs),UVM_LOW); end
                         begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf("seq item wdptr = %h",srio_trans_item.wdptr),UVM_LOW); end
                         begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf("seq item rdsize = %h",srio_trans_item.rdsize),UVM_LOW); end
                         begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf("seq item SrcTID = %h",srio_trans_item.SrcTID),UVM_LOW); end
                        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf("seq item prioirty = %b",srio_trans_item.prio),UVM_LOW); end
			begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf("seq item crf = %b",srio_trans_item.crf),UVM_LOW); end
			begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf("seq item Virtual channel = %b",srio_trans_item.vc),UVM_LOW); end

       finish_item(srio_trans_item);
	end  //}
   

  endtask


endclass : srio_ll_base_seq

