clear

cd "/Users/xiong/Library/Mobile Documents/com~apple~CloudDocs/研一课程/金融工程原理/project"

import excel data_clear.xls, firstrow clear

save data_clear.dta, replace

use data_clear.dta

keep if i <= 80 

replace i = 81 - i

replace Change = -.0085 in 71

tsset i

arch Change, arch(1) garch(1)

predict h, variance 

graph twoway line  h i, xlabel(0(10)80)  xtitle("Day") ytitle("Volatility") lc(red)
