*** Load Data ***

	cd "C:\Users\Tyler\Desktop\000204\batch_0\result"
	
	use 000204.dta, clear
	
***Sumarize statistics***
	
	asdoc sum PORN30 MARITAL TVHOURS EDUC AGE RINCOME RELITEN XMOVIE YEAR 
	
***Replace missing data*** 
	
	foreach x in TVHOURS EDUC AGE RINCOME RELITEN XMOVIE {
    gen `x'_d = (`x' == .d)
    replace `x' = 0 if `x'_d
}

	foreach x in TVHOURS EDUC AGE RINCOME RELITEN XMOVIE {
    gen `x'_n = (`x' == .n)
    replace `x' = 0 if `x'_n
}

	foreach x in TVHOURS EDUC AGE RINCOME RELITEN XMOVIE {
    gen `x'_s = (`x' == .s)
    replace `x' = 0 if `x'_s
}

	foreach x in TVHOURS EDUC AGE RINCOME RELITEN XMOVIE {
    gen `x'_i = (`x' == .i)
    replace `x' = 0 if `x'_i
}
***Control Variables***
	local controls YEAR ID_ TVHOURS EDUC AGE RINCOME RELITEN XMOVIE 
		
***Generate never married***
	gen nevmarried=0
	replace nevmarried=1 if MARITAL==5
	
	
*** Categorial Dummy Varibles for PORN30 **

	gen pornnever=0
	replace pornnever=1 if PORN30==1
	
	gen porn12=0
	replace porn12=1 if PORN30==2
	
	gen porn35=0
	replace porn35=1 if PORN30==3
	
	gen porn5=0
	replace porn5=1 if PORN30==4
	
*** Dropping missing data ***

	drop PORNINF PORNMORL PORNRAPE WEBMOB PORNOUT AGEWED COHABOK HRS2  
	
*** Base regress model ***
	*regress nevmarried porn12 porn35 porn5 
	*outreg2 using "000204.xls", se bracket replace 
	
	*regress nevmarried porn12 porn35 porn5 `controls'
	*outreg2 using "000204.xls", se bracket append 

	logit nevmarried porn12 porn35 porn5 
	margeff, replace
	outreg2 using "000204.xls", se bracket replace 
	
*** Base with Controls ***

	logit nevmarried porn12 porn35 porn5 `controls' 
	margeff, replace 
	outreg2 using "000204.xls", se bracket append 
	
*** Men vs Women ***

	gen mennever=0
	replace mennever=1 if MARITAL==5 & SEX==1
	
	gen femnever=0
	replace femnever=1 if MARITAL==5 & SEX==2

	
** OUT PUT **
	logit mennever porn12 porn35 porn5 
	margeff, replace
	outreg2 using "000204.xls", se bracket append 
	
	logit mennever porn12 porn35 porn5 `controls'
	margeff, replace
	outreg2 using "000204.xls", se bracket append 

	
*** Base with Controls, and YEAR ***

	*logit nevmarried porn12 porn35 porn5 `controls' ,absorb(YEAR)
	*margeff
	*outreg2 using "000204.xls", se bracket append 

