#set working directory
setwd("UCI HAR Dataset")
library(dplyr)

###Merges the training and the test sets to create one data set.
#read in headers file
headers <- read.table("features.txt", sep=" ")
#read in the subjects and merge
test_subj <- read.table("test/subject_test.txt", sep=" ")
train_subj <- read.table("train/subject_train.txt", sep=" ")
data_subj <-  rbind(test_subj, train_subj)
#read in activity labels and merge
test_act <- read.table("test/y_test.txt", sep=" ")
train_act <- read.table("train/y_train.txt", sep=" ")
data_act <-  rbind(test_act, train_act)
#read in matricies and merge
test <- read.table("test/x_test.txt")
train <- read.table("train/x_train.txt")
data <- rbind(test, train)

#attach headers, subject, and activity info
names(data) <- headers$V2
data$subj_id <- cbind(data_subj$V1)
data$activity <- cbind(data_act$V1)

#remove unneeded data frames
remove("data_act","data_subj","headers","test","test_act","test_subj","train","train_act","train_subj")


###Extracts only the measurements on the mean and standard deviation for each measurement.
data <- data[, c("subj_id", "activity", grep("(mean|std)[^Freq]", names(data), value=T))]


###Uses descriptive activity names to name the activities in the data set
data$activity <- factor(data$activity, 
                        labels=c("walking", "walking_upstairs", "walking_downstairs", "sitting", "standing", "laying"))

#Appropriately labels the data set with descriptive variable names.
#variable names joined above
#remove extraneous characters
names(data)[3:68]<- gsub("[()]","",names(data)[3:68])
names(data)[63:68] <- sub("Body","",names(data)[63:68])
#enhance decriptiveness of labels
names(data)[3:42] <- sub("t","Time_",names(data)[3:42])
names(data)[43:68] <- sub("f","Freq_",names(data)[43:68])
#capitalize letters
names(data)[3:68] <- sub("mean","Mean",names(data)[3:68])
names(data)[3:68] <- sub("std","Std",names(data)[3:68])
#use underscores instead of dashes
names(data)[3:68] <- gsub("-","_",names(data)[3:68])

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidydata <- group_by(data, subj_id, activity) %>%
    summarize_all(mean)
