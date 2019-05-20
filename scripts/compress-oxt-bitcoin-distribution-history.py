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

    file_names = ['stats_addr_bl_dist','stats_txo_vlm_dist']

    for daily_file_name in file_names:
        print('Reading in {}...'.format(daily_file_name))

        # load csv lines
        daily_stats = None
        with open('../data/{}.csv'.format(daily_file_name), 'r') as f:
            daily_stats = csv.reader(f.readlines(), dialect='excel', delimiter=',') # tx format: [tx, time, count]

        week_path = '../data/week/{}.csv'.format(daily_file_name)

        # don't append to old files
        if os.path.isfile(week_path):
            os.remove(week_path)

        wc=1
        avg_week_less=0
        avg_week_more=0

        print('Processing {} into weekly averages...'.format(daily_file_name))
        for row in daily_stats:

            day_tot_less = 0
            day_tot_more = 0
            try:
                time_stamp = str(int(get_posix_timestamp(row[0])))
                # sum values <1BTC
                for i in range(2, 11):
                    day_tot_less += float(row[i])
                # sum values >=1BTC
                for i in range(10, 19):
                    day_tot_more += float(row[i])
            except ValueError as e:
                print("Caught error: " + str(e))
                continue

            avg_week_less += day_tot_less
            avg_week_more += day_tot_more

            if wc == 7:
                avg_week_less = avg_week_less / 7
                avg_week_more = avg_week_more / 7
                # spit out avg weekly data points
                with open(week_path, 'a') as compressed_csv: # [unixtime, avg_week_price]
                    compressed_csv.write(time_stamp + ', {}, {}\n'.format(avg_week_less,avg_week_more))

                avg_week_less=0
                avg_week_more=0
                wc=0

            wc+=1

        print('Finished {} calculating weekly averages.'.format(daily_file_name))

# so main() isn't executed if file is imported
if __name__ == "__main__":
    # remove first script name argument
    main(sys.argv[1:])
