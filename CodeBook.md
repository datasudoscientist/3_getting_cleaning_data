---
title: "CodeBook: Getting and Cleaning Data Assignment"
author: "Sajid Qadri"
date: "June 13, 2016"
output: html_document
---

There variables in the final dataset for this assignment consist of:

-1 "subject", which is a number between 1 and 30 representing the 30 participants in the study. This variable was converted to class factor for statistical analysis.

-1 "activity", which was a code between 1 and 6 which was converted to a descriptive phrase provided in the file activity_labels.txt. This variable was converted to class factor for statistical analysis.

-561 "features" , which consists of 561-feature vector with time and frequency domain variables. These variables were not converted, but the variable names were converted to vaible variable names using the function make.names.


Along the way the following objects were created and manipulated to create the final tidy dataset:

- features : names of 561 feature vector variables
- activites: descriptions of the 6 possible activity states
- feature_names: transformed features to acceptable variable names
- subjects_test: subjects in test data  
- features_test: features in test data  
- activities_test: activities in test data  
- subjects_train: subjects in training data 
- features_train: features in training data 
- activities_train: activities in training data
- activity_master: rbind test + training activites
- feature_master: rbind test + training features
- subject_master: rbind test + training subjects
- df_master: cbind activity-, feature-, subject- master
- deduped_df: df_master with duplicate feature columns removed
- df_mean: columns from deduped_df containing the description 'mean'
- df_std: columns from deduped_df containing the description 'std' for standard deviation
- df_cols: columns from deduped_df containing the other variables of interest, subject and activity
- df_analysis: cbind of df_mean, df_std, and df_cols
- df_avgs: aggregate of the averages of each variable for each activity and each subject
- step_4_df.txt: 
- step_5_df.txt: 
