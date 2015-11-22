# 1. Merges the training and the test sets to create one data set

# Read data into data frames

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")

# Load feature labels
features <- read.table("./UCI HAR Dataset/features.txt")

# Add column name for subject files
names(subject_train) <- "subject"
names(subject_test) <- "subject"

# Add column names for the files
names(X_train) <- features$V2
names(X_test) <- features$V2

names(y_train) <- "activity"
names(y_test) <- "activity"

# Merge files into one dataset
trainset <- cbind(subject_train,X_train,y_train)
testset <- cbind(subject_test, X_test, y_test)
data <- rbind(trainset,testset)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

# Determine which columns contain "mean()" or "std()"
wantedColumns <- features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]

# Add also subject_ID and activity columns
wantedColumns <- c(as.character(wantedColumns), "subject", "activity")

# Subset the data frame by wanted columns
data <- subset(data, select=wantedColumns)


# 3. Uses descriptive activity names to name the activities in the data set

# Load the activity labels
activity <- read.table("./UCI HAR Dataset/activity_labels.txt")

# factorize the variable activity in data frame data using descriptive activity names
data$activity <- factor(data$activity, labels = activity[,2])

# 4. Appropriately labels the data set with descriptive variable names. 
names(data) <- gsub("^t", "time", names(data))
names(data) <- gsub("^f", "frequency", names(data))
names(data) <- gsub("Acc", "Accelerometer", names(data))
names(data) <- gsub("Gyro", "Gyroscope", names(data))
names(data) <- gsub("Mag", "Magnitude", names(data))


# 5. From the data set in step 4, creates a second, independent tidy data set with the average 
# of each variable for each activity and each subject.
library(plyr)
library(dplyr)

# create the tidy data set
tidy <- aggregate(. ~subject + activity, data, mean)
tidy <-tidy[order(tidy$subject,tidy$activity),]

write.table(tidy, file = "tidydata.txt",row.name=FALSE)


