**20234213001 熊雄 作业
** Stata基本操作
clear 
set more off 

cd "/Users/xiong/Library/Mobile Documents/com~apple~CloudDocs/研一课程/计量经济学/homework"

import excel nerlove.xls, firstrow clear
save nerlove.dta, replace

use nerlove.dta

label variable tc "total cost"
label variable q "total output"
label variable pl "price of labor"
label variable pf "price of fuel"
label variable pk "user cost of capital"

describe //显示所有变量
list tc q  
sort tc  //从小到大排序指令
list tc in 1/5 //从小到大显示前5个tc
list tc q in 1/5 //从小到大显示前5个tc和对应的q
gsort -tc 
list tc q if q >= 10000 //显示tc变量和大于等于10000的q变量
*drop if q > 12000 //删除某些数据
*keep if q > 12000 //保留某些数据

*描述性统计
sum q, detail
tabulate pl  //显示pl的累计分布函数
correlate tc q pl pf pk

//画常见图
histogram q,width(1000) frequency //直方图
scatter tc q //两个变量之间的散点图
gen n=_n //_n指第几个观测值
scatter tc q, mlabel(n) mlabpos(6) 

twoway (scatter tc q)(lfit tc q) //画两个图
graph save scatter1,replace //保存

twoway (scatter tc q)(qfit tc q) //二次拟合图qfit
graph save scatter2,replace

graph combine scatter1.gph scatter2.gph //拼接
graph save combinegph,replace

//display expression //展示计算
di log(2) //计算器, di指display缩写，
di normal(1.96) //Phi(1.96)（逆函数invnormal）
di ttail(120, 1.96) //自由度为120的t分布，大于1.96的概率
di Ftail(3, 12, 10) //自由度为3和12的F分布，大于10的概率
di chi2(7, 15) //自由度为7的卡方分布中，小于15的概率
di chi2tail(7, 15)  //自由度为7的卡方分布中，大于15的概率
di invchi2tail(7, 0.05) //自由度为7的卡方分布，求概率为95%分位所对应的值：

dis "upper tail probability t(3)>1.33 = " t_tail
dis "lower tail probability t(3)<1.33 = " 1- ttail(3,1.33)

//画正态分布和t分布图
//normalden:正态密度函数, range(-5 5):自变量取值-5到5，注意没有逗号
//tden:t分布
//lpattern(dash)虚线 默认实现。||指"并且"
//"///"代码换行符
twoway function y = normalden(x),range(-5 5) ///
|| function y = tden(3,x),range(-5 5) lpattern(dash) ///
||,title("standard normal and t(3)") ///
legend(label(1 "N(0,1)") label(2 "t(3)"))

twoway function y=tden(38,x),range(1.686 5) ///
color(ltbule) recast(area) /// 
||function y =tden(38,x),range(-5 5) ///
legend(off) plotregion(margin(zero)) ///
||,ytitle("f(t)") xtitle("t") ///
text(0 1.686 "1.686",place(s)) ///
title("Right-tail rejection region")

**  案例的回归分析：简单线性模型与检验
*观察相关系数矩阵，判断解释变量之间是否有完全多重共线性
correlate tc q pl pf pk //结果：解释变量间没有完全多重共线性

*判断有误平方项和交互项遗漏
regress tc q pl pk pf
predict tchat //生成回归的拟合值
gen tchat2 = tchat^2 //生成拟合值的平方项
regress tc q pl pk pf tchat2 //结果显示tchat2在99%水平下显著不为零

*检查遗漏变量
gen q2 = q ^ 2
gen pl2 = pl ^ 2
gen pf2 = pf ^ 2
gen pk2 = pk ^ 2 
gen qpl = q * pl
gen qpf = q * pf
gen qpk = q * pk
gen plpf = pl * pf
gen plpk = pl * pk
gen pfpk = pf * pk 
regress tc q pl pf pk q2 pl2 pf2 pk2 qpl qpf qpk plpf plpk pfpk
test pl2 pf2 pk2 plpf plpk pfpk //联合F检验不能拒绝原假设，这些变量可以从模型中去除
regress tc q pl pf pk q2 qpl qpf qpk //结果好很多

*检验异方差
estat hettest //B-P检验，p = 0 < 0.05，有异方差
estat imtest, white //white检验，p = 0 < 0.05，存在异方差

*处理异方差
regress tc q pl pf pk q2 qpl qpf qpk,robust //使用稳健标准误
predict e1, resid //加权最小二乘回归WLS
gen e12 = e1 ^ 2
gen lne12 = log(e12)
reg lne12 q pl pf pk q2 qpl qpf qpk
predict g1
gen h1 = exp(g1)
reg tc q pl pf pk q2 qpl qpf qpk [aw = 1 / h1]

*保存文件
save nerlove.dta, replace
