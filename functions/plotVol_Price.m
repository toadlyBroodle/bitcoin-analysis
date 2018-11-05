function [  ] = plotVol_Price( statsvlmout,btcusdavgprice )

SPY = 3.1536e+07; %3.1536e+07 seconds/year

% Prepare stats arrays
timevol = statsvlmout{:,1};
vol = statsvlmout{:,2};
%lnsp500 = log(sp500);
timebtc = btcusdavgprice{:,1};
btc = btcusdavgprice{:,2};
%lnbtc = log(btc);

minTime = 1.29384e+09; %1/1/2011
maxTime = 1.5463e+09; %1/1/2019
timeTicks = minTime:SPY:maxTime;
minPrice = 0;
maxPriceBtc = 30000;
%maxPriceSp500 = 3000;

% labels
usd = ' (USD$)';
btcy = 'USD/BTC';
btctit = sprintf('Daily %s price',btcy);
voly = 'S&P500';
voltit = sprintf('Daily %s close',voly);
title({sprintf('%s and %s',btctit,voltit);...
    '\it\fontsize{10}github.com/toadlyBroodle/bitcoin-analysis/'})

% Plot daily exchange chart
ax1 = gca;

yyaxis(ax1(1),'left')
hold on;
plot(ax1(1),timebtc,btc,'Color','b')
%plot(ax1(1),timeTicks,fitbtcline,'g--','LineWidth',2);

set(ax1(1),'YColor','b');
set(ax1(1),'YScale','log')
%set(ax1(1),'ylim', [minPrice,maxPriceBtc])
%set(ax1(1),'xlim', [(minTime + SPY),maxTime])
ax1.XTick = timeTicks;
xticklabels(2011:1:2019)
yticklabels([1,10,100,1000,10000])
ylabel(ax1(1),sprintf('%s%s',btcy,usd))

yyaxis(ax1(1),'right')
hold on;
plot(ax1(1),timevol,vol,'Color','r')
%plot(ax1(1),timeTicks,fitsp500line,'p--','LineWidth',2);

set(ax1(1),'YScale','log')
%set(ax1(1),'ylim', [minPrice,maxPriceSp500])
set(ax1(1),'xlim', [minTime,maxTime])
set(ax1(1),'YColor','r');
ylabel(ax1(1),sprintf('%s%s',voly,usd))

% inset linear plot
ax3 = axes('Position',[.64 .18 .25 .25],...
    'XAxisLocation','top','YAxisLocation','left',...
    'YScale','linear');

hold(ax3,'on')
plot(timebtc,btc,'b');
plot(timevol,vol,'r');

ylabel(ax3,usd);
yticklabels([0,10000,20000])
set(ax3,'xlim', [minTime,maxTime])
ax3.XTick = timeTicks;
ax3.XAxisLocation = 'bottom';
xticklabels(11:1:19)
%legend(btcy,sp500y);

end