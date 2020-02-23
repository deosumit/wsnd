set mem 5g
set more off

global workdir "C:/Users/sumit/Documents/Work/Worker Sorting/My work"
global regdir "$workdir/tex files/regressions"

do "$workdir/cleaning.do"




 
 
 estpost ttest w_demo_Age w_demo_Married w_demo_ChildrenNum w_edu_HighestEducation apt_total w60_min_netspeed w_wrkex_PreviousWorkExYear w_wrkex_NumOfJobsDoneBefore if user_n==1 & wave>1 , by (w_demo_Gender )
 estpost ttest w_demo_Age w_demo_Married w_demo_ChildrenNum w_edu_HighestEducation apt_total w60_min_netspeed w_wrkex_PreviousWorkExYear w_wrkex_NumOfJobsDoneBefore if user_n==1 & wave>4 , by (w_demo_Gender )
 estpost ttest w_demo_Age w_demo_Married w_demo_ChildrenNum w_edu_HighestEducation apt_total w60_min_netspeed w_wrkex_PreviousWorkExYear w_wrkex_NumOfJobsDoneBefore if user_n==1 & wave==5 , by (w_demo_Gender)
 estpost ttest w_demo_Age w_demo_Married w_demo_ChildrenNum w_edu_HighestEducation apt_total w60_min_netspeed w_wrkex_PreviousWorkExYear w_wrkex_NumOfJobsDoneBefore if user_n==1 & wave==6 , by (w_demo_Gender)
 
  
 
 estpost ttest w_edu_years if user_n==1 & wave>1 , by (w_demo_Gender )
 estpost ttest w_edu_years if user_n==1 & wave>4 , by (w_demo_Gender )
 estpost ttest w_edu_years if user_n==1 & wave==5 , by (w_demo_Gender)
 estpost ttest w_edu_years if user_n==1 & wave==6 , by (w_demo_Gender)
 
tab ad_type W_walkpref   if user_n==1
tab ad_type Train_Pref    if user_n==1
tab W_walkpref  Train_Pref if user_n==1 & ad_type=="Home"
tab W_walkpref  Train_Pref if user_n==1 & ad_type=="Office"


*Work-location wise hourly working patterns
		preserve
		bysort hour alloc_off: egen avg_speed=mean(ln_n_speed_s) 

		
		keep hour alloc_off avg_speed wave

		sort alloc_off hour 

		duplicates drop 
		drop if wave<4

		twoway 	(scatter avg_speed hour if alloc_off ==0, connect(l) xline(13, lwidth(38) lc(gs14)) xlabel(0(2)24)) ///
				(scatter avg_speed hour if alloc_off ==1, connect(l) graphregion(fcolor(white))) , ///
				legend(order(1 "Home" 2 "Office" )) 
		restore
		
		
		preserve
		bysort day alloc_off: egen avg_speed=mean(ln_n_speed_s) 

		
		keep day alloc_off avg_speed wave

		sort alloc_off day

		duplicates drop 
        drop if wave<4
		label values day day 

		twoway 	(scatter avg_speed day if alloc_off ==0, connect(l) xline(3, lwidth(77) lc(gs14)) graphregion(fcolor(white)) xlabel( 1(1)7,valuelabel))  ///
				(scatter avg_speed day if alloc_off ==1, connect(l) graphregion(fcolor(white))), ///
				legend(order(1 "Home" 2 "Office" )) 
		restore

		
*Gender-wise work pattern
*Average Speed
		preserve
		bysort hour alloc_off w_demo_Gender: egen avg_speed=mean(ln_n_speed_s)

		keep hour alloc_off avg_speed w_demo_Gender wave

		sort alloc_off w_demo_Gender hour 

		duplicates drop 
        drop if wave<4
		twoway 	(scatter avg_speed hour if alloc_off ==0 & w_demo_Gender==0, connect(l) xline(13, lwidth(38) lc(gs14)) xlabel(0(2)24)) ///
				(scatter avg_speed hour if alloc_off ==1 & w_demo_Gender==0, connect(l) graphregion(fcolor(white))) ///
				(scatter avg_speed hour if alloc_off ==0 & w_demo_Gender==1, connect(l) graphregion(fcolor(white))) ///
				(scatter avg_speed hour if alloc_off ==1 & w_demo_Gender==1, connect(l) graphregion(fcolor(white))), ///
				legend(order(1 "Home-Men" 2 "Office-Men" 3 "Home-Women" 4 "Office-Women" )) 
		restore
		
		
	    preserve
		bysort day alloc_off w_demo_Gender: egen avg_speed=mean(ln_n_speed_s)


		keep day alloc_off avg_speed w_demo_Gender wave

		sort alloc_off w_demo_Gender day 

		duplicates drop 
        drop if wave<4
		label values day day 

		twoway 	(scatter avg_speed day if alloc_off ==0 & w_demo_Gender==0, connect(l) xline(13, lwidth(38) lc(gs14)) xlabel(1(1)7)) ///
				(scatter avg_speed day if alloc_off ==1 & w_demo_Gender==0, connect(l) graphregion(fcolor(white))) ///
				(scatter avg_speed day if alloc_off ==0 & w_demo_Gender==1, connect(l) graphregion(fcolor(white))) ///
				(scatter avg_speed day if alloc_off ==1 & w_demo_Gender==1, connect(l) graphregion(fcolor(white))), ///
				legend(order(1 "Home-Men" 2 "Office-Men" 3 "Home-Women" 4 "Office-Women" )) 
		restore
		
		
*Workdone		
		preserve
		bysort hour alloc_off w_demo_Gender: gen tot_survey_per_hour=_N
		bysort alloc_off w_demo_Gender: gen tot_survey=_N
		
		cap drop prop
		gen prop=(tot_survey_per_hour/tot_survey)*100

		keep hour alloc_off prop w_demo_Gender wave

		sort alloc_off w_demo_Gender hour
		drop if wave<4
		duplicates drop 

		twoway 	(scatter prop hour if alloc_off ==0 & w_demo_Gender==0, connect(l) xline(13, lwidth(38) lc(gs14)) xlabel(0(2)24)) ///
				(scatter prop hour if alloc_off ==1 & w_demo_Gender==0, connect(l) graphregion(fcolor(white))) ///
				(scatter prop hour if alloc_off ==0 & w_demo_Gender==1, connect(l) graphregion(fcolor(white))) ///
				(scatter prop hour if alloc_off ==1 & w_demo_Gender==1, connect(l) graphregion(fcolor(white))), ///
				legend(order(1 "Home-Men" 2 "Office-Men" 3 "Home-Women" 4 "Office-Women" )) 
		restore
		
		
	    preserve
		bysort day alloc_off w_demo_Gender: gen tot_survey_per_hour=_N
		bysort alloc_off w_demo_Gender: gen tot_survey=_N
		cap drop prop
		gen prop=(tot_survey_per_hour/tot_survey)*100

		keep day alloc_off prop w_demo_Gender wave

		sort alloc_off w_demo_Gender day

		duplicates drop 
		drop if wave<4
		
		label values day day 

		twoway 	(scatter prop day if alloc_off ==0 & w_demo_Gender==0, connect(l) xline(13, lwidth(38) lc(gs14)) xlabel(1(1)7)) ///
				(scatter prop day if alloc_off ==1 & w_demo_Gender==0, connect(l) graphregion(fcolor(white))) ///
				(scatter prop day if alloc_off ==0 & w_demo_Gender==1, connect(l) graphregion(fcolor(white))) ///
				(scatter prop day if alloc_off ==1 & w_demo_Gender==1, connect(l) graphregion(fcolor(white))), ///
				legend(order(1 "Home-Men" 2 "Office-Men" 3 "Home-Women" 4 "Office-Women" )) 
		restore

		
*Preference and allocaiton wise work pattern
*Average Speed
		preserve
		bysort hour alloc_off pref_office : egen avg_speed=mean(ln_n_speed_s)

		keep hour alloc_off avg_speed pref_office wave

		sort alloc_off pref_office  hour

		duplicates drop 
		
		drop if wave<4

		twoway 	(scatter avg_speed hour if alloc_off ==0 & pref_office ==0, connect(l) xline(13, lwidth(38) lc(gs14)) xlabel(0(2)24)) ///
				(scatter avg_speed hour if alloc_off ==1 & pref_office ==0, connect(l) graphregion(fcolor(white))) ///
				(scatter avg_speed hour if alloc_off ==0 & pref_office ==1, connect(l) graphregion(fcolor(white))) ///
				(scatter avg_speed hour if alloc_off ==1 & pref_office ==1, connect(l) graphregion(fcolor(white))), ///
				legend(order(1 "HH" 2 "HO" 3 "OH" 4 "OO" )) 
		restore
		
		
	    preserve
		bysort day alloc_off pref_office: egen avg_speed=mean(ln_n_speed_s)


		keep day alloc_off avg_speed pref_office wave

		sort alloc_off pref_office day

		duplicates drop 
		drop if wave<4
		label values day day 

		twoway 	(scatter avg_speed day if alloc_off ==0 & pref_office==0, connect(l)  xline(3, lwidth(77) lc(gs14)) xlabel(1(1)7)) ///
				(scatter avg_speed day if alloc_off ==1 & pref_office==0, connect(l) graphregion(fcolor(white))) ///
				(scatter avg_speed day if alloc_off ==0 & pref_office==1, connect(l) graphregion(fcolor(white))) ///
				(scatter avg_speed day if alloc_off ==1 & pref_office==1, connect(l) graphregion(fcolor(white))), ///
				legend(order(1 "HH" 2 "HO" 3 "OH" 4 "OO" )) 
		restore
		
		
*Workdone		
		preserve
		bysort hour alloc_off pref_office: gen tot_survey_per_hour=_N
		bysort alloc_off pref_office: gen tot_survey=_N
		
		cap drop prop
		gen prop=(tot_survey_per_hour/tot_survey)*100

		keep hour alloc_off prop pref_office wave

		sort alloc_off pref_office hour

		duplicates drop 
		drop if wave<4
		
		twoway 	(scatter prop hour if alloc_off ==0 & pref_office==0, connect(l) xline(13, lwidth(38) lc(gs14)) xlabel(0(2)24)) ///
				(scatter prop hour if alloc_off ==1 & pref_office==0, connect(l) graphregion(fcolor(white))) ///
				(scatter prop hour if alloc_off ==0 & pref_office==1, connect(l) graphregion(fcolor(white))) ///
				(scatter prop hour if alloc_off ==1 & pref_office==1, connect(l) graphregion(fcolor(white))), ///
				legend(order(1 "HH" 2 "HO" 3 "OH" 4 "OO" ))  
		restore
		
		
	    preserve
		bysort day alloc_off pref_office: gen tot_survey_per_hour=_N
		bysort alloc_off pref_office: gen tot_survey=_N
		cap drop prop
		gen prop=(tot_survey_per_hour/tot_survey)*100

		keep day alloc_off prop pref_office wave

		sort alloc_off pref_office day

		duplicates drop 
		drop if wave<4
		
		label values day day 

		twoway 	(scatter prop day if alloc_off ==0 & pref_office==0, connect(l)  xline(3, lwidth(77) lc(gs14)) xlabel(1(1)7)) ///
				(scatter prop day if alloc_off ==1 & pref_office==0, connect(l) graphregion(fcolor(white))) ///
				(scatter prop day if alloc_off ==0 & pref_office==1, connect(l) graphregion(fcolor(white))) ///
				(scatter prop day if alloc_off ==1 & pref_office==1, connect(l) graphregion(fcolor(white))), ///
				legend(order(1 "HH" 2 "HO" 3 "OH" 4 "OO" ))   
		restore
		
		
		
*Preference_allocaiton_gender wise work pattern
*Average Speed
		preserve
		bysort hour alloc_off pref_office w_demo_Gender : egen avg_speed=mean(ln_n_speed_s)

		keep hour alloc_off avg_speed pref_office w_demo_Gender wave

		sort alloc_off pref_office w_demo_Gender hour

		duplicates drop 
		
		drop if wave<4

// 		twoway 	(scatter avg_speed hour if alloc_off ==0 & pref_office ==0 & w_demo_Gender==0, connect(l) xline(13, lwidth(38) lc(gs14)) xlabel(0(2)24))  ///
// 				(scatter avg_speed hour if alloc_off ==1 & pref_office ==0 & w_demo_Gender==0, connect(l) graphregion(fcolor(white))) ///
// 				(scatter avg_speed hour if alloc_off ==0 & pref_office ==1 & w_demo_Gender==0, connect(l) graphregion(fcolor(white))) ///
// 				(scatter avg_speed hour if alloc_off ==1 & pref_office ==1 & w_demo_Gender==0, connect(l) graphregion(fcolor(white))), ///
// 				legend(order(1 "HH" 2 "HO" 3 "OH" 4 "OO" )) title("Men")
//				
 		twoway 	(scatter avg_speed hour if alloc_off ==0 & pref_office ==0 & w_demo_Gender==1, connect(l) xline(13, lwidth(38) lc(gs14)) xlabel(0(2)24))  ///
				(scatter avg_speed hour if alloc_off ==1 & pref_office ==0 & w_demo_Gender==1, connect(l) graphregion(fcolor(white))) ///
 				(scatter avg_speed hour if alloc_off ==0 & pref_office ==1 & w_demo_Gender==1, connect(l) graphregion(fcolor(white))) ///
 				(scatter avg_speed hour if alloc_off ==1 & pref_office ==1 & w_demo_Gender==1, connect(l) graphregion(fcolor(white))), ///
 				legend(order(1 "HH" 2 "HO" 3 "OH" 4 "OO" )) title("Women")
				
// 		gr combine m12.gph f12.gph
		restore
		
		
	    preserve
		bysort day alloc_off pref_office w_demo_Gender: egen avg_speed=mean(ln_n_speed_s)


		keep day alloc_off avg_speed pref_office w_demo_Gender wave

		sort alloc_off pref_office w_demo_Gender day

		duplicates drop 
		drop if wave<4
		label values day day 
		
// 		twoway 	(scatter avg_speed day if alloc_off ==0 & pref_office ==0 & w_demo_Gender==0, connect(l) xline(3, lwidth(77) lc(gs14)) xlabel(1(1)7))  ///
// 				(scatter avg_speed day if alloc_off ==1 & pref_office ==0 & w_demo_Gender==0, connect(l) graphregion(fcolor(white))) ///
// 				(scatter avg_speed day if alloc_off ==0 & pref_office ==1 & w_demo_Gender==0, connect(l) graphregion(fcolor(white))) ///
// 				(scatter avg_speed day if alloc_off ==1 & pref_office ==1 & w_demo_Gender==0, connect(l) graphregion(fcolor(white))), ///
// 				legend(order(1 "HH" 2 "HO" 3 "OH" 4 "OO" ))  saving(m1, replace) title("Men")
				
 		twoway 	(scatter avg_speed day if alloc_off ==0 & pref_office ==0 & w_demo_Gender==1, connect(l) xline(3, lwidth(77) lc(gs14)) xlabel(1(1)7))  ///
 				(scatter avg_speed day if alloc_off ==1 & pref_office ==0 & w_demo_Gender==1, connect(l) graphregion(fcolor(white))) ///
 				(scatter avg_speed day if alloc_off ==0 & pref_office ==1 & w_demo_Gender==1, connect(l) graphregion(fcolor(white))) ///
 				(scatter avg_speed day if alloc_off ==1 & pref_office ==1 & w_demo_Gender==1, connect(l) graphregion(fcolor(white))), ///
 				legend(order(1 "HH" 2 "HO" 3 "OH" 4 "OO" ))  saving(f1, replace) title("Women")
				
// 		gr combine m1.gph f1.gph
		restore


		
		
*Workdone		
		preserve
		bysort hour alloc_off pref_office w_demo_Gender: gen tot_survey_per_hour=_N
		bysort alloc_off pref_office w_demo_Gender: gen tot_survey=_N
		
		cap drop prop
		gen prop=(tot_survey_per_hour/tot_survey)*100

		keep hour alloc_off prop pref_office wave w_demo_Gender

		sort alloc_off pref_office w_demo_Gender hour

		duplicates drop 
		drop if wave<4
		
		twoway 	(scatter prop hour if alloc_off ==0 & pref_office ==0 & w_demo_Gender==0, connect(l) xline(13, lwidth(38) lc(gs14)) xlabel(0(2)24)) ///
				(scatter prop hour if alloc_off ==1 & pref_office ==0 & w_demo_Gender==0, connect(l) graphregion(fcolor(white))) ///
				(scatter prop hour if alloc_off ==0 & pref_office ==1 & w_demo_Gender==0, connect(l) graphregion(fcolor(white))) ///
				(scatter prop hour if alloc_off ==1 & pref_office ==1 & w_demo_Gender==0, connect(l) graphregion(fcolor(white))) ///
				(scatter prop hour if alloc_off ==0 & pref_office ==0 & w_demo_Gender==1, connect(l) graphregion(fcolor(white))) ///
				(scatter prop hour if alloc_off ==1 & pref_office ==0 & w_demo_Gender==1, connect(l) graphregion(fcolor(white))) ///
				(scatter prop hour if alloc_off ==0 & pref_office ==1 & w_demo_Gender==1, connect(l) graphregion(fcolor(white))) ///
				(scatter prop hour if alloc_off ==1 & pref_office ==1 & w_demo_Gender==1, connect(l) graphregion(fcolor(white))), ///
				legend(order(1 "HH-M" 2 "HO-M" 3 "OH-M" 4 "OO-M" 5 "HH-W" 6 "HO-W" 7 "OH-W" 8 "OO-W" )) 
		restore
		
		
	    preserve
		bysort day alloc_off pref_office w_demo_Gender: gen tot_survey_per_hour=_N
		bysort alloc_off pref_office w_demo_Gender: gen tot_survey=_N
		cap drop prop
		gen prop=(tot_survey_per_hour/tot_survey)*100

		keep day alloc_off prop pref_office wave w_demo_Gender

		sort alloc_off pref_office day w_demo_Gender

		duplicates drop 
		drop if wave<4
		
		label values day day 

		twoway 	(scatter prop day if alloc_off ==0 & pref_office==0 & w_demo_Gender==0, connect(l)  xline(3, lwidth(77) lc(gs14)) xlabel(1(1)7)) ///
				(scatter prop day if alloc_off ==1 & pref_office==0 & w_demo_Gender==0, connect(l) graphregion(fcolor(white))) ///
				(scatter prop day if alloc_off ==0 & pref_office==1 & w_demo_Gender==0, connect(l) graphregion(fcolor(white))) ///
				(scatter prop day if alloc_off ==1 & pref_office==1 & w_demo_Gender==0, connect(l) graphregion(fcolor(white))) ///
				(scatter prop day if alloc_off ==0 & pref_office ==0 & w_demo_Gender==1, connect(l) graphregion(fcolor(white))) ///
				(scatter prop day if alloc_off ==1 & pref_office ==0 & w_demo_Gender==1, connect(l) graphregion(fcolor(white))) ///
				(scatter prop day if alloc_off ==0 & pref_office ==1 & w_demo_Gender==1, connect(l) graphregion(fcolor(white))) ///
				(scatter prop day if alloc_off ==1 & pref_office ==1 & w_demo_Gender==1, connect(l) graphregion(fcolor(white))), ///
				legend(order(1 "HH-M" 2 "HO-M" 3 "OH-M" 4 "OO-M" 5 "HH-W" 6 "HO-W" 7 "OH-W" 8 "OO-W" )) 
		restore

******accuracy

*Preference_allocaiton_gender wise work pattern
*Average Speed
		preserve
		bysort hour alloc_off pref_office w_demo_Gender : egen avg_accuracy=mean(accuracy )

		keep hour alloc_off avg_accuracy pref_office w_demo_Gender wave

		sort alloc_off pref_office w_demo_Gender hour

		duplicates drop 
		
		drop if wave<4

 /*		twoway 	(scatter avg_accuracy hour if alloc_off ==0 & pref_office ==0 & w_demo_Gender==0, connect(l) xline(13, lwidth(38) lc(gs14)) xlabel(0(2)24))  ///
 				(scatter avg_accuracy hour if alloc_off ==1 & pref_office ==0 & w_demo_Gender==0, connect(l) graphregion(fcolor(white))) ///
 				(scatter avg_accuracy hour if alloc_off ==0 & pref_office ==1 & w_demo_Gender==0, connect(l) graphregion(fcolor(white))) ///
 				(scatter avg_accuracy hour if alloc_off ==1 & pref_office ==1 & w_demo_Gender==0, connect(l) graphregion(fcolor(white))), ///
 				legend(order(1 "HH" 2 "HO" 3 "OH" 4 "OO" )) title("Men")
*/				
		twoway 	(scatter avg_accuracy hour if alloc_off ==0 & pref_office ==0 & w_demo_Gender==1, connect(l) xline(13, lwidth(38) lc(gs14)) xlabel(0(2)24))  ///
				(scatter avg_accuracy hour if alloc_off ==1 & pref_office ==0 & w_demo_Gender==1, connect(l) graphregion(fcolor(white))) ///
 				(scatter avg_accuracy hour if alloc_off ==0 & pref_office ==1 & w_demo_Gender==1, connect(l) graphregion(fcolor(white))) ///
 				(scatter avg_accuracy hour if alloc_off ==1 & pref_office ==1 & w_demo_Gender==1, connect(l) graphregion(fcolor(white))), ///
 				legend(order(1 "HH" 2 "HO" 3 "OH" 4 "OO" )) title("Women")
				
// 		gr combine m12.gph f12.gph
		restore
		
		
	    preserve
		bysort day alloc_off pref_office w_demo_Gender: egen avg_accuracy=mean(accuracy)


		keep day alloc_off avg_accuracy pref_office w_demo_Gender wave

		sort alloc_off pref_office w_demo_Gender day

		duplicates drop 
		drop if wave<4
		label values day day 
		
 		twoway 	(scatter avg_accuracy day if alloc_off ==0 & pref_office ==0 & w_demo_Gender==0, connect(l) xline(3, lwidth(77) lc(gs14)) xlabel(1(1)7))  ///
 				(scatter avg_accuracy day if alloc_off ==1 & pref_office ==0 & w_demo_Gender==0, connect(l) graphregion(fcolor(white))) ///
 				(scatter avg_accuracy day if alloc_off ==0 & pref_office ==1 & w_demo_Gender==0, connect(l) graphregion(fcolor(white))) ///
 				(scatter avg_accuracy day if alloc_off ==1 & pref_office ==1 & w_demo_Gender==0, connect(l) graphregion(fcolor(white))), ///
 				legend(order(1 "HH" 2 "HO" 3 "OH" 4 "OO" ))   title("Men")
				
 /*		twoway 	(scatter avg_accuracy day if alloc_off ==0 & pref_office ==0 & w_demo_Gender==1, connect(l) xline(3, lwidth(77) lc(gs14)) xlabel(1(1)7))  ///
 				(scatter avg_accuracy day if alloc_off ==1 & pref_office ==0 & w_demo_Gender==1, connect(l) graphregion(fcolor(white))) ///
 				(scatter avg_accuracy day if alloc_off ==0 & pref_office ==1 & w_demo_Gender==1, connect(l) graphregion(fcolor(white))) ///
 				(scatter avg_accuracy day if alloc_off ==1 & pref_office ==1 & w_demo_Gender==1, connect(l) graphregion(fcolor(white))), ///
 				legend(order(1 "HH" 2 "HO" 3 "OH" 4 "OO" ))  saving(f1, replace) title("Women")
*/				
// 		gr combine m1.gph f1.gph
		restore
