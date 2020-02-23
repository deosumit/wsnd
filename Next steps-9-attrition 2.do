set mem 5g
set more off

global workdir "C:\Users\sumit\Documents\Work\Worker Sorting\My work"
global regdir "$workdir\tex files\regressions"

do "$workdir\cleaning.do"
			
			
/**************************/
/*Baseline Characteristics*/
/**************************/
*Antoinette: Could you please make a balance table to show that based on observable characteristics our 4 treatment groups were truly randomized.

/* Following lines of code was copied from randomization file
local x W_gender W_place W_speed W_edu W_edu_yrs W_edu_12th W_edu_grad W_edu_master W_laptop W_typing W_workex W_workex_dur W_emp W_unemp_dur W_tryingjob W_tryingjob_dur W_DEworkex W_DEworkex_dur W_C6Howmanyhourswouldyoulik W_C7Howmanyhourswouldyoulik W_married W_C131Ifsohowmanychildren

W_speed

estpost ttest `x', by(home)
*/ 


preserve

keep if user_n==1

local demo w_demo_Gender w_demo_Age w_demo_Married w_demo_ChildrenNum w_demo_distance w_demo_withinchennai
local edu w_edu_years  w_edu_LaptopDesktopUsed w_edu_TypingCourseCompleted w_edu_typing_certificate
local wrkex w_wrkex_PreviousWorkExYear w_wrkex_NumOfJobsDoneBefore w_empstat_Unemployment_duration 
local speed w60_min_netspeed cash_net_speed plain_net_speed 


estpost ttest `speed' `demo' `edu' `wrkex' if W_walkpref==0 & wave>3, by(allocation)

estpost ttest `speed' `demo' `edu' `wrkex' if W_walkpref==1 & wave>3, by(allocation)

restore 


/**************************/
/*Attrition variable*/
/**************************/
bysort recruitmentid_new: egen firstsurvey_time=min(startdatetime )
bysort recruitmentid_new: egen lastsurvey_time=max(startdatetime )


format firstsurvey_time %tc
format lastsurvey_time %tc

gen firstsurvey_day= dofc(firstsurvey_time)
gen lastsurvey_day=dofc(lastsurvey_time)

format firstsurvey_day %td
format lastsurvey_day %td

gen int daysworked= lastsurvey_day - firstsurvey_day + 1
replace daysworked=daysworked - 14 if Add=="B3" & daysworked>49


preserve
keep if user_n==1
gen pref_all=1 if alloc_off==0 & pref_office==0
replace pref_all=2 if alloc_off==1 & pref_office==0
replace pref_all=3 if alloc_off==0 & pref_office==1
replace pref_all=4 if alloc_off==1 & pref_office==1

replace wave3plus=1 if wave>4

bysort pref_all	wave3plus: gen deos_pre3_group=_N


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


gen ln_daysworked = ln(daysworked)

global outreg_setting "noni auto(2) addtext(Wave FE, Yes)"


************************************************************************************************************

reg ln_daysworked ad_office pref_office alloc_off i.wave if wave>3,  cluster( wave )
outreg2 using "$regdir\t1.tex", replace  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_daysworked ad_office pref_office alloc_off i.wave if wave==5
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_daysworked ad_office pref_office alloc_off i.wave if wave==6
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_daysworked ad_office i.wave if wave>3,  cluster( wave )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_daysworked ad_office i.wave if wave==5
outreg2 using "$regdir\t1.tex", append  $outreg_setting  ctitle(Wave 3.5)

reg ln_daysworked ad_office i.wave if wave==6
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_daysworked pref_office i.wave if wave>3,  cluster( wave )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_daysworked pref_office i.wave if wave==5
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_daysworked pref_office i.wave if wave==6
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_daysworked alloc_off i.wave if wave>3,  cluster( wave )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_daysworked alloc_off i.wave if wave==5
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_daysworked alloc_off i.wave if wave==6
outreg2 using "$regdir\t1.tex", append  $outreg_setting  ctitle(Wave 4)



gen one_week=(daysworked>3)


reg one_week ad_office pref_office alloc_off i.wave if wave>3,  cluster( wave )
outreg2 using "$regdir\t1.tex", replace  $outreg_setting ctitle(Wave 3.5 \& 4)

reg one_week ad_office pref_office alloc_off i.wave if wave==5
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5)

reg one_week ad_office pref_office alloc_off i.wave if wave==6
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4)

reg one_week ad_office i.wave if wave>3,  cluster( wave )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg one_week ad_office i.wave if wave==5
outreg2 using "$regdir\t1.tex", append  $outreg_setting  ctitle(Wave 3.5)

reg one_week ad_office i.wave if wave==6
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4)

reg one_week pref_office i.wave if wave>3,  cluster( wave )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg one_week pref_office i.wave if wave==5
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5)

reg one_week pref_office i.wave if wave==6
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4)

reg one_week alloc_off i.wave if wave>3,  cluster( wave )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg one_week alloc_off i.wave if wave==5
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5)

reg one_week alloc_off i.wave if wave==6
outreg2 using "$regdir\t1.tex", append  $outreg_setting  ctitle(Wave 4)


gen daysworked_1st3weeks= daysworked if daysworked<21
replace daysworked_1st3weeks= 21 if daysworked>20

gen ln_daysworked_1st3weeks=ln(daysworked_1st3weeks)

reg ln_daysworked_1st3weeks ad_office pref_office alloc_off i.wave if wave>3,  cluster( wave )
outreg2 using "$regdir\t1.tex", replace  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_daysworked_1st3weeks ad_office pref_office alloc_off i.wave if wave==5
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_daysworked_1st3weeks ad_office pref_office alloc_off i.wave if wave==6
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_daysworked_1st3weeks ad_office i.wave if wave>3,  cluster( wave )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_daysworked_1st3weeks ad_office i.wave if wave==5
outreg2 using "$regdir\t1.tex", append  $outreg_setting  ctitle(Wave 3.5)

reg ln_daysworked_1st3weeks ad_office i.wave if wave==6
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_daysworked_1st3weeks pref_office i.wave if wave>3,  cluster( wave )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_daysworked_1st3weeks pref_office i.wave if wave==5
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_daysworked_1st3weeks pref_office i.wave if wave==6
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_daysworked_1st3weeks alloc_off i.wave if wave>3,  cluster( wave )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_daysworked_1st3weeks alloc_off i.wave if wave==5
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_daysworked_1st3weeks alloc_off i.wave if wave==6
outreg2 using "$regdir\t1.tex", append  $outreg_setting  ctitle(Wave 4)

***********************************************************
* sample of 235
preserve

keep if _merge==3

reg ln_daysworked ad_office pref_office alloc_off i.wave if wave>3,  cluster( wave )
outreg2 using "$regdir\t1.tex", replace  $outreg_setting ctitle(Wave 3.5 \& 4)


reg ln_daysworked ad_office i.wave if wave>3,  cluster( wave )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)


reg ln_daysworked pref_office i.wave if wave>3,  cluster( wave )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)


reg ln_daysworked alloc_off i.wave if wave>3,  cluster( wave )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)



restore 

preserve

keep if _merge==3

reg one_week ad_office pref_office alloc_off i.wave if wave>3,  cluster( wave )
outreg2 using "$regdir\t1.tex", replace  $outreg_setting ctitle(Wave 3.5 \& 4)

reg one_week ad_office i.wave if wave>3,  cluster( wave )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg one_week pref_office i.wave if wave>3,  cluster( wave )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg one_week alloc_off i.wave if wave>3,  cluster( wave )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)



restore 

preserve

keep if _merge==3

reg ln_daysworked_1st3weeks ad_office pref_office alloc_off i.wave if wave>3,  cluster( wave )
outreg2 using "$regdir\t1.tex", replace  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_daysworked_1st3weeks ad_office i.wave if wave>3,  cluster( wave )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_daysworked_1st3weeks pref_office i.wave if wave>3,  cluster( wave )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_daysworked_1st3weeks alloc_off i.wave if wave>3,  cluster( wave )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

restore 

***********************************************************




reg ln_daysworked pref_office alloc_off c.pref_office#c.alloc_off i.wave if wave>3,  cluster( wave )
outreg2 using "$regdir\t1.tex", replace  $outreg_setting 

reg ln_daysworked pref_office alloc_off c.pref_office#c.alloc_off i.wave if wave>3 & ad_office==0,  cluster( wave )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Home Ad)

reg ln_daysworked pref_office alloc_off c.pref_office#c.alloc_off i.wave if wave>3 & ad_office==1,  cluster( wave )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Office Ad)

reg ln_daysworked_1st3weeks pref_office alloc_off c.pref_office#c.alloc_off i.wave if wave>3,  cluster( wave )
outreg2 using "$regdir\t1.tex", append  $outreg_setting 

reg ln_daysworked_1st3weeks pref_office alloc_off c.pref_office#c.alloc_off i.wave if wave>3 & ad_office==0,  cluster( wave )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Home Ad)

reg ln_daysworked_1st3weeks pref_office alloc_off c.pref_office#c.alloc_off i.wave if wave>3 & ad_office==1,  cluster( wave )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Office Ad)



reg ln_daysworked pref_office alloc_off c.pref_office#c.alloc_off i.wave if wave>3,  cluster( wave )
outreg2 using "$regdir\t1.tex", replace  $outreg_setting 

reg ln_daysworked pref_office alloc_off c.pref_office#c.alloc_off i.wave if wave>3 & w_demo_Gender ==0,  cluster( wave )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(All Men)

reg ln_daysworked pref_office alloc_off c.pref_office#c.alloc_off i.wave if wave>3 & w_demo_Gender ==1,  cluster( wave )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(All Women)

reg ln_daysworked pref_office alloc_off c.pref_office#c.alloc_off i.wave if wave>3 & w_demo_Gender ==1 & w_demo_Married==1,  cluster( wave )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Married Women)

reg ln_daysworked pref_office alloc_off c.pref_office#c.alloc_off i.wave if wave>3 & w_demo_Gender ==1 & w_demo_Married==0,  cluster( wave )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Unmarried Women)


reg one_week pref_office alloc_off c.pref_office#c.alloc_off i.wave if wave>3,  cluster( wave )
outreg2 using "$regdir\t1.tex", replace  $outreg_setting 

reg one_week pref_office alloc_off c.pref_office#c.alloc_off i.wave if wave>3 & w_demo_Gender ==0,  cluster( wave )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(All Men)

reg one_week pref_office alloc_off c.pref_office#c.alloc_off i.wave if wave>3 & w_demo_Gender ==1,  cluster( wave )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(All Women)

reg one_week pref_office alloc_off c.pref_office#c.alloc_off i.wave if wave>3 & w_demo_Gender ==1 & w_demo_Married==1,  cluster( wave )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Married Women)

reg one_week pref_office alloc_off c.pref_office#c.alloc_off i.wave if wave>3 & w_demo_Gender ==1 & w_demo_Married==0,  cluster( wave )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Unmarried Women)



reg ln_daysworked_1st3weeks pref_office alloc_off c.pref_office#c.alloc_off i.wave if wave>3,  cluster( wave )
outreg2 using "$regdir\t1.tex", replace  $outreg_setting 

reg ln_daysworked_1st3weeks pref_office alloc_off c.pref_office#c.alloc_off i.wave if wave>3 & w_demo_Gender ==0,  cluster( wave )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(All Men)

reg ln_daysworked_1st3weeks pref_office alloc_off c.pref_office#c.alloc_off i.wave if wave>3 & w_demo_Gender ==1,  cluster( wave )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(All Women)

reg ln_daysworked_1st3weeks pref_office alloc_off c.pref_office#c.alloc_off i.wave if wave>3 & w_demo_Gender ==1 & w_demo_Married==1,  cluster( wave )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Married Women)

reg ln_daysworked_1st3weeks pref_office alloc_off c.pref_office#c.alloc_off i.wave if wave>3 & w_demo_Gender ==1 & w_demo_Married==0,  cluster( wave )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Unmarried Women)

 
*********Learning***********
sort recruitmentid_new startdatetime

bysort recruitmentid_new week: egen f_s_time=min(startdatetime)
bysort recruitmentid_new week: egen l_s_time=max(startdatetime)

local num _N

gen l16_speed= 

for x = 1/`num'{
if f_s_time[`x']==startdatetime  replace f16_speed=
}
