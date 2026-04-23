import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer

@cocotb.test()
async def self_test_waveform(dut):
    """
    Minimal testbench for self_test.vhd
    - Drives mclk
    - Applies reset
    - Observes duty_cycle
    """

    # Start 100 MHz clock (10 ns period)
    cocotb.start_soon(Clock(dut.mclk, 10, units="ns").start())

    # Apply reset for a few clock cycles
    dut.reset.value = 1
    for _ in range(5):
        await RisingEdge(dut.mclk)
    dut.reset.value = 0

    # Run simulation for enough cycles to see ROM steps
    for cycle in range(100):
        await RisingEdge(dut.mclk)
        # Optional: print duty_cycle to console
        dut._log.info(f"Time {cocotb.utils.get_sim_time('ns')} ns: duty_cycle = {dut.duty_cycle.value}")
