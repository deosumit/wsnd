set mem 5g
set more off

global workdir "C:\Users\sumit\Documents\Work\Worker Sorting\My work"
global regdir "$workdir\tex files\regressions"

do "$workdir\cleaning.do"

global covars "i.week i.wave i.section pref_office ad_office"
global outreg_setting "noobs nor2 noni nonot auto(2) nocon keep(pref_office alloc_off c.pref_office#c.alloc_off)"

gen incentive= ln_n_speed_plain-ln_n_speed_cash

/******************/
/*Allocation*******/
/******************/

*1.a & 1.b
{
reg ln_n_speed_s alloc_off $covars, cluster( person_week )
outreg2 using "$regdir\t1.tex", replace  $outreg_setting ctitle(All waves)

reg ln_n_speed_s alloc_off $covars if wave==5, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s alloc_off $covars if wave==6 , cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s alloc_off $covars if wave>4, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(All waves)

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==5 , cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==6, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave>4 , cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)
}


*ATE
{
reg ln_n_speed_s alloc_off $covars [pw=weight], cluster( person_week )
outreg2 using "$regdir\t1.tex", replace  $outreg_setting ctitle(All waves)

reg ln_n_speed_s alloc_off $covars if wave==5 [pw=weight], cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s alloc_off $covars if wave==6 [pw=weight], cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s alloc_off $covars if wave>4 [pw=weight], cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash [pw=weight], cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(All waves)

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==5 [pw=weight], cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==6 [pw=weight], cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave>4 [pw=weight], cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)
}

global covars "i.week i.wave i.section pref_office ad_office hard c.hard#c.alloc_off"
global outreg_setting " noni auto(2)  keep(alloc_off hard c.hard#c.alloc_off)"

*Hard Surveys
{
reg ln_n_speed_s alloc_off $covars, cluster( person_week )
outreg2 using "$regdir\t1.tex", replace  $outreg_setting ctitle(All waves)

reg ln_n_speed_s alloc_off $covars if wave==5, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s alloc_off $covars if wave==6 , cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s alloc_off $covars if wave>4, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(All waves)

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==5 , cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==6, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave>4 , cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)
}


*ATE
{
reg ln_n_speed_s alloc_off $covars [pw=weight], cluster( person_week )
outreg2 using "$regdir\t1.tex", replace  $outreg_setting ctitle(All waves)

// reg ln_n_speed_s alloc_off $covars if wave==5 [pw=weight], cluster( person_week )
// outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5)
//
// reg ln_n_speed_s alloc_off $covars if wave==6 [pw=weight], cluster( person_week )
// outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s alloc_off $covars if wave>4 [pw=weight], cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash [pw=weight], cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(All waves)

// reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==5 [pw=weight], cluster( person_week )
// outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5)
//
// reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==6 [pw=weight], cluster( person_week )
// outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave>4 [pw=weight], cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)
}


/******************/
/*Selection effect*/
/******************/
*Baseline Speeds
global opt = "keep(pref_office Train_Pref ad_office alloc_off) nonotes nor2 noni nocons auto(3)"

global i=1

foreach x of varlist ln_n_speed_cash ln_n_speed_plain ln_speed_60min incentive{

reg `x'  pref_office ad_office  i.wave if user_n==1 &  wave>1, cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", replace  ctitle(All waves) $opt

reg `x' pref_office ad_office  i.wave if user_n==1 &  wave==5 , cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append ctitle(Wave 3.5) $opt

reg `x' pref_office ad_office  i.wave if user_n==1 & wave==6, cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(Wave 4) $opt

reg `x' pref_office ad_office  i.wave if user_n==1 &  wave>4 , cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(Wave 3.5 \& 4) $opt

reg `x' Train_Pref ad_office  if user_n==1 &  wave>1, cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(All waves) $opt
 
reg `x' Train_Pref ad_office  if user_n==1 &  wave==5 , cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(Wave 3.5) $opt

reg `x' Train_Pref ad_office  if user_n==1 &  wave==6, cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(Wave 4) $opt

reg `x' Train_Pref ad_office  if user_n==1 & wave>4 , cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(Wave 3.5 \& 4)  $opt

global i= $i + 1
}

g comp_speed= ln_n_speed_cash if user_n==1
replace comp_speed= ln_n_speed_plain if user_n==2
replace comp_speed= ln_speed_60min if user_n==3
replace comp_speed= ln_avg16_n_speed_s if user_n==4

{
reg comp_speed  pref_office ad_office  i.wave if user_n<4 & wave>1, cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", replace  ctitle(All waves) $opt

reg comp_speed pref_office ad_office  i.wave if user_n<4 & wave==5 , cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append ctitle(Wave 3.5) $opt

reg comp_speed pref_office ad_office  i.wave if user_n<4 & wave==6, cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append  ctitle(Wave 4) $opt

reg comp_speed pref_office ad_office  i.wave if user_n<4 & wave>4 , cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append  ctitle(Wave 3.5 \& 4) $opt

reg comp_speed  Train_Pref ad_office  i.wave if user_n<4 & wave>1, cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append  ctitle(All waves) $opt

reg comp_speed Train_Pref ad_office  i.wave if user_n<4 & wave==5 , cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append ctitle(Wave 3.5) $opt

reg comp_speed Train_Pref ad_office  i.wave if user_n<4 & wave==6, cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append  ctitle(Wave 4) $opt

reg comp_speed Train_Pref ad_office  i.wave if user_n<4 & wave>4 , cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append  ctitle(Wave 3.5 \& 4) $opt
}



*new specification
*only preference 
global opt = "keep(pref_office Train_Pref ad_office alloc_off) nonotes nor2 noni nocons auto(3)"

global i=1

foreach x of varlist ln_n_speed_cash ln_n_speed_plain  ln_speed_60min incentive{

reg `x'  pref_office  i.wave if user_n==1 &   wave>1, cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", replace  ctitle(All waves) $opt

reg `x' pref_office i.wave if user_n==1 &  wave==5 , cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append ctitle(Wave 3.5) $opt

reg `x' pref_office i.wave if user_n==1 &  wave==6, cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(Wave 4) $opt

reg `x' pref_office i.wave if user_n==1 &  wave>4 , cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(Wave 3.5 \& 4) $opt

reg `x' Train_Pref if user_n==1 &  wave>1, cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(All waves) $opt
 
reg `x' Train_Pref if user_n==1 &  wave==5 , cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(Wave 3.5) $opt

reg `x' Train_Pref if user_n==1 &  wave==6, cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(Wave 4) $opt

reg `x' Train_Pref if user_n==1 &  wave>4 , cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(Wave 3.5 \& 4)  $opt

global i= $i + 1
}

{
reg comp_speed  pref_office i.wave if user_n<4 & wave>1, cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", replace  ctitle(All waves) $opt

reg comp_speed pref_office i.wave if user_n<4 & wave==5 , cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append ctitle(Wave 3.5) $opt

reg comp_speed pref_office i.wave if user_n<4 & wave==6, cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append  ctitle(Wave 4) $opt

reg comp_speed pref_office i.wave if user_n<4 & wave>4 , cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append  ctitle(Wave 3.5 \& 4) $opt

reg comp_speed Train_Pref i.wave if user_n<4 & wave>1, cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append  ctitle(All waves) $opt

reg comp_speed Train_Pref i.wave if user_n<4 & wave==5 , cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append ctitle(Wave 3.5) $opt

reg comp_speed Train_Pref i.wave if user_n<4 & wave==6, cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append  ctitle(Wave 4) $opt

reg comp_speed Train_Pref i.wave if user_n<4 & wave>4 , cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append  ctitle(Wave 3.5 \& 4) $opt
}

*only ad type
global opt = "keep(pref_office Train_Pref ad_office alloc_off) nonotes nor2 noni nocons auto(3)"


global i=1

foreach x of varlist ln_n_speed_cash ln_n_speed_plain  ln_speed_60min incentive{

reg `x' ad_office  i.wave if user_n==1 & wave>1, cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", replace  ctitle(All waves) $opt

reg `x' ad_office i.wave if user_n==1 & wave==5 , cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append ctitle(Wave 3.5) $opt

reg `x' ad_office i.wave if user_n==1 & wave==6, cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(Wave 4) $opt

reg `x' ad_office i.wave if user_n==1 & wave>4 , cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(Wave 3.5 \& 4) $opt

global i= $i + 1
}

{
reg comp_speed ad_office i.wave if user_n<4 & wave>1, cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", replace  ctitle(All waves) $opt

reg comp_speed ad_office i.wave if user_n<4 & wave==5 , cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append ctitle(Wave 3.5) $opt

reg comp_speed ad_office i.wave if user_n<4 & wave==6, cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append  ctitle(Wave 4) $opt

reg comp_speed ad_office i.wave if user_n<4 & wave>4 , cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append  ctitle(Wave 3.5 \& 4) $opt
}



*ad & pref
global opt = "keep(pref_office Train_Pref ad_office ad_office c.pref_office#c.ad_office c.Train_Pref#c.ad_office) nonotes nor2 noni nocons auto(3)"

global i=1

foreach x of varlist ln_n_speed_cash ln_n_speed_plain ln_speed_60min incentive{

reg `x'  pref_office ad_office c.pref_office#c.ad_office  i.wave if user_n==1 &  wave>1, cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", replace  ctitle(All waves) $opt

reg `x' pref_office ad_office c.pref_office#c.ad_office  i.wave if user_n==1 &  wave==5 , cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append ctitle(Wave 3.5) $opt

reg `x' pref_office ad_office c.pref_office#c.ad_office  i.wave if user_n==1 & wave==6, cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(Wave 4) $opt

reg `x' pref_office ad_office c.pref_office#c.ad_office  i.wave if user_n==1 &  wave>4 , cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(Wave 3.5 \& 4) $opt

reg `x' Train_Pref ad_office c.Train_Pref#c.ad_office  if user_n==1 &  wave>1, cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(All waves) $opt
 
reg `x' Train_Pref ad_office c.Train_Pref#c.ad_office  if user_n==1 &  wave==5 , cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(Wave 3.5) $opt

reg `x' Train_Pref ad_office c.Train_Pref#c.ad_office  if user_n==1 &  wave==6, cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(Wave 4) $opt

reg `x' Train_Pref ad_office c.Train_Pref#c.ad_office  if user_n==1 & wave>4 , cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(Wave 3.5 \& 4)  $opt

global i= $i + 1
}



{
reg comp_speed  pref_office ad_office c.pref_office#c.ad_office  i.wave if user_n<4 & wave>1, cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", replace  ctitle(All waves) $opt

reg comp_speed pref_office ad_office c.pref_office#c.ad_office  i.wave if user_n<4 & wave==5 , cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append ctitle(Wave 3.5) $opt

reg comp_speed pref_office ad_office c.pref_office#c.ad_office  i.wave if user_n<4 & wave==6, cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append  ctitle(Wave 4) $opt

reg comp_speed pref_office ad_office c.pref_office#c.ad_office  i.wave if user_n<4 & wave>4 , cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append  ctitle(Wave 3.5 \& 4) $opt

reg comp_speed  Train_Pref ad_office c.Train_Pref#c.ad_office  i.wave if user_n<4 & wave>1, cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append  ctitle(All waves) $opt

reg comp_speed Train_Pref ad_office c.Train_Pref#c.ad_office  i.wave if user_n<4 & wave==5 , cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append ctitle(Wave 3.5) $opt

reg comp_speed Train_Pref ad_office c.Train_Pref#c.ad_office  i.wave if user_n<4 & wave==6, cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append  ctitle(Wave 4) $opt

reg comp_speed Train_Pref ad_office c.Train_Pref#c.ad_office  i.wave if user_n<4 & wave>4 , cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append  ctitle(Wave 3.5 \& 4) $opt
}

global opt "noobs nor2 noni nonot auto(2) nocon keep(pref_office alloc_off c.pref_office#c.alloc_off)"


*only men
preserve 

drop if w_demo_Gender==1

global i=1
foreach x of varlist ln_n_speed_cash ln_n_speed_plain ln_speed_60min incentive{

reg `x' pref_office ad_office c.pref_office#c.ad_office i.wave if  wave>1, cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", replace  ctitle(All waves) $opt

reg `x' pref_office ad_office c.pref_office#c.ad_office i.wave if  wave==5 , cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append ctitle(Wave 3.5) $opt

reg `x' pref_office ad_office c.pref_office#c.ad_office i.wave if  wave==6, cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(Wave 4) $opt

reg `x' pref_office ad_office c.pref_office#c.ad_office i.wave if  wave>4 , cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(Wave 3.5 \& 4) $opt

reg `x' Train_Pref ad_office c.Train_Pref#c.ad_office  if  wave>1, cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(All waves) $opt
 
reg `x' Train_Pref ad_office c.Train_Pref#c.ad_office  if  wave==5 , cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(Wave 3.5) $opt

reg `x' Train_Pref ad_office c.Train_Pref#c.ad_office  if  wave==6, cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(Wave 4) $opt

reg `x' Train_Pref ad_office c.Train_Pref#c.ad_office  if  wave>4 , cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(Wave 3.5 \& 4)  $opt

global i= $i + 1
}

{
reg comp_speed  pref_office ad_office c.pref_office#c.ad_office i.wave if user_n<4 & wave>1, cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", replace  ctitle(All waves) $opt

reg comp_speed pref_office ad_office c.pref_office#c.ad_office i.wave if user_n<4 & wave==5 , cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append ctitle(Wave 3.5) $opt

reg comp_speed pref_office ad_office c.pref_office#c.ad_office i.wave if user_n<4 & wave==6, cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append  ctitle(Wave 4) $opt

reg comp_speed pref_office ad_office c.pref_office#c.ad_office i.wave if user_n<4 & wave>4 , cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append  ctitle(Wave 3.5 \& 4) $opt

reg comp_speed Train_Pref ad_office c.Train_Pref#c.ad_office  i.wave if user_n<4 & wave>1, cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append  ctitle(All waves) $opt

reg comp_speed Train_Pref ad_office c.Train_Pref#c.ad_office  i.wave if user_n<4 & wave==5 , cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append ctitle(Wave 3.5) $opt

reg comp_speed Train_Pref ad_office c.Train_Pref#c.ad_office  i.wave if user_n<4 & wave==6, cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append  ctitle(Wave 4) $opt

reg comp_speed Train_Pref ad_office c.Train_Pref#c.ad_office  i.wave if user_n<4 & wave>4 , cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append  ctitle(Wave 3.5 \& 4) $opt
}

restore 


*only women
preserve 

drop if w_demo_Gender==0

foreach x of varlist ln_n_speed_cash ln_n_speed_plain ln_speed_60min incentive{

reg `x'  i.ad_office#i.pref_office i.wave if  wave>1, cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", replace  ctitle(All waves) $opt

reg `x' i.ad_office#i.pref_office i.wave if  wave==5 , cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append ctitle(Wave 3.5) $opt

reg `x' i.ad_office#i.pref_office i.wave if  wave==6, cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(Wave 4) $opt

reg `x' i.ad_office#i.pref_office i.wave if  wave>4 , cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(Wave 3.5 \& 4) $opt

reg `x' i.ad_office#i.Train_Pref if  wave>1, cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(All waves) $opt
 
reg `x' i.ad_office#i.Train_Pref if  wave==5 , cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(Wave 3.5) $opt

reg `x' i.ad_office#i.Train_Pref if  wave==6, cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(Wave 4) $opt

reg `x' i.ad_office#i.Train_Pref if  wave>4 , cluster( recruitmentid_new )
outreg2 using "$regdir\t1$i.tex", append  ctitle(Wave 3.5 \& 4)  $opt

global i= $i + 1
}

{
reg comp_speed  i.ad_office#i.pref_office i.wave if user_n<4 & wave>1, cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", replace  ctitle(All waves) $opt

reg comp_speed i.ad_office#i.pref_office i.wave if user_n<4 & wave==5 , cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append ctitle(Wave 3.5) $opt

reg comp_speed i.ad_office#i.pref_office i.wave if user_n<4 & wave==6, cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append  ctitle(Wave 4) $opt

reg comp_speed i.ad_office#i.pref_office i.wave if user_n<4 & wave>4 , cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append  ctitle(Wave 3.5 \& 4) $opt

reg comp_speed i.ad_office#i.Train_Pref i.wave if user_n<4 & wave>1, cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append  ctitle(All waves) $opt

reg comp_speed i.ad_office#i.Train_Pref i.wave if user_n<4 & wave==5 , cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append ctitle(Wave 3.5) $opt

reg comp_speed i.ad_office#i.Train_Pref i.wave if user_n<4 & wave==6, cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append  ctitle(Wave 4) $opt

reg comp_speed i.ad_office#i.Train_Pref i.wave if user_n<4 & wave>4 , cluster( recruitmentid_new )
outreg2 using "$regdir\t15.tex", append  ctitle(Wave 3.5 \& 4) $opt
}

restore 


/*********************************/
/*Selection-coefficient over time*/
/*********************************/

bysort recruitmentid_new week: gen no_survey_week=_N




*First 4 surveys 
reg ln_n_speed_s  pref_office  i.section i.wave if  ad_office==1 & attempt_seq<17, cluster( person_week )
outreg2 using "$regdir\t2121.tex", replace  $outreg_setting ctitle(All waves)

reg ln_n_speed_s  pref_office alloc_off  i.section  i.wave if  ad_office==1 & attempt_seq<17, cluster( person_week )
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(All waves)

reg ln_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.section  i.wave if  ad_office==1 & attempt_seq<17, cluster( person_week )
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(All waves)


reg ln_n_speed_s  pref_office i.section  i.wave if wave==5 &  ad_office==1 & attempt_seq<17 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s  pref_office alloc_off i.section  i.wave if wave==5 &  ad_office==1 & attempt_seq<17 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off i.section  i.wave if wave==5 &  ad_office==1 & attempt_seq<17, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5)


reg ln_n_speed_s  pref_office i.section  i.wave if wave==6 &  ad_office==1 & attempt_seq<17, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s  pref_office alloc_off i.section  i.wave if wave==6 &  ad_office==1 & attempt_seq<17, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off i.section  i.wave if wave==6 &  ad_office==1 & attempt_seq<17, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)


reg ln_n_speed_s  pref_office  i.section  i.wave if wave>4 &  ad_office==1 & attempt_seq<17, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_n_speed_s  pref_office alloc_off  i.section  i.wave if wave>4 &  ad_office==1 & attempt_seq<17, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off  i.section  i.wave if wave>4 &  ad_office==1 & attempt_seq<17, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)



gen weight_fw=1/no_survey_week 

*First week- eqaully weighted DEO
reg ln_n_speed_s  pref_office  i.section  i.wave  [pw=weight_fw] if  ad_office==1 & week==1, cluster( person_week )
outreg2 using "$regdir\t2121.tex", replace  $outreg_setting ctitle(All waves)

reg ln_n_speed_s  pref_office alloc_off  i.section  i.wave  [pw=weight_fw] if  ad_office==1 & week==1, cluster( person_week )
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(All waves)

reg ln_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.section  i.wave  [pw=weight_fw] if  ad_office==1 & week==1, cluster( person_week )
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(All waves)


reg ln_n_speed_s  pref_office i.section  i.wave  [pw=weight_fw] if wave==5 &  ad_office==1 & week==1 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s  pref_office alloc_off i.section  i.wave  [pw=weight_fw] if wave==5 &  ad_office==1 & week==1 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off i.section  i.wave  [pw=weight_fw] if wave==5 &  ad_office==1 & week==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5)


reg ln_n_speed_s  pref_office i.section  i.wave  [pw=weight_fw] if wave==6 &  ad_office==1 & week==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s  pref_office alloc_off i.section  i.wave  [pw=weight_fw] if wave==6 &  ad_office==1 & week==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off i.section  i.wave  [pw=weight_fw] if wave==6 &  ad_office==1 & week==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)


reg ln_n_speed_s  pref_office  i.section  i.wave  [pw=weight_fw] if wave>4 &  ad_office==1 & week==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_n_speed_s  pref_office alloc_off  i.section  i.wave  [pw=weight_fw] if wave>4 &  ad_office==1 & week==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off  i.section  i.wave  [pw=weight_fw] if wave>4 &  ad_office==1 & week==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)



*First week- weighted # survey
reg ln_n_speed_s  pref_office  i.section  i.wave  if  ad_office==1 & week==1, cluster( person_week )
outreg2 using "$regdir\t2121.tex", replace  $outreg_setting ctitle(All waves)

reg ln_n_speed_s  pref_office alloc_off  i.section  i.wave if  ad_office==1 & week==1, cluster( person_week )
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(All waves)

reg ln_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.section  i.wave   if  ad_office==1 & week==1, cluster( person_week )
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(All waves)


reg ln_n_speed_s  pref_office i.section  i.wave   if wave==5 &  ad_office==1 & week==1 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s  pref_office alloc_off i.section  i.wave   if wave==5 &  ad_office==1 & week==1 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off i.section  i.wave   if wave==5 &  ad_office==1 & week==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5)


reg ln_n_speed_s  pref_office i.section  i.wave   if wave==6 &  ad_office==1 & week==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s  pref_office alloc_off i.section  i.wave  if wave==6 &  ad_office==1 & week==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off i.section  i.wave   if wave==6 &  ad_office==1 & week==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)


reg ln_n_speed_s  pref_office  i.section  i.wave  if wave>4 &  ad_office==1 & week==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_n_speed_s  pref_office alloc_off  i.section  i.wave  if wave>4 &  ad_office==1 & week==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off  i.section  i.wave  if wave>4 &  ad_office==1 & week==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)



*All weeks- Equally weighted DEO

reg ln_n_speed_s  pref_office  i.section  i.wave i.week [pw=weight] if  ad_office==1 , cluster( person_week )
outreg2 using "$regdir\t2121.tex", replace  $outreg_setting ctitle(All waves)

reg ln_n_speed_s  pref_office alloc_off  i.section  i.wave i.week  [pw=weight] if  ad_office==1 , cluster( person_week )
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(All waves)

reg ln_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.section  i.wave i.week [pw=weight] if  ad_office==1, cluster( person_week )
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(All waves)


reg ln_n_speed_s  pref_office i.section  i.wave i.week [pw=weight] if wave==5 &  ad_office==1  , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s  pref_office alloc_off i.section  i.wave i.week [pw=weight] if wave==5 &  ad_office==1  , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off i.section  i.wave i.week [pw=weight] if wave==5 &  ad_office==1 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5)


reg ln_n_speed_s  pref_office i.section  i.wave i.week [pw=weight] if wave==6 &  ad_office==1 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s  pref_office alloc_off i.section  i.wave i.week [pw=weight] if wave==6 &  ad_office==1 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off i.section  i.wave i.week [pw=weight] if wave==6 &  ad_office==1 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)


reg ln_n_speed_s  pref_office  i.section  i.wave i.week [pw=weight] if wave>4 &  ad_office==1 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_n_speed_s  pref_office alloc_off  i.section  i.wave i.week [pw=weight] if wave>4 &  ad_office==1 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off  i.section  i.wave i.week [pw=weight] if wave>4 &  ad_office==1 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)



*All weeks- weighted # surveys

reg ln_n_speed_s  pref_office  i.section  i.wave i.week  if  ad_office==1 , cluster( person_week )
outreg2 using "$regdir\t2121.tex", replace  $outreg_setting ctitle(All waves)

reg ln_n_speed_s  pref_office alloc_off  i.section  i.wave i.week   if  ad_office==1 , cluster( person_week )
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(All waves)

reg ln_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.section  i.wave i.week  if  ad_office==1, cluster( person_week )
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(All waves)


reg ln_n_speed_s  pref_office i.section  i.wave i.week  if wave==5 &  ad_office==1  , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s  pref_office alloc_off i.section  i.wave i.week  if wave==5 &  ad_office==1  , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off i.section  i.wave i.week  if wave==5 &  ad_office==1 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5)


reg ln_n_speed_s  pref_office i.section  i.wave i.week  if wave==6 &  ad_office==1 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s  pref_office alloc_off i.section  i.wave i.week  if wave==6 &  ad_office==1 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off i.section  i.wave i.week  if wave==6 &  ad_office==1 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)


reg ln_n_speed_s  pref_office  i.section  i.wave i.week  if wave>4 &  ad_office==1 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_n_speed_s  pref_office alloc_off  i.section  i.wave i.week  if wave>4 &  ad_office==1 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off  i.section  i.wave i.week  if wave>4 &  ad_office==1 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)
