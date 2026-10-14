
## Script to identify errors in Murrelet dataset

# Sam Walmsley, October 2026
# Princeton University
# sam.walmsley@princeton.edu 

# Dataset from: https://doi.org/10.6084/m9.figshare.25308250



# E1 - Bad sunrise time ---------------------------------------------------

# histograms
hist(d$Sunrise)
# too high
d[Sunrise>1000,,]
# too low
d[Sunrise<120,,]




# E2 - Unexpected or wrong survey duration --------------------------------

# negative value!
d[SurveyDuration<0,,]
#  (EndHour)*60+(EndMinute) – (StartHour)*60+(StartMinute) – ObstructedMinutes.
d[, my_sd_calculation:=((EndHour*60)+EndMinute) - ((StartHour)*60+StartMinute) - ObstructedMinutes, by=.I]
d[SurveyDuration!=my_sd_calculation,,] # 20 rows of difference




# E3 - Rows with birds but survey duration is 0 ---------------------------

d[SurveyDuration==0 & MamuIn>0,,]





# E4 - Logic errors in obstruction time -----------------------------------

# 105 minutes obstructed pre-dawn, but only 11 total
d[PDObstructedMinutes > ObstructedMinutes,,] # 1 row




# E5 - Status "complete" for full rainout ---------------------------------

d[Status=='Complete' & SurveyDuration==0,,] 




# E6 - Logic errors in predawn vs total counts ----------------------------

d[MamuInPD>MamuIn,,] # 46 rows





# E7 - Missing time values ------------------------------------------------

d[is.na(EndMinute),,]
d[is.na(EndMinute),,]



# E8 - Changing habitat classifications -----------------------------------

d[,unique(Loc),by='Name'] # Kelsey Bay both coastal and inland?









