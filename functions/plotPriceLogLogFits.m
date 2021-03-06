function [ ] = plotPriceLogLogFits( btcusdavgprice )

SPY = 60*60*24*365;

% Prepare arrays and tables of times and prices
time = btcusdavgprice{:,1};
%date = datetime(time,'ConvertFrom','posixtime');
price = btcusdavgprice{:,2};

minPrice = min(price(:));
maxPrice = max(20000);
%genTime = 1.231e+09; % Genesis block, posix timestamp
minTime = min(time);
maxTime = 1.61e+09; % Jun 1, 2020

timeExt = linspace(minTime,maxTime,200);
dateExt = datetime(timeExt,'ConvertFrom','posixtime');

[fitExp,gdnessExp] = fit(time,price,'exp1');
fitExpExt = fitExp.a*exp(fitExp.b*timeExt);
%[fitPoly,gdnessPoly] = fit(time,lnprice,'poly1');
%fitPolyExt = fitPoly.p1*timeExt(:) + fitPoly.p2;

growPercPerYr = fitExp.b*SPY*100

% Plot daily price chart
figure(2)
hold on
grid on

ax = gca;
ax.XLim = [minTime maxTime];
ax.YLim = [minPrice maxPrice];
ax.YScale = 'log';

plot(time,price,'b');
plot(timeExt,fitExpExt,'r--','LineWidth',2);
%plot(timeExt,fitPolyExt,'g--','LineWidth',2);

% draw halvings
line([1.33e+09 1.33e+09],[minPrice maxPrice],'color','yellow');
line([1.468e+09 1.468e+09],[minPrice maxPrice],'color','yellow');
line([1.589e+09 1.589e+09],[minPrice maxPrice],'color','yellow');

title({'Bitcoin price growth: buy below trend, sell above';...
    '\it\fontsize{10}github.com/toadlyBroodle/bitcoin-analysis/'});
xlabel('Posix timestamp [seconds]')
ylabel('Bitcoin price [USD/BTC]')
legend('Daily averaged USD/BTC',...
    sprintf('Exponential best fit: y=%.2e*exp(x)+%.2e; Growth: %.0f%%/yr; R^2: %.2f',fitExp.a,fitExp.b,growPercPerYr,gdnessExp.rsquare),...
    'Block reward halvings');

% inset linear plot
ax3 = axes('Position',[.66 .14 .25 .25],...
    'XAxisLocation','top','YAxisLocation','left',...
    'YScale','linear');

hold on;
grid on;
plot(time,price,'b');
plot(timeExt,fitExpExt,'r--','LineWidth',2);
%plot(timeExt,fitPolyExt,'g--','LineWidth',2);

set(ax3,'XTick',[],'XLabel',[],...
    'XLim',[minTime maxTime],'YLim',[minPrice maxPrice]);

ylabel(ax3,'[USD/BTC]');
end