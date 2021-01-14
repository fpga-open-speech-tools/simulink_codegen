#!/usr/bin/python

# @file device.py
#
#     Python classes to represent Linux devices
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

from enum import Enum

from time import strftime
# Refactor constants into C constants/defines such as
    # i2c/ spi address
    # nominal states ex. 0x35 is the initialization data
def get_device(device_type, config):
    device_map = { 
        # DeviceType.SPI : SPIDevice(config.device_name, config.compatible, config.device_address), 
        # DeviceType.I2C: I2CDevice(config.device_name, config.compatible, config.device_address), 
        DeviceType.FPGA: FPGADevice(config.device_name, config.compatible) 
    }

    device = device_map.get(device_type, Device(config.device_name, config.compatible))
    device.device_attributes = config.device_attributes
    return device
class DeviceType(Enum):
    """Enumeration representing the driver's device type."""

    SPI = 0
    I2C = 1
    FPGA = 2

class Device:
    def __init__(self, name, compatible):
        self.name = name
        self.compatible = compatible
        self.device_attributes = []

    def create_declarations(self):
        c_code = ""
        c_code += self.create_includes()
        c_code += "static struct class *cl;\n"
        c_code += "static dev_t dev_num;"
        c_code += self._create_dev_struct()
        c_code += self._create_func_prototypes()
        c_code += "typedef struct fe_" + self.name + "_dev fe_" + self.name + "_dev_t;\n"
        c_code += self._create_id_matching_struct()
        c_code += self._create_platform_driver_struct()
        c_code += self._create_file_ops_struct()
        c_code += self._create_module_declarations()
        for attr in self.device_attributes:
            c_code += attr.create_macro()
        c_code += self._create_attr_table()
        c_code += self._create_attr_group()
        return c_code
    def create_func_implementations(self):
        c_code = ""
        c_code += self._create_init_func()
        c_code += self._create_probe_func()
        c_code += self._create_file_ops_funcs()
        for attr in self.device_attributes:
            c_code += attr.create_read_func(self.name)
            c_code += attr.create_write_func(self.name)
        c_code += self._create_remove_func()
        c_code += self._create_exit_func()
        return c_code
    def _create_func_prototypes(self): 
        c_code = ""
        c_code += "static int " + self.name + "_init(void);\n"
        c_code += "static void " + self.name + "_exit(void);\n"
        c_code += "static int " + self.name + "_probe(struct platform_device *pdev);\n"
        c_code += "static int " + self.name + "_remove(struct platform_device *pdev);\n"
        c_code += "static ssize_t " + self.name + "_read(struct file *file, char *buffer, size_t len, loff_t *offset);\n"
        c_code += "static ssize_t " + self.name + "_write(struct file *file, const char *buffer, size_t len, loff_t *offset);\n"
        c_code += "static int " + self.name + "_open(struct inode *inode, struct file *file);\n"
        c_code += "static int " + self.name + "_release(struct inode *inode, struct file *file);\n\n"
        for attr in self.device_attributes:
            c_code += attr.create_func_prototypes()
        return c_code
    def create_includes(self):
        c_code = "#include <linux/module.h>\n"
        c_code += "#include <linux/platform_device.h>\n"
        c_code += "#include <linux/io.h>\n"
        c_code += "#include <linux/fs.h>\n"
        c_code += "#include <linux/types.h>\n"
        c_code += "#include <linux/uaccess.h>\n"
        c_code += "#include <linux/init.h>\n"
        c_code += "#include <linux/cdev.h>\n"
        c_code += "#include <linux/regmap.h>\n"
        c_code += "#include <linux/of.h>\n"
        c_code += "#include \"custom_functions.h\"\n"
        return c_code
    def _create_module_declarations(self):
        c_code = "\nMODULE_LICENSE(\"GPL\");\n"
        c_code += "MODULE_AUTHOR(\"Autogen <support@flatearthinc.com\");\n"
        c_code += "MODULE_DESCRIPTION(\"Loadable kernel module for the " + self.name + "\");\n"
        c_code += "MODULE_VERSION(\"1.0\");\n"
        c_code += "MODULE_DEVICE_TABLE(of, fe_" + self.name + "_dt_ids);\n"
    
        c_code += "module_init(" + self.name + "_init);\n"
        c_code += "module_exit(" + self.name + "_exit);\n\n"
        return c_code
    def _create_file_ops_struct(self):
        c_code = "/* File ops struct */\n"
        c_code += "static const struct file_operations fe_" + self.name + "_fops = {\n"
        c_code += "  .owner = THIS_MODULE,\n"
        c_code += "  .read = "    + self.name + "_read,\n"
        c_code += "  .write = "   + self.name + "_write,\n"
        c_code += "  .open = "    + self.name + "_open,\n"
        c_code += "  .release = " + self.name + "_release,\n"
        c_code += "};\n\n"
        return c_code

    def _create_platform_driver_struct(self):
        c_code = "/* Platform driver struct */\n"
        c_code += "static struct platform_driver " + self.name + "_platform = {\n"
        c_code += "  .probe = " + self.name + "_probe,\n"
        c_code += "  .remove = " + self.name + "_remove,\n"
        c_code += "  .driver = {\n"
        c_code += "    .name = \"Flat Earth " + self.name + " Driver\",\n"
        c_code += "    .owner = THIS_MODULE,\n"
        c_code += "    .of_match_table = fe_" + self.name + "_dt_ids\n"
        c_code += "  }\n"
        c_code += "};\n\n"
        return c_code

    def _create_id_matching_struct(self):
        c_code = "/* ID Matching struct */\n"
        c_code += "static struct of_device_id fe_" + self.name + "_dt_ids[] = {\n"
        c_code += "  {\n"
        c_code += "    .compatible = \"" + self.compatible + "\"\n"
        c_code += "  },\n"
        c_code += "  { }\n"
        c_code += "};\n\n"
        return c_code

    def _create_dev_struct(self):
        c_code = "\n/* Device struct */\n"
        c_code += "struct fe_" + self.name + "_dev {\n"
        c_code += "  struct cdev cdev;\n"
        c_code += "  void __iomem *regs;\n"
        for attr in self.device_attributes:
            c_code += f"  {attr.create_variable_declaration()}"
        c_code += "};\n\n"
        return c_code
    def _create_attr_table(self):
        c_code = ""
        c_code += f"static struct attribute *{self.name}_attrs[] = {{"
        for attr in self.device_attributes:
            c_code += f"  &dev_attr_{attr.name}.attr,"
        c_code += f"  NULL"
        c_code += f"}};\n\n"
        return c_code
    def _create_attr_group(self):
        c_code = f"ATTRIBUTE_GROUPS({self.name});\n\n"
        return c_code
    def _create_init_func(self):
        c_code = ""
        c_code += f"static int {self.name}_init(void) {{\n"
        c_code += "  int ret_val = 0;\n"
        time_string = strftime("%Y-%m-%d %H:%M")
        c_code += "  printk(KERN_ALERT \"FUNCTION AUTO GENERATED AT: " + time_string + "\\n\");\n"
        c_code += "  pr_info(\"Initializing the Flat Earth " + self.name + " module\\n\");\n"
        c_code += "  // Register our driver with the \"Platform Driver\" bus\n"
        c_code += "  ret_val = platform_driver_register(&" + self.name + "_platform);"
        c_code += "  if (ret_val != 0) {\n"
        c_code += "    pr_err(\"platform_driver_register returned %d\\n\", ret_val);\n"
        c_code += "    return ret_val;\n"
        c_code += "  }\n"
        c_code += self._init_device()
        c_code += "  pr_info(\"Flat Earth " + self.name + " module successfully initialized!\\n\");\n"
        c_code += "  return 0;\n"
        c_code += "}\n"
        return c_code
    def _init_device(self):
        return ""
    def _create_probe_func(self):
        c_code = ""
        c_code += "static int " + self.name + "_probe(struct platform_device *pdev) {\n"
        c_code += "  int ret_val = -EBUSY;\n"
        c_code += ("  char device_name[" + str(len(self.name) + 12) +"] = \"fe_" + self.name
                        + "\";\n")  # adding 12 to len is arbitrary
        c_code += "  char deviceMinor[20];\n"
        c_code += "  int status;\n"
        c_code += "  struct device *device_obj;\n"
        devp_struct_name = "fe_" + self.name + "_devp"
        c_code += "  fe_" + self.name + "_dev_t * " + devp_struct_name + ";\n"
        c_code += "  struct resource *r = NULL;\n"
        c_code += "  pr_info(\"" + self.name + "_probe enter\\n\");\n"
        c_code += ("  " + devp_struct_name + " = devm_kzalloc(&pdev->dev, sizeof(fe_" + self.name +
                        "_dev_t), GFP_KERNEL);\n")
        c_code += self._init_platform()
        c_code += "  platform_set_drvdata(pdev, (void *)" + devp_struct_name + ");\n"
        c_code += "  " + devp_struct_name + "->name = devm_kzalloc(&pdev->dev, 50, GFP_KERNEL);\n"
        c_code += "  if (" + devp_struct_name + "->name == NULL)\n"
        c_code += "    goto bad_mem_alloc;\n"
        c_code += "  strcpy(" + devp_struct_name + "->name, (char *)pdev->name);\n"
        c_code += "  pr_info(\"%s\\n\", (char *)pdev->name);\n"
        c_code += "  status = alloc_chrdev_region(&dev_num, 0, 1, \"fe_" + self.name + "_\");\n"
        c_code += "  if (status != 0)\n"
        c_code += "    goto bad_alloc_chrdev_region;\n"
        c_code += "  cl = class_create(THIS_MODULE, device_name);\n"
        c_code += "  if (cl == NULL)\n"
        c_code += "    goto bad_class_create;\n"
        c_code += "  cdev_init(&" + devp_struct_name + "->cdev, &fe_" + self.name + "_fops);\n"
        c_code += "  status = cdev_add(&" + devp_struct_name + "->cdev, dev_num, 1);\n"
        c_code += "  if (status != 0)\n"
        c_code += "    goto bad_cdev_add;\n"
        c_code += "  sprintf(deviceMinor, \"%d\", MINOR(dev_num));\n"
        c_code += "  strcat(device_name, deviceMinor);\n"
        c_code += "  pr_info(\"%s\\n\", device_name);\n"
        c_code += f" device_obj = device_create_with_groups(cl, NULL, dev_num, NULL, {self.name}_groups, device_name);\n"
        c_code += f"  if (device_obj == NULL)\n"
        c_code += "    goto bad_device_create;\n"
        c_code += "  dev_set_drvdata(device_obj, " + devp_struct_name + ");\n"
        c_code += "  pr_info(\"" + self.name + " exit\\n\");\n"
        c_code += "  return 0;\n"
        c_code += "bad_device_create:\n"
        c_code += "bad_cdev_add:\n"
        c_code += "  cdev_del(&fe_" + self.name + "_devp->cdev);\n"
        c_code += "bad_class_create:\n"
        c_code += "  class_destroy(cl);\n"
        c_code += "bad_alloc_chrdev_region:\n"
        c_code += "  unregister_chrdev_region(dev_num, 1);\n"
        c_code += "bad_mem_alloc:\n"
        c_code += "bad_exit_return:\n"
        c_code += "  pr_info(\"" + self.name + "_probe bad exit\\n\");\n"
        c_code += "  return ret_val;\n"
        c_code += "}\n\n\n"
        return c_code
    def _init_platform(self):
        return ""
    def _create_file_ops_funcs(self):
        c_code = "static int " + self.name + "_open(struct inode *inode, struct file *file) {\n"
        c_code += "  // TODO: fill this in (if its needed, it might not be)\n"
        c_code += "  return 0;\n"
        c_code += "}\n\n"
        c_code += "static int " + self.name + "_release(struct inode *inode, struct file *file) {\n"
        c_code += "  // TODO: fill this in (if its needed, it might not be)\n"
        c_code += "  return 0;\n"
        c_code += "}\n\n"
        c_code += "static ssize_t " + self.name + "_read(struct file *file, char *buffer, size_t len, loff_t *offset) {\n"
        c_code += "  // TODO: fill this in (if its needed, it might not be)\n"
        c_code += "  return 0;\n"
        c_code += "}\n\n"
        c_code += "static ssize_t " + self.name + "_write(struct file *file, const char *buffer, size_t len, loff_t *offset) {\n"
        c_code += "  // TODO: fill this in (if its needed, it might not be)\n"
        c_code += "  return 0;\n"
        c_code += "}\n"
        return c_code
    
    def _create_remove_func(self):
        c_code = ""
        c_code += "static int " + self.name + "_remove(struct platform_device *pdev) {\n"
        c_code += "  fe_" + self.name + "_dev_t *dev = (fe_" + self.name + "_dev_t *)platform_get_drvdata(pdev);\n"
        c_code += "  pr_info(\"" + self.name + "_remove enter\\n\");\n"
        c_code += "  device_destroy(cl, dev_num);\n"
        c_code += "  cdev_del(&dev->cdev);\n"
        c_code += "  class_destroy(cl);\n"
        c_code += "  unregister_chrdev_region(dev_num, 2);\n"
        c_code += "  pr_info(\"" + self.name + "_remove exit\\n\");\n"
        c_code += "  return 0;\n"
        c_code += "}\n\n\n"
        return c_code

    def _create_exit_func(self):
        c_code = "static void " + self.name + "_exit(void) {\n"
        c_code += "  pr_info(\"Flat Earth " + self.name + " module exit\\n\");\n"
        c_code += "  platform_driver_unregister(&" + self.name + "_platform);\n"
        c_code += self._exit_device()
            
        c_code += "  pr_info(\"Flat Earth " + self.name + " module successfully unregistered\\n\");\n"
        c_code += "}\n"
        return c_code
    def _exit_device(self):
        return ""

class FPGADevice(Device):
    def __init__(self, name, compatible):
        super().__init__(name, compatible)
    def _init_platform(self):
        devp_struct_name = "fe_" + self.name + "_devp"
        c_code = ""
        c_code += "  r = platform_get_resource(pdev, IORESOURCE_MEM, 0);\n"
        c_code += "  if (r == NULL) {\n"
        c_code += "    pr_err(\"IORESOURCE_MEM (register space) does not exist\\n\");\n"
        c_code += "    goto bad_exit_return;"
        c_code += "  }\n"
        c_code += "  " + devp_struct_name + "->regs = devm_ioremap_resource(&pdev->dev, r);\n"
        c_code += "  if (IS_ERR(" + devp_struct_name + "->regs)) {\n"
        c_code += "    ret_val = PTR_ERR(fe_" + self.name + "_devp->regs);\n"
        c_code += "    goto bad_exit_return;\n  }\n"
        return c_code


class SPIDevice(Device):
    def __init__(self, name, compatible, address, speed, chip_select, mode):
        super().__init__(name, compatible)
        self.address = address
        self.speed = speed
        self.chip_select = chip_select
        self.mode = mode
    def create_declarations(self):
        c_code = super().create_declarations()
        c_code += "static uint8_t bits = 8;\n"
        c_code += "static uint32_t speed = " + self.speed + ";\n"
        c_code += "static struct spi_device *spi_device;\n"
    def _create_func_prototypes(self):
        c_code = super()._create_func_prototypes()
        c_code += "uint8_t find_volume_level(uint32_t fp28_num);\n"
        c_code += "uint32_t decode_volume(uint8_t code);\n"
        return c_code
    def _init_device(self):
        c_code = ""
        c_code += "  // Register the device\n"
        c_code += "  struct spi_board_info spi_device_info = {\n"
        c_code += "    .modalias = \"fe_" + self.name + "_\",\n"
        c_code += "    .max_speed_hz = " + self.speed + ",\n"
        c_code += "    .bus_num = 0,\n"
        c_code += "    .chip_select = " + self.chip_select + ",\n"
        c_code += "    .mode = " + self.mode + ",\n"
        c_code += "  };\n"
        c_code += "  /* To send data we have to know what spi port/pins should be used. This information\n"
        c_code += "  can be found in the device-tree. */\n"
        c_code += "  master = spi_busnum_to_master( spi_device_info.bus_num );\n"
        c_code += "  if( !master ) {\n"
        c_code += "    printk(\"MASTER not found.\\n\");\n"
        c_code += "    return -ENODEV;\n"
        c_code += "  }\n"
        c_code += "  // create a new slave device, given the master and device info\n"
        c_code += "  spi_device = spi_new_device(master, &spi_device_info);\n"
        c_code += "  printk(\"Setting up new slave device\\n\");\n"
        c_code += "  if (!spi_device) {\n"
        c_code += "    printk(\"FAILED to create slave.\\n\");\n"
        c_code += "    return -ENODEV;\n"
        c_code += "  }\n"
        c_code += "  printk(\"Set the bits per word\\n\");\n"
        c_code += "  spi_device->bits_per_word = bits;\n"
        c_code += "  printk(\"Setting up the device\\n\");\n"
        c_code += "  ret_val = spi_setup(spi_device);\n"
        c_code += "  if (ret_val) {\n"
        c_code += "    printk(\"FAILED to setup slave.\\n\");\n"
        c_code += "    spi_unregister_device(spi_device);\n"
        c_code += "    return -ENODEV;\n"
        c_code += "  }\n"
        c_code += "  printk(\"Sending SPI initialization commands...\\n\");\n"
        c_code += "  // Sending init commands\n"
        c_code += self._write_init_commands()
        return c_code
    def _write_init_commands(self):
        # c_code = ""
        # if inputParams.initCommLen > 0:
        #     c_code += "  char cmd[" + str(inputParams.initCommBytes) + "];\n"
        # for i in range(inputParams.initCommLen):
        #     try:
        #         c_code += "  // desc: " + inputParams.initCommDesc[i] + "\n"
        #     except:
        #         c_code += "  // no command description\n"
        #     for j in range(inputParams.initCommBytes):
        #         c_code += "  cmd[" + str(j) + "] = " + inputParams.initComm[i][j] + ";"
        #     c_code += "\n"
        #     c_code += "  ret_val = " + inputParams.initCommSendFunc + "(" + inputParams.initCommSendParams + ");\n\n"
        # return c_code
        return ""
    # def WriteVolumeTable(inputParams, c_code):
    #     c_code += "typedef struct {\n"
    #     c_code += "  uint16_t value;\n"
    #     c_code += "  uint8_t  code;\n"
    #     c_code += "} volumeLevel;\n\n"
    #     try:
    #         c_code += "#define PN_INDEX " + str(inputParams.PN_INDEX) + "\n"
    #     except:
    #         c_code += "// No PN_INDEX specified in input params\n"
    #     c_code += "static volumeLevel VolumeLevels[] = {\n"
    #     for i in range(len(inputParams.volumeTable)):
    #         c_code += "  {.value = " + str(inputParams.volumeTable[i][0]) + ", .code = " + str(inputParams.volumeTable[i][1]) + "},\n"
    #     c_code += "};\n"
    #     return c_code
    def _exit_device(self):
        c_code = "  if (spi_device) {\n"
        c_code += "    spi_unregister_device(spi_device);\n"
        c_code += "  }\n"
        return c_code
    def _create_includes(self):
        c_code = "#include <linux/spi/spi.h>\n"
        return c_code

class I2CDevice(Device):
    def __init__(self, name, compatible, address):
        super().__init__(name, compatible)
        self.address = address
    
    def create_declarations(self):
        c_code = super().create_declarations()
        c_code += self._create_i2c_structs()
        return c_code
    
    def _create_includes(self):
        c_code = ""
        c_code += super().create_includes()
        c_code += "#include <linux/i2c.h>\n"
        return c_code
    def _create_func_prototypes(self):
        c_code = super()._create_func_prototypes()
        c_code += "uint8_t find_volume_level(uint32_t fp28_num, uint8_t p);\n"
        c_code += "uint32_t decode_volume(uint8_t code);\n"
        return c_code
    def _create_i2c_structs(self):
        c_code = ""
        c_code += "struct i2c_client * " + self.name + "_i2c_client;\n"
        c_code += "static struct i2c_device_id " + self.name + "_id[] = {\n"
        c_code += "  {\n"
        c_code += "    \"" + self.name + "_i2c\"," + self.address + "\n"
        c_code += "  },\n"
        c_code += "  { }\n"
        c_code += "};\n\n"
        c_code += "static struct i2c_board_info " + self.name + "_i2c_info = {\n"
        c_code += "  I2C_BOARD_INFO(\"" + self.name + "_i2c\"," + self.address + "),\n"
        c_code += "};\n\n"
        c_code += "static int " + self.name + "_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id) {\n"
        c_code += "  return 0;\n"
        c_code += "}\n"
        c_code += "static int " + self.name + "_i2c_remove(struct i2c_client *client) {\n"
        c_code += "  return 0;\n"
        c_code += "}\n"
        c_code += "struct i2c_driver " + self.name + "_i2c_driver = {\n"
        c_code += "  .driver = {\n"
        c_code += "    .name=\"" + self.name + "_i2c\",\n"
        c_code += "  },\n"
        c_code += "  .probe = " + self.name + "_i2c_probe,\n"
        c_code += "  .remove = " + self.name + "_i2c_remove,\n"
        c_code += "  .id_table = " + self.name + "_id,\n"
        c_code += "};\n"
        return c_code
    def _init_device(self):
        c_code = ""
        c_code += "  /*-------------------------------------------------------\n"
        c_code += "     I2C communication\n"
        c_code += "  --------------------------------------------------------*/\n"
        c_code += "  // Register the device\n"
        c_code += "  ret_val = i2c_add_driver(&" + self.name + "_i2c_driver);\n"
        c_code += "  if (ret_val < 0) {\n"
        c_code += "    pr_err(\"Failed to register I2C driver\");\n"
        c_code += "    return ret_val;\n"
        c_code += "  }\n"
        c_code += "  i2c_adapt = i2c_get_adapter(0);\n"
        c_code += "  memset(&i2c_info,0,sizeof(struct i2c_board_info));\n"
        c_code += "  strlcpy(i2c_info.type, \"" + self.name + "_i2c\",I2C_NAME_SIZE);\n"
        c_code += "  " + self.name + "_i2c_client = i2c_new_device(i2c_adapt,&" + self.name + "_i2c_info);\n"
        c_code += "  i2c_put_adapter(i2c_adapt);\n"
        c_code += "  if (!" + self.name + "_i2c_client) {\n"
        c_code += "    pr_err(\"Failed to connect to I2C client\\n\");\n"
        c_code += "    ret_val = -ENODEV;\n"
        c_code += "    return ret_val;\n"
        c_code += "  }\n"
        c_code += "  // Send some initialization commands\n"
        return c_code