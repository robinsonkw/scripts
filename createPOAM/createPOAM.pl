# coding: utf-8

import xml.etree.ElementTree as ET
import re
from collections import defaultdict
import os
from tkinter import Tk
from tkinter.filedialog import askdirectory, askopenfilename
import pandas as pd
from datetime import datetime, date
import xlsxwriter


Tk().withdraw()
currentPOAM = askopenfilename(title='Select Current POAM', \
                              filetypes = (("Excel Files","*.xlsx"),\
                                           ("all files","*.*")))
targetDir = askdirectory(title='Select directory contatining Nessus files')

print(currentPOAM)
print(targetDir)

#targetDir = (r'C:\Users\dkallus\Downloads')
#targetDir = (r'H:\nessusScans\MUCE\20200616')
os.chdir(targetDir)
poamPluginIDs = []
host = ''
IP = ''
MAC = ''
start = ''
pluginID = '0'
severityWord = ['INFO', 'LOW', 'MODERATE', 'HIGH', 'VERY HIGH']
headers = ['System Name', 'POAM Purpose', 'A&A Number', 'POAM Item Date', \
           'POAM Item Number', 'Security ID (If Applicable)', \
           'Nessus Plugin ID', 'POAM Item Description', 'POAM Item Category',\
           'Risk Level (If Applicable)', 'ISSM Risk Statement', \
           'Recommendation/Required Action', 'Planned Mitigation', \
           'Resources Required', 'Type and Test Tool (If Applicable)',\
           'Test Validation (If Applicable)', 'Status', \
           'Estimated Completion Date', 'Revised Completion Date', \
           'Actual Completion', 'Closed Date', 'Comments', 'Agency', \
           'System Owner', 'Support Organization', 'Reporting POCs', \
           'Responsible POCs', 'Validation POC', 'ISSM POC']
colors = {'VERY HIGH': '#FF0000', 'HIGH': '#FF9900', 'MODERATE': '#FFFF00', \
          'LOW': '#008000'}
oldPOAM = defaultdict(dict)
newPOAM = defaultdict(dict)
hosts = defaultdict(dict)
plugins = defaultdict(dict)
scan = defaultdict(dict)
installedSoftware = defaultdict(dict)
compliancePlugins = [57581, 56209, 56208, 33931, 33929, 21156]
veryHighs = []
highs = []
moderates = []
lows = []
allPlugins = []
systemName = ''
poamPurpose = 'A&A'
AnANumber = ''
poamCategory = ''
status = ''
agency = ''
sysOwner = ''
supportOrg = ''
reportingPOC = ''
responsiblePOC = ''
validationPOC = ''
issmPOC = ''
poamID = 1
poamStatus = defaultdict(dict)
newPOAM = []
smDict = defaultdict(dict)

tool = 'Nessus Professional Feed'

if (len(currentPOAM) != 0):
    print('Looks like we have a current POAM')
    
    # Read the old POAM into a Pandas Dataframe  
    poam = pd.read_excel(currentPOAM, sheet_name='POAM', skiprows=[0])
    # Fill in the holes to remove all NaN values
    poam = poam.fillna('')
    # Convert the dataframe into a list of lists (each row is a separate list)
    oldPoamList = poam.values.tolist()
    # Delete the dataframe
    del poam
    # Get the PluginIDs from the old POAM
    poamPluginIDs = [row[6] for row in oldPoamList]
    # Get the system name
    systemName = oldPoamList[-1][0]
    # Get the A&A Number
    AnANumber  = oldPoamList[-1][2] 
    # Get the highest POAMID so we can determine the next one
    poamID = oldPoamList[-1][4] + 1
    # Get the agency
    agency = oldPoamList[-1][22]
    # Get System Owner
    sysOwner = oldPoamList[-1][23]
    # Get Support Organization
    supportOrg = oldPoamList[-1][24]
    # Get Reporting POCs
    reportingPOC = oldPoamList[-1][25]
    # Get Responsible POCs
    responsiblePOC = oldPoamList[-1][26]
    # Get Validation POC
    validationPOC = oldPoamList[-1][27]
    # Get ISSM POC
    issmPOC = oldPoamList[-1][28]
    # Read the old SM tab into a Dataframe
    smTab = pd.read_excel(currentPOAM, sheet_name='System Manager')
    smTab = smTab.fillna('')
    smList = smTab.values.tolist()
    del smTab
    for item in smList:
        smDict[item[5]][item[4]] = item[10]
    
    del smList            
    
else:
    print('No current POAM selected')

     


for file in os.listdir(targetDir):

    if (not re.search('.nessus$', file)):
        continue

    print(file)    
    tree = ET.parse(file)
    root = tree.getroot()

    for child in root.iter():
            
        if (child.tag == 'ReportItem'):
            pluginID = int(child.get('pluginID'))
           
            # We want to skip PCI-DSS compliance plugin output
            if pluginID in compliancePlugins:
                continue
            
            if not (plugins[pluginID].get('severity')):
                plugins[pluginID] = {'severity': \
                       severityWord[int(child.get('severity'))],\
                       'pluginName': child.get('pluginName')}
                if (plugins[pluginID]['severity'] == 'VERY HIGH'):
                    veryHighs.append(pluginID)
                elif (plugins[pluginID]['severity'] == 'HIGH'):
                    highs.append(pluginID)
                elif (plugins[pluginID]['severity'] == 'MODERATE'):
                    moderates.append(pluginID)
                elif (plugins[pluginID]['severity'] == 'LOW'):
                    lows.append(pluginID)
                
            
            if (hosts[host].get('plugins')):
                hosts[host]['plugins'].add(int(pluginID))
                #if pluginID in poamPluginIDs:
                    #pass

                #else:
                    #pass

            else:
                hosts[host]['plugins'] = set()
                hosts[host]['plugins'].add(int(pluginID))
            
            if (plugins[pluginID].get('hosts')):
                plugins[pluginID]['hosts'].add(host)
            else:
                plugins[pluginID]['hosts'] = set()
                plugins[pluginID]['hosts'].add(host)
                
            if (pluginID == '11219'):
                port = child.get('port')
                if (hosts[host].get('tcpPorts')):
                    hosts[host]['tcpPorts'].add(port)
                else:
                    hosts[host]['tcpPorts'] = set()
                    hosts[host]['tcpPorts'].add(port)
    
        if (child.tag == 'description'):
            plugins[pluginID]['description'] = child.text
        if (child.tag == 'plugin_output'):
            plugins[pluginID]['output'] = child.text
        if (child.tag == 'see_also'):
            plugins[pluginID]['see_also'] = child.text
            
        if (child.tag == 'solution'):
            plugins[pluginID]['solution'] = child.text
        
        if (child.tag == 'plugin_output' and pluginID == 19506):
                                      
            for i in re.split('\n',child.text):
                
                if ('pluginDate' not in scan) and (re.search('Plugin feed \
                   version :', i)):
                    scan['pluginDate'] = re.split('\s+', i)[-1]
                    
                if (re.search('Credentialed checks :', i)): 
                    hosts[host]['credentialed'] = re.split('\s+', i)[-1]
    
                if (re.search('Scan Start Date :', i)):
                    hosts[host]['startDate'] = \
                    datetime.strptime(re.split('\s+', i)[4], '%Y/%m/%d')
                    scan['scanDate'] = hosts[host]['startDate']
                                        
        
        if (child.tag == 'tag'): 
  
           if (child.get('name') == 'mac-address'):
               hosts[host]['MAC'] = re.sub('\n',' ',child.text)
                          
           elif (child.get('name') == 'host-ip'):
               hosts[host]['IP'] = re.sub('\n',' ',child.text)
               
           elif (child.get('name') == 'HOST_START'):
               start = child.text
           
           elif (child.get('name') == 'operating-system'):
               hosts[host]['OS'] = re.sub('\n','; ',child.text)
           
           elif (child.get('name') == 'system-type'):
               hosts[host]['system-type'] = child.text
           
        if (child.tag == 'ReportHost'):
           host = child.get('name') 
        
        # Plugin 48942 identifies Windows OS release number
        # The output number needs a rubric to translate to 1903, 1909, etc
        if (pluginID == '48942') and (child.tag == 'plugin_output'):
            for i in re.split('\n', child.text):
                if (re.search('Operating system version', i)):
                    release = re.split('\s+', i)[-1]

                    hosts[host]['OS'] += ' ('
                    hosts[host]['OS'] += re.split('\s+', i)[-1]
                    hosts[host]['OS'] += ')'
      
        # Plugin 20811 identifies installed Windows software
        if (pluginID == 20811) and (child.tag == 'plugin_output'):
            for i in re.split('\n', child.text):
                if (re.match('^\s*$', i)):
                    continue
                if (re.match('The following software are installed on the \
                             remote host :', i)):
                    continue

                software = re.split('\[', i)[0]
                
                if (not installedSoftware.get(software)):
                    installedSoftware[software] = defaultdict()
                
                versionBlock = 'UNK'
                versionOBJ = re.search('\sv?(\d+[-\.\d]*)\s',i)
                if (versionOBJ):
                    versionBlock = versionOBJ.group(0)

                
                if (re.search('\[version', i)):

                    tmpVersionBlock = re.split('(\[|\])',i)[2]
                    versionBlock = re.split('\s+', tmpVersionBlock)[-1]
                    
                
                if (installedSoftware[software].get(versionBlock)):
                    installedSoftware[software][versionBlock] += 1
                else:
                    installedSoftware[software][versionBlock] = 1
                    
        # Plugin 22869 idnetifies installed Linux software            
        if (pluginID == 22869) and (child.tag == 'plugin_output'):

            for i in re.split('\n', child.text):
                if (re.match('^\s*$', i)):
                    continue
                if (re.match('^Here is the list of packages', i)):
                    continue
                
                line = re.split('\s+', i)
                if line[0] != 'ii': 
                    continue
               
                if (len(line) >= 4):
                    software = line[2]
                    versionBlock = line[3]
                
                if ( not installedSoftware.get(software)):
                    installedSoftware[software] = defaultdict()
                    
                if (installedSoftware[software].get(versionBlock)):
                    installedSoftware[software][versionBlock] += 1
                else:
                    installedSoftware[software][versionBlock] = 1    

                    
workbook = xlsxwriter.Workbook('POAM.xlsx')


bold = workbook.add_format({'bold': True})
std = workbook.add_format()
date_format = workbook.add_format({'num_format': 'mm/dd/yyyy'})
veryHigh = workbook.add_format({'bg_color': colors['VERY HIGH']})
high = workbook.add_format({'bg_color': colors['HIGH']})
moderate = workbook.add_format({'bg_color': colors['MODERATE']})
low = workbook.add_format({'bg_color': colors['LOW']})
textWrap = workbook.add_format({'text_wrap': True})
topHeader = workbook.add_format({'align': 'center', 'bg_color': '#CCCCCC', \
                                 'border': 2})
secondHeader = workbook.add_format({'bg_color': '#EEEEEE', 'text_wrap': True, \
                                    'border': 2})
                              
frmt = std

#agency = 'None'



poamSheet = workbook.add_worksheet('POAM')
hostSheet = workbook.add_worksheet('HOST')
swSheet = workbook.add_worksheet('SOFTWARE')
crossSheet = workbook.add_worksheet('System Manager')
pluginSheet = workbook.add_worksheet('PLUGIN')


crossSheet.set_column('A:D', 15)
crossSheet.set_column('E:E', 30)
crossSheet.set_column('F:F', 15)
crossSheet.set_column('G:G', 100)
crossSheet.set_column('H:H', 30)
crossSheet.set_column('I:M', 100)
crossSheet.write(0,0, 'System Name')
crossSheet.write(0,1, 'A&A Number')
crossSheet.write(0,2, 'POAM Item Date')
crossSheet.write(0,3, 'POAM Item Number')
crossSheet.write(0,4, 'Host')
crossSheet.write(0,5, 'Nessus Plugin ID')
crossSheet.write(0,6, 'POAM Item Description')
crossSheet.write(0,7, 'Risk Level')
crossSheet.write(0,8, 'Recommended/Required Action')
crossSheet.write(0,9, 'Planned Mitigation Summary')
crossSheet.write(0,10, 'Planned Mitigation Individual')
crossSheet.write(0,11, 'Description')
crossSheet.write(0,12, 'Plugin Output')
crossSheet.write(0,13, 'See Also')

# Set Column Widths
poamSheet.set_column('A:G', 15)
poamSheet.set_column('H:H', 100)
poamSheet.set_column('I:K', 30)
poamSheet.set_column('L:M', 100)
poamSheet.set_column('N:AC', 15)

hostSheet.set_column('A:B', 11)
hostSheet.set_column('C:C', 100)
hostSheet.set_column('D:D', 50)
hostSheet.set_column('E:G', 11)
hostSheet.set_column('H:H', 100)

pluginSheet.set_column('A:B', 15)
pluginSheet.set_column('C:C', 100)
pluginSheet.set_column('D:D', 15)
pluginSheet.set_column('E:F', 100)

swSheet.set_column('A:A', 100)
swSheet.set_column('B:B', 50)

# Merge Some Top Row Cells
poamSheet.merge_range('A1:P1', 'POAM Item Information', topHeader)
poamSheet.merge_range('Q1:V1', 'POAM Item Status', topHeader)
poamSheet.merge_range('W1:AC1', 'POAM Item Organization/POCs', topHeader)

row = 1
column = 0

# Plugin Sheet
pluginRow = 0
pluginColumn = 0

pluginSheet.write(pluginRow, pluginColumn, 'POAM ID')
pluginColumn += 1
pluginSheet.write(pluginRow, pluginColumn, 'Plugin ID')
pluginColumn += 1
pluginSheet.write(pluginRow, pluginColumn, 'Plugin Name')
pluginColumn += 1
pluginSheet.write(pluginRow, pluginColumn, 'Num Hosts')
pluginColumn += 1
pluginSheet.write(pluginRow, pluginColumn, 'SubNets')
pluginColumn += 1
pluginSheet.write(pluginRow, pluginColumn, 'Hosts')
pluginColumn += 1

pluginRow = 1
pluginColumn = 0

# Group all the plugins
allPlugins.extend(veryHighs)
allPlugins.extend(highs)
allPlugins.extend(moderates)
allPlugins.extend(lows)

if (len(currentPOAM) != 0):
    # Work through the old POAM first
    for item in oldPoamList:
        line = item.copy()
        repeat = 0
        openItem = 0
        plugin = int(line[6])
              
        # Determine if this item is in the new scan
        if plugin in allPlugins:
            # This plugin still exists in the new scan so we will need to update it
            repeat = 1


            count = len(plugins[plugin]['hosts'])

            # See if the existing entry is open    
        if line[16] == 'OPEN':
            openItem = 1


        # If this item is not in the new scan and not currently open the write it
        # out to the new POAM unaltered
        if repeat == 0 and openItem == 0:
            # Annotate no status change
            poamStatus[line[4]]='No Change'
            pass    
    
        # If this item is not in the new scan and is currently listed as open then
        # we need to complete it and update it accordingly        
        if repeat == 0 and openItem == 1:

            # Annotate this item has been completed
            poamStatus[line[4]]='Completed'
            # Update the comment that it no longer shows up in the scans
            comment = "{} - plugin ID {} not found in Nessus scan output. \
Marking complete at this time.\n".format(scan['scanDate'].\
            strftime('%m/%d/%Y'), plugin)
            line[21] += comment

            
            # Change the status to complete
            line[16] = 'COMPLETE'
            
            # Change the Actual Completetion to the scan date
            line[19] = scan['scanDate'].strftime('%m/%d/%Y')
            
        # If this item is in the new scan and is currently not opened the we need
        # to re-open this item
        if repeat == 1 and openItem == 0:
            poamStatus[line[4]] = 'Re-opened'

            # Update the comment field showing this has been reopened
            comment = "{} - REOPENED {} instances of plugin ID {} found in Nessus \
            scan output.\n".format(scan['scanDate'].strftime('%m/%d/%Y'), count, \
            plugin)
            line[9] = plugins[pluginID]['severity']
            line[21] += comment

            
            # Change the status to open
            line[16] = 'OPEN'
            
            # Remove the Actual Completion Date
            line[19] = ''
            pass
        
        # If this item is in the new scan and is curently open then we need to
        # update it
        if repeat == 1 and openItem == 1:
            poamStatus[line[4]] = 'Still Open'
            
            # Update the comment field showing the new counts
            comment = "{} - {} instances of plugin ID {} found in Nessus scan \
output.\n".format(scan['scanDate'].strftime('%m/%d/%Y'), count, \
            plugin)
            line[9] = plugins[pluginID]['severity']
            line[21] += comment

            pass
        
        newPOAM.append(line)
    
for i in headers:
    poamSheet.write(row, column, i, secondHeader)
    column += 1
    


row = 2
crossTabRow = 1
column = 0





for plugin in allPlugins:
 
    if plugin in poamPluginIDs:
        continue
    
    # Setup our comments
    count = len(plugins[plugin]['hosts'])
    comment = "{} - {} instances of plugin ID {} found in Nessus scan output.\
    \n".format\
    (scan['scanDate'].strftime('%m/%d/%Y'), count, plugin)    
    
    
   
    #['System Name', 'POAM Purpose', 'A&A Number', 'POAM Item Date', \
    #'POAM Item Number', 'Security ID (If Applicable)', \
    #'Nessus Plugin ID', 'POAM Item Description', 'POAM Item Category',\
    #'Risk Level (If Applicable)', 'ISSM Risk Statement', \
    #'Recommendation/Required Action', 'Planned Mitigation', \
    #'Resources Required', 'Type and Test Tool (If Applicable)',\
    #'Test Validation (If Applicable)', 'Status', \
    #'Estimated Completion Date', 'Revised Completion Date', \
    #'Actual Completion', 'Closed Date', 'Comments', 'Agency', \
    #'System Owner', 'Support Organization', 'Reporting POCs', \
    #'Responsible POCs', 'Validation POC', 'ISSM POC']
        
    # Loop through all plugins to add it to the oldPOAMList
    entry = [systemName, poamPurpose, AnANumber, scan['scanDate'], poamID,'',\
             plugin, plugins[plugin]['pluginName'], poamCategory, \
             plugins[plugin]['severity'], '', \
             plugins[plugin].get('solution'), '', \
             '', tool, tool, 'OPEN', \
             '', '', \
             '', '', comment, agency, \
             sysOwner, supportOrg, reportingPOC, \
             responsiblePOC, validationPOC, issmPOC]
    
    # Add it to our POAM
    newPOAM.append(entry)
    
    # Increment our poamID
    poamID += 1
   
    

for line in newPOAM:

    # Set the plugin name
    plugin = line[6]
 
   
    if plugin in plugins and line[16] == 'OPEN':
        
        # PLUGIN Sheet
        # POAM ID
        pluginSheet.write(pluginRow, pluginColumn, line[4])
        pluginColumn += 1
        # Plugin ID
        pluginSheet.write(pluginRow, pluginColumn, plugin)
        pluginColumn += 1
        # Plugin Name
        pluginSheet.write(pluginRow, pluginColumn, line[7], textWrap)
        pluginColumn += 1
        # Num Hosts
        pluginSheet.write(pluginRow, pluginColumn, len(plugins[plugin]['hosts']))
        pluginColumn += 1
        # Subnets
        tmpHosts = []
        subnets = {}
            
        for host in sorted(plugins[plugin]['hosts']):
            ip = hosts[host]['IP']
            #tmpHosts = tmpHosts + ip + ', '
            tmpHosts.append(ip)
                
            hostParts = ip.split('.')
            tmpSubNet = hostParts[0] + '.' + hostParts[1] + '.' + hostParts[2]
            subnets[tmpSubNet] = 1
                
        pluginSheet.write(pluginRow, pluginColumn, \
                          ', '.join(str(x) for x in subnets), textWrap) 
        pluginColumn += 1
        # Hosts
        #pluginSheet.write(pluginRow, pluginColumn, tmpHosts, textWrap)
        pluginSheet.write(pluginRow, pluginColumn, \
                          ', '.join(str(x) for x in tmpHosts), textWrap)
        pluginRow += 1
        pluginColumn = 0
        
        for host in (plugins[plugin]['hosts']):
            
            #       0              1              2              3
            #['System Name', 'POAM Purpose', 'A&A Number', 'POAM Item Date', \
            #        4                 5      
            #'POAM Item Number', 'Security ID (If Applicable)', \
            #        6                 7                         8
            #'Nessus Plugin ID', 'POAM Item Description', 'POAM Item Category',\
            #        9                              10
            #'Risk Level (If Applicable)', 'ISSM Risk Statement', \
            #        11                             12
            #'Recommendation/Required Action', 'Planned Mitigation', \
            #        13                      14
            #'Resources Required', 'Type and Test Tool (If Applicable)',\
            #        15                            16
            #'Test Validation (If Applicable)', 'Status', \
            #        17                            18
            #'Estimated Completion Date', 'Revised Completion Date', \
            #        19                20            21         22
            #'Actual Completion', 'Closed Date', 'Comments', 'Agency', \
            #        23                24                  25
            #'System Owner', 'Support Organization', 'Reporting POCs', \
            #        26                27              28
            #'Responsible POCs', 'Validation POC', 'ISSM POC']
        
            # System Name    
            crossSheet.write(crossTabRow,0,line[0])
            # A&A Number
            crossSheet.write(crossTabRow,1,line[2])
            # POAM Item Date
            crossSheet.write(crossTabRow,2,line[3], date_format)
            # POAM Item Number
            crossSheet.write(crossTabRow,3,line[4])
            # Host 
            crossSheet.write(crossTabRow,4,host)
            # Nessus Plugin ID
            crossSheet.write(crossTabRow,5,line[6])
            # POAM Item Description
            crossSheet.write(crossTabRow,6,line[7], textWrap)
            #Risk Level
            crossSheet.write(crossTabRow,7,line[9])
            # Recommended/Required Action
            crossSheet.write(crossTabRow,8,line[11], textWrap)
            # Planned Mitigation
            crossSheet.write(crossTabRow,9,line[12], textWrap)
            # Planned Mitigation Individual
            crossSheet.write(crossTabRow,10, smDict[plugin].get(host), textWrap)
            # Description
            crossSheet.write(crossTabRow,11,plugins[plugin]['description'], \
                             textWrap)
            # PluginOutput
            crossSheet.write(crossTabRow,12,plugins[plugin].get('output'), \
                             textWrap)
            # See Also
            crossSheet.write(crossTabRow,13,plugins[plugin].get('see_also'), \
                             textWrap)
            crossTabRow += 1
   

           
    # System Name
    poamSheet.write(row, column, line[0])
    column += 1
    # Always A&A
    poamSheet.write(row, column, line[1])
    column += 1
    # Skip over A&A Number
    poamSheet.write(row, column, line[2])
    column += 1
    # POAM Item Date
    poamSheet.write_datetime(row, column, line[3], date_format)
    column += 1
    # POAM Item Number    
    poamSheet.write(row, column, int(line[4]))
    column += 1
    # Skip Security ID
    column += 1
    # Nessus Plugin ID
    poamSheet.write(row, column, int(line[6]))
    column += 1
    # POAM Item Description
    poamSheet.write(row, column, line[7], textWrap)
    column += 1    
    #POAM Item Category
    poamSheet.write(row, column, line[8], textWrap)
    column += 1
    # Risk Level    
    if (line[9] == 'VERY HIGH'):
        frmt = veryHigh
    elif (line[9] == 'HIGH'):
        frmt = high
    elif (line[9] == 'MODERATE'):
        frmt = moderate
    elif (line[9] == 'LOW'):
        frmt = low
    poamSheet.write(row, column, line[9], frmt)
    column += 1
    #ISSM Risk Statement
    poamSheet.write(row, column, line[10], textWrap)
    column += 1
    # Recommendation/Required Action
    poamSheet.write(row, column, line[11], textWrap)
    column += 1
    # Planned Mitigation
    poamSheet.write(row, column, line[12], textWrap)
    column += 1
    # Resources Required
    poamSheet.write(row, column, line[13], textWrap)
    column += 1
    # Type and Test Tool 
    poamSheet.write(row, column, line[14], textWrap)
    column += 1
    # Test Validation
    poamSheet.write(row, column, line[15], textWrap)
    column += 1
    # Status
    poamSheet.write(row, column, line[16])    
    column += 1
    # Estimated Completion Date
    poamSheet.write(row, column, line[17], date_format)
    column += 1
    # Revised Completion Date
    poamSheet.write(row, column, line[18], date_format)
    column += 1
    # Actual Completion
    poamSheet.write(row, column, line[19], date_format)
    column += 1
    # Closed Date
    poamSheet.write(row, column, line[20], date_format)
    column += 1
    # Comments
    poamSheet.write(row, column, line[21], textWrap)
    column += 1
    # Agency
    poamSheet.write(row, column, line[22])
    column += 1
    # System Owner
    poamSheet.write(row, column, line[23])
    column += 1
    # Support Organization
    poamSheet.write(row, column, line[24])
    column += 1
    # Reporting POCs
    poamSheet.write(row, column, line[25])
    column += 1
    # Responsible POC
    poamSheet.write(row, column, line[26])
    column += 1
    # Validation POC
    poamSheet.write(row, column, line[27])
    column += 1
    # ISSM POC
    poamSheet.write(row, column, line[28])
    column += 1
      
    row+=1
    column = 0
    
    
# Host Sheet
row = 0
column = 0

hostSheet.write(row, column, 'Name')
column += 1
hostSheet.write(row, column, 'IP')
column += 1
hostSheet.write(row, column, 'MAC')
column += 1
hostSheet.write(row, column, 'OS')
column += 1
hostSheet.write(row, column, 'TYPE')
column += 1
hostSheet.write(row, column, 'CREDENTIALS')
column += 1
hostSheet.write(row, column, 'NUM VULNS')
column += 1
hostSheet.write(row, column, 'VULNERABILITIES')


row = 1
column = 0 

for host in hosts:
    hostSheet.write(row, column, host)
    column += 1
    hostSheet.write(row, column, hosts[host].get('IP'))
    column += 1
    hostSheet.write(row, column, hosts[host].get('MAC'), textWrap)
    column += 1
    hostSheet.write(row, column, hosts[host].get('OS'))
    column += 1
    hostSheet.write(row, column, hosts[host].get('system-type'))
    column += 1
    hostSheet.write(row, column, hosts[host].get('credentialed'))
    column += 1

    pluginList = ''
    count = 0
    for plugin in hosts[host]['plugins']:
        count += 1
        pluginList = pluginList + str(plugin) + ', '
 
    hostSheet.write(row, column, count)
    column += 1       
    hostSheet.write(row, column, pluginList, textWrap)
    
    row += 1
    column = 0
    



 
    
row = 0 
column = 0

swSheet.write(row,column,'Name')
column += 1
swSheet.write(row,column,'Version')

row = 1
column = 0

for software in sorted(installedSoftware):
    for version in sorted(installedSoftware[software]):
        swSheet.write(row, column, software)
        column += 1
        swSheet.write(row,column, version)
        row += 1
        column = 0

workbook.close()
              

    


        
