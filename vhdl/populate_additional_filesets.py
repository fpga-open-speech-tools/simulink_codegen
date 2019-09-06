import os
def populate_additional_filesets(input_struct, additionalFilesetAbsDir):
    for filename in os.listdir(additionalFilesetAbsDir):
        if filename.endswith(".vhd"):
            input_struct.additional_filesets.append(filename)
            print("added file " + filename)
