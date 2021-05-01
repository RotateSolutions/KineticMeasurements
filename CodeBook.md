The files from the dataset are imported into R as tibbles.

First, the names of features to be calculated are contained in a one-column tibble called "features".

Second, the list of subjects from whom the training data were collected is contained in a one-column tibble called "subject_train", and the corresponding measurements are stored in the following tibbles:
	

Third, the list of subjects from whom the test data were collected is contained in a one-column tibble called "subject_test".
The training data itself is contain in three vector variables which each has three components (x,y,z):
	* total linear acceleration as measured by the accelerometer:
		total_acc_x_train, total_acc_y_train, total_acc_z_train 
	* linear acceleration of body (removing the influence of gravity):
		body_acc_x_train, body_acc_y_train, body_acc_z_train 
	* rotation of body as measured by the gyroscope:
		body_gyro_x_train, body_gyro_y_train, body_gyro_z_train 
In addition, there are various quantities calculated from the data. Some are in the orignial time domain, and others (by application of a Fourier transform) are in the frequency domain. These quantities are the entries of the tibble "features" described above. The 
	* measurements are in "X_train" 
and the 
	* activity involved is in "y_train"
	
Fourth, there are corresponding variables for the test data.  The names of these vaiables are identical to those for the training data, except that the string "train" is replaced by "test" ("total_acc_x_test", for example).

The training and test data are merged in variables with the same names, except that "train" and "test" are replaced by "all" ("tatal_acc_x_all", for example).

The tables "calculated_train" and "calculated_test" collect the calculated measurements (for training and test data, respectively), where each record includes both the subject performing the activity and the activity performed.
These collections of calculated measurements are merged in a table called "calculated".

As we are interested only in the measurements that consist of a mean or standard deviation, the table "calculated_reduced" is created from "calculated" containing just these measurements. 

The numbers indicating the six activities performed are replaced by the respective text descriptions 
"walking","walking upstairs","walking downstairs","sitting","standing","lying".

The names of the reduced set of calculated quantities are changed to something more readable.
The names of the reduced set of calculated quantities are changed to something more readable, containing, as advised by my Coursera professor, no capital letters or underscore characters. The names are constructed as follows:

	* Each name of a calculated quantity begins with "time" or "freq", according to whether the calculated quantity lies in the time domain or (as obtained by a Fourier transform) in the frequency domain.

	* The second part of each name is "grav" or "body", according to whether the calculated quantity describes the action of gravity or the motion of the body of the subject.

	* The third part of each name is "tangential" or "normal", according to whether the quantity calculated is parallel to the direction of motion, or perpendicular to it.

	* The fourth part of each name is "force" or "jerk", according to whether the calculated measurement is a 2nd or 3rd derivative. (2nd derivatives measure acceleration and thus force, while 3rd derivatives measure the rate of change of force, which describes the "jerkiness" of the motion.)
	
	* The fifth part of each name is "x", "y", "z", or "mag", according to whether the number is the x-coordinate, y-coordinate, z-coordinate, or magnitude of a vector.

	* The sixth and last part of each name is "mean" or "stde", according to whether the calculated measurement is a mean or standard deviation.
	
The records of the table "activities_reduced" are grouped by activity and subject to form the sorted table "calculated_reduced_grouped". Grouped values are averaged, to create the table "activities", with one average value for each measured quantity for each activity and subject.

(Finally, the table "activities" is exported as a text file.)