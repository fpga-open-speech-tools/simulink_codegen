#!/usr/bin/python

# @file vgenAvalonWrapper.py
#
#     Python function to auto generate vhdl code given json generated from Simulink/Matlab
#
#     @author Trevor Vannoy, Aaron Koenigsberg
#     @date 2019
#     @copyright 2019 Flat Earth Inc
#
#     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
#     INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
#     PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
#     FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
#     ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
#     Trevor Vannoy
#     Flat Earth Inc
#     985 Technology Blvd
#     Bozeman, MT 59718
#     support@flatearthinc.com

import json
import argparse
import re
from textwrap import dedent
from math import ceil, log, fabs

# TODO: error checking

indent = '  '

def create_library():
    LIBRARIES=dedent("""\
        library ieee;
        use ieee.std_logic_1164.all;
        use ieee.numeric_std.all;\n
        """)
    return LIBRARIES

def create_entity(name, sink_enabled, sink, source_enabled, source,
    registers_enabled, registers, conduit_out_enabled, conduit_out,
    conduit_in_enabled, conduit_in):

    global indent

    ENTITY_BEGIN=dedent("""\
        entity {}_avalon is
          port (
          """.format(name))
    ENTITY_END=dedent("""\
          );
        end entity {}_avalon;\n
        """.format(name))

    entity = ENTITY_BEGIN

    entity += indent*2 + "clk".ljust(26, ' ') + ": in  std_logic;\n"
    entity += indent*2 + "reset".ljust(26, ' ') + ": in  std_logic;\n"

    # avalon streaming sink
    if sink_enabled:
        for signal in sink:
            datatype = convert_data_type(signal['data_type'])
            entity += indent*2 + (signal['name']).ljust(26, ' ') + ": in  " + datatype + "; --" +\
                signal['data_type']['type'] + '\n'


    # avalon streaming source
    if source_enabled:
        for signal in source:
            datatype = convert_data_type(signal['data_type'])
            entity += indent*2 + signal['name'].ljust(26, ' ') + ": out " + datatype + "; --" +\
                signal['data_type']['type'] + '\n'

    # avalon memorymapped bus
    if registers_enabled:
        entity += indent*2 + "avalon_slave_address".ljust(26, ' ') + ": in  std_logic_vector({} downto 0);\
            \n".format(str(int(ceil(log(len(registers),2)) - 1)).ljust(3, ' '))

        entity += indent*2 + "avalon_slave_read".ljust(26, ' ') + ": in  std_logic;\n"
        entity += indent*2 + "avalon_slave_readdata".ljust(26, ' ') + ": out std_logic_vector(31  downto 0);\n"

        entity += indent*2 + "avalon_slave_write".ljust(26, ' ') + ": in  std_logic;\n"
        entity += indent*2 + "avalon_slave_writedata".ljust(26, ' ') +": in  std_logic_vector(31  downto 0);\n"

    # input conduit signals
    if conduit_in_enabled:
        for signal in conduit_in:
            name = re.search('Export_(.*)', signal['name']).group(1)
            datatype = convert_data_type(signal['data_type'])

            entity += indent*2 + name.ljust(30, ' ') + ": in " + datatype + "; --" + \
                signal['data_type']['type'] + '\n'

    # output conduit signals
    if conduit_out_enabled:
        for signal in conduit_out:
            name = re.search('Export_(.*)', signal['name']).group(1)
            datatype = convert_data_type(signal['data_type'])

            entity += indent*2 + name.ljust(26, ' ') + ": out " + datatype + "; --" + \
                signal['data_type']['type'] + '\n'

    # remove the semicolon from the last entity port definition
    semicolon_idx = entity.rfind(';')
    entity = entity[:semicolon_idx] + entity[semicolon_idx+1:]

    entity += ENTITY_END

    return entity

def create_architecture(name, registers_enabled, registers, register_defaults,
    component_declaration, component_instantiation, clock,
    sink_flag, sink_signal, mm_flag, mm_signal, ci_flag, ci_signal, source_flag, source_signal, co_flag, co_signal):
    global indent

    ARCH_BEGIN = "architecture {}_avalon_arch of {}_avalon is\n\n".format(name, name)
    ARCH_END = "end architecture;"

    architecture = ARCH_BEGIN

    if registers_enabled:
        # sort registers according to register number
        registers = sorted(registers, key=lambda k: k['reg_num'])

        # declare register signals
        (register_defaults, data_widths) = create_component_reg_defaults(mm_flag, mm_signal)
        for register, data_width in zip(register_defaults, data_widths):
            if data_width == 1:
                architecture += indent + "signal " + register.replace('<=',
                ': std_logic :=') + "\n"
            else:
                architecture += indent + "signal " + register.replace('<=',
                ': std_logic_vector({}  downto 0) :='.format(data_width-1)) + "\n"



    architecture += "\n"
    architecture += create_component_declaration2(clock=clock, entity=name, sink_flag=sink_flag, sink_signal=sink_signal,
                            mm_flag=mm_flag, mm_signal=mm_signal, ci_flag=ci_flag, ci_signal=ci_signal,
                            source_flag=source_flag, source_signal=source_signal, co_flag=co_flag, co_signal=co_signal)

    # begin architecture
    architecture += "\nbegin\n\n"

    architecture += create_component_instantiation2(ts_system=clock, entity=name, sink_flag=sink_flag, sink_signal=sink_signal,
                            mm_flag=mm_flag, mm_signal=mm_signal, ci_flag=ci_flag, ci_signal=ci_signal,
                            source_flag=source_flag, source_signal=source_signal, co_flag=co_flag, co_signal=co_signal)

    architecture += "\n"

    if registers_enabled:
        addr_width = int(ceil(log(len(registers),2)))

        # create read process
        architecture += indent + "bus_read : process(clk)\n" + indent + "begin\n"
        architecture += indent*2 + "if rising_edge(clk) and avalon_slave_read = '1' then\n"
        architecture += indent*3 + "case avalon_slave_address is\n"

        for register, data_width in zip(registers, data_widths):
            if data_width == 1:
                value = "(31 downto 1 => '0') & {0}".format(register['name'])
            elif data_width != 32:
                if 'sfix' in register['data_type']:
                    value = '(31 downto {0} => {2}({1})) & {2}'.format(data_width, data_width-1, register['name'])
                else:
                    value = '(31 downto {0} => \'0\') & {1}'.format(data_width, register['name'])
            else:
                value = register['name']

            architecture += indent*4 + \
                "when \"{0:0{1}b}\" => avalon_slave_readdata <= {2};\n".format(register['reg_num'],\
                addr_width, value)

        architecture += indent*4 + "when others => avalon_slave_readdata <= (others => '0');\n"
        architecture += indent*3 + "end case;\n" + indent*2 + "end if;\n" + \
            indent + "end process;\n\n"

        # create write process
        architecture += indent + "bus_write : process(clk, reset)\n" + indent + "begin\n"
        architecture += indent*2 + "if reset = '1' then\n"

        for reg in register_defaults:
            architecture += indent * 3 + reg + "\n"

        architecture += indent*2 + "elsif rising_edge(clk) and " + \
            "avalon_slave_write = '1' then\n"
        architecture += indent*3 + "case avalon_slave_address is\n"

        for register, data_width in zip(registers, data_widths):
            if data_width == 1:
                architecture += indent*4 + \
                    "when \"{0:0{1}b}\" => {2} <= avalon_slave_writedata(0);\n".format(
                        register['reg_num'], addr_width, register['name']) 
            else:
                architecture += indent*4 + \
                    "when \"{0:0{1}b}\" => {2} <= avalon_slave_writedata({3} downto 0);\n".format(
                        register['reg_num'], addr_width, register['name'], data_width-1) 

        architecture += indent*4 + "when others => null;\n"
        architecture += indent*3 + "end case;\n" + indent*2 + "end if;\n" + \
            indent + "end process;\n\n"

    architecture += ARCH_END

    return architecture

# TODO: rename this to create_datatype_string? 
def convert_data_type(typedict):
    # TODO: add support for more data types (e.g. integer, signed, unsigned)?
    if typedict['type'] in {'boolean', 'ufix1'}:
        typestr = 'std_logic'
    else:
        typestr = 'std_logic_vector({} downto 0)'.format(str(typedict['width']-1).ljust(3, ' '))
    return typestr

def num_to_bitstring(value, tot_bits, frac_bits):
    # make value positive, then take the two's complement later if value is supposed to be negative
    is_negative = value < 0
    value = fabs(value)

    # Get rid of the binary point by shifting the value left by frac_bits.
    # The value must be an int to be converted to a binary string.
    # The bits in this new value are the closest possible representation
    # to the original floating point value
    value = int(round(2**frac_bits * value))

    if is_negative:
        # take the two's complement; this also handles the sign extension    
        toggle_mask = 2**tot_bits - 1
        value ^= toggle_mask
        value += 1

    # [2:] removes '0b' from the binary string
    bitstring = bin(value)[2:]

    if not is_negative:
        # sign extend with 0's
        bitstring = bitstring.rjust(tot_bits, "0")

    # wrap the string in quotes
    bitstring = '"{0}"'.format(bitstring)

    return bitstring


def create_component_declaration2(clock, entity, sink_flag, sink_signal, mm_flag, mm_signal, ci_flag, ci_signal, source_flag, source_signal, co_flag, co_signal):
    global indent
    decl = "component " + entity + "\n"
    decl += indent * 1 + "port(\n"
    decl += indent * 2 + "clk".ljust(28, ' ') + ": in  std_logic; -- clk_freq = " + str(clock['frequency']) + " Hz, period = " + str(clock['period']) + "\n"
    decl += indent * 2 + "reset".ljust(28, ' ') + ": in  std_logic;\n"
    decl += indent * 2 + "clk_enable".ljust(28, ' ') + ": in  std_logic;\n"
    if sink_flag == 1:
        for i in range(len(sink_signal)):
            name = sink_signal[i]["name"]
            data_type = sink_signal[i]["data_type"]
            decl += (indent * 2 + name).ljust(32, ' ') + (": in  " + convert_data_type(data_type) + ";").ljust(45, ' ') + " -- " + data_type['type'] + "\n"
    if mm_flag == 1:
        for i in range(len(mm_signal)):
            # the vhdl that matlab generates has register_control prefixed to each register name, so we need to do the same
            name = "register_control_" + mm_signal[i]["name"]
            data_type = mm_signal[i]["data_type"]
            decl += (indent * 2 + name).ljust(32, ' ') + (": in  " + convert_data_type(data_type) + ";").ljust(45, ' ') + " -- " + data_type['type'] + "\n"
    if ci_flag == 1:
        for i in range(len(ci_signal)):
            name = ci_signal[i]["name"]
            data_type = ci_signal[i]["data_type"]
            decl += (indent * 2 + name).ljust(32, ' ') + (": in  " + convert_data_type(data_type) + ";").ljust(45, ' ') + " -- " + data_type['type'] + "\n"
    decl += (indent * 2 + "ce_out").ljust(32, ' ') + ": out std_logic;\n"
    if source_flag == 1:
        for i in range(len(source_signal)):
            name = source_signal[i]["name"]
            data_type = source_signal[i]["data_type"]
            decl += (indent * 2 + name).ljust(32, ' ') + (": out " + convert_data_type(data_type) + ";").ljust(45, ' ') + " -- " + data_type['type'] + "\n"
    if co_flag == 1:
        for i in range(len(co_signal)):
            name = co_signal[i]["name"]
            data_type = co_signal[i]["data_type"]
            decl += (indent * 2 + name).ljust(32, ' ') + (": out " + convert_data_type(data_type) + ";").ljust(45, ' ') + " -- " + data_type['type'] + "\n"
    last_semi_ind = decl.rfind(";")
    decl = decl[:last_semi_ind] + ' ' + decl[last_semi_ind + 1:]
    decl += indent * 1 + ");\n"
    decl += "end component;\n"
    return decl

def create_component_instantiation2(ts_system, entity, sink_flag, sink_signal, mm_flag, mm_signal, ci_flag, ci_signal, source_flag, source_signal, co_flag, co_signal):
    global indent
    inst = "u_" + entity + " : " + entity + "\n"
    inst += indent * 1 + "port map(\n"
    inst += (indent * 2 + "clk").ljust(32, ' ') + "=>  clk,\n"
    inst += (indent * 2 + "reset").ljust(32, ' ') + "=>  reset,\n"
    inst += (indent * 2 + "clk_enable").ljust(32, ' ') + "=>  '1',\n"
    if sink_flag == 1:
        for i in range(len(sink_signal)):
            name = sink_signal[i]["name"]
            data_type = sink_signal[i]["data_type"]
            inst += (indent * 2 + name).ljust(32, ' ') + "=>  " + (name + ",").ljust(32, ' ') + " -- " + data_type['type'] + "\n"
    if mm_flag == 1:
        for i in range(len(mm_signal)):
            name = "register_control_" + mm_signal[i]["name"]
            name2 = mm_signal[i]["name"]
            data_type = mm_signal[i]["data_type"]
            inst += (indent * 2 + name).ljust(32, ' ') + "=>  " + (name2 + ",").ljust(32, ' ') + " -- " + data_type['type'] + "\n"
    if ci_flag == 1:
        for i in range(len(ci_signal)):
            name = ci_signal[i]["name"]
            name2 = name.replace("Export_", "")
            data_type = ci_signal[i]["data_type"]
            inst += (indent * 2 + name).ljust(32, ' ') + "=>  " + (name2 + ",").ljust(32, ' ') + " -- " + data_type['type'] + "\n"
    if source_flag == 1:
        for i in range(len(source_signal)):
            name = source_signal[i]["name"]
            data_type = source_signal[i]["data_type"]
            inst += (indent * 2 + name).ljust(32, ' ') + "=>  " + (name + ",").ljust(32, ' ') + " -- " + data_type['type'] + "\n"
    if co_flag == 1:
        for i in range(len(co_signal)):
            name = co_signal[i]["name"]
            name2 = name.replace("Export_", "")
            data_type = co_signal[i]["data_type"]
            inst += (indent * 2 + name).ljust(32, ' ') + "=>  " + (name2 + ",").ljust(32, ' ') + " -- " + data_type['type'] + "\n"
    last_comma_ind = inst.rfind(',')
    inst = inst[:last_comma_ind] + ' ' + inst[last_comma_ind + 1:]
    inst += indent * 1 + ");\n"
    return inst


def create_component_reg_defaults(mm_flag, mm_signal):
    reg_defs = []
    data_widths = []

    if mm_flag == 1:
        for i in range(len(mm_signal)):
            name = mm_signal[i]["name"]
            name2 = name.replace("Register_Control_", "")
            def_val = mm_signal[i]["default_value"]
            datatype = mm_signal[i]["data_type"]
            typestr = datatype['type']

            (value_str, data_width) = convert_default_value(def_val, datatype)
            reg_defs.append(name2.ljust(24, ' ') + "  <=  " + value_str +
                "; -- " + str(def_val) + " (" + typestr + ")") 
            data_widths.append(data_width)

    return (reg_defs, data_widths)


def convert_default_value(value, datatype):
    is_int = False
    is_bool = False
    data_width = 32

    if datatype['type'] == 'boolean':
        is_bool = True
        data_width = 1
    else:
        data_width = datatype['width']
        frac_width = datatype['fractional_bits']

    # create the default value string
    if is_int:
        value_str = "std_logic_vector(to_unsigned({}, {}))".format(value, data_width)
    elif is_bool:
        value_str = "'{}'".format(value)
    else:
        value_str = num_to_bitstring(value, data_width, frac_width)

    return (value_str, data_width)


def parseargs():
    parser = argparse.ArgumentParser(description=\
        "Generate VHDL code for Avalon streaming and memory-mapped interfaces.")
    parser.add_argument('infile',
        help="json file containing the interface and register specifications")
    parser.add_argument('-v', '--verbose', action='store_true',
        help="verbose output")
    parser.add_argument('-p', '--print', action='store_true', dest='print_output',
        help="print out the generated vhdl code")
    parser.add_argument('outfile', help="the name of the output vhdl file")
    args = parser.parse_args()
    return (args.infile, args.outfile, args.verbose, args.print_output)


# TODO: make a default filename?
def main(infile, outfile, verbose, print_output):
    with open(infile) as f:
        avalon = json.load(f)

    name = avalon['entity']
    sink_enabled = avalon['avalon_sink_flag']
    sink = avalon['avalon_sink']['signal'] if sink_enabled else None
    source_enabled = avalon['avalon_source_flag']
    source = avalon['avalon_source']['signal'] if source_enabled else None
    registers_enabled = avalon['avalon_memorymapped_flag']
    registers = avalon['avalon_memorymapped']['register'] if registers_enabled else None
    conduit_in_enabled = avalon['conduit_input_flag']
    conduit_in = avalon['conduit_input']['signal'] if conduit_in_enabled else None
    conduit_out_enabled = avalon['conduit_output_flag']
    conduit_out = avalon['conduit_output']['signal'] if conduit_out_enabled else None
    register_defaults = None#avalon['vhdl']['register_defaults']
    component_declaration = None#avalon['vhdl']['component_declaration']
    component_instantiation = None#avalon['vhdl']['component_instantiation']
    clock = {'frequency': 1, 'period': .1}#avalon['clock']


    vhdl_out = create_library()
    vhdl_out += create_entity(name=name, sink_enabled=sink_enabled, sink=sink, source_enabled=source_enabled, source=source,
        registers_enabled=registers_enabled, registers=registers, conduit_out_enabled=conduit_out_enabled,
        conduit_out=conduit_out, conduit_in_enabled=conduit_in_enabled, conduit_in=conduit_in)
    vhdl_out += create_architecture(name, registers_enabled, registers,
        register_defaults, component_declaration, component_instantiation, clock=clock, sink_flag=sink_enabled, sink_signal=sink,
        source_flag=source_enabled, source_signal=source, mm_flag=registers_enabled, mm_signal=registers,
        co_flag=conduit_out_enabled, co_signal=conduit_out, ci_flag=conduit_in_enabled,
        ci_signal=conduit_in)

    if print_output:
        print(vhdl_out)

    with open(outfile, 'w') as f:
        f.write(vhdl_out)

if __name__ == '__main__':
    (infile, outfile, verbose, print_output) = parseargs()
    main(infile, outfile, verbose, print_output)
