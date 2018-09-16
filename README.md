# Course Project for Getting and Cleaning Data

The script run_analysis.R does the following:

1. Downloads the dataset if it is not already present.
2. Reads the activity and feature text files.
3. Reads the training and test datasets, and filters it so that only those columns which are a mean or standard deviation measurement are retained.
4. Reads the activity and subject files for each dataset, and merges those columns with the respective dataset.
5. Merges both the test and train datasets into one dataset.
6. Changes the activity and subject columns into factors and gives the activities descriptive names.
7. Creates a tidy dataset with the average of each variable for each activity and each subject.