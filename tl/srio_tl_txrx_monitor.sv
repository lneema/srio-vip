////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_tl_txrx_monitor.sv
// Project :  srio vip
// Purpose :  TL protocol Checker
// Author  :  Mobiveil
//
// Contains srio_tl_txrx_monitor class to perform protocol checks of TL
////////////////////////////////////////////////////////////////////////////////

class srio_tl_txrx_monitor extends uvm_component;

  /// @cond
  `uvm_component_utils(srio_tl_txrx_monitor)

  // Instance of LL configuration
  srio_tl_config tl_config;

  // Register model instance
  srio_reg_block tl_reg_model;

  // Env Config 
  srio_env_config tl_mon_env_config;

  srio_trans  tl_out_pkt;
  srio_trans  tl_pkt;
  srio_trans  in_packet;
  srio_trans  pkts_to_process[$];
  int LTLED_CSR;  // <OR with tl_LTLED_CSR and update the register>

  // Monitor imports
  uvm_analysis_imp #(srio_trans,srio_tl_txrx_monitor) tl_tx_mon_imp; 
  uvm_analysis_imp #(srio_trans,srio_tl_txrx_monitor) tl_rx_mon_imp; 

  // Monitor Properties
  bit mon_type;         // 1 : tx_monitor ;         0 : rx_monitor
  bit en_err_report;    // 1 : Enable error report; 0 : Disable error report 
  int deviceid;
  int deviceid_8;
  int deviceid_16;
  int deviceid_32;
  bit dev32support;
  bit dev16support;
  bit drop_packet;

  // Analysis port
  uvm_analysis_port #(srio_trans) mon_ap;
  /// @endcond

  extern function new(string name="srio_tl_txrx_monitor", 
    uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

  extern function void write(srio_trans t1);
  extern function void process_pkt(srio_trans t);

  extern function void srio_tl_pkt_protocol_chk();
  extern function void tl_update_ltled_csr();

endclass: srio_tl_txrx_monitor

////////////////////////////////////////////////////////////////////////////////
/// Name: run_phase \n 
/// Description: TL TXRX Monitor's run_phase task \n
/// run_phase
//////////////////////////////////////////////////////////////////////////////// 

task srio_tl_txrx_monitor::run_phase(uvm_phase phase);
  // Error demotion
  err_demoter tl_err_demoter   = new;
  tl_err_demoter.en_err_demote = !en_err_report;
  uvm_report_cb::add(this,tl_err_demoter);


  forever 
  begin  // {
    wait(pkts_to_process.size() > 0); 
    begin // {          
      in_packet = new pkts_to_process.pop_front(); 
      process_pkt(in_packet); 
    end // } 
  end // }

endtask

////////////////////////////////////////////////////////////////////////////////
/// Name: write \n 
/// Description: TL TXRX Monitor's write function \n
///              Stores all the packets received through the analysis port of \n  
///              other layers into a queue \n    
/// write
//////////////////////////////////////////////////////////////////////////////// 

function void srio_tl_txrx_monitor::write(srio_trans t1);

  if (t1.transaction_kind == SRIO_PACKET) 
  begin // { 
    pkts_to_process.push_back(t1); 
    `uvm_info("TL_MON_RECEIVED_PKT", $sformatf("Packet Ftype: %0h h", t1.ftype), 
    UVM_LOW)
  end // }
      
endfunction: write

////////////////////////////////////////////////////////////////////////////////
/// Name: process_pkt \n
/// Description: TL TXRX Monitor's process_pkt function \n
///              Does first level processing of the received packet \n  
///              Calls the protocol checker to perform further checks and \n  
///              sends out the packet through the analysis port \n    
/// process_pkt
//////////////////////////////////////////////////////////////////////////////// 
function void srio_tl_txrx_monitor::process_pkt(srio_trans t); 
  tl_pkt     = new t;
  tl_out_pkt = new t;
  LTLED_CSR = 0;

  if (tl_config.has_checks && tl_mon_env_config.has_checks)
  begin // {
    if (tl_pkt.pl_err_encountered)
    begin // {
      `uvm_info("TL_MON", 
      $sformatf("Packet Ftype: %0h h is not entering TL checks because of PL error",
      tl_pkt.ftype), UVM_LOW)
    end // }  
    else 
    begin // {
      srio_tl_pkt_protocol_chk(); 
      tl_update_ltled_csr();
    end // }
  end // }
  mon_ap.write(tl_out_pkt);

endfunction: process_pkt

////////////////////////////////////////////////////////////////////////////////
/// Name: new \n 
/// Description: TL TXRX Monitor's new function \n
/// new
//////////////////////////////////////////////////////////////////////////////// 

function srio_tl_txrx_monitor::new(string name="srio_tl_txrx_monitor", 
                                 uvm_component parent=null);
  super.new(name, parent);
endfunction: new

////////////////////////////////////////////////////////////////////////////////
/// Name: build_phase \n 
/// Description: TL TXRX Monitor's build_phase function \n
/// build_phase
////////////////////////////////////////////////////////////////////////////////

function void srio_tl_txrx_monitor::build_phase(uvm_phase phase);

  if (!uvm_config_db #(srio_tl_config)::get(this,"", "tl_config", tl_config))
    `uvm_fatal("CONFIG_LOAD", "Cannot get() tl_config ")

  if (!uvm_config_db #(bit)::get(this, "", "mon_type", mon_type))
    `uvm_fatal("CONFIG_LOAD", "Cannot get()TL MON_TYPE Value")

  if (!uvm_config_db #(bit)::get(this, "", "en_err_report", en_err_report))
    `uvm_fatal("CONFIG_LOAD", "Cannot get() TL en_err_report Value")

  if (!uvm_config_db #(srio_env_config)::get(this, "", "srio_env_config", 
    tl_mon_env_config))
    `uvm_fatal("CONFIG_LOAD", "Cannot get() Env Config Handle")

  `uvm_info("TL_MON", $sformatf("TL MON_TYPE %0h h en_err_report %0h h", 
            mon_type, en_err_report), UVM_LOW)

  mon_ap = new("txrx_monitor_ap", this);

  // Monitor imports
  tl_tx_mon_imp = new("tl_tx_mon_imp", this);
  tl_rx_mon_imp = new("tl_rx_mon_imp", this);

endfunction : build_phase

////////////////////////////////////////////////////////////////////////////////
/// Name: connect_phase \n 
/// Description: TL TXRX Monitor's connect_phase function \n
/// connect_phase
////////////////////////////////////////////////////////////////////////////////

function void srio_tl_txrx_monitor::connect_phase(uvm_phase phase);
  // Register Model 
  if (mon_type)
  begin // {
    tl_reg_model = tl_mon_env_config.srio_reg_model_rx;
  end // }
  else
  begin // {
    tl_reg_model = tl_mon_env_config.srio_reg_model_tx;
  end //}

  deviceid_8  = tl_reg_model.Base_Device_ID_CSR.Base_deviceID.get();
  deviceid_16 = tl_reg_model.Base_Device_ID_CSR.Large_base_deviceID.get();
  deviceid_32 = tl_reg_model.Dev32_Base_Device_ID_CSR.Dev32_Base_Device_ID.get();

  dev32support = tl_reg_model.Processing_Element_Features_CAR.Dev32_Support.get();
  dev16support = tl_reg_model.Processing_Element_Features_CAR.Dev16_Support.get();

endfunction: connect_phase

////////////////////////////////////////////////////////////////////////////////
/// Name: srio_tl_pkt_protocol_chk \n 
/// Description: TL's Protocol Checker function \n
/// srio_tl_pkt_protocol_chk
////////////////////////////////////////////////////////////////////////////////

function void srio_tl_txrx_monitor::srio_tl_pkt_protocol_chk();

  tl_err_type err_type;
  bit         pass_sts;
  bit         pkt_valid;
  bit [1:0]   exp_tt;

  pass_sts  = 1;
  pkt_valid = 1;
  err_type  = TL_NULL_ERR;
  
  tl_pkt.tl_pkt_valid = 1;
  // Destination ID check to accept packets

  if (tl_mon_env_config.srio_mode == SRIO_GEN13)
    deviceid = deviceid_8;
  else if (tl_mon_env_config.srio_mode == SRIO_GEN21 || 
           tl_mon_env_config.srio_mode == SRIO_GEN22)
    deviceid = deviceid_16;
  else 
    deviceid = deviceid_32;

  if (tl_pkt.DestinationID != deviceid)
  begin // {
    if (tl_config.en_deviceid_chk)
    begin // {
      pass_sts = 0;
      pkt_valid = 0;
      err_type = DEST_ID_MISMATCH_ERR;
      LTLED_CSR[5] = 1;

      `uvm_error("SRIO_TL_PROTOCOL_CHECKER:DEST_ID_MISMATCH_ERR", 
      $sformatf("Spec ref: Part3-Section2.3: %s: Packet is dropped; Exp: %0h; Actual: %0h",
      err_type.name, deviceid, tl_pkt.DestinationID))
    end // }
    else
    begin // {
      err_type = DEST_ID_MISMATCH_ERR;

      `uvm_info("SRIO_TL_PROTOCOL_CHECKER:DEST_ID_MISMATCH_ERR", 
      $sformatf("Spec ref: Part3-Section2.3: %s: Exp: %0h; Actual: %0h", 
      err_type.name, deviceid, tl_pkt.DestinationID), UVM_INFO)
    end // }
  end // }

  if(((tl_mon_env_config.srio_dev_id_size == SRIO_DEVID_32) && (dev32support != 1)) ||
     ((tl_mon_env_config.srio_dev_id_size == SRIO_DEVID_16) && (dev16support != 1)))
  begin // {
    `uvm_error("SRIO_TL_PROTOCOL_CHECKER", 
    $sformatf("Spec ref: Part3-Section2.4: %s is not supported by the device",
    tl_mon_env_config.srio_dev_id_size.name))
  end // }
  else if(((tl_mon_env_config.srio_mode == SRIO_GEN13) && 
          ((tl_mon_env_config.srio_dev_id_size == SRIO_DEVID_32) ||
           (tl_mon_env_config.srio_dev_id_size == SRIO_DEVID_16)))       ||
          ((tl_mon_env_config.srio_mode == SRIO_GEN21 
         || tl_mon_env_config.srio_mode == SRIO_GEN22) &&
           (tl_mon_env_config.srio_dev_id_size == SRIO_DEVID_32)))
  begin // {
    `uvm_error("SRIO_TL_PROTOCOL_CHECKER", $sformatf("%s not supported by %s", 
    tl_mon_env_config.srio_dev_id_size.name, tl_mon_env_config.srio_mode.name))
  end // }
  
  case (tl_mon_env_config.srio_dev_id_size)
    SRIO_DEVID_32: exp_tt = 'b10;
    SRIO_DEVID_16: exp_tt = 'b01;
    SRIO_DEVID_8 : exp_tt = 'b00;
  endcase

  // TT field check
  if (tl_pkt.tt != exp_tt)
  begin // {
    pass_sts = 0;
    
    if (tl_pkt.tt == 'b11)
    begin // {
      err_type = RESERVED_TT_ERR;

      `uvm_error("SRIO_TL_PROTOCOL_CHECKER:RESERVED_TT_ERR", 
      $sformatf("Spec ref: Part3-Section2.4: %s: Packet is dropped; \
      TT Exp: %0h; Act: %0h", err_type.name, exp_tt, tl_pkt.tt))
    end // }
    else
    begin // {
      err_type = UNSUPPORTED_TT_ERR;

      `uvm_error("SRIO_TL_PROTOCOL_CHECKER:UNSUPPORTED_TT_ERR", 
      $sformatf("Spec ref: Part3-Section2.4: %s: Packet is dropped; \
      TT Exp: %0h; Act: %0h", 
      err_type.name, exp_tt, tl_pkt.tt))
    end // }

    pkt_valid = 0;

  end // }

  tl_out_pkt.tl_err_encountered = pass_sts;
  tl_out_pkt.tl_pkt_valid       = pkt_valid;
  tl_out_pkt.tl_err_detected    = err_type; 

endfunction: srio_tl_pkt_protocol_chk

////////////////////////////////////////////////////////////////////////////////
/// Name: tl_update_ltled_csr \n 
/// Description: TL function to update the status registers \n
/// tl_update_ltled_csr
////////////////////////////////////////////////////////////////////////////////

function void srio_tl_txrx_monitor::tl_update_ltled_csr();
  
  int LTLEE_RD1, LTLED_RD1, LTLED_WR, LTLED_RD2, LTLHAC_WR, LTLAC_WR, LTLDIDC_WR,
      LTLCC_WR, LTLD32DIDC_WR, LTLD32SIDC_WR; 
  bit port_wr_pending_sts;

  if (LTLED_CSR !=0)
  begin // { 
    LTLEE_RD1 =  tl_reg_model.Logical_Transport_Layer_Error_Enable_CSR.get();
    LTLED_RD1 =  tl_reg_model.Logical_Transport_Layer_Error_Detect_CSR.get();

    LTLED_WR = LTLED_CSR & LTLEE_RD1;

    if (LTLED_WR) // Err sts update is enabled and the error has been detected 
    begin // {
      LTLED_WR = LTLED_WR  | LTLED_RD1;
      void'(tl_reg_model.Logical_Transport_Layer_Error_Detect_CSR.predict(LTLED_WR));
      LTLED_RD2 = tl_reg_model.Logical_Transport_Layer_Error_Detect_CSR.get();
  
      if (LTLED_RD2 != LTLED_WR)
      begin // {
       `uvm_warning("SRIO_LL_PROTOCOL_CHECKER:reg_chk", 
        $sformatf("LTLED Register not updated properly; \
        Write value: %0h h; Read Value: %0h h", LTLED_WR, LTLED_RD2))
      end // }

      // Updating Error Capture registers
      case (tl_mon_env_config.port_number)
        0 : port_wr_pending_sts = tl_reg_model.Port_0_Error_and_Status_CSR.Port_write_Pending.get(); 
        1 : port_wr_pending_sts = tl_reg_model.Port_1_Error_and_Status_CSR.Port_write_Pending.get();
        2 : port_wr_pending_sts = tl_reg_model.Port_2_Error_and_Status_CSR.Port_write_Pending.get();
        3 : port_wr_pending_sts = tl_reg_model.Port_3_Error_and_Status_CSR.Port_write_Pending.get();
        4 : port_wr_pending_sts = tl_reg_model.Port_4_Error_and_Status_CSR.Port_write_Pending.get();
        5 : port_wr_pending_sts = tl_reg_model.Port_5_Error_and_Status_CSR.Port_write_Pending.get();
        6 : port_wr_pending_sts = tl_reg_model.Port_6_Error_and_Status_CSR.Port_write_Pending.get();
        7 : port_wr_pending_sts = tl_reg_model.Port_7_Error_and_Status_CSR.Port_write_Pending.get();
        8 : port_wr_pending_sts = tl_reg_model.Port_8_Error_and_Status_CSR.Port_write_Pending.get();
        9 : port_wr_pending_sts = tl_reg_model.Port_9_Error_and_Status_CSR.Port_write_Pending.get();
        10: port_wr_pending_sts = tl_reg_model.Port_10_Error_and_Status_CSR.Port_write_Pending.get();
        11: port_wr_pending_sts = tl_reg_model.Port_11_Error_and_Status_CSR.Port_write_Pending.get();
        12: port_wr_pending_sts = tl_reg_model.Port_12_Error_and_Status_CSR.Port_write_Pending.get();
        13: port_wr_pending_sts = tl_reg_model.Port_13_Error_and_Status_CSR.Port_write_Pending.get();
        14: port_wr_pending_sts = tl_reg_model.Port_14_Error_and_Status_CSR.Port_write_Pending.get();
        15: port_wr_pending_sts = tl_reg_model.Port_15_Error_and_Status_CSR.Port_write_Pending.get();
      endcase

      if (port_wr_pending_sts == 0)
      begin // {
        // Set Port-write Pending bit to 1  
        case (tl_mon_env_config.port_number)
          0 : void'(tl_reg_model.Port_0_Error_and_Status_CSR.Port_write_Pending.predict(1'b1));
          1 : void'(tl_reg_model.Port_1_Error_and_Status_CSR.Port_write_Pending.predict(1'b1));
          2 : void'(tl_reg_model.Port_2_Error_and_Status_CSR.Port_write_Pending.predict(1'b1));
          3 : void'(tl_reg_model.Port_3_Error_and_Status_CSR.Port_write_Pending.predict(1'b1));
          4 : void'(tl_reg_model.Port_4_Error_and_Status_CSR.Port_write_Pending.predict(1'b1));
          5 : void'(tl_reg_model.Port_5_Error_and_Status_CSR.Port_write_Pending.predict(1'b1));
          6 : void'(tl_reg_model.Port_6_Error_and_Status_CSR.Port_write_Pending.predict(1'b1));
          7 : void'(tl_reg_model.Port_7_Error_and_Status_CSR.Port_write_Pending.predict(1'b1));
          8 : void'(tl_reg_model.Port_8_Error_and_Status_CSR.Port_write_Pending.predict(1'b1));
          9 : void'(tl_reg_model.Port_9_Error_and_Status_CSR.Port_write_Pending.predict(1'b1));
          10: void'(tl_reg_model.Port_10_Error_and_Status_CSR.Port_write_Pending.predict(1'b1));
          11: void'(tl_reg_model.Port_11_Error_and_Status_CSR.Port_write_Pending.predict(1'b1));
          12: void'(tl_reg_model.Port_12_Error_and_Status_CSR.Port_write_Pending.predict(1'b1));
          13: void'(tl_reg_model.Port_13_Error_and_Status_CSR.Port_write_Pending.predict(1'b1));
          14: void'(tl_reg_model.Port_14_Error_and_Status_CSR.Port_write_Pending.predict(1'b1));
          15: void'(tl_reg_model.Port_15_Error_and_Status_CSR.Port_write_Pending.predict(1'b1));
        endcase

        LTLHAC_WR     =  tl_pkt.ext_address;
        LTLAC_WR      = {tl_pkt.address, 1'b0, tl_pkt.xamsbs};
        LTLDIDC_WR    = {tl_pkt.DestinationID[15:0], tl_pkt.SourceID[15:0]}; 
        LTLCC_WR      = {tl_pkt.ftype, tl_pkt.ttype, tl_pkt.letter, tl_pkt.mbox,
                         tl_pkt.msgseg_xmbox, 16'h0};
        LTLD32DIDC_WR =  tl_pkt.DestinationID;
        LTLD32SIDC_WR =  tl_pkt.SourceID;
 
        void'(tl_reg_model.Logical_Transport_Layer_Address_Capture_CSR.predict(LTLAC_WR));
        void'(tl_reg_model.Logical_Transport_Layer_Control_Capture_CSR.predict(LTLCC_WR));

        if (tl_mon_env_config.en_ext_addr_support)
        begin // {
          void'(tl_reg_model.Logical_Transport_Layer_High_Address_Capture_CSR.predict(LTLHAC_WR));
        end // }

        dev32support = tl_reg_model.Processing_Element_Features_CAR.Dev32_Support.get();
        if (dev32support)
        begin // {
          void'(tl_reg_model.Logical_Transport_Layer_Dev32_Destination_ID_Capture_CSR.predict(LTLD32DIDC_WR));
          void'(tl_reg_model.Logical_Transport_Layer_Dev32_Source_ID_Capture_CSR.predict(LTLD32SIDC_WR));
        end // }
        else
        begin // {
          void'(tl_reg_model.Logical_Transport_Layer_Device_ID_Capture_CSR.predict(LTLDIDC_WR));
        end // }
      end // }
    end // }
  end // }
  
endfunction : tl_update_ltled_csr

// =============================================================================
