## ui.R

options(shiny.sanitize.errors = FALSE)

library(shiny)

#Reading the file from external drive and some dataframe processing
#setwd("H:/Courses/Data Analysis Specialization/9. Developing Data Products/Project/Week4")
can_file<-read.csv(file="./final_data.csv",sep="",stringsAsFactors = FALSE)
      choices = data.frame(
      var = names(can_file)[2:length(can_file)],
      num = 1:(length(names(can_file))-1))
      
# List of choices for selectInput
mylist <- as.list(choices$num)
mylist2<-as.list(c(2015:2025))
mylist3<-as.list(c(1999:2014))

# Names for the List myList
names(mylist) <- choices$var
      
# Shiny application Inputs and Outputs
shinyUI(fluidPage(
      actionButton("htmlfile", "Instruction Manual",onclick = "window.open('App_Instructions.html')"),
      titlePanel("Cancer related Death Rate in US"),
            sidebarLayout(
                  sidebarPanel(
                        selectInput("select","Select state",selected=52,choices=mylist),
                        selectInput("select2","Select Year (For prediction)",choices=mylist2),
                        selectInput("select3","Select Year (All states)",choices=mylist3)
                  ),                  
                  mainPanel(
                        tabsetPanel(type="tabs",
                        tabPanel("Selected state",br(),h3("Deaths/year per 100,000 population"),plotOutput("plot1"),textOutput("text1")),
                        tabPanel("All states",br(),h3("Deaths/year per 100,000 population"),plotOutput("plot2"))
                        )
                  )
            )
      )
)
