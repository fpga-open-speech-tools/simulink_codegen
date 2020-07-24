import json

class InputStructure:
    def __init__(self):

        # device specifications
        self.device_name = None
        self.device_type = None  # 0 for spi, 1 for i2c, 2 for memory mapped device
        self.device_name_abbrev = None  
        self.compatible_flag = None  # Sets the compatible key on Linux, telling it what devices it is compatible with. Ex: "dev,fe-AD1939"
        self.device_i2c_address = None
        self.vendor = "al" 

        # device attribute specifications
        self.device_attributes = None  # list of string attributes
        self.attributeDataTypes = None  # list of string data types
        self.attributeDataTypeSigned = None # list of signed/unsigned
        self.attributeDataTypeFraction = None # list of fraction widths
        self.attributeDataTypeWidth = None # list of fraction widths
        self.attributePerms = None  # attribute permissions, list of "0446" or whatever the desired permission is
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

        # top of file stuff
        self.needsVolumeTable = None  # true if the device needs a volume table
        self.volumeTable = None  # should be filled in with [ [ <val>, "0xNN"] .. ] in decreasing order of val
        self.PN_INDEX = None  # index where the val goes from positive to negative

        # stuff
        self.speed = 500000  # not even sure what this is
        self.mode = None  # rising edge or whatever
        self.chipSelect = None  # not even sure what this is either


        # min and max for each attribute
        # look for data type var

    def parse_json(self, jsonFileName):
        file = open(jsonFileName, "r")
        fileStr = file.read()
        jsonDict = json.loads(fileStr)
        inputStruct = InputStructure()

        inputStruct.device_name = jsonDict['linux_device_name']
        inputStruct.device_type = 2
        inputStruct.device_name_abbrev = jsonDict['model_abbreviation']
        inputStruct.compatible_flag = f'dev,{inputStruct.vendor}- {inputStruct.device_name}' 
        attributes = jsonDict['avalon_memorymapped']['register']
        inputStruct.device_attributes = []
        for attr in attributes:
            inputStruct.device_attributes.append(DeviceAttribute.parse_json(attr))
        return inputStruct

class DataType:
    """Represent a fixed point number."""

    def __init__(self, name, width, signed = False, fractional_bits = 0):
        """Initialize a fixed point numerical data type.

        Parameters
        ----------
        name  : str
            Name of the data type
        width : int
            Number of bits in the data type
        signed : bool, optional
            True if the data type is signed, false if unsigned. By default False
        fractional_bits : int, optional
            Number of fractional bits in the data type, by default 0
        """
        self.name = name
        self.signed = signed
        self.width = width
        self.fractional_bits = fractional_bits

    @staticmethod
    def parse_json(dt_json):
        """Parse JSON object into DataType."""
        return DataType(dt_json['type'], dt_json['signed'], dt_json['width'], dt_json['fractional_bits'])
class DeviceAttribute:
    """Represent a device attribute on a Linux device driver."""

    def __init__ (self, name, data_type = None, offset = 0, permissions = "0664"):
        """Initialize a representation of a Linux device driver attribute.

        Parameters
        ----------
        name : str, optional
            [description], by default ""
        data_type : [type], optional
            [description], by default None
        offset : int, optional
            [description], by default 0
        permissions : str, optional
            [description], by default "0664"
        """
        self.name = name
        self.data_type = data_type
        self.permissions = permissions
        self.offset = offset

    @staticmethod
    def parse_json(dev_attr_json):
        """Parse JSON object into DeviceAttribute."""
        data_type = DataType.parse_json(dev_attr_json["data_type"])
        return DeviceAttribute(dev_attr_json['name', data_type, dev_attr_json['reg_num']])