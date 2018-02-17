function [ ] = plotPizzaTimeLog( avgPrice )

timeOfPizza = 1.274e+09;

% Prepare arrays and tables of times and prices
price = avgPrice{:,2};
time = avgPrice{:,1};
timeFromPizza(:,1) = time(:,1) - timeOfPizza;
timeExtrapd = linspace(0,1.55e+9 - timeOfPizza,40);

% coefficient derived from curve fitting tool, i.e.:
    % y(x)=4.1e-03*exp(b*x)
b = 5.938e-08; % 5.938e-08

pizzaExpFun = 4.1e-03*exp(b*timeFromPizza);
pizzaExpFunFut = 4.1e-03*exp(b*timeExtrapd);

% Plot daily price chart
figure(2)
hold on
grid on

set(gca, 'YScale', 'log');
%ylim([0.01 1e+5]);
xlim([0 1.55e+9 - timeOfPizza]);
ax = gca;
ax.YAxis.Exponent = 3;

plot(timeFromPizza,price);
plot(timeFromPizza,pizzaExpFun,'r');
plot(0, 4.1e-03, 'bs')
plot(timeExtrapd,pizzaExpFunFut,'r--');

title('Figure 2. Daily averaged btcusd trading price, logarithmic scale')
xlabel('Time since 10,000BTC pizza, sec')
ylabel('Bitcoin price, USD/BTC')
legend('Daily averaged Bitstamp trades','Constrained exponential fit to 13-Feb-2018','10,000BTC pizza');
end