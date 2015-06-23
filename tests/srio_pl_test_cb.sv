////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_callback.sv
// Project :  srio vip
// Purpose :  Physical Layer Call Back
// Author  :  Mobiveil
//
// Logical Layer BFM component.
//
//////////////////////////////////////////////////////////////////////////////// 

class srio_pl_tx_cb extends srio_pl_callback; 

function new (string name = "srio_pl_tx_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_tx_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
     
   tx_srio_cg.cg =10'h100;
     endtask 

endclass : srio_pl_tx_cb 

class srio_pl_rx_cb extends srio_pl_callback; 

function new (string name = "srio_pl_rx_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_rx_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_received_lane0 (ref srio_pl_lane_data rx_srio_cg,srio_env_config env_config);
   
   
   rx_srio_cg.cg  = 10'h0EF;
  
endtask 

endclass : srio_pl_rx_cb 

//=== SYNC BREAK 

class srio_pl_sync_break_callback extends srio_pl_callback; 
int temp0 =0,temp1 = 0,temp2 =0 ,temp3 =0,temp4 =0,temp5 =0,temp6 =0,temp7 =0,temp8 =0,temp9 =0,temp10 =0,temp11 =0,temp12 =0,temp13 =0,temp14 =0,temp15 =0 ;

function new (string name = "srio_pl_sync_break_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_sync_break_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
     if(temp0 ==0 ) begin //{  
   tx_srio_cg.cg =10'h100;
    temp0 =1;
    end //}
 end //}
     endtask 

virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
     if(temp1 ==0 ) begin //{  
   tx_srio_cg.cg =10'h100;
    temp1 =1;
    end //}
 end //}
     endtask 
virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
     if(temp2 ==0 ) begin //{  
   tx_srio_cg.cg =10'h100;
    temp2 =1;
    end //}
 end //}
     endtask 
virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
     if(temp3 ==0 ) begin //{  
   tx_srio_cg.cg =10'h100;
    temp3 =1;
    end //}
 end //}
     endtask 
virtual task srio_pl_cg_generated_lane4 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
     if(temp4 ==0 ) begin //{  
   tx_srio_cg.cg =10'h100;
    temp4 =1;
    end //}
 end //}
     endtask 
virtual task srio_pl_cg_generated_lane5 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
     if(temp5 ==0 ) begin //{  
   tx_srio_cg.cg =10'h100;
    temp5 =1;
    end //}
 end //}
     endtask 
virtual task srio_pl_cg_generated_lane6 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
     if(temp6 ==0 ) begin //{  
   tx_srio_cg.cg =10'h100;
    temp6 =1;
    end //}
 end //}
     endtask 
virtual task srio_pl_cg_generated_lane7 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
     if(temp7 ==0 ) begin //{  
   tx_srio_cg.cg =10'h100;
    temp7 =1;
    end //}
 end //}
     endtask 
virtual task srio_pl_cg_generated_lane8 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
     if(temp8 ==0 ) begin //{  
   tx_srio_cg.cg =10'h100;
    temp8 =1;
    end //}
 end //}
     endtask 
virtual task srio_pl_cg_generated_lane9 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
     if(temp9 ==0 ) begin //{  
   tx_srio_cg.cg =10'h100;
    temp9 =1;
    end //}
 end //}
     endtask 
virtual task srio_pl_cg_generated_lane10 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
     if(temp10 ==0 ) begin //{  
   tx_srio_cg.cg =10'h100;
    temp10 =1;
    end //}
 end //}
     endtask 
virtual task srio_pl_cg_generated_lane11 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
     if(temp11 ==0 ) begin //{  
   tx_srio_cg.cg =10'h100;
    temp11 =1;
    end //}
 end //}
     endtask 
virtual task srio_pl_cg_generated_lane12 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
     if(temp12 ==0 ) begin //{  
   tx_srio_cg.cg =10'h100;
    temp12 =1;
    end //}
 end //}
     endtask 
virtual task srio_pl_cg_generated_lane13 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
     if(temp13 ==0 ) begin //{  
   tx_srio_cg.cg =10'h100;
    temp13 =1;
    end //}
 end //}
     endtask 
virtual task srio_pl_cg_generated_lane14 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
     if(temp14 ==0 ) begin //{  
   tx_srio_cg.cg =10'h100;
    temp14 =1;
    end //}
 end //}
     endtask 
virtual task srio_pl_cg_generated_lane15 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
     if(temp15 ==0 ) begin //{  
   tx_srio_cg.cg =10'h100;
    temp15 =1;
    end //}
 end //}
     endtask 

endclass : srio_pl_sync_break_callback

//================================================================================ 
//== callback to breqk sync of lane 0 ,2,3 ===========dto1xm1=== 1xmode_ln1_sl==== 
//================================================================================ 

class srio_pl_sync0_sync2_break_callback extends srio_pl_callback;

bit flag ;
int cnt = 0;
 
function new (string name = "srio_pl_sync0_sync2_break_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_sync0_sync2_break_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if(flag == 1)
   begin //{
    cnt = cnt+1;
   if(env_config.srio_mode == SRIO_GEN30 && cnt == 1024) begin //{
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
    cnt = 0;
    end //}
  end //}
endtask 

virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(env_config.srio_mode == SRIO_GEN30 && flag == 1) begin //{
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
end
endtask 

virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(env_config.srio_mode == SRIO_GEN30 && flag == 1) begin //{
   tx_srio_cg.cg =10'h100;
   tx_srio_cg.brc3_cg ='h0;
   end
endtask 

endclass : srio_pl_sync0_sync2_break_callback


//=================================================================== 
//======callback to break sync of lane 1,,2,3 =========dto1xm0======= 
//=================================================================== 

class srio_pl_sync1_sync2_break_callback extends srio_pl_callback; 

function new (string name = "srio_pl_sync1_sync2_break_callback");
super.new(name); 
endfunction 
static string type_name = "srio_pl_sync1_sync2_break_callback"; 
virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 

virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 

virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 

endclass : srio_pl_sync1_sync2_break_callback 

//=====================================================================
//=======callback to break sync of lanes 0,1,3 =========dto1xm2======== 
//===================================================================== 

class srio_pl_sync0_sync1_break_callback extends srio_pl_callback; 

function new (string name = "srio_pl_sync0_sync1_break_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_sync0_sync1_break_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 

virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 

virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 
endclass : srio_pl_sync0_sync1_break_callback

 //=== ALIGN ERROR 

class srio_pl_align_error_callback extends srio_pl_callback; 
int temp =0;
function new (string name = "srio_pl_align_error_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_align_error_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 
 
virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
        if (temp ==0) begin //{
          if ((tx_srio_cg.cg == 10'hFA) || (tx_srio_cg.cg == 10'h305) || (tx_srio_cg.cg == 10'h2E8) ||  (tx_srio_cg.cg == 10'h117) || (tx_srio_cg.cg == 10'h368) || (tx_srio_cg.cg == 10'h97) || (tx_srio_cg.cg == 10'hF9) ||  (tx_srio_cg.cg == 10'h306))  begin //{ 
         tx_srio_cg.cg = 10'h100;
         temp =1;
   end //}
   end //}
 end //}
     endtask

endclass : srio_pl_align_error_callback
///=== ALIGN ERROR 2 TIMES
class srio_pl_align_error_2_sm_callback extends srio_pl_callback; 
int temp =0 ;
int flag;
function new (string name = "srio_pl_align_error_2_sm_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_align_error_2_sm_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 
 
virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
    if (temp ==0) 
    begin //{
    if ((tx_srio_cg.cg == 10'hFA) || (tx_srio_cg.cg == 10'h305) || (tx_srio_cg.cg == 10'h2E8) ||  (tx_srio_cg.cg == 10'h117) || (tx_srio_cg.cg == 10'h368) || (tx_srio_cg.cg == 10'h97) || (tx_srio_cg.cg == 10'hF9) ||  (tx_srio_cg.cg == 10'h306)) 
    begin //{ 
             if (flag ==2)  begin //{
               temp =1;              
              end //} 
             else  begin //{
               tx_srio_cg.cg = 10'h100;
               flag++;
              end //}
   end //}
   end //} 
 end //}
     endtask
endclass : srio_pl_align_error_2_sm_callback

// 7C TO 1C DELIMITER CHANGES FOR ANY LINK REQUEST BEFORE THE PACKET WITHOUT END DELIMTER

class srio_pl_delimiter_7c_to_1c_cb extends srio_pl_callback; 
rand bit [0:3] stype1_1;
function new (string name = "srio_pl_delimiter_7c_to_1c_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_delimiter_7c_to_1c_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_trans_generated(ref srio_trans tx_srio_trans);
//if ((env_config.pl_rx_mon_init_sm_state = NX_MODE) && (env_config.pl_tx_mon_init_sm_state = NX_MODE))  begin //{
      if ((tx_srio_trans.transaction_kind == SRIO_PACKET) &&( tx_srio_trans.cs_kind == SRIO_DELIM_PD)) begin //{
      if((tx_srio_trans.stype1 == 4'd0) || (tx_srio_trans.stype1 == 4'd3) || (tx_srio_trans.stype1 == 4'd4)) begin //{
    tx_srio_trans.transaction_kind = SRIO_CS;
    tx_srio_trans.cs_kind = SRIO_DELIM_SC;
    
   end //}
   end //}
 //end //}
endtask 
endclass

//===================================================================================== 
// callback to break sync of lane 0,1,3 ;; and of lane 2(condition based)== distosil ==
//===================================================================================== 

class srio_pl_sync0_sync1_sync2_break_callback extends srio_pl_callback; 
bit lane_break_flag;
bit corruption_started;

function new (string name = "srio_pl_sync0_sync1_sync2_break_callback"); super.new(name); 
lane_break_flag = 1;endfunction 


static string type_name = "srio_pl_sync0_sync1_sync2_break_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
    if( lane_break_flag == 1'b1) begin //{
      tx_srio_cg.cg =10'h100;
      tx_srio_cg.brc3_cg ='h0;
    end  //}
endtask 

virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
    if(lane_break_flag == 1'b1) begin //{
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
    end //}
endtask 


virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
if(lane_break_flag ==1'b1) begin //{
  if (env_config.pl_tx_mon_init_sm_state == DISCOVERY && env_config.pl_rx_mon_init_sm_state ==DISCOVERY)
  begin
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
    corruption_started = 1;
  end
  if (corruption_started && env_config.pl_tx_mon_init_sm_state == SILENT && env_config.pl_rx_mon_init_sm_state == SILENT)
  begin
    lane_break_flag = 0;
    corruption_started = 0;
  end 
end  //}
endtask 


virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(lane_break_flag ==1'b1) begin //{
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
 end  //}

endtask 
endclass : srio_pl_sync0_sync1_sync2_break_callback

///=== ALIGN STATE MACHINE
class srio_pl_align_sm_callback extends srio_pl_callback; 
int temp =0 ;
int flag;
function new (string name = "srio_pl_align_sm_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_align_sm_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 
 
virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
    if (temp ==0) 
    begin //{
    if ((tx_srio_cg.cg == 10'hFA) || (tx_srio_cg.cg == 10'h305) || (tx_srio_cg.cg == 10'h2E8) ||  (tx_srio_cg.cg == 10'h117) || (tx_srio_cg.cg == 10'h368) || (tx_srio_cg.cg == 10'h97) || (tx_srio_cg.cg == 10'hF9) ||  (tx_srio_cg.cg == 10'h306)) 
    begin //{ 
             if (flag ==3)  begin //{
               temp =1;              
              end //} 
             else  begin //{
               tx_srio_cg.cg = 10'h100;
               flag++;
              end //}
   end //}
   end //} 
 end //}
     endtask
endclass : srio_pl_align_sm_callback

//=====================================================================
//callback to break sync on lane 1,2,3 ;;1xln0 to 1x_recovery =========
//=====================================================================
class srio_pl_sync1_sync2_break_cb extends srio_pl_callback; 
bit lane_break ;

function new (string name = "srio_pl_sync1_sync2_break_cb"); 
super.new(name); 
lane_break = 1'b1;
endfunction 

static string type_name = "srio_pl_sync1_sync2_break_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 

virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 

virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 
endclass : srio_pl_sync1_sync2_break_cb 


//========================-========================================
// callback to break sync of lane 0,2,3 ;;1xln1 to 1x_rec==========
//=================================================================



class srio_pl_sync0_sync2_break_cb extends srio_pl_callback; 
bit lane_break ;

function new (string name = "srio_pl_sync0_sync2_break_cb"); 
super.new(name); 
lane_break = 1'b1;
endfunction 

static string type_name = "srio_pl_sync0_sync2_break_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(env_config.srio_mode == SRIO_GEN30) begin //{
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
   end
endtask 

virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(env_config.srio_mode == SRIO_GEN30) begin //{
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
  end
endtask 

virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(env_config.srio_mode == SRIO_GEN30) begin //{
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
end
endtask 


endclass : srio_pl_sync0_sync2_break_cb

//==================================================================
//= callback o break sync of lane 0,1,3 ;; 1xln2 to 1x_rec =========
//==================================================================


class srio_pl_sync0_sync1_break_cb extends srio_pl_callback; 

function new (string name = "srio_pl_sync0_sync1_break_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_sync0_sync1_break_cb"; 
bit lane_break; 

virtual function string get_type_name(); 
return type_name; 
lane_break =1'b1;
endfunction 

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 

virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 

virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 

virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == X1_M0 && env_config.pl_rx_mon_init_sm_state == X1_M0 && lane_break ) begin //{ 
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
     lane_break = 1'b0 ;
end //}
endtask 

endclass : srio_pl_sync0_sync1_break_cb

///=== ALIGN TO ALIGNED_1 TO NOT ALIGNED

class srio_pl_align1_notaligned_sm_callback extends srio_pl_callback; 
int temp =0 ;
int flag = 0;

function new (string name = "srio_pl_align1_notaligned_sm_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_align1_notaligned_sm_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 
virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
        if (temp ==0) begin //{   
          if ((tx_srio_cg.cg == 10'hFA) || (tx_srio_cg.cg == 10'h305) || (tx_srio_cg.cg == 10'h2E8) ||  (tx_srio_cg.cg == 10'h117) || (tx_srio_cg.cg == 10'h368) || (tx_srio_cg.cg == 10'h97) || (tx_srio_cg.cg == 10'hF9) ||  (tx_srio_cg.cg == 10'h306))  begin //{ 
         tx_srio_cg.cg = 10'h100;
         flag ++;
          end //}
   if(flag == 4) begin //{
   temp = 1;
     end //}
  end //}
 end //}
endtask
endclass : srio_pl_align1_notaligned_sm_callback

// SYNC CALLBACK

class srio_pl_sync_sm_callback extends srio_pl_callback; 
int temp0 =0,temp1 = 0,temp2 =0 ,temp3 =0,temp4 =0,temp5 =0,temp6 =0,temp7 =0,temp8 =0,temp9 =0,temp10 =0,temp11 =0,temp12 =0,temp13 =0,temp14 =0,temp15 =0 ;
int flag0 =0,flag1 = 0,flag2 =0 ,flag3 =0,flag4 =0,flag5 =0,flag6 =0,flag7 =0,flag8 =0,flag9 =0,flag10 =0,flag11 =0,flag12 =0,flag13 =0,flag14 =0,flag15 =0 ;
function new (string name = "srio_pl_sync_sm_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_sync_sm_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 
virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
  if (temp0 ==0) begin //{       
  tx_srio_cg.cg = 10'h100;
  flag0 ++;  
  end //}
  if(flag0 == 4) begin //{
  temp0 = 1;
    end //}
  end //}
endtask
virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
  if (temp1 ==0) begin //{       
  tx_srio_cg.cg = 10'h100;
  flag1 ++;  
  end //}
  if(flag1 == 4) begin //{
  temp1 = 1;

  end //}
  end //}
endtask
virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
  if (temp2 ==0) begin //{       
  tx_srio_cg.cg = 10'h100;
  flag2 ++;  
  end //}
  if(flag2 == 4) begin //{
  temp2 = 1;

  end //}
  end //}
endtask
virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
  if (temp3 ==0) begin //{       
  tx_srio_cg.cg = 10'h100;
  flag3 ++;  
  end //}
  if(flag3 == 4) begin //{
  temp3 = 1;

  end //}
  end //}
endtask
virtual task srio_pl_cg_generated_lane4 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
  if (temp4 ==0) begin //{       
  tx_srio_cg.cg = 10'h100;
  flag4 ++;  
  end //}
  if(flag4 == 4) begin //{
  temp4 = 1;
  end //}
  end //}
endtask
virtual task srio_pl_cg_generated_lane5 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
  if (temp5 ==0) begin //{       
  tx_srio_cg.cg = 10'h100;
  flag5 ++;  
  end //}
  if(flag5 == 4) begin //{
  temp5 = 1;

  end //}
  end //}
endtask
virtual task srio_pl_cg_generated_lane6 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
  if (temp6 ==0) begin //{       
  tx_srio_cg.cg = 10'h100;
  flag6 ++;  
  end //}
  if(flag6 == 4) begin //{
  temp6 = 1;
  end //}
  end //}
endtask
virtual task srio_pl_cg_generated_lane7 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
  if (temp7 ==0) begin //{       
  tx_srio_cg.cg = 10'h100;
  flag7 ++;  
  end //}
  if(flag7 == 4) begin //{
  temp7 = 1;
  end //}
  end //}
endtask
virtual task srio_pl_cg_generated_lane8 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
  if (temp8 ==0) begin //{       
  tx_srio_cg.cg = 10'h100;
  flag8 ++;  
  end //}
  if(flag8 == 4) begin //{
  temp8 = 1;

  end //}
  end //}
endtask
virtual task srio_pl_cg_generated_lane9 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
  if (temp9 ==0) begin //{       
  tx_srio_cg.cg = 10'h100;
  flag9 ++;  
  end //}
  if(flag9 == 4) begin //{
  temp9 = 1;

  end //}
  end //}
endtask
virtual task srio_pl_cg_generated_lane10 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
  if (temp10 ==0) begin //{       
  tx_srio_cg.cg = 10'h100;
  flag10 ++;  
  end //}
  if(flag10 == 4) begin //{
  temp10 = 1;
  end //}
  end //}
endtask
virtual task srio_pl_cg_generated_lane11 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
  if (temp11 ==0) begin //{       
  tx_srio_cg.cg = 10'h100;
  flag11 ++;  
  end //}
  if(flag11 == 4) begin //{
  temp11 = 1;


  end //}
  end //}
endtask
virtual task srio_pl_cg_generated_lane12 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
  if (temp12 ==0) begin //{       
  tx_srio_cg.cg = 10'h100;
  flag12 ++;  
  end //}
  if(flag12 == 4) begin //{
  temp12 = 1;

  end //}
  end //}
endtask
virtual task srio_pl_cg_generated_lane13 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
  if (temp13 ==0) begin //{       
  tx_srio_cg.cg = 10'h100;
  flag13 ++;  
  end //}
  if(flag13 == 4) begin //{
  temp13 = 1;

  end //}
  end //}
endtask
virtual task srio_pl_cg_generated_lane14 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
  if (temp14 ==0) begin //{       
  tx_srio_cg.cg = 10'h100;
  flag14 ++;  
  end //}
  if(flag14 == 4) begin //{
  temp14 = 1;
  end //}
  end //}
endtask
virtual task srio_pl_cg_generated_lane15 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
  if (temp15 ==0) begin //{       
  tx_srio_cg.cg = 10'h100;
  flag15 ++;  
  end //}
  if(flag15 == 4) begin //{
  temp15 = 1;


  end //}
  end //}
endtask
endclass : srio_pl_sync_sm_callback


//===========================================================
//== callback to break sync on lane 2 and 3 ==for 2xmode=====
//===========================================================

class srio_pl_sync0_break_cb extends srio_pl_callback; 
function new (string name = "srio_pl_sync0_break_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_sync0_break_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask

virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 


endclass : srio_pl_sync0_break_cb

//============================================================================= 
//==callback to break sync on lane 0,1,2 and 3(condition based) = 1xrectosl====
//============================================================================= 

class srio_pl_sync1_sync2_break_cb1 extends srio_pl_callback; 
bit lane_break;
bit lane_currupt;

function new (string name = "srio_pl_sync1_sync2_break_cb1"); 
super.new(name);
lane_break = 1'b1; 
endfunction 

static string type_name = "srio_pl_sync1_sync2_break_cb1"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 


virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if (env_config.pl_tx_mon_init_sm_state == X1_RECOVERY && env_config.pl_rx_mon_init_sm_state == X1_RECOVERY && lane_break ) begin //{ 
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
    lane_currupt = 1'b1;
end 

  if (env_config.pl_tx_mon_init_sm_state == SILENT && env_config.pl_rx_mon_init_sm_state == SILENT && lane_currupt ) begin //{ 
         lane_currupt = 1'b0;
         lane_break = 1'b0;
  end
endtask

virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 

virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 

virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 

endclass : srio_pl_sync1_sync2_break_cb1 


//=========================================================================
//===CB to break sync on lane 2,3 and 0(condition base)====== 2xrecto1xm1 =
//=========================================================================


class srio_pl_sync0_brk_cb extends srio_pl_callback; 
bit lane_break ;

function new (string name = "srio_pl_sync0_brk_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_sync0_brk_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == X2_MODE && env_config.pl_rx_mon_init_sm_state == X2_MODE  ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;

 end //}
 if (env_config.pl_tx_mon_init_sm_state == X2_RECOVERY && env_config.pl_rx_mon_init_sm_state == X2_RECOVERY  ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
end //}
 if (env_config.pl_tx_mon_init_sm_state == X1_M1 && env_config.pl_rx_mon_init_sm_state == X1_M1  ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
end //}
endtask 


virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask

virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask


endclass : srio_pl_sync0_brk_cb

//=====================================================================
//================================= 2xrectosl==========================
//=====================================================================

class srio_pl_sync0_sync1_brk_cb extends srio_pl_callback; 

bit lane_break;
bit lane_currupt ;
function new (string name = "srio_pl_sync0_sync1_brk_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_sync0_sync1_brk_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
if (env_config.pl_tx_mon_init_sm_state == X2_RECOVERY && env_config.pl_rx_mon_init_sm_state == X2_RECOVERY  ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
end //}
endtask 

virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == X2_RECOVERY && env_config.pl_rx_mon_init_sm_state == X2_RECOVERY  ) begin //{ 
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
end //}
endtask 

virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;

 if (env_config.pl_tx_mon_init_sm_state == X2_MODE && env_config.pl_rx_mon_init_sm_state == X2_MODE  ) begin //{ 
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
 end

endtask

virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;

 if (env_config.pl_tx_mon_init_sm_state == X2_MODE && env_config.pl_rx_mon_init_sm_state == X2_MODE  ) begin //{ 
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
 end

endtask

endclass : srio_pl_sync0_sync1_brk_cb

///=== ALIGN STATE MACHINE FOR ALIGNED_1 - ALIGNED_2 - ALIGNED_2


class srio_pl_gen2_a1_a2_a2_sm_callback extends srio_pl_callback; 
int temp =0 ;
int flag;
function new (string name = "srio_pl_gen2_a1_a2_a2_sm_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_gen2_a1_a2_a2_sm_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 
 
virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
    if (temp ==0) 
    begin //{
    if ((tx_srio_cg.cg == 10'hFA) || (tx_srio_cg.cg == 10'h305) || (tx_srio_cg.cg == 10'h2E8) ||  (tx_srio_cg.cg == 10'h117) || (tx_srio_cg.cg == 10'h368) || (tx_srio_cg.cg == 10'h97) || (tx_srio_cg.cg == 10'hF9) ||  (tx_srio_cg.cg == 10'h306)) 
    begin //{ 
             if (flag ==2)  begin //{
               temp =1;              
              end //} 
             else  begin //{
               tx_srio_cg.cg = 10'h100;
               flag++;
              end //}
   end //}
   end //} 
 end //}
     endtask
endclass : srio_pl_gen2_a1_a2_a2_sm_callback
// SYNC CALLBACK -- NO_SYNC1-NO_SYNC_1-NO_SYNC_1-N0_SYNC_2

class srio_pl_ns1_ns2_ns1_ns2_sm_callback extends srio_pl_callback; 

int temp0 =0,temp1 = 0,temp2 =0 ,temp3 =0,temp4 =0,temp5 =0,temp6 =0,temp7 =0,temp8 =0,temp9 =0,temp10 =0,temp11 =0,temp12 =0,temp13 =0,temp14 =0,temp15 =0 ;
rand bit sel;

srio_pl_agent pl_agent_cb ;

static string type_name = "srio_pl_ns1_ns2_ns1_ns2_sm_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 
virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[0].current_sync_state == NO_SYNC_1) begin //{ 
   if(temp0 == 0) begin //{
    sel = $urandom;
    tx_srio_cg.cg = sel ? 10'hFA :10'h305 ;
  
    temp0 = 1;
    end //}
   end //}
endtask
virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[1].current_sync_state == NO_SYNC_1) begin //{ 
   if(temp1 == 0) begin //{
   sel = $urandom;
    tx_srio_cg.cg = sel ? 10'hFA :10'h305 ;
    temp1 = 1;
    end //}
   end //}
endtask
virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[2].current_sync_state == NO_SYNC_1) begin //{ 
   if(temp2 == 0) begin //{
   sel = $urandom;
    tx_srio_cg.cg = sel ? 10'hFA :10'h305 ; 
    temp2 = 1;
    end //}
   end //}
endtask
virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[3].current_sync_state == NO_SYNC_1) begin //{ 
   if(temp3 == 0) begin //{
   sel = $urandom;
    tx_srio_cg.cg = sel ? 10'hFA :10'h305 ;
    temp3 = 1;
    end //}
   end //}
endtask
virtual task srio_pl_cg_generated_lane4 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[4].current_sync_state == NO_SYNC_1) begin //{ 
   if(temp4 == 0) begin //{
   sel = $urandom;
    tx_srio_cg.cg = sel ? 10'hFA :10'h305 ;
    temp4 = 1;
    end //}
   end //}
endtask
virtual task srio_pl_cg_generated_lane5 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[5].current_sync_state == NO_SYNC_1) begin //{ 
   if(temp5 == 0) begin //{
   sel = $urandom;
    tx_srio_cg.cg = sel ? 10'hFA :10'h305 ;
    temp5 = 1;
    end //}
   end //}
endtask
virtual task srio_pl_cg_generated_lane6 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[6].current_sync_state == NO_SYNC_1) begin //{ 
   if(temp6 == 0) begin //{
   sel = $urandom;
    tx_srio_cg.cg = sel ? 10'hFA :10'h305 ;
    temp6 = 1;
    end //}
   end //}
endtask
virtual task srio_pl_cg_generated_lane7 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[7].current_sync_state == NO_SYNC_1) begin //{ 
   if(temp7 == 0) begin //{
   sel = $urandom;
    tx_srio_cg.cg = sel ? 10'hFA :10'h305 ;
    temp7 = 1;
    end //}
   end //}
endtask
virtual task srio_pl_cg_generated_lane8 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[8].current_sync_state == NO_SYNC_1) begin //{ 
   if(temp8 == 0) begin //{
   sel = $urandom;
    tx_srio_cg.cg = sel ? 10'hFA :10'h305 ;
    temp8 = 1;
    end //}
   end //}
endtask
virtual task srio_pl_cg_generated_lane9 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[9].current_sync_state == NO_SYNC_1) begin //{ 
   if(temp9 == 0) begin //{
   sel = $urandom;
    tx_srio_cg.cg = sel ? 10'hFA :10'h305 ;
    temp9 = 1;
    end //}
   end //}
endtask
virtual task srio_pl_cg_generated_lane10 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[10].current_sync_state == NO_SYNC_1) begin //{ 
   if(temp10 == 0) begin //{
   sel = $urandom;
    tx_srio_cg.cg = sel ? 10'hFA :10'h305 ;
    temp10 = 1;
    end //}
   end //}
endtask
virtual task srio_pl_cg_generated_lane11 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[11].current_sync_state == NO_SYNC_1) begin //{ 
   if(temp11 == 0) begin //{
   sel = $urandom;
    tx_srio_cg.cg = sel ? 10'hFA :10'h305 ;
    temp11 = 1;
    end //}
   end //}
endtask
virtual task srio_pl_cg_generated_lane12 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[12].current_sync_state == NO_SYNC_1) begin //{ 
   if(temp12 == 0) begin //{
   sel = $urandom;
    tx_srio_cg.cg = sel ? 10'hFA :10'h305 ;
    temp12 = 1;
    end //}
   end //}
endtask
virtual task srio_pl_cg_generated_lane13 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[13].current_sync_state == NO_SYNC_1) begin //{ 
   if(temp13 == 0) begin //{
   sel = $urandom;
    tx_srio_cg.cg = sel ? 10'hFA :10'h305 ;
    temp13 = 1;
    end //}
   end //}
endtask
virtual task srio_pl_cg_generated_lane14 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[14].current_sync_state == NO_SYNC_1) begin //{ 
   if(temp14 == 0) begin //{
   sel = $urandom;
    tx_srio_cg.cg = sel ? 10'hFA :10'h305 ;
    temp14 = 1;
    end //}
   end //}
endtask
virtual task srio_pl_cg_generated_lane15 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[15].current_sync_state == NO_SYNC_1) begin //{ 
   if(temp15 == 0) begin //{
   sel = $urandom;
   tx_srio_cg.cg = sel ? 10'hFA :10'h305 ;
    temp15 = 1;
    end //}
   end //}
endtask
endclass : srio_pl_ns1_ns2_ns1_ns2_sm_callback

//===========================================================
//== Nx recovery to 1xm0 state mode ;; break lane(1) ========
//===========================================================

class srio_pl_sync1_brk_cb extends srio_pl_callback; 

function new (string name = "srio_pl_sync1_brk_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_sync1_brk_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE && env_config.pl_rx_mon_init_sm_state == NX_MODE ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
 end //}

 if (env_config.pl_tx_mon_init_sm_state == NX_RECOVERY && env_config.pl_rx_mon_init_sm_state == NX_RECOVERY ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
 end //}

endtask 
virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_RECOVERY && env_config.pl_rx_mon_init_sm_state == NX_RECOVERY ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
 end //}
endtask 
virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_RECOVERY && env_config.pl_rx_mon_init_sm_state == NX_RECOVERY ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
 end //}
endtask 


endclass : srio_pl_sync1_brk_cb


//===============================================================
//== Nx recovery to 1xm1 state mode ;; break lane(0 & 2) ========
//===============================================================

class srio_pl_sync0_brk_cb1 extends srio_pl_callback; 

function new (string name = "srio_pl_sync0_brk_cb1"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_sync0_brk_cb1"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE && env_config.pl_rx_mon_init_sm_state == NX_MODE ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
 end //}
 if (env_config.pl_tx_mon_init_sm_state == NX_RECOVERY && env_config.pl_rx_mon_init_sm_state == NX_RECOVERY ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
 end //}

endtask 

virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_RECOVERY && env_config.pl_rx_mon_init_sm_state == NX_RECOVERY ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
 end //}
endtask 

virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_RECOVERY && env_config.pl_rx_mon_init_sm_state == NX_RECOVERY ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
 end //}
endtask 


endclass : srio_pl_sync0_brk_cb1

//===============================================================
//== Nx recovery to 1xm2 state mode ;; break lane(0 & 1) ========
//===============================================================

class srio_pl_sync0_1_brk_cb1 extends srio_pl_callback; 

function new (string name = "srio_pl_sync0_1_brk_cb1"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_sync0_1_brk_cb1"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE && env_config.pl_rx_mon_init_sm_state == NX_MODE ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
 end //}

if (env_config.pl_tx_mon_init_sm_state == NX_RECOVERY && env_config.pl_rx_mon_init_sm_state == NX_RECOVERY ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
 end //}


endtask 

virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
if (env_config.pl_tx_mon_init_sm_state == NX_RECOVERY && env_config.pl_rx_mon_init_sm_state == NX_RECOVERY ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
 end //}
endtask 


virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_RECOVERY && env_config.pl_rx_mon_init_sm_state == NX_RECOVERY ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
 end //}
endtask 


endclass : srio_pl_sync0_1_brk_cb1

//===============================================================
//== Nx recovery to silent state mode ;; break lane(0 & 1) ========
//===============================================================

class srio_pl_sync0_1_2_brk_cb1 extends srio_pl_callback; 

bit lane_break ;
bit lane_currupt ;

function new (string name = "srio_pl_sync0_1_2_brk_cb1"); 
super.new(name);
lane_break = 1'b1 ;
endfunction 

static string type_name = "srio_pl_sync0_1_2_brk_cb1"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE && env_config.pl_rx_mon_init_sm_state == NX_MODE && lane_break ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
     lane_currupt = 1'b1 ;
 end //}
if (env_config.pl_tx_mon_init_sm_state == NX_RECOVERY && env_config.pl_rx_mon_init_sm_state == NX_RECOVERY ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
 end //}

if (env_config.pl_tx_mon_init_sm_state == SILENT && env_config.pl_rx_mon_init_sm_state == SILENT && lane_currupt ) begin //{ 
lane_break = 1'b0;
lane_currupt = 1'b0 ;
end //}

endtask 

virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);

 if (env_config.pl_tx_mon_init_sm_state == NX_MODE && env_config.pl_rx_mon_init_sm_state == NX_MODE && lane_break ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
    lane_currupt = 1'b1;
 end //}

if (env_config.pl_tx_mon_init_sm_state == NX_RECOVERY && env_config.pl_rx_mon_init_sm_state == NX_RECOVERY ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
 end //}

if (env_config.pl_tx_mon_init_sm_state == SILENT && env_config.pl_rx_mon_init_sm_state == SILENT && lane_currupt ) begin //{ 
lane_break = 1'b0;
lane_currupt = 1'b0 ;
end //}

endtask 


virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_RECOVERY && env_config.pl_rx_mon_init_sm_state == NX_RECOVERY ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
 end //}
endtask 


endclass : srio_pl_sync0_1_2_brk_cb1


//===================================
//====break sync0====== nxrto2xm ====
//===================================

class srio_pl_sync2_brk_cb1  extends srio_pl_callback; 
bit lane_break ;

function new (string name = "srio_pl_sync2_brk_cb1"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_sync2_brk_cb1"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE && env_config.pl_rx_mon_init_sm_state == NX_MODE  ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
 end //}
 if (env_config.pl_tx_mon_init_sm_state == NX_RECOVERY && env_config.pl_rx_mon_init_sm_state == NX_RECOVERY  ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
end //}

endtask 

endclass : srio_pl_sync2_brk_cb1

// SYNC CALLBACK -- NO_SYNC1-NO_SYNC_1-NO_SYNC

class srio_pl_ns1_ns2_ns_sm_callback extends srio_pl_callback; 

int temp0 =0,temp1 = 0,temp2 =0 ,temp3 =0,temp4 =0,temp5 =0,temp6 =0,temp7 =0,temp8 =0,temp9 =0,temp10 =0,temp11 =0,temp12 =0,temp13 =0,temp14 =0,temp15 =0 ;
srio_pl_agent pl_agent_cb ;

static string type_name = "srio_pl_ns1_ns2_ns_sm_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[0].current_sync_state == NO_SYNC_1) begin //{ 
  if(temp0 == 0) begin //{
  tx_srio_cg.cg = 10'h100;
  temp0 =1;
   end //}
end //}
  endtask

virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[1].current_sync_state == NO_SYNC_1) begin //{ 
  if(temp1 == 0) begin //{
  tx_srio_cg.cg = 10'h100;
  temp1 =1;
     end //}
  end //}
endtask
virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
 if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[2].current_sync_state == NO_SYNC_1) begin //{ 
  if(temp2 == 0) begin //{
  tx_srio_cg.cg = 10'h100;
  temp2 =1;
  
   end //}
  end //}
endtask
virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[3].current_sync_state == NO_SYNC_1) begin //{ 
  if(temp3 == 0) begin //{
  tx_srio_cg.cg = 10'h100;
  temp3 =1;
   end //}
  end //}
endtask
virtual task srio_pl_cg_generated_lane4 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[4].current_sync_state == NO_SYNC_1) begin //{ 
  if(temp4 == 0) begin //{
  tx_srio_cg.cg = 10'h100;
  temp4 =1;
   end //}
 
  end //}
endtask
virtual task srio_pl_cg_generated_lane5 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[5].current_sync_state == NO_SYNC_1) begin //{ 
  if(temp5 == 0) begin //{
  tx_srio_cg.cg = 10'h100;
  temp5 =1;
   end //}
  end //}
endtask
virtual task srio_pl_cg_generated_lane6 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[6].current_sync_state == NO_SYNC_1) begin //{ 
  if(temp6 == 0) begin //{
  tx_srio_cg.cg = 10'h100;
  temp6 =1;
   end //}
  end //}
endtask
virtual task srio_pl_cg_generated_lane7 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[7].current_sync_state == NO_SYNC_1) begin //{ 
  if(temp7 == 0) begin //{
  tx_srio_cg.cg = 10'h100;
  temp7 =1;
   end //}
  end //}
endtask
virtual task srio_pl_cg_generated_lane8 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[8].current_sync_state == NO_SYNC_1) begin //{ 
  if(temp8 == 0) begin //{
  tx_srio_cg.cg = 10'h100;
  temp8 =1;
   end //}
  end //}
endtask
virtual task srio_pl_cg_generated_lane9 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[9].current_sync_state == NO_SYNC_1) begin //{ 
  if(temp9 == 0) begin //{
  tx_srio_cg.cg = 10'h100;
  temp9 =1;
   end //}
  end //}
endtask
virtual task srio_pl_cg_generated_lane10 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[10].current_sync_state == NO_SYNC_1) begin //{ 
  if(temp10 == 0) begin //{
  tx_srio_cg.cg = 10'h100;
  temp10 =1;
   end //}
  end //}
endtask
virtual task srio_pl_cg_generated_lane11 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[11].current_sync_state == NO_SYNC_1) begin //{ 
  if(temp11 == 0) begin //{
  tx_srio_cg.cg = 10'h100;
  temp11 =1;
   end //}
  end //}
endtask
virtual task srio_pl_cg_generated_lane12 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[12].current_sync_state == NO_SYNC_1) begin //{ 
  if(temp12 == 0) begin //{
  tx_srio_cg.cg = 10'h100;
  temp12 =1;
   end //}
  end //}
endtask
virtual task srio_pl_cg_generated_lane13 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[13].current_sync_state == NO_SYNC_1) begin //{ 
  if(temp13 == 0) begin //{
  tx_srio_cg.cg = 10'h100;
  temp13 =1;
   end //}
  end //}
endtask
virtual task srio_pl_cg_generated_lane14 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[14].current_sync_state == NO_SYNC_1) begin //{ 
  if(temp14 == 0) begin //{
  tx_srio_cg.cg = 10'h100;
  temp14 =1;
   end //}
  end //}
  endtask
virtual task srio_pl_cg_generated_lane15 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[15].current_sync_state == NO_SYNC_1) begin //{ 
  if(temp15 == 0) begin //{
  tx_srio_cg.cg = 10'h100;
  temp15 =1;
   end //}
  end //}
endtask 
endclass : srio_pl_ns1_ns2_ns_sm_callback
// SYNC CALLBACK -- NO_SYNC1-NO_SYNC_2-NO_SYNC_3 -NO_SYNC_2 -NO_SYNC

class srio_pl_ns1_ns2_ns3_ns2_ns_sm_callback extends srio_pl_callback; 
int temp0 =0,temp1 = 0,temp2 =0 ,temp3 =0,temp4 =0,temp5 =0,temp6 =0,temp7 =0,temp8 =0,temp9 =0,temp10 =0,temp11 =0,temp12 =0,temp13 =0,temp14 =0,temp15 =0 ;

srio_pl_agent pl_agent_cb ;

static string type_name = "srio_pl_ns1_ns2_ns3_ns2_ns_sm_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[0].current_sync_state == NO_SYNC_3) begin //{ 
  if(temp0 == 0) begin //{
  tx_srio_cg.cg = 10'h100;
  temp0 =1;
   end //}
end //}
  endtask

virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[1].current_sync_state == NO_SYNC_3) begin //{ 
  if(temp1 == 0) begin //{
  tx_srio_cg.cg = 10'h100;
  temp1 =1;
   end //}
  end //}
endtask
virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
 if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[2].current_sync_state == NO_SYNC_3) begin //{ 
  if(temp2 == 0) begin //{
  tx_srio_cg.cg = 10'h100;
  temp2 =1;
   end //}
  end //}
endtask
virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[3].current_sync_state == NO_SYNC_3) begin //{ 
  if(temp3 == 0) begin //{
  tx_srio_cg.cg = 10'h100;
  temp3 =1;
   end //}
  end //}
endtask
virtual task srio_pl_cg_generated_lane4 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[4].current_sync_state == NO_SYNC_3) begin //{ 
  if(temp4 == 0) begin //{
  tx_srio_cg.cg = 10'h100;
  temp4 =1;
   end //}
 
  end //}
endtask
virtual task srio_pl_cg_generated_lane5 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[5].current_sync_state == NO_SYNC_3) begin //{ 
  if(temp5 == 0) begin //{
  tx_srio_cg.cg = 10'h100;
  temp5 =1;
   end //}
  end //}
endtask
virtual task srio_pl_cg_generated_lane6 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[6].current_sync_state == NO_SYNC_3) begin //{ 
  if(temp6 == 0) begin //{
  tx_srio_cg.cg = 10'h100;
  temp6 =1;
   end //}
  end //}
endtask
virtual task srio_pl_cg_generated_lane7 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[7].current_sync_state == NO_SYNC_3) begin //{ 
  if(temp7 == 0) begin //{
  tx_srio_cg.cg = 10'h100;
  temp7 =1;
   end //}
  end //}
endtask
virtual task srio_pl_cg_generated_lane8 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[8].current_sync_state == NO_SYNC_3) begin //{ 
  if(temp8 == 0) begin //{
  tx_srio_cg.cg = 10'h100;
  temp8 =1;
   end //}
  end //}
endtask
virtual task srio_pl_cg_generated_lane9 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[9].current_sync_state == NO_SYNC_3) begin //{ 
  if(temp9 == 0) begin //{
  tx_srio_cg.cg = 10'h100;
  temp9 =1;
   end //}
  end //}
endtask
virtual task srio_pl_cg_generated_lane10 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[10].current_sync_state == NO_SYNC_3) begin //{ 
  if(temp10 == 0) begin //{
  tx_srio_cg.cg = 10'h100;
  temp10 =1;
   end //}
  end //}
endtask
virtual task srio_pl_cg_generated_lane11 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[11].current_sync_state == NO_SYNC_3) begin //{ 
  if(temp11 == 0) begin //{
  tx_srio_cg.cg = 10'h100;
  temp11 =1;
   end //}
  end //}
endtask
virtual task srio_pl_cg_generated_lane12 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[12].current_sync_state == NO_SYNC_3) begin //{ 
  if(temp12 == 0) begin //{
  tx_srio_cg.cg = 10'h100;
  temp12 =1;
   end //}
  end //}
endtask
virtual task srio_pl_cg_generated_lane13 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[13].current_sync_state == NO_SYNC_3) begin //{ 
  if(temp13 == 0) begin //{
  tx_srio_cg.cg = 10'h100;
  temp13 =1;
   end //}
  end //}
endtask
virtual task srio_pl_cg_generated_lane14 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[14].current_sync_state == NO_SYNC_3) begin //{ 
  if(temp14 == 0) begin //{
  tx_srio_cg.cg = 10'h100;
  temp14 =1;
   end //}
  end //}
  endtask
virtual task srio_pl_cg_generated_lane15 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[15].current_sync_state == NO_SYNC_3) begin //{ 
  if(temp15 == 0) begin //{
  tx_srio_cg.cg = 10'h100;
  temp15 =1;
   end //}
  end //}
endtask 
endclass : srio_pl_ns1_ns2_ns3_ns2_ns_sm_callback
// SYNC CALLBACK -- NO_SYNC1-NO_SYNC_2-NO_SYNC_3 -NO_SYNC_2 -NO_SYNC_1

class srio_pl_ns1_ns2_ns3_ns2_ns1_sm_callback extends srio_pl_callback;
 int temp0 =0,temp1 = 0,temp2 =0 ,temp3 =0,temp4 =0,temp5 =0,temp6 =0,temp7 =0,temp8 =0,temp9 =0,temp10 =0,temp11 =0,temp12 =0,temp13 =0,temp14 =0,temp15 =0 ;
rand bit sel;

srio_pl_agent pl_agent_cb ;
srio_pl_bfm pl_bfm_cb;

static string type_name = "srio_pl_ns1_ns2_ns3_ns2_ns1_sm_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);   
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[0].current_sync_state == NO_SYNC_3) begin //{ 
      if(pl_bfm_cb.lane_driver_ins[0].cur_dis == POS) begin //{
       if(temp0 == 0) begin //{
       sel = $urandom;
       tx_srio_cg.cg = sel ? 10'h305 : 10'h306;
       temp0 =1;
       end //}
       end //}
     else begin //{
      if( pl_bfm_cb.lane_driver_ins[0].cur_dis == NEG) begin //{
       if(temp0 == 0) begin //{
       sel = $urandom;
       tx_srio_cg.cg = sel ? 10'hFA : 10'hF9 ;
       temp0 =1;       
       end //}
    end //}
 end //}
end //}
endtask
virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);   
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[1].current_sync_state == NO_SYNC_3) begin //{ 
      if(pl_bfm_cb.lane_driver_ins[1].cur_dis == POS) begin //{
       if(temp1 == 0) begin //{
       sel = $urandom;
       tx_srio_cg.cg = sel ? 10'h305 : 10'h306;
       temp1 =1;
       end //}
       end //}
     else begin //{
      if( pl_bfm_cb.lane_driver_ins[1].cur_dis == NEG) begin //{
       if(temp1 == 0) begin //{
       sel = $urandom;
       tx_srio_cg.cg = sel ? 10'hFA : 10'hF9 ;
       temp1 =1;       
       end //}
    end //}
 end //}
end //}
endtask
virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);   
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[2].current_sync_state == NO_SYNC_3) begin //{ 
      if(pl_bfm_cb.lane_driver_ins[2].cur_dis == POS) begin //{
       if(temp2 == 0) begin //{
       sel = $urandom;
       tx_srio_cg.cg = sel ? 10'h305 : 10'h306;
       temp2 =1;
       end //}
       end //}
     else begin //{
      if( pl_bfm_cb.lane_driver_ins[2].cur_dis == NEG) begin //{
       if(temp2 == 0) begin //{
       sel = $urandom;
       tx_srio_cg.cg = sel ? 10'hFA : 10'hF9 ;
       temp2 =1;       
       end //}
    end //}
 end //}
end //}
endtask
virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);   
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[3].current_sync_state == NO_SYNC_3) begin //{ 
      if(pl_bfm_cb.lane_driver_ins[3].cur_dis == POS) begin //{
       if(temp3 == 0) begin //{
       sel = $urandom;
       tx_srio_cg.cg = sel ? 10'h305 : 10'h306;
       temp3 =1;
       end //}
       end //}
     else begin //{
      if( pl_bfm_cb.lane_driver_ins[3].cur_dis == NEG) begin //{
       if(temp3 == 0) begin //{
       sel = $urandom;
       tx_srio_cg.cg = sel ? 10'hFA : 10'hF9 ;
       temp3 =1;       
       end //}
    end //}
 end //}
end //}
endtask
virtual task srio_pl_cg_generated_lane4 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);   
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[4].current_sync_state == NO_SYNC_3) begin //{ 
      if(pl_bfm_cb.lane_driver_ins[4].cur_dis == POS) begin //{
       if(temp4 == 0) begin //{
       sel = $urandom;
       tx_srio_cg.cg = sel ? 10'h305 : 10'h306;
       temp4 =1;
       end //}
       end //}
     else begin //{
      if( pl_bfm_cb.lane_driver_ins[4].cur_dis == NEG) begin //{
       if(temp4 == 0) begin //{
       sel = $urandom;
       tx_srio_cg.cg = sel ? 10'hFA : 10'hF9 ;
       temp4 =1;       
       end //}
    end //}
 end //}
end //}
endtask

virtual task srio_pl_cg_generated_lane5 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);   
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[5].current_sync_state == NO_SYNC_3) begin //{ 
      if(pl_bfm_cb.lane_driver_ins[5].cur_dis == POS) begin //{
       if(temp5 == 0) begin //{
       sel = $urandom;
       tx_srio_cg.cg = sel ? 10'h305 : 10'h306;
       temp5 =1;
       end //}
       end //}
     else begin //{
      if( pl_bfm_cb.lane_driver_ins[5].cur_dis == NEG) begin //{
       if(temp5 == 0) begin //{
       sel = $urandom;
       tx_srio_cg.cg = sel ? 10'hFA : 10'hF9 ;
       temp5 =1;       
       end //}
    end //}
 end //}
end //}
endtask
virtual task srio_pl_cg_generated_lane6 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);   
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[6].current_sync_state == NO_SYNC_3) begin //{ 
      if(pl_bfm_cb.lane_driver_ins[6].cur_dis == POS) begin //{
       if(temp6 == 0) begin //{
       sel = $urandom;
       tx_srio_cg.cg = sel ? 10'h305 : 10'h306;
       temp6 =1;
       end //}
       end //}
     else begin //{
      if( pl_bfm_cb.lane_driver_ins[6].cur_dis == NEG) begin //{
       if(temp6 == 0) begin //{
       sel = $urandom;
       tx_srio_cg.cg = sel ? 10'hFA : 10'hF9 ;
       temp6 =1;       
       end //}
    end //}
 end //}
end //}
endtask
virtual task srio_pl_cg_generated_lane7 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);   
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[7].current_sync_state == NO_SYNC_3) begin //{ 
      if(pl_bfm_cb.lane_driver_ins[7].cur_dis == POS) begin //{
       if(temp7 == 0) begin //{
       sel = $urandom;
       tx_srio_cg.cg = sel ? 10'h305 : 10'h306;
       temp7 =1;
       end //}
       end //}
     else begin //{
      if( pl_bfm_cb.lane_driver_ins[7].cur_dis == NEG) begin //{
       if(temp7 == 0) begin //{
       sel = $urandom;
       tx_srio_cg.cg = sel ? 10'hFA : 10'hF9 ;
       temp7 =1;       
       end //}
    end //}
 end //}
end //}
endtask
virtual task srio_pl_cg_generated_lane8 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);   
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[8].current_sync_state == NO_SYNC_3) begin //{ 
      if(pl_bfm_cb.lane_driver_ins[8].cur_dis == POS) begin //{
       if(temp8 == 0) begin //{
       sel = $urandom;
       tx_srio_cg.cg = sel ? 10'h305 : 10'h306;
       temp8 =1;
       end //}
       end //}
     else begin //{
      if( pl_bfm_cb.lane_driver_ins[8].cur_dis == NEG) begin //{
       if(temp8 == 0) begin //{
       sel = $urandom;
       tx_srio_cg.cg = sel ? 10'hFA : 10'hF9 ;
       temp8 =1;       
       end //}
    end //}
 end //}
end //}
endtask
virtual task srio_pl_cg_generated_lane9 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);   
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[9].current_sync_state == NO_SYNC_3) begin //{ 
      if(pl_bfm_cb.lane_driver_ins[9].cur_dis == POS) begin //{
       if(temp9 == 0) begin //{
       sel = $urandom;
       tx_srio_cg.cg = sel ? 10'h305 : 10'h306;
       temp9 =1;
       end //}
       end //}
     else begin //{
      if( pl_bfm_cb.lane_driver_ins[9].cur_dis == NEG) begin //{
       if(temp9 == 0) begin //{
       sel = $urandom;
       tx_srio_cg.cg = sel ? 10'hFA : 10'hF9 ;
       temp9 =1;       
       end //}
    end //}
 end //}
end //}
endtask
virtual task srio_pl_cg_generated_lane10 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);   
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[10].current_sync_state == NO_SYNC_3) begin //{ 
      if(pl_bfm_cb.lane_driver_ins[10].cur_dis == POS) begin //{
       if(temp10 == 0) begin //{
       sel = $urandom;
       tx_srio_cg.cg = sel ? 10'h305 : 10'h306;
       temp10 =1;
       end //}
       end //}
     else begin //{
      if( pl_bfm_cb.lane_driver_ins[10].cur_dis == NEG) begin //{
       if(temp10 == 0) begin //{
       sel = $urandom;
       tx_srio_cg.cg = sel ? 10'hFA : 10'hF9 ;
       temp10 =1;       
       end //}
    end //}
 end //}
end //}
endtask
virtual task srio_pl_cg_generated_lane11 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);   
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[11].current_sync_state == NO_SYNC_3) begin //{ 
      if(pl_bfm_cb.lane_driver_ins[11].cur_dis == POS) begin //{
       if(temp11 == 0) begin //{
       sel = $urandom;
       tx_srio_cg.cg = sel ? 10'h305 : 10'h306;
       temp11 =1;
       end //}
       end //}
     else begin //{
      if( pl_bfm_cb.lane_driver_ins[11].cur_dis == NEG) begin //{
       if(temp11 == 0) begin //{
       sel = $urandom;
       tx_srio_cg.cg = sel ? 10'hFA : 10'hF9 ;
       temp11 =1;       
       end //}
    end //}
 end //}
end //}
endtask
virtual task srio_pl_cg_generated_lane12 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);   
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[12].current_sync_state == NO_SYNC_3) begin //{ 
      if(pl_bfm_cb.lane_driver_ins[12].cur_dis == POS) begin //{
       if(temp12 == 0) begin //{
       sel = $urandom;
       tx_srio_cg.cg = sel ? 10'h305 : 10'h306;
       temp12 =1;
       end //}
       end //}
     else begin //{
      if( pl_bfm_cb.lane_driver_ins[12].cur_dis == NEG) begin //{
       if(temp12 == 0) begin //{
       sel = $urandom;
       tx_srio_cg.cg = sel ? 10'hFA : 10'hF9 ;
       temp12 =1;       
       end //}
    end //}
 end //}
end //}
endtask

virtual task srio_pl_cg_generated_lane13 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);   
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[13].current_sync_state == NO_SYNC_3) begin //{ 
      if(pl_bfm_cb.lane_driver_ins[13].cur_dis == POS) begin //{
       if(temp13 == 0) begin //{
       sel = $urandom;
       tx_srio_cg.cg = sel ? 10'h305 : 10'h306;
       temp13 =1;
       end //}
       end //}
     else begin //{
      if( pl_bfm_cb.lane_driver_ins[13].cur_dis == NEG) begin //{
       if(temp13 == 0) begin //{
       sel = $urandom;
       tx_srio_cg.cg = sel ? 10'hFA : 10'hF9 ;
       temp13 =1;       
       end //}
    end //}
 end //}
end //}
endtask
virtual task srio_pl_cg_generated_lane14 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);   
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[14].current_sync_state == NO_SYNC_3) begin //{ 
      if(pl_bfm_cb.lane_driver_ins[14].cur_dis == POS) begin //{
       if(temp14 == 0) begin //{
       sel = $urandom;
       tx_srio_cg.cg = sel ? 10'h305 : 10'h306;
       temp14 =1;
       end //}
       end //}
     else begin //{
      if( pl_bfm_cb.lane_driver_ins[14].cur_dis == NEG) begin //{
       if(temp14 == 0) begin //{
       sel = $urandom;
       tx_srio_cg.cg = sel ? 10'hFA : 10'hF9 ;
       temp14 =1;       
       end //}
    end //}
 end //}
end //}
endtask
virtual task srio_pl_cg_generated_lane15 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);   
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[15].current_sync_state == NO_SYNC_3) begin //{ 
      if(pl_bfm_cb.lane_driver_ins[15].cur_dis == POS) begin //{
       if(temp15 == 0) begin //{
       sel = $urandom;
       tx_srio_cg.cg = sel ? 10'h305 : 10'h306;
       temp15 =1;
       end //}
       end //}
     else begin //{
      if( pl_bfm_cb.lane_driver_ins[15].cur_dis == NEG) begin //{
       if(temp15 == 0) begin //{
       sel = $urandom;
       tx_srio_cg.cg = sel ? 10'hFA : 10'hF9 ;
       temp15 =1;       
       end //}
    end //}
 end //}
end //}
endtask
endclass :srio_pl_ns1_ns2_ns3_ns2_ns1_sm_callback



//=================================================================================
//=================dis to 2x mode ====currupt lane 2 & 3 for 4x ,8x ,16x===========
//=================================================================================

class srio_pl_sync3_brk_cb extends srio_pl_callback; 

function new (string name = "srio_pl_sync3_brk_cb "); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_sync3_brk_cb "; 

virtual function string get_type_name(); 
return type_name; 
endfunction

virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 

virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 


endclass : srio_pl_sync3_brk_cb
// GEN 3 SYNC CALLBACK 

class srio_pl_gen3_ns2_ns3_ns1_sm_callback extends srio_pl_callback; 

int temp0 =0,temp1 = 0,temp2 =0 ,temp3 =0,temp4 =0,temp5 =0,temp6 =0,temp7 =0,temp8 =0,temp9 =0,temp10 =0,temp11 =0,temp12 =0,temp13 =0,temp14 =0,temp15 =0 ;
int flag0 =0,flag1 = 0,flag2 =0 ,flag3 =0,flag4 =0,flag5 =0,flag6 =0,flag7 =0,flag8 =0,flag9 =0,flag10 =0,flag11 =0,flag12 =0,flag13 =0,flag14 =0,flag15 =0 ;

bit [0:66] brc3_cg_temp;
srio_pl_agent pl_agent_cb ;

static string type_name = "srio_pl_gen3_ns2_ns3_ns1_sm_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 
virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[0].current_sync_state == NO_SYNC_3) begin //{ 
  if(temp0 == 0) begin //{
  brc3_cg_temp = tx_srio_cg.brc3_cg;
  if(brc3_cg_temp[33:38] == 6'b001101) begin //{
     flag0 =flag0 + 1;
   end //} 
  if(flag0 == 2) begin //{
  tx_srio_cg.brc3_cg[2] = 1'b1;
  temp0 = 1;
   end //} 
    end //}
end //}
  endtask

virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[1].current_sync_state == NO_SYNC_3) begin //{ 
 if(temp1 == 0) begin //{
  brc3_cg_temp = tx_srio_cg.brc3_cg;
  if(brc3_cg_temp[33:38] == 6'b001101) begin //{
     flag1 =flag1 + 1;
   end //} 
  if(flag1 == 2) begin //{
  tx_srio_cg.brc3_cg[2] = 1'b1;
  temp1 = 1;
   end //} 
    end //}
end //}
endtask
virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
 if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[2].current_sync_state == NO_SYNC_3) begin //{
if(temp2 == 0) begin //{
  brc3_cg_temp = tx_srio_cg.brc3_cg;
  if(brc3_cg_temp[33:38] == 6'b001101) begin //{
     flag2 =flag2 + 1;
   end //} 
  if(flag2 == 2) begin //{
  tx_srio_cg.brc3_cg[2] = 1'b1;
  temp2 = 1;
   end //} 
    end //}
end //}
  endtask
virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[3].current_sync_state == NO_SYNC_3) begin //{ 
 if(temp3 == 0) begin //{
  brc3_cg_temp = tx_srio_cg.brc3_cg;
  if(brc3_cg_temp[33:38] == 6'b001101) begin //{
     flag3 =flag3 + 1;
   end //} 
  if(flag3 == 2) begin //{
  tx_srio_cg.brc3_cg[2] = 1'b1;
  temp3 = 1;
   end //} 
    end //}
end //}
endtask
virtual task srio_pl_cg_generated_lane4 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[4].current_sync_state == NO_SYNC_3) begin //{ 
if(temp4 == 0) begin //{
  brc3_cg_temp = tx_srio_cg.brc3_cg;
  if(brc3_cg_temp[33:38] == 6'b001101) begin //{
     flag4 =flag4 + 1;
   end //} 
  if(flag4 == 2) begin //{
  tx_srio_cg.brc3_cg[2] = 1'b1;
  temp4 = 1;
   end //} 
    end //}
end //}
 endtask
virtual task srio_pl_cg_generated_lane5 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[5].current_sync_state == NO_SYNC_3) begin //{ 
  if(temp5 == 0) begin //{
  brc3_cg_temp = tx_srio_cg.brc3_cg;
  if(brc3_cg_temp[33:38] == 6'b001101) begin //{
     flag5 =flag5 + 1;
   end //} 
  if(flag5 == 2) begin //{
  tx_srio_cg.brc3_cg[2] = 1'b1;
  temp5 = 1;
   end //} 
    end //}
end //}
endtask
virtual task srio_pl_cg_generated_lane6 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[6].current_sync_state == NO_SYNC_3) begin //{ 
  if(temp6 == 0) begin //{
  brc3_cg_temp = tx_srio_cg.brc3_cg;
  if(brc3_cg_temp[33:38] == 6'b001101) begin //{
     flag6 =flag6 + 1;
   end //} 
  if(flag6 == 2) begin //{
  tx_srio_cg.brc3_cg[2] = 1'b1;
  temp6 = 1;
   end //} 
    end //}
end //}
endtask
virtual task srio_pl_cg_generated_lane7 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[7].current_sync_state == NO_SYNC_3) begin //{ 
  if(temp7 == 0) begin //{
  brc3_cg_temp = tx_srio_cg.brc3_cg;
  if(brc3_cg_temp[33:38] == 6'b001101) begin //{
     flag7 =flag7 + 1;
   end //} 
  if(flag7 == 2) begin //{
  tx_srio_cg.brc3_cg[2] = 1'b1;
  temp7 = 1;
   end //} 
    end //}
end //}
endtask
virtual task srio_pl_cg_generated_lane8 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[8].current_sync_state == NO_SYNC_3) begin //{
if(temp8 == 0) begin //{
  brc3_cg_temp = tx_srio_cg.brc3_cg;
  if(brc3_cg_temp[33:38] == 6'b001101) begin //{
     flag8 =flag8 + 1;
   end //} 
  if(flag8 == 2) begin //{
  tx_srio_cg.brc3_cg[2] = 1'b1;
  temp8 = 1;
   end //} 
    end //}
end //} 
  endtask
virtual task srio_pl_cg_generated_lane9 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[9].current_sync_state == NO_SYNC_3) begin //{ 
if(temp9 == 0) begin //{
  brc3_cg_temp = tx_srio_cg.brc3_cg;
  if(brc3_cg_temp[33:38] == 6'b001101) begin //{
     flag9 =flag9 + 1;
   end //} 
  if(flag9 == 2) begin //{
  tx_srio_cg.brc3_cg[2] = 1'b1;
  temp9 = 1;
   end //} 
    end //}
end //}
 
endtask
virtual task srio_pl_cg_generated_lane10 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[10].current_sync_state == NO_SYNC_3) begin //{ 
 if(temp10 == 0) begin //{
  brc3_cg_temp = tx_srio_cg.brc3_cg;
  if(brc3_cg_temp[33:38] == 6'b001101) begin //{
     flag10 =flag10 + 1;
   end //} 
  if(flag10 == 2) begin //{
  tx_srio_cg.brc3_cg[2] = 1'b1;
  temp10 = 1;
   end //} 
    end //}
end //}
endtask
virtual task srio_pl_cg_generated_lane11 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[11].current_sync_state == NO_SYNC_3) begin //{ 
 if(temp11 == 0) begin //{
  brc3_cg_temp = tx_srio_cg.brc3_cg;
  if(brc3_cg_temp[33:38] == 6'b001101) begin //{
     flag11 =flag11 + 1;
   end //} 
  if(flag11 == 2) begin //{
  tx_srio_cg.brc3_cg[2] = 1'b1;
  temp11 = 1;
   end //} 
    end //}
end //}
endtask
virtual task srio_pl_cg_generated_lane12 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[12].current_sync_state == NO_SYNC_3) begin //{ 
  if(temp12 == 0) begin //{
  brc3_cg_temp = tx_srio_cg.brc3_cg;
  if(brc3_cg_temp[33:38] == 6'b001101) begin //{
     flag12 =flag12 + 1;
   end //} 
  if(flag12 == 2) begin //{
  tx_srio_cg.brc3_cg[2] = 1'b1;
  temp12 = 1;
   end //} 
    end //}
end //}
endtask
virtual task srio_pl_cg_generated_lane13 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[13].current_sync_state == NO_SYNC_3) begin //{ 
 if(temp13 == 0) begin //{
  brc3_cg_temp = tx_srio_cg.brc3_cg;
  if(brc3_cg_temp[33:38] == 6'b001101) begin //{
     flag13 =flag13 + 1;
   end //} 
  if(flag13 == 2) begin //{
  tx_srio_cg.brc3_cg[2] = 1'b1;
  temp13 = 1;
   end //} 
    end //}
end //} 
endtask
virtual task srio_pl_cg_generated_lane14 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[14].current_sync_state == NO_SYNC_3) begin //{ 
  if(temp14 == 0) begin //{
  brc3_cg_temp = tx_srio_cg.brc3_cg;
  if(brc3_cg_temp[33:38] == 6'b001101) begin //{
     flag14 =flag14 + 1;
   end //} 
  if(flag14 == 2) begin //{
  tx_srio_cg.brc3_cg[2] = 1'b1;
  temp14 = 1;
   end //} 
    end //}
end //}
  endtask
virtual task srio_pl_cg_generated_lane15 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[15].current_sync_state == NO_SYNC_3) begin //{ 
  if(temp15 == 0) begin //{
  brc3_cg_temp = tx_srio_cg.brc3_cg;
  if(brc3_cg_temp[33:38] == 6'b001101) begin //{
     flag15 =flag15 + 1;
   end //} 
  if(flag15 == 2) begin //{
  tx_srio_cg.brc3_cg[2] = 1'b1;
  temp15 = 1;
   end //} 
    end //}
end //}
endtask 
endclass : srio_pl_gen3_ns2_ns3_ns1_sm_callback

//=================================================================================
///=================2x rec to ln0 mode ====currupt lane 2 & 3 for 4x ,8x ,16x===========
//=================================================================================

class srio_pl_sync3_brk_cb1 extends srio_pl_callback; 

function new (string name = "srio_pl_sync3_brk_cb1 "); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_sync3_brk_cb1 "; 

virtual function string get_type_name(); 
return type_name; 
endfunction
  
virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == X2_MODE && env_config.pl_rx_mon_init_sm_state == X2_MODE ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
end
endtask 


virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 

virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 


endclass : srio_pl_sync3_brk_cb1

//=================================================
//====== 2xmode_sl && 2x_rec_2xmode ===============
//=================================================
class srio_pl_sync_brk_cb extends srio_pl_callback; 
function new (string name = "srio_pl_sync_brk_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_sync_brk_cb "; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask

virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 
endclass : srio_pl_sync_brk_cb



//============================================================
//== GEN1.3 SEEK to 1xm0 callback    =========================
//============================================================


class srio_pl_sync1_2_3_brk_cb extends srio_pl_callback; 
function new (string name = "srio_pl_sync1_2_3_brk_cb "); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_sync1_2_3_brk_cb "; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 


virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask

virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 
endclass : srio_pl_sync1_2_3_brk_cb

//============================================================
//== GEN1.3 SEEK to 1xm1 callback   ==========================
//============================================================

class srio_pl_sync0_2_3_brk_cb extends srio_pl_callback; 
function new (string name = "srio_pl_sync0_2_3_brk_cb "); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_sync0_2_3_brk_cb "; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 


virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask

virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 
endclass : srio_pl_sync0_2_3_brk_cb

//========================================================================
//====lane2 and 3 // lane 1 after going to 2x recovery====== 2xrecto1xm0 =
//========================================================================

class srio_pl_sync2_3_1_brk_cb extends srio_pl_callback; 
bit lane_break ;

function new (string name = "srio_pl_sync2_3_1_brk_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_sync2_3_1_brk_cb "; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == X2_MODE && env_config.pl_rx_mon_init_sm_state == X2_MODE  ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;

 end //}
 if (env_config.pl_tx_mon_init_sm_state == X2_RECOVERY && env_config.pl_rx_mon_init_sm_state == X2_RECOVERY  ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
end //}
 if (env_config.pl_tx_mon_init_sm_state == X1_M0 && env_config.pl_rx_mon_init_sm_state == X1_M0  ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
end //}
endtask 


virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask

virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask


endclass : srio_pl_sync2_3_1_brk_cb 

//========================================================================
//====lane2 and 3 // lane 1 after going to 2x recovery====== 2xmode2xrec =
//========================================================================

class srio_pl_sync2_3_1_brk_cb1 extends srio_pl_callback; 
bit lane_break ;

function new (string name = "srio_pl_sync2_3_1_brk_cb1"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_sync2_3_1_brk_cb1 "; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == X2_MODE && env_config.pl_rx_mon_init_sm_state == X2_MODE  ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;

 end //}
 if (env_config.pl_tx_mon_init_sm_state == X2_RECOVERY && env_config.pl_rx_mon_init_sm_state == X2_RECOVERY  ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
end //}
 if (env_config.pl_tx_mon_init_sm_state == X1_M0 && env_config.pl_rx_mon_init_sm_state == X1_M0  ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
end //}
endtask 


virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask

virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask


endclass : srio_pl_sync2_3_1_brk_cb1 



//========================================================================
//====GEN 2_2 ====== ================& nxm_dis_1xm0======================
//========================================================================

class srio_pl_nxm_dis_sl_cb extends srio_pl_callback; 

bit lane_break ;
function new (string name = "srio_pl_nxm_dis_sl_cb") ;
super.new(name); 
endfunction 

static string type_name = "srio_pl_nxm_dis_sl_cb" ; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE && env_config.pl_rx_mon_init_sm_state == NX_MODE  ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
lane_break =1'b1;
 end //}

 if (env_config.pl_tx_mon_init_sm_state == DISCOVERY && env_config.pl_rx_mon_init_sm_state == DISCOVERY && lane_break ) begin //{
    tx_srio_cg.cg =10'h100;
     tx_srio_cg.brc3_cg ='h0;
end //}
endtask 

virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE && env_config.pl_rx_mon_init_sm_state == NX_MODE  ) begin //{ 
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
lane_break =1'b1;
end //}

 if (env_config.pl_tx_mon_init_sm_state == DISCOVERY && env_config.pl_rx_mon_init_sm_state == DISCOVERY  && lane_break) begin //{
    tx_srio_cg.cg =10'h100;
     tx_srio_cg.brc3_cg ='h0;
end //}
endtask

virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE && env_config.pl_rx_mon_init_sm_state == NX_MODE  ) begin //{ 
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
lane_break =1'b1;
end //}


 if (env_config.pl_tx_mon_init_sm_state == DISCOVERY && env_config.pl_rx_mon_init_sm_state == DISCOVERY && lane_break ) begin //{
    tx_srio_cg.cg =10'h100;
     tx_srio_cg.brc3_cg ='h0;
end //}
endtask


endclass : srio_pl_nxm_dis_sl_cb  



//========================================================================
//====GEN 2_2 ====== ===============  & nxm_dis_1xm1======================
//========================================================================

class srio_pl_nxm_dis_1xm1_cb extends srio_pl_callback; 

bit lane_break ;
function new (string name = "srio_pl_nxm_dis_1xm1_cb") ;
super.new(name); 
endfunction 

static string type_name = "srio_pl_nxm_dis_1xm1_cb" ; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE && env_config.pl_rx_mon_init_sm_state == NX_MODE  ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
    lane_break = 1'b1;
 end //}

 if (env_config.pl_tx_mon_init_sm_state == DISCOVERY && env_config.pl_rx_mon_init_sm_state == DISCOVERY && lane_break ) begin //{
    tx_srio_cg.cg =10'h100;
     tx_srio_cg.brc3_cg ='h0;
end //}
endtask 

virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE && env_config.pl_rx_mon_init_sm_state == NX_MODE  ) begin //{ 
    lane_break = 1'b1;
end //}

 if (env_config.pl_tx_mon_init_sm_state == DISCOVERY && env_config.pl_rx_mon_init_sm_state == DISCOVERY  && lane_break ) begin //{
    tx_srio_cg.cg =10'h100;
     tx_srio_cg.brc3_cg ='h0;
end //}
endtask

virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE && env_config.pl_rx_mon_init_sm_state == NX_MODE  ) begin //{ 
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
    lane_break = 1'b1;
end //}


 if (env_config.pl_tx_mon_init_sm_state == DISCOVERY && env_config.pl_rx_mon_init_sm_state == DISCOVERY && lane_break ) begin //{
    tx_srio_cg.cg =10'h100;
     tx_srio_cg.brc3_cg ='h0;
end //}
endtask


endclass : srio_pl_nxm_dis_1xm1_cb 

 
//========================================================================
//====GEN 2_2 ====== ================== nxm_dis_1xm2======================
//========================================================================

class srio_pl_nxm_dis_1xm2_cb extends srio_pl_callback; 
 
bit lane_break;
function new (string name = "srio_pl_nxm_dis_1xm2_cb") ;
super.new(name); 
endfunction 

static string type_name = "srio_pl_nxm_dis_1xm2_cb" ; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE && env_config.pl_rx_mon_init_sm_state == NX_MODE  ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
lane_break = 1'b1 ;
 end //}

 if (env_config.pl_tx_mon_init_sm_state == DISCOVERY && env_config.pl_rx_mon_init_sm_state == DISCOVERY  && lane_break) begin //{
    tx_srio_cg.cg =10'h100;
     tx_srio_cg.brc3_cg ='h0;
end //}
 
endtask 

virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE && env_config.pl_rx_mon_init_sm_state == NX_MODE  ) begin //{ 
  lane_break = 1'b1; 
end //}
 if (env_config.pl_tx_mon_init_sm_state == DISCOVERY && env_config.pl_rx_mon_init_sm_state == DISCOVERY  && lane_break) begin //{
    tx_srio_cg.cg =10'h100;
     tx_srio_cg.brc3_cg ='h0;

end //}
endtask

virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE && env_config.pl_rx_mon_init_sm_state == NX_MODE  ) begin //{ 
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
lane_break =1'b1;
end //}


 if (env_config.pl_tx_mon_init_sm_state == DISCOVERY && env_config.pl_rx_mon_init_sm_state == DISCOVERY  && lane_break ) begin //{
    tx_srio_cg.cg =10'h100;
     tx_srio_cg.brc3_cg ='h0;
end //}
endtask


endclass : srio_pl_nxm_dis_1xm2_cb


//========================================================================
//====GEN 2_2 ====== ================== nxm_dis_x2m======================
//========================================================================

class srio_pl_nxm_dis_x2m_cb extends srio_pl_callback; 

bit lane_break;
function new (string name = "srio_pl_nxm_dis_x2m_cb") ;
super.new(name); 
endfunction 

static string type_name = "srio_pl_nxm_dis_x2m_cb" ; 

virtual function string get_type_name(); 
return type_name; 
endfunction 


virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE && env_config.pl_rx_mon_init_sm_state == NX_MODE  ) begin //{ 
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
    lane_break = 1'b1;
end //}
 if (env_config.pl_tx_mon_init_sm_state == DISCOVERY && env_config.pl_rx_mon_init_sm_state == DISCOVERY && lane_break ) begin //{
    tx_srio_cg.cg =10'h100;
     tx_srio_cg.brc3_cg ='h0;
end //}
endtask

virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE && env_config.pl_rx_mon_init_sm_state == NX_MODE  ) begin //{ 
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
    lane_break = 1'b1;
end //}


 if (env_config.pl_tx_mon_init_sm_state == DISCOVERY && env_config.pl_rx_mon_init_sm_state == DISCOVERY && lane_break ) begin //{
    tx_srio_cg.cg =10'h100;
     tx_srio_cg.brc3_cg ='h0;
end //}
endtask


endclass : srio_pl_nxm_dis_x2m_cb

//========================================================================
//====GEN 2_2 ==========================& nxm_dis_sl======================
//========================================================================

class srio_pl_nxm_dis_sl_cb1 extends srio_pl_callback; 

bit lane_break  ;
bit lane_currupt  ;
bit lane_flag;

function new (string name = "srio_pl_nxm_dis_sl_cb1") ;
super.new(name); 
lane_currupt = 1'b1;
endfunction 

static string type_name = "srio_pl_nxm_dis_sl_cb1" ; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);


 if (env_config.pl_tx_mon_init_sm_state == NX_MODE && env_config.pl_rx_mon_init_sm_state == NX_MODE && lane_currupt ) begin //{ 

lane_break =1'b1;
 end //}


 if (env_config.pl_tx_mon_init_sm_state == DISCOVERY && env_config.pl_rx_mon_init_sm_state == DISCOVERY && lane_break ) begin //{
    tx_srio_cg.cg =10'h100;
     tx_srio_cg.brc3_cg ='h0;

end //}
endtask 

virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);

 if (env_config.pl_tx_mon_init_sm_state == NX_MODE && env_config.pl_rx_mon_init_sm_state == NX_MODE && lane_currupt ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
lane_break =1'b1;
 end //}

 if (env_config.pl_tx_mon_init_sm_state == DISCOVERY && env_config.pl_rx_mon_init_sm_state == DISCOVERY && lane_break ) begin //{
    tx_srio_cg.cg =10'h100;
     tx_srio_cg.brc3_cg ='h0;
lane_flag = 1'b1;
end //}

 if (env_config.pl_tx_mon_init_sm_state == SILENT && env_config.pl_rx_mon_init_sm_state == SILENT && lane_flag) begin //{
   lane_flag = 1'b0;
   lane_break = 1'b0;
   lane_currupt = 1'b0;
end //}
endtask 

virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);

 if (env_config.pl_tx_mon_init_sm_state == NX_MODE && env_config.pl_rx_mon_init_sm_state == NX_MODE && lane_currupt ) begin //{ 
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
lane_break =1'b1;
end //}

 if (env_config.pl_tx_mon_init_sm_state == DISCOVERY && env_config.pl_rx_mon_init_sm_state == DISCOVERY  && lane_break) begin //{
    tx_srio_cg.cg =10'h100;
     tx_srio_cg.brc3_cg ='h0;

end //}
endtask

virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);

 if (env_config.pl_tx_mon_init_sm_state == NX_MODE && env_config.pl_rx_mon_init_sm_state == NX_MODE  && lane_currupt) begin //{ 
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
lane_break =1'b1;
end //}


 if (env_config.pl_tx_mon_init_sm_state == DISCOVERY && env_config.pl_rx_mon_init_sm_state == DISCOVERY && lane_break ) begin //{
    tx_srio_cg.cg =10'h100;
     tx_srio_cg.brc3_cg ='h0;

end //}
endtask


endclass : srio_pl_nxm_dis_sl_cb1
 //============================================================================ 
//===========callback for sync0 and sync2 break =======x1m to x1r to sl ====== 
//============================================================================ 

class srio_pl_sync0_sync2_break_cb1 extends srio_pl_callback; 
bit lane_break;
bit lane_currupt;

function new (string name = "srio_pl_sync0_sync2_break_cb1"); 
super.new(name);
lane_break = 1'b1; 
endfunction 

static string type_name = "srio_pl_sync0_sync2_break_cb1"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 


virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if (env_config.pl_tx_mon_init_sm_state == X1_RECOVERY && env_config.pl_rx_mon_init_sm_state == X1_RECOVERY && lane_break ) begin //{ 
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
    lane_currupt = 1'b1;
end 

  if (env_config.pl_tx_mon_init_sm_state == SILENT && env_config.pl_rx_mon_init_sm_state == SILENT && lane_currupt ) begin //{ 
         lane_currupt = 1'b0;
         lane_break = 1'b0;
  end
endtask

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 

virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 

virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 

endclass : srio_pl_sync0_sync2_break_cb1 


//============================================================================ 
//===========callback for sync1 and sync0 break =======x1m2 to x1r to sl ====== 
//============================================================================ 

class srio_pl_sync0_sync1_break_cb1 extends srio_pl_callback; 
bit lane_break;
bit lane_currupt;

function new (string name = "srio_pl_sync0_sync1_break_cb1"); 
super.new(name);
lane_break = 1'b1; 
endfunction 

static string type_name = "srio_pl_sync0_sync1_break_cb1"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 


virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if (env_config.pl_tx_mon_init_sm_state == X1_RECOVERY && env_config.pl_rx_mon_init_sm_state == X1_RECOVERY && lane_break ) begin //{ 
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
    lane_currupt = 1'b1;
end 

  if (env_config.pl_tx_mon_init_sm_state == SILENT && env_config.pl_rx_mon_init_sm_state == SILENT && lane_currupt ) begin //{ 
         lane_currupt = 1'b0;
         lane_break = 1'b0;
  end
endtask

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 

virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 

virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 

endclass : srio_pl_sync0_sync1_break_cb1 

 // GEN3 --ALIGNED STATE CHANGES 

class srio_pl_gen3_a_a2_a3_a4_sm_callback extends srio_pl_callback; 
int temp = 0;
int align_break =0 ;
int flag = 0;
bit [0:66] brc3_cg_temp;
srio_pl_agent pl_agent_cb ;

static string type_name = "srio_pl_gen3_a_a2_a3_a4_sm_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 
virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
  if(pl_agent_cb.pl_monitor.tx_monitor.srio_pl_sm_ins.current_nx_align_state == ALIGNED) begin //{ 
  if(temp == 0) begin //{
  brc3_cg_temp = tx_srio_cg.brc3_cg;
    if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001111) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110000))) begin //{
       flag = flag + 1;  
   end //} 
  if(flag == 1) begin //{
     tx_srio_cg.brc3_cg[2] = 1;
     tx_srio_cg.brc3_cg[1] = 0;  
     temp = 1;
   end //} 
    end //}
end //}
  endtask

endclass : srio_pl_gen3_a_a2_a3_a4_sm_callback
// GEN3 --ALIGNED STATE CHANGES 
class srio_pl_gen3_a3_a4_a5_a3_sm_callback extends srio_pl_callback; 
bit temp1 = 0 ,temp2 = 0, temp_10 = 0;
int flag0 = 0;
bit [0:66] brc3_cg_temp;
srio_pl_agent pl_agent_cb ;

static string type_name = "srio_pl_gen3_a3_a4_a5_a3_sm_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 
virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 

  if (temp2 && (pl_agent_cb.pl_monitor.tx_monitor.srio_pl_sm_ins.current_nx_align_state == NOT_ALIGNED || pl_agent_cb.pl_monitor.tx_monitor.srio_pl_sm_ins.current_nx_align_state == NOT_ALIGNED_1))
   begin  //{
    temp_10 = 0;
     end //}

  if((pl_agent_cb.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.N_lanes_aligned && pl_agent_cb.pl_monitor.tx_monitor.srio_pl_sm_ins.nx_align_MA_counter == 0) && ~temp2)  begin //{ 
      brc3_cg_temp = tx_srio_cg.brc3_cg; 
      if (brc3_cg_temp[2] && ~temp1)
        temp1 = 1;
      if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001111) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110000)) && temp1) begin //{
        flag0 = flag0 + 1;
     
        if(flag0 == 2) begin //{   

        tx_srio_cg.brc3_cg[2] = 1;
        tx_srio_cg.brc3_cg[1] = 0;
        flag0 = 0;
        temp_10 =1;
        temp2 =1;
               end //}
       end //}
      end //}
    else if(temp_10 == 1) begin //{

      brc3_cg_temp = tx_srio_cg.brc3_cg; 
      if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001111) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110000))) begin //{
        flag0 = flag0 + 1;
     
	if(flag0 == 2) begin //{   
        tx_srio_cg.brc3_cg[2] = 1;
        tx_srio_cg.brc3_cg[1] = 0;
        flag0 = 0;
               end //}
       end //}
   end //}
   
       endtask

  endclass : srio_pl_gen3_a3_a4_a5_a3_sm_callback

// GEN3 --ALIGNED STATE CHANGES 

class srio_pl_gen3_a3_a4_a6_a3_sm_callback extends srio_pl_callback; 
bit temp1 = 0 ,temp2 = 0, temp_10 = 0;
int flag0 = 0;
bit [0:66] brc3_cg_temp;
srio_pl_agent pl_agent_cb ;

static string type_name = "srio_pl_gen3_a3_a4_a6_a3_sm_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 
virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
   if (temp2 && (pl_agent_cb.pl_monitor.tx_monitor.srio_pl_sm_ins.current_nx_align_state == NOT_ALIGNED || pl_agent_cb.pl_monitor.tx_monitor.srio_pl_sm_ins.current_nx_align_state == NOT_ALIGNED_1))
   begin  //{
    temp_10 = 0;
     end //}

  if((pl_agent_cb.pl_monitor.tx_monitor.srio_pl_sm_ins.pl_sm_trans.N_lanes_aligned && pl_agent_cb.pl_monitor.tx_monitor.srio_pl_sm_ins.nx_align_MA_counter == 0) && ~temp2)  begin //{ 
      brc3_cg_temp = tx_srio_cg.brc3_cg; 
      if (brc3_cg_temp[2] && ~temp1)
        temp1 = 1;
      if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001111) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110000)) && temp1) begin //{
        flag0 = flag0 + 1;
     
        if(flag0 == 2) begin //{   

        tx_srio_cg.brc3_cg[2] = 1;
        tx_srio_cg.brc3_cg[1] = 0;
        flag0 = 0;
        temp_10 =1;
        temp2 =1;
               end //}
       end //}
      end //}
    else if(temp_10 == 1) begin //{

      brc3_cg_temp = tx_srio_cg.brc3_cg; 
      if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001111) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110000))) begin //{
        flag0 = flag0 + 1;
     
	if(flag0 == 1) begin //{   
        tx_srio_cg.brc3_cg[2] = 1;
        tx_srio_cg.brc3_cg[1] = 0;
        flag0 = 0;
               end //}
       end //}
   end //}
 endtask

endclass : srio_pl_gen3_a3_a4_a6_a3_sm_callback


//========================================================================= 
//===========callback for sync0 and sync1 break ========1xrecto1xln2======== 
//========================================================================== 

class srio_pl_sync0_sync1_break_callback1 extends srio_pl_callback; 

function new (string name = "srio_pl_sync0_sync1_break_callback1"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_sync0_sync1_break_callback1"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 

virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 

virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 
endclass : srio_pl_sync0_sync1_break_callback1
// SOP STOMP  --- CORRUPT EOP BY STOMP.
class srio_pl_sop_stomp_callback extends srio_pl_callback;
int pkt_size;
bit [0:8] tmp0,tmp1,tmp2,tmp3,tmp4,tmp5,tmp6,tmp7,tmp8;
bit [0:8] flag;
bit [0:12] cal_crc13;
bit [0:37] tmp_crc;
srio_pl_agent pl_agent_cb ; 
function new (string name = "srio_pl_sop_stomp_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_sop_stomp_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_trans_transmit(ref srio_pl_data_trans tx_gen,srio_trans srio_trans_in);
   if(tx_gen.m_type == MERGED_PKT)
    begin //{
       pkt_size = tx_gen.bs_merged_pkt.size() ; 
       tmp8 =tx_gen.bs_merged_pkt[pkt_size -8] ;
       tmp7 =tx_gen.bs_merged_pkt[pkt_size -7] ;
       tmp6 =tx_gen.bs_merged_pkt[pkt_size -6] ;
       tmp5 =tx_gen.bs_merged_pkt[pkt_size -5] ;
       tmp4 =tx_gen.bs_merged_pkt[pkt_size -4] ;
       tmp3 =tx_gen.bs_merged_pkt[pkt_size -3] ;
       tmp2 =tx_gen.bs_merged_pkt[pkt_size -2] ;
       tmp1 =tx_gen.bs_merged_pkt[pkt_size -1] ;
       flag= {tmp6[8],tmp5[1:2]};
    if(flag == 3'b010) begin //{
     tx_gen.bs_merged_pkt[pkt_size -6][8] = 1'b0;
     tx_gen.bs_merged_pkt[pkt_size -5][1:2] = 2'b01;
     tmp_crc={tx_gen.bs_merged_pkt[pkt_size -7][1:8],tx_gen.bs_merged_pkt[pkt_size -6][1:8],tx_gen.bs_merged_pkt[pkt_size -5][1:5]};
     cal_crc13= srio_trans_in.calccrc13(tmp_crc);
     tx_gen.bs_merged_pkt[pkt_size -3][4:8]=cal_crc13[0:4];
      tx_gen.bs_merged_pkt[pkt_size -2][1:8]=cal_crc13[5:12];
    end //}
end //}
endtask

endclass

//************* callback for corrupted lane_sync[0] in SEEK_1X_MODE_RCV ******************

class srio_pl_asymmetry_rcv_s1xmrcv_are_cb extends srio_pl_callback; 

srio_pl_agent pl_agent_cb ;

function new (string name = "srio_pl_asymmetry_rcv_s1xmrcv_are_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_asymmetry_rcv_s1xmrcv_are_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
if (pl_agent_cb.pl_monitor.tx_monitor.srio_pl_sm_ins.current_rcv_width_state == SEEK_1X_MODE_RCV)begin //{

   tx_srio_cg.brc3_cg = 0;

end //}
endtask

endclass

//************* callback for corrupted lane_sync[0] and lane_sync[1] in  SEEK_2X_MODE_RCV state******************

class srio_pl_asymmetry_rcv_s2xmrcv_are_cb extends srio_pl_callback; 

srio_pl_agent pl_agent_cb ;

function new (string name = "srio_pl_asymmetry_rcv_s2xmrcv_are_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_asymmetry_rcv_s2xmrcv_are_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 
if (pl_agent_cb.pl_monitor.tx_monitor.srio_pl_sm_ins.current_rcv_width_state == SEEK_2X_MODE_RCV)begin //{

   tx_srio_cg.brc3_cg = 0;

end //}
endtask

virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 
if (pl_agent_cb.pl_monitor.tx_monitor.srio_pl_sm_ins.current_rcv_width_state == SEEK_2X_MODE_RCV)begin //{

   tx_srio_cg.brc3_cg = 0;

end //}
endtask

endclass

//************* callback for corrupted lane_sync[0] in X1_MODE_RCV ******************

class srio_pl_asymmetry_rcv_x1mrcv_to_are_cb extends srio_pl_callback; 

srio_pl_agent pl_agent_cb ;

function new (string name = "srio_pl_asymmetry_rcv_x1mrcv_to_are_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_asymmetry_rcv_x1mrcv_to_are_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
if (pl_agent_cb.pl_monitor.tx_monitor.srio_pl_sm_ins.current_rcv_width_state == X1_MODE_RCV)begin //{

   tx_srio_cg.brc3_cg = 0;

end //}
endtask

endclass

//************* callback for corrupted lane_sync[0] and lane_sync[1] ******************

class srio_pl_asymmetry_rcv_x2mrcv_to_are_cb extends srio_pl_callback; 

srio_pl_agent pl_agent_cb ;

function new (string name = "srio_pl_asymmetry_rcv_x2mrcv_to_are_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_asymmetry_rcv_x2mrcv_to_are_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 
if (pl_agent_cb.pl_monitor.tx_monitor.srio_pl_sm_ins.current_rcv_width_state == X2_MODE_RCV)begin //{

   tx_srio_cg.brc3_cg = 0;

end //}
endtask

virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 
if (pl_agent_cb.pl_monitor.tx_monitor.srio_pl_sm_ins.current_rcv_width_state == X2_MODE_RCV)begin //{

   tx_srio_cg.brc3_cg = 0;

end //}
endtask

endclass



//========================================================================
//====GEN 2_2 ====== ================& nxm_dis_nxm======================
//========================================================================

class srio_pl_nxm_dis_nxm_cb extends srio_pl_callback; 


bit lane_break ;
bit lane_currupt ;

function new (string name = "srio_pl_nxm_dis_nxm_cb") ;
super.new(name); 
lane_break = 1'b1;
endfunction 

static string type_name = "srio_pl_nxm_dis_nxm_cb" ; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE && env_config.pl_rx_mon_init_sm_state == NX_MODE && lane_break  ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
    lane_currupt = 1'b1;
 end //}

 if (env_config.pl_tx_mon_init_sm_state == DISCOVERY  && env_config.pl_rx_mon_init_sm_state == DISCOVERY && lane_currupt  ) begin //{ 
  lane_break =1'b0 ;
lane_currupt = 1'b0;
end  //}

endtask

endclass

//************* callback for corrupted lane_sync[0] and lane_sync[1] ******************

class srio_pl_asymmetry_rcv_x2rnr_x2mrcv_cb extends srio_pl_callback; 

srio_pl_agent pl_agent_cb ;
bit temp;
function new (string name = "srio_pl_asymmetry_rcv_x2rnr_x2mrcv_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_asymmetry_rcv_x2rnr_x2mrcv_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
if(temp == 0)
begin // {
if(pl_agent_cb.pl_monitor.tx_monitor.srio_pl_sm_ins.current_rcv_width_state == X2_RETRAIN_RCV) 
begin //{
if (pl_agent_cb.pl_monitor.tx_monitor.srio_pl_sm_ins.current_rcv_width_state == X2_RECOVERY_RCV)begin //{

   tx_srio_cg.brc3_cg = 0;
   temp = temp + 1;
end //}
end //}
end //}
endtask

virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
if(temp == 0) 
if(pl_agent_cb.pl_monitor.tx_monitor.srio_pl_sm_ins.current_rcv_width_state == X2_RETRAIN_RCV) 
if (pl_agent_cb.pl_monitor.tx_monitor.srio_pl_sm_ins.current_rcv_width_state == X2_RECOVERY_RCV)begin //{

   tx_srio_cg.brc3_cg = 0;
   temp = temp+1;
end //}
endtask

endclass
//************* callback for corrupted lane_sync[0] ******************

class srio_pl_asymmetry_rcv_x1rnr_x1mrcv_cb extends srio_pl_callback; 

srio_pl_agent pl_agent_cb ;
bit temp;
function new (string name = "srio_pl_asymmetry_rcv_x1rnr_x1mrcv_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_asymmetry_rcv_x1rnr_x1mrcv_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
if(temp == 0)
begin //{
if(pl_agent_cb.pl_monitor.tx_monitor.srio_pl_sm_ins.current_rcv_width_state == X1_RETRAIN_RCV) 
begin //{
if (pl_agent_cb.pl_monitor.tx_monitor.srio_pl_sm_ins.current_rcv_width_state == X1_RECOVERY_RCV)begin //{

   tx_srio_cg.brc3_cg = 0;
   temp = temp + 1;
end //}
end //}
end //}
endtask

endclass

//=================== callback to corrupt crc32_err =============

class srio_pl_tx_crc32_err_cb extends srio_pl_callback; 
bit temp;
function new (string name = "srio_pl_tx_crc32_err_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_tx_crc32_err_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

 virtual task srio_pl_trans_generated(ref srio_trans tx_srio_trans);
   if(temp == 0)
     begin
       tx_srio_trans.pl_err_kind =  LINK_CRC_ERR;
       temp = temp+1;
     end
    else
      tx_srio_trans.pl_err_kind =  NO_ERR;

 endtask 

endclass : srio_pl_tx_crc32_err_cb 

//================== callback for control codeword =============
class srio_pl_cg_invalid_for_skip_callback extends srio_pl_callback; 
int temp = 0;
int temp1 = 0;
int flag = 0;
bit [0:66] brc3_cg_temp;
srio_pl_agent pl_agent_cb ;
static string type_name = "srio_pl_cg_invalid_for_skip_callback"; 
virtual function string get_type_name(); 
return type_name; 
endfunction
virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(env_config.srio_mode == SRIO_GEN30) begin //{
     if(temp == 0)
       begin
         tx_srio_cg.brc3_cg [33:38] = 6'b001011;
          temp = temp+1;
       end
     else
       tx_srio_cg.brc3_cg = 0;
end
endtask  
endclass

// SOP - RESTART RETRY  --- CORRUPT EOP BY RESTRAT RETRY.

class srio_pl_sop_restart_rty_callback extends srio_pl_callback;
int pkt_size;
bit [0:8] tmp0,tmp1,tmp2,tmp3,tmp4,tmp5,tmp6,tmp7,tmp8;
bit [0:8] flag;
bit [0:12] cal_crc13;
bit [0:37] tmp_crc;
srio_pl_agent pl_agent_cb ; 
function new (string name = "srio_pl_sop_restart_rty_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_sop_restart_rty_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_trans_transmit(ref srio_pl_data_trans tx_gen,srio_trans srio_trans_in);
   if(tx_gen.m_type == MERGED_PKT)
    begin //{
       pkt_size = tx_gen.bs_merged_pkt.size() ; 
       tmp8 =tx_gen.bs_merged_pkt[pkt_size -8] ;
       tmp7 =tx_gen.bs_merged_pkt[pkt_size -7] ;
       tmp6 =tx_gen.bs_merged_pkt[pkt_size -6] ;
       tmp5 =tx_gen.bs_merged_pkt[pkt_size -5] ;
       tmp4 =tx_gen.bs_merged_pkt[pkt_size -4] ;
       tmp3 =tx_gen.bs_merged_pkt[pkt_size -3] ;
       tmp2 =tx_gen.bs_merged_pkt[pkt_size -2] ;
       tmp1 =tx_gen.bs_merged_pkt[pkt_size -1] ;
       flag= {tmp6[8],tmp5[1:2]};
    if(flag == 3'b010) begin //{
     tx_gen.bs_merged_pkt[pkt_size -6][8] = 1'b0;
     tx_gen.bs_merged_pkt[pkt_size -5][1:2] = 2'b11;
     tmp_crc={tx_gen.bs_merged_pkt[pkt_size -7][1:8],tx_gen.bs_merged_pkt[pkt_size -6][1:8],tx_gen.bs_merged_pkt[pkt_size -5][1:5]};
     cal_crc13= srio_trans_in.calccrc13(tmp_crc);
     tx_gen.bs_merged_pkt[pkt_size -3][4:8]=cal_crc13[0:4];
      tx_gen.bs_merged_pkt[pkt_size -2][1:8]=cal_crc13[5:12];
    end //}
end //}
endtask

endclass
// SOP - LINK REQ RESET DEVICE  --- CORRUPT EOP BY LINK REQ RESET DEVICE .

class srio_pl_sop_link_req_rst_dev_callback extends srio_pl_callback;
int pkt_size;
bit [0:8] tmp0,tmp1,tmp2,tmp3,tmp4,tmp5,tmp6,tmp7,tmp8;
bit [0:8] flag;
bit [0:12] cal_crc13;
bit [0:37] tmp_crc;
srio_pl_agent pl_agent_cb ; 
function new (string name = "srio_pl_sop_link_req_rst_dev_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_sop_link_req_rst_dev_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_trans_transmit(ref srio_pl_data_trans tx_gen,srio_trans srio_trans_in);
   if(tx_gen.m_type == MERGED_PKT)
    begin //{
       pkt_size = tx_gen.bs_merged_pkt.size() ; 
       tmp8 =tx_gen.bs_merged_pkt[pkt_size -8] ;
       tmp7 =tx_gen.bs_merged_pkt[pkt_size -7] ;
       tmp6 =tx_gen.bs_merged_pkt[pkt_size -6] ;
       tmp5 =tx_gen.bs_merged_pkt[pkt_size -5] ;
       tmp4 =tx_gen.bs_merged_pkt[pkt_size -4] ;
       tmp3 =tx_gen.bs_merged_pkt[pkt_size -3] ;
       tmp2 =tx_gen.bs_merged_pkt[pkt_size -2] ;
       tmp1 =tx_gen.bs_merged_pkt[pkt_size -1] ;
       flag= {tmp6[8],tmp5[1:2]};
    if(flag == 3'b010) begin //{
     tx_gen.bs_merged_pkt[pkt_size -6][8] = 1'b1;
     tx_gen.bs_merged_pkt[pkt_size -5][1:5] = 5'b00011;
     tmp_crc={tx_gen.bs_merged_pkt[pkt_size -7][1:8],tx_gen.bs_merged_pkt[pkt_size -6][1:8],tx_gen.bs_merged_pkt[pkt_size -5][1:5]};
     cal_crc13= srio_trans_in.calccrc13(tmp_crc);
     tx_gen.bs_merged_pkt[pkt_size -3][4:8]=cal_crc13[0:4];
      tx_gen.bs_merged_pkt[pkt_size -2][1:8]=cal_crc13[5:12];
    end //}
end //}
endtask

endclass
// SOP - LINK REQ INPUT STATUS  --- CORRUPT EOP BY LINK REQ INPUT STATUS .

class srio_pl_sop_link_req_inp_stat_callback extends srio_pl_callback;
int pkt_size;
bit [0:8] tmp0,tmp1,tmp2,tmp3,tmp4,tmp5,tmp6,tmp7,tmp8;
bit [0:8] flag;
bit [0:12] cal_crc13;
bit [0:37] tmp_crc;
srio_pl_agent pl_agent_cb ; 
function new (string name = "srio_pl_sop_link_req_inp_stat_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_sop_link_req_inp_stat_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_trans_transmit(ref srio_pl_data_trans tx_gen,srio_trans srio_trans_in);
   if(tx_gen.m_type == MERGED_PKT)
    begin //{
       pkt_size = tx_gen.bs_merged_pkt.size() ; 
       tmp8 =tx_gen.bs_merged_pkt[pkt_size -8] ;
       tmp7 =tx_gen.bs_merged_pkt[pkt_size -7] ;
       tmp6 =tx_gen.bs_merged_pkt[pkt_size -6] ;
       tmp5 =tx_gen.bs_merged_pkt[pkt_size -5] ;
       tmp4 =tx_gen.bs_merged_pkt[pkt_size -4] ;
       tmp3 =tx_gen.bs_merged_pkt[pkt_size -3] ;
       tmp2 =tx_gen.bs_merged_pkt[pkt_size -2] ;
       tmp1 =tx_gen.bs_merged_pkt[pkt_size -1] ;
       flag= {tmp6[8],tmp5[1:2]};
    if(flag == 3'b010) begin //{
     tx_gen.bs_merged_pkt[pkt_size -6][8] = 1'b1;
     tx_gen.bs_merged_pkt[pkt_size -5][1:5] = 5'b00100;
     tmp_crc={tx_gen.bs_merged_pkt[pkt_size -7][1:8],tx_gen.bs_merged_pkt[pkt_size -6][1:8],tx_gen.bs_merged_pkt[pkt_size -5][1:5]};
     cal_crc13= srio_trans_in.calccrc13(tmp_crc);
     tx_gen.bs_merged_pkt[pkt_size -3][4:8]=cal_crc13[0:4];
      tx_gen.bs_merged_pkt[pkt_size -2][1:8]=cal_crc13[5:12];
    end //}
end //}
endtask

endclass



//================== callback to corrupt brc3_stype1_msb =============
class srio_pl_brc3_stype1_msb_cb extends srio_pl_callback; 
bit temp;
function new (string name = "srio_pl_brc3_stype1_msb_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_brc3_stype1_msb_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_trans_generated(ref srio_trans tx_srio_trans);
 //  if(env_config.srio_mode == SRIO_GEN30) begin //{
    tx_srio_trans.brc3_stype1_msb = 2'b11;
      //end //}
 //end //}
endtask 
endclass
// DELIMITER CHANGES -- 7C TO 1C.

class srio_pl_delimiter_change_callback extends srio_pl_callback;
bit [0:8] tmp0,tmp1,tmp2,tmp3,tmp4,tmp5,tmp6,tmp7,tmp8;
bit [0:8] flag;
bit [0:12] cal_crc13;
bit [0:37] tmp_crc;
int pkt_size;
srio_pl_agent pl_agent_cb ; 
function new (string name = "srio_pl_delimiter_change_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_delimiter_change_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_trans_transmit(ref srio_pl_data_trans tx_gen,srio_trans srio_trans_in);
   if(tx_gen.m_type == MERGED_CS)
    begin //{
       tmp0 =tx_gen.bs_merged_cs[0][1:8] ;
       tmp7 =tx_gen.bs_merged_cs[7][1:8] ;
       tmp0[1:8] = 8'h1C;
       tmp7[1:8] = 8'h1C;
       tx_gen.bs_merged_cs[0][1:8] = tmp0[1:8];
       tx_gen.bs_merged_cs[7][1:8] = tmp7[1:8];           
    end //}
   endtask

endclass
// DELIMITER CHANGES FOR STATUS AND NON STATUS CONTROL SYMBOLS-- 7C TO 1C.

class srio_pl_delimiter_changes_status_non_status_cs_callback extends srio_pl_callback;
bit [0:8] tmp0,tmp1,tmp2,tmp3,tmp4,tmp5,tmp6,tmp7,tmp8;
bit [0:8] flag;
bit [0:12] cal_crc13;
bit [0:37] tmp_crc;
int pkt_size;
srio_pl_agent pl_agent_cb ; 
function new (string name = "srio_pl_delimiter_changes_status_non_status_cs_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_delimiter_changes_status_non_status_cs_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_trans_transmit(ref srio_pl_data_trans tx_gen,srio_trans srio_trans_in);
   if(tx_gen.m_type == MERGED_CS)
    begin //{
       tmp0[1:8] =tx_gen.bs_merged_cs[0][1:8] ;
       tmp1[1:8] =tx_gen.bs_merged_cs[1][1:8] ;
       tmp2[1:8] =tx_gen.bs_merged_cs[2][1:8] ;
       tmp3[1:8] =tx_gen.bs_merged_cs[3][1:8] ;
       tmp7[1:8] =tx_gen.bs_merged_cs[7][1:8] ;
      if(((tmp1[1:3] == 3'b100) && ({tmp2[8],tmp3[1:2]} == 3'b111)) || tmp1[1:3] == 3'b000 ) begin //{ 
        
       tmp0[1:8] = 8'h1C;
       tmp7[1:8] = 8'h1C;
       tx_gen.bs_merged_cs[0][1:8] = tmp0[1:8];
       tx_gen.bs_merged_cs[7][1:8] = tmp7[1:8];           
    end //}
   end //}
   endtask

endclass
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////

class srio_pl_sync_reset_sm_callback extends srio_pl_callback; 

 bit lane_break0 ,lane_break1,lane_break2,lane_break3,lane_break4,lane_break5,lane_break6,lane_break7,lane_break8,lane_break9,lane_break10,lane_break11,lane_break12,lane_break13,lane_break14,lane_break15 ;     
 bit lane_currupt0 ,lane_currupt1,lane_currupt2,lane_currupt3,lane_currupt4,lane_currupt5,lane_currupt6,lane_currupt7,lane_currupt8,lane_currupt9,lane_currupt10,lane_currupt11,lane_currupt12,lane_currupt13,lane_currupt14,lane_currupt15 ;

function new (string name = "srio_pl_sync_reset_sm_callback"); 
super.new(name); 
lane_break0=1 ;lane_break1 =1;lane_break2 = 1;lane_break3 = 1;lane_break4 = 1;lane_break5 = 1;lane_break6 = 1 ;lane_break7 =1 ;lane_break8 =1 ;lane_break9 =1 ;lane_break10=1;lane_break11 =1;lane_break12= 1;lane_break13 =1;lane_break14=1;lane_break15 =1;     
endfunction  

static string type_name = "srio_pl_sync_reset_sm_callback"; 
srio_pl_agent pl_agent_cb ;

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[0].current_sync_state == SYNC && lane_break0) begin //{ 
    tx_srio_cg.cg =10'h100;
    lane_currupt0 = 1'b1;
    end //}
  
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[0].current_sync_state == SYNC_1 && lane_currupt0) begin //{ 
    lane_break0 = 1'b0;
    lane_currupt0 = 1'b0;
    end //}

endtask


virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[1].current_sync_state == SYNC && lane_break1) begin //{ 
    tx_srio_cg.cg =10'h100;
    lane_currupt1 = 1'b1;
    end //}
  
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[1].current_sync_state == SYNC_1 && lane_currupt1) begin //{ 
    lane_break1 = 1'b0;
    lane_currupt1 = 1'b0;
    end //}
  
endtask

virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[2].current_sync_state == SYNC && lane_break2) begin //{ 
    tx_srio_cg.cg =10'h100;
    lane_currupt2 = 1'b1;
    end //}
 
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[2].current_sync_state == SYNC_1 && lane_currupt2) begin //{ 
    lane_break2 = 1'b0;
    lane_currupt2 = 1'b0;
    end //}
  

endtask

virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[3].current_sync_state == SYNC && lane_break3) begin //{ 
    tx_srio_cg.cg =10'h100;
    lane_currupt3 = 1'b1;
    end //}
 
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[3].current_sync_state == SYNC_1 && lane_currupt3) begin //{ 
    lane_break3 = 1'b0;
    lane_currupt3 = 1'b0;
    end //}
  

endtask

virtual task srio_pl_cg_generated_lane4 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[4].current_sync_state == SYNC && lane_break4) begin //{ 
    tx_srio_cg.cg =10'h100;
    lane_currupt4 = 1'b1;
    end //}
 
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[4].current_sync_state == SYNC_1 && lane_currupt4) begin //{ 
    lane_break4 = 1'b0;
    lane_currupt4 = 1'b0;
    end //}
 
endtask

virtual task srio_pl_cg_generated_lane5 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[5].current_sync_state == SYNC && lane_break5) begin //{ 
    tx_srio_cg.cg =10'h100;
    lane_currupt5 = 1'b1;
    end //}
 
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[5].current_sync_state == SYNC_1 && lane_currupt5) begin //{ 
    lane_break5 = 1'b0;
    lane_currupt5 = 1'b0;
    end //}
 

endtask

virtual task srio_pl_cg_generated_lane6 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[6].current_sync_state == SYNC && lane_break6) begin //{ 
    tx_srio_cg.cg =10'h100;
    lane_currupt6 = 1'b1;
    end //}

 
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[6].current_sync_state == SYNC_1 && lane_currupt6) begin //{ 
    lane_break6 = 1'b0;
    lane_currupt6 = 1'b0;
    end //}
 
endtask

virtual task srio_pl_cg_generated_lane7 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[7].current_sync_state == SYNC && lane_break7) begin //{ 
    tx_srio_cg.cg =10'h100;
    lane_currupt7 = 1'b1;
    end //}
 
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[7].current_sync_state == SYNC_1 && lane_currupt7) begin //{ 
    lane_break7 = 1'b0;
    lane_currupt7 = 1'b0;
    end //}
 
endtask

virtual task srio_pl_cg_generated_lane8 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[8].current_sync_state == SYNC && lane_break8) begin //{ 
    tx_srio_cg.cg =10'h100;
    lane_currupt8 = 1'b1;
    end //}

 
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[8].current_sync_state == SYNC_1 && lane_currupt8) begin //{ 
    lane_break8 = 1'b0;
    lane_currupt8 = 1'b0;
    end //}
 
endtask

virtual task srio_pl_cg_generated_lane9 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[9].current_sync_state == SYNC && lane_break9) begin //{ 
    tx_srio_cg.cg =10'h100;
    lane_currupt9 = 1'b1;
    end //}
 
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[9].current_sync_state == SYNC_1 && lane_currupt9) begin //{ 
    lane_break9 = 1'b0;
    lane_currupt9 = 1'b0;
    end //}
 
endtask

virtual task srio_pl_cg_generated_lane10 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[10].current_sync_state == SYNC && lane_break10) begin //{ 
    tx_srio_cg.cg =10'h100;
    lane_currupt10 = 1'b1;
    end //}
 
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[10].current_sync_state == SYNC_1 && lane_currupt10) begin //{ 
    lane_break10 = 1'b0;
    lane_currupt10 = 1'b0;
    end //}
 
endtask

virtual task srio_pl_cg_generated_lane11 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[11].current_sync_state == SYNC && lane_break11) begin //{ 
    tx_srio_cg.cg =10'h100;
    lane_currupt11 = 1'b1;
    end //}
 
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[11].current_sync_state == SYNC_1 && lane_currupt11) begin //{ 
    lane_break11 = 1'b0;
    lane_currupt11 = 1'b0;
    end //}
 
endtask

virtual task srio_pl_cg_generated_lane12 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[12].current_sync_state == SYNC && lane_break12) begin //{ 
    tx_srio_cg.cg =10'h100;
    lane_currupt12 = 1'b1;
    end //}
 
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[12].current_sync_state == SYNC_1 && lane_currupt12) begin //{ 
    lane_break12 = 1'b0;
    lane_currupt12 = 1'b0;
    end //}
 
endtask

virtual task srio_pl_cg_generated_lane13 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[13].current_sync_state == SYNC && lane_break13) begin //{ 
    tx_srio_cg.cg =10'h100;
    lane_currupt13 = 1'b1;
    end //}
 
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[13].current_sync_state == SYNC_1 && lane_currupt13) begin //{ 
    lane_break13 = 1'b0;
    lane_currupt13 = 1'b0;
    end //}
 
endtask

virtual task srio_pl_cg_generated_lane14 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[14].current_sync_state == SYNC && lane_break14) begin //{ 
    tx_srio_cg.cg =10'h100;
    lane_currupt14 = 1'b1;
    end //}
 
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[14].current_sync_state == SYNC_1 && lane_currupt14) begin //{ 
    lane_break14 = 1'b0;
    lane_currupt14 = 1'b0;
    end //}
 
endtask

virtual task srio_pl_cg_generated_lane15 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[15].current_sync_state == SYNC && lane_break15) begin //{ 
    tx_srio_cg.cg =10'h100;
   lane_currupt15 = 1'b1;
    end //}
 
   if(pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[15].current_sync_state == SYNC_1 && lane_currupt15) begin //{ 
    lane_break15 = 1'b0;
    lane_currupt15 = 1'b0;
    end //}
 
endtask

endclass


//========================================================================
//====lane2 and 3 // nxm_nxr_nxrn_nxr_2x ====== NX_RECOVERY TO 2XMODE =
//========================================================================

class srio_pl_nxm_nxr_nxrn_nxr_2x_cb extends srio_pl_callback; 
bit lane_break ;

function new (string name = "srio_pl_nxm_nxr_nxrn_nxr_2x_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_nxm_nxr_nxrn_nxr_2x_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);

 if (env_config.pl_tx_mon_init_sm_state == NX_RETRAIN && env_config.pl_rx_mon_init_sm_state == NX_RETRAIN  ) begin //{ 
     lane_break = 1'b1;
end //}

 if (env_config.pl_tx_mon_init_sm_state == NX_RECOVERY && env_config.pl_rx_mon_init_sm_state == NX_RECOVERY && lane_break ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
end //}
endtask 


virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);

 if (env_config.pl_tx_mon_init_sm_state == NX_RETRAIN && env_config.pl_rx_mon_init_sm_state == NX_RETRAIN  ) begin //{ 
     lane_break = 1'b1;
end //}


 if (env_config.pl_tx_mon_init_sm_state == NX_RECOVERY && env_config.pl_rx_mon_init_sm_state == NX_RECOVERY && lane_break ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
end //}
endtask 
endclass : srio_pl_nxm_nxr_nxrn_nxr_2x_cb


//========================================================================
//====lane2 and 3 // srio_pl_nxm_nxr_nxrn_nxr_x1m0_test ====== 
//========================================================================

class srio_pl_nxm_nxr_nxrn_nxr_x1m0_cb extends srio_pl_callback; 
bit lane_break ;

function new (string name = "srio_pl_nxm_nxr_nxrn_nxr_x1m0_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_nxm_nxr_nxrn_nxr_x1m0_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);

 if (env_config.pl_tx_mon_init_sm_state == NX_RETRAIN && env_config.pl_rx_mon_init_sm_state == NX_RETRAIN  ) begin //{ 
     lane_break = 1'b1;
end //}


 if (env_config.pl_tx_mon_init_sm_state == NX_RECOVERY && env_config.pl_rx_mon_init_sm_state == NX_RECOVERY &&  lane_break ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
end //}
endtask 


virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 
 if (env_config.pl_tx_mon_init_sm_state == NX_RETRAIN && env_config.pl_rx_mon_init_sm_state == NX_RETRAIN  ) begin //{ 
     lane_break = 1'b1;
end //}

if (env_config.pl_tx_mon_init_sm_state == NX_RECOVERY && env_config.pl_rx_mon_init_sm_state == NX_RECOVERY && lane_break ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
end //}
endtask 


virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 
 if (env_config.pl_tx_mon_init_sm_state == NX_RETRAIN && env_config.pl_rx_mon_init_sm_state == NX_RETRAIN  ) begin //{ 
     lane_break = 1'b1;
end //}


 if (env_config.pl_tx_mon_init_sm_state == NX_RECOVERY && env_config.pl_rx_mon_init_sm_state == NX_RECOVERY && lane_break ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
end //}
endtask 
endclass : srio_pl_nxm_nxr_nxrn_nxr_x1m0_cb



//========================================================================
//====lane2 and 3 // srio_pl_nxm_nxr_nxrn_nxr_x1m1_test ====== 
//========================================================================

class srio_pl_nxm_nxr_nxrn_nxr_x1m1_cb extends srio_pl_callback; 
bit lane_break ;

function new (string name = "srio_pl_nxm_nxr_nxrn_nxr_x1m1_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_nxm_nxr_nxrn_nxr_x1m1_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 
 if (env_config.pl_tx_mon_init_sm_state == NX_RETRAIN && env_config.pl_rx_mon_init_sm_state == NX_RETRAIN  ) begin //{ 
     lane_break = 1'b1;
end //}


 if (env_config.pl_tx_mon_init_sm_state == NX_RECOVERY && env_config.pl_rx_mon_init_sm_state == NX_RECOVERY && lane_break ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
end //}
endtask 


virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 
 if (env_config.pl_tx_mon_init_sm_state == NX_RETRAIN && env_config.pl_rx_mon_init_sm_state == NX_RETRAIN  ) begin //{ 
     lane_break = 1'b1;
end //}


 if (env_config.pl_tx_mon_init_sm_state == NX_RECOVERY && env_config.pl_rx_mon_init_sm_state == NX_RECOVERY && lane_break ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
end //}
endtask 


virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 
 if (env_config.pl_tx_mon_init_sm_state == NX_RETRAIN && env_config.pl_rx_mon_init_sm_state == NX_RETRAIN  ) begin //{ 
     lane_break = 1'b1;
end //}


 if (env_config.pl_tx_mon_init_sm_state == NX_RECOVERY && env_config.pl_rx_mon_init_sm_state == NX_RECOVERY && lane_break ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
end //}
endtask 
endclass : srio_pl_nxm_nxr_nxrn_nxr_x1m1_cb


//========================================================================
//====lane2 and 3 // srio_pl_nxm_nxr_nxrn_nxr_x1m2_test ====== 
//========================================================================

class srio_pl_nxm_nxr_nxrn_nxr_x1m2_cb extends srio_pl_callback; 
bit lane_break ;

function new (string name = "srio_pl_nxm_nxr_nxrn_nxr_x1m2_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_nxm_nxr_nxrn_nxr_x1m2_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 
 if (env_config.pl_tx_mon_init_sm_state == NX_RETRAIN && env_config.pl_rx_mon_init_sm_state == NX_RETRAIN  ) begin //{ 
     lane_break = 1'b1;
end //}


 if (env_config.pl_tx_mon_init_sm_state == NX_RECOVERY && env_config.pl_rx_mon_init_sm_state == NX_RECOVERY && lane_break ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
end //}
endtask 


virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 
 if (env_config.pl_tx_mon_init_sm_state == NX_RETRAIN && env_config.pl_rx_mon_init_sm_state == NX_RETRAIN  ) begin //{ 
     lane_break = 1'b1;
end //}


 if (env_config.pl_tx_mon_init_sm_state == NX_RECOVERY && env_config.pl_rx_mon_init_sm_state == NX_RECOVERY && lane_break ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
end //}
endtask 


virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 
 if (env_config.pl_tx_mon_init_sm_state == NX_RETRAIN && env_config.pl_rx_mon_init_sm_state == NX_RETRAIN  ) begin //{ 
     lane_break = 1'b1;
end //}


 if (env_config.pl_tx_mon_init_sm_state == NX_RECOVERY && env_config.pl_rx_mon_init_sm_state == NX_RECOVERY && lane_break ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
end //}
endtask 
endclass : srio_pl_nxm_nxr_nxrn_nxr_x1m2_cb
//=== SYNC BREAK 

class srio_pl_sync_break_1_callback extends srio_pl_callback; 
int temp0 =0,temp1 = 0,temp2 =0 ,temp3 =0,temp4 =0,temp5 =0,temp6 =0,temp7 =0,temp8 =0,temp9 =0,temp10 =0,temp11 =0,temp12 =0,temp13 =0,temp14 =0,temp15 =0 ;
srio_pl_agent pl_agent_cb ;
function new (string name = "srio_pl_sync_break_1_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_sync_break_1_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if (pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[0].current_sync_state == SYNC )  begin //{
     if(temp0 ==0 ) begin //{  
   tx_srio_cg.cg =10'h100;
    temp0 =1;
    end //}
 end //}
     endtask 

virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if (pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[1].current_sync_state == SYNC )  begin //{
     if(temp1 ==0 ) begin //{  
   tx_srio_cg.cg =10'h100;
    temp1 =1;
    end //}
 end //}
     endtask 
virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if (pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[2].current_sync_state == SYNC )  begin //{
     if(temp2 ==0 ) begin //{  
   tx_srio_cg.cg =10'h100;
    temp2 =1;
    end //}
 end //}
     endtask 
virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if (pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[3].current_sync_state == SYNC )  begin //{
     if(temp3 ==0 ) begin //{  
   tx_srio_cg.cg =10'h100;
    temp3 =1;
    end //}
 end //}
     endtask 
virtual task srio_pl_cg_generated_lane4 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if (pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[4].current_sync_state == SYNC )  begin //{
     if(temp4 ==0 ) begin //{  
   tx_srio_cg.cg =10'h100;
    temp4 =1;
    end //}
 end //}
     endtask 
virtual task srio_pl_cg_generated_lane5 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if (pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[5].current_sync_state == SYNC )  begin //{
     if(temp5 ==0 ) begin //{  
   tx_srio_cg.cg =10'h100;
    temp5 =1;
    end //}
 end //}
     endtask 
virtual task srio_pl_cg_generated_lane6 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if (pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[6].current_sync_state == SYNC )  begin //{
     if(temp6 ==0 ) begin //{  
   tx_srio_cg.cg =10'h100;
    temp6 =1;
    end //}
 end //}
     endtask 
virtual task srio_pl_cg_generated_lane7 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if (pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[7].current_sync_state == SYNC )  begin //{
     if(temp7 ==0 ) begin //{  
   tx_srio_cg.cg =10'h100;
    temp7 =1;
    end //}
 end //}
     endtask 
virtual task srio_pl_cg_generated_lane8 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if (pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[8].current_sync_state == SYNC )  begin //{
     if(temp8 ==0 ) begin //{  
   tx_srio_cg.cg =10'h100;
    temp8 =1;
    end //}
 end //}
     endtask 
virtual task srio_pl_cg_generated_lane9 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if (pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[9].current_sync_state == SYNC )  begin //{
     if(temp9 ==0 ) begin //{  
   tx_srio_cg.cg =10'h100;
    temp9 =1;
    end //}
 end //}
     endtask 
virtual task srio_pl_cg_generated_lane10 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if (pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[10].current_sync_state == SYNC )  begin //{
     if(temp10 ==0 ) begin //{  
   tx_srio_cg.cg =10'h100;
    temp10 =1;
    end //}
 end //}
     endtask 
virtual task srio_pl_cg_generated_lane11 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if (pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[11].current_sync_state == SYNC )  begin //{
     if(temp11 ==0 ) begin //{  
   tx_srio_cg.cg =10'h100;
    temp11 =1;
    end //}
 end //}
     endtask 
virtual task srio_pl_cg_generated_lane12 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if (pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[12].current_sync_state == SYNC )  begin //{
     if(temp12 ==0 ) begin //{  
   tx_srio_cg.cg =10'h100;
    temp12 =1;
    end //}
 end //}
     endtask 
virtual task srio_pl_cg_generated_lane13 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if (pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[13].current_sync_state == SYNC )  begin //{
     if(temp13 ==0 ) begin //{  
   tx_srio_cg.cg =10'h100;
    temp13 =1;
    end //}
 end //}
     endtask 
virtual task srio_pl_cg_generated_lane14 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if (pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[14].current_sync_state == SYNC )  begin //{
     if(temp14 ==0 ) begin //{  
   tx_srio_cg.cg =10'h100;
    temp14 =1;
    end //}
 end //}
     endtask 
virtual task srio_pl_cg_generated_lane15 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if (pl_agent_cb.pl_monitor.tx_monitor.lane_handle_ins[15].current_sync_state == SYNC )  begin //{
     if(temp15 ==0 ) begin //{  
   tx_srio_cg.cg =10'h100;
    temp15 =1;
    end //}
 end //}
     endtask 

endclass : srio_pl_sync_break_1_callback 



//========================================================================
//====lane2 and 3 // srio_pl_nxm_nxr_nxrn_nxr_sil_test ====== 
//========================================================================

class srio_pl_nxm_nxr_nxrn_nxr_sil_cb extends srio_pl_callback; 
bit lane_break ;

function new (string name = "srio_pl_nxm_nxr_nxrn_nxr_sil_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_nxm_nxr_nxrn_nxr_sil_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 
 if (env_config.pl_tx_mon_init_sm_state == NX_RETRAIN && env_config.pl_rx_mon_init_sm_state == NX_RETRAIN  ) begin //{ 
     lane_break = 1'b1;
end //}


 if (env_config.pl_tx_mon_init_sm_state == NX_RECOVERY && env_config.pl_rx_mon_init_sm_state == NX_RECOVERY && lane_break ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
end //}
endtask 


virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 
 if (env_config.pl_tx_mon_init_sm_state == NX_RETRAIN && env_config.pl_rx_mon_init_sm_state == NX_RETRAIN  ) begin //{ 
     lane_break = 1'b1;
end //}


 if (env_config.pl_tx_mon_init_sm_state == NX_RECOVERY && env_config.pl_rx_mon_init_sm_state == NX_RECOVERY && lane_break ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
end //}
endtask 

virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 
 if (env_config.pl_tx_mon_init_sm_state == NX_RETRAIN && env_config.pl_rx_mon_init_sm_state == NX_RETRAIN  ) begin //{ 
     lane_break = 1'b1;
end //}


 if (env_config.pl_tx_mon_init_sm_state == NX_RECOVERY && env_config.pl_rx_mon_init_sm_state == NX_RECOVERY && lane_break ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
end //}
endtask 

virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 
 if (env_config.pl_tx_mon_init_sm_state == NX_RETRAIN && env_config.pl_rx_mon_init_sm_state == NX_RETRAIN  ) begin //{ 
     lane_break = 1'b1;
end //}


 if (env_config.pl_tx_mon_init_sm_state == NX_RECOVERY && env_config.pl_rx_mon_init_sm_state == NX_RECOVERY && lane_break ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
end //}
endtask 
endclass : srio_pl_nxm_nxr_nxrn_nxr_sil_cb


//=================================================================================
//=================srio_pl_x2m_x2r_x2rn_x2r_x1m0_lanes2_test=======================
//=================================================================================

class srio_pl_x2m_x2r_x2rn_x2r_x1m0_cb extends srio_pl_callback; 
bit lane_break ;

function new (string name = "srio_pl_x2m_x2r_x2rn_x2r_x1m0_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_x2m_x2r_x2rn_x2r_x1m0_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction

virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 
 if (env_config.pl_tx_mon_init_sm_state == X2_RETRAIN && env_config.pl_rx_mon_init_sm_state == X2_RETRAIN  ) begin //{ 
     lane_break = 1'b1;
end //}


 if (env_config.pl_tx_mon_init_sm_state == X2_RECOVERY && env_config.pl_rx_mon_init_sm_state == X2_RECOVERY && lane_break ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
end //}
endtask 



virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 

virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 


endclass :srio_pl_x2m_x2r_x2rn_x2r_x1m0_cb

//=================================================================================
//=================srio_pl_x2m_x2r_x2rn_x2r_x1m1_lanes2_test=======================
//=================================================================================

class srio_pl_x2m_x2r_x2rn_x2r_x1m1_cb extends srio_pl_callback; 
bit lane_break ;

function new (string name = "srio_pl_x2m_x2r_x2rn_x2r_x1m1_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_x2m_x2r_x2rn_x2r_x1m1_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 
 if (env_config.pl_tx_mon_init_sm_state == X2_RETRAIN && env_config.pl_rx_mon_init_sm_state == X2_RETRAIN  ) begin //{ 
     lane_break = 1'b1;
end //}


 if (env_config.pl_tx_mon_init_sm_state == X2_RECOVERY && env_config.pl_rx_mon_init_sm_state == X2_RECOVERY && lane_break ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
end //}
endtask 



virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 

virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 


endclass :srio_pl_x2m_x2r_x2rn_x2r_x1m1_cb

//=================================================================================
//=================srio_pl_x2m_x2r_x2rn_x2r_sil_lanes2_test=======================
//=================================================================================

class srio_pl_x2m_x2r_x2rn_x2r_sil_cb extends srio_pl_callback; 
bit lane_break ;

function new (string name = "srio_pl_x2m_x2r_x2rn_x2r_sil_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_x2m_x2r_x2rn_x2r_sil_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 
 if (env_config.pl_tx_mon_init_sm_state == X2_RETRAIN && env_config.pl_rx_mon_init_sm_state == X2_RETRAIN  ) begin //{ 
     lane_break = 1'b1;
end //}


 if (env_config.pl_tx_mon_init_sm_state == X2_RECOVERY && env_config.pl_rx_mon_init_sm_state == X2_RECOVERY && lane_break ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
end //}
endtask 


virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 
 if (env_config.pl_tx_mon_init_sm_state == X2_RETRAIN && env_config.pl_rx_mon_init_sm_state == X2_RETRAIN  ) begin //{ 
     lane_break = 1'b1;
end //}


 if (env_config.pl_tx_mon_init_sm_state == X2_RECOVERY && env_config.pl_rx_mon_init_sm_state == X2_RECOVERY && lane_break ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
end //}
endtask 



virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 

virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 


endclass :srio_pl_x2m_x2r_x2rn_x2r_sil_cb

//============================================================================ 
//===========x1m1_x1r_x1rn_x1r_sil  ========================================= 
//============================================================================ 

class srio_pl_x1m1_x1r_x1rn_x1r_sil_cb1 extends srio_pl_callback; 
bit lane_break;
bit lane_currupt;

function new (string name = "srio_pl_x1m1_x1r_x1rn_x1r_sil_cb1"); 
super.new(name);
//lane_break = 1'b1; 
endfunction 

static string type_name = "srio_pl_x1m1_x1r_x1rn_x1r_sil_cb1"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 


virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 
 if (env_config.pl_tx_mon_init_sm_state == X1_RETRAIN && env_config.pl_rx_mon_init_sm_state == X1_RETRAIN  ) begin //{ 
     lane_break = 1'b1;
end //}

  if (env_config.pl_tx_mon_init_sm_state == X1_RECOVERY && env_config.pl_rx_mon_init_sm_state == X1_RECOVERY && lane_break ) begin //{ 
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
    lane_currupt = 1'b1;
end 

  if (env_config.pl_tx_mon_init_sm_state == SILENT && env_config.pl_rx_mon_init_sm_state == SILENT && lane_currupt ) begin //{ 
         lane_currupt = 1'b0;
         lane_break = 1'b0;
  end
endtask

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 

virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 

virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 

endclass : srio_pl_x1m1_x1r_x1rn_x1r_sil_cb1 



//============================================================================ 
//========== srio_pl_x1m2_x1r_x1rn_x1r_sl_cb    =========================== 
//============================================================================ 

class srio_pl_x1m2_x1r_x1rn_x1r_sl_cb extends srio_pl_callback; 
bit lane_break;
bit lane_currupt;

function new (string name = "srio_pl_x1m2_x1r_x1rn_x1r_sl_cb "); 
super.new(name);
endfunction 

static string type_name = "srio_pl_x1m2_x1r_x1rn_x1r_sl_cb "; 

virtual function string get_type_name(); 
return type_name; 
endfunction 


virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 
 if (env_config.pl_tx_mon_init_sm_state == X1_RETRAIN && env_config.pl_rx_mon_init_sm_state == X1_RETRAIN  ) begin //{ 
     lane_break = 1'b1;
end //}

  if (env_config.pl_tx_mon_init_sm_state == X1_RECOVERY && env_config.pl_rx_mon_init_sm_state == X1_RECOVERY && lane_break ) begin //{ 
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
    lane_currupt = 1'b1;
end 

  if (env_config.pl_tx_mon_init_sm_state == SILENT && env_config.pl_rx_mon_init_sm_state == SILENT && lane_currupt ) begin //{ 
         lane_currupt = 1'b0;
         lane_break = 1'b0;
  end
endtask

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 

virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 

virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 

endclass : srio_pl_x1m2_x1r_x1rn_x1r_sl_cb 



//=============================================================== 
//=========== srio_pl_x1m0_x1r_x1rn_x1r_sl_cb ===================
//=============================================================== 

class srio_pl_x1m0_x1r_x1rn_x1r_sl_cb extends srio_pl_callback; 
bit lane_break;
bit lane_currupt;

function new (string name = "srio_pl_x1m0_x1r_x1rn_x1r_sl_cb"); 
super.new(name);
endfunction 

static string type_name = "srio_pl_x1m0_x1r_x1rn_x1r_sl_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 


virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 
 if (env_config.pl_tx_mon_init_sm_state == X1_RETRAIN && env_config.pl_rx_mon_init_sm_state == X1_RETRAIN  ) begin //{ 
     lane_break = 1'b1;
end //}


  if (env_config.pl_tx_mon_init_sm_state == X1_RECOVERY && env_config.pl_rx_mon_init_sm_state == X1_RECOVERY && lane_break ) begin //{ 
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
    lane_currupt = 1'b1;
end 

  if (env_config.pl_tx_mon_init_sm_state == SILENT && env_config.pl_rx_mon_init_sm_state == SILENT && lane_currupt ) begin //{ 
         lane_currupt = 1'b0;
         lane_break = 1'b0;
  end
endtask

virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 

virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 

virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
endtask 

endclass :srio_pl_x1m0_x1r_x1rn_x1r_sl_cb  


//===============================================================
//=========== srio_pl_nxr_nxrn_nxr_sil_cb========================= 
//===============================================================

class  srio_pl_nxr_nxrn_nxr_sil_cb extends srio_pl_callback; 

bit lane_break ;
bit lane_currupt ;

function new (string name = "srio_pl_nxr_nxrn_nxr_sil_cb"); 
super.new(name);
lane_break = 1'b1;
endfunction 

static string type_name = "srio_pl_nxr_nxrn_nxr_sil_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);

 if (env_config.pl_tx_mon_init_sm_state == NX_MODE && env_config.pl_rx_mon_init_sm_state == NX_MODE && lane_break ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
 end //}

if (env_config.pl_tx_mon_init_sm_state == NX_RETRAIN && env_config.pl_rx_mon_init_sm_state == NX_RETRAIN ) begin //{ 
    lane_currupt = 1'b1;
 end //}

if (env_config.pl_tx_mon_init_sm_state == NX_RECOVERY && env_config.pl_rx_mon_init_sm_state == NX_RECOVERY && lane_currupt) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
 end //}


if (env_config.pl_tx_mon_init_sm_state == SILENT && env_config.pl_rx_mon_init_sm_state == SILENT && lane_currupt ) begin //{ 
lane_break = 1'b0;
lane_currupt = 1'b0 ;
end //}

endtask 

virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
 

 if (env_config.pl_tx_mon_init_sm_state == NX_MODE && env_config.pl_rx_mon_init_sm_state == NX_MODE && lane_break ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
 end //}

if (env_config.pl_tx_mon_init_sm_state == NX_RETRAIN && env_config.pl_rx_mon_init_sm_state == NX_RETRAIN ) begin //{ 
    lane_currupt = 1'b1;
 end //}

if (env_config.pl_tx_mon_init_sm_state == NX_RECOVERY && env_config.pl_rx_mon_init_sm_state == NX_RECOVERY && lane_currupt) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
 end //}


if (env_config.pl_tx_mon_init_sm_state == SILENT && env_config.pl_rx_mon_init_sm_state == SILENT && lane_currupt ) begin //{ 
lane_break = 1'b0;
lane_currupt = 1'b0 ;
end //}

endtask 


virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);

if (env_config.pl_tx_mon_init_sm_state == NX_RETRAIN && env_config.pl_rx_mon_init_sm_state == NX_RETRAIN ) begin //{ 
    lane_currupt = 1'b1;
 end //}

 if (env_config.pl_tx_mon_init_sm_state == NX_RECOVERY && env_config.pl_rx_mon_init_sm_state == NX_RECOVERY && lane_currupt ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
 end //}
endtask 


virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);

if (env_config.pl_tx_mon_init_sm_state == NX_RETRAIN && env_config.pl_rx_mon_init_sm_state == NX_RETRAIN ) begin //{ 
    lane_currupt = 1'b1;
 end //}

 if (env_config.pl_tx_mon_init_sm_state == NX_RECOVERY && env_config.pl_rx_mon_init_sm_state == NX_RECOVERY && lane_currupt ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
 end //}
endtask 


endclass :srio_pl_nxr_nxrn_nxr_sil_cb 


//========================================
//=== srio_pl_x2m_x2r_x2rn_x2r_sil========
//========================================

class srio_pl_srio_pl_x2m_x2r_x2rn_x2r_sil_cb extends srio_pl_callback; 

bit lane_break;
bit lane_currupt ;
function new (string name = "srio_pl_x2m_x2r_x2rn_x2r_sil_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_x2m_x2r_x2rn_x2r_sil_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 

if (env_config.pl_tx_mon_init_sm_state == X2_RETRAIN && env_config.pl_rx_mon_init_sm_state == X2_RETRAIN  ) begin //{ 
lane_currupt = 1'b1 ;
end

if (env_config.pl_tx_mon_init_sm_state == X2_RECOVERY && env_config.pl_rx_mon_init_sm_state == X2_RECOVERY && lane_currupt ) begin //{ 
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
end //}
endtask 

virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);

if (env_config.pl_tx_mon_init_sm_state == X2_RETRAIN && env_config.pl_rx_mon_init_sm_state == X2_RETRAIN  ) begin //{ 
lane_currupt = 1'b1 ;
end

 if (env_config.pl_tx_mon_init_sm_state == X2_RECOVERY && env_config.pl_rx_mon_init_sm_state == X2_RECOVERY && lane_currupt ) begin //{ 
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
end //}
endtask 

virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;

 if (env_config.pl_tx_mon_init_sm_state == X2_MODE && env_config.pl_rx_mon_init_sm_state == X2_MODE  ) begin //{ 
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
 end

endtask

virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;

 if (env_config.pl_tx_mon_init_sm_state == X2_MODE && env_config.pl_rx_mon_init_sm_state == X2_MODE  ) begin //{ 
   tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
 end

endtask

endclass : srio_pl_srio_pl_x2m_x2r_x2rn_x2r_sil_cb 
//IDLE 2 CORRUPTION.

class srio_pl_idle2_cs_marker_field_corrupt_callback extends srio_pl_callback;
int m_detect;
bit [0:65] tmp0;
bit  flag;
bit [0:8] temp; 
function new (string name = "srio_pl_idle2_cs_marker_field_corrupt_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_idle2_cs_marker_field_corrupt_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_char_transmitted_lane0(ref bit [0:65] idle_field_char,srio_env_config env_config);
  if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{

  if(flag == 0 ) begin //{
  tmp0= idle_field_char;
  temp = tmp0[57:65];   
      if(temp == 9'h13C)   begin //{
      m_detect++; 
      end //}
       if((m_detect) &&!(temp == 9'h13C)) begin //{
       m_detect = 0;
       end //}
        if(m_detect == 3) begin //{
         idle_field_char[57:65] = 9'h000;
         flag = 1;
         end //}
  end //}
  end //}
         endtask

endclass

//IDLE 2 CORRUPTION -- D21.5 .

class srio_pl_idle2_cs_marker_d21_5_corrupt_callback extends srio_pl_callback;
int m_detect;
bit [0:65] tmp0;
bit  flag,corrupt_cnt;
bit [0:8] temp;
function new (string name = "srio_pl_idle2_cs_marker_d21_5_corrupt_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_idle2_cs_marker_d21_5_corrupt_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_char_transmitted_lane0(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{ 
  if(flag == 0 ) begin //{
  tmp0= idle_field_char;
  temp = tmp0[57:65];
      if(temp == 9'h13C)   begin //{
      m_detect++;
      end //}
       if((m_detect) &&!(temp == 9'h13C)) begin //{
       m_detect = 0;
       end //}
        if(m_detect == 4) begin //{
         corrupt_cnt =1;
        end //}
      if((corrupt_cnt == 1) && (temp == 9'h0B5)) begin //{
         idle_field_char = 9'h000;        
         corrupt_cnt = 0;
         flag =  1;
         end //}
  end //}
  end //}
         endtask

endclass

//IDLE 2 CORRUPTION -- CS FIELD.

class srio_pl_idle2_cs_field_corrupt_callback extends srio_pl_callback;
int m_detect;
bit [0:65] tmp0;
bit  flag,corrupt_cnt;
bit [0:8] temp;
function new (string name = "srio_pl_idle2_cs_field_corrupt_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_idle2_cs_field_corrupt_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_char_transmitted_lane0(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{
  if(flag == 0 ) begin //{
  tmp0= idle_field_char;
  temp = tmp0[57:65];
 
      if(temp == 9'h13C)   begin //{
      m_detect++;
      end //}
       if((m_detect) &&!(temp == 9'h13C)) begin //{
       m_detect = 0;
       end //}
        if(m_detect == 4) begin //{
         corrupt_cnt =1;
        end //}
      if((corrupt_cnt == 1) && (temp == 9'h067)) begin //{
         idle_field_char = 9'h000;         
         corrupt_cnt = 0;
         flag =  1;
         end //}
  end //}
  end //}   
   endtask

endclass
//IDLE 2 CORRUPTION LOSS OF DESC SYNC

class srio_pl_idle2_loss_desc_sync_corrupt_callback extends srio_pl_callback;
int m_detect,d_detect;
bit [0:65] tmp0;
bit  flag;
bit [0:8] temp; 
function new (string name = "srio_pl_idle2_loss_desc_sync_corrupt_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_idle2_loss_desc_sync_corrupt_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_char_transmitted_lane0(ref bit [0:65] idle_field_char,srio_env_config env_config);
  if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{
  if(flag == 0 ) begin //{
  tmp0= idle_field_char;
  temp = tmp0[57:65];   
      if(temp == 9'h13C)   begin //{
      m_detect = 1; 
      end //}
       if((m_detect) &&(temp == 9'h000)) begin //{
       d_detect++; 
       end //}
       if((d_detect) &&!(temp == 9'h000)) begin //{
       d_detect = 0;
       end //}

        if((m_detect == 1)&&(d_detect == 4 )) begin //{
         idle_field_char[57:65] = 9'h0B5;
         m_detect = 0;
         flag = 1;
          end //}
  end //}
  end //}
         endtask

endclass
//IDLE 2 CORRUPTION PSEUDO RANDOM DATA FIELD

class srio_pl_idle2_pseudo_random_data_field_corrupt_callback extends srio_pl_callback;
int o_detect,rd_detect;
bit [0:65] tmp0;
bit  flag;
bit [0:8] temp; 
function new (string name = "srio_pl_idle2_pseudo_random_data_field_corrupt_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_idle2_pseudo_random_data_field_corrupt_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_char_transmitted_lane0(ref bit [0:65] idle_field_char,srio_env_config env_config);
  if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{
  if(flag == 0 ) begin //{
  tmp0= idle_field_char;
  temp = tmp0[57:65]; 
    
       if(!(o_detect) &&(temp == 9'h000)) begin //{
       rd_detect++;
        end //}
       if(!(o_detect) &&!(temp == 9'h000)) begin //{
       rd_detect = 0;
       end //}

        if(!(o_detect == 1)&&(rd_detect == 10 )) begin //{
         idle_field_char[57:65] = 9'h0B5;
         o_detect = 1;
         flag = 1;
         end //}
  end //}
  end //}
         endtask

endclass
//GEN3 INVALID ORDERED SEQUENCES.

class srio_pl_gen3_invalid_ordered_seq_callback extends srio_pl_callback;
int sm_detect,sc_detect;
bit  flag,lc_cnt;
bit [0:65] temp;
function new (string name = "srio_pl_gen3_invalid_ordered_seq_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_gen3_invalid_ordered_seq_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_char_transmitted_lane0(ref bit [0:65] idle_field_char,srio_env_config env_config);

  if(flag == 0 ) begin //{
  temp = idle_field_char; 
       if(temp[32:37] == 6'b001110) begin //{
       sc_detect++;
       sm_detect = 1;
       end //}
       if((sm_detect) &&!(temp[32:37] == 6'b001110)) begin //{
       sc_detect = 0;
       sm_detect = 0;
        end //}
        if(sc_detect == 3) begin //{
         lc_cnt =1;
        end //}
      if((lc_cnt == 1) && (temp[32:37] == 6'b001100)) begin //{
         idle_field_char[32:37] = 6'b001011 ;         
         lc_cnt = 0;
         flag =  1;
         end //}
  end //}
     
   endtask

endclass

// GEN3 -- CORRUPTION IN SKIP ORDER SEQUENCE.
class srio_pl_gen3_incorrect_skip_order_seq_callback extends srio_pl_callback; 
bit [0:66] brc3_cg_temp;
int sc_detect0,sc_detect1,sc_detect2,sc_detect3,sc_detect4,sc_detect5,sc_detect6,sc_detect7,sc_detect8,sc_detect9,sc_detect10,sc_detect11,sc_detect12,sc_detect13,sc_detect14,sc_detect15;
bit  flag0,flag1,flag2,flag3,flag4,flag5,flag6,flag7,flag8,flag9,flag10,flag11,flag12,flag13,flag14,flag15;
bit lc_cnt0,lc_cnt1,lc_cnt2,lc_cnt3,lc_cnt4,lc_cnt5,lc_cnt6,lc_cnt7,lc_cnt8,lc_cnt9,lc_cnt10,lc_cnt11,lc_cnt12,lc_cnt13,lc_cnt14,lc_cnt15;
bit sm_detect0,sm_detect1,sm_detect2,sm_detect3,sm_detect4,sm_detect5,sm_detect6,sm_detect7,sm_detect8,sm_detect9,sm_detect10,sm_detect11,sm_detect12,sm_detect13,sm_detect14,sm_detect15;
bit sc_set0,sc_set1,sc_set2,sc_set3,sc_set4,sc_set5,sc_set6,sc_set7,sc_set8,sc_set9,sc_set10,sc_set11,sc_set12,sc_set13,sc_set14,sc_set15;
static string type_name = "srio_pl_gen3_incorrect_skip_order_seq_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 
virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag0 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect0++;
     sc_set0 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set0 ) begin //{ 
     sc_detect0 = 0;
     sc_set0 = 0;
      end //}
      if(sc_detect0 == 3) begin //{
      lc_cnt0 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt0) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;
     lc_cnt0 = 0;
     flag0 =  1;

     end //}
   
   end //}
endtask
virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag1 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect1++;
     sc_set1 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set1 ) begin //{ 
     sc_detect1 = 0;
     sc_set1 = 0;
      end //}
      if(sc_detect1 == 3) begin //{
      lc_cnt1 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt1) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;
     lc_cnt1 = 0;
     flag1 =  1;

     end //}
   
   end //}
endtask
virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag2 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect2++;
     sc_set2 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set2 ) begin //{ 
     sc_detect2 = 0;
     sc_set2 = 0;
      end //}
      if(sc_detect2 == 3) begin //{
      lc_cnt2 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt2) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;
     lc_cnt2 = 0;
     flag2 =  1;

     end //}
   
   end //}
endtask
virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag3 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect3++;
     sc_set3 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set3 ) begin //{ 
     sc_detect3 = 0;
     sc_set3 = 0;
      end //}
      if(sc_detect3 == 3) begin //{
      lc_cnt3 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt3) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;
     lc_cnt3 = 0;
     flag3 =  1;

     end //}
   
   end //}
endtask
virtual task srio_pl_cg_generated_lane4 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag4 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect4++;
     sc_set4 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set4 ) begin //{ 
     sc_detect4 = 0;
     sc_set4 = 0;
      end //}
      if(sc_detect4 == 3) begin //{
      lc_cnt4 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt4) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;
     lc_cnt4 = 0;
     flag4 =  1;

     end //}
   
   end //}
endtask
virtual task srio_pl_cg_generated_lane5 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag5 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect5++;
     sc_set5 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set5 ) begin //{ 
     sc_detect5 = 0;
     sc_set5 = 0;
      end //}
      if(sc_detect5 == 3) begin //{
      lc_cnt5 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt5) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;
     lc_cnt5 = 0;
     flag5 =  1;

     end //}
   
   end //}
endtask
virtual task srio_pl_cg_generated_lane6 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag6 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect6++;
     sc_set6 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set6 ) begin //{ 
     sc_detect6 = 0;
     sc_set6 = 0;
      end //}
      if(sc_detect6 == 3) begin //{
      lc_cnt6 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt6) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;
     lc_cnt6 = 0;
     flag6 =  1;

     end //}
   
   end //}
endtask
virtual task srio_pl_cg_generated_lane7 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag7 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect7++;
     sc_set7 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set7 ) begin //{ 
     sc_detect7 = 0;
     sc_set7 = 0;
      end //}
      if(sc_detect7 == 3) begin //{
      lc_cnt7 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt7) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;
     lc_cnt7 = 0;
     flag7 =  1;

     end //}
   
   end //}
endtask
virtual task srio_pl_cg_generated_lane8 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag8 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect8++;
     sc_set8 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set8 ) begin //{ 
     sc_detect8 = 0;
     sc_set8 = 0;
      end //}
      if(sc_detect8 == 3) begin //{
      lc_cnt8 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt8) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;
     lc_cnt8 = 0;
     flag8 =  1;

     end //}
   
   end //}
endtask
virtual task srio_pl_cg_generated_lane9 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag9 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect9++;
     sc_set9 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set9 ) begin //{ 
     sc_detect9 = 0;
     sc_set9 = 0;
      end //}
      if(sc_detect9 == 3) begin //{
      lc_cnt9 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt9) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;
     lc_cnt9 = 0;
     flag9 =  1;

     end //}
   
   end //}
endtask
virtual task srio_pl_cg_generated_lane10 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag10 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect10++;
     sc_set10 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set10 ) begin //{ 
     sc_detect10 = 0;
     sc_set10 = 0;
      end //}
      if(sc_detect10 == 3) begin //{
      lc_cnt10 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt10) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;
     lc_cnt10 = 0;
     flag10 =  1;

     end //}
   
   end //}
endtask
virtual task srio_pl_cg_generated_lane11 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag11 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect11++;
     sc_set11 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set11 ) begin //{ 
     sc_detect11 = 0;
     sc_set11 = 0;
      end //}
      if(sc_detect11 == 3) begin //{
      lc_cnt11 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt11) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;
     lc_cnt11 = 0;
     flag11 =  1;

     end //}
   
   end //}
endtask
virtual task srio_pl_cg_generated_lane12 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag12 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect12++;
     sc_set12 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set12 ) begin //{ 
     sc_detect12 = 0;
     sc_set12 = 0;
      end //}
      if(sc_detect12 == 3) begin //{
      lc_cnt12 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt12) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;
     lc_cnt12 = 0;
     flag12 =  1;

     end //}
   
   end //}
endtask
virtual task srio_pl_cg_generated_lane13 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag13 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect13++;
     sc_set13 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set13 ) begin //{ 
     sc_detect13 = 0;
     sc_set13 = 0;
      end //}
      if(sc_detect13 == 3) begin //{
      lc_cnt13 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt13) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;
     lc_cnt13 = 0;
     flag13 =  1;

     end //}
   
   end //}
endtask
virtual task srio_pl_cg_generated_lane14 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag14 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect14++;
     sc_set14 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set14 ) begin //{ 
     sc_detect14 = 0;
     sc_set14 = 0;
      end //}
      if(sc_detect14 == 3) begin //{
      lc_cnt14 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt14) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;
     lc_cnt14 = 0;
     flag14 =  1;

     end //}
   
   end //}
endtask
virtual task srio_pl_cg_generated_lane15 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag15 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect15++;
     sc_set15 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set15 ) begin //{ 
     sc_detect15 = 0;
     sc_set15 = 0;
      end //}
      if(sc_detect15 == 3) begin //{
      lc_cnt15 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt15) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;
     lc_cnt15 = 0;
     flag15 =  1;

     end //}
   
   end //}
endtask

endclass

// GEN3 -- CORRUPTION IN SKIP ORDER SEQUENCE.
class srio_pl_gen3_incorrect_skip_order_1_seq_callback extends srio_pl_callback; 
bit [0:66] brc3_cg_temp;
int sc_detect0,sc_detect1,sc_detect2,sc_detect3,sc_detect4,sc_detect5,sc_detect6,sc_detect7,sc_detect8,sc_detect9,sc_detect10,sc_detect11,sc_detect12,sc_detect13,sc_detect14,sc_detect15;
bit  flag0,flag1,flag2,flag3,flag4,flag5,flag6,flag7,flag8,flag9,flag10,flag11,flag12,flag13,flag14,flag15;
bit lc_cnt0,lc_cnt1,lc_cnt2,lc_cnt3,lc_cnt4,lc_cnt5,lc_cnt6,lc_cnt7,lc_cnt8,lc_cnt9,lc_cnt10,lc_cnt11,lc_cnt12,lc_cnt13,lc_cnt14,lc_cnt15;
bit ds_cnt0,ds_cnt1,ds_cnt2,ds_cnt3,ds_cnt4,ds_cnt5,ds_cnt6,ds_cnt7,ds_cnt8,ds_cnt9,ds_cnt10,ds_cnt11,ds_cnt12,ds_cnt13,ds_cnt14,ds_cnt15;
bit sm_detect0,sm_detect1,sm_detect2,sm_detect3,sm_detect4,sm_detect5,sm_detect6,sm_detect7,sm_detect8,sm_detect9,sm_detect10,sm_detect11,sm_detect12,sm_detect13,sm_detect14,sm_detect15;
bit sc_set0,sc_set1,sc_set2,sc_set3,sc_set4,sc_set5,sc_set6,sc_set7,sc_set8,sc_set9,sc_set10,sc_set11,sc_set12,sc_set13,sc_set14,sc_set15;

static string type_name = "srio_pl_gen3_incorrect_skip_order_1_seq_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 
virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag0 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect0++;
     sc_set0 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set0 ) begin //{ 
     sc_detect0 = 0;
     sc_set0 = 0;
      end //}
      if(sc_detect0 == 3) begin //{
      lc_cnt0 =1;
      
     end //}
     
   if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt0) begin //{
     lc_cnt0 = 0;
     ds_cnt0 = 1;
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001101) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110010)) && ds_cnt0) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;    
     flag0 =  1;

     end //}
   end //}
endtask
virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag1 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect1++;
     sc_set1 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set1 ) begin //{ 
     sc_detect1 = 0;
     sc_set1 = 0;
      end //}
      if(sc_detect1 == 3) begin //{
      lc_cnt1 =1;
      
     end //}
      if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt1) begin //{
     lc_cnt1 = 0;
     ds_cnt1 = 1;
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001101) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110010)) && ds_cnt1) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;    
     flag1 =  1;

     end //}  
   end //}
endtask
virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag2 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect2++;
     sc_set2 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set2 ) begin //{ 
     sc_detect2 = 0;
     sc_set2 = 0;
      end //}
      if(sc_detect2 == 3) begin //{
      lc_cnt2 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt2) begin //{
     lc_cnt2 = 0;
     ds_cnt2 = 1;
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001101) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110010)) && ds_cnt2) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;    
     flag2 =  1;

     end //}
   
   end //}
endtask
virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag3 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect3++;
     sc_set3 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set3 ) begin //{ 
     sc_detect3 = 0;
     sc_set3 = 0;
      end //}
      if(sc_detect3 == 3) begin //{
      lc_cnt3 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt3) begin //{
     lc_cnt3 = 0;
     ds_cnt3 = 1;
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001101) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110010)) && ds_cnt3) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;    
     flag3 =  1;

     end //}
   
   end //}
endtask
virtual task srio_pl_cg_generated_lane4 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag4 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect4++;
     sc_set4 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set4 ) begin //{ 
     sc_detect4 = 0;
     sc_set4 = 0;
      end //}
      if(sc_detect4 == 3) begin //{
      lc_cnt4 =1;
      
     end //}
     
   if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt4) begin //{
     lc_cnt4 = 0;
     ds_cnt4 = 1;
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001101) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110010)) && ds_cnt4) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;    
     flag4 =  1;

     end //}
   end //}
endtask
virtual task srio_pl_cg_generated_lane5 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag5 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect5++;
     sc_set5 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set5 ) begin //{ 
     sc_detect5 = 0;
     sc_set5 = 0;
      end //}
      if(sc_detect5 == 3) begin //{
      lc_cnt5 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt5) begin //{
     lc_cnt5 = 0;
     ds_cnt5 = 1;
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001101) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110010)) && ds_cnt5) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;    
     flag5 =  1;

     end //}
   
   end //}
endtask
virtual task srio_pl_cg_generated_lane6 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag6 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect6++;
     sc_set6 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set6 ) begin //{ 
     sc_detect6 = 0;
     sc_set6 = 0;
      end //}
      if(sc_detect6 == 3) begin //{
      lc_cnt6 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt6) begin //{
     lc_cnt6 = 0;
     ds_cnt6 = 1;
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001101) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110010)) && ds_cnt6) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;    
     flag6 =  1;

     end //}
   
   end //}
endtask
virtual task srio_pl_cg_generated_lane7 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag7 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect7++;
     sc_set7 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set7 ) begin //{ 
     sc_detect7 = 0;
     sc_set7 = 0;
      end //}
      if(sc_detect7 == 3) begin //{
      lc_cnt7 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt7) begin //{
     lc_cnt7 = 0;
     ds_cnt7 = 1;
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001101) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110010)) && ds_cnt7) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;    
     flag7 =  1;

     end //}
   
   end //}
endtask
virtual task srio_pl_cg_generated_lane8 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag8 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect8++;
     sc_set8 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set8 ) begin //{ 
     sc_detect8 = 0;
     sc_set8 = 0;
      end //}
      if(sc_detect8 == 3) begin //{
      lc_cnt8 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt8) begin //{
     lc_cnt8 = 0;
     ds_cnt8 = 1;
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001101) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110010)) && ds_cnt8) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;    
     flag8 =  1;

     end //}
   
   end //}
endtask
virtual task srio_pl_cg_generated_lane9 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag9 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect9++;
     sc_set9 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set9 ) begin //{ 
     sc_detect9 = 0;
     sc_set9 = 0;
      end //}
      if(sc_detect9 == 3) begin //{
      lc_cnt9 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt9) begin //{
     lc_cnt9 = 0;
     ds_cnt9 = 1;
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001101) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110010)) && ds_cnt9) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;    
     flag9 =  1;

     end //}
   
   end //}
endtask
virtual task srio_pl_cg_generated_lane10 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag10 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect10++;
     sc_set10 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set10 ) begin //{ 
     sc_detect10 = 0;
     sc_set10 = 0;
      end //}
      if(sc_detect10 == 3) begin //{
      lc_cnt10 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt10) begin //{
     lc_cnt10 = 0;
     ds_cnt10 = 1;
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001101) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110010)) && ds_cnt10) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;    
     flag10 =  1;

     end //}
   
   end //}
endtask
virtual task srio_pl_cg_generated_lane11 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag11 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect11++;
     sc_set11 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set11 ) begin //{ 
     sc_detect11 = 0;
     sc_set11 = 0;
      end //}
      if(sc_detect11 == 3) begin //{
      lc_cnt11 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt11) begin //{
     lc_cnt11 = 0;
     ds_cnt11 = 1;
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001101) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110010)) && ds_cnt11) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;    
     flag11 =  1;

     end //}
   
   end //}
endtask
virtual task srio_pl_cg_generated_lane12 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag12 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect12++;
     sc_set12 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set12 ) begin //{ 
     sc_detect12 = 0;
     sc_set12 = 0;
      end //}
      if(sc_detect12 == 3) begin //{
      lc_cnt12 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt12) begin //{
     lc_cnt12 = 0;
     ds_cnt12 = 1;
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001101) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110010)) && ds_cnt12) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;    
     flag12 =  1;

     end //}
   
   end //}
endtask
virtual task srio_pl_cg_generated_lane13 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag13 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect13++;
     sc_set13 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set13 ) begin //{ 
     sc_detect13 = 0;
     sc_set13 = 0;
      end //}
      if(sc_detect13 == 3) begin //{
      lc_cnt13 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt13) begin //{
     lc_cnt13 = 0;
     ds_cnt13 = 1;
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001101) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110010)) && ds_cnt13) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;    
     flag13 =  1;

     end //}
   
   end //}
endtask
virtual task srio_pl_cg_generated_lane14 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag14 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect14++;
     sc_set14 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set14 ) begin //{ 
     sc_detect14 = 0;
     sc_set14 = 0;
      end //}
      if(sc_detect14 == 3) begin //{
      lc_cnt14 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt14) begin //{
     lc_cnt14 = 0;
     ds_cnt14 = 1;
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001101) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110010)) && ds_cnt14) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;    
     flag14 =  1;

     end //}
   
   end //}
endtask
virtual task srio_pl_cg_generated_lane15 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag15 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect15++;
     sc_set15 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set15 ) begin //{ 
     sc_detect15 = 0;
     sc_set15 = 0;
      end //}
      if(sc_detect15 == 3) begin //{
      lc_cnt15 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt15) begin //{
     lc_cnt15 = 0;
     ds_cnt15 = 1;
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001101) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110010)) && ds_cnt15) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;    
     flag15 =  1;

     end //}
   
   end //}
endtask

endclass
// GEN3 -- CORRUPTION IN SKIP ORDER SEQUENCE.
class srio_pl_gen3_incorrect_skip_order_2_seq_callback extends srio_pl_callback; 
bit [0:66] brc3_cg_temp;
int sc_detect0,sc_detect1,sc_detect2,sc_detect3,sc_detect4,sc_detect5,sc_detect6,sc_detect7,sc_detect8,sc_detect9,sc_detect10,sc_detect11,sc_detect12,sc_detect13,sc_detect14,sc_detect15;
int des_cnt0,des_cnt1,des_cnt2,des_cnt3,des_cnt4,des_cnt5,des_cnt6,des_cnt7,des_cnt8,des_cnt9,des_cnt10,des_cnt11,des_cnt12,des_cnt13,des_cnt14,des_cnt15;
bit  flag0,flag1,flag2,flag3,flag4,flag5,flag6,flag7,flag8,flag9,flag10,flag11,flag12,flag13,flag14,flag15;
bit lc_cnt0,lc_cnt1,lc_cnt2,lc_cnt3,lc_cnt4,lc_cnt5,lc_cnt6,lc_cnt7,lc_cnt8,lc_cnt9,lc_cnt10,lc_cnt11,lc_cnt12,lc_cnt13,lc_cnt14,lc_cnt15;
bit ds_cnt0,ds_cnt1,ds_cnt2,ds_cnt3,ds_cnt4,ds_cnt5,ds_cnt6,ds_cnt7,ds_cnt8,ds_cnt9,ds_cnt10,ds_cnt11,ds_cnt12,ds_cnt13,ds_cnt14,ds_cnt15;
bit sm_detect0,sm_detect1,sm_detect2,sm_detect3,sm_detect4,sm_detect5,sm_detect6,sm_detect7,sm_detect8,sm_detect9,sm_detect10,sm_detect11,sm_detect12,sm_detect13,sm_detect14,sm_detect15;
bit sc_set0,sc_set1,sc_set2,sc_set3,sc_set4,sc_set5,sc_set6,sc_set7,sc_set8,sc_set9,sc_set10,sc_set11,sc_set12,sc_set13,sc_set14,sc_set15;

static string type_name = "srio_pl_gen3_incorrect_skip_order_2_seq_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 
virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag0 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect0++;
     sc_set0 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set0 ) begin //{ 
     sc_detect0 = 0;
     sc_set0 = 0;
      end //}
      if(sc_detect0 == 3) begin //{
      lc_cnt0 =1;
      
     end //}
     
   if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt0) begin //{
     lc_cnt0 = 0;
     ds_cnt0 = 1;
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001101) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110010)) && ds_cnt0) begin //{
     des_cnt0++;
     end //}
     if(des_cnt0 == 2) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;    
     flag0 =  1;

     end //}
   end //}
endtask
virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag1 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect1++;
     sc_set1 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set1 ) begin //{ 
     sc_detect1 = 0;
     sc_set1 = 0;
      end //}
      if(sc_detect1 == 3) begin //{
      lc_cnt1 =1;
      
     end //}
      if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt1) begin //{
     lc_cnt1 = 0;
     ds_cnt1 = 1;
     end //}
      if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001101) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110010)) && ds_cnt0) begin //{
     des_cnt1++;
     end //}
     if(des_cnt1 == 2) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;    
     flag1 =  1;

     end //}
   end //}
endtask
virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag2 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect2++;
     sc_set2 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set2 ) begin //{ 
     sc_detect2 = 0;
     sc_set2 = 0;
      end //}
      if(sc_detect2 == 3) begin //{
      lc_cnt2 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt2) begin //{
     lc_cnt2 = 0;
     ds_cnt2 = 1;
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001101) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110010)) && ds_cnt0) begin //{
     des_cnt2++;
     end //}
     if(des_cnt2 == 2) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;    
     flag2 =  1;

     end //}  
   end //}
endtask
virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag3 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect3++;
     sc_set3 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set3 ) begin //{ 
     sc_detect3 = 0;
     sc_set3 = 0;
      end //}
      if(sc_detect3 == 3) begin //{
      lc_cnt3 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt3) begin //{
     lc_cnt3 = 0;
     ds_cnt3 = 1;
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001101) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110010)) && ds_cnt0) begin //{
     des_cnt3++;
     end //}
     if(des_cnt3 == 2) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;    
     flag3 =  1;

     end //}
   
   end //}
endtask
virtual task srio_pl_cg_generated_lane4 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag4 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect4++;
     sc_set4 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set4 ) begin //{ 
     sc_detect4 = 0;
     sc_set4 = 0;
      end //}
      if(sc_detect4 == 3) begin //{
      lc_cnt4 =1;
      
     end //}
     
   if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt4) begin //{
     lc_cnt4 = 0;
     ds_cnt4 = 1;
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001101) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110010)) && ds_cnt0) begin //{
     des_cnt4++;
     end //}
     if(des_cnt4 == 2) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;    
     flag4 =  1;

     end //}
   end //}
endtask
virtual task srio_pl_cg_generated_lane5 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag5 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect5++;
     sc_set5 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set5 ) begin //{ 
     sc_detect5 = 0;
     sc_set5 = 0;
      end //}
      if(sc_detect5 == 3) begin //{
      lc_cnt5 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt5) begin //{
     lc_cnt5 = 0;
     ds_cnt5 = 1;
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001101) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110010)) && ds_cnt0) begin //{
     des_cnt5++;
     end //}
     if(des_cnt5 == 2) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;    
     flag5 =  1;

     end //}
   
   end //}
endtask
virtual task srio_pl_cg_generated_lane6 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag6 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect6++;
     sc_set6 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set6 ) begin //{ 
     sc_detect6 = 0;
     sc_set6 = 0;
      end //}
      if(sc_detect6 == 3) begin //{
      lc_cnt6 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt6) begin //{
     lc_cnt6 = 0;
     ds_cnt6 = 1;
     end //}
       if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001101) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110010)) && ds_cnt0) begin //{
     des_cnt6++;
     end //}
     if(des_cnt6 == 2) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;    
     flag6 =  1;

     end //} 
   end //}
endtask
virtual task srio_pl_cg_generated_lane7 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag7 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect7++;
     sc_set7 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set7 ) begin //{ 
     sc_detect7 = 0;
     sc_set7 = 0;
      end //}
      if(sc_detect7 == 3) begin //{
      lc_cnt7 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt7) begin //{
     lc_cnt7 = 0;
     ds_cnt7 = 1;
     end //}
    if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001101) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110010)) && ds_cnt0) begin //{
     des_cnt7++;
     end //}
     if(des_cnt7 == 2) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;    
     flag7 =  1;

     end //}
   
   end //}
endtask
virtual task srio_pl_cg_generated_lane8 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag8 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect8++;
     sc_set8 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set8 ) begin //{ 
     sc_detect8 = 0;
     sc_set8 = 0;
      end //}
      if(sc_detect8 == 3) begin //{
      lc_cnt8 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt8) begin //{
     lc_cnt8 = 0;
     ds_cnt8 = 1;
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001101) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110010)) && ds_cnt0) begin //{
     des_cnt8++;
     end //}
     if(des_cnt8 == 2) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;    
     flag8 =  1;

     end //}
   
   end //}
endtask
virtual task srio_pl_cg_generated_lane9 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag9 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect9++;
     sc_set9 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set9 ) begin //{ 
     sc_detect9 = 0;
     sc_set9 = 0;
      end //}
      if(sc_detect9 == 3) begin //{
      lc_cnt9 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt9) begin //{
     lc_cnt9 = 0;
     ds_cnt9 = 1;
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001101) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110010)) && ds_cnt0) begin //{
     des_cnt9++;
     end //}
     if(des_cnt9 == 2) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;    
     flag9 =  1;

     end //}
   
   end //}
endtask
virtual task srio_pl_cg_generated_lane10 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag10 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect10++;
     sc_set10 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set10 ) begin //{ 
     sc_detect10 = 0;
     sc_set10 = 0;
      end //}
      if(sc_detect10 == 3) begin //{
      lc_cnt10 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt10) begin //{
     lc_cnt10 = 0;
     ds_cnt10 = 1;
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001101) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110010)) && ds_cnt0) begin //{
     des_cnt10++;
     end //}
     if(des_cnt10 == 2) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;    
     flag10 =  1;

     end //}
   
   end //}
endtask
virtual task srio_pl_cg_generated_lane11 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag11 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect11++;
     sc_set11 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set11 ) begin //{ 
     sc_detect11 = 0;
     sc_set11 = 0;
      end //}
      if(sc_detect11 == 3) begin //{
      lc_cnt11 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt11) begin //{
     lc_cnt11 = 0;
     ds_cnt11 = 1;
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001101) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110010)) && ds_cnt0) begin //{
     des_cnt11++;
     end //}
     if(des_cnt11 == 2) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;    
     flag11 =  1;

     end //}
   
   end //}
endtask
virtual task srio_pl_cg_generated_lane12 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag12 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect12++;
     sc_set12 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set12 ) begin //{ 
     sc_detect12 = 0;
     sc_set12 = 0;
      end //}
      if(sc_detect12 == 3) begin //{
      lc_cnt12 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt12) begin //{
     lc_cnt12 = 0;
     ds_cnt12 = 1;
     end //}
     
   if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001101) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110010)) && ds_cnt0) begin //{
     des_cnt12++;
     end //}
     if(des_cnt12 == 2) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;    
     flag12 =  1;

     end //}
   end //}
endtask
virtual task srio_pl_cg_generated_lane13 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag13 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect13++;
     sc_set13 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set13 ) begin //{ 
     sc_detect13 = 0;
     sc_set13 = 0;
      end //}
      if(sc_detect13 == 3) begin //{
      lc_cnt13 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt13) begin //{
     lc_cnt13 = 0;
     ds_cnt13 = 1;
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001101) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110010)) && ds_cnt0) begin //{
     des_cnt13++;
     end //}
     if(des_cnt13 == 2) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;    
     flag13 =  1;

     end //}
   
   end //}
endtask
virtual task srio_pl_cg_generated_lane14 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag14 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect14++;
     sc_set14 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set14 ) begin //{ 
     sc_detect14 = 0;
     sc_set14 = 0;
      end //}
      if(sc_detect14 == 3) begin //{
      lc_cnt14 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt14) begin //{
     lc_cnt14 = 0;
     ds_cnt14 = 1;
     end //}
       if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001101) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110010)) && ds_cnt0) begin //{
     des_cnt14++;
     end //}
     if(des_cnt14 == 2) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;    
     flag14 =  1;

     end //} 
   end //}
endtask
virtual task srio_pl_cg_generated_lane15 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
    
     if(flag15 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001))) begin //{ 
     sc_detect15++;
     sc_set15 = 1;
     end //}
     if(~brc3_cg_temp[2] && !((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001110) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110001)) && sc_set15 ) begin //{ 
     sc_detect15 = 0;
     sc_set15 = 0;
      end //}
      if(sc_detect15 == 3) begin //{
      lc_cnt15 =1;
      
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011)) && lc_cnt15) begin //{
     lc_cnt15 = 0;
     ds_cnt15 = 1;
     end //}
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001101) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110010)) && ds_cnt0) begin //{
     des_cnt15++;
     end //}
     if(des_cnt15 == 2) begin //{
     tx_srio_cg.brc3_cg[33:38] = 6'b001011;    
     flag15 =  1;

     end //}
   
   end //}
endtask

endclass

// FINAL CRC CORRUPTION

class srio_pl_final_crc_corrupt_callback extends srio_pl_callback;
int pkt_size;
bit [0:8] tmp7;
function new (string name = "srio_pl_final_crc_corrupt_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_final_crc_corrupt_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_trans_transmit(ref srio_pl_data_trans tx_gen,srio_trans srio_trans_in);
   if(tx_gen.m_type == MERGED_PKT)
    begin //{
       pkt_size = tx_gen.bs_merged_pkt.size() ; 
       tx_gen.bs_merged_pkt[80] = 9'h100;
    end //}
endtask

endclass

//================================================================================ 
//== callback to corrupt CSE or CSEB to CSB  
//================================================================================ 

class srio_pl_start_cw_open_context_err_cb extends srio_pl_callback;
 
function new (string name = "srio_pl_start_cw_open_context_err_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_start_cw_open_context_err_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(env_config.srio_mode == SRIO_GEN30) begin //{
         if((tx_srio_cg.brc3_type == 0 ) && ((tx_srio_cg.brc3_cc_type == 2'b10)||(tx_srio_cg.brc3_cc_type == 2'b11)))
           begin //{
             tx_srio_cg.brc3_cg[33:34] =2'b01;
           end //}
      
end //} 
endtask 

endclass : srio_pl_start_cw_open_context_err_cb

//================================================================================ 
//== callback to corrupt CSB to CSE  
//================================================================================ 

class srio_pl_end_cw_closed_context_err_cb extends srio_pl_callback;
bit [1:0] temp;
function new (string name = "srio_pl_end_cw_closed_context_err_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_end_cw_closed_context_err_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(env_config.srio_mode == SRIO_GEN30) begin //{
     if(temp != 3)
       begin //{
         if((tx_srio_cg.brc3_type == 0 ) && (tx_srio_cg.brc3_cc_type == 2'b01))
           begin //{
             tx_srio_cg.brc3_cg[33:34] =2'b10;
             temp = temp+1;
           end //}
      end //}
end //} 
endtask 

endclass : srio_pl_end_cw_closed_context_err_cb


//================================================================================ 
//== callback to corrupt CSB to CSE  
//================================================================================ 

class srio_pl_end_cw_corrupted_to_data_err_cb extends srio_pl_callback;
bit [1:0] temp;
function new (string name = "srio_pl_end_cw_corrupted_to_data_err_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_end_cw_corrupted_to_data_err_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(env_config.srio_mode == SRIO_GEN30) begin //{
     if(temp != 3)
       begin //{
         if((tx_srio_cg.brc3_type == 0 ) && (tx_srio_cg.brc3_cc_type == 2'b10))
           begin //{
             tx_srio_cg.brc3_cg[1:2] =2'b01;
             temp = temp+1;
           end //}
      end //}
end //} 
endtask 

endclass : srio_pl_end_cw_corrupted_to_data_err_cb

//IDLE 2 CORRUPTION -- CS FIELD for introducing multiple commands in AET

class srio_pl_idle2_cs_field_aet_cmd_corrupt_callback extends srio_pl_callback;
int m_detect;
bit [0:65] tmp0;
bit  flag,corrupt_cnt;
bit [0:8] temp;
bit [3:0] cs_field_count;
bit cmd_check;
bit [3:0] cmd_cnt;
function new (string name = "srio_pl_idle2_cs_field_aet_cmd_corrupt_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_idle2_cs_field_aet_cmd_corrupt_callback"; 


virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_char_transmitted_lane0(ref bit [0:65] idle_field_char,srio_env_config env_config);
     if(flag == 0 ) begin //{
       tmp0= idle_field_char;
       temp = tmp0[57:65];
       if(temp == 9'h13C)   begin //{
         m_detect++;
         end //}
       if((m_detect) &&!(temp == 9'h13C)) begin //{
         m_detect = 0;
         end //}
        if(m_detect == 4) begin //{
          corrupt_cnt =1;
          end //}
        /*if(corrupt_cnt == 1)
          begin
            if((cmd_cnt == 4) && (temp == 9'h067))
              cmd_check = 1;
            else
              cmd_cnt = cmd_cnt++;
           end*/
        if(temp == 9'h067 && corrupt_cnt == 1) //need to be modified the character as 9'h7e
           cmd_check = 1;
        if((cmd_check == 1)&&(corrupt_cnt == 1) && ((temp == 9'h067)||(temp == 9'h078)||(temp == 9'h07e)||(temp == 9'h0f8))) begin //{
        
         if((cs_field_count == 13)||(cs_field_count == 14)||(cs_field_count == 15))
         begin // {
         idle_field_char = 9'h078;

         end //}
         else 
         begin //{
         idle_field_char = idle_field_char;
         end //}
         if(cs_field_count == 16)
         begin // {     
         flag =  1;  
         corrupt_cnt = 0;
         cs_field_count = 0;
         cmd_check = 0;
         end //}
         else
          begin //{
          cs_field_count++;     
          end //}  
         end //}
   end //}
  
endtask
endclass

//IDLE 2 CORRUPTION -- CS FIELD for introducing multiple commands in AET

class srio_pl_idle2_cs_field_aet_ack_nack_corrupt_callback extends srio_pl_callback;
int m_detect;
bit [0:65] tmp0;
bit  flag,corrupt_cnt;
bit [0:8] temp;
bit [3:0] cs_field_count;
bit cmd_check;
bit [3:0] cmd_cnt;
function new (string name = "srio_pl_idle2_cs_field_aet_ack_nack_corrupt_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_idle2_cs_field_aet_ack_nack_corrupt_callback"; 


virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_char_transmitted_lane0(ref bit [0:65] idle_field_char,srio_env_config env_config);
     if(flag == 0 ) begin //{
       tmp0= idle_field_char;
       temp = tmp0[57:65];
       if(temp == 9'h13C)   begin //{
         m_detect++;
         end //}
       if((m_detect) &&!(temp == 9'h13C)) begin //{
         m_detect = 0;
         end //}
        if(m_detect == 4) begin //{
          corrupt_cnt =1;
          end //}
        if((corrupt_cnt == 1) && ((temp == 9'h067)||(temp == 9'h078)||(temp == 9'h07e)||(temp == 9'h0f8))) begin //{
        
         if((cs_field_count == 16))
         begin // {
         idle_field_char = 9'h0f8;

         end //}
         else 
         begin //{
         idle_field_char = idle_field_char;
         end //}
         if(cs_field_count == 16)
         begin // {     
         flag =  1;  
         corrupt_cnt = 0;
         cs_field_count = 0;
         cmd_check = 0;
         end //}
         else
          begin //{
          cs_field_count++;     
          end //}  
         end //}
   end //}
  
endtask
endclass

// GEN3 -- CORRUPTION IN SKIP ORDER SEQUENCE FOLLOWED BY LANE CHECK
class srio_pl_gen3_incorrect_skip_order_lc_flwby_sc_seq_callback extends srio_pl_callback; 
bit [0:66] brc3_cg_temp;

bit  flag0;
bit sc_set0,sc_set1;
bit [3:0] cg_cnt;

static string type_name = "srio_pl_gen3_incorrect_skip_order_lc_flwby_sc_seq_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 
function new (string name = "srio_pl_gen3_incorrect_skip_order_lc_flwby_sc_seq_callback"); 
super.new(name); 
endfunction 
virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;

     if(flag0 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001100)||(brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110011))) begin //{ 
     sc_set0 = 1;
     end //}
     else if (sc_set0 && (~brc3_cg_temp[0] &&  brc3_cg_temp[33:38] != 6'b001110))
         sc_set0 = 0;
     else if(sc_set0)
        begin //{
          if(~brc3_cg_temp[0] &&  brc3_cg_temp[33:38] == 6'b001110)
             cg_cnt ++;
          else if(cg_cnt == 2 || cg_cnt == 3)
             sc_set1 = 1;
        end //}         
      end //}
      if(sc_set1) begin //{ 
     tx_srio_cg.brc3_cg[33:38] = 6'b001101;    
     flag0 =  1;    
     sc_set0 = 0;
     sc_set1 = 0; 
     end //}
endtask

endclass

// GEN3 -- CORRUPTION IN SKIP MARKER FIRST VALUE IS CORRUPTED.
class srio_pl_gen3_incorrect_skip_marker_first_part_seq_callback extends srio_pl_callback; 

bit [0:66] brc3_cg_temp;
bit  flag0;


static string type_name = "srio_pl_gen3_incorrect_skip_marker_first_part_seq_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 
function new (string name = "srio_pl_gen3_incorrect_skip_marker_first_part_seq_callback"); 
super.new(name); 
endfunction 
virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;

     if(flag0 == 0) begin //{   
     if(~brc3_cg_temp[2] && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001011)||(brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110100))) begin //{
       tx_srio_cg.brc3_cg[0:29] = 0; 
       //flag0 = 1;
     end //}
     end
endtask

endclass

//IDLE 2 CORRUPTION -- Truncation of MMMM sequence

class srio_pl_idle2_truncation_mmmm_sequence_corrupt_callback extends srio_pl_callback;
int m_detect;
bit [0:65] tmp0;
bit [1:0] flag = 1;
bit corrupt_cnt;
bit [0:8] temp;
bit [3:0] cs_field_count;
bit cmd_check;
bit [3:0] cmd_cnt;
function new (string name = "srio_pl_idle2_truncation_mmmm_sequence_corrupt_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_idle2_truncation_mmmm_sequence_corrupt_callback"; 


virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_char_transmitted_lane0(ref bit [0:65] idle_field_char,srio_env_config env_config);
//if ((env_config.pl_rx_mon_init_sm_state == NX_MODE) && (env_config.pl_tx_mon_init_sm_state == NX_MODE))  begin //{
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
     if(flag != 0 ) begin //{
       tmp0= idle_field_char;
       temp = tmp0[57:65];
       if(temp == 9'h13C)   begin //{
         m_detect++;
         end //}
       if((m_detect) &&!(temp == 9'h13C)) begin //{
         m_detect = 0;
         end //}
       if(m_detect == 4) begin //{
          idle_field_char = 9'h1bc;
          corrupt_cnt =1;
          flag = flag+1;
         end //}

   end //}
 end //} 
endtask
endclass

//IDLE 2 CORRUPTION -- KR check

class srio_pl_idle2_KR_sequence_corrupt_callback extends srio_pl_callback;
int m_detect;
bit [0:65] tmp0;
bit [1:0] flag = 0;
bit [0:8] temp;
bit k_detect;
function new (string name = "srio_pl_idle2_KR_sequence_corrupt_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_idle2_KR_sequence_corrupt_callback"; 


virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_char_transmitted_lane0(ref bit [0:65] idle_field_char,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
     if(flag == 0 ) begin //{
       tmp0= idle_field_char;
       temp = tmp0[57:65];
       if(temp == 9'h1BC)   begin //{
         k_detect = 1;
         end //}
       if((m_detect) &&!(temp == 9'h1FD)) begin //{
         k_detect = 0;
         end //}
       if(k_detect) begin //{
          idle_field_char = 9'h13c;
          flag = 1;
         end //}

   end //}
 end //} 
endtask
endclass

//IDLE 2 CORRUPTION -- Incomplete SYNC Sequence MDDDD

class srio_pl_idle2_MDDDD_sync_sequence_corrupt_callback extends srio_pl_callback;
bit [0:65] tmp0;
bit [1:0] flag = 0;
bit [0:8] temp;
bit m_detect;
bit [3:0] d_detect_cnt;
function new (string name = "srio_pl_idle2_MDDDD_sync_sequence_corrupt_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_idle2_MDDDD_sync_sequence_corrupt_callback"; 


virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_char_transmitted_lane0(ref bit [0:65] idle_field_char,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
     if(flag == 0 ) begin //{
       tmp0= idle_field_char;
       temp = tmp0[57:65];
       if(temp == 9'h13C)   begin //{
         m_detect = 1;
         end //}
       else if((m_detect) &&!(temp == 9'h000)) begin //{
         m_detect = 0;
         d_detect_cnt = 0;
         end //}
       else if((m_detect) && (temp == 9'h000)) begin //{
          d_detect_cnt = d_detect_cnt+1;
          end //}
       if((d_detect_cnt == 3) && (temp == 9'h000)) begin //{
          idle_field_char = 9'h13c;
          d_detect_cnt = 0;
          flag = 1;
         end //}
   end //}
 end //} 
endtask
endclass

//IDLE 2 CORRUPTION -- Invalid SYNC Sequence MDDDD

class srio_pl_idle2_invalid_MDDDD_sync_seq_corrupt_callback extends srio_pl_callback;
bit [0:65] tmp0;
bit [1:0] flag = 0;
bit [0:8] temp;
bit m_detect;
bit [3:0] d_detect_cnt;
bit [1:0] mdddd_cnt;
function new (string name = "srio_pl_idle2_invalid_MDDDD_sync_seq_corrupt_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_idle2_invalid_MDDDD_sync_seq_corrupt_callback"; 


virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_char_transmitted_lane0(ref bit [0:65] idle_field_char,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
     if(flag == 0 ) begin //{
       tmp0= idle_field_char;
       temp = tmp0[57:65];
       if(mdddd_cnt == 2)   begin //{
       if(temp == 9'h13C)   begin //{
         m_detect = 1;
         end //}
       else if((m_detect) &&!(temp == 9'h000)) begin //{
         m_detect = 0;
         d_detect_cnt = 0;
         end //}
       else if((m_detect) && (temp == 9'h000)) begin //{
          d_detect_cnt = d_detect_cnt+1;
          end //}
       if((d_detect_cnt == 3) && (temp == 9'h000)) begin //{
          idle_field_char = 9'h13c;
          d_detect_cnt = 0;
          flag = 1;
         end //}
      end // }

       else if((temp == 9'h13C) && !(m_detect))   begin //{
         idle_field_char = 9'h13c;
         m_detect = 1;
         end //}
       else if((m_detect) &&(temp != 9'h000)) begin //{
         m_detect = 0;
         d_detect_cnt = 0;
         end //}
       else if((m_detect) && (temp == 9'h000) && (d_detect_cnt < 5)) begin //{
         d_detect_cnt++;
         end //}
       if((d_detect_cnt == 4)&& (m_detect == 1)) begin //{
          mdddd_cnt = mdddd_cnt+1;
          d_detect_cnt = 0;
          m_detect = 0;
         end //}

   end //}
 end //} 
endtask
endclass

//================================================================================ 
//== callback to corrupt Timestamp contral symbol sequence 
//================================================================================ 

class srio_pl_timestamp_seq_err_cb extends srio_pl_callback;
bit [0:66] brc3_cg_temp; 
function new (string name = "srio_pl_timestamp_seq_err_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_timestamp_seq_err_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
   if(env_config.srio_mode == SRIO_GEN30) begin //{
      brc3_cg_temp = tx_srio_cg.brc3_cg;
         if(((brc3_cg_temp[0] == 0 ) && ((brc3_cg_temp[33:34] == 2'b11)) ||((brc3_cg_temp[0] == 1 ) && ((brc3_cg_temp[33:34] == 2'b00)) )))
           begin //{
             if((brc3_cg_temp[35:38] == 4'b0011) && (brc3_cg_temp[42:43] == 2'b00))
               begin //{
                 tx_srio_cg.brc3_cg[42:43] = 2'b11;
                end //}
 
           end //}
      end //} 
end //}
endtask 

endclass : srio_pl_timestamp_seq_err_cb

//IDLE 2 CORRUPTION --idle2 with control status signal 

class srio_pl_idle2_control_status_cs_corrupt_callback extends srio_pl_callback;
int m_detect_cnt0,m_detect_cnt1,m_detect_cnt2,m_detect_cnt3;
bit [0:65] tmp0,tmp1,tmp2,tmp3;
bit [1:0] flag = 1;
bit corrupt_cnt;
bit b5_cnt0,b5_cnt1,b5_cnt2,b5_cnt3;
bit [0:8] temp0,temp1,temp2,temp3;
bit [3:0] cs_field_count;
bit b5_detect0,b5_detect1,b5_detect2,b5_detect3;
bit m_detect0,m_detect1,m_detect2,m_detect3;
bit [5:0] cg_cnt0,cg_cnt1,cg_cnt2,cg_cnt3;

function new (string name = "srio_pl_idle2_control_status_cs_corrupt_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_idle2_control_status_cs_corrupt_callback"; 


virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_char_transmitted_lane0(ref bit [0:65] idle_field_char,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
     if(flag != 0 ) begin //{
       tmp0= idle_field_char;
       temp0 = tmp0[57:65];
       if((m_detect0==0) && (temp0 == 9'h13C))   begin //{
         m_detect_cnt0++;
         end //}
       if((m_detect0 == 0)&&(m_detect_cnt0) && (temp0 != 9'h13C)) begin //{
         m_detect0 = 0;
         m_detect_cnt0 = 0;
         end //}
       else if(m_detect_cnt0 == 4) begin //{
          m_detect0 =1;
          m_detect_cnt0 = 0;
         end //}
          if((temp0 == 9'h0b5) && (m_detect0 == 1) && (b5_cnt0 == 0))
          begin //{
             b5_detect0 = 1;
             b5_cnt0++;
           end //}
     else  if((m_detect0) && (b5_detect0))  begin //{

       if((b5_detect0) && (m_detect0)) begin //{
          cg_cnt0 = cg_cnt0+1;
          if(cg_cnt0 == 35) begin //{
            b5_detect0 = 0;
            m_detect0 = 0;
           end //}
          else if((cg_cnt0==1)||(cg_cnt0==13)||(cg_cnt0==26)) begin //{
            idle_field_char = 9'h11c;
          end //}
          else if((cg_cnt0==2)||(cg_cnt0==14)||(cg_cnt0==27)) begin //{
            idle_field_char = 9'h000;
          end //}
          else
           begin //{
           idle_field_char = 9'h000;
           end //}
        end //}
    end //} 
 end //}
 end //}
        
endtask

 virtual task srio_pl_char_transmitted_lane1(ref bit [0:65] idle_field_char,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
     if(flag != 0 ) begin //{
       tmp1= idle_field_char;
       temp1 = tmp1[57:65];
       if((m_detect1==0) && (temp1 == 9'h13C))   begin //{
         m_detect_cnt1++;
         end //}
       if((m_detect1 == 0)&&(m_detect_cnt1) && (temp1 != 9'h13C)) begin //{
         m_detect1 = 0;
         m_detect_cnt1 = 0;
         end //}
       else if(m_detect_cnt1 == 4) begin //{
          m_detect1 =1;
          m_detect_cnt1 = 0;
         end //}

          if((temp1 == 9'h0b5) && (m_detect1 == 1) && (b5_cnt1 == 0))
          begin //{
             b5_detect1 = 1;
             b5_cnt1++;
           end //}

     else  if((m_detect1) && (b5_detect1))  begin //{

       if((b5_detect1) && (m_detect1)) begin //{
          cg_cnt1 = cg_cnt1+1;
          if(cg_cnt1 == 35) begin //{
            b5_detect1 = 0;
            m_detect1 = 0;
           end //}
          else if((cg_cnt1==1)||(cg_cnt1==13)||(cg_cnt1==26)) begin //{
            idle_field_char = 9'h080;
          end //}
          else if((cg_cnt1==2)||(cg_cnt1==14)||(cg_cnt1==27)) begin //{
            idle_field_char = 9'h00a;
          end //}
          else
           begin //{
           idle_field_char = 9'h000;
           end //}
        end //}
    end //} 
 end //}
 end //}
        
endtask

 virtual task srio_pl_char_transmitted_lane2(ref bit [0:65] idle_field_char,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
     if(flag != 0 ) begin //{
       tmp2= idle_field_char;
       temp2 = tmp2[57:65];
       if((m_detect2==0) && (temp2 == 9'h13C))   begin //{
         m_detect_cnt2++;
         end //}
       if((m_detect2 == 0)&&(m_detect_cnt2) && (temp2 != 9'h13C)) begin //{
         m_detect2 = 0;
         m_detect_cnt2 = 0;
         end //}
       else if(m_detect_cnt2 == 4) begin //{
          m_detect2 =1;
          m_detect_cnt2 = 0;
         end //}

          if((temp2 == 9'h0b5) && (m_detect2 == 1) && (b5_cnt2 == 0))
          begin //{
             b5_detect2 = 1;
             b5_cnt2++;
           end //}

      else  if((m_detect2) && (b5_detect2))  begin //{

       if((b5_detect2) && (m_detect2)) begin //{
          cg_cnt2 = cg_cnt2+1;
          if(cg_cnt2 == 35) begin //{
            b5_detect2 = 0;
            m_detect2 = 0;
           end //}
          else if((cg_cnt2==1)||(cg_cnt2==13)||(cg_cnt2==26)) begin //{
            idle_field_char = 9'h07f;
          end //}
          else if((cg_cnt2==2)||(cg_cnt2==14)||(cg_cnt2==27)) begin //{
            idle_field_char = 9'h035;
          end //}
          else
           begin //{
           idle_field_char = 9'h000;
           end //}
        end //}
    end //} 
 end //}
 end //}
        
endtask

 virtual task srio_pl_char_transmitted_lane3(ref bit [0:65] idle_field_char,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
     if(flag != 0 ) begin //{
       tmp3= idle_field_char;
       temp3 = tmp3[57:65];
       if((m_detect3==0) && (temp3 == 9'h13C))   begin //{
         m_detect_cnt3++;
         end //}
       if((m_detect3 == 0)&&(m_detect_cnt3) && (temp3 != 9'h13C)) begin //{
         m_detect3 = 0;
         m_detect_cnt3 = 0;
         end //}
       else if(m_detect_cnt3 == 4) begin //{
          m_detect3 =1;
          m_detect_cnt3 = 0;
         end //}

          if((temp3 == 9'h0b5) && (m_detect3 == 1) && (b5_cnt3 == 0))
          begin //{
             b5_detect3 = 1;
             b5_cnt3++;
           end //}

      else  if((m_detect3) && (b5_detect3))  begin //{

       if((b5_detect3) && (m_detect3)) begin //{
          cg_cnt3 = cg_cnt3+1;
          if(cg_cnt3 == 35) begin //{
            b5_detect3 = 0;
            m_detect3 = 0;
           end //}
          else if((cg_cnt3==1)||(cg_cnt3==13)||(cg_cnt3==26)) begin //{
            idle_field_char = 9'h0c0;
          end //}
          else if((cg_cnt3==2)||(cg_cnt3==14)||(cg_cnt3==27)) begin //{
            idle_field_char = 9'h11c;
          end //}
          else
           begin //{
           idle_field_char = 9'h000;
           end //}
        end //}
    end //} 
 end //}
 end //}
       
endtask
endclass

class srio_pl_gen3_incorrect_spacing_cw_bw_sc_cw_seq_callback extends srio_pl_callback; 
bit [0:66] brc3_cg_temp;
bit [1:0] sc_cw_cnt,cw_corrupt_cnt;
rand bit [3:0] rand_cw_cnt; 
bit [3:0] cw_cnt;
bit flag0;
static string type_name = "srio_pl_gen3_incorrect_spacing_cw_bw_sc_cw_seq_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction
 
virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp = tx_srio_cg.brc3_cg;
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
     if(flag0 == 0) begin //{ 
       rand_cw_cnt = $urandom_range(15,3);
     if (sc_cw_cnt == 2) begin //{
        if(cw_cnt != rand_cw_cnt )  begin //{
            cw_cnt = cw_cnt+1;
          end //}
        else if(cw_cnt == rand_cw_cnt) begin //{
            if(cw_corrupt_cnt == 0) begin //{
               tx_srio_cg.brc3_cg[33:38] = 6'b001111;
               tx_srio_cg.brc3_cg[0:32] = 0;
               tx_srio_cg.brc3_cg[39:66] = 0;
               cw_corrupt_cnt = cw_corrupt_cnt+1;
             end //}
             else if(cw_corrupt_cnt == 1) begin //{
               tx_srio_cg.brc3_cg[33:38] = 6'b001111;
               tx_srio_cg.brc3_cg[0:32] = 0;
               tx_srio_cg.brc3_cg[39:66] = 0;
               cw_corrupt_cnt = 0;
               sc_cw_cnt = 0;
               flag0 = 1;
             end //}
          end //}
        end //}

     else if((~brc3_cg_temp[2] && (sc_cw_cnt == 0) && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001111) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110000)))) begin //{ 
     sc_cw_cnt = 1;
     end //}
       
     else if(~brc3_cg_temp[2] && (sc_cw_cnt == 1) && ((~brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b001111) || (brc3_cg_temp[0] && brc3_cg_temp[33:38] == 6'b110000))) begin //{ 
     sc_cw_cnt = 2;
     end //}
    end //}
  end //}
endtask

endclass

/*************** CS corruption for standalone setup ************/
class srio_pl_standalone_cs_corrupt_cb extends srio_pl_callback;
int m_detect;
bit [0:65] tmp0;
bit  flag,corrupt_cnt;
bit [0:8] temp;
bit [1:0] cnt;
bit delay_flag,cs_flag;
function new (string name = "srio_pl_standalone_cs_corrupt_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_standalone_cs_corrupt_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_char_transmitted_lane0(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{
  if((flag == 0) && (delay_flag == 1)) begin //{
  tmp0= idle_field_char;
  temp = tmp0[57:65];
 
      if(temp == 9'h11C)   begin //{
        cs_flag = 1;
      end //}
     end //}
   end //}

   endtask
 virtual task srio_pl_char_transmitted_lane2(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{
  if((flag == 0) && (delay_flag == 1) && (cs_flag == 1) && cnt == 0) begin //{
     cnt = cnt+1;
      end //}
   else if(cnt == 1 && flag == 0)
       begin
         idle_field_char = 9'h000; 
         flag = 1;
       end

     end //}

   endtask

endclass

/************************ IDLE2 corruption for standalone setup ************/
class srio_pl_standalone_idle2_corrupt_cb extends srio_pl_callback;
bit [0:65] tmp0,tmp1,tmp2,tmp3;
bit [1:0] flag0 = 0;
bit [1:0] flag1 = 0;
bit [1:0] flag2 = 0;
bit [1:0] flag3 = 0;
bit [0:8] temp0,temp1,temp2,temp3;
bit m_detect0,m_detect1,m_detect2,m_detect3;
bit [3:0] d_detect_cnt0,d_detect_cnt1,d_detect_cnt2,d_detect_cnt3;
bit delay_flag;
function new (string name = "srio_pl_standalone_idle2_corrupt_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_standalone_idle2_corrupt_cb"; 


virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_char_transmitted_lane0(ref bit [0:65] idle_field_char,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
     if(flag0 == 0 && delay_flag == 1) begin //{
       tmp0= idle_field_char;
       temp0 = tmp0[57:65];
       if(temp0 == 9'h000)   begin //{
          idle_field_char = 9'h03e;
          flag0 = 1;
         end //}
   end //}
 end //} 
endtask

 virtual task srio_pl_char_transmitted_lane1(ref bit [0:65] idle_field_char,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
     if(flag1 == 0 && delay_flag == 1) begin //{
       tmp1= idle_field_char;
       temp1 = tmp1[57:65];
       if(temp1 == 9'h000)   begin //{
          idle_field_char = 9'h03e;
          flag1 = 1;
         end //}
   end //}
 end //} 
endtask

 virtual task srio_pl_char_transmitted_lane2(ref bit [0:65] idle_field_char,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
     if(flag2 == 0 && delay_flag == 1) begin //{
       tmp2= idle_field_char;
       temp2 = tmp2[57:65];
       if(temp2 == 9'h000)   begin //{
          idle_field_char = 9'h03e;
          flag2 = 1;
         end //}
   end //}
 end //} 
endtask

 virtual task srio_pl_char_transmitted_lane3(ref bit [0:65] idle_field_char,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
     if(flag3 == 0 && delay_flag == 1) begin //{
       tmp3= idle_field_char;
       temp3 = tmp3[57:65];
       if(temp3 == 9'h000)   begin //{
          idle_field_char = 9'h03e;
          flag3 = 1;
         end //}
   end //}
 end //} 
endtask

endclass

//========== Gobal variable for callback ================
class srio_static_variable_class extends srio_pl_callback;
static bit delay_flag;
endclass


/************** Insert Packet corruption for standalone setup ************/
class srio_pl_standalone_pkt_corrupt_cb extends srio_pl_callback;
int m_detect;
bit [0:65] tmp0;
bit  flag0,corrupt_cnt;
bit [0:8] temp;
bit [3:0] cnt0,cnt1,cnt2,cnt3;
bit cs_flag0;
srio_static_variable_class static_variable_ins;

function new (string name = "srio_pl_standalone_pkt_corrupt_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_standalone_pkt_corrupt_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction

 virtual task srio_pl_char_transmitted_lane0(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{
  if((flag0 == 0) && (static_variable_ins.delay_flag == 1)) begin //{
  tmp0= idle_field_char;
  temp = tmp0[57:65];
 
      if(temp == 9'h17C)   begin //{
        cnt0 = cnt0+1;
      end //}

      else if(cnt0 == 2)  begin //{
        idle_field_char = 9'h17C;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
      else if(cnt0 == 3)  begin //{
        idle_field_char = 9'h000;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
          
      else if(cnt0 == 4)  begin //{
        idle_field_char = 9'h015;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
       else if(cnt0 == 5) begin //{
        idle_field_char = 9'h000;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
       else if(cnt0 == 6) begin //{
        idle_field_char = 9'h034;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
       else if(cnt0 == 7) begin //{
        idle_field_char = 9'h17C;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end 
       else if(cnt0 == 8) begin //{
        idle_field_char = 9'h000;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
       else if(cnt0 == 9) begin //{
        idle_field_char = 9'h000;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
       else if(cnt0 == 10) begin //
        idle_field_char = 9'h000;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
      else if(cnt0 == 11) begin //{
        flag0 = 1;
        static_variable_ins.delay_flag = 0;
      end //}
      else begin //{
        if(cnt0 == 1) begin //{
          cs_flag0 = 0;
          cnt0 = cnt0+1;
         end //}
         else
            cs_flag0 = 0;
        end //} 
     end //}
   end //}

   endtask
 virtual task srio_pl_char_transmitted_lane1(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{
  if((flag0 == 0) && (static_variable_ins.delay_flag == 1) && (cs_flag0 == 1)) begin //{

      if(cnt1 == 0)  begin //{
        idle_field_char = 9'h00b;
        cnt1 = cnt1+1;
       end //} 
       else if(cnt1 == 1)  begin //{
        idle_field_char = 9'h002;
        cnt1 = cnt1+1;
       end //} 

       else if(cnt1 == 2)  begin //{
        idle_field_char = 9'h00a;
        cnt1 = cnt1+1;
       end //} 
       else if(cnt1 == 3) begin //{
        idle_field_char = 9'h05;
        cnt1 = cnt1+1;
       end //}
       else if(cnt1 == 4) begin //{
        idle_field_char = 9'h039;
        cnt1 = cnt1+1;
       end //}
       else if(cnt1 == 5) begin //{
        idle_field_char = 9'h00b;
        cnt1 = cnt1+1;
       end //}
       else if(cnt1 == 6) begin //{
        idle_field_char = 9'h003;
        cnt1 = cnt1+1;
       end //}
       else if(cnt1 == 7) begin //{
        idle_field_char = 9'h000;
        cnt1 = cnt1+1;
       end //}
       else if(cnt1 == 8) begin //{
        idle_field_char = 9'h000;
        cnt1 = cnt1+1;
       end //}

     end //}
   end //}
 endtask
 virtual task srio_pl_char_transmitted_lane2(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{
  if((flag0 == 0) && (static_variable_ins.delay_flag == 1) && cs_flag0 == 1) begin //{

      if(cnt2 == 0)  begin //{
        idle_field_char = 9'h07e;
        cnt2 = cnt2+1;
       end //} 
       else if(cnt2 == 1)  begin //{
        idle_field_char = 9'h77;
        cnt2 = cnt2+1;
       end //} 

       else if(cnt2 == 2)  begin //{
        idle_field_char = 9'h0b4;
        cnt2 = cnt2+1;
       end //} 
       else if(cnt2 == 3) begin //{
        idle_field_char = 9'h0f6;
        cnt2 = cnt2+1;
       end //}
       else if(cnt2 == 4) begin //{
        idle_field_char = 9'h000;
        cnt2 = cnt2+1;
       end //}
       else if(cnt2 == 5) begin //{
        idle_field_char = 9'h0fe;
        cnt2 = cnt2+1;
       end //}
       else if(cnt2 == 6) begin //{
        idle_field_char = 9'h076;
        cnt2 = cnt2+1;
       end //}
      else if(cnt2 == 7) begin //{
        idle_field_char = 9'h000;
        cnt2 = cnt2+1;
       end //}
       else if(cnt2 == 8) begin //{
        idle_field_char = 9'h000;
        cnt2 = cnt2+1;
       end //}

    end //}
   end //}
 endtask

 virtual task srio_pl_char_transmitted_lane3(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{
  if((flag0 == 0) && (static_variable_ins.delay_flag == 1) && cs_flag0 == 1) begin //{
      if(cnt3 == 0)  begin //{
        idle_field_char = 9'h000;
        cnt3 = cnt3+1;
       end //} 
       else if(cnt3 == 1)  begin //{
        idle_field_char = 9'h17C;
        cnt3 = cnt3+1;
       end //} 

       else if(cnt3 == 2)  begin //{
        idle_field_char = 9'h0a2;
        cnt3 = cnt3+1;
       end //} 
       else if(cnt3 == 3) begin //{
        idle_field_char = 9'h007;
        cnt3 = cnt3+1;
       end //}
       else if(cnt3 == 4) begin //{
        idle_field_char = 9'h000;
        cnt3 = cnt3+1;
       end //}
       else if(cnt3 == 5) begin //{
        idle_field_char = 9'h080;
        cnt3 = cnt3+1;
       end //}
       else if(cnt3 == 6) begin //{
        idle_field_char = 9'h17C;
        cnt3 = cnt3+1;
       end //}
      else if(cnt3 == 7) begin //{
        idle_field_char = 9'h000;
        cnt3 = cnt3+1;
       end //}
       else if(cnt3 == 8) begin //{
        idle_field_char = 9'h000;
        cnt3 = cnt3+1;
       end //}

     end //}
   end //}

   endtask
endclass

//=========== callback to detect recieved CS =========
class srio_pl_rcvd_trans_cb extends srio_pl_callback;
//bit delay_flag;
srio_static_variable_class static_variable_ins;
bit [1:0] retry_cnt;
function new (string name = "srio_pl_rcvd_trans_cb"); 
super.new(name); 
endfunction 

virtual task srio_pl_trans_received(ref srio_trans rx_srio_trans);

if(rx_srio_trans.transaction_kind==SRIO_PACKET)
begin
 rx_srio_trans.print();
end
if(rx_srio_trans.transaction_kind==SRIO_CS)
 begin
   if((rx_srio_trans.stype0 == 4'h1) && (retry_cnt < 1) )
      begin 
         static_variable_ins.delay_flag =1;
         retry_cnt = retry_cnt+1;
      end
     
end
endtask
endclass
/*************** Packet CRC corruption for standalone setup ************/
class srio_pl_standalone_pkt_crc_corrupt_cb extends srio_pl_callback;
int m_detect;
bit [0:65] tmp0;
bit  flag0,corrupt_cnt;
bit [0:8] temp;
bit [3:0] cnt0,cnt1,cnt2,cnt3;
bit cs_flag0;
srio_static_variable_class static_variable_ins;
function new (string name = "srio_pl_standalone_pkt_crc_corrupt_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_standalone_pkt_crc_corrupt_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_char_transmitted_lane0(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{
  if((flag0 == 0) && (static_variable_ins.delay_flag == 1)) begin //{
  tmp0= idle_field_char;
  temp = tmp0[57:65];
 
      if(temp == 9'h17C)   begin //{
        cnt0 = cnt0+1;
      end //}

      else if(cnt0 == 2)  begin //{
        idle_field_char = 9'h17C;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
      else if(cnt0 == 3)  begin //{
        idle_field_char = 9'h000;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
          
      else if(cnt0 == 4)  begin //{
        idle_field_char = 9'h015;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
       else if(cnt0 == 5) begin //{
        idle_field_char = 9'h000;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
       else if(cnt0 == 6) begin //{
        idle_field_char = 9'h000; //Packet CRC corruption 
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
       else if(cnt0 == 7) begin //{
        idle_field_char = 9'h17C;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end 
       else if(cnt0 == 8) begin //{
        idle_field_char = 9'h000;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
       else if(cnt0 == 9) begin //{
        idle_field_char = 9'h000;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
       else if(cnt0 == 10) begin //
        idle_field_char = 9'h000;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
      else if(cnt0 == 11) begin //{
        flag0 = 1;
        static_variable_ins.delay_flag = 0;
      end //}
      else begin //{
        if(cnt0 == 1) begin //{
          cs_flag0 = 0;
          cnt0 = cnt0+1;
         end //}
         else
            cs_flag0 = 0;
        end //} 
     end //}
   end //}

   endtask
 virtual task srio_pl_char_transmitted_lane1(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{
  if((flag0 == 0) && (static_variable_ins.delay_flag == 1) && (cs_flag0 == 1)) begin //{

      if(cnt1 == 0)  begin //{
        idle_field_char = 9'h00b;
        cnt1 = cnt1+1;
       end //} 
       else if(cnt1 == 1)  begin //{
        idle_field_char = 9'h002;
        cnt1 = cnt1+1;
       end //} 

       else if(cnt1 == 2)  begin //{
        idle_field_char = 9'h00a;
        cnt1 = cnt1+1;
       end //} 
       else if(cnt1 == 3) begin //{
        idle_field_char = 9'h05;
        cnt1 = cnt1+1;
       end //}
       else if(cnt1 == 4) begin //{
        idle_field_char = 9'h000;  // Packet CRC corruption 
        cnt1 = cnt1+1;
       end //}
       else if(cnt1 == 5) begin //{
        idle_field_char = 9'h00b;
        cnt1 = cnt1+1;
       end //}
       else if(cnt1 == 6) begin //{
        idle_field_char = 9'h003;
        cnt1 = cnt1+1;
       end //}
       else if(cnt1 == 7) begin //{
        idle_field_char = 9'h000;
        cnt1 = cnt1+1;
       end //}
       else if(cnt1 == 8) begin //{
        idle_field_char = 9'h000;
        cnt1 = cnt1+1;
       end //}

     end //}
   end //}
 endtask
 virtual task srio_pl_char_transmitted_lane2(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{
  if((flag0 == 0) && (static_variable_ins.delay_flag == 1) && cs_flag0 == 1) begin //{

      if(cnt2 == 0)  begin //{
        idle_field_char = 9'h07e;
        cnt2 = cnt2+1;
       end //} 
       else if(cnt2 == 1)  begin //{
        idle_field_char = 9'h77;
        cnt2 = cnt2+1;
       end //} 

       else if(cnt2 == 2)  begin //{
        idle_field_char = 9'h0b4;
        cnt2 = cnt2+1;
       end //} 
       else if(cnt2 == 3) begin //{
        idle_field_char = 9'h0f6;
        cnt2 = cnt2+1;
       end //}
       else if(cnt2 == 4) begin //{
        idle_field_char = 9'h000;
        cnt2 = cnt2+1;
       end //}
       else if(cnt2 == 5) begin //{
        idle_field_char = 9'h0fe;
        cnt2 = cnt2+1;
       end //}
       else if(cnt2 == 6) begin //{
        idle_field_char = 9'h076;
        cnt2 = cnt2+1;
       end //}
      else if(cnt2 == 7) begin //{
        idle_field_char = 9'h000;
        cnt2 = cnt2+1;
       end //}
       else if(cnt2 == 8) begin //{
        idle_field_char = 9'h000;
        cnt2 = cnt2+1;
       end //}

    end //}
   end //}
 endtask


 virtual task srio_pl_char_transmitted_lane3(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{
  if((flag0 == 0) && (static_variable_ins.delay_flag == 1) && cs_flag0 == 1) begin //{
      if(cnt3 == 0)  begin //{
        idle_field_char = 9'h000;
        cnt3 = cnt3+1;
       end //} 
       else if(cnt3 == 1)  begin //{
        idle_field_char = 9'h17C;
        cnt3 = cnt3+1;
       end //} 

       else if(cnt3 == 2)  begin //{
        idle_field_char = 9'h0a2;
        cnt3 = cnt3+1;
       end //} 
       else if(cnt3 == 3) begin //{
        idle_field_char = 9'h007;
        cnt3 = cnt3+1;
       end //}
       else if(cnt3 == 4) begin //{
        idle_field_char = 9'h000;
        cnt3 = cnt3+1;
       end //}
       else if(cnt3 == 5) begin //{
        idle_field_char = 9'h080;
        cnt3 = cnt3+1;
       end //}
       else if(cnt3 == 6) begin //{
        idle_field_char = 9'h17C;
        cnt3 = cnt3+1;
       end //}
      else if(cnt3 == 7) begin //{
        idle_field_char = 9'h000;
        cnt3 = cnt3+1;
       end //}
       else if(cnt3 == 8) begin //{
        idle_field_char = 9'h000;
        cnt3 = cnt3+1;
       end //}

     end //}
   end //}

   endtask

endclass

//************* check callback******************

class srio_pl_check_cb extends srio_pl_callback; 

srio_pl_agent pl_agent_cb ;

function new (string name = "srio_pl_check_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_check_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction

virtual task srio_pl_trans_received (ref srio_trans rx_srio_trans);
 rx_srio_trans.print();
 
endtask


endclass

/***************Insert Packet AckID corruption for standalone setup ************/

class srio_pl_standalone_pkt_ackid_corrupt_cb extends srio_pl_callback;
int m_detect;
bit [0:65] tmp0;
bit  flag0,corrupt_cnt;
bit [0:8] temp;
bit [3:0] cnt0,cnt1,cnt2,cnt3;
bit cs_flag0;
srio_static_variable_class static_variable_ins;

function new (string name = "srio_pl_standalone_pkt_ackid_corrupt_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_standalone_pkt_ackid_corrupt_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction

 virtual task srio_pl_char_transmitted_lane0(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{
  if((flag0 == 0) && (static_variable_ins.delay_flag == 1)) begin //{
  tmp0= idle_field_char;
  temp = tmp0[57:65];
 
      if(temp == 9'h17C)   begin //{
        cnt0 = cnt0+1;
      end //}

      else if(cnt0 == 2)  begin //{
        idle_field_char = 9'h17C;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
      else if(cnt0 == 3)  begin //{
        idle_field_char = 9'h000;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
          
      else if(cnt0 == 4)  begin //{
        idle_field_char = 9'h019; //corruted ackid to 6
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
       else if(cnt0 == 5) begin //{
        idle_field_char = 9'h000;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
       else if(cnt0 == 6) begin //{
        idle_field_char = 9'h074;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
       else if(cnt0 == 7) begin //{
        idle_field_char = 9'h17C;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end 
       else if(cnt0 == 8) begin //{
        idle_field_char = 9'h000;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
       else if(cnt0 == 9) begin //{
        idle_field_char = 9'h000;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
       else if(cnt0 == 10) begin //
        idle_field_char = 9'h000;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
      else if(cnt0 == 11) begin //{
        flag0 = 1;
        static_variable_ins.delay_flag = 0;
      end //}
      else begin //{
        if(cnt0 == 1) begin //{
          cs_flag0 = 0;
          cnt0 = cnt0+1;
         end //}
         else
            cs_flag0 = 0;
        end //} 
     end //}
   end //}

   endtask
 virtual task srio_pl_char_transmitted_lane1(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{
  if((flag0 == 0) && (static_variable_ins.delay_flag == 1) && (cs_flag0 == 1)) begin //{

      if(cnt1 == 0)  begin //{
        idle_field_char = 9'h00b;
        cnt1 = cnt1+1;
       end //} 
       else if(cnt1 == 1)  begin //{
        idle_field_char = 9'h002;
        cnt1 = cnt1+1;
       end //} 

       else if(cnt1 == 2)  begin //{
        idle_field_char = 9'h04a;
        cnt1 = cnt1+1;
       end //} 
       else if(cnt1 == 3) begin //{
        idle_field_char = 9'h006;
        cnt1 = cnt1+1;
       end //}
       else if(cnt1 == 4) begin //{
        idle_field_char = 9'h06c;
        cnt1 = cnt1+1;
       end //}
       else if(cnt1 == 5) begin //{
        idle_field_char = 9'h00b;
        cnt1 = cnt1+1;
       end //}
       else if(cnt1 == 6) begin //{
        idle_field_char = 9'h003;
        cnt1 = cnt1+1;
       end //}
       else if(cnt1 == 7) begin //{
        idle_field_char = 9'h000;
        cnt1 = cnt1+1;
       end //}
       else if(cnt1 == 8) begin //{
        idle_field_char = 9'h000;
        cnt1 = cnt1+1;
       end //}

     end //}
   end //}
 endtask
 virtual task srio_pl_char_transmitted_lane2(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{
  if((flag0 == 0) && (static_variable_ins.delay_flag == 1) && cs_flag0 == 1) begin //{

      if(cnt2 == 0)  begin //{
        idle_field_char = 9'h07e;
        cnt2 = cnt2+1;
       end //} 
       else if(cnt2 == 1)  begin //{
        idle_field_char = 9'h77;
        cnt2 = cnt2+1;
       end //} 

       else if(cnt2 == 2)  begin //{
        idle_field_char = 9'h063;
        cnt2 = cnt2+1;
       end //} 
       else if(cnt2 == 3) begin //{
        idle_field_char = 9'h056;
        cnt2 = cnt2+1;
       end //}
       else if(cnt2 == 4) begin //{
        idle_field_char = 9'h000;
        cnt2 = cnt2+1;
       end //}
       else if(cnt2 == 5) begin //{
        idle_field_char = 9'h0fe;
        cnt2 = cnt2+1;
       end //}
       else if(cnt2 == 6) begin //{
        idle_field_char = 9'h076;
        cnt2 = cnt2+1;
       end //}
      else if(cnt2 == 7) begin //{
        idle_field_char = 9'h000;
        cnt2 = cnt2+1;
       end //}
       else if(cnt2 == 8) begin //{
        idle_field_char = 9'h000;
        cnt2 = cnt2+1;
       end //}

    end //}
   end //}
 endtask


 virtual task srio_pl_char_transmitted_lane3(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{
  if((flag0 == 0) && (static_variable_ins.delay_flag == 1) && cs_flag0 == 1) begin //{
      if(cnt3 == 0)  begin //{
        idle_field_char = 9'h000;
        cnt3 = cnt3+1;
       end //} 
       else if(cnt3 == 1)  begin //{
        idle_field_char = 9'h17C;
        cnt3 = cnt3+1;
       end //} 

       else if(cnt3 == 2)  begin //{
        idle_field_char = 9'h051;
        cnt3 = cnt3+1;
       end //} 
       else if(cnt3 == 3) begin //{
        idle_field_char = 9'h023;
        cnt3 = cnt3+1;
       end //}
       else if(cnt3 == 4) begin //{
        idle_field_char = 9'h000;
        cnt3 = cnt3+1;
       end //}
       else if(cnt3 == 5) begin //{
        idle_field_char = 9'h080;
        cnt3 = cnt3+1;
       end //}
       else if(cnt3 == 6) begin //{
        idle_field_char = 9'h17C;
        cnt3 = cnt3+1;
       end //}
      else if(cnt3 == 7) begin //{
        idle_field_char = 9'h000;
        cnt3 = cnt3+1;
       end //}
       else if(cnt3 == 8) begin //{
        idle_field_char = 9'h000;
        cnt3 = cnt3+1;
       end //}

     end //}
   end //}

   endtask
endclass 

/************** Insert Packet corruption with SOP crc error for standalone setup ************/
class srio_pl_standalone_pkt_sop_crc_corrupt_cb extends srio_pl_callback;
int m_detect;
bit [0:65] tmp0;
bit  flag0,corrupt_cnt;
bit [0:8] temp;
bit [3:0] cnt0,cnt1,cnt2,cnt3;
bit cs_flag0;
srio_static_variable_class static_variable_ins;

function new (string name = "srio_pl_standalone_pkt_sop_crc_corrupt_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_standalone_pkt_sop_crc_corrupt_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction

 virtual task srio_pl_char_transmitted_lane0(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{
  if((flag0 == 0) && (static_variable_ins.delay_flag == 1)) begin //{
  tmp0= idle_field_char;
  temp = tmp0[57:65];
 
      if(temp == 9'h17C)   begin //{
        cnt0 = cnt0+1;
      end //}

      else if(cnt0 == 2)  begin //{
        idle_field_char = 9'h17C;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
      else if(cnt0 == 3)  begin //{
        idle_field_char = 9'h000;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
          
      else if(cnt0 == 4)  begin //{
        idle_field_char = 9'h015;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
       else if(cnt0 == 5) begin //{
        idle_field_char = 9'h000;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
       else if(cnt0 == 6) begin //{
        idle_field_char = 9'h034;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
       else if(cnt0 == 7) begin //{
        idle_field_char = 9'h17C;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end 
       else if(cnt0 == 8) begin //{
        idle_field_char = 9'h000;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
       else if(cnt0 == 9) begin //{
        idle_field_char = 9'h000;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
       else if(cnt0 == 10) begin //
        idle_field_char = 9'h000;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
      else if(cnt0 == 11) begin //{
        flag0 = 1;
        static_variable_ins.delay_flag = 0;
      end //}
      else begin //{
        if(cnt0 == 1) begin //{
          cs_flag0 = 0;
          cnt0 = cnt0+1;
         end //}
         else
            cs_flag0 = 0;
        end //} 
     end //}
   end //}

   endtask
 virtual task srio_pl_char_transmitted_lane1(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{
  if((flag0 == 0) && (static_variable_ins.delay_flag == 1) && (cs_flag0 == 1)) begin //{

      if(cnt1 == 0)  begin //{
        idle_field_char = 9'h00b;
        cnt1 = cnt1+1;
       end //} 
       else if(cnt1 == 1)  begin //{
        idle_field_char = 9'h000; //SOP crc corruption 
        cnt1 = cnt1+1;
       end //} 

       else if(cnt1 == 2)  begin //{
        idle_field_char = 9'h00a;
        cnt1 = cnt1+1;
       end //} 
       else if(cnt1 == 3) begin //{
        idle_field_char = 9'h005;
        cnt1 = cnt1+1;
       end //}
       else if(cnt1 == 4) begin //{
        idle_field_char = 9'h039;
        cnt1 = cnt1+1;
       end //}
       else if(cnt1 == 5) begin //{
        idle_field_char = 9'h00b;
        cnt1 = cnt1+1;
       end //}
       else if(cnt1 == 6) begin //{
        idle_field_char = 9'h003;
        cnt1 = cnt1+1;
       end //}
       else if(cnt1 == 7) begin //{
        idle_field_char = 9'h000;
        cnt1 = cnt1+1;
       end //}
       else if(cnt1 == 8) begin //{
        idle_field_char = 9'h000;
        cnt1 = cnt1+1;
       end //}

     end //}
   end //}
 endtask
 virtual task srio_pl_char_transmitted_lane2(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{
  if((flag0 == 0) && (static_variable_ins.delay_flag == 1) && cs_flag0 == 1) begin //{

      if(cnt2 == 0)  begin //{
        idle_field_char = 9'h07e;
        cnt2 = cnt2+1;
       end //} 
       else if(cnt2 == 1)  begin //{
        idle_field_char = 9'h000; //SOP crc corruption
        cnt2 = cnt2+1;
       end //} 

       else if(cnt2 == 2)  begin //{
        idle_field_char = 9'h0b4;
        cnt2 = cnt2+1;
       end //} 
       else if(cnt2 == 3) begin //{
        idle_field_char = 9'h0f6;
        cnt2 = cnt2+1;
       end //}
       else if(cnt2 == 4) begin //{
        idle_field_char = 9'h000;
        cnt2 = cnt2+1;
       end //}
       else if(cnt2 == 5) begin //{
        idle_field_char = 9'h0fe;
        cnt2 = cnt2+1;
       end //}
       else if(cnt2 == 6) begin //{
        idle_field_char = 9'h076;
        cnt2 = cnt2+1;
       end //}
      else if(cnt2 == 7) begin //{
        idle_field_char = 9'h000;
        cnt2 = cnt2+1;
       end //}
       else if(cnt2 == 8) begin //{
        idle_field_char = 9'h000;
        cnt2 = cnt2+1;
       end //}

    end //}
   end //}
 endtask


 virtual task srio_pl_char_transmitted_lane3(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{
  if((flag0 == 0) && (static_variable_ins.delay_flag == 1) && cs_flag0 == 1) begin //{
      if(cnt3 == 0)  begin //{
        idle_field_char = 9'h000;
        cnt3 = cnt3+1;
       end //} 
       else if(cnt3 == 1)  begin //{
        idle_field_char = 9'h17C;
        cnt3 = cnt3+1;
       end //} 

       else if(cnt3 == 2)  begin //{
        idle_field_char = 9'h0a2;
        cnt3 = cnt3+1;
       end //} 
       else if(cnt3 == 3) begin //{
        idle_field_char = 9'h007;
        cnt3 = cnt3+1;
       end //}
       else if(cnt3 == 4) begin //{
        idle_field_char = 9'h000;
        cnt3 = cnt3+1;
       end //}
       else if(cnt3 == 5) begin //{
        idle_field_char = 9'h080;
        cnt3 = cnt3+1;
       end //}
       else if(cnt3 == 6) begin //{
        idle_field_char = 9'h17C;
        cnt3 = cnt3+1;
       end //}
      else if(cnt3 == 7) begin //{
        idle_field_char = 9'h000;
        cnt3 = cnt3+1;
       end //}
       else if(cnt3 == 8) begin //{
        idle_field_char = 9'h000;
        cnt3 = cnt3+1;
       end //}

     end //}
   end //}

   endtask
endclass


/************** Insert Packet EOP crc corruption for standalone setup ************/
class srio_pl_standalone_pkt_eop_crc_corrupt_cb extends srio_pl_callback;
int m_detect;
bit [0:65] tmp0;
bit  flag0,corrupt_cnt;
bit [0:8] temp;
bit [3:0] cnt0,cnt1,cnt2,cnt3;
bit cs_flag0;
srio_static_variable_class static_variable_ins;

function new (string name = "srio_pl_standalone_pkt_eop_crc_corrupt_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_standalone_pkt_eop_crc_corrupt_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction

 virtual task srio_pl_char_transmitted_lane0(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{
  if((flag0 == 0) && (static_variable_ins.delay_flag == 1)) begin //{
  tmp0= idle_field_char;
  temp = tmp0[57:65];
 
      if(temp == 9'h17C)   begin //{
        cnt0 = cnt0+1;
      end //}

      else if(cnt0 == 2)  begin //{
        idle_field_char = 9'h17C;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
      else if(cnt0 == 3)  begin //{
        idle_field_char = 9'h000;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
          
      else if(cnt0 == 4)  begin //{
        idle_field_char = 9'h015;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
       else if(cnt0 == 5) begin //{
        idle_field_char = 9'h000;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
       else if(cnt0 == 6) begin //{
        idle_field_char = 9'h034;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
       else if(cnt0 == 7) begin //{
        idle_field_char = 9'h17C;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end 
       else if(cnt0 == 8) begin //{
        idle_field_char = 9'h000;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
       else if(cnt0 == 9) begin //{
        idle_field_char = 9'h000;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
       else if(cnt0 == 10) begin //
        idle_field_char = 9'h000;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
      else if(cnt0 == 11) begin //{
        flag0 = 1;
        static_variable_ins.delay_flag = 0;
      end //}
      else begin //{
        if(cnt0 == 1) begin //{
          cs_flag0 = 0;
          cnt0 = cnt0+1;
         end //}
         else
            cs_flag0 = 0;
        end //} 
     end //}
   end //}

   endtask
 virtual task srio_pl_char_transmitted_lane1(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{
  if((flag0 == 0) && (static_variable_ins.delay_flag == 1) && (cs_flag0 == 1)) begin //{

      if(cnt1 == 0)  begin //{
        idle_field_char = 9'h00b;
        cnt1 = cnt1+1;
       end //} 
       else if(cnt1 == 1)  begin //{
        idle_field_char = 9'h002;
        cnt1 = cnt1+1;
       end //} 

       else if(cnt1 == 2)  begin //{
        idle_field_char = 9'h00a;
        cnt1 = cnt1+1;
       end //} 
       else if(cnt1 == 3) begin //{
        idle_field_char = 9'h005;
        cnt1 = cnt1+1;
       end //}
       else if(cnt1 == 4) begin //{
        idle_field_char = 9'h039;
        cnt1 = cnt1+1;
       end //}
       else if(cnt1 == 5) begin //{
        idle_field_char = 9'h00b;
        cnt1 = cnt1+1;
       end //}
       else if(cnt1 == 6) begin //{
        idle_field_char = 9'h000;   //EOP crc corruption
        cnt1 = cnt1+1;
       end //}
       else if(cnt1 == 7) begin //{
        idle_field_char = 9'h000;
        cnt1 = cnt1+1;
       end //}
       else if(cnt1 == 8) begin //{
        idle_field_char = 9'h000;
        cnt1 = cnt1+1;
       end //}

     end //}
   end //}
 endtask
 virtual task srio_pl_char_transmitted_lane2(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{
  if((flag0 == 0) && (static_variable_ins.delay_flag == 1) && cs_flag0 == 1) begin //{

      if(cnt2 == 0)  begin //{
        idle_field_char = 9'h07e;
        cnt2 = cnt2+1;
       end //} 
       else if(cnt2 == 1)  begin //{
        idle_field_char = 9'h77;
        cnt2 = cnt2+1;
       end //} 

       else if(cnt2 == 2)  begin //{
        idle_field_char = 9'h0b4;
        cnt2 = cnt2+1;
       end //} 
       else if(cnt2 == 3) begin //{
        idle_field_char = 9'h0f6;
        cnt2 = cnt2+1;
       end //}
       else if(cnt2 == 4) begin //{
        idle_field_char = 9'h000;
        cnt2 = cnt2+1;
       end //}
       else if(cnt2 == 5) begin //{
        idle_field_char = 9'h0fe;
        cnt2 = cnt2+1;
       end //}
       else if(cnt2 == 6) begin //{
        idle_field_char = 9'h000; //EOP crc corruption
        cnt2 = cnt2+1;
       end //}
      else if(cnt2 == 7) begin //{
        idle_field_char = 9'h000;
        cnt2 = cnt2+1;
       end //}
       else if(cnt2 == 8) begin //{
        idle_field_char = 9'h000;
        cnt2 = cnt2+1;
       end //}

    end //}
   end //}
 endtask


 virtual task srio_pl_char_transmitted_lane3(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{
  if((flag0 == 0) && (static_variable_ins.delay_flag == 1) && cs_flag0 == 1) begin //{
      if(cnt3 == 0)  begin //{
        idle_field_char = 9'h000;
        cnt3 = cnt3+1;
       end //} 
       else if(cnt3 == 1)  begin //{
        idle_field_char = 9'h17C;
        cnt3 = cnt3+1;
       end //} 

       else if(cnt3 == 2)  begin //{
        idle_field_char = 9'h0a2;
        cnt3 = cnt3+1;
       end //} 
       else if(cnt3 == 3) begin //{
        idle_field_char = 9'h007;
        cnt3 = cnt3+1;
       end //}
       else if(cnt3 == 4) begin //{
        idle_field_char = 9'h000;
        cnt3 = cnt3+1;
       end //}
       else if(cnt3 == 5) begin //{
        idle_field_char = 9'h080;
        cnt3 = cnt3+1;
       end //}
       else if(cnt3 == 6) begin //{
        idle_field_char = 9'h17C;
        cnt3 = cnt3+1;
       end //}
      else if(cnt3 == 7) begin //{
        idle_field_char = 9'h000;
        cnt3 = cnt3+1;
       end //}
       else if(cnt3 == 8) begin //{
        idle_field_char = 9'h000;
        cnt3 = cnt3+1;
       end //}

     end //}
   end //}

   endtask
endclass

/************** Insert Packet with no SOP corruption for standalone setup ************/
class srio_pl_standalone_pkt_no_sop_corrupt_cb extends srio_pl_callback;
int m_detect;
bit [0:65] tmp0;
bit  flag0,corrupt_cnt;
bit [0:8] temp;
bit [3:0] cnt0,cnt1,cnt2,cnt3;
bit cs_flag0;
srio_static_variable_class static_variable_ins;

function new (string name = "srio_pl_standalone_pkt_no_sop_corrupt_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_standalone_pkt_no_sop_corrupt_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction

 virtual task srio_pl_char_transmitted_lane0(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{
  if((flag0 == 0) && (static_variable_ins.delay_flag == 1)) begin //{
  tmp0= idle_field_char;
  temp = tmp0[57:65];
 
      if(temp == 9'h17C)   begin //{
        cnt0 = cnt0+1;
      end //}
        
      else if(cnt0 == 2)  begin //{
        idle_field_char = 9'h015;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
       else if(cnt0 == 3) begin //{
        idle_field_char = 9'h000;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
       else if(cnt0 == 4) begin //{
        idle_field_char = 9'h034;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
       else if(cnt0 == 5) begin //{
        idle_field_char = 9'h17C;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end 
       else if(cnt0 == 6) begin //{
        idle_field_char = 9'h000;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
      else if(cnt0 == 7) begin //{
        flag0 = 1;
        static_variable_ins.delay_flag = 0;
      end //}
      else begin //{
        if(cnt0 == 1) begin //{
          cs_flag0 = 0;
          cnt0 = cnt0+1;
         end //}
         else
            cs_flag0 = 0;
        end //} 
     end //}
   end //}

   endtask
 virtual task srio_pl_char_transmitted_lane1(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{
  if((flag0 == 0) && (static_variable_ins.delay_flag == 1) && (cs_flag0 == 1)) begin //{

       if(cnt1 == 0)  begin //{
        idle_field_char = 9'h00a;
        cnt1 = cnt1+1;
       end //} 
       else if(cnt1 == 1) begin //{
        idle_field_char = 9'h005;
        cnt1 = cnt1+1;
       end //}
       else if(cnt1 == 2) begin //{
        idle_field_char = 9'h039;
        cnt1 = cnt1+1;
       end //}
       else if(cnt1 == 3) begin //{
        idle_field_char = 9'h00b;
        cnt1 = cnt1+1;
       end //}
       else if(cnt1 == 4) begin //{
        idle_field_char = 9'h006;
        cnt1 = cnt1+1;
       end //}

     end //}
   end //}
 endtask
 virtual task srio_pl_char_transmitted_lane2(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{
  if((flag0 == 0) && (static_variable_ins.delay_flag == 1) && cs_flag0 == 1) begin //{

      if(cnt2 == 0)  begin //{
        idle_field_char = 9'h0b4;
        cnt2 = cnt2+1;
       end //} 
       else if(cnt2 == 1) begin //{
        idle_field_char = 9'h0f6;
        cnt2 = cnt2+1;
       end //}
       else if(cnt2 == 2) begin //{
        idle_field_char = 9'h000;
        cnt2 = cnt2+1;
       end //}
       else if(cnt2 == 3) begin //{
        idle_field_char = 9'h07e;
        cnt2 = cnt2+1;
       end //}
       else if(cnt2 == 4) begin //{
        idle_field_char = 9'h0f3;
        cnt2 = cnt2+1;
       end //}

    end //}
   end //}
 endtask


 virtual task srio_pl_char_transmitted_lane3(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{
  if((flag0 == 0) && (static_variable_ins.delay_flag == 1) && cs_flag0 == 1) begin //{

      if(cnt3 == 0)  begin //{
        idle_field_char = 9'h0a2;
        cnt3 = cnt3+1;
       end //} 
       else if(cnt3 == 1) begin //{
        idle_field_char = 9'h007;
        cnt3 = cnt3+1;
       end //}
       else if(cnt3 == 2) begin //{
        idle_field_char = 9'h000;
        cnt3 = cnt3+1;
       end //}
       else if(cnt3 == 3) begin //{
        idle_field_char = 9'h080;
        cnt3 = cnt3+1;
       end //}
       else if(cnt3 == 4) begin //{
        idle_field_char = 9'h17C;
        cnt3 = cnt3+1;
       end //}
     end //}
   end //}

   endtask
endclass

/************** Insert Packet with no EOP corruption for standalone setup ************/
class srio_pl_standalone_pkt_no_eop_corrupt_cb extends srio_pl_callback;
int m_detect;
bit [0:65] tmp0;
bit  flag0,corrupt_cnt;
bit [0:8] temp;
bit [3:0] cnt0,cnt1,cnt2,cnt3;
bit cs_flag0;
srio_static_variable_class static_variable_ins;

function new (string name = "srio_pl_standalone_pkt_no_eop_corrupt_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_standalone_pkt_no_eop_corrupt_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction

 virtual task srio_pl_char_transmitted_lane0(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{
  if((flag0 == 0) && (static_variable_ins.delay_flag == 1)) begin //{
  tmp0= idle_field_char;
  temp = tmp0[57:65];
 
      if(temp == 9'h17C)   begin //{
        cnt0 = cnt0+1;
      end //}

      else if(cnt0 == 2)  begin //{
        idle_field_char = 9'h17C;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
      else if(cnt0 == 3)  begin //{
        idle_field_char = 9'h000;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
          
      else if(cnt0 == 4)  begin //{
        idle_field_char = 9'h015;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
       else if(cnt0 == 5) begin //{
        idle_field_char = 9'h000;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
       else if(cnt0 == 6) begin //{
        idle_field_char = 9'h034;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
      else if(cnt0 == 9) begin //{
        flag0 = 1;
        static_variable_ins.delay_flag = 0;
      end //}
      else begin //{
        if(cnt0 == 1) begin //{
          cs_flag0 = 0;
          cnt0 = cnt0+1;
         end //}
         else
            cs_flag0 = 0;
        end //} 
     end //}
   end //}

   endtask
 virtual task srio_pl_char_transmitted_lane1(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{
  if((flag0 == 0) && (static_variable_ins.delay_flag == 1) && (cs_flag0 == 1)) begin //{

      if(cnt1 == 0)  begin //{
        idle_field_char = 9'h00b;
        cnt1 = cnt1+1;
       end //} 
       else if(cnt1 == 1)  begin //{
        idle_field_char = 9'h002;
        cnt1 = cnt1+1;
       end //} 

       else if(cnt1 == 2)  begin //{
        idle_field_char = 9'h00a;
        cnt1 = cnt1+1;
       end //} 
       else if(cnt1 == 3) begin //{
        idle_field_char = 9'h005;
        cnt1 = cnt1+1;
       end //}
       else if(cnt1 == 4) begin //{
        idle_field_char = 9'h039;
        cnt1 = cnt1+1;
       end //}
     end //}
   end //}
 endtask
 virtual task srio_pl_char_transmitted_lane2(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{
  if((flag0 == 0) && (static_variable_ins.delay_flag == 1) && cs_flag0 == 1) begin //{

      if(cnt2 == 0)  begin //{
        idle_field_char = 9'h07e;
        cnt2 = cnt2+1;
       end //} 
       else if(cnt2 == 1)  begin //{
        idle_field_char = 9'h077;
        cnt2 = cnt2+1;
       end //} 

       else if(cnt2 == 2)  begin //{
        idle_field_char = 9'h0b4;
        cnt2 = cnt2+1;
       end //} 
       else if(cnt2 == 3) begin //{
        idle_field_char = 9'h0f6;
        cnt2 = cnt2+1;
       end //}
       else if(cnt2 == 4) begin //{
        idle_field_char = 9'h000;
        cnt2 = cnt2+1;
       end //}

    end //}
   end //}
 endtask


 virtual task srio_pl_char_transmitted_lane3(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{
  if((flag0 == 0) && (static_variable_ins.delay_flag == 1) && cs_flag0 == 1) begin //{
      if(cnt3 == 0)  begin //{
        idle_field_char = 9'h000;
        cnt3 = cnt3+1;
       end //} 
       else if(cnt3 == 1)  begin //{
        idle_field_char = 9'h17C;
        cnt3 = cnt3+1;
       end //} 

       else if(cnt3 == 2)  begin //{
        idle_field_char = 9'h0a2;
        cnt3 = cnt3+1;
       end //} 
       else if(cnt3 == 3) begin //{
        idle_field_char = 9'h007;
        cnt3 = cnt3+1;
       end //}
       else if(cnt3 == 4) begin //{
        idle_field_char = 9'h000;
        cnt3 = cnt3+1;
       end //}
     end //}
   end //}

   endtask
endclass 

/************** Insert Packet and STOMP crc corruption for standalone setup ************/
class srio_pl_standalone_pkt_stomp_crc_corrupt_cb extends srio_pl_callback;
int m_detect;
bit [0:65] tmp0;
bit  flag0,corrupt_cnt;
bit [0:8] temp;
bit [3:0] cnt0,cnt1,cnt2,cnt3;
bit cs_flag0;
srio_static_variable_class static_variable_ins;

function new (string name = "srio_pl_standalone_pkt_stomp_crc_corrupt_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_standalone_pkt_stomp_crc_corrupt_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction

 virtual task srio_pl_char_transmitted_lane0(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{
  if((flag0 == 0) && (static_variable_ins.delay_flag == 1)) begin //{
  tmp0= idle_field_char;
  temp = tmp0[57:65];
 
      if(temp == 9'h17C)   begin //{
        cnt0 = cnt0+1;
      end //}

      else if(cnt0 == 2)  begin //{
        idle_field_char = 9'h17C;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
      else if(cnt0 == 3)  begin //{
        idle_field_char = 9'h000;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
          
      else if(cnt0 == 4)  begin //{
        idle_field_char = 9'h015;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
       else if(cnt0 == 5) begin //{
        idle_field_char = 9'h000;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
       else if(cnt0 == 6) begin //{
        idle_field_char = 9'h034;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
       else if(cnt0 == 7) begin //{
        idle_field_char = 9'h17C;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end 
       else if(cnt0 == 8) begin //{
        idle_field_char = 9'h000;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
       else if(cnt0 == 9) begin //{
        idle_field_char = 9'h000;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
       else if(cnt0 == 10) begin //
        idle_field_char = 9'h000;
        cs_flag0 = 1;
        cnt0 = cnt0+1;
       end
      else if(cnt0 == 11) begin //{
        flag0 = 1;
        static_variable_ins.delay_flag = 0;
      end //}
      else begin //{
        if(cnt0 == 1) begin //{
          cs_flag0 = 0;
          cnt0 = cnt0+1;
         end //}
         else
            cs_flag0 = 0;
        end //} 
     end //}
   end //}

   endtask
 virtual task srio_pl_char_transmitted_lane1(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{
  if((flag0 == 0) && (static_variable_ins.delay_flag == 1) && (cs_flag0 == 1)) begin //{

      if(cnt1 == 0)  begin //{
        idle_field_char = 9'h00b;
        cnt1 = cnt1+1;
       end //} 
       else if(cnt1 == 1)  begin //{
        idle_field_char = 9'h002;
        cnt1 = cnt1+1;
       end //} 

       else if(cnt1 == 2)  begin //{
        idle_field_char = 9'h00a;
        cnt1 = cnt1+1;
       end //} 
       else if(cnt1 == 3) begin //{
        idle_field_char = 9'h005;
        cnt1 = cnt1+1;
       end //}
       else if(cnt1 == 4) begin //{
        idle_field_char = 9'h039;
        cnt1 = cnt1+1;
       end //}
       else if(cnt1 == 5) begin //{
        idle_field_char = 9'h00b;
        cnt1 = cnt1+1;
       end //}
       else if(cnt1 == 6) begin //{
        idle_field_char = 9'h003;
        cnt1 = cnt1+1;
       end //}
       else if(cnt1 == 7) begin //{
        idle_field_char = 9'h000;
        cnt1 = cnt1+1;
       end //}
       else if(cnt1 == 8) begin //{
        idle_field_char = 9'h000;
        cnt1 = cnt1+1;
       end //}

     end //}
    else  begin //{
      if(cnt0 == 2)
         idle_field_char = 9'h000;
    end //} 
   end //}
 endtask
 virtual task srio_pl_char_transmitted_lane2(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{
  if((flag0 == 0) && (static_variable_ins.delay_flag == 1) && cs_flag0 == 1) begin //{

      if(cnt2 == 0)  begin //{
        idle_field_char = 9'h07e;
        cnt2 = cnt2+1;
       end //} 
       else if(cnt2 == 1)  begin //{
        idle_field_char = 9'h077;
        cnt2 = cnt2+1;
       end //} 

       else if(cnt2 == 2)  begin //{
        idle_field_char = 9'h0b4;
        cnt2 = cnt2+1;
       end //} 
       else if(cnt2 == 3) begin //{
        idle_field_char = 9'h0f6;
        cnt2 = cnt2+1;
       end //}
       else if(cnt2 == 4) begin //{
        idle_field_char = 9'h000;
        cnt2 = cnt2+1;
       end //}
       else if(cnt2 == 5) begin //{
        idle_field_char = 9'h0fe;
        cnt2 = cnt2+1;
       end //}
       else if(cnt2 == 6) begin //{
        idle_field_char = 9'h076;
        cnt2 = cnt2+1;
       end //}
      else if(cnt2 == 7) begin //{
        idle_field_char = 9'h000;
        cnt2 = cnt2+1;
       end //}
       else if(cnt2 == 8) begin //{
        idle_field_char = 9'h000;
        cnt2 = cnt2+1;
       end //}

    end //}
    else  begin //{
      if(cnt0 == 2)
         idle_field_char = 9'h000;
    end //}   
   end //}
 endtask


 virtual task srio_pl_char_transmitted_lane3(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{
  if((flag0 == 0) && (static_variable_ins.delay_flag == 1) && cs_flag0 == 1) begin //{
      if(cnt3 == 0)  begin //{
        idle_field_char = 9'h000;
        cnt3 = cnt3+1;
       end //} 
       else if(cnt3 == 1)  begin //{
        idle_field_char = 9'h17C;
        cnt3 = cnt3+1;
       end //} 

       else if(cnt3 == 2)  begin //{
        idle_field_char = 9'h0a2;
        cnt3 = cnt3+1;
       end //} 
       else if(cnt3 == 3) begin //{
        idle_field_char = 9'h007;
        cnt3 = cnt3+1;
       end //}
       else if(cnt3 == 4) begin //{
        idle_field_char = 9'h000;
        cnt3 = cnt3+1;
       end //}
       else if(cnt3 == 5) begin //{
        idle_field_char = 9'h080;
        cnt3 = cnt3+1;
       end //}
       else if(cnt3 == 6) begin //{
        idle_field_char = 9'h17C;
        cnt3 = cnt3+1;
       end //}
      else if(cnt3 == 7) begin //{
        idle_field_char = 9'h000;
        cnt3 = cnt3+1;
       end //}
       else if(cnt3 == 8) begin //{
        idle_field_char = 9'h000;
        cnt3 = cnt3+1;
       end //}

     end //}

   end //}

   endtask

endclass
//============== callback to detect Recieved Retry or  PNACK CS =========
class srio_pl_rcvd_retry_pnack_cs_cb extends srio_pl_callback;
bit irs_detect_cb,ies_detect_cb;
function new (string name = "srio_pl_rcvd_retry_pnack_cs_cb"); 
super.new(name); 
endfunction 

virtual task srio_pl_trans_received(ref srio_trans rx_srio_trans);

if(rx_srio_trans.transaction_kind==SRIO_CS)
 begin
   if((rx_srio_trans.stype0 == 4'h1) )
      begin 
          irs_detect_cb = 1;
      end
   else if (rx_srio_trans.stype0 == 4'h2)
      begin
        ies_detect_cb = 1;
      end
    else 
     begin
         irs_detect_cb = 0;
         ies_detect_cb = 0;
     end
         
end
endtask
endclass

//============== callback to detect Transmitted Retry or PNACK CS =========
class srio_pl_transmit_retry_pnack_cs_cb extends srio_pl_callback;
bit ors_detect_cb,oes_detect_cb;
int pkt_size;
bit [0:8] tmp0,tmp1,tmp2,tmp3,tmp4,tmp5,tmp6,tmp7,tmp8;
bit [0:2] flag;
function new (string name = "srio_pl_transmit_retry_pnack_cs_cb"); 
super.new(name); 
endfunction 

 virtual task srio_pl_trans_transmit(ref srio_pl_data_trans tx_gen,srio_trans srio_trans_in);
   if(tx_gen.m_type == MERGED_CS)
    begin //{
       pkt_size = tx_gen.bs_merged_cs.size() ; 
       tmp8 =tx_gen.bs_merged_cs[pkt_size -8] ;
       tmp7 =tx_gen.bs_merged_cs[pkt_size -7] ;
       tmp6 =tx_gen.bs_merged_cs[pkt_size -6] ;
       tmp5 =tx_gen.bs_merged_cs[pkt_size -5] ;
       tmp4 =tx_gen.bs_merged_cs[pkt_size -4] ;
       tmp3 =tx_gen.bs_merged_cs[pkt_size -3] ;
       tmp2 =tx_gen.bs_merged_cs[pkt_size -2] ;
       tmp1 =tx_gen.bs_merged_cs[pkt_size -1] ;
       flag= tmp7[1:3];
   if((flag == 1) )
      begin 
          ors_detect_cb = 1;
      end
   else if (flag == 2)
      begin
        oes_detect_cb = 1;
      end
    else 
     begin
         ors_detect_cb = 0;
         oes_detect_cb = 0;
     end
end //}
endtask

endclass

//***************** CS insertion callback ********************
class srio_pl_cs_insertion_callback extends srio_pl_callback;
int cs_detect_cnt0=0,cs_detect_cnt1;
bit [0:65] tmp0,tmp1,tmp3;
bit flag0,flag1;
bit [0:8] temp0,temp1,temp2,temp3;
int rand_inject;

function new (string name = "srio_pl_cs_insertion_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_cs_insertion_callback"; 


virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_char_transmitted_lane0(ref bit [0:65] idle_field_char,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
   if(env_config.idle_detected && env_config.idle_selected)
    begin//{
      if(env_config.num_of_lanes==2) begin//{
         tmp0= idle_field_char;
         temp0 = tmp0[57:65];
       if(flag0 == 0 ) begin //{
         if((temp0 == 9'h11C) && (cs_detect_cnt0 == 0))   begin //{
             cs_detect_cnt0=1;
             rand_inject=$urandom_range(0,7);
           end //}
         else if (cs_detect_cnt0 <= 4 && cs_detect_cnt0>=1)
           begin //{
             cs_detect_cnt0++;
           end//}
        else if(cs_detect_cnt0 == 5) 
           begin//{
             env_config.scramble_dis=0;
             idle_field_char[57:65] = 9'h000;
           end//}
        else if(cs_detect_cnt0 == 6) 
           begin//{
             env_config.scramble_dis=0;
             idle_field_char[57:65] = 9'h11c;
           end//}
        else if(cs_detect_cnt0 == 7) 
           begin//{
             env_config.scramble_dis=0;
             idle_field_char[57:65] = 9'h07f;
           end//}
        else if(cs_detect_cnt0 == 8) 
           begin//{
             env_config.scramble_dis=0;
             idle_field_char[57:65] = 9'h000;
           end//}
        else if(cs_detect_cnt0 == 9) 
           begin//{
             env_config.scramble_dis=0;
             idle_field_char[57:65] = 9'h035;
           end//}
        end//}
      end//}
     else if(env_config.num_of_lanes==1)
      begin//{
         tmp0= idle_field_char;
         temp0 = tmp0[57:65];
       
       if(flag0 == 0 ) begin //{
         if((temp0 == 9'h11C) && (cs_detect_cnt0 == 0))   begin //{
             cs_detect_cnt0=1;
             rand_inject=$urandom_range(0,7);
           end //}
         else if (cs_detect_cnt0 <= 7 && cs_detect_cnt0>=1)
           begin //{
             cs_detect_cnt0++;
           end//}
        else if(cs_detect_cnt0 == 8) 
           begin//{
             env_config.scramble_dis=0;
             idle_field_char[57:65] = 9'h000;
             if(rand_inject==0)
              cs_detect_cnt0 ++;
             rand_inject--;
           end//}
        else if(cs_detect_cnt0 == 9) 
           begin//{
             env_config.scramble_dis=0;
             idle_field_char[57:65] = 9'h11c;
             cs_detect_cnt0 ++;
           end//}
        else if(cs_detect_cnt0 == 10) 
           begin//{
             env_config.scramble_dis=0;
             idle_field_char[57:65] = 9'h080;
             cs_detect_cnt0 ++;
           end//}
        else if(cs_detect_cnt0 == 11) 
           begin//{
             env_config.scramble_dis=0;
             idle_field_char[57:65] = 9'h07f;
             cs_detect_cnt0 ++;
           end//}
        else if(cs_detect_cnt0 == 12) 
           begin//{
             env_config.scramble_dis=0;
             idle_field_char[57:65] = 9'h0c0;
             cs_detect_cnt0 ++;
           end//}
        else if(cs_detect_cnt0 == 13) 
           begin//{
             env_config.scramble_dis=0;
             idle_field_char[57:65] = 9'h000;
             cs_detect_cnt0 ++;
           end//}
        else if(cs_detect_cnt0 == 14) 
           begin//{
             env_config.scramble_dis=0;
             idle_field_char[57:65] = 9'h00a;
             cs_detect_cnt0 ++;
           end//}
        else if(cs_detect_cnt0 == 15) 
           begin//{
             env_config.scramble_dis=0;
             idle_field_char[57:65] = 9'h035;
             cs_detect_cnt0 ++;
           end//}
        else if(cs_detect_cnt0 == 16) 
           begin//{
             env_config.scramble_dis=0;
             idle_field_char[57:65] = 9'h11c;
             flag0=1;
             cs_detect_cnt0=0;
             `uvm_info("CALLBACK",$sformatf("Control Symbol Inserted"),UVM_LOW)
           end//}
      end//}
       if(flag0 == 1 && temp0 == 9'h11C) begin //{
         if(flag1)
          begin//{
           flag0=0;
          end//}
         flag1=1;
         if(~flag0)
         flag1=0;
        end//}
     end //}
     else if(env_config.num_of_lanes==4)
      begin//{
         tmp0= idle_field_char;
         temp0 = tmp0[57:65];
       if(flag0 == 0 ) begin //{
         if((temp0 == 9'h11C) && (cs_detect_cnt0 == 0))   begin //{
             cs_detect_cnt0=1;
             rand_inject=$urandom_range(0,7);
           end //}
         else if (cs_detect_cnt0==1)
           begin //{
             cs_detect_cnt0++;
           end//}
        else if(cs_detect_cnt0 == 3) 
           begin//{
             env_config.scramble_dis=0;
             idle_field_char[57:65] = 9'h000;
           end//}
        else if(cs_detect_cnt0 == 4) 
           begin//{
             env_config.scramble_dis=0;
             idle_field_char[57:65] = 9'h11c;
           end//}
        else if(cs_detect_cnt0 == 5) 
           begin//{
             env_config.scramble_dis=0;
             idle_field_char[57:65] = 9'h000;
           end//}
         end //}
         
      end//}
     end //}
    else
     begin//{
      //IDLE1 Beginning
      if(env_config.num_of_lanes==2)
       begin//{
           tmp0= idle_field_char;
           temp0 = tmp0[57:65];
         if(flag0 == 0 ) begin //{
           if(cs_detect_cnt0 == 2) 
             begin//{
               idle_field_char[57:65] = 9'h1BC;
             end//}
          else if(cs_detect_cnt0 == 3) 
             begin//{
               idle_field_char[57:65] = 9'h11c;
             end//}
          else if(cs_detect_cnt0 == 4) 
             begin//{
               idle_field_char[57:65] = 9'h0ff;
             end//}
         end//}
       end//}
     else if(env_config.num_of_lanes==1)
      begin//{
           tmp0= idle_field_char;
           temp0 = tmp0[57:65];
       if(flag0 == 0 ) begin //{
         if((temp0 == 9'h11C) && (cs_detect_cnt0 == 0))   begin //{
             cs_detect_cnt0=1;
             rand_inject=$urandom_range(0,7);
           end //}
         else if (cs_detect_cnt0 <= 3 && cs_detect_cnt0>=1)
           begin //{
             cs_detect_cnt0++;
           end//}
        else if(cs_detect_cnt0 == 4) 
           begin//{
             env_config.scramble_dis=0;
             idle_field_char[57:65] = 9'h1BC;
             if(rand_inject==0)
              cs_detect_cnt0 ++;
             rand_inject--;
           end//}
        else if(cs_detect_cnt0 == 5) 
           begin//{
             env_config.scramble_dis=0;
             idle_field_char[57:65] = 9'h11c;
             cs_detect_cnt0 ++;
           end//}
        else if(cs_detect_cnt0 == 6) 
           begin//{
             env_config.scramble_dis=0;
             idle_field_char[57:65] = 9'h080;
             cs_detect_cnt0 ++;
           end//}
        else if(cs_detect_cnt0 == 7) 
           begin//{
             env_config.scramble_dis=0;
             idle_field_char[57:65] = 9'h0ff;
             cs_detect_cnt0 ++;
           end//}
        else if(cs_detect_cnt0 == 8) 
           begin//{
             env_config.scramble_dis=0;
             idle_field_char[57:65] = 9'h00f;
             flag0=1;
             cs_detect_cnt0=0;
             `uvm_info("CALLBACK",$sformatf("Control Symbol Inserted"),UVM_LOW)
        end//}
      end//}
       if(flag0 == 1 && temp0 == 9'h11C) begin //{
         flag0=0;
        end//}
      end//}
     else if(env_config.num_of_lanes==4)
      begin//{
           tmp0= idle_field_char;
           temp0 = tmp0[57:65];
        if(flag0 == 0 ) begin //{
         if((temp0 == 9'h11C) && (cs_detect_cnt0 == 0))   begin //{
             cs_detect_cnt0++;
             rand_inject=$urandom_range(0,7);
           end //}
         else if (cs_detect_cnt0==2)
           begin//{
             idle_field_char[57:65] = 9'h1BC;
           end//}
         else if (cs_detect_cnt0==3)
           begin//{
             idle_field_char[57:65] = 9'h11C;
        end//}
      end//}
     end//}
   end//}
end//}
        
endtask

 virtual task srio_pl_char_transmitted_lane1(ref bit [0:65] idle_field_char,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
   if(env_config.idle_detected && env_config.idle_selected)
    begin//{
      if(env_config.num_of_lanes==2)
       begin//{
         tmp1= idle_field_char;
         temp1 = tmp1[57:65];
        if(flag1 == 1 &&  temp1==9'h11c) begin //{
          flag0=0;
          flag1=0;
         end//}
        if(flag1 == 0 ) begin //{
         if((temp0 == 9'h11C) && (cs_detect_cnt1 == 0))   begin //{
             cs_detect_cnt1++;
           end //}
         else if (cs_detect_cnt1 < 4)
           begin//{
             cs_detect_cnt1++;
           end//}
        else if(cs_detect_cnt0 == 5) 
           begin//{
             env_config.scramble_dis=0;
             idle_field_char[57:65] = 9'h000;
             rand_inject--;
             if(~rand_inject)
              cs_detect_cnt0 ++;
           end//}
        else if(cs_detect_cnt0 == 6) 
           begin//{
             env_config.scramble_dis=0;
             idle_field_char[57:65] = 9'h080;
             cs_detect_cnt0 ++;
           end//}
        else if(cs_detect_cnt0 == 7) 
           begin//{
             env_config.scramble_dis=0;
             idle_field_char[57:65] = 9'h0c0;
             cs_detect_cnt0 ++;
           end//}
        else if(cs_detect_cnt0 == 8)
           begin//{
             env_config.scramble_dis=0;
             idle_field_char[57:65] = 9'h00a;
             cs_detect_cnt0 ++;
           end//}
        else if(cs_detect_cnt0 == 9) 
           begin//{
             env_config.scramble_dis=0;
             idle_field_char[57:65] = 9'h11c;
             cs_detect_cnt0 ++;
             flag1 = 1;
             flag0 = 1;
             cs_detect_cnt0=0;
           end//}
       end//}
     end//}
    else if(env_config.num_of_lanes==4)
     begin//{
        if(cs_detect_cnt0 == 3) 
           begin//{
             env_config.scramble_dis=0;
             idle_field_char[57:65] = 9'h000;
           end//}
        else if(cs_detect_cnt0 == 4) 
           begin//{
             env_config.scramble_dis=0;
             idle_field_char[57:65] = 9'h080;
           end//}
        else if(cs_detect_cnt0 == 5) 
           begin//{
             env_config.scramble_dis=0;
             idle_field_char[57:65] = 9'h00a;
           end//}
     end//}
    end//}
   else
    begin//{
     if(env_config.num_of_lanes==2)
      begin//{
        tmp1= idle_field_char;
        temp1 = tmp1[57:65];
       if(flag1 == 0 ) begin //{
        if((temp0 == 9'h11C) && (cs_detect_cnt0 == 0))   begin //{
            cs_detect_cnt0=1;
             rand_inject=$urandom_range(0,7);
          end //}
        else if (cs_detect_cnt1 < 4)
            cs_detect_cnt1++;
       else if(cs_detect_cnt0 == 1) 
            cs_detect_cnt0 ++;
       else if(cs_detect_cnt0 == 2) 
          begin//{
            idle_field_char[57:65] = 9'h1BC;
            if(rand_inject==0)
            cs_detect_cnt0 ++;
            rand_inject--;
          end//}
       else if(cs_detect_cnt0 == 3) 
          begin//{
            idle_field_char[57:65] = 9'h080;
            cs_detect_cnt0 ++;
          end//}
       else if(cs_detect_cnt0 == 4) 
          begin//{
            idle_field_char[57:65] = 9'h00f;
            cs_detect_cnt0 ++;
            flag1 = 1;
            flag0 = 1;
            cs_detect_cnt0=0;
          end//}
       end//}
        if(flag1 == 1 &&  temp0==9'h11c) begin //{
          flag0=0;
          flag1=0;
         end//}
      end//}
     else if(env_config.num_of_lanes==4)
      begin//{
         if(cs_detect_cnt0 == 2) 
            begin//{
              idle_field_char[57:65] = 9'h1BC;
            end//}
         else if(cs_detect_cnt0 == 3) 
            begin//{
              idle_field_char[57:65] = 9'h080;
            end//}
      end//}
     end//}
    end//}
endtask

 virtual task srio_pl_char_transmitted_lane2(ref bit [0:65] idle_field_char,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
   if(env_config.idle_detected && env_config.idle_selected)
    begin//{
      if(env_config.num_of_lanes==4)
        begin//{
        if(cs_detect_cnt0 == 3) 
           begin//{
             env_config.scramble_dis=0;
             idle_field_char[57:65] = 9'h000;
           end//}
        else if(cs_detect_cnt0 == 4) 
           begin//{
             env_config.scramble_dis=0;
             idle_field_char[57:65] = 9'h07f;
           end//}
        else if(cs_detect_cnt0 == 5) 
           begin//{
             env_config.scramble_dis=0;
             idle_field_char[57:65] = 9'h035;
           end//}
        end//}
    end//}
   else
    begin//{
      if(env_config.num_of_lanes==4)
        begin//{
         if(cs_detect_cnt0 == 2) 
            begin//{
              idle_field_char[57:65] = 9'h1BC;
            end//}
         else if(cs_detect_cnt0 == 3) 
            begin//{
              idle_field_char[57:65] = 9'h0ff;
            end//}
        end//}
    end//}
end//}
endtask

 virtual task srio_pl_char_transmitted_lane3(ref bit [0:65] idle_field_char,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
   if(env_config.idle_detected && env_config.idle_selected)
    begin//{
      if(env_config.num_of_lanes==4)
        begin//{
           tmp3= idle_field_char;
           temp3 = tmp3[57:65];
        if(cs_detect_cnt0 == 2 && temp3==9'h11c) 
           begin//{
              cs_detect_cnt0++;
           end//}
        else if(cs_detect_cnt0 == 3) 
           begin//{
             env_config.scramble_dis=0;
             idle_field_char[57:65] = 9'h000;
             if(rand_inject==0)
              cs_detect_cnt0++;
             rand_inject--;
           end//}
        else if(cs_detect_cnt0 == 4) 
           begin//{
             env_config.scramble_dis=0;
             idle_field_char[57:65] = 9'h0c0;
              cs_detect_cnt0++;
           end//}
        else if(cs_detect_cnt0 == 5) 
           begin//{
             env_config.scramble_dis=0;
             idle_field_char[57:65] = 9'h11c;
             flag0=1;
             cs_detect_cnt0=0;
           end//}
        if(flag0==1 && temp3==9'h11C)
         flag0=0;
        end//}
   end//}
  else
   begin//{
      if(env_config.num_of_lanes==4)
        begin//{
         if(cs_detect_cnt0==1)
          cs_detect_cnt0=2;
         else if(cs_detect_cnt0==2)
          begin//{
             idle_field_char[57:65] = 9'h1BC;
             if(rand_inject==0)
              cs_detect_cnt0++;
             rand_inject--;
          end//} 
         else if(cs_detect_cnt0==3)
          begin//{
             idle_field_char[57:65] = 9'h00F;
             flag0=1;
             cs_detect_cnt0=0;
          end//} 
          if(flag0==1 && temp0==9'h11C)
           flag0=0;
        end//}
   end//}

end//}
endtask
endclass

//callback to corrupt the PKT_ACC CS to make LINK_TIMEOUT
class srio_pl_remove_pa_link_timeout_callback extends srio_pl_callback;
bit [0:8] tmp0,tmp1,tmp2,tmp3,tmp4,tmp5,tmp6,tmp7,tmp8;
bit [0:12] cal_crc13;
bit [0:37] tmp_crc;
int pkt_size;
srio_pl_agent pl_agent_cb ; 
int cnt;
bit flag;
function new (string name = "srio_pl_remove_pa_link_timeout_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_remove_pa_link_timeout_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_trans_transmit(ref srio_pl_data_trans tx_gen,srio_trans srio_trans_in);
   if(tx_gen.m_type == MERGED_CS)
    begin //{
       begin
         tmp1 =tx_gen.bs_merged_cs[1][1:8] ;
         if(tmp1[1:3] == 0 && flag != 1)
         begin //{
         cnt = cnt+1;
         if(cnt > 2 && cnt < 4)
         begin //{
          tx_gen.bs_merged_cs.delete() ;
         end //}
         end//}
         else if(tmp1[1:3] == 6)
           begin
             flag = 1;
           end
       end
    end //}
   endtask

endclass


//============== callback to corrupt EOP to STOMP for GEN2 =========
class srio_pl_transmit_eop_to_stomp_cs_cb extends srio_pl_callback;
int pkt_size;
bit [0:8] tmp0,tmp1,tmp2,tmp3,tmp4,tmp5,tmp6,tmp7,tmp8;
bit flag1,flag2,flag3;
int cnt;

bit [0:12] cal_crc13;
bit [0:37] tmp_crc;
rand bit [3:0] cnt_rand;
bit rand_bit = 1;
bit [3:0] a,b,c;

function new (string name = "srio_pl_transmit_eop_to_stomp_cs_cb"); 
super.new(name); 
endfunction 

 virtual task srio_pl_trans_transmit(ref srio_pl_data_trans tx_gen,srio_trans srio_trans_in);
   if(rand_bit == 1)
     begin
       cnt_rand = $urandom_range(1,6);
       a = cnt_rand;
       cnt_rand = $urandom_range(1,6);
       b = cnt_rand;
       cnt_rand = $urandom_range(1,6);
       c = cnt_rand;
       rand_bit = 0;
     end
   if(tx_gen.m_type == MERGED_PKT)
    begin //{
       pkt_size = tx_gen.bs_merged_pkt.size() ; 
       tmp0 =tx_gen.bs_merged_pkt[pkt_size -8] ;
       tmp1 =tx_gen.bs_merged_pkt[pkt_size -7] ;
       tmp2 =tx_gen.bs_merged_pkt[pkt_size -6] ;
       tmp3 =tx_gen.bs_merged_pkt[pkt_size -5] ;
       tmp4 =tx_gen.bs_merged_pkt[pkt_size -4] ;
       tmp5 =tx_gen.bs_merged_pkt[pkt_size -3] ;
       tmp6 =tx_gen.bs_merged_pkt[pkt_size -2] ;
       tmp7 =tx_gen.bs_merged_pkt[pkt_size -1] ;
       if(tmp0 == 9'h17C)
         begin
           if((tmp1[1:3] == 4) && ({tmp2[8],tmp3[1:2]} == 2) && (flag1 == 0 | flag2 == 0 | flag3 == 0))
             begin
               cnt = cnt+1;
                 if(cnt == a | cnt == b | cnt == c)
                 begin 
                  {tx_gen.bs_merged_pkt[pkt_size -6][8],tx_gen.bs_merged_pkt[pkt_size -5][1:2]} = 3'b001;
                  void'(calccrc13({tx_gen.bs_merged_pkt[pkt_size -7][1:8],tx_gen.bs_merged_pkt[pkt_size -6][1:8],tx_gen.bs_merged_pkt[pkt_size -5][1:5]}));
                   tx_gen.bs_merged_pkt[pkt_size -3][4:8] = cal_crc13[0:4];
                   tx_gen.bs_merged_pkt[pkt_size -2][1:8] = cal_crc13[5:12];
                        if(cnt == a)
                        flag1 = 1;
                        if(cnt == b)
                        flag2 = 1;
                        if(cnt == c)
                        flag3 = 1;
                 end
              end
           end
end //}
endtask

function logic [0:12] calccrc13(logic [0:37] lcs_val);

  logic [0:20] temp_val;

  bit poly_load = 0;

  temp_val = lcs_val[17:37];

  calccrc13[ 0 ]  = ( temp_val[ 4] ^ temp_val[ 6] ^
                             temp_val[ 9] ^ temp_val[14] ^
                            temp_val[19] ) ^ poly_load;
  calccrc13[ 1 ]  = ( temp_val[ 0] ^ temp_val[ 5] ^
                             temp_val[ 7] ^ temp_val[10] ^
                             temp_val[15] ^ temp_val[20] );
  calccrc13[ 2 ]  = ( temp_val[ 1] ^ temp_val[ 6] ^
                             temp_val[ 8] ^ temp_val[11] ^
                             temp_val[16] );
  calccrc13[ 3 ]  = ( temp_val[ 2] ^ temp_val[ 4] ^
                             temp_val[ 6] ^ temp_val[ 7] ^
                             temp_val[12] ^ temp_val[14] ^
                            temp_val[17] ^ temp_val[19] ) ^ poly_load;
  calccrc13[ 4 ]  = ( temp_val[ 3] ^ temp_val[ 5] ^
                             temp_val[ 7] ^ temp_val[ 8] ^
                             temp_val[13] ^ temp_val[15] ^
                             temp_val[18] ^ temp_val[20] );
  calccrc13[ 5 ]  = ( temp_val[ 0] ^ temp_val[ 8] ^
                             temp_val[16] );
  calccrc13[ 6 ]  = ( temp_val[ 1] ^ temp_val[ 9] ^
                             temp_val[17] );
  calccrc13[ 7 ]  = ( temp_val[ 2] ^ temp_val[10] ^
                             temp_val[18] );
  calccrc13[ 8 ]  = ( temp_val[ 3] ^ temp_val[ 4] ^
                             temp_val[ 6] ^ temp_val[ 9] ^
                             temp_val[11] ^ temp_val[14] ) ^ poly_load;
  calccrc13[ 9 ]  = ( temp_val[ 0] ^ temp_val[ 4] ^
                             temp_val[ 5] ^ temp_val[ 7] ^
                             temp_val[10] ^ temp_val[12] ^
                             temp_val[15] );
  calccrc13[ 10 ] = ( temp_val[ 1] ^ temp_val[ 5] ^
                             temp_val[ 6] ^ temp_val[ 8] ^
                             temp_val[11] ^ temp_val[13] ^
                             temp_val[16] ) ^ poly_load;
  calccrc13[ 11 ] = ( temp_val[ 2] ^ temp_val[ 4] ^
                             temp_val[ 7] ^ temp_val[12] ^
                             temp_val[17] ^ temp_val[19] );
  calccrc13[ 12 ] = ( temp_val[ 3] ^ temp_val[ 5] ^
                                       temp_val[ 8] ^ temp_val[13] ^
                                       temp_val[18] ^ temp_val[20] ) ^ poly_load;
 

  cal_crc13 = calccrc13;
endfunction 

endclass

//============== callback to corrupt RESTART_FROM_RETRY to PNACK =========
class srio_pl_transmit_rfr_corrupt_cs_cb extends srio_pl_callback;
int pkt_size;
bit [0:8] tmp0,tmp1,tmp2,tmp3,tmp4,tmp5,tmp6,tmp7,tmp8;
bit flag;
int cnt,num_of_merged_cs;
bit [0:12] cal_crc13;
function new (string name = "srio_pl_transmit_rfr_corrupt_cs_cb"); 
super.new(name); 
endfunction 

 virtual task srio_pl_trans_transmit(ref srio_pl_data_trans tx_gen,srio_trans srio_trans_in);
   if(tx_gen.m_type == MERGED_CS)
    begin //{
       pkt_size = tx_gen.bs_merged_cs.size() ;
       num_of_merged_cs = pkt_size/8;
       for(int i = 0;i < num_of_merged_cs;i++)
       begin  //{
       tmp0 =tx_gen.bs_merged_cs[pkt_size -8] ;
       tmp1 =tx_gen.bs_merged_cs[pkt_size -7] ;
       tmp2 =tx_gen.bs_merged_cs[pkt_size -6] ;
       tmp3 =tx_gen.bs_merged_cs[pkt_size -5] ;
       tmp4 =tx_gen.bs_merged_cs[pkt_size -4] ;
       tmp5 =tx_gen.bs_merged_cs[pkt_size -3] ;
       tmp6 =tx_gen.bs_merged_cs[pkt_size -2] ;
       tmp7 =tx_gen.bs_merged_cs[pkt_size -1] ;
       if(tmp0 == 9'h11C)
         begin //{
           if((tmp1[1:3] == 4) && ({tmp2[8],tmp3[1:2]} == 3) && (flag == 0))
             begin //{ 
                  void'(calccrc13({tx_gen.bs_merged_cs[pkt_size -7][1:8],tx_gen.bs_merged_cs[pkt_size -6][1:8],tx_gen.bs_merged_cs[pkt_size -5][1:5]}));
                   tx_gen.bs_merged_cs[pkt_size -3][4:8] = 5'h00;
                   tx_gen.bs_merged_cs[pkt_size -2][1:8] = 8'h00;
                  flag = 1;
                 end //}
              end //}
       pkt_size = pkt_size-8;
       end //}
end //}
endtask

function logic [0:12] calccrc13(logic [0:37] lcs_val);

  logic [0:20] temp_val;

  bit poly_load = 0;

  temp_val = lcs_val[17:37];

  calccrc13[ 0 ]  = ( temp_val[ 4] ^ temp_val[ 6] ^
                             temp_val[ 9] ^ temp_val[14] ^
                            temp_val[19] ) ^ poly_load;
  calccrc13[ 1 ]  = ( temp_val[ 0] ^ temp_val[ 5] ^
                             temp_val[ 7] ^ temp_val[10] ^
                             temp_val[15] ^ temp_val[20] );
  calccrc13[ 2 ]  = ( temp_val[ 1] ^ temp_val[ 6] ^
                             temp_val[ 8] ^ temp_val[11] ^
                             temp_val[16] );
  calccrc13[ 3 ]  = ( temp_val[ 2] ^ temp_val[ 4] ^
                             temp_val[ 6] ^ temp_val[ 7] ^
                             temp_val[12] ^ temp_val[14] ^
                            temp_val[17] ^ temp_val[19] ) ^ poly_load;
  calccrc13[ 4 ]  = ( temp_val[ 3] ^ temp_val[ 5] ^
                             temp_val[ 7] ^ temp_val[ 8] ^
                             temp_val[13] ^ temp_val[15] ^
                             temp_val[18] ^ temp_val[20] );
  calccrc13[ 5 ]  = ( temp_val[ 0] ^ temp_val[ 8] ^
                             temp_val[16] );
  calccrc13[ 6 ]  = ( temp_val[ 1] ^ temp_val[ 9] ^
                             temp_val[17] );
  calccrc13[ 7 ]  = ( temp_val[ 2] ^ temp_val[10] ^
                             temp_val[18] );
  calccrc13[ 8 ]  = ( temp_val[ 3] ^ temp_val[ 4] ^
                             temp_val[ 6] ^ temp_val[ 9] ^
                             temp_val[11] ^ temp_val[14] ) ^ poly_load;
  calccrc13[ 9 ]  = ( temp_val[ 0] ^ temp_val[ 4] ^
                             temp_val[ 5] ^ temp_val[ 7] ^
                             temp_val[10] ^ temp_val[12] ^
                             temp_val[15] );
  calccrc13[ 10 ] = ( temp_val[ 1] ^ temp_val[ 5] ^
                             temp_val[ 6] ^ temp_val[ 8] ^
                             temp_val[11] ^ temp_val[13] ^
                             temp_val[16] ) ^ poly_load;
  calccrc13[ 11 ] = ( temp_val[ 2] ^ temp_val[ 4] ^
                             temp_val[ 7] ^ temp_val[12] ^
                             temp_val[17] ^ temp_val[19] );
  calccrc13[ 12 ] = ( temp_val[ 3] ^ temp_val[ 5] ^
                                       temp_val[ 8] ^ temp_val[13] ^
                                       temp_val[18] ^ temp_val[20] ) ^ poly_load;
 

  cal_crc13 = calccrc13;
endfunction 

endclass


//============== callback to corrupt RESTART_FROM_RETRY to PNACK =========
class srio_pl_transmit_rfr_to_pnack_cs_cb extends srio_pl_callback;
int pkt_size;
bit [0:8] tmp0,tmp1,tmp2,tmp3,tmp4,tmp5,tmp6,tmp7,tmp8;
bit flag;
int cnt,num_of_merged_cs;
bit [0:12] cal_crc13;
function new (string name = "srio_pl_transmit_rfr_to_pnack_cs_cb"); 
super.new(name); 
endfunction 

 virtual task srio_pl_trans_transmit(ref srio_pl_data_trans tx_gen,srio_trans srio_trans_in);
   if(tx_gen.m_type == MERGED_CS)
    begin //{
       pkt_size = tx_gen.bs_merged_cs.size() ;
       num_of_merged_cs = pkt_size/8;
       for(int i = 0;i < num_of_merged_cs;i++)
       begin  //{
       tmp0 =tx_gen.bs_merged_cs[pkt_size -8] ;
       tmp1 =tx_gen.bs_merged_cs[pkt_size -7] ;
       tmp2 =tx_gen.bs_merged_cs[pkt_size -6] ;
       tmp3 =tx_gen.bs_merged_cs[pkt_size -5] ;
       tmp4 =tx_gen.bs_merged_cs[pkt_size -4] ;
       tmp5 =tx_gen.bs_merged_cs[pkt_size -3] ;
       tmp6 =tx_gen.bs_merged_cs[pkt_size -2] ;
       tmp7 =tx_gen.bs_merged_cs[pkt_size -1] ;
       if(tmp0 == 9'h11C)
         begin //{
           if((tmp1[1:3] == 4) && ({tmp2[8],tmp3[1:2]} == 3) && (flag == 0))
             begin //{ 
                  tx_gen.bs_merged_cs[pkt_size -7][1:3]= 3'b010;
                  {tx_gen.bs_merged_cs[pkt_size -6][8],tx_gen.bs_merged_cs[pkt_size -5][1:2]} = 3'b111;
                  void'(calccrc13({tx_gen.bs_merged_cs[pkt_size -7][1:8],tx_gen.bs_merged_cs[pkt_size -6][1:8],tx_gen.bs_merged_cs[pkt_size -5][1:5]}));
                   tx_gen.bs_merged_cs[pkt_size -3][4:8] = cal_crc13[0:4];
                   tx_gen.bs_merged_cs[pkt_size -2][1:8] = cal_crc13[5:12];
                  flag = 1;
                 end //}
              end //}
       pkt_size = pkt_size-8;
       end //}
end //}
endtask

function logic [0:12] calccrc13(logic [0:37] lcs_val);

  logic [0:20] temp_val;

  bit poly_load = 0;

  temp_val = lcs_val[17:37];

  calccrc13[ 0 ]  = ( temp_val[ 4] ^ temp_val[ 6] ^
                             temp_val[ 9] ^ temp_val[14] ^
                            temp_val[19] ) ^ poly_load;
  calccrc13[ 1 ]  = ( temp_val[ 0] ^ temp_val[ 5] ^
                             temp_val[ 7] ^ temp_val[10] ^
                             temp_val[15] ^ temp_val[20] );
  calccrc13[ 2 ]  = ( temp_val[ 1] ^ temp_val[ 6] ^
                             temp_val[ 8] ^ temp_val[11] ^
                             temp_val[16] );
  calccrc13[ 3 ]  = ( temp_val[ 2] ^ temp_val[ 4] ^
                             temp_val[ 6] ^ temp_val[ 7] ^
                             temp_val[12] ^ temp_val[14] ^
                            temp_val[17] ^ temp_val[19] ) ^ poly_load;
  calccrc13[ 4 ]  = ( temp_val[ 3] ^ temp_val[ 5] ^
                             temp_val[ 7] ^ temp_val[ 8] ^
                             temp_val[13] ^ temp_val[15] ^
                             temp_val[18] ^ temp_val[20] );
  calccrc13[ 5 ]  = ( temp_val[ 0] ^ temp_val[ 8] ^
                             temp_val[16] );
  calccrc13[ 6 ]  = ( temp_val[ 1] ^ temp_val[ 9] ^
                             temp_val[17] );
  calccrc13[ 7 ]  = ( temp_val[ 2] ^ temp_val[10] ^
                             temp_val[18] );
  calccrc13[ 8 ]  = ( temp_val[ 3] ^ temp_val[ 4] ^
                             temp_val[ 6] ^ temp_val[ 9] ^
                             temp_val[11] ^ temp_val[14] ) ^ poly_load;
  calccrc13[ 9 ]  = ( temp_val[ 0] ^ temp_val[ 4] ^
                             temp_val[ 5] ^ temp_val[ 7] ^
                             temp_val[10] ^ temp_val[12] ^
                             temp_val[15] );
  calccrc13[ 10 ] = ( temp_val[ 1] ^ temp_val[ 5] ^
                             temp_val[ 6] ^ temp_val[ 8] ^
                             temp_val[11] ^ temp_val[13] ^
                             temp_val[16] ) ^ poly_load;
  calccrc13[ 11 ] = ( temp_val[ 2] ^ temp_val[ 4] ^
                             temp_val[ 7] ^ temp_val[12] ^
                             temp_val[17] ^ temp_val[19] );
  calccrc13[ 12 ] = ( temp_val[ 3] ^ temp_val[ 5] ^
                                       temp_val[ 8] ^ temp_val[13] ^
                                       temp_val[18] ^ temp_val[20] ) ^ poly_load;
 

  cal_crc13 = calccrc13;
endfunction 

endclass


//callback to corrupt the PKT_ACC CS to make LINK_TIMEOUT
class srio_pl_remove_pa_link_timeout_callback1 extends srio_pl_callback;
bit [0:8] tmp0,tmp1,tmp2,tmp3,tmp4,tmp5,tmp6,tmp7,tmp8;
bit [0:12] cal_crc13;
bit [0:37] tmp_crc;
int pkt_size;
srio_pl_agent pl_agent_cb ; 
int cnt;
bit flag,corrupt_flag;
function new (string name = "srio_pl_remove_pa_link_timeout_callback1"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_remove_pa_link_timeout_callback1"; 

virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_trans_transmit(ref srio_pl_data_trans tx_gen,srio_trans srio_trans_in);
if(corrupt_flag == 1)
 begin //{
   if(tx_gen.m_type == MERGED_CS)
    begin //{
         tmp1 =tx_gen.bs_merged_cs[1][1:8] ;
         if(tmp1[1:3] == 0 && flag != 1)
          begin//{
          tx_gen.bs_merged_cs.delete() ;
         end //}
         else if(tmp1[1:3] == 6)
           begin //{
             flag = 1;
           end //}
    end //}
   if(tx_gen.m_type == MERGED_PKT)
    begin //{
          tx_gen.bs_merged_pkt.delete() ;
    end //} 
end //} 
   endtask

endclass


//callback to corrupt the PKT_ACC CS to make LINK_TIMEOUT 
class srio_pl_remove_pa_cs_link_timeout_callback extends srio_pl_callback;
bit [0:8] tmp0,tmp1,tmp2,tmp3,tmp4,tmp5,tmp6,tmp7,tmp8;
bit [0:12] cal_crc13;
bit [0:37] tmp_crc;
int pkt_size;
srio_pl_agent pl_agent_cb ; 
int cnt;
bit flag,corrupt_flag;
function new (string name = "srio_pl_remove_pa_cs_link_timeout_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_remove_pa_cs_link_timeout_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_trans_transmit(ref srio_pl_data_trans tx_gen,srio_trans srio_trans_in);
if(corrupt_flag == 1)
 begin //{
   if(tx_gen.m_type == MERGED_CS)
    begin //{
         tmp1 =tx_gen.bs_merged_cs[1][1:8] ;
         if(tmp1[1:3] == 0 && flag != 1)
          begin//{
          tx_gen.bs_merged_cs.delete() ;
         end //}
         else if(tmp1[1:3] == 6)
           begin //{
             flag = 1;
           end //}
    end //}
/*   if(tx_gen.m_type == MERGED_PKT)
    begin //{
          tx_gen.bs_merged_pkt.delete() ;
    end //} */
end //} 
   endtask

endclass

//callback to corrupt the PKT_ACC CS to make LINK_TIMEOUT User pkt case
class srio_pl_usr_remove_pa_cs_link_timeout_callback extends srio_pl_callback;
bit [0:8] tmp0,tmp1,tmp2,tmp3,tmp4,tmp5,tmp6,tmp7,tmp8;
bit [0:12] cal_crc13;
bit [0:37] tmp_crc;
int pkt_size;
srio_pl_agent pl_agent_cb ; 
int cnt;
bit flag,corrupt_flag;
function new (string name = "srio_pl_usr_remove_pa_cs_link_timeout_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_usr_remove_pa_cs_link_timeout_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_trans_transmit(ref srio_pl_data_trans tx_gen,srio_trans srio_trans_in);
 begin //{
   if(tx_gen.m_type == MERGED_CS)
    begin //{
         tmp1 =tx_gen.bs_merged_cs[1][1:8] ;
        if(tmp1[1:3] == 6 && flag != 1)
           begin //{
             flag = 1;
           end //}
    end //}
end //} 
   endtask

endclass


//=========== callback to detect recieved CS retry,pacc,pnack,link request and link response CS =========
class srio_pl_rcvd_control_symbol_cb extends srio_pl_callback;

bit [31:0] rcvd_retry_cnt;
bit [31:0] rcvd_pnack_cnt;
bit [31:0] rcvd_pacc_cnt;
bit [31:0] rcvd_lreq_cnt;
bit [31:0] rcvd_lresp_cnt;

function new (string name = "srio_pl_rcvd_control_symbol_cb"); 
super.new(name); 
endfunction 

virtual task srio_pl_trans_received(ref srio_trans rx_srio_trans);

if(rx_srio_trans.transaction_kind==SRIO_CS)
 begin
   if((rx_srio_trans.stype0 == 4'h0))
      begin 
         rcvd_pacc_cnt = rcvd_pacc_cnt+1;
      end
   if((rx_srio_trans.stype0 == 4'h1))
      begin 
         rcvd_retry_cnt = rcvd_retry_cnt+1;
      end
   if((rx_srio_trans.stype0 == 4'h2))
      begin 
         rcvd_pnack_cnt = rcvd_pnack_cnt+1;
      end
   if((rx_srio_trans.stype0 == 4'h6))
      begin 
         rcvd_lresp_cnt = rcvd_lresp_cnt+1;
      end
   if((rx_srio_trans.stype1 == 4'h4))
      begin 
         rcvd_lreq_cnt = rcvd_lreq_cnt+1;
      end
     
 end
endtask
endclass

//=========== callback to detect sent CS retry,pacc,pnack,link request and link response CS =========

class srio_pl_sent_control_symbol_cb extends srio_pl_callback;
bit [0:8] tmp0,tmp1,tmp2,tmp3,tmp4,tmp5,tmp6,tmp7,tmp8;
bit [0:12] cal_crc13;
bit [0:37] tmp_crc;
int pkt_size;
srio_pl_agent pl_agent_cb ; 
int cnt;

logic [0:8] cb_mergered_pkt[$];
logic [0:8] cb_mergered_cs[$];
int cb_merged_cs_q_size;
int cb_merged_pkt_q_size;
bit [31:0] sent_retry_cnt;
bit [31:0] sent_pnack_cnt;
bit [31:0] sent_pacc_cnt;
bit [31:0] sent_lreq_cnt;
bit [31:0] sent_lresp_cnt;
int loop_cs_cnt,loop_pkt_cnt;
function new (string name = "srio_pl_sent_control_symbol_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_sent_control_symbol_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_trans_transmit(ref srio_pl_data_trans tx_gen,srio_trans srio_trans_in);
   if(tx_gen.m_type == MERGED_CS)
    begin //{
         cb_merged_cs_q_size = tx_gen.bs_merged_cs.size();
         for(int i = 0;i<cb_merged_cs_q_size;i++)
         begin
         end
         loop_cs_cnt = cb_merged_cs_q_size/4;
         for(int i = 0;i < loop_cs_cnt;i++)
           begin //{
             tmp0 =tx_gen.bs_merged_cs[cb_merged_cs_q_size -(4+(i*4))] ; 
             tmp1 =tx_gen.bs_merged_cs[cb_merged_cs_q_size -(3+(i*4))] ; 
             tmp2 =tx_gen.bs_merged_cs[cb_merged_cs_q_size -(2+(i*4))] ; 
             tmp3 =tx_gen.bs_merged_cs[cb_merged_cs_q_size -(1+(i*4))] ; 
             if(tmp0 == 9'h11C)
               begin //{
                 if(tmp1[1:3] == 0)
                begin //{
                  sent_pacc_cnt =  sent_pacc_cnt + 1;
                end //}
                else if(tmp1[1:3] == 1)
                begin //{
                  sent_retry_cnt =  sent_retry_cnt + 1;
                end //}
                else if(tmp1[1:3] == 2)
                begin //{
                  sent_pnack_cnt =  sent_pnack_cnt + 1;
                end //}
                else if(tmp1[1:3] == 6)
                begin //{
                  sent_lresp_cnt =  sent_lresp_cnt + 1;
                end //}
                else if({tmp2[8],tmp3[3]} == 4)
                begin //{
                  sent_lreq_cnt =  sent_lreq_cnt + 1;
                end //}
              end //}
         end //}
     end //}

   else if(tx_gen.m_type == MERGED_PKT)
    begin //{
         cb_merged_pkt_q_size = tx_gen.bs_merged_pkt.size();
         loop_pkt_cnt = cb_merged_pkt_q_size/4;
         for(int i = 0;i < loop_pkt_cnt;i++)
           begin //{
             tmp4 =tx_gen.bs_merged_pkt[cb_merged_pkt_q_size -(4+(i*4))] ; 
             tmp5 =tx_gen.bs_merged_pkt[cb_merged_pkt_q_size -(3+(i*4))] ; 
             tmp6 =tx_gen.bs_merged_pkt[cb_merged_pkt_q_size -(2+(i*4))] ; 
             tmp7 =tx_gen.bs_merged_pkt[cb_merged_pkt_q_size -(1+(i*4))] ; 
             if(tmp4 == 9'h11C)
               begin //{
                 if(tmp5[1:3] == 0)
                begin //{
                  sent_pacc_cnt =  sent_pacc_cnt + 1;
                end //}
                else if(tmp5[1:3] == 1)
                begin //{
                  sent_retry_cnt =  sent_retry_cnt + 1;
                end //}
                else if(tmp5[1:3] == 2)
                begin //{
                  sent_pnack_cnt =  sent_pnack_cnt + 1;
                end //}
                else if(tmp5[1:3] == 6)
                begin //{
                  sent_lresp_cnt =  sent_lresp_cnt + 1;
                end //}
                else if({tmp6[8],tmp7[3]} == 4)
                begin //{
                  sent_lreq_cnt =  sent_lreq_cnt + 1;
                end //}
              end //}
          end //}

     end //}
   endtask
endclass


//============== callback to corrupt EOP to STOMP for GEN1 =========
class srio_pl_gen1_transmit_eop_to_stomp_cs_cb extends srio_pl_callback;
int pkt_size;
bit [0:8] tmp0,tmp1,tmp2,tmp3,tmp4,tmp5,tmp6,tmp7,tmp8;
bit flag1,flag2,flag3;
int cnt;

bit [0:4] cal_crc5;
bit [0:12] cal_crc13;
bit [0:23] cal_crc24;
bit [0:37] tmp_crc;
rand bit [3:0] cnt_rand;
bit rand_bit = 1;
bit [3:0] a,b,c;

function new (string name = "srio_pl_gen1_transmit_eop_to_stomp_cs_cb"); 
super.new(name); 
endfunction 

 virtual task srio_pl_trans_transmit(ref srio_pl_data_trans tx_gen,srio_trans srio_trans_in);
   if(rand_bit == 1)
     begin
       cnt_rand = $urandom_range(1,6);
       a = cnt_rand;
       cnt_rand = $urandom_range(1,6);
       b = cnt_rand;
       cnt_rand = $urandom_range(1,6);
       c = cnt_rand;
       rand_bit = 0;
     end
   
   if(tx_gen.m_type == MERGED_PKT)
    begin //{
       pkt_size = tx_gen.bs_merged_pkt.size() ; 
       tmp0 =tx_gen.bs_merged_pkt[pkt_size -4] ;
       tmp1 =tx_gen.bs_merged_pkt[pkt_size -3] ;
       tmp2 =tx_gen.bs_merged_pkt[pkt_size -2] ;
       tmp3 =tx_gen.bs_merged_pkt[pkt_size -1] ;
       if(tmp0 == 9'h17C)
         begin
           if((tmp1[1:3] == 4) && (tmp2[6:8] == 2) && (flag1 == 0 | flag2 == 0 | flag3 == 0))
             begin
               cnt = cnt+1;
                if(cnt == a | cnt == b | cnt == c)
                 begin 
                  tx_gen.bs_merged_pkt[pkt_size -2][6:8] = 3'b001;
                  tmp_crc = {1'b0,tx_gen.bs_merged_pkt[pkt_size -3][1:3],1'b0,tx_gen.bs_merged_pkt[pkt_size -3][4:8],1'b0,tx_gen.bs_merged_pkt[pkt_size -2][1:8],tx_gen.bs_merged_pkt[pkt_size -1][1:3]};
                  void'(calccrc5(tmp_crc));
                   tx_gen.bs_merged_pkt[pkt_size -1][4:8] = cal_crc5;
                  if(cnt == a)
                  flag1 = 1;
                  if(cnt == b)
                  flag2 = 1;
                  if(cnt == c)
                  flag3 = 1;
                 end
              end
           end
end //}
endtask
function logic [0:4] calccrc5(logic [0:37] scs_val);

  logic [0:20] temp_val;

  temp_val = scs_val[17:37];

  calccrc5[0] = ( temp_val[ 0] ^ temp_val[ 1] ^
                           temp_val[ 4] ^ temp_val[ 5] ^
                           temp_val[ 6] ^ temp_val[12] ^
                           temp_val[14] ^ temp_val[17] ^
                           temp_val[18] ^ temp_val[20] );

  calccrc5[1] = ( temp_val[ 0] ^ temp_val[ 2] ^
                           temp_val[ 4] ^ temp_val[ 7] ^
                           temp_val[12] ^ temp_val[13] ^
                           temp_val[14] ^ temp_val[15] ^
                           temp_val[17] ^ temp_val[19] ^
                           ~temp_val[20]  );

  calccrc5[2] = ( temp_val[ 1] ^ temp_val[ 4] ^
                           temp_val[ 5] ^ temp_val[ 8] ^
                           temp_val[13] ^ temp_val[14] ^
                           temp_val[15] ^ temp_val[16] ^
                           temp_val[18] ^ ~temp_val[20]);

  calccrc5[3] = ( temp_val[ 1] ^ temp_val[ 2] ^
                           temp_val[ 4] ^ temp_val[10] ^
                           temp_val[12] ^ temp_val[15] ^
                           temp_val[16] ^ temp_val[18] ^
                           temp_val[19] ^ ~temp_val[20]);

  calccrc5[4] = ( temp_val[ 0] ^ temp_val[ 2] ^
                             temp_val[ 4] ^ temp_val[ 5] ^
                             temp_val[11] ^ temp_val[13] ^
                             temp_val[16] ^ temp_val[17] ^
                             temp_val[19] ^ temp_val[20] );

  cal_crc5 = calccrc5;

endfunction : calccrc5

endclass

//============== callback to corrupt EOP to STOMP for GEN3 =========
class srio_pl_gen3_transmit_eop_to_stomp_cs_cb extends srio_pl_callback;
int pkt_size;
bit [0:65] tmp0,tmp1,tmp2,tmp3,tmp4,tmp5,tmp6,tmp7,tmp8;
bit flag1,flag2,flag3;
int cnt;

bit [0:4] cal_crc5;
bit [0:12] cal_crc13;
bit [0:23] cal_crc24;
bit [0:37] tmp_crc;
rand bit [3:0] cnt_rand;
bit rand_bit = 1;
bit [3:0] a,b,c;

function new (string name = "srio_pl_gen3_transmit_eop_to_stomp_cs_cb"); 
super.new(name); 
endfunction 

 virtual task srio_pl_trans_transmit(ref srio_pl_data_trans tx_gen,srio_trans srio_trans_in);
   if(rand_bit == 1)
     begin
       cnt_rand = $urandom_range(1,6);
       a = cnt_rand;
       cnt_rand = $urandom_range(1,6);
       b = cnt_rand;
       cnt_rand = $urandom_range(1,6);
       c = cnt_rand;
       rand_bit = 0;
     end

   if(tx_gen.m_type == MERGED_PKT)
    begin //{
       pkt_size = tx_gen.brc3_merged_pkt.size() ; 
       tmp0 =tx_gen.brc3_merged_pkt[pkt_size -2] ;
       tmp1 =tx_gen.brc3_merged_pkt[pkt_size -1] ;
       
      if(tmp0[32:33] == 2'b01 && tmp1[32:33] == 2'b10)
         begin
           if((flag1 == 0 | flag2 == 0 | flag3 == 0))
             begin
               cnt = cnt+1;
               if(cnt == a | cnt == b | cnt == c)
                 begin
                   if(tmp1[2:4] == 3'b010) 
                      begin
                        tx_gen.brc3_merged_pkt[pkt_size -1][2:4] = 3'b001;
                        tmp_crc={tx_gen.brc3_merged_pkt[pkt_size -2][2:31],2'b00,tx_gen.brc3_merged_pkt[pkt_size -1][2:7]};                        
                        void'(calccrc24(tmp_crc));
                         tx_gen.brc3_merged_pkt[pkt_size -1][8:31] = cal_crc24;
                        if(cnt == a)
                        flag1 = 1;
                        if(cnt == b)
                        flag2 = 1;
                        if(cnt == c)
                        flag3 = 1;
                      end
                 end
              end
           end
end //}
endtask
function logic [0:23] calccrc24(logic [0:37] scs_val);
  logic [0:37] temp_val;

  temp_val = scs_val;

      calccrc24[0] = temp_val[36] ^ temp_val[33] ^ temp_val[29] ^ temp_val[28] ^ temp_val[27] ^ temp_val[25] ^ temp_val[24] ^ temp_val[17] ^ temp_val[15] ^ temp_val[14] ^ temp_val[12] ^ temp_val[11] ^ temp_val[10] ^ temp_val[9]  ^ temp_val[4] ^ temp_val[2] ^ temp_val[0];

      calccrc24[1] = temp_val[37] ^ temp_val[34] ^ temp_val[30] ^ temp_val[29] ^ temp_val[28] ^ temp_val[26] ^ temp_val[25] ^ temp_val[18] ^ temp_val[16] ^ temp_val[15] ^ temp_val[13] ^ temp_val[12] ^ temp_val[11] ^ temp_val[10] ^ temp_val[5] ^ temp_val[3] ^ temp_val[1];

      calccrc24[2] = temp_val[36] ^ temp_val[35] ^ temp_val[33] ^ temp_val[31] ^ temp_val[30] ^ temp_val[28] ^ temp_val[26] ^ temp_val[25] ^ temp_val[24] ^ temp_val[19] ^ temp_val[16] ^ temp_val[15] ^ temp_val[13] ^ temp_val[10] ^ temp_val[9] ^ temp_val[6] ^ temp_val[0];

      calccrc24[3] = !temp_val[37] ^ temp_val[36] ^ temp_val[34] ^ temp_val[32] ^ temp_val[31] ^ temp_val[29] ^ temp_val[27] ^ temp_val[26] ^ temp_val[25] ^ temp_val[20] ^ temp_val[17] ^ temp_val[16] ^ temp_val[14] ^ temp_val[11] ^ temp_val[10] ^ temp_val[7] ^ temp_val[1] ^ temp_val[0];

      calccrc24[4] = !temp_val[37] ^ temp_val[36] ^ temp_val[35] ^ temp_val[32] ^ temp_val[30] ^ temp_val[29] ^ temp_val[26] ^ temp_val[25] ^ temp_val[24] ^ temp_val[21] ^ temp_val[18] ^ temp_val[14] ^ temp_val[10] ^ temp_val[9] ^ temp_val[8] ^ temp_val[4] ^ temp_val[1] ^ temp_val[0];

      calccrc24[5] = !temp_val[37] ^ temp_val[31] ^ temp_val[30] ^ temp_val[29] ^ temp_val[28] ^ temp_val[26] ^ temp_val[24] ^ temp_val[22] ^ temp_val[19] ^ temp_val[17] ^ temp_val[14] ^ temp_val[12] ^ temp_val[5] ^ temp_val[4] ^ temp_val[1] ^ temp_val[0];

      calccrc24[6] = !temp_val[36] ^ temp_val[33] ^ temp_val[32] ^ temp_val[31] ^ temp_val[30] ^ temp_val[28] ^ temp_val[24] ^ temp_val[23] ^ temp_val[20] ^ temp_val[18] ^ temp_val[17] ^ temp_val[14] ^ temp_val[13] ^ temp_val[12] ^ temp_val[11] ^ temp_val[10] ^ temp_val[9] ^ temp_val[6] ^ temp_val[5] ^ temp_val[4] ^ temp_val[1] ^ temp_val[0];

      calccrc24[7] = temp_val[37] ^ temp_val[34] ^ temp_val[33] ^ temp_val[32] ^ temp_val[31] ^ temp_val[29] ^ temp_val[25] ^ temp_val[24] ^ temp_val[21] ^ temp_val[19] ^ temp_val[18] ^ temp_val[15] ^ temp_val[14] ^ temp_val[13] ^ temp_val[12] ^ temp_val[11] ^ temp_val[10] ^ temp_val[7] ^ temp_val[6] ^ temp_val[5] ^ temp_val[2] ^ temp_val[1];

      calccrc24[8] = !temp_val[36] ^ temp_val[35] ^ temp_val[34] ^ temp_val[32] ^ temp_val[30] ^ temp_val[29] ^ temp_val[28] ^ temp_val[27] ^ temp_val[26] ^ temp_val[24] ^ temp_val[22] ^ temp_val[20] ^ temp_val[19] ^ temp_val[17] ^ temp_val[16] ^ temp_val[13] ^ temp_val[10] ^ temp_val[9] ^ temp_val[8] ^ temp_val[7] ^ temp_val[6] ^ temp_val[4] ^ temp_val[3];

      calccrc24[9] = !temp_val[37] ^ temp_val[36] ^ temp_val[35] ^ temp_val[33] ^ temp_val[31] ^ temp_val[30] ^ temp_val[29] ^ temp_val[28] ^ temp_val[27] ^ temp_val[25] ^ temp_val[23] ^ temp_val[21] ^ temp_val[20] ^ temp_val[18] ^ temp_val[17] ^ temp_val[14] ^ temp_val[11] ^ temp_val[10] ^ temp_val[9] ^ temp_val[8] ^ temp_val[7] ^ temp_val[5] ^ temp_val[4];

      calccrc24[10] = temp_val[37] ^ temp_val[34] ^ temp_val[33] ^ temp_val[32] ^ temp_val[31] ^ temp_val[30] ^ temp_val[27] ^ temp_val[26] ^ temp_val[25] ^ temp_val[22] ^ temp_val[21] ^ temp_val[19] ^ temp_val[18] ^ temp_val[17] ^ temp_val[14] ^ temp_val[8] ^ temp_val[6] ^ temp_val[5] ^ temp_val[4] ^ temp_val[2] ^ temp_val[0];

      calccrc24[11] = temp_val[36] ^ temp_val[35] ^ temp_val[34] ^ temp_val[32] ^ temp_val[31] ^ temp_val[29] ^ temp_val[26] ^ temp_val[25] ^ temp_val[24] ^ temp_val[23] ^ temp_val[22] ^ temp_val[20] ^ temp_val[19] ^ temp_val[18] ^ temp_val[17] ^ temp_val[14] ^ temp_val[12] ^ temp_val[11] ^ temp_val[10] ^ temp_val[7] ^ temp_val[6] ^ temp_val[5] ^ temp_val[4] ^ temp_val[3] ^ temp_val[2] ^ temp_val[1] ^ temp_val[0];

      calccrc24[12] = temp_val[37] ^ temp_val[36] ^ temp_val[35] ^ temp_val[33] ^ temp_val[32] ^ temp_val[30] ^ temp_val[27] ^ temp_val[26] ^ temp_val[25] ^ temp_val[24] ^ temp_val[23] ^ temp_val[21] ^ temp_val[20] ^ temp_val[19] ^ temp_val[18] ^ temp_val[15] ^ temp_val[13] ^ temp_val[12] ^ temp_val[11] ^ temp_val[8] ^ temp_val[7] ^ temp_val[6] ^ temp_val[5] ^ temp_val[4] ^ temp_val[3] ^ temp_val[2] ^ temp_val[1] ^ temp_val[0];

      calccrc24[13] = !temp_val[37] ^ temp_val[34] ^ temp_val[31] ^ temp_val[29] ^ temp_val[26] ^ temp_val[22] ^ temp_val[21] ^ temp_val[20] ^ temp_val[19] ^ temp_val[17] ^ temp_val[16] ^ temp_val[15] ^ temp_val[13] ^ temp_val[11] ^ temp_val[10] ^ temp_val[8] ^ temp_val[7] ^ temp_val[6] ^ temp_val[5] ^ temp_val[3] ^ temp_val[1] ^ temp_val[0];

      calccrc24[14] = temp_val[36] ^ temp_val[35] ^ temp_val[33] ^ temp_val[32] ^ temp_val[30] ^ temp_val[29] ^ temp_val[28] ^ temp_val[25] ^ temp_val[24] ^ temp_val[23] ^ temp_val[22] ^ temp_val[21] ^ temp_val[20] ^ temp_val[18] ^ temp_val[16] ^ temp_val[15] ^ temp_val[10] ^ temp_val[8] ^ temp_val[7] ^ temp_val[6] ^ temp_val[1];

      calccrc24[15] = !temp_val[37] ^ temp_val[36] ^ temp_val[34] ^ temp_val[33] ^ temp_val[31] ^ temp_val[30] ^ temp_val[29] ^ temp_val[26] ^ temp_val[25] ^ temp_val[24] ^ temp_val[23] ^ temp_val[22] ^ temp_val[21] ^ temp_val[19] ^ temp_val[17] ^ temp_val[16] ^ temp_val[11] ^ temp_val[9] ^ temp_val[8] ^ temp_val[7] ^ temp_val[2];

      calccrc24[16] = temp_val[37] ^ temp_val[36] ^ temp_val[35] ^ temp_val[34] ^ temp_val[33] ^ temp_val[32] ^ temp_val[31] ^ temp_val[30] ^ temp_val[29] ^ temp_val[28] ^ temp_val[26] ^ temp_val[23] ^ temp_val[22] ^ temp_val[20] ^ temp_val[18] ^ temp_val[15] ^ temp_val[14] ^ temp_val[11] ^ temp_val[8] ^ temp_val[4] ^ temp_val[3] ^ temp_val[2] ^ temp_val[0];

      calccrc24[17] = !temp_val[37] ^ temp_val[35] ^ temp_val[34] ^ temp_val[32] ^ temp_val[31] ^ temp_val[30] ^ temp_val[28] ^ temp_val[25] ^ temp_val[23] ^ temp_val[21] ^ temp_val[19] ^ temp_val[17] ^ temp_val[16] ^ temp_val[14] ^ temp_val[11] ^ temp_val[10] ^ temp_val[5] ^ temp_val[3] ^ temp_val[2] ^ temp_val[1] ^ temp_val[0];

      calccrc24[18] = !temp_val[35] ^ temp_val[32] ^ temp_val[31] ^ temp_val[28] ^ temp_val[27] ^ temp_val[26] ^ temp_val[25] ^ temp_val[22] ^ temp_val[20] ^ temp_val[18] ^ temp_val[14] ^ temp_val[10] ^ temp_val[9] ^ temp_val[6] ^ temp_val[3] ^ temp_val[1];

      calccrc24[19] = !temp_val[36] ^ temp_val[33] ^ temp_val[32] ^ temp_val[29] ^ temp_val[28]  ^ temp_val[27] ^ temp_val[26] ^ temp_val[23] ^ temp_val[21]  ^ temp_val[19] ^ temp_val[15] ^ temp_val[11] ^ temp_val[10] ^ temp_val[7]  ^ temp_val[4] ^ temp_val[2];

      calccrc24[20] = !temp_val[37] ^ temp_val[34] ^ temp_val[33] ^ temp_val[30] ^ temp_val[29] ^ temp_val[28]  ^ temp_val[27] ^ temp_val[24] ^ temp_val[22] ^ temp_val[20] ^ temp_val[16] ^ temp_val[12] ^ temp_val[11] ^ temp_val[8] ^ temp_val[5]  ^ temp_val[3] ^ temp_val[0];

      calccrc24[21] = !temp_val[36] ^ temp_val[35] ^ temp_val[34] ^ temp_val[33] ^ temp_val[31] ^ temp_val[30] ^ temp_val[27] ^ temp_val[24] ^ temp_val[23] ^ temp_val[21]   ^ temp_val[15] ^ temp_val[14] ^ temp_val[13] ^ temp_val[11] ^ temp_val[10] ^ temp_val[6] ^ temp_val[2] ^ temp_val[1] ^ temp_val[0]; 

      calccrc24[22] = !temp_val[37] ^ temp_val[36] ^ temp_val[35] ^ temp_val[34]  ^ temp_val[32]  ^ temp_val[31]  ^ temp_val[28]  ^ temp_val[25] ^ temp_val[24] ^ temp_val[22]  ^ temp_val[16]  ^ temp_val[15] ^ temp_val[14]  ^ temp_val[12] ^ temp_val[11]  ^ temp_val[7]  ^ temp_val[3]  ^ temp_val[2] ^ temp_val[1] ^ temp_val[0];  

      calccrc24[23] = temp_val[37] ^ temp_val[35]  ^ temp_val[32] ^ temp_val[28]  ^ temp_val[27] ^ temp_val[26]  ^ temp_val[24] ^ temp_val[23] ^ temp_val[16] ^ temp_val[14] ^ temp_val[13] ^ temp_val[11] ^ temp_val[10] ^ ^ temp_val[9] ^ temp_val[8] ^ temp_val[3] ^ temp_val[1];

   cal_crc24 = calccrc24;

endfunction : calccrc24

endclass

//IDLE 2 CORRUPTION -- data and control word corruption in lanes

class srio_pl_data_cntl_corrupt_callback extends srio_pl_callback;
int data_detected;
bit [0:65] tmp0;
bit  flag,corrupt_cnt;
bit [0:8] temp;
function new (string name = "srio_pl_data_cntl_corrupt_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_data_cntl_corrupt_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_char_transmitted_lane0(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
// if (env_config.pl_tx_mon_init_sm_state == X2_MODE  && env_config.pl_rx_mon_init_sm_state == X2_MODE)  begin //{
  if(flag == 0 ) begin //{
  tmp0= idle_field_char;
  temp = tmp0[57:65];
 
      if(temp == 9'h000)   begin //{
      data_detected = 1;
      end //}
  end //}
  end //}   
   endtask

 virtual task srio_pl_char_transmitted_lane1(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
// if (env_config.pl_tx_mon_init_sm_state == X2_MODE  && env_config.pl_rx_mon_init_sm_state == X2_MODE)  begin //{
  if(data_detected == 1 ) begin //{
    idle_field_char = 9'h13C; 
    flag = 1;
    data_detected = 0;
    end //}
   end //}
 endtask

endclass

//IDLE 2 CORRUPTION -- KRRR insertion in idle2 sequence

class srio_pl_krrr_insertion_idle2_sequence_corrupt_callback extends srio_pl_callback;
int m_detect0,m_detect1,m_detect2,m_detect3;
bit [0:65] tmp0,tmp1,tmp2,tmp3;
bit [1:0] flag0,flag1,flag2,flag3 ;
bit corrupt_cnt0,corrupt_cnt1,corrupt_cnt2,corrupt_cnt3;
bit [0:8] temp0,temp1,temp2,temp3;
int cnt0,cnt1,cnt2,cnt3;
rand bit [0:6]  cnt_rand;
rand bit mode;
int corrupt_count0,corrupt_count1,corrupt_count2,corrupt_count3;
function new (string name = "srio_pl_krrr_insertion_idle2_sequence_corrupt_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_krrr_insertion_idle2_sequence_corrupt_callback"; 


virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_char_transmitted_lane0(ref bit [0:65] idle_field_char,srio_env_config env_config);
//if ((env_config.pl_rx_mon_init_sm_state == NX_MODE) && (env_config.pl_tx_mon_init_sm_state == NX_MODE))  begin //{
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
     if(flag0 == 0 ) begin //{
       tmp0= idle_field_char;
       temp0 = tmp0[57:65];
       if(temp0 == 9'h13C)   begin //{
         m_detect0++;
         end //}
       if((m_detect0) &&!(temp0 == 9'h13C)) begin //{
         m_detect0 = 0;
         end //}
       if(m_detect0 == 4) begin //{
          corrupt_cnt0 =1;
          flag0 = flag0+1;
          mode = $urandom;
          if(mode)
          cnt_rand = $urandom_range(5,10);
         end //}

   end //}
    else if(corrupt_cnt0 == 1)
       begin 
         cnt0 = cnt0+1;
           if(cnt0 == 33+cnt_rand)
             begin
             idle_field_char = 9'h1bc;  
             end     
           if(cnt0 == 34+cnt_rand)
             begin
             idle_field_char = 9'h1FD;  
             end  
           if(cnt0 == 35+cnt_rand)
             begin
             idle_field_char = 9'h1FD;  
             end  
           if(cnt0 == 36+cnt_rand)
             begin
             idle_field_char = 9'h1FD;  
             corrupt_cnt0 = 0;
             cnt0 = 0;
             corrupt_count0 = corrupt_count0+1;
             if(corrupt_count0 != 10)
               begin
                flag0 = 0;
               end
             end  
         end     
 end //} 
endtask

 virtual task srio_pl_char_transmitted_lane1(ref bit [0:65] idle_field_char,srio_env_config env_config);
//if ((env_config.pl_rx_mon_init_sm_state == NX_MODE) && (env_config.pl_tx_mon_init_sm_state == NX_MODE))  begin //{
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
     if(flag1 == 0 ) begin //{
       tmp1= idle_field_char;
       temp1 = tmp1[57:65];
       if(temp1 == 9'h13C)   begin //{
         m_detect1++;
         end //}
       if((m_detect1) &&!(temp1 == 9'h13C)) begin //{
         m_detect1 = 0;
         end //}
       if(m_detect1 == 4) begin //{
          corrupt_cnt1 =1;
          flag1 = flag1+1;
         end //}

   end //}
    else if(corrupt_cnt1 == 1)
       begin 
         cnt1 = cnt1+1;
           if(cnt1 == 33+cnt_rand)
             begin
             idle_field_char = 9'h1bc;  
             end     
           if(cnt1 == 34+cnt_rand)
             begin
             idle_field_char = 9'h1FD;  
             end  
           if(cnt1 == 35+cnt_rand)
             begin
             idle_field_char = 9'h1FD;  
             end  
           if(cnt1 == 36+cnt_rand)
             begin
             idle_field_char = 9'h1FD;  
             corrupt_cnt1 = 0;
             cnt1 = 0;
             corrupt_count1 = corrupt_count1+1;
             if(corrupt_count1 != 10)
               begin
                flag1 = 0;
               end
             end  
         end     
 end //} 
endtask
 virtual task srio_pl_char_transmitted_lane2(ref bit [0:65] idle_field_char,srio_env_config env_config);
//if ((env_config.pl_rx_mon_init_sm_state == NX_MODE) && (env_config.pl_tx_mon_init_sm_state == NX_MODE))  begin //{
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
     if(flag2 == 0 ) begin //{
       tmp2= idle_field_char;
       temp2 = tmp2[57:65];
       if(temp2 == 9'h13C)   begin //{
         m_detect2++;
         end //}
       if((m_detect2) &&!(temp2 == 9'h13C)) begin //{
         m_detect2 = 0;
         end //}
       if(m_detect2 == 4) begin //{
          corrupt_cnt2 =1;
          flag2 = flag2+1;
         end //}

   end //}
    else if(corrupt_cnt2 == 1)
       begin 
         cnt2 = cnt2+1;
           if(cnt2 == 33+cnt_rand)
             begin
             idle_field_char = 9'h1bc;  
             end     
           if(cnt2 == 34+cnt_rand)
             begin
             idle_field_char = 9'h1FD;  
             end  
           if(cnt2 == 35+cnt_rand)
             begin
             idle_field_char = 9'h1FD;  
             end  
           if(cnt2 == 36+cnt_rand)
             begin
             idle_field_char = 9'h1FD;  
             cnt2 = 0;
             corrupt_cnt2 = 0;
             corrupt_count2 = corrupt_count2+1;
             if(corrupt_count2 != 10)
               begin
                flag2 = 0;
               end
             end  
         end     
 end //} 
endtask

 virtual task srio_pl_char_transmitted_lane3(ref bit [0:65] idle_field_char,srio_env_config env_config);
//if ((env_config.pl_rx_mon_init_sm_state == NX_MODE) && (env_config.pl_tx_mon_init_sm_state == NX_MODE))  begin //{
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
     if(flag3 == 0 ) begin //{
       tmp3= idle_field_char;
       temp3 = tmp3[57:65];
       if(temp3 == 9'h13C)   begin //{
         m_detect3++;
         end //}
       if((m_detect3) &&!(temp3 == 9'h13C)) begin //{
         m_detect3 = 0;
         end //}
       if(m_detect3 == 4) begin //{
          corrupt_cnt3 =1;
          flag3 = flag3+1;
         end //}

   end //}
    else if(corrupt_cnt3 == 1)
       begin 
         cnt3 = cnt3+1;
           if(cnt3 == 33+cnt_rand)
             begin
             idle_field_char = 9'h1bc;  
             end     
           if(cnt3 == 34+cnt_rand)
             begin
             idle_field_char = 9'h1FD;  
             end  
           if(cnt3 == 35+cnt_rand)
             begin
             idle_field_char = 9'h1FD;  
             end  
           if(cnt3 == 36+cnt_rand)
             begin
             idle_field_char = 9'h1FD;  
             cnt3 = 0;
             corrupt_cnt3 = 0;
             corrupt_count3 = corrupt_count3+1;
             if(corrupt_count3 != 10)
               begin
                flag3 = 0;
               end
             end  
         end     
 end //} 
endtask

endclass

//PACKET CRC CORRUPTION

class srio_pl_pkt_crc_corrupt_callback extends srio_pl_callback;
int pkt_size;
bit [0:8] tmp7;
bit flag;
function new (string name = "srio_pl_pkt_crc_corrupt_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_pkt_crc_corrupt_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_trans_transmit(ref srio_pl_data_trans tx_gen,srio_trans srio_trans_in);
   if(tx_gen.m_type == MERGED_PKT && flag == 0)
    begin //{
       pkt_size = tx_gen.bs_merged_pkt.size() ;
       tx_gen.bs_merged_pkt[80] = 9'h100;
       flag = 1;
    end //}
endtask

endclass

//============== callback to corrupt CS CRC =========
class srio_pl_transmit_cs_crc_cb extends srio_pl_callback;
int pkt_size;
bit [0:8] tmp0,tmp1,tmp2,tmp3,tmp4,tmp5,tmp6,tmp7,tmp8;
bit flag;
int cnt,num_of_merged_cs;
function new (string name = "srio_pl_transmit_cs_crc_cb"); 
super.new(name); 
endfunction 

 virtual task srio_pl_trans_transmit(ref srio_pl_data_trans tx_gen,srio_trans srio_trans_in);
   if(tx_gen.m_type == MERGED_CS)
    begin //{
       pkt_size = tx_gen.bs_merged_cs.size() ;
       tmp0 =tx_gen.bs_merged_cs[pkt_size -8] ;
       tmp1 =tx_gen.bs_merged_cs[pkt_size -7] ;
       tmp2 =tx_gen.bs_merged_cs[pkt_size -6] ;
       tmp3 =tx_gen.bs_merged_cs[pkt_size -5] ;
       tmp4 =tx_gen.bs_merged_cs[pkt_size -4] ;
       tmp5 =tx_gen.bs_merged_cs[pkt_size -3] ;
       tmp6 =tx_gen.bs_merged_cs[pkt_size -2] ;
       tmp7 =tx_gen.bs_merged_cs[pkt_size -1] ;
       if(tmp0 == 9'h11C)
         begin //{
           if(flag == 0)
             begin //{
                   tx_gen.bs_merged_cs[pkt_size -3][4:8] = 'h5;
                   tx_gen.bs_merged_cs[pkt_size -2][1:8] = 'hf;
                  flag = 1;
                 end //}
              end //}
end //}
endtask
endclass

//GEN3 pkt crc corruption
class srio_pl_gen3_pkt_crc_cb extends srio_pl_callback;
int pkt_size;
bit [0:65] tmp0,tmp1,tmp2,tmp3,tmp4,tmp5,tmp6,tmp7,tmp8;
bit flag1,flag2,flag3;


function new (string name = "srio_pl_gen3_pkt_crc_cb"); 
super.new(name); 
endfunction 

 virtual task srio_pl_trans_transmit(ref srio_pl_data_trans tx_gen,srio_trans srio_trans_in);
   if(tx_gen.m_type == MERGED_PKT)
    begin //{
       pkt_size = tx_gen.brc3_merged_pkt.size() ; 
       tmp0 =tx_gen.brc3_merged_pkt[0] ;
       tmp1 =tx_gen.brc3_merged_pkt[1] ;
       tmp2 =tx_gen.brc3_merged_pkt[2] ;
       if(flag1 == 0)
         begin
           if(tmp0[32:33] == 2'b01 && tmp1[32:33] == 2'b10)
              begin
                if(tmp2[0:1] == 2'b01)
                    begin
                      tx_gen.brc3_merged_pkt[2][5] = ! tx_gen.brc3_merged_pkt[2][5];
                      flag1 = 1;
                     end
              end
          end
end //}
endtask
endclass

// Final with multi point callback 
//IDLE 2 CORRUPTION --idle2 with control status signal 

class srio_pl_idle2_multi_cs_krrr_corrupt_callback extends srio_pl_callback;
int m_detect_cnt0,m_detect_cnt1,m_detect_cnt2,m_detect_cnt3;
bit [0:65] tmp0,tmp1,tmp2,tmp3;
bit [1:0] flag = 1;
bit corrupt_cnt;
bit b5_cnt0,b5_cnt1,b5_cnt2,b5_cnt3;
bit [0:8] temp0,temp1,temp2,temp3;
bit [3:0] cs_field_count;
bit b5_detect0,b5_detect1,b5_detect2,b5_detect3;
bit m_detect0,m_detect1,m_detect2,m_detect3;
bit [5:0] cg_cnt0,cg_cnt1,cg_cnt2,cg_cnt3;
int idle_cnt0,idle_cnt1;

function new (string name = "srio_pl_idle2_multi_cs_krrr_corrupt_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_idle2_multi_cs_krrr_corrupt_callback"; 


virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_char_transmitted_lane0(ref bit [0:65] idle_field_char,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
 // if (env_config.pl_tx_mon_init_sm_state == X2_MODE  && env_config.pl_rx_mon_init_sm_state == X2_MODE)  begin //{
     if(flag != 0 ) begin //{
       tmp0= idle_field_char;
       temp0 = tmp0[57:65];
       if((m_detect0==0) && (temp0 == 9'h13C))   begin //{
         m_detect_cnt0++;
         end //}
       if((m_detect0 == 0)&&(m_detect_cnt0) && (temp0 != 9'h13C)) begin //{
         m_detect0 = 0;
         m_detect_cnt0 = 0;
         end //}
       else if(m_detect_cnt0 == 4) begin //{
          m_detect0 =1;
          m_detect_cnt0 = 0;
         end //}
          if((temp0 == 9'h0b5) && (m_detect0 == 1) && (b5_cnt0 == 0))
          begin //{
             b5_detect0 = 1;
             b5_cnt0++;
           end //}
     else  if((m_detect0) && (b5_detect0))  begin //{

       if((b5_detect0) && (m_detect0)) begin //{
          cg_cnt0 = cg_cnt0+1;
          if(cg_cnt0 == 36) begin //{
            b5_detect0 = 0;
            m_detect0 = 0;
            cg_cnt0 = 0;
            b5_cnt0 = 0;
            idle_cnt0 = idle_cnt0+1; //pravin
           end //}
          else if((cg_cnt0>= 0 &&cg_cnt0 <= (3+idle_cnt0) )) begin //{
            idle_field_char = idle_field_char;
          end //}
          else if((cg_cnt0==(4+idle_cnt0))&& (cg_cnt0 <= 32)) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h11c;
          end //}
          else if((cg_cnt0==(5+idle_cnt0))&& (cg_cnt0 <= 33)) begin //{
            env_config.scramble_dis= 0;
            idle_field_char = 9'h07F;
          end //}
          else if((cg_cnt0==(6+idle_cnt0))&& (cg_cnt0 <= 34)) begin //{
            env_config.scramble_dis= 0;
            idle_field_char = 9'h000;
          end //}
          else if((cg_cnt0==(7+idle_cnt0))&& (cg_cnt0 <= 35)) begin //{
            env_config.scramble_dis= 0;
            idle_field_char = 9'h035;
          end //}
          else if((cg_cnt0==(8+idle_cnt0))&& (cg_cnt0 <= 32)) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h1BC;
          end //}
          else if(cg_cnt0==(9+idle_cnt0)&& (cg_cnt0 <= 33)) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h1FD;
          end //}
          else if(cg_cnt0==(10+idle_cnt0)&& (cg_cnt0 <= 34)) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h1FD;
          end //}
          else if(cg_cnt0==(11+idle_cnt0)&& (cg_cnt0 <= 35)) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h1FD;
          end //}
          else if(cg_cnt0==(12+idle_cnt0)) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h13C;
          end //}
          else if((cg_cnt0>=(13+idle_cnt0) && cg_cnt0 <= (28+idle_cnt0))) begin //{
            env_config.scramble_dis= 0;
            idle_field_char = 9'h000;
          end //}
          else if((cg_cnt0==(29+idle_cnt0))) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h1FB;
          end //}
          else if((cg_cnt0>=(30+idle_cnt0) && cg_cnt0 <= (35+idle_cnt0))) begin //{
            env_config.scramble_dis= 0;
            idle_field_char = 9'h000;
          end //}
          else
           begin //{
            env_config.scramble_dis= 0;
           idle_field_char = 9'h000;
//           idle_field_char = idle_field_char;
           end //}
        end //}
    end //} 
 end //}
 end //}
        
endtask

 virtual task srio_pl_char_transmitted_lane1(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
 // if (env_config.pl_tx_mon_init_sm_state == X2_MODE  && env_config.pl_rx_mon_init_sm_state == X2_MODE)  begin //{
     if(flag != 0 ) begin //{
       tmp1= idle_field_char;
       temp1 = tmp1[57:65];
       if((m_detect1==0) && (temp1 == 9'h13C))   begin //{
         m_detect_cnt1++;
         end //}
       if((m_detect1 == 0)&&(m_detect_cnt1) && (temp1 != 9'h13C)) begin //{
         m_detect1 = 0;
         m_detect_cnt1 = 0;
         end //}
       else if(m_detect_cnt1 == 4) begin //{
          m_detect1 =1;
          m_detect_cnt1 = 0;
         end //}
          if((temp1 == 9'h0b5) && (m_detect1 == 1) && (b5_cnt1 == 0))
          begin //{
             b5_detect1 = 1;
             b5_cnt1++;
           end //}
     else  if((m_detect1) && (b5_detect1))  begin //{

       if((b5_detect1) && (m_detect1)) begin //{
          cg_cnt1 = cg_cnt1+1;
          if(cg_cnt1 == 36) begin //{
            b5_detect1 = 0;
            m_detect1 = 0;
            cg_cnt1 = 0;
            b5_cnt1 = 0;
           idle_cnt1 = idle_cnt1+1; //pravin
           end //}
          else if((cg_cnt1>=0 &&cg_cnt1 <= (3+idle_cnt1) )) begin //{
            idle_field_char = idle_field_char;
          end //}

          else if((cg_cnt1==(4+idle_cnt1)) && (cg_cnt1 <= 32)) begin //{
            env_config.scramble_dis= 0;
            idle_field_char = 9'h080;
          end //}
          else if((cg_cnt1==(5+idle_cnt1))  && (cg_cnt1 <= 33)) begin //{
            env_config.scramble_dis= 0;
            idle_field_char = 9'h0c0;
          end //}
          else if((cg_cnt1==(6+idle_cnt1)) && (cg_cnt1 <= 34)) begin //{
            env_config.scramble_dis= 0;
            idle_field_char = 9'h00a;
          end //}
          else if((cg_cnt1==(7+idle_cnt1)) && (cg_cnt1 <= 35)) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h11c;
          end //}
          else if((cg_cnt1==(8+idle_cnt1))&& (cg_cnt1 <= 32)) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h1BC;
          end //}
          else if(cg_cnt1 ==(9+idle_cnt1)&& (cg_cnt1 <= 33)) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h1FD;
          end //}
          else if(cg_cnt1 ==(10+idle_cnt1)&& (cg_cnt1 <= 34)) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h1FD;
          end //}
          else if(cg_cnt1 ==(11+idle_cnt1)&& (cg_cnt1 <= 35)) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h1FD;
          end //}

          else if((cg_cnt1==(12+idle_cnt1))) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h13C;
          end //}
          else if((cg_cnt1>=(13+idle_cnt1) && cg_cnt1 <= (28+idle_cnt1))) begin //{
            env_config.scramble_dis= 0;
            idle_field_char = 9'h000;
          end //}
          else if((cg_cnt1==(29+idle_cnt1))) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h1FB;
          end //}
          else if((cg_cnt1>=(30+idle_cnt1) && cg_cnt1 <= (35+idle_cnt1))) begin //{
            env_config.scramble_dis= 0;
            idle_field_char = 9'h000;
          end //}
          else
           begin //{
            env_config.scramble_dis= 0;
           idle_field_char = 9'h000;
         //  env_config.scramble_dis= 0;
//           idle_field_char = idle_field_char ;
           end //}
        end //}
    end //} 
 end //}
 end //}
        
endtask
endclass


// Final with 1st cs insertion callback 
//IDLE 2 CORRUPTION --idle2 with control status signal 

class srio_pl_idle2_single_cs_krrr_corrupt_callback extends srio_pl_callback;
int m_detect_cnt0,m_detect_cnt1,m_detect_cnt2,m_detect_cnt3;
bit [0:65] tmp0,tmp1,tmp2,tmp3;
bit [1:0] flag = 1;
bit corrupt_cnt;
bit b5_cnt0,b5_cnt1,b5_cnt2,b5_cnt3;
bit [0:8] temp0,temp1,temp2,temp3;
bit [3:0] cs_field_count;
bit b5_detect0,b5_detect1,b5_detect2,b5_detect3;
bit m_detect0,m_detect1,m_detect2,m_detect3;
bit [5:0] cg_cnt0,cg_cnt1,cg_cnt2,cg_cnt3;
int idle_cnt0,idle_cnt1;

function new (string name = "srio_pl_idle2_single_cs_krrr_corrupt_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_idle2_single_cs_krrr_corrupt_callback"; 


virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_char_transmitted_lane0(ref bit [0:65] idle_field_char,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
 // if (env_config.pl_tx_mon_init_sm_state == X2_MODE  && env_config.pl_rx_mon_init_sm_state == X2_MODE)  begin //{
     if(flag != 0 ) begin //{
       tmp0= idle_field_char;
       temp0 = tmp0[57:65];
       if((m_detect0==0) && (temp0 == 9'h13C))   begin //{
         m_detect_cnt0++;
         end //}
       if((m_detect0 == 0)&&(m_detect_cnt0) && (temp0 != 9'h13C)) begin //{
         m_detect0 = 0;
         m_detect_cnt0 = 0;
         end //}
       else if(m_detect_cnt0 == 4) begin //{
          m_detect0 =1;
          m_detect_cnt0 = 0;
         end //}
          if((temp0 == 9'h0b5) && (m_detect0 == 1) && (b5_cnt0 == 0))
          begin //{
             b5_detect0 = 1;
             b5_cnt0++;
           end //}
     else  if((m_detect0) && (b5_detect0))  begin //{

       if((b5_detect0) && (m_detect0)) begin //{
          cg_cnt0 = cg_cnt0+1;
          if(cg_cnt0 == 36) begin //{
            b5_detect0 = 0;
            m_detect0 = 0;
            cg_cnt0 = 0;
           end //}
          else if((cg_cnt0>= (0+idle_cnt0) &&cg_cnt0 <= (3+idle_cnt0) )) begin //{
            idle_field_char = idle_field_char;
          end //}
          else if((cg_cnt0==(4+idle_cnt0))) begin //{
            idle_field_char = 9'h11c;
          end //}
          else if((cg_cnt0==(5+idle_cnt0))) begin //{
            idle_field_char = 9'h07F;
          end //}
          else if((cg_cnt0==(6+idle_cnt0))) begin //{
            idle_field_char = 9'h000;
          end //}
          else if((cg_cnt0==(7+idle_cnt0))) begin //{
            idle_field_char = 9'h035;
          end //}
          else if((cg_cnt0==(8+idle_cnt0))) begin //{
            idle_field_char = 9'h1BC;
          end //}
          else if((cg_cnt0>=(9+idle_cnt0) && cg_cnt0 <= (11+idle_cnt0))) begin //{
            idle_field_char = 9'h1FD;
          end //}
          else if((cg_cnt0==12)) begin //{
            idle_field_char = 9'h13C;
          end //}
          else if((cg_cnt0>=13 && cg_cnt0 <= 28)) begin //{
            idle_field_char = 9'h000;
          end //}
          else if((cg_cnt0==(29+idle_cnt0))) begin //{
            idle_field_char = 9'h1FB;
          end //}
          else if((cg_cnt0>=(30+idle_cnt0) && cg_cnt0 <= (35+idle_cnt0))) begin //{
            idle_field_char = 9'h000;
          end //}
          else
           begin //{
           idle_field_char = 9'h000;
           end //}
        end //}
    end //} 
 end //}
 end //}
        
endtask

 virtual task srio_pl_char_transmitted_lane1(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
 // if (env_config.pl_tx_mon_init_sm_state == X2_MODE  && env_config.pl_rx_mon_init_sm_state == X2_MODE)  begin //{
     if(flag != 0 ) begin //{
       tmp1= idle_field_char;
       temp1 = tmp1[57:65];
       if((m_detect1==0) && (temp1 == 9'h13C))   begin //{
         m_detect_cnt1++;
         end //}
       if((m_detect1 == 0)&&(m_detect_cnt1) && (temp1 != 9'h13C)) begin //{
         m_detect1 = 0;
         m_detect_cnt1 = 0;
         end //}
       else if(m_detect_cnt1 == 4) begin //{
          m_detect1 =1;
          m_detect_cnt1 = 0;
         end //}
          if((temp1 == 9'h0b5) && (m_detect1 == 1) && (b5_cnt1 == 0))
          begin //{
             b5_detect1 = 1;
             b5_cnt1++;
           end //}
     else  if((m_detect1) && (b5_detect1))  begin //{

       if((b5_detect1) && (m_detect1)) begin //{
          cg_cnt1 = cg_cnt1+1;
          if(cg_cnt1 == 36) begin //{
            b5_detect1 = 0;
            m_detect1 = 0;
            cg_cnt1 = 0;
           end //}
          else if((cg_cnt1>=(0+idle_cnt1) &&cg_cnt1 <= (3+idle_cnt1) )) begin //{
            idle_field_char = idle_field_char;
          end //}

          else if((cg_cnt1==(4+idle_cnt1))) begin //{
            idle_field_char = 9'h080;
          end //}
          else if((cg_cnt1==(5+idle_cnt1))) begin //{
            idle_field_char = 9'h0c0;
          end //}
          else if((cg_cnt1==(6+idle_cnt1))) begin //{
            idle_field_char = 9'h00a;
          end //}
          else if((cg_cnt1==(7+idle_cnt1))) begin //{
            idle_field_char = 9'h11c;
          end //}
          else if((cg_cnt1==(8+idle_cnt1))) begin //{
            idle_field_char = 9'h1BC;
          end //}
          else if((cg_cnt1 >=(9+idle_cnt1) && cg_cnt1 <= (11+idle_cnt1))) begin //{
            idle_field_char = 9'h1FD;
          end //}
          else if((cg_cnt1==(12+idle_cnt1))) begin //{
            idle_field_char = 9'h13C;
          end //}
          else if((cg_cnt1>=(13+idle_cnt1) && cg_cnt1 <= (28+idle_cnt1))) begin //{
            idle_field_char = 9'h000;
          end //}
          else if((cg_cnt1==(29+idle_cnt1))) begin //{
            idle_field_char = 9'h1FB;
          end //}
          else if((cg_cnt1>=(30+idle_cnt1) && cg_cnt1 <= (35+idle_cnt1))) begin //{
            idle_field_char = 9'h000;
          end //}
          else
           begin //{
           idle_field_char = 9'h000;
           end //}
        end //}
    end //} 
 end //}
 end //}
        
endtask
endclass


//CS insertion in data words 

class srio_pl_cs_insert_data_word_corrupt_callback extends srio_pl_callback;
int m_detect_cnt0,m_detect_cnt1,m_detect_cnt2,m_detect_cnt3;
bit [0:65] tmp0,tmp1,tmp2,tmp3;
rand bit  flag ;
bit corrupt_cnt;
bit b5_cnt0,b5_cnt1,b5_cnt2,b5_cnt3;
bit [0:8] temp0,temp1,temp2,temp3;
bit [3:0] cs_field_count;
bit b5_detect0,b5_detect1,b5_detect2,b5_detect3;
bit m_detect0,m_detect1,m_detect2,m_detect3;
bit [5:0] cg_cnt0,cg_cnt1,cg_cnt2,cg_cnt3;
int idle_cnt0,idle_cnt1;
int corrupt_cnt0,corrupt_cnt1;
bit flag_0,flag_1;
int insert_cnt0,insert_cnt1;
function new (string name = "srio_pl_cs_insert_data_word_corrupt_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_cs_insert_data_word_corrupt_callback"; 


virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_char_transmitted_lane0(ref bit [0:65] idle_field_char,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
     flag = 1;
 // if (env_config.pl_tx_mon_init_sm_state == X2_MODE  && env_config.pl_rx_mon_init_sm_state == X2_MODE)  begin //{
     if(flag != 0 && insert_cnt0 <= 3) begin //{
       tmp0= idle_field_char;
       temp0 = tmp0[57:65];
       if((m_detect0==0) && (temp0 == 9'h13C))   begin //{
         m_detect_cnt0++;
         end //}
       if((m_detect0 == 0)&&(m_detect_cnt0) && (temp0 != 9'h13C)) begin //{
         m_detect0 = 0;
         m_detect_cnt0 = 0;
         end //}
       else if(m_detect_cnt0 == 4) begin //{
          m_detect0 =1;
          m_detect_cnt0 = 0;
         end //}
          if((temp0 == 9'h0b5) && (m_detect0 == 1) && (b5_cnt0 == 0))
          begin //{
             b5_detect0 = 1;
             b5_cnt0++;
           end //}
     else if((m_detect0) && (b5_detect0))  begin //{
          cg_cnt0 = cg_cnt0+1;
          if(cg_cnt0 == 36 && flag_0 == 0)
            begin //{
              if(temp0 == 9'h1bc)
                 begin
                   corrupt_cnt0 = cg_cnt0;
                   corrupt_cnt0 = corrupt_cnt0 + 7;
                 end
              else 
               begin
                 corrupt_cnt0 = cg_cnt0;
               end
              flag_0 = 1;
             end //}

         else if (flag_0 == 1)
           begin //{
         if(cg_cnt0 == corrupt_cnt0+1 )
             begin
            env_config.scramble_dis= 1;
              idle_field_char = 9'h11c;
             end
          else if(cg_cnt0 == corrupt_cnt0+2 )
             begin
            env_config.scramble_dis= 0;
              idle_field_char = 9'h07f;
             end
          else if(cg_cnt0 == corrupt_cnt0+3 )
             begin
            env_config.scramble_dis= 0;
              idle_field_char = 9'h000;
             end
          else if(cg_cnt0 == corrupt_cnt0+4 )
             begin
            env_config.scramble_dis= 0;
              idle_field_char = 9'h035;
              b5_detect0 = 0;
              m_detect0 = 0;
              cg_cnt0 =0;
              corrupt_cnt0 =0;
              flag_0 = 0;
              insert_cnt0 = insert_cnt0 + 1;
              b5_cnt0 = 0;
             end
         end //}                 
       end //}

    end //} 
 end //}
        
endtask

 virtual task srio_pl_char_transmitted_lane1(ref bit [0:65] idle_field_char,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
 // if (env_config.pl_tx_mon_init_sm_state == X2_MODE  && env_config.pl_rx_mon_init_sm_state == X2_MODE)  begin //{
     if(flag != 0 && insert_cnt1 <= 3) begin //{
       tmp1= idle_field_char;
       temp1 = tmp1[57:65];
       if((m_detect1==0) && (temp1 == 9'h13C))   begin //{
         m_detect_cnt1++;
         end //}
       if((m_detect1 == 0)&&(m_detect_cnt1) && (temp1 != 9'h13C)) begin //{
         m_detect1 = 0;
         m_detect_cnt1 = 0;
         end //}
       else if(m_detect_cnt1 == 4) begin //{
          m_detect1 =1;
          m_detect_cnt1 = 0;
         end //}
          if((temp1 == 9'h0b5) && (m_detect1 == 1) && (b5_cnt1 == 0))
          begin //{
             b5_detect1 = 1;
             b5_cnt1++;
           end //}
     else if((m_detect1) && (b5_detect1))  begin //{
          cg_cnt1 = cg_cnt1+1;
          if(cg_cnt1 == 36 && flag_1 == 0)
            begin
              if(temp0 == 9'h1bc)
                 begin
                   corrupt_cnt1 = cg_cnt1;
                   corrupt_cnt1 = corrupt_cnt1 + 7;
                 end
              else 
               begin
                 corrupt_cnt1 = cg_cnt1;
               end
               flag_1 = 1;
             end
         // else 
         else if (flag_1 == 1)
           begin //{
          if(cg_cnt1 == corrupt_cnt1+1 )
             begin
            env_config.scramble_dis= 0;
              idle_field_char = 9'h080;
             end
          else if(cg_cnt1 == corrupt_cnt1+2 )
             begin
            env_config.scramble_dis= 0;
              idle_field_char = 9'h0c0;
             end
          else if(cg_cnt1 == corrupt_cnt1+3 )
             begin
            env_config.scramble_dis= 0;
              idle_field_char = 9'h00a;
             end
          else if(cg_cnt1 == corrupt_cnt1+4 )
             begin
            env_config.scramble_dis= 1;
             m_detect1 = 0;
              idle_field_char = 9'h11c;
              b5_detect1 = 0;
              cg_cnt1 =0;
              corrupt_cnt1 =0;
              flag_1 = 0;
              insert_cnt1 = insert_cnt1 + 1;
              b5_cnt1 =0;
             end
         end                  
      end  //}
    end //} 
 end //}
endtask
endclass


//IDLE 2 CORRUPTION --idle2 with control status signal for single lane

class srio_pl_idle2_single_cs_krrr_corrupt_callback1 extends srio_pl_callback;
int m_detect_cnt0,m_detect_cnt1,m_detect_cnt2,m_detect_cnt3;
bit [0:65] tmp0,tmp1,tmp2,tmp3;
bit [1:0] flag = 1;
bit corrupt_cnt;
bit b5_cnt0,b5_cnt1,b5_cnt2,b5_cnt3;
bit [0:8] temp0,temp1,temp2,temp3;
bit [3:0] cs_field_count;
bit b5_detect0,b5_detect1,b5_detect2,b5_detect3;
bit m_detect0,m_detect1,m_detect2,m_detect3;
bit [5:0] cg_cnt0,cg_cnt1,cg_cnt2,cg_cnt3;
int idle_cnt0,idle_cnt1;

function new (string name = "srio_pl_idle2_single_cs_krrr_corrupt_callback1"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_idle2_single_cs_krrr_corrupt_callback1"; 


virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_char_transmitted_lane0(ref bit [0:65] idle_field_char,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
 // if (env_config.pl_tx_mon_init_sm_state == X2_MODE  && env_config.pl_rx_mon_init_sm_state == X2_MODE)  begin //{
     if(flag != 0 ) begin //{
       tmp0= idle_field_char;
       temp0 = tmp0[57:65];
       if((m_detect0==0) && (temp0 == 9'h13C))   begin //{
         m_detect_cnt0++;
         end //}
       if((m_detect0 == 0)&&(m_detect_cnt0) && (temp0 != 9'h13C)) begin //{
         m_detect0 = 0;
         m_detect_cnt0 = 0;
         end //}
       else if(m_detect_cnt0 == 4) begin //{
          m_detect0 =1;
          m_detect_cnt0 = 0;
         end //}
          if((temp0 == 9'h0b5) && (m_detect0 == 1) && (b5_cnt0 == 0))
          begin //{
             b5_detect0 = 1;
             b5_cnt0++;
           end //}
     else  if((m_detect0) && (b5_detect0))  begin //{

       if((b5_detect0) && (m_detect0)) begin //{
          cg_cnt0 = cg_cnt0+1;
          if(cg_cnt0 == 36) begin //{
            b5_detect0 = 0;
            m_detect0 = 0;
            cg_cnt0 = 0;
           end //}
          else if((cg_cnt0>= (0+idle_cnt0) &&cg_cnt0 <= (3+idle_cnt0) )) begin //{
            idle_field_char = idle_field_char;
          end //}
          else if((cg_cnt0==(4+idle_cnt0))) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h11c;
          end //}
          else if((cg_cnt0==(5+idle_cnt0))) begin //{
            env_config.scramble_dis= 0;
            idle_field_char = 9'h080;
          end //}
          else if((cg_cnt0==(6+idle_cnt0))) begin //{
            env_config.scramble_dis= 0;
            idle_field_char = 9'h07f;
          end //}
          else if((cg_cnt0==(7+idle_cnt0))) begin //{
            env_config.scramble_dis= 0;
            idle_field_char = 9'h0c0;
          end //}

          else if((cg_cnt0==(8+idle_cnt0))) begin //{
            env_config.scramble_dis= 0;
            idle_field_char = 9'h000;
          end //}

          else if((cg_cnt0==(9+idle_cnt0))) begin //{
            env_config.scramble_dis= 0;
            idle_field_char = 9'h00a;
          end //}

          else if((cg_cnt0==(10+idle_cnt0))) begin //{
            env_config.scramble_dis= 0;
            idle_field_char = 9'h035;
          end //}

          else if((cg_cnt0==(11+idle_cnt0))) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h11c;
          end //}

          else if((cg_cnt0==(12+idle_cnt0))) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h1BC;
          end //}
          else if((cg_cnt0>=(13+idle_cnt0) && cg_cnt0 <= (15+idle_cnt0))) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h1FD;
          end //}
          else if((cg_cnt0==16)) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h13C;
          end //}
          else if((cg_cnt0>=17 && cg_cnt0 <= 28)) begin //{
            env_config.scramble_dis= 0;
            idle_field_char = 9'h000;
          end //}
          else if((cg_cnt0==(29+idle_cnt0))) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h1FB;
          end //}
          else if((cg_cnt0>=(30+idle_cnt0) && cg_cnt0 <= (35+idle_cnt0))) begin //{
            env_config.scramble_dis= 0;
            idle_field_char = 9'h000;
          end //}
          else
           begin //{
            env_config.scramble_dis= 0;
           idle_field_char = 9'h000;
           end //}
        end //}
    end //} 
 end //}
 end //}
        
endtask

endclass


//IDLE 2 CORRUPTION --idle2 with control status signal for 4 lanes 

class srio_pl_idle2_multi_cs_krrr_corrupt_callback2 extends srio_pl_callback;
int m_detect_cnt0,m_detect_cnt1,m_detect_cnt2,m_detect_cnt3;
bit [0:65] tmp0,tmp1,tmp2,tmp3;
bit [1:0] flag = 1;
bit corrupt_cnt;
bit b5_cnt0,b5_cnt1,b5_cnt2,b5_cnt3;
bit [0:8] temp0,temp1,temp2,temp3;
bit [3:0] cs_field_count;
bit b5_detect0,b5_detect1,b5_detect2,b5_detect3;
bit m_detect0,m_detect1,m_detect2,m_detect3;
bit [5:0] cg_cnt0,cg_cnt1,cg_cnt2,cg_cnt3;
int idle_cnt0,idle_cnt1,idle_cnt2,idle_cnt3;

function new (string name = "srio_pl_idle2_multi_cs_krrr_corrupt_callback2"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_idle2_multi_cs_krrr_corrupt_callback2"; 


virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_char_transmitted_lane0(ref bit [0:65] idle_field_char,srio_env_config env_config);
  if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
 // if (env_config.pl_tx_mon_init_sm_state == X2_MODE  && env_config.pl_rx_mon_init_sm_state == X2_MODE)  begin //{
     if(flag != 0 ) begin //{       
       tmp0= idle_field_char;
       temp0 = tmp0[57:65];
       if((m_detect0==0) && (temp0 == 9'h13C))   begin //{
         m_detect_cnt0++;
         end //}
       if((m_detect0 == 0)&&(m_detect_cnt0) && (temp0 != 9'h13C)) begin //{
         m_detect0 = 0;
         m_detect_cnt0 = 0;
         end //}
       else if(m_detect_cnt0 == 4) begin //{
          m_detect0 =1;
          m_detect_cnt0 = 0;
         end //}
          if((temp0 == 9'h0b5) && (m_detect0 == 1) && (b5_cnt0 == 0))
          begin //{
             b5_detect0 = 1;
             b5_cnt0++;
           end //}
     else  if((m_detect0) && (b5_detect0))  begin //{

       if((b5_detect0) && (m_detect0)) begin //{
          cg_cnt0 = cg_cnt0+1;
          if(cg_cnt0 == 36) begin //{
            b5_detect0 = 0;
            m_detect0 = 0;
            cg_cnt0 = 0;
         //   b5_cnt0 = 0;
            //idle_cnt0 = idle_cnt0+1; //pravin
           end //}
          else if((cg_cnt0>= 0 &&cg_cnt0 <= (3+idle_cnt0) )) begin //{
            idle_field_char = idle_field_char;
          end //}
          else if((cg_cnt0==(4+idle_cnt0))&& (cg_cnt0 <= 32)) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h11c;
          end //}
          else if((cg_cnt0==(5+idle_cnt0))&& (cg_cnt0 <= 33)) begin //{
            env_config.scramble_dis= 0;
            idle_field_char = 9'h000;
          end //}

          else if((cg_cnt0==(6+idle_cnt0))&& (cg_cnt0 <= 32)) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h1BC;
          end //}
          else if(cg_cnt0==(7+idle_cnt0)&& (cg_cnt0 <= 33)) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h1FD;
          end //}
          else if(cg_cnt0==(8+idle_cnt0)&& (cg_cnt0 <= 34)) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h1FD;
          end //}
          else if(cg_cnt0==(9+idle_cnt0)&& (cg_cnt0 <= 35)) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h1FD;
          end //}
          else if(cg_cnt0==(10+idle_cnt0)) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h13C;
          end //}
          else if((cg_cnt0>=(11+idle_cnt0) && cg_cnt0 <= (28+idle_cnt0))) begin //{
            env_config.scramble_dis= 0;
            idle_field_char = 9'h000;
          end //}
          else if((cg_cnt0==(29+idle_cnt0))) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h1FB;
          end //}
          else if((cg_cnt0>=(30+idle_cnt0) && cg_cnt0 <= (35+idle_cnt0))) begin //{
            env_config.scramble_dis= 0;
            idle_field_char = 9'h000;
          end //}
          else
           begin //{
            env_config.scramble_dis= 0;
           idle_field_char = 9'h000;
//           idle_field_char = idle_field_char;
           end //}
        end //}
    end //} 
 end //}
 end //}
        
endtask

 virtual task srio_pl_char_transmitted_lane1(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
 // if (env_config.pl_tx_mon_init_sm_state == X2_MODE  && env_config.pl_rx_mon_init_sm_state == X2_MODE)  begin //{
     if(flag != 0 ) begin //{
       tmp1= idle_field_char;
       temp1 = tmp1[57:65];
       if((m_detect1==0) && (temp1 == 9'h13C))   begin //{
         m_detect_cnt1++;
         end //}
       if((m_detect1 == 0)&&(m_detect_cnt1) && (temp1 != 9'h13C)) begin //{
         m_detect1 = 0;
         m_detect_cnt1 = 0;
         end //}
       else if(m_detect_cnt1 == 4) begin //{
          m_detect1 =1;
          m_detect_cnt1 = 0;
         end //}
          if((temp1 == 9'h0b5) && (m_detect1 == 1) && (b5_cnt1 == 0))
          begin //{
             b5_detect1 = 1;
             b5_cnt1++;
           end //}
     else  if((m_detect1) && (b5_detect1))  begin //{

       if((b5_detect1) && (m_detect1)) begin //{
          cg_cnt1 = cg_cnt1+1;
          if(cg_cnt1 == 36) begin //{
            b5_detect1 = 0;
            m_detect1 = 0;
            cg_cnt1 = 0;
           end //}
          else if((cg_cnt1>=0 &&cg_cnt1 <= (3+idle_cnt1) )) begin //{
            idle_field_char = idle_field_char;
          end //}

          else if((cg_cnt1==(4+idle_cnt1)) && (cg_cnt1 <= 32)) begin //{
            env_config.scramble_dis= 0;
            idle_field_char = 9'h080;
          end //}
          else if((cg_cnt1==(5+idle_cnt1))  && (cg_cnt1 <= 33)) begin //{
            env_config.scramble_dis= 0;
            idle_field_char = 9'h00a;
          end //}
          else if((cg_cnt1==(6+idle_cnt1))&& (cg_cnt1 <= 32)) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h1BC;
          end //}
          else if(cg_cnt1 ==(7+idle_cnt1)&& (cg_cnt1 <= 33)) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h1FD;
          end //}
          else if(cg_cnt1 ==(8+idle_cnt1)&& (cg_cnt1 <= 34)) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h1FD;
          end //}
          else if(cg_cnt1 ==(9+idle_cnt1)&& (cg_cnt1 <= 35)) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h1FD;
          end //}

          else if((cg_cnt1==(10+idle_cnt1))) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h13C;
          end //}
          else if((cg_cnt1>=(11+idle_cnt1) && cg_cnt1 <= (28+idle_cnt1))) begin //{
            env_config.scramble_dis= 0;
            idle_field_char = 9'h000;
          end //}
          else if((cg_cnt1==(29+idle_cnt1))) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h1FB;
          end //}
          else if((cg_cnt1>=(30+idle_cnt1) && cg_cnt1 <= (35+idle_cnt1))) begin //{
            env_config.scramble_dis= 0;
            idle_field_char = 9'h000;
          end //}
          else
           begin //{
            env_config.scramble_dis= 0;
           idle_field_char = 9'h000;
           end //}
        end //}
    end //} 
 end //}
 end //}
        
endtask


 virtual task srio_pl_char_transmitted_lane2(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
 // if (env_config.pl_tx_mon_init_sm_state == X2_MODE  && env_config.pl_rx_mon_init_sm_state == X2_MODE)  begin //{
     if(flag != 0 ) begin //{
       tmp2= idle_field_char;
       temp2 = tmp2[57:65];
       if((m_detect2==0) && (temp2 == 9'h13C))   begin //{
         m_detect_cnt2++;
         end //}
       if((m_detect2 == 0)&&(m_detect_cnt2) && (temp2 != 9'h13C)) begin //{
         m_detect2 = 0;
         m_detect_cnt2 = 0;
         end //}
       else if(m_detect_cnt2 == 4) begin //{
          m_detect2 =1;
          m_detect_cnt2 = 0;
         end //}
          if((temp2 == 9'h0b5) && (m_detect2 == 1) && (b5_cnt2 == 0))
          begin //{
             b5_detect2 = 1;
             b5_cnt2++;
           end //}
     else  if((m_detect2) && (b5_detect2))  begin //{

       if((b5_detect2) && (m_detect2)) begin //{
          cg_cnt2 = cg_cnt2+1;
          if(cg_cnt2 == 36) begin //{
            b5_detect2 = 0;
            m_detect2 = 0;
            cg_cnt2 = 0;
           end //}
          else if((cg_cnt2>=0 &&cg_cnt2 <= (3+idle_cnt2) )) begin //{
            idle_field_char = idle_field_char;
          end //}

          else if((cg_cnt2==(4+idle_cnt2)) && (cg_cnt2 <= 32)) begin //{
            env_config.scramble_dis= 0;
            idle_field_char = 9'h07F;
          end //}
          else if((cg_cnt2==(5+idle_cnt2))  && (cg_cnt2 <= 33)) begin //{
            env_config.scramble_dis= 0;
            idle_field_char = 9'h035;
          end //}
          else if((cg_cnt2==(6+idle_cnt2))&& (cg_cnt2 <= 32)) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h1BC;
          end //}
          else if(cg_cnt2 ==(7+idle_cnt2)&& (cg_cnt2 <= 33)) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h1FD;
          end //}
          else if(cg_cnt2 ==(8+idle_cnt2)&& (cg_cnt2 <= 34)) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h1FD;
          end //}
          else if(cg_cnt2 ==(9+idle_cnt2)&& (cg_cnt2 <= 35)) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h1FD;
          end //}

          else if((cg_cnt2==(10+idle_cnt2))) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h13C;
          end //}
          else if((cg_cnt2>=(11+idle_cnt2) && cg_cnt2 <= (28+idle_cnt2))) begin //{
            env_config.scramble_dis= 0;
            idle_field_char = 9'h000;
          end //}
          else if((cg_cnt2==(29+idle_cnt2))) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h1FB;
          end //}
          else if((cg_cnt2>=(30+idle_cnt2) && cg_cnt2 <= (35+idle_cnt2))) begin //{
            env_config.scramble_dis= 0;
            idle_field_char = 9'h000;
          end //}
          else
           begin //{
            env_config.scramble_dis= 0;
           idle_field_char = 9'h000;
           end //}
        end //}
    end //} 
 end //}
 end //}
        
endtask

 virtual task srio_pl_char_transmitted_lane3(ref bit [0:65] idle_field_char,srio_env_config env_config);
 if ((env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))  begin //{
 // if (env_config.pl_tx_mon_init_sm_state == X2_MODE  && env_config.pl_rx_mon_init_sm_state == X2_MODE)  begin //{
     if(flag != 0 ) begin //{
       tmp3= idle_field_char;
       temp3 = tmp3[57:65];
       if((m_detect3==0) && (temp3 == 9'h13C))   begin //{
         m_detect_cnt3++;
         end //}
       if((m_detect3 == 0)&&(m_detect_cnt3) && (temp3 != 9'h13C)) begin //{
         m_detect3 = 0;
         m_detect_cnt3 = 0;
         end //}
       else if(m_detect_cnt3 == 4) begin //{
          m_detect3 =1;
          m_detect_cnt3 = 0;
         end //}
          if((temp3 == 9'h0b5) && (m_detect3 == 1) && (b5_cnt3 == 0))
          begin //{
             b5_detect3 = 1;
             b5_cnt3++;
           end //}
     else  if((m_detect3) && (b5_detect3))  begin //{

       if((b5_detect3) && (m_detect3)) begin //{
          cg_cnt3 = cg_cnt3+1;
          if(cg_cnt3 == 36) begin //{
            b5_detect3 = 0;
            m_detect3 = 0;
            cg_cnt3 = 0;
           end //}
          else if((cg_cnt3>=0 &&cg_cnt3 <= (3+idle_cnt3) )) begin //{
            idle_field_char = idle_field_char;
          end //}

          else if((cg_cnt3==(4+idle_cnt3)) && (cg_cnt3 <= 32)) begin //{
            env_config.scramble_dis= 0;
            idle_field_char = 9'h0C0;
          end //}
          else if((cg_cnt3==(5+idle_cnt3))  && (cg_cnt3 <= 33)) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h11C;
          end //}
          else if((cg_cnt3==(6+idle_cnt3))&& (cg_cnt3 <= 32)) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h1BC;
          end //}
          else if(cg_cnt3 ==(7+idle_cnt3)&& (cg_cnt3 <= 33)) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h1FD;
          end //}
          else if(cg_cnt3 ==(8+idle_cnt3)&& (cg_cnt3 <= 34)) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h1FD;
          end //}
          else if(cg_cnt3 ==(9+idle_cnt3)&& (cg_cnt3 <= 35)) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h1FD;
          end //}

          else if((cg_cnt3==(10+idle_cnt3))) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h13C;
          end //}
          else if((cg_cnt3>=(11+idle_cnt3) && cg_cnt3 <= (28+idle_cnt3))) begin //{
            env_config.scramble_dis= 0;
            idle_field_char = 9'h000;
          end //}
          else if((cg_cnt3==(29+idle_cnt3))) begin //{
            env_config.scramble_dis= 1;
            idle_field_char = 9'h1FB;
          end //}
          else if((cg_cnt3>=(30+idle_cnt3) && cg_cnt3 <= (35+idle_cnt3))) begin //{
            env_config.scramble_dis= 0;
            idle_field_char = 9'h000;
          end //}
          else
           begin //{
            env_config.scramble_dis= 0;
           idle_field_char = 9'h000;
           end //}
        end //}
    end //} 
 end //}
 end //}
        
endtask
endclass


//IDLE2  followed by SOP then EOP unused.

class srio_pl_sop_idle2_eop_char_trans_cb extends srio_pl_callback;
int m_detect;
bit [0:65] tmp0,tmp1,tmp2,tmp3;
int  flag;
bit [0:8] temp0,temp1,temp2,temp3; 
bit cs_detected,sop_detect1,sop_detect2;
int m_send0,m_send1,m_send2,m_send3;
int d_send0,d_send1,d_send2,d_send3;

function new (string name = "srio_pl_sop_idle2_eop_char_trans_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_sop_idle2_eop_char_trans_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction


 virtual task srio_pl_char_transmitted_lane0(ref bit [0:65] idle_field_char,srio_env_config env_config);
  if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{

  if(flag < 5 ) begin //{
  tmp0= idle_field_char;
  temp0 = tmp0[57:65];   
      if(temp0 == 9'h17C)   begin //{
      cs_detected = 1; 
      end //}
      if(sop_detect1 == 1 && sop_detect2 == 1 )
        begin       
          cs_detected = 0; 
         d_send0 = d_send0+1;
         m_send0 = m_send0 +1;
        end
      if (m_send0 == 2)
        begin
         idle_field_char[57:65] = 9'h13C;       
        end
      else if(m_send0 > 2 && d_send0 < 16)
       begin
         idle_field_char[57:65] = 9'h000;
       end 
      else if (d_send0 == 16)
        begin
           d_send0 = 0;
           m_send0 =0;
           sop_detect1 =0;
           sop_detect2 =0;
           cs_detected = 0;
           flag = flag+1;
        end
  end //}
  end //}
endtask

 virtual task srio_pl_char_transmitted_lane1(ref bit [0:65] idle_field_char,srio_env_config env_config);
  if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{

  if(flag <= 5) begin //{
  tmp1= idle_field_char;
  temp1 = tmp1[57:65];   
      if(sop_detect1 == 1 && sop_detect2 == 1)
        begin
         m_send1 = m_send1+1;
         d_send1 = d_send1+1;
        end
      if(m_send1 == 2)
        begin
         idle_field_char[57:65] = 9'h13C;
        end
      else if(m_send1 > 2 && d_send1 < 15)
       begin
         idle_field_char[57:65] = 9'h000;
       end 
      else if (d_send1 == 15)
        begin
           d_send1 = 0;
           m_send1 =0;
           sop_detect1 =0;
           sop_detect2 =0;
        end
         
  end //}
  end //}
         endtask

 virtual task srio_pl_char_transmitted_lane2(ref bit [0:65] idle_field_char,srio_env_config env_config);
  if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{

  if(flag <= 5 ) begin //{
  tmp2= idle_field_char;
  temp2 = tmp2[57:65];   
      if(temp2[8] == 0 && cs_detected == 1 )   begin //{
          sop_detect1 = 1;
      end //}
      if(sop_detect1 == 1 && sop_detect2 == 1)
        begin
         m_send2 = m_send2+1;
         d_send2 = d_send2+1;
        end
      if(m_send2 == 2)
        begin
         idle_field_char[57:65] = 9'h13C;
       end
      else if(m_send2 > 1 && d_send2 < 15)
       begin
         idle_field_char[57:65] = 9'h000;
       end 
      else if (d_send2 == 15)
        begin
           d_send2 = 0;
           m_send2 =0;
           sop_detect1 =0;
           sop_detect2 =0;
        end

  end //}
  end //}
         endtask

 virtual task srio_pl_char_transmitted_lane3(ref bit [0:65] idle_field_char,srio_env_config env_config);
  if (env_config.pl_tx_mon_init_sm_state == NX_MODE  && env_config.pl_rx_mon_init_sm_state == NX_MODE)  begin //{

  if(flag <= 5 ) begin //{
  tmp3= idle_field_char;
  temp3 = tmp3[57:65];   
      if(temp3[1:2] == 0 && cs_detected == 1 )   begin //{
          sop_detect2 = 1;
      end //}
      if(sop_detect1 == 1 && sop_detect2 == 1 )
        begin
         d_send3 = d_send3+1;
         m_send3 = m_send3+1;
        end
      if(m_send3 == 3)
        begin
         idle_field_char[57:65] = 9'h13C;
        end
      else if(m_send3 > 3 && d_send3 < 16)
       begin
         idle_field_char[57:65] = 9'h000;
       end 
      else if (d_send3 == 16)
        begin
           d_send3 = 0;
           m_send3 =0;
           sop_detect1 =0;
           sop_detect2 =0;
        end

  end //}
  end //}
         endtask

endclass
// IDLE followed by SOP and then EOP 
class srio_pl_sop_idle_eop_merg_pkt_cb extends srio_pl_callback;
int pkt_size;
bit [0:8] tmp0,tmp1,tmp2,tmp3,tmp4,tmp5,tmp6,tmp7,tmp8;
bit [0:8] flag;
bit [0:12] cal_crc13;
bit [0:37] tmp_crc;
srio_pl_agent pl_agent_cb ; 
int div_68 ,merg_cnt,a;
function new (string name = "srio_pl_sop_idle_eop_merg_pkt_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_sop_idle_eop_merg_pkt_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_trans_transmit(ref srio_pl_data_trans tx_gen,srio_trans srio_trans_in);
   if(tx_gen.m_type == MERGED_PKT && merg_cnt <5)
    begin //{
      merg_cnt = merg_cnt + 1;
       pkt_size = tx_gen.bs_merged_pkt.size() ; 
       tmp8 =tx_gen.bs_merged_pkt[0] ;
       tmp7 =tx_gen.bs_merged_pkt[1] ;
       tmp6 =tx_gen.bs_merged_pkt[2] ;
       tmp5 =tx_gen.bs_merged_pkt[3] ;
       tmp4 =tx_gen.bs_merged_pkt[4] ;
       tmp3 =tx_gen.bs_merged_pkt[5] ;
       tmp2 =tx_gen.bs_merged_pkt[6] ;
       tmp1 =tx_gen.bs_merged_pkt[7] ;
       flag= {tmp6[8],tmp5[1:2]};
    if(tmp8 == 'h17C && flag == 3'b000) begin //{

   div_68 =   (pkt_size - 16)/68; 
    for(int j =0;j < div_68;j++) 
    begin
    for(int i =1;i <= 68;i++) 
      begin
      a = (j*68)+i;
      if(i >= 1 && i <= 4)
      tx_gen.bs_merged_pkt[a+7] = 9'h13C;
      else
       tx_gen.bs_merged_pkt[a+7] = 9'h000;
      end
   end
  end //}
end //}
endtask

endclass

// IDLE followed by SOP and then LREQ 
class srio_pl_sop_idle_lreq_merg_pkt_cb extends srio_pl_callback;
int pkt_size;
bit [0:8] tmp0,tmp1,tmp2,tmp3,tmp4,tmp5,tmp6,tmp7,tmp8;
bit [0:8] flag;
bit [0:12] cal_crc13;
bit [0:37] tmp_crc;
srio_pl_agent pl_agent_cb ; 
int div_68 ,merg_cnt,a,b;
function new (string name = "srio_pl_sop_idle_lreq_merg_pkt_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_sop_idle_lreq_merg_pkt_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_trans_transmit(ref srio_pl_data_trans tx_gen,srio_trans srio_trans_in);
   if(tx_gen.m_type == MERGED_PKT && merg_cnt <5)
    begin //{
      merg_cnt = merg_cnt + 1;
       pkt_size = tx_gen.bs_merged_pkt.size() ; 
       tmp8 =tx_gen.bs_merged_pkt[0] ;
       tmp7 =tx_gen.bs_merged_pkt[1] ;
       tmp6 =tx_gen.bs_merged_pkt[2] ;
       tmp5 =tx_gen.bs_merged_pkt[3] ;
       tmp4 =tx_gen.bs_merged_pkt[4] ;
       tmp3 =tx_gen.bs_merged_pkt[5] ;
       tmp2 =tx_gen.bs_merged_pkt[6] ;
       tmp1 =tx_gen.bs_merged_pkt[7] ;
       flag= {tmp6[8],tmp5[1:2]};
    if(tmp8 == 'h17C && flag == 3'b000) begin //{

   div_68 =   (pkt_size - 16)/68; 
    for(int j =0;j < div_68;j++) 
    begin
    for(int i =1;i <= 68;i++) 
      begin
      a = (j*68)+i;
      if(i >= 1 && i <= 4)
      tx_gen.bs_merged_pkt[a+7] = 9'h13C;
      else
       tx_gen.bs_merged_pkt[a+7] = 9'h000;
      end
   end

       for(int k =1 ;k <= 80 ;k++)
         begin
           if(k == 17 | k == 18 | k == 19 | k == 20 
              | k == 37 | k == 38 | k == 39 | k == 40 
              | k == 57 | k == 58 | k == 59 | k == 60
              | k == 77 | k == 78 | k == 79 | k == 80)
           begin
           tx_gen.bs_merged_pkt[pkt_size-(8+k)] = 9'h13C;
           end
           else
           tx_gen.bs_merged_pkt[pkt_size-(8+k)] = 9'h000;
          end
     
       tx_gen.bs_merged_pkt[pkt_size-8] = 9'h11C;
       tx_gen.bs_merged_pkt[pkt_size-7] = 9'h080;
       tx_gen.bs_merged_pkt[pkt_size-6] = 9'h07F;
       tx_gen.bs_merged_pkt[pkt_size-5] = 9'h020;
       tx_gen.bs_merged_pkt[pkt_size-4] = 9'h000;
       tx_gen.bs_merged_pkt[pkt_size-3] = 9'h00d;
       tx_gen.bs_merged_pkt[pkt_size-2] = 9'h0d2;
       tx_gen.bs_merged_pkt[pkt_size-1] = 9'h11C;
    end //}
end //}
endtask

endclass

//=========== callback to corrupt CS ackid status =========

class srio_pl_ackid_status_corrupt_cb extends srio_pl_callback;
bit [0:8] tmp0_cs,tmp1_cs,tmp2_cs,tmp3_cs,tmp4_cs,tmp5_cs,tmp6_cs,tmp7_cs,tmp8_cs;
bit [0:8] tmp0_pkt,tmp1_pkt,tmp2_pkt,tmp3_pkt,tmp4_pkt,tmp5_pkt,tmp6_pkt,tmp7_pkt,tmp8_pkt;
bit [0:12] cal_crc13;
bit [0:37] tmp_crc;
int pkt_size;
srio_pl_agent pl_agent_cb ; 
int cnt;
rand int rand_crc;
logic [0:8] cb_mergered_pkt[$];
logic [0:8] cb_mergered_cs[$];
int cb_merged_cs_q_size;
int cb_merged_pkt_q_size;
int loop_cs_cnt,loop_pkt_cnt;
bit flag;
function new (string name = "srio_pl_ackid_status_corrupt_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_ackid_status_corrupt_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_trans_transmit(ref srio_pl_data_trans tx_gen,srio_trans srio_trans_in);
if(flag == 1)
 begin
   if(tx_gen.m_type == MERGED_CS)
    begin //{
         pkt_size = tx_gen.bs_merged_cs.size();
         loop_cs_cnt = pkt_size/8;
         for(int i = 0;i < loop_cs_cnt;i++)
           begin //{
             tmp0_cs =tx_gen.bs_merged_cs[pkt_size -(8+(8*i))] ; 
             if(tmp0_cs == 9'h11C)
                begin //{
                  tx_gen.bs_merged_cs[pkt_size -(6+(i*8))][1] = 1;
                  tmp_crc={tx_gen.bs_merged_cs[pkt_size -(7+(8*i))][1:8],tx_gen.bs_merged_cs[pkt_size -(6+(8*i))][1:8],tx_gen.bs_merged_cs[pkt_size -(5+(8*i))][1:5]};
                  cal_crc13= srio_trans_in.calccrc13(tmp_crc);
                  tx_gen.bs_merged_cs[pkt_size -(3+(8*i))][4:8]=cal_crc13[0:4];
                  tx_gen.bs_merged_cs[pkt_size -(2+(8*i))][1:8]=cal_crc13[5:12]; 
              end //}
         end //}
     end //}
end
   endtask
endclass

//=========== callback to corrupt CS and PKT to generate PNACK with different cause GEN1=========

class srio_pl_pnack_diff_cause_gen1_err_cb extends srio_pl_callback;
bit [0:8] tmp0_cs,tmp1_cs,tmp2_cs,tmp3_cs,tmp4_cs,tmp5_cs,tmp6_cs,tmp7_cs,tmp8_cs;
bit [0:8] tmp0_pkt,tmp1_pkt,tmp2_pkt,tmp3_pkt,tmp4_pkt,tmp5_pkt,tmp6_pkt,tmp7_pkt,tmp8_pkt;
bit [0:12] cal_crc13;
bit [0:37] tmp_crc;
int pkt_size;
srio_pl_agent pl_agent_cb ; 
int cnt;
rand int rand_crc,rand_pkt_ackid;
logic [0:8] cb_mergered_pkt[$];
logic [0:8] cb_mergered_cs[$];
int cb_merged_cs_q_size;
int cb_merged_pkt_q_size;
int loop_cs_cnt,loop_pkt_cnt;
function new (string name = "srio_pl_pnack_diff_cause_gen1_err_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_pnack_diff_cause_gen1_err_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_trans_transmit(ref srio_pl_data_trans tx_gen,srio_trans srio_trans_in);
   if(tx_gen.m_type == MERGED_CS)
    begin //{
         cb_merged_cs_q_size = tx_gen.bs_merged_cs.size();
         loop_cs_cnt = cb_merged_cs_q_size/4;
         for(int i = 0;i < loop_cs_cnt;i++)
           begin //{
             tmp0_cs =tx_gen.bs_merged_cs[cb_merged_cs_q_size -(4+(i*4))] ; 
             tmp1_cs =tx_gen.bs_merged_cs[cb_merged_cs_q_size -(3+(i*4))] ; 
             tmp2_cs =tx_gen.bs_merged_cs[cb_merged_cs_q_size -(2+(i*4))] ; 
             tmp3_cs =tx_gen.bs_merged_cs[cb_merged_cs_q_size -(1+(i*4))] ; 
             if(tmp0_cs == 9'h11C)
                begin //{
               rand_crc = $urandom_range(1,10);
               if(rand_crc >= 5 && rand_crc <= 8)
                 begin//{
                  tx_gen.bs_merged_cs[cb_merged_cs_q_size -(1+(i*4))][4:8] = 'h0;
                   
              end //}
         end //}
     end //}
     end //}
   else if(tx_gen.m_type == MERGED_PKT)
    begin //{
         cb_merged_pkt_q_size = tx_gen.bs_merged_pkt.size();
         loop_pkt_cnt = cb_merged_pkt_q_size/8;
         for(int i = cb_merged_pkt_q_size;i > 0;i--)
           begin //{
             rand_pkt_ackid = $urandom_range(1,10);
             if(rand_pkt_ackid >= 5 && rand_pkt_ackid <= 8)
             begin //{
             if(tx_gen.bs_merged_pkt[cb_merged_pkt_q_size -i] == 9'h17C && tx_gen.bs_merged_pkt[cb_merged_pkt_q_size -(i-2)][6:8] == 0)
               begin //{
                tx_gen.bs_merged_pkt[cb_merged_pkt_q_size - (i-4)][1:6] = 0;
              end //}
          end //}
          end //}
     end//}
   endtask
endclass

//=========== callback to corrupt CS and PKT to generate PNACK with different cause GEN2=========

class srio_pl_pnack_diff_cause_gen2_err_cb extends srio_pl_callback;
bit [0:8] tmp0_cs,tmp1_cs,tmp2_cs,tmp3_cs,tmp4_cs,tmp5_cs,tmp6_cs,tmp7_cs,tmp8_cs;
bit [0:8] tmp0_pkt,tmp1_pkt,tmp2_pkt,tmp3_pkt,tmp4_pkt,tmp5_pkt,tmp6_pkt,tmp7_pkt,tmp8_pkt;
bit [0:12] cal_crc13;
bit [0:37] tmp_crc;
int pkt_size;
srio_pl_agent pl_agent_cb ; 
int cnt;
rand int rand_crc,rand_pkt_ackid;
logic [0:8] cb_mergered_pkt[$];
logic [0:8] cb_mergered_cs[$];
int cb_merged_cs_q_size;
int cb_merged_pkt_q_size;
int loop_cs_cnt,loop_pkt_cnt;
bit ackid_crc_err;
function new (string name = "srio_pl_pnack_diff_cause_gen2_err_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_pnack_diff_cause_gen2_err_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_trans_transmit(ref srio_pl_data_trans tx_gen,srio_trans srio_trans_in);
  if(tx_gen.m_type == MERGED_CS)
    begin //{
         cb_merged_cs_q_size = tx_gen.bs_merged_cs.size();
         loop_cs_cnt = cb_merged_cs_q_size/8;
         for(int i = 0;i < loop_cs_cnt;i++)
           begin //{
             tmp0_cs =tx_gen.bs_merged_cs[cb_merged_cs_q_size -(8+(i*8))] ; 
             tmp1_cs =tx_gen.bs_merged_cs[cb_merged_cs_q_size -(7+(i*8))] ; 
             tmp2_cs =tx_gen.bs_merged_cs[cb_merged_cs_q_size -(6+(i*8))] ; 
             tmp3_cs =tx_gen.bs_merged_cs[cb_merged_cs_q_size -(5+(i*8))] ; 
             tmp4_cs =tx_gen.bs_merged_cs[cb_merged_cs_q_size -(4+(i*8))] ; 
             tmp5_cs =tx_gen.bs_merged_cs[cb_merged_cs_q_size -(3+(i*8))] ; 
             tmp6_cs =tx_gen.bs_merged_cs[cb_merged_cs_q_size -(2+(i*8))] ; 
             tmp7_cs =tx_gen.bs_merged_cs[cb_merged_cs_q_size -(1+(i*8))] ; 
             if(tmp0_cs == 9'h11C)
                begin //{
               rand_crc = $urandom_range(1,10);
               if(rand_crc >= 5 && rand_crc <= 8)
                 begin//{
                  tx_gen.bs_merged_cs[cb_merged_cs_q_size -(2+(i*8))][1:8] = 'h0;
                  tx_gen.bs_merged_cs[cb_merged_cs_q_size -(3+(i*8))][4:8] = 'h0;
                   
              end //}
         end //}
     end //}
     end //}

   else if(tx_gen.m_type == MERGED_PKT)
    begin //{
         cb_merged_pkt_q_size = tx_gen.bs_merged_pkt.size();
         loop_pkt_cnt = cb_merged_pkt_q_size/8;
         for(int i = cb_merged_pkt_q_size;i > 0;i--)
           begin //{
             rand_pkt_ackid = $urandom_range(1,10);
             if(rand_pkt_ackid >= 5 && rand_pkt_ackid <= 8)
             begin //{
             if(tx_gen.bs_merged_pkt[cb_merged_pkt_q_size -i] == 9'h17C && tx_gen.bs_merged_pkt[cb_merged_pkt_q_size -(i-7)] == 9'h17C  && tx_gen.bs_merged_pkt[cb_merged_pkt_q_size -(i-2)][8] == 0 && tx_gen.bs_merged_pkt[cb_merged_pkt_q_size -(i-3)][1:2] == 0)
               begin //{
                ackid_crc_err = $urandom;
                if(ackid_crc_err)
                tx_gen.bs_merged_pkt[cb_merged_pkt_q_size - (i-8)][1:6] = 5;
              end //}
          end //}
          end //}
     end //}
   endtask
endclass

//=========== callback to corrupt CS and PKT to generate PNACK with different cause GEN3 =========

class srio_pl_pnack_diff_cause_gen3_err_cb extends srio_pl_callback;
bit [0:65] tmp0_cs,tmp1_cs,tmp2_cs,tmp3_cs,tmp4_cs,tmp5_cs,tmp6_cs,tmp7_cs,tmp8_cs;
bit [0:65] tmp0_pkt,tmp1_pkt,tmp2_pkt,tmp3_pkt,tmp4_pkt,tmp5_pkt,tmp6_pkt,tmp7_pkt,tmp8_pkt;
bit [0:12] cal_crc13;
bit [0:37] tmp_crc;
int pkt_size;
srio_pl_agent pl_agent_cb ; 
int cnt;
bit flag;
rand int rand_crc,rand_pkt_ackid;
rand int pkt_crc_sel;
logic [0:8] cb_mergered_pkt[$];
logic [0:8] cb_mergered_cs[$];
int cb_merged_cs_q_size;
int cb_merged_pkt_q_size;
int loop_cs_cnt,loop_pkt_cnt;

function new (string name = "srio_pl_pnack_diff_cause_gen3_err_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_pnack_diff_cause_gen3_err_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_trans_transmit(ref srio_pl_data_trans tx_gen,srio_trans srio_trans_in);
   if(tx_gen.m_type == MERGED_CS && flag == 1)
    begin //{
         cb_merged_cs_q_size = tx_gen.brc3_merged_cs.size();
         for(int i = 0;i < cb_merged_cs_q_size;i++)
           begin //{
             tmp0_cs =tx_gen.brc3_merged_cs[i] ; 
             if(tmp0_cs[0:1] == 2 && (tmp0_cs[32:33] == 2'b10 || tmp0_cs[32:33] == 2'b11))
                begin //{
               rand_crc = $urandom_range(1,10);
               if(rand_crc >= 5 && rand_crc <= 8)
                 begin//{
                  tx_gen.brc3_merged_cs[i][8:31] = 'h0;
                   
              end //}
         end //}
     end //}
     end //}

   else if(tx_gen.m_type == MERGED_PKT && flag == 1)
    begin //{
         cb_merged_pkt_q_size = tx_gen.brc3_merged_pkt.size();
         for(int i = 0;i < cb_merged_pkt_q_size;i++)
           begin //{
            tmp0_pkt =tx_gen.brc3_merged_pkt[i] ;
 
            rand_pkt_ackid = $urandom_range(1,10);
            if(rand_pkt_ackid >= 5 && rand_pkt_ackid <= 8)
             begin
           if(tx_gen.brc3_merged_pkt[i][0:1]==2 && tx_gen.brc3_merged_pkt[i][32:33]==2 )
             begin
              tx_gen.brc3_merged_pkt[i][34:39]= 'h8;
             end
            end
          end //}
           pkt_crc_sel = $urandom_range(1,10);
         if(pkt_crc_sel >= 5 && pkt_crc_sel <= 8)
         begin //{
         tmp1_pkt =tx_gen.brc3_merged_pkt[0] ;  
         tmp2_pkt =tx_gen.brc3_merged_pkt[1] ;  
         tmp3_pkt =tx_gen.brc3_merged_pkt[2] ; 
           if(tmp1_pkt[32:33] == 2'b01 && tmp2_pkt[32:33] == 2'b10)
              begin
                if(tmp3_pkt[0:1] == 2'b01)
                    begin
                      tx_gen.brc3_merged_pkt[2][5] = ! tx_gen.brc3_merged_pkt[2][5];
                     end
              end
          end //}

     end //}

   endtask
endclass

//=========== callback to corrupt PKT to generate PNACK with ackid cause ========

class srio_pl_pnack_ackid_cause_err_cb extends srio_pl_callback;
bit [0:8] tmp0_pkt,tmp1_pkt,tmp2_pkt,tmp3_pkt,tmp4_pkt,tmp5_pkt,tmp6_pkt,tmp7_pkt,tmp8_pkt;
int pkt_size;
srio_pl_agent pl_agent_cb ; 
int cnt,err_pkt_cnt;
rand int rand_crc,rand_pkt_ackid;
logic [0:8] cb_mergered_pkt[$];
logic [0:8] cb_mergered_cs[$];
int cb_merged_cs_q_size;
int cb_merged_pkt_q_size;
int loop_cs_cnt,loop_pkt_cnt;
bit ackid_crc_err,flag,corruption_done;
function new (string name = "srio_pl_pnack_ackid_cause_err_cb"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_pnack_ackid_cause_err_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction
 virtual task srio_pl_trans_transmit(ref srio_pl_data_trans tx_gen,srio_trans srio_trans_in);
                
   if(corruption_done == 1)
   cnt = cnt+1;
   if(tx_gen.m_type == MERGED_PKT && flag == 1 && cnt<= err_pkt_cnt)
    begin //{
         cb_merged_pkt_q_size = tx_gen.bs_merged_pkt.size();
         loop_pkt_cnt = cb_merged_pkt_q_size/8;
         for(int i = cb_merged_pkt_q_size;i > 0;i--)
           begin //{
             //rand_pkt_ackid = $urandom_range(1,10); //for random insertion
             rand_pkt_ackid = 6;
             if(rand_pkt_ackid >= 5 && rand_pkt_ackid <= 8)
             begin //{
             if(tx_gen.bs_merged_pkt[cb_merged_pkt_q_size -i] == 9'h17C && tx_gen.bs_merged_pkt[cb_merged_pkt_q_size -(i-7)] == 9'h17C  && tx_gen.bs_merged_pkt[cb_merged_pkt_q_size -(i-2)][8] == 0 && tx_gen.bs_merged_pkt[cb_merged_pkt_q_size -(i-3)][1:2] == 0)
               begin //{
                ackid_crc_err = 1;
                if(ackid_crc_err)
                begin
                tx_gen.bs_merged_pkt[cb_merged_pkt_q_size - (i-8)][1:6] = 5;
                corruption_done = 1;
                end
                else
                corruption_done = 0;
              end //}
          end //}
          end //}
     end //}
   endtask
endclass

// GEN3 -- CORRUPTION CODEWORD LOCK - DESCRAMBLER SEED - SKIP ORDER CORRUPTION AFTER LINK INIT
class srio_pl_gen3_cwl_descr_seed_skip_order_corrup_cb extends srio_pl_callback; 
bit [0:66] brc3_cg_temp_0,brc3_cg_temp_1,brc3_cg_temp_2,brc3_cg_temp_3;
int cwl_cnt_0,cwl_corupt_cnt_0;
int cwl_cnt_1,cwl_corupt_cnt_1;
int cwl_cnt_2,cwl_corupt_cnt_2;
int cwl_cnt_3,cwl_corupt_cnt_3;
int descr_seed_cnt_0,descr_seed_corupt_cnt_0;
int descr_seed_cnt_1,descr_seed_corupt_cnt_1;
int descr_seed_cnt_2,descr_seed_corupt_cnt_2;
int descr_seed_cnt_3,descr_seed_corupt_cnt_3;
int skip_order_cnt_0,skip_order_corupt_cnt_0;
int skip_order_cnt_1,skip_order_corupt_cnt_1;
int skip_order_cnt_2,skip_order_corupt_cnt_2;
int skip_order_cnt_3,skip_order_corupt_cnt_3;
int status_control_cw_cnt_0,status_control_cw_corupt_cnt_0;
int status_control_cw_cnt_1,status_control_cw_corupt_cnt_1;
int status_control_cw_cnt_2,status_control_cw_corupt_cnt_2;
int status_control_cw_cnt_3,status_control_cw_corupt_cnt_3;
bit [3:0] no_cwl_cnt_0 = 3;
bit [3:0] no_cwl_cnt_1 = 3;
bit [3:0] no_cwl_cnt_2 = 3;
bit [3:0] no_cwl_cnt_3 = 3;
bit [3:0] no_descr_seed_cnt_0 = 3;
bit [3:0] no_descr_seed_cnt_1 = 3;
bit [3:0] no_descr_seed_cnt_2 = 3;
bit [3:0] no_descr_seed_cnt_3 = 3;
bit [3:0] no_skip_order_cnt_0 = 3;
bit [3:0] no_skip_order_cnt_1 = 3;
bit [3:0] no_skip_order_cnt_2 = 3;
bit [3:0] no_skip_order_cnt_3 = 3;
bit [3:0] no_status_control_cw_cnt_0 = 3;
bit [3:0] no_status_control_cw_cnt_1 = 3;
bit [3:0] no_status_control_cw_cnt_2 = 3;
bit [3:0] no_status_control_cw_cnt_3 = 3;
bit  flag_0 = 1;

static string type_name = "srio_pl_gen3_cwl_descr_seed_skip_order_corrup_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 
function new (string name = "srio_pl_gen3_cwl_descr_seed_skip_order_corrup_cb"); 
super.new(name); 
endfunction
 
virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp_0 = tx_srio_cg.brc3_cg;
if(env_config.srio_mode == SRIO_GEN30 && (env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))
  begin
    if(brc3_cg_temp_0[0] != brc3_cg_temp_0[1])
      begin 
       if(cwl_cnt_0 != 64) 
         begin
          cwl_cnt_0 = cwl_cnt_0 + 1;
           if(cwl_cnt_0 == 50 && cwl_corupt_cnt_0 < no_cwl_cnt_0)
             begin 
              cwl_corupt_cnt_0 = cwl_corupt_cnt_0 + 1;
              tx_srio_cg.brc3_cg[1:2] = 2'b11 ;
             end
         end
       else
         begin 
          cwl_cnt_0 = 0;
         end
      end
    if(~brc3_cg_temp_0[2] && ((~brc3_cg_temp_0[0] && brc3_cg_temp_0[33:38] == 6'b001101)||(brc3_cg_temp_0[0] && brc3_cg_temp_0[33:38] == 6'b110010)))
      begin 
       if(descr_seed_cnt_0 != 6) 
         begin
          descr_seed_cnt_0 = descr_seed_cnt_0 + 1;
           if(descr_seed_cnt_0 == 5 && descr_seed_corupt_cnt_0 < no_descr_seed_cnt_0)
             begin 
              descr_seed_corupt_cnt_0 = descr_seed_corupt_cnt_0 + 1;
              tx_srio_cg.brc3_cg[3:32] = 30'h3fff_ffff ;
              tx_srio_cg.brc3_cg[39:66] = 28'hfff_ffff ;
             end
         end
       else
         begin 
          descr_seed_cnt_0 = 0;
         end
      end
    if(~brc3_cg_temp_0[2] && ((~brc3_cg_temp_0[0] && brc3_cg_temp_0[33:38] == 6'b001111)||(brc3_cg_temp_0[0] && brc3_cg_temp_0[33:38] == 6'b110000)))
      begin 
       if(status_control_cw_cnt_0 != 4) 
         begin
          status_control_cw_cnt_0 = status_control_cw_cnt_0 + 1;
           if(status_control_cw_cnt_0 == 3 && status_control_cw_corupt_cnt_0 < no_status_control_cw_cnt_0)
             begin 
              status_control_cw_corupt_cnt_0 = status_control_cw_corupt_cnt_0 + 1;
              tx_srio_cg.brc3_cg[3:32] = 30'h3fff_ffff ;
              tx_srio_cg.brc3_cg[39:66] = 28'hfff_ffff ;
             end
         end
       else
         begin 
          status_control_cw_cnt_0 = 0;
         end
      end

    if(~brc3_cg_temp_0[2] && ((~brc3_cg_temp_0[0] && brc3_cg_temp_0[33:38] == 6'b001011)||(brc3_cg_temp_0[0] && brc3_cg_temp_0[33:38] == 6'b110100)))
      begin 
       if(skip_order_cnt_0 != 4) 
         begin
          skip_order_cnt_0 = skip_order_cnt_0 + 1;
           if(skip_order_cnt_0 == 3 && skip_order_corupt_cnt_0 < no_skip_order_cnt_0)
             begin 
              skip_order_corupt_cnt_0 = skip_order_corupt_cnt_0 + 1;
              tx_srio_cg.brc3_cg[3:32] = 30'h3fff_ffff ;
              tx_srio_cg.brc3_cg[39:66] = 28'hfff_ffff ;
             end
         end
       else
         begin 
          skip_order_cnt_0 = 0;
         end
      end
end
endtask

virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp_1 = tx_srio_cg.brc3_cg;
if(env_config.srio_mode == SRIO_GEN30 && (env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))
  begin
    if(brc3_cg_temp_1[0] != brc3_cg_temp_1[1])
      begin 
       if(cwl_cnt_1 != 64) 
         begin
          cwl_cnt_1 = cwl_cnt_1 + 1;
           if(cwl_cnt_1 == 50 && cwl_corupt_cnt_1 < no_cwl_cnt_1)
             begin 
              cwl_corupt_cnt_1 = cwl_corupt_cnt_1 + 1;
              tx_srio_cg.brc3_cg[1:2] = 2'b11 ;
             end
         end
       else
         begin 
          cwl_cnt_1 = 0;
         end
      end
    if(~brc3_cg_temp_1[2] && ((~brc3_cg_temp_1[0] && brc3_cg_temp_1[33:38] == 6'b001101)||(brc3_cg_temp_1[0] && brc3_cg_temp_1[33:38] == 6'b110010)))
      begin 
       if(descr_seed_cnt_1 != 6) 
         begin
          descr_seed_cnt_1 = descr_seed_cnt_1 + 1;
           if(descr_seed_cnt_1 == 5 && descr_seed_corupt_cnt_1 < no_descr_seed_cnt_1)
             begin 
              descr_seed_corupt_cnt_1 = descr_seed_corupt_cnt_1 + 1;
              tx_srio_cg.brc3_cg[3:32] = 30'h3fff_ffff ;
             end
         end
       else
         begin 
          descr_seed_cnt_1 = 0;
         end
      end
    if(~brc3_cg_temp_1[2] && ((~brc3_cg_temp_1[0] && brc3_cg_temp_1[33:38] == 6'b001111)||(brc3_cg_temp_1[0] && brc3_cg_temp_1[33:38] == 6'b110000)))
      begin 
       if(status_control_cw_cnt_1 != 4) 
         begin
          status_control_cw_cnt_1 = status_control_cw_cnt_1 + 1;
           if(status_control_cw_cnt_1 == 3 && status_control_cw_corupt_cnt_1 < no_status_control_cw_cnt_1)
             begin 
              status_control_cw_corupt_cnt_1 = status_control_cw_corupt_cnt_1 + 1;
              tx_srio_cg.brc3_cg[3:32] = 30'h3fff_ffff ;
              tx_srio_cg.brc3_cg[39:66] = 28'hfff_ffff ;
             end
         end
       else
         begin 
          status_control_cw_cnt_1 = 0;
         end
      end

    if(~brc3_cg_temp_1[2] && ((~brc3_cg_temp_1[0] && brc3_cg_temp_1[33:38] == 6'b001011)||(brc3_cg_temp_1[0] && brc3_cg_temp_1[33:38] == 6'b110100)))
      begin 
       if(skip_order_cnt_1 != 4) 
         begin
          skip_order_cnt_1 = skip_order_cnt_1 + 1;
           if(skip_order_cnt_1 == 3 && skip_order_corupt_cnt_1 < no_skip_order_cnt_1)
             begin 
              skip_order_corupt_cnt_1 = skip_order_corupt_cnt_1 + 1;
              tx_srio_cg.brc3_cg[3:32] = 30'h3fff_ffff ;
             end
         end
       else
         begin 
          skip_order_cnt_1 = 0;
         end
      end
end
endtask

virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp_2 = tx_srio_cg.brc3_cg;
if(env_config.srio_mode == SRIO_GEN30 && (env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))
  begin
    if(brc3_cg_temp_2[0] != brc3_cg_temp_2[1])
      begin 
       if(cwl_cnt_2 != 64) 
         begin
          cwl_cnt_2 = cwl_cnt_2 + 1;
           if(cwl_cnt_2 == 50 && cwl_corupt_cnt_2 < no_cwl_cnt_2)
             begin 
              cwl_corupt_cnt_2 = cwl_corupt_cnt_2 + 1;
              tx_srio_cg.brc3_cg[1:2] = 2'b11 ;
             end
         end
       else
         begin 
          cwl_cnt_2 = 0;
         end
      end
    if(~brc3_cg_temp_2[2] && ((~brc3_cg_temp_2[0] && brc3_cg_temp_2[33:38] == 6'b001101)||(brc3_cg_temp_2[0] && brc3_cg_temp_2[33:38] == 6'b110010)))
      begin 
       if(descr_seed_cnt_2 != 6) 
         begin
          descr_seed_cnt_2 = descr_seed_cnt_2 + 1;
           if(descr_seed_cnt_2 == 5 && descr_seed_corupt_cnt_2 < no_descr_seed_cnt_2)
             begin 
              descr_seed_corupt_cnt_2 = descr_seed_corupt_cnt_2 + 1;
              tx_srio_cg.brc3_cg[3:32] = 30'h3fff_ffff ;
             end
         end
       else
         begin 
          descr_seed_cnt_2 = 0;
         end
      end
    if(~brc3_cg_temp_2[2] && ((~brc3_cg_temp_2[0] && brc3_cg_temp_2[33:38] == 6'b001111)||(brc3_cg_temp_2[0] && brc3_cg_temp_2[33:38] == 6'b110000)))
      begin 
       if(status_control_cw_cnt_2 != 4) 
         begin
          status_control_cw_cnt_2 = status_control_cw_cnt_2 + 1;
           if(status_control_cw_cnt_2 == 3 && status_control_cw_corupt_cnt_2 < no_status_control_cw_cnt_2)
             begin 
              status_control_cw_corupt_cnt_2 = status_control_cw_corupt_cnt_2 + 1;
              tx_srio_cg.brc3_cg[3:32] = 30'h3fff_ffff ;
              tx_srio_cg.brc3_cg[39:66] = 28'hfff_ffff ;
             end
         end
       else
         begin 
          status_control_cw_cnt_2 = 0;
         end
      end

    if(~brc3_cg_temp_2[2] && ((~brc3_cg_temp_2[0] && brc3_cg_temp_2[33:38] == 6'b001011)||(brc3_cg_temp_2[0] && brc3_cg_temp_2[33:38] == 6'b110100)))
      begin 
       if(skip_order_cnt_2 != 4) 
         begin
          skip_order_cnt_2 = skip_order_cnt_2 + 1;
           if(skip_order_cnt_2 == 3 && skip_order_corupt_cnt_2 < no_skip_order_cnt_2)
             begin 
              skip_order_corupt_cnt_2 = skip_order_corupt_cnt_2 + 1;
              tx_srio_cg.brc3_cg[3:32] = 30'h3fff_ffff ;
             end
         end
       else
         begin 
          skip_order_cnt_2 = 0;
         end
      end
end
endtask

virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp_3 = tx_srio_cg.brc3_cg;
if(env_config.srio_mode == SRIO_GEN30 && (env_config.pl_mon_tx_link_initialized == 1) && (env_config.pl_mon_rx_link_initialized == 1))
  begin
    if(brc3_cg_temp_3[0] != brc3_cg_temp_3[1])
      begin 
       if(cwl_cnt_3 != 64) 
         begin
          cwl_cnt_3 = cwl_cnt_3 + 1;
           if(cwl_cnt_3 == 50 && cwl_corupt_cnt_3 < no_cwl_cnt_3)
             begin 
              cwl_corupt_cnt_3 = cwl_corupt_cnt_3 + 1;
              tx_srio_cg.brc3_cg[1:2] = 2'b11 ;
             end
         end
       else
         begin 
          cwl_cnt_3 = 0;
         end
      end
    if(~brc3_cg_temp_3[2] && ((~brc3_cg_temp_3[0] && brc3_cg_temp_3[33:38] == 6'b001101)||(brc3_cg_temp_3[0] && brc3_cg_temp_3[33:38] == 6'b110010)))
      begin 
       if(descr_seed_cnt_3 != 6) 
         begin
          descr_seed_cnt_3 = descr_seed_cnt_3 + 1;
           if(descr_seed_cnt_3 == 5 && descr_seed_corupt_cnt_3 < no_descr_seed_cnt_3)
             begin 
              descr_seed_corupt_cnt_3 = descr_seed_corupt_cnt_3 + 1;
              tx_srio_cg.brc3_cg[3:32] = 30'h3fff_ffff ;
             end
         end
       else
         begin 
          descr_seed_cnt_3 = 0;
         end
      end
    if(~brc3_cg_temp_3[2] && ((~brc3_cg_temp_3[0] && brc3_cg_temp_3[33:38] == 6'b001111)||(brc3_cg_temp_3[0] && brc3_cg_temp_3[33:38] == 6'b110000)))
      begin 
       if(status_control_cw_cnt_3 != 4) 
         begin
          status_control_cw_cnt_3 = status_control_cw_cnt_3 + 1;
           if(status_control_cw_cnt_3 == 3 && status_control_cw_corupt_cnt_3 < no_status_control_cw_cnt_3)
             begin 
              status_control_cw_corupt_cnt_3 = status_control_cw_corupt_cnt_3 + 1;
              tx_srio_cg.brc3_cg[3:32] = 30'h3fff_ffff ;
              tx_srio_cg.brc3_cg[39:66] = 28'hfff_ffff ;
             end
         end
       else
         begin 
          status_control_cw_cnt_3 = 0;
         end
      end

    if(~brc3_cg_temp_3[2] && ((~brc3_cg_temp_3[0] && brc3_cg_temp_3[33:38] == 6'b001011)||(brc3_cg_temp_3[0] && brc3_cg_temp_3[33:38] == 6'b110100)))
      begin 
       if(skip_order_cnt_3 != 4) 
         begin
          skip_order_cnt_3 = skip_order_cnt_3 + 1;
           if(skip_order_cnt_3 == 3 && skip_order_corupt_cnt_3 < no_skip_order_cnt_3)
             begin 
              skip_order_corupt_cnt_3 = skip_order_corupt_cnt_3 + 1;
              tx_srio_cg.brc3_cg[3:32] = 30'h3fff_ffff ;
             end
         end
       else
         begin 
          skip_order_cnt_3 = 0;
         end
      end
end
endtask
endclass

//================================================================================ 
//== GEN3 callback to breqk sync of lane 0,1,2,3 
//================================================================================ 

class srio_pl_gen3_sync_break_callback extends srio_pl_callback;

bit flag_0,flag_1,flag_2,flag_3 ;
int cnt_0 = 0;
int cnt_1 = 0;
int cnt_2 = 0;
int cnt_3 = 0;
 
function new (string name = "srio_pl_gen3_sync_break_callback"); 
super.new(name); 
endfunction 

static string type_name = "srio_pl_gen3_sync_break_callback"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 

virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(env_config.srio_mode == SRIO_GEN30 && flag_0 == 1) begin //{
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
    cnt_0 = cnt_0+1;
    if(cnt_0 > 4)
    flag_0 = 0;
end
endtask 

virtual task srio_pl_cg_generated_lane1(ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(env_config.srio_mode == SRIO_GEN30 && flag_1 == 1) begin //{
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
    cnt_1 = cnt_1+1;
    if(cnt_1 > 4)
    flag_1 = 0;
end
endtask 

virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(env_config.srio_mode == SRIO_GEN30 && flag_2 == 1) begin //{
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
    cnt_2 = cnt_2+1;
    if(cnt_2 > 4)
    flag_2 = 0;
end
endtask 

virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config);
   if(env_config.srio_mode == SRIO_GEN30 && flag_3 == 1) begin //{
    tx_srio_cg.cg =10'h100;
    tx_srio_cg.brc3_cg ='h0;
    cnt_3 = cnt_3+1;
    if(cnt_3 > 4)
    flag_3 = 0;
end
endtask 
endclass : srio_pl_gen3_sync_break_callback

// GEN3 -- CORRUPTION CODEWORD LOCK - DESCRAMBLER SEED - SKIP ORDER CORRUPTION RANDOM CORRUPTION
class srio_pl_gen3_cwl_descr_seed_skip_order_rand_corrup_cb extends srio_pl_callback; 
bit [0:66] brc3_cg_temp_0,brc3_cg_temp_1,brc3_cg_temp_2,brc3_cg_temp_3;
int cwl_cnt_0,cwl_corupt_cnt_0;
int cwl_cnt_1,cwl_corupt_cnt_1;
int cwl_cnt_2,cwl_corupt_cnt_2;
int cwl_cnt_3,cwl_corupt_cnt_3;
int descr_seed_cnt_0,descr_seed_corupt_cnt_0;
int descr_seed_cnt_1,descr_seed_corupt_cnt_1;
int descr_seed_cnt_2,descr_seed_corupt_cnt_2;
int descr_seed_cnt_3,descr_seed_corupt_cnt_3;
int skip_order_cnt_0,skip_order_corupt_cnt_0;
int skip_order_cnt_1,skip_order_corupt_cnt_1;
int skip_order_cnt_2,skip_order_corupt_cnt_2;
int skip_order_cnt_3,skip_order_corupt_cnt_3;
int status_control_cw_cnt_0,status_control_cw_corupt_cnt_0;
int status_control_cw_cnt_1,status_control_cw_corupt_cnt_1;
int status_control_cw_cnt_2,status_control_cw_corupt_cnt_2;
int status_control_cw_cnt_3,status_control_cw_corupt_cnt_3;
bit [7:0] no_cwl_cnt_0 = 30;
bit [7:0] no_cwl_cnt_1 = 30;
bit [7:0] no_cwl_cnt_2 = 30;
bit [7:0] no_cwl_cnt_3 = 30;
bit [7:0] no_descr_seed_cnt_0 = 30;
bit [7:0] no_descr_seed_cnt_1 = 30;
bit [7:0] no_descr_seed_cnt_2 = 30;
bit [7:0] no_descr_seed_cnt_3 = 30;
bit [7:0] no_skip_order_cnt_0 = 30;
bit [7:0] no_skip_order_cnt_1 = 30;
bit [7:0] no_skip_order_cnt_2 = 30;
bit [7:0] no_skip_order_cnt_3 = 30;
bit [7:0] no_status_control_cw_cnt_0 = 30;
bit [7:0] no_status_control_cw_cnt_1 = 30;
bit [7:0] no_status_control_cw_cnt_2 = 30;
bit [7:0] no_status_control_cw_cnt_3 = 30;
bit  flag_0 = 1;
rand bit [3:0] rand_hit;
static string type_name = "srio_pl_gen3_cwl_descr_seed_skip_order_rand_corrup_cb"; 

virtual function string get_type_name(); 
return type_name; 
endfunction 
function new (string name = "srio_pl_gen3_cwl_descr_seed_skip_order_rand_corrup_cb"); 
super.new(name); 
endfunction
 
virtual task srio_pl_cg_generated_lane0 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp_0 = tx_srio_cg.brc3_cg;
if(env_config.srio_mode == SRIO_GEN30)
  begin
    if(brc3_cg_temp_0[0] != brc3_cg_temp_0[1])
      begin 
       if(cwl_cnt_0 != 64) 
         begin
          cwl_cnt_0 = cwl_cnt_0 + 1;
           if(cwl_cnt_0 == 50 && cwl_corupt_cnt_0 < no_cwl_cnt_0)
             begin 
              rand_hit = $urandom_range(1,10);
              if(rand_hit <= 5 && rand_hit >= 1)
              begin
              cwl_corupt_cnt_0 = cwl_corupt_cnt_0 + 1;
              tx_srio_cg.brc3_cg[1:2] = 2'b11 ;
              `uvm_info("GEN3_CALLBACK_ERR",$sformatf("CODEWORD_LOCK is corrupted"),UVM_LOW);
              end
             end
         end
       else
         begin 
          cwl_cnt_0 = 0;
         end
      end
    if(~brc3_cg_temp_0[2] && ((~brc3_cg_temp_0[0] && brc3_cg_temp_0[33:38] == 6'b001101)||(brc3_cg_temp_0[0] && brc3_cg_temp_0[33:38] == 6'b110010)))
      begin 
       if(descr_seed_cnt_0 != 6) 
         begin
          descr_seed_cnt_0 = descr_seed_cnt_0 + 1;
           if(descr_seed_cnt_0 == 5 && descr_seed_corupt_cnt_0 < no_descr_seed_cnt_0)
             begin
              if(rand_hit <= 5 && rand_hit >= 1)
              begin 
              descr_seed_corupt_cnt_0 = descr_seed_corupt_cnt_0 + 1;
              tx_srio_cg.brc3_cg[3:32] = 30'h3fff_ffff ;
              tx_srio_cg.brc3_cg[39:66] = 28'hfff_ffff ;
              `uvm_info("GEN3_CALLBACK_ERR",$sformatf("DESCRAMBLER_SEED is corrupted"),UVM_LOW);
              end
             end
         end
       else
         begin 
          descr_seed_cnt_0 = 0;
         end
      end
    if(~brc3_cg_temp_0[2] && ((~brc3_cg_temp_0[0] && brc3_cg_temp_0[33:38] == 6'b001111)||(brc3_cg_temp_0[0] && brc3_cg_temp_0[33:38] == 6'b110000)))
      begin 
       if(status_control_cw_cnt_0 != 4) 
         begin
          status_control_cw_cnt_0 = status_control_cw_cnt_0 + 1;
           if(status_control_cw_cnt_0 == 3 && status_control_cw_corupt_cnt_0 < no_status_control_cw_cnt_0)
             begin 
              if(rand_hit <= 5 && rand_hit >= 1)
              begin
              status_control_cw_corupt_cnt_0 = status_control_cw_corupt_cnt_0 + 1;
              tx_srio_cg.brc3_cg[3:32] = 30'h3fff_ffff ;
              tx_srio_cg.brc3_cg[39:66] = 28'hfff_ffff ;
              `uvm_info("GEN3_CALLBACK_ERR",$sformatf("STATUS_CNTRL CW is corrupted"),UVM_LOW);
              end
             end
         end
       else
         begin 
          status_control_cw_cnt_0 = 0;
         end
      end

    if(~brc3_cg_temp_0[2] && ((~brc3_cg_temp_0[0] && brc3_cg_temp_0[33:38] == 6'b001011)||(brc3_cg_temp_0[0] && brc3_cg_temp_0[33:38] == 6'b110100)))
      begin 
       if(skip_order_cnt_0 != 4) 
         begin
          skip_order_cnt_0 = skip_order_cnt_0 + 1;
           if(skip_order_cnt_0 == 3 && skip_order_corupt_cnt_0 < no_skip_order_cnt_0)
             begin 
              if(rand_hit <= 5 && rand_hit >= 1)
              begin
              skip_order_corupt_cnt_0 = skip_order_corupt_cnt_0 + 1;
              tx_srio_cg.brc3_cg[3:32] = 30'h3fff_ffff ;
              tx_srio_cg.brc3_cg[39:66] = 28'hfff_ffff ;
              `uvm_info("GEN3_CALLBACK_ERR",$sformatf("SKIP ORDER is corrupted"),UVM_LOW);
              end
             end
         end
       else
         begin 
          skip_order_cnt_0 = 0;
         end
      end
end
endtask

virtual task srio_pl_cg_generated_lane1 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp_1 = tx_srio_cg.brc3_cg;
if(env_config.srio_mode == SRIO_GEN30)
  begin
    if(brc3_cg_temp_1[0] != brc3_cg_temp_1[1])
      begin 
       if(cwl_cnt_1 != 64) 
         begin
          cwl_cnt_1 = cwl_cnt_1 + 1;
           if(cwl_cnt_1 == 50 && cwl_corupt_cnt_1 < no_cwl_cnt_1)
             begin 
              if(rand_hit <= 5 && rand_hit >= 1)
              begin
              cwl_corupt_cnt_1 = cwl_corupt_cnt_1 + 1;
              tx_srio_cg.brc3_cg[1:2] = 2'b11 ;
              `uvm_info("GEN3_CALLBACK_ERR",$sformatf("CODEWORD_LOCK is corrupted"),UVM_LOW);
              end
             end
         end
       else
         begin 
          cwl_cnt_1 = 0;
         end
      end
    if(~brc3_cg_temp_1[2] && ((~brc3_cg_temp_1[0] && brc3_cg_temp_1[33:38] == 6'b001101)||(brc3_cg_temp_1[0] && brc3_cg_temp_1[33:38] == 6'b110010)))
      begin 
       if(descr_seed_cnt_1 != 6) 
         begin
          descr_seed_cnt_1 = descr_seed_cnt_1 + 1;
           if(descr_seed_cnt_1 == 5 && descr_seed_corupt_cnt_1 < no_descr_seed_cnt_1)
             begin 
              if(rand_hit <= 5 && rand_hit >= 1)
              begin
              descr_seed_corupt_cnt_1 = descr_seed_corupt_cnt_1 + 1;
              tx_srio_cg.brc3_cg[3:32] = 30'h3fff_ffff ;
              `uvm_info("GEN3_CALLBACK_ERR",$sformatf("DESCRAMBLER_SEED is corrupted"),UVM_LOW);
              end
             end
         end
       else
         begin 
          descr_seed_cnt_1 = 0;
         end
      end
    if(~brc3_cg_temp_1[2] && ((~brc3_cg_temp_1[0] && brc3_cg_temp_1[33:38] == 6'b001111)||(brc3_cg_temp_1[0] && brc3_cg_temp_1[33:38] == 6'b110000)))
      begin 
       if(status_control_cw_cnt_1 != 4) 
         begin
          status_control_cw_cnt_1 = status_control_cw_cnt_1 + 1;
           if(status_control_cw_cnt_1 == 3 && status_control_cw_corupt_cnt_1 < no_status_control_cw_cnt_1)
             begin 
              if(rand_hit <= 5 && rand_hit >= 1)
              begin
              status_control_cw_corupt_cnt_1 = status_control_cw_corupt_cnt_1 + 1;
              tx_srio_cg.brc3_cg[3:32] = 30'h3fff_ffff ;
              tx_srio_cg.brc3_cg[39:66] = 28'hfff_ffff ;
              `uvm_info("GEN3_CALLBACK_ERR",$sformatf("STATUS_CNTRL CW is corrupted"),UVM_LOW);
              end
             end
         end
       else
         begin 
          status_control_cw_cnt_1 = 0;
         end
      end

    if(~brc3_cg_temp_1[2] && ((~brc3_cg_temp_1[0] && brc3_cg_temp_1[33:38] == 6'b001011)||(brc3_cg_temp_1[0] && brc3_cg_temp_1[33:38] == 6'b110100)))
      begin 
       if(skip_order_cnt_1 != 4) 
         begin
          skip_order_cnt_1 = skip_order_cnt_1 + 1;
           if(skip_order_cnt_1 == 3 && skip_order_corupt_cnt_1 < no_skip_order_cnt_1)
             begin 
              if(rand_hit <= 5 && rand_hit >= 1)
              begin
              skip_order_corupt_cnt_1 = skip_order_corupt_cnt_1 + 1;
              tx_srio_cg.brc3_cg[3:32] = 30'h3fff_ffff ;
              `uvm_info("GEN3_CALLBACK_ERR",$sformatf("SKIP_ORDER is corrupted"),UVM_LOW);
              end
             end
         end
       else
         begin 
          skip_order_cnt_1 = 0;
         end
      end
end
endtask

virtual task srio_pl_cg_generated_lane2 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp_2 = tx_srio_cg.brc3_cg;
if(env_config.srio_mode == SRIO_GEN30 )
  begin
    if(brc3_cg_temp_2[0] != brc3_cg_temp_2[1])
      begin 
       if(cwl_cnt_2 != 64) 
         begin
          cwl_cnt_2 = cwl_cnt_2 + 1;
           if(cwl_cnt_2 == 50 && cwl_corupt_cnt_2 < no_cwl_cnt_2)
             begin 
              if(rand_hit <= 5 && rand_hit >= 1)
              begin
              cwl_corupt_cnt_2 = cwl_corupt_cnt_2 + 1;
              tx_srio_cg.brc3_cg[1:2] = 2'b11 ;
              `uvm_info("GEN3_CALLBACK_ERR",$sformatf("CODEWORD_LOCK is corrupted"),UVM_LOW);
              end
             end
         end
       else
         begin 
          cwl_cnt_2 = 0;
         end
      end
    if(~brc3_cg_temp_2[2] && ((~brc3_cg_temp_2[0] && brc3_cg_temp_2[33:38] == 6'b001101)||(brc3_cg_temp_2[0] && brc3_cg_temp_2[33:38] == 6'b110010)))
      begin 
       if(descr_seed_cnt_2 != 6) 
         begin
          descr_seed_cnt_2 = descr_seed_cnt_2 + 1;
           if(descr_seed_cnt_2 == 5 && descr_seed_corupt_cnt_2 < no_descr_seed_cnt_2)
             begin 
              if(rand_hit <= 5 && rand_hit >= 1)
              begin
              descr_seed_corupt_cnt_2 = descr_seed_corupt_cnt_2 + 1;
              tx_srio_cg.brc3_cg[3:32] = 30'h3fff_ffff ;
              `uvm_info("GEN3_CALLBACK_ERR",$sformatf("DESCRAMBLER_SEED is corrupted"),UVM_LOW);
              end
             end
         end
       else
         begin 
          descr_seed_cnt_2 = 0;
         end
      end
    if(~brc3_cg_temp_2[2] && ((~brc3_cg_temp_2[0] && brc3_cg_temp_2[33:38] == 6'b001111)||(brc3_cg_temp_2[0] && brc3_cg_temp_2[33:38] == 6'b110000)))
      begin 
       if(status_control_cw_cnt_2 != 4) 
         begin
          status_control_cw_cnt_2 = status_control_cw_cnt_2 + 1;
           if(status_control_cw_cnt_2 == 3 && status_control_cw_corupt_cnt_2 < no_status_control_cw_cnt_2)
             begin 
              if(rand_hit <= 5 && rand_hit >= 1)
              begin
              status_control_cw_corupt_cnt_2 = status_control_cw_corupt_cnt_2 + 1;
              tx_srio_cg.brc3_cg[3:32] = 30'h3fff_ffff ;
              tx_srio_cg.brc3_cg[39:66] = 28'hfff_ffff ;
              `uvm_info("GEN3_CALLBACK_ERR",$sformatf("STATUS_CNTR CW is corrupted"),UVM_LOW);
              end
             end
         end
       else
         begin 
          status_control_cw_cnt_2 = 0;
         end
      end

    if(~brc3_cg_temp_2[2] && ((~brc3_cg_temp_2[0] && brc3_cg_temp_2[33:38] == 6'b001011)||(brc3_cg_temp_2[0] && brc3_cg_temp_2[33:38] == 6'b110100)))
      begin 
       if(skip_order_cnt_2 != 4) 
         begin
          skip_order_cnt_2 = skip_order_cnt_2 + 1;
           if(skip_order_cnt_2 == 3 && skip_order_corupt_cnt_2 < no_skip_order_cnt_2)
             begin 
              if(rand_hit <= 5 && rand_hit >= 1)
              begin
              skip_order_corupt_cnt_2 = skip_order_corupt_cnt_2 + 1;
              tx_srio_cg.brc3_cg[3:32] = 30'h3fff_ffff ;
              `uvm_info("GEN3_CALLBACK_ERR",$sformatf("SKIP_ORDER is corrupted"),UVM_LOW);
              end
             end
         end
       else
         begin 
          skip_order_cnt_2 = 0;
         end
      end
end
endtask

virtual task srio_pl_cg_generated_lane3 (ref srio_pl_lane_data tx_srio_cg,srio_env_config env_config); 
     brc3_cg_temp_3 = tx_srio_cg.brc3_cg;
if(env_config.srio_mode == SRIO_GEN30)
  begin
    if(brc3_cg_temp_3[0] != brc3_cg_temp_3[1])
      begin 
       if(cwl_cnt_3 != 64) 
         begin
          cwl_cnt_3 = cwl_cnt_3 + 1;
           if(cwl_cnt_3 == 50 && cwl_corupt_cnt_3 < no_cwl_cnt_3)
             begin 
              if(rand_hit <= 5 && rand_hit >= 1)
              begin
              cwl_corupt_cnt_3 = cwl_corupt_cnt_3 + 1;
              tx_srio_cg.brc3_cg[1:2] = 2'b11 ;
              `uvm_info("GEN3_CALLBACK_ERR",$sformatf("CODEWORD_LOCK is corrupted"),UVM_LOW);
              end
             end
         end
       else
         begin 
          cwl_cnt_3 = 0;
         end
      end
    if(~brc3_cg_temp_3[2] && ((~brc3_cg_temp_3[0] && brc3_cg_temp_3[33:38] == 6'b001101)||(brc3_cg_temp_3[0] && brc3_cg_temp_3[33:38] == 6'b110010)))
      begin 
       if(descr_seed_cnt_3 != 6) 
         begin
          descr_seed_cnt_3 = descr_seed_cnt_3 + 1;
           if(descr_seed_cnt_3 == 5 && descr_seed_corupt_cnt_3 < no_descr_seed_cnt_3)
             begin 
              if(rand_hit <= 5 && rand_hit >= 1)
              begin
              descr_seed_corupt_cnt_3 = descr_seed_corupt_cnt_3 + 1;
              tx_srio_cg.brc3_cg[3:32] = 30'h3fff_ffff ;
              `uvm_info("GEN3_CALLBACK_ERR",$sformatf("DESCRAMBLER_SEED is corrupted"),UVM_LOW);
              end
             end
         end
       else
         begin 
          descr_seed_cnt_3 = 0;
         end
      end
    if(~brc3_cg_temp_3[2] && ((~brc3_cg_temp_3[0] && brc3_cg_temp_3[33:38] == 6'b001111)||(brc3_cg_temp_3[0] && brc3_cg_temp_3[33:38] == 6'b110000)))
      begin 
       if(status_control_cw_cnt_3 != 4) 
         begin
          status_control_cw_cnt_3 = status_control_cw_cnt_3 + 1;
           if(status_control_cw_cnt_3 == 3 && status_control_cw_corupt_cnt_3 < no_status_control_cw_cnt_3)
             begin 
              if(rand_hit <= 5 && rand_hit >= 1)
              begin
              status_control_cw_corupt_cnt_3 = status_control_cw_corupt_cnt_3 + 1;
              tx_srio_cg.brc3_cg[3:32] = 30'h3fff_ffff ;
              tx_srio_cg.brc3_cg[39:66] = 28'hfff_ffff ;
              `uvm_info("GEN3_CALLBACK_ERR",$sformatf("STATUS_CNTRL CW is corrupted"),UVM_LOW);
              end
             end
         end
       else
         begin 
          status_control_cw_cnt_3 = 0;
         end
      end

    if(~brc3_cg_temp_3[2] && ((~brc3_cg_temp_3[0] && brc3_cg_temp_3[33:38] == 6'b001011)||(brc3_cg_temp_3[0] && brc3_cg_temp_3[33:38] == 6'b110100)))
      begin 
       if(skip_order_cnt_3 != 4) 
         begin
          skip_order_cnt_3 = skip_order_cnt_3 + 1;
           if(skip_order_cnt_3 == 3 && skip_order_corupt_cnt_3 < no_skip_order_cnt_3)
             begin 
              if(rand_hit <= 5 && rand_hit >= 1)
              begin
              skip_order_corupt_cnt_3 = skip_order_corupt_cnt_3 + 1;
              tx_srio_cg.brc3_cg[3:32] = 30'h3fff_ffff ;
              `uvm_info("GEN3_CALLBACK_ERR",$sformatf("SKIP_ORDER is corrupted"),UVM_LOW);
              end
             end
         end
       else
         begin 
          skip_order_cnt_3 = 0;
         end
      end
end
endtask
endclass

