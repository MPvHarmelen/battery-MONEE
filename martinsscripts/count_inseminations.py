#! /usr/bin/env python3
import re
import math
from collections import defaultdict

USAGE = """
Usage:
{} output_file iterations bin_size input_file [input_file ...]

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
    from sys import argv, exit
    if len(argv) < 5:
        print(USAGE.format(argv[0]))
        exit(1)
    for arg in argv:
        if re.search(r'\bh(elp)?\b', arg):
            print(USAGE.format(argv[0]))
            exit(1)

    output_file = argv[1]
    iterations = int(argv[2])
    bin_size = int(argv[3])
    result = insems_many_files(argv[4:], iterations, bin_size)
    save_result(result, output_file, bin_size)
