import argparse

from ipcore.avalon_wrapper import main as run_avalon_wrapper_generation

def main(config_dir=".", working_dir="."):
    """Generate an Avalon wrapper for Simulink generated VHDL from model.json.

    Parameters
    ----------
    config_dir : str
        Path to directory containing model.json config file
    working_dir : str
        Path to working directory
    """
    if not working_dir.endswith("/"):
        working_dir += "/"
    if not config_dir.endswith("/"):
        config_dir += "/"
    run_avalon_wrapper_generation(config_dir, working_dir)

def parseargs():
    """Parse commandline input arguments."""
    parser = argparse.ArgumentParser(
        description="Generate an Avalon wrapper from model.json config")
    parser.add_argument('-c', '--config',
                        help="Directory containing model.json configuration file")
    parser.add_argument('-w', '--working-dir', default=".",
                        help="Working directory to generate the avalon wrapper in")
    args = parser.parse_args()
    return (args.config, args.working_dir )


if __name__ == "__main__":
    (config_dir_arg, working_dir_arg) = parseargs()

    main(config_dir_arg, working_dir_arg)
