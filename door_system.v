`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/18/2019 07:36:11 PM
// Design Name: 
// Module Name: door_system
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

//todo rename card_valid na card valid
module door_system(
    input clk,
    input reset,
    
    input sensor_entrance, 
    input sensor_exit, 
    
    input card_valid,
    
    output wire GREEN_LED,
    output wire RED_LED,
    output wire door_status
 );
 
parameter IDLE = 3'b000, 
          WAIT_CARD = 3'b001, 
          WRONG_CARD = 3'b010, 
          RIGHT_CARD = 3'b011,
          ENTER_FIRST = 3'b100;
          
reg[2:0] current_state, 
         next_state;
          
reg[31:0] counter_wait;
 
reg red_tmp,
    green_tmp,
    door_status_tmp;
     
    
always @(posedge clk or posedge reset) begin

    //change state to next on every clock
    if(reset) begin
        current_state = IDLE;
    end else begin
        current_state = next_state;
    end

    //counter wait for card
    if(current_state== WAIT_CARD) begin
        counter_wait <= counter_wait + 1;
    end else begin
        counter_wait <= 0;
    end
    
 end
 
// change state
always @(*) begin
    case(current_state)
        IDLE: begin //if sensor entrence wait for card
            if(sensor_entrance == 1 || sensor_exit == 1) begin
                next_state = WAIT_CARD;
            end else begin
                next_state = IDLE;
            end
        end
        WAIT_CARD: begin //check if card is correct
            if(counter_wait <= 3) begin // keep waiting for 3 cycles
                next_state = WAIT_CARD;
            end else if(card_valid == 1) begin
                next_state = RIGHT_CARD;
            end else begin
                next_state = WRONG_CARD;
            end
        end
        WRONG_CARD: begin //check card again
            if(card_valid == 1) begin
                next_state = RIGHT_CARD;
            end else begin
                next_state = WRONG_CARD;
            end
        end
        RIGHT_CARD: begin //if card is correct proced to open door
            if(sensor_entrance==1 && sensor_exit == 1) begin //if enter on both sides then proceed entering first
                next_state = ENTER_FIRST;
            end else begin
                next_state = IDLE;
            end
        end
        ENTER_FIRST: begin
            if(card_valid == 1) begin
                next_state = RIGHT_CARD;
            end else begin
                next_state = ENTER_FIRST;
            end
        end
        default: begin 
            next_state = IDLE;
        end
    endcase
end

// LEDs and output 
//blink green if correct CARD
//blick red if waiting for card
always @(posedge clk) begin 
    case(current_state)
        IDLE: begin
            green_tmp = 0;
            red_tmp = 0;
            door_status_tmp = 0;
        end
        WAIT_CARD: begin
            green_tmp = 0;
            red_tmp = 1;
            door_status_tmp = 0;
        end
        WRONG_CARD: begin
            green_tmp = 0;
            red_tmp = ~red_tmp;
            door_status_tmp = 0;
        end
        RIGHT_CARD: begin
            green_tmp = ~green_tmp;
            red_tmp = 0;
            door_status_tmp = 1;
        end
        ENTER_FIRST: begin
            green_tmp = 0;
            red_tmp = ~red_tmp;
            door_status_tmp = 0;
        end
    endcase
end
 
assign RED_LED = red_tmp;
assign GREEN_LED = green_tmp;
assign door_status = door_status_tmp;

endmodule
