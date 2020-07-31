import json
from device_drivers.device import DeviceType
from device_drivers.device_attributes import DeviceAttribute, DataType

class DriverConfig:
    """The configuration for the driver being generated."""

    def __init__(self):
        """Initialize driver configuration."""
        # device specifications
        self.device_name = None
        self.device_type = None  # 0 for spi, 1 for i2c, 2 for memory mapped device
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
        fileStr = file.read()
        jsonDict = json.loads(fileStr)
        inputStruct = DriverConfig()

        inputStruct.device_name = jsonDict['devices'][0]['name']
        inputStruct.device_type = DeviceType.FPGA
        inputStruct.device_name_abbrev = inputStruct.device_name
        inputStruct.compatible = f'dev,{inputStruct.vendor}-{inputStruct.device_name}' 
        attributes = jsonDict['devices'][0]['registers']
        inputStruct.device_attributes = []
        inputStruct.device_attributes.append(DeviceAttribute("name", DataType("string", 32), "0444"))
        for attr in attributes:
            inputStruct.device_attributes.append(DeviceAttribute.parse_json(attr, inputStruct.device_type))
        return inputStruct


