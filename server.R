


# 3. SERVER COMPUTATION LAYER ---------------------------------------------


server <- function(input, output, session) {
  
  # This single line forces ggplot2/plotly/lattice to match the dark/light switch!
  # thematic_shiny(session = session)
  
  
  # Reactive subsetting based on user input filtering
  filtered_data <- 
    reactive({
      iot_data[Type == input$type & Tool_Wear < input$wear_threshold]
      })  

  
  
  # Dynamic UI calculation metrics summary
  output$daily_summary_ui<-renderUI({
    df<-filtered_data()
    
    req(df)
    
    avg_speed<- ifelse(nrow(df)>0,yes = round(mean(df$Rotational_Speed,0)),
                       no = 0)
    
    avg_torque<- ifelse(nrow(df)>0,yes = round(mean(df$Torque),1),
                       no = 0)
    
    failures<- ifelse(nrow(df)>0,yes = sum(df$`Machine failure`==1),
                       no = 0)
  
    tagList(
      
      p(span("Mean Operational Velocity: ",style="color: #008080;"),
        strong(avg_speed," RPM")),
      
      p(span("Average Axis Torque Strain: ",style="color: #008080;"),
        strong(avg_torque," nm")),
      
      
      p(span("Predicted Mechanical Failures: ",style="color: #008080;"),
        span(failures,style=ifelse(failures>0,
                                   yes = "color: #FF0055; font-weight: bold;",
                                   no = "color: #FFFFFF;")) )
      
      )
    
    })
  
  
  # Machinery Log Output table mapping rows
  
  output$event_log_table<- renderTable({
    
    df<-filtered_data()
    
    req(df, nrow(df)>0)
    
    
    # Restructure data layout view to emphasize sensor matrices
    
    display_df<-df[,c("Product ID","Air_Temp","Process_Temp","Rotational_Speed",
                      "Torque","Tool_Wear","Machine failure")]
    
    names(display_df)<-c("Product ID","Air Temp (K)","Proc Temp (K)",
                         "Speed (RPM)","Torque (Nm)","Wear (min)",
                         "Failure Flag")
    
    # Show last 7 telemetry readings
    tail(display_df,7)
  },striped = FALSE,hover = TRUE,spacing = "s")
  
  
  
  
  
  #CSV Downloader targeting localized metrics 
  
  output$download_csv<-downloadHandler(
    # {req(filtered_data())}

        filename = function(){
      paste("ai4i-filtered-subgrid-",Sys.Date(),".csv",sep = "")
    },
    content = function(file){
      write.csv(filtered_data(),file,row.names = FALSE)
    }
  )
  
  
  
  
  # End instance routine
  observeEvent(input$logout,
               {stopApp()})
  
  
    
  
  # # KPI Calculations 
  output$total_machines <- renderText({ nrow(filtered_data()) })
  # 
  # # Sum up actual mechanical failures in the subset   
  # output$failure_count <- renderText({
  #   sum(filtered_data()$`Machine failure` == 1)
  # })
  # 
  # output$avg_torque <- renderText({
  #   paste(round(mean(filtered_data()$Torque), 2), " Nm")
  # })
  # 

#  Main Time-Series Engine ------------------------------------------------

  
  # 2. CREATE A REACTIVE VARIABLE THAT RE-EXTRACTS COLORS ON TOGGLE
  live_colors <- reactive({
    # This input dependency forces R to re-evaluate this block when clicked
    
      dark= input$dark_mode_toggle
      req(dark)

    # print(input$dark_mode_toggle)
    # Re-extract the fresh compiled hex values from the live theme state
    # bs_get_variables(#bs_current_theme(),
    #   session$getCurrentTheme(),
    #   c("custom-chart-bg", "custom-chart-font", "custom-grid-color")
    # )
list(
    chart_bg   = ifelse(dark=="dark","#202020","#ffffff"),
    chart_font = ifelse(dark=="dark","#ffffff","#202020"),
    grid_color = ifelse(dark=="dark","#404040","#e0e0e0")
)
    
    
  })
  # 
  
  
  output$sensor_plot <- renderPlotly({
    
    df<-filtered_data()
    
    # 1. Read the custom CSS variables live from the current theme state
    # theme_info <- getCurrentOutputInfo()
    # print(theme_info$bg())
    # print(theme_info$fg())
  
      req(df)
    
    cols<-live_colors()
    req(cols)
    # 
    # print(cols)
    # # Fallback to defaults if the application is still initializing
    # bg_color <- theme_info$bg() %||% "#eeeeee"
    # font_color <- theme_info$fg() %||% "#222222"
    
    # print(bs_current_theme()$layers)
    # 
    # # 2. Extract the compiled theme values for the current user state
    # # This automatically tracks light vs dark mode switches
    # current_colors <- bs_get_variables(bs_current_theme(),
    #                     c("custom-chart-bg", "custom-chart-font",
    #                       "custom-grid-color","bg-custom-chart-bg",
    #                       "theme-colors-bg"))

    
    # print(current_colors)
    # # # 3. Pull the exact calculated strings
    chart_bg   <- cols[["chart_bg"]]
    chart_font <- cols[["chart_font"]]
    grid_color <- cols[["grid_color"]]
    # # 
    # 
    
# chart_bg   <- ifelse(input$dark_mode_toggle=="dark","#202020","#ffffff")
# chart_font <- ifelse(input$dark_mode_toggle=="dark","#ffffff","#202020")
# grid_color <- ifelse(input$dark_mode_toggle=="dark","#404040","#e0e0e0")
      
        
      
    # th=bs_current_theme()
    
    # 2. Tell Plotly exactly which CSS variable to pull from your SCSS file
    # This keeps your color definitions 100% inside your .scss file!
    # chart_bg   <- "var(--custom-chart-bg)"
    # chart_font <- "var(--custom-chart-font)"
    # grid_color <- "var(--custom-grid-color)"
    
    
    p <- plot_ly(df[1:500], x = ~`UDI`) %>%
      
      add_lines(y = ~Torque, name = "Torque (Nm)",
                line = list(color = '#00A0A0')) %>%
      
      add_lines(y = ~Rotational_Speed / 30, name = "Normalized Speed",
                line = list(color = '#A00000')) %>%
      
      layout(
        
        # Natively binding the browser's current CSS variables to the layout
        plot_bgcolor = chart_bg,
        paper_bgcolor = chart_bg,
        font = list(color =  chart_font),
        
        xaxis = list(
          title = "Time Sequence (Ticks)", 
          gridcolor = grid_color
        ),
        yaxis = list(
          title = "Sensor Values", 
          gridcolor = grid_color
        )
      )
        
        
        # xaxis = list(title = "Time Sequence (Ticks)", gridcolor = bg_color),
        # yaxis = list(title = "Sensor Values", gridcolor = bg_color),
        # plot_bgcolor = bg_color,
        # paper_bgcolor = bg_color,
        # font = list(color = font_color))
        # 
        # yaxis = list(title = "Sensor Values")#,
        # plot_bgcolor = "#DDDDDD",
        # paper_bgcolor = "#DDDDDD",
        # font = list(color = "#000000")
      # )
    
    p
  })
  

#  Secondary Distribution Graph -------------------------------------------

  
  output$temp_hist <- renderPlotly({
    
    cols<-live_colors()
    req(cols)
    chart_bg   <- cols[["chart_bg"]]
    chart_font <- cols[["chart_font"]]
    grid_color <- cols[["grid_color"]]
    
    
    
    plot_ly(filtered_data(), x = ~Air_Temp, type = "histogram",
            alpha = 0.5,color = I('#007700'),size=I(0.1)
            # marker = list(color = '#007700',size  = I(1))
            ) %>%
      
      layout(
        xaxis = list(title = "Air Temperature (K)"),
        plot_bgcolor = chart_bg,
        paper_bgcolor = chart_bg,
        font = list(color = chart_font)
      )
  })
  
# 
  
  }


# Run The Application -----------------------------------------------------


# shinyApp(ui, server)
