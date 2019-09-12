library(tidyverse)
library(fs)
library(janitor)

setwd('~/Projects/renta-sec-censal/')

files <- fs::dir_ls('src')

clean_csv <- function(file) {
  tsv <- read_tsv(file, skip = 4) %>% 
    clean_names() %>% 
    filter(str_detect(x1, 'sección')) %>%
    remove_empty('cols')
  
  # Casi todos los CSV
  if (length(colnames(tsv)) == 5) {
    df <- tsv %>% 
      rename(
        name = x1,
        renta_media_por_persona_y_2016 = renta_media_por_persona,
        renta_media_por_persona_y_2015 = x3,
        renta_media_por_hogar_y_2016 = renta_media_por_hogar,
        renta_media_por_hogar_y_2015 = x5)
  }
  
  # Guipuzcoa solo tiene datos de 2016
  if (length(colnames(tsv)) == 3 ) {
    df <- tsv %>% 
      rename(
        name = x1,
        renta_media_por_persona_y_2016 = renta_media_por_persona,
        renta_media_por_hogar_y_2016 = renta_media_por_hogar)
  }
  
  # Alava no tiene datos por sección
  if (length(colnames(tsv)) == 1) {
    df <- tsv %>% 
      mutate(
        id = str_sub(x1, 1, 10),
        id_short = str_sub(x1, -5),
        municipio = str_trim(str_sub(x1, 12, -14)),
        group = NA,
        year = NA,
        value = NA
      ) %>% 
    select(-x1)
    
    return(df)
  }
  
  df %>% 
    slice(-1) %>% 
    slice(1:(n()-4))
  
  tidy <- gather(df, group, value, 2:length(colnames(df))) %>% 
    separate(group, c('group', 'year'), sep = '_y_') %>%
    mutate(value = as.numeric(value)) %>% 
    mutate(
      id = str_sub(name, 1, 10),
      id_short = str_sub(name, -5),
      municipio = str_trim(str_sub(name, 12, -14))
    ) %>% 
    select(id, id_short, municipio, everything(), -name)
  
  return(tidy)
}

# Clean everything and write file
df <- files %>% 
  map_dfr(clean_csv) %>% 
  write_csv('output/data.csv')

df %>%
  filter(group == 'renta_media_por_persona', year == '2016') %>% 
  filter(value > 0) %>% 
  write_csv('output/renta_persona.csv')

df %>%
  filter(group == 'renta_media_por_hogar', year == '2016') %>% 
  filter(value > 0) %>% 
  write_csv('output/renta_hogar.csv')
