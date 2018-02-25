function [ ] = plotTradingStartConstrained( btcusdavgdayprice )

timeOfBitstamp = 1.316e+09;
minTime = 0;
maxTime = 1.55e+09 - timeOfBitstamp;

% Prepare arrays and tables of times and prices
price = btcusdavgdayprice{:,2};
lnPrice = log(price);
time = btcusdavgdayprice{:,1};
timeExt = linspace(minTime, maxTime,20);

% coefficient derived from curve fitting tool, i.e.:
    % y(x)=exp(b*x) <-- at x=0, a=1
b = 4.588e-08; % 4.459e-08

fitExp = exp(b*timeExt);
fitPoly = fit(time,lnPrice,'poly1');
fitPolyExp = fitPoly.p1*timeExt+fitPoly.p2;

% Plot daily price chart
figure(2)
hold on
grid on

ax = gca;
xlim([minTime maxTime]);

plot(time,lnprice,'b');
plot(timeExt,fitPolyExp,'r--','LineWidth',2);

title('Daily averaged Bitstamp Bitcoin trading price')
xlabel('Unix timestamp, [seconds]')
ylabel('Bitcoin price, [USD/BTC]')
legend('Ln(Bitcoin price, [USD/BTC])',...
    sprintf('Constrained poly1 fit: y=%.3e*x+%.3e, where x=0 at %.3e Unix timestamp',fitPoly.p1,fitPoly.p2,timeOfBitstamp));

% axis for years
ax2 = axes('Position',[ax.Position(1) .88 ax.Position(3) 1e-12],'XAxisLocation','top','Color','none');
ax2.XLim = [datetime(1.23e09,'ConvertFrom','posixtime'),datetime(1.55e09,'ConvertFrom','posixtime')];

% inset linear plot
ax3 = axes('Position',[.66 .14 .25 .25],...
    'XAxisLocation','top','YAxisLocation','left',...
    'YScale','linear');

hold on;
plot(time,price,'m');
plot(timeExt,fitExp,'g--','LineWidth',2);

set(ax3,'XTick',[],'XLabel',[],'YLabel',[],...
    'XLim',[minTime maxTime],'YLim',[min(price(:)) max(price(:))]);

legend('Daily averaged Bitstamp trades',sprintf('Constrained exp1 fit: y=exp(%.3e*x), where x=0 at %.3e Unix timestamp',b, timeOfBitstamp));

end