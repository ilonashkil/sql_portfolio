import xml.etree.ElementTree as ET
import csv

# Set the name of the input and output files
input_file = 'health_data.xml'
output_file = 'health_data.csv'

# Open the XML file and create an ElementTree object
tree = ET.parse(input_file)
root = tree.getroot()

# Get all the tags in the XML file and their attributes
tags = []
for elem in root.iter():
    tag = elem.tag
    attributes = elem.attrib.keys()
    if tag not in tags:
        tags.append(tag)
        tags.extend(attributes)

print(tags)
# # Open the CSV file for writing
with open(output_file, 'w', newline='') as f:
    writer = csv.writer(f)

    # Write the header row with the tag names
    writer.writerow(tags)

    # Loop through each record in the XML file and extract the data
    for record in root.iter():
        data = []
        for tag in tags:
            value = record.attrib.get(tag, '')
            data.append(value)
        writer.writerow(data)
