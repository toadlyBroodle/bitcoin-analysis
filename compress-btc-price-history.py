#! /usr/bin/python3

import sys, signal, os
import csv
import datetime
from time import strftime
from requests import get
import gzip, io

def get_day(stamp):
    return datetime.datetime.fromtimestamp(int(stamp)).strftime('%d')

def get_month(stamp):
    return datetime.datetime.fromtimestamp(int(stamp)).strftime('%m')

def get_year(stamp):
    return datetime.datetime.fromtimestamp(int(stamp)).strftime('%Y')

def get_date_string(stamp):
    return datetime.datetime.fromtimestamp(int(stamp)).strftime('%Y, %m, %d, ')

def strip_decimals(floater):
    splitter = floater.split('.')
    return int(splitter[0])

def main(argv):

    local_csv_path = './bitstampUSD.csv'
    local_gz_path = './bitstampUSD.csv.gz'
    url = 'http://api.bitcoincharts.com/v1/csv/bitstampUSD.csv.gz'

    # catch SIGINTs and KeyboardInterrupts
    def signal_handler(signal, frame):
        print("Current job prematurely terminated: received KeyboardInterrupt kill signal.")
        #report_job_status()
        sys.exit(0)
    # set SIGNINT listener to catch kill signals
    signal.signal(signal.SIGINT, signal_handler)

    # download latest price history
    if not os.path.isfile(local_gz_path):
        print('Downloading latest bitstamp price history from bitcoincharts.com...')
        # open in binary mode
        with open(local_gz_path, "wb") as file:
            # get request
            response = get(url)
            # write to file
            file.write(response.content)

    # unzip and save csv
    if not os.path.isfile(local_csv_path):
        print('Unpacking downloaded file...')
        with gzip.open(local_gz_path, 'rb') as infile:
            with open(local_csv_path, 'wb') as outfile:
                for line in infile:
                    outfile.write(line)

    # load csv lines
    trades = None
    print('Reading in .csv file...')
    with open(local_csv_path, 'r') as f:
        trades = csv.reader(f.readlines(), dialect='excel', delimiter=',') # trade format: [unixtime, price, amount]

    line_num=0
    dc=1
    pastday=None
    avg_day_price=0
    wc=1
    avg_week_price=0

    print('Processing price history into daily and weekly average prices...')
    for row in trades:
        day = get_day(row[0])

        if day == pastday:
            avg_day_price += strip_decimals(row[1])
        else:
            day_avg = int(avg_day_price / dc)

            with open('btcusd-avg-day-price.csv', 'a') as compressed_csv: # [unixtime, avg_day_price]
                # spit out entire table
                compressed_csv.write(row[0] + ', {}\n'.format(str(day_avg)))
            #with open('X_File.txt', 'a') as compressed_dates:
                # just dates
                #compressed_dates.write(row[0] + '\n')
            #\n\n\nwith open('Y_File.txt', 'a') as compressed_prices:
                # just prices
                #compressed_prices.write(row[1] + '\n')

            avg_week_price += day_avg
            if wc == 7:
                avg_week_price = strip_decimals(str(avg_week_price / 7))
                # spit out avg weekly data points
                with open('btcusd-avg-week-price.csv', 'a') as compressed_csv: # [unixtime, avg_week_price]
                    compressed_csv.write(row[0] + ', {}\n'.format(avg_week_price))

                wc=1

            wc+=1
            avg_day_price = 0
            dc=1

        pastday = day
        line_num+=1
        dc+=1

    print('Finished compressing bitstamp BTC prices into daily and weekly averages')

# so main() isn't executed if file is imported
if __name__ == "__main__":
    # remove first script name argument
    main(sys.argv[1:])