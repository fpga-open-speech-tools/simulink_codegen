% vgen_process_simulink_model
%
% This script parses the simulink model and extracts the interface signals
% and puts this information in a JSON file.

% Copyright 2019 Audio Logic
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Ross K. Snider, Trevor Vannoy
% Audio Logic
% 985 Technology Blvd
% Bozeman, MT 59718
% openspeech@flatearthinc.com

%% Generate the Simulink model VHDL code
mp.generation_active = 1;
% run the hdl coder
%try
    generate_vhdl;
%catch
%    mp.generation_active = 0;
%    return;
%end;
mp.generation_active = 0;

mdlrefs = find_mdlrefs(mp.modelName);
prefix = hdlget_param(mp.modelName, 'ModulePrefix');
sourcePatterns = [".*_pkg\.vhd"];

for n = 1:numel(mdlrefs)
    mdlref = string(mdlrefs{n});
    if mdlref == mp.modelName
        sourcePatterns(end + 1) = prefix + "(?!avalon).*\.vhd";
    else
        sourcePatterns(end + 1) = mdlref + filesep + filesep + prefix + ".*\.vhd";
    end
end

sourcePatternsStr = "";
for pattern = sourcePatterns
    sourcePatternsStr =  sourcePatternsStr + " " + string('"') + pattern + '"'; 
end


% this is where hdlworkflow puts the vhdl files
hdlpath = [mp.modelPath filesep 'hdlsrc' filesep mp.modelAbbreviation];

if system("python3 --version") == 0
    python = "python3 ";
else 
    [status, output] = system("python --version");
    if status == 0 && contains(output, "Python 3.")
        python = "python ";
    else 
        disp('Python 3 was not found on the path. This must be fixed before continuing')
        return;
    end
end

%% Generate the Avalon VHDL wrapper for the VHDL code generated by the HDL Coder
disp('vgen: Creating Avalon VDHL wrapper.')
config_dir = [mp.modelPath];
config_filepath = [mp.modelPath filesep 'model.json'];
config_file = ['model.json'];
outfile = [hdlpath filesep mp.modelName '_dataplane_avalon.vhd'];

avalon_gen_cmd = python + mp.codegen_path + filesep + "autogen_avalon_wrapper.py -c " + config_dir + " -w " + hdlpath;
disp(avalon_gen_cmd)
system(avalon_gen_cmd);
disp(['      created vhdl file: ' outfile])

%% Generate the .tcl script to be used by Platform Designer in Quartus
disp('vgen: Creating .tcl script for Platform Designer.')
% NOTE: platform designer only adds components if they have the _hw.tcl suffix
outfile = [hdlpath filesep mp.modelName '_dataplane_avalon_hw.tcl'];

hw_tcl_cmd = python + mp.codegen_path + filesep + "autogen_hw_tcl.py -c " + config_file + " -w " + hdlpath + " -o " + outfile + " -s " + sourcePatternsStr;

disp(hw_tcl_cmd)
system(hw_tcl_cmd);

disp(['      created tcl file: ' outfile])

disp('vgen: Executing Quartus workflow')
if ispc; second_cmd = "&"; else; second_cmd = ";"; end
working_dir = hdlpath + "/quartus/";

quartus_workflow_cmd = python + mp.codegen_path + "/autogen_quartus.py -c " + config_filepath ...
    + " -w " + working_dir + " -l " + second_cmd + " exit &";
disp(quartus_workflow_cmd)
system(quartus_workflow_cmd);

% Stream the Quartus workflow log and display it to the user
fid = fopen("autogen_quartus.log");
if fid>0
    while 1
        % read the current line
        where = ftell(fid);
        line = fgetl(fid);
        % Print file until exit is encountered
        if line == -1
            pause(20/1000)
            fseek(fid, where, 'bof');
        elseif line == "exit"
            break
        else
            disp(line)
        end
    end
    fclose(fid);
end

disp('Executed Quartus workflow')

%% Generate the device driver code
disp('Creating device driver.')
outfile = [hdlpath filesep mp.modelName '.c'];
device_driver_cmd = python + mp.codegen_path + "/autogen_device_driver.py -c " + config_filepath ...
    + " -w " + hdlpath ;
disp(device_driver_cmd)
system(device_driver_cmd);
disp(['      created device driver: ' outfile])

%% Generate kernel module build files
disp('Creating Makefile and Kbuild.')
system(python + mp.driver_codegen_path + filesep + "gen_makefile.py " + [hdlpath filesep] + " " + mp.modelName);
disp(['      created Makefile: ' [hdlpath filesep 'Makefile']])
disp(['      created Kbuild: ' [hdlpath filesep 'Kbuild']])

%% Build kernel module
disp('Building kernel module.')
cd(hdlpath)
if ispc
    if system('wsl.exe cd') == 0 
        !wsl.exe make clean
        !wsl.exe make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
    else
        disp("Windows Subsystem for Linux is currently required to automate building kernel modules")
    end
elseif isunix
    !make clean
    !make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
else
    disp('The current operating system is unsupported for automatically building kernel modules')
end

% TODO: this file now generates C code, but "vgen" make it seem like it is just VHDL still. This should be changed, and the repository should be reorganized a bit. 
%% Build Device Tree blob
target = lower(char(mp.target));
project_revision = mp.modelName + "_" + target;
sopcinfo_file = hdlpath + "/quartus/" + target + '_system.sopcinfo';
disp("Generating device tree source file")
if target == "reflex" || target == "audioblade"
    extra_flag = " -d " + project_revision
else
    extra_flag = " -r " + project_revision;
end
disp(python + mp.dtogen_path + filesep + "generate.py -s " + sopcinfo_file + extra_flag + " -o " + hdlpath)
system(python + mp.dtogen_path + filesep + "generate.py -s " + sopcinfo_file + extra_flag + " -o " + hdlpath);

disp("Compiling device tree source file")

if ispc
    if system('wsl.exe cd') == 0 
        system("wsl.exe dtc -@ -O dtb -o " + project_revision + ".dtbo " + project_revision + ".dts");
    else
        disp("Windows Subsystem for Linux is currently required to automate compiling device tree overlays")
    end
elseif isunix
    system("dtc -@ -O dtb -o " + project_revision + ".dtbo " + project_revision + ".dts");
else
    disp('The current operating system is unsupported for automatically compiling device tree overlays')
end

disp('')
disp('Upload the following artifacts to S3 for deployment:')

paths = string(mp.modelPath) + filesep + "model.json";
paths(end+1) = string(hdlpath) + filesep + mp.modelName + ".ko";
paths(end+1) = string(hdlpath) + filesep + mp.modelName + "_" + target + ".dtbo";
paths(end+1) = string(hdlpath) + "quartus" + filesep + "output_files" + ...
    filesep + mp.modelName + "_" + target + ".rbf"; 
for artifactPath = paths
    disp(["   " + artifactPath])
end

disp('')
disp('vgen: Finished.')

% reset fast simulation flag so running the model simulation isn't so slow after generating code. 
mp.fastsim_flag = 1;

% turn simulation prompts and callbacks back on for normal simulation.
mp.sim_prompts = 1;
