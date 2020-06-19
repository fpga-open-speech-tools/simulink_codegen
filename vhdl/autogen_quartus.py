import argparse

from dataplane_config import DataplaneConfig
from quartus.quartus_workflow import execute_quartus_workflow


def main(inputFilename, working_dir):
    if not(working_dir.endswith("/")):
        working_dir += "/"
    dataplane_config = DataplaneConfig.parse_json(inputFilename)
    execute_quartus_workflow(
        dataplane_config, working_dir)

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
