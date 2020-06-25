import json
import math
import re
import os

class DataplaneConfig:
    def __init__(self):
        self.description = ""
        self.name = "Fill me in"
        self.version = "1.0"
        self.internal = False
        self.opaque_address_map = True
        self.author = ""
        self.display_name = "Fill me in"
        self.model_abbreviation = "Fill me in"
        self.inst_in_sys_mod = True
        self.editable = True
        self.report_to_talkback = False
        self.allow_greybox_generation = False
        self.report_hierarchy = False
        self.additional_module_properties = []
        self.custom_components = []

        self.quartus_path = ""
        self.quartus_version = ""
        self.quartus_synth_top_level = "Fill me in"
        self.enable_rel_inc_paths = False
        self.enable_file_overwrite = False
        self.vhdl_top_level_file = "Fill me in"
        self.additional_filesets = []

        self.parameters = []

        self.compatible_flag = "Fill me in"
        self.group = "Fill me in"
        self.vendor = "al"
        self.target_system = ""

        self.clock_rate = 0
        self.clock_abbrev = "clk"

        self.has_avalon_mm_slave_signal = True
        self.avalon_mm_slave_signal_name = "Fill me in (or not)"
        self.data_bus_size = 32
        self.address_bus_size = 0

        self.has_sink_signal = True
        self.sink_signal_name = "Fill me in (or not)"
        self.sink_signal_port_names_and_widths = {} #{"channel": 2, "data": 32, "error": 3, "valid": 1}
        self.sink_max_channel = 0

        self.has_source_signal = True
        self.source_signal_name = "Fill me in (or not)"
        self.source_signal_port_names_and_widths = {} #{"channel": 2, "data": 32, "error": 3, "valid": 1}
        self.source_max_channel = 0

    
    def populate_additional_filesets(self, additionalFilesetAbsDir):
        for filename in os.listdir(additionalFilesetAbsDir):
            if filename.endswith(".vhd") and '_avalon' not in filename and self.model_abbreviation in filename:
                self.additional_filesets.append(filename)
    
    @staticmethod
    def parse_json(inputFilename):
        with open(inputFilename, "r") as file:
            in_str = file.read()
            json_dict = json.loads(in_str)
            input_struct = DataplaneConfig()
            input_struct.name = json_dict['model_name']
            input_struct.quartus_synth_top_level = json_dict['entity'] + "_avalon"
            input_struct.vhdl_top_level_file = json_dict['model_abbreviation'] + "_dataplane_avalon.vhd"
            input_struct.group = json_dict['model_name']
            input_struct.vendor = "al"
            input_struct.compatible_flag = f"dev,{input_struct.vendor}-" + json_dict['linux_device_name']
            input_struct.clock_rate = json_dict['clocks']['system_frequency_Hz']
            input_struct.clock_abbrev = "clk"
            input_struct.display_name = json_dict['model_name']
            input_struct.model_abbreviation = json_dict['model_abbreviation']

            if json_dict['avalon_memorymapped_flag'] == 1:
                input_struct.avalon_mm_slave_signal_name = 'avalon_slave'
                input_struct.has_avalon_mm_slave_signal = True
                input_struct.data_bus_size = 32
                input_struct.address_bus_size = int(math.ceil(math.log(len(json_dict['avalon_memorymapped']['register']))))
            if json_dict['avalon_sink_flag'] == 1:
                input_struct.sink_signal_name = 'avalon_streaming_sink'
                input_struct.has_sink_signal = True
                for signal in json_dict['avalon_sink']['signal']:
                    input_struct.sink_signal_port_names_and_widths[signal['name']] = signal['data_type']['width']
                    if 'channel' in signal['name']:
                        input_struct.sink_max_channel = int(math.pow(2, input_struct.sink_signal_port_names_and_widths[signal['name']]) - 1)
            if json_dict['avalon_source_flag'] == 1:
                input_struct.source_signal_name = 'avalon_streaming_source'
                input_struct.has_source_signal = True
                for signal in json_dict['avalon_source']['signal']:
                    input_struct.source_signal_port_names_and_widths[signal['name']] = signal['data_type']['width']
                    if 'channel' in signal['name']:
                        input_struct.source_max_channel = int(math.pow(2, input_struct.source_signal_port_names_and_widths[signal['name']]) - 1)
        return input_struct
