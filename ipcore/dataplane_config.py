import json
from math import ceil, log
import os
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

    def populate_additional_filesets(self, additionalFilesetAbsDir):
        for filename in os.listdir(additionalFilesetAbsDir):
            if filename.endswith(".vhd") and '_avalon' not in filename and (self.name in filename or "pkg" in filename):
                self.additional_filesets.append(filename)

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
                ceil(log(len(model.devices[deviceIndex].registers))))

        config.sink_max_channel = int(
            ceil(log(model.system.audioIn.numberOfChannels, 2)))
        config.source_max_channel = int(
            ceil(log(model.system.audioOut.numberOfChannels, 2)))
        return config


def model_json_decoder(modelDict):
    return namedtuple('Model', modelDict.keys())(*modelDict.values())
