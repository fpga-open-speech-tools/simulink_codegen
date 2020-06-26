

# Refactor constants into C constants/defines such as
    # i2c/ spi address
    # nominal states ex. 0x35 is the initialization data

class Device:
    def __init__(self, name, compatible):
        self.name = name
        self.compatible = compatible
        self.device_attributes = []
        pass
    
    def create_declarations(self):
        functionString = self._create_dev_struct()
        functionString += "typedef struct fe_" + self.name + "_dev fe_" + self.name + "_dev_t;\n"
        functionString += self._create_id_matching_struct()
        functionString += self._create_platform_driver_struct()
        functionString += self._create_file_ops_struct()
        functionString += self._create_func_prototypes()
        functionString += self._create_module_declarations()
        for attr in self.device_attributes:
            functionString += attr.create_macro()
        functionString += "DEVICE_ATTR(name, 0444, name_read, NULL);\n"

        return functionString
    def _create_func_prototypes(self): 
        functionString = "static int " + self.name + "_probe(struct platform_device *pdev);\n"
        functionString += "static int " + self.name + "_remove(struct platform_device *pdev);\n"
        functionString += "static ssize_t " + self.name + "_read(struct file *file, char *buffer, size_t len, loff_t *offset);\n"
        functionString += "static ssize_t " + self.name + "_write(struct file *file, const char *buffer, size_t len, loff_t *offset);\n"
        functionString += "static int " + self.name + "_open(struct inode *inode, struct file *file);\n"
        functionString += "static int " + self.name + "_release(struct inode *inode, struct file *file);\n\n"
        functionString += "static ssize_t name_read(struct device *dev, struct device_attribute *attr, char *buf);\n"
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
        functionString += "module_exit(" + self.name + "_exit);\n"
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
        functionString += "  char *name;\n"
        functionString += "  void __iomem *regs;\n"
        for attr in self.device_attributes:
            try:  # try to get the type of the attribute from input params, otherwise just assume its int;
                functionString += "  " + attr.data_type.name
            except:
                functionString += "  int"
            functionString += " " + attr.name + ";\n"
        functionString += "};\n\n"
        return functionString
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

class SPIDevice(Device):
    def __init__(self, name, compatible, address):
        super.__init__(name, compatible)
        self.address = address
    def _create_func_prototypes(self):
        functionString = super._create_func_prototypes()
        functionString += "uint8_t find_volume_level(uint32_t fp28_num);\n"
        functionString += "uint32_t decode_volume(uint8_t code);\n"
        return functionString
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
        super.__init__(name, compatible)
        self.address = address
    
    def create_declarations(self):
        functionString = super.create_declarations()
        functionString += self._create_i2c_structs()
        return functionString
    
    def _create_includes(self):
        functionString = "#include <linux/i2c.h>\n"
        return functionString
    def _create_func_prototypes(self):
        functionString = super._create_func_prototypes()
        functionString += "uint8_t find_volume_level(uint32_t fp28_num, uint8_t p);\n"
        functionString += "uint32_t decode_volume(uint8_t code);\n"
        return functionString

    def _create_i2c_structs(self):
        
        functionString = "static struct i2c_device_id " + self.name + "_id[] = {\n"
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