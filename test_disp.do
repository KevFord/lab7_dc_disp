#Restart simulation
restart -f

# Define all input signals, reset active
force clk_50 0 0, 1 10 ns -r 20 ns

force reset 1
force transmit_ready 1
run 2 us

force reset 0
run 21 ns

# Run a short time
run 0.5 us
force transmit_ready 1
force current_dc x"33"
run 21 ns

force current_dc_update 1
run 35 ns
force current_dc_update 0
run 1 us

force current_dc x"64"
run 21 ns

force current_dc_update 1
run 35 ns
force current_dc_update 0
run 21 ns

run 1 us

force current_dc x"7"
run 21 ns

force current_dc_update 1
run 35 ns
force current_dc_update 0
run 21 ns



run 1 us