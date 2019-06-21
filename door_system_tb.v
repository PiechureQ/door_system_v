`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/18/2019 07:38:19 PM
// Design Name: 
// Module Name: door_system_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module door_system_tb;

// inputs
reg clk;
reg reset;
reg sensor_entrance;
reg sensor_exit;
reg card_valid;

// outputs
wire GREEN_LED;
wire RED_LED;
wire door_status;

// Unit Under Test (UUT)
door_system uut (
    clk, 
    reset, 
    sensor_entrance, 
    sensor_exit, 
    card_valid, 
    GREEN_LED, 
    RED_LED,
    door_status
);


always begin
    //set clock
    #10 clk = ~clk;

end


initial begin
    // init input
    reset = 1;
    sensor_entrance = 0;
    sensor_exit = 0;
    card_valid = 0;
    clk = 0;
    
    //test
    #100 reset = 0;
    
    #1000 sensor_entrance = 1;
    
    #1250 card_valid = 1;
    #1750 card_valid = 0;

    #2000 sensor_exit = 1;
    
    #2250 card_valid = 1;
    #2750 card_valid = 0;

    #3000 sensor_entrance = 0;
    
    #3500 card_valid = 1;
    
    #4000;
    sensor_exit = 0;
    card_valid = 0;

end
  
endmodule