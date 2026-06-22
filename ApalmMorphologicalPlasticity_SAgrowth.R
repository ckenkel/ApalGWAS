#Morphological Plasticity Analysis
# by Holland Elder adapted for Acropora palmata from Million 2021

#install.packages("gdata")
#utils::install.packages("gap")
#utils::install.packages("lme4")#solving Matrix-glmer incompatibility for R v 4.3.2; say no to installing from source
library(tidyr)
library(dplyr)
options(dplyr.summarise.inform=F)
library(ggplot2)
library(lme4)
library(lmerTest)
library(multcomp)
library(pbkrtest)
library(ggfortify)
#library(gridExtra)
library(ggpubr)
library(lsmeans)
#library(tidyverse)
library(reshape2)
library(naniar)
library(piecewiseSEM)
library(foreach)
library(car)
library(agricolae)
library(DHARMa) 

#Start here with some checks
grow<-read.csv("~/Dropbox/CarlsLab/ResearchProjects/NOAA_CRCP/PALMATA/ApalmMorphologicalPlasticity_rready.csv", header = T,stringsAsFactors=TRUE)
str(grow)
summary(grow)

# Convert numbers into factors for these columns, and generate faactor for nested arrays within sites  
grow$Tag<-as.factor(grow$Tag)
grow$Array<-as.factor(grow$Array)
grow$FragID<-as.factor(grow$FragID)
grow$ArrayInSite<-with(grow,factor(Site:Array))

#grow$TissueSampledT0<-as.factor(grow$TissueSampledT0)
#grow$TissueSampledT24<-as.factor(grow$TissueSampledT24)


#relevel sites from East to West (can choose to order in anyway, eventually they will be ordered by survival)
grow= grow %>% 
  mutate(Site = factor(Site, levels=c("Eastern Sambo","Marker 32","Western Sambo","Big Pine","Dave's Ledge","Looe Key","Eastern Dry Rocks","Maryland Shoals","Bahia Honda")))
grow= grow %>%
  mutate(Genotype=factor(Genotype,levels=c("AP13-X5","AP13-X7","AP13-X9","AP13-XK","AP14-5")))


#how many measurements do we have for each time point
sum(!is.na(grow$T0_SA)) #135
sum(!is.na(grow$T12_SA)) #35
sum(!is.na(grow$T15_SA)) #107
sum(!is.na(grow$T18_SA)) #104
sum(!is.na(grow$T24_SA)) #92

#A common mistake when phenotyping is recording V as the SA of a mesh with closed holes. 
#If this is the case, V will be greater than SA but this shouldn't happen just based on these coral sizes.
#this should be 0, just as a check
sum(grow$T24_SA<grow$T24_V,na.rm = T) #looks good for all time points

# Imputation would not be valid in an Acropora palmata data set. Can test some correlations perhaps at a later date but not now.
# Breakage is also not relevant for Acropora palmata.
# So calculations for these steps have been removed.


######## Size & Growth ####################################################

summary(grow)
head(grow)

#First, calculate monthly growth rates over time-windows

grow$T12_SAgr<-(grow$T12_SA-grow$T0_SA)/12

grow$T15_SAgr<-(grow$T15_SA-grow$T12_SA)/3

grow$T18_SAgr<-(grow$T18_SA-grow$T15_SA)/3

grow$T24_SAgr<-(grow$T24_SA-grow$T18_SA)/6


### Now some general data exploration

hist(grow$T0_SA) #very normal

hist(grow$T12_SA) #a little skewed, but not bad

hist(grow$T15_SA) #a little skewed, but not bad

hist(grow$T18_SA) #more skewed

hist(grow$T24_SA) #not bad

#Quick look at overall averages for sites and genotype
grow %>% group_by(Genotype) %>% #seems like some diffs among genets in growth - X9 is outpacing
  summarise(mean(T24_SA,na.rm=T))

grow %>% group_by(Site) %>%. #EDR is not great for survival, but growth is good
  summarise(mean(T24_SA,na.rm=T))
  
#Does surface area vary among genets originally?
  
anova(lm(T0_SA~Genotype,data=grow)) #yes

plot(T0_SA~Genotype,data=grow) 
#yes, some genets larger initially (but note X9 is middle), 
#must therefore explore including as covariate
#no diffs in initial V or IS bc there is no 3D growth

####### Mixed models for absolute size 
####################

#1. Effects on absolute size in order to have largest data set
#   - basically considering all of things that happen to a coral, what impacts final size

#pivoting data set to have a column for trait value and time and trait, omitting Bahia Honda bc insufficient survival
grow$T0_SAdup<-grow$T0_SA #need to also keep T0_SA as covariate to test for now

size<-grow %>% 
  filter(Site!="Bahia Honda") %>%
  pivot_longer(cols=c(10,12,13,15,17,18,20,22,23,25,27,28,30,34,35,50:57),names_to = c('time','trait'),names_sep='_',values_to="size",values_drop_na=T)
size$time<-factor(size$time,ordered = T,levels=c("T0","T12","T15","T18","T24")) #making time ordinal

# This version does not have T12 because this time point is missing data 
# inferrence doesn't change however, so using full dataset version above
#size2<-grow %>% 
#  filter(Site!="Bahia Honda") %>%
#  pivot_longer(cols=c(10,34,35,17,18,20,22,23,25,27,28,30),names_to = c('time','trait'),names_sep='_',values_to="size",values_drop_na=T)
#size2$time<-factor(size2$time,ordered = T,levels=c("T0","T15","T18","T24")) #making time ordinal

### testing out transforms ###
dat=size[which(size$trait=="SA"),]

#dat=size2[which(size$trait=="SA"),]

hist(dat$size)
hist(log(dat$size)) #not quite far enough
hist(sqrt(dat$size)) #much improved
summary(dat$size)
head(dat$time)
#####

#Modeling SA

SA<-lmer(size~T0_SAdup+Genotype*Site*time+(1|Site:Array)+(1|UniqueID),data=size[which(size$trait=="SA"),],REML = T)

resSA <- simulateResiduals(fittedModel = SA) #check fits with DHARMa
plot(resSA) #not great
testDispersion(resSA) #significantly underdispersed 

#try transform
SAmod<-lmer((sqrt(size))~T0_SAdup+Genotype*Site*time+(1|Site:Array)+(1|UniqueID),data=size[which(size$trait=="SA"),],REML = T)

resSAmod <- simulateResiduals(fittedModel = SAmod) #check fits with DHARMa
plot(resSAmod) #still overfit
testDispersion(resSAmod) #still underdispersed 

#try simplification
SAmod2<-lmer(sqrt(size)~T0_SAdup+Genotype*Site+time+(1|Site:Array)+(1|UniqueID),data=size[which(size$trait=="SA"),],REML = T)

resSAmod2 <- simulateResiduals(fittedModel = SAmod2) #check fits with DHARMa
plot(resSAmod2) #still overfit, but better
testDispersion(resSAmod2) #no longer underdispersed 

#how much of an effect does initial SA have?
dat=size[which(size$trait=="SA"),]
par(mfrow=c(2,2))
sub=subset(dat,time=="T12")
plot(sqrt(size)~T0_SAdup,sub,xlab="T0 Surface Area",ylab="sqrt(Surface Area at T12)",main="T12")
abline(lm(sqrt(size)~T0_SAdup,sub)) 
summary(lm(sqrt(size)~T0_SAdup,sub)) #NS
sub=subset(dat,time=="T15")
plot(sqrt(size)~T0_SAdup,sub,xlab="T0 Surface Area",ylab="sqrt(Surface Area at T15)",main="T15")
abline(lm(sqrt(size)~T0_SAdup,sub)) 
summary(lm(sqrt(size)~T0_SAdup,sub)) #NS
sub=subset(dat,time=="T18")
plot(sqrt(size)~T0_SAdup,sub,xlab="T0 Surface Area",ylab="sqrt(Surface Area at T18)",main="T18")
abline(lm(sqrt(size)~T0_SAdup,sub)) 
summary(lm(sqrt(size)~T0_SAdup,sub)) #NS
sub=subset(dat,time=="T24")
plot(sqrt(size)~T0_SAdup,sub,xlab="T0 Surface Area",ylab="sqrt(Surface Area at T24)",main="T24")
abline(lm(sqrt(size)~T0_SAdup,sub)) 
summary(lm(sqrt(size)~T0_SAdup,sub)) #NS

#effect minimal, now without initial size term
SAmod3<-lmer((sqrt(size))~Genotype*Site+time+(1|Site:Array)+(1|UniqueID),data=size[which(size$trait=="SA"),],REML = T)

resSAmod3 <- simulateResiduals(fittedModel = SAmod3) #check fits with DHARMa
plot(resSAmod3) #still overfit, but no warnings, QQ is better
testDispersion(resSAmod3) #no longer underdispersed 

anova(SAmod3,ddf="Kenward-Roger") # additive effect of site, def time effect, no interaction
#Type III Analysis of Variance Table with Kenward-Roger's method
#              Sum Sq Mean Sq NumDF  DenDF  F value  Pr(>F)    
#Genotype        38.9    9.71     4  61.13   2.2529 0.07366 .  
#Site            91.4   13.06     7  15.94   3.0287 0.03161 *  
#time          4743.3 1185.82     4 343.51 274.9943 < 2e-16 ***
#Genotype:Site   74.1    2.65    28  59.96   0.6137 0.92090    
#---
#Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

summary(SAmod3) 
rand(SAmod3) # both significant
#ANOVA-like table for random-effects: Single term deletions
#Model:
#  (sqrt(size)) ~ Genotype + Site + time + (1 | Site:Array) + (1 | UniqueID) + Genotype:Site
#                 npar  logLik    AIC    LRT Df Pr(>Chisq)    
#<none>             47 -970.95 2035.9                         
#(1 | Site:Array)   46 -977.71 2047.4 13.523  1  0.0002356 ***
#  (1 | UniqueID)     46 -977.39 2046.8 12.888  1  0.0003307 ***
##  ---
#  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

#need to do Tukey's post-hoc for site and genotype

SAs <- glht(SAmod3, linfct = mcp(Site = "Tukey"))
summary(SAs) #no sig pairwise difs post MTC

SAt <- glht(SAmod3, linfct = mcp(time = "Tukey"))
summary(SAt) #strong differences over time


hist(dat$T0_SAdup)

#plot of average genotype size over time at a site; need to re-incorporate T0 SA, col 10

colorG <- c("rosybrown", "paleturquoise4","seagreen", "goldenrod","salmon")
colorS <- c("#0099c6","mediumseagreen", "paleturquoise1", "lightcoral", "lightsalmon", "rosybrown1","darkseagreen1","lightgoldenrod")


#quartz()
size[which(size$trait=="SA"),] %>% #change trait as needed
  group_by(Genotype,Site,time) %>%
  summarise(size=mean(size)) %>%
  mutate(time=factor(time,levels = c("T0","T12","T15","T18","T24"))) %>%
  ggplot(aes(x=time,y=size,group=Genotype))+
  geom_point(aes(color=Genotype))+
  geom_line(aes(color=Genotype,group=Genotype))+
  scale_color_manual(values=c("rosybrown", "paleturquoise4","seagreen", "goldenrod","salmon"))+
  ylab(expression(paste("Surface Area (",cm^{2},")")))+
  xlab(label = NULL)+theme_bw()+
  facet_wrap(~Site,ncol=4,scales = "fixed") #free

#now average for sites with error bars
pd <- position_dodge(0.3)
size[which(size$trait=="SA"),] %>% #change trait as needed
  group_by(Site,time) %>%
  summarise(avg=mean(size),sd=sd(size),n=n(),se=sd/sqrt(n)) %>%
  mutate(time=factor(time,levels = c("T0","T12","T15","T18","T24"))) %>%
  ggplot(aes(x=time,y=avg,group=Site))+
  geom_point(aes(color=Site),position=pd)+
  geom_line(aes(color=Site,group=Site),position=pd)+
  geom_errorbar(aes(ymin=avg-se,ymax=avg+se,color=Site),lwd=0.4,width=0.3,position=pd)+
  scale_color_manual(values=c("#0099c6","mediumseagreen", "paleturquoise1", "lightcoral", "lightsalmon", "rosybrown1","darkseagreen1","lightgoldenrod"))+
  ylab(expression(paste("Surface Area (",cm^{2},")")))+
  xlab(label = NULL)+theme_bw()
