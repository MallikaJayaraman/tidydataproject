# tidydataproject
Course project for Getting and Cleaning Data

##Overview 
This file contains a description of the steps I took to complete the Course Project for the Getting and Cleaning Data course taught by Johns Hopkins University on Coursera. For this project, I compiled accelerometer and gyroscope data from a UCI Machine Learning experiment into a tidy data file, following the principles outlined in Hadley Wickam's tidy data article. 

The data can be accessed here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Hadley Wickman's article is available here: https://www.jstatsoft.org/article/view/v059i10/v59i10.pdf

##Methods
In order to create a tidy data file, I followed the five basic steps outlined in the project assigment:
1. Merge the training and the test sets to create one data set.
2. Extract only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

###Step 1: Merge the training and test sets
The first step in this portion of the analysis was to import all the relevant text files into R. These included: 
-features.txt: all the variable names in the dataset
-subject_test.txt: all the subjects in the test group
-subject_train.txt: all the subjects in the training group
-y_test.txt: the activities performed by subjects in the test group
-y_train.txt: the activities performed by subjects in the training group
-x_test.txt: accelerometer and gryoscope data collected for the test set
-y_test.txt accelerometer and gryoscope data collected for the training set

After importing these files, I merged the subject data into one table, using the rbind() command. I repeated this step for the activity and accelerometer/gyroscope data. Then, I attached specified the variable names table as the headers of the accelerometer/gyroscope data. Finally, I added columns specifying the subject ids (colname=subj_id) and the activities (colname=activity) to the accelerometer/gyroscope data using the cbind command(). For simplicity, I removed the intermediate data frames from RStudio and was left with my final data frame for Step 1, called data. 

###Step 2: Extract only the measurements on the mean and standard deviation for each measurement.
To extract all the mean and standard deviation measurements, I searched for column names containing either "mean" or the word "std" (standard deviation). I excluded columns containing "Freq" in order to exclude columns containing the "Weighted average of the frequency components to obtain a mean frequency", as this was not a measurement of a variable's mean. 

I used the grep function to search for these parameters. In addition, I included the subj_id and activity columns in my subsetted dataset. 

###Step 3: Uses descriptive activity names to name the activities in the data set.
To complete this step, I converted the activity column to a factor variable, and applied the activity labels specified in the activity_labels.txt file. 

###Step 4: Appropriately labels the data set with descriptive variable names.
For this step, I wanted to create labels for the variables that could easily be cross-referenced in the code book, but were still short enough to type in RStudio. To accomplish this, I made 4 key changes: 
-Removing extraneous characters, such as parentheses
-Enhancing the descriptive nature of characters, such as "t" and "f"
-Capitalizing letters at the beginning of words for easier readibility
-Changing dashes to underscores so that labels will appear consistently in R

I accomplished these steps using the sub and gsub functions. 

###Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Warwick defines tidy data as having the following characteristics: 
1. Each variable forms a column.
2. Each observation forms a row.
3. Each type of observational unit forms a table

Initially, in creating my tidy data set, I was concerned that the X, Y, and Z axis data collected for several variables should be stored in their own column as an axis variable. However, after some consideration, I concluded that this did not make sense for the following reasons: 
-not all variables have an X, Y, and Z axis measurement, and therefore this column would be unpopulated for a number of variables
-this would make the data more difficult to analyze, as the mean of movement in the X, Y, and Z directions should be calculated individually
- X, Y, and Z measurements are distinct variables and not a categorical descriptor of a subset of subjects (the way different treatment groups would be).

To summarize by data, I used the group_by and summarize_all functions from the dplyr package. I grouped my dataset by the subject_id and activity variables and then calculated the mean of the remaining variables. This generated my final tidy data product. 