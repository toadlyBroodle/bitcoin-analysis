function [ output_args ] = plotUtxoChart( txstotalwithunspentoutputsdayavg, utxocounthistorydayavg, log_y )

% Prepare arrays and tables of times and prices
timetxwithutxo = txstotalwithunspentoutputsdayavg{:,1};
txwithutxo = txstotalwithunspentoutputsdayavg{:,2};
timeutxo = utxocounthistorydayavg{:,1};
utxo = utxocounthistorydayavg{:,2};

lntxwithutxo = log(txwithutxo);
lnutxo = log(utxo);

timepastfut = linspace(1.23e+9,1.55e+9,80);
datepastfut = datetime(timepastfut, 'ConvertFrom', 'posixtime');

% all coefficients derived from curve fitting tool
    % i.e.
    %   fit(time,txs,'exp1')
    %   fit(time,utxos,'exp1')  
wa=1.617e-05; % 9.036e-06, 1.206e-05
wb=1.86e-08; % 1.899e-08
ua=2.411; % 2.043
ub=1.125e-08; % 1.137e-08
fit1 = wa*exp(wb*timetxwithutxo);
fit1f = wa*exp(wb*timepastfut);
fit2 = ua*exp(ub*timeutxo);
fit2f = ua*exp(ub*timepastfut);

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

plot(timetxwithutxo,txwithutxo,'m','LineWidth',2);
plot(timetxwithutxo,fit1,'r--','LineWidth',2);
%plot(timepastfut,fit1f,'r--','LineWidth',2);
plot(timeutxo,utxo,'g','LineWidth',2);
plot(timeutxo,fit2,'b--','LineWidth',2);
%plot(timepastfut,fit2f,'b--','LineWidth',2);

title('Daily transactions with UTXOs and UTXO counts, data from statoshi.info')
xlabel('Unix timestamp, seconds since epoch')
ylabel('Transactions/UTXOs')
legend('Transactions with UTXOs',sprintf('Exponential fit of transactions with UTXOs: y=%.3e*exp(%.3e*x)',wa,wb),'UTXOs',sprintf('Exponential fit of UTXOs: y=%.3e*exp(%.3e*x)',ua,ub));

end