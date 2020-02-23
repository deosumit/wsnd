set mem 5g
set more off

global workdir "C:\Users\sumit\Documents\Work\Worker Sorting\My work"
global regdir "$workdir\tex files\regressions"

do "$workdir\cleaning.do"

global covars "i.week i.wave i.section"
global outreg_setting "noni addtext(Section+Week+Wave FE, Yes) auto(3)"

/*******************/
/*Allocation effect*/
/*******************/
	
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


*ATE with differentiated sample weights (yields same results)
{
reg ln_n_speed_s alloc_off $covars [pw=weight_n], cluster( person_week )
outreg2 using "$regdir\t71.tex", replace  $outreg_setting ctitle(All waves)

reg ln_n_speed_s alloc_off $covars if wave==5 [pw=weight_5], cluster( person_week )
outreg2 using "$regdir\t71.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s alloc_off $covars if wave==6 [pw=weight_6], cluster( person_week )
outreg2 using "$regdir\t71.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s alloc_off $covars if wave>4 [pw=weight_56], cluster( person_week )
outreg2 using "$regdir\t71.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash [pw=weight_n], cluster( person_week )
outreg2 using "$regdir\t71.tex", append  $outreg_setting ctitle(All waves)

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==5 [pw=weight_5], cluster( person_week )
outreg2 using "$regdir\t71.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==6 [pw=weight_6], cluster( person_week )
outreg2 using "$regdir\t71.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave>4 [pw=weight_56], cluster( person_week )
outreg2 using "$regdir\t71.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)
}


***Testing sensitivity of allocation effect to baseline speed metric
{
reg ln_n_speed_s alloc_off $covars  if wave>1, cluster( person_week )
outreg2 using "$regdir\t10.tex", replace  $outreg_setting ctitle(All waves)  keep(alloc_off )

reg ln_n_speed_s alloc_off $covars  if wave==5 , cluster( person_week )
outreg2 using "$regdir\t10.tex", append  $outreg_setting ctitle(Wave 3.5) keep(alloc_off )

reg ln_n_speed_s alloc_off $covars  if wave==6, cluster( person_week )
outreg2 using "$regdir\t10.tex", append  $outreg_setting ctitle(Wave 4) keep(alloc_off )

reg ln_n_speed_s alloc_off $covars  if wave>4 , cluster( person_week )
outreg2 using "$regdir\t10.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4) keep(alloc_off )

reg ln_n_speed_s alloc_off $covars if wave>1 [pw=weight] , cluster( person_week )
outreg2 using "$regdir\t10.tex", append  $outreg_setting ctitle(All waves) keep(alloc_off )

reg ln_n_speed_s alloc_off $covars if wave==5 [pw=weight], cluster( person_week )
outreg2 using "$regdir\t10.tex", append  $outreg_setting ctitle(Wave 3.5) keep(alloc_off )

reg ln_n_speed_s alloc_off $covars if wave==6 [pw=weight], cluster( person_week )
outreg2 using "$regdir\t10.tex", append  $outreg_setting ctitle(Wave 4) keep(alloc_off )

reg ln_n_speed_s alloc_off $covars if wave>4 [pw=weight], cluster( person_week )
outreg2 using "$regdir\t10.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4) keep(alloc_off )
}

global i=1
foreach x of varlist ln_n_speed_cash ln_n_speed_plain ln_avg16_n_speed_s ln_speed_60min{

reg ln_n_speed_s alloc_off $covars `x' if wave>1, cluster( person_week )
outreg2 using "$regdir\t1$i.tex", replace  $outreg_setting ctitle(All waves)  keep(alloc_off `x')

reg ln_n_speed_s alloc_off $covars `x' if wave==5 , cluster( person_week )
outreg2 using "$regdir\t1$i.tex", append  $outreg_setting ctitle(Wave 3.5) keep(alloc_off `x')

reg ln_n_speed_s alloc_off $covars `x' if wave==6, cluster( person_week )
outreg2 using "$regdir\t1$i.tex", append  $outreg_setting ctitle(Wave 4) keep(alloc_off `x')

reg ln_n_speed_s alloc_off $covars `x' if wave>4 , cluster( person_week )
outreg2 using "$regdir\t1$i.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4) keep(alloc_off `x')

reg ln_n_speed_s alloc_off $covars `x' if wave>1 [pw=weight], cluster( person_week )
outreg2 using "$regdir\t1$i.tex", append  $outreg_setting ctitle(All waves)  keep(alloc_off `x')

reg ln_n_speed_s alloc_off $covars `x' if wave==5 [pw=weight] , cluster( person_week )
outreg2 using "$regdir\t1$i.tex", append  $outreg_setting ctitle(Wave 3.5) keep(alloc_off `x')

reg ln_n_speed_s alloc_off $covars `x' if wave==6 [pw=weight], cluster( person_week )
outreg2 using "$regdir\t1$i.tex", append  $outreg_setting ctitle(Wave 4) keep(alloc_off `x')

reg ln_n_speed_s alloc_off $covars `x' if wave>4 [pw=weight], cluster( person_week )
outreg2 using "$regdir\t1$i.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4) keep(alloc_off `x')

global i= $i + 1
}



*High penalty
{
reg ln_n_speed_s_highpenalty alloc_off $covars, cluster( person_week )
outreg2 using "$regdir\t1.tex", replace  $outreg_setting ctitle(All waves)

reg ln_n_speed_s_highpenalty alloc_off $covars if wave==5, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s_highpenalty alloc_off $covars if wave==6 , cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s_highpenalty alloc_off $covars if wave>4, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_n_speed_s_highpenalty alloc_off $covars ln_n_speed_cash, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(All waves)

reg ln_n_speed_s_highpenalty alloc_off $covars ln_n_speed_cash if wave==5 , cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s_highpenalty alloc_off $covars ln_n_speed_cash if wave==6, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s_highpenalty alloc_off $covars ln_n_speed_cash if wave>4 , cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)
}

{
reg ln_n_speed_s_highpenalty alloc_off $covars [pw=weight], cluster( person_week )
outreg2 using "$regdir\t1.tex", replace  $outreg_setting ctitle(All waves)

reg ln_n_speed_s_highpenalty alloc_off $covars if wave==5 [pw=weight],  cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s_highpenalty alloc_off $covars if wave==6 [pw=weight], cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s_highpenalty alloc_off $covars if wave>4 [pw=weight], cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_n_speed_s_highpenalty alloc_off $covars ln_n_speed_cash [pw=weight], cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(All waves)

reg ln_n_speed_s_highpenalty alloc_off $covars ln_n_speed_cash if wave==5 [pw=weight] , cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s_highpenalty alloc_off $covars ln_n_speed_cash if wave==6 [pw=weight], cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s_highpenalty alloc_off $covars ln_n_speed_cash if wave>4 [pw=weight], cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)
}


*accuracy-weighted by survey
{
reg accuracy alloc_off $covars, cluster( person_week )
outreg2 using "$regdir\t1.tex", replace  $outreg_setting ctitle(All waves)

reg accuracy alloc_off $covars if wave==5, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5)

reg accuracy alloc_off $covars if wave==6 , cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4)

reg accuracy alloc_off $covars if wave>4, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg accuracy alloc_off $covars accuracy_cash , cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(All waves)

reg accuracy alloc_off $covars  accuracy_cash if wave==5, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5)

reg accuracy alloc_off $covars accuracy_cash if wave==6 , cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4)

reg accuracy alloc_off $covars accuracy_cash if wave>4, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)
}

*Accuracy - weighted equally across DEOs
{
reg accuracy alloc_off $covars [pw=weight], cluster( person_week )
outreg2 using "$regdir\t1.tex", replace  $outreg_setting ctitle(All waves)

reg accuracy alloc_off $covars if wave==5 [pw=weight], cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5)

reg accuracy alloc_off $covars if wave==6 [pw=weight], cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4)

reg accuracy alloc_off $covars if wave>4 [pw=weight], cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg accuracy alloc_off $covars accuracy_cash [pw=weight], cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(All waves)

reg accuracy alloc_off $covars  accuracy_cash if wave==5 [pw=weight], cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5)

reg accuracy alloc_off $covars accuracy_cash if wave==6 [pw=weight], cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4)

reg accuracy alloc_off $covars accuracy_cash if wave>4 [pw=weight], cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)
}


*Total time spent 
{
reg tot_gross_time alloc_off $covars if userweek==1, cluster( person_week )
outreg2 using "$regdir\t1.tex", replace  $outreg_setting ctitle(All waves)

reg tot_gross_time alloc_off $covars if wave==5 & userweek==1, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5)

reg tot_gross_time alloc_off $covars if wave==6 & userweek==1, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4)

reg tot_gross_time alloc_off $covars if wave>4 & userweek==1, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg tot_net_time alloc_off $covars if userweek==1, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(All waves)

reg tot_net_time alloc_off $covars if wave==5 & userweek==1, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5)

reg tot_net_time alloc_off $covars if wave==6 & userweek==1, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4)

reg tot_net_time alloc_off $covars if wave>4 & userweek==1, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)
}


*Total time spent- dropping values that are incomplete
{
reg tot_gross_time alloc_off $covars if userweek==1 & tot_gross_time>30, cluster( person_week )
outreg2 using "$regdir\t1.tex", replace  $outreg_setting ctitle(All waves)

reg tot_gross_time alloc_off $covars if wave==5 & userweek==1 & tot_gross_time>30, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5)

reg tot_gross_time alloc_off $covars if wave==6 & userweek==1 & tot_gross_time>30, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4)

reg tot_gross_time alloc_off $covars if wave>4 & userweek==1 & tot_gross_time>30, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg tot_net_time alloc_off $covars if userweek==1 & tot_net_time>25, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(All waves)

reg tot_net_time alloc_off $covars if wave==5 & userweek==1 & tot_net_time>25, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5)

reg tot_net_time alloc_off $covars if wave==6 & userweek==1 & tot_net_time>25, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4)

reg tot_net_time alloc_off $covars if wave>4 & userweek==1 & tot_net_time>25, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)
}


*cluster at higher order 
{
reghdfe ln_n_speed_s alloc_off $covars, vce(cluster person sr_week ) noabsorb
outreg2 using "$regdir\t1.tex", replace  $outreg_setting ctitle(All waves)

reghdfe ln_n_speed_s alloc_off $covars if wave==5, vce(cluster person sr_week ) noabsorb
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5)

reghdfe ln_n_speed_s alloc_off $covars if wave==6 , vce(cluster person sr_week ) noabsorb
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4)

reghdfe ln_n_speed_s alloc_off $covars if wave>4, vce(cluster person sr_week ) noabsorb
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reghdfe ln_n_speed_s alloc_off $covars ln_n_speed_cash, vce(cluster person sr_week ) noabsorb
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(All waves)

reghdfe ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==5 , vce(cluster person sr_week ) noabsorb
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5)

reghdfe ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==6, vce(cluster person sr_week ) noabsorb
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4)

reghdfe ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave>4 , vce(cluster person sr_week ) noabsorb
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)
}


*Accounting for wave 3.5 and 4 difference in allocation effect 
*=============================================================

*Allocation effect change over time?
gen alloc_off_sr_week= alloc_off*sr_week 
gen alloc_off_year_month=alloc_off*year_month
gen alloc_off_wave3h=alloc_off*(wave==5)
gen alloc_off_wave4=alloc_off*(wave==6)


reg ln_n_speed_s alloc_off $covars if wave==5, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s alloc_off $covars if wave==6 , cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s i.wave#i.alloc_off $covars ln_n_speed_cash if wave>4, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(All waves)
margins i.wave#alloc_off
marginsplot

*Monthly allocation effect. This does not capture levels but just the difference.  (DID NOT USE IN LATEX FILE!!!)
reg ln_n_speed_s i.year_month#i.alloc_off i.week i.wave i.section ln_n_speed_cash if wave>4, cluster( person_week )
margins i.year_month#alloc_off
marginsplot
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(All waves)


*Performance of home and office groups in 3.5 and 4
reg ln_n_speed_s i.week#i.wave#i.alloc_off i.week i.wave i.section ln_n_speed_cash if wave>4, cluster( person_week )
margins week#wave#alloc_off
marginsplot, graphregion(color(white)) plotopts(msize(small) ) noci plot1opts(lp(dash)) plot3opts(lp(dash)) /*
*/ plot(,label("Wave 3.5-Home" "Wave 3.5-Office"  "Wave 4-Home"  "Wave 4-Office"))


*Checking this because david asked. 

*Weekwise becomes too complicated
reg ln_n_speed_s i.week#i.wave#i.alloc_off#i.ad_office i.week i.wave i.section ln_n_speed_cash if wave>4, cluster( person_week )
margins week#wave#alloc_off#ad_office
marginsplot, graphregion(color(white)) plotopts(msize(small) ) noci plot1opts(lp(dash)) plot3opts(lp(dash)) 

*Both ad types allocation effect in wave 4 is smaller than 3.5
reg ln_n_speed_s i.wave#i.alloc_off#i.ad_office i.week i.wave i.section ln_n_speed_cash if wave>4, cluster( person_week )
margins wave#alloc_off#ad_office
marginsplot, graphregion(color(white)) plotopts(msize(small) ) noci plot1opts(lp(dash)) plot3opts(lp(dash)) 

*Preference- allocation effect for home preference candidates same across both waves but office preference candidates experience negative office effect
reg ln_n_speed_s i.wave#i.alloc_off#i.pref_off i.week i.wave i.section ln_n_speed_cash if wave>4, cluster( person_week )
margins wave#alloc_off#pref_off
marginsplot, graphregion(color(white)) plotopts(msize(small) ) noci plot1opts(lp(dash)) plot3opts(lp(dash)) 



*Performance of home and office groups in all waves
reg ln_n_speed_s i.week#i.wave#i.alloc_off i.week i.wave i.section ln_n_speed_cash if wave>1, cluster( person_week )
margins week#wave#alloc_off
marginsplot, name(a9, replace) scale(0.7)  title("Home") graphregion(color(white)) plotopts(msize(small) ) noci plot2opts(m(i) lp(blank)) plot4opts(m(i) lp(blank)) plot6opts(m(i) lp(blank)) plot8opts(m(i) lp(blank)) 
marginsplot, name(a10, replace) scale(0.7) title("Office") graphregion(color(white)) plotopts(msize(small) ) noci plot1opts(m(i) lp(blank)) plot3opts(m(i) lp(blank)) plot5opts(m(i) lp(blank)) plot7opts(m(i) lp(blank)) 

graph combine a9 a10, graphregion(color(white)) ycom


*Check difference between home and office groups across two waves 
{
reg w60_min_netspeed wave#alloc_off if wave>4 & user_n==1
margins wave#alloc_off
marginsplot, name(a1, replace) scale(0.7) title("Baseline Speed") graphregion(color(white)) 

reg apt_total wave#alloc_off if wave>4 & user_n==1
margins wave#alloc_off
marginsplot, name(a2, replace) scale(0.7) legend(off) title("Aptitude") graphregion(color(white))

reg w_edu_years  wave#alloc_off if wave>4 & user_n==1
margins wave#alloc_off
marginsplot, name(a22, replace) scale(0.7) legend(off) title("Education in years") graphregion(color(white))

reg w_demo_Gender wave#alloc_off if wave>4 & user_n==1
margins wave#alloc_off
marginsplot,name(a3, replace) scale(0.7) legend(off) title("Prop of Female") graphregion(color(white))

reg w_demo_Married wave#alloc_off if wave>4 & user_n==1
margins wave#alloc_off
marginsplot,name(a4, replace) scale(0.7) legend(off) title("Prop of Married") graphregion(color(white))

reg w_demo_Age wave#alloc_off if wave>4 & user_n==1
margins wave#alloc_off
marginsplot,name(a5, replace) scale(0.7) legend(off) title("Age") graphregion(color(white))

reg w_demo_ChildrenNum wave#alloc_off if wave>4 & user_n==1
margins wave#alloc_off
marginsplot,name(a6, replace) scale(0.7) legend(off) title("# children") graphregion(color(white))

reg w_edu_TypingCourseCompleted wave#alloc_off if wave>4 & user_n==1
margins wave#alloc_off
marginsplot,name(a7, replace) scale(0.7) legend(off) title("Prop with typing course") graphregion(color(white))

reg w_wrkex_PreviousWorkExYear wave#alloc_off if wave>4 & user_n==1
margins wave#alloc_off
marginsplot,name(a8, replace) scale(0.7) legend(off) title("Work Ex (years)") graphregion(color(white))
}

graph combine a1 a2 a22 a3 a4 a5 a6 a7 a8, graphregion(color(white)) 


global outreg_setting= "noni nonot auto(3) keep(alloc_off) nor2 noobs nocons"


*Running regressions acros those subgroups
{

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==5 , cluster( person_week )
outreg2 using "$regdir\t1.tex", replace  $outreg_setting ctitle(Wave 3.5) 

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==6, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4) 

******Education
reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==5 & w_edu_years<15 , cluster( person_week )
outreg2 using "$regdir\t1.tex", replace  $outreg_setting ctitle(Wave 3.5) 

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==6 & w_edu_years<15, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4) 

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==5 & w_edu_years>15, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5) 

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==6 & w_edu_years>15, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4) 


******Gender

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==5 &w_demo_Gender==0 , cluster( person_week )
outreg2 using "$regdir\t1.tex", replace  $outreg_setting ctitle(Wave 3.5) 

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==6 & w_demo_Gender==0, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4) 

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==5 & w_demo_Gender==1, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5) 

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==6 & w_demo_Gender==1, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4) 

******Age

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==5 & w_demo_Age<=23 , cluster( person_week )
outreg2 using "$regdir\t1.tex", replace  $outreg_setting ctitle(Wave 3.5) 
 
reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==6 & w_demo_Age<=23, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4) 

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==5 & w_demo_Age>23, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5) 

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==6 & w_demo_Age>23, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4)

******Aptitude

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==5 &apt_total<=16 , cluster( person_week )
outreg2 using "$regdir\t1.tex", replace  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==6 & apt_total<=16, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4) 

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==5 & apt_total>16, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5) 

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==6 & apt_total>16, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4) 


******Speed

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==5 &ln_n_speed_cash<=3.5 , cluster( person_week )
outreg2 using "$regdir\t1.tex", replace  $outreg_setting ctitle(Wave 3.5) 

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==6 & ln_n_speed_cash<=3.5, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4) 

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==5 & ln_n_speed_cash>3.5, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5) 

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==6 & ln_n_speed_cash>3.5, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4) 


******Work exp

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==5 &w_wrkex_PreviousWorkExYear<=1 , cluster( person_week )
outreg2 using "$regdir\t1.tex", replace  $outreg_setting ctitle(Wave 3.5) 

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==6 & w_wrkex_PreviousWorkExYear<=1, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4) 

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==5 & w_wrkex_PreviousWorkExYear>1, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5) 

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==6 & w_wrkex_PreviousWorkExYear>1, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4) 


******preference 

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==5 & pref_office==0 , cluster( person_week )
outreg2 using "$regdir\t1.tex", replace  $outreg_setting ctitle(Wave 3.5) 

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==6 & pref_office==0, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4) 

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==5 & pref_office==1, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5) 

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==6 & pref_office==1, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4) 


******ad type 

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==5 & ad_office==0 , cluster( person_week )
outreg2 using "$regdir\t1.tex", replace  $outreg_setting ctitle(Wave 3.5) 

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==6 & ad_office==0, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4) 

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==5 & ad_office==1, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 3.5) 

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==6 & ad_office==1, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4) 
}


preserve 

drop if  w_demo_Gender==1 & w_demo_Age<=23

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==5 , cluster( person_week )
outreg2 using "$regdir\t1.tex", replace  $outreg_setting ctitle(Wave 3.5) 

reg ln_n_speed_s alloc_off $covars ln_n_speed_cash if wave==6, cluster( person_week )
outreg2 using "$regdir\t1.tex", append  $outreg_setting ctitle(Wave 4) 

restore 


/**********************************/
/*Weekly plot of allocation effect*/
/**********************************/


*1.c.a
{
reg ln_n_speed_s alloc_off i.week i.week##i.alloc_off i.wave i.section, cluster( person_week ) 
outreg2 using "$regdir\t3.tex", replace  noni addtext(Week and Wave FE, Yes) auto(3) ctitle(All waves)
margins week#alloc_off
marginsplot, name(c1, replace) scale(0.7) legend(off) title("All waves") graphregion(color(white)) 


reg ln_n_speed_s alloc_off i.week i.week##i.alloc_off i.section if wave==5 , cluster( person_week )
outreg2 using "$regdir\t3.tex", append  noni addtext(Week and Wave FE, Yes) auto(3) ctitle(Wave 3.5)
margins week#alloc_off
marginsplot, name(c2, replace) scale(0.7) legend(off) title("Waves 3.5") graphregion(color(white))


reg ln_n_speed_s alloc_off i.week i.week##i.alloc_off i.section if wave==6 , cluster( person_week )
outreg2 using "$regdir\t3.tex", append  noni addtext(Week and Wave FE, Yes) auto(3) ctitle(Wave 4)
margins week#alloc_off
marginsplot, name(c3, replace) scale(0.7) legend(off) title("Waves 4") graphregion(color(white))


reg ln_n_speed_s alloc_off i.week i.week##i.alloc_off i.wave i.section if wave>4 , cluster( person_week )
outreg2 using "$regdir\t3.tex", append  noni addtext(Week and Wave FE, Yes) auto(3) ctitle(Wave 3.5 \& 4)
margins week#alloc_off
marginsplot, name(c4, replace) scale(0.7) legend(off) title("Waves 3.5 & 4") graphregion(color(white))
}

graph combine c1 c2 c3 c4, graphregion(color(white)) ycom

*1.c.b
qui{
reg ln_n_speed_s alloc_off i.week i.week##i.alloc_off i.wave i.section ln_n_speed_cash, cluster( person_week )
outreg2 using "$regdir\t3.tex", append  noni addtext(Week and Wave FE, Yes) auto(3) ctitle(All waves)
margins week#alloc_off
marginsplot, name(c5, replace) scale(0.7) legend(off) title("All Waves") graphregion(color(white))


reg ln_n_speed_s alloc_off i.week i.week##i.alloc_off ln_n_speed_cash i.section if wave==5 , cluster( person_week )
outreg2 using "$regdir\t3.tex", append  noni addtext(Week and Wave FE, Yes) auto(3) ctitle(Wave 3.5)
margins week#alloc_off
marginsplot, name(c6, replace) scale(0.7) legend(off) title("Waves 3.5") graphregion(color(white))


reg ln_n_speed_s alloc_off i.week i.week##i.alloc_off ln_n_speed_cash i.section if wave==6 , cluster( person_week )
outreg2 using "$regdir\t3.tex", append  noni addtext(Week and Wave FE, Yes) auto(3) ctitle(Wave 4)
margins week#alloc_off
marginsplot, name(c7, replace) scale(0.7) legend(off) title("Waves 4") graphregion(color(white))


reg ln_n_speed_s alloc_off i.week i.week##i.alloc_off i.wave ln_n_speed_cash i.section if wave>4 , cluster( person_week )
outreg2 using "$regdir\t3.tex", append  noni addtext(Week and Wave FE, Yes) auto(3) ctitle(Wave 3.5 \& 4)
margins week#alloc_off
marginsplot, name(c8, replace) scale(0.7) legend(off) title("Waves 3.5 & 4") graphregion(color(white))
}

graph combine c5 c6 c7 c8, graphregion(color(white)) ycom


qui{
reg ln_n_speed_s alloc_off i.week i.week##i.alloc_off i.wave i.section ln_n_speed_cash if high_speed==0, cluster( person_week )
margins week#alloc_off
marginsplot, name(c15, replace) scale(0.7) legend(off) title("All Waves-Low") graphregion(color(white)) plot1opts(msize(vtiny)) ci1opts(lp(blank ))

reg ln_n_speed_s alloc_off i.week i.week##i.alloc_off i.wave i.section ln_n_speed_cash if high_speed==1, cluster( person_week )
margins week#alloc_off
marginsplot, name(c25, replace) scale(0.7) legend(off) title("All Waves-High") graphregion(color(white)) plot1opts(msize(vtiny)) ci1opts(lp(blank ))

reg ln_n_speed_s alloc_off i.week i.week##i.alloc_off i.wave ln_n_speed_cash i.section if wave>4 & high_speed==0 , cluster( person_week )
margins week#alloc_off
marginsplot, name(c18, replace) scale(0.7) legend(off) title("Waves 3.5 & 4-Low") graphregion(color(white)) plot1opts(msize(vtiny)) ci1opts(lp(blank ))

reg ln_n_speed_s alloc_off i.week i.week##i.alloc_off i.wave ln_n_speed_cash i.section if wave>4 & high_speed==1, cluster( person_week )
margins week#alloc_off
marginsplot, name(c28, replace) scale(0.7) legend(off) title("Waves 3.5 & 4-High") graphregion(color(white)) plot1opts(msize(vtiny)) ci1opts(lp(blank ))

reg ln_n_speed_s alloc_off i.week i.week##i.alloc_off ln_n_speed_cash i.section if wave==5 & high_speed==0, cluster( person_week )
margins week#alloc_off
marginsplot, name(c16, replace) scale(0.7) legend(off) title("Waves 3.5-Low") graphregion(color(white)) plot1opts(msize(vtiny)) ci1opts(lp(blank ))

reg ln_n_speed_s alloc_off i.week i.week##i.alloc_off ln_n_speed_cash i.section if wave==5 & high_speed==1, cluster( person_week )
margins week#alloc_off
marginsplot, name(c26, replace) scale(0.7) legend(off) title("Waves 3.5-High") graphregion(color(white)) plot1opts(msize(vtiny)) ci1opts(lp(blank ))

reg ln_n_speed_s alloc_off i.week i.week##i.alloc_off ln_n_speed_cash i.section if wave==6 & high_speed==0, cluster( person_week )
margins week#alloc_off
marginsplot, name(c17, replace) scale(0.7) legend(off) title("Waves 4-Low") graphregion(color(white)) plot1opts(msize(vtiny)) ci1opts(lp(blank ))

reg ln_n_speed_s alloc_off i.week i.week##i.alloc_off ln_n_speed_cash i.section if wave==6 & high_speed==1, cluster( person_week )
margins week#alloc_off
marginsplot, name(c27, replace) scale(0.7) legend(off) title("Waves 4-High") graphregion(color(white)) plot1opts(msize(vtiny)) ci1opts(lp(blank ))

}

graph combine c15 c25 c18 c28, graphregion(color(white)) ycom c(2)
graph combine c16 c26 c17 c27, graphregion(color(white)) ycom c(2)



***Testing sensitivity of allocation effect to baseline speed metric

reg ln_n_speed_s alloc_off $covars  if wave>1, cluster( person_week )
outreg2 using "$regdir\t10.tex", replace  $outreg_setting ctitle(All waves)  keep(alloc_off )

reg ln_n_speed_s alloc_off $covars  if wave==5 , cluster( person_week )
outreg2 using "$regdir\t10.tex", append  $outreg_setting ctitle(Wave 3.5) keep(alloc_off )

reg ln_n_speed_s alloc_off $covars  if wave==6, cluster( person_week )
outreg2 using "$regdir\t10.tex", append  $outreg_setting ctitle(Wave 4) keep(alloc_off )

reg ln_n_speed_s alloc_off $covars  if wave>4 , cluster( person_week )
outreg2 using "$regdir\t10.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4) keep(alloc_off )


global i=1

foreach x of varlist ln_n_speed_cash ln_n_speed_plain ln_speed_1st16 ln_speed_60min{

reg ln_n_speed_s alloc_off $covars `x' if wave>1, cluster( person_week )
outreg2 using "$regdir\t1$i.tex", replace  $outreg_setting ctitle(All waves)  keep(alloc_off `x')

reg ln_n_speed_s alloc_off $covars `x' if wave==5 , cluster( person_week )
outreg2 using "$regdir\t1$i.tex", append  $outreg_setting ctitle(Wave 3.5) keep(alloc_off `x')

reg ln_n_speed_s alloc_off $covars `x' if wave==6, cluster( person_week )
outreg2 using "$regdir\t1$i.tex", append  $outreg_setting ctitle(Wave 4) keep(alloc_off `x')

reg ln_n_speed_s alloc_off $covars `x' if wave>4 , cluster( person_week )
outreg2 using "$regdir\t1$i.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4) keep(alloc_off `x')

global i= $i + 1
}



