# -*- coding: utf-8 -*-

from datetime import datetime, timedelta


def parse_date_publicportal(date_str):
    return ' '.join([date_str.split(' ')[1], date_str.split(' ')[-1]])


def subtract_from_time(date_time, subtr_min, subtr_sec):
    sub = (datetime.strptime(date_time, "%d.%m.%Y %H:%M") - timedelta(minutes=int(subtr_min), seconds=int(subtr_sec)))
    return sub.isoformat()


def insert_tender_id_into_xpath(xpath_to_change, tender_id):
    return xpath_to_change.format(tender_id)


def adapt_tender_data(tender_data):
        sum_for_value, sum_for_minimal_step = 0, 0
        for lot in tender_data['data'].get('lots', []):
            lot['value']['amount'] = int(lot['value']['amount'])
            sum_for_value += lot['value']['amount']
            lot['minimalStep']['amount'] = int(lot['minimalStep']['amount'])
            sum_for_minimal_step += lot['minimalStep']['amount']
        tender_data['data']['minimalStep']['amount'] = sum_for_minimal_step if sum_for_minimal_step != 0 else int(
            tender_data['data']['minimalStep']['amount'])
        tender_data['data']['value']['amount'] = sum_for_value if sum_for_value != 0 else int(
            tender_data['data']['value']['amount'])
        return tender_data


def get_only_numbers(given_string):
    numbers = int(u''.join([s for s in given_string.split() if s.isdigit()]))
    return numbers

