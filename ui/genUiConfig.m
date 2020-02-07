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
uiConfig.module = mp.model_name;

% create the first page and panel
registerControls = createControlObject(mp.register(1));
pageName = mp.register(1).uiPageName;
panelName = mp.register(1).uiPanelName;
panel = {struct('name', panelName, 'controls', registerControls)};
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
            uiConfig.pages{pageIdx}.panels{panelIdx}.controls(registerIdx) = registerControls;
        else
            % panel doesn't exist, so create one and add the register controls
            uiConfig.pages{pageIdx}.panels = {uiConfig.pages{pageIdx}.panels, ...
                struct('name', panelName, 'controls', registerControls)};
        end
    else
        % page doesn't exist, so create a new page and panel for the register controls
        uiConfig.pages = {uiConfig.pages struct('name', pageName, 'panels', ...
            struct('name', panelName, 'controls', registerControls))};
    end
end
        
writejson(uiConfig, outfile);
end

    
function controlObject = createControlObject(register)
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
idx = 0;
for i = 1:length(arrayOfStruct)
    if strcmpi(arrayOfStruct{i}.(field), value)
        idx = i;
    end
end
end