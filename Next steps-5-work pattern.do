set mem 5g
set more off

global workdir "C:\Users\sumit\Documents\Work\Worker Sorting\My work"
global regdir "$workdir\tex files\regressions"

do "$workdir\cleaning.do"

global covars "i.week i.wave i.section"
global outreg_setting "noni addtext(Section+Week+Wave FE, Yes) auto(3)"



**************************************************
**************Variable generation*****************
**************************************************

sort recruitmentid_new  startdatetime 
drop userweek_n 
bysort recruitmentid_new: gen userweek_n=_n
bysort recruitmentid_new: gen userweek_N=_N


gen 	type=1 if ad_office==0 & pref_office==0 & alloc_off==0
replace type=2 if ad_office==0 & pref_office==0 & alloc_off==1
replace type=3 if ad_office==0 & pref_office==1 & alloc_off==0
replace type=4 if ad_office==0 & pref_office==1 & alloc_off==1
replace type=5 if ad_office==1 & pref_office==0 & alloc_off==0
replace type=6 if ad_office==1 & pref_office==0 & alloc_off==1
replace type=7 if ad_office==1 & pref_office==1 & alloc_off==0
replace type=8 if ad_office==1 & pref_office==1 & alloc_off==1

label define type 1 "HHH" 2 "HHO" 3 "HOH" 4 "HOO" 5 "OHH" 6 "OHO" 7 "OOH" 8 "OOO"
label val type type 

gen wave_new=wave
replace wave_new=3 if wave==2

label define wave_new 3 "2 & 3" 5 "3.5" 6 "4" 
label val wave_new wave_new 

*Types for allocation
gen 	type1=1 if ad_office==0 & pref_office==0 
replace type1=2 if ad_office==0 & pref_office==1 
replace type1=3 if ad_office==1 & pref_office==0 
replace type1=4 if ad_office==1 & pref_office==1 

label define type1 1 "HH*" 2 "HO*" 3 "OH*" 4 "OO*" 
label val type1 type1

*Types for selection
gen 	type2=1 if ad_office==0 & alloc_off==0 
replace type2=2 if ad_office==0 & alloc_off==1 
replace type2=3 if ad_office==1 & alloc_off==0 
replace type2=4 if ad_office==1 & alloc_off==1 

label define type2 1 "H*H" 2 "H*O" 3 "O*H" 4 "O*O" 
label val type2 type2


*Types for Ad type
gen 	type3=1 if pref_office==0 & alloc_off==0 
replace type3=2 if pref_office==0 & alloc_off==1 
replace type3=3 if pref_office==1 & alloc_off==0 
replace type3=4 if pref_office==1 & alloc_off==1 

label define type3 1 "*HH" 2 "*HO" 3 "*OH" 4 "*OO" 
label val type3 type3




********************************************
***************Work Pattern*****************
********************************************


gen hour = hh(startdatetime)

gen day = 1
replace day=2 if startday==`"Tuesday"'
replace day=3 if startday==`"Wednesday"'
replace day=4 if startday==`"Thursday"'
replace day=5 if startday==`"Friday"' 
replace day=6 if startday==`"Saturday"'
replace day=7 if startday== `"Sunday"'


label define day 1 "Mon" 2 "Tue" 3 "Wed" 4 "Thr" 5 "Fri" 6 "Sat" 7 "Sun", replace

label values day day 


gen seq=(day*100)+hour


*Was looking if there is pattern in how DEOs spend time through weeks across DEOs
encode recruitmentid_new, gen(id)

preserve

keep if id<200 & id>160

hist hour if id==229 & day==4, freq by(week)

restore


*Classification of hours 
gen time_of_day=2 if hour>=9 & hour<18
replace time_of_day=1 if hour>=6 & hour <=8
replace time_of_day=3 if hour>=18 & hour <= 22
replace time_of_day=4 if hour>22 | hour<6


*Work-location wise hourly working patterns
		preserve
		bysort hour alloc_off: gen tot_survey_per_hour=_N
		bysort alloc_off: gen tot_survey=_N
		
		cap drop prop
		gen prop=(tot_survey_per_hour/tot_survey)*100

		keep hour alloc_off prop

		sort alloc_off hour

		duplicates drop 

		twoway 	(scatter prop hour if alloc_off ==0, connect(l) xline(13, lwidth(38) lc(gs14)) xlabel(0(2)24)) ///
				(scatter prop hour if alloc_off ==1, connect(l) graphregion(fcolor(white))) , ///
				legend(order(1 "Home" 2 "Office" )) 
		restore


*Work-location wise day-wise working patterns
		preserve
		bysort day alloc_off: gen tot_survey_per_hour=_N
		bysort alloc_off: gen tot_survey=_N
		cap drop prop
		gen prop=(tot_survey_per_hour/tot_survey)*100

		keep day alloc_off prop

		sort alloc_off day

		duplicates drop 

		label values day day 

		twoway 	(scatter prop day if alloc_off ==0, connect(l) xline(3, lwidth(77) lc(gs14)) graphregion(fcolor(white)) xlabel( 1(1)7,valuelabel))  ///
				(scatter prop day if alloc_off ==1, connect(l) graphregion(fcolor(white))), ///
				legend(order(1 "Home" 2 "Office" )) 
		restore

*Proportion workdone during "working hours" which weekdays from 9 to 6 . 
	
gen working_hours=(hour>=9 & hour<=18 & day<=5)


		bysort working_hours recruitmentid_new: gen tot_survey_per_hour=_N
		bysort recruitmentid_new: gen tot_survey=_N

		gen prop_wrk_wh=(tot_survey_per_hour/tot_survey)*100
		replace prop_wrk_wh=100-prop_wrk_wh if working_hours==0
		
		cap drop tot_survey_per_hour tot_survey
		
hist prop_wrk_wh if user_n==1 , by(allocation) freq  xtitle("Proportion of work-done during office hours")


preserve

drop if alloc_off==1

*Regression on work pattern level
reg prop alloc_off pref_office ad_office ln_n_speed_cash w_demo_Married w_demo_Gender w_demo_Age if user_n==1 & wave>1
outreg2 using "$regdir\t31.tex", replace auto(2) ctitle(Wave 2 $+$)

reg prop alloc_off pref_office  ad_office ln_n_speed_cash w_demo_Married w_demo_Gender w_demo_Age if user_n==1 & wave==2
outreg2 using "$regdir\t31.tex", append auto(2) ctitle(Wave 2)

reg prop alloc_off pref_office  ad_office ln_n_speed_cash w_demo_Married w_demo_Gender w_demo_Age if user_n==1 & wave==3
outreg2 using "$regdir\t31.tex", append auto(2) ctitle(Wave 3)

reg prop alloc_off pref_office  ad_office ln_n_speed_cash w_demo_Married w_demo_Gender w_demo_Age if user_n==1 & wave==5
outreg2 using "$regdir\t31.tex", append auto(2) ctitle(Wave 3.5)

reg prop alloc_off pref_office  ad_office ln_n_speed_cash w_demo_Married w_demo_Gender w_demo_Age if user_n==1 & wave==6
outreg2 using "$regdir\t31.tex", append auto(2) ctitle(Wave 4)

restore

reg ln_n_speed_s i.hour if alloc_off==0
margins i.hour
marginsplot 


preserve
drop if (hour<9 | hour>18) & alloc_off==1
reg ln_n_speed_s i.hour#alloc_off 
margins hour#alloc_off
marginsplot, ci1opts(lp(blank )) ci2opts(lp(blank )) ylabel(3.6(.1)3.9)  legend(order(1 "Home" 2 "Office" )) 
restore

bysort recruitmentid_new startdate: egen variance_daily_speed = sd(ln_n_speed_s)


**Step 5*************
*Proportion of work done during working hours by ad and pref type

*Proportion of work done across ad type and preference 
reg prop_wrk_wh i.type1 i.wave  if user_n==1 & alloc_off==0
margins i.type1
marginsplot, scale(0.7) name(a2, replace) title("Proportion of workdone during office hours") ytitle("%") graphregion(color(white)) 

*Speed differences across ad type and preference 
reg ln_n_speed_s  i.type1#i.working_hours i.sec i.week i.wave  if  alloc_off==0
margins i.type1#i.working_hours
marginsplot, scale(0.7) name(a2, replace) title("Speed comparision") ytitle("") xtitle("Ad_type*Preference") graphregion(color(white)) legend(pos(5) ring(0) col(1))

*Variance in workdone every day 
bysort recruitmentid_new startdate: egen tot_time_day = total(totalperiodhhmmss)
replace tot_time_day = tot_time_day/3600

bysort recruitmentid_new startdate: gen day_n = _n

preserve 

drop if day_n!=1 

bysort recruitmentid_new: egen sd_daily_wrk_hr=sd(tot_time_day)

drop user_n

bysort recruitmentid_new: gen user_n=_n

reg sd_daily_wrk_hr i.type1 i.wave  if user_n==1 & alloc_off==0
margins i.type1
marginsplot, scale(0.7) name(a2, replace) title("Standard Deviation of daily work hours") ytitle("hours") graphregion(color(white)) 



restore 





















