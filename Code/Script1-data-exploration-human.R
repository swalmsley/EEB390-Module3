
## Script to clean and explore Murrelet data

# Sam Walmsley, October 2026
# Princeton University
# sam.walmsley@princeton.edu 

# Dataset from: https://doi.org/10.6084/m9.figshare.25308250


# 0 - Load packages -------------------------------------------------------
library(data.table)
library(ggplot2)


# 1 - Read in data --------------------------------------------------------

# Read in main dataframe
d <- data.table(read.csv('Data/Murrelet-data/mamu-count-data.csv'))
# Read in metadata (if we want to check what columns mean)
m <- read.csv('Data/Murrelet-data/mamu-count-metadata.csv')


# 2 - Data exploration ----------------------------------------------------

# Number of observations by year
d[,.N,by='Year']

# Calculate simple rate
d[,sighting_rate:=MamuMax/SurveyDuration,]
hist(d$sighting_rate)
range(d$sighting_rate, na.rm=TRUE)


# 3 - Data cleaning -------------------------------------------------------

# Check survey times
d[SurveyDuration<0,,]

# Exclude row with erroneous survey time
d <- d[SurveyDuration>=0,,]


# 4 - Making a simple figure ----------------------------------------------

# Association between tilt and incoming counts
g <- ggplot(d, aes(x=Tilt, y=MamuIn)) +
  geom_point() + 
  labs(x='Radar tilt', y='Incoming murrelet counts')+
  geom_smooth(method='lm')



# Saving figure to outputs ------------------------------------------------
png('./Output/Tilt-Figure.png', width=4, height=4, units='in', res=800)
g 
dev.off()
