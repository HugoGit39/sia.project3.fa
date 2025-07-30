###########
#
# between_df 
#
###########

# Run KMO and Bartlett’s test on between_df
between_test <- between_df %>% dplyr::select(Happy, Relaxed, Energetic, Content,
                                  Stressed, Anxious, Irritated, Down)

# KMO test
kmo_result <- KMO(between_test)

# Bartlett’s test
bartlett_result <- cortest.bartlett(cor(between_test), n = nrow(between_test))

###########
#
# within_df 
#
###########

within_test <- within_centered_df %>% dplyr::select(Happy, Relaxed, Energetic, Content,
                                          Stressed, Anxious, Irritated, Down)

# KMO test
kmo_result <- KMO(within_test)

# Bartlett’s test
bartlett_result <- cortest.bartlett(cor(within_test), n = nrow(within_test))
