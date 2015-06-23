////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_base_test.sv
// Project : srio vip
// Purpose : SRIO Base test
// Author  : Mobiveil
//
// Base test for all tests.
//
////////////////////////////////////////////////////////////////////////////////

`include "uvm_macros.svh"

import uvm_pkg::*;              ///< Import UVM package
import srio_env_pkg::*;         ///< import SRIO ENV package
import srio_seq_lib_pkg::*;     ///< Import SRIO Sequence Library package

class srio_base_test extends uvm_test;

  `uvm_component_utils(srio_base_test)

  srio_env env1;                     ///< ENV1 instance
  srio_env env2;                     ///< ENV2 instance 
 
  srio_env_config env_config1;       ///< Config object for env1
  srio_env_config env_config2;       ///< Config object for env2
  srio_reg_block srio1_reg_model_tx; ///< Register model for ENV1's BFM
  srio_reg_block srio1_reg_model_rx; ///< Register model for ENV1's DUT
  srio_reg_block srio2_reg_model_tx; ///< Register model for ENV2's BFM
  srio_reg_block srio2_reg_model_rx; ///< Register model for ENV2's DUT

  integer env1_file_h;               ///< File handle for ENV1's tracker file
  integer env2_file_h;               ///< FIle handle for ENV2's tracker file  

  function new(string name, uvm_component parent=null);
    super.new(name, parent);
    uvm_reg::include_coverage("*",UVM_CVR_ALL);
  endfunction

  function void build_phase( uvm_phase phase );
    env_config1 = srio_env_config::type_id::create("srio_env_config",this);                    // Create env config object for env1
    uvm_config_db #(srio_env_config)::set(this,"*srio_env1*", "srio_env_config", env_config1); // Store the env1 config handle to config database
    env_config2 = srio_env_config::type_id::create("srio_env_config",this);                    // Create env config object for env2
    uvm_config_db #(srio_env_config)::set(this,"*srio_env2*", "srio_env_config", env_config2); // Store the env2 config handle to config database

    // Configure the important env config variables, getting the values from
    // RUN script
    `ifdef NUM_LANES   // Configure number of lanes
       env_config1.num_of_lanes = `NUM_LANES;
       env_config2.num_of_lanes = `NUM_LANES;
    `endif
    `ifdef SRIO_VER   // Configure SRIO Version
       env_config1.srio_mode = `SRIO_VER;
       env_config2.srio_mode = `SRIO_VER;
    `endif
    `ifdef SRIO_SPEED  // Configure link rate 
       env_config1.srio_baud_rate = `SRIO_SPEED;
       env_config2.srio_baud_rate = `SRIO_SPEED;
    `endif
    `ifdef CRF   // Configure CRF Support
       env_config1.crf_en = `CRF;
       env_config2.crf_en = `CRF;
    `endif
    `ifdef SRIO_DEVID  // Configure size of device id
       env_config1.srio_dev_id_size = `SRIO_DEVID;
       env_config2.srio_dev_id_size = `SRIO_DEVID;
    `endif
    `ifdef ADDR_MODE  // Configure addressing mode
       env_config1.srio_addr_mode = `ADDR_MODE;
       env_config2.srio_addr_mode = `ADDR_MODE;

       if ((env_config1.srio_addr_mode == SRIO_ADDR_50) ||
           (env_config1.srio_addr_mode == SRIO_ADDR_66))
       begin  
         env_config1.en_ext_addr_support = 1;
       end
       if ((env_config2.srio_addr_mode == SRIO_ADDR_50) ||
           (env_config2.srio_addr_mode == SRIO_ADDR_66))
       begin  
         env_config2.en_ext_addr_support = 1;
       end
    `endif

    // Register model for env1
    srio1_reg_model_tx     = srio_reg_block::type_id::create("srio1_reg_model_tx");

    `ifdef REG_MODEL_SET
      if (`REG_MODEL_SET == 2 || env_config1.srio_mode == SRIO_GEN30)
      begin //{
	env_config1.spec_support = V30;
        srio1_reg_model_tx.brc3 = 1;
      end //}
      else
      begin //{
	env_config1.spec_support = V22;
        srio1_reg_model_tx.brc3 = 0;
      end //}
    `else
      env_config1.spec_support = V22;
      srio1_reg_model_tx.brc3 = 0;
    `endif

    srio1_reg_model_tx.build();

    srio1_reg_model_rx     = srio_reg_block::type_id::create("srio1_reg_model_rx");

    `ifdef REG_MODEL_SET
      if (`REG_MODEL_SET == 2 || env_config1.srio_mode == SRIO_GEN30)
      begin //{
        srio1_reg_model_rx.brc3 = 1;
      end //}
      else
      begin //{
        srio1_reg_model_rx.brc3 = 0;
      end //}
    `else
      srio1_reg_model_rx.brc3 = 0;
    `endif

    srio1_reg_model_rx.build();

    // Register model for env2
    srio2_reg_model_tx     = srio_reg_block::type_id::create("srio2_reg_model_tx");

    `ifdef REG_MODEL_SET
      if (`REG_MODEL_SET == 2 || env_config2.srio_mode == SRIO_GEN30)
      begin //{
	env_config2.spec_support = V30;
        srio2_reg_model_tx.brc3 = 1;
      end //}
      else
      begin //{
	env_config2.spec_support = V22;
        srio2_reg_model_tx.brc3 = 0;
      end //}
    `else
      env_config2.spec_support = V22;
      srio2_reg_model_tx.brc3 = 0;
    `endif

    srio2_reg_model_tx.build();

    srio2_reg_model_rx     = srio_reg_block::type_id::create("srio2_reg_model_rx");

    `ifdef REG_MODEL_SET
      if (`REG_MODEL_SET == 2 || env_config2.srio_mode == SRIO_GEN30)
      begin //{
        srio2_reg_model_rx.brc3 = 1;
      end //}
      else
      begin //{
        srio2_reg_model_rx.brc3 = 0;
      end //}
    `else
      srio2_reg_model_rx.brc3 = 0;
    `endif

    srio2_reg_model_rx.build();
    
    // Task to configure the registers.User can program the required initial values
    // to the register in the same way
    config_srio_reg();
   
    // Store register model handles to env config
    env_config1.srio_reg_model_tx = srio1_reg_model_tx;
    env_config1.srio_reg_model_rx = srio1_reg_model_rx;
    env_config2.srio_reg_model_tx = srio2_reg_model_tx;
    env_config2.srio_reg_model_rx = srio2_reg_model_rx;

    // Create env1 and env2 instances
    env1 = srio_env::type_id::create("srio_env1", this );
    env2 = srio_env::type_id::create("srio_env2", this );

  endfunction

  function void connect_phase( uvm_phase phase );
    // Store the handles of individual layer's config to env config
    env_config1.ll_config = env1.ll_agent.ll_config;
    env_config1.tl_config = env1.tl_agent.tl_config;
    env_config1.pl_config = env1.pl_agent.pl_config;

    env_config2.ll_config = env2.ll_agent.ll_config;
    env_config2.tl_config = env2.tl_agent.tl_config;
    env_config2.pl_config = env2.pl_agent.pl_config;
    
    /// Tracker File handle creation 
    env1_file_h = $fopen("env1_srio_tracker.txt", "w");
    env2_file_h = $fopen("env2_srio_tracker.txt", "w");
    // Store file handles for transaction recording logics use 
    env_config1.file_h = env1_file_h;
    env_config2.file_h = env2_file_h;

    // Idle mode select
    `ifdef IDLE_SEL
       if (`IDLE_SEL == 2)
       begin // {  
         env_config1.pl_config.idle_sel = 1;
         env_config2.pl_config.idle_sel = 1;
       end // }
       else if (`IDLE_SEL == 1)  
       begin // {
         env_config1.pl_config.idle_sel = 0;
         env_config2.pl_config.idle_sel = 0;
       end // }
    `endif

    // Training mode select
    `ifdef TRAINING_MODE
       if (`TRAINING_MODE == 1)
       begin // {  
         env_config1.pl_config.brc3_training_mode = 1;
         env_config2.pl_config.brc3_training_mode = 1;
       end // }
       else if (`TRAINING_MODE == 0)  
       begin // {
         env_config1.pl_config.brc3_training_mode = 0;
         env_config2.pl_config.brc3_training_mode = 0;
       end // }
    `endif

    // Display important configuration values
    `uvm_info("SRIO_TEST", $sformatf("\n \
    DEVICE_CONFIGURATION ENV1 \n\
    --------------------------\n\
    No. of Lanes: %0d \n\
    Version     : %s  \n\
    Speed       : %s  \n\
    Device ID   : %s  \n\
    Address Mode: %s  \n\
    Idle_sel    : %0d (0->IDLE1 1->IDLE2)\n\
    Training_Mode: %0d \n", 
    env_config1.num_of_lanes, env_config1.srio_mode.name, env_config1.srio_baud_rate.name, 
    env_config1.srio_dev_id_size.name, env_config1.srio_addr_mode.name,env_config1.pl_config.idle_sel,env_config1.pl_config.brc3_training_mode), UVM_LOW);

    `uvm_info("SRIO_TEST", $sformatf("\n \
    DEVICE_CONFIGURATION ENV2: \n\
    --------------------------\n\
    No. of Lanes: %0d \n\
    Version     : %s  \n\
    Speed       : %s  \n\
    Device ID   : %s  \n\
    Address Mode: %s  \n\
    Idle_sel    : %0d (0->IDLE1 1->IDLE2)\n\
    Training_Mode: %0d \n", 
    env_config2.num_of_lanes, env_config2.srio_mode.name, env_config2.srio_baud_rate.name, 
    env_config2.srio_dev_id_size.name, env_config2.srio_addr_mode.name,env_config2.pl_config.idle_sel,env_config2.pl_config.brc3_training_mode), UVM_LOW);

  endfunction

// =============================================================================

  function void report_phase(uvm_phase phase);
  
    uvm_report_server reportServer = uvm_report_server::get_server();
    $display("=========================================================================");
    $display("");
    
    assert(reportServer.get_severity_count(UVM_FATAL) == 0 && reportServer.get_severity_count(UVM_ERROR) == 0) 
      $display("                      ***   TESTCASE PASSED   ***");
    else 
      $display("                      ***   TESTCASE FAILED   ***");
  
    $display("");
    $display("=========================================================================");
  endfunction : report_phase

// =============================================================================

    //The below task configures the basic register fields of srio
    function void config_srio_reg();
      bit [31:0]  pef_car;
      void'(srio1_reg_model_tx.Destination_Operations_CAR.predict(32'h3FFF_33FF));
      void'(srio1_reg_model_tx.Source_Operations_CAR.predict(32'h3FFF_33FF));
      void'(srio1_reg_model_rx.Destination_Operations_CAR.predict(32'h3FFF_33FF));
      void'(srio1_reg_model_rx.Source_Operations_CAR.predict(32'h3FFF_33FF));

      pef_car = 32'h0100_0010; // Bit[19] = 0  Bit[27] = 0
      `ifdef SRIO_DEVID
        case (env_config1.srio_dev_id_size)
          SRIO_DEVID_32: pef_car = 32'h0108_0010; // Bit[19] = 1
          SRIO_DEVID_16: pef_car = 32'h0900_0010; // Bit[27] = 1
        endcase
      `endif

      void'(srio1_reg_model_tx.Processing_Element_Features_CAR.predict(pef_car));
      void'(srio1_reg_model_rx.Processing_Element_Features_CAR.predict(pef_car));
      void'(srio2_reg_model_tx.Destination_Operations_CAR.predict(32'h3FFF_33FF));
      void'(srio2_reg_model_tx.Source_Operations_CAR.predict(32'h3FFF_33FF));
      void'(srio2_reg_model_rx.Destination_Operations_CAR.predict(32'h3FFF_33FF));
      void'(srio2_reg_model_rx.Source_Operations_CAR.predict(32'h3FFF_33FF));
      void'(srio2_reg_model_tx.Processing_Element_Features_CAR.predict(pef_car));
      void'(srio2_reg_model_rx.Processing_Element_Features_CAR.predict(pef_car));
      void'(srio1_reg_model_tx.Data_Streaming_Logical_Layer_Control_CSR.TM_Types_Supported.predict(4'b0111));
      void'(srio1_reg_model_rx.Data_Streaming_Logical_Layer_Control_CSR.TM_Types_Supported.predict(4'b0111));
      void'(srio2_reg_model_tx.Data_Streaming_Logical_Layer_Control_CSR.TM_Types_Supported.predict(4'b0111));
      void'(srio2_reg_model_rx.Data_Streaming_Logical_Layer_Control_CSR.TM_Types_Supported.predict(4'b0111));

      // Enable to all LL Error detection
      void'(srio1_reg_model_tx.Logical_Transport_Layer_Error_Enable_CSR.predict(32'h0000_7FFF));
      void'(srio1_reg_model_rx.Logical_Transport_Layer_Error_Enable_CSR.predict(32'h0000_7FFF));
      void'(srio2_reg_model_tx.Logical_Transport_Layer_Error_Enable_CSR.predict(32'h0000_7FFF));
      void'(srio2_reg_model_rx.Logical_Transport_Layer_Error_Enable_CSR.predict(32'h0000_7FFF));
     // SegSupport = 256
      void'(srio1_reg_model_tx.Data_Streaming_Information_CAR.SegSupport.predict(16'h0080));
      void'(srio1_reg_model_rx.Data_Streaming_Information_CAR.SegSupport.predict(16'h0080));
      void'(srio2_reg_model_tx.Data_Streaming_Information_CAR.SegSupport.predict(16'h0080));
      void'(srio2_reg_model_rx.Data_Streaming_Information_CAR.SegSupport.predict(16'h0080));
      if (env_config1.srio_mode == SRIO_GEN13)
      begin //{
        void'(srio1_reg_model_tx.Port_0_Control_CSR.predict(32'h8000_0602));
        void'(srio1_reg_model_rx.Port_0_Control_CSR.predict(32'h8000_0602));
      end //}
      else
      begin //{
        void'(srio1_reg_model_tx.Port_0_Error_and_Status_CSR.predict(32'h0000_0003));
        void'(srio1_reg_model_tx.Port_0_Control_CSR.predict(32'h800C_0603));
        void'(srio1_reg_model_tx.Port_0_Control_2_CSR.predict(32'hC000_FFC0));
        void'(srio1_reg_model_rx.Port_0_Error_and_Status_CSR.predict(32'h0000_0003));
        void'(srio1_reg_model_rx.Port_0_Control_CSR.predict(32'h800C_0603));
        void'(srio1_reg_model_rx.Port_0_Control_2_CSR.predict(32'hC000_FFC0));
      end //}

      if (env_config2.srio_mode == SRIO_GEN13)
      begin //{
        void'(srio2_reg_model_tx.Port_0_Control_CSR.predict(32'h8000_0602));
        void'(srio2_reg_model_rx.Port_0_Control_CSR.predict(32'h8000_0602));
      end //}
      else
      begin //{
        void'(srio2_reg_model_tx.Port_0_Error_and_Status_CSR.predict(32'h0000_0003));
        void'(srio2_reg_model_tx.Port_0_Control_CSR.predict(32'h800C_0603));
        void'(srio2_reg_model_tx.Port_0_Control_2_CSR.predict(32'hC000_FFC0));
        void'(srio2_reg_model_rx.Port_0_Error_and_Status_CSR.predict(32'h0000_0003));
        void'(srio2_reg_model_rx.Port_0_Control_CSR.predict(32'h800C_0603));
        void'(srio2_reg_model_rx.Port_0_Control_2_CSR.predict(32'hC000_FFC0));
      end //}

    endfunction

    task run_phase(uvm_phase phase);
     super.run_phase(phase);
    endtask:run_phase
  endclass



