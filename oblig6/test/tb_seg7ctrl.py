import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ReadOnly, Timer
from tb_bin2ssd_test import bin2ssd #importing truth table

@cocotb.test()
async def seg7ctrl_test(dut):
    dut._log.info("Starting seg7ctrl test")
    cocotb.start_soon(Clock(dut.mclk, 10, unit ="ns").start())

    #applying reset
    dut.reset.value = 1
    dut.d0.value = 0
    dut.d1.value = 0
    await RisingEdge(dut.mclk)
    await RisingEdge(dut.mclk)
    dut.reset.value = 0
    await RisingEdge(dut.mclk)
    
    #test values
    d0_val = 0x3
    d1_val = 0xA
    dut.d0.value = d0_val
    dut.d1.value = d1_val

    seen_c0 = False
    seen_c1 = False
    
    for _ in range (400000):
        await RisingEdge(dut.mclk)
        await ReadOnly()
        c_val = int(dut.c.value)
        seg_val = int(dut.abcdefg.value)

        if c_val == 0:
            expected = bin2ssd[d0_val]
            assert seg_val == expected, \
                    f"c=0, wrong output. Got{seg_val:07b} expected{expected:07b}"
            seen_c0 = True
        else:
            expected = bin2ssd[d1_val]
            assert seg_val == expected, \
                    f"c=1, wrong output. Got{seg_val:07b} expected{expected:07b}"
            seen_c1 = True
    assert seen_c0 and seen_c1, "Multiplexing did not work"
    dut._log.info("seg7ctrl passed")

