

name1='Goldstein-Price';
function [Y]=f1(X)

    x=X(1,:);
    y=X(2,:);
    
    Y = 1+((x+y+1)^2).*(19-14*x+3*x^2-14*y+6*x.*y+3*y^2);
    Y = Y.*( 30+((2*x-3*y)^2).*(18-32*x+12*x^2+48*y-36*x.*y+27*y^2) );
  
endfunction
B1=[-2 2 ; -2 2];
sol1=[0 -1];
res1=3;

name2 ='Ackley';
function [y]=f2(x)
    a=-0.2*sqrt(0.5*(x(1)^2+x(2)^2));
    b=0.5*(cos(2*%pi*x(1))+cos(2*%pi*x(2)));
    y=-20*exp(a)-exp(b)+%e+20;
endfunction
B2=[-5 5; -5 5];
sol2=[0,0];
res2=0;

name3 ='Eggholder';
function [y]=f3(x)
    a=sqrt(norm((x(1)/2)+(x(2)+47)));
    b=sqrt(norm(x(1)-(x(2)+47)));
    y=-(x(2)+47)*sin(a)-x(1)*sin(b);
endfunction
B3=[-512 512;-512 512];
sol3=[512 404.2319];
res3=-959.6407';


name4 ='Himmelblau';
function [y]=f4(x)
    a=x(1)^2+x(2)-11;
    b=x(1)+x(2)^2-7;
    y=a^2+b^2; 
endfunction
B4=[-5 5;-5 5];
sol4=[3.0 2.0; -2.805118 3.131312; -3.779310,-3.283186; 3.584428,-1.848126];
res4=0;

name5 ='Bukin n°6';
function [y]=f5(x)
   a=sqrt(norm(x(2)-0.01*x(1)^2));
   b=0.01*norm(x(1)+10);
   y=100*a+b;
endfunction
B5=[-15 -5;-3 3];  
sol5=[-10,1];
res5=0;


name6 ='Schaffer n°4';
function [y]=f6(x)
    a=norm(x(1)^2-x(2)^2);
    b=(cos(sin(a)))^2-0.5;
    c=1+ 0.001*(x(1)^2+x(2)^2);
    y=0.5+(b/(c^2));
endfunction
B6=[-100 100;-100 100];
sol6=[0 1.25313 ; 0 -1.25313];
res6=0.292579;


name7 ='Cross-in-tray';
function [y]=f7(x)
    y=-0.0001*(norm(sin(x(1))*sin(x(2))*exp(norm(100-((sqrt(x(1)^2+x(2)^2))/(%pi)))))+1)^(0.1);
endfunction
B7=[-10 10; -10 10];
sol7=[1.34941 -1.34941 ; 1.34941,1.34941 ; -1.34941,1.34941 ; -1.34941,-1.34941];
res7=-2.06261;


name8 ='Schaffer n°2';
function [y]=f8(x)
    a=(sin(x(1)^2-x(2)^2))^2-0.5;
    b=1+0.001*(x(1)^2+x(2)^2);
    y=0.5+(a/(b^2));
endfunction
B8=[-100 100;-100 100];
sol8=[0,0];
res8=0;

name9 ='Easom';
function [y]=f9(x)
    y=-((cos(x(1,:))).*(cos(x(2,:))).*(exp(-((x(1,:)-(%pi))^2+(x(2,:)-(%pi))^2))));
endfunction
B9=[-100 100; -100 100];
sol9=[%pi %pi];
res9=-1;


name10='Matyas';
function [y]=f10(x)
    y=0.26*(x(1)^2+x(2)^2)-0.48*x(1)*x(2);
endfunction
B10=[-10 10 ; -10 10];
sol10=[0,0];
res10=0;


name11='Booth';
function [y]=f11(x)
    a=x(1)+2*x(2)-7;
    b=2*x(1)+x(2)-5;
    y=a^2+b^2;
endfunction
B11=[-10 10;-10 10];
sol11=[1,3];
res11=0;


name12='Beale';
function [y]=f12(x)
    a=1.5-x(1,:)+x(1,:).*x(2,:);
    b=2.25-x(1,:)+x(1,:).*x(2,:)^2;
    c=2.625-x(1,:)+x(1,:).*x(2,:)^3;
    y=a^2+b^2+c^2;
endfunction
B12=[-4.5 4.5; -4.5 4.5];
sol12=[3,0.5];
res12=0;

name13='Lévi n°13';
function [y]=f13(x)
    a=(sin(3*%pi*x(1)))^2;
    b=(sin(3*%pi*x(2)))^2;
    c=(sin(2*%pi*x(2)))^2;
    y=a+((x(1)-1)^2)*(1+b)+((x(2)-1)^2)*(1+c);
endfunction
B13=[-10 10 ; -10 10];
sol13=[1,1];
res13=0;

name14='McCormick';
function [y]=f14(x)
    y=sin(x(1)+x(2))+(x(1)-x(2))^2-1.5*x(1)+2.5*x(2)+1;
endfunction
B14=[-1.5 4 ; -3 4];
sol14=[-0.54719,-1.54719];
res14=-1.9133;


name15='Hölder table';
function [y]=f15(x)
    a=norm(1-((sqrt(x(1)^2+x(2)^2))/%pi));
    y=-norm(sin(x(1))*cos(x(2))*exp(a));
endfunction
B15=[-10 10 ; -10 10];
sol15=[8.05502,9.66459 ; -8.05502 9.66459 ; 8.05502 -9.66459 ; -8.05502 -9.66459];
res15=-19.2085;

