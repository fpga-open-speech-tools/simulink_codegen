#!/usr/bin/python

# @file combine_ui_configs.py
#
#   Script to combine multiple UI json files into one file
#    
#   @author Trevor Vannoy
#   @date 2020
#   @copyright 2020 Flat Earth Inc
#
#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
#   INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
#   PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
#   FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
#   ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
#   Trevor Vannoy
#   Flat Earth Inc
#   985 Technology Blvd
#   Bozeman, MT 59718
#   support@flatearthinc.com

import json
import argparse

def main(configs, name, outfile='UI.json', verbose=False):
    """
    Combine multiple UI json files into one.

    Each UI json file contains a list of pages, each of which has a name and a list panels. 
    Each panel has a name and a list of controls. This function merges pages, panels, and 
    controls from multiple UI json files into one json file that can be used to configure
    a GUI with the UI elements from each UI json file.

    Inputs:
        configs     = list of linker json filenames
        name = UI name (what the UI represents), e.g. hearing aid 
        outfile     = name of the output linker json file
        verbose     = verbose printing
    """
    combined = {'name': name, 'pages': []}
    
    # lambda functions to get lists of page and panel names
    page_names = lambda: [combined['pages'][i]['name'] for i in range(len(combined['pages']))] 
    panel_names = lambda m :[combined['pages'][m]['panels'] for i in range(len(combined['pages'][m]['panels']))]

    for config in configs:
        with open(config) as fd:
            config_dict = json.load(fd)
            for page in config_dict['pages']:
                try:
                    # check if the page exists in the combined config
                    page_idx = page_names().index(page['name'])

                    # page exists, so loop through all panels in the page
                    for panel in page['panels']:
                        try:
                            # check if panel exists in the combined config
                            panel_idx = panel_names(page_idx).index(panel['name'])

                            # panel already exists, so add register controls to the controls list
                            combined['pages'][page_idx]['panels'][panel_idx]['controls'].extend(panel['controls'])
                            if verbose:
                                print('adding controls to panel {}'.format(panel['name']))
                        except ValueError:
                            # panel isn't in the page, so add it
                            combined['pages'][page_idx]['panels'].append(panel)
                            if verbose:
                                print('adding panel {}'.format(panel['name']))
                except ValueError:
                    # page isn't in the combined dictionary, so add it
                    combined['pages'].append(page)
                    if verbose:
                        print('adding page {}'.format(page['name']))

    if verbose:
        print('\n')
        print(json.dumps(combined, indent=4, sort_keys=True))

    if verbose:
        print('\n')
        print('wrote new UI file: ' + outfile)
    json.dump(combined, open(outfile, 'w'), indent=4, sort_keys=True)


def parseargs():
    """
    Parse commandline input arguments.
    """
    parser = argparse.ArgumentParser(description=\
        "Combine multiple UI json files into one")
    parser.add_argument('name', 
        help="what the UI represents (e.g. hearing aid, multi-effects, etc.)")
    parser.add_argument('configs',
        help="list of UI files to combine", nargs='+')
    parser.add_argument('-o', '--outfile',
        help="name of combined UI json file", default='UI.json')
    parser.add_argument('-v', '--verbose', action='store_true', 
        help="verbose output")
    args = parser.parse_args()
    return (args.configs, args.name, args.outfile, args.verbose)


if __name__ == "__main__":
    (configs, name, outfile, verbose) = parseargs()
    main(configs, name, outfile, verbose)
