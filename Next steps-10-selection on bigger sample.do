set mem 5g
set more off

global workdir "C:\Users\sumit\Documents\Work\Worker Sorting\My work"


use "C:\Users\sumit\Documents\Work\Worker Sorting\03. Datasets\31. Surveys\312. walk in\3124. Final Dataset\Walkin_Cleaned_Encoded.dta", clear

merge 1:1 A1RecruitmentID using "C:\Users\sumit\Documents\Work\Worker Sorting\03. Datasets\31. Surveys\313. Baseline\3134. Final Dataset\Baseline cleaned.dta"
*drop if _merge!=3
*drop _merge

rename _merge bs_wi_merge

rename A1RecruitmentID recruitmentid_new
merge 1:1 recruitmentid_new using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\dta\attrit_days_trim.dta"
rename _merge attrit_merge

rename recruitmentid_new A1RecruitmentID 


merge 1:1 A1RecruitmentID using "C:\Users\sumit\Documents\Work\Worker Sorting\03. Datasets\33. Software\333. Cash, Non-Cash\3334.Final\plain & cash_appended.dta"
drop if _merge==2
rename _merge cashplain_merge


merge 1:1 A1RecruitmentID using "C:\Users\sumit\Documents\Work\Worker Sorting\03. Datasets\33. Software\331. 60 mins test\3314.Final\appended_60 min speed.dta"
*ed if _merge==2


cap drop usergroup startday startdate starttime surveyname endday enddate endtime totalperiodhhmmss timespenthhmmss idletimehhmmss totalkeystrokes incorrectkeystrokes keystrokesaccuracy totalfields filledfields emptyfields correctentries incorrectentries missedentries correctvoidentries fieldsaccuracy totalcharacters incorrectcharacters characteraccuracy startdatetime enddatetime incor_field_ incorrect_char1_ incorrect_char2_ corr_char tot_ent_char_ total_char_ corr_field entered_fields_
cap drop e_* 
cap drop time_* a_*


rename A1RecruitmentID recruitmentid_new

split recruitmentid_new, p("D") g(advert)
replace advert1="D"+advert2 if advert1==""

foreach a in `"A1"' `"A10"' `"A11"' `"A12"' `"A4"' `"A5"' `"B10"' `"B11"' `"B3"' `"B6"' `"B7"' `"C3"' `"C4"' `"C7"' `"C8"' `"D3"' `"D4"' `"D5"'{
replace ad_office=0 if ad_office==. & advert1=="`a'"
}

foreach a in "A2"' `"A3"' `"A8"' `"A9"' `"B4"' `"B5"' `"B8"' `"B9"' `"C1"' `"C5"' `"C6"' `"D1"' `"D2"' `"D7"' `"W4A1"' `"W4A2"' `"D8"'{
replace ad_office=1 if ad_office==. & advert1=="`a'"
}

replace wave=1 if wave==. & advert1==`"W1"'

foreach a in `"A1"' `"A2"'{
replace wave=2 if wave==. & advert1=="`a'"
}

foreach a in `"A3"' `"A4"' `"A5"'{
replace wave=3 if wave==. & advert1=="`a'"
}

foreach a in `"A10"' `"A11"' `"A12"' `"A4"' `"A5"' `"A8"' `"A9"' `"B3"' `"B4"' `"B5"' `"B6"' `"B7"' `"W4A1"' `"W4A2"'{
replace wave=5 if wave==. & advert1=="`a'"
}

foreach a in `"B10"' `"B11"' `"B8"' `"B9"' `"C1"' `"C3"' `"C4"' `"C5"' `"C6"' `"C7"' `"C8"' `"D1"' `"D2"' `"D3"' `"D4"' `"D5"' `"D7"' `"D8"'{
replace wave=6 if wave==. & advert1=="`a'"
}


gen wrkd_1day= (daysworked!=.)
replace daysworked=1 if daysworked==.




replace pref_office= w_wrkpref_MainWalkPref if pref_office==.
replace alloc_off= w_allocation if alloc_off==.


gen pref_all=1 if alloc_off==0 & pref_office==0
replace pref_all=2 if alloc_off==1 & pref_office==0
replace pref_all=3 if alloc_off==0 & pref_office==1
replace pref_all=4 if alloc_off==1 & pref_office==1

replace wave3plus=1 if wave>4 
replace wave3plus=0 if wave<4 

gen sample= (alloc_off!=.)
replace sample= 2 if wrkd_1day==1
/*
expand 3

bysort recruitmentid_new: gen test=_n 

gen bl_speed = log(w60_min_netspeed) if test==1
replace bl_speed = log(cash_net_speed) if test==2
replace bl_speed = log(plain_net_speed ) if test==3

global workdir "C:\Users\sumit\Documents\Work\Worker Sorting\My work"
global regdir "$workdir\tex files\reg_dec2019"

global outreg_setting "noni auto(2) keep(pref_office ad_office c.pref_office#c.ad_office) tex(frag) nonotes"




***T-stats with the new sample
local demo w_demo_Gender w_demo_Age w_demo_Married w_demo_ChildrenNum w_demo_distance w_demo_withinchennai
local edu  w_edu_LaptopDesktopUsed w_edu_TypingCourseCompleted w_edu_typing_certificate
local wrkex w_wrkex_PreviousWorkExYear w_wrkex_NumOfJobsDoneBefore w_empstat_Unemployment_duration 
local speed w60_min_netspeed cash_net_speed plain_net_speed 


estpost ttest `speed' `demo' `edu' `wrkex' if pref_office ==0 & wave>3, by(alloc_off )

estpost ttest `speed' `demo' `edu' `wrkex' if pref_office ==1 & wave>3, by(alloc_off )



local pref h_expenses h_flexibility h_parttime_comm h_travel h_comfortable h_otherjob h_familycare h_permission
estpost ttest `pref' if sample>0 & test==1 & wave>3 & pref_office==0, by(alloc_off )


******************************





*Baseline Regression
reg bl_speed  pref_office i.wave i.test if wave>3 & sample>0, cluster( recruitmentid_new )
outreg2 using "$regdir\ability", replace  $outreg_setting ctitle(Pre , Attrition) 

reg bl_speed  ad_office  i.wave i.test if wave>3 & sample>0, cluster( recruitmentid_new )
outreg2 using "$regdir\ability", append  $outreg_setting ctitle(Pre , Attrition) 

reg bl_speed  pref_office ad_office  i.wave i.test if wave>3 & sample>0, cluster( recruitmentid_new )
outreg2 using "$regdir\ability", append  $outreg_setting ctitle(Pre , Attrition) 

reg bl_speed  pref_office ad_office c.pref_office#c.ad_office i.wave i.test if wave>3 & sample>0, cluster( recruitmentid_new )
outreg2 using "$regdir\ability", append  $outreg_setting ctitle(Pre , Attrition) 

reg bl_speed  pref_office i.wave i.test if wave>3 & sample>1, cluster( recruitmentid_new )
outreg2 using "$regdir\ability", append  $outreg_setting ctitle(Post , Attrition) 

reg bl_speed  ad_office  i.wave i.test if wave>3 & sample>1, cluster( recruitmentid_new )
outreg2 using "$regdir\ability", append  $outreg_setting ctitle(Post , Attrition) 

reg bl_speed  pref_office ad_office  i.wave i.test if wave>3 & sample>1, cluster( recruitmentid_new )
outreg2 using "$regdir\ability", append  $outreg_setting ctitle(Post , Attrition) 

reg bl_speed  pref_office ad_office c.pref_office#c.ad_office i.wave i.test if wave>3 & sample>1, cluster( recruitmentid_new )
outreg2 using "$regdir\ability", append  $outreg_setting ctitle(Post , Attrition) 


*Big sample
reg bl_speed  pref_office i.wave i.test if wave>1 & sample>0, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_allweeks", replace  $outreg_setting ctitle(Pre , Attrition) 

reg bl_speed  ad_office  i.wave i.test if wave>1 & sample>0, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_allweeks", append  $outreg_setting ctitle(Pre , Attrition) 

reg bl_speed  pref_office ad_office  i.wave i.test if wave>1 & sample>0, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_allweeks", append  $outreg_setting ctitle(Pre , Attrition) 

reg bl_speed  pref_office ad_office c.pref_office#c.ad_office i.wave i.test if wave>1 & sample>0, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_allweeks", append  $outreg_setting ctitle(Pre , Attrition) 

reg bl_speed  pref_office i.wave i.test if wave>1 & sample>1, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_allweeks", append  $outreg_setting ctitle(Post , Attrition) 

reg bl_speed  ad_office  i.wave i.test if wave>1 & sample>1, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_allweeks", append  $outreg_setting ctitle(Post , Attrition) 

reg bl_speed  pref_office ad_office  i.wave i.test if wave>1 & sample>1, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_allweeks", append  $outreg_setting ctitle(Post , Attrition) 

reg bl_speed  pref_office ad_office c.pref_office#c.ad_office i.wave i.test if wave>1 & sample>1, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_allweeks", append  $outreg_setting ctitle(Post , Attrition) 



**Gender
*Male 
preserve 
keep if w_demo_Gender ==0

reg bl_speed  pref_office i.wave i.test if wave>3 & sample>0, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_men", replace  $outreg_setting ctitle(Pre , Attrition) 

reg bl_speed  ad_office  i.wave i.test if wave>3 & sample>0, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_men", append  $outreg_setting ctitle(Pre , Attrition) 

reg bl_speed  pref_office ad_office  i.wave i.test if wave>3 & sample>0, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_men", append  $outreg_setting ctitle(Pre , Attrition) 

reg bl_speed  pref_office ad_office c.pref_office#c.ad_office i.wave i.test if wave>3 & sample>0, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_men", append  $outreg_setting ctitle(Pre , Attrition) 

reg bl_speed  pref_office i.wave i.test if wave>3 & sample>1, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_men", append  $outreg_setting ctitle(Post , Attrition) 

reg bl_speed  ad_office  i.wave i.test if wave>3 & sample>1, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_men", append  $outreg_setting ctitle(Post , Attrition) 

reg bl_speed  pref_office ad_office  i.wave i.test if wave>3 & sample>1, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_men", append  $outreg_setting ctitle(Post , Attrition) 

reg bl_speed  pref_office ad_office c.pref_office#c.ad_office i.wave i.test if wave>3 & sample>1, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_men", append  $outreg_setting ctitle(Post , Attrition) 
restore

*Female
preserve 
keep if w_demo_Gender ==1

reg bl_speed  pref_office i.wave i.test if wave>3 & sample>0, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_women", replace  $outreg_setting ctitle(Pre , Attrition) 

reg bl_speed  ad_office  i.wave i.test if wave>3 & sample>0, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_women", append  $outreg_setting ctitle(Pre , Attrition) 

reg bl_speed  pref_office ad_office  i.wave i.test if wave>3 & sample>0, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_women", append  $outreg_setting ctitle(Pre , Attrition) 

reg bl_speed  pref_office ad_office c.pref_office#c.ad_office i.wave i.test if wave>3 & sample>0, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_women", append  $outreg_setting ctitle(Pre , Attrition) 

reg bl_speed  pref_office i.wave i.test if wave>3 & sample>1, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_women", append  $outreg_setting ctitle(Post , Attrition) 

reg bl_speed  ad_office  i.wave i.test if wave>3 & sample>1, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_women", append  $outreg_setting ctitle(Post , Attrition) 

reg bl_speed  pref_office ad_office  i.wave i.test if wave>3 & sample>1, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_women", append  $outreg_setting ctitle(Post , Attrition) 

reg bl_speed  pref_office ad_office c.pref_office#c.ad_office i.wave i.test if wave>3 & sample>1, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_women", append  $outreg_setting ctitle(Post , Attrition) 
restore


*Married Female
preserve 
keep if w_demo_Gender ==1 & w_demo_Married==1

reg bl_speed  pref_office i.wave i.test if wave>3 & sample>0, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_fem_mar", replace  $outreg_setting ctitle(Pre , Attrition) 

reg bl_speed  ad_office  i.wave i.test if wave>3 & sample>0, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_fem_mar", append  $outreg_setting ctitle(Pre , Attrition) 

reg bl_speed  pref_office ad_office  i.wave i.test if wave>3 & sample>0, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_fem_mar", append  $outreg_setting ctitle(Pre , Attrition) 

reg bl_speed  pref_office ad_office c.pref_office#c.ad_office i.wave i.test if wave>3 & sample>0, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_fem_mar", append  $outreg_setting ctitle(Pre , Attrition) 

reg bl_speed  pref_office i.wave i.test if wave>3 & sample>1, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_fem_mar", append  $outreg_setting ctitle(Post , Attrition) 

reg bl_speed  ad_office  i.wave i.test if wave>3 & sample>1, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_fem_mar", append  $outreg_setting ctitle(Post , Attrition) 

reg bl_speed  pref_office ad_office  i.wave i.test if wave>3 & sample>1, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_fem_mar", append  $outreg_setting ctitle(Post , Attrition) 

reg bl_speed  pref_office ad_office c.pref_office#c.ad_office i.wave i.test if wave>3 & sample>1, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_fem_mar", append  $outreg_setting ctitle(Post , Attrition) 
restore


**Age
*Old
preserve 
keep if w_demo_Age >24

reg bl_speed  pref_office i.wave i.test if wave>3 & sample>0, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_old", replace  $outreg_setting ctitle(Pre , Attrition) 

reg bl_speed  ad_office  i.wave i.test if wave>3 & sample>0, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_old", append  $outreg_setting ctitle(Pre , Attrition) 

reg bl_speed  pref_office ad_office  i.wave i.test if wave>3 & sample>0, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_old", append  $outreg_setting ctitle(Pre , Attrition) 

reg bl_speed  pref_office ad_office c.pref_office#c.ad_office i.wave i.test if wave>3 & sample>0, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_old", append  $outreg_setting ctitle(Pre , Attrition) 

reg bl_speed  pref_office i.wave i.test if wave>3 & sample>1, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_old", append  $outreg_setting ctitle(Post , Attrition) 

reg bl_speed  ad_office  i.wave i.test if wave>3 & sample>1, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_old", append  $outreg_setting ctitle(Post , Attrition) 

reg bl_speed  pref_office ad_office  i.wave i.test if wave>3 & sample>1, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_old", append  $outreg_setting ctitle(Post , Attrition) 

reg bl_speed  pref_office ad_office c.pref_office#c.ad_office i.wave i.test if wave>3 & sample>1, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_old", append  $outreg_setting ctitle(Post , Attrition) 
restore


*Young
preserve 
keep if w_demo_Age <25

reg bl_speed  pref_office i.wave i.test if wave>3 & sample>0, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_young", replace  $outreg_setting ctitle(Pre , Attrition) 

reg bl_speed  ad_office  i.wave i.test if wave>3 & sample>0, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_young", append  $outreg_setting ctitle(Pre , Attrition) 

reg bl_speed  pref_office ad_office  i.wave i.test if wave>3 & sample>0, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_young", append  $outreg_setting ctitle(Pre , Attrition) 

reg bl_speed  pref_office ad_office c.pref_office#c.ad_office i.wave i.test if wave>3 & sample>0, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_young", append  $outreg_setting ctitle(Pre , Attrition) 

reg bl_speed  pref_office i.wave i.test if wave>3 & sample>1, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_young", append  $outreg_setting ctitle(Post , Attrition) 

reg bl_speed  ad_office  i.wave i.test if wave>3 & sample>1, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_young", append  $outreg_setting ctitle(Post , Attrition) 

reg bl_speed  pref_office ad_office  i.wave i.test if wave>3 & sample>1, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_young", append  $outreg_setting ctitle(Post , Attrition) 

reg bl_speed  pref_office ad_office c.pref_office#c.ad_office i.wave i.test if wave>3 & sample>1, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_young", append  $outreg_setting ctitle(Post , Attrition) 
restore


***Work experience 
*no workexp
preserve 
keep if w_wrkex_PreviousWorkExYear == 0

reg bl_speed  pref_office i.wave i.test if wave>3 & sample>0, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_no_wrkex", replace  $outreg_setting ctitle(Pre , Attrition) 

reg bl_speed  ad_office  i.wave i.test if wave>3 & sample>0, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_no_wrkex", append  $outreg_setting ctitle(Pre , Attrition) 

reg bl_speed  pref_office ad_office  i.wave i.test if wave>3 & sample>0, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_no_wrkex", append  $outreg_setting ctitle(Pre , Attrition) 

reg bl_speed  pref_office ad_office c.pref_office#c.ad_office i.wave i.test if wave>3 & sample>0, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_no_wrkex", append  $outreg_setting ctitle(Pre , Attrition) 

reg bl_speed  pref_office i.wave i.test if wave>3 & sample>1, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_no_wrkex", append  $outreg_setting ctitle(Post , Attrition) 

reg bl_speed  ad_office  i.wave i.test if wave>3 & sample>1, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_no_wrkex", append  $outreg_setting ctitle(Post , Attrition) 

reg bl_speed  pref_office ad_office  i.wave i.test if wave>3 & sample>1, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_no_wrkex", append  $outreg_setting ctitle(Post , Attrition) 

reg bl_speed  pref_office ad_office c.pref_office#c.ad_office i.wave i.test if wave>3 & sample>1, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_no_wrkex", append  $outreg_setting ctitle(Post , Attrition) 
restore


*Young
preserve 
keep if w_wrkex_PreviousWorkExYear>0 & w_wrkex_PreviousWorkExYear<=2

reg bl_speed  pref_office i.wave i.test if wave>3 & sample>0, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_lit_wrkex", replace  $outreg_setting ctitle(Pre , Attrition) 

reg bl_speed  ad_office  i.wave i.test if wave>3 & sample>0, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_lit_wrkex", append  $outreg_setting ctitle(Pre , Attrition) 

reg bl_speed  pref_office ad_office  i.wave i.test if wave>3 & sample>0, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_lit_wrkex", append  $outreg_setting ctitle(Pre , Attrition) 

reg bl_speed  pref_office ad_office c.pref_office#c.ad_office i.wave i.test if wave>3 & sample>0, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_lit_wrkex", append  $outreg_setting ctitle(Pre , Attrition) 

reg bl_speed  pref_office i.wave i.test if wave>3 & sample>1, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_lit_wrkex", append  $outreg_setting ctitle(Post , Attrition) 

reg bl_speed  ad_office  i.wave i.test if wave>3 & sample>1, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_lit_wrkex", append  $outreg_setting ctitle(Post , Attrition) 

reg bl_speed  pref_office ad_office  i.wave i.test if wave>3 & sample>1, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_lit_wrkex", append  $outreg_setting ctitle(Post , Attrition) 

reg bl_speed  pref_office ad_office c.pref_office#c.ad_office i.wave i.test if wave>3 & sample>1, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_lit_wrkex", append  $outreg_setting ctitle(Post , Attrition) 
restore


preserve 
keep if  w_wrkex_PreviousWorkExYear>2

reg bl_speed  pref_office i.wave i.test if wave>3 & sample>0, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_lot_wrkex", replace  $outreg_setting ctitle(Pre , Attrition) 

reg bl_speed  ad_office  i.wave i.test if wave>3 & sample>0, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_lot_wrkex", append  $outreg_setting ctitle(Pre , Attrition) 

reg bl_speed  pref_office ad_office  i.wave i.test if wave>3 & sample>0, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_lot_wrkex", append  $outreg_setting ctitle(Pre , Attrition) 

reg bl_speed  pref_office ad_office c.pref_office#c.ad_office i.wave i.test if wave>3 & sample>0, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_lot_wrkex", append  $outreg_setting ctitle(Pre , Attrition) 

reg bl_speed  pref_office i.wave i.test if wave>3 & sample>1, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_lot_wrkex", append  $outreg_setting ctitle(Post , Attrition) 

reg bl_speed  ad_office  i.wave i.test if wave>3 & sample>1, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_lot_wrkex", append  $outreg_setting ctitle(Post , Attrition) 

reg bl_speed  pref_office ad_office  i.wave i.test if wave>3 & sample>1, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_lot_wrkex", append  $outreg_setting ctitle(Post , Attrition) 

reg bl_speed  pref_office ad_office c.pref_office#c.ad_office i.wave i.test if wave>3 & sample>1, cluster( recruitmentid_new )
outreg2 using "$regdir\ability_lot_wrkex", append  $outreg_setting ctitle(Post , Attrition) 
restore



*************************************************************************************************************************************************
***Whats driving negative selection effect 

gen reason=w_wrkpref_hom_reason
replace reason=w_wrkpref_off_reason+10 if reason==.

label define reason 1 "h_expenses" ///
					2 "h_flexibility" ///
					3 "h_parttime_comm" ///
					4 "h_travel" ///
					5 "h_comfortable" ///
					6 "h_otherjob" ///
					7 "h_familycare" ///
					8 "h_permission" ///
					9 "h_negative" ///
					10 "h_others" ///
					11 "o_office_environ" ///
					12 "o_convinient" ///
					13 "o_9to5" ///
					14 "o_nodisturb" ///
					15 "o_network" ///
					16 "o_ease of solving issue" ///
					17 "o_getexperience" ///
					18 "o_others", replace
label value reason reason
				
reg bl_speed  i.reason i.wave i.test if wave>3 & sample>0, cluster( recruitmentid_new )
margins reason
marginsplot, horizontal   plotopts(connect(i))	xline(3.383053)

reg bl_speed  i.reason##i.w_demo_Gender  i.wave i.test if wave>3 & sample>0, cluster( recruitmentid_new )
margins reason#w_demo_Gender
marginsplot, by(w_demo_Gender) horizontal   plotopts(connect(i))	xline(3.383053)



foreach x of var w_wrkpref_Reasons4Home_1 w_wrkpref_Reasons4Home_2 w_wrkpref_Reasons4Home_3 w_wrkpref_Reasons4Home_4 w_wrkpref_Reasons4Home_5 w_wrkpref_Reasons4Home_6 w_wrkpref_Reasons4Home_7 w_wrkpref_Reasons4Home_8 w_wrkpref_Reasons4Home_9 w_wrkpref_Reasons4Home_10 w_wrkpref_Reasons4Office_1 w_wrkpref_Reasons4Office_2 w_wrkpref_Reasons4Office_3 w_wrkpref_Reasons4Office_4 w_wrkpref_Reasons4Office_5 w_wrkpref_Reasons4Office_6 w_wrkpref_Reasons4Office_7 w_wrkpref_Reasons4Office_8 w_wrkpref_Reasons4Office_9{
gen `x'_1=(`x'!=.)
}

/*
w_wrkpref_o_office_environ w_wrkpref_o_convinient w_wrkpref_o_9to5 w_wrkpref_o_nodisturb w_wrkpref_o_network  w_wrkpref_o_others w_o_easeissues w_o_getexperience

  

w_wrkpref_h_others
w_wrkpref_h_travel
w_wrkpref_h_comfortable
w_wrkpref_h_permission
w_wrkpref_o_others
*/


*****************************************************************************************************************
*****************************************************************************************************************


rename (w_wrkpref_h_expenses w_wrkpref_h_flexibility w_wrkpref_h_parttime_comm  w_wrkpref_h_otherjob w_h_negative w_wrkpref_h_familycare)  ///
(h_expenses h_flexibility h_parttime_comm  h_otherjob h_negative h_familycare)

rename (w_wrkpref_o_office_environ w_wrkpref_o_convinient w_wrkpref_o_9to5 w_wrkpref_o_nodisturb w_wrkpref_o_network   w_o_easeissues w_o_getexperience) ///
(o_office_environ o_convinient o_9to5 o_nodisturb o_network o_easeissues o_getexperience)

reg bl_speed   h_expenses h_flexibility h_parttime_comm  h_otherjob h_negative h_familycare  ///
o_office_environ o_convinient o_9to5 o_nodisturb o_network o_easeissues o_getexperience ///
i.wave i.test if wave>3 & sample>0, cluster( recruitmentid_new )


*Seeing if any particular reason sticks out. 
*/
***Cleaning Reason Data********************

drop _merge w_*
merge m:1 recruitmentid_new using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\03. Datasets\31. Surveys\312. walk in\3124. Final Dataset\Walkin_Cleaned_Encoded.dta"
drop if _merge==1
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


*education
gen w_edu_years= 8 if w_edu_HighestEducation==1
replace w_edu_years= 10 if w_edu_HighestEducation==2
replace w_edu_years= 12 if w_edu_HighestEducation==3
replace w_edu_years= 14 if w_edu_HighestEducation==4
replace w_edu_years= 16 if w_edu_HighestEducation==5 |  w_edu_HighestEducation==7
replace w_edu_years= 18 if w_edu_HighestEducation==6


gen p_pre=.
gen b_pre=.
gen se_pre=.
gen p_post=.
gen b_post=.
gen se_post=.

gen pref_home=1-pref_off

global i=1

foreach x of varlist o_nodisturb o_network o_convinient o_easeissues  o_9to5 o_office_environ  o_getexperience{ 

reg bl_speed pref_office c.pref_office#c.`x' i.wave i.test if wave>3 & sample>0, cluster( recruitmentid_new )

replace b_pre= _b[c.pref_office#c.`x'] in $i
replace se_pre= _se[c.pref_office#c.`x'] in $i
replace p_pre= _b[pref_office] in  $i

global i= $i + 1
}


foreach x of varlist h_expenses h_parttime_comm h_travel h_familycare  { 

reg bl_speed pref_home  c.pref_home#c.`x' i.wave i.test if wave>3 & sample>0, cluster( recruitmentid_new )

replace b_pre= _b[c.pref_home#c.`x'] in $i
replace se_pre= _se[c.pref_home#c.`x'] in $i
replace p_pre= _b[pref_home] in  $i

global i= $i + 1
}


global i=1

foreach x of varlist o_nodisturb o_network o_convinient o_easeissues  o_9to5 o_office_environ  o_getexperience{ 

reg bl_speed pref_office c.pref_office#c.`x' i.wave i.test if wave>3 & sample>1, cluster( recruitmentid_new )

replace b_post= _b[c.pref_office#c.`x'] in $i
replace se_post= _se[c.pref_office#c.`x'] in $i
replace p_post= _b[pref_office] in  $i

global i= $i + 1
}


foreach x of varlist h_expenses h_parttime_comm h_travel h_familycare{ 

reg bl_speed pref_home  c.pref_home#c.`x' i.wave i.test if wave>3 & sample>1, cluster( recruitmentid_new )

replace b_post= _b[c.pref_home#c.`x'] in $i
replace se_post= _se[c.pref_home#c.`x'] in $i
replace p_post= _b[pref_home] in  $i

global i= $i + 1
}


gen lb= b - 1.96*se
gen ub= b + 1.96*se





