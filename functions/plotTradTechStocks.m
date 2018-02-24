function [ ] = plotTradTechStocks( IBM, MSFT, AAPL, AMZN, GOOG)

% Prepare arrays and tables of times and prices
aplDate = AAPL{:,1};
amzDate = AMZN{:,1};
gooDate = GOOG{:,1};
ibmDate = IBM{:,1};
msfDate = MSFT{:,1};
aplPrice = AAPL{:,2};
amzPrice = AMZN{:,2};
gooPrice = GOOG{:,2};
ibmPrice = IBM{:,2};
msfPrice = MSFT{:,2};
lnApl = log(aplPrice);
lnAmz = log(amzPrice);
lnGoo = log(gooPrice);
lnIbm = log(ibmPrice);
lnMsf = log(msfPrice);
aplTime = posixtime(aplDate);
amzTime = posixtime(amzDate);
gooTime = posixtime(gooDate);
ibmTime = posixtime(ibmDate);
msfTime = posixtime(msfDate);

minTime = min(ibmTime(:));
maxTime = max(ibmTime(:));

% prepare data fits
aplFit = fit(aplTime,aplPrice,'exp1');
amzFit = fit(amzTime,amzPrice,'exp1');
gooFit = fit(gooTime,gooPrice,'exp1');
ibmFit = fit(ibmTime,ibmPrice,'exp1');
msfFit = fit(msfTime,msfPrice,'exp1');

% Plot daily price chart
figure(2)
hold on
grid on

ax = gca;
ax.YScale = 'log';
xlim([minTime maxTime]);
ylim([.1 2000]);

plot(ibmFit,'c--',ibmTime,ibmPrice,'c');
plot(msfFit,'b--',msfTime,msfPrice,'b');
plot(aplFit,'m--',aplTime,aplPrice,'m');
plot(amzFit,'g--',amzTime,amzPrice,'g');
plot(gooFit,'r--',gooTime,gooPrice,'r');

title('Average weekly corporate tech stock trading prices')
xlabel('Unix timestamp, seconds since epoch')
ylabel('Trading price, USD')
legend('IBM',sprintf('y=%.3e*exp(%.3e*x)',ibmFit.a,ibmFit.b),...
    'MSFT',sprintf('y=%.3e*exp(%.3e*x)',msfFit.a,msfFit.b),...
    'AAPL',sprintf('y=%.3e*exp(%.3e*x)',aplFit.a,aplFit.b),...
    'AMZN',sprintf('y=%.3e*exp(%.3e*x)',amzFit.a,amzFit.b),...
    'GOOG',sprintf('y=%.3e*exp(%.3e*x)',gooFit.a,gooFit.b));

% axis for years
ax2 = axes('Position',[ax.Position(1) .88 ax.Position(3) 1e-12],...
    'XAxisLocation','top',...
    'XLim',[1962,2018],...
    'Color','none');

% inset linear plot
ax3 = axes('Position',[.77 .14 .15 .15],...
    'XAxisLocation','top','YAxisLocation','right',...
    'YScale','linear');

hold on;
plot(ibmTime,ibmPrice,'c');
plot(msfTime,msfPrice,'b');
plot(aplTime,aplPrice,'m');
plot(amzTime,amzPrice,'g');
plot(gooTime,gooPrice,'r');

set(ax3,'XTick',[],'YTick',[],'XLabel',[],'YLabel',[],...
    'XLim',[minTime maxTime],'YLim',[min(ibmPrice(:)) max(gooPrice(:))]);
%title('Linear plot','FontWeight','normal','FontSize',10);
end