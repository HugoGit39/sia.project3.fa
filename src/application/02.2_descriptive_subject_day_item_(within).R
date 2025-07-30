# Aggregate per day per person (mean of items)
lavaan_df <- final_df %>%
  group_by(Name, day = as.Date(Scheduled.Time.x)) %>%
  summarise(across(c(Happy, Relaxed, Energetic, Content,
                     Stressed, Anxious, Irritated, Down),
                   ~ mean(.x, na.rm = TRUE)),
            .groups = "drop")



# Compute descriptive stats per subject, per item, per day
subject_day_item_descriptives <- long_df %>%
  group_by(Name, day, Item) %>%
  summarise(
    Mean = mean(Value, na.rm = TRUE),
    SD = sd(Value, na.rm = TRUE),
    Variance = var(Value, na.rm = TRUE),
    N = sum(!is.na(Value)),
    .groups = "drop"
  )

#create within dfs for cfa and efa
within_df <- long_df %>%
  group_by(Name, day, Item) %>%
  summarise(Value = mean(Value, na.rm = TRUE), .groups = "drop") %>%
  pivot_wider(names_from = Item, values_from = Value)

# 1. Compute weekly mean per subject per item
weekly_means <- long_df %>%
  group_by(Name, Item) %>%
  summarise(WeeklyMean = mean(Value, na.rm = TRUE), .groups = "drop")

# 2. Compute daily mean per subject per item
daily_means <- long_df %>%
  group_by(Name, day, Item) %>%
  summarise(DailyMean = mean(Value, na.rm = TRUE), .groups = "drop")

# 3. Join and subtract to get centered values
within_centered <- daily_means %>%
  left_join(weekly_means, by = c("Name", "Item")) %>%
  mutate(Centered = DailyMean - WeeklyMean)

# 4. create within dfs for efa and cfae daily average - weekly averages
within_centered_df <- within_centered %>%
  dplyr::select(Name, day, Item, Centered) %>%
  pivot_wider(names_from = Item, values_from = Centered)

