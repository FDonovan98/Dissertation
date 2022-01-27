import csv
import hashlib

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
    parsedText = [[]]
    with open(filePath, newline='') as csvfile:
        file = csv.reader(csvfile, dialect='excel')
        for row in file:
            x = 0
            temp = []
            for word in row:
                temp.append(word)

            parsedText.append(temp)

    return parsedText


def WriteDataToOutputFile(filepath, data):
    with open(filepath, 'w') as outputFile:
        writer = csv.writer(outputFile)
        writer.writerows(data)

    return 0


# Hash email to obfuscate it but keep entries by the same person related
def HashEmails(data, emailIndex):
    y = 0
    for row in data:
        if (y != 0):
            row[emailIndex] = hashlib.sha1(
                row[emailIndex].encode('utf-8')).hexdigest()
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
    combined = HashEmails(combined, 1)

    WriteDataToOutputFile(outputDataPath, combined)


# Set file path's
controlDataPath = 'Dissertation Survey - Supervisor Version N.csv'
experimentalDataPath = 'Dissertation Survey - Supervisor Version P_(1-2)(1).csv'
outputDataPath = 'parsed_supervisor_results.csv'

CreateParsedSupervisorData(
    controlDataPath, experimentalDataPath, outputDataPath)

# TODO:
# - script to parse student data as this only does supervisor sheet
# - student sheet will need to be related to a supervisor before encoding
# - dictionary of all supervisor email's
# - NONONO way overcomplicating it
# - just include a field on each survey to select the team & hash with that. so much simpler
