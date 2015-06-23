function [msg] = lsbStepByteDecoder( y_dec, min, nbits )

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
    msg = char(s');

end