set mem 5g
set more off

global workdir "C:\Users\sumit\Documents\Work\Worker Sorting\My work"


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

keep if user_n==1

save "C:\Users\sumit\Documents\Work\Worker Sorting\My work\dta\attrit_days.dta"


use "C:\Users\sumit\Documents\Work\Worker Sorting\03. Datasets\31. Surveys\312. walk in\3124. Final Dataset\Walkin_Cleaned_Encoded.dta", clear

merge 1:1 A1RecruitmentID using "C:\Users\sumit\Documents\Work\Worker Sorting\03. Datasets\31. Surveys\313. Baseline\3134. Final Dataset\Baseline cleaned.dta"
drop if _merge!=3
drop _merge

rename A1RecruitmentID recruitmentid_new
merge 1:1 recruitmentid_new using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\dta\attrit_days.dta"

cap drop usergroup startday startdate starttime surveyname endday enddate endtime totalperiodhhmmss timespenthhmmss idletimehhmmss totalkeystrokes incorrectkeystrokes keystrokesaccuracy totalfields filledfields emptyfields correctentries incorrectentries missedentries correctvoidentries fieldsaccuracy totalcharacters incorrectcharacters characteraccuracy startdatetime enddatetime incor_field_ incorrect_char1_ incorrect_char2_ corr_char tot_ent_char_ total_char_ corr_field entered_fields_
cap drop e_* 
cap drop time_* a_*


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


replace daysworked=1 if daysworked==.




replace pref_office= w_wrkpref_MainWalkPref if pref_office==.
replace alloc_off= w_allocation if alloc_off==.


gen pref_all=1 if alloc_off==0 & pref_office==0
replace pref_all=2 if alloc_off==1 & pref_office==0
replace pref_all=3 if alloc_off==0 & pref_office==1
replace pref_all=4 if alloc_off==1 & pref_office==1

replace wave3plus=1 if wave>4 
replace wave3plus=0 if wave<4 

***************Analysis***********

