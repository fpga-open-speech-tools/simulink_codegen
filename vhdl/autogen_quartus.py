import argparse

from input_structure import InputStructure
from parse_json import parse_json
from quartus.quartus_workflow import execute_quartus_workflow


def main(inputFilename, additionalFilesetAbsDir):
    input_struct = parse_json(
        additionalFilesetAbsDir + "\\..\\..\\" + inputFilename)
    execute_quartus_workflow(
        input_struct, get_working_dir(additionalFilesetAbsDir))


def get_working_dir(dir):
    if not(dir.endswith("\\")):
        dir += "\\"
    return dir + "quartus\\"


def parseargs():
    """
    Parse commandline input arguments.
    """
    parser = argparse.ArgumentParser(
        description="Executes the quartus workflow, from creating a system to compiling the project made around that system")
    parser.add_argument('-j', '--json',
                        help="JSON file containing autogen configuration")
    parser.add_argument('-w', '--working-dir',
                        help="Working directory to execute the quartus workflow in")
    args = parser.parse_args()
    return (args.json, args.working_dir)


if __name__ == "__main__":
    (json_filename, working_dir) = parseargs()

    main(json_filename, working_dir)
