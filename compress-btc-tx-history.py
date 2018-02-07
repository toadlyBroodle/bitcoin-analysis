#! /usr/bin/python3

import sys, signal, os
import csv
import datetime
from time import strftime, mktime

def get_posix_timestamp(timestr): # input format: YYYY-mm-ddThh:mm:ssZ
    d = datetime.datetime.strptime(timestr, "%Y-%m-%dT%H:%M:%S.%fZ")
    return mktime(d.timetuple())

def get_day(line):
    stamp = get_posix_timestamp(line)
    return datetime.datetime.fromtimestamp(int(stamp)).strftime('%d')

def main(argv):
    '''
        Compress previously exported (from http://satoshi.info) transaction count historical data
        by calculating daily averages.
    '''

    local_csv_path = './utxo_count_history.csv'

    # load csv lines
    tx_counts = None
    print('Reading in .csv file...')
    with open(local_csv_path, 'r') as f:
        tx_counts = csv.reader(f.readlines(), dialect='excel', delimiter=';') # tx format: [tx, time, count]

    wc=1
    avg_week_tx=0

    print('Processing tx count history into daily and weekly average counts...')
    for row in tx_counts:

        time_stamp = str(int(get_posix_timestamp(row[1])))
        txs_int = int(float(row[2]))

        with open('utxo-day-count.csv', 'a') as compressed_csv: # [unixtime, avg_day_tx_count]
            # spit out avg daily data points
            compressed_csv.write(time_stamp + ', {}\n'.format(txs_int))

        avg_week_tx += txs_int

        if wc == 7:
            avg_week_tx = int(avg_week_tx / 7)
            # spit out avg weekly data points
            with open('utxo-avg-week-count.csv', 'a') as compressed_csv: # [unixtime, avg_week_price]
                compressed_csv.write(time_stamp + ', {}\n'.format(avg_week_tx))

            wc=1
            avg_week_tx=0

        wc+=1

    print('Finished compressing bitstamp BTC prices into daily and weekly averages')

# so main() isn't executed if file is imported
if __name__ == "__main__":
    # remove first script name argument
    main(sys.argv[1:])