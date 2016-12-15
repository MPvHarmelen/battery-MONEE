#! /usr/bin/env python3
import re
import math
from collections import defaultdict

ITERATIONS = 1000000
BIN_SIZE = 1000
OUTPUT_FILE = 'inseminations'

TEST = "EggHatched: (1711; 288.165; 385.484); [[0, 0.25, 180], [0, 1, 134], "\
    "[0, 1.75, 160]]; Winner: 134"
BIGGER_TEST = """
PuckTaken: (928;0;341;466)
EggHatched: (1702; 215; 555); [[0, 0.25, 158], [0, 0.4, 114], [0, 0.55, 123], [0, 0.7, 138], [0, 0.85, 174], [0, 1, 107], [0, 1.15, 169], [0, 1.3, 161], [0, 1.45, 152], [0, 1.6, 139], [0, 1.75, 145]]; Winner: 158
EggHatched: (1712; 260; 510); [[0, 0.25, 119], [0, 0.55, 112], [0, 0.85, 186], [0, 1.15, 160], [0, 1.45, 168], [0, 1.75, 194]]; Winner: 194
EggHatched: (1723; 233.138; 487.024); [[0, 0.25, 173], [0, 0.4375, 198], [0, 0.625, 115], [0, 0.8125, 178], [0, 1, 103], [0, 1.1875, 121], [0, 1.375, 184], [0, 1.5625, 108], [0, 1.75, 140]]; Winner: 108
EggHatched: (1724; 245; 585); [[0, 0.25, 139], [0, 0.386364, 131], [0, 0.522727, 126], [0, 0.659091, 195], [0, 0.795455, 123], [0, 0.931818, 104], [0, 1.06818, 149], [0, 1.20455, 143], [0, 1.34091, 138], [0, 1.47727, 117], [0, 1.61364, 166], [0, 1.75, 158]]; Winner: 123
EggHatched: (1726; 175.643; 611.569); [[0, 0.25, 137], [0, 1.75, 159]]; Winner: 159
"""

INSEM_EXP = re.compile(r'EggHatched: \((\d+);.*\[(\[.*\](, )?)+\]; Winner: .*')


def insems_in_line(line, insems=0, iteration=None):
    match = INSEM_EXP.match(line)
    if match is not None:
        iteration = int(match.group(1))
        insems = match.group(2).count('[')
    return (iteration, insems) if iteration else None


def binned_insems_in_iterable(iterable, bin_size):
    """
    We can misuse the fact the items for in the bins are in order
    """
    # Two generators to avoid calling `insems_in_line` twice
    result = []
    current_bin, current_total = 0, 0
    for line in iterable:
        itinsems = insems_in_line(line)
        if itinsems is not None:
            if itinsems[0] // bin_size == current_bin:
                current_total += itinsems[1]
            else:
                result.append((current_bin * bin_size, current_total))
                while itinsems[0] // bin_size > current_bin:
                    current_bin += 1
                if itinsems[0] // bin_size != current_bin:
                    raise ValueError("Bins? it: {}, bin: {}".format(
                        itinsems[0], current_bin
                    ))
                current_total = itinsems[1]
    result.append((current_bin * bin_size, current_total))
    return defaultdict(lambda: 0, result)


def insems_many_files(files, iterations, bin_size):
    n_bins = math.ceil(iterations / bin_size)
    result = [[] for _ in range(n_bins)]
    for file in files:
        print("Processing {}".format(file))
        with open(file) as filed:
            try:
                insems = binned_insems_in_iterable(filed, bin_size)
            except ValueError:
                raise ValueError("Corrupt file: {}".format(file))
        for i, l in enumerate(result):
            l.append(insems[i * bin_size])
    return result


def save_result(result, filename, bin_size):
    with open(filename, 'w') as fd:
        fd.writelines(
            str(i * bin_size) + '\t' + '\t'.join(str(x) for x in line) + '\n'
            for i, line in enumerate(result)
        )


if __name__ == '__main__':
    from sys import argv
    result = insems_many_files(argv[1:], ITERATIONS, BIN_SIZE)
    save_result(result, OUTPUT_FILE, BIN_SIZE)
