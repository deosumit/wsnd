set mem 5g
set more off

global workdir "C:\Users\sumit\Documents\Work\Worker Sorting\My work"
global regdir "$workdir\tex files\regressions"

do "$workdir\cleaning.do"

global covars "i.week i.wave i.section"
global outreg_setting "noni addtext(Section+Week+Wave FE, Yes) auto(3)"



********************************************
**********************Attrition*************
********************************************

sort recruitmentid_new  startdatetime 
drop userweek_n 
bysort recruitmentid_new: gen userweek_n=_n
bysort recruitmentid_new: gen userweek_N=_N

preserve
drop if  userweek_n!=userweek_N
keep recruitmentid_new week wave allocation  pref_office 
rename week attrit_new 
save "C:\Users\sumit\Documents\Work\Worker Sorting\My work\dta\attrit.dta", replace 
restore

drop _merge
merge m:1 recruitmentid_new using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\dta\attrit.dta"


preserve
drop if user_n!=1
keep recruitmentid_new attrit wave allocation 
restore 

gen pref_same_alloc=(pref_office==ad_office)
gen attrit_w8=(attrit==8)
gen attrit_w4=(attrit>3)


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


*Update 4 included this! David said this is too much clutter. 

reg attrit alloc_off pref_office pref_same_alloc ad_office ln_n_speed_cash w_demo_Married w_demo_Gender w_demo_Age if user_n==1 & wave>1
outreg2 using "$regdir\t31.tex", replace auto(2) ctitle(Wave 2 $+$)

reg attrit alloc_off pref_office pref_same_alloc ad_office ln_n_speed_cash w_demo_Married w_demo_Gender w_demo_Age if user_n==1 & wave==2
outreg2 using "$regdir\t31.tex", append auto(2) ctitle(Wave 2)

reg attrit alloc_off pref_office pref_same_alloc ad_office ln_n_speed_cash w_demo_Married w_demo_Gender w_demo_Age if user_n==1 & wave==3
outreg2 using "$regdir\t31.tex", append auto(2) ctitle(Wave 3)

reg attrit alloc_off pref_office pref_same_alloc ad_office ln_n_speed_cash w_demo_Married w_demo_Gender w_demo_Age if user_n==1 & wave==5
outreg2 using "$regdir\t31.tex", append auto(2) ctitle(Wave 3.5)

reg attrit alloc_off pref_office pref_same_alloc ad_office ln_n_speed_cash w_demo_Married w_demo_Gender w_demo_Age if user_n==1 & wave==6
outreg2 using "$regdir\t31.tex", append auto(2) ctitle(Wave 4)

reg attrit_w8 alloc_off pref_office pref_same_alloc ad_office ln_n_speed_cash w_demo_Married w_demo_Gender w_demo_Age if user_n==1 & wave>1
outreg2 using "$regdir\t31.tex", append auto(2) ctitle(Wave 2 $+$)

reg attrit_w8 alloc_off pref_office pref_same_alloc ad_office ln_n_speed_cash w_demo_Married w_demo_Gender w_demo_Age if user_n==1 & wave==2
outreg2 using "$regdir\t31.tex", append auto(2) ctitle(Wave 2)

reg attrit_w8 alloc_off pref_office pref_same_alloc ad_office ln_n_speed_cash w_demo_Married w_demo_Gender w_demo_Age if user_n==1 & wave==3
outreg2 using "$regdir\t31.tex", append auto(2) ctitle(Wave 3)

reg attrit_w8 alloc_off pref_office pref_same_alloc ad_office ln_n_speed_cash w_demo_Married w_demo_Gender w_demo_Age if user_n==1 & wave==5
outreg2 using "$regdir\t31.tex", append auto(2) ctitle(Wave 3.5)

reg attrit_w8 alloc_off pref_office pref_same_alloc ad_office ln_n_speed_cash w_demo_Married w_demo_Gender w_demo_Age if user_n==1 & wave==6
outreg2 using "$regdir\t31.tex", append auto(2) ctitle(Wave 4)

reg attrit_w4 alloc_off pref_office pref_same_alloc ad_office ln_n_speed_cash w_demo_Married w_demo_Gender w_demo_Age if user_n==1 & wave>1
outreg2 using "$regdir\t31.tex", append auto(2) ctitle(Wave 2 $+$)

reg attrit_w4 alloc_off pref_office pref_same_alloc ad_office ln_n_speed_cash w_demo_Married w_demo_Gender w_demo_Age if user_n==1 & wave==2
outreg2 using "$regdir\t31.tex", append auto(2) ctitle(Wave 2)

reg attrit_w4 alloc_off pref_office pref_same_alloc ad_office ln_n_speed_cash w_demo_Married w_demo_Gender w_demo_Age if user_n==1 & wave==3
outreg2 using "$regdir\t31.tex", append auto(2) ctitle(Wave 3)

reg attrit_w4 alloc_off pref_office pref_same_alloc ad_office ln_n_speed_cash w_demo_Married w_demo_Gender w_demo_Age if user_n==1 & wave==5
outreg2 using "$regdir\t31.tex", append auto(2) ctitle(Wave 3.5)

reg attrit_w4 alloc_off pref_office pref_same_alloc ad_office ln_n_speed_cash w_demo_Married w_demo_Gender w_demo_Age if user_n==1 & wave==6
outreg2 using "$regdir\t31.tex", append auto(2) ctitle(Wave 4)





*Update 5
*Week of attrition
reg attrit i.type if user_n==1 & wave>1
margins i.type 
marginsplot,scale(0.7) name(a1, replace) title("All Waves") ytitle("") graphregion(color(white)) ciop(lp(dot))


reg attrit i.wave_new#i.type if user_n==1 & wave>1
margins i.type#i.wave_new 
marginsplot, scale(0.7) noci name(a2, replace) title("Wave-wise") ytitle("") graphregion(color(white)) legend(pos(5) ring(0) col(1))

graph combine a1 a2, graphregion(color(white)) ycom col(2) title("")


*All 8 weeks 
reg attrit_w8 i.type if user_n==1 & wave>1
margins i.type 
marginsplot,scale(0.7) name(a1, replace) title("All Waves") ytitle("") graphregion(color(white)) ciop(lp(dot))


reg attrit_w8 i.wave_new#i.type if user_n==1 & wave>1
margins i.type#i.wave_new 
marginsplot, scale(0.7) noci name(a2, replace) title("Wave-wise") ytitle("") graphregion(color(white)) legend(pos(5) ring(0) col(1))

graph combine a1 a2, graphregion(color(white)) ycom col(2) title("")


*More than 4 weeks
reg attrit_w4 i.type if user_n==1 & wave>1
margins i.type 
marginsplot,scale(0.7) name(a1, replace) title("All Waves") ytitle("") graphregion(color(white)) ciop(lp(dot))


reg attrit_w4 i.wave_new#i.type if user_n==1 & wave>1
margins i.type#i.wave_new 
marginsplot, scale(0.7) noci name(a2, replace) title("Wave-wise") ytitle("") graphregion(color(white)) legend(pos(5) ring(0) col(1))

graph combine a1 a2, graphregion(color(white)) ycom col(2) title("")


*Does the high incentive works 

gen high_incentive= 1 if Add==`"C5"'
replace high_incentive= 1 if Add==`"C6"'
replace high_incentive= 1 if Add==`"C7"'
replace high_incentive= 1 if Add==`"C8"'
replace high_incentive= 1 if Add==`"D78"'
replace high_incentive= 1 if Add==`"B10"'
replace high_incentive= 1 if Add==`"B11"'
replace high_incentive= 0 if high_incentive==. & wave==6
replace high_incentive= 1 if wave==5



*Low incentive- incentivised people to stay longer. 
reg attrit high_incentive if user_n==1 & wave==6
outreg2 using "$regdir\t.tex", replace auto(2) ctitle("Week of attrition")

reg attrit_w8 high_incentive if user_n==1 & wave==6
outreg2 using "$regdir\t.tex", append auto(2) ctitle("Week of attrition")

reg attrit_w4 high_incentive if user_n==1 & wave==6
outreg2 using "$regdir\t.tex", append auto(2) ctitle("Week of attrition")

*Subgroups
reg attrit_w8 high_incentive if user_n==1 & wave==6 & alloc_off==0
outreg2 using "$regdir\t.tex", append auto(2) ctitle("Home Workers")

reg attrit_w8 high_incentive if user_n==1 & wave==6 & alloc_off==1
outreg2 using "$regdir\t.tex", append auto(2) ctitle("Office Workers")

reg attrit_w8 high_incentive if user_n==1 & wave==6 & pref_office==0
outreg2 using "$regdir\t.tex", append auto(2) ctitle("Pref. Home")

reg attrit_w8 high_incentive if user_n==1 & wave==6 & pref_office==1
outreg2 using "$regdir\t.tex", append auto(2) ctitle("Pref. Office")

reg attrit_w8 high_incentive if user_n==1 & wave==6 & ad_office==0
outreg2 using "$regdir\t.tex", append auto(2) ctitle("Home Ad")

reg attrit_w8 high_incentive if user_n==1 & wave==6 & ad_office==1
outreg2 using "$regdir\t.tex", append auto(2) ctitle("Office Ad")
*Update 5- new attempt

*Attrit 
*Allocation effect
*All waves
reg attrit alloc_off if user_n==1 & wave>1
reg attrit alloc_off#i.type1 if user_n==1 & wave>1
lincom 1.alloc_off#1.type1-0.alloc_off#1.type1
lincom 1.alloc_off#2.type1-0.alloc_off#2.type1
lincom 1.alloc_off#3.type1-0.alloc_off#3.type1
lincom 1.alloc_off#4.type1-0.alloc_off#4.type1

*Wave 2 & 3
reg attrit alloc_off if user_n==1 & wave>1 & wave<5

reg attrit alloc_off#i.type1 if user_n==1 & wave>1 & wave<5
lincom 1.alloc_off#1.type1-0.alloc_off#1.type1
lincom 1.alloc_off#2.type1-0.alloc_off#2.type1
lincom 1.alloc_off#3.type1-0.alloc_off#3.type1
lincom 1.alloc_off#4.type1-0.alloc_off#4.type1

*Wave 3.5
reg attrit alloc_off if user_n==1 & wave==5

reg attrit alloc_off#i.type1 if user_n==1 & wave==5
lincom 1.alloc_off#1.type1-0.alloc_off#1.type1
lincom 1.alloc_off#2.type1-0.alloc_off#2.type1
lincom 1.alloc_off#3.type1-0.alloc_off#3.type1
lincom 1.alloc_off#4.type1-0.alloc_off#4.type1

*Wave 4
reg attrit alloc_off if user_n==1 & wave==6

reg attrit alloc_off#i.type1 if user_n==1 & wave==6
lincom 1.alloc_off#1.type1-0.alloc_off#1.type1
lincom 1.alloc_off#2.type1-0.alloc_off#2.type1
lincom 1.alloc_off#3.type1-0.alloc_off#3.type1
lincom 1.alloc_off#4.type1-0.alloc_off#4.type1

**
*Preference Effect
reg attrit pref_office if user_n==1 & wave>1
reg attrit pref_office#i.type2 if user_n==1 & wave>1
lincom 1.pref_office#1.type2-0.pref_office#1.type2
lincom 1.pref_office#2.type2-0.pref_office#2.type2
lincom 1.pref_office#3.type2-0.pref_office#3.type2
lincom 1.pref_office#4.type2-0.pref_office#4.type2

*Wave 2 & 3
reg attrit pref_office if user_n==1 & wave>1 & wave<5

reg attrit pref_office#i.type2 if user_n==1 & wave>1 & wave<5
lincom 1.pref_office#1.type2-0.pref_office#1.type2
lincom 1.pref_office#2.type2-0.pref_office#2.type2
lincom 1.pref_office#3.type2-0.pref_office#3.type2
lincom 1.pref_office#4.type2-0.pref_office#4.type2

*Wave 3.5
reg attrit pref_office if user_n==1 & wave==5

reg attrit pref_office#i.type2 if user_n==1 & wave==5
lincom 1.pref_office#1.type2-0.pref_office#1.type2
lincom 1.pref_office#2.type2-0.pref_office#2.type2
lincom 1.pref_office#3.type2-0.pref_office#3.type2
lincom 1.pref_office#4.type2-0.pref_office#4.type2

*Wave 4
reg attrit pref_office if user_n==1 & wave==6

reg attrit pref_office#i.type2 if user_n==1 & wave==6
lincom 1.pref_office#1.type2-0.pref_office#1.type2
lincom 1.pref_office#2.type2-0.pref_office#2.type2
lincom 1.pref_office#3.type2-0.pref_office#3.type2
lincom 1.pref_office#4.type2-0.pref_office#4.type2

**
*Ad_type effect
reg attrit ad_office if user_n==1 & wave>1
reg attrit ad_office#i.type3 if user_n==1 & wave>1
lincom 1.ad_office#1.type3-0.ad_office#1.type3
lincom 1.ad_office#2.type3-0.ad_office#2.type3
lincom 1.ad_office#3.type3-0.ad_office#3.type3
lincom 1.ad_office#4.type3-0.ad_office#4.type3

*Wave 2 & 3
reg attrit ad_office if user_n==1 & wave>1 & wave<5

reg attrit ad_office#i.type3 if user_n==1 & wave>1 & wave<5
lincom 1.ad_office#1.type3-0.ad_office#1.type3
lincom 1.ad_office#2.type3-0.ad_office#2.type3
lincom 1.ad_office#3.type3-0.ad_office#3.type3
lincom 1.ad_office#4.type3-0.ad_office#4.type3

*Wave 3.5
reg attrit ad_office if user_n==1 & wave==5

reg attrit ad_office#i.type3 if user_n==1 & wave==5
lincom 1.ad_office#1.type3-0.ad_office#1.type3
lincom 1.ad_office#2.type3-0.ad_office#2.type3
lincom 1.ad_office#3.type3-0.ad_office#3.type3
lincom 1.ad_office#4.type3-0.ad_office#4.type3

*Wave 4
reg attrit ad_office if user_n==1 & wave==6

reg attrit ad_office#i.type3 if user_n==1 & wave==6
lincom 1.ad_office#1.type3-0.ad_office#1.type3
lincom 1.ad_office#2.type3-0.ad_office#2.type3
lincom 1.ad_office#3.type3-0.ad_office#3.type3
lincom 1.ad_office#4.type3-0.ad_office#4.type3

*===============================================================================

*Attrit_w8 
*Allocation effect
*All waves
reg attrit_w8 alloc_off if user_n==1 & wave>1
reg attrit_w8 alloc_off#i.type1 if user_n==1 & wave>1
lincom 1.alloc_off#1.type1-0.alloc_off#1.type1
lincom 1.alloc_off#2.type1-0.alloc_off#2.type1
lincom 1.alloc_off#3.type1-0.alloc_off#3.type1
lincom 1.alloc_off#4.type1-0.alloc_off#4.type1

*Wave 2 & 3
reg attrit_w8 alloc_off if user_n==1 & wave>1 & wave<5

reg attrit_w8 alloc_off#i.type1 if user_n==1 & wave>1 & wave<5
lincom 1.alloc_off#1.type1-0.alloc_off#1.type1
lincom 1.alloc_off#2.type1-0.alloc_off#2.type1
lincom 1.alloc_off#3.type1-0.alloc_off#3.type1
lincom 1.alloc_off#4.type1-0.alloc_off#4.type1

*Wave 3.5
reg attrit_w8 alloc_off if user_n==1 & wave==5

reg attrit_w8 alloc_off#i.type1 if user_n==1 & wave==5
lincom 1.alloc_off#1.type1-0.alloc_off#1.type1
lincom 1.alloc_off#2.type1-0.alloc_off#2.type1
lincom 1.alloc_off#3.type1-0.alloc_off#3.type1
lincom 1.alloc_off#4.type1-0.alloc_off#4.type1

*Wave 4
reg attrit_w8 alloc_off if user_n==1 & wave==6

reg attrit_w8 alloc_off#i.type1 if user_n==1 & wave==6
lincom 1.alloc_off#1.type1-0.alloc_off#1.type1
lincom 1.alloc_off#2.type1-0.alloc_off#2.type1
lincom 1.alloc_off#3.type1-0.alloc_off#3.type1
lincom 1.alloc_off#4.type1-0.alloc_off#4.type1

**
*Preference Effect
reg attrit_w8 pref_office if user_n==1 & wave>1
reg attrit_w8 pref_office#i.type2 if user_n==1 & wave>1
lincom 1.pref_office#1.type2-0.pref_office#1.type2
lincom 1.pref_office#2.type2-0.pref_office#2.type2
lincom 1.pref_office#3.type2-0.pref_office#3.type2
lincom 1.pref_office#4.type2-0.pref_office#4.type2

*Wave 2 & 3
reg attrit_w8 pref_office if user_n==1 & wave>1 & wave<5

reg attrit_w8 pref_office#i.type2 if user_n==1 & wave>1 & wave<5
lincom 1.pref_office#1.type2-0.pref_office#1.type2
lincom 1.pref_office#2.type2-0.pref_office#2.type2
lincom 1.pref_office#3.type2-0.pref_office#3.type2
lincom 1.pref_office#4.type2-0.pref_office#4.type2

*Wave 3.5
reg attrit_w8 pref_office if user_n==1 & wave==5

reg attrit_w8 pref_office#i.type2 if user_n==1 & wave==5
lincom 1.pref_office#1.type2-0.pref_office#1.type2
lincom 1.pref_office#2.type2-0.pref_office#2.type2
lincom 1.pref_office#3.type2-0.pref_office#3.type2
lincom 1.pref_office#4.type2-0.pref_office#4.type2

*Wave 4
reg attrit_w8 pref_office if user_n==1 & wave==6

reg attrit_w8 pref_office#i.type2 if user_n==1 & wave==6
lincom 1.pref_office#1.type2-0.pref_office#1.type2
lincom 1.pref_office#2.type2-0.pref_office#2.type2
lincom 1.pref_office#3.type2-0.pref_office#3.type2
lincom 1.pref_office#4.type2-0.pref_office#4.type2

**
*Ad_type effect
reg attrit_w8 ad_office if user_n==1 & wave>1
reg attrit_w8 ad_office#i.type3 if user_n==1 & wave>1
lincom 1.ad_office#1.type3-0.ad_office#1.type3
lincom 1.ad_office#2.type3-0.ad_office#2.type3
lincom 1.ad_office#3.type3-0.ad_office#3.type3
lincom 1.ad_office#4.type3-0.ad_office#4.type3

*Wave 2 & 3
reg attrit_w8 ad_office if user_n==1 & wave>1 & wave<5

reg attrit_w8 ad_office#i.type3 if user_n==1 & wave>1 & wave<5
lincom 1.ad_office#1.type3-0.ad_office#1.type3
lincom 1.ad_office#2.type3-0.ad_office#2.type3
lincom 1.ad_office#3.type3-0.ad_office#3.type3
lincom 1.ad_office#4.type3-0.ad_office#4.type3

*Wave 3.5
reg attrit_w8 ad_office if user_n==1 & wave==5

reg attrit_w8 ad_office#i.type3 if user_n==1 & wave==5
lincom 1.ad_office#1.type3-0.ad_office#1.type3
lincom 1.ad_office#2.type3-0.ad_office#2.type3
lincom 1.ad_office#3.type3-0.ad_office#3.type3
lincom 1.ad_office#4.type3-0.ad_office#4.type3

*Wave 4
reg attrit_w8 ad_office if user_n==1 & wave==6

reg attrit_w8 ad_office#i.type3 if user_n==1 & wave==6
lincom 1.ad_office#1.type3-0.ad_office#1.type3
lincom 1.ad_office#2.type3-0.ad_office#2.type3
lincom 1.ad_office#3.type3-0.ad_office#3.type3
lincom 1.ad_office#4.type3-0.ad_office#4.type3
