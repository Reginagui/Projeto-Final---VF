# Cria um mapa vetorial usando o limite do município (lim_projeto)
# =========================================================

# --- Pacotes ---
library(sf)
library(tmap)
library(geobr) # Para baixar limites estaduais (contexto)

# --- 0. Preparação de Diretórios ---
dir.create("resultados/mapas", recursive = TRUE, showWarnings = FALSE)

# --- 1. Carregamento dos Dados Processados ---

# Carrega o limite do município (Uruçuca)
tryCatch({
  lim_projeto <- sf::st_read("dados/processed/limite_urucuca.gpkg") 
}, error = function(e) {
  stop("ERRO: O arquivo limite_urucuca.gpkg não foi encontrado. Verifique o caminho.")
})

# --- 2. Carregamento dos Dados de Contexto (Bahia) ---

# Código IBGE da Bahia (29)
limite_estado <- read_state(code_state = 29, year = 2020) 

# Reprojetar o limite do estado para o CRS do limite do município, se necessário
limite_estado <- st_transform(limite_estado, st_crs(lim_projeto))


# --- 3. Geração do Mapa Vetorial de Contexto (tmap) ---

tmap_mode("plot") 

mapa_contexto <- tm_shape(limite_estado) + 
  # Desenha o estado da Bahia
  tm_fill(col = "gray90", alpha = 0.5) +
  tm_borders(col = "gray40", lwd = 1) +
  
  # Adiciona a camada de Uruçuca
  tm_shape(lim_projeto) + 
  tm_fill(col = "red", alpha = 0.8) + # Destaque em vermelho
  tm_borders(col = "black", lwd = 1.5) +
  
  # Layout
  tm_layout(
    title = "Localização do Município de Uruçuca (BA)",
    title.size = 1.2,
    title.fontface = "bold",
    frame = TRUE,
    bg.color = "white",
    # Opcional: Zoom ajustado para focar na região, se o estado for muito grande.
    # Se quiser mostrar a Bahia inteira, remova esta linha.
    bbox = st_bbox(lim_projeto) * c(0.8, 0.8, 1.2, 1.2) # Zoom na região de Uruçuca
  ) +
  
  # Elementos
  tm_scale_bar(position = c("left", "bottom"), text.size = 0.6) + 
  tm_compass(type = "arrow", position = c("right", "top"), size = 1)

# 4. Salvar o Mapa Vetorial
tmap_save(
  tm = mapa_contexto, 
  filename = "resultados/mapas/mapa_contexto_vetor.png",
  width = 7,
  height = 7,
  units = "in"
)

# Visualizar
mapa_contexto
