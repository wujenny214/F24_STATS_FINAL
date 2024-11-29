# Load necessary library for rename
library(dplyr)
library(readxl)

# Vector of all 50 states
states <- c("Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", 
            "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", 
            "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", 
            "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", 
            "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", 
            "New Hampshire", "New Jersey", "New Mexico", "New York", 
            "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", 
            "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", 
            "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", 
            "West Virginia", "Wisconsin", "Wyoming")

# Vector of desired columns to keep
desired_cols <- c('FIPS', 'State',  
                  "Life Expectancy", "Segregation Index...200",
                  "% Limited Access to Healthy Foods", 
                  "% Uninsured Adults", 
                  "Spending per Pupil", "School Funding Adequacy", 
                  "Median Household Income" ) 

# Base URL
base_path <- "F24_STATS_FINAL/county_data/"

# Initialize an empty list to store processed data frames
all_data <- list()

# Loop through each state
for (state in states) {
  # Format the state name for URL (replace spaces with %20)
  state_url <- paste0(base_path, gsub(" ", "\ ", state), ".xlsx")

  # Read the CSV
  full_data <- read_excel(state_url, sheet="Additional Measure Data", skip=1)
  
  # Subset columns
  subset_data <- full_data[desired_cols]
  
  # Rename columns
  renamed_data <- subset_data %>%
    rename(
      "Residential.Segregation.Index" = "Segregation Index...200"
    )
  
  # Drop the first row
  processed_data <- renamed_data[-1, ]
  
  # Save processed data to the list with a dynamic name
  all_data[[tolower(state)]] <- processed_data
}

# Combine all processed data frames into one
combined <- do.call(rbind, all_data)

#Create categorical variable for school funding adequacy
combined_pre_merge <- combined |>
  mutate(
    School.Funding.Cat = factor(case_when(
      School.Funding.Adequacy < 0 ~ 'Inadequate', 
      School.Funding.Adequacy > 0  ~ 'Adequate',
      TRUE ~ NA
    ), levels=c('Inadequate', 'Adequate'), labels=c(0, 1)))

#Merge with ACS (property tax) data
acs <- read.csv("https://github.com/wujenny214/F24_STATS_FINAL/raw/refs/heads/main/county_data/acs_prop_2.csv")
merged_df <- full_join(combined_pre_merge, acs, by = c("FIPS" = "fips")) %>%
  mutate(
    indicator = case_when(
      is.na(State) & !is.na(state) ~ "Right Only",  # Row from acs only
      !is.na(State) & is.na(state) ~ "Left Only",   # Row from combined_pre_merge only
      !is.na(State) & !is.na(state) ~ "Both"        # Row present in both dfs
    )
  )

print(merged_df[merged_df$indicator == "Right Only", ])
print(merged_df[merged_df$indicator == "Left Only", ])
#Difference of 8 rows, indicating that there are 8 counties with health data but no property tax data. 
#Alaska and South Dakota are going to be dropped anyways due to missing residential segregation index data.
#Looking into the VA county with missing property tax data (51515), it turns out that this county does not have any
#health data either in the original spreadsheet, but is still recorded as a county. Upon further analysis
#it was found that this FIPS code corresponded to Bedford City, which was merged into 51519 in 2010. Therefore it was safe to drop.

merged_df <- merged_df[merged_df$FIPS != 51515, ]
merged_df <- merged_df |> 
  mutate(
    Median.Prop.Tax = as.numeric(med_.re_taxes_paid))

intermed_merged = subset(merged_df, select = -c(med_.re_taxes_paid, med_.re_taxes_paid_real, county.1, Location, indicator, county, state) )

#Now merge with regions data
regions <- read.csv("https://github.com/cphalpert/census-regions/raw/refs/heads/master/us%20census%20bureau%20regions%20and%20divisions.csv")
final_merged <- left_join(intermed_merged, regions, by = c("State" = "State"))
final_merged = subset(final_merged, select = -c(State.Code))

#Rename columns
final_merged <- final_merged |> 
  rename(
    Percent.Uninsured.Adults = X..Uninsured.Adults, 
    Percent.Limited.Access.Healthy.Foods = X..Limited.Access.to.Healthy.Foods)

# The final data frame `combined` contains all processed state data.
write.csv(final_merged, '~/Documents/R\ Course\ Code/F24_STATS_FINAL/combined.csv')
