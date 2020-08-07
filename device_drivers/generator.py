#!/usr/bin/python

# @file generator.py
#
#     Python class to generate device drivers
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

    def json_to_driver(self):
        driver_string = ""
        driver_string += self.device.create_declarations()
        driver_string += self.device.create_func_implementations()
        return driver_string
