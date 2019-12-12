phyExpandData_ <- function(x, labels, phy, datatype="abundance"){
  if (!inherits(phy, "chaophytree"))
    stop("Non convenient data : only for chaophytree object")

  datatype <- check_datatype(datatype)

  if(datatype=="incidence_freq" | datatype=="incidence")
    stop('only support datatype="incidence_raw"')

  my_match <- match(labels, names(phy$tips))
  if(sum(is.na(my_match)) > 0) stop("Argument labels and tree Tip not matach")



  if(datatype=="abundance"){
    if(length(x) !=length(labels)) stop("Length of labels and abundance data not matach")
    tmp<-data.frame(label=labels,x=x)
    tmp$label<-as.character(tmp$label)
    treeNdata<-full_join(phy$phytree, tmp, by="label")
    inodelist<-treeNdata %>% filter(tgroup !="Tip") %>% pull(node)
    names(inodelist)<-treeNdata %>% filter(tgroup !="Tip") %>% pull(label)
    inode_x<-sapply(inodelist,function(x){offspring(treeNdata,x,tiponly=T) %>% select(x) %>% sum()})

    tmp1<-data.frame(label=names(inode_x),branch.abun=inode_x)
    tmp2<-tmp %>% rename(branch.abun=x)
    tmp_all<-rbind(tmp2,tmp1)
    treeNdata<-full_join(treeNdata, tmp_all, by="label") %>% select(-x)


  }else if(datatype=="incidence_raw"){

    if(nrow(x) !=length(labels)) stop("Length of labels and incidence data not matach")
    y <- iNEXT::as.incfreq(x)
    t <- y[1]
    y <- y[-1]
    names(y) <- labels
    tmp.tip<-data.frame(label=labels,x=y)
    tmp.tip$label<-as.character(tmp.tip$label)
    treeNdata<-full_join(phy$phytree, tmp.tip, by="label")


    inode_each<-apply(x,2,function(i){
      tmp<-data.frame(label=labels,x=i)
      tmp$label<-as.character(tmp$label)
      tmp.treeNdata<-full_join(phy$phytree, tmp, by="label")
      inodelist<-tmp.treeNdata %>% filter(tgroup !="Tip") %>% pull(node)
      names(inodelist)<-tmp.treeNdata %>% filter(tgroup !="Tip") %>% pull(label)
      ivalue_each<-sapply(inodelist,function(x){offspring(tmp.treeNdata,x,tiponly=T) %>% select(x) %>% max()})
    })
    inode_x <- rowSums(inode_each)
    tmp.inode<-data.frame(label=names(inode_x),branch.abun=inode_x)

    tmp.tip<-tmp.tip %>% rename(branch.abun=x)
    tmp_all<-rbind(tmp.tip,tmp.inode)
    treeNdata<-full_join(treeNdata, tmp_all, by="label") %>% select(-x)


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
#' data(phybird.new)
#' bird.abu <- phybird.new$abun
#' bird.inc <- phybird.new$inci
#' bird.lab <- rownames(phybird.new$abun)
#' bird.phy <- phybird.new$chaophytree
#' phyExpandData(bird.abu, labels=bird.lab, phy=bird.phy, datatype="abundance")
#' phyExpandData(bird.inc, labels=bird.lab, phy=bird.phy, datatype="incidence_raw")
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

