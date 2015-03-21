> if(!file.exists("./data")){dir.create("./data")}

## dowloading the files from the site and saving them in working directory 
> fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
> download.file(fileUrl,destfile="./data/Dataset.zip")
## unzipping the files
> unzip(zipfile="./data/Dataset.zip",exdir="./data")
> path_rf <- file.path("./data" , "UCI HAR Dataset")
## listing the files in the path reference
> files<-list.files(path_rf, recursive=TRUE)
> files

## reading in the activity files
> dataActivityTest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
> dataActivityTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)
## reading in the subject files
>dataSubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
>dataSubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)
## reading feature files
>dataFeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
> dataFeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)
## looking at the properties of the activity data
>str(dataActivityTest)
>str(dataActivityTrain)
## looking at the properties of the subject data
>str(dataSubjectTrain)
>str(dataSubjectTest)
## looking at the properties of the feartures data
>str(dataFeaturesTest)
>str(dataFeaturesTrain)
## combining similar tables into one so that merging is much easier
> dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
> dataActivity<- rbind(dataActivityTrain, dataActivityTest) 
> dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)
## setting names to variables 
>names(dataSubject)<-c("subject")
>names(dataActivity)<- c("activity")
>dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
>names(dataFeatures)<- dataFeaturesNames$V2
## merge columns to get the data frame data
>dataCombine <- cbind(dataSubject, dataActivity
>Data <- cbind(dataFeatures, dataCombine)
## Note: don't print data frame without using head command.  It will take forever
## Subset Name of Features by measurements on the mean and standard deviation
>subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
## subset that data frame Data by selecting names of features
>selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
>Data<-subset(Data,select=selectedNames)
## check to make sure you've selected the means and std variables
>str(Data)
## read the descriptive activity names from the activity_lables.txt file 
>activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)
## checking that activity lables 
>head(Data$activity,30)
## label the dataset with descriptive variable names
>names(Data)<-gsub("^t", "time", names(Data))
>names(Data)<-gsub("^f", "frequency", names(Data))
>names(Data)<-gsub("Acc", "Accelerometer", names(Data))
>names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
>names(Data)<-gsub("Mag", "Magnitude", names(Data))
>names(Data)<-gsub("BodyBody", "Body", names(Data))
## checking the names of the data
>names(Data)
## creating a second, independent tidy data set and outputting it
>library(plyr);
>Data2<-aggregate(. ~subject + activity, Data, mean)
>Data2<-Data2[order(Data2$subject,Data2$activity),]
>write.table(Data2, file = "tidydata.txt",row.name=FALSE)
## produce codebook
>library(knitr)
>knit2html("codebook.Rmd");

