def create_xpath(xpath, variable):
    return xpath.format(variable)


def prune_amount(str):
    return round(int(''.join([s for s in str.split() if s.isdigit()])))

