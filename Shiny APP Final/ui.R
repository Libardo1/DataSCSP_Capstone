library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(theme = "bootstrap.css",align="center",
  img(src='head.png', align = "center", height="150", width="920"),
  hr(),
  # Copy the line below to make a text input box
  h1("Insert Text Here (In English)"),
  textInput("text", label = "", value = ""),
  tags$style(type='text/css', "#text { width: 1000px; height:100px; font-size: 30px;font-style: italic; }"),

  submitButton("Submit to Predict"),
  hr(),
  h6("Note: the first prediction may take a few seconds longer than normal, once this prediction the following snapshots will be made."),
  img(src='2gram.png', align = "right", height="300", width="500"),
  img(src='5gram.png', align = "left", height="300", width="500"),
  textOutput("text0"),
  tags$head(tags$style("#text0{color: blue; font-size: 30px;font-style: italic;}")),
  textOutput("text1"),
  tags$head(tags$style("#text1{color: red; font-size: 50px;font-style: italic;}")),
  hr(),
  h4("", a("camiloherrera.co", href="http://camiloherrera.co"))  
))