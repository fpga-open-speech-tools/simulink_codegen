% Kill existing compile
if bdroot ~= "" && strcmp(get_param(bdroot,'SimulationStatus'), 'stopped') == 0
    set_param(gcs, 'SimulationCommand', 'stop')
    cmd = [bdroot,'([],[],[],''term'');'];
    try
        eval(cmd)
    catch
    end
end
if exist('mp','var') == 0
    sm_run_me_first;
    %pause(3)
end
cmd = [bdroot,'([],[],[],''compile'');'];
    try
        eval(cmd)
    catch
    end
%end
pause(5)
get_param(bdroot,'SimulationStatus')
vgen_process_simulink_model
