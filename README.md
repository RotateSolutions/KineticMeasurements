This document describes the action of the script run_analysis.R.

Note: Packages "dbplyr", "readr", and "tidyr" must be loaded for this script to work.

The files from the dataset are imported into R as tibbles:

The raw data from the smartphones includes measurements of the total acceleration of the phone.  These are a vector with (x,y,z) coordinates. Once      acceleration due to gravity is removed, the total acceleration is split into
	* tangential acceleration 
		(acceleration in the direction of motion) 
and 	
	* normal acceleration 
		(acceleration perpendicular to the direction of motion).

Some of this data is "training" data, and the rest is "test" data.

THe "training" and "test" data are merged.

The original dataset also includes 561 measurements calculated from the raw data.  (Some of these are in the (original) time domain, and others are results of a Fourier transform and are in the frequency domain.) They are calculated for each record. The ones that are either a mean or a standard deviation are selected and the rest are discarded.

Like the raw data, these measurements are divided into "training" and "test" sets. As with the raw data, they are combined to form a single tibble "calculated".

Next, the tibble is reduced by selecting only the calculated measurements that are a mean or a standard deviation, to obtain the tibble "calculated_reduced".

The text names of the activities are substituted for the numbers 1,...,6 in the records representing them:
	* "walking"
	* "walking upstairs"
	* "walking downstairs"
	* "sitting"
	* "standing"
	* "lying

The names of the reduced set of calculated quantities are changed to something more readable, containing, as advised by my Coursera professor, no capital letters or underscore characters. The names are constructed as follows:

	* Each name of a calculated quantity begins with "time" or "freq", according to whether the calculated quantity lies in the time domain or (as obtained by a Fourier transform) in the frequency domain.

	* The second part of each name is "grav" or "body", according to whether the calculated quantity describes the action of gravity or the motion of the body of the subject.

	* The third part of each name is "tangential" or "normal", according to whether the quantity calculated is parallel to the direction of motion, or perpendicular to it.

	* The fourth part of each name is "force" or "jerk", according to whether the calculated measurement is a 2nd or 3rd derivative. (2nd derivatives measure acceleration and thus force, while 3rd derivatives measure the rate of change of force, which describes the "jerkiness" of the motion.)
	
	* The fifth part of each name is "x", "y", "z", or "mag", according to whether the number is the x-coordinate, y-coordinate, z-coordinate, or magnitude of a vector.

	* The sixth and last part of each name is "mean" or "stde", according to whether the calculated measurement is a mean or standard deviation.

The records of the table are grouped by subject and activity, and the grouped values averaged.

The final tibble gives the average of each variable for each activity and each subject. It is sorted first by activity, then by subject. 

The tibble is exported to a text file, which is the tidy data set. 