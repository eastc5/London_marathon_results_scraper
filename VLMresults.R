# This R script scrapes data from the 2016 Virgin London Marathon results webpage
# you can view the results manually here:http://results-2016.virginmoneylondonmarathon.com/2016/
# the scipt simply scrolls through the results pages using a for loop adjusting the page variable 
# in the url with the 'M' variable for mens results and then repeats the process for the 
# womens result using 'W'. THe final output is sent to a csv file for further processing and 
# analysis. 


library(rvest)
library(plotly)

#Check to see if results file aready existsif not go scrape it 

if (!file.exists("./data/VLM2016.csv")) {

URL1 <- "http://results-2016.virginmoneylondonmarathon.com/2016/?page="
URL2 ="&event=MAS&num_results=1000&pid=list&search%5Bage_class%5D=%25&search%5Bsex%5D="

Running <-NULL
i<-NULL

#Get results for Men (24 pages of results)
 for (i in 1:24) { 
 
# create the url          
URL<-paste(URL1,i,URL2,"M",sep = "")

#parse the html and extract the desired table with x-path 
Runningpage <- URL %>% read_html()%>%html_nodes(xpath =
            '//*[@id="cbox-left"]/div[5]/div[1]/table')%>% html_table(header = TRUE)
Runningpage<-Runningpage[[1]]
# create an addional column for gender factor variable
Runningpage[,10]<-Runningpage$Gender
#place a M for men in it
Runningpage$Gender[1:nrow(Runningpage)]<-"M"
# add this page to the previous pages 
Running<-rbind(Running,Runningpage)

 }

#Get results for women

for (j in 1:16) { 
    
    URL<-paste(URL1,j,URL2,"W",sep = "")
    
    Runningpage <- URL %>% read_html()%>%html_nodes(xpath =
                    '//*[@id="cbox-left"]/div[5]/div[1]/table')%>% html_table(header = TRUE)
    Runningpage<-Runningpage[[1]]
    Runningpage[,10]<-Runningpage$Gender
    Runningpage$Gender[1:nrow(Runningpage)]<-"W"
    Running<-rbind(Running,Runningpage)
    
}

#output data to a csv file 
write.csv(Running,file = "./data/VLM2016.csv")
}


