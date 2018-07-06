function [ ] = plotGooTrendsPrice( btcusdavgprice, gootrendbtc, gootrendbuybtc )



% Prepare arrays and tables of times and prices
time = btcusdavgprice{:,1};
price = btcusdavgprice{:,2};
lnprice = log(price);

minPrice = min(price(:));
maxPrice = max(price(:));
minTime = time(1);
maxTime = 1.55e+09;

timeExt = linspace(minTime,maxTime,20);

fitExp = fit(time,price,'exp1');
fitExpExt = fitExp.a*exp(fitExp.b*timeExt(:));
lnfitExpExt = log(fitExpExt);
fitPoly = fit(time,lnprice,'poly1');
fitPolyExt = fitPoly.p1*timeExt+fitPoly.p2;
expfitPolyExt = exp(fitPolyExt);

% Plot daily price chart
figure(2)
hold on
grid on

ax = gca;
ylim([min(lnprice(:)) 11]);
xlim([minTime maxTime]);

plot(time,lnprice,'b');
plot(timeExt,lnfitExpExt,'g--','LineWidth',2);
plot(timeExt,fitPolyExt,'r--','LineWidth',2);

title({'Daily averaged Bitstamp Bitcoin trading price:';...
    'full and partial (to Jul-2017) unconstrained exp1 and poly1 fits'});
    %'partial (to Jul-2017) unconstrained exp1 and poly1 fits'});
xlabel('Unix timestamp, [seconds]')
ylabel('Ln(Bitcoin price, [USD/BTC])')
legend('Daily averaged Bitstamp price',...
    sprintf('Exp1 fit: y=%.3e*exp(%.3e*x)',fitExp.a,fitExp.b),...
    sprintf('Poly1 fit: ln(y)=%.3e*x+(%.3e)',fitPoly.p1,fitPoly.p2),...

% axis for years
ax2 = axes('Position',[ax.Position(1) .88 ax.Position(3) 1e-12],...
    'XAxisLocation','top',...
    'XLim',[2011.75,2019.1],...
    'Color','none');

% inset linear plot
ax3 = axes('Position',[.66 .14 .25 .25],...
    'XAxisLocation','top','YAxisLocation','left',...
    'YScale','linear');

hold on;
grid on;
plot(time,price,'b');
plot(timeExt,fitExpExt,'g--','LineWidth',2);
plot(timeExt,expfitPolyExt,'r--','LineWidth',2);

set(ax3,'XTick',[],'XLabel',[],...
    'XLim',[minTime maxTime],'YLim',[minPrice 20000]);

ylabel(ax3,'Bitcoin price, [USD/BTC]');

end