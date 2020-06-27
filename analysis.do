using data.dta, clear

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
