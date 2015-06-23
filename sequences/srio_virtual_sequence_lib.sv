
////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_virtual_sequence_lib.sv
// Project :  srio vip
// Purpose : Virtual sequences 
// Author  :  Mobiveil
//
// Virtual sequences  for all layered sequences.
//
////////////////////////////////////////////////////////////////////////////////
class srio_virtual_base_seq extends uvm_sequence#(srio_trans);

  `uvm_object_utils(srio_virtual_base_seq)

///config handle
  srio_env_config env_config;
  srio_reg_block srio_reg_model;

///Virtual sequencer Handles
 srio_ll_sequencer vseq_ll_sequencer;
 srio_tl_sequencer vseq_tl_sequencer;
 srio_pl_sequencer vseq_pl_sequencer;
 srio_virtual_sequencer vseq_virtual_seqr;


function new(string name="");
    super.new(name);
  endfunction

task body();

     assert($cast(vseq_virtual_seqr,m_sequencer)) 
   

   if(!uvm_config_db #(srio_env_config)::get(m_sequencer, "", "srio_env_config", env_config))
    `uvm_fatal("Config Fatal", "Can't get the env_config")
        vseq_ll_sequencer= vseq_virtual_seqr.v_ll_sequencer;
	vseq_tl_sequencer= vseq_virtual_seqr.v_tl_sequencer;
	vseq_pl_sequencer= vseq_virtual_seqr.v_pl_sequencer;


   #100ns; 

endtask

endclass : srio_virtual_base_seq

//================RANDOM SEQUENCE============

class srio_ll_default_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_default_seq)

    rand bit [7:0] mtusize_1;
    rand bit [3:0] TMmode_0; 
    srio_ll_default_class_seq ll_default_seq;

   function new(string name="");
    super.new(name);
  endfunction

  task body();
         super.body();
         
          repeat(2000) begin //{ 
          ll_default_seq = srio_ll_default_class_seq::type_id::create("ll_default_seq");
          ll_default_seq.mtusize_0 = mtusize_1; 
          ll_default_seq.TMOP_0 = TMmode_0;                  
          ll_default_seq.start(vseq_ll_sequencer);
 
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with Random Value"),UVM_LOW); end
  end //}
   #1ns;
  endtask

endclass : srio_ll_default_seq

//================NREAD============

class srio_ll_nread_req_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_nread_req_seq)
  
 srio_ll_request_class_seq ll_nread_req_seq ;
   
    function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
    
	 
	for(int i = 0; i < 5 ;i++) begin //{
         ll_nread_req_seq = srio_ll_request_class_seq::type_id::create("ll_nread_req_seq");
  	
       
        ll_nread_req_seq.ftype_0 = 4'h2;
	ll_nread_req_seq.ttype_0 = 4'h4;
	       
          ll_nread_req_seq.start(vseq_ll_sequencer); 
        begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  NREAD"),UVM_LOW); end
	        end //} 
 	  endtask

endclass : srio_ll_nread_req_seq

//================SWRITE============

class srio_ll_swrite_req_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_swrite_req_seq)

  srio_ll_swrite_seq ll_swrite_req_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 1 ;i++) begin //{
        ll_swrite_req_seq = srio_ll_swrite_seq::type_id::create("ll_swrite_req_seq");
  	
        ll_swrite_req_seq.ftype_0 = 4'h6;
	ll_swrite_req_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  SWRITE"),UVM_LOW); end
#500ns;
		fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;


     end //}
  endtask

endclass : srio_ll_swrite_req_seq


//================NWRITE SEQUENCE============

class srio_ll_nwrite_req_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_nwrite_req_seq)

  srio_ll_write_class_seq ll_nwrite_req_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
       	for(int i = 0; i < 5 ;i++) begin //{
        ll_nwrite_req_seq = srio_ll_write_class_seq::type_id::create("ll_nwrite_req_seq");
  	
        ll_nwrite_req_seq.ftype_0 = 4'h5;
	ll_nwrite_req_seq.ttype_0 = 4'h4;
	
        ll_nwrite_req_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  NWRITE"),UVM_LOW); end
#100ns;
		fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;


    end //}
  endtask


endclass : srio_ll_nwrite_req_seq

//================NWRITE_R SEQUENCE============

class srio_ll_nwrite_r_req_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_nwrite_r_req_seq)

  srio_ll_write_class_seq ll_nwrite_r_req_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 5 ;i++) begin //{
        ll_nwrite_r_req_seq = srio_ll_write_class_seq::type_id::create("ll_nwrite_r_req_seq");
  	
        ll_nwrite_r_req_seq.ftype_0 = 4'h5;
	ll_nwrite_r_req_seq.ttype_0 = 4'h5;
	ll_nwrite_r_req_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  NWRITE_R"),UVM_LOW); end
#100ns;
		fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}
  endtask

endclass : srio_ll_nwrite_r_req_seq

//================ATOMIC SWAP SEQUENCE============

class srio_ll_atomic_swap_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_atomic_swap_seq)

  srio_ll_write_class_seq ll_atomic_swap_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 10 ;i++) begin //{
        ll_atomic_swap_seq = srio_ll_write_class_seq::type_id::create("ll_atomic_swap_seq");
  	
         ll_atomic_swap_seq.ftype_0 = 4'h5;
	 ll_atomic_swap_seq.ttype_0 = 4'hC;
	
         ll_atomic_swap_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with ATOMIC SWAP "),UVM_LOW); end
#100ns;
		fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

end //}
  endtask

endclass : srio_ll_atomic_swap_seq

//================ATOMIC COMPARE AND SWAP SEQUENCE============

class srio_ll_atomic_compare_and_swap_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_atomic_compare_and_swap_seq)

  srio_ll_write_class_seq ll_atomic_compare_and_swap_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 10 ;i++) begin //{
        ll_atomic_compare_and_swap_seq = srio_ll_write_class_seq::type_id::create("ll_atomic_compare_and_swap_seq");
  	
        ll_atomic_compare_and_swap_seq.ftype_0 = 4'h5;
	ll_atomic_compare_and_swap_seq.ttype_0 = 4'hD;
	

         ll_atomic_compare_and_swap_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with ATOMIC COMPARE AND  SWAP "),UVM_LOW); end
#100ns;
		fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;
end //}

  endtask

endclass : srio_ll_atomic_compare_and_swap_seq
//================ATOMIC TEST AND SWAP SEQUENCE============

class srio_ll_atomic_test_and_swap_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_atomic_test_and_swap_seq)

  srio_ll_write_class_seq ll_atomic_test_and_swap_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 10 ;i++) begin //{
        ll_atomic_test_and_swap_seq = srio_ll_write_class_seq::type_id::create("ll_atomic_test_and_swap_seq");
  	
        ll_atomic_test_and_swap_seq.ftype_0 = 4'h5;
	ll_atomic_test_and_swap_seq.ttype_0 = 4'hE;
	ll_atomic_test_and_swap_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with ATOMIC TEST AND SWAP "),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}
  endtask

endclass : srio_ll_atomic_test_and_swap_seq

//================ATOMIC INC ============

class srio_ll_atomic_inc_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_atomic_inc_seq)

  srio_ll_request_class_seq ll_atomic_inc_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 10 ;i++) begin //{
          ll_atomic_inc_seq = srio_ll_request_class_seq::type_id::create("ll_atomic_inc_seq");
  	
        ll_atomic_inc_seq.ftype_0 = 4'h2;
	ll_atomic_inc_seq.ttype_0 = 4'hc;
	

          ll_atomic_inc_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  ATOMIC INCREMENT"),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}
  endtask

endclass :srio_ll_atomic_inc_seq

//================ATOMIC DEC ============

class srio_ll_atomic_dec_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_atomic_dec_seq)

 srio_ll_request_class_seq ll_atomic_dec_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 10 ;i++) begin //{
          ll_atomic_dec_seq = srio_ll_request_class_seq::type_id::create("ll_atomic_dec_seq");
  	
        ll_atomic_dec_seq.ftype_0 = 4'h2;
	ll_atomic_dec_seq.ttype_0 = 4'hD;
	ll_atomic_dec_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  ATOMIC DECREMENT"),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}
  endtask

endclass :srio_ll_atomic_dec_seq

//================ATOMIC SET ============

class srio_ll_atomic_set_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_atomic_set_seq)

  srio_ll_request_class_seq ll_atomic_set_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 10 ;i++) begin //{
          ll_atomic_set_seq = srio_ll_request_class_seq::type_id::create("ll_atomic_set_seq");
  	
        ll_atomic_set_seq.ftype_0 = 4'h2;
	ll_atomic_set_seq.ttype_0 = 4'hE;
	
         ll_atomic_set_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  ATOMIC SET"),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

end //}
  endtask

endclass :srio_ll_atomic_set_seq

//================ATOMIC CLEAR ============

class srio_ll_atomic_clear_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_atomic_clear_seq)

  srio_ll_request_class_seq ll_atomic_clear_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 10 ;i++) begin //{
          ll_atomic_clear_seq = srio_ll_request_class_seq::type_id::create("ll_atomic_clear_seq");
  	
        ll_atomic_clear_seq.ftype_0 = 4'h2;
	ll_atomic_clear_seq.ttype_0 = 4'hF;
	

          ll_atomic_clear_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  ATOMIC CLEAR"),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}
  endtask

endclass :srio_ll_atomic_clear_seq

//================MAINTENANCE BASE SEQUENCE  ============

class srio_ll_maintenance_rd_req_base_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_maintenance_rd_req_base_seq)

  srio_ll_maintenance_base_seq ll_maintenance_rd_req_base_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 10 ;i++) begin //{

          ll_maintenance_rd_req_base_seq  = srio_ll_maintenance_base_seq ::type_id::create("ll_maintenance_rd_req_seq");
  	
        ll_maintenance_rd_req_base_seq.ftype_0 = 4'h8;
	ll_maintenance_rd_req_base_seq.ttype_0 = 4'h0;
	ll_maintenance_rd_req_base_seq.wdptr_0  = 1'b0;
	ll_maintenance_rd_req_base_seq.wrsize_1 = 4'h8;
	ll_maintenance_rd_req_base_seq.rdsize_1 = 4'h8;
	ll_maintenance_rd_req_base_seq.config_offset_0 = 21'hFFFF;
	ll_maintenance_rd_req_base_seq.targetID_Info_0 = 8'hFF;
	ll_maintenance_rd_req_base_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  MAINTENANCE READ"),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}
  endtask

endclass :srio_ll_maintenance_rd_req_base_seq

//================MAINTENANCE READ  ============

class srio_ll_maintenance_rd_req_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_maintenance_rd_req_seq)

  srio_ll_maintenance_req_seq ll_maintenance_rd_req_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	
	for(int i = 0; i < 10 ;i++) begin //{
          ll_maintenance_rd_req_seq  = srio_ll_maintenance_req_seq ::type_id::create("ll_maintenance_rd_req_seq");
  	
        ll_maintenance_rd_req_seq.ftype_0 = 4'h8;
	ll_maintenance_rd_req_seq.ttype_0 = 4'h0;
	ll_maintenance_rd_req_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  MAINTENANCE READ"),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}
  endtask

endclass :srio_ll_maintenance_rd_req_seq

//================MAINTENANCE WRITE  ============

class srio_ll_maintenance_wr_req_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_maintenance_wr_req_seq)

  srio_ll_maintenance_req_seq ll_maintenance_wr_req_seq ;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 10 ;i++) begin //{
          ll_maintenance_wr_req_seq  = srio_ll_maintenance_req_seq ::type_id::create("ll_maintenance_wr_req_seq");
  	
        ll_maintenance_wr_req_seq.ftype_0 = 4'h8;
	ll_maintenance_wr_req_seq.ttype_0 = 4'h1;
	ll_maintenance_wr_req_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  MAINTENANCE WRITE"),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

end //}

  endtask

endclass :srio_ll_maintenance_wr_req_seq

//================MAINTENANCE READ RESPONSE  ============

class srio_ll_maintenance_rd_resp_req_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_maintenance_rd_resp_req_seq)

   srio_ll_maintenance_req_seq  ll_maintenance_rd_resp_req_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 30 ;i++) begin //{

           ll_maintenance_rd_resp_req_seq = srio_ll_maintenance_req_seq ::type_id::create("ll_maintenance_rd_resp_req_seq");
  	
        ll_maintenance_rd_resp_req_seq.ftype_0 = 4'h8;
	ll_maintenance_rd_resp_req_seq.ttype_0 = 4'h2;
	ll_maintenance_rd_resp_req_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  MAINTENANCE READ RESPONSE"),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

end //}

  endtask

endclass :srio_ll_maintenance_rd_resp_req_seq

//================MAINTENANCE WRITE RESPONSE  ============

class srio_ll_maintenance_wr_resp_req_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_maintenance_wr_resp_req_seq)  


  srio_ll_maintenance_req_seq ll_maintenance_wr_resp_req_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 30 ;i++) begin //{
          ll_maintenance_wr_resp_req_seq  = srio_ll_maintenance_req_seq ::type_id::create("ll_maintenance_wr_resp_req_seq");
  	
        ll_maintenance_wr_resp_req_seq.ftype_0 = 4'h8;
	ll_maintenance_wr_resp_req_seq.ttype_0 = 4'h3;
	ll_maintenance_wr_resp_req_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  MAINTENANCE WRITE RESPONSE"),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

end //}

  endtask

endclass :srio_ll_maintenance_wr_resp_req_seq

//================MAINTENANCE PORT WRITE  ============

class srio_ll_maintenance_port_wr_req_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_maintenance_port_wr_req_seq)

  srio_ll_maintenance_req_seq ll_maintenance_port_wr_req_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 10 ;i++) begin //{
          ll_maintenance_port_wr_req_seq  = srio_ll_maintenance_req_seq ::type_id::create("ll_maintenance_port_wr_req_seq");
  	
        ll_maintenance_port_wr_req_seq.ftype_0 = 4'h8;
	ll_maintenance_port_wr_req_seq.ttype_0 = 4'h4;
	ll_maintenance_port_wr_req_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  MAINTENANCE PORT WRITE"),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}
  endtask

endclass :srio_ll_maintenance_port_wr_req_seq

//===============MAINTENANCE WRITE READ =======

class srio_ll_maintenance_wr_rd_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_maintenance_wr_rd_seq)

  srio_ll_maintenance_wr_rd_base_seq ll_maintenance_wr_rd_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	
	for(int i = 0; i < 1 ;i++) begin //{
           ll_maintenance_wr_rd_seq  = srio_ll_maintenance_wr_rd_base_seq ::type_id::create("ll_maintenance_wr_rd_seq");
  	
        ll_maintenance_wr_rd_seq.ftype_0 = 4'h8;
	ll_maintenance_wr_rd_seq.ttype_0 = 4'h1;
        ll_maintenance_wr_rd_seq.rdsize_1= 4'h8;
        ll_maintenance_wr_rd_seq.wrsize_1= 4'h8;
        ll_maintenance_wr_rd_seq.wdptr_0= 1'h0;
        ll_maintenance_wr_rd_seq.config_offset_0=8'h48 ; 

	ll_maintenance_wr_rd_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  MAINTENANCE WRITE READ"),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}
  endtask

endclass :srio_ll_maintenance_wr_rd_seq


//================DOORBELL  ============

class srio_ll_doorbell_req_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_doorbell_req_seq)

  srio_ll_doorbell_seq ll_doorbell_req_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 50 ;i++) begin //{
           ll_doorbell_req_seq =srio_ll_doorbell_seq ::type_id::create("ll_doorbell_req_seq");
  	
        ll_doorbell_req_seq.ftype_0 = 4'hA;
	
        ll_doorbell_req_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  DOORBELL "),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;


	end //}
  endtask

endclass :srio_ll_doorbell_req_seq

//===========MESSAGE FOR RANDOM SEQUENCE===========

class srio_ll_message_random_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_message_random_seq)

  srio_ll_message_random_req_seq ll_message_random_req_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 10 ;i++) begin //{
        ll_message_random_req_seq =srio_ll_message_random_req_seq ::type_id::create("ll_message_random_req_seq");
  	
        ll_message_random_req_seq.ftype_0 = 4'hB;
	
        ll_message_random_req_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  message sequences "),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}
  endtask

endclass :srio_ll_message_random_seq

//===========MESSAGE INTERLEAVED SEQUENCE===========

class srio_ll_msg_interleaved_req_seq  extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_msg_interleaved_req_seq)

    srio_ll_message_interleaved_out_order_req_seq ll_msg_interleaved_req_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 10 ;i++) begin //{
         ll_msg_interleaved_req_seq=srio_ll_message_interleaved_out_order_req_seq ::type_id::create("ll_msg_interleaved_req_seq");

  	env_config.ll_config.interleaved_pkt = TRUE ;
        ll_msg_interleaved_req_seq.ftype_0 = 4'hB;
	
        ll_msg_interleaved_req_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  message interleaved sequences "),UVM_LOW); end	
	end //}
  endtask

endclass :srio_ll_msg_interleaved_req_seq

//===========MESSAGE OUT OF ORDER  SEQUENCE===========

class srio_ll_msg_outoforder_resp_seq  extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_msg_outoforder_resp_seq)

    srio_ll_message_interleaved_out_order_req_seq ll_msg_out_order_resp_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 10 ;i++) begin //{
         ll_msg_out_order_resp_seq= srio_ll_message_interleaved_out_order_req_seq::type_id::create("ll_msg_out_order_resp_seq");

  	//env_config.ll_config.en_out_of_order_gen = TRUE ;
        ll_msg_out_order_resp_seq.ftype_0 = 4'hB;
	
        ll_msg_out_order_resp_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  message out of order response sequences "),UVM_LOW); end	
	end //}
  endtask

endclass :srio_ll_msg_outoforder_resp_seq

///================MESSAGE WITH SINGLE SEGMENT  ============

class srio_ll_msg_sseg_req_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_msg_sseg_req_seq)

  rand bit [3:0] ssize0;

    srio_ll_message_req_seq ll_msg_sseg_req_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 10 ;i++) begin //{
        ll_msg_sseg_req_seq = srio_ll_message_req_seq ::type_id::create("ll_msg_sseg_req_seq");

  	ssize0 = $urandom_range(14,9);


        ll_msg_sseg_req_seq.ftype_0 = 4'hB;
        ll_msg_sseg_req_seq.ssize_0 = ssize0;
        ll_msg_sseg_req_seq.message_length_0 = (2**(ssize0-9));

        ll_msg_sseg_req_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with MESSAGE WITH SSIZE 8 BYTES  "),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}
  endtask

endclass :srio_ll_msg_sseg_req_seq

//================MESSAGE WITH MULTI SEGMENT  ============

class srio_ll_msg_mseg_req_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_msg_mseg_req_seq)

  rand bit [3:0] ssize0;
	
  srio_ll_message_req_seq ll_msg_mseg_req_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 50 ;i++) begin //{
        ll_msg_mseg_req_seq = srio_ll_message_req_seq ::type_id::create("ll_msg_mseg_req_seq");

  	ssize0 = $urandom_range(14,9);

        ll_msg_mseg_req_seq.ftype_0 = 4'hB;
        ll_msg_mseg_req_seq.ssize_0 = ssize0;

        ll_msg_mseg_req_seq.message_length_0 = $urandom_range((16*(2**(ssize0-9))),(2*(2**(ssize0-9))));
        ll_msg_mseg_req_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with MESSAGE WITH SSIZE 8 BYTES  "),UVM_LOW); end

    #1ns;

	end //}
  endtask

endclass :srio_ll_msg_mseg_req_seq

//================MESSAGE WITH SSIZE 8 BYTES  ============
 
class srio_ll_msg_ssize_8byte_req_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_msg_ssize_8byte_req_seq)
   
  rand bit [3:0] ssize0;
	
  srio_ll_message_req_seq ll_msg_ssize_8byte_req_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 10 ;i++) begin //{
        ll_msg_ssize_8byte_req_seq = srio_ll_message_req_seq ::type_id::create("ll_msg_ssize_8byte_req_seq");

  	ssize0 = 4'h9;

        ll_msg_ssize_8byte_req_seq.ftype_0 = 4'hB;
        ll_msg_ssize_8byte_req_seq.ssize_0 = ssize0;
        ll_msg_ssize_8byte_req_seq.message_length_0 = $urandom_range((2**(ssize0-9)*8),1);

        ll_msg_ssize_8byte_req_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with MESSAGE WITH SSIZE 8 BYTES  "),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}
  endtask

endclass :srio_ll_msg_ssize_8byte_req_seq

//================MESSAGE WITH SSIZE 16 BYTES  ============

class srio_ll_msg_ssize_16byte_req_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_msg_ssize_16byte_req_seq)

  rand bit [3:0] ssize0;

  srio_ll_message_req_seq ll_msg_ssize_16byte_req_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 10 ;i++) begin //{
        ll_msg_ssize_16byte_req_seq = srio_ll_message_req_seq ::type_id::create("ll_msg_ssize_16byte_req_seq");

  	ssize0 = 4'hA;

        ll_msg_ssize_16byte_req_seq.ftype_0 = 4'hB;
        ll_msg_ssize_16byte_req_seq.ssize_0 = ssize0;
        ll_msg_ssize_16byte_req_seq.message_length_0 = $urandom_range((2**(ssize0-9)*8),1);

	
        ll_msg_ssize_16byte_req_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with MESSAGE WITH SSIZE 16 BYTES  "),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}
  endtask

endclass :srio_ll_msg_ssize_16byte_req_seq

//================MESSAGE WITH SSIZE 32 BYTES  ============

class srio_ll_msg_ssize_32byte_req_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_msg_ssize_32byte_req_seq)

  rand bit [3:0] ssize0;

  srio_ll_message_req_seq ll_msg_ssize_32byte_req_seq;

  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 10 ;i++) begin //{
        ll_msg_ssize_32byte_req_seq = srio_ll_message_req_seq ::type_id::create("ll_msg_ssize_32byte_req_seq");

  	ssize0 = 4'hB;

        ll_msg_ssize_32byte_req_seq.ftype_0 = 4'hB;
        ll_msg_ssize_32byte_req_seq.ssize_0 = ssize0;
        ll_msg_ssize_32byte_req_seq.message_length_0 = $urandom_range((2**(ssize0-9)*8),1);
	
        ll_msg_ssize_32byte_req_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with MESSAGE WITH SSIZE 32 BYTES  "),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}
  endtask

endclass :srio_ll_msg_ssize_32byte_req_seq

//================MESSAGE WITH SSIZE 64 BYTES  ============

class srio_ll_msg_ssize_64byte_req_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_msg_ssize_64byte_req_seq)


   rand bit [3:0] ssize0;

  srio_ll_message_req_seq ll_msg_ssize_64byte_req_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 10 ;i++) begin //{
        ll_msg_ssize_64byte_req_seq = srio_ll_message_req_seq ::type_id::create("ll_msg_ssize_64byte_req_seq");

  	ssize0 = 4'hC;

        ll_msg_ssize_64byte_req_seq.ftype_0 = 4'hB;
        ll_msg_ssize_64byte_req_seq.ssize_0 = ssize0;
        ll_msg_ssize_64byte_req_seq.message_length_0 = $urandom_range((2**(ssize0-9)*8),1);

	
        ll_msg_ssize_64byte_req_seq.start(vseq_ll_sequencer);  
 begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with MESSAGE WITH SSIZE 64 BYTES  "),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}
  endtask

endclass :srio_ll_msg_ssize_64byte_req_seq

//================MESSAGE WITH SSIZE 128 BYTES  ============

class srio_ll_msg_ssize_128byte_req_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_msg_ssize_128byte_req_seq)

   rand bit [3:0] ssize0;

  srio_ll_message_req_seq ll_msg_ssize_128byte_req_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 10 ;i++) begin //{
        ll_msg_ssize_128byte_req_seq = srio_ll_message_req_seq ::type_id::create("ll_msg_ssize_128byte_req_seq");

  	ssize0 = 4'hD;

        ll_msg_ssize_128byte_req_seq.ftype_0 = 4'hB;
        ll_msg_ssize_128byte_req_seq.ssize_0 = ssize0;
        ll_msg_ssize_128byte_req_seq.message_length_0 = $urandom_range((2**(ssize0-9)*8),1);

	
        ll_msg_ssize_128byte_req_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with MESSAGE WITH SSIZE 128 BYTES  "),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}

  endtask

endclass :srio_ll_msg_ssize_128byte_req_seq

//================MESSAGE WITH SSIZE 256 BYTES  ============

class srio_ll_msg_ssize_256byte_req_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_msg_ssize_256byte_req_seq)

   rand bit [3:0] ssize0;

  srio_ll_message_req_seq ll_msg_ssize_256byte_req_seq ;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 10 ;i++) begin //{
        ll_msg_ssize_256byte_req_seq = srio_ll_message_req_seq ::type_id::create("ll_msg_ssize_256byte_req_seq");

  	ssize0 = 4'hE;

        ll_msg_ssize_256byte_req_seq.ftype_0 = 4'hB;
        ll_msg_ssize_256byte_req_seq.ssize_0 = ssize0;
        ll_msg_ssize_256byte_req_seq.message_length_0 = $urandom_range((2**(ssize0-9)*8),1);

	
        ll_msg_ssize_256byte_req_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with MESSAGE WITH SSIZE 256 BYTES  "),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}
  endtask

endclass :srio_ll_msg_ssize_256byte_req_seq


//================DATA STREAMING WITH MAINTENANCE ============

class srio_ll_maintenance_ds_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_maintenance_ds_seq)

   srio_ll_maintenance_ds_base_seq ll_maintenance_ds_base_seq ;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
      repeat(5) begin //{

	
       ll_maintenance_ds_base_seq= srio_ll_maintenance_ds_base_seq::type_id::create("ll_maintenance_ds_base_seq");

       ll_maintenance_ds_base_seq.start(vseq_ll_sequencer); 
	 begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with DATA STREAMING SINGLE SEGMENT   "),UVM_LOW); end
	end //}
  endtask

endclass :srio_ll_maintenance_ds_seq

//================DATA STREAMING WITH INTERLEAVED  ============

class srio_ll_ds_interleaved_seq extends srio_virtual_base_seq;
   `uvm_object_utils(srio_ll_ds_interleaved_seq)
    
   rand bit [7:0] mtusize_1;
   rand bit [15:0] pdu_length_1;

   srio_ll_ds_interleaved_base_seq ll_ds_interleaved_seq ;

   function new(string name="");
    super.new(name);
   endfunction

   task body();
   super.body();
   repeat (10) begin //{   	
   ll_ds_interleaved_seq  = srio_ll_ds_interleaved_base_seq ::type_id::create("ll_ds_interleaved_seq");

    env_config.ll_config.interleaved_pkt = TRUE ;
    ll_ds_interleaved_seq.mtusize_0 = mtusize_1;
    ll_ds_interleaved_seq.pdulength_0= pdu_length_1;

    ll_ds_interleaved_seq.start(vseq_ll_sequencer); 
    begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with DATA STREAMING WITH INTERLEAVED  "),UVM_LOW); end
    #1ns;
    end //}	
  endtask

endclass :srio_ll_ds_interleaved_seq

//================DATA STREAMING WITH MAX PDU AND MTU ============

class srio_ll_ds_max_min_pdu_mtu_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_max_min_pdu_mtu_seq)

   rand bit [7:0] mtusize_1;
   rand bit [15:0] pdu_length_1;

   srio_ll_ds_max_min_pdu_mtu_base_seq ll_ds_max_min_pdu_mtu_base_seq ;

   function new(string name="");
   super.new(name);
   endfunction

  task body();
	super.body();
	
       ll_ds_max_min_pdu_mtu_base_seq= srio_ll_ds_max_min_pdu_mtu_base_seq::type_id::create("ll_ds_max_min_pdu_mtu_base_seq");
       ll_ds_max_min_pdu_mtu_base_seq.mtusize_0 = mtusize_1;
       ll_ds_max_min_pdu_mtu_base_seq.pdulength_0 = pdu_length_1;
       ll_ds_max_min_pdu_mtu_base_seq.start(vseq_ll_sequencer); 
	 begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with DATA STREAMING MAX MTU AND PDU SEGMENT   "),UVM_LOW); end
	
  endtask

endclass :srio_ll_ds_max_min_pdu_mtu_seq

//================DATA STREAMING CORNER CASE FOR 80BYTE SEGMENT ============

class srio_ll_ds_corner_case_total_pkt_80byte_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_corner_case_total_pkt_80byte_seq)
  
   rand bit [7:0] mtusize_1;
   rand bit [15:0] pdu_length_1;
 
   srio_ll_ds_corner_case_total_pkt_80byte_base_seq ll_ds_corner_case_total_pkt_80byte_seq;
  function new(string name="");
    super.new(name);
  endfunction
   
  task body();
	super.body();
	
           ll_ds_corner_case_total_pkt_80byte_seq  = srio_ll_ds_corner_case_total_pkt_80byte_base_seq::type_id::create("ll_ds_corner_case_total_pkt_80byte_seq");
          ll_ds_corner_case_total_pkt_80byte_seq.mtusize_0 = mtusize_1;
          ll_ds_corner_case_total_pkt_80byte_seq.pdulength_0 =pdu_length_1;
          ll_ds_corner_case_total_pkt_80byte_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with DATA STREAMING CORNER CASE FOR 80BYTE SEGMENT   "),UVM_LOW); end

  endtask

endclass :srio_ll_ds_corner_case_total_pkt_80byte_seq



//================DATA STREAMING SINGLE SEGMENT ============

class srio_ll_ds_sseg_req_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_sseg_req_seq)
  
   rand bit [7:0] mtusize_1;
   rand bit [15:0] pdu_length_1;
 
   srio_ll_ds_sseg_req_base_seq ll_ds_sseg_req_seq;

   function new(string name="");
   super.new(name);
   endfunction
   
  task body();
	super.body();
	repeat(1) begin //{
           ll_ds_sseg_req_seq  = srio_ll_ds_sseg_req_base_seq::type_id::create("ll_ds_sseg_req_seq");
          ll_ds_sseg_req_seq.mtusize_0 = mtusize_1;
          ll_ds_sseg_req_seq.pdulength_0= pdu_length_1;
          ll_ds_sseg_req_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with DATA STREAMING SINGLE SEGMENT   "),UVM_LOW); end
	end //}
  endtask

endclass :srio_ll_ds_sseg_req_seq

//================DATA STREAMING MULTI SEGMENT ============

class srio_ll_ds_mseg_req_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_mseg_req_seq)
  
   rand bit [7:0] mtusize_1;
   rand bit [15:0] pdu_length_1;
 
   srio_ll_ds_mseg_req_base_seq ll_ds_mseg_req_seq;

   function new(string name="");
   super.new(name);
   endfunction

  task body();
   super.body();
   ll_ds_mseg_req_seq  =srio_ll_ds_mseg_req_base_seq ::type_id::create("ll_ds_mseg_req_seq");
   ll_ds_mseg_req_seq.mtusize_0 = mtusize_1;
   ll_ds_mseg_req_seq.pdulength_0 = pdu_length_1;   
   ll_ds_mseg_req_seq.start(vseq_ll_sequencer);  
   begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with DATA STREAMING MULTI SEGMENT   "),UVM_LOW); end

  endtask

endclass :srio_ll_ds_mseg_req_seq

//================LFC XOFF SEQUENCES ============

class srio_ll_lfc_xoff_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_lfc_xoff_seq)

  srio_ll_lfc_random_seq  ll_lfc_xoff_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	//for(int i = 0; i < 10 ;i++) begin //{
          ll_lfc_xoff_seq   = srio_ll_lfc_random_seq::type_id::create("ll_lfc_xoff_seq");
  	
          ll_lfc_xoff_seq.ftype_0 = 4'h7;
          ll_lfc_xoff_seq.xon_xoff_0 = 1'b0;
	  ll_lfc_xoff_seq.FAM_0 = 3'b000;
	  
          ll_lfc_xoff_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with LFC XOFF SEQUENCE   "),UVM_LOW); end


	//end //}

  endtask

endclass :srio_ll_lfc_xoff_seq

//================LFC XON SEQUENCES ============

class srio_ll_lfc_xon_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_lfc_xon_seq)

  srio_ll_lfc_random_seq  ll_lfc_xon_seq ;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 10 ;i++) begin //{
          ll_lfc_xon_seq   = srio_ll_lfc_random_seq::type_id::create("ll_lfc_xon_seq");
  	
          ll_lfc_xon_seq.xon_xoff_0 = 1'b1;
	  ll_lfc_xon_seq.FAM_0 = 3'b000;
	  ll_lfc_xon_seq.ftype_0 = 4'h7;
	  
          ll_lfc_xon_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with LFC XON SEQUENCE   "),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}
	
  endtask

endclass :srio_ll_lfc_xon_seq

//================LFC XON/XOFF SEQUENCES ============

class srio_ll_lfc_xon_xoff_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_lfc_xon_xoff_seq)

  srio_ll_lfc_random_seq  ll_lfc_xon_xoff_seq ;
    function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	          ll_lfc_xon_xoff_seq  = srio_ll_lfc_random_seq::type_id::create("ll_lfc_xon_xoff_seq");
          ll_lfc_xon_xoff_seq.start(vseq_ll_sequencer);
	
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with LFC XON AND XOFF SEQUENCE   "),UVM_LOW); end

  endtask

endclass :srio_ll_lfc_xon_xoff_seq

//================LFC MULTI XOFF  ORPAHEND SEQUENCES ============

class srio_ll_lfc_multi_xoff_orphaned_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_lfc_multi_xoff_orphaned_seq)

  srio_ll_lfc_random_seq  ll_lfc_multi_xoff_orphaned_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 10 ;i++) begin //{
          ll_lfc_multi_xoff_orphaned_seq   = srio_ll_lfc_random_seq::type_id::create("ll_lfc_multi_xoff_orphaned_seq");
  	  ll_lfc_multi_xoff_orphaned_seq.ftype_0 = 4'h7;
          ll_lfc_multi_xoff_orphaned_seq.xon_xoff_0 = 1'b0;
	  ll_lfc_multi_xoff_orphaned_seq.FAM_0 = 3'b000;
	  
          ll_lfc_multi_xoff_orphaned_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with LFC MULTI XOFF ORPHANED SEQUENCE   "),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}
endtask

endclass :srio_ll_lfc_multi_xoff_orphaned_seq


//================LFC XOFF(ARB_0)  SEQUENCES ============

class srio_ll_lfc_xoff_arb_0_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_lfc_xoff_arb_0_seq)
  rand bit [6:0] flowid;
  srio_ll_lfc_seq  ll_lfc_xoff_arb_0_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	
          ll_lfc_xoff_arb_0_seq   = srio_ll_lfc_seq::type_id::create("ll_lfc_xoff_arb_0_seq");
  	  ll_lfc_xoff_arb_0_seq.ftype_0 = 4'h7;
          ll_lfc_xoff_arb_0_seq.xon_xoff_0 = 1'b0;
	  ll_lfc_xoff_arb_0_seq.tgtdestID_0 = 32'h1;
	  ll_lfc_xoff_arb_0_seq.DestinationID_0 =32'hFFFF_FFFF;
	  ll_lfc_xoff_arb_0_seq.FAM_0 = 3'b010;
	  ll_lfc_xoff_arb_0_seq.flowID_0 = flowid;
	  
          ll_lfc_xoff_arb_0_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with LFC XOFF ARB_0 SEQUENCE   "),UVM_LOW); end

  endtask

endclass :srio_ll_lfc_xoff_arb_0_seq

//================LFC XOFF(ARB_1)  SEQUENCES ============

class srio_ll_lfc_xoff_arb_1_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_lfc_xoff_arb_1_seq)
  rand bit [6:0] flowid;
  srio_ll_lfc_seq  ll_lfc_xoff_arb_1_seq ;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	

          ll_lfc_xoff_arb_1_seq   = srio_ll_lfc_seq::type_id::create("ll_lfc_xoff_arb_1_seq");
  	 ll_lfc_xoff_arb_1_seq.ftype_0 = 4'h7;
          ll_lfc_xoff_arb_1_seq.xon_xoff_0 = 1'b0;
	  ll_lfc_xoff_arb_1_seq.tgtdestID_0 = 32'h1;
	  ll_lfc_xoff_arb_1_seq.DestinationID_0 =32'hFFFF_FFFF;
	  ll_lfc_xoff_arb_1_seq.FAM_0 = 3'b011;
	  ll_lfc_xoff_arb_1_seq.flowID_0 = flowid;
	  
          ll_lfc_xoff_arb_1_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with LFC XOFF ARB_1 SEQUENCE   "),UVM_LOW); end

  endtask

endclass :srio_ll_lfc_xoff_arb_1_seq


//================LFC MULTI XON WITHOUT XOFF SEQUENCES ============

class srio_ll_lfc_multi_xon_without_xoff_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_lfc_multi_xon_without_xoff_seq)
  rand bit [6:0] flowid;
  srio_ll_lfc_seq  ll_lfc_multi_xon_without_xoff_seq ;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();

          ll_lfc_multi_xon_without_xoff_seq   = srio_ll_lfc_seq::type_id::create("ll_lfc_multi_xon_without_xoff_seq");
  	  ll_lfc_multi_xon_without_xoff_seq.ftype_0 = 4'h7;
          ll_lfc_multi_xon_without_xoff_seq.xon_xoff_0 = 1'b1;
	  ll_lfc_multi_xon_without_xoff_seq.tgtdestID_0 = 32'h2;
	  ll_lfc_multi_xon_without_xoff_seq.DestinationID_0 =32'hFFFF_FFFF;
	  ll_lfc_multi_xon_without_xoff_seq.FAM_0 = 3'b000;
	  ll_lfc_multi_xon_without_xoff_seq.flowID_0 = flowid;
	  
          ll_lfc_multi_xon_without_xoff_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with LFC MULTI XOFF ORPHANED SEQUENCE   "),UVM_LOW); end

          endtask

endclass :srio_ll_lfc_multi_xon_without_xoff_seq


//================LFC XOFF(REQUEST FOR GRANTED)  SEQUENCES ============

class srio_ll_lfc_xoff_request_flow_grnt_1_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_lfc_xoff_request_flow_grnt_1_seq)
  rand bit [6:0] flowid;
  srio_ll_lfc_seq  ll_lfc_xoff_request_flow_grnt_1_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	          ll_lfc_xoff_request_flow_grnt_1_seq   = srio_ll_lfc_seq::type_id::create("ll_lfc_xoff_request_flow_grnt_1_seq");
  	  ll_lfc_xoff_request_flow_grnt_1_seq.ftype_0 = 4'h7;
          ll_lfc_xoff_request_flow_grnt_1_seq.xon_xoff_0 = 1'b1;
	  ll_lfc_xoff_request_flow_grnt_1_seq.tgtdestID_0 = 32'h2;
	  ll_lfc_xoff_request_flow_grnt_1_seq.DestinationID_0 =32'hFFFF_FFFF;
	  ll_lfc_xoff_request_flow_grnt_1_seq.FAM_0 = 3'b011;
	  ll_lfc_xoff_request_flow_grnt_1_seq.flowID_0 = flowid;
	  
          ll_lfc_xoff_request_flow_grnt_1_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with LFC XOFF REQUEST FOR GRANTED_1 SEQUENCE   "),UVM_LOW); end

  endtask

endclass :srio_ll_lfc_xoff_request_flow_grnt_1_seq

//================LFC XOFF(REQUEST FOR GRANTED_0)  SEQUENCES ============

class srio_ll_lfc_xoff_request_flow_grnt_0_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_lfc_xoff_request_flow_grnt_0_seq)

  rand bit [6:0] flowid;
  srio_ll_lfc_seq  ll_lfc_xoff_request_flow_grnt_0_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
          ll_lfc_xoff_request_flow_grnt_0_seq   = srio_ll_lfc_seq::type_id::create("ll_lfc_xoff_request_flow_grnt_0_seq");
  	  ll_lfc_xoff_request_flow_grnt_0_seq.ftype_0 = 4'h7;
          ll_lfc_xoff_request_flow_grnt_0_seq.xon_xoff_0 = 1'b1;
	  ll_lfc_xoff_request_flow_grnt_0_seq.tgtdestID_0 = 32'h2;
	  ll_lfc_xoff_request_flow_grnt_0_seq.DestinationID_0 =32'hFFFF_FFFF;
	  ll_lfc_xoff_request_flow_grnt_0_seq.FAM_0 = 3'b010;
	  ll_lfc_xoff_request_flow_grnt_0_seq.flowID_0 = flowid;
	  
          ll_lfc_xoff_request_flow_grnt_0_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with LFC XOFF REQUEST FOR GRANTED_0 SEQUENCE   "),UVM_LOW); end

  endtask


endclass :srio_ll_lfc_xoff_request_flow_grnt_0_seq

//==============TRAFFIC MANAGEMENT RANDOM SEQUENCES=============

class srio_ll_traffic_mgmt_random_req_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_traffic_mgmt_random_req_seq)

  rand bit [3:0] TMmode_0;
  srio_ll_traffic_mgmt_req_seq ll_traffic_mgmt_random_req_seq;

  function new(string name="");
  super.new(name);
  endfunction

  task body();
	super.body();
        repeat(50) begin //{	
        ll_traffic_mgmt_random_req_seq  = srio_ll_traffic_mgmt_req_seq::type_id::create("ll_traffic_mgmt_sseg_req_seq");

  	ll_traffic_mgmt_random_req_seq.ftype_0 = 4'h9;
        ll_traffic_mgmt_random_req_seq.xh_0 = 1'b1;
        ll_traffic_mgmt_random_req_seq.TMOP_0 = TMmode_0;
        ll_traffic_mgmt_random_req_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with DATA STREAMING SINGLE SEGMENT   "),UVM_LOW); end
       end //}
  endtask

endclass :srio_ll_traffic_mgmt_random_req_seq

//==============DS AND TRAFFIC MANAGEMENT RANDOM SEQUENCES=============

class srio_ll_ds_traffic_mgmt_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_traffic_mgmt_seq)

   rand bit [3:0] TMmode_0;
   rand bit [7:0] mtusize_1;
   rand bit [15:0] pdu_length_1; 
   srio_ll_ds_traffic_mgmt_base_seq ll_ds_traffic_mgmt_base_seq;
   function new(string name="");
    super.new(name);
   endfunction

  task body();
	super.body();
        repeat(10) begin //{	
        ll_ds_traffic_mgmt_base_seq = srio_ll_ds_traffic_mgmt_base_seq ::type_id::create("ll_ds_traffic_mgmt_base_seq");
        ll_ds_traffic_mgmt_base_seq.xh_0 = $urandom;
        ll_ds_traffic_mgmt_base_seq.mtusize_0 = mtusize_1;
        ll_ds_traffic_mgmt_base_seq.pdulength_0 = pdu_length_1;
        ll_ds_traffic_mgmt_base_seq.TMOP_0 = TMmode_0;
        ll_ds_traffic_mgmt_base_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with DATA STREAMING AND TRAFFIC PACKET"),UVM_LOW); end
        end //}
  endtask

endclass :srio_ll_ds_traffic_mgmt_seq

//================ TRAFFIC MANAGEMENT FOR BASIC STREAM MANAGEMENT SEQUENCES ===

class srio_ll_ds_traffic_mgmt_basic_stream_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_traffic_mgmt_basic_stream_seq)

   rand bit [3:0] TMmode_0;

   srio_ll_ds_traffic_mgmt_basic_stream_base_seq ll_ds_traffic_mgmt_basic_stream_seq;
  function new(string name="");
   super.new(name);
  endfunction

  task body();
	super.body();

         ll_ds_traffic_mgmt_basic_stream_seq   =srio_ll_ds_traffic_mgmt_basic_stream_base_seq::type_id::create("ll_ds_traffic_mgmt_basic_stream_seq");
  	
        ll_ds_traffic_mgmt_basic_stream_seq.xh_0 = 1'b1;
	ll_ds_traffic_mgmt_basic_stream_seq.TMOP_0 = TMmode_0;
	ll_ds_traffic_mgmt_basic_stream_seq.ftype_0 = 4'h9;	
	ll_ds_traffic_mgmt_basic_stream_seq.wild_card_0 = 3'b0;
	ll_ds_traffic_mgmt_basic_stream_seq.parameter1_0 = 8'h3; 	  
        ll_ds_traffic_mgmt_basic_stream_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with TRAFFIC MANAGEMENT FOR BASIC STREAM MANAGEMENT SEQUENCE   "),UVM_LOW); end

  endtask

endclass :srio_ll_ds_traffic_mgmt_basic_stream_seq
//================ TRAFFIC MANAGEMENT FOR RATE CONTROL MANAGEMENT SEQUENCES ====

class srio_ll_ds_traffic_mgmt_rate_control_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_traffic_mgmt_rate_control_seq)
   rand bit [3:0] TMmode_0;

   srio_ll_ds_traffic_mgmt_rate_based_base_seq ll_ds_traffic_mgmt_rate_control_seq;
  function new(string name="");
  super.new(name);
  endfunction

  task body();
	super.body();
        repeat( 20) begin //{
        ll_ds_traffic_mgmt_rate_control_seq   = srio_ll_ds_traffic_mgmt_rate_based_base_seq::type_id::create("ll_ds_traffic_mgmt_rate_control_seq");
  	ll_ds_traffic_mgmt_rate_control_seq.ftype_0 = 4'h9;	
        ll_ds_traffic_mgmt_rate_control_seq.xh_0 = 1'b1;
	ll_ds_traffic_mgmt_rate_control_seq.TMOP_0 = TMmode_0;
	ll_ds_traffic_mgmt_rate_control_seq.wild_card_0 = 3'b0;
	ll_ds_traffic_mgmt_rate_control_seq.parameter1_0 = 8'h1;	  	  
         ll_ds_traffic_mgmt_rate_control_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with TRAFFIC MANAGEMENT FOR RATE CONTROL MANAGEMENT SEQUENCE   "),UVM_LOW); end
       end //}
  endtask

endclass :srio_ll_ds_traffic_mgmt_rate_control_seq
//================ TRAFFIC MANAGEMENT FOR CREDIT CONTROL MANAGEMENT SEQUENCES ============

class srio_ll_ds_traffic_mgmt_credit_control_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_traffic_mgmt_credit_control_seq)

   rand bit [3:0] TMmode_0;

   srio_ll_ds_traffic_mgmt_credit_based_base_seq ll_ds_traffic_mgmt_credit_control_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
        ll_ds_traffic_mgmt_credit_control_seq   = srio_ll_ds_traffic_mgmt_credit_based_base_seq::type_id::create("ll_ds_traffic_mgmt_credit_control_seq");
  	
        ll_ds_traffic_mgmt_credit_control_seq.xh_0 = 1'b1;
	ll_ds_traffic_mgmt_credit_control_seq.TMOP_0 = TMmode_0;
	ll_ds_traffic_mgmt_credit_control_seq.ftype_0 = 4'h9;	
	ll_ds_traffic_mgmt_credit_control_seq.wild_card_0 = 3'b0;
        ll_ds_traffic_mgmt_credit_control_seq.cos_0 = 8'h1F;
        ll_ds_traffic_mgmt_credit_control_seq.streamID_0 = 16'h3F;
	ll_ds_traffic_mgmt_credit_control_seq.parameter1_0 = $urandom_range(32'd31,32'd16);  
         ll_ds_traffic_mgmt_credit_control_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with TRAFFIC MANAGEMENT FOR CREDIT CONTROL MANAGEMENT SEQUENCE   "),UVM_LOW); end

  endtask

endclass :srio_ll_ds_traffic_mgmt_credit_control_seq
//================ TRAFFIC MANAGEMENT FOR CREDIT AND RATE CONTROL MANAGEMENT SEQUENCES ============
class srio_ll_ds_traffic_mgmt_credit_rate_control_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_traffic_mgmt_credit_rate_control_seq)
  rand bit [3:0] TMmode_0;

  srio_ll_ds_traffic_mgmt_credit_rate_based_base_seq  ll_ds_traffic_mgmt_credit_rate_control_seq;
	bit tm_mode;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
        ll_ds_traffic_mgmt_credit_rate_control_seq   = srio_ll_ds_traffic_mgmt_credit_rate_based_base_seq::type_id::create("ll_ds_traffic_mgmt_credit_rate_control_seq");
 		
        ll_ds_traffic_mgmt_credit_rate_control_seq.xh_0 = 1'b1;
	ll_ds_traffic_mgmt_credit_rate_control_seq.TMOP_0 = TMmode_0;
	ll_ds_traffic_mgmt_credit_rate_control_seq.ftype_0 = 4'h9;	
	ll_ds_traffic_mgmt_credit_rate_control_seq.wild_card_0 = 3'b0;
	ll_ds_traffic_mgmt_credit_rate_control_seq.parameter1_0 = 8'h00;	  
        ll_ds_traffic_mgmt_credit_rate_control_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with TRAFFIC MANAGEMENT FOR APPLICATION DEFINED STREAM CONTROL MANAGEMENT SEQUENCE   "),UVM_LOW); end
  endtask

endclass :srio_ll_ds_traffic_mgmt_credit_rate_control_seq


//================GSM RANDOM CLASS============

class srio_ll_gsm_random_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_gsm_random_seq)
   srio_ll_gsm_class_random_seq ll_gsm_class_random_seq;

  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 1000 ;i++) begin //{
	ll_gsm_class_random_seq = srio_ll_gsm_class_random_seq::type_id::create("ll_gsm_class_random_seq");
      
        ll_gsm_class_random_seq.start(vseq_ll_sequencer); 
        
	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  GSM CLASS 1"),UVM_LOW); end
         	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  GSM CLASS 2"),UVM_LOW); end
end //}
   #1ns;
  endtask

endclass : srio_ll_gsm_random_seq


//================GSM READ OWNER============

class srio_ll_gsm_rd_owner_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_gsm_rd_owner_seq)
   srio_ll_gsm_class_seq ll_gsm_rd_owner_seq;
      function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 1 ;i++) begin //{

          ll_gsm_rd_owner_seq = srio_ll_gsm_class_seq::type_id::create("ll_gsm_rd_owner_seq");
  	
         
                  
          ll_gsm_rd_owner_seq.ftype_0 = 4'h1;
	  ll_gsm_rd_owner_seq.ttype_0 = 4'h0;
          ll_gsm_rd_owner_seq.start(vseq_ll_sequencer); 
        
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  READ OWNER"),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}


  endtask

endclass : srio_ll_gsm_rd_owner_seq

//================GSM READ TO OWN OWNER============

class srio_ll_gsm_rd_to_own_owner_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_gsm_rd_to_own_owner_seq)

   srio_ll_gsm_class_seq ll_gsm_rd_to_own_owner_seq;
    function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 1 ;i++) begin //{

          ll_gsm_rd_to_own_owner_seq = srio_ll_gsm_class_seq::type_id::create("ll_gsm_rd_to_own_owner_seq");
  	
         
        
          ll_gsm_rd_to_own_owner_seq.ftype_0 = 4'h1;
	  ll_gsm_rd_to_own_owner_seq.ttype_0 = 4'h1;
          ll_gsm_rd_to_own_owner_seq.start(vseq_ll_sequencer); 
         
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  READ TO OWN OWNER"),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}

  endtask

endclass : srio_ll_gsm_rd_to_own_owner_seq

//================GSM I/O READ OWNER============

class srio_ll_gsm_io_rd_owner_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_gsm_io_rd_owner_seq)
  srio_ll_gsm_class_seq ll_gsm_io_rd_owner_seq;
       function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 1 ;i++) begin //{

          ll_gsm_io_rd_owner_seq = srio_ll_gsm_class_seq::type_id::create("ll_gsm_io_rd_owner_seq");
  	
         

          ll_gsm_io_rd_owner_seq.ftype_0 = 4'h1;
	  ll_gsm_io_rd_owner_seq.ttype_0 = 4'h2;
          ll_gsm_io_rd_owner_seq.start(vseq_ll_sequencer); 
         
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  I/O READ OWNER"),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}

  endtask

endclass : srio_ll_gsm_io_rd_owner_seq

//================GSM READ HOME============

class srio_ll_gsm_read_home_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_gsm_read_home_seq)
  srio_ll_gsm_class_seq ll_gsm_read_home_seq;
       function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	
	for(int i = 0; i < 1 ;i++) begin //{

          ll_gsm_read_home_seq = srio_ll_gsm_class_seq::type_id::create("ll_gsm_read_home_seq");
  	
        
          ll_gsm_read_home_seq.ftype_0 = 4'h2;
	  ll_gsm_read_home_seq.ttype_0 = 4'h0;
          ll_gsm_read_home_seq.start(vseq_ll_sequencer); 
        	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  READ HOME"),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}

  endtask

endclass : srio_ll_gsm_read_home_seq

//================GSM READ TO OWN HOME============

class srio_ll_gsm_read_to_own_home_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_gsm_read_to_own_home_seq)
	srio_ll_gsm_class_seq ll_gsm_read_to_own_home_seq;
       function new(string name="");
    	super.new(name);
  	endfunction

  task body();
	super.body();
	for(int i = 0; i < 1 ;i++) begin //{

          ll_gsm_read_to_own_home_seq = srio_ll_gsm_class_seq::type_id::create("ll_gsm_read_to_own_home_seq");
  	
        
          ll_gsm_read_to_own_home_seq.ftype_0 = 4'h2;
	  ll_gsm_read_to_own_home_seq.ttype_0 = 4'h1;
          ll_gsm_read_to_own_home_seq.start(vseq_ll_sequencer); 
         
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  READ TO OWN HOME"),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}

  endtask

endclass : srio_ll_gsm_read_to_own_home_seq

//================GSM I/O READ HOME============

class srio_ll_gsm_io_read_home_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_gsm_io_read_home_seq)
	srio_ll_gsm_class_seq ll_gsm_io_read_home_seq;
       function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	
	for(int i = 0; i < 1 ;i++) begin //{

          ll_gsm_io_read_home_seq = srio_ll_gsm_class_seq::type_id::create("ll_gsm_io_read_home_seq");
  	
        
          ll_gsm_io_read_home_seq.ftype_0 = 4'h2;
	  ll_gsm_io_read_home_seq.ttype_0 = 4'h2;
          ll_gsm_io_read_home_seq.start(vseq_ll_sequencer); 
         
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  I/O READ HOME"),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}

  endtask

endclass : srio_ll_gsm_io_read_home_seq

//================GSM DKILL HOME============

class srio_ll_gsm_dkill_home_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_gsm_dkill_home_seq)
	srio_ll_gsm_class_seq ll_gsm_dkill_home_seq;
       function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
		for(int i = 0; i < 1 ;i++) begin //{

          ll_gsm_dkill_home_seq = srio_ll_gsm_class_seq::type_id::create("ll_gsm_dkill_home_seq");
  	
                  ll_gsm_dkill_home_seq.ftype_0 = 4'h2;
	  ll_gsm_dkill_home_seq.ttype_0 = 4'h3;
          ll_gsm_dkill_home_seq.start(vseq_ll_sequencer); 
        
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  DKILL HOME"),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}

  endtask

endclass : srio_ll_gsm_dkill_home_seq

//================GSM IKILL HOME============

class srio_ll_gsm_ikill_home_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_gsm_ikill_home_seq)
	srio_ll_gsm_class_seq ll_gsm_ikill_home_seq;
       function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	
	for(int i = 0; i < 1 ;i++) begin //{

          ll_gsm_ikill_home_seq = srio_ll_gsm_class_seq::type_id::create("ll_gsm_ikill_home_seq");
  	
                  ll_gsm_ikill_home_seq.ftype_0 = 4'h2;
	  ll_gsm_ikill_home_seq.ttype_0 = 4'h5;
          ll_gsm_ikill_home_seq.start(vseq_ll_sequencer); 
        
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  IKILL HOME"),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}

  endtask

endclass : srio_ll_gsm_ikill_home_seq

//================GSM TLBIE============

class srio_ll_gsm_tlbie_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_gsm_tlbie_seq)
	srio_ll_gsm_class_seq ll_gsm_tlbie_seq ;
       function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	
	for(int i = 0; i < 1 ;i++) begin //{

          ll_gsm_tlbie_seq = srio_ll_gsm_class_seq::type_id::create("ll_gsm_tlbie_seq");
  	
        
          ll_gsm_tlbie_seq.ftype_0 = 4'h2;
	  ll_gsm_tlbie_seq.ttype_0 = 4'h6;
          ll_gsm_tlbie_seq.start(vseq_ll_sequencer); 
   	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  TLBIE"),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}

  endtask

endclass : srio_ll_gsm_tlbie_seq

//================GSM TLSYNC============

class srio_ll_gsm_tlbsync_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_gsm_tlbsync_seq)
	srio_ll_gsm_class_seq ll_gsm_tlbsync_seq;
       function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();

	for(int i = 0; i < 1 ;i++) begin //{

          ll_gsm_tlbsync_seq = srio_ll_gsm_class_seq::type_id::create("ll_gsm_tlbsync_seq");
  	
        
          ll_gsm_tlbsync_seq.ftype_0 = 4'h2;
	  ll_gsm_tlbsync_seq.ttype_0 = 4'h7;
          ll_gsm_tlbsync_seq.start(vseq_ll_sequencer); 
        
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  TLSYNC"),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}

  endtask

endclass : srio_ll_gsm_tlbsync_seq

//================GSM IREAD HOME============

class srio_ll_gsm_iread_home_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_gsm_iread_home_seq)
	srio_ll_gsm_class_seq ll_gsm_iread_home_seq;
       function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
		for(int i = 0; i < 1 ;i++) begin //{

          ll_gsm_iread_home_seq = srio_ll_gsm_class_seq::type_id::create("ll_gsm_iread_home_seq");
  	
          ll_gsm_iread_home_seq.ftype_0 = 4'h2;
	  ll_gsm_iread_home_seq.ttype_0 = 4'h8;
          ll_gsm_iread_home_seq.start(vseq_ll_sequencer); 
        	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  IREAD HOME"),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}

  endtask

endclass : srio_ll_gsm_iread_home_seq

//================GSM FLUSH WITHOUT DATA============

class srio_ll_gsm_flush_without_data_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_gsm_flush_without_data_seq)
	srio_ll_gsm_class_seq ll_gsm_flush_without_data_seq;
       function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	
	for(int i = 0; i < 1 ;i++) begin //{

          ll_gsm_flush_without_data_seq = srio_ll_gsm_class_seq::type_id::create("ll_gsm_flush_without_data_seq");
  	
          ll_gsm_flush_without_data_seq.ftype_0 = 4'h2;
	  ll_gsm_flush_without_data_seq.ttype_0 = 4'h9;
          ll_gsm_flush_without_data_seq.start(vseq_ll_sequencer); 
        	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  FLUSH WITHOUT DATA"),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}

  endtask

endclass : srio_ll_gsm_flush_without_data_seq

//================GSM IKILL SHARER============

class srio_ll_gsm_ikill_sharer_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_gsm_ikill_sharer_seq)
	srio_ll_gsm_class_seq ll_gsm_ikill_sharer_seq ;
       function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
		for(int i = 0; i < 1 ;i++) begin //{

          ll_gsm_ikill_sharer_seq = srio_ll_gsm_class_seq::type_id::create("ll_gsm_ikill_sharer_seq");
  	
          ll_gsm_ikill_sharer_seq.ftype_0 = 4'h2;
	  ll_gsm_ikill_sharer_seq.ttype_0 = 4'hA;
          ll_gsm_ikill_sharer_seq.start(vseq_ll_sequencer); 
        
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  IKILL SHARER"),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}

  endtask

endclass : srio_ll_gsm_ikill_sharer_seq

//================GSM DKILL SHARER============

class srio_ll_gsm_dkill_sharer_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_gsm_dkill_sharer_seq)
	srio_ll_gsm_class_seq ll_gsm_dkill_sharer_seq ;
       function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 1 ;i++) begin //{

          ll_gsm_dkill_sharer_seq = srio_ll_gsm_class_seq::type_id::create("ll_gsm_dkill_sharer_seq");
  	
          ll_gsm_dkill_sharer_seq.ftype_0 = 4'h2;
	  ll_gsm_dkill_sharer_seq.ttype_0 = 4'hB;
          ll_gsm_dkill_sharer_seq.start(vseq_ll_sequencer); 
        begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  DKILL SHARER"),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}

  endtask

endclass : srio_ll_gsm_dkill_sharer_seq

//================CASTOUT SEQUENCE============

class srio_ll_gsm_castout_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_gsm_castout_seq)

  srio_ll_gsm_class_seq ll_gsm_castout_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 1 ;i++) begin //{

        ll_gsm_castout_seq = srio_ll_gsm_class_seq::type_id::create("ll_gsm_castout_seq");
  	
          ll_gsm_castout_seq.ftype_0 = 4'h5;
	  ll_gsm_castout_seq.ttype_0 = 4'h0;

          ll_gsm_castout_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  CASTOUT"),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}

  endtask

endclass : srio_ll_gsm_castout_seq

//================FLUSH WITH DATA SEQUENCE============

class srio_ll_gsm_flush_with_data_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_gsm_flush_with_data_seq)

  srio_ll_gsm_class_seq ll_gsm_flush_with_data_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body(); for(int i = 0; i < 1 ;i++) begin //{

        ll_gsm_flush_with_data_seq = srio_ll_gsm_class_seq::type_id::create("ll_gsm_flush_with_data_seq");
  	
          ll_gsm_flush_with_data_seq.ftype_0 = 4'h5;
	  ll_gsm_flush_with_data_seq.ttype_0 = 4'h1;

          ll_gsm_flush_with_data_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  FLUSH WITH DATA"),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}

  endtask

endclass : srio_ll_gsm_flush_with_data_seq


//=======PL SEQUENCES ===================

class srio_pl_pkt_acc_cs_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_pkt_acc_cs_seq)

	 rand bit [0:11] ackid_1;
         rand bit [0:11] param_value_0;

        srio_pl_control_base_seq pl_pkt_acc_cs_seq;

      function new(string name="");
      super.new(name);
       endfunction

  task body();
	super.body();
 	
        pl_pkt_acc_cs_seq =srio_pl_control_base_seq ::type_id::create("pl_pkt_acc_cs_seq");
  	
        //env_config.pl_config.pkt_acc_gen_kind = PL_DISABLED;
        pl_pkt_acc_cs_seq.stype0_1 = 4'b0000;
	pl_pkt_acc_cs_seq.param0_1  = ackid_1;
	pl_pkt_acc_cs_seq.param1_1  = param_value_0;
	pl_pkt_acc_cs_seq.start(vseq_pl_sequencer);  
	
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with PACKET ACCEPTED CONTROL SYMBOLS SEQUENCE"),UVM_LOW); end
	//end //}
  endtask

endclass : srio_pl_pkt_acc_cs_seq

//======PACKET RETRY ======

class srio_pl_pkt_rty_cs_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_pkt_rty_cs_seq)
        
	rand bit [0:11] ackid_1;
        rand bit [0:11] param_value_0;

	srio_pl_control_base_seq pl_pkt_rty_cs_seq;
	
      function new(string name="");
      super.new(name);
      endfunction

  task body();
	super.body();

        pl_pkt_rty_cs_seq =srio_pl_control_base_seq ::type_id::create("pl_pkt_rty_cs_seq");
        //env_config.pl_config.pkt_acc_gen_kind = PL_DISABLED;
  	pl_pkt_rty_cs_seq.stype0_1 = 4'b0001;
	pl_pkt_rty_cs_seq.param0_1  =ackid_1;
	pl_pkt_rty_cs_seq.param1_1  =param_value_0 ;

         pl_pkt_rty_cs_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with PACKET RETRY CONTROL SYMBOLS SEQUENCE"),UVM_LOW); end
 endtask

endclass : srio_pl_pkt_rty_cs_seq

//======PACKET NOT ACCEPTED ======

class srio_pl_pkt_na_cs_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_pkt_na_cs_seq)

     rand bit [0:11] ackid_1;
     rand bit [0:11] param_value_0;
     rand bit mode;
     srio_pl_control_base_seq pl_pkt_na_cs_seq;

    function new(string name="");
    super.new(name);
    endfunction

  task body();
	super.body();
        pl_pkt_na_cs_seq =srio_pl_control_base_seq ::type_id::create("pl_pkt_na_cs_seq");
  	 
        pl_pkt_na_cs_seq.stype0_1 = 4'b0010;
	pl_pkt_na_cs_seq.param0_1  =  ackid_1;
	pl_pkt_na_cs_seq.param1_1  = param_value_0; 
	pl_pkt_na_cs_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with PACKET NOT ACCEPTED CONTROL SYMBOLS SEQUENCE"),UVM_LOW); end
  endtask

endclass : srio_pl_pkt_na_cs_seq
//======PACKET VIRTUAL CHANNEL STATUS  ======

class srio_pl_vc_st_cs_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_vc_st_cs_seq)
      rand bit [0:11] ackid_1;
      rand bit [0:11] param_value_0;
  
     srio_pl_control_base_seq pl_vc_st_cs_seq;	
    
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();

        pl_vc_st_cs_seq =srio_pl_control_base_seq ::type_id::create("pl_vc_st_cs_seq");
   	
        pl_vc_st_cs_seq.stype0_1 = 4'b101;
	pl_vc_st_cs_seq.param0_1  =ackid_1;
        pl_vc_st_cs_seq.param1_1  =param_value_0;
        pl_vc_st_cs_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with PACKET VIRTUAL CHANNEL STATUS  CONTROL SYMBOLS SEQUENCE"),UVM_LOW); end
	  endtask

endclass : srio_pl_vc_st_cs_seq

//======PACKET STATUS CS  ======

class srio_pl_st_cs_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_st_cs_seq)
      rand bit [0:11] ackid_1;
      rand bit [0:11] param_value_0;
  
     srio_pl_control_base_seq pl_st_cs_seq;	
    
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();

        pl_st_cs_seq =srio_pl_control_base_seq ::type_id::create("pl_st_cs_seq");
   	
        pl_st_cs_seq.stype0_1 = 4'b100;
	pl_st_cs_seq.param0_1  =ackid_1;
        pl_st_cs_seq.param1_1  =param_value_0;
        pl_st_cs_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with PACKET STATUS  CONTROL SYMBOLS SEQUENCE"),UVM_LOW); end
	  endtask

endclass : srio_pl_st_cs_seq

//======PACKET LINK RESPONSE  ======

class srio_pl_link_response_cs_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_link_response_cs_seq)
   rand bit [0:11] ackid_1;
   rand bit [0:11] param_value_0;
   
   srio_pl_control_base_seq pl_link_response_cs_seq;
	
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	
        pl_link_response_cs_seq =srio_pl_control_base_seq ::type_id::create("pl_link_response_cs_seq");
  	
       	
        pl_link_response_cs_seq.stype0_1 = 4'b110;
	pl_link_response_cs_seq.param0_1  =ackid_1;
	pl_link_response_cs_seq.param1_1  =param_value_0;
        pl_link_response_cs_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with PACKET LINK RESPONSE  CONTROL SYMBOLS SEQUENCE"),UVM_LOW); end

  endtask

endclass : srio_pl_link_response_cs_seq

//======PACKET START OF PACKET  ======
class srio_pl_sop_cs_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_sop_cs_seq)
   
   rand bit [0:11] ackid_1;
   rand bit [0:11] param_value_0;
   srio_pl_stype1_cs_seq pl_sop_cs_seq; 
	   
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	

        pl_sop_cs_seq =srio_pl_stype1_cs_seq ::type_id::create("pl_sop_cs_seq");
        pl_sop_cs_seq.stype1_1 = 4'b0000;
        pl_sop_cs_seq.cmd_1 = 3'b000;
        pl_sop_cs_seq.param1_1  = param_value_0; 
        pl_sop_cs_seq.start(vseq_pl_sequencer);  
        begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with PACKET SOP OF PACKET  CONTROL SYMBOLS SEQUENCE"),UVM_LOW); end
	
	endtask

endclass : srio_pl_sop_cs_seq



//======PACKET END OF PACKET  ======
class srio_pl_eop_cs_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_eop_cs_seq)
  
   rand bit [0:11] ackid_1;
   rand bit [0:11] param_value_0;
   srio_pl_stype1_cs_seq pl_eop_cs_seq;  
     
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();


        pl_eop_cs_seq =srio_pl_stype1_cs_seq ::type_id::create("pl_eop_cs_seq");
  	
        pl_eop_cs_seq.stype1_1 = 4'b0010;
        pl_eop_cs_seq.cmd_1 = 3'b000;
        pl_eop_cs_seq.param1_1  = param_value_0;
       
	pl_eop_cs_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with PACKET END OF PACKET  CONTROL SYMBOLS SEQUENCE"),UVM_LOW); end
	
  endtask

endclass : srio_pl_eop_cs_seq


//======PACKET STOMP PACKET  ======

class srio_pl_stomp_cs_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_stomp_cs_seq)

   
   rand bit [0:11] ackid_1;
   rand bit [0:11] param_value_0;

    srio_pl_stype1_cs_seq pl_stomp_cs_seq; 
  
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	pl_stomp_cs_seq =srio_pl_stype1_cs_seq ::type_id::create("pl_stomp_cs_seq");
  	
        pl_stomp_cs_seq.stype1_1 = 4'b0001;
        pl_stomp_cs_seq.cmd_1 = 3'b000;	
        pl_stomp_cs_seq.param1_1  = param_value_0;
        
        pl_stomp_cs_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with PACKET STOMP PACKET  CONTROL SYMBOLS SEQUENCE"),UVM_LOW); end
  endtask

endclass : srio_pl_stomp_cs_seq

//======RESTART FROM RETRY PACKET  ======

class srio_pl_restart_rty_cs_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_restart_rty_cs_seq)
   
   rand bit [0:11] ackid_1;
   rand bit [0:11] param_value_0;
    srio_pl_stype1_cs_seq pl_restart_rty_cs_seq;
     
  
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();

        pl_restart_rty_cs_seq =srio_pl_stype1_cs_seq ::type_id::create("pl_restart_rty_cs_seq");
  	
        pl_restart_rty_cs_seq.stype1_1 = 4'b011;
        pl_restart_rty_cs_seq.cmd_1 = 3'b000;
        pl_restart_rty_cs_seq.param1_1  = param_value_0;
        
	pl_restart_rty_cs_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with RESTART FROM RETRYPACKET  CONTROL SYMBOLS SEQUENCE"),UVM_LOW); end
  endtask

endclass : srio_pl_restart_rty_cs_seq

//======LINK REQUEST RESET DEVICE  PACKET  ======

class srio_pl_link_req_rst_dev_cs_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_link_req_rst_dev_cs_seq)
   
   rand bit [0:11] ackid_1;
   rand bit [0:11] param_value_0;
  srio_pl_stype1_cs_seq pl_link_req_rst_dev_cs_seq;
     
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	

        pl_link_req_rst_dev_cs_seq =srio_pl_stype1_cs_seq ::type_id::create("pl_link_req_rst_dev_cs_seq");
  	
        pl_link_req_rst_dev_cs_seq.stype1_1 = 4'b100;
        pl_link_req_rst_dev_cs_seq.cmd_1 = 3'b011;
        pl_link_req_rst_dev_cs_seq.param1_1  = param_value_0;
        
        pl_link_req_rst_dev_cs_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with LINK REQUEST RESET DEVICE  PACKET  CONTROL SYMBOLS SEQUENCE"),UVM_LOW); end
  endtask

endclass : srio_pl_link_req_rst_dev_cs_seq

//======LINK REQUEST INPUT DEVICE  PACKET  ======

class srio_pl_link_req_input_dev_cs_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_link_req_input_dev_cs_seq)
    
    rand bit [0:11] ackid_1;
    rand bit [0:11] param_value_0;
   srio_pl_stype1_cs_seq pl_link_req_input_dev_cs_seq;  
 
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	
        pl_link_req_input_dev_cs_seq =srio_pl_stype1_cs_seq ::type_id::create("pl_link_req_input_dev_cs_seq");
  	
        pl_link_req_input_dev_cs_seq.stype1_1 = 4'b100;
        pl_link_req_input_dev_cs_seq.cmd_1 = 3'b100;
        pl_link_req_input_dev_cs_seq.param1_1  = param_value_0;
        
        pl_link_req_input_dev_cs_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with LINK REQUEST INPUT DEVICE  PACKET  CONTROL SYMBOLS SEQUENCE"),UVM_LOW); end

  endtask

endclass : srio_pl_link_req_input_dev_cs_seq
//======LINK REQUEST RESET PORT PACKET  ======

class srio_pl_link_req_rst_port_cs_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_link_req_rst_port_cs_seq)
   
   rand bit [0:11] ackid_1;
   rand bit [0:11] param_value_0;
  srio_pl_stype1_cs_seq pl_link_req_rst_port_cs_seq;
     
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	

        pl_link_req_rst_port_cs_seq =srio_pl_stype1_cs_seq ::type_id::create("pl_link_req_rst_port_cs_seq");
  	
        pl_link_req_rst_port_cs_seq.stype1_1 = 4'b100;
        pl_link_req_rst_port_cs_seq.cmd_1 = 3'b010;
        pl_link_req_rst_port_cs_seq.param1_1  = param_value_0;
        
        pl_link_req_rst_port_cs_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with LINK REQUEST RESET PORT  PACKET  CONTROL SYMBOLS SEQUENCE"),UVM_LOW); end
  endtask

endclass : srio_pl_link_req_rst_port_cs_seq
//======PACKET NOP PACKET  ======

class srio_pl_nop_cs_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_nop_cs_seq)
    
    rand bit [0:11] ackid_1;
    rand bit [0:11] param_value_0;
    	srio_pl_stype1_cs_seq pl_nop_cs_seq;
 
	function new(string name="");
    	super.new(name);
  	endfunction

  task body();
	super.body();
        
        pl_nop_cs_seq =srio_pl_stype1_cs_seq ::type_id::create("pl_nop_cs_seq");
  	
        pl_nop_cs_seq.stype1_1 = 4'b111;
        pl_nop_cs_seq.cmd_1 = 3'b000;
        pl_nop_cs_seq.param1_1  = param_value_0;
        
        pl_nop_cs_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with PACKET NOP PACKET  CONTROL SYMBOLS SEQUENCE"),UVM_LOW); end

  endtask

endclass : srio_pl_nop_cs_seq


//======DISCOVERY TO NXMODE  ======

class srio_pl_dis_nxmode_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_dis_nxmode_sm_seq)
    srio_pl_dis_nxmode_sm_base_seq pl_dis_nxmode_sm_seq;   
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_dis_nxmode_sm_seq = srio_pl_dis_nxmode_sm_base_seq::type_id::create("pl_dis_nxmode_sm_seq");
  	
        pl_dis_nxmode_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with discovery to nx mode "),UVM_LOW); end
  endtask

endclass : srio_pl_dis_nxmode_sm_seq

//======DISCOVERY TO 2XMODE  ======

class srio_pl_dis_2xmode_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_dis_2xmode_sm_seq)
  srio_pl_dis_2xmode_sm_base_seq pl_dis_2xmode_sm_seq;     
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_dis_2xmode_sm_seq = srio_pl_dis_2xmode_sm_base_seq::type_id::create("pl_dis_2xmode_sm_seq");
  	
        pl_dis_2xmode_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with discovery to 2xmode "),UVM_LOW); end
  endtask

endclass : srio_pl_dis_2xmode_sm_seq

//======DISCOVERY TO 1XMODE LANE_0 STATE TRANSITION  ======

class srio_pl_dis_1xmode_ln0_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_dis_1xmode_ln0_sm_seq)
  srio_pl_dis_1xmode_ln0_sm_base_seq pl_dis_1xmode_ln0_sm_seq;     
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_dis_1xmode_ln0_sm_seq = srio_pl_dis_1xmode_ln0_sm_base_seq::type_id::create("pl_dis_1xmode_ln0_sm_seq");
  	
        pl_dis_1xmode_ln0_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with discovery to 1xmode lane0"),UVM_LOW); end
  endtask

endclass : srio_pl_dis_1xmode_ln0_sm_seq

//====== DISCOVERY TO 1XMODE LANE_1 STATE TRANSITION ======

class srio_pl_dis_1xmode_ln1_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_dis_1xmode_ln1_sm_seq)
   srio_pl_dis_1xmode_ln1_sm_base_seq pl_dis_1xmode_ln1_sm_seq;    
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_dis_1xmode_ln1_sm_seq = srio_pl_dis_1xmode_ln1_sm_base_seq::type_id::create("pl_dis_1xmode_ln1_sm_seq");
  	
        pl_dis_1xmode_ln1_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with DISCOVERY TO 1XMODE LANE_1 STATE TRANSITION  "),UVM_LOW); end
  endtask

endclass : srio_pl_dis_1xmode_ln1_sm_seq

//====== DISCOVERY TO 1XMODE LANE_2 STATE TRANSITION ======

class srio_pl_dis_1xmode_ln2_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_dis_1xmode_ln2_sm_seq)
  srio_pl_dis_1xmode_ln2_sm_base_seq pl_dis_1xmode_ln2_sm_seq;     
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_dis_1xmode_ln2_sm_seq = srio_pl_dis_1xmode_ln2_sm_base_seq::type_id::create("pl_dis_1xmode_ln2_sm_seq");
  	
        pl_dis_1xmode_ln2_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with DISCOVERY TO 1XMODE LANE_2 STATE TRANSITION "),UVM_LOW); end
  endtask

endclass : srio_pl_dis_1xmode_ln2_sm_seq

//====== 1XMODE LANE_0COVERY TO 1XMODE LANE_1 STATE TRANSITION ======

class srio_pl_1xmode_ln0_1xmode_ln1_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_1xmode_ln0_1xmode_ln1_sm_seq)
   srio_pl_1xmode_ln0_1xmode_ln1_sm_base_seq pl_1xmode_ln0_1xmode_ln1_sm_seq;    
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_1xmode_ln0_1xmode_ln1_sm_seq = srio_pl_1xmode_ln0_1xmode_ln1_sm_base_seq::type_id::create("pl_1xmode_ln0_1xmode_ln1_sm_seq");
  	
        pl_1xmode_ln0_1xmode_ln1_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with 1XMODE LANE_0COVERY TO 1XMODE LANE_1 STATE TRANSITION  "),UVM_LOW); end
  endtask

endclass : srio_pl_1xmode_ln0_1xmode_ln1_sm_seq

//====== 1XMODE LANE_0COVERY TO 1XMODE LANE_2 STATE TRANSITION ======

class srio_pl_1xmode_ln0_1xmode_ln2_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_1xmode_ln0_1xmode_ln2_sm_seq)
  srio_pl_1xmode_ln0_1xmode_ln2_sm_base_seq pl_1xmode_ln0_1xmode_ln2_sm_seq;     
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_1xmode_ln0_1xmode_ln2_sm_seq = srio_pl_1xmode_ln0_1xmode_ln2_sm_base_seq::type_id::create("pl_1xmode_ln0_1xmode_ln2_sm_seq");
  	
        pl_1xmode_ln0_1xmode_ln2_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with 1XMODE LANE_0COVERY TO 1XMODE LANE_2 STATE TRANSITION "),UVM_LOW); end
  endtask

endclass : srio_pl_1xmode_ln0_1xmode_ln2_sm_seq


//======DISCOVERY TO SILENT STATE TRANSITION  ======

class srio_pl_dis_sl_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_dis_sl_sm_seq)
  srio_pl_dis_sl_sm_base_seq pl_dis_sl_sm_seq;     
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_dis_sl_sm_seq = srio_pl_dis_sl_sm_base_seq::type_id::create("pl_dis_sl_sm_seq");
  	
        pl_dis_sl_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with DISCOVERY TO SILENT STATE TRANSITION "),UVM_LOW); end
  endtask

endclass : srio_pl_dis_sl_sm_seq

//======NXMODE TO SILENT STATE TRANSITION  ======

class srio_pl_nxmode_sl_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_nxmode_sl_sm_seq)
   srio_pl_nxmode_sl_sm_base_seq pl_nxmode_sl_sm_seq;    
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_nxmode_sl_sm_seq = srio_pl_nxmode_sl_sm_base_seq::type_id::create("pl_nxmode_sl_sm_seq");
  	
        pl_nxmode_sl_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with NXMODE TO SILENT STATE TRANSITION "),UVM_LOW); end
  endtask

endclass : srio_pl_nxmode_sl_sm_seq

//====== NXMODE TO DISCOVERY STATE TRANSITION  ======

class srio_pl_nxmode_dis_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_nxmode_dis_sm_seq)
  srio_pl_nxmode_dis_sm_base_seq pl_nxmode_dis_sm_seq ;     
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_nxmode_dis_sm_seq = srio_pl_nxmode_dis_sm_base_seq::type_id::create("pl_nxmode_dis_sm_seq");
  	
        pl_nxmode_dis_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with NXMODE TO DISCOVERY STATE TRANSITION   "),UVM_LOW); end
  endtask

endclass : srio_pl_nxmode_dis_sm_seq

//====== 2XMODE TO SILENT STATE TRANSITION ======

class srio_pl_2xmode_sl_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_2xmode_sl_sm_seq)
  srio_pl_2xmode_sl_sm_base_seq pl_2xmode_sl_sm_seq;     
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_2xmode_sl_sm_seq = srio_pl_2xmode_sl_sm_base_seq::type_id::create("pl_2xmode_sl_sm_seq");
  	
        pl_2xmode_sl_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  2XMODE TO SILENT STATE TRANSITION"),UVM_LOW); end
  endtask

endclass : srio_pl_2xmode_sl_sm_seq

//====== 2XMODE TO 1XMODE_LANE0 STATE TRANSITION ======

class srio_pl_2xmode_1xmode_ln0_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_2xmode_1xmode_ln0_sm_seq)
  srio_pl_2xmode_1xmode_ln0_sm_base_seq pl_2xmode_1xmode_ln0_sm_seq;     
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_2xmode_1xmode_ln0_sm_seq = srio_pl_2xmode_1xmode_ln0_sm_base_seq::type_id::create("pl_2xmode_1xmode_ln0_sm_seq");
  	
        pl_2xmode_1xmode_ln0_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  2XMODE TO 1XMODE_LANE0 STATE TRANSITION"),UVM_LOW); end
  endtask

endclass : srio_pl_2xmode_1xmode_ln0_sm_seq

//====== 2XMODE TO 1XMODE_LANE1 STATE TRANSITION ======

class srio_pl_2xmode_1xmode_ln1_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_2xmode_1xmode_ln1_sm_seq)
  srio_pl_2xmode_1xmode_ln1_sm_base_seq pl_2xmode_1xmode_ln1_sm_seq;     
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_2xmode_1xmode_ln1_sm_seq = srio_pl_2xmode_1xmode_ln1_sm_base_seq::type_id::create("pl_2xmode_1xmode_ln1_sm_seq");
  	
        pl_2xmode_1xmode_ln1_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  2XMODE TO 1XMODE_LANE1 STATE TRANSITION"),UVM_LOW); end
  endtask

endclass : srio_pl_2xmode_1xmode_ln1_sm_seq


//====== 2XMODE TO 2X RECOVERY STATE TRANSITION ======

class srio_pl_2xmode_2x_rec_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_2xmode_2x_rec_sm_seq)
  srio_pl_2xmode_2x_rec_sm_base_seq pl_2xmode_2x_rec_sm_seq;     
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_2xmode_2x_rec_sm_seq = srio_pl_2xmode_2x_rec_sm_base_seq::type_id::create("pl_2xmode_2x_rec_sm_seq");
  	
        pl_2xmode_2x_rec_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with 2XMODE TO 2X RECOVERY STATE TRANSITION "),UVM_LOW); end
  endtask

endclass : srio_pl_2xmode_2x_rec_sm_seq

//====== 1XMODE LANE_0 TO SILENT STATE TRANSITION ======

class srio_pl_1xmode_ln0_sl_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_1xmode_ln0_sl_sm_seq)
  srio_pl_1xmode_ln0_sl_sm_base_seq pl_1xmode_ln0_sl_sm_seq;     
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_1xmode_ln0_sl_sm_seq = srio_pl_1xmode_ln0_sl_sm_base_seq::type_id::create("pl_1xmode_ln0_sl_sm_seq");
  	
        pl_1xmode_ln0_sl_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with 1XMODE LANE_0 TO SILENT STATE TRANSITION "),UVM_LOW); end
  endtask

endclass : srio_pl_1xmode_ln0_sl_sm_seq

//====== 1XMODE LANE_1 TO SILENT STATE TRANSITION  ======

class srio_pl_1xmode_ln1_sl_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_1xmode_ln1_sl_sm_seq)
   srio_pl_1xmode_ln1_sl_sm_base_seq pl_1xmode_ln1_sl_sm_seq;    
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_1xmode_ln1_sl_sm_seq = srio_pl_1xmode_ln1_sl_sm_base_seq::type_id::create("pl_1xmode_ln1_sl_sm_seq");
  	
        pl_1xmode_ln1_sl_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with 1XMODE LANE_1 TO SILENT STATE TRANSITION  "),UVM_LOW); end
  endtask

endclass : srio_pl_1xmode_ln1_sl_sm_seq

//====== 1XMODE LANE_2 TO SILENT STATE TRANSITION   ======

class srio_pl_1xmode_ln2_sl_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_1xmode_ln2_sl_sm_seq)
   srio_pl_1xmode_ln2_sl_sm_base_seq pl_1xmode_ln2_sl_sm_seq;    
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_1xmode_ln2_sl_sm_seq = srio_pl_1xmode_ln2_sl_sm_base_seq::type_id::create("pl_1xmode_ln2_sl_sm_seq");
  	
        pl_1xmode_ln2_sl_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with 1XMODE LANE_2 TO SILENT STATE TRANSITION   "),UVM_LOW); end
  endtask

endclass : srio_pl_1xmode_ln2_sl_sm_seq

//====== 1XMODE LANE_2 TO 1X RECOVERY STATE TRANSITION ======

class srio_pl_1xmode_ln2_1x_rec_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_1xmode_ln2_1x_rec_sm_seq)
  srio_pl_1xmode_ln2_1x_rec_sm_base_seq pl_1xmode_ln2_1x_rec_sm_seq;     
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_1xmode_ln2_1x_rec_sm_seq = srio_pl_1xmode_ln2_1x_rec_sm_base_seq::type_id::create("pl_1xmode_ln2_1x_rec_sm_seq");
  	
        pl_1xmode_ln2_1x_rec_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with 1XMODE LANE_2 TO 1X RECOVERY STATE TRANSITION "),UVM_LOW); end
  endtask

endclass : srio_pl_1xmode_ln2_1x_rec_sm_seq

//====== 1XMODE LANE_1 TO 1X RECOVERY STATE TRANSITION ======

class srio_pl_1xmode_ln1_1x_rec_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_1xmode_ln1_1x_rec_sm_seq)
  srio_pl_1xmode_ln1_1x_rec_sm_base_seq pl_1xmode_ln1_1x_rec_sm_seq;     
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_1xmode_ln1_1x_rec_sm_seq = srio_pl_1xmode_ln1_1x_rec_sm_base_seq::type_id::create("pl_1xmode_ln1_1x_rec_sm_seq");
  	
        pl_1xmode_ln1_1x_rec_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with 1XMODE LANE_1 TO 1X RECOVERY STATE TRANSITION  "),UVM_LOW); end
  endtask

endclass : srio_pl_1xmode_ln1_1x_rec_sm_seq

//====== 1XMODE LANE_0 TO 1X RECOVERY STATE TRANSITION ======

class srio_pl_1xmode_ln0_1x_rec_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_1xmode_ln0_1x_rec_sm_seq)
    srio_pl_1xmode_ln0_1x_rec_sm_base_seq pl_1xmode_ln0_1x_rec_sm_seq;    
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_1xmode_ln0_1x_rec_sm_seq = srio_pl_1xmode_ln0_1x_rec_sm_base_seq::type_id::create("pl_1xmode_ln0_1x_rec_sm_seq");
  	
        pl_1xmode_ln0_1x_rec_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with 1XMODE LANE_0 TO 1X RECOVERY STATE TRANSITION "),UVM_LOW); end
  endtask

endclass : srio_pl_1xmode_ln0_1x_rec_sm_seq

//====== 2X RECOVERY TO 2X MODE STATE TRANSITION ======

class srio_pl_2x_rec_2xmode_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_2x_rec_2xmode_sm_seq)
   srio_pl_2x_rec_2xmode_sm_base_seq pl_2x_rec_2xmode_sm_seq;    
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_2x_rec_2xmode_sm_seq = srio_pl_2x_rec_2xmode_sm_base_seq::type_id::create("pl_2x_rec_2xmode_sm_seq");
  	
        pl_2x_rec_2xmode_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with 2X RECOVERY TO 2X MODE STATE TRANSITION "),UVM_LOW); end
  endtask

endclass : srio_pl_2x_rec_2xmode_sm_seq

//====== 2X RECOVERY TO 1X MODE LANE_0 STATE TRANSITION ======

class srio_pl_2x_rec_1xmode_ln0_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_2x_rec_1xmode_ln0_sm_seq)
  srio_pl_2x_rec_1xmode_ln0_sm_base_seq pl_2x_rec_1xmode_ln0_sm_seq;     
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_2x_rec_1xmode_ln0_sm_seq = srio_pl_2x_rec_1xmode_ln0_sm_base_seq::type_id::create("pl_2x_rec_1xmode_ln0_sm_seq");
  	
        pl_2x_rec_1xmode_ln0_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with 2X RECOVERY TO 1X MODE LANE_0 STATE TRANSITION "),UVM_LOW); end
  endtask

endclass : srio_pl_2x_rec_1xmode_ln0_sm_seq

//====== 2X RECOVERY TO 1X MODE LANE_1 STATE TRANSITION  ======

class srio_pl_2x_rec_1xmode_ln1_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_2x_rec_1xmode_ln1_sm_seq)
  srio_pl_2x_rec_1xmode_ln1_sm_base_seq pl_2x_rec_1xmode_ln1_sm_seq;     
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_2x_rec_1xmode_ln1_sm_seq = srio_pl_2x_rec_1xmode_ln1_sm_base_seq::type_id::create("pl_2x_rec_1xmode_ln1_sm_seq");
  	
        pl_2x_rec_1xmode_ln1_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with 2X RECOVERY TO 1X MODE LANE_1 STATE TRANSITION   "),UVM_LOW); end
  endtask

endclass : srio_pl_2x_rec_1xmode_ln1_sm_seq

//======2X RECOVERY TO SILENT STATE TRANSITION   ======

class srio_pl_2x_rec_sl_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_2x_rec_sl_sm_seq)
    srio_pl_2x_rec_sl_sm_base_seq pl_2x_rec_sl_sm_seq;   
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_2x_rec_sl_sm_seq = srio_pl_2x_rec_sl_sm_base_seq::type_id::create("pl_2x_rec_sl_sm_seq");
  	
        pl_2x_rec_sl_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with 2X RECOVERY TO SILENT STATE TRANSITION  "),UVM_LOW); end
  endtask

endclass : srio_pl_2x_rec_sl_sm_seq

//====== 1X RECOVERY TO SILENT STATE TRANSITION ======

class srio_pl_1x_rec_sl_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_1x_rec_sl_sm_seq)
    srio_pl_1x_rec_sl_sm_base_seq pl_1x_rec_sl_sm_seq;   
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_1x_rec_sl_sm_seq = srio_pl_1x_rec_sl_sm_base_seq::type_id::create("pl_1x_rec_sl_sm_seq");
  	
        pl_1x_rec_sl_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with 1X RECOVERY TO SILENT STATE TRANSITION "),UVM_LOW); end
  endtask

endclass : srio_pl_1x_rec_sl_sm_seq

//====== 1X RECOVERY TO 1X MODE LANE_0 STATE TRANSITION ======

class srio_pl_1x_rec_1xmode_ln0_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_1x_rec_1xmode_ln0_sm_seq)

    srio_pl_1x_rec_1xmode_ln0_sm_base_seq pl_1x_rec_1xmode_ln0_sm_seq; 
  
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_1x_rec_1xmode_ln0_sm_seq = srio_pl_1x_rec_1xmode_ln0_sm_base_seq::type_id::create("pl_1x_rec_1xmode_ln0_sm_seq");
  	
        pl_1x_rec_1xmode_ln0_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with 1X RECOVERY TO 1X MODE LANE_0 STATE TRANSITION  "),UVM_LOW); end
  endtask

endclass : srio_pl_1x_rec_1xmode_ln0_sm_seq

//====== 1X RECOVERY TO 1X MODE LANE_1 STATE TRANSITION  ======

class srio_pl_1x_rec_1xmode_ln1_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_1x_rec_1xmode_ln1_sm_seq)
  srio_pl_1x_rec_1xmode_ln1_sm_base_seq pl_1x_rec_1xmode_ln1_sm_seq;     
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_1x_rec_1xmode_ln1_sm_seq = srio_pl_1x_rec_1xmode_ln1_sm_base_seq::type_id::create("pl_1x_rec_1xmode_ln1_sm_seq");
  	
        pl_1x_rec_1xmode_ln1_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with 1X RECOVERY TO 1X MODE LANE_1 STATE TRANSITION "),UVM_LOW); end
  endtask

endclass : srio_pl_1x_rec_1xmode_ln1_sm_seq

//======  1X RECOVERY TO 1X MODE LANE_2 STATE TRANSITION ======

class srio_pl_1x_rec_1xmode_ln2_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_1x_rec_1xmode_ln2_sm_seq)
   srio_pl_1x_rec_1xmode_ln2_sm_base_seq pl_1x_rec_1xmode_ln2_sm_seq;    
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_1x_rec_1xmode_ln2_sm_seq = srio_pl_1x_rec_1xmode_ln2_sm_base_seq::type_id::create("pl_1x_rec_1xmode_ln2_sm_seq");
  	
        pl_1x_rec_1xmode_ln2_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with 1X RECOVERY TO 1X MODE LANE_2 STATE TRANSITION "),UVM_LOW); end
  endtask

endclass : srio_pl_1x_rec_1xmode_ln2_sm_seq


//======FTYPE ERROR SEQUENCES====================

class srio_ll_ftype_error_seq extends srio_virtual_base_seq;

  `uvm_object_utils(srio_ll_ftype_error_seq)
	
	srio_ll_ftype_error_base_seq ll_ftype_error_base_seq;


	function new(string name="");
    	super.new(name);
  	endfunction

	task body();
	super.body();
	repeat(5) begin //{
     
        ll_ftype_error_base_seq = srio_ll_ftype_error_base_seq::type_id::create("ll_ftype_error_base_seq");
  	
         
	ll_ftype_error_base_seq.start(vseq_ll_sequencer);  

 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  INVALID FTYPE"),UVM_LOW); end
     end //}
  endtask

endclass : srio_ll_ftype_error_seq

//======TTYPE ERROR SEQUENCES====================

class srio_ll_ttype_error_seq extends srio_virtual_base_seq;

  `uvm_object_utils(srio_ll_ttype_error_seq)
	
     	
	srio_ll_ttype_error_base_seq ll_ttype_error_base_seq;


	function new(string name="");
    	super.new(name);
  	endfunction

	task body();
	super.body();
	repeat(5) begin //{
     
        ll_ttype_error_base_seq = srio_ll_ttype_error_base_seq::type_id::create("ll_ttype_error_base_seq");
  	
         
	ll_ttype_error_base_seq.start(vseq_ll_sequencer);  

 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  INVALID TTYPE"),UVM_LOW); end
     end //}
  endtask

endclass : srio_ll_ttype_error_seq

//======MAX_SIZE ERROR SEQUENCES====================


class srio_ll_max_size_error_seq extends srio_virtual_base_seq;

  `uvm_object_utils(srio_ll_max_size_error_seq)
	
     	
	srio_ll_max_size_error_base_seq ll_max_size_error_base_seq;


	function new(string name="");
    	super.new(name);
  	endfunction

	task body();
	super.body();
	repeat(5) begin //{
     
        ll_max_size_error_base_seq = srio_ll_max_size_error_base_seq::type_id::create("ll_max_size_error_base_seq");
  	
         
	ll_max_size_error_base_seq.start(vseq_ll_sequencer);  

 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  INVALID MAX_SIZE"),UVM_LOW); end
     end //}
  endtask

endclass : srio_ll_max_size_error_seq

//======PAYLOAD  ERROR SEQUENCES====================

class srio_ll_payload_error_seq extends srio_virtual_base_seq;

  `uvm_object_utils(srio_ll_payload_error_seq)
	
     	
	srio_ll_payload_error_base_seq ll_payload_error_base_seq;


	function new(string name="");
    	super.new(name);
  	endfunction

	task body();
	super.body();
	repeat(5) begin //{
     
        ll_payload_error_base_seq = srio_ll_payload_error_base_seq::type_id::create("ll_payload_error_base_seq");
  	
         
	ll_payload_error_base_seq.start(vseq_ll_sequencer);  

 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  INVALID PAYLOAD "),UVM_LOW); end
     end //}
  endtask

endclass : srio_ll_payload_error_seq

//======SIZE  ERROR SEQUENCES====================

class srio_ll_size_error_seq extends srio_virtual_base_seq;

  `uvm_object_utils(srio_ll_size_error_seq)
	
     	
	srio_ll_size_error_base_seq ll_size_error_base_seq;


	function new(string name="");
    	super.new(name);
  	endfunction

	task body();
	super.body();
	repeat(5) begin //{
     
        ll_size_error_base_seq = srio_ll_size_error_base_seq::type_id::create("ll_size_error_base_seq");
  	
         
	ll_size_error_base_seq.start(vseq_ll_sequencer);  

 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  INVALID SIZE "),UVM_LOW); end
     end //}
  endtask

endclass : srio_ll_size_error_seq

//======NO_PAYLOAD  ERROR SEQUENCES====================

class srio_ll_no_payload_error_seq extends srio_virtual_base_seq;

  `uvm_object_utils(srio_ll_no_payload_error_seq)
	
     	
	srio_ll_no_payload_error_base_seq ll_no_payload_error_base_seq;


	function new(string name="");
    	super.new(name);
  	endfunction

	task body();
	super.body();
	repeat(5) begin //{
     
        ll_no_payload_error_base_seq = srio_ll_no_payload_error_base_seq::type_id::create("ll_no_payload_error_base_seq");
  	
         
	ll_no_payload_error_base_seq.start(vseq_ll_sequencer);  

 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  INVALID NO_PAYLOAD "),UVM_LOW); end
     end //}
  endtask

endclass : srio_ll_no_payload_error_seq

//======PAYLOAD_EXIST  ERROR SEQUENCES========

class srio_ll_payload_exist_error_seq extends srio_virtual_base_seq;

  `uvm_object_utils(srio_ll_payload_exist_error_seq)
	
     	
	srio_ll_payload_exist_error_base_seq ll_payload_exist_error_base_seq;


	function new(string name="");
    	super.new(name);
  	endfunction

	task body();
	super.body();
	repeat(5) begin //{
     
        ll_payload_exist_error_base_seq = srio_ll_payload_exist_error_base_seq::type_id::create("ll_payload_exist_error_base_seq");
  	
         
	ll_payload_exist_error_base_seq.start(vseq_ll_sequencer);  

 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  INVALID PAYLOAD_EXIST "),UVM_LOW); end
     end //}
  endtask

endclass : srio_ll_payload_exist_error_seq
//======ATAS_PAYLOAD_ERR ERROR SEQUENCES====================

class srio_ll_atomic_test_and_swap_payload_error_seq extends srio_virtual_base_seq;

  `uvm_object_utils(srio_ll_atomic_test_and_swap_payload_error_seq)
	
     	
	srio_ll_atomic_test_and_swap_payload_error_base_seq ll_atomic_test_and_swap_payload_error_base_seq;


	function new(string name="");
    	super.new(name);
  	endfunction

	task body();
	super.body();
	repeat(5) begin //{
     
        ll_atomic_test_and_swap_payload_error_base_seq = srio_ll_atomic_test_and_swap_payload_error_base_seq::type_id::create("ll_atomic_test_and_swap_payload_error_base_seq");
  	
         
	ll_atomic_test_and_swap_payload_error_base_seq.start(vseq_ll_sequencer);  

 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  INVALID ATAS_PAYLOAD_ERR"),UVM_LOW); end
     end //}
  endtask

endclass : srio_ll_atomic_test_and_swap_payload_error_seq

//======AS_PAYLOAD_ERR ERROR SEQUENCES====================

class srio_ll_atomic_swap_error_seq extends srio_virtual_base_seq;

  `uvm_object_utils(srio_ll_atomic_swap_error_seq)
	
     	
	srio_ll_atomic_swap_error_base_seq ll_atomic_swap_error_base_seq;


	function new(string name="");
    	super.new(name);
  	endfunction

	task body();
	super.body();
	repeat(5) begin //{
     
        ll_atomic_swap_error_base_seq = srio_ll_atomic_swap_error_base_seq::type_id::create("ll_atomic_swap_error_base_seq");
  	
         
	ll_atomic_swap_error_base_seq.start(vseq_ll_sequencer);  

 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  INVALID AS_PAYLOAD_ERR"),UVM_LOW); end
     end //}
  endtask

endclass : srio_ll_atomic_swap_error_seq

//======ACAS_PAYLOAD_ERR ERROR SEQUENCES====================

class srio_ll_atomic_compare_and_swap_error_seq extends srio_virtual_base_seq;

  `uvm_object_utils(srio_ll_atomic_compare_and_swap_error_seq)
	
     	
	srio_ll_atomic_compare_and_swap_error_base_seq ll_atomic_compare_and_swap_error_base_seq;


	function new(string name="");
    	super.new(name);
  	endfunction

	task body();
	super.body();
	repeat(5) begin //{
     
        ll_atomic_compare_and_swap_error_base_seq = srio_ll_atomic_compare_and_swap_error_base_seq::type_id::create("ll_atomic_compare_and_swap_error_base_seq");
  	
          
	ll_atomic_compare_and_swap_error_base_seq.start(vseq_ll_sequencer);  

 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  INVALID ACAS_PAYLOAD_ERR"),UVM_LOW); end
     end //}
  endtask

endclass : srio_ll_atomic_compare_and_swap_error_seq

//======DW_ALIGN_ERR ERROR SEQUENCES====================

class srio_ll_doubleword_align_error_seq extends srio_virtual_base_seq;

  `uvm_object_utils(srio_ll_doubleword_align_error_seq)
	
     	
	srio_ll_doubleword_align_error_base_seq ll_doubleword_align_error_base_seq;


	function new(string name="");
    	super.new(name);
  	endfunction

	task body();
	super.body();
	repeat(5) begin //{
     
        ll_doubleword_align_error_base_seq = srio_ll_doubleword_align_error_base_seq::type_id::create("ll_doubleword_align_error_base_seq");
  	
         
	ll_doubleword_align_error_base_seq.start(vseq_ll_sequencer);  

 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  INVALID DW_ALIGN_ERR"),UVM_LOW); end
     end //}
  endtask

endclass : srio_ll_doubleword_align_error_seq


//======LFC_PRI  ERROR SEQUENCES====================

class srio_ll_lfc_pri_error_seq extends srio_virtual_base_seq;

  `uvm_object_utils(srio_ll_lfc_pri_error_seq)
	
     	
	srio_ll_lfc_pri_error_base_seq ll_lfc_pri_error_base_seq;


	function new(string name="");
    	super.new(name);
  	endfunction

	task body();
	super.body();
	repeat(5) begin //{
     
        ll_lfc_pri_error_base_seq = srio_ll_lfc_pri_error_base_seq::type_id::create("ll_lfc_pri_error_base_seq");
  	
         
	ll_lfc_pri_error_base_seq.start(vseq_ll_sequencer);  

 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  INVALID LFC_PRI "),UVM_LOW); end
     end //}
  endtask

endclass : srio_ll_lfc_pri_error_seq

//======DS_MTU_ERR  ERROR SEQUENCES====================

class srio_ll_ds_mtu_error_seq extends srio_virtual_base_seq;

  `uvm_object_utils(srio_ll_ds_mtu_error_seq)
	
     	rand bit [7:0] mtusize_1;
        rand bit [16:0] pdu_length_1;

	srio_ll_ds_mtu_error_base_seq ll_ds_mtu_error_base_seq;
	function new(string name="");
    	super.new(name);
  	endfunction

	task body();
	super.body();
	repeat(1) begin //{
     
        ll_ds_mtu_error_base_seq = srio_ll_ds_mtu_error_base_seq::type_id::create("ll_ds_mtu_error_base_seq");
  	
        ll_ds_mtu_error_base_seq.mtusize_0 = mtusize_1;
        ll_ds_mtu_error_base_seq.pdulength_0 = pdu_length_1;
	ll_ds_mtu_error_base_seq.start(vseq_ll_sequencer);  

 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  INVALID DS_MTU_ERR "),UVM_LOW); end
     end //}
  endtask

endclass : srio_ll_ds_mtu_error_seq

//======DS_PDU  ERROR SEQUENCES====================

class srio_ll_ds_pdu_error_seq extends srio_virtual_base_seq;

  `uvm_object_utils(srio_ll_ds_pdu_error_seq)
	
        rand bit [7:0] mtusize_1;
        rand bit [16:0] pdu_length_1;	
	srio_ll_ds_pdu_error_base_seq ll_ds_pdu_error_base_seq;
	function new(string name="");
    	super.new(name);
  	endfunction

	task body();
	super.body();
	repeat(1) begin //{
     
        ll_ds_pdu_error_base_seq = srio_ll_ds_pdu_error_base_seq::type_id::create("ll_ds_pdu_error_base_seq");
  	
        ll_ds_pdu_error_base_seq.mtusize_0 = mtusize_1;
        ll_ds_pdu_error_base_seq.pdulength_0 = pdu_length_1; 
	ll_ds_pdu_error_base_seq.start(vseq_ll_sequencer);  

 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  INVALID DS_PDU "),UVM_LOW); end
     end //}
  endtask

endclass : srio_ll_ds_pdu_error_seq

//======DS_SOP  ERROR SEQUENCES====================

class srio_ll_ds_sop_error_seq extends srio_virtual_base_seq;

  `uvm_object_utils(srio_ll_ds_sop_error_seq)
	
     	rand bit [7:0] mtusize_1;
        rand bit [16:0] pdu_length_1;

	srio_ll_ds_sop_error_base_seq ll_ds_sop_error_base_seq;

	function new(string name="");
    	super.new(name);
  	endfunction

	task body();
	super.body();
	repeat(1) begin //{
     
        ll_ds_sop_error_base_seq = srio_ll_ds_sop_error_base_seq::type_id::create("ll_ds_sop_error_base_seq");
  	
        ll_ds_sop_error_base_seq.mtusize_0 = mtusize_1;
        ll_ds_sop_error_base_seq.pdulength_0 = pdu_length_1;
	ll_ds_sop_error_base_seq.start(vseq_ll_sequencer);  

 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  INVALID DS_SOP "),UVM_LOW); end
     end //}
  endtask

endclass : srio_ll_ds_sop_error_seq

//======DS_EOP  ERROR SEQUENCES====================

class srio_ll_ds_eop_error_seq extends srio_virtual_base_seq;

  `uvm_object_utils(srio_ll_ds_eop_error_seq)
	
     	rand bit [7:0] mtusize_1;
        rand bit [16:0] pdu_length_1;
	srio_ll_ds_eop_error_base_seq ll_ds_eop_error_base_seq;

	function new(string name="");
    	super.new(name);
  	endfunction

	task body();
	super.body();
        ll_ds_eop_error_base_seq = srio_ll_ds_eop_error_base_seq::type_id::create("ll_ds_eop_error_base_seq");
  	
        ll_ds_eop_error_base_seq.mtusize_0 = mtusize_1;
        ll_ds_eop_error_base_seq.pdulength_0 = pdu_length_1;
	ll_ds_eop_error_base_seq.start(vseq_ll_sequencer);  

 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  INVALID DS_EOP "),UVM_LOW); end
       endtask

endclass : srio_ll_ds_eop_error_seq

//======DS_PAD  ERROR SEQUENCES====================

class srio_ll_ds_pad_error_seq extends srio_virtual_base_seq;

  `uvm_object_utils(srio_ll_ds_pad_error_seq)
	
     	rand bit [7:0] mtusize_1;
        rand bit [16:0] pdu_length_1;
	srio_ll_ds_pad_error_base_seq ll_ds_pad_error_base_seq;

	function new(string name="");
    	super.new(name);
  	endfunction

	task body();
	super.body();
	     
        ll_ds_pad_error_base_seq = srio_ll_ds_pad_error_base_seq::type_id::create("ll_ds_pad_error_base_seq");
  	
        ll_ds_pad_error_base_seq.mtusize_0 = mtusize_1;
        ll_ds_pad_error_base_seq.pdulength_0 = pdu_length_1;
	ll_ds_pad_error_base_seq.start(vseq_ll_sequencer);  

 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  INVALID DS_PAD "),UVM_LOW); end
    
  endtask

endclass : srio_ll_ds_pad_error_seq

//======MSG_SSIZE  ERROR SEQUENCES====================

class srio_ll_msg_ssize_error_seq extends srio_virtual_base_seq;

  `uvm_object_utils(srio_ll_msg_ssize_error_seq)
	
	srio_ll_msg_ssize_error_base_seq ll_msg_ssize_error_base_seq;
	function new(string name="");
    	super.new(name);
  	endfunction

	task body();
	super.body();

     
        ll_msg_ssize_error_base_seq = srio_ll_msg_ssize_error_base_seq::type_id::create("ll_msg_ssize_error_base_seq");
  	
         
	ll_msg_ssize_error_base_seq.start(vseq_ll_sequencer);  

 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  INVALID MSG_SSIZE "),UVM_LOW); end
       endtask

endclass : srio_ll_msg_ssize_error_seq

//======MSGSEG  ERROR SEQUENCES====================

class srio_ll_msgseg_error_seq extends srio_virtual_base_seq;

  `uvm_object_utils(srio_ll_msgseg_error_seq)
	
     	
	srio_ll_msgseg_error_base_seq ll_msgseg_error_base_seq;


	function new(string name="");
    	super.new(name);
  	endfunction

	task body();
	super.body();
	repeat(5) begin //{
     
        ll_msgseg_error_base_seq = srio_ll_msgseg_error_base_seq::type_id::create("ll_msgseg_error_base_seq");
  	
         
	ll_msgseg_error_base_seq.start(vseq_ll_sequencer);  

 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  INVALID MSGSEG "),UVM_LOW); end
     end //}
  endtask

endclass : srio_ll_msgseg_error_seq

//======DS_ODD_ERR  ERROR SEQUENCES====================

class srio_ll_ds_odd_error_seq extends srio_virtual_base_seq;

  `uvm_object_utils(srio_ll_ds_odd_error_seq)
	
        rand bit [7:0] mtusize_1;
        rand bit [16:0] pdu_length_1;	
	srio_ll_ds_odd_error_base_seq ll_ds_odd_error_base_seq;

	function new(string name="");
    	super.new(name);
  	endfunction

	task body();
	super.body();
	     
        ll_ds_odd_error_base_seq = srio_ll_ds_odd_error_base_seq::type_id::create("ll_ds_odd_error_base_seq");
  	
         
	ll_ds_odd_error_base_seq.start(vseq_ll_sequencer);  

 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  INVALID DS_ODD_ERR "),UVM_LOW); end
    
  endtask

endclass : srio_ll_ds_odd_error_seq

//======RESP_RSVD_STS_ERR  ERROR SEQUENCES====================

class srio_ll_resp_rsvd_sts_error_seq extends srio_virtual_base_seq;

  `uvm_object_utils(srio_ll_resp_rsvd_sts_error_seq)
	//rand bit [3:0] ttype_0;
  	//rand bit y;
	
     	
	srio_ll_resp_rsvd_sts_error_base_seq ll_resp_rsvd_sts_error_base_seq;


	function new(string name="");
    	super.new(name);
  	endfunction

	task body();
	super.body();
	repeat(5) begin //{
     
        ll_resp_rsvd_sts_error_base_seq = srio_ll_resp_rsvd_sts_error_base_seq::type_id::create("ll_resp_rsvd_sts_error_base_seq");
  	//y = $urandom;
 //ttype_0 = y ? $urandom_range(4'hF,4'h9) : $urandom_range(4'h7,4'h2);
        //ll_resp_rsvd_sts_error_base_seq.ttype_0 = y ? $urandom_range(4'hF,4'h9) : $urandom_range(4'h7,4'h2);
	  
	ll_resp_rsvd_sts_error_base_seq.start(vseq_ll_sequencer);  

 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  INVALID RESP_RSVD_STS_ERR "),UVM_LOW); end
     end //}
  endtask

endclass : srio_ll_resp_rsvd_sts_error_seq

//======RESP_PRI_ERR  ERROR SEQUENCES====================

class srio_ll_resp_pri_error_seq extends srio_virtual_base_seq;

  `uvm_object_utils(srio_ll_resp_pri_error_seq)
	
     	
	srio_ll_resp_pri_error_base_seq ll_resp_pri_error_base_seq;


	function new(string name="");
    	super.new(name);
  	endfunction

	task body();
	super.body();
	repeat(5) begin //{
     
        ll_resp_pri_error_base_seq = srio_ll_resp_pri_error_base_seq::type_id::create("ll_resp_pri_error_base_seq");
  	
       //  
	ll_resp_pri_error_base_seq.start(vseq_ll_sequencer);  

 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  INVALID RESP_PRI_ERR "),UVM_LOW); end
     end //}
  endtask

endclass : srio_ll_resp_pri_error_seq

//======RESP_PAYLOAD_ERR  ERROR SEQUENCES====================

class srio_ll_resp_payload_error_seq extends srio_virtual_base_seq;

  `uvm_object_utils(srio_ll_resp_payload_error_seq)
	
     	
	srio_ll_resp_payload_error_base_seq ll_resp_payload_error_base_seq;


	function new(string name="");
    	super.new(name);
  	endfunction

	task body();
	super.body();
	repeat(5) begin //{
     
        ll_resp_payload_error_base_seq = srio_ll_resp_payload_error_base_seq::type_id::create("ll_resp_payload_error_base_seq");
  	
         
	ll_resp_payload_error_base_seq.start(vseq_ll_sequencer);  

 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  INVALID RESP_PAYLOAD_ERR "),UVM_LOW); end
     end //}
  endtask

endclass : srio_ll_resp_payload_error_seq

//======EARLY_CRC_ERR  ERROR SEQUENCES====================

class srio_pl_pkt_early_crc_error_seq extends srio_virtual_base_seq;

  `uvm_object_utils(srio_pl_pkt_early_crc_error_seq)
	
     	
	srio_pl_pkt_early_crc_error_base_seq pl_pkt_early_crc_error_base_seq;


	function new(string name="");
    	super.new(name);
  	endfunction

	task body();
	super.body();
	repeat(500) begin //{
     
        pl_pkt_early_crc_error_base_seq = srio_pl_pkt_early_crc_error_base_seq::type_id::create("pl_pkt_early_crc_error_base_seq");
  	
    	pl_pkt_early_crc_error_base_seq.start(vseq_ll_sequencer);  

 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  INVALID EARLY_CRC_ERR "),UVM_LOW); end
     end //}
  endtask

endclass : srio_pl_pkt_early_crc_error_seq

//======FINAL_CRC_ERR  ERROR SEQUENCES====================

class srio_pl_pkt_final_crc_error_seq extends srio_virtual_base_seq;

  `uvm_object_utils(srio_pl_pkt_final_crc_error_seq)
	
     	
	srio_pl_pkt_final_crc_error_base_seq pl_pkt_final_crc_error_base_seq;


	function new(string name="");
    	super.new(name);
  	endfunction

	task body();
	super.body();
	repeat(5) begin //{
     
        pl_pkt_final_crc_error_base_seq = srio_pl_pkt_final_crc_error_base_seq::type_id::create("pl_pkt_final_crc_error_base_seq");
  	
       
	pl_pkt_final_crc_error_base_seq.start(vseq_ll_sequencer);  

 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  INVALID FINAL_CRC_ERR "),UVM_LOW); end
     end //}
  endtask

endclass : srio_pl_pkt_final_crc_error_seq

//======ACKID_ERR  ERROR SEQUENCES====================

class srio_pl_pkt_ackid_error_seq extends srio_virtual_base_seq;

  `uvm_object_utils(srio_pl_pkt_ackid_error_seq)
	
     	
	srio_pl_pkt_ackid_error_base_seq pl_pkt_ackid_error_base_seq;


	function new(string name="");
    	super.new(name);
  	endfunction

	task body();
	super.body();
	repeat(5) begin //{
     
        pl_pkt_ackid_error_base_seq = srio_pl_pkt_ackid_error_base_seq::type_id::create("pl_pkt_ackid_error_base_seq");
  	
       
	pl_pkt_ackid_error_base_seq.start(vseq_ll_sequencer);  

 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  INVALID ACKID_ERR "),UVM_LOW); end
     end //}
  endtask

endclass : srio_pl_pkt_ackid_error_seq

//======ILLEGAL_PRIO_ERR  ERROR SEQUENCES====================

class srio_pl_pkt_illegal_prio_error_seq extends srio_virtual_base_seq;

  `uvm_object_utils(srio_pl_pkt_illegal_prio_error_seq)
	
     	
	srio_pl_pkt_illegal_prio_error_base_seq pl_pkt_illegal_prio_error_base_seq;


	function new(string name="");
    	super.new(name);
  	endfunction

	task body();
	super.body();
	repeat(5) begin //{
     
        pl_pkt_illegal_prio_error_base_seq = srio_pl_pkt_illegal_prio_error_base_seq::type_id::create("pl_pkt_illegal_prio_error_base_seq");
  	
       
	pl_pkt_illegal_prio_error_base_seq.start(vseq_ll_sequencer);  

 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  INVALID ILLEGAL_PRIO_ERR "),UVM_LOW); end
     end //}
  endtask

endclass : srio_pl_pkt_illegal_prio_error_seq

//======ILLEGAL_CRF_ERR  ERROR SEQUENCES====================

class srio_pl_pkt_illegal_crf_error_seq extends srio_virtual_base_seq;

  `uvm_object_utils(srio_pl_pkt_illegal_crf_error_seq)
	
     	
	srio_pl_pkt_illegal_crf_error_base_seq pl_pkt_illegal_crf_error_base_seq;


	function new(string name="");
    	super.new(name);
  	endfunction

	task body();
	super.body();
	repeat(5) begin //{
     
        pl_pkt_illegal_crf_error_base_seq = srio_pl_pkt_illegal_crf_error_base_seq::type_id::create("pl_pkt_illegal_crf_error_base_seq");
  	
       
	pl_pkt_illegal_crf_error_base_seq.start(vseq_ll_sequencer);  

 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  INVALID ILLEGAL_CRF_ERR "),UVM_LOW); end
     end //}
  endtask

endclass : srio_pl_pkt_illegal_crf_error_seq

//======USER GENERATE SEQUENCES===========

class srio_ll_user_gen_seq extends srio_virtual_base_seq;

  `uvm_object_utils(srio_ll_user_gen_seq)
	
     	rand bit [1:0] prior;
        rand bit crf_1;
	srio_ll_user_gen_base_seq ll_user_gen_base_seq;


	function new(string name="");
    	super.new(name);
  	endfunction

	task body();
	super.body();
	repeat(50) begin //{
     
        ll_user_gen_base_seq = srio_ll_user_gen_base_seq::type_id::create("ll_user_gen_base_seq");
  	
        ll_user_gen_base_seq.prio_0 = prior;
        ll_user_gen_base_seq.crf_0 =crf_1;  
	ll_user_gen_base_seq.start(vseq_ll_sequencer);  
       	
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  USER GENERATE PACKET "),UVM_LOW); end
     end //}
  endtask

endclass : srio_ll_user_gen_seq
//================LFC  XON/XOFF USER GENERATE SEQUENCES ============

class srio_ll_lfc_user_gen_xoff_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_lfc_user_gen_xoff_seq)
   rand bit [6:0] flowid;
  srio_ll_lfc_seq  ll_lfc_xoff_seq ;
  

  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
       	for(int i = 0; i < 1 ;i++) begin //{

          ll_lfc_xoff_seq  = srio_ll_lfc_seq::type_id::create("ll_lfc_xoff_seq");
          
	  ll_lfc_xoff_seq.ftype_0 = 4'h7;
          ll_lfc_xoff_seq.xon_xoff_0 = 1'b0;
	  ll_lfc_xoff_seq.tgtdestID_0 = 32'h2;
	  ll_lfc_xoff_seq.DestinationID_0 = 32'hFFFF_FFFF;
	  ll_lfc_xoff_seq.FAM_0 = 3'b0;
	  ll_lfc_xoff_seq.flowID_0 = flowid;
          ll_lfc_xoff_seq.start(vseq_ll_sequencer);
	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with LFC XOFF SEQUENCE   "),UVM_LOW); end
	end //}
	endtask
endclass :srio_ll_lfc_user_gen_xoff_seq
//================LFC  XON/XOFF USER GENERATE SEQUENCES ============

class srio_ll_lfc_user_gen_xon_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_lfc_user_gen_xon_seq)
   rand bit [6:0] flowid;
  srio_ll_lfc_seq  ll_lfc_xon_seq ;
  

  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
       	for(int i = 0; i < 1 ;i++) begin //{

          ll_lfc_xon_seq  = srio_ll_lfc_seq::type_id::create("ll_lfc_xon_seq");
          
	  ll_lfc_xon_seq.ftype_0 = 4'h7;
          ll_lfc_xon_seq.xon_xoff_0 = 1'b1;
	  ll_lfc_xon_seq.tgtdestID_0 = 32'h2;
	  ll_lfc_xon_seq.DestinationID_0 = 32'hFFFF_FFFF;
	  ll_lfc_xon_seq.FAM_0 = 3'b0;
	  ll_lfc_xon_seq.flowID_0 =flowid ;
          ll_lfc_xon_seq.start(vseq_ll_sequencer);
	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with LFC XON SEQUENCE   "),UVM_LOW); end
	end //}
	endtask
endclass :srio_ll_lfc_user_gen_xon_seq

//======IO RANDOM SEQUENCES===========

class srio_ll_io_random_seq extends srio_virtual_base_seq;

  `uvm_object_utils(srio_ll_io_random_seq)
	
     	
	srio_ll_io_random_base_seq ll_io_random_base_seq;


	function new(string name="");
    	super.new(name);
  	endfunction

	task body();
	super.body();
	repeat(500) begin //{
     
        ll_io_random_base_seq = srio_ll_io_random_base_seq::type_id::create("ll_io_random_base_seq");
  	 
	ll_io_random_base_seq.start(vseq_ll_sequencer);  
	
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  IO RANDOM PACKET "),UVM_LOW); end
    #1ns;
     end //}
  endtask

endclass : srio_ll_io_random_seq


//================DATA STREAMING MULTI SEGMENT WITH SINGLE MTU CONFIGURED  ============

class srio_ll_ds_mseg_single_mtu_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_mseg_single_mtu_seq)
    rand bit [15:0] pdu_length_1;
    rand bit [7:0] mtusize_1; 
   srio_ll_ds_mseg_single_mtu_base_seq ll_ds_mseg_single_mtu_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	
         ll_ds_mseg_single_mtu_seq  =srio_ll_ds_mseg_single_mtu_base_seq ::type_id::create("ll_ds_mseg_single_mtu_seq");   
         ll_ds_mseg_single_mtu_seq.mtusize_0 = mtusize_1;
          ll_ds_mseg_single_mtu_seq.pdulength_0 = pdu_length_1;
          ll_ds_mseg_single_mtu_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with DATA STREAMING MULTI SEGMENT WITH SINGLE NTU    "),UVM_LOW); end
  endtask

endclass :srio_ll_ds_mseg_single_mtu_seq
//================PORT RESPONSE TIMEOUT VALE CONFIGURED  ============

class srio_ll_port_resp_timeout_reg_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_port_resp_timeout_reg_seq)
     
   srio_ll_port_resp_timeout_reg_base_seq ll_port_resp_timeout_reg_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	
         ll_port_resp_timeout_reg_seq  =srio_ll_port_resp_timeout_reg_base_seq ::type_id::create("ll_port_resp_timeout_reg_seq");   


          ll_port_resp_timeout_reg_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with PORT RESPONSE TIMEOUT VALE    "),UVM_LOW); end
  endtask

endclass :srio_ll_port_resp_timeout_reg_seq


//===== NXMODE SUPPORT DISABLED ======

class srio_pl_nx_mode_support_disable_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_nx_mode_support_disable_seq)
    srio_pl_nx_mode_support_disable_base_seq pl_nx_mode_support_disable_seq;   
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_nx_mode_support_disable_seq = srio_pl_nx_mode_support_disable_base_seq::type_id::create("pl_nx_mode_support_disable_seq");
  	env_config.pl_config.nx_mode_support = 0;
        pl_nx_mode_support_disable_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with nx mode support disabled "),UVM_LOW); end
  endtask

endclass : srio_pl_nx_mode_support_disable_seq
//===== 2XMODE SUPPORT DISABLED ======

class srio_pl_x2_mode_support_disable_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_x2_mode_support_disable_seq)
    srio_pl_x2_mode_support_disable_base_seq pl_x2_mode_support_disable_seq;   
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_x2_mode_support_disable_seq = srio_pl_x2_mode_support_disable_base_seq::type_id::create("pl_x2_mode_support_disable_seq");
  	env_config.pl_config.x2_mode_support = 0;
        pl_x2_mode_support_disable_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  x2 mode supported disabled "),UVM_LOW); end
  endtask

endclass : srio_pl_x2_mode_support_disable_seq

///======ATOMIC REQUEST SEQUENCES===========

class srio_ll_all_atomic_req_seq extends srio_virtual_base_seq;

  `uvm_object_utils(srio_ll_all_atomic_req_seq)
	
     	
	srio_ll_all_atomic_req_base_seq ll_all_atomic_req_base_seq;


	function new(string name="");
    	super.new(name);
  	endfunction

	task body();
	super.body();
	repeat(50) begin //{
     
        ll_all_atomic_req_base_seq = srio_ll_all_atomic_req_base_seq::type_id::create("ll_all_atomic_req_base_seq");
  	 
	ll_all_atomic_req_base_seq.start(vseq_ll_sequencer);  

 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with all ATOMIC PACKET "),UVM_LOW); end
        #1ns;
     end //}
  endtask

endclass : srio_ll_all_atomic_req_seq

//=========================== DS CONCURRENT ==================================

class srio_ll_ds_concurrent_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_concurrent_seq)

   srio_ll_ds_concurrent_base_seq ll_ds_concurrent_base_seq;

  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
      repeat(1) begin //{
          ll_ds_concurrent_base_seq = srio_ll_ds_concurrent_base_seq::type_id::create("ll_ds_concurrent_base_seq");
          ll_ds_concurrent_base_seq.start(vseq_ll_sequencer); 
	 begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with DATA STREAMING SINGLE SEGMENT   "),UVM_LOW); end
	end //}
  endtask

endclass :srio_ll_ds_concurrent_seq
 //=========================== DS maximum active segment support ==================================

class srio_ll_ds_max_seg_support_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_max_seg_support_seq)

   srio_ll_ds_max_seg_support_base_seq ll_ds_max_seg_support_base_seq;

  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();

          ll_ds_max_seg_support_base_seq = srio_ll_ds_max_seg_support_base_seq::type_id::create("ll_ds_max_seg_support_base_seq");
           env_config.ll_config.interleaved_pkt = TRUE;
          ll_ds_max_seg_support_base_seq.start(vseq_ll_sequencer); 
	 begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with DATA STREAMING SEGMENT FOR MAX ACTIVE SEGMENT SUPPORT"),UVM_LOW); end
	
  endtask

endclass :srio_ll_ds_max_seg_support_seq
 //=========================== DS MUT reserved value  ==================================

class srio_ll_ds_mtu_reserved_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_mtu_reserved_seq)

   srio_ll_ds_mtu_reserved_base_seq ll_ds_mtu_reserved_base_seq;

  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
      repeat(50) begin //{
          ll_ds_mtu_reserved_base_seq = srio_ll_ds_mtu_reserved_base_seq::type_id::create("ll_ds_mtu_reserved_base_seq");
          ll_ds_mtu_reserved_base_seq.start(vseq_ll_sequencer); 
	 begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with DS reserved MTU value"),UVM_LOW); end
	end //}
  endtask

endclass :srio_ll_ds_mtu_reserved_seq

 //=========================== DS START AND END ERROR VIRTUAL SEQUENCE  ==================================

class srio_ll_ds_s_e_err_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_s_e_err_seq)

   srio_ll_ds_s_e_err_base_seq ll_ds_s_e_err_base_seq;

  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
      repeat(50) begin //{
          ll_ds_s_e_err_base_seq = srio_ll_ds_s_e_err_base_seq::type_id::create("ll_ds_s_e_err_base_seq");
          ll_ds_s_e_err_base_seq.start(vseq_ll_sequencer); 
	 begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence for DS start and end error"),UVM_LOW); end
	end //}
  endtask

endclass :srio_ll_ds_s_e_err_seq

//================DATA STREAMING WITH MAINTENANCE ============

class srio_ll_ds_payload_size_err_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_payload_size_err_seq)

   srio_ll_ds_payload_size_err_base_seq ll_ds_payload_size_err_base_seq ;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
      repeat(5) begin //{
       ll_ds_payload_size_err_base_seq= srio_ll_ds_payload_size_err_base_seq::type_id::create("ll_ds_payload_size_err_base_seq");
       ll_ds_payload_size_err_base_seq.start(vseq_ll_sequencer); 
	 begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence For Corrupted Payload DS Packet "),UVM_LOW); end
	end //}
  endtask

endclass :srio_ll_ds_payload_size_err_seq

//================DATA STREAMING WITH TRAFFIC============

class srio_ll_ds_traffic_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_traffic_seq)
    rand bit [7:0] mtusize_1;
    rand bit [15:0] pdu_length_1;
   srio_ll_ds_traffic_base_seq ll_ds_traffic_base_seq ;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
      	repeat(10) begin //{
       ll_ds_traffic_base_seq= srio_ll_ds_traffic_base_seq::type_id::create("ll_ds_traffic_base_seq");
       ll_ds_traffic_base_seq.mtusize_0 =mtusize_1;
       ll_ds_traffic_base_seq.pdulength_0 =pdu_length_1;
       ll_ds_traffic_base_seq.streamID_0 = 16'h3F;
       ll_ds_traffic_base_seq.cos_0 = 8'h1F;
       ll_ds_traffic_base_seq.start(vseq_ll_sequencer); 
	 begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with DATA STREAMING SINGLE SEGMENT   "),UVM_LOW); end
  end //}
endtask

endclass :srio_ll_ds_traffic_seq

//================ TRAFFIC MANAGEMENT FOR BASIC XOFF STREAM MANAGEMENT SEQUENCES ===

class srio_ll_ds_traffic_mgmt_basic_stream_xoff_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_traffic_mgmt_basic_stream_xoff_seq)
    rand bit [3:0] TMmode_0;
    srio_ll_ds_traffic_mgmt_stream_base_seq ll_ds_traffic_mgmt_basic_stream_xoff_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	ll_ds_traffic_mgmt_basic_stream_xoff_seq   = srio_ll_ds_traffic_mgmt_stream_base_seq::type_id::create("ll_ds_traffic_mgmt_basic_stream_xoff_seq");
  	
        ll_ds_traffic_mgmt_basic_stream_xoff_seq.xh_0 = 1'b1;
	ll_ds_traffic_mgmt_basic_stream_xoff_seq.TMOP_0 = TMmode_0;
	ll_ds_traffic_mgmt_basic_stream_xoff_seq.ftype_0 = 4'h9;	
	ll_ds_traffic_mgmt_basic_stream_xoff_seq.wild_card_0 = 3'b0;
	ll_ds_traffic_mgmt_basic_stream_xoff_seq.parameter1_0 = 8'h0; 	  
	ll_ds_traffic_mgmt_basic_stream_xoff_seq.parameter2_0 = 8'h0; 	  
	ll_ds_traffic_mgmt_basic_stream_xoff_seq.cos_0 = 8'h1F; 	  
	ll_ds_traffic_mgmt_basic_stream_xoff_seq.streamID_0 = 16'h3F; 	  
	ll_ds_traffic_mgmt_basic_stream_xoff_seq.mask_0 = 8'h0; 
        ll_ds_traffic_mgmt_basic_stream_xoff_seq.xtype_0 = 3'h0;	  
        ll_ds_traffic_mgmt_basic_stream_xoff_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with TRAFFIC MANAGEMENT FOR BASIC XOFF STREAM MANAGEMENT SEQUENCE   "),UVM_LOW); end

  endtask

endclass :srio_ll_ds_traffic_mgmt_basic_stream_xoff_seq
//================ TRAFFIC MANAGEMENT FOR BASIC XON STREAM MANAGEMENT SEQUENCES ===

class srio_ll_ds_traffic_mgmt_basic_stream_xon_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_traffic_mgmt_basic_stream_xon_seq)
    rand bit [3:0] TMmode_0;
    srio_ll_ds_traffic_mgmt_stream_base_seq ll_ds_traffic_mgmt_basic_stream_xon_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	          ll_ds_traffic_mgmt_basic_stream_xon_seq   = srio_ll_ds_traffic_mgmt_stream_base_seq::type_id::create("ll_ds_traffic_mgmt_basic_stream_xon_seq");
  	
        ll_ds_traffic_mgmt_basic_stream_xon_seq.xh_0 = 1'b1;
	ll_ds_traffic_mgmt_basic_stream_xon_seq.TMOP_0 = TMmode_0;
	ll_ds_traffic_mgmt_basic_stream_xon_seq.ftype_0 = 4'h9;	
	ll_ds_traffic_mgmt_basic_stream_xon_seq.wild_card_0 = 3'b0;
	ll_ds_traffic_mgmt_basic_stream_xon_seq.parameter1_0 = 8'h0; 	  
	ll_ds_traffic_mgmt_basic_stream_xon_seq.parameter2_0 = 8'hFF; 	  
	ll_ds_traffic_mgmt_basic_stream_xon_seq.cos_0 = 8'h1F; 	  
	ll_ds_traffic_mgmt_basic_stream_xon_seq.streamID_0 = 16'h3F; 	  
	ll_ds_traffic_mgmt_basic_stream_xon_seq.mask_0 = 8'h0; 
    ll_ds_traffic_mgmt_basic_stream_xon_seq.xtype_0 = 3'h0;	  
    ll_ds_traffic_mgmt_basic_stream_xon_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with TRAFFIC MANAGEMENT FOR BASIC XON STREAM MANAGEMENT SEQUENCE   "),UVM_LOW); end

  endtask

endclass :srio_ll_ds_traffic_mgmt_basic_stream_xon_seq

//================Normal DATA STREAMING WITH payload error ============

class srio_ll_normal_ds_payload_size_err_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_normal_ds_payload_size_err_seq)

   srio_ll_normal_ds_payload_size_err_base_seq ll_normal_ds_payload_size_err_base_seq ;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
      repeat(5) begin //{
       ll_normal_ds_payload_size_err_base_seq= srio_ll_normal_ds_payload_size_err_base_seq::type_id::create("ll_normal_ds_payload_size_err_base_seq");
       ll_normal_ds_payload_size_err_base_seq.start(vseq_ll_sequencer); 
	 begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence For Corrupted Payload DS Packet "),UVM_LOW); end
	end //}
  endtask
endclass :srio_ll_normal_ds_payload_size_err_seq

//================ TRAFFIC MANAGEMENT with non zero xtype SEQUENCES ===

class srio_ll_ds_traffic_mgmt_xtype_err_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_traffic_mgmt_xtype_err_seq)

    srio_ll_ds_traffic_mgmt_stream_base_seq ll_ds_traffic_mgmt_basic_stream_xoff_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	          ll_ds_traffic_mgmt_basic_stream_xoff_seq   = srio_ll_ds_traffic_mgmt_stream_base_seq::type_id::create("ll_ds_traffic_mgmt_basic_stream_xoff_seq");
  	
        ll_ds_traffic_mgmt_basic_stream_xoff_seq.xh_0 = 1'b1;
	ll_ds_traffic_mgmt_basic_stream_xoff_seq.TMOP_0 = 4'h0;
	ll_ds_traffic_mgmt_basic_stream_xoff_seq.ftype_0 = 4'h9;	
	ll_ds_traffic_mgmt_basic_stream_xoff_seq.wild_card_0 = 3'b0;
	ll_ds_traffic_mgmt_basic_stream_xoff_seq.parameter1_0 = 8'h0; 	  
	ll_ds_traffic_mgmt_basic_stream_xoff_seq.parameter2_0 = 8'h0; 	  
	ll_ds_traffic_mgmt_basic_stream_xoff_seq.cos_0 = 8'h1F; 	  
	ll_ds_traffic_mgmt_basic_stream_xoff_seq.streamID_0 = 16'h3F; 	  
	ll_ds_traffic_mgmt_basic_stream_xoff_seq.mask_0 = 8'h0; 
    ll_ds_traffic_mgmt_basic_stream_xoff_seq.xtype_0 = 3'b111;	  
    ll_ds_traffic_mgmt_basic_stream_xoff_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with TRAFFIC MANAGEMENT FOR XTYPE ERROR SEQUENCE   "),UVM_LOW); end

  endtask

endclass :srio_ll_ds_traffic_mgmt_xtype_err_seq
//================ TRAFFIC MANAGEMENT FOR RATE XOFF STREAM MANAGEMENT SEQUENCES ===

class srio_ll_ds_traffic_mgmt_user_rate_xoff_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_traffic_mgmt_user_rate_xoff_seq)
    rand bit [3:0] TMmode_0;
    srio_ll_ds_traffic_mgmt_user_rate_base_seq ll_ds_traffic_mgmt_user_rate_xoff_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	          ll_ds_traffic_mgmt_user_rate_xoff_seq   = srio_ll_ds_traffic_mgmt_user_rate_base_seq::type_id::create("ll_ds_traffic_mgmt_user_rate_xoff_seq");
  	
        ll_ds_traffic_mgmt_user_rate_xoff_seq.xh_0 = 1'b1;
	ll_ds_traffic_mgmt_user_rate_xoff_seq.TMOP_0 = TMmode_0;
	ll_ds_traffic_mgmt_user_rate_xoff_seq.ftype_0 = 4'h9;	
	ll_ds_traffic_mgmt_user_rate_xoff_seq.wild_card_0 = 3'b0;
	ll_ds_traffic_mgmt_user_rate_xoff_seq.parameter1_0 = 8'h0; 	  
	ll_ds_traffic_mgmt_user_rate_xoff_seq.parameter2_0 = 8'h0; 	  
	ll_ds_traffic_mgmt_user_rate_xoff_seq.cos_0 = 8'h1F; 	  
	ll_ds_traffic_mgmt_user_rate_xoff_seq.streamID_0 = 16'h3F; 	  
	ll_ds_traffic_mgmt_user_rate_xoff_seq.mask_0 = 8'h0; 
    ll_ds_traffic_mgmt_user_rate_xoff_seq.xtype_0 = 3'h0;	  
        ll_ds_traffic_mgmt_user_rate_xoff_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with TRAFFIC MANAGEMENT FOR RATE XOFF STREAM MANAGEMENT SEQUENCE   "),UVM_LOW); end

  endtask

endclass :srio_ll_ds_traffic_mgmt_user_rate_xoff_seq
//================ TRAFFIC MANAGEMENT FOR RATE XON STREAM MANAGEMENT SEQUENCES ===

class srio_ll_ds_traffic_mgmt_user_rate_xon_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_traffic_mgmt_user_rate_xon_seq)
    rand bit [3:0] TMmode_0;
    srio_ll_ds_traffic_mgmt_user_rate_base_seq ll_ds_traffic_mgmt_user_rate_xon_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	          ll_ds_traffic_mgmt_user_rate_xon_seq   = srio_ll_ds_traffic_mgmt_user_rate_base_seq::type_id::create("ll_ds_traffic_mgmt_user_rate_xon_seq");
  	
        ll_ds_traffic_mgmt_user_rate_xon_seq.xh_0 = 1'b1;
	ll_ds_traffic_mgmt_user_rate_xon_seq.TMOP_0 = TMmode_0;
	ll_ds_traffic_mgmt_user_rate_xon_seq.ftype_0 = 4'h9;	
	ll_ds_traffic_mgmt_user_rate_xon_seq.wild_card_0 = 3'b0;
	ll_ds_traffic_mgmt_user_rate_xon_seq.parameter1_0 = 8'h0; 	  
	ll_ds_traffic_mgmt_user_rate_xon_seq.parameter2_0 = 8'hFF; 	  
	ll_ds_traffic_mgmt_user_rate_xon_seq.cos_0 = 8'h1F; 	  
	ll_ds_traffic_mgmt_user_rate_xon_seq.streamID_0 = 16'h3F; 	  
	ll_ds_traffic_mgmt_user_rate_xon_seq.mask_0 = 8'h0; 
        ll_ds_traffic_mgmt_user_rate_xon_seq.xtype_0 = 3'h0;	  
        ll_ds_traffic_mgmt_user_rate_xon_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with TRAFFIC MANAGEMENT FOR RATE XON STREAM MANAGEMENT SEQUENCE   "),UVM_LOW); end

  endtask

endclass :srio_ll_ds_traffic_mgmt_user_rate_xon_seq
//================ TRAFFIC MANAGEMENT FOR CREDIT XON STREAM MANAGEMENT SEQUENCES ===

class srio_ll_ds_traffic_mgmt_user_credit_xon_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_traffic_mgmt_user_credit_xon_seq)
    rand bit [3:0] TMmode_0;

    srio_ll_ds_traffic_mgmt_user_credit_base_seq ll_ds_traffic_mgmt_user_credit_xon_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
       
	          ll_ds_traffic_mgmt_user_credit_xon_seq   = srio_ll_ds_traffic_mgmt_user_credit_base_seq::type_id::create("ll_ds_traffic_mgmt_user_credit_xon_seq");
  	
      ll_ds_traffic_mgmt_user_credit_xon_seq.xh_0 = 1'b1;
	ll_ds_traffic_mgmt_user_credit_xon_seq.TMOP_0 = TMmode_0;
	ll_ds_traffic_mgmt_user_credit_xon_seq.ftype_0 = 4'h9;	
	ll_ds_traffic_mgmt_user_credit_xon_seq.wild_card_0 = 3'b0;
	ll_ds_traffic_mgmt_user_credit_xon_seq.parameter1_0 = 8'h0; 	  
	ll_ds_traffic_mgmt_user_credit_xon_seq.parameter2_0 = 8'hFF; 	  
	ll_ds_traffic_mgmt_user_credit_xon_seq.cos_0 = 8'h1F; 	  
	ll_ds_traffic_mgmt_user_credit_xon_seq.streamID_0 = 16'h3F; 	  
	ll_ds_traffic_mgmt_user_credit_xon_seq.mask_0 = 8'h0; 
        ll_ds_traffic_mgmt_user_credit_xon_seq.xtype_0 = 3'h0;	  
        ll_ds_traffic_mgmt_user_credit_xon_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with TRAFFIC MANAGEMENT FOR CREDIT XON STREAM MANAGEMENT SEQUENCE   "),UVM_LOW); end

  endtask

endclass :srio_ll_ds_traffic_mgmt_user_credit_xon_seq
//================ TRAFFIC MANAGEMENT FOR CREDIT XOFF STREAM MANAGEMENT SEQUENCES ===

class srio_ll_ds_traffic_mgmt_user_credit_xoff_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_traffic_mgmt_user_credit_xoff_seq)
     rand bit [3:0]  TMmode_0;

    srio_ll_ds_traffic_mgmt_user_credit_base_seq ll_ds_traffic_mgmt_user_credit_xoff_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	 ll_ds_traffic_mgmt_user_credit_xoff_seq   = srio_ll_ds_traffic_mgmt_user_credit_base_seq::type_id::create("ll_ds_traffic_mgmt_user_credit_xoff_seq");
  	
        ll_ds_traffic_mgmt_user_credit_xoff_seq.xh_0 = 1'b1;
	ll_ds_traffic_mgmt_user_credit_xoff_seq.TMOP_0 = TMmode_0;
	ll_ds_traffic_mgmt_user_credit_xoff_seq.ftype_0 = 4'h9;	
	ll_ds_traffic_mgmt_user_credit_xoff_seq.wild_card_0 = 3'b0;
	ll_ds_traffic_mgmt_user_credit_xoff_seq.parameter1_0 = 8'h0; 	  
	ll_ds_traffic_mgmt_user_credit_xoff_seq.parameter2_0 = 8'h0; 	  
	ll_ds_traffic_mgmt_user_credit_xoff_seq.cos_0 = 8'h1F; 	  
	ll_ds_traffic_mgmt_user_credit_xoff_seq.streamID_0 = 16'h3F; 	  
	ll_ds_traffic_mgmt_user_credit_xoff_seq.mask_0 = 8'h0; 
        ll_ds_traffic_mgmt_user_credit_xoff_seq.xtype_0 = 3'h0;	  
        ll_ds_traffic_mgmt_user_credit_xoff_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with TRAFFIC MANAGEMENT FOR CREDIT XOFF STREAM MANAGEMENT SEQUENCE   "),UVM_LOW); end

  endtask

endclass :srio_ll_ds_traffic_mgmt_user_credit_xoff_seq

//================ TRAFFIC MANAGEMENT FOR RESERVED TMOP SEQUENCES ===

class srio_ll_ds_traffic_mgmt_tmop_err_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_traffic_mgmt_tmop_err_seq)
    rand bit [3:0] invalid; 
    srio_ll_ds_traffic_mgmt_stream_base_seq ll_ds_traffic_mgmt_basic_stream_xoff_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
    ll_ds_traffic_mgmt_basic_stream_xoff_seq   = srio_ll_ds_traffic_mgmt_stream_base_seq::type_id::create("ll_ds_traffic_mgmt_basic_stream_xoff_seq");
    invalid = $urandom_range(32'd15,32'd4);  	
    ll_ds_traffic_mgmt_basic_stream_xoff_seq.xh_0 = 1'b1;
	ll_ds_traffic_mgmt_basic_stream_xoff_seq.TMOP_0 = invalid;
	ll_ds_traffic_mgmt_basic_stream_xoff_seq.ftype_0 = 4'h9;	
	ll_ds_traffic_mgmt_basic_stream_xoff_seq.wild_card_0 = 3'b0;
	ll_ds_traffic_mgmt_basic_stream_xoff_seq.parameter1_0 = 8'h0; 	  
	ll_ds_traffic_mgmt_basic_stream_xoff_seq.parameter2_0 = 8'h0; 	  
	ll_ds_traffic_mgmt_basic_stream_xoff_seq.cos_0 = 8'h1F; 	  
	ll_ds_traffic_mgmt_basic_stream_xoff_seq.streamID_0 = 16'h3F; 	  
	ll_ds_traffic_mgmt_basic_stream_xoff_seq.mask_0 = 8'h0; 
    ll_ds_traffic_mgmt_basic_stream_xoff_seq.xtype_0 = 3'h0;	  
        ll_ds_traffic_mgmt_basic_stream_xoff_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with TRAFFIC MANAGEMENT FOR RESERVED TMOP SEQUENCE   "),UVM_LOW); end

  endtask

endclass :srio_ll_ds_traffic_mgmt_tmop_err_seq

//================ TRAFFIC MANAGEMENT FOR VALID TMOP AND RESERVED PARAMETER1 SEQUENCES ===

class srio_ll_ds_traffic_mgmt_parameter1_err_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_traffic_mgmt_parameter1_err_seq)

   srio_ll_ds_traffic_mgmt_basic_stream_base_seq ll_ds_traffic_mgmt_basic_stream_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 5 ;i++) begin //{

          ll_ds_traffic_mgmt_basic_stream_seq   =srio_ll_ds_traffic_mgmt_basic_stream_base_seq::type_id::create("ll_ds_traffic_mgmt_basic_stream_seq");
  	
        ll_ds_traffic_mgmt_basic_stream_seq.xh_0 = 1'b1;
	ll_ds_traffic_mgmt_basic_stream_seq.TMOP_0 = 4'b0000;
	ll_ds_traffic_mgmt_basic_stream_seq.ftype_0 = 4'h9;	
	ll_ds_traffic_mgmt_basic_stream_seq.wild_card_0 = 3'b0;
	ll_ds_traffic_mgmt_basic_stream_seq.parameter1_0 = 8'h2; 	  
        ll_ds_traffic_mgmt_basic_stream_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with TRAFFIC MANAGEMENT FOR RESERVED PARAMETR1 SEQUENCE   "),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}

  endtask
endclass

//================RANDOM SEQUENCE for ftype err ============

class srio_ll_ftype_default_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ftype_default_seq)
     
    srio_ll_ftype_default_class_seq ll_ftype_default_seq;

   function new(string name="");
    super.new(name);
  endfunction

  task body();
         super.body();
         
        
          ll_ftype_default_seq = srio_ll_ftype_default_class_seq::type_id::create("ll_ftype_default_seq");                  
          ll_ftype_default_seq.start(vseq_ll_sequencer);
 
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with Random FTYPE Value"),UVM_LOW); end
  endtask

endclass : srio_ll_ftype_default_seq

//================LFC UNSUPPORTED FLOWID SEQUENCES ============

class srio_ll_lfc_unsupport_flowid_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_lfc_unsupport_flowid_seq)
   
   rand bit [6:0] flowid;
  srio_ll_lfc_seq  ll_lfc_xoff_seq ;
  

  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
       	for(int i = 0; i < 1 ;i++) begin //{

          ll_lfc_xoff_seq  = srio_ll_lfc_seq::type_id::create("ll_lfc_xoff_seq");
          
	  ll_lfc_xoff_seq.ftype_0 = 4'h7;
          ll_lfc_xoff_seq.xon_xoff_0 = 1'b0;
	  ll_lfc_xoff_seq.tgtdestID_0 = 32'h2;
	  ll_lfc_xoff_seq.DestinationID_0 = 32'hFFFF_FFFF;
	  ll_lfc_xoff_seq.FAM_0 = 3'b0;
	  ll_lfc_xoff_seq.flowID_0 = flowid;
          ll_lfc_xoff_seq.start(vseq_ll_sequencer);
	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with LFC XOFF UNSUPPORTED FLOWID SEQUENCE   "),UVM_LOW); end
	end //}
	endtask
endclass :srio_ll_lfc_unsupport_flowid_seq


//================LFC XON(ARB_0)  SEQUENCES ============

class srio_ll_lfc_xon_arb_0_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_lfc_xon_arb_0_seq)

  rand bit [6:0] flowid;
  srio_ll_lfc_seq  ll_lfc_xon_arb_0_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();

          ll_lfc_xon_arb_0_seq   = srio_ll_lfc_seq::type_id::create("ll_lfc_xon_arb_0_seq");
  	  ll_lfc_xon_arb_0_seq.ftype_0 = 4'h7;
          ll_lfc_xon_arb_0_seq.xon_xoff_0 = 1'b1;
	  ll_lfc_xon_arb_0_seq.tgtdestID_0 = 32'h1;
	  ll_lfc_xon_arb_0_seq.DestinationID_0 =32'hFFFF_FFFF;
	  ll_lfc_xon_arb_0_seq.FAM_0 = 3'b010;
	  ll_lfc_xon_arb_0_seq.flowID_0 = flowid;
	  ll_lfc_xon_arb_0_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with LFC XON ARB_0 SEQUENCE   "),UVM_LOW); end

  endtask

endclass :srio_ll_lfc_xon_arb_0_seq

//================LFC XON(ARB_1)  SEQUENCES ============

class srio_ll_lfc_xon_arb_1_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_lfc_xon_arb_1_seq)

  rand bit [6:0] flowid;
  srio_ll_lfc_seq  ll_lfc_xon_arb_1_seq ;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();

          ll_lfc_xon_arb_1_seq   = srio_ll_lfc_seq::type_id::create("ll_lfc_xon_arb_1_seq");
  	 ll_lfc_xon_arb_1_seq.ftype_0 = 4'h7;
          ll_lfc_xon_arb_1_seq.xon_xoff_0 = 1'b1;
	  ll_lfc_xon_arb_1_seq.tgtdestID_0 = 32'h1;
	  ll_lfc_xon_arb_1_seq.DestinationID_0 =32'hFFFF_FFFF;
	  ll_lfc_xon_arb_1_seq.FAM_0 = 3'b011;
	  ll_lfc_xon_arb_1_seq.flowID_0 = flowid;
	  
          ll_lfc_xon_arb_1_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with LFC XON ARB_1 SEQUENCE   "),UVM_LOW); end
  endtask

endclass :srio_ll_lfc_xon_arb_1_seq
//==============LFC AND DS FOR FLOW ARBITRATION SEQUENCES=============

class srio_ll_lfc_ds_single_pdu_arb_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_lfc_ds_single_pdu_arb_seq)

   rand bit [7:0] mtusize_1;
   rand bit [15:0] pdu_length_1;
   rand bit [1:0] prior;
   rand bit crf_1;

   srio_ll_lfc_ds_single_pdu_arb_base_seq ll_lfc_ds_single_pdu_arb_base_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	
            ll_lfc_ds_single_pdu_arb_base_seq = srio_ll_lfc_ds_single_pdu_arb_base_seq ::type_id::create("ll_lfc_ds_single_pdu_arb_base_seq");      
        ll_lfc_ds_single_pdu_arb_base_seq.mtusize_0 = mtusize_1;
        ll_lfc_ds_single_pdu_arb_base_seq.pdulength_0 = pdu_length_1;
        ll_lfc_ds_single_pdu_arb_base_seq.prio_0 = prior;
        ll_lfc_ds_single_pdu_arb_base_seq.crf_0 = crf_1;
        ll_lfc_ds_single_pdu_arb_base_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with LFC AND DS FOR FLOW ARBITRATION"),UVM_LOW); end

  endtask

endclass :srio_ll_lfc_ds_single_pdu_arb_seq

//==============LFC AND DS FOR FLOW ARBITRATION SEQUENCES=============

class srio_ll_lfc_ds_multi_pdu_arb_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_lfc_ds_multi_pdu_arb_seq)

   rand bit [7:0] mtusize_1;
   rand bit [15:0] pdu_length_1;
   rand bit [1:0] prior;
   rand bit crf_1;

   srio_ll_lfc_ds_multi_pdu_arb_base_seq ll_lfc_ds_multi_pdu_arb_base_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	repeat(3) begin //{
        ll_lfc_ds_multi_pdu_arb_base_seq = srio_ll_lfc_ds_multi_pdu_arb_base_seq ::type_id::create("ll_lfc_ds_multi_pdu_arb_base_seq");
        ll_lfc_ds_multi_pdu_arb_base_seq.mtusize_0 = mtusize_1;
        ll_lfc_ds_multi_pdu_arb_base_seq.pdulength_0 = pdu_length_1;
        ll_lfc_ds_multi_pdu_arb_base_seq.prio_0 = prior;
        ll_lfc_ds_multi_pdu_arb_base_seq.crf_0 = crf_1;

        ll_lfc_ds_multi_pdu_arb_base_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with LFC AND DS FOR FLOW ARBITRATION"),UVM_LOW); end
        end //}
  endtask

endclass :srio_ll_lfc_ds_multi_pdu_arb_seq
//================LFC XOFF(REQUEST_SINGLE PDU 1)  SEQUENCES ============

class srio_ll_lfc_request_flow_spdu_1_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_lfc_request_flow_spdu_1_seq)
  rand bit [6:0] flowid;
  srio_ll_lfc_seq  ll_lfc_request_flow_spdu_1_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	
          ll_lfc_request_flow_spdu_1_seq = srio_ll_lfc_seq::type_id::create("ll_lfc_request_flow_spdu_1_seq");
  	  ll_lfc_request_flow_spdu_1_seq.ftype_0 = 4'h7;
          ll_lfc_request_flow_spdu_1_seq.xon_xoff_0 = 1'b1;
	  ll_lfc_request_flow_spdu_1_seq.tgtdestID_0 = 32'h2;
	  ll_lfc_request_flow_spdu_1_seq.DestinationID_0 =32'hFFFF_FFFF;
	  ll_lfc_request_flow_spdu_1_seq.FAM_0 = 3'b101;
	  ll_lfc_request_flow_spdu_1_seq.flowID_0 = flowid;
	  
          ll_lfc_request_flow_spdu_1_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with LFC XOFF REQUEST_SINGLE_PDU_1 GRANTED SEQUENCE   "),UVM_LOW); end

  endtask

endclass :srio_ll_lfc_request_flow_spdu_1_seq

//================LFC XOFF(REQUEST_0 FOR SINGLE PDU)  SEQUENCES ============

class srio_ll_lfc_request_flow_spdu_0_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_lfc_request_flow_spdu_0_seq)
  rand bit [6:0] flowid;
  srio_ll_lfc_seq  ll_lfc_request_flow_spdu_0_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
          ll_lfc_request_flow_spdu_0_seq = srio_ll_lfc_seq::type_id::create("ll_lfc_request_flow_spdu_0_seq");
  	  ll_lfc_request_flow_spdu_0_seq.ftype_0 = 4'h7;
          ll_lfc_request_flow_spdu_0_seq.xon_xoff_0 = 1'b1;
	  ll_lfc_request_flow_spdu_0_seq.tgtdestID_0 = 32'h2;
	  ll_lfc_request_flow_spdu_0_seq.DestinationID_0 =32'hFFFF_FFFF;
	  ll_lfc_request_flow_spdu_0_seq.FAM_0 = 3'b100;
	  ll_lfc_request_flow_spdu_0_seq.flowID_0 = flowid;
	  
          ll_lfc_request_flow_spdu_0_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with LFC XOFF REQUEST_0 GRANTED FOR SINGLE PDUSEQUENCE   "),UVM_LOW); end
  endtask

endclass :srio_ll_lfc_request_flow_spdu_0_seq

//================LFC XOFF(RELEASE_0)  SEQUENCES ============

class srio_ll_lfc_release_0_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_lfc_release_0_seq)
  rand bit [6:0] flowid;
  srio_ll_lfc_seq  ll_lfc_release_0_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	
          ll_lfc_release_0_seq   = srio_ll_lfc_seq::type_id::create("ll_lfc_release_0_seq");
  	  ll_lfc_release_0_seq.ftype_0 = 4'h7;
          ll_lfc_release_0_seq.xon_xoff_0 = 1'b0;
	  ll_lfc_release_0_seq.tgtdestID_0 = 32'h2;
	  ll_lfc_release_0_seq.DestinationID_0 =32'hFFFF_FFFF;
	  ll_lfc_release_0_seq.FAM_0 = 3'b100;
	  ll_lfc_release_0_seq.flowID_0 = flowid;
	  
          ll_lfc_release_0_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with LFC XOFF RELEASE_0 SEQUENCE   "),UVM_LOW); end

  endtask

endclass :srio_ll_lfc_release_0_seq

//================LFC XOFF(RELEASE_1)  SEQUENCES ============

class srio_ll_lfc_release_1_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_lfc_release_1_seq)
  rand bit [6:0] flowid;
  srio_ll_lfc_seq  ll_lfc_release_1_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	

          ll_lfc_release_1_seq = srio_ll_lfc_seq::type_id::create("ll_lfc_release_1_seq");
  	  ll_lfc_release_1_seq.ftype_0 = 4'h7;
          ll_lfc_release_1_seq.xon_xoff_0 = 1'b0;
	  ll_lfc_release_1_seq.tgtdestID_0 = 32'h2;
	  ll_lfc_release_1_seq.DestinationID_0 =32'hFFFF_FFFF;
	  ll_lfc_release_1_seq.FAM_0 = 3'b101;
	  ll_lfc_release_1_seq.flowID_0 = flowid;
	  
          ll_lfc_release_1_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with LFC XOFF RELEASE_1 SEQUENCE   "),UVM_LOW); end

  endtask

endclass :srio_ll_lfc_release_1_seq
//================FLOW ARBITRATION SUPPORT CONFIGURED  ============

class srio_ll_flow_arb_support_reg_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_flow_arb_support_reg_seq)
     
   srio_ll_flow_arb_support_reg_base_seq ll_flow_arb_support_reg_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	
         ll_flow_arb_support_reg_seq  =srio_ll_flow_arb_support_reg_base_seq ::type_id::create("ll_flow_arb_support_reg_seq");   


          ll_flow_arb_support_reg_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with FLOW ARBITRATION SUPPORT    "),UVM_LOW); end
   endtask

endclass :srio_ll_flow_arb_support_reg_seq
//================LFC XOFF(REQUEST FOR MULTIPDU)  SEQUENCES ============

class srio_ll_lfc_request_flow_mpdu_1_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_lfc_request_flow_mpdu_1_seq)
  rand bit [6:0] flowid;
  srio_ll_lfc_seq  ll_lfc_request_flow_mpdu_1_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	          ll_lfc_request_flow_mpdu_1_seq   = srio_ll_lfc_seq::type_id::create("ll_lfc_request_flow_mpdu_1_seq");
  	  ll_lfc_request_flow_mpdu_1_seq.ftype_0 = 4'h7;
          ll_lfc_request_flow_mpdu_1_seq.xon_xoff_0 = 1'b1;
	  ll_lfc_request_flow_mpdu_1_seq.tgtdestID_0 = 32'h2;
	  ll_lfc_request_flow_mpdu_1_seq.DestinationID_0 =32'hFFFF_FFFF;
	  ll_lfc_request_flow_mpdu_1_seq.FAM_0 = 3'b111;
	  ll_lfc_request_flow_mpdu_1_seq.flowID_0 = flowid;
	  
          ll_lfc_request_flow_mpdu_1_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with LFC XOFF REQUEST FOR MULTIPDU_1 SEQUENCE   "),UVM_LOW); end

  endtask

endclass :srio_ll_lfc_request_flow_mpdu_1_seq

//================LFC XOFF(REQUEST FOR MULTIPDU_0)  SEQUENCES ============

class srio_ll_lfc_request_flow_mpdu_0_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_lfc_request_flow_mpdu_0_seq)
  rand bit [6:0] flowid;
  srio_ll_lfc_seq  ll_lfc_request_flow_mpdu_0_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	
          ll_lfc_request_flow_mpdu_0_seq   = srio_ll_lfc_seq::type_id::create("ll_lfc_request_flow_mpdu_0_seq");
  	  ll_lfc_request_flow_mpdu_0_seq.ftype_0 = 4'h7;
          ll_lfc_request_flow_mpdu_0_seq.xon_xoff_0 = 1'b1;
	  ll_lfc_request_flow_mpdu_0_seq.tgtdestID_0 = 32'h2;
	  ll_lfc_request_flow_mpdu_0_seq.DestinationID_0 =32'hFFFF_FFFF;
	  ll_lfc_request_flow_mpdu_0_seq.FAM_0 = 3'b110;
	  ll_lfc_request_flow_mpdu_0_seq.flowID_0 = flowid;
	  
          ll_lfc_request_flow_mpdu_0_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with LFC XOFF REQUEST FOR MULTIPDU_0 SEQUENCE   "),UVM_LOW); end

  endtask

endclass :srio_ll_lfc_request_flow_mpdu_0_seq


//==============TRAFFIC MANAGEMENT TM type & mode error SEQUENCES=============

class srio_ll_traffic_mgmt_tm_type_mode_err_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_traffic_mgmt_tm_type_mode_err_seq)

  srio_ll_traffic_mgmt_tm_type_mode_seq ll_traffic_mgmt_tm_type_mode_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 50 ;i++) begin //{
           ll_traffic_mgmt_tm_type_mode_seq  = srio_ll_traffic_mgmt_tm_type_mode_seq::type_id::create("ll_traffic_mgmt_tm_type_mode_seq");

  	ll_traffic_mgmt_tm_type_mode_seq.ftype_0 = 4'h9;
        ll_traffic_mgmt_tm_type_mode_seq.xh_0 = 1'b1;
        ll_traffic_mgmt_tm_type_mode_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with DS TM TYPE AND MODE ERROR   "),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

		end //}
  endtask

endclass :srio_ll_traffic_mgmt_tm_type_mode_err_seq

//================ TRAFFIC MANAGEMENT FOR MASK ERROR SEQUENCES ===

class srio_ll_ds_traffic_mgmt_mask_err_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_traffic_mgmt_mask_err_seq)
   rand bit [2:0] invalid_sel;
   rand logic [7:0] mask_rand ;
    srio_ll_ds_traffic_mgmt_stream_base_seq ll_ds_traffic_mgmt_basic_stream_xoff_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	          ll_ds_traffic_mgmt_basic_stream_xoff_seq   = srio_ll_ds_traffic_mgmt_stream_base_seq::type_id::create("ll_ds_traffic_mgmt_basic_stream_xoff_seq");
   invalid_sel = $urandom;

   case(invalid_sel)
        3'b000 : mask_rand = 2;
        3'b001 : mask_rand = $urandom_range(6,4);
        3'b010 : mask_rand = $urandom_range(14,8);
        3'b011 : mask_rand = $urandom_range(30,16);
        3'b100 : mask_rand = $urandom_range(62,32);
        3'b101 : mask_rand = $urandom_range(126,64);
        3'b110 : mask_rand = $urandom_range(254,128);
    endcase
 	
    ll_ds_traffic_mgmt_basic_stream_xoff_seq.xh_0 = 1'b1;
	ll_ds_traffic_mgmt_basic_stream_xoff_seq.TMOP_0 = 4'h0;
	ll_ds_traffic_mgmt_basic_stream_xoff_seq.ftype_0 = 4'h9;	
	ll_ds_traffic_mgmt_basic_stream_xoff_seq.wild_card_0 = 3'b0;
	ll_ds_traffic_mgmt_basic_stream_xoff_seq.parameter1_0 = 8'h0; 	  
	ll_ds_traffic_mgmt_basic_stream_xoff_seq.parameter2_0 = 8'h0; 	  
	ll_ds_traffic_mgmt_basic_stream_xoff_seq.cos_0 = 8'h1F; 	  
	ll_ds_traffic_mgmt_basic_stream_xoff_seq.streamID_0 = 16'h3F; 	  
	ll_ds_traffic_mgmt_basic_stream_xoff_seq.mask_0 = mask_rand; 
    ll_ds_traffic_mgmt_basic_stream_xoff_seq.xtype_0 = 3'h0;	  
        ll_ds_traffic_mgmt_basic_stream_xoff_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with TRAFFIC MANAGEMENT FOR MASK ERROR SEQUENCE   "),UVM_LOW); end

  endtask

endclass :srio_ll_ds_traffic_mgmt_mask_err_seq

//================ TRAFFIC MANAGEMENT FOR different operations SEQUENCES ===

class srio_ll_ds_traffic_mgmt_diff_operation_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_traffic_mgmt_diff_operation_seq)
   rand bit [3:0] TMOP_rand;
   rand bit a;
   rand bit [1:0] b;
   rand bit [7:0] para1;
   rand bit [7:0] para2;
   rand bit [3:0] c;
    srio_ll_ds_traffic_mgmt_various_operation_base_seq ll_ds_traffic_mgmt_diff_operation_base_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
    repeat(50)
      begin
	          ll_ds_traffic_mgmt_diff_operation_base_seq   = srio_ll_ds_traffic_mgmt_various_operation_base_seq::type_id::create("ll_ds_traffic_mgmt_diff_operation_base_seq");

    a = $urandom;
    b = $urandom_range(3,1);  
    c = $urandom_range(16,0); 
    if(TMOP_rand == 0)
      begin
       para1 = {6'h00,2'b11};
       para2 = $urandom_range(255,0);
      end
    else if (TMOP_rand == 1)
       begin
        para1 = {5'h00,a,b};
           if (para1[2:0] == {a,2'b01})
              begin
                 para2 = $urandom_range(255,0);
              end
           else if (para1[2:0] == {a,2'b10})
                 para2 = $urandom_range(255,1);
           else if (para1[2:0] == 3'b011)
                 para2 = $urandom_range(255,1);
       end
    else if (TMOP_rand == 2)
       begin
         if((b==1)||(b==2))
           begin
            para1 = {2'b00,b,c};
            para2 = $urandom_range(255,0);
           end
         else if (b == 3)
           begin
            para1 = {2'b00,2'b11,4'b0000};
            para2 = $urandom_range(255,0);
           end
       end
    ll_ds_traffic_mgmt_diff_operation_base_seq.xh_0 = 1'b1;
	ll_ds_traffic_mgmt_diff_operation_base_seq.TMOP_0 = TMOP_rand;
	ll_ds_traffic_mgmt_diff_operation_base_seq.ftype_0 = 4'h9;	
	ll_ds_traffic_mgmt_diff_operation_base_seq.wild_card_0 = 3'b0;
	ll_ds_traffic_mgmt_diff_operation_base_seq.parameter1_0 = para1; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.parameter2_0 = para2; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.cos_0 = 8'h1F; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.streamID_0 = 16'h3F; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.mask_0 = 8'h0; 
    ll_ds_traffic_mgmt_diff_operation_base_seq.xtype_0 = 3'h0;	  
    ll_ds_traffic_mgmt_diff_operation_base_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with TRAFFIC MANAGEMENT FOR queue status,reduce,increase,double,credit,allocate SEQUENCE   "),UVM_LOW); end

end
  endtask

endclass :srio_ll_ds_traffic_mgmt_diff_operation_seq

//================ TRAFFIC MANAGEMENT FOR CREDIT XON STREAM MANAGEMENT SEQUENCES ===

class srio_ll_ds_traffic_mgmt_user_credit_err_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_traffic_mgmt_user_credit_err_seq)

    srio_ll_ds_traffic_mgmt_credit_err_seq ll_ds_traffic_mgmt_user_credit_err_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	          ll_ds_traffic_mgmt_user_credit_err_seq   = srio_ll_ds_traffic_mgmt_credit_err_seq::type_id::create("ll_ds_traffic_mgmt_user_credit_err_seq");
  	
        ll_ds_traffic_mgmt_user_credit_err_seq.xh_0 = 1'b1;
	ll_ds_traffic_mgmt_user_credit_err_seq.TMOP_0 = 4'h2;
	ll_ds_traffic_mgmt_user_credit_err_seq.ftype_0 = 4'h9;	
	ll_ds_traffic_mgmt_user_credit_err_seq.wild_card_0 = 3'b0;
	ll_ds_traffic_mgmt_user_credit_err_seq.parameter1_0 = 16; 	  
	ll_ds_traffic_mgmt_user_credit_err_seq.parameter2_0 = 1; 	  
	ll_ds_traffic_mgmt_user_credit_err_seq.cos_0 = 8'h1F; 	  
	ll_ds_traffic_mgmt_user_credit_err_seq.streamID_0 = 16'h3F; 	  
	ll_ds_traffic_mgmt_user_credit_err_seq.mask_0 = 8'h0; 
        ll_ds_traffic_mgmt_user_credit_err_seq.xtype_0 = 3'h0;	  
        ll_ds_traffic_mgmt_user_credit_err_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with TRAFFIC MANAGEMENT FOR CREDIT XON STREAM MANAGEMENT SEQUENCE   "),UVM_LOW); end

  endtask

endclass :srio_ll_ds_traffic_mgmt_user_credit_err_seq
//================ TRAFFIC MANAGEMENT FOR specific stream  XOFF SEQUENCES ===

class srio_ll_ds_traffic_mgmt_specific_stream_xoff_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_traffic_mgmt_specific_stream_xoff_seq)
   rand bit [3:0] TMOP_rand;

    srio_ll_ds_traffic_mgmt_diff_operation_base_seq ll_ds_traffic_mgmt_diff_operation_base_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
      begin
	          ll_ds_traffic_mgmt_diff_operation_base_seq   = srio_ll_ds_traffic_mgmt_diff_operation_base_seq::type_id::create("ll_ds_traffic_mgmt_diff_operation_base_seq");
    ll_ds_traffic_mgmt_diff_operation_base_seq.xh_0 = 1'b1;
	ll_ds_traffic_mgmt_diff_operation_base_seq.TMOP_0 = TMOP_rand;
	ll_ds_traffic_mgmt_diff_operation_base_seq.ftype_0 = 4'h9;	
	ll_ds_traffic_mgmt_diff_operation_base_seq.wild_card_0 = 3'b0;
	ll_ds_traffic_mgmt_diff_operation_base_seq.parameter1_0 = 0; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.parameter2_0 = 0; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.cos_0 = 8'h1F; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.streamID_0 = 16'h3F; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.mask_0 = 8'h0; 
    ll_ds_traffic_mgmt_diff_operation_base_seq.xtype_0 = 3'h0;	  
    ll_ds_traffic_mgmt_diff_operation_base_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with TRAFFIC MANAGEMENT FOR SPECIFIC STREAM XOFF SEQUENCE   "),UVM_LOW); end

end
  endtask

endclass :srio_ll_ds_traffic_mgmt_specific_stream_xoff_seq

//================ TRAFFIC MANAGEMENT FOR specific stream  XON SEQUENCES ===

class srio_ll_ds_traffic_mgmt_specific_stream_xon_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_traffic_mgmt_specific_stream_xon_seq)
   rand bit [3:0] TMOP_rand;

    srio_ll_ds_traffic_mgmt_diff_operation_base_seq ll_ds_traffic_mgmt_diff_operation_base_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
      begin
	          ll_ds_traffic_mgmt_diff_operation_base_seq   = srio_ll_ds_traffic_mgmt_diff_operation_base_seq::type_id::create("ll_ds_traffic_mgmt_diff_operation_base_seq");
    ll_ds_traffic_mgmt_diff_operation_base_seq.xh_0 = 1'b1;
	ll_ds_traffic_mgmt_diff_operation_base_seq.TMOP_0 = TMOP_rand;
	ll_ds_traffic_mgmt_diff_operation_base_seq.ftype_0 = 4'h9;	
	ll_ds_traffic_mgmt_diff_operation_base_seq.wild_card_0 = 3'b0;
	ll_ds_traffic_mgmt_diff_operation_base_seq.parameter1_0 = 0; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.parameter2_0 = 8'hff; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.cos_0 = 8'h1F; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.streamID_0 = 16'h3F; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.mask_0 = 8'h0; 
    ll_ds_traffic_mgmt_diff_operation_base_seq.xtype_0 = 3'h0;	  
    ll_ds_traffic_mgmt_diff_operation_base_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with TRAFFIC MANAGEMENT FOR SPECIFIC STREAM XON SEQUENCE   "),UVM_LOW); end

end
  endtask

endclass :srio_ll_ds_traffic_mgmt_specific_stream_xon_seq

//================ TRAFFIC MANAGEMENT FOR specific COS  XOFF SEQUENCES ===

class srio_ll_ds_traffic_mgmt_specific_cos_xoff_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_traffic_mgmt_specific_cos_xoff_seq)
   rand bit [3:0] TMOP_rand;
   rand bit [15:0] streamID_rand;
   rand bit  sel ;

    srio_ll_ds_traffic_mgmt_diff_operation_base_seq ll_ds_traffic_mgmt_diff_operation_base_seq;
  function new(string name="");
    super.new(name);
  endfunction
  task body();
	super.body();
      begin
              sel = $urandom;
             if (sel == 0)
               streamID_rand = 16'h0030;
             else
               streamID_rand = 16'h00ff;
	          ll_ds_traffic_mgmt_diff_operation_base_seq   = srio_ll_ds_traffic_mgmt_diff_operation_base_seq::type_id::create("ll_ds_traffic_mgmt_diff_operation_base_seq");
    ll_ds_traffic_mgmt_diff_operation_base_seq.xh_0 = 1'b1;
	ll_ds_traffic_mgmt_diff_operation_base_seq.TMOP_0 = TMOP_rand;
	ll_ds_traffic_mgmt_diff_operation_base_seq.ftype_0 = 4'h9;	
	ll_ds_traffic_mgmt_diff_operation_base_seq.wild_card_0 = 3'b001;
	ll_ds_traffic_mgmt_diff_operation_base_seq.parameter1_0 = 0; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.parameter2_0 = 0; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.cos_0 = 8'h1F; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.streamID_0 = streamID_rand; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.mask_0 = 8'h0; 
    ll_ds_traffic_mgmt_diff_operation_base_seq.xtype_0 = 3'h0;	  
    ll_ds_traffic_mgmt_diff_operation_base_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with TRAFFIC MANAGEMENT FOR SPECIFIC COS XOFF SEQUENCE   "),UVM_LOW); end

end
  endtask

endclass :srio_ll_ds_traffic_mgmt_specific_cos_xoff_seq

//================ TRAFFIC MANAGEMENT FOR specific COS  XON SEQUENCES ===

class srio_ll_ds_traffic_mgmt_specific_cos_xon_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_traffic_mgmt_specific_cos_xon_seq)
   rand bit [3:0] TMOP_rand;
   rand bit [15:0] streamID_rand;
   rand bit  sel ;

    srio_ll_ds_traffic_mgmt_diff_operation_base_seq ll_ds_traffic_mgmt_diff_operation_base_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
      begin
             sel = $urandom;
             if (sel == 0)
               streamID_rand = 16'h0030;
             else
               streamID_rand = 16'h00ff;	  

        ll_ds_traffic_mgmt_diff_operation_base_seq   = srio_ll_ds_traffic_mgmt_diff_operation_base_seq::type_id::create("ll_ds_traffic_mgmt_diff_operation_base_seq");
    ll_ds_traffic_mgmt_diff_operation_base_seq.xh_0 = 1'b1;
	ll_ds_traffic_mgmt_diff_operation_base_seq.TMOP_0 = TMOP_rand;
	ll_ds_traffic_mgmt_diff_operation_base_seq.ftype_0 = 4'h9;	
	ll_ds_traffic_mgmt_diff_operation_base_seq.wild_card_0 = 3'b001;
	ll_ds_traffic_mgmt_diff_operation_base_seq.parameter1_0 = 0; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.parameter2_0 = 8'hff; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.cos_0 = 8'h1F; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.streamID_0 = streamID_rand; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.mask_0 = 8'h0; 
    ll_ds_traffic_mgmt_diff_operation_base_seq.xtype_0 = 3'h0;	  
    ll_ds_traffic_mgmt_diff_operation_base_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with TRAFFIC MANAGEMENT FOR SPECIFIC COS XON SEQUENCE   "),UVM_LOW); end

end
  endtask

endclass :srio_ll_ds_traffic_mgmt_specific_cos_xon_seq

//================ TRAFFIC MANAGEMENT FOR ALL STREAM AND GROUP OF COS  XOFF SEQUENCES ===

class srio_ll_ds_traffic_mgmt_group_of_cos_xoff_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_traffic_mgmt_group_of_cos_xoff_seq)
   rand bit [3:0] TMOP_rand;
   rand bit [15:0] streamID_rand;
    srio_ll_ds_traffic_mgmt_diff_operation_base_seq ll_ds_traffic_mgmt_diff_operation_base_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
      begin

              streamID_rand = $urandom;
	          ll_ds_traffic_mgmt_diff_operation_base_seq   = srio_ll_ds_traffic_mgmt_diff_operation_base_seq::type_id::create("ll_ds_traffic_mgmt_diff_operation_base_seq");
    ll_ds_traffic_mgmt_diff_operation_base_seq.xh_0 = 1'b1;
	ll_ds_traffic_mgmt_diff_operation_base_seq.TMOP_0 = TMOP_rand;
	ll_ds_traffic_mgmt_diff_operation_base_seq.ftype_0 = 4'h9;	
	ll_ds_traffic_mgmt_diff_operation_base_seq.wild_card_0 = 3'b001;
	ll_ds_traffic_mgmt_diff_operation_base_seq.parameter1_0 = 0; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.parameter2_0 = 0; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.cos_0 = 8'h1F; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.streamID_0 = streamID_rand; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.mask_0 = 8'h01; 
    ll_ds_traffic_mgmt_diff_operation_base_seq.xtype_0 = 3'h0;	  
    ll_ds_traffic_mgmt_diff_operation_base_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with TRAFFIC MANAGEMENT FOR GROUP COS XOFF SEQUENCE   "),UVM_LOW); end

end
  endtask

endclass :srio_ll_ds_traffic_mgmt_group_of_cos_xoff_seq

//================ TRAFFIC MANAGEMENT FOR ALL STREAM AND GROUP OF COS  XON SEQUENCES ===

class srio_ll_ds_traffic_mgmt_group_of_cos_xon_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_traffic_mgmt_group_of_cos_xon_seq)
   rand bit [3:0] TMOP_rand;
   rand bit [15:0] streamID_rand;
    srio_ll_ds_traffic_mgmt_diff_operation_base_seq ll_ds_traffic_mgmt_diff_operation_base_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
      begin
             streamID_rand = $urandom_range(65535,0);
	          ll_ds_traffic_mgmt_diff_operation_base_seq   = srio_ll_ds_traffic_mgmt_diff_operation_base_seq::type_id::create("ll_ds_traffic_mgmt_diff_operation_base_seq");
    ll_ds_traffic_mgmt_diff_operation_base_seq.xh_0 = 1'b1;
	ll_ds_traffic_mgmt_diff_operation_base_seq.TMOP_0 = TMOP_rand;
	ll_ds_traffic_mgmt_diff_operation_base_seq.ftype_0 = 4'h9;	
	ll_ds_traffic_mgmt_diff_operation_base_seq.wild_card_0 = 3'b001;
	ll_ds_traffic_mgmt_diff_operation_base_seq.parameter1_0 = 0; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.parameter2_0 = 8'hff; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.cos_0 = 8'h1F; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.streamID_0 = streamID_rand; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.mask_0 = 8'h01; 
    ll_ds_traffic_mgmt_diff_operation_base_seq.xtype_0 = 3'h0;	  
    ll_ds_traffic_mgmt_diff_operation_base_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with TRAFFIC MANAGEMENT FOR GROUP COS XON SEQUENCE   "),UVM_LOW); end

end
  endtask

endclass :srio_ll_ds_traffic_mgmt_group_of_cos_xon_seq

//================ TRAFFIC MANAGEMENT FOR ALL STREAM AND ALL COS  XOFF SEQUENCES ===

class srio_ll_ds_traffic_mgmt_random_cos_xoff_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_traffic_mgmt_random_cos_xoff_seq)
   rand bit [3:0] TMOP_rand;
   rand bit [15:0] streamID_rand;
   bit [7:0] mask_rand;
   rand bit [7:0] cos_rand;
   rand bit [3:0] sel;

    srio_ll_ds_traffic_mgmt_diff_operation_base_seq ll_ds_traffic_mgmt_diff_operation_base_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
      begin
             streamID_rand = $urandom;
             cos_rand   = $urandom;

             sel     = $urandom_range(8,0);
             if(sel == 0)
               mask_rand = 8'b00000000;
             if(sel == 1)
               mask_rand = 8'b00000001;
             if(sel == 2)
               mask_rand = 8'b00000011;
             if(sel == 3)
               mask_rand = 8'b00000111;
             if(sel == 4)
               mask_rand = 8'b00001111;
             if(sel == 5)
               mask_rand = 8'b00011111;
             if(sel == 6)
               mask_rand = 8'b00111111;
             if(sel == 7)
               mask_rand = 8'b01111111;
             if(sel == 8)
               mask_rand = 8'b11111111; 
	          ll_ds_traffic_mgmt_diff_operation_base_seq   = srio_ll_ds_traffic_mgmt_diff_operation_base_seq::type_id::create("ll_ds_traffic_mgmt_diff_operation_base_seq");
    ll_ds_traffic_mgmt_diff_operation_base_seq.xh_0 = 1'b1;
	ll_ds_traffic_mgmt_diff_operation_base_seq.TMOP_0 = TMOP_rand;
	ll_ds_traffic_mgmt_diff_operation_base_seq.ftype_0 = 4'h9;	
	ll_ds_traffic_mgmt_diff_operation_base_seq.wild_card_0 = 3'b011;
	ll_ds_traffic_mgmt_diff_operation_base_seq.parameter1_0 = 0; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.parameter2_0 = 0; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.cos_0 = cos_rand; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.streamID_0 = streamID_rand; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.mask_0 = mask_rand; 
    ll_ds_traffic_mgmt_diff_operation_base_seq.xtype_0 = 3'h0;	  
    ll_ds_traffic_mgmt_diff_operation_base_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with TRAFFIC MANAGEMENT FOR SPECIFIC COS XOFF SEQUENCE   "),UVM_LOW); end

end
  endtask

endclass :srio_ll_ds_traffic_mgmt_random_cos_xoff_seq

//================ TRAFFIC MANAGEMENT FOR ALL STREAM AND ALL COS  XON SEQUENCES ===

class srio_ll_ds_traffic_mgmt_random_cos_xon_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_traffic_mgmt_random_cos_xon_seq)
   rand bit [3:0] TMOP_rand;
   rand bit [15:0] streamID_rand;
   bit [7:0] mask_rand;
   rand bit [7:0] cos_rand;
   rand bit [3:0] sel;
    srio_ll_ds_traffic_mgmt_diff_operation_base_seq ll_ds_traffic_mgmt_diff_operation_base_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
      begin
             streamID_rand = $urandom;
             cos_rand  = $urandom;
             sel     = $urandom_range(8,0);
             if(sel == 0)
               mask_rand = 8'b00000000;
             if(sel == 1)
               mask_rand = 8'b00000001;
             if(sel == 2)
               mask_rand = 8'b00000011;
             if(sel == 3)
               mask_rand = 8'b00000111;
             if(sel == 4)
               mask_rand = 8'b00001111;
             if(sel == 5)
               mask_rand = 8'b00011111;
             if(sel == 6)
               mask_rand = 8'b00111111;
             if(sel == 7)
               mask_rand = 8'b01111111;
             if(sel == 8)
               mask_rand = 8'b11111111;            

	          ll_ds_traffic_mgmt_diff_operation_base_seq   = srio_ll_ds_traffic_mgmt_diff_operation_base_seq::type_id::create("ll_ds_traffic_mgmt_diff_operation_base_seq");
    ll_ds_traffic_mgmt_diff_operation_base_seq.xh_0 = 1'b1;
	ll_ds_traffic_mgmt_diff_operation_base_seq.TMOP_0 = TMOP_rand;
	ll_ds_traffic_mgmt_diff_operation_base_seq.ftype_0 = 4'h9;	
	ll_ds_traffic_mgmt_diff_operation_base_seq.wild_card_0 = 3'b011;
	ll_ds_traffic_mgmt_diff_operation_base_seq.parameter1_0 = 0; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.parameter2_0 = 8'hff; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.cos_0 = cos_rand; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.streamID_0 = streamID_rand; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.mask_0 = mask_rand; 
    ll_ds_traffic_mgmt_diff_operation_base_seq.xtype_0 = 3'h0;	  
    ll_ds_traffic_mgmt_diff_operation_base_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with TRAFFIC MANAGEMENT FOR SPECIFIC COS XON SEQUENCE   "),UVM_LOW); end

end
  endtask

endclass :srio_ll_ds_traffic_mgmt_random_cos_xon_seq


//================DATA STREAMING MULTI SEGMENT WITH SINGLE MTU CONFIGURED AND DEFINED PRIORITY ,CRF FOR LFC ============

class srio_ll_lfc_ds_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_lfc_ds_seq)
   rand bit [1:0] prior;
   rand bit crf_1;
   srio_ll_lfc_ds_base_seq ll_lfc_ds_base_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	
         ll_lfc_ds_base_seq  = srio_ll_lfc_ds_base_seq ::type_id::create("ll_lfc_ds_base_seq");   
         ll_lfc_ds_base_seq.prio_0 = prior; 
         ll_lfc_ds_base_seq.crf_0 = crf_1;
          ll_lfc_ds_base_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with DATA STREAMING MULTI SEGMENT WITH SINGLE MTU AND DEFINED PRIORITY AND CRF VALUES FOR LFC CASE "),UVM_LOW); end
  endtask

endclass :srio_ll_lfc_ds_seq
//================ TRAFFIC MANAGEMENT FOR ALL TRAFFIC  SEQUENCES ===

class srio_ll_ds_all_traffic_xoff_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_all_traffic_xoff_seq)
   rand bit [3:0] TMOP_rand;
   rand bit [15:0] streamID_rand;
   bit [7:0] mask_rand;
   rand bit [7:0] cos_rand;
   rand bit [3:0] sel;

    srio_ll_ds_traffic_mgmt_diff_operation_base_seq ll_ds_traffic_mgmt_diff_operation_base_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
      begin
             streamID_rand = $urandom;
             cos_rand   = $urandom;

             sel     = $urandom_range(8,0);
             if(sel == 0)
               mask_rand = 8'b00000000;
             if(sel == 1)
               mask_rand = 8'b00000001;
             if(sel == 2)
               mask_rand = 8'b00000011;
             if(sel == 3)
               mask_rand = 8'b00000111;
             if(sel == 4)
               mask_rand = 8'b00001111;
             if(sel == 5)
               mask_rand = 8'b00011111;
             if(sel == 6)
               mask_rand = 8'b00111111;
             if(sel == 7)
               mask_rand = 8'b01111111;
             if(sel == 8)
               mask_rand = 8'b11111111; 
	          ll_ds_traffic_mgmt_diff_operation_base_seq   = srio_ll_ds_traffic_mgmt_diff_operation_base_seq::type_id::create("ll_ds_traffic_mgmt_diff_operation_base_seq");
    ll_ds_traffic_mgmt_diff_operation_base_seq.xh_0 = 1'b1;
	ll_ds_traffic_mgmt_diff_operation_base_seq.TMOP_0 = TMOP_rand;
	ll_ds_traffic_mgmt_diff_operation_base_seq.ftype_0 = 4'h9;	
	ll_ds_traffic_mgmt_diff_operation_base_seq.wild_card_0 = 3'b111;
	ll_ds_traffic_mgmt_diff_operation_base_seq.parameter1_0 = 0; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.parameter2_0 = 0; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.cos_0 = cos_rand; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.streamID_0 = streamID_rand; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.mask_0 = mask_rand; 
    ll_ds_traffic_mgmt_diff_operation_base_seq.xtype_0 = 3'h0;	  
    ll_ds_traffic_mgmt_diff_operation_base_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual SEQUENCE FOR ALL TRAFFIC XOFF SEQUENCE   "),UVM_LOW); end

end
  endtask

endclass :srio_ll_ds_all_traffic_xoff_seq

//================ TRAFFIC MANAGEMENT FOR ALL TRAFFIC SEQUENCES ===

class srio_ll_ds_all_traffic_xon_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_all_traffic_xon_seq)
   rand bit [3:0] TMOP_rand;
   rand bit [15:0] streamID_rand;
   bit [7:0] mask_rand;
   rand bit [7:0] cos_rand;
   rand bit [3:0] sel;
    srio_ll_ds_traffic_mgmt_diff_operation_base_seq ll_ds_traffic_mgmt_diff_operation_base_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
      begin
             streamID_rand = $urandom;
             cos_rand  = $urandom;
             sel     = $urandom_range(8,0);
             if(sel == 0)
               mask_rand = 8'b00000000;
             if(sel == 1)
               mask_rand = 8'b00000001;
             if(sel == 2)
               mask_rand = 8'b00000011;
             if(sel == 3)
               mask_rand = 8'b00000111;
             if(sel == 4)
               mask_rand = 8'b00001111;
             if(sel == 5)
               mask_rand = 8'b00011111;
             if(sel == 6)
               mask_rand = 8'b00111111;
             if(sel == 7)
               mask_rand = 8'b01111111;
             if(sel == 8)
               mask_rand = 8'b11111111;            

	          ll_ds_traffic_mgmt_diff_operation_base_seq   = srio_ll_ds_traffic_mgmt_diff_operation_base_seq::type_id::create("ll_ds_traffic_mgmt_diff_operation_base_seq");
    ll_ds_traffic_mgmt_diff_operation_base_seq.xh_0 = 1'b1;
	ll_ds_traffic_mgmt_diff_operation_base_seq.TMOP_0 = TMOP_rand;
	ll_ds_traffic_mgmt_diff_operation_base_seq.ftype_0 = 4'h9;	
	ll_ds_traffic_mgmt_diff_operation_base_seq.wild_card_0 = 3'b111;
	ll_ds_traffic_mgmt_diff_operation_base_seq.parameter1_0 = 0; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.parameter2_0 = 8'hff; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.cos_0 = cos_rand; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.streamID_0 = streamID_rand; 	  
	ll_ds_traffic_mgmt_diff_operation_base_seq.mask_0 = mask_rand; 
    ll_ds_traffic_mgmt_diff_operation_base_seq.xtype_0 = 3'h0;	  
    ll_ds_traffic_mgmt_diff_operation_base_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual SEQUENCE FOR ALL TRAFFIC XON SEQUENCE   "),UVM_LOW); end

end
endtask
endclass :srio_ll_ds_all_traffic_xon_seq

//================NWRITE_R and NREAD_R  SEQUENCE FOR 34 BIT ADDRESSING ============

class srio_ll_nwrite_nread_34_addr_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_nwrite_nread_34_addr_seq)

  srio_ll_nwrite_nread_34_addr_base_seq ll_nwrite_r_reg_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 1 ;i++) begin //{
        ll_nwrite_r_reg_seq = srio_ll_nwrite_nread_34_addr_base_seq::type_id::create("ll_nwrite_r_reg_seq");
  	    ll_nwrite_r_reg_seq.rdsize_1= 4'h8;
        ll_nwrite_r_reg_seq.wrsize_1= 4'h8;
        ll_nwrite_r_reg_seq.wdptr_0= 1'h0;
        ll_nwrite_r_reg_seq.address_0=29'h0000_0009 ; 

	ll_nwrite_r_reg_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  NWRITE_R and NREAD_R for 34 bit ADDRESSING"),UVM_LOW); end
#100ns;
		fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}
  endtask

endclass : srio_ll_nwrite_nread_34_addr_seq

//================NWRITE_R and NREAD_R  SEQUENCE FOR 50 BIT ADDRESSING ============

class srio_ll_nwrite_nread_50_addr_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_nwrite_nread_50_addr_seq)

  srio_ll_nwrite_nread_50_addr_base_seq ll_nwrite_r_reg_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 1 ;i++) begin //{
        ll_nwrite_r_reg_seq = srio_ll_nwrite_nread_50_addr_base_seq::type_id::create("ll_nwrite_r_reg_seq");
  	    ll_nwrite_r_reg_seq.rdsize_1= 4'h8;
        ll_nwrite_r_reg_seq.wrsize_1= 4'h8;
        ll_nwrite_r_reg_seq.wdptr_0= 1'h0;
        ll_nwrite_r_reg_seq.address_0=29'h0000_0009 ; 

	ll_nwrite_r_reg_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  NWRITE_R and NREAD_R for 50 bit ADDRESSING"),UVM_LOW); end
#100ns;
		fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}
  endtask

endclass : srio_ll_nwrite_nread_50_addr_seq

//================NWRITE_R and NREAD_R  SEQUENCE FOR 66 BIT ADDRESSING ============

class srio_ll_nwrite_nread_66_addr_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_nwrite_nread_66_addr_seq)

  srio_ll_nwrite_nread_66_addr_base_seq ll_nwrite_r_reg_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 1 ;i++) begin //{
        ll_nwrite_r_reg_seq = srio_ll_nwrite_nread_66_addr_base_seq::type_id::create("ll_nwrite_r_reg_seq");
  	    ll_nwrite_r_reg_seq.rdsize_1= 4'h8;
        ll_nwrite_r_reg_seq.wrsize_1= 4'h8;
        ll_nwrite_r_reg_seq.wdptr_0= 1'h0;
        ll_nwrite_r_reg_seq.address_0=29'h0000_0009 ; 

	ll_nwrite_r_reg_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  NWRITE_R and NREAD_R for 66 bit ADDRESSING"),UVM_LOW); end
#100ns;
		fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}
  endtask

endclass : srio_ll_nwrite_nread_66_addr_seq

//================DATA STREAMING MULTI SEGMENT WITH SINGLE MTU CONFIGURED AND DEFINED PRIORITY ,CRF FOR LFC ============

class srio_ll_lfc_ds_random_prio_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_lfc_ds_random_prio_seq)
   rand bit [1:0] prior;
   rand bit crf_1;
   srio_ll_lfc_ds_random_prio_base_seq ll_lfc_ds_base_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	
         ll_lfc_ds_base_seq  = srio_ll_lfc_ds_random_prio_base_seq ::type_id::create("ll_lfc_ds_base_seq");   
          ll_lfc_ds_base_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with DATA STREAMING MULTI SEGMENT WITH SINGLE MTU AND RANDOM PRIORITY AND CRF VALUES FOR LFC CASE "),UVM_LOW); end
  endtask

endclass :srio_ll_lfc_ds_random_prio_seq

//================TRANSPORT TYPE============

class srio_tl_pkt_tt_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_tl_pkt_tt_seq)
  
 srio_tl_pkt_tt_base_seq tl_pkt_tt_seq ;
   
    function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
          repeat(5) begin //{ 
          tl_pkt_tt_seq = srio_tl_pkt_tt_base_seq::type_id::create("tl_pkt_tt_seq"); 
	       
          tl_pkt_tt_seq.start(vseq_tl_sequencer); 
        begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  TRANSPORT TYPE"),UVM_LOW); end
          end //}
 	  endtask

endclass : srio_tl_pkt_tt_seq
//================SWRITE AND NWRITE TYPE============

class srio_pl_nwrite_swrite_req_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_nwrite_swrite_req_seq)
  
 srio_pl_nwrite_swrite_class_base_seq pl_nwrite_swrite_seq ;
   
    function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
          repeat(5) begin //{ 
          pl_nwrite_swrite_seq = srio_pl_nwrite_swrite_class_base_seq::type_id::create("pl_nwrite_swrite_seq"); 
	       
          pl_nwrite_swrite_seq.start(vseq_pl_sequencer); 
        begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  TRANSPORT TYPE"),UVM_LOW); end
          end //}
 	  endtask

endclass : srio_pl_nwrite_swrite_req_seq

//================NWRITE_R and NREAD_R  SEQUENCE FOR MEMORY ACCESS ============

class srio_ll_nwrite_nread_mem_access_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_nwrite_nread_mem_access_seq)

  srio_ll_nwrite_nread_mem_access_base_seq ll_nwrite_r_reg_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 1 ;i++) begin //{
        ll_nwrite_r_reg_seq = srio_ll_nwrite_nread_mem_access_base_seq::type_id::create("ll_nwrite_r_reg_seq");
  	    ll_nwrite_r_reg_seq.rdsize_1= 4'h8;
        ll_nwrite_r_reg_seq.wrsize_1= 4'h8;
        ll_nwrite_r_reg_seq.wdptr_0= 1'h0;
     //   ll_nwrite_r_reg_seq.address_0=29'h0000_0009 ; 

	ll_nwrite_r_reg_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  NWRITE_R and NREAD_R for 66 bit ADDRESSING"),UVM_LOW); end
#100ns;
		fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}
  endtask

endclass : srio_ll_nwrite_nread_mem_access_seq

//======USER GENERATE random PRIORITY SEQUENCES===========

class srio_ll_user_gen_random_prio_seq extends srio_virtual_base_seq;

  `uvm_object_utils(srio_ll_user_gen_random_prio_seq)
	
     	rand bit [1:0] prior;
  
	srio_ll_user_gen_base_seq ll_user_gen_base_seq;

	function new(string name="");
    	super.new(name);
  	endfunction

	task body();
	super.body();
	repeat(50) begin //{
        prior = $urandom_range(2,0);    
        ll_user_gen_base_seq = srio_ll_user_gen_base_seq::type_id::create("ll_user_gen_base_seq");
  	
        ll_user_gen_base_seq.prio_0 = prior;
        ll_user_gen_base_seq.crf_0 =0;  
	ll_user_gen_base_seq.start(vseq_ll_sequencer);  
       	
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  USER GENERATE PACKET "),UVM_LOW); end
     end //}
  endtask

endclass : srio_ll_user_gen_random_prio_seq

//================MAINTENANCE DS  SUPPORT CONFIGURED  ============

class srio_ll_maintenance_ds_support_reg_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_maintenance_ds_support_reg_seq)
   rand bit [7:0] mtusize_1;
   rand bit [3:0] tm_mode_1;  
   srio_ll_maintenance_ds_support_base_reg ll_maintenace_ds_support_reg_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	
         ll_maintenace_ds_support_reg_seq  =srio_ll_maintenance_ds_support_base_reg ::type_id::create("ll_maintenace_ds_support_reg_seq");   

          ll_maintenace_ds_support_reg_seq.mtusize_0 = mtusize_1;
          ll_maintenace_ds_support_reg_seq.tm_mode_0 = tm_mode_1;
          ll_maintenace_ds_support_reg_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with MAINTENANCE DS  SUPPORT    "),UVM_LOW); end
   endtask

endclass :srio_ll_maintenance_ds_support_reg_seq

//====== ASYMMETRY TO SILENT  ======

class srio_pl_asymm_sl_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_asymm_sl_sm_seq)

    srio_pl_asymm_sl_sm_base_seq pl_asymm_sl_sm_seq; 
  
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_asymm_sl_sm_seq = srio_pl_asymm_sl_sm_base_seq::type_id::create("pl_asymm_sl_sm_seq");
  	
        pl_asymm_sl_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "VIRTUAL SEQUENCE WITH ASYMMETRY TO SILENT"),UVM_LOW); end
  endtask
endclass
//====== 1X RECOVERY TO 1X RETRAIN ======

class srio_pl_1x_rec_1x_retrain_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_1x_rec_1x_retrain_sm_seq)
    srio_pl_1x_rec_1x_retrain_sm_base_seq pl_1x_rec_1x_retrain_sm_seq;   
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_1x_rec_1x_retrain_sm_seq = srio_pl_1x_rec_1x_retrain_sm_base_seq::type_id::create("pl_1x_rec_1x_retrain_sm_seq");
  	
        pl_1x_rec_1x_retrain_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "VIRTUAL SEQUENCE WITH 1X RECOVERY TO 1X RETRAIN "),UVM_LOW); end
  endtask
endclass
//====== NX RECOVERY TO NX RETRAIN ======

class srio_pl_nx_rec_nx_retrain_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_nx_rec_nx_retrain_sm_seq)
    srio_pl_nx_rec_nx_retrain_sm_base_seq pl_nx_rec_nx_retrain_sm_seq;   
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_nx_rec_nx_retrain_sm_seq = srio_pl_nx_rec_nx_retrain_sm_base_seq::type_id::create("pl_nx_rec_nx_retrain_sm_seq");
  	
        pl_nx_rec_nx_retrain_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "VIRTUAL SEQUENCE WITH NX RECOVERY TO NX RETRAIN "),UVM_LOW); end
  endtask
endclass
//====== 2X RECOVERY TO 2X RETRAIN ======

class srio_pl_2x_rec_2x_retrain_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_2x_rec_2x_retrain_sm_seq)
    srio_pl_2x_rec_2x_retrain_sm_base_seq pl_2x_rec_2x_retrain_sm_seq;   
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_2x_rec_2x_retrain_sm_seq = srio_pl_2x_rec_2x_retrain_sm_base_seq::type_id::create("pl_2x_rec_2x_retrain_sm_seq");
  	
        pl_2x_rec_2x_retrain_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "VIRTUAL SEQUENCE WITH 2X RECOVERY TO 2X RETRAIN "),UVM_LOW); end
  endtask
endclass
//====== 2X RETRAIN TO 2X RECOVERY======

class srio_pl_2x_retrain_2x_rec_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_2x_retrain_2x_rec_sm_seq)
    srio_pl_2x_retrain_2x_rec_sm_base_seq pl_2x_retrain_2x_rec_sm_seq;   
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_2x_retrain_2x_rec_sm_seq = srio_pl_2x_retrain_2x_rec_sm_base_seq::type_id::create("pl_2x_retrain_2x_rec_sm_seq");
  	
        pl_2x_retrain_2x_rec_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "VIRTUAL SEQUENCE WITH 2X RETRAIN TO 2X RECOVERY "),UVM_LOW); end
  endtask
endclass
//====== NX RETRAIN TO NX RECOVERY======

class srio_pl_nx_retrain_nx_rec_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_nx_retrain_nx_rec_sm_seq)
    srio_pl_nx_retrain_nx_rec_sm_base_seq pl_nx_retrain_nx_rec_sm_seq;   
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_nx_retrain_nx_rec_sm_seq = srio_pl_nx_retrain_nx_rec_sm_base_seq::type_id::create("pl_nx_retrain_nx_rec_sm_seq");
  	
        pl_nx_retrain_nx_rec_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "VIRTUAL SEQUENCE WITH NX RETRAIN TO NX RECOVERY "),UVM_LOW); end
  endtask
endclass

//====== 1X RETRAIN TO 1X RECOVERY======

class srio_pl_1x_retrain_1x_rec_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_1x_retrain_1x_rec_sm_seq)
    srio_pl_1x_retrain_1x_rec_sm_base_seq pl_1x_retrain_1x_rec_sm_seq;   
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_1x_retrain_1x_rec_sm_seq = srio_pl_1x_retrain_1x_rec_sm_base_seq::type_id::create("pl_1x_retrain_1x_rec_sm_seq");
  	
        pl_1x_retrain_1x_rec_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "VIRTUAL SEQUENCE WITH 1X RETRAIN TO 1X RECOVERY "),UVM_LOW); end
  endtask
endclass

//====== NX MODE TO NX RECOVERY======

class srio_pl_nx_mode_nx_rec_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_nx_mode_nx_rec_sm_seq)
    srio_pl_nx_mode_nx_rec_sm_base_seq pl_nx_mode_nx_rec_sm_seq;   
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_nx_mode_nx_rec_sm_seq = srio_pl_nx_mode_nx_rec_sm_base_seq::type_id::create("pl_nx_mode_nx_rec_sm_seq");
  	
        pl_nx_mode_nx_rec_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "VIRTUAL SEQUENCE WITH NX MODE TO NX RECOVERY "),UVM_LOW); end
  endtask
endclass

//====== NX RECOVERY TO NX MODE======

class srio_pl_nx_rec_nx_mode_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_nx_rec_nx_mode_sm_seq)
    srio_pl_nx_rec_nx_mode_sm_base_seq pl_nx_rec_nx_mode_sm_seq;   
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_nx_rec_nx_mode_sm_seq = srio_pl_nx_rec_nx_mode_sm_base_seq::type_id::create("pl_nx_rec_nx_mode_sm_seq");
  	
        pl_nx_rec_nx_mode_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "VIRTUAL SEQUENCE WITH NX RECOVERY TO NX MODE "),UVM_LOW); end
  endtask
endclass

//====== NX RECOVERY TO 1X MODE LANE 0======

class srio_pl_nx_rec_1x_mode_ln0_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_nx_rec_1x_mode_ln0_sm_seq)
    srio_pl_nx_rec_1x_mode_ln0_sm_base_seq pl_nx_rec_1x_mode_ln0_sm_seq;   
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_nx_rec_1x_mode_ln0_sm_seq = srio_pl_nx_rec_1x_mode_ln0_sm_base_seq::type_id::create("pl_nx_rec_1x_mode_ln0_sm_seq");
  	
        pl_nx_rec_1x_mode_ln0_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "VIRTUAL SEQUENCE WITH NX RECOVERY TO 1X MODE LANE 0 "),UVM_LOW); end
  endtask
endclass

//====== NX RECOVERY TO 1X MODE LANE 1======

class srio_pl_nx_rec_1x_mode_ln1_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_nx_rec_1x_mode_ln1_sm_seq)
    srio_pl_nx_rec_1x_mode_ln1_sm_base_seq pl_nx_rec_1x_mode_ln1_sm_seq;   
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_nx_rec_1x_mode_ln1_sm_seq = srio_pl_nx_rec_1x_mode_ln1_sm_base_seq::type_id::create("pl_nx_rec_1x_mode_ln1_sm_seq");
  	
        pl_nx_rec_1x_mode_ln1_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "VIRTUAL SEQUENCE WITH NX RECOVERY TO 1X MODE LANE 1 "),UVM_LOW); end
  endtask
endclass

//====== NX RECOVERY TO 1X MODE LANE 2======

class srio_pl_nx_rec_1x_mode_ln2_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_nx_rec_1x_mode_ln2_sm_seq)
    srio_pl_nx_rec_1x_mode_ln2_sm_base_seq pl_nx_rec_1x_mode_ln2_sm_seq;   
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_nx_rec_1x_mode_ln2_sm_seq = srio_pl_nx_rec_1x_mode_ln2_sm_base_seq::type_id::create("pl_nx_rec_1x_mode_ln2_sm_seq");
  	
        pl_nx_rec_1x_mode_ln2_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "VIRTUAL SEQUENCE WITH NX RECOVERY TO 1X MODE LANE 2 "),UVM_LOW); end
  endtask
endclass

//====== NX RECOVERY TO SILENT======

class srio_pl_nx_rec_sl_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_nx_rec_sl_sm_seq)
    srio_pl_nx_rec_sl_sm_base_seq pl_nx_rec_sl_sm_seq;   
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_nx_rec_sl_sm_seq = srio_pl_nx_rec_sl_sm_base_seq::type_id::create("pl_nx_rec_sl_sm_seq");
  	
        pl_nx_rec_sl_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "VIRTUAL SEQUENCE WITH NX RECOVERY TO SILENT "),UVM_LOW); end
  endtask
endclass

//====== NX MODE TO ASYMMETRY======

class srio_pl_nx_mode_asymm_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_nx_mode_asymm_sm_seq)
    srio_pl_nx_mode_asymm_sm_base_seq pl_nx_mode_asymm_sm_seq;   
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_nx_mode_asymm_sm_seq = srio_pl_nx_mode_asymm_sm_base_seq::type_id::create("pl_nx_mode_asymm_sm_seq");
  	
        pl_nx_mode_asymm_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "VIRTUAL SEQUENCE WITH NX MODE TO ASYMMETRY "),UVM_LOW); end
  endtask
endclass

//====== 2X MODE TO ASYMMETRY======

class srio_pl_2x_mode_asymm_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_2x_mode_asymm_sm_seq)
    srio_pl_2x_mode_asymm_sm_base_seq pl_2x_mode_asymm_sm_seq;   
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_2x_mode_asymm_sm_seq = srio_pl_2x_mode_asymm_sm_base_seq::type_id::create("pl_2x_mode_asymm_sm_seq");
  	
        pl_2x_mode_asymm_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "VIRTUAL SEQUENCE WITH 2X MODE TO ASYMMETRY "),UVM_LOW); end
  endtask
endclass

//====== 2X RECOVERY TO 2X MODE======

class srio_pl_nx_rec_2x_mode_sm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_nx_rec_2x_mode_sm_seq)
    srio_pl_nx_rec_2x_mode_sm_base_seq pl_nx_rec_2x_mode_sm_seq;   
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
         pl_nx_rec_2x_mode_sm_seq = srio_pl_nx_rec_2x_mode_sm_base_seq::type_id::create("pl_nx_rec_2x_mode_sm_seq");
  	
        pl_nx_rec_2x_mode_sm_seq.start(vseq_pl_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "VIRTUAL SEQUENCE WITH 2X RECOVERY TO 2X MODE "),UVM_LOW); end
  endtask
endclass

//================DATA STREAMING WITH TRAFFIC random stream ID============

class srio_ll_ds_traffic_random_streamid_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_traffic_random_streamid_seq)
    rand bit [7:0] mtusize_1;
    rand bit [15:0] pdu_length_1;
    rand bit [1:0] sel;
    rand bit [15:0] streamID_rand;
    rand bit [7:0] cos_rand;
   srio_ll_ds_traffic_base_seq ll_ds_traffic_base_seq ;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
             sel = $urandom;
             cos_rand = $urandom_range(32'h0000001f,32'h0000001e);
             if (sel == 0)
               streamID_rand = 16'h3f;
             else  if (sel == 1)
               streamID_rand = 16'h4f;
             else if (sel == 2)
               streamID_rand = 16'h5f;
             else
               streamID_rand = 16'hff;
      	repeat(10) begin //{
       ll_ds_traffic_base_seq= srio_ll_ds_traffic_base_seq::type_id::create("ll_ds_traffic_base_seq");
       ll_ds_traffic_base_seq.mtusize_0 =mtusize_1;
       ll_ds_traffic_base_seq.pdulength_0 =pdu_length_1;
       ll_ds_traffic_base_seq.streamID_0 = streamID_rand;
       ll_ds_traffic_base_seq.cos_0 = cos_rand;
       ll_ds_traffic_base_seq.start(vseq_ll_sequencer); 
	 begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with DATA STREAMING SINGLE SEGMENT   "),UVM_LOW); end
  end //}
endtask

endclass :srio_ll_ds_traffic_random_streamid_seq


//================DATA STREAMING WITH TRAFFIC random stream ID and COS ============

class srio_ll_ds_traffic_random_streamid_cos_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_traffic_random_streamid_cos_seq)
    rand bit [7:0] mtusize_1;
    rand bit [15:0] pdu_length_1;
    rand bit [15:0] streamID_rand;
    rand bit [7:0] cos_rand;
   srio_ll_ds_traffic_base_seq ll_ds_traffic_base_seq ;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();

             cos_rand = $urandom;
             streamID_rand = $urandom;
      	repeat(10) begin //{
       ll_ds_traffic_base_seq= srio_ll_ds_traffic_base_seq::type_id::create("ll_ds_traffic_base_seq");
       ll_ds_traffic_base_seq.mtusize_0 =mtusize_1;
       ll_ds_traffic_base_seq.pdulength_0 =pdu_length_1;
       ll_ds_traffic_base_seq.streamID_0 = streamID_rand;
       ll_ds_traffic_base_seq.cos_0 = cos_rand;
       ll_ds_traffic_base_seq.start(vseq_ll_sequencer); 
	 begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with DATA STREAMING SINGLE SEGMENT   "),UVM_LOW); end
  end //}
endtask

endclass :srio_ll_ds_traffic_random_streamid_cos_seq
//================DATA STREAMING WITH all TRAFFIC============

class srio_ll_ds_all_traffic_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_all_traffic_seq)
    rand bit [7:0] mtusize_1;
    rand bit [15:0] pdu_length_1;
   srio_ll_ds_traffic_base_seq ll_ds_traffic_base_seq ;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
      	repeat(10) begin //{
       ll_ds_traffic_base_seq= srio_ll_ds_traffic_base_seq::type_id::create("ll_ds_traffic_base_seq");
       ll_ds_traffic_base_seq.mtusize_0 =mtusize_1;
       ll_ds_traffic_base_seq.pdulength_0 =pdu_length_1;
       ll_ds_traffic_base_seq.streamID_0 =16'h3F;
       ll_ds_traffic_base_seq.pdulength_0 =8'h1F;
  
       ll_ds_traffic_base_seq.start(vseq_ll_sequencer); 
	 begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with DATA STREAMING SINGLE SEGMENT   "),UVM_LOW); end
  end //}
endtask

endclass :srio_ll_ds_all_traffic_seq

//================ TRAFFIC MANAGEMENT FOR CREDIT CONTROL MANAGEMENT  SEQUENCES FOR ALL TRAFFIC============

class srio_ll_ds_all_traffic_mgmt_credit_control_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_all_traffic_mgmt_credit_control_seq)

   rand bit [3:0] TMmode_0;

   srio_ll_ds_traffic_mgmt_credit_based_base_seq ll_ds_traffic_mgmt_credit_control_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
        ll_ds_traffic_mgmt_credit_control_seq   = srio_ll_ds_traffic_mgmt_credit_based_base_seq::type_id::create("ll_ds_traffic_mgmt_credit_control_seq");
  	
        ll_ds_traffic_mgmt_credit_control_seq.xh_0 = 1'b1;
	ll_ds_traffic_mgmt_credit_control_seq.TMOP_0 = TMmode_0;
	ll_ds_traffic_mgmt_credit_control_seq.ftype_0 = 4'h9;	
	ll_ds_traffic_mgmt_credit_control_seq.wild_card_0 = 3'b111;
        ll_ds_traffic_mgmt_credit_control_seq.cos_0 = 8'h1F;
        ll_ds_traffic_mgmt_credit_control_seq.streamID_0 = 16'h3F;
	ll_ds_traffic_mgmt_credit_control_seq.parameter1_0 = $urandom_range(32'd31,32'd16);  
         ll_ds_traffic_mgmt_credit_control_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with TRAFFIC MANAGEMENT FOR CREDIT CONTROL MANAGEMENT SEQUENCE   "),UVM_LOW); end

  endtask

endclass :srio_ll_ds_all_traffic_mgmt_credit_control_seq
//================ TRAFFIC MANAGEMENT FOR CREDIT CONTROL MANAGEMENT  SEQUENCES FOR SPECIFIC DESTINATION TRAFFIC============

class srio_ll_ds_specific_destid_traffic_mgmt_credit_control_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_specific_destid_traffic_mgmt_credit_control_seq)

   rand bit [3:0] TMmode_0;

   srio_ll_ds_traffic_mgmt_credit_based_base_seq ll_ds_traffic_mgmt_credit_control_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
        ll_ds_traffic_mgmt_credit_control_seq   = srio_ll_ds_traffic_mgmt_credit_based_base_seq::type_id::create("ll_ds_traffic_mgmt_credit_control_seq");
  	
        ll_ds_traffic_mgmt_credit_control_seq.xh_0 = 1'b1;
	ll_ds_traffic_mgmt_credit_control_seq.TMOP_0 = TMmode_0;
	ll_ds_traffic_mgmt_credit_control_seq.ftype_0 = 4'h9;	
	ll_ds_traffic_mgmt_credit_control_seq.wild_card_0 = 3'b011;
        ll_ds_traffic_mgmt_credit_control_seq.cos_0 = 8'h1F;
        ll_ds_traffic_mgmt_credit_control_seq.streamID_0 = 16'h3F;
	ll_ds_traffic_mgmt_credit_control_seq.parameter1_0 = $urandom_range(32'd31,32'd16);  
         ll_ds_traffic_mgmt_credit_control_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with TRAFFIC MANAGEMENT FOR CREDIT CONTROL MANAGEMENT SEQUENCE   "),UVM_LOW); end

  endtask

endclass :srio_ll_ds_specific_destid_traffic_mgmt_credit_control_seq

//================ILLEGAL IO SEQUENCE============

class srio_ll_illegal_io_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_illegal_io_seq)

  srio_ll_illegal_io_trans_seq ll_illegal_io_trans_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
    ll_illegal_io_trans_seq = srio_ll_illegal_io_trans_seq::type_id::create("ll_illegal_io_trans_seq");
	ll_illegal_io_trans_seq.start(vseq_ll_sequencer);  
    #100ns;
  endtask

endclass : srio_ll_illegal_io_seq

//================ILLEGAL MSG SEQUENCE============

class srio_ll_illegal_msg_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_illegal_msg_seq)

  srio_ll_illegal_msg_trans_seq ll_illegal_msg_trans_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
    ll_illegal_msg_trans_seq = srio_ll_illegal_msg_trans_seq::type_id::create("ll_illegal_msg_trans_seq");
	ll_illegal_msg_trans_seq.start(vseq_ll_sequencer);  
    #100ns;
  endtask

endclass : srio_ll_illegal_msg_seq

//================ILLEGAL GSM SEQUENCE============

class srio_ll_illegal_gsm_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_illegal_gsm_seq)

  srio_ll_illegal_gsm_trans_seq ll_illegal_gsm_trans_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
    ll_illegal_gsm_trans_seq = srio_ll_illegal_gsm_trans_seq::type_id::create("ll_illegal_gsm_trans_seq");
	ll_illegal_gsm_trans_seq.start(vseq_ll_sequencer);  
    #100ns;
  endtask

endclass : srio_ll_illegal_gsm_seq

//================VC ENABLED DATA STREAMING MULTI SEGMENT ============

class srio_ll_vc_ds_mseg_req_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_vc_ds_mseg_req_seq)
  
   rand bit [7:0] mtusize_1;
   rand bit [15:0] pdu_length_1;
   rand bit vc_1,crf_1; 
   rand bit [1:0] prio_1;
   srio_ll_vc_ds_mseg_req_base_seq ll_vc_ds_mseg_req_seq;

   function new(string name="");
   super.new(name);
   endfunction

  task body();
   super.body();
   repeat (10) begin //{
   ll_vc_ds_mseg_req_seq  =srio_ll_vc_ds_mseg_req_base_seq ::type_id::create("ll_vc_ds_mseg_req_seq");
   ll_vc_ds_mseg_req_seq.mtusize_0 = mtusize_1;
   ll_vc_ds_mseg_req_seq.pdulength_0 = pdu_length_1; 
   ll_vc_ds_mseg_req_seq.vc_0 = vc_1;
   ll_vc_ds_mseg_req_seq.prio_0 = prio_1;
   ll_vc_ds_mseg_req_seq.crf_0  = crf_1;
   ll_vc_ds_mseg_req_seq.start(vseq_ll_sequencer);  
   begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with DATA STREAMING MULTI SEGMENT   "),UVM_LOW); end
   end //}
  endtask

endclass :srio_ll_vc_ds_mseg_req_seq
//================ VC ENABLED LFC XOFF SEQUENCES ============

class srio_ll_vc_lfc_xoff_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_vc_lfc_xoff_seq)

  rand bit [6:0] flowid;
  rand bit vc_1;

  srio_ll_vc_lfc_seq  ll_vc_lfc_xoff_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	
          ll_vc_lfc_xoff_seq   = srio_ll_vc_lfc_seq::type_id::create("ll_vc_lfc_xoff_seq");
  	  ll_vc_lfc_xoff_seq.ftype_0 = 4'h7;
          ll_vc_lfc_xoff_seq.xon_xoff_0 = 1'b0;
	  ll_vc_lfc_xoff_seq.tgtdestID_0 = 32'h1;
	  ll_vc_lfc_xoff_seq.DestinationID_0 =32'hFFFF_FFFF;
	  ll_vc_lfc_xoff_seq.FAM_0 = 3'b000;
	  ll_vc_lfc_xoff_seq.flowID_0 = flowid;
	  ll_vc_lfc_xoff_seq.vc_0 = vc_1;
          ll_vc_lfc_xoff_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with LFC XOFF SEQUENCE   "),UVM_LOW); end

  endtask

endclass :srio_ll_vc_lfc_xoff_seq

//================VC ENABLED LFC XON SEQUENCES ============

class srio_ll_vc_lfc_xon_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_vc_lfc_xon_seq)

  rand bit [6:0] flowid;
  rand bit vc_1;

  srio_ll_vc_lfc_seq  ll_vc_lfc_xon_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	
          ll_vc_lfc_xon_seq   = srio_ll_vc_lfc_seq::type_id::create("ll_vc_lfc_xon_seq");
  	  ll_vc_lfc_xon_seq.ftype_0 = 4'h7;
          ll_vc_lfc_xon_seq.xon_xoff_0 = 1'b1;
	  ll_vc_lfc_xon_seq.tgtdestID_0 = 32'h1;
	  ll_vc_lfc_xon_seq.DestinationID_0 =32'hFFFF_FFFF;
	  ll_vc_lfc_xon_seq.FAM_0 = 3'b000;
	  ll_vc_lfc_xon_seq.flowID_0 = flowid;
	  ll_vc_lfc_xon_seq.vc_0 = vc_1;
          ll_vc_lfc_xon_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with LFC XON SEQUENCE   "),UVM_LOW); end

  endtask

endclass :srio_ll_vc_lfc_xon_seq
//======================= Multi VC NWRITE AND SWRITE SEQUENCE ======================
class srio_ll_multi_vc_nwrite_swrite_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_multi_vc_nwrite_swrite_seq)
  rand bit sel;
  rand bit [1:0] prio_1;
  rand bit crf_1;
  rand bit vc_1;

  srio_ll_multi_vc_nwrite_swrite_base_seq ll_multi_vc_nwrite_swrite_base_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 50 ;i++) begin //{
    ll_multi_vc_nwrite_swrite_base_seq = srio_ll_multi_vc_nwrite_swrite_base_seq::type_id::create("ll_multi_vc_nwrite_swrite_base_seq");
  	sel = $urandom;
    if(sel) 
    ll_multi_vc_nwrite_swrite_base_seq.ftype_0 = 4'h6;
    else
    begin
    ll_multi_vc_nwrite_swrite_base_seq.ftype_0 = 4'h5;
    ll_multi_vc_nwrite_swrite_base_seq.ttype_0 = 4'h4;    
    end
    ll_multi_vc_nwrite_swrite_base_seq.prio_0 = prio_1;
    ll_multi_vc_nwrite_swrite_base_seq.crf_0 = crf_1;
    ll_multi_vc_nwrite_swrite_base_seq.vc_0 = vc_1;
    ll_multi_vc_nwrite_swrite_base_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with Multi VC NWRITE & SWRITE"),UVM_LOW); end
     end //}
  endtask

endclass : srio_ll_multi_vc_nwrite_swrite_seq

//================MESSAGE WITH MULTI SEGMENT - ERROR SCENARIO  ============

class srio_ll_msg_mseg_req_with_err_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_msg_mseg_req_with_err_seq)

  rand bit [3:0] ssize0;
	
  srio_ll_message_req_seq ll_msg_mseg_req_with_err_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 1 ;i++) begin //{
        ll_msg_mseg_req_with_err_seq = srio_ll_message_req_seq ::type_id::create("ll_msg_mseg_req_with_err_seq");

  	ssize0 = $urandom_range(14,9);

        ll_msg_mseg_req_with_err_seq.ftype_0 = 4'hB;
        ll_msg_mseg_req_with_err_seq.ssize_0 = ssize0;

        ll_msg_mseg_req_with_err_seq.message_length_0 = $urandom_range((2**(ssize0-9)*8),1);
        ll_msg_mseg_req_with_err_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with MESSAGE WITH SSIZE 8 BYTES  "),UVM_LOW); end


	end //}
  endtask

endclass :srio_ll_msg_mseg_req_with_err_seq

//================MESSAGE WITH MULTI SEGMENT MAX ============

class srio_ll_msg_mseg_max_req_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_msg_mseg_max_req_seq)

  rand bit [3:0] ssize0;
	
  srio_ll_message_req_seq ll_msg_mseg_max_req_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 1000 ;i++) begin //{
        ll_msg_mseg_max_req_seq = srio_ll_message_req_seq ::type_id::create("ll_msg_mseg_max_req_seq");

  	ssize0 = 9;

        ll_msg_mseg_max_req_seq.ftype_0 = 4'hB;
        ll_msg_mseg_max_req_seq.ssize_0 = ssize0;

        ll_msg_mseg_max_req_seq.message_length_0 = 4096;
        ll_msg_mseg_max_req_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with MESSAGE WITH SSIZE 8 BYTES  "),UVM_LOW); end
   #1ns;
	end //}
  endtask

endclass :srio_ll_msg_mseg_max_req_seq
//================ TRAFFIC MANAGEMENT FOR BASIC STREAM RANDOM MANAGEMENT SEQUENCES ===

class srio_ll_ds_traffic_mgmt_random_basic_stream_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_traffic_mgmt_random_basic_stream_seq)
    rand bit [3:0] TMmode_0;
    rand bit [1:0] mode;
    rand bit [7:0] param1,param2;
    rand bit flag;
    srio_ll_ds_traffic_mgmt_stream_base_seq ll_ds_traffic_mgmt_basic_stream_random_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
        repeat(500) begin //{
	ll_ds_traffic_mgmt_basic_stream_random_seq   = srio_ll_ds_traffic_mgmt_stream_base_seq::type_id::create("ll_ds_traffic_mgmt_basic_stream_random_seq");
        flag = $urandom;
        mode = $urandom_range(32'd2,32'd0);  	
        case(mode) //{
        2'b00 : begin param1 = 8'h0; param2 = flag ? 8'h00 : 8'hFF; end 
        2'b01 : begin param1 = 8'h3; param2 = flag ? 8'h00 : 8'hFF; end 
        2'b10 : begin param1 = 8'h3; param2 = $urandom_range(32'd254,32'd1); end 
        endcase //}


        ll_ds_traffic_mgmt_basic_stream_random_seq.xh_0 = 1'b1;
	ll_ds_traffic_mgmt_basic_stream_random_seq.TMOP_0 = TMmode_0;
	ll_ds_traffic_mgmt_basic_stream_random_seq.ftype_0 = 4'h9;	
	ll_ds_traffic_mgmt_basic_stream_random_seq.wild_card_0 = 3'b0;
	ll_ds_traffic_mgmt_basic_stream_random_seq.parameter1_0 = param1; 	  
	ll_ds_traffic_mgmt_basic_stream_random_seq.parameter2_0 = param2; 	  
	ll_ds_traffic_mgmt_basic_stream_random_seq.cos_0 = 8'h1F; 	  
	ll_ds_traffic_mgmt_basic_stream_random_seq.streamID_0 = 16'h3F; 	  
	ll_ds_traffic_mgmt_basic_stream_random_seq.mask_0 = 8'h0; 
        ll_ds_traffic_mgmt_basic_stream_random_seq.xtype_0 = 3'h0;	  
        ll_ds_traffic_mgmt_basic_stream_random_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with TRAFFIC MANAGEMENT FOR BASIC STREAM  RANDOM MANAGEMENT SEQUENCE   "),UVM_LOW); end
         #1ns;
        end //}
       
  endtask

endclass :srio_ll_ds_traffic_mgmt_random_basic_stream_seq
//================ TRAFFIC MANAGEMENT FOR RATE STREAM RANDOM MANAGEMENT SEQUENCES ===

class srio_ll_ds_traffic_mgmt_random_rate_stream_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_traffic_mgmt_random_rate_stream_seq)
    rand bit [3:0] TMmode_0;
    rand bit [2:0] mode;
    rand bit [7:0] param1,param2;
    rand bit flag;
    srio_ll_ds_traffic_mgmt_stream_base_seq ll_ds_traffic_mgmt_rate_stream_random_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
        repeat(500) begin //{
	ll_ds_traffic_mgmt_rate_stream_random_seq   = srio_ll_ds_traffic_mgmt_stream_base_seq::type_id::create("ll_ds_traffic_mgmt_rate_stream_random_seq");
        flag = $urandom;
        mode = $urandom_range(32'd4,32'd0);  	
        case(mode) //{
        3'b000 : begin param1 = 8'h0; param2 = flag ? 8'h0 : 8'hFF; end 
        3'b001 : begin param1 = flag ? 8'h1 : 8'h5 ; param2 = $urandom_range(32'd255,32'd0);end 
        3'b010 : begin param1 = flag ? 8'h2 : 8'h6 ; param2 = $urandom_range(32'd255,32'd1); end 
        3'b011 : begin param1 = 8'h3; param2 = flag ? 8'h0 : 8'hFF ; end 
        3'b100 : begin param1 = 8'h3; param2 = $urandom_range(32'd254,32'd1);  end 
        endcase //}


        ll_ds_traffic_mgmt_rate_stream_random_seq.xh_0 = 1'b1;
	ll_ds_traffic_mgmt_rate_stream_random_seq.TMOP_0 = TMmode_0;
	ll_ds_traffic_mgmt_rate_stream_random_seq.ftype_0 = 4'h9;	
	ll_ds_traffic_mgmt_rate_stream_random_seq.wild_card_0 = 3'b0;
	ll_ds_traffic_mgmt_rate_stream_random_seq.parameter1_0 = param1; 	  
	ll_ds_traffic_mgmt_rate_stream_random_seq.parameter2_0 = param2; 	  
	ll_ds_traffic_mgmt_rate_stream_random_seq.cos_0 = 8'h1F; 	  
	ll_ds_traffic_mgmt_rate_stream_random_seq.streamID_0 = 16'h3F; 	  
	ll_ds_traffic_mgmt_rate_stream_random_seq.mask_0 = 8'h0; 
        ll_ds_traffic_mgmt_rate_stream_random_seq.xtype_0 = 3'h0;	  
        ll_ds_traffic_mgmt_rate_stream_random_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with TRAFFIC MANAGEMENT FOR RATE STREAM  RANDOM MANAGEMENT SEQUENCE   "),UVM_LOW); end
        #1ns;
        end //}
        
  endtask

endclass :srio_ll_ds_traffic_mgmt_random_rate_stream_seq
//================ TRAFFIC MANAGEMENT FOR CREDIT STREAM RANDOM MANAGEMENT SEQUENCES ===

class srio_ll_ds_traffic_mgmt_random_credit_stream_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_traffic_mgmt_random_credit_stream_seq)
    rand bit [3:0] TMmode_0;
    rand bit [2:0] mode;
    rand bit [7:0] param1,param2;
    rand bit flag;
    srio_ll_ds_traffic_mgmt_stream_base_seq ll_ds_traffic_mgmt_credit_stream_random_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
        repeat(500) begin //{
	ll_ds_traffic_mgmt_credit_stream_random_seq   = srio_ll_ds_traffic_mgmt_stream_base_seq::type_id::create("ll_ds_traffic_mgmt_credit_stream_random_seq");
        flag = $urandom;
        mode = $urandom_range(32'd4,32'd0);  	
        case(mode) //{
        3'b000 : begin param1 = 8'h0; param2 = flag ? 8'h0 : 8'hFF; end 
        3'b001 : begin param1 = $urandom_range(32'd31,32'd16) ; param2 = $urandom_range(32'd255,32'd0);end 
        3'b010 : begin param1 = $urandom_range(32'd47,32'd32) ; param2 = $urandom_range(32'd255,32'd0); end 
        3'b011 : begin param1 = 8'd48; param2 = flag ? 8'h0 : 8'hFF ; end 
        3'b100 : begin param1 = 8'd48; param2 = $urandom_range(32'd254,32'd1);  end 
        endcase //}


        ll_ds_traffic_mgmt_credit_stream_random_seq.xh_0 = 1'b1;
	ll_ds_traffic_mgmt_credit_stream_random_seq.TMOP_0 = TMmode_0;
	ll_ds_traffic_mgmt_credit_stream_random_seq.ftype_0 = 4'h9;	
	ll_ds_traffic_mgmt_credit_stream_random_seq.wild_card_0 = 3'b0;
	ll_ds_traffic_mgmt_credit_stream_random_seq.parameter1_0 = param1; 	  
	ll_ds_traffic_mgmt_credit_stream_random_seq.parameter2_0 = param2; 	  
	ll_ds_traffic_mgmt_credit_stream_random_seq.cos_0 = 8'h1F; 	  
	ll_ds_traffic_mgmt_credit_stream_random_seq.streamID_0 = 16'h3F; 	  
	ll_ds_traffic_mgmt_credit_stream_random_seq.mask_0 = 8'h0; 
        ll_ds_traffic_mgmt_credit_stream_random_seq.xtype_0 = 3'h0;	  
        ll_ds_traffic_mgmt_credit_stream_random_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with TRAFFIC MANAGEMENT FOR CREDIT STREAM  RANDOM MANAGEMENT SEQUENCE   "),UVM_LOW); end
        #1ns;
        end //}
        
  endtask

endclass :srio_ll_ds_traffic_mgmt_random_credit_stream_seq

//================INVALID ATOMIC SEQUENCE============

class srio_ll_atomic_invalid_size_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_atomic_invalid_size_seq)

  srio_ll_atomic_invalid_seq ll_illegal_atomic_trans_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
    super.body();
    ll_illegal_atomic_trans_seq = srio_ll_atomic_invalid_seq::type_id::create("ll_illegal_atomic_trans_seq");
    ll_illegal_atomic_trans_seq.start(vseq_ll_sequencer);  
    #100ns;
  endtask

endclass : srio_ll_atomic_invalid_size_seq
// Data Streaming ERROR Scenario Check

class srio_ll_ds_mseg_req_err_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_mseg_req_err_seq)
  
   rand bit [7:0] mtusize_1;
   rand bit [15:0] pdu_length_1;
 
   srio_ll_ds_mseg_req_base_seq ll_ds_mseg_req_err_seq;

   function new(string name="");
   super.new(name);
   endfunction

  task body();
   super.body();
   ll_ds_mseg_req_err_seq  =srio_ll_ds_mseg_req_base_seq ::type_id::create("ll_ds_mseg_req_err_seq");
   ll_ds_mseg_req_err_seq.mtusize_0 = mtusize_1;
   ll_ds_mseg_req_err_seq.pdulength_0 = pdu_length_1;   
   ll_ds_mseg_req_err_seq.start(vseq_ll_sequencer);  
   begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with DATA STREAMING MULTI SEGMENT   "),UVM_LOW); end

  endtask

endclass : srio_ll_ds_mseg_req_err_seq

//================DATA STREAMING WITH maximum streamID============

class srio_ll_ds_max_streamid_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_max_streamid_seq)
    rand bit [7:0] mtusize_1;
    rand bit [15:0] pdu_length_1;
   srio_ll_ds_traffic_base_seq ll_ds_traffic_base_seq ;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
      	repeat(10) begin //{
       ll_ds_traffic_base_seq= srio_ll_ds_traffic_base_seq::type_id::create("ll_ds_traffic_base_seq");
       ll_ds_traffic_base_seq.mtusize_0 =mtusize_1;
       ll_ds_traffic_base_seq.pdulength_0 =pdu_length_1;
       ll_ds_traffic_base_seq.streamID_0 = 16'hFFFF;
       ll_ds_traffic_base_seq.cos_0 = 8'h1F;
       ll_ds_traffic_base_seq.start(vseq_ll_sequencer); 
	 begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with DATA STREAMING SINGLE SEGMENT   "),UVM_LOW); end
  end //}
endtask

endclass :srio_ll_ds_max_streamid_seq
//======IO RANDOM SEQUENCES FOR PL ===========

class srio_pl_ll_io_random_seq extends srio_virtual_base_seq;

  `uvm_object_utils(srio_pl_ll_io_random_seq)
	
     	
	srio_ll_io_random_base_seq ll_io_random_base_seq;


	function new(string name="");
    	super.new(name);
  	endfunction

	task body();
	super.body();
	
        ll_io_random_base_seq = srio_ll_io_random_base_seq::type_id::create("ll_io_random_base_seq");
  	 
	ll_io_random_base_seq.start(vseq_ll_sequencer);  
	
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  IO RANDOM PACKET "),UVM_LOW); end
    
  endtask

endclass : srio_pl_ll_io_random_seq

class srio_ll_msg_unsupported_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_msg_unsupported_seq)

    rand bit [3:0] ssize0;
    rand bit flag;

    srio_ll_message_req_seq ll_msg_mseg_req_seq;

   function new(string name="");
    super.new(name);
  endfunction

  task body();
    super.body();

    repeat(10) begin //{
      ll_msg_mseg_req_seq = srio_ll_message_req_seq::type_id::create("ll_msg_mseg_req_seq");
      ssize0 = $urandom_range(14,9);
      flag = $urandom;
      ll_msg_mseg_req_seq.ftype_0 = 4'hB;
      ll_msg_mseg_req_seq.ssize_0 = ssize0;
      ll_msg_mseg_req_seq.message_length_0 =flag ? (2**(ssize0-9)) : $urandom_range((16*(2**(ssize0-9))),(2*(2**(ssize0-9))));
      ll_msg_mseg_req_seq.start(vseq_ll_sequencer);
    end //}
  endtask

endclass : srio_ll_msg_unsupported_seq 

class srio_ll_db_unsupported_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_db_unsupported_seq)

    srio_ll_doorbell_seq ll_doorbell_req_seq;

   function new(string name="");
    super.new(name);
  endfunction

  task body();
    super.body();
      ll_doorbell_req_seq =srio_ll_doorbell_seq ::type_id::create("ll_doorbell_req_seq");
      ll_doorbell_req_seq.ftype_0 = 4'hA;
      ll_doorbell_req_seq.start(vseq_ll_sequencer);
  endtask

endclass : srio_ll_db_unsupported_seq

//================ 2^n Outstanding unacknowledged Request ============

class srio_ll_outstanding_unack_req_seq extends srio_virtual_base_seq;
  `uvm_object_utils(srio_ll_outstanding_unack_req_seq)
  rand bit [3:0] ftype_rand;
  rand bit [3:0] ttype_rand;
  rand bit [2:0] sel;
  rand bit a;
  srio_ll_request_class_seq ll_nread_req_seq ;
   
  function new(string name="");
    super.new(name);
  endfunction

 task body();
   super.body();
    sel = $urandom_range(3,0);
    a   = $urandom;
    if(sel == 0)
      begin
        ftype_rand = 2;
        ttype_rand = a ? 4'h4 : $urandom_range(15,12);
      end
    else if(sel == 1)
      begin
        ftype_rand = 5;
        ttype_rand = a ? $urandom_range(5,4) : $urandom_range(14,12);
      end
    else if(sel == 2)
      begin
        ftype_rand = 6;
        ttype_rand = $urandom;
      end
    else if(sel == 3)
      begin
        ftype_rand = 8;
        ttype_rand = $urandom_range(4,0);
      end
     
	for(int i = 0; i < 70 ;i++) begin //{
      ll_nread_req_seq = srio_ll_request_class_seq::type_id::create("ll_nread_req_seq");
  	  ll_nread_req_seq.ftype_0 = ftype_rand;
	  ll_nread_req_seq.ttype_0 = ttype_rand;
	  ll_nread_req_seq.start(vseq_ll_sequencer); 
      begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with REQUEST"),UVM_LOW); end
	   #100ns;
		fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork; 

        end //} 
 	  endtask

endclass : srio_ll_outstanding_unack_req_seq

//================MAINTENANCE READ RESPONSE  ============

class srio_ll_unexp_msg_resp_req_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_unexp_msg_resp_req_seq)

   srio_ll_request_class_seq  ll_msg_resp_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 30 ;i++) begin //{

           ll_msg_resp_seq = srio_ll_request_class_seq ::type_id::create("ll_msg_resp_seq");
  	
        ll_msg_resp_seq.ftype_0 = 4'hb;
    	ll_msg_resp_seq.ttype_0 = 4'h1;
    	ll_msg_resp_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  MAINTENANCE READ RESPONSE"),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

end //}

  endtask

endclass :srio_ll_unexp_msg_resp_req_seq
//================MESSAGE WITH MULTI SEGMENT MAX AND DEFINED MBOX AND LETTER ============

class srio_ll_msg_mseg_max_mbox_letter_req_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_msg_mseg_max_mbox_letter_req_seq)

  rand bit [3:0] ssize0;

  srio_ll_msg_mbox_letter_req_seq ll_msg_mseg_max_req_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 1000 ;i++) begin //{
        ll_msg_mseg_max_req_seq = srio_ll_msg_mbox_letter_req_seq ::type_id::create("ll_msg_mseg_max_req_seq");
    	ssize0 = 9;
        ll_msg_mseg_max_req_seq.ftype_0 = 4'hB;
        ll_msg_mseg_max_req_seq.ssize_0 = ssize0;
        ll_msg_mseg_max_req_seq.mbox_0 = 2'b01;
        ll_msg_mseg_max_req_seq.letter_0 = 2'b10;
        ll_msg_mseg_max_req_seq.message_length_0 = 4096;
        ll_msg_mseg_max_req_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with MESSAGE WITH SSIZE 8 BYTES  "),UVM_LOW); end
   #1ns;
	end //}
  endtask

endclass :srio_ll_msg_mseg_max_mbox_letter_req_seq


//================ REQUEST SEQUENCE ============

class srio_ll_req_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_req_seq)
  
 srio_ll_request_class_seq ll_req_seq ;
   
    function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
    for(int i = 0; i < 800 ;i++) begin //{
       ll_req_seq = srio_ll_request_class_seq::type_id::create("ll_req_seq");
  	   ll_req_seq.ftype_0 = 4'h2;
       ll_req_seq.ttype_0 = 4'h4;
	   ll_req_seq.start(vseq_ll_sequencer); 
        begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  REQUEST SEQUENCE FOR CALLBACK"),UVM_LOW); end
       #100ns;
		fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork; 
        end //} 
 	  endtask

endclass : srio_ll_req_seq

//================GSM REQUEST SEQUENCE============

class srio_ll_gsm_pkt_for_illegal_resp_req_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_gsm_pkt_for_illegal_resp_req_seq)
  rand bit [1:0] sel;
 rand bit [3:0] ttype_rand;

  srio_ll_write_class_seq ll_gsm_pkt_for_illegal_response_req_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 30 ;i++) begin //{
    sel = $urandom_range(32'd3,32'd0);
    if(sel == 0)
      ttype_rand = 3;
    else if(sel == 1)
      ttype_rand = 5;
    else if(sel == 2)
      ttype_rand = 7;
    else if (sel == 3)
      ttype_rand = $urandom_range(32'd11,32'd9);
    ll_gsm_pkt_for_illegal_response_req_seq = srio_ll_write_class_seq::type_id::create("ll_gsm_pkt_for_illegal_response_req_seq");
  	ll_gsm_pkt_for_illegal_response_req_seq.ftype_0 = 4'h2;
	ll_gsm_pkt_for_illegal_response_req_seq.ttype_0 = ttype_rand;
	ll_gsm_pkt_for_illegal_response_req_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  NWRITE_R"),UVM_LOW); end
#100ns;
		fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}
  endtask

endclass : srio_ll_gsm_pkt_for_illegal_resp_req_seq
 //================MESSAGE WITH MULTI SEGMENT  ============

class srio_ll_msg_mseg_req_cov_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_msg_mseg_req_cov_seq)
	
  srio_ll_message_cov_req_seq ll_msg_mseg_req_cov_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
      for(int seg_size = 9; seg_size <= 14; seg_size = seg_size + 1) begin //{
        for(int msglen = 1; msglen <= 16; msglen = msglen + 1) begin //{
          for(int letter = 0; letter <= 3; letter = letter + 1) begin //{
            for(int mbox = 0; mbox <= 3; mbox = mbox + 1) begin //{
              ll_msg_mseg_req_cov_seq = srio_ll_message_cov_req_seq ::type_id::create("ll_msg_mseg_req_seq");
              ll_msg_mseg_req_cov_seq.ftype_0 = 4'hB;
              ll_msg_mseg_req_cov_seq.ssize_0 = seg_size;
              ll_msg_mseg_req_cov_seq.message_length_0 = msglen;
              ll_msg_mseg_req_cov_seq.mbox_0 = mbox;
              ll_msg_mseg_req_cov_seq.letter_0 = letter;
              ll_msg_mseg_req_cov_seq.start(vseq_ll_sequencer);  
              #10ns;
            end //}
          end //}
        end //}
      end //}
  endtask

endclass :srio_ll_msg_mseg_req_cov_seq
 
// Invalid TT Sequence

class srio_ll_pkt_invalid_tt_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_pkt_invalid_tt_seq)

  srio_ll_pkt_invalid_tt_base_seq ll_pkt_invalid_tt_seq;
   
  function new(string name="");
   super.new(name);
  endfunction

  task body();
	super.body();
          repeat(5) begin //{ 
            ll_pkt_invalid_tt_seq = srio_ll_pkt_invalid_tt_base_seq::type_id::create("ll_pkt_invalid_tt_seq");
	    ll_pkt_invalid_tt_seq.start(vseq_ll_sequencer);    
          end //}
 	  endtask

endclass : srio_ll_pkt_invalid_tt_seq

class srio_txrx_seq extends srio_virtual_base_seq;

    `uvm_object_utils(srio_txrx_seq)

     rand bit [0:11] ackid_1;
     rand bit [0:11] param_value_0;

     srio_txrx_base_seq pl_sts_cs_seq;

      function new(string name="");
      super.new(name);
       endfunction

  task body();
        super.body();

        pl_sts_cs_seq =srio_txrx_base_seq ::type_id::create("pl_sts_cs_seq");

//       //env_config.pl_config.pkt_acc_gen_kind = PL_DISABLED;
      for(int cnt=0; cnt<16; cnt++) 
      begin
        pl_sts_cs_seq.start(vseq_pl_sequencer);
        #100ns;
        begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence for TXRX STS CTRL SYMBOLS"),UVM_LOW); end
      end
        //end //}
  endtask

endclass : srio_txrx_seq
//======SOP -- NWRITE -- EOP======
class srio_pl_sop_nwrite_eop_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_sop_nwrite_eop_seq)
   rand bit [0:11] param_value_0;   
   srio_pl_nwrite_swrite_class_base_seq pl_nwrite_swrite_class_base_seq ;
   srio_pl_control_symbol_packet_base_seq pl_control_symbol_packet_base_seq1;	
   srio_pl_control_symbol_packet_base_seq pl_control_symbol_packet_base_seq2;
   function new(string name="");
   super.new(name);
   endfunction

  task body();
    super.body();

       pl_control_symbol_packet_base_seq1 =srio_pl_control_symbol_packet_base_seq ::type_id::create("pl_control_symbol_packet_base_seq1");
       pl_control_symbol_packet_base_seq1.stype0_1 = 4'd4;
       pl_control_symbol_packet_base_seq1.stype1_1 = 4'd0;
       pl_control_symbol_packet_base_seq1.param0_1  = 6'd0;
       pl_control_symbol_packet_base_seq1.param1_1  = param_value_0;
       pl_control_symbol_packet_base_seq1.cmd_1  = 3'd0;
       pl_control_symbol_packet_base_seq1.brc3_stype1_msb_1  = 2'b10;
       pl_control_symbol_packet_base_seq1.delimiter_1 = 8'h7c;
       pl_control_symbol_packet_base_seq1.start(vseq_pl_sequencer);  
       begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with SOP "),UVM_LOW); end

       pl_nwrite_swrite_class_base_seq = srio_pl_nwrite_swrite_class_base_seq::type_id::create("pl_nwrite_swrite_class_base_seq");        
       pl_nwrite_swrite_class_base_seq.start(vseq_pl_sequencer); 
       begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  NWRITE"),UVM_LOW); end
       pl_control_symbol_packet_base_seq2 =srio_pl_control_symbol_packet_base_seq ::type_id::create("pl_control_symbol_packet_base_seq2");
               
       pl_control_symbol_packet_base_seq2.stype0_1 = 4'd4;
       pl_control_symbol_packet_base_seq2.stype1_1 = 4'd2;
       pl_control_symbol_packet_base_seq2.param0_1  = 6'd0;
       pl_control_symbol_packet_base_seq2.param1_1  = param_value_0;
       pl_control_symbol_packet_base_seq2.cmd_1  = 3'd0;
       pl_control_symbol_packet_base_seq2.brc3_stype1_msb_1  = 2'b00;
       pl_control_symbol_packet_base_seq2.delimiter_1 = 8'h7c;
       if(env_config.srio_mode==SRIO_GEN30)
        begin//{
         pl_control_symbol_packet_base_seq2.stype1_1 = 4'd2;
         pl_control_symbol_packet_base_seq2.cmd_1  = 3'd0;
        end//}
       pl_control_symbol_packet_base_seq2.start(vseq_pl_sequencer);         
       begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with EOP"),UVM_LOW); end
  endtask

endclass : srio_pl_sop_nwrite_eop_seq

//======GEN 3 SOP PADDED======
class srio_pl_gen3_sop_padded_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_gen3_sop_padded_seq)
     rand bit [0:11] param_value_0;   
     srio_pl_control_symbol_packet_base_seq pl_control_symbol_packet_base_seq;	
     function new(string name="");
   super.new(name);
   endfunction

  task body();
    super.body();

       pl_control_symbol_packet_base_seq =srio_pl_control_symbol_packet_base_seq ::type_id::create("pl_control_symbol_packet_base_seq");
       pl_control_symbol_packet_base_seq.stype0_1 = 4'd4;
       pl_control_symbol_packet_base_seq.stype1_1 = 4'd0;
       pl_control_symbol_packet_base_seq.param0_1  = 6'd0;
       pl_control_symbol_packet_base_seq.param1_1  = param_value_0;
       pl_control_symbol_packet_base_seq.cmd_1  = 3'd0;
       pl_control_symbol_packet_base_seq.brc3_stype1_msb_1  = 2'b11;
       pl_control_symbol_packet_base_seq.delimiter_1 = 8'h1c;
       pl_control_symbol_packet_base_seq.start(vseq_pl_sequencer);  
       begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with SOP PADDED"),UVM_LOW); end
  endtask
endclass :srio_pl_gen3_sop_padded_seq
//======GEN 3 EOP PADDED======
class srio_pl_gen3_eop_padded_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_gen3_eop_padded_seq)
     rand bit [0:11] param_value_0;   
     srio_pl_control_symbol_packet_base_seq pl_control_symbol_packet_base_seq;	
     function new(string name="");
   super.new(name);
   endfunction

  task body();
    super.body();

       pl_control_symbol_packet_base_seq =srio_pl_control_symbol_packet_base_seq ::type_id::create("pl_control_symbol_packet_base_seq");
       pl_control_symbol_packet_base_seq.stype0_1 = 4'd4;
       pl_control_symbol_packet_base_seq.stype1_1 = 4'd2;
       pl_control_symbol_packet_base_seq.param0_1  = 6'd0;
       pl_control_symbol_packet_base_seq.param1_1  = param_value_0;
       pl_control_symbol_packet_base_seq.cmd_1  = 3'd1;
       pl_control_symbol_packet_base_seq.brc3_stype1_msb_1  = 2'b00;
       pl_control_symbol_packet_base_seq.delimiter_1 = 8'h1c;
       pl_control_symbol_packet_base_seq.start(vseq_pl_sequencer);  
       begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with EOP PADDED"),UVM_LOW); end
  endtask
endclass :srio_pl_gen3_eop_padded_seq

//======USER GENERATE SEQUENCES WITH MULTI VC SUPPORT===========

class srio_ll_vc_user_gen_seq extends srio_virtual_base_seq;

  `uvm_object_utils(srio_ll_vc_user_gen_seq)
	
     	rand bit [1:0] prior;
        rand bit crf_1; 
        rand bit vc_1;
	srio_ll_vc_user_gen_base_seq ll_user_gen_base_seq;


	function new(string name="");
    	super.new(name);
  	endfunction

	task body();
	super.body();
	repeat(50) begin //{
     
        ll_user_gen_base_seq = srio_ll_vc_user_gen_base_seq::type_id::create("ll_user_gen_base_seq");
  	
        ll_user_gen_base_seq.prio_0 = prior;
        ll_user_gen_base_seq.crf_0 =crf_1;
        ll_user_gen_base_seq.vc_0 =vc_1;    
	ll_user_gen_base_seq.start(vseq_ll_sequencer);  
       	
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  USER GENERATE PACKET "),UVM_LOW); end
     end //}
  endtask

endclass : srio_ll_vc_user_gen_seq

//================LFC  XON/XOFF USER GENERATE SEQUENCES with multi vc support============

class srio_ll_vc_lfc_user_gen_xoff_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_vc_lfc_user_gen_xoff_seq)
   rand bit [6:0] flowid;
   rand bit vc_1;
  srio_ll_multi_vc_lfc_seq  ll_lfc_xoff_seq ;
  

  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
       	for(int i = 0; i < 1 ;i++) begin //{

          ll_lfc_xoff_seq  = srio_ll_multi_vc_lfc_seq::type_id::create("ll_lfc_xoff_seq");
          
	  ll_lfc_xoff_seq.ftype_0 = 4'h7;
          ll_lfc_xoff_seq.xon_xoff_0 = 1'b0;
	  ll_lfc_xoff_seq.tgtdestID_0 = 32'h2;
	  ll_lfc_xoff_seq.DestinationID_0 = 32'hFFFF_FFFF;
	  ll_lfc_xoff_seq.FAM_0 = 3'b0;
	  ll_lfc_xoff_seq.flowID_0 = flowid;
	  ll_lfc_xoff_seq.vc_0 = vc_1;

          ll_lfc_xoff_seq.start(vseq_ll_sequencer);
	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with LFC XOFF SEQUENCE   "),UVM_LOW); end
	end //}
	endtask
endclass :srio_ll_vc_lfc_user_gen_xoff_seq

//================LFC  XON/XOFF USER GENERATE SEQUENCES with multi vc support ============

class srio_ll_vc_lfc_user_gen_xon_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_vc_lfc_user_gen_xon_seq)
   rand bit [6:0] flowid;
   rand bit vc_1;

  srio_ll_multi_vc_lfc_seq  ll_lfc_xon_seq ;
  

  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
       	for(int i = 0; i < 1 ;i++) begin //{

          ll_lfc_xon_seq  = srio_ll_multi_vc_lfc_seq::type_id::create("ll_lfc_xon_seq");
          
	  ll_lfc_xon_seq.ftype_0 = 4'h7;
          ll_lfc_xon_seq.xon_xoff_0 = 1'b1;
	  ll_lfc_xon_seq.tgtdestID_0 = 32'h2;
	  ll_lfc_xon_seq.DestinationID_0 = 32'hFFFF_FFFF;
	  ll_lfc_xon_seq.FAM_0 = 3'b0;
	  ll_lfc_xon_seq.flowID_0 =flowid ;
	  ll_lfc_xon_seq.vc_0 = vc_1 ;

          ll_lfc_xon_seq.start(vseq_ll_sequencer);
	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with LFC XON SEQUENCE   "),UVM_LOW); end
	end //}
	endtask
endclass :srio_ll_vc_lfc_user_gen_xon_seq

//================ATOMIC REQUEST SEQUENCE with Address specific ============

class srio_ll_atomic_req_with_addr_seq extends srio_virtual_base_seq;

    `uvm_object_utils(srio_ll_atomic_req_with_addr_seq)

  srio_ll_atomic_req_with_addr_base_seq ll_atomic_req_with_addr_base_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 1 ;i++) begin //{
        ll_atomic_req_with_addr_base_seq = srio_ll_atomic_req_with_addr_base_seq::type_id::create("ll_atomic_req_with_addr_base_seq");
  	    ll_atomic_req_with_addr_base_seq.rdsize_1= 4'h8;
        ll_atomic_req_with_addr_base_seq.wrsize_1= 4'h8;
        ll_atomic_req_with_addr_base_seq.wdptr_0= 1'h0;
        ll_atomic_req_with_addr_base_seq.address_0=29'h0000_0009 ; 

	    ll_atomic_req_with_addr_base_seq.start(vseq_ll_sequencer); 
    end //} 
  endtask

endclass : srio_ll_atomic_req_with_addr_seq


//================REQUEST SEQUENCE with Address specific ============

class srio_ll_req_with_addr_seq extends srio_virtual_base_seq;

    `uvm_object_utils(srio_ll_req_with_addr_seq)

  srio_ll_req_with_addr_base_seq ll_req_with_addr_base_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 5 ;i++) begin //{
        ll_req_with_addr_base_seq = srio_ll_req_with_addr_base_seq::type_id::create("ll_req_with_addr_base_seq");
  	    ll_req_with_addr_base_seq.rdsize_1= 4'h8;
        ll_req_with_addr_base_seq.wrsize_1= 4'h8;
        ll_req_with_addr_base_seq.wdptr_0= 1'h0;
        ll_req_with_addr_base_seq.address_0=29'h0000_0009 ; 

	    ll_req_with_addr_base_seq.start(vseq_ll_sequencer); 
    end //} 
  endtask

endclass : srio_ll_req_with_addr_seq

//======IO RANDOM SEQUENCES with specific src_tid ===========

class srio_ll_io_random_speci_src_tid_seq extends srio_virtual_base_seq;

  `uvm_object_utils(srio_ll_io_random_speci_src_tid_seq)
	
     	
	srio_ll_io_random_req_base_seq ll_io_random_base_seq;


	function new(string name="");
    	super.new(name);
  	endfunction

	task body();
	super.body();
	repeat(10) begin //{
     
        ll_io_random_base_seq = srio_ll_io_random_req_base_seq::type_id::create("ll_io_random_base_seq");
  	 
	ll_io_random_base_seq.start(vseq_ll_sequencer);  
	
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  IO RANDOM PACKET "),UVM_LOW); end
    #1ns;
     end //}
  endtask

endclass : srio_ll_io_random_speci_src_tid_seq

//================MESSAGE  DEFINED MBOX AND LETTER ============

class srio_ll_msg_same_mbox_letter_req_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_msg_same_mbox_letter_req_seq)

  rand bit [3:0] ssize0;

  srio_ll_msg_same_mbox_letter_req_base_seq ll_msg_mseg_max_req_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 1 ;i++) begin //{
        ll_msg_mseg_max_req_seq = srio_ll_msg_same_mbox_letter_req_base_seq ::type_id::create("ll_msg_mseg_max_req_seq");
        env_config.ll_config.interleaved_pkt = TRUE ;
        ll_msg_mseg_max_req_seq.ftype_0 = 4'hB;
        ll_msg_mseg_max_req_seq.mbox_0 = 2'b01;
        ll_msg_mseg_max_req_seq.letter_0 = 2'b10;
        ll_msg_mseg_max_req_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with MESSAGE WITH  DEFINED MBOX AND LETTER  "),UVM_LOW); end
   #1ns;
	end //}
  endtask

endclass :srio_ll_msg_same_mbox_letter_req_seq

//================DATA STREAMING MULTI SEGMENT WITH SPECIFIC COS FIELD ============

class srio_ll_ds_mseg_with_speci_cos_req_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_ds_mseg_with_speci_cos_req_seq)
  
   rand bit [7:0] mtusize_1;
   rand bit [15:0] pdu_length_1;
 
   srio_ll_ds_mseg_with_speci_cos_req_base_seq ll_ds_mseg_req_seq;

   function new(string name="");
   super.new(name);
   endfunction

  task body();
   super.body();
   ll_ds_mseg_req_seq  =srio_ll_ds_mseg_with_speci_cos_req_base_seq ::type_id::create("ll_ds_mseg_req_seq");
   ll_ds_mseg_req_seq.start(vseq_ll_sequencer);  
   begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with DATA STREAMING MULTI SEGMENT  WITH SPECIFIC COS"),UVM_LOW); end
  endtask

endclass :srio_ll_ds_mseg_with_speci_cos_req_seq

//================RANDOM SEQUENCE for Default Reset============

class srio_ll_default_reset_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_default_reset_seq)

    rand bit [7:0] mtusize_1;
    rand bit [3:0] TMmode_0; 
    srio_ll_default_reset_base_seq ll_default_seq;

   function new(string name="");
    super.new(name);
  endfunction

  task body();
         super.body();
         
          repeat(200) begin //{ 
          ll_default_seq = srio_ll_default_reset_base_seq::type_id::create("ll_default_seq");
          ll_default_seq.mtusize_0 = mtusize_1; 
          ll_default_seq.TMOP_0 = TMmode_0;                  
          ll_default_seq.start(vseq_ll_sequencer);
 
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with Random Value"),UVM_LOW); end
  end //}
   #1ns;
  endtask

endclass : srio_ll_default_reset_seq

//=======PL SEQUENCES to produce control symbols ===================

class srio_pl_pkt_acc_status_cs_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_pl_pkt_acc_status_cs_seq)
     rand bit [3:0] stype0_2;
	 rand bit [0:11] ackid_1;
         rand bit [0:11] param_value_0;

        srio_pl_control_base_seq pl_pkt_acc_cs_seq;

      function new(string name="");
      super.new(name);
       endfunction

  task body();
	super.body();
 	
    pl_pkt_acc_cs_seq =srio_pl_control_base_seq ::type_id::create("pl_pkt_acc_cs_seq");
  	
    //env_config.pl_config.pkt_acc_gen_kind = PL_DISABLED;
    pl_pkt_acc_cs_seq.stype0_1 = stype0_2;
	pl_pkt_acc_cs_seq.param0_1  = ackid_1;
	pl_pkt_acc_cs_seq.param1_1  = param_value_0;
	pl_pkt_acc_cs_seq.start(vseq_pl_sequencer);  
	
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with PACKET ACCEPTED CONTROL SYMBOLS SEQUENCE"),UVM_LOW); end
	//end //}
  endtask

endclass : srio_pl_pkt_acc_status_cs_seq

//================RANDOM SEQUENCE for Standalone setup============

class srio_ll_standalone_default_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_standalone_default_seq)

    rand bit [7:0] mtusize_1;
    srio_ll_standalone_default_class_seq ll_default_seq;

   function new(string name="");
    super.new(name);
  endfunction

  task body();
         super.body();
         
          repeat(2000) begin //{ 
          ll_default_seq = srio_ll_standalone_default_class_seq::type_id::create("ll_default_seq");
          ll_default_seq.mtusize_0 = mtusize_1; 
          ll_default_seq.start(vseq_ll_sequencer);
 
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with Random Value"),UVM_LOW); end
  end //}
   #1ns;
  endtask

endclass : srio_ll_standalone_default_seq

//================NREAD STANDALONE============

class srio_ll_standalone_nread_req_seq extends srio_virtual_base_seq;
int num_of_pkt_0;
 `uvm_object_utils(srio_ll_standalone_nread_req_seq)
  
 srio_ll_request_class_seq ll_nread_req_seq ;
   
function new(string name="");
  super.new(name);
endfunction

  task body();
	super.body();
	for(int i = 0; i < num_of_pkt_0 ;i++) begin //{
      ll_nread_req_seq = srio_ll_request_class_seq::type_id::create("ll_nread_req_seq");
      ll_nread_req_seq.ftype_0 = 4'h2;
	  ll_nread_req_seq.ttype_0 = 4'h4;
      ll_nread_req_seq.start(vseq_ll_sequencer); 
      begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  NREAD"),UVM_LOW); end
	  end //} 
  endtask
endclass : srio_ll_standalone_nread_req_seq
//================ Standalone NWRITE SEQUENCE============
class srio_ll_standalone_nwrite_req_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_standalone_nwrite_req_seq)
  srio_ll_write_class_seq ll_nwrite_req_seq;
  function new(string name="");
    super.new(name);
  endfunction
  task body();
	super.body();
       	for(int i = 0; i < 1000 ;i++) begin //{
        ll_nwrite_req_seq = srio_ll_write_class_seq::type_id::create("ll_nwrite_req_seq");
        ll_nwrite_req_seq.ftype_0 = 4'h5;
	    ll_nwrite_req_seq.ttype_0 = 4'h4;
        ll_nwrite_req_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  NWRITE"),UVM_LOW); end
    #100ns;
    end //}
  endtask
endclass : srio_ll_standalone_nwrite_req_seq


//================MAINTENANCE WRITE with config offset  ============

class srio_ll_maintenance_wr_reg_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_maintenance_wr_reg_seq)
  rand bit [20:0] config_offset_1 ;
  srio_ll_maintenance_req_config_seq ll_maintenance_wr_req_seq ;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 1 ;i++) begin //{
          ll_maintenance_wr_req_seq  = srio_ll_maintenance_req_config_seq ::type_id::create("ll_maintenance_wr_req_seq");
  	
        ll_maintenance_wr_req_seq.ftype_0 = 4'h8;
	    ll_maintenance_wr_req_seq.ttype_0 = 4'h1;
	    ll_maintenance_wr_req_seq.config_offset_0 = config_offset_1;

	ll_maintenance_wr_req_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  MAINTENANCE WRITE"),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

end //}

  endtask

endclass :srio_ll_maintenance_wr_reg_seq

//================NREAD with  variable number of packets============

class srio_ll_nread_req_num_pkt_seq extends srio_virtual_base_seq;
 
 `uvm_object_utils(srio_ll_nread_req_num_pkt_seq)
  
 srio_ll_request_class_seq ll_nread_req_seq ;

 int num_pkt;
   
    function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	 
	for(int i = 0; i < num_pkt ;i++) begin //{
       ll_nread_req_seq = srio_ll_request_class_seq::type_id::create("ll_nread_req_seq");
       ll_nread_req_seq.ftype_0 = 4'h2;
   	   ll_nread_req_seq.ttype_0 = 4'h4;
	       
       ll_nread_req_seq.start(vseq_ll_sequencer); 
        begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  NREAD"),UVM_LOW); end
	        end //} 
   endtask

endclass : srio_ll_nread_req_num_pkt_seq

//================MAINTENANCE WRITE with config offset to configure PLTOCCSR-lower & PRTOCCSR-higer value ============

class srio_ll_maintenance_wr_timeout_reg_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_maintenance_wr_timeout_reg_seq)
  rand bit [20:0] config_offset_1 ;
  srio_ll_maintenance_req_timeout_config_seq ll_maintenance_wr_req_seq ;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 1 ;i++) begin //{
          ll_maintenance_wr_req_seq  = srio_ll_maintenance_req_timeout_config_seq ::type_id::create("ll_maintenance_wr_req_seq");
  	
        ll_maintenance_wr_req_seq.ftype_0 = 4'h8;
	    ll_maintenance_wr_req_seq.ttype_0 = 4'h1;
	    ll_maintenance_wr_req_seq.config_offset_0 = config_offset_1;

	ll_maintenance_wr_req_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  MAINTENANCE WRITE"),UVM_LOW); end
#100ns;

	fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

end //}

  endtask

endclass :srio_ll_maintenance_wr_timeout_reg_seq

//================MAINTENANCE READ RESPONSE  ============

class srio_ll_nwrite_r_usr_resp_vseq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_nwrite_r_usr_resp_vseq)

   srio_ll_nwrite_r_usr_resp_seq  ll_nwrite_r_usr_resp_seq;
   bit [3:0] num_of_pkt_0;
   int targetID_Info_1;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < num_of_pkt_0 ;i++) begin //{

    ll_nwrite_r_usr_resp_seq = srio_ll_nwrite_r_usr_resp_seq ::type_id::create("ll_nwrite_r_usr_resp_seq");
    ll_nwrite_r_usr_resp_seq.ftype_0 = 4'hd;
    ll_nwrite_r_usr_resp_seq.targetID_Info_0 = i;
	ll_nwrite_r_usr_resp_seq.start(vseq_ll_sequencer);  

end //}

  endtask

endclass :srio_ll_nwrite_r_usr_resp_vseq

//================ nwrite wrsize and wdptr user defined============
class srio_ll_nwrite_wrsize_wdptr_req_seq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_nwrite_wrsize_wdptr_req_seq)
 srio_ll_request_wrsize_wdptr_class_seq ll_nwrite_req_seq ;
    function new(string name="");
    super.new(name);
  endfunction
  task body();
	super.body();
	for(int i = 0; i < 1 ;i++) begin //{
         ll_nwrite_req_seq = srio_ll_request_wrsize_wdptr_class_seq::type_id::create("ll_nwrite_req_seq");
        ll_nwrite_req_seq.ftype_0 = 4'h5;
	    ll_nwrite_req_seq.ttype_0 = 4'h4;
          ll_nwrite_req_seq.start(vseq_ll_sequencer); 
        begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  NWRITE"),UVM_LOW); end
	        end //} 
 	  endtask
endclass : srio_ll_nwrite_wrsize_wdptr_req_seq

//================== nwrite nread case with payaload print callback 
class srio_ll_nwrite_nread_pld_print_cb_vseq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_nwrite_nread_pld_print_cb_vseq)

  srio_ll_nwrite_nread_pld_print_cb_seq ll_nwrite_nread_pld_print_cb_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 10 ;i++) begin //{
        ll_nwrite_nread_pld_print_cb_seq = srio_ll_nwrite_nread_pld_print_cb_seq::type_id::create("ll_nwrite_nread_pld_print_cb_seq");
  	    ll_nwrite_nread_pld_print_cb_seq.rdsize_1= 4'hb;
        ll_nwrite_nread_pld_print_cb_seq.wrsize_1= 4'hb;
        ll_nwrite_nread_pld_print_cb_seq.wdptr_0= 1'h0;
        ll_nwrite_nread_pld_print_cb_seq.address_0=29'h1000_0000 ; 

	ll_nwrite_nread_pld_print_cb_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  NWRITE_R and NREAD_R"),UVM_LOW); end
#100ns;
		fork //{
		begin  //{
		wait(env_config.ll_config.bfm_tx_pkt_cnt == env_config.ll_config.tx_mon_tot_pkt_rcvd);
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Matched of Value i  %d is ",i),UVM_LOW); end
		
		end  //}

		begin //{
		#25000ns;
		begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf("Virtual Sequence -- Packet Count Does Not Matched of Value i  %d is ",i),UVM_LOW); end
	
		end //}
	join_any //}
	disable fork;

	end //}
  endtask

endclass : srio_ll_nwrite_nread_pld_print_cb_vseq
//================MESSAGE WITH MULTI SEGMENT  For RAB UVM setup============

class srio_rab_ll_msg_mseg_req_seq extends srio_virtual_base_seq;
  `uvm_object_utils(srio_rab_ll_msg_mseg_req_seq)
  rand bit [3:0] letter_1;
  rand bit [3:0] mbox_1;

	
  srio_ll_rab_message_req_seq ll_msg_mseg_req_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i < 20 ;i++) begin //{
        ll_msg_mseg_req_seq = srio_ll_rab_message_req_seq ::type_id::create("ll_msg_mseg_req_seq");

        ll_msg_mseg_req_seq.ftype_0 = 4'hB;
        ll_msg_mseg_req_seq.letter_0 = letter_1;
        ll_msg_mseg_req_seq.mbox_0 = mbox_1;
        ll_msg_mseg_req_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with MESSAGE WITH SSIZE 8 BYTES  "),UVM_LOW); end

    #1ns;

	end //}
  endtask

endclass :srio_rab_ll_msg_mseg_req_seq
//================DATA STREAMING WITH INTERLEAVED  ============

class srio_ll_rab_ds_interleaved_seq extends srio_virtual_base_seq;
   `uvm_object_utils(srio_ll_rab_ds_interleaved_seq)
    
   rand bit [7:0] mtusize_1;
   rand bit [15:0] pdu_length_1;
   bit [7:0] cos_1;
   bit [15:0] srcid_1;

   srio_ll_rab_ds_interleaved_base_seq ll_ds_interleaved_seq ;

   function new(string name="");
    super.new(name);
   endfunction

   task body();
   super.body();
   repeat (5) begin //{   	
   ll_ds_interleaved_seq  = srio_ll_rab_ds_interleaved_base_seq ::type_id::create("ll_ds_interleaved_seq");

    ll_ds_interleaved_seq.mtusize_0 = mtusize_1;
    ll_ds_interleaved_seq.pdulength_0= pdu_length_1;
    ll_ds_interleaved_seq.cos_0= cos_1;
    ll_ds_interleaved_seq.srcid_0= srcid_1;

    ll_ds_interleaved_seq.start(vseq_ll_sequencer); 
    begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with DATA STREAMING WITH INTERLEAVED  "),UVM_LOW); end
    #1ns;
    end //}	
  endtask

endclass :srio_ll_rab_ds_interleaved_seq

//========= NWRITE WITH MAXIMUM 256 BYTES SEQUENCE =========

class srio_ll_nwrite_max_pkt_size_class_vseq extends srio_virtual_base_seq;
    `uvm_object_utils(srio_ll_nwrite_max_pkt_size_class_vseq)
  
 srio_ll_nwrite_max_pkt_size_class_seq ll_nwrite_req_seq ;
   
    function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
    
	 
	for(int i = 0; i < 5 ;i++) begin //{
         ll_nwrite_req_seq = srio_ll_nwrite_max_pkt_size_class_seq::type_id::create("ll_nwrite_req_seq");
  	
       
        ll_nwrite_req_seq.ftype_0 = 4'h5;
	    ll_nwrite_req_seq.ttype_0 = 4'h4;
	       
          ll_nwrite_req_seq.start(vseq_ll_sequencer); 
        begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  NWRITE"),UVM_LOW); end
	        end //} 
 	  endtask

endclass : srio_ll_nwrite_max_pkt_size_class_vseq


class srio_ll_msg_same_letter_mbox_diff_src_id_vseq extends srio_virtual_base_seq;
  `uvm_object_utils(srio_ll_msg_same_letter_mbox_diff_src_id_vseq)
  rand bit [3:0] letter_1;
  rand bit [3:0] mbox_1;
  rand bit [31:0] SourceID_1;
  rand bit [3:0] ssize_1;
  rand bit [3:0] msg_len_1;
  int message_length_1;

	
  srio_ll_msg_same_letter_mbox_diff_src_id_seq ll_msg_same_letter_mbox_diff_src_id_seq;
  function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
        ll_msg_same_letter_mbox_diff_src_id_seq = srio_ll_msg_same_letter_mbox_diff_src_id_seq ::type_id::create("ll_msg_same_letter_mbox_diff_src_id_seq");

        ll_msg_same_letter_mbox_diff_src_id_seq.ftype_0 = 4'hB;
        ll_msg_same_letter_mbox_diff_src_id_seq.letter_0 = letter_1;
        ll_msg_same_letter_mbox_diff_src_id_seq.mbox_0 = mbox_1;
        ll_msg_same_letter_mbox_diff_src_id_seq.SourceID_0 = SourceID_1;
        ll_msg_same_letter_mbox_diff_src_id_seq.ssize_0 = ssize_1;
        ll_msg_same_letter_mbox_diff_src_id_seq.msg_len_0  = msg_len_1;
        ll_msg_same_letter_mbox_diff_src_id_seq.message_length_0  = message_length_1;
        ll_msg_same_letter_mbox_diff_src_id_seq.start(vseq_ll_sequencer);  
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "srio_ll_msg_same_letter_mbox_diff_src_id_vseq  "),UVM_LOW); end

    #1ns;

  endtask

endclass :srio_ll_msg_same_letter_mbox_diff_src_id_vseq

//================ REQUEST SEQUENCE FOR NREAD NWRITE SWRITE NWRITE_R ============

class srio_ll_rand_write_read_vseq extends srio_virtual_base_seq;
  int no_of_pkt;
    `uvm_object_utils(srio_ll_rand_write_read_vseq)
  
 srio_ll_rand_write_read_seq ll_rand_write_read_seq ;
   
    function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
	for(int i = 0; i <  no_of_pkt;i++) begin //{
       ll_rand_write_read_seq = srio_ll_rand_write_read_seq::type_id::create("ll_rand_write_read_seq");
       ll_rand_write_read_seq.start(vseq_ll_sequencer); 
        begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  NREAD"),UVM_LOW); end
	    end //} 
  endtask

endclass : srio_ll_rand_write_read_vseq

//================ nwrite wrsize and wdptr user defined============

class srio_ll_req_usr_wrsize_wdptr_class_vseq extends srio_virtual_base_seq;
 `uvm_object_utils(srio_ll_req_usr_wrsize_wdptr_class_vseq)
 
 srio_ll_req_usr_wrsize_wdptr_class_seq ll_nwrite_req_seq ;
   
    function new(string name="");
    super.new(name);
  endfunction

  task body();
	super.body();
    
	 
	for(int i = 0; i < 3 ;i++) begin //{
        ll_nwrite_req_seq = srio_ll_req_usr_wrsize_wdptr_class_seq::type_id::create("ll_nwrite_req_seq");
        if(i == 0)	
        begin //{
        ll_nwrite_req_seq.payload_size_0 = 56; 
        end //}
        else if(i == 1)	
        begin //{
        ll_nwrite_req_seq.payload_size_0 = 64; 
        end //}
        if(i == 2)	
        begin //{
        ll_nwrite_req_seq.payload_size_0 = 72; 
        end //}
        ll_nwrite_req_seq.ftype_0 = 4'h5;
	    ll_nwrite_req_seq.ttype_0 = 4'h4;
        if(i == 2)
        begin
        ll_nwrite_req_seq.wrsize_1 = 4'hD;
        end
        else
        begin
        ll_nwrite_req_seq.wrsize_1 = 4'hC;
        end
        ll_nwrite_req_seq.wdptr_1 = 1'b1;
	       
          ll_nwrite_req_seq.start(vseq_ll_sequencer); 
        begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  NWRITE"),UVM_LOW); end
	        end //} 
 	  endtask

endclass : srio_ll_req_usr_wrsize_wdptr_class_vseq

//======USER GENERATE sequential PRIORITY SEQUENCES===========

class srio_ll_user_gen_seq_prio_seq extends srio_virtual_base_seq;

  `uvm_object_utils(srio_ll_user_gen_seq_prio_seq)
	
     	rand bit [1:0] prior;
        rand bit crf;
	srio_ll_user_gen_base_seq ll_user_gen_base_seq;

	function new(string name="");
    	super.new(name);
  	endfunction

	task body();
	super.body();
    for(int i =0;i < 8;i++)
	 begin //{
        if(i != 3 && i != 7)
        begin
        {crf,prior}= i;    
        ll_user_gen_base_seq = srio_ll_user_gen_base_seq::type_id::create("ll_user_gen_base_seq");
  	
        ll_user_gen_base_seq.prio_0 = prior;
        ll_user_gen_base_seq.crf_0 =crf;  
	ll_user_gen_base_seq.start(vseq_ll_sequencer);  
       	
 	begin  `uvm_info("SRIO VIRTUAL SEQUENCE LIBRARY",$sformatf( "Virtual sequence with  USER GENERATE PACKET with ordered PRIORITY & CRF "),UVM_LOW); end
        end
     end //}
  endtask

endclass : srio_ll_user_gen_seq_prio_seq
