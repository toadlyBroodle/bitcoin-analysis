function [ ] = plotPrice( avgPrice )

% Prepare arrays and tables of times and prices
price = avgPrice{:,2};
time = avgPrice{:,1};
timeJul2017 = avgPrice{1:2103,1};
timeFut = linspace(1.45e+9,1.55e+9,80);
date = datetime(time,'ConvertFrom','posixtime');
dateJul2017 = datetime(timeJul2017,'ConvertFrom','posixtime');
dateFut = datetime(timeFut,'ConvertFrom','posixtime');

% all coefficients derived from curve fitting tool, i.e.:
    %fitFull = fit(time,price,'exp1')
    %fitJul = fit(timeJul2017,priceJul2017,'exp1')
    %fitNov = fit(timeNov2017,priceNov2017,'exp1')
fa = 5.355e-50; % 3.811e-11 <-- bounded at 0; 5.355e-50 <-- unbounded;
fb = 8.107e-08; % 2.156e-08 <-- bounded at 0; 8.107e-08 <-- unbounded;
ca = 7.521e-13;
cb = 2.354e-08;

fullExpFun = fa*exp(fb*time); 
choppedExpFun = ca*exp(cb*timeJul2017);
fullExpFunFut = fa*exp(fb*timeFut);
choppedExpFunFut = ca*exp(cb*timeFut);

% extend to 2009 dummy data
pa = 2.134e-19; % 2.134e-19 <-- 2009 dummy data, 0-constrained
pb = 3.418e-08; % 3.418e-08 <-- 2009 dummy data, 0-constrained
fullExpFunPastSolid = pa*exp(pb*time);
fullExpFunPast = pa*exp(pb*timeFut);


% Plot daily price chart
figure(2)
hold on
grid on

ax = gca;
ax.YAxis.Exponent = 3;
ylim([0 20000]);
xlim([1.45e+9 1.55e+9]);

plot(date,price);
plot(date,fullExpFun,'r');
plot(dateJul2017,choppedExpFun,'m');

plot(date,fullExpFunPastSolid,'g');
plot(dateFut,fullExpFunPast,'g--');

plot(dateFut,fullExpFunFut,'r--');
plot(dateFut,choppedExpFunFut,'m--');

title('Figure 1. Daily averaged btcusd trading price')
xlabel('Time, year')
ylabel('Bitcoin price, USD/BTC')
legend('Daily averaged Bitstamp trades','Exponential fit to 13-Feb-2018','Exponential fit to 14-Jul-2017','Exponential fit from 1-Jan-2009');

end