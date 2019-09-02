#!/bin/python

# load input files
aliases = open('/home/adam/.bin/aliases', 'r')

lf = ''
bash = ''

# append aliases
for a in aliases.readlines():
    if(len(a.split()) < 3):
        lf += 'map b' + a.split()[0] + ' cd ' + a.split()[1] + '\n'
        bash += 'alias b' + a.split()[0] + \
            '=\'cd ' + a.split()[1] + '\'' + '\n'
    else:
        lf += 'map b' + a.split()[0] + ' cd ' + a.split()[1] + '\n'
        lf += 'map e' + \
            a.split()[0] + ' :cd ' + a.split()[1] + \
            '; $$EDITOR ' + a.split()[2] + '\n'
        bash += 'alias b' + a.split()[0] + \
            '=\'cd ' + a.split()[1] + '\'' + '\n'
        bash += 'alias e' + \
            a.split()[0] + '=\'cd ' + a.split()[1] + \
            ' && ' + '$EDITOR ' + a.split()[2] + '\'' + '\n'

print(lf)
print(bash)

lf_out = open('/home/adam/.config/lf/lf_bookmarks', 'w')
bash_out = open('/home/adam/.bash_bookmarks', 'w')

lf_out.write(lf)
bash_out.write(bash)
