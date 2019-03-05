function [  ] = plotPrice_BtcVol( btcusdavgprice,statsvlmout )

SPY = 3.1536e+07; %3.1536e+07 seconds/year

% Prepare stats arrays
timevol = statsvlmout{:,1};
vol = statsvlmout{:,2};
timebtc = btcusdavgprice{:,1};
btc = btcusdavgprice{:,2};

minTime = 1.29384e+09; %1/1/2011
maxTime = 1.551755e+09; %3/4/2019
timeTicks = minTime:SPY:maxTime;
minPrice = 0;
maxPriceBtc = 30000;

% labels
usdbtcunit = '[USD$/BTC]';
volunit = '[BTC/Day]';
btctit = sprintf('Bitcoin price, %s',usdbtcunit);
voltit = sprintf('Adjusted transaction volume, %s',volunit);
title({'Daily Bitcoin price and adjusted transaction volume';...
    '\it\fontsize{10}github.com/toadlyBroodle/bitcoin-analysis/'})

% Plot daily exchange chart
ax1 = gca;

%% LOG BTC Price on RIGHT axis
yyaxis(ax1(1),'right')
set(ax1(1),'YScale','log')
set(ax1(1),'ylim', [1,20000])
set(ax1(1),'YColor','b');

hold on;
plot(ax1(1),timebtc,btc,'Color','b')

set(ax1(1),'xlim', [(minTime + SPY),maxTime])
ax1.XTick = timeTicks;
xticklabels(2011:1:2019)
yticklabels([1,10,100,1000,10000])
ylabel(ax1(1),btctit)

%% LOG Volume on LEFT axis
yyaxis(ax1(1),'left')
%set(ax1(1),'ylim', [0,5e-14])

hold on;
plot(ax1(1),timevol,vol,'Color','r')

set(ax1(1),'YScale','log')
set(ax1(1),'YColor','r');
ylabel(ax1(1),voltit)

%% inset linear plot
ax2 = axes('Position',[.57 .18 .25 .25],...
    'XAxisLocation','bottom','YAxisLocation','left',...
    'YScale','linear');
set(ax2,'xlim', [minTime,maxTime])
xticklabels(11:1:19) % year labels

hold(ax2,'on')
%% LIN BTC Price on RIGHT axis
yyaxis(ax2(1),'right')
set(ax2(1),'YColor','b');
plot(timebtc,btc,'b');

ylabel(ax2,usdbtcunit);
yticklabels([0,10000,20000])
ax2.XTick = timeTicks;

%% LIN Volume on LEFT axis
yyaxis(ax2(1),'left')
set(ax2(1),'YColor','r');
plot(timevol,vol,'r');

ylabel(ax2,volunit);
%yticklabels([0,10000,20000])
ax2.XTick = timeTicks;

end