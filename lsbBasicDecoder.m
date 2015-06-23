function [msg] = function lsbBasicDecoder( y_dec, minimo, nbits )
  y_ver_aux=y_dec+minimo;
  y_ver_aux=y_ver_aux.*2^(nbits-1);
  y_ver=dec2bin(y_ver_aux,nbits);
  %m=zeros(size(ms_bin,1),size(ms_bin,2));
  for i=0:size(ms_bin,1)-1
      n=nbits_m*i+1;
      m(i+1,:)=y_ver(n:n+nbits_m-1,nbits);
  end
  s=bin2dec(m);
  msg = char(s');
end