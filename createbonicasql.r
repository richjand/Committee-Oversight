library(sqldf)
library(readr)

db <- dbConnect(SQLite(), dbname="bonica.sqlite")
bonica80 <- read_csv("E:/Bonica/contribDB_1980.csv")
dbWriteTable(conn = db, name = "bonica80", value = as.data.frame(bonica80), row.names = FALSE)
rm(bonica80)

bonica82 <- read_csv("E:/Bonica/contribDB_1982.csv")
dbWriteTable(conn = db, name = "bonica82", value = as.data.frame(bonica82), row.names = FALSE)
rm(bonica82)


bonica84 <- read_csv("E:/Bonica/contribDB_1984.csv")
dbWriteTable(conn = db, name = "bonica84", value = as.data.frame(bonica84), row.names = FALSE)
rm(bonica84)


bonica86 <- read_csv("E:/Bonica/contribDB_1986.csv")
dbWriteTable(conn = db, name = "bonica86", value = as.data.frame(bonica86), row.names = FALSE)
rm(bonica86)


bonica88 <- read_csv("E:/Bonica/contribDB_1988.csv")
dbWriteTable(conn = db, name = "bonica88", value = as.data.frame(bonica88), row.names = FALSE)
rm(bonica88)


bonica90 <- read_csv("E:/Bonica/contribDB_1990.csv")
dbWriteTable(conn = db, name = "bonica90", value = as.data.frame(bonica90), row.names = FALSE)
rm(bonica90)

bonica92 <- read_csv("E:/Bonica/contribDB_1992.csv")
dbWriteTable(conn = db, name = "bonica92", value = as.data.frame(bonica92), row.names = FALSE)
rm(bonica92)

bonica94 <- read_csv("E:/Bonica/contribDB_1994.csv")
dbWriteTable(conn = db, name = "bonica94", value = as.data.frame(bonica94), row.names = FALSE)
rm(bonica94)


bonica96 <- read_csv("E:/Bonica/contribDB_1996.csv")
dbWriteTable(conn = db, name = "bonica96", value = as.data.frame(bonica96), row.names = FALSE)
rm(bonica96)


bonica98 <- read_csv("E:/Bonica/contribDB_1998.csv")
dbWriteTable(conn = db, name = "bonica98", value = as.data.frame(bonica98), row.names = FALSE)
rm(bonica98)


bonica00 <- read_csv("E:/Bonica/contribDB_2000.csv")
dbWriteTable(conn = db, name = "bonica00", value = as.data.frame(bonica00), row.names = FALSE)
rm(bonica00)


bonica02 <- read_csv("E:/Bonica/contribDB_2002.csv")
dbWriteTable(conn = db, name = "bonica02", value = as.data.frame(bonica02), row.names = FALSE)
rm(bonica02)

bonica04 <- read_csv("E:/Bonica/contribDB_2004.csv")
dbWriteTable(conn = db, name = "bonica04", value = as.data.frame(bonica04), row.names = FALSE)
rm(bonica04)

bonica06 <- read_csv("E:/Bonica/contribDB_2006.csv")
dbWriteTable(conn = db, name = "bonica06", value = as.data.frame(bonica06), row.names = FALSE)
rm(bonica06)

bonica08 <- read_csv("E:/Bonica/contribDB_2008.csv")
dbWriteTable(conn = db, name = "bonica08", value = as.data.frame(bonica08), row.names = FALSE)
rm(bonica08)

bonica10 <- read_csv("E:/Bonica/contribDB_2010.csv")
dbWriteTable(conn = db, name = "bonica10", value = as.data.frame(bonica10), row.names = FALSE)
rm(bonica10)

bonica12 <- read_csv("E:/Bonica/contribDB_2012.csv")
dbWriteTable(conn = db, name = "bonica12", value = as.data.frame(bonica12), row.names = FALSE)
rm(bonica12)