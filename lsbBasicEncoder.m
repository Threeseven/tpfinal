function [archivo_salida, snr] = dwtencoder( archivo_entrada, msg )
  % LSB original para ocultar texto
  [y, fs, nbits]=wavread(archivo_entrada);
  if size(y,2)==2;
      y=y(1:22560,1);
  end
  minimo=abs(min(y));
  y_a=y+minimo;
  y_a=y_a.*(2^(nbits-1));
  % nbits=8;
  y_bin=dec2bin(y_a,nbits);


  nbits_m=8; % Cantidad de bits para codificar el mensaje
  % Mensaje a codificar
  ms_d=single(msg);
  ms_bin=dec2bin(ms_d,nbits_m);
  % Codificación
  k=1;
  for i=1:size(ms_bin,1)
    for j=1:size(ms_bin,2)
        y_bin(k,nbits)=ms_bin(i,j);
        k=k+1;
    end
  end
  y_dec=bin2dec(y_bin);
  y_dec=(y_dec./2^(nbits-1))-minimo;
  snr= 10*log10((sum(y.^2))/(sum(y-y_dec).^2));
  wavwrite(y_dec, fs, nbits, archivo_salida);
end