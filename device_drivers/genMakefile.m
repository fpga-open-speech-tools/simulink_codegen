% genMakefile Generate Makefile and Kbuild for compiling kernel modules
%
% genMakefile(modulePath, modelName)
%
% In order for this function to be platform-independent, the path has to include 
% the proper trailing slash for your operating system. The easiest way to do this 
% is with the _filesep_ command. 
%
% Inputs:
%   modulePath = path to where the kernel module is located
%   modelName = name of the kernel module, without any file extensions

% Copyright 2020 Flat Earth Inc, Montana State University
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

function genMakefile(modulePath, modelName)
py.gen_makefile.main(modulePath, modelName)
