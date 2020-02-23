use "C:\Users\sumit\Documents\Work\Worker Sorting\04. Analysis\41. final dataset\412. Datasets\All merged data.dta", clear

/*
use "C:\Users\sumit\Documents\Work\Worker Sorting\04. Analysis\42. analysis output\421. do files\updated data_lk\FinalData\All merged data.dta", clear
*This data does not contain week but something called week_id 

use "C:\Users\sumit\Documents\Work\Worker Sorting\04. Analysis\42. analysis output\421. do files\updated data_lk\All merged data_cleaned.dta", clear
*this dataset contains week but has that missing for 81,854 observations. 
*/

rename (a_preference a_h_prefnow ) (A_preference A_h_prefnow )
rename (e_h_pref e_o_diff_choice e_o_pref e_pref_now) (E_h_pref E_o_diff_choice E_o_pref E_pref_now)

/*
cap drop train_* w_* b_* a_* e_* time_*
*/
cap drop week1 week2 week3 week4 week5 week6 week7 week8 week9 week10 week11 week12
cap drop n_speed_s ln_totchar_cash ln_totchar_plain ln_totchar_60min ln_n_totchar_s
cap drop ln_speed_1st16
cap drop mismatch_walkin_plain_merge last_merge
cap drop pers_*
cap drop risk_*
cap drop Timestamp BP SNo Username Wave F
cap drop C02OtherSpecify C06OtherSpecify TrainPref_Reason
replace allocation=trim(allocation )
cap drop pref_off alloc_off interactn O_H H_O O_O H_H
cap drop ad_office ad_interactn ad_pref_off ad_alloc_off ad_H_H ad_H_O ad_O_H ad_O_O
cap drop pref_week week_o user wk_sec_dif surveyfactor sec_dif surveyfactor2 h_interactn h_pref_off h_alloc_off h_H_H h_H_O h_O_H h_O_O


**Defining Week 
		
			global ads  ""A0" 			"A1" 		"A2" 		"A3" 		"A4" 		"A5" 		"A8" 		"A9" 		"A10" 		"A11" 		"A12" 		"AMix" 		"B1" 		"B2"		"B3"		"B4"		"B5" 		"B6" 		"B7" 		"B8" 	   "B9" 		"B10" 		"B11"   	"C1" 		"C3" 		"C4" 		"C5" 		"C6" 		"C7" 	   "C8" 		"D12" 		"D345"      "D78""
			global date ""28mar2016"	"15aug2016" "29aug2016"	"26dec2016" "2jan2017"	"23jan2017"	"6feb2017"	"6feb2017"	"20feb2017" "20feb2017"	"20feb2017"	"27feb2017"	"3apr2017"	"3apr2017"	"15may2017"	"10jul2017" "10jul2017" "7aug2017"	"7aug2017"	"4sep2017" "4sep2017"   "25sep2017" "25sep2017" "16oct2017" "6nov2017"  "6nov2017"  "27nov2017" "27nov2017" "1jan2018" "1jan2018"   "5feb2018"  "19feb2018" "19march2018"
			global n: word count $ads 
		
		forvalues i = 1/$n {
			forvalues x=1/12{
						replace week=`x' if (startdatetime>tc(`:word `i' of $date' 00:00:00)+msofhours(7*24*(`x'-1))) ///
						 & (startdatetime<tc(`:word `i' of $date' 00:00:00)+msofhours(7*24*(`x'))) & Add=="`:word `i' of $ads'"
			}
		}

replace week=week-2 if week>7 & Add=="B3"
		
**Defining Wave
		replace wave=2 	if Add=="A1" | Add=="A2"
		replace wave=3 	if Add=="A3" | Add=="A4" | Add=="A5" 
		replace wave=3.5 if  Add=="A8" | Add=="A9" | Add=="A10" | Add=="A11" | Add=="A12" | Add=="AMix" | Add=="B1" | Add=="B2" | Add=="B3" | Add=="B4" | Add=="B5" | Add=="B6" | Add=="B7"
		replace wave=4 	if Add=="B8" | Add=="B9" | Add=="B10" | Add=="B11" | Add=="C1" | Add=="C2" | Add=="C3" | Add=="C4" | Add=="C5" | Add=="C6" | Add=="C7" | Add=="C8" | Add=="D12" | Add=="D345" | Add=="D78"
	
**Defining Ad type 
		*Ad types
			foreach a in A1 A10 A11 A12 A4 A5 B3 B10 B11 B6 B7 C3 C4 C7 C8  D345{
				replace ad_type="Home" if Add=="`a'"
				}
			foreach a in A2 A3  A8 A9 B1 B2 B4 B5 B8 B9 C1 C5 C6 D12 D78 {
				replace ad_type="Office" if Add=="`a'"
				}
				
gen alloc_off=(allocation=="Office")
				
replace wave=5 if wave==3.5
replace wave=6 if wave==4
		
gen person_week=recruitmentid_new + string(week) 
		
drop if week>8

rename difficulty difficulty_old

merge m:1 surveyname using "C:\Users\sumit\Documents\Work\Worker Sorting\03. Datasets\34. Others\difficulty.dta"
drop if _merge==2
drop _merge
		
		*Solid weeks
		*Wave 1 
		replace difficulty="Easy" if week<5 & wave==1
		replace difficulty="Hard" if week>4 & week<7 & wave==1
		replace difficulty="Hard" if week>8 & wave==1

		*Wave 2+
		replace difficulty="Easy" if week<4 & wave>1
		replace difficulty="Hard" if week>3 & week<7 & wave>1
		replace difficulty="Hard" if week>9 & wave>1
		
drop hard 
gen hard=(difficulty=="Hard")

drop attempt_seq attrit no_survey

*attempt order
	sort recruitmentid_new startdatetime 
	by recruitmentid_new: gen attempt_seq=_n
	by recruitmentid_new: gen no_survey=_N/4
	
	
	*attrition variable
	gen attrit=week if attempt_seq==no_survey*4
		sort recruitmentid_new attrit
		local N=_N
		forvalues x = 2/`N'{
			qui if recruitmentid_new[`x'-1]==recruitmentid_new[`x'] replace attrit=attrit[`x'-1] in `x'
			}

*Define endline preference recall
gen e_pref_recall=A_preference
replace e_pref_recall= 1 if e_pref_recall==. & E_h_pref==2
replace e_pref_recall= 0 if e_pref_recall==. & E_h_pref ==1
replace e_pref_recall= 1 if e_pref_recall==. & E_o_pref ==2
replace e_pref_recall= 0 if e_pref_recall==. & E_o_pref ==1

*Define endline preference 
gen e_pref=1 if A_h_prefnow==2
replace e_pref=0 if A_h_prefnow==1
replace e_pref=0 if E_pref_now==1
replace e_pref=1 if E_pref_now==2
replace e_pref=1 if E_o_diff_choice==2 & E_o_pref==2
replace e_pref=0 if E_o_diff_choice==2 & E_o_pref==1
replace e_pref=1 if E_o_diff_choice==1 & E_o_pref==1
replace e_pref=0 if E_o_diff_choice==1 & E_o_pref==2

*Computing average speed for 1st 4 surveys
replace totalcharacters=total_char_ if  entered_fields_!=. & wave>1
replace incorrectcharacters=incorrect_char1_ if entered_fields_!=. & wave>1	
gen n_speed_s=(totalcharacters-incorrectcharacters)/(totalperiodhhmmss/60)
replace ln_n_speed_s=ln(n_speed_s)


gen accuracy=((totalcharacters-incorrectcharacters)/totalcharacters)*100
replace accuracy=. if accuracy<0


preserve
drop if attempt_seq>17
keep recruitmentid_new n_speed_s ln_n_speed_s 
bysort recruitmentid_new: egen avg16_ln_n_speed_s=mean(ln_n_speed_s)
bysort recruitmentid_new: egen avg16_n_speed_s=mean( n_speed_s )
gen ln_avg16_n_speed_s= ln(avg16_n_speed_s)
drop ln_n_speed_s n_speed_s
duplicates drop
save "C:\Users\sumit\Documents\Work\Worker Sorting\My work\dta\avg16.dta", replace 
restore 			
merge m:1 recruitmentid_new using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\dta\avg16.dta"

*Define ad type
gen ad_office=(ad_type=="Office")	
replace ad_office=. if ad_type==""
gen pref_office=(W_walkpref==1)

*Ad & preference pairs
gen OO=(ad_office==1 & W_walkpref==1)
gen OH=(ad_office==1 & W_walkpref==0)
gen HO=(ad_office==0 & W_walkpref==1)
gen HH=(ad_office==0 & W_walkpref==0)

replace OO=. if ad_type==""
replace OH=. if ad_type==""
replace HO=. if ad_type==""
replace HH=. if ad_type==""

*Ad, preference and allocation interaction
gen OOO=OO*alloc_off 
gen OHO=OH*alloc_off
gen HOO=HO*alloc_off
gen HHO=HH*alloc_off

*Total time spent regressions
bysort recruitmentid_new week: gen userweek_n=_n
bysort recruitmentid_new week: egen tot_gross_time=sum(totalperiodhhmmss)
bysort recruitmentid_new week: egen tot_net_time=sum( timespenthhmmss)
replace tot_gross_time=tot_gross_time/3600
replace tot_net_time=tot_net_time/3600

*Total surveys
gen N=_N
bysort recruitmentid_new: gen N_n=_N
gen weight=N/N_n

*Penalty class
gen gross_penalty=incorrectcharacters 
replace gross_penalty=1.5*incorrectcharacters if ((incorrectcharacters)/totalcharacters)>0.15 & difficulty=="Hard"
replace gross_penalty=2*incorrectcharacters if ((incorrectcharacters)/totalcharacters)>0.20 & difficulty=="Hard"
replace gross_penalty=1.5*incorrectcharacters if ((incorrectcharacters)/totalcharacters)>0.075 & difficulty=="Easy"
replace gross_penalty=2*incorrectcharacters if ((incorrectcharacters)/totalcharacters)>0.10 & difficulty=="Easy"

gen n_speed_s_highpenalty=(totalcharacters-gross_penalty)/(totalperiodhhmmss/60)
replace n_speed_s_highpenalty=1 if n_speed_s_highpenalty<=0

gen ln_n_speed_s_highpenalty=ln(n_speed_s_highpenalty)


*mean speed
drop _merge
preserve
drop if user_n!=1
keep recruitmentid_new ln_n_speed_cash 
egen mid_speed_s=median(ln_n_speed_cash)
drop ln_n_speed_cash
save "C:\Users\sumit\Documents\Work\Worker Sorting\My work\dta\avg.dta", replace 
restore 
merge m:1 recruitmentid_new using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\dta\avg.dta"


gen high_speed=(ln_n_speed_cash>mid_speed_s)

*1.a & 1.b
{
reg ln_n_speed_s alloc_off i.week i.wave i.section, cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", replace  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(All waves)

reg ln_n_speed_s alloc_off i.week i.wave i.section if wave==5, cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(Wave 3.5)

reg ln_n_speed_s alloc_off i.week i.wave i.section if wave==6 , cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(Wave 4)

reg ln_n_speed_s alloc_off i.week i.wave i.section if wave>4, cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(Wave 3.5 \& 4)

reg ln_n_speed_s alloc_off i.week i.wave i.section ln_n_speed_cash, cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(All waves)

reg ln_n_speed_s alloc_off i.week i.wave i.section ln_n_speed_cash if wave==5 , cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(Wave 3.5)

reg ln_n_speed_s alloc_off i.week i.wave i.section ln_n_speed_cash if wave==6, cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(Wave 4)

reg ln_n_speed_s alloc_off i.week i.wave i.section ln_n_speed_cash if wave>4 , cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(Wave 3.5 \& 4)
}

Ad-wise allocation effect
`"A0"' `"A1"' `"A10"' `"A11"' `"A12"' `"A2"' `"A3"' `"A4"' `"A5"' `"A8"' `"A9"' `"AMix"' `"B1"' `"B10"' `"B11"' `"B2"' `"B3"' `"B4"' `"B5"' `"B6"' `"B7"' `"B8"' `"B9"' `"C1"' `"C3"' `"C4"' `"C5"' `"C6"' `"C7"' `"C8"' `"D12"' `"D345"' `"D78"'

*accuracy
{
reg accuracy alloc_off i.week i.wave i.section, cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", replace  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(All waves)

reg accuracy alloc_off i.week i.wave i.section if wave==5, cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(Wave 3.5)

reg accuracy alloc_off i.week i.wave i.section if wave==6 , cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(Wave 4)

reg accuracy alloc_off i.week i.wave i.section if wave>4, cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(Wave 3.5 \& 4)
}

*Total time spent 
{
reg tot_gross_time alloc_off i.week i.wave i.section if userweek==1, cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", replace  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(All waves)

reg tot_gross_time alloc_off i.week i.wave i.section if wave==5 & userweek==1, cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(Wave 3.5)

reg tot_gross_time alloc_off i.week i.wave i.section if wave==6 & userweek==1, cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(Wave 4)

reg tot_gross_time alloc_off i.week i.wave i.section if wave>4 & userweek==1, cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(Wave 3.5 \& 4)

reg tot_net_time alloc_off i.week i.wave i.section if userweek==1, cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(All waves)

reg tot_net_time alloc_off i.week i.wave i.section if wave==5 & userweek==1, cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(Wave 3.5)

reg tot_net_time alloc_off i.week i.wave i.section if wave==6 & userweek==1, cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(Wave 4)

reg tot_net_time alloc_off i.week i.wave i.section if wave>4 & userweek==1, cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(Wave 3.5 \& 4)
}

*cluster at higher order 
{
reghdfe ln_n_speed_s alloc_off i.week i.wave i.section, vce(cluster person week ) noabsorb
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", replace  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(All waves)

reghdfe ln_n_speed_s alloc_off i.week i.wave i.section if wave==5, vce(cluster person week ) noabsorb
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(Wave 3.5)

reghdfe ln_n_speed_s alloc_off i.week i.wave i.section if wave==6 , vce(cluster person week ) noabsorb
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(Wave 4)

reghdfe ln_n_speed_s alloc_off i.week i.wave i.section if wave>4, vce(cluster person week ) noabsorb
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(Wave 3.5 \& 4)

reghdfe ln_n_speed_s alloc_off i.week i.wave i.section ln_n_speed_cash, vce(cluster person week ) noabsorb
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(All waves)

reghdfe ln_n_speed_s alloc_off i.week i.wave i.section ln_n_speed_cash if wave==5 , vce(cluster person week ) noabsorb
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(Wave 3.5)

reghdfe ln_n_speed_s alloc_off i.week i.wave i.section ln_n_speed_cash if wave==6, vce(cluster person week ) noabsorb
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(Wave 4)

reghdfe ln_n_speed_s alloc_off i.week i.wave i.section ln_n_speed_cash if wave>4 , vce(cluster person week ) noabsorb
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(Wave 3.5 \& 4)
}

*ATE
{
reg ln_n_speed_s alloc_off i.week i.wave i.section [pw=weight], cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", replace  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(All waves)

reg ln_n_speed_s alloc_off i.week i.wave i.section if wave==5 [pw=weight], cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(Wave 3.5)

reg ln_n_speed_s alloc_off i.week i.wave i.section if wave==6 [pw=weight], cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(Wave 4)

reg ln_n_speed_s alloc_off i.week i.wave i.section if wave>4 [pw=weight], cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(Wave 3.5 \& 4)

reg ln_n_speed_s alloc_off i.week i.wave i.section ln_n_speed_cash [pw=weight], cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(All waves)

reg ln_n_speed_s alloc_off i.week i.wave i.section ln_n_speed_cash if wave==5 [pw=weight], cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(Wave 3.5)

reg ln_n_speed_s alloc_off i.week i.wave i.section ln_n_speed_cash if wave==6 [pw=weight], cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(Wave 4)

reg ln_n_speed_s alloc_off i.week i.wave i.section ln_n_speed_cash if wave>4 [pw=weight], cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(Wave 3.5 \& 4)
}


*High penalty
{
reg ln_n_speed_s_highpenalty alloc_off i.week i.wave i.section, cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", replace  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(All waves)

reg ln_n_speed_s_highpenalty alloc_off i.week i.wave i.section if wave==5, cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(Wave 3.5)

reg ln_n_speed_s_highpenalty alloc_off i.week i.wave i.section if wave==6 , cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(Wave 4)

reg ln_n_speed_s_highpenalty alloc_off i.week i.wave i.section if wave>4, cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(Wave 3.5 \& 4)

reg ln_n_speed_s_highpenalty alloc_off i.week i.wave i.section ln_n_speed_cash, cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(All waves)

reg ln_n_speed_s_highpenalty alloc_off i.week i.wave i.section ln_n_speed_cash if wave==5 , cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(Wave 3.5)

reg ln_n_speed_s_highpenalty alloc_off i.week i.wave i.section ln_n_speed_cash if wave==6, cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(Wave 4)

reg ln_n_speed_s_highpenalty alloc_off i.week i.wave i.section ln_n_speed_cash if wave>4 , cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(Wave 3.5 \& 4)
}


*1.c.a
{
reg ln_n_speed_s alloc_off i.week i.week##i.alloc_off i.wave i.section, cluster( person_week ) 
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t3.tex", replace  noni addtext(Week and Wave FE, Yes) auto(3) ctitle(All waves)
margins week#alloc_off
marginsplot, name(c1, replace) scale(0.7) legend(off) title("All waves") graphregion(color(white)) 


reg ln_n_speed_s alloc_off i.week i.week##i.alloc_off i.section if wave==5 , cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t3.tex", append  noni addtext(Week and Wave FE, Yes) auto(3) ctitle(Wave 3.5)
margins week#alloc_off
marginsplot, name(c2, replace) scale(0.7) legend(off) title("Waves 3.5") graphregion(color(white))


reg ln_n_speed_s alloc_off i.week i.week##i.alloc_off i.section if wave==6 , cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t3.tex", append  noni addtext(Week and Wave FE, Yes) auto(3) ctitle(Wave 4)
margins week#alloc_off
marginsplot, name(c3, replace) scale(0.7) legend(off) title("Waves 4") graphregion(color(white))


reg ln_n_speed_s alloc_off i.week i.week##i.alloc_off i.wave i.section if wave>4 , cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t3.tex", append  noni addtext(Week and Wave FE, Yes) auto(3) ctitle(Wave 3.5 \& 4)
margins week#alloc_off
marginsplot, name(c4, replace) scale(0.7) legend(off) title("Waves 3.5 & 4") graphregion(color(white))
}

graph combine c1 c2 c3 c4, graphregion(color(white)) ycom

*1.c.b
qui{
reg ln_n_speed_s alloc_off i.week i.week##i.alloc_off i.wave i.section ln_n_speed_cash, cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t3.tex", append  noni addtext(Week and Wave FE, Yes) auto(3) ctitle(All waves)
margins week#alloc_off
marginsplot, name(c5, replace) scale(0.7) legend(off) title("All Waves") graphregion(color(white))


reg ln_n_speed_s alloc_off i.week i.week##i.alloc_off ln_n_speed_cash i.section if wave==5 , cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t3.tex", append  noni addtext(Week and Wave FE, Yes) auto(3) ctitle(Wave 3.5)
margins week#alloc_off
marginsplot, name(c6, replace) scale(0.7) legend(off) title("Waves 3.5") graphregion(color(white))


reg ln_n_speed_s alloc_off i.week i.week##i.alloc_off ln_n_speed_cash i.section if wave==6 , cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t3.tex", append  noni addtext(Week and Wave FE, Yes) auto(3) ctitle(Wave 4)
margins week#alloc_off
marginsplot, name(c7, replace) scale(0.7) legend(off) title("Waves 4") graphregion(color(white))


reg ln_n_speed_s alloc_off i.week i.week##i.alloc_off i.wave ln_n_speed_cash i.section if wave>4 , cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t3.tex", append  noni addtext(Week and Wave FE, Yes) auto(3) ctitle(Wave 3.5 \& 4)
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
graph combine c16 c26 c17 c27 , graphregion(color(white)) ycom c(2)



***Testing sensitivity of allocation effect to baseline speed metric

reg ln_n_speed_s alloc_off i.week i.wave i.section  if wave>1, cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t10.tex", replace  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(All waves)  keep(alloc_off )

reg ln_n_speed_s alloc_off i.week i.wave i.section  if wave==5 , cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t10.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(Wave 3.5) keep(alloc_off )

reg ln_n_speed_s alloc_off i.week i.wave i.section  if wave==6, cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t10.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(Wave 4) keep(alloc_off )

reg ln_n_speed_s alloc_off i.week i.wave i.section  if wave>4 , cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t10.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(Wave 3.5 \& 4) keep(alloc_off )


global i=1

foreach x of varlist ln_n_speed_cash ln_n_speed_plain ln_speed_1st16 ln_speed_60min{

reg ln_n_speed_s alloc_off i.week i.wave i.section `x' if wave>1, cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1$i.tex", replace  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(All waves)  keep(alloc_off `x')

reg ln_n_speed_s alloc_off i.week i.wave i.section `x' if wave==5 , cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1$i.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(Wave 3.5) keep(alloc_off `x')

reg ln_n_speed_s alloc_off i.week i.wave i.section `x' if wave==6, cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1$i.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(Wave 4) keep(alloc_off `x')

reg ln_n_speed_s alloc_off i.week i.wave i.section `x' if wave>4 , cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t1$i.tex", append  noni addtext(Section+Week+Wave FE, Yes) auto(3) ctitle(Wave 3.5 \& 4) keep(alloc_off `x')

global i= $i + 1
}





*2.a
{
reg ln_avg16_n_speed_s  pref_office ad_office i.wave if user_n==1 & ad_type!="", cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t21.tex", replace  noni auto(3) ctitle(All waves)

reg ln_avg16_n_speed_s  pref_office ad_office alloc_off i.wave if user_n==1 & ad_type!="", cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t21.tex", append  noni auto(3) ctitle(All waves)

reg ln_avg16_n_speed_s  pref_office ad_office if wave==5 & user_n==1 & ad_type!="", cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t21.tex", append  noni auto(3) ctitle(Wave 3.5)

reg ln_avg16_n_speed_s  pref_office ad_office alloc_off if wave==5 & user_n==1 & ad_type!="", cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t21.tex", append  noni  auto(3) ctitle(Wave 3.5)

reg ln_avg16_n_speed_s  pref_office ad_office if wave==6 & user_n==1 & ad_type!="", cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t21.tex", append  noni  auto(3) ctitle(Wave 4)

reg ln_avg16_n_speed_s  pref_office ad_office alloc_off if wave==6 & user_n==1 & ad_type!="", cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t21.tex", append  noni  auto(3) ctitle(Wave 4)

reg ln_avg16_n_speed_s  pref_office ad_office i.wave if wave>4 & user_n==1 & ad_type!="", cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t21.tex", append  noni  auto(3) ctitle(Wave 3.5 \& 4)

reg ln_avg16_n_speed_s  pref_office ad_office alloc_off i.wave if wave>4 & user_n==1 & ad_type!="", cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t21.tex", append  noni  auto(3) ctitle(Wave 3.5 \& 4)

}

*Selection effect on baseline speed measures 
 

*2.b.2
{
*office ad
reg ln_avg16_n_speed_s pref_office if user_n==1 & ad_office==1, cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2121.tex", replace  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(All waves)

reg ln_avg16_n_speed_s pref_office alloc_off  if user_n==1 & ad_office==1, cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2121.tex", append  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(All waves)

reg ln_avg16_n_speed_s pref_office alloc_off  c.pref_office#c.alloc_off  if user_n==1 & ad_office==1, cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2121.tex", append  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(All waves)


reg ln_avg16_n_speed_s pref_office if wave==5 & user_n==1 & ad_office==1, cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2121.tex", append  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(Wave 4)

reg ln_avg16_n_speed_s pref_office alloc_off if wave==5 & user_n==1 & ad_office==1, cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2121.tex", append  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(Wave 4)

reg ln_avg16_n_speed_s pref_office alloc_off c.pref_office#c.alloc_off if wave==5 & user_n==1 & ad_office==1, cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2121.tex", append  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(Wave 4)


reg ln_avg16_n_speed_s pref_office if wave==6 & user_n==1 & ad_office==1, cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2121.tex", append  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(Wave 3)

reg ln_avg16_n_speed_s pref_office alloc_off if wave==6 & user_n==1 & ad_office==1, cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2121.tex", append  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(Wave 3)

reg ln_avg16_n_speed_s pref_office alloc_off c.pref_office#c.alloc_off if wave==6 & user_n==1 & ad_office==1, cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2121.tex", append  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(Wave 3)


reg ln_avg16_n_speed_s pref_office  if wave>4 & user_n==1 & ad_office==1, cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2121.tex", append  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(Wave 3 \& 4)

reg ln_avg16_n_speed_s pref_office alloc_off  if wave>4 & user_n==1 & ad_office==1, cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2121.tex", append  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(Wave 3 \& 4)

reg ln_avg16_n_speed_s pref_office alloc_off c.pref_office#c.alloc_off  if wave>4 & user_n==1 & ad_office==1, cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2121.tex", append  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(Wave 3 \& 4)


*Home ad
reg ln_avg16_n_speed_s pref_office if user_n==1 & ad_office==0, cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2122.tex", replace  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(All waves)

reg ln_avg16_n_speed_s pref_office alloc_off if user_n==1 & ad_office==0, cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2122.tex", append  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(All waves)

reg ln_avg16_n_speed_s pref_office alloc_off c.pref_office#c.alloc_off if user_n==1 & ad_office==0, cluster( person_week )
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2122.tex", append  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(All waves)


reg ln_avg16_n_speed_s pref_office if wave==5 & user_n==1 & ad_office==0, cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2122.tex", append  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(Wave 4)

reg ln_avg16_n_speed_s pref_office alloc_off if wave==5 & user_n==1 & ad_office==0, cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2122.tex", append  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(Wave 4)

reg ln_avg16_n_speed_s pref_office alloc_off c.pref_office#c.alloc_off if wave==5 & user_n==1 & ad_office==0, cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2122.tex", append  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(Wave 4)


reg ln_avg16_n_speed_s pref_office if wave==6 & user_n==1 & ad_office==0, cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2122.tex", append  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(Wave 3)

reg ln_avg16_n_speed_s pref_office alloc_off if wave==6 & user_n==1 & ad_office==0, cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2122.tex", append  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(Wave 3)

reg ln_avg16_n_speed_s pref_office alloc_off c.pref_office#c.alloc_off if wave==6 & user_n==1 & ad_office==0, cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2122.tex", append  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(Wave 3)


reg ln_avg16_n_speed_s pref_office if wave>4 & user_n==1 & ad_office==0, cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2122.tex", append  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(Wave 3 \& 4)

reg ln_avg16_n_speed_s pref_office alloc_off if wave>4 & user_n==1 & ad_office==0, cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2122.tex", append  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(Wave 3 \& 4)

reg ln_avg16_n_speed_s pref_office alloc_off c.pref_office#c.alloc_off if wave>4 & user_n==1 & ad_office==0, cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2122.tex", append  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(Wave 3 \& 4)

}

*Training preference 
preserve
replace pref_office=Train_Pref 
{

*office ad
reg ln_avg16_n_speed_s pref_office if wave==5 & user_n==1 & ad_office==1, cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2121.tex", replace  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(Wave 4)

reg ln_avg16_n_speed_s pref_office alloc_off if wave==5 & user_n==1 & ad_office==1, cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2121.tex", append  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(Wave 4)

reg ln_avg16_n_speed_s pref_office alloc_off c.pref_office#c.alloc_off if wave==5 & user_n==1 & ad_office==1, cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2121.tex", append  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(Wave 4)


reg ln_avg16_n_speed_s pref_office if wave==6 & user_n==1 & ad_office==1, cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2121.tex", append  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(Wave 3)

reg ln_avg16_n_speed_s pref_office alloc_off if wave==6 & user_n==1 & ad_office==1, cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2121.tex", append  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(Wave 3)

reg ln_avg16_n_speed_s pref_office alloc_off c.pref_office#c.alloc_off if wave==6 & user_n==1 & ad_office==1, cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2121.tex", append  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(Wave 3)


reg ln_avg16_n_speed_s pref_office  if wave>4 & user_n==1 & ad_office==1, cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2121.tex", append  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(Wave 3 \& 4)

reg ln_avg16_n_speed_s pref_office alloc_off  if wave>4 & user_n==1 & ad_office==1, cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2121.tex", append  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(Wave 3 \& 4)

reg ln_avg16_n_speed_s pref_office alloc_off c.pref_office#c.alloc_off  if wave>4 & user_n==1 & ad_office==1, cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2121.tex", append  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(Wave 3 \& 4)


*Home ad

reg ln_avg16_n_speed_s pref_office if wave==5 & user_n==1 & ad_office==0, cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2122.tex", replace  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(Wave 4)

reg ln_avg16_n_speed_s pref_office alloc_off if wave==5 & user_n==1 & ad_office==0, cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2122.tex", append  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(Wave 4)

reg ln_avg16_n_speed_s pref_office alloc_off c.pref_office#c.alloc_off if wave==5 & user_n==1 & ad_office==0, cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2122.tex", append  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(Wave 4)


reg ln_avg16_n_speed_s pref_office if wave==6 & user_n==1 & ad_office==0, cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2122.tex", append  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(Wave 3)

reg ln_avg16_n_speed_s pref_office alloc_off if wave==6 & user_n==1 & ad_office==0, cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2122.tex", append  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(Wave 3)

reg ln_avg16_n_speed_s pref_office alloc_off c.pref_office#c.alloc_off if wave==6 & user_n==1 & ad_office==0, cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2122.tex", append  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(Wave 3)


reg ln_avg16_n_speed_s pref_office if wave>4 & user_n==1 & ad_office==0, cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2122.tex", append  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(Wave 3 \& 4)

reg ln_avg16_n_speed_s pref_office alloc_off if wave>4 & user_n==1 & ad_office==0, cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2122.tex", append  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(Wave 3 \& 4)

reg ln_avg16_n_speed_s pref_office alloc_off c.pref_office#c.alloc_off if wave>4 & user_n==1 & ad_office==0, cluster(person_week)
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t2122.tex", append  noni addtext(Week and Wave FE, Yes) auto(2) ctitle(Wave 3 \& 4)

}
restore

*2.b.3

reg ln_avg16_n_speed_s OO OH HO HH i.wave if user_n==1 & ad_type!="", cluster( person_week ) noc
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t211.tex", replace  noni addtext(Week and Wave FE, Yes) auto(3) ctitle(All waves)

reg ln_avg16_n_speed_s OO OH HO HH alloc_off i.wave if user_n==1 & ad_type!="", cluster( person_week ) noc
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t211.tex", append  noni addtext(Week and Wave FE, Yes) auto(3) ctitle(All waves)

reg ln_avg16_n_speed_s OO OH HO HH if wave==5 & user_n==1 & ad_type!="", cluster(person_week) noc
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t211.tex", append  noni addtext(Week and Wave FE, Yes) auto(3) ctitle(Wave 3.5)

reg ln_avg16_n_speed_s OO OH HO HH alloc_off if wave==5 & user_n==1 & ad_type!="", cluster(person_week) noc
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t211.tex", append  noni addtext(Week and Wave FE, Yes) auto(3) ctitle(Wave 3.5)

reg ln_avg16_n_speed_s OO OH HO HH if wave==6 & user_n==1 & ad_type!="", cluster(person_week) noc
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t211.tex", append  noni addtext(Week and Wave FE, Yes) auto(3) ctitle(Wave 4)

reg ln_avg16_n_speed_s OO OH HO HH alloc_off if wave==6 & user_n==1 & ad_type!="", cluster(person_week) noc
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t211.tex", append  noni addtext(Week and Wave FE, Yes) auto(3) ctitle(Wave 4)

reg ln_avg16_n_speed_s OO OH HO HH i.wave if wave>4 & user_n==1 & ad_type!="", cluster(person_week) noc
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t211.tex", append  noni addtext(Week and Wave FE, Yes) auto(3) ctitle(Wave 3.5 \& 4)

reg ln_avg16_n_speed_s OO OH HO HH alloc_off i.wave if wave>4 & user_n==1 & ad_type!="", cluster(person_week) noc
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t211.tex", append  noni addtext(Week and Wave FE, Yes) auto(3) ctitle(Wave 3.5 \& 4)

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

 reg ln_avg16_n_speed_s OO OH HO HH alloc_off if wave==5 & user_n==1 & ad_type!="", cluster(person_week) noc
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t31.tex", replace  noni auto(3) ctitle(Wave 3.5) noas

reg ln_avg16_n_speed_s OO OH HO HH alloc_off if wave==6 & user_n==1 & ad_type!="", cluster(person_week) noc
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t31.tex", append  noni auto(3) ctitle(Wave 4) noas

foreach lname of varlist  w_demo_Gender w_demo_Married w_demo_distance w_demo_Age w_demo_ChildrenNum{
reg ln_avg16_n_speed_s OO OH HO HH OO`lname' OH`lname' HO`lname' HH`lname' alloc_off if wave==5 & user_n==1 & ad_type!="", cluster(person_week) noc 
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t31.tex", append  noni auto(3) ctitle(Wave 3.5) noas

reg ln_avg16_n_speed_s OO OH HO HH OO`lname' OH`lname' HO`lname' HH`lname' alloc_off if wave==6 & user_n==1 & ad_type!="", cluster(person_week) noc 
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t31.tex", append  noni auto(3) ctitle(Wave 4) noas
}


*2.d
reg ln_avg16_n_speed_s OO OH HO HH OOO OHO HOO HHO  i.wave if user_n==1 & ad_type!="", cluster( person_week ) noc
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t24.tex", replace  noni addtext(Week and Wave FE, Yes) auto(3) ctitle(All waves)

reg ln_avg16_n_speed_s OO OH HO HH OOO OHO HOO HHO  if wave==5 & user_n==1 & ad_type!="", cluster(person_week) noc
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t24.tex", append  noni addtext(Week and Wave FE, Yes) auto(3) ctitle(Wave 3.5)

reg ln_avg16_n_speed_s OO OH HO HH OOO OHO HOO HHO  if wave==6 & user_n==1 & ad_type!="", cluster(person_week) noc
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t24.tex", append  noni addtext(Week and Wave FE, Yes) auto(3) ctitle(Wave 4)

reg ln_avg16_n_speed_s OO OH HO HH OOO OHO HOO HHO  i.wave if wave>4 & user_n==1 & ad_type!="", cluster(person_week) noc
outreg2 using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\tex files\regressions\t24.tex", append  noni addtext(Week and Wave FE, Yes) auto(3) ctitle(Wave 3.5 \& 4)




