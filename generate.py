#!/usr/local/bin/python3

from pathlib import Path
import shutil



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
                if '{begin nostudent}' in line:
                    in_nostudent = True

                    if p is me:
                        n.write('//' + '=' * 10 + ' ')
                        n.write(line)
                elif '{end nostudent}' in line:
                    in_nostudent = False

                    if p is me:
                        n.write('//' + '-' * 10 + ' ')
                        n.write(line)
                else:
                    if p is me or (p is students and not in_nostudent):
                        n.write(line)

        print("created {}".format(new))
