* ======================================================= *
* Module : BEEM136 Research Methods                       *
* Project: Misremembering Past Present Biases (Reproduce) *
* Author : Ziteng Dong                                    *
* Task   : Generating Tables                              *
* ======================================================= *


clear all

* Specify pathway for data
global DATA "../Data"                   // import data
global OUTPUT "../Output"	// export data



* --------------------------------------------- *
* Table 1: Average correctly remembered choices *
* --------------------------------------------- *

* --- Import data --- *
use "${DATA}/Data_cleaned/Cleaned_Working_Data.dta"

drop if no_switching_point == 1

* --- Necessary calculation --- *

* Computing group-wise confidence intervals for means
// First visit (treatment == 0)
ci mean total_remember if treatment == 0 & Present_bias_dummy == 1   // present-biased
ci mean total_remember if treatment == 0 & timecons == 1             // time-consistent
ci mean total_remember if treatment == 0 & Present_bias_dummy == 0   // not present-biased
ci mean total_remember if treatment == 0 & fb_dummy == 1             // future-biased
	
// Second visit (treatment == 1)
ci mean total_remember if treatment == 1 & Present_bias_dummy == 1	// present-biased
ci mean total_remember if treatment == 1 & timecons == 1			// time-consistent
ci mean total_remember if treatment == 1 & Present_bias_dummy == 0	// not present-biased
ci mean total_remember if treatment == 1 & fb_dummy == 1 			// future-biased

* Create an indicator for present bias and time consistent
// First visit (treatment == 0)
gen pb_timecons =.
replace pb_timecons = 0 if treatment == 0 & Present_bias_dummy == 1
replace pb_timecons = 1 if treatment == 0 & timecons == 1

// Second visit (treatment == 1)
gen pb_timecons2 =.
replace pb_timecons2 = 0 if treatment == 1 & Present_bias_dummy == 1
replace pb_timecons2 = 1 if treatment == 1 & timecons == 1

* Create an indicator for future bias and present bias
// First visit (treatment == 0)
gen fb_pb =.
replace fb_pb = 0 if treatment == 0 & fb_dummy == 1
replace fb_pb = 1 if treatment == 0 & Present_bias_dummy == 1

// Second visit (treatment == 1)
gen fb_pb2 =.
replace fb_pb2 = 0 if treatment == 1 & fb_dummy == 1
replace fb_pb2 = 1 if treatment == 1 & Present_bias_dummy == 1

* Create an indicator for comparing present bias between 1st and 2nd vists
gen pb_first_second =.
replace pb_first_second = 0 if treatment == 0 & Present_bias_dummy == 1
replace pb_first_second = 1 if treatment == 1 & Present_bias_dummy == 1

* Create an indicator for comparing time consistency between 1st and 2nd vists
gen tc_first_second =.
replace tc_first_second = 0 if treatment == 0 & timecons == 1
replace tc_first_second = 1 if treatment == 1 & timecons == 1

* Create an indicator for comparing non-present bias between 1st and 2nd vists
gen nopb_first_second =.
replace nopb_first_second = 0 if treatment == 0 & Present_bias_dummy == 0
replace nopb_first_second = 1 if treatment == 1 & Present_bias_dummy == 0

* Create an indicator for comparing future bias between 1st and 2nd vists
gen fb_first_second =.
replace fb_first_second = 0 if treatment == 0 & fb_dummy == 1
replace fb_first_second = 1 if treatment == 1 & fb_dummy == 1


* Test if the remember data (group-wise) come from the same distribution

// First visit (treatment == 0; within group) 
ranksum total_remember if treatment == 0, by(pb_timecons)			// present-biased vs time-consistent 
ranksum total_remember if treatment == 0, by(Present_bias_dummy)	// present-biased vs non-present-biased 
ranksum total_remember if treatment == 0, by(fb_pb)					// future-biased vs present-biased

// Second visit (treatment == 1; within group)
ranksum total_remember if treatment == 1, by(pb_timecons2)			// present-biased vs time-consistent 
ranksum total_remember if treatment == 1, by(Present_bias_dummy)	// present-biased vs non-present-biased 
ranksum total_remember if treatment == 1, by(fb_pb2)				// future-biased vs present-biased

// 1st vs 2nd visit (across group)
ranksum total_remember if Present_bias_dummy == 1, by(pb_first_second)		// present bias
ranksum total_remember if timecons == 1, by(tc_first_second)				// time consistency
ranksum total_remember if Present_bias_dummy == 0, by(nopb_first_second)	// non-present bias
ranksum total_remember if fb_dummy == 1, by(fb_first_second)				// future bias





* ------------------------------------------------------- *
* Table 2: Regression Results 1_Existence of Present Bias *
* ------------------------------------------------------- *

clear all
use "${DATA}/Data_cleaned/Cleaned_Working_Data.dta"

* Filtering
drop if fb_dummy == 1					// remove future-biased obs.
drop if Misremembering_intensity < 0	// remove 'wrong' direction obs.
drop if treatment == 1					// drop obs if from 2nd visit 
drop if no_switching_point == 1			// remove obs. without choosing switching point

* This dataset corresponds to: 
* obs. from the first visit;
* present-biased vs time-consistent obs;
* directional misremembering (recalled switching < actual switching)

* --- Regression 1.1 (1st Visit) --- *

* To estimate if present-biased participants are more likely than 
* time-consistent participants to exhibit directional misremembering

reg Misremembering_dummy Present_bias_dummy, robust

outreg2 using "${OUTPUT}/Output_Tables/regression_tables1.xls", replace tex(frag pr land) label sortvar(Present_bias_dummy)

* --- Regression 1.2 (1st Visit) --- *

* To estimate if present-biased participants exhibit stronger 
* motivated misremembering than time-consistent participants

reg Misremembering_intensity Present_bias_dummy, robust

outreg2 using "${OUTPUT}/Output_Tables/regression_tables1.xls", append tex(frag pr land) label sortvar(Present_bias_dummy)

*------------------------------------------------------------------------*

clear all
use "${DATA}/Data_cleaned/Cleaned_Working_Data.dta"

* Filtering
drop if fb_dummy == 1					// remove future-biased obs.
drop if Misremembering_intensity < 0	// remove 'wrong' direction obs.
drop if treatment == 0					// drop obs if from 1st visit 
drop if no_switching_point == 1			// remove obs. without choosing switching point

* This dataset corresponds to: 
* obs. from the second visit;
* present-biased vs time-consistent obs;
* directional misremembering (recalled switching < actual switching)

* --- Regression 1.3 (2nd Visit) --- *

* To estimate if present-biased participants are more likely than 
* time-consistent participants to exhibit directional misremembering

reg Misremembering_dummy Present_bias_dummy, robust

outreg2 using "${OUTPUT}/Output_Tables/regression_tables1.xls", append tex(frag pr land) label sortvar(Present_bias_dummy)

* --- Regression 1.4 (2nd Visit) --- *

* To estimate if present-biased participants exhibit stronger 
* motivated misremembering than time-consistent participants

reg Misremembering_intensity Present_bias_dummy, robust

outreg2 using "${OUTPUT}/Output_Tables/regression_tables1.xls", append tex(frag pr land) label sortvar(Present_bias_dummy)


* ------------------------------------------------------- *
* Table 3: Regression Results 2_Intensity of Present Bias *
* ------------------------------------------------------- *

clear all
use "${DATA}/Data_cleaned/Cleaned_Working_Data.dta"

* Filtering
drop if fb_dummy == 1					// remove future-biased obs.
drop if Misremembering_intensity < 0	// remove 'wrong' direction obs.
drop if treatment == 1					// drop obs if from 2nd visit 
drop if no_switching_point == 1			// remove obs. without choosing switching point

* This dataset corresponds to: 
* obs. from the first visit;
* present-biased vs time-consistent obs;
* directional misremembering (recalled switching < actual switching)

* --- Regression 2.1 (1st Visit) --- *

* To estimate the relationship between the intensity of present bias and 
* the likelihood of motivated misremembering

reg Misremembering_dummy Present_bias_intensity, robust

outreg2 using "${OUTPUT}/Output_Tables/regression_tables2.xls", replace tex(frag pr land) label sortvar(Present_bias_intensity)

* --- Regression 2.2 (1st Visit) --- *

* To estimate the relationship between the intensity of present bias and 
* the intensity of motivated misremembering

reg Misremembering_intensity Present_bias_intensity, robust

outreg2 using "${OUTPUT}/Output_Tables/regression_tables2.xls", append tex(frag pr land) label sortvar(Present_bias_intensity)


*------------------------------------------------------------------------*

clear all
use "${DATA}/Data_cleaned/Cleaned_Working_Data.dta"

* Filtering
drop if fb_dummy == 1					// remove future-biased obs.
drop if Misremembering_intensity < 0	// remove 'wrong' direction obs.
drop if treatment == 0					// drop obs if from 1st visit 
drop if no_switching_point == 1			// remove obs. without choosing switching point

* This dataset corresponds to: 
* obs. from the second visit;
* present-biased vs time-consistent obs;
* directional misremembering (recalled switching < actual switching)

* --- Regression 2.3 (2nd Visit) --- *

* To estimate the relationship between the intensity of present bias and 
* the likelihood of motivated misremembering

reg Misremembering_dummy Present_bias_intensity, robust

outreg2 using "${OUTPUT}/Output_Tables/regression_tables2.xls", append tex(frag pr land) label sortvar(Present_bias_intensity)

* --- Regression 2.4 (2nd Visit) --- *

* To estimate the relationship between the intensity of present bias and 
* the intensity of motivated misremembering

reg Misremembering_intensity Present_bias_intensity, robust

outreg2 using "${OUTPUT}/Output_Tables/regression_tables2.xls", append tex(frag pr land) label sortvar(Present_bias_intensity)



* ---------------------- *
* Table 3: Randomization *
* ---------------------- *

* This is to check if the observable characteristics are balanced between treatment and control groups

clear all
use "${DATA}/Data_cleaned/Cleaned_Working_Data.dta"

* Generate new variables
gen female = (gender == "Female")
gen mother_dipl = inlist(mothereduc, "BSC", "MA", "PhD")

* --- Randomization table contents --- *

* Test the equality of proportions across two groups
prtest female, by(treatment)
prtest mother_dipl, by(treatment)

* Test the equality of means across treatment and control groups
ttest Social_rank, by(treatment)
ttest Math, by(treatment)
ttest Trust, by(treatment)
ttest Risk, by(treatment)

* Test whether the distribution of variables differs between treatment and control groups
ranksum Social_rank, by(treatment)
ranksum Math, by(treatment)
ranksum Trust, by(treatment)
ranksum Risk, by(treatment)	



* ------------------------------- *
* Table 4: Switching Point Matrix *
* ------------------------------- *

clear all
use "${DATA}/Data_cleaned/Cleaned_Working_Data.dta"

* Filtering
drop if inconsistent == 1
drop if Switching_point1 == 0
drop if Switching_point2 == 0

* This dataset corresponds to:
* obs. has exactly one switching point


* Generate a transition matrix
tabulate Switching_point1 Switching_point2, matcell(Freq) row

* Calculate percentages manually and store in matrix
matrix Pct = Freq

forvalues i = 1/`=rowsof(Pct)' {
    scalar row_sum = 0
    forvalues j = 1/`=colsof(Pct)' {
        scalar row_sum = row_sum + Freq[`i', `j']
	}
    forvalues j = 1/`=colsof(Pct)' {
        matrix Pct[`i', `j'] = 100 * Freq[`i', `j'] / row_sum
	}
}

* Calculate the total counts for each row
matrix Totals = J(`=rowsof(Freq)', 1, .)

forvalues i = 1/`=rowsof(Freq)' {
    scalar row_sum = 0
    forvalues j = 1/`=colsof(Freq)' {
        scalar row_sum = row_sum + Freq[`i', `j']
	}
    matrix Totals[`i', 1] = row_sum
}

* Combine counts and totals
matrix CountsWithTotals = J(`=rowsof(Freq)', `=colsof(Freq)+1', .)

forvalues i = 1/`=rowsof(Freq)' {
    forvalues j = 1/`=colsof(Freq)' {
        matrix CountsWithTotals[`i', `j'] = Freq[`i', `j']
	}
    matrix CountsWithTotals[`i', `=colsof(Freq)+1'] = Totals[`i', 1]
}

* Combine percentages and totals
matrix PercentagesWithTotals = J(`=rowsof(Pct)', `=colsof(Pct)+1', .)

forvalues i = 1/`=rowsof(Pct)' {
    forvalues j = 1/`=colsof(Pct)' {
        matrix PercentagesWithTotals[`i', `j'] = Pct[`i', `j']
	}
    matrix PercentagesWithTotals[`i', `=colsof(Pct)+1'] = Totals[`i', 1]
}

* Export the counts matrix with totals to Excel
putexcel set "${OUTPUT}/Output_Tables/transition_matrix.xlsx", sheet("Counts") replace

putexcel A1 = matrix(CountsWithTotals), names

* Export the percentages matrix with totals to Excel
putexcel set "${OUTPUT}/Output_Tables/transition_matrix.xlsx", sheet("Percentages") modify

putexcel A1 = matrix(PercentagesWithTotals), names



* -------------------------- *
* Table 5: Correlation Table *
* -------------------------- *

clear all
use "${DATA}/Data_cleaned/Cleaned_Working_Data.dta"

* Filtering
drop if inconsistent == 1
drop if Switching_point1 == 0
drop if Switching_point2 == 0

* This dataset corresponds to:
* obs. has exactly one switching point
* which is different from dataset in the paper


gen Misremembering_intensity_abs = abs(Misremembering_intensity)

pwcorr Misremembering_dummy Misremembering_intensity_abs Switching_point1 ///
	Switching_point2 fb_dummy Present_bias_dummy Female Math Social_rank ///
	Trust Risk, star(.05)

* --------------------------------------------- *
* Table 6: Regressions With Background Controls *
* --------------------------------------------- *

// 1) Table C.9: DV = Misremembering_dummy (directional, motivation-aligned)

clear all                          					// reset memory
use "${DATA}/Data_cleaned/Cleaned_Working_Data.dta" // load cleaned data

drop if fb_dummy == 1              // keep PB + time-consistent only
drop if Misremembering_intensity<0 // keep only motivation-aligned direction
drop if no_switching_point == 1    // keep only defined switching points

gen Second_visit = treatment        								// 1 = recall 2nd visit, 0 = recall 1st
gen presentbdummy_secondvisit = Present_bias_dummy*Second_visit     // PB dummy × 2nd visit
gen presentb_secondvisit      = Present_bias_intensity*Second_visit // PB intensity × 2nd visit

label var Second_visit "Second Visit"
label var presentbdummy_secondvisit "P. Bias x Second Visit"
label var presentb_secondvisit "P. Bias Intensity x Second Visit"

reg Misremembering_dummy Present_bias_dummy Second_visit, robust
outreg2 using "${OUTPUT}/Output_Tables/regr_c5.xls", replace tex(frag pr land) label ///
    sortvar(Present_bias_intensity Second_visit presentb_secondvisit Female Mother_has_diploma Social_rank Math Trust Risk)

reg Misremembering_dummy Present_bias_dummy Second_visit presentbdummy_secondvisit, robust
outreg2 using "${OUTPUT}/Output_Tables/regr_c5.xls", append tex(frag pr land) label ///
    sortvar(Present_bias_intensity Second_visit presentb_secondvisit Female Mother_has_diploma Social_rank Math Trust Risk)

reg Misremembering_dummy Present_bias_dummy Second_visit presentbdummy_secondvisit ///
    Female Mother_has_diploma Social_rank Math Trust Risk, robust
outreg2 using "${OUTPUT}/Output_Tables/regr_c5.xls", append tex(frag pr land) label ///
    sortvar(Present_bias_intensity Second_visit presentb_secondvisit Female Mother_has_diploma Social_rank Math Trust Risk)

reg Misremembering_dummy Present_bias_intensity Second_visit, robust
outreg2 using "${OUTPUT}/Output_Tables/regr_c5.xls", append tex(frag pr land) label ///
    sortvar(Present_bias_intensity Second_visit presentb_secondvisit Female Mother_has_diploma Social_rank Math Trust Risk)

reg Misremembering_dummy Present_bias_intensity Second_visit presentb_secondvisit, robust
outreg2 using "${OUTPUT}/Output_Tables/regr_c5.xls", append tex(frag pr land) label ///
    sortvar(Present_bias_intensity Second_visit presentb_secondvisit Female Mother_has_diploma Social_rank Math Trust Risk)

reg Misremembering_dummy Present_bias_intensity Second_visit presentb_secondvisit ///
    Female Mother_has_diploma Social_rank Math Trust Risk, robust
outreg2 using "${OUTPUT}/Output_Tables/regr_c5.xls", append tex(frag pr land) label ///
    sortvar(Present_bias_intensity Second_visit presentb_secondvisit Female Mother_has_diploma Social_rank Math Trust Risk)


// 2) Table C.10: DV = Misremembering_intensity (motivation-aligned)

reg Misremembering_intensity Present_bias_dummy Second_visit, robust
outreg2 using "${OUTPUT}/Output_Tables/regr_c6.xls", replace tex(frag pr land) label ///
    sortvar(Present_bias_intensity Second_visit presentb_secondvisit Female Mother_has_diploma Social_rank Math Trust Risk)

reg Misremembering_intensity Present_bias_dummy Second_visit presentbdummy_secondvisit, robust
outreg2 using "${OUTPUT}/Output_Tables/regr_c6.xls", append tex(frag pr land) label ///
    sortvar(Present_bias_intensity Second_visit presentb_secondvisit Female Mother_has_diploma Social_rank Math Trust Risk)

reg Misremembering_intensity Present_bias_dummy Second_visit presentbdummy_secondvisit ///
    Female Mother_has_diploma Social_rank Math Trust Risk, robust
outreg2 using "${OUTPUT}/Output_Tables/regr_c6.xls", append tex(frag pr land) label ///
    sortvar(Present_bias_intensity Second_visit presentb_secondvisit Female Mother_has_diploma Social_rank Math Trust Risk)

reg Misremembering_intensity Present_bias_intensity Second_visit, robust
outreg2 using "${OUTPUT}/Output_Tables/regr_c6.xls", append tex(frag pr land) label ///
    sortvar(Present_bias_intensity Second_visit presentb_secondvisit Female Mother_has_diploma Social_rank Math Trust Risk)

reg Misremembering_intensity Present_bias_intensity Second_visit presentb_secondvisit, robust
outreg2 using "${OUTPUT}/Output_Tables/regr_c6.xls", append tex(frag pr land) label ///
    sortvar(Present_bias_intensity Second_visit presentb_secondvisit Female Mother_has_diploma Social_rank Math Trust Risk)

reg Misremembering_intensity Present_bias_intensity Second_visit presentb_secondvisit ///
    Female Mother_has_diploma Social_rank Math Trust Risk, robust
outreg2 using "${OUTPUT}/Output_Tables/regr_c6.xls", append tex(frag pr land) label ///
    sortvar(Present_bias_intensity Second_visit presentb_secondvisit Female Mother_has_diploma Social_rank Math Trust Risk)



