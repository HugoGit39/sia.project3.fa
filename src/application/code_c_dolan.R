rm(list=ls(all=TRUE))
#
library(MASS)
#
wrdata=F
filen =NA
if (wrdata) filen = 'dat_1'
#
#
NP=250  # total number of persons
NI=8    # number of items
NT=7    # number of "time points" repeated measures within person S,S,M,T,W,T,F .... S,S,M,T,W,T,F
NEB=2   # number of between persons common factors
NEW=2  # number of within persons common factors
#
relB = rep(.8,NI)  # item reliabiliy per item between persons
relW = rep(.5,NI)  # item reliability per item within persons
#
B2Tratio = rep(.3,NI) # between to (between + within) variance ratio. 
#                     # < 1 means that the within person variance is greater than the between person variance, as expected.      
# factor structure between individuals
#
L_B=matrix(c(
  1,0,
  .8,0,
  .7,0,
  .9,0,
  0,1,
  0,.8,
  0,.7,
  0,.75),NI,NEB, byrow=T)
PS_B = matrix(c(
  1,.5,
  .5,1),NEB, NEB, byrow=T)
# 
B_signal = diag(L_B%*%PS_B%*%t(L_B))
TE_B = diag(B_signal - relB*B_signal) / relB
# within individuals
L_W=matrix(c(
  1,0,
  .9,0,
  .75,0,
  .7,0,
  0,1,
  0,.8,
  0,.7,
  0,.75),NI,NEW, byrow=T)
PS_W = matrix(c(
  1,.5,
  .5,1),NEB, NEB, byrow=T)
# 
W_signal = diag(L_B%*%PS_B%*%t(L_B))
TE_W = diag(W_signal - relW*W_signal) / relW
#
#
#
SB = L_B%*%PS_B%*%t(L_B) + TE_B
SW = L_W%*%PS_W%*%t(L_W) + TE_W
#
#tmp=mvrnorm(NP, rep(0,NI), Sigma=SB)
#efaB1 = factanal(tmp, factors=2, rotation='promax')
#tmp=mvrnorm(NP*NI, rep(0,NI), Sigma=SW)
#efaW1 = factanal(tmp, factors=2, rotation='promax')
#
varW = diag(SW)
varB = diag(SB)
#
checkW = eigen(SW)$values
checkB = eigen(SB)$values
# screeplots
RB = cov2cor(SB)
RW = cov2cor(SW)
checkW = eigen(RW)$values
checkB = eigen(RB)$values
# 
x11()
plot(1:NI, checkW, ylim = c(0,NI), type='b', pch='B', lwd=3, col=3)
lines(1:NI, checkB, type='b', pch='W', lwd=3, col=2)
abline(h=1, lwd=2)
#
# B2Tratio = rep(.3,NI) # between to (between + within) variance ratio. 
scaleB = sqrt( diag( (B2Tratio*varW) / (varB - B2Tratio*varB) ) )
SB = scaleB%*%SB%*%scaleB
#
datB = matrix(0, NP, NI)
datW = matrix(0, NP*NT, NI)
dat = matrix(0, NP*NT, NI+2)
#
datB = mvrnorm(NP, rep(0,NI), Sigma=SB)  # NP x NI between person scores
#
ii=0
for (i in 1:NP) {
  mu_i = datB[i,1:NI]
  for (j in 1:NT) {
    ii=ii+1
    dat[ii,1]=i
    dat[ii,2]=j
    dat[ii,3:(NI+2)] = mvrnorm(1, mu=mu_i, Sigma=SW)
    datW[ii,1:NI] = dat[ii,3:(NI+2)] - mu_i 
  } }
# 
# dat are the raw data in the long format
# datB are the between person data (means of the the NT item scores within each person, scores corrected for between person means)
# datW are the within person data (scores minus the between person means)
#
# 
# check structure using EFA
#
efaB = factanal(datB, factors=2, rotation='promax')
efaW = factanal(datW, factors=2, rotation='promax')
efa_ = factanal(dat[,3:(NI+2)], factors=2, rotation='promax')
#
colnames(dat) = c('person','T',paste("item",1:NI,sep=""))
#
if (wrdata) { write.table(dat, file=filen, col.names=F, row.names=F) } 
#
#
# illustrate multilevel factor model in lavaav
library(lavaan)
#
model1 <- '
    level: 1
        fw1 =~ item1 + item2 + item3 + item4
        fw2 =~ item5 + item6 + item7 + item8
        fw1 ~ fw2
    level: 2
        fb1 =~ item1 + item2 + item3 + item4
        fb2 =~ item5 + item6 + item7 + item8
        fb1 ~ fb2
'
fit <- sem(model = model1, data = dat, cluster = "person")
#
# efaB   # efa of between person covariance matrix 
#      (this is not strictly correct, because the between person covariance matrix is 
# biased by the within person cov matrix)
# efaW   # efa of the within person cov matrix
#
summary(fit) # this is the correct 2 level CFA analysis
