## Reading the files
subject_train <- read.table("./train/subject_train.txt", header=FALSE)
X_train <- read.table("./train/X_train.txt", header=FALSE)
y_train <- read.table("./train/y_train.txt", header=FALSE)

subject_test  <- read.table("./test/subject_test.txt", header=FALSE)
X_test <- read.table("./test/X_test.txt", header=FALSE)
y_test <- read.table("./test/y_test.txt", header=FALSE)

activity_labels <- read.table("./activity_labels.txt", header=FALSE)
features <- read.table("./features.txt", header=FALSE)

## Merge the X_train and X_test into one data set
train_test <- rbind(X_train, X_test)

## Grab just the mean and stdev for each measurement
features_names <- t(features$V2)
names(train_test) <- features_names

mean_col <- grep("mean",names(train_test))
means <- train_test[,mean_col]

std_col <- grep("std",names(train_test))
std <- train_test[,std_col]

## Merge the required measurements and other identification data into one table
subject <- rbind(subject_train, subject_test)
names(subject) <- c("subject")
y <- rbind(y_train, y_test)
names(y) <- c("y")
run_data <- cbind(subject, y, means, std)

## Use the descriptive activity names to name the activity in the run_data set
run_data1 <- merge(x=activity_labels, y=run_data, by.x="V1", by.y="subject")
run_data1 <- select(run_data1, -V1)
colnames(run_data1)[1] <- "Activity"
