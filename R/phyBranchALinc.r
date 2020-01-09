#######################################################################################################################
#' R code for phylo to Chaophyabu function, we defind chaophytree objects
#' @import dplyr
#' @import tidytree
#' @import ape
#' @param phylo a phylo object
#' @param data a vector with names
#' @return  a Chaophyabu objects
#' @examples
#' data(phybird.new)
#' bird.abu <- phybird.new$abun
#' bird.inc <- phybird.new$inci
#' bird.lab <- rownames(phybird.new$abun)
#' bird.phy <- phybird.new$chaophytree
#' tree<-tidytree::as.phylo(bird.phy$phytree)
#' Idata<-bird.inc$North.site

#' refTs<-c(80,90,100)
#' result<-phy_BranchAL_Inc(tree,Idata,datatype="incidence_raw",refTs)
#' result$treeNabu
#' result$treeH
#' result$BLbyT
#'
#'
#' @export
#'
###should input incidence by vector with names


phy_BranchAL_Inc<-function(phylo,data, datatype="incidence_raw",refT=0,rootExtend=T,remove0=T){
  #if(class(phylo) != "phylo")
  if (!inherits(phylo, "phylo"))
    stop("invlid class: only support phylo object")

  datatype <- check_datatype(datatype)
  if(datatype=="incidence_freq" | datatype=="incidence")
    stop('only support datatype="incidence_raw"')

  labels<-rownames(data)
  my_match <- match(labels, phylo$tip.label)
  if(sum(is.na(my_match)) > 0) stop("Argument labels and tree Tip not matach")

  ###drop Abu=0 tips ###
  if(remove0==T){
    if(datatype=="abundance"){
      sp = unique(names(data)[data>0])
      subdata = data[sp]

    }
    else if(datatype=="incidence_raw"){
      sp = unique(rownames(data)[rowSums(data)>0])
      subdata = data[sp, ]
    }
    dtip <- phylo$tip.label[-match(sp,phylo$tip.label)]
    subtree = ape::drop.tip(phylo, dtip)
  }
  else{
    subtree<-phylo
    subdata<-data
  }

  labels<-rownames(subdata)

  ###subtree change to chaophytree object
  chaotr<-phylo2phytree(subtree)

  ###calculate ExpandData

  if(datatype=="incidence_raw"){
    y <- iNEXT::as.incfreq(subdata)
    t <- y[1]
    y <- y[-1]
    names(y) <- labels
    tmp.tip<-data.frame(label=names(y),x=y,stringsAsFactors=F)
    treeNdata<-full_join(chaotr$phytree, tmp.tip, by="label")

    inode_each<-apply(subdata,2,function(i){
      tmp<-data.frame(label=labels,x=i)
      tmp$label<-as.character(tmp$label)
      tmp.treeNdata<-full_join(chaotr$phytree, tmp, by="label")
      inodelist<-tmp.treeNdata %>% filter(tgroup !="Tip") %>% pull(node)
      names(inodelist)<-tmp.treeNdata %>% filter(tgroup !="Tip") %>% pull(label)
      ivalue_each<-sapply(inodelist,function(x){offspring(tmp.treeNdata,x,tiponly=T) %>% select(x) %>% max()})
    })
    inode_x <- rowSums(inode_each)
    tmp.inode<-data.frame(label=names(inode_x),branch.abun=inode_x)

    tmp.tip<-tmp.tip %>% rename(branch.abun=x)
    tmp_all<-rbind(tmp.tip,tmp.inode)
    treeNdata<-full_join(treeNdata, tmp_all, by="label") %>% select(-x)


    ###calculate inode length
    # treeH and rootlength
    treeH<-chaotr$treeH

    phyL<-sapply(refT,function(y) phy_L_Abu_T_(treeNdata,y,rootExtend,treeH))
    names(phyL)<-paste("T",refT,sep="")

    z <- list("treeNabu"=treeNdata,"treeH"=treeH,"BLbyT"=phyL)
    class(z) <- "Chaophyabu"
    return(z)

  }

}

#######################################################################################################################
#' R code for phylo to Chaophyabu function, speed up performance
#' @import dplyr
#' @import tidytree
#' @import ape
#' @param phylo a phylo object
#' @param data a vector with names
#' @return  a Chaophyabu objects
#' @examples

#' data(phybird.new)
#' bird.inc <- phybird.new$inci
#' bird.lab <- rownames(phybird.new$abun)
#' bird.phy <- phybird.new$chaophytree
#' tree<-tidytree::as.phylo(bird.phy$phytree)
#' Idata<-bird.inc$North.site

#' refTs<-c(80,90,100)
#' result<-phyBranchAL_Abu(tree,Idata,datatype="incidence_raw",refTs)
#' result$treeNabu
#' result$treeH
#' result$BLbyT
#'
#'
#' @export
#'
###should input abundance by vector with names
phyBranchAL_Inc<-function(phylo,data, datatype="incidence_raw",refT=0,rootExtend=T,remove0=T){
  if (!inherits(phylo, "phylo"))
    stop("invlid class: only support phylo object")

  datatype <- check_datatype(datatype)
  if(datatype=="incidence_freq" | datatype=="incidence")
    stop('only support datatype="incidence_raw"')

  labels<-rownames(data)
  my_match <- match(labels, phylo$tip.label)
  if(sum(is.na(my_match)) > 0) stop("Argument labels and tree Tip not matach")

  ###drop Abu=0 tips ###
  if(remove0==T){
    if(datatype=="abundance"){
      sp = unique(names(data)[data>0])
      subdata = data[sp]

    }
    else if(datatype=="incidence_raw"){
      sp = unique(rownames(data)[rowSums(data)>0])
      subdata = data[sp, ]
    }
    dtip <- phylo$tip.label[-match(sp,phylo$tip.label)]
    subtree = ape::drop.tip(phylo, dtip)
  }
  else{
    subtree<-phylo
    subdata<-data
  }

  labels<-rownames(subdata)


  if(datatype=="incidence_raw"){
    phylo.root<-length(subtree$tip.label)+1

    edgelength<-ape::node.depth.edgelength(subtree)
    #treeH<-max(ape::node.depth.edgelength(subtree))
    treeH<-max(edgelength)

    ##change to tibble format: easy to read
    phylo.t <- tidytree::as_tibble(subtree)
    phylo.t.1<-phylo.t %>% mutate(branch.length=replace(branch.length, is.na(branch.length),0),
                                  tgroup=case_when(node<phylo.root ~"Tip",
                                                   node==phylo.root ~"Root",
                                                   TRUE ~"Inode"),
                                  newlabel=case_when(node-phylo.root==0 & (label ==""|is.na(label)) ~ "Root",
                                                     label==""|is.na(label) ~paste("I",node-phylo.root,sep=""),
                                                     TRUE ~ label ),
                                  edgelengthv=edgelength,
                                  node.age=case_when(edgelengthv==treeH~0,
                                                     TRUE ~ treeH-edgelengthv),
                                  branch.height=case_when(tgroup=="Tip" ~ branch.length,
                                                          tgroup=="Root"~treeH,
                                                          TRUE ~branch.length+node.age )
                                   ) %>% select(-label) %>% rename(label=newlabel)


    y <- iNEXT::as.incfreq(subdata)
    t <- y[1]
    y <- y[-1]
    names(y) <- labels
    tmp.tip<-data.frame(label=names(y),x=y,stringsAsFactors=F)
    treeNdata<-full_join(phylo.t.1, tmp.tip, by="label")

    inode_each<-apply(subdata,2,function(i){
      tmp<-data.frame(label=labels,x=i)
      tmp$label<-as.character(tmp$label)
      tmp.treeNdata<-full_join(phylo.t.1, tmp, by="label")
      inodelist<-tmp.treeNdata %>% filter(tgroup !="Tip") %>% pull(node)
      names(inodelist)<-tmp.treeNdata %>% filter(tgroup !="Tip") %>% pull(label)
      ivalue_each<-sapply(inodelist,function(x){offspring(tmp.treeNdata,x,tiponly=T) %>% select(x) %>% max()})
    })
    inode_x <- rowSums(inode_each)
    tmp.inode<-data.frame(label=names(inode_x),branch.abun=inode_x)

    tmp.tip<-tmp.tip %>% rename(branch.abun=x)
    tmp_all<-rbind(tmp.tip,tmp.inode)
    treeNdata<-full_join(treeNdata, tmp_all, by="label") %>% select(-x,-edgelengthv,-node.age)

    phyL<-sapply(refT,function(y) phyL_Abu_T_(treeNdata,y,rootExtend,treeH))
    colnames(phyL)<-paste("T",refT,sep="")
    treeNdata<-treeNdata %>% select(-branch.height)


    z <- list("treeNabu"=treeNdata,"treeH"=treeH,"BLbyT"=phyL)
    class(z) <- "Chaophyabu"
    return(z)
  }

}


