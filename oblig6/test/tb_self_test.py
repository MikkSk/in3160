import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

secret_rom = [
    (0x1,0x2),
    (0x3,0x4),
    (0x4,0x0),
    (0x0,0x0),
    (0x5,0x6),
    (0x7,0x3),
    (0x0,0x0),
    (0x8,0x6),
    (0x9,0x0),
    (0x0,0x0),
    (0xA,0xB),
    (0x3,0x0),
    (0x0,0x0),
    (0xC,0x6),
    (0x6,0x5),
    (0x0,0x0)
]

@cocotb.test()
async def self_test_tb(dut):

    dut._log.info("starting test")
    cocotb.start_soon(Clock(dut.mclk, 10, unit = "ns").start())

    #reset
    dut.reset.value = 1
    await RisingEdge(dut.mclk)
    await RisingEdge(dut.mclk)
    dut.reset.value = 0

    #next relevant tick
    await RisingEdge(dut.second_tick)

    #going through ROM
    for i, (d1_expected,d0_expected) in enumerate(secret_rom):

        d1 = int(dut.d1.value)
        d0 = int(dut.d0.value)

        assert d1 == d1_expected,f"step{i}:got {d1},expected {d1_expected})"
        assert d0 == d0_expected,f"step{i}:got {d0},expected {d0_expected})"
        
        await RisingEdge(dut.second_tick)
        
        dut._log.info(f"step{i} pass: d1={d1_expected:X} d0={d0_expected:X}")

        dut._log.info("test pass")
