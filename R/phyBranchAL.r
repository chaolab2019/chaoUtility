#######################################################################################################################
#' R code for phylo to Chaophyabu function, we defind chaophytree objects
#' @import dplyr
#' @import tidytree
#' @import ape
#' @param phylo a phylo object
#' @param data a vector with names
#' @return  a Chaophyabu objects
#' @examples
#' data(AbuALdata)
#' adata<-AbuALdata$abudata
#' atree<-AbuALdata$tree
#' vdata<-adata$EM
#' names(vdata)<-rownames(adata)
#' refTs<-c(400,325,250)
#' result<-phy_BranchAL_Abu(atree,vdata,datatype="abundance",refTs)
#' result$treeNabu
#' result$treeH
#' result$BLbyT
#'
#'
#' @export
#'
###should input abundance by vector with names


phy_BranchAL_Abu<-function(phylo,data, datatype="abundance",refT=0,rootExtend=T,remove0=T){
  #if(class(phylo) != "phylo")
  if (!inherits(phylo, "phylo"))
    stop("invlid class: only support phylo object")

  datatype <- check_datatype(datatype)
  if(datatype=="incidence_freq" | datatype=="incidence")
    stop('only support datatype="incidence_raw"')

  labels<-names(data)
  my_match <- match(labels, phylo$tip.label)
  if(sum(is.na(my_match)) > 0) stop("Argument labels and tree Tip not matach")

  if(datatype=="abundance"){

    ###drop Abu=0 tips###
    if(remove0==T){
      dtip = phylo$tip.label[-match(names(data[data>0]), phylo$tip.label)]
      subtree = ape::drop.tip(phylo, dtip)
      subdata = data[data>0]

    }
    else{
      subtree<-phylo
      subdata<-data
    }


    ###calculate inode abundance
    chaotr<-phylo2phytree(subtree)

    #inodelist<-names(chaotr$nodes)
     tmp<-data.frame(label=names(subdata),x=subdata,stringsAsFactors=F)
     treeNdata<-full_join(chaotr$phytree, tmp, by="label")
     inodelist<-treeNdata %>% filter(tgroup !="Tip") %>% pull(node)
     names(inodelist)<-treeNdata %>% filter(tgroup !="Tip") %>% pull(label)
    inode_x<-sapply(inodelist,function(x){offspring(treeNdata,x,tiponly=T) %>% select(x) %>% sum()})


    tmp1<-data.frame(label=names(inode_x),branch.abun=inode_x)
    tmp2<-tmp %>% rename(branch.abun=x)
    tmp_all<-rbind(tmp2,tmp1)
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

phy_L_Abu_T_<-function(treeNdata,t_1,rootExtend=T,treeH=0){
  rootlength<-0
  if (t_1>0){
    if(rootExtend==T & t_1>treeH) rootlength<-t_1-treeH
  }
  phyAL<-treeNdata %>% mutate(branch.height=ifelse(tgroup=="Tip",branch.length,node.age))
  phyAL<-phyAL %>% mutate(cumsum.length=ifelse(tgroup=="Tip",branch.length,node.age+branch.length))
  phyAL$refT<-t_1
  phyAL<-phyAL %>% mutate(tmp=cumsum.length-refT)
  phyAL<-phyAL %>% mutate(branch.length.new=ifelse(tgroup=="Root",rootlength,
                                                   ifelse(tmp<0,branch.length,
                                                          ifelse(tgroup=="Tip",branch.length-tmp,
                                                                 ifelse(node.age>refT,0,refT-node.age)))))
  branch.length.byT<-phyAL %>% pull(branch.length.new)
  names(branch.length.byT)<-phyAL %>% pull(label)
  tout <- list("branchL"=branch.length.byT)
  return(tout)
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
#' data(AbuALdata)
#' adata<-AbuALdata$abudata
#' atree<-AbuALdata$tree
#' vdata<-adata$EM
#' names(vdata)<-rownames(adata)
#' refTs<-c(400,325,250)
#' result<-phyBranchAL_Abu(atree,vdata,datatype="abundance",refTs)
#' result$treeNabu
#' result$treeH
#' result$BLbyT
#'
#'
#' @export
#'
###should input abundance by vector with names
phyBranchAL_Abu<-function(phylo,data, datatype="abundance",refT=0,rootExtend=T,remove0=T){
  #if(class(phylo) != "phylo")
  if (!inherits(phylo, "phylo"))
    stop("invlid class: only support phylo object")

  datatype <- check_datatype(datatype)
  if(datatype=="incidence_freq" | datatype=="incidence")
    stop('only support datatype="incidence_raw"')

  labels<-names(data)
  my_match <- match(labels, phylo$tip.label)
  if(sum(is.na(my_match)) > 0) stop("Argument labels and tree Tip not matach")


  if(datatype=="abundance"){

    ###drop Abu=0 tips###
    if(remove0==T){
      dtip = phylo$tip.label[-match(names(data[data>0]), phylo$tip.label)]
      subtree = ape::drop.tip(phylo, dtip)
      subdata = data[data>0]

    }
    else{
      subtree<-phylo
      subdata<-data
    }

    phylo.root<-length(subtree$tip.label)+1

    edgelength<-ape::node.depth.edgelength(subtree)
    #treeH<-max(ape::node.depth.edgelength(subtree))
    treeH<-max(edgelength)

    ##change to tibble format: easy to read
    phylo.t <- tidytree::as_tibble(subtree)



    # phylo.t.1<-phylo.t %>% mutate(tgroup=case_when(node<phylo.root ~"Tip",
    #                                                node==phylo.root ~"Root",
    #                                                TRUE ~"Inode"),
    #                               newlabel=case_when(node-phylo.root==0 & label =="" ~ "Root",
    #                                                  label=="" ~paste("I",node-phylo.root,sep=""),
    #                                                  TRUE ~ label)) %>% select(-label) %>% rename(label=newlabel)

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

    tmp<-tibble(label=names(subdata),x=subdata)
    treeNdata<-full_join(phylo.t.1, tmp, by="label")
    inodelist<-treeNdata %>% filter(tgroup !="Tip") %>% pull(node)
    names(inodelist)<-treeNdata %>% filter(tgroup !="Tip") %>% pull(label)
    inode_x<-sapply(inodelist,function(x){offspring(treeNdata,x,tiponly=T) %>% select(x) %>% sum()})

    tmp_all<-bind_rows(tibble(label=names(subdata),branch.abun=subdata),tibble(label=names(inode_x),branch.abun=inode_x))
    treeNdata<-full_join(treeNdata, tmp_all, by="label") %>% select(-x,-edgelengthv,-node.age)

    phyL<-sapply(refT,function(y) phyL_Abu_T_(treeNdata,y,rootExtend,treeH))
    colnames(phyL)<-paste("T",refT,sep="")
    treeNdata<-treeNdata %>% select(-branch.height)


    z <- list("treeNabu"=treeNdata,"treeH"=treeH,"BLbyT"=phyL)
    class(z) <- "Chaophyabu"
    return(z)
  }

}

phyL_Abu_T_<-function(treeNdata,t_1,rootExtend=T,treeH=0){
  rootlength<-0
  if (t_1>0){
    if(rootExtend==T & t_1>treeH) {
      rootlength<-t_1-treeH
      phyAL<-treeNdata %>% mutate(branch.length.new=case_when(tgroup=="Root" ~ rootlength,
                                                              TRUE~ branch.length)
      )
    }
    else{
      phyAL<-treeNdata %>% mutate(branch.length.new=case_when(tgroup=="Root" ~ rootlength,
                                                              branch.height>=t_1 ~ pmax(0,branch.length-branch.height+t_1),
                                                              TRUE~ branch.length))
    }
  }
  else stop("reference T should >0 ")

  branch.length.byT<-phyAL %>% pull(branch.length.new)
  names(branch.length.byT)<-phyAL %>% pull(label)
  return(branch.length.byT)
}


