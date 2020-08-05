from abc import ABC, abstractmethod
from enum import Enum
import os

from .util import tab

class BaseVHDLNode(ABC):
    def __init__(self, name):
        """[summary]

        Parameters
        ----------
        name : [type]
            [description]
        """
        self.name = name
    @abstractmethod
    def generate(self):
        """Generate VHDL code."""
class Library(BaseVHDLNode):
    def __init__(self, name, packages=None):
        super().__init__(name)
        self.packages = packages or []
    def generate(self):
        vhdl = f"library {self.name};\n"
        for package in self.packages:
            vhdl += f"use {self.name}.{package}.all;\n"
        vhdl += "\n"
        return vhdl

class VHDLFile(BaseVHDLNode):
    def __init__(self, name):
        super().__init__(name)
    @abstractmethod
    def generate(self):
        """Generate VHDL code."""
    def write(self, output_dir=""):
        if output_dir != "" and not output_dir.endswith(os.sep):
            output_dir += os.sep

        with open(output_dir + self.name + ".vhd", 'w') as vhdl_file:
            vhdl_file.write(self.generate())

class EntityFile(VHDLFile):
    """Represents a VHDL entity file."""

    def __init__(self, name, entity, architecture=None, libraries=None):
        super().__init__(name)
        self.entity = entity
        self.architecture = architecture
        self.libraries = libraries or []
    def generate(self):
        """Generate a VHDL entity file."""
        vhdl = ""

        for library in self.libraries:
            vhdl += library.generate()

        vhdl += self.entity.generate()
        vhdl += self.architecture.generate()
        return vhdl

class Signal(BaseVHDLNode):
    def __init__(self, name, length=1, default_value=None, data_type=None):
        super().__init__(name)
        self.length = length
        self.default_value = default_value

        if data_type is None:
            data_type = self._get_data_type()
        self.data_type = data_type

    def generate(self):
        """Generate a VHDL signal."""
        print(self.name + " has length: " + str(self.length))
        if self.length == 1:
            type_declaration = self.data_type
        else:
            length_test = self.length - 1
            type_declaration = f"{self.data_type}({(self.length - 1)} downto 0)"
        return f"signal {self.name.ljust(32)} : {type_declaration} := {self.default_value};\n"
    def _get_data_type(self):
        if self.length == 1:
            return "std_logic"
        return"std_logic_vector"
class LiteralSignal(Signal):
    def __init__(self, value):
        if len(value) == 1:
            name = f"'{value}'"
        else:
            name = f"\"{value}\""
        super().__init__(name, len(value), value)
class Port(Signal):
    def __init__(self, direction, name, length=1, data_type=None):
        super().__init__(name, length, None, data_type)
        self.direction = direction
    def generate(self):
        """Generate a VHDL port."""
        print(self.name + " has length: " + str(self.length))
        if self.length == 1:
            type_declaration = self.data_type
        else:
            type_declaration = f"{self.data_type}({(self.length - 1)} downto 0)"
        return f"{self.name.ljust(32)} : {self.direction.value} {type_declaration}"

class PortDir(Enum):
    In = "in "
    Out = "out"


class Entity(BaseVHDLNode):
    def __init__(self, name, ports):
        super().__init__(name)
        self.ports = ports
    def generate(self):
        """Generate a VHDL entity."""
        vhdl_string = f"entity {self.name} is \n"
        vhdl_string += self._generate_ports()
        vhdl_string += f"end entity {self.name};\n\n"
        return vhdl_string
    def _generate_ports(self):
        vhdl_string = ""
        vhdl_string += tab() + "port (\n"
        vhdl_string += tab(2)
        ports_vhdl = [port.generate() for port in self.ports]
        vhdl_string += (";\n" + tab(2)).join(ports_vhdl)
        vhdl_string += "\n"
        vhdl_string += tab() + ");\n"
        return vhdl_string
    def getPort(self, name):
        return next(port for port in self.ports if port.name == name)
    def getPorts(self, *names):
        return filter(lambda port: port.name in names, self.ports)
class Component(Entity):
    def __init__(self, name, ports):
        super().__init__(name, ports)
        self.port_map = None
    def generate(self):
        """Generate a VHDL component."""
        vhdl_string = f"component {self.name} is \n"
        vhdl_string += self._generate_ports()
        vhdl_string += f"end component {self.name};\n\n"
        return vhdl_string
class PortMap(BaseVHDLNode):
    def __init__(self, name, port_mapping, component):
        super().__init__(name)
        self._map = port_mapping
        self.component = component
    def generate(self):
        vhdl = f"{self.name} : {self.component.name}\n"
        vhdl += tab() + "port map(\n"
        port_assignments = []

        for port in self.component.ports:
            signal_str = self._create_signal_str(port)
            port_assignments.append(f"{port.name.ljust(32)} => {signal_str}")

        vhdl += tab(2)
        vhdl += (", \n" + tab(2)).join(port_assignments)
        vhdl += "\n"
        vhdl += ");\n"
        return vhdl

    def _create_signal_str(self, port):
        signal = self._map.get(port)
        if signal is None:
            return "open"
        if port.length == signal.length:
            return signal.name
        # Handle signed vs unsigned and resizing here
            
        #return signal_name
class Architecture(BaseVHDLNode):
    def __init__(self, name, entity):
        super().__init__(name)
        self.entity = entity
        self.signals = []
        self.processes = []
        self.components = []
    def generate(self):
        """Generate a VHDL Architecture."""
        vhdl = f"architecture {self.name} of {self.entity.name} is\n\n"

        for component in self.components:
            vhdl += component.generate()
        for signal in self.signals:
            vhdl += tab() + signal.generate()
        vhdl += "\n"
        vhdl += "begin\n\n"
        for component in self.components:
            vhdl += component.port_map.generate()
        for process in self.processes:
            vhdl += process.generate()
        
        vhdl += "end architecture;\n"
        return vhdl

class Process(BaseVHDLNode):
    def __init__(self, name, sensitivity_list=None, logic=""):
        super().__init__(name)
        self.sensitivity_list = sensitivity_list or []
        self.logic = logic
    def generate(self):
        """Generate a VHDL Architecture."""
        sensitivity_list_str = [signal.name for signal in self.sensitivity_list]
        vhdl = f"{self.name} : process({', '.join(sensitivity_list_str) })\n"
        vhdl += "begin\n"
        vhdl += self.logic
        vhdl += "end process;\n"
        return vhdl
