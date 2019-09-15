
#######################################################################################################################
#' R code for phylo to phylog like function, we defind chaolabphy objects
#' @import dplyr
#' @import tidytree
#' @param phylo a phylo object
#' @return  a chaolabphy objects
#' @examples
#' data(treesample)
#' newphy<-phylo2chaolabphy(treesample)
#' leaves <- newphy$leaves
#' nodes<- newphy$nodes
#' parts<- newphy$parts
#'
#' @export

phylo2chaolabphy<-function(phylo)
{
  if(class(phylo) != "phylo")
    stop("invlid class: only support phylo object")

  phylo.root<-length(phylo$tip.label)+1

  ##change to tibble format: easy to read
  phylo.t <- tidytree::as_tibble(phylo)

  ###leaves
  phylo.t.leaves<-phylo.t %>% filter(node<phylo.root)
  data.leaves<-phylo.t.leaves$branch.length
  names(data.leaves) <- phylo.t.leaves$label
 # print("data.leaves")
#  print(data.leaves)

  ###nodes
  phylo.t.nodes<-phylo.t %>% filter(node>=phylo.root)
  phylo.t.nodes<-phylo.t.nodes %>% mutate(Inode=node-phylo.root)
  phylo.t.nodes<-phylo.t.nodes %>% mutate(Inode2=ifelse(Inode==0,0,max(Inode)-Inode+1))
  phylo.t.nodes<-phylo.t.nodes %>% mutate(newlable=ifelse(Inode==0,"Root",paste("I",Inode,sep="")))
  #subtree.tibble.2<-subtree.tibble.2 %>% mutate(newlable=ifelse(Inode2==0,"Root",paste("I",Inode2,sep="")))
  phylo.t.nodes<-phylo.t.nodes %>% mutate(label.new=ifelse(is.na(label)|label=="",newlable,label))
  phylo.t.nodes<-phylo.t.nodes %>% mutate(length.new=ifelse(is.na(branch.length),0,branch.length))
  data.nodes<-phylo.t.nodes$length.new
  names(data.nodes) <- phylo.t.nodes$label.new
 # print("data.nodes")
#  print(data.nodes)

  ####combine
  phylo.t.nodes<-phylo.t.nodes %>% select("parent", "node", "branch.length", "label","label.new","length.new")
  phylo.t.leaves<-phylo.t.leaves %>% mutate(label.new=label,length.new=branch.length)
  phylo.t.all<-rbind(phylo.t.leaves,phylo.t.nodes)
  phylo.t.all.1 <- phylo.t.all %>% select("parent", "node","label.new","length.new") %>% rename(label=label.new,branch.length=length.new)
  inodes<-phylo.t.all.1$node[phylo.t.all.1$node>=phylo.root]
  inodes.name<-phylo.t.all.1$label[phylo.t.all.1$node>=phylo.root]
  # y<-rev(x)
  #  namey<-rev(name)
  data.parts = list()
  data.parts<-lapply(1:length(inodes),function(x){child(phylo.t.all.1,inodes[x])%>% pull(label)})
  names(data.parts)<-inodes.name

  # data.parts = list()
  # for(i in 1:length(inodes)){
  #   tmp<-child(phylo.t.all.1,inodes[i])%>% pull(label)
  #   data.parts[[i]] <- tmp
  # }
  # names(data.parts) = inodes.name

  z <- list("leaves"=data.leaves, "nodes"=data.nodes, "parts"=data.parts)
  class(z) <- "chaolabphy"
  return(z)
}


#######################################################################################################################
#' R code for phylo to phytree function, we defind chaophytree objects
#' @import dplyr
#' @import tidytree
#' @param phylo a phylo object
#' @return  a chaophytree objects
#' @examples
#' data(treesample)
#' newphy<-phylo2phytree(treesample)
#' leaves <- newphy$leaves
#' nodes<- newphy$nodes
#' treedata<-newphy$phytree
#' treeH<-newphy$treeH
#'
#'
#' @export
#'

phylo2phytree<-function(phylo){
  if(class(phylo) != "phylo")
    stop("invlid class: only support phylo object")

  phylo.root<-length(phylo$tip.label)+1

  ##change to tibble format: easy to read
  phylo.t <- tidytree::as_tibble(phylo)

  ###leaves
  phylo.t.leaves<-phylo.t %>% filter(node<phylo.root)
  data.leaves<-phylo.t.leaves$branch.length
  names(data.leaves) <- phylo.t.leaves$label

  ###nodes
  phylo.t.nodes<-phylo.t %>% filter(node>=phylo.root)
  phylo.t.nodes<-phylo.t.nodes %>% mutate(Inode=node-phylo.root)
  phylo.t.nodes<-phylo.t.nodes %>% mutate(newlable=ifelse(Inode==0,"Root",paste("I",Inode,sep="")))
  phylo.t.nodes<-phylo.t.nodes %>% mutate(label.new=ifelse(is.na(label)|label=="",newlable,label))
  phylo.t.nodes<-phylo.t.nodes %>% mutate(length.new=ifelse(is.na(branch.length),0,branch.length))
  data.nodes<-phylo.t.nodes$length.new
  names(data.nodes) <- phylo.t.nodes$label.new

  ###combine leave node to complete data
  phylo.t.nodes<-phylo.t.nodes %>% select(parent,node,length.new,label.new) %>% rename(branch.length=length.new,label=label.new)
  phylo.t.all<-rbind(phylo.t.leaves,phylo.t.nodes)
  phylo.t.all<-phylo.t.all %>% mutate(tgroup=ifelse(node<phylo.root,"leaves",ifelse(node==phylo.root,"Root","nodes")))


  ##add treeH
  treeH<-max(ape::node.depth.edgelength(phylo))


  ##add node.age
  edgelength<-ape::node.depth.edgelength(phylo)
 # node.age<-treeH-ape::node.depth.edgelength(phylo)
  node.age<-sapply(1:length(edgelength),function(x){ifelse(isTRUE(all.equal(edgelength[x],treeH)),0,treeH-edgelength[x])})
  phylo.t.all<-phylo.t.all %>% mutate(node.age=node.age)

  z <- list("leaves"=data.leaves, "nodes"=data.nodes, "phytree"=phylo.t.all,"treeH"=treeH)
  class(z) <- "chaophytree"
  return(z)

}


