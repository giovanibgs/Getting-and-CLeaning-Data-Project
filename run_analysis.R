# reading features and activity labels data
features <- read.table("C:/Users/usuario/Desktop/DSSWork/UCI HAR Dataset/features.txt")
activitylabels <- read.table("C:/Users/usuario/Desktop/DSSWork/UCI HAR Dataset/activity_labels.txt")

# reading train data
subjecttrain <-read.table("C:/Users/usuario/Desktop/DSSWork/UCI HAR Dataset/train/subject_train.txt", header=FALSE)
xtrain <- read.table("C:/Users/usuario/Desktop/DSSWork/UCI HAR Dataset/train/X_train.txt", header=FALSE)
ytrain <- read.table("C:/Users/usuario/Desktop/DSSWork/UCI HAR Dataset/train/y_train.txt", header=FALSE)

# naming train data
colnames(subjecttrain) <- "STid"
colnames(xtrain) <- "Features"
colnames(ytrain) <- "Activity"

# reading test data
subjecttest <- read.table("C:/Users/usuario/Desktop/DSSWork/UCI HAR Dataset/test/subject_test.txt") 
xtest <- read.table("C:/Users/usuario/Desktop/DSSWork/UCI HAR Dataset/test/x_test.txt")
ytest <- read.table("C:/Users/usuario/Desktop/DSSWork/UCI HAR Dataset/test/y_test.txt")

# naming test data
colnames(subjecttest) <- "STid"
colnames(xtests) <- "Features"
colnames(ytest) <- "Activity"

# Data Merge
# first step is merging train data
trainmerge <- cbind(subjecttrain, xtrain, ytrain)
# second step is merging test data
testmerge <- cbind(subjecttest, xtest, ytest)
# Final step is to merge train and test data
traintestmerge <- rbind(trainmerge, testmerge)

# Mean and Standard deviation for each measurement
meanstd <- traintestmerge[,grepl("mean|std|subject|Activity",colnames(traintestmerge))]

# Descriptive activity names
library(plyr)
meanstd <- join(meanstd, activityLabel, by = "Activity", match = "first")
meanstd <- meanstd[,-1]

# Labels with descriptive variable names
names(meanstd) <- gsub("\\(|\\)", "", names(meanstd), perl  = TRUE)
names(meanstd) <- make.names(names(meanstd))
names(meanstd) <- gsub("Acc", "Acceleration", names(meanstd))
names(meanstd) <- gsub("^t", "Time", names(meanstd))
names(meanstd) <- gsub("^f", "Frequency", names(meanstd))
names(meanstd) <- gsub("BodyBody", "Body", names(meanstd))
names(meanstd) <- gsub("mean", "Mean", names(meanstd))
names(meanstd) <- gsub("std", "Std", names(meanstd))
names(meanstd) <- gsub("Freq", "Frequency", names(meanstd))
names(meanstd) <- gsub("Mag", "Magnitude", names(meanstd))

# Independent tidy data set with the average of each variable for each activity and each subject.
meanstd2 <- ddply(meanstd, c("subject","activity"), numcolwise(mean))
write.table(meanstd2,file="newdataset.txt")



