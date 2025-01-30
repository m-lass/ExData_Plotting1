## This is the script for plot 3 of the Module 1 project of the Explanatory Analysis with R class.
## It provides the code used to generate the plot 3 graph that can be found in the project repo,
## including the pre-plotting data processing part.

## The dataset has 2075259 rows and 9 colums, which means that the required RAM in bytes is :
## 2075259 × 9 x 8 = 149418648 bytes. Converting it to MB : 149418648   ÷   1048576  = 142,5 MB.
## Using memuse(), we can find out our available RAM :

install.packages("memuse")
library(memuse)
Sys.meminfo()

## In my case, the output is :

## Totalram:  15.733 GiB 
## Freeram:    6.046 GiB

## So it should be fine.

power <- read.table("./household_power_consumption.txt", sep=";", header = TRUE)

## First we convert the dates so we can directly subset the dataset and use less memory for further
## processing. Here I had to cheat a little bit and go an hour into Saturday, any less than that and
## R would not add me the Saturday label on the x axis.

power$Date <- as.Date(power$Date, format = "%d/%m/%Y")
power <- subset(power,(power$Date=='2007-02-01'|power$Date=='2007-02-02'
                       |power$Date=='2007-02-03'&power$Time<="01:00:00"))

## Then we create a DateTime variable which combines the date and time info.

power$DateTime<-paste(power$Date,power$Time,sep=" ") 
power$DateTime <- strptime(power$DateTime, format = "%Y-%m-%d %H:%M:%S")
power$DateTime<-as.POSIXct(power$DateTime)

Sys.setlocale (category = "LC_TIME", locale = "English_Ireland.utf8") 
## Just for me, because I don't live in an English-speaking country...

## Next we need to convert the character variables into numeric ones in order to better manipulate them.

power$Global_active_power <- as.numeric(power$Global_active_power)
power$Global_reactive_power <- as.numeric(power$Global_reactive_power)
power$Voltage <- as.numeric(power$Voltage)
power$Global_intensity <- as.numeric(power$Global_intensity)
power$Sub_metering_1 <- as.numeric(power$Sub_metering_1)
power$Sub_metering_2 <- as.numeric(power$Sub_metering_2)

## Finally, we create plot 3 and export it as PNG.

plot(power$DateTime, power$Sub_metering_1, type = "l", xaxt = "n", xlab="", ylab="Energy sub metering")
lines(power$DateTime, power$Sub_metering_2, col="red")
lines(power$DateTime, power$Sub_metering_3, col="blue")
legend("topright", legend = c("Sub_metering_1        ","Sub_metering_2        ","Sub_metering_3        "), 
       cex= 1, lty = 1, lwd=2, col= c("black","red", "blue"), xpd=TRUE)
## Sorry, I added the spaces because I had a formatting issue during the export and couldn't seem to
## figure out where it was coming from.
axis.POSIXct(1, at = as.Date(power$DateTime), format = "%a")
dev.copy(png, file = "plot3.png")
dev.off()

## Default format is 480x480 so we do not need any extra steps.