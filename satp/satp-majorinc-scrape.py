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

table = soup.findAll('table')
table = table[2]

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

    table = soup.findAll('table')
    table = table[2]

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