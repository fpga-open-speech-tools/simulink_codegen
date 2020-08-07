from math import ceil, fabs, log

from .node import *
from .util import *
from .avalon_config import AvalonConfig
def main(config_path="", working_dir=""):
    """Generate an Avalon wrapper for Simulink generated VHDL with a config in the given path.

    Parameters
    ----------
    config_path : str, optional
        Path to directory containing model.json configuration file, by default ""
    working_dir : str, optional
        Directory to output avalon wrapper to, by default ""
        which outputs it to the current directory
    """
    config = AvalonConfig.parse_json(config_path + "./model.json")
    if working_dir == "":
        working_dir = config.working_dir
    generate_avalon_wrapper(config.registers, config.audio_in, config.audio_out, working_dir)

def generate_avalon_wrapper(registers, audio_in, audio_out, working_dir=""):
    """Generate an Avalon wrapper for Simulink generated VHDL.

    Parameters
    ----------
    registers : list of Register
        Registers that are in the dataplane
    audio_in : Audio
        Audio object describing audio input to the dataplane
    audio_out : Audio
        Audio object describing audio output from the dataplane
    working_dir : str, optional
        Directory to output avalon wrapper to, by default "" which is the current directory
    """
    avalon_in_data_type = DataType(32, 28, True)
    avalon_out_data_type = DataType(32, 28, True)

    avalon_entity_ports = [
        Port(PortDir.In, "clk"),
        Port(PortDir.In, "reset"),
        Port(PortDir.In, "avalon_sink_valid"),
        Port(PortDir.In, "avalon_sink_data", 32, "std_logic_vector", avalon_in_data_type),
        Port(PortDir.In, "avalon_sink_channel", 2),
        Port(PortDir.In, "avalon_sink_error", 2),
        Port(PortDir.Out, "avalon_source_valid"),
        Port(PortDir.Out, "avalon_source_data", 32, "std_logic_vector", avalon_out_data_type),
        Port(PortDir.Out, "avalon_source_channel", 2),
        Port(PortDir.Out, "avalon_source_error", 2),
        Port(PortDir.In, "avalon_slave_address", 2),
        Port(PortDir.In, "avalon_slave_read"),
        Port(PortDir.Out, "avalon_slave_readdata", 32),
        Port(PortDir.In, "avalon_slave_write"),
        Port(PortDir.In, "avalon_slave_writedata", 32)
    ]
    avalon_entity = Entity("BC_dataplane_avalon", avalon_entity_ports)

    avalon_architecture = Architecture(f"{avalon_entity.name}_arch", avalon_entity)

    register_signals = [Signal(
        reg.name,
        reg.data_type.word_len,
        reg.default,
        "std_logic" if reg.data_type.word_len == 1 else "std_logic_vector",
        reg.data_type)
                        for reg in registers]
    dataplane_signals = [
        Signal(
            "dataplane_sink_data",
            audio_in.data_type.word_len,
            None,
            "std_logic_vector",
            audio_in.data_type),
        Signal(
            "dataplane_source_data",
            audio_out.data_type.word_len,
            None,
            "std_logic_vector",
            audio_out.data_type
        )
        ]
    register_prefix = "register_control_"
    register_ports = [Port(
        PortDir.In,
        register_prefix + reg.name,
        reg.data_type.word_len,
        "std_logic" if reg.data_type.word_len == 1 else "std_logic_vector",
        reg.data_type)
                      for reg in registers]

    dataplane = Component("BC_dataplane", register_ports + [
        Port(PortDir.In, "clk"),
        Port(PortDir.In, "reset"),
        Port(PortDir.In, "clk_enable"),
        Port(PortDir.In, "avalon_sink_valid"),
        Port(PortDir.In, "avalon_sink_data", audio_in.data_type.word_len, "std_logic_vector", audio_in.data_type),
        Port(PortDir.In, "avalon_sink_channel", 2),
        Port(PortDir.In, "avalon_sink_error", 2),
        Port(PortDir.Out, "ce_out"),
        Port(PortDir.Out, "avalon_source_valid"),
        Port(PortDir.Out, "avalon_source_data", audio_out.data_type.word_len, "std_logic_vector", audio_out.data_type),
        Port(PortDir.Out, "avalon_source_channel", 2),
        Port(PortDir.Out, "avalon_source_error", 2),
    ])

    avalon_architecture.components = [dataplane]
    avalon_architecture.signals = register_signals + dataplane_signals

    avalon_architecture.signal_assignments = {
        avalon_architecture.get_signal("dataplane_sink_data") : avalon_entity.get_port("avalon_sink_data"),
        avalon_entity.get_port("avalon_source_data") : avalon_architecture.get_signal("dataplane_source_data")
    }

    # Create PortMap
    ## {Port, Signal}
    port_map = {
        dataplane.get_port("clk") : avalon_entity.get_port("clk"),
        dataplane.get_port("reset") : avalon_entity.get_port("reset"),
        dataplane.get_port("clk_enable") : LiteralSignal('1'),
        dataplane.get_port("avalon_sink_valid") : avalon_entity.get_port("avalon_sink_valid"),
        dataplane.get_port("avalon_sink_data") : avalon_architecture.get_signal("dataplane_sink_data"),
        dataplane.get_port("avalon_sink_channel") : avalon_entity.get_port("avalon_sink_channel"),
        dataplane.get_port("avalon_sink_error") : avalon_entity.get_port("avalon_sink_error"),
        dataplane.get_port("avalon_source_valid") : avalon_entity.get_port("avalon_source_valid"),
        dataplane.get_port("avalon_source_data") : avalon_architecture.get_signal("dataplane_source_data"),
        dataplane.get_port("avalon_source_channel") : avalon_entity.get_port("avalon_source_channel"),
        dataplane.get_port("avalon_source_error") : avalon_entity.get_port("avalon_source_error"),
    }

    for reg in registers:
        reg_signal = next(port for port in register_signals if port.name == reg.name)
        port_map[dataplane.get_port(f"register_control_{reg.name}")] = reg_signal

    dataplane.port_map = PortMap(f"u_{dataplane.name}", port_map, dataplane)

    bus_read = Process("bus_read")
    bus_read.sensitivity_list = [avalon_entity.get_port("clk")]
    bus_read.logic = create_bus_read_logic(register_signals, avalon_entity.get_port("avalon_slave_readdata"))

    bus_write = Process("bus_write")
    bus_write.sensitivity_list = avalon_entity.get_ports("clk", "reset")
    bus_write.logic = create_bus_write_logic(register_signals, avalon_entity.get_port("avalon_slave_writedata"))

    avalon_architecture.processes = [bus_read, bus_write]

    libraries = [
        Library("ieee", [
            "std_logic_1164",
            "numeric_std"
        ]),
        Library("work", ["fixed_resize_pkg"])
    ]

    avalon_wrapper = EntityFile(avalon_entity.name, avalon_entity, avalon_architecture, libraries)
    avalon_wrapper.write(working_dir)

def create_bus_read_logic(register_signals, avalon_slave_readdata_signal):
    """Create VHDL logic to read register data from dataplane.

    Parameters
    ----------
    register_signals : list of Signal
        Signals connected to dataplane registers
    avalon_slave_readdata_signal : Signal
        Signal that the avalon reads data from

    Returns
    -------
    str
        VHDL code for process logic that reads register data from dataplane signals
    """
    data_out = avalon_slave_readdata_signal
    read_enable = "avalon_slave_read"
    avalon_slave_address = "avalon_slave_address"

    logic_string = ""
    logic_string += tab() + f"if rising_edge(clk) and {read_enable} = '1' then \n"
    logic_string += tab(2) + f"case {avalon_slave_address} is\n"

    addr_width = int(ceil(log(len(register_signals), 2)))
    for idx, reg in enumerate(register_signals):
        addr = "{0:0{1}b}".format(idx, addr_width)
        assignment = data_out.generate_assignment(reg)
        logic_string += tab(3) + f"when \"{addr}\" => {assignment}"

    logic_string += tab(3) + f"when others => {data_out.name} <= (others => '0');\n"
    logic_string += tab(2) + "end case;\n"
    logic_string += tab() + "end if;\n"
    return logic_string

def create_bus_write_logic(register_signals, avalon_slave_writedata_signal):
    """Create VHDL logic to write to dataplane registers.

    Parameters
    ----------
    register_signals : list of Signal
        Signals connected to dataplane registers
    avalon_slave_writedata_signal : Signal
        Signal that the avalon writes data to

    Returns
    -------
    str
        VHDL code for process logic that writes to dataplane register signals
    """
    write_enable = "avalon_slave_write"
    data_in = avalon_slave_writedata_signal
    avalon_slave_address = "avalon_slave_address"

    logic_string = ""
    logic_string += tab() +  f"if reset = '1' then \n"
    for reg in register_signals:
        data_type = reg.underlying_data_type
        if data_type.word_len == 1:
            default_bit_string = f"'{reg.default_value}'"
        else:
            default_bit_string = num_to_bitstring(reg.default_value, data_type.word_len, data_type.frac_len)
        logic_string += tab(2) + f"{reg.name.ljust(24)} <= {(default_bit_string + ';').ljust(32)} -- {reg.default_value}\n"

    logic_string += tab() +  f"elsif rising_edge(clk) and {write_enable} = '1' then\n"
    logic_string += tab(2) + f"case {avalon_slave_address} is\n"

    addr_width = int(ceil(log(len(register_signals), 2)))
    for idx, reg in enumerate(register_signals):
        addr = "{0:0{1}b}".format(idx, addr_width)
        assignment = reg.generate_assignment(data_in)
        logic_string += tab(3) + f"when \"{addr}\" => {assignment}"
    logic_string += tab(3) + "when others => null;"
    logic_string += tab(2) + "end case;\n"
    logic_string += tab() +  "end if;\n"
    return logic_string
