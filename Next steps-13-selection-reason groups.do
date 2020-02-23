
use "C:\Users\sumit\Documents\Work\Worker Sorting\My work\Final.dta", clear


set mem 5g
set more off

global workdir "C:\Users\sumit\Documents\Work\Worker Sorting\My work"
global regdir "$workdir\tex files\reg_dec2019"

global outreg_setting "noni auto(2) keep(pref_office alloc_off c.pref_office#c.alloc_off pref_home alloc_home  c.pref_home#c.alloc_home) tex(frag) nonotes"

*==================
*Defining Variables
*==================

gen pref_home=1-pref_off
gen alloc_home=1-alloc_off

gen pref_office=pref_off


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

*===================
*Regression Analysis
*===================


	*Home Preference
	*==============
	*###############
	
	**Baseline
	
	reg bl_speed  pref_home i.wave i.user_n if wave>3 & user_n<4 & sample==3, cluster( recruitmentid_new )
		outreg2 using "$regdir\baseline_home", replace  $outreg_setting ctitle(Overall) 

	foreach x of varlist h_familycare  h_parttime_comm h_travel h_expenses { 
		replace pref_home=`x'
		reg bl_speed  pref_home i.wave i.user_n if wave>3 & user_n<4 & (pref_office==1 | pref_home==1 ) & sample==3, cluster( recruitmentid_new )
			outreg2 using "$regdir\baseline_home", append  $outreg_setting ctitle("`x'") 
	}

	replace pref_home=1-pref_off

	*Normal Speed
	*===============

	**Treatment
	reg ln_n_speed_s pref_home alloc_home  c.pref_home#c.alloc_home i.wave i.week i.section if wave>4 & sample==3 [pw=weight], cluster( person_week )
		outreg2 using "$regdir\treatment_home", replace  $outreg_setting ctitle(Overall) 

	foreach x of varlist h_familycare  h_parttime_comm h_travel h_expenses { 
		replace pref_home=`x'
		reg ln_n_speed_s pref_home alloc_home  c.pref_home#c.alloc_home i.wave i.week i.section if wave>4 & sample==3 & (pref_office==1 | pref_home==1 ) [pw=weight], cluster( person_week )
			outreg2 using "$regdir\treatment_home", append  $outreg_setting ctitle("`x'") 
	}
	replace pref_home=1-pref_off


	**Learning
	reg ln_n_speed_s pref_home alloc_home  c.pref_home#c.alloc_home i.wave i.week i.section ln_n_speed_cash if wave>4 & sample==3 [pw=weight], cluster( person_week )
		outreg2 using "$regdir\learning_home", replace  $outreg_setting ctitle(Overall) 

	foreach x of varlist h_familycare  h_parttime_comm h_travel h_expenses { 
		replace pref_home=`x'
		reg ln_n_speed_s pref_home alloc_home  c.pref_home#c.alloc_home i.wave i.week i.section ln_n_speed_cash if wave>4 & sample==3 & (pref_office==1 | pref_home==1 ) [pw=weight], cluster( person_week )
			outreg2 using "$regdir\learning_home", append  $outreg_setting ctitle("`x'") 
	}
	replace pref_home=1-pref_off
	
	
	{	/*
		**Alternative specification
		reg ln_n_speed_s pref_office alloc_off  c.pref_office#c.alloc_off i.wave i.week i.section if wave>4 & sample==3  [pw=weight], cluster( person_week )
			outreg2 using "$regdir\treatment_home1", replace  $outreg_setting ctitle(Overall) 

		foreach x of varlist h_familycare  h_parttime_comm h_travel h_expenses { 
			replace pref_home=`x'
			reg ln_n_speed_s pref_office alloc_off  c.pref_office#c.alloc_off i.wave i.week i.section if wave>4 & (pref_office==1 | pref_home==1 ) & sample==3 [pw=weight], cluster( person_week )
				outreg2 using "$regdir\treatment_home1", append  $outreg_setting ctitle("`x'") 
		}
		replace pref_home=1-pref_off
		*/
	}
	*Exponentialy Penalised Speed
	*###############


	
	**Treatment
	reg ln_n_speed_s_highpenalty pref_home alloc_home  c.pref_home#c.alloc_home i.wave i.week i.section if wave>4 & sample==3 & ln_n_speed_s!=. [pw=weight], cluster( person_week )
		outreg2 using "$regdir\treatment_home_p", replace  $outreg_setting ctitle(Overall) 

	foreach x of varlist h_familycare  h_parttime_comm h_travel h_expenses { 
		replace pref_home=`x'
		reg ln_n_speed_s_highpenalty pref_home alloc_home  c.pref_home#c.alloc_home i.wave i.week i.section if wave>4 & sample==3  & ln_n_speed_s!=.  & (pref_office==1 | pref_home==1 ) [pw=weight], cluster( person_week )
			outreg2 using "$regdir\treatment_home_p", append  $outreg_setting ctitle("`x'") 
	}
	replace pref_home=1-pref_off


	**Learning
	reg ln_n_speed_s_highpenalty pref_home alloc_home  c.pref_home#c.alloc_home i.wave i.week i.section ln_n_speed_cash if wave>4  & ln_n_speed_s!=. & sample==3 [pw=weight], cluster( person_week )
		outreg2 using "$regdir\learning_home_p", replace  $outreg_setting ctitle(Overall) 

	foreach x of varlist h_familycare  h_parttime_comm h_travel h_expenses { 
		replace pref_home=`x'
		reg ln_n_speed_s_highpenalty pref_home alloc_home  c.pref_home#c.alloc_home i.wave i.week i.section ln_n_speed_cash if wave>4  & ln_n_speed_s!=. & sample==3 & (pref_office==1 | pref_home==1 ) [pw=weight], cluster( person_week )
			outreg2 using "$regdir\learning_home_p", append  $outreg_setting ctitle("`x'") 
	}
	replace pref_home=1-pref_off	
	
	
	
	
	
	
	
	*Office reasons
	*==============
	**Baseline
	reg bl_speed  pref_off i.wave i.user_n if wave>3 & user_n<4 & sample==3, cluster( recruitmentid_new )
		outreg2 using "$regdir\baseline_off", replace  $outreg_setting ctitle(Overall) 

	foreach x of varlist o_nodisturb o_network o_convinient o_easeissues o_9to5 o_office_environ o_getexperience { 
		replace pref_office=`x'
		reg bl_speed  pref_office i.wave i.user_n if wave>3 & user_n<4 & (pref_office==1 | pref_home==1 ) & sample==3, cluster( recruitmentid_new )
			outreg2 using "$regdir\baseline_off", append  $outreg_setting ctitle("`x'") 

	}
	replace pref_office=pref_off

	**Treatment
	reg ln_n_speed_s pref_office alloc_off  c.pref_office#c.alloc_off i.wave i.week i.section if wave>4 & sample==3 [pw=weight], cluster( person_week )
		outreg2 using "$regdir\treatment_off", replace  $outreg_setting ctitle(Overall) 

	foreach x of varlist o_nodisturb o_network o_convinient o_easeissues o_9to5 o_office_environ o_getexperience { 
		replace pref_office=`x'
		reg ln_n_speed_s pref_office alloc_off  c.pref_office#c.alloc_off i.wave i.week i.section if wave>4 & (pref_office==1 | pref_home==1 ) & sample==3 [pw=weight], cluster( person_week )
			outreg2 using "$regdir\treatment_off", append  $outreg_setting ctitle("`x'") 
	}
	replace pref_office=pref_off
	
	
	**learning
	reg ln_n_speed_s pref_office alloc_off  c.pref_office#c.alloc_off i.wave i.week i.section ln_n_speed_cash if wave>4 & sample==3 [pw=weight], cluster( person_week )
		outreg2 using "$regdir\learning_off", replace  $outreg_setting ctitle(Overall) 

	foreach x of varlist o_nodisturb o_network o_convinient o_easeissues o_9to5 o_office_environ o_getexperience { 
		replace pref_office=`x'
		reg ln_n_speed_s pref_office alloc_off  c.pref_office#c.alloc_off i.wave i.week i.section ln_n_speed_cash if wave>4 & (pref_office==1 | pref_home==1 ) & sample==3 [pw=weight], cluster( person_week )
			outreg2 using "$regdir\learning_off", append  $outreg_setting ctitle("`x'") 
	}
	replace pref_office=pref_off
	
	
	

	
		
	*Office reasons
	*==============


	**Treatment
	reg ln_n_speed_s_highpenalty pref_office alloc_off  c.pref_office#c.alloc_off i.wave i.week i.section if wave>4 & sample==3 [pw=weight], cluster( person_week )
		outreg2 using "$regdir\treatment_off_p", replace  $outreg_setting ctitle(Overall) 

	foreach x of varlist o_nodisturb o_network o_convinient o_easeissues o_9to5 o_office_environ o_getexperience { 
		replace pref_office=`x'
		reg ln_n_speed_s_highpenalty pref_office alloc_off  c.pref_office#c.alloc_off i.wave i.week i.section if wave>4 & (pref_office==1 | pref_home==1 ) & sample==3 [pw=weight], cluster( person_week )
			outreg2 using "$regdir\treatment_off_p", append  $outreg_setting ctitle("`x'") 
	}
	replace pref_office=pref_off
	
	
	**learning
	reg ln_n_speed_s_highpenalty pref_office alloc_off  c.pref_office#c.alloc_off i.wave i.week i.section ln_n_speed_cash if wave>4 & sample==3 [pw=weight], cluster( person_week )
		outreg2 using "$regdir\learning_off_p", replace  $outreg_setting ctitle(Overall) 

	foreach x of varlist o_nodisturb o_network o_convinient o_easeissues o_9to5 o_office_environ o_getexperience { 
		replace pref_office=`x'
		reg ln_n_speed_s_highpenalty pref_office alloc_off  c.pref_office#c.alloc_off i.wave i.week i.section ln_n_speed_cash if wave>4 & (pref_office==1 | pref_home==1 ) & sample==3 [pw=weight], cluster( person_week )
			outreg2 using "$regdir\learning_off_p", append  $outreg_setting ctitle("`x'") 
	}
	replace pref_office=pref_off
