function E = network_efficient(A)
%A-ÁÚ½Ó¾ØÕó
   a=A;
   n=length(a);
   a(a==0)=inf;
   a([1:n+1:n^2])=0;

         for k=1:n;
             for i = 1:n;
                for j=1:n;
                     if a(i,j)>a(i,k)+a(k,j);
                        a(i,j)=a(i,k)+a(k,j);
                     end
                end
             end
         end

     a;%×î¶ÌÂ·¾ØÕó

      D=1./a;
      D(D==inf)=0;
      E=(sum(D(:)))/(n*(n-1));

end