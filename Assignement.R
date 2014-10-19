setwd("./Documents/Reproducable Research")

# Import data
data <- read.csv("activity.csv")

# Summarise data for total steps in day using dplyr package
library(dplyr)
Step_sum <- group_by(data, date) %>%
      summarise(daysum = sum(steps))

# Histogram of daily data
hist(Step_sum$daysum, xlab = "Total steps in day", col = "red", main = "Histogram of total steps in day")

# Mean and median of total steps taken per day
mean(Step_sum$daysum, na.rm = TRUE)
median(Step_sum$daysum, na.rm = TRUE)

# Summarise data for intervals with average interval steps
Interval_Avg <- group_by(data, interval) %>%
      summarise(intavg = mean(steps, na.rm = TRUE))

plot(Interval_Avg$interval, Interval_Avg$intavg, type = "n", xlab = "5 min Interval", ylab = "Average steps per interval", main = "Average number of steps per interval")
lines(Interval_Avg$interval, Interval_Avg$intavg)

# Return interval with largest average
Interval_Avg[ match(max(Interval_Avg$intavg),Interval_Avg$intavg), 1]

# Total number of NA
sum(is.na(data$steps))

# Replace NA values with average for interval time
library(data.table)
DT <- data.table(data)
setkey(DT, interval)

DT[,steps := ifelse(is.na(steps), median(steps, na.rm=TRUE), steps), by=interval]

# Repeat histogram, mean and median for daily sum with clean data
Clean_Step_sum <- group_by(DT, date) %>%
      summarise(cleandaysum = sum(steps))

hist(Clean_Step_sum$cleandaysum, xlab = "Total steps in day", col = "red", main = "Histogram of total steps in day")

mean(Clean_Step_sum$cleandaysum, na.rm = TRUE)
median(Clean_Step_sum$cleandaysum, na.rm = TRUE)

# Add variable showing weekday or weekend
library(lubridate)
Week_Data <- mutate(DT, day = ifelse( wday(ymd(date)) == 1 | wday(ymd(date)) == 7 , "Weekend" , "Weekday" ))

# Summarise data with average for weekday and interval
Weekday_avg <- group_by(Week_Data, day, interval) %>%
      summarise(avgsteps = mean(steps))

library(lattice)
xyplot(avgsteps ~ interval | day, data = Weekday_avg, type = "a")

