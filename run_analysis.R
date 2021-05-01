# Note: Packages "dbplyr", "readr", and "tidyr" must be loaded for this script to work.

# # First, the compressed dataset must be downloaded from the internet:
# download.file(
#         "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
#         "UCI HAR Dataset.zip"
#               )
# # Then, it must be unzipped:
# unzip("UCI HAR Dataset.zip")

# The data must reside in the directory "UCI HAR Dataset" in the working directory.

# Here, the files from the dataset are imported into R as tibbles:

# First, the names of features to be calculated from the raw data:
features <- read_table("./UCI HAR Dataset/features.txt", col_names=FALSE)

# Second, the list of subjects from whom the training data were collected...
subject_train <- read_table("./UCI HAR Dataset/train/subject_train.txt", col_names=FALSE)
# ...and the training data itself...
total_acc_x_train <- read_table("./UCI HAR Dataset/train/Inertial Signals/total_acc_x_train.txt", col_names=FALSE)
total_acc_y_train <- read_table("./UCI HAR Dataset/train/Inertial Signals/total_acc_y_train.txt", col_names=FALSE)
total_acc_z_train <- read_table("./UCI HAR Dataset/train/Inertial Signals/total_acc_z_train.txt", col_names=FALSE)
body_acc_x_train <- read_table("./UCI HAR Dataset/train/Inertial Signals/body_acc_x_train.txt", col_names=FALSE)
body_acc_y_train <- read_table("./UCI HAR Dataset/train/Inertial Signals/body_acc_y_train.txt", col_names=FALSE)
body_acc_z_train <- read_table("./UCI HAR Dataset/train/Inertial Signals/body_acc_z_train.txt", col_names=FALSE)
body_gyro_x_train <- read_table("./UCI HAR Dataset/train/Inertial Signals/body_gyro_x_train.txt", col_names=FALSE)
body_gyro_y_train <- read_table("./UCI HAR Dataset/train/Inertial Signals/body_gyro_y_train.txt", col_names=FALSE)
body_gyro_z_train <- read_table("./UCI HAR Dataset/train/Inertial Signals/body_gyro_z_train.txt", col_names=FALSE)
# ...and the quantities calculated from the training data...
X_train <- read_table("./UCI HAR Dataset/train/X_train.txt", col_names=FALSE)
# ...and the activities during which the training data were collected:
y_train <- read_table("./UCI HAR Dataset/train/y_train.txt", col_names=FALSE)

# Third, the list of subjects from whom the test data were collected...
subject_test <- read_table("./UCI HAR Dataset/test/subject_test.txt", col_names=FALSE)
# ...and the test data itself...
total_acc_x_test <- read_table("./UCI HAR Dataset/test/Inertial Signals/total_acc_x_test.txt", col_names=FALSE)
total_acc_y_test <- read_table("./UCI HAR Dataset/test/Inertial Signals/total_acc_y_test.txt", col_names=FALSE)
total_acc_z_test <- read_table("./UCI HAR Dataset/test/Inertial Signals/total_acc_z_test.txt", col_names=FALSE)
body_acc_x_test <- read_table("./UCI HAR Dataset/test/Inertial Signals/body_acc_x_test.txt", col_names=FALSE)
body_acc_y_test <- read_table("./UCI HAR Dataset/test/Inertial Signals/body_acc_y_test.txt", col_names=FALSE)
body_acc_z_test <- read_table("./UCI HAR Dataset/test/Inertial Signals/body_acc_z_test.txt", col_names=FALSE)
body_gyro_x_test <- read_table("./UCI HAR Dataset/test/Inertial Signals/body_gyro_x_test.txt", col_names=FALSE)
body_gyro_y_test <- read_table("./UCI HAR Dataset/test/Inertial Signals/body_gyro_y_test.txt", col_names=FALSE)
body_gyro_z_test <- read_table("./UCI HAR Dataset/test/Inertial Signals/body_gyro_z_test.txt", col_names=FALSE)
# ...and the quantities calculated from the test data...
X_test <- read_table("./UCI HAR Dataset/test/X_test.txt", col_names=FALSE)
# ...and the activities during which the test data were collected:
y_test <- read_table("./UCI HAR Dataset/test/y_test.txt", col_names=FALSE)

# Here, we merge the training and test data...
total_acc_x_all <- rbind(total_acc_x_train,total_acc_x_test)
total_acc_y_all <- rbind(total_acc_y_train,total_acc_y_test)
total_acc_z_all <- rbind(total_acc_z_train,total_acc_z_test)
body_acc_x_all <- rbind(body_acc_x_train,body_acc_x_test)
body_acc_y_all <- rbind(body_acc_y_train,body_acc_y_test)
body_acc_z_all <- rbind(body_acc_z_train,body_acc_z_test)
body_gyro_x_all <- rbind(body_gyro_x_train,body_gyro_x_test)
body_gyro_y_all <- rbind(body_gyro_y_train,body_gyro_y_test)
body_gyro_z_all <- rbind(body_gyro_z_train,body_gyro_z_test)
# ...and the calculated quantities for the combined data:
X_all <- rbind(X_train,X_test)
y_all <- rbind(y_train,y_test)

# Here, we construct a table including the calculated quantities for the combined data,
# with each record including both the subject performing the activity, and the activity performed:
calculated_train <- cbind(subject_train,y_train,X_train)
calculated_test <- cbind(subject_test,y_test,X_test)
calculated <- rbind(calculated_train,calculated_test)
calculated_names <- append(features$X1,c("subject","activity"),0)
names(calculated) <- calculated_names

# Here, the table is reduced by selecting only the calculated measurements that are a mean or a standard deviation:
calculated_reduced <- select(calculated,matches("mean()|std()|subject|activity")&!matches("meanFreq|angle"))

# Here, the text names of the activities are substituted for the numbers 1,..., 6 representing them:
activity_labels <- c("walking","walking upstairs","walking downstairs","sitting","standing","lying")
calculated_reduced$activity <- lapply(as.integer(calculated_reduced$activity),function(a){activity_labels[a]})

# Here the names of the reduced set of calculated quantities are changed to something more readable:
calculated_reduced_names <- c(
        "subject", "activity",
        "timebodylinearaccelerationxmean", "timebodylinearaccelerationymean", "timebodylinearaccelerationzmean",
        "timebodylinearaccelerationxstde", "timebodylinearaccelerationystde", "timebodylinearaccelerationzstde",
        "timegravitylinearaccelerationxmean", "timegravitylinearaccelerationymean", "timegravitylinearaccelerationzmean",
        "timegravitylinearaccelerationxstde", "timegravitylinearaccelerationystde", "timegravitylinearaccelerationzstde",
        "timebodylinearjerkxmean", "timebodylinearjerkymean", "timebodylinearjerkzmean",
        "timebodylinearjerkxstde", "timebodylinearjerkystde", "timebodylinearjerkzstde",
        "timebodyrotationalaccelerationxmean", "timebodyrotationalaccelerationymean", "bodyrotationalaccelerationzmean",
        "timebodyrotationalaccelerationxstde", "timebodyrotationalaccelerationystde", "bodyrotationalaccelerationzstde",
        "timebodyrotationaljerkxmean", "timebodyrotationaljerkymean", "timebodyrotationaljerkzmean",
        "timebodyrotationaljerkxstde", "timebodyrotationaljerkystde", "timebodyrotationaljerkzstde",
        "timebodylinearaccelerationmagmean",
        "timebodylinearaccelerationmagstde",
        "timegravlinearaccelerationmagmean",
        "timegravlinearaccelerationmagstde",
        "timebodylinearjerkmagmean",
        "timebodylinearjerkmagstde",
        "timebodyrotationalaccelerationmagmean",
        "timebodyrotationalaccelerationmagstde",
        "timebodyrotationaljerkmagmean",
        "timebodyrotationaljerkmagstde",
        "freqbodylinearaccelerationxmean", "freqbodylinearaccelerationymean", "freqbodylinearaccelerationzmean",
        "freqbodylinearaccelerationxstde", "freqbodylinearaccelerationystde", "freqbodylinearaccelerationzstde",
        "freqbodylinearjerkxmean", "freqbodylinearjerkymean", "freqbodylinearjerkzmean",
        "freqbodylinearjerkxstde", "freqbodylinearjerkystde", "freqbodylinearjerkzstde",
        "freqbodyrotationalaccelerationxmean", "freqbodyrotationalaccelerationymean", "freqbodyrotationalaccelerationzmean",
        "freqbodyrotationalaccelerationxstde", "freqbodyrotationalaccelerationystde", "freqbodyrotationalaccelerationzstde",
        "freqbodylinearaccelerationmagmean",
        "freqbodylinearaccelerationmagstde",
        "freqbodylinearjerkmagmean",
        "freqbodylinearjerkmagstde",
        "freqbodyrotationalaccelerationmagmean",
        "freqbodyrotationalaccelerationmagstde",
        "freqbodyrotationaljerkmagmean",
        "freqbodyrotationaljerkmagstde"
)
names(calculated_reduced) <- calculated_reduced_names

# The records of the table are grouped by subject and activity:
calculated_reduced_grouped <- group_by(calculated_reduced,subject,activity)

# The grouped values are averaged:
activities <- summarise_at(calculated_reduced_grouped,vars(timebodylinearaccelerationxmean:freqbodyrotationaljerkmagstde), mean)

# The table is split into 6 different tables, one for each activity.
# walking <- select(filter(activities,activity == "walking"),- activity)
# walking_upstairs <- select(filter(activities,activity == "walking_upstairs"),- activity)
# walking_downstairs <- select(filter(activities,activity == "walking_downstairs"),- activity)
# sitting <- select(filter(activities,activity == "sitting"),- activity)
# standing <- select(filter(activities,activity == "standing"),- activity)
# lying <- select(filter(activities,activity == "lying"),- activity)

# The table is exported to a text file:
write.table(apply(activities,2,as.character), "activities.txt", row.names = FALSE)
