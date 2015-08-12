# Reproducible Research: Peer Assessment 1


## Loading and preprocessing the data


```r
data <- read.csv("activity.csv")
```

## What is mean total number of steps taken per day?

First, compute the total number of steps per day, excluding missing values

```r
library(ggplot2)
```

```
## Warning: package 'ggplot2' was built under R version 3.1.3
```


```r
raw.data <- read.csv("activity.csv")

data <- raw.data[!is.na(raw.data$steps),]

steps.by.date <- aggregate(steps ~ date, data = data, FUN = sum)
```

A histogram of the steps per day shows the distribution:


```r
p <- ggplot(steps.by.date, aes(x=steps)) +  geom_histogram(binwidth = 1000, fill="blue")  + 
  labs(title = "Histogram showing steps per day frequencies", 
       x = "Steps per day",
       y = "Frequency of occurrence")

print(p)
```

![](PA1_template_files/figure-html/meanstepshistogram-1.png) 

### Mean and median steps taken per day

The mean number of steps taken per day is 10766.19.

The median number of steps taken per day is 10765

## What is the average daily activity pattern?



## Imputing missing values



## Are there differences in activity patterns between weekdays and weekends?
