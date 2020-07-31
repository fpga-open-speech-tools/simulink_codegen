from .driver_config import DriverConfig
from .device import get_device

import os.path

class Generator:
  def __init__(self, config):
    self.config = config
    self.device = get_device(self.config.device_type, config)
  # Writes driver to file by calling JsonToDriver
  def write_driver(self, outputFile):

      output = open(outputFile, "w")
      output.write(self.json_to_driver())

      print("Keep in mind custom_functions.h should be included when you compile the driver.")

  # Should make the string representation
  def json_to_driver(self):
    driverString = ""
    driverString += self.device.create_declarations()
    driverString += self.device.create_func_implementations()
    return driverString

  
