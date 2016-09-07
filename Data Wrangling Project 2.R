# Data Wrangling Project 2 : Titanic data
# Objective: Deal with missing values in Titanic passenger dataset

# Setup
library(dplyr)
library(tidyr)
library(graphics)
library(stats)


# Import .csv file as  a data frame
raw_data <- read.csv("/Users/tanvidesai/Documents/2016 Courses/Foundations of Data Science/Data Wrangling Project 2/titanic_original.csv", 
                     head = TRUE, sep = ",", stringsAsFactors = FALSE)
tbl_df(raw_data)
str(raw_data)


# Replace missing values in 'embarked' column with 'S'
raw_data$embarked[raw_data$embarked==" "] <- "S"
View(raw_data)


# Populate missing values in 'Age' with mean age
raw_data$age[is.na(raw_data$age)] <- mean(raw_data$age, na.rm= T)
View(raw_data)

# Could use median, mode or 0 to replace missing values.
# In this case, mean works best because:
# Median and mean are very similar (and therefore, mode not necessary)
# 0 is not a valid value for age


# Replace missing values in 'boat' column with 'None'
raw_data$boat <- sub("^$", "None", raw_data$boat)


# Interpret missing cabin information
# Cabin information is missing for 77% of the passengers. It does not make
#   sense to fill missing cabin numbers with a value because no apparent
#   pattern can be found on reviewing the dataset that would enable interpretation
#   of the missing data.
# Missing value here could mean that cabins were purchased for groups of people by individual
#   people/agency and/or that cabins were shared by multiple people, considering most of the missing 
#   values correspond to 2nd or 3rd class passengers.

# Create new binary variable 'has_cabin_number'
titanic_data_cleaned <- mutate(raw_data, has_cabin_number = ifelse(grepl("^$", cabin), 0, 1))
View(titanic_data_cleaned)

# Export new dataset as .csv file
write.csv(titanic_data_cleaned, "/Users/tanvidesai/Documents/2016 Courses/Foundations of Data Science/Data Wrangling Project 2/titanic_clean.csv")











