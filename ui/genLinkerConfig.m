% genLinkerConfig Generate linker json file
%
% genLinkerConfig(mp, outfile)
%
% The linker json file tells our node js server on the HPS where 
% registers for a device driver are located in sysfs. This function
% generates a linker file for the model represented by mp. If 
% multiple models are to be run on the FPGA, use combine_linker_configs.py
% to combine linker files for all models of interest.
%
% Inputs:
%   mp = simulink model parameters struct
%   outfile = name of the output linker json file

% Copyright 2020 Audio Logic
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Trevor Vannoy
% Audio Logic
% 985 Technology Blvd
% Bozeman, MT 59718
% openspeech@flatearthinc.com

function genLinkerConfig(mp, outfile)
linkerConfig = struct(mp.model_name, struct());
linkerConfig.(mp.model_name).majorNo = "*";

links = struct();

% map widget name to sysfs file
for register = mp.register
    links.(register.widgetName) = ['/', lower(register.name)];
end

linkerConfig.(mp.model_name).links = links;

writejson(linkerConfig, outfile);