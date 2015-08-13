
# REMIND: be smart about unzipping the data if it needs to be, and maybe downloading it
# as well.  
library(ggplot2)
raw.data <- read.csv("activity.csv")

data <- raw.data[!is.na(raw.data$steps),]


steps.by.date <- aggregate(steps ~ date, data = data, FUN = sum)

#p <- qplot(data.with.valid.steps$date, data.with.valid.steps$steps, geom="histogram")
#p <- qplot(data.with.valid.steps$steps, geom="histogram")
if (FALSE) {
p <- ggplot(steps.by.date, aes(x=steps)) +  geom_histogram(binwidth = 1000)  + 
  labs(title = "Histogram showing steps per day frequencies", x = "Steps per day", y = "Frequency of days occurrence")

print(p)
}

average.steps <- aggregate(steps ~ interval, data = data, FUN = mean)

p <- ggplot(average.steps, aes(x = interval, y = steps)) + 
  geom_line() +
  labs(title = "Average number of steps, by interval during the day", 
       x = "Inteval in the day", y = "Average number of steps")

print(p)

max.average.steps <- average.steps[which.max(average.steps$steps),]
print(max.average.steps$interval)


dates <- seq(ISOdate(2000, 1, 1, 0, 0, 0), ISOdate(2000, 1, 2, 0, 0,0), 60)
print(dates[max.average.steps$interval])
