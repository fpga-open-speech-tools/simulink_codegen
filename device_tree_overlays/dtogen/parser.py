
import xml.etree.ElementTree as ET

from .node import *

def parse(sopc_file):
    """Parse device tree nodes from the given file.

    Parameters
    ----------
    sopc_file : str
        sopcinfo file name, ex. 'soc_system.sopcinfo'

    Returns
    -------
    list of Node
        Returns a list of the root nodes in the device tree
    """
    tree = ET.parse(sopc_file)
    root = tree.getroot()
    
    bridges_root = root.find('./module/assignment[value="bridge"]/..')
    bridge_nodes, bridges = parse_bridges(root, bridges_root)
    
    sl_nodes = parse_autogen_nodes(root, bridges)
    for node in sl_nodes:
        bridge_nodes[node.index].add_children(node)
    
    return [BridgeRootNode(bridges_root.attrib["name"], bridges_root.attrib["name"], children=bridge_nodes)]

def parse_autogen_nodes(root, bridges):
    """Parse the Autogen nodes under the bridges from the sopcinfo file.

    Parameters
    ----------
    root : Element
        Root element of the sopcinfo file
    bridges : dict
        Dictionary containing bridge indices and internal links from the bridge
        name the sl nodes are attached to and the actual bridges

    Returns
    -------
    list of MemoryMappedSlaveNode
        List of the Autogen nodes found under the bridges as Device Tree Nodes
    """
    autogen_nodes = root.findall('./module/assignment[name="embeddedsw.dts.group"][value="autogen"]/..')
    
    nodes = []
    for node in autogen_nodes:
        primary_compatible = f"fe,{node.attrib['kind']}-{node.attrib['version']}"
        secondary_compatible = node.findtext('./assignment[name="embeddedsw.dts.compatible"]/value')
        compatible = f"\"{primary_compatible}\", \"{secondary_compatible}\""
        
        address_span_bits = node.findtext('./interface[@name="avalon_slave"]/parameter[@name="addressSpan"]/value')
        avalon_connection = root.find('./connection[@kind="avalon"][endModule="' + node.attrib["name"] + '"]')

        base_address = avalon_connection.findtext('./parameter[@name="baseAddress"]/value')
        
        bridge = avalon_connection.findtext('./startConnectionPoint')
        link = bridges[bridge]
        bridge_info = bridges[link]
        
        nodes.append(MemoryMappedSlaveNode(label=node.attrib["name"], name=node.attrib["kind"], base_addr=int(base_address, 0), \
            span=int(address_span_bits), index=bridge_info[0], compatible=compatible\
            ))
    return nodes

def parse_bridges(root, bridges_root):
    """Parse the bridges found under the root bridges node.

    Parameters
    ----------
    root : Element
        Root element of the sopcinfo file
    bridges_root : Element
        The root bridges node that contains the bridges in the sopcinfo file

    Returns
    -------
    (list of MemoryBridgeNode, dict)
        Returns a tuple containing a list of parsed bridge nodes and a dictionary containing info on the bridges
    """
    bridges_xml = bridges_root.findall('./interface[@kind="altera_axi_slave"]')
    bridges = {}
    bridge_counter = 0
    bridge_nodes = []

    for bridge in bridges_xml:
        span = bridge.findtext("./assignment[name='addressSpan']/value")

        if span is None:
            continue
        memoryblock = root.find(f".//memoryBlock[moduleName='{bridges_root.attrib['name']}'][slaveName='{bridge.attrib['name']}']")
        if memoryblock is None:
            continue
        base = memoryblock.findtext('baseAddress')
        
        bridge_link = bridge.attrib["name"].split("_", 1)[1]
        bridges[bridge_link] = bridge.attrib["name"]
        bridges[bridge.attrib["name"]] = [bridge_counter, base]
        
        bridge_nodes.append(MemoryBridgeNode(bridge.attrib["name"], base_addr=int(base), span=int(span), index=bridge_counter, label=bridge.attrib["name"]))
        bridge_counter += 1

    return (bridge_nodes, bridges)