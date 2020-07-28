# Nome: Lista de Correspondência nome/ibgecod
# Marco Antonio Faganello - marcofaga@gmail.com - http://github.com/marcofaga
# Data de início: 28 de julho de 2020

# Libraries===================================================================

library(tidyverse)

# Início do script============================================================


lista <- read.csv2("raw/histMun.csv")
lista <- unique(lista[,c(2,4,7,8)])
lista$nomeMun <- iconv(lista$nomeMun, to="ASCII//TRANSLIT")
lista$nomeMun <- toupper(lista$nomeMun)
lista <- unique(lista)
names(lista)[3] <- c("codIbge")

lista2 <- lista[grepl("'", lista$nomeMun),]
lista2$nomeMun <- gsub("'", " ", lista2$nomeMun)

lista <- rbind(lista, lista2)

lista2 <- lista[grepl("'", lista$nomeMun),]
lista2$nomeMun <- gsub("'", "", lista2$nomeMun)

lista <- rbind(lista, lista2)

lista3 <- unique(read.csv2("raw/bd01TransfMun.csv")[,c(2,3,5)])
lista3$codUf <- substr(lista3$codIbge, 1, 2)
names(lista3)[2] <- "nomeMun"
lista3 <- lista3[,match(names(lista), names(lista3))]

lista <- unique(rbind(lista, lista3))
lista <- as.tibble(lista)
lista <- lista %>% arrange(uf, nomeMun)
remove(lista2, lista3)
lista$codUf <- as.character(lista$codUf)
lista$codIbge <- as.character(lista$codIbge)

listaNomeIbge <- lista
remove(lista)

# Output =====================================================================
write.csv2(listaNomeIbge, "listaNomeIbge.csv")
