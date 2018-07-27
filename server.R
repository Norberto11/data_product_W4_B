## server.R

library(shiny)
library(dplyr)
library(ggplot2)



shinyServer(function(input, output) {

# Processing and model prodiction
      can_file<-reactive({
            #setwd("H:/Courses/Data Analysis Specialization/9. Developing Data Products/Project/Week4")
            read.csv(file="./final_data.csv",sep="",stringsAsFactors = FALSE)
      })
      
      input_state<-reactive({
            as.numeric(input$select)+1
      })
      
      mylist3<-reactive({
            mylist3<-as.list(c(1999:2014))
      })
      
      input_year<-reactive({
            as.numeric(match(input$select3,mylist3()))
      })
      
      input_year2<-reactive({
            as.numeric(input$select2)
      })
  
      selection<-reactive({
            select(can_file(),year,names(can_file())[input_state()])
      })
      
      b1<-reactive({
            b1<-can_file()[input_year(),]
      })
      
      vector_state<-reactive({
            names(b1()[2:ncol(b1())])
      })
      
      vector_deaths<-reactive({
            as.vector(t(b1()[,c(2:ncol(b1()))]))
      })
            
      b3<-reactive({
            data.frame(state=vector_state(),deaths=vector_deaths())
      })
            
      b4<-reactive({
            b3()[order(b3()[,2],decreasing=TRUE),c(1,2)]
      })
      
      modFit<-reactive({
            lm(selection()[,2]~year,data=selection())
            
      })
      
      prediction<-reactive({
            round(modFit()$coefficients[1]+modFit()$coefficients[2]*input_year2(),0)
      })
      
# Server Outputs
      
      output$plot1 <- renderPlot({
            ggplot(selection(),aes(selection()[,1],selection()[,2]))+
                  geom_point(col="blue",pch=1,cex=3)+
                  geom_line(col="black")+
                  geom_smooth(method="lm",col="blue",lty=2)+
                  labs(y=paste("Deaths - ",names(selection())[2]))+
                  labs(x="Year")+
                  scale_x_continuous(breaks=selection()$year)
      })
      
      output$text1<-renderText({
            paste("Prediction by",input_year2(),"in",names(selection())[2],"=",prediction(),"deaths per 100,000 population")
      })
      
      output$plot2<-renderPlot({
            barplot(b4()$deaths,names.arg=as.vector(b4()$state),las=2,col="red",cex.names=0.75,main=paste(input$select3),ylim=c(0,300))
      })

})

