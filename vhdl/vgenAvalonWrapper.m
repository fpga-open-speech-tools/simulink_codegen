% vgenAvalonWrapper Generate an Avalon vhdl wrapper from a json input file
%
% vgenAvalonWrapper(infile, outfile, verbose, print_output)
%
% The json file this function expects has a specific format that contains information about the vhdl entity and
% the Avalon streaming interface parameters. This will often be generated by MATLAB/Simulink, but it can also be written
% by hand. An example of the format is shown below. This function calls a python script of the same name that generates
% the vhdl.
% TODO: add example json file
%
% Inputs:
%   infile = the json input filename
%   outfile = the vhdl output filename
%   verbose = verbose output
%   print_output = print the output vhdl in the console

% Copyright 2019 Flat Earth Inc, Montana State University
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Trevor Vannoy
% Flat Earth Inc
% 985 Technology Blvd
% Bozeman, MT 59718
% support@flatearthinc.com

function vgenAvalonWrapper(infile, outfile, verbose, print_output)

% TODO: add default values to input arguments

% call the python file that autogens the vhdl code
py.vgenAvalonWrapper.main(infile, outfile, verbose, print_output)
