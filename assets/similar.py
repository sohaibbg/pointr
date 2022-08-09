import json
import re
from fuzzywuzzy import fuzz
from fuzzywuzzy import process

f = open('assets/stopList.json')
stopList = json.load(f)

comparator = fuzz.ratio
upweight_pattern = r'\d+'
downweight_factor = 0.01
downweight_terms = ['road', 'chowrangi', 'street', 'shahrah', 'mills', 
                    'shaheed', 'hotel', 'cinema',
                    ' no.', 'colony', 'plaza', 'town', 'khayaban',
                    'square', 'block', 'sector', 'society', 'station',
                    'police', 'gulshan', '-e-', '.', 'abad', 'goth',
                    'hospital', 'chowk', 'market', ]


def nonmatching_numbers(s1, s2):
    m1 = re.findall(upweight_pattern, s1)
    m2 = re.findall(upweight_pattern, s2)
    matches = [element for element in m1 if element not in m2] + \
        [element for element in m2 if element not in m1]
    return matches


def matching_weights(s1, s2):
    matches = []
    for term in downweight_terms:
        if term in s1 and term in s2:
            matches.append(term)
    return matches


def acc_without_terms(s1, s2, l):
    # calculate accuracy for string similarity without matching terms
    if bool(l):
        for term in l:
            s1 = s1.replace(term, '')
            s2 = s2.replace(term, '')
        return comparator(s1, s2)
    else:
        return 0


def find_dups(l):
    def acc_compare(a):
        return a['acc']

    def weighted_acc(s1, s2):
        acc = comparator(s1, s2)
        downweight_acc = acc_without_terms(
            s1, s2, downweight_terms)
        if bool(nonmatching_numbers(s1, s2)):
            return 0
        if bool(downweight_acc):
            return (acc + ((1/downweight_factor)-1)*downweight_acc) / (1 + ((1/downweight_factor)-1))
        else:
            return acc

    res = []
    for i, s1 in enumerate(l):
        for s2 in l[i+1:]:
            acc = weighted_acc(s1.lower(), s2.lower())
            if acc > 60:
                res.append(
                    {'s1': s1, 's2': s2, 'acc': acc}
                )
        print('\r', 100*i/len(l), end='', flush=True)
    res.sort(key=acc_compare, reverse=True)
    return res


dups = find_dups(stopList)
with open('assets/dups.json', 'w') as f:
    json.dump(dups, f)
