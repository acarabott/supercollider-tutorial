#!/usr/local/bin/python3

from pathlib import Path
import shutil



master = Path("./master/")
students = Path("./students/")
me = Path("./me/")


for p in [students, me]:
    print(80 * "-")

    if p.exists():
        shutil.rmtree(p.name)
        print("removed {}".format(p.name))

    p.mkdir(0o755)

    print(80 * "-")

    for scd in master.glob('*.scd'):
        new = p / scd.name
        new.touch(0o755)
        print("created {}".format(scd))

        with scd.open() as s, new.open('w') as n:
            in_nostudent = False
            for line in s:
                if '{begin nostudent}' in line:
                    in_nostudent = True
                elif '{end nostudent}' in line:
                    in_nostudent = False
                else:
                    if p is me or (p is students and not in_nostudent):
                        n.write(line)

            print("wrote {}".format(scd))
