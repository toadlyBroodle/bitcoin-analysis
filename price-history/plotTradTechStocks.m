function [ ] = plotTradTechStocks( IBM, MSFT, AAPL, GOOG)

% Prepare arrays and tables of times and prices
aplDate = AAPL{:,1};
aplPrice = AAPL{:,2};
gooDate = GOOG{:,1};
gooPrice = GOOG{:,2};
ibmDate = IBM{:,1};
ibmPrice = IBM{:,2};
msfDate = MSFT{:,1};
msfPrice = MSFT{:,2};
lnApl = log(aplPrice);
lnGoo = log(gooPrice);
lnIbm = log(ibmPrice);
lnMsf = log(msfPrice);
aplTime = posixtime(aplDate);
gooTime = posixtime(gooDate);
ibmTime = posixtime(ibmDate);
msfTime = posixtime(msfDate);

%aplPriceStart = aplPrice(1);
%aplTimeNorm = aplTime(:) - aplTime(1) + 1;

minTime = min(ibmTime(:));
maxTime = max(ibmTime(:));

%aplFun = @(x,aplTimeNorm)aplPriceStart*exp(x(1)*aplTimeNorm);

%aplFitEq = sprintf('%.3e*exp(b*x)',aplPriceStart);
%aplFitOp = fitoptions('Method', 'NonLinearLeastSquares','StartPoint',5.05e-08,'Lower',1e-10,'Upper',1e-07);
%a = lsqcurvefit(aplFun,[0,0],aplTimeNorm,aplPrice)
%aplFit = fit(aplTimeNorm,aplPrice,aplFitEq,aplFitOp);

% prepare data fits
aplFit = fit(aplTime,aplPrice,'exp1');
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

plot(ibmFit,'b--',ibmTime,ibmPrice,'b');
plot(msfFit,'m--',msfTime,msfPrice,'m');
plot(aplFit,'r--',aplTime,aplPrice,'r');
%plot(aplTime,aplPrice,aplFun(a,aplTimeNorm));
plot(gooFit,'g--',gooTime,gooPrice,'g');

title('Average weekly corporate tech stock trading prices')
xlabel('Unix timestamp, seconds since epoch')
ylabel('Trading price, USD')
legend('IBM',sprintf('y=%.3e*exp(%.3e*x)',ibmFit.a,ibmFit.b),...
    'MSFT',sprintf('y=%.3e*exp(%.3e*x)',msfFit.a,msfFit.b),...
    'AAPL',sprintf('y=%.3e*exp(%.3e*x)',aplPriceStart,aplFit.b),...
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
plot(ibmTime,ibmPrice,'b');
plot(msfTime,msfPrice,'m');
plot(aplTime,aplPrice,'r');
plot(gooTime,gooPrice,'g');

set(ax3,'XTick',[],'YTick',[],'XLabel',[],'YLabel',[],...
    'XLim',[minTime maxTime],'YLim',[min(ibmPrice(:)) max(gooPrice(:))]);
%title('Linear plot','FontWeight','normal','FontSize',10);
end