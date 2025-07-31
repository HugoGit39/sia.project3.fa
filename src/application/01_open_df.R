


# Check if a file was selected EMA
if (file_path != "") {
  sav_df <- read_sav(file_path)
  print(head(ema_df))  # Corrected
} else {
  cat("No file selected.\n")
}



# * 1.0 EMA Week 1 ----

# Open file dialog to select CSV
file_path <- tclvalue(tkgetOpenFile(filetypes = "{{CSV Files} {.csv}} {{All files} *}"))

# Check if a file was selected EMA
if (file_path != "") {
  ema_df <- read.csv(file_path)
  print(head(ema_df))  # Corrected
} else {
  cat("No file selected.\n")
}

ema_df <- ema_df %>% select(-Location)

col_rename_map <- c(
  # Affect VAS
  "X.1_VAS..Hoe.gelukkig.voel.je.je.op.dit.moment."     = "Happy",
  "X.2_VAS..Hoe.ontspannen.voel.je.je.op.dit.moment."   = "Relaxed",
  "X.3_VAS..Hoe.energiek.voel.je.je.op.dit.moment."     = "Energetic",
  "X.4_VAS..Hoe.tevreden.voel.je.je.op.dit.moment."     = "Content",
  "X.5_VAS..Hoe.gestrest.voel.je.je.op.dit.moment."     = "Stressed",
  "X.6_VAS..Hoe.angstig.voel.je.je.op.dit.moment."      = "Anxious",
  "X.7_VAS..Hoe.geïrriteerd.voel.je.je.op.dit.moment."  = "Irritated",
  "X.8_VAS..Hoe.neerslachtig.voel.je.je.op.dit.moment." = "Down",
  "X.9_VAS..Hoeveel.honger.heb.je.op.dit.moment."       = "Hungry",
  "X.10_VAS..Hoe.voel.je.je.op.dit.moment.lichamelijk." = "Physical",
  "X.12_VAS..Hoe.betekenisvol.vind.je.hetgeen.wat.je.net.voor.d" = "Meaning",
  
  # Social preference VAS
  "X.14_VAS..Zou.je.liever.met.anderen.zijn." = "PreferOthers",
  "X.15_VAS..Vind.je.dit.gezelschap.aangenaam." = "EnjoyCompany",
  "X.16_VAS..Zou.je.liever.alleen.willen.zijn." = "PreferAlone",
  
  # Social context MAQ
  "X.13_MAQ_1..Alleen"                  = "Alone",
  "X.13_MAQ_2..Alleen.met.onbekenden"   = "AloneWithStrangers",
  "X.13_MAQ_3..Je.partner.echtgenoot"   = "Partner",
  "X.13_MAQ_4..Je.kind.eren."           = "Children",
  "X.13_MAQ_5..Andere.familieleden"     = "Family",
  "X.13_MAQ_6..Vrienden"                = "Friends",
  "X.13_MAQ_7..Collega.s.klasgenoten"   = "Colleagues",
  "X.13_MAQ_8..Cliënten..klanten"       = "Clients",
  "X.13_MAQ_9..Andere.bekenden"         = "OtherKnown",
  
  # Location & activity SAQ
  "X.17_SAQ..Ben.je...."                 = "Location",
  "X.18_SAQ..En.ben.je....Als.je.vanuit.huis.werkt.kies..Thuis." = "WorkFromHome",
  "X.20_SAQ..Wat.was.je.net.voor.de.vragenlijst.aan.het.doen."   = "PreviousActivity",
  
  # Activities MAQ
  "X.19_MAQ_1..Werken.studeren"          = "WorkStudy",
  "X.19_MAQ_2..Vrije.tijd..actief..bijv..Wandelen..sporten..uitga" = "LeisureActive",
  "X.19_MAQ_3..Vrije.tijd..passief..bijv..Lezen..tv.kijken..op.te" = "LeisurePassive",
  "X.19_MAQ_4..Sociale.activiteit..bijv..Met.vrienden.afspreken."  = "SocialActivity",
  "X.19_MAQ_5..Huishoudelijke.taken..bijv..Schoonmaken..eten.koke" = "Household",
  "X.19_MAQ_6..Eten..bijv..Lunchen..uiteten."                      = "Eating",
  "X.19_MAQ_7..Uiterlijke.verzorging..bijv..Aankleden..tanden.poe" = "SelfCare",
  "X.19_MAQ_8..Anders"                                             = "OtherActivity",
  
  # Substances MAQ
  "X.21_MAQ_1..Caffeïne"                = "Caffeine",
  "X.21_MAQ_2..Alcohol"                 = "Alcohol",
  "X.21_MAQ_3..Tabak"                   = "Tobacco",
  "X.21_MAQ_4..Wiet.hasj"               = "Cannabis",
  "X.21_MAQ_5..Andere.drugs.medicatie"  = "OtherDrugs",
  "X.21_MAQ_6..Geen.van.bovenstaande"   = "NoSubstance"
)



names(ema_df)[names(ema_df) %in% names(col_rename_map)] <- col_rename_map[names(ema_df)[names(ema_df) %in% names(col_rename_map)]]

# * 2.0 Ochtend ----

# Open file dialog to select CSV
file_path <- tclvalue(tkgetOpenFile(filetypes = "{{CSV Files} {.csv}} {{All files} *}"))

# Check if a file was selected EMA
if (file_path != "") {
  mor_df <- read.csv(file_path)
  print(head(mor_df))  # Corrected
} else {
  cat("No file selected.\n")
}

mor_df <- mor_df %>% select(-Location)

col_rename_map_morning <- c(
  "X.1_CAL..Hoe.laat.ging.je.gisteravond.naar.bed." = "Bedtime",
  "X.2_CAL..Hoe.laat.werd.je.wakker.vanmorgen."     = "WakeTime",
  "X.3_VAS..Hoe.goed.heb.je.geslapen."              = "SleepQuality"
)

names(mor_df)[names(mor_df) %in% names(col_rename_map_morning)] <- col_rename_map_morning[names(mor_df)[names(mor_df) %in% names(col_rename_map_morning)]]

mor_df <- mor_df %>%
  mutate(
    Bedtime_parsed = hms(Bedtime),       # Parses HH:MM:SS
    WakeTime_parsed = hms(WakeTime),     # Parses HH:MM:SS
    SleepTime = case_when(
      !is.na(Bedtime_parsed) & !is.na(WakeTime_parsed) ~ {
        diff <- as.numeric(WakeTime_parsed - Bedtime_parsed, units = "hours")
        ifelse(diff < 0, diff + 24, diff)  # Handle overnight
      },
      TRUE ~ NA_real_
    )
  ) %>%
  dplyr::select(-Bedtime_parsed, -WakeTime_parsed)

# * 3.0 Avond ----

# Open file dialog to select CSV
file_path <- tclvalue(tkgetOpenFile(filetypes = "{{CSV Files} {.csv}} {{All files} *}"))

# Check if a file was selected EMA
if (file_path != "") {
  eve_df <- read.csv(file_path)
  print(head(eve_df))  # Corrected
} else {
  cat("No file selected.\n")
}

eve_df <- eve_df %>% select(-Location)

col_rename_map_evening <- c(
  # Evening questions
  "X.1_SAQ..Was.vandaag.een.normale.dag.voor.je."   = "NormalDay",
  "X.2_SAQ..Was.vandaag.een.werk.schooldag."       = "WorkOrSchoolDay",
  "X.3_CAL..Wanneer.begon.en.eindigde.je.werk.schooldag." = "WorkSchoolPeriod"
)

names(eve_df)[names(eve_df) %in% names(col_rename_map_evening)] <- col_rename_map_evening[names(eve_df)[names(eve_df) %in% names(col_rename_map_evening)]]

# * 4.0 Participants ----

# Open file dialog to select CSV
file_path <- tclvalue(tkgetOpenFile(filetypes = "{{CSV Files} {.csv}} {{All files} *}"))

# Check if a file was selected PARTICIPANTS
if (file_path != "") {
  participants_df <- read.csv(file_path)
  print(head(participants_df))  # Corrected
} else {
  cat("No file selected.\n")
}

participants_df <- participants_df %>% select(-Location)

col_rename_map_participants <- c(
  
  # Participant info
  "X.2_FFT..Voornaam." = "FirstName",
  "X.3_CAL..Geboortedatum." = "Birthdate",
  "X.4_SAQ..Geslacht." = "Sex",
  "X.9_SAQ..Ben.je.een.ochtendpersoon.of.een.avondpersoon.." = "Chronotype",
  "X.5_SAQ..Hoe.laat.sta.je.meestal.op.op.doordeweekse.dagen." = "WakeWeekdays",
  "X.6_SAQ..Hoe.laat.sta.je.meestal.op.in.het.weekend." = "WakeWeekend",
  
  # General wellbeing
  "X.7_VAS..Hoe.gelukkig.ben.je.in.het.algemeen.." = "GeneralHappiness",
  "X.8_VAS..Hoe.tevreden.ben.je.met.je.leven.in.het.algemeen.." = "GeneralSatisfaction",
  "X.10_VAS..Hoe.doelgericht.en.zinvol.vind.je.je.leven.in.het" = "LifePurpose"
)

names(participants_df)[names(participants_df) %in% names(col_rename_map_participants)] <- col_rename_map_participants[names(participants_df)[names(participants_df) %in% names(col_rename_map_participants)]]

participants_df <- participants_df %>%
  mutate(
    Birthdate = dmy(Birthdate),  # Convert to Date
    Age = as.integer(interval(Birthdate, today()) / years(1))  # Calculate Age
  )

# * 5.0 Join ----

# Ensure unique column names to prevent join errors
ema_df <- ema_df %>% rename_with(make.unique)
mor_df <- mor_df %>% rename_with(make.unique)
eve_df <- eve_df %>% rename_with(make.unique)
participants_df <- participants_df %>% rename_with(make.unique)

# Define just the  names
vas_items <- c("Happy", "Relaxed", "Energetic", "Content", 
               "Stressed", "Anxious", "Irritated", "Down")

social_items <- c("Alone", "AloneWithStrangers", "Partner", "Children", 
                  "Family", "Friends", "Colleagues", "Clients", "OtherKnown")

location_items <- c("Location", "WorkFromHome", "PreviousActivity")

activity_items <- c("WorkStudy", "LeisureActive", "LeisurePassive", 
                    "SocialActivity", "Household", "Eating", "SelfCare", "OtherActivity")

substance_items <- c("Caffeine", "Alcohol", "Tobacco", "Cannabis", "OtherDrugs", "NoSubstance")

morning_items <- c("Bedtime", "WakeTime", "SleepQuality")

evening_items <- c("NormalDay", "WorkOrSchoolDay", "WorkSchoolPeriod")

participant_items <- c(
  "FirstName", "Birthdate", "Sex", "Chronotype",
  "WakeWeekdays", "WakeWeekend",
  "GeneralHappiness", "GeneralSatisfaction", "LifePurpose"
)

#join
# 1. Select relevant columns from each dataset
ema_selected <- ema_df %>%
  select(Name, all_of(vas_items), all_of(social_items),
         all_of(location_items), all_of(activity_items),
         all_of(substance_items))

participants_selected <- participants_df %>%
  select(Name, all_of(participant_items))

mor_selected <- mor_df %>%
  select(Name, all_of(morning_items))

eve_selected <- eve_df %>%
  select(Name, all_of(evening_items))

# 2. Join all data on "Name"
final_df <- ema_selected %>%
  left_join(participants_selected, by = "Name") %>%
  left_join(mor_selected, by = "Name") %>%
  left_join(eve_selected, by = "Name")

#create factors of binary avriables
final_df[social_items] <- lapply(final_df[social_items], factor)
final_df[activity_items] <- lapply(final_df[activity_items], factor)
final_df[substance_items] <- lapply(final_df[substance_items], factor)

# Convert to long format
long_df <- final_df %>%
  dplyr::select(Name, Sex, Age, day = Scheduled.Time.x, all_of(vas_items)) %>%
  mutate(day = as.Date(day)) %>%
  pivot_longer(cols = all_of(vas_items),
               names_to = "Item",
               values_to = "Value")


