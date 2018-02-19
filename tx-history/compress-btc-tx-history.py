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

def get_output_path(path, append):
    sections = path.split('.')
    return sections[0] + append + '.csv'

def main(argv):
    '''
        Compress previously exported (from http://statoshi.info) transaction count historical data
        by calculating daily averages.
    '''

    path = argv[0]

    # load csv lines
    tx_counts = None
    print('Reading in .csv file...')
    with open(path, 'r') as f:
        tx_counts = csv.reader(f.readlines(), dialect='excel', delimiter=';') # tx format: [tx, time, count]

    day_path = get_output_path(path, '-day-avg')
    week_path = get_output_path(path, '-week-avg')

    # delete old output files, so they are not appended to
    if os.path.isfile(day_path):
        os.remove(day_path)
    if os.path.isfile(week_path):
        os.remove(week_path)

    wc=1
    avg_week_tx=0

    print('Processing tx count history into daily and weekly average counts...')
    for row in tx_counts:

        try:
            time_stamp = str(int(get_posix_timestamp(row[1])))
            txs_int = float(row[2])
        except ValueError as e:
            print("Caught error: " + str(e))
            continue

        with open(day_path, 'a') as compressed_csv: # [unixtime, avg_day_tx_count]
            # spit out avg daily data points
            compressed_csv.write(time_stamp + ', {}\n'.format(txs_int))

        avg_week_tx += txs_int

        if wc == 7:
            avg_week_tx = avg_week_tx / 7
            # spit out avg weekly data points
            with open(week_path, 'a') as compressed_csv: # [unixtime, avg_week_price]
                compressed_csv.write(time_stamp + ', {}\n'.format(avg_week_tx))

            wc=1
            avg_week_tx=0

        wc+=1

    print('Finished compressing transaction counts into daily and weekly averages.')

# so main() isn't executed if file is imported
if __name__ == "__main__":
    # remove first script name argument
    main(sys.argv[1:])