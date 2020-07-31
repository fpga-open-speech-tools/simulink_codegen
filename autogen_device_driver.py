import argparse
import sys
import logging

from device_drivers import Generator as DeviceDriverGenerator, DriverConfig


def main(config_filepath, working_dir = "."):
    """Generate a Linux device driver from JSON using the config file given, in the given working directory.

    Parameters
    ----------
    config_filepath : str
        Path to config file
    working_dir : str
        Path to working directory
    """
    if not(working_dir.endswith("/")):
        working_dir += "/"
    config = DriverConfig.parse_json(config_filepath)
    generator = DeviceDriverGenerator(config)
    generator.write_driver( working_dir + config.device_name + ".c")
    

def parseargs():
    """Parse commandline input arguments."""
    parser = argparse.ArgumentParser(
        description="Generate a Linux device driver from JSON")
    parser.add_argument('-c', '--config',
                        help="Config file containing autogen configuration in JSON format")
    parser.add_argument('-w', '--working-dir', default=".",
                        help="Working directory to generate the device driver in")
    args = parser.parse_args()
    return (args.config, args.working_dir )


if __name__ == "__main__":
    (config_filepath, working_dir) = parseargs()

    main(config_filepath, working_dir)
