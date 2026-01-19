* ======================================================= *
* Module : BEEM136 Research Methods                       *
* Project: Misremembering Past Present Biases (Reproduce) *
* Author : Ziteng Dong                                    *
* Task   : Data Cleaning                                  *
* ======================================================= *


clear all

* ----------------------------- *
* Part I: Loading and preparing *
* ----------------------------- *

* Specify pathway for data
global DATA "../Data"

* Load data
import delimited "${DATA}/Data_Raw/data_raw.csv", clear

* Change all variable name into lowercase
foreach var of varlist _all {
    rename `var' `=lower("`var'")'
}



* --------------------------------------- *
* Part II: Data Cleaning and Manipulation *
* --------------------------------------- *

* --- Generate necessary variables --- *

* Dummy variable for gender
gen female = (gender == "Female")				

* New variable for mother's diploma
gen mother_dipl = 0								
replace mother_dipl = 1 if mothereduc == "PhD"  
replace mother_dipl = 1 if mothereduc == "MA"
replace mother_dipl = 1 if mothereduc == "BSC"

* --- Dropout time inconsistent subjects --- *

* Generate indicators for inconsistency 
foreach c in 1 2 3 {
    gen inconsistent`c' = 0
    forvalues i = 1/11 {
        local next = `i' + 1
        replace inconsistent`c' = 1 if ///
            choice`c'_`next' < choice`c'_`i' & inconsistent`c' == 0
    }
}

egen inconsistent = rowmax(inconsistent1 inconsistent2 inconsistent3)

* Drop inconsistent observations
drop if inconsistent == 1



* --- Generate Switching Points --- *

foreach c in 1 2 3 {
	gen switching_point`c' = .
	forvalues i = 1/12 {
		replace switching_point`c' = `i' ///
		if choice`c'_`i' == 2 & missing(switching_point`c')
	}
}

* Fill missing values with zero
foreach c in 1 2 3 {
	replace switching_point`c' = 0 if missing(switching_point`c')
}


* --- Classifying participants into time consistent/present-biased/future-biased --- *

gen timecons = (switching_point1 == switching_point2)
gen pb_dummy = (switching_point1 < switching_point2)
gen fb_dummy = (switching_point1 > switching_point2)



* --- Calculate difference in switching points between two visits

* Difference in switching points
gen sw_diff = switching_point2 - switching_point1

* Continuous present bias (positive differences)
gen pb_cont = max(sw_diff, 0)

* Continuous future bias (negative differences, in absolute value)
gen fb_cont = max(-sw_diff, 0)

* Combined continuous time preference
gen time_pref_cont = sw_diff



* --- Tables of distribution of selected variables --- *

tab timecons
tab pb_dummy
tab pb_cont if pb_cont>0
tab fb_dummy
tab fb_cont if fb_cont>0



* --- Recalling choices (third visit) --- *

* Recall correctly choices in the first visit (treatment == 0)
forvalues i = 1/12 {
	gen rem1_`i' = (treatment == 0 & choice1_`i' == choice3_`i') ///
	if treatment == 0
}

egen total_rem1 = rowtotal(rem1_*)


* Recall correctly choices in the second visit (treatment == 1)
forvalues i = 1/12 {
	gen rem2_`i' = (treatment == 1 & choice2_`i' == choice3_`i') ///
	if treatment == 1
}

egen total_rem2 = rowtotal(rem2_*)

* Combine two together
gen total_remember = max(total_rem1, total_rem2)



* --- Misremembering choices (third visit) --- *

* Dummy variable indicating existence of misremembering
gen diff13 = (switching_point1 - switching_point3) if treatment == 0
gen diff23 = (switching_point2 - switching_point3) if treatment == 1


gen misrem1_dummy = (diff13 != 0 & inconsistent1 == 0 ///
					& inconsistent3 == 0 & !missing(diff13)) ///
					if treatment == 0
gen misrem2_dummy = (diff23 != 0 & inconsistent2 == 0 ///
					& inconsistent3 == 0 & !missing(diff23)) ///
					if treatment == 1

gen misrem_dummy = misrem1_dummy
replace misrem_dummy = misrem2_dummy if missing(misrem_dummy)


* Calculate the intensity of misremembering

gen misrem1_int = diff13 ///
    if treatment == 0 & inconsistent1 == 0 & inconsistent3 == 0

gen misrem2_int = diff23 ///
    if treatment == 1 & inconsistent2 == 0 & inconsistent3 == 0


gen Misremembering_intensity = misrem1_int
replace Misremembering_intensity = misrem2_int if missing(Misremembering_intensity)


gen no_switching_point = (switching_point1 == 0 | switching_point2 == 0)

* --- Tables of distribution of selected variables --- *

tab misrem_dummy
tab Misremembering_intensity


* --------------------------------------------- *
* Part III: Finishing up and exporting the data *
* --------------------------------------------- *


keep gender mothereduc math socialrank_1 trust risk timepref_control ///
		patience_days treatment female mother_dipl inconsistent 	 /// 
		switching_point1 switching_point2 switching_point3 			 ///
		no_switching_point timecons pb_dummy fb_dummy sw_diff 		 ///
		pb_cont fb_cont time_pref_cont total_remember 				 ///
		misrem_dummy Misremembering_intensity


rename female Female
rename mother_dipl Mother_has_diploma
rename socialrank Social_rank
rename math Math
rename trust Trust
rename risk Risk
rename pb_dummy Present_bias_dummy
rename pb_cont Present_bias_intensity
rename fb_cont Future_bias_intensity
rename sw_diff Switching_point_difference
rename misrem_dummy Misremembering_dummy

rename switching_point1 Switching_point1
rename switching_point2 Switching_point2
rename switching_point3 Switching_point3



label var total_remember "Total Decisions Remembered"
label var time_pref_cont "Time Preferences"
label var Misremembering_intensity "Intensity of Misremembering"
label var Misremembering_dummy "Dummy of Misremembering"
label var Present_bias_intensity "Intensity of Present Bias"
label var inconsistent "Being Inconsistent in at least one of the three choices"
label var Switching_point_difference "Difference between Remembered and Actual Switching Point"
label var Future_bias_intensity "Intensity of Future Bias"
label var treatment "Second Visit"
label var no_switching_point "No Switching points at either first or second visit"



save "${DATA}/Data_Cleaned/Cleaned_Working_Data.dta", replace










