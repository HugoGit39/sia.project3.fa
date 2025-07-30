

# Open file dialog to select CSV
file_path <- tclvalue(tkgetOpenFile(filetypes = "{{CSV Files} {.csv}} {{All files} *}"))

# Check if a file was selected EMA
if (file_path != "") {
  ema_df <- read.csv(file_path)
  print(head(ema_df))  # Corrected
} else {
  cat("No file selected.\n")
}

#change names
col_rename_map <- c(
  "X.1_VAS..Hoe.gelukkig.voel.je.je.op.dit.moment."     = "Happy",
  "X.2_VAS..Hoe.ontspannen.voel.je.je.op.dit.moment."   = "Relaxed",
  "X.3_VAS..Hoe.energiek.voel.je.je.op.dit.moment."     = "Energetic",
  "X.4_VAS..Hoe.tevreden.voel.je.je.op.dit.moment."     = "Content",
  "X.5_VAS..Hoe.gestrest.voel.je.je.op.dit.moment."     = "Stressed",
  "X.6_VAS..Hoe.angstig.voel.je.je.op.dit.moment."      = "Anxious",
  "X.7_VAS..Hoe.geïrriteerd.voel.je.je.op.dit.moment."  = "Irritated",
  "X.8_VAS..Hoe.neerslachtig.voel.je.je.op.dit.moment." = "Down"
)

names(ema_df)[names(ema_df) %in% names(col_rename_map)] <- col_rename_map[names(ema_df)[names(ema_df) %in% names(col_rename_map)]]

# Open file dialog to select CSV
file_path <- tclvalue(tkgetOpenFile(filetypes = "{{CSV Files} {.csv}} {{All files} *}"))

# Check if a file was selected PARTICIPANTS
if (file_path != "") {
  participants_df <- read.csv(file_path)
  print(head(participants_df))  # Corrected
} else {
  cat("No file selected.\n")
}

#change names
names(participants_df)[8:9] <- c("Birthdate", "Sex")

#Well date format + age calculation
participants_df$Birthdate <- format(as.Date(participants_df$Birthdate, format = "%d/%m/%Y"), "%Y%m%d")

participants_df$Age <- as.integer(
  floor(
    as.numeric(difftime(Sys.Date(), as.Date(participants_df$Birthdate, format = "%Y%m%d"), units = "days")) / 365.25
  )
)

#join based on particpants ID
final_df <- left_join(ema_df, participants_df, by = "Name")

# Define just the VAS item names
vas_items <- c("Happy", "Relaxed", "Energetic", "Content", 
               "Stressed", "Anxious", "Irritated", "Down")

# Convert to long format
long_df <- final_df %>%
  dplyr::select(Name, Sex, Age, day = Scheduled.Time.x, all_of(vas_items)) %>%
  mutate(day = as.Date(day)) %>%
  pivot_longer(cols = all_of(vas_items),
               names_to = "Item",
               values_to = "Value")


