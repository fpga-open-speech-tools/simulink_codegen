from abc import ABC, abstractmethod


class AbstractNode(ABC):
    """Abstract base class for representing device tree nodes
    """
    def __init__(self, name, label=None, parent=None, children=[]):
        """Creates a device tree node

        Parameters
        ----------
        name : str
            Name of the node
        label : str, optional
            Label for this node in the device tree, by default None
        parent : Node, optional
            The parent of this node in the device tree, by default None
        children : list of Node, optional
            The children of this node in the device tree, by default []
        
        """
        self.name = name
        self.label = label
        self.parent = parent
        self._default_format = True
        self.tab = True
        self._children = []
        if children:
            # make sure children is a list
            if not isinstance(children, list):
                children = [children]

            self.add_children(*children)

    @property
    def children(self):
        return self._children

    @children.setter
    def children(self, children):
        # we are overwriting the children list, so start with an empty list
        self._children = []

        # make sure children is a list
        if not isinstance(children, list):
            children = [children]

        self.add_children(*children)

    # NOTE: instead of having this method, we could instead make users call device_tree_node.children.append(); I'm not sure which way is preferable.
    def add_children(self, *args):
        """Adds child nodes to this node

        Raises
        ------
        TypeError
            Raises if the inputs are not an instance of an AbstractNode
        """
        for child in args:
            if isinstance(child, AbstractNode):
                child.parent = self
                self._children.append(child)
            else:
                raise TypeError("child is not a device tree node object")

    @abstractmethod
    def _print_properties(self):
        """Describes how the properties of the node should be printed in a device tree

        Returns
        -------
        str
            String representation of the properties of the node in the device tree
        """
        return NotImplemented

    def __str__(self):
        s = ''

        # XXX: maybe we could handle the base device tree references in a cleaner way than just checking if the node doesn't have a parent. Just because a node doesn't have a parent doesn't mean that the node is being inserted at a label in the base device tree. The node could need to be inserted into the root of the base device tree, for example.
        if isinstance(self.parent, DeviceTreeRootNode):
            # if the node doesn't have a parent, reference a base device tree label for tree insertion

            # TODO: name is a required argument, so I'm using it for the label here, but maybe it would make more sense to use label instead? But labels aren't required in general.
            s += '&' + self.name + ' {\n'
        else:
            # if the node has a parent, we don't need to reference a label in the base device tree
            if self._default_format:
                if self.label is not None:
                    s += self.label + ': '
                s += self.name + ' {\n'

        s += self._print_properties()
        for child in self._children:
            s += self.add_tab()  + str(child).replace('\n', '\n' + self.add_tab() ) + '\n'
        if self._default_format:
            s += '};'

        return s

    @staticmethod
    def hex(__i, length = 8):
        """Converts an integer to a hex string with padded 0's as needed

        Parameters
        ----------
        __i : int
            An integer to be converted to a hex string
        length : int, optional
            the number of digits in the hex string, by default 8

        Returns
        -------
        str
            Hex string of __i with padded 0's to ensure at least length digits
        """
        hex_str = hex(__i)[2:]
        padding = (8-len(hex_str)) * '0'
        return f"0x{padding}{hex_str}"

    def add_tab(self):
        """Returns a tab if the node is configured to include it in it's formatting

        Returns
        -------
        str
            Returns a tab if self.tab is True, otherwise empty string
        """
        if(self.tab):
            return '\t'
        return ''

class Node(AbstractNode):
    """Base class for representing device tree nodes
    """
    def __init__(self, name, label=None, parent=None,
                 children=[], compatible=None):
        """Creates a device tree node

        Parameters
        ----------
        name : str
            Name of the node
        label : str, optional
            Label for this node in the device tree, by default None
        parent : Node, optional
            The parent of this node in the device tree, by default None
        children : list of Node, optional
            The children of this node in the device tree, by default []
        compatible : str, optional
            Describes compatible drivers with device tree node, by default None
        """
        super().__init__(name=name, label=label, parent=parent, children=children)

        self.compatible = compatible
    
    
    def _print_properties(self):
        s = ''
        if self.compatible is not None:
            # TODO: make tab size a variable
            s += self.add_tab() + 'compatible = "{}";\n'.format(self.compatible)

        return s


class FpgaRegionNode(Node):
    """ Represents an FPGA region in the device tree
    """
    def __init__(self, name, firmware_name, label=None,
                 children=[], compatible=None, status=None):
        """Creates an FPGA Region device tree node

        Parameters
        ----------
        name : str
            Name of the node
        firmware_name : str
            Name of the firmware file to load for the fpga region
        label : str, optional
            Label for this node in the device tree, by default None
        children : list of Node, optional
            The children of this node in the device tree, by default []
        compatible : str, optional
            Describes compatible drivers with device tree node, by default None
        status : str, optional
            Status to set the Node to, by default None
        """
        super().__init__(name, label=label, children=children, compatible=compatible)
        self.firmware_name = firmware_name
        self.status = status

    def _print_properties(self):
        s = ''
        s += super()._print_properties()
        s += self.add_tab() + 'firmware-name = "{}";\n'.format(self.firmware_name)
        #if self.status is not None:
        #    s += self.add_tab() + 'status = "{}";\n'.format(self.status)

        return s

class MemoryMappedNode(Node):
    """Base class for memory mapped nodes in the device tree
    """
    def __init__(self, name, base_addr, span, label=None, parent=None,
                 children=None, compatible=None):
        """Creates a Memory Mapped device tree node

        Parameters
        ----------
        name : str
            Name of the node
        base_addr : int
            Base address of the node
        span : int
            Amount of memory for this node
        label : str, optional
            Label for this node in the device tree, by default None
        parent : Node, optional
            The parent of this node in the device tree, by default None
        children : list of Node, optional
            The children of this node in the device tree, by default []
        compatible : str, optional
            Describes compatible drivers with device tree node, by default None
        """
        super().__init__(name, label=label, parent=parent, children=children, compatible=compatible)
        self.base_addr = base_addr
        self.span = span

class MemoryBridgeNode(MemoryMappedNode):
    """Represents an fpga bridge in the device tree
    """
    def __init__(self, name, base_addr, span, index=None, label=None, parent=None,
                 children=None, compatible=None):
        """Creates an FPGA bridge device tree node

        Parameters
        ----------
        name : str
            Name of the node
        base_addr : int
            Base address of the node
        span : int
            Amount of memory for this node
        index : int, optional
            Index of the bridge in the list of FPGA bridges in the parent node, by default None
        label : str, optional
            Label for this node in the device tree, by default None
        parent : Node, optional
            The parent of this node in the device tree, by default None
        children : list of Node, optional
            The children of this node in the device tree, by default []
        compatible : str, optional
            Describes compatible drivers with device tree node, by default None
        """
        super().__init__(name, base_addr, span, label=label, parent=parent, children=children, compatible=compatible)
        self.index = index
        self._default_format = False
        self.tab = False

    def _print_properties(self):
        return ''

class MemoryMappedSlaveNode(MemoryMappedNode):
    """Represents a memory mapped slave node in the device tree
    """
    def __init__(self, name, base_addr, span, index=None, label=None, parent=None,
                 children=None, compatible=''):
        """Creates an memory mapped slave device tree node

        Parameters
        ----------
        name : str
            Name of the node
        base_addr : int
            Base address of the node
        span : int
            Amount of memory for this node
        index : int, optional
            Index of the parent bridge, by default None
        label : str, optional
            Label for this node in the device tree, by default None
        parent : Node, optional
            The parent of this node in the device tree, by default None
        children : list of Node, optional
            The children of this node in the device tree, by default []
        compatible : str, optional
            Describes compatible drivers with device tree node, by default None
        """
        super().__init__('', base_addr, span, label=label, parent=parent, children=children, compatible=compatible)
        self.index = index

        base_addr_str = self.hex(self.base_addr)[2:]
        self._name = name
        self.name = f"{self._name}@{self.index or ''}{base_addr_str}"
    def _print_properties(self):
        s = ""
        s += f"{self.add_tab() }compatible = {self.compatible};\n"
        s += f"{self.add_tab() }reg = <{self.hex(self.index)} {self.hex(self.base_addr)} {self.hex(self.span)}>;\n"
        return s
class BridgeRootNode(Node):
    """Represents the root bridges node that fpga bridges children are under in the device tree
    """
    def __init__(self, name, label=None, parent=None, children=[], compatible=None):
        """Creates the root bridges node that contains the bridges underneath it

        Parameters
        ----------
        name : str
            Name of the node
        label : str, optional
            Label for this node in the device tree, by default None
        parent : Node, optional
            The parent of this node in the device tree, by default None
        children : list of Node, optional
            The children of this node in the device tree, by default []
        compatible : str, optional
            Describes compatible drivers with device tree node, by default None
        """
        super().__init__(name, label=label, children=children, compatible=compatible)
        self._default_format = False
        self.tab = False

    def _print_properties(self):
        s = '\n'
        # This specifies reg values in children will be with the bridge number
        # and the untranslated base address 
        s += self.add_tab()  +'#address-cells = <2>;\n'
        # A single value will be given for the span of the register on children
        s += self.add_tab()  +'#size-cells = <1>;\n'

        s += self.add_tab()  +'ranges = '
        for i in range(len(self.children)):
            bridge = self.children[i]
            # XXX: Not sure if this is necessary, it adds the bridge itself if it has no children
            if len(bridge.children) == 0:
                s += f"< {self.hex(bridge.index)} {self.hex(0)} {self.hex(bridge.base_addr)} {self.hex(bridge.span)}>"
                if (i == len(self.children) - 1):
                    s += ';\n'
                else:
                    s += ',\n' + self.add_tab()  * 2 
            for j in range(len(bridge.children)):
                child = bridge.children[j]
                s += '<' + self.hex(bridge.index) + ' '
                s += self.hex(child.base_addr) + ' '
                s += self.hex(child.base_addr + bridge.base_addr) + ' '
                s += self.hex(child.span) + '>'
                if (i == len(self.children) - 1) and (j == len(bridge.children) - 1):
                    s += ';\n'
                else:
                    s += ',\n' + self.add_tab()  * 2
        return s

    
class DeviceTreeRootNode(Node):
    """Represents the root bridges node that fpga bridges children are under in the device tree
    """
    def __init__(self, children=[]):
         super().__init__("Root", children=children)
         self._default_format = False
         self.tab = False
    def _print_properties(self):
        s = '/dts-v1/;\n/plugin/;\n\n'
        return s