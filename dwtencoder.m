%---------------------------------------%
%% Definición de variables %%
%---------------------------------------%
close all;
clear all;
msg='Mensaje de prueba';
bits_fijos=8; % no toco los nbits_fijos mas representativos
[y, fs, nbits]=wavread('sound2.WAV','native'); % native me devuelve los samples en int16
%---------------------------------------%
subplot(2,1,1)
%si la señal tiene dos canales me quedo con uno y la acorto
if size(y,2)>1
    y=y(1:22560,1);
end
plot(y)
%sound(double(y),fs)

haarint=liftwave('haar','int2int');
[ca,cd]=lwt(double(y),haarint);
minimo=abs(min(ca));
c_a=ca+minimo; % Coeficientes > 0
%c_a=c_a.*(2^(nbits-1)); % Necesitamos que sean enteros... ?????
%thr=floor(log2((c_a)));

% cálculo de umbrales por coeficiente
th=zeros(1,length(c_a));
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

ca_bin2=dec2bin(c_a,nbits);
ca_bin=ca_bin2;

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
for j=1:i-2
  ca_bin(j,nbits-th(j)+1:nbits)=msg_bin_l(k:k+th(j)-1);
  k=k+th(j);
end

ca_dec=bin2dec(ca_bin);
ca_dec=ca_dec-minimo;
y_steg = ilwt(ca_dec,cd,haarint);
y_steg=int16(y_steg);


subplot(2,1,2)
plot(y_steg)
%sound(y_steg,fs)
wavwrite(y_steg,fs,nbits,'salida.wav')
