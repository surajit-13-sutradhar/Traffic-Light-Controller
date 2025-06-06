// testbench for the traffic_light_controller module
`timescale 1ns / 1ps // set time unit to 1 ns and time precision to 1 ps

module tb_traffic_light;

    // declaring signals to connect to the traffic light controller
    reg clk;             // clock signal
    reg reset;           // reset signal
    wire red, yellow, green; // outputs from the module (leds)

    // instantiating the unit under test (uut)
    traffic_light_controller uut (
        .clk(clk),
        .reset(reset),
        .red(red),
        .yellow(yellow),
        .green(green)
    );

    // this initial block runs once at the beginning of simulation
    initial begin
        // print a header for readability
        $display("time\tred\tyellow\tgreen");

        // continuously monitor and print the output values during simulation
        $monitor("%0t\t%b\t%b\t%b", $time, red, yellow, green);

        // dump waveform data to a .vcd file (for viewing with gtkwave)
        $dumpfile("traffic_light.vcd");         // name of output vcd file
        $dumpvars(0, tb_traffic_light);         // record all variables in this module

        // initialize clock and reset
        clk = 0;        // start clock at 0
        reset = 1;      // activate reset to initialize the system
        #5 reset = 0;   // after 5 time units, deactivate reset
    end

    // clock generation: toggle clk every 5 time units (10 units total = 1 full clock cycle)
    always #5 clk = ~clk;

    // automatically stop the simulation after 200 time units
    initial begin
        #200 $finish;
    end

endmodule
