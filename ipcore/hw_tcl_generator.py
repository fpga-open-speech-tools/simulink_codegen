

class HwTCLGenerator:
    def __init__(self, dataplane_config):
        self.name = dataplane_config.name
        self.version = dataplane_config.version
        self.description = dataplane_config.description
        self.author = dataplane_config.author

        self.additional_filesets = dataplane_config.additional_filesets

        self.vendor = dataplane_config.vendor

        self.clock_rate = dataplane_config.clock_rate

        self.data_bus_size = dataplane_config.data_bus_size
        self.address_bus_size = dataplane_config.address_bus_size
        self.has_avalon_mm_slave_signal = dataplane_config.has_avalon_mm_slave_signal

        self.sink_max_channel = dataplane_config.sink_max_channel
        self.source_max_channel = dataplane_config.source_max_channel

    def write_tcl(self, outputFilename):
        with open(outputFilename, "w") as out_file:
            out_file.write(self.generate())
    
    def generate(self):
        tcl = self.create_header_file_stuff()
        tcl += self.create_module()
        tcl += self.create_file_sets()
        tcl += self.create_module_assignments()
        tcl += self.create_connection_point_clock()
        tcl += self.create_connection_point_reset()
        tcl += self.create_mm_connection_point()
        tcl += self.create_sink_connection_point()
        tcl += self.create_source_connection_point()
        return tcl

    def create_header_file_stuff(self):
        tcl = ""
        tcl += "package require -exact qsys 16.1\n"
        tcl += "\n\n\n"
        return tcl


    def create_module(self):
        tcl = ""
        tcl += "set_module_property DESCRIPTION \"" + \
            self.description + "\"\n"
        tcl += "set_module_property NAME \"" + self.name + "\"\n"
        tcl += "set_module_property VERSION " + self.version + "\n"
        tcl += "set_module_property OPAQUE_ADDRESS_MAP true\n"
        tcl += "set_module_property AUTHOR \"" + self.author + "\"\n"
        tcl += "set_module_property GROUP \"FPGA Open Speech Tools/Autogen\"\n"
        tcl += "set_module_property DISPLAY_NAME \"" + \
            self.name + "\"\n"
        tcl += "set_module_property INSTANTIATE_IN_SYSTEM_MODULE true\n"
        tcl += "set_module_property EDITABLE true\n"
        tcl += "set_module_property REPORT_TO_TALKBACK false\n"
        tcl += "set_module_property ALLOW_GREYBOX_GENERATION false\n"
        tcl += "set_module_property REPORT_HIERARCHY false\n"
        tcl += "\n\n\n"
        return tcl


    def create_file_sets(self):
        tcl = ""
        tcl += "add_fileset QUARTUS_SYNTH QUARTUS_SYNTH \"\" \"\"\n"

        for i in range(len(self.additional_filesets)):
            tcl += ("add_fileset_file " + self.additional_filesets[i] + " VHDL PATH " +
                            self.additional_filesets[i] + "\n")

        # add the top level file
        quartus_synth_top_level = self.name + "_dataplane_avalon"
        tcl += "set_fileset_property QUARTUS_SYNTH TOP_LEVEL " + \
            quartus_synth_top_level + "\n"
        tcl += ("set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false\n")
        tcl += ("set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false\n")
        vhdl_top_level_file = quartus_synth_top_level + ".vhd"
        tcl += ("add_fileset_file " + vhdl_top_level_file + " VHDL PATH " +
                        vhdl_top_level_file + " TOP_LEVEL_FILE\n")
        tcl += "\n\n\n"

        return tcl


    def create_module_assignments(self):
        tcl = ""
        tcl += "set_module_assignment embeddedsw.dts.compatible " + \
            f"dev,{self.vendor}-{self.name}\n"
        tcl += "set_module_assignment embeddedsw.dts.group autogen \n"
        tcl += "set_module_assignment embeddedsw.dts.vendor " + \
            self.vendor + "\n"

        tcl += "\n\n\n"
        return tcl


    def create_connection_point_clock(self):
        tcl = ""
        tcl += "add_interface clock clock end\n"
        tcl += "set_interface_property clock clockRate " + \
            str(self.clock_rate) + "\n"
        tcl += "set_interface_property clock ENABLED true\n"
        tcl += "set_interface_property clock EXPORT_OF \"\"\n"
        tcl += "set_interface_property clock PORT_NAME_MAP \"\"\n"
        tcl += "set_interface_property clock CMSIS_SVD_VARIABLES \"\"\n"
        tcl += "set_interface_property clock SVD_ADDRESS_GROUP \"\"\n"
        tcl += "add_interface_port clock clk clk Input 1\n"
        tcl += "\n\n\n"
        return tcl


    def create_connection_point_reset(self):
        tcl = ""
        tcl += "add_interface reset reset end\n"
        tcl += "set_interface_property reset associatedClock clock\n"
        tcl += "set_interface_property reset synchronousEdges DEASSERT\n"
        tcl += "set_interface_property reset ENABLED true\n"
        tcl += "set_interface_property reset EXPORT_OF true\n"
        tcl += "set_interface_property reset PORT_NAME_MAP \"\"\n"
        tcl += "set_interface_property reset CMSIS_SVD_VARIABLES \"\"\n"
        tcl += "set_interface_property reset SVD_ADDRESS_GROUP \"\"\n"
        tcl += "add_interface_port reset reset reset Input 1\n"
        tcl += "\n\n\n"
        return tcl


    def create_mm_connection_point(self):
        if not self.has_avalon_mm_slave_signal:
            return ""
        tcl = ""
        memory_slave = 'avalon_slave'
        tcl += "add_interface " + memory_slave + " avalon end\n"
        tcl += "set_interface_property " + memory_slave + " addressUnits WORDS\n"
        tcl += "set_interface_property " + memory_slave + " associatedClock clock\n"
        tcl += "set_interface_property " + memory_slave + " associatedReset reset\n"
        tcl += "set_interface_property " + memory_slave + " bitsPerSymbol 8\n"
        tcl += "set_interface_property " + \
            memory_slave + " burstOnBurstBoundariesOnly false\n"
        tcl += "set_interface_property " + memory_slave + " burstcountUnits WORDS\n"
        tcl += "set_interface_property " + memory_slave + " explicitAddressSpan 0\n"
        tcl += "set_interface_property " + memory_slave + " holdTime 0\n"
        tcl += "set_interface_property " + memory_slave + " linewrapBursts false\n"
        tcl += "set_interface_property " + \
            memory_slave + " maximumPendingReadTransactions 0\n"
        tcl += "set_interface_property " + \
            memory_slave + " maximumPendingWriteTransactions 0\n"
        tcl += "set_interface_property " + memory_slave + " readLatency 0\n"
        tcl += "set_interface_property " + memory_slave + " readWaitTime 1\n"
        tcl += "set_interface_property " + memory_slave + " setupTime 1\n"
        tcl += "set_interface_property " + memory_slave + " timingUnits Cycles\n"
        tcl += "set_interface_property " + memory_slave + " writeWaitTime 0\n"
        tcl += "set_interface_property " + memory_slave + " ENABLED true\n"
        tcl += "set_interface_property " + memory_slave + " EXPORT_OF \"\"\n"
        tcl += "set_interface_property " + memory_slave + " PORT_NAME_MAP \"\"\n"
        tcl += "set_interface_property " + \
            memory_slave + " CMSIS_SVD_VARIABLES \"\"\n"
        tcl += "set_interface_property " + \
            memory_slave + " SVD_ADDRESS_GROUP \"\"\n\n"

        tcl += "add_interface_port " + memory_slave + " " + memory_slave + "_address address Input " + \
            str(self.address_bus_size if self.address_bus_size > 0 else 1) + "\n"
        tcl += "add_interface_port " + \
            memory_slave + " " + memory_slave + "_read read Input 1\n"
        tcl += "add_interface_port " + memory_slave + " " + memory_slave + \
            "_readdata readdata Output " + str(self.data_bus_size) + "\n"
        tcl += "add_interface_port " + memory_slave + \
            " " + memory_slave + "_write write Input 1\n"
        tcl += "add_interface_port " + memory_slave + " " + memory_slave + \
            "_writedata writedata Input " + str(self.data_bus_size) + "\n"
        tcl += "set_interface_assignment " + \
            memory_slave + " embeddedsw.configuration.isFlash 0\n"
        tcl += "set_interface_assignment " + memory_slave + \
            " embeddedsw.configuration.isMemoryDevice 0\n"
        tcl += "set_interface_assignment " + memory_slave + \
            " embeddedsw.configuration.isNonVolatileStorage 0\n"
        tcl += "set_interface_assignment " + memory_slave + \
            " embeddedsw.configuration.isPrintableDevice 0\n"
        tcl += "\n\n\n"
        return tcl


    def create_sink_connection_point(self):
        tcl = ""
        sink = "avalon_streaming_sink"
        tcl += "add_interface " + sink + " avalon_streaming end\n"
        tcl += "set_interface_property " + sink + " associatedClock clock\n"
        tcl += "set_interface_property " + sink + " associatedReset reset\n"
        tcl += "set_interface_property " + sink + \
            " dataBitsPerSymbol " + str(self.data_bus_size) + "\n"
        tcl += "set_interface_property " + sink + " errorDescriptor \"\"\n"
        tcl += "set_interface_property " + \
            sink + " firstSymbolInHighOrderBits true\n"
        tcl += "set_interface_property " + sink + \
            " maxChannel " + str(self.sink_max_channel) + "\n"
        tcl += "set_interface_property " + sink + " readyLatency 0\n"
        tcl += "set_interface_property " + sink + " ENABLED true\n"
        tcl += "set_interface_property " + sink + " EXPORT_OF \"\"\n"
        tcl += "set_interface_property " + sink + " PORT_NAME_MAP \"\"\n"
        tcl += "set_interface_property " + \
            sink + " CMSIS_SVD_VARIABLES \"\"\n"
        tcl += "set_interface_property " + sink + " SVD_ADDRESS_GROUP \"\"\n"
        tcl += "add_interface_port " + sink + " avalon_sink_valid valid Input 1\n"
        tcl += "add_interface_port " + sink + " avalon_sink_data data Input 32\n"
        tcl += f"add_interface_port {sink} avalon_sink_channel channel Input {self.sink_max_channel}\n"
        tcl += "add_interface_port " + sink + " avalon_sink_error error Input 2\n"
        tcl += "\n\n\n"
        return tcl


    def create_source_connection_point(self):
        tcl = ""
        source = 'avalon_streaming_source'
        tcl += "add_interface " + source + " avalon_streaming start\n"
        tcl += "set_interface_property " + source + " associatedClock clock\n"
        tcl += "set_interface_property " + source + " associatedReset reset\n"
        tcl += "set_interface_property " + source + \
            " dataBitsPerSymbol " + str(self.data_bus_size) + "\n"
        tcl += "set_interface_property " + source + " errorDescriptor \"\"\n"
        tcl += "set_interface_property " + \
            source + " firstSymbolInHighOrderBits true\n"
        tcl += "set_interface_property " + source + \
            " maxChannel " + str(self.source_max_channel) + "\n"
        tcl += "set_interface_property " + source + " readyLatency 0\n"
        tcl += "set_interface_property " + source + " ENABLED true\n"
        tcl += "set_interface_property " + source + " EXPORT_OF \"\"\n"
        tcl += "set_interface_property " + source + " PORT_NAME_MAP \"\"\n"
        tcl += "set_interface_property " + \
            source + " CMSIS_SVD_VARIABLES \"\"\n"
        tcl += "set_interface_property " + source + " SVD_ADDRESS_GROUP \"\"\n"

        tcl += "add_interface_port " + source + " avalon_source_valid valid Output 1\n"
        tcl += "add_interface_port " + source + " avalon_source_data data Output 32\n"
        tcl += f"add_interface_port {source} avalon_source_channel channel Output {self.source_max_channel}\n"
        tcl += "add_interface_port " + source + " avalon_source_error error Output 2\n"
        tcl += "\n\n\n"
        return tcl
