%%
close all
clear all

[y, fs, nbits]=wavread('sonido4');
subplot(2,1,1)
%si la señal tiene dos canales me quedo con uno y la acorto
if size(y,2)>1
    y=y(1:22560,1);
end
plot(y)
sound(y,fs)
haarint=liftwave('haar','int2int');
[ca,cd]=lwt(y,haarint);
minimo=abs(min(ca));
c_a=ca+minimo;
c_a=c_a.*(2^(nbits-1));


%thr=floor(log2((c_a)));
th=zeros(1,length(c_a));
bits_fijos=8;
for i=1:length(c_a)
    if ((abs(c_a(i)))>=2^(nbits-1))
        th(i)=nbits-1-bits_fijos;
        %th(i)=15-bits_fijos;
        elseif ((abs(c_a(i)))<2^(nbits-1) && (abs(c_a(i)))>=(nbits-3))
            %th(i)=thr(i)-6;
            th(i)=nbits-3-bits_fijos;
    
            elseif ((abs(c_a(i)))<(nbits-3) && (abs(c_a(i)))>=(nbits-5))
                %th(i)=thr(i)-5;
                th(i)=nbits-5-bits_fijos;

                elseif ((abs(c_a(i)))<(nbits-5) && (abs(c_a(i)))>=(nbits-7))
                    %th(i)=thr(i)-4;
                    th(i)=nbits-7-bits_fijos;
                    elseif ((abs(c_a(i)))<(nbits-7) && (abs(c_a(i)))>(nbits-9))
                        %th(i)=thr(i)-3;
                        th(i)=3;
                        
    else
        th(i)=1;
        
    end
end


% for i=1:length(c_a)
%     if (abs(c_a(i))>=2^10)
% %         th(i)=thr(i)-3;
%           th(i)=10-3;
%     elseif ((abs(c_a(i)))<2^10 && (abs(c_a(i)))>=2^5)
%         th(i)=7-2;
%     else
%         th(i)=4;
%     end
% end

ca_bin2=dec2bin(c_a,nbits);
ca_bin=ca_bin2;
nbits_m=8;%cantidad de para codificar el mensaje
%mensaje
mens_temp=dec2bin(single('Estaba el diablo mal parado en la esquina de mi barrio ahi donde dobla el viento y se cruzan los atajos. Al lado de él estaba la muerte, con una botella en la mano me miraban de reojo y se reían por lo bajo.Y yo que esperaba no sé a quién,al otro lado de la calle del otoño una noche de bufanda que me encontró desvelado,entre dientes oí a la muerte que decía así: Cuántas veces se habrá escapado,como laucha por tirantey esta noche que no cuesta nada, ni siquiera fatigarme, podemos llevarnos un cordero, con solo cruzar la calle. Yo me escondí tras la niebla y miré al infinito,a ver si llegaba ese que nunca iba a venir.Estaba el diablo mal parado en la esquina de mi barrio,al lado de él estaba la muerte,con una botella en la mano. Y temblando como una hoja,me crucé para encararlos,y les dije, me parece que esta vez me dejaron bien plantado. Les pedí fuego y del bolsillo saqué una rama pa convidarlos y bajo un árbol del otoñonos quedamos chamuyando,me contaron de sus vidas,sus triunfos y sus fracasos,de que el mundo andaba locoy hasta el cielo fué comprado y más miedo que ellos dos,me daba el propio ser humano.Y yo ya no esperaba a nadie,y entre las risas del aquelarre el diablo y la muerte se me fueron amigando, ahí donde dobla el viento y se cruzan los atajos, ahí donde brinda la vida en la esquina de mi barrio. Estaba el diablo mal parado en la esquina de mi barrio ahi donde dobla el viento y se cruzan los atajos. Al lado de él estaba la muerte, con una botella en la mano me miraban de reojo y se reían por lo bajo.Y yo que esperaba no sé a quién,al otro lado de la calle del otoño una noche de bufanda que me encontró desvelado,entre dientes oí a la muerte que decía así: Cuántas veces se habrá escapado,como laucha por tirantey esta noche que no cuesta nada, ni siquiera fatigarme, podemos llevarnos un cordero, con solo cruzar la calle. Yo me escondí tras la niebla y miré al infinito,a ver si llegaba ese que nunca iba a venir.Estaba el diablo mal parado en la esquina de mi barrio,al lado de él estaba la muerte,con una botella en la mano. Y temblando como una hoja,me crucé para encararlos,y les dije, me parece que esta vez me dejaron bien plantado. Les pedí fuego y del bolsillo saqué una rama pa convidarlos y bajo un árbol del otoñonos quedamos chamuyando,me contaron de sus vidas,sus triunfos y sus fracasos,de que el mundo andaba locoy hasta el cielo fué comprado y más miedo que ellos dos,me daba el propio ser humano.Y yo ya no esperaba a nadie,y entre las risas del aquelarre el diablo y la muerte se me fueron amigando, ahí donde dobla el viento y se cruzan los atajos, ahí donde brinda la vida en la esquina de mi barrio.'),nbits_m);
mens=[];

%tranformar mensaje en vector fila
for i=1:size(mens_temp,1)
    mens=[mens mens_temp(i,:)];
end
mens_bin=dec2bin(mens,nbits_m);

%tm=size(ms_d,2);%tamaño del mensaje
 k=1;
 i=1;
 j=0;
 tm=length(mens)+16;
 while (j<tm)
     j=j+th(i);
     i=i+1;
 end

 bits_tm=16;
 tm_bin=dec2bin(tm,bits_tm);
 mens=[tm_bin(1:8) tm_bin(9:16) mens];
for j=1:i-2
  ca_bin(j,nbits-th(j)+1:nbits)=mens(k:k+th(j)-1);
  k=k+th(j);
end

ca_dec=bin2dec(ca_bin);
y_dec = ilwt(ca_dec,cd,haarint);
y_dec=y_dec./(2^(nbits-1));
x=y_dec-minimo;


subplot(2,1,2)
plot(x)
sound(x,fs)
wavwrite(x,fs,nbits,'salida.wav')
%% verificacion
close all
clear all
nbits_m=8;
[y, fs2, nbits2]=wavread('sonido4');
if size(y,2)==2
    y=y(1:22560,1);
end
[x, fs, nbits]=wavread('salida.wav');
haarint=liftwave('haar','int2int');
[ca_ver,cd]=lwt(x,haarint);

minimo=(min(ca_ver));
%minimo=0.9592;
c_b=ca_ver+abs(minimo);
c_b2=c_b.*(2^(nbits-1));
th2=zeros(1,length(ca_ver));
bits_fijos=8;

for i=1:length(ca_ver)
    if ((abs(c_b2(i)))>=2^(nbits-1))
        th2(i)=nbits-1-bits_fijos;
        %th(i)=15-bits_fijos;
        elseif ((abs(c_b2(i)))<2^(nbits-1) && (abs(c_b2(i)))>=(nbits-3))
            %th(i)=thr(i)-6;
            th2(i)=nbits-3-bits_fijos;
    
            elseif ((abs(c_b2(i)))<(nbits-3) && (abs(c_b2(i)))>=(nbits-5))
                %th(i)=thr(i)-5;
                th2(i)=nbits-5-bits_fijos;

                elseif ((abs(c_b2(i)))<(nbits-5) && (abs(c_b2(i)))>=(nbits-7))
                    %th(i)=thr(i)-4;
                    th2(i)=nbits-7-bits_fijos;
                    elseif ((abs(c_b2(i)))<(nbits-7) && (abs(c_b2(i)))>(nbits-9))
                        %th(i)=thr(i)-3;
                        th2(i)=3;
                        
    else
        th2(i)=1;
        
    end
end
%th2=th;


c_bin2=dec2bin(c_b2,nbits);
w=0;
k=1;
j=1;

while (k<=16)
  tm_bin(k:k+th2(j)-1)=c_bin2(j,nbits-th2(j)+1:nbits);
  k=k+th2(j); 
  j=j+1;
end
i=1;
j=0;
tm=bin2dec(tm_bin(1:16));
 while (j<=tm+16)
     j=j+th2(i);
     i=i+1;
 end
%m=zeros(size(ms_bin,1),size(ms_bin,2));
k=1;

for j=1:i-2
  mens_re(k:k+th2(j)-1)=c_bin2(j,nbits-th2(j)+1:nbits);
  k=k+th2(j);
end
g=[];
for j=0:round(length(mens_re)/nbits_m)-2
    n=nbits_m*j+1;
    g=[g;mens_re(n:n+nbits_m-1)];
end
s=bin2dec(g);
largo=[length(x) length(y)];
char(s(3:(tm/8))')
    
    


snr= 10*log10((sum(y(1:min(largo)).^2))/(sum(y(1:min(largo))-x(1:min(largo))).^2))

