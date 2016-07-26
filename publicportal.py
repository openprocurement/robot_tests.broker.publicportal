from datetime import datetime


def parse_date_publicportal(date):
    return datetime.datetime.strptime(date, '%d-%m-%y').strftime('%m-%d-%y')


def create_xpath(xpath, tender_uaid):
    return xpath.format(tender_uaid)


def prune_amount(string):
    return round(float(string.replace(' ', '')), 2)
