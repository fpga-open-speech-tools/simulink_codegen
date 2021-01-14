from math import fabs
import collections

Register = collections.namedtuple('Register', ['name', 'data_type', 'default', 'direction'])
Audio = collections.namedtuple('Audio', ['data_type', 'channel_count', 'dual'])
DataType = collections.namedtuple(
    'DataType', ['word_len', 'frac_len', 'signed'])


def tab(number_of_tabs=1):
    return number_of_tabs * 2 * " "


def num_to_bitstring(value, tot_bits, frac_bits, surround_with=None):
    """Convert number to a fixed point binary string.

    Parameters
    ----------
    value : int
        Number to be converted
    tot_bits : int
        Total bits in the converted string
    frac_bits : int
        Number of fractional bits in the fixed point binary string

    Returns
    -------
    str
        Fixed point binary string representing value
    """
    if tot_bits == 1 and surround_with is None:
        return f"'{value}'"

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
    bitstring = '{0}'.format(bitstring)
    if surround_with is None:
        bitstring = f"\"{bitstring}\""
    else:
        bitstring = f"{surround_with}{bitstring}{surround_with}"

    return bitstring
