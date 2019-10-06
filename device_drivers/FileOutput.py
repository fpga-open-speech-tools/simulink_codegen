from CreateInitFunctionFile import CreateInitFunction
from CreateFileHeaderInfo import CreateFileHeaderInfo
from CreateFunctionPrototypes import CreateFunctionPrototypes
from CreateCFunctionStubs import CreateCFunctionStubs
from CreateMiscTopOfFileStuff import CreateMiscTopOfFile
from CreateDeviceAttrMacros import WriteDeviceAttributes
from CreateDriverStuff import CreateDriverStuff
from CreateProbeFunction import CreateProbeFunction
from CreateReadAndWriteFuncs import CreateAttrReadWriteFuncs
from CreateCustomFunctions import CreateCustomFunctions
from CreateEndOfFileStuff import CreateEndOfFileStuff
from CreateRemoveFunction import CreateRemoveFunction
from CreateExitFunction import CreateExitFunction
import os.path
from time import strftime


def WriteDriver(fileName, inputParams):
    timeString = strftime("%Y-%m-%d %H:%M")
    inputParams.currTime = timeString

    output = open(fileName, "w")
    output.write(  CreateFileHeaderInfo(inputParams)      )
    output.write(  CreateMiscTopOfFile(inputParams)       )
    output.write(  CreateFunctionPrototypes(inputParams)  )
    output.write(  WriteDeviceAttributes(inputParams)     )
    output.write(  CreateDriverStuff(inputParams)         )
    output.write(  CreateInitFunction(inputParams)        )
    output.write(  CreateProbeFunction(inputParams)       )
    output.write(  CreateAttrReadWriteFuncs(inputParams)  )
    output.write(  CreateCFunctionStubs(inputParams)      )
    output.write(  CreateRemoveFunction(inputParams)      )
    output.write(  CreateExitFunction(inputParams)        )
    output.write(  CreateCustomFunctions(inputParams)     )
    output.write(  CreateEndOfFileStuff(inputParams)      )

    print("Keep in mind custom_functions.h should be included when you compile the driver.")
