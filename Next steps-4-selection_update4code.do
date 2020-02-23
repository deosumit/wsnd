


*First 4 surveys 
reg ln_n_speed_s  pref_office  i.section if  ad_office==0 & attempt_seq<17, cluster( person_week )
outreg2 using "$regdir\t2121.tex", replace  $outreg_setting ctitle(All waves)

reg ln_n_speed_s  pref_office alloc_off  i.section if  ad_office==0 & attempt_seq<17, cluster( person_week )
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(All waves)

reg ln_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.section if  ad_office==0 & attempt_seq<17, cluster( person_week )
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(All waves)


reg ln_n_speed_s  pref_office i.section if wave==5 &  ad_office==0 & attempt_seq<17 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s  pref_office alloc_off i.section if wave==5 &  ad_office==0 & attempt_seq<17 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off i.section if wave==5 &  ad_office==0 & attempt_seq<17, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5)


reg ln_n_speed_s  pref_office i.section if wave==6 &  ad_office==0 & attempt_seq<17, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s  pref_office alloc_off i.section if wave==6 &  ad_office==0 & attempt_seq<17, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off i.section if wave==6 &  ad_office==0 & attempt_seq<17, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)


reg ln_n_speed_s  pref_office  i.section if wave>4 &  ad_office==0 & attempt_seq<17, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_n_speed_s  pref_office alloc_off  i.section if wave>4 &  ad_office==0 & attempt_seq<17, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off  i.section if wave>4 &  ad_office==0 & attempt_seq<17, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)



gen weight_fw=1/no_survey_week 

*First week
reg ln_n_speed_s  pref_office  i.section  [pw=weight_fw] if  ad_office==0 & week==1, cluster( person_week )
outreg2 using "$regdir\t2121.tex", replace  $outreg_setting ctitle(All waves)

reg ln_n_speed_s  pref_office alloc_off  i.section  [pw=weight_fw] if  ad_office==0 & week==1, cluster( person_week )
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(All waves)

reg ln_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.section  [pw=weight_fw] if  ad_office==0 & week==1, cluster( person_week )
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(All waves)


reg ln_n_speed_s  pref_office i.section  [pw=weight_fw] if wave==5 &  ad_office==0 & week==1 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s  pref_office alloc_off i.section  [pw=weight_fw] if wave==5 &  ad_office==0 & week==1 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off i.section  [pw=weight_fw] if wave==5 &  ad_office==0 & week==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5)


reg ln_n_speed_s  pref_office i.section  [pw=weight_fw] if wave==6 &  ad_office==0 & week==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s  pref_office alloc_off i.section  [pw=weight_fw] if wave==6 &  ad_office==0 & week==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off i.section  [pw=weight_fw] if wave==6 &  ad_office==0 & week==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)


reg ln_n_speed_s  pref_office  i.section  [pw=weight_fw] if wave>4 &  ad_office==0 & week==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_n_speed_s  pref_office alloc_off  i.section  [pw=weight_fw] if wave>4 &  ad_office==0 & week==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off  i.section  [pw=weight_fw] if wave>4 &  ad_office==0 & week==1, cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)




*All weeks 

reg ln_n_speed_s  pref_office  i.section i.week [pw=weight] if  ad_office==0 , cluster( person_week )
outreg2 using "$regdir\t2121.tex", replace  $outreg_setting ctitle(All waves)

reg ln_n_speed_s  pref_office alloc_off  i.section i.week  [pw=weight] if  ad_office==0 , cluster( person_week )
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(All waves)

reg ln_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.section i.week [pw=weight] if  ad_office==0, cluster( person_week )
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(All waves)


reg ln_n_speed_s  pref_office i.section i.week [pw=weight] if wave==5 &  ad_office==0  , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s  pref_office alloc_off i.section i.week [pw=weight] if wave==5 &  ad_office==0  , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off i.section i.week [pw=weight] if wave==5 &  ad_office==0 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5)


reg ln_n_speed_s  pref_office i.section i.week [pw=weight] if wave==6 &  ad_office==0 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s  pref_office alloc_off i.section i.week [pw=weight] if wave==6 &  ad_office==0 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off i.section i.week [pw=weight] if wave==6 &  ad_office==0 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)


reg ln_n_speed_s  pref_office  i.section i.week [pw=weight] if wave>4 &  ad_office==0 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_n_speed_s  pref_office alloc_off  i.section i.week [pw=weight] if wave>4 &  ad_office==0 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off  i.section i.week [pw=weight] if wave>4 &  ad_office==0 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)


*All weeks but excluding week effects

reg ln_n_speed_s  pref_office  i.section  [pw=weight] if  ad_office==0 , cluster( person_week )
outreg2 using "$regdir\t2121.tex", replace  $outreg_setting ctitle(All waves)

reg ln_n_speed_s  pref_office alloc_off  i.section   [pw=weight] if  ad_office==0 , cluster( person_week )
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(All waves)

reg ln_n_speed_s  pref_office alloc_off  c.pref_office#c.alloc_off  i.section  [pw=weight] if  ad_office==0, cluster( person_week )
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(All waves)


reg ln_n_speed_s  pref_office i.section  [pw=weight] if wave==5 &  ad_office==0  , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s  pref_office alloc_off i.section  [pw=weight] if wave==5 &  ad_office==0  , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off i.section  [pw=weight] if wave==5 &  ad_office==0 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5)


reg ln_n_speed_s  pref_office i.section  [pw=weight] if wave==6 &  ad_office==0 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s  pref_office alloc_off i.section  [pw=weight] if wave==6 &  ad_office==0 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off i.section  [pw=weight] if wave==6 &  ad_office==0 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 4)


reg ln_n_speed_s  pref_office  i.section  [pw=weight] if wave>4 &  ad_office==0 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_n_speed_s  pref_office alloc_off  i.section  [pw=weight] if wave>4 &  ad_office==0 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)

reg ln_n_speed_s  pref_office alloc_off c.pref_office#c.alloc_off  i.section  [pw=weight] if wave>4 &  ad_office==0 , cluster(person_week)
outreg2 using "$regdir\t2121.tex", append  $outreg_setting ctitle(Wave 3.5 \& 4)
