phyLengthbyT_ <- function(t_1, phy, datatype="abundance",rootExtend=F){
  if (!inherits(phy, "chaophytree"))
    stop("Non convenient data : only for chaophytree object")

  datatype <- check_datatype(datatype)

  if(datatype=="incidence_freq" | datatype=="incidence")
    stop('only support datatype="incidence_raw"')

  rootlength<-0
  if(rootExtend==T & t_1>phy$treeH) rootlength<-t_1-phy$treeH

  if(datatype=="abundance"){
    phytable<-phy$phytree
    phytable<-phytable %>% mutate(branch.height=ifelse(tgroup=="leaves",branch.length,node.age))
    phytable<-phytable %>% mutate(cumsum.length=ifelse(tgroup=="leaves",branch.length,node.age+branch.length))
    phytable$t1<-t_1
    phytable<-phytable %>% mutate(tmp=cumsum.length-t_1)
    phytable<-phytable %>% mutate(branch.length.new=ifelse(tgroup=="Root",rootlength,
                                                           ifelse(tmp<0,branch.length,
                                                                  ifelse(tgroup=="leaves",branch.length-tmp,
                                                                         ifelse(node.age>t1,0,t1-node.age)))))

    branch.length.byT<-phytable %>% pull(branch.length.new)
    names(branch.length.byT)<-phytable %>% pull(label)



  }else if(datatype=="incidence_raw"){
    # y <- iNEXT::as.incfreq(x)
    # t <- y[1]
    # y <- y[-1]
    # names(y) <- labels
    # y <- y[names(phy$leaves)]
    # Ut <- sum(y)
    #
    # rownames(x) <- labels
    # x <- x[names(phy$leaves),]
    #
    # for(i in 1:length(phy$parts)){
    #   x <- rbind(x, colSums(x[phy$parts[[i]],])>0)
    #   rownames(x)[nrow(x)] <- names(phy$parts)[i]
    # }
    # yy <- rowSums(x)
    # data.frame("branch_abun"=yy, "branch_length"=c(phy$leaves, phy$nodes))
  }
  return(branch.length.byT)
}


###########################################
#' Calculate branch length by reference ageT
#'
#' \code{phyLengthbyT}: Calculate branch length by reference ageT
#'
#' @param Tx a numerical vector of ageT.\cr
#' @param phy a phylogenetic tree with \code{"chaophytree"} class.\cr
#' @param datatype data type of input data: individual-based abundance data (\code{datatype = "abundance"}), species by sampling-units incidence matrix (\code{datatype = "incidence_raw"}).
#' @return a maxtrix with new branch length by ageT(Tx).
#' @examples
#' data(phybird)
#' bird.abu <- phybird$abun
#' bird.inc <- phybird$inci
#' bird.lab <- rownames(phybird$abun)
#' bird.phy <- phybird$chaophytree
#' phyLengthbyT(Ts=c(75,55),  phy=bird.phy, datatype="abundance")
#'
#' @export
phyLengthbyT<- function(Ts, phy, datatype="abundance",rootExtend=F){
  if (!inherits(phy, "chaophytree"))
    stop("Non convenient data : only for chaophytree object")

  datatype <- check_datatype(datatype)

  if(datatype=="incidence_freq" | datatype=="incidence")
    stop('only support datatype="incidence_raw"')


  sapply(Ts,function(x) phyLengthbyT_(x, phy, datatype,rootExtend))

}

