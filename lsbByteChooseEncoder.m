function [snr] = lsbByteChooseEncoder( archivo_entrada,archivo_salida, msg )

      [y, fs, nbits]=wavread(archivo_entrada);
      if size(y,2)>1
          y=y(1:22560,1);
      end
      minimo=abs(min(y));
      y_a=y+minimo;
      y_a=y_a.*(2^(nbits-1));
      y_bin=dec2bin(y_a,nbits);
      tm=size(y_bin,1);
      length(msg);
     

      nbits_m=8; % Cantidad de para codificar el mensaje
      % Mensaje a codificar
      ms_d=single(msg);
      ms_bin=dec2bin(ms_d,nbits_m);
      size(ms_bin);
      floor(size(ms_bin,1)*8);
     if (tm<floor(size(ms_bin,1)*8))
        ms_bin=ms_bin(1:floor(tm/8),:);
      end
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
      snr= 10*log10((sum(y.^2))/(sum(y-y_dec).^2)); 
      wavwrite(y_dec, fs, nbits, archivo_salida); 
end      