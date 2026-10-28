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

if (!file.exists("ai4i2020.csv")) {
  download.file(data_url, temp_zip, mode = "wb")
  unzip(temp_zip, files = "ai4i2020.csv")
  unlink(temp_zip)
}

# Read data using data.table for optimized speed
iot_data <- fread("ai4i2020.csv")
setnames(iot_data, 
         old = c("Air temperature [K]", "Process temperature [K]", "Rotational speed [rpm]", "Torque [Nm]", "Tool wear [min]"),
         new = c("Air_Temp", "Process_Temp", "Rotational_Speed", "Torque", "Tool_Wear"))



# Global Theme ------------------------------------------------------------

# hud_theme = bs_theme(version = 5, bootswatch = "minty",
#                  primary = "#00E5FF", success = "#00E676")
# 




# 1. Parse your file as a structural Sass layer
# scss_layer <- sass_layer_file("./www/style.scss")



hud_theme = bs_theme(version = 5,
                     fg = "#121212",       # Text Color
                     bg = "#DDDDDD",       # Background Color
                     primary = "#00A0A0",  # Teal primary accent
                     accent = "#00FFFF",   # Cyan / Bright Teal for active elements.
    base_font = font_google("Share Tech Mono") # Digital/ HUD style font
                     )  %>%
  bs_add_mixins(sass_file("./www/style.scss"))

    # bs_bundle(scss_layer)

  
  # bs_get_variables(hud_theme,
  #                     c("custom-chart-bg", "custom-chart-font",
  #                       "custom-grid-color"))
                   # 
  
  # bs_add_variables(.where = "declarations","custom-chart-font"="$custom-chart-font",
  #                  sass_file("./www/style.scss")) %>%
  
  # Injecting the custom dynamic neon glitch/glitter styles 
  # bs_add_rules(sass_file("./www/style.scss"))

  




# Function to preview the styling a (primary) Bootstrap button
# library(htmltools)
# 
# # button <- tags$a(class = "btn-outline-cyan w-100 mb-2", href = "#", role = "button", "Hello")
# 
# button <-actionButton("refresh","↻ Reset Metrics",
#              class="btn-outline-cyan w-100 mb-2")
# 
# preview_button <- function(theme) {
#   browsable(tags$body(bs_theme_dependencies(theme), button))
# }

# Here we start with a theme based on a Bootswatch theme,
# then override some variable defaults
# theme <- bs_add_variables(
#   bs_theme(bootswatch = "sketchy", primary = "orange"),
#   "body-bg" = "#EEEEEE",
#   "font-family-base" = "monospace",
#   "font-size-base" = "1.4rem",
#   "btn-padding-y" = ".16rem",
#   "btn-padding-x" = "2rem"
# )

# preview_button(hud_theme)





# # If you need to set a variable based on another Bootstrap variable
# theme <- bs_add_variables(theme, "body-color" = "$success", .where = "declarations")
# preview_button(theme)




  
  # Injecting the custom dynamic neon glitch/glitter styles
  #' bs_add_rules("
  #'              
  #'              /* 1. Define the Pulse/Glitter Keyframes * /
  #'              @keyframes hud-glitter {
  #'              0% {
  #'              box-shadow: 0 0 4px #00FFFF, inset 0 0 2px #00FFFF;
  #'              text-shadow: 0 0 2px #00FFFF;
  #'              }
  #'              50% {
  #'              box-shadow: 0 0 15px #00FFFF, inset 0 0 8px #00FFFF;
  #'              text-shadow: 0 0 8px #00FFFF;
  #'              opacity: 0.95;
  #'              }
  #'              100% {
  #'              box-shadow: 0 0 4px #00FFFF, inset 0 0 2px #00FFFF;
  #'              text-shadow: 0 0 2px #00FFFF;
  #'              }
  #'              }
  #'              
  #'              /* 2. Apply the effect to active Bootstrap Nav links (Tabs) */
  #'              .navbar-nav .nav-link.active, .nav-pills .nav-link.active {
  #'              background-color: #00A0A0  !important;
  #'              color: #000FAA  !important;
  #'              border: 1px solid #1a1a1a;
  #'              animation: hud-glitter 2s infinite ease-in-out;
  #'              }
  #'              
  #'              /* 3. Apply a dynamic hover effect to buttons and cards */
  #'              .btn-outline-cyan:hover, .card:hover {
  #'              border-color: #800000  !important;
  #'              color: #1a1a1a  !important;
  #'              animation: hud-glitter 1.5s infinite ease-in-out;
  #'              transition: all 0.3s ease;
  #'              }
  #'              
  #'              /* Give cards a crisp cyber border initially */
  #'              .card {
  #'              border: 1px solid #00A0A0;
  #'              background-color: #FFFFFF !important;
  #'              }
  #'              ")
  #'              
  #'            
# 
# 
# hud_theme<- bs_theme(
#   version = 5,
#   # Overwrite standard colors
#   primary = "#004b87", 
#   success = "#2ecc71",
#   # Add entirely new custom map colors here using specific variable names
#   "theme-colors" = "map-merge($theme-colors, ('brand-purple': #6f42c1, 'custom-orange': #ff6720))"
# )
# 
# 
# hud_theme<-bs_theme(version = 5) |> 
#   # 2. Inject your SCSS into the 'declarations' layer
#   bs_add_mixins(
#     # .where = "declarations", 
#     sass::sass_file("./www/style.scss")
#   )
# 
# 
# 
# bs_get_variables(hud_theme,
#                  c("body-bg", "primary","success","custom-chart-bg",
#                    "theme-colors"))
