from math import ceil, fabs, log

from .node import *
from .util import *
from .avalon_config import AvalonConfig
def main(config_path=""):
    config = AvalonConfig.parse_json(config_path + "./model.json")
    generate_avalon_wrapper(config.registers, config.audio_in, config.audio_out, config.working_dir)

def generate_avalon_wrapper(registers, audio_in, audio_out, working_dir=""):

    avalon_entity_ports = [
        Port(PortDir.In, "clk"),
        Port(PortDir.In, "reset"),
        Port(PortDir.In, "avalon_sink_valid"),
        Port(PortDir.In, "avalon_sink_data", 32),
        Port(PortDir.In, "avalon_sink_channel", 2),
        Port(PortDir.In, "avalon_sink_error", 2),
        Port(PortDir.Out, "avalon_source_valid"),
        Port(PortDir.Out, "avalon_source_data", 32),
        Port(PortDir.Out, "avalon_source_channel", 2),
        Port(PortDir.Out, "avalon_source_error", 2),
        Port(PortDir.In, "avalon_slave_address", 2),
        Port(PortDir.In, "avalon_slave_read"),
        Port(PortDir.Out, "avalon_slave_readdata", 32),
        Port(PortDir.In, "avalon_slave_write"),
        Port(PortDir.In, "avalon_slave_writedata")
    ]
    avalon_entity = Entity("BC_dataplane_avalon", avalon_entity_ports)

    avalon_architecture = Architecture(f"{avalon_entity.name}_arch", avalon_entity)

    arch_signals = [
        Signal("enable", 1, "1"),
        Signal("bits", 6, "100000"),
        Signal("wet_dry_mix", 8, "01000000")
    ]

    dataplane = Component("BC_dataplane", [
        Port(PortDir.In, "clk"),
        Port(PortDir.In, "reset"),
        Port(PortDir.In, "clk_enable"),
        Port(PortDir.In, "avalon_sink_valid"),
        Port(PortDir.In, "avalon_sink_data", audio_in.word_len),
        Port(PortDir.In, "avalon_sink_channel", 2),
        Port(PortDir.In, "avalon_sink_error", 2),
        Port(PortDir.In, "register_control_enable", 1),
        Port(PortDir.In, "register_control_bits", 6),
        Port(PortDir.In, "register_control_wet_dry_mix", 8),
        Port(PortDir.Out, "ce_out"),
        Port(PortDir.Out, "avalon_source_valid"),
        Port(PortDir.Out, "avalon_source_data", audio_out.word_len),
        Port(PortDir.Out, "avalon_source_channel", 2),
        Port(PortDir.Out, "avalon_source_error", 2),
    ])

    avalon_architecture.components = [dataplane]
    avalon_architecture.signals = arch_signals

    # Create PortMap
    ## {Port, Signal}
    port_map = {
        dataplane.getPort("clk") : avalon_entity.getPort("clk"),
        dataplane.getPort("reset") : avalon_entity.getPort("reset"),
        dataplane.getPort("clk_enable") : LiteralSignal('1'),
        dataplane.getPort("avalon_sink_valid") : avalon_entity.getPort("avalon_sink_valid"),
        dataplane.getPort("avalon_sink_data") : avalon_entity.getPort("avalon_sink_data"),
        dataplane.getPort("avalon_sink_channel") : avalon_entity.getPort("avalon_sink_channel"),
        dataplane.getPort("avalon_sink_error") : avalon_entity.getPort("avalon_sink_error"),
        dataplane.getPort("avalon_source_valid") : avalon_entity.getPort("avalon_source_valid"),
        dataplane.getPort("avalon_source_data") : avalon_entity.getPort("avalon_source_data"),
        dataplane.getPort("avalon_source_channel") : avalon_entity.getPort("avalon_source_channel"),
        dataplane.getPort("avalon_source_error") : avalon_entity.getPort("avalon_source_error"),
    }

    for reg in registers:
        reg_signal = next(port for port in arch_signals if port.name == reg.name)
        port_map[dataplane.getPort(f"register_control_{reg.name}")] = reg_signal

    dataplane.port_map = PortMap(f"u_{dataplane.name}", port_map, dataplane)

    bus_read = Process("bus_read")
    bus_read.sensitivity_list = [avalon_entity.getPort("clk")]
    bus_read.logic = create_bus_read_logic(registers)

    bus_write = Process("bus_write")
    bus_write.sensitivity_list = avalon_entity.getPorts("clk", "reset")
    bus_write.logic = create_bus_write_logic(registers)

    avalon_architecture.processes = [bus_read, bus_write]

    libraries = [
        Library("ieee", [
            "std_logic_1164",
            "numeric_std"
        ])
    ]

    avalon_wrapper = EntityFile(avalon_entity.name, avalon_entity, avalon_architecture, libraries)
    avalon_wrapper.write(working_dir)

## Bus read/write still need signed support

def create_bus_read_logic(registers):
    data_out = "avalon_slave_readdata"
    read_enable = "avalon_slave_read"
    avalon_slave_address = "avalon_slave_address"

    logic_string = ""
    logic_string += tab() + f"if rising_edge(clk) and {read_enable} = '1' then \n"
    logic_string += tab(2) + f"case {avalon_slave_address} is\n"

    addr_width = int(ceil(log(len(registers), 2)))
    for idx, reg in enumerate(registers):
        addr = "{0:0{1}b}".format(idx, addr_width)
        logic_string += tab(3) + f"when \"{addr}\" => {data_out} <= resize({reg.name}, 32);\n"

    logic_string += tab(3) + f"when others => {data_out} <= (others => '0');\n"
    logic_string += tab(2) + "end case;\n"
    logic_string += tab() + "end if;\n"
    return logic_string

def create_bus_write_logic(registers):
    write_enable = "avalon_slave_write"
    data_in = "avalon_slave_writedata"
    avalon_slave_address = "avalon_slave_address"

    logic_string = ""
    logic_string += tab() +  f"if reset = '1' then \n"
    for reg in registers:
        if reg.word_len == 1:
            default_bit_string = f"'{reg.default}'"
        else:
            default_bit_string = num_to_bitstring(reg.default, reg.word_len, reg.frac_len)
        logic_string += tab(2) + f"{reg.name.ljust(24)} <= {(default_bit_string + ';').ljust(32)} -- {reg.default}\n"

    logic_string += tab() +  f"elsif rising_edge(clk) and {write_enable} = '1' then\n"
    logic_string += tab(2) + f"case {avalon_slave_address} is\n"

    addr_width = int(ceil(log(len(registers), 2)))
    for idx, reg in enumerate(registers):
        addr = "{0:0{1}b}".format(idx, addr_width)
        if reg.word_len == 1:
            avalon_to_reg = f"{data_in}(0)"
        else:
            avalon_to_reg = f"resize({data_in}, {reg.word_len})"
        logic_string += tab(3) + f"when \"{addr}\" => {reg.name} <= {avalon_to_reg};\n"

    logic_string += tab(2) + "end case;\n"
    logic_string += tab() +  "end if;\n"
    return logic_string


