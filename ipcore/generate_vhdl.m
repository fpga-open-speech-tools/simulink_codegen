%% Load the Model
model = mp.modelName;
dataplane_name = 'dataplane';

%% Calculate oversampling factor from sample time
orig_sim_mode = get_param(model, 'SimulationMode');
set_param(model,'SimulationMode','normal')
sampleTimes = Simulink.BlockDiagram.getSampleTimes(mp.modelAbbreviation);
mp.base_rate = 1/sampleTimes(1).Value(1);
if mp.base_rate == Inf
    mp.base_rate = 1/sampleTimes(2).Value(1);
end;
oversampling_factor = mp.Fs_system/mp.base_rate;
set_param(model,'SimulationMode', orig_sim_mode)

%% Model HDL Parameters
hdlset_param(model, ...
    'DateComment', 'off', ...
    'Workflow', 'Generic ASIC/FPGA', ...
    'ModulePrefix', [model '_'], ...
    'CriticalPathEstimation', 'on', ...
    'GenerateHDLTestBench', 'off', ...
    'HDLCodingStandardCustomizations',hdlcodingstd.IndustryCustomizations(), ...
    'HDLGenerateWebview', 'off', ...
    'HDLSubsystem', [model '/' dataplane_name], ...
    'OptimizationReport', 'on', ...
    'ResourceReport', 'off', ...
    'SynthesisTool', 'Altera QUARTUS II', ...
    'SynthesisToolChipFamily', mp.target.deviceFamily, ...
    'SynthesisToolDeviceName', mp.target.device, ...
    'SynthesisToolPackageName', '', ...
    'SynthesisToolSpeedValue', '', ...
    'MapPipelineDelaysToRAM', 'on', ...
    'UseRisingEdge', 'on', ...
    'TargetDirectory', 'hdlsrc', ...
    'TargetFrequency', mp.Fs_system / 1000000, ... % TargetFrequency is in MHz
    'Oversampling', oversampling_factor, ...
    'HierarchicalDistPipelining', 'on', ...
    'MulticyclePathConstraints', 'off', ...
    'ClockRatePipelining', 'on');

%% Workflow Configuration Settings
% Construct the Workflow Configuration Object with default settings
hWC = hdlcoder.WorkflowConfig('SynthesisTool','Altera QUARTUS II','TargetWorkflow','Generic ASIC/FPGA');

% Specify the top level project directory
hWC.ProjectFolder = mp.modelPath;

% Set Workflow tasks to run
hWC.RunTaskGenerateRTLCodeAndTestbench = true;
hWC.RunTaskVerifyWithHDLCosimulation = false;
hWC.RunTaskCreateProject = false;
hWC.RunTaskPerformLogicSynthesis = false;
hWC.RunTaskPerformMapping = false;
hWC.RunTaskPerformPlaceAndRoute = false;
hWC.RunTaskAnnotateModelWithSynthesisResult = false;

% Set properties related to 'RunTaskGenerateRTLCodeAndTestbench' Task
hWC.GenerateRTLCode = true;
hWC.GenerateTestbench = false;
hWC.GenerateValidationModel = false;

% Set properties related to 'RunTaskCreateProject' Task
hWC.Objective = hdlcoder.Objective.None;
hWC.AdditionalProjectCreationTclFiles = '';

% Set properties related to 'RunTaskPerformMapping' Task
hWC.SkipPreRouteTimingAnalysis = false;

% Set properties related to 'RunTaskPerformPlaceAndRoute' Task
hWC.IgnorePlaceAndRouteErrors = false;

% Set properties related to 'RunTaskAnnotateModelWithSynthesisResult' Task
hWC.CriticalPathSource = 'pre-route';
hWC.CriticalPathNumber =  1;
hWC.ShowAllPaths = false;
hWC.ShowDelayData = false;
hWC.ShowUniquePaths = false;
hWC.ShowEndsOnly = false;

% Validate the Workflow Configuration Object
hWC.validate;

if exist('hdlworkflow.m', 'file')
    hdlworkflow;
end

%% Run the workflow
hdlcoder.runWorkflow([model '/' dataplane_name], hWC);
