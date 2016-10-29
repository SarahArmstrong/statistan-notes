import urllib
import urllib.request
from bs4 import BeautifulSoup

import pandas as pd
import re
from string import ascii_lowercase

def make_soup(url):
	page = urllib.request.urlopen(url)
	sdata = BeautifulSoup(page, 'html.parser')
	return sdata


# (1) Table Type 1: 2013 - Present Year


# i. Present year

url = 'http://www.satp.org/satporgtp/countries/pakistan/database/majorincidents.htm'

soup = make_soup(url)

table = soup.findAll('table')[2]

trows = table.findAll('tr')
midata = []

midata_h1 = trows[0].findAll('td')
midata_h1 = [ele.text.strip() for ele in midata_h1]

midata_h2 = trows[1].findAll('td')
midata_h2 = [ele.text.strip() for ele in midata_h2]

for trow in trows[2:]:
    midata_body = trow.findAll('td')
    midata_body = [ele.text.strip() for ele in midata_body]
    midata.append(midata_body)

sub_headers = []
for i in range(0, 4, 1):
    sub_headers_ = str(midata_h2[i] + " " + midata_h1[3])
    sub_headers.append(sub_headers_)
    
headers = midata_h1[0:3] + sub_headers + midata_h1[4:]

df = pd.DataFrame(midata, columns = headers)

df = df.ix[:, 1:8] # Drop index 0 column

title = soup.title.text.strip()
year = title[-4:]

df.to_csv('midata' + str(year), sep=',')


# ii. 2013 - Present year_{-1}

present_year = 2016
for yr in range(2013, present_year, 1):

    url = 'http://www.satp.org/satporgtp/countries/pakistan/database/majorincidents' + str(yr) + '.htm'

    soup = make_soup(url)

    table = soup.findAll('table')[2]

    trows = table.findAll('tr')
    midata = []

    midata_h1 = trows[0].findAll('td')
    midata_h1 = [ele.text.strip() for ele in midata_h1]

    midata_h2 = trows[1].findAll('td')
    midata_h2 = [ele.text.strip() for ele in midata_h2]

    for trow in trows[2:]:
        midata_body = trow.findAll('td')
        midata_body = [ele.text.strip() for ele in midata_body]
        midata.append(midata_body)

    sub_headers = []
    for i in range(0, 4, 1):
        sub_headers_ = str(midata_h2[i] + " " + midata_h1[3])
        sub_headers.append(sub_headers_)

    headers = midata_h1[0:3] + sub_headers + midata_h1[4:]

    df = pd.DataFrame(midata, columns = headers)

    df = df.ix[:, 1:8] # Drop index 0 column

    title = soup.title.text.strip()
    year = title[-4:]

    df.to_csv('midata' + str(year), sep=',')


# Table Type 2: 2007 - 2012; NOTE: Data unstructured - needs to be manually translated to be usable


# 2012:

url = 'http://www.satp.org/satporgtp/countries/pakistan/database/majorincidents2012.htm'

soup = make_soup(url)

table = soup.findAll('table')[1]

trows = table.findAll('tr')
midata = []

for trow in trows[2:3]:
    midata_body = trow.findAll('td')
    midata_body = [ele.text.strip() for ele in midata_body]
    midata.append(midata_body)
midata = [val for sublist in midata for val in sublist][2]

midata = midata.replace('\r\n', '')
midata = midata.replace('\n\n\n\n\n\n\n', '')
midata = midata.replace('           ', ' ')
midata = midata.split('\n')

# Remove empty strings from list
midata = list(filter(None, midata))

title = midata[0]
midata = midata[2:]

df = pd.DataFrame(midata)

year = title[-4:]

df.to_csv('midata' + str(year), sep=',')


# 2007 - 2011

for yr in range(2007, 2012, 1):

    url = 'http://www.satp.org/satporgtp/countries/pakistan/database/majorinci' + str(yr) + '.htm'

    soup = make_soup(url)

    table = soup.findAll('table')[1]

    trows = table.findAll('tr')
    midata = []

    for trow in trows[2:3]:
        midata_body = trow.findAll('td')
        midata_body = [ele.text.strip() for ele in midata_body]
        midata.append(midata_body)
    midata = [val for sublist in midata for val in sublist][2]

    midata = midata.replace('\r\n', '')
    midata = midata.replace('\n\n\n\n\n\n\n', '')
    midata = midata.replace('           ', ' ')
    midata = midata.split('\n')

    # Remove empty strings from list
    midata = list(filter(None, midata))
    
    title = midata[0]
    midata = midata[2:]

    df = pd.DataFrame(midata)

    year = title[-4:]

    df.to_csv('midata' + str(year), sep=',')


# 1988 - 2006: exported as single string .csv file - must be reshaped in R
    
midata = []

yearslist = (2004, 2006)
for yr in yearslist:

    url = 'http://www.satp.org/satporgtp/countries/pakistan/database/majorinc' + str(yr) + '.htm'

    soup = make_soup(url)

    block = soup.find('div', attrs={'id':'block'})
    
    table = block.find('table')
    
    trow = table.findAll('tr')[2]
    
    tdata = trow.findAll('td')[2]
    
    paragraphs = tdata.findAll('p')
    
    midata_ = []
    midata_body = [p.text.strip() for p in paragraphs]
    midata_.append(midata_body)
    midata_ = [val for sublist in midata_ for val in sublist]

    midata_ = [ele.replace('\r\n', '') for ele in midata_]
    midata_ = [ele.replace('\n\n\n\n\n\n\n', '') for ele in midata_]
    midata_ = [ele.replace('           ', ' ') for ele in midata_]
    
    # Remove empty strings from list
    midata_ = list(filter(None, midata_))
    
    midata.append(midata_)
    
midata = [val for sublist in midata for val in sublist]

df = pd.DataFrame(midata)

df.to_csv('midata1988-2006', sep=',')