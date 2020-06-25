% genUiConfig Generate json file used to autogenerate gui
%
% genUiConfig(mp, outfile)
%
% This function generates a json file that can be used to autogenerate 
% GUI controls at runtime. To generate GUI controls at runtime, the 
% generated json file needs to be called UI.json and be in the same 
% directory as the nodejs server on the HPS. 
%
% To create a GUI that controls multiple Simulink models running on
% an FPGA, the individual UI json files for each model need to be 
% combined into one json file with combine_ui_configs.py
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

function genUiConfig(mp, outfile)
% NOTE: to get jsonencode to create lists when there is only one struct, 
%       I had to use cell arrays instead of normal arrays. A scalar is the same as a 
%       1x1 array, so that all makes sense. Creating the cell arrays seemed to work 
%       best when I created the cell array outside of the struct constructor. 
%       Essentially, I needed a cell array of [1x1 structs] so jsonencode
%       would create the intended data structure. The data structure creation 
%       in this function could probably be cleaner...

% The GUI name defaults to the model name, but can be changed
% when running combine_ui_configs.py
uiConfig.name = mp.model_name;

module = mp.model_name;

% create the first page and panel
registerControls = createControlObject(mp.register(1), module);
pageName = formatTitle(mp.register(1).uiPageName);
panelName = formatTitle(mp.register(1).uiPanelName);
controls = {registerControls};
panel = {struct('name', panelName)};
panel{1}.controls = controls;
uiConfig.pages = {struct('name', pageName, 'panels', ...
    {panel})};
    

% add the rest of the registers to the UI config
for i=2:length(mp.register)
    registerControls = createControlObject(mp.register(i), module);
    pageName = formatTitle(mp.register(i).uiPageName);
    panelName = formatTitle(mp.register(i).uiPanelName);

    % check if the desired page already exists
    pageIdx = findFieldValue(uiConfig.pages, 'name', pageName);
    if pageIdx
        % page exists, so check if the desired panel exists
        panelIdx = findFieldValue(uiConfig.pages{pageIdx}.panels, 'name', panelName);
        if panelIdx
            % add register to existing panel
            % NOTE: apparently appending to a cell array doesn't work quite like 
            %       appending to a normal array. a = {..., ...}; a = {a, ...} DOES NOT
            %       behave the same as a = [..., ...]; a = [a, ...]. Maybe that's not 
            %       even a good way to append to normal arrays either... 
            %       To append to a cell array, you need to index into a new cell
            registerIdx = length(uiConfig.pages{pageIdx}.panels{panelIdx}.controls) + 1;
            uiConfig.pages{pageIdx}.panels{panelIdx}.controls{registerIdx} = registerControls;
        else
            % panel doesn't exist, so create one and add the register controls
            panelIdx = length(uiConfig.pages{pageIdx}.panels) + 1;
            panel = {struct('name', panelName)};
            panel{1}.controls = {registerControls};
            uiConfig.pages{pageIdx}.panels{panelIdx} = panel{1};
            
        end
    else
        % page doesn't exist, so create a new page and panel for the register controls
        panel = {struct('name', panelName)};
        panel{1}.controls = {registerControls};
        pageIdx = length(uiConfig.pages) + 1;
        uiConfig.pages{pageIdx} = struct('name', pageName, 'panels', {panel});
    end
end
        
writejson(uiConfig, outfile);
end

    
function control = createControlObject(register, module)
% createControlObject Assemble register info into a struct
%
% control = createControlObject(register, module)
%
% This function essentially just renames some fields in the register struct
%
% Inputs:
%   register = register struct from Simulink model init scripts
%   module = the model / device driver name
% Outputs:
%   control = register info packed into a struct for json UI config file
control.linkerName = register.widgetName;
control.type = register.widgetType;
control.min = register.min;
control.max = register.max;
control.dataType = register.dataType.qpointstr;
control.defaultValue = register.default;
control.units = register.widgetDisplayUnits;
control.style = register.widgetStyle;
control.title = formatTitle(register.name);
control.module = module;
end

function idx = findFieldValue(arrayOfStruct, field, value)
% findFieldValue Find a field value in an array of structs
%
% idx = findFieldValue(arrayOfStruct, field, value)
%
% This function loops through an array of structures, looks at
% the given field in each struct, and sees if the given value
% is in any of the structs. If so, it returns the index where that is
% is true, otherwise the index is 0.
% 
% Inputs:
%   arrayOfStruct = array of structures to loop through
%   field = the field to look at in each struct
%   value = the value to look for
%
% Outputs:
%   idx = the index where the field was found
idx = 0;
for i = 1:length(arrayOfStruct)
    if strcmpi(arrayOfStruct{i}.(field), value)
        idx = i;
    end
end
end

function s = formatTitle(str)
% formatTitle Format strings into "Title Case"
%
% s = formatTitle(str)
%
% Formats strings into by separating words and capitalizing 
% each word. This is used for display purposes because we would 
% rather display "Some Register Name" than "some_register_name" in GUIs.
% This function only works on strings where words are separated by
% spaces, hyphens, or underscores.
%
% Inputs:
%   str = the string to format
% Outputs:
%   s = the formatted string

% TODO: add support for camelCase and TitleCase strings?
% split string into words
words = split(str, [" " "_" "-"]);

% capitalize each word
words = cellfun(@(s) [upper(s(1)) s(2:end)], words, 'uniformoutput', false);

% put the words back together with spaces in between
s = join(words, ' ');

% turn cell array into character array (string)
s = s{:};
end