% createLinkerWidgetNames Create the widget names used in the UI and linker configs for each register
%
% mp = createLinkerWidgetNames(mp)
%
% To avoid name conflicts between different devices/models, the widget names 
% are of the form <ui element type><#><model name>, e.g. toggle1flanger, slider3bitcrusher, etc.
%
% Inputs:
%   mp = simulink model parameters struct
% Outputs:
%   mp = simulink model parameters struct, with widget names for each register added

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
function mp = createLinkerWidgetNames(mp)

numWidgets = containers.Map();
for i = 1:length(mp.register)
    % keep track of how many registers have a given widget type so 
    % we can increment the widget name accordingly
    widgetType = mp.register(i).widget_type;
    if numWidgets.isKey(widgetType)
        numWidgets(widgetType) = numWidgets(widgetType) + 1;
    else
        numWidgets(widgetType) = 1;
    end

    % widget name is of the form: slider<#><model name>
    widgetName = [widgetType, num2str(numWidgets(widgetType)), mp.model_name];
    mp.register(i).widget_name = widgetName;

end
