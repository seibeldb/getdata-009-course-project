# Course Project
#setwd("/Users/seibeldb/Desktop/Online Classes/Johns Hopkins Data Science/Getting and Cleaning Data/Course Project/UCI HAR Dataset/")

# create a vector of the column numbers that contain mean and sd values.  these numbers where found by inspecting the "features.txt" file
means.sds<-c(1:6,41:46,81:86,121:126,161:166,201:202,214:215,227:228,240:241,253:254,266:271,294:296,345:350,373:375,424:429,452:454,503:504,513,516:517,526,529:530,539,542:543,552,555:561)

# create a vector of 561 "NULL" values and then insert "numeric" values corresponding to the columns that contain means and standard deviations.
# this will be used with read.table "colClasses=the.cc" to extract the column poitions marked as "numeric" and skip those marked as "NULL".
the.cc<-c(rep("NULL",561))  
the.cc[means.sds]<-"numeric"  

# create a list of the column names for mean and sd values.  the dataset comes with a file "features.txt" that contains all the column names.
the.rows=rep(FALSE,561)
the.rows[means.sds]<-TRUE  # the column numbers correspond to row numbers in the "features.txt" file
the.col.names<-read.table("features.txt")[the.rows,"V2"]

## read the activity codes and labels and create a function that converts the code into a label
the.activity.labels<-read.table("activity_labels.txt")
act.lab<-function (x) return(the.activity.labels$V2[x])

#### read and merge the training data

tr.subject<-read.table("train/subject_train.txt",col.names=c("subject-ID"))  #,nrows=10)
tr.activity<-read.table("train/y_train.txt",col.names=c("activity-code"))  #,nrows=10)
# add the activity column using the act.lab(x) function
tr.activity["activity"]<-sapply(tr.activity$activity.code,act.lab)

# read the metrics table while excluding the columns with "NULL" specified 
tr.metrics<-read.table("train/X_train.txt",colClasses=the.cc)  #,nrows=10)  
# add column names from features.txt
colnames(tr.metrics)<-the.col.names

# column merge the three tables
train.data<-cbind(tr.subject,tr.activity,tr.metrics)

#### read and merge the testing data

te.subject<-read.table("test/subject_test.txt",col.names=c("subject-ID"))  #,nrows=10)
te.activity<-read.table("test/y_test.txt",col.names=c("activity-code"))  #,nrows=10)
# add the activity column using the act.lab(x) function
te.activity["activity"]<-sapply(te.activity$activity.code,act.lab)  

# read the metrics table while excluding the columns with "NULL" specified 
te.metrics<-read.table("test/X_test.txt",colClasses=the.cc)  #,nrows=10)  
# add column names from features.txt
colnames(te.metrics)<-the.col.names

# column merge the three tables
test.data<-cbind(te.subject,te.activity,te.metrics)

# Combine test and training data

all.data<-rbind(train.data,test.data)

# create a summary of the means of grouped by activity and student.ID
tidy2<-aggregate(x=all.data[4:length(all.data)],by=list(all.data$activity,all.data$subject.ID),mean)
attributes(tidy2)$names[1:2]<-c("activity","student.ID")

# save tidy2 as a text file for upload to coursera
#setwd("/Users/seibeldb/Desktop/Online Classes/Johns Hopkins Data Science/Getting and Cleaning Data/Course Project")
write.table(tidy2,file="tidy2.txt",row.name=FALSE)
