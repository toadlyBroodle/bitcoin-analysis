function [  ] = plotNasdaq_sp500_correlation( IXIC,GSPC )

SPY = 3.1536e+07; %3.1536e+07 seconds/year

% Prepare stats arrays
timeNas = IXIC{:,1};
ixic = IXIC{:,2};
gspc = GSPC{:,2};

%% sp and nas daily movements
len = length(ixic);
movements = zeros(len-1,2);
for i = 1:len
    if i > 1
        movements(i,1) = ixic(i) - ixic(i-1);
        movements(i,2) = gspc(i) - gspc(i-1);
    end
    
end

%% plots
minTime = 1.29384e+09; % 1/1/2011
maxTime = 1.5463e+09; %1/1/2019
timeTicks = minTime:SPY:maxTime;
%minPrice = 0;
%maxPriceBtc = 30000;
%maxPriceNas = 9000;

% best fit lines
%fitpolysp500 = fit(timesp500,sp500,'poly1');
%fitsp500line = fitpolysp500.p1*timeTicks+fitpolysp500.p2;
%fitpolybtc = fit(timebtc,btc,'poly1');
%fitbtcline = fitpolybtc.p1*timeTicks+fitpolybtc.p2;

% labels
usd = '(USD$)';
nastit = 'Nasdaq';
sptit = 'S&P 500';
title({sprintf('Correlated daily %s and %s market movements (i_n - i_n_-_1)',nastit,sptit);...
    '\it\fontsize{10}github.com/toadlyBroodle/bitcoin-analysis/'})

% Plot daily exchange chart
ax1 = gca;

hold on;
plot(ax1(1),timeNas,movements(:,1),'Color','r')
plot(ax1(1),timeNas,movements(:,2),'Color','b')

set(ax1(1),'xlim', [(minTime + SPY),maxTime])
ax1.XTick = timeTicks;
xticklabels(2011:1:2019)
ylabel(sprintf('Market movement %s',usd))
legend(nastit,sptit)

end