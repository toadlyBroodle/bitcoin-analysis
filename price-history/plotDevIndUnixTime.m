function [ ] = plotDevIndUnixTime( wldbnkdevind )

% Prepare arrays and tables of times and prices
di_mobcell = [wldbnkdevind{1,21:57}',wldbnkdevind{2,21:57}'];
di_intusers = [wldbnkdevind{1,34:57}',wldbnkdevind{4,34:57}'];
di_brdbnd = [wldbnkdevind{1,42:57}',wldbnkdevind{5,42:57}'];

percmob = di_mobcell(:,2);
percint = di_intusers(:,2);
percbrd = di_brdbnd(:,2);

yearmob = di_mobcell(:,1);
yearint = di_intusers(:,1);
yearbrd = di_brdbnd(:,1);

datemob = datetime(yearmob,12,31); % set dates to year ends
dateint = datetime(yearint,12,31);
datebrd = datetime(yearbrd,12,31);

timemob = posixtime(datemob);
timeint = posixtime(dateint);
timebrd = posixtime(datebrd);

mobexpsubtime2001 = timemob(1:22);
mobexpsubtime2011 = timemob(1:29);
mobexpsubperc2001 = percmob(1:22);
mobexpsubperc2011 = percmob(1:29);

% mob exp subset (to 2001) fit coefs: 
a = 6.865e-05;  
b = 1.227e-08;
%a11 = 5.923e-04;
%b11 = 9.903e-09;
mobexp2001fit = a*exp(b*mobexpsubtime2001);
mobexp2001fitExtrpd = a*exp(b*mobexpsubtime2011);

% Plot world bank development indicators figure
figure(2)
hold on
grid on

ax1 = gca; % current axes
ax1.YScale = 'log';
%xmax1 = max(timemob(:));
%xmin1 = min(timemob(:));
%ax1.XLim = [xmin1,xmax1];

plot(timemob,percmob,'b','LineWidth',2);
plot(mobexpsubtime2001,mobexp2001fit,'r','LineWidth',2);
plot(mobexpsubtime2011,mobexp2001fitExtrpd,'r--','LineWidth',2);
plot(timeint,percint,'m','LineWidth',2);
plot(timebrd,percbrd,'g','LineWidth',2);


title('World bank development indicators data, logarithmic scale')
xlabel('Unix timestamp, seconds since epoch')
ylabel('Percent of world population, %')
legend('Mobile cellular subscriptions','Mobile cellular exponential fit to 2001',sprintf('y=%.3e*exp(%.3e*x)',a,b),'Internet users','Fixed broadband subscriptions');

% axis for years
ax2 = axes('Position',[.2 .88 .63 1e-12],'XAxisLocation','top','Color','none');
xmax2 = max(2015);
xmin2 = min(yearmob(:));
ax2.XLim = [xmin2,xmax2];
end