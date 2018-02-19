function [ ] = plotStartBitstampTradingLog( avgPrice, logy )

timeOfBitstamp = 1.316e+09;

% Prepare arrays and tables of times and prices
price = avgPrice{:,2};
time = avgPrice{:,1};
timeFromTrading(:,1) = time(:,1) - timeOfBitstamp;
timeExtrapd = linspace(1.52e+09 - timeOfBitstamp, 1.55e+09 - timeOfBitstamp,20);

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

ax = gca;

if logy
set(ax, 'YScale', 'log');
xlim([0 1.55e+9 - timeOfBitstamp]);

else
ylim([0 25000]);
ax.YAxis.Exponent = 3;
end

plot(date,price,'LineWidth',2);
plot(date,tradingExpFun,'r','LineWidth',2);
plot(dateFut,tradingExpFunFut,'r--','LineWidth',2);

title('Daily averaged btcusd trading price, logarithmic scale')
xlabel('Time, year')
ylabel('Bitcoin price, USD/BTC')
legend('Daily averaged Bitstamp trades','Constrained exponential fit to 18-Feb-2018',sprintf('y=*exp(%.3e*x), where x=0 at %.3e Unix timestamp',b, timeOfBitstamp));

end