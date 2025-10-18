Projeto final
title: Relatório de Uso e Cobertura do Solo: Análise Geoespacial do Município de Uruçuca (BA)
author: Regina Guimaraes silva
---
Resumo
Este relatório apresenta os resultados da análise de uso e cobertura do solo para o município de Uruçuca, no estado da Bahia, com base nos dados geoespaciais da Coleção 10 do projeto MapBiomas. O trabalho inclui o processamento de dados raster, cálculo de área por classe e visualização cartográfica dos resultados. O Objetivo do trabalho é analisar a cobertura de uso do solo no múnicipio no ano de 2024 e identificar a proporção e organaização espacial das diferentes unidades de paisagem para o muncípio. O processamento geoespacial foi realizado utilizando a linguagem R e os pacotes especializados sf (vetor), terra (raster) e tmap (cartografia). As principais etapas incluíram o recorte Espacial, onde o raster de uso do solo do MapBiomas foi recortado utilizando o limite vetorial do município de Uruçuca e o cálculo de área, no qual a frequência de pixels foi contada para cada classe de uso do solo, e as contagens foram convertidas em Hectares (Ha). A análise revela que a Formação Florestal é a classe predominante, respondendo por 92% da área do município, conforme apesentado no gáfico 1. Utilizar ferramentas geoespaciais para conseguir informações atuais sobre as classes de uso e cobertura, bem como as proporções fornecem informações valiosas para futuras ações de planejamento e conservação.

| **Responsável pela Criação** | Regina Guimarães Silva |
| **Data da Criação/Análise** | Outubro de 2025 |
| **Software Utilizado** | R (Linguagem de Programação) e pacotes: `readr`,  `dplyr`,  `tibble`, `tidyverse`, `lubridate`, `patchwork`, `terra`, `sf`, `ggplot2`. |
| **Contato** | rgsilva.ppgecb@uesc.br |

Os dados de uso e cobertura do solo podem ser baixados no site do mapbiomas: https://brasil.mapbiomas.org/
