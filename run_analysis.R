#Course Project
#--------------

# Load all the files to merge later
# activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]
# data column names
features <- read.table("./UCI HAR Dataset/features.txt")[,2]

# Extract measurements (mean and std dev)
extract_features <- grepl("mean|std", features)

# X-test files:
#-------------
# Load  X_test, y_test and put the column names.
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
names(X_test) = features

# Extract measurements (mean and std dev)
X_test = X_test[,extract_features]
# activity labels
y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"
# and use of cbind to bind data
test_data <- cbind(as.data.table(subject_test), y_test, X_test)


# X-test files:
#-------------
# Same as test, do the same steps...
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
names(X_train) = features
# Extract measurements (mean and std dev)
X_train = X_train[,extract_features]
# activity data
y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"
# and use of cbind to bind data
train_data <- cbind(as.data.table(subject_train), y_train, X_train)

# Final tidy_data file
#---------------------
# Merge both test and train with rbind funtion and put labels on columsn
data = rbind(test_data, train_data)
id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data      = melt(data, id = id_labels, measure.vars = data_labels)

# Finally put mean function to data
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)
# ... and write the file
write.table(tidy_data, file = "./tidy_data.txt")