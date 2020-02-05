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
uiConfig.pages = containers.Map();

for register = mp.register
    registerControls = createControlObject(register);

    page = register.ui_page;
    panelName = register.ui_effect_name;
    if uiConfig.pages.isKey(page)
        % page exists, so check if the desired "effect" panel exists
        if uiConfig.pages(page).isKey(panelName)
            panels = uiConfig.pages(page);
            % add register to existing effect panel
            panels(panelName) = [panels(panelName), registerControls];
        else
            % effect panel doesn't exist, so create one
            panels(panelName) = registerControls;
        end
    else
        % page doesn't exist, so create a new page and an "effect" panel
        uiConfig.pages(page) = containers.Map(panelName, registerControls);
    end
end
        
writejson(uiConfig, outfile);
end

    
function controlObject = createControlObject(register)
controlObject.linkerName = register.widget_name;
controlObject.type = register.widget_type;
controlObject.range = [num2str(register.min) '-' num2str(register.max)];
controlObject.defaultValue = register.default;
controlObject.units = register.widget_display_units;
controlObject.style = register.widget_style;
end

