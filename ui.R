

#  2. USER INTERFACE (Industrial Dark Dashboard UI) -----------------------


ui <- page_sidebar(
  title = "🏭 Industrial OT/IoT Analytics Tower",
  
  theme = hud_theme
  ,
  
  # 2. Push items to the right side of the navbar and add the switch
  # nav_spacer(),
  # nav_item(
    
  # )

# ,
  
  # # Custom CSS wrapper to styling specific custom components
  # header =  tags$head(
  #   tags$style(HTML("
  #                   .btn-outline-cyan{
  #                   color: #00FFFF;
  #                   border-color: #008080;
  #                   background: transparent;
  #                   }
  #                 
  #                   .table{
  #                   color: #FFFFFF !important;
  #                   }
  #       
  #         /* Custom look for the select input to blend into the cyber interface */
  #       .form-select, .form-conrtol{
  #       background-color: #1a1a1a !important;
  #       color: #FFFFFF !important;
  #       border: 1px solid #008080 !important;
  #       }
  #       
  #       .form-select:focus, .form-control:focus{
  #       border-color: #00FFFF !important;
  #       box-shadow: 0 0 8px #00FFFF !important;
  #       }")
  #              ))

    # ,
  
  sidebar = sidebar(
    
            title = "Asset Filters",
            
            input_dark_mode(id = "dark_mode_toggle"),
            
            selectInput("type", "Machine Risk Category:",
                      choices = unique(iot_data$Type), selected = "L"),

          sliderInput("wear_threshold", "Tool Wear Warning Limit (min):",
                      min = 0, max = 250, value = 180),
          
          hr(),
          withSpinner(textOutput("total_machines"),type = 1,color = "#008080" ),
          hr(),
          
          actionButton("refresh","↻ Reset Metrics",
                       class="btn-outline-cyan w-100 mb-2 bg-gradient"),
          
          actionButton("logout","☓ Close Terminal",
                       class="btn-sm btn-outline-danger w-100 bg-gradient")
          
        )

  ,


  # nav_panel(
  # # title= "Milling Diagnostic Grid",
    
# 
# footer =  
navset_card_pill(
        # type="pills",
        id = "tabsets"
#         
        ,
#         
        
        nav_panel("Diagnostic Grid",
                 
    layout_column_wrap(
      width = 1/2,

      card(
        card_header("Operational Status Summary"),
        withSpinner(uiOutput("daily_summary_ui"),type = 1,
                    color = "#008080"),
        card_footer(downloadButton("download_csv","↓ Export AI4A subset",
                                   class = "btn-sm btn-secondary"))
      ),

      card(
        card_header("Active Machinery Exception Log"),
        withSpinner(tableOutput("event_log_table"),type = 1,
                    color = "#008080")
      )
      )
    )
    
    ,
  


  nav_panel(
    title = "Charts"

  ,
    
    
    
    navset_card_tab( #title = "Charts" ,
      full_screen = T,
      # type="pills",
      id = "chart_tabsets",
      # tabPanel("Live",div(class="bg-secondary p-2 rounded",dygraphOutput("LivePlot"))) ,
      
            
      nav_panel(title = "Thermal Stress Distribution",
                card_body(height = 500,
                          plotlyOutput("temp_hist"))),
      
      nav_panel(title = "Real-time Sensor Stream (Torque vs Rotational Speed)",
                card_body(height = 500,plotlyOutput("sensor_plot")
                     ))
      
    )
  
  
  #  )
  
      )
  
  )
  
  
)








# nav_panel(
#   title = "Telemetry Control Center",
#   layout_sidebar(
#     
#     sidebar = sidebar(
#       title = "Asset Filters",
#     
#         selectInput("type", "Machine Risk Category:", 
#                   choices = unique(iot_data$Type), selected = "L"),
#       
#       sliderInput("wear_threshold", "Tool Wear Warning Limit (min):", 
#                   min = 0, max = 250, value = 180),
#       hr(),
#       helpText("Monitoring active factory telemetry nodes.")
#     ),
#     
#     #### KPI Cards Layout
#     
#     layout_columns(
#       
#       card(
#         card_header("Total Monitored Assets"),
#    withSpinner(textOutput("total_machines"),type = 1,color = "#008080" ) ,
#         class = "text-info font-weight-bold"
#       )
#       ,
#       
#       card(
#         card_header("Critical Failure Alerts"),
#         withSpinner(textOutput("failure_count"),type = 1,color = "#008080" ) ,
#         
#         class = "text-danger"
#       )
#       ,
#       
#       card(
#         card_header("Avg Operational Torque"),
#         withSpinner(textOutput("avg_torque"),type = 1,color = "#008080" ) 
#         
#       )
#     ),
#     
#     ### Visual Analysis Charts
#     layout_columns(
#       col_widths = c(8, 4),
#   
#           card(
#         card_header("Real-time Sensor Stream (Torque vs Rotational Speed)"),
#         plotlyOutput("sensor_plot")
#       )
#       
#       ,
#       card(
#         card_header("Thermal Stress Distribution"),
#         plotlyOutput("temp_hist")
#       )
#     )
#   )
# )