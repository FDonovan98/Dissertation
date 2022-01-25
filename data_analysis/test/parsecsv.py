import csv
import hashlib


def ParseData(filePath, validColumns, columnHeaders):
    parsedText = columnHeaders
    y = 0

    with open(filePath, newline='') as csvfile:
        file = csv.reader(csvfile, dialect='excel')
        for row in file:
            x = 0
            temp = []
            for word in row:
                if (y != 0):
                    if(x in validColumns):
                        temp.append(word)

                x += 1

            if (y != 0):
                parsedText.append(temp)
            y += 1

    return parsedText


def WriteDataToOutputFile(filepath, data):
    with open(filepath, 'w') as outputFile:
        writer = csv.writer(outputFile)
        writer.writerows(data)


def HashEmails(data):
    # hash email to obfuscate it but keep entries by the same person related
    y = 0
    for row in data:
        if (y != 0):
            row[0] = hashlib.sha1(row[0].encode('utf-8')).hexdigest()
        y += 1

    return data


def MarkDataAsExperimental(isExperimental, data):
    data[0].insert(0, 'isExperimental')
    for i in range(1, len(data)):
        data[i].insert(0, isExperimental)

    return data


def CombineData(dataA, dataB):
    return dataA + dataB
    # return combinedData


validColumns = [3, 10, 16]
columnHeaders = [['email', 'buildConfidence', 'scopeConfidence']]

# experimentalSupervisorData = ParseData(
#     'Dissertation Survey - Supervisor Version E_(1-2).csv', validColumns, columnHeaders)

# experimentalSupervisorData = HashEmails(experimentalSupervisorData)

controlSupervisorData = ParseData(
    'Dissertation Survey - Supervisor Version E_(1-2).csv', validColumns, columnHeaders)

WriteDataToOutputFile('parsed_results.csv', controlSupervisorData)

# TODO:
# - script to parse student data as this only does supervisor sheet
# - student sheet will need to be related to a supervisor before encoding
# - dictionary of all supervisor email's
# - NONONO way overcomplicating it
# - just include a field on each survey to select the team & hash with that. so much simpler
# - will also need to map groups to if they are experimental or not and include that as a column
