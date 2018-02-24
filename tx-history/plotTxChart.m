function [  ] = plotTxChart( txsacceptedpersecondweekavg )

xblock0 = 1.23e09;

% Prepare arrays and tables of transactions
timetxpersec = txsacceptedpersecondweekavg{:,1};
timeblock0(:,1) = timetxpersec(:,1) - xblock0; 
txperday = txsacceptedpersecondweekavg{:,2} *60*60*24; % convert to tx/day
lntxperday = log(txperday);

timepastfut = linspace(0,1.55e+9-xblock0,20);

% fit data
%fittxperday = fit(timetxpersec,txperday,'exp1');
%extline = fittxperday.a*exp(fittxperday.b*timepastfut(:));
fittxperday = fit(timeblock0,lntxperday,'poly1')
extline = fittxperday.p1*timepastfut(:)+fittxperday.p2;

yblock0 = 1;
fitblock0 = fit(timeblock0,lntxperday,'p1*x+1')
extblock0 = fitblock0.p1*timepastfut(:)+yblock0;

% Plot daily price chart
figure(2)
hold on
grid on

plot(timeblock0,lntxperday,'b');
plot(timepastfut,extline,'r--');
plot(timepastfut,extblock0,'g--');

title('Daily accepted transactions')
xlabel('Time since block0, [seconds]')
ylabel('Natural logarithm of transaction counts, ln(txs)')
%xtickformat('y');
legend('Accepted transactions',...
    sprintf('Poly1 fit of accepted txs: y=%.3e*x+%.3e',fittxperday.p1,fittxperday.p2),...
    sprintf('Block0 constrained poly1 fit: y=%.3e*x',fitblock0.p1));

%datepastfut = datetime(timepastfut, 'ConvertFrom', 'posixtime');


end