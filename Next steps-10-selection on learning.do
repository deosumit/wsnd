set mem 5g
set more off

global workdir "C:\Users\sumit\Documents\Work\Worker Sorting\My work"
global regdir "$workdir\tex files\reg_dec2019"

do "$workdir\cleaning.do"
			
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
			
			
****************************************
keep if userweek_n==1

global outreg_setting "noni auto(2) keep(pref_office alloc_off c.pref_office#c.alloc_off) tex(frag) nonotes"

***Learning 
*Wave3.5+
reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if wave>3 , cluster( recruitmentid_new  )
outreg2 using "$regdir\basic_learning", replace  $outreg_setting ctitle(All DEOs, All Weeks) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\basic_learning", append  $outreg_setting ctitle(All DEOs, 1-3 wks data) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\basic_learning", append  $outreg_setting ctitle(3\+ wks DEOs, All Weeks) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\basic_learning", append  $outreg_setting ctitle(3\+ wks DEOs, 1-3 wks data)

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\basic_learning", append  $outreg_setting ctitle(8 wks DEOs, All Weeks) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\basic_learning", append  $outreg_setting ctitle(8 wks DEOs, 1-3 wks data)




*All Wave
reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_allweeks", replace  $outreg_setting ctitle(All DEOs, All Weeks) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if week<4, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_allweeks", append  $outreg_setting ctitle(All DEOs, 1-3 wks data) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_allweeks", append  $outreg_setting ctitle(3\+ wks DEOs, All Weeks) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week<4, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_allweeks", append  $outreg_setting ctitle(3\+ wks DEOs, 1-3 wks data) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_allweeks", append  $outreg_setting ctitle(8 wks DEOs, All Weeks) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week<4, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_allweeks", append  $outreg_setting ctitle(8 wks DEOs, 1-3 wks data) 

***Gender 

preserve
keep if w_demo_Gender==0
reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_male", replace  $outreg_setting ctitle(All DEOs, All Weeks) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_male", append  $outreg_setting ctitle(All DEOs, 1-3 wks data) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_male", append  $outreg_setting ctitle(3\+ wks DEOs, All Weeks) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_male", append  $outreg_setting ctitle(3\+ wks DEOs, 1-3 wks data)

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_male", append  $outreg_setting ctitle(8 wks DEOs, All Weeks) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_male", append  $outreg_setting ctitle(8 wks DEOs, 1-3 wks data)
restore


preserve
keep if w_demo_Gender==1
reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_female", replace  $outreg_setting ctitle(All DEOs, All Weeks) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_female", append  $outreg_setting ctitle(All DEOs, 1-3 wks data) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_female", append  $outreg_setting ctitle(3\+ wks DEOs, All Weeks) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_female", append  $outreg_setting ctitle(3\+ wks DEOs, 1-3 wks data)

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_female", append  $outreg_setting ctitle(8 wks DEOs, All Weeks) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_female", append  $outreg_setting ctitle(8 wks DEOs, 1-3 wks data)
restore


preserve
keep if w_demo_Gender==1 & w_demo_Married==1
reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_fem_mar", replace  $outreg_setting ctitle(All DEOs, All Weeks) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_fem_mar", append  $outreg_setting ctitle(All DEOs, 1-3 wks data) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_fem_mar", append  $outreg_setting ctitle(3\+ wks DEOs, All Weeks) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_fem_mar", append  $outreg_setting ctitle(3\+ wks DEOs, 1-3 wks data)

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_fem_mar", append  $outreg_setting ctitle(8 wks DEOs, All Weeks) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_fem_mar", append  $outreg_setting ctitle(8 wks DEOs, 1-3 wks data)
restore


****Ad type

preserve
keep if ad_office ==1
reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_off_ad", replace  $outreg_setting ctitle(All DEOs, All Weeks) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_off_ad", append  $outreg_setting ctitle(All DEOs, 1-3 wks data) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_off_ad", append  $outreg_setting ctitle(3\+ wks DEOs, All Weeks)  

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_off_ad", append  $outreg_setting ctitle(3\+ wks DEOs, 1-3 wks data) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_off_ad", append  $outreg_setting ctitle(8 wks DEOs, All Weeks) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_off_ad", append  $outreg_setting ctitle(8 wks DEOs, 1-3 wks data) 
restore


preserve
keep if ad_office ==0
reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_hom_ad", replace  $outreg_setting ctitle(All DEOs, All Weeks) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_hom_ad", append  $outreg_setting ctitle(All DEOs, 1-3 wks data) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_hom_ad", append  $outreg_setting ctitle(3\+ wks DEOs, All Weeks) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_hom_ad", append  $outreg_setting ctitle(3\+ wks DEOs, 1-3 wks data) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_hom_ad", append  $outreg_setting ctitle(8 wks DEOs, All Weeks) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_hom_ad", append  $outreg_setting ctitle(8 wks DEOs, 1-3 wks data) 
restore


****Age 

preserve
keep if w_demo_Age  <25
reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_young", replace  $outreg_setting ctitle(All DEOs, All Weeks) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_young", append  $outreg_setting ctitle(All DEOs, 1-3 wks data) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_young", append  $outreg_setting ctitle(3\+ wks DEOs, All Weeks) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_young", append  $outreg_setting ctitle(3\+ wks DEOs, 1-3 wks data) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_young", append  $outreg_setting ctitle(8 wks DEOs, All Weeks) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_young", append  $outreg_setting ctitle(8 wks DEOs, 1-3 wks data) 
restore


preserve
keep if w_demo_Age  >24
reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_old", replace  $outreg_setting ctitle(All DEOs, All Weeks) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_old", append  $outreg_setting ctitle(All DEOs, 1-3 wks data) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_old", append  $outreg_setting ctitle(3\+ wks DEOs, All Weeks) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_old", append  $outreg_setting ctitle(3\+ wks DEOs, 1-3 wks data) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_old", append  $outreg_setting ctitle(8 wks DEOs, All Weeks) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_old", append  $outreg_setting ctitle(8 wks DEOs, 1-3 wks data) 
restore



********************************************
*Learning + Baseline ability 


*Wave3.5+
reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if wave>3 , cluster( recruitmentid_new  )
outreg2 using "$regdir\basic_learning", replace  $outreg_setting ctitle(All DEOs, All Weeks) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\basic_learning", append  $outreg_setting ctitle(All DEOs, 1-3 wks data) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\basic_learning", append  $outreg_setting ctitle(3\+ wks DEOs, All Weeks) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\basic_learning", append  $outreg_setting ctitle(3\+ wks DEOs, 1-3 wks data)

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\basic_learning", append  $outreg_setting ctitle(8 wks DEOs, All Weeks) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\basic_learning", append  $outreg_setting ctitle(8 wks DEOs, 1-3 wks data)




*All Wave
reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_allweeks", replace  $outreg_setting ctitle(All DEOs, All Weeks) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if week<4, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_allweeks", append  $outreg_setting ctitle(All DEOs, 1-3 wks data) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_allweeks", append  $outreg_setting ctitle(3\+ wks DEOs, All Weeks) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week<4, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_allweeks", append  $outreg_setting ctitle(3\+ wks DEOs, 1-3 wks data) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_allweeks", append  $outreg_setting ctitle(8 wks DEOs, All Weeks) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week<4, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_allweeks", append  $outreg_setting ctitle(8 wks DEOs, 1-3 wks data) 

***Gender 

preserve
keep if w_demo_Gender==0
reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_male", replace  $outreg_setting ctitle(All DEOs, All Weeks) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_male", append  $outreg_setting ctitle(All DEOs, 1-3 wks data) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_male", append  $outreg_setting ctitle(3\+ wks DEOs, All Weeks) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_male", append  $outreg_setting ctitle(3\+ wks DEOs, 1-3 wks data)

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_male", append  $outreg_setting ctitle(8 wks DEOs, All Weeks) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_male", append  $outreg_setting ctitle(8 wks DEOs, 1-3 wks data)
restore


preserve
keep if w_demo_Gender==1
reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_female", replace  $outreg_setting ctitle(All DEOs, All Weeks) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_female", append  $outreg_setting ctitle(All DEOs, 1-3 wks data) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_female", append  $outreg_setting ctitle(3\+ wks DEOs, All Weeks) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_female", append  $outreg_setting ctitle(3\+ wks DEOs, 1-3 wks data)

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_female", append  $outreg_setting ctitle(8 wks DEOs, All Weeks) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_female", append  $outreg_setting ctitle(8 wks DEOs, 1-3 wks data)
restore


preserve
keep if w_demo_Gender==1 & w_demo_Married==1
reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_fem_mar", replace  $outreg_setting ctitle(All DEOs, All Weeks) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_fem_mar", append  $outreg_setting ctitle(All DEOs, 1-3 wks data) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_fem_mar", append  $outreg_setting ctitle(3\+ wks DEOs, All Weeks) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_fem_mar", append  $outreg_setting ctitle(3\+ wks DEOs, 1-3 wks data)

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_fem_mar", append  $outreg_setting ctitle(8 wks DEOs, All Weeks) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_fem_mar", append  $outreg_setting ctitle(8 wks DEOs, 1-3 wks data)
restore


****Ad type

preserve
keep if ad_office ==1
reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_off_ad", replace  $outreg_setting ctitle(All DEOs, All Weeks) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_off_ad", append  $outreg_setting ctitle(All DEOs, 1-3 wks data) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_off_ad", append  $outreg_setting ctitle(3\+ wks DEOs, All Weeks)  

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_off_ad", append  $outreg_setting ctitle(3\+ wks DEOs, 1-3 wks data) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_off_ad", append  $outreg_setting ctitle(8 wks DEOs, All Weeks) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_off_ad", append  $outreg_setting ctitle(8 wks DEOs, 1-3 wks data) 
restore


preserve
keep if ad_office ==0
reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_hom_ad", replace  $outreg_setting ctitle(All DEOs, All Weeks) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_hom_ad", append  $outreg_setting ctitle(All DEOs, 1-3 wks data) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_hom_ad", append  $outreg_setting ctitle(3\+ wks DEOs, All Weeks) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_hom_ad", append  $outreg_setting ctitle(3\+ wks DEOs, 1-3 wks data) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_hom_ad", append  $outreg_setting ctitle(8 wks DEOs, All Weeks) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_hom_ad", append  $outreg_setting ctitle(8 wks DEOs, 1-3 wks data) 
restore


****Age 

preserve
keep if w_demo_Age  <25
reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_young", replace  $outreg_setting ctitle(All DEOs, All Weeks) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_young", append  $outreg_setting ctitle(All DEOs, 1-3 wks data) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_young", append  $outreg_setting ctitle(3\+ wks DEOs, All Weeks) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_young", append  $outreg_setting ctitle(3\+ wks DEOs, 1-3 wks data) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_young", append  $outreg_setting ctitle(8 wks DEOs, All Weeks) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_young", append  $outreg_setting ctitle(8 wks DEOs, 1-3 wks data) 
restore


preserve
keep if w_demo_Age  >24
reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_old", replace  $outreg_setting ctitle(All DEOs, All Weeks) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_old", append  $outreg_setting ctitle(All DEOs, 1-3 wks data) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_old", append  $outreg_setting ctitle(3\+ wks DEOs, All Weeks) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_old", append  $outreg_setting ctitle(3\+ wks DEOs, 1-3 wks data) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_old", append  $outreg_setting ctitle(8 wks DEOs, All Weeks) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week<4 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_old", append  $outreg_setting ctitle(8 wks DEOs, 1-3 wks data) 
restore
