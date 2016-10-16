import urllib
import urllib.request
from bs4 import BeautifulSoup

def make_soup(url):
	page = urllib.request.urlopen(url)
	sdata = BeautifulSoup(page, "html.parser")
	return sdata

url = "http://www.satp.org/satporgtp/countries/pakistan/database/bombblast.htm"

soup = make_soup(url)