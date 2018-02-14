function [ output_args ] = plotTxChart( avgTx, avgUtxo, log_y )

% Prepare arrays and tables of times and prices
txs = avgTx{:,2};
time = avgTx{:,1};
utxos = avgUtxo{:,2};
%utxosTime = avgUtxo{:,1};
timepastfut = linspace(1.23e+9,1.55e+9,20);
date = datetime(time,'ConvertFrom','posixtime');
datepastfut = datetime(timepastfut, 'ConvertFrom', 'posixtime');

% all coefficients derived from curve fitting tool
    % i.e.
    %   fit(time,txs,'exp1')
    %   fit(time,utxos,'exp1')
ta=1.206e-05; % 9.036e-06
tb=1.879e-08; % 1.899e-08
ua=2.043; % 2.043
ub=1.137e-08; % 1.137e-08
txExpFun = ta*exp(tb*time);
txExpFunPastFut = ta*exp(tb*timepastfut);
utxoExpFun = ua*exp(ub*time);
utxoExpFunPastFut = ua*exp(ub*timepastfut);

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

plot(date,txs,'b');
plot(date,utxos,'r');
plot(date,txExpFun,'g');
plot(date,utxoExpFun,'m');
plot(datepastfut,txExpFunPastFut,'g--');
plot(datepastfut,utxoExpFunPastFut,'m--');
title('Fig 3. Daily transaction and UTXO counts, data from satoshi.info')
xlabel('Time, year')
ylabel('Transactions/UTXOs')
%xtickformat('y');
legend('Transactions','UTXOs','Exponential fit of transactions data','Exponential fit of UTXO data');

end