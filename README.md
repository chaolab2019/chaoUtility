A Quick introudction for chaolab utility
================

<!-- README.md is generated from README.Rmd. Please edit that file -->
``` r
library(chaoUtility)
```

`chaoUtility` focuses on some useful tools for chao lab, include bootstrap and checktype functions

HOW TO RUN chaoUtility:
-----------------------

The `chaoUtility` package can be downloaded with a standard R installation procedure using the following commands.

``` r
## install the latest version from github
install.packages('devtools')
library(devtools)
install_github('chaolab2019/chaoUtility')

## import packages
```

MAIN FUNCTION: Boot\_p()
------------------------

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
<code>character</code> : "One" or "JADE". `Bootype = "One"` or `Bootype = "JADE"` <br> "One": from \#99 2013 Entropy and the species accumulation curve Appendix S2: Estimating species relative abundance. <br>"JADE": from \#107 Unveiling the species-rank abundance distribution by generalizing the Good-Turing sample coverage theory.
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
