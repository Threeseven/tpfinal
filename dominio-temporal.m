close all
clear all
%LSB original para ocultar texto
%sonido portador

[y, fs, nbits]=wavread('sound1.WAV');
subplot(3,1,1)
plot(y)
sound(y,fs)
minimo=abs(min(y));
y_a=y+minimo;
%subplot(4,1,2)
%plot(y)
%sound(y,fs)
y_a=y_a.*(2^(nbits-1));
% nbits=8;
y_bin=dec2bin(y_a,nbits);


nbits_m=8;%cantidad de bits para codificar el mensaje
%mensaje
ms_d=single('Estaba el diablo mal parado en la esquina de mi barrio ahi donde dobla el viento y se cruzan los atajos. Al lado de él estaba la muerte, con una botella en la mano me miraban de reojo y se reían por lo bajo.Y yo que esperaba no sé a quién,al otro lado de la calle del otoño una noche de bufanda que me encontró desvelado,entre dientes oí a la muerte que decía así: Cuántas veces se habrá escapado,como laucha por tirantey esta noche que no cuesta nada, ni siquiera fatigarme, podemos llevarnos un cordero, con solo cruzar la calle. Yo me escondí tras la niebla y miré al infinito,a ver si llegaba ese que nunca iba a venir.Estaba el diablo mal parado en la esquina de mi barrio,al lado de él estaba la muerte,con una botella en la mano. Y temblando como una hoja,me crucé para encararlos,y les dije, me parece que esta vez me dejaron bien plantado. Les pedí fuego y del bolsillo saqué una rama pa convidarlos y bajo un árbol del otoñonos quedamos chamuyando,me contaron de sus vidas,sus triunfos y sus fracasos,de que el mundo andaba locoy hasta el cielo fué comprado y más miedo que ellos dos,me daba el propio ser humano.Y yo ya no esperaba a nadie,y entre las risas del aquelarre el diablo y la muerte se me fueron amigando, ahí donde dobla el viento y se cruzan los atajos, ahí donde brinda la vida en la esquina de mi barrio.  ');
ms_bin=dec2bin(ms_d,nbits_m);
%Codificación
k=1;
for i=1:size(ms_bin,1)
  for j=1:size(ms_bin,2)
      y_bin(k,nbits)=ms_bin(i,j);
      k=k+1;
  end
end
y_dec=bin2dec(y_bin);
y_dec=(y_dec./2^(nbits-1))-minimo;
sound(y_dec,fs)
subplot(3,1,2)
plot(y_dec)
subplot(3,1,3)
plot(y-y_dec)

%%verificacion

y_ver_aux=y_dec+minimo;
y_ver_aux=y_ver_aux.*2^(nbits-1);
y_ver=dec2bin(y_ver_aux,nbits);
%m=zeros(size(ms_bin,1),size(ms_bin,2));
for i=0:size(ms_bin,1)-1
    n=nbits_m*i+1;
    m(i+1,:)=y_ver(n:n+nbits_m-1,nbits);
end
s=bin2dec(m);
char(s')
snr= 10*log10((sum(y.^2))/(sum(y-y_dec).^2))
%% nSB segun primeros 2 bits  n=14,15,16
close all
clear all

%sonido portador

[y, fs, nbits]=wavread('sound1.WAV');
subplot(3,1,1)
plot(y)
sound(y,fs)
minimo=abs(min(y));
y_a=y+minimo;
%subplot(4,1,2)
%plot(y)
%sound(y,fs)
y_a=y_a.*(2^(nbits-1));
y_bin=dec2bin(y_a,nbits);


nbits_m=8;%cantidad de para codificar el mensaje
%mensaje
ms_d=single('Estaba el diablo mal parado en la esquina de mi barrio ahi donde dobla el viento y se cruzan los atajos. Al lado de él estaba la muerte, con una botella en la mano me miraban de reojo y se reían por lo bajo.Y yo que esperaba no sé a quién,al otro lado de la calle del otoño una noche de bufanda que me encontró desvelado,entre dientes oí a la muerte que decía así: Cuántas veces se habrá escapado,como laucha por tirantey esta noche que no cuesta nada, ni siquiera fatigarme, podemos llevarnos un cordero, con solo cruzar la calle. Yo me escondí tras la niebla y miré al infinito,a ver si llegaba ese que nunca iba a venir.Estaba el diablo mal parado en la esquina de mi barrio,al lado de él estaba la muerte,con una botella en la mano. Y temblando como una hoja,me crucé para encararlos,y les dije, me parece que esta vez me dejaron bien plantado. Les pedí fuego y del bolsillo saqué una rama pa convidarlos y bajo un árbol del otoñonos quedamos chamuyando,me contaron de sus vidas,sus triunfos y sus fracasos,de que el mundo andaba locoy hasta el cielo fué comprado y más miedo que ellos dos,me daba el propio ser humano.Y yo ya no esperaba a nadie,y entre las risas del aquelarre el diablo y la muerte se me fueron amigando, ahí donde dobla el viento y se cruzan los atajos, ahí donde brinda la vida en la esquina de mi barrio.  ');
ms_bin=dec2bin(ms_d,nbits_m);
%Codificación
k=1;
lsb1=nbits;
lsb2=nbits-1;
lsb3=nbits-1;
for i=1:size(ms_bin,1)
  for j=1:size(ms_bin,2)
      aux=bin2dec(y_bin(k,1:2));
      if aux==0
          y_bin(k,lsb3)=ms_bin(i,j);
      elseif aux==1
          y_bin(k,lsb2)=ms_bin(i,j); 
      elseif aux==2
          y_bin(k,lsb1)=ms_bin(i,j); 
      else
          y_bin(k,lsb1)=ms_bin(i,j); 
      end
                  
      k=k+1;
  end
end
y_dec=bin2dec(y_bin);
y_dec=(y_dec./2^(nbits-1))-minimo;
sound(y_dec,fs)
subplot(3,1,2)
plot(y_dec)
subplot(3,1,3)
plot(y-y_dec)

%%verificacion

y_ver_aux=y_dec+minimo;
y_ver_aux=y_ver_aux.*2^(nbits-1);
y_ver=dec2bin(y_ver_aux,nbits);

k=1;
for i=1:size(ms_bin,1)
  for j=1:size(ms_bin,2)
      aux=bin2dec(y_ver(k,1:2));
      if aux==0
          m(i,j)=y_ver(k,lsb3);
      elseif aux==1
          m(i,j)=y_ver(k,lsb2);
      elseif aux==2
          m(i,j)=y_ver(k,lsb1);
      else
          m(i,j)=y_ver(k,lsb1);
      end
                  
      k=k+1;
  end
end

%m=zeros(size(ms_bin,1),size(ms_bin,2));
% for i=0:size(ms_bin,1)-1
%     n=nbits_m*i+1;
%     m(i+1,:)=y_ver(n:n+nbits_m-1,16);
% end
s=bin2dec(m);
char(s')
snr= 10*log10((sum(y.^2))/(sum(y-y_dec).^2))
%% LSB con paso variable segun 3 primeros tres bits, oculta menos informacion
close all
clear all

%sonido portador

[y, fs, nbits]=wavread('sound2.WAV');
subplot(3,1,1)
plot(y)
sound(y,fs)
minimo=abs(min(y));
y_a=y+minimo;
%subplot(4,1,2)
%plot(y)
%sound(y,fs)
y_a=y_a.*(2^(nbits-1));
y_bin=dec2bin(y_a,nbits);


nbits_m=8;%cantidad de para codificar el mensaje
%mensaje
ms_d=single('Estaba el diablo mal parado en la esquina de mi barrio ahi donde dobla el viento y se cruzan los atajos. Al lado de él estaba la muerte, con una botella en la mano me miraban de reojo y se reían por lo bajo.Y yo que esperaba no sé a quién,al otro lado de la calle del otoño una noche de bufanda que me encontró desvelado,entre dientes oí a la muerte que decía así: Cuántas veces se habrá escapado,como laucha por tirantey esta noche que no cuesta nada, ni siquiera fatigarme, podemos llevarnos un cordero, con solo cruzar la calle. Yo me escondí tras la niebla y miré al infinito,a ver si llegaba ese que nunca iba a venir.Estaba el diablo mal parado en la esquina de mi barrio,al lado de él estaba la muerte,con una botella en la mano. Y temblando como una hoja,me crucé para encararlos,y les dije, me parece que esta vez me dejaron bien plantado. Les pedí fuego y del bolsillo saqué una rama pa convidarlos y bajo un árbol del otoñonos quedamos chamuyando,me contaron de sus vidas,sus triunfos y sus fracasos,de que el mundo andaba locoy hasta el cielo fué comprado y más miedo que ellos dos,me daba el propio ser humano.Y yo ya no esperaba a nadie,y entre las risas del aquelarre el diablo y la muerte se me fueron amigando, ahí donde dobla el viento y se cruzan los atajos, ahí donde brinda la vida en la esquina de mi barrio.  ');
ms_bin=dec2bin(ms_d,nbits_m);
%Codificación
k=1;
w=0;
lsb=nbits;
for i=1:size(ms_bin,1)
  for j=1:size(ms_bin,2)
      if k<size(y_bin,1)
        y_bin(k,lsb)=ms_bin(i,j);
        w=bin2dec(y_bin(k,1:3));            
        k=k+w+1;
      end
     
  end
end
y_dec=bin2dec(y_bin);
y_dec=(y_dec./2^(nbits-1))-minimo;
sound(y_dec,fs)
subplot(3,1,2)
plot(y_dec)
subplot(3,1,3)
plot(y-y_dec)

%%verificacion

y_ver_aux=y_dec+minimo;
y_ver_aux=y_ver_aux.*2^(nbits-1);
y_ver=dec2bin(y_ver_aux,nbits);

k=1;
for i=1:size(ms_bin,1)
  for j=1:size(ms_bin,2)
      if k<size(y_bin,1)
        m(i,j)=y_ver(k,lsb);
        w=bin2dec(y_ver(k,1:3));            
        k=k+w+1;
      end
  end
end

%m=zeros(size(ms_bin,1),size(ms_bin,2));
% for i=0:size(ms_bin,1)-1
%     n=nbits_m*i+1;
%     m(i+1,:)=y_ver(n:n+nbits_m-1,16);
% end
s=bin2dec(m);
char(s')
snr= 10*log10((sum(y.^2))/(sum(y-y_dec).^2))
