import os
def populate_additional_filesets(input_struct, additionalFilesetAbsDir):
    for filename in os.listdir(additionalFilesetAbsDir):
        if filename.endswith(".vhd") and '_avalon' not in filename and input_struct.model_abbreviation in filename:
            input_struct.additional_filesets.append(filename)