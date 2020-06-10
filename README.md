# Simulink Code Generation

## Overview of Quartus Workflow  
The automated Quartus workflow section of Autogen takes the generated Platform Designer component and integrates the component into a Platform Designer system based on the targeted hardware, then creates a Quartus project based off the system, then compiles it to an SRAM Object File (.sof) and converts it to a Raw Binary File (.rbf) 

Deliverables of note  
- Quartus project containing Platform Designer system integrated with custom audio processing effect 
- SRAM Object File (.sof) & Raw Binary File (.rbf) for programming the FPGA
- Sopcinfo file for use with device tree overlay generation   
## Dependencies of the workflow
- Python 3
- Quartus Standard Edition 18 + 
## Officially supported target hardware
- Audioblade
- DE-10 Nano with Audio Mini daughter card
## Using the automated Quartus workflow standalone
Quartus workflows can be automated without the entire autogen software by running autogen_quartus.py directly with its needed arguments of the json configuration file and the working directory of the quartus workflow    
`usage: autogen_quartus.py [-h] [-j JSON] [-w WORKING_DIR]`  
Example usage: 
```
python simulink_codegen/vhdl/autogen_quartus.py -j simulink_models/models/echo/SE_dataplane.json -w simulink_models/models/echo/hdlsrc/echo/
```  
Coupling/dependencies of working directory:   
- Needs _hw.tcl file to be a directory above (or in component library)  
- Needs to be 3 or 5 subdirectories of the Autogen root directory in order for the ipx file to find the component library  
## Quartus steps
Workflow has the following steps:   
- Generate the system  
    - Generate the tcl file describing the system's changes from the base system (if needed)  
    - Generate the qsys file describing the Platform Designer using qsys-script  (if needed)  
    - Generate the system from the qsys file using qsys-generate  
- Generate the project (if needed)
- Compile the project 

### Generating the Qsys file 
The process for generating the system involves first the need to create a tcl file to describe the changes and additions from the base system associated with the target configuration. This consists of adding the new component, then adding connections to the existing system, and saving the system in another qsys file. After the tcl file is created, `qsys-script` is used to generated the qsys file from the tcl file.

The qsys file is not regenerated on future runs of the same target configuration. This enables the system to be customized manually after the initial system generation

### Generating the system  
The Platform Designer system is then generated with `qsys-generate`, the same underlying tool used by the Platform Designer window in Quartus.

### Generating the project   
The process of generating the project consists of 3 steps:  
1. Generating the make_project.tcl
    - Creates the project & specific revision based on targeted hardware
    - Configures project based on targeted hardware 
    - Adds needed files to the project
    - Adds post-compiles hooks like the generation of ".rbf" files
2. Copies filed listed in make_project.tcl to the working directory 
3. Creates the project by running `quartus_sh -t make_project.tcl`

The project is not regenerated if a project is found in the working directory with the same name and project revision. This enables custom project settings to be made manually and persist after the initial project generation.

### Compiling the project
The project is then compiled by creating a simple tcl file that compiles the project and run with the command `quartus_sh -t compile_project.tcl`
After the project has been compiled the gen_rbf.tcl script is automatically run to convert the generated sof file into an rbf programming file

