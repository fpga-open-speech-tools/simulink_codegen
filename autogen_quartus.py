import argparse
import sys
import logging

from quartus.workflow_config import WorkflowConfig
from quartus.workflow import execute_quartus_workflow


def main(config_filepath, working_dir, log_to_file=False):
    """Execute the Quartus workflow using the config file given, in the given working directory.

    Parameters
    ----------
    config_filepath : str
        Path to config file
    working_dir : str
        Path to working directory for Quartus workflow
    log_to_file : bool, optional
        If true logs to a file in addition to stdout, by default False
    """
    if not(working_dir.endswith("/")):
        working_dir += "/"
    logger = init_logging(logging.INFO, log_to_file)
    try:
        config = WorkflowConfig.parse_json(config_filepath)
        execute_quartus_workflow(
            config.target_system, config.custom_components, config.clock_rate, working_dir)
    finally:
        # Is logged to tell anything reading the log that the workflow is over.
        # Is used by Matlab side when streaming the log to the Matlab command window 
        logger.info("exit")


def init_logging(debugLevel, log_to_file=False):
    """Initialize quartus module logging to given debug level and whether to also log to a file.

    Parameters
    ----------
    debugLevel : int
        The level required to trigger logging, where higher levels only show things like errors
    log_to_file : bool, optional
        If true logs to a file in addition to stdout, by default False

    Returns
    -------
    Logger
        Returns a Logger object with the given configuration
    """
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
    """Parse commandline input arguments."""
    parser = argparse.ArgumentParser(
        description="Executes the quartus workflow, from creating a system to compiling the project made around that system")
    parser.add_argument('-c', '--config',
                        help="Config file containing autogen configuration in JSON format")
    parser.add_argument('-w', '--working-dir',
                        help="Working directory to execute the quartus workflow in")
    parser.add_argument('-l', '--logging', required=False, action="store_true",
                        help="Enable logging to autogen_quartus.log")
    args = parser.parse_args()
    return (args.config, args.working_dir, args.logging)


if __name__ == "__main__":
    (config_filepath, working_dir, log_to_file) = parseargs()

    main(config_filepath, working_dir, log_to_file)
