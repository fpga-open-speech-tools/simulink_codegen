from .node import *

def main():
    avalonWrapper = EntityFile("avalonWrapper") 
    avalonEntityPorts = [
        Port(PortDir.In, "clk"),
        Port(PortDir.In, "reset"),
        Port(PortDir.In, "avalon_sink_valid"),
        Port(PortDir.In, "avalon_sink_data", 32),
        Port(PortDir.In, "avalon_sink_channel", 2),
        Port(PortDir.In, "avalon_sink_error", 2),
        Port(PortDir.Out, "avalon_sink_valid"),
        Port(PortDir.Out, "avalon_sink_data", 32),
        Port(PortDir.Out, "avalon_sink_channel", 2),
        Port(PortDir.Out, "avalon_sink_error", 2),
        Port(PortDir.In, "avalon_slave_address", 2),
        Port(PortDir.In, "avalon_slave_read"),
        Port(PortDir.Out, "avalon_slave_readdata", 32),
        Port(PortDir.In, "avalon_slave_write"),
        Port(PortDir.In, "avalon_slave_writedata")
    ]
    avalonEntity = Entity("avalonWrapper", avalonEntityPorts)

    