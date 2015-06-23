////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_env.sv
// Project :  srio vip
// Purpose :  SRIO VIP Env Component
// Author  :  Mobiveil
//
// SRIO VIP env component extended from uvm_env.Instantiates PL/TL//LL Agents.
// Necessary connections between them are also included in this class.
////////////////////////////////////////////////////////////////////////////////

class srio_env extends uvm_env;

  `uvm_component_utils(srio_env)

  srio_ll_agent ll_agent;                     ///< LL Agent Object 
  srio_tl_agent tl_agent;                     ///< TL Agent Object
  srio_pl_agent pl_agent;                     ///< PL Agent Object
  srio_env_config env_config;                 ///< Env config object
  srio_virtual_sequencer e_virtual_sequencer;  ///< Virtual sequencer object
 
  srio_reg_block srio_reg_model;         ///< SRIO register block
  srio_reg_adapter srio_adapter;         ///< Register layering adapter
  uvm_reg_predictor #(srio_trans) srio_reg_predictor;  ///< Register predictor
  srio_trans_decoder trans_decoder;  ///< SRIO Transaction decoder, used by register model

  srio_ll_func_coverage srio_ll_fc;  ///< LL functional coverage instance
  srio_tl_func_coverage srio_tl_fc;  ///< TL functional coverage instance
  srio_pl_func_coverage srio_pl_fc;  ///< PL functional coverage instance

  uvm_put_port   #(srio_trans) tl_agent_tx_put_port;    ///< Dummy TLM port used in PL model 
  uvm_put_export #(srio_trans) tl_agent_rx_put_export;  ///< Dummy TLM port used in PL model
  uvm_tlm_fifo   #(srio_trans) tl_rx_fifo;              ///< Dummy TLM port fifo  

///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : New
/// Description : Constructor method for srio_env class.
///////////////////////////////////////////////////////////////////////////////////////////////
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : build_phase
/// Description : build_phase method for srio_pl_bfm class.
/// In this all the config variables are got and all agents , sequencer, reg models, coverage
/// and ports are created
///////////////////////////////////////////////////////////////////////////////////////////////
  function void build_phase(uvm_phase phase);

    if(!uvm_config_db #(srio_env_config)::get(this, "", "srio_env_config", env_config)) // Get env config handle from config database
     `uvm_fatal("CONFIG FATAL", "Can't get the env_config")

    srio_reg_model     = env_config.srio_reg_model_rx;  // DUT's register model instance
    srio_adapter       = srio_reg_adapter::type_id::create("srio_adapter");  // Register model adapter
    srio_reg_predictor = uvm_reg_predictor #(srio_trans)::type_id::create("srio_reg_predictor", this); // Register model predictor
    trans_decoder      = srio_trans_decoder::type_id::create("trans_decoder", this);    // Register model predictor

    if(env_config.srio_vip_model == SRIO_PE)  // If PE model include LL and TL agents
    begin
      ll_agent = srio_ll_agent::type_id::create("ll_agent", this);
      tl_agent = srio_tl_agent::type_id::create("tl_agent", this);
    end
    pl_agent = srio_pl_agent::type_id::create("pl_agent", this);
   
    if(env_config.has_virtual_sequencer)  // If has virtual sequencer , create virtual sequencer instance
    begin 
       e_virtual_sequencer = srio_virtual_sequencer::type_id::create("e_virtual_sequencer", this);
    end 

    if(env_config.has_coverage)  // If Functional coverage needs to be included
    begin 
      if(env_config.srio_vip_model == SRIO_PE)  // If PE model include LL and TL FC
      begin 
        srio_ll_fc     = srio_ll_func_coverage::type_id::create("srio_ll_fc", this);
        srio_tl_fc     = srio_tl_func_coverage::type_id::create("srio_tl_fc", this);
      end 
      srio_pl_fc     = srio_pl_func_coverage::type_id::create("srio_pl_fc", this);  // Include PL FC for all models
    end 

    if(env_config.srio_vip_model == SRIO_PL || env_config.srio_vip_model == SRIO_TXRX)  
    begin
      tl_agent_rx_put_export = new("tl_agent_rx_put_export", this);
      tl_agent_tx_put_port   = new("tl_agent_tx_put_port", this);
      tl_rx_fifo = new("tl_rx_fifo", this,100);
    end
  endfunction

////////////////////////////////////////////////////////////////////////////////
/// Name: connect_phase \n
/// Description: ENV's connect_phase function \n
/// All the ports,analysis ports,reg models and functional coverage are connected
////////////////////////////////////////////////////////////////////////////////
  function void connect_phase(uvm_phase phase);
     if(env_config.srio_vip_model == SRIO_PE)  // If PE model,connect PL-<>TL and TL<-> LL
     begin  // TLM ports
       ll_agent.ll_agent_tx_put_port.connect(tl_agent.tl_agent_tx_put_export);
       tl_agent.tl_agent_tx_put_port.connect(pl_agent.pl_agent_tx_put_export);
       pl_agent.pl_agent_rx_put_port.connect(tl_agent.tl_agent_rx_put_export);
       tl_agent.tl_agent_rx_put_port.connect(ll_agent.ll_agent_rx_put_export);
       // Analysis port to upper layer import connection
       tl_agent.tl_monitor.tx_mon_ap.connect(ll_agent.ll_monitor.tx_monitor.ll_tx_mon_imp);
       tl_agent.tl_monitor.rx_mon_ap.connect(ll_agent.ll_monitor.rx_monitor.ll_rx_mon_imp);
       pl_agent.pl_monitor.tx_mon_ap.connect(tl_agent.tl_monitor.tx_monitor.tl_tx_mon_imp); 
       pl_agent.pl_monitor.rx_mon_ap.connect(tl_agent.tl_monitor.rx_monitor.tl_rx_mon_imp);
     end 
     else if(env_config.srio_vip_model == SRIO_PL || env_config.srio_vip_model == SRIO_TXRX)  
     begin 
       // In PL/TXRX model only PL agent will be included.User needs to connect the
       // PL agents's TLM and Analysis port to their wrapper logic.Here dummy
       // ports are connected for example and user needs to replace it.
       tl_agent_rx_put_export.connect(tl_rx_fifo.put_export);  
       tl_agent_tx_put_port.connect(pl_agent.pl_agent_tx_put_export);
       pl_agent.pl_agent_rx_put_port.connect(tl_agent_rx_put_export);
     end 
   if(env_config.has_virtual_sequencer)   // Create virtual sequencer instance for each layer and store the handles
   begin                                  // to top virtual sequencer
      if(env_config.srio_vip_model == SRIO_PE)  // If PE model include LL and TL FC
      begin 
       e_virtual_sequencer.v_ll_sequencer = ll_agent.ll_sequencer;
       e_virtual_sequencer.v_tl_sequencer = tl_agent.tl_sequencer;
      end
      e_virtual_sequencer.v_pl_sequencer = pl_agent.pl_sequencer;
      begin
         `uvm_info("SRIO ENV FILE ",$sformatf( "CONNECTION BETWEEN THE VIRTUAL AND TARGET SEQUENCERS"),UVM_LOW);
      end
   end 
    // Register sequencer layering part:
    if(env_config.srio_vip_model == SRIO_PE)
      srio_reg_model.srio_reg_block_map.set_sequencer(ll_agent.ll_sequencer, srio_adapter);
    else
      srio_reg_model.srio_reg_block_map.set_sequencer(pl_agent.pl_sequencer, srio_adapter);

    //Register Layer
    // Register prediction part:
    // Set the predictor Adress map:
    srio_reg_predictor.map = srio_reg_model.srio_reg_block_map;
    // Set the predictor adapter:
    srio_reg_predictor.adapter = srio_adapter;
    // Disable the register models auto-prediction
    srio_reg_model.srio_reg_block_map.set_auto_predict(0);
    trans_decoder.tx_decoder.srio_reg_model = srio_reg_model; 
    // Connect the predictor to the bus agent monitor analysis port
    if(env_config.srio_vip_model == SRIO_PE)
    begin //{
      ll_agent.tx_mon_ap.connect(trans_decoder.tx_decoder.analysis_export);
      ll_agent.rx_mon_ap.connect(trans_decoder.rx_decoder.analysis_export);
      if(env_config.has_coverage)
      begin //{
        ll_agent.tx_mon_ap.connect(srio_ll_fc.tx_trans_collector.analysis_export);
        ll_agent.rx_mon_ap.connect(srio_ll_fc.rx_trans_collector.analysis_export);
        tl_agent.tx_mon_ap.connect(srio_tl_fc.tx_trans_collector.analysis_export);
        tl_agent.rx_mon_ap.connect(srio_tl_fc.rx_trans_collector.analysis_export);
        pl_agent.tx_mon_ap.connect(srio_pl_fc.tx_trans_collector.analysis_export);
        pl_agent.rx_mon_ap.connect(srio_pl_fc.rx_trans_collector.analysis_export);
        srio_ll_fc.ll_agent = ll_agent;
        srio_pl_fc.pl_agent = pl_agent;
      end //}
    end //}
    else
    begin //{
      pl_agent.tx_mon_ap.connect(trans_decoder.tx_decoder.analysis_export);
      pl_agent.rx_mon_ap.connect(trans_decoder.rx_decoder.analysis_export);
      if(env_config.has_coverage)
      begin //{
        pl_agent.tx_mon_ap.connect(srio_pl_fc.tx_trans_collector.analysis_export);
        pl_agent.rx_mon_ap.connect(srio_pl_fc.rx_trans_collector.analysis_export);
        srio_pl_fc.pl_agent = pl_agent;
      end //}
    end //}

    // Connect the srio transaction decoder to the register predictor's input port
    trans_decoder.ap.connect(srio_reg_predictor.bus_in);
  endfunction: connect_phase
endclass

