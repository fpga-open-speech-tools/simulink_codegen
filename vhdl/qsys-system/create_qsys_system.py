from qsys_templates import qsys_templates

def create_quartus_settings(config, template):
    """Creates the quartus settings for the system
    
    Arguments:
        config {[dictionary]} -- the user config
        template {[qsys_templates]} -- template object to utilize qsys templates      

    Returns:
        [string] -- A string representing the quartus settings section of the qsys system
    """
    if(config["target"] == "de10"):
        config["device_family"] = "Cyclone V"
        config["device"] = "5CSEBA6U23I7"
    elif(config["target"] == "arria10"):
        pass
    ## TODO: ADD device & family for audioblade #config[qsys] will need to be formatted properly
    built_string = template.add_created_by_function_header(create_quartus_settings)
    built_string += template.add_quartus_settings(config["quartus"], config["system_name"], config["device_family"], config["device"])
    return built_string

    

def create_component_instantiation(config, template):
    """Creates the component instantiation section of the qsys system
    
    Arguments:
        config {[dictionary]} -- the user config
        template {[qsys_templates]} -- template object to utilize qsys templates      
    
    Returns:
        [string] -- A string representing the component instantiation section of the qsys system
    """
    built_string = template.add_created_by_function_header(create_component_instantiation)

    if(config["target"] == "de10"):
        built_string += template.de10_base_component_instantiation(config["quartus"])
        for custom_component in config["custom_components"]:
            built_string += template.add_custom_component_instantiaion(custom_component)
    elif(config["target"] == "arria10"):
        pass
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
    if(config["target"] == "de10"):
        built_string += template.add_de10_exported_interfaces()
    elif(config["target"] == "arria10"):
        pass
    return built_string

def create_connections(config, template):
    """Creates the connections section of the qsys system
    
    Arguments:
        config {[dictionary]} -- the user config
        template {[qsys_templates]} -- template object to utilize qsys templates      
    
    Returns:
        [string] -- A string representing the connections section of the qsys system
    """
    built_string = template.add_created_by_function_header(create_connections)
    if(config["target"] == "de10"):
        built_string += template.add_de10_base_connections()
        for custom_component in config["custom_components"]:
            built_string += template.add_de10_custom_component_connections(custom_component)
    elif(config["target"] == "arria10"):
        pass
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
    if(config["target"] == "de10"):
        built_string += template.add_de10_interconnect_requirements(config["system_name"])
    elif(config["target"] == "arria10"):
        pass
    return built_string

def create_qsys_system(config):
    """Creates the tcl file for the Qsys system
    
    Arguments:
        config {[dictionary]} -- the user config
    """
    template = qsys_templates(len(config["custom_components"]))
    if(config["target"] == "de10"):
        create_de10_system(config, template)
    elif(config["target"] == "arria10"):
        create_arria10_system(config, template)
    else:
        print("An invalid target system has been selected")

def create_de10_system(config, template):
    """Creates a tcl file for a DE-10 & Audio Mini System
    
    Arguments:
        config {[dictionary]} -- the user config
        template {[qsys_templates]} -- template object to utilize qsys templates  
    """
    config["system_name"] = "de10" + "_system"
    with open(config["system_name"] + ".tcl", "w") as out_file:
        out_file.write(create_quartus_settings(config, template))
        out_file.write(create_component_instantiation(config, template))
        out_file.write(create_exported_interfaces(config, template))
        out_file.write(create_connections(config, template))
        out_file.write(create_interconnect_requirements(config, template))

def create_arria10_system(config, template):
    """Creates a tcl file for the Arria-10 based Audioblade
    
    Arguments:
        config {[dictionary]} -- the user config
        template {[qsys_templates]} -- template object to utilize qsys templates  
    """
    pass

## Test code below
config = {}
config["model_abbreviation"] = "MNR"
config["target"] = "de10"
config["quartus"] = "18.0"
#config["system_name"] = "soc_system"
config["custom_components"] = []
custom_component = { "name": "mean_nse_reduction"}
config["custom_components"].append("short_window_mean_reduction")

print(create_qsys_system(config))