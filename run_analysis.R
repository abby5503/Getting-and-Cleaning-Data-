
#read train data
X_train <- read.table("~/Desktop/UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("~/Desktop/UCI HAR Dataset/train/y_train.txt")
Sub_train <- read.table("~/Desktop/UCI HAR Dataset/train/subject_train.txt")
#read test data
X_test <- read.table("~/Desktop/UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("~/Desktop/UCI HAR Dataset/test/y_test.txt")
Sub_test <- read.table("~/Desktop/UCI HAR Dataset/test/subject_test.txt")
#merge_train_test_data

X_total<-rbind(X_train, X_test)
Y_total<-rbind(Y_train, Y_test)
sub_total<-rbind(Sub_train, Sub_test)
merge_train_data<-cbind(Y_total,X_total)
merge_train_data<-cbind(sub_total,merge_train_data)



#Extracts only the measurements on the mean and standard deviation for each measurement

feature<-read.table("~/Desktop/UCI HAR Dataset/features.txt")
f_name=feature$V2
mean_std<- grepl(pattern="mean()|std()", f_name)
meanFreq<- grepl(pattern="meanFreq()", f_name)
f_key <- mean_std & !meanFreq
F_key <- c(TRUE,TRUE,f_key) 
mean_std_data <- merge_train_data[,f_key]



#Uses descriptive activity names to name the activities in the data set
mean_std_data$V1.1[mean_std_data$V1.1 == 1] <- "WALKING"
mean_std_data$V1.1[mean_std_data$V1.1 == 2] <- "WALKING_UPSTAIRS"
mean_std_data$V1.1[mean_std_data$V1.1 == 3] <- "WALKING_DOWNSTAIRS"
mean_std_data$V1.1[mean_std_data$V1.1 == 4] <- "SITTING"
mean_std_data$V1.1[mean_std_data$V1.1 == 5] <- "STANDING"
mean_std_data$V1.1[mean_std_data$V1.1 == 6] <- "LAYING"


#Appropriately labels the data set with descriptive variable names
xcolname<-f_name[f_key]
xcolname<-as.character(xcolname)
colnames(mean_std_data)<- c("subject", "activity",xcolname)

write.table(mean_std_data, file = "tydydata_1.csv", row.name=FALSE)

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
tidydata<-mean_std_data%>% group_by(subject,activity)%>%summarise_all(mean)

write.table(tidydata, file = "tydydata_2.csv", row.name=FALSE)






