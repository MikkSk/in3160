import cocotb
from cocotb.triggers import Timer, RisingEdge
from cocotb.clock import Clock

sw_list = ["00","01","10","11"]
ld_list = ["1110","1101","1011","1111"] #last value changed from 0111 - 1111

@cocotb.test()
async def main_test(dut):
    
    dut._log.info("Running test...")

    for i, k in zip(sw_list, ld_list):
        dut._log.info(f"Loading value{i}")
        dut.sw.value = i
        await Timer(100, unit = "ns")
        assert dut.ld.value == k, f"ld value not set to{k}"

    await Timer(150, unit="ns")
    dut._log.info("Running test ...done")

