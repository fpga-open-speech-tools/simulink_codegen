from abc import ABC, abstractmethod
from enum import Enum

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
        pass
class EntityFile(BaseVHDLNode):
    """Represents a VHDL entity file."""

    def __init__(self, name, entity = None):
        self.name = name
        self.entity = entity
    def generate(self):
        """Generate a VHDL entity file."""
        pass

class Signal(BaseVHDLNode):
    def __init__(self, name, data_type, length = 1):
        self.data_type = data_type
        self.length = length
    def generate(self):
        """Generate a VHDL signal."""
        pass
class Port(Signal):
    def __init__(self, direction, name, length = 1, data_type = None):
        if data_type == None:
            data_type = self._get_data_type()
        super().__init__(name, data_type, length)
        self.direction = direction
    def generate(self):
        """Generate a VHDL port."""
        pass
    def _get_data_type(self):
        if self.length == 1:
            return "std_logic"
        else:
            return"std_logic_vector"
class PortDir(Enum):
    In = 1
    Out = 2


class Entity(BaseVHDLNode):
    def __init__(self, name, ports):
        self.name = name
        self.ports = ports
    def generate(self):
        """Generate a VHDL entity."""
        pass
class Component(Entity):
    def __init__(self, name, ports):
        super().__init__(name, ports)
        self.portMap = {}
    def generate(self):
        """Generate a VHDL component."""
        pass
class Architecture(BaseVHDLNode):
    def __init__(self, name, entity):
        self.name = name
        self.entity = entity
        self.signals = []
        self.processes = []
        self.components = []
    def generate(self):
        """Generate a VHDL Architecture."""
        pass
class Process(BaseVHDLNode):
    def __init___(self, name):
        self.name = name
        self.sensitivity_list = []
        self.logic = []
        self.variables = []
    def generate(self):
        """Generate a VHDL Architecture."""
        pass