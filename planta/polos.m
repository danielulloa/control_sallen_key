syms R1 R2 C1 C2 Vin x V1 V2;
eq1=(1/R1+1/R2+x*C1)*V1+(-1/R2-x*C1)*V2-Vin/R1;
eq2=(-1/R2)*V1+(1/R2+x*C2)*V2;
C2=C1;
R2=2*R1;
eq1s=subs(eq1);
eq2s=subs(eq2);
solu=solve(eq1s,eq2s,V1,V2);
Hs=simplify(solu.V2/Vin);
pretty(Hs)

C1=1e-9;
f=1000;
R1=1/(2*pi*f*C1);
Hs2=subs(Hs)
s=tf('s')
Hs2=strrep(char(Hs2),'x','s')
Hs2=eval(Hs2)

%sys=tf([1],[pi*pi*200e-6 3/(20e+3*pi) 1])
%pzmap(Hs2)
k=1;

G=k;
C=1/(s+100);
sysCL=feedback(Hs2*G*C,1)
t=0:1e-6:10e-3;
u=ones(size(t,2),1);
[y,t,x]=lsim(sysCL,u,t);
plot(t,y,'y',t,u,'m')
xlabel('Time (ms)')
ylabel('Amplitude')
title('Input-purple, Output-yellow')
 figure(2)
 rlocus(sysCL)