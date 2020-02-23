set mem 5g
set more off

global workdir "C:\Users\sumit\Documents\Work\Worker Sorting\My work"
global regdir "$workdir\tex files\regressions"

do "$workdir\cleaning.do"

global covars "i.week i.wave i.section"
global outreg_setting "noni addtext(Section+Week+Wave FE, Yes) auto(3)"

/******************/
/*Selection effect*/
/******************/

global opt = "keep(pref_office Train_Pref ad_office alloc_off) nonotes nor2 noni nocons auto(3)"

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

*Selection effect on baseline speed measures, first week and all week regressions. These regression were not used. 
{
/*
keep if user_n==1

*2.b.2
*walkin selection effec- first 4 surveys
{
*office ad
reg ln_avg16_n_speed_s pref_office if  ad_office==1, cluster( person_week )
outreg2 using "$regdir\t2121.tex", replace  $outreg_setting ctitle(All waves)

reg ln_avg16_n_speed_s pref_office alloc_off  if  ad_office==1, cluster( person_week )
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(All waves)

reg ln_avg16_n_speed_s pref_office alloc_off  c.pref_office#c.alloc_off  if  ad_office==1, cluster( person_week )
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(All waves)


reg ln_avg16_n_speed_s pref_office if wave==5 &  ad_office==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_avg16_n_speed_s pref_office alloc_off if wave==5 &  ad_office==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_avg16_n_speed_s pref_office alloc_off c.pref_office#c.alloc_off if wave==5 &  ad_office==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)


reg ln_avg16_n_speed_s pref_office if wave==6 &  ad_office==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3)

reg ln_avg16_n_speed_s pref_office alloc_off if wave==6 &  ad_office==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3)

reg ln_avg16_n_speed_s pref_office alloc_off c.pref_office#c.alloc_off if wave==6 &  ad_office==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3)


reg ln_avg16_n_speed_s pref_office  if wave>4 &  ad_office==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3 \& 4)

reg ln_avg16_n_speed_s pref_office alloc_off  if wave>4 &  ad_office==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3 \& 4)

reg ln_avg16_n_speed_s pref_office alloc_off c.pref_office#c.alloc_off  if wave>4 &  ad_office==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3 \& 4)


*Home ad

reg ln_avg16_n_speed_s pref_office if  ad_office==0, cluster( person_week )
outreg2 using "$regdir\t2122.tex", replace  $outreg_setting ctitle(All waves)

reg ln_avg16_n_speed_s pref_office alloc_off if  ad_office==0, cluster( person_week )
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(All waves)

reg ln_avg16_n_speed_s pref_office alloc_off c.pref_office#c.alloc_off if  ad_office==0, cluster( person_week )
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(All waves)


reg ln_avg16_n_speed_s pref_office if wave==5 &  ad_office==0, cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_avg16_n_speed_s pref_office alloc_off if wave==5 &  ad_office==0, cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_avg16_n_speed_s pref_office alloc_off c.pref_office#c.alloc_off if wave==5 &  ad_office==0, cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 4)


reg ln_avg16_n_speed_s pref_office if wave==6 &  ad_office==0, cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 3)

reg ln_avg16_n_speed_s pref_office alloc_off if wave==6 &  ad_office==0, cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 3)

reg ln_avg16_n_speed_s pref_office alloc_off c.pref_office#c.alloc_off if wave==6 &  ad_office==0, cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 3)


reg ln_avg16_n_speed_s pref_office if wave>4 &  ad_office==0, cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 3 \& 4)

reg ln_avg16_n_speed_s pref_office alloc_off if wave>4 &  ad_office==0, cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 3 \& 4)

reg ln_avg16_n_speed_s pref_office alloc_off c.pref_office#c.alloc_off if wave>4 &  ad_office==0, cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 3 \& 4)

}




*Training preference 
preserve
replace pref_office=Train_Pref 
{

*office ad
reg ln_avg16_n_speed_s pref_office if wave==5 &  ad_office==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", replace  $outreg_setting ctitle(Wave 4)

reg ln_avg16_n_speed_s pref_office alloc_off if wave==5 &  ad_office==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_avg16_n_speed_s pref_office alloc_off c.pref_office#c.alloc_off if wave==5 &  ad_office==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)


reg ln_avg16_n_speed_s pref_office if wave==6 &  ad_office==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3)

reg ln_avg16_n_speed_s pref_office alloc_off if wave==6 &  ad_office==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3)

reg ln_avg16_n_speed_s pref_office alloc_off c.pref_office#c.alloc_off if wave==6 &  ad_office==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3)


reg ln_avg16_n_speed_s pref_office  if wave>4 &  ad_office==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3 \& 4)

reg ln_avg16_n_speed_s pref_office alloc_off  if wave>4 &  ad_office==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3 \& 4)

reg ln_avg16_n_speed_s pref_office alloc_off c.pref_office#c.alloc_off  if wave>4 &  ad_office==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3 \& 4)


*Home ad

reg ln_avg16_n_speed_s pref_office if wave==5 &  ad_office==0, cluster(person_week)
outreg2 using "$regdir\t2122.tex", replace  $outreg_setting ctitle(Wave 4)

reg ln_avg16_n_speed_s pref_office alloc_off if wave==5 &  ad_office==0, cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_avg16_n_speed_s pref_office alloc_off c.pref_office#c.alloc_off if wave==5 &  ad_office==0, cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 4)


reg ln_avg16_n_speed_s pref_office if wave==6 &  ad_office==0, cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 3)

reg ln_avg16_n_speed_s pref_office alloc_off if wave==6 &  ad_office==0, cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 3)

reg ln_avg16_n_speed_s pref_office alloc_off c.pref_office#c.alloc_off if wave==6 &  ad_office==0, cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 3)


reg ln_avg16_n_speed_s pref_office if wave>4 &  ad_office==0, cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 3 \& 4)

reg ln_avg16_n_speed_s pref_office alloc_off if wave>4 &  ad_office==0, cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 3 \& 4)

reg ln_avg16_n_speed_s pref_office alloc_off c.pref_office#c.alloc_off if wave>4 &  ad_office==0, cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 3 \& 4)

}
restore


*Selection effect in first week 

bysort recruitmentid_new week: gen no_survey_week=_N
bysort recruitmentid_new week: egen avg_week_speed=mean(ln_n_speed_s)

{
*office ad
global covars "i.wave"

reg ln_n_speed_s pref_office $covars if  ad_office==1 & week==1 & user_week_n==1, cluster( person_week )
outreg2 using "$regdir\t2121.tex", replace  $outreg_setting ctitle(All waves)

reg ln_n_speed_s pref_office alloc_off $covars if  ad_office==1 & week==1 & user_week_n==1, cluster( person_week )
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(All waves)

reg ln_n_speed_s pref_office alloc_off  c.pref_office#c.alloc_off $covars if  ad_office==1 & week==1 & user_week_n==1, cluster( person_week )
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(All waves)


reg ln_n_speed_s pref_office $covars if wave==5 &  ad_office==1 & week==1 & user_week_n==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s pref_office alloc_off $covars if wave==5 &  ad_office==1 & week==1 & user_week_n==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  noni addtext(Week and Wave FE, Yes) auto (2) ctitle(Wave 3.5)

reg ln_n_speed_s pref_office alloc_off c.pref_office#c.alloc_off $covars if wave==5 &  ad_office==1 & week==1 & user_week_n==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5)


reg ln_n_speed_s pref_office $covars if wave==6 &  ad_office==1 & week==1 & user_week_n==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s pref_office alloc_off $covars if wave==6 &  ad_office==1 & week==1 & user_week_n==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s pref_office alloc_off c.pref_office#c.alloc_off $covars if wave==6 &  ad_office==1 & week==1 & user_week_n==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)


reg ln_n_speed_s pref_office $covars if wave>4 &  ad_office==1 & week==1 & user_week_n==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_n_speed_s pref_office alloc_off $covars if wave>4 &  ad_office==1 & week==1 & user_week_n==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_n_speed_s pref_office alloc_off c.pref_office#c.alloc_off $covars if wave>4 &  ad_office==1 & week==1 & user_week_n==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

******************


*Home ad
reg ln_n_speed_s pref_office $covars if  ad_office==0 & week==1 & user_week_n==1, cluster( person_week )
outreg2 using "$regdir\t2122.tex", replace  $outreg_setting ctitle(All waves)

reg ln_n_speed_s pref_office alloc_off $covars if  ad_office==0 & week==1 & user_week_n==1, cluster( person_week )
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(All waves)

reg ln_n_speed_s pref_office alloc_off c.pref_office#c.alloc_off  $covars if  ad_office==0 & week==1 & user_week_n==1, cluster( person_week )
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(All waves)


reg ln_n_speed_s pref_office $covars  if wave==5 &  ad_office==0 & week==1 & user_week_n==1, cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s pref_office alloc_off $covars if wave==5 &  ad_office==0 & week==1 & user_week_n==1, cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s pref_office alloc_off c.pref_office#c.alloc_off $covars if wave==5 &  ad_office==0 & week==1 & user_week_n==1, cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 4)


reg ln_n_speed_s pref_office $covars if wave==6 &  ad_office==0 & week==1 & user_week_n==1, cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 3)

reg ln_n_speed_s pref_office alloc_off $covars if wave==6 &  ad_office==0 & week==1 & user_week_n==1, cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 3)

reg ln_n_speed_s pref_office alloc_off c.pref_office#c.alloc_off $covars if wave==6 &  ad_office==0 & week==1 & user_week_n==1, cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 3)


reg ln_n_speed_s pref_office $covars if wave>4 &  ad_office==0 & week==1 & user_week_n==1, cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 3 \& 4)

reg ln_n_speed_s pref_office alloc_off $covars if wave>4 &  ad_office==0 & week==1 & user_week_n==1, cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 3 \& 4)

reg ln_n_speed_s pref_office alloc_off c.pref_office#c.alloc_off $covars if wave>4 &  ad_office==0 & week==1 & user_week_n==1, cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 3 \& 4)

}


bysort recruitmentid_new: egen avg_8weeks_speed=mean(ln_n_speed_s )
keep if user_n==1

global covars "i.wave"
*Selection effect on the entire sample
{
*office ad
{
reg avg_8weeks_speed pref_office $covars if  ad_office==1, cluster( person_week )
outreg2 using "$regdir\t2121.tex", replace  $outreg_setting ctitle(All waves)

reg avg_8weeks_speed pref_office alloc_off $covars if  ad_office==1, cluster( person_week )
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(All waves)

reg ln_n_speed_s pref_office alloc_off  c.pref_office#c.alloc_off $covars if  ad_office==1, cluster( person_week )
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(All waves)


reg avg_8weeks_speed pref_office $covars if wave==5 &  ad_office==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5)

reg avg_8weeks_speed pref_office alloc_off $covars if wave==5 &  ad_office==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5)

reg avg_8weeks_speed pref_office alloc_off c.pref_office#c.alloc_off $covars if wave==5 &  ad_office==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5)


reg avg_8weeks_speed pref_office $covars if wave==6 &  ad_office==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)

reg avg_8weeks_speed pref_office alloc_off $covars if wave==6 &  ad_office==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)

reg avg_8weeks_speed pref_office alloc_off c.pref_office#c.alloc_off $covars if wave==6 &  ad_office==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)


reg avg_8weeks_speed pref_office $covars if wave>4 &  ad_office==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg avg_8weeks_speed pref_office alloc_off $covars if wave>4 &  ad_office==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg avg_8weeks_speed pref_office alloc_off c.pref_office#c.alloc_off $covars if wave>4 &  ad_office==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)
}

*Home ad
{
reg avg_8weeks_speed pref_office $covars if  ad_office==0, cluster( person_week )
outreg2 using "$regdir\t2122.tex", replace  $outreg_setting ctitle(All waves)

reg avg_8weeks_speed pref_office alloc_off $covars if  ad_office==0, cluster( person_week )
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(All waves)

reg avg_8weeks_speed pref_office alloc_off c.pref_office#c.alloc_off  $covars if  ad_office==0, cluster( person_week )
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(All waves)


reg avg_8weeks_speed pref_office $covars  if wave==5 &  ad_office==0, cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 4)

reg avg_8weeks_speed pref_office alloc_off $covars if wave==5 &  ad_office==0, cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 4)

reg avg_8weeks_speed pref_office alloc_off c.pref_office#c.alloc_off $covars if wave==5 &  ad_office==0, cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 4)


reg avg_8weeks_speed pref_office $covars if wave==6 &  ad_office==0, cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 3)

reg avg_8weeks_speed pref_office alloc_off $covars if wave==6 &  ad_office==0, cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 3)

reg avg_8weeks_speed pref_office alloc_off c.pref_office#c.alloc_off $covars if wave==6 &  ad_office==0, cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 3)


reg avg_8weeks_speed pref_office $covars if wave>4 &  ad_office==0, cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 3 \& 4)

reg avg_8weeks_speed pref_office alloc_off $covars if wave>4 &  ad_office==0, cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 3 \& 4)

reg avg_8weeks_speed pref_office alloc_off c.pref_office#c.alloc_off $covars if wave>4 &  ad_office==0, cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 3 \& 4)
}

*Both ads
{
reg ln_n_speed_s pref_office $covars if  wave>1, cluster( person_week )
outreg2 using "$regdir\t2122.tex", replace  $outreg_setting ctitle(All waves)

reg ln_n_speed_s pref_office alloc_off $covars if  wave>1, cluster( person_week )
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(All waves)

reg ln_n_speed_s pref_office alloc_off c.pref_office#c.alloc_off  $covars if  wave>1, cluster( person_week )
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(All waves)


reg ln_n_speed_s pref_office $covars  if wave==5 , cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s pref_office alloc_off $covars if wave==5 , cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s pref_office alloc_off c.pref_office#c.alloc_off $covars if wave==5 , cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 3.5)


reg ln_n_speed_s pref_office $covars if wave==6 , cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 3)

reg ln_n_speed_s pref_office alloc_off $covars if wave==6 , cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 3)

reg ln_n_speed_s pref_office alloc_off c.pref_office#c.alloc_off $covars if wave==6 , cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 3)


reg ln_n_speed_s pref_office $covars if wave>4 , cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 3 \& 4)

reg ln_n_speed_s pref_office alloc_off $covars if wave>4 , cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 3 \& 4)

reg ln_n_speed_s pref_office alloc_off c.pref_office#c.alloc_off $covars if wave>4 , cluster(person_week)
outreg2 using "$regdir\t2122.tex", append  $outreg_setting ctitle(Wave 3 \& 4)
}
}

*/
}

*2.b.3
/*
reg ln_avg16_n_speed_s OO OH HO HH i.wave if  ad_type!="", cluster( person_week ) noc
outreg2 using "$regdir\t211.tex", replace  noni addtext(Week and Wave FE, Yes) auto(3) ctitle(All waves)

reg ln_avg16_n_speed_s OO OH HO HH alloc_off i.wave if  ad_type!="", cluster( person_week ) noc
outreg2 using "$regdir\t211.tex", append  noni addtext(Week and Wave FE, Yes) auto(3) ctitle(All waves)

reg ln_avg16_n_speed_s OO OH HO HH if wave==5 &  ad_type!="", cluster(person_week) noc
outreg2 using "$regdir\t211.tex", append  noni addtext(Week and Wave FE, Yes) auto(3) ctitle(Wave 3.5)

reg ln_avg16_n_speed_s OO OH HO HH alloc_off if wave==5 &  ad_type!="", cluster(person_week) noc
outreg2 using "$regdir\t211.tex", append  noni addtext(Week and Wave FE, Yes) auto(3) ctitle(Wave 3.5)

reg ln_avg16_n_speed_s OO OH HO HH if wave==6 &  ad_type!="", cluster(person_week) noc
outreg2 using "$regdir\t211.tex", append  noni addtext(Week and Wave FE, Yes) auto(3) ctitle(Wave 4)

reg ln_avg16_n_speed_s OO OH HO HH alloc_off if wave==6 &  ad_type!="", cluster(person_week) noc
outreg2 using "$regdir\t211.tex", append  noni addtext(Week and Wave FE, Yes) auto(3) ctitle(Wave 4)

reg ln_avg16_n_speed_s OO OH HO HH i.wave if wave>4 &  ad_type!="", cluster(person_week) noc
outreg2 using "$regdir\t211.tex", append  noni addtext(Week and Wave FE, Yes) auto(3) ctitle(Wave 3.5 \& 4)

reg ln_avg16_n_speed_s OO OH HO HH alloc_off i.wave if wave>4 &  ad_type!="", cluster(person_week) noc
outreg2 using "$regdir\t211.tex", append  noni addtext(Week and Wave FE, Yes) auto(3) ctitle(Wave 3.5 \& 4)

*2.c
 foreach lname of varlist w_demo_Age w_demo_ChildrenNum w_wrkex_PreviousWorkExYear w_wrkex_NumOfJobsDoneBefore w_empstat_DE_WrkEx_yrs w_demo_Gender w_demo_Married w_demo_distance w_edu_HighestEducation w_wrkex_PreviousWorkEx apt_math apt_english apt_puzzle apt_total    {
	estpost ttest `lname' if user_n==1, by (wave4)
 }
 
foreach lname of varlist w_demo_Age w_demo_ChildrenNum w_wrkex_PreviousWorkExYear w_wrkex_NumOfJobsDoneBefore w_empstat_DE_WrkEx_yrs w_demo_Gender w_demo_Married w_demo_distance w_edu_HighestEducation w_wrkex_PreviousWorkEx apt_math apt_english apt_puzzle apt_total    {
gen OO`lname'=OO*`lname' 
gen OH`lname'=OH*`lname'
gen HO`lname'=HO*`lname'
gen HH`lname'=HH*`lname'
 }
 
  
 w_wrkex_PreviousWorkExYear w_wrkex_NumOfJobsDoneBefore w_empstat_DE_WrkEx_yrs w_wrkex_PreviousWorkEx
 w_edu_HighestEducation apt_math apt_english apt_puzzle apt_total 

 reg ln_avg16_n_speed_s OO OH HO HH alloc_off if wave==5 &  ad_type!="", cluster(person_week) noc
outreg2 using "$regdir\t31.tex", replace  noni auto(3) ctitle(Wave 3.5) noas

reg ln_avg16_n_speed_s OO OH HO HH alloc_off if wave==6 &  ad_type!="", cluster(person_week) noc
outreg2 using "$regdir\t31.tex", append  noni auto(3) ctitle(Wave 4) noas

foreach lname of varlist  w_demo_Gender w_demo_Married w_demo_distance w_demo_Age w_demo_ChildrenNum{
reg ln_avg16_n_speed_s OO OH HO HH OO`lname' OH`lname' HO`lname' HH`lname' alloc_off if wave==5 &  ad_type!="", cluster(person_week) noc 
outreg2 using "$regdir\t31.tex", append  noni auto(3) ctitle(Wave 3.5) noas

reg ln_avg16_n_speed_s OO OH HO HH OO`lname' OH`lname' HO`lname' HH`lname' alloc_off if wave==6 &  ad_type!="", cluster(person_week) noc 
outreg2 using "$regdir\t31.tex", append  noni auto(3) ctitle(Wave 4) noas
}


*2.d
reg ln_avg16_n_speed_s OO OH HO HH OOO OHO HOO HHO  i.wave if  ad_type!="", cluster( person_week ) noc
outreg2 using "$regdir\t24.tex", replace  noni addtext(Week and Wave FE, Yes) auto(3) ctitle(All waves)

reg ln_avg16_n_speed_s OO OH HO HH OOO OHO HOO HHO  if wave==5 &  ad_type!="", cluster(person_week) noc
outreg2 using "$regdir\t24.tex", append  noni addtext(Week and Wave FE, Yes) auto(3) ctitle(Wave 3.5)

reg ln_avg16_n_speed_s OO OH HO HH OOO OHO HOO HHO  if wave==6 &  ad_type!="", cluster(person_week) noc
outreg2 using "$regdir\t24.tex", append  noni addtext(Week and Wave FE, Yes) auto(3) ctitle(Wave 4)

reg ln_avg16_n_speed_s OO OH HO HH OOO OHO HOO HHO  i.wave if wave>4 &  ad_type!="", cluster(person_week) noc
outreg2 using "$regdir\t24.tex", append  noni addtext(Week and Wave FE, Yes) auto(3) ctitle(Wave 3.5 \& 4)

*/


**************************
*Update 5- wanted to see how advert*preference groups behave before the allocation has an impact
**************************


*Baseline speed measures
g comp_speed= ln_n_speed_cash if user_n==1
replace comp_speed= ln_n_speed_plain if user_n==2
replace comp_speed= ln_speed_60min if user_n==3
replace comp_speed= ln_avg16_n_speed_s if user_n==4

{
reg comp_speed  pref_office#ad_office i.wave if user_n<4 & wave>1, cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", replace  ctitle(All waves) $opt

reg comp_speed pref_office#ad_office i.wave  i.wave if user_n<4 & wave==5 , cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append ctitle(Wave 3.5) $opt

reg comp_speed pref_office#ad_office i.wave  i.wave if user_n<4 & wave==6, cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append  ctitle(Wave 4) $opt

reg comp_speed pref_office#ad_office i.wave  i.wave if user_n<4 & wave>4 , cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append  ctitle(Wave 3.5 \& 4) $opt
}

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


reg ln_n_speed_s  pref_office#ad_office#alloc_off  i.section i.week i.wave [pw=weight] if wave>4 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)



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
