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
fitpoly = fit(time,lnstats,'poly1');
fitpolyext = fitpoly.p1*timepastfut(:)+fitpoly.p2;

% Plot daily price chart
figure(2)
hold on
grid on
ax = gca;

xlim([minTime maxTime]);
ylim([min(lnstats(:)) max(lnstats(:))]);

plot(time,lnstats,'b');
plot(timepastfut,fitpolyext,'r--','LineWidth',2);

% uncomment respective titles
%stattit = 'Bitcoin days destroyed (BDD)';
%statx = 'Ln(BDD)';
%stattit = 'Bitcoin block size';
%statx = 'Ln(block size, [bytes]),';
%stattit = 'total Bitcoin addresses';
%statx = 'Ln(total addresses)';
%stattit = 'accepted Bitcoin transactions';
%statx = 'Ln(accepted transactions)';
%stattit = 'Bitcoin UTXOs';
%statx = 'Ln(UTXOs)';
stattit = 'new Bitcoin addresses';
statx = 'Ln(new addresses)';

title(sprintf('Weekly averaged %s with exp1 and poly1 best fits',stattit))
ylabel(statx)
xlabel('Unix timestamp, [seconds]')
%xtickformat('y');
legend(statx,...
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

plot(time,stats,'m');
plot(timepastfut,fitexpext,'g--','LineWidth',2);

set(ax3,'XTick',[],'XLabel',[],'YLabel',[],...
    'XLim',[minTime maxTime],'YLim',[min(stats(:)) max(stats(:))]);

legend(stattit,...
    sprintf('Exp1 fit: y=%.3e*exp(%.3e*x)',fitexp.a,fitexp.b));


end