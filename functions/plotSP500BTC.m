function [  ] = plotSP500BTC( sp50013sep2017,btcusdavgprice )

minTime = 1.31e+09;
maxTime = 1.48e+09;

% Prepare stats arrays
time = sp50013sep2017{:,1};
stats = sp50013sep2017{:,2};
lnstats = log(stats);
timebtc = btcusdavgprice{:,1};
btc = btcusdavgprice{:,2};
lnbtc = log(btc);

timepastfut = linspace(minTime,maxTime,20);
% fit data
%fitpolystat = fit(time,lnstats,'poly1');
%fitpolystatext = fitpolystat.p1*timepastfut+fitpolystat.p2;
%expfitPolyExt = exp(fitPolyExt);
%fitpolybtc = fit(timebtc,lnbtc,'poly1');
%fitpolybtcext = fitpolybtc.p1*timepastfut+fitpolybtc.p2;

% Plot daily exchange chart
figure(2)
grid on;
ax1 = gca;

%xlim([minTime maxTime]);
%ylim([min(lnstats(:)) max(lnstats(:)) + 1]); % add padding to top y-axis for timeline

plot(timebtc,lnbtc,'b');
%plot(timepastfut,fitpolystatext,'g--','LineWidth',2);

hold on;

% labels
btcy = 'USD/BTC';
btctit = sprintf('Daily %s price',btcy);
staty = 'S&P500';
stattit = sprintf('Daily %s close',staty);
lnbtcy = sprintf('Ln(%s)',btcy);
lnstaty = sprintf('Ln(%s)',staty);
title({sprintf('%s and %s',btctit,stattit);...
    '\it\fontsize{10}github.com/toadlyBroodle/bitcoin-analysis/'})

ax1.YAxis.Color = 'b';
ylabel(lnbtcy)
ax1.XTickLabels = [];

% plot S&P data on seperate axis
ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','Color','none');
ax2.YAxis.Color = 'r';
ax2.XLim = [2009,2019.1];

hold on;

plot(time,lnstats,'r');
%plot(timepastfut,fitpolybtcext,'p--','LineWidth',2);

ylabel(lnstaty)

% inset linear plot
ax3 = axes('Position',[.68 .14 .25 .25],...
    'XAxisLocation','top','YAxisLocation','left',...
    'YScale','linear');

hold on;

plot(timebtc,btc,'b');
plot(time,stats,'r');
%plot(timeExt,fitExpExt,'g--','LineWidth',2);
%plot(timeExt,expfitPolyExt,'r--','LineWidth',2);

ax3.XTick = [];
ylabel(ax3,'USD$');
yticklabels({'0','10000','20000'})
legend(btcy,staty);



%ax3.XLim = [minTime maxTime];
%ax3.YLim = [min(stats(:)) max(stats(:))];

end