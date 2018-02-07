Various scripts and data used to analyze the Bitcoin blockchain, network, and protocol.

_Bitcoin price history_
 - *compress-btc-price-history.py*
   - Description: request Bitstamp trading history and process data into averaged daily and weekly price history data sets.
   - download updated trading history
     - source url: http://api.bitcoincharts.com/v1/csv/bitstampUSD.csv.gz
     - unzip bitstampUSD.csv.gz -> bitstampUSD.csv
   - process bitstampUSD.csv 
     - spit out average daily price history -> btcusd-avg-day-price.csv
     - spit out average weekly price history -> btcusd-avg-week-price.csv
 - *plotPriceChart.m*
   - Description: Matlab function that plots above data sets along with exponential fitted curves from three subsets of price data.
     - Note: must manually import .csv files into Matlab tables to feed into function
     - input arguments: price table, log scale y-axis (boolean)

_Bitcoin transaction and UTXO histories_
 - *compress-btc-tx-history.py*
   - Description: compress previously exported transaction and utxo count historical data by calculating daily and weekly averages.
   - Note: must manually download transaction and utxo data from http://satoshi.info
     - respective files: tx_count_history.csv, utxo_count_history.csv
   - script processes above files and spits out daily and weekly averaged counts
     - respective tx files: tx-day-count.csv, tx-week-count.csv
     - restpecive utxo files: utxo-day-count.csv, utxo-avg-week-count.csv
 - *plotTxChart.m*
   - Description: Matlab function that plots above data sets along with respective exponential fitted curves.
     - Note: must manually import .csv files into Matlab tables to feed into function
     - input arguments: tx table, utxo table, log scale y-axis (boolean)
 - *generate_prehistory_price.py*
   - Description: populates .csv file with dummy price data from mining of first block to beginning of Bitstamp trading history.
     - This dummy data can be useful for improved curve fitting accuracy.
