import delimited using D:\OneDrive\Uczelnia\RSM\Thesis\Analysis\data.csv, delimiters(";") clear

/*
* Data cleanup and coding
*/

drop if real(durationinseconds) < 300
keep if finished == "True"
drop if displayed_block == "Decoupling-Response-and-Feedback-in-Time"

generate test1 = 1
generate test2 = 2
replace test1 = 1 if q19 == "Yes"
replace test2 = 2 if q19 == "No"
replace test2 = 1 if q20 == "Yes"
replace test2 = 2 if q20 == "No"

keep if test1 == 1
keep if test2 == 2

generate test3 = 1
generate test4 = 1
replace test3 = 1 if q15 == "That teammates’ critique will make you feel some discomfort."
replace test3 = 2 if q15 == "That you should start as soon as you can."
replace test3 = 3 if q15 == "That previous entrepreneurship booth failed to achieve its goal."
replace test3 = 4 if q15 == "That Startup Incubator does not like the idea of joint booth."
replace test3 = . if missing(q15)

replace test4 = 1 if q17 == "That your teammates will be devil’s advocates."
replace test4 = 2 if q17 == "That you should start as soon as you can."
replace test4 = 3 if q17 == "That previous entrepreneurship booth failed to achieve its goal."
replace test4 = 4 if q17 == "That Startup Incubator does not like the idea of joint booth."
replace test4 = . if missing(q17)

keep if test3 == 1 | missing(test3)
keep if test4 == 1 | missing(test4)

generate cog_level = 0
replace cog_level = 0 if cognitive_level == "Low"
replace cog_level = 1 if cognitive_level == "High"
label define cog_level_label 0 "Low" 1 "High"
label values cog_level cog_level_label

generate restrat = 0
replace restrat = 0 if displayed_block == "No-Resolution-Strategy"
replace restrat = 1 if displayed_block == "Decision-making-as-a-Play"
replace restrat = 2 if displayed_block == "Cognitive-Understanding-of-the-Paradox"
label define restrat_label 0 "RS0" 1 "RS1" 2 "RS2"
label values restrat restrat_label

generate cog1 = 1
replace cog1 = 1 if q23 == "Did not disagree"
replace cog1 = 2 if q23 == "Disagreed a little bit"
replace cog1 = 3 if q23 == "Somewhat disagreed"
replace cog1 = 4 if q23 == "Disagreed"
replace cog1 = 5 if q23 == "Very much disagreed"

generate cog2 = 1
replace cog2 = 1 if q24 == "Provided the same"
replace cog2 = 2 if q24 == "Provided very similar"
replace cog2 = 3 if q24 == "Provided somewhat similar"
replace cog2 = 4 if q24 == "Provided a bit different"
replace cog2 = 5 if q24 == "Provided a very different"

generate wtc1 = 1
replace wtc1 = 1 if q25 == "Strongly negative"
replace wtc1 = 2 if q25 == "Negative"
replace wtc1 = 3 if q25 == "Neutral"
replace wtc1 = 4 if q25 == "Positive"
replace wtc1 = 5 if q25 == "Strongly positive"

generate wtc2 = 1
replace wtc2 = 1 if q26 == "Don’t want to"
replace wtc2 = 2 if q26 == "May or may not"
replace wtc2 = 3 if q26 == "Want a little bit to"
replace wtc2 = 4 if q26 == "Want to"
replace wtc2 = 5 if q26 == "Very much want to"

generate gender = 0
replace gender = 0 if q32 == "Male"
replace gender = 1 if q32 == "Female"
label define gender_label 0 "Male" 1 "Female"
label values gender gender_label

generate education = 0
replace education = 0 if q34 == "Primary education"
replace education = 1 if q34 == "Secondary or post-secondary education"
replace education = 2 if q34 == "Bachelor's degree"
replace education = 3 if q34 == "Master's degree"
replace education = 4 if q34 == "Ph.D. or higher"
label define education_label 0 "Primary education" 1 "Secondary or post-secondary education" 2 "Bachelor's degree" 3 "Master's degree" 4 "Ph.D. or higher"
label values education education_label

generate position = 0
replace position = 1 if q36 == "Regular employee, specialist, or other operational roles"
replace position = 2 if q36 == "Manager"
replace position = 3 if q36 == "Executive"
replace position = 0 if missing(q36)
label define position_label 0 "Never held any position" 1 "Regular employee, specialist, or other operational roles" 2 "Manager" 3 "Executive"
label values position position_label

egen id = group(responseid)

generate ind_cog = (cog1 + cog2) / 2
generate wtc = (wtc1 + wtc2) / 2

label variable cog_level "Cognitive Conflict Level"
label variable ind_cog "Perceived Cognifive Conflict"
label variable wtc "Willingness to Cooperate"
label variable gender "Gender"
label variable education "Education Level"
label variable position "Position in a Company"
label variable restrat "Resolution Strategy"

keep id cog_level restrat cog1 cog2 wtc1 wtc2 gender education position ind_cog wtc

/*
* Analysis
*/

sum wtc ind_cog cog_level education position wtc ind_cog
tab1 cog_level restrat gender education position
cor cog_level education position wtc ind_cog

alpha cog1 cog2
alpha wtc1 wtc2

ktau education position
tab gender education, chi2
tab gender position, chi2
tab gender restrat, chi2
tab education restrat, chi2

anova ind_cog cog_level

sum ind_cog if cog_level == 0
sum ind_cog if cog_level == 1

mixed c.wtc i.restrat i.cog_level, baselevels vce(robust)
est store rwtc1

mixed c.wtc i.cog_level##i.restrat, baselevels vce(robust)
est store rwtc2

mixed c.wtc i.restrat i.cog_level i.gender i.education i.position, baselevels vce(robust)
est store rwtc3

mixed c.wtc i.cog_level##i.restrat i.gender i.education i.position, baselevels vce(robust)
est store rwtc4

contrast cog_level##restrat gender education position
contrast cog_level, effects
contrast restrat@cog_level, effects
contrast restrat@cog_level, effects mcompare(bonferroni)

esttab rwtc1 rwtc2 rwtc3 rwtc4 using wtc.rtf, p compress one nogap label nomtitles replace

mixed c.ind_cog i.restrat i.cog_level, baselevels vce(robust)
est store rind1

mixed c.ind_cog i.cog_level##i.restrat , baselevels vce(robust)
est store rind2

mixed c.ind_cog i.restrat i.cog_level i.gender i.education i.position, baselevels vce(robust)
est store rind3

mixed c.ind_cog i.cog_level##i.restrat i.gender i.education i.position, baselevels vce(robust)
est store rind4

contrast cog_level##restrat gender education position
contrast cog_level, effects
contrast education, effects
contrast education, effects mcompare(bonferroni)
contrast r.b2.education, effects
contrast r.b2.education, effects mcompare(bonferroni)
contrast restrat@cog_level, effects mcompare(bonferroni)

margins, at(cog_level = (0 1) restrat = (0 2)) asbalanced
marginsplot, noci title("Perceived Cognitive Conflict Predictive Margins") ytitle("Perceived Cognitive Conflict")
graph export ind1.png, replace
margins, dydx(cog_level) at(restrat = (0 2)) asbalanced
marginsplot, noci title("Average Marginal Effect of High Cognitive Conflict") ytitle("Effects on Perceived Cognitive Conflict")
graph export ind2.png, replace

esttab rind1 rind2 rind3 rind4 using ind_cog.rtf, p compress one nogap label nomtitles replace
