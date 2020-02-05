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
