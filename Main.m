clc
%Modulacion 
%Comunicaciones Electrica 1 - II 2018

Ai=1;
f_m=100;
Selec=1;
Selec_2=1;
In=1;
Kp=1;
Kf=1;
A_c=1;

for F_c=100:1:1000
    AM_modulation(Ai,f_m,Selec,Selec_2,F_c,In,Kp,Kf,A_c);
end