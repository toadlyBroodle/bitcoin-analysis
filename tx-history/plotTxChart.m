function [ output_args ] = plotTxChart( txmempool, txpersec, log_y )

% Prepare arrays and tables of times and prices
tmempool = txmempool{:,1};
cmempool = txmempool{:,2};
tpersec = txpersec{:,1};
cperday = txpersec{:,2} *60*60*24; % convert to tx/day

timepastfut = linspace(1.23e+9,1.55e+9,80);
datepastfut = datetime(timepastfut, 'ConvertFrom', 'posixtime');

% all coefficients derived from curve fitting tool
    % i.e.
    %   fit(time,txs,'exp1')
    %   fit(time,utxos,'exp1')
ma = 5.57e-10;
mb = 2.113e-08;
pa = 2.303e-06 *60*60*24;
pb = 9.332e-09;
fit1 = ma*exp(mb*tmempool);
fit1f = ma*exp(mb*timepastfut);
fit2 = pa*exp(pb*tpersec);
fit2f = pa*exp(pb*timepastfut);

% Plot daily price chart
figure(2)
hold on
grid on
% linear or log y-axis?
if (log_y)
    set(gca, 'YScale', 'log');
    %ylim([1 50000])
else
    %xlim([1.45e+9 1.55e+9]);
end

plot(tmempool,cmempool,'b','LineWidth',2);
plot(tmempool,fit1,'r--','LineWidth',2);
plot(tpersec,cperday,'m','LineWidth',2);
plot(tpersec,fit2,'g--','LineWidth',2);

title('Daily transactions in mempool and accepted transactions, data from statoshi.info')
xlabel('Unix timestamp, seconds since epoch')
ylabel('Transaction counts')
%xtickformat('y');
legend('Transactions in mempool',sprintf('Exponential fit of mempool txs: y=%.3e*exp(%.3e*x)',ma,mb),'Accepted transactions',sprintf('Exponential fit of accepted txs: y=%.3e*exp(%.3e*x)',pa,pb));

end