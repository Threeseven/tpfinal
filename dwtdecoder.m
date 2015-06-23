function [msg] = dwtdecoder( archivo_salida)
%---------------------------------------%
% Definición de variables %
%---------------------------------------%

bits_fijos=8; % no toco los nbits_fijos mas representativos
[y, fs, nbits]=wavread(archivo_salida,'native'); % native me devuelve los samples en int16
%msg='Error!';
%---------------------------------------%
% Me quedo con un canal
if size(y,2)==2
    y=y(:,1);
end
haarint=liftwave('haar','int2int');
[c_a,cd]=lwt(double(y),haarint);

minimo=(min(c_a));
c_a=c_a+abs(minimo);% coeficientes > 0

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
sum(th)/length(th)
% plot(th)
% 
% title('Capacidad de bits por muestra - Señal Voz ');
ca_bin=dec2bin(c_a,nbits);

%busco la longitud del mensaje, codificada en los primeros 16bits del
%mensaje
k=1;
j=1;
while (k<=16)
  tm_bin(k:k+th(j)-1)=ca_bin(j,nbits-th(j)+1:nbits);
  k=k+th(j); 
  j=j+1;
end

%calculo en que coeficiente está el último bit del mensaje, según la
%longitud antes calculada.
i=1;
j=0;
tm_bin(1:16);
tm=bin2dec(tm_bin(1:16));
 while (j<=tm+16)
     j=j+th(i);
     i=i+1;
 end
% extraigo el mensaje en binario
k=1;
msg_bin_l=zeros(1,tm+16);
for j=1:i
  msg_bin_l(k:k+th(j)-1)=ca_bin(j,nbits-th(j)+1:nbits);
  k=k+th(j);
end
%separo en caracteres de 8 bits
msg_bin=zeros(floor(length(msg_bin_l)/8),8); %prealloc
for j=0:floor(length(msg_bin_l)/8)-1
    pos=8*j+1;
    msg_bin(j+1,:)=msg_bin_l(pos:pos+8-1);
end
% vector de mensaje en decimal
s=bin2dec(char(msg_bin));
msg=char(s(3:(tm/8))');
end