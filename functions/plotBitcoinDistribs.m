function [  ] = plotBitcoinDistribs( statsfile )

minTime = 1.23e+09;
maxTime = 1.55e+09;

% Prepare stats arrays
time = statsfile{:,1};
lessbtc = statsfile{:,2};
morebtc = statsfile{:,3};
lnless = log(lessbtc);
lnmore = log(morebtc);

timepastfut = linspace(minTime,maxTime,20);

% fit data
fitlessexp = fit(time,lessbtc,'exp1');
fitlessexpext = fitlessexp.a*exp(fitlessexp.b*timepastfut(:));
lnfitlessexpext = log(fitlessexpext);

fitmoreexp = fit(time,morebtc,'exp1');
fitmoreexpext = fitmoreexp.a*exp(fitmoreexp.b*timepastfut(:));
lnfitmoreexpext = log(fitmoreexpext);

% Plot daily charts
figure(2)
hold on
grid on
ax = gca;

xlim([minTime maxTime]);
ylim([min(lnless(:)) max(lnless(:)) + 1]); % add padding to top y-axis for timeline

plot(time,lnless,'b');
plot(timepastfut,lnfitlessexpext,'g--','LineWidth',2);

plot(time,lnmore,'m');
plot(timepastfut,lnfitmoreexpext,'r--','LineWidth',2);


% uncomment appropriately
%stattit = 'daily Bitcoin address balance distributions';
%staty = 'BABD';
%statyless = 'addresses with balance <1BTC';
%statymore = 'addresses with balance >=1BTC';
stattit = 'daily Bitcoin UTXO volume distributions';
staty = 'BUVD';
statyless = 'UTXOs with amounts <1BTC';
statymore = 'UTXOs with amounts >=1BTC';

lnstaty = sprintf('Ln(%s)',staty);

title({sprintf('Weekly averaged %s',stattit);...
    'with exp1 best fits to July 12, 2018';...
    '\it\fontsize{10}github.com/toadlyBroodle/bitcoin-analysis/'})
ylabel(lnstaty)
xlabel('Unix timestamp, [seconds]')
%xtickformat('y');
legend(statyless,...
    sprintf('Exp1 fit: y=%.3e*exp(%.3e*x); Growth: %.0f%%/year',fitlessexp.a,fitlessexp.b, fitlessexp.b*60*60*24*365*100),...
    statymore,...
    sprintf('Exp1 fit: y=%.3e*exp(%.3e*x); Growth: %.0f%%/year',fitmoreexp.a,fitmoreexp.b, fitmoreexp.b*60*60*24*365*100));

% axis for years
ax2 = axes('Position',[ax.Position(1) .88 ax.Position(3) 1e-12],...
    'XAxisLocation','top',...
    'Color','none');
ax2.XLim = [2009,2019.1];

% inset linear plot
ax3 = axes('Position',[.66 .14 .25 .25],...
    'XAxisLocation','top','YAxisLocation','left',...
    'YScale','linear');

hold on;

plot(time,lessbtc,'b');
plot(time,morebtc,'m');
plot(timepastfut,fitlessexpext,'g--','LineWidth',2);
plot(timepastfut,fitmoreexpext,'r--','LineWidth',2);

ylabel(ax3,staty);
ax3.XTick = [];
ax3.XLabel = [];
ax3.XLim = [minTime maxTime];
ax3.YLim = [min(lessbtc(:)) max(lessbtc(:))];

end