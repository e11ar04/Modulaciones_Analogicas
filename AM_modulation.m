function []= AM_modulation(Ai,f_m,Selec,Selec_2,F_c,In,Kp,Kf,A_c)

clc
%Modulacion 
%Comunicaciones Electrica 1 - II 2018

 
fprintf('\n Modulaciones Analogicas\n');

%Fre = input('\nSe debe definir una frecuencia de muestreo: ');
Fre = 30000;
t = 0:1/Fre:2;


%Se pregunta al usuario por los parametros de la onda de informacion 
%fprintf('Procesando modulacion..\n ')
%Ai = input('\nIngrese la amplitud de la onda de informacion:'); 
%f_m = input('\nFrecuencia de la onda de informacion: ');
%fprintf('\nSeleccione entre las 4 funciones precargadas para determinar la onda de informacion:\n');
%fprintf('\n1-Senoidal \n2-Sawtooth \n3-Pulsos \n');
%Selec = input('\nSu eleccion es: ');


if Selec==1
    m = Ai.*cos(2*pi*f_m*t);            %Onda de informacion Senoidal
elseif Selec ==2
    m = Ai.*sawtooth(2*pi*f_m*t);
elseif Selec==3
    m = Ai.*square(2*pi*f_m*t);
end



%Se le pregunta al usuario por el tipo de modulacion que desea
%fprintf('\nTipos de modulacion \n 1-Modulacion AM DSB-LC \n 2-Modulacion AM DSB-SC\n 3-Modulacion Fase\n 4-Modulacion FM \n');
%Selec_2 = input('\nSeleccione la modulacion que desea aplicar: ');


%Funciones para modulacion ------USAR ESTAS PARA GENERAR DATOS A PAGINA WEB

%In = input('Defina el indice de modulacion: ');



if Selec_2 == 1
    %In = input('Defina el indice de modulacion: ');
    
    %Se le pregunta por los datos del la onda portadora
    %fprintf('\n Se debe definir los parametros de la onda portadora\n ')
    %F_c = input('Ingrese la frecuencia de la portadora: '); %Frecuencia de portadora
    A_c = Ai/In; %Se define la magnitud de la portadora en base a indice de modulacion y amplitud info
    Portadora = A_c*cos(2*pi*t*F_c); % Funcion de portadora
    
    %Calculo de onda modulada
    Modulada = AM_LC(Portadora,m,In); %Funcion de modulacion AM-Long Carrier - ver al final del script
    
    %Demodulacion y filtrado
    d = (A_c.*(1+In.*m).*cos(2.*pi.*F_c.*t)).*(A_c.*cos(2.*pi.*F_c.*t));
    butterw=conv(d,butter(25,F_c/(Fre/2)));
    rec=butterw(25:10000);
    ampl=rec*(((min(m)-max(m))/2)/((min(rec)-max(rec))/2));
    d2=min(ampl)+((max(ampl)-min(ampl))/2);
    d1=ampl-d2;
    
    %Analisis Espectral de la senal
    [power,n] = spectrum(Modulada);
    f = (0:n-1)*(Fre/n);
    
    %Generacion de txt
    Modu=horzcat(t',Modulada');
    p1=int2str(F_c); %frecuencia portadora
    p2=int2str(Selec); %selector de mensaje
    p3=int2str(Selec_2); %selector de modulacion
    p4=int2str(In); %Indice de modulacion
    p5=int2str(Ai); %Amplitud de mensaje
    p6=int2str(f_m); %Frecuencia de mensaje
    p7=int2str(Kp);
    p8=int2str(Kf);
    p9=int2str(A_c);
    filename_modu = strcat('modu_',p1,p2,p3,p4,p5,p6,p7,p8,p9,'.txt');
    
    Portu=horzcat(t',Portadora');
    filename_portu = strcat('portu_',p1,p2,p3,p4,p5,p6,p7,p8,p9,'.txt');
    
    Men=horzcat(t',m');
    filename_men = strcat('men_',p1,p2,p3,p4,p5,p6,p7,p8,p9,'.txt');
    
    tx = t(1:9976);
    Demod=horzcat(tx',d1'); 
    filename_demod = strcat('demod_',p1,p2,p3,p4,p5,p6,p7,p8,p9,'.txt');
    
    Espec=horzcat(f',power');
    filename_espec = strcat('espec_',p1,p2,p3,p4,p5,p6,p7,p8,p9,'.txt');
    
    dlmwrite(filename_modu,Modu,'newline','pc','delimiter',' ');
    dlmwrite(filename_portu,Portu,'newline','pc','delimiter',' ');
    dlmwrite(filename_men,Men,'newline','pc','delimiter',' ');
    dlmwrite(filename_demod,Demod,'newline','pc','delimiter',' ');
    dlmwrite(filename_espec,Espec,'newline','pc','delimiter',' ');

    
    
elseif Selec_2 == 2
    %In = input('Defina el indice de modulacion: ');
    
    %Se le pregunta por los datos del la onda portadora
    %fprintf('\n Se debe definir los parametros de la onda portadora\n ')
    %F_c = input('Ingrese la frecuencia de la portadora: '); %Frecuencia de portadora
    A_c = Ai/In; %Se define la magnitud de la portadora en base a indice de modulacion y amplitud info
    Portadora = A_c*cos(2*pi*t*F_c); % Funcion de portadora
    
    %Calculo de onda modulada
    Modulada =  AM_SC(Portadora,m,In);  %Funcion de modulacion AM-Supressed Carrier
    
    %Demod
    d = (A_c.*(In.*m).*cos(2.*pi.*F_c.*t)).*(A_c.*cos(2.*pi.*F_c.*t));
    d2 = conv(d,butter(20,F_c/(Fre/2)));
    rec = d2(25:10000);
    ampl=rec*(((min(m)-max(m))/2)/((min(rec)-max(rec))/2));
    d1=ampl;
    
elseif Selec_2 ==3
    %Kp= input('Defina sensibilidad del modulador de fase: ');
    
    %Se le pregunta por los datos del la onda portadora
    %fprintf('\n Se debe definir los parametros de la onda portadora\n ')
    %F_c = input('Ingrese la frecuencia de la portadora: '); %Frecuencia de portadora
    %A_c = input('Defina amplitud de la onda portadora: ');
    Portadora = A_c*cos(2*pi*t*F_c); % Funcion de portador
    
    Modulada = PM(m,Kp,F_c,A_c,t); %Funcion de modulacion de fase

    %Demod
    phasedev = Kp.*Ai;
    d1 = pmdemod(Modulada,F_c,Fre,phasedev);
    
elseif Selec_2 ==4
    %Kf= input('Defina sensibilidad del modulador de frecuencia: ');
    
    %Se le pregunta por los datos del la onda portadora
    %fprintf('\n Se debe definir los parametros de la onda portadora\n ')
    %F_c = input('Ingrese la frecuencia de la portadora: '); %Frecuencia de portadora
    %A_c = input('Defina amplitud de la onda portadora: ');
    Portadora = A_c*cos(2*pi*t*F_c); % Funcion de portador
    
    %Modulada = FM(m,Kf,F_c,A_c,t); %Funcion de modulacion de frecuencia
    
    freqdev=Kf.*Ai;
    Modulada = fmmod(m,F_c,Fre,freqdev);
    
    %Demod

%     d2 = conv(Modulada,butter(10,F_c/(Fre/2)));
%     rec = d2(25:10000);     
%     ampl=rec*(((min(m)-max(m))/2)/((min(rec)-max(rec))/2));
%     ampl=d2*(((min(m)-max(m))/2)/((min(d2)-max(d2))/2));
%     d=ampl;
%     d1 = fmdemod(d,F_c,Fre,freqdev);
    %d1 = fmdemod(Modulada,F_c,Fre,freqdev);
    
    %freqdev=Kf.*Ai;
    d = fmdemod(Modulada,F_c,Fre,freqdev);
%     d2 = conv(d,butter(3,F_c/(Fre/2)));
%     rec = d2(25:10000);
   
    rec = d(25:10000);
    ampl=rec*(((min(m)-max(m))/2)/((min(rec)-max(rec))/2));
    d1=ampl;
    
end

%Analisis Espectral de la senal

%GRAFICAS
%---------------------------------------------------------------------

% GrÃ¡fica de portadora
subplot(5,1,1); %grafica de portadora
plot(t(1:F_c),Portadora(1:F_c)),xlabel('tiempo(s)'),ylabel('Amplitud (V)'); %grafica de portadora 
grid on
title('Onda Portadora');


subplot(5,1,2);  %SeÃ±al de informacion
ymin=-Ai-0.2;
ymax=Ai+0.2;

if Selec==1
    plot(t(1:F_c),m(1:F_c)),xlabel('tiempo(s)'),ylabel('Amplitud (V)');
    ylim([ymin ymax]);
    grid on
    title ('Onda de Informacion');
elseif Selec==2
    plot(t(1:F_c),m(1:F_c)),xlabel('tiempo(s)'),ylabel('Amplitud (V)');
    ylim([ymin ymax]);
    grid on
    title ('Onda de Informacion');
elseif Selec==3
    plot(t(1:F_c),m(1:F_c)),xlabel('tiempo(s)'),ylabel('Amplitud (V)');
    ylim([ymin ymax]);
    grid on
    title ('Onda de Informacion');
end


% Grafica de senal modulada
subplot(5,1,3);  %SeÃ±al de informacion
plot(t(1:F_c),Modulada(1:F_c)),xlabel('tiempo(s)'),ylabel('Amplitud (V)');
grid on
title ('Onda Modulada');


% Grafica de analisis espectral
subplot(5,1,4);
%f = (0:n-1)*(Fre/n);
plot(f,power),xlabel('Frequency'),ylabel('Power');
grid on
title ('Analisis Espectral');


% GrÃ¡fica de onda demodulada
% subplot(5,1,5), plot(t(1:F_c)-0.002,d1(1:F_c)),xlabel('tiempo (s)'),ylabel('Demodulada');
%subplot(5,1,5), plot(t(1:F_c),d1(1:F_c)),xlabel('tiempo (s)'),ylabel('Demodulada');
subplot(5,1,5), plot(t(1:F_c),d1(1:F_c)),xlabel('tiempo (s)'),ylabel('Demodulada'); %FM

%xlim([0 0.03]);
grid on
title ('Onda Demodulada');




function x = AM_LC(Portadora,m,In)
    x =(1+In.*m).*Portadora;
end

function x = AM_SC(Portadora,m,In)
    x = In.*m.*Portadora;
end

function x = PM(m,Kp,F_c,A_c,t)
    x = A_c.*cos(2.*pi.*F_c.*t + Kp.*m);
end

function x = FM(m,Kf,F_c,A_c,t)
   x = A_c.*cos(2.*pi.*F_c.*t + 2.*pi.*Kf.*m); %Falta definir integral
end


function [x,n] = spectrum(Modulada)
    fourier = fft(Modulada);
    n=length(Modulada);
    x = abs(fourier).^2/n;
end
end
