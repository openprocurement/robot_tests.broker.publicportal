# -*- coding: utf-8 -*-

from datetime import datetime, timedelta


def parse_date_publicportal(str_date):
    split = str_date.split(' ')
    date = ' '.join([split[1], split[-1]])
    return date


def subtract_from_time(date_time, subtr_min, subtr_sec):
    sub = datetime.strptime(date_time, "%d.%m.%Y %H:%M")
    sub = (sub - timedelta(minutes=int(subtr_min),
                           seconds=int(subtr_sec))).isoformat()
    return sub


def insert_tender_id_into_xpath(xpath_to_change, tender_id):
    return xpath_to_change.format(tender_id)


def adapt_tender_data(tender_data):
    tender_data.data.value['amount'] = int(tender_data.data.value['amount'])
    tender_data.data['minimalStep']['amount'] = int(tender_data.data['minimalStep']['amount'])
    sum = 0
    for lot in tender_data.data.get('lots', []):
        lot['value']['amount'] = int(lot['value']['amount'])
        sum += lot['value']['amount']
        tender_data.data['value']['amount'] = sum
    lot['minimalStep']['amount'] = int(lot['minimalStep']['amount'])
    return tender_data


def get_only_numbers(given_string):
    numbers = int(u''.join([s for s in given_string.split() if s.isdigit()]))
    return numbers

