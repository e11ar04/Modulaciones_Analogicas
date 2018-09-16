clear all
clc
%Modulacion 
%Comunicaciones Electrica 1 - II 2018

 
fprintf('\n Modulaciones Analogicas\n');

Fre = input('\nSe debe definir una frecuencia de muestreo:');
t = 0:1/Fre:2;


%Se le pregunta por los datos del la onda portadora
fprintf('\n Se debe definir los parametros de la onda portadora\n ')
F_c = input('Ingrese la frecuencia de la portadora:'); %Frecuencia de portadora
A_c = input('Ingrese la amplitud de la portadora:'); %Amplitud de portadora
Portadora = A_c*cos(2*pi*t*F_c); % Funcion de portadora


%Se pregunta al usuario por los parametros de la onda de informacion 
fprintf('\n Se debe definir los parametros de la onda de informacion\n ')
fprintf('\nSeleccione entre las 4 funciones precargadas para determinar la onda de informacion:\n');
fprintf('\n1-Senoidal \n2-Sawtooth \n3-Pulsos \n');

Selec = input('\nSu eleccion es:');

if Selec ==1
    f_m = input('Frecuencia:');
    m = cos(2*pi*f_m*t);
elseif Selec ==2
    f_m = input('Frecuencia del diente:');
    m = sawtooth(2*pi*f_m*t);
    integral = trapz(t,m);
elseif Selec==3
    f_m = input('Frecuencia del pulso:');
    m = square(2*pi*f_m*t);
    integral = trapz(t,m);
end



%Se le pregunta al usuario por el tipo de modulacion que desea
fprintf('\nTipos de modulacion \n 1-Modulacion AM DSB-LC \n 2-Modulacion AM DSB-SC\n 3-Modulacion Fase\n 4-Modulacion FM \n');
Selec_2 = input('\nSeleccione la modulacion que desea aplicar:\n');


%Funciones para modulacion ------USAR ESTAS PARA GENERAR DATOS A PAGINA WEB

In = input('Defina el indice de modulacion:');



if Selec_2 == 1
    Modulada = AM_LC(Portadora,m,In); %Funcion de modulacion AM-Long Carrier
elseif Selec_2 == 2
    Modulada =  AM_SC(Portadora,m,In);  %Funcion de modulacion AM-Supressed Carrier
elseif Selec_2 ==3
    Modulada = PM(m,In,F_c,A_c,t); %Funcion de modulacion de fase
elseif Selec_2 ==4
    Modulada = FM(m,In,F_c,A_c,t); %Funcion de modulacion de frecuencia
end

%Analisis Espectral de la senal
[power,n] = spectrum(Modulada);

%GRAFICAS
%---------------------------------------------------------------------
%grafica de portadora
subplot(4,1,1); %grafica de portadora

plot(t,Portadora),xlabel('tiempo(s)'),ylabel('Amplitud (V)'); %grafica de portadora 
grid on
title('Onda Portadora');


subplot(4,1,2);  %Señal de informacion

if Selec==1
    plot(t,m),xlabel('tiempo(s)'),ylabel('Amplitud (V)');
    grid on
    title ('Onda de Informacion');
elseif Selec==2
    plot(t,m),xlabel('tiempo(s)'),ylabel('Amplitud (V)');
    grid on
    title ('Onda de Informacion');
elseif Selec==3
    plot(t,m),xlabel('tiempo(s)'),ylabel('Amplitud (V)');
    grid on
    title ('Onda de Informacion');
end



% Grafica de senal modulada
subplot(4,1,3);  %Señal de informacion
plot(t,Modulada),xlabel('tiempo(s)'),ylabel('Amplitud (V)');
grid on
title ('Onda de Modulada');


%Grafica de analisis espectral

subplot(4,1,4);
f = (0:n-1)*(Fre/n);
plot(f,power),xlabel('Frequency'),ylabel('Power');
grid on
title ('Analisis Espectral');


function x = AM_LC(Portadora,m,In)
    x =(1+In.*m).*Portadora;
end

function x = AM_SC(Portadora,m,In)
    x = In.*m.*Portadora;
end

function x = PM(m,In,F_c,A_c,t)
    A_m = input('Defina amplitud del msj');
    x = A_c.*cos(2.*pi.*F_c.*t + (In/A_m).*m);
end

function x = FM(m,In,F_c,A_c,t)
   A_m = input('Defina amplitud del msj');
   x = A_c.*cos(2.*pi.*F_c.*t - (In/A_m).*m);
end


function [x,n] = spectrum(Modulada)
    fourier = fft(Modulada);
    n=length(Modulada);
    x = abs(fourier).^2/n;
end


