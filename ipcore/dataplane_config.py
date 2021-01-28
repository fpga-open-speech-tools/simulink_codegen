import json
from math import ceil, log
import os
import re
from collections import namedtuple


class DataplaneConfig:
    def __init__(self):
        self.name = "Fill me in"
        self.description = ""
        self.version = "1.0"
        self.author = "Autogen"
        self.additional_filesets = []
        self.vendor = "al"
        self.clock_rate = 0

        self.has_avalon_mm_slave_signal = False
        self.data_bus_size = 32
        self.address_bus_size = 0

        self.sink_max_channel = 0
        self.source_max_channel = 0
        self.sink_bits_per_symbol = 24
        self.source_bits_per_symbol = 24

    def populate_additional_filesets(self, additionalFilesetAbsDir, sourceFilePatterns):
        for pattern in sourceFilePatterns:
            
            subdirectories = pattern.split('\\\\')[0:-1]
            regex = pattern.split('\\\\')[-1]
            subdirectory_path = "\\".join(subdirectories)
            search_path = additionalFilesetAbsDir + "\\" + subdirectory_path
            
            matchingFiles = []
            for filename in os.listdir(search_path):
                if (re.match(regex, filename) and not(filename in self.additional_filesets)):
                    if len(subdirectories) > 0:
                        filepath = subdirectory_path + "\\\\" + filename
                    else:
                        filepath = filename
                    matchingFiles.append(filepath)
            self.additional_filesets.extend(matchingFiles)


    @staticmethod
    def parse_json(inputFilename, deviceIndex=0):
        with open(inputFilename, "r") as file:
            in_str = file.read()
        model = json.loads(in_str, object_hook=model_json_decoder)
        config = DataplaneConfig()
        config.name = model.devices[0].name
        config.clock_rate = model.system.systemClockFrequency

        if len(model.devices[deviceIndex].registers) > 0:
            config.has_avalon_mm_slave_signal = True
            config.address_bus_size = int(
                ceil(log(len(model.devices[deviceIndex].registers), 2)))

        config.sink_max_channel = model.system.audioIn.numberOfChannels - 1
        config.source_max_channel = model.system.audioOut.numberOfChannels - 1
        config.sink_bits_per_symbol = model.system.audioIn.wordLength
        config.source_bits_per_symbol = model.system.audioOut.wordLength
        return config


def model_json_decoder(modelDict):
    return namedtuple('Model', modelDict.keys())(*modelDict.values())
