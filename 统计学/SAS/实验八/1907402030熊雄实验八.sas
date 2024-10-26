%let mean1 = 1; /*随机变量X的均值*/
%let mean2 = 2; /*随机变量Y的均值*/
%let var1 = 2; /*随机变量X的方差*/
%let var2 = 1; /*随机变量Y的方差*/
%let r = 0.5; /*相关系数*/
%let pi = 3.1415926;
Data norm;
	var1_1 = sqrt (&var1); /*随机变量X的标准差*/
	var2_1 = sqrt (&var2);  /*随机变量Y的标准差*/
	frac = var2_1 / var1_1; 
	delta = 2 * &var1 * &var2 * (1 - &r * &r);  /*对应前面分析的\delta代换*/
 	do x = -3 * var1_1 to 3 * var1_1 by 0.1;  /*循环*/
		do y = -3 * var2_1 to 3 * var2_1 by 0.1;
 			z = 1 / (&pi * delta) * exp (- 1 / delta * ( (x - &mean1)* (x - &mean1)* frac + (y - &mean2)*(y - &mean2) / frac - &r * (x - &mean1) * (y - &mean2)));
			output;
	end;
end;
keep x y z; 
run;
proc g3d data = norm;
  plot x * y = z / 
rotate = 90  /*Z轴的旋转角度为150°*/
tilt = 160 /*Y轴的旋转角度为60°*/
ctop = red 
caxis = black 
cbottom = blue 
grid 
xticknum = 10  /*X轴上刻度线的数目*/
yticknum = 10  /*Y轴上刻度线的数目*/
zticknum = 10;  /*Z轴上刻度线的数目*/
	title '3D Normal Distribution';  /*标题*/
run;
