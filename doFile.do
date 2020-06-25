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

generate age = 0
replace age = 0 if q33 == "Under 18"
replace age = 1 if q33 == "18 - 24"
replace age = 2 if q33 == "25 - 34"
replace age = 3 if q33 == "35 - 44"
replace age = 4 if q33 == "45 - 54"
replace age = 5 if q33 == "55 - 64"
replace age = 6 if q33 == "65 - 74"
replace age = 7 if q33 == "75 - 84"
replace age = 8 if q33 == "85 or older"
label define age_label 0 "Under 18" 1 "18 - 24" 2 "25 - 34" 3 "35 - 44" 4 "45 - 54" 5 "55 - 64" 6 "65 - 74" 7 "75 - 84" 8 "85 or older"
label values age age_label

generate education = 0
replace education = 0 if q34 == "Primary education"
replace education = 1 if q34 == "Secondary or post-secondary education"
replace education = 2 if q34 == "Bachelor's degree"
replace education = 3 if q34 == "Master's degree"
replace education = 4 if q34 == "Ph.D. or higher"
label define education_label 0 "Primary education" 1 "Secondary or post-secondary education" 2 "Bachelor's degree" 3 "Master's degree" 4 "Ph.D. or higher"
label values education education_label

generate experience = 0
replace experience = 0 if q35 == "I do not have any professional experience"
replace experience = 1 if q35 == "0-2 years"
replace experience = 2 if q35 == "3-5 years"
replace experience = 3 if q35 == "5-7 years"
replace experience = 4 if q35 == "7 or more years"
label define experience_label 0 "I do not have any professional experience" 1 "0-2 years" 2 "3-5 years" 3 "5-7 years" 4 "7 or more years"
label values experience experience_label

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
label variable gender "Gender (female)"
label variable education "Education Level"
label variable experience "Years of Professional Experience"
label variable position "Position in Company"
label variable restrat "Resolution Strategy"

keep id cog_level restrat cog1 cog2 wtc1 wtc2 gender age education experience position ind_cog wtc

/*
* Analysis
*/

tab cog_level restrat
tab1 gender education position

alpha cog1 cog2
alpha wtc1 wtc2

ktau education position
tab gender education, chi2
tab gender position, chi2
tab gender restrat, chi2
tab experience restrat, chi2
tab education restrat, chi2

anova ind_cog cog_level
est store anova1

sum ind_cog if cog_level == 0
sum ind_cog if cog_level == 1

mixed c.wtc i.restrat i.cog_level, baselevels vce(robust)
est store a1

mixed c.wtc i.restrat i.cog_level i.gender i.education i.position, baselevels vce(robust)
est store a3

mixed c.wtc i.cog_level##i.restrat, baselevels vce(robust)
est store b1

mixed c.wtc i.cog_level##i.restrat i.gender i.education i.position, baselevels vce(robust)
est store b3

contrast cog_level##g.restrat gender education position
contrast cog_level, effects

margins, at(cog_level = (0 1) restrat = (0 2))
marginsplot, noci title("Willingness to Cooperate Predictive Margins") ytitle("Willingness to Cooperate")
graph export wtc1.png, replace
margins, dydx(cog_level) at(restrat = (0 2))
marginsplot, noci title("Average Marginal Effect of High Cognitive Conflict") ytitle("Effects on Willingness to Cooperate")
graph export wtc2.png, replace

esttab a1 b1 a3 b3 using wtc.rtf, p compress one nogap label nomtitles replace

mixed c.ind_cog i.restrat i.cog_level, baselevels vce(robust)
est store a1

mixed c.ind_cog i.restrat i.cog_level i.gender i.education i.position, baselevels vce(robust)
est store a3

mixed c.ind_cog i.cog_level##i.restrat , baselevels vce(robust)
est store b1

mixed c.ind_cog i.cog_level##i.restrat i.gender i.education i.position , baselevels vce(robust)
est store b3

contrast cog_level##g.restrat gender education position
contrast cog_level, effects
contrast r.b2.education, effects mcompare(bonferroni)
contrast restrat@cog_level, effects mcompare(bonferroni)

margins, at(cog_level = (0 1) restrat = (0 2))
marginsplot, noci title("Perceived Cognitive Conflict Predictive Margins") ytitle("Perceived Cognitive Conflict")
graph export ind1.png, replace
margins, dydx(cog_level) at(restrat = (0 2))
marginsplot, noci title("Average Marginal Effect of High Cognitive Conflict") ytitle("Effects on Perceived Cognitive Conflict")
graph export ind2.png, replace

esttab a1 b1 a3 b3 using ind_cog.rtf, p compress one nogap label nomtitles replace
