def WriteDeviceAttributes(inputParams):
    functionString = "/*************************************************\n"
    functionString += "Generated in WriteDeviceAttributes\n"
    functionString += "*************************************************/\n"
    for attr in inputParams.device_attributes:
        functionString += ("DEVICE_ATTR(" + attr.name + ", " + attr.permissions
                           + ", " + attr.name + "_read, " + attr.name
                           + "_write);\n")
    functionString += "DEVICE_ATTR(name, 0444, name_read, NULL);\n"
    functionString += "/* End WriteDeviceAttributes */\n\n\n"
    return functionString