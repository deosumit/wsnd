set mem 5g
set more off

global workdir "C:\Users\sumit\Documents\Work\Worker Sorting\My work"
global regdir "$workdir\tex files\regressions"


do "$workdir\cleaning.do"


*Allocation

global covars "i.week i.wave i.section"
global outreg_setting "noni addtext(Section+Week+Wave FE, Yes) auto(2)"

/*******************/
/*Allocation effect*/
/*******************/
	


{

reg ln_n_speed_s alloc_off $covars if w_demo_Gender==0 & wave>4 [pw=weight], cluster( person_week )
outreg2 using "$regdir\t1.tex", replace  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if w_demo_Gender==0 & wave>4 [pw=weight], cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_n_speed_s alloc_off $covars if w_demo_Gender==1 & wave>4 [pw=weight], cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if w_demo_Gender==1 & wave>4 [pw=weight], cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_n_speed_s alloc_off $covars if w_demo_Gender==1 & wave>4 & w_demo_Married==1 [pw=weight], cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if w_demo_Gender==1 & wave>4 & w_demo_Married ==1 [pw=weight], cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)


}



********************************



gen 	type=1 if ad_office==0 & pref_office==0 & alloc_off==0
replace type=2 if ad_office==0 & pref_office==0 & alloc_off==1
replace type=3 if ad_office==0 & pref_office==1 & alloc_off==0
replace type=4 if ad_office==0 & pref_office==1 & alloc_off==1
replace type=5 if pref_office==0 & alloc_off==0
replace type=6 if pref_office==0 & alloc_off==1
replace type=7 if pref_office==1 & alloc_off==0
replace type=8 if pref_office==1 & alloc_off==1

label define type 1 "HHH" 2 "HHO" 3 "HOH" 4 "HOO" 5 "OHH" 6 "OHO" 7 "OOH" 8 "OOO"
label val type type 



*Average Speed
		preserve
		bysort hour alloc_off pref_office ad_office : egen avg_speed=mean(ln_n_speed_s)

		keep hour alloc_off avg_speed pref_office ad_office section hard 

		sort alloc_off pref_office ad_office hour 

		duplicates drop 

		twoway 	(scatter avg_speed hour if alloc_off ==0 & pref_office==0 & ad_office==0, connect(l) xline(13, lwidth(38) lc(gs14)) xlabel(0(2)24) ylabel(3(0.5)4.5)) ///
				(scatter avg_speed hour if alloc_off ==0 & pref_office==1 & ad_office==0, connect(l) graphregion(fcolor(white))) ///
				(scatter avg_speed hour if alloc_off ==0 & pref_office==0 & ad_office==1, connect(l) graphregion(fcolor(white))) ///
				(scatter avg_speed hour if alloc_off ==0 & pref_office==1 & ad_office==1, connect(l) graphregion(fcolor(white))), ///
				legend(order(1 "HH" 2 "HO" 3 "OH" 4 "OO" )) 
		restore

		
		preserve
		bysort hour alloc_off pref_office ad_office : egen avg_speed=mean(ln_n_speed_s)

		keep hour alloc_off avg_speed pref_office ad_office

		sort alloc_off pref_office ad_office hour

		duplicates drop 

		twoway 	(scatter avg_speed hour if alloc_off ==1 & pref_office==0 & ad_office==0, connect(l) xline(13, lwidth(38) lc(gs14)) xlabel(0(2)24) ylabel(3(0.5)4.5)) ///
				(scatter avg_speed hour if alloc_off ==1 & pref_office==1 & ad_office==0, connect(l) graphregion(fcolor(white))) ///
				(scatter avg_speed hour if alloc_off ==1 & pref_office==0 & ad_office==1, connect(l) graphregion(fcolor(white))) ///
				(scatter avg_speed hour if alloc_off ==1 & pref_office==1 & ad_office==1, connect(l) graphregion(fcolor(white))), ///
				legend(order(1 "HH" 2 "HO" 3 "OH" 4 "OO" )) 
		restore
		
	    preserve
		bysort day alloc_off pref_office ad_office : egen avg_speed=mean(ln_n_speed_s)


		keep day alloc_off avg_speed pref_office ad_office 

		sort alloc_off pref_office ad_office  day

		duplicates drop 

		label values day day 

		twoway 	(scatter avg_speed day if alloc_off ==0 & pref_office==0 & ad_office==0, connect(l) xline(13, lwidth(38) lc(gs14)) xlabel(1(1)7) ylabel(3.5(0.25)4.25)) ///
				(scatter avg_speed day if alloc_off ==0 & pref_office==1 & ad_office==0, connect(l) graphregion(fcolor(white))) ///
				(scatter avg_speed day if alloc_off ==0 & pref_office==0 & ad_office==1, connect(l) graphregion(fcolor(white))) ///
				(scatter avg_speed day if alloc_off ==0 & pref_office==1 & ad_office==1, connect(l) graphregion(fcolor(white))), ///
				legend(order(1 "HH" 2 "HO" 3 "OH" 4 "OO" )) 
		restore
		

		preserve
		bysort day alloc_off pref_office ad_office : egen avg_speed=mean(ln_n_speed_s)


		keep day alloc_off avg_speed pref_office ad_office 

		sort alloc_off pref_office ad_office  day

		duplicates drop 

		label values day day 

		twoway 	(scatter avg_speed day if alloc_off ==1 & pref_office==0 & ad_office==0, connect(l) xline(13, lwidth(38) lc(gs14)) xlabel(1(1)7) ylabel(3.5(0.25)4.25)) ///
				(scatter avg_speed day if alloc_off ==1 & pref_office==1 & ad_office==0, connect(l) graphregion(fcolor(white))) ///
				(scatter avg_speed day if alloc_off ==1 & pref_office==0 & ad_office==1, connect(l) graphregion(fcolor(white))) ///
				(scatter avg_speed day if alloc_off ==1 & pref_office==1 & ad_office==1, connect(l) graphregion(fcolor(white))), ///
				legend(order(1 "HH" 2 "HO" 3 "OH" 4 "OO" )) 
		restore
		
		
*Workdone		
		preserve
		bysort hour alloc_off pref_office ad_office: gen tot_survey_per_hour=_N
		bysort alloc_off pref_office ad_office: gen tot_survey=_N
		
		cap drop prop
		gen prop=(tot_survey_per_hour/tot_survey)*100

		keep hour alloc_off prop pref_office ad_office

		sort alloc_off pref_office ad_office hour

		duplicates drop 

		twoway 	(scatter prop hour if alloc_off ==0 & pref_office==0 & ad_office==0, connect(l) xline(13, lwidth(38) lc(gs14)) xlabel(0(2)24)) ///
				(scatter prop hour if alloc_off ==0 & pref_office==1 & ad_office==0, connect(l) graphregion(fcolor(white))) ///
				(scatter prop hour if alloc_off ==0 & pref_office==0 & ad_office==1, connect(l) graphregion(fcolor(white))) ///
				(scatter prop hour if alloc_off ==0 & pref_office==1 & ad_office==1, connect(l) graphregion(fcolor(white))), ///
				legend(order(1 "HH" 2 "HO" 3 "OH" 4 "OO" )) 
		restore
		

		preserve
		bysort hour alloc_off pref_office ad_office: gen tot_survey_per_hour=_N
		bysort alloc_off pref_office ad_office: gen tot_survey=_N
		
		cap drop prop
		gen prop=(tot_survey_per_hour/tot_survey)*100

		keep hour alloc_off prop pref_office ad_office

		sort alloc_off pref_office ad_office hour

		duplicates drop 

		twoway 	(scatter prop hour if alloc_off ==1 & pref_office==0 & ad_office==0, connect(l) xline(13, lwidth(38) lc(gs14)) xlabel(0(2)24)) ///
				(scatter prop hour if alloc_off ==1 & pref_office==1 & ad_office==0, connect(l) graphregion(fcolor(white))) ///
				(scatter prop hour if alloc_off ==1 & pref_office==0 & ad_office==1, connect(l) graphregion(fcolor(white))) ///
				(scatter prop hour if alloc_off ==1 & pref_office==1 & ad_office==1, connect(l) graphregion(fcolor(white))), ///
				legend(order(1 "HH" 2 "HO" 3 "OH" 4 "OO" )) 
		restore
		
	   preserve
		bysort day alloc_off pref_office ad_office: gen tot_survey_per_hour=_N
		bysort alloc_off pref_office ad_office: gen tot_survey=_N
		
		cap drop prop
		gen prop=(tot_survey_per_hour/tot_survey)*100

		keep day alloc_off prop pref_office ad_office

		sort alloc_off pref_office ad_office day

		duplicates drop 

		label values day day 

		twoway 	(scatter prop day if alloc_off ==0 & pref_office==0 & ad_office==0, connect(l) xline(13, lwidth(38) lc(gs14)) xlabel(1(1)7)) ///
				(scatter prop day if alloc_off ==0 & pref_office==1 & ad_office==0, connect(l) graphregion(fcolor(white))) ///
				(scatter prop day if alloc_off ==0 & pref_office==0 & ad_office==1, connect(l) graphregion(fcolor(white))) ///
				(scatter prop day if alloc_off ==0 & pref_office==1 & ad_office==1, connect(l) graphregion(fcolor(white))), ///
				legend(order(1 "HH" 2 "HO" 3 "OH" 4 "OO" ))  
		restore

		preserve
		bysort day alloc_off pref_office ad_office: gen tot_survey_per_hour=_N
		bysort alloc_off pref_office ad_office: gen tot_survey=_N
		
		cap drop prop
		gen prop=(tot_survey_per_hour/tot_survey)*100

		keep day alloc_off prop pref_office ad_office

		sort alloc_off pref_office ad_office day

		duplicates drop 

		label values day day 

		twoway 	(scatter prop day if alloc_off ==1 & pref_office==0 & ad_office==0, connect(l) xline(13, lwidth(38) lc(gs14)) xlabel(1(1)7)) ///
				(scatter prop day if alloc_off ==1 & pref_office==1 & ad_office==0, connect(l) graphregion(fcolor(white))) ///
				(scatter prop day if alloc_off ==1 & pref_office==0 & ad_office==1, connect(l) graphregion(fcolor(white))) ///
				(scatter prop day if alloc_off ==1 & pref_office==1 & ad_office==1, connect(l) graphregion(fcolor(white))), ///
				legend(order(1 "HH" 2 "HO" 3 "OH" 4 "OO" ))  
		restore

		
*Latest requirement 
*Average Speed
		preserve
		
		expand 2 if w_demo_Gender==1 & w_demo_Married==1, gen(tag)
		
		replace w_demo_Gender=2 if tag==1
		
		bysort hour alloc_off w_demo_Gender : egen avg_speed=mean(ln_n_speed_s)

		keep hour alloc_off avg_speed w_demo_Gender

		sort alloc_off w_demo_Gender hour 

		duplicates drop 
		
		drop if avg_speed<3.4
		
		twoway 	(scatter avg_speed hour if alloc_off ==0 & w_demo_Gender==0, connect(l) lc(red) mfc(red) mlc(red) msiz(tiny) xline(13, lwidth(38) lc(gs14)) xlabel(0(2)24) ylabel(3.5 (0.2) 4.1)) ///
				(scatter avg_speed hour if alloc_off ==0 & w_demo_Gender==1, connect(l) lc(blue) mfc(blue) mlc(blue) msiz(tiny) graphregion(fcolor(white))) ///
				(scatter avg_speed hour if alloc_off ==0 & w_demo_Gender==2, connect(l) lc(green) mfc(green) mlc(green) msiz(tiny) graphregion(fcolor(white))) ///
				(scatter avg_speed hour if alloc_off ==1 & w_demo_Gender==0, connect(l) lc(red) mfc(red) msiz(tiny) mlc(red) lpattern(dash) graphregion(fcolor(white))) ///
				(scatter avg_speed hour if alloc_off ==1 & w_demo_Gender==1, connect(l) lc(blue) mfc(blue) msiz(tiny) mlc(blue) lpattern(dash) graphregion(fcolor(white))) ///
				(scatter avg_speed hour if alloc_off ==1 & w_demo_Gender==2, connect(l) lc(green) mfc(green) msiz(tiny) mlc(green) lpattern(dash) graphregion(fcolor(white))), ///
				legend(order(1 "Home-Men" 4 "Office-Men" 2 "Home-Women" 5 "Office-Women" 3 "Home-Married Women"   6 "Office-Married Women"  )) 
		restore
		
	

		
		
		
*Workdone		
		preserve
		
	    expand 2 if w_demo_Gender==1 & w_demo_Married==1, gen(tag)
		
		replace w_demo_Gender=2 if tag==1
		
		bysort hour alloc_off w_demo_Gender : gen tot_survey_per_hour=_N
		bysort alloc_off w_demo_Gender : gen tot_survey=_N
		
		cap drop prop
		gen prop=(tot_survey_per_hour/tot_survey)*100

		keep hour alloc_off prop w_demo_Gender

		sort alloc_off w_demo_Gender hour

		duplicates drop 

		twoway 	(scatter prop hour if alloc_off ==0 & w_demo_Gender==0, connect(l) lc(red) mfc(red) mlc(red) msiz(tiny) xline(13, lwidth(38) lc(gs14)) xlabel(0(2)24)) ///
				(scatter prop hour if alloc_off ==0 & w_demo_Gender==1, connect(l) lc(blue) mfc(blue) mlc(blue) msiz(tiny) graphregion(fcolor(white))) ///
				(scatter prop hour if alloc_off ==0 & w_demo_Gender==2, connect(l) lc(green) mfc(green) mlc(green) msiz(tiny) graphregion(fcolor(white))) ///
				(scatter prop hour if alloc_off ==1 & w_demo_Gender==0, connect(l) lc(red) mfc(red) msiz(tiny) mlc(red) lpattern(dash) graphregion(fcolor(white))) ///
				(scatter prop hour if alloc_off ==1 & w_demo_Gender==1, connect(l) lc(blue) mfc(blue) msiz(tiny) mlc(blue) lpattern(dash) graphregion(fcolor(white))) ///
				(scatter prop hour if alloc_off ==1 & w_demo_Gender==2, connect(l) lc(green) mfc(green) msiz(tiny) mlc(green) lpattern(dash) graphregion(fcolor(white))), ///
				legend(order(1 "Home-Men" 4 "Office-Men" 2 "Home-Women" 5 "Office-Women" 3 "Home-Married Women"   6 "Office-Married Women"  )) 
		restore
				
		
		
/*********************************/
/*Selection-coefficient over time*/
/*********************************/

bysort recruitmentid_new week: gen no_survey_week=_N
global outreg_setting "noni auto(2) keep(pref_office alloc_off  c.pref_office#c.alloc_off ln_n_speed_cash c.ln_n_speed_cash#c.pref_office)"


*First 4 surveys 
reg ln_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off   i.section  i.wave if  attempt_seq<17, cluster( person_week )
outreg2 using "$regdir\t2121.tex", replace  $outreg_setting ctitle(All waves)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off i.section   i.wave if wave==5 &  attempt_seq<17, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5)


reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off i.section   i.wave if wave==6 &  attempt_seq<17, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)


reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off   i.section  i.wave if wave>4 &  attempt_seq<17, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off ln_n_speed_cash c.ln_n_speed_cash#c.alloc_off  i.section  i.wave if  attempt_seq<17, cluster( person_week )
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(All waves)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off i.section ln_n_speed_cash c.ln_n_speed_cash#c.alloc_off  i.wave if wave==5 &  attempt_seq<17, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5)


reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off i.section ln_n_speed_cash c.ln_n_speed_cash#c.alloc_off  i.wave if wave==6 &  attempt_seq<17, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)


reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off ln_n_speed_cash c.ln_n_speed_cash#c.alloc_off  i.section  i.wave if wave>4 &  attempt_seq<17, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)



gen weight_fw=1/no_survey_week 
global outreg_setting "noni auto(2) keep(pref_office alloc_off  c.pref_office#c.alloc_off ln_n_speed_cash c.ln_n_speed_cash#c.pref_office)"


*First week- eqaully weighted DEO
reg ln_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.section  i.wave  [pw=weight_fw] if  week==1, cluster( person_week )
outreg2 using "$regdir\t2121.tex", replace  $outreg_setting ctitle(All waves)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off i.section  i.wave  [pw=weight_fw] if wave==5 &  week==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off i.section  i.wave  [pw=weight_fw] if wave==6 &  week==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off  i.section  i.wave  [pw=weight_fw] if wave>4 &  week==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off ln_n_speed_cash c.ln_n_speed_cash#c.alloc_off  i.section  i.wave  [pw=weight_fw] if  week==1, cluster( person_week )
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(All waves)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off ln_n_speed_cash c.ln_n_speed_cash#c.alloc_off i.section  i.wave  [pw=weight_fw] if wave==5 &  week==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off ln_n_speed_cash c.ln_n_speed_cash#c.alloc_off i.section  i.wave  [pw=weight_fw] if wave==6 &  week==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off ln_n_speed_cash c.ln_n_speed_cash#c.alloc_off  i.section  i.wave  [pw=weight_fw] if wave>4 &  week==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)


*All weeks- Equally weighted DEO
global outreg_setting "noni auto(2) keep(pref_office alloc_off  c.pref_office#c.alloc_off ln_n_speed_cash c.ln_n_speed_cash#c.pref_office)"

reg ln_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.section  i.wave i.week [pw=weight] , cluster( person_week )
outreg2 using "$regdir\t2121.tex", replace  $outreg_setting ctitle(All waves)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off i.section  i.wave i.week [pw=weight] if wave==5 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off i.section  i.wave i.week [pw=weight] if wave==6 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off  i.section  i.wave i.week [pw=weight] if wave>4 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off ln_n_speed_cash c.ln_n_speed_cash#c.pref_office i.section  i.wave i.week [pw=weight] , cluster( person_week )
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(All waves)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off ln_n_speed_cash c.ln_n_speed_cash#c.pref_office i.section  i.wave i.week [pw=weight] if wave==5 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off ln_n_speed_cash c.ln_n_speed_cash#c.pref_office i.section  i.wave i.week [pw=weight] if wave==6 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off ln_n_speed_cash c.ln_n_speed_cash#c.pref_office i.section  i.wave i.week [pw=weight] if wave>4 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)



*All weeks- Equally weighted DEO
global outreg_setting "noni auto(2) keep(pref_office alloc_off  c.pref_office#c.alloc_off ln_n_speed_cash c.ln_n_speed_cash#c.alloc_off)"

reg ln_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.section  i.wave i.week [pw=weight] , cluster( person_week )
outreg2 using "$regdir\t2121.tex", replace  $outreg_setting ctitle(All waves)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off  i.section  i.wave i.week [pw=weight] if wave>4 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off ln_n_speed_cash c.ln_n_speed_cash#c.alloc_off i.section  i.wave i.week [pw=weight] , cluster( person_week )
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(All waves)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off ln_n_speed_cash c.ln_n_speed_cash#c.alloc_off i.section  i.wave i.week [pw=weight] if wave>4 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)



global outreg_setting "noni auto(2) keep(pref_office alloc_off  c.pref_office#c.alloc_off ln_n_speed_cash c.ln_n_speed_cash#c.pref_office)"

*Selection on Treatment effects 
reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off  i.section  i.wave i.week [pw=weight] if wave>4 & w_demo_Gender==0, cluster(person_week)
outreg2 using "$regdir\t2122.tex", replace  $outreg_setting ctitle(Men)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off  i.section  i.wave i.week [pw=weight] if wave>4 & w_demo_Gender==1, cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Women)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off  i.section  i.wave i.week [pw=weight] if wave>4 & w_demo_Gender==1 & w_demo_Married==1 , cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Married Women)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off ln_n_speed_cash c.ln_n_speed_cash#c.pref_office i.section  i.wave i.week [pw=weight] if wave>4 & w_demo_Gender==0, cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Men)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off ln_n_speed_cash c.ln_n_speed_cash#c.pref_office i.section  i.wave i.week [pw=weight] if wave>4 & w_demo_Gender==1, cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Women)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off ln_n_speed_cash c.ln_n_speed_cash#c.pref_office i.section  i.wave i.week [pw=weight] if wave>4 & w_demo_Gender==1 & w_demo_Married==1, cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Married Women)


*selection on Ad type 
*All weeks- Equally weighted DEO

global outreg_setting "noni auto(2) keep(ad_office alloc_off  c.ad_office#c.alloc_off ln_n_speed_cash c.ln_n_speed_cash#c.ad_office)"

reg ln_n_speed_s  ad_office alloc_off  c.ad_office#c.alloc_off  i.section  i.wave i.week [pw=weight] , cluster( person_week )
outreg2 using "$regdir\t2123.tex", replace  $outreg_setting ctitle(All waves)

reg ln_n_speed_s  ad_office alloc_off c.ad_office#c.alloc_off i.section  i.wave i.week [pw=weight] if wave==5 , cluster(person_week)
outreg2 using "$regdir\t2123.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s  ad_office alloc_off c.ad_office#c.alloc_off i.section  i.wave i.week [pw=weight] if wave==6 , cluster(person_week)
outreg2 using "$regdir\t2123.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s  ad_office alloc_off c.ad_office#c.alloc_off  i.section  i.wave i.week [pw=weight] if wave>4 , cluster(person_week)
outreg2 using "$regdir\t2123.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_n_speed_s  ad_office alloc_off  c.ad_office#c.alloc_off ln_n_speed_cash c.ln_n_speed_cash#c.ad_office i.section  i.wave i.week [pw=weight] , cluster( person_week )
outreg2 using "$regdir\t2123.tex", append  $outreg_setting ctitle(All waves)

reg ln_n_speed_s  ad_office alloc_off c.ad_office#c.alloc_off ln_n_speed_cash c.ln_n_speed_cash#c.ad_office i.section  i.wave i.week [pw=weight] if wave==5 , cluster(person_week)
outreg2 using "$regdir\t2123.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s  ad_office alloc_off c.ad_office#c.alloc_off ln_n_speed_cash c.ln_n_speed_cash#c.ad_office i.section  i.wave i.week [pw=weight] if wave==6 , cluster(person_week)
outreg2 using "$regdir\t2123.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s  ad_office alloc_off c.ad_office#c.alloc_off ln_n_speed_cash c.ln_n_speed_cash#c.ad_office i.section  i.wave i.week [pw=weight] if wave>4 , cluster(person_week)
outreg2 using "$regdir\t2123.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)



*Selection effect table 
global opt "noobs nor2 noni nonot auto(2) nocon keep(pref_office ad_office c.pref_office#c.ad_office)"


*only men
preserve 

keep if w_demo_Gender==0

global i=1
foreach x of varlist ln_n_speed_cash ln_n_speed_plain ln_speed_60min incentive{

reg `x' pref_office  i.wave if  wave>1, cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", replace  ctitle(All waves) $opt

reg `x' pref_office  i.wave if  wave==5 , cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append ctitle(Wave 3.5) $opt

reg `x' pref_office  i.wave if  wave==6, cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(Wave 4) $opt

reg `x' pref_office  i.wave if  wave>4 , cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(Wave 3.5 \& 4) $opt


global i= $i + 1
}

{
reg comp_speed  pref_office  i.wave if user_n<4 & wave>1, cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", replace  ctitle(All waves) $opt

reg comp_speed pref_office  i.wave if user_n<4 & wave==5 , cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append ctitle(Wave 3.5) $opt

reg comp_speed pref_office  i.wave if user_n<4 & wave==6, cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append  ctitle(Wave 4) $opt

reg comp_speed pref_office  i.wave if user_n<4 & wave>4 , cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append  ctitle(Wave 3.5 \& 4) $opt


}


replace pref_office=Train_Pref

global i=1
foreach x of varlist ln_n_speed_cash ln_n_speed_plain ln_speed_60min incentive{

reg `x' pref_office  i.wave if  wave>1, cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(All waves) $opt

reg `x' pref_office  i.wave if  wave==5 , cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append ctitle(Wave 3.5) $opt

reg `x' pref_office  i.wave if  wave==6, cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(Wave 4) $opt

reg `x' pref_office  i.wave if  wave>4 , cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(Wave 3.5 \& 4) $opt


global i= $i + 1
}

{
reg comp_speed  pref_office  i.wave if user_n<4 & wave>1, cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append  ctitle(All waves) $opt

reg comp_speed pref_office  i.wave if user_n<4 & wave==5 , cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append ctitle(Wave 3.5) $opt

reg comp_speed pref_office  i.wave if user_n<4 & wave==6, cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append  ctitle(Wave 4) $opt

reg comp_speed pref_office  i.wave if user_n<4 & wave>4 , cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append  ctitle(Wave 3.5 \& 4) $opt

}

restore 



