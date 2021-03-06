###################################################
### Read in the data
###################################################

mpls = read.csv(file = "/Users/andrewz/Documents/EPsy-8252/data/minneapolis.csv")

mpls



###################################################
### Remove missing data
###################################################

mpls = mpls[complete.cases(mpls), ]



###################################################
### Reshaping the data to the long format
###################################################

library(reshape2)

mplsLong = melt(
	mpls2, 
	id = c("studentID", "female"),
	measure = c("read.5", "read.6", "read.7", "read.8")
	)

# Rename the columns
names(mplsLong)[3] = "grade"
names(mplsLong)[4] = "read"

# Rename levels of grade column
levels(mplsLong$grade)[1] = "grade.5"
levels(mplsLong$grade)[2] = "grade.6"
levels(mplsLong$grade)[3] = "grade.7"
levels(mplsLong$grade)[4] = "grade.8"

# Coerce female into a factor
mplsLong$female = factor(mplsLong$female, 
	levels = c(0, 1), 
	labels = c("Male", "Female")
	)

# Coerce studentID into a factor
mplsLong$student = as.factor(mplsLong$studentID)

# Examine data
head(mplsLong)



###################################################
### Plot the reading scores by grade facetted on female 
###################################################

library(ggplot2)

ggplot(data = mplsLong, aes(x = grade, y = read)) +
	geom_line(alpha = 0.4, aes(group = studentID)) +
	stat_summary(fun.y = "mean", geom = "line", aes(group = 1), lwd = 1.5) +
	theme_bw() +
	xlab("Grade") +
	ylab("Reading Score") +
	facet_wrap(~female)




###################################################
### Fit repeated measures ANOVA with feamle as a predictor as well
###################################################

library(ez)

aov.2 = ezANOVA(
	data = mplsLong, 
	dv = read, 
	wid = student, 
	within = .(grade),
	between = .(female), 
	detailed = TRUE
	)
aov.2


