function [ ] = plotStartBitstampTradingLog( avgPrice, logy )

timeOfBitstamp = 1.316e+09;

% Prepare arrays and tables of times and prices
price = avgPrice{:,2};
time = avgPrice{:,1};
timeFromTrading(:,1) = time(:,1) - timeOfBitstamp;
timeExtrapd = linspace(0,1.55e+9 - timeOfBitstamp,40);

date = datetime(time,'ConvertFrom','posixtime');
dateFut = datetime(timeExtrapd + timeOfBitstamp,'ConvertFrom','posixtime');
% coefficient derived from curve fitting tool, i.e.:
    % y(x)=exp(b*x) <-- at x=0, a=1
b = 4.459e-08; % 4.459e-08

tradingExpFun = exp(b*timeFromTrading);
tradingExpFunFut = exp(b*timeExtrapd);

% Plot daily price chart
figure(2)
hold on
grid on

%if logy
set(gca, 'YScale', 'log');
%ylim([0.01 1e+5]);
xlim([0 1.55e+9 - timeOfBitstamp]);


%else
%ax = gca;
%ax.YAxis.Exponent = 3;
%ylim([0 20000]);
%xlim([1.45e+9 1.55e+9]);
%end

plot(date,price);
plot(date,tradingExpFun,'r');
plot(dateFut,tradingExpFunFut,'r--');

title('Figure 3. Daily averaged btcusd trading price, logarithmic scale')
xlabel('Time, year')
ylabel('Bitcoin price, USD/BTC')
legend('Daily averaged Bitstamp trades','Constrained exponential fit to 13-Feb-2018');
end