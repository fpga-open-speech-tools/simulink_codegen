from abc import ABC, abstractmethod
from enum import Enum
import os
from shutil import copyfile
import pathlib

from .util import tab, num_to_bitstring


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
    def __init__(self, name, libraries=None):
        super().__init__(name)
        self.libraries = libraries or []

    @abstractmethod
    def generate(self):
        """Generate VHDL code."""

    def write(self, output_dir=""):
        """Write file to the filesystem.

        Copies packages used in the work library to the output directory as well.

        Parameters
        ----------
        output_dir : str, optional
            Output directory to write file to, by default "" which results in the current directory
        """
        if output_dir != "" and not output_dir.endswith(os.sep):
            output_dir += os.sep

        with open(output_dir + self.name + ".vhd", 'w') as vhdl_file:
            vhdl_file.write(self.generate())

        work_library = next(
            (library for library in self.libraries if library.name == "work"), None)
        cur_dir = str(pathlib.Path(os.path.realpath(__file__)).parent)

        if work_library is not None:
            for package in work_library.packages:
                if os.path.isfile(cur_dir + "/" + package + ".vhd"):
                    copyfile(cur_dir + "/" + package + ".vhd",
                             output_dir + package + ".vhd")


class EntityFile(VHDLFile):
    """Represents a VHDL entity file."""

    def __init__(self, name, entity, architecture=None, libraries=None):
        super().__init__(name, libraries)
        self.entity = entity
        self.architecture = architecture

    def generate(self):
        """Generate a VHDL entity file."""
        vhdl = ""

        for library in self.libraries:
            vhdl += library.generate()

        vhdl += self.entity.generate()
        vhdl += self.architecture.generate()
        return vhdl


class Signal(BaseVHDLNode):
    def __init__(self, name, length=1, default_value=None, data_type=None, underlying_data_type=None):
        super().__init__(name)
        
        self.length = length or 1
        self.default_value = default_value

        if data_type is None:
            data_type = self._get_data_type()
        self.data_type = data_type
        self.underlying_data_type = underlying_data_type

    def generate(self):
        """Generate a VHDL signal."""
        if self.length == 1:
            type_declaration = self.data_type
        else:
            type_declaration = f"{self.data_type}({(self.length - 1)} downto 0)"
        if self.default_value is not None:
            default_str = f" := {self._get_default_str()}"
        else:
            default_str = ""
        return f"signal {self.name.ljust(32)} : {type_declaration}{default_str};\n"

    def generate_assignment(self, new_signal_value):
        """Generate VHDL assignment to this signal, including necessary resizing.

        Resizes using underlying data type if possible.
        VHDL data types must match except for std_logic and std_logic_vector.
        For assignmnents between std_logic and std_logic_vector,
        the first bit is where data is assumed to be stored.

        Parameters
        ----------
        new_signal_value : Signal
            signal being assigned to this. VHDL data types must match except for std_logic and std_logic_vector

        Returns
        -------
        str
            VHDL code to assign new_signal_value to this signal
        """
        if self.length == 1:
            if new_signal_value.length == 1:
                right_hand_side = new_signal_value.name
            else:
                right_hand_side = f"{new_signal_value.name}(0)"
        elif new_signal_value.length == 1:
            # No sign extension needed since length 1 is inherently unsigned
            right_hand_side = f"(0 => {new_signal_value.name}, others => '0')"
        else:
            right_hand_side = self._get_right_hand_side_vector_value(
                new_signal_value)
        return f"{self.name} <= {right_hand_side};\n"

    def _get_right_hand_side_vector_value(self, new_signal_value):
        new_data_type = new_signal_value.underlying_data_type
        if self.underlying_data_type is None or new_data_type is None:
            if self.length == new_signal_value.length:
                right_hand_side = new_signal_value.name
            elif self.underlying_data_type == new_data_type:
                # Both have no underlying_data_type, so just resize it
                right_hand_side = f"std_logic_vector(resize(unsigned({new_signal_value.name}), {self.length}))"
            elif self.length > new_signal_value.length and new_data_type is not None:
                # If extending signal, don't worry that assigment is to signal with no underlying data type
                conversion = "signed" if new_data_type.signed else "unsigned"
                right_hand_side = f"std_logic_vector(resize({conversion}({new_signal_value.name}), {self.length}))"
            elif self.underlying_data_type is not None:
                conversion = "signed" if self.underlying_data_type.signed else "unsigned"
                right_hand_side = f"std_logic_vector(resize({conversion}({new_signal_value.name}), {self.length}))"
            else:
                raise ValueError("Assigning signals of different length requires they either both or neither have underlying data types.\n"
                                 f"Attemped assigning {new_signal_value.name} ({new_signal_value.length}) to {self.name} ({self.length})")
        elif self.underlying_data_type == new_data_type:
            right_hand_side = new_signal_value.name
        else:
            if new_signal_value.data_type == "std_logic_vector":
                conversion = "signed" if new_data_type.signed else "unsigned"
                input_value = f"{conversion}({new_signal_value.name})"
            else:
                input_value = new_signal_value.name
            fixed_inputs = f"{input_value}, {new_signal_value.length}, {new_data_type.frac_len}, " \
                + f"{self.length}, {self.underlying_data_type.frac_len}"

            right_hand_side = f"resize_fixed({fixed_inputs})"
            if self.data_type == "std_logic_vector":
                right_hand_side = f"std_logic_vector({right_hand_side})"
        return right_hand_side

    def _get_default_str(self):
        if (not isinstance(self.default_value, str)) and self.underlying_data_type is not None:
            word_len = self.underlying_data_type.word_len
            frac_len = self.underlying_data_type.frac_len
            default_bit_string = num_to_bitstring(
                self.default_value, word_len, frac_len)
            return default_bit_string
        return str(self.default_value)

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


class Port(BaseVHDLNode):
    def __init__(self, direction, signal):
        super().__init__(signal.name)
        self.direction = direction
        self.signal = signal

    def generate(self):
        """Generate a VHDL port."""
        if self.signal.length == 1 and self.signal.data_type != "std_logic_vector":
            type_declaration = self.signal.data_type
        else:
            type_declaration = f"{self.signal.data_type}({(self.signal.length - 1)} downto 0)"
        return f"{self.name.ljust(32)} : {self.direction.value} {type_declaration}"

    @property
    def length(self):
        return self.signal.length

    @property
    def data_type(self):
        return self.signal.data_type

    @property
    def underlying_data_type(self):
        return self.signal.underlying_data_type

    def generate_assignment(self, new_signal_value):
        """Generate VHDL assignment to this port, including necessary resizing.

        Resizes using underlying data type if possible.
        VHDL data types must match except for std_logic and std_logic_vector.
        For assignmnents between std_logic and std_logic_vector,
        the first bit is where data is assumed to be stored.

        Parameters
        ----------
        new_signal_value : Signal
            signal being assigned to this. VHDL data types must match except for std_logic and std_logic_vector

        Returns
        -------
        str
            VHDL code to assign new_signal_value to this port
        """
        return self.signal.generate_assignment(new_signal_value)


class PortDir(Enum):
    In = "in "
    Out = "out"


class ArraySignal(Signal):
    def __init__(self, name, vhdl_type, length, element_type, element_length, element_data_type=None):
        super().__init__(name, length, None, vhdl_type)
        self.signals = [Signal(f"{self.name}({i})", element_length,
                               None, element_type, element_data_type) for i in range(length)]

    def __getitem__(self, key):
        return self.signals[key]


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

    def get_port(self, name):
        """Get entity port by name.

        Parameters
        ----------
        name : str
            Name of port to retrieve

        Returns
        -------
        Port, None
            Returns entity port with the given name if found, otherwise None.
        """
        return next((port for port in self.ports if port.name == name), None)

    def get_ports(self, *names):
        """Get ports by name.

        Returns
        -------
        list of Port
            A list of Ports found matching the names given.
        """
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
        vhdl += ");\n\n"
        return vhdl

    def _create_signal_str(self, port):
        signal = self._map.get(port)
        if signal is None:
            return "open"
        if port.length != signal.length:
            raise ValueError("Port assignments must be of equal length\n"
                             + f"Attempted assigning {signal.name} ({signal.length}) to {port.name}({port.length})")
        return signal.name


class Architecture(BaseVHDLNode):
    def __init__(self, name, entity):
        super().__init__(name)
        self.entity = entity
        self.signals = []
        self.processes = []
        self.components = []
        self.signal_assignments = {}

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
        for target, value in self.signal_assignments.items():
            vhdl += target.generate_assignment(value)
        vhdl += "\n"
        for process in self.processes:
            vhdl += process.generate()

        vhdl += "end architecture;\n"
        return vhdl

    def get_signal(self, name):
        """Get architecture signal by name.

        Parameters
        ----------
        name : str
            Name of signal to retrieve

        Returns
        -------
        Signal, None
            Returns signal with the given name if found, otherwise None.
        """
        return next((signal for signal in self.signals if signal.name == name), None)


class Process(BaseVHDLNode):
    def __init__(self, name, sensitivity_list=None, logic=""):
        super().__init__(name)
        self.sensitivity_list = sensitivity_list or []
        self.logic = logic

    def generate(self):
        """Generate a VHDL Architecture."""
        sensitivity_list_str = [
            signal.name for signal in self.sensitivity_list]
        vhdl = f"{self.name} : process({', '.join(sensitivity_list_str) })\n"
        vhdl += "begin\n"
        vhdl += self.logic
        vhdl += "end process;\n\n"
        return vhdl
