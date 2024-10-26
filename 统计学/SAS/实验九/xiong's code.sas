/*Xiong's homework code*/
PROC MEANS  data = sashelp.class mean std range qrange var skew kurt;
var weight;
label mean = '��ֵ' 
	std = '��׼��' 
	range = '����' 
	qrange = '�ķ�λ������' 
	var = '����' 
	skew = 'ƫ��' 
	kurt = '���';
output out = work.resultmeans 
	mean = mean 
	std = std 
	range = range 
	qrange = qrange 
	var = var 
	skew = skew 
	kurt = kurt; /*�����������������ݼ�resultmeans*/
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
	value $setsex 'M' = '��' 'F' = 'Ů';
RUN;
DATA sss;
	set sashelp.class;
	format sex setsex.;
run;
DATA sss;
set sss;
label name = '����'
	sex = '�Ա�'
	age = '����'
	height = '���'
	weight = '����';
run;

PROC FORMAT;
VALUE setweight LOW - 85 = '��'
	85 - 100 = '��'
	100 - HIGH = '��';
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


