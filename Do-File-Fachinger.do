*BIP*
*Datensatz importieren
import datensatz_fachinger.dta firstrow clear
*Variablen, die nicht zur Analyse benötigt werden, werden gelöscht* 
drop MDI_basic MDI_achi_plus GINI coeff_ineq ineq_inc ihdi hdi inc_equity c02_prod mf phdi eys le mys gnipc 
drop if countryno == .
* Fehlende Werte werden durch lineare Interpolation (in 14 Fällen wird extrapoliert) ausgeglichen 
bysort countryno: ipolate gdppc year, generate (gdppc1)
drop gdppc 
rename gdppc1 gdppc 
bysort countryno: ipolate gds year, generate (gds1) 
drop gds 
rename gds1 gds 
bysort countryno: ipolate lpg year, generate (lpg1)
drop lpg 
rename lpg1 lpg
bysort countryno: ipolate emp year, generate (emp1) epolate 
drop emp 
rename emp1 emp  
bysort countryno: ipolate exp year, generate (exp1) epolate
drop exp 
rename exp1 exp  
bysort countryno: ipolate imp year, generate (imp1) epolate 
drop imp 
rename imp1 imp
bysort countryno: ipolate cons year, generate (cons1) epolate 
drop cons 
rename cons1 cons
bysort countryno: ipolate inv year, generate (inv1) epolate
drop inv 
rename inv1 inv
bysort countryno: ipolate indshare year, generate (indshare1) epolate
drop indshare 
rename indshare1 indshare
bysort countryno: ipolate trdop year, generate (trdop1) 
drop trdop 
rename trdop1 trdop
bysort countryno: ipolate infl year, generate (infl1)
drop infl 
rename infl1 infl
bysort countryno: ipolate popg year, generate (popg1)
drop popg 
rename popg1 popg
* Der Startzeitpunk wird für das Jahr 2001 festgelegt*
drop if year<=2000
* Länder für die nun nicht alle Variablen zur Verfügung stellen, werden exkludiert* 
drop if countryno == 55
drop if countryno == 15
drop if countryno == 29
drop if countryno == 27
drop if countryno == 31
drop if countryno == 7
drop if countryno == 20
drop if countryno == 52 
* zudem werden die Nordafrikanischen Länder, die im Datensatz enthalten waren, gelöscht, da sie per Definition nicht zum donorpool gehören 
drop if countryno == 1
drop if countryno == 16
drop if countryno == 36
drop if countryno == 50
*Der Datensatz wird nun als Paneldatensatze definiert und ist nun vollständig balanced*
tsset countryno year
* Der Befehl allsynth wird ausgeführt um die durchschnittlichen Treatmenteffekte auszurechnen. Dabei wird die bias-correction spezifiziert (Elasticnet regression) und Placebos erstellt, sowie die Outcomevariable demeaned. Am Ende wird alles abgetragen*
allsynth gdppc emp lpg indshare inv popg con exp imp,transform(gdppc, demean) bcorrect(merge) pvalues keep(gdpdata, replace) stacked(trunits(treated) trperiods(tr_year),clear figure(bcorrect placebos lineback, save(allsynth, replace) ytitle(gdp - treatment effect) xtitle(event years) scheme(tufte)))

* HDI *
*Datensatz importieren
import excel datensatz_fachinger.dta firstrow clear
*Variablen, die nicht zur Analyse benötigt werden, werden gelöscht*
drop MDI_basic MDI_achi_plus GINI coeff_ineq ineq_inc c02_prod mf ihdi phdi inc_equity trdop indshare cons imp exp lpg gds popg infl emp inv 
* Fehlende Werte werden durch lineare Interpolation (in 8 Fällen wird extrapoliert) ausgeglichen 
bysort countryno: ipolate hdi year, generate (hdi1) epolate
drop hdi 
rename hdi1 hdi
bysort countryno: ipolate eys year, generate (eys1)
drop eys 
rename eys1 eys
bysort countryno: ipolate le year, generate (le1)
drop le 
rename le1 le
bysort countryno: ipolate mys year, generate (mys1) epolate
drop mys 
rename mys1 mys
bysort countryno: ipolate gnipc year, generate (gnipc1)
drop gnipc 
rename gnipc1 gnipc
* Der Startzeitpunk wird für das Jahr 2000 festgelegt*
drop if year<=1999
* Länder für die nun nicht alle Variablen zur Verfügung stellen, werden exkludiert* 
drop if countryno == .
drop if countryno == 44
drop if countryno == 46
drop if countryno == 24
drop if countryno == 47 
* zudem werden die Nordafrikanischen Länder, die im Datensatz enthalten waren, gelöscht, da sie per Definition nicht zum donorpool gehören 
drop if countryno == 1
drop if countryno == 16
drop if countryno == 36
drop if countryno == 50
*Der Datensatz wird nun als Paneldatensatze definiert und ist nun vollständig balanced
xtset countryno year
* Der Befehl allsynth wird ausgeführt um die durchschnittlichen Treatmenteffekte auszurechnen. Dabei wird die bias-correction spezifiziert (Elasticnet regression) und Placebos erstellt, sowie die Outcomevariable demeaned. Am Ende wird alles abgetragen*
allsynth hdi1 eys mys1 le gnipc,transform(hdi1, demean) bcorrect(merge elastic) pvalues keep(gdpdata, replace) stacked(trunits(treated) trperiods(tr_year),clear figure(bcorrect placebos, save(allsynth, replace) ytitle(HDI - Treatment effect) xtitle(event years) scheme(tufte)))


