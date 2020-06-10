load('DJI_data')
%%
%calculo de retornos
retorno=zeros(length(datos(:,1))-1,length(datos(1,:)));
for j=1:1:length(datos(1,:))
    for i=2:1:length(datos(:,1))
        retorno(i-1,j)=log(datos(i,j)/datos(i-1,j));
    end
end
%%
%calculo de pesos de cada activo 
peso=zeros(length(datos(:,1))-1,length(datos(1,:)));
for jj=2:1:length(datos(:,1))
    sumatotal=sum(datos(jj,:));
    for ii=1:1:length(datos(1,:))
        peso(jj-1,ii)=datos(jj,ii)/sumatotal;
    end
end
%sum(peso) %comprobamos que la suma de los pesos resulte en 1. 
peso1=zeros(1,length(datos(1,:)));
for g=1:1:length(peso(1,:))
    peso1(1,g)=sum(peso(:,g));
end
%%
%retorno de un portafolio esta dado por peso'*retorno
retorno_portafolio=peso.'*retorno;
%%
%calculo de promedio y varianza de cada accion
promedio=zeros(1,length(datos(1,:)));
for ii=1:1:length(datos(1,:))
        promedio(1,ii)=sum(retorno(:,ii))/446;
end
var1=var(retorno);
mean1=mean(retorno);
names={'MMM' 'AXP' 'AAPL' 'BA' 'CAT' 'CVX' 'CSCO' 'KO' 'XOM' 'GS' 'HD' 'IBM' 'INTC' 'JNJ' 'JPM' 'MCD' 'MRK' 'MSFT' 'NKE' 'PG' 'TRV' 'UNH' 'UTX' 'VZ' 'V' 'WMT' 'WBA' 'DIS'};
figure(1)
plot(var1,mean1.*-1,'o')
title('Frente de Pareto')
xlabel('Varianza')
ylabel('Retorno esperado')
text(var1, mean1.*-1, names, 'VerticalAlignment','bottom', ...
                             'HorizontalAlignment','right');

%%
%optimizacion cuadratica
k=4;
maxr=zeros(2,1);
maxv=zeros(2,1);
for u=1:1:2
    cov1=cov(retorno);
    H = k*cov1;
    f = mean1.';
    Aeq = ones(1,28);
    beq = 1;
    x = quadprog(H,f,[],[],Aeq,beq,zeros(28,1),ones(28,1));
    
    maxr(u,1)=(x.'*-1*mean1.');
    maxv(u,1)=(x.'*cov1*x);
    k=k*4;
    
end

%[x,feval]=quadprog(cov1,mean1.');

figure(1)
plot(var1,mean1.*-1,'bo')
title('Frente de Pareto')
xlabel('Varianza')
ylabel('Retorno esperado')
text(var1, mean1.*-1, names, 'VerticalAlignment','bottom', ...
                             'HorizontalAlignment','right');
hold on 
plot(maxv,maxr,'r--*')
