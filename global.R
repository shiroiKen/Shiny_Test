
# Load Libraries ----------------------------------------------------------

library(shiny)
library(bslib)
library(data.table)
library(plotly)
library(shinycssloaders)
library(sass)

# 1. DATA PREPROCESSING LAYER (Download & Clean) --------------------------


# Automatically fetch the real UCI IoT Predictive Maintenance dataset
data_url <- "https://archive.ics.uci.edu/static/public/601/ai4i+2020+predictive+maintenance+dataset.zip"
temp_zip <- tempfile(fileext = ".zip")


# If the file doesn't exist on local drive download it.
if (!file.exists("./data/ai4i2020.csv")) {
  download.file(data_url, temp_zip, mode = "wb")
  unzip(temp_zip, files = "ai4i2020.csv")
  unlink(temp_zip)
}

# Read data using data.table for optimized speed and rename some of the columns
iot_data <- fread("./data/ai4i2020.csv")
setnames(iot_data, 
         old = c("Air temperature [K]", "Process temperature [K]", "Rotational speed [rpm]", "Torque [Nm]", "Tool wear [min]"),
         new = c("Air_Temp", "Process_Temp", "Rotational_Speed", "Torque", "Tool_Wear"))



# Global Theme ------------------------------------------------------------


hud_theme = bs_theme(version = 5,
                     fg = "#121212",       # Text Color
                     bg = "#DDDDDD",       # Background Color
                     primary = "#00A0A0",  # Teal primary accent
                     accent = "#00FFFF",   # Cyan / Bright Teal for active elements.
    base_font = font_google("Share Tech Mono") # Digital/ HUD style font
                     )  %>%
  
  
  # Injecting the custom styles 
  bs_add_mixins(sass_file("./www/style.scss")) 

