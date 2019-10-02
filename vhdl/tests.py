import unittest
import random
import math

from vgenAvalonWrapper import num_to_bitstring

class TestBitstringConversion(unittest.TestCase):

    def test_positive_int(self):
        tot_bits = 16
        frac_bits = 0
        value = 234

        # expected value computed using Mathwork's fixed-point toolbox
        expected = '0000000011101010'

        bitstring = num_to_bitstring(value, tot_bits, frac_bits)

        # remove quotes from the bitstring
        bitstring = bitstring.strip('"')

        self.assertEqual(bitstring, expected)

    def test_negative_int(self):
        tot_bits = 32
        frac_bits = 0
        value = -6437

        # expected value computed using Mathwork's fixed-point toolbox
        expected = '11111111111111111110011011011011'

        bitstring = num_to_bitstring(value, tot_bits, frac_bits)

        # remove quotes from the bitstring
        bitstring = bitstring.strip('"')

        self.assertEqual(bitstring, expected)

    # TODO: it'd be nice to test random negative integers as well, bin() doesn't do
    #       two's complement, so it would kind of be a pain
    def test_random_positive_ints(self):
        word_lengths = [random.randint(1, 32) for i in range(10000)]
        frac_bits = 0
        
        # getrandbits returns a long int, but I cast to a normal int because our values 
        # will never be larger than 32 bits
        values = [int(random.getrandbits(bits)) for bits in word_lengths]

        for tot_bits, value in zip(word_lengths, values):
            bitstring = num_to_bitstring(value, tot_bits, frac_bits)

            # remove quotes from the bitstring
            bitstring = bitstring.strip('"')

            # cast the bitstring back to an integer, then compare with the original value
            integer = int('0b' + bitstring, 2)
            self.assertEqual(integer, value)

    def test_positive_float(self):
        tot_bits = 23
        frac_bits = 12
        value = 123.987
        resolution = 2**(-frac_bits)

        bitstring = num_to_bitstring(value, tot_bits, frac_bits)
        bitstring = bitstring.strip('"')
        integer = int('0b' + bitstring, 2)
        float_result = integer * 2**(-frac_bits)

        error = math.fabs(value -float_result)
        self.assertLessEqual(error, resolution)

    def test_negative_float(self):
        tot_bits = 16
        frac_bits = 7
        value = -123.987

        # expected value computed with Mathwork's fixed-point toolbox
        expected = '1100001000000010'

        bitstring = num_to_bitstring(value, tot_bits, frac_bits)
        bitstring = bitstring.strip('"')

        self.assertEqual(expected, bitstring)

    def test_random_positive_floats(self):
        tot_bits = 32

        # max value is arbitrary
        max_value = 2**(tot_bits/2) 

        frac_lengths = [random.randint(1, 31) for i in range(10000)]
        values = [max_value * random.random() for i in range(10000)]

        for frac_bits, value in zip(frac_lengths, values):
            resolution = 2**(-frac_bits)
            bitstring = num_to_bitstring(value, tot_bits, frac_bits)
            bitstring = bitstring.strip('"')
            integer = int('0b' + bitstring, 2)
            float_result = integer * 2**(-frac_bits)

            error = math.fabs(value -float_result)
            self.assertLessEqual(error, resolution)




if __name__ == "__main__":
    unittest.main()
