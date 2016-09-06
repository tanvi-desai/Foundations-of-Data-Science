# Set up
library (tidyr)
library (dplyr)
library(stringr)
library(psych)


#Import .csv file as  a data frame
raw_data <- read.csv("/Users/tanvidesai/Documents/2016 Courses/Foundations of Data Science/Data Wrangling Project 1/refine_original.csv", 
         head = TRUE, sep = ",")
tbl_df(raw_data)
View(raw_data)


# Clean up brand names
raw_data$company <- tolower(raw_data$company)
raw_data$company <- str_replace(raw_data$company, "f", "ph")
raw_data$company <- str_replace(raw_data$company, "^ph[a-z]+ps", "philips")
raw_data$company <- str_replace(raw_data$company, "^ak[a-z0-9 ]+", "akzo")
raw_data$company <- str_replace(raw_data$company,"unilver","unilever")

# Separate product code and number
raw_data <- separate(raw_data, Product.code...number, 
                     c("product_code", "product_number"), sep = "-")


# Add product categories
categorize_product <- function(product_code) {
  if (product_code == "p") {
  return ("Smartphone") 
  } else if (product_code == "v") {
    return ("TV") 
  } else if (product_code == "x") {
    return ("Laptop") 
  } else if (product_code == "q") {
    return("Tablet") 
  }}

raw_data <- raw_data %>% mutate(product_category = sapply(product_code, categorize_product))


# Add full address for geocoding
raw_data <- unite(raw_data, "full_address", address, city, country, sep = ",")

# Create binary (0/1) variables for: 
# 1) Company 
dummy_var <- dummy.code(raw_data$company)
new_dataset <- data.frame(raw_data, dummy_var)
colnames(new_dataset)[7:10] <- paste("company_", colnames(new_dataset[ c(7:10)]), sep = "")

# 2) Product category
dummy_var1 <- dummy.code(new_dataset$product_category)
final_dataset <- data.frame(new_dataset, dummy_var1)
colnames(final_dataset)[11:14] <- paste("product_", colnames(final_dataset[ c(11:14)]), sep = "")

View(final_dataset)


# Export new dataset as .csv file
write.csv(final_dataset, "/Users/tanvidesai/Documents/2016 Courses/Foundations of Data Science/Data Wrangling Project 1/refine_cleaned.csv")

