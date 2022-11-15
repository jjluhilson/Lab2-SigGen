#include "Vsinegen.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "vbuddy.cpp"

int main (int argc, char **argv, char **env) {
    int i; //counts the number of clock cycles to simulate (used in for loop)
    int clk; //clock signal

    Verilated::commandArgs(argc, argv);
    //init top verilog instance
    Vsinegen* top = new Vsinegen; //instantiate the counter module as Vcounter - name of all generated files. This is the DUT
    //init trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC; //vcdC is the data type we use for the trace file pointer
    top->trace (tfp, 99);
    tfp->open ("sinegen.vcd"); //dump the waveform data to sinegen.vcd
    
    //init vbuddy - port path is in vbuddy.cfg
    if (vbdOpen() != 1) return(-1); //open vbd port, if not found then exit with error code
    vbdHeader("Lab 2: Sig gen");

    //initalize simulation inputs
    top->clk = 1; //top is the name of the top level entity. Only top level signals are visible
    top->rst = 1;
    top->en = 0;
    top->incr = vbdValue();

    //run simulation for many clock cycles
    for (i = 0; i < 1000000; i++) {

        //dump variables into VCD file and toggle clock
        for (clk = 0; clk < 2; clk++) { //for loop that toggles the clock, also outputs trace for each half of the clock cycle. Forces model to evaluate on both edges of the clock
            tfp->dump (2*i + clk); //unit is in picoseconds!
            top->clk = !top->clk;
            top->eval (); //simulates clock cycle in verilator
        }
        
        //send sine value to Vbuddy
        vbdPlot(int(top->dout), 0, 255);
        vbdCycle(i+1);

        //we change the rst and en signals throughout the simulation
        top->rst = (i < 2);
        top->en = (i>4);
        top->incr = vbdValue();

         // either simulation finished, or 'q' is pressed
        if ((Verilated::gotFinish()) || (vbdGetkey()=='q')) 
            exit(0);                // ... exit if finish OR 'q' pressed
    }

    vbdClose();
    tfp->close();
    exit(0);
}