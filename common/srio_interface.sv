////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_interface.sv
// Project :  srio vip
// Purpose :  Interface
// Author  :  Mobiveil
//
// SRIO VIP's Interface. All signals are declared here.
//
////////////////////////////////////////////////////////////////////////////////

interface srio_interface;
                          
  // reset
  logic srio_rst_n;
  logic sim_clk;

  logic [0:15] rx_sclk;
  logic [0:15] tx_sclk;
  logic [0:15] rx_pclk;
  logic [0:15] tx_pclk;

  // Serial transmit pins
  logic [0:15] txp;
  logic [0:15] txn;
  // Serial receive pins
  logic [0:15] rxp;
  logic [0:15] rxn;

  // Parallel interface  pins
  logic [0:9] rx_pdata[0:15];
  logic [0:9] tx_pdata[0:15];

  // Gen3 Parallel interface  pins
  logic [0:66] gen3_rx_pdata[0:15];
  logic [0:66] gen3_tx_pdata[0:15];

  logic TSG_clk;

endinterface
