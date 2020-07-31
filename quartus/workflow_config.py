import json
import math
import os


class WorkflowConfig:
    """Describe configuration to execute a Quartus workflow."""

    def __init__(self):
        """Initialize an empty configuration."""
        self.custom_components = []
        self.target_system = ""
        self.clock_rate = 0
        self.working_dir = ""

    @staticmethod
    def parse_json(inputFilepath):
        """Parse a WorkflowConfig from a JSON file.

        Parameters
        ----------
        inputFilepath : str
            file path to JSON file to parse

        Returns
        -------
        WorkflowConfig
            Parsed configuration
        """
        with open(inputFilepath, "r") as file:
            in_str = file.read()
            json_dict = json.loads(in_str)
            config = WorkflowConfig()
            print(json_dict)
            config.clock_rate = json_dict['system']['systemClockFrequency']
            config.target_system = json_dict['system']['target']
            devices = json_dict['devices']
            config.custom_components = []
            for device in devices:
                config.custom_components.append(device['name'])
        return config
