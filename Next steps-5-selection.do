set mem 5g
set more off

global workdir "C:\Users\sumit\Documents\Work\Worker Sorting\My work"
global regdir "$workdir\tex files\regressions"

do "$workdir\cleaning.do"

global covars "i.week i.wave i.section"
global outreg_setting "noni addtext(Section+Week+Wave FE, Yes) auto(3)"
global opt = "keep(pref_office Train_Pref ad_office alloc_off) nonotes nor2 noni nocons auto(3)"


/******************/
/*Selection effect*/
/******************/


global i=1

foreach x of varlist ln_n_speed_cash ln_n_speed_plain ln_avg16_n_speed_s  ln_speed_60min{

reg `x'  pref_office ad_office alloc_off i.wave if  wave>1, cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", replace  ctitle(All waves) $opt

reg `x' pref_office ad_office alloc_off i.wave if  wave==5 , cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append ctitle(Wave 3.5) $opt

reg `x' pref_office ad_office alloc_off i.wave if  wave==6, cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(Wave 4) $opt

reg `x' pref_office ad_office alloc_off i.wave if  wave>4 , cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(Wave 3.5 \& 4) $opt

reg `x' Train_Pref ad_office alloc_off if  wave>1, cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(All waves) $opt
 
reg `x' Train_Pref ad_office alloc_off if  wave==5 , cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(Wave 3.5) $opt

reg `x' Train_Pref ad_office alloc_off if  wave==6, cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(Wave 4) $opt

reg `x' Train_Pref ad_office alloc_off if  wave>4 , cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(Wave 3.5 \& 4)  $opt

global i= $i + 1
}

g comp_speed= ln_n_speed_cash if user_n==1
replace comp_speed= ln_n_speed_plain if user_n==2
replace comp_speed= ln_speed_60min if user_n==3
replace comp_speed= ln_avg16_n_speed_s if user_n==4

{
reg comp_speed  pref_office ad_office alloc_off i.wave if user_n<5 & wave>1, cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", replace  ctitle(All waves) $opt

reg comp_speed pref_office ad_office alloc_off i.wave if user_n<5 & wave==5 , cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append ctitle(Wave 3.5) $opt

reg comp_speed pref_office ad_office alloc_off i.wave if user_n<5 & wave==6, cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append  ctitle(Wave 4) $opt

reg comp_speed pref_office ad_office alloc_off i.wave if user_n<5 & wave>4 , cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append  ctitle(Wave 3.5 \& 4) $opt

reg comp_speed  Train_Pref ad_office alloc_off i.wave if user_n<5 & wave>1, cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append  ctitle(All waves) $opt

reg comp_speed Train_Pref ad_office alloc_off i.wave if user_n<5 & wave==5 , cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append ctitle(Wave 3.5) $opt

reg comp_speed Train_Pref ad_office alloc_off i.wave if user_n<5 & wave==6, cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append  ctitle(Wave 4) $opt

reg comp_speed Train_Pref ad_office alloc_off i.wave if user_n<5 & wave>4 , cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append  ctitle(Wave 3.5 \& 4) $opt
}

*2.a
{
reg ln_avg16_n_speed_s  pref_office ad_office i.wave if  ad_type!="", cluster( person_week )
outreg2 using "$regdir\t21.tex", replace  noni auto(3) ctitle(All waves)

reg ln_avg16_n_speed_s  pref_office ad_office alloc_off i.wave if  ad_type!="", cluster( person_week )
outreg2 using "$regdir\t21.tex", append  noni auto(3) ctitle(All waves)

reg ln_avg16_n_speed_s  pref_office ad_office if wave==5 &  ad_type!="", cluster(person_week)
outreg2 using "$regdir\t21.tex", append  noni auto(3) ctitle(Wave 3.5)

reg ln_avg16_n_speed_s  pref_office ad_office alloc_off if wave==5 &  ad_type!="", cluster(person_week)
outreg2 using "$regdir\t21.tex", append  noni  auto(3) ctitle(Wave 3.5)

reg ln_avg16_n_speed_s  pref_office ad_office if wave==6 &  ad_type!="", cluster(person_week)
outreg2 using "$regdir\t21.tex", append  noni  auto(3) ctitle(Wave 4)

reg ln_avg16_n_speed_s  pref_office ad_office alloc_off if wave==6 &  ad_type!="", cluster(person_week)
outreg2 using "$regdir\t21.tex", append  noni  auto(3) ctitle(Wave 4)

reg ln_avg16_n_speed_s  pref_office ad_office i.wave if wave>4 &  ad_type!="", cluster(person_week)
outreg2 using "$regdir\t21.tex", append  noni  auto(3) ctitle(Wave 3.5 \& 4)

reg ln_avg16_n_speed_s  pref_office ad_office alloc_off i.wave if wave>4 &  ad_type!="", cluster(person_week)
outreg2 using "$regdir\t21.tex", append  noni  auto(3) ctitle(Wave 3.5 \& 4)
}



**************************
*Update 5- wanted to see how advert*preference groups behave before the allocation has an impact
**************************


*Baseline speed measures
g comp_speed= ln_n_speed_cash if user_n==1
replace comp_speed= ln_n_speed_plain if user_n==2
replace comp_speed= ln_speed_60min if user_n==3
replace comp_speed= ln_avg16_n_speed_s if user_n==4

bysort recruitmentid_new week: gen no_survey_week=_N
gen weight_fw=1/no_survey_week 

/*
{
reg comp_speed  pref_office#ad_office i.wave if user_n<4 & wave>1, cluster( recruitmentid_new )
margins pref_office#ad_office 
marginsplot
outreg2 using "$regdir\t15.tex", replace  ctitle(All waves) $opt

reg comp_speed pref_office#ad_office if user_n<4 & wave==5 , cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", replace ctitle(Wave 3.5) $opt

reg comp_speed pref_office#ad_office  if user_n<4 & wave==6, cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append  ctitle(Wave 4) $opt

reg comp_speed pref_office#ad_office#alloc_off  i.wave if user_n<4 & wave>4 , cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append  ctitle(Wave 3.5 \& 4) $opt
}

*graph combine a9 a10, graphregion(color(white)) ycom



*all weeks & preference*ad groups

reg ln_n_speed_s  pref_office#ad_office  i.section i.week i.wave [pw=weight], cluster( person_week )
outreg2 using "$regdir\t2121.tex", replace  $outreg_setting ctitle(All waves)


reg ln_n_speed_s  pref_office#ad_office i.section i.week i.wave [pw=weight] if wave==5, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5)


reg ln_n_speed_s  pref_office#ad_office i.section i.week i.wave [pw=weight] if wave==6, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)


reg ln_n_speed_s  pref_office#ad_office  i.section i.week i.wave [pw=weight] if wave>4 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)


*all weeks & preference*ad*allocation groups

reg ln_n_speed_s  pref_office#ad_office#alloc_off  i.section i.week i.wave [pw=weight], cluster( person_week )
outreg2 using "$regdir\t2121.tex", replace  $outreg_setting ctitle(All waves)


reg ln_n_speed_s  pref_office#ad_office#alloc_off i.section i.week i.wave [pw=weight] if wave==5, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5)


reg ln_n_speed_s  pref_office#ad_office#alloc_off i.section i.week i.wave [pw=weight] if wave==6, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)


reg ln_n_speed_s  pref_office#ad_office#alloc_off#i.week  i.section i.wave [pw=weight] if wave>4 , cluster(person_week)
margins i.week#pref_office#ad_office#alloc_off
marginsplot
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)
*/



reg comp_speed ad_office#pref_office#alloc_off if user_n<4 & wave==5 , cluster( recruitmentid_new )
outreg2 using "$regdir\t1.tex", replace ctitle(Wave 3.5) $outreg_setting

reg ln_n_speed_s  ad_office#pref_office#alloc_off i.section i.week i.wave [pw=weight_fw] if week==1 & wave==5, cluster(person_week)
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s  ad_office#pref_office#alloc_off i.section i.week i.wave [pw=weight] if wave==5, cluster(person_week)
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5)



*****This shit works I think !


*Baseline speed
reg comp_speed pref_office#ad_office#alloc_off  i.wave if user_n<4 & wave>4 , cluster( recruitmentid_new )

margins pref_office#ad_office#alloc_off 
marginsplot, name(a9, replace) scale(0.7) 

margins ad_office#pref_office#alloc_off 
marginsplot, name(a10, replace) scale(0.7) 

margins alloc_off#ad_office#pref_office
marginsplot, name(a11, replace) scale(0.7) 

graph combine a9 a10 a11, graphregion(color(white)) ycom col(3)


gen week_new=week 
replace week_new=2 if week>2
label define week_new 1 "First" 2 "Second+" 
label val week_new week_new 

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



*week1 speed
bysort recruitmentid_new week: gen no_survey_week=_N
gen weight_fw=1/no_survey_week 

***Attempt no. 2
*First week
reg ln_n_speed_s  pref_office#ad_office#alloc_off  i.wave  i.section  [pw=weight_fw] if  wave>4 & week==1, cluster( person_week )

margins pref_office#ad_office#alloc_off 
marginsplot, name(a9a, replace) scale(0.7) 

margins ad_office#pref_office#alloc_off 
marginsplot, name(a10a, replace) scale(0.7) 

margins alloc_off#ad_office#pref_office
marginsplot, name(a11a, replace) scale(0.7)

graph combine a9 a10 a11 a9a a10a a11a, graphregion(color(white)) ycom col(3)



*All weeks- overall 
reg ln_n_speed_s  pref_office#ad_office#alloc_off  i.wave i.week i.section  [pw=weight] if  wave>4, cluster( person_week )

margins pref_office#ad_office#alloc_off 
marginsplot, name(a9b, replace) scale(0.7) 

margins ad_office#pref_office#alloc_off 
marginsplot, name(a10b, replace) scale(0.7) 

margins alloc_off#ad_office#pref_office 
marginsplot, name(a11b, replace) scale(0.7)  

graph combine a9 a10 a11 a9a a10a a11a a9b a10b a11b, graphregion(color(white)) ycom


*All weeks- learning only 
gen learning=ln_n_speed_s-ln_avg16_n_speed_s

reg learning  pref_office#ad_office#alloc_off  i.wave i.week i.section  [pw=weight] if  wave>4, cluster( person_week )

margins pref_office#ad_office#alloc_off 
marginsplot, name(a9, replace) scale(0.7) 

margins ad_office#pref_office#alloc_off 
marginsplot, name(a10, replace) scale(0.7) 

margins alloc_off#ad_office#pref_office 
marginsplot, name(a11, replace) scale(0.7)  

graph combine a9 a10 a11, graphregion(color(white)) ycom



***Attempt no. 3
reg ln_n_speed_s  i.week_new#i.type  i.wave  i.section  [pw=weight] if  wave>4 , cluster( person_week )
margins i.type#i.week_new
marginsplot 


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


***Attempt no. 4

*Preference Effect
reg comp_speed pref_office i.wave if user_n<5 & wave>1, cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", replace  ctitle(All waves) keep(pref_office) nor2 noni nocons auto(3)

reg ln_n_speed_s  pref_office i.wave i.section  [pw=weight_fw] if week==1 & wave>1, cluster( person_week )
outreg2 using "$regdir\t15.tex", append  ctitle(All waves) keep(pref_office) nor2 noni nocons auto(3)

reg ln_n_speed_s  pref_office i.wave i.section i.week [pw=weight] if wave>1, cluster( person_week )
outreg2 using "$regdir\t15.tex", append  ctitle(All waves) keep(pref_office) nor2 noni nocons auto(3)


reg comp_speed pref_office#type2 i.wave if user_n<5 & wave>1, cluster( recruitmentid_new )
lincom 1.pref_office#1.type2-0.pref_office#1.type2
lincom 1.pref_office#2.type2-0.pref_office#2.type2
lincom 1.pref_office#3.type2-0.pref_office#3.type2
lincom 1.pref_office#4.type2-0.pref_office#4.type2


reg ln_n_speed_s  pref_office#type2 i.wave i.section  [pw=weight_fw] if week==1 & wave>1, cluster( person_week )
lincom 1.pref_office#1.type2-0.pref_office#1.type2
lincom 1.pref_office#2.type2-0.pref_office#2.type2
lincom 1.pref_office#3.type2-0.pref_office#3.type2
lincom 1.pref_office#4.type2-0.pref_office#4.type2


reg ln_n_speed_s  pref_office#type2 i.wave i.section i.week [pw=weight] if wave>1, cluster( person_week )
lincom 1.pref_office#1.type2-0.pref_office#1.type2
lincom 1.pref_office#2.type2-0.pref_office#2.type2
lincom 1.pref_office#3.type2-0.pref_office#3.type2
lincom 1.pref_office#4.type2-0.pref_office#4.type2


*Wave 2 & 3
reg comp_speed pref_office i.wave if user_n<5 & wave>1 & wave<5, cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", replace  ctitle(All waves) keep(pref_office) nor2 noni nocons auto(3)

reg ln_n_speed_s  pref_office i.wave i.section  [pw=weight_fw] if week==1 & wave>1 & wave<5, cluster( person_week )
outreg2 using "$regdir\t15.tex", append  ctitle(All waves) keep(pref_office) nor2 noni nocons auto(3)

reg ln_n_speed_s  pref_office i.wave i.section i.week [pw=weight] if wave>1 & wave<5, cluster( person_week )
outreg2 using "$regdir\t15.tex", append  ctitle(All waves) keep(pref_office) nor2 noni nocons auto(3)


reg comp_speed pref_office#type2 i.wave if user_n<5 & wave>1 & wave<5, cluster( recruitmentid_new )
lincom 1.pref_office#1.type2-0.pref_office#1.type2
lincom 1.pref_office#2.type2-0.pref_office#2.type2
lincom 1.pref_office#3.type2-0.pref_office#3.type2
lincom 1.pref_office#4.type2-0.pref_office#4.type2


reg ln_n_speed_s  pref_office#type2 i.wave i.section  [pw=weight_fw] if week==1 & wave>1 & wave<5, cluster( person_week )
lincom 1.pref_office#1.type2-0.pref_office#1.type2
lincom 1.pref_office#2.type2-0.pref_office#2.type2
lincom 1.pref_office#3.type2-0.pref_office#3.type2
lincom 1.pref_office#4.type2-0.pref_office#4.type2


reg ln_n_speed_s  pref_office#type2 i.wave i.section i.week [pw=weight] if wave>1 & wave>1 & wave<5, cluster( person_week )
lincom 1.pref_office#1.type2-0.pref_office#1.type2
lincom 1.pref_office#2.type2-0.pref_office#2.type2
lincom 1.pref_office#3.type2-0.pref_office#3.type2
lincom 1.pref_office#4.type2-0.pref_office#4.type2


*Wave 3.5
reg comp_speed pref_office i.wave if user_n<5 & wave==5, cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", replace  ctitle(All waves) keep(pref_office) nor2 noni nocons auto(3)

reg ln_n_speed_s  pref_office i.wave i.section  [pw=weight_fw] if week==1 & wave==5, cluster( person_week )
outreg2 using "$regdir\t15.tex", append  ctitle(All waves) keep(pref_office) nor2 noni nocons auto(3)

reg ln_n_speed_s  pref_office i.wave i.section i.week [pw=weight] if wave==5, cluster( person_week )
outreg2 using "$regdir\t15.tex", append  ctitle(All waves) keep(pref_office) nor2 noni nocons auto(3)


reg comp_speed pref_office#type2 i.wave if user_n<5 & wave==5, cluster( recruitmentid_new )
lincom 1.pref_office#1.type2-0.pref_office#1.type2
lincom 1.pref_office#2.type2-0.pref_office#2.type2
lincom 1.pref_office#3.type2-0.pref_office#3.type2
lincom 1.pref_office#4.type2-0.pref_office#4.type2


reg ln_n_speed_s  pref_office#type2 i.wave i.section  [pw=weight_fw] if week==1 & wave==5, cluster( person_week )
lincom 1.pref_office#1.type2-0.pref_office#1.type2
lincom 1.pref_office#2.type2-0.pref_office#2.type2
lincom 1.pref_office#3.type2-0.pref_office#3.type2
lincom 1.pref_office#4.type2-0.pref_office#4.type2


reg ln_n_speed_s  pref_office#type2 i.wave i.section i.week [pw=weight] if wave>1 & wave==5, cluster( person_week )
lincom 1.pref_office#1.type2-0.pref_office#1.type2
lincom 1.pref_office#2.type2-0.pref_office#2.type2
lincom 1.pref_office#3.type2-0.pref_office#3.type2
lincom 1.pref_office#4.type2-0.pref_office#4.type2

*Wave 4
reg comp_speed pref_office i.wave if user_n<5 & wave==6, cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", replace  ctitle(All waves) keep(pref_office) nor2 noni nocons auto(3)

reg ln_n_speed_s  pref_office i.wave i.section  [pw=weight_fw] if week==1 & wave==6, cluster( person_week )
outreg2 using "$regdir\t15.tex", append  ctitle(All waves) keep(pref_office) nor2 noni nocons auto(3)

reg ln_n_speed_s  pref_office i.wave i.section i.week [pw=weight] if wave==6, cluster( person_week )
outreg2 using "$regdir\t15.tex", append  ctitle(All waves) keep(pref_office) nor2 noni nocons auto(3)


reg comp_speed pref_office#type2 i.wave if user_n<5 & wave==6, cluster( recruitmentid_new )
lincom 1.pref_office#1.type2-0.pref_office#1.type2
lincom 1.pref_office#2.type2-0.pref_office#2.type2
lincom 1.pref_office#3.type2-0.pref_office#3.type2
lincom 1.pref_office#4.type2-0.pref_office#4.type2


reg ln_n_speed_s  pref_office#type2 i.wave i.section  [pw=weight_fw] if week==1 & wave==6, cluster( person_week )
lincom 1.pref_office#1.type2-0.pref_office#1.type2
lincom 1.pref_office#2.type2-0.pref_office#2.type2
lincom 1.pref_office#3.type2-0.pref_office#3.type2
lincom 1.pref_office#4.type2-0.pref_office#4.type2


reg ln_n_speed_s  pref_office#type2 i.wave i.section i.week [pw=weight] if wave>1 & wave==6, cluster( person_week )
lincom 1.pref_office#1.type2-0.pref_office#1.type2
lincom 1.pref_office#2.type2-0.pref_office#2.type2
lincom 1.pref_office#3.type2-0.pref_office#3.type2
lincom 1.pref_office#4.type2-0.pref_office#4.type2
