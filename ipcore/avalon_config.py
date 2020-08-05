import json
from pathlib import Path

from .util import Register, Audio

class AvalonConfig:
    """Describe configuration to generate avalon wrapper."""

    def __init__(self, target, audio_in, audio_out, registers=None, working_dir=""):
        """Initialize an empty configuration."""
        self.registers = registers or []
        self.target_system = target
        self.working_dir = working_dir
        self.audio_in = audio_in
        self.audio_out = audio_out

    @staticmethod
    def parse_json(config_filepath):
        """Parse an AvalonConfig from a JSON file.

        Parameters
        ----------
        config_filepath : str
            file path to JSON file to parse

        Returns
        -------
        AvalonConfig
            Parsed configuration
        """
        with open(config_filepath, "r") as file:
            in_str = file.read()
        modeljson = json.loads(in_str)

        working_dir = Path(config_filepath).parent.name
        target = modeljson["system"]["target"]
        json_audio_in = modeljson["system"]["audioIn"]
        audio_in = Audio(
            json_audio_in["wordLength"],
            json_audio_in["fractionLength"], 
            json_audio_in["signed"],
            json_audio_in["numberOfChannels"]
        )

        json_audio_out = modeljson["system"]["audioOut"]
        audio_out = Audio(
            json_audio_out["wordLength"],
            json_audio_out["fractionLength"], 
            json_audio_out["signed"],
            json_audio_out["numberOfChannels"]
        )

        json_registers = modeljson['devices'][0]["registers"]
        registers = []
        for reg in json_registers:
            registers.append(Register(
                reg["name"],
                reg["dataType"]["wordLength"],
                reg["dataType"]["fractionLength"],
                reg["dataType"]["signed"],
                reg["defaultValue"]
                ))
        return AvalonConfig(target, audio_in, audio_out, registers, working_dir)
