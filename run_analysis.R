# ---------------------------------------------------------------------------------------
# Step 0 - Load the plyr library
# ---------------------------------------------------------------------------------------
library(plyr)

# ---------------------------------------------------------------------------------------
# Step 1 - Merge the training and test sets to create one data set
# ---------------------------------------------------------------------------------------
# Step 1a - Load the train data files
x_trn <- read.table("train/X_train.txt")
y_trn <- read.table("train/y_train.txt")
subject_trn <- read.table("train/subject_train.txt")

# Step 1b - Load the train data files
x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

# Step 1c - Create the x dataset file
x_data <- rbind(x_trn, x_test)

# Step 1d - Create the y dataset file
y_data <- rbind(y_trn, y_test)

# Step 1e - Create the subject dataset file
subject_data <- rbind(subject_trn, subject_test)

# ---------------------------------------------------------------------------------------
# Step 2 - Extract only the measurements on the mean and standard deviation for each measurement
# ---------------------------------------------------------------------------------------
# Step 2a - Load the features data file
features <- read.table("features.txt")

# Step 2b - Extract only columns with mean() or std() in their names
mean_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

# Step 2c - Subset the desired columns to x data
x_data <- x_data[, mean_std_features]

# Step 2d - Correct the column names
names(x_data) <- features[mean_std_features, 2]

# ---------------------------------------------------------------------------------------
# Step 3 - Use descriptive activity names to name the activities in the data set
# ---------------------------------------------------------------------------------------
# Step 3a - Load the activity labels data file
activity_labels <- read.table("activity_labels.txt")

# Step 3b - Update values with correct activity names
y_data[, 1] <- activity_labels[y_data[, 1], 2]

# Step 3c - Correct column name
names(y_data) <- "activity_labels"

# ---------------------------------------------------------------------------------------
# Step 4 - Appropriately labels the data set with descriptive variable names
# ---------------------------------------------------------------------------------------
# Step 4a - Correct column name
names(subject_data) <- "subject"

# Step 4b - Combine all the data in a single data set
all_data <- cbind(x_data, y_data, subject_data)

# ---------------------------------------------------------------------------------------
# Step 5 - From the data set in step 4, creates a second, independent tidy data set with 
#          the average of each variable for each activity and each subject
# ---------------------------------------------------------------------------------------
averages_data <- ddply(all_data, .(subject, activity_labels), function(x) colMeans(x[, 1:66]))
write.table(averages_data, "averages_data.txt", row.name=FALSE)

# ---------------------------------------------------------------------------------------
