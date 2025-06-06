module traffic_light_controller (
    input clk,           // traffic light r timing k manipulate koribo
    input reset,         // will reset the controller to base state (eyat red loisu)
    output reg red,      // RED light control signal
    output reg yellow,   // YELLOW light control signal
    output reg green     // GREEN light control signal
);

    // each state k (green, yellow and red k) 2-bit binary t convert korisu- 00, 01 aaru 10 (11 can be imagined as don't care in this case)
    parameter GREEN = 2'b00, 
              YELLOW = 2'b01, 
              RED = 2'b10;

    // current state and the next state of the traffic light
    reg [1:0] state, next_state;

    // timer to keep track of how long we’ve been in the current state
    reg [3:0] timer;

    // [x:0] mane: 4 bits in total. i.e. 0000 to 1111

    // this block runs on every rising edge of the clock or when reset is triggered
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // reset hole RED state ole gusi jua and reset the timer
            state <= RED;
            timer <= 0;
        end 
        else begin
            // update the state to the next state
            state <= next_state;

            // timer will count up to a max value depending on the state
            // for GREEN and RED, it goes to 9 (i.e., 10 cycles)
            // for yellow, it goes to 4 (i.e., 5 cycles)
            if (timer == 4'd9)
                timer <= 0;
            else
                timer <= timer + 1;
        end
    end

    // combinational logic to decide what is next state
    // and which light (RED, YELLOW, GREEN) should be on
    always @(*) begin
        // by default sob off
        red = 0;
        yellow = 0;
        green = 0;

        // setting lights and next state based on current state and timer
        // this is a switch case code
        case (state)
            GREEN: begin
                green = 1; // Turn on GREEN light
                // after 10 clock cycles in GREEN, switch to YELLOW
                next_state = (timer == 4'd9) ? YELLOW : GREEN;
            end

            YELLOW: begin
                yellow = 1; // Turn on YELLOW light
                // after 5 clock cycles in YELLOW, switch to RED
                next_state = (timer == 4'd4) ? RED : YELLOW;
            end

            RED: begin
                red = 1; // Turn on RED light
                // after 10 clock cycles in RED, switch to GREEN
                next_state = (timer == 4'd9) ? GREEN : RED;
            end

            default: begin
                // safety net: in case of undefined input, go to RED
                next_state = RED;
            end
        endcase
    end

endmodule
