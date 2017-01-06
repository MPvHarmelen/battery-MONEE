#! /usr/bin/env python3
"""
Author: Martin van Harmelen <Martin@vanharmelen.com>

This file reads a text file consisting of the terminal output of RoboRobo and
writes a number of files:
 - depletion time per bin (done)
 - Something with fishers test (done)
 - number inseminations per bin (impossible)
"""

import re
import math
import random
from collections import defaultdict

CHOICES = [
    'iteration',
    'depletion_time',
    'n_wins',
    'n_pucks',
    'distance',
]

NO_DEP_ITERATION = 0
INIT_ITERATION = 1
GATHERED_RE = re.compile(
    r'\[gathered\] (?P<iteration>\d+) (?P<prev_id>-?\d+) '
    r'(?P<n_pucks>-?(\d+|nan)) ?(?P<distance>\d+\.\d+)?$'
)
DESCENDANT_RE = re.compile(
    r'\[descendant\] (?P<iteration>\d+) '
    r'(?P<win_id>\d+) (?P<new_id>\d+)$'
)
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
    id >>> [iteration, depletion_time, n_wins, n_pucks, distance]
    or
    id >>> [iteration, depletion_time, n_wins]

    and the highest iteration
    """
    # Create a list with enough space for all ids by using the last id
    highest_match = first_match(
        reversed(input_list), DESCENDANT_RE
    )
    highest_id = int(highest_match.groupdict()['new_id'])
    output = [None] * (1 + highest_id)

    # Iterate over all lines
    # Finds the first line to match GATHERED_RE or stops at StopIteration, then
    # forces the next two lines to match DESCENDANT_RE and DEPLETION_RE
    # respectively.
    gatherrema = GATHERED_RE.match
    iterator = iter(input_list)
    while True:
        try:
            # Inlined first_match
            match = gatherrema(next(iterator))
            while match is None:
                match = gatherrema(next(iterator))

            gadic = match.groupdict()
        except StopIteration:
            break
        dedic = DESCENDANT_RE.match(next(iterator)).groupdict()
        assert dedic['iteration'] == gadic['iteration']
        iteration = int(dedic['iteration'])

        # Entries before NO_DEP_ITERATION don't print depletion time
        dep_time = None
        if iteration > NO_DEP_ITERATION:
            line = ''
            while not line:
                line = next(iterator).strip()
            dep_time = int(DEPLETION_RE.match(line).groups()[0])

        # Save new data
        output[int(dedic['new_id'])] = {
            'iteration': iteration,
            'depletion_time': dep_time,
            'n_wins': 0
        }

        # Save died data
        prev_id = int(gadic['prev_id'])
        if -1 < prev_id < len(output):
            output[prev_id].update(
                n_pucks=int(gadic['n_pucks']),
                distance=float(gadic['distance'] or 0)
            )

        # Entries before INIT_ITERATION don't have existing ancestors
        if iteration > INIT_ITERATION:
            # Save winner
            win_id = int(dedic['win_id'])
            if win_id < len(output):
                output[win_id]['n_wins'] += 1

    # return output, iteration
    return output


# def bin_data(data):
#     ...
#     # bin size
def bin_iterable(iterable, bin_size, bin_key):
    """
    We can misuse the fact the items for in the bins are in order
    """
    result = []
    current_bin, current_total = 0, []
    for line in iterable:
        bin_thing = line[bin_key]
        if bin_thing // bin_size == current_bin:
            current_total.append(line)
        else:
            result.append((current_bin * bin_size, current_total))
            while bin_thing // bin_size > current_bin:
                current_bin += 1
            if bin_thing // bin_size != current_bin:
                raise ValueError("Bins? it: {}, bin: {}".format(
                    bin_thing, current_bin
                ))
            current_total = [line]
    result.append((current_bin * bin_size, current_total))
    return defaultdict(list, result)


def quartiles(li):
    """Calculate the three quartile numbers"""
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
    li = sorted(li)
    lenl = len(li)
    if lenl % 2 == 0:
        return [
            median(li[:lenl // 2]),
            median(li),
            median(li[lenl // 2:])
        ]
    else:
        div = lenl // 4
        rem = lenl % 4
        return [
            (
                rem * li[div - (rem % 3)] + (4 - rem) * li[div + 1 - (rem % 3)]
            ) / 4,
            median(li),
            (
                (4 - rem) * li[3 * div + 1 - (rem % 3)]
                + rem * li[3 * div + 2 - (rem % 3)]
            ) / 4
        ]


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


def fishers_test(square):
    """Calculate Fisher's exact test"""
    a = square[0][0]
    b = square[0][1]
    c = square[1][0]
    d = square[1][1]

    f = math.factorial
    return (f(a + b) * f(c + d) * f(a + c) * f(b + d)) / \
        (f(a) * f(b) * f(c) * f(d) * f(a + b + c + d))


def fisher_on_bins(bin_dict, *args, **kwargs):
    return {
        binn: [fishers_test(classify_data(values, *args, **kwargs))]
        for binn, values in bin_dict.items()
    }


def clean_parsed(parsed, check_filled):
    return [
        l for l in parsed
        if check_filled in l and l[check_filled] is not None
    ]


def combined_parse_clean_bins(filenames, bin_size, bin_thing, clean_keys=None):
    clean_keys = clean_keys if clean_keys is not None else []
    total_bins = defaultdict(list)
    for file in filenames:
        print("Processing {}".format(file))
        with open(file) as fd:
            try:
                all_dna = parse(fd.readlines())
            except AttributeError:
                    raise ValueError("Corrupt file: {}".format(file))
            except StopIteration:
                    raise ValueError("Corrupt file: {}".format(file))
            except IndexError:
                    raise ValueError(
                        "Corrupt file, new_ids not sorted: {}".format(file)
                    )
        for key in clean_keys:
            all_dna = clean_parsed(all_dna, key)
        bins = bin_iterable(all_dna, bin_size, bin_thing)
        for binn, values in bins.items():
            total_bins[binn].extend(values)
    return total_bins


def output_dict(data, bin_size, filename, tab_size=4):

    ranel = random.choice(list(data.values()))
    maxes = [max(data) + bin_size] + [
        max(d[i] for d in data.values()) for i in range(len(ranel))
    ]
    maxi = maxes[0]

    ljusts = [len(str(m)) for m in maxes]
    ljusts = [ljust + tab_size - (ljust % tab_size) for ljust in ljusts]

    with open(filename, 'w') as fd:
        fd.writelines(
            "{}{}{}\n".format(
                str(i).ljust(ljusts[0]),
                ''.join(
                    str(d).ljust(ljusts[k + 1])
                    for k, d in enumerate(data[i][:-1])
                ),
                data[i][-1]
            )
            for i in range(0, maxi, bin_size)
        )


def column_quartiles(data, column):
    """
    Return lower quartile, median and upper quartile for given column per bin
    """
    return {
        key: quartiles(item[column] for item in binn)
        for key, binn in data.items()
    }


if __name__ == '__main__':
    from argparse import ArgumentParser
    parser = ArgumentParser()
    parser.add_argument('-b', '--bin_by', default=CHOICES[0], choices=CHOICES)
    parser.add_argument('-q', '--quartiles', nargs='+', choices=CHOICES,
                        default=[])
    parser.add_argument('-f', '--fisher', nargs='+', choices=CHOICES,
                        default=[],
                        help="Do Fisher's exact test with n_wins")
    parser.add_argument('output_basename')
    parser.add_argument('bin_size', type=int)
    parser.add_argument('input_file', nargs='+')
    args = parser.parse_args()

    binned = combined_parse_clean_bins(
        args.input_file,
        args.bin_size,
        args.bin_by,
        args.quartiles + args.fisher
    )

    for column in args.fisher:
        print("Calculating Fisher's exact test for {}".format(column))
        output_dict(
            fisher_on_bins(binned, 'n_wins', column, 1),
            args.bin_size,
            args.output_basename + '.{}.fisher'.format(column)
        )

    for column in args.quartiles:
        print("Calculating quartiles for {}".format(column))
        output_dict(
            column_quartiles(binned, column),
            args.bin_size,
            args.output_basename + '.{}.quartiles'.format(column)
        )
