function [ ] = plotPriceLnFits( btcusdavgdayprice )

subsetCellEnd = 2103;
maxTime = 1.55e+09;

% Prepare arrays and tables of times and prices
price = btcusdavgdayprice{:,2};
lnPrice = log(price);
priceJul2017 = btcusdavgdayprice{1:subsetCellEnd,2};
lnPriceJul2017 = log(priceJul2017);
time = btcusdavgdayprice{:,1};
timeJul2017 = btcusdavgdayprice{1:subsetCellEnd,1};
timeFut = linspace(time(end),maxTime,20);
date = datetime(time,'ConvertFrom','posixtime');
dateFut = datetime(timeFut,'ConvertFrom','posixtime');

fitFull = fit(time,price,'exp1');
fitJul = fit(timeJul2017,priceJul2017,'exp1');
extFut = fitFull.a*exp(fitFull.b*timeFut(:));
extJulFut = fitJul.a*exp(fitJul.b*timeFut(:));

minTime = time(1);
minPrice = min(price(:));
maxPrice = max(price(:));

% Plot daily price chart
figure(2)
hold on
grid on

ax = gca;
set(ax, 'YScale', 'log');
xlim([minTime maxTime]);

plot(fitFull,'b--',time,price,'b');
plot(fitJul,'r--');
%plot(extFut,'b--');
%plot(extJulFut,'r--');

title('Daily averaged btcusd trading price')
xlabel('Time, year')
ylabel('Bitcoin price, USD/BTC')
legend('Daily averaged Bitstamp trades',...
    sprintf('Full fit: y=%.3e*exp(%.3e*x)',fitFull.a,fitFull.b),...
    sprintf('Fit to Jul-2017: y=%.3e*exp(%.3e*x)',fitJul.a,fitJul.b));

% axis for years
ax2 = axes('Position',[ax.Position(1) .88 ax.Position(3) 1e-12],...
    'XAxisLocation','top',...
    'XLim',[2011.75,2019],...
    'Color','none');

% inset linear plot
ax3 = axes('Position',[.77 .14 .15 .15],...
    'XAxisLocation','top','YAxisLocation','right',...
    'YScale','linear');

hold on;
plot(time,price,'b');
%plot(extFut,'b--');
plot(fitJul,'r--');
%plot(extJulFut,'r--');

set(ax3,'XTick',[],'YTick',[],'XLabel',[],'YLabel',[],...
    'XLim',[minTime maxTime],'YLim',[minPrice maxPrice]);
end