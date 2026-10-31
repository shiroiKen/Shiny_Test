


# 3. SERVER COMPUTATION LAYER ---------------------------------------------


server <- function(input, output, session) {
  

# Reactive data Subsetting ------------------------------------------------

  # Reactive subsetting based on user input filtering
  filtered_data <- 
    reactive({
      iot_data[Type == input$type & Tool_Wear < input$wear_threshold]
      })  


  

# Render Summary Outputs ----------------------------------------------------------

  # Dynamic UI calculation metrics summary
  output$daily_summary_ui<-renderUI({
    df<-filtered_data()
    
    req(df)   # require the filtered data to be present
    
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
  


# Render the data table --------------------------------------------------------

    
  # Machinery Log Output table mapping rows
  
  output$event_log_table<- renderTable({
    
    df<-filtered_data()
    
    req(df, nrow(df)>0) # also require the data frame not to be empty
    
    
    # Restructure data layout view to emphasize sensor matrices
    
    display_df<-df[,c("Product ID","Air_Temp","Process_Temp","Rotational_Speed",
                      "Torque","Tool_Wear","Machine failure")]
    
    names(display_df)<-c("Product ID","Air Temp (K)","Proc Temp (K)",
                         "Speed (RPM)","Torque (Nm)","Wear (min)",
                         "Failure Flag")
    
    # Show last 7 telemetry readings
    tail(display_df,7)
  },striped = FALSE,hover = TRUE,spacing = "s")
  
  
  
  

# Render the download button action ---------------------------------------

  
  #CSV Down-loader targeting localized metrics 
  
  output$download_csv<-downloadHandler(
    

        filename = function(){
      paste("ai4i-filtered-subgrid-",Sys.Date(),".csv",sep = "")
    },
    content = function(file){
      write.csv(filtered_data(),file,row.names = FALSE)
    }
  )
  

  
  
# Render The Reset button ---------------------------------------------
  
  # End instance routine
  observeEvent(input$refresh,
               {
updateSelectInput(inputId = "type", selected = "L")
updateSliderInput(inputId ="wear_threshold", value =180)
})
  
  
  
    

# Render The close App button ---------------------------------------------

  # End instance routine
  observeEvent(input$logout,
               {stopApp()})
  
  

# Render Number of the filtered machines ----------------------------------

  # # KPI Calculations 
  output$total_machines <- renderText({ nrow(filtered_data()) })

  

# Reactive colors for plots  ----------------------------------------------

# This is to change plots colors when changing dark/light modes  
  
  # 2. CREATE A REACTIVE VARIABLE THAT RE-EXTRACTS COLORS ON TOGGLE
  live_colors <- reactive({
 
       # This input dependency forces R to re-evaluate this block when clicked
          dark= input$dark_mode
          req(dark)

list(
    chart_bg   = ifelse(dark=="dark","#202020","#ffffff"),
    chart_font = ifelse(dark=="dark","#ffffff","#202020"),
    grid_color = ifelse(dark=="dark","#404040","#e0e0e0")
)
    })
   
  

  #  Main Time-Series Engine ------------------------------------------------
  
  output$sensor_plot <- renderPlotly({
    
    df<-filtered_data()
    cols<-live_colors()
    req(df,cols)  # require the filtered data and reactive colors.
   
    
    # Pull the calculated colors
    chart_bg   <- cols[["chart_bg"]]
    chart_font <- cols[["chart_font"]]
    grid_color <- cols[["grid_color"]]
    
    
# Define the Plot    
p <- plot_ly(df[1:500], x = ~`UDI`) %>%  # fixed data sample
      
add_lines(y = ~Torque, name = "Torque (Nm)",  # add 1st trend line
               line = list(color = '#00A0A0')) %>%
      
add_lines(y = ~Rotational_Speed / 30,  # add 2nd trend line
               name = "Normalized Speed", 
               line = list(color = '#A00000')) %>%
      
      layout(          # Customise the chart visuals
        
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
        
    p   # draw the  plot

      })
  

#  Secondary Distribution Graph -------------------------------------------

  
  output$temp_hist <- renderPlotly({
    
    df<-filtered_data()
    cols<-live_colors()
    req(df,cols)  # require the filtered data and reactive colors.
    
    # Pull the calculated colors
    chart_bg   <- cols[["chart_bg"]]
    chart_font <- cols[["chart_font"]]
    grid_color <- cols[["grid_color"]]
    
    
    
    plot_ly(df, x = ~Air_Temp, type = "histogram",
            alpha = 0.5,color = I('#007700'),size=I(0.1)
            ) %>%
      
      layout(
        xaxis = list(title = "Air Temperature (K)"),
        plot_bgcolor = chart_bg,
        paper_bgcolor = chart_bg,
        font = list(color = chart_font)
      )
  })
  
  
  }

