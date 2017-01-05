"""
Author: Martin van Harmelen <Martin@vanharmelen.com>

This file reads a text file consisting of the terminal output of RoboRobo and
writes a number of files:
 - depletion time per bin
 - Something with fishers test (to-do)
 - number inseminations per bin (to-do)
"""

import re

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


def eggs(input_list):
    """
    Parse a list of lines
    output a list:
    id >>> [iteration, depletiontime, n_descendants, n_pucks, distance]
    or
    id >>> [iteration, depletiontime, n_descendants]
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

    return output


if __name__ == '__main__':
    INFILE = '/home/martin/Documents/repos/battery-MONEE/RoboRobo/depletionLogs/level1000seed123-run16.txt'
    with open(INFILE) as file:
        all_eggs = eggs(file.readlines())
    print(len(all_eggs))
    print(len([x for x in all_eggs if len(x) > 3]))
    print()
    print(len([x for x in all_eggs if x[2] > 0]))
    print(len([x for x in all_eggs if x[2] > 1]))
    print(len([x for x in all_eggs if x[2] > 2]))
    print(len([x for x in all_eggs if x[2] > 3]))
    print(len([x for x in all_eggs if x[2] > 4]))
