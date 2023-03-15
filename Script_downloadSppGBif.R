
# Março 2023
# Autor: Natália Freitas (nfreitas1990@gmail.com)
# Script criado com base no Github:https://github.com/diogosbr/download-occurrence-data/blob/master/script_.R


# Objetivo: Baixar dados de Ocorrência do site Gbif

# Pacotes -----------------------------------------------------------------
# Instalar os pacotes necessários
pacotes = c("rgbif", "dismo", "raster", "maptools", "devtools")
for (p in setdiff(pacotes, installed.packages()[, "Package"])) { install.packages(p, dependencies = T)}


# Lista de Espécies -------------------------------------------------------
# Carregar a lista de espécies que se deseja baixar os registros
nome.sp <- c('Astyanax bimaculatus', 'Astyanax lacustris', 'Brycon dulcis')


# Armazenar registros -----------------------------------------------------
# Gerar objeto para armazenar os registros
lista = c()
# Colocar barra da progresso
pb <- txtProgressBar(min = 1, max = length(nome.sp), style = 3)


# Loop para Donwload ------------------------------------------------------
# Baixar em uma única tabela
for(i in nome.sp){
  setTxtProgressBar(pb, grep(pattern = i, nome.sp))
  cat("\n")
  
  # Baixar dados de ocorrência do GBIF pelo pacote rgbif
  # Limitar as ocorrencias para o brasil
  species <- rgbif::occ_data(scientificName = i, hasCoordinate = TRUE, country = 'BR') 
                                    
  # Excluir os registros que não possui longitude e latitude
  species= na.exclude(species)
  
  # Criar lista com as espécies
  lista = plyr::rbind.fill(lista, species$data)
}


# Selecionar colunas de interesse -----------------------------------------
lista_spp <- lista|>
  dplyr::select("scientificName","decimalLatitude", "decimalLongitude",
                "order","family", "genus","species","genericName", "taxonomicStatus",
                "iucnRedListCategory","dateIdentified","stateProvince","references",
                "municipality")

# Exploratorio ------------------------------------------------------------
# Número de registros com coordenadas por espécie/ por estado
table(lista_spp$species)
table(lista_spp$stateProvince)

# visualizando os 3 primeiro registros
head(lista_spp,3)



# Mapa --------------------------------------------------------------------

# Plotando os registros para visualização
data(wrld_simpl, package = "maptools")
lista1=lista_spp
sp::coordinates(lista1)  = ~decimalLongitude+decimalLatitude
raster::plot(lista1, col = as.factor(unique(lista$species)), pch = 19, cex = 1.2);raster::plot(wrld_simpl, add = T)
legend("topleft", unique(lista$species), col = as.factor(unique(lista$species)), pch = 19, title = "Espécies")



# Limpando registros ------------------------------------------------------
# Delimitando os registros para Bacia do Rio Doce


