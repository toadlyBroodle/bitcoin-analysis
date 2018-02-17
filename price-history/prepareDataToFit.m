function [ output_args ] = prepareDataToFit( btcusdavgdayprice, prehistoryprice )
% 1) import btcusd-avg-day-price.csv into workspace as btcusdavgdayprice
% table.
% 2) create various arrays to fit data to
price = btcusdavgdayprice{:,2};
priceJul2017 = btcusdavgdayprice{1:2103,2};
priceNov2017 = btcusdavgdayprice{1:2226,2};
time = btcusdavgdayprice{:,1};
timeJul2017 = btcusdavgdayprice{1:2103,1};
timeNov2017 = btcusdavgdayprice{1:2226,1};

% 3) create array of combined prehistoryprice and avgdayprice
curvefitdata=outerjoin(prehistoryprice,btcusdavgdayprice,'MergeKeys', true);
curvefittime = curvefitdata{:,1};
curvefitprice = curvefitdata{:,2};

% 4) create array of normalized times where x=0 at 1.274e+9 unixtime
timeFromPizza(:,1) = time(:,1) - 1.274e+9;

end

