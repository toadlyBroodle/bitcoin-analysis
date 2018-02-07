function [ ] = plotPriceChart( avgPrice, log_y )

% Prepare arrays and tables of times and prices
price = avgPrice{:,2};
priceJul2017 = avgPrice{1:2103,2};
priceNov2017 = avgPrice{1:2226,2};
time = avgPrice{:,1};
timeJul2017 = avgPrice{1:2103,1};
timeNov2017 = avgPrice{1:2226,1};
timeFut = linspace(1.45e+9,1.55e+9,20);
date = datetime(time,'ConvertFrom','posixtime');
dateJul2017 = datetime(timeJul2017,'ConvertFrom','posixtime');
dateNov2017 = datetime(timeNov2017,'ConvertFrom','posixtime');
dateFut = datetime(timeFut,'ConvertFrom','posixtime');

% all coefficients derived from curve fitting tool, i.e.:
    %fitFull = fit(time,price,'exp1')
    %fitJul = fit(timeJul2017,priceJul2017,'exp1')
    %fitNov = fit(timeNov2017,priceNov2017,'exp1')
fa = 5.355e-50; % 3.811e-11 <-- bounded at 0; 5.355e-50 <-- unbounded
fb = 8.107e-08; % 2.156e-08 <-- bounded at 0; 8.107e-08 <-- unbounded
ma = 4.556e-08; % 4.556e-08 <-- bounded at 0; 2.957e-34 <-- unbounded
mb = 1.634e-08; % 1.634e-08 <-- bounded at 0; 5.68e-08 <-- unbounded
ca = 7.521e-13;
cb = 2.354e-08;

fullExpFun = fa*exp(fb*time); 
medExpFun = ma*exp(mb*timeNov2017);
choppedExpFun = ca*exp(cb*timeJul2017);
fullExpFunFut = fa*exp(fb*timeFut);
medExpFunFut = ma*exp(mb*timeFut);
choppedExpFunFut = ca*exp(cb*timeFut);

% Plot daily price chart
figure(1)
hold on
grid on
% linear or log y-axis?
if (log_y)
    set(gca, 'YScale', 'log');
    ylim([1 50000]);
    %xlim([1.23e+9 1.55e+9]);
else
    ax = gca;
    ax.YAxis.Exponent = 3;
    ylim([0 20000]);
    xlim([1.45e+9 1.55e+9]);
end

plot(date,price);
plot(date,fullExpFun,'r');
plot(dateNov2017,medExpFun,'g');
plot(dateJul2017,choppedExpFun,'m');
plot(dateFut,fullExpFunFut,'r--');
plot(dateFut,medExpFunFut,'g--');
plot(dateFut,choppedExpFunFut,'m--');
title('Figure 1. Daily averaged btcusd price')
xlabel('Time, year')
ylabel('Bitcoin price, USD/BTC')
%ytickformat('usd');
legend('Daily averaged Bitstamp trades','Exponential fit to 4-Feb-2018', 'Exponential fit to 6-Nov-2017', 'Exponential fit to 14-Jul-2017');

end