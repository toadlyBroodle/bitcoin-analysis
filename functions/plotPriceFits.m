function [ ] = plotPriceFits( btcusdavgprice )

genTime = 1.231e+09; % Genesis block time
SPY = 60*60*24*365;

% Prepare arrays and tables of times and prices
time = btcusdavgprice{:,1};
price = btcusdavgprice{:,2};
lgprice = log(price);

minPrice = min(price(:));
maxPrice = max(price(:));
minTime = time(1);
maxTime = 1.61e+09;
timeExt = linspace(minTime,maxTime,20);

minDate = datetime(minTime,'ConvertFrom','posixtime');
maxDate = datetime(maxTime,'ConvertFrom','posixtime');

[fitExp,gdnessExp] = fit(time,price,'exp1');
fitExpExt = fitExp.a*exp(fitExp.b*timeExt(:));
lgfitExpExt = log(fitExpExt);
[fitPoly,gdnessPoly] = fit(time,lgprice,'poly1');
fitPolyExt = fitPoly.p1*timeExt+fitPoly.p2;
expfitPolyExt = exp(fitPolyExt);

% Plot daily price chart
figure(2)
hold on
grid on

ax = gca;
ylim([min(lgprice(:)) 11]);
xlim([minTime maxTime]);

plot(time,lgprice,'b');
plot(timeExt,lgfitExpExt,'g--','LineWidth',2);
plot(timeExt,fitPolyExt,'r--','LineWidth',2);

title({'Daily averaged Bitstamp Bitcoin trading price:';...
    'exponential and polynomial fits';...
    '\it\fontsize{10}github.com/toadlyBroodle/bitcoin-analysis/'});
xlabel('Unix timestamp, [seconds]')
ylabel('Ln(Bitcoin price, [USD/BTC])')
legend('Average daily Bitcoin price',...
    sprintf('Exp1 fit: y=%.3e*exp(%.3e*x); Growth: %.0f%%/year, R^2: %.2f',fitExp.a,fitExp.b,fitExp.b*SPY*100,gdnessExp.rsquare),...
    sprintf('Poly1 fit: ln(y)=%.3e*x+(%.3e); Growth: %.0f%%/year, R^2: %.2f',fitPoly.p1,fitPoly.p2,fitPoly.p1*SPY*100,gdnessPoly.rsquare));

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