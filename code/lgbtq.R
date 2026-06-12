# ------------------------------------------------------------------------------------------------ #
# Este script analiza las percepciones de los ecuatorianos sobre la homosexualidad usando la
# Encuesta Mundial de Valores (WVS). Los datos utilizados están almacenados en el GitHub del LIDE
# https://github.com/laboratoriolide/WVSEcuador. Para consultar la fuente original, visita la 
# página de la WVSA www.worldvaluessurvey.org.
# ------------------------------------------------------------------------------------------------ #

# Cargar librerías
if(!require(tidyverse)) install.packages("tidyverse", repos = "http://cran.us.r-project.org")
if(!require(scales)) install.packages("scales", repos = "http://cran.us.r-project.org")
if(!require(patchwork)) install.packages("patchwork", repos = "http://cran.us.r-project.org")
if(!require(haven)) install.packages("haven", repos = "http://cran.us.r-project.org")
if(!require(labelled)) install.packages("labelled", repos = "http://cran.us.r-project.org")

# Cargar datos
WVSEcuador <- read_dta("https://github.com/laboratoriolide/WVSEcuador/raw/main/data/WVSEcuador.dta")

# Etiquetas de las variables
WVSEcuador_labels <- var_label(WVSEcuador)

# --- Procesamiento ----

# Año de la encuesta
WVSEcuador$anio <- as_factor(WVSEcuador$S020)

# Sexo de la persona encuestada
WVSEcuador$sexo <- as_factor(WVSEcuador$X001)
WVSEcuador$sexo <- recode_factor(WVSEcuador$sexo, Male = "Hombre", Female = "Mujer")

# ---- A124_09: Preferiría no tener a un homosexual como vecino ----

# Calcular la media por sexo
A124_09 <- WVSEcuador %>% group_by(anio, sexo) %>% 
  summarize(mean = mean(A124_09 == 1, na.rm = TRUE))

# Guardar los resultados
saveRDS(A124_09, "outputs/lgbtq/homo_vecinos")

# Gráfico comparando hombres y mujeres en los años 2013 y 2018
A124_09 %>% 
  ggplot(aes(x = sexo, y = mean, fill = anio)) +
  geom_col(position = position_dodge(width = 0.8), width = 0.7) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  labs(
    x = NULL,
    y = NULL,
    fill = NULL
  ) +
  theme_minimal()

# ---- D081: Las parejas homosexuales son tan buenos padres como otras parejas ----

# Renombrar los niveles de la variable
WVSEcuador$D081 <- as_factor(WVSEcuador$D081)
WVSEcuador$D081 <- droplevels(WVSEcuador$D081, exclude = c("Missing; Not available", "Not asked", "Not applicable", "No answer"))
levels(WVSEcuador$D081) <- c("No sabe", "Totalmente de acuerdo", "De acuerdo", "Indiferente", "En desacuerdo", "Totalmente en desacuerdo")

# Calcular la frecuencia relativa (Esta pregunta solo se hizo en el 2018)
D081 <- WVSEcuador %>% filter (anio == 2018, !is.na(D081)) %>% group_by(D081) %>% 
  summarize(n = n()) %>% mutate(porc = n/sum(n))

# Guardar los resultados
saveRDS(D081, "outputs/lgbtq/homo_padres")

# Gráfico
D081 %>% 
  ggplot(aes(x = D081, y = porc)) +
  geom_col(position = position_dodge(width = 0.8), width = 0.7) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  labs(
    x = NULL,
    y = NULL,
    fill = NULL
  ) +
  theme_minimal()
