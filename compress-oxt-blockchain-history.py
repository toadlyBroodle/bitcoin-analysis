#! /usr/bin/python3

import sys, signal, os
import csv
import datetime
from time import strftime, mktime

def get_posix_timestamp(timestr): # input format: YYYY-mm-ddThh:mm:ssZ
    d = datetime.datetime.strptime(timestr, "%d/%m/%Y")
    return mktime(d.timetuple())

def main(argv):
    '''
        Format daily and calculate weekly averages of daily blockchain statistics, previously exported from http://oxt.me.
    '''

    file_names = ['stats_bdd','stats_blocksize','stats_nb_total_addr','stats_nb_tx','stats_nb_utxo','stats_new_addr','stats_nb_payments','stats_fee','stats_vlm_out']

    for daily_file_name in file_names:
        print('Reading in {}...'.format(daily_file_name))

        # load csv lines
        daily_stats = None
        with open('data/{}.csv'.format(daily_file_name), 'r') as f:
            daily_stats = csv.reader(f.readlines(), dialect='excel', delimiter=',') # tx format: [tx, time, count]

        day_path = 'data/day/{}.csv'.format(daily_file_name)
        week_path = 'data/week/{}.csv'.format(daily_file_name)

        # don't append to old files
        if os.path.isfile(day_path):
            os.remove(day_path)
        if os.path.isfile(week_path):
            os.remove(week_path)

        wc=1
        avg_week_tx=0

        print('Processing {} into weekly averages...'.format(daily_file_name))
        for row in daily_stats:

            try:
                time_stamp = str(int(get_posix_timestamp(row[0])))
                stat = float(row[1])
            except ValueError as e:
                print("Caught error: " + str(e))
                continue

            # omit 0s so as not to calculate undefined ln(0)
            if stat == 0:
                continue

            with open(day_path, 'a') as compressed_csv: # [unixtime, avg_day_tx_count]
                # spit out avg daily data points
                compressed_csv.write(time_stamp + ', {}\n'.format(stat))

            avg_week_tx += stat

            if wc == 7:
                avg_week_tx = avg_week_tx / 7
                # spit out avg weekly data points
                with open(week_path, 'a') as compressed_csv: # [unixtime, avg_week_price]
                    compressed_csv.write(time_stamp + ', {}\n'.format(avg_week_tx))

                wc=1
                avg_week_tx=0

            wc+=1

        print('Finished {} calculating weekly averages.'.format(daily_file_name))

# so main() isn't executed if file is imported
if __name__ == "__main__":
    # remove first script name argument
    main(sys.argv[1:])