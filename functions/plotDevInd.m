function [ ] = plotDevInd( wldbnkdevind )

% Prepare arrays and tables of times and prices
di_mobcell = [wldbnkdevind{1,21:57}',wldbnkdevind{2,21:57}'];
di_intusers = [wldbnkdevind{1,34:57}',wldbnkdevind{4,34:57}'];
di_brdbnd = [wldbnkdevind{1,42:57}',wldbnkdevind{5,42:57}'];

percmob = di_mobcell(:,2);
percint = di_intusers(:,2);
percbrd = di_brdbnd(:,2);

lnpercmob = log(percmob);
lnpercint = log(percint);
lnpercbrd = log(percbrd);

yearmob = di_mobcell(:,1);
yearint = di_intusers(:,1);
yearbrd = di_brdbnd(:,1);

datemob = datetime(yearmob,12,31); % set dates to year ends
dateint = datetime(yearint,12,31);
datebrd = datetime(yearbrd,12,31);

%secsperyear = 60*60*24*365;
timemob = posixtime(datemob);
timeint = posixtime(dateint);
timebrd = posixtime(datebrd);

mobsubtime2001 = timemob(1:22);
mobsubperc2001 = percmob(1:22);
lnmobsubperc2001 = log(mobsubperc2001);

fitmobexp2001 = fit(mobsubtime2001,mobsubperc2001,'exp1');
fitmobexpext2001 = fitmobexp2001.a*exp(fitmobexp2001.b*timemob);
fitmobpoly2001 = fit(mobsubtime2001,lnmobsubperc2001,'poly1');
fitmobpolyext2001 = fitmobpoly2001.p1*timemob+fitmobpoly2001.p2;

% Plot world bank development indicators figure
figure(2)
hold on
grid on

ax1 = gca; % current axes
xmax1 = max(timemob(:));
xmin1 = min(timemob(:));
ax1.XLim = [xmin1,xmax1];
ax1.YLim = [min(lnpercmob(:)) max(lnpercmob(:))];

plot(timemob,lnpercmob,'b');
plot(timemob,fitmobpolyext2001,'b--','LineWidth',2);
plot(timeint,lnpercint,'m');
plot(timebrd,lnpercbrd,'g');


title({'World bank development indicators:';'global telecoms penetration and early mobile cellular growth exp1 and poly1 fits'})
xlabel('Unix timestamp, [seconds]')
ylabel('Ln(percent of world population, [%])')
legend('Ln(mobile cellular subscriptions)',...
    sprintf('Poly1 fit to 2001: ln(y)=%.3e*x+(%.3e)',fitmobpoly2001.p1,fitmobpoly2001.p2),...
    'Ln(Internet users)',...
    'Ln(fixed broadband subscriptions)');

% axis for years
ax2 = axes('Position',[ax1.Position(1) .88 ax1.Position(3) 1e-12],...
    'XAxisLocation','top',...
    'Color','none');
ax2.XLim = [min(yearmob(:)),max(yearmob(:))];

% inset linear plot
ax3 = axes('Position',[.66 .14 .25 .25],...
    'XAxisLocation','top','YAxisLocation','left',...
    'YScale','linear');

hold on;
plot(timemob,percmob,'c');
plot(timemob,fitmobexpext2001,'c--','LineWidth',2);
plot(timeint,percint,'m');
plot(timebrd,percbrd,'g');

set(ax3,'XTick',[],'XLabel',[],'YLabel',[],...
    'XLim',[xmin1 xmax1],'YLim',[min(percmob(:)) max(percmob(:))]);

legend('Mobile cellular subscriptions',...
    sprintf('Exp1 fit to 2001: y=%.3e*exp(%.3e*x)',fitmobexp2001.a,fitmobexp2001.b),...
    'Internet users',...
    'Fixed broadband subscriptions');

end