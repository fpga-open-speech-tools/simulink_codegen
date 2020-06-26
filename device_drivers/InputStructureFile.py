import json
from enum import Enum

class DriverConfig:
    """The configuration for the driver being generated."""

    def __init__(self):
        """Initialize driver configuration."""
        # device specifications
        self.device_name = None
        self.device_type = None  # 0 for spi, 1 for i2c, 2 for memory mapped device
        self.device_name_abbrev = None  
        self.compatible_flag = None  # Sets the compatible key on Linux, telling it what devices it is compatible with. Ex: "dev,fe-AD1939"
        self.device_i2c_address = None
        self.vendor = "al" 

        # device attribute specifications
        self.device_attributes = None  # list of string attributes
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

    def parse_json(self, json_filepath):
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

        inputStruct.device_name = jsonDict['linux_device_name']
        inputStruct.device_type = DeviceType(2)
        inputStruct.device_name_abbrev = jsonDict['model_abbreviation']
        inputStruct.compatible_flag = f'dev,{inputStruct.vendor}- {inputStruct.device_name}' 
        attributes = jsonDict['avalon_memorymapped']['register']
        inputStruct.device_attributes = []
        for attr in attributes:
            inputStruct.device_attributes.append(DeviceAttribute.parse_json(attr, inputStruct.device_type))
        return inputStruct
class DeviceType(Enum):
    """Enumeration representing the driver's device type.""" 

    SPI = 0
    I2C = 1
    FPGA = 2

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

    def __init__ (self, name, data_type, offset = 0, permissions = "0664"):
        """Initialize a representation of a Linux device driver attribute.

        Parameters
        ----------
        name : str
            [description]
        data_type : [type]
            [description]
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
    def parse_json(dev_attr_json, device_type):
        """Parse JSON object into DeviceAttribute."""
        data_type = DataType.parse_json(dev_attr_json["data_type"])
        if device_type == DeviceType.FPGA:
            return FPGADeviceAttribute(dev_attr_json['name'], data_type, dev_attr_json['reg_num'])
        elif device_type == DeviceType.SPI:
            pass
        elif device_type == DeviceType.I2C:
            pass
        else:
            raise ValueError("Unsupported device type requested")
    def create_func_prototypes(self):
        functionString = "static ssize_t " + self.name + \
                          "_write (struct device *dev, struct device_attribute *attr, const char *buf, size_t count);\n"
        functionString += "static ssize_t " + self.name + \
                          "_read  (struct device *dev, struct device_attribute *attr, char *buf);\n"
        return functionString
    
    def create_read_func(self, device_name):
        functionString = "static ssize_t " + self.name + "_read(struct device *dev, struct device_attribute *attr, char *buf) {\n"
        functionString += "  fe_" + device_name + "_dev_t * devp = (fe_" + device_name + "_dev_t *)dev_get_drvdata(dev);\n"
        functionString += "  fp_to_string(buf, devp->" + self.name + \
            ", " + str(self.data_type.fractional_bits) + ", " + \
            str(self.data_type.signed).lower()+ ", " + \
            str(self.data_type.width) + ");\n"
        functionString += "  strcat2(buf,\"\\n\");\n"
        functionString += "  return strlen(buf);\n"
        functionString += "}\n\n"
        return functionString

    def create_write_func(self, device_name):
        pass

    def create_macro(self):

        # Update to use permissions. If can't write or read, set the function to NULL
        functionString = ("DEVICE_ATTR(" + self.name + ", " + self.permissions
                            + ", " + self.name + "_read, " + self.name
                            + "_write);\n")
        return functionString

class FPGADeviceAttribute(DeviceAttribute):
    def __init__ (self, name,  data_type, offset = 0, permissions = "0664"):
        super.__init__(name, data_type, offset, permissions)

    def create_read_func(self, device_name):
        return super.create_read_func(device_name)

    def create_write_func(self, device_name):
        functionString = "static ssize_t " + self.name + "_write(struct device *dev, struct device_attribute *attr, const char *buf, size_t count) {\n"
        functionString +=  "  uint32_t tempValue = 0;\n"
        functionString += "  char substring[80];\n"
        functionString += "  int substring_count = 0;\n"
        functionString += "  int i;\n"
        functionString += "  fe_" + device_name + "_dev_t *devp = (fe_" + device_name + \
                        "_dev_t *)dev_get_drvdata(dev);\n"
        functionString += "  for (i = 0; i < count; i++) {\n"
        functionString += "    if ((buf[i] != ',') && (buf[i] != ' ') && (buf[i] != '\\0') && (buf[i] != '\\r') && (buf[i] != '\\n')) {\n"
        functionString += "      substring[substring_count] = buf[i];\n"
        functionString += "      substring_count ++;\n"
        functionString += "    }\n"
        functionString += "  }\n"
        functionString += "  substring[substring_count] = 0;\n"
        is_signed = self.data_type.signed
        functionString += "  tempValue = set_fixed_num(substring, " + \
            str(self.data_type.fractional_bits) + ", " + (str(is_signed)).lower() + ");\n"
        functionString += "  devp->" + self.name + " = tempValue;\n"
        functionString += "  iowrite32(devp->" + self.name + ", (u32 *)devp->regs"
        functionString += " + " + self.offset
        functionString += ");\n"
        functionString += "  return count;\n"
        functionString += "}\n\n"
        return functionString

## Don't do commands. Add this to device attributes directly
## so i2c and spi attributes receive a register address rather than offset
## is_read is handled by whichever function is being called
## spi_addr is either passed into the function or just added to constructor as a prop
## spi_addr should generate a constant in C
## If SPI_ADDR is a C constant, the value doesn't need to be passed around
class SPICommand:
    def __init__(self, data, reg_addr, is_read, spi_addr = None):
        self.data = data
        self.reg_addr = reg_addr
        self.is_read = is_read
        self.spi_addr = spi_addr
    def _append_hex_id(self, val):
        if type(val) is int:
            val = str(val)
        if val[:1] != "0x":
            val = "0x" + val

class SPIDeviceAttribute(DeviceAttribute):
    def __init__ (self, name,  data_type, offset = 0, permissions = "0664"):
        super.__init__(name, data_type, offset, permissions)
    # .attrWriteComm = [["0x08", "0x06", "0x00"], ["0x08", "0x06", "0x00"], ["0x08", "0x07", "0x00"],
    # address + R/W, Register, Data

    def create_read_func(self, device_name):
        return super.create_read_func(device_name)

    def create_write_func(self, device_name, device_name_abbrev):
        functionString = "static ssize_t " + self.name + "_write(struct device *dev, struct device_attribute *attr, const char *buf, size_t count) {\n"
        functionString += "  uint32_t tempValue = 0;\n"
        functionString += "  char substring[80];\n"
        functionString += "  int substring_count = 0;\n"
        functionString += "  int i;\n"
        functionString += "  char cmd[" + str(inputParams.attrWriteCommBytes) + "] = {"
        for j in range(inputParams.attrWriteCommBytes):
            # i is the index previously used to access the attribute
            functionString += " " + inputParams.attrWriteComm[i][j]
            if j != inputParams.attrWriteCommBytes - 1:
                functionString += ","
        functionString += "};\n"
        functionString += "  uint8_t code = 0x00;\n"
        functionString += "  fe_" + device_name + "_dev_t * devp = (fe_" + device_name + \
                        "_dev_t *) dev_get_drvdata(dev);\n"
        functionString += "  for (i = 0; i < count; i++) {\n"
        functionString += "    if ((buf[i] != ',') && (buf[i] != ' ') && (buf[i] != '\\0') && (buf[i] != '\\r') && (buf[i] != '\\n')) {\n"
        functionString += "      substring[substring_count] = buf[i];\n"
        functionString += "      substring_count ++;\n"
        functionString += "    }\n"
        functionString += "  }\n"
        functionString += "  substring[substring_count] = '\\0';\n"
        functionString += "  if (buf[0] == '-') {\n"
        functionString += "    for (i = 0; i < 79; i++) {\n"
        functionString += "      substring[i] = substring[i + 1];\n"
        functionString += "    }\n"
        functionString += "  }\n"
        functionString += "  tempValue = set_fixed_num(substring, 16, true);\n"
        functionString += "  code = find_volume_level(tempValue, 1);\n"
        functionString += "  tempValue = decode_volume(code);\n"
        functionString += "  devp->" + self.name + " = tempValue;\n"
        functionString += "  cmd[" + str(inputParams.attrWriteCommBytes - 1) + "] = code;\n"
        functionString += "  i2c_master_send(" + device_name_abbrev + "_i2c_client, &cmd[0], " + str(inputParams.attrWriteCommBytes) + ");\n"
        functionString += "  return count;\n"
        functionString += "}\n\n"
        return functionString

class I2CDeviceAttribute(DeviceAttribute):

    def __init__ (self, name,  data_type, offset = 0, permissions = "0664"):
        super.__init__(name, data_type, offset, permissions)

    def create_read_func(self, device_name):
        return super.create_read_func(device_name)

    def create_write_func(self, device_name, device_name_abbrev):
        functionString = "static ssize_t " + self.name + "_write(struct device *dev, struct device_attribute *attr, const char *buf, size_t count) {\n"
        functionString +=  "  uint32_t tempValue = 0;\n"
        functionString += "  char substring[80];\n"
        functionString += "  int substring_count = 0;\n"
        functionString += "  int i;\n"
        functionString += "  char cmd[" + str(inputParams.attrWriteCommBytes) + "] = {"
        for j in range(inputParams.attrWriteCommBytes):
            # i is the index previously used to access the attribute
            functionString += " " + inputParams.attrWriteComm[i][j]
            if j != inputParams.attrWriteCommBytes - 1:
                functionString += ","
        functionString += "};\n"
        functionString += "  uint8_t code = 0x00;\n"
        functionString += "  fe_" + device_name + "_dev_t * devp = (fe_" + device_name + \
                        "_dev_t *) dev_get_drvdata(dev);\n"
        functionString += "  for (i = 0; i < count; i++) {\n"
        functionString += "    if ((buf[i] != ',') && (buf[i] != ' ') && (buf[i] != '\\0') && (buf[i] != '\\r') && (buf[i] != '\\n')) {\n"
        functionString += "      substring[substring_count] = buf[i];\n"
        functionString += "      substring_count ++;\n"
        functionString += "    }\n"
        functionString += "  }\n"
        functionString += "  substring[substring_count] = '\\0';\n"
        functionString += "  if (buf[0] == '-') {\n"
        functionString += "    for (i = 0; i < 79; i++) {\n"
        functionString += "      substring[i] = substring[i + 1];\n"
        functionString += "    }\n"
        functionString += "    tempValue = set_fixed_num(substring, 16, true);\n"
        functionString += "    code = find_volume_level(tempValue, 0);\n"
        functionString += "  } else {\n"
        functionString += "    tempValue = set_fixed_num(substring, 16, true);\n"
        functionString += "    code = find_volume_level(tempValue, 1);\n"
        functionString += "  }\n"
        functionString += "  tempValue = decode_volume(code);\n"
        functionString += "  devp->" + self.name + " = tempValue;\n"
        functionString += "  cmd[" + str(inputParams.attrWriteCommBytes - 1) + "] = code;\n"
        functionString += "  i2c_master_send(" + device_name_abbrev + "_i2c_client, &cmd[0], " + str(inputParams.attrWriteCommBytes) + ");\n"
        functionString += "  return count;\n"
        functionString += "}\n\n"
        return functionString