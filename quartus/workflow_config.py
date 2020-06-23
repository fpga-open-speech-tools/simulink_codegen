import json
import math
import os

class WorkflowConfig:
    def __init__(self):
        self.custom_components = []
        self.target_system = ""
        self.clock_rate = 0
        self.working_dir = ""

    
    @staticmethod
    def parse_json(inputFilename):
        with open(inputFilename, "r") as file:
            in_str = file.read()
            json_dict = json.loads(in_str)
            config = WorkflowConfig()
           
            config.clock_rate = json_dict.get('clocks') and json_dict.get('clocks')['system_frequency_Hz']
            config.target_system = json_dict.get("target_system")
            config.custom_components = json_dict.get("custom_components") or [json_dict.get('model_name')]
            config.working_dir = json_dict.get("working_dir")
        return config
