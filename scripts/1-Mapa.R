library(terra)
library(geobr)
library(sf)
library(tmap)      
library(dplyr)
library(tibble)    
library(readr) 
library(ggplot2)
# 

# Código IBGE 
codigo_urucuca <- 2932705 

limite_urucuca <- read_municipality(code_muni = codigo_urucuca, year = 2022) 

st_write(limite_urucuca, "dados/processed/limite_urucuca.gpkg", delete_dsn = TRUE) #salvando o arquivo em geopackage na pasta dados, delete_dsn = true é pra excluir um arquivo no destino caso já haja um arquivo com o mesmo nome, garantir reprodutibilidade# 
limite_urucuca <- st_read("dados/processed/limite_urucuca.gpkg")

# 1. Carregar o raster do MapBiomas
# *Substitua 'NOME_DO_SEU_ARQUIVO.tif' pelo nome real do arquivo na sua pasta dados/raw*
urucuca_raster <- terra::rast("dados/raw/uso_solo_urucuca.tif")
# 2. Re-projetar o limite municipal para o mesmo SRC do raster (se necessário)
# (O MapBiomas geralmente usa um sistema de projeção diferente do geobr)
src_mapbiomas <- terra::crs(urucuca_raster, proj=TRUE)
limite_urucuca_proj <- st_transform(limite_urucuca, crs = src_mapbiomas)

# 3. Recortar (crop) e mascarar (mask) o raster
# Recortar (crop) primeiro para reduzir o tamanho da área de processamento
urucuca_crop <- terra::crop(urucuca_raster, vect(limite_urucuca_proj))

# Mascarar (mask) para manter apenas os pixels dentro do limite do município
urucuca_mask <- terra::mask(urucuca_crop, vect(limite_urucuca_proj))
names(urucuca_mask) <- "classe_id"
urucuca_df <- urucuca_mask %>% 
  terra::as.data.frame(xy = TRUE)
names(urucuca_df)[3] <- "classe_id"


# 4. Criar a legenda do MapBiomas manualmente (Nível 3 - classes principais)
# Usei as cores oficiais do MapBiomas
legenda_mb <- tibble::tribble(
  ~classe, ~descricao, ~cor,
  3, "Formação Florestal", "#006400",       
  5, "Formação Campestre", "#a0f3b0",
  9, "Silvicultura", "#689947",         
  11, "Área Úmida Natural", "#032e33",
  15, "Pastagem", "#e974ed",             
  21, "Mosaico de Uso", "#d5cc70",
  23, "Praia, Duna e Areal", "#a18548",  
  24, "Área Urbanizada", "#ff0000",      
  25, "Outras Áreas Não Vegetadas", "#c59240",
  26, "Corpo D'Água (Rio)", "#4c85be", 
  33, "Corpo D'Água (Oceano)", "#0000ff",
  49, "Restinga Arbórea", "#21796d",      
  50, "Restinga Herbácea", "#526c2e" 
)
# 5. Filtrar a legenda para apenas as classes presentes e preparar a paleta

# Valores únicos presentes no data frame (já renomeado)
# Usamos unique() no vetor da coluna classe_id
valores_presentes <- unique(urucuca_df$classe_id)

# Filtrar a legenda para incluir apenas as classes que realmente existem no seu mapa
legenda_plot <- legenda_mb %>% 
  filter(classe %in% valores_presentes)

# Remover NAs (opcional, mas bom para garantir)
urucuca_df <- urucuca_df %>% 
  filter(!is.na(classe_id))

# 6. Criar o vetor de cores (paleta) para o ggplot (CRUCIAL)
# O vetor de valores deve ter como 'names' o ID da classe (como string)

paleta_mb_filtrada <- legenda_plot$cor
# O names() deve mapear o ID da classe (como caractere) para a cor
names(paleta_mb_filtrada) <- as.character(legenda_plot$classe)

# Os labels são as descrições que aparecerão na legenda
labels_mb <- legenda_plot$descricao

# 7. Gerar o mapa com ggplot2
mapa_uso_terra_gg <- ggplot() +
  
  # Adiciona o raster (agora como data frame) usando geom_tile
  geom_tile(data = urucuca_df, 
            aes(x = x, y = y, fill = as.factor(classe_id)),
            # Remove bordas dos pixels para um visual mais limpo
            colour = NA, 
            na.rm = TRUE) + 
  
  # Define a escala de preenchimento (cores)
  scale_fill_manual(
    name = "Uso e Cobertura",
    # Usa a paleta mapeada pelos IDs das classes
    values = paleta_mb_filtrada, 
    # Usa as descrições como rótulos
    labels = labels_mb,
    # Garante que áreas fora do município não sejam coloridas
    na.value = "transparent"
  ) +
  
  # Adiciona o limite municipal (vetor) por cima
  geom_sf(data = limite_urucuca_proj, fill = NA, color = "black", linewidth = 0.8) +
  
  # Fixa a proporção dos eixos e o SRC para garantir que o mapa não fique distorcido
  coord_sf(crs = src_mapbiomas) +
  
  # Configurações de tema e título
  labs(title = "Uso e Cobertura da Terra em Uruçuca (MapBiomas)") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    legend.title = element_text(size = 10, face = "bold"),
    legend.text = element_text(size = 8),
    axis.title = element_blank(),
    axis.text = element_blank(), # Remove as coordenadas
    panel.grid.major = element_blank(), # Remove grades
    panel.grid.minor = element_blank()
  )

# 8. Exibir o mapa
print(mapa_uso_terra_gg)

# 9. SALVAR O MAPA USANDO ggsave()
ggplot2::ggsave(
  filename = "dados/processed/mapa_uso_terra_urucuca_ggplot_final.png",
  plot = mapa_uso_terra_gg,
  width = 8, 
  height = 8, 
  units = "in", 
  dpi = 300
)
























