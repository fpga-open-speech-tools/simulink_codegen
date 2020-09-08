import json
import math
import re
import os
from collections import namedtuple

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
            if filename.endswith(".vhd") and '_avalon' not in filename and (self.model_abbreviation in filename or "pkg" in filename):
                self.additional_filesets.append(filename)
    
    @staticmethod
    def parse_json_from_legacy(json_dict):
        input_struct = DataplaneConfig()
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

    def parse_json(inputFilename):
        with open(inputFilename, "r") as file:
                in_str = file.read()
        model = json.loads(in_str, object_hook=modelJsonDecoder)
        legacy_dict = {}
        legacy_dict["avalon_sink_flag"] = 1
        legacy_dict["avalon_source_flag"] = 1
        legacy_dict["avalon_memorymapped_flag"] = 1 if len(model.devices[0].registers) > 0 else 0
        legacy_dict["entity"] = model.devices[0].name + "_dataplane"
        legacy_dict["model_name"] = model.devices[0].name
        legacy_dict["linux_device_name"] = model.devices[0].name
        legacy_dict["model_abbreviation"] = model.devices[0].name
        legacy_dict["clocks"] = {
            "sample_frequency_Hz": model.system.sampleClockFrequency,
            "system_frequency_Hz": model.system.systemClockFrequency,
            "sample_period_seconds": 1 / model.system.sampleClockFrequency,
            "system_period_seconds": 1 / model.system.systemClockFrequency
        }
        legacy_dict["avalon_sink"] = {
            "signal": [
                {
                    "name": "avalon_sink_valid",
                    "data_type": {
                        "width": 1,
                        "type": "boolean",
                        "signed": False,
                        "fractional_bits": 0
                    }
                },
                {
                    "name": "avalon_sink_data",
                    "data_type": {
                        "width": 32,
                        "type": "sfix32_En28",
                        "signed": model.system.audioIn.signed,
                        "fractional_bits": 28
                    }
                }, 
                {
                    "name": "avalon_sink_channel",
                    "data_type": {
                        "width": int(math.ceil(math.log(model.system.audioIn.numberOfChannels, 2))),
                        "type": "ufix4",
                        "signed": False,
                        "fractional_bits": 0
                    }
                }, 
                {
                    "name": "avalon_sink_error",
                    "data_type": {
                        "width": 2,
                        "type": "ufix2",
                        "signed": False,
                        "fractional_bits": 0
                    }
                }
            ]
        }
        legacy_dict["avalon_source"] = {
            "signal": [
                {
                    "name": "avalon_source_valid",
                    "data_type": {
                        "width": 1,
                        "type": "boolean",
                        "signed": False,
                        "fractional_bits": 0
                    }
                },
                {
                    "name": "avalon_source_data",
                    "data_type": {
                        "width": 32,
                        "type": "sfix32_En28",
                        "signed": model.system.audioOut.signed,
                        "fractional_bits": 28
                    }
                },
                {
                    "name": "avalon_source_channel",
                    "data_type": {
                        "width": int(math.ceil(math.log(model.system.audioOut.numberOfChannels, 2))),
                        "type": "ufix1",
                        "signed": False,
                        "fractional_bits": 0
                    }
                },
                {
                    "name": "avalon_source_error",
                    "data_type": {
                        "width": 2,
                        "type": "ufix2",
                        "signed": False,
                        "fractional_bits": 0
                    }
                }
            ]}
        legacy_dict["avalon_memorymapped"] = {
            "register" : generate_legacy_register(model.devices[0].registers)
        }
        return DataplaneConfig.parse_json_from_legacy(legacy_dict)

def generate_legacy_register(new_registers):
    old_registers = []
    for reg in new_registers:
        old_reg = {
            "default_value": reg.defaultValue,
                "name": reg.name,
                "data_type": {
                    "width": reg.dataType.wordLength,
                    "type": "",
                    "signed": reg.dataType.signed,
                    "fractional_bits": reg.dataType.fractionLength
                },
            "reg_num": reg.registerNumber,
            "max_value": 0,
            "min_value": 0
        }
        old_registers.append(old_reg)
    return old_registers

def modelJsonDecoder(modelDict):
    return namedtuple('Model', modelDict.keys())(*modelDict.values())
