
#######################################################################################################################
#' R code for check datatype
#' @param datatype a string "abundance", "incidence", "incidence_freq", "incidence_raw"
#' @return  a correct datatype or stop
#' @export
######################################################################################################################

check_datatype <- function(datatype){
  TYPE <- c("abundance", "incidence", "incidence_freq", "incidence_raw")
  if((is.na(pmatch(datatype, TYPE))) | (pmatch(datatype, TYPE) == -1))
    stop("invalid datatype")
  datatype <- match.arg(datatype, TYPE)
  if(datatype=="incidence_freq") datatype <- "incidence"
  return(datatype)
}


#######################################################################################################################
#' R code for check bootstrap type
#' @param Bootype a string "One", "JADE"
#' @return  a correct Bootype or stop
######################################################################################################################
check_Bootype <- function(Bootype){
  TYPE <- c("One", "JADE")
  if((is.na(pmatch(Bootype, TYPE))) | (pmatch(Bootype, TYPE) == -1))
    stop("invalid Bootype")
  return(Bootype)
}


#######################################################################################################################
#' R code for check data
#' @param x a vector
#' @param datatype a string
#' @return  if correct no return, otherwise stop
######################################################################################################################

check_data <- function(x,datatype="abundance"){
  datatype<-check_datatype(datatype)
  if(datatype == "abundance"){
    if(sum(x)==0) stop("Zero abundance counts in one or more sample sites")
  }else if (datatype=="incidence"){
    t <- x[1]
    y <- x[-1]
    if(t>sum(y)){
      warning("Insufficient data to provide reliable estimators and associated s.e.")
    }
    if(sum(y)==0) stop("Zero incidence frequencies in one or more sample sites")
    if(t<max(y)){
      stop("Your incidence data format is not correct! The first entry should be #of sampling units(T).")
    }
  }else if (datatype=="incidence_raw") warning("your incidence data format is incidence_raw")

}

