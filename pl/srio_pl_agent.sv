////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_agent.sv
// Project :  srio vip
// Purpose :  Physical Layer Agent 
// Author  :  Mobiveil
//
// Physical Layer Agent component.
//
////////////////////////////////////////////////////////////////////////////////  

class srio_pl_agent extends uvm_agent;

  /// @cond
  `uvm_component_utils(srio_pl_agent)
  /// @endcond

  virtual srio_interface srio_if;                      ///< Virtual Interface

  srio_pl_config pl_config;                            ///< PL Config instance

  srio_env_config env_config;                          ///< ENV Config instance

  srio_pl_sequencer pl_sequencer;                      ///< PL Sequencer instance

  srio_pl_bfm pl_driver;                            	///< PL Driver instance

  srio_pl_common_component_trans pl_agent_tx_trans;    ///< Common Component transction tx instance
  srio_pl_common_component_trans pl_agent_rx_trans;    ///< Common Component transction rx instance
  srio_pl_common_component_trans pl_agent_bfm_trans;   ///< Common Component transction bfm instance

  srio_pl_monitor pl_monitor;                          ///< PL Monitor instance 

  bit bfm_or_mon;                                      ///< Bfm or Mon type   

  uvm_put_port #(srio_trans) pl_agent_rx_put_port;     ///< uvm put port
  uvm_put_export #(srio_trans) pl_agent_tx_put_export; ///< uvm put export
  uvm_tlm_fifo #(srio_trans) pl_tx_fifo;               ///< uvm tlm fifo

  // ports
  uvm_analysis_port #(srio_trans) tx_mon_ap;           ///< TX Monitor uvm analysis port 
  uvm_analysis_port #(srio_trans) rx_mon_ap;           ///< RX Monitor uvm analysis port 

  extern function new(string name="srio_pl_agent", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task gen_int_clk();
  
  int cnt;                                             ///< cnt variable 
  bit int_clk;                                         ///< Internal clk 

endclass



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : New
/// Description : Constructor method for srio_pl_agent class.
///////////////////////////////////////////////////////////////////////////////////////////////
function srio_pl_agent::new(string name="srio_pl_agent", uvm_component parent=null);
  super.new(name,parent);
  pl_agent_rx_put_port     = new("pl_agent_rx_put_port", this);
  pl_agent_tx_put_export   = new("pl_agent_tx_put_export", this);
  pl_tx_fifo               = new("pl_tx_fifo", this,100);
endfunction : new



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : build_phase
/// Description : build_phase method for srio_pl_agent class.
/// It gets various config_db variables and also creates all the comonents under this instance.
/// If the env is configured as ACTIVE, then only driver and sequencer instances are created
/// along with monitor instance, else only monitor instance is created.
///////////////////////////////////////////////////////////////////////////////////////////////
function void srio_pl_agent::build_phase(uvm_phase phase);

  pl_config          = srio_pl_config::type_id::create("pl_config", this);
  pl_agent_tx_trans  = srio_pl_common_component_trans::type_id::create("pl_agent_tx_trans", this);
  pl_agent_rx_trans  = srio_pl_common_component_trans::type_id::create("pl_agent_rx_trans", this);
  pl_agent_bfm_trans = srio_pl_common_component_trans::type_id::create("pl_agent_bfm_trans", this);

  uvm_config_db #(srio_pl_config)::set(this,"*", "pl_config", pl_config);
  uvm_config_db #(srio_pl_common_component_trans)::set(this,"*", "pl_com_tx_trans", pl_agent_tx_trans);
  uvm_config_db #(srio_pl_common_component_trans)::set(this,"*", "pl_com_rx_trans", pl_agent_rx_trans);
  uvm_config_db #(srio_pl_common_component_trans)::set(this,"*", "pl_com_bfm_trans", pl_agent_bfm_trans);

  if (!uvm_config_db #(virtual srio_interface)::get(this, "", "SRIO_VIF", pl_config.srio_if))
    `uvm_fatal("CONFIG_LOAD_IF", "Cannot get() virtual interface")

  if (!uvm_config_db #(srio_env_config)::get(this, "", "srio_env_config", env_config))
    `uvm_fatal("CONFIG_LOAD", "Cannot get() ENV CONFIG HANDLE")

  uvm_config_db #(bit)::set(this,"pl_driver", "bfm_or_mon", 1);
  uvm_config_db #(bit)::set(this,"SRIO_PL_MONITOR.*", "bfm_or_mon", 0);

  if (pl_config.is_active == UVM_ACTIVE)
  begin//{
      pl_driver    = srio_pl_bfm::type_id::create("pl_driver", this);
      pl_sequencer = srio_pl_sequencer::type_id::create("pl_sequencer", this);
  end //}

  pl_monitor       = srio_pl_monitor::type_id::create("SRIO_PL_MONITOR", this);

endfunction : build_phase



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name :connect_phase 
/// Description : connect_phase method for srio_pl_agent class.
/// It connects the config_db variables to corresponding sub-compoenent variables, and also
/// creates a connection for all the ports from active and passive sub-componenets.
///////////////////////////////////////////////////////////////////////////////////////////////
function void srio_pl_agent::connect_phase(uvm_phase phase);
  tx_mon_ap = pl_monitor.tx_mon_ap;
  rx_mon_ap = pl_monitor.rx_mon_ap;

  if (pl_config.is_active == UVM_ACTIVE)
  begin //{
        pl_driver.seq_item_port.connect(pl_sequencer.seq_item_export);
        pl_driver.srio_if = pl_config.srio_if;
        pl_agent_tx_put_export.connect(pl_tx_fifo.put_export);
        pl_driver.pl_drv_get_port.connect(pl_tx_fifo.get_export);
        pl_driver.pl_drv_put_port.connect(pl_agent_rx_put_port);
  end //}

endfunction : connect_phase



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name :run_phase
/// Description : It triggers the int_clk generation method.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_agent::run_phase(uvm_phase phase);
 fork
   gen_int_clk();
 join_none

endtask : run_phase


///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_int_clk
/// Description : This method generates internal clock.If srio version is SRIO_GEN30 divide by
/// 67 internal clock is generated.For other versions divide by 10 internal clock is generated.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_agent::gen_int_clk();
forever 
begin //{
	if (env_config.srio_interface_mode == SRIO_SERIAL)
	begin //{
           @(negedge pl_config.srio_if.tx_sclk[0])
           begin //{
               if((cnt == 66 && env_config.srio_mode == SRIO_GEN30) || (cnt == 9 && env_config.srio_mode != SRIO_GEN30))
                  cnt = 0;
               else
                 cnt = cnt + 1;
                
               if(cnt == 0)
                 pl_agent_bfm_trans.int_clk = 1;
               else if((cnt == 34 && env_config.srio_mode == SRIO_GEN30) || (cnt == 5 && env_config.srio_mode != SRIO_GEN30))
                 pl_agent_bfm_trans.int_clk = 0;
           end //}   
	end //}
	else if (env_config.srio_interface_mode == SRIO_PARALLEL)
	begin //{
	  @(pl_config.srio_if.tx_pclk[0]);
	  pl_agent_bfm_trans.int_clk = ~pl_config.srio_if.tx_pclk[0];
	end //}
end //}
endtask : gen_int_clk
