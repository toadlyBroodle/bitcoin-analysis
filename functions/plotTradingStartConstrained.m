function [ ] = plotTradingStartConstrained( avgPrice)

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

minTime = 0;
maxTime = 1.55e+09 - timeOfBitstamp;

% Plot daily price chart
figure(2)
hold on
grid on

ax = gca;
set(ax, 'YScale', 'log');
xlim([minTime maxTime]);

plot(date,price,'LineWidth',2);
plot(date,tradingExpFun,'r','LineWidth',2);
plot(dateFut,tradingExpFunFut,'r--','LineWidth',2);

title('Daily averaged btcusd trading price, logarithmic scale')
xlabel('Time, year')
ylabel('Bitcoin price, USD/BTC')
legend('Daily averaged Bitstamp trades','Constrained exponential fit to 18-Feb-2018',sprintf('y=*exp(%.3e*x), where x=0 at %.3e Unix timestamp',b, timeOfBitstamp));

% axis for years
ax2 = axes('Position',[ax.Position(1) .88 ax.Position(3) 1e-12],'XAxisLocation','top','Color','none');
ax2.XLim = [minTime,maxTime];

% inset linear plot
ax3 = axes('Position',[.66 .14 .25 .25],...
    'XAxisLocation','top','YAxisLocation','right',...
    'YScale','linear');

hold on;
plot(date,price);
plot(date,tradingExpFun,'r');
plot(dateFut,tradingExpFunFut,'r--');

set(ax3,'XTick',[],'YTick',[],'XLabel',[],'YLabel',[],...
    'XLim',[min(date(:)) max(dateFut(:))],'YLim',[min(price(:)) max(price(:))]);

end