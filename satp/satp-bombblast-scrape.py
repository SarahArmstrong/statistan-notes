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


# (1) Table Type 1: 2009 - Present Year


# i. Present year

url = 'http://www.satp.org/satporgtp/countries/pakistan/database/bombblast.htm'

soup = make_soup(url)

table = soup.findAll('table', attrs={'class':'pagraph1'})
table = table[0]

trows = table.findAll('tr')
bbdata = []
for trow in trows:
    bbdata_ = trow.findAll('td')
    bbdata_ = [ele.text.strip() for ele in bbdata_]
    bbdata.append(bbdata_)

bbdata = [[i.replace('\r\n','') for i in li] for li in bbdata]
bbdata = [[i.replace('\n\n\n\n\n\n\n', '') for i in li] for li in bbdata]
bbdata = [[i.replace('           ', ' ') for i in li] for li in bbdata]
bbdata = [[i.replace('       ', ' ') for i in li] for li in bbdata]
bbdata = [[i.replace('     ', ' ') for i in li] for li in bbdata]

headers =  bbdata.pop(0)
df = pd.DataFrame(bbdata, columns = headers)

df = df.ix[:, 1:5] # Drop index 0 column

title = soup.title.text.strip()
year = title[-4:]
print(year)

df.to_csv('bbdata' + str(year), sep=',')


# ii. 2009 - Present year_{-1}

present_year = 2016
for yr in range(2009, present_year, 1):

    url = 'http://www.satp.org/satporgtp/countries/pakistan/database/bombblast' + str(yr) +'.htm'

    soup = make_soup(url)

    table = soup.findAll('table', attrs={'class':'pagraph1'})
    table = table[0]

    trows = table.findAll('tr')
    bbdata = []
    for trow in trows:
        bbdata_ = trow.findAll('td')
        bbdata_ = [ele.text.strip() for ele in bbdata_]
        bbdata.append(bbdata_)
    
        bbdata = [[i.replace('\r\n','') for i in li] for li in bbdata]
        bbdata = [[i.replace('\n\n\n\n\n\n\n', '') for i in li] for li in bbdata]
        bbdata = [[i.replace('           ', ' ') for i in li] for li in bbdata]
        bbdata = [[i.replace('       ', ' ') for i in li] for li in bbdata]
        bbdata = [[i.replace('     ', ' ') for i in li] for li in bbdata]

    headers =  bbdata.pop(0)
    df = pd.DataFrame(bbdata, columns = headers)

    df = df.ix[:, 1:5] # Drop index 0 column
    
    title = soup.title.text.strip()
    year = title[-4:]
    print(year)
    
    df.to_csv('bbdata' + str(year), sep=',')
    
    
# Table Type 2: 2000 - 2008

for yr in range(2000, 2009, 1):

    url = 'http://www.satp.org/satporgtp/countries/pakistan/database/bombblast' + str(yr) +'.htm'

    soup = make_soup(url)

    table = soup.findAll('table', attrs={'class':'pagraph1'})
    table = table[0]

    trows = table.findAll('tr')
    bbdata = []
    for trow in trows:
        bbdata_ = trow.findAll('td')
        bbdata_ = [ele.text.strip() for ele in bbdata_]
        bbdata.append(bbdata_)
    
    bbdata = [[i.replace('\r\n','') for i in li] for li in bbdata]
    bbdata = [[i.replace('\n\n\n\n\n\n\n', '') for i in li] for li in bbdata]
    bbdata = [[i.replace('           ', ' ') for i in li] for li in bbdata]
    bbdata = [[i.replace('       ', ' ') for i in li] for li in bbdata]
    bbdata = [[i.replace('     ', ' ') for i in li] for li in bbdata]

    headers =  bbdata.pop(0)
    df = pd.DataFrame(bbdata, columns = headers)
    
    title = soup.title.text.strip()
    year = title[-4:]
    print(year)
    
    df.to_csv('bbdata' + str(year), sep=',')