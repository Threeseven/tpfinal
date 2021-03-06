%% Evaluador de performance

audio_entrada = 'quealguientraigamadera.wav';
audio_salida = 'salida.wav';

cantidad_pasos = 10 ;

mensaje_total = fileread('randomtext.txt');
largo_mensaje = length(mensaje_total);
largo_mensaje_atomo = floor(largo_mensaje/cantidad_pasos);

snrs = zeros(cantidad_pasos,3);
ODG_max = zeros(1,cantidad_pasos);
ODG_real = zeros(cantidad_pasos,3);
for i = 1:cantidad_pasos
      
      mensaje = mensaje_total(1:i*largo_mensaje_atomo);
      
      % Archivo contra si mismo para tener de referencia
      ODG_max(i, 1) = PQevalAudio( audio_entrada, audio_entrada );
      
      % Hacemos la codificacion
      [snr] = lsbBasicEncoder( audio_entrada,audio_salida,mensaje );  
      % Guardamos el SNR
      snrs(i, 1) = snr;
      % Valor de referencia perceptual
      ODG_real(i, 1) = PQevalAudio( audio_entrada, audio_salida );

      [snr] = lsbByteChooseEncoder( audio_entrada,audio_salida, mensaje );
      % Guardamos el SNR
      snrs(i, 2) = snr;

      % Valor de referencia perceptual
      ODG_real(i, 2) = PQevalAudio( audio_entrada, audio_salida );
      
      snr = lsbStepByteEncoder( audio_entrada,audio_salida, mensaje );
      % Guardamos el SNR
      snrs(i, 3) = snr;
      % Valor de referencia perceptual
      ODG_real(i, 3) = PQevalAudio( audio_entrada, audio_salida );
end

x = [1:largo_mensaje_atomo:largo_mensaje-largo_mensaje_atomo];

figure(1);
plot(x, snrs(:,1)', 'r+', x, snrs(:,2)', 'b--o', x, snrs(:,3)', 'c*');
title('Comparacion SNR  - Dominio Temporal');
xlabel('Tamaño de mensaje');
saveas(1, 'snr.png', 'png');

figure(2);
plot(x, ODG_max, 'g', x, ODG_real(:,1), 'r--+', x, ODG_real(:,2), 'b--o', x, ODG_real(:,3), 'c*');
title('Comparacion PEAQ - Dominio Temporal');
xlabel('Tamaño de mensaje');
saveas(2, 'peaq.png', 'png');