function [  ] = plotBlockchainStats( statsfile )

minTime = 1.23e+09;
maxTime = 1.55e+09;

% Prepare stats arrays
time = statsfile{:,1};
stats = statsfile{:,2};
lnstats = log(stats);

timepastfut = linspace(minTime,maxTime,20);

% fit data
fitexp = fit(time,stats,'exp1');
fitexpext = fitexp.a*exp(fitexp.b*timepastfut(:));
lnfitexpext = log(fitexpext);
fitpoly = fit(time,lnstats,'poly1');
fitpolyext = fitpoly.p1*timepastfut(:)+fitpoly.p2;
expfitpolyext = exp(fitpolyext);

% Plot daily price chart
figure(2)
hold on
grid on
ax = gca;

xlim([minTime maxTime]);
ylim([min(lnstats(:)) max(lnstats(:))]);

plot(time,lnstats,'b');
plot(timepastfut,lnfitexpext,'g--','LineWidth',2);
plot(timepastfut,fitpolyext,'r--','LineWidth',2);

% uncomment respective titles
%stattit = 'daily Bitcoin days destroyed (BDD)';
%staty = 'BDD';
%stattit = 'daily cumulative Bitcoin block size';
%staty = 'Cumulative block size, [bytes]';
%stattit = 'daily cumulative Bitcoin mining fees';
%staty = 'Mining fees, [Satoshis]';
%stattit = 'daily Bitcoin payments estimate';
%staty = 'Payments (estimate)';
%stattit = 'daily total Bitcoin addresses';
%staty = 'Total addresses';
%stattit = 'daily accepted Bitcoin transactions';
%staty = 'Accepted transactions';
%stattit = 'total Bitcoin UTXOs';
%staty = 'Total UTXOs';
stattit = 'daily new Bitcoin addresses';
staty = 'New addresses';
%stattit = 'daily BTC value transferred';
%staty = 'BTC transferred, [Satoshis]';

lnstaty = sprintf('Ln(%s)',staty);

title({sprintf('Weekly averaged %s',stattit);'with exp1 and poly1 best fits'})
ylabel(lnstaty)
xlabel('Unix timestamp, [seconds]')
%xtickformat('y');
legend(staty,...
    sprintf('Exp1 fit: y=%.3e*exp(%.3e*x)',fitexp.a,fitexp.b),...
    sprintf('Poly1 fit: ln(y)=%.3e*x+(%.3e)',fitpoly.p1,fitpoly.p2));

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

plot(time,stats,'b');
plot(timepastfut,fitexpext,'g--','LineWidth',2);
plot(timepastfut,expfitpolyext,'r--','LineWidth',2);

ylabel(ax3,staty);
ax3.XTick = [];
ax3.XLabel = [];
ax3.XLim = [minTime maxTime];
ax3.YLim = [min(stats(:)) max(stats(:))];

end