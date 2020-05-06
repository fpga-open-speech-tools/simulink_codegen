import os
import subprocess 
import fileinput
from shutil import copyfile
from .qsys_templates import qsys_templates

def create_quartus_settings(config, template):
    """Creates the quartus settings for the system
    
    Arguments:
        config {[dictionary]} -- the user config
        template {[qsys_templates]} -- template object to utilize qsys templates      

    Returns:
        [string] -- A string representing the quartus settings section of the qsys system
    """
    if(config.target_system == "de10"):
        config.device_family = "Cyclone V"
        config.device = "5CSEBA6U23I7"
    elif(config.target_system == "arria10"):
        pass
    ## TODO: ADD device & family for audioblade #config[qsys] will need to be formatted properly
    built_string = template.add_created_by_function_header(create_quartus_settings)
    built_string += template.add_quartus_settings(config.quartus_version, config.system_name, config.device_family, config.device)
    return built_string

    

def create_component_instantiation(config, template, custom_only):
    """Creates the component instantiation section of the qsys system
    
    Arguments:
        config {[dictionary]} -- the user config
        template {[qsys_templates]} -- template object to utilize qsys templates      
    
    Returns:
        [string] -- A string representing the component instantiation section of the qsys system
    """
    built_string = template.add_created_by_function_header(create_component_instantiation)

    if not(custom_only):
        if(config.target_system == "de10"):
            built_string += template.de10_base_component_instantiation(config.quartus_version)
        elif(config.target_system == "arria10"):
            pass
    for custom_component in config.custom_components:
            built_string += template.add_custom_component_instantiaion(custom_component)
    return built_string

def create_exported_interfaces(config, template):
    """Creates the exported interfaces section of the qsys system
    
    Arguments:
        config {[dictionary]} -- the user config
        template {[qsys_templates]} -- template object to utilize qsys templates      
    
    Returns:
        [string] -- A string representing the exported interfaces section of the qsys system
    """
    built_string = template.add_created_by_function_header(create_exported_interfaces)
    if(config.target_system == "de10"):
        built_string += template.add_de10_exported_interfaces()
    elif(config.target_system == "arria10"):
        pass
    return built_string

def create_connections(config, template, custom_only):
    """Creates the connections section of the qsys system
    
    Arguments:
        config {[dictionary]} -- the user config
        template {[qsys_templates]} -- template object to utilize qsys templates      
    
    Returns:
        [string] -- A string representing the connections section of the qsys system
    """
    built_string = template.add_created_by_function_header(create_connections)
    if(config.target_system == "de10"):
        if not(custom_only):
            hps_name = "hps"
            built_string += template.add_de10_base_connections()  
    elif(config.target_system == "arria10"):
        hps_name = "arria10_hps_0"
        pass
    for custom_component in config.custom_components:
            built_string += template.add_de10_custom_component_connections(custom_component, config.target_system)
    return built_string
def create_interconnect_requirements(config, template):
    """Creates the interconnect requirements section of the qsys system
    
    Arguments:
        config {[dictionary]} -- the user config
        template {[qsys_templates]} -- template object to utilize qsys templates    
    
    Returns:
        [string] -- A string representing the interconnect requirements section of the qsys system
    """
    built_string = template.add_created_by_function_header(create_interconnect_requirements)
    if(config.target_system == "de10"):
        built_string += template.add_de10_interconnect_requirements(config.system_name)
    elif(config.target_system == "arria10"):
        pass
    return built_string

def create_qsys_system(config, auto_gen = True, base_path = ""):
    """Creates the tcl file for the Qsys system
    
    Arguments:
        config {[dictionary]} -- the user config
        auto_gen {[Boolean]} -- If true, generates qsys file and VHDL for qsys system
    """
    template = qsys_templates(len(config.custom_components))
    if(config.target_system == "de10"):
        create_de10_system(config, template, auto_gen, base_path)
    elif(config.target_system == "arria10"):
        create_de10_system(config, template, auto_gen, base_path)
        #create_arria10_system(config, template, auto_gen, base_path)
    else:
        print("An invalid target system has been selected")

def create_de10_system(config, template, auto_gen, base_path = ""):
    """Creates a tcl file for a DE-10 & Audio Mini System
    
    Arguments:
        config {[dictionary]} -- the user config
        template {[qsys_templates]} -- template object to utilize qsys templates  
        auto_gen {[Boolean]} -- If true, generates qsys file and VHDL for qsys system
    """
    if not(base_path.endswith("\\")):
        base_path += "\\"
    if(config.target_system == "de10"):
        config.system_name = "de10" + "_system"
        base_qsys_file = "soc_base_system.qsys"
        base_project_file = "de10_proj.tcl"
        top_level_vhd_file = "DE10Nano_System.vhd"
        original_system = "soc_system"
    elif(config.target_system == "arria10"):
        config.system_name = "arria10" + "_system"
        base_project_file = "arria10_proj.tcl"
        base_qsys_file = "som_system.qsys"
        top_level_vhd_file = "A10SoM_System.vhd"
        original_system = "som_system"
    ipx_file = "components.ipx"
    tcl_file = config.system_name + ".tcl"
    qsys_file = config.system_name + ".qsys"
    use_template = True

    abspath = os.path.abspath(__file__)
    dname = os.path.dirname(abspath)

    print("copying files")
    copyfile(dname + "\\" + base_qsys_file, base_path + base_qsys_file)
    copyfile(dname + "\\" + ipx_file, base_path + ipx_file)

    with open(base_path + tcl_file, "w") as out_file:
        if use_template:
            out_file.write(f"package require -exact qsys {template.extract_qsys_version(config.quartus_version)}\n")
            out_file.write(f"load_system {{{base_qsys_file}}}")
            out_file.write(create_component_instantiation(config, template, True))
            out_file.write(create_connections(config, template, True))
            out_file.write(f"save_system {{{qsys_file}}}")
        else:
            out_file.write(create_quartus_settings(config, template))
            out_file.write(create_component_instantiation(config, template, False))
            out_file.write(create_exported_interfaces(config, template))
            out_file.write(create_connections(config, template, False))
            out_file.write(create_interconnect_requirements(config, template))

        
    if not(auto_gen):
        return

    qsys_file_created = False
    qsys_system_generated = False
    qsys_script_cmd = f'cd {base_path} & ' + 'qsys-script ' + f"--script={tcl_file} " + f"--search-path=\"..\\..\\..\\..\\..\\component_library\\**\\*,$\" "
    print(qsys_script_cmd)
    with open(base_path + "qsys_script.log", "w") as log_file:
        creating_qsys_system = subprocess.Popen(qsys_script_cmd, 
                           stdout=log_file,
                           stderr=log_file,
                           shell=True,
                           universal_newlines=True)

    return_code = creating_qsys_system.wait()
    
    if return_code != 0:
        return 1

    print("Generating system")
    qsys_cmd =  f'cd {base_path} & qsys-generate --synthesis=VHDL --search-path=\"..\\component_library\\**\\*,$\"  {qsys_file}'
    print(qsys_cmd)
    with open(base_path + "qsys_gen.log", "w") as log_file:
        generating_qsys_system = subprocess.Popen(qsys_cmd, 
                        stdout=log_file,
                        stderr=log_file,
                        shell=True,
                        universal_newlines=True)
    
    return_code = generating_qsys_system.wait()
    if return_code != 0:
        return 1
    print("Generating make_project.tcl")
    with open(base_path + "make_project.tcl", "w") as proj_file:
        proj_file.write(template.add_quartus_project(config.system_name, config.target_system))
    copyfile(dname + "\\" + base_project_file, base_path + base_project_file)

    with open(dname + "\\" + top_level_vhd_file, "r") as orig_top_file:
        with open(base_path + top_level_vhd_file, "w") as new_top_file:
            for line in orig_top_file:
                new_top_file.write( line.replace( original_system, config.system_name ) )

    print("Generating project")
    proj_gen_cmd = f"cd {base_path} & quartus_sh -t make_project.tcl"
    print(proj_gen_cmd)
    with open(base_path + "project_gen.log", "w") as log_file:
        generating_project = subprocess.Popen(proj_gen_cmd, 
                        stdout=log_file,
                        stderr=log_file,
                        shell=True,
                        universal_newlines=True)
    return_code = generating_project .wait()
    if return_code != 0:
        return 1

    print("Generating rbf file")
    rbf_gen_cmd = f"cd {base_path}\\output_files & quartus_cpf -c -m FPP {config.target_system}.sof {config.target_system}.rbf"
    print(rbf_gen_cmd)
    with open(base_path + "rbf_gen.log", "w") as log_file:
        generating_rbf = subprocess.Popen(rbf_gen_cmd, 
                        stdout=log_file,
                        stderr=log_file,
                        shell=True,
                        universal_newlines=True)
    return_code = generating_rbf .wait()
    if return_code != 0:
        return 1
    
if __name__ == '__main__':
    ## Test code below
    config = ()
    config.model_abbreviation = "MNR"
    config.target = "arria10"
    config.quartus_version = "18.0"
    config.custom_components = ["short_window_mean_reduction"]

    # TODO: Update to no longer have "avalon_source/sink" hardcoded? 
    # Or if hardcoded, look at renaming them to audio in/processed audio out 

    print(create_qsys_system(config, False))