function [  ] = plotSP500BTC( sp50013sep2017,btcusdavgprice )

SPY = 3.1536e+07; %3.1536e+07 seconds/year

% Prepare stats arrays
timesp500 = sp50013sep2017{:,1};
sp500 = sp50013sep2017{:,2};
%lnsp500 = log(sp500);
timebtc = btcusdavgprice{:,1};
btc = btcusdavgprice{:,2};
%lnbtc = log(btc);

minTime = 1.29384e+09; %1/1/2011
maxTime = 1.5463e+09; %1/1/2019
timeTicks = minTime:SPY:maxTime;
minPrice = 0;
maxPriceBtc = 30000;
maxPriceSp500 = 3000;

% best fit lines
fitpolysp500 = fit(timesp500,sp500,'poly1');
fitsp500line = fitpolysp500.p1*timeTicks+fitpolysp500.p2;
fitpolybtc = fit(timebtc,btc,'poly1');
fitbtcline = fitpolybtc.p1*timeTicks+fitpolybtc.p2;

% labels
usd = ' (USD$)';
btcy = 'USD/BTC';
btctit = sprintf('Daily %s price',btcy);
sp500y = 'S&P500';
sp500tit = sprintf('Daily %s close',sp500y);
title({sprintf('%s and %s',btctit,sp500tit);...
    '\it\fontsize{10}github.com/toadlyBroodle/bitcoin-analysis/'})

% Plot daily exchange chart
ax1 = gca;

yyaxis(ax1(1),'left')
hold on;
plot(ax1(1),timebtc,btc,'Color','b')
plot(ax1(1),timeTicks,fitbtcline,'g--','LineWidth',2);

set(ax1(1),'YColor','b');
set(ax1(1),'YScale','log')
set(ax1(1),'ylim', [minPrice,maxPriceBtc])
%set(ax1(1),'xlim', [(minTime + SPY),maxTime])
ax1.XTick = timeTicks;
xticklabels(2011:1:2019)
yticklabels([1,10,100,1000,10000])
ylabel(ax1(1),sprintf('%s%s',btcy,usd))

yyaxis(ax1(1),'right')
hold on;
plot(ax1(1),timesp500,sp500,'Color','r')
plot(ax1(1),timeTicks,fitsp500line,'p--','LineWidth',2);

set(ax1(1),'YScale','log')
set(ax1(1),'ylim', [minPrice,maxPriceSp500])
set(ax1(1),'xlim', [minTime,maxTime])
set(ax1(1),'YColor','r');
ylabel(ax1(1),sprintf('%s%s',sp500y,usd))

% inset linear plot
ax3 = axes('Position',[.64 .18 .25 .25],...
    'XAxisLocation','top','YAxisLocation','left',...
    'YScale','linear');

hold(ax3,'on')
plot(timebtc,btc,'b');
plot(timesp500,sp500,'r');

ylabel(ax3,usd);
yticklabels([0,10000,20000])
set(ax3,'xlim', [minTime,maxTime])
ax3.XTick = timeTicks;
ax3.XAxisLocation = 'bottom';
xticklabels(11:1:19)
%legend(btcy,sp500y);

end