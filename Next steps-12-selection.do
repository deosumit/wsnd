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

global outreg_setting "noni auto(2) keep(pref_office alloc_off c.pref_office#c.alloc_off c.ln_n_speed_cash#c.pref_office ln_n_speed_cash) tex(frag) nonotes addtext(Section+Week+Wave FE, Yes)"

*********Defining speed variable*************

gen bl_speed = log(w60_min_netspeed) if user_n==1
replace bl_speed = log(cash_net_speed) if user_n==2
replace bl_speed = log(plain_net_speed ) if user_n==3

drop _merge
merge m:1 recruitmentid_new using "C:\Users\sumit\Documents\Work\Worker Sorting\My work\03. Datasets\31. Surveys\312. walk in\3124. Final Dataset\Walkin_Cleaned_Encoded.dta"
drop if _merge==2
drop _merge

*********Regression Analysis*************



***Cleaning Reason Data********************

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


/*
gen reason=""
replace reason="w_h_expenses" in 1
replace reason="w_h_flexibility" in 2
replace reason="w_h_parttime_comm" in 3
replace reason="w_h_travel" in 4
replace reason="w_h_familycare" in 5
replace reason="w_h_permission" in 6
replace reason="w_h_negative" in 7
replace reason="w_h_others" in 8

replace reason="w_o_office_environ" in 9
replace reason="w_o_convinient" in 10
replace reason="w_o_9to5" in 11
replace reason="w_o_nodisturb" in 12
replace reason="w_o_network" in 13
replace reason="w_o_easeissues" in 14
replace reason="w_o_getexperience" in 15
replace reason="w_o_others" in 16


gen rsn_prop=.

global i=1

foreach v of varlist w_h_expenses w_h_flexibility w_h_parttime_comm w_h_travel w_h_familycare w_h_permission w_h_negative w_h_others {
count if `v'==1 & wave>3 & user_n==1
replace rsn_prop= (r(N) / 87 )*100 in $i
global i= $i + 1
 }     

 
"Expenses shoot up: cloths food outside, transportation 5.Expenses shoot up: cloths food outside, transportation / ஆடைகள் வெளியே உணவு சாப்பிடுவது , போக்குவரத்து போன்ற செலவுகள் மிச்சம்
 
 foreach v of varlist w_o_office_environ w_o_convinient w_o_9to5 w_o_nodisturb w_o_network w_o_easeissues w_o_getexperience w_o_others {
count if `v'==1 & wave>3 & user_n==1
replace rsn_prop= (r(N) / 148 )*100 in $i
global i= $i + 1
 }     

 
*/

 
reg bl_speed  pref_office i.wave i.user_n if wave>3 & user_n<4, cluster( recruitmentid_new )
outreg2 using "$regdir\update10", replace  $outreg_setting ctitle(Baseline, Speed) 

reg ln_n_speed_s pref_office alloc_off  c.pref_office#c.alloc_off i.wave i.week i.section if wave>4 [pw=weight], cluster( person_week )
outreg2 using "$regdir\update10.tex", append  $outreg_setting ctitle(Speed)

reg ln_n_speed_s pref_office alloc_off  c.pref_office#c.alloc_off i.wave i.week i.section ln_n_speed_cash if wave>4 [pw=weight], cluster( person_week )
outreg2 using "$regdir\update10.tex", append  $outreg_setting ctitle(Speed)

reg ln_n_speed_s pref_office alloc_off  c.pref_office#c.alloc_off i.wave i.week i.section ln_n_speed_cash c.ln_n_speed_cash#c.pref_office if wave>4 [pw=weight], cluster( person_week )
outreg2 using "$regdir\update10.tex", append  $outreg_setting ctitle(Speed)

/*
reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if wave>3 & week==3 & userweek_n==1, cluster( recruitmentid_new  )
outreg2 using "$regdir\update10", append  $outreg_setting ctitle(Learning, Week 3) 

reg learning  pref_office alloc_off  c.pref_office#c.alloc_off  i.wave i.week if wave>3 & week==1 & userweek_n==1, cluster( recruitmentid_new  )
outreg2 using "$regdir\update10", append  $outreg_setting ctitle(Learning, Week 1) 
*/

**********************************************

preserve





restore 


***************************


