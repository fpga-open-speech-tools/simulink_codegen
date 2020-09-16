from math import ceil, fabs, log

from .vhdl_node import *
from .util import *
from .avalon_config import AvalonConfig

AD1939_DATA_TYPE = DataType(32, 28, True)


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
    generate_avalon_wrapper(config.registers, config.audio_in, config.audio_out,
                            config.entity_name, working_dir, config.is_sample_based)


def generate_avalon_wrapper(registers, audio_in, audio_out, entity_name, working_dir="", is_sample_based=False):
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
    avalon_in_data_type = AD1939_DATA_TYPE
    avalon_out_data_type = AD1939_DATA_TYPE

    addr_width = int(ceil(log(len(registers), 2)))
    if addr_width == 0 and len(registers) == 1:
        addr_width = 1
    channel_in_width = int(ceil(log(audio_in.channel_count, 2)))
    channel_out_width = int(ceil(log(audio_out.channel_count, 2)))

    avalon_entity_ports = [
        Port(PortDir.In, Signal("clk")),
        Port(PortDir.In, Signal("reset")),
        Port(PortDir.In, Signal("avalon_sink_valid")),
        Port(PortDir.In, Signal("avalon_sink_data", 32,
                                None, "std_logic_vector", avalon_in_data_type)),
        Port(PortDir.In, Signal("avalon_sink_channel", channel_in_width, None, "std_logic_vector")),
        Port(PortDir.In, Signal("avalon_sink_error", 2)),
        Port(PortDir.Out, Signal("avalon_source_valid")),
        Port(PortDir.Out, Signal("avalon_source_data", 32,
                                 None, "std_logic_vector", avalon_out_data_type)),
        Port(PortDir.Out, Signal("avalon_source_channel", channel_out_width, None, "std_logic_vector")),
        Port(PortDir.Out, Signal("avalon_source_error", 2)),
        Port(PortDir.In, Signal("avalon_slave_address",
                                addr_width, None, "std_logic_vector")),
        Port(PortDir.In, Signal("avalon_slave_read")),
        Port(PortDir.Out, Signal("avalon_slave_readdata", 32)),
        Port(PortDir.In, Signal("avalon_slave_write")),
        Port(PortDir.In, Signal("avalon_slave_writedata", 32))
    ]
    avalon_entity = Entity(f"{entity_name}_avalon", avalon_entity_ports)

    avalon_architecture = Architecture(
        f"{avalon_entity.name}_arch", avalon_entity)

    register_signals = [
        Signal(
            reg.name,
            reg.data_type.word_len,
            reg.default,
            "std_logic" if reg.data_type.word_len == 1 else "std_logic_vector",
            reg.data_type
        )
        for reg in registers]
    dataplane_signals = create_dataplane_signals(
        audio_in, audio_out, is_sample_based)
    register_prefix = "register_control_"
    register_ports = [
        Port(
            PortDir.In,
            Signal(
                register_prefix + reg.name,
                reg.data_type.word_len,
                None,
                "std_logic" if reg.data_type.word_len == 1 else "std_logic_vector",
                reg.data_type)
        )
        for reg in registers]

    dataplane = create_dataplane_component(
        audio_in, audio_out, register_ports, entity_name, is_sample_based)

    avalon_architecture.components = [dataplane]
    avalon_architecture.signals = register_signals + dataplane_signals

    if not is_sample_based:
        avalon_architecture.signal_assignments = {
            avalon_architecture.get_signal("dataplane_sink_data"): avalon_entity.get_port("avalon_sink_data"),
            avalon_entity.get_port("avalon_source_data"): avalon_architecture.get_signal("dataplane_source_data")
        }

    dataplane.port_map = create_dataplane_port_map(
        dataplane, avalon_entity, registers, register_signals, avalon_architecture, is_sample_based)

    avalon_architecture.processes = create_processes(
        register_signals, dataplane_signals, avalon_entity, is_sample_based)

    libraries = [
        Library("ieee", [
            "std_logic_1164",
            "numeric_std"
        ]),
        Library("work", [
            "fixed_resize_pkg",
            f"{entity_name}_pkg"
        ])
    ]

    avalon_wrapper = EntityFile(
        avalon_entity.name, avalon_entity, avalon_architecture, libraries)
    avalon_wrapper.write(working_dir)


def create_dataplane_component(audio_in, audio_out, register_ports, entity_name, is_sample_based):
    if is_sample_based:
        sink_vhdl_type = f"vector_of_std_logic_vector{audio_in.data_type.word_len}"
        source_vhdl_type = f"vector_of_std_logic_vector{audio_out.data_type.word_len}"
        avalon_sink = [
            Port(
                PortDir.In,
                ArraySignal("avalon_sink_data", sink_vhdl_type, audio_in.channel_count,
                            "std_logic_vector", audio_in.data_type.word_len, audio_in.data_type)
            )
        ]
        avalon_source = [
            Port(
                PortDir.Out,
                ArraySignal("avalon_source_data", source_vhdl_type, audio_out.channel_count,
                            "std_logic_vector", audio_out.data_type.word_len, audio_out.data_type)
            )
        ]
    else:
        channel_in_width = int(ceil(log(audio_in.channel_count, 2)))
        channel_out_width = int(ceil(log(audio_out.channel_count, 2)))
        avalon_sink = [
            Port(PortDir.In, Signal("avalon_sink_valid")),
            Port(PortDir.In, Signal("avalon_sink_data", audio_in.data_type.word_len,
                                    None, "std_logic_vector", audio_in.data_type)),
            Port(PortDir.In, Signal("avalon_sink_channel", channel_in_width, None, "std_logic_vector")),
            Port(PortDir.In, Signal("avalon_sink_error", 2)),
        ]
        avalon_source = [
            Port(PortDir.Out, Signal("avalon_source_valid")),
            Port(PortDir.Out, Signal("avalon_source_data", audio_out.data_type.word_len,
                                     None, "std_logic_vector", audio_out.data_type)),
            Port(PortDir.Out, Signal("avalon_source_channel", channel_out_width, None, "std_logic_vector")),
            Port(PortDir.Out, Signal("avalon_source_error", 2)),
        ]
    return Component(entity_name, register_ports + [
        Port(PortDir.In, Signal("clk")),
        Port(PortDir.In, Signal("reset")),
        Port(PortDir.In, Signal("clk_enable")),
        *avalon_sink,
        Port(PortDir.Out, Signal("ce_out")),
        *avalon_source
    ])


def create_dataplane_port_map(dataplane, entity, registers, register_signals, architecture, is_sample_based):
    avalon_port_map = {
        dataplane.get_port("avalon_sink_data"): architecture.get_signal("dataplane_sink_data"),
        dataplane.get_port("avalon_source_data"): architecture.get_signal("dataplane_source_data")
    }

    if not is_sample_based:
        avalon_port_map.update({
            dataplane.get_port("avalon_sink_valid"): entity.get_port("avalon_sink_valid"),
            dataplane.get_port("avalon_sink_channel"): entity.get_port("avalon_sink_channel"),
            dataplane.get_port("avalon_sink_error"): entity.get_port("avalon_sink_error"),
            dataplane.get_port("avalon_source_valid"): entity.get_port("avalon_source_valid"),
            dataplane.get_port("avalon_source_channel"): entity.get_port("avalon_source_channel"),
            dataplane.get_port("avalon_source_error"): entity.get_port("avalon_source_error"),
        })

    port_map = {
        dataplane.get_port("clk"): entity.get_port("clk"),
        dataplane.get_port("reset"): entity.get_port("reset"),
        dataplane.get_port("clk_enable"): LiteralSignal('1'),
        **avalon_port_map
    }

    for reg in registers:
        reg_signal = next(
            port for port in register_signals if port.name == reg.name)
        port_map[dataplane.get_port(
            f"register_control_{reg.name}")] = reg_signal
    return PortMap(f"u_{dataplane.name}", port_map, dataplane)


def create_processes(register_signals, dataplane_signals, avalon_entity, isSampleBased=False):
    processes = []
    if isSampleBased:
        channel_to_sample_p = Process("channel_to_sample")
        channel_to_sample_p.sensitivity_list = [avalon_entity.get_port("clk")]
        sink_data = next(
            port for port in dataplane_signals if port.name == "dataplane_sink_data")
        sink_data_tmp = next(
            port for port in dataplane_signals if port.name == "dataplane_sink_data_tmp")
        channel_to_sample_p.logic = channel_to_sample(
            avalon_entity.get_port("avalon_sink_data"), sink_data_tmp, sink_data)
        processes.append(channel_to_sample_p)

        sample_to_channel_p = Process("sample_to_channel")
        sample_to_channel_p.sensitivity_list = [avalon_entity.get_port("clk")]
        dataplane_source_data = next(
            port for port in dataplane_signals if port.name == "dataplane_source_data")
        sample_to_channel_p.logic = sample_to_channel(
            avalon_entity.get_port("avalon_source_data"), dataplane_source_data)
        processes.append(sample_to_channel_p)

    bus_read = Process("bus_read")
    bus_read.sensitivity_list = [avalon_entity.get_port("clk")]
    bus_read.logic = create_bus_read_logic(
        register_signals, avalon_entity.get_port("avalon_slave_readdata"))
    processes.append(bus_read)

    bus_write = Process("bus_write")
    bus_write.sensitivity_list = avalon_entity.get_ports("clk", "reset")
    bus_write.logic = create_bus_write_logic(
        register_signals, avalon_entity.get_port("avalon_slave_writedata"))
    processes.append(bus_write)

    return processes


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
    logic_string += tab() + \
        f"if rising_edge(clk) and {read_enable} = '1' then \n"
    logic_string += tab(2) + f"case {avalon_slave_address} is\n"

    addr_width = int(ceil(log(len(register_signals), 2)))
    for idx, reg in enumerate(register_signals):
        addr = "{0:0{1}b}".format(idx, addr_width)
        assignment = data_out.generate_assignment(reg)
        logic_string += tab(3) + f"when \"{addr}\" => {assignment}"

    logic_string += tab(3) + \
        f"when others => {data_out.name} <= (others => '0');\n"
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
    logic_string += tab() + f"if reset = '1' then \n"
    for reg in register_signals:
        data_type = reg.underlying_data_type
        default_bit_string = num_to_bitstring(
                reg.default_value, data_type.word_len, data_type.frac_len)
        logic_string += tab(2) + \
            f"{reg.name.ljust(24)} <= {(default_bit_string + ';').ljust(32)} -- {reg.default_value}\n"

    logic_string += tab() + \
        f"elsif rising_edge(clk) and {write_enable} = '1' then\n"
    logic_string += tab(2) + f"case {avalon_slave_address} is\n"

    addr_width = int(ceil(log(len(register_signals), 2)))
    for idx, reg in enumerate(register_signals):
        addr = "{0:0{1}b}".format(idx, addr_width)
        assignment = reg.generate_assignment(data_in)
        logic_string += tab(3) + f"when \"{addr}\" => {assignment}"
    logic_string += tab(3) + "when others => null;"
    logic_string += tab(2) + "end case;\n"
    logic_string += tab() + "end if;\n"
    return logic_string


def create_dataplane_signals(audio_in, audio_out, isSampleBased):
    if not isSampleBased:
        return [
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
    return [
        ArraySignal(
            "dataplane_sink_data",
            f"vector_of_std_logic_vector{audio_in.data_type.word_len}",
            audio_in.channel_count,
            "std_logic_vector",
            audio_in.data_type.word_len,
            audio_in.data_type
        ),
        ArraySignal(
            "dataplane_sink_data_tmp",
            f"vector_of_std_logic_vector{audio_in.data_type.word_len}",
            audio_in.channel_count,
            "std_logic_vector",
            audio_in.data_type.word_len,
            audio_in.data_type
        ),
        ArraySignal(
            "dataplane_source_data",
            f"vector_of_std_logic_vector{audio_out.data_type.word_len}",
            audio_out.channel_count,
            "std_logic_vector",
            audio_out.data_type.word_len,
            audio_out.data_type
        ),
        ArraySignal(
            "dataplane_source_data_prev",
            f"vector_of_std_logic_vector{audio_out.data_type.word_len}",
            audio_out.channel_count,
            "std_logic_vector",
            audio_out.data_type.word_len,
            audio_out.data_type
        ),
        Signal("counter", 1, 0, "natural")

    ]


def channel_to_sample(avalon_sink_data_signal, dataplane_sink_data_tmp_signal, dataplane_sink_data_signal):
    return f"""
    if rising_edge(clk) then
        if avalon_sink_valid = '1' then
            if avalon_sink_channel = "0" then
            {dataplane_sink_data_tmp_signal[0].generate_assignment(avalon_sink_data_signal)}
            elsif avalon_sink_channel = "1" then
                {dataplane_sink_data_tmp_signal[1].generate_assignment(avalon_sink_data_signal)}
                {dataplane_sink_data_signal.generate_assignment(dataplane_sink_data_tmp_signal)}
            end if;
        end if;
    end if; 
"""


def sample_to_channel(avalon_source_data_signal, dataplane_source_data_signal):
    vhdl = tab() + "if rising_edge(clk) then\n"

    vhdl += tab(2) + "if counter = 2048 then\n"
    vhdl += tab(3) + "counter <= 1;\n"

    vhdl += tab(2) + "else\n"

    vhdl += tab(3) + "if counter = 1 then\n"
    vhdl += tab(4) + avalon_source_data_signal.generate_assignment(
        dataplane_source_data_signal[0])
    vhdl += tab(4) + "avalon_source_valid <= '1';\n"
    vhdl += tab(4) + "avalon_source_channel<= \"0\";\n"

    vhdl += tab(3) + "elsif counter = 2 then\n"
    vhdl += tab(4) + avalon_source_data_signal.generate_assignment(
        dataplane_source_data_signal[1])
    vhdl += tab(4) + "avalon_source_valid <= '1';\n"
    vhdl += tab(4) + "avalon_source_channel <= \"1\";\n"

    vhdl += tab(3) + "end if;\n"
    vhdl += tab(3) + "counter <= counter + 1;\n"
    vhdl += tab(2) + "end if;\n"

    vhdl += tab() + "end if;\n"
    return vhdl
