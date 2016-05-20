from datetime import datetime, timedelta
from random import choice, seed
from urllib2 import urlopen
import time

LETTERS = ['A', 'B', 'C', 'D', 'E', 'F']
NUMBERS = list(range(1000))

PROTOCOL = 'http://'
DOMAIN = 'dev.prozorro.org'
PORT = '8080'

seconds = int(time.time())
seed(seconds)


def trigger_search_sync_dev_prozorro():
    # sync_url = 'https://market.zakupkipro.com/sync_es_stuff'
    sync_url = '%s%s:%s/sync_es_stuff' % (PROTOCOL, DOMAIN, PORT)
    resp = urlopen(sync_url)
    return '__SYNC_TRIGGERED__'