library(dplyr)
library(stringr)
my_db <- src_sqlite("E:/Bonica/bonica.sqlite")
sectors <- read.csv("C:/Users/richjand/Dropbox/Diss stuff/empiricalchaptercommoversight/lobbying/TopLobbyingSectorsRelevantToEandC.csv", stringsAsFactors=F)
template <- read.csv("C:/Users/richjand/Dropbox/Diss stuff/empiricalchaptercommoversight/EandCtemplate.csv", stringsAsFactors=F)
names(template)[names(template)=='witness'] <- 'agency'
rids <- read.csv("C:/Users/richjand/Dropbox/Diss stuff/empiricalchaptercommoversight/lobbying/candidate_cfscores_st_fed_1979_2012.csv", stringsAsFactors=F)
rids <- select(rids, bonica.rid, ICPSR2) %>%
      rename(bonica_rid = bonica.rid, icpsr = ICPSR2)
rids$icpsr <- str_sub(rids$icpsr, -5)
rids <- unique(rids)


agencies <- unique(sectors$agency)
catcodes <- unique(sectors$catcode)

congress106 <- tbl(my_db, sql("SELECT bonica_cid, amount, bonica_rid, contributor_category FROM bonica98")) %>%
              filter(contributor_category %in% catcodes) %>%
              filter(bonica_rid !='') %>%
              group_by(bonica_rid, contributor_category) %>%
              summarise(totalamount = sum(amount)) %>%
              collect()
congress106 <- left_join(congress106, rids, by = 'bonica_rid')
congress106$congress <- 106

congress107 <- tbl(my_db, sql("SELECT bonica_cid, amount, bonica_rid, contributor_category FROM bonica00")) %>%
  filter(contributor_category %in% catcodes) %>%
  filter(bonica_rid !='') %>%
  group_by(bonica_rid, contributor_category) %>%
  summarise(totalamount = sum(amount)) %>%
  collect()
congress107 <- left_join(congress107, rids, by = 'bonica_rid')
congress107$congress <- 107

congress108 <- tbl(my_db, sql("SELECT bonica_cid, amount, bonica_rid, contributor_category FROM bonica02")) %>%
  filter(contributor_category %in% catcodes) %>%
  filter(bonica_rid !='') %>%
  group_by(bonica_rid, contributor_category) %>%
  summarise(totalamount = sum(amount)) %>%
  collect()
congress108 <- left_join(congress108, rids, by = 'bonica_rid')
congress108$congress <- 108

congress109 <- tbl(my_db, sql("SELECT bonica_cid, amount, bonica_rid, contributor_category FROM bonica04")) %>%
  filter(contributor_category %in% catcodes) %>%
  filter(bonica_rid !='') %>%
  group_by(bonica_rid, contributor_category) %>%
  summarise(totalamount = sum(amount)) %>%
  collect()
congress109 <- left_join(congress109, rids, by = 'bonica_rid')
congress109$congress <- 109

congress110 <- tbl(my_db, sql("SELECT bonica_cid, amount, bonica_rid, contributor_category FROM bonica06")) %>%
  filter(contributor_category %in% catcodes) %>%
  filter(bonica_rid !='') %>%
  group_by(bonica_rid, contributor_category) %>%
  summarise(totalamount = sum(amount)) %>%
  collect()
congress110 <- left_join(congress110, rids, by = 'bonica_rid')
congress110$congress <- 110

congress111 <- tbl(my_db, sql("SELECT bonica_cid, amount, bonica_rid, contributor_category FROM bonica08")) %>%
  filter(contributor_category %in% catcodes) %>%
  filter(bonica_rid !='') %>%
  group_by(bonica_rid, contributor_category) %>%
  summarise(totalamount = sum(amount)) %>%
  collect()
congress111 <- left_join(congress111, rids, by = 'bonica_rid')
congress111$congress <- 111

congress112 <- tbl(my_db, sql("SELECT bonica_cid, amount, bonica_rid, contributor_category FROM bonica10")) %>%
  filter(contributor_category %in% catcodes) %>%
  filter(bonica_rid !='') %>%
  group_by(bonica_rid, contributor_category) %>%
  summarise(totalamount = sum(amount)) %>%
  collect()
congress112 <- left_join(congress112, rids, by = 'bonica_rid')
congress112$congress <- 112

contributions <- rbind(congress106,congress107,congress108,congress109,congress110,congress111,congress112)
contributions <- filter(contributions, is.na(icpsr)==F)

###CREATE VECTORS OF RELEVANT SECTORS FOR AGENCIES###
doe <- filter(sectors, agencycode == 8900)$catcode
cdc <- filter(sectors, agencycode == 7509)$catcode
cms <- filter(sectors, agencycode == 7505)$catcode
doc <- filter(sectors, agencycode == 1300)$catcode
hhs <- filter(sectors, agencycode == 7500)$catcode
dot <- filter(sectors, agencycode == 6900)$catcode
epa <- filter(sectors, agencycode == 6800)$catcode
fcc <- filter(sectors, agencycode == 2700)$catcode
ferc <- filter(sectors, agencycode == 8902)$catcode
ftc <- filter(sectors, agencycode == 2900)$catcode
fda <- filter(sectors, agencycode == 7506)$catcode
nih <- filter(sectors, agencycode == 7508)$catcode
nrc <- filter(sectors, agencycode == 3100)$catcode

##Sum amounts and input data##
template$amount <- 0
for (i in 1:nrow(template)){
  print(i)
  id <- template$icpsr[i]
  cong <- template$congress[i]
  sub <- filter(contributions, icpsr==id, congress==cong)
  if(template$agency[i]==8900) template$amount[i] <- sum(sub$totalamount[sub$contributor_category %in% doe])
  if(template$agency[i]==7509) template$amount[i] <- sum(sub$totalamount[sub$contributor_category %in% cdc])
  if(template$agency[i]==7505) template$amount[i] <- sum(sub$totalamount[sub$contributor_category %in% cms])
  if(template$agency[i]==1300) template$amount[i] <- sum(sub$totalamount[sub$contributor_category %in% doc])
  if(template$agency[i]==7500) template$amount[i] <- sum(sub$totalamount[sub$contributor_category %in% hhs])
  if(template$agency[i]==6900) template$amount[i] <- sum(sub$totalamount[sub$contributor_category %in% dot])
  if(template$agency[i]==6800) template$amount[i] <- sum(sub$totalamount[sub$contributor_category %in% epa])
  if(template$agency[i]==2700) template$amount[i] <- sum(sub$totalamount[sub$contributor_category %in% fcc])
  if(template$agency[i]==8902) template$amount[i] <- sum(sub$totalamount[sub$contributor_category %in% ferc])
  if(template$agency[i]==2900) template$amount[i] <- sum(sub$totalamount[sub$contributor_category %in% ftc])
  if(template$agency[i]==7506) template$amount[i] <- sum(sub$totalamount[sub$contributor_category %in% fda])
  if(template$agency[i]==7508) template$amount[i] <- sum(sub$totalamount[sub$contributor_category %in% nih])
  if(template$agency[i]==3100) template$amount[i] <- sum(sub$totalamount[sub$contributor_category %in% nrc])
}

##Adjust for inflation http://www.multpl.com/gdp-deflator/table##
template$amountadj
for (i in 1:nrow(template)){
  if (template$congress[i]==106) template$amountadj[i] = (1+(1-.8259))*template$amount[i]
  if (template$congress[i]==107) template$amountadj[i] = (1+(1-.8565))*template$amount[i]
  if (template$congress[i]==108) template$amountadj[i] = (1+(1-.9005))*template$amount[i]
  if (template$congress[i]==109) template$amountadj[i] = (1+(1-.9558))*template$amount[i]
  if (template$congress[i]==110) template$amountadj[i] = (1+(1-.9981))*template$amount[i]
  if (template$congress[i]==111) template$amountadj[i] = (1+(1-1.0195))*template$amount[i]
  if (template$congress[i]==112) template$amountadj[i] = (1+(1-1.0865))*template$amount[i]
  
}
template$logamount <- log(template$amount)
template$logadj <- log(template$amountadj)
template$commagency <- factor(paste(template$subcommcode, template$agency, sep = "_"))
template$agencycongress <- factor(paste(template$agency, template$congress, sep = '_'))
template$commcongress <- factor(paste(template$subcommcode,template$congress, sep = '_'))
template$divided <- ifelse(template$congress %in% c(106,110),"Divided","Unified")
template$republican <- ifelse(!(template$congress %in% c(111,112)),'Republican','Democrat')

regs <- read.csv("C:/Users/richjand/Dropbox/Diss stuff/empiricalchaptercommoversight/EandCRegs.csv", col.names = c('agencyname','agency','year','pages','numregs'))
regs$congress <- NA
for (k in 1:nrow(regs)){
  if (regs$year[k] %in% c(1999,2000)) regs$congress[k] = 106
  if (regs$year[k] %in% c(2001,2002)) regs$congress[k] = 107
  if (regs$year[k] %in% c(2003,2004)) regs$congress[k] = 108
  if (regs$year[k] %in% c(2005,2006)) regs$congress[k] = 109
  if (regs$year[k] %in% c(2007,2008)) regs$congress[k] = 110
  if (regs$year[k] %in% c(2009,2010)) regs$congress[k] = 111
  if (regs$year[k] %in% c(2011,2012)) regs$congress[k] = 112
}

r <- regs %>%
  filter(is.na(congress)==F) %>%
  group_by(agency, congress) %>%
  summarise(regpages = sum(pages), numregs = sum(numregs))

j <- left_join(template, r, by = c('agency','congress'))

write.csv(j, file = 'C:/Users/richjand/Dropbox/Diss stuff/empiricalchaptercommoversight/EnergyAndCommerce.csv', row.names=F)
