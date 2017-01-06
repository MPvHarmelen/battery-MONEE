#! /usr/bin/env python3

from read_depletionlog import quartiles


if __name__ == '__main__':
    import csv
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('input_file')
    parser.add_argument('output_file')
    parser.add_argument('-i', '--ignore_lines', type=int, default=0)
    parser.add_argument('-d', '--delimiter', default='\t')
    args = parser.parse_args()

    with open(args.input_file) as inf, open(args.output_file, 'w') as outf:
        for _ in range(args.ignore_lines):
            next(inf)
        outf.writelines(
            line[0] + '\t' + '\t'.join(
                str(f) for f in quartiles(int(s) for s in line[1:])
            ) + '\n'
            for line in csv.reader(
                inf,
                delimiter=args.delimiter,
                skipinitialspace=True
            )
        )
