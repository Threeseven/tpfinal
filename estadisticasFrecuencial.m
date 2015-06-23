%% Evaluador de performance

audio_entrada = 'audiowp.wav';
audio_salida = 'salida.wav';

cantidad_pasos = 10;

mensaje_total = fileread('randomtext.txt');
largo_mensaje = length(mensaje_total);
largo_mensaje_atomo = floor(largo_mensaje/cantidad_pasos);

snrs = zeros(cantidad_pasos,1);
ODG_max = zeros(cantidad_pasos,1);
ODG_real = zeros(cantidad_pasos,1);
bits=0;

for i = 1:cantidad_pasos
      mensaje = mensaje_total(1:i*largo_mensaje_atomo);
      % Hacemos la codificacion
      [snr] = dwtencoder( audio_entrada,audio_salida, mensaje,bits );  
      % Guardamos el SNR
      snrs(i) = snr;
      % Archivo contra si mismo para tener de referencia
      ODG_max(i) = PQevalAudio( audio_entrada, audio_entrada );
      % Valor de referencia perceptual
      ODG_real(i) = PQevalAudio( audio_entrada, audio_salida );

end

x = [1:largo_mensaje_atomo:largo_mensaje-largo_mensaje_atomo];

figure(1);
plot(x, snrs, 'b--o');
title('Comparacion SNR  - Dominio Frecuencial - cdf1.3');
xlabel('Tamaño de mensaje');

figure(2);
plot(x, ODG_max', 'r', x, ODG_real', 'b--o');
title('Comparacion PEAQ - Dominio Frecuencial - cdf1.3');
xlabel('Tamaño de mensaje');
%% Evaluador de performance

audio_entrada = 'sound1.WAV';
audio_salida = 'salida.wav';

cantidad_pasos = 10;

mensaje_total = fileread('randomtext.txt');
largo_mensaje = length(mensaje_total);
largo_mensaje_atomo = floor(largo_mensaje/cantidad_pasos);

snrs = zeros(cantidad_pasos,1);
ODG_max = zeros(cantidad_pasos,1);
ODG_real = zeros(cantidad_pasos,1);

for i = 1:cantidad_pasos
      %mensaje = mensaje_total(1:i*largo_mensaje_atomo);
      % Hacemos la codificacion
      [snr] = dwtencoder( audio_entrada,audio_salida, mensaje,i );  
      % Guardamos el SNR
      snrs(i) = snr;
      % Archivo contra si mismo para tener de referencia
      ODG_max(i) = PQevalAudio( audio_entrada, audio_entrada );
      % Valor de referencia perceptual
      ODG_real(i) = PQevalAudio( audio_entrada, audio_salida );

end

x = [1:largo_mensaje_atomo:largo_mensaje-largo_mensaje_atomo];

figure(1);
plot(1:i, snrs, 'b--o');
title('Comparacion SNR  - Dominio Frecuencial');
xlabel('Cantidad de bits por coeficiente');

figure(2);
plot(1:i, ODG_max', 'r', 1:i, ODG_real', 'b--o');
title('Comparacion PEAQ - Dominio Frecuencial');
xlabel('Cantidad de bits por coeficiente');
%%
close all

clear all
audio_entrada = 'jazz_trombon.wav';
audio_salida = 'salida.wav';
i=0;

mensaje = fileread('randomtext.txt');
[snr] = dwtencoder( audio_entrada,audio_salida, mensaje,i )

[msg] = dwtdecoder( audio_salida)

