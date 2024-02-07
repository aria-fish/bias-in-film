#Author: Aria Fisher
#STAT 040 Final Project 
#12/7/2022


#Read in data from a .csv file
library(tidyverse)
bechdel_data<- read.csv(file="bechdel_data.csv")
head(bechdel_data)

#Demonstrate some data cleaning techniques
clean_bechdel_data<-bechdel_data[1:9]
clean_bechdel_data<-clean_bechdel_data[c("year","title","binary","domgross","intgross")]

clean_bechdel_data<-rename(clean_bechdel_data,
                           Release_Year=year,
                           Movie_Title=title,
                           Bechdel_Test=binary,
                           Domestic_Profits=domgross,
                           Intl_Profits=intgross)

clean_bechdel_data$Domestic_Profits<-as.numeric(clean_bechdel_data$Domestic_Profits)
clean_bechdel_data$Intl_Profits<-as.numeric(clean_bechdel_data$Intl_Profits)
clean_bechdel_data<-drop_na(clean_bechdel_data,"Domestic_Profits")
clean_bechdel_data<-drop_na(clean_bechdel_data,"Intl_Profits")
glimpse(clean_bechdel_data)

#Output the number of rows and number of columns in a data frame
#Output all the column names
colnames(clean_bechdel_data)

#Illustrate the use of summary and table functions
summary(clean_bechdel_data)
table(clean_bechdel_data$Bechdel_Test)
summary(clean_bechdel_data$Domestic_Profits)
##These can easily give summary statistics about profits, and demonstrate how many movies fail or pass the test

#Output the min, max, average, and standard deviation of a variable
min(clean_bechdel_data$Domestic_Profits)
max(clean_bechdel_data$Domestic_Profits)
mean(clean_bechdel_data$Domestic_Profits)
sd(clean_bechdel_data$Domestic_Profits)

#Illustrate how you can select columns of a data frame into a new data frame. 
#Show your result by executing a summary or glimpse of the new data frame.
#Illustrate the use of merge, show your result with summary or glimpse of the new data frame.
movie_profits<-clean_bechdel_data[c("Movie_Title","Domestic_Profits","Intl_Profits")]
glimpse(movie_profits)
bechdel_info<-clean_bechdel_data[c("Movie_Title","Bechdel_Test", "Release_Year")]
merged_data<-merge(movie_profits,bechdel_info)
glimpse(merged_data)

#Illustrate the use of filter
filtered_data<-filter(merged_data, Bechdel_Test=="PASS")
glimpse(filtered_data)
fail_data<-filter(merged_data, Bechdel_Test=="FAIL")
#Illustrate the use of arrange command from greatest to least
filtered_data<-arrange(filtered_data, desc(Domestic_Profits))

#Use slice max/slice min to output the top/bottom 3 rows. You may use any column of your choosing.
slice_max(filtered_data, Domestic_Profits, n=3)                       

#Illustrate the use of a pipe operation
filtered_data%>%slice_max(Domestic_Profits,n=3)%>%select("Movie_Title", "Domestic_Profits")
##This is a more efficient way of completing the two previous steps

#Illustrate the use of mutate to add a calculated column
total_profit_data<-mutate(clean_bechdel_data, Total_Profits=Domestic_Profits+Intl_Profits)
##This allows us to see the total profits of a film, both domestically and overseas

#Use summarize and group_by
by_tprofit<- group_by(total_profit_data, Bechdel_Test)
summarize(by_tprofit, Profits=mean(Total_Profits, na.rm=T))
##This outputs the mean total profits- the value created above- for failures and passing movies

#Illustrate the calculation of a correlation coefficient
cor(clean_bechdel_data$Intl_Profits, clean_bechdel_data$Domestic_Profits)
##This proves a strong positive correlation between dom. and intl. profits

#Use ggplot for 2 visualizations and a scatter plot with LR line
ggplot(filtered_data,
       aes(Domestic_Profits,Intl_Profits))+geom_point(col="light blue")+
  geom_smooth(method=lm, se=F)+
  labs(title="Scatterplot of Correlation",
       subtitle="Between Domestic and International Profits",
       x="Domestic Profits", y="International Profits")

ggplot(clean_bechdel_data, 
       aes(Release_Year, Intl_Profits))+geom_line(col='blue')+
  labs(title="Release Year and Overseas Profits",
       subtitle="For all movies in the dataset",
       x="Release",y="International Profits")

ggplot(filtered_data,
       aes(Release_Year, Intl_Profits))+geom_line(col='dark green')+
  labs(title="Release Year and Overseas Profits",
       subtitle="For movies passing the Bechdel test",
       x="Release",y="International Profits")

ggplot(fail_data,
       aes(Release_Year, Intl_Profits))+geom_line(col='red')+
  labs(title="Release Year and Overseas Profits",
       subtitle="For movies failing the Bechdel test",
       x="Release",y="International Profits")
#Illustrate the use of a loop
avg_cbechdel<-clean_bechdel_data[c("Release_Year", "Domestic_Profits", "Intl_Profits")]
average_all=vector("double", ncol(avg_cbechdel))
for(i in seq_along(avg_cbechdel))
{
  average_all[[i]]=mean(avg_cbechdel[[i]])
}
average_all

avg_fbechdel<-fail_data[c("Release_Year", "Domestic_Profits", "Intl_Profits")]
average_fail=vector("double", ncol(avg_fbechdel))
for(i in seq_along(avg_fbechdel))
{
  average_fail[[i]]=mean(avg_fbechdel[[i]])
}
average_fail
##This gives the average year, domestic, and international profits for movies that fail the test
avg_filtered<-filtered_data[c("Release_Year", "Domestic_Profits", "Intl_Profits")]
average_b=vector("double", ncol(avg_filtered))
for(i in seq_along(avg_filtered))
{
  average_b[[i]]=mean(avg_filtered[[i]])
}
average_b
##This gives the same as the loop before, but only for moves that pass
year_fbechdel<-fail_data[c("Release_Year", "Intl_Profits")]
myear_fbechdel=vector("double", ncol(year_fbechdel))
for (i in seq_along(year_fbechdel))
{
  myear_fbechdel[[i]] =max(year_fbechdel[[i]])
}
myear_fbechdel
##This gives the max year and the max profits for failing movies
year_b<-filtered_data[c("Release_Year", "Intl_Profits")]
myear_b=vector("double", ncol(year_b))
for (i in seq_along(year_b))
{
  myear_b[[i]]=max(year_b[[i]])
}
myear_b
##This gives the same as the loop before, but only for moves that pass

#Illustrate the use of an if-statement
for(i in seq_along(clean_bechdel_data))
{
  if (clean_bechdel_data$Intl_Profits[i]>2700000000){
    print("High Profit")
  }else if (clean_bechdel_data$Intl_Profits[i]>140000000){
    print("Mid Profit")
  }else{
    print("Low Profit")
  }
} 

#Illustrate the use of a function
fail_movies<-clean_bechdel_data[c()]
above.average<-function(x){
  count<-0
  for (i in seq_along(x)){
    if(x[[i]]>1.508502e+08){
      count<-count+1
    }
  }
  count
}
##This returns how many movies in a set have profits above average for the whole dataset
##The average value comes from average_all
above.average(fail_data$Intl_Profits)
above.average(filtered_data$Intl_Profits)
#350 of the FAIL set are above the average profits
#216 of the PASS set are above the average profits
nrow(filtered_data)
nrow(fail_data)
350/1004

216/825
#about 29 percent of pass movies above average