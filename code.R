
# REMIND: be smart about unzipping the data if it needs to be, and maybe downloading it
# as well.  
library(ggplot2)

raw.data <- read.csv("activity.csv")


data <- subset(raw.data, !is.na(raw.data$steps))


steps.by.date <- aggregate(steps ~ date, data = data, FUN = sum)

#p <- qplot(data.with.valid.steps$date, data.with.valid.steps$steps, geom="histogram")
#p <- qplot(data.with.valid.steps$steps, geom="histogram")
#if (TRUE) {
steps.histogram <- ggplot(steps.by.date, aes(x=steps)) +  geom_histogram(binwidth = 1000)  + 
  labs(title = "Histogram showing steps per day frequencies", x = "Steps per day", y = "Frequency of days occurrence")

print(steps.histogram)
#}



average.steps <- aggregate(steps ~ interval, data = data, FUN = mean)

p<- ggplot(average.steps, aes(x = interval, y = steps)) + 
  geom_line() +
  labs(title = "Average number of steps, by interval during the day", 
       x = "Inteval in the day", y = "Average number of steps")

print(p)

max.average.steps <- average.steps[which.max(average.steps$steps),]
print(max.average.steps$interval)

missing.steps.rows <- subset(raw.data, is.na(raw.data$steps))

for (i in seq_along(missing.steps.rows$steps)) {
  #print(i)
  interval <- missing.steps.rows[i,]$interval
  #print(sprintf("%d = %s", i, interval))
  missing.steps.rows[i,]$steps = average.steps[average.steps$interval == interval,]$steps

  #missing.steps[i] = average.steps$steps[average.steps$interval == missing.steps.rows$interval[i],]$steps
  #print(i)
}
#library(plyr)
#imputed.steps.rows <- mutate(missing.steps.rows, steps = average.steps$steps[average.steps$interval == interval])

imputed.data <- rbind(missing.steps.rows, data)
imputed.steps.by.date <- aggregate(steps ~ date, data = imputed.data, FUN = sum)

mean.imputed.steps.by.date= mean(imputed.steps.by.date$steps)

#p <- qplot(data.with.valid.steps$date, data.with.valid.steps$steps, geom="histogram")
#p <- qplot(data.with.valid.steps$steps, geom="histogram")
if (TRUE) {
  library(gridExtra)
 
  imputed.histogram <- ggplot(imputed.steps.by.date, aes(x=steps)) +  geom_histogram(binwidth = 1000)  + 
    geom_vline(xintercept = mean.imputed.steps.by.date, color = "red") +
    labs(title = "Histogram showing steps/day freq.", x = "Steps per day", y = "Frequency of days occurrence")
  grid.arrange(steps.histogram, imputed.histogram, nrow=1, ncol=2)
  #print(imputed.histogram)

  print(sprintf("mean steps by date without imputed values: %f and with imputed values: %f", 
                mean(steps.by.date$steps), 
                mean(imputed.steps.by.date$steps)))
  print(sprintf("median steps by date without imputed values %f and with imputed values: %f",median(steps.by.date$steps), median(imputed.steps.by.date$steps)))

  combined.steps.data <- rbind(cbind(imputed.steps.by.date, imputed=TRUE), cbind(steps.by.date, imputed=FALSE))
  
  combined.histograms <- ggplot(combined.steps.data, aes(x=steps, fill = imputed) ) +  geom_histogram(binwidth = 1000)  + 
    labs(title = "Histogram showing steps/day freq.", x = "Steps per day", y = "Frequency of days occurrence")
  
  print(combined.histograms)
  
  combined.histograms <- ggplot(combined.steps.data, aes(x=steps), fill="white") +  
    geom_histogram(binwidth = 1000)  + 
    facet_grid(imputed ~ .) +
    geom_vline(xintercept = mean.imputed.steps.by.date, color = "red",linetype="dashed") +
    labs(title = "Histogram showing steps/day freq.", x = "Steps per day", y = "Frequency of days occurrence")
  #print(combined.histograms)
}

f <- weekdays(as.Date(combined.steps.data$date))
combined.steps.data = transform(combined.steps.data, day.type = factor(ifelse(f == 'Saturday' | f == 'Sunday', 'weekend', 'weekday')))
