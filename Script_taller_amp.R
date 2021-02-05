##%######################################################%##
#                                                          #
####        Taller: Introducción al Análisis de         ####
####            Datos con R para Psicólogos             ####
####                                                    ####
####        Bach. Ps. Brian Norman Peña-Calero          ####
####                brianmsm@gmail.com                  ####
####                                                    ####
####    AMP - Semana Académica Facultad Psicología 2020 ####
#                                                          #
##%######################################################%##


# 1. Ejecución de código

# Cada línea de código que está en el script puede ejecutarse de 4 formas:
#   - Estando el cursor sobre la línea, presionar el botón "run"
#   - Estando el cursor sobre la línea, presionar CTRL + ENTER (teclado) [RECOMENDADO]
#   - Seleccionando la línea entera, presionar el botón "run"
#   - Seleccionando la línea entera, presionar CTRL + ENTER (teclado)

"¡Hola Mundo!"
print("¡Hola Mundo!")

# Es necesario usar concatenar
print(c("¡Hola Mundo!", "Saludos desde AMP"))

# La función "paste" permite juntar en un mismo elemento.
print(paste("¡Hola Mundo!", "Saludos desde AMP"))

# 2. Asignación de objetos
# El símbolo <- significa que se asigna lo de la derecha al nombre de una "variable" conocida
# como objeto. Se puede insertar fácilmente <-  con ALT + - (guión o símbolo menos).

hola <- "¡Hola Mundo!"
saludos <- "Saludos por Brian"

## Actividad. Hacer un print de los objetos 
print(paste(hola, saludos))

# 3. R como Calculadora

1 + 5
5 * 7
(5 * 8)/(6 + 4^2) 

## Actividad. Generar 2 objetos que contengan las edades de 2 personas
## de su elección (Ej. papá, mamá, hermano y/o uno mismo). Luego, restarlas,
## utilizando esa mismos objetos creados

papa <- 56
yo <- 24

hermano - yo

paste("La diferencia de edad con mi papá es", papa - yo,
      "años")
# 3. Paquetes y funciones
# Cuando vemos print(), c(), paste(), son funciones dentro de R que se pueden ejecutar
# sin necesidad de hacer un paso previo, es decir, ni bien se abre el software. Estas 
# funciones son conocidas como r-base. Sin embargo, también existen funciones extras
# para hacer todo tipo de cosas, desde importación de datos específicos, hasta análisis
# sumamente complejos. Estos paquetes se instalan con una función llamada install.packages(),
# y se cargan en el ambiente con la función library().

install.packages("googlesheets4")
library(googlesheets4)

gs4_deauth() 
read_sheet("https://docs.google.com/spreadsheets/d/1yBEFC3fnzG5AA09x86gH1cEbhVLx3iGcS628dOKAp1s/")


# Ahora mismo no podemos interactuar con la base de datos que se nos muestra, ya que no 
# está guardada en ningún lugar. 
# ¿Qué tenemos que hacer?

inteligencia <- read_sheet("https://docs.google.com/spreadsheets/d/1yBEFC3fnzG5AA09x86gH1cEbhVLx3iGcS628dOKAp1s/")

# readxl::read_excel()
# readr::read_csv()
# haven::read_sav()

# 4. Manipulaciones elementales

install.packages("tidyverse")
library(tidyverse)

# Para las operaciones vamos a utilizar el operador pipe ` %>% ` que significa 'luego' o 
# 'através de'. Por ejemplo: 
# 
# feliz %>% 
#   caer_vaso() %>% 
#   triste() %>% 
#   reparar()

# El operador pipe %>% se inserta con la combinación de teclas CTRL + SHIFT + M 

inteligencia %>% 
  count(AREA)

inteligencia %>% 
  count(SEXO)

inteligencia %>% 
  count(AREA, SEXO)

inteligencia %>% 
  count(SEXO, AREA)

# 4.1. Función filter

inteligencia %>% 
  filter(SEXO == "mujer") 

inteligencia %>% 
  filter(AREA == "Ciencias Básicas") # Cuidado con tilde

inteligencia %>% 
  filter(SEXO == "mujer", AREA == "Ciencias Básicas")

# 4.2. Función select

inteligencia %>% 
  select(I01:I20)

# Práctica: Seleccionen las respuesta del ítem 1 al 20 que sean de los varones

inteligencia %>% 
  filter(SEXO == "varon") %>% 
  select(I01:I20)




# 4.3. Sumar items
# La prueba EQ-i-M20 de Inteligencia emocional tiene la siguiente estructura:
#   - Intrapersonal: I03, I07, I10, I16
#   - Interpersonal: I01, I05, I13, I19
#   - Manejo de emociones: I02, I08, I12, I18
#   - Adaptabilidad: I06, I09, I11, I14
#   - Estado de ánimo general: I04, I15, I17, I20

# Ejemplo:
inteligencia %>% 
  rowwise() %>% 
  mutate(
    intra = sum(c_across(c(I03, I07, I10, I16))),
    inter = sum(c_across(c(I01, I05, I13, I19))),
    manejo_emociones = sum(c_across(c(I02, I08, I12, I18))),
    adaptabilidad = sum(c_across(c(I06, I09, I11, I14))),
    estado_animo = sum(c_across(c(I04, I15, I17, I20)))
  ) %>% 
  ungroup()

# Ejercicio final:
# 1. Crea la sumatoria de las 5 dimensiones de la prueba.
# 2. Guarda esto en un nuevo objeto, elige el nombre que desees.
# 3. Mediante la función select() muestra únicamente la información de SUJETO,
# AREA, SEXO y las nuevas variables. Que no se vean los ítems.

new_inteligencia <- inteligencia %>% 
  rowwise() %>% 
  mutate(
    intra = sum(c_across(c(I03, I07, I10, I16))),
    inter = sum(c_across(c(I01, I05, I13, I19))),
    manejo_emociones = sum(c_across(c(I02, I08, I12, I18))),
    adaptabilidad = sum(c_across(c(I06, I09, I11, I14))),
    estado_animo = sum(c_across(c(I04, I15, I17, I20)))
  ) %>% 
  ungroup()


new_inteligencia %>% 
  select(SUJETO:SEXO, intra:estado_animo)



# Plus:

new_inteligencia %>% 
  ggplot(aes(x = inter)) + 
  geom_histogram(bins = 12,
                 color = "black",
                 fill = "grey") +
  theme_bw()
