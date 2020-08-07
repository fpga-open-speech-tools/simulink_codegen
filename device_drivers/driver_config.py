#!/usr/bin/python

# @file driver_config.py
#
#     Python class to read and parse device driver config
#
#     @author Dylan Wickham
#     @date 2020
#     @copyright 2020 Audio Logic
#
#     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
#     INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
#     PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
#     FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
#     ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
#     Dylan Wickham
#     Audio Logic
#     985 Technology Blvd
#     Bozeman, MT 59718
#     openspeech@flatearthinc.com

import json
from device_drivers.device import DeviceType
from device_drivers.device_attributes import DeviceAttribute, DataType

class DriverConfig:
    """The configuration for the driver being generated."""

    def __init__(self):
        """Initialize driver configuration."""
        # device specifications
        self.device_name = None
        self.device_type = None  
        self.device_name_abbrev = None  
        self.compatible = None  # Sets the compatible key on Linux, telling it what devices it is compatible with. Ex: "dev,fe-AD1939"
        self.device_address = None
        self.vendor = "al" 

        # device attribute specifications
        self.device_attributes = None  # list of string attributes
        #                             for the attribute at the same index
        self.attrWriteCommBytes = None  # number of bytes in a command. Should be same as len(self.attrWritComm[0])
        self.attrWriteComm = None  # of the form [ ["0xNN", "0xNN", ..] ..] for however many bytes a command contains,
        #                            and however many attributes there are. They are matched according to index
        self.attributeWriteOffsets = None  # used for fpga's only i think. should be of the form [ [ "OFFSET_N", "OFFSET_N" ..] ..]
        #                            for each attribute it should be the defined constants which are added to devp->regs

        # initial command information
        self.initComm = None  # initial commands that get run in init. 2d list [ ["0xNN", "0xNN", ..] ..]
        self.initCommBytes = None  # number of bytes in a initialization command. Should be same as len(initComm[0])
        self.initCommLen = None  # number of initialization commands. Should be same as len(initComm)
        self.initCommSendFunc = None  # function that sends each command, spi_master_write, for instance
        self.initCommSendParams = None  # parameters that should be inserted for the commSendFunc. ie "dev,cmd,sizeof(cmd)"

        # AD1939/TPA6032A volume properties
        self.needsVolumeTable = None  # true if the device needs a volume table
        self.volumeTable = None  # should be filled in with [ [ <val>, "0xNN"] .. ] in decreasing order of val
        self.PN_INDEX = None  # index where the val goes from positive to negative

        # SPI properties
        self.speed = 500000  # not even sure what this is
        self.mode = None  # rising edge or whatever
        self.chipSelect = None  # not even sure what this is either


        # min and max for each attribute
        # look for data type var
    @staticmethod
    def parse_json(json_filepath):
        """Parse JSON file into driver configuration.

        Parameters
        ----------
        json_filepath : str
            file path to JSON configuration file

        Returns
        -------
        DriverConfig
            Returns an instance of DriverConfig parsed from the JSON file
        """
        file = open(json_filepath, "r")
        file_str = file.read()
        json_dict = json.loads(file_str)
        input_struct = DriverConfig()

        input_struct.device_name = json_dict['devices'][0]['name']
        input_struct.device_type = DeviceType.FPGA
        input_struct.device_name_abbrev = input_struct.device_name
        input_struct.compatible = f'dev,{input_struct.vendor}-{input_struct.device_name}' 
        attributes = json_dict['devices'][0]['registers']
        input_struct.device_attributes = []
        input_struct.device_attributes.append(DeviceAttribute("name", DataType("string", 32), "0444"))
        for attr in attributes:
            input_struct.device_attributes.append(DeviceAttribute.parse_json(attr, input_struct.device_type))
        return input_struct


