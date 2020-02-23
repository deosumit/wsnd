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

encode recruitmentid_new, gen(id)

preserve

keep if id<200 & id>160

hist hour if id==229 & day==4, freq by(week)

restore


*Classification of hours 
gen time_of_day=2 if hour>=9 & hour<=19
replace time_of_day=1 if hour>=6 & hour <=8
replace time_of_day=3 if hour>=18 & hour <= 22
replace time_of_day=4 if hour>=22 | hour<=6


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

		gen prop=(tot_survey_per_hour/tot_survey)*100
		replace prop=100-prop if working_hours==0
		
		cap drop tot_survey_per_hour tot_survey
		
hist prop if user_n==1 , by(allocation) freq  xtitle("Proportion of work-done during office hours")


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

bysort recruitmentid_new startdate: variance_daily_speed = sd(ln_n_speed_s)
