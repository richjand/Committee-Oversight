library(lme4)
library(dplyr)
library(ggplot2)
library(stringr)
library(pscl)

##Generate data about basic hearing statistics##
h <- read.csv("C:/Users/richjand/Dropbox/Diss stuff/codedhearings.csv")
com <- h[h$commcode == '128' & h$oversightprob==1,]
table(com$subcommcode)
scnames <- c("Full Committee",'Energy','Communications','Health','Oversight and Investigations','Commerce and Trade','Environment')
scs <- data.frame(scnames, count = table(com$subcommcode))
scs$scnames <- reorder(scs$scnames, scs$count.Freq)
subcommcount <- ggplot(scs, aes(x = scnames, y = count.Freq)) + 
  ylim(c(0,105)) +
  geom_bar(stat = 'identity') + 
  coord_flip() + 
  ylab("Number of Oversight Hearings") +
  xlab('')
ggsave("C:/Users/richjand/Dropbox/Diss stuff/empiricalchaptercommoversight/hearingsbysubcommittee.pdf", height = 4, width = 8)

##Information about witnesses by agency##
wits <- read.csv("C:/Users/richjand/Dropbox/Diss stuff/empiricalchaptercommoversight/witnesses/commercecommitteeuncleaned.csv", stringsAsFactors=F) 
nrow(filter(wits, Agency01 == ''))

allwits <- c(wits$Agency01, wits$Agency02, wits$agency03, wits$Agency04, wits$Agency05, wits$Agency06, wits$Agency07, wits$Agency08, wits$Agency09, wits$Agency10)
allwits <- allwits[is.na(allwits)==F & allwits!= '']
length(table(allwits))
length(table(str_sub(allwits,0,2)))

topagencies = sort(table(str_sub(allwits,0,2)), decreasing = T)[1:10]
anames = c("HHS","Energy","EPA","Commerce","FCC","Transportation","FTC", "Homeland Security", "Nuclear Regulatory Comm.", "Agriculture")
topa <- data.frame(anames, topagencies)
topa$anames <- reorder(topa$anames, topa$topagencies)
tagencies <- ggplot(topa, aes(x = anames, y = topagencies)) + 
  ylim(c(0,115)) +
  geom_bar(stat = 'identity') + 
  coord_flip() + 
  ylab("Number of Witnesses") +
  xlab('')
ggsave("C:/Users/richjand/Dropbox/Diss stuff/empiricalchaptercommoversight/topagencies.pdf", height = 6, width = 8)


x <- read.csv("C:/Users/richjand/Dropbox/Diss stuff/empiricalchaptercommoversight/EnergyAndCommerce.csv")
x$logdays <- log(1+x$days)
x$loghearings <- log(1+x$number)
x$logpages <- log(1+x$regpages)
x$logregs <- log(1+x$numregs)
x$congress <- factor(x$congress)
x$subcommcode <- factor(x$subcommcode)
x$agency <- factor(x$agency)
x$divided <- factor(x$divided)
x$divnum <- ifelse(x$divided=='Divided',1,0)
x$divlregs <- x$logregs * x$divnum
y <- filter(x, !(x$agency %in% c(7509,7000)))

jurisdiction <- y%>%
  group_by(commagency) %>%
  summarise(days = sum(days)) %>%
  filter(days>0)

wj <- filter(y, commagency %in% jurisdiction$commagency)

##Descriptive statistics on regulatory activity##
regs <- y %>%
  select(agency, congress, numregs, regpages)%>%
  group_by(agency, congress)%>%
  slice(1)

regmeans <- regs %>%
  group_by(agency) %>%
  summarise(count = mean(numregs), pages = mean(regpages))
  

t1names <- c("log(Contributions)","log(Regulations)", "Divided", "Divided *\n log(Regulations)")
##TABLE 1: NB, USING FULL SAMPLE##
nb1 <- glm.nb(days~logadj + congress + agency + subcommcode, data = y,control = glm.control(maxit=10000000))
nb2 <- glm.nb(days~logadj + logregs + divided + congress + agency + subcommcode, data = y,control = glm.control(maxit=10000000))
nb3 <- glm.nb(days~logadj + logregs + divided + agencycongress + commcongress, data = y,control = glm.control(maxit=10000000))
nb4 <- glm.nb(days~logadj + logregs + divided + divlregs + congress + agency + subcommcode, data = y,control = glm.control(maxit=10000000))
stargazer(nb1, nb2, nb3, nb4,
          omit = c('congress','agency','subcomm'),
          covariate.labels = t1names,
          add.lines = list(c("Agency Fixed Effects", "Y","Y","N","Y"),
                           c("Congress Fixed Effects","Y","Y","N","Y"),
                           c("Committee Fixed Effects", "Y","Y","N","Y"),
                           c("Agency-Year Fixed Effects", "N","N","Y","N"),
                           c("Committee-Year Fixed Effects", "N","N","Y","N"))
          )

##ZINB##
zinb1 <- zeroinfl(days ~ logadj + congress + agency + subcommcode,
                  data = y, dist = "negbin")

zinb2 <- zeroinfl(days ~ logadj + logregs + divided + agency + subcommcode,
                  data = y, dist = 'negbin')

zinb3 <- zeroinfl(days ~ logadj + logregs + divided + divlregs + agency + subcommcode,
                  data = y, dist = 'negbin')

stargazer(zinb1, zinb2, zinb3,
          omit = c('congress','agency','subcomm'),
          covariate.labels = t1names,
          add.lines = list(c("Agency Fixed Effects", "Y","Y","Y"),
                           c("Congress Fixed Effects","Y","N","N"),
                           c("Committee Fixed Effects", "Y","Y","Y")),
          notes = "All variables used in both equations")
AIC(zinb1, zinb2, zinb3)

##split sample##
nb5 <- glm.nb(days~logadj + congress + agency + subcommcode, data = wj,control = glm.control(maxit=10000000))
nb6 <- glm.nb(days~logadj + logregs + divided + congress + agency + subcommcode, data = wj,control = glm.control(maxit=10000000))
nb7 <- glm.nb(days~logadj + logregs + divided + agencycongress + commcongress, data = wj,control = glm.control(maxit=10000000))
nb8 <- glm.nb(days~logadj + logregs + divided + divlregs + congress + agency + subcommcode, data = wj,control = glm.control(maxit=10000000))
stargazer(nb5, nb6, nb7, nb8,
          omit = c('congress','agency','subcomm'),
          covariate.labels = t1names,
          add.lines = list(c("Agency Fixed Effects", "Y","Y","N","Y"),
                           c("Congress Fixed Effects","Y","Y","N","Y"),
                           c("Committee Fixed Effects", "Y","Y","N","Y"),
                           c("Agency-Year Fixed Effects", "N","N","Y","N"),
                           c("Committee-Year Fixed Effects", "N","N","Y","N")
                           )
)