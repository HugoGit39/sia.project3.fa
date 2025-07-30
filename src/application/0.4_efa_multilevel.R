model1 <- '
  level: 1
    fw1 =~ Happy + Relaxed + Energetic + Content
    fw2 =~ Stressed + Anxious + Irritated + Down

  level: 2
    fb1 =~ Happy + Relaxed + Energetic + Content
    fb2 =~ Stressed + Anxious + Irritated + Down
'

fit <- sem(model1, data = lavaan_df, cluster = "Name")
summary(fit, fit.measures = TRUE, standardized = TRUE)






