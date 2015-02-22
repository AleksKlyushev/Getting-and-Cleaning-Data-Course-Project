#Script for make tiny data frame
library(dplyr)
#Read train data
train<-read.table("train\\X_train.txt")
#Read test data
test<-read.table("test\\X_test.txt")
#merge train and test data
Data<-rbind(train,test)
rm(test,train)
#Make Y features
train_Y<-read.table("train\\y_train.txt")
test_Y<-read.table("test\\y_test.txt")
Y<-rbind(train_Y,test_Y)
colnames(Y)<-'Y'
rm(test_Y,train_Y)
#Make Train/test(TT) features
TT<-c()
TT[1:7352]<-"Train"
TT[7353:10299]<-"Test"
#Make Subject(Sub) features
train_Sub<-read.table("train\\subject_train.txt")
test_Sub<-read.table("test\\subject_test.txt")
Sub<-rbind(train_Sub,test_Sub)
colnames(Sub)<-'Sub'
rm(test_Sub,train_Sub)
#read names of features
Label<-read.table("features.txt",colClasses = "character")
colnames(Data)<-Label[,2]
Data<-Data[,(grepl('mean',colnames(Data))|grepl('std',colnames(Data)))&!
                 grepl('meanFreq',colnames(Data))]
#Read active
Activ<-read.table("activity_labels.txt")
Data<-cbind(Data,Y,Sub)
for (i in c(1:6)){
      Data[which(Data$Y==i),'Y']<-as.character(Activ[i,2])
}
Data_n<-group_by(.data = Data,Sub,Y)
Data_end<-summarise_each(tbl = Data_n,funs(mean))   
write.table(Data_end,file="Data_sum.txt", row.names=FALSE)
