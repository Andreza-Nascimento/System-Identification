function fac=myfac(y,TAU)
  
N=length(y);

for tau=0:TAU,
     soma=0;
     for t=1:N-tau,
       aux=y(t)*y(t+tau);
       soma=soma+aux;
     end
     fac(tau+1)=soma/(N-tau);
end


