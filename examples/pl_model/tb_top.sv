////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  tb_top.sv
// Project :  srio vip
// Purpose :  SRIO VIP TB TOP Module
// Author  :  Mobiveil
//
// Top module for SRIO VIP back to back set up.
//
//////////////////////////////////////////////////////////////////////////////// 
typedef enum {SRIO_125, SRIO_25, SRIO_3125, SRIO_5, SRIO_625, SRIO_103125} baud_rate;

module tb_top;

  import uvm_pkg::*;			///< Importing uvm package.
  import srio_test_lib_pkg::*;		///< Importing test library package.

/////////////////////////////////////////

// Instantiate the interfaces:

srio_interface SRIO_IF1();		///< Interface instance for env1.
srio_interface SRIO_IF2();		///< Interface instance for env2.

////////////////////////////////////////////////////////////////////////////////////////
/// Name : Initial block 1.
/// Description : Sets the virtual interface instances of env1 and env2 in uvm_config_db
/// and triggers the test by calling run_test.
////////////////////////////////////////////////////////////////////////////////////////
initial
begin
  uvm_config_db#(virtual  srio_interface)::set(null,  "*srio_env1*",  "SRIO_VIF",  SRIO_IF1);
  uvm_config_db#(virtual  srio_interface)::set(null,  "*srio_env2*",  "SRIO_VIF",  SRIO_IF2);
  run_test();
end


////////////////////////////////////////////////////////////////////////////////////////
/// Name : Initial block 2.
/// Description : Issues reset to both the ENVs and clears it after 50ns.
////////////////////////////////////////////////////////////////////////////////////////
initial
begin
   SRIO_IF1.srio_rst_n = 0;
   SRIO_IF2.srio_rst_n = 0;
   #50ns; 
   SRIO_IF1.srio_rst_n = 1;
   SRIO_IF2.srio_rst_n = 1;
end


////////////////////////////////////////////////////////////////////////////////////////
/// Name : Initial block 3.
/// Description : Generates sim_clk based on the baud rate.
////////////////////////////////////////////////////////////////////////////////////////
initial
begin
   SRIO_IF1.sim_clk = 0;
   forever
   begin
     if(`SRIO_SPEED == SRIO_125)
       #4ns SRIO_IF1.sim_clk = ~SRIO_IF1.sim_clk;
     if(`SRIO_SPEED == SRIO_25)
       #2ns SRIO_IF1.sim_clk = ~SRIO_IF1.sim_clk;
     if(`SRIO_SPEED == SRIO_3125)
       #1.6ns SRIO_IF1.sim_clk = ~SRIO_IF1.sim_clk;
     if(`SRIO_SPEED == SRIO_5)
       #1ns SRIO_IF1.sim_clk = ~SRIO_IF1.sim_clk;
     if(`SRIO_SPEED == SRIO_625)
       #0.8ns SRIO_IF1.sim_clk = ~SRIO_IF1.sim_clk;
     if(`SRIO_SPEED == SRIO_103125)
       #3.25ns SRIO_IF1.sim_clk = ~SRIO_IF1.sim_clk;
   end
end

////////////////////////////////////////////////////////////////////////////////////////
/// Name : Initial block 4.
/// Description : Generates serial clock (sclk) based on the baud rate.
////////////////////////////////////////////////////////////////////////////////////////
initial
begin
   SRIO_IF1.rx_sclk[0] = 0;
   forever
   begin
     if(`SRIO_SPEED == SRIO_125)
       #400ps SRIO_IF1.rx_sclk[0] = ~SRIO_IF1.rx_sclk[0];
     if(`SRIO_SPEED == SRIO_25)
       #200ps SRIO_IF1.rx_sclk[0] = ~SRIO_IF1.rx_sclk[0];
     if(`SRIO_SPEED == SRIO_3125)
       #160ps SRIO_IF1.rx_sclk[0] = ~SRIO_IF1.rx_sclk[0];
     if(`SRIO_SPEED == SRIO_5)
       #100ps SRIO_IF1.rx_sclk[0] = ~SRIO_IF1.rx_sclk[0];
     if(`SRIO_SPEED == SRIO_625)
       #80ps SRIO_IF1.rx_sclk[0] = ~SRIO_IF1.rx_sclk[0];
     if(`SRIO_SPEED == SRIO_103125)
       #48.5ps SRIO_IF1.rx_sclk[0] = ~SRIO_IF1.rx_sclk[0];
   end
end


////////////////////////////////////////////////////////////////////////////////////////
/// Name : Initial block 5.
/// Description : Generates parallel clock (pclk) based on the baud rate.
////////////////////////////////////////////////////////////////////////////////////////
initial
begin
   SRIO_IF1.rx_pclk[0] = 0;
   forever
   begin
     if(`SRIO_SPEED == SRIO_125)
       #4000ps SRIO_IF1.rx_pclk[0] = ~SRIO_IF1.rx_pclk[0];
     if(`SRIO_SPEED == SRIO_25)
       #2000ps SRIO_IF1.rx_pclk[0] = ~SRIO_IF1.rx_pclk[0];
     if(`SRIO_SPEED == SRIO_3125)
       #1600ps SRIO_IF1.rx_pclk[0] = ~SRIO_IF1.rx_pclk[0];
     if(`SRIO_SPEED == SRIO_5)
       #1000ps SRIO_IF1.rx_pclk[0] = ~SRIO_IF1.rx_pclk[0];
     if(`SRIO_SPEED == SRIO_625)
       #800ps SRIO_IF1.rx_pclk[0]  = ~SRIO_IF1.rx_pclk[0];
     if(`SRIO_SPEED == SRIO_103125)
       #3250ps SRIO_IF1.rx_pclk[0] = ~SRIO_IF1.rx_pclk[0];
   end
end


////////////////////////////////////////////////////////////////////////////////////////
/// Name : Initial block 6.
/// Description : Generates parallel clock (pclk) based on the baud rate.
////////////////////////////////////////////////////////////////////////////////////////
initial
begin
   SRIO_IF1.TSG_clk = 0;
   forever
   begin
     if(`SRIO_SPEED == SRIO_125)
       #4000ps SRIO_IF1.TSG_clk = ~SRIO_IF1.TSG_clk;
     if(`SRIO_SPEED == SRIO_25)
       #2000ps SRIO_IF1.TSG_clk = ~SRIO_IF1.TSG_clk;
     if(`SRIO_SPEED == SRIO_3125)
       #1600ps SRIO_IF1.TSG_clk = ~SRIO_IF1.TSG_clk;
     if(`SRIO_SPEED == SRIO_5)
       #1000ps SRIO_IF1.TSG_clk = ~SRIO_IF1.TSG_clk;
     if(`SRIO_SPEED == SRIO_625)
       #800ps SRIO_IF1.TSG_clk  = ~SRIO_IF1.TSG_clk;
     if(`SRIO_SPEED == SRIO_103125)
       #3250ps SRIO_IF1.TSG_clk = ~SRIO_IF1.TSG_clk;       
   end
end
////////////////////////////////////////////////////////////////////////////////////////
/// Name : Combinational always block 1.
/// Description : Assignes the serial clock generated for lane0 to all the lanes.
////////////////////////////////////////////////////////////////////////////////////////
always @(*)
begin
  
  for (int i=0;i<16;i++)
  begin //{ 
   SRIO_IF1.rx_sclk[i] <= SRIO_IF1.rx_sclk[0];
   SRIO_IF1.tx_sclk[i] <= SRIO_IF1.rx_sclk[0];
   SRIO_IF2.rx_sclk[i] <= SRIO_IF1.rx_sclk[0];
   SRIO_IF2.tx_sclk[i] <= SRIO_IF1.rx_sclk[0];
  end //}

end


////////////////////////////////////////////////////////////////////////////////////////
/// Name : Combinational always block 2.
/// Description : Assignes the sim_clk of env1 to sim_clk of env2.
////////////////////////////////////////////////////////////////////////////////////////
always @(*)
begin
  SRIO_IF2.sim_clk       <= SRIO_IF1.sim_clk;
end


////////////////////////////////////////////////////////////////////////////////////////
/// Name : Combinational always block 3.
/// Description : Assignes the parallel clock generated for lane0 to all the lanes.
////////////////////////////////////////////////////////////////////////////////////////
always @(*)
begin

  for (int i=0;i<16;i++)
  begin //{ 
   SRIO_IF1.rx_pclk[i] <= SRIO_IF1.rx_pclk[0];
   SRIO_IF1.tx_pclk[i] <= SRIO_IF1.rx_pclk[0];
   SRIO_IF2.rx_pclk[i] <= SRIO_IF1.rx_pclk[0];
   SRIO_IF2.tx_pclk[i] <= SRIO_IF1.rx_pclk[0];
  end //}

end


////////////////////////////////////////////////////////////////////////////////////////
/// Name : Combinational always block 4.
/// Description : Connects the serial transmit and receive data lines of env1 and env2.
////////////////////////////////////////////////////////////////////////////////////////
always @(*)
begin

  for (int i=0;i<16;i++)
  begin //{ 
   SRIO_IF1.rxp[i] <= SRIO_IF2.txp[i];
   SRIO_IF2.rxp[i] <= SRIO_IF1.txp[i];
   SRIO_IF1.rxn[i] <= SRIO_IF2.txn[i];
   SRIO_IF2.rxn[i] <= SRIO_IF1.txn[i];
  end //}

end

////////////////////////////////////////////////////////////////////////////////////////
/// Name : Combinational always block 5.
/// Description : Connects the parallel transmit and receive data lines of env1 and env2.
/// These set of parallel data are used in SRIO_GEN13, SRIO_GEN21 and SRIO_GEN22.
////////////////////////////////////////////////////////////////////////////////////////
always @(*)
begin

  for (int i=0;i<16;i++)
  begin //{ 
   SRIO_IF1.rx_pdata[i] <= SRIO_IF2.tx_pdata[i];
   SRIO_IF2.rx_pdata[i] <= SRIO_IF1.tx_pdata[i];
  end //}

end //}


////////////////////////////////////////////////////////////////////////////////////////
/// Name : Combinational always block 6.
/// Description : Connects the parallel transmit and receive data lines of env1 and env2.
/// These set of parallel data are used only in SRIO_GEN30.
////////////////////////////////////////////////////////////////////////////////////////
always @(*)
begin

  for (int i=0;i<16;i++)
  begin //{ 
   SRIO_IF1.gen3_rx_pdata[i] <= SRIO_IF2.gen3_tx_pdata[i];
   SRIO_IF2.gen3_rx_pdata[i] <= SRIO_IF1.gen3_tx_pdata[i];
  end //}

end

////////////////////////////////////////////////////////////////////////////////////////
/// Name : Combinational always block 7.
/// Description : Assignes the TSG_clk of env1 to TSG_clk of env2.
////////////////////////////////////////////////////////////////////////////////////////
always @(*)
begin
  SRIO_IF2.TSG_clk       <= SRIO_IF1.TSG_clk;
end
endmodule

