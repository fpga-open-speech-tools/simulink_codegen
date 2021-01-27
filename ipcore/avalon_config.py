import json
from pathlib import Path

from .util import Register, Audio, DataType


class AvalonConfig:
    """Describe configuration to generate avalon wrapper."""

    def __init__(self, target, audio_in, audio_out, entity_name, registers=None, working_dir="", is_sample_based=False):
        """Initialize an empty configuration."""
        self.registers = registers or []
        self.target_system = target
        self.working_dir = working_dir
        self.audio_in = audio_in
        self.audio_out = audio_out
        self.entity_name = entity_name
        self.is_sample_based = is_sample_based

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
            modeljson = json.load(file)

        working_dir = Path(config_filepath).parent.name
        target = modeljson["system"]["target"]
        json_audio_in = modeljson["system"]["audioIn"]
        audio_in = Audio(
            DataType(
                json_audio_in["wordLength"],
                json_audio_in["fractionLength"],
                json_audio_in["signed"]
                ),
            json_audio_in["numberOfChannels"],
            json_audio_in.get("dual") or False
        )

        json_audio_out = modeljson["system"]["audioOut"]
        audio_out = Audio(
            DataType(
                json_audio_out["wordLength"],
                json_audio_out["fractionLength"],
                json_audio_out["signed"]
                ),
            json_audio_out["numberOfChannels"],
            json_audio_out.get("dual") or False
        )

        json_registers = modeljson['devices'][0]["registers"]
        registers = []
        for reg in json_registers:
            direction = reg.get("direction") or "in"
            registers.append(Register(
                reg["name"],
                DataType(
                    reg["dataType"]["wordLength"],
                    reg["dataType"]["fractionLength"],
                    reg["dataType"]["signed"]
                    ),
                reg["defaultValue"],
                direction
            ))
        entity_name = modeljson['devices'][0]["name"] + "_dataplane"
        is_sample_based = modeljson['system']['processing'].lower() == "sample"
        return AvalonConfig(target, audio_in, audio_out, entity_name, registers, working_dir, is_sample_based)
