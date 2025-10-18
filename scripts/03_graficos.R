## Grafico de uso e cobertura do solo

# --- Pacotes ---
library(ggplot2)
library(dplyr)
library(readr)
library(forcats) # Útil para ordenar fatores no ggplot

# --- 0. Preparação de Diretórios ---
dir.create("resultados", showWarnings = FALSE)
dir.create("resultados/tabelas", showWarnings = FALSE)
dir.create("resultados/graficos", showWarnings = FALSE)
dir.create("resultados/mapas", showWarnings = FALSE)


# --- 1. Carregar Dados de Análise ---
dados_grafico <- readr::read_csv("resultados/tabelas/tabela_area.csv")

# --- 2. Preparação e Ordenação ---

dados_grafico <- dados_grafico %>%
  # Calcula o total para porcentagem (opcional)
  mutate(Porcentagem = (Area_Ha / sum(Area_Ha)) * 100) %>%
  # Ordena a Classe_Descricao com base na Area_Ha (Fator para o ggplot)
  mutate(Classe_Descricao = forcats::fct_reorder(Classe_Descricao, Area_Ha, .desc = TRUE))

# --- 3. Geração do Gráfico ggplot2 (Barra Horizontal) ---

# ⚠️ MUDANÇA 1: Movendo fill para aes() para ter cores por barra
grafico_uso_solo <- ggplot(dados_grafico, aes(x = Classe_Descricao, y = Area_Ha, fill = Classe_Descricao)) +
  
  # Gráfico de barras (geom_col)
  geom_col() + # fill agora está no aes()
  
  # Adicionar rótulos de dados
  geom_text(aes(label = paste0(round(Area_Ha, 1), " Ha")), 
            hjust = -0.1, size = 3.0, 
            color = "black") + # Usar cor sólida para o texto
  
  # Coordenada: Transforma para barras horizontais
  coord_flip() +
  
  scale_y_continuous(
    expand = expansion(mult = c(0.01, 0.15)) # Adiciona 15% de espaço no topo (direita) do eixo Y
  ) +
  
  scale_fill_discrete(guide = "none") + # Usa cores discretas e remove a legenda
  
  # Rótulos e Títulos
  labs(
    title = "Uso e Cobertura do Solo em Uruçuca, BA (2024)",
    subtitle = paste0("Total da Área Analisada: ", round(sum(dados_grafico$Area_Ha), 0), " Ha"),
    x = "Classe de Uso do Solo",
    y = "Área (Hectares - Ha)",
    caption = "Fonte: MapBiomas, Coleção 10"
  ) +
  
  # Temas de Visualização
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    axis.title.y = element_blank(), # Remove o título do eixo Y (Classe de Uso)
    panel.grid.major.y = element_blank(),
    legend.position = "none" # Garante que a legenda não apareça
  )

# 4. Salvar o Gráfico
ggsave(
  filename = "resultados/graficos/grafico_uso_solo.png",
  plot = grafico_uso_solo,
  width = 10,
  height = 6,
  units = "in"
)

# Visualizar o gráfico
print(grafico_uso_solo)
