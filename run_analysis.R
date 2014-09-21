# Coursera Getting and Cleaning Data.
# Course Project 

#
# Make sure needed libraries are available
#
if(! require("data.table")){
  install.packages("data.table")
  if(! require(data.table)){
    stop("could not install required packages (data.table)")
  }
}

#
# Loads dataset and processes it.
# Can be used for either training or test data
#
load_dataset <- function(type, selected.features, activity.labels){
 
  # Create base path
  path <- paste(type, '/', sep = '')
  
  # Create file names
  feature.vectors.file <- paste(path, 'X_', type, '.txt', sep = '')
  activity.labels.file <- paste(path, 'y_', type, '.txt', sep = '')
  subject.ids.file <- paste(path, 'subject_', type, '.txt', sep= '')
  
  # Load data files using the file names
  feature.vectors.data <- read.table(feature.vectors.file)[,selected.features$id]
  activity.labels.data <- read.table(activity.labels.file)[,1]
  subject.ids.data <- read.table(subject.ids.file)[,1]
  
  # Name variables 
  names(feature.vectors.data) <- selected.features$label
  feature.vectors.data$label <- factor(activity.labels.data, levels=activity.labels$id, labels=activity.labels$label)
  feature.vectors.data$subject <- factor(subject.ids.data)
  
  # Return the preprocessed data set
  feature.vectors.data
}

#
# Actually perform the required analysis.
#
run_analysis <- function(){
  # Assume that the data set is extracted already in the current working directory
  setwd('UCI HAR Dataset/')
  
  # Load id->feature label data
  feature.vector.labels.data <- read.table('features.txt', col.names = c('id','label'))
  
  # Select only the measurements on the mean and standard deviation for each measurement.
  # Features we want to select have -mean() or -std() as a part of the name.
  selected.features <- subset(feature.vector.labels.data, grepl('-(mean|std)\\(', feature.vector.labels.data$label))
  
  # Load id->activity label data
  activity.labels <- read.table('activity_labels.txt', col.names = c('id', 'label'))
  
  # Read in the training data set
  train.df <- load_dataset('train', selected.features, activity.labels)
  
  # Read in the test data set
  test.df <- load_dataset('test', selected.features, activity.labels)
  
  # Merge the train and test sets
  merged.df <- rbind(train.df, test.df)

  # Convert the merged data to a data.table for easier processing
  merged.dt <- data.table(merged.df)
  
  # Calculate the average of each variable for each activity and each subject. 
  tidy.dt <- merged.dt[, lapply(.SD, mean), by=list(label,subject)]
  
  # Clean up the variable names
  tidy.dt.names <- names(tidy.dt)
  tidy.dt.names <- gsub('-mean', 'Mean', tidy.dt.names)
  tidy.dt.names <- gsub('-std', 'Std', tidy.dt.names)
  tidy.dt.names <- gsub('[()-]', '', tidy.dt.names)
  tidy.dt.names <- gsub('BodyBody', 'Body', tidy.dt.names)
  setnames(tidy.dt, tidy.dt.names)
  
  # Move back to the original working directory
  setwd('..')
  
  # Write out a text file with the final dataset
  write.table(tidy.dt, "tidy_dataset.txt", sep="\t")
}