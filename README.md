Various scripts and data used to analyze the Bitcoin blockchain, network, protocol, and economics.

## Bitcoin price history

 - _compress-btc-price-history.py_
   - Description: request Bitstamp trading history and process data into averaged daily and weekly price history data sets.
   - download updated trading history
     - source url: http://api.bitcoincharts.com/v1/csv/bitstampUSD.csv.gz
     - unzip bitstampUSD.csv.gz -> bitstampUSD.csv
   - process bitstampUSD.csv
     - spit out average daily/weekly price history -> _btcusd-avg-[day/week]-price.csv_

 - _plotPriceChart.m_
   - Description: Matlab function that plots above data sets along with exponential fitted curves from three subsets of price data.
     - Note: must manually import .csv files into Matlab tables to feed into function and change daily/weekly title strings
     - Input argument: daily/weekly price array imported from _btcusd-avg-price.csv_ file

## Bitcoin transaction and UTXO histories

 - _compress-oxt-blockchain-history.py_
   - Description: compress previously exported blockchain metrics historical data by calculating daily and weekly averages.
   - Note: must manually download metrics .csv data from http://oxt.me
   - Script processes downloaded metric files and spits out daily and weekly averaged _stats[METRIC].csv_ files

 - _plotBlockchainStats.m_
   - Description: Matlab function that plots above data sets along with respective exponential fitted curves.
     - Note: must manually import .csv files into Matlab tables to feed into function and uncomment only relevant title strings
     - Input argument: relevant metric array imported from daily/weekly averaged _stats[METRIC].csv_ files

## Generated Figures

![BTC price history full, unconstrained, daily, exp1 and poly1 fits](https://github.com/toadlyBroodle/bitcoin-analysis/blob/master/figs/Jun30/bitstamp-btcusd-trading-price-full-week-exp1-poly1-fits.png)
![blockchain stats: fees](https://github.com/toadlyBroodle/bitcoin-analysis/blob/master/figs/Jun30/blkchn-stats-fees-exp1-poly1-fits.png)
![top tech stock price poly1 fits](https://github.com/toadlyBroodle/bitcoin-analysis/blob/master/figs/Mar22/top-corp-tech-stock-prices-week-fits.png)
![telecoms penetration expl1, poly1 fits](https://github.com/toadlyBroodle/bitcoin-analysis/blob/master/figs/Mar22/world-bank-development-indicators-telecoms-penetration-exp1-poly1-fit.png)
