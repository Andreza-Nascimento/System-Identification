function fac=myfac2(y,TAU)
  
N=length(y);

for tau=0:TAU,
     soma=0;
     for t=tau+1:N,
       aux=y(t)*y(t-tau);
       soma=soma+aux;
     end
     fac(tau+1)=soma/(N-tau);
end


