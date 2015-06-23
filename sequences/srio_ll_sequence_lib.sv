////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_sequence_lib.sv
// Project :  srio vip
// Purpose :  Logical layer sequences 
// Author  :  Mobiveil
//
// All  Logical layer sequences  component.
//
////////////////////////////////////////////////////////////////////////////////
class srio_ll_base_seq extends uvm_sequence#(srio_trans);

  `uvm_object_utils(srio_ll_base_seq)

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

endtask

endclass : srio_ll_base_seq
//====DEFAULT SEQUENCE ====

class srio_ll_default_class_seq extends srio_ll_base_seq;
    `uvm_object_utils(srio_ll_default_class_seq)

    srio_trans srio_trans_item;
    rand bit [7:0] mtusize_0;
    rand bit [3:0] TMOP_0;
 
    function new(string name="");
    super.new(name);
    endfunction

  virtual task body();

      // Random Packet
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
      srio_trans_item.Tmop.constraint_mode(0);
     
      start_item(srio_trans_item);
      assert(srio_trans_item.randomize() with { mtusize == mtusize_0 ;TMOP == TMOP_0;});
      srio_trans_item.print();
      finish_item(srio_trans_item);
      #100ns;
     // wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
     endtask

endclass :srio_ll_default_class_seq

//========= REQUEST SEQUENCE =========

class srio_ll_request_class_seq extends srio_ll_base_seq;
    `uvm_object_utils(srio_ll_request_class_seq)

   srio_trans srio_trans_item;

  rand bit [3:0] ftype_0;
  rand bit [3:0] ttype_0;
      function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
     srio_trans_item = srio_trans::type_id::create("srio_trans_item");	
     srio_trans_item.Ftype.constraint_mode(0);
     srio_trans_item.Ttype.constraint_mode(0);
     
      start_item(srio_trans_item);
     assert(srio_trans_item.randomize() with {ftype ==ftype_0 ;ttype == ttype_0;});  
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " REQUEST CLASS Transcation"),UVM_LOW); end
        srio_trans_item.print();
        finish_item(srio_trans_item);
  endtask

endclass : srio_ll_request_class_seq
//========= GSM SEQUENCE =========
class srio_ll_gsm_class_seq extends srio_ll_base_seq;
    `uvm_object_utils(srio_ll_gsm_class_seq)

   srio_trans srio_trans_item;

  rand bit [3:0] ftype_0;
  rand bit [3:0] ttype_0;
      function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
     srio_trans_item = srio_trans::type_id::create("srio_trans_item");	
     srio_trans_item.Ftype.constraint_mode(0);
     srio_trans_item.Ttype.constraint_mode(0);
     
      start_item(srio_trans_item);
     assert(srio_trans_item.randomize() with {ftype ==ftype_0 ;ttype == ttype_0;});  
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " REQUEST CLASS Transcation"),UVM_LOW); end
        srio_trans_item.print();
        finish_item(srio_trans_item);
  endtask

endclass : srio_ll_gsm_class_seq

//========= GSM RANDOM SEQUENCE =========
class srio_ll_gsm_class_random_seq extends srio_ll_base_seq;
    `uvm_object_utils(srio_ll_gsm_class_random_seq)

   srio_trans srio_trans_item;

  rand bit [3:0] ftype_0;
  rand bit [3:0] ttype_0;
  rand bit [1:0] mode;
  rand bit flag;
      function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
     srio_trans_item = srio_trans::type_id::create("srio_trans_item");	
     srio_trans_item.Ftype.constraint_mode(0);
     srio_trans_item.Ttype.constraint_mode(0);
     mode = $urandom;
     flag = $urandom;

     case(mode)  //{
       2'b00       : begin ftype_0 = 4'h1; ttype_0 = $urandom_range(32'd0,32'd2); end 
       2'b01       : begin ftype_0 = 4'h2; ttype_0 = flag ? $urandom_range(32'd0,32'd3) : $urandom_range(32'd5,32'd11); end 
       2'b10,2'b11 : begin ftype_0 = 4'h5; ttype_0 = $urandom_range(32'd0,32'd1); end 
     endcase //}
 
      start_item(srio_trans_item);
     assert(srio_trans_item.randomize() with {ftype ==ftype_0 ;ttype == ttype_0;});  
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " REQUEST CLASS Transcation"),UVM_LOW); end
        srio_trans_item.print();
        finish_item(srio_trans_item);

	fork //{
	begin //{
        @(env_config.ll_config.ll_pkt_received);
        #20ns;
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET AFTER MAINT_RD"),UVM_LOW);
	end //}
	begin //{
	#10000ns;
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET FAILED AFTER MAINT_RD --- TIMEOUT OCCURED "),UVM_LOW);
	end //}
	join_any //}
	disable fork;


  endtask

endclass : srio_ll_gsm_class_random_seq


//======= WRITE SEQUENCE =======


class srio_ll_write_class_seq extends srio_ll_base_seq;
  `uvm_object_utils(srio_ll_write_class_seq)

  srio_trans srio_trans_item;
  

  rand bit [3:0] ttype_0;
  rand bit [3:0] ftype_0;
  

function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
       srio_trans_item = srio_trans::type_id::create("srio_trans_item");   
     srio_trans_item.Ftype.constraint_mode(0);
     srio_trans_item.Ttype.constraint_mode(0);
     if(ftype_0 == 4'h5 && ttype_0 == 4'hE)
     begin
       srio_trans_item.Wdptr.constraint_mode(0);
       srio_trans_item.wrsize_0.constraint_mode(0);
     end
     
     start_item(srio_trans_item);

    if(ftype_0 == 4'h5 && ttype_0 == 4'hE)
	  assert(srio_trans_item.randomize() with {ftype ==ftype_0 ;ttype ==ttype_0; wrsize ==8;prio == 1; crf == 0;});
    else
	  assert(srio_trans_item.randomize() with {ftype ==ftype_0 ;ttype ==ttype_0;prio == 1; crf == 0;});

        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " WRITE CLASS REQUEST Transcation"),UVM_LOW); end       
     srio_trans_item.print();

     finish_item(srio_trans_item);
     endtask
endclass : srio_ll_write_class_seq



//======= SWRITE SEQUENCE =======


class srio_ll_swrite_seq extends srio_ll_base_seq;
`uvm_object_utils(srio_ll_swrite_seq)
srio_trans srio_trans_item;
	   
 rand bit [3:0] ftype_0;
 

function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
		
        srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
        start_item(srio_trans_item);
        assert(srio_trans_item.randomize() with {ftype == ftype_0;}); 
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "SWRITE REQUEST Transcation"),UVM_LOW); end
       srio_trans_item.print();

       finish_item(srio_trans_item);

  endtask

endclass : srio_ll_swrite_seq


//======= MAINTENANCE REQ RANDOM SEQUENCE =======


class srio_ll_maintenance_req_seq extends srio_ll_base_seq;
  `uvm_object_utils(srio_ll_maintenance_req_seq)
  srio_trans srio_trans_item;

  rand bit [3:0] ttype_0;
  rand bit [3:0] ftype_0;
   
function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
		
      	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
     	
        start_item(srio_trans_item);
	assert(srio_trans_item.randomize() with {ftype ==ftype_0 ;ttype == ttype_0 ;});

	
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE REQUEST Transcation"),UVM_LOW); end

      	srio_trans_item.print();

       	finish_item(srio_trans_item);

	
  endtask
endclass : srio_ll_maintenance_req_seq


//======= MAINTENANCE REQ SEQUENCE =======


class srio_ll_maintenance_base_seq extends srio_ll_base_seq;
  `uvm_object_utils(srio_ll_maintenance_base_seq)
  srio_trans srio_trans_item;

  rand bit [3:0] ttype_0;
  rand bit [3:0] ftype_0;
  rand bit wdptr_0 ;        
  rand bit [3:0] wrsize_1;  
  rand bit [3:0] rdsize_1;
  rand bit [20:0] config_offset_0 ;
  rand bit [7:0] targetID_Info_0;
function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
		
      	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
     	srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.rdsize_0.constraint_mode(0);
	srio_trans_item.Ftype_8.constraint_mode(0);
	
        start_item(srio_trans_item);

	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == config_offset_0;
     targetID_Info == targetID_Info_0;});

	
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE REQUEST Transcation"),UVM_LOW); end

      	srio_trans_item.print();

       	finish_item(srio_trans_item);

	
  endtask
endclass : srio_ll_maintenance_base_seq



//========================================
//======= MAINTENANCE WRITE READ SEQUENCE =======
//========================================


class srio_ll_maintenance_wr_rd_base_seq extends srio_ll_base_seq;
  `uvm_object_utils(srio_ll_maintenance_wr_rd_base_seq)
  srio_trans srio_trans_item;
  uvm_reg rg;
  logic [3:0] ttype_0;
  logic [3:0] ftype_0;
  logic wdptr_0;        
  logic [3:0] wrsize_1;  
  logic [3:0] rdsize_1;
  logic [20:0] config_offset_0 ;
  logic [7:0] targetID_Info_0;
  logic [31:0] write_data;
  logic [31:0] read1_data;
  logic [31:0] read2_data;
  logic [7:0] expected_payload[$];
  logic [31:0] expected_write;
  logic [31:0] expected_write1;
  logic [13:0] g;
function new(string name="");
    super.new(name);
  endfunction

task byte_reverse(input logic [31:0] a);
  logic [7:0] b,c,d,e;
  b  = {a[24],a[25],a[26],a[27],a[28],a[29],a[30],a[31]};
  c  = {a[16],a[17],a[18],a[19],a[20],a[21],a[22],a[23]};
  d  = {a[8],a[9],a[10],a[11],a[12],a[13],a[14],a[15]};
  e  = {a[0],a[1],a[2],a[3],a[4],a[5],a[6],a[7]};
  expected_write1 = {b,c,d,e};
endtask

  virtual task body();
		
    srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
    srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.rdsize_0.constraint_mode(0);
	srio_trans_item.Ftype_8.constraint_mode(0);
	  
 //Device_Identity_CAR
    ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h00;
     });
        begin  
`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
    read1_data = srio_reg_model.Device_Identity_CAR.get();
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
    ttype_0 = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h00;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Device_Identity_CAR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h00;
     });
       srio_trans_item.payload.delete();
        begin  
`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Device_Identity_CAR.get();
        `uvm_info("RO Device_Identity_CAR",$sformatf("After first read 'h00 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Device_Identity_CAR",$sformatf("After first write 'h00 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Device_Identity_CAR",$sformatf("After second read 'h00 read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
     //Device_Information_CAR
 ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h04;
     });
             begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Device_Information_CAR.get();

    ttype_0 = 1; 
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h04;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Device_Information_CAR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h04;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Device_Information_CAR.get();
        `uvm_info("RO Device_Information_CAR",$sformatf("After first read 'h00 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Device_Information_CAR",$sformatf("After first write 'h00 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Device_Information_CAR",$sformatf("After second read 'h00 read2_data = %h", read2_data),UVM_LOW);   
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);


 //Assembly_Identity_CAR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h08;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Assembly_Identity_CAR.get();
     ttype_0 = 1;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h08;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Assembly_Identity_CAR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h08;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Assembly_Identity_CAR.get();
        `uvm_info("RO Assembly_Identity_CAR",$sformatf("After first read 'h08 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Assembly_Identity_CAR",$sformatf("After first write 'h08 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Assembly_Identity_CAR",$sformatf("After second read 'h08 read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
 //Assembly_Information_CAR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h0c;
     });
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Assembly_Information_CAR.get();
     ttype_0 = 1;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h0c;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Assembly_Information_CAR.get();
          ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h0c;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Assembly_Information_CAR.get();
               `uvm_info("RO Assembly_Information_CAR",$sformatf("After first read 'h0c read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Assembly_Information_CAR",$sformatf("After first write 'h0c write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Assembly_Information_CAR",$sformatf("After second read 'h0c read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
 //Processing_Element_Features_CAR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h10;
     });
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Processing_Element_Features_CAR.get();

     ttype_0 = 1;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h10;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Processing_Element_Features_CAR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h10;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Processing_Element_Features_CAR.get();
               `uvm_info("RO Processing_Element_Features_CAR",$sformatf("After first read 'h10 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Processing_Element_Features_CAR",$sformatf("After first write 'h10 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Processing_Element_Features_CAR",$sformatf("After second read 'h10 read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

 //Switch_Port_Information_CAR
     ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h14;
     });
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Switch_Port_Information_CAR.get();
     ttype_0 = 1;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h14;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Switch_Port_Information_CAR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h14;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Switch_Port_Information_CAR.get();
        `uvm_info("RO Switch_Port_Information_CAR",$sformatf("After first read 'h14 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Switch_Port_Information_CAR",$sformatf("After first write 'h14 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Switch_Port_Information_CAR",$sformatf("After second read 'h14 read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
 //Source_Operations_CAR
     ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h18;
     });
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Source_Operations_CAR.get();
        ttype_0 = 1;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h18;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Source_Operations_CAR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h18;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Source_Operations_CAR.get();
        `uvm_info("RO Source_Operations_CAR",$sformatf("After first read 'h18 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Source_Operations_CAR",$sformatf("After first write 'h18 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Source_Operations_CAR",$sformatf("After second read 'h18 read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
 //Destination_Operations_CAR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h1c;
     });
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Destination_Operations_CAR.get();
     ttype_0 = 1;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h1c;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Destination_Operations_CAR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h1c;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Destination_Operations_CAR.get();
        `uvm_info("RO Destination_Operations_CAR",$sformatf("After first read 'h1c read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Destination_Operations_CAR",$sformatf("After first write 'h1c write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Destination_Operations_CAR",$sformatf("After second read 'h1c read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Switch_Route_Table_Destination_ID_Limit_CAR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h34;
     });
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Switch_Route_Table_Destination_ID_Limit_CAR.get();
      ttype_0 = 1;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h34;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Switch_Route_Table_Destination_ID_Limit_CAR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h34;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Switch_Route_Table_Destination_ID_Limit_CAR.get();
        `uvm_info("RO Switch_Route_Table_Destination_ID_Limit_CAR",$sformatf("After first read 'h34 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Switch_Route_Table_Destination_ID_Limit_CAR",$sformatf("After first write 'h34 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Switch_Route_Table_Destination_ID_Limit_CAR",$sformatf("After second read 'h34 read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
 //Data_Streaming_Information_CAR
 ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h3c;
     });
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Data_Streaming_Information_CAR.get();
     ttype_0 = 1;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h3c;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Data_Streaming_Information_CAR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h3c;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Data_Streaming_Information_CAR.get();
        `uvm_info("RO Data_Streaming_Information_CAR",$sformatf("After first read 'h3c read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Data_Streaming_Information_CAR",$sformatf("After first write 'h3c write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Data_Streaming_Information_CAR",$sformatf("After second read 'h3c read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);


      //Data_Streaming_Logical_Layer_Control_CSR
      ttype_0 = 1;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h48;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Data_Streaming_Logical_Layer_Control_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
            `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);             
             `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if({write_data[31:24],write_data[7:4]} == {expected_write1[31:24],expected_write1[7:4]})
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")

        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h48;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Data_Streaming_Logical_Layer_Control_CSR.get();
        `uvm_info("RW Data_Streaming_Logical_Layer_Control_CSR",$sformatf("After first write 'h48 write_data = %h", write_data),UVM_LOW);
     if({write_data[31:24],write_data[7:4]} != {read1_data[31:24],read1_data[7:4]})
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Processing_Element_Logical_Layer_Control_CSR
     ttype_0 = 1;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h4c;
     });
      for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Processing_Element_Logical_Layer_Control_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
            `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);              
           `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data[31:29] == expected_write1[31:29])
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h4c;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Processing_Element_Logical_Layer_Control_CSR.get();
        `uvm_info("RW Processing_Element_Logical_Layer_Control_CSR",$sformatf("After first write 'h4c write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Processing_Element_Logical_Layer_Control_CSR",$sformatf("After first read 'h4c read1_data = %h", read1_data),UVM_LOW);       
       if(write_data != read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Local_Configuration_Space_Base_Address_0_CSR
     ttype_0 = 1;
 start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h58;
     });
        for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Local_Configuration_Space_Base_Address_0_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
            `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);     
              `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);    if(write_data == expected_write1)
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h58;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Local_Configuration_Space_Base_Address_0_CSR.get();
        `uvm_info("RW Local_Configuration_Space_Base_Address_0_CSR",$sformatf("After first write 'h58 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Local_Configuration_Space_Base_Address_0_CSR",$sformatf("After first read 'h58 read1_data = %h", read1_data),UVM_LOW);       
       if(write_data != read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Local_Configuration_Space_Base_Address_1_CSR
     ttype_0 = 1;

 start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h5c;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Local_Configuration_Space_Base_Address_1_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
            `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);     
          `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW); 
        
     if(write_data == expected_write1)
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h5c;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Local_Configuration_Space_Base_Address_1_CSR.get();
        `uvm_info("RW Local_Configuration_Space_Base_Address_1_CSR",$sformatf("After first write 'h5c write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Local_Configuration_Space_Base_Address_1_CSR",$sformatf("After first read 'h5c read1_data = %h", read1_data),UVM_LOW);       
       if(write_data != read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Base_Device_ID_CSR
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h60;
     });
        for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Base_Device_ID_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
            `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);    
           `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);          
     if(write_data[31:8] == expected_write1[31:8])
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h60;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Base_Device_ID_CSR.get();
        `uvm_info("RW Base_Device_ID_CSR",$sformatf("After first write 'h60 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Base_Device_ID_CSR",$sformatf("After first read 'h60 read1_data = %h", read1_data),UVM_LOW);       
       if(write_data != read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Dev32_Base_Device_ID_CSR
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h64;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Dev32_Base_Device_ID_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);     
          `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data == expected_write1)
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h64;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Dev32_Base_Device_ID_CSR.get();
        `uvm_info("RW Dev32_Base_Device_ID_CSR",$sformatf("After first write 'h64 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Dev32_Base_Device_ID_CSR",$sformatf("After first read 'h64 read1_data = %h", read1_data),UVM_LOW);       
       if(write_data != read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Host_Base_Device_ID_Lock_CSR
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h68;
     });
        for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Host_Base_Device_ID_Lock_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);     
          `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data == expected_write1)
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h68;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Host_Base_Device_ID_Lock_CSR.get();
        `uvm_info("RW Host_Base_Device_ID_Lock_CSR",$sformatf("After first write 'h68 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Host_Base_Device_ID_Lock_CSR",$sformatf("After first read 'h68 read1_data = %h", read1_data),UVM_LOW);       
       if(write_data != read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Component_Tag_CSR
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h6c;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Component_Tag_CSR.get();     
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);     
          `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data == expected_write1)
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h6c;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Component_Tag_CSR.get();
        `uvm_info("RW Component_Tag_CSR",$sformatf("After first write 'h6c write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Component_Tag_CSR",$sformatf("After first read 'h6c read1_data = %h", read1_data),UVM_LOW);       
       if(write_data != read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Standard_Route_Configuration_Destination_ID_Select_CSR
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h70;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Standard_Route_Configuration_Destination_ID_Select_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);     
          `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if({write_data[31:16],write_data[0]} == {expected_write1[31:16],expected_write1[0]})
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h70;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Standard_Route_Configuration_Destination_ID_Select_CSR.get();
        `uvm_info("RW Standard_Route_Configuration_Destination_ID_Select_CSR",$sformatf("After first write 'h70 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Standard_Route_Configuration_Destination_ID_Select_CSR",$sformatf("After first read 'h70 read1_data = %h", read1_data),UVM_LOW);       
       if(write_data != read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);    
//Standard_Route_Configuration_Port_Select_CSR
 ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h74;
     });
       for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Standard_Route_Configuration_Port_Select_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);     
          `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data == expected_write1)
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h74;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Standard_Route_Configuration_Port_Select_CSR.get();
         `uvm_info("RW Standard_Route_Configuration_Port_Select_CSR",$sformatf("After first write 'h74 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Standard_Route_Configuration_Port_Select_CSR",$sformatf("After first read 'h74 read1_data = %h", read1_data),UVM_LOW);       
       if(write_data != read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW); 
//Standard_Route_Default_Port_CSR
     ttype_0 = 1;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h78;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Standard_Route_Default_Port_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);     
          `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data[31:22] == expected_write1[31:22])
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == 'h78;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Standard_Route_Default_Port_CSR.get();
         `uvm_info("RW Standard_Route_Default_Port_CSR",$sformatf("After first write 'h78 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Standard_Route_Default_Port_CSR",$sformatf("After first read 'h78 read1_data = %h", read1_data),UVM_LOW);       
       if(write_data != read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);    
  
//EXT1
//LP_Serial_Register_Block_Header
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+'h00;
     });
      for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.LP_Serial_Register_Block_Header.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);    
           `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data != expected_write)
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+'h00;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.LP_Serial_Register_Block_Header.get();
         `uvm_info("RW LP_Serial_Register_Block_Header",$sformatf("After first write 'EXT1_BASE_ADDR+'h00 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW LP_Serial_Register_Block_Header",$sformatf("After first read 'EXT1_BASE_ADDR+'h00 read1_data = %h", read1_data),UVM_LOW);       
       if(write_data != read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW); 
//Port_Link_Timeout_Control_CSR
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+'h20;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Port_Link_Timeout_Control_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);
               `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data == expected_write1)
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+'h20;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Port_Link_Timeout_Control_CSR.get();
         `uvm_info("RW Port_Link_Timeout_Control_CSR",$sformatf("After first write 'EXT1_BASE_ADDR+'h20 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Port_Link_Timeout_Control_CSR",$sformatf("After first read 'EXT1_BASE_ADDR+'h20 read1_data = %h", read1_data),UVM_LOW);       
       if(write_data != read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);     
//Port_Response_Timeout_Control_CSR
 ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+'h24;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Port_Response_Timeout_Control_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW); 
              `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data == expected_write1)
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+'h24;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Port_Response_Timeout_Control_CSR.get();
         `uvm_info("RW Port_Response_Timeout_Control_CSR",$sformatf("After first write 'EXT1_BASE_ADDR+'h24 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Port_Response_Timeout_Control_CSR",$sformatf("After first read 'EXT1_BASE_ADDR+'h24 read1_data = %h", read1_data),UVM_LOW);       
       if(write_data != read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);       
//Port_General_Control_CSR
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+'h3c;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Port_General_Control_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW); 
              `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data[2:0] == expected_write1[2:0])
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+'h3c;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Port_General_Control_CSR.get();
        `uvm_info("RW Port_General_Control_CSR",$sformatf("After first write 'EXT1_BASE_ADDR+'h3c write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Port_General_Control_CSR",$sformatf("After first read 'EXT1_BASE_ADDR+'h3c read1_data = %h", read1_data),UVM_LOW);       
       if(write_data != read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);      
//Port_0_Link_Maintenance_Request_CSR
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+'h40;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Port_0_Link_Maintenance_Request_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW); 
              `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data[31:29] == expected_write1[31:29])
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+'h40;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Port_0_Link_Maintenance_Request_CSR.get();
       `uvm_info("RW Port_0_Link_Maintenance_Request_CSR",$sformatf("After first write 'EXT1_BASE_ADDR+'h40 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Port_0_Link_Maintenance_Request_CSR",$sformatf("After first read 'EXT1_BASE_ADDR+'h40 read1_data = %h", read1_data),UVM_LOW);       
       if(write_data != read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Port_1_Link_Maintenance_Request_CSR
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+'h80;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Port_1_Link_Maintenance_Request_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW); 
              `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data[31:29] == expected_write1[31:29])
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+'h80;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Port_1_Link_Maintenance_Request_CSR.get();
       `uvm_info("RW Port_1_Link_Maintenance_Request_CSR",$sformatf("After first write 'EXT1_BASE_ADDR+'h80 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Port_1_Link_Maintenance_Request_CSR",$sformatf("After first read 'EXT1_BASE_ADDR+'h80 read1_data = %h", read1_data),UVM_LOW);       
       if(write_data != read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Port_2_Link_Maintenance_Request_CSR
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+'hc0;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Port_2_Link_Maintenance_Request_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW); 
              `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data[31:29] == expected_write1[31:29])
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+'hc0;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Port_2_Link_Maintenance_Request_CSR.get();
       `uvm_info("RW Port_2_Link_Maintenance_Request_CSR",$sformatf("After first write 'EXT1_BASE_ADDR+'hc0 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Port_2_Link_Maintenance_Request_CSR",$sformatf("After first read 'EXT1_BASE_ADDR+'hc0 read1_data = %h", read1_data),UVM_LOW);       
       if(write_data != read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Port_3_Link_Maintenance_Request_CSR
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+'h100;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Port_3_Link_Maintenance_Request_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW); 
              `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data[31:29] == expected_write1[31:29])
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+'h100;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Port_3_Link_Maintenance_Request_CSR.get();
       `uvm_info("RW Port_3_Link_Maintenance_Request_CSR",$sformatf("After first write 'EXT1_BASE_ADDR+'h100 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Port_3_Link_Maintenance_Request_CSR",$sformatf("After first read 'EXT1_BASE_ADDR+'h100 read1_data = %h", read1_data),UVM_LOW);       
       if(write_data != read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Port_4_Link_Maintenance_Request_CSR
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+'h140;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Port_4_Link_Maintenance_Request_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW); 
              `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data[31:29] == expected_write1[31:29])
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+'h140;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Port_4_Link_Maintenance_Request_CSR.get();
       `uvm_info("RW Port_4_Link_Maintenance_Request_CSR",$sformatf("After first write 'EXT1_BASE_ADDR+'h140 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Port_4_Link_Maintenance_Request_CSR",$sformatf("After first read 'EXT1_BASE_ADDR+'h140 read1_data = %h", read1_data),UVM_LOW);       
       if(write_data != read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Port_5_Link_Maintenance_Request_CSR
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+'h180;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Port_5_Link_Maintenance_Request_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW); 
              `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data[31:29] == expected_write1[31:29])
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+'h180;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Port_5_Link_Maintenance_Request_CSR.get();
       `uvm_info("RW Port_5_Link_Maintenance_Request_CSR",$sformatf("After first write 'EXT1_BASE_ADDR+'h180 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Port_5_Link_Maintenance_Request_CSR",$sformatf("After first read 'EXT1_BASE_ADDR+'h180 read1_data = %h", read1_data),UVM_LOW);       
       if(write_data != read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Port_6_Link_Maintenance_Request_CSR
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+'h1c0;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Port_6_Link_Maintenance_Request_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW); 
              `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data[31:29] == expected_write1[31:29])
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+'h1c0;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Port_6_Link_Maintenance_Request_CSR.get();
       `uvm_info("RW Port_6_Link_Maintenance_Request_CSR",$sformatf("After first write 'EXT1_BASE_ADDR+'h1c0 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Port_6_Link_Maintenance_Request_CSR",$sformatf("After first read 'EXT1_BASE_ADDR+'h1c0 read1_data = %h", read1_data),UVM_LOW);       
       if(write_data != read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Port_7_Link_Maintenance_Request_CSR
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+'h200;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Port_7_Link_Maintenance_Request_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW); 
              `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data[31:29] == expected_write1[31:29])
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+'h200;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Port_7_Link_Maintenance_Request_CSR.get();
       `uvm_info("RW Port_7_Link_Maintenance_Request_CSR",$sformatf("After first write 'EXT1_BASE_ADDR+'h200 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Port_7_Link_Maintenance_Request_CSR",$sformatf("After first read 'EXT1_BASE_ADDR+'h200 read1_data = %h", read1_data),UVM_LOW);       
       if(write_data != read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Port_8_Link_Maintenance_Request_CSR
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+'h240;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Port_8_Link_Maintenance_Request_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW); 
              `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data[31:29] == expected_write1[31:29])
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+'h240;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Port_8_Link_Maintenance_Request_CSR.get();
       `uvm_info("RW Port_8_Link_Maintenance_Request_CSR",$sformatf("After first write 'EXT1_BASE_ADDR+'h240 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Port_8_Link_Maintenance_Request_CSR",$sformatf("After first read 'EXT1_BASE_ADDR+'h240 read1_data = %h", read1_data),UVM_LOW);       
       if(write_data != read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Port_9_Link_Maintenance_Request_CSR
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+'h280;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Port_9_Link_Maintenance_Request_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW); 
              `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data[31:29] == expected_write1[31:29])
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+'h280;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Port_9_Link_Maintenance_Request_CSR.get();
       `uvm_info("RW Port_9_Link_Maintenance_Request_CSR",$sformatf("After first write 'EXT1_BASE_ADDR+'h280 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Port_9_Link_Maintenance_Request_CSR",$sformatf("After first read 'EXT1_BASE_ADDR+'h280 read1_data = %h", read1_data),UVM_LOW);       
       if(write_data != read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Port_10_Link_Maintenance_Request_CSR
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+'h2c0;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Port_10_Link_Maintenance_Request_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW); 
              `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data[31:29] == expected_write1[31:29])
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+'h2c0;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Port_10_Link_Maintenance_Request_CSR.get();
       `uvm_info("RW Port_10_Link_Maintenance_Request_CSR",$sformatf("After first write 'EXT1_BASE_ADDR+'h2c0 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Port_10_Link_Maintenance_Request_CSR",$sformatf("After first read 'EXT1_BASE_ADDR+'h2c0 read1_data = %h", read1_data),UVM_LOW);       
       if(write_data != read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Port_11_Link_Maintenance_Request_CSR
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+'h300;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Port_11_Link_Maintenance_Request_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW); 
              `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data[31:29] == expected_write1[31:29])
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+'h300;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Port_11_Link_Maintenance_Request_CSR.get();
       `uvm_info("RW Port_11_Link_Maintenance_Request_CSR",$sformatf("After first write 'EXT1_BASE_ADDR+'h300 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Port_11_Link_Maintenance_Request_CSR",$sformatf("After first read 'EXT1_BASE_ADDR+'h300 read1_data = %h", read1_data),UVM_LOW);       
       if(write_data != read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Port_12_Link_Maintenance_Request_CSR
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+'h340;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Port_12_Link_Maintenance_Request_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW); 
              `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data[31:29] == expected_write1[31:29])
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+'h340;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Port_12_Link_Maintenance_Request_CSR.get();
       `uvm_info("RW Port_12_Link_Maintenance_Request_CSR",$sformatf("After first write 'EXT1_BASE_ADDR+'h340 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Port_12_Link_Maintenance_Request_CSR",$sformatf("After first read 'EXT1_BASE_ADDR+'h340 read1_data = %h", read1_data),UVM_LOW);       
       if(write_data != read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Port_13_Link_Maintenance_Request_CSR
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+'h380;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Port_13_Link_Maintenance_Request_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW); 
              `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data[31:29] == expected_write1[31:29])
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+'h380;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Port_13_Link_Maintenance_Request_CSR.get();
       `uvm_info("RW Port_13_Link_Maintenance_Request_CSR",$sformatf("After first write 'EXT1_BASE_ADDR+'h380 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Port_13_Link_Maintenance_Request_CSR",$sformatf("After first read 'EXT1_BASE_ADDR+'h380 read1_data = %h", read1_data),UVM_LOW);       
       if(write_data != read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Port_14_Link_Maintenance_Request_CSR
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+'h3c0;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Port_14_Link_Maintenance_Request_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW); 
              `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data[31:29] == expected_write1[31:29])
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+'h3c0;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Port_14_Link_Maintenance_Request_CSR.get();
       `uvm_info("RW Port_14_Link_Maintenance_Request_CSR",$sformatf("After first write 'EXT1_BASE_ADDR+'h3c0 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Port_14_Link_Maintenance_Request_CSR",$sformatf("After first read 'EXT1_BASE_ADDR+'h3c0 read1_data = %h", read1_data),UVM_LOW);       
       if(write_data != read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Port_15_Link_Maintenance_Request_CSR
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+'h400;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Port_15_Link_Maintenance_Request_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW); 
              `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data[31:29] == expected_write1[31:29])
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+'h400;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Port_15_Link_Maintenance_Request_CSR.get();
       `uvm_info("RW Port_15_Link_Maintenance_Request_CSR",$sformatf("After first write 'EXT1_BASE_ADDR+'h400 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Port_15_Link_Maintenance_Request_CSR",$sformatf("After first read 'EXT1_BASE_ADDR+'h400 read1_data = %h", read1_data),UVM_LOW);       
       if(write_data != read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

Port_n_Link_Maintenance_Response_CSR_task('h44);
Port_n_Link_Maintenance_Response_CSR_task('h84);
Port_n_Link_Maintenance_Response_CSR_task('hc4);
Port_n_Link_Maintenance_Response_CSR_task('h104);
Port_n_Link_Maintenance_Response_CSR_task('h144);
Port_n_Link_Maintenance_Response_CSR_task('h184);
Port_n_Link_Maintenance_Response_CSR_task('h1c4);
Port_n_Link_Maintenance_Response_CSR_task('h204);
Port_n_Link_Maintenance_Response_CSR_task('h244);
Port_n_Link_Maintenance_Response_CSR_task('h284);
Port_n_Link_Maintenance_Response_CSR_task('h2c4);
Port_n_Link_Maintenance_Response_CSR_task('h304);
Port_n_Link_Maintenance_Response_CSR_task('h344);
Port_n_Link_Maintenance_Response_CSR_task('h384);
Port_n_Link_Maintenance_Response_CSR_task('h3c4);
Port_n_Link_Maintenance_Response_CSR_task('h404);

if(!srio_reg_model.brc3)
begin  
Port_n_Local_ackID_CSR_task('h48);
Port_n_Local_ackID_CSR_task('h68);
Port_n_Local_ackID_CSR_task('h88);
Port_n_Local_ackID_CSR_task('ha8);
Port_n_Local_ackID_CSR_task('hc8);
Port_n_Local_ackID_CSR_task('he8);
Port_n_Local_ackID_CSR_task('h108);
Port_n_Local_ackID_CSR_task('h128);
Port_n_Local_ackID_CSR_task('h148);
Port_n_Local_ackID_CSR_task('h168);
Port_n_Local_ackID_CSR_task('h188);
Port_n_Local_ackID_CSR_task('h1a8);
Port_n_Local_ackID_CSR_task('h1c8);
Port_n_Local_ackID_CSR_task('h1e8);
Port_n_Local_ackID_CSR_task('h208);
Port_n_Local_ackID_CSR_task('h228);
end

//Port_0_Error_and_Status_CSR
Port_0_Error_and_Status_CSR_task('h58);
Port_0_Error_and_Status_CSR_task('h98);
Port_0_Error_and_Status_CSR_task('hd8);
Port_0_Error_and_Status_CSR_task('h118);
Port_0_Error_and_Status_CSR_task('h158);
Port_0_Error_and_Status_CSR_task('h198);
Port_0_Error_and_Status_CSR_task('h1d8);
Port_0_Error_and_Status_CSR_task('h218);
Port_0_Error_and_Status_CSR_task('h258);
Port_0_Error_and_Status_CSR_task('h298);
Port_0_Error_and_Status_CSR_task('h2d8);
Port_0_Error_and_Status_CSR_task('h318);
Port_0_Error_and_Status_CSR_task('h358);
Port_0_Error_and_Status_CSR_task('h398);
Port_0_Error_and_Status_CSR_task('h3d8);
Port_0_Error_and_Status_CSR_task('h418);

//Port_0_Control_CSR
Port_0_Control_CSR_task('h5c);
Port_0_Control_CSR_task('h9c);
Port_0_Control_CSR_task('hdc);
Port_0_Control_CSR_task('h11c);
Port_0_Control_CSR_task('h15c);
Port_0_Control_CSR_task('h19c);
Port_0_Control_CSR_task('h1dc);
Port_0_Control_CSR_task('h21c);
Port_0_Control_CSR_task('h25c);
Port_0_Control_CSR_task('h29c);
Port_0_Control_CSR_task('h2dc);
Port_0_Control_CSR_task('h31c);
Port_0_Control_CSR_task('h35c);
Port_0_Control_CSR_task('h39c);
Port_0_Control_CSR_task('h3dc);
Port_0_Control_CSR_task('h41c);


//Port_0_Initialization_Status_CSR
Port_0_Initialization_Status_CSR_task('h4c);
Port_0_Initialization_Status_CSR_task('h8c);
Port_0_Initialization_Status_CSR_task('hcc);
Port_0_Initialization_Status_CSR_task('h10c);
Port_0_Initialization_Status_CSR_task('h14c);
Port_0_Initialization_Status_CSR_task('h18c);
Port_0_Initialization_Status_CSR_task('h1cc);
Port_0_Initialization_Status_CSR_task('h20c);
Port_0_Initialization_Status_CSR_task('h24c);
Port_0_Initialization_Status_CSR_task('h28c);
Port_0_Initialization_Status_CSR_task('h2cc);
Port_0_Initialization_Status_CSR_task('h30c);
Port_0_Initialization_Status_CSR_task('h34c);
Port_0_Initialization_Status_CSR_task('h38c);
Port_0_Initialization_Status_CSR_task('h3cc);
Port_0_Initialization_Status_CSR_task('h40c);

//Port_0_Outbound_ackID_CSR
Port_0_Outbound_ackID_CSR_task('h60);
Port_0_Outbound_ackID_CSR_task('ha0);
Port_0_Outbound_ackID_CSR_task('he0);
Port_0_Outbound_ackID_CSR_task('h120);
Port_0_Outbound_ackID_CSR_task('h160);
Port_0_Outbound_ackID_CSR_task('h1a0);
Port_0_Outbound_ackID_CSR_task('h1e0);
Port_0_Outbound_ackID_CSR_task('h220);
Port_0_Outbound_ackID_CSR_task('h260);
Port_0_Outbound_ackID_CSR_task('h2a0);
Port_0_Outbound_ackID_CSR_task('h2e0);
Port_0_Outbound_ackID_CSR_task('h320);
Port_0_Outbound_ackID_CSR_task('h360);
Port_0_Outbound_ackID_CSR_task('h3a0);
Port_0_Outbound_ackID_CSR_task('h3e0);
Port_0_Outbound_ackID_CSR_task('h420);


//Port_0_Inbound_ackID_CSR
Port_0_Inbound_ackID_CSR_task('h64);
Port_0_Inbound_ackID_CSR_task('ha4);
Port_0_Inbound_ackID_CSR_task('he4);
Port_0_Inbound_ackID_CSR_task('h124);
Port_0_Inbound_ackID_CSR_task('h164);
Port_0_Inbound_ackID_CSR_task('h1a4);
Port_0_Inbound_ackID_CSR_task('h1e4);
Port_0_Inbound_ackID_CSR_task('h224);
Port_0_Inbound_ackID_CSR_task('h264);
Port_0_Inbound_ackID_CSR_task('h2a4);
Port_0_Inbound_ackID_CSR_task('h2e4);
Port_0_Inbound_ackID_CSR_task('h324);
Port_0_Inbound_ackID_CSR_task('h364);
Port_0_Inbound_ackID_CSR_task('h3a4);
Port_0_Inbound_ackID_CSR_task('h3e4);
Port_0_Inbound_ackID_CSR_task('h424);

//Port_0_Power_Management_CSR
Port_0_Power_Management_CSR_task('h68);
Port_0_Power_Management_CSR_task('ha8);
Port_0_Power_Management_CSR_task('he8);
Port_0_Power_Management_CSR_task('h128);
Port_0_Power_Management_CSR_task('h168);
Port_0_Power_Management_CSR_task('h1a8);
Port_0_Power_Management_CSR_task('h168);
Port_0_Power_Management_CSR_task('h1e8);
Port_0_Power_Management_CSR_task('h228);
Port_0_Power_Management_CSR_task('h268);
Port_0_Power_Management_CSR_task('h2a8);
Port_0_Power_Management_CSR_task('h328);
Port_0_Power_Management_CSR_task('h368);
Port_0_Power_Management_CSR_task('h3a8);
Port_0_Power_Management_CSR_task('h3e8);
Port_0_Power_Management_CSR_task('h428);


//Port_0_Latency_Optimization_CSR
Port_0_Latency_Optimization_CSR_task('h6c);
Port_0_Latency_Optimization_CSR_task('hac);
Port_0_Latency_Optimization_CSR_task('hec);
Port_0_Latency_Optimization_CSR_task('h12c);
Port_0_Latency_Optimization_CSR_task('h16c);
Port_0_Latency_Optimization_CSR_task('h1ac);
Port_0_Latency_Optimization_CSR_task('h1ec);
Port_0_Latency_Optimization_CSR_task('h22c);
Port_0_Latency_Optimization_CSR_task('h26c);
Port_0_Latency_Optimization_CSR_task('h1ac);
Port_0_Latency_Optimization_CSR_task('h2ec);
Port_0_Latency_Optimization_CSR_task('h32c);
Port_0_Latency_Optimization_CSR_task('h36c);
Port_0_Latency_Optimization_CSR_task('h3ac);
Port_0_Latency_Optimization_CSR_task('h3ec);
Port_0_Latency_Optimization_CSR_task('h42c);

//Port_0_Link_Timers_Control_CSR
Port_0_Link_Timers_Control_CSR_task('h70);
Port_0_Link_Timers_Control_CSR_task('hb0);
Port_0_Link_Timers_Control_CSR_task('hf0);
Port_0_Link_Timers_Control_CSR_task('h130);
Port_0_Link_Timers_Control_CSR_task('h170);
Port_0_Link_Timers_Control_CSR_task('h1b0);
Port_0_Link_Timers_Control_CSR_task('h1f0);
Port_0_Link_Timers_Control_CSR_task('h230);
Port_0_Link_Timers_Control_CSR_task('h270);
Port_0_Link_Timers_Control_CSR_task('h2b0);
Port_0_Link_Timers_Control_CSR_task('h2f0);
Port_0_Link_Timers_Control_CSR_task('h330);
Port_0_Link_Timers_Control_CSR_task('h370);
Port_0_Link_Timers_Control_CSR_task('h3b0);
Port_0_Link_Timers_Control_CSR_task('h3f0);
Port_0_Link_Timers_Control_CSR_task('h430);


//Port_0_Link_Timers_Control_2_CSR
Port_0_Link_Timers_Control_2_CSR_task('h74);
Port_0_Link_Timers_Control_2_CSR_task('hb4);
Port_0_Link_Timers_Control_2_CSR_task('hf4);
Port_0_Link_Timers_Control_2_CSR_task('h134);
Port_0_Link_Timers_Control_2_CSR_task('h174);
Port_0_Link_Timers_Control_2_CSR_task('h1b4);
Port_0_Link_Timers_Control_2_CSR_task('h1f4);
Port_0_Link_Timers_Control_2_CSR_task('h234);
Port_0_Link_Timers_Control_2_CSR_task('h274);
Port_0_Link_Timers_Control_2_CSR_task('h2b4);
Port_0_Link_Timers_Control_2_CSR_task('h2f4);
Port_0_Link_Timers_Control_2_CSR_task('h334);
Port_0_Link_Timers_Control_2_CSR_task('h374);
Port_0_Link_Timers_Control_2_CSR_task('h3b4);
Port_0_Link_Timers_Control_2_CSR_task('h3f4);
Port_0_Link_Timers_Control_2_CSR_task('h434);

//Port_0_Link_Timers_Control_3_CSR
Port_0_Link_Timers_Control_3_CSR_task('h78);
Port_0_Link_Timers_Control_3_CSR_task('hb8);
Port_0_Link_Timers_Control_3_CSR_task('hf8);
Port_0_Link_Timers_Control_3_CSR_task('h138);
Port_0_Link_Timers_Control_3_CSR_task('h178);
Port_0_Link_Timers_Control_3_CSR_task('h1b8);
Port_0_Link_Timers_Control_3_CSR_task('h1f8);
Port_0_Link_Timers_Control_3_CSR_task('h238);
Port_0_Link_Timers_Control_3_CSR_task('h278);
Port_0_Link_Timers_Control_3_CSR_task('h2b8);
Port_0_Link_Timers_Control_3_CSR_task('h2f8);
Port_0_Link_Timers_Control_3_CSR_task('h338);
Port_0_Link_Timers_Control_3_CSR_task('h378);
Port_0_Link_Timers_Control_3_CSR_task('h3b8);
Port_0_Link_Timers_Control_3_CSR_task('h3f8);
Port_0_Link_Timers_Control_3_CSR_task('h438);


//EXT2
//LP_Serial_Lane_Register_Block_Header
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h00;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.LP_Serial_Lane_Register_Block_Header.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW); 
              `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data[31:16] == 32'h000d)
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h00;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.LP_Serial_Lane_Register_Block_Header.get();
       `uvm_info("RW LP_Serial_Lane_Register_Block_Header",$sformatf("After first write 'EXT2_BASE_ADDR+'h00 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW LP_Serial_Lane_Register_Block_Header",$sformatf("After first read 'EXT2_BASE_ADDR+'h00 read1_data = %h", read1_data),UVM_LOW);       
       if(write_data != read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Lane_0_Status_0_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h10;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_0_Status_0_CSR.get();
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h10;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_0_Status_0_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h10;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_0_Status_0_CSR.get();
        `uvm_info("RO Lane_0_Status_0_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h10 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_0_Status_0_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h10 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_0_Status_0_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h10 read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Lane_0_Status_1_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h14;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_0_Status_1_CSR.get();
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h14;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_0_Status_1_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h14;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_0_Status_1_CSR.get();
        `uvm_info("RW Lane_0_Status_1_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h14 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RW Lane_0_Status_1_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h14 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Lane_0_Status_1_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h14 read2_data = %h", read2_data),UVM_LOW);  
     if(read2_data != {read1_data[31:1],write_data[0]})
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Lane_0_Status_2_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h18;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_0_Status_2_CSR.get();
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h18;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_0_Status_2_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h18;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_0_Status_2_CSR.get();
        `uvm_info("RO Lane_0_Status_2_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h18 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_0_Status_2_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h18 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_0_Status_2_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h18 read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
 //Lane_0_Status_3_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h1c;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_0_Status_3_CSR.get();
 ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h1c;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_0_Status_3_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h1c;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_0_Status_3_CSR.get();
        `uvm_info("RO Lane_0_Status_3_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h1c read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_0_Status_3_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h1c write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_0_Status_3_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h1c read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Lane_1_Status_0_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h30;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_1_Status_0_CSR.get();
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h30;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_1_Status_0_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h30;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_1_Status_0_CSR.get();
        `uvm_info("RO Lane_1_Status_0_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h30 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_1_Status_0_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h30 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_1_Status_0_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h30 read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Lane_1_Status_1_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h34;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_1_Status_1_CSR.get();
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h34;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_1_Status_1_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h34;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_1_Status_1_CSR.get();
        `uvm_info("RW Lane_1_Status_1_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h34 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RW Lane_1_Status_1_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h34 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Lane_1_Status_1_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h34 read2_data = %h", read2_data),UVM_LOW);  
     if(read2_data != {read1_data[31:1],write_data[0]})
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Lane_1_Status_2_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h38;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_1_Status_2_CSR.get();
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h38;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_1_Status_2_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h38;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_1_Status_2_CSR.get();
        `uvm_info("RO Lane_1_Status_2_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h38 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_1_Status_2_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h38 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_1_Status_2_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h38 read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
 //Lane_1_Status_3_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h3c;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_1_Status_3_CSR.get();
 ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h3c;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_1_Status_3_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h3c;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_1_Status_3_CSR.get();
        `uvm_info("RO Lane_1_Status_3_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h3c read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_1_Status_3_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h3c write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_1_Status_3_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h3c read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Lane_2_Status_0_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h50;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_2_Status_0_CSR.get();
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h70;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_2_Status_0_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h70;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_2_Status_0_CSR.get();
        `uvm_info("RO Lane_2_Status_0_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h70 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_2_Status_0_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h70 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_2_Status_0_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h70 read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Lane_2_Status_1_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h54;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_2_Status_1_CSR.get();
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h54;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_2_Status_1_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h54;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_2_Status_1_CSR.get();
        `uvm_info("RW Lane_2_Status_1_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h54 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RW Lane_2_Status_1_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h54 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Lane_2_Status_1_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h54 read2_data = %h", read2_data),UVM_LOW);  
     if(read2_data != {read1_data[31:1],write_data[0]})
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Lane_2_Status_2_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h58;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_2_Status_2_CSR.get();
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h58;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_2_Status_2_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h58;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_2_Status_2_CSR.get();
        `uvm_info("RO Lane_2_Status_2_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h58 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_2_Status_2_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h58 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_2_Status_2_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h58 read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
 //Lane_2_Status_3_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h5c;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_2_Status_3_CSR.get();
 ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h5c;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_2_Status_3_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h5c;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_2_Status_3_CSR.get();
        `uvm_info("RO Lane_2_Status_3_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h5c read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_2_Status_3_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h5c write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_2_Status_3_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h5c read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Lane_3_Status_0_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h70;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_3_Status_0_CSR.get();
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h70;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_3_Status_0_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h70;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_3_Status_0_CSR.get();
        `uvm_info("RO Lane_3_Status_0_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h70 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_3_Status_0_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h70 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_3_Status_0_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h70 read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Lane_3_Status_1_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h74;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_3_Status_1_CSR.get();
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h74;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_3_Status_1_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h74;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_3_Status_1_CSR.get();
        `uvm_info("RW Lane_3_Status_1_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h74 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RW Lane_3_Status_1_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h74 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Lane_3_Status_1_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h74 read2_data = %h", read2_data),UVM_LOW);  
     if(read2_data != {read1_data[31:1],write_data[0]})
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Lane_3_Status_2_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h78;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_3_Status_2_CSR.get();
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h78;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_3_Status_2_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h78;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_3_Status_2_CSR.get();
        `uvm_info("RO Lane_3_Status_2_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h78 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_3_Status_2_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h78 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_3_Status_2_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h78 read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
 //Lane_3_Status_3_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h7c;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_3_Status_3_CSR.get();
 ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h7c;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_3_Status_3_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h7c;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_3_Status_3_CSR.get();
        `uvm_info("RO Lane_3_Status_3_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h7c read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_3_Status_3_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h7c write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_3_Status_3_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h7c read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Lane_4_Status_0_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h90;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_4_Status_0_CSR.get();
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h90;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_4_Status_0_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h90;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_4_Status_0_CSR.get();
        `uvm_info("RO Lane_4_Status_0_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h90 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_4_Status_0_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h90 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_4_Status_0_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h90 read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Lane_4_Status_1_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h94;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_4_Status_1_CSR.get();
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h94;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_4_Status_1_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h94;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_4_Status_1_CSR.get();
        `uvm_info("RW Lane_4_Status_1_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h94 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RW Lane_4_Status_1_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h94 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Lane_4_Status_1_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h94 read2_data = %h", read2_data),UVM_LOW);  
     if(read2_data != {read1_data[31:1],write_data[0]})
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Lane_4_Status_2_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h98;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_4_Status_2_CSR.get();
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h98;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_4_Status_2_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h98;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_4_Status_2_CSR.get();
        `uvm_info("RO Lane_4_Status_2_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h98 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_4_Status_2_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h98 write_data = %h", write_data),UVM_LOW);
       `uvm_info("RO Lane_4_Status_2_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h98 read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
 //Lane_4_Status_3_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h9c;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_4_Status_3_CSR.get();
 ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h9c;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_4_Status_3_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h9c;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_4_Status_3_CSR.get();
        `uvm_info("RO Lane_4_Status_3_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h9c read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_4_Status_3_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h9c write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_4_Status_3_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h9c read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Lane_5_Status_0_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'hb0;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_5_Status_0_CSR.get();
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'hb0;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_5_Status_0_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'hb0;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_5_Status_0_CSR.get();
        `uvm_info("RO Lane_5_Status_0_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'hb0 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_5_Status_0_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'hb0 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_5_Status_0_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'hb0 read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Lane_5_Status_1_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'hb4;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_5_Status_1_CSR.get();
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'hb4;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_5_Status_1_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'hb4;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_5_Status_1_CSR.get();
        `uvm_info("RW Lane_5_Status_1_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'hb4 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RW Lane_5_Status_1_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'hb4 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Lane_5_Status_1_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'hb4 read2_data = %h", read2_data),UVM_LOW);  
     if(read2_data != {read1_data[31:1],write_data[0]})
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Lane_5_Status_2_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'hb8;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_5_Status_2_CSR.get();
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'hb8;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_5_Status_2_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'hb8;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_5_Status_2_CSR.get();
        `uvm_info("RO Lane_5_Status_2_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'hb8 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_5_Status_2_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'hb8 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_5_Status_2_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'hb8 read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
 //Lane_5_Status_3_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'hbc;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_5_Status_3_CSR.get();
 ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'hbc;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_5_Status_3_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'hbc;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_5_Status_3_CSR.get();
        `uvm_info("RO Lane_5_Status_3_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'hbc read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_5_Status_3_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'hbc write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_5_Status_3_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'hbc read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Lane_6_Status_0_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'hd0;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_6_Status_0_CSR.get();
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'hd0;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_6_Status_0_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'hd0;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_6_Status_0_CSR.get();
        `uvm_info("RO Lane_6_Status_0_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'hd0 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_6_Status_0_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'hd0 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_6_Status_0_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'hd0 read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Lane_6_Status_1_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'hd4;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_6_Status_1_CSR.get();
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'hd4;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_6_Status_1_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'hd4;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_6_Status_1_CSR.get();
        `uvm_info("RW Lane_6_Status_1_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'hd4 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RW Lane_6_Status_1_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'hd4 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Lane_6_Status_1_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'hd4 read2_data = %h", read2_data),UVM_LOW);  
     if(read2_data != {read1_data[31:1],write_data[0]})
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Lane_6_Status_2_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'hd8;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_6_Status_2_CSR.get();
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'hd8;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_6_Status_2_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'hd8;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_6_Status_2_CSR.get();
        `uvm_info("RO Lane_6_Status_2_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'hd8 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_6_Status_2_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'hd8 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_6_Status_2_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'hd8 read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
 //Lane_6_Status_3_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'hdc;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_6_Status_3_CSR.get();
 ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'hdc;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_6_Status_3_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'hdc;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_6_Status_3_CSR.get();
        `uvm_info("RO Lane_6_Status_3_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'hdc read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_6_Status_3_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'hdc write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_6_Status_3_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'hdc read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Lane_7_Status_0_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'hdf4;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_7_Status_0_CSR.get();
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'hdf4;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_7_Status_0_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'hdf4;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_7_Status_0_CSR.get();
        `uvm_info("RO Lane_7_Status_0_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'hdf4 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_7_Status_0_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'hdf4 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_7_Status_0_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'hdf4 read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Lane_7_Status_1_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'hdf4;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_7_Status_1_CSR.get();
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'hdf4;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_7_Status_1_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'hdf4;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_7_Status_1_CSR.get();
        `uvm_info("RW Lane_7_Status_1_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'hdf4 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RW Lane_7_Status_1_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'hdf4 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Lane_7_Status_1_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'hdf4 read2_data = %h", read2_data),UVM_LOW);  
     if(read2_data != {read1_data[31:1],write_data[0]})
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Lane_7_Status_2_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'hdf8;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_7_Status_2_CSR.get();
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'hdf8;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_7_Status_2_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'hdf8;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_7_Status_2_CSR.get();
        `uvm_info("RO Lane_7_Status_2_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'hdf8 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_7_Status_2_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'hdf8 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_7_Status_2_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'hdf8 read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
 //Lane_7_Status_3_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'hdfc;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_7_Status_3_CSR.get();
 ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'hdfc;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_7_Status_3_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'hdfc;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_7_Status_3_CSR.get();
        `uvm_info("RO Lane_7_Status_3_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'hdfc read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_7_Status_3_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'hdfc write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_7_Status_3_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'hdfc read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Lane_8_Status_0_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h110;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_8_Status_0_CSR.get();
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h110;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_8_Status_0_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h110;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_8_Status_0_CSR.get();
        `uvm_info("RO Lane_8_Status_0_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h110 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_8_Status_0_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h110 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_8_Status_0_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h110 read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Lane_8_Status_1_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h114;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_8_Status_1_CSR.get();
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h114;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_8_Status_1_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h114;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_8_Status_1_CSR.get();
        `uvm_info("RW Lane_8_Status_1_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h114 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RW Lane_8_Status_1_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h114 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Lane_8_Status_1_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h114 read2_data = %h", read2_data),UVM_LOW);  
     if(read2_data != {read1_data[31:1],write_data[0]})
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Lane_8_Status_2_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h118;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_8_Status_2_CSR.get();
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h118;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_8_Status_2_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h118;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_8_Status_2_CSR.get();
        `uvm_info("RO Lane_8_Status_2_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h118 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_8_Status_2_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h118 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_8_Status_2_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h118 read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
 //Lane_8_Status_3_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h11c;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_8_Status_3_CSR.get();
 ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h11c;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_8_Status_3_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h11c;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_8_Status_3_CSR.get();
        `uvm_info("RO Lane_8_Status_3_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h11c read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_8_Status_3_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h11c write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_8_Status_3_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h11c read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Lane_9_Status_0_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h130;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_9_Status_0_CSR.get();
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h130;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_9_Status_0_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h130;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_9_Status_0_CSR.get();
        `uvm_info("RO Lane_9_Status_0_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h130 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_9_Status_0_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h130 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_9_Status_0_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h130 read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Lane_9_Status_1_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h134;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_9_Status_1_CSR.get();
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h134;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_9_Status_1_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h134;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_9_Status_1_CSR.get();
        `uvm_info("RW Lane_9_Status_1_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h134 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RW Lane_9_Status_1_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h134 write_data = %h", write_data),UVM_LOW);
      `uvm_info("RW Lane_9_Status_1_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h134 read2_data = %h", read2_data),UVM_LOW);  
     if(read2_data != {read1_data[31:1],write_data[0]})
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Lane_9_Status_2_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h138;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_9_Status_2_CSR.get();
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h138;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_9_Status_2_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h138;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_9_Status_2_CSR.get();
        `uvm_info("RO Lane_9_Status_2_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h138 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_9_Status_2_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h138 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_9_Status_2_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h138 read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
 //Lane_9_Status_3_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h13c;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_9_Status_3_CSR.get();
 ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h13c;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_9_Status_3_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h13c;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_9_Status_3_CSR.get();
        `uvm_info("RO Lane_9_Status_3_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h13c read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_9_Status_3_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h13c write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_9_Status_3_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h13c read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Lane_10_Status_0_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h150;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_10_Status_0_CSR.get();
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h150;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_10_Status_0_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h150;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_10_Status_0_CSR.get();
        `uvm_info("RO Lane_10_Status_0_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h150 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_10_Status_0_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h150 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_10_Status_0_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h150 read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Lane_10_Status_1_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h154;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_10_Status_1_CSR.get();
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h154;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_10_Status_1_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h154;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_10_Status_1_CSR.get();
        `uvm_info("RW Lane_10_Status_1_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h154 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RW Lane_10_Status_1_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h154 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Lane_10_Status_1_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h154 read2_data = %h", read2_data),UVM_LOW);  
     if(read2_data != {read1_data[31:1],write_data[0]})
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Lane_10_Status_2_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h158;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_10_Status_2_CSR.get();
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h158;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_10_Status_2_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h158;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_10_Status_2_CSR.get();
        `uvm_info("RO Lane_10_Status_2_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h158 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_10_Status_2_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h158 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_10_Status_2_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h158 read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
 //Lane_10_Status_3_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h15c;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_10_Status_3_CSR.get();
 ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h15c;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_10_Status_3_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h15c;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_10_Status_3_CSR.get();
        `uvm_info("RO Lane_10_Status_3_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h15c read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_10_Status_3_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h15c write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_10_Status_3_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h15c read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Lane_11_Status_0_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h170;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_11_Status_0_CSR.get();
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h170;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_11_Status_0_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h170;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_11_Status_0_CSR.get();
        `uvm_info("RO Lane_11_Status_0_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h170 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_11_Status_0_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h170 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_11_Status_0_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h170 read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Lane_11_Status_1_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h174;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_11_Status_1_CSR.get();
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h174;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_11_Status_1_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h174;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_11_Status_1_CSR.get();
        `uvm_info("RW Lane_11_Status_1_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h174 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RW Lane_11_Status_1_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h174 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Lane_11_Status_1_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h174 read2_data = %h", read2_data),UVM_LOW);  
     if(read2_data != {read1_data[31:1],write_data[0]})
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Lane_11_Status_2_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h178;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_11_Status_2_CSR.get();
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h178;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_11_Status_2_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h178;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_11_Status_2_CSR.get();
        `uvm_info("RO Lane_11_Status_2_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h178 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_11_Status_2_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h178 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_11_Status_2_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h178 read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
 //Lane_11_Status_3_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h17c;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_11_Status_3_CSR.get();
 ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h17c;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_11_Status_3_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h17c;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_11_Status_3_CSR.get();
        `uvm_info("RO Lane_11_Status_3_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h17c read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_11_Status_3_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h17c write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_11_Status_3_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h17c read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Lane_12_Status_0_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h190;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_12_Status_0_CSR.get();
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h190;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_12_Status_0_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h190;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_12_Status_0_CSR.get();
        `uvm_info("RO Lane_12_Status_0_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h190 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_12_Status_0_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h190 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_12_Status_0_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h190 read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Lane_12_Status_1_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h194;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_12_Status_1_CSR.get();
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h194;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_12_Status_1_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h194;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_12_Status_1_CSR.get();
        `uvm_info("RW Lane_12_Status_1_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h194 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RW Lane_12_Status_1_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h194 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Lane_12_Status_1_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h194 read2_data = %h", read2_data),UVM_LOW);  
     if(read2_data != {read1_data[31:1],write_data[0]})
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Lane_12_Status_2_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h198;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_12_Status_2_CSR.get();
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h198;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_12_Status_2_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h198;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_12_Status_2_CSR.get();
        `uvm_info("RO Lane_12_Status_2_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h198 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_12_Status_2_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h198 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_12_Status_2_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h198 read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
 //Lane_12_Status_3_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h19c;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_12_Status_3_CSR.get();
 ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h19c;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_12_Status_3_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h19c;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_12_Status_3_CSR.get();
        `uvm_info("RO Lane_12_Status_3_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h19c read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_12_Status_3_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h19c write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_12_Status_3_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h19c read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Lane_13_Status_0_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h1b0;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_13_Status_0_CSR.get();
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h1b0;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_13_Status_0_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h1b0;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_13_Status_0_CSR.get();
        `uvm_info("RO Lane_13_Status_0_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h1b0 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_13_Status_0_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h1b0 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_13_Status_0_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h1b0 read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Lane_13_Status_1_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h1b4;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_13_Status_1_CSR.get();
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h1b4;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_13_Status_1_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h1b4;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_13_Status_1_CSR.get();
        `uvm_info("RW Lane_13_Status_1_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h1b4 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RW Lane_13_Status_1_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h1b4 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Lane_13_Status_1_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h1b4 read2_data = %h", read2_data),UVM_LOW);  
     if(read2_data != {read1_data[31:1],write_data[0]})
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Lane_13_Status_2_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h1b8;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_13_Status_2_CSR.get();
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h1b8;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_13_Status_2_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h1b8;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_13_Status_2_CSR.get();
        `uvm_info("RO Lane_13_Status_2_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h1b8 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_13_Status_2_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h1b8 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_13_Status_2_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h1b8 read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
 //Lane_13_Status_3_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h1bc;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_13_Status_3_CSR.get();
 ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h1bc;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_13_Status_3_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h1bc;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_13_Status_3_CSR.get();
        `uvm_info("RO Lane_13_Status_3_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h1bc read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_13_Status_3_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h1bc write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_13_Status_3_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h1bc read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Lane_14_Status_0_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h1d0;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_14_Status_0_CSR.get();
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h1d0;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_14_Status_0_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h1d0;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_14_Status_0_CSR.get();
        `uvm_info("RO Lane_14_Status_0_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h1d0 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_14_Status_0_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h1d0 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_14_Status_0_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h1d0 read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Lane_14_Status_1_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h1d4;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_14_Status_1_CSR.get();
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h1d4;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_14_Status_1_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h1d4;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_14_Status_1_CSR.get();
        `uvm_info("RW Lane_14_Status_1_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h1d4 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RW Lane_14_Status_1_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h1d4 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Lane_14_Status_1_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h1d4 read2_data = %h", read2_data),UVM_LOW);  
     if(read2_data != {read1_data[31:1],write_data[0]})
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Lane_14_Status_2_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h1d8;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_14_Status_2_CSR.get();
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h1d8;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_14_Status_2_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h1d8;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_14_Status_2_CSR.get();
        `uvm_info("RO Lane_14_Status_2_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h1d8 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_14_Status_2_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h1d8 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_14_Status_2_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h1d8 read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
 //Lane_14_Status_3_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h1dc;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_14_Status_3_CSR.get();
 ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h1dc;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_14_Status_3_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h1dc;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_14_Status_3_CSR.get();
        `uvm_info("RO Lane_14_Status_3_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h1dc read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_14_Status_3_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h1dc write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_14_Status_3_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h1dc read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Lane_15_Status_0_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h1f0;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_15_Status_0_CSR.get();
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h1f0;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_15_Status_0_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h1f0;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_15_Status_0_CSR.get();
        `uvm_info("RO Lane_15_Status_0_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h1f0 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_15_Status_0_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h1f0 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_15_Status_0_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h1f0 read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Lane_15_Status_1_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h1f4;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_15_Status_1_CSR.get();
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h1f4;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_15_Status_1_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h1f4;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_15_Status_1_CSR.get();
        `uvm_info("RW Lane_15_Status_1_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h1f4 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RW Lane_15_Status_1_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h1f4 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Lane_15_Status_1_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h1f4 read2_data = %h", read2_data),UVM_LOW);  
     if(read2_data != {read1_data[31:1],write_data[0]})
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Lane_15_Status_2_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h1f8;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_15_Status_2_CSR.get();
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h1f8;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_15_Status_2_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h1f8;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_15_Status_2_CSR.get();
        `uvm_info("RO Lane_15_Status_2_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h1f8 read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_15_Status_2_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h1f8 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_15_Status_2_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h1f8 read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
 //Lane_15_Status_3_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h1fc;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Lane_15_Status_3_CSR.get();
 ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h1fc;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Lane_15_Status_3_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT2_BASE_ADDR+'h1fc;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Lane_15_Status_3_CSR.get();
        `uvm_info("RO Lane_15_Status_3_CSR",$sformatf("After first read 'EXT2_BASE_ADDR+'h1fc read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Lane_15_Status_3_CSR",$sformatf("After first write 'EXT2_BASE_ADDR+'h1fc write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Lane_15_Status_3_CSR",$sformatf("After second read 'EXT2_BASE_ADDR+'h1fc read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//EXT3
//Error_Management_Extensions_Block_Header
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+'h00;
     });
      for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
     write_data = srio_reg_model.Error_Management_Extensions_Block_Header.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);  
             `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data[31:16] == 32'h0007)
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+'h00;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Error_Management_Extensions_Block_Header.get();
       `uvm_info("RW Error_Management_Extensions_Block_Header",$sformatf("After first write 'EXT3_BASE_ADDR+'h00 write_data = %h", write_data),UVM_LOW);
       `uvm_info("RW Error_Management_Extensions_Block_Header",$sformatf("After first read 'EXT3_BASE_ADDR+'h00 read1_data = %h", read1_data),UVM_LOW);       
       if(write_data !== read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Logical_Transport_Layer_Error_Detect_CSR
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+'h08;
     });
       for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
     write_data = srio_reg_model.Logical_Transport_Layer_Error_Detect_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);  
             `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if({write_data[31:24],write_data[14:0]} == {expected_write1[31:24],expected_write1[14:0]})
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+'h08;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Logical_Transport_Layer_Error_Detect_CSR.get();
       `uvm_info("RW Logical_Transport_Layer_Error_Detect_CSR",$sformatf("After first write 'EXT3_BASE_ADDR+'h08 write_data = %h", write_data),UVM_LOW);
       `uvm_info("RW Logical_Transport_Layer_Error_Detect_CSR",$sformatf("After first read 'EXT3_BASE_ADDR+'h08 read1_data = %h", read1_data),UVM_LOW);       
       if(write_data !== read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Logical_Transport_Layer_Error_Enable_CSR
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+'h0c;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
     write_data = srio_reg_model.Logical_Transport_Layer_Error_Enable_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);  
             `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if({write_data[31:24],write_data[14:0]} == {expected_write1[31:24],expected_write1[14:0]})
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+'h0c;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Logical_Transport_Layer_Error_Enable_CSR.get();
       `uvm_info("RW Logical_Transport_Layer_Error_Enable_CSR",$sformatf("After first write 'EXT3_BASE_ADDR+'h0c write_data = %h", write_data),UVM_LOW);
       `uvm_info("RW Logical_Transport_Layer_Error_Enable_CSR",$sformatf("After first read 'EXT3_BASE_ADDR+'h0c read1_data = %h", read1_data),UVM_LOW);       
       if(write_data !== read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Logical_Transport_Layer_High_Address_Capture_CSR
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+'h10;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
     write_data = srio_reg_model.Logical_Transport_Layer_High_Address_Capture_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);   
            `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data == expected_write1)
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+'h10;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Logical_Transport_Layer_High_Address_Capture_CSR.get();
       `uvm_info("RW Logical_Transport_Layer_High_Address_Capture_CSR",$sformatf("After first write 'EXT3_BASE_ADDR+'h10 write_data = %h", write_data),UVM_LOW);
       `uvm_info("RW Logical_Transport_Layer_High_Address_Capture_CSR",$sformatf("After first read 'EXT3_BASE_ADDR+'h10 read1_data = %h", read1_data),UVM_LOW);       
       if(write_data !== read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Logical_Transport_Layer_Address_Capture_CSR
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+'h14;
     });
       for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
     write_data = srio_reg_model.Logical_Transport_Layer_Address_Capture_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);   
            `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data == expected_write1)
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+'h14;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Logical_Transport_Layer_Address_Capture_CSR.get();
       `uvm_info("RW Logical_Transport_Layer_Address_Capture_CSR",$sformatf("After first write 'EXT3_BASE_ADDR+'h14 write_data = %h", write_data),UVM_LOW);
       `uvm_info("RW Logical_Transport_Layer_Address_Capture_CSR",$sformatf("After first read 'EXT3_BASE_ADDR+'h14 read1_data = %h", read1_data),UVM_LOW);       
       if(write_data !== read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Logical_Transport_Layer_Device_ID_Capture_CSR
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+'h18;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
     write_data = srio_reg_model.Logical_Transport_Layer_Device_ID_Capture_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);   
            `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data == expected_write1)
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+'h18;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Logical_Transport_Layer_Device_ID_Capture_CSR.get();
       `uvm_info("RW Logical_Transport_Layer_Device_ID_Capture_CSR",$sformatf("After first write 'EXT3_BASE_ADDR+'h18 write_data = %h", write_data),UVM_LOW);
       `uvm_info("RW Logical_Transport_Layer_Device_ID_Capture_CSR",$sformatf("After first read 'EXT3_BASE_ADDR+'h18 read1_data = %h", read1_data),UVM_LOW);       
       if(write_data !== read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Logical_Transport_Layer_Control_Capture_CSR
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+'h1c;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
     write_data = srio_reg_model.Logical_Transport_Layer_Control_Capture_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);   
            `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data == expected_write1)
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+'h1c;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Logical_Transport_Layer_Control_Capture_CSR.get();
       `uvm_info("RW Logical_Transport_Layer_Control_Capture_CSR",$sformatf("After first write 'EXT3_BASE_ADDR+'h1c write_data = %h", write_data),UVM_LOW);
       `uvm_info("RW Logical_Transport_Layer_Control_Capture_CSR",$sformatf("After first read 'EXT3_BASE_ADDR+'h1c read1_data = %h", read1_data),UVM_LOW);       
       if(write_data !== read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Port_write_Target_deviceID_CSR
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+'h28;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
     write_data = srio_reg_model.Port_write_Target_deviceID_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write),UVM_LOW);  
             `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data[16:0] == expected_write1[16:0])
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+'h28;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Port_write_Target_deviceID_CSR.get();
      `uvm_info("RW Port_write_Target_deviceID_CSR",$sformatf("After first write 'EXT3_BASE_ADDR+'h28 write_data = %h", write_data),UVM_LOW);
       `uvm_info("RW Port_write_Target_deviceID_CSR",$sformatf("After first read 'EXT3_BASE_ADDR+'h28 read1_data = %h", read1_data),UVM_LOW);       
       if(write_data !== read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Packet_Time_to_live_CSR
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+'h2c;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
     write_data = srio_reg_model.Packet_Time_to_live_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);   
            `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data[15:0] == expected_write1[15:0])
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")

        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+'h2c;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Packet_Time_to_live_CSR.get();
      `uvm_info("RW Packet_Time_to_live_CSR",$sformatf("After first write 'EXT3_BASE_ADDR+'h2c write_data = %h", write_data),UVM_LOW);
       `uvm_info("RW Packet_Time_to_live_CSR",$sformatf("After first read 'EXT3_BASE_ADDR+'h2c read1_data = %h", read1_data),UVM_LOW);       
       if(write_data !== read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Port_0_Error_Detect_CSR
Port_0_Error_Detect_CSR_task('h40);
Port_0_Error_Detect_CSR_task('h80);
Port_0_Error_Detect_CSR_task('hc0);
Port_0_Error_Detect_CSR_task('h100);
Port_0_Error_Detect_CSR_task('h140);
Port_0_Error_Detect_CSR_task('h180);
Port_0_Error_Detect_CSR_task('h1c0);
Port_0_Error_Detect_CSR_task('h200);
Port_0_Error_Detect_CSR_task('h240);
Port_0_Error_Detect_CSR_task('h280);
Port_0_Error_Detect_CSR_task('h2c0);
Port_0_Error_Detect_CSR_task('h300);
Port_0_Error_Detect_CSR_task('h340);
Port_0_Error_Detect_CSR_task('h380);
Port_0_Error_Detect_CSR_task('h3c0);
Port_0_Error_Detect_CSR_task('h400);


//Port_0_Error_Rate_Enable_CSR
Port_0_Error_Rate_Enable_CSR_task('h44);
Port_0_Error_Rate_Enable_CSR_task('h84);
Port_0_Error_Rate_Enable_CSR_task('hc4);
Port_0_Error_Rate_Enable_CSR_task('h104);
Port_0_Error_Rate_Enable_CSR_task('h144);
Port_0_Error_Rate_Enable_CSR_task('h184);
Port_0_Error_Rate_Enable_CSR_task('h1c4);
Port_0_Error_Rate_Enable_CSR_task('h204);
Port_0_Error_Rate_Enable_CSR_task('h244);
Port_0_Error_Rate_Enable_CSR_task('h284);
Port_0_Error_Rate_Enable_CSR_task('h2c4);
Port_0_Error_Rate_Enable_CSR_task('h304);
Port_0_Error_Rate_Enable_CSR_task('h344);
Port_0_Error_Rate_Enable_CSR_task('h384);
Port_0_Error_Rate_Enable_CSR_task('h3c4);
Port_0_Error_Rate_Enable_CSR_task('h404);

//Port_0_Attributes_Capture_CSR
Port_0_Attributes_Capture_CSR_task('h48);
Port_0_Attributes_Capture_CSR_task('h88);
Port_0_Attributes_Capture_CSR_task('hc8);
Port_0_Attributes_Capture_CSR_task('h108);
Port_0_Attributes_Capture_CSR_task('h148);
Port_0_Attributes_Capture_CSR_task('h188);
Port_0_Attributes_Capture_CSR_task('h1c8);
Port_0_Attributes_Capture_CSR_task('h208);
Port_0_Attributes_Capture_CSR_task('h248);
Port_0_Attributes_Capture_CSR_task('h288);
Port_0_Attributes_Capture_CSR_task('h2c8);
Port_0_Attributes_Capture_CSR_task('h308);
Port_0_Attributes_Capture_CSR_task('h348);
Port_0_Attributes_Capture_CSR_task('h388);
Port_0_Attributes_Capture_CSR_task('h3c8);
Port_0_Attributes_Capture_CSR_task('h408);

//Port_0_Packet_Control_Symbol_Capture_0_CSR
Port_0_Packet_Control_Symbol_Capture_0_CSR_task('h4c);
Port_0_Packet_Control_Symbol_Capture_0_CSR_task('h8c);
Port_0_Packet_Control_Symbol_Capture_0_CSR_task('hcc);
Port_0_Packet_Control_Symbol_Capture_0_CSR_task('h10c);
Port_0_Packet_Control_Symbol_Capture_0_CSR_task('h14c);
Port_0_Packet_Control_Symbol_Capture_0_CSR_task('h18c);
Port_0_Packet_Control_Symbol_Capture_0_CSR_task('h1cc);
Port_0_Packet_Control_Symbol_Capture_0_CSR_task('h20c);
Port_0_Packet_Control_Symbol_Capture_0_CSR_task('h24c);
Port_0_Packet_Control_Symbol_Capture_0_CSR_task('h28c);
Port_0_Packet_Control_Symbol_Capture_0_CSR_task('h2cc);
Port_0_Packet_Control_Symbol_Capture_0_CSR_task('h30c);
Port_0_Packet_Control_Symbol_Capture_0_CSR_task('h34c);
Port_0_Packet_Control_Symbol_Capture_0_CSR_task('h38c);
Port_0_Packet_Control_Symbol_Capture_0_CSR_task('h3cc);
Port_0_Packet_Control_Symbol_Capture_0_CSR_task('h40c);


//Port_0_Packet_Capture_1_CSR
Port_0_Packet_Capture_1_CSR_task('h50);
Port_0_Packet_Capture_1_CSR_task('h90);
Port_0_Packet_Capture_1_CSR_task('hd0);
Port_0_Packet_Capture_1_CSR_task('h110);
Port_0_Packet_Capture_1_CSR_task('h150);
Port_0_Packet_Capture_1_CSR_task('h190);
Port_0_Packet_Capture_1_CSR_task('h1d0);
Port_0_Packet_Capture_1_CSR_task('h210);
Port_0_Packet_Capture_1_CSR_task('h250);
Port_0_Packet_Capture_1_CSR_task('h290);
Port_0_Packet_Capture_1_CSR_task('h2d0);
Port_0_Packet_Capture_1_CSR_task('h310);
Port_0_Packet_Capture_1_CSR_task('h350);
Port_0_Packet_Capture_1_CSR_task('h390);
Port_0_Packet_Capture_1_CSR_task('h3d0);
Port_0_Packet_Capture_1_CSR_task('h410);


//Port_0_Packet_Capture_2_CSR
Port_0_Packet_Capture_n_CSR_task('h54);
Port_0_Packet_Capture_n_CSR_task('h94);
Port_0_Packet_Capture_n_CSR_task('hd4);
Port_0_Packet_Capture_n_CSR_task('h114);
Port_0_Packet_Capture_n_CSR_task('h154);
Port_0_Packet_Capture_n_CSR_task('h194);
Port_0_Packet_Capture_n_CSR_task('h1d4);
Port_0_Packet_Capture_n_CSR_task('h214);
Port_0_Packet_Capture_n_CSR_task('h254);
Port_0_Packet_Capture_n_CSR_task('h294);
Port_0_Packet_Capture_n_CSR_task('h2d4);
Port_0_Packet_Capture_n_CSR_task('h314);
Port_0_Packet_Capture_n_CSR_task('h354);
Port_0_Packet_Capture_n_CSR_task('h394);
Port_0_Packet_Capture_n_CSR_task('h3d4);
Port_0_Packet_Capture_n_CSR_task('h414);


//Port_0_Packet_Capture_3_CSR

Port_0_Packet_Capture_n_CSR_task('h58);
Port_0_Packet_Capture_n_CSR_task('h98);
Port_0_Packet_Capture_n_CSR_task('hd8);
Port_0_Packet_Capture_n_CSR_task('h118);
Port_0_Packet_Capture_n_CSR_task('h158);
Port_0_Packet_Capture_n_CSR_task('h198);
Port_0_Packet_Capture_n_CSR_task('h1d8);
Port_0_Packet_Capture_n_CSR_task('h218);
Port_0_Packet_Capture_n_CSR_task('h258);
Port_0_Packet_Capture_n_CSR_task('h298);
Port_0_Packet_Capture_n_CSR_task('h2d8);
Port_0_Packet_Capture_n_CSR_task('h318);
Port_0_Packet_Capture_n_CSR_task('h358);
Port_0_Packet_Capture_n_CSR_task('h398);
Port_0_Packet_Capture_n_CSR_task('h3d8);
Port_0_Packet_Capture_n_CSR_task('h418);

//Port_0_Packet_Capture_4_CSR

Port_0_Packet_Capture_n_CSR_task('h5c);
Port_0_Packet_Capture_n_CSR_task('h9c);
Port_0_Packet_Capture_n_CSR_task('hdc);
Port_0_Packet_Capture_n_CSR_task('h11c);
Port_0_Packet_Capture_n_CSR_task('h15c);
Port_0_Packet_Capture_n_CSR_task('h19c);
Port_0_Packet_Capture_n_CSR_task('h1dc);
Port_0_Packet_Capture_n_CSR_task('h21c);
Port_0_Packet_Capture_n_CSR_task('h25c);
Port_0_Packet_Capture_n_CSR_task('h29c);
Port_0_Packet_Capture_n_CSR_task('h2dc);
Port_0_Packet_Capture_n_CSR_task('h31c);
Port_0_Packet_Capture_n_CSR_task('h35c);
Port_0_Packet_Capture_n_CSR_task('h39c);
Port_0_Packet_Capture_n_CSR_task('h3dc);
Port_0_Packet_Capture_n_CSR_task('h41c);

//Port_0_Error_Rate_CSR
Port_0_Error_Rate_CSR_task('h68);
Port_0_Error_Rate_CSR_task('ha8);
Port_0_Error_Rate_CSR_task('he8);
Port_0_Error_Rate_CSR_task('h128);
Port_0_Error_Rate_CSR_task('h168);
Port_0_Error_Rate_CSR_task('h1a8);
Port_0_Error_Rate_CSR_task('h1e8);
Port_0_Error_Rate_CSR_task('h228);
Port_0_Error_Rate_CSR_task('h268);
Port_0_Error_Rate_CSR_task('h2a8);
Port_0_Error_Rate_CSR_task('h2e8);
Port_0_Error_Rate_CSR_task('h328);
Port_0_Error_Rate_CSR_task('h368);
Port_0_Error_Rate_CSR_task('h3a8);
Port_0_Error_Rate_CSR_task('h3e8);
Port_0_Error_Rate_CSR_task('h428);

//Port_0_Error_Rate_Threshold_CSR
Port_0_Error_Rate_Threshold_CSR_task('h6c);
Port_0_Error_Rate_Threshold_CSR_task('hac);
Port_0_Error_Rate_Threshold_CSR_task('hec);
Port_0_Error_Rate_Threshold_CSR_task('h12c);
Port_0_Error_Rate_Threshold_CSR_task('h16c);
Port_0_Error_Rate_Threshold_CSR_task('h1ac);
Port_0_Error_Rate_Threshold_CSR_task('h1ec);
Port_0_Error_Rate_Threshold_CSR_task('h22c);
Port_0_Error_Rate_Threshold_CSR_task('h26c);
Port_0_Error_Rate_Threshold_CSR_task('h2ac);
Port_0_Error_Rate_Threshold_CSR_task('h2ec);
Port_0_Error_Rate_Threshold_CSR_task('h32c);
Port_0_Error_Rate_Threshold_CSR_task('h36c);
Port_0_Error_Rate_Threshold_CSR_task('h3ac);
Port_0_Error_Rate_Threshold_CSR_task('h3ec);
Port_0_Error_Rate_Threshold_CSR_task('h42c);

//Error_Management_Hot_Swap_Extensions_Block_CAR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+'h04;
     });
      begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Error_Management_Hot_Swap_Extensions_Block_CAR.get();
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+'h04;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Error_Management_Hot_Swap_Extensions_Block_CAR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+'h04;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Error_Management_Hot_Swap_Extensions_Block_CAR.get();
        `uvm_info("RO Error_Management_Hot_Swap_Extensions_Block_CAR",$sformatf("After first read 'EXT3_BASE_ADDR+'h04; read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Error_Management_Hot_Swap_Extensions_Block_CAR",$sformatf("After first write 'EXT3_BASE_ADDR+'h04; write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Error_Management_Hot_Swap_Extensions_Block_CAR",$sformatf("After second read 'EXT3_BASE_ADDR+'h04; read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);


//Logical_Transport_Layer_Dev32_Destination_ID_Capture_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+'h20;
     });
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Logical_Transport_Layer_Dev32_Destination_ID_Capture_CSR.get();
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+'h20;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Logical_Transport_Layer_Dev32_Destination_ID_Capture_CSR.get();
        `uvm_info("REGISTER VALUE AFTER FIRST WRITE",$sformatf("After first write EXT3_BASE_ADDR+32'h00000020 write_data = %h", write_data),UVM_LOW);
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+'h20;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Logical_Transport_Layer_Dev32_Destination_ID_Capture_CSR.get();
        `uvm_info("RO Logical_Transport_Layer_Dev32_Destination_ID_Capture_CSR",$sformatf("After first read 'EXT3_BASE_ADDR+'h20; read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Logical_Transport_Layer_Dev32_Destination_ID_Capture_CSR",$sformatf("After first write 'EXT3_BASE_ADDR+'h20; write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Logical_Transport_Layer_Dev32_Destination_ID_Capture_CSR",$sformatf("After second read 'EXT3_BASE_ADDR+'h20; read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Logical_Transport_Layer_Dev32_Source_ID_Capture_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+'h24;
     });
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Logical_Transport_Layer_Dev32_Source_ID_Capture_CSR.get();    ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+'h24;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Logical_Transport_Layer_Dev32_Source_ID_Capture_CSR.get();
        `uvm_info("REGISTER VALUE AFTER FIRST WRITE",$sformatf("After first write EXT3_BASE_ADDR+32'h00000024 write_data = %h", write_data),UVM_LOW);
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+'h24;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Logical_Transport_Layer_Dev32_Source_ID_Capture_CSR.get();
        `uvm_info("RO Logical_Transport_Layer_Dev32_Source_ID_Capture_CSR",$sformatf("After first read 'EXT3_BASE_ADDR+'h24; read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Logical_Transport_Layer_Dev32_Source_ID_Capture_CSR",$sformatf("After first write 'EXT3_BASE_ADDR+'h24; write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Logical_Transport_Layer_Dev32_Source_ID_Capture_CSR",$sformatf("After second read 'EXT3_BASE_ADDR+'h24; read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Port_Write_Dev32_Target_DeviceID_CSR
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+'h30;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
     write_data = srio_reg_model.Port_Write_Dev32_Target_DeviceID_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);  
             `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data == expected_write1)
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+'h30;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Port_Write_Dev32_Target_DeviceID_CSR.get();
      `uvm_info("RW Port_Write_Dev32_Target_DeviceID_CSR",$sformatf("After first write 'EXT3_BASE_ADDR+'h30 write_data = %h", write_data),UVM_LOW);
       `uvm_info("RW Port_Write_Dev32_Target_DeviceID_CSR",$sformatf("After first read 'EXT3_BASE_ADDR+'h30 read1_data = %h", read1_data),UVM_LOW);       
       if(write_data !== read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Port_Write_Transmission_Control_CSR
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+'h34;
     });
      for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
     write_data = srio_reg_model.Port_Write_Transmission_Control_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);  
             `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data[31] == expected_write1[31])
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+'h34;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Port_Write_Transmission_Control_CSR.get();
      `uvm_info("RW Port_Write_Transmission_Control_CSR",$sformatf("After first write 'EXT3_BASE_ADDR+'h34 write_data = %h", write_data),UVM_LOW);
       `uvm_info("RW Port_Write_Transmission_Control_CSR",$sformatf("After first read 'EXT3_BASE_ADDR+'h34 read1_data = %h", read1_data),UVM_LOW);       
       if(write_data !== read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Port_0_Link_Uninit_Discard_Timer_CSR
Port_0_Link_Uninit_Discard_Timer_CSR_task('h70);
Port_0_Link_Uninit_Discard_Timer_CSR_task('hb0);
Port_0_Link_Uninit_Discard_Timer_CSR_task('hf0);
Port_0_Link_Uninit_Discard_Timer_CSR_task('h130);
Port_0_Link_Uninit_Discard_Timer_CSR_task('h170);
Port_0_Link_Uninit_Discard_Timer_CSR_task('h1b0);
Port_0_Link_Uninit_Discard_Timer_CSR_task('h1f0);
Port_0_Link_Uninit_Discard_Timer_CSR_task('h230);
Port_0_Link_Uninit_Discard_Timer_CSR_task('h270);
Port_0_Link_Uninit_Discard_Timer_CSR_task('h2b0);
Port_0_Link_Uninit_Discard_Timer_CSR_task('h2f0);
Port_0_Link_Uninit_Discard_Timer_CSR_task('h330);
Port_0_Link_Uninit_Discard_Timer_CSR_task('h370);
Port_0_Link_Uninit_Discard_Timer_CSR_task('h3b0);
Port_0_Link_Uninit_Discard_Timer_CSR_task('h3f0);
Port_0_Link_Uninit_Discard_Timer_CSR_task('h430);



//EXT4
//VC_Register_Block_Header
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT4_BASE_ADDR+'h00;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
     write_data = srio_reg_model.VC_Register_Block_Header.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);   
            `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data[31:16] == 32'h000a)
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")

        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT4_BASE_ADDR+'h00;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.VC_Register_Block_Header.get();
      `uvm_info("RW VC_Register_Block_Header",$sformatf("After first write 'EXT4_BASE_ADDR+'h00 write_data = %h", write_data),UVM_LOW);
       `uvm_info("RW VC_Register_Block_Header",$sformatf("After first read 'EXT4_BASE_ADDR+'h00 read1_data = %h", read1_data),UVM_LOW);       
       if(write_data !== read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Port_0_VC_Control_and_Status_Register
Port_0_VC_Control_and_Status_Register_task('h20);
Port_0_VC_Control_and_Status_Register_task('h40);
Port_0_VC_Control_and_Status_Register_task('h60);
Port_0_VC_Control_and_Status_Register_task('h80);
Port_0_VC_Control_and_Status_Register_task('ha0);
Port_0_VC_Control_and_Status_Register_task('hc0);
Port_0_VC_Control_and_Status_Register_task('he0);
Port_0_VC_Control_and_Status_Register_task('h100);
Port_0_VC_Control_and_Status_Register_task('h120);
Port_0_VC_Control_and_Status_Register_task('h140);
Port_0_VC_Control_and_Status_Register_task('h160);
Port_0_VC_Control_and_Status_Register_task('h180);
Port_0_VC_Control_and_Status_Register_task('h1a0);
Port_0_VC_Control_and_Status_Register_task('h1c0);
Port_0_VC_Control_and_Status_Register_task('h1e0);
Port_0_VC_Control_and_Status_Register_task('h200);

//Port_0_VC0_BW_Allocation_Register
Port_0_VC0_BW_Allocation_Register_task('h24);
Port_0_VC0_BW_Allocation_Register_task('h44);
Port_0_VC0_BW_Allocation_Register_task('h64);
Port_0_VC0_BW_Allocation_Register_task('h84);
Port_0_VC0_BW_Allocation_Register_task('ha4);
Port_0_VC0_BW_Allocation_Register_task('hc4);
Port_0_VC0_BW_Allocation_Register_task('he4);
Port_0_VC0_BW_Allocation_Register_task('h104);
Port_0_VC0_BW_Allocation_Register_task('h124);
Port_0_VC0_BW_Allocation_Register_task('h144);
Port_0_VC0_BW_Allocation_Register_task('h164);
Port_0_VC0_BW_Allocation_Register_task('h184);
Port_0_VC0_BW_Allocation_Register_task('h1a4);
Port_0_VC0_BW_Allocation_Register_task('h1c4);
Port_0_VC0_BW_Allocation_Register_task('h1e4);
Port_0_VC0_BW_Allocation_Register_task('h204);

//Port_0_VC5_VC1_BW_Allocation_Register
Port_0_VC5_VC1_BW_Allocation_Register_task('h28);
Port_0_VC5_VC1_BW_Allocation_Register_task('h48);
Port_0_VC5_VC1_BW_Allocation_Register_task('h68);
Port_0_VC5_VC1_BW_Allocation_Register_task('h88);
Port_0_VC5_VC1_BW_Allocation_Register_task('ha8);
Port_0_VC5_VC1_BW_Allocation_Register_task('hc8);
Port_0_VC5_VC1_BW_Allocation_Register_task('he8);
Port_0_VC5_VC1_BW_Allocation_Register_task('h108);
Port_0_VC5_VC1_BW_Allocation_Register_task('h128);
Port_0_VC5_VC1_BW_Allocation_Register_task('h148);
Port_0_VC5_VC1_BW_Allocation_Register_task('h168);
Port_0_VC5_VC1_BW_Allocation_Register_task('h188);
Port_0_VC5_VC1_BW_Allocation_Register_task('h1a8);
Port_0_VC5_VC1_BW_Allocation_Register_task('h1c8);
Port_0_VC5_VC1_BW_Allocation_Register_task('h1e8);
Port_0_VC5_VC1_BW_Allocation_Register_task('h208);

//Port_0_VC7_VC3_BW_Allocation_Register
Port_0_VC7_VC3_BW_Allocation_Register_task('h2c);
Port_0_VC7_VC3_BW_Allocation_Register_task('h4c);
Port_0_VC7_VC3_BW_Allocation_Register_task('h6c);
Port_0_VC7_VC3_BW_Allocation_Register_task('h8c);
Port_0_VC7_VC3_BW_Allocation_Register_task('hac);
Port_0_VC7_VC3_BW_Allocation_Register_task('hcc);
Port_0_VC7_VC3_BW_Allocation_Register_task('hec);
Port_0_VC7_VC3_BW_Allocation_Register_task('h10c);
Port_0_VC7_VC3_BW_Allocation_Register_task('h12c);
Port_0_VC7_VC3_BW_Allocation_Register_task('h14c);
Port_0_VC7_VC3_BW_Allocation_Register_task('h16c);
Port_0_VC7_VC3_BW_Allocation_Register_task('h18c);
Port_0_VC7_VC3_BW_Allocation_Register_task('h1ac);
Port_0_VC7_VC3_BW_Allocation_Register_task('h1cc);
Port_0_VC7_VC3_BW_Allocation_Register_task('h1ec);
Port_0_VC7_VC3_BW_Allocation_Register_task('h20c);

//Port_0_VC6_VC2_BW_Allocation_Register
Port_0_VC6_VC2_BW_Allocation_Register_task('h30);
Port_0_VC6_VC2_BW_Allocation_Register_task('h50);
Port_0_VC6_VC2_BW_Allocation_Register_task('h70);
Port_0_VC6_VC2_BW_Allocation_Register_task('h90);
Port_0_VC6_VC2_BW_Allocation_Register_task('hb0);
Port_0_VC6_VC2_BW_Allocation_Register_task('hd0);
Port_0_VC6_VC2_BW_Allocation_Register_task('hf0);
Port_0_VC6_VC2_BW_Allocation_Register_task('h110);
Port_0_VC6_VC2_BW_Allocation_Register_task('h130);
Port_0_VC6_VC2_BW_Allocation_Register_task('h150);
Port_0_VC6_VC2_BW_Allocation_Register_task('h170);
Port_0_VC6_VC2_BW_Allocation_Register_task('h190);
Port_0_VC6_VC2_BW_Allocation_Register_task('h1b0);
Port_0_VC6_VC2_BW_Allocation_Register_task('h1d0);
Port_0_VC6_VC2_BW_Allocation_Register_task('h1f0);
Port_0_VC6_VC2_BW_Allocation_Register_task('h210);

//Port_0_VC8_VC4_BW_Allocation_Register
Port_0_VC8_VC4_BW_Allocation_Register_task('h34);
Port_0_VC8_VC4_BW_Allocation_Register_task('h54);
Port_0_VC8_VC4_BW_Allocation_Register_task('h74);
Port_0_VC8_VC4_BW_Allocation_Register_task('h94);
Port_0_VC8_VC4_BW_Allocation_Register_task('hb4);
Port_0_VC8_VC4_BW_Allocation_Register_task('hd4);
Port_0_VC8_VC4_BW_Allocation_Register_task('hf4);
Port_0_VC8_VC4_BW_Allocation_Register_task('h114);
Port_0_VC8_VC4_BW_Allocation_Register_task('h134);
Port_0_VC8_VC4_BW_Allocation_Register_task('h154);
Port_0_VC8_VC4_BW_Allocation_Register_task('h174);
Port_0_VC8_VC4_BW_Allocation_Register_task('h194);
Port_0_VC8_VC4_BW_Allocation_Register_task('h1b4);
Port_0_VC8_VC4_BW_Allocation_Register_task('h1d4);
Port_0_VC8_VC4_BW_Allocation_Register_task('h1f4);
Port_0_VC8_VC4_BW_Allocation_Register_task('h214);

//EXT5
//Timestamp_Generation_Extension_Block_Header
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT5_BASE_ADDR+'h00;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Timestamp_Generation_Extension_Block_Header.get();
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT5_BASE_ADDR+'h00;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Timestamp_Generation_Extension_Block_Header.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT5_BASE_ADDR+'h00;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Timestamp_Generation_Extension_Block_Header.get();
        `uvm_info("RO Timestamp_Generation_Extension_Block_Header",$sformatf("After first read 'EXT5_BASE_ADDR+'h00; read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Timestamp_Generation_Extension_Block_Header",$sformatf("After first write 'EXT5_BASE_ADDR+'h00; write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Timestamp_Generation_Extension_Block_Header",$sformatf("After second read 'EXT5_BASE_ADDR+'h00; read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Timestamp_CAR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT5_BASE_ADDR+'h04;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Timestamp_CAR.get();
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT5_BASE_ADDR+'h04;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Timestamp_CAR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT5_BASE_ADDR+'h04;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Timestamp_CAR.get();
        `uvm_info("RO Timestamp_CAR",$sformatf("After first read 'EXT5_BASE_ADDR+'h04; read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Timestamp_CAR",$sformatf("After first write 'EXT5_BASE_ADDR+'h04; write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Timestamp_CAR",$sformatf("After second read 'EXT5_BASE_ADDR+'h04; read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
//Timestamp_Generator_Status_CSR
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT5_BASE_ADDR+'h08;
     });
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Timestamp_Generator_Status_CSR.get();
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT5_BASE_ADDR+'h08;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Timestamp_Generator_Status_CSR.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT5_BASE_ADDR+'h08;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = srio_reg_model.Timestamp_Generator_Status_CSR.get();
        `uvm_info("RO Timestamp_Generator_Status_CSR",$sformatf("After first read 'EXT5_BASE_ADDR+'h08; read1_data = %h", read1_data),UVM_LOW);       
        `uvm_info("RO Timestamp_Generator_Status_CSR",$sformatf("After first write 'EXT5_BASE_ADDR+'h08; write_data = %h", write_data),UVM_LOW);
        `uvm_info("RO Timestamp_Generator_Status_CSR",$sformatf("After second read 'EXT5_BASE_ADDR+'h08; read2_data = %h", read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);     
//Timestamp_Generator_MSW_CSR
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT5_BASE_ADDR+'h34;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
     write_data = srio_reg_model.Timestamp_Generator_MSW_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);   
            `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data == expected_write1)
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT5_BASE_ADDR+'h34;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Timestamp_Generator_MSW_CSR.get();
       `uvm_info("RW Timestamp_Generator_MSW_CSR",$sformatf("After first write 'EXT5_BASE_ADDR+'h34 write_data = %h", write_data),UVM_LOW);
       `uvm_info("RW Timestamp_Generator_MSW_CSR",$sformatf("After first read 'EXT5_BASE_ADDR+'h34 read1_data = %h", read1_data),UVM_LOW);       
       if(write_data !== read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Timestamp_Generator_LSW_CSR
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT5_BASE_ADDR+'h38;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
     write_data = srio_reg_model.Timestamp_Generator_LSW_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);  
             `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data == expected_write1)
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT5_BASE_ADDR+'h38;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Timestamp_Generator_LSW_CSR.get();
       `uvm_info("RW Timestamp_Generator_LSW_CSR",$sformatf("After first write 'EXT5_BASE_ADDR+'h38 write_data = %h", write_data),UVM_LOW);
       `uvm_info("RW Timestamp_Generator_LSW_CSR",$sformatf("After first read 'EXT5_BASE_ADDR+'h38 read1_data = %h", read1_data),UVM_LOW);       
       if(write_data !== read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

//Port_0_Timestamp_0_MSW_CSR
Port_0_Timestamp_0_MSW_CSR_task('h44);
Port_0_Timestamp_0_MSW_CSR_task('h84);
Port_0_Timestamp_0_MSW_CSR_task('hc4);
Port_0_Timestamp_0_MSW_CSR_task('h104);
Port_0_Timestamp_0_MSW_CSR_task('h144);
Port_0_Timestamp_0_MSW_CSR_task('h184);
Port_0_Timestamp_0_MSW_CSR_task('h1c4);
Port_0_Timestamp_0_MSW_CSR_task('h204);
Port_0_Timestamp_0_MSW_CSR_task('h244);
Port_0_Timestamp_0_MSW_CSR_task('h284);
Port_0_Timestamp_0_MSW_CSR_task('h2c4);
Port_0_Timestamp_0_MSW_CSR_task('h304);
Port_0_Timestamp_0_MSW_CSR_task('h344);
Port_0_Timestamp_0_MSW_CSR_task('h384);
Port_0_Timestamp_0_MSW_CSR_task('h3c4);
Port_0_Timestamp_0_MSW_CSR_task('h404);

//Port_0_Timestamp_0_LSW_CSR
Port_0_Timestamp_0_LSW_CSR_task('h48);
Port_0_Timestamp_0_LSW_CSR_task('h88);
Port_0_Timestamp_0_LSW_CSR_task('hc8);
Port_0_Timestamp_0_LSW_CSR_task('h108);
Port_0_Timestamp_0_LSW_CSR_task('h148);
Port_0_Timestamp_0_LSW_CSR_task('h188);
Port_0_Timestamp_0_LSW_CSR_task('h1c8);
Port_0_Timestamp_0_LSW_CSR_task('h208);
Port_0_Timestamp_0_LSW_CSR_task('h248);
Port_0_Timestamp_0_LSW_CSR_task('h288);
Port_0_Timestamp_0_LSW_CSR_task('h2c8);
Port_0_Timestamp_0_LSW_CSR_task('h308);
Port_0_Timestamp_0_LSW_CSR_task('h348);
Port_0_Timestamp_0_LSW_CSR_task('h388);
Port_0_Timestamp_0_LSW_CSR_task('h3c8);
Port_0_Timestamp_0_LSW_CSR_task('h408);

//Port_0_Timestamp_1_MSW_CSR
Port_0_Timestamp_0_MSW_CSR_task('h54);
Port_0_Timestamp_0_MSW_CSR_task('h94);
Port_0_Timestamp_0_MSW_CSR_task('hd4);
Port_0_Timestamp_0_MSW_CSR_task('h114);
Port_0_Timestamp_0_MSW_CSR_task('h154);
Port_0_Timestamp_0_MSW_CSR_task('h194);
Port_0_Timestamp_0_MSW_CSR_task('h1d4);
Port_0_Timestamp_0_MSW_CSR_task('h214);
Port_0_Timestamp_0_MSW_CSR_task('h254);
Port_0_Timestamp_0_MSW_CSR_task('h294);
Port_0_Timestamp_0_MSW_CSR_task('h2d4);
Port_0_Timestamp_0_MSW_CSR_task('h314);
Port_0_Timestamp_0_MSW_CSR_task('h354);
Port_0_Timestamp_0_MSW_CSR_task('h394);
Port_0_Timestamp_0_MSW_CSR_task('h3d4);
Port_0_Timestamp_0_MSW_CSR_task('h414);

//Port_0_Timestamp_1_LSW_CSR
Port_0_Timestamp_0_LSW_CSR_task('h58);
Port_0_Timestamp_0_LSW_CSR_task('h98);
Port_0_Timestamp_0_LSW_CSR_task('hd8);
Port_0_Timestamp_0_LSW_CSR_task('h118);
Port_0_Timestamp_0_LSW_CSR_task('h158);
Port_0_Timestamp_0_LSW_CSR_task('h198);
Port_0_Timestamp_0_LSW_CSR_task('h1d8);
Port_0_Timestamp_0_LSW_CSR_task('h218);
Port_0_Timestamp_0_LSW_CSR_task('h258);
Port_0_Timestamp_0_LSW_CSR_task('h298);
Port_0_Timestamp_0_LSW_CSR_task('h2d8);
Port_0_Timestamp_0_LSW_CSR_task('h318);
Port_0_Timestamp_0_LSW_CSR_task('h358);
Port_0_Timestamp_0_LSW_CSR_task('h398);
Port_0_Timestamp_0_LSW_CSR_task('h3d8);
Port_0_Timestamp_0_LSW_CSR_task('h418);

//Port_0_Timestamp_Generator_Synchronization_CSR
Port_0_Timestamp_Generator_Synchronization_CSR_task('h60);  
Port_0_Timestamp_Generator_Synchronization_CSR_task('ha0);  
Port_0_Timestamp_Generator_Synchronization_CSR_task('he0);  
Port_0_Timestamp_Generator_Synchronization_CSR_task('h120);  
Port_0_Timestamp_Generator_Synchronization_CSR_task('h160);  
Port_0_Timestamp_Generator_Synchronization_CSR_task('h1a0);  
Port_0_Timestamp_Generator_Synchronization_CSR_task('h1e0);  
Port_0_Timestamp_Generator_Synchronization_CSR_task('h220);  
Port_0_Timestamp_Generator_Synchronization_CSR_task('h260);  
Port_0_Timestamp_Generator_Synchronization_CSR_task('h2a0);  
Port_0_Timestamp_Generator_Synchronization_CSR_task('h2e0);  
Port_0_Timestamp_Generator_Synchronization_CSR_task('h320);  
Port_0_Timestamp_Generator_Synchronization_CSR_task('h360);  
Port_0_Timestamp_Generator_Synchronization_CSR_task('h3a0);  
Port_0_Timestamp_Generator_Synchronization_CSR_task('h3e0);  
Port_0_Timestamp_Generator_Synchronization_CSR_task('h420);  

//Port_0_Auto_Update_Counter_CSR
Port_0_Auto_Update_Counter_CSR_task('h64);
Port_0_Auto_Update_Counter_CSR_task('ha4);
Port_0_Auto_Update_Counter_CSR_task('he4);
Port_0_Auto_Update_Counter_CSR_task('h124);
Port_0_Auto_Update_Counter_CSR_task('h164);
Port_0_Auto_Update_Counter_CSR_task('h1a4);
Port_0_Auto_Update_Counter_CSR_task('h1e4);
Port_0_Auto_Update_Counter_CSR_task('h224);
Port_0_Auto_Update_Counter_CSR_task('h264);
Port_0_Auto_Update_Counter_CSR_task('h2a4);
Port_0_Auto_Update_Counter_CSR_task('h2e4);
Port_0_Auto_Update_Counter_CSR_task('h324);
Port_0_Auto_Update_Counter_CSR_task('h364);
Port_0_Auto_Update_Counter_CSR_task('h3a4);
Port_0_Auto_Update_Counter_CSR_task('h3e4);
Port_0_Auto_Update_Counter_CSR_task('h424);

//Port_0_Timestamp_Synchronization_Command_CSR
Port_0_Timestamp_Synchronization_Command_CSR_task('h68);
Port_0_Timestamp_Synchronization_Command_CSR_task('ha8);
Port_0_Timestamp_Synchronization_Command_CSR_task('he8);
Port_0_Timestamp_Synchronization_Command_CSR_task('h128);
Port_0_Timestamp_Synchronization_Command_CSR_task('h168);
Port_0_Timestamp_Synchronization_Command_CSR_task('h1a8);
Port_0_Timestamp_Synchronization_Command_CSR_task('h1e8);
Port_0_Timestamp_Synchronization_Command_CSR_task('h228);
Port_0_Timestamp_Synchronization_Command_CSR_task('h268);
Port_0_Timestamp_Synchronization_Command_CSR_task('h2a8);
Port_0_Timestamp_Synchronization_Command_CSR_task('h2e8);
Port_0_Timestamp_Synchronization_Command_CSR_task('h328);
Port_0_Timestamp_Synchronization_Command_CSR_task('h368);
Port_0_Timestamp_Synchronization_Command_CSR_task('h3a8);
Port_0_Timestamp_Synchronization_Command_CSR_task('h3e8);
Port_0_Timestamp_Synchronization_Command_CSR_task('h428);

//Port_0_Timestamp_Synchronization_Status_CSR
Port_0_Timestamp_Synchronization_Status_CSR_task('h6c);
Port_0_Timestamp_Synchronization_Status_CSR_task('hac);
Port_0_Timestamp_Synchronization_Status_CSR_task('hec);
Port_0_Timestamp_Synchronization_Status_CSR_task('h12c);
Port_0_Timestamp_Synchronization_Status_CSR_task('h16c);
Port_0_Timestamp_Synchronization_Status_CSR_task('h1ac);
Port_0_Timestamp_Synchronization_Status_CSR_task('h1ec);
Port_0_Timestamp_Synchronization_Status_CSR_task('h22c);
Port_0_Timestamp_Synchronization_Status_CSR_task('h26c);
Port_0_Timestamp_Synchronization_Status_CSR_task('h2ac);
Port_0_Timestamp_Synchronization_Status_CSR_task('h2ec);
Port_0_Timestamp_Synchronization_Status_CSR_task('h32c);
Port_0_Timestamp_Synchronization_Status_CSR_task('h36c);
Port_0_Timestamp_Synchronization_Status_CSR_task('h3ac);
Port_0_Timestamp_Synchronization_Status_CSR_task('h3ec);
Port_0_Timestamp_Synchronization_Status_CSR_task('h42c);

//Port_0_Timestamp_Offset_CSR
Port_0_Timestamp_Offset_CSR_task('h70);
Port_0_Timestamp_Offset_CSR_task('hb0);
Port_0_Timestamp_Offset_CSR_task('hf0);
Port_0_Timestamp_Offset_CSR_task('h130);
Port_0_Timestamp_Offset_CSR_task('h170);
Port_0_Timestamp_Offset_CSR_task('h1b0);
Port_0_Timestamp_Offset_CSR_task('h1f0);
Port_0_Timestamp_Offset_CSR_task('h230);
Port_0_Timestamp_Offset_CSR_task('h270);
Port_0_Timestamp_Offset_CSR_task('h2b0);
Port_0_Timestamp_Offset_CSR_task('h2f0);
Port_0_Timestamp_Offset_CSR_task('h330);
Port_0_Timestamp_Offset_CSR_task('h370);
Port_0_Timestamp_Offset_CSR_task('h3b0);
Port_0_Timestamp_Offset_CSR_task('h3f0);
Port_0_Timestamp_Offset_CSR_task('h430);


//EXT6
//LP_Serial_VC_Register_Block_Header
ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT6_BASE_ADDR+'h00;
     });
      for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.LP_Serial_VC_Register_Block_Header.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);    
           `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data[31:16] == 'h000b)
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT6_BASE_ADDR+'h00;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.LP_Serial_VC_Register_Block_Header.get();
         `uvm_info("RW LP_Serial_VC_Register_Block_Header",$sformatf("After first write 'EXT6_BASE_ADDR+'h00 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW LP_Serial_VC_Register_Block_Header",$sformatf("After first read 'EXT6_BASE_ADDR+'h00 read1_data = %h", read1_data),UVM_LOW);       
       if(write_data != read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW); 

//Port_0_VoQ_Control_Status_Register
Port_0_VoQ_Control_Status_Register_task('h20);
Port_0_VoQ_Control_Status_Register_task('h24);
Port_0_VoQ_Control_Status_Register_task('h28);
Port_0_VoQ_Control_Status_Register_task('h2c);
Port_0_VoQ_Control_Status_Register_task('h30);
Port_0_VoQ_Control_Status_Register_task('h34);
Port_0_VoQ_Control_Status_Register_task('h38);
Port_0_VoQ_Control_Status_Register_task('h3c);
Port_0_VoQ_Control_Status_Register_task('h40);
Port_0_VoQ_Control_Status_Register_task('h44);
Port_0_VoQ_Control_Status_Register_task('h48);
Port_0_VoQ_Control_Status_Register_task('h4c);
Port_0_VoQ_Control_Status_Register_task('h50);
Port_0_VoQ_Control_Status_Register_task('h54);
Port_0_VoQ_Control_Status_Register_task('h58);
Port_0_VoQ_Control_Status_Register_task('h5c);


endtask

task Port_n_Link_Maintenance_Response_CSR_task(bit [20:0] address);
    bit [20:0] a;
    a = address;
    rg = srio_reg_model.srio_reg_block_map.get_reg_by_offset(srio_reg_model.EXT1_BASE_ADDR+a);

        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+a;
     });
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = rg.get();
      ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+a;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
        #500ns;
        write_data = rg.get();
        write_data = srio_reg_model.Port_0_Link_Maintenance_Request_CSR.get();
        
    ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+a;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
      read2_data = rg.get();
        `uvm_info("RO Port_n_Link_Maintenance_Response_CSR",$sformatf("After first read 'EXT1_BASE_ADDR+ %0h read1_data = %0h",a,read1_data),UVM_LOW);       
        `uvm_info("RO Port_n_Link_Maintenance_Response_CSR",$sformatf("After first write 'EXT1_BASE_ADDR+ %0h write_data = %0h",a, write_data),UVM_LOW);
        `uvm_info("RO Port_n_Link_Maintenance_Response_CSR",$sformatf("After second read 'EXT1_BASE_ADDR+ %0h read2_data = %0h",a, read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
endtask

task Port_n_Local_ackID_CSR_task(bit [20:0] address);

    bit [20:0] a;
    logic [31:0] my_data;
    a = address;
    rg = srio_reg_model.srio_reg_block_map.get_reg_by_offset(srio_reg_model.EXT1_BASE_ADDR+a);
#100ns;
   my_data = rg.get();
    ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+a;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
   my_data = rg.get();
             write_data = rg.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW); 
              `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
       if({write_data[7:2]} == {expected_write1[7:2]})

           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+a;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
   my_data = rg.get();
        read1_data = rg.get();
       `uvm_info("RW Port_n_Local_ackID_CSR",$sformatf("After first write 'EXT1_BASE_ADDR+'48 write_data = %h", write_data),UVM_LOW);
       `uvm_info("RW Port_n_Local_ackID_CSR",$sformatf("After first read 'EXT1_BASE_ADDR+'h48 read1_data = %h", read1_data),UVM_LOW);       
       if({write_data[7:2]} != {read1_data[7:2]})
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
endtask

task Port_0_Error_and_Status_CSR_task(bit [20:0] address);

    bit [20:0] a;
    logic [31:0] my_data;
    a = address;
    rg = srio_reg_model.srio_reg_block_map.get_reg_by_offset(srio_reg_model.EXT1_BASE_ADDR+a);
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+a;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = rg.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW); 
              `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if({write_data[26],write_data[3:0]} == {expected_write1[26],expected_write1[3:0]})

           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
      ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+'ha;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = rg.get();
       `uvm_info("RW Port_n_Error_and_Status_CSR",$sformatf("After first write 'EXT1_BASE_ADDR+'h%0h write_data = %h", a,write_data),UVM_LOW);
        `uvm_info("RW Port_n_Error_and_Status_CSR",$sformatf("After first read 'EXT1_BASE_ADDR+'h%0h read1_data = %h",a, read1_data),UVM_LOW);       
       if(write_data != read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

endtask 
task Port_0_Control_CSR_task(bit [20:0] address);
    bit [20:0] a;
    logic [31:0] my_data;
    a = address;
    rg = srio_reg_model.srio_reg_block_map.get_reg_by_offset(srio_reg_model.EXT1_BASE_ADDR+a);
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+a;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = rg.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW); 
              `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if({write_data[30:20],write_data[17:8],write_data[4:2]} == {expected_write1[30:20],expected_write1[17:8],expected_write1[4:2]})
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+a;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = rg.get();
       `uvm_info("RW Port_n_Control_CSR",$sformatf("After first write 'EXT1_BASE_ADDR+'h%0h write_data = %h", a,write_data),UVM_LOW);
        `uvm_info("RW Port_n_Control_CSR",$sformatf("After first read 'EXT1_BASE_ADDR+'h%0h read1_data = %h", a,read1_data),UVM_LOW);       
       if(write_data != read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

endtask

task Port_0_Initialization_Status_CSR_task(bit [20:0] address);
    bit [20:0] a;
    logic [31:0] my_data;
    a = address;
    rg = srio_reg_model.srio_reg_block_map.get_reg_by_offset(srio_reg_model.EXT1_BASE_ADDR+a);

        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+a;
     });
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = rg.get();
    ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+a;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = rg.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+a;
     });
        srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = rg.get();
        `uvm_info("RO Port_n_Initialization_Status_CSR",$sformatf("After first read 'EXT1_BASE_ADDR+'h%0h read1_data = %h",a, read1_data),UVM_LOW);       
        `uvm_info("RO Port_n_Initialization_Status_CSR",$sformatf("After first write 'EXT1_BASE_ADDR+'h%0h write_data = %h",a, write_data),UVM_LOW);
        `uvm_info("RO Port_n_Initialization_Status_CSR",$sformatf("After second read 'EXT1_BASE_ADDR+'h%0h read2_data = %h",a, read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

endtask
task Port_0_Outbound_ackID_CSR_task(bit [20:0] address);
    bit [20:0] a;
    a = address;
    rg = srio_reg_model.srio_reg_block_map.get_reg_by_offset(srio_reg_model.EXT1_BASE_ADDR+a);

     ttype_0 = 1;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+a;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = rg.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);  
             `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data[31:20] == expected_write1[31:20])
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+a;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = rg.get();
       `uvm_info("RW Port_n_Outbound_ackID_CSR",$sformatf("After first write 'EXT1_BASE_ADDR+'h%0h write_data = %h",a, write_data),UVM_LOW);
        `uvm_info("RW Port_n_Outbound_ackID_CSR",$sformatf("After first read 'EXT1_BASE_ADDR+'h%0h read1_data = %h",a, read1_data),UVM_LOW);       
     if(read1_data[7:0] != 0)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
endtask

task Port_0_Inbound_ackID_CSR_task(bit [20:0] address);
    bit [20:0] a;
    a = address;
    rg = srio_reg_model.srio_reg_block_map.get_reg_by_offset(srio_reg_model.EXT1_BASE_ADDR+a);

        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+a;
     });
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = rg.get();
     ttype_0 = 1;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+a;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = rg.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+a;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = rg.get();
        `uvm_info("RO Port_n_Inbound_ackID_CSR",$sformatf("After first read 'EXT1_BASE_ADDR+'h%0h read1_data = %h",a, read1_data),UVM_LOW);       
        `uvm_info("RO Port_n_Inbound_ackID_CSR",$sformatf("After first write 'EXT1_BASE_ADDR+'h%0h write_data = %h",a, write_data),UVM_LOW);
        `uvm_info("RO Port_n_Inbound_ackID_CSR",$sformatf("After second read 'EXT1_BASE_ADDR+'h%0h read2_data = %h",a, read2_data),UVM_LOW);  
     if(read1_data[19:0] != read2_data[19:0])
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
endtask

task Port_0_Power_Management_CSR_task(bit [20:0] address);
    bit [20:0] a;
    a = address;
    rg = srio_reg_model.srio_reg_block_map.get_reg_by_offset(srio_reg_model.EXT1_BASE_ADDR+a);

     ttype_0 = 1;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+a;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = rg.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW); 
              `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if({write_data[31:26],write_data[23:21],write_data[18:16],write_data[9:5]} == {expected_write1[31:26],expected_write1[23:21],expected_write1[18:16],expected_write1[9:5]})
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+a;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = rg.get();
       `uvm_info("RW Port_n_Power_Management_CSR",$sformatf("After first write 'EXT1_BASE_ADDR+'h%0h write_data = %h",a, write_data),UVM_LOW);
        `uvm_info("RW Port_n_Power_Management_CSR",$sformatf("After first read 'EXT1_BASE_ADDR+'h%0h read1_data = %h",a, read1_data),UVM_LOW);       
    if(read1_data != {write_data[31:26],2'b00,3'b000,2'b00,3'b000,3'b000,3'b000,write_data[9:5],5'b00000})
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
endtask

task Port_0_Latency_Optimization_CSR_task(bit [20:0] address);
    bit [20:0] a;
    a = address;
    rg = srio_reg_model.srio_reg_block_map.get_reg_by_offset(srio_reg_model.EXT1_BASE_ADDR+a);

     ttype_0 = 1;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+a;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = rg.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW); 
              `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data[9:8] == expected_write1[9:8])
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+a;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = rg.get();
       `uvm_info("RW Port_n_Latency_Optimization_CSR",$sformatf("After first write 'EXT1_BASE_ADDR+'h%0h write_data = %h",a, write_data),UVM_LOW);
        `uvm_info("RW Port_n_Latency_Optimization_CSR",$sformatf("After first read 'EXT1_BASE_ADDR+'h%0h read1_data = %h",a, read1_data),UVM_LOW);       
       if(write_data != read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
endtask

task Port_0_Link_Timers_Control_CSR_task(bit [20:0] address);
    bit [20:0] a;
    a = address;
    rg = srio_reg_model.srio_reg_block_map.get_reg_by_offset(srio_reg_model.EXT1_BASE_ADDR+a);

     ttype_0 = 1;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+a;
     });
     for(int i=0; i<8; i++)   
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = rg.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);  
             `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data == expected_write1)
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+a;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = rg.get();
       `uvm_info("RW Port_n_Link_Timers_Control_CSR",$sformatf("After first write 'EXT1_BASE_ADDR+'h%0h write_data = %h",a, write_data),UVM_LOW);
        `uvm_info("RW Port_n_Link_Timers_Control_CSR",$sformatf("After first read 'EXT1_BASE_ADDR+'h%0h read1_data = %h",a, read1_data),UVM_LOW);       
       if(write_data != read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

endtask
task Port_0_Link_Timers_Control_2_CSR_task (bit [20:0] address);
    bit [20:0] a;
    a = address;
    rg = srio_reg_model.srio_reg_block_map.get_reg_by_offset(srio_reg_model.EXT1_BASE_ADDR+a);
     ttype_0 = 1;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+a;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = rg.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);  
             `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data == expected_write1)
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+a;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = rg.get();
       `uvm_info("RW Port_n_Link_Timers_Control_2_CSR",$sformatf("After first write 'EXT1_BASE_ADDR+'h%0h write_data = %h",a, write_data),UVM_LOW);
        `uvm_info("RW Port_n_Link_Timers_Control_2_CSR",$sformatf("After first read 'EXT1_BASE_ADDR+'h%0h read1_data = %h",a, read1_data),UVM_LOW);       
       if(write_data != read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
endtask
task Port_0_Link_Timers_Control_3_CSR_task(bit [20:0] address);
    bit [20:0] a;
    a = address;
    rg = srio_reg_model.srio_reg_block_map.get_reg_by_offset(srio_reg_model.EXT1_BASE_ADDR+a);
     ttype_0 = 1;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+a;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = rg.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);  
             `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data == expected_write1)
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT1_BASE_ADDR+a;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = rg.get();
       `uvm_info("RW Port_n_Link_Timers_Control_3_CSR",$sformatf("After first write 'EXT1_BASE_ADDR+'h%0h write_data = %h",a, write_data),UVM_LOW);
        `uvm_info("RW Port_n_Link_Timers_Control_3_CSR",$sformatf("After first read 'EXT1_BASE_ADDR+'h%0h read1_data = %h",a, read1_data),UVM_LOW);       
       if(write_data != read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

endtask
task Port_0_Error_Detect_CSR_task(bit [20:0] address);
    bit [20:0] a;
    a = address;
    rg = srio_reg_model.srio_reg_block_map.get_reg_by_offset(srio_reg_model.EXT3_BASE_ADDR+a);
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+a;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
     write_data = rg.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);   
            `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if({write_data[31:26],write_data[18:8],write_data[3:0]} == {expected_write1[31:26],expected_write1[18:8],expected_write1[3:0]})
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+a;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = rg.get();
      `uvm_info("RW Port_n_Error_Detect_CSR",$sformatf("After first write 'EXT3_BASE_ADDR+'h%0h write_data = %h",a, write_data),UVM_LOW);
       `uvm_info("RW Port_n_Error_Detect_CSR",$sformatf("After first read 'EXT3_BASE_ADDR+'h%0h read1_data = %h",a, read1_data),UVM_LOW);       
       if(write_data !== read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

endtask
task Port_0_Error_Rate_Enable_CSR_task (bit [20:0] address);
    bit [20:0] a;
    a = address;
    rg = srio_reg_model.srio_reg_block_map.get_reg_by_offset(srio_reg_model.EXT3_BASE_ADDR+a);
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+a;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
     write_data = rg.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);   
            `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if({write_data[31:26],write_data[18:8],write_data[3:0]} == {expected_write1[31:26],expected_write1[18:8],expected_write1[3:0]})
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+a;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = rg.get();
      `uvm_info("RW Port_n_Error_Rate_Enable_CSR",$sformatf("After first write 'EXT3_BASE_ADDR+'h%0h write_data = %h",a, write_data),UVM_LOW);
       `uvm_info("RW Port_n_Error_Rate_Enable_CSR",$sformatf("After first read 'EXT3_BASE_ADDR+'h%0h read1_data = %h",a, read1_data),UVM_LOW);       
       if(write_data !== read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
endtask
task Port_0_Attributes_Capture_CSR_task(bit [20:0] address);
    bit [20:0] a;
    a = address;
    rg = srio_reg_model.srio_reg_block_map.get_reg_by_offset(srio_reg_model.EXT3_BASE_ADDR+a);
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+a;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
     write_data = rg.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);    
          `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data == expected_write1)
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+a;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = rg.get();
      `uvm_info("RW Port_n_Attributes_Capture_CSR",$sformatf("After first write 'EXT3_BASE_ADDR+'h%0h write_data = %h",a, write_data),UVM_LOW);
       `uvm_info("RW Port_n_Attributes_Capture_CSR",$sformatf("After first read 'EXT3_BASE_ADDR+'h%0h read1_data = %h",a, read1_data),UVM_LOW);       
       if(write_data !== read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
endtask

task Port_0_Packet_Control_Symbol_Capture_0_CSR_task(bit [20:0] address);
    bit [20:0] a;
    a = address;
    rg = srio_reg_model.srio_reg_block_map.get_reg_by_offset(srio_reg_model.EXT3_BASE_ADDR+a);
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+a;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
     write_data = rg.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);   
            `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data == expected_write1)
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+a;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = rg.get();
      `uvm_info("RW Port_n_Attributes_Capture_CSR",$sformatf("After first write 'EXT3_BASE_ADDR+'h%0h write_data = %h",a, write_data),UVM_LOW);
       `uvm_info("RW Port_n_Attributes_Capture_CSR",$sformatf("After first read 'EXT3_BASE_ADDR+'h%0h read1_data = %h",a, read1_data),UVM_LOW);       
       if(write_data !== read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);


endtask
task Port_0_Packet_Capture_1_CSR_task(bit [20:0] address);
    bit [20:0] a;
    a = address;
    rg = srio_reg_model.srio_reg_block_map.get_reg_by_offset(srio_reg_model.EXT3_BASE_ADDR+a);
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+a;
     });
       for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
     write_data = rg.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);   
            `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data == expected_write1)
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")

        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+a;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = rg.get();
      `uvm_info("RW Port_n_Packet_Capture_1_CSR",$sformatf("After first write 'EXT3_BASE_ADDR+'h%0h write_data = %h",a, write_data),UVM_LOW);
       `uvm_info("RW Port_n_Packet_Capture_1_CSR",$sformatf("After first read 'EXT3_BASE_ADDR+'h%0h read1_data = %h",a, read1_data),UVM_LOW);       
       if(write_data !== read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

endtask
task Port_0_Packet_Capture_n_CSR_task(bit [20:0] address);
    bit [20:0] a;
    a = address;
    rg = srio_reg_model.srio_reg_block_map.get_reg_by_offset(srio_reg_model.EXT3_BASE_ADDR+a);
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+a;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
     write_data = rg.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);  
             `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data == expected_write1)
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")

        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+a;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = rg.get();
      `uvm_info("RW Port_n_Packet_Capture_n_CSR",$sformatf("After first write 'EXT3_BASE_ADDR+'h%0h write_data = %h",a, write_data),UVM_LOW);
       `uvm_info("RW Port_n_Packet_Capture_n_CSR",$sformatf("After first read 'EXT3_BASE_ADDR+'h%0h read1_data = %h",a, read1_data),UVM_LOW);       
       if(write_data !== read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

endtask
task Port_0_Error_Rate_CSR_task(bit [20:0] address);
    bit [20:0] a;
    a = address;
    rg = srio_reg_model.srio_reg_block_map.get_reg_by_offset(srio_reg_model.EXT3_BASE_ADDR+a);
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+a;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
     write_data = rg.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);   
            `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data == expected_write1)
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+a;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = rg.get();
      `uvm_info("RW Port_n_Error_Rate_CSR",$sformatf("After first write 'EXT3_BASE_ADDR+'h%0h write_data = %h",a, write_data),UVM_LOW);
       `uvm_info("RW Port_n_Error_Rate_CSR",$sformatf("After first read 'EXT3_BASE_ADDR+'h%0h read1_data = %h",a,read1_data),UVM_LOW);       
       if(write_data !== read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

endtask
task Port_0_Error_Rate_Threshold_CSR_task(bit [20:0] address);
    bit [20:0] a;
    a = address;
    rg = srio_reg_model.srio_reg_block_map.get_reg_by_offset(srio_reg_model.EXT3_BASE_ADDR+a);
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+a;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
     write_data = rg.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);  
             `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data[15:0] == expected_write1[15:0])
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+a;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = rg.get();
      `uvm_info("RW Port_n_Error_Rate_Threshold_CSR",$sformatf("After first write 'EXT3_BASE_ADDR+'h%0h write_data = %h",a, write_data),UVM_LOW);
       `uvm_info("RW Port_n_Error_Rate_Threshold_CSR",$sformatf("After first read 'EXT3_BASE_ADDR+'h%0h read1_data = %h",a, read1_data),UVM_LOW);       
       if(write_data !== read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

endtask
task Port_0_Link_Uninit_Discard_Timer_CSR_task(bit [20:0] address);
    bit [20:0] a;
    a = address;
    rg = srio_reg_model.srio_reg_block_map.get_reg_by_offset(srio_reg_model.EXT3_BASE_ADDR+a);
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+a;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
     write_data = rg.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);   
            `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data == expected_write1)
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT3_BASE_ADDR+a;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = rg.get();
      `uvm_info("RW Port_n_Link_Uninit_Discard_Timer_CSR",$sformatf("After first write 'EXT3_BASE_ADDR+'h%0h write_data = %h",a, write_data),UVM_LOW);
       `uvm_info("RW Port_n_Link_Uninit_Discard_Timer_CSR",$sformatf("After first read 'EXT3_BASE_ADDR+'h%0h read1_data = %h",a,read1_data),UVM_LOW);       
       if(write_data !== read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

endtask
task Port_0_VC_Control_and_Status_Register_task(bit [20:0] address);
    bit [20:0] a;
    a = address;
    rg = srio_reg_model.srio_reg_block_map.get_reg_by_offset(srio_reg_model.EXT4_BASE_ADDR+a);
     ttype_0 = 1;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT4_BASE_ADDR+a;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
     write_data = rg.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);  
             `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if({write_data[31:24],write_data[15:0]} == {expected_write1[31:24],expected_write1[15:0]})
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT4_BASE_ADDR+a;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = rg.get();
       `uvm_info("RW Port_n_VC_Control_and_Status_Register",$sformatf("After first write 'EXT4_BASE_ADDR+'h%0h write_data = %h",a, write_data),UVM_LOW);
       `uvm_info("RW Port_n_VC_Control_and_Status_Register",$sformatf("After first read 'EXT4_BASE_ADDR+'h%0h read1_data = %h",a, read1_data),UVM_LOW);       
       if(write_data !== read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

endtask

task Port_0_VC0_BW_Allocation_Register_task(bit [20:0] address);
    bit [20:0] a;
    a = address;
    rg = srio_reg_model.srio_reg_block_map.get_reg_by_offset(srio_reg_model.EXT4_BASE_ADDR+a);
     ttype_0 = 1;
     start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT4_BASE_ADDR+a;
     });
       for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
     write_data = rg.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW); 
          `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if({write_data[31:8],write_data[1]} == {expected_write1[31:8],expected_write1[1]})
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT4_BASE_ADDR+a;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = rg.get();
       `uvm_info("RW Port_n_VC0_BW_Allocation_Register",$sformatf("After first write 'EXT4_BASE_ADDR+'h%0h write_data = %h",a, write_data),UVM_LOW);
       `uvm_info("RW Port_n_VC0_BW_Allocation_Register",$sformatf("After first read 'EXT4_BASE_ADDR+'h%0h read1_data = %h",a, read1_data),UVM_LOW);       
       if(write_data !== read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

endtask
task Port_0_VC5_VC1_BW_Allocation_Register_task(bit [20:0] address);
    bit [20:0] a;
    a = address;
    rg = srio_reg_model.srio_reg_block_map.get_reg_by_offset(srio_reg_model.EXT4_BASE_ADDR+a);
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT4_BASE_ADDR+a;
     });
      for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
     write_data = rg.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);  
             `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data == expected_write1)
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT4_BASE_ADDR+a;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = rg.get();
       `uvm_info("RW Port_n_VC5_VC1_BW_Allocation_Register",$sformatf("After first write 'EXT4_BASE_ADDR+'h%0h write_data = %h",a, write_data),UVM_LOW);
       `uvm_info("RW Port_n_VC5_VC1_BW_Allocation_Register",$sformatf("After first read 'EXT4_BASE_ADDR+'h%0h read1_data = %h",a, read1_data),UVM_LOW);       
       if(write_data !== read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
endtask

task Port_0_VC7_VC3_BW_Allocation_Register_task(bit [20:0] address);
    bit [20:0] a;
    a = address;
    rg = srio_reg_model.srio_reg_block_map.get_reg_by_offset(srio_reg_model.EXT4_BASE_ADDR+a);
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT4_BASE_ADDR+a;
     });
      for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
     write_data = rg.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);  
             `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data == expected_write1)
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT4_BASE_ADDR+a;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = rg.get();
       `uvm_info("RW Port_n_VC7_VC3_BW_Allocation_Register",$sformatf("After first write 'EXT4_BASE_ADDR+'h%0h write_data = %h",a, write_data),UVM_LOW);
       `uvm_info("RW Port_n_VC7_VC3_BW_Allocation_Register",$sformatf("After first read 'EXT4_BASE_ADDR+'h%0h read1_data = %h",a, read1_data),UVM_LOW);       
       if(write_data !== read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

endtask

task Port_0_VC6_VC2_BW_Allocation_Register_task(bit [20:0] address);
    bit [20:0] a;
    a = address;
    rg = srio_reg_model.srio_reg_block_map.get_reg_by_offset(srio_reg_model.EXT4_BASE_ADDR+a);
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT4_BASE_ADDR+a;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
     write_data = rg.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);   
            `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data == expected_write1)
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT4_BASE_ADDR+a;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = rg.get();
       `uvm_info("RW Port_n_VC6_VC2_BW_Allocation_Register",$sformatf("After first write 'EXT4_BASE_ADDR+'h%0h write_data = %h",a, write_data),UVM_LOW);
       `uvm_info("RW Port_n_VC6_VC2_BW_Allocation_Register",$sformatf("After first read 'EXT4_BASE_ADDR+'h%0h read1_data = %h",a, read1_data),UVM_LOW);       
       if(write_data !== read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

endtask

task Port_0_VC8_VC4_BW_Allocation_Register_task(bit [20:0] address);
    bit [20:0] a;
    a = address;
    rg = srio_reg_model.srio_reg_block_map.get_reg_by_offset(srio_reg_model.EXT4_BASE_ADDR+a);
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT4_BASE_ADDR+a;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
     write_data = rg.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);  
             `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data == expected_write1)
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT4_BASE_ADDR+a;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = rg.get();
       `uvm_info("RW Port_n_VC8_VC4_BW_Allocation_Register",$sformatf("After first write 'EXT4_BASE_ADDR+'h%0h write_data = %h",a, write_data),UVM_LOW);
       `uvm_info("RW Port_n_VC8_VC4_BW_Allocation_Register",$sformatf("After first read 'EXT4_BASE_ADDR+'h%0h read1_data = %h",a, read1_data),UVM_LOW);       
       if(write_data !== read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
endtask

task  Port_0_Timestamp_0_MSW_CSR_task(bit [20:0] address);
    bit [20:0] a;
    a = address;
    rg = srio_reg_model.srio_reg_block_map.get_reg_by_offset(srio_reg_model.EXT5_BASE_ADDR+a);
    ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT5_BASE_ADDR+a;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = rg.get();
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT5_BASE_ADDR+a;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = rg.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT5_BASE_ADDR+a;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = rg.get();
        `uvm_info("RO Port_n_Timestamp_0_MSW_CSR",$sformatf("After first read 'EXT5_BASE_ADDR+'h%0h; read1_data = %h",a, read1_data),UVM_LOW);       
        `uvm_info("RO Port_n_Timestamp_0_MSW_CSR",$sformatf("After first write 'EXT5_BASE_ADDR+'h%0h; write_data = %h",a, write_data),UVM_LOW);
        `uvm_info("RO Port_n_Timestamp_0_MSW_CSR",$sformatf("After second read 'EXT5_BASE_ADDR+'h%0h; read2_data = %h",a,read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW); 

endtask
task  Port_0_Timestamp_0_LSW_CSR_task(bit [20:0] address);
    bit [20:0] a;
    a = address;
    rg = srio_reg_model.srio_reg_block_map.get_reg_by_offset(srio_reg_model.EXT5_BASE_ADDR+a);
    ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT5_BASE_ADDR+a;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = rg.get();
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT5_BASE_ADDR+a;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = rg.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT5_BASE_ADDR+a;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = rg.get();
        `uvm_info("RO Port_n_Timestamp_0_LSW_CSR",$sformatf("After first read 'EXT5_BASE_ADDR+'h%0h; read1_data = %h",a, read1_data),UVM_LOW);       
        `uvm_info("RO Port_n_Timestamp_0_LSW_CSR",$sformatf("After first write 'EXT5_BASE_ADDR+'h%0h; write_data = %h",a, write_data),UVM_LOW);
        `uvm_info("RO Port_n_Timestamp_0_LSW_CSR",$sformatf("After second read 'EXT5_BASE_ADDR+'h%0h; read2_data = %h",a,read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW); 

endtask
task Port_0_Timestamp_Generator_Synchronization_CSR_task(bit [20:0] address);
    bit [20:0] a;
    a = address;
    rg = srio_reg_model.srio_reg_block_map.get_reg_by_offset(srio_reg_model.EXT5_BASE_ADDR+a);
    ttype_0 = 1;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT5_BASE_ADDR+a;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;

     write_data = rg.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);  
             `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if({write_data[31:19],write_data[7:6],write_data[2:0]} == {expected_write1[31:19],expected_write1[7:6],expected_write1[2:0]})
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT5_BASE_ADDR+a;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = rg.get();
       `uvm_info("RW Port_n_Timestamp_Generator_Synchronization_CSR",$sformatf("After first write 'EXT5_BASE_ADDR+'h%0h write_data = %h",a, write_data),UVM_LOW);
       `uvm_info("RW Port_n_Timestamp_Generator_Synchronization_CSR",$sformatf("After first read 'EXT5_BASE_ADDR+'h%0h read1_data = %h",a, read1_data),UVM_LOW);       
       if(write_data !== read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

endtask

task Port_0_Auto_Update_Counter_CSR_task(bit [20:0] address);
    bit [20:0] a;
    a = address;
    rg = srio_reg_model.srio_reg_block_map.get_reg_by_offset(srio_reg_model.EXT5_BASE_ADDR+a);
    ttype_0 = 1;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT5_BASE_ADDR+a;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
     write_data = rg.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);    
           `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data == expected_write1)
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT5_BASE_ADDR+a;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = rg.get();
       `uvm_info("RW Port_n_Auto_Update_Counter_CSR",$sformatf("After first write 'EXT5_BASE_ADDR+'h%0h write_data = %h",a, write_data),UVM_LOW);
       `uvm_info("RW Port_n_Auto_Update_Counter_CSR",$sformatf("After first read 'EXT5_BASE_ADDR+'h%0h read1_data = %h",a, read1_data),UVM_LOW);       
       if(write_data !== read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

endtask

task Port_0_Timestamp_Synchronization_Command_CSR_task(bit [20:0] address);
    bit [20:0] a;
    a = address;
    rg = srio_reg_model.srio_reg_block_map.get_reg_by_offset(srio_reg_model.EXT5_BASE_ADDR+a);
     ttype_0 = 1;
     start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT5_BASE_ADDR+a;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
     write_data = rg.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);   
            `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if({write_data[31:29],write_data[27],write_data[23]} == {expected_write1[31:29],expected_write1[27],expected_write1[23]})
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")

        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT5_BASE_ADDR+a;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = rg.get();
       `uvm_info("RW Port_n_Timestamp_Synchronization_Command_CSR",$sformatf("After first write 'EXT5_BASE_ADDR+'h%0h write_data = %h",a, write_data),UVM_LOW);
       `uvm_info("RW Port_n_Timestamp_Synchronization_Command_CSR",$sformatf("After first read 'EXT5_BASE_ADDR+'h%0h read1_data = %h",a, read1_data),UVM_LOW);       
       if(write_data !== read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

endtask

task Port_0_Timestamp_Synchronization_Status_CSR_task(bit [20:0] address);
    bit [20:0] a;
    a = address;
    rg = srio_reg_model.srio_reg_block_map.get_reg_by_offset(srio_reg_model.EXT5_BASE_ADDR+a);
    ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT5_BASE_ADDR+a;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = rg.get();
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT5_BASE_ADDR+a;
     });
     for(int i=0; i<8; i++)
       srio_trans_item.payload.push_back(i);
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = rg.get();
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT5_BASE_ADDR+a;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read2_data = rg.get();
        `uvm_info("RO Port_n_Timestamp_Synchronization_Status_CSR",$sformatf("After first read 'EXT5_BASE_ADDR+'h%0h; read1_data = %h",a, read1_data),UVM_LOW);       
        `uvm_info("RO Port_n_Timestamp_Synchronization_Status_CSR",$sformatf("After first write 'EXT5_BASE_ADDR+'h%0h; write_data = %h",a, write_data),UVM_LOW);
        `uvm_info("RO Port_n_Timestamp_Synchronization_Status_CSR",$sformatf("After second read 'EXT5_BASE_ADDR+'h%0h; read2_data = %h",a, read2_data),UVM_LOW);  
     if(read1_data != read2_data)
       `uvm_error("ERROR","EXPECTED DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","EXPECTED DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW); 

endtask

task Port_0_Timestamp_Offset_CSR_task(bit [20:0] address);
    bit [20:0] a;
    a = address;
    rg = srio_reg_model.srio_reg_block_map.get_reg_by_offset(srio_reg_model.EXT5_BASE_ADDR+a);
     ttype_0 = 1;
     start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT5_BASE_ADDR+a;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
     write_data = rg.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);      
          `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if(write_data[15:0] == expected_write1[15:0])
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")

        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT5_BASE_ADDR+a;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = rg.get();
       `uvm_info("RW Port_n_Timestamp_Offset_CSR",$sformatf("After first write 'EXT5_BASE_ADDR+'h%0h write_data = %h",a, write_data),UVM_LOW);
       `uvm_info("RW Port_n_Timestamp_Offset_CSR",$sformatf("After first read 'EXT5_BASE_ADDR+'h%0h read1_data = %h",a, read1_data),UVM_LOW);       
       if(write_data != read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);
endtask
task Port_0_VoQ_Control_Status_Register_task(bit [20:0] address);
    bit [20:0] a;
    a = address;
    rg = srio_reg_model.srio_reg_block_map.get_reg_by_offset(srio_reg_model.EXT6_BASE_ADDR+a);
     ttype_0 = 1;
start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT6_BASE_ADDR+a;
     });
     for(int i=0; i<8; i++)
             begin
       srio_trans_item.payload.push_back(i);
       if(!wdptr_0)
          expected_payload.push_back(i);
       else 
           expected_payload.push_front(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
     write_data = rg.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
          `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);            
          `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if({write_data[31:26],write_data[18:8],write_data[2:0]} == {expected_write1[31:26],expected_write1[18:8],expected_write1[2:0]})
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")
        ttype_0 = 0;
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype ==ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     config_offset == srio_reg_model.EXT6_BASE_ADDR+a;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = rg.get();
       `uvm_info("RW Port_n_VoQ_Control_Status_Register",$sformatf("After first write 'EXT6_BASE_ADDR+'h%0h write_data = %h",a, write_data),UVM_LOW);
       `uvm_info("RW Port_n_VoQ_Control_Status_Register",$sformatf("After first read 'EXT6_BASE_ADDR+'h%0h read1_data = %h",a, read1_data),UVM_LOW);       
       if(write_data !== read1_data)
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);


endtask
endclass : srio_ll_maintenance_wr_rd_base_seq




//=====DS FOR TOTAL 80BYTE CASE =======

class srio_ll_ds_corner_case_total_pkt_80byte_base_seq extends srio_ll_base_seq;
  `uvm_object_utils(srio_ll_ds_corner_case_total_pkt_80byte_base_seq)

  srio_trans srio_trans_item;

   rand bit [15:0] pdulength_0;
   rand bit [7:0] mtusize_0; 

   function new(string name="");
   super.new(name);
   endfunction

   virtual task body();
	
      	//Data streaming Packet
        srio_trans_item = srio_trans::type_id::create("srio_trans_item");

	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ftype_9.constraint_mode(0);
	srio_trans_item.Xh.constraint_mode(0);

	       
	start_item(srio_trans_item);
        assert(srio_trans_item.randomize() with {
	ftype ==4'h9 ;
	xh==1'b0;
	mtusize == mtusize_0;
	pdulength ==pdulength_0 ;
	});
	srio_trans_item.print();

	begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DATA STREAMING REQUEST CORNER CASE FOR TOTAL BYTE 80 Transcation"),UVM_LOW); end

       finish_item(srio_trans_item);
       	
endtask 
endclass :srio_ll_ds_corner_case_total_pkt_80byte_base_seq

//=====DS WITH MAINTENANCE =======
class srio_ll_maintenance_ds_base_seq extends srio_ll_base_seq;
  `uvm_object_utils(srio_ll_maintenance_ds_base_seq)
  srio_trans srio_trans_item;

  
   rand bit [15:0] pdulength_0;
   rand bit [7:0] mtusize_0; 
   rand bit [31:0] read_data;
   rand bit [3:0] tm_mode_0;
 function new(string name="");
    super.new(name);
  endfunction

virtual task body();
	
         mtusize_0 = $urandom_range(32'd64,32'd8);
        `uvm_info("MTU SIZE VALUE",$sformatf("The randomized value of mtusize_0 is %0b",mtusize_0),UVM_LOW)
	pdulength_0 =$urandom_range(32'h0000_FFFF,32'h0000_0000);
        //tm_mode_0 = $urandom_range(32'd4,32'd0);

        /////
       srio_trans_item = srio_trans::type_id::create("srio_trans_item");

	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
     	srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.rdsize_0.constraint_mode(0);
	srio_trans_item.Ftype_8.constraint_mode(0);
	

    // Maintenance Read 
        start_item(srio_trans_item);
        srio_trans_item.usr_gen_pkt =1;
	assert(srio_trans_item.randomize() with {
        ftype == 4'h8;
        ttype == 4'h0 ;
        rdsize ==4'h8 ;
        wrsize ==4'h8 ;
        wdptr ==1'b0 ;
        config_offset == 21'h48;});

	srio_trans_item.print();

        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE READ REQUEST Transcation"),UVM_LOW); end
        finish_item(srio_trans_item);

	fork //{
	begin //{
        //@(env_config.ll_config.ll_pkt_transmitted);
        @(env_config.ll_config.ll_pkt_received);
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET AFTER MAINT_RD"),UVM_LOW);
	end //}
	begin //{
	#10000ns;
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET FAILED AFTER MAINT_RD --- TIMEOUT OCCURED "),UVM_LOW);
	end //}
	join_any //}
	disable fork;


	read_data = env_config.srio_reg_model_rx.Data_Streaming_Logical_Layer_Control_CSR.get();

	 //read_data[31:0] = {4'b1110,tm_mode_0,8'h0,8'h0,mtusize_0};
         read_data[7:0] = {4'b1110,4'b0000};
         read_data[15:8] = 8'h0;
         read_data[23:16] = 8'h0;
         read_data[31:24] = mtusize_0;
	
	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
     	srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.rdsize_0.constraint_mode(0);
	srio_trans_item.Ftype_8.constraint_mode(0);
	

	//Maintenance Write 
	start_item(srio_trans_item);
       srio_trans_item.usr_gen_pkt =1;
	assert(srio_trans_item.randomize() with {
     ftype == 4'h8;
     ttype == 4'h1 ;
     rdsize ==4'h8 ;
     wrsize ==4'h8 ;
     wdptr ==1'b0 ;
     config_offset == 21'h48;});

     srio_trans_item.payload.push_back(read_data[31:24]);
     srio_trans_item.payload.push_back(read_data[23:16]);
     srio_trans_item.payload.push_back(read_data[15:8]);
     srio_trans_item.payload.push_back(read_data[7:0]);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);

     srio_trans_item.print();
	
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE REQUEST  Transcation"),UVM_LOW); end

       finish_item(srio_trans_item);
        fork //{
	begin //{
        //@(env_config.ll_config.ll_pkt_transmitted);
        @(env_config.ll_config.ll_pkt_received);
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET AFTER MAINT_WR"),UVM_LOW);
	end //}
	begin //{
	#10000ns;
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET FAILED AFTER MAINT_WR --- TIMEOUT OCCURED "),UVM_LOW);
	end //}
	join_any //}
	disable fork;
     
    
	//Data streaming Packet
        srio_trans_item = srio_trans::type_id::create("srio_trans_item");
        srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ftype_9.constraint_mode(0);
	srio_trans_item.Xh.constraint_mode(0);

	
       
	start_item(srio_trans_item);
        assert(srio_trans_item.randomize() with {
	ftype ==4'h9 ;
	xh==1'b0;
	mtusize == mtusize_0;
	pdulength ==pdulength_0 ;
	});
	srio_trans_item.print();

	begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DATA STREAMING REQUEST Transcation"),UVM_LOW); end

       finish_item(srio_trans_item);
	#100ns;

     	
	wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
	#1000ns;
endtask 
endclass :srio_ll_maintenance_ds_base_seq



//=====DS INTERLEAVED PACKET =======

class srio_ll_ds_interleaved_base_seq extends srio_ll_base_seq;
  `uvm_object_utils(srio_ll_ds_interleaved_base_seq)
  srio_trans srio_trans_item;

  
   rand bit [15:0] pdulength_0;
   rand bit [7:0] mtusize_0; 
   
   function new(string name="");
    super.new(name);
   endfunction

 virtual task body();
	
        srio_trans_item = srio_trans::type_id::create("srio_trans_item");

	//Data streaming Packet

	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ftype_9.constraint_mode(0);
	srio_trans_item.Xh.constraint_mode(0);
	
	start_item(srio_trans_item);
        srio_trans_item.usr_gen_pkt =0;
        assert(srio_trans_item.randomize() with {
	ftype ==4'h9 ;
	xh==1'b0;
	mtusize == mtusize_0;
	pdulength ==pdulength_0 ;
	});
	srio_trans_item.print();

	begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DATA STREAMING REQUEST FOR INTERLEAVED PACKET Transcation"),UVM_LOW); end

       finish_item(srio_trans_item);
        #100ns;
     	 endtask 
endclass :srio_ll_ds_interleaved_base_seq


//=====DS WITH MAXIMUM PDU AND MTU =======

class srio_ll_ds_max_min_pdu_mtu_base_seq extends srio_ll_base_seq;
  `uvm_object_utils(srio_ll_ds_max_min_pdu_mtu_base_seq)
  srio_trans srio_trans_item;

  
   rand bit [15:0] pdulength_0;
   rand bit [7:0] mtusize_0; 
   
   function new(string name="");
   super.new(name);
   endfunction

 virtual task body();

              	
	//Data streaming Packet
        srio_trans_item = srio_trans::type_id::create("srio_trans_item");

	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ftype_9.constraint_mode(0);
	srio_trans_item.Xh.constraint_mode(0);

	
       
	start_item(srio_trans_item);
        assert(srio_trans_item.randomize() with {
	ftype ==4'h9 ;
	xh==1'b0;
	mtusize == mtusize_0;
	pdulength ==pdulength_0 ;
	});
	srio_trans_item.print();

	begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DATA STREAMING REQUEST MAX PDU AND MTU Transcation"),UVM_LOW); end

       finish_item(srio_trans_item);
       #100ns;
        endtask 
endclass :srio_ll_ds_max_min_pdu_mtu_base_seq


//======= MESSAGE REQ  RANDOM SEQUENCE =======


class srio_ll_message_random_req_seq extends srio_ll_base_seq;
`uvm_object_utils(srio_ll_message_random_req_seq)
 srio_trans srio_trans_item;

  rand bit [3:0] ftype_0;
  
       function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
	
        srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);


        start_item(srio_trans_item);

	assert(srio_trans_item.randomize() with {ftype == ftype_0;});

         begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "Message request packet Transcation"),UVM_LOW); end

         srio_trans_item.print();

         finish_item(srio_trans_item);

  endtask
   endclass : srio_ll_message_random_req_seq

//======= MESSAGE REQ SEQUENCE =======


class srio_ll_message_req_seq extends srio_ll_base_seq;
`uvm_object_utils(srio_ll_message_req_seq)
 srio_trans srio_trans_item;

  rand bit [3:0] ftype_0;
  rand bit [3:0] ssize_0;
  int  message_length_0;
       function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
	
        srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ftype_B.constraint_mode(0);
	srio_trans_item.Ftype_B_2.constraint_mode(0);
        
        start_item(srio_trans_item);

	assert(srio_trans_item.randomize() with {ftype == ftype_0;ssize == ssize_0;message_length == message_length_0;});

         begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "Message request packet Transcation"),UVM_LOW); end

         srio_trans_item.print();

         finish_item(srio_trans_item);

  endtask
   endclass : srio_ll_message_req_seq

//======= MESSAGE REQ INTERLEAVED AND OUT OF ORDER SEQUENCE =======


class srio_ll_message_interleaved_out_order_req_seq  extends srio_ll_base_seq;
`uvm_object_utils(srio_ll_message_interleaved_out_order_req_seq)
 srio_trans srio_trans_item;

  rand bit [3:0] ftype_0;
  
       function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
	//repeat(5) begin //{	
        srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	//srio_trans_item.Ftype_B.constraint_mode(0);
        
        start_item(srio_trans_item);

	assert(srio_trans_item.randomize() with {ftype == ftype_0;});

         begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "Message request packet with interleaved Transcation"),UVM_LOW); end

         srio_trans_item.print();

         finish_item(srio_trans_item);
	//end //}
  endtask
   endclass :srio_ll_message_interleaved_out_order_req_seq

//======= DOORBELL SEQUENCE =======


class srio_ll_doorbell_seq extends srio_ll_base_seq;
`uvm_object_utils(srio_ll_doorbell_seq)
   srio_trans srio_trans_item;

   rand bit [3:0] ftype_0;
   
   function new(string name="");
    super.new(name);
    endfunction

  virtual task body();
	
        srio_trans_item = srio_trans::type_id::create("srio_trans_item"); 
	srio_trans_item.Ftype.constraint_mode(0);
	

        start_item(srio_trans_item);
	assert(srio_trans_item.randomize() with {ftype == ftype_0;}); 
       
         begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DOORBELL SEQUENCE Transcation"),UVM_LOW); end
         srio_trans_item.print();
         finish_item(srio_trans_item);

  endtask

endclass : srio_ll_doorbell_seq

//=====DATA STREAMING SEQUENCE======

class srio_ll_ds_sseg_req_base_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_ds_sseg_req_base_seq)

   srio_trans srio_trans_item;

     rand bit [7:0] mtusize_0;
     rand bit[15:0] pdulength_0;
 
     function new(string name="");
     super.new(name);
     endfunction

  virtual task body();
   	
     //DS Packet
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
      srio_trans_item.Ftype.constraint_mode(0);
      srio_trans_item.Ftype_9.constraint_mode(0);
      srio_trans_item.Xh.constraint_mode(0);
	  
	   
      start_item(srio_trans_item);

       assert(srio_trans_item.randomize() with {ftype ==4'h9 ;xh==1'b0;mtusize == mtusize_0;pdulength == pdulength_0;});
       begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DS SINGLE SEGMENT Transcation"),UVM_LOW); end

        srio_trans_item.print();
     finish_item(srio_trans_item);
     fork //{
	begin //{
        wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
        //@(env_config.ll_config.ll_pkt_transmitted);
        //@(env_config.ll_config.ll_pkt_received);
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET AFTER DS"),UVM_LOW);
	end //}
	begin //{
	#10000ns;
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET FAILED AFTER DS --- TIMEOUT OCCURED "),UVM_LOW);
	end //}
	join_any //}
	disable fork;  
  endtask
endclass :srio_ll_ds_sseg_req_base_seq	

  //DS MULTI SEGEMENT SEQUENCES

 class srio_ll_ds_mseg_req_base_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_ds_mseg_req_base_seq)

  srio_trans srio_trans_item;

     rand bit [15:0] pdulength_0;
     rand bit [7:0] mtusize_0; 
          
    function new(string name="");
    super.new(name);
    endfunction

  virtual task body();
     //DS Packet	
     srio_trans_item = srio_trans::type_id::create("srio_trans_item");
     srio_trans_item.Ftype.constraint_mode(0);
     srio_trans_item.Ftype_9.constraint_mode(0);
     srio_trans_item.Xh.constraint_mode(0);

     start_item(srio_trans_item);

     assert(srio_trans_item.randomize() with {ftype ==4'h9 ;xh==1'b0;pdulength == pdulength_0;mtusize == mtusize_0;});
     begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DS MULTI SEGMENT Transcation"),UVM_LOW); end  
       
    srio_trans_item.print();
    finish_item(srio_trans_item);
   #100ns; 
  endtask
endclass :srio_ll_ds_mseg_req_base_seq	

//======= TRAFFIC MANAGEMENT BASIC STREAM SEQUENCE =======

class srio_ll_ds_traffic_mgmt_basic_stream_base_seq extends srio_ll_base_seq;

`uvm_object_utils(srio_ll_ds_traffic_mgmt_basic_stream_base_seq)
    srio_trans srio_trans_item;

    rand bit [3:0] ftype_0;
    rand bit xh_0 ;
    rand bit [3:0]TMOP_0;
    rand bit [2:0] wild_card_0;
    rand bit [7:0] parameter1_0;
    
   function new (string name="");
    super.new(name);
    endfunction

virtual task body();
      //DS Packet

      srio_trans_item = srio_trans::type_id::create("srio_trans_item");	
      srio_trans_item.Ftype.constraint_mode(0);
      srio_trans_item.Xh.constraint_mode(0);  
      srio_trans_item.traffic_mgt.constraint_mode(0); 
      srio_trans_item.traffic_parameter1.constraint_mode(0);   
      start_item(srio_trans_item);

      assert(srio_trans_item.randomize() with {ftype == ftype_0;xh==xh_0;TMOP == TMOP_0;wild_card == wild_card_0;parameter1==parameter1_0;}); 
       
      begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DATA STREAMING TRAFFIC MANAGEMENT BASIC STREAM SEQUENCE Transcation"),UVM_LOW); end
         srio_trans_item.print();
         finish_item(srio_trans_item);
        #100ns;
        endtask

  endclass : srio_ll_ds_traffic_mgmt_basic_stream_base_seq

//======= TRAFFIC MANAGEMENT CREDIT BASED SEQUENCE =======

class srio_ll_ds_traffic_mgmt_credit_based_base_seq extends srio_ll_base_seq;

`uvm_object_utils(srio_ll_ds_traffic_mgmt_credit_based_base_seq)
    srio_trans srio_trans_item;

    rand bit [3:0] ftype_0;
    rand bit xh_0 ;
    rand bit [3:0]TMOP_0;
    rand bit [2:0] wild_card_0;
    rand bit [7:0] parameter1_0;
    rand bit [7:0] cos_0; 
    rand bit [15:0] streamID_0;
   function new (string name="");
    super.new(name);
    endfunction

virtual task body();

    //DS Packet	
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");	
      srio_trans_item.Ftype.constraint_mode(0);
      srio_trans_item.Xh.constraint_mode(0);  
      srio_trans_item.traffic_mgt.constraint_mode(0); 
      srio_trans_item.traffic_parameter1.constraint_mode(0);
      srio_trans_item.streamid.constraint_mode(0);  
      srio_trans_item.Tmop.constraint_mode(0); 
      start_item(srio_trans_item);

	assert(srio_trans_item.randomize() with {ftype == ftype_0;xh==xh_0;TMOP == TMOP_0;wild_card == wild_card_0;cos == cos_0 ;parameter1==parameter1_0;streamID == streamID_0;}); 
       
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DATA STREAMING TRAFFIC MANAGEMENT CREDIT BASED SEQUENCE Transcation"),UVM_LOW); end
        srio_trans_item.print();
        finish_item(srio_trans_item);
       #100ns;
         endtask

  endclass : srio_ll_ds_traffic_mgmt_credit_based_base_seq

//======= TRAFFIC MANAGEMENT CREDIT RATE BASED SEQUENCE =======

class srio_ll_ds_traffic_mgmt_credit_rate_based_base_seq extends srio_ll_base_seq;

`uvm_object_utils(srio_ll_ds_traffic_mgmt_credit_rate_based_base_seq)
    srio_trans srio_trans_item;

     
    rand bit [3:0] ftype_0;
    rand bit xh_0 ;
    rand bit [3:0]TMOP_0;
    rand bit [2:0] wild_card_0;
    rand bit [7:0] parameter1_0;
    
   function new (string name="");
    super.new(name);
    endfunction

virtual task body();
      //DS Packet

      srio_trans_item = srio_trans::type_id::create("srio_trans_item");	
      srio_trans_item.Ftype.constraint_mode(0);
      srio_trans_item.Xh.constraint_mode(0);  
      srio_trans_item.traffic_mgt.constraint_mode(0);
      srio_trans_item.traffic_parameter1.constraint_mode(0);    
      start_item(srio_trans_item);

      assert(srio_trans_item.randomize() with {ftype == ftype_0;xh==xh_0;TMOP == TMOP_0;wild_card == wild_card_0;parameter1==parameter1_0;}); 
       
      begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DATA STREAMING TRAFFIC MANAGEMENT CREDIT RATE BASED SEQUENCE Transcation"),UVM_LOW); end
      srio_trans_item.print();
      finish_item(srio_trans_item);
      #100ns;
  endtask

  endclass : srio_ll_ds_traffic_mgmt_credit_rate_based_base_seq


//======= TRAFFIC MANAGEMENT RATE BASED SEQUENCE =======

class srio_ll_ds_traffic_mgmt_rate_based_base_seq extends srio_ll_base_seq;

`uvm_object_utils(srio_ll_ds_traffic_mgmt_rate_based_base_seq)
    srio_trans srio_trans_item;

     
    rand bit [3:0] ftype_0;
    rand bit xh_0 ;
    rand bit [3:0]TMOP_0;
    rand bit [2:0] wild_card_0;
    rand bit [7:0] parameter1_0;
     rand bit [31:0] read_data; 


   function new (string name="");
    super.new(name);
    endfunction

virtual task body();

   //DS Packet
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
      srio_trans_item.Ftype.constraint_mode(0);
      srio_trans_item.Xh.constraint_mode(0);  
      srio_trans_item.traffic_mgt.constraint_mode(0);
      srio_trans_item.traffic_parameter1.constraint_mode(0);    
      start_item(srio_trans_item);

      assert(srio_trans_item.randomize() with {ftype == ftype_0;xh==xh_0;TMOP == TMOP_0;wild_card == wild_card_0;parameter1==parameter1_0;}); 
       
         begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DATA STREAMING TRAFFIC MANAGEMENT RATE BASED SEQUENCE Transcation"),UVM_LOW); end
         srio_trans_item.print();
         finish_item(srio_trans_item);
       #100ns;
  endtask

  endclass : srio_ll_ds_traffic_mgmt_rate_based_base_seq


//======= TRAFFIC MANAGEMENT RANDOM SEQUENCE =======

class srio_ll_traffic_mgmt_req_seq extends srio_ll_base_seq;

`uvm_object_utils(srio_ll_traffic_mgmt_req_seq)
    srio_trans srio_trans_item;

     rand bit [3:0] ftype_0;
     rand bit xh_0 ;
     rand bit [3:0]TMOP_0;
      
     function new (string name="");
     super.new(name);
     endfunction

 virtual task body();
      //DS Packet		
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");	
      srio_trans_item.Ftype.constraint_mode(0);
      srio_trans_item.Xh.constraint_mode(0);  
      srio_trans_item.Tmop.constraint_mode(0);    
      start_item(srio_trans_item);

      assert(srio_trans_item.randomize() with {ftype == ftype_0;xh==xh_0;TMOP == TMOP_0;}); 
       
      begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DATA STREAMING TRAFFIC MANAGEMENT SEQUENCE Transcation"),UVM_LOW); end
       srio_trans_item.print();
       finish_item(srio_trans_item);
       #100ns;
  endtask

  endclass : srio_ll_traffic_mgmt_req_seq

//======= DS AND TRAFFIC MANAGEMENT RANDOM SEQUENCE =======

class srio_ll_ds_traffic_mgmt_base_seq extends srio_ll_base_seq;

`uvm_object_utils(srio_ll_ds_traffic_mgmt_base_seq)
    srio_trans srio_trans_item;
     rand bit [3:0] ftype_0;
     rand bit xh_0 ;
     rand bit [3:0]TMOP_0;
     rand bit [7:0] mtusize_0;
     rand bit[15:0] pdulength_0;

    function new (string name="");
    super.new(name);
    endfunction

virtual task body();
      //DS PACKET
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");	
      srio_trans_item.Ftype.constraint_mode(0);
      srio_trans_item.Xh.constraint_mode(0);  
      srio_trans_item.Tmop.constraint_mode(0); 
      srio_trans_item.Ftype_9.constraint_mode(0);	   
        start_item(srio_trans_item);

	assert(srio_trans_item.randomize() with {ftype == 4'h9;xh==xh_0;TMOP == TMOP_0;mtusize == mtusize_0;pdulength == pdulength_0;}); 
       
         begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DATA STREAMING PACKET AND  TRAFFIC MANAGEMENT SEQUENCE Transcation"),UVM_LOW); end
         srio_trans_item.print();
         finish_item(srio_trans_item);
        #100ns;
	  endtask

  endclass : srio_ll_ds_traffic_mgmt_base_seq

//========LFC SEQUENCES=========
class srio_ll_lfc_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_lfc_seq)
   
  srio_trans srio_trans_item;

   rand bit [31:0] tgtdestID_0;
   rand bit [2:0] FAM_0;
   rand bit xon_xoff_0;
   rand bit [3:0] ftype_0;
   rand bit [31:0] DestinationID_0;
   rand bit [6:0] flowID_0;
   rand bit SOC_0;
   function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
      srio_trans_item.Ftype.constraint_mode(0);
      srio_trans_item.Ftype_7.constraint_mode(0);
      srio_trans_item.Ftype_7_fam.constraint_mode(0);
      srio_trans_item.Ftype_7_xon_xoff.constraint_mode(0);
	srio_trans_item.Ftype7_flowid.constraint_mode(0);

      start_item(srio_trans_item);

      assert(srio_trans_item.randomize() with {ftype ==ftype_0;flowID==flowID_0;xon_xoff==xon_xoff_0;tgtdestID==tgtdestID_0;DestinationID == DestinationID_0; FAM==FAM_0;});
		begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "LFC XOFF packet Transcation"),UVM_LOW); end

     
        srio_trans_item.print();
	finish_item(srio_trans_item);
      endtask
endclass :srio_ll_lfc_seq

//========LFC RANDOM SEQUENCES=========
class srio_ll_lfc_random_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_lfc_random_seq)
   
  srio_trans srio_trans_item;

   
   rand bit xon_xoff_0;
   rand bit [3:0] ftype_0;
   rand bit [2:0] FAM_0;
   function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
      srio_trans_item.Ftype.constraint_mode(0);
      srio_trans_item.Ftype_7_xon_xoff.constraint_mode(0);
      srio_trans_item.Ftype_7_fam.constraint_mode(0);

      srio_trans_item.prior.constraint_mode(0);
      start_item(srio_trans_item);

      assert(srio_trans_item.randomize() with {ftype ==ftype_0;xon_xoff==xon_xoff_0;prio == 2'b11;crf == 1'b1;FAM == FAM_0; });
		begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "LFC XOFF packet Transcation"),UVM_LOW); end

     
        srio_trans_item.print();
	finish_item(srio_trans_item);
      endtask
endclass :srio_ll_lfc_random_seq

//========FTYPE ERROR SEQUENCES=========

class srio_ll_ftype_error_base_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_ftype_error_base_seq)
   rand bit [3:0] ftype_0,ttype_0;
   rand bit y;
   rand bit [2:0] x;
 
  srio_trans srio_trans_item;

  function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
	srio_trans_item.ll_err.constraint_mode(0);
	 x = $random;
	 y = $random;

	case (x)  //{
  	 3'd0,3'd7 : ftype_0 = 4'h2;
   	3'd1,3'd6 : ftype_0 = 4'h5;
   	3'd2,3'd5 : ftype_0 = 4'h6;
   	3'd3 : ftype_0 = 4'h8;
     
  	endcase //}


	//Type
	if (ftype_0 == 4'h2)  begin 
		ttype_0 = y ? 4'h4 : $urandom_range(32'h0000_000C,32'h0000_000F);
	
	end 
	else if (ftype_0 == 4'h5) begin 
	        ttype_0 = y ? $urandom_range(32'h0000_0004,32'h0000_0005) : $urandom_range(32'h0000_000C,32'h0000_000E);
	
	end 
	else begin 
	  	ttype_0 = 4'h0;
	end 


     start_item(srio_trans_item);
     if(ftype_0 == 4'h6 )
      assert(srio_trans_item.randomize() with {ll_err_kind == FTYPE_ERR;ftype == ftype_0;} );
      else 
      assert(srio_trans_item.randomize() with {ll_err_kind == FTYPE_ERR;ftype == ftype_0;} );
  
     begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "INVALID FTYPE SEQUENCES"),UVM_LOW); end

        
	finish_item(srio_trans_item);
      endtask
endclass :srio_ll_ftype_error_base_seq

//========TTYPE ERROR SEQUENCES=========

class srio_ll_ttype_error_base_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_ttype_error_base_seq)
   rand bit [3:0] ftype_0,ttype_0;
   rand bit x,y;
 
  srio_trans srio_trans_item;

  function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
	srio_trans_item.ll_err.constraint_mode(0);
	
	 x = $urandom;
	 y = $urandom;
	// Ftype 
	ftype_0 = x ? 4'h8 :4'h5 ;
	//Type
	if (ftype_0 == 4'h8)  begin 
		ttype_0 = $urandom_range(32'h0000_0005,32'h0000_000F);
	
	end 
	else if (ftype_0 == 4'h5) begin 
	        ttype_0 = y ? $urandom_range(32'h0000_0002,32'h0000_0003) : $urandom_range(32'h0000_0006,32'h0000_000B);
	
	end 
	else begin 
	  	ttype_0 = 4'h0;
	
	end 


     start_item(srio_trans_item);

      assert(srio_trans_item.randomize() with {ll_err_kind == TTYPE_ERR;ftype == ftype_0;} );
 
  
     begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "INVALID TTYPE SEQUENCES"),UVM_LOW); end

        
	finish_item(srio_trans_item);
      endtask
endclass :srio_ll_ttype_error_base_seq

//========MAX SIZE ERROR SEQUENCES=========

class srio_ll_max_size_error_base_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_max_size_error_base_seq)
   rand bit [3:0] ftype_0,ttype_0;
   rand bit y;
   rand bit [2:0] x;
 
  srio_trans srio_trans_item;

  function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
	srio_trans_item.ll_err.constraint_mode(0);
	
	 x = $urandom;
	 y = $urandom;
	// Ftype 
	
	case (x)  //{
	   3'd0,3'd7 : ftype_0 = 4'h2;
	   3'd1,3'd6 : ftype_0 = 4'h5;
	   3'd2,3'd5 : ftype_0 = 4'h6;
	   3'd3 : ftype_0 = 4'h8;
	     
	  endcase //}
	
	//Type
	if (ftype_0 == 4'h2)  begin 
		ttype_0 = y ? 4'h4 : $urandom_range(32'h0000_000C,32'h0000_000F);
	
	end 
	else if (ftype_0 == 4'h5) begin 
	        ttype_0 = y ? $urandom_range(32'h0000_0004,32'h0000_0005) : $urandom_range(32'h0000_000C,32'h0000_000E);
	
	end 
	else begin 
	  	ttype_0 = 4'h0;
	end 
	
	 

     start_item(srio_trans_item);
      if(ftype_0 == 4'h6 )
      assert(srio_trans_item.randomize() with {ll_err_kind ==MAX_SIZE_ERR ;ftype == ftype_0;} );
      else 
      assert(srio_trans_item.randomize() with {ll_err_kind ==MAX_SIZE_ERR ;ftype == ftype_0;ttype == ttype_0;} );
 
  
     begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "INVALID MAX SIZE SEQUENCES"),UVM_LOW); end

        
	finish_item(srio_trans_item);
      endtask
endclass :srio_ll_max_size_error_base_seq

//========PAYLOAD  ERROR SEQUENCES=========

class srio_ll_payload_error_base_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_payload_error_base_seq)
   rand bit [3:0] ftype_0,ttype_0;
   rand bit y;
   rand bit [2:0] x;

  srio_trans srio_trans_item;

  function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
	srio_trans_item.ll_err.constraint_mode(0);
	
	 x = $urandom;
	 y = $urandom;
	// Ftype 
	
	case (x)  //{
	   3'd0,3'd7 : ftype_0 = 4'h2;
	   3'd1,3'd6 : ftype_0 = 4'h5;
	   3'd2,3'd5 : ftype_0 = 4'h6;
	   3'd3 : ftype_0 = 4'h8;
	     
	  endcase //}
	
	//Type
	if (ftype_0 == 4'h2)  begin 
		ttype_0 = y ? 4'hF : $urandom_range(32'h0000_000C,32'h0000_000E);
	
	end 
	else if (ftype_0 == 4'h5) begin 
	        ttype_0 = y ? $urandom_range(32'h0000_0004,32'h0000_0005) : $urandom_range(32'h0000_000C,32'h0000_000E);
	
	end 
	else begin 
	  	ttype_0 = 4'h1;
	end 
	

     start_item(srio_trans_item);
      if(ftype_0 == 4'h6 )
      assert(srio_trans_item.randomize() with {ll_err_kind ==PAYLOAD_ERR ;ftype == ftype_0 ;} );
      else 
      assert(srio_trans_item.randomize() with {ll_err_kind ==PAYLOAD_ERR ;ftype == ftype_0;ttype == ttype_0;} );
 
  
     begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "INVALID PAYLOAD  SEQUENCES"),UVM_LOW); end

        
	finish_item(srio_trans_item);
      endtask
endclass :srio_ll_payload_error_base_seq
//========SIZE  ERROR SEQUENCES=========
class srio_ll_size_error_base_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_size_error_base_seq)
   rand bit [3:0] ftype_0,ttype_0;
   rand bit y;
  rand bit [2:0] x;

  srio_trans srio_trans_item;

  function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
	srio_trans_item.ll_err.constraint_mode(0);
	srio_trans_item.wrsize_0.constraint_mode(0);
	
	
	 x = $urandom;
	 y = $urandom;
	// Ftype 
	
	case (x)  //{
	   3'd0,3'd7 : ftype_0 = 4'h2;
	   3'd1,3'd6 : ftype_0 = 4'h5;
	   3'd2,3'd5 : ftype_0 = 4'h6;
	   3'd3 : ftype_0 = 4'h8;
	     
	  endcase //}
	
	//Type
	if (ftype_0 == 4'h2)  begin 
		ttype_0 = y ? 4'h4 : $urandom_range(32'h0000_000C,32'h0000_000F);
	
	end 
	else if (ftype_0 == 4'h5) begin 
	        ttype_0 = y ? $urandom_range(32'h0000_0004,32'h0000_0005) : $urandom_range(32'h0000_000C,32'h0000_000E);
	
	end 
	else begin 
	  	ttype_0 = 4'h0;
	end 


     start_item(srio_trans_item);
      if(ftype_0 == 4'h6 )
      assert(srio_trans_item.randomize() with {ll_err_kind ==SIZE_ERR ;ftype == ftype_0;wrsize == 4'b1011;} );
      else 
      assert(srio_trans_item.randomize() with {ll_err_kind ==SIZE_ERR ;ftype == ftype_0;ttype == ttype_0;wrsize == 4'b1011;} );
 
  
     begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "INVALID SIZE  SEQUENCES"),UVM_LOW); end

        
	finish_item(srio_trans_item);
      endtask
endclass :srio_ll_size_error_base_seq

//========NO_PAYLOAD  ERROR SEQUENCES=========

class srio_ll_no_payload_error_base_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_no_payload_error_base_seq)
   rand bit [3:0] ftype_0,ttype_0;
   rand bit y;
   rand bit [2:0] x;

  srio_trans srio_trans_item;

  function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
	srio_trans_item.ll_err.constraint_mode(0);
	
	 x = $urandom;
	 y = $urandom;
	// Ftype 
	
	case (x)  //{
	   3'd0,3'd7 : ftype_0 = 4'h2;
	   3'd1,3'd6 : ftype_0 = 4'h5;
	   3'd2,3'd5 : ftype_0 = 4'h6;
	   3'd3 : ftype_0 = 4'h8;
	     
	  endcase //}
	
	//Type
	if (ftype_0 == 4'h2)  begin 
		ttype_0 = y ? 4'hF : $urandom_range(32'h0000_000C,32'h0000_000E);
	
	end 
	else if (ftype_0 == 4'h5) begin 
	        ttype_0 = y ? $urandom_range(32'h0000_0004,32'h0000_0005) : $urandom_range(32'h0000_000C,32'h0000_000E);
	
	end 
	else begin 
	  	ttype_0 = 4'h1;
	end 
	

     start_item(srio_trans_item);
      if(ftype_0 == 4'h6 )
      assert(srio_trans_item.randomize() with {ll_err_kind ==NO_PAYLOAD_ERR ;ftype == ftype_0;} );
      else 
      assert(srio_trans_item.randomize() with {ll_err_kind ==NO_PAYLOAD_ERR ;ftype == ftype_0;ttype == ttype_0;} );
 
  
     begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "INVALID NO_PAYLOAD  SEQUENCES"),UVM_LOW); end

        
	finish_item(srio_trans_item);
      endtask
endclass :srio_ll_no_payload_error_base_seq

//========PAYLOAD_EXIST  ERROR SEQUENCES=========

class srio_ll_payload_exist_error_base_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_payload_exist_error_base_seq)
   rand bit [3:0] ftype_0,ttype_0;
   rand bit y;
   rand bit [2:0] x;
 
  srio_trans srio_trans_item;

  function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
	srio_trans_item.ll_err.constraint_mode(0);
	
	 x = $urandom;
	 y = $urandom;
	// Ftype 
	
	case (x)  //{
	   3'd0,3'd7 : ftype_0 = 4'h2;
	   3'd1,3'd6 : ftype_0 = 4'h5;
	   3'd2,3'd5 : ftype_0 = 4'h6;
	   3'd3 : ftype_0 = 4'h8;
	     
	  endcase //}
	
	//Type
	if (ftype_0 == 4'h2)  begin 
		ttype_0 = y ? 4'hF : $urandom_range(32'h0000_000C,32'h0000_000E);
	
	end 
	else if (ftype_0 == 4'h5) begin 
	        ttype_0 = y ? $urandom_range(32'h0000_0004,32'h0000_0005) : $urandom_range(32'h0000_000C,32'h0000_000E);
	
	end 
	else begin 
	  	ttype_0 = 4'h1;
	end 


     start_item(srio_trans_item);
      if(ftype_0 == 4'h6 )
      assert(srio_trans_item.randomize() with {ll_err_kind ==PAYLOAD_EXIST_ERR ;ftype == ftype_0;} );
      else 
      assert(srio_trans_item.randomize() with {ll_err_kind ==PAYLOAD_EXIST_ERR ;ftype == ftype_0;ttype == ttype_0;} );
 
  
     begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "INVALID PAYLOAD_EXIST  SEQUENCES"),UVM_LOW); end

        
	finish_item(srio_trans_item);
      endtask
endclass :srio_ll_payload_exist_error_base_seq

//========ATOMIC_TEST_AND_SWAP  ERROR SEQUENCES=========

class srio_ll_atomic_test_and_swap_payload_error_base_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_atomic_test_and_swap_payload_error_base_seq)
 
  srio_trans srio_trans_item;

  function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
	srio_trans_item.ll_err.constraint_mode(0);



     start_item(srio_trans_item);

      assert(srio_trans_item.randomize() with {ll_err_kind ==ATAS_PAYLOAD_ERR ;ftype ==4'h5 ;ttype ==4'hE ;} );
 
  
     begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "INVALID ATOMIC_TEST_AND_SWAP  SEQUENCES"),UVM_LOW); end

        
	finish_item(srio_trans_item);
      endtask
endclass :srio_ll_atomic_test_and_swap_payload_error_base_seq

//========AS_PAYLOAD_ERR  ERROR SEQUENCES=========

class srio_ll_atomic_swap_error_base_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_atomic_swap_error_base_seq)
 
  srio_trans srio_trans_item;

  function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
	srio_trans_item.ll_err.constraint_mode(0);



     start_item(srio_trans_item);

      assert(srio_trans_item.randomize() with {ll_err_kind ==AS_PAYLOAD_ERR ;ftype ==4'h5 ;ttype ==4'hC ;} );
 
  
     begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "INVALID AS_PAYLOAD_ERR  SEQUENCES"),UVM_LOW); end

        
	finish_item(srio_trans_item);
      endtask
endclass :srio_ll_atomic_swap_error_base_seq

//========ACAS_PAYLOAD_ERR  ERROR SEQUENCES=========

class srio_ll_atomic_compare_and_swap_error_base_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_atomic_compare_and_swap_error_base_seq)
 
  srio_trans srio_trans_item;

  function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
	srio_trans_item.ll_err.constraint_mode(0);



     start_item(srio_trans_item);

      assert(srio_trans_item.randomize() with {ll_err_kind ==ACAS_PAYLOAD_ERR ;ftype ==4'h5 ;ttype ==4'hD ;} );
 
  
     begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "INVALID ACAS_PAYLOAD_ERR  SEQUENCES"),UVM_LOW); end

        
	finish_item(srio_trans_item);
      endtask
endclass :srio_ll_atomic_compare_and_swap_error_base_seq

//========DW_ALIGN_ERR ERROR SEQUENCES=========

class srio_ll_doubleword_align_error_base_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_doubleword_align_error_base_seq)
   rand bit [3:0] ftype_0,ttype_0;
   rand bit x,y;
 
  srio_trans srio_trans_item;

  function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
	srio_trans_item.ll_err.constraint_mode(0);
	
	
	
	 x = $urandom;
	 y = $urandom;
	// Ftype 
	ftype_0 = x ? 4'h8 :(4'h2 ? 4'h5 : 4'h6) ;
	
	//Type
	if (ftype_0 == 4'h8)  begin 
		ttype_0 = 1;
	
	end 
	else if (ftype_0 == 4'h5) begin 
	        ttype_0 = 4;
	
	end 
	else begin 
	  	ttype_0 = 4'h0;
	end 
	

     start_item(srio_trans_item);

      assert(srio_trans_item.randomize() with {ll_err_kind ==DW_ALIGN_ERR ;ftype == ftype_0;ttype == ttype_0;} );
 
  
     begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "INVALID MAX SIZE SEQUENCES"),UVM_LOW); end

        
	finish_item(srio_trans_item);
      endtask
endclass :srio_ll_doubleword_align_error_base_seq

//========LFC_PRI  ERROR SEQUENCES=========

class srio_ll_lfc_pri_error_base_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_lfc_pri_error_base_seq)
   rand bit [3:0] ftype_0,ttype_0;
   rand bit x,y;
 
  srio_trans srio_trans_item;

  function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
	srio_trans_item.ll_err.constraint_mode(0);

     start_item(srio_trans_item);

      assert(srio_trans_item.randomize() with {ll_err_kind ==LFC_PRI_ERR ;ftype == 4'h7;} );
 
     begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "INVALID LFC_PRI  SEQUENCES"),UVM_LOW); end

        
	finish_item(srio_trans_item);
      endtask
endclass :srio_ll_lfc_pri_error_base_seq

//========DS_MTU_ERR  ERROR SEQUENCES=========

class srio_ll_ds_mtu_error_base_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_ds_mtu_error_base_seq)
    srio_trans srio_trans_item;
 
   rand bit [7:0] mtusize_0;
   rand bit [31:0] pdulength_0;
   
  function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
 	 
    //DS packet with mtu error
        srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.ll_err.constraint_mode(0);
	srio_trans_item.Xh.constraint_mode(0);

     start_item(srio_trans_item);

      assert(srio_trans_item.randomize() with {ll_err_kind ==DS_MTU_ERR ;ftype == 4'h9;xh == 1'h0;pdulength == pdulength_0;mtusize == mtusize_0;} );
 
      begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "INVALID DS_MTU_ERR  SEQUENCES"),UVM_LOW); end 
      finish_item(srio_trans_item);
      fork //{
	begin //{
        wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET AFTER DS"),UVM_LOW);
	end //}
	begin //{
	#10000ns;
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET FAILED AFTER DS --- TIMEOUT OCCURED "),UVM_LOW);
	end //}
	join_any //}
      disable fork;

      endtask
endclass :srio_ll_ds_mtu_error_base_seq

//========DS_PDU_ERR  ERROR SEQUENCES=========

class srio_ll_ds_pdu_error_base_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_ds_pdu_error_base_seq)

   srio_trans srio_trans_item;

   rand bit [7:0] mtusize_0;
   rand bit [31:0] pdulength_0;

  function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
 	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.ll_err.constraint_mode(0);
	srio_trans_item.Xh.constraint_mode(0);
     start_item(srio_trans_item);

      assert(srio_trans_item.randomize() with {ll_err_kind ==DS_PDU_ERR ;ftype == 4'h9;xh == 1'h0;pdulength == pdulength_0;mtusize == mtusize_0;} );
 
     begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "INVALID DS_PDU_ERR  SEQUENCES"),UVM_LOW); end

       finish_item(srio_trans_item);
       fork //{
	begin //{
        wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET AFTER DS"),UVM_LOW);
	end //}
	begin //{
	#10000ns;
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET FAILED AFTER DS --- TIMEOUT OCCURED "),UVM_LOW);
	end //}
	join_any //}
      disable fork;

      endtask
endclass :srio_ll_ds_pdu_error_base_seq

//========DS_SOP_ERR  ERROR SEQUENCES=========

class srio_ll_ds_sop_error_base_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_ds_sop_error_base_seq)
    srio_trans srio_trans_item;

   rand bit [7:0] mtusize_0;
   rand bit [31:0] pdulength_0;
   

  function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
 	
        srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.ll_err.constraint_mode(0);
	srio_trans_item.Xh.constraint_mode(0);

     start_item(srio_trans_item);

      assert(srio_trans_item.randomize() with {ll_err_kind ==DS_SOP_ERR ;ftype == 4'h9;xh == 1'h0;pdulength == pdulength_0;mtusize == mtusize_0;} );
 
     begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "INVALID DS_SOP_ERR  SEQUENCES"),UVM_LOW); end
    finish_item(srio_trans_item);
    fork //{
	begin //{
        wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET AFTER DS"),UVM_LOW);
	end //}
	begin //{
	#10000ns;
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET FAILED AFTER DS --- TIMEOUT OCCURED "),UVM_LOW);
	end //}
	join_any //}
      disable fork;

      endtask
endclass :srio_ll_ds_sop_error_base_seq

//========DS_EOP_ERR  ERROR SEQUENCES=========

class srio_ll_ds_eop_error_base_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_ds_eop_error_base_seq)
   srio_trans srio_trans_item;

   rand bit [7:0] mtusize_0;
   rand bit [31:0] pdulength_0;
   
    function new(string name="");
    super.new(name);
    endfunction

  virtual task body();
         
        srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.ll_err.constraint_mode(0);
	srio_trans_item.Xh.constraint_mode(0);

     	start_item(srio_trans_item);

      assert(srio_trans_item.randomize() with {ll_err_kind ==DS_EOP_ERR ;ftype == 4'h9;xh == 1'h0;pdulength == pdulength_0;mtusize == mtusize_0;} );
     
     begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "INVALID DS_EOP_ERR  SEQUENCES"),UVM_LOW); end  
      finish_item(srio_trans_item);
     fork //{
	begin //{
        wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET AFTER DS"),UVM_LOW);
	end //}
	begin //{
	#10000ns;
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET FAILED AFTER DS --- TIMEOUT OCCURED "),UVM_LOW);
	end //}
	join_any //}
      disable fork;
      endtask
endclass :srio_ll_ds_eop_error_base_seq

//========DS_ODD_ERR  ERROR SEQUENCES=========

class srio_ll_ds_odd_error_base_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_ds_odd_error_base_seq)
   srio_trans srio_trans_item;

   rand bit [7:0] mtusize_0;
   rand bit [31:0] pdulength_0;

    function new(string name="");
    super.new(name);
    endfunction

  virtual task body();
 	        
        srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.ll_err.constraint_mode(0);
	srio_trans_item.Xh.constraint_mode(0);

     	start_item(srio_trans_item);

      assert(srio_trans_item.randomize() with {ll_err_kind ==DS_ODD_ERR ;ftype == 4'h9;xh == 1'h0;pdulength == pdulength_0;mtusize == mtusize_0;} ); 
  
     begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "INVALID DS_ODD_ERR  SEQUENCES"),UVM_LOW); end 
	finish_item(srio_trans_item);
     fork //{
	begin //{
        wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET AFTER DS"),UVM_LOW);
	end //}
	begin //{
	#10000ns;
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET FAILED AFTER DS --- TIMEOUT OCCURED "),UVM_LOW);
	end //}
	join_any //}
      disable fork;

      endtask
endclass :srio_ll_ds_odd_error_base_seq

//========DS_PAD_ERR  ERROR SEQUENCES=========

class srio_ll_ds_pad_error_base_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_ds_pad_error_base_seq)
   srio_trans srio_trans_item;

   rand bit [7:0] mtusize_0;
   rand bit [31:0] pdulength_0;
    
  function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
 	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.ll_err.constraint_mode(0);
	srio_trans_item.Xh.constraint_mode(0);

 	start_item(srio_trans_item);

      assert(srio_trans_item.randomize() with {ll_err_kind ==DS_PAD_ERR ;ftype == 4'h9;xh == 1'h0;pdulength == pdulength_0;mtusize == mtusize_0;} ); 
  
     begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "INVALID DS_PAD_ERR  SEQUENCES"),UVM_LOW); end 
	finish_item(srio_trans_item);
      fork //{
	begin //{
        wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET AFTER DS"),UVM_LOW);
	end //}
	begin //{
	#10000ns;
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET FAILED AFTER DS --- TIMEOUT OCCURED "),UVM_LOW);
	end //}
	join_any //}
      disable fork;
      endtask
endclass :srio_ll_ds_pad_error_base_seq

//========MSG_SSIZE_ERR  ERROR SEQUENCES=========

class srio_ll_msg_ssize_error_base_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_msg_ssize_error_base_seq)
   
  srio_trans srio_trans_item;

  function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
	srio_trans_item.ll_err.constraint_mode(0);

     start_item(srio_trans_item);

      assert(srio_trans_item.randomize() with {ll_err_kind ==MSG_SSIZE_ERR ;ftype == 4'hB;} );
 
  
     begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "INVALID MSG_SSIZE_ERR  SEQUENCES"),UVM_LOW); end

        
	finish_item(srio_trans_item);
      endtask
endclass :srio_ll_msg_ssize_error_base_seq

//========MSGSEG_ERR  ERROR SEQUENCES=========

class srio_ll_msgseg_error_base_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_msgseg_error_base_seq)
    srio_trans srio_trans_item;

  function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
	srio_trans_item.ll_err.constraint_mode(0);

     start_item(srio_trans_item);

      assert(srio_trans_item.randomize() with {ll_err_kind ==MSGSEG_ERR ;ftype == 4'hB;} );
 
  
     begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "INVALID MSGSEG_ERR  SEQUENCES"),UVM_LOW); end

        
	finish_item(srio_trans_item);
      endtask
endclass :srio_ll_msgseg_error_base_seq

//========RESP_RSVD_STS_ERR SEQUENCES=========

class srio_ll_resp_rsvd_sts_error_base_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_resp_rsvd_sts_error_base_seq)
   rand bit [3:0] ttype_0;
   rand bit y;

 
  srio_trans srio_trans_item;

  function new(string name="");
    super.new(name);
  endfunction

  virtual task body();


      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
	srio_trans_item.ll_err.constraint_mode(0);
	
	y = $random;
	 ttype_0 = y ? $urandom_range(32'h0000_000F,32'h0000_0009) : $urandom_range(32'h0000_0007,32'h0000_0002);
	 
     start_item(srio_trans_item);

      assert(srio_trans_item.randomize() with {ll_err_kind ==RESP_RSVD_STS_ERR ;ftype == 4'hD;ttype == ttype_0;} );
 
  
     begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "INVALID RESP_RSVD_STS_ERR  SEQUENCES"),UVM_LOW); end

        
	finish_item(srio_trans_item);
      endtask
endclass :srio_ll_resp_rsvd_sts_error_base_seq

//========RESP_PRI_ERR SEQUENCES=========

class srio_ll_resp_pri_error_base_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_resp_pri_error_base_seq)
   rand bit [3:0] ttype_0;
   rand bit [1:0] y;
   
  srio_trans srio_trans_item;

  function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);


     start_item(srio_trans_item);

      assert(srio_trans_item.randomize() with {ftype == 4'h2;ttype == 4'h4;} );
 
  
     begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "INVALID RESP_PRI_ERR  SEQUENCES"),UVM_LOW); end

        
	finish_item(srio_trans_item);
      endtask
endclass :srio_ll_resp_pri_error_base_seq

//========RESP_PAYLOAD_ERR SEQUENCES=========

class srio_ll_resp_payload_error_base_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_resp_payload_error_base_seq)
   rand bit [3:0] ftype_0,ttype_0;
   
  srio_trans srio_trans_item;

  function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
	srio_trans_item.ll_err.constraint_mode(0);

 

     start_item(srio_trans_item);

      assert(srio_trans_item.randomize() with {ll_err_kind ==RESP_PAYLOAD_ERR ;ftype == 4'hD;} );
 
  
     begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "INVALID RESP_PAYLOAD_ERR  SEQUENCES"),UVM_LOW); end

        
	finish_item(srio_trans_item);
      endtask
endclass :srio_ll_resp_payload_error_base_seq 


//========= USER GENERATE SEQUENCE =========

class srio_ll_user_gen_base_seq extends srio_ll_base_seq;
    `uvm_object_utils(srio_ll_user_gen_base_seq)

   srio_trans srio_trans_item;

  rand bit [3:0] ftype_0;
  rand bit [3:0] ttype_0;
  rand bit [2:0] mode ;
  rand bit flag,crf_0;
  rand bit [1:0] prio_0;
      function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
     srio_trans_item = srio_trans::type_id::create("srio_trans_item");	
     srio_trans_item.Ftype.constraint_mode(0);
     srio_trans_item.Ttype.constraint_mode(0);
     srio_trans_item.prior.constraint_mode(0);
     srio_trans_item.Crf.constraint_mode(0);
     
     mode = $urandom;
	flag = $urandom;
	// Ftype 
	
	case (mode)  //{
	    3'd0,3'd5: ftype_0 = 4'h2;
	   3'd1,3'd6: ftype_0 = 4'h5;
	   3'd2,3'd7: ftype_0 = 4'h6;
	   3'd3: ftype_0 = 4'hA;
	   3'd4: ftype_0 = 4'hB;
           
	  endcase //}
	
	//Type
	if (ftype_0 == 4'h2)  begin 
		ttype_0 = flag ? 4'h4 : $urandom_range(32'h0000_000C,32'h0000_000F);
	
	end 
	else if (ftype_0 == 4'h5) begin 
	        ttype_0 = flag ? $urandom_range(32'h0000_0004,32'h0000_0005) : $urandom_range(32'h0000_000C,32'h0000_000E);
	
	end 
	else begin 
	 	ttype_0 = 4'h0;
	end 
	

      start_item(srio_trans_item);
     if(ftype_0 == 4'h6 ||ftype_0 == 4'hA || ftype_0 == 4'hB )
     assert(srio_trans_item.randomize() with {ftype == ftype_0; prio == prio_0; crf == crf_0;});
     else 
     assert(srio_trans_item.randomize() with {ftype == ftype_0;ttype == ttype_0; prio == prio_0; crf == crf_0;});
         
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " RANDOM USER GENERATE  Transcation PRIO : %0h , CRF : %0h",prio_0,crf_0),UVM_LOW); end
        srio_trans_item.print();
        finish_item(srio_trans_item);
  endtask

endclass : srio_ll_user_gen_base_seq

//========= IO RANDOM SEQUENCE =========

class srio_ll_io_random_base_seq extends srio_ll_base_seq;
    `uvm_object_utils(srio_ll_io_random_base_seq)

   srio_trans srio_trans_item;

  rand bit [3:0] ftype_0;
  rand bit [3:0] ttype_0;
  rand bit [1:0] mode;
  rand bit flag;
      function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
	
     srio_trans_item = srio_trans::type_id::create("srio_trans_item");	
     srio_trans_item.Ftype.constraint_mode(0);
     srio_trans_item.Ttype.constraint_mode(0);
     mode = $urandom;
     // Ftype 
     ftype_0 = mode ? 4'h6 : 4'h5;
     if(ftype_0 == 4'h5)
     ttype_0 = 4'h4;
     start_item(srio_trans_item);
     if(ftype_0 == 4'h6 )
     assert(srio_trans_item.randomize() with {ftype ==ftype_0 ;});  
     else 
     assert(srio_trans_item.randomize() with {ftype ==ftype_0 ;ttype == ttype_0;});  
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " RANDOM I0  Transcation"),UVM_LOW); end 
       srio_trans_item.print();

        finish_item(srio_trans_item);
  endtask

endclass : srio_ll_io_random_base_seq

//DS MULTI SEGEMENT AND SINGLE MTU  SEQUENCES
class srio_ll_ds_mseg_single_mtu_base_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_ds_mseg_single_mtu_base_seq)

  srio_trans srio_trans_item;

     rand bit [3:0] ftype_0;
     rand bit xh_0 ;
     rand bit [15:0] pdulength_0;
     rand bit [7:0] mtusize_0; 
        
function new(string name="");
    super.new(name);
  endfunction

  virtual task body();

 ///DS PACKET

	repeat(5) begin //{
           srio_trans_item = srio_trans::type_id::create("srio_trans_item");
           srio_trans_item.Ftype.constraint_mode(0);
	   srio_trans_item.Ftype_9.constraint_mode(0);
	   srio_trans_item.Xh.constraint_mode(0);
	   
           start_item(srio_trans_item);

            assert(srio_trans_item.randomize() with {ftype ==4'h9 ;xh==1'b0;pdulength == pdulength_0;mtusize == mtusize_0;});
            begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DS MULTI SEGMENT -- SINGLE MTU CONFIGURED Transcation"),UVM_LOW); end
   srio_trans_item.print();
   finish_item(srio_trans_item);
	end //}
   #1000ns;
  endtask
endclass :srio_ll_ds_mseg_single_mtu_base_seq

 
// PORT RESPONSE TIMEOUT REGISTER SEQUENCE

class srio_ll_port_resp_timeout_reg_base_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_port_resp_timeout_reg_base_seq)

  srio_trans srio_trans_item;
 
   rand bit [31:0] read_data;

 function new(string name="");
    super.new(name);
  endfunction

virtual task body();
	
        
      	srio_trans_item = srio_trans::type_id::create("srio_trans_item");

	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
     	srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.rdsize_0.constraint_mode(0);
	srio_trans_item.Ftype_8.constraint_mode(0);
	

    // Maintenance Read 
        start_item(srio_trans_item);
       srio_trans_item.usr_gen_pkt =1;
	assert(srio_trans_item.randomize() with {
     ftype == 4'h8;
     ttype == 4'h0 ;
     rdsize ==4'h8 ;
     wrsize ==4'h8 ;
     wdptr ==1'b0 ;
     config_offset == 21'h124;});

	srio_trans_item.print();

        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE READ REQUEST Transcation"),UVM_LOW); end
finish_item(srio_trans_item);

		fork //{
	begin //{
        @(env_config.ll_config.ll_pkt_received);
        #20ns;

	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET "),UVM_LOW);
	end //}
	begin //{
	#5000ns;
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET FAILED --- TIMEOUT OCCURED "),UVM_LOW);
	end //}
	join_any //}
	disable fork;

	read_data = env_config.srio_reg_model_rx.Port_Response_Timeout_Control_CSR.timeout_value.get();
	

        read_data[23:0] = 20;////$urandom_range(32'd1000,32'd100);
	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
     	srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.rdsize_0.constraint_mode(0);
	srio_trans_item.Ftype_8.constraint_mode(0);
	

	//Maintenance Write For Port Response Timeout Register
	start_item(srio_trans_item);
       srio_trans_item.usr_gen_pkt =1;
	assert(srio_trans_item.randomize() with {
     ftype == 4'h8;
     ttype == 4'h1 ;
     rdsize ==4'h8 ;
     wrsize ==4'h8 ;
     wdptr ==1'b0 ;
     config_offset == 21'h124;});

     srio_trans_item.payload.push_back(read_data[31:24]);
     srio_trans_item.payload.push_back(read_data[23:16]);
     srio_trans_item.payload.push_back(read_data[15:8]);
     srio_trans_item.payload.push_back(read_data[7:0]);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);

     srio_trans_item.print();
	
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE REQUEST FOR PORT RESPONSE REGISTER Transcation"),UVM_LOW); end

       finish_item(srio_trans_item);

	#50ns;
	read_data = env_config.srio_reg_model_rx.Port_Response_Timeout_Control_CSR.timeout_value.get();

	endtask
endclass :srio_ll_port_resp_timeout_reg_base_seq

//========ATOMIC REQUEST SEQUENCES for all=========

class srio_ll_all_atomic_req_base_seq extends srio_ll_base_seq;
 `uvm_object_utils(srio_ll_all_atomic_req_base_seq)
  srio_trans srio_trans_item;

  rand bit [3:0] ftype_0;
  rand bit [3:0] ttype_0;
  rand bit flag;
  
  
  function new(string name="");
    super.new(name);
  endfunction

  virtual task body(); //{
    srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
    flag = $urandom;
    case(flag) //{
        1'b0 : ftype_0 = 4'h2;
        1'b1 : ftype_0 = 4'h5;
    endcase //}
    if(ftype_0 == 2)    
        ttype_0 = $urandom_range(32'h0000_000f,32'h0000_000c);
    else if(ftype_0 == 5)
        ttype_0 = $urandom_range(32'h0000_000e,32'h0000_000c);

    start_item(srio_trans_item); //{
    assert(srio_trans_item.randomize() with {ftype == ftype_0 ;ttype == ttype_0 ;});
    begin  //{
       `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "ATOMIC REQUEST SEQUENCES"),UVM_LOW);
    end //}
    srio_trans_item.print();
	finish_item(srio_trans_item); //}
  endtask //}
endclass :srio_ll_all_atomic_req_base_seq

//========DS CONCURRENT SEQUENCES=========

 class srio_ll_ds_concurrent_base_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_ds_concurrent_base_seq)

  srio_trans srio_trans_item;

     rand bit [3:0] ftype_0;
     rand bit xh_0 ;
     rand bit [15:0] pdulength_0;
     rand bit [7:0] mtusize_0; 
     rand bit [31:0] read_data;     
  function new(string name="");
    super.new(name);
  endfunction
  virtual task body();
 	mtusize_0 = $urandom_range(32'd64,32'd8);
 	pdulength_0 = $urandom_range(32'h0000_0FFF,mtusize_0*4);
	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
    srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.rdsize_0.constraint_mode(0);
	srio_trans_item.Ftype_8.constraint_mode(0);
    // Maintenance Read 
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt =1;
	assert(srio_trans_item.randomize() with {
     ftype == 4'h8;
     ttype == 4'h0 ;
     rdsize ==4'h8 ;
     wrsize ==4'h8 ;
     wdptr ==1'b0 ;
     config_offset == 21'h48;});
	srio_trans_item.print();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE READ REQUEST Transcation"),UVM_LOW); end
finish_item(srio_trans_item);
	fork //{
	begin //{
        @(env_config.ll_config.ll_pkt_received);
        #20ns;
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET "),UVM_LOW);
	end //}
	begin //{
	#5000ns;
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET FAILED --- TIMEOUT OCCURED "),UVM_LOW);
	end //}
	join_any //}
disable fork;
	read_data = env_config.srio_reg_model_rx.Data_Streaming_Logical_Layer_Control_CSR.get();
    read_data[31:24] = mtusize_0;
    read_data[7:0] = {4'b1110,4'b0000};
	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
    srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.rdsize_0.constraint_mode(0);
	srio_trans_item.Ftype_8.constraint_mode(0);
	//Maintenance Write
	start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt =1;
	assert(srio_trans_item.randomize() with {
     ftype == 4'h8;
     ttype == 4'h1 ;
     rdsize ==4'h8 ;
     wrsize ==4'h8 ;
     wdptr ==1'b0 ;
     config_offset == 21'h48;});
     srio_trans_item.payload.push_back(read_data[31:24]);
     srio_trans_item.payload.push_back(read_data[23:16]);
     srio_trans_item.payload.push_back(read_data[15:8]);
     srio_trans_item.payload.push_back(read_data[7:0]);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.print();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE REQUEST Transcation"),UVM_LOW); end
     finish_item(srio_trans_item);
	#100ns;
//DS PACKET
fork
  begin
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
      srio_trans_item.Ftype.constraint_mode(0);
      srio_trans_item.Ftype_9.constraint_mode(0);
	  srio_trans_item.Xh.constraint_mode(0);
      start_item(srio_trans_item);
      assert(srio_trans_item.randomize() with {ftype ==4'h9 ;xh==1'b0;pdulength == pdulength_0;mtusize == mtusize_0;});
      begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DS MULTI SEGMENT -- SINGLE MTU CONFIGURED Transcation"),UVM_LOW); end
	  srio_trans_item.print();
	  finish_item(srio_trans_item);
  end
  begin
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
      srio_trans_item.Ftype.constraint_mode(0);
      srio_trans_item.Ftype_9.constraint_mode(0);
	  srio_trans_item.Xh.constraint_mode(0);
      start_item(srio_trans_item);
      assert(srio_trans_item.randomize() with {ftype ==4'h9 ;xh==1'b0;pdulength == pdulength_0;mtusize == mtusize_0;});
      begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DS MULTI SEGMENT -- SINGLE MTU CONFIGURED Transcation"),UVM_LOW); end
	  srio_trans_item.print();
	  finish_item(srio_trans_item);
  end
  begin
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
      srio_trans_item.Ftype.constraint_mode(0);
      srio_trans_item.Ftype_9.constraint_mode(0);
	  srio_trans_item.Xh.constraint_mode(0);
      start_item(srio_trans_item);
      assert(srio_trans_item.randomize() with {ftype ==4'h9 ;xh==1'b0;pdulength == pdulength_0;mtusize == mtusize_0;});
      begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DS MULTI SEGMENT -- SINGLE MTU CONFIGURED Transcation"),UVM_LOW); end
	  srio_trans_item.print();
	  finish_item(srio_trans_item);
  end
  begin
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
      srio_trans_item.Ftype.constraint_mode(0);
      srio_trans_item.Ftype_9.constraint_mode(0);
	  srio_trans_item.Xh.constraint_mode(0);
      start_item(srio_trans_item);
      assert(srio_trans_item.randomize() with {ftype ==4'h9 ;xh==1'b0;pdulength == pdulength_0;mtusize == mtusize_0;});
      begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DS MULTI SEGMENT -- SINGLE MTU CONFIGURED Transcation"),UVM_LOW); end
	  srio_trans_item.print();
	  finish_item(srio_trans_item);
  end
join
  endtask
endclass :srio_ll_ds_concurrent_base_seq

//========DS maximum active segment support =========

 class srio_ll_ds_max_seg_support_base_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_ds_max_seg_support_base_seq)

  srio_trans srio_trans_item;

     rand bit [3:0] ftype_0;
     rand bit xh_0 ;
     rand bit [15:0] pdulength_0;
     rand bit [7:0] mtusize_0; 
     rand bit [31:0] read_data;     
  function new(string name="");
    super.new(name);
  endfunction
  virtual task body();
 	mtusize_0 = $urandom_range(32'd64,32'd8);
 	pdulength_0 = $urandom_range(32'h0000_0FFF,32'h0000_01FF);
	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
    srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.rdsize_0.constraint_mode(0);
	srio_trans_item.Ftype_8.constraint_mode(0);
    // Maintenance Read 
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt =1;
	assert(srio_trans_item.randomize() with {
     ftype == 4'h8;
     ttype == 4'h0 ;
     rdsize ==4'h8 ;
     wrsize ==4'h8 ;
     wdptr ==1'b0 ;
     config_offset == 21'h48;});
	srio_trans_item.print();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE READ REQUEST Transcation"),UVM_LOW); end
finish_item(srio_trans_item);
	fork //{
	begin //{
        @(env_config.ll_config.ll_pkt_received);
        #20ns;
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET "),UVM_LOW);
	end //}
	begin //{
	#5000ns;
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET FAILED --- TIMEOUT OCCURED "),UVM_LOW);
	end //}
	join_any //}
disable fork;
	read_data = env_config.srio_reg_model_rx.Data_Streaming_Logical_Layer_Control_CSR.get();
    read_data[31:24] = mtusize_0;
    read_data[7:0] = {4'b1110,4'b0000};
	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
    srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.rdsize_0.constraint_mode(0);
	srio_trans_item.Ftype_8.constraint_mode(0);
	//Maintenance Write
	start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt =1;
	assert(srio_trans_item.randomize() with {
     ftype == 4'h8;
     ttype == 4'h1 ;
     rdsize ==4'h8 ;
     wrsize ==4'h8 ;
     wdptr ==1'b0 ;
     config_offset == 21'h48;});
     srio_trans_item.payload.push_back(read_data[31:24]);
     srio_trans_item.payload.push_back(read_data[23:16]);
     srio_trans_item.payload.push_back(read_data[15:8]);
     srio_trans_item.payload.push_back(read_data[7:0]);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.print();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE REQUEST Transcation"),UVM_LOW); end
     finish_item(srio_trans_item);
	#100ns;
 //DS PACKET
repeat(20)
   begin //{
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
      srio_trans_item.Ftype.constraint_mode(0);
      srio_trans_item.Ftype_9.constraint_mode(0);
	  srio_trans_item.Xh.constraint_mode(0);
      start_item(srio_trans_item);
      assert(srio_trans_item.randomize() with {ftype ==4'h9 ;xh==1'b0;pdulength == pdulength_0;mtusize == mtusize_0;});
      begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DS Maximum active Segment Support"),UVM_LOW); end
	  srio_trans_item.print();
	  finish_item(srio_trans_item);
	end //}
  endtask
endclass :srio_ll_ds_max_seg_support_base_seq

//========DS MTU RESERVED SEQUENCES=========

 class srio_ll_ds_mtu_reserved_base_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_ds_mtu_reserved_base_seq)

  srio_trans srio_trans_item;

     rand bit [3:0] ftype_0;
     rand bit xh_0 ;
     rand bit [15:0] pdulength_0;
     rand bit [7:0] mtusize_0; 
     rand bit [31:0] read_data;     
     rand bit flag;
  function new(string name="");
    super.new(name);
  endfunction
  virtual task body();
    flag = $urandom;
    if(flag)
     	mtusize_0 = $urandom_range(32'd7,32'd0);
    else
        mtusize_0 = $urandom_range(32'hffffffff,32'd65);
 	pdulength_0 = $urandom_range(32'h0000_0FFF,mtusize_0*4);
	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
    srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.rdsize_0.constraint_mode(0);
	srio_trans_item.Ftype_8.constraint_mode(0);
    // Maintenance Read 
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt =1;
	assert(srio_trans_item.randomize() with {
     ftype == 4'h8;
     ttype == 4'h0 ;
     rdsize ==4'h8 ;
     wrsize ==4'h8 ;
     wdptr ==1'b0 ;
     config_offset == 21'h48;});
	srio_trans_item.print();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE READ REQUEST Transcation"),UVM_LOW); end
finish_item(srio_trans_item);
	fork //{
	begin //{
	wait(env_config.ll_config.tx_mon_tot_pkt_rcvd > 0);
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET "),UVM_LOW);
	end //}
	begin //{
	#5000ns;
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET FAILED --- TIMEOUT OCCURED "),UVM_LOW);
	end //}
	join_any //}
disable fork;
	read_data = env_config.srio_reg_model_rx.Data_Streaming_Logical_Layer_Control_CSR.get();
    read_data[31:24] = mtusize_0;
    read_data[7:0] = {4'b1110,4'b0000};
	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
    srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.rdsize_0.constraint_mode(0);
	srio_trans_item.Ftype_8.constraint_mode(0);
	//Maintenance Write
	start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt =1;
	assert(srio_trans_item.randomize() with {
     ftype == 4'h8;
     ttype == 4'h1 ;
     rdsize ==4'h8 ;
     wrsize ==4'h8 ;
     wdptr ==1'b0 ;
     config_offset == 21'h48;});
     srio_trans_item.payload.push_back(read_data[31:24]);
     srio_trans_item.payload.push_back(read_data[23:16]);
     srio_trans_item.payload.push_back(read_data[15:8]);
     srio_trans_item.payload.push_back(read_data[7:0]);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.print();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE REQUEST Transcation"),UVM_LOW); end
     finish_item(srio_trans_item);
	#100ns;
//DS PACKET
   begin //{
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
      srio_trans_item.Ftype.constraint_mode(0);
      srio_trans_item.Ftype_9.constraint_mode(0);
	  srio_trans_item.Xh.constraint_mode(0);
      start_item(srio_trans_item);
      assert(srio_trans_item.randomize() with {ftype ==4'h9 ;xh==1'b0;pdulength == pdulength_0;mtusize == mtusize_0;});
      begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DS Sequence for Reserved MTU "),UVM_LOW); end
	  srio_trans_item.print();
	  finish_item(srio_trans_item);
	end //}
  endtask
endclass :srio_ll_ds_mtu_reserved_base_seq

//========DS START AND END ERROR SEQUENCES=========

 class srio_ll_ds_s_e_err_base_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_ds_s_e_err_base_seq)

  srio_trans srio_trans_item;

     rand bit [3:0] ftype_0;
     rand bit xh_0 ;
     rand bit [15:0] pdulength_0;
     rand bit [7:0] mtusize_0; 
     rand bit [31:0] read_data;     
     rand bit [1:0] flag;
     rand bit odd = 0;
  function new(string name="");
    super.new(name);
  endfunction
  virtual task body();
 	mtusize_0 = $urandom_range(32'd64,32'd8);
 	pdulength_0 = $urandom_range(32'h0000_0FFF,mtusize_0*4);
    if (pdulength_0 % 2 > 0)
        pdulength_0 = pdulength_0+1;
    if ((pdulength_0 % 4 == 1) || (pdulength_0 % 4 == 2))
         odd = 0;

	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
    srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.rdsize_0.constraint_mode(0);
	srio_trans_item.Ftype_8.constraint_mode(0);
    // Maintenance Read 
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt =1;
	assert(srio_trans_item.randomize() with {
     ftype == 4'h8;
     ttype == 4'h0 ;
     rdsize ==4'h8 ;
     wrsize ==4'h8 ;
     wdptr ==1'b0 ;
     config_offset == 21'h48;});
	srio_trans_item.print();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE READ REQUEST Transcation"),UVM_LOW); end
finish_item(srio_trans_item);
	fork //{
	begin //{
	        @(env_config.ll_config.ll_pkt_received);
        #20ns;
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET "),UVM_LOW);
	end //}
	begin //{
	#5000ns;
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET FAILED --- TIMEOUT OCCURED "),UVM_LOW);
	end //}
	join_any //}
disable fork;
	read_data = env_config.srio_reg_model_rx.Data_Streaming_Logical_Layer_Control_CSR.get();
    read_data[31:24] = mtusize_0;
    read_data[7:0] = {4'b1110,4'b0000};
	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
    srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.rdsize_0.constraint_mode(0);
	srio_trans_item.Ftype_8.constraint_mode(0);
	//Maintenance Write
	start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt =1;
	assert(srio_trans_item.randomize() with {
     ftype == 4'h8;
     ttype == 4'h1 ;
     rdsize ==4'h8 ;
     wrsize ==4'h8 ;
     wdptr ==1'b0 ;
     config_offset == 21'h48;});
     srio_trans_item.payload.push_back(read_data[31:24]);
     srio_trans_item.payload.push_back(read_data[23:16]);
     srio_trans_item.payload.push_back(read_data[15:8]);
     srio_trans_item.payload.push_back(read_data[7:0]);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.print();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE REQUEST Transcation"),UVM_LOW); end
     finish_item(srio_trans_item);
	#100ns;
//DS PACKET
  repeat(10)
   begin //{
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
      srio_trans_item.Ftype.constraint_mode(0);
      srio_trans_item.Ftype_9.constraint_mode(0);
	  srio_trans_item.Xh.constraint_mode(0);
      srio_trans_item.Ftype_9A.constraint_mode(0);
      srio_trans_item.streamid.constraint_mode(0);
      flag = $urandom_range(32'd2,32'd0);
      start_item(srio_trans_item);
      srio_trans_item.usr_gen_pkt =1;
      assert(srio_trans_item.randomize() with {ftype ==4'h9 ;cos == 0;O == odd ; P == 0 ;xh==1'b0;streamID == 0;{S,E} == flag;pdulength == pdulength_0;mtusize == mtusize_0;});
      for(int i=0; i<mtusize_0*4; i++)
       srio_trans_item.payload.push_back(i);
      begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DS witn Incorrect Start and End segment"),UVM_LOW); end
	  srio_trans_item.print();
	  finish_item(srio_trans_item);
	end //}
  
  endtask
endclass :srio_ll_ds_s_e_err_base_seq

//=====DS WITH CORRUPTED DATA PAYLOAD SIZE =======

class srio_ll_ds_payload_size_err_base_seq extends srio_ll_base_seq;
  `uvm_object_utils(srio_ll_ds_payload_size_err_base_seq)
  srio_trans srio_trans_item;
   rand bit [15:0] pdulength_0;
   rand bit [7:0] mtusize_0; 
   rand bit [31:0] read_data;
   rand bit inc;
   rand bit odd;
 function new(string name="");
    super.new(name);
  endfunction
virtual task body();
    mtusize_0 = $urandom_range(32'd64,32'd8);
   `uvm_info("MTU SIZE VALUE",$sformatf("The randomized value of mtusize_0 is %0b",mtusize_0),UVM_LOW)
	pdulength_0 =$urandom_range(32'h0000_FFFF,32'h0000_0000);
    inc = $urandom;
    if (pdulength_0 % 2 > 0)
        pdulength_0 = pdulength_0+1;
    if ((pdulength_0 % 4 == 1) || (pdulength_0 % 4 == 2))
         odd = 0;
  	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
   	srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.rdsize_0.constraint_mode(0);
	srio_trans_item.Ftype_8.constraint_mode(0);
    // Maintenance Read 
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt =1;
	assert(srio_trans_item.randomize() with {
     ftype == 4'h8;
     ttype == 4'h0 ;
     rdsize ==4'h8 ;
     wrsize ==4'h8 ;
     wdptr ==1'b0 ;
     config_offset == 21'h48;});
	 srio_trans_item.print();
     begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE READ REQUEST Transcation"),UVM_LOW); end
finish_item(srio_trans_item);
	fork //{
	begin //{
        @(env_config.ll_config.ll_pkt_received);
        #20ns;
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET "),UVM_LOW);
	end //}
	begin //{
	#5000ns;
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET FAILED --- TIMEOUT OCCURED "),UVM_LOW);
	end //}
	join_any //}
	disable fork;
	read_data = env_config.srio_reg_model_rx.Data_Streaming_Logical_Layer_Control_CSR.get();
    read_data[31:24] = mtusize_0;
    read_data[7:0] = {4'b1110,4'b0000};
	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
   	srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.rdsize_0.constraint_mode(0);
	srio_trans_item.Ftype_8.constraint_mode(0);
	//Maintenance Write
	start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt =1;
	assert(srio_trans_item.randomize() with {
     ftype == 4'h8;
     ttype == 4'h1 ;
     rdsize ==4'h8 ;
     wrsize ==4'h8 ;
     wdptr ==1'b0 ;
     config_offset == 21'h48;});
     srio_trans_item.payload.push_back(read_data[31:24]);
     srio_trans_item.payload.push_back(read_data[23:16]);
     srio_trans_item.payload.push_back(read_data[15:8]);
     srio_trans_item.payload.push_back(read_data[7:0]);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.print();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE REQUEST Transcation"),UVM_LOW); end
       finish_item(srio_trans_item);
	#100ns;
//DS PACKET
  repeat(10)
   begin //{
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
      srio_trans_item.Ftype.constraint_mode(0);
      srio_trans_item.Ftype_9.constraint_mode(0);
	  srio_trans_item.Xh.constraint_mode(0);
      srio_trans_item.Ftype_9A.constraint_mode(0);
      srio_trans_item.streamid.constraint_mode(0);
      start_item(srio_trans_item);
      srio_trans_item.usr_gen_pkt =1;
      assert(srio_trans_item.randomize() with {ftype ==4'h9 ;cos == 0; P == 0 ;O == odd;xh==1'b0;streamID == 0;{S,E} == 2'b10;pdulength == pdulength_0;mtusize == mtusize_0;});
  if(inc)
       begin
      for(int i=0; i<((mtusize_0*4)+5); i++)
      begin
       srio_trans_item.payload.push_back(i);
      end
         `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "Expecting Payload Oversize Error"),UVM_LOW);
       end
    else
       begin
      for(int i=0; i<((mtusize_0*4)-5); i++)
      begin
       srio_trans_item.payload.push_back(i);
      end
         `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "Expecting Payload undersize Error"),UVM_LOW);
       end
      begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DS witn Incorrect Start and End segment"),UVM_LOW); end
	  srio_trans_item.print();
	  finish_item(srio_trans_item);
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
      srio_trans_item.Ftype.constraint_mode(0);
      srio_trans_item.Ftype_9.constraint_mode(0);
	  srio_trans_item.Xh.constraint_mode(0);
      srio_trans_item.Ftype_9A.constraint_mode(0);
      srio_trans_item.streamid.constraint_mode(0);
      start_item(srio_trans_item);
      srio_trans_item.usr_gen_pkt =1;
      assert(srio_trans_item.randomize() with {ftype ==4'h9 ;cos == 0; P == 0 ;O == odd;xh==1'b0;streamID == 0;{S,E} == 2'b01;pdulength == pdulength_0;mtusize == mtusize_0;});
      begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DS witn Incorrect Start and End segment"),UVM_LOW); end
         `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "Value of Payload before Corrupting is %0d",srio_trans_item.payload.size()),UVM_LOW);
   if(inc)
       begin
      for(int i=0; i<((mtusize_0*4)+5); i++)
      begin
       srio_trans_item.payload.push_back(i);
      end
         `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "Expecting Payload Oversize Error"),UVM_LOW);
       end
    else
       begin
      for(int i=0; i<((mtusize_0*4)-5); i++)
      begin
       srio_trans_item.payload.push_back(i);
      end
         `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "Expecting Payload undersize Error"),UVM_LOW);
       end
         `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "Value of Payload after Corrupting is %0d",srio_trans_item.payload.size()),UVM_LOW);
	  srio_trans_item.print();

	  finish_item(srio_trans_item);

	end //}

	wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
	#1000ns;
endtask 
endclass :srio_ll_ds_payload_size_err_base_seq

//=====DS WITH TRAFFIC MANAGAMENT  =======

class srio_ll_ds_traffic_base_seq extends srio_ll_base_seq;
  `uvm_object_utils(srio_ll_ds_traffic_base_seq)
  srio_trans srio_trans_item;

  
   rand bit [15:0] pdulength_0;
   rand bit [7:0] mtusize_0; 
   rand bit [31:0] read_data;
   rand bit [15:0] streamID_0;
   rand bit [7:0] cos_0;

   function new(string name="");
   super.new(name);
   endfunction

    virtual task body();
	
        	//Data streaming Packet

        srio_trans_item = srio_trans::type_id::create("srio_trans_item");

        srio_trans_item.Ftype_9.constraint_mode(0);
	srio_trans_item.Xh.constraint_mode(0);
        srio_trans_item.streamid.constraint_mode(0);
	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
       
	start_item(srio_trans_item);
        assert(srio_trans_item.randomize() with {
	ftype ==4'h9 ;
	xh==1'b0;
	mtusize == mtusize_0;
	pdulength ==pdulength_0 ;
        streamID ==streamID_0 ;
        cos == cos_0; 
	});
	srio_trans_item.print();

	begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DATA STREAMING REQUEST Transcation With STEAMID AND COS "),UVM_LOW); end

       finish_item(srio_trans_item);
       #100ns;	
endtask 
endclass :srio_ll_ds_traffic_base_seq
//======= TRAFFIC MANAGEMENT STREAM ALL SEQUENCE =======

class srio_ll_ds_traffic_mgmt_stream_base_seq extends srio_ll_base_seq;

`uvm_object_utils(srio_ll_ds_traffic_mgmt_stream_base_seq)

    srio_trans srio_trans_item;

    rand bit xh_0,rate ;
    rand bit [3:0] ftype_0,TMOP_0,tmop,tm_mode;
    rand bit [2:0] wild_card_0;
    rand bit [7:0] parameter1_0,parameter2_0,cos_0,mask_0;
    rand bit [31:0] read_data; 
    rand bit [15:0] streamID_0;
    rand bit [2:0] xtype_0;
    
    function new (string name="");
    super.new(name);
    endfunction

     virtual task body();

       //DS TM packet
        srio_trans_item = srio_trans::type_id::create("srio_trans_item");	
        srio_trans_item.Ftype.constraint_mode(0);
        srio_trans_item.Xh.constraint_mode(0);   
        srio_trans_item.traffic_mgt.constraint_mode(0); 
        srio_trans_item.traffic_parameter1.constraint_mode(0); 
        srio_trans_item.Ftype_9_TM_0.constraint_mode(0);
        srio_trans_item.streamid.constraint_mode(0);
        srio_trans_item.Ftype_9_Xtype.constraint_mode(0);
        srio_trans_item.Tmop.constraint_mode(0);
        srio_trans_item.Ftype_9_Xtype.constraint_mode(0);
        start_item(srio_trans_item);

	assert(srio_trans_item.randomize() with {ftype == ftype_0;xh==xh_0;xtype == xtype_0;TMOP == TMOP_0;wild_card == wild_card_0;parameter1==parameter1_0;parameter2==parameter2_0;cos == cos_0;streamID ==streamID_0;mask == mask_0; }); 
       
         begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DATA STREAMING TRAFFIC MANAGEMENT SEQUENCE ALL  Transcation"),UVM_LOW); end
         srio_trans_item.print();
         finish_item(srio_trans_item);
         #100ns;
  endtask

  endclass : srio_ll_ds_traffic_mgmt_stream_base_seq

//=====NORMAL DS WITH CORRUPTED DATA PAYLOAD SIZE =======

class srio_ll_normal_ds_payload_size_err_base_seq extends srio_ll_base_seq;
  `uvm_object_utils(srio_ll_normal_ds_payload_size_err_base_seq)
  srio_trans srio_trans_item;
   rand bit [15:0] pdulength_0;
   rand bit [7:0] mtusize_0; 
   rand bit [31:0] read_data;
   rand bit inc;
   rand bit odd;
 function new(string name="");
    super.new(name);
  endfunction
virtual task body();
    mtusize_0 = $urandom_range(32'd64,32'd8);
   `uvm_info("MTU SIZE VALUE",$sformatf("The randomized value of mtusize_0 is %0b",mtusize_0),UVM_LOW)
	pdulength_0 =$urandom_range(32'h0000_FFFF,32'h0000_0000);
    inc = $urandom;
    if (pdulength_0 % 2 > 0)
        pdulength_0 = pdulength_0+1;
    if ((pdulength_0 % 4 == 1) || (pdulength_0 % 4 == 2))
         odd = 0;
//DS PACKET
  repeat(10)
   begin //{
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
      srio_trans_item.Ftype.constraint_mode(0);
      srio_trans_item.Ftype_9.constraint_mode(0);
	  srio_trans_item.Xh.constraint_mode(0);
      srio_trans_item.Ftype_9A.constraint_mode(0);
      srio_trans_item.streamid.constraint_mode(0);
      start_item(srio_trans_item);
      srio_trans_item.usr_gen_pkt =1;
      assert(srio_trans_item.randomize() with {ftype ==4'h9 ;cos == 0; P == 0 ;O == odd;xh==1'b0;streamID == 0;{S,E} == 2'b10;pdulength == pdulength_0;mtusize == mtusize_0;});
  if(inc)
       begin
      for(int i=0; i<((mtusize_0*4)+5); i++)
      begin
       srio_trans_item.payload.push_back(i);
      end
         `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "Expecting Payload Oversize Error"),UVM_LOW);
       end
    else
       begin
      for(int i=0; i<((mtusize_0*4)-5); i++)
      begin
       srio_trans_item.payload.push_back(i);
      end
         `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "Expecting Payload undersize Error"),UVM_LOW);
       end
      begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DS witn Incorrect Start and End segment"),UVM_LOW); end
	  srio_trans_item.print();
	  finish_item(srio_trans_item);
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
      srio_trans_item.Ftype.constraint_mode(0);
      srio_trans_item.Ftype_9.constraint_mode(0);
	  srio_trans_item.Xh.constraint_mode(0);
      srio_trans_item.Ftype_9A.constraint_mode(0);
      srio_trans_item.streamid.constraint_mode(0);
      start_item(srio_trans_item);
      srio_trans_item.usr_gen_pkt =1;
      assert(srio_trans_item.randomize() with {ftype ==4'h9 ;cos == 0; P == 0 ;O == odd;xh==1'b0;streamID == 0;{S,E} == 2'b01;pdulength == pdulength_0;mtusize == mtusize_0;});
      begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DS witn Incorrect Start and End segment"),UVM_LOW); end
         `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "Value of Payload before Corrupting is %0d",srio_trans_item.payload.size()),UVM_LOW);
   if(inc)
       begin
      for(int i=0; i<((mtusize_0*4)+5); i++)
      begin
       srio_trans_item.payload.push_back(i);
      end
         `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "Expecting Payload Oversize Error"),UVM_LOW);
       end
    else
       begin
      for(int i=0; i<((mtusize_0*4)-5); i++)
      begin
       srio_trans_item.payload.push_back(i);
      end
         `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "Expecting Payload undersize Error"),UVM_LOW);
       end
         `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "Value of Payload after Corrupting is %0d",srio_trans_item.payload.size()),UVM_LOW);
	  srio_trans_item.print();

	  finish_item(srio_trans_item);

	end //}

	wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
	#1000ns;
endtask 
endclass :srio_ll_normal_ds_payload_size_err_base_seq

//======= TRAFFIC MANAGEMENT USER CREDIT STREAM  SEQUENCE =======

class srio_ll_ds_traffic_mgmt_user_credit_base_seq extends srio_ll_base_seq;

`uvm_object_utils(srio_ll_ds_traffic_mgmt_user_credit_base_seq)

    srio_trans srio_trans_item;

    rand bit xh_0,rate ;
    rand bit [3:0] ftype_0,TMOP_0,tmop,tm_mode;
    rand bit [2:0] wild_card_0;
    rand bit [7:0] parameter1_0,parameter2_0,cos_0,mask_0;
    rand bit [31:0] read_data; 
    rand bit [15:0] streamID_0;
    rand bit [2:0] xtype_0;
    
    function new (string name="");
    super.new(name);
    endfunction

     virtual task body();


        srio_trans_item = srio_trans::type_id::create("srio_trans_item");	
        srio_trans_item.Ftype.constraint_mode(0);
        srio_trans_item.Xh.constraint_mode(0);   
        srio_trans_item.traffic_mgt.constraint_mode(0); 
        srio_trans_item.traffic_parameter1.constraint_mode(0); 
        srio_trans_item.Ftype_9_TM_0.constraint_mode(0);
        srio_trans_item.streamid.constraint_mode(0);
        srio_trans_item.Ftype_9_Xtype.constraint_mode(0);
        srio_trans_item.Tmop.constraint_mode(0);
        srio_trans_item.Ftype_9_Xtype.constraint_mode(0);
        start_item(srio_trans_item);

	assert(srio_trans_item.randomize() with {ftype == ftype_0;xh==xh_0;xtype == xtype_0;TMOP == TMOP_0;wild_card == wild_card_0;parameter1==parameter1_0;parameter2==parameter2_0;cos == cos_0;streamID ==streamID_0;mask == mask_0; }); 
       
         begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DATA USER CREDIT STREAMING TRAFFIC MANAGEMENT SEQUENCE ALL  Transcation"),UVM_LOW); end
         srio_trans_item.print();
         finish_item(srio_trans_item);
         #100ns;
  endtask

  endclass : srio_ll_ds_traffic_mgmt_user_credit_base_seq
//======= TRAFFIC MANAGEMENT USER RATE STREAM  SEQUENCE =======

class srio_ll_ds_traffic_mgmt_user_rate_base_seq extends srio_ll_base_seq;

`uvm_object_utils(srio_ll_ds_traffic_mgmt_user_rate_base_seq)

    srio_trans srio_trans_item;

    rand bit xh_0,rate ;
    rand bit [3:0] ftype_0,TMOP_0,tmop,tm_mode;
    rand bit [2:0] wild_card_0;
    rand bit [7:0] parameter1_0,parameter2_0,cos_0,mask_0;
    rand bit [31:0] read_data; 
    rand bit [15:0] streamID_0;
    rand bit [2:0] xtype_0;
    
    function new (string name="");
    super.new(name);
    endfunction

     virtual task body();

       // DS Packet	
        srio_trans_item = srio_trans::type_id::create("srio_trans_item");	
        srio_trans_item.Ftype.constraint_mode(0);
        srio_trans_item.Xh.constraint_mode(0);   
        srio_trans_item.traffic_mgt.constraint_mode(0); 
        srio_trans_item.traffic_parameter1.constraint_mode(0); 
        srio_trans_item.Ftype_9_TM_0.constraint_mode(0);
        srio_trans_item.streamid.constraint_mode(0);
        srio_trans_item.Ftype_9_Xtype.constraint_mode(0);
        srio_trans_item.Tmop.constraint_mode(0);
        srio_trans_item.Ftype_9_Xtype.constraint_mode(0);
        start_item(srio_trans_item);

	assert(srio_trans_item.randomize() with {ftype == ftype_0;xh==xh_0;xtype == xtype_0;TMOP == TMOP_0;wild_card == wild_card_0;parameter1==parameter1_0;parameter2==parameter2_0;cos == cos_0;streamID ==streamID_0;mask == mask_0; }); 
       
         begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DATA USER RATE STREAMING TRAFFIC MANAGEMENT SEQUENCE ALL  Transcation"),UVM_LOW); end
         srio_trans_item.print();
         finish_item(srio_trans_item);
        #100ns;
  endtask

  endclass : srio_ll_ds_traffic_mgmt_user_rate_base_seq


//====DEFAULT SEQUENCE for random FTYPE ====

class srio_ll_ftype_default_class_seq extends srio_ll_base_seq;
    `uvm_object_utils(srio_ll_ftype_default_class_seq)

    rand bit [7:0] mtusize_0;
    rand bit [31:0] read_data;
    rand bit [2:0] mode ;
    rand bit [3:0] tm_mode ;
    rand bit [15:0] pdulength_0;
    rand bit sel;
   rand bit [3:0] TMmode;
    srio_trans srio_trans_item;
 
  function new(string name="");
    super.new(name);
  endfunction

  virtual task body();

	
	//pdulength_0 =$urandom_range(32'h0000_FFFF,32'h0000_0000);
      	srio_trans_item = srio_trans::type_id::create("srio_trans_item");

	
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
     	srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.rdsize_0.constraint_mode(0);
	srio_trans_item.Ftype_8.constraint_mode(0);

    // Maintenance Read 
        start_item(srio_trans_item);
       srio_trans_item.usr_gen_pkt =1;
	assert(srio_trans_item.randomize() with {
     ftype == 4'h8;
     ttype == 4'h0 ;
     rdsize ==4'h8 ;
     wrsize ==4'h8 ;
     wdptr ==1'b0 ;
     config_offset == 21'h48;});

	srio_trans_item.print();

        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE READ REQUEST Transcation"),UVM_LOW); end
finish_item(srio_trans_item);

		fork //{
	begin //{
        @(env_config.ll_config.ll_pkt_received);
        #20ns;
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET "),UVM_LOW);
	end //}
	begin //{
	#5000ns;
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET FAILED --- TIMEOUT OCCURED "),UVM_LOW);
	end //}
	join_any //}
	disable fork;

	read_data = env_config.srio_reg_model_rx.Data_Streaming_Logical_Layer_Control_CSR.get();

 	mtusize_0 = $urandom_range(32'd64,32'd8);
 	pdulength_0 = $urandom_range(32'h0000_0FFF,mtusize_0*4);
	mode = $urandom_range(32'd3,32'd0);
	sel = $urandom;
        case(mode) //{
	3'd0:begin tm_mode = 4'b0001; TMmode = 4'h0;end
	3'd1:begin tm_mode = 4'b0010; TMmode = 4'h1;end
	3'd2:begin tm_mode = 4'b0011; TMmode = 4'h2;end
	3'd3:begin tm_mode = 4'b0100; TMmode = (sel == 1'b1) ? 4'h2 :4'h1; end 

	endcase //}
	read_data[7:0]  = {4'b1110,tm_mode};;
        read_data[15:8] = 8'b0;
        read_data[23:16] = 8'b0;
        read_data[31:24] = mtusize_0;
	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
    srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.rdsize_0.constraint_mode(0);
	srio_trans_item.Ftype_8.constraint_mode(0);
	

	//Maintenance Write
	start_item(srio_trans_item);
       srio_trans_item.usr_gen_pkt =1;
	assert(srio_trans_item.randomize() with {
     ftype == 4'h8;
     ttype == 4'h1 ;
     rdsize ==4'h8 ;
     wrsize ==4'h8 ;
     wdptr ==1'b0 ;
     config_offset == 21'h48;});

     srio_trans_item.payload.push_back(read_data[31:24]);
     srio_trans_item.payload.push_back(read_data[23:16]);
     srio_trans_item.payload.push_back(read_data[15:8]);
     srio_trans_item.payload.push_back(read_data[7:0]);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);

     srio_trans_item.print();
	
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE REQUEST Transcation"),UVM_LOW); end

       finish_item(srio_trans_item);

	#100ns;

        read_data = env_config.srio_reg_model_rx.Data_Streaming_Logical_Layer_Control_CSR.get();
    for(int i = 0;i<16;i++)
      for(int j = 0;j<16;j++)
        begin //{
     
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
      srio_trans_item.Ftype.constraint_mode(0);
      srio_trans_item.Ttype.constraint_mode(0);
      srio_trans_item.Tmop.constraint_mode(0);
        start_item(srio_trans_item);
      assert(srio_trans_item.randomize() with {ftype == i;ttype == j; TMOP == TMmode;});
            srio_trans_item.print();
      finish_item(srio_trans_item);
      #100ns;
	end //}
   endtask

endclass :srio_ll_ftype_default_class_seq 

//=====DS FOR LFC ARBITRATION SINGLE PDU =======

class srio_ll_lfc_ds_single_pdu_arb_base_seq extends srio_ll_base_seq;
  `uvm_object_utils(srio_ll_lfc_ds_single_pdu_arb_base_seq)
  srio_trans srio_trans_item;

   rand bit [15:0] pdulength_0;
   rand bit [7:0] mtusize_0; 
   rand bit [1:0] prio_0;
   rand bit crf_0;
   function new(string name="");
    super.new(name);
    endfunction

virtual task body();
	
	//Data streaming Packet
        srio_trans_item = srio_trans::type_id::create("srio_trans_item");
        srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ftype_9.constraint_mode(0);
	srio_trans_item.Xh.constraint_mode(0);
        srio_trans_item.prior.constraint_mode(0);
        srio_trans_item.Crf.constraint_mode(0);

	       
	start_item(srio_trans_item);
        assert(srio_trans_item.randomize() with {
	ftype ==4'h9 ;
	xh==1'b0;
	mtusize == mtusize_0;
	pdulength ==pdulength_0 ;
        prio == prio_0;
        crf == crf_0;
	});
	srio_trans_item.print();

	begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DATA STREAMING REQUEST Transcation"),UVM_LOW); end

       finish_item(srio_trans_item);
	#100ns;	
		
endtask 
endclass :srio_ll_lfc_ds_single_pdu_arb_base_seq
//=====DS FOR LFC ARBITRATION MULTI PDU =======

class srio_ll_lfc_ds_multi_pdu_arb_base_seq extends srio_ll_base_seq;
  `uvm_object_utils(srio_ll_lfc_ds_multi_pdu_arb_base_seq)
  srio_trans srio_trans_item;
 
   rand bit [15:0] pdulength_0;
   rand bit [7:0] mtusize_0; 
   rand bit [1:0] prio_0;
   rand bit crf_0;

   function new(string name="");
    super.new(name);
   endfunction

virtual task body();
	
   	//Data streaming Packet
        srio_trans_item = srio_trans::type_id::create("srio_trans_item");
        srio_trans_item.Ftype.constraint_mode(0);
        srio_trans_item.Ftype_9.constraint_mode(0);
	srio_trans_item.Xh.constraint_mode(0);
        srio_trans_item.prior.constraint_mode(0);
        srio_trans_item.Crf.constraint_mode(0);
	       
	start_item(srio_trans_item);
        assert(srio_trans_item.randomize() with {
	ftype ==4'h9 ;
	xh==1'b0;
	mtusize == mtusize_0;
	pdulength ==pdulength_0 ;
        prio == prio_0;
        crf == crf_0;
	});
	srio_trans_item.print();

	begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DATA STREAMING REQUEST Transcation"),UVM_LOW); end

       finish_item(srio_trans_item);
       #100ns;	
endtask 
endclass :srio_ll_lfc_ds_multi_pdu_arb_base_seq

// FLOW ARBITRATION SUPPORT REGISTER SEQUENCE

class srio_ll_flow_arb_support_reg_base_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_flow_arb_support_reg_base_seq)

  srio_trans srio_trans_item;
 
   rand bit [31:0] read_data;

 function new(string name="");
    super.new(name);
  endfunction

virtual task body();
	
        
      	srio_trans_item = srio_trans::type_id::create("srio_trans_item");

	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
     	srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.rdsize_0.constraint_mode(0);
	srio_trans_item.Ftype_8.constraint_mode(0);
	

    // Maintenance Read 
        start_item(srio_trans_item);
       srio_trans_item.usr_gen_pkt =1;
	assert(srio_trans_item.randomize() with {
     ftype == 4'h8;
     ttype == 4'h0 ;
     rdsize ==4'h8 ;
     wrsize ==4'h8 ;
     wdptr ==1'b0 ;
     config_offset == 21'h10;});

	srio_trans_item.print();

        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE READ REQUEST Transcation"),UVM_LOW); end
finish_item(srio_trans_item);

		fork //{
	begin //{
        @(env_config.ll_config.ll_pkt_received);
        #20ns;
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET "),UVM_LOW);
	end //}
	begin //{
	#5000ns;
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET FAILED --- TIMEOUT OCCURED "),UVM_LOW);
	end //}
	join_any //}
	disable fork;

	read_data = env_config.srio_reg_model_rx.Processing_Element_Features_CAR.Flow_Arbitration_Support.get();
	

        //read_data[20] = 1'b1;////$urandom_range(32'd1000,32'd100);
 read_data = 32'h0000_0800;
	
	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
     	srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.rdsize_0.constraint_mode(0);
	srio_trans_item.Ftype_8.constraint_mode(0);
	

	//Maintenance Write For Port Response Timeout Register
	start_item(srio_trans_item);
       srio_trans_item.usr_gen_pkt =1;
	assert(srio_trans_item.randomize() with {
     ftype == 4'h8;
     ttype == 4'h1 ;
     rdsize ==4'h8 ;
     wrsize ==4'h8 ;
     wdptr ==1'b0 ;
     config_offset == 21'h10;});

     srio_trans_item.payload.push_back(read_data[31:24]);
     srio_trans_item.payload.push_back(read_data[23:16]);
     srio_trans_item.payload.push_back(read_data[15:8]);
     srio_trans_item.payload.push_back(read_data[7:0]);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);

     srio_trans_item.print();
	
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE REQUEST FOR FLOW ARBITRATION REGISTER Transcation"),UVM_LOW); end

       finish_item(srio_trans_item);
void'(env_config.srio_reg_model_rx.Processing_Element_Features_CAR.Flow_Arbitration_Support.predict(1'b1));
         void'(env_config.srio_reg_model_tx.Processing_Element_Features_CAR.Flow_Arbitration_Support.predict(1'b1));


	#50ns;
	read_data = env_config.srio_reg_model_rx.Processing_Element_Features_CAR.Flow_Arbitration_Support.get();
        
	endtask
endclass :srio_ll_flow_arb_support_reg_base_seq


//======= TRAFFIC MANAGEMENT TM TYPE ERROR SEQUENCE =======

class srio_ll_traffic_mgmt_tm_type_mode_seq extends srio_ll_base_seq;

`uvm_object_utils(srio_ll_traffic_mgmt_tm_type_mode_seq)
    srio_trans srio_trans_item;
     rand bit [3:0] ftype_0;
     rand bit xh_0 ;
     rand bit [3:0]TMOP_0;
     rand bit [31:0] read_data; 
     rand bit [3:0] tm_mode;
     rand bit [3:0] TMmode;
     rand bit [2:0] invalid;
     rand bit [3:0] invalid1;

   function new (string name="");
    super.new(name);
    endfunction

virtual task body();
	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
   	srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.rdsize_0.constraint_mode(0);
	srio_trans_item.Ftype_8.constraint_mode(0);
	// Maintenance Read 
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt =1;
	assert(srio_trans_item.randomize() with {
     ftype == 4'h8;
     ttype == 4'h0 ;
     rdsize ==4'h8 ;
     wrsize ==4'h8 ;
     wdptr ==1'b0 ;
     config_offset == 21'h48;});
	 srio_trans_item.print();
     begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE READ REQUEST Transcation"),UVM_LOW); end
     finish_item(srio_trans_item);
    fork //{
	begin //{
        @(env_config.ll_config.ll_pkt_received);
        #20ns;
	 `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET "),UVM_LOW);
	end //}
	begin //{
	#5000ns;
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET FAILED --- TIMEOUT OCCURED "),UVM_LOW);
	end //}
	join_any //}
disable fork;

	read_data = env_config.srio_reg_model_rx.Data_Streaming_Logical_Layer_Control_CSR.get();
    	invalid = $urandom;
        invalid1 = $urandom_range(32'd7,32'd5);
        read_data[7:0]  = {invalid,1'b1,invalid1};
        read_data[15:8] = 8'b0;
    	read_data[23:16] = 8'b0;
	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
   	srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.rdsize_0.constraint_mode(0);
	srio_trans_item.Ftype_8.constraint_mode(0);
	//Maintenance Write
	start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt =1;
	assert(srio_trans_item.randomize() with {
     ftype == 4'h8;
     ttype == 4'h1 ;
     rdsize ==4'h8 ;
     wrsize ==4'h8 ;
     wdptr ==1'b0 ;
     config_offset == 21'h48;});
     srio_trans_item.payload.push_back(read_data[31:24]);
     srio_trans_item.payload.push_back(read_data[23:16]);
     srio_trans_item.payload.push_back(read_data[15:8]);
     srio_trans_item.payload.push_back(read_data[7:0]);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.print();
       begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE REQUEST Transcation"),UVM_LOW); end
       finish_item(srio_trans_item);
      #100ns;
      read_data = env_config.srio_reg_model_rx.Data_Streaming_Logical_Layer_Control_CSR.get();
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");	
      srio_trans_item.Ftype.constraint_mode(0);
      srio_trans_item.Xh.constraint_mode(0);  
      srio_trans_item.Tmop.constraint_mode(0);    
      start_item(srio_trans_item);

	assert(srio_trans_item.randomize() with {ftype == ftype_0;xh==xh_0;TMOP == TMmode;}); 
       
         begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DATA STREAMING TRAFFIC MANAGEMENT TM TYPE & MODE ERROR SEQUENCE Transcation"),UVM_LOW); end
         srio_trans_item.print();
         finish_item(srio_trans_item);
  endtask

  endclass : srio_ll_traffic_mgmt_tm_type_mode_seq
//======= TRAFFIC MANAGEMENT various operation SEQUENCE =======

class srio_ll_ds_traffic_mgmt_various_operation_base_seq extends srio_ll_base_seq;

`uvm_object_utils(srio_ll_ds_traffic_mgmt_various_operation_base_seq)

    srio_trans srio_trans_item;

    rand bit xh_0,rate ;
    rand bit [3:0] ftype_0,TMOP_0,tmop,tm_mode;
    rand bit [2:0] wild_card_0;
    rand bit [7:0] parameter1_0,parameter2_0,cos_0,mask_0;
    rand bit [31:0] read_data; 
    rand bit [15:0] streamID_0;
    rand bit [2:0] xtype_0;
    rand bit [2:0] mode ;
    rand bit sel;
    bit [3:0] tm_mode1;

    function new (string name="");
    super.new(name);
    endfunction

     virtual task body();


	srio_trans_item = srio_trans::type_id::create("srio_trans_item");

	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
     	srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.rdsize_0.constraint_mode(0);
	srio_trans_item.Ftype_8.constraint_mode(0);

		// Maintenance Read 
        start_item(srio_trans_item);
       srio_trans_item.usr_gen_pkt =1;
	assert(srio_trans_item.randomize() with {
     ftype == 4'h8;
     ttype == 4'h0 ;
     rdsize ==4'h8 ;
     wrsize ==4'h8 ;
     wdptr ==1'b0 ;
     config_offset == 21'h48;});

	srio_trans_item.print();

        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE READ REQUEST Transcation"),UVM_LOW); end
finish_item(srio_trans_item);

		
	fork //{
	begin //{
	wait(env_config.ll_config.tx_mon_tot_pkt_rcvd > 0);
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET "),UVM_LOW);
	end //}
	begin //{
	#25000ns;
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET FAILED --- TIMEOUT OCCURED "),UVM_LOW);
	end //}

	join_any //}
disable fork;

	read_data = env_config.srio_reg_model_rx.Data_Streaming_Logical_Layer_Control_CSR.get();

	mode = $urandom_range(32'd3,32'd0);
	sel = $urandom;
        case(TMOP_0) //{
	3'd0:begin tm_mode = 4'b0001; TMOP_0 = 4'h0;end
	3'd1:begin tm_mode = 4'b0010; TMOP_0 = 4'h1;end
	3'd2:begin tm_mode = 4'b0011; TMOP_0 = 4'h2;end
	3'd3:begin tm_mode = 4'b0100; TMOP_0 = (sel == 1'b1) ? 4'h2 :4'h1; end 

	endcase //}
	read_data[7:0]  = {4'b1110,tm_mode};
        read_data[15:8] = 8'b0;
	read_data[23:16] = 8'b0;

	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
     	srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.rdsize_0.constraint_mode(0);
	srio_trans_item.Ftype_8.constraint_mode(0);
	

	//Maintenance Write
	start_item(srio_trans_item);
       srio_trans_item.usr_gen_pkt =1;
	assert(srio_trans_item.randomize() with {
     ftype == 4'h8;
     ttype == 4'h1 ;
     rdsize ==4'h8 ;
     wrsize ==4'h8 ;
     wdptr ==1'b0 ;
     config_offset == 21'h48;});

     srio_trans_item.payload.push_back(read_data[31:24]);
     srio_trans_item.payload.push_back(read_data[23:16]);
     srio_trans_item.payload.push_back(read_data[15:8]);
     srio_trans_item.payload.push_back(read_data[7:0]);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);

     srio_trans_item.print();
	
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE REQUEST Transcation"),UVM_LOW); end

       finish_item(srio_trans_item);

	#100ns;
      
             tm_mode1[3] = tm_mode[0];
             tm_mode1[2] = tm_mode[1];
             tm_mode1[1] = tm_mode[2]; 
             tm_mode1[0] = tm_mode[3];

        read_data = env_config.srio_reg_model_rx.Data_Streaming_Logical_Layer_Control_CSR.get();
         void'(env_config.srio_reg_model_rx.Data_Streaming_Logical_Layer_Control_CSR.TM_Mode.predict(tm_mode1));
         void'(env_config.srio_reg_model_tx.Data_Streaming_Logical_Layer_Control_CSR.TM_Mode.predict(tm_mode1));
         void'(env_config.srio_reg_model_rx.Data_Streaming_Logical_Layer_Control_CSR.TM_Types_Supported.predict(4'b0111));
         void'(env_config.srio_reg_model_tx.Data_Streaming_Logical_Layer_Control_CSR.TM_Types_Supported.predict(4'b0111));        
	wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);

        srio_trans_item = srio_trans::type_id::create("srio_trans_item");	
        srio_trans_item.Ftype.constraint_mode(0);
        srio_trans_item.Xh.constraint_mode(0);   
        srio_trans_item.traffic_mgt.constraint_mode(0); 
        srio_trans_item.traffic_parameter1.constraint_mode(0); 
        srio_trans_item.Ftype_9_TM_0.constraint_mode(0);
        srio_trans_item.streamid.constraint_mode(0);
        srio_trans_item.Ftype_9_Xtype.constraint_mode(0);
        srio_trans_item.Tmop.constraint_mode(0);
        srio_trans_item.Ftype_9_Xtype.constraint_mode(0);
        start_item(srio_trans_item);

	assert(srio_trans_item.randomize() with {ftype == ftype_0;xh==xh_0;xtype == xtype_0;TMOP == TMOP_0;wild_card == wild_card_0;parameter1==parameter1_0;parameter2==parameter2_0;cos == cos_0;streamID ==streamID_0;mask == mask_0; }); 
       
         begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DATA STREAMING TRAFFIC MANAGEMENT SEQUENCE ALL  Transcation"),UVM_LOW); end
         srio_trans_item.print();
         finish_item(srio_trans_item);
  endtask

  endclass : srio_ll_ds_traffic_mgmt_various_operation_base_seq

//======= TRAFFIC MANAGEMENT different operation SEQUENCE =======

class srio_ll_ds_traffic_mgmt_diff_operation_base_seq extends srio_ll_base_seq;

`uvm_object_utils(srio_ll_ds_traffic_mgmt_diff_operation_base_seq)

    srio_trans srio_trans_item;

    rand bit xh_0,rate ;
    rand bit [3:0] ftype_0,TMOP_0,tmop,tm_mode;
    rand bit [2:0] wild_card_0;
    rand bit [7:0] parameter1_0,parameter2_0,cos_0,mask_0;
    rand bit [31:0] read_data; 
    rand bit [15:0] streamID_0;
    rand bit [2:0] xtype_0;
    rand bit [2:0] mode ;
    rand bit sel;
    bit [3:0] tm_mode1;

    function new (string name="");
    super.new(name);
    endfunction

     virtual task body();
	    srio_trans_item = srio_trans::type_id::create("srio_trans_item");
        srio_trans_item = srio_trans::type_id::create("srio_trans_item");	
        srio_trans_item.Ftype.constraint_mode(0);
        srio_trans_item.Xh.constraint_mode(0);   
        srio_trans_item.traffic_mgt.constraint_mode(0); 
        srio_trans_item.traffic_parameter1.constraint_mode(0); 
        srio_trans_item.Ftype_9_TM_0.constraint_mode(0);
        srio_trans_item.streamid.constraint_mode(0);
        srio_trans_item.Ftype_9_Xtype.constraint_mode(0);
        srio_trans_item.Tmop.constraint_mode(0);
        srio_trans_item.Ftype_9_Xtype.constraint_mode(0);
        start_item(srio_trans_item);

	assert(srio_trans_item.randomize() with {ftype == ftype_0;xh==xh_0;xtype == xtype_0;TMOP == TMOP_0;wild_card == wild_card_0;parameter1==parameter1_0;parameter2==parameter2_0;cos == cos_0;streamID ==streamID_0;mask == mask_0; }); 
       
         begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DATA STREAMING TRAFFIC MANAGEMENT SEQUENCE ALL  Transcation"),UVM_LOW); end
         srio_trans_item.print();
         finish_item(srio_trans_item);
         #100ns;

  endtask

  endclass : srio_ll_ds_traffic_mgmt_diff_operation_base_seq


//======= TRAFFIC MANAGEMENT ERROR CREDIT SEQUENCE   =======

class srio_ll_ds_traffic_mgmt_credit_err_seq extends srio_ll_base_seq;

`uvm_object_utils(srio_ll_ds_traffic_mgmt_credit_err_seq)

    srio_trans srio_trans_item;

    rand bit xh_0,rate ;
    rand bit [3:0] ftype_0,TMOP_0,tmop,tm_mode;
    rand bit [2:0] wild_card_0;
    rand bit [7:0] parameter1_0,parameter2_0,cos_0,mask_0;
    rand bit [31:0] read_data; 
    rand bit [15:0] streamID_0;
    rand bit [2:0] xtype_0;
    
    function new (string name="");
    super.new(name);
    endfunction

     virtual task body();


	srio_trans_item = srio_trans::type_id::create("srio_trans_item");

	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
     	srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.rdsize_0.constraint_mode(0);
	srio_trans_item.Ftype_8.constraint_mode(0);

		// Maintenance Read 
        start_item(srio_trans_item);
       srio_trans_item.usr_gen_pkt =1;
	assert(srio_trans_item.randomize() with {
     ftype == 4'h8;
     ttype == 4'h0 ;
     rdsize ==4'h8 ;
     wrsize ==4'h8 ;
     wdptr ==1'b0 ;
     config_offset == 21'h48;});

	srio_trans_item.print();

        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE READ REQUEST Transcation"),UVM_LOW); end
finish_item(srio_trans_item);

		
	fork //{
	begin //{
        @(env_config.ll_config.ll_pkt_received);
        #20ns;
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET "),UVM_LOW);
	end //}
	begin //{
	#5000ns;
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET FAILED --- TIMEOUT OCCURED "),UVM_LOW);
	end //}

	join_any //}
disable fork;

	read_data = env_config.srio_reg_model_rx.Data_Streaming_Logical_Layer_Control_CSR.get();
    read_data[7:0]  = {4'b1110,4'b0011};
    read_data[15:8] = 8'b0;
	read_data[23:16] = 8'b0;

	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
  	srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.rdsize_0.constraint_mode(0);
	srio_trans_item.Ftype_8.constraint_mode(0);
	//Maintenance Write
	start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt =1;
	assert(srio_trans_item.randomize() with {
     ftype == 4'h8;
     ttype == 4'h1 ;
     rdsize ==4'h8 ;
     wrsize ==4'h8 ;
     wdptr ==1'b0 ;
     config_offset == 21'h48;});

     srio_trans_item.payload.push_back(read_data[31:24]);
     srio_trans_item.payload.push_back(read_data[23:16]);
     srio_trans_item.payload.push_back(read_data[15:8]);
     srio_trans_item.payload.push_back(read_data[7:0]);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);

     srio_trans_item.print();
	
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE REQUEST Transcation"),UVM_LOW); end

       finish_item(srio_trans_item);

	#100ns;
	wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);

        srio_trans_item = srio_trans::type_id::create("srio_trans_item");	
        srio_trans_item.Ftype.constraint_mode(0);
        srio_trans_item.Xh.constraint_mode(0);   
        srio_trans_item.traffic_mgt.constraint_mode(0); 
        srio_trans_item.traffic_parameter1.constraint_mode(0); 
        srio_trans_item.Ftype_9_TM_0.constraint_mode(0);
        srio_trans_item.streamid.constraint_mode(0);
        srio_trans_item.Ftype_9_Xtype.constraint_mode(0);
        srio_trans_item.Tmop.constraint_mode(0);
        srio_trans_item.Ftype_9_Xtype.constraint_mode(0);
        start_item(srio_trans_item);

	assert(srio_trans_item.randomize() with {ftype == ftype_0;xh==xh_0;xtype == xtype_0;TMOP == TMOP_0;wild_card == wild_card_0;parameter1==parameter1_0;parameter2==parameter2_0;cos == cos_0;streamID ==streamID_0;mask == mask_0; }); 
       
         begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DATA USER CREDIT STREAMING TRAFFIC MANAGEMENT SEQUENCE ALL  Transcation"),UVM_LOW); end
         srio_trans_item.print();
         finish_item(srio_trans_item);
  endtask

  endclass : srio_ll_ds_traffic_mgmt_credit_err_seq


//DS MULTI SEGEMENT AND SINGLE MTU WITH DEFINED PRIORITY AND CRF FOR LFC SEQUENCES

 class srio_ll_lfc_ds_base_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_lfc_ds_base_seq)

  srio_trans srio_trans_item;

    rand bit [3:0] ftype_0;
    rand bit xh_0 ;
     rand bit [15:0] pdulength_0;
     rand bit [7:0] mtusize_0; 
     rand bit [31:0] read_data;     
     rand bit [1:0] prio_0;
     rand bit crf_0;
function new(string name="");
    super.new(name);
  endfunction

  virtual task body();

 	mtusize_0 = $urandom_range(32'd64,32'd8);
 	pdulength_0 = $urandom_range(32'h0000_0FFF,mtusize_0*4);
	srio_trans_item = srio_trans::type_id::create("srio_trans_item");

	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
     	srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.rdsize_0.constraint_mode(0);
	srio_trans_item.Ftype_8.constraint_mode(0);
	// Maintenance Read 
        start_item(srio_trans_item);
       srio_trans_item.usr_gen_pkt =1;
	assert(srio_trans_item.randomize() with {
     ftype == 4'h8;
     ttype == 4'h0 ;
     rdsize ==4'h8 ;
     wrsize ==4'h8 ;
     wdptr ==1'b0 ;
     config_offset == 21'h48;});

	srio_trans_item.print();

        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE READ REQUEST Transcation"),UVM_LOW); end
finish_item(srio_trans_item);

	fork //{
	begin //{
        @(env_config.ll_config.ll_pkt_received);
        #20ns;
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET "),UVM_LOW);
	end //}
	begin //{
	#5000ns;
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET FAILED --- TIMEOUT OCCURED "),UVM_LOW);
	end //}
	join_any //}
disable fork;

	read_data = env_config.srio_reg_model_rx.Data_Streaming_Logical_Layer_Control_CSR.get();
    read_data[7:0] = {4'b1110,4'b0000};
    read_data[31:24] = mtusize_0;
	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
   	srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.rdsize_0.constraint_mode(0);
	srio_trans_item.Ftype_8.constraint_mode(0);
	//Maintenance Write
	start_item(srio_trans_item);
       srio_trans_item.usr_gen_pkt =1;
	assert(srio_trans_item.randomize() with {
     ftype == 4'h8;
     ttype == 4'h1 ;
     rdsize ==4'h8 ;
     wrsize ==4'h8 ;
     wdptr ==1'b0 ;
     config_offset == 21'h48;});
     srio_trans_item.payload.push_back(read_data[31:24]);
     srio_trans_item.payload.push_back(read_data[23:16]);
     srio_trans_item.payload.push_back(read_data[15:8]);
     srio_trans_item.payload.push_back(read_data[7:0]);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);

     srio_trans_item.print();
	
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE REQUEST Transcation"),UVM_LOW); end

       finish_item(srio_trans_item);

	#100ns;

        read_data = env_config.srio_reg_model_rx.Data_Streaming_Logical_Layer_Control_CSR.get();
       
///DS PACKET

	repeat(5) begin //{
        srio_trans_item = srio_trans::type_id::create("srio_trans_item");
        srio_trans_item.Ftype.constraint_mode(0);
	    srio_trans_item.Ftype_9.constraint_mode(0);
	    srio_trans_item.Xh.constraint_mode(0);
	    srio_trans_item.prior.constraint_mode(0);
        srio_trans_item.Crf.constraint_mode(0);

            start_item(srio_trans_item);

      assert(srio_trans_item.randomize() with {ftype ==4'h9 ;xh==1'b0;pdulength == pdulength_0;mtusize == mtusize_0;prio == prio_0;crf == crf_0;});
      begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DS MULTI SEGMENT -- WITH DEFINED PRIORITY AND CRF FOR LFC CASE"),UVM_LOW); end

             
		srio_trans_item.print();
	         finish_item(srio_trans_item);
	end //}

  endtask
endclass :srio_ll_lfc_ds_base_seq
//================NWRITE_R and NREAD_R  SEQUENCE FOR 34 BIT ADDRESSING ============

class srio_ll_nwrite_nread_34_addr_base_seq extends srio_ll_base_seq;
  `uvm_object_utils(srio_ll_nwrite_nread_34_addr_base_seq)
  srio_trans srio_trans_item;

  logic [3:0] ttype_0;
  logic [3:0] ftype_0;
  logic wdptr_0;        
  logic [3:0] wrsize_1;  
  logic [3:0] rdsize_1;
  logic [20:0] config_offset_0 ;
  logic [7:0] targetID_Info_0;
  logic [29:0] address_0;
  logic [31:0] write_data;
  logic [31:0] read1_data;
  logic [31:0] read2_data;
  logic [7:0] expected_payload[$];
  logic [31:0] expected_write;
  logic [31:0] expected_write1;
  logic [13:0] g;
function new(string name="");
    super.new(name);
  endfunction

task byte_reverse(input logic [31:0] a);
  logic [7:0] b,c,d,e;
  b  = {a[24],a[25],a[26],a[27],a[28],a[29],a[30],a[31]};
  c  = {a[16],a[17],a[18],a[19],a[20],a[21],a[22],a[23]};
  d  = {a[8],a[9],a[10],a[11],a[12],a[13],a[14],a[15]};
  e  = {a[0],a[1],a[2],a[3],a[4],a[5],a[6],a[7]};
  expected_write1 = {b,c,d,e};
endtask

  virtual task body();
		
    srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
    srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.rdsize_0.constraint_mode(0);
	srio_trans_item.Ftype_8.constraint_mode(0);
	
    srio_reg_model.Processing_Element_Logical_Layer_Control_CSR.Extended_addressing_control.set(3'b100);

      //Data_Streaming_Logical_Layer_Control_CSR
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype == 4'h5 ;
     ttype == 4'h5 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     address == address_0;
     xamsbs == 0;
     });
     for(int i=0; i<8; i++)
       begin
       srio_trans_item.payload.push_back(i);
          expected_payload.push_back(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "NWRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Data_Streaming_Logical_Layer_Control_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
    assert(srio_trans_item.randomize() with {
     ftype ==2 ;
     ttype == 4 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     address == address_0;
     xamsbs == 0;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Data_Streaming_Logical_Layer_Control_CSR.get();
            `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);             
             `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if({write_data[31:24],write_data[7:4]} == {expected_write1[31:24],expected_write1[7:4]})
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")

        `uvm_info("RW Data_Streaming_Logical_Layer_Control_CSR",$sformatf("After first write 'h48 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Data_Streaming_Logical_Layer_Control_CSR",$sformatf("After first read 'h48 read1_data = %h", read1_data),UVM_LOW);       
       if({write_data[31:24],write_data[7:4]} != {read1_data[31:24],read1_data[7:4]})
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

endtask

endclass : srio_ll_nwrite_nread_34_addr_base_seq

//================NWRITE_R and NREAD_R  SEQUENCE FOR 50 BIT ADDRESSING ============

class srio_ll_nwrite_nread_50_addr_base_seq extends srio_ll_base_seq;
  `uvm_object_utils(srio_ll_nwrite_nread_50_addr_base_seq)
  srio_trans srio_trans_item;

  logic [3:0] ttype_0;
  logic [3:0] ftype_0;
  logic wdptr_0;        
  logic [3:0] wrsize_1;  
  logic [3:0] rdsize_1;
  logic [20:0] config_offset_0 ;
  logic [7:0] targetID_Info_0;
  logic [29:0] address_0;
  logic [31:0] write_data;
  logic [31:0] read1_data;
  logic [31:0] read2_data;
  logic [7:0] expected_payload[$];
  logic [31:0] expected_write;
  logic [31:0] expected_write1;
  logic [13:0] g;
function new(string name="");
    super.new(name);
  endfunction

task byte_reverse(input logic [31:0] a);
  logic [7:0] b,c,d,e;
  b  = {a[24],a[25],a[26],a[27],a[28],a[29],a[30],a[31]};
  c  = {a[16],a[17],a[18],a[19],a[20],a[21],a[22],a[23]};
  d  = {a[8],a[9],a[10],a[11],a[12],a[13],a[14],a[15]};
  e  = {a[0],a[1],a[2],a[3],a[4],a[5],a[6],a[7]};
  expected_write1 = {b,c,d,e};
endtask

  virtual task body();
		
    srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
    srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.rdsize_0.constraint_mode(0);
	srio_trans_item.Ftype_8.constraint_mode(0);
	
    srio_reg_model.Processing_Element_Logical_Layer_Control_CSR.Extended_addressing_control.set(3'b010);
      //Data_Streaming_Logical_Layer_Control_CSR
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype == 4'h5 ;
     ttype == 4'h5 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     address == address_0;
     ext_address == 0;
     xamsbs == 0;
     });
     for(int i=0; i<8; i++)
       begin
       srio_trans_item.payload.push_back(i);
          expected_payload.push_back(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "NWRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Data_Streaming_Logical_Layer_Control_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
    assert(srio_trans_item.randomize() with {
     ftype ==2 ;
     ttype == 4 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     address == address_0;
     ext_address == 0;
     xamsbs == 0;

     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Data_Streaming_Logical_Layer_Control_CSR.get();
            `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);             
             `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if({write_data[31:24],write_data[7:4]} == {expected_write1[31:24],expected_write1[7:4]})
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")


        `uvm_info("RW Data_Streaming_Logical_Layer_Control_CSR",$sformatf("After first write 'h48 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Data_Streaming_Logical_Layer_Control_CSR",$sformatf("After first read 'h48 read1_data = %h", read1_data),UVM_LOW);       
       if({write_data[31:24],write_data[7:4]} != {read1_data[31:24],read1_data[7:4]})
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

endtask

endclass : srio_ll_nwrite_nread_50_addr_base_seq

//================NWRITE_R and NREAD_R  SEQUENCE FOR 66 BIT ADDRESSING ============

class srio_ll_nwrite_nread_66_addr_base_seq extends srio_ll_base_seq;
  `uvm_object_utils(srio_ll_nwrite_nread_66_addr_base_seq)
  srio_trans srio_trans_item;

  logic [3:0] ttype_0;
  logic [3:0] ftype_0;
  logic wdptr_0;        
  logic [3:0] wrsize_1;  
  logic [3:0] rdsize_1;
  logic [20:0] config_offset_0 ;
  logic [7:0] targetID_Info_0;
  logic [29:0] address_0;
  logic [31:0] write_data;
  logic [31:0] read1_data;
  logic [31:0] read2_data;
  logic [7:0] expected_payload[$];
  logic [31:0] expected_write;
  logic [31:0] expected_write1;
  logic [13:0] g;
function new(string name="");
    super.new(name);
  endfunction

task byte_reverse(input logic [31:0] a);
  logic [7:0] b,c,d,e;
  b  = {a[24],a[25],a[26],a[27],a[28],a[29],a[30],a[31]};
  c  = {a[16],a[17],a[18],a[19],a[20],a[21],a[22],a[23]};
  d  = {a[8],a[9],a[10],a[11],a[12],a[13],a[14],a[15]};
  e  = {a[0],a[1],a[2],a[3],a[4],a[5],a[6],a[7]};
  expected_write1 = {b,c,d,e};
endtask

  virtual task body();
		
    srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
    srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.rdsize_0.constraint_mode(0);
	srio_trans_item.Ftype_8.constraint_mode(0);
	
    srio_reg_model.Processing_Element_Logical_Layer_Control_CSR.Extended_addressing_control.set(3'b001);
      //Data_Streaming_Logical_Layer_Control_CSR
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype == 4'h5 ;
     ttype == 4'h5 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     address == address_0;
     ext_address == 0;
     xamsbs == 0;
     });
     for(int i=0; i<8; i++)
       begin
       srio_trans_item.payload.push_back(i);
          expected_payload.push_back(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "NWRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Data_Streaming_Logical_Layer_Control_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
    assert(srio_trans_item.randomize() with {
     ftype ==2 ;
     ttype == 4 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     address == address_0;
     ext_address == 0;
     xamsbs == 0;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
        read1_data = srio_reg_model.Data_Streaming_Logical_Layer_Control_CSR.get();
            `uvm_info("EXPECTED WRITE DATA",$sformatf("EXPECTED WRITE DATA WRITTEN INTO THE REGISTER = %0h", expected_write1),UVM_LOW);             
             `uvm_info("WRITE DATA",$sformatf("WRITTEN DATA VALUE IN THE RESPECTIVE REGISTER = %0h", write_data),UVM_LOW);
     if({write_data[31:24],write_data[7:4]} == {expected_write1[31:24],expected_write1[7:4]})
           `uvm_info("WRITE DATA CHECK","EXPECTED WRITE DATA MATCHES WITH REGISTER WRITE DATA",UVM_LOW)
     else
           `uvm_error("WRITE DATA CHECK","EXPECTED WRITE DATA DOES NOT MATCH WITH REGISTER WRITE DATA")


        `uvm_info("RW Data_Streaming_Logical_Layer_Control_CSR",$sformatf("After first write 'h48 write_data = %h", write_data),UVM_LOW);
        `uvm_info("RW Data_Streaming_Logical_Layer_Control_CSR",$sformatf("After first read 'h48 read1_data = %h", read1_data),UVM_LOW);       
       if({write_data[31:24],write_data[7:4]} != {read1_data[31:24],read1_data[7:4]})
       `uvm_error("ERROR","WRITE DATA DOES NOT MATCH WITH READ DATA OF THE REGISTER")
     else 
       `uvm_info("REGISTER VALUE COMPARISON","WRITE DATA MATCHES WITH READ DATA OF THE REGISTER",UVM_LOW);

endtask

endclass : srio_ll_nwrite_nread_66_addr_base_seq

//DS MULTI SEGEMENT AND SINGLE MTU WITH RANDOM PRIORITY AND CRF FOR LFC SEQUENCES

 class srio_ll_lfc_ds_random_prio_base_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_lfc_ds_random_prio_base_seq)

  srio_trans srio_trans_item;

    rand bit [3:0] ftype_0;
    rand bit xh_0 ;
     rand bit [15:0] pdulength_0;
     rand bit [7:0] mtusize_0; 
     rand bit [31:0] read_data;     
     rand bit [1:0] prio_0;
     rand bit crf_0;
function new(string name="");
    super.new(name);
  endfunction

  virtual task body();

 	mtusize_0 = $urandom_range(32'd64,32'd8);
 	pdulength_0 = $urandom_range(32'h0000_0FFF,mtusize_0*4);
	srio_trans_item = srio_trans::type_id::create("srio_trans_item");

	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
     	srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.rdsize_0.constraint_mode(0);
	srio_trans_item.Ftype_8.constraint_mode(0);
    // Maintenance Read 
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt =1;
	assert(srio_trans_item.randomize() with {
     ftype == 4'h8;
     ttype == 4'h0 ;
     rdsize ==4'h8 ;
     wrsize ==4'h8 ;
     wdptr ==1'b0 ;
     config_offset == 21'h48;});
     srio_trans_item.print();
    begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE READ REQUEST Transcation"),UVM_LOW); end
   finish_item(srio_trans_item);
	fork //{
	begin //{
        @(env_config.ll_config.ll_pkt_received);
        #20ns;
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET "),UVM_LOW);
	end //}
	begin //{
	#5000ns;
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET FAILED --- TIMEOUT OCCURED "),UVM_LOW);
	end //}
	join_any //}
disable fork;

	read_data = env_config.srio_reg_model_rx.Data_Streaming_Logical_Layer_Control_CSR.get();
    read_data[7:0] = {4'b1110,4'b0000};
    read_data[31:24] = mtusize_0;
	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
    srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.rdsize_0.constraint_mode(0);
	srio_trans_item.Ftype_8.constraint_mode(0);
	//Maintenance Write
	start_item(srio_trans_item);
     srio_trans_item.usr_gen_pkt =1;
	assert(srio_trans_item.randomize() with {
     ftype == 4'h8;
     ttype == 4'h1 ;
     rdsize ==4'h8 ;
     wrsize ==4'h8 ;
     wdptr ==1'b0 ;
     config_offset == 21'h48;});
     srio_trans_item.payload.push_back(read_data[31:24]);
     srio_trans_item.payload.push_back(read_data[23:16]);
     srio_trans_item.payload.push_back(read_data[15:8]);
     srio_trans_item.payload.push_back(read_data[7:0]);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.print();
     begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE REQUEST Transcation"),UVM_LOW); end
     finish_item(srio_trans_item);
	#100ns;
    read_data = env_config.srio_reg_model_rx.Data_Streaming_Logical_Layer_Control_CSR.get();
 
///DS PACKET
	repeat(50) begin //{
        prio_0 = $urandom_range(2,0);
        srio_trans_item = srio_trans::type_id::create("srio_trans_item");
        srio_trans_item.Ftype.constraint_mode(0);
	    srio_trans_item.Ftype_9.constraint_mode(0);
	    srio_trans_item.Xh.constraint_mode(0);
	    srio_trans_item.prior.constraint_mode(0);
        srio_trans_item.Crf.constraint_mode(0);
        start_item(srio_trans_item);
      assert(srio_trans_item.randomize() with {ftype ==4'h9 ;xh==1'b0;pdulength == pdulength_0;mtusize == mtusize_0;prio == prio_0;crf == 0;});
      begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DS MULTI SEGMENT -- WITH RANDOM PRIORITY AND CRF FOR LFC CASE"),UVM_LOW); end
            
		srio_trans_item.print();
	         finish_item(srio_trans_item);
	end //}
  endtask
endclass :srio_ll_lfc_ds_random_prio_base_seq

//================NWRITE_R and NREAD_R  SEQUENCE FOR MEMORY ACCESS ============

class srio_ll_nwrite_nread_mem_access_base_seq extends srio_ll_base_seq;
  `uvm_object_utils(srio_ll_nwrite_nread_mem_access_base_seq)
  srio_trans srio_trans_item;
  logic [3:0] ttype_0;
  logic [3:0] ftype_0;
  logic wdptr_0;        
  logic [3:0] wrsize_1;  
  logic [3:0] rdsize_1;
  logic [20:0] config_offset_0 ;
  logic [7:0] targetID_Info_0;
  logic [29:0] address_0;
  logic [31:0] write_data;
  logic [31:0] read1_data;
  logic [31:0] read2_data;
  logic [7:0] expected_payload[$];
  logic [31:0] expected_write;
  logic [31:0] expected_write1;
  logic [13:0] g;

function new(string name="");
    super.new(name);
  endfunction

task byte_reverse(input logic [31:0] a);
  logic [7:0] b,c,d,e;
  b  = {a[24],a[25],a[26],a[27],a[28],a[29],a[30],a[31]};
  c  = {a[16],a[17],a[18],a[19],a[20],a[21],a[22],a[23]};
  d  = {a[8],a[9],a[10],a[11],a[12],a[13],a[14],a[15]};
  e  = {a[0],a[1],a[2],a[3],a[4],a[5],a[6],a[7]};
  expected_write1 = {b,c,d,e};
endtask

  virtual task body();
    srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
    srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.rdsize_0.constraint_mode(0);
	srio_trans_item.Ftype_8.constraint_mode(0);
    srio_trans_item.ext_adress_xamsbs.constraint_mode(0);
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype == 4'h5 ;
     ttype == 4'h5 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     address == 29'h1000_0000;
     ext_address == 0;
     xamsbs == 0;
     SrcTID == 1;
     });
     for(int i=0; i<8; i++)
       begin
       srio_trans_item.payload.push_back(i);
          expected_payload.push_back(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "NWRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
     write_data = srio_reg_model.Data_Streaming_Logical_Layer_Control_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
    assert(srio_trans_item.randomize() with {
     ftype ==2 ;
     ttype == 4 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     address == 29'h1000_0000;
     ext_address == 0;
     xamsbs == 0;
     SrcTID == 3;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #5000ns;

endtask

endclass : srio_ll_nwrite_nread_mem_access_base_seq

// MAINTENANCE DS SUPPORT AND MTU,TMODE CONFIGURATION
class srio_ll_maintenance_ds_support_base_reg extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_maintenance_ds_support_base_reg)

  srio_trans srio_trans_item;
   rand bit [31:0] read_data;
   rand bit [7:0] mtusize_0;
   rand bit [15:0] pdu_length_0;
   rand bit [3:0] tm_mode_0,TMmode_0;

   function new(string name="");
    super.new(name);
   endfunction

  virtual task body();
  	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
  	srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.rdsize_0.constraint_mode(0);
	srio_trans_item.Ftype_8.constraint_mode(0);
    // Maintenance Read 
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt =1;
	assert(srio_trans_item.randomize() with {
        ftype == 4'h8;
        ttype == 4'h0 ;
        rdsize ==4'h8 ;
        wrsize ==4'h8 ;
        wdptr ==1'b0 ;
        config_offset == 21'h48;});
        srio_trans_item.print();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE READ REQUEST Transcation"),UVM_LOW); end
    finish_item(srio_trans_item);
	fork //{
	begin //{
        //@(env_config.ll_config.ll_pkt_transmitted);
        @(env_config.ll_config.ll_pkt_received);
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET AFTER MAINT_RD"),UVM_LOW);
	end //}
	begin //{
	#10000ns;
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET FAILED AFTER MAINT_RD --- TIMEOUT OCCURED "),UVM_LOW);
	end //}
	join_any //}
	disable fork;
	read_data = env_config.srio_reg_model_rx.Data_Streaming_Logical_Layer_Control_CSR.get();
    //read_data[31:0] = {4'b1110,tm_mode_0,8'h0,8'h0,mtusize_0};
         read_data[7:0] = {4'b1110,tm_mode_0};
         read_data[15:8] = 8'h0;
         read_data[23:16] = 8'h0;
         read_data[31:24] = mtusize_0;
	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
    srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.rdsize_0.constraint_mode(0);
	srio_trans_item.Ftype_8.constraint_mode(0);
	//Maintenance Write 
	start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt =1;
	assert(srio_trans_item.randomize() with {
     ftype == 4'h8;
     ttype == 4'h1 ;
     rdsize ==4'h8 ;
     wrsize ==4'h8 ;
     wdptr ==1'b0 ;
     config_offset == 21'h48;});
     srio_trans_item.payload.push_back(read_data[31:24]);
     srio_trans_item.payload.push_back(read_data[23:16]);
     srio_trans_item.payload.push_back(read_data[15:8]);
     srio_trans_item.payload.push_back(read_data[7:0]);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.print();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE REQUEST  Transcation"),UVM_LOW); end
       finish_item(srio_trans_item);
        fork //{
	begin //{
        //@(env_config.ll_config.ll_pkt_transmitted);
        @(env_config.ll_config.ll_pkt_received);
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET AFTER MAINT_WR"),UVM_LOW);
	end //}
	begin //{
	#10000ns;
	`uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "WAITING FOR TX MONITOR TOTAL PACKET FAILED AFTER MAINT_WR --- TIMEOUT OCCURED "),UVM_LOW);
    end //}
	join_any //}
	disable fork;
    endtask
endclass :srio_ll_maintenance_ds_support_base_reg

class srio_ll_illegal_io_trans_seq extends srio_ll_base_seq;
  `uvm_object_utils(srio_ll_illegal_io_trans_seq)

  srio_trans srio_trans_item;
  rand bit [3:0] ttype_0;
  rand bit [3:0] ftype_0;
  function new(string name="");
    super.new(name);
  endfunction

  virtual task body();

     //generate type 5 packets with legal and illegal ttype
     for(int i=0; i<12; i++)
     begin //{
       srio_trans_item = srio_trans::type_id::create("srio_trans_item");   
       srio_trans_item.Ftype.constraint_mode(0);
       srio_trans_item.Ttype.constraint_mode(0);
    
       start_item(srio_trans_item);
       assert(srio_trans_item.randomize() with {ftype==5 ;ttype==i;});
       begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " TYPE5 REQUEST With Legal/Illegal TTYPE"),UVM_LOW); end       
       srio_trans_item.print();
       finish_item(srio_trans_item);
       end //}
       //generate type 5 packets with illegal wrsize==14 and wdptr==1
       for(int i=0; i<16; i++)
       begin //{
       srio_trans_item = srio_trans::type_id::create("srio_trans_item");   
       srio_trans_item.Ftype.constraint_mode(0);
       srio_trans_item.Ttype.constraint_mode(0);
       srio_trans_item.wrsize_0.constraint_mode(0);
       srio_trans_item.Wdptr.constraint_mode(0);
       start_item(srio_trans_item);
       if(i==0 || i==1 || i==4 || i==5 || (i>11 && i<16) )
         assert(srio_trans_item.randomize() with {ftype==5 ;ttype==i; wrsize==14; wdptr==1;});
           begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " TYPE5 REQUEST With Illegal WRSIZE=14/WDPTR=1"),UVM_LOW); end       
       srio_trans_item.print();
       finish_item(srio_trans_item);
      end //}

     //generate type 5 packets with illegal wrsize==14 and wdptr==0
     for(int i=0; i<16; i++)
     begin //{
       srio_trans_item = srio_trans::type_id::create("srio_trans_item");   
       srio_trans_item.Ftype.constraint_mode(0);
       srio_trans_item.Ttype.constraint_mode(0);
       srio_trans_item.wrsize_0.constraint_mode(0);
       srio_trans_item.Wdptr.constraint_mode(0);
       start_item(srio_trans_item);
       if(i==0 || i==1 || i==4 || i==5 || (i>11 && i<16) )
         assert(srio_trans_item.randomize() with {ftype==5 ;ttype==i; wrsize==14; wdptr==0;});
         begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " TYPE5 REQUEST With Illegal WRSIZE=14/WDPTR=0"),UVM_LOW); end       
       srio_trans_item.print();
       finish_item(srio_trans_item);
     end //}

          //generate type 5 packets with illegal wrsize==15 and wdptr==0
     for(int i=0; i<16; i++)
     begin //{
       srio_trans_item = srio_trans::type_id::create("srio_trans_item");   
       srio_trans_item.Ftype.constraint_mode(0);
       srio_trans_item.Ttype.constraint_mode(0);
       srio_trans_item.wrsize_0.constraint_mode(0);
       srio_trans_item.Wdptr.constraint_mode(0);
       start_item(srio_trans_item);
       if(i==0 || i==1 || i==4 || i==5 || (i>11 && i<16) )
         assert(srio_trans_item.randomize() with {ftype==5 ;ttype==i; wrsize==15; wdptr==0;});
          begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " TYPE5 REQUEST With Illegal WRSIZE=15/WDPTR=0"),UVM_LOW); end       
       srio_trans_item.print();
       finish_item(srio_trans_item);
     end //}
          //generate type 8 packets with legal/illegal ttype values
     for(int i=5; i<16; i++)
     begin //{
       srio_trans_item = srio_trans::type_id::create("srio_trans_item");   
       srio_trans_item.Ftype.constraint_mode(0);
       srio_trans_item.Ttype.constraint_mode(0);
       start_item(srio_trans_item);
       assert(srio_trans_item.randomize() with {ftype==8 ;ttype==i;});
          begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " TYPE8 REQUEST With Legal/Illegal TTYPE"),UVM_LOW); end       
       srio_trans_item.print();
       finish_item(srio_trans_item);
     end //}

          //generate type 13 packets with legal/illegal ttype values
     for(int i=0; i<16; i++)
     begin //{
       srio_trans_item = srio_trans::type_id::create("srio_trans_item");   
       srio_trans_item.Ftype.constraint_mode(0);
       srio_trans_item.Ttype.constraint_mode(0);
     
       start_item(srio_trans_item);
       assert(srio_trans_item.randomize() with {ftype==13 ;ttype==i;});
          begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " TYPE13 Transaction With Legal/Illegal TTYPE"),UVM_LOW); end       
       srio_trans_item.print();
       finish_item(srio_trans_item);
     end //}

          //generate type 8 read response packets with legal/illegal trasaction status
     for(int i=1; i<12; i++)
     begin //{
       srio_trans_item = srio_trans::type_id::create("srio_trans_item");   
       srio_trans_item.Ftype.constraint_mode(0);
       srio_trans_item.Ttype.constraint_mode(0);

       start_item(srio_trans_item);
       assert(srio_trans_item.randomize() with {ftype==8 ;ttype==2; trans_status==i;});

          begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " TYPE13 Transaction With Legal/Illegal TTYPE"),UVM_LOW); end       
       srio_trans_item.print();

       finish_item(srio_trans_item);
     end //}

          //generate type 8 write response packets with legal/illegal trasaction status
     for(int i=1; i<12; i++)
     begin //{
       srio_trans_item = srio_trans::type_id::create("srio_trans_item");   
       srio_trans_item.Ftype.constraint_mode(0);
       srio_trans_item.Ttype.constraint_mode(0);
     
       start_item(srio_trans_item);
       assert(srio_trans_item.randomize() with {ftype==8 ;ttype==3; trans_status==i;});

          begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " TYPE13 Transaction With Legal/Illegal TTYPE"),UVM_LOW); end       
       srio_trans_item.print();

       finish_item(srio_trans_item);
     end //}

     endtask
endclass : srio_ll_illegal_io_trans_seq

//Illegal msg transaction sequence
class srio_ll_illegal_msg_trans_seq extends srio_ll_base_seq;
  `uvm_object_utils(srio_ll_illegal_msg_trans_seq)

  srio_trans srio_trans_item;
  rand bit [3:0] ttype_0;
  rand bit [3:0] ftype_0;
 function new(string name="");
    super.new(name);
  endfunction

  virtual task body();

     //generate msg packets with illegal ssize
     for(int i=0; i<9; i++)
     begin //{
       srio_trans_item = srio_trans::type_id::create("srio_trans_item");   
       srio_trans_item.Ftype.constraint_mode(0);
       srio_trans_item.Ftype_B_1.constraint_mode(0);
       srio_trans_item.Ftype_B_2.constraint_mode(0);
       srio_trans_item.Ftype_B.constraint_mode(0);
     
       start_item(srio_trans_item);
       assert(srio_trans_item.randomize() with {ftype==11 ; msg_len ==0; ssize==i;});

          begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " MSG REQUEST With msg_len==0 and illegal SSIZE"),UVM_LOW); end       
       srio_trans_item.print();

       finish_item(srio_trans_item);
     end //}

      //generate msg packets with illegal ssize
      for(int i=0; i<9; i++)
      begin //{
        srio_trans_item = srio_trans::type_id::create("srio_trans_item");   
        srio_trans_item.Ftype.constraint_mode(0);
        srio_trans_item.Ttype.constraint_mode(0);
        srio_trans_item.Ftype_B_2.constraint_mode(0);
        srio_trans_item.Ftype_B.constraint_mode(0);
      
        start_item(srio_trans_item);
        assert(srio_trans_item.randomize() with {ftype==11 ;ssize==i;});

           begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " MSG REQUEST With Illegal msg_len!=0 and illegal SSIZE"),UVM_LOW); end       
        srio_trans_item.print();

        finish_item(srio_trans_item);
      end //}

      //generate msg resp packets with illegal trans status
      for(int i=0; i<12; i++)
      begin //{
        srio_trans_item = srio_trans::type_id::create("srio_trans_item");   
        srio_trans_item.Ftype.constraint_mode(0);
        srio_trans_item.Ttype.constraint_mode(0);
        srio_trans_item.trans_status_c.constraint_mode(0);
      
        start_item(srio_trans_item);
        assert(srio_trans_item.randomize() with {ftype==13 ;ttype==1; trans_status==i;});

           begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " MSG RESP With Illegal trans_status"),UVM_LOW); end       
        srio_trans_item.print();

        finish_item(srio_trans_item);
      end //}


     endtask
endclass : srio_ll_illegal_msg_trans_seq

//Illegal gsm transaction sequence
class srio_ll_illegal_gsm_trans_seq extends srio_ll_base_seq;
  `uvm_object_utils(srio_ll_illegal_gsm_trans_seq)

  srio_trans srio_trans_item;
  

  rand bit [3:0] ttype_0;
  rand bit [3:0] ftype_0;
  rand bit [3:0] rdsize_0;
  

function new(string name="");
    super.new(name);
  endfunction

  virtual task body();

     //generate type 1 gsm packets with illegal ttype
     for(int i=3; i<16; i++)
     begin //{
       srio_trans_item = srio_trans::type_id::create("srio_trans_item");   
       srio_trans_item.Ftype.constraint_mode(0);
        srio_trans_item.Ttype.constraint_mode(0);
     
       start_item(srio_trans_item);
       assert(srio_trans_item.randomize() with {ftype==1 ; ttype ==i;});

          begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " TYPE 1 GSM with illegal TTYPE"),UVM_LOW); end       
       srio_trans_item.print();

       finish_item(srio_trans_item);
     end //}

     //generate type 5 gsm packets with illegal ttype
     for(int i=2; i<16; i++)
     begin //{
       srio_trans_item = srio_trans::type_id::create("srio_trans_item");   
       srio_trans_item.Ftype.constraint_mode(0);
        srio_trans_item.Ttype.constraint_mode(0);
     
       start_item(srio_trans_item);
       if(i<4 && i>5)
         assert(srio_trans_item.randomize() with {ftype==5 ; ttype ==i;});

          begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " TYPE 5 GSM with illegal TTYPE"),UVM_LOW); end       
       srio_trans_item.print();

       finish_item(srio_trans_item);
     end //}

     //generate type 1 gsm packets with illegal rdsize
     for(int i=0; i<3; i++)
     begin //{
       srio_trans_item = srio_trans::type_id::create("srio_trans_item");   
       srio_trans_item.Ftype.constraint_mode(0);
        srio_trans_item.Ttype.constraint_mode(0);
        srio_trans_item.rdsize_0.constraint_mode(0);
     
       start_item(srio_trans_item);
         assert(srio_trans_item.randomize() with {ftype==1 ; ttype ==i; rdsize>12;});

          begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " TYPE 1 GSM with illegal RDSIZE"),UVM_LOW); end       
       srio_trans_item.print();

       finish_item(srio_trans_item);
     end //}

     //generate type 2 gsm packets with illegal rdsize
     for(int i=0; i<12; i++)
     begin //{
       srio_trans_item = srio_trans::type_id::create("srio_trans_item");   
       srio_trans_item.Ftype.constraint_mode(0);
        srio_trans_item.Ttype.constraint_mode(0);
        srio_trans_item.rdsize_0.constraint_mode(0);
     
       if(i !=4)
       begin //{
         start_item(srio_trans_item);
         assert(srio_trans_item.randomize() with {ftype==2 ; ttype ==i; rdsize>12;});

          begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " TYPE 1 GSM with illegal RDSIZE"),UVM_LOW); end       
         srio_trans_item.print();

         finish_item(srio_trans_item);
       end //}
     end //}

     //generate type 5 gsm packets with illegal rdsize
     for(int i=0; i<2; i++)
     begin //{
       srio_trans_item = srio_trans::type_id::create("srio_trans_item");   
       srio_trans_item.Ftype.constraint_mode(0);
        srio_trans_item.Ttype.constraint_mode(0);
        srio_trans_item.rdsize_0.constraint_mode(0);
        srio_trans_item.wrsize_0.constraint_mode(0);
     
       if(i !=4)
       begin //{
         start_item(srio_trans_item);
         assert(srio_trans_item.randomize() with {ftype==5 ; ttype ==i; rdsize>12; wrsize>12;});

          begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " TYPE 5 GSM with illegal RDSIZE/WRSIZE"),UVM_LOW); end       
         srio_trans_item.print();

         finish_item(srio_trans_item);
       end //}
     end //}

     endtask
endclass : srio_ll_illegal_gsm_trans_seq

//VC ENABLED DS MULTI SEGEMENT SEQUENCES

 class srio_ll_vc_ds_mseg_req_base_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_vc_ds_mseg_req_base_seq)

  srio_trans srio_trans_item;

     rand bit [15:0] pdulength_0;
     rand bit [7:0] mtusize_0; 
     rand bit vc_0,crf_0;
     rand bit [1:0] prio_0;     
    function new(string name="");
    super.new(name);
    endfunction

  virtual task body();
     //DS Packet	
     srio_trans_item = srio_trans::type_id::create("srio_trans_item");
     srio_trans_item.Ftype.constraint_mode(0);
     srio_trans_item.Ftype_9.constraint_mode(0);
     srio_trans_item.Xh.constraint_mode(0);
     srio_trans_item.prior.constraint_mode(0);
     srio_trans_item.Crf.constraint_mode(0);

     start_item(srio_trans_item);

     assert(srio_trans_item.randomize() with {ftype ==4'h9 ;xh==1'b0;pdulength == pdulength_0;mtusize == mtusize_0;prio == prio_0;crf == crf_0;});
     srio_trans_item.vc = vc_0;
     begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DS MULTI SEGMENT Transcation"),UVM_LOW); end  
       
    srio_trans_item.print();
    finish_item(srio_trans_item);
   #100ns; 
  endtask
endclass :srio_ll_vc_ds_mseg_req_base_seq

//========VC ENABLED LFC SEQUENCES=========
class srio_ll_vc_lfc_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_vc_lfc_seq)
   
  srio_trans srio_trans_item;

   rand bit [31:0] tgtdestID_0;
   rand bit [2:0] FAM_0;
   rand bit xon_xoff_0;
   rand bit [3:0] ftype_0;
   rand bit [31:0] DestinationID_0;
   rand bit [6:0] flowID_0;
   rand bit vc_0;
   function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
      srio_trans_item.Ftype.constraint_mode(0);
      srio_trans_item.Ftype_7.constraint_mode(0);
      srio_trans_item.Ftype_7_fam.constraint_mode(0);
      srio_trans_item.Ftype_7_xon_xoff.constraint_mode(0);
      srio_trans_item.Ftype7_flowid.constraint_mode(0);

      start_item(srio_trans_item);

      assert(srio_trans_item.randomize() with {ftype ==ftype_0;flowID==flowID_0;xon_xoff==xon_xoff_0;tgtdestID==tgtdestID_0;DestinationID == DestinationID_0; FAM==FAM_0;});
     srio_trans_item.vc = vc_0;
      begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "LFC XOFF packet Transcation"),UVM_LOW); end

     
        srio_trans_item.print();
	finish_item(srio_trans_item);
      endtask
endclass :srio_ll_vc_lfc_seq

//======================= Multi VC NWRITE AND SWRITE SEQUENCE ======================

class srio_ll_multi_vc_nwrite_swrite_base_seq extends srio_ll_base_seq;
`uvm_object_utils(srio_ll_multi_vc_nwrite_swrite_base_seq)
srio_trans srio_trans_item;
	   
 rand bit [3:0] ftype_0;
 rand bit [3:0] ttype_0;
 rand bit [1:0] prio_0;
 rand bit crf_0;
 rand bit vc_0;
  

function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
		
        srio_trans_item = srio_trans::type_id::create("srio_trans_item");
    	srio_trans_item.Ftype.constraint_mode(0);
    	srio_trans_item.Ttype.constraint_mode(0);
    	srio_trans_item.prior.constraint_mode(0);
    	srio_trans_item.Crf.constraint_mode(0);

        start_item(srio_trans_item);
        assert(srio_trans_item.randomize() with {ftype == ftype_0;ttype == ttype_0;prio == prio_0;crf == crf_0;}); 
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MULTI VC NWRITE & SWRITE REQUEST Transcation"),UVM_LOW); end
       srio_trans_item.vc = vc_0; 
       srio_trans_item.print();
       finish_item(srio_trans_item);
       #100ns;
  endtask

endclass : srio_ll_multi_vc_nwrite_swrite_base_seq

class srio_ll_atomic_invalid_seq extends srio_ll_base_seq;
  `uvm_object_utils(srio_ll_atomic_invalid_seq)

  srio_trans srio_trans_item;
  rand bit [3:0] ttype_0;
  rand bit [3:0] ftype_0;
  function new(string name="");
    super.new(name);
  endfunction

  virtual task body();

     //generate type 5 ttype=12 atomic packets with valid and invalid size 
     for(int i=0; i<16; i++)
     begin //{
       srio_trans_item = srio_trans::type_id::create("srio_trans_item");   
       srio_trans_item.Ftype.constraint_mode(0);
       srio_trans_item.Ttype.constraint_mode(0);
       srio_trans_item.wrsize_0.constraint_mode(0);
       srio_trans_item.Wdptr.constraint_mode(0);
    
       start_item(srio_trans_item);
       assert(srio_trans_item.randomize() with {ftype==5 ;ttype==12; wrsize==i; wdptr==0;});
       begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " TYPE5 REQUEST With Legal/Illegal TTYPE"),UVM_LOW); end       
       srio_trans_item.print();
       finish_item(srio_trans_item);
       #1ns;

       srio_trans_item = srio_trans::type_id::create("srio_trans_item");   
       srio_trans_item.Ftype.constraint_mode(0);
       srio_trans_item.Ttype.constraint_mode(0);
       srio_trans_item.wrsize_0.constraint_mode(0);
       srio_trans_item.Wdptr.constraint_mode(0);
    
       start_item(srio_trans_item);
       assert(srio_trans_item.randomize() with {ftype==5 ;ttype==12; wrsize==i; wdptr==1;});
       begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " TYPE5 REQUEST With Legal/Illegal TTYPE"),UVM_LOW); end       
       srio_trans_item.print();
       finish_item(srio_trans_item);
       #1ns;
     end //}

     //generate type 5 ttype=13 atomic packets with valid and invalid size 
     for(int i=0; i<16; i++)
     begin //{
       srio_trans_item = srio_trans::type_id::create("srio_trans_item");   
       srio_trans_item.Ftype.constraint_mode(0);
       srio_trans_item.Ttype.constraint_mode(0);
       srio_trans_item.wrsize_0.constraint_mode(0);
       srio_trans_item.Wdptr.constraint_mode(0);
    
       start_item(srio_trans_item);
       assert(srio_trans_item.randomize() with {ftype==5 ;ttype==13; wrsize==i; wdptr==0;});
       begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " TYPE5 REQUEST With Legal/Illegal TTYPE"),UVM_LOW); end       
       srio_trans_item.print();
       finish_item(srio_trans_item);
       #1ns;

       srio_trans_item = srio_trans::type_id::create("srio_trans_item");   
       srio_trans_item.Ftype.constraint_mode(0);
       srio_trans_item.Ttype.constraint_mode(0);
       srio_trans_item.wrsize_0.constraint_mode(0);
       srio_trans_item.Wdptr.constraint_mode(0);
    
       start_item(srio_trans_item);
       assert(srio_trans_item.randomize() with {ftype==5 ;ttype==13; wrsize==i; wdptr==1;});
       begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " TYPE5 REQUEST With Legal/Illegal TTYPE"),UVM_LOW); end       
       srio_trans_item.print();
       finish_item(srio_trans_item);
       #1ns;
     end //}

     //generate type 5 ttype=14 atomic packets with valid and invalid size 
     for(int i=0; i<16; i++)
     begin //{
       srio_trans_item = srio_trans::type_id::create("srio_trans_item");   
       srio_trans_item.Ftype.constraint_mode(0);
       srio_trans_item.Ttype.constraint_mode(0);
       srio_trans_item.wrsize_0.constraint_mode(0);
       srio_trans_item.Wdptr.constraint_mode(0);
    
       start_item(srio_trans_item);
       assert(srio_trans_item.randomize() with {ftype==5 ;ttype==14; wrsize==i; wdptr==0;});
       begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " TYPE5 REQUEST With Legal/Illegal TTYPE"),UVM_LOW); end       
       srio_trans_item.print();
       finish_item(srio_trans_item);
       #1ns;

       srio_trans_item = srio_trans::type_id::create("srio_trans_item");   
       srio_trans_item.Ftype.constraint_mode(0);
       srio_trans_item.Ttype.constraint_mode(0);
       srio_trans_item.wrsize_0.constraint_mode(0);
       srio_trans_item.Wdptr.constraint_mode(0);
    
       start_item(srio_trans_item);
       assert(srio_trans_item.randomize() with {ftype==5 ;ttype==14; wrsize==i; wdptr==1;});
       begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " TYPE5 REQUEST With Legal/Illegal TTYPE"),UVM_LOW); end       
       srio_trans_item.print();
       finish_item(srio_trans_item);
       #1ns;
     end //}

     //generate type 2 ttype=12 atomic packets with valid and invalid size 
     for(int i=0; i<16; i++)
     begin //{
       srio_trans_item = srio_trans::type_id::create("srio_trans_item");   
       srio_trans_item.Ftype.constraint_mode(0);
       srio_trans_item.Ttype.constraint_mode(0);
       srio_trans_item.rdsize_0.constraint_mode(0);
       srio_trans_item.Wdptr.constraint_mode(0);
    
       start_item(srio_trans_item);
       assert(srio_trans_item.randomize() with {ftype==2 ;ttype==12; rdsize==i; wdptr==0;});
       begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " TYPE5 REQUEST With Legal/Illegal TTYPE"),UVM_LOW); end       
       srio_trans_item.print();
       finish_item(srio_trans_item);
       #1ns;

       srio_trans_item = srio_trans::type_id::create("srio_trans_item");   
       srio_trans_item.Ftype.constraint_mode(0);
       srio_trans_item.Ttype.constraint_mode(0);
       srio_trans_item.rdsize_0.constraint_mode(0);
       srio_trans_item.Wdptr.constraint_mode(0);
    
       start_item(srio_trans_item);
       assert(srio_trans_item.randomize() with {ftype==2 ;ttype==12; rdsize==i; wdptr==1;});
       begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " TYPE5 REQUEST With Legal/Illegal TTYPE"),UVM_LOW); end       
       srio_trans_item.print();
       finish_item(srio_trans_item);
       #1ns;
     end //}

     //generate type 2 ttype=13 atomic packets with valid and invalid size 
     for(int i=0; i<16; i++)
     begin //{
       srio_trans_item = srio_trans::type_id::create("srio_trans_item");   
       srio_trans_item.Ftype.constraint_mode(0);
       srio_trans_item.Ttype.constraint_mode(0);
       srio_trans_item.rdsize_0.constraint_mode(0);
       srio_trans_item.Wdptr.constraint_mode(0);
    
       start_item(srio_trans_item);
       assert(srio_trans_item.randomize() with {ftype==2 ;ttype==13; rdsize==i; wdptr==0;});
       begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " TYPE5 REQUEST With Legal/Illegal TTYPE"),UVM_LOW); end       
       srio_trans_item.print();
       finish_item(srio_trans_item);
       #1ns;

       srio_trans_item = srio_trans::type_id::create("srio_trans_item");   
       srio_trans_item.Ftype.constraint_mode(0);
       srio_trans_item.Ttype.constraint_mode(0);
       srio_trans_item.rdsize_0.constraint_mode(0);
       srio_trans_item.Wdptr.constraint_mode(0);
    
       start_item(srio_trans_item);
       assert(srio_trans_item.randomize() with {ftype==2 ;ttype==13; rdsize==i; wdptr==1;});
       begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " TYPE5 REQUEST With Legal/Illegal TTYPE"),UVM_LOW); end       
       srio_trans_item.print();
       finish_item(srio_trans_item);
       #1ns;
     end //}

     //generate type 2 ttype=14 atomic packets with valid and invalid size 
     for(int i=0; i<16; i++)
     begin //{
       srio_trans_item = srio_trans::type_id::create("srio_trans_item");   
       srio_trans_item.Ftype.constraint_mode(0);
       srio_trans_item.Ttype.constraint_mode(0);
       srio_trans_item.rdsize_0.constraint_mode(0);
       srio_trans_item.Wdptr.constraint_mode(0);
    
       start_item(srio_trans_item);
       assert(srio_trans_item.randomize() with {ftype==2 ;ttype==14; rdsize==i; wdptr==0;});
       begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " TYPE5 REQUEST With Legal/Illegal TTYPE"),UVM_LOW); end       
       srio_trans_item.print();
       finish_item(srio_trans_item);
       #1ns;

       srio_trans_item = srio_trans::type_id::create("srio_trans_item");   
       srio_trans_item.Ftype.constraint_mode(0);
       srio_trans_item.Ttype.constraint_mode(0);
       srio_trans_item.rdsize_0.constraint_mode(0);
       srio_trans_item.Wdptr.constraint_mode(0);
    
       start_item(srio_trans_item);
       assert(srio_trans_item.randomize() with {ftype==2 ;ttype==14; rdsize==i; wdptr==1;});
       begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " TYPE5 REQUEST With Legal/Illegal TTYPE"),UVM_LOW); end       
       srio_trans_item.print();
       finish_item(srio_trans_item);
       #1ns;
     end //}

     //generate type 2 ttype=15 atomic packets with valid and invalid size 
     for(int i=0; i<16; i++)
     begin //{
       srio_trans_item = srio_trans::type_id::create("srio_trans_item");   
       srio_trans_item.Ftype.constraint_mode(0);
       srio_trans_item.Ttype.constraint_mode(0);
       srio_trans_item.rdsize_0.constraint_mode(0);
       srio_trans_item.Wdptr.constraint_mode(0);
    
       start_item(srio_trans_item);
       assert(srio_trans_item.randomize() with {ftype==2 ;ttype==15; rdsize==i; wdptr==0;});
       begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " TYPE5 REQUEST With Legal/Illegal TTYPE"),UVM_LOW); end       
       srio_trans_item.print();
       finish_item(srio_trans_item);
       #1ns;

       srio_trans_item = srio_trans::type_id::create("srio_trans_item");   
       srio_trans_item.Ftype.constraint_mode(0);
       srio_trans_item.Ttype.constraint_mode(0);
       srio_trans_item.rdsize_0.constraint_mode(0);
       srio_trans_item.Wdptr.constraint_mode(0);
    
       start_item(srio_trans_item);
       assert(srio_trans_item.randomize() with {ftype==2 ;ttype==15; rdsize==i; wdptr==1;});
       begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " TYPE5 REQUEST With Legal/Illegal TTYPE"),UVM_LOW); end       
       srio_trans_item.print();
       finish_item(srio_trans_item);
       #1ns;
     end //}


     endtask
endclass : srio_ll_atomic_invalid_seq

//======= MESSAGE REQ SEQUENCE WITH LETTER AND MBOX VALUE =======

class srio_ll_msg_mbox_letter_req_seq extends srio_ll_base_seq;
`uvm_object_utils(srio_ll_msg_mbox_letter_req_seq)
 srio_trans srio_trans_item;

  rand bit [3:0] ftype_0;
  rand bit [3:0] ssize_0;
  rand bit [1:0] mbox_0;
  rand bit [1:0] letter_0;
  int  message_length_0;
  
  function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
	
    srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ftype_B.constraint_mode(0);
	srio_trans_item.Ftype_B_2.constraint_mode(0);
    start_item(srio_trans_item);
    assert(srio_trans_item.randomize() with {ftype == ftype_0;ssize == ssize_0;message_length == message_length_0;mbox == mbox_0;letter == letter_0;});
    begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "Message request packet Transcation"),UVM_LOW); end
    srio_trans_item.print();
    finish_item(srio_trans_item);

  endtask
endclass : srio_ll_msg_mbox_letter_req_seq
//======= MESSAGE REQ SEQUENCE FOR COVERAGE =======


class srio_ll_message_cov_req_seq extends srio_ll_base_seq;
`uvm_object_utils(srio_ll_message_cov_req_seq)
 srio_trans srio_trans_item;

  rand bit [3:0] ftype_0;
  rand bit [3:0] ssize_0;
  int  message_length_0;
  rand bit [1:0] letter_0;
  rand bit [1:0] mbox_0;

       function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
	
    srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ftype_B.constraint_mode(0);
	srio_trans_item.Ftype_B_2.constraint_mode(0);
    srio_trans_item.Ftype_B_1.constraint_mode(0);

        start_item(srio_trans_item);

	assert(srio_trans_item.randomize() with {ftype == ftype_0;ssize == ssize_0;message_length == message_length_0;letter == letter_0;mbox == mbox_0;});

         begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "Message request packet Transcation"),UVM_LOW); end

         srio_trans_item.print();

         finish_item(srio_trans_item);

  endtask
   endclass : srio_ll_message_cov_req_seq

// Invalid TT Sequence

class srio_ll_pkt_invalid_tt_base_seq extends srio_ll_base_seq;
    `uvm_object_utils(srio_ll_pkt_invalid_tt_base_seq)

   srio_trans srio_trans_item;

  rand bit [3:0] ftype_0;
  rand bit [3:0] ttype_0;
      function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
     srio_trans_item = srio_trans::type_id::create("srio_trans_item");	
     srio_trans_item.Ftype.constraint_mode(0);
     srio_trans_item.Ttype.constraint_mode(0);
     srio_trans_item.tl_err.constraint_mode(0);

      start_item(srio_trans_item);
     assert(srio_trans_item.randomize() with {tl_err_kind == RESERVED_TT_ERR; ftype == 4'h2 ;ttype == 4'h4;});  
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " Invalid TT for Nread Transcation"),UVM_LOW); end
        srio_trans_item.print();
        finish_item(srio_trans_item);
  endtask

endclass : srio_ll_pkt_invalid_tt_base_seq
//========= USER GENERATE SEQUENCE with vc support =========

class srio_ll_vc_user_gen_base_seq extends srio_ll_base_seq;
    `uvm_object_utils(srio_ll_vc_user_gen_base_seq)

   srio_trans srio_trans_item;

  rand bit [3:0] ftype_0;
  rand bit [3:0] ttype_0;
  rand bit [2:0] mode ;
  rand bit flag,crf_0;
  rand bit vc_0;
  rand bit [1:0] prio_0;
      function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
     srio_trans_item = srio_trans::type_id::create("srio_trans_item");	
     srio_trans_item.Ftype.constraint_mode(0);
     srio_trans_item.Ttype.constraint_mode(0);
     srio_trans_item.prior.constraint_mode(0);
     srio_trans_item.Crf.constraint_mode(0);
     
     mode = $urandom;
	flag = $urandom;
	// Ftype 
	
	case (mode)  //{
	   3'd0,3'd5: ftype_0 = 4'h5;
	   3'd1,3'd6,3'd4: ftype_0 = 4'h6;
	   3'd2,3'd7,3'd3: ftype_0 = 4'h8;
           
	  endcase //}
	
	//Type
	if (ftype_0 == 4'h5)  begin 
		ttype_0 = 4;
	
	end 
	else if (ftype_0 == 4'h8) begin 
	        ttype_0 = 4;
	
	end 
	else begin 
	 	ttype_0 = 4'h0;
	end 
	

      start_item(srio_trans_item);
     if(ftype_0 == 4'h6 )
     assert(srio_trans_item.randomize() with {ftype == ftype_0; prio == prio_0; crf == crf_0;});
     else 
     assert(srio_trans_item.randomize() with {ftype == ftype_0;ttype == ttype_0; prio == prio_0; crf == crf_0;});
     srio_trans_item.vc = vc_0;         
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " RANDOM USER GENERATE  Transcation"),UVM_LOW); end
        srio_trans_item.print();
        finish_item(srio_trans_item);
  endtask

endclass : srio_ll_vc_user_gen_base_seq


//========LFC SEQUENCES with vc support =========

class srio_ll_multi_vc_lfc_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_multi_vc_lfc_seq)
  rand bit vc_0; 
  srio_trans srio_trans_item;
  
   rand bit [31:0] tgtdestID_0;
   rand bit [2:0] FAM_0;
   rand bit xon_xoff_0;
   rand bit [3:0] ftype_0;
   rand bit [31:0] DestinationID_0;
   rand bit [6:0] flowID_0;
   rand bit SOC_0;
   function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
      srio_trans_item.Ftype.constraint_mode(0);
      srio_trans_item.Ftype_7.constraint_mode(0);
      srio_trans_item.Ftype_7_fam.constraint_mode(0);
      srio_trans_item.Ftype_7_xon_xoff.constraint_mode(0);
	srio_trans_item.Ftype7_flowid.constraint_mode(0);

      start_item(srio_trans_item);

      assert(srio_trans_item.randomize() with {ftype ==ftype_0;flowID==flowID_0;xon_xoff==xon_xoff_0;tgtdestID==tgtdestID_0;DestinationID == DestinationID_0; FAM==FAM_0;});
       srio_trans_item.vc = vc_0;
		begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "LFC  packet Transcation"),UVM_LOW); end

     
        srio_trans_item.print();
	finish_item(srio_trans_item);
      endtask
endclass :srio_ll_multi_vc_lfc_seq

//==== Atomic request with specified sequence address  ========

class srio_ll_atomic_req_with_addr_base_seq extends srio_ll_base_seq;
  `uvm_object_utils(srio_ll_atomic_req_with_addr_base_seq)
 
  srio_trans srio_trans_item;
  rand bit  flag_0;
  rand bit  [3:0] ttype_0;
  rand bit  [3:0] ftype_0;
  logic wdptr_0;        
  logic [3:0] wrsize_1;  
  logic [3:0] rdsize_1;
  logic [29:0] address_0;

function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
   	flag_0 = $urandom;
    if(flag_0 == 1)
     begin
      ftype_0 = 2;
      ttype_0 = $urandom_range(15,12);
     end
    else
     begin
      ftype_0 = 5;
      ttype_0 = $urandom_range(14,12);
     end
	
    srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
    srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.rdsize_0.constraint_mode(0);
	srio_trans_item.Ftype_8.constraint_mode(0);
 
    //Data_Streaming_Logical_Layer_Control_CSR
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype == ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     address == address_0;
     ext_address == 0;
     xamsbs == 0;
     });
     if(ftype_0 == 5)
     begin
     for(int i=0; i<4; i++)
       begin
       srio_trans_item.payload.push_back(i);
       end
      end
     srio_trans_item.print();
  	 finish_item(srio_trans_item);

endtask

endclass : srio_ll_atomic_req_with_addr_base_seq

//==== Request with specified sequence address  ========

class srio_ll_req_with_addr_base_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_req_with_addr_base_seq)
 
  srio_trans srio_trans_item;
  rand bit  [3:0] ttype_0;
  rand bit  [3:0] ftype_0;
  logic wdptr_0;        
  logic [3:0] wrsize_1;  
  logic [3:0] rdsize_1;
  logic [29:0] address_0;
  rand bit [1:0] ftype_rand;
  rand bit [1:0] ttype_rand;

function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
      ftype_rand = $urandom;
      ttype_rand = $urandom;
      if(ftype_rand == 0)
        begin
          ftype_0 = 2;
          if(ttype_rand == 0)
          ttype_0 = $urandom_range(15,12);
          else
          ttype_0 = 4;
         end
       else if (ftype_rand == 1)
         begin
          ftype_0 = 5;
          if(ttype_rand == 0)
          ttype_0 = $urandom_range(14,12);
          else
          ttype_0 = $urandom_range(4,5);
         end
       else
         begin
          ftype_0 = 6;
         end
    srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
    srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.rdsize_0.constraint_mode(0);
	srio_trans_item.Ftype_8.constraint_mode(0);
 
    //Data_Streaming_Logical_Layer_Control_CSR
    start_item(srio_trans_item);
	assert(srio_trans_item.randomize() with {
     ftype == ftype_0 ;
     ttype == ttype_0 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     address == address_0;
     ext_address == 0;
     xamsbs == 0;
     });
     srio_trans_item.print();
  	 finish_item(srio_trans_item);

endtask

endclass : srio_ll_req_with_addr_base_seq

//========= IO RANDOM SEQUENCE =========

class srio_ll_io_random_req_base_seq extends srio_ll_base_seq;
    `uvm_object_utils(srio_ll_io_random_req_base_seq)

   srio_trans srio_trans_item;

  rand bit [3:0] ftype_0;
  rand bit [3:0] ttype_0;
  rand bit[2:0] flag;
  rand bit sel;
      function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
	
     srio_trans_item = srio_trans::type_id::create("srio_trans_item");	
     srio_trans_item.Ftype.constraint_mode(0);
     srio_trans_item.Ttype.constraint_mode(0);
     flag = $urandom;
     sel = $urandom;

     // Ftype 
     if(flag == 0)
       begin
         ftype_0 = 2;
         ttype_0 = 4;
       end
     else if (flag == 1)
       begin
         ftype_0 = 2;
         ttype_0 = $urandom_range(15,12);
       end
     else if (flag == 2)
       begin
         ftype_0 = 5;
         ttype_0 = sel ? $urandom_range(14,12):$urandom_range(5,4);
       end
     else
       begin
         ftype_0 = 8;
         ttype_0 = $urandom_range(1,0);
       end


     start_item(srio_trans_item);
     if(ftype_0 == 4'h6 )
     assert(srio_trans_item.randomize() with {ftype ==ftype_0 ;});  
     else 
     assert(srio_trans_item.randomize() with {ftype ==ftype_0 ;ttype == ttype_0;});  
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " RANDOM I0  Transcation"),UVM_LOW); end 
       srio_trans_item.print();

        finish_item(srio_trans_item);
  endtask

endclass : srio_ll_io_random_req_base_seq

//======= MESSAGE REQ SEQUENCE WITH LETTER AND MBOX VALUE =======

class srio_ll_msg_same_mbox_letter_req_base_seq extends srio_ll_base_seq;
`uvm_object_utils(srio_ll_msg_same_mbox_letter_req_base_seq)
 srio_trans srio_trans_item;

  rand bit [3:0] ftype_0;
  rand bit [1:0] mbox_0;
  rand bit [1:0] letter_0;
  rand bit [31:0] SourceID_0;
  rand bit [31:0] DestinationID_0;

  function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
    SourceID_0 = $urandom;
    DestinationID_0 = $urandom;	
    srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ftype_B_1.constraint_mode(0);
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt =1;
    assert(srio_trans_item.randomize() with {ftype == ftype_0;mbox == mbox_0;letter == letter_0;ssize == 4'b1110;msg_len == 4'd4;msgseg_xmbox == 0;SourceID == SourceID_0;DestinationID == DestinationID_0;});
      for(int i=0; i<256; i++)
      begin
       srio_trans_item.payload.push_back(i);
      end
    begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "Message request packet Transcation SEG-1"),UVM_LOW); end
    srio_trans_item.print();
    finish_item(srio_trans_item);
    srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ftype_B_1.constraint_mode(0);
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt =1;
    assert(srio_trans_item.randomize() with {ftype == ftype_0;mbox == mbox_0;letter == letter_0;ssize == 4'b1110;msg_len == 4'd4;msgseg_xmbox == 1;SourceID == SourceID_0;DestinationID == DestinationID_0;});
      for(int i=0; i<256; i++)
      begin
       srio_trans_item.payload.push_back(i);
      end
    begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "Message request packet Transcation SEG-2"),UVM_LOW); end
    srio_trans_item.print();
    finish_item(srio_trans_item);
    srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ftype_B_1.constraint_mode(0);
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt =1;
    assert(srio_trans_item.randomize() with {ftype == ftype_0;mbox == mbox_0;letter == letter_0;ssize == 4'b1110;msg_len == 4'd4;msgseg_xmbox == 2;SourceID == SourceID_0;DestinationID == DestinationID_0;});
      for(int i=0; i<256; i++)
      begin
       srio_trans_item.payload.push_back(i);
      end
    begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "Message request packet Transcation SEG-3"),UVM_LOW); end
    srio_trans_item.print();
    finish_item(srio_trans_item);
    srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ftype_B_1.constraint_mode(0);
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt =1;
    assert(srio_trans_item.randomize() with {ftype == ftype_0;mbox == mbox_0;letter == letter_0;ssize == 4'b1110;msg_len == 4'd4;msgseg_xmbox == 3;SourceID == SourceID_0;DestinationID == DestinationID_0;});
      for(int i=0; i<256; i++)
      begin
       srio_trans_item.payload.push_back(i);
      end
    begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "Message request packet Transcation SEG-4"),UVM_LOW); end
    srio_trans_item.print();
    finish_item(srio_trans_item);
    srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ftype_B_1.constraint_mode(0);
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt =1;
    assert(srio_trans_item.randomize() with {ftype == ftype_0;mbox == mbox_0;letter == letter_0;ssize == 4'b1110;msg_len == 4'd4;msgseg_xmbox == 4;SourceID == SourceID_0;DestinationID == DestinationID_0;});
      for(int i=0; i<256; i++)
      begin
       srio_trans_item.payload.push_back(i);
      end
    begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "Message request packet Transcation SEG-5"),UVM_LOW); end
    srio_trans_item.print();
    finish_item(srio_trans_item);

  endtask
endclass : srio_ll_msg_same_mbox_letter_req_base_seq

//DS MULTI SEGEMENT SEQUENCES WITH SPECIFIC COS FIELD

 class srio_ll_ds_mseg_with_speci_cos_req_base_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_ds_mseg_with_speci_cos_req_base_seq)

  srio_trans srio_trans_item;
   rand bit [15:0] pdulength_0;
   rand bit [7:0] mtusize_0; 
   rand bit [31:0] read_data;
   rand bit [31:0] SourceID_0;
   rand bit [31:0] DestinationID_0;
 function new(string name="");
    super.new(name);
  endfunction

virtual task body();
    mtusize_0 = 32'd64;
    SourceID_0 = $urandom;
    DestinationID_0 = $urandom;
   `uvm_info("MTU SIZE VALUE",$sformatf("The randomized value of mtusize_0 is %0b",mtusize_0),UVM_LOW)
	pdulength_0 = 32'd1024;
   begin //{
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
      srio_trans_item.Ftype.constraint_mode(0);
      srio_trans_item.Ftype_9.constraint_mode(0);
	  srio_trans_item.Xh.constraint_mode(0);
      srio_trans_item.Ftype_9A.constraint_mode(0);
      srio_trans_item.streamid.constraint_mode(0);
      start_item(srio_trans_item);
      srio_trans_item.usr_gen_pkt =1;
      assert(srio_trans_item.randomize() with {ftype ==4'h9 ;cos == 8'h1f; P == 0 ;O == 0;xh==1'b0;streamID == 0;{S,E} == 2'b10;pdulength == pdulength_0;mtusize == mtusize_0; SourceID == SourceID_0;DestinationID == DestinationID_0;});
      for(int i=0; i<256; i++)
      begin
       srio_trans_item.payload.push_back(i);
      end
         `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DS Start of packets"),UVM_LOW);
	  srio_trans_item.print();
	  finish_item(srio_trans_item);
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
      srio_trans_item.Ftype.constraint_mode(0);
      srio_trans_item.Ftype_9.constraint_mode(0);
	  srio_trans_item.Xh.constraint_mode(0);
      srio_trans_item.Ftype_9A.constraint_mode(0);
      srio_trans_item.streamid.constraint_mode(0);
      start_item(srio_trans_item);
      srio_trans_item.usr_gen_pkt =1;
      assert(srio_trans_item.randomize() with {ftype ==4'h9 ;cos == 8'h1f; P == 0 ;O == 0;xh==1'b0;streamID == 0;{S,E} == 2'b00;pdulength == pdulength_0;mtusize == mtusize_0; SourceID == SourceID_0;DestinationID == DestinationID_0;});
      begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DS Middle segment"),UVM_LOW); end
      for(int i=0; i<256; i++)
      begin
       srio_trans_item.payload.push_back(i);
      end
	  srio_trans_item.print();

	  finish_item(srio_trans_item);
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
      srio_trans_item.Ftype.constraint_mode(0);
      srio_trans_item.Ftype_9.constraint_mode(0);
	  srio_trans_item.Xh.constraint_mode(0);
      srio_trans_item.Ftype_9A.constraint_mode(0);
      srio_trans_item.streamid.constraint_mode(0);
      start_item(srio_trans_item);
      srio_trans_item.usr_gen_pkt =1;
      assert(srio_trans_item.randomize() with {ftype ==4'h9 ;cos == 8'h1f; P == 0 ;O == 0;xh==1'b0;streamID == 0;{S,E} == 2'b00;pdulength == pdulength_0;mtusize == mtusize_0; SourceID == SourceID_0;DestinationID == DestinationID_0;});
      begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DS Middle segment"),UVM_LOW); end
      for(int i=0; i<256; i++)
      begin
       srio_trans_item.payload.push_back(i);
      end
	  srio_trans_item.print();

	  finish_item(srio_trans_item);
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
      srio_trans_item.Ftype.constraint_mode(0);
      srio_trans_item.Ftype_9.constraint_mode(0);
	  srio_trans_item.Xh.constraint_mode(0);
      srio_trans_item.Ftype_9A.constraint_mode(0);
      srio_trans_item.streamid.constraint_mode(0);
      start_item(srio_trans_item);
      srio_trans_item.usr_gen_pkt =1;
      assert(srio_trans_item.randomize() with {ftype ==4'h9 ;cos == 8'h1f; P == 0 ;O == 0;xh==1'b0;streamID == 0;{S,E} == 2'b01;pdulength == pdulength_0;mtusize == mtusize_0; SourceID == SourceID_0;DestinationID == DestinationID_0;});
      begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DS Middle segment"),UVM_LOW); end
      for(int i=0; i<256; i++)
      begin
       srio_trans_item.payload.push_back(i);
      end
	  srio_trans_item.print();

	  finish_item(srio_trans_item);
	end //}

	#1000ns;
endtask 
endclass :srio_ll_ds_mseg_with_speci_cos_req_base_seq
	
//====DEFAULT SEQUENCE ====

class srio_ll_default_reset_base_seq extends srio_ll_base_seq;
    `uvm_object_utils(srio_ll_default_reset_base_seq)

    srio_trans srio_trans_item;
    rand bit [7:0] mtusize_0;
    rand bit [3:0] TMOP_0;
 
    function new(string name="");
    super.new(name);
    endfunction

  virtual task body();

      // Random Packet
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
      srio_trans_item.Tmop.constraint_mode(0);
     
      start_item(srio_trans_item);
      assert(srio_trans_item.randomize() with { mtusize == mtusize_0 ;TMOP == TMOP_0;});
      srio_trans_item.print();
      finish_item(srio_trans_item);
     endtask

endclass :srio_ll_default_reset_base_seq

//====DEFAULT SEQUENCE  For Standalone setup ====

class srio_ll_standalone_default_class_seq extends srio_ll_base_seq;
    `uvm_object_utils(srio_ll_standalone_default_class_seq)

    srio_trans srio_trans_item;
    rand bit [7:0] mtusize_0;
    rand bit [3:0] ftype_0;
    rand bit [3:0] ttype_0;
    rand bit [3:0] ftype_rand;
    rand bit [3:0] ttype_rand;
    function new(string name="");
    super.new(name);
    endfunction

  virtual task body();

      // Random Packet
      srio_trans_item = srio_trans::type_id::create("srio_trans_item");
     
      start_item(srio_trans_item);
     srio_trans_item.Ftype.constraint_mode(0);
     srio_trans_item.Ttype.constraint_mode(0);
     srio_trans_item.Xh.constraint_mode(0);
     ftype_rand = $urandom_range(1,6);
    if(ftype_rand == 1)
     begin
          ttype_rand = $urandom_range(4,1);
          ftype_0 = 4'h2;
          if(ttype_rand == 1)
            ttype_0 = 4'hc;
          else if(ttype_rand == 2)
             ttype_0 = 4'hd;
          else if(ttype_rand == 3)
             ttype_0 = 4'he;
          else if(ttype_rand == 4)
             ttype_0 = 4'hf;
          else if(ttype_rand == 4)
             ttype_0 = 4'h4;
     end
    else if(ftype_rand == 2)
       begin
         ttype_rand = $urandom_range(2,1);
         ftype_0 = 4'h5;
         if(ttype_rand == 1)
           ttype_0 = 4'h4;
         else if(ttype_rand == 2)
           ttype_0 = 4'h5;
       end
    else if(ftype_rand == 3)
       begin
         ftype_0 = 4'h6;
       end
    else if(ftype_rand == 4)
       begin
         ftype_0 = 4'h9;
       end
    else if(ftype_rand == 5)
        begin
          ftype_0 = 4'ha;
        end
    else if(ftype_rand == 6)
        begin
          ftype_0 = 4'hb;
        end
      assert(srio_trans_item.randomize() with { mtusize == mtusize_0 ;ftype == ftype_0;ttype == ttype_0;xh == 0;});
      srio_trans_item.print();
      finish_item(srio_trans_item);
      #100ns;
     endtask

endclass :srio_ll_standalone_default_class_seq

//========== Maintenance Request with variable config offset =========
class srio_ll_maintenance_req_config_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_maintenance_req_config_seq)
   srio_trans srio_trans_item;

  rand bit [3:0] ttype_0;
  rand bit [3:0] ftype_0;
  rand bit [20:0] config_offset_0 ;
  rand bit [31:0] read_data;   

function new(string name="");
    super.new(name);
endfunction

  virtual task body();
		
  	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
	srio_trans_item.Ftype_8.constraint_mode(0);
    srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.rdsize_0.constraint_mode(0);
    srio_trans_item.usr_gen_pkt = 1;	
    start_item(srio_trans_item);
	assert(srio_trans_item.randomize() with {ftype ==ftype_0 ;ttype == ttype_0 ;config_offset == config_offset_0;wrsize == 4'h8;rdsize == 4'h8;wdptr == 1'b0;});
     read_data[23:0] = 24'h10_0000;
     srio_trans_item.payload.push_back(read_data[31:24]);
     srio_trans_item.payload.push_back(read_data[23:16]);
     srio_trans_item.payload.push_back(read_data[15:8]);
     srio_trans_item.payload.push_back(read_data[7:0]);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h80);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);

	
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE REQUEST Transcation"),UVM_LOW); end

      	srio_trans_item.print();

       	finish_item(srio_trans_item);

	
  endtask
endclass : srio_ll_maintenance_req_config_seq


//================MAINTENANCE WRITE with config offset to configure PLTOCCSR-lower & PRTOCCSR-higer value ====
class srio_ll_maintenance_req_timeout_config_seq extends srio_ll_base_seq;

  `uvm_object_utils(srio_ll_maintenance_req_timeout_config_seq)
   srio_trans srio_trans_item;

  rand bit [3:0] ttype_0;
  rand bit [3:0] ftype_0;
  rand bit [20:0] config_offset_0 ;
  rand bit [31:0] read_data;   

function new(string name="");
    super.new(name);
endfunction

  virtual task body();
		
  	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
	srio_trans_item.Ftype_8.constraint_mode(0);
    srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.rdsize_0.constraint_mode(0);
    srio_trans_item.usr_gen_pkt = 1;	
    start_item(srio_trans_item);
	assert(srio_trans_item.randomize() with {ftype ==ftype_0 ;ttype == ttype_0 ;config_offset == config_offset_0;wrsize == 4'h8;rdsize == 4'h8;wdptr == 1'b0;});
     read_data[23:0] = 24'h10_0000;
     srio_trans_item.payload.push_back(read_data[31:24]);
     srio_trans_item.payload.push_back(read_data[23:16]);
     srio_trans_item.payload.push_back(read_data[15:8]);
     srio_trans_item.payload.push_back(read_data[7:0]);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h80);
     srio_trans_item.payload.push_back(8'h00);
     srio_trans_item.payload.push_back(8'h00);

	
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE REQUEST Transcation"),UVM_LOW); end

      	srio_trans_item.print();

       	finish_item(srio_trans_item);

	
  endtask
endclass : srio_ll_maintenance_req_timeout_config_seq

//======= Nwrite R  response user defined sequence =======

class srio_ll_nwrite_r_usr_resp_seq extends srio_ll_base_seq;
  `uvm_object_utils(srio_ll_nwrite_r_usr_resp_seq)
  srio_trans srio_trans_item;

  rand bit [3:0] ttype_0;
  rand bit [3:0] ftype_0;
  int targetID_Info_0;
   
function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
		
      	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.trans_status_c.constraint_mode(0);
    srio_trans_item.prior.constraint_mode(0);
    srio_trans_item.Ftype_8.constraint_mode(0);
     	
        start_item(srio_trans_item);
	assert(srio_trans_item.randomize() with {ftype ==ftype_0 ;trans_status == 0 ;prio == 2;crf == 0;targetID_Info == targetID_Info_0;});

	
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "NWRITE_R response"),UVM_LOW); end

      	srio_trans_item.print();

       	finish_item(srio_trans_item);

	
  endtask
endclass : srio_ll_nwrite_r_usr_resp_seq
//========= REQUEST SEQUENCE =========
class srio_ll_request_wrsize_wdptr_class_seq extends srio_ll_base_seq;
    `uvm_object_utils(srio_ll_request_wrsize_wdptr_class_seq)
   srio_trans srio_trans_item;
  rand bit [3:0] ftype_0;
  rand bit [3:0] ttype_0;
      function new(string name="");
    super.new(name);
  endfunction
  virtual task body();
     srio_trans_item = srio_trans::type_id::create("srio_trans_item");	
     srio_trans_item.Ftype.constraint_mode(0);
     srio_trans_item.Ttype.constraint_mode(0);
    srio_trans_item.wrsize_0.constraint_mode(0);     
      start_item(srio_trans_item);
     assert(srio_trans_item.randomize() with {ftype ==ftype_0 ;ttype == ttype_0;wrsize == 'hd;wdptr == 1'b1;});  
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " REQUEST CLASS Transcation"),UVM_LOW); end
        srio_trans_item.print();
        finish_item(srio_trans_item);
  endtask
endclass : srio_ll_request_wrsize_wdptr_class_seq
//================NWRITE_R and NREAD_R  SEQUENCE FOR 34 BIT ADDRESSING ============
class srio_ll_nwrite_nread_pld_print_cb_seq extends srio_ll_base_seq;
  `uvm_object_utils(srio_ll_nwrite_nread_pld_print_cb_seq)
  srio_trans srio_trans_item;
  logic [3:0] ttype_0;
  logic [3:0] ftype_0;
  logic wdptr_0;        
  logic [3:0] wrsize_1;  
  logic [3:0] rdsize_1;
  logic [20:0] config_offset_0 ;
  logic [7:0] targetID_Info_0;
  logic [29:0] address_0;
  logic [31:0] write_data;
  logic [31:0] read1_data;
  logic [31:0] read2_data;
  logic [7:0] expected_payload[$];
  logic [31:0] expected_write;
  logic [31:0] expected_write1;
  logic [13:0] g;
function new(string name="");
    super.new(name);
  endfunction
task byte_reverse(input logic [31:0] a);
  logic [7:0] b,c,d,e;
  b  = {a[24],a[25],a[26],a[27],a[28],a[29],a[30],a[31]};
  c  = {a[16],a[17],a[18],a[19],a[20],a[21],a[22],a[23]};
  d  = {a[8],a[9],a[10],a[11],a[12],a[13],a[14],a[15]};
  e  = {a[0],a[1],a[2],a[3],a[4],a[5],a[6],a[7]};
  expected_write1 = {b,c,d,e};
endtask
  virtual task body();
    srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
    srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.rdsize_0.constraint_mode(0);
	srio_trans_item.Ftype_8.constraint_mode(0);
    srio_reg_model.Processing_Element_Logical_Layer_Control_CSR.Extended_addressing_control.set(3'b100);
      //Data_Streaming_Logical_Layer_Control_CSR
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
	assert(srio_trans_item.randomize() with {
     ftype == 4'h5 ;
     ttype == 4'h5 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     address == address_0;
     xamsbs == 0;
     });
     for(int i=0; i<8; i++)
       begin
       srio_trans_item.payload.push_back(i);
          expected_payload.push_back(i);
       end
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "NWRITE-READ WR Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
            write_data = srio_reg_model.Data_Streaming_Logical_Layer_Control_CSR.get();   
     expected_write[31:24] = expected_payload.pop_front;
     expected_write[23:16] = expected_payload.pop_front;
     expected_write[15:8] = expected_payload.pop_front;
     expected_write[7:0] = expected_payload.pop_front;
     expected_payload.delete();
     byte_reverse(expected_write);
    start_item(srio_trans_item);
    srio_trans_item.usr_gen_pkt = 1;
    assert(srio_trans_item.randomize() with {
     ftype ==2 ;
     ttype == 4 ;
     rdsize == rdsize_1;
     wrsize == wrsize_1 ;
     wdptr == wdptr_0;
     address == address_0;
     xamsbs == 0;
     });
       srio_trans_item.payload.delete();
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "MAINTENANCE WRITE-READ RD Transcation"),UVM_LOW); end
      	srio_trans_item.print();
       	finish_item(srio_trans_item);
      #500ns;
endtask
endclass : srio_ll_nwrite_nread_pld_print_cb_seq
//======= MESSAGE REQ SEQUENCE For RAB UVM setup =======
class srio_ll_rab_message_req_seq extends srio_ll_base_seq;
`uvm_object_utils(srio_ll_rab_message_req_seq)
 srio_trans srio_trans_item;

  rand bit [3:0] ftype_0;
  rand bit [3:0] ssize_0;
  rand bit [3:0] letter_0;
  rand bit [3:0] mbox_0;
  int  message_length_0;
  function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
	
        srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ftype_B_1.constraint_mode(0);
        
        start_item(srio_trans_item);

	assert(srio_trans_item.randomize() with {ftype == ftype_0;letter == letter_0;mbox == mbox_0;msgseg_xmbox == 0;});

         begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "Message request packet Transcation"),UVM_LOW); end

         srio_trans_item.print();

         finish_item(srio_trans_item);

  endtask
   endclass : srio_ll_rab_message_req_seq
//=====DS INTERLEAVED PACKET =======

class srio_ll_rab_ds_interleaved_base_seq extends srio_ll_base_seq;
  `uvm_object_utils(srio_ll_rab_ds_interleaved_base_seq)
  srio_trans srio_trans_item;

  
   rand bit [15:0] pdulength_0;
   rand bit [7:0] mtusize_0; 
   bit [7:0] cos_0;
   bit [15:0] srcid_0;
   
   function new(string name="");
    super.new(name);
   endfunction

 virtual task body();
	
        srio_trans_item = srio_trans::type_id::create("srio_trans_item");

	//Data streaming Packet

	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ftype_9.constraint_mode(0);
	srio_trans_item.Xh.constraint_mode(0);
	
	start_item(srio_trans_item);
        srio_trans_item.usr_gen_pkt =0;
        assert(srio_trans_item.randomize() with {
	ftype ==4'h9 ;
	xh==1'b0;
	mtusize == mtusize_0;
	pdulength ==pdulength_0 ;
    cos == cos_0;
    SourceID == srcid_0;
	});
	srio_trans_item.print();

	begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( "DATA STREAMING REQUEST FOR INTERLEAVED PACKET Transcation"),UVM_LOW); end

       finish_item(srio_trans_item);
        #100ns;
     	 endtask 
endclass :srio_ll_rab_ds_interleaved_base_seq

//========= NWRITE WITH MAXIMUM 256 BYTES SEQUENCE =========

class srio_ll_nwrite_max_pkt_size_class_seq extends srio_ll_base_seq;
    `uvm_object_utils(srio_ll_nwrite_max_pkt_size_class_seq)

   srio_trans srio_trans_item;

  rand bit [3:0] ftype_0;
  rand bit [3:0] ttype_0;
      function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
     srio_trans_item = srio_trans::type_id::create("srio_trans_item");	
     srio_trans_item.Ftype.constraint_mode(0);
     srio_trans_item.Ttype.constraint_mode(0);
    srio_trans_item.wrsize_0.constraint_mode(0);     
      start_item(srio_trans_item);
     assert(srio_trans_item.randomize() with {ftype ==ftype_0 ;ttype == ttype_0;wrsize == 'hf;wdptr == 1'b1;});  
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " REQUEST CLASS Transcation"),UVM_LOW); end
        srio_trans_item.print();
        finish_item(srio_trans_item);
  endtask

endclass : srio_ll_nwrite_max_pkt_size_class_seq


class srio_ll_msg_same_letter_mbox_diff_src_id_seq extends srio_ll_base_seq;
`uvm_object_utils(srio_ll_msg_same_letter_mbox_diff_src_id_seq)
 srio_trans srio_trans_item;

  rand bit [3:0] ftype_0;
  rand bit [3:0] letter_0;
  rand bit [3:0] mbox_0;
  rand bit [31:0] SourceID_0;
  rand bit [3:0] msg_len_0;
  rand bit [3:0] ssize_0;
  int seg_size;
  int message_length_0;
  function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
	
  srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ftype_B_1.constraint_mode(0);
	srio_trans_item.Ftype_B_2.constraint_mode(0);
  srio_trans_item.Ftype_B.constraint_mode(0);
       
  ssize_0   = $urandom_range(9, 14);
  case (ssize_0)
          9 : message_length_0 = $urandom_range(2, 16);
          10 : message_length_0 = $urandom_range(3, 32);
          11 : message_length_0 = $urandom_range(5, 64);
          12 : message_length_0 = $urandom_range(9, 128);
          13 : message_length_0 = $urandom_range(17, 256);
          14 : message_length_0 = $urandom_range(33, 512);
  endcase 

  start_item(srio_trans_item);

	assert(srio_trans_item.randomize() with {ftype == ftype_0;letter == letter_0;mbox == mbox_0; SourceID == SourceID_0; 
  message_length == message_length_0; ssize == ssize_0;});

  begin  `uvm_info("srio_ll_msg_same_letter_mbox_diff_src_id_seq",$sformatf( " msg len %h, ssize %h, message length %h", msg_len_0,ssize_0,message_length_0),UVM_LOW); end

  srio_trans_item.print();

  finish_item(srio_trans_item);


  endtask
endclass : srio_ll_msg_same_letter_mbox_diff_src_id_seq

//========= REQUEST SEQUENCE FOR NREAD NWRITE SWRITE NWRITE_R =========

class srio_ll_rand_write_read_seq extends srio_ll_base_seq;
    `uvm_object_utils(srio_ll_rand_write_read_seq)

   srio_trans srio_trans_item;
  rand bit [1:0] pkt_sel;
  bit [3:0] ftype_0;
  bit [3:0] ttype_0;
      function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
     srio_trans_item = srio_trans::type_id::create("srio_trans_item");	
     srio_trans_item.Ftype.constraint_mode(0);
     srio_trans_item.Ttype.constraint_mode(0);
     pkt_sel = $urandom_range(0,3); 
     if(pkt_sel == 0)
      begin
       ftype_0 = 5;
       ttype_0 = 4;
      end
     else if(pkt_sel == 1)
      begin
       ftype_0 = 5;
       ttype_0 = 5;
      end
     else if(pkt_sel == 2)
      begin
       ftype_0 = 6;
       ttype_0 = 0;
      end
     else if(pkt_sel == 3)
      begin
       ftype_0 = 2;
       ttype_0 = 4;
      end

      start_item(srio_trans_item);
     assert(srio_trans_item.randomize() with {ftype ==ftype_0 ;ttype == ttype_0;});  
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " REQUEST CLASS Transcation"),UVM_LOW); end
        srio_trans_item.print();
        finish_item(srio_trans_item);
  endtask

endclass : srio_ll_rand_write_read_seq

//========= REQUEST SEQUENCE with user defined wrsize and wdptr =========

class srio_ll_req_usr_wrsize_wdptr_class_seq extends srio_ll_base_seq;
    `uvm_object_utils(srio_ll_req_usr_wrsize_wdptr_class_seq)

   srio_trans srio_trans_item;

  rand bit [3:0] ftype_0;
  rand bit [3:0] ttype_0;
  bit wdptr_1;
  bit [3:0] wrsize_1;
  int payload_size_0; 
      function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
     srio_trans_item = srio_trans::type_id::create("srio_trans_item");	
     srio_trans_item.Ftype.constraint_mode(0);
     srio_trans_item.Ttype.constraint_mode(0);
     srio_trans_item.wrsize_0.constraint_mode(0);     
     start_item(srio_trans_item);
     srio_trans_item.usr_gen_pkt = 1;
     assert(srio_trans_item.randomize() with {ftype ==ftype_0 ;ttype == ttype_0;wrsize == wrsize_1;wdptr == wdptr_1;});
      for(int i=0; i<payload_size_0; i++)
      begin
       srio_trans_item.payload.push_back(i);
      end  
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " REQUEST CLASS Transcation"),UVM_LOW); end
        srio_trans_item.print();
        finish_item(srio_trans_item);
  endtask

endclass : srio_ll_req_usr_wrsize_wdptr_class_seq
