

# 5. Define 2-factor CFA model
cfa_model_within <- '
  PositiveAffect =~ Happy + Relaxed + Energetic + Content
  NegativeAffect =~ Stressed + Anxious + Irritated + Down
'

# 6. Fit CFA model with clustering on Name
fit_within <- cfa(
  model = cfa_model_within,
  data = within_df,
  cluster = "Name",
  missing = "fiml"
)

# 7. Summary
summary(fit_within, fit.measures = TRUE, standardized = TRUE)

mod_within <- modindices(fit_within, sort = TRUE, minimum.value = 10)
head(mod_within, 20)  # See top 20 suggested changes

cfa_model_within_adj <- '
  level: 1
    PositiveAffect =~ Happy + Relaxed + Energetic + Content
    NegativeAffect =~ Stressed + Anxious + Irritated + Down

    # Add residual correlations suggested by modindices
    Relaxed ~~ Stressed
    Relaxed ~~ Down
    Stressed ~~ Down

'

fit_within_adj <- sem(
  cfa_model_within_adj,
  data = within_df,
  cluster = "Name",
  missing = "fiml"
)

summary(fit_within_adj, fit.measures = TRUE, standardized = TRUE)

