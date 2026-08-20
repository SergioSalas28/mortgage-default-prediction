[01_idea_y_datos.md](https://github.com/user-attachments/files/31245615/01_idea_y_datos.md)
# Entrega 1 - Idea del proyecto y datos

## 1. Idea del proyecto

El objetivo del proyecto es analizar préstamos hipotecarios para estudiar qué características están relacionadas con la morosidad y, posteriormente, desarrollar un modelo que permita identificar qué préstamos presentan una mayor probabilidad de tener problemas de pago.

La idea es combinar la información disponible en el momento en que se origina cada hipoteca con su comportamiento posterior, para poder estudiar la relación entre las características iniciales del préstamo y su evolución.

## 2. Datos que se utilizarán

El proyecto utilizará principalmente dos tipos de tablas:

### Origination (`orig`)

Las tablas `orig` contienen información sobre el préstamo en el momento de su originación.

Entre las variables disponibles se encuentran características del préstamo, del inmueble y del prestatario.

Se utilizarán inicialmente los datos correspondientes a los años:

- 2020
- 2021
- 2022
- 2023
- 2024

### Performance (`perf`)

Las tablas `perf` contienen información sobre el seguimiento de los préstamos a lo largo del tiempo.

Estas tablas permiten observar cómo evoluciona cada hipoteca después de su originación y contienen variables especialmente relevantes para estudiar el comportamiento de pago y la morosidad.

Cada tabla contiene el seguimiento posterior de cada una de las hipotecas de su mismo año, es decir la tabla `perf 2020` contiene datos de las hipótecas que se pidieron en 2020 desde ese mismo año hasta la actualidad.

## 3. Relación entre los datos

Las tablas `orig` y `perf` se relacionarán mediante el campo:

`loan_sequence_number`

La tabla `orig` proporciona la información inicial de cada préstamo, mientras que `perf` contiene múltiples registros de seguimiento para un mismo préstamo a lo largo del tiempo.

Por tanto, la relación entre ambas fuentes no es simplemente una relación 1:1: una hipoteca puede tener múltiples observaciones en `perf`.

## 4. Objetivo posterior

Una vez preparados y limpiados los datos, se construirá una capa final de datos que combine la información de originación con el historial de performance.

Este dataset servirá como base para:

- realizar análisis exploratorio de los datos;
- estudiar los factores relacionados con la morosidad;
- crear variables derivadas;
- desarrollar posteriormente un modelo predictivo.

## 5. Fuente de datos

Los datos utilizados en este proyecto proceden de Freddie Mac, concretamente del conjunto de datos Single-Family Loan-Level Dataset.
https://www.freddiemac.com/research/datasets/sf-loanlevel-dataset?utm_source=chatgpt.com De aqui es el dataset, lo único que es necesario registrarse para acceder a él.
