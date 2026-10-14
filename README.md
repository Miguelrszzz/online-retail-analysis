# Análisis de ventas online (Online Retail)

Análisis de transacciones de una tienda online con **SQLite** y **R**: calidad de datos, comportamiento de clientes (segmentación RFM y cohortes de retención) y productos que se compran juntos (algoritmo apriori).

> **Autor:** Miguel Sanz · Data Analyst & BI Specialist · [LinkedIn](https://www.linkedin.com/in/miguel-sanz-ba9b5b300)

---

## 1. Contexto y objetivo

Una tienda online necesita entender **cómo compran sus clientes** para decidir dónde enfocar sus campañas y su inventario. Este proyecto responde tres preguntas de negocio:

1. ¿Qué tipos de clientes tiene la tienda y cuáles generan más valor? (RFM)
2. ¿Qué porcentaje de clientes vuelve a comprar después de su primera compra y hay estacionalidad? (cohortes)
3. ¿Qué productos se compran juntos con más frecuencia? (apriori)

## 2. Datos

- **Fuente:** [indicar origen, por ejemplo UCI Machine Learning Repository, *Online Retail*]
- **Periodo:** diciembre 2010 – diciembre 2011 (el último mes está incompleto)
- **Tamaño:** [N filas] transacciones · [N] clientes · [N] productos
- **Campos principales:** factura, producto, cantidad, fecha, precio, `CustomerID`, país

## 3. Herramientas

| Herramienta | Uso |
|---|---|
| SQLite (DB Browser) | Almacenamiento y consultas |
| R (`dplyr`, `lubridate`, `ggplot2`) | Limpieza, análisis y gráficos |
| R Markdown | Reporte final en HTML |

## 4. Estructura del repositorio

```
├── code/
│   ├── 01_conexion_sqlite.R        # Conexión a la base de datos
│   ├── 02_analisis_cohortes.R      # Retención por cohortes
│   ├── 03_algoritmo_apriori.R      # Reglas de asociación
│   ├── 04_reporte.Rmd              # Reporte completo (incluye RFM)
│   └── Ventas_online_Proyecto_1.sqbpro
├── salidas/
│   ├── reporte.html                # Reporte renderizado
│   └── cohortes_retencion.png      # Gráfico de retención
└── README.md
```

## 5. Metodología

**Limpieza de datos**
- Se excluyeron registros sin `CustomerID`, facturas canceladas y cantidades o precios no válidos.
- Filas eliminadas: [N] de [N] ([X]%).

**Segmentación RFM**
- Cada cliente se puntúa por **recencia** (días desde su última compra), **frecuencia** (número de compras) y **valor monetario** (gasto total).
- Con esas puntuaciones se agrupan en segmentos (campeones, leales, en riesgo, perdidos, etc.).

**Análisis de cohortes**
- Cada cliente se asigna a la **cohorte** de su primer mes de compra.
- Se calcula cuántos clientes de cada cohorte vuelven a comprar en los meses siguientes, como porcentaje del tamaño inicial.

**Algoritmo apriori**
- Se agrupan los productos por factura y se buscan combinaciones que se compran juntas.
- Parámetros: soporte mínimo [X], confianza mínima [X].

## 6. Resultados

### Segmentos de clientes (RFM)

| Segmento | Clientes | % de clientes | % de ingresos |
|---|---|---|---|
| [Campeones] | [N] | [X]% | [X]% |
| [Leales] | [N] | [X]% | [X]% |
| [En riesgo] | [N] | [X]% | [X]% |
| [Perdidos] | [N] | [X]% | [X]% |

- [Hallazgo: qué porcentaje de ingresos aporta el segmento de mayor valor]
- [Hallazgo: tamaño del segmento en riesgo]

### Retención de clientes por cohorte

![Retención por cohorte](salidas/cohortes_retencion.png)

- Entre **20% y 30%** de los clientes vuelve a comprar el mes siguiente a su primera compra.
- La retención **se estabiliza** en torno a 20-30% en lugar de caer a cero: existe una base de clientes recurrentes.
- Las compras **aumentan hacia fin de año** (septiembre a noviembre), lo que apunta a estacionalidad.
- Las cohortes de septiembre retienen mejor (30-33%) que las de primavera (17-25%).
- La cohorte de diciembre de 2010 es el inicio del dataset e incluye clientes que ya existían, por lo que no es comparable con las demás.
- La última diagonal del gráfico es baja porque el último mes del dataset está incompleto; no representa abandono real.

### Productos que se compran juntos

- [Regla 1: si compra X, compra Y — soporte, confianza, lift]
- [Regla 2: ...]
- [Regla 3: ...]

## 7. Recomendaciones de negocio

1. **Cuidar a los mejores clientes:** [acción para el segmento Campeones/Leales, a partir de tu RFM] y recuperar a los clientes en riesgo con ofertas de reactivación.
2. **Reforzar el mes 1:** lanzar una campaña de recompra pocas semanas después de la primera compra, que es cuando se pierde la mayor parte de los clientes.
3. **Preparar el pico de fin de año:** asegurar inventario y promociones entre septiembre y noviembre.
4. **Ofrecer combos:** usar las reglas de apriori para sugerir productos complementarios. [Concretar con tus reglas]

## 8. Cómo reproducirlo

1. Clona el repositorio y descomprime los datos en una carpeta `data/`.
2. Abre `Ventas_online_Proyecto_1.sqbpro` en DB Browser for SQLite, o crea la base con el script `01_conexion_sqlite.R`.
3. Instala los paquetes: `install.packages(c("tidyverse", "lubridate", "arules", "DBI", "RSQLite"))`
4. Ejecuta los scripts de `code/` en orden numérico.
5. Para el reporte: abre `04_reporte.Rmd` en RStudio y presiona *Knit*.

## 9. Limitaciones

- El último mes está incompleto, por lo que no se interpreta la retención de ese mes.
- No hay datos de costos, por lo que el análisis se limita a ingresos y comportamiento.
- Solo se analiza un año de datos, así que la estacionalidad no se puede confirmar con otro año.
