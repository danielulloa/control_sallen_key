clear all
% Funcion de transferencia de SKpj
syms R1 R2 C1 C2 Vin x V1 V2;
eq1=(1/R1+1/R2+x*C1)*V1+(-1/R2-x*C1)*V2-Vin/R1;
eq2=(-1/R2)*V1+(1/R2+x*C2)*V2;
C2=C1;
R2=0.5*R1;
eq1s=subs(eq1);
eq2s=subs(eq2);
solu=solve(eq1s,eq2s,V1,V2);
Hs=simplify(solu.V2/Vin);
pretty(Hs);

% Reemplazando valores
C1=1e-9;
f=1000;
R1=1/(2*pi*f*C1);
planta=subs(Hs);
s=tf('s');
planta=strrep(char(planta),'x','s');

% Planta
planta=eval(planta);
subplot(2,2,1)
rlocus(planta)
t=0:1e-6:2e-3;
u=ones(size(t,2),1);
sysCLu=feedback(planta,1)
[y,t,x]=lsim(sysCLu,u,t);
subplot(2,2,2)
plot(t,y,'g',t,u,'r')
clear C1 C2 eq1 eq1s eq2 eq2s f R1 R2 solu V1 V2 Vin x

% Error estacionario nulo

integrador=tf(10000/s);

% Compensador en adelanto minima ganancia

[z,p,k]=zpkdata(planta);
clear z k;
p=p{1,1};
pc=[p(2)+p(2)*tan(67.5*pi/180)];
zc=[p(2)-p(2)*tan(22.5*pi/180)];
[num,den]=zp2tf(zc,pc,1);
comp=tf(num,den);
pd=p(2)+1*i*p(2)
%syms k
%eq3=1-k*(pc/zc)*abs((p(1)*p(2)*10000*(1+(pd/zc))/((pd-p(1))*(pd-p(2))*pd*(1+pd/pc))
clear num den;
subplot(2,2,3)
rlocus(planta*integrador*comp)

%[K,r]= rlocfind(num, den)

sysCL=feedback(planta*integrador*comp*1.5169,1)
[y,t,x]=lsim(sysCL,u,t);
subplot(2,2,4)
plot(t,y,'g',t,u,'r')
%sys=tf([1],[pi*pi*200e-6 3/(20e+3*pi) 1])
%pzmap(Hs2)
%k=1;
%controlSystemDesigner(planta*integrador*comp)
%G=k/(s+31.4);
%sysCL=feedback(Hs2*G*C*1,1)
%t=0:1e-6:1e-3;
%u=ones(size(t,2),1);
%[y,t,x]=lsim(sysCL,u,t);
%plot(t,y,'y',t,u,'m')
%xlabel('Time (ms)')
%ylabel('Amplitude')
%title('Input-purple, Output-yellow')
% figure(2)
% rlocus(sysCL)
%  tf(G)
%  ans =
%  
%                        5.903e38
%   --------------------------------------------------
%   2.99e31 s^3 + 2.828e35 s^2 + 5.991e38 s + 1.854e40
%  
% Name: G
% Continuous-time transfer function.

% tf(C)
% 
% ans =
%  
%   16.66 s^2 + 1.183e05 s + 3.074e08
%   ---------------------------------
%             s + 2.058e04
%  
% Name: C
% Continuous-time transfer function.