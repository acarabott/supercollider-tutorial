#!/usr/local/bin/python3

from pathlib import Path
import shutil

BEGIN = '{begin nostudent}'
END = '{end nostudent}'
PREFIX = "// "
BEGIN_MARKER = PREFIX + (80 - (len(PREFIX + BEGIN))) * '`' + BEGIN + '\n'
END_MARKER = PREFIX + (80 - len(PREFIX + END)) * '-' + END + '\n'

master = Path("./master/")
students = Path("./students/")
me = Path("./me/")




for p in [students, me]:
    print(80 * "-")

    # delete old dirs
    if p.exists():
        shutil.rmtree(p.name)
        print("removed {}".format(p.name))

    # create new dirs, no scd files
    def ignore_scd(dir, files):
        res = [f for f in files if Path(f).suffix == '.scd']
        return res

    shutil.copytree(master.name, p.name, ignore=ignore_scd)
    print(80 * "-")

# create new .scd files, without nostudent blocks
for scd in master.glob('**/*.scd'):
    for p in [students, me]:
        new = p / '/'.join(scd.parts[1:])
        new.touch(0o755)

        with scd.open() as s, new.open('w') as n:
            in_nostudent = False
            for line in s:
                if BEGIN in line:
                    in_nostudent = True

                    if p is me:
                        n.write(BEGIN_MARKER)
                elif END in line:
                    in_nostudent = False

                    if p is me:
                        n.write(END_MARKER)
                else:
                    if p is me or (p is students and not in_nostudent):
                        n.write(line)

        print("created {}".format(new))
