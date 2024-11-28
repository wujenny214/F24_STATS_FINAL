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
                  "Median Household Income" ) # Update with actual column names

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

# The final data frame `combined` contains all processed state data.

