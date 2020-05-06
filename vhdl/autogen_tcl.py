
from create_connection_point_clock import create_connection_point_clock
from create_connection_point_reset import create_connection_point_reset
from create_file_sets import create_file_sets
from create_module import create_module
from create_module_assignments import create_module_assignments
from create_header_file_stuff import create_header_file_stuff
from create_mm_connection_point import create_mm_connection_point
from create_sink_connection_point import create_sink_connection_point
from create_source_connection_point import  create_source_connection_point
from input_structure import InputStructure
from parse_json import parse_json
from populate_additional_filesets import populate_additional_filesets
from qsys_system.create_qsys_system import create_qsys_system


import os
def main(inputFilename, outputFilename, additionalFilesetAbsDir):
    print("Hello ")
    input_struct = parse_json(additionalFilesetAbsDir + "\\..\\..\\" + inputFilename)
    populate_additional_filesets(input_struct, additionalFilesetAbsDir)
    write_tcl(input_struct, outputFilename)
    print("Going in")
    print("AUTOGEN_COMP_LIB is" + os.getenv('AUTOGEN_COMP_LIB'))
    create_qsys_system(input_struct, True, additionalFilesetAbsDir)
    print("test")

def write_tcl(input_struct, outputFilename):
    with open(outputFilename, "w") as out_file:
        out_file.write(create_header_file_stuff(input_struct))
        out_file.write(create_module(input_struct))
        out_file.write(create_file_sets(input_struct))
        out_file.write(create_module_assignments(input_struct))
        out_file.write(create_connection_point_clock(input_struct))
        out_file.write(create_connection_point_reset(input_struct))
        out_file.write(create_mm_connection_point(input_struct))
        out_file.write(create_sink_connection_point(input_struct))
        out_file.write(create_source_connection_point(input_struct))
        
if __name__ == "__main__":
    main('MNR_dataplane.json', "C:\\Users\\wickh\\Documents\\NIH\\simulink_models\\models\\short_window_mean_reduction\\hdlsrc\\MNR\\MNR_dataplane_avalon_hw.tcl", "C:\\Users\\wickh\\Documents\\NIH\\simulink_models\\models\\short_window_mean_reduction\\hdlsrc\\MNR")