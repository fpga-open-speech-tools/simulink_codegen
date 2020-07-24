"""This module provides a template class that generates tcl strings for use with Quartus as well access to the string templates."""

custom_component_base_connections_template = '''
add_connection pll_using_AD1939_MCLK.outclk0 component_name_0.clock
add_connection clock_name.clk_reset component_name_0.reset
add_connection axi_master_name component_name_0.avalon_slave
set_connection_parameter_value axi_master_name/component_name_0.avalon_slave arbitrationPriority {1}
set_connection_parameter_value axi_master_name/component_name_0.avalon_slave baseAddress {component_base_address}
set_connection_parameter_value axi_master_name/component_name_0.avalon_slave defaultConnection {0}
'''
custom_component_initial_audio_in_connection_template = '''
add_connection audio_in component_name_0.avalon_streaming_sink
'''
custom_component_audio_in_connection_template = '''
add_connection last_component_name.avalon_streaming_source component_name_0.avalon_streaming_sink
'''
custom_component_final_audio_out_connection_template = '''
add_connection component_name_0.avalon_streaming_source audio_out
'''

custom_component_instantiation_template = "add_instance component_name_0 component_name 1.0\n"

quartus_project_template = """
set project project_name
set revision project_revision
load_package flow

project_new $project -revision ${revision} -overwrite

source ${target_system}_proj.tcl

#Add files here
files_list

# Add post-compile hook
set_global_assignment -name POST_FLOW_SCRIPT_FILE quartus_sh:gen_rbf.tcl


project_close
"""

quartus_compile_template = """
load_package flow

project_open -revision project_revision project_name

# compile the project
execute_flow -compile

project_close
"""


class QuartusTemplates:
    """Generate templates for Quartus workflow."""

    def __init__(self, num_custom_components, baseAddress):
        """Initialize QuartusTemplates.

        Parameters
        ----------
        num_custom_components : [type]
            [description]
        baseAddress : [type]
            [description]
        """
        self.custom_components_added = 0
        self.num_custom_components = num_custom_components
        self.de10_components_base_address = 20  # Format is 0x0020
        self.last_component_added = ""

    def add_custom_component_instantiaion(self, component_name):
        """Generate a string representing a component being instantiated in _hw.tcl.

        Parameters
        ----------
        component_name : str
            Name of Platform Designer component to instantiate

        Returns
        -------
        str
            String that instantiates the given component in _hw.tcl
        """
        return custom_component_instantiation_template.replace("component_name", component_name)

    def add_custom_component_connections(self, component_name, target):
        """Generate _hw.tcl section for connecting a custom component to the system being made.

        Connects to initial audio source on first call.
        Connects to the last passed in component on future calls.
        Once the number of custom_compoents has been reached, the component also gets connnected to audio out

        Parameters
        ----------
        component_name : str
            Name of Platform Designer component to instantiate
        target : Target
            target configuration tuple 

        Returns
        -------
        str
            Returns _hw.tcl section for connecting a custom component to the system being generated.
        """
        # Increment address by 0x10 each time a custom_component is added
        component_base_address = "0x00" + \
            str(self.de10_components_base_address +
                self.custom_components_added * 10)

        built_string = custom_component_base_connections_template \
            .replace("component_name", component_name) \
            .replace("component_base_address", component_base_address) \
            .replace("axi_master_name", target.axi_master_name) \
            .replace("clock_name", target.clock_name)

        if(self.custom_components_added == 0):
            built_string += custom_component_initial_audio_in_connection_template.replace(
                "component_name", component_name).replace("audio_in", target.audio_in)
        if((self.custom_components_added + 1) == self.num_custom_components):
            built_string += custom_component_final_audio_out_connection_template.replace(
                "component_name", component_name).replace("audio_out", target.audio_out)
            self.custom_components_added = 0
            return built_string

        built_string += custom_component_audio_in_connection_template.replace(
            "component_name", component_name).replace("last_component_name", self.last_component_added)

        self.last_component_added = component_name
        self.custom_components_added += 1

        return built_string

    def add_quartus_project(self, proj_name, project_revision, target):
        """Generate a tcl file that can be run to make a Quartus project.

        Parameters
        ----------
        proj_name : str
            Name of the project
        project_revision : str
            Name of the project revision
        target : Target
            NamedTuple that provides information about the target configuration

        Returns
        -------
        str
            tcl file that describes the project
        """
        files = self.add_files_list(target.files_list)
        return quartus_project_template.replace("project_name", proj_name).replace("project_revision", project_revision).replace("files_list", files)

    def add_quartus_compile_project(self, project_name, project_revision):
        """Generate a tcl file that can be run to compile the given Quartus project.

        Parameters
        ----------
        project_name : str
            Name of the project
        project_revision : str
            Name of the project revision

        Returns
        -------
        str
            tcl file that has the commands to compile the project
        """
        return quartus_compile_template.replace("project_name", project_name).replace("project_revision", project_revision)

    def add_files_list(self, files):
        """Generate tcl commands to add a list of files to an open Quartus project.

        Parameters
        ----------
        files : list of str
            List of files to be added to a Quartus project

        Returns
        -------
        str
            List of tcl commands to add the given files to an open Quartus project
        """
        files_list = ''
        base_string = '\nset_global_assignment -name '
        tcl_file_type = ''
        for file in files:
            if file.endswith('vhd'):
                tcl_file_type = 'VHDL_FILE '
            elif file.endswith('qip'):
                tcl_file_type = 'QIP_FILE '
            elif file.endswith('qsys'):
                tcl_file_type = 'QSYS_FILE '
            else:
                tcl_file_type = 'SOURCE_FILE '
            files_list += base_string + tcl_file_type + file
        return files_list
