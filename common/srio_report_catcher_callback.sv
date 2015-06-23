////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_report_catcher.sv
// Project :  srio vip
// Purpose :  Demotion and Promotion of uvm messages 
// Author  :  Mobiveil
//
// To demote and promote uvm messages 
////////////////////////////////////////////////////////////////////////////////

class severity_modifier extends uvm_report_catcher;
  uvm_severity severity_list [string];
  uvm_severity final_severity; 

////////////////////////////////////////////////////////////////////////////////
/// Name: config_severity \n 
/// Description: Task to config the severity of uvm_messages \n
/// config_severity
//////////////////////////////////////////////////////////////////////////////// 

  task config_severity(input string e_id, input uvm_severity f_severity);
    severity_list[e_id] = f_severity; 
  endtask

////////////////////////////////////////////////////////////////////////////////
/// Name: catch \n 
/// Description:  call_back function that modifies the severity of uvm msgs \n
/// catch
////////////////////////////////////////////////////////////////////////////////

  virtual function action_e catch();
    if(severity_list.exists(get_id()))    
    begin // {
      final_severity = uvm_severity'(severity_list[get_id]);
      set_severity(final_severity);
    end // }
    return THROW;  
  endfunction
endclass: severity_modifier

class err_demoter extends uvm_report_catcher;
  bit en_err_demote;

////////////////////////////////////////////////////////////////////////////////
/// Name: new \n 
/// Description: Error demoter's new function \n
/// new
////////////////////////////////////////////////////////////////////////////////

  function new(string name="err_demoter");
    super.new(name);
  endfunction

////////////////////////////////////////////////////////////////////////////////
/// Name: catch \n 
/// Description:  call_back function that demotes the uvm_error to uvm_warning\n
/// catch
////////////////////////////////////////////////////////////////////////////////

  virtual function action_e catch();
    if (get_severity()== UVM_ERROR)    
    begin // {
      if (en_err_demote == 1)    
      begin // {
        set_severity(UVM_WARNING);
      end // }
      else     
      begin // {
        set_severity(UVM_ERROR);
      end // }
    end // }
    return THROW;  
  endfunction
endclass: err_demoter

// =============================================================================
