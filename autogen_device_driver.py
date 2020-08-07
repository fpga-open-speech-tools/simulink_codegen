#!/usr/bin/python

# @file autogen_device_driver.py
#
#     Python script to auto generate device drivers
#
#     @author Dylan Wickham
#     @date 2020
#     @copyright 2020 Audio Logic
#
#     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
#     INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
#     PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
#     FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
#     ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
#     Dylan Wickham
#     Audio Logic
#     985 Technology Blvd
#     Bozeman, MT 59718
#     openspeech@flatearthinc.com

import argparse

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
    generator.write_driver(working_dir + config.device_name + ".c")
    

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
    (config_filepath_arg, working_dir_arg) = parseargs()

    main(config_filepath_arg, working_dir_arg)
