# Compute descriptive stats per subject, per item
between_descriptives <- long_df %>%
  group_by(Name, Item) %>%
  summarise(
    Mean = mean(Value, na.rm = TRUE),
    SD = sd(Value, na.rm = TRUE),
    Variance = var(Value, na.rm = TRUE),
    N = sum(!is.na(Value)),
    .groups = "drop"
  )

# Create between-person dataframe including Age and Sex
between_df <- final_df %>%
  group_by(Name) %>%
  summarise(
    Age = first(Age),
    Sex = first(Sex),
    across(c(Happy, Relaxed, Energetic, Content,
             Stressed, Anxious, Irritated, Down), 
           ~ mean(.x, na.rm = TRUE))
  ) %>%
  ungroup()
