%% Evaluador de performance

audio_entrada = 'sound1.WAV';
audio_salida = 'salida.wav';

cantidad_pasos = 10;

mensaje_total = fileread('randomtext.txt');
largo_mensaje = length(mensaje_total);
largo_mensaje_atomo = largo_mensaje/cantidad_pasos;

snrs = zeros(cantidad_pasos,1);
ODG_max = zeros(cantidad_pasos,1);
ODG_real = zeros(cantidad_pasos,1);

for i = 1:cantidad_pasos
      mensaje = mensaje_total(1:i*largo_mensaje_atomo);
      % Hacemos la codificacion
      [archivo_salida, snr] = dwtencoder( audio_entrada, mensaje );  
      % Guardamos el SNR
      snrs(i) = snr;
      % Archivo contra si mismo para tener de referencia
      ODG_max(i) = PQevalAudio( archivo_entrada, archivo_entrada );
      % Valor de referencia perceptual
      ODG_real(i) = PQevalAudio( archivo_entrada, archivo_salida );

end

x = [1:largo_mensaje_atomo:largo_mensaje];

figure(1);
stem(x, snr);
title("Comparacion SNR  - Dominio Frecuencial");
xtitle("Tamaño de mensaje");

figure(2);
stem(x, ODG_max, x, ODG_real);
title("Comparacion PEAQ - Dominio Frecuencial");
xlabel("Tamaño de mensaje");