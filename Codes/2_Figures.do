* ======================================================= *
* Module : BEEM136 Research Methods                       *
* Project: Misremembering Past Present Biases (Reproduce) *
* Author : Ziteng Dong                                    *
* Task   : Generating Figures                             *
* ======================================================= *


clear all

* Specify pathway for data
global DATA "../Data"       // import data
global OUTPUT "../Output"	// export data



* ----------------------------------- *
* Figure 1: Switching Point Histogram *
* ----------------------------------- *

clear all
use "${DATA}/Data_Cleaned/Cleaned_Working_Data.dta"

* Difference in switching points (2nd visit - 1st visit)
gen sw_diff12 = Switching_point2 - Switching_point1
label var sw_diff12 "Difference in switching points between second and first visit"

* Histogram
histogram sw_diff12, discrete width(1) percent color(navy)			///
    xtitle("Switching point difference (2nd visit - 1st visit)")	///
    ytitle("Percent of participants")
    
graph export "${OUTPUT}/Output_Figures/Figure_1_switching_point_diff.png", as(png) replace



* ------------------------------------ *
* Figure 2: Fractional polynomial plot *
* ------------------------------------ *

gen total_rem1 =.
replace total_rem1 = total_remember if treatment == 0
gen total_rem2 =.
replace total_rem2 = total_remember if treatment == 1
gen pb_cont = Present_bias_intensity	
	

*Combined graph
twoway 																								///
	(fpfitci total_rem1 pb_cont if treatment==0, lcolor(blue) fcolor(blue%30) lwidth(vvthin))		///
	(fpfit total_rem1 pb_cont if treatment==0, lcolor(blue) lwidth(medium)) 						///
	(fpfitci total_rem2 pb_cont if treatment==1, lcolor(orange) fcolor(orange%30) lwidth(vvthin))	///
	(fpfit total_rem2 pb_cont if treatment==1, lcolor(orange) lwidth(medium)), 						///
	xtitle("Intensity of present bias") ytitle("Number of correctly remembered choices") 			///
	ylabel(1(1)12) yscale(range(1 12)) legend(order(1 4) 											///
	label(1 "Remembering choices during the first visit") 											///
	label(4 "Remembering choices during the second visit") pos(6) col(1) ring(0))


graph export "${OUTPUT}/Output_Figures/Figure_2_fractional_polynomial.png", as(png) replace


* ---------------------------------------------------- *
* Figure 3: CDF of total_remember by group (1st visit) *
* ---------------------------------------------------- *

clear all
use "${DATA}/Data_Cleaned/Cleaned_Working_Data.dta"

// Filters
keep if treatment == 0
sort total_remember

// Cumulative distribution function for present-biased and non-present-biased groups
cumul total_remember if Present_bias_dummy == 1, gen(cdf_pb)
cumul total_remember if Present_bias_dummy == 0, gen(cdf_npb)

// Draw their CDFs in one plot
twoway ///
	(line cdf_pb total_remember if Present_bias_dummy == 1, sort) ///
	(line cdf_npb total_remember if Present_bias_dummy == 0, sort), ///
	legend(order(1 "Present Biased" 2 "Non-Present Biased")) ///
	ytitle("CDF") xtitle("Correctly remembered choices")
	
graph export "${OUTPUT}/Output_Figures/Figure_3_cdf_1visit.png", as(png) replace

* ---------------------------------------------------- *
* Figure 4: CDF of total_remember by group (2nd visit) *
* ---------------------------------------------------- *

clear all
use "${DATA}/Data_Cleaned/Cleaned_Working_Data.dta"

// Filters
keep if treatment == 1
sort total_remember
// Cumulative distribution function for present-biased and non-present-biased groups
cumul total_remember if Present_bias_dummy == 1, gen(cdf_pb)
cumul total_remember if Present_bias_dummy == 0, gen(cdf_npb)

// Draw their CDFs in one plot
twoway ///
	(line cdf_pb total_remember if Present_bias_dummy == 1, sort) ///
	(line cdf_npb total_remember if Present_bias_dummy == 0, sort), ///
 	legend(order(1 "Present Biased" 2 "Non-Present Biased)")) ///
	ytitle("CDF") xtitle("Correctly remembered choices")

graph export "${OUTPUT}/Output_Figures/Figure_4_cdf_2visit.png", as(png) replace
