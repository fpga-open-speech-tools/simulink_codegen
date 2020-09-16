import argparse
from ipcore.dataplane_config import DataplaneConfig
from ipcore.hw_tcl_generator import HwTCLGenerator

def main(inputFilename, outputFilename, additionalFilesetAbsDir):
    dataplane_config = DataplaneConfig.parse_json(
        additionalFilesetAbsDir + "/../../" + inputFilename)
    dataplane_config.populate_additional_filesets(additionalFilesetAbsDir)
    generator = HwTCLGenerator(dataplane_config)
    generator.write_tcl(outputFilename)

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
    main(*parseargs())
