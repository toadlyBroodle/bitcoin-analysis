function [ ] = plotDevIndUnixTime( wldbnkdevind )

% Prepare arrays and tables of times and prices
di_mobcell = [wldbnkdevind{1,21:57}',wldbnkdevind{2,21:57}'];
di_intusers = [wldbnkdevind{1,34:57}',wldbnkdevind{4,34:57}'];
di_brdbnd = [wldbnkdevind{1,42:57}',wldbnkdevind{5,42:57}'];

percmob = di_mobcell(:,2);
percint = di_intusers(:,2);
percbrd = di_brdbnd(:,2);

lnPercMob = log(percmob);
lnPercInt = log(percint);
lnPercBrd = log(percbrd);

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

mobexpsubtime2001 = timemob(1:22);
%mobexpsubtime2011 = timemob(1:29);
mobexpsubperc2001 = percmob(1:22);
%mobexpsubperc2011 = percmob(1:29);
lnPerc2001 = log(mobexpsubperc2001);

fitmob2001 = fit(mobexpsubtime2001,mobexpsubperc2001,'exp1');
%fitmob2011 = fit(mobexpsubtime2011,mobexpsubperc2011,'exp1');

% Plot world bank development indicators figure
figure(2)
hold on
grid on

ax1 = gca; % current axes
ax1.YScale = 'log';
xmax1 = max(timemob(:));
xmin1 = min(timemob(:));
ax1.XLim = [xmin1,xmax1];

plot(fitmob2001,'b--',timemob,percmob,'b');
%plot(fitmob2011,'b:');
plot(timeint,percint,'m');
plot(timebrd,percbrd,'g');


title('World bank development indicators, global telecoms penetration')
xlabel('Unix timestamp, seconds since epoch')
ylabel('Percent of world population, %')
legend('Mobile cellular subscriptions',sprintf('y=%.3e*exp(%.3e*x)',fitmob2001.a,fitmob2001.b),'Internet users','Fixed broadband subscriptions');

% axis for years
ax2 = axes('Position',[ax1.Position(1) .88 ax1.Position(3) 1e-12],'XAxisLocation','top','Color','none');
ax2.XLim = [min(yearmob(:)),max(yearmob(:))];

% inset linear plot
ax3 = axes('Position',[.66 .14 .25 .25],...
    'XAxisLocation','top','YAxisLocation','right',...
    'YScale','linear');

hold on;
plot(fitmob2001,'b--',timemob,percmob,'b');
plot(timeint,percint,'m');
plot(timebrd,percbrd,'g');

set(ax3,'XTick',[],'YTick',[],'XLabel',[],'YLabel',[],...
    'XLim',[xmin1 xmax1],'YLim',[min(percmob(:)) max(percmob(:))]);
end