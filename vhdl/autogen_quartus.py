import argparse
import sys
import logging

from dataplane_config import DataplaneConfig
from quartus.quartus_workflow import execute_quartus_workflow


def main(inputFilename, working_dir, log_to_file=False):
    if not(working_dir.endswith("/")):
        working_dir += "/"
    logger = init_logging(logging.INFO, log_to_file)
    try:
        dataplane_config = DataplaneConfig.parse_json(inputFilename)
        execute_quartus_workflow(
            dataplane_config.target_system, dataplane_config.custom_components, dataplane_config.clock_rate, working_dir)
    finally:
        logger.info("exit")

def init_logging(debugLevel, log_to_file=False):
    logger = logging.getLogger('autogen_quartus')

    if log_to_file:
        file_log_handler = logging.FileHandler('autogen_quartus.log', 'w')
        file_log_handler.setLevel(debugLevel)
        file_log_handler.setFormatter(logging.Formatter())
        logger.addHandler(file_log_handler)

    console_handler = logging.StreamHandler()
    console_handler.setLevel(debugLevel)
    console_handler.setFormatter(logging.Formatter())
    logger.addHandler(console_handler)

    logger.setLevel(debugLevel)
    return logger

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
    parser.add_argument('-l', '--logging', required=False, action="store_true",
                        help="Enable logging to autogen_quartus.log")
    args = parser.parse_args()
    return (args.json, args.working_dir, args.logging)


if __name__ == "__main__":
    (json_filename, working_dir, log_to_file) = parseargs()

    main(json_filename, working_dir, log_to_file)
