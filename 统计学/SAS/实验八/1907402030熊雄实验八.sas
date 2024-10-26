%let mean1 = 1; /*�������X�ľ�ֵ*/
%let mean2 = 2; /*�������Y�ľ�ֵ*/
%let var1 = 2; /*�������X�ķ���*/
%let var2 = 1; /*�������Y�ķ���*/
%let r = 0.5; /*���ϵ��*/
%let pi = 3.1415926;
Data norm;
	var1_1 = sqrt (&var1); /*�������X�ı�׼��*/
	var2_1 = sqrt (&var2);  /*�������Y�ı�׼��*/
	frac = var2_1 / var1_1; 
	delta = 2 * &var1 * &var2 * (1 - &r * &r);  /*��Ӧǰ�������\delta����*/
 	do x = -3 * var1_1 to 3 * var1_1 by 0.1;  /*ѭ��*/
		do y = -3 * var2_1 to 3 * var2_1 by 0.1;
 			z = 1 / (&pi * delta) * exp (- 1 / delta * ( (x - &mean1)* (x - &mean1)* frac + (y - &mean2)*(y - &mean2) / frac - &r * (x - &mean1) * (y - &mean2)));
			output;
	end;
end;
keep x y z; 
run;
proc g3d data = norm;
  plot x * y = z / 
rotate = 90  /*Z�����ת�Ƕ�Ϊ150��*/
tilt = 160 /*Y�����ת�Ƕ�Ϊ60��*/
ctop = red 
caxis = black 
cbottom = blue 
grid 
xticknum = 10  /*X���Ͽ̶��ߵ���Ŀ*/
yticknum = 10  /*Y���Ͽ̶��ߵ���Ŀ*/
zticknum = 10;  /*Z���Ͽ̶��ߵ���Ŀ*/
	title '3D Normal Distribution';  /*����*/
run;
