import os
import subprocess
import fileinput
from shutil import copyfile
from quartus.quartus_templates import quartus_templates
from quartus.target import DE10, Arria10, Target


def create_component_instantiation(config, template):
    """Creates the tcl string to handle component instantiation for a qsys system

    Parameters
    ----------
    config : InputStructure
        User input structure describing the intended generation
    template : quartus_templates
        template object to utilize qsys template

    Returns
    -------
    string
        Component instantiation section of tcl file
    """
    built_string = template.add_created_by_function_header(
        create_component_instantiation)
    for custom_component in config.custom_components:
        built_string += template.add_custom_component_instantiaion(
            custom_component)
    return built_string


def create_connections(target, config, template):
    """Creates the tcl string to handle connections for a qsys system

    Parameters
    ----------
    target : Target
        NamedTuple that provides information about the target configuration
    config : InputStructure
        User input structure describing the intended generation
    template : quartus_templates
        template object to utilize qsys template

    Returns
    -------
    string
        Connections section of tcl file
    """
    built_string = template.add_created_by_function_header(create_connections)
    for custom_component in config.custom_components:
        built_string += template.add_custom_component_connections(
            custom_component, target)
    return built_string


def create_tcl_system_file(target, config, template, working_dir):
    """Creates a tcl file that describes a qsys system

    Parameters
    ----------
    target : Target
        NamedTuple that provides information about the target configuration
    config : InputStructure
        User input structure describing the intended generation
    template : quartus_templates
        template object to utilize qsys templates  
    working_dir : string
        Working directory of the generation process
    """

    base_qsys_file = target.base_qsys_file
    tcl_file = target.system_name + ".tcl"
    qsys_file = target.system_name + ".qsys"
    ipx_file = "components.ipx"

    print("Making tcl file for qsys")
    copyfile(RES_DIR + base_qsys_file, working_dir + base_qsys_file)
    copyfile(RES_DIR + ipx_file, working_dir + ipx_file)

    with open(working_dir + tcl_file, "w") as out_file:
        out_file.write(
            f"package require -exact qsys {config.quartus_version}\n")
        out_file.write(f"load_system {{{base_qsys_file}}}")
        out_file.write(create_component_instantiation(config, template))
        out_file.write(create_connections(target, config, template))
        out_file.write(f"save_system {{{qsys_file}}}")


def run_cmd_and_log(cmd, log_msg, log_file_path, err_on_fail=True):
    """Runs a given command as a subprocess, 
    logs a message to standard out, 
    and logs the output of the command to a logfile 

    Parameters
    ----------
    cmd : string
        Command to run as a subprocess
    log_msg : string
        Message to log to std_out
    log_file_path : string
        Full path of the log file to write to the output of the command to
    err_on_fail : bool, optional
        Throw err if the child process fails, by default True

    Raises
    ------
    ChildProcessError
        Throws error if the command fails
    """
    print(log_msg)
    print(cmd.replace("\\", "\\\\"))
    with open(log_file_path, "w") as log_file:
        process = subprocess.Popen(cmd,
                                   stdout=log_file,
                                   stderr=log_file,
                                   shell=True,
                                   universal_newlines=True)

    return_code = process.wait()
    if return_code != 0 and err_on_fail:
        raise ChildProcessError(
            f"The following command failed {cmd} \n The log file can be found at {log_file_path}")


def gen_qsys_file(tcl_file, working_dir):
    """Generates the qsys file from the tcl file using qsys-script

    Parameters
    ----------
    tcl_file : string
        Name of tcl file to convert into a qsys file
    working_dir : string
        Working directory of the generation process
    """
    #TODO: Updates search path from being a hardcoded (relative) path 
    cmd = f'cd {working_dir} && ' + QSYS_BIN_DIR + 'qsys-script ' + f'--script={tcl_file} ' + f'--search-path="../../../../../component_library/**/*,$" '
    log_file_path = working_dir + "qsys_script.log"
    log_msg = "Generating qsys file from tcl file"
    run_cmd_and_log(cmd, log_msg, log_file_path)


def gen_qsys_system(qsys_file, working_dir):
    """Generates the qsys file using qsys-generate

    Parameters
    ----------
    qsys_file : string
        Qsys file to generate
    working_dir : string
        Working directory of the generation process
    """
    cmd = f'cd {working_dir} && {QSYS_BIN_DIR}qsys-generate --synthesis=VHDL --search-path="../component_library/**/*,$"  {qsys_file}'
    log_file_path = working_dir + "qsys_gen.log"
    log_msg = "Generating system"
    run_cmd_and_log(cmd, log_msg, log_file_path)


def gen_project_tcl(target, template, working_dir):
    """Generates the make_project.tcl file
    Also copies over the top level VHDL file and
    base project tcl file into the working directory

    Parameters
    ----------
    target : Target
        NamedTuple that provides information about the target configuration
    template : quartus_templates
        template object to utilize qsys templates  
    working_dir : string
        Working directory of the generation process
    """

    base_project_file = target.base_proj_tcl_file
    top_level_vhdl_file = target.top_level_vhdl_file
    original_system = target.original_system

    print("Generating make_project.tcl")
    with open(working_dir + "make_project.tcl", "w") as proj_file:
        proj_file.write(template.add_quartus_project(
            target.system_name, target))
    copyfile(RES_DIR + base_project_file, working_dir + base_project_file)

    with open(RES_DIR + top_level_vhdl_file, "r") as orig_top_file:
        with open(working_dir + top_level_vhdl_file, "w") as new_top_file:
            for line in orig_top_file:
                new_top_file.write(line.replace(
                    original_system, target.system_name))
    copyfile(RES_DIR + "gen_rbf.tcl", working_dir + "gen_rbf.tcl")


def gen_pll_qsys(working_dir):
    """Generates the phase locked loop component needed for the arria10 configuration

    Parameters
    ----------
    working_dir : string
        Working directory of the generation process
    """
    pll_file = "pll.qsys"
    copyfile(RES_DIR + "/res/" + pll_file, working_dir + pll_file)
    log_msg = "Generating pll"
    cmd =  f'cd {working_dir} && {QSYS_BIN_DIR}qsys-generate --synthesis=VHDL --search-path="../component_library/**/*,$"  {pll_file}'
    log_file_path = working_dir + "pll_gen.log"

    run_cmd_and_log(cmd, log_msg, log_file_path)


def gen_project(working_dir):
    """Generates and compiles the project defined in make_project.tcl

    Parameters
    ----------
    working_dir : string
        Working directory of the generation process
    """
    log_msg = "Generating and compiling project"
    cmd = f"cd {working_dir} && {QUARTUS_BIN_DIR}quartus_sh -t make_project.tcl"
    log_file_path = working_dir + "project_gen.log"

    run_cmd_and_log(cmd, log_msg, log_file_path)


def gen_rbf(working_dir, target_system):
    """Converts the sof file to an rbf file

    Parameters
    ----------
    working_dir : string
        Working directory of the generation process
    target_system : string
        The target system being generated
    """
    log_msg = "Generating rbf file"
    # Command uses -m FPP for the fast passive parallel which ends up being equivalent to passive parallel x16
    cmd = f"cd {working_dir}/output_files && {QUARTUS_BIN_DIR}quartus_cpf -c -m FPP {target_system}.sof {target_system}.rbf"
    log_file_path = working_dir + "rbf_gen.log"

    run_cmd_and_log(cmd, log_msg, log_file_path)


def execute_quartus_workflow(config, working_dir=""):
    """Executes quartus workflow that creates a system and project, compiles it,
        and converts the output file to an RBF

    Parameters
    ----------
    config : InputStructure
        User input structure describing the intended generation  
    working_dir : str, optional
        Working directory of the generation process, by default ""
    """
    target = None

    if(config.target_system == "de10"):
        target = DE10
    elif(config.target_system == "arria10"):
        target = Arria10
    else:
        raise ValueError(
            f"The provided target: {config.target_system} is not supported")

    abspath = os.path.abspath(__file__)
    dname = os.path.dirname(abspath)
    global RES_DIR
    RES_DIR = os.path.dirname(abspath) + "/res/"
    global QUARTUS_BIN_DIR
    global QSYS_BIN_DIR
    QUARTUS_BIN_DIR = os.environ["QSYS_ROOTDIR"].split("sopc_builder")[
        0] + "bin64\\"
    QSYS_BIN_DIR = os.environ["QSYS_ROOTDIR"] + "\\"

    tcl_file = target.system_name + ".tcl"
    qsys_file = target.system_name + ".qsys"

    template = quartus_templates(
        len(config.custom_components), int(target.base_address))
    os.makedirs(working_dir, exist_ok=True)

    create_tcl_system_file(target, config, template, working_dir)

    gen_qsys_file(tcl_file, working_dir)
    gen_qsys_system(qsys_file, working_dir)
    gen_project_tcl(target, template, working_dir)

    if(config.target_system == "arria10"):
        gen_pll_qsys(working_dir)

    gen_project(working_dir)
