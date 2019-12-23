A Quick introudction for chaolab utility
================

<!-- README.md is generated from README.Rmd. Please edit that file -->
overview
========

``` r
library(chaoUtility)
```

`chaoUtility` focuses on some useful tools for chao lab, include:

general functions:[`Boot_p()`](#boot_p) and `checktype()`

phylogeny fucntions:

-[`phylo2phytree()`](#phylo2phytree) : input phylo object([ultrmetric](#examples-ultrametictree) or [non-ultrametric](#examples-non-ultrametictree)), return chaophytree object

-[`phyExpandData()`](#phyexpanddata) : input abundance data, label,chaophytree object, return tibble with abundance or [incidence data](#examples-incidence-simple-data).

-[`phyExpandData()`](#phyexpanddata) : input abundance data, label,chaophytree object, return tibble with abundance or [incidence data](#examples-incidence-simple-data).

-[`phylengthbyT()`](#phylengthbyt) : input vector of ageT, chaophytree object, return matrix with label and new branch.length (default `rootExtend =T` ,if `rootExtend=T and ageT>treeH`, root.length=ageT-treeH), [non ultrametric tree example](#examples-non-ultrametric-tree-by-reference-t)

-[`phyBranchAL()`](#phybranchal) : input abundance data,phylo object,vector of ageTs, return Chaophyabu object (default `rootExtend =T` ,`removeAbu0=T`)

-`phylo2chaolabphy()`

HOW TO RUN chaoUtility:
-----------------------

The `chaoUtility` package can be downloaded with a standard R installation procedure using the following commands.

``` r
## install the latest version from github
install.packages('devtools')
library(devtools)
install_github('chaolab2019/chaoUtility')
```

Boot\_p
-------

We first describe the main function `Boot_p()` with default arguments:

``` r
Boot_p(x,zero=TRUE,Bootype="One",datatype="abundance")
```

<table style="width:100%;">
<colgroup>
<col width="20%">
<col width="80%">
</colgroup>
<thead>
<tr class="header">
<th align="center">
Argument
</th>
<th align="left">
Description
</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="center">
<code>x</code>
</td>
<td align="left">
a <code>matrix</code>, <code>data.frame</code>, <code>lists</code> of species abundances or incidence data.
</td>
</tr>
<tr class="even">
<td align="center">
<code>zero</code>
</td>
<td align="left">
reserves zero frequency or not. Default is TRUE.
</td>
</tr>
<tr class="odd">
<td align="center">
<code>Bootype</code>
</td>
<td align="left">
<code>character</code> : "One" or "JADE" or "SAR". `Bootype = "One"` or `Bootype = "JADE"` or `Bootype = "SAR"`<br> "One": from \#99 2013 Entropy and the species accumulation curve Appendix S2: Estimating species relative abundance. <br>"JADE": from \#107 Unveiling the species-rank abundance distribution by generalizing the Good-Turing sample coverage theory. <br>"SAR": :sampleing which was drawn without replacement (based on one parameter estimated method)
</td>
<tr class="even">
<td align="center">
<code>datatype</code>
</td>
<td align="left">
data type of input data: individual-based abundance data (`datatype = "abundance"`), or species by sampling-units incidence frequency (`datatype = "incidence_freq"` or `datatype = "incidence"`),or species by sampling-units incidence matrix (`datatype = "incidence_raw"`).
</td>
</tbody>
</table>
EXAMPLES
--------

without replacement:

``` r
library(chaoUtility)
data(bird)
bird.abun<- bird$abun
Boot_p(bird$abun,zero=FALSE,Bootype="SAR",datatype="abundance",rho=0.8)
$North.site
 [1] 37  2  1  7  4  3 13  1  2  6 11  2 12 11  2  2 13 14  1  2  7  2 17
[24]  7  3  4 13  2  1

$South.site
 [1]  4 18 30  2  2  1  5  2  6 32  5 10  1  5  5  6 10 16  3 12  8  1 14
[24]  4 16  2  2  8  7  2  4 18 14  2  6  3  2 17  2

data(incdata)
Boot_p(incdata,zero=FALSE,Bootype="SAR",datatype="incidence",rho=0.8)
$Monsoon
plots                                                                   
  191    10     9     4    31     1    64     1     1     8     9     3 
                                                                        
    1     2     2    46     7     3     1    52     4     8    16    61 
                                                                        
  129    22     0    15     3     2     8     2     1   101     2     1 
                                                                        
    3     2     7     2    26     1     3    30     7     2    14     4 
                                                                        
    1     5    44     7    84    36     3     2     3     6     5     4 
                                                                        
    4    19     7    16    26     2     2    37     4    29     1    40 
                                                                        
    4     3    72     7     2    31    35    21    15    33    67     2 
                                                                        
    2    47     4     2     3    12     1   119    10    66    33   146 
                                                                        
    2     1     0     2     2     6    12   107    71     2    78    20 
                                                                        
    6     6     3     4    17    52    33     7     5     8    95    18 
                                                                        
    8     4   108    54    58     2     2     4     1     4     3    13 
                                                                        
    2     9     2     1    33    64     5    46     6     4    31     2 
                                                                        
   12    93     3    79    23    45     2     2    74    91    13     2 
                                                                        
    2    42     5    11    16     1     8     1    11    49    91     3 
                                                                        
   28     2    19    14   103     2     2     4    19    47    40    13 
                                                                        
   17     7    31     5     3     4   116     2     8     4    16    32 
                                                                        
    2     4    20    46   186    59     5     1    39    64     2    43 
                                                                        
   50     2     2    24     2     6     7    27    67   118     2     2 
                                                                        
    3     2    12     3     1     4    40   108     4     7    25     9 
                                                                        
   10     3     3    40     2     6    53     5    14     9    51     8 
                                                                        
   15     6     2     6     1     4     2     2     1     2    20    17 
                                                                        
   21     7    10     2   140    97    73     2    79     2     2     3 
                                                                        
   36     2    11     2    12     1     0     4     3    10    33   157 
                                                                        
    4     2     2    21     2    32     2     2     2     0    45    35 
                                                                        
    1     1     8    37     6     1     3     4    49     1    35    16 
                                                                        
    6     0     5     4     2     3    46    17    58    17     3    15 
                                                                        
    9     2    65    16    62    13     4     2     1     6     2    11 
                                                                        
   44     1    26     2   106     1     2     2     1     2     2     2 
                                                            
    1     2     2     1     2     1     2     2     2     2 

$Upper.cloud
plots                                                                   
  153     1     3     1     9    24    13     7    14    36    15     2 
                                                                        
    1     2     2    35     2     1     6     9    33     3     4    33 
                                                                        
    2     5    59    54     2     2     8     1    40     2     4    50 
                                                                        
    8     2     9    40    51    79    59     1     7    41     1    63 
                                                                        
    1     2     1     3    47     3     5     3     2     3     3    32 
                                                                        
   59    56    88    17     8    31     9     4    10     1     2     0 
                                                                        
    1     7     3     6    63    36    11     5     2     4     2    20 
                                                                        
    4    66     2     2    44    18     1     2     2     2    11     2 
                                                                        
    4     5     1     2    29     2     6    38     1    16     2    25 
                                                                        
   15    24     2    11     2     3     2    20    40    65     3     3 
                                                                        
    5    13   142     2     2     3    11    11     2     2     2     1 
                                                                        
   16    12     7    24     2     2     3     2    26     1     2     3 
                                                                        
    7    18     2    15     1    12     2    11     3     3     4    13 
                                                                        
    3    50     1    10     5     2     6     6     8     5     4     2 
                                                                        
    2     3     3     2    41    81     2     2     4     5     9     1 
                                                                        
    1     4    19    16     2     2     5     7    40     3     6     2 
                                                                        
    4     2     1    37    50     9     5    15     5    44    53     1 
                                                                        
   96     6     3     6    38    22     3    11     7    69     3     2 
                                                                        
  107    88     2    10     4     4    10     2    13     6     0     5 
                                                                        
   24     2     9     6     2     1     2     2    22     7    23     1 
                                                                        
    2     2     0     2     0     2     2     2     1     1     1     2 
      
    1 
```

with replacement:One

``` r
library(chaoUtility)
data(bird)
bird.inc <- bird$inci
bird.abun<- bird$abun
Boot_p(bird$abun, datatype="abundance")
$North.site
           Acanthiza_lineata               Acanthiza_nana 
                 0.000000000                  0.000000000 
           Acanthiza_pusilla Acanthorhynchus_tenuirostris 
                 0.202970297                  0.000000000 
        Alisterus_scapularis             Cacatua_galerita 
                 0.013711189                  0.002085140 
   Cacomantis_flabelliformis     Calyptorhynchus_funereus 
                 0.024505461                  0.019252435 
     Colluricincla_harmonica        Cormobates_leucophaea 
                 0.019252435                  0.054454394 
           Corvus_coronoides          Dacelo_novaeguineae 
                 0.002085140                  0.007808497 
        Eopsaltria_australis               Gerygone_mouki 
                 0.024505461                  0.059405543 
     Leucosarcia_melanoleuca       Lichenostomus_chrysops 
                 0.002085140                  0.000000000 
             Malurus_cyaneus             Malurus_lamberti 
                 0.000000000                  0.000000000 
        Manorina_melanophrys            Meliphaga_lewinii 
                 0.000000000                  0.054454394 
      Menura_novaehollandiae          Monarcha_melanopsis 
                 0.044547402                  0.002085140 
         Neochmia_temporalis           Oriolus_sagittatus 
                 0.000000000                  0.002085140 
       Pachycephala_olivacea      Pachycephala_pectoralis 
                 0.000000000                  0.079207914 
    Pachycephala_rufiventris         Pardalotus_punctatus 
                 0.000000000                  0.074257406 
              Petroica_rosea           Phylidonyris_niger 
                 0.002085140                  0.000000000 
         Platycercus_elegans          Psophodes_olivaceus 
                 0.007808497                  0.034609444 
   Ptilonorhynchus_violaceus          Ptiloris_paradiseus 
                 0.007808497                  0.000000000 
        Rhipidura_albicollis          Rhipidura_rufifrons 
                 0.089108910                  0.039586152 
    Sericornis_citreogularis         Sericornis_frontalis 
                 0.000000000                  0.007808497 
          Strepera_graculina            Zoothera_lunulata 
                 0.013711189                  0.000000000 
         Zosterops_lateralis                              
                 0.079207914                  0.005901447 
                                                          
                 0.005901447                  0.005901447 
                                                          
                 0.005901447                  0.005901447 

$South.site
           Acanthiza_lineata               Acanthiza_nana 
                 0.009205941                  0.058631921 
           Acanthiza_pusilla Acanthorhynchus_tenuirostris 
                 0.100977199                  0.005480418 
        Alisterus_scapularis             Cacatua_galerita 
                 0.001844732                  0.005480418 
   Cacomantis_flabelliformis     Calyptorhynchus_funereus 
                 0.016162296                  0.001844732 
     Colluricincla_harmonica        Cormobates_leucophaea 
                 0.019490072                  0.104234528 
           Corvus_coronoides          Dacelo_novaeguineae 
                 0.000000000                  0.000000000 
        Eopsaltria_australis               Gerygone_mouki 
                 0.016162296                  0.032571812 
     Leucosarcia_melanoleuca       Lichenostomus_chrysops 
                 0.001844732                  0.012754851 
             Malurus_cyaneus             Malurus_lamberti 
                 0.019490072                  0.019490072 
        Manorina_melanophrys            Meliphaga_lewinii 
                 0.029312227                  0.058631921 
      Menura_novaehollandiae          Monarcha_melanopsis 
                 0.016162296                  0.032571812 
         Neochmia_temporalis           Oriolus_sagittatus 
                 0.029312227                  0.000000000 
       Pachycephala_olivacea      Pachycephala_pectoralis 
                 0.005480418                  0.048859923 
    Pachycephala_rufiventris         Pardalotus_punctatus 
                 0.009205941                  0.055374591 
              Petroica_rosea           Phylidonyris_niger 
                 0.001844732                  0.005480418 
         Platycercus_elegans          Psophodes_olivaceus 
                 0.022778664                  0.022778664 
   Ptilonorhynchus_violaceus          Ptiloris_paradiseus 
                 0.005480418                  0.009205941 
        Rhipidura_albicollis          Rhipidura_rufifrons 
                 0.065146580                  0.045602574 
    Sericornis_citreogularis         Sericornis_frontalis 
                 0.005480418                  0.019490072 
          Strepera_graculina            Zoothera_lunulata 
                 0.012754851                  0.001844732 
         Zosterops_lateralis                              
                 0.055374591                  0.005386634 
                                                          
                 0.005386634                  0.005386634 
```

References
----------

-   Chao, A., Wang, Y. T., and Jost, L. (2013). Entropy and the species accumulation curve: a novel estimator of entropy via discovery rates of new species. Methods in Ecology and Evolution, 4, 1091-1110.
-   Chao, A., Hsieh, T. C., Chazdon, R. L., Colwell, R. K., and Gotelli, N. J. (2015). Unveiling the species-rank abundance distribution by generalizing the Good-Turing sample coverage theory. Ecology 96, 1189-1201.

[back](#overview)

phylo2phytree
-------------

### examples ultrametictree

``` r
library(chaoUtility)
data(treesample)
newphy<-phylo2phytree(treesample)

class(newphy)
[1] "chaophytree"
```

``` r
newphy$tips
       Elymus_farctus    Vulpia_fasciculata    Ammophila_arenaria 
                97.50                 97.50                 97.50 
  Lophocloa_pubescens         Cyperus_kalli Asparagus_acutifolius 
                97.50                146.25                 97.50 
 Pancratium_maritimum      Lonicera_implexa 
                97.50                292.50 

newphy$nodes
poales_to_asterales                  I1                  I2 
               0.00               97.50               48.75 
            poaceae                  I4 
              48.75               97.50 

newphy$phytree
# A tibble: 13 x 6
   parent  node branch.length label                 tgroup node.age
    <int> <int>         <dbl> <chr>                 <chr>     <dbl>
 1     12     1          97.5 Elymus_farctus        Tip         0  
 2     12     2          97.5 Vulpia_fasciculata    Tip         0  
 3     12     3          97.5 Ammophila_arenaria    Tip         0  
 4     12     4          97.5 Lophocloa_pubescens   Tip         0  
 5     11     5         146.  Cyperus_kalli         Tip         0  
 6     13     6          97.5 Asparagus_acutifolius Tip         0  
 7     13     7          97.5 Pancratium_maritimum  Tip         0  
 8      9     8         292.  Lonicera_implexa      Tip         0  
 9      9     9           0   poales_to_asterales   Root      292. 
10      9    10          97.5 I1                    Inode     195  
11     10    11          48.8 I2                    Inode     146. 
12     11    12          48.8 poaceae               Inode      97.5
13     10    13          97.5 I4                    Inode      97.5


newphy$treeH
[1] 292.5
```

``` r
library(ape)
plot(treesample)
tiplabels()
nodelabels()
library(dplyr)
nodetext<-newphy$phytree %>% filter(tgroup!="Tip") %>% pull(label)
nodelabels(text=nodetext,adj=c(0,2.2))
edgelabels(treesample$edge.length, bg="black", col="white", font=2)
```

<img src="README_files/figure-markdown_github/unnamed-chunk-8-1.png" width="672" style="display: block; margin: auto;" /> [back](#overview)

### examples non ultrametictree

``` r
text<-"(((((((A:4,B:4):6,C:5):8,D:6):3,E:21):10,((F:4,G:12):14,H:8):13):13,((I:5,J:2):30,(K:11,L:11):2):17):4,M:56);"
library(ape)
tree2<-read.tree(text=text)

library(chaoUtility)
tree2.phytree<-phylo2phytree(tree2)

library(dplyr)
nodetext<-tree2.phytree$phytree %>% filter(tgroup!="Tip") %>% pull(label)
plot(tree2)
nodelabels(text=nodetext)
edgelabels(tree2$edge.length, bg="black", col="white", font=2)
```

<img src="README_files/figure-markdown_github/unnamed-chunk-9-1.png" width="672" style="display: block; margin: auto;" />

``` r

tree2.phytree$treeH
[1] 56

as.data.frame(tree2.phytree$phytree)
   parent node branch.length label tgroup node.age
1      20    1             4     A    Tip        8
2      20    2             4     B    Tip        8
3      19    3             5     C    Tip       13
4      18    4             6     D    Tip       20
5      17    5            21     E    Tip        8
6      22    6             4     F    Tip        8
7      22    7            12     G    Tip        0
8      21    8             8     H    Tip       18
9      24    9             5     I    Tip        0
10     24   10             2     J    Tip        3
11     25   11            11     K    Tip       22
12     25   12            11     L    Tip       22
13     14   13            56     M    Tip        0
14     14   14             0  Root   Root       56
15     14   15             4    I1  Inode       52
16     15   16            13    I2  Inode       39
17     16   17            10    I3  Inode       29
18     17   18             3    I4  Inode       26
19     18   19             8    I5  Inode       18
20     19   20             6    I6  Inode       12
21     16   21            13    I7  Inode       26
22     21   22            14    I8  Inode       12
23     15   23            17    I9  Inode       35
24     23   24            30   I10  Inode        5
25     23   25             2   I11  Inode       33

tree2.phytree$leaves
NULL

tree2.phytree$nodes
Root   I1   I2   I3   I4   I5   I6   I7   I8   I9  I10  I11 
   0    4   13   10    3    8    6   13   14   17   30    2 
```

[back](#overview)

### examples non ultrametictree

``` r
text<-"(((((((A:4,B:4):6,C:5):8,D:6):3,E:21):10,((F:4,G:12):14,H:8):13):13,((I:5,J:2):30,(K:11,L:11):2):17):4,M:56);"
library(ape)
tree2<-read.tree(text=text)

library(chaoUtility)
tree2.phytree<-phylo2phytree(tree2)

library(dplyr)
nodetext<-tree2.phytree$phytree %>% filter(tgroup!="Tip") %>% pull(label)
plot(tree2)
nodelabels(text=nodetext)
edgelabels(tree2$edge.length, bg="black", col="white", font=2)
```

<img src="README_files/figure-markdown_github/unnamed-chunk-10-1.png" width="672" style="display: block; margin: auto;" />

``` r

tree2.phytree$treeH
[1] 56

as.data.frame(tree2.phytree$phytree)
   parent node branch.length label tgroup node.age
1      20    1             4     A    Tip        8
2      20    2             4     B    Tip        8
3      19    3             5     C    Tip       13
4      18    4             6     D    Tip       20
5      17    5            21     E    Tip        8
6      22    6             4     F    Tip        8
7      22    7            12     G    Tip        0
8      21    8             8     H    Tip       18
9      24    9             5     I    Tip        0
10     24   10             2     J    Tip        3
11     25   11            11     K    Tip       22
12     25   12            11     L    Tip       22
13     14   13            56     M    Tip        0
14     14   14             0  Root   Root       56
15     14   15             4    I1  Inode       52
16     15   16            13    I2  Inode       39
17     16   17            10    I3  Inode       29
18     17   18             3    I4  Inode       26
19     18   19             8    I5  Inode       18
20     19   20             6    I6  Inode       12
21     16   21            13    I7  Inode       26
22     21   22            14    I8  Inode       12
23     15   23            17    I9  Inode       35
24     23   24            30   I10  Inode        5
25     23   25             2   I11  Inode       33

tree2.phytree$leaves
NULL

tree2.phytree$nodes
Root   I1   I2   I3   I4   I5   I6   I7   I8   I9  I10  I11 
   0    4   13   10    3    8    6   13   14   17   30    2 
```

phyExpandData
-------------

### EXAMPLES:abundance data

``` r
library(chaoUtility)
data(phybird.new)
bird.abu <- phybird.new$abun
bird.lab <- rownames(phybird.new$abun)
bird.phy <- phybird.new$chaophytree

bird.abu
                             North.site South.site
Acanthiza_lineata                     0          3
Acanthiza_nana                        0         18
Acanthiza_pusilla                    41         31
Acanthorhynchus_tenuirostris          0          2
Alisterus_scapularis                  3          1
Cacatua_galerita                      1          2
Cacomantis_flabelliformis             5          5
Calyptorhynchus_funereus              4          1
Colluricincla_harmonica               4          6
Cormobates_leucophaea                11         32
Corvus_coronoides                     1          0
Dacelo_novaeguineae                   2          0
Eopsaltria_australis                  5          5
Gerygone_mouki                       12         10
Leucosarcia_melanoleuca               1          1
Lichenostomus_chrysops                0          4
Malurus_cyaneus                       0          6
Malurus_lamberti                      0          6
Manorina_melanophrys                  0          9
Meliphaga_lewinii                    11         18
Menura_novaehollandiae                9          5
Monarcha_melanopsis                   1         10
Neochmia_temporalis                   0          9
Oriolus_sagittatus                    1          0
Pachycephala_olivacea                 0          2
Pachycephala_pectoralis              16         15
Pachycephala_rufiventris              0          3
Pardalotus_punctatus                 15         17
Petroica_rosea                        1          1
Phylidonyris_niger                    0          2
Platycercus_elegans                   2          7
Psophodes_olivaceus                   7          7
Ptilonorhynchus_violaceus             2          2
Ptiloris_paradiseus                   0          3
Rhipidura_albicollis                 18         20
Rhipidura_rufifrons                   8         14
Sericornis_citreogularis              0          2
Sericornis_frontalis                  2          6
Strepera_graculina                    3          4
Zoothera_lunulata                     0          1
Zosterops_lateralis                  16         17

bird.lab
 [1] "Acanthiza_lineata"            "Acanthiza_nana"              
 [3] "Acanthiza_pusilla"            "Acanthorhynchus_tenuirostris"
 [5] "Alisterus_scapularis"         "Cacatua_galerita"            
 [7] "Cacomantis_flabelliformis"    "Calyptorhynchus_funereus"    
 [9] "Colluricincla_harmonica"      "Cormobates_leucophaea"       
[11] "Corvus_coronoides"            "Dacelo_novaeguineae"         
[13] "Eopsaltria_australis"         "Gerygone_mouki"              
[15] "Leucosarcia_melanoleuca"      "Lichenostomus_chrysops"      
[17] "Malurus_cyaneus"              "Malurus_lamberti"            
[19] "Manorina_melanophrys"         "Meliphaga_lewinii"           
[21] "Menura_novaehollandiae"       "Monarcha_melanopsis"         
[23] "Neochmia_temporalis"          "Oriolus_sagittatus"          
[25] "Pachycephala_olivacea"        "Pachycephala_pectoralis"     
[27] "Pachycephala_rufiventris"     "Pardalotus_punctatus"        
[29] "Petroica_rosea"               "Phylidonyris_niger"          
[31] "Platycercus_elegans"          "Psophodes_olivaceus"         
[33] "Ptilonorhynchus_violaceus"    "Ptiloris_paradiseus"         
[35] "Rhipidura_albicollis"         "Rhipidura_rufifrons"         
[37] "Sericornis_citreogularis"     "Sericornis_frontalis"        
[39] "Strepera_graculina"           "Zoothera_lunulata"           
[41] "Zosterops_lateralis"         


phyExpandData(x=bird.abu, labels=bird.lab, phy=bird.phy, datatype="abundance")
$North.site
# A tibble: 81 x 7
   parent  node branch.length label             tgroup node.age branch.abun
    <int> <int>         <dbl> <chr>             <chr>     <dbl>       <int>
 1     46     1          32.0 Alisterus_scapul~ Tip           0           3
 2     46     2          32.0 Platycercus_eleg~ Tip           0           2
 3     47     3          32.1 Cacatua_galerita  Tip           0           1
 4     47     4          32.1 Calyptorhynchus_~ Tip           0           4
 5     48     5          60.6 Menura_novaeholl~ Tip           0           9
 6     50     6          49.8 Ptilonorhynchus_~ Tip           0           2
 7     50     7          49.8 Cormobates_leuco~ Tip           0          11
 8     53     8          14.3 Malurus_lamberti  Tip           0           0
 9     53     9          14.3 Malurus_cyaneus   Tip           0           0
10     55    10          37.0 Pardalotus_punct~ Tip           0          15
# ... with 71 more rows

$South.site
# A tibble: 81 x 7
   parent  node branch.length label             tgroup node.age branch.abun
    <int> <int>         <dbl> <chr>             <chr>     <dbl>       <int>
 1     46     1          32.0 Alisterus_scapul~ Tip           0           1
 2     46     2          32.0 Platycercus_eleg~ Tip           0           7
 3     47     3          32.1 Cacatua_galerita  Tip           0           2
 4     47     4          32.1 Calyptorhynchus_~ Tip           0           1
 5     48     5          60.6 Menura_novaeholl~ Tip           0           5
 6     50     6          49.8 Ptilonorhynchus_~ Tip           0           2
 7     50     7          49.8 Cormobates_leuco~ Tip           0          32
 8     53     8          14.3 Malurus_lamberti  Tip           0           6
 9     53     9          14.3 Malurus_cyaneus   Tip           0           6
10     55    10          37.0 Pardalotus_punct~ Tip           0          17
# ... with 71 more rows
```

### examples incidence simple data

``` r
library(chaoUtility)
data(phyincisimple)
data.inc <- phyincisimple$inci.simple.data
data.lab<-rownames(data.inc)
phy.inc<-phyincisimple$tree.simple.phytree
```

[back](#overview)

### examples incidence simple data

``` r
library(chaoUtility)
data(phyincisimple.new)
data.inc <- phyincisimple.new$inci.simple.data
data.lab<-rownames(data.inc)
phy.inc<-phyincisimple.new$tree.simple.phytree



phylotree<-phyincisimple.new$tree.simple
plot(phylotree)
nodetext<-phy.inc$phytree %>% filter(tgroup!="Tip") %>% pull(label)
nodelabels(text=nodetext)
edgelabels(phylotree$edge.length, bg="black", col="white", font=2)
```

<img src="README_files/figure-markdown_github/unnamed-chunk-13-1.png" width="672" style="display: block; margin: auto;" />

``` r
data.inc
  p1 p2 p3 p4 p5 p6
A  1  1  1  1  0  0
B  1  0  1  0  1  1
C  0  0  1  0  0  1
D  0  1  0  1  1  0
E  1  1  0  1  1  0

dataNtree<-phyExpandData(data.inc, labels=data.lab, phy=phy.inc, datatype="incidence_raw")
as.data.frame(dataNtree)
  parent node branch.length label tgroup node.age branch.abun
1      8    1           0.2     A    Tip      0.0           4
2      8    2           0.2     B    Tip      0.0           4
3      9    3           0.3     C    Tip      0.0           2
4      9    4           0.3     D    Tip      0.0           3
5      6    5           0.8     E    Tip      0.0           4
6      6    6           1.0  Root   Root      0.8           6
7      6    7           0.3    I1  Inode      0.5           6
8      7    8           0.3    I2  Inode      0.2           6
9      7    9           0.2    I3  Inode      0.3           5
```

[back](#overview)

phyLengthbyT
------------

### EXAMPLES

``` r
library(chaoUtility)
data(phybird)
bird.phy <- phybird$chaophytree


bird.phy$treeH
[1] 82.8575

phyLengthbyT(Ts=c(90,75,55), phy=bird.phy, datatype="abundance")
                                   [,1]       [,2]       [,3]
Alisterus_scapularis         31.9659554 31.9659554 31.9659554
Platycercus_elegans          31.9659554 31.9659554 31.9659554
Cacatua_galerita             32.1466904 32.1466904 32.1466904
Calyptorhynchus_funereus     32.1466904 32.1466904 32.1466904
Menura_novaehollandiae       60.6248485 60.6248485 55.0000000
Ptilonorhynchus_violaceus    49.8413606 49.8413606 49.8413606
Cormobates_leucophaea        49.8413606 49.8413606 49.8413606
Malurus_lamberti             14.3265737 14.3265737 14.3265737
Malurus_cyaneus              14.3265737 14.3265737 14.3265737
Pardalotus_punctatus         36.9602832 36.9602832 36.9602832
Phylidonyris_niger           29.7638223 29.7638223 29.7638223
Meliphaga_lewinii            19.8034030 19.8034030 19.8034030
Manorina_melanophrys         15.9536491 15.9536491 15.9536491
Lichenostomus_chrysops       15.9536490 15.9536490 15.9536490
Acanthorhynchus_tenuirostris 27.5349436 27.5349436 27.5349436
Sericornis_frontalis         14.5326945 14.5326945 14.5326945
Sericornis_citreogularis     14.5326945 14.5326945 14.5326945
Acanthiza_pusilla            13.6642770 13.6642770 13.6642770
Acanthiza_nana               10.9532494 10.9532494 10.9532494
Acanthiza_lineata            10.9532494 10.9532494 10.9532494
Gerygone_mouki               23.0715047 23.0715047 23.0715047
Psophodes_olivaceus          36.8231156 36.8231156 36.8231156
Strepera_graculina           36.8231156 36.8231156 36.8231156
Colluricincla_harmonica      24.5403935 24.5403935 24.5403935
Pachycephala_pectoralis      11.1569810 11.1569810 11.1569810
Pachycephala_rufiventris     11.1569810 11.1569810 11.1569810
Pachycephala_olivacea        16.5433092 16.5433092 16.5433092
Oriolus_sagittatus           30.5513069 30.5513069 30.5513069
Monarcha_melanopsis          25.4610513 25.4610513 25.4610513
Ptiloris_paradiseus          25.4610513 25.4610513 25.4610513
Rhipidura_rufifrons          15.4390507 15.4390507 15.4390507
Rhipidura_albicollis         15.4390507 15.4390507 15.4390507
Corvus_coronoides            27.8225694 27.8225694 27.8225694
Eopsaltria_australis         37.9655378 37.9655378 37.9655378
Petroica_rosea               37.9655377 37.9655377 37.9655377
Zosterops_lateralis          44.5429809 44.5429809 44.5429809
Zoothera_lunulata            43.6284208 43.6284208 43.6284208
Neochmia_temporalis          43.6284206 43.6284206 43.6284206
Dacelo_novaeguineae          80.5684691 75.0000000 55.0000000
Leucosarcia_melanoleuca      76.7365165 75.0000000 55.0000000
Cacomantis_flabelliformis    76.7365166 75.0000000 55.0000000
Root                          7.1424967  0.0000000  0.0000000
I1                            2.2890338  0.0000000  0.0000000
I2                            3.3780170  0.0000000  0.0000000
I3                           32.1763058 29.9858534  9.9858534
I4                           13.0481910 13.0481910 13.0481910
I5                           12.8674561 12.8674561 12.8674561
I6                           16.5656036 14.3751512  0.0000000
I7                            3.6411840  3.6411840  0.0000000
I8                            7.1423040  7.1423040  5.1586393
I9                            3.5604001  3.5604001  1.5767354
I10                           7.7250663  7.7250663  7.7250663
I11                          31.3716245 31.3716245 31.3716245
I12                           7.6639121  7.6639121  7.6639121
I13                           1.0740030  1.0740030  1.0740030
I14                           7.1964609  7.1964609  7.1964609
I15                           2.2288786  2.2288786  2.2288786
I16                           7.7315406  7.7315406  7.7315406
I17                           3.8497540  3.8497540  3.8497540
I18                          14.9627814 14.9627814 14.9627814
I19                           1.8811889  1.8811889  1.8811889
I20                           6.6576213  6.6576213  6.6576213
I21                           7.5260388  7.5260388  7.5260388
I22                           2.7110275  2.7110275  2.7110275
I23                           3.0724789  3.0724789  3.0724789
I24                          11.2166519 11.2166519 11.2166519
I25                           2.3110182  2.3110182  2.3110182
I26                           2.7312937  2.7312937  2.7312937
I27                          11.8624466 11.8624466 11.8624466
I28                           7.9970842  7.9970842  7.9970842
I29                           5.3863282  5.3863282  5.3863282
I30                           5.8515332  5.8515332  5.8515332
I31                           2.7287374  2.7287374  2.7287374
I32                           1.2437461  1.2437461  1.2437461
I33                           1.1177720  1.1177720  1.1177720
I34                          11.1397726 11.1397726 11.1397726
I35                           3.3279815  3.3279815  3.3279815
I36                           9.0572663  9.0572663  9.0572663
I37                           2.4798231  2.4798231  2.4798231
I38                           0.9145603  0.9145603  0.9145603
I39                           6.1209866  0.0000000  0.0000000
```

[back](#overview)

### examples non ultrametric tree by reference t

``` r
text<-"(((((((A:4,B:4):6,C:5):8,D:6):3,E:21):10,((F:4,G:12):14,H:8):13):13,((I:5,J:2):30,(K:11,L:11):2):17):4,M:56);"
library(ape)
tree2<-read.tree(text=text)
```

### examples non ultrametric tree by reference t

``` r
text<-"(((((((A:4,B:4):6,C:5):8,D:6):3,E:21):10,((F:4,G:12):14,H:8):13):13,((I:5,J:2):30,(K:11,L:11):2):17):4,M:56);"
library(ape)
tree2<-read.tree(text=text)

library(chaoUtility)
phytree<-phylo2phytree(tree2)

phytree$treeH
[1] 56

phyLengthbyT(Ts=c(75,55,50), phy=phytree, datatype="abundance",rootExtend=T)
     [,1] [,2] [,3]
A       4    4    4
B       4    4    4
C       5    5    5
D       6    6    6
E      21   21   21
F       4    4    4
G      12   12   12
H       8    8    8
I       5    5    5
J       2    2    2
K      11   11   11
L      11   11   11
M      56   55   50
Root   19    0    0
I1      4    3    0
I2     13   13   11
I3     10   10   10
I4      3    3    3
I5      8    8    8
I6      6    6    6
I7     13   13   13
I8     14   14   14
I9     17   17   15
I10    30   30   30
I11     2    2    2

library(dplyr)
nodetext<-phytree$phytree %>% filter(tgroup!="Tip") %>% pull(label)
plot(tree2)
nodelabels(text=nodetext)
edgelabels(tree2$edge.length, bg="black", col="white", font=2)
```

<img src="README_files/figure-markdown_github/unnamed-chunk-17-1.png" width="672" style="display: block; margin: auto;" />

``` r

as.data.frame(phytree$phytree)
   parent node branch.length label tgroup node.age
1      20    1             4     A    Tip        8
2      20    2             4     B    Tip        8
3      19    3             5     C    Tip       13
4      18    4             6     D    Tip       20
5      17    5            21     E    Tip        8
6      22    6             4     F    Tip        8
7      22    7            12     G    Tip        0
8      21    8             8     H    Tip       18
9      24    9             5     I    Tip        0
10     24   10             2     J    Tip        3
11     25   11            11     K    Tip       22
12     25   12            11     L    Tip       22
13     14   13            56     M    Tip        0
14     14   14             0  Root   Root       56
15     14   15             4    I1  Inode       52
16     15   16            13    I2  Inode       39
17     16   17            10    I3  Inode       29
18     17   18             3    I4  Inode       26
19     18   19             8    I5  Inode       18
20     19   20             6    I6  Inode       12
21     16   21            13    I7  Inode       26
22     21   22            14    I8  Inode       12
23     15   23            17    I9  Inode       35
24     23   24            30   I10  Inode        5
25     23   25             2   I11  Inode       33
```

[back](#overview)

\#phybranchal
-------------

### EXAMPLES-improve performance

``` r
 data(AbuALdata)
 adata<-AbuALdata$abudata
 atree<-AbuALdata$tree
 vdata<-adata$EM
 names(vdata)<-rownames(adata)
 vdata
     Juniperus_oxycedrus        Clematis_flammula         Silene_canescens 
                       0                        0                        0 
            Salsola_kali      Polygonum_maritimum   Phillyrea_angustifolia 
                      72                       14                        0 
    Helichrysum_stoechas       Otanthus_maritimus Centaurea_sphaerocephala 
                       0                       16                        0 
        Sonchus_bulbosus        Anthemis_maritima    Pycnocomon_rutifolium 
                       0                        9                        0 
        Lonicera_implexa       Eryngium_maritimum      Echinophora_spinosa 
                       0                        8                       11 
      Pseudorlaya_pumila          Rubia_peregrina     Crucianella_maritima 
                       0                        0                        0 
           Prasium_majus          Teucrium_flavum       Plantago_coronopus 
                       0                        0                        1 
   Calystegia_soldanella         Lotus_cytisoides         Ononis_variegata 
                      10                        0                        2 
     Medicago_littoralis          Medicago_marina        Rhamnus_alaternus 
                       0                        1                        0 
            Quercus_ilex      Euphorbia_terracina        Chamaesyce_peplis 
                       0                        0                       36 
      Pistacia_lentiscus           Daphne_gnidium           Cistus_incanus 
                       0                        0                        0 
         Cakile_maritima            Smilax_aspera     Pancratium_maritimum 
                      81                        0                        6 
   Asparagus_acutifolius            Cyperus_kalli      Lophocloa_pubescens 
                       0                        1                        0 
          Lagurus_ovatus    Sporobolus_virginicus          Bromus_diandrus 
                       0                       42                        0 
       Cutandia_maritima       Ammophila_arenaria       Vulpia_fasciculata 
                       3                        0                        0 
          Elymus_farctus 
                      60 
 
 refTs<-c(400,250,100)
 result<-phyBranchAL_Abu(atree,vdata,datatype="abundance",refTs)
 
 ##final branch.abu:removed abu=0
 treeNabu<-result$treeNabu
 treeNabu %>% print(n = Inf)
# A tibble: 32 x 8
   parent  node branch.length tgroup label node.age branch.height
    <int> <int>         <dbl> <chr>  <chr>    <dbl>         <dbl>
 1     21     1          97.5 Tip    Elym~      0            97.5
 2     21     2          97.5 Tip    Cuta~      0            97.5
 3     21     3          97.5 Tip    Spor~      0            97.5
 4     20     4         146.  Tip    Cype~      0           146. 
 5     19     5         195   Tip    Panc~      0           195  
 6     23     6         195   Tip    Caki~      0           195  
 7     24     7         162.  Tip    Cham~      0           162. 
 8     25     8          65   Tip    Medi~      0            65  
 9     25     9          65   Tip    Onon~      0            65  
10     28    10          97.5 Tip    Caly~      0            97.5
11     28    11          97.5 Tip    Plan~      0            97.5
12     30    12          43.3 Tip    Echi~      0            43.3
13     30    13          43.3 Tip    Eryn~      0            43.3
14     31    14          97.5 Tip    Anth~      0            97.5
15     31    15          97.5 Tip    Otan~      0            97.5
16     32    16         130   Tip    Poly~      0           130  
17     32    17         130   Tip    Sals~      0           130  
18     18    18          NA   Root   poal~    292.          292. 
19     18    19          97.5 Inode  I1       195           292. 
20     19    20          48.8 Inode  I2       146.          195  
21     20    21          48.8 Inode  poac~     97.5         146. 
22     18    22          65   Inode  I4       228.          292. 
23     22    23          32.5 Inode  I5       195           228. 
24     23    24          32.5 Inode  I6       162.          195  
25     24    25          97.5 Inode  I7        65           162. 
26     22    26          32.5 Inode  I8       195           228. 
27     26    27          32.5 Inode  I9       162.          195  
28     27    28          65   Inode  I10       97.5         162. 
29     27    29          32.5 Inode  I11      130           162. 
30     29    30          86.7 Inode  apia~     43.3         130  
31     29    31          32.5 Inode  aste~     97.5         130  
32     26    32          65   Inode  cary~    130           195  
# ... with 1 more variable: branch.abun <int>
 
 ##final treeH:removed abu=0
 result$treeH
[1] 292.5
 
 ##final branch.length:removed abu=0
 result$BLbyT
                           T400      T250      T100
Elymus_farctus         97.50000  97.50000  97.50000
Cutandia_maritima      97.50000  97.50000  97.50000
Sporobolus_virginicus  97.50000  97.50000  97.50000
Cyperus_kalli         146.25000 146.25000 100.00000
Pancratium_maritimum  195.00000 195.00000 100.00000
Cakile_maritima       195.00000 195.00000 100.00000
Chamaesyce_peplis     162.50000 162.50000 100.00000
Medicago_marina        65.00000  65.00000  65.00000
Ononis_variegata       65.00000  65.00000  65.00000
Calystegia_soldanella  97.50000  97.50000  97.50000
Plantago_coronopus     97.50000  97.50000  97.50000
Echinophora_spinosa    43.33333  43.33333  43.33333
Eryngium_maritimum     43.33333  43.33333  43.33333
Anthemis_maritima      97.50000  97.50000  97.50000
Otanthus_maritimus     97.50000  97.50000  97.50000
Polygonum_maritimum   130.00000 130.00000 100.00000
Salsola_kali          130.00000 130.00000 100.00000
poales_to_asterales   107.50000   0.00000   0.00000
I1                     97.50000  55.00000   0.00000
I2                     48.75000  48.75000   0.00000
poaceae                48.75000  48.75000   2.50000
I4                     65.00000  22.50000   0.00000
I5                     32.50000  32.50000   0.00000
I6                     32.50000  32.50000   0.00000
I7                     97.50000  97.50000  35.00000
I8                     32.50000  32.50000   0.00000
I9                     32.50000  32.50000   0.00000
I10                    65.00000  65.00000   2.50000
I11                    32.50000  32.50000   0.00000
apiaceae               86.66667  86.66667  56.66667
asteraceae             32.50000  32.50000   2.50000
caryophyllales         65.00000  65.00000   0.00000
 
 ####result$treeNabu is an object of tbl_tree could change to phylo
 tlb2phylo<-as.phylo(treeNabu)
 plot(tlb2phylo)
```

<img src="README_files/figure-markdown_github/unnamed-chunk-18-1.png" width="672" style="display: block; margin: auto;" />

``` r
 
 
 ###this is the original tree
 plot(atree)
```

<img src="README_files/figure-markdown_github/unnamed-chunk-18-2.png" width="672" style="display: block; margin: auto;" />

### EXAMPLES

``` r
 data(AbuALdata)
 adata<-AbuALdata$abudata
 atree<-AbuALdata$tree
 vdata<-adata$EM
 names(vdata)<-rownames(adata)
 vdata
     Juniperus_oxycedrus        Clematis_flammula         Silene_canescens 
                       0                        0                        0 
            Salsola_kali      Polygonum_maritimum   Phillyrea_angustifolia 
                      72                       14                        0 
    Helichrysum_stoechas       Otanthus_maritimus Centaurea_sphaerocephala 
                       0                       16                        0 
        Sonchus_bulbosus        Anthemis_maritima    Pycnocomon_rutifolium 
                       0                        9                        0 
        Lonicera_implexa       Eryngium_maritimum      Echinophora_spinosa 
                       0                        8                       11 
      Pseudorlaya_pumila          Rubia_peregrina     Crucianella_maritima 
                       0                        0                        0 
           Prasium_majus          Teucrium_flavum       Plantago_coronopus 
                       0                        0                        1 
   Calystegia_soldanella         Lotus_cytisoides         Ononis_variegata 
                      10                        0                        2 
     Medicago_littoralis          Medicago_marina        Rhamnus_alaternus 
                       0                        1                        0 
            Quercus_ilex      Euphorbia_terracina        Chamaesyce_peplis 
                       0                        0                       36 
      Pistacia_lentiscus           Daphne_gnidium           Cistus_incanus 
                       0                        0                        0 
         Cakile_maritima            Smilax_aspera     Pancratium_maritimum 
                      81                        0                        6 
   Asparagus_acutifolius            Cyperus_kalli      Lophocloa_pubescens 
                       0                        1                        0 
          Lagurus_ovatus    Sporobolus_virginicus          Bromus_diandrus 
                       0                       42                        0 
       Cutandia_maritima       Ammophila_arenaria       Vulpia_fasciculata 
                       3                        0                        0 
          Elymus_farctus 
                      60 
 
 refTs<-c(400,250,100)
 result<-phy_BranchAL_Abu(atree,vdata,datatype="abundance",refTs)
 
 ##final branch.abu:removed abu=0
 treeNabu<-result$treeNabu
 treeNabu %>% print(n = Inf)
# A tibble: 32 x 7
   parent  node branch.length label             tgroup node.age branch.abun
    <int> <int>         <dbl> <chr>             <chr>     <dbl>       <int>
 1     21     1          97.5 Elymus_farctus    Tip         0            60
 2     21     2          97.5 Cutandia_maritima Tip         0             3
 3     21     3          97.5 Sporobolus_virgi~ Tip         0            42
 4     20     4         146.  Cyperus_kalli     Tip         0             1
 5     19     5         195   Pancratium_marit~ Tip         0             6
 6     23     6         195   Cakile_maritima   Tip         0            81
 7     24     7         162.  Chamaesyce_peplis Tip         0            36
 8     25     8          65   Medicago_marina   Tip         0             1
 9     25     9          65   Ononis_variegata  Tip         0             2
10     28    10          97.5 Calystegia_solda~ Tip         0            10
11     28    11          97.5 Plantago_coronop~ Tip         0             1
12     30    12          43.3 Echinophora_spin~ Tip         0            11
13     30    13          43.3 Eryngium_maritim~ Tip         0             8
14     31    14          97.5 Anthemis_maritima Tip         0             9
15     31    15          97.5 Otanthus_maritim~ Tip         0            16
16     32    16         130   Polygonum_mariti~ Tip         0            14
17     32    17         130   Salsola_kali      Tip         0            72
18     18    18           0   poales_to_astera~ Root      292.          373
19     18    19          97.5 I1                Inode     195           112
20     19    20          48.8 I2                Inode     146.          106
21     20    21          48.8 poaceae           Inode      97.5         105
22     18    22          65   I4                Inode     228.          261
23     22    23          32.5 I5                Inode     195           120
24     23    24          32.5 I6                Inode     162.           39
25     24    25          97.5 I7                Inode      65             3
26     22    26          32.5 I8                Inode     195           141
27     26    27          32.5 I9                Inode     162.           55
28     27    28          65   I10               Inode      97.5          11
29     27    29          32.5 I11               Inode     130            44
30     29    30          86.7 apiaceae          Inode      43.3          19
31     29    31          32.5 asteraceae        Inode      97.5          25
32     26    32          65   caryophyllales    Inode     130            86
 
 ##final treeH:removed abu=0
 result$treeH
[1] 292.5
 
 ##final branch.length:removed abu=0
 result$BLbyT
$T400
       Elymus_farctus     Cutandia_maritima Sporobolus_virginicus 
             97.50000              97.50000              97.50000 
        Cyperus_kalli  Pancratium_maritimum       Cakile_maritima 
            146.25000             195.00000             195.00000 
    Chamaesyce_peplis       Medicago_marina      Ononis_variegata 
            162.50000              65.00000              65.00000 
Calystegia_soldanella    Plantago_coronopus   Echinophora_spinosa 
             97.50000              97.50000              43.33333 
   Eryngium_maritimum     Anthemis_maritima    Otanthus_maritimus 
             43.33333              97.50000              97.50000 
  Polygonum_maritimum          Salsola_kali   poales_to_asterales 
            130.00000             130.00000             107.50000 
                   I1                    I2               poaceae 
             97.50000              48.75000              48.75000 
                   I4                    I5                    I6 
             65.00000              32.50000              32.50000 
                   I7                    I8                    I9 
             97.50000              32.50000              32.50000 
                  I10                   I11              apiaceae 
             65.00000              32.50000              86.66667 
           asteraceae        caryophyllales 
             32.50000              65.00000 

$T250
       Elymus_farctus     Cutandia_maritima Sporobolus_virginicus 
             97.50000              97.50000              97.50000 
        Cyperus_kalli  Pancratium_maritimum       Cakile_maritima 
            146.25000             195.00000             195.00000 
    Chamaesyce_peplis       Medicago_marina      Ononis_variegata 
            162.50000              65.00000              65.00000 
Calystegia_soldanella    Plantago_coronopus   Echinophora_spinosa 
             97.50000              97.50000              43.33333 
   Eryngium_maritimum     Anthemis_maritima    Otanthus_maritimus 
             43.33333              97.50000              97.50000 
  Polygonum_maritimum          Salsola_kali   poales_to_asterales 
            130.00000             130.00000               0.00000 
                   I1                    I2               poaceae 
             55.00000              48.75000              48.75000 
                   I4                    I5                    I6 
             22.50000              32.50000              32.50000 
                   I7                    I8                    I9 
             97.50000              32.50000              32.50000 
                  I10                   I11              apiaceae 
             65.00000              32.50000              86.66667 
           asteraceae        caryophyllales 
             32.50000              65.00000 

$T100
       Elymus_farctus     Cutandia_maritima Sporobolus_virginicus 
             97.50000              97.50000              97.50000 
        Cyperus_kalli  Pancratium_maritimum       Cakile_maritima 
            100.00000             100.00000             100.00000 
    Chamaesyce_peplis       Medicago_marina      Ononis_variegata 
            100.00000              65.00000              65.00000 
Calystegia_soldanella    Plantago_coronopus   Echinophora_spinosa 
             97.50000              97.50000              43.33333 
   Eryngium_maritimum     Anthemis_maritima    Otanthus_maritimus 
             43.33333              97.50000              97.50000 
  Polygonum_maritimum          Salsola_kali   poales_to_asterales 
            100.00000             100.00000               0.00000 
                   I1                    I2               poaceae 
              0.00000               0.00000               2.50000 
                   I4                    I5                    I6 
              0.00000               0.00000               0.00000 
                   I7                    I8                    I9 
             35.00000               0.00000               0.00000 
                  I10                   I11              apiaceae 
              2.50000               0.00000              56.66667 
           asteraceae        caryophyllales 
              2.50000               0.00000 
 
 ####result$treeNabu is an object of tbl_tree could change to phylo
 tlb2phylo<-as.phylo(treeNabu)
 plot(tlb2phylo)
```

<img src="README_files/figure-markdown_github/unnamed-chunk-19-1.png" width="672" style="display: block; margin: auto;" />

``` r
 
 
 ###this is the original tree
 plot(atree)
```

<img src="README_files/figure-markdown_github/unnamed-chunk-19-2.png" width="672" style="display: block; margin: auto;" />

[back](#overview)
