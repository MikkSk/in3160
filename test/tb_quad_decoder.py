import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer

CLK_PERIOD_NS = 10  # 100 MHz

async def reset_dut(dut):
    dut.reset.value = 1
    dut.SA.value = 0
    dut.SB.value = 0
    await Timer(50, units="ns")
    dut.reset.value = 0
    await RisingEdge(dut.mclk)


async def apply_state(dut, a, b):
    dut.SA.value = a
    dut.SB.value = b
    await RisingEdge(dut.mclk)


async def check_pulse(signal, expected, name):
    if expected:
        assert signal.value == 1, f"{name} should be HIGH"
    else:
        assert signal.value == 0, f"{name} should be LOW"


@cocotb.test()
async def test_forward_rotation(dut):

    cocotb.start_soon(Clock(dut.mclk, CLK_PERIOD_NS, units="ns").start())
    await reset_dut(dut)

    # Forward sequence
    seq = [(0,0), (0,1), (1,1), (1,0), (0,0)]

    pulse_count = 0

    for i in range(2):  # repeat twice
        for (a, b) in seq:
            await apply_state(dut, a, b)

            if dut.pos_inc.value == 1:
                pulse_count += 1

            # Ensure no reverse pulse
            assert dut.pos_dec.value == 0, "Unexpected pos_dec during forward"

    assert pulse_count > 0, "No forward pulses detected"

@cocotb.test()
async def test_reverse_rotation(dut):

    cocotb.start_soon(Clock(dut.mclk, CLK_PERIOD_NS, units="ns").start())
    await reset_dut(dut)

    # Reverse sequence
    seq = [(0,0), (1,0), (1,1), (0,1), (0,0)]

    pulse_count = 0

    for i in range(2):
        for (a, b) in seq:
            await apply_state(dut, a, b)

            if dut.pos_dec.value == 1:
                pulse_count += 1

            # Ensure no forward pulse
            assert dut.pos_inc.value == 0, "Unexpected pos_inc during reverse"

    assert pulse_count > 0, "No reverse pulses detected"


@cocotb.test()
async def test_single_cycle_pulses(dut):
    cocotb.start_soon(Clock(dut.mclk, CLK_PERIOD_NS, units="ns").start())
    await reset_dut(dut)

    seq = [(0,0), (0,1), (1,1), (1,0), (0,0)]

    for (a, b) in seq:
        await apply_state(dut, a, b)
        await RisingEdge(dut.mclk)  # Wait for clock edge
        
        # Check for pos_inc pulse
        if dut.pos_inc.value == 1:
            await RisingEdge(dut.mclk)
            assert dut.pos_inc.value == 0, "pos_inc not 1-cycle pulse"

        # Check for pos_dec pulse
        if dut.pos_dec.value == 1:
            await RisingEdge(dut.mclk)
            assert dut.pos_dec.value == 0, "pos_dec not 1-cycle pulse"



@cocotb.test()
async def test_invalid_transition(dut):

    cocotb.start_soon(Clock(dut.mclk, CLK_PERIOD_NS, units="ns").start())
    await reset_dut(dut)

    # Jump invalid: 00 -> 11
    await apply_state(dut, 0, 0)
    await apply_state(dut, 1, 1)

    # Should not produce pulses
    assert dut.pos_inc.value == 0, "Invalid transition caused pos_inc"
    assert dut.pos_dec.value == 0, "Invalid transition caused pos_dec"



@cocotb.test()
async def test_reset(dut):

    cocotb.start_soon(Clock(dut.mclk, CLK_PERIOD_NS, units="ns").start())

    dut.reset.value = 1
    dut.SA.value = 1
    dut.SB.value = 1

    await Timer(50, units="ns")
    dut.reset.value = 0

    await RisingEdge(dut.mclk)

    assert dut.pos_inc.value == 0
    assert dut.pos_dec.value == 0
