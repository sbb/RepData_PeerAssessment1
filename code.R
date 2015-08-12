
# REMIND: be smart about unzipping the data if it needs to be, and maybe downloading it
# as well.  
library(ggplot2)
raw.data <- read.csv("activity.csv")

data <- raw.data[!is.na(raw.data$steps),]


steps.by.date <- aggregate(steps ~ date, data = data, FUN = sum)

#p <- qplot(data.with.valid.steps$date, data.with.valid.steps$steps, geom="histogram")
#p <- qplot(data.with.valid.steps$steps, geom="histogram")
p <- ggplot(steps.by.date, aes(x=steps)) +  geom_histogram(binwidth = 1000)  + 
  labs(title = "Histogram showing steps per day frequencies", x = "Steps per day", y = "Frequency of days occurring")

print(p)