library(shiny)
library(tidyverse)
library(BiocManager)
library(pathview)
library(DT)
library(org.Mm.eg.db)
library(org.Hs.eg.db)


data('korg')
data('paths.hsa')
data('gene.idtype.list')
data('bods')

bods <- as.tibble(bods)

paths.hsa = tibble(PathwayID = rownames(as.data.frame(paths.hsa)), `Pathway Name` = as.vector(paths.hsa)) %>%
  separate(PathwayID, into = c('a', 'Pathway ID'), sep = 'hsa') %>% dplyr::select(-a)


species <- as_tibble(korg) %>% dplyr::select(common.name, scientific.name, kegg.code)

