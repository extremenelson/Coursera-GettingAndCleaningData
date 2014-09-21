Course Project Codebook
==============================================================


## Original Data

The original data was collected from smartphone accelerometer and gyroscope 
data. It was then processed using various signal processing techniques to
produce the archived data used in this project. Links to both the data as well
as the project itself are provided below.

- [source](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) 
- [description](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)


## Conventions followed

The code and dataset variable naming conventions are as described in the Google
R Style Guide as linked to below.

[Google R Styde Guide](http://google-styleguide.googlecode.com/svn/trunk/Rguide.xml).

## Data sets

### Raw data set

The raw dataset was created using the following regular expression to filter 
out required features for each measurement from the original feature vector set. 

`-(mean|std)\\(`

This regular expression selects 66 features from the original data set.
Combined with subject identifiers `subject` and activity labels `label`, this 
makes up the 68 variables of the processed raw data set.

The training and test subsets of the original dataset were combined to produce 
the final raw dataset.

### Tidy data set

Tidy data set contains the average of all feature standard deviation and mean 
values of the raw dataset. Examples of some of the variable name conversions
are listed below.

 1. Replaced `-mean` with `Mean`
 2. Replaced `-std` with `Std`
 3. Removed parenthesis `()`

