library(haven)    
library(dplyr)    
library(labelled) 


datos <- read_sav("input/Latinobarometro_2020_Esp_Spss_v1_0.sav")


datos_chile <- datos %>% filter(IDENPA == 152)

datos <- datos_chile %>%
  select(REG, EDAD, SEXO, P38N, P37N.A, P37N.B, P37N.C, P37N.D) %>%
  rename(
    region = REG,
    edad = EDAD,
    sexo = SEXO,
    percepcion_inmigracion = P38N,
    P37NA = P37N.A,
    P37NB = P37N.B,
    P37NC = P37N.C,
    P37ND = P37N.D
  )



datos$percepcion_inmigracion <- as_factor(datos$percepcion_inmigracion)
datos$sexo <- as_factor(datos$sexo)
datos$region <- as_factor(datos$region)


datos$percepcion_num <- case_when(
  datos$percepcion_inmigracion == "Lo beneficia" ~ 1,
  datos$percepcion_inmigracion == "Lo perjudica" ~ 0,
  TRUE ~ NA_real_ 
)


datos$edad <- as.numeric(datos$edad)


datos$P37NA <- as.numeric(datos$P37NA)
datos$P37NB <- as.numeric(datos$P37NB)
datos$P37NC <- as.numeric(datos$P37NC)
datos$P37ND <- as.numeric(datos$P37ND)



datos <- datos %>%
  filter(!percepcion_inmigracion %in% c("No sabe / No contesta",
                                        "No preguntada",
                                        "No aplicable",
                                        "No contesta",
                                        "No sabe",
                                        "Ni beneficia ni perjudica")) %>%
  ungroup() 


datos$percepcion_inmigracion <- droplevels(datos$percepcion_inmigracion)
datos$sexo <- droplevels(datos$sexo)
datos$region <- droplevels(datos$region)

saveRDS(datos, "procesamiento/chile_procesado.rds")
