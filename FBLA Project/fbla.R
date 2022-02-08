
library(shiny)

#Imports the data set
attractions_data <- read.csv("/Users/eegap/OneDrive/Documents/FBLA_SLC_Project/slcinfo4.csv")


# Defines UI
ui <- fluidPage(
  #Changes background color and text size and color of the title
  tags$head(
    tags$style(HTML("
      @import url('https://fonts.googleapis.com/css2?family=Yusei+Magic&display=swap');
      body {
        background-color: #DAAD86;
        color: white;
      }
      h2 {
        font-family: 'Yusei Magic', sans-serif;
        font-size: 50px;
      }
      h4 {
        font-size: 30px;
      }
      .shiny-input-container {
        color: #474747;
      }"))
    
  ),
  
  
  # Application title
  titlePanel( div(HTML(" <b>Attraction Selection</b> "))),
  
  
  
  # Sidebar where you can pick your five attributes
  sidebarLayout(
    sidebarPanel(
      
      selectInput("location",
                  h3("Select Your Location"),
                  choices = attractions_data$Location,
                  multiple=FALSE),
      
      selectInput("attractionType",
                  h3("Select your Attraction Type"),
                  choices = attractions_data$Type.of.Attraction,
                  multiple=FALSE),
      
      selectInput("KidFriendly",
                  h3("Select whether Kid Friendly"),
                  choices = attractions_data$Kid.Friendly,
                  multiple=FALSE),
      
      selectInput("outdoors",
                  h3("Select whether indoors or outdoors"),
                  choices = attractions_data$Outdoors.Indoors,
                  multiple=FALSE),
      
      selectInput("rating",
                  h3("Select Rating"),
                  choices = attractions_data$Stars.Rating.out.of.5,
                  multiple=FALSE),
      
      submitButton("Submit")
    ),
    
    
    
    # Shows the Attraction
    mainPanel(
      tabsetPanel(type="tabs",
                  
                  tabPanel("Output",
                           
                           h4(textOutput("attraction_output"))),
                  
                  tabPanel("Other Attractions in the Area",
                           
                           tableOutput("attraction_table")),
                  tabPanel("Need help?", h4("Need help? Select from five different attributes: Location, Attraction Type, Family Friendly, Outdoors or Indoors, and the Rating. Using this information, the program will find you a Georgia location that matches all of your desires. If nothing suits your attributes, you will be prompted to see all the attractions based on the area that you have selected. It will give you all the attributes about each attraction in that area. Hope you have fun!"))), 
    )
  )
)

server <- function(input, output) {
  
  attraction_pred <- reactive({
    
    # Getting User Inputs
    loc <- input$location
    attraction_type <- input$attractionType
    kid_friendly <- input$KidFriendly
    outdoor_indoor <- input$outdoors
    rating <- input$rating
    
    # Filtering the Dataset
    filter1 <- attractions_data[attractions_data$Location == loc,]
    filter2 <- filter1[filter1$Type.of.Attraction == attraction_type,]
    filter3 <- filter2[filter2$Kid.Friendly == kid_friendly,]
    filter4 <- filter3[filter3$Outdoors.Indoors == outdoor_indoor,]
    filter5 <- filter4[filter4$Stars.Rating.out.of.5 == rating,]
    
    if (nrow(filter5) > 0) {
      final_attraction <- filter5$Attraction
    }
    
    else {
      # Give list of attractions in the given location
      attraction_list <- filter1$Attraction
      final_attraction <- "No Attractions avaliable"
    }
    final_attraction
  })
  
  attractionsTable <- reactive({
    
    loc <- input$location
    
    filter1 <- attractions_data[attractions_data$Location == loc,]
    
    filter1
    
  })
  
  # Make a dataset that has images for each location
  # Call attraction_pred() to get final attraction
  # get the image for the final attraction
  
  output$attraction_output <-
    renderText(paste(attraction_pred()))
  
  output$attraction_table <-
    renderTable(attractionsTable())==
}

# Run the application
shinyApp(ui = ui, server = server)

