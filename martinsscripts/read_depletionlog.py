"""
Author: Martin van Harmelen <Martin@vanharmelen.com>

This file reads a text file consisting of the terminal output of RoboRobo and
writes a number of files:
 - depletion time per bin
 - Something with fishers test (to-do)
 - number inseminations per bin (to-do)
"""

import re
import math
from collections import defaultdict

BIN_SIZE = 5000


NO_DEP_ITERATION = 0
INIT_ITERATION = 1
GATHERED_RE = re.compile(r'\[gathered\] (?P<iteration>\d+) (?P<prev_id>-?\d+) (?P<n_pucks>-?(\d+|nan)) ?(?P<distance>\d+\.\d+)?$')
DESCENDANT_RE = re.compile(r'\[descendant\] (?P<iteration>\d+) (?P<win_id>\d+) (?P<new_id>\d+)$')
DEPLETION_RE = re.compile(r'Depletion time: (-?\d+)$')

# def get_dep_time(string):
#     return int(string[16:])


def first_match(iterator, regex):
    """Find the first matching element of an iterator"""
    # I do not want to use re.fullmatch
    match = regex.match(next(iterator))
    while match is None:
        match = regex.match(next(iterator))
    return match


def parse(input_list):
    """
    Parse a list of lines
    output a list:
    id >>> [iteration, depletiontime, n_descendants, n_pucks, distance]
    or
    id >>> [iteration, depletiontime, n_descendants]

    and the highest iteration
    """
    # Create a list with enough space for all ids by using the last id
    output = [None] * (1 + int(first_match(
        reversed(input_list), DESCENDANT_RE
    ).groupdict()['new_id']))

    # Iterate over all lines
    # Finds the first line to match GATHERED_RE or stops at StopIteration, then
    # forces the next two lines to match DESCENDANT_RE and DEPLETION_RE
    # respectively.
    iterator = iter(input_list)
    while True:
        try:
            gadic = first_match(iterator, GATHERED_RE).groupdict()
        except StopIteration:
            break
        dedic = DESCENDANT_RE.match(next(iterator)).groupdict()
        assert dedic['iteration'] == gadic['iteration']
        iteration = int(dedic['iteration'])

        # Entries before NO_DEP_ITERATION don't print depletion time
        dep_time = None
        if iteration > NO_DEP_ITERATION:
            dep_time = int(DEPLETION_RE.match(next(iterator)).groups()[0])

        # Save new data
        output[int(dedic['new_id'])] = [
            iteration,
            dep_time,
            0
        ]

        # Save died data
        prev_id = int(gadic['prev_id'])
        if -1 < prev_id < len(output):
            output[prev_id] += [
                int(gadic['n_pucks']),
                float(gadic['distance'] or 0)
            ]

        # Entries before INIT_ITERATION don't have existing ancestors
        if iteration > INIT_ITERATION:
            # Save winner
            win_id = int(dedic['win_id'])
            if win_id < len(output):
                output[win_id][2] += 1

    return output, iteration


def clean_parsed(parsed):
    return [l for l in parsed if l[1] is not None]


def fishers_test(square):
    """Calculate Fisher's exact test"""
    a = square[0][0]
    b = square[0][1]
    c = square[1][0]
    d = square[1][1]

    f = math.factorial
    return (f(a + b) * f(c + d) * f(a + c) * f(b + d)) / \
        (f(a) * f(b) * f(c) * f(d) * f(a + b + c + d))


# def bin_data(data):
#     ...
#     # bin size
def binned_insems_in_iterable(iterable, bin_size):
    """
    We can misuse the fact the items for in the bins are in order
    """
    result = []
    current_bin, current_total = 0, []
    for line in iterable:
        if line[0] // bin_size == current_bin:
            current_total.append(line[1:])
        else:
            result.append((current_bin * bin_size, current_total))
            while line[0] // bin_size > current_bin:
                current_bin += 1
            if line[0] // bin_size != current_bin:
                raise ValueError("Bins? it: {}, bin: {}".format(
                    line[0], current_bin
                ))
            current_total = [line[1:]]
    result.append((current_bin * bin_size, current_total))
    return defaultdict(lambda: [], result)


def fisher_on_bins(bin_dict, *args, **kwargs):
    return {
        binn: fishers_test(classify_data(values, *args, **kwargs))
        for binn, values in bin_dict.items()
    }


def quartiles(list):
    ...
    # From: http://www.wikiwand.com/en/Quartile#Method_3
    # Method 3

    # If there are an even number of data points, then Method 3 is the same as
    # either method above since the median is no single datum.

    # If there are (4n+1) data points, then the lower quartile is 25% of the
    # nth data value plus 75% of the (n+1)th data value; the upper quartile is
    # 75% of the (3n+1)th data point plus 25% of the (3n+2)th data point.

    # If there are (4n+3) data points, then the lower quartile is 75% of the
    # (n+1)th data value plus 25% of the (n+2)th data value; the upper quartile
    # is 25% of the (3n+2)th data point plus 75% of the (3n+3)th data point.

    # This always gives the arithmetic mean of Methods 1 and 2; it ensures that
    # the median value is given its correct weight, and thus quartile values
    # change as smoothly as possible as additional data points are added.


def median(list_in):
    s = sorted(list_in)
    return (s[(len(s) - 1) // 2] + s[len(s) // 2]) / 2


def classify_data(data, first_index, second_index, first_cutoff=None,
                  second_cutoff=None):
    first = [d[first_index] for d in data]
    second = [d[second_index] for d in data]
    first_m = first_cutoff if first_cutoff is not None else median(first)
    second_m = second_cutoff if second_cutoff is not None else median(second)
    square = [[0, 0], [0, 0]]
    for felem, selem in zip(first, second):
        square[felem < first_m][selem < second_m] += 1

    return square

    # classes, higher than median v.s. lower than median: >> columns to choose
    #  - depletion time
    #  - pucks collected
    #  - distance travelled

    # Versus:
    #  - More than 0 offspring or 0 offspring


if __name__ == '__main__':
    # id >>> [iteration, depletiontime, n_descendants, n_pucks, distance]
    INFILE = '/home/martin/Documents/repos/battery-MONEE/RoboRobo/depletionLogs/level200seed123-run16.txt'
    with open(INFILE) as file:
        all_dna, iteration = parse(file.readlines())
    all_dna = clean_parsed(all_dna)
    print(iteration)
    binned = binned_insems_in_iterable(all_dna, BIN_SIZE)
    # for it, li in sorted(fisher_on_bins(binned, 1, -1, 1).items()):
    for it, li in sorted(binned.items()):
        square = classify_data(li, 1, -1, 1)
        val = fishers_test(square)
        # if val < 10 ** (-3):
        print(it, square, val, math.log(val, 10))
        # print(li)
    # for egg in clean_parsed(all_dna):
    #     if egg[1] is None:
    #         print(egg)
    # print(len(all_dna))
    # print(len([x for x in all_dna if len(x) > 3]))
    # print()
    # print(len([x for x in all_dna if x[2] > 0]))
    # print(len([x for x in all_dna if x[2] > 1]))
    # print(len([x for x in all_dna if x[2] > 2]))
    # print(len([x for x in all_dna if x[2] > 3]))
    # print(len([x for x in all_dna if x[2] > 4]))
