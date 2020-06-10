%% Load the Model
model = mp.model_abbreviation;
dataplane_name = 'dataplane';
load_system(model);

if mp.target_system == 'de10'
    device_family = 'Cyclone V';
    device = '5CSEBA6U23I7';
elseif mp.target_system == 'arria10'
    device_family = 'Arria 10';
    device = '10AS066H2F34I1HG';
end

%% Model HDL Parameters
hdlset_param(model, ...
    'DateComment', 'off', ...
    'Workflow', 'Generic ASIC/FPGA', ...
    'ModulePrefix', [model '_'], ...
    'CriticalPathEstimation', 'off', ...
    'GenerateHDLTestBench', 'off', ...
    'HDLCodingStandardCustomizations',hdlcodingstd.IndustryCustomizations(), ...
    'HDLGenerateWebview', 'on', ...
    'HDLSubsystem', [model '/' dataplane_name], ...
    'OptimizationReport', 'on', ...
    'ResourceReport', 'on', ...
    'SynthesisTool', 'Altera QUARTUS II', ...
    'SynthesisToolChipFamily', device_family, ...
    'SynthesisToolDeviceName', device, ...
    'SynthesisToolPackageName', '', ...
    'SynthesisToolSpeedValue', '', ...
    'MapPipelineDelaysToRAM', 'on', ...
    'UseRisingEdge', 'on', ...
    'TargetDirectory', 'hdlsrc', ...
    'TargetFrequency', mp.Fs_system);

% TODO: should we always map pipeline delays to ram? 
% TODO: add ability to customize code generation parameters on a per-model basis 

%% Workflow Configuration Settings
% Construct the Workflow Configuration Object with default settings
hWC = hdlcoder.WorkflowConfig('SynthesisTool','Altera QUARTUS II','TargetWorkflow','Generic ASIC/FPGA');

% Specify the top level project directory
hWC.ProjectFolder = mp.model_path;

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

%% Run the workflow
hdlcoder.runWorkflow([model '/' dataplane_name], hWC);
