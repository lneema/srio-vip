////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_env_config.svh
// Project :  srio vip
// Purpose :  VIP Environment Confguration
// Author  :  Mobiveil
//
// Contains the global configuration variables of srio vip.
//
////////////////////////////////////////////////////////////////////////////////


typedef enum {SRIO_DEVID_8,SRIO_DEVID_16,SRIO_DEVID_32} device_id;
typedef enum {SRIO_ADDR_34,SRIO_ADDR_50,SRIO_ADDR_66} address_mode;
typedef enum {NOT_SUPPTD,SUPPTD} crf_support;
typedef enum {SRIO_GEN30,SRIO_GEN22,SRIO_GEN21,SRIO_GEN13} mode;
typedef enum {SRIO_PE,SRIO_PL,SRIO_TXRX} vip_model;
typedef enum {NO_SYNC, NO_SYNC_1, NO_SYNC_2, NO_SYNC_3, NO_SYNC_4, SYNC, SYNC_1, SYNC_2, SYNC_3, SYNC_4} sync_sm_states;
typedef enum {NOT_ALIGNED, NOT_ALIGNED_1, NOT_ALIGNED_2, NOT_ALIGNED_3, ALIGNED, ALIGNED_1, ALIGNED_2, ALIGNED_3, ALIGNED_4, ALIGNED_5, ALIGNED_6, ALIGNED_7} align_sm_states;
typedef enum {INITIALIZE, GET_COLUMN, X1_DELIMITER, X2_DELIMITER, SET_1X_MODE, SET_2X_MODE} mode_detect_sm_states;
typedef enum {SILENT, SEEK, DISCOVERY, X2_RECOVERY, X1_RECOVERY, NX_MODE, X2_MODE, X1_M0, X1_M1, X1_M2, NX_RECOVERY, NX_RETRAIN, X2_RETRAIN, X1_RETRAIN, ASYM_MODE} init_sm_states;
typedef enum {SRIO_125, SRIO_25, SRIO_3125, SRIO_5, SRIO_625, SRIO_103125} baud_rate;
typedef enum {BFM, DUT} monitor_interface_type;
typedef enum {SRIO_SERIAL, SRIO_PARALLEL} interface_mode;
typedef enum {V13, V21, V22, V30} spec_version;

typedef enum {OUT_OF_FRAME, RESET_COUNT, GET_NEW_MARKER, TEST_MARKER, VALID_MARKER, IN_FRAME, INVALID_MARKER, SLIP} frame_lock_sm_states;
typedef enum {NO_LOCK, NO_LOCK_1, NO_LOCK_2, NO_LOCK_3, SLIP_ALIGNMENT, LOCK, LOCK_1, LOCK_2, LOCK_3} cw_lock_sm_states;
typedef enum {UNTRAINED, DME_TRAINING_0, DME_TRAINING_1, DME_TRAINING_2, DME_TRAINING_FAIL, CW_TRAINING_0, CW_TRAINING_1, CW_TRAINING_FAIL, TRAINED, KEEP_ALIVE, RETRAINING_0, RETRAINING_1, RETRAINING_2, RETRAIN_FAIL} link_train_sm_states;
typedef enum {NOT_UPDATED, UPDATE_COEFF, MAXIMUM, UPDATED, MINIMUM} dme_training_coeff_update_states;
typedef enum {IDLE, XMT_WIDTH, RETRAIN_0, RETRAIN_1, RETRAIN_2, RETRAIN_3, RETRAIN_4, RETRAIN_5, RETRAIN_TIMEOUT} retrain_xmt_width_ctrl_sm_states;
typedef enum {XMT_WIDTH_CMD_2, XMT_WIDTH_CMD_3, XMT_WIDTH_CMD_IDLE, XMT_WIDTH_CMD_1} xmt_width_cmd_sm_states;
typedef enum {ASYM_XMT_EXIT, ASYM_XMT_IDLE, XMT_WIDTH_NACK, SEEK_1X_MODE_XMT, SEEK_1X_MODE_XMT_1, SEEK_1X_MODE_XMT_2, SEEK_1X_MODE_XMT_3, X1_MODE_XMT_ACK, X1_MODE_XMT, SEEK_2X_MODE_XMT, SEEK_2X_MODE_XMT_1, SEEK_2X_MODE_XMT_2, SEEK_2X_MODE_XMT_3, X2_MODE_XMT_ACK, X2_MODE_XMT,  SEEK_NX_MODE_XMT, SEEK_NX_MODE_XMT_1, SEEK_NX_MODE_XMT_2, SEEK_NX_MODE_XMT_3, NX_MODE_XMT_ACK, NX_MODE_XMT} xmt_width_sm_states;
typedef enum {RCV_WIDTH_CMD_2, RCV_WIDTH_CMD_3, RCV_WIDTH_CMD_IDLE, RCV_WIDTH_CMD_1} rcv_width_cmd_sm_states;
typedef enum {ASYM_RCV_EXIT, ASYM_RCV_IDLE, RCV_WIDTH_NACK, SEEK_1X_MODE_RCV, X1_MODE_RCV_ACK, X1_MODE_RCV, X1_RETRAIN_RCV, X1_RECOVERY_RCV, SEEK_2X_MODE_RCV, X2_MODE_RCV_ACK, X2_MODE_RCV,  X2_RETRAIN_RCV, X2_RECOVERY_RCV, SEEK_NX_MODE_RCV, NX_MODE_RCV_ACK, NX_MODE_RCV, NX_RETRAIN_RCV,NX_RECOVERY_RCV} rcv_width_sm_states;

typedef class srio_ll_config;
typedef class srio_tl_config;
typedef class srio_pl_config;

class srio_env_config extends uvm_object;

  `uvm_object_utils(srio_env_config)

  // Properties
  device_id srio_dev_id_size            = SRIO_DEVID_8;  ///< Configures the device id size
  uvm_active_passive_enum is_active     = UVM_ACTIVE;	 ///< Configures Active or passive
  address_mode srio_addr_mode           = SRIO_ADDR_34;  ///< Configures the addressing mode
  mode srio_mode                        = SRIO_GEN21;	 ///< Configures the Specification version
  crf_support crf_en                    = SUPPTD;          ///< Configure CRF support
  vip_model srio_vip_model              = SRIO_PE;	 ///< Configures the VIP model mode	
  baud_rate srio_baud_rate;
  monitor_interface_type srio_tx_mon_if = BFM;           ///< Configures monitor interface type (BFM or DUT)
  monitor_interface_type srio_rx_mon_if = DUT;
  interface_mode srio_interface_mode    = SRIO_SERIAL;   ///< Configures the interface mode (SERIAL or PARALLEL)

  bit has_checks                 = 1;  		 ///< Enable/Disable monitor checks
  bit has_coverage               = 1;		 ///< Enable/Disable functional	coverage
  int port_number 		 = 0;		///< Device port number.
  int num_of_lanes               = 4;            ///< Configures the number of lanes to be supported
  bit en_ext_addr_support        = 0;            ///< Configures the extended address support
  bit link_initialized           = 0;            ///< Indicates if link is initialized or not
  bit pl_mon_tx_link_initialized = 0;            ///< Indicates if PL monitor TX links initialized or not
  bit pl_mon_rx_link_initialized = 0;            ///< Indicates if PL monitor RX links initialized or not
  bit [23:0] reg_space_size      = 24'hFFFFFF;   ///< Configures register space size
  bit has_virtual_sequencer      = 1;            ///< Configures if virtual sequencer is required or not
  bit multi_vc_support           = 0;            ///< Enable/Disable Multiple VC support
  int vc_num_support             = 1;            ///< Number of VCs supported, possible values addition to VC0
                                                 ///< 8 - VC1-VC8, 4 - VC1,VC3,VC5,VC7, 2 - VC1,VC5 1 - VC1    
  bit en_packet_delay            = 0;           ///<  Enable packet delay
  spec_version spec_support 	 = V21;		///< Specification version supported
  srio_reg_block srio_reg_model_tx;             ///< BFM register model instance
  srio_reg_block srio_reg_model_rx;             ///< DUT register model instance
  srio_ll_config ll_config;                     ///< LL config handle
  srio_tl_config tl_config;                     ///< TL config handle
  srio_pl_config pl_config;                     ///< PL config handle

  init_sm_states pl_rx_mon_init_sm_state;	///< Rx monitor initialization state.
  init_sm_states pl_tx_mon_init_sm_state;	///< Tx monitor initialization state.

  bit idle_detected;                            ///< Indicates the IDLE type detected
  bit idle_selected;                            ///< Indicates the IDLE type selected

  bit [0:11] current_ack_id;                    ///< Indicates the ack id of the received packet
  event packet_rx_started;                      ///< Event triggered whenever PL started receiving packet

  integer file_h;			        ///< File handler for transaction tracker.

  bit scramble_dis=0;                            ///< Bit to control scrambling from Callback.
                                                ///< 1-disable scrambling, 0 -enable scrambling
  bit max_pkt_err_cause=0;                      ///< Bit to control PNAC cause field for Max Pkt size Err
                                                ///< 0 -31(General Err) 1- 5(Invalid Err)
  bit idle_chk_err_dis;                         ///< flag bit used for idle check error - disable
 
  bit reset_ackid    =0;                        ///< flag bit to reset internal ackids in BFM
  event pkt_acc_timeout_evt;			///< Timeout for packet accepted CS detected.
  event pkt_nacc_timeout_evt;			///< Timeout for packet not accepted CS detected.
  event link_resp_timeout_evt;			///< Timeout for Link response CS detected.
  event loop_resp_timeout_evt;			///< Timeout for Loop response CS detected.
  event link_req_timeout_evt;			///< Timeout for Link request CS detected.
  event loop_req_timeout_evt;			///< Timeout for Loop request CS detected.
  event rfr_timeout_evt;			///< Timeout for Restart from retry CS detected.
  extern function new (string name = "srio_env_config");

endclass: srio_env_config

//////////////////////////////////////////////////////////////////////////
/// Name: new
/// Description: env config's new function
/// new
//////////////////////////////////////////////////////////////////////////

function srio_env_config::new(string name = "srio_env_config");
  super.new(name);
endfunction: new
