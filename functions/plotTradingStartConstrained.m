function [ ] = plotTradingStartConstrained( btcusdavgprice )

timeOfBitstamp = 1.316e+09;
minTime = 0;
maxTime = 1.55e+09 - timeOfBitstamp;

% Prepare arrays and tables of times and prices
price = btcusdavgprice{:,2};
lnPrice = log(price);
time = btcusdavgprice{:,1};
timeNorm(:,1) = time(:,1) - timeOfBitstamp;
timeExt = linspace(minTime, maxTime,20);

% coefficients derived from curve fitting tool, i.e.:
    % y(x)=exp(b*x), ln(x)=p1*b + 1
b = 4.588e-08;
p1 = 3.902E-08;

fitExpExt = exp(b*timeExt);
fitPolyExt = p1*timeExt+1;

% Plot daily price chart
figure(2)
hold on
grid on

ax = gca;
xlim([minTime maxTime]);

plot(timeNorm,lnPrice,'b');
plot(timeExt,fitPolyExt,'r--','LineWidth',2);

title({'Daily averaged Bitstamp Bitcoin trading price:';'poly1 and exp1 fits constrained through $USD1 at start of trading'})
xlabel('Time since start of Bitstamp trading, [seconds]')
ylabel('Ln(Bitcoin price, [USD/BTC])')
legend('Ln(USD/BTC)',...
    sprintf('Constrained poly1 fit: ln(y)=%.3e*x+1,\nwhere x=0 at %.3e Unix timestamp',p1,timeOfBitstamp));

% axis for years
ax2 = axes('Position',[ax.Position(1) .88 ax.Position(3) 1e-12],'XAxisLocation','top','Color','none');
ax2.XLim = [2009 2019.1];

% inset linear plot
ax3 = axes('Position',[.66 .14 .25 .25],...
    'XAxisLocation','top','YAxisLocation','left',...
    'YScale','linear');

hold on;
plot(timeNorm,price,'m');
plot(timeExt,fitExpExt,'g--','LineWidth',2);

set(ax3,'XTick',[],'XLabel',[],'YLabel',[],...
    'XLim',[minTime maxTime],'YLim',[min(price(:)) 20000]);

legend('USD/BTC',...
    sprintf('Constrained exp1 fit: y=1*exp(%.3e*x),\nwhere x=0 at %.3e Unix timestamp',b, timeOfBitstamp));

end