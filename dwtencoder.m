function [snr] = dwtencoder( archivo_entrada, archivo_salida, msg, bits)

  %---------------------------------------%
  % Definición de variables %
  %---------------------------------------%
  bits_fijos=8; % no toco los nbits_fijos mas representativos
  [y, fs, nbits]=wavread(archivo_entrada,'native'); % native me devuelve los samples en int16
  %---------------------------------------%
  %si la señal tiene dos canales me quedo con uno y la acorto
  if size(y,2)>1
      y=y(:,1);
  end
  y=y(1:30000);
  haarint=liftwave('haar','int2int');
  [ca,cd]=lwt(double(y),haarint);
  minimo=abs(min(ca));
  c_a=ca+minimo; % Coeficientes > 0

  %thr=floor(log2((c_a)));

  % cálculo de umbrales por coeficiente
  th=zeros(1,length(c_a));
  if (bits==0)
    for i=1:length(c_a)
          if ((c_a(i))>=2^(nbits-1))
              th(i)=nbits-1-bits_fijos; %7
                elseif ((c_a(i))<2^(nbits-1) && (c_a(i))>=2^(nbits-3))
                th(i)=nbits-3-bits_fijos; %5
                elseif ((c_a(i))<2^(nbits-3) && (c_a(i))>=2^(nbits-5))
                      th(i)=nbits-5-bits_fijos;%3
                      elseif ((c_a(i))<2^(nbits-5) && (c_a(i))>=2^(nbits-7))
                       th(i)=nbits-7-bits_fijos;%1        
          end
    end
  else
    th=bits*ones(1,length(th));
  end
  %acorto el mensaje si es mas largo que el audio
  tm_th=floor(sum(th)/8);
  if(tm_th<length(msg))
      msg=msg(1:tm_th-2);
  end
  %acorto el mensaje si es mas largo que 2^16
  tm_msg=length(msg);
  aux=floor((2^16-1)/8);
  if (tm_msg>aux)
      msg=msg(1:aux-2);
  end
  ca_bin=dec2bin(c_a,nbits);

  msg_bin=dec2bin(single(msg),8); % 8 bits para ASCII con acentos, ñ...
  msg_bin_l=zeros(1,numel(msg_bin)); % prealloc de msg_bin_l
  %tranformar mensaje en vector fila
  for i=1:size(msg_bin,1)
      pos=((i-1)*8)+1;
      msg_bin_l(pos:pos+7)=msg_bin(i,:);
  end

   k=1;
   i=1;
   j=0;
   bits_tm=16;
   tm=length(msg_bin_l)+bits_tm;
 
   %calculo en que coeficiente irá el último bit del mensaje
   while (j<tm)
       j=j+th(i);
       i=i+1;
   end
   
   tm_bin=dec2bin(tm,bits_tm);
   %msg_bin_l=[tm_bin(1:8) tm_bin(9:16) msg_bin_l];
   msg_bin_l=[tm_bin msg_bin_l];
  for j=1:i-1
      pos=nbits-th(j)+1;
      if ((k+th(j)-1)>length(msg_bin_l))
          ca_bin(j,pos:pos+length(msg_bin_l)-k)=msg_bin_l(k:length(msg_bin_l));
      else
          ca_bin(j,pos:nbits)=msg_bin_l(k:k+th(j)-1);
      end
    k=k+th(j);
  end

  ca_dec=bin2dec(ca_bin);
  ca_dec=ca_dec-minimo;
  y_steg = ilwt(ca_dec,cd,haarint);
  y_steg=int16(y_steg);
 
  wavwrite(y_steg,fs,nbits,archivo_salida);
  [y2, fs, nbits]=wavread(archivo_entrada);
  [y3, fs, nbits]=wavread(archivo_salida);
 sound(y3(1:30000),fs)
  plot(y2(1:30000,1)-y3(1:30000))
  % medida de señal/ruido
  largo=[length(y2) length(y3)];
  snr= 10*log10((sum(y2(1:min(largo),1).^2))/(sum(y2(1:min(largo),1)-y3(1:min(largo))).^2));
end