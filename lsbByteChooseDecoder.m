function [msg] = function lsbByteChooseDecoder( y_dec, minimo, nbits )
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
    msg = char(s');

end