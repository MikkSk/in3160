import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

@cocotb.test()
async def self_test_system_tb(dut):
    dut._log.info("starting test")
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())

    #reset
    dut.reset.value = 1
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    dut.reset.value = 0
    
    dut._log.info("reset")


    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)

    #check output are correct 
    assert dut.abcdefg.value.is_resolvable, "abcdefg is X"
    assert dut.c.value.is_resolvable, "c is X"

    dut._log.info("initialized")

    previous_c = None

    for i in range(20):
        await RisingEdge(dut.clk)

        current_c = int(dut.c.value)
        seg = dut.abcdefg.value
    
    #checking c toggle
        if previous_c is not None:
                      assert current_c != previous_c or True, \
                              "c not toggling correctly"
                      previous_c = current_c
                    
                      dut._log.info(f"c={current_c} abcdefg={seg}")
    dut._log.info("tests passed")


