%
% mc_rpt
%
ac_lev = [sum(ac(:,1))/nb sum(ac(:,2))/np];	
fprintf('Data "%s" %3i/%5i/%5i/%2i/%4.2f\n',...
	'flares',mvar,[nb np]/1000,sample_rate,q_sig) 
fprintf(' pmin = %i,',pmin)
fprintf(' accept: %5.3f %5.3f\n',ac_lev)
end1 = size(Ts,2);
dt_mean  = mean(Ts(nb+1:end1));
dt_sigma = std(Ts(nb+1:end1));
fprintf('DT mean and sigma: %5.2f %5.2f\n',dt_mean,dt_sigma)
[dum,mp] = max(store_prb); 
ter = 100*mean(mp' ~= Yt);							
fprintf('Test error = %5.2f%%\n\n',ter)

subplot(3,2,1)
plot(Lik(1:nb)), grid on
xlabel('Samples of burn-in'), ylabel('Log likelihood')
subplot(3,2,3)
plot(Ts(1:nb)), grid on
ylabel('DT nodes'), xlabel('Samples of burn-in')
subplot(3,2,5)
[a,b] = hist(Ts(1:nb),1:max(Ts(1:nb))); 
bar(b,a/nb);
grid on
xlabel('DT nodes'), ylabel('Prob')
subplot(3,2,2)
plot(Lik(nb+1:end1)), grid on
xlabel('Samples of post burn-in'), ylabel('Log likelihood')
subplot(3,2,4) 
plot(Ts(nb+1:end1)), grid on
ylabel('DT nodes'), xlabel('Samples of post burn-in')
subplot(3,2,6) 
[a,b] = hist(Ts(nb+1:end1),1:max(Ts(nb+1:end1))); 
bar(b,a/np);
grid on
xlabel('DT nodes'), ylabel('Prob')

if hist_collect == 1
  fprintf('1: %5.2f%% %5.2f%%\n',100 - ter,ter)
  hist_ar_norm = hist_ar/np;  
  Yq = zeros(numt,1);
  for c1 = 1:C
    A = find(hist_ar_norm(c1,:) >= consist_lev);
    Yq(A) = c1;
  end
  conf_cor = 100*sum(Yq == Yt)/numt;							
  A = find(Yq > 0);
  conf_incor = 100*sum(Yq(A) ~= Yt(A))/numt;
  uncert = 100*sum(Yq == 0)/numt;
  fprintf('2: %5.2f%% %5.2f%% %5.2f%%\n',conf_cor,uncert,conf_incor)
end
return