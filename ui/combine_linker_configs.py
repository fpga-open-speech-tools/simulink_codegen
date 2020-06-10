#!/usr/bin/python

# @file combine_linker_configs.py
#
#     Script to combine multiple linker json files into one file
#
#     @author Trevor Vannoy
#     @date 2020
#     @copyright 2020 Flat Earth Inc
#
#     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
#     INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
#     PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
#     FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
#     ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
#     Trevor Vannoy
#     Flat Earth Inc
#     985 Technology Blvd
#     Bozeman, MT 59718
#     support@flatearthinc.com

import json
import argparse

def main(configs, outfile='Linker.json', verbose=False):
    """
    Combine multiple linker json files into one.

    Each linker json file is an object of one or more objects
    representing a device driver interface for a given IP core.
    This function combines each of these objects such that the output 
    is an object containing all of the device driver interface objects.

    Inputs:
        configs = list of linker json filenames
        outfile = name of the output linker json file
        verbose = verbose printing
    """
    combined = {}

    for config in configs:
        with open(config) as fd:
            config_dict = json.load(fd)
            combined.update(config_dict)

    if verbose:
        print('\n')
        print(json.dumps(combined, indent=4, sort_keys=True))

    if verbose:
        print('\n')
        print('wrote new linker file: ' + outfile)
    json.dump(combined, open(outfile, 'w'), indent=4, sort_keys=True)


def parseargs():
    """
    Parse commandline input arguments.
    """
    parser = argparse.ArgumentParser(description=\
        "Combine multiple linker json files into one")
    parser.add_argument('configs',
        help="list of linker files to combine", nargs='+')
    parser.add_argument('-o', '--outfile',
        help="name of combined linker json file", default='Linker.json')
    parser.add_argument('-v', '--verbose', action='store_true', 
        help="verbose output")
    args = parser.parse_args()
    return (args.configs, args.outfile, args.verbose)


if __name__ == "__main__":
    (configs, outfile, verbose) = parseargs()
    main(configs, outfile, verbose)