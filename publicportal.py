from datetime import datetime


def parse_date_publicportal(date):
    return datetime.datetime.strptime(date, '%d-%m-%y').strftime('%m-%d-%y')


def insert_tender_id_into_xpath(xpath_to_change, tender_id):
    return xpath_to_change.format(tender_id)


def prune_amount(string):
    return round(float(string.replace(' ', '')), 2)
