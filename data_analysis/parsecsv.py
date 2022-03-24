from ast import Not
# from asyncio.windows_events import NULL
import csv
import hashlib
from random import random

# Reads data from .csv file, including only wanted columns
def ParseData(filePath, validColumns, columnHeaders):
    # First set of data will need to have column headers
    # Following sets will not
    if(columnHeaders == False):
        parsedText = []
    else:
        parsedText = columnHeaders

    y = 0

    with open(filePath, newline='') as csvfile:
        file = csv.reader(csvfile, dialect='excel')
        for row in file:
            x = 0
            temp = []
            for word in row:
                # y != 0 to ignore .csv headers in favour of custom headers
                if (y != 0):
                    # Ignore any columns we don't want results from
                    if(x in validColumns):
                        temp.append(word)

                x += 1

            # y != 0 to ignore .csv headers in favour of custom headers
            if (y != 0):
                parsedText.append(temp)
            y += 1

    return parsedText

# Test function to strip all data from a .csv, regardless of wanted columns
def SimpleParse(filePath):
    y = 0
    parsedText = []
    with open(filePath, newline='') as csvfile:
        file = csv.reader(csvfile, dialect='excel')
        for row in file:
            temp = []
            for word in row:
                if (y != 0):
                    temp.append(word)
            if(y >= 1):
                parsedText.append(temp)
            y += 1

    return parsedText


def WriteDataToOutputFile(filepath, data):
    with open(filepath, 'w') as outputFile:
        writer = csv.writer(outputFile)
        writer.writerows(data)

    return 0


# Hash email to obfuscate it but keep entries by the same person related
def HashColumn(data, columnIndex):
    y = 0
    for row in data:
        if (y != 0):
            row[columnIndex] = hashlib.sha1(
                row[columnIndex].encode('utf-8')).hexdigest()
        y += 1

    return data

# Marks whether data has come from an experimental or control group
def MarkDataAsExperimental(isExperimental, data, header):
    if (header == False):
        start = 0
    else:
        data[0].insert(0, header)
        start = 1
    for i in range(start, len(data)):
        data[i].insert(0, isExperimental)

    return data


def CombineData(dataA, dataB):
    return dataA + dataB

# Uses generated lookup table to assign each participant to the correct team
def SetTeams(data, header):
    data[0].insert(1, header)
    for i in range(1, len(data)):
        hasSetValue = False
        for j in range(0, len(teamLookupTable)):
            for k in range(1, len(teamLookupTable[j])):
                if (data[i][1] == teamLookupTable[j][k]):
                    hasSetValue = True
                    data[i].insert(1, teamLookupTable[j][0])

                if(hasSetValue): break
            
            if (hasSetValue): break

            if (j == len(teamLookupTable)-1):
                print("ERROR: " + data[i][1] + " not present in teamLookupTable. Assigning random value for " + header)
                data[i].insert(1, str(random()))

    return data

# Reads data from experimental .csv file & control .csv file
# Then marks them as experimental or control
# Then outputs the data to another file
def CreateParsedSupervisorData(controlDataPath, experimentalDataPath, outputDataPath):
    validColumns = [3, 10, 16]
    columnHeaders = [['id', 'buildConfidence', 'scopeConfidence']]

    experimentalSupervisorData = ParseData(
        experimentalDataPath, validColumns, columnHeaders)

    experimentalSupervisorData = MarkDataAsExperimental(
        True, experimentalSupervisorData, 'isExperimental')

    validColumns = [3, 10, 16]
    columnHeaders = False

    controlSupervisorData = ParseData(
        controlDataPath, validColumns, columnHeaders)

    controlSupervisorData = MarkDataAsExperimental(
        False, controlSupervisorData, False)

    combined = CombineData(experimentalSupervisorData, controlSupervisorData)
    combined = SetTeams(combined, 'team')
    combined = HashColumn(combined, 1)
    combined = HashColumn(combined, 2)

    WriteDataToOutputFile(outputDataPath, combined)

def GenerateLookupTable(filePath):
    parsedData = SimpleParse(filePath)
    return parsedData

# Maps a verbose value in a specific column to a numeric value.
# This is needed for the data analysis in R.
def ConvertVerboseToNumeric(data, columnIndex, verboseArray):
    y = 0
    entryConverted = True
    for row in data:
        if (y != 0):
            entryConverted = False
            for i in range(0, len(verboseArray)):
                if (row[columnIndex] == verboseArray[i]):
                    row[columnIndex] = i
                    entryConverted = True
                    i = len(verboseArray)
        if (not entryConverted):
            print("Error: Verbose entry " + row[columnIndex] + " had no equivalent in verboseArray")
        y += 1

    return data

# Parses student data, only data relevant to the R data analysis is included in the output file.
def CreateParsedStudentData(controlDataPath, experimentalDataPath, outputDataPath):
    # Defines columns to be included in the output file
    validColumns = [3, 10, 16, 22, 25, 28]
    columnHeaders = [['id', 'scopeConfidence', 'stateUnderstanding', 'contributionUnderstanding', 'scopeFrequency', 'playtestFrequency']]
    
    experimentalData = ParseData(experimentalDataPath, validColumns, columnHeaders)

    experimentalData = MarkDataAsExperimental(
    True, experimentalData, 'isExperimental')

    # Defines columns to be included in the output file
    validColumns = [3, 10, 16, 22, 25, 28]
    columnHeaders = False

    controlData = ParseData(
        controlDataPath, validColumns, columnHeaders)

    controlData = MarkDataAsExperimental(
        False, controlData, False)

    combined = CombineData(experimentalData, controlData)
    combined = ConvertVerboseToNumeric(combined, 5, ['Once a semester\n', 'Every other sprint\n', 'Once per sprint\n', 'Multiple times per sprint\n'])
    combined = ConvertVerboseToNumeric(
        combined, 6, ['Only at events (Demo day etc.)\n', 'Every other sprint\n', 'Once per sprint\n', 'Multiple times per sprint\n'])
    combined = SetTeams(combined, 'team')
    combined = HashColumn(combined, 1)
    combined = HashColumn(combined, 2)

    WriteDataToOutputFile(outputDataPath, combined)

def ParseStudentData():
    # Generates a lookup table, mapping individual participants to their team
    global teamLookupTable 
    teamLookupTable  = GenerateLookupTable('Participants.csv')

    # Set file path's
    controlDataPath = 'Dissertation Survey - Student Version N.csv'
    experimentalDataPath = 'Dissertation Survey - Student Version P.csv'
    outputDataPath = 'parsed_student_results.csv'
    CreateParsedStudentData(
        controlDataPath, experimentalDataPath, outputDataPath)

def ParseTestData():
    # Generates a lookup table, mapping individual participants to their team.
    global teamLookupTable 
    teamLookupTable = GenerateLookupTable('testparticipants.csv')

    # Set file path's
    controlDataPath = 'testdata_N.csv'
    experimentalDataPath = 'testdata_P.csv'
    outputDataPath = 'parsed_test_results.csv'
    CreateParsedStudentData(
        controlDataPath, experimentalDataPath, outputDataPath)

# ParseStudentData()
ParseTestData()