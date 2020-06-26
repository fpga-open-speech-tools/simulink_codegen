def CreateMiscTopOfFile(inputParams):
    functionString = "/***********************************************\n"
    functionString += "  Generated in CreateMiscTopOfFile\n"
    functionString += "***********************************************/\n"
    functionString += "static struct class *cl;  // Global variable for the device class\n"
    functionString += "static dev_t dev_num;\n\n"
    functionString += "/*********** Device type specific things **************/\n"
    if inputParams.device_type == 0:   # SPI Device
        functionString = TopOfFileSPIStuff(inputParams, functionString)
    elif inputParams.device_type == 1: # I2C Device
        functionString = TopOfFileI2CStuff(inputParams, functionString)
    elif inputParams.device_type == 2: # FPGA Device
        pass
    else:
        print("NOT A SPI I2C OR FPGA DEVICE?")
        return ""
    if inputParams.needsVolumeTable:
        functionString += "\n/* Volume table */\n"
        functionString = WriteVolumeTable(inputParams, functionString)
    functionString += "/* End of CreateMiscTopOfFile */\n\n\n"
    return functionString


def TopOfFileSPIStuff(inputParams, functionString):
    functionString += "// Define some SPI stuff\n"
    functionString += "static uint8_t bits = 8;\n"
    functionString += "static uint32_t speed = " + inputParams.speed + ";\n"
    functionString += "static struct spi_device *spi_device;\n"
    return functionString


def TopOfFileI2CStuff(inputParams, functionString):
    functionString += "// Define some I2C stuff\n"
    functionString += "struct i2c_driver " + inputParams.device_name_abbrev + "_i2c_driver;\n"
    functionString += "struct i2c_client * " + inputParams.device_name_abbrev + "_i2c_client;\n"
    functionString += "static const unsigned short normal_i2c[] = {0x35, I2C_CLIENT_END}; // remove? -Tyler\n"
    return functionString


def WriteVolumeTable(inputParams, functionString):
    functionString += "typedef struct {\n"
    functionString += "  uint16_t value;\n"
    functionString += "  uint8_t  code;\n"
    functionString += "} volumeLevel;\n\n"
    try:
        functionString += "#define PN_INDEX " + str(inputParams.PN_INDEX) + "\n"
    except:
        functionString += "// No PN_INDEX specified in input params\n"
    functionString += "static volumeLevel VolumeLevels[] = {\n"
    for i in range(len(inputParams.volumeTable)):
        functionString += "  {.value = " + str(inputParams.volumeTable[i][0]) + ", .code = " + str(inputParams.volumeTable[i][1]) + "},\n"
    functionString += "};\n"
    return functionString