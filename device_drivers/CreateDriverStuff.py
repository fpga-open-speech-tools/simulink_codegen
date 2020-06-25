def CreateDriverStuff(inputParams):
    functionString = "/****************************************************\n"
    functionString += "Generated in CreateDriverStuff\n"
    functionString += "****************************************************/\n"
    devName = inputParams.device_name
    functionString += CreateDevStruct(inputParams)
    functionString += "typedef struct fe_" + devName + "_dev fe_" + devName + "_dev_t;\n"
    functionString += CreateIDMatchingStruct(inputParams)
    if inputParams.device_type == 1:  # if I2C device it needs the next thing
        functionString += CreateI2CDriverStructs(inputParams)
    functionString += "MODULE_DEVICE_TABLE(of, fe_" + devName + "_dt_ids);\n"
    functionString += CreatePlatformDriverStruct(inputParams)
    functionString += CreateFileOpsStruct(inputParams)
    functionString += "/* End of CreateDriverStuff */\n\n\n"
    return functionString


def CreateDevStruct(inputParams):
    functionString = "\n/* Device struct */\n"
    functionString += "struct fe_" + inputParams.device_name + "_dev {\n"
    functionString += "  struct cdev cdev;\n"
    functionString += "  char *name;\n"
    functionString += "  void __iomem *regs;\n"
    for attr in inputParams.device_attributes:
        try:  # try to get the type of the attribute from input params, otherwise just assume its int;
            functionString += "  " + attr.data_type.name
        except:
            functionString += "  int"
        functionString += " " + inputParams.device_attributes.name + ";\n"
    functionString += "};\n\n"
    return functionString


def CreateIDMatchingStruct(inputParams):
    functionString = "/* ID Matching struct */\n"
    functionString += "static struct of_device_id fe_" + inputParams.device_name + "_dt_ids[] = {\n"
    functionString += "  {\n"
    functionString += "    .compatible = \"" + inputParams.compatible_flag + "\"\n"
    functionString += "  },\n"
    functionString += "  { }\n"
    functionString += "};\n\n"
    return functionString


def CreatePlatformDriverStruct(inputParams):
    functionString = "/* Platform driver struct */\n"
    functionString += "static struct platform_driver " + inputParams.device_name + "_platform = {\n"
    functionString += "  .probe = " + inputParams.device_name + "_probe,\n"
    functionString += "  .remove = " + inputParams.device_name + "_remove,\n"
    functionString += "  .driver = {\n"
    functionString += "    .name = \"Flat Earth " + inputParams.device_name + " Driver\",\n"
    functionString += "    .owner = THIS_MODULE,\n"
    functionString += "    .of_match_table = fe_" + inputParams.device_name + "_dt_ids\n"
    functionString += "  }\n"
    functionString += "};\n\n"
    return functionString


def CreateFileOpsStruct(inputParams):
    functionString = "/* File ops struct */\n"
    functionString += "static const struct file_operations fe_" + inputParams.device_name + "_fops = {\n"
    functionString += "  .owner = THIS_MODULE,\n"
    functionString += "  .read = "    + inputParams.device_name + "_read,\n"
    functionString += "  .write = "   + inputParams.device_name + "_write,\n"
    functionString += "  .open = "    + inputParams.device_name + "_open,\n"
    functionString += "  .release = " + inputParams.device_name + "_release,\n"
    functionString += "};\n\n"
    return functionString


def CreateI2CDriverStructs(inputParams):
    devNameAbbrev = inputParams.device_name_abbrev
    functionString = "/* I2C Driver stuff */\n"
    functionString += "static struct i2c_device_id " + devNameAbbrev + "_id[] = {\n"
    functionString += "  {\n"
    functionString += "    \"" + devNameAbbrev + "_i2c\"," + inputParams.device_i2c_address + "\n"
    functionString += "  },\n"
    functionString += "  { }\n"
    functionString += "};\n\n"
    functionString += "static struct i2c_board_info " + devNameAbbrev + "_i2c_info = {\n"
    functionString += "  I2C_BOARD_INFO(\"" + devNameAbbrev + "_i2c\"," + inputParams.device_i2c_address + "),\n"
    functionString += "};\n\n"
    functionString += "static int " + devNameAbbrev + "_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id) {\n"
    functionString += "  return 0;\n"
    functionString += "}\n"
    functionString += "static int " + devNameAbbrev + "_i2c_remove(struct i2c_client *client) {\n"
    functionString += "  return 0;\n"
    functionString += "}\n"
    functionString += "struct i2c_driver " + devNameAbbrev + "_i2c_driver = {\n"
    functionString += "  .driver = {\n"
    functionString += "    .name=\"" + devNameAbbrev + "_i2c\",\n"
    functionString += "  },\n"
    functionString += "  .probe = " + devNameAbbrev + "_i2c_probe,\n"
    functionString += "  .remove = " + devNameAbbrev + "_i2c_remove,\n"
    functionString += "  .id_table = " + devNameAbbrev + "_id,\n"
    functionString += "};\n"
    return functionString