phyExpandData_ <- function(x, labels, phy, datatype="abundance"){
  if (!inherits(phy, "chaophytree"))
    stop("Non convenient data : only for chaophytree object")

  datatype <- check_datatype(datatype)

  if(datatype=="incidence_freq" | datatype=="incidence")
    stop('only support datatype="incidence_raw"')

  my_match <- match(labels, names(phy$leaves))
  if(sum(is.na(my_match)) > 0) stop("Argument labels and tree leaves not matach")

  if(datatype=="abundance"){
    tmp<-data.frame(label=labels,x=x)
    tmp$label<-as.character(tmp$label)
    treeNdata<-full_join(phy$phytree, tmp, by="label")
    inodelist<-treeNdata %>% filter(tgroup !="leaves") %>% pull(node)
    names(inodelist)<-treeNdata %>% filter(tgroup !="leaves") %>% pull(label)
    inode_x<-sapply(inodelist,function(x){offspring(treeNdata,x,tiponly=T) %>% select(x) %>% sum()})

    tmp1<-data.frame(label=names(inode_x),branch.abun=inode_x)
    tmp2<-tmp %>% rename(branch.abun=x)
    tmp_all<-rbind(tmp2,tmp1)
    treeNdata<-full_join(treeNdata, tmp_all, by="label") %>% select(-x)


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
  return(treeNdata)
}


###########################################
#' Expand branch abundance/incience and branch length
#'
#' \code{phyExpandData}: Expand branch abundance/incience and branch length
#'
#' @param x a vector/matrix/list of species abundances or a matrix of raw incidence table.\cr
#' @param labels a vector of species name for input data.\cr
#' @param phy a phylogenetic tree with \code{"chaophytree"} class.\cr
#' @param datatype data type of input data: individual-based abundance data (\code{datatype = "abundance"}), species by sampling-units incidence matrix (\code{datatype = "incidence_raw"}).
#' @return a tibble tree with abundances.
#' @examples
#' data(phybird)
#' bird.abu <- phybird$abun
#' bird.inc <- phybird$inci
#' bird.lab <- rownames(phybird$abun)
#' bird.phy <- phybird$chaophytree
#' phyExpandData(bird.abu, labels=bird.lab, phy=bird.phy, datatype="abundance")
#'
#' @export
phyExpandData <- function(x, labels, phy, datatype="abundance"){
  if (!inherits(phy, "chaophytree"))
    stop("Non convenient data : only for chaophytree object")

  datatype <- check_datatype(datatype)

  if(datatype=="incidence_freq" | datatype=="incidence")
    stop('only support datatype="incidence_raw"')

  if(class(x)=="list"){
    lapply(x, function(x) phyExpandData_(x, labels, phy, datatype))
  }else if(class(x) %in% c("matrix","data.frame") & datatype=="abundance"){
    apply(x, 2, function(x) phyExpandData_(x, labels, phy, datatype))
  }else{
    phyExpandData_(x, labels, phy, datatype)
  }
}

