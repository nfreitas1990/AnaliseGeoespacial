

# Natalia
# Objetivo: Download espécies de peixes pertencentes a bacia do Rio Doce
# localizada no estado de Minas Gerais e Espirito Santo


# Instalar pacote ---------------------------------------------------------
devtools::install_github("liibre/Rocc")


# Pacotes -----------------------------------------------------------------
library(Rocc)
library(dplyr)

# Ajuda sobre o pacote ----------------------------------------------------
?rspeciesLink
args(rspeciesLink)


# Espécies ----------------------------------------------------------------
spp <- readxl::read_xlsx("data/DimensaoSpp_marco2023.xlsx")

spp <- spp |> 
        select(Especie) |> 
        filter(!endsWith(spp$Especie,"sp.")) |>             # excluir linhas terminam sp. 
        mutate(Especie = stringr::str_squish(Especie),       # retirar espaços do nome
               Especie = stringr::str_to_sentence(Especie))  # colocar 1 letra em maiusculo
  

# Lista de Especies -------------------------------------------------------
spp <- as.character(spp$Especie)
class(spp)
length(spp)
spp2 <- spp[1:80]
lista <- rspeciesLink(filename = "dadosPeixesSpeciesLink2",
             species =  spp2,
             Scope = "animals", 
             stateProvince = c("Minas Gerais", "Espírito Santo"))


table(lista$scientificName)
