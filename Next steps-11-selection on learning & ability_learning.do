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

global outreg_setting "noni auto(2) keep(pref_office alloc_off c.pref_office#c.alloc_off pref_home alloc_home  c.pref_home#c.alloc_home) tex(frag) nonotes"


*Wave3.5+
reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if wave>3 & week==1, cluster( recruitmentid_new  )
outreg2 using "$regdir\basic_learning", replace  $outreg_setting ctitle(All DEOs, Week 1) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week==1 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\basic_learning", append  $outreg_setting ctitle(3\+ wks DEOs, Week 1)

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==1 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\basic_learning", append  $outreg_setting ctitle(8 wks DEOs, Week 1)

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week==3 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\basic_learning", append  $outreg_setting ctitle(3\+ wks DEOs, Week 3)

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==3 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\basic_learning", append  $outreg_setting ctitle(8 wks DEOs, Week 3)

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==8 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\basic_learning", append  $outreg_setting ctitle(8 wks DEOs, Week 8)





*All Wave
reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if  week==1, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_allweeks", replace  $outreg_setting ctitle(All DEOs, Week 1) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week==1 , cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_allweeks", append  $outreg_setting ctitle(3\+ wks DEOs, Week 1)

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==1 , cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_allweeks", append  $outreg_setting ctitle(8 wks DEOs, Week 1)

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week==3 , cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_allweeks", append  $outreg_setting ctitle(3\+ wks DEOs, Week 3)

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==3 , cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_allweeks", append  $outreg_setting ctitle(8 wks DEOs, Week 3)

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==8 , cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_allweeks", append  $outreg_setting ctitle(8 wks DEOs, Week 8)



***Gender 

preserve
keep if w_demo_Gender==0
reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if wave>3 & week==1, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_male", replace  $outreg_setting ctitle(All DEOs, Week 1) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week==1 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_male", append  $outreg_setting ctitle(3\+ wks DEOs, Week 1)

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==1 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_male", append  $outreg_setting ctitle(8 wks DEOs, Week 1)

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week==3 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_male", append  $outreg_setting ctitle(3\+ wks DEOs, Week 3)

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==3 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_male", append  $outreg_setting ctitle(8 wks DEOs, Week 3)

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==8 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_male", append  $outreg_setting ctitle(8 wks DEOs, Week 8)
restore

preserve
keep if w_demo_Gender==1
reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if wave>3 & week==1, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_female", replace  $outreg_setting ctitle(All DEOs, Week 1) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week==1 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_female", append  $outreg_setting ctitle(3\+ wks DEOs, Week 1)

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==1 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_female", append  $outreg_setting ctitle(8 wks DEOs, Week 1)

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week==3 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_female", append  $outreg_setting ctitle(3\+ wks DEOs, Week 3)

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==3 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_female", append  $outreg_setting ctitle(8 wks DEOs, Week 3)

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==8 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_female", append  $outreg_setting ctitle(8 wks DEOs, Week 8)
restore

preserve
keep if w_demo_Gender==1 & w_demo_Married==1
reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if wave>3 & week==1, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_fem_mar", replace  $outreg_setting ctitle(All DEOs, Week 1) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week==1 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_fem_mar", append  $outreg_setting ctitle(3\+ wks DEOs, Week 1)

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==1 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_fem_mar", append  $outreg_setting ctitle(8 wks DEOs, Week 1)

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week==3 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_fem_mar", append  $outreg_setting ctitle(3\+ wks DEOs, Week 3)

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==3 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_fem_mar", append  $outreg_setting ctitle(8 wks DEOs, Week 3)

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==8 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_fem_mar", append  $outreg_setting ctitle(8 wks DEOs, Week 8)
restore


****Ad type

preserve
keep if ad_office ==1
reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if wave>3 & week==1, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_off_ad", replace  $outreg_setting ctitle(All DEOs, Week 1) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week==1 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_off_ad", append  $outreg_setting ctitle(3\+ wks DEOs, Week 1)

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==1 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_off_ad", append  $outreg_setting ctitle(8 wks DEOs, Week 1)

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week==3 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_off_ad", append  $outreg_setting ctitle(3\+ wks DEOs, Week 3)

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==3 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_off_ad", append  $outreg_setting ctitle(8 wks DEOs, Week 3)

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==8 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_off_ad", append  $outreg_setting ctitle(8 wks DEOs, Week 8)
restore


preserve
keep if ad_office ==0
reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if wave>3 & week==1, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_hom_ad", replace  $outreg_setting ctitle(All DEOs, Week 1) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week==1 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_hom_ad", append  $outreg_setting ctitle(3\+ wks DEOs, Week 1)

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==1 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_hom_ad", append  $outreg_setting ctitle(8 wks DEOs, Week 1)

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week==3 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_hom_ad", append  $outreg_setting ctitle(3\+ wks DEOs, Week 3)

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==3 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_hom_ad", append  $outreg_setting ctitle(8 wks DEOs, Week 3)

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==8 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_hom_ad", append  $outreg_setting ctitle(8 wks DEOs, Week 8)
restore


****Age 

preserve
keep if w_demo_Age  <25
reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if wave>3 & week==1, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_young", replace  $outreg_setting ctitle(All DEOs, Week 1) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week==1 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_young", append  $outreg_setting ctitle(3\+ wks DEOs, Week 1)

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==1 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_young", append  $outreg_setting ctitle(8 wks DEOs, Week 1)

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week==3 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_young", append  $outreg_setting ctitle(3\+ wks DEOs, Week 3)

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==3 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_young", append  $outreg_setting ctitle(8 wks DEOs, Week 3)

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==8 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_young", append  $outreg_setting ctitle(8 wks DEOs, Week 8)
restore


preserve
keep if w_demo_Age  >24
reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if wave>3 & week==1, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_old", replace  $outreg_setting ctitle(All DEOs, Week 1) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week==1 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_old", append  $outreg_setting ctitle(3\+ wks DEOs, Week 1)

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==1 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_old", append  $outreg_setting ctitle(8 wks DEOs, Week 1)

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week==3 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_old", append  $outreg_setting ctitle(3\+ wks DEOs, Week 3)

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==3 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_old", append  $outreg_setting ctitle(8 wks DEOs, Week 3)

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==8 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\learning_old", append  $outreg_setting ctitle(8 wks DEOs, Week 8) 
restore


********************************************
*Learning + Baseline ability 

*Wave3.5+
reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if wave>3 & week==1, cluster( recruitmentid_new  )
outreg2 using "$regdir\basic_ability_learning", replace  $outreg_setting ctitle(All DEOs, Week 1) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week==1 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\basic_ability_learning", append  $outreg_setting ctitle(3\+ wks DEOs, Week 1)

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==1 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\basic_ability_learning", append  $outreg_setting ctitle(8 wks DEOs, Week 1)

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week==3 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\basic_ability_learning", append  $outreg_setting ctitle(3\+ wks DEOs, Week 3)

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==3 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\basic_ability_learning", append  $outreg_setting ctitle(8 wks DEOs, Week 3)

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==8 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\basic_ability_learning", append  $outreg_setting ctitle(8 wks DEOs, Week 8)





*All Wave
reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if  week==1, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_allweeks", replace  $outreg_setting ctitle(All DEOs, Week 1) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week==1 , cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_allweeks", append  $outreg_setting ctitle(3\+ wks DEOs, Week 1)

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==1 , cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_allweeks", append  $outreg_setting ctitle(8 wks DEOs, Week 1)

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week==3 , cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_allweeks", append  $outreg_setting ctitle(3\+ wks DEOs, Week 3)

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==3 , cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_allweeks", append  $outreg_setting ctitle(8 wks DEOs, Week 3)

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==8 , cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_allweeks", append  $outreg_setting ctitle(8 wks DEOs, Week 8)



***Gender 

preserve
keep if w_demo_Gender==0
reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if wave>3 & week==1, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_male", replace  $outreg_setting ctitle(All DEOs, Week 1) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week==1 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_male", append  $outreg_setting ctitle(3\+ wks DEOs, Week 1)

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==1 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_male", append  $outreg_setting ctitle(8 wks DEOs, Week 1)

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week==3 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_male", append  $outreg_setting ctitle(3\+ wks DEOs, Week 3)

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==3 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_male", append  $outreg_setting ctitle(8 wks DEOs, Week 3)

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==8 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_male", append  $outreg_setting ctitle(8 wks DEOs, Week 8)
restore

preserve
keep if w_demo_Gender==1
reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if wave>3 & week==1, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_female", replace  $outreg_setting ctitle(All DEOs, Week 1) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week==1 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_female", append  $outreg_setting ctitle(3\+ wks DEOs, Week 1)

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==1 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_female", append  $outreg_setting ctitle(8 wks DEOs, Week 1)

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week==3 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_female", append  $outreg_setting ctitle(3\+ wks DEOs, Week 3)

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==3 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_female", append  $outreg_setting ctitle(8 wks DEOs, Week 3)

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==8 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_female", append  $outreg_setting ctitle(8 wks DEOs, Week 8)
restore

preserve
keep if w_demo_Gender==1 & w_demo_Married==1
reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if wave>3 & week==1, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_fem_mar", replace  $outreg_setting ctitle(All DEOs, Week 1) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week==1 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_fem_mar", append  $outreg_setting ctitle(3\+ wks DEOs, Week 1)

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==1 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_fem_mar", append  $outreg_setting ctitle(8 wks DEOs, Week 1)

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week==3 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_fem_mar", append  $outreg_setting ctitle(3\+ wks DEOs, Week 3)

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==3 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_fem_mar", append  $outreg_setting ctitle(8 wks DEOs, Week 3)

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==8 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_fem_mar", append  $outreg_setting ctitle(8 wks DEOs, Week 8)
restore


****Ad type

preserve
keep if ad_office ==1
reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if wave>3 & week==1, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_off_ad", replace  $outreg_setting ctitle(All DEOs, Week 1) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week==1 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_off_ad", append  $outreg_setting ctitle(3\+ wks DEOs, Week 1)

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==1 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_off_ad", append  $outreg_setting ctitle(8 wks DEOs, Week 1)

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week==3 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_off_ad", append  $outreg_setting ctitle(3\+ wks DEOs, Week 3)

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==3 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_off_ad", append  $outreg_setting ctitle(8 wks DEOs, Week 3)

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==8 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_off_ad", append  $outreg_setting ctitle(8 wks DEOs, Week 8)
restore


preserve
keep if ad_office ==0
reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if wave>3 & week==1, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_hom_ad", replace  $outreg_setting ctitle(All DEOs, Week 1) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week==1 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_hom_ad", append  $outreg_setting ctitle(3\+ wks DEOs, Week 1)

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==1 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_hom_ad", append  $outreg_setting ctitle(8 wks DEOs, Week 1)

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week==3 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_hom_ad", append  $outreg_setting ctitle(3\+ wks DEOs, Week 3)

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==3 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_hom_ad", append  $outreg_setting ctitle(8 wks DEOs, Week 3)

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==8 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_hom_ad", append  $outreg_setting ctitle(8 wks DEOs, Week 8)
restore


****Age 

preserve
keep if w_demo_Age  <25
reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if wave>3 & week==1, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_young", replace  $outreg_setting ctitle(All DEOs, Week 1) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week==1 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_young", append  $outreg_setting ctitle(3\+ wks DEOs, Week 1)

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==1 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_young", append  $outreg_setting ctitle(8 wks DEOs, Week 1)

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week==3 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_young", append  $outreg_setting ctitle(3\+ wks DEOs, Week 3)

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==3 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_young", append  $outreg_setting ctitle(8 wks DEOs, Week 3)

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==8 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_young", append  $outreg_setting ctitle(8 wks DEOs, Week 8)
restore


preserve
keep if w_demo_Age  >24
reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if wave>3 & week==1, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_old", replace  $outreg_setting ctitle(All DEOs, Week 1) 

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week==1 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_old", append  $outreg_setting ctitle(3\+ wks DEOs, Week 1)

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==1 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_old", append  $outreg_setting ctitle(8 wks DEOs, Week 1)

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>18 & week==3 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_old", append  $outreg_setting ctitle(3\+ wks DEOs, Week 3)

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==3 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_old", append  $outreg_setting ctitle(8 wks DEOs, Week 3)

reg ln_week_avg16_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if daysworked>49 & week==8 & wave>3, cluster( recruitmentid_new  )
outreg2 using "$regdir\ability_learning_old", append  $outreg_setting ctitle(8 wks DEOs, Week 8) 
restore


**Does anyone reason explain the difference?


drop _merge w_*
merge m:1 recruitmentid_new using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\03. Datasets\31. Surveys\312. walk in\3124. Final Dataset\Walkin_Cleaned_Encoded.dta"
drop if _merge==2
drop _merge

drop w_h_expenses w_h_flexibility w_h_parttime_comm w_h_travel w_h_familycare w_h_permission w_h_negative w_h_others w_o_office_environ w_o_convinient w_o_9to5 w_o_nodisturb w_o_network w_o_easeissues w_o_getexperience w_o_others
			*Cleaning reasons for Home and Office Preference:
			*Reasons for Home		
			
				gen H1=w_wrkpref_Reasons4Home
				gen h_expenses			=(strpos(H1, "Expenses shoot up: cloths food outside") )>0
														 
				gen h_parttime_comm		=(strpos(H1, "He trying the another job so most prefer home based") ///
				                         |strpos(H1, "Part time Job & Other works commitments")) > 0
										              
				gen h_travel			=(strpos(H1, "Commutation cost: time"))	> 0
				
				gen h_familycare		=(strpos(H1, "Taking care of parents or children" )) >0
								
				gen h_others			=(strpos(H1,"Less negative influences")  ///
										 | strpos(H1, "Work/life balance is good & Less stress and anxiety") ///
										 | strpos(H1, "Disability")) > 0
				
				*gen h_others			=(strpos(H1, "Disability")) > 0

				drop H1
				

			
			
			*Reasons for Office
			
			
                gen O1 = w_wrkpref_Reasons4Office				
				*split wrkpref_Reasons4Office, p(",") g(O)
				gen o_office_environ		=(strpos(O1, "Willingness to work in an Office Environment") ) > 0 
				
				gen o_convinient			=(strpos(O1, "Convinent")) > 0
				
				gen o_9to5					=(strpos(O1, "interested to work 9 to 5")) > 0
											 
				gen o_nodisturb				=(strpos(O1, "No disturbance as compared to Home")) > 0
											 
				gen o_network				=(strpos(O1, "To build professional Network"))	> 0
											 
				gen o_easeissues			=(strpos(O1, "Ease of solving issues face")) > 0
				
				gen o_getexperience			=(strpos(O1, "get experience")) > 0
											 
				drop O1


gen pref_home=1-pref_off
gen alloc_home=1-alloc_off



gen p=.
gen b=.
gen b_int=.
gen se=.
gen se_int=.




global i=1

foreach x of varlist o_office_environ o_convinient o_9to5 o_nodisturb o_network o_easeissues o_getexperience{ 

reg ln_n_speed_s pref_office alloc_off c.pref_office#c.alloc_off c.pref_office#c.`x' c.pref_office#c.alloc_off#c.`x' i.wave i.section i.week if wave>3 [pw=weight], cluster( recruitmentid_new )

replace b= _b[c.pref_office#c.`x'] in $i
replace se= _se[c.pref_office#c.`x'] in $i
replace b_int= _b[c.pref_office#c.alloc_off#c.`x'] in $i
replace se_int= _se[c.pref_office#c.alloc_off#c.`x'] in $i
replace p= _b[pref_office] in  $i

global i= $i + 1
}


foreach x of varlist h_expenses h_parttime_comm h_travel h_familycare{ 

reg ln_n_speed_s pref_home alloc_home c.pref_home#c.alloc_home c.pref_home#c.`x' c.pref_home#c.alloc_home#c.`x' i.wave i.section i.week if wave>3 [pw=weight], cluster( recruitmentid_new )

replace b= _b[c.pref_home#c.`x'] in $i
replace se= _se[c.pref_home#c.`x'] in $i
replace b_int= _b[c.pref_home#c.alloc_home#c.`x'] in $i
replace se_int= _se[c.pref_home#c.alloc_home#c.`x'] in $i
replace p= _b[pref_home] in  $i

global i= $i + 1
}


gen lb= b - 1.96*se
gen ub= b + 1.96*se



***********20th Monday 2020***********


reg bl_speed  pref_office i.wave i.user_n if wave>3 & user_n<4, cluster( recruitmentid_new )
outreg2 using "$regdir\update10", replace  $outreg_setting ctitle(Baseline, Speed) 

reg ln_n_speed_s pref_office alloc_off  c.pref_office#c.alloc_off i.wave i.week i.section if wave>4 [pw=weight], cluster( person_week )
outreg2 using "$regdir\update10.tex", append  $outreg_setting ctitle(Speed)

reg ln_n_speed_s pref_office alloc_off  c.pref_office#c.alloc_off i.wave i.week i.section ln_n_speed_cash if wave>4 [pw=weight], cluster( person_week )
outreg2 using "$regdir\update10.tex", append  $outreg_setting ctitle(Speed)

reg ln_n_speed_s pref_office alloc_off  c.pref_office#c.alloc_off i.wave i.week i.section ln_n_speed_cash c.ln_n_speed_cash#c.pref_office if wave>4 [pw=weight], cluster( person_week )
outreg2 using "$regdir\update10.tex", append  $outreg_setting ctitle(Speed)







************************

gen bl_speed = log(w60_min_netspeed) if user_n==1
replace bl_speed = log(cash_net_speed) if user_n==2
replace bl_speed = log(plain_net_speed ) if user_n==3

reg bl_speed  pref_home i.wave i.user_n if wave>3 & user_n<4, cluster( recruitmentid_new )
outreg2 using "$regdir\baseline_home", replace  $outreg_setting ctitle(Overall) 

foreach x of varlist h_familycare  h_parttime_comm h_travel h_expenses { 

replace pref_home=`x'

reg bl_speed  pref_home i.wave i.user_n if wave>3 & user_n<4 & (pref_office==1 | pref_home==1 ), cluster( recruitmentid_new )
outreg2 using "$regdir\baseline_home", append  $outreg_setting ctitle("`x'") 

}

replace pref_home=1-pref_off




reg ln_n_speed_s pref_home alloc_home  c.pref_home#c.alloc_home i.wave i.week i.section if wave>4  [pw=weight], cluster( person_week )
outreg2 using "$regdir\treatment_home", replace  $outreg_setting ctitle(Overall) 

foreach x of varlist h_familycare  h_parttime_comm h_travel h_expenses { 

replace pref_home=`x'

reg ln_n_speed_s pref_home alloc_home  c.pref_home#c.alloc_home i.wave i.week i.section if wave>4 & (pref_office==1 | pref_home==1 ) [pw=weight], cluster( person_week )
outreg2 using "$regdir\treatment_home", append  $outreg_setting ctitle("`x'") 

}



reg ln_n_speed_s pref_office alloc_off  c.pref_office#c.alloc_off i.wave i.week i.section if wave>4  [pw=weight], cluster( person_week )
outreg2 using "$regdir\treatment_home1", replace  $outreg_setting ctitle(Overall) 

foreach x of varlist h_familycare  h_parttime_comm h_travel h_expenses { 

replace pref_home=`x'

reg ln_n_speed_s pref_office alloc_off  c.pref_office#c.alloc_off i.wave i.week i.section if wave>4 & (pref_office==1 | pref_home==1 ) [pw=weight], cluster( person_week )
outreg2 using "$regdir\treatment_home1", append  $outreg_setting ctitle("`x'") 

}

*********Office reasons

replace pref_off=w_wrkpref_MainWalkPref
replace pref_home= 1- w_wrkpref_MainWalkPref

reg bl_speed  pref_off i.wave i.user_n if wave>3 & user_n<4, cluster( recruitmentid_new )
outreg2 using "$regdir\baseline_off", replace  $outreg_setting ctitle(Overall) 

foreach x of varlist o_nodisturb o_network o_convinient o_easeissues o_9to5 o_office_environ o_getexperience { 

replace pref_off=`x'

reg bl_speed  pref_off i.wave i.user_n if wave>3 & user_n<4 & (pref_office==1 | pref_home==1 ), cluster( recruitmentid_new )
outreg2 using "$regdir\baseline_off", append  $outreg_setting ctitle("`x'") 

}


reg ln_n_speed_s pref_office alloc_off  c.pref_office#c.alloc_off i.wave i.week i.section if wave>4  [pw=weight], cluster( person_week )
outreg2 using "$regdir\treatment_off", replace  $outreg_setting ctitle(Overall) 

foreach x of varlist o_nodisturb o_network o_convinient o_easeissues o_9to5 o_office_environ o_getexperience { 

replace pref_office=`x'

reg ln_n_speed_s pref_office alloc_off  c.pref_office#c.alloc_off i.wave i.week i.section if wave>4 & (pref_office==1 | pref_home==1 ) [pw=weight], cluster( person_week )
outreg2 using "$regdir\treatment_off", append  $outreg_setting ctitle("`x'") 

}
