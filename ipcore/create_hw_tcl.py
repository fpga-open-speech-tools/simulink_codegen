import argparse
from dataplane_config import DataplaneConfig


def main(inputFilename, outputFilename, additionalFilesetAbsDir):
    dataplane_config = DataplaneConfig.parse_json(
        additionalFilesetAbsDir + "/../../" + inputFilename)
    dataplane_config.populate_additional_filesets(additionalFilesetAbsDir)
    write_tcl(dataplane_config, outputFilename)


def write_tcl(dataplane_config, outputFilename):
    with open(outputFilename, "w") as out_file:
        out_file.write(create_header_file_stuff(dataplane_config))
        out_file.write(create_module(dataplane_config))
        out_file.write(create_file_sets(dataplane_config))
        out_file.write(create_module_assignments(dataplane_config))
        out_file.write(create_connection_point_clock(dataplane_config))
        out_file.write(create_connection_point_reset(dataplane_config))
        out_file.write(create_mm_connection_point(dataplane_config))
        out_file.write(create_sink_connection_point(dataplane_config))
        out_file.write(create_source_connection_point(dataplane_config))


def create_header_file_stuff(dataplane_config):
    built_string = "# # # # # # # # # # # # # # # # # #\n"
    built_string += "# Built in create_header_file_stuff\n"
    built_string += "# # # # # # # # # # # # # # # # # #\n\n"
    built_string += "package require -exact qsys 16.1\n"
    built_string += "# End create_header_file_stuff\n\n\n"
    return built_string


def create_module(dataplane_config):
    built_string = "# # # # # # # # # # # # # # # # #\n"
    built_string += "# Created in create_module\n"
    built_string += "# # # # # # # # # # # # # # # # #\n\n"
    built_string += "set_module_property DESCRIPTION \"" + \
        dataplane_config.description + "\"\n"
    built_string += "set_module_property NAME \"" + dataplane_config.name + "\"\n"
    built_string += "set_module_property VERSION " + dataplane_config.version + "\n"
    built_string += "set_module_property OPAQUE_ADDRESS_MAP " + \
        str(dataplane_config.opaque_address_map).lower() + "\n"
    built_string += "set_module_property AUTHOR \"" + dataplane_config.author + "\"\n"
    built_string += "set_module_property GROUP \"FPGA Open Speech Tools/Autogen\"\n"
    built_string += "set_module_property DISPLAY_NAME \"" + \
        dataplane_config.display_name + "\"\n"
    built_string += "set_module_property INSTANTIATE_IN_SYSTEM_MODULE " + \
        str(dataplane_config.inst_in_sys_mod).lower() + "\n"
    built_string += "set_module_property EDITABLE " + \
        str(dataplane_config.editable).lower() + "\n"
    built_string += "set_module_property REPORT_TO_TALKBACK " + \
        str(dataplane_config.report_to_talkback).lower() + "\n"
    built_string += "set_module_property ALLOW_GREYBOX_GENERATION " + \
        str(dataplane_config.allow_greybox_generation).lower() + "\n"
    built_string += "set_module_property VERSION " + dataplane_config.version + "\n"
    built_string += "set_module_property REPORT_HIERARCHY " + \
        str(dataplane_config.report_hierarchy).lower() + "\n"
    for i in range(len(dataplane_config.additional_module_properties)):
        built_string += ("set_module_property " + dataplane_config.additional_module_properties[i][0] +
                         " " + dataplane_config.additional_module_properties[i][1] + "\n")
    built_string += "# end of create_module\n\n\n"
    return built_string


def create_file_sets(dataplane_config):
    built_string = "# # # # # # # # # # # # # # # # # #\n"
    built_string += "# created in create_file_sets\n"
    built_string += "# # # # # # # # # # # # # # # # # #\n\n"
    built_string += "add_fileset QUARTUS_SYNTH QUARTUS_SYNTH \"\" \"\"\n"

    # add additional dependent files before the top level file; quartus needs to synthesize dependencies first
    for i in range(len(dataplane_config.additional_filesets)):
        built_string += ("add_fileset_file " + dataplane_config.additional_filesets[i] + " VHDL PATH " +
                         dataplane_config.additional_filesets[i] + "\n")

    # add the top level file
    built_string += "set_fileset_property QUARTUS_SYNTH TOP_LEVEL " + \
        dataplane_config.quartus_synth_top_level + "\n"
    built_string += ("set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS " +
                     str(dataplane_config.enable_rel_inc_paths).lower() + "\n")
    built_string += ("set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE " +
                     str(dataplane_config.enable_file_overwrite).lower() + "\n")
    built_string += ("add_fileset_file " + dataplane_config.vhdl_top_level_file + " VHDL PATH " +
                     dataplane_config.vhdl_top_level_file + " TOP_LEVEL_FILE\n")
    built_string += "# end create_file_sets\n\n\n"

    return built_string


def create_module_assignments(input_structs):
    built_string = "# # # # # # # # # # # # # # # # # #\n"
    built_string += "# Created in create_module_assignments\n"
    built_string += "# # # # # # # # # # # # # # # # # # # #\n\n"
    built_string += "set_module_assignment embeddedsw.dts.compatible " + \
        input_structs.compatible_flag + "\n"
    built_string += "set_module_assignment embeddedsw.dts.group autogen \n"
    built_string += "set_module_assignment embeddedsw.dts.vendor " + \
        input_structs.vendor + "\n"

    built_string += "# End create_module_assignments\n\n\n"
    return built_string


def create_connection_point_clock(dataplane_config):
    built_string = "# # # # # # # # # # # # # # # # # # # # # #\n"
    built_string += "# Created by create_connection_point_clock\n"
    built_string += "# # # # # # # # # # # # # # # # # # # # # #\n\n"
    built_string += "add_interface clock clock end\n"
    built_string += "set_interface_property clock clockRate " + \
        str(dataplane_config.clock_rate) + "\n"
    built_string += "set_interface_property clock ENABLED true\n"
    built_string += "set_interface_property clock EXPORT_OF \"\"\n"
    built_string += "set_interface_property clock PORT_NAME_MAP \"\"\n"
    built_string += "set_interface_property clock CMSIS_SVD_VARIABLES \"\"\n"
    built_string += "set_interface_property clock SVD_ADDRESS_GROUP \"\"\n"
    built_string += "add_interface_port clock " + dataplane_config.clock_abbrev + \
        " " + dataplane_config.clock_abbrev + " Input 1\n"
    built_string += "# End create_connection_point_clock\n\n\n"
    return built_string


def create_connection_point_reset(dataplane_config):
    built_string = "# # # # # # # # # # # # # # # # # # # # # #\n"
    built_string += "# Created by create_connection_point_reset\n"
    built_string += "# # # # # # # # # # # # # # # # # # # # # #\n\n"
    built_string += "add_interface reset reset end\n"
    built_string += "set_interface_property reset associatedClock clock\n"
    built_string += "set_interface_property reset synchronousEdges DEASSERT\n"
    built_string += "set_interface_property reset ENABLED true\n"
    built_string += "set_interface_property reset EXPORT_OF true\n"
    built_string += "set_interface_property reset PORT_NAME_MAP \"\"\n"
    built_string += "set_interface_property reset CMSIS_SVD_VARIABLES \"\"\n"
    built_string += "set_interface_property reset SVD_ADDRESS_GROUP \"\"\n"
    built_string += "add_interface_port reset reset reset Input 1\n"
    built_string += "# End create_connection_point_reset\n\n\n"
    return built_string


def create_mm_connection_point(dataplane_config):
    if not dataplane_config.has_avalon_mm_slave_signal:
        return ""
    built_string = "# # # # # # # # # # # # # # # # # # # # #\n"
    built_string += "# Created by create_mm_connection_point\n"
    built_string += "# # # # # # # # # # # # # # # # # # # # #\n\n"
    mmname = dataplane_config.avalon_mm_slave_signal_name
    built_string += "add_interface " + mmname + " avalon end\n"
    built_string += "set_interface_property " + mmname + " addressUnits WORDS\n"
    built_string += "set_interface_property " + mmname + " associatedClock clock\n"
    built_string += "set_interface_property " + mmname + " associatedReset reset\n"
    built_string += "set_interface_property " + mmname + " bitsPerSymbol 8\n"
    built_string += "set_interface_property " + \
        mmname + " burstOnBurstBoundariesOnly false\n"
    built_string += "set_interface_property " + mmname + " burstcountUnits WORDS\n"
    built_string += "set_interface_property " + mmname + " explicitAddressSpan 0\n"
    built_string += "set_interface_property " + mmname + " holdTime 0\n"
    built_string += "set_interface_property " + mmname + " linewrapBursts false\n"
    built_string += "set_interface_property " + \
        mmname + " maximumPendingReadTransactions 0\n"
    built_string += "set_interface_property " + \
        mmname + " maximumPendingWriteTransactions 0\n"
    built_string += "set_interface_property " + mmname + " readLatency 0\n"
    built_string += "set_interface_property " + mmname + " readWaitTime 1\n"
    built_string += "set_interface_property " + mmname + " setupTime 1\n"
    built_string += "set_interface_property " + mmname + " timingUnits Cycles\n"
    built_string += "set_interface_property " + mmname + " writeWaitTime 0\n"
    built_string += "set_interface_property " + mmname + " ENABLED true\n"
    built_string += "set_interface_property " + mmname + " EXPORT_OF \"\"\n"
    built_string += "set_interface_property " + mmname + " PORT_NAME_MAP \"\"\n"
    built_string += "set_interface_property " + \
        mmname + " CMSIS_SVD_VARIABLES \"\"\n"
    built_string += "set_interface_property " + \
        mmname + " SVD_ADDRESS_GROUP \"\"\n\n"

    built_string += "add_interface_port " + mmname + " " + mmname + "_address address Input " + \
        str(dataplane_config.address_bus_size if dataplane_config.address_bus_size > 0 else 1) + "\n"
    built_string += "add_interface_port " + \
        mmname + " " + mmname + "_read read Input 1\n"
    built_string += "add_interface_port " + mmname + " " + mmname + \
        "_readdata readdata Output " + str(dataplane_config.data_bus_size) + "\n"
    built_string += "add_interface_port " + mmname + \
        " " + mmname + "_write write Input 1\n"
    built_string += "add_interface_port " + mmname + " " + mmname + \
        "_writedata writedata Input " + str(dataplane_config.data_bus_size) + "\n"
    built_string += "set_interface_assignment " + \
        mmname + " embeddedsw.configuration.isFlash 0\n"
    built_string += "set_interface_assignment " + mmname + \
        " embeddedsw.configuration.isMemoryDevice 0\n"
    built_string += "set_interface_assignment " + mmname + \
        " embeddedsw.configuration.isNonVolatileStorage 0\n"
    built_string += "set_interface_assignment " + mmname + \
        " embeddedsw.configuration.isPrintableDevice 0\n"
    built_string += "# End create_mm_connection_point\n\n\n"
    return built_string


def create_sink_connection_point(dataplane_config):
    if not dataplane_config.has_sink_signal:
        return ""
    built_string = "# # # # # # # # # # # # # # # # # # # # # #\n"
    built_string += "# Created by create_sink_connection_point\n"
    built_string += "# # # # # # # # # # # # # # # # # # # # # #\n\n"
    ssname = dataplane_config.sink_signal_name
    built_string += "add_interface " + ssname + " avalon_streaming end\n"
    built_string += "set_interface_property " + ssname + " associatedClock clock\n"
    built_string += "set_interface_property " + ssname + " associatedReset reset\n"
    built_string += "set_interface_property " + ssname + \
        " dataBitsPerSymbol " + str(dataplane_config.data_bus_size) + "\n"
    built_string += "set_interface_property " + ssname + " errorDescriptor \"\"\n"
    built_string += "set_interface_property " + \
        ssname + " firstSymbolInHighOrderBits true\n"
    built_string += "set_interface_property " + ssname + \
        " maxChannel " + str(dataplane_config.sink_max_channel) + "\n"
    built_string += "set_interface_property " + ssname + " readyLatency 0\n"
    built_string += "set_interface_property " + ssname + " ENABLED true\n"
    built_string += "set_interface_property " + ssname + " EXPORT_OF \"\"\n"
    built_string += "set_interface_property " + ssname + " PORT_NAME_MAP \"\"\n"
    built_string += "set_interface_property " + \
        ssname + " CMSIS_SVD_VARIABLES \"\"\n"
    built_string += "set_interface_property " + ssname + " SVD_ADDRESS_GROUP \"\"\n"

    for port_name, num_bits in dataplane_config.sink_signal_port_names_and_widths.items():
        port_type = port_name.rpartition('_')[2]
        built_string += ("add_interface_port " + ssname + " " + port_name + " " + port_type + " Input "
                         + str(num_bits) + "\n")
    built_string += "# End create_sink_connection_point\n\n\n"
    return built_string


def create_source_connection_point(dataplane_config):
    if not dataplane_config.has_source_signal:
        return ""
    built_string = "# # # # # # # # # # # # # # # # # # # # # # #\n"
    built_string += "# Created in create_source_connection_point\n"
    built_string += "# # # # # # # # # # # # # # # # # # # # # # #\n\n"
    ssname = dataplane_config.source_signal_name
    built_string += "add_interface " + ssname + " avalon_streaming start\n"
    built_string += "set_interface_property " + ssname + " associatedClock clock\n"
    built_string += "set_interface_property " + ssname + " associatedReset reset\n"
    built_string += "set_interface_property " + ssname + \
        " dataBitsPerSymbol " + str(dataplane_config.data_bus_size) + "\n"
    built_string += "set_interface_property " + ssname + " errorDescriptor \"\"\n"
    built_string += "set_interface_property " + \
        ssname + " firstSymbolInHighOrderBits true\n"
    built_string += "set_interface_property " + ssname + \
        " maxChannel " + str(dataplane_config.source_max_channel) + "\n"
    built_string += "set_interface_property " + ssname + " readyLatency 0\n"
    built_string += "set_interface_property " + ssname + " ENABLED true\n"
    built_string += "set_interface_property " + ssname + " EXPORT_OF \"\"\n"
    built_string += "set_interface_property " + ssname + " PORT_NAME_MAP \"\"\n"
    built_string += "set_interface_property " + \
        ssname + " CMSIS_SVD_VARIABLES \"\"\n"
    built_string += "set_interface_property " + ssname + " SVD_ADDRESS_GROUP \"\"\n"

    for port_name, num_bits in dataplane_config.source_signal_port_names_and_widths.items():
        port_type = port_name.rpartition('_')[2]
        built_string += ("add_interface_port " + ssname + " " + port_name + " " + port_type + " Output "
                         + str(num_bits) + "\n")
    built_string += "# End create_sink_connection_point\n\n\n"
    return built_string


def parseargs():
    """Parse commandline input arguments."""
    parser = argparse.ArgumentParser(
        description="Generates a Platform Design/Qsys component as _hw.tcl file")
    parser.add_argument('-c', '--config',
                        help="JSON file containing autogen configuration")
    parser.add_argument('-w', '--working-dir',
                        help="Working directory to generate the Platform Designer component in")
    parser.add_argument('-o', '--output-filename',
                        help="Name of the output file, recommended to end in '_hw.tcl'")
    args = parser.parse_args()
    return (args.config, args.output_filename, args.working_dir)


if __name__ == "__main__":
    (json_filename, outputFilename, working_dir) = parseargs()

    main(json_filename, outputFilename, working_dir)
