from enum import Enum

from time import strftime
# Refactor constants into C constants/defines such as
    # i2c/ spi address
    # nominal states ex. 0x35 is the initialization data
def get_device(device_type, config):
    device_map = { 
        # DeviceType.SPI : SPIDevice(config.device_name, config.compatible, config.device_address), 
        # DeviceType.I2C: I2CDevice(config.device_name, config.compatible, config.device_address), 
        DeviceType.FPGA: FPGADevice(config.device_name, config.compatible), 
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
        pass

    def create_declarations(self):
        functionString = ""
        functionString += self._create_includes()
        functionString += "static struct class *cl;\n"
        functionString += "static dev_t dev_num;"
        functionString += self._create_dev_struct()
        functionString += self._create_func_prototypes()
        functionString += "typedef struct fe_" + self.name + "_dev fe_" + self.name + "_dev_t;\n"
        functionString += self._create_id_matching_struct()
        functionString += self._create_platform_driver_struct()
        functionString += self._create_file_ops_struct()
        functionString += self._create_module_declarations()
        for attr in self.device_attributes:
            functionString += attr.create_macro()
        functionString += self._create_attr_table()
        functionString += self._create_attr_group()
        return functionString
    def create_func_implementations(self):
        functionString = ""
        functionString += self._create_init_func()
        functionString += self._create_probe_func()
        functionString += self._create_file_ops_funcs()
        for attr in self.device_attributes:
            functionString += attr.create_read_func(self.name)
            functionString += attr.create_write_func(self.name)
        functionString += self._create_remove_func()
        functionString += self._create_exit_func()
        return functionString
    def _create_func_prototypes(self): 
        functionString = ""
        functionString += "static int " + self.name + "_init(void);\n"
        functionString += "static void " + self.name + "_exit(void);\n"
        functionString += "static int " + self.name + "_probe(struct platform_device *pdev);\n"
        functionString += "static int " + self.name + "_remove(struct platform_device *pdev);\n"
        functionString += "static ssize_t " + self.name + "_read(struct file *file, char *buffer, size_t len, loff_t *offset);\n"
        functionString += "static ssize_t " + self.name + "_write(struct file *file, const char *buffer, size_t len, loff_t *offset);\n"
        functionString += "static int " + self.name + "_open(struct inode *inode, struct file *file);\n"
        functionString += "static int " + self.name + "_release(struct inode *inode, struct file *file);\n\n"
        for attr in self.device_attributes:
            functionString += attr.create_func_prototypes()
        return functionString
    def _create_includes(self):
        functionString = "#include <linux/module.h>\n"
        functionString += "#include <linux/platform_device.h>\n"
        functionString += "#include <linux/io.h>\n"
        functionString += "#include <linux/fs.h>\n"
        functionString += "#include <linux/types.h>\n"
        functionString += "#include <linux/uaccess.h>\n"
        functionString += "#include <linux/init.h>\n"
        functionString += "#include <linux/cdev.h>\n"
        functionString += "#include <linux/regmap.h>\n"
        functionString += "#include <linux/of.h>\n"
        functionString += "#include \"custom_functions.h\"\n"
        return functionString
    def _create_module_declarations(self):
        functionString = "\nMODULE_LICENSE(\"GPL\");\n"
        functionString += "MODULE_AUTHOR(\"Autogen <support@flatearthinc.com\");\n"
        functionString += "MODULE_DESCRIPTION(\"Loadable kernel module for the " + self.name + "\");\n"
        functionString += "MODULE_VERSION(\"1.0\");\n"
        functionString += "MODULE_DEVICE_TABLE(of, fe_" + self.name + "_dt_ids);\n"
    
        functionString += "module_init(" + self.name + "_init);\n"
        functionString += "module_exit(" + self.name + "_exit);\n\n"
        return functionString
    def _create_file_ops_struct(self):
        functionString = "/* File ops struct */\n"
        functionString += "static const struct file_operations fe_" + self.name + "_fops = {\n"
        functionString += "  .owner = THIS_MODULE,\n"
        functionString += "  .read = "    + self.name + "_read,\n"
        functionString += "  .write = "   + self.name + "_write,\n"
        functionString += "  .open = "    + self.name + "_open,\n"
        functionString += "  .release = " + self.name + "_release,\n"
        functionString += "};\n\n"
        return functionString

    def _create_platform_driver_struct(self):
        functionString = "/* Platform driver struct */\n"
        functionString += "static struct platform_driver " + self.name + "_platform = {\n"
        functionString += "  .probe = " + self.name + "_probe,\n"
        functionString += "  .remove = " + self.name + "_remove,\n"
        functionString += "  .driver = {\n"
        functionString += "    .name = \"Flat Earth " + self.name + " Driver\",\n"
        functionString += "    .owner = THIS_MODULE,\n"
        functionString += "    .of_match_table = fe_" + self.name + "_dt_ids\n"
        functionString += "  }\n"
        functionString += "};\n\n"
        return functionString

    def _create_id_matching_struct(self):
        functionString = "/* ID Matching struct */\n"
        functionString += "static struct of_device_id fe_" + self.name + "_dt_ids[] = {\n"
        functionString += "  {\n"
        functionString += "    .compatible = \"" + self.compatible + "\"\n"
        functionString += "  },\n"
        functionString += "  { }\n"
        functionString += "};\n\n"
        return functionString

    def _create_dev_struct(self):
        functionString = "\n/* Device struct */\n"
        functionString += "struct fe_" + self.name + "_dev {\n"
        functionString += "  struct cdev cdev;\n"
        functionString += "  void __iomem *regs;\n"
        for attr in self.device_attributes:
            functionString += f"  {attr.create_variable_declaration()}"
        functionString += "};\n\n"
        return functionString
    def _create_attr_table(self):
        functionString = ""
        functionString += f"static struct attribute *{self.name}_attrs[] = {{"
        for attr in self.device_attributes:
            functionString += f"  &dev_attr_{attr.name}.attr,"
        functionString += f"  NULL"
        functionString += f"}};\n\n"
        return functionString
    def _create_attr_group(self):
        functionString = f"ATTRIBUTE_GROUPS({self.name});\n\n"
        return functionString
    def _create_init_func(self):
        functionString = ""
        functionString += f"static int {self.name}_init(void) {{\n"
        functionString += "  int ret_val = 0;\n"
        timeString = strftime("%Y-%m-%d %H:%M")
        functionString += "  printk(KERN_ALERT \"FUNCTION AUTO GENERATED AT: " + timeString + "\\n\");\n"
        functionString += "  pr_info(\"Initializing the Flat Earth " + self.name + " module\\n\");\n"
        functionString += "  // Register our driver with the \"Platform Driver\" bus\n"
        functionString += "  ret_val = platform_driver_register(&" + self.name + "_platform);"
        functionString += "  if (ret_val != 0) {\n"
        functionString += "    pr_err(\"platform_driver_register returned %d\\n\", ret_val);\n"
        functionString += "    return ret_val;\n"
        functionString += "  }\n"
        functionString += self._init_device()
        functionString += "  pr_info(\"Flat Earth " + self.name + " module successfully initialized!\\n\");\n"
        functionString += "  return 0;\n"
        functionString += "}\n"
        return functionString
    def _init_device(self):
        return ""
    def _create_probe_func(self):
        functionString = ""
        functionString += "static int " + self.name + "_probe(struct platform_device *pdev) {\n"
        functionString += "  int ret_val = -EBUSY;\n"
        functionString += ("  char device_name[" + str(len(self.name) + 12) +"] = \"fe_" + self.name
                        + "_\";\n")  # adding 12 to len is arbitrary
        functionString += "  char deviceMinor[20];\n"
        functionString += "  int status;\n"
        functionString += "  struct device *device_obj;\n"
        devpString = "fe_" + self.name + "_devp"
        functionString += "  fe_" + self.name + "_dev_t * " + devpString + ";\n"
        functionString += "  struct resource *r = NULL;\n"
        functionString += "  pr_info(\"" + self.name + "_probe enter\\n\");\n"
        functionString += ("  " + devpString + " = devm_kzalloc(&pdev->dev, sizeof(fe_" + self.name +
                        "_dev_t), GFP_KERNEL);\n")
        functionString += self._init_platform()
        functionString += "  platform_set_drvdata(pdev, (void *)" + devpString + ");\n"
        functionString += "  " + devpString + "->name = devm_kzalloc(&pdev->dev, 50, GFP_KERNEL);\n"
        functionString += "  if (" + devpString + "->name == NULL)\n"
        functionString += "    goto bad_mem_alloc;\n"
        functionString += "  strcpy(" + devpString + "->name, (char *)pdev->name);\n"
        functionString += "  pr_info(\"%s\\n\", (char *)pdev->name);\n"
        functionString += "  status = alloc_chrdev_region(&dev_num, 0, 1, \"fe_" + self.name + "_\");\n"
        functionString += "  if (status != 0)\n"
        functionString += "    goto bad_alloc_chrdev_region;\n"
        functionString += "  sprintf(deviceMinor, \"%d\", MAJOR(dev_num));\n"
        functionString += "  strcat(device_name, deviceMinor);\n"
        functionString += "  pr_info(\"%s\\n\", device_name);\n"
        functionString += "  cl = class_create(THIS_MODULE, device_name);\n"
        functionString += "  if (cl == NULL)\n"
        functionString += "    goto bad_class_create;\n"
        functionString += "  cdev_init(&" + devpString + "->cdev, &fe_" + self.name + "_fops);\n"
        functionString += "  status = cdev_add(&" + devpString + "->cdev, dev_num, 1);\n"
        functionString += "  if (status != 0)\n"
        functionString += "    goto bad_cdev_add;\n"
        functionString += f" device_obj = device_create_with_groups(cl, NULL, dev_num, NULL, {self.name}_groups, device_name);\n"
        functionString += f"  if (device_obj == NULL)\n"
        functionString += "    goto bad_device_create;\n"
        functionString += "  dev_set_drvdata(device_obj, " + devpString + ");\n"
        functionString += "  pr_info(\"" + self.name + " exit\\n\");\n"
        functionString += "  return 0;\n"
        functionString += "bad_device_create:\n"
        functionString += "bad_cdev_add:\n"
        functionString += "  cdev_del(&fe_" + self.name + "_devp->cdev);\n"
        functionString += "bad_class_create:\n"
        functionString += "  class_destroy(cl);\n"
        functionString += "bad_alloc_chrdev_region:\n"
        functionString += "  unregister_chrdev_region(dev_num, 1);\n"
        functionString += "bad_mem_alloc:\n"
        functionString += "bad_exit_return:\n"
        functionString += "  pr_info(\"" + self.name + "_probe bad exit\\n\");\n"
        functionString += "  return ret_val;\n"
        functionString += "}\n\n\n"
        return functionString
    def _init_platform(self):
        return ""
    def _create_file_ops_funcs(self):
        
        functionString = "static int " + self.name + "_open(struct inode *inode, struct file *file) {\n"
        functionString += "  // TODO: fill this in (if its needed, it might not be)\n"
        functionString += "  return 0;\n"
        functionString += "}\n\n"
        functionString += "static int " + self.name + "_release(struct inode *inode, struct file *file) {\n"
        functionString += "  // TODO: fill this in (if its needed, it might not be)\n"
        functionString += "  return 0;\n"
        functionString += "}\n\n"
        functionString += "static ssize_t " + self.name + "_read(struct file *file, char *buffer, size_t len, loff_t *offset) {\n"
        functionString += "  // TODO: fill this in (if its needed, it might not be)\n"
        functionString += "  return 0;\n"
        functionString += "}\n\n"
        functionString += "static ssize_t " + self.name + "_write(struct file *file, const char *buffer, size_t len, loff_t *offset) {\n"
        functionString += "  // TODO: fill this in (if its needed, it might not be)\n"
        functionString += "  return 0;\n"
        functionString += "}\n"
        return functionString
    
    def _create_remove_func(self):
        functionString = ""
        functionString += "static int " + self.name + "_remove(struct platform_device *pdev) {\n"
        functionString += "  fe_" + self.name + "_dev_t *dev = (fe_" + self.name + "_dev_t *)platform_get_drvdata(pdev);\n"
        functionString += "  pr_info(\"" + self.name + "_remove enter\\n\");\n"
        functionString += "  device_destroy(cl, dev_num);\n"
        functionString += "  cdev_del(&dev->cdev);\n"
        functionString += "  class_destroy(cl);\n"
        functionString += "  unregister_chrdev_region(dev_num, 2);\n"
        functionString += "  pr_info(\"" + self.name + "_remove exit\\n\");\n"
        functionString += "  return 0;\n"
        functionString += "}\n\n\n"
        return functionString

    def _create_exit_func(self):
        functionString = "static void " + self.name + "_exit(void) {\n"
        functionString += "  pr_info(\"Flat Earth " + self.name + " module exit\\n\");\n"
        functionString += "  platform_driver_unregister(&" + self.name + "_platform);\n"
        functionString += self._exit_device()
            
        functionString += "  pr_info(\"Flat Earth " + self.name + " module successfully unregistered\\n\");\n"
        functionString += "}\n"
        return functionString
    def _exit_device(self):
        return ""

class FPGADevice(Device):
    def __init__(self, name, compatible):
        super().__init__(name, compatible)
    def _init_platform(self):
        devpString = "fe_" + self.name + "_devp"
        functionString = ""
        functionString += "  r = platform_get_resource(pdev, IORESOURCE_MEM, 0);\n"
        functionString += "  if (r == NULL) {\n"
        functionString += "    pr_err(\"IORESOURCE_MEM (register space) does not exist\\n\");\n"
        functionString += "    goto bad_exit_return;"
        functionString += "  }\n"
        functionString += "  " + devpString + "->regs = devm_ioremap_resource(&pdev->dev, r);\n"
        functionString += "  if (IS_ERR(" + devpString + "->regs)) {\n"
        functionString += "    ret_val = PTR_ERR(fe_" + self.name + "_devp->regs);\n"
        functionString += "    goto bad_exit_return;\n  }\n"
        return functionString


class SPIDevice(Device):
    def __init__(self, name, compatible, address, speed, chip_select, mode):
        super().__init__(name, compatible)
        self.address = address
        self.speed = speed
        self.chip_select = chip_select
        self.mode = mode
    def create_declarations(self):
        functionString = super().create_declarations()
        functionString += "static uint8_t bits = 8;\n"
        functionString += "static uint32_t speed = " + self.speed + ";\n"
        functionString += "static struct spi_device *spi_device;\n"
    def _create_func_prototypes(self):
        functionString = super()._create_func_prototypes()
        functionString += "uint8_t find_volume_level(uint32_t fp28_num);\n"
        functionString += "uint32_t decode_volume(uint8_t code);\n"
        return functionString
    def _init_device(self):
        functionString = ""
        functionString += "  // Register the device\n"
        functionString += "  struct spi_board_info spi_device_info = {\n"
        functionString += "    .modalias = \"fe_" + self.name + "_\",\n"
        functionString += "    .max_speed_hz = " + self.speed + ",\n"
        functionString += "    .bus_num = 0,\n"
        functionString += "    .chip_select = " + self.chip_select + ",\n"
        functionString += "    .mode = " + self.mode + ",\n"
        functionString += "  };\n"
        functionString += "  /* To send data we have to know what spi port/pins should be used. This information\n"
        functionString += "  can be found in the device-tree. */\n"
        functionString += "  master = spi_busnum_to_master( spi_device_info.bus_num );\n"
        functionString += "  if( !master ) {\n"
        functionString += "    printk(\"MASTER not found.\\n\");\n"
        functionString += "    return -ENODEV;\n"
        functionString += "  }\n"
        functionString += "  // create a new slave device, given the master and device info\n"
        functionString += "  spi_device = spi_new_device(master, &spi_device_info);\n"
        functionString += "  printk(\"Setting up new slave device\\n\");\n"
        functionString += "  if (!spi_device) {\n"
        functionString += "    printk(\"FAILED to create slave.\\n\");\n"
        functionString += "    return -ENODEV;\n"
        functionString += "  }\n"
        functionString += "  printk(\"Set the bits per word\\n\");\n"
        functionString += "  spi_device->bits_per_word = bits;\n"
        functionString += "  printk(\"Setting up the device\\n\");\n"
        functionString += "  ret_val = spi_setup(spi_device);\n"
        functionString += "  if (ret_val) {\n"
        functionString += "    printk(\"FAILED to setup slave.\\n\");\n"
        functionString += "    spi_unregister_device(spi_device);\n"
        functionString += "    return -ENODEV;\n"
        functionString += "  }\n"
        functionString += "  printk(\"Sending SPI initialization commands...\\n\");\n"
        functionString += "  // Sending init commands\n"
        functionString += self._write_init_commands()
        return
    def _write_init_commands(self):
        # functionString = ""
        # if inputParams.initCommLen > 0:
        #     functionString += "  char cmd[" + str(inputParams.initCommBytes) + "];\n"
        # for i in range(inputParams.initCommLen):
        #     try:
        #         functionString += "  // desc: " + inputParams.initCommDesc[i] + "\n"
        #     except:
        #         functionString += "  // no command description\n"
        #     for j in range(inputParams.initCommBytes):
        #         functionString += "  cmd[" + str(j) + "] = " + inputParams.initComm[i][j] + ";"
        #     functionString += "\n"
        #     functionString += "  ret_val = " + inputParams.initCommSendFunc + "(" + inputParams.initCommSendParams + ");\n\n"
        # return functionString
        return ""
    # def WriteVolumeTable(inputParams, functionString):
    #     functionString += "typedef struct {\n"
    #     functionString += "  uint16_t value;\n"
    #     functionString += "  uint8_t  code;\n"
    #     functionString += "} volumeLevel;\n\n"
    #     try:
    #         functionString += "#define PN_INDEX " + str(inputParams.PN_INDEX) + "\n"
    #     except:
    #         functionString += "// No PN_INDEX specified in input params\n"
    #     functionString += "static volumeLevel VolumeLevels[] = {\n"
    #     for i in range(len(inputParams.volumeTable)):
    #         functionString += "  {.value = " + str(inputParams.volumeTable[i][0]) + ", .code = " + str(inputParams.volumeTable[i][1]) + "},\n"
    #     functionString += "};\n"
    #     return functionString
    def _exit_device(self):
        functionString = "  if (spi_device) {\n"
        functionString += "    spi_unregister_device(spi_device);\n"
        functionString += "  }\n"
        return functionString
    def _create_includes(self):
        functionString = "#include <linux/spi/spi.h>\n"
        return functionString

class I2CDevice(Device):
    def __init__(self, name, compatible, address):
        super().__init__(name, compatible)
        self.address = address
    
    def create_declarations(self):
        functionString = super().create_declarations()
        functionString += self._create_i2c_structs()
        return functionString
    
    def _create_includes(self):
        functionString = ""
        functionString += super()._create_includes()
        functionString += "#include <linux/i2c.h>\n"
        return functionString
    def _create_func_prototypes(self):
        functionString = super()._create_func_prototypes()
        functionString += "uint8_t find_volume_level(uint32_t fp28_num, uint8_t p);\n"
        functionString += "uint32_t decode_volume(uint8_t code);\n"
        return functionString
    def _create_i2c_structs(self):
        functionString = ""
        functionString += "struct i2c_client * " + self.name + "_i2c_client;\n"
        functionString += "static struct i2c_device_id " + self.name + "_id[] = {\n"
        functionString += "  {\n"
        functionString += "    \"" + self.name + "_i2c\"," + self.address + "\n"
        functionString += "  },\n"
        functionString += "  { }\n"
        functionString += "};\n\n"
        functionString += "static struct i2c_board_info " + self.name + "_i2c_info = {\n"
        functionString += "  I2C_BOARD_INFO(\"" + self.name + "_i2c\"," + self.address + "),\n"
        functionString += "};\n\n"
        functionString += "static int " + self.name + "_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id) {\n"
        functionString += "  return 0;\n"
        functionString += "}\n"
        functionString += "static int " + self.name + "_i2c_remove(struct i2c_client *client) {\n"
        functionString += "  return 0;\n"
        functionString += "}\n"
        functionString += "struct i2c_driver " + self.name + "_i2c_driver = {\n"
        functionString += "  .driver = {\n"
        functionString += "    .name=\"" + self.name + "_i2c\",\n"
        functionString += "  },\n"
        functionString += "  .probe = " + self.name + "_i2c_probe,\n"
        functionString += "  .remove = " + self.name + "_i2c_remove,\n"
        functionString += "  .id_table = " + self.name + "_id,\n"
        functionString += "};\n"
        return functionString
    def _init_device(self):
        functionString = ""
        functionString += "  /*-------------------------------------------------------\n"
        functionString += "     I2C communication\n"
        functionString += "  --------------------------------------------------------*/\n"
        functionString += "  // Register the device\n"
        functionString += "  ret_val = i2c_add_driver(&" + self.name + "_i2c_driver);\n"
        functionString += "  if (ret_val < 0) {\n"
        functionString += "    pr_err(\"Failed to register I2C driver\");\n"
        functionString += "    return ret_val;\n"
        functionString += "  }\n"
        functionString += "  i2c_adapt = i2c_get_adapter(0);\n"
        functionString += "  memset(&i2c_info,0,sizeof(struct i2c_board_info));\n"
        functionString += "  strlcpy(i2c_info.type, \"" + self.name + "_i2c\",I2C_NAME_SIZE);\n"
        functionString += "  " + self.name + "_i2c_client = i2c_new_device(i2c_adapt,&" + self.name + "_i2c_info);\n"
        functionString += "  i2c_put_adapter(i2c_adapt);\n"
        functionString += "  if (!" + self.name + "_i2c_client) {\n"
        functionString += "    pr_err(\"Failed to connect to I2C client\\n\");\n"
        functionString += "    ret_val = -ENODEV;\n"
        functionString += "    return ret_val;\n"
        functionString += "  }\n"
        functionString += "  // Send some initialization commands\n"
        return functionString