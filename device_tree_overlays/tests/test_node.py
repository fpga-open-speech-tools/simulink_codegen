import unittest

from dtogen.node import Node


# TODO: add more tests to test the constructor (e.g. add children/parents in the constructor)
class TestNode(unittest.TestCase):
    def setUp(self):
        self.parent = Node(name='parent', compatible='parent')
        self.child0 = Node(name='child', label='child0', compatible='child')
        self.child1 = Node(name='child', label='child1', compatible='child')

    def test_top_level_node(self):
        expected = (
            '&parent {\n'
            '    compatible = "parent";\n'
            '};'
        )

        self.assertEqual(expected, str(self.parent))

    def test_one_child_node(self):
        expected = (
            '&parent {\n'
            '    compatible = "parent";\n'
            '    child0: child {\n'
            '        compatible = "child";\n'
            '    };\n'
            '};'
        )

        self.parent.children = self.child0

        self.assertEqual(expected, str(self.parent))

    def test_two_child_nodes(self):
        expected = (
            '&parent {\n'
            '    compatible = "parent";\n'
            '    child0: child {\n'
            '        compatible = "child";\n'
            '    };\n'
            '    child1: child {\n'
            '        compatible = "child";\n'
            '    };\n'
            '};'
        )

        self.parent.children = [self.child0, self.child1]

        self.assertEqual(expected, str(self.parent))

    def test_nested_child_nodes(self):
        expected = (
            '&parent {\n'
            '    compatible = "parent";\n'
            '    child0: child {\n'
            '        compatible = "child";\n'
            '        child1: child {\n'
            '            compatible = "child";\n'
            '        };\n'
            '    };\n'
            '};'
        )

        # assigning to the children property should work whether or not we make
        # a single node into a list or not
        self.parent.children = self.child0
        self.child0.children = [self.child1]

        self.assertEqual(expected, str(self.parent))

    def test_add_children(self):
        expected = (
            '&parent {\n'
            '    compatible = "parent";\n'
            '    child0: child {\n'
            '        compatible = "child";\n'
            '    };\n'
            '    child1: child {\n'
            '        compatible = "child";\n'
            '    };\n'
            '};'
        )

        self.parent.add_children(self.child0, self.child1)

        self.assertEqual(expected, str(self.parent))


if __name__ == "__main__":
    unittest.main()
