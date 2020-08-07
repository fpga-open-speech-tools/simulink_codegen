#!/usr/bin/python

# @file device_attributes.py
#
#     Python classes to represent attributes of a Linux device 
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

from device_drivers.device import DeviceType

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
        return DataType(dt_json['type'], dt_json['wordLength'],  dt_json['signed'], dt_json['fractionLength'])
class DeviceAttribute:
    """Represent a device attribute on a Linux device driver."""

    def __init__ (self, name, data_type, permissions = "0664"):
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

    @staticmethod
    def parse_json(dev_attr_json, device_type):
        """Parse JSON object into DeviceAttribute.

        Parameters
        ----------
        dev_attr_json : dict
            Dictionary representing attribute from JSON
        device_type : DeviceType
            Represents what device interface this attribute is tied to

        Returns
        -------
        DeviceAttribute
            Returns device attribute matching device_type

        Raises
        ------
        ValueError
            Raises error if unsupported DeviceType is passed in
        """
        data_type = DataType.parse_json(dev_attr_json["dataType"])
        if device_type == DeviceType.FPGA:
            return FPGADeviceAttribute(dev_attr_json['name'], data_type, dev_attr_json['registerNumber'])
        elif device_type == DeviceType.SPI:
            pass
        elif device_type == DeviceType.I2C:
            pass
        else:
            raise ValueError("Unsupported device type requested")
    def create_variable_declaration(self):
        if self.data_type.name == "string":
            return f"char *{self.name};\n"
        elif self.data_type.signed:
            return f"int {self.name};\n"
        else:
            return f"unsigned int {self.name};\n"
            
    def create_func_prototypes(self):
        """Create C function prototypes for attribute read and write

        Returns
        -------
        str
            Returns string representing C function prototypes
        """
        c_code = ""
        if(self.permissions != "0444"):
            c_code += "static ssize_t " + self.name + \
                             "_write (struct device *dev, struct device_attribute *attr, const char *buf, size_t count);\n"
        c_code += "static ssize_t " + self.name + \
                          "_read  (struct device *dev, struct device_attribute *attr, char *buf);\n"
        return c_code
    
    def create_read_func(self, device_name):
        """Create C function definition for reading the attribute value.

        Parameters
        ----------
        device_name : str
            Name of device the attibute belongs to

        Returns
        -------
        str
            Returns C function definition for reading the attribute value
        """
        c_code = "static ssize_t " + self.name + "_read(struct device *dev, struct device_attribute *attr, char *buf) {\n"
        c_code += "  fe_" + device_name + "_dev_t * devp = (fe_" + device_name + "_dev_t *)dev_get_drvdata(dev);\n"
        if self.data_type.name == "string":
            c_code += self._read_string()
        else:
            c_code += self._read_int()
        c_code += "  return strlen(buf);\n"
        c_code += "}\n\n"
        return c_code

    def _read_string(self):
        c_code = ""
        c_code += f"  sprintf(buf, \"%s\\n\", devp->{self.name});\n"
        return c_code

    def _read_int(self):
        c_code = ""
        c_code += "  fp_to_string(buf, devp->" + self.name + \
            ", " + str(self.data_type.fractional_bits) + ", " + \
            str(self.data_type.signed).lower()+ ", " + \
            str(self.data_type.width) + ");\n"
        c_code += "  strcat2(buf,\"\\n\");\n"
        return c_code

    # TODO: Implement it with writing to register for register only attributes
    def create_write_func(self, device_name):
        """Create C function definition for writing to the attribute.

        Parameters
        ----------
        device_name : str
            Name of device the attibute belongs to

        Returns
        -------
        str
            Returns C function definition for writing to the attribute
        """
        write_func = ""
        if(self.permissions != "0444"):
            pass
        return write_func
        
    def create_macro(self):
        """Create DEVICE_ATTR macro for attribute.

        Returns
        -------
        str
            Returns DEVICE_ATTR macro for the attribute
        """
        if(self.permissions == "0444"):
            write_func = "NULL"
        else:
            write_func = self.name + "_write"
        
        c_code = ("DEVICE_ATTR(" + self.name + ", " + self.permissions
                            + ", " + self.name + "_read, " + write_func
                            + ");\n")
        return c_code
class FPGADeviceAttribute(DeviceAttribute):
    def __init__ (self, name,  data_type, offset = 0, permissions = "0664"):
        super().__init__(name, data_type, permissions)
        self.offset = offset

    def create_read_func(self, device_name):
        """Create C function definition for reading the FPGA attribute value.

        Parameters
        ----------
        device_name : str
            Name of device the attibute belongs to

        Returns
        -------
        str
            Returns C function definition for reading the attribute value
        """
        return super().create_read_func(device_name)

    def create_write_func(self, device_name):
        """Create C function definition for writing to the FPGA attribute.

        Parameters
        ----------
        device_name : str
            Name of device the attibute belongs to

        Returns
        -------
        str
            Returns C function definition for writing to the attribute
        """
        c_code = "static ssize_t " + self.name + "_write(struct device *dev, struct device_attribute *attr, const char *buf, size_t count) {\n"
        c_code +=  "  uint32_t tempValue = 0;\n"
        c_code += "  char substring[80];\n"
        c_code += "  int substring_count = 0;\n"
        c_code += "  int i;\n"
        c_code += "  fe_" + device_name + "_dev_t *devp = (fe_" + device_name + \
                        "_dev_t *)dev_get_drvdata(dev);\n"
        c_code += "  for (i = 0; i < count; i++) {\n"
        c_code += "    if ((buf[i] != ',') && (buf[i] != ' ') && (buf[i] != '\\0') && (buf[i] != '\\r') && (buf[i] != '\\n')) {\n"
        c_code += "      substring[substring_count] = buf[i];\n"
        c_code += "      substring_count ++;\n"
        c_code += "    }\n"
        c_code += "  }\n"
        c_code += "  substring[substring_count] = 0;\n"
        is_signed = str(self.data_type.signed).lower()
        c_code += "  tempValue = set_fixed_num(substring, " + \
            str(self.data_type.fractional_bits) + ", " + is_signed + ");\n"
        c_code += "  devp->" + self.name + " = tempValue;\n"
        c_code += "  iowrite32(devp->" + self.name + ", (u32 *)devp->regs"
        c_code += " + " + str(self.offset)
        c_code += ");\n"
        c_code += "  return count;\n"
        c_code += "}\n\n"
        return c_code

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
    def __init__ (self, name,  data_type, permissions = "0664"):
        super().__init__(name, data_type,permissions)
    # .attrWriteComm = [["0x08", "0x06", "0x00"], ["0x08", "0x06", "0x00"], ["0x08", "0x07", "0x00"],
    # address + R/W, Register, Data

    def create_read_func(self, device_name):
        """Create C function definition for reading the SPI attribute value.

        Parameters
        ----------
        device_name : str
            Name of device the attibute belongs to

        Returns
        -------
        str
            Returns C function definition for reading the attribute value
        """
        return super().create_read_func(device_name)

    def create_write_func(self, device_name, device_name_abbrev):
        """Create C function definition for writing to the SPI attribute.

        Parameters
        ----------
        device_name : str
            Name of device the attibute belongs to

        Returns
        -------
        str
            Returns C function definition for writing to the attribute
        """
        c_code = "static ssize_t " + self.name + "_write(struct device *dev, struct device_attribute *attr, const char *buf, size_t count) {\n"
        c_code += "  uint32_t tempValue = 0;\n"
        c_code += "  char substring[80];\n"
        c_code += "  int substring_count = 0;\n"
        c_code += "  int i;\n"
        c_code += "  char cmd[" + str(inputParams.attrWriteCommBytes) + "] = {"
        for j in range(inputParams.attrWriteCommBytes):
            # i is the index previously used to access the attribute
            c_code += " " + inputParams.attrWriteComm[i][j]
            if j != inputParams.attrWriteCommBytes - 1:
                c_code += ","
        c_code += "};\n"
        c_code += "  uint8_t code = 0x00;\n"
        c_code += "  fe_" + device_name + "_dev_t * devp = (fe_" + device_name + \
                        "_dev_t *) dev_get_drvdata(dev);\n"
        c_code += "  for (i = 0; i < count; i++) {\n"
        c_code += "    if ((buf[i] != ',') && (buf[i] != ' ') && (buf[i] != '\\0') && (buf[i] != '\\r') && (buf[i] != '\\n')) {\n"
        c_code += "      substring[substring_count] = buf[i];\n"
        c_code += "      substring_count ++;\n"
        c_code += "    }\n"
        c_code += "  }\n"
        c_code += "  substring[substring_count] = '\\0';\n"
        c_code += "  if (buf[0] == '-') {\n"
        c_code += "    for (i = 0; i < 79; i++) {\n"
        c_code += "      substring[i] = substring[i + 1];\n"
        c_code += "    }\n"
        c_code += "  }\n"
        c_code += "  tempValue = set_fixed_num(substring, 16, true);\n"
        c_code += "  code = find_volume_level(tempValue, 1);\n"
        c_code += "  tempValue = decode_volume(code);\n"
        c_code += "  devp->" + self.name + " = tempValue;\n"
        c_code += "  cmd[" + str(inputParams.attrWriteCommBytes - 1) + "] = code;\n"
        c_code += "  i2c_master_send(" + device_name_abbrev + "_i2c_client, &cmd[0], " + str(inputParams.attrWriteCommBytes) + ");\n"
        c_code += "  return count;\n"
        c_code += "}\n\n"
        return c_code

class I2CDeviceAttribute(DeviceAttribute):

    def __init__ (self, name,  data_type, permissions = "0664"):
        super().__init__(name, data_type, permissions)

    def create_read_func(self, device_name):
        """Create C function definition for reading the I2C attribute value.

        Parameters
        ----------
        device_name : str
            Name of device the attibute belongs to

        Returns
        -------
        str
            Returns C function definition for reading the attribute value
        """
        return super().create_read_func(device_name)

    def create_write_func(self, device_name, device_name_abbrev):
        """Create C function definition for writing to I2C the attribute.

        Parameters
        ----------
        device_name : str
            Name of device the attibute belongs to

        Returns
        -------
        str
            Returns C function definition for writing to the attribute
        """
        c_code = "static ssize_t " + self.name + "_write(struct device *dev, struct device_attribute *attr, const char *buf, size_t count) {\n"
        c_code +=  "  uint32_t tempValue = 0;\n"
        c_code += "  char substring[80];\n"
        c_code += "  int substring_count = 0;\n"
        c_code += "  int i;\n"
        c_code += "  char cmd[" + str(inputParams.attrWriteCommBytes) + "] = {"
        for j in range(inputParams.attrWriteCommBytes):
            # i is the index previously used to access the attribute
            c_code += " " + inputParams.attrWriteComm[i][j]
            if j != inputParams.attrWriteCommBytes - 1:
                c_code += ","
        c_code += "};\n"
        c_code += "  uint8_t code = 0x00;\n"
        c_code += "  fe_" + device_name + "_dev_t * devp = (fe_" + device_name + \
                        "_dev_t *) dev_get_drvdata(dev);\n"
        c_code += "  for (i = 0; i < count; i++) {\n"
        c_code += "    if ((buf[i] != ',') && (buf[i] != ' ') && (buf[i] != '\\0') && (buf[i] != '\\r') && (buf[i] != '\\n')) {\n"
        c_code += "      substring[substring_count] = buf[i];\n"
        c_code += "      substring_count ++;\n"
        c_code += "    }\n"
        c_code += "  }\n"
        c_code += "  substring[substring_count] = '\\0';\n"
        c_code += "  if (buf[0] == '-') {\n"
        c_code += "    for (i = 0; i < 79; i++) {\n"
        c_code += "      substring[i] = substring[i + 1];\n"
        c_code += "    }\n"
        c_code += "    tempValue = set_fixed_num(substring, 16, true);\n"
        c_code += "    code = find_volume_level(tempValue, 0);\n"
        c_code += "  } else {\n"
        c_code += "    tempValue = set_fixed_num(substring, 16, true);\n"
        c_code += "    code = find_volume_level(tempValue, 1);\n"
        c_code += "  }\n"
        c_code += "  tempValue = decode_volume(code);\n"
        c_code += "  devp->" + self.name + " = tempValue;\n"
        c_code += "  cmd[" + str(inputParams.attrWriteCommBytes - 1) + "] = code;\n"
        c_code += "  i2c_master_send(" + device_name_abbrev + "_i2c_client, &cmd[0], " + str(inputParams.attrWriteCommBytes) + ");\n"
        c_code += "  return count;\n"
        c_code += "}\n\n"
        return c_code