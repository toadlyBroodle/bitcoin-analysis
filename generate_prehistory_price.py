#! /usr/bin/python3

'''
    Generate dummy price data from first block mined to beginning of trading.
    Data will be used to increase accuracy of coefficients generated from curve fitting tool.
'''

import csv

sec_per_day = 60*60*24
mining_epoc = 1.23e+09
trading_start_time = 1.316e+09
time_diff = trading_start_time - mining_epoc
time_intervals = time_diff / sec_per_day
price_per_day = 1 / time_intervals
price = 0

with open('prehistory_price.csv', 'w') as ph:
    while mining_epoc < trading_start_time:
        price += price_per_day
        ph.write(str(mining_epoc) + ', {}\n'.format(price))
        mining_epoc +=  sec_per_day
