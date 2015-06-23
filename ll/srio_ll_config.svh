////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_config.svh
// Project :  srio vip
// Purpose :  Logical Layer Configuation
// Author  :  Mobiveil
//
// Contains the logical layer configuration class and its variables.
// 
//////////////////////////////////////////////////////////////////////////////// 

class srio_ll_config extends uvm_object;

  /// @cond
  `uvm_object_utils(srio_ll_config)
  /// @endcond

  int orph_xoff_timeout;                             ///< Timeout limit for Orphaned XOFF
  int req_xonxoff_timeout;                           ///< Max time within which XON/XOFF to be sent after receiving REQUEST
  int xon_pdu_timeout;                               ///< Max time within which PDU has to be sent after receing XON
  int tx_mon_tot_pkt_rcvd = 0;                       ///< Number of packets received by TX monitor
  int rx_mon_tot_pkt_rcvd = 0;                       ///< Number of packets received by RX monitor
  int bfm_tx_pkt_cnt      = 0;                       ///< Number of packets transmitted from LL BFM
  int bfm_rx_pkt_cnt      = 0;                       ///< Number of packets received by LL BFM

  uvm_active_passive_enum is_active   = UVM_ACTIVE;  ///< Active or passive agent.
  pkt_arb_type arb_type               = SRIO_LL_RR;  ///< Selection of scheduling method between different packet types
  srio_ll_resp_gen_mode resp_gen_mode = IMMEDIATE;   ///< Response generation mode 

  bit has_checks             = 1;  	             ///< checks enable
  bit has_coverage           = 0;		     ///< coverage enable
  bool interleaved_pkt       = FALSE;                ///< Interleaved mode enable/disable
  bool en_out_of_order_gen   = FALSE;                ///< Out of order generation of msg and completion  
  int gen_resp_en_ratio      = 100;                  ///< Ratio to configre how much responses to be generated
  int gen_resp_dis_ratio     = 0;                    ///< Disable response generation ratio   
  int resp_done_ratio        = 100;                  ///< Done response status ratio
  int resp_err_ratio         = 0;                    ///< Error response status ratio
  int resp_retry_ratio       = 0;                    ///< Retry response status ratio
  int resp_interv_ratio      = 20;                   ///< Intervention status ratio         
  int resp_done_interv_ratio = 20;                   ///< Done intervention status ratio 
  int resp_data_only_ratio   = 20;                   ///< Data only response status ratio
  int resp_not_owner_ratio   = 0;                    ///< Not owner response status ratio
  int resp_delay_min         = 100;                  ///< Random response delay minimum value 
  int resp_delay_max         = 500;                  ///< Random response delay maximum value  
  int io_pkt_ratio           = 20;                   ///< Configures IO packet transmission ratio
  int db_pkt_ratio           = 20;                   ///< Configures DB packet transmission ratio
  int msg_pkt_ratio          = 20;                   ///< Configures MSG packet transmission ratio
  int ds_pkt_ratio           = 20;                   ///< Configures DS packet transmission ratio
  int gsm_pkt_ratio          = 20;                   ///< Configures GSM packet transmission ratio      
  int lfc_pkt_ratio          = 20;                   ///< configures LFC packet transmission ratio          
  bit ds_ext_hdr_en          = 0; 
  bool block_ll_traffic      = FALSE;                ///< Enable/disable packet transmission from LL
  int  ll_resp_timeout       = 100000;               ///< Reponse timeout,used by active BFM component,in nano second
  
  event ll_pkt_transmitted;                          ///< Event triggered when a packet is transmitted by LL
  event ll_pkt_received;                             ///< Event triggered when a packet is received by LL

  extern function new (string name = "srio_ll_config");  ///< new function


endclass: srio_ll_config

//////////////////////////////////////////////////////////////////////////
/// Name: new \n
/// Description: LL Config's new function \n
/// new
//////////////////////////////////////////////////////////////////////////

function srio_ll_config::new(string name = "srio_ll_config");
  super.new(name);

  orph_xoff_timeout        = 32'h0FFF_FFFF; 
  req_xonxoff_timeout      = 32'h0FFF_FFFF; 
  xon_pdu_timeout          = 32'h0FFF_FFFF; 

endfunction: new

