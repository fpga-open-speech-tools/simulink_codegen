import json
import math
import re
from input_structure import InputStructure
def parse_json(inputFilename):
    with open(inputFilename, "r") as file:
        in_str = file.read()
        json_dict = json.loads(in_str)
        input_struct = InputStructure()
        input_struct.name = json_dict['model_name']
        input_struct.quartus_synth_top_level = json_dict['entity'] + "_avalon"
        input_struct.vhdl_top_level_file = json_dict['model_abbreviation'] + "_dataplane_avalon.vhd"
        input_struct.compatible_flag = "dev,fe-" + json_dict['linux_device_name']
        input_struct.group = json_dict['model_name']
        input_struct.vendor = "fe"
        input_struct.clock_rate = json_dict['clocks']['system_frequency_Hz']
        input_struct.clock_abbrev = "clk"
        input_struct.display_name = json_dict['model_name']
        input_struct.model_abbreviation = json_dict['model_abbreviation']
        input_struct.quartus_path = json_dict["quartus_path"]
        input_struct.quartus_version = re.search('.intelFPGA.(\d+\.\d+)', json_dict["quartus_path"]).group(1)   
        input_struct.target_system = json_dict["target_system"]
        input_struct.custom_components = [json_dict['model_name']]

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