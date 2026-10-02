# 04. Análisis y modelado

## 1. Problema que se busca resolver

En el Jupyter Notebook se ha desarrollado un primer modelo de
**clasificación de préstamos hipotecarios según la presencia o ausencia
de morosidad**.

Para trabajar a nivel de préstamo se construyó `df_loan`, dejando una
fila por `loan_sequence_number`.

La variable objetivo se definió como:

``` python
df_loan['delinquency'] = (
    df_loan['current_loan_delinquency_status'] >= 1
).astype(int)
```

Por tanto, `0` representa un préstamo sin morosidad y `1` un préstamo
con morosidad.

El objetivo del modelado es comprobar hasta qué punto las
características disponibles del préstamo permiten identificar los casos
de morosidad.

## 2. Trabajo realizado en el Jupyter Notebook

El trabajo de modelado se realizó sobre `df_loan`.

Los principales pasos fueron:

1.  Construcción de `df_loan` con una fila por préstamo mediante
    `groupby(loan_sequence_number)`.
2.  Uso del primer valor para las variables de originación y del máximo
    para `current_loan_delinquency_status`.
3.  Creación de la variable objetivo `delinquency`.
4.  Preparación de las variables utilizadas para el modelado.
5.  Separación de los datos en entrenamiento y prueba.
6.  Comparación de diferentes modelos de clasificación.
7.  Tratamiento del desequilibrio entre las clases.
8.  Estudio de diferentes umbrales de clasificación.
9.  Evaluación mediante métricas y matriz de confusión.
10. Inicio de una optimización de XGBoost mediante Optuna.

El dataset quedó en **249.936 préstamos**.

## 3. Modelos probados

Se probaron diferentes alternativas.

### Regresión logística balanceada

Se utilizó `class_weight='balanced'`.

Para la clase de morosidad obtuvo:

- Precision: 0,17
- Recall: 0,64
- F1: 0,27
- Accuracy: 0,66

Sirvió como primera referencia.

### Random Forest balanceado

Para la clase de morosidad obtuvo:

- Precision: 0,24
- Recall: 0,10
- F1: 0,14
- Accuracy: 0,88

Aunque el accuracy era elevado, detectaba muy poca morosidad.

### XGBoost estándar

Para la clase de morosidad obtuvo:

- Precision: 0,28
- Recall: 0,01
- F1: 0,01
- Accuracy: 0,90

Prácticamente no detectaba la clase de morosidad.

### LightGBM estándar

Para la clase de morosidad obtuvo:

- Precision: 0,43
- Recall: 0,00
- F1: 0,00
- Accuracy: 0,90

Tampoco detectaba prácticamente la clase de morosidad.

## 4. Tratamiento del desequilibrio

A partir de los resultados anteriores se incorporó un tratamiento
específico del desequilibrio en los modelos basados en árboles.

Para XGBoost y LightGBM se calculó:

``` python
scale_pos_weight = (
    (y_train == 0).sum() /
    (y_train == 1).sum()
)
```

El valor fue aproximadamente **9**.

### XGBoost balanceado

Obtuvo:

- Clase 1: precision 0,17
- Clase 1: recall 0,62
- Clase 1: F1 0,27
- Accuracy: 0,67
- ROC-AUC: aproximadamente 0,70

### LightGBM balanceado

Obtuvo:

- Clase 1: precision 0,17
- Clase 1: recall 0,65
- Clase 1: F1 0,27
- Accuracy: 0,65

Se decidió continuar trabajando con **XGBoost balanceado**.

## 5. División de entrenamiento y prueba

Se utilizó siempre la misma separación:

``` python
X_train, X_test, y_train, y_test = train_test_split(
    X,
    y,
    test_size=0.20,
    random_state=42,
    stratify=y
)
```

El conjunto de prueba quedó formado por **49.988 préstamos**:

- 45.030 de clase 0.
- 4.958 de clase 1.

La separación fue estratificada para mantener la proporción de las
clases.

## 6. Estudio del umbral

Para XGBoost balanceado se probaron los umbrales 0,50, 0,45, 0,40, 0,35,
0,30, 0,25 y 0,20.

Se observó que al reducir el umbral aumentaba el recall de la clase de
morosidad, pero disminuía la precision.

| Umbral | Precision 1 | Recall 1 | F1 1 |
|-------:|------------:|---------:|-----:|
|   0,50 |        0,17 |     0,62 | 0,27 |
|   0,45 |        0,16 |     0,69 | 0,26 |
|   0,40 |        0,15 |     0,76 | 0,24 |
|   0,35 |        0,14 |     0,82 | 0,23 |
|   0,30 |        0,13 |     0,87 | 0,22 |
|   0,25 |        0,12 |     0,91 | 0,21 |
|   0,20 |        0,11 |     0,95 | 0,20 |

Para comparar modelos e hiperparámetros se mantuvo inicialmente el
umbral **0,50**.

## 7. Optimización de XGBoost

Se compararon distintas alternativas de búsqueda de hiperparámetros y
finalmente se continuó con **Optuna**.

La estrategia utilizada fue mantener inicialmente `scale_pos_weight`
aproximadamente en 9 y el umbral en 0,50, optimizando los
hiperparámetros de XGBoost.

Para evitar utilizar el conjunto de prueba en la selección, se creó una
validación interna a partir de `X_train`.

La primera optimización tuvo como objetivo maximizar la **precision de
la clase 1** y realizó **30 trials**.

El mejor modelo, evaluado posteriormente sobre `X_test`, obtuvo:

- Precision clase 1: **0,19**
- Recall clase 1: **0,47**
- F1 clase 1: **0,27**
- Accuracy: **0,74**

Comparación:

| Modelo                           | Precision 1 | Recall 1 | F1 1 | Accuracy |
|----------------------------------|------------:|---------:|-----:|---------:|
| XGBoost balanceado               |        0,17 |     0,62 | 0,27 |     0,67 |
| XGBoost optimizado por precision |        0,19 |     0,47 | 0,27 |     0,74 |

La optimización por precision aumentó precision y accuracy, pero redujo
el recall. Por tanto, existe un intercambio entre detectar más casos de
morosidad y reducir las falsas alarmas.

## 8. Evaluación final

La matriz de confusión obtenida para el XGBoost balanceado fue:

|                        | Predicción sin morosidad | Predicción con morosidad |
|------------------------|-------------------------:|-------------------------:|
| **Real sin morosidad** |                   30.877 |                   14.153 |
| **Real con morosidad** |                    1.889 |                    3.069 |

Esto significa que:

- 30.877 préstamos sin morosidad fueron clasificados correctamente.
- 14.153 préstamos sin morosidad fueron marcados como morosos.
- 1.889 préstamos con morosidad no fueron detectados.
- 3.069 préstamos con morosidad fueron detectados correctamente.

De los **4.958 préstamos que realmente presentaban morosidad**, se
detectaron **3.069**, aproximadamente el **61,9 %**.

De los **45.030 préstamos que realmente no presentaban morosidad**, se
identificaron correctamente **30.877**, aproximadamente el **68,6 %**.

El acierto global sobre los **49.988 préstamos de prueba** fue
aproximadamente del **67,9 %**.

## Conclusión

Esta entrega recoge el trabajo realizado en el Jupyter Notebook para
pasar de `df_loan` a un primer modelo de clasificación de morosidad.

Se construyó la variable objetivo, se realizó la separación entre
entrenamiento y prueba, se compararon varios modelos, se trató el
desequilibrio, se estudiaron diferentes umbrales y se inició la
optimización de XGBoost mediante Optuna.

El XGBoost balanceado utilizado como referencia detectó aproximadamente
el **61,9 % de los préstamos que realmente presentaban morosidad**. La
optimización posterior por precision mostró que modificar el objetivo
cambia el equilibrio entre precision y recall.

El siguiente paso del modelado es continuar comparando diferentes
objetivos de optimización antes de establecer definitivamente la
configuración final.
