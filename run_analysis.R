## Setting up the data: Reading the required files
subject_train <- read.table("./train/subject_train.txt", header=FALSE)
X_train <- read.table("./train/X_train.txt", header=FALSE)
y_train <- read.table("./train/y_train.txt", header=FALSE)

subject_test  <- read.table("./test/subject_test.txt", header=FALSE)
X_test <- read.table("./test/X_test.txt", header=FALSE)
y_test <- read.table("./test/y_test.txt", header=FALSE)

activity_labels <- read.table("./activity_labels.txt", header=FALSE)
features <- read.table("./features.txt", header=FALSE)

## Merge the X_train and X_test into one data set and add the column names from the features file
train_test <- rbind(X_train, X_test)

features_names <- t(features$V2)
names(train_test) <- features_names

## Grab just the mean and stdev in the train_test data set created above into two tables, means and std
mean_col <- grep("mean",names(train_test))
means <- train_test[,mean_col]

std_col <- grep("std",names(train_test))
std <- train_test[,std_col]

## Merge the subject_train and subject_test into one data set
subject <- rbind(subject_train, subject_test)
names(subject) <- c("subject")

## Merge the y_train and y_test into one data set
activity <- rbind(y_train, y_test)
names(activity) <- c("activity")

## Merge subject, activity, means, and std data sets into one big data set called run_data
run_data <- cbind(subject, activity, means, std)

## Use the descriptive activity names to name the activity in the run_data set
run_data1 <- merge(x=activity_labels, y=run_data, by.x="V1", by.y="activity")
run_data1 <- select(run_data1, -V1)
colnames(run_data1)[1] <- "activity"

## The run_data1 table already has the appropriate descriptive variable names.
## Here, I'm just cleaning up the column names a bit to remove the "()"
## Refer to the CodeBook for a detailed explanation of each descriptive variable
names(run_data1) <- gsub("\\()","",names(run_data1))

## Create a second, independent tidy data set with the average of each variable for each activity and each subject
grouped <- run_data1 %>% group_by(subject, activity) %>%
    summarise_each(funs(mean))

## Write the grouped table to a TidyData.txt file
write.table(grouped, file = "TidyData.txt", row.name=FALSE)