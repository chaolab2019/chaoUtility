
#######################################################################################################################
#' R code for JADE (Joint species-rank Abundance Distribution/Estimation): two parameters &
#' 2013 Entropy and the species accumulation curve Appendix S2: Estimating species relative abundance :one parameter
#' based on individual-based (abundance) and sampling-unit-based (incidence) data.
#' @param Bootype a string= "JADE" or "One". Default is "One"
#' @param datatype a string
#' @param x a vector/matrix/list of species abundance frequency
#' @param zero reserves zero frequency or not. Default is TRUE.
#' @return  a vector/matrix/list with species relative abundance or detection probability distribution
#' @examples
#' data(bird)
#' bird.inc <- bird$inci
#' bird.abun<- bird$abun
#' Boot_p(bird$abun, datatype="abundance")
#' Boot_p(bird$abun, datatype="incidence_raw")
#' @export

Boot_p<-function(x,zero=TRUE,Bootype="One",datatype="abundance"){
  datatype <- check_datatype(datatype)
  Bootype <- check_Bootype(Bootype)
  if(class(x)=="list"){
    lapply(x, function(x) Boot_p_(x,zero,Bootype, datatype))
  }else if(class(x) %in% c("matrix","data.frame") & datatype=="abundance"){
    apply(x, 2, function(x) Boot_p_(x,zero,Bootype, datatype))
  }else{
    Boot_p_(x,zero,Bootype, datatype)
  }
}


Boot_p_<-function(x,zero=TRUE,Bootype="One",datatype="abundance")
{

  check_data(x,datatype)
  if(datatype == "abundance"){
    if(Bootype =="One") out_p <- bootp_one_abu(x,zero)
    else if(Bootype =="JADE") out_p <- bootp_jade_abu(x,zero)

  }else if (datatype == "incidence"){
    if(Bootype =="One") out_p <- bootp_one_inc(x,zero)
    else if(Bootype =="JADE") out_p <- bootp_jade_inc(x,zero)
  }else if (datatype == "incidence_raw"){
    xx <- iNEXT::as.incfreq(x)
    if(Bootype =="One") out_p <- bootp_one_inc(xx,zero)
    else if(Bootype =="JADE") out_p <- bootp_jade_inc(xx,zero)

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
#'
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
  b <- sum(Spec / n * (1 - Spec / n) ^ n)
  if(f0.hat==0){
    w <- 0
    if(sum(Spec>0)==1){
      warning("This site has only one species. Estimation is not robust.")
    }
  }else{
    w <- a / b      	#adjusted factor for rare species in the sample
  }

  if(zero==FALSE) Spec <- Spec[Spec>0]
  Prob.hat <- Spec / n * (1 - w * (1 - Spec / n) ^ n)					#estimation of relative abundance of observed species in the sample
  Prob.hat.Unse <- rep(a/ceiling(f0.hat), ceiling(f0.hat))  	#estimation of relative abundance of unseen species in the sample
  return(c(Prob.hat, Prob.hat.Unse))		  							#Output: a vector of estimated relative abundance
}


bootp_one_inc <- function (Spec,zero=TRUE) {
  nT <- Spec[1]
  Spec <- Spec[-1]
  Sobs <- sum(Spec > 0)
  Q1 <- sum(Spec == 1)
  Q2 <- sum(Spec == 2)
  Q0.hat <- ifelse(Q2 == 0, (nT - 1)/nT * Q1 * (Q1 - 1)/2,
                   (nT - 1)/nT * Q1^2/2/Q2)
  A <- ifelse(Q1 > 0, nT * Q0.hat/(nT * Q0.hat + Q1), 1)
  a <- Q1/nT * A
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


