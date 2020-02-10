% genUiConfig Generate json file used to autogenerate gui
%
% genUiConfig(mp, outfile)
%
%
% Inputs:
%   mp = simulink model parameters struct
%   outfile = name of the output linker json file

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

function genUiConfig(mp, outfile)
% NOTE: to get jsonencode to create lists when there is only one struct, 
%       I had to use cell arrays instead of normal arrays. A scalar is the same as a 
%       1x1 array, so that all makes sense. Creating the cell arrays seemed to work 
%       best when I created the cell array outside of the struct constructor. 
%       Essentially, I needed a cell array of [1x1 structs] so jsonencode
%       would create the intended data structure. The data structure creation 
%       in this function could probably be cleaner...

uiConfig.module = mp.model_name;

% create the first page and panel
registerControls = createControlObject(mp.register(1));
pageName = mp.register(1).uiPageName;
panelName = mp.register(1).uiPanelName;
controls = {registerControls};
panel = {struct('name', panelName)};
panel{1}.controls = controls;
uiConfig.pages = {struct('name', pageName, 'panels', ...
    {panel})};
    

% add the rest of the registers to the UI config
for i=2:length(mp.register)
    registerControls = createControlObject(mp.register(i));
    pageName = mp.register(i).uiPageName;
    panelName = mp.register(i).uiPanelName;

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

    
function controlObject = createControlObject(register)
% createControlObject Assemble register info into a struct
%
% controlObject = createControlObject(register)
%
% This function essentially just renames some fields in the register struct
%
% Inputs:
%   register = register struct from Simulink model init scripts
% Outputs:
%   controlObject = register info packed into a struct for json UI config file
controlObject.linkerName = register.widget_name;
controlObject.type = register.widget_type;
controlObject.min = register.min;
controlObject.max = register.max;
controlObject.dataType = register.dataType.qpointstr;
controlObject.defaultValue = register.default;
controlObject.units = register.widget_display_units;
controlObject.style = register.widget_style;
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