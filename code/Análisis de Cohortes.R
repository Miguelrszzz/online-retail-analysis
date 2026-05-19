## Tipo de dato del dataframe

sapply(df_retail, class)

## Transformar Fecha y Hora a Date

df_retail <- df_retail %>%
  mutate(Fecha = as.Date(Fecha))

## Identificar cohortes

df_cohortes <- df_retail %>%
  group_by(CustomerID) %>%
  mutate(Mes_Cohorte = floor_date(min(Fecha), "month")) %>%
  ungroup()

# 2. Calcular el mes de cada factura y el índice (distancia en meses)
df_cohortes <- df_cohortes %>%
  mutate(
    Mes_Factura = floor_date(Fecha, "month"),
    Indice_Mes = as.numeric(interval(Mes_Cohorte, Mes_Factura) %/% months(1))
  )

# 3. Agrupar para obtener la retención
tabla_retencion <- df_cohortes %>%
  group_by(Mes_Cohorte, Indice_Mes) %>%
  summarise(n_clientes = n_distinct(CustomerID), .groups = 'drop') %>%
  # Calcular el porcentaje basado en el mes 0 de cada cohorte
  group_by(Mes_Cohorte) %>%
  mutate(pct_retencion = n_clientes / first(n_clientes)) %>%
  ungroup()


## Grafico ggplot

ggplot(tabla_retencion, aes(x = Indice_Mes, y = reorder(format(Mes_Cohorte, "%Y-%m"), desc(Mes_Cohorte)), fill = pct_retencion)) +
  geom_tile(color = "white") +
  geom_text(aes(label = scales::percent(pct_retencion, accuracy = 1)), size = 3) +
  scale_fill_gradient(low = "#e3f2fd", high = "#1565c0", labels = scales::percent) +
  labs(
    title = "Análisis de Cohortes: Retención Mensual de Clientes",
    subtitle = "Basado en el primer mes de compra (Online Retail Dataset)",
    x = "Meses transcurridos desde la primera compra",
    y = "Cohorte (Mes de Inicio)",
    fill = "% Retención"
  ) +
  theme_minimal()
