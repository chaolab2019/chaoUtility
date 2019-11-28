
#######################################################################################################################
#' R code for JADE (Joint species-rank Abundance Distribution/Estimation): two parameters &
#' 2013 Entropy and the species accumulation curve Appendix S2: Estimating species relative abundance :one parameter
#' based on individual-based (abundance) and sampling-unit-based (incidence) data.
#' @param Bootype a string= "JADE" or "One" or "SAR". Default is "One", SAR for without replacement
#' @param datatype a string
#' @param x a vector/matrix/list of species abundance frequency
#' @param zero reserves zero frequency or not. Default is TRUE.
#' @param rho a numerical value as sampling fraction, only for SAR default=NaN
#' @return  a vector/matrix/list with species relative abundance or detection probability distribution
#' @examples
#' data(bird)
#' bird.inc <- bird$inci
#' bird.abun<- bird$abun
#' Boot_p(bird$abun, datatype="abundance")
#' Boot_p(bird$abun, datatype="incidence_raw")
#' @export

Boot_p<-function(x,zero=TRUE,Bootype="One",datatype="abundance",rho=NaN){
  datatype <- check_datatype(datatype)
  Bootype <- check_Bootype(Bootype)
  if(Bootype=="SAR" & is.nan(rho)==T)  stop("Bootype SAR invalid rho")
  if(class(x)=="list"){
    lapply(x, function(x) Boot_p_(x,zero,Bootype, datatype,rho))
  }else if(class(x) %in% c("matrix","data.frame") & datatype=="abundance"){
    apply(x, 2, function(x) Boot_p_(x,zero,Bootype, datatype,rho))
  }else if(class(x) %in% c("matrix","data.frame") & datatype=="incidence"){
    apply(x, 2, function(x) Boot_p_(x,zero,Bootype, datatype,rho))
  }else{
    Boot_p_(x,zero,Bootype, datatype,rho)
  }
}


Boot_p_<-function(x,zero=TRUE,Bootype="One",datatype="abundance",rho=NaN)
{

  check_data(x,datatype)
  if(datatype == "abundance"){
    if(Bootype =="One") out_p <- bootp_one_abu(x,zero)
    else if(Bootype =="JADE") out_p <- bootp_jade_abu(x,zero)
    else if(Bootype=="SAR" )  out_p <- bootp_one_abu_sar(x,zero,rho)



  }else if (datatype == "incidence"){
    if(Bootype =="One") out_p <- bootp_one_inc(x,zero)
    else if(Bootype =="JADE") out_p <- bootp_jade_inc(x,zero)
    else if(Bootype=="SAR")  out_p <- bootp_one_inc_sar(x,zero,rho)
  }else if (datatype == "incidence_raw"){
    xx <- iNEXT::as.incfreq(x)
    if(Bootype =="One") out_p <- bootp_one_inc(xx,zero)
    else if(Bootype =="JADE") out_p <- bootp_jade_inc(xx,zero)
    else if(Bootype=="SAR")  out_p <- bootp_one_inc_sar(xx,zero,rho)

  }

}

################################################################################################################
#' Estimating species relative abundance/incidnece bootstrap Pi
#' Chao, A., Wang, Y. T., and Jost, L. (2013).
#' Entropy and the species accumulation curve: a novel estimator of entropy via discovery rates of new species.
#' Appendix S2:  Estimating species relative abundance :one parameter
#' bootp_one_abu(x) is a function for abundance data
#' bootp_one_inc(x) is a function for incidence data
#' @param Spec a vector of species abundance frequency
#' @param zero reserves zero frequency or not. Default is TRUE.
#' @return a numerical vector and its length is the same as Spec
#' @examples
#' data(bird)
#' bird.inc <- bird$inci
#' bird.abun<- bird$abun
#' Boot_p(bird$abun, datatype="abundance")
#' Boot_p(bird$abun, datatype="incidence_raw")
#############################################################################################################

bootp_one_abu <- function(Spec,zero=TRUE)
{
  Sobs <- sum(Spec > 0)   #observed species
  n <- sum(Spec)        #sample size
  f1 <- sum(Spec == 1)   #singleton
  f2 <- sum(Spec == 2)   #doubleton
  f0.hat <- ifelse(f2 == 0, (n - 1) / n * f1 * (f1 - 1) / 2, (n - 1) / n * f1 ^ 2/ 2 / f2)  #estimation of unseen species via Chao1
  A <- ifelse(f1>0, n*f0.hat/(n*f0.hat+f1), 1)
  a <- f1/n*A
 # a <- ifelse(f2==0, f1/n*(n-1)*(f1-1)/((n-1)*(f1-1)-2), f1/n*(n-1)*f1/((n-1)*f1+2*f2))

  b <- sum(Spec / n * (1 - Spec / n) ^ n)
  if(f0.hat==0){
    w <- 0
    if(sum(Spec>0)==1){
      warning("This site has only one species. Estimation is not robust.")
    }
  }else{
    w <- a / b      	#adjusted factor for rare species in the sample: lamda
  }

  if(zero==FALSE) Spec <- Spec[Spec>0]
  Prob.hat <- Spec / n * (1 - w * (1 - Spec / n) ^ n)					#estimation of relative abundance of observed species in the sample
  Prob.hat.Unse <- rep(a/ceiling(f0.hat), ceiling(f0.hat))  	#estimation of relative abundance of unseen species in the sample
  return(c(Prob.hat, Prob.hat.Unse))		  							#Output: a vector of estimated relative abundance
}


bootp_one_inc <- function (Spec,zero=TRUE) {
  nT <- Spec[1]
  Spec <- Spec[-1]
  #Sobs <- sum(Spec > 0)
  U <- sum(Spec>0)
  Q1 <- sum(Spec == 1)
  Q2 <- sum(Spec == 2)
  Q0.hat <- ifelse(Q2 == 0, (nT - 1)/nT * Q1 * (Q1 - 1)/2,
                   (nT - 1)/nT * Q1^2/2/Q2)
  A <- ifelse(Q1 > 0, nT * Q0.hat/(nT * Q0.hat + Q1), 1)
  a <- Q1/nT * A
 # a <- ifelse(Q2==0,Q1/nT*(nT-1)*(Q1-1)/((nT-1)*(Q1-1)+2),
 #             Q1/nT*(nT-1)*Q1/((nT-1)*Q1+2*Q2))
  b <- sum(Spec/nT * (1 - Spec/nT)^nT)
  if (Q0.hat == 0) {
    w <- 0
    if (sum(Spec > 0) == 1) {
      warning("This site has only one species. Estimation is not robust.")
    }
  }
  else {
    w <- a/b

  }

  if(zero==FALSE) Spec <- Spec[Spec>0]
  Prob.hat <- Spec/nT * (1 - w * (1 - Spec/nT)^nT)
  Prob.hat.Unse <- rep(a/ceiling(Q0.hat), ceiling(Q0.hat))
  return(c(Prob.hat, Prob.hat.Unse))
}


################################################################################################################
#' estimate the bootstrap population of an incidence sample which was drawn without replacement.
#' Chao, A.,... (2019).
#' bootp_one_abu_sar(x) is a function for abundance data
#' bootp_one_inc_sar(x) is a function for incidence data
#' @param Spec a vector of species abundance frequency
#' @param zero reserves zero frequency or not. Default is TRUE.
#' @param rho a numerical value as sampling fraction
#' @return a numerical vector and its length is the same as Spec
#' @examples
#' data(bird)
#' bird.abun<- bird$abun
#' Boot_p(bird.abun,zero=FALSE,Bootype="SAR",datatype="abundance",rho=0.7)
#' data(incdata)
#' Boot_p(incdata,zero=FALSE,Bootype="SAR",datatype="incidence",rho=0.7)
#############################################################################################################



bootp_one_abu_sar <- function(Spec,zero=TRUE,rho=NaN){
  if(is.nan(rho)==T)  stop("Bootype SAR invalid rho")
  if(rho>1 |rho<=0)   stop("Boottype SAR invalid rho (0<rho<=1)")
  Sobs <- sum(Spec > 0)   #observed species
  #n <- sum(Spec)        #sample size
  n <- sum(sapply(unique(Spec), function(x){ x* sum(Spec == x)}))
  N <- ceiling(n/rho)
  f1 <- sum(Spec == 1)   #singleton
  f2 <- sum(Spec == 2)   #doubleton
  f0.hat <- ifelse( f2>0, f1^2/(n/(n-1)*2*f2+rho/(1-rho)*f1), f1*(f1-1)/(n/(n-1)*2+rho/(1-rho)*f1))
  C_hat = ifelse(f2>0, 1-f1/n*(1-rho)*(n-1)*f1/((n-1)*f1+2*f2), 1-f1/n*(1-rho)*(n-1)*(f1-1)/((n-1)*(f1-1)+2))
  #lamda_hat = (1-C_hat)/sum((Spec/n)*(1-rho)^(Spec/rho))
  #if (lamda_hat == "NaN") lamda_hat=0
  lamda_hat = ifelse(rho==1, 0,  (1-C_hat)/sum((Spec/n)*(1-rho)^(Spec/rho)))


  if(zero==FALSE) Spec <- Spec[Spec>0]
  Ni_det = ceiling((Spec/rho)*(1-lamda_hat*((1-rho)^(Spec/rho))))
  Ni_det[Ni_det>N]=N
  Ni_undet = ceiling(N*(1-C_hat)/f0.hat)
  Ni_hat = c( Ni_det, rep(Ni_undet,ceiling(f0.hat)))

  temp <- unlist(sapply(1:length(Ni_hat), function(x){
    rep(x,Ni_hat[x])
  })
  )

  N_hatbyn<-as.data.frame(table(temp[sample(1:length(temp),n,replace = F)]))
  N_hat<-N_hatbyn$Freq


  return(N_hat)
}



bootp_one_inc_sar <- function (y,zero=TRUE,rho=NaN) {
  if(is.nan(rho)==T)  stop("Bootype SAR invalid rho")
  if(rho>1 |rho<=0)   stop("Boottype SAR invalid rho (0<rho<=1)")
  nT = y[1]
  y <- y[-1]
  Q1 <- sum(y == 1)
  Q2 <- sum(y == 2)
  T_star <- ceiling(nT/rho)

  Q0_hat = if(Q1==0&Q2==0 | rho==1 | nT==1) { 0 } else { Q1^2 / ( nT/(nT-1)*2*Q2 + rho/(1-rho)*Q1 ) }
  C_hat = ifelse(Q1==0&Q2==0, 1, 1-Q1/nT*(1-rho)*(nT-1)*Q1/((nT-1)*Q1+2*Q2))
  lamdba_hat = ifelse(rho==1, 0, (1-C_hat) / sum(y/nT*(1-rho)^(y/rho)))

  if(zero==FALSE) y <- y[y>0]

  M_obs_hat = if(rho==0) { 0 } else { ceiling(y/rho*(1-lamdba_hat*(1-rho)^(y/rho))) }
  M_obs_hat[M_obs_hat>T_star]=T_star
  M_unobs_hat = if(Q0_hat==0) { 0 } else { rep(ceiling(T_star * (1-C_hat)/Q0_hat), ceiling(Q0_hat)) }
  Mi_hat = c( M_obs_hat, M_unobs_hat)

  dama <- matrix(0,length(Mi_hat),T_star)
  for (j in 1:length(Mi_hat)) {
    samp <- sample(1:T_star,Mi_hat[j],replace = FALSE)
    dama[j,samp] <- 1
  }

  M_hatbynT<-rowSums(dama[,sample(1:ncol(dama),nT,replace = F)])
  M_hat<-c(nT,M_hatbynT)

  return(M_hat)


}





####################################################################################
# R code for JADE (Joint species-rank Abundance Distribution/Estimation) based on individual-based (abundance) and sampling-unit-based (incidence) data.
#' DetAbu(x, zero=FALSE) is a function of estimating detected species relative abundance.
#' @param Spec a vector of species abundance frequency
#' @param zero reserves zero frequency or not. Default is FALSE.
#' @return a numerical vector and its length is the same as Spec
#' bootp_jade_abu(Spec,zero) is a function for abundance data
#' bootp_jade_inc(Spec,zero) is a function for incidence data
#
#########################################################################################
bootp_jade_abu <- function(Spec,zero=TRUE){
  Prob.hat<-DetAbu(Spec,zero)
  Prob.hat.Unse<-UndAbu(Spec)
  return(c(Prob.hat, Prob.hat.Unse))

}

bootp_jade_inc <- function(Spec,zero=TRUE){
  Prob.hat<-DetInc(Spec,zero)
  Prob.hat.Unse<-UndInc(Spec)
  return(c(Prob.hat, Prob.hat.Unse))

}

####################################################################################
# R code for JADE (Joint species-rank Abundance Distribution/Estimation) based on individual-based (abundance) and sampling-unit-based (incidence) data.

#' DetAbu(x, zero=FALSE) is a function of estimating detected species relative abundance.
#' @param x a vector of species abundance frequency
#' @param zero reserves zero frequency or not. Default is FALSE.
#' @return a numerical vector
##############################################################################
DetAbu <- function(x, zero=FALSE){
  x <- unlist(x)
  n <- sum(x)
  f1 <- sum(x==1)
  f2 <- sum(x==2)
  f3 <- sum(x==3)

  if(f1>0 & f2>0){
    A1 <- f1 / n * ((n-1)*f1 / ((n-1)*f1 + 2*f2))
  }else if(f1>1 & f2==0){
    A1 <- (f1-1) / n * ((n-1)*f1 / ((n-1)*f1 + 2))
  }else{
    return(x/n)
  }

  if(f2>0 & f3>0){
    A2 <- f2 / choose(n, 2) * ((n-2)*f2 / ((n-2)*f2 + 3*f3))^2
  }else if(f2>1 & f3==0){
    A2 <- (f2-1) / choose(n, 2) * ((n-2)*f2 / ((n-2)*f2 + 3))^2
  }else{
    A2 <- 0
  }

  if(zero==FALSE) x <- x[x>0]
  q.solve <- function(q){
    e <- A1 / sum(x/n*exp(-q*x))
    out <- sum((x/n * (1 - e * exp(-q*x)))^2) - sum(choose(x,2)/choose(n,2)) + A2
    abs(out)
  }
  #q <- tryCatch(uniroot(q.solve, lower=0, upper=1)$root, error = function(e) {1})
  q <- tryCatch(optimize(q.solve, c(0,1))$min, error = function(e) {1})
  e <- A1 / sum(x/n*exp(-q*x))
  o <- x/n * (1 - e * exp(-q*x))
  o
}

#
#
###########################################
#' Estimating undetected species relative abundance
#'
#' \code{UndAbu} Estimating undetected species relative abundance
#' @param x a vector of species abundance frequency
#' @return a numerical vector
###############################################
UndAbu <- function(x){
  x <- unlist(x)
  n <- sum(x)
  f1 <- sum(x==1)
  f2 <- sum(x==2)
  f3 <- sum(x==3)
  f4 <- max(sum(x == 4), 1)
  f0.hat <- ceiling(ifelse(f2 == 0, (n - 1) / n * f1 * (f1 - 1) / 2, (n - 1) / n * f1 ^ 2/ 2 / f2))  #estimation of unseen species via Chao1
  if(f0.hat < 0.5){
    return(NULL)
  }

  if(f1>0 & f2>0){
    A1 <- f1 / n * ((n-1)*f1 / ((n-1)*f1 + 2*f2))
  }else if(f1>1 & f2==0){
    A1 <- (f1-1) / n * ((n-1)*f1 / ((n-1)*f1 + 2))
  }else{
    return(NULL)
  }

  if(f2>0 & f3>0){
    A2 <- f2 / choose(n, 2) * ((n-2)*f2 / ((n-2)*f2 + 3*f3))^2
  }else if(f2>1 & f3==0){
    A2 <- (f2-1) / choose(n, 2) * ((n-2)*f2 / ((n-2)*f2 + 3))^2
  }else{
    A2 <- 0
  }


  R <- ifelse(A2>0, A1^2/A2, 1)
  j <- 1:f0.hat
  f.solve <- function(x){
    out <- sum(x^j)^2 / sum((x^j)^2) - R
    abs(out)
  }
  b <-  tryCatch(optimize(f.solve, lower=(R-1)/(R+1), upper=1, tol=1e-5)$min, error = function(e) {(R-1)/(R+1)})
  a <- A1 / sum(b^j)
  p <- a * b^j
  if(f0.hat == 1) p <- A1
  p
}


#
#
###########################################
#' Estimating detected species incidence probability
#'
#' \code{DetInc} Estimating detected species incidence probability
#' @param y a vector of species incidence frequency
#' @param zero reserve zero frequency or not. Default is \code{FALSE}.
#' @return a numerical vector
##########################################
DetInc <- function(y, zero=FALSE){
  y <- unlist(y)
  nT <- max(y)
  y <- y[-1]
  Q1 <- sum(y==1)
  Q2 <- sum(y==2)
  Q3 <- sum(y==3)

  if(Q1>0 & Q2>0){
    A1 <- Q1 / nT * ((nT-1)*Q1 / ((nT-1)*Q1 + 2*Q2))
  }else if(Q1>1 & Q2==0){
    A1 <- (Q1-1) / nT * ((nT-1)*Q1 / ((nT-1)*Q1 + 2))
  }else{
    return(y/nT)
  }

  if(Q2>0 & Q3>0){
    A2 <- Q2 / choose(nT, 2) * ((nT-2)*Q2 / ((nT-2)*Q2 + 3*Q3))^2
  }else if(Q2>1 & Q3==0){
    A2 <- (Q2-1) / choose(nT, 2) * ((nT-2)*Q2 / ((nT-2)*Q2 + 3))^2
  }else{
    A2 <- 0
  }


  if(zero==FALSE) y <- y[y>0]
  q.solve <- function(q){
    e <- A1 / sum(y/T*exp(-q*y))
    out <- sum((y/nT * (1 - e * exp(-q*y)))^2) - sum(choose(y,2)/choose(nT,2)) + A2
    abs(out)
  }
  #q <- tryCatch(uniroot(q.solve, lower=0, upper=1)$root, error = function(e) {1})
  q <- tryCatch(optimize(q.solve, c(0,1))$min, error = function(e) {1})
  e <- A1 / sum(y/nT*exp(-q*y))
  o <- y/nT * (1 - e * exp(-q*y))
  o
}


#
#
###########################################
#' Estimating undetected species incidence probability
#'
#' \code{UndInc} Estimating undetected species incidence probability
#' @param y a vector of species incidence frequency.
#' @return a numerical vector
############################################
UndInc <- function(y){
  y <- unlist(y)
  nT <- max(y)
  y <- y[-1]
  Q1 <- sum(y==1)
  Q2 <- sum(y==2)
  Q3 <- sum(y==3)
  Q4 <- max(sum(y == 4), 1)
  Q0.hat <- ceiling(ifelse(Q2 == 0, (nT - 1) / nT * Q1 * (Q1 - 1) / 2, (nT - 1) / nT * Q1 ^ 2/ 2 / Q2))  #estimation of unseen species via Chao2
  if(Q0.hat < 0.5){
    return(NULL)
  }

  if(Q1>0 & Q2>0){
    A1 <- Q1 / nT * ((nT-1)*Q1 / ((nT-1)*Q1 + 2*Q2))
  }else if(Q1>1 & Q2==0){
    A1 <- (Q1-1) / nT * ((nT-1)*Q1 / ((nT-1)*Q1 + 2))
  }else{
    return(NULL)
  }

  if(Q2>0 & Q3>0){
    A2 <- Q2 / choose(nT, 2) * ((nT-2)*Q2 / ((nT-2)*Q2 + 3*Q3))^2
  }else if(Q2>1 & Q3==0){
    A2 <- (Q2-1) / choose(nT, 2) * ((nT-2)*Q2 / ((nT-2)*Q2 + 3))^2
  }else{
    A2 <- 0
  }

  R <- ifelse(A2>0, A1^2/A2, 1)
  j <- 1:Q0.hat
  f.solve <- function(x){
    out <- sum(x^j)^2 / sum((x^j)^2) - R
    abs(out)
  }
  b <-  tryCatch(optimize(f.solve, lower=(R-1)/(R+1), upper=1, tol=1e-5)$min, error = function(e) {(R-1)/(R+1)})
  a <- A1 / sum(b^j)
  p <- a * b^j
  if(Q0.hat ==1) p <- A1
  p
}




