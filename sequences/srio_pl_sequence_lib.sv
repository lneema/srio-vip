
////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_sequence_lib.sv
// Project :  srio vip
// Purpose :  Physical layer sequences 
// Author  :  Mobiveil
//
// All Physical layer sequences.
//
////////////////////////////////////////////////////////////////////////////////
class srio_pl_base_seq extends uvm_sequence#(srio_trans);

  `uvm_object_utils(srio_pl_base_seq)

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

endclass : srio_pl_base_seq

class srio_pl_control_base_seq extends srio_pl_base_seq ; //{

    `uvm_object_utils(srio_pl_control_base_seq)

    srio_trans srio_trans_item;

      bit [0:3]stype0_1; 
      bit [0:11] param0_1;
      bit [0:11] param1_1;
       
	function new(string name="");
   	 super.new(name);
  	endfunction

  	virtual task body();  //{

        srio_trans_item = srio_trans::type_id::create("srio_trans_item");
        srio_trans_item.Stype0.constraint_mode(0); 
       	srio_trans_item.pkt_type = SRIO_PL_PACKET;
	srio_trans_item.transaction_kind = SRIO_CS;
	srio_trans_item.stype0 = stype0_1;
	srio_trans_item.param0 = param0_1;
	srio_trans_item.param1 = param1_1;
	srio_trans_item.delimiter = 8'h1C;

      	start_item(srio_trans_item); //{	  
       finish_item(srio_trans_item); //}
       
	endtask  //}
	endclass :srio_pl_control_base_seq //}

   //==Stype 1 CS


    class srio_pl_stype1_cs_seq extends srio_pl_base_seq ; //{
 
 `uvm_object_utils(srio_pl_stype1_cs_seq)

    srio_trans srio_trans_item;
      rand bit flag;
      bit [0:3]stype0_1; 
      bit [0:11] param0_1;
      bit [0:11] param1_1; 
      bit [0:3]  stype1_1;
      bit [0:3] cmd_1;
      bit [0:7] set_delim_1;
	function new(string name="");
   	 super.new(name);
  	endfunction

  	virtual task body();  //{

     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
        
	srio_trans_item.Stype1.constraint_mode(0);
	srio_trans_item.Stype1_const.constraint_mode(0); 
       	srio_trans_item.pkt_type = SRIO_PL_PACKET;
	srio_trans_item.transaction_kind = SRIO_CS;
  
        if(stype1_1 == 4'b0000)
        srio_trans_item.brc3_stype1_msb= flag ? 2'b10 : 2'b11;
        srio_trans_item.stype1 = stype1_1;
	srio_trans_item.cmd    = cmd_1;
       	srio_trans_item.param1 = param1_1; 
      	start_item(srio_trans_item); //{
        	  
        finish_item(srio_trans_item); //}
 
      		endtask //}

endclass :srio_pl_stype1_cs_seq  //}     

//DISCOVERY TO NXMODE STATE 

class srio_pl_dis_nxmode_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_dis_nxmode_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;
 
	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{

        if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    	`uvm_fatal("Config Fatal", "Can't get the env_config")

     	srio_reg_model = env_config.srio_reg_model_rx;

     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	      	
	srio_trans_item.transaction_kind = SRIO_STATE_MC;
	srio_trans_item.next_state = NX_MODE;
	
        srio_trans_item.Ftype.constraint_mode(0);
        srio_trans_item.Ttype.constraint_mode(0);
     
        start_item(srio_trans_item);
        
        finish_item(srio_trans_item);	
	
	
	endtask //}



endclass  : srio_pl_dis_nxmode_sm_base_seq //}

//DISCOVERY TO 2XMODE STATE 

class srio_pl_dis_2xmode_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_dis_2xmode_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;

	function new(string name="");
   	 super.new(name);
       	endfunction


  	virtual task body();  //{

	if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    	`uvm_fatal("Config Fatal", "Can't get the env_config")

   	srio_reg_model = env_config.srio_reg_model_rx;

     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
      	
	srio_trans_item.transaction_kind =SRIO_STATE_MC ;
	srio_trans_item.next_state = X2_MODE;

	start_item(srio_trans_item); //{
     	finish_item(srio_trans_item); //}
	
	endtask //}



endclass  : srio_pl_dis_2xmode_sm_base_seq //}


//DISCOVERY TO 1XMODE LANE_0 STATE 

class srio_pl_dis_1xmode_ln0_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_dis_1xmode_ln0_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;

	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{
	if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    `uvm_fatal("Config Fatal", "Can't get the env_config")

   	srio_reg_model = env_config.srio_reg_model_rx;

     	 srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	
	srio_trans_item.transaction_kind =SRIO_STATE_MC ;
	srio_trans_item.next_state = X1_M0;
	
	start_item(srio_trans_item); //{
     	finish_item(srio_trans_item); //}
	
	endtask //}



endclass  : srio_pl_dis_1xmode_ln0_sm_base_seq //}


//DISCOVERY TO 1XMODE LANE_1 STATE 

class srio_pl_dis_1xmode_ln1_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_dis_1xmode_ln1_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;

   function new(string name="");
   super.new(name);
   endfunction

  	virtual task body();  //{

	if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    `uvm_fatal("Config Fatal", "Can't get the env_config")

   	srio_reg_model = env_config.srio_reg_model_rx;
	
     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	
	srio_trans_item.transaction_kind =SRIO_STATE_MC ;
	srio_trans_item.next_state = X1_M1;
	
	start_item(srio_trans_item); //{
     	finish_item(srio_trans_item); //}
	
	endtask //}



endclass  : srio_pl_dis_1xmode_ln1_sm_base_seq //}

//DISCOVERY TO 1XMODE LANE_2 STATE 

class srio_pl_dis_1xmode_ln2_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_dis_1xmode_ln2_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;

	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{

	if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    `uvm_fatal("Config Fatal", "Can't get the env_config")

   	srio_reg_model = env_config.srio_reg_model_rx;
     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
      	
	srio_trans_item.transaction_kind =SRIO_STATE_MC ;
	srio_trans_item.next_state = X1_M2;
	
	start_item(srio_trans_item); //{
     	finish_item(srio_trans_item); //}
	
	endtask //}



endclass  : srio_pl_dis_1xmode_ln2_sm_base_seq //}

//1XMODE LANE_0 TO 1XMODE LANE_1 STATE 

class srio_pl_1xmode_ln0_1xmode_ln1_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_1xmode_ln0_1xmode_ln1_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;

   function new(string name="");
   super.new(name);
   endfunction

  	virtual task body();  //{

	if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    `uvm_fatal("Config Fatal", "Can't get the env_config")

   	srio_reg_model = env_config.srio_reg_model_rx;
	
     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	
	srio_trans_item.transaction_kind =SRIO_STATE_MC ;
	srio_trans_item.next_state = X1_M1;
	
	start_item(srio_trans_item); //{
     	finish_item(srio_trans_item); //}
	
	endtask //}



endclass  : srio_pl_1xmode_ln0_1xmode_ln1_sm_base_seq //}

//1XMODE LANE_0 TO 1XMODE LANE_2 STATE 

class srio_pl_1xmode_ln0_1xmode_ln2_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_1xmode_ln0_1xmode_ln2_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;

	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{

	if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    `uvm_fatal("Config Fatal", "Can't get the env_config")

   	srio_reg_model = env_config.srio_reg_model_rx;
     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
      	
	srio_trans_item.transaction_kind =SRIO_STATE_MC ;
	srio_trans_item.next_state = X1_M2;
	
	start_item(srio_trans_item); //{
     	finish_item(srio_trans_item); //}
	
	endtask //}



endclass  : srio_pl_1xmode_ln0_1xmode_ln2_sm_base_seq //}



//DISCOVERY TO SILENT STATE 

class srio_pl_dis_sl_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_dis_sl_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;

	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{
	if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    `uvm_fatal("Config Fatal", "Can't get the env_config")

   	srio_reg_model = env_config.srio_reg_model_rx;

     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
      	
	srio_trans_item.transaction_kind = SRIO_STATE_MC;
	srio_trans_item.next_state = SILENT;
	
	start_item(srio_trans_item); //{
     	finish_item(srio_trans_item); //}
	
	endtask //}



endclass  : srio_pl_dis_sl_sm_base_seq //}

// NXMODE TO SILENT STATE 

class srio_pl_nxmode_sl_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_nxmode_sl_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;

	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{

	if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    `uvm_fatal("Config Fatal", "Can't get the env_config")

   	srio_reg_model = env_config.srio_reg_model_rx;
     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	
	srio_trans_item.transaction_kind =SRIO_STATE_MC ;
	srio_trans_item.next_state = SILENT;
	
	start_item(srio_trans_item); //{
     	finish_item(srio_trans_item); //}
	
	endtask //}



endclass  : srio_pl_nxmode_sl_sm_base_seq //}

// NXMODE TO DISCOVERY STATE 

class srio_pl_nxmode_dis_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_nxmode_dis_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;

	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{
	if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    	`uvm_fatal("Config Fatal", "Can't get the env_config")

   	srio_reg_model = env_config.srio_reg_model_rx;

     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
      	
	srio_trans_item.transaction_kind = SRIO_STATE_MC;
	srio_trans_item.next_state =DISCOVERY ;
	
	start_item(srio_trans_item); //{
     	finish_item(srio_trans_item); //}
	
	endtask //}



endclass  : srio_pl_nxmode_dis_sm_base_seq //}

// 2XMODE TO SILENT STATE 

class srio_pl_2xmode_sl_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_2xmode_sl_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;
 
	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{
	if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    	`uvm_fatal("Config Fatal", "Can't get the env_config")

   	srio_reg_model = env_config.srio_reg_model_rx;

     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
      	
	srio_trans_item.transaction_kind =SRIO_STATE_MC ;
	srio_trans_item.next_state = SILENT;
	
	start_item(srio_trans_item); //{
     	finish_item(srio_trans_item); //}
	
	endtask //}



endclass  : srio_pl_2xmode_sl_sm_base_seq //}

// 2XMODE TO 1XMODE_LANE0 STATE 

class srio_pl_2xmode_1xmode_ln0_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_2xmode_1xmode_ln0_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;
 
	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{
	if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    	`uvm_fatal("Config Fatal", "Can't get the env_config")

   	srio_reg_model = env_config.srio_reg_model_rx;

     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
      	
	srio_trans_item.transaction_kind =SRIO_STATE_MC ;
	srio_trans_item.next_state =X1_M0;
	
	start_item(srio_trans_item); //{
     	finish_item(srio_trans_item); //}
	
	endtask //}



endclass  : srio_pl_2xmode_1xmode_ln0_sm_base_seq //}

// 2XMODE TO 1XMODE_LANE1 STATE 

class srio_pl_2xmode_1xmode_ln1_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_2xmode_1xmode_ln1_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;
 
	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{
	if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    	`uvm_fatal("Config Fatal", "Can't get the env_config")

   	srio_reg_model = env_config.srio_reg_model_rx;

     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
      	
	srio_trans_item.transaction_kind =SRIO_STATE_MC ;
	srio_trans_item.next_state =X1_M1;
	
	start_item(srio_trans_item); //{
     	finish_item(srio_trans_item); //}
	
	endtask //}



endclass  : srio_pl_2xmode_1xmode_ln1_sm_base_seq //}


// 2XMODE TO 2X RECOVERY STATE 

class srio_pl_2xmode_2x_rec_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_2xmode_2x_rec_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;

	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{
	if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    	`uvm_fatal("Config Fatal", "Can't get the env_config")

   	srio_reg_model = env_config.srio_reg_model_rx;

     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
      	
	srio_trans_item.transaction_kind = SRIO_STATE_MC;
	srio_trans_item.next_state = X2_RECOVERY;
	
	start_item(srio_trans_item); //{
     	finish_item(srio_trans_item); //}
	
	endtask //}



endclass  :srio_pl_2xmode_2x_rec_sm_base_seq //}

// 1XMODE LANE_0 TO SILENT STATE 

class srio_pl_1xmode_ln0_sl_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_1xmode_ln0_sl_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;

	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{

	if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    	`uvm_fatal("Config Fatal", "Can't get the env_config")

  	 srio_reg_model = env_config.srio_reg_model_rx;
     	 srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	
	srio_trans_item.transaction_kind =SRIO_STATE_MC ;
	srio_trans_item.next_state =SILENT ;	

	start_item(srio_trans_item); //{
     	finish_item(srio_trans_item); //}
	
	endtask //}



endclass  :srio_pl_1xmode_ln0_sl_sm_base_seq //}

// 1XMODE LANE_1 TO SILENT STATE 

class srio_pl_1xmode_ln1_sl_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_1xmode_ln1_sl_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;

	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{
	if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
   	 `uvm_fatal("Config Fatal", "Can't get the env_config")

   	srio_reg_model = env_config.srio_reg_model_rx;

     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
      	
	srio_trans_item.transaction_kind =SRIO_STATE_MC ;
	srio_trans_item.next_state =SILENT ;
	
	start_item(srio_trans_item); //{
     	finish_item(srio_trans_item); //}
	
	endtask //}



endclass  :srio_pl_1xmode_ln1_sl_sm_base_seq //}

// 1XMODE LANE_2 TO SILENT STATE 

class srio_pl_1xmode_ln2_sl_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_1xmode_ln2_sl_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;

	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{
	if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    	`uvm_fatal("Config Fatal", "Can't get the env_config")

   	srio_reg_model = env_config.srio_reg_model_rx;

     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	
	srio_trans_item.transaction_kind = SRIO_STATE_MC;
	srio_trans_item.next_state =SILENT ;
	
	start_item(srio_trans_item); //{
     	finish_item(srio_trans_item); //}
	
	endtask //}



endclass  :srio_pl_1xmode_ln2_sl_sm_base_seq //}


// 1XMODE LANE_1 TO 1X RECOVERY STATE 

class srio_pl_1xmode_ln1_1x_rec_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_1xmode_ln1_1x_rec_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;

	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{
	if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
   	 `uvm_fatal("Config Fatal", "Can't get the env_config")

   	srio_reg_model = env_config.srio_reg_model_rx;

     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
      	
	srio_trans_item.transaction_kind =SRIO_STATE_MC ;
	srio_trans_item.next_state =X1_RECOVERY ;
	
	start_item(srio_trans_item); //{
     	finish_item(srio_trans_item); //}
	
	endtask //}



endclass  :srio_pl_1xmode_ln1_1x_rec_sm_base_seq //}

// 1XMODE LANE_2 TO 1X RECOVERY STATE 

class srio_pl_1xmode_ln2_1x_rec_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_1xmode_ln2_1x_rec_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;

	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{
	if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    	`uvm_fatal("Config Fatal", "Can't get the env_config")

   	srio_reg_model = env_config.srio_reg_model_rx;

     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
      	
	srio_trans_item.transaction_kind =SRIO_STATE_MC ;
	srio_trans_item.next_state =X1_RECOVERY ;
	
	start_item(srio_trans_item); //{
     	finish_item(srio_trans_item); //}
	
	endtask //}



endclass  :srio_pl_1xmode_ln2_1x_rec_sm_base_seq //}

// 1XMODE LANE_0 TO 1X RECOVERY STATE 

class srio_pl_1xmode_ln0_1x_rec_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_1xmode_ln0_1x_rec_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;

	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{
	if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    	`uvm_fatal("Config Fatal", "Can't get the env_config")

   	srio_reg_model = env_config.srio_reg_model_rx;

     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
      	
	srio_trans_item.transaction_kind =SRIO_STATE_MC ;
	srio_trans_item.next_state =X1_RECOVERY ;
	
	start_item(srio_trans_item); //{
     	finish_item(srio_trans_item); //}
	
	endtask //}



endclass  :srio_pl_1xmode_ln0_1x_rec_sm_base_seq //}

// 2X RECOVERY TO 2X MODE STATE 

class srio_pl_2x_rec_2xmode_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_2x_rec_2xmode_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;

	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{
	if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    	`uvm_fatal("Config Fatal", "Can't get the env_config")

   	srio_reg_model = env_config.srio_reg_model_rx;

     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	
	srio_trans_item.transaction_kind =SRIO_STATE_MC ;
	srio_trans_item.next_state =X2_MODE ;	

	start_item(srio_trans_item); //{
     	finish_item(srio_trans_item); //}
	
	endtask //}



endclass  :srio_pl_2x_rec_2xmode_sm_base_seq //}


// 2X RECOVERY TO 1X MODE LANE_0 STATE 

class srio_pl_2x_rec_1xmode_ln0_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_2x_rec_1xmode_ln0_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;

	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{
	if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
   	 `uvm_fatal("Config Fatal", "Can't get the env_config")

   	srio_reg_model = env_config.srio_reg_model_rx;

     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	
	srio_trans_item.transaction_kind = SRIO_STATE_MC;
	srio_trans_item.next_state =X1_M0 ;
	
	start_item(srio_trans_item); //{
     	finish_item(srio_trans_item); //}
	
	endtask //}



endclass  :srio_pl_2x_rec_1xmode_ln0_sm_base_seq //}

// 2X RECOVERY TO 1X MODE LANE_1 STATE 

class srio_pl_2x_rec_1xmode_ln1_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_2x_rec_1xmode_ln1_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;

	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{
	if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    	`uvm_fatal("Config Fatal", "Can't get the env_config")

   	srio_reg_model = env_config.srio_reg_model_rx;

     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
      	
	srio_trans_item.transaction_kind = SRIO_STATE_MC;
	srio_trans_item.next_state =X1_M1 ;	

	start_item(srio_trans_item); //{
     	finish_item(srio_trans_item); //}
	
	endtask //}



endclass  :srio_pl_2x_rec_1xmode_ln1_sm_base_seq //}

// 2X RECOVERY TO SILENT STATE 

class srio_pl_2x_rec_sl_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_2x_rec_sl_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;

	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{
	if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    	`uvm_fatal("Config Fatal", "Can't get the env_config")

   	srio_reg_model = env_config.srio_reg_model_rx;

     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
      	
	srio_trans_item.transaction_kind = SRIO_STATE_MC;
	srio_trans_item.next_state = SILENT;	

	start_item(srio_trans_item); //{
     	finish_item(srio_trans_item); //}
	
	endtask //}



endclass  :srio_pl_2x_rec_sl_sm_base_seq //}

// 1X RECOVERY TO SILENT STATE 

class srio_pl_1x_rec_sl_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_1x_rec_sl_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;

	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{
	if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    	`uvm_fatal("Config Fatal", "Can't get the env_config")

   	srio_reg_model = env_config.srio_reg_model_rx;

     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
      	
	srio_trans_item.transaction_kind = SRIO_STATE_MC;
	srio_trans_item.next_state = SILENT;	

	start_item(srio_trans_item); //{
     	finish_item(srio_trans_item); //}
	
	endtask //}



endclass  :srio_pl_1x_rec_sl_sm_base_seq //}

// 1X RECOVERY TO 1X MODE LANE_0 STATE 

class srio_pl_1x_rec_1xmode_ln0_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_1x_rec_1xmode_ln0_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;

	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{
	if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    	`uvm_fatal("Config Fatal", "Can't get the env_config")

   	srio_reg_model = env_config.srio_reg_model_rx;

     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
		
	srio_trans_item.transaction_kind = SRIO_STATE_MC;
	srio_trans_item.next_state =X1_M0 ;

	start_item(srio_trans_item); //{
     	finish_item(srio_trans_item); //}
	
	endtask //}



endclass  :srio_pl_1x_rec_1xmode_ln0_sm_base_seq //}

// 1X RECOVERY TO 1X MODE LANE_1 STATE 

class srio_pl_1x_rec_1xmode_ln1_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_1x_rec_1xmode_ln1_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;

	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{
	if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    	`uvm_fatal("Config Fatal", "Can't get the env_config")

   	srio_reg_model = env_config.srio_reg_model_rx;

     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	
	srio_trans_item.transaction_kind =SRIO_STATE_MC ;
	srio_trans_item.next_state =X1_M1 ;
	
	start_item(srio_trans_item); //{
     	finish_item(srio_trans_item); //}
	
	endtask //}



endclass  :srio_pl_1x_rec_1xmode_ln1_sm_base_seq //}


// 1X RECOVERY TO 1X MODE LANE_2 STATE 

class srio_pl_1x_rec_1xmode_ln2_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_1x_rec_1xmode_ln2_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;

	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{
	if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    	`uvm_fatal("Config Fatal", "Can't get the env_config")

   	srio_reg_model = env_config.srio_reg_model_rx;

     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	
	srio_trans_item.transaction_kind =SRIO_STATE_MC ;
	srio_trans_item.next_state =X1_M2 ;
	start_item(srio_trans_item); //{
     	finish_item(srio_trans_item); //}
	
	endtask //}



endclass  :srio_pl_1x_rec_1xmode_ln2_sm_base_seq //}

//=====ACKID_ERR SEQUENCES =======


class srio_pl_pkt_ackid_error_base_seq extends srio_pl_base_seq; //{
 
 `uvm_object_utils(srio_pl_pkt_ackid_error_base_seq)

   srio_trans srio_trans_item;
   
	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{


     	 srio_trans_item = srio_trans::type_id::create("srio_trans_item");
			
	srio_trans_item.pl_err.constraint_mode(0);
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);


      	start_item(srio_trans_item); //{
		
      assert(srio_trans_item.randomize ()with {ftype == 4'h5;ttype== 4'h4;pl_err_kind == ACKID_ERR;});  ///correct
  
	finish_item(srio_trans_item); //}
	
	endtask //}



endclass  : srio_pl_pkt_ackid_error_base_seq //}

//=====FINAL_CRC_ERR SEQUENCES =======


class srio_pl_pkt_final_crc_error_base_seq extends srio_pl_base_seq; //{
 
 `uvm_object_utils(srio_pl_pkt_final_crc_error_base_seq)

   srio_trans srio_trans_item;
   
	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{


     	 srio_trans_item = srio_trans::type_id::create("srio_trans_item");
			
	srio_trans_item.pl_err.constraint_mode(0);
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
	srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.Wdptr.constraint_mode(0);
      	start_item(srio_trans_item); //{
		
      assert(srio_trans_item.randomize ()with {ftype == 4'h5;ttype == 4'h4;wdptr == 1'b1;wrsize == 4'b1101;pl_err_kind == FINAL_CRC_ERR;});  ///correct
  
	finish_item(srio_trans_item); //}
	
	endtask //}



endclass  : srio_pl_pkt_final_crc_error_base_seq //}

//=====EARLY_CRC_ERR SEQUENCES =======


class srio_pl_pkt_early_crc_error_base_seq extends srio_pl_base_seq; //{
 
 `uvm_object_utils(srio_pl_pkt_early_crc_error_base_seq)
  rand bit [1:0] x;
  rand bit [3:0] ftype_0;
  rand bit [3:0] ttype_0;
   srio_trans srio_trans_item;
   
	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{


     	 srio_trans_item = srio_trans::type_id::create("srio_trans_item");
			
	srio_trans_item.pl_err.constraint_mode(0);
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
	srio_trans_item.wrsize_0.constraint_mode(0);
	srio_trans_item.Wdptr.constraint_mode(0);
      	start_item(srio_trans_item); //{
	x = $urandom;
	case (x)  //{
	   3'd0 :begin 
             ftype_0 = 4'h5;
             ttype_0 = 4'h4;
             end
	   3'd1 :begin 
             ftype_0 = 4'h5;
             ttype_0 = 4'h5;
             end
	   3'd2 :begin 
             ftype_0 = 4'h6;
             ttype_0 = 4'h0;
             end
	   3'd3 :begin 
             ftype_0 = 4'h2;
             ttype_0 = 4'h4;
             end
	  endcase //}		
      assert(srio_trans_item.randomize ()with {ftype == ftype_0;ttype == ttype_0;wdptr == 1'b1;wrsize == 4'b1101;pl_err_kind == EARLY_CRC_ERR;});  ///correct
   	finish_item(srio_trans_item); //}
	
	endtask //}



endclass  : srio_pl_pkt_early_crc_error_base_seq //}

//=====ILLEGAL_PRIO_ERR SEQUENCES =======


class srio_pl_pkt_illegal_prio_error_base_seq extends srio_pl_base_seq; //{
 
 `uvm_object_utils(srio_pl_pkt_illegal_prio_error_base_seq)
rand bit[2:0] x;
rand bit[3:0] ftype_0;
   srio_trans srio_trans_item;
   
	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{
     	 srio_trans_item = srio_trans::type_id::create("srio_trans_item");
			
	srio_trans_item.prior.constraint_mode(0);
	srio_trans_item.Ftype.constraint_mode(0);
	x = $urandom;
	case (x)  //{
	   3'd0,3'd7 : ftype_0 = 4'h2;
	   3'd1,3'd6 : ftype_0 = 4'h5;
	   3'd2 : ftype_0 = 4'h6;
	   3'd3 : ftype_0 = 4'h8;
	   3'd4 : ftype_0 = 4'hA;
	   3'd5 : ftype_0 = 4'hB;
	  
	  endcase //}

      	start_item(srio_trans_item); //{
	
        assert(srio_trans_item.randomize ()with{ftype == ftype_0;prio == 2'b11; });  ///correct
  
	finish_item(srio_trans_item); //}
	
	endtask //}



endclass  : srio_pl_pkt_illegal_prio_error_base_seq //}

//=====ILLEGAL_CRF_ERR SEQUENCES =======


class srio_pl_pkt_illegal_crf_error_base_seq extends srio_pl_base_seq; //{
 
	 `uvm_object_utils(srio_pl_pkt_illegal_crf_error_base_seq)
	rand bit[2:0] x;
	rand bit[3:0] ftype_0;
	rand bit crf_0;
         srio_trans srio_trans_item;
   
	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{


     	 srio_trans_item = srio_trans::type_id::create("srio_trans_item");
			
	srio_trans_item.Crf.constraint_mode(0);
	srio_trans_item.prior.constraint_mode(0);
	srio_trans_item.Ftype.constraint_mode(0);
	srio_trans_item.Ttype.constraint_mode(0);
        x = $urandom;
        crf_0 = $urandom;

	case (x)  //{
	   3'd0,3'd7 : ftype_0 = 4'h2;
	   3'd1,3'd6 : ftype_0 = 4'h5;
	   3'd2 : ftype_0 = 4'h6;
	   3'd3 : ftype_0 = 4'h8;
	   3'd4 : ftype_0 = 4'hA;
	   3'd5 : ftype_0 = 4'hB;
	
	     endcase //}

      	start_item(srio_trans_item); //{
		
      assert(srio_trans_item.randomize ()with{ftype == ftype_0;prio == 2'b11;crf == crf_0; });  ///correct
  
	finish_item(srio_trans_item); //}
	
	endtask //}



endclass  : srio_pl_pkt_illegal_crf_error_base_seq //}

//===NXMODE SUPPORT DISABLED


class srio_pl_nx_mode_support_disable_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_nx_mode_support_disable_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;
 
	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{

        if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    	`uvm_fatal("Config Fatal", "Can't get the env_config")

     	srio_reg_model = env_config.srio_reg_model_rx;

     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");

	start_item(srio_trans_item); //{
     	finish_item(srio_trans_item); //}
	
	endtask //}



endclass  : srio_pl_nx_mode_support_disable_base_seq //}
//===2XMODE SUPPORT DISABLED


class srio_pl_x2_mode_support_disable_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_x2_mode_support_disable_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;
 
	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{

        if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    	`uvm_fatal("Config Fatal", "Can't get the env_config")

     	srio_reg_model = env_config.srio_reg_model_rx;

     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");

	start_item(srio_trans_item); //{
     	finish_item(srio_trans_item); //}
	
	endtask //}



endclass  : srio_pl_x2_mode_support_disable_base_seq //}

//========= REQUEST SEQUENCE =========

class srio_pl_nwrite_swrite_class_base_seq extends srio_ll_base_seq;
    `uvm_object_utils(srio_pl_nwrite_swrite_class_base_seq)

   srio_trans srio_trans_item;

  rand bit [3:0] ftype_0;
  rand bit [3:0] ttype_0;
  

      function new(string name="");
    super.new(name);
  endfunction

  virtual task body();
     srio_trans_item = srio_trans::type_id::create("srio_trans_item");
     srio_trans_item.pkt_type = SRIO_PL_PACKET;	
     srio_trans_item.transaction_kind = SRIO_PACKET;
     srio_trans_item.Ftype.constraint_mode(0);
     srio_trans_item.Ttype.constraint_mode(0);
     srio_trans_item.wrsize_0.constraint_mode(0);
     srio_trans_item.ackid.rand_mode(0);

     ftype_0 = $urandom_range(32'd6,32'd5);
   
      start_item(srio_trans_item);
     if(ftype_0 == 4'h5) 
     assert(srio_trans_item.randomize() with {ftype ==ftype_0;ttype == 4'h4;wrsize ==4'hB ;wdptr ==1'b0;ackid==0;}); 
     else 
     assert(srio_trans_item.randomize() with {ftype ==ftype_0;wrsize ==4'hB ;wdptr ==1'b0;ackid==0;}); 
     for(int i=0; i<8; i++) begin //{
     srio_trans_item.payload.push_back(i); 
     end //}
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " SWRITE OR NWRITE Transcation"),UVM_LOW); end
        srio_trans_item.print();
        finish_item(srio_trans_item);
  endtask

endclass : srio_pl_nwrite_swrite_class_base_seq

//ASYMMETRY TO SILENT STATE 

class srio_pl_asymm_sl_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_asymm_sl_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;
 
	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{

        if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    	`uvm_fatal("Config Fatal", "Can't get the env_config")

     	srio_reg_model = env_config.srio_reg_model_rx;

     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	      	
	srio_trans_item.transaction_kind = SRIO_STATE_MC;
	srio_trans_item.next_state = ASYM_MODE;	

        srio_trans_item.Ftype.constraint_mode(0);
        srio_trans_item.Ttype.constraint_mode(0);
     
        start_item(srio_trans_item);
        assert(srio_trans_item.randomize() with {ftype ==4'h2 ;ttype == 4'h4;});  
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " NREAD REQUEST CLASS Transcation"),UVM_LOW); end
        srio_trans_item.print();
        finish_item(srio_trans_item);	
	endtask //}



endclass  : srio_pl_asymm_sl_sm_base_seq //}

//1X RECOVERY TO 1X RETRAIN STATE 

class srio_pl_1x_rec_1x_retrain_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_1x_rec_1x_retrain_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;
 
	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{

        if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    	`uvm_fatal("Config Fatal", "Can't get the env_config")

     	srio_reg_model = env_config.srio_reg_model_rx;

     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	      	
	srio_trans_item.transaction_kind = SRIO_STATE_MC;
	srio_trans_item.next_state = X1_RETRAIN;	

        srio_trans_item.Ftype.constraint_mode(0);
        srio_trans_item.Ttype.constraint_mode(0);
     
        start_item(srio_trans_item);
        assert(srio_trans_item.randomize() with {ftype ==4'h2 ;ttype == 4'h4;});  
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " NREAD REQUEST CLASS Transcation"),UVM_LOW); end
        srio_trans_item.print();
        finish_item(srio_trans_item);	
	endtask //}

endclass  : srio_pl_1x_rec_1x_retrain_sm_base_seq //}

//1X RETRAIN TO 1X RECOVERY   STATE 

class srio_pl_1x_retrain_1x_rec_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_1x_retrain_1x_rec_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;
 
	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{

        if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    	`uvm_fatal("Config Fatal", "Can't get the env_config")

     	srio_reg_model = env_config.srio_reg_model_rx;

     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	      	
	srio_trans_item.transaction_kind = SRIO_STATE_MC;
	srio_trans_item.next_state = X1_RECOVERY;	

        srio_trans_item.Ftype.constraint_mode(0);
        srio_trans_item.Ttype.constraint_mode(0);
     
        start_item(srio_trans_item);
        assert(srio_trans_item.randomize() with {ftype ==4'h2 ;ttype == 4'h4;});  
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " NREAD REQUEST CLASS Transcation"),UVM_LOW); end
        srio_trans_item.print();
        finish_item(srio_trans_item);	
	endtask //}

endclass  : srio_pl_1x_retrain_1x_rec_sm_base_seq //}
//NX RETRAIN TO NX RECOVERY   STATE 

class srio_pl_nx_retrain_nx_rec_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_nx_retrain_nx_rec_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;
 
	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{

        if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    	`uvm_fatal("Config Fatal", "Can't get the env_config")

     	srio_reg_model = env_config.srio_reg_model_rx;

     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	      	
	srio_trans_item.transaction_kind = SRIO_STATE_MC;
	srio_trans_item.next_state = NX_RECOVERY;	

        srio_trans_item.Ftype.constraint_mode(0);
        srio_trans_item.Ttype.constraint_mode(0);
     
        start_item(srio_trans_item);
        assert(srio_trans_item.randomize() with {ftype ==4'h2 ;ttype == 4'h4;});  
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " NREAD REQUEST CLASS Transcation"),UVM_LOW); end
        srio_trans_item.print();
        finish_item(srio_trans_item);	
	endtask //}

endclass  : srio_pl_nx_retrain_nx_rec_sm_base_seq //}

//2X RETRAIN TO 2X RECOVERY   STATE 

class srio_pl_2x_retrain_2x_rec_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_2x_retrain_2x_rec_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;
 
	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{

        if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    	`uvm_fatal("Config Fatal", "Can't get the env_config")

     	srio_reg_model = env_config.srio_reg_model_rx;

     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	      	
	srio_trans_item.transaction_kind = SRIO_STATE_MC;
	srio_trans_item.next_state = X2_RECOVERY;	

        srio_trans_item.Ftype.constraint_mode(0);
        srio_trans_item.Ttype.constraint_mode(0);
     
        start_item(srio_trans_item);
        assert(srio_trans_item.randomize() with {ftype ==4'h2 ;ttype == 4'h4;});  
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " NREAD REQUEST CLASS Transcation"),UVM_LOW); end
        srio_trans_item.print();
        finish_item(srio_trans_item);	
	endtask //}

endclass  : srio_pl_2x_retrain_2x_rec_sm_base_seq //}

//2X RECOVERY TO 2X RETRAIN STATE 

class srio_pl_2x_rec_2x_retrain_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_2x_rec_2x_retrain_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;
 
	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{

        if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    	`uvm_fatal("Config Fatal", "Can't get the env_config")

     	srio_reg_model = env_config.srio_reg_model_rx;

     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	      	
	srio_trans_item.transaction_kind = SRIO_STATE_MC;
	srio_trans_item.next_state = X2_RETRAIN;	

        srio_trans_item.Ftype.constraint_mode(0);
        srio_trans_item.Ttype.constraint_mode(0);
     
        start_item(srio_trans_item);
        assert(srio_trans_item.randomize() with {ftype ==4'h2 ;ttype == 4'h4;});  
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " NREAD REQUEST CLASS Transcation"),UVM_LOW); end
        srio_trans_item.print();
        finish_item(srio_trans_item);	
	endtask //}

endclass  : srio_pl_2x_rec_2x_retrain_sm_base_seq //}
//NX RECOVERY TO NX RETRAIN STATE 

class srio_pl_nx_rec_nx_retrain_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_nx_rec_nx_retrain_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;
 
	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{

        if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    	`uvm_fatal("Config Fatal", "Can't get the env_config")

     	srio_reg_model = env_config.srio_reg_model_rx;

     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	      	
	srio_trans_item.transaction_kind = SRIO_STATE_MC;
	srio_trans_item.next_state = NX_RETRAIN;	

        srio_trans_item.Ftype.constraint_mode(0);
        srio_trans_item.Ttype.constraint_mode(0);
     
        start_item(srio_trans_item);
        assert(srio_trans_item.randomize() with {ftype ==4'h2 ;ttype == 4'h4;});  
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " NREAD REQUEST CLASS Transcation"),UVM_LOW); end
        srio_trans_item.print();
        finish_item(srio_trans_item);	
	endtask //}

endclass  : srio_pl_nx_rec_nx_retrain_sm_base_seq //}

//NX MODE TO NX RECOVERY STATE 

class srio_pl_nx_mode_nx_rec_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_nx_mode_nx_rec_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;
 
	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{

        if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    	`uvm_fatal("Config Fatal", "Can't get the env_config")

     	srio_reg_model = env_config.srio_reg_model_rx;

     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	      	
	srio_trans_item.transaction_kind = SRIO_STATE_MC;
	srio_trans_item.next_state = NX_RECOVERY;	

        srio_trans_item.Ftype.constraint_mode(0);
        srio_trans_item.Ttype.constraint_mode(0);
     
        start_item(srio_trans_item);
        assert(srio_trans_item.randomize() with {ftype ==4'h2 ;ttype == 4'h4;});  
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " NREAD REQUEST CLASS Transcation"),UVM_LOW); end
        srio_trans_item.print();
        finish_item(srio_trans_item);	
	endtask //}

endclass  : srio_pl_nx_mode_nx_rec_sm_base_seq //}
// NX RECOVERY TO NX MODE STATE 

class srio_pl_nx_rec_nx_mode_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_nx_rec_nx_mode_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;
 
	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{

        if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    	`uvm_fatal("Config Fatal", "Can't get the env_config")

     	srio_reg_model = env_config.srio_reg_model_rx;

     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	      	
	srio_trans_item.transaction_kind = SRIO_STATE_MC;
	srio_trans_item.next_state = NX_MODE;	

        srio_trans_item.Ftype.constraint_mode(0);
        srio_trans_item.Ttype.constraint_mode(0);
     
        start_item(srio_trans_item);
        assert(srio_trans_item.randomize() with {ftype ==4'h2 ;ttype == 4'h4;});  
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " NREAD REQUEST CLASS Transcation"),UVM_LOW); end
        srio_trans_item.print();
        finish_item(srio_trans_item);	
	endtask //}

endclass  : srio_pl_nx_rec_nx_mode_sm_base_seq //}
// NX RECOVERY TO 1X MODE LANE0 STATE 

class srio_pl_nx_rec_1x_mode_ln0_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_nx_rec_1x_mode_ln0_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;
 
	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{

        if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    	`uvm_fatal("Config Fatal", "Can't get the env_config")

     	srio_reg_model = env_config.srio_reg_model_rx;

     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	      	
	srio_trans_item.transaction_kind = SRIO_STATE_MC;
	srio_trans_item.next_state = X1_M0;	

        srio_trans_item.Ftype.constraint_mode(0);
        srio_trans_item.Ttype.constraint_mode(0);
     
        start_item(srio_trans_item);
        assert(srio_trans_item.randomize() with {ftype ==4'h2 ;ttype == 4'h4;});  
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " NREAD REQUEST CLASS Transcation"),UVM_LOW); end
        srio_trans_item.print();
        finish_item(srio_trans_item);	
	endtask //}

endclass  : srio_pl_nx_rec_1x_mode_ln0_sm_base_seq //}

// NX RECOVERY TO 1X MODE LANE 1 STATE 

class srio_pl_nx_rec_1x_mode_ln1_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_nx_rec_1x_mode_ln1_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;
 
	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{

        if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    	`uvm_fatal("Config Fatal", "Can't get the env_config")

     	srio_reg_model = env_config.srio_reg_model_rx;

     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	      	
	srio_trans_item.transaction_kind = SRIO_STATE_MC;
	srio_trans_item.next_state = X1_M1;	

        srio_trans_item.Ftype.constraint_mode(0);
        srio_trans_item.Ttype.constraint_mode(0);
     
        start_item(srio_trans_item);
        assert(srio_trans_item.randomize() with {ftype ==4'h2 ;ttype == 4'h4;});  
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " NREAD REQUEST CLASS Transcation"),UVM_LOW); end
        srio_trans_item.print();
        finish_item(srio_trans_item);	
	endtask //}

endclass  : srio_pl_nx_rec_1x_mode_ln1_sm_base_seq //}
// NX RECOVERY TO 1X MODE LANE 2 STATE 

class srio_pl_nx_rec_1x_mode_ln2_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_nx_rec_1x_mode_ln2_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;
 
	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{

        if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    	`uvm_fatal("Config Fatal", "Can't get the env_config")

     	srio_reg_model = env_config.srio_reg_model_rx;

     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	      	
	srio_trans_item.transaction_kind = SRIO_STATE_MC;
	srio_trans_item.next_state = X1_M2;	

        srio_trans_item.Ftype.constraint_mode(0);
        srio_trans_item.Ttype.constraint_mode(0);
     
        start_item(srio_trans_item);
        assert(srio_trans_item.randomize() with {ftype ==4'h2 ;ttype == 4'h4;});  
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " NREAD REQUEST CLASS Transcation"),UVM_LOW); end
        srio_trans_item.print();
        finish_item(srio_trans_item);	
	endtask //}

endclass  : srio_pl_nx_rec_1x_mode_ln2_sm_base_seq //}
// NX RECOVERY TO SILENT STATE 

class srio_pl_nx_rec_sl_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_nx_rec_sl_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;
 
	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{

        if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    	`uvm_fatal("Config Fatal", "Can't get the env_config")

     	srio_reg_model = env_config.srio_reg_model_rx;

     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	      	
	srio_trans_item.transaction_kind = SRIO_STATE_MC;
	srio_trans_item.next_state = SILENT;	

        srio_trans_item.Ftype.constraint_mode(0);
        srio_trans_item.Ttype.constraint_mode(0);
     
        start_item(srio_trans_item);
        assert(srio_trans_item.randomize() with {ftype ==4'h2 ;ttype == 4'h4;});  
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " NREAD REQUEST CLASS Transcation"),UVM_LOW); end
        srio_trans_item.print();
        finish_item(srio_trans_item);	
	endtask //}

endclass  : srio_pl_nx_rec_sl_sm_base_seq //}
// NX MODE TO ASYMMETRY MODE STATE 

class srio_pl_nx_mode_asymm_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_nx_mode_asymm_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;
 
	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{

        if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    	`uvm_fatal("Config Fatal", "Can't get the env_config")

     	srio_reg_model = env_config.srio_reg_model_rx;

     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	      	
	srio_trans_item.transaction_kind = SRIO_STATE_MC;
	srio_trans_item.next_state = ASYM_MODE;	

        srio_trans_item.Ftype.constraint_mode(0);
        srio_trans_item.Ttype.constraint_mode(0);
     
        start_item(srio_trans_item);
        assert(srio_trans_item.randomize() with {ftype ==4'h2 ;ttype == 4'h4;});  
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " NREAD REQUEST CLASS Transcation"),UVM_LOW); end
        srio_trans_item.print();
        finish_item(srio_trans_item);	
	endtask //}

endclass  : srio_pl_nx_mode_asymm_sm_base_seq //}
// 2X MODE TO ASYMMETRY MODE STATE 

class srio_pl_2x_mode_asymm_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_2x_mode_asymm_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;
 
	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{

        if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    	`uvm_fatal("Config Fatal", "Can't get the env_config")

     	srio_reg_model = env_config.srio_reg_model_rx;

     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	      	
	srio_trans_item.transaction_kind = SRIO_STATE_MC;
	srio_trans_item.next_state = ASYM_MODE;	

        srio_trans_item.Ftype.constraint_mode(0);
        srio_trans_item.Ttype.constraint_mode(0);
     
        start_item(srio_trans_item);
        assert(srio_trans_item.randomize() with {ftype ==4'h2 ;ttype == 4'h4;});  
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " NREAD REQUEST CLASS Transcation"),UVM_LOW); end
        srio_trans_item.print();
        finish_item(srio_trans_item);	
	endtask //}

endclass  : srio_pl_2x_mode_asymm_sm_base_seq //}
//NX RECOVERY TO 2X MODE STATE 

class srio_pl_nx_rec_2x_mode_sm_base_seq extends uvm_sequence#(srio_trans); //{
 
 `uvm_object_utils(srio_pl_nx_rec_2x_mode_sm_base_seq)

   srio_trans srio_trans_item;
   srio_env_config env_config;
   srio_reg_block srio_reg_model;
 
	function new(string name="");
   	 super.new(name);
       	endfunction

  	virtual task body();  //{

        if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    	`uvm_fatal("Config Fatal", "Can't get the env_config")

     	srio_reg_model = env_config.srio_reg_model_rx;

     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
	      	
	srio_trans_item.transaction_kind = SRIO_STATE_MC;
	srio_trans_item.next_state = X2_MODE;	

        srio_trans_item.Ftype.constraint_mode(0);
        srio_trans_item.Ttype.constraint_mode(0);
     
        start_item(srio_trans_item);
        assert(srio_trans_item.randomize() with {ftype ==4'h2 ;ttype == 4'h4;});  
        begin  `uvm_info("SRIO LOGICAL LAYER SEQUENCE LIBRARY",$sformatf( " NREAD REQUEST CLASS Transcation"),UVM_LOW); end
        srio_trans_item.print();
        finish_item(srio_trans_item);	
	endtask //}

endclass  : srio_pl_nx_rec_2x_mode_sm_base_seq //}

class srio_txrx_base_seq extends uvm_sequence#(srio_trans);

    `uvm_object_utils(srio_txrx_base_seq)

    srio_env_config env_config;
    srio_reg_block srio_reg_model;

    srio_trans srio_trans_item;


    bit [0:3]stype0_1;
    bit [0:11] param0_1;
    bit [0:11] param1_1;


function new(string name="");
  super.new(name);
endfunction


virtual task body();  //{

        
  srio_trans_item = srio_trans::type_id::create("srio_trans_item");
  srio_trans_item.Stype0.constraint_mode(0);
  srio_trans_item.Stype1.constraint_mode(0);
  srio_trans_item.pkt_type = SRIO_PL_PACKET;
  srio_trans_item.transaction_kind = SRIO_CS;
  srio_trans_item.stype0 = 4;
  srio_trans_item.param0 = 0;
  srio_trans_item.param1 = 12'hFFF;
  srio_trans_item.stype1 = 7;
  srio_trans_item.cmd    = 0;
  srio_trans_item.delimiter    = 8'h1C;
 
        
  start_item(srio_trans_item); //{
        
  finish_item(srio_trans_item); //}
        

endtask  //}


task pre_body();

  super.pre_body();
  if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    `uvm_fatal("Config Fatal", "Can't get the env_config")
  srio_reg_model = env_config.srio_reg_model_rx;
//  wait (env_config.pl_mon_tx_link_initialized == 1);
//  wait (env_config.pl_mon_rx_link_initialized == 1);

endtask
endclass 
//==CONTROL SYMBOL SEQUENCES.


 class srio_pl_control_symbol_packet_base_seq extends srio_pl_base_seq ; //{
 
 `uvm_object_utils(srio_pl_control_symbol_packet_base_seq)

    srio_trans srio_trans_item;
     
      bit [0:3]  stype0_1; 
      bit [0:11] param0_1;
      bit [0:11] param1_1; 
      bit [0:3]  stype1_1;
      bit [0:3]  cmd_1;
      bit [0:7]  delimiter_1;
      bit [0:2]  brc3_stype1_msb_1;

	function new(string name="");
   	 super.new(name);
  	endfunction

  	virtual task body();  //{

     	srio_trans_item = srio_trans::type_id::create("srio_trans_item");
        
	srio_trans_item.Stype0.constraint_mode(0);
	srio_trans_item.Stype1.constraint_mode(0);
	srio_trans_item.Stype1_const.constraint_mode(0); 
       	srio_trans_item.pkt_type = SRIO_PL_PACKET;
	srio_trans_item.transaction_kind = SRIO_CS; 
	srio_trans_item.stype0 = stype0_1;
	srio_trans_item.stype1 = stype1_1;
	srio_trans_item.cmd    = cmd_1;
        srio_trans_item.param0 = param0_1;
       	srio_trans_item.param1 = param1_1;
       	srio_trans_item.delimiter = delimiter_1;
       	srio_trans_item.brc3_stype1_msb= brc3_stype1_msb_1;


      	start_item(srio_trans_item); //{
        	  
        finish_item(srio_trans_item); //}
 
      		endtask //}

endclass :srio_pl_control_symbol_packet_base_seq  //} 

