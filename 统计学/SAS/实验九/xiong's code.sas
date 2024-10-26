/*Xiong's homework code*/
PROC MEANS  data = sashelp.class mean std range qrange var skew kurt;
var weight;
label mean = '均值' 
	std = '标准差' 
	range = '极差' 
	qrange = '四分位数极差' 
	var = '方差' 
	skew = '偏度' 
	kurt = '峰度';
output out = work.resultmeans 
	mean = mean 
	std = std 
	range = range 
	qrange = qrange 
	var = var 
	skew = skew 
	kurt = kurt; /*将输出结果保存在数据集resultmeans*/
RUN;
ods select plots;
PROC UNIVARIATE data = sashelp.class plot; 
var height;
run;

PROC FREQ data = sashelp.class;
	table sex;
	table sex * age /chisq;
RUN;

PROC FORMAT;
	value $setsex 'M' = '男' 'F' = '女';
RUN;
DATA sss;
	set sashelp.class;
	format sex setsex.;
run;
DATA sss;
set sss;
label name = '姓名'
	sex = '性别'
	age = '年龄'
	height = '身高'
	weight = '体重';
run;

PROC FORMAT;
VALUE setweight LOW - 85 = '轻'
	85 - 100 = '中'
	100 - HIGH = '重';
RUN;
PROC FREQ data = work.sss;
	table weight;
	format weight setweight.;
	table sex * weight / chisq;
run;

proc gplot data = sashelp.class;
	plot weight * height;
	symbol V = TRIANGLE, CV = RED, H = 2;
run;

PROC MEANS data = sss mean ; 
	class age sex; 
	var height;
RUN;


