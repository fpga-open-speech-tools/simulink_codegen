%% Execute the Autogen process

modelName = bdroot;

% Kill existing compile
if modelName ~= "" && strcmp(get_param(modelName,'SimulationStatus'), 'stopped') == 0
    set_param(gcs, 'SimulationCommand', 'stop')
    cmd = [modelName,'([],[],[],''term'');'];
    try
        eval(cmd)
    catch
    end
end

% If workspace has been cleared, attempts to run sm_run_me_first to initialize mp
if exist('mp','var') == 0
    sm_run_me_first;
end
% Attempts to compile the model
cmd = [modelName,'([],[],[],''compile'');'];

eval(cmd)

% Run through rest of Autogen process
vgen_process_simulink_model
