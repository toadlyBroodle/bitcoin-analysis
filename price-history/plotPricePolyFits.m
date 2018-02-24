function [ ] = plotPricePolyFits( btcusdavgweekprice )

subsetCellEnd = 304; % daily=2103, weekly=304
maxTime = 1.55e+09;
startTradingTime = 1.316e+09;

% Prepare arrays and tables of times and prices
price = btcusdavgweekprice{:,2};
lnPrice = log(price);
priceJul2017 = btcusdavgweekprice{1:subsetCellEnd,2};
lnPriceJul2017 = log(priceJul2017);
time = btcusdavgweekprice{:,1};
timeJul2017 = btcusdavgweekprice{1:subsetCellEnd,1};
timeFut = linspace(time(end),maxTime,20);
date = datetime(time,'ConvertFrom','posixtime');
dateFut = datetime(timeFut,'ConvertFrom','posixtime');

fitFull = fit(time,lnPrice,'poly1');
fitJul = fit(timeJul2017,lnPriceJul2017,'poly1');
%extFut = fitFull.p2*exp(fitFull.p1*timeFut(:));
%extJulFut = fitJul.p2*exp(fitJul.p1*timeFut(:));

minTime = time(1);
minPrice = min(price(:));
maxPrice = max(price(:));

% Plot daily price chart
figure(2)
hold on
grid on

ax = gca;
%set(ax, 'YScale', 'log');
xlim([minTime maxTime]);

plot(fitFull,'b--',time,lnPrice,'b');
plot(fitJul,'r--');
%plot(extFut,'b--');
%plot(extJulFut,'r--');

title('Weekly averaged BTC/USD Bitstamp trading price')
xlabel('Unix timestamp, [seconds since epoch]')
ylabel('Natural logarithm of Bitcoin price, [USD/BTC]')
legend('Ln(weekly averaged Bitstamp trades)',...
    sprintf('Full fit: ln(y)=%.3e*x+%.3e',fitFull.p2,fitFull.p1),...
    sprintf('Fit to Jul-2017: ln(y)=%.3e*x+%.3e',fitJul.p2,fitJul.p1));

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
%plot(fitJul,'r--');
%plot(extJulFut,'r--');

set(ax3,'XTick',[],'YTick',[],'XLabel',[],'YLabel',[],...
    'XLim',[minTime maxTime],'YLim',[minPrice maxPrice]);
end