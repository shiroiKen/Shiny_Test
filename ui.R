

#  2. USER INTERFACE (Industrial Dark Dashboard UI) -----------------------


ui <- page_sidebar(
  
  # The Page title
  title = "🏭 Industrial OT/IoT Analytics Tower",
  
  # Use the defined global theme
  theme = hud_theme
  ,
  

# The Filters Sidebar  ----------------------------------------------------

  
  # SideBar for the Controls
  sidebar = sidebar(
    
            title = "Asset Filters",
            
            # Dark / Light mode Toggle
            input_dark_mode(id = "dark_mode"),
            
            
            selectInput("type", "Machine Risk Category:",
                      choices = unique(iot_data$Type), selected = "L"),

          sliderInput("wear_threshold", "Tool Wear Warning Limit (min):",
                      min = 0, max = 250, value = 180),
          
          hr(),
          # Show Total number of selected machines
          withSpinner(textOutput("total_machines"),type = 1,color = "#008080" ),
          hr(),
          
          # Reset The control filters
          actionButton("refresh","↻ Reset Metrics",
                       class="btn-outline-cyan w-100 mb-2 bg-gradient"),
          
          # Close the Application
          actionButton("logout","☓ Close Terminal",
                       class="btn-sm btn-outline-danger w-100 bg-gradient")
          
        )

  ,



# Main Data Pane  ---------------------------------------------------------

  
navset_card_pill(

        id = "tabsets"
        ,
# Split into two panels (data grid & charts)

        # 1st Panel (data grid)
        nav_panel("Diagnostic Grid",
                 
    # split the panel into two halves 
    layout_column_wrap(
      width = 1/2,

      #View a summary      (1st Half)
      card(
        card_header("Operational Status Summary"),
        withSpinner(uiOutput("daily_summary_ui"),type = 1,
                    color = "#008080"),
      
        # Download Button
          card_footer(downloadButton("download_csv","↓ Export AI4A subset",
                                   class = "btn-sm btn-secondary"))
      ),

      # View data table (2nd Half)
      card(
        card_header("Active Machinery Exception Log"),
        withSpinner(tableOutput("event_log_table"),type = 1,
                    color = "#008080")
      )
      )
    )
    
    ,
  

# 2nd Panel (Charts)
  nav_panel(
    title = "Charts"

  ,
    
    
    # split into Two panels for Two charts
    navset_card_tab( 
      full_screen = T,
      
      id = "chart_tabsets",
      
      # histogram plot for Temperature.      
      nav_panel(title = "Thermal Stress Distribution",
                card_body(height = 500,
                          plotlyOutput("temp_hist"))),
      
      # time series for some values
      nav_panel(title = "Real-time Sensor Stream (Torque vs Rotational Speed)",
                card_body(height = 500,plotlyOutput("sensor_plot")
                     ))
      
)
)
)
)
