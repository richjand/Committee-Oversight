import requests
import pprint
import csv

totalpages = []
count = []
agencies = ['energy-department','food-and-drug-administration','centers-for-medicare-medicaid-services','federal-communications-commission', 'federal-trade-commission', 'commerce-department','nuclear-regulatory-commission', 'environmental-protection-agency','transportation-department','health-and-human-services-department', 'national-institutes-of-health',#'centers-for-disease-control-and-prevention', 
'federal-energy-regulatory-commission']

agencycodes = ['8900','7506','7505','2700','2900','1300','3100','6800','6900','7500','7508','8902']

years = ['1998','1999','2000','2001','2002','2003','2004','2005','2006','2007','2008','2009','2010','2011','2012','2013']

for agency in agencies:
    print(agency)
    for year in years:
        query_params = { 'per_page': 1000,
                'fields[]': ['page_length','agencies'],
                'conditions[agencies]': agency,
                'conditions[publication_date][year]': year,
                'conditions[type]': 'PRORULE'
        }
        endpoint = 'http://api.federalregister.gov/v1/articles.json'
        response = requests.get(endpoint, params=query_params)
        pl = []
        if response.json()['count']!=0:
            data = response.json()['results']
            if agency in ['energy-department','transportation-department','health-and-human-services-department']:
                soloregs = 0
                for d in data:
                    if len(d['agencies'])==1:
                        pl.append(d['page_length'])
                        soloregs = soloregs+1
            if agency not in ['energy-department','transportation-department','health-and-human-services-department']:
                for d in data:
                    pl.append(d['page_length'])
                soloregs = response.json()['count']
        else:
            pl.append(0)
            soloregs = 0
        totalpages.append(sum(pl))
        count.append(soloregs)

year = years*12

agencyname = []
for a in agencies:
    x = 1
    while x < 17:
        agencyname.append(a)
        x = x+1

agency = []
for a in agencycodes:
    x = 1
    while x<17:
        agency.append(a)
        x = x+1

rows = zip(agencyname,agency,year,totalpages,count)
with open("EandCRegs.csv", "w") as f:
    writer = csv.writer(f)
    for row in rows:
        writer.writerow(row)