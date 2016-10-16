import urllib
import urllib.request
from bs4 import BeautifulSoup

def make_soup(url):
	page = urllib.request.urlopen(url)
	sdata = BeautifulSoup(page, 'html.parser')
	return sdata

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
    
print(bbdata)