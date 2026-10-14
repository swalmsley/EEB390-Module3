
## Script to ask: how does radar Tilt affect murrelet sightings?

# Dataset from: https://doi.org/10.6084/m9.figshare.25308250


# 0 - Load packages -------------------------------------------------------
library(data.table)
library(ggplot2)


# 1 - Read in data --------------------------------------------------------

d <- data.table(read.csv('Data/Murrelet-data/mamu-count-data.csv'))


# 2 - Basic exploration ---------------------------------------------------

dim(d)
str(d)
summary(d[, .(Year, Tilt, SurveyDuration, PDSurveyDuration, MamuInPD)])

# Missing values in key columns
d[, lapply(.SD, function(x) sum(is.na(x))),
  .SDcols = c('Tilt', 'MamuInPD', 'PDSurveyDuration', 'Dir', 'Status')]

# Survey types and statuses
d[, .N, by = Dir]
d[, .N, by = Status]
d[, .N, by = Tilt][order(Tilt)]

# Raw distributions
hist(d$Tilt, main = 'Radar tilt', xlab = 'Tilt (degrees)')
hist(d$MamuInPD, main = 'Predawn incoming counts', xlab = 'MamuInPD')


# 3 - Data cleaning -------------------------------------------------------

# Keep complete, predawn (incoming) surveys with valid durations and tilt.
# Outgoing (evening) surveys have very different counts and negative
# predawn durations, so they are excluded.
dc <- d[Dir == 'Incoming' &
          Status == 'Complete' &
          !is.na(Tilt) &
          !is.na(MamuInPD) &
          PDSurveyDuration > 0]

# Sighting rate: predawn incoming birds per minute of predawn survey
dc[, sighting_rate := MamuInPD / PDSurveyDuration]

nrow(d); nrow(dc)  # rows before / after cleaning
summary(dc$sighting_rate)
hist(dc$sighting_rate, main = 'Sighting rate', xlab = 'Birds per minute')

# Sighting rates are strongly right-skewed, so also use a log scale
dc[, log_rate := log1p(sighting_rate)]


# 4 - Simple figure: Tilt vs sightings ------------------------------------

# Mean rate per tilt angle, to show the pattern beyond overplotted points
tilt_means <- dc[, .(mean_rate = mean(sighting_rate), n = .N), by = Tilt]

ggplot(dc, aes(x = Tilt, y = sighting_rate)) +
  geom_jitter(width = 0.3, alpha = 0.3, colour = 'grey40') +
  geom_point(data = tilt_means, aes(y = mean_rate, size = n),
             colour = 'firebrick') +
  geom_smooth(method = 'lm', colour = 'firebrick', fill = 'firebrick') +
  scale_y_log10() +
  labs(x = 'Radar tilt (degrees)',
       y = 'Sighting rate (birds per minute, log scale)',
       size = 'Surveys',
       title = 'Murrelet sighting rate vs. radar tilt') +
  theme_bw()

# Quick stats check
summary(lm(log_rate ~ Tilt, data = dc))
